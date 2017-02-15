set(activewindowcontrolplugin_SRCS
    appmenumodel.cpp
    activewindowcontrolplugin.cpp
    )

add_library(activewindowcontrolplugin SHARED ${activewindowcontrolplugin_SRCS})

cmake_policy(SET CMP0053 NEW)
cmake_policy(SET CMP0063 NEW)

find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Widgets DBus)

add_subdirectory(libdbusmenuqt)

target_link_libraries(activewindowcontrolplugin
                      Qt5::Core
                      Qt5::Widgets
                      Qt5::Quick
                      Qt5::DBus
                      KF5::Plasma
                      KF5::WindowSystem
                      dbusmenuqt
                      )

find_package(X11)
set_package_properties(X11 PROPERTIES DESCRIPTION "X11 libraries"
                        URL "http://www.x.org"
                        TYPE OPTIONAL
                        PURPOSE "Required for building the X11 based workspace")

if(X11_FOUND)
  find_package(XCB MODULE REQUIRED COMPONENTS XCB RANDR)
  set_package_properties(XCB PROPERTIES TYPE REQUIRED)
  if(NOT X11_SM_FOUND)
    message(FATAL_ERROR "\nThe X11 Session Management (SM) development package could not be found.\nPlease install libSM.\n")
  endif(NOT X11_SM_FOUND)

  find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS X11Extras)
endif()

if(X11_FOUND AND XCB_XCB_FOUND)
  set(HAVE_X11 1)
endif()

configure_file(config-X11.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-X11.h)

if(HAVE_X11)
    find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED X11Extras)
    find_package(XCB MODULE REQUIRED COMPONENTS XCB RANDR)
    set_package_properties(XCB PROPERTIES TYPE REQUIRED)
    target_link_libraries(activewindowcontrolplugin
                          Qt5::X11Extras
                          XCB::XCB
                          )
endif()

install(TARGETS activewindowcontrolplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/activeWindowControl)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/activeWindowControl)
