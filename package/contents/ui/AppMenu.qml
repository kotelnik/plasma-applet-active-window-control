import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: appmenu
    anchors.fill: parent

    property bool appmenuEnabled: plasmoid.configuration.appmenuEnabled
    property bool appmenuNextToButtons: plasmoid.configuration.appmenuNextToButtons
    property bool appmenuFillHeight: plasmoid.configuration.appmenuFillHeight
    property bool appmenuEnabledAndNonEmpty: appmenuEnabled && appMenuModel !== null && appMenuModel.menuAvailable
    property bool appmenuOpened: appmenuEnabled && plasmoid.nativeInterface.currentIndex > -1
    property var appMenuModel: null

    property bool appmenuButtonsOffsetEnabled: !buttonsStandalone && appmenuNextToButtons && childrenRect.width > 0
    property double appmenuOffsetWidth: visible && appmenuNextToIconAndText && !appmenuSwitchSidesWithIconAndText
                                                ? appmenu.childrenRect.width + (appmenuButtonsOffsetEnabled ? controlButtonsArea.width : 0) + appmenuSideMargin*2
                                                : 0

    visible: appmenuEnabledAndNonEmpty && !noWindowActive && (appmenuNextToIconAndText || mouseHover || appmenuOpened)

    GridLayout {
        id: buttonGrid

        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight

        flow: GridLayout.LeftToRight
        rowSpacing: units.smallSpacing
        columnSpacing: units.smallSpacing

        anchors.top: parent.top
        anchors.left: parent.left

        property double placementOffsetButtons: appmenuNextToButtons && controlButtonsArea.visible ? controlButtonsArea.width + appmenuSideMargin : 0
        property double placementOffset: appmenuNextToIconAndText && appmenuSwitchSidesWithIconAndText
                                            ? activeWindowListView.anchors.leftMargin + windowTitleText.anchors.leftMargin + Math.min(windowTitleText.implicitWidth, windowTitleText.width) + appmenuSideMargin
                                            : placementOffsetButtons

        anchors.leftMargin: (bp === 1 || bp === 3) ? parent.width - width - placementOffset : placementOffset
        anchors.topMargin: (bp === 2 || bp === 3) ? 0 : parent.height - height

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