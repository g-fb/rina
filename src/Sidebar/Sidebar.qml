pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami

import com.georgefb.hana

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
            model: foldersModel
            delegate: ItemDelegate {
                required property url folderUrl
                required property string folderName

                text: folderName
                width: ListView.view.width
                onClicked: {
                    filesModel.parentFolder = folderUrl
                }
            }

            SplitView.fillHeight: true
            SplitView.preferredWidth: root.width * 0.5
        }

        ListView {
            model: filesModel
            delegate: ItemDelegate {
                required property url fileUrl
                required property string fileName

                text: fileName
                width: ListView.view.width
                onClicked: {
                    Q_EMIT: root.fileSelected(fileUrl)
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
