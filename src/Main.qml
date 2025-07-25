/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import QtQuick
import QtQuick.Controls

import org.kde.config as KConfig

import com.georgefb.rina.sidebar
import com.georgefb.rina.webview

ApplicationWindow {
    id: appWindow

    width: 1000
    height: 600
    minimumWidth: 850
    minimumHeight: 500
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
                id: sidebar

                SplitView.fillHeight: true
                SplitView.preferredWidth: appWindow.width * 0.25
                SplitView.minimumWidth: 300
            }

            WebView {
                id: webView

                SplitView.fillHeight: true
                SplitView.fillWidth: appWindow.width * 0.75

                Connections {
                    target: sidebar
                    function onFileSelected(fileUrl) {
                        webView.fileUrl = fileUrl
                    }
                }
            }
        }
    }
}
