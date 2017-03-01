import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: appmenu
    anchors.fill: parent
    // set the left margin to give space to title text
    anchors.leftMargin: plasmoid.configuration.appmenuAfterText ? titleTextWidth + 20 : 0

    property bool appmenuEnabled: plasmoid.configuration.appmenuEnabled
    property bool appmenuNextToButtons: plasmoid.configuration.appmenuNextToButtons
    property bool appmenuFillHeight: plasmoid.configuration.appmenuFillHeight
    property bool appmenuEnabledAndNonEmpty: appmenuEnabled && appMenuModel !== null && appMenuModel.menuAvailable
    property bool appmenuOpened: appmenuEnabled && plasmoid.nativeInterface.currentIndex > -1
    property var appMenuModel: null

    property bool appmenuButtonsOffsetEnabled: !buttonsStandalone && appmenuNextToButtons && childrenRect.width > 0
    property double appmenuOffsetWidth: appmenuNextToIconAndText
                                                ? appmenu.childrenRect.width + (appmenuButtonsOffsetEnabled ? controlButtonsArea.width : 0)
                                                : 0

    visible: appmenuEnabledAndNonEmpty && (appmenuNextToIconAndText || mouseHover || appmenuOpened) && !noWindowVisible // this added from other user named kupiqu

    GridLayout {
        id: buttonGrid

        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight

        flow: GridLayout.LeftToRight
        rowSpacing: units.smallSpacing
        columnSpacing: units.smallSpacing

        anchors.top: parent.top
        anchors.left: parent.left

        property double placementOffset: appmenuNextToButtons && controlButtonsArea.visible ? controlButtonsArea.width + 5 : 0

        anchors.leftMargin: (bp === 1 || bp === 3) ? parent.width - width - placementOffset : placementOffset
        anchors.topMargin: (bp === 2 || bp === 3) ? 0 : parent.height - height

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 150
                easing.type: Easing.Linear
            }
        }
        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 150
                easing.type: Easing.Linear
            }
        }

        Component.onCompleted: {
            plasmoid.nativeInterface.buttonGrid = buttonGrid
        }

        Connections {
            target: plasmoid.nativeInterface
            onRequestActivateIndex: {
                var idx = Math.max(0, Math.min(buttonRepeater.count - 1, index))
                var button = buttonRepeater.itemAt(index)
                if (button) {
                    button.clicked()
                }
            }
        }

        Repeater {
            id: buttonRepeater
            model: null

            PlasmaComponents.ToolButton {
                readonly property int buttonIndex: index
                property double heightRatio: appmenu.height < minimumHeight ? appmenu.height / minimumHeight : 1

                Layout.preferredWidth: minimumWidth
                Layout.preferredHeight: appmenuFillHeight ? appmenu.height : minimumHeight
                font.pixelSize: fontPixelSize * heightRatio
                text: activeMenu
                // fake highlighted
                checkable: plasmoid.nativeInterface.currentIndex === index
                checked: checkable
                onClicked: {
                    plasmoid.nativeInterface.trigger(this, index)
                }
            }
        }
    }

    function initializeAppModel() {
        if (appMenuModel !== null) {
            return
        }
        print('initializing appMenuModel...')
        try {
            appMenuModel = Qt.createQmlObject(
                'import QtQuick 2.2;\
                 import org.kde.plasma.plasmoid 2.0;\
                 import org.kde.private.activeWindowControl 1.0 as ActiveWindowControlPrivate;\
                 ActiveWindowControlPrivate.AppMenuModel {\
                     id: appMenuModel;\
                     Component.onCompleted: {\
                         plasmoid.nativeInterface.model = appMenuModel\
                     }\
                 }', main)
        } catch (e) {
            print('appMenuModel failed to initialize: ' + e)
        }
        print('initializing appmenu...DONE ' + appMenuModel)
        if (appMenuModel !== null) {
            resetAppmenuModel()
        }
    }

    function resetAppmenuModel() {
        if (appmenuEnabled) {
            initializeAppModel()
            if (appMenuModel === null) {
                return
            }
            print('setting model in QML: ' + appMenuModel)
            for (var key in appMenuModel) {
                print('  ' + key + ' -> ' + appMenuModel[key])
            }
            plasmoid.nativeInterface.model = appMenuModel
            buttonRepeater.model = appMenuModel
        } else {
            plasmoid.nativeInterface.model = null
            buttonRepeater.model = null
        }
    }

    onAppmenuEnabledChanged: {
        appmenu.resetAppmenuModel()
    }

}
