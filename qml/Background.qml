/**
 * Petals: A brain-teasing puzzle for 1-4 players
 * Copyright (C) 2013, 2015 Thomas Perl <m@thp.io>
 * http://thp.io/2013/petals/
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

import QtQuick 2.0

Screen {
    property alias color: main.color

    Rectangle {
        id: main
        property int current: 0
        property variant colors: ['#136779']
        color: Qt.darker(colors[current], 3)
        anchors.fill: parent

        Repeater {
            model: 5

            Rectangle {
                id: centerRect
                property real baseRotation: 0

                width: parent.width/2
                height: width
                anchors.centerIn: parent
                anchors.verticalCenterOffset: (2-index)*200
                anchors.horizontalCenterOffset: Math.sin((2-index)*baseRotation*Math.PI/180)*200 + (2-index)*40
                color: Qt.lighter(parent.color, 1.2)
                rotation: baseRotation + 10* index

                PropertyAnimation {
                    target: centerRect
                    property: 'baseRotation'
                    running: true
                    paused: !platformWindow.active
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: fader.interval * 2
                }
            }
        }


        Timer {
            id: fader
            interval: 30000
            repeat: true
            running: platformWindow.active
            onTriggered: {
                main.current = (main.current + 1) % main.colors.length;
            }
        }

        Behavior on color { ColorAnimation { duration: fader.interval } }
    }
}
