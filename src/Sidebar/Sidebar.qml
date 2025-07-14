import QtCore
import QtQuick
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami

import com.georgefb.hana

Item {
    id: root

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
