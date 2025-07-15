pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
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
    }

    SplitView {
        orientation: Qt.Horizontal
        anchors.fill: parent

        ListView {
            property int margin: 10

            model: foldersModel
            currentIndex: 0
            leftMargin: margin
            topMargin: margin
            rightMargin: margin
            bottomMargin: margin
            delegate: ItemDelegate {
                required property int index
                required property url folderUrl
                required property string folderName

                text: folderName
                font.pointSize: 14
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                highlighted: ListView.view.currentIndex === index
                onClicked: {
                    ListView.view.currentIndex = index
                    filesModel.parentFolder = folderUrl
                }

                Component.onCompleted: {
                    if (index === 0) {
                        filesModel.parentFolder = folderUrl
                    }
                }
            }

            SplitView.fillHeight: true
            SplitView.preferredWidth: root.width * 0.5
        }

        ListView {
            property int margin: 10

            model: filesModel
            currentIndex: 0
            leftMargin: margin
            topMargin: margin
            rightMargin: margin
            bottomMargin: margin
            delegate: ItemDelegate {
                required property int index
                required property url fileUrl
                required property string fileName

                text: fileName
                font.pointSize: 12
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                highlighted: ListView.view.currentIndex === index
                onClicked: {
                    ListView.view.currentIndex = index
                    Q_EMIT: root.fileSelected(fileUrl)
                }

                Component.onCompleted: {
                    if (index === 0) {
                        Q_EMIT: root.fileSelected(fileUrl)
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
}
