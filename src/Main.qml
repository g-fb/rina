import QtQuick
import QtQuick.Controls

import com.georgefb.hana.sidebar

ApplicationWindow {
    id: appWindow

    width: 800
    height: 600
    minimumWidth: 400
    minimumHeight: 300
    visible: true

    title: qsTr("Hana")

    Page {
        anchors.fill: parent

        SplitView {
            orientation: Qt.Horizontal
            anchors.fill: parent

            Sidebar {
                SplitView.fillHeight: true
                SplitView.preferredWidth: appWindow.width * 0.25
            }
        }
    }
}
