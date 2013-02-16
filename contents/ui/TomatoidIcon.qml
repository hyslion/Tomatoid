/*
 *   Copyright 2011 Viranch Mehta <viranch.mehta@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtras

Item {
    id: compactItem
    anchors.fill: parent

    property bool showOverlay: true

    property QtObject root: plasmoid.rootItem
    property QtObject timer: plasmoid.rootItem.timer
    property bool timerRunning: seconds > 0 || timer.running
    property int seconds: timer.seconds
    property string taskName: timer.taskName

    property string timeString: Qt.formatTime(new Date(0,0,0,0,0, seconds), "mm:ss")


    property string redIcon: "../icons/tomatoid-icon-red.png"
    property string greyIcon: "drawing.svg"
    property string greenIcon: "../icons/tomatoid-icon-green.png"



    function configChanged() {
        showOverlay = plasmoid.readConfig("showBatteryString");
    }


    function isConstrained() {
        return (plasmoid.formFactor == Vertical || plasmoid.formFactor == Horizontal);
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        property int minimumWidth
        property int minimumHeight
        onClicked: plasmoid.togglePopup()

        PlasmaCore.Theme { id: theme }

        PlasmaCore.IconItem {
            anchors.fill: parent
            source: {
                if(root.inPomodoro)
                    return "tomatoid-running"
                if(root.inBreak)
                    return "tomatoid-break"
                else
                    return "tomatoid-idle"
            }
        }

        /*QtExtras.QIconItem {
            icon: {
                if(root.inPomodoro)
                    return new QIcon(compactItem.redIcon)
                if(root.inBreak)
                    return new QIcon(compactItem.greenIcon)
                else
                    return new QIcon(compactItem.greyIcon)
            }
            anchors.fill: parent
            //fillMode: Image.PreserveAspectFit
            smooth: true
        }

        QtExtras.QIconItem {
            anchors.fill: parent
            icon: QIcon("konqueror")
        }*/

        Item {
            id: batteryContainer
            anchors.centerIn: parent
            property real size: Math.min(parent.width, parent.height)
            width: size
            height: size

            Rectangle {
                id: labelRect
                // should be 40 when size is 90
                width: Math.max(parent.size*4/9, 35)
                height: width/2
                anchors.centerIn: parent
                color: theme.backgroundColor
                border.color: "grey"
                border.width: 2
                radius: 4
                opacity: timerRunning ?
                (showOverlay ? 0.5 : (isConstrained() ? 0 : mouseArea.containsMouse*0.7)) : 0

                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Text {
                id: overlayText
                text: timeString
                color: theme.textColor
                font.pixelSize: Math.max(batteryContainer.size/8, 11)
                anchors.centerIn: labelRect
                opacity: labelRect.opacity > 0 ? 1 : 0
            }
        }
    }
}