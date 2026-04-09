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
    property bool hasBackButton: false

    MenuLabel {
        id: question
        text: "Game paused"

        y: platformWindow.sy(208)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SimpleButton {
        id: firstButton
        text: "Continue"
        onClicked: stagePack.pop();

        y: platformWindow.sy(313)
        width: platformWindow.sx(257)
        height: platformWindow.sy(114)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SimpleButton {
        id: secondButton
        text: "Quit to Menu"
        onClicked: stagePack.pop(2);

        y: platformWindow.sy(445)
        width: firstButton.width
        height: firstButton.height
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
