/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami

import com.georgefb.rina

Item {
    id: root

    signal fileSelected(fileUrl: url)

    FoldersModel {
        id: foldersModel

        dataFolder: GeneralSettings.dataFolder
    }

    FilesModel {
        id: filesModel

        parentFolder: SidebarSettings.lastFolder
    }

    SplitView {
        orientation: Qt.Horizontal
        anchors.fill: parent
        visible: GeneralSettings.dataFolder

        ListView {
            id: foldersView

            property int margin: 10

            model: foldersModel
            currentIndex: foldersModel.lastFolderIndex
            delegate: FolderDelegate {
                onClicked: {
                    ListView.view.currentIndex = index
                    filesModel.parentFolder = folderUrl
                    filesView.currentIndex = 0
                    SidebarSettings.lastFolder = folderUrl
                    SidebarSettings.save()
                }
            }

            header: ToolBar {
                width: parent.width
                ToolButton {
                    text: "Add folder"
                    width: parent.width
                    onClicked: {
                        const dialog = createFolderComponent.createObject() as Dialog
                        dialog.open()
                    }
                }
            }

            SplitView.fillHeight: true
            SplitView.preferredWidth: root.width * 0.5
        }

        ListView {
            id: filesView

            property int margin: 10

            model: filesModel
            currentIndex: filesModel.lastFileIndex
            delegate: FileDelegate {
                onClicked: {
                    ListView.view.currentIndex = index
                    Q_EMIT: root.fileSelected(fileUrl)
                    SidebarSettings.lastFile = fileUrl
                    SidebarSettings.save()
                }

                Component.onCompleted: {
                    if (index === ListView.view.currentIndex) {
                        Q_EMIT: root.fileSelected(fileUrl)
                    }
                }
            }
            onCountChanged: {
                if (count > 0) {
                    return
                }
                Q_EMIT: root.fileSelected("")
            }

            header: ToolBar {
                width: parent.width
                ToolButton {
                    text: "Add file"
                    width: parent.width
                    onClicked: {
                        const folderDelegate = foldersView.itemAtIndex(foldersView.currentIndex) as FolderDelegate
                        const object = {
                            parentUrl: folderDelegate.folderUrl
                        }

                        const dialog = createFileComponent.createObject(Overlay.overlay, object) as Dialog
                        dialog.open()
                    }
                }
            }

            SplitView.fillHeight: true
            SplitView.preferredWidth: root.width * 0.5
        }
    }

    Kirigami.PlaceholderMessage {
        anchors.fill: parent
        visible: !GeneralSettings.dataFolder
        helpfulAction: Kirigami.Action {
            icon.name: "list-add"
            text: "Select data folder"
            onTriggered: {
                folderDialog.open()
            }
        }
    }

    FolderDialog {
        id: folderDialog

        currentFolder: GeneralSettings.dataFolder || StandardPaths.writableLocation(StandardPaths.HomeLocation)
        title: qsTr("@title:window", "Select folder")

        onAccepted: {
            GeneralSettings.dataFolder = folderDialog.selectedFolder
            GeneralSettings.save()
        }
    }

    Component {
        id: createFolderComponent

        Dialog {
            id: createFolderDialog

            property bool folderExists: false

            title: i18nc("@title:window", "Add new folder")
            parent: root
            anchors.centerIn: parent
            width: Math.min(parent.width, 400)
            visible: true
            standardButtons: Dialog.Ok | Dialog.Cancel
            closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
            modal: true
            onAccepted: {
                if (folderNameField.text === "") {
                    return
                }

                Bridge.createFolder(`${GeneralSettings.dataFolder}/${folderNameField.text}`)
            }

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 100
                }
            }

            ColumnLayout {
                width: parent.width

                Label {
                    text: i18nc("@label", "Folder name")
                }

                TextField {
                    id: folderNameField

                    focus: true
                    onTextEdited: {
                        createFolderDialog.folderExists = Bridge.folderExists(`${GeneralSettings.dataFolder}/${folderNameField.text}`)
                        let okBtn = createFolderDialog.standardButton(Dialog.Ok)
                        okBtn.enabled = !createFolderDialog.folderExists
                    }
                    Keys.onReturnPressed: {
                        createFolderDialog.accept()
                    }
                    Keys.onEnterPressed: {
                        createFolderDialog.accept()
                    }
                }

                Kirigami.InlineMessage {
                    id: folderExistsMessage

                    text: i18nc("@info", `Folder already exists\n“%1”`,
                                `${GeneralSettings.dataFolder}/${folderNameField.text}`)
                    type: Kirigami.MessageType.Warning
                    visible: createFolderDialog.folderExists

                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    Layout.topMargin: Kirigami.Units.largeSpacing
                }
            }
        }
    }

    Component {
        id: createFileComponent

        Dialog {
            id: createFileDialog

            property url parentUrl
            property bool fileExists: false

            title: i18nc("@title:window", "Add new file")
            parent: root
            anchors.centerIn: parent
            width: Math.min(parent.width, 400)
            visible: true
            standardButtons: Dialog.Ok | Dialog.Cancel
            closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
            modal: true
            onAccepted: {
                if (fileNameField.text === "") {
                    return
                }

                Bridge.createFile(`${createFileDialog.parentUrl}/${fileNameField.text}`)
            }

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 100
                }
            }

            ColumnLayout {
                width: parent.width

                Label {
                    text: i18nc("@label", "File name")
                }

                TextField {
                    id: fileNameField

                    focus: true
                    onTextEdited: {
                        createFileDialog.fileExists = Bridge.fileExists(`${createFileDialog.parentUrl}/${fileNameField.text}`)
                        let okBtn = createFileDialog.standardButton(Dialog.Ok)
                        okBtn.enabled = !createFileDialog.fileExists
                    }
                    Keys.onReturnPressed: {
                        createFileDialog.accept()
                    }
                    Keys.onEnterPressed: {
                        createFileDialog.accept()
                    }
                }

                Kirigami.InlineMessage {
                    id: fileExistsMessage

                    text: i18nc("@info", `File already exists\n“%1”`,
                                `${GeneralSettings.dataFolder}/${fileNameField.text}`)
                    type: Kirigami.MessageType.Warning
                    visible: createFileDialog.fileExists

                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    Layout.topMargin: Kirigami.Units.largeSpacing
                }
            }
        }
    }
}
