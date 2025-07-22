/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import QtWebChannel

import org.kde.kirigami as Kirigami

import com.georgefb.rina

Page {
    id: root

    property url fileUrl

    header: ToolBar {
        enabled: root.fileUrl.toString() !== ""

        RowLayout {
            anchors.fill: parent
            Kirigami.SearchField {
                onAccepted: {
                    webView.findText(text)
                }
            }
            Item {
                Layout.fillWidth: true
            }
            ToolButton {
                icon.name: "zoom-out"
                onClicked: webView.zoomFactor -= 0.10
            }
            ToolButton {
                text: webView.zoomFactor.toFixed(2)
                onClicked: webView.zoomFactor = 1
            }
            ToolButton {
                icon.name: "zoom-in"
                onClicked: webView.zoomFactor += 0.10
            }
        }
    }

    WebEngineView {
        id: webView

        url: "qrc:/qt/qml/com/georgefb/rina/webview/index.html"
        anchors.fill: parent
        visible: root.fileUrl.toString() !== ""

        profile.offTheRecord: false
        profile.storageName: "com.georgefb.rina"

        zoomFactor:GeneralSettings.zoomFactor
        webChannel: mainWebChannel

        onNewWindowRequested: function(request) {
            Qt.openUrlExternally(request.requestedUrl)
        }

        onZoomFactorChanged: {
            GeneralSettings.zoomFactor = zoomFactor
            GeneralSettings.save()
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
                }
            }

            onIsEditorInitializedChanged: {
                // on startup, the editor is not initialized fast enough
                // to load the content in the onFileUrlChanged signal handler
                // so we load the content when the initialization is complete
                if (isEditorInitialized && fileUrl !== "") {
                    editorContent = Bridge.getFileContent(fileUrl)
                }
            }

            WebChannel.id: "htmlBridge"
        }
    }
}
