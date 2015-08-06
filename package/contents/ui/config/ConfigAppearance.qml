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

    GridLayout {
        columns: 1
        
        Label {
            text: i18n("Width in horizontal panel:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
        }
        Slider {
            id: horizontalScreenWidthPercent
            stepSize: 0.001
            minimumValue: 0.001
            maximumValue: 1
            value: 0.12
            Layout.preferredWidth: 500
        }
        
        Item {
            width: 2
            height: 10
        }
        
        CheckBox {
            id: showWindowTitle
            text: i18n("Show window title")
        }
        
        CheckBox {
            id: showWindowIcon
            text: i18n("Show window icon")
        }
        
        CheckBox {
            id: windowIconOnTheRight
            text: i18n("Window icon on the right")
        }
    }
    
}
