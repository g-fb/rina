qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(apprina
    main.cpp
)

qt_policy(SET QTP0001 NEW)
qt_add_qml_module(apprina
    URI com.georgefb.rina
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES bridge.h bridge.cpp
)

# generate settings class
kconfig_target_kcfg_file(apprina
    FILE generalsettings.kcfg
    CLASS_NAME GeneralSettings

    MUTATORS
    SINGLETON
    GENERATE_MOC
    DEFAULT_VALUE_GETTERS
    GENERATE_PROPERTIES
    PARENT_IN_CONSTRUCTOR
    QML_REGISTRATION
)

add_subdirectory(Sidebar)
add_subdirectory(WebView)

target_link_libraries(apprina
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
        webviewplugin
)

install(TARGETS apprina ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
