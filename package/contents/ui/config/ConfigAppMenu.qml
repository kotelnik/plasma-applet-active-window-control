import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: main

    property alias cfg_appmenuEnabled: appmenuEnabled.checked
    property alias cfg_appmenuNextToButtons: appmenuNextToButtons.checked
    property alias cfg_appmenuFillHeight: appmenuFillHeight.checked
    property alias cfg_appmenuNextToIconAndText: appmenuNextToIconAndText.checked
    property alias cfg_appmenuSwitchSidesWithIconAndText: appmenuSwitchSidesWithIconAndText.checked
    property alias cfg_appmenuOuterSideMargin: appmenuOuterSideMargin.value
    property alias cfg_appmenuIconAndTextOpacity: appmenuIconAndTextOpacity.value

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
                id: appmenuSwitchSidesWithIconAndText
                text: i18n("Switch sides with icon and text")
                Layout.columnSpan: 2
                enabled: appmenuNextToIconAndText.checked
            }

            Label {
                text: i18n('Side margin:')
                Layout.alignment: Qt.AlignRight
            }
            SpinBox {
                id: appmenuOuterSideMargin
                decimals: 0
                stepSize: 1
                minimumValue: 0
                maximumValue: 100
                suffix: i18nc('Abbreviation for pixels', 'px')
            }

            Label {
                text: i18n('Icon and text opacity:')
                Layout.alignment: Qt.AlignRight
            }
            SpinBox {
                id: appmenuIconAndTextOpacity
                decimals: 2
                stepSize: 0.1
                minimumValue: 0
                maximumValue: 1
            }
        }
    }

}
