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

Item {
    id: choice

    width: platformWindow.sx(200)
    height: platformWindow.sy(80)

    property alias model: repeater.model
    property int selected: 0

    property real targetWidth: width / model.length

    Row {
        id: row
        anchors.fill: parent

        Repeater {
            id: repeater

            Rectangle {
                height: row.height
                width: choice.targetWidth

                property bool selected: choice.selected === index
                Text {
                    anchors.centerIn: parent
                    text: modelData ? modelData : '-'
                    color: selected ? 'white' : '#999999'
                    font.pixelSize: platformWindow.scale(30)
                }

                color: selected ? '#66aaaaaa' : '#99333333'

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        choice.selected = index;
                    }
                }
            }
        }
    }
}
