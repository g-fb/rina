import QtQuick
import QtQuick.Controls

import com.georgefb.rina

ItemDelegate {
    id: root

    required property int index
    required property url fileUrl
    required property string fileName

    text: fileName
    font.pointSize: 12
    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
    highlighted: ListView.view.currentIndex === index

    ContextMenu.menu: Menu {
        MenuItem {
            text: i18nc("@action:inmenu", "Open containing folder")
            icon.name: "folder"
            onClicked: {
                Bridge.highlightInFileManager(root.fileUrl)
            }
        }

        MenuItem {
            text: i18nc("@action:inmenu", "Rename file")
            icon.name: "edit-rename"
            onClicked: {
                Bridge.rename(root.fileUrl)
            }
        }

        MenuItem {
            text: i18nc("@action:inmenu", "Delete file")
            icon.name: "delete"
            onClicked: {
                Bridge.moveToTrash(root.fileUrl)
            }
        }
    }
}
