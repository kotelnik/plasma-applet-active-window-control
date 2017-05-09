import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("Appearance")
         icon: "preferences-desktop-color"
         source: "config/ConfigAppearance.qml"
    }
    ConfigCategory {
         name: i18n("Behaviour")
         icon: "preferences-desktop"
         source: "config/ConfigBehaviour.qml"
    }
    ConfigCategory {
         name: i18n("Buttons")
         icon: "preferences-activities"
         source: "config/ConfigButtons.qml"
    }
    ConfigCategory {
         name: i18n("Mouse Control")
         icon: "preferences-desktop-mouse"
         source: "config/ConfigMouseControl.qml"
    }
    ConfigCategory {
         name: i18n("Application Menu")
         icon: "application-menu"
         source: "config/ConfigAppMenu.qml"
    }
}
