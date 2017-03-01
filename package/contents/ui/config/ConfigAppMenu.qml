import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: main

    property alias cfg_appmenuEnabled: appmenuEnabled.checked
    property alias cfg_appmenuNextToButtons: appmenuNextToButtons.checked
    property alias cfg_appmenuFillHeight: appmenuFillHeight.checked
    property alias cfg_appmenuNextToIconAndText: appmenuNextToIconAndText.checked
    property alias cfg_appmenuAfterText: appmenuAfterText.checked

    GroupBox {
        id: appmenuEnabled
        title: i18n("Enable application menu")
        checkable: true
        flat: true

        GridLayout {
            columns: 2

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            CheckBox {
                id: appmenuFillHeight
                text: i18n("Fill height")
                Layout.columnSpan: 2
            }

            CheckBox {
                id: appmenuNextToButtons
                text: i18n("Show next to buttons")
                Layout.columnSpan: 2
            }

            CheckBox {
                id: appmenuNextToIconAndText
                text: i18n("Show next to icon and text")
                Layout.columnSpan: 2
            }
            
            CheckBox {
                id: appmenuAfterText
                text: i18n("Show after text")
                Layout.columnSpan: 2
            }
        }
    }

}
