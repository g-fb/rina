import QtQuick
import QtQuick.Controls
import QtWebEngine
import QtWebChannel

import com.georgefb.hana

WebEngineView {
    id: root

    property url fileUrl

    url: "qrc:/qt/qml/com/georgefb/hana/webview/index.html"

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
        property bool editorInitialized: false

        function save(content: string) {
            Bridge.saveContentToFile(fileUrl, content)
        }

        onFileUrlChanged: {
            editorContent = Bridge.getFileContent(fileUrl)
        }

        WebChannel.id: "htmlBridge"
    }
}
