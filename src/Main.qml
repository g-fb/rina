import QtQuick
import QtQuick.Controls

import org.kde.config as KConfig

import com.georgefb.rina.sidebar
import com.georgefb.rina.webview

ApplicationWindow {
    id: appWindow

    width: 800
    height: 600
    minimumWidth: 400
    minimumHeight: 300
    visible: true

    title: qsTr("Rina")

    KConfig.WindowStateSaver {
        configGroupName: "MainWindow"
    }

    Page {
        anchors.fill: parent

        SplitView {
            orientation: Qt.Horizontal
            anchors.fill: parent

            Sidebar {
                SplitView.fillHeight: true
                SplitView.preferredWidth: appWindow.width * 0.25

                onFileSelected: function(fileUrl) {
                    webView.fileUrl = fileUrl
                }
            }

            WebView {
                id: webView

                SplitView.fillHeight: true
                SplitView.fillWidth: appWindow.width * 0.75
            }
        }
    }
}
