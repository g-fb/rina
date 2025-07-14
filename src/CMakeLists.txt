qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(apphana
    main.cpp
)

qt_add_qml_module(apphana
    URI hana
    VERSION 1.0
    QML_FILES
        Main.qml
)

target_link_libraries(apphana
    PRIVATE
        Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS apphana
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
