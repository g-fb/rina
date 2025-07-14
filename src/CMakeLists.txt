qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(apphana
    main.cpp
)

qt_policy(SET QTP0001 NEW)
qt_add_qml_module(apphana
    URI com.georgefb.hana
    VERSION 1.0
    QML_FILES
        Main.qml
)

add_subdirectory(Sidebar)

target_link_libraries(apphana
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::WebEngineCore
        Qt6::WebEngineQuick

        KF6::ColorScheme
        KF6::ConfigCore
        KF6::ConfigGui
        KF6::I18n
        KF6::IconThemes
        KF6::KIOWidgets
        KF6::Kirigami
        KF6::Crash

        # link qml modules
        sidebarplugin
)

install(TARGETS apphana ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
