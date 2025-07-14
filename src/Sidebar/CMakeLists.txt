
qt_add_library(sidebar STATIC)
qt_add_qml_module(sidebar
    URI com.georgefb.hana.sidebar
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/src/com/georgefb/hana/sidebar
    IMPORT_PATH ${CMAKE_BINARY_DIR}
    QML_FILES
        Sidebar.qml
)
