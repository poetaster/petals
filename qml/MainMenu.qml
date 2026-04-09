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
    Text {
        y: platformWindow.sy(45)
        color: Qt.lighter(background.color, 4)
        text: 'Petals'
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        styleColor: Qt.lighter(background.color, 5)
        font.strikeout: false
        font.underline: false
        font.italic: false
        font.bold: false
        style: Text.Raised
        font.pixelSize: platformWindow.scale(51)
    }

    SimpleButton {
        id: newGame
        text: "New Game"
        anchors.horizontalCenterOffset: 0
        onClicked: stagePack.push_qml('SetupScreen.qml')

        y: platformWindow.sy(195)
        width: platformWindow.sx(344)
        height: platformWindow.sy(98)

        anchors.horizontalCenter: parent.horizontalCenter
    }

    SimpleButton {
        id: highScores
        text: "High Scores"
        anchors.horizontalCenterOffset: 0
        onClicked: stagePack.push_qml('HighScoresScreen.qml')

        y: platformWindow.sy(318)
        width: newGame.width
        height: newGame.height
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SimpleButton {
        id: help
        text: "How to Play"
        anchors.horizontalCenterOffset: 0
        onClicked: stagePack.push_qml('HelpScreen.qml')

        y: highScores.y + highScores.height + (highScores.y - (newGame.y + newGame.height))
        width: newGame.width
        height: newGame.height

        anchors.horizontalCenter: parent.horizontalCenter
    }

    SimpleButton {
        id: about
        text: "About"
        anchors.horizontalCenterOffset: 0
        onClicked: stagePack.push_qml('AboutScreen.qml')

        y: help.y + help.height + (highScores.y - (newGame.y + newGame.height))
        width: newGame.width
        height: newGame.height

        anchors.horizontalCenter: parent.horizontalCenter
    }
}
