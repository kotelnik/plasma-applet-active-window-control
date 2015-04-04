import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_showControlButtons: showControlButtons.checked
    property int cfg_buttonsPosition
    property alias cfg_showMinimize: showMinimize.checked
    property alias cfg_horizontalScreenWidthPercent: horizontalScreenWidthPercent.value
    property alias cfg_buttonSize: buttonSize.value

    onCfg_buttonsPositionChanged: {
        switch (cfg_buttonsPosition) {
        case 0:
            buttonsPositionGroup.current = upperLeftRadio;
            break;
        case 2:
            buttonsPositionGroup.current = bottomLeftRadio;
            break;
        case 3:
            buttonsPositionGroup.current = bottomRightRadio;
            break;
        case 1:
        default:
            buttonsPositionGroup.current = upperRightRadio;
        }
    }

    ExclusiveGroup {
        id: buttonsPositionGroup
    }
    
    GridLayout {
        id: displayPosition
        columns: 2
        
        Label {
            text: i18n("Control Buttons:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        CheckBox {
            id: showControlButtons
            text: i18n("Show control buttons")
        }
        Item {
            width: 2
            height: 2
        }
        CheckBox {
            id: showMinimize
            text: i18n("Show minimize button")
            enabled: showControlButtons.checked
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
            enabled: showControlButtons.checked
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 3
        }
        RadioButton {
            id: upperRightRadio
            exclusiveGroup: buttonsPositionGroup
            text: i18n("Upper right")
            onCheckedChanged: if (checked) cfg_buttonsPosition = 1;
            enabled: showControlButtons.checked
        }
        RadioButton {
            id: bottomLeftRadio
            exclusiveGroup: buttonsPositionGroup
            text: i18n("Bottom left")
            onCheckedChanged: if (checked) cfg_buttonsPosition = 2;
            enabled: showControlButtons.checked
        }
        RadioButton {
            id: bottomRightRadio
            exclusiveGroup: buttonsPositionGroup
            text: i18n("Bottom right")
            onCheckedChanged: if (checked) cfg_buttonsPosition = 3;
            enabled: showControlButtons.checked
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }
        
        Label {
            text: i18n("Button size:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            Layout.columnSpan: 2
        }
        Slider {
            id: buttonSize
            stepSize: 0.1
            minimumValue: 0.1
            tickmarksEnabled: true
            width: parent.width
            Layout.columnSpan: 2
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }
        
        Label {
            text: i18n("Width in horizontal panel:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            Layout.columnSpan: 2
        }
        Slider {
            id: horizontalScreenWidthPercent
            stepSize: 0.01
            minimumValue: 0.08
            value: 0.12
            tickmarksEnabled: true
            width: parent.width
            Layout.columnSpan: 2
        }
    }
    
}
