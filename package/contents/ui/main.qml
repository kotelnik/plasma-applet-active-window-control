/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.taskmanager 0.1 as TaskManager

Item {
    id: main

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)

    property double horizontalScreenWidthPercent: plasmoid.configuration.horizontalScreenWidthPercent
    property double buttonSize: plasmoid.configuration.buttonSize
    property bool autoFillWidth: plasmoid.configuration.autoFillWidth
    property double widthForHorizontalPanel: (Screen.width * horizontalScreenWidthPercent + plasmoid.configuration.widthFineTuning) - ((!controlButtonsArea.visible && buttonsStandalone && plasmoid.configuration.buttonsDynamicWidth) ? controlButtonsArea.width : 0)
    anchors.fill: parent
    Layout.fillWidth: plasmoid.configuration.autoFillWidth
    Layout.preferredWidth: autoFillWidth ? -1 : (vertical ? parent.width : (widthForHorizontalPanel > 0 ? widthForHorizontalPanel : 0.0001))
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.preferredHeight: parent === null ? 0 : vertical ? Math.min(theme.defaultFont.pointSize * 4, parent.width) : parent.height
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight

    property int textType: plasmoid.configuration.textType
    property int fitText: plasmoid.configuration.fitText
    property int tooltipTextType: plasmoid.configuration.tooltipTextType
    property string tooltipText: ''

    property bool windowIconOnTheRight: plasmoid.configuration.windowIconOnTheRight
    property double iconAndTextSpacing: plasmoid.configuration.iconAndTextSpacing
    property bool slidingIconAndText: plasmoid.configuration.slidingIconAndText
    property double fontPixelSize: theme.defaultFont.pixelSize * plasmoid.configuration.fontSizeScale
    property bool fontBold: plasmoid.configuration.boldFontWeight
    property string fontFamily: plasmoid.configuration.fontFamily

    property bool noWindowActive: true
    property bool currentWindowMaximized: false
    property bool canShowButtonsAccordingMaximized: showButtonOnlyWhenMaximized ? currentWindowMaximized : true

    property int controlButtonsSpacing: plasmoid.configuration.controlButtonsSpacing

    property int bp: plasmoid.configuration.buttonsPosition;
    property bool buttonsVerticalCenter: plasmoid.configuration.buttonsVerticalCenter
    property bool showControlButtons: plasmoid.configuration.showControlButtons
    property bool showButtonOnlyWhenMaximized: plasmoid.configuration.showButtonOnlyWhenMaximized
    property bool showMinimize: showControlButtons && plasmoid.configuration.showMinimize
    property bool showMaximize: showControlButtons && plasmoid.configuration.showMaximize
    property bool showPinToAllDesktops: showControlButtons && plasmoid.configuration.showPinToAllDesktops
    property string buttonOrder: plasmoid.configuration.buttonOrder
    property bool doubleClickMaximizes: plasmoid.configuration.doubleClickMaximizes
    property int leftClickAction: plasmoid.configuration.leftClickAction
    property string chosenLeftClickSource: leftClickAction === 1 ? shortcutDS.presentWindows : leftClickAction === 2 ? shortcutDS.presentWindowsAll : leftClickAction === 3 ? shortcutDS.presentWindowsClass : ''
    property bool middleClickClose: plasmoid.configuration.middleClickAction === 1
    property bool middleClickFullscreen: plasmoid.configuration.middleClickAction === 2
    property bool wheelUpMaximizes: plasmoid.configuration.wheelUpMaximizes
    property bool wheelDownMinimizes: plasmoid.configuration.wheelDownAction === 1
    property bool wheelDownUnmaximizes: plasmoid.configuration.wheelDownAction === 2

    property bool buttonsStandalone: showControlButtons && plasmoid.configuration.buttonsStandalone
    property bool doNotHideControlButtons: showControlButtons && plasmoid.configuration.doNotHideControlButtons

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    property bool mouseHover: false
    property bool isActiveWindowPinned: false
    property bool isActiveWindowMaximized: false

    property bool appmenuNextToIconAndText: plasmoid.configuration.appmenuNextToIconAndText
    property double appmenuSideMargin: plasmoid.configuration.appmenuOuterSideMargin
    property bool appmenuSwitchSidesWithIconAndText: plasmoid.configuration.appmenuSwitchSidesWithIconAndText
    property bool appmenuBoldTitleWhenMenuDisplayed: plasmoid.configuration.appmenuBoldTitleWhenMenuDisplayed

    property var activeTaskLocal: null

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation



    //
    // MODEL
    //
    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled

        screenGeometry: plasmoid.screenGeometry
        filterByScreen: plasmoid.configuration.showForCurrentScreenOnly

        onActiveTaskChanged: {
            updateActiveWindowInfo()
        }
        onDataChanged: {
            updateActiveWindowInfo()
        }
        onCountChanged: {
            updateActiveWindowInfo()
        }
    }

    function activeTask() {
        return activeTaskLocal
    }

    function activeTaskExists() {
        return activeTaskLocal.display !== undefined
    }

    onTooltipTextTypeChanged: updateTooltip()

    function updateTooltip() {
        if (tooltipTextType === 1) {
            tooltipText = replaceTitle(activeTask().display || '')
        } else if (tooltipTextType === 2) {
            tooltipText = activeTask().AppName || ''
        } else {
            tooltipText = ''
        }
    }

    function updateActiveWindowInfo() {

        var activeTaskIndex = tasksModel.activeTask

        // fallback for Plasma 5.8
        var abstractTasksModel = TaskManager.AbstractTasksModel || {}
        var isActive = abstractTasksModel.IsActive || 271
        var appName = abstractTasksModel.AppName || 258
        var isMaximized = abstractTasksModel.IsMaximized || 276
        var virtualDesktop = abstractTasksModel.VirtualDesktop || 286

        if (!tasksModel.data(activeTaskIndex, isActive)) {
            activeTaskLocal = {}
        } else {
            activeTaskLocal = {
                display: tasksModel.data(activeTaskIndex, Qt.DisplayRole),
                decoration: tasksModel.data(activeTaskIndex, Qt.DecorationRole),
                AppName: tasksModel.data(activeTaskIndex, appName),
                IsMaximized: tasksModel.data(activeTaskIndex, isMaximized),
                VirtualDesktop: tasksModel.data(activeTaskIndex, virtualDesktop)
            }
        }

        var actTask = activeTask()
        noWindowActive = !activeTaskExists()
        currentWindowMaximized = !noWindowActive && actTask.IsMaximized === true
        isActiveWindowPinned = actTask.VirtualDesktop === -1;
        if (noWindowActive) {
            windowTitleText.text = plasmoid.configuration.noWindowText
            iconItem.source = plasmoid.configuration.noWindowIcon
        } else {
            windowTitleText.text = textType === 1 ? actTask.AppName : replaceTitle(actTask.display)
            iconItem.source = actTask.decoration
        }
        updateTooltip()
    }

    function toggleMaximized() {
        tasksModel.requestToggleMaximized(tasksModel.activeTask);
    }

    function toggleMinimized() {
        tasksModel.requestToggleMinimized(tasksModel.activeTask);
    }

    function toggleClose() {
        tasksModel.requestClose(tasksModel.activeTask);
    }

    function toggleFullscreen() {
        tasksModel.requestToggleFullScreen(tasksModel.activeTask);
    }

    function togglePinToAllDesktops() {
        tasksModel.requestVirtualDesktop(tasksModel.activeTask, 0);
    }

    function setMaximized(maximized) {
        if ((maximized && !activeTask().IsMaximized)
            || (!maximized && activeTask().IsMaximized)) {
            print('toggle maximized')
            toggleMaximized()
        }
    }

    function setMinimized() {
        if (!activeTask().IsMinimized) {
            toggleMinimized()
        }
    }

    //
    // ACTIVE WINDOW INFO
    //
    Item {
        id: activeWindowListView

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        property double appmenuOffsetLeft: (bp === 0 || bp === 2) ? appmenu.appmenuOffsetWidth : 0
        property double appmenuOffsetRight: (bp === 1 || bp === 3) ? appmenu.appmenuOffsetWidth : 0
        property double controlButtonsAreaWidth: noWindowActive ? 0 : controlButtonsArea.width

        anchors.left: parent.left
        anchors.leftMargin: buttonsStandalone && (bp === 0 || bp === 2) && (!slidingIconAndText || controlButtonsArea.mouseInWidget || doNotHideControlButtons) && (canShowButtonsAccordingMaximized || !slidingIconAndText) ? controlButtonsAreaWidth + appmenuOffsetLeft : 0 + appmenuOffsetLeft
        anchors.right: parent.right
        anchors.rightMargin: buttonsStandalone && (bp === 1 || bp === 3) && (!slidingIconAndText || controlButtonsArea.mouseInWidget || doNotHideControlButtons) && (canShowButtonsAccordingMaximized || !slidingIconAndText) ? controlButtonsAreaWidth + appmenuOffsetRight : 0 + appmenuOffsetRight

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

        width: parent.width - anchors.leftMargin - anchors.rightMargin

        opacity: appmenu.visible && !appmenuNextToIconAndText ? plasmoid.configuration.appmenuIconAndTextOpacity : 1

        Item {
            width: parent.width
            height: main.height

            // window icon
            PlasmaCore.IconItem {
                id: iconItem

                anchors.left: parent.left
                anchors.leftMargin: windowIconOnTheRight ? parent.width - iconItem.width : 0

                width: parent.height
                height: parent.height

                source: plasmoid.configuration.noWindowIcon
                visible: plasmoid.configuration.showWindowIcon
            }

            // window title
            PlasmaComponents.Label {
                id: windowTitleText

                property double iconMargin: (plasmoid.configuration.showWindowIcon ? iconItem.width : 0)
                property double properWidth: parent.width - iconMargin - iconAndTextSpacing
                property double properHeight: parent.height
                property bool noElide: fitText === 2 || (fitText === 1 && mouseHover)
                property int allowFontSizeChange: 3
                property int minimumPixelSize: 8
                property double iconMarginForAnchor: noWindowActive && plasmoid.configuration.noWindowIcon === '' ? 0 : iconMargin
                property bool limitTextWidth: plasmoid.configuration.limitTextWidth
                property int textWidthLimit: plasmoid.configuration.textWidthLimit
                property double computedWidth: limitTextWidth ? (implicitWidth > textWidthLimit ? textWidthLimit : implicitWidth) : properWidth

                anchors.left: parent.left
                anchors.leftMargin: windowIconOnTheRight ? 0 : iconMarginForAnchor + iconAndTextSpacing
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                text: plasmoid.configuration.noWindowText
                wrapMode: Text.Wrap
                width: computedWidth
                elide: noElide ? Text.ElideNone : Text.ElideRight
                visible: plasmoid.configuration.showWindowTitle
                font.pixelSize: fontPixelSize
                font.pointSize: -1
                font.weight: fontBold || (appmenuBoldTitleWhenMenuDisplayed && appmenu.visible) ? Font.Bold : theme.defaultFont.weight
                font.family: fontFamily || theme.defaultFont.family

                onTextChanged: {
                    font.pixelSize = fontPixelSize
                    allowFontSizeChange = 3
                }

                onNoElideChanged: {
                    font.pixelSize = fontPixelSize
                    allowFontSizeChange = 3
                }

                onPaintedHeightChanged: {
                    if (allowFontSizeChange > 0 && noElide && paintedHeight > properHeight) {
                        var newPixelSize = (properHeight / paintedHeight) * fontPixelSize
                        font.pixelSize = newPixelSize < minimumPixelSize ? minimumPixelSize : newPixelSize
                    }
                    allowFontSizeChange--
                }
            }

        }
    }

    function replaceTitle(title) {
        if (!plasmoid.configuration.useWindowTitleReplace) {
            return title
        }
        return title.replace(new RegExp(plasmoid.configuration.replaceTextRegex), plasmoid.configuration.replaceTextReplacement);
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onEntered: {
            mouseHover = true
            controlButtonsArea.mouseInWidget = showControlButtons && !noWindowActive
        }

        onExited: {
            mouseHover = false
            controlButtonsArea.mouseInWidget = false
        }

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                if (wheelUpMaximizes) {
                    setMaximized(true)
                }
            } else {
                if (wheelDownMinimizes) {
                    setMinimized()
                } else if (wheelDownUnmaximizes) {
                    setMaximized(false)
                }
            }
        }

        onDoubleClicked: {
            if (doubleClickMaximizes && mouse.button == Qt.LeftButton) {
                toggleMaximized()
            }
        }

        onClicked: {
            if (chosenLeftClickSource !== '' && !doubleClickMaximizes && mouse.button == Qt.LeftButton) {
                shortcutDS.connectedSources.push(chosenLeftClickSource)
                controlButtonsArea.mouseInWidget = false
                return
            }
            if (mouse.button == Qt.MiddleButton) {
                if (middleClickFullscreen) {
                    toggleFullscreen()
                } else if (middleClickClose) {
                    toggleClose()
                }
            }
        }

        PlasmaCore.ToolTipArea {

            anchors.fill: parent

            active: tooltipTextType > 0 && tooltipText !== ''
            interactive: true
            location: plasmoid.location

            mainItem: Row {

                spacing: 0

                Layout.minimumWidth: fullText.width + units.largeSpacing
                Layout.minimumHeight: childrenRect.height
                Layout.maximumWidth: Layout.minimumWidth
                Layout.maximumHeight: Layout.minimumHeight

                Item {
                    width: units.largeSpacing / 2
                    height: 2
                }

                PlasmaComponents.Label {
                    id: fullText
                    text: tooltipText
                }
            }
        }

        AppMenu {
            id: appmenu
        }

        ListView {
            id: controlButtonsArea

            property bool mouseInWidget: false
            property double controlButtonsHeight: parent.height * buttonSize

            orientation: ListView.Horizontal
            visible: showControlButtons && (doNotHideControlButtons || mouseInWidget || appmenu.visible) && (currentWindowMaximized || !showButtonOnlyWhenMaximized) && !noWindowActive

            spacing: controlButtonsSpacing

            height: buttonsVerticalCenter ? parent.height : controlButtonsHeight
            width: controlButtonsHeight + ((controlButtonsModel.count - 1) * (controlButtonsHeight + controlButtonsSpacing))

            anchors.top: parent.top
            anchors.left: parent.left

            anchors.leftMargin: (bp === 1 || bp === 3) ? parent.width - width : 0
            anchors.topMargin: (bp === 2 || bp === 3) ? parent.height - height : 0

            model: controlButtonsModel

            delegate: ControlButton { }
        }

    }

    ListModel {
        id: controlButtonsModel
    }

    function addButton(preparedArray, buttonName) {
        if (buttonName === 'close') {
            preparedArray.push({
                iconName: 'close',
                windowOperation: 'close'
            });
        } else if (buttonName === 'maximize' && showMaximize) {
            preparedArray.push({
                iconName: 'maximize',
                windowOperation: 'toggleMaximized'
            });
        } else if (buttonName === 'minimize' && showMinimize) {
            preparedArray.push({
                iconName: 'minimize',
                windowOperation: 'toggleMinimized'
            });
        } else if ((buttonName === 'pin' || buttonName === 'alldesktops') && showPinToAllDesktops) {
            preparedArray.push({
                iconName: 'alldesktops',
                windowOperation: 'togglePinToAllDesktops'
            });
        }
    }

    function initializeControlButtonsModel() {

        var preparedArray = []
        buttonOrder.split('|').forEach(function (buttonName) {
            addButton(preparedArray, buttonName);
        });

        controlButtonsModel.clear()

        if (bp === 1 || bp === 3) {
            for (var i = preparedArray.length - 1; i >= 0; i--) {
                controlButtonsModel.append(preparedArray[i])
            }
        } else {
            for (var i = 0; i < preparedArray.length; i++) {
                controlButtonsModel.append(preparedArray[i])
            }
        }
    }

    function performActiveWindowAction(windowOperation) {
        if (bp === 4 || !controlButtonsArea.visible) {
            return;
        }
        if (windowOperation === 'close') {
            toggleClose()
        } else if (windowOperation === 'toggleMaximized') {
            toggleMaximized()
        } else if (windowOperation === 'toggleMinimized') {
            toggleMinimized()
        } else if (windowOperation === 'togglePinToAllDesktops') {
            togglePinToAllDesktops()
        }
    }

    function action_close() {
        toggleClose()
    }

    function action_maximise() {
        toggleMaximized()
    }

    function action_minimise() {
        toggleMinimized()
    }

    function action_pinToAllDesktops() {
        togglePinToAllDesktops()
    }

    Component.onCompleted: {
        initializeControlButtonsModel()
        updateActiveWindowInfo()
        plasmoid.setAction('close', i18n('Close'), 'window-close');
        plasmoid.setAction('maximise', i18n('Toggle Maximise'), 'arrow-up-double');
        plasmoid.setAction('minimise', i18n('Minimise'), 'draw-arrow-down');
        plasmoid.setAction('pinToAllDesktops', i18n('Toggle Pin To All Desktops'), 'window-pin');
    }

    onShowMaximizeChanged: initializeControlButtonsModel()
    onShowMinimizeChanged: initializeControlButtonsModel()
    onShowPinToAllDesktopsChanged: initializeControlButtonsModel()
    onBpChanged: initializeControlButtonsModel()
    onButtonOrderChanged: initializeControlButtonsModel()

    PlasmaCore.DataSource {
        id: shortcutDS
        engine: 'executable'

        property string presentWindows: 'qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Expose"'
        property string presentWindowsAll: 'qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "ExposeAll"'
        property string presentWindowsClass: 'qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "ExposeClass"'

        connectedSources: []

        onNewData: {
            connectedSources.length = 0
        }
    }

}
