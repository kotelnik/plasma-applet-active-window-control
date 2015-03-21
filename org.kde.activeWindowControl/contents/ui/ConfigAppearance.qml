import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0 as Layouts

Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height

    property int cfg_closeButtonPosition

    onCfg_closeButtonPositionChanged: {
        switch (cfg_closeButtonPosition) {
        case 0:
            closeButtonPositionGroup.current = upperLeftRadio;
            break;
        case 2:
            closeButtonPositionGroup.current = bottomLeftRadio;
            break;
        case 3:
            closeButtonPositionGroup.current = bottomRightRadio;
            break;
        case 4:
            closeButtonPositionGroup.current = hideRadio;
            break;
        case 1:
        default:
            closeButtonPositionGroup.current = upperRightRadio;
        }
    }

    Component.onCompleted: cfg_currentDesktopSelectedChanged()

    QtControls.ExclusiveGroup {
        id: closeButtonPositionGroup
    }
    
    Layouts.GridLayout {
        columns: 2
        QtControls.Label {
            text: i18n("Display close button:")
            Layouts.Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
        }
        QtControls.RadioButton {
            id: upperLeftRadio
            exclusiveGroup: closeButtonPositionGroup
            text: i18n("Upper left")
            onCheckedChanged: if (checked) cfg_closeButtonPosition = 0;
        }
        Item {
            width: 2
            height: 2
            Layouts.Layout.rowSpan: 2
        }
        QtControls.RadioButton {
            id: upperRightRadio
            exclusiveGroup: closeButtonPositionGroup
            text: i18n("Upper right")
            onCheckedChanged: if (checked) cfg_closeButtonPosition = 1;
        }
        QtControls.RadioButton {
            id: bottomLeftRadio
            exclusiveGroup: closeButtonPositionGroup
            text: i18n("Bottom left")
            onCheckedChanged: if (checked) cfg_closeButtonPosition = 2;
        }
        Item {
            width: 2
            height: 2
            Layouts.Layout.rowSpan: 2
        }
        QtControls.RadioButton {
            id: bottomRightRadio
            exclusiveGroup: closeButtonPositionGroup
            text: i18n("Bottom right")
            onCheckedChanged: if (checked) cfg_closeButtonPosition = 3;
        }
        QtControls.RadioButton {
            id: hideRadio
            exclusiveGroup: closeButtonPositionGroup
            text: i18n("Hide")
            onCheckedChanged: if (checked) cfg_closeButtonPosition = 4;
        }
    }
}
