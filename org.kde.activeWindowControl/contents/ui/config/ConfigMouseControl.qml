import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_doubleClickMaximizes: doubleClickMaximizes.checked
    property alias cfg_middleClickFullscreen: middleClickFullscreen.checked
    property alias cfg_wheelUpMaximizes: wheelUpMaximizes.checked
    property int cfg_wheelDownAction

    onCfg_wheelDownActionChanged: {
        switch (cfg_wheelDownAction) {
        case 1:
            wheelDownActionGroup.current = wheelDownMinimizesRadio;
            break;
        case 2:
            wheelDownActionGroup.current = wheelDownUnmaximizesRadio;
            break;
        case 0:
        default:
            wheelDownActionGroup.current = wheelDownDisabledRadio;
        }
    }
    
    Component.onCompleted: {
        cfg_wheelDownActionChanged()
    }

    ExclusiveGroup {
        id: wheelDownActionGroup
    }
    
    GridLayout {
        id: displayPosition
        columns: 2
        
        Label {
            text: i18n("Mouse Buttons:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        CheckBox {
            id: doubleClickMaximizes
            text: i18n("Doubleclick to toggle maximizing")
        }
        Item {
            width: 2
            height: 2
        }
        CheckBox {
            id: middleClickFullscreen
            text: i18n("Middleclick to toggle fullscreen")
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }
        
        Label {
            text: i18n("Mouse Wheel:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        CheckBox {
            id: wheelUpMaximizes
            text: i18n("Mouse wheel up to maximize")
        }
        Item {
            width: 2
            height: 2
            Layout.rowSpan: 3
        }
        RadioButton {
            id: wheelDownDisabledRadio
            exclusiveGroup: wheelDownActionGroup
            text: i18n("Mouse wheel down disabled")
            onCheckedChanged: if (checked) cfg_wheelDownAction = 0;
        }
        RadioButton {
            id: wheelDownMinimizesRadio
            exclusiveGroup: wheelDownActionGroup
            text: i18n("Mouse wheel down to minimize")
            onCheckedChanged: if (checked) cfg_wheelDownAction = 1;
        }
        RadioButton {
            id: wheelDownUnmaximizesRadio
            exclusiveGroup: wheelDownActionGroup
            text: i18n("Mouse wheel down to unmaximize")
            onCheckedChanged: if (checked) cfg_wheelDownAction = 2;
        }
    }
    
}
