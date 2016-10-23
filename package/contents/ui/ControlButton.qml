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
import org.kde.plasma.core 2.0 as PlasmaCore
//import org.kde.kwin.decoration 0.1

MouseArea {
    id: controlButton

    height: controlButtonsArea.height
    width: controlButtonsArea.controlButtonsHeight

    property bool mouseInside: false
    property bool mousePressed: false

    property bool isPin: iconName === 'pinToAllDesktops'

    property string themeName: textColorLight ? 'breeze-dark' : 'default'
    property string buttonImagePath: isPin ? 'window' : Qt.resolvedUrl('../icons/' + themeName + '/' + iconName + '.svgz')

    PlasmaCore.Svg {
        id: buttonSvg
        imagePath: buttonImagePath
    }

    // icon
    PlasmaCore.SvgItem {
        id: svgItem
        width: parent.width
        height: width
        svg: buttonSvg
        elementId: mouseInside ? 'pressed-center' : 'active-center'
        anchors.verticalCenter: parent.verticalCenter
        visible: !isPin
    }

    Rectangle {
        width: parent.width * 0.8
        height: width
        anchors.centerIn: parent
        color: '#aaaaaa'
        radius: width * 0.5
        visible: isPin && mouseInside
    }

    PlasmaCore.IconItem {
        width: parent.width * 0.6
        height: width
        source: main.isActiveWindowPinned ? 'window-unpin' : 'window-pin'
        anchors.centerIn: parent
        visible: isPin
    }

//     DecorationButton {
//         buttonType: DecorationOptions.DecorationButtonOnAllDesktops
//         anchors.fill: parent
//         visible: isPin
//     }

    hoverEnabled: true

    onEntered: {
        mouseInside = true
    }

    onExited: {
        mouseInside = false
    }

    // trigger active window action
    onClicked: {
        controlButtonsArea.mouseInWidget = true
        main.performActiveWindowAction(windowOperation)
    }
}
