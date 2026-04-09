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

Screen {
    id: setupScreen

    MenuLabel {
        text: "Number of Players"
        anchors.bottom: playerChoice.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Choice {
        id: playerChoice
        y: platformWindow.sy(68)
        width: platformWindow.sx(425)
        height: platformWindow.sy(80)
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        model: ['1', '2', '3', '4']
    }

    MenuLabel {
        text: "Game Type"
        anchors.bottom: gameType.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Choice {
        id: gameType
        y: platformWindow.sy(214)
        width: playerChoice.width
        height: playerChoice.height
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        // must be in line with what's defined in constants.js
        model: ['Time Limit', 'Score Limit']
    }

    MenuLabel {
        text: "Game Duration"
        anchors.bottom: duration.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Choice {
        id: duration
        y: gameType.y + (gameType.y - playerChoice.y)
        width: playerChoice.width
        height: playerChoice.height
        anchors.horizontalCenter: parent.horizontalCenter
        model: (gameType.selected === 0) ? setupScreen.getHighScoreDurations() : setupScreen.getTimeAttackDurations()
    }

    MenuLabel {
        text: "Difficulty"
        anchors.bottom: difficulty.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Choice {
        id: difficulty
        y: duration.y + (gameType.y - playerChoice.y)
        width: playerChoice.width
        height: playerChoice.height
        anchors.horizontalCenter: parent.horizontalCenter
        model: Constants.DifficultyLevels
    }

    function getHighScoreDurations() {
        var result = [];
        for (var i=0; i<Constants.TimeLimits.length; i++) {
            result.push('' + Constants.TimeLimits[i] + ' min');
        }
        return result;
    }

    function getTimeAttackDurations() {
        var result = [];
        for (var i=0; i<Constants.ScoreLimits.length; i++) {
            result.push('' + Constants.ScoreLimits[i] + ' pts');
        }
        return result;
    }

    SimpleButton {
        id: simplebutton1
        y: platformWindow.sy(649)
        width: platformWindow.sx(280)
        height: platformWindow.sy(113)
        text: "Start Game"
        anchors.right: difficulty.right
        onClicked: {
            var props = {
                "players": playerChoice.selected + 1,
                "difficulty": difficulty.selected,
                "gameType": gameType.selected,
                "duration": duration.selected,
            };
            stagePack.push_qml('GameScreen.qml', props, true);
        }
    }
}
