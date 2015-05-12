import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("Appearance")
         icon: "preferences-desktop-color"
         source: "config/ConfigAppearance.qml"
    }
    ConfigCategory {
         name: i18n("Mouse Control")
         icon: "preferences-desktop-mouse"
         source: "config/ConfigMouseControl.qml"
    }
}
