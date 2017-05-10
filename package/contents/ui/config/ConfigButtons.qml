import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

Item {

    property alias cfg_showControlButtons: showControlButtons.checked
    property alias cfg_doNotHideControlButtons: doNotHideControlButtons.checked
    property int cfg_buttonsPosition
    property alias cfg_buttonsVerticalCenter: buttonsVerticalCenter.checked
    property alias cfg_buttonsStandalone: buttonsStandalone.checked
    property alias cfg_buttonsDynamicWidth: buttonsDynamicWidth.checked
    property alias cfg_slidingIconAndText: slidingIconAndText.checked
    property alias cfg_showButtonOnlyWhenMaximized: showButtonOnlyWhenMaximized.checked
    property alias cfg_showMinimize: showMinimize.checked
    property alias cfg_showMaximize: showMaximize.checked
    property alias cfg_showPinToAllDesktops: showPinToAllDesktops.checked
    property alias cfg_buttonSize: buttonSize.value
    property alias cfg_controlButtonsSpacing: controlButtonsSpacing.value
    property string cfg_buttonOrder
    property alias cfg_customAuroraeThemePath: customAuroraeThemePath.text
    property string cfg_customAuroraeThemeImageExtension

    onCfg_buttonsPositionChanged: {
        switch (cfg_buttonsPosition) {
        case 0:
            buttonsPositionGroup.current = upperLeftRadio;
            break;
        case 1:
            buttonsPositionGroup.current = upperRightRadio;
            break;
        case 2:
            buttonsPositionGroup.current = bottomLeftRadio;
            break;
        case 3:
            buttonsPositionGroup.current = bottomRightRadio;
            break;
        default:
            buttonsPositionGroup.current = upperLeftRadio;
        }
    }

    property variant extensionModel: ['.svg', '.svgz']

    Component.onCompleted: {
        cfg_buttonsPositionChanged()
        sortButtonOrder()
        customAuroraeThemeImageExtension.currentIndex = extensionModel.indexOf(cfg_customAuroraeThemeImageExtension)
    }

    ListModel {
        id: buttonsToSpend
        ListElement {
            text: "close"
        }
        ListElement {
            text: "minimize"
        }
        ListElement {
            text: "maximize"
        }
        ListElement {
            text: "alldesktops"
        }
    }

    function sortButtonOrder() {
        cfg_buttonOrder.split('|').forEach(function (buttonName, index) {
            if (buttonName === 'close') {
                print('adding ' + buttonName);
                buttonOrder.model.insert(index, buttonsToSpend.get(0));
            } else if (buttonName === 'minimize') {
                buttonOrder.model.insert(index, buttonsToSpend.get(1));
                print('adding ' + buttonName);
            } else if (buttonName === 'maximize') {
                buttonOrder.model.insert(index, buttonsToSpend.get(2));
                print('adding ' + buttonName);
            } else if (buttonName === 'pin' || buttonName === 'alldesktops') {
                buttonOrder.model.insert(index, buttonsToSpend.get(3));
                print('adding ' + buttonName);
            }
        });
    }

    ExclusiveGroup {
        id: buttonsPositionGroup
    }

    GroupBox {
        id: showControlButtons
        title: i18n("Enable Control Buttons")
        checkable: true
        flat: true

        GridLayout {
            columns: 2

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Item {
                width: 2
                height: 2
                Layout.rowSpan: 3
            }

            CheckBox {
                id: showMinimize
                text: i18n("Show minimize button")
            }

            CheckBox {
                id: showMaximize
                text: i18n("Show maximize button")
            }

            CheckBox {
                id: showPinToAllDesktops
                text: i18n("Show pin to all desktops")
            }

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Label {
                text: i18n("Button order:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }

            OrderableListView {
                id: buttonOrder
                height: units.gridUnit * 2
                width: height * 4
                model: ListModel {
                    // will be filled initially by sortButtonOrder() method
                }
                orientation: ListView.Horizontal
                itemWidth: width / 4
                itemHeight: itemWidth

                onModelOrderChanged: {
                    var orderStr = '';
                    for (var i = 0; i < model.count; i++) {
                        var item = model.get(i)
                        if (orderStr.length > 0) {
                            orderStr += '|';
                        }
                        orderStr += item.text;
                    }
                    cfg_buttonOrder = orderStr;
                    print('written: ' + cfg_buttonOrder);
                }
            }

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Label {
                text: i18n("Behaviour:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }

            CheckBox {
                id: doNotHideControlButtons
                text: i18n("Do not hide on mouse out")
            }

            Item {
                width: 2
                height: 2
                Layout.rowSpan: 4
            }

            CheckBox {
                id: showButtonOnlyWhenMaximized
                text: i18n("Show only when maximized")
            }

            CheckBox {
                id: buttonsStandalone
                text: i18n("Buttons next to icon and text")
            }

            CheckBox {
                id: buttonsDynamicWidth
                text: i18n("Dynamic width")
                enabled: buttonsStandalone.checked
            }

            CheckBox {
                id: slidingIconAndText
                text: i18n("Sliding icon and text")
                enabled: buttonsStandalone.checked
            }


            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Label {
                text: i18n("Position:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            RadioButton {
                id: upperLeftRadio
                exclusiveGroup: buttonsPositionGroup
                text: i18n("Upper left")
                onCheckedChanged: if (checked) cfg_buttonsPosition = 0;
            }
            Item {
                width: 2
                height: 2
                Layout.rowSpan: 4
            }
            RadioButton {
                id: upperRightRadio
                exclusiveGroup: buttonsPositionGroup
                text: i18n("Upper right")
                onCheckedChanged: if (checked) cfg_buttonsPosition = 1;
            }
            RadioButton {
                id: bottomLeftRadio
                exclusiveGroup: buttonsPositionGroup
                text: i18n("Bottom left")
                onCheckedChanged: if (checked) cfg_buttonsPosition = 2;
            }
            RadioButton {
                id: bottomRightRadio
                exclusiveGroup: buttonsPositionGroup
                text: i18n("Bottom right")
                onCheckedChanged: if (checked) cfg_buttonsPosition = 3;
            }

            CheckBox {
                id: buttonsVerticalCenter
                text: i18n("Vertical center")
            }

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Label {
                text: i18n("Button size:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            Slider {
                id: buttonSize
                stepSize: 0.1
                minimumValue: 0.1
                tickmarksEnabled: true
                width: parent.width
            }

            Label {
                text: i18n("Buttons spacing:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            Slider {
                id: controlButtonsSpacing
                stepSize: 1
                minimumValue: 0
                maximumValue: 20
                tickmarksEnabled: true
                width: parent.width
            }

            Item {
                width: 2
                height: 10
                Layout.columnSpan: 2
            }

            Label {
                text: i18n('Path to aurorae theme:')
                Layout.alignment: Qt.AlignRight
            }
            Row {
                TextField {
                    id: customAuroraeThemePath
                    placeholderText: 'Leave empty to use default Breeze theme.'
                    onTextChanged: cfg_customAuroraeThemePath = text
                    width: 300
                }
                ComboBox {
                    id: customAuroraeThemeImageExtension
                    model: extensionModel
                    onActivated: {
                        cfg_customAuroraeThemeImageExtension = textAt(index)
                    }
                    width: 80
                }
            }
        }
    }


}
