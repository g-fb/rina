import QtQuick
import QtQuick.Controls
import QtWebEngine
import QtWebChannel

WebEngineView {
    id: root

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

        property bool editorInitialized: false

        onEditorInitializedChanged: {
            console.log("ready")
        }
        WebChannel.id: "htmlBridge"
    }
}
