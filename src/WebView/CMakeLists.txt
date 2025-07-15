
qt_add_library(webview STATIC)
qt_add_qml_module(webview
    URI com.georgefb.rina.webview
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/src/com/georgefb/rina/webview
    IMPORT_PATH ${CMAKE_BINARY_DIR}
    QML_FILES
        WebView.qml
    RESOURCES
        index.html
)
