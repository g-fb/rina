#
# SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#

qt_add_library(sidebar STATIC)
qt_add_qml_module(sidebar
    URI com.georgefb.rina.sidebar
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/src/com/georgefb/rina/sidebar
    IMPORT_PATH ${CMAKE_BINARY_DIR}
    QML_FILES
        Sidebar.qml
        FileDelegate.qml
        FolderDelegate.qml
    SOURCES foldersmodel.h foldersmodel.cpp
    SOURCES filesmodel.h filesmodel.cpp
)
