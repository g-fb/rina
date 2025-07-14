
qt_add_library(webview STATIC)
qt_add_qml_module(webview
    URI com.georgefb.hana.webview
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/src/com/georgefb/hana/webview
    IMPORT_PATH ${CMAKE_BINARY_DIR}
    QML_FILES
        WebView.qml
)
