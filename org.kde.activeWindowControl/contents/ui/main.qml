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

MouseArea {
    id: main
    
    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    
    anchors.fill: parent
    Layout.preferredWidth: vertical ? parent.width : Screen.width * 0.12
    Layout.preferredHeight: vertical ? Math.min(theme.defaultFont.pointSize * 4, parent.width) : parent.height
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    
    property int cbp: plasmoid.configuration.closeButtonPosition;
    
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
            var noWindowVisible = count === 0
            closeArea.visible = !noWindowVisible
            noWindowText.visible = noWindowVisible
        }
    }
    
    Text {
        id: noWindowText
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: i18n('No active window')
        color: theme.textColor
        width: parent.width
        elide: Text.ElideRight
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
                
                width: parent.height
                height: parent.height
                
                source: DecorationRole
            }
            
            // window title
            Text {
                id: windowTitleText
                anchors {
                    left: iconItem.right
                    verticalCenter: parent.verticalCenter
                }
                text: DisplayRole
                color: theme.textColor
                wrapMode: Text.WordWrap
                maximumLineCount: parent.height / 20
                width: parent.width - iconItem.width
                elide: Text.ElideRight
            }
        }
    }


    //
    // CLOSE area
    //
    MouseArea {
        id: closeArea
        
        anchors.top: parent.top
        anchors.left: parent.left
        
        width: parent.height * 0.4
        height: width
        
        anchors.leftMargin: (cbp === 1 || cbp === 3) ? parent.width - width : 0
        anchors.topMargin: (cbp === 2 || cbp === 3) ? parent.height - height : 0
        
        // close icon
        PlasmaCore.SvgItem {
            id: closeSvgItem
            width: parent.width
            height: width
            svg: PlasmaCore.Svg {
                //prefix is: /usr/share/plasma/desktoptheme/default/
                imagePath: 'widgets/configuration-icons'
            }
            elementId: 'close'
            visible: false
        }
        
        // close icon has now better visibility
        BrightnessContrast {
            id: closeSvgItemEffect
            anchors.fill: closeSvgItem
            source: closeSvgItem
            brightness: 0.5
            contrast: 0.5
            visible: false
        }
        
        hoverEnabled: true
        
        onEntered: {
            closeSvgItemEffect.visible = true
        }
        
        onExited: {
            closeSvgItemEffect.visible = false
        }
        
        // trigger close active window
        onClicked: {
            if (cbp === 4) {
                return;
            }
            var service = tasksSource.serviceForSource('tasks');
            var operation = service.operationDescription('close');
            operation.Id = tasksSource.models.tasks.activeTaskId();
            service.startOperationCall(operation);
        }
    }
    
    hoverEnabled: true
    
    onEntered: {
        closeSvgItem.visible = plasmoid.configuration.closeButtonPosition !== 4
    }
    
    onExited: {
        closeSvgItem.visible = false
    }
}
