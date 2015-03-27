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
import org.kde.plasma.core 2.0 as PlasmaCore

MouseArea {
    id: controlButton
    
    property string iconElementId
    property string windowOperation
    
    height: parent.height
    width: height
    
    anchors.top: parent.top
    anchors.left: parent.left
    
    property bool mouseInside: false
    
    // close icon
    PlasmaCore.SvgItem {
        id: svgItem
        width: parent.width
        height: width
        svg: PlasmaCore.Svg {
            //prefix is: /usr/share/plasma/desktoptheme/default/
            imagePath: 'widgets/configuration-icons'
        }
        elementId: iconElementId
        visible: controlButtonsArea.mouseInside
    }
    
    // close icon has now better visibility
    BrightnessContrast {
        id: svgItemEffect
        anchors.fill: svgItem
        source: svgItem
        brightness: 0.5
        contrast: 0.5
        visible: mouseInside
    }
    
    hoverEnabled: true
    
    onEntered: {
        mouseInside = true
        //svgItemEffect.visible = svgItem.visible
    }
    
    onExited: {
        mouseInside = false
        //svgItemEffect.visible = false
    }
    
    // trigger close active window
    onClicked: {
        if (bp === 4) {
            return;
        }
        var service = tasksSource.serviceForSource('tasks')
        var operation = service.operationDescription(windowOperation)
        operation.Id = tasksSource.models.tasks.activeTaskId()
        service.startOperationCall(operation)
    }
}