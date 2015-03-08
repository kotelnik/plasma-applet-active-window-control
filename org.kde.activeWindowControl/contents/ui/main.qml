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
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main
    anchors.fill: parent
    Layout.preferredWidth: 200
    
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    //
    // MODEL
    //
    PlasmaCore.DataSource {
        id: tasksSource
        engine: "tasks"
        onSourceAdded: {
            connectSource(source);
        }
        connectedSources: "tasks"
    }
    // should return always one item
    PlasmaCore.SortFilterModel {
        id: activeWindowModel
        filterRole: "Active"
        filterRegExp: "true"
        sourceModel: tasksSource.models.tasks
    }

    //
    // CLOSE area
    //
    MouseArea {
        id: closeArea
        anchors.top: parent.top
        anchors.left: parent.left
        
        width: parent.height
        height: parent.height
        
        PlasmaCore.SvgItem {
            id: closeSvgItem
            width: parent.height
            height: parent.height
            svg: PlasmaCore.Svg {
                //prefix is: /usr/share/plasma/desktoptheme/default/
                imagePath: "icons/window"
            }
        }
        
        onClicked: {
            var service = tasksSource.serviceForSource("tasks");
            var operation = service.operationDescription("close");
            operation.Id = tasksSource.models.tasks.activeTaskId();
            print('closing window with id: ' + operation.Id);
            service.startOperationCall(operation);
        }
    }
    
    //
    // ACTIVE WINDOW INFO
    //
    ListView {
        id: activeWindowListView
        anchors {
            top: parent.top
            left: closeArea.right
            bottom: parent.bottom
            right: parent.right
        }
        width: parent.width - closeSvgItem.width
        focus: true
        spacing: 0
        
        model: activeWindowModel
        
        delegate: Item {
            width: parent.width
            height: main.height
            
            // icon
            PlasmaCore.IconItem {
                id: iconItem
                
                anchors {
                    top: parent.top
                    right: parent.right
                }
                
                width: main.height*0.5
                height: main.height*0.5
                
                source: DecorationRole
            }
            
            // window title
            Text {
                id: windowTitleText
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                text: DisplayRole
                color: theme.textColor
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                width: parent.width
                elide: Text.ElideRight
            }
        }
    }
}
