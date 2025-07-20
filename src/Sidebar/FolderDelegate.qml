import QtQuick
import QtQuick.Controls

import com.georgefb.rina

ItemDelegate {
    id: root

    required property int index
    required property url folderUrl
    required property string folderName

    text: folderName
    font.pointSize: 14
    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
    highlighted: ListView.view.currentIndex === index

    ContextMenu.menu: Menu {
        MenuItem {
            text: i18nc("@action:inmenu", "Open folder")
            icon.name: "folder"
            onClicked: {
                Qt.openUrlExternally(root.folderUrl)
            }
        }

        MenuItem {
            text: i18nc("@action:inmenu", "Open containing folder")
            icon.name: "folder"
            onClicked: {
                Bridge.highlightInFileManager(root.folderUrl)
            }
        }

        MenuItem {
            text: i18nc("@action:inmenu", "Delete folder")
            icon.name: "delete"
            onClicked: {
                Bridge.moveToTrash(root.folderUrl)
            }
        }
    }
}
