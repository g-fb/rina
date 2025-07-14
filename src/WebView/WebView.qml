import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import QtWebChannel

import org.kde.kirigami as Kirigami

import com.georgefb.hana

Page {
    id: root

    property url fileUrl

    header: ToolBar {
        RowLayout {
            Kirigami.SearchField {
                onAccepted: {
                    webView.findText(text)
                }
            }
        }
    }

    WebEngineView {
        id: webView

        url: "qrc:/qt/qml/com/georgefb/hana/webview/index.html"
        anchors.fill: parent

        profile.offTheRecord: false
        profile.storageName: "com.georgefb.hana"

        webChannel: mainWebChannel

        onNewWindowRequested: function(request) {
            Qt.openUrlExternally(request.requestedUrl)
        }

        WebChannel {
            id: mainWebChannel

            registeredObjects: [htmlBridge]
        }

        QtObject {
            id: htmlBridge

            property url fileUrl: root.fileUrl
            property string editorContent
            property bool isEditorInitialized: false

            function save(content: string) {
                Bridge.saveContentToFile(fileUrl, content)
            }

            onFileUrlChanged: {
                if (isEditorInitialized) {
                    editorContent = Bridge.getFileContent(fileUrl)
                } else {
                    editorInitTimer.start()
                }
            }

            WebChannel.id: "htmlBridge"
        }

        Timer {
            id: editorInitTimer

            running: false
            repeat: true
            interval: 50

            onTriggered: {
                if (htmlBridge.isEditorInitialized) {
                    editorInitTimer.stop()
                    htmlBridge.editorContent = Bridge.getFileContent(htmlBridge.fileUrl)
                }
            }
        }
    }
}
