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

import 'constants.js' as Constants

Item {
    id: screen

    property bool hasBackButton: true

    width: platformWindow.width
    height: platformWindow.height

    function setSlide(value) {
        rotationTransform.angle = 90*value;
        opacity = 1-Math.abs(value);
        anchors.leftMargin = stagePack.width / 4 * value;
    }

    transform: Rotation {
        id: rotationTransform

        axis {
            x: 0
            y: 1
            z: 0
        }

        origin {
            x: width/2
            y: height/2
            z: 0
        }
    }
}
