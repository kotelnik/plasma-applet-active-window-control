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
    property alias cfg_appmenuTextMenuSpacing: appmenuTextMenuSpacing.text
    property alias cfg_appmenuTextMenuLimit: appmenuTextMenuLimit.text

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
            
            GridLayout {
                columns: 2
                Layout.columnSpan: 2
                enabled: appmenuAfterText.checked
                
                Label {
                    text: i18n("Spacing:")
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
                }
                
                TextField {
                    id: appmenuTextMenuSpacing
                    Layout.preferredWidth: 50
                    onTextChanged: cfg_appmenuTextMenuSpacing = text
                }
                
                Label {
                    text: i18n("Title limit:")
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
                }
                
                TextField {
                    id: appmenuTextMenuLimit
                    Layout.preferredWidth: 50
                    onTextChanged: cfg_appmenuTextMenuLimit = text
                }
            }
        }
    }

}
