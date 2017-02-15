set(activewindowcontrolapplet_SRCS
    activewindowcontrolapplet.cpp
)

add_library(plasma_applet_activewindowcontrol MODULE ${activewindowcontrolapplet_SRCS})

kcoreaddons_desktop_to_json(plasma_applet_activewindowcontrol ../package/metadata.desktop)

target_link_libraries(plasma_applet_activewindowcontrol
                      Qt5::Widgets
                      Qt5::Quick
                      Qt5::DBus
                      KF5::Plasma
                      KF5::WindowSystem)

install(TARGETS plasma_applet_activewindowcontrol DESTINATION ${PLUGIN_INSTALL_DIR}/plasma/applets)
