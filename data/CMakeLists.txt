#
# SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#

ecm_install_icons(
    ICONS icons/sc-apps-rina.svg
    DESTINATION ${KDE_INSTALL_ICONDIR}
    THEME hicolor
)

install(FILES com.georgefb.rina.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES com.georgefb.rina.metainfo.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
