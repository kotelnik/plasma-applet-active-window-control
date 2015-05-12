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

Item {
    id: main
    
    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    
    property double horizontalScreenWidthPercent: plasmoid.configuration.horizontalScreenWidthPercent
    property double buttonSize: plasmoid.configuration.buttonSize
    
    anchors.fill: parent
    Layout.preferredWidth: vertical ? parent.width : Screen.width * horizontalScreenWidthPercent
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.preferredHeight: vertical ? Math.min(theme.defaultFont.pointSize * 4, parent.width) : parent.height
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    
    property bool noWindowVisible: true
    property int controlButtonsSpacing: plasmoid.configuration.controlButtonsSpacing
    
    property int bp: plasmoid.configuration.buttonsPosition;
    property bool showControlButtons: plasmoid.configuration.showControlButtons
    property bool showMinimize: showControlButtons && plasmoid.configuration.showMinimize
    property bool showMaximize: showControlButtons && plasmoid.configuration.showMaximize
    property bool doubleClickMaximizes: plasmoid.configuration.doubleClickMaximizes
    property bool middleClickFullscreen: plasmoid.configuration.middleClickFullscreen
    property bool wheelUpMaximizes: plasmoid.configuration.wheelUpMaximizes
    property bool wheelDownMinimizes: plasmoid.configuration.wheelDownAction === 1
    property bool wheelDownUnmaximizes: plasmoid.configuration.wheelDownAction === 2
    
    property bool doNotHideControlButtons: plasmoid.configuration.doNotHideControlButtons
    
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    //
    // MODEL
    //
    PlasmaCore.DataSource {
        id: tasksSource
        engine: 'tasks'
        onSourceAdded: {
            connectSource(source);
        }
        connectedSources: 'tasks'
    }
    // should return always one item
    PlasmaCore.SortFilterModel {
        id: activeWindowModel
        filterRole: 'Active'
        filterRegExp: 'true'
        sourceModel: tasksSource.models.tasks
        onCountChanged: {
            noWindowVisible = count === 0
        }
    }
    
    function toggleMaximized() {
        var service = tasksSource.serviceForSource('tasks')
        var operation = service.operationDescription('toggleMaximized')
        operation.Id = tasksSource.models.tasks.activeTaskId()
        service.startOperationCall(operation)
    }
    
    function toggleFullscreen() {
        var service = tasksSource.serviceForSource('tasks')
        var operation = service.operationDescription('toggleFullScreen')
        operation.Id = tasksSource.models.tasks.activeTaskId()
        service.startOperationCall(operation)
    }
    
    function setMaximized(maximized) {
        var service = tasksSource.serviceForSource('tasks')
        var operation = service.operationDescription('setMaximized')
        operation.Id = tasksSource.models.tasks.activeTaskId()
        operation.maximized = maximized
        service.startOperationCall(operation)
    }
    
    function setMinimized() {
        var service = tasksSource.serviceForSource('tasks')
        var operation = service.operationDescription('setMinimized')
        operation.Id = tasksSource.models.tasks.activeTaskId()
        operation.minimized = true
        service.startOperationCall(operation)
    }
    
    Text {
        id: noWindowText
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.left: parent.left
        text: i18n('Plasma Desktop')
        color: theme.textColor
        width: parent.width - 10
        elide: Text.ElideRight
        
        visible: noWindowVisible
    }

    //
    // ACTIVE WINDOW INFO
    //
    ListView {
        id: activeWindowListView
        anchors.fill: parent
        width: parent.width
        
        model: activeWindowModel
        
        delegate: Item {
            width: parent.width
            height: main.height
            
            // window icon
            PlasmaCore.IconItem {
                id: iconItem
                
                anchors.left: parent.left
                anchors.leftMargin: plasmoid.configuration.windowIconOnTheRight ? parent.width - iconItem.width : 0
                
                width: parent.height
                height: parent.height
                
                source: DecorationRole
                visible: plasmoid.configuration.showWindowIcon
            }
            
            // window title
            Text {
                id: windowTitleText
                anchors.left: parent.left
                anchors.leftMargin: plasmoid.configuration.windowIconOnTheRight ? 0 : iconItem.width
                anchors.verticalCenter: parent.verticalCenter
                text: DisplayRole
                color: theme.textColor
                wrapMode: Text.Wrap
                maximumLineCount: Math.max(1, Math.round(parent.height / (theme.defaultFont.pointSize * 2)))
                width: parent.width - iconItem.width
                elide: Text.ElideRight
                font.pointSize: theme.defaultFont.pointSize
                visible: plasmoid.configuration.showWindowTitle
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        
        hoverEnabled: true
        
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        
        onEntered: {
            controlButtonsArea.mouseInWidget = showControlButtons && !noWindowVisible
        }
        
        onExited: {
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
            if (mouse.button == Qt.LeftButton && doubleClickMaximizes) {
                toggleMaximized()
            }
        }
        
        onClicked: {
            if (mouse.button == Qt.MiddleButton && middleClickFullscreen) {
                toggleFullscreen()
            }
        }
        
        
        ListView {
            id: controlButtonsArea
            
            property bool mouseInWidget: false
            
            orientation: ListView.Horizontal
            opacity: doNotHideControlButtons || (showControlButtons && mouseInWidget) ? 1 : 0
            
            spacing: controlButtonsSpacing
            
            height: parent.height * buttonSize
            width: height + ((controlButtonsModel.count - 1) * (height + controlButtonsSpacing))
            
            anchors.top: parent.top
            anchors.left: parent.left
            
            anchors.leftMargin: (bp === 1 || bp === 3) ? parent.width - width : 0
            anchors.topMargin: (bp === 2 || bp === 3) ? parent.height - height : 0
            
            model: controlButtonsModel
            
            delegate: ControlButton {
            }
        }
    }
    
    ListModel {
        id: controlButtonsModel
    }
    
    function initializeControlButtonsModel() {
        var preparedArray = []
        preparedArray.push({
            iconElementId: 'close',
            windowOperation: 'close'
        })
        if (showMaximize) {
            preparedArray.push({
                iconElementId: 'maximize',
                windowOperation: 'toggleMaximized'
            })
        }
        if (showMinimize) {
            preparedArray.push({
                iconElementId: 'remove',
                windowOperation: 'toggleMinimized'
            })
        }
        
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
    
    Component.onCompleted: {
        initializeControlButtonsModel()
    }
    
    onShowMaximizeChanged: {
        initializeControlButtonsModel()
    }
    
    onShowMinimizeChanged: {
        initializeControlButtonsModel()
    }
    
    onBpChanged: {
        initializeControlButtonsModel()
    }
    
}
