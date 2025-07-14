import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: root

    profile.offTheRecord: false
    profile.storageName: "com.georgefb.hana"

    onNewWindowRequested: function(request) {
        Qt.openUrlExternally(request.requestedUrl)
    }
}
