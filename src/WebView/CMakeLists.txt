#
# SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#

qt_add_library(webview STATIC)
qt_add_qml_module(webview
    URI com.georgefb.rina.webview
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/src/com/georgefb/rina/webview
    IMPORT_PATH ${CMAKE_BINARY_DIR}
    QML_FILES
        WebView.qml
    RESOURCES
        index.html
        assets/atom-one-dark.min.css
        assets/katex.min.css
        assets/quill.snow.css
        assets/highlight.min.js
        assets/katex.min.js
        assets/quill.js
)
