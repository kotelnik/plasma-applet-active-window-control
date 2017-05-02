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
        rowSpacing: 0
        columnSpacing: 0

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
                    button.clicked(null)
                }
            }
        }

        Repeater {
            id: buttonRepeater
            model: null

            MouseArea {
                id: appmenuButton

                hoverEnabled: true

                readonly property int buttonIndex: index

                property bool menuOpened: plasmoid.nativeInterface.currentIndex === index

                Layout.preferredWidth: appmenuButtonBackground.width
                Layout.preferredHeight: appmenuButtonBackground.height

                Rectangle {
                    id: appmenuButtonBackground
                    border.color: 'transparent'
                    width: appmenuButtonTitle.implicitWidth + units.smallSpacing * 3
                    height: appmenuFillHeight ? appmenu.height : appmenuButtonTitle.implicitHeight + units.smallSpacing
                    color: menuOpened ? theme.highlightColor : 'transparent'
                    radius: units.smallSpacing / 2
                }

                PlasmaComponents.Label {
                    id: appmenuButtonTitle
                    anchors.centerIn: appmenuButtonBackground
                    font.pixelSize: fontPixelSize * plasmoid.configuration.appmenuButtonTextSizeScale
                    text: activeMenu.replace('&', '')
                }

                onClicked: {
                    plasmoid.nativeInterface.trigger(this, index)
                }

                onEntered: {
                    appmenuButtonBackground.border.color = theme.highlightColor
                }

                onExited: {
                    appmenuButtonBackground.border.color = 'transparent'
                }
            }
        }
    }

    Rectangle {
        id: separator
        anchors.left: buttonGrid.left
        anchors.leftMargin: appmenuSwitchSidesWithIconAndText ? - appmenuSideMargin * 0.5 : buttonGrid.width + appmenuSideMargin * 0.5
        anchors.verticalCenter: buttonGrid.verticalCenter
        height: 0.8 * parent.height
        width: 1
        visible: appmenuNextToIconAndText && plasmoid.configuration.appmenuSeparatorEnabled
        color: theme.textColor
        opacity: 0.4
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