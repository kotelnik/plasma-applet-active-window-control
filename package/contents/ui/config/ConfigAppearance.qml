import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_horizontalScreenWidthPercent: horizontalScreenWidthPercent.value
    
    property alias cfg_showWindowTitle: showWindowTitle.checked
    property alias cfg_showWindowIcon: showWindowIcon.checked
    property alias cfg_windowIconOnTheRight: windowIconOnTheRight.checked
    
    property alias cfg_iconAndTextSpacing: iconAndTextSpacing.value

    GridLayout {
        columns: 2
        
        Label {
            text: i18n("Width in horizontal panel:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            Layout.columnSpan: 2
        }
        Slider {
            id: horizontalScreenWidthPercent
            stepSize: 0.001
            minimumValue: 0.001
            maximumValue: 1
            Layout.preferredWidth: 500
            Layout.columnSpan: 2
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }
        
        CheckBox {
            id: showWindowTitle
            text: i18n("Show window title")
            Layout.columnSpan: 2
        }
        
        CheckBox {
            id: showWindowIcon
            text: i18n("Show window icon")
            Layout.columnSpan: 2
        }
        
        CheckBox {
            id: windowIconOnTheRight
            text: i18n("Window icon on the right")
            Layout.columnSpan: 2
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }
        
        GridLayout {
            columns: 2
            
            Layout.columnSpan: 2
            
            Label {
                text: i18n("Icon and text spacing:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            }
            SpinBox {
                id: iconAndTextSpacing
                decimals: 1
                stepSize: 0.5
                minimumValue: 0.5
                maximumValue: 300
            }
        }
    }
    
}
