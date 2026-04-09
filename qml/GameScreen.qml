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

import 'util.js' as Util
import 'constants.js' as Constants

Screen {
    id: gameScreen
    property int players: 1
    property int difficulty: 0
    property int gameType: 0
    property int duration: 0

    function requestClose() {
        stagePack.push_qml('ConfirmCloseScreen.qml');
    }

    Item {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: platformWindow.scale(20)
        }

        height: platformWindow.sy(40)

        Text {
            color: 'white'
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            text: {
                if (main.scoreLimit !== 0) {
                    if (main.players === 1) {
                        'Score: ' + main.score[0] + ' / ' + main.scoreLimit
                    } else {
                        'Game to ' + main.scoreLimit
                    }
                } else {
                    'Score: ' + main.score[0]
                }
            }

            font.pixelSize: parent.height * .8

            visible: (main.players === 1) || (main.scoreLimit !== 0)
        }

        Text {
            color: 'white'
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: {
                if (main.timeLimit !== 0) {
                    Util.formatTime(main.usedTime) + ' / ' + Util.formatTime(main.timeLimit*60)
                } else {
                    Util.formatTime(main.usedTime)
                }
            }

            font.pixelSize: parent.height * .8
            visible: (main.players === 1) || (main.timeLimit !== 0)
        }
    }

    Petals {
        id: main
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: playerButtons.top
        }

        Component.onCompleted: {
            main.players = gameScreen.players;
            main.difficulty = gameScreen.difficulty;
            if (gameScreen.gameType === Constants.TimeLimitMode) {
                main.timeLimit = Constants.TimeLimits[gameScreen.duration];
            } else if (gameScreen.gameType === Constants.ScoreLimitMode) {
                main.scoreLimit = Constants.ScoreLimits[gameScreen.duration];
            }
            main.gameType = gameScreen.gameType;
            init();
        }

        running: (stagePack.activePage === gameScreen) && platformWindow.active
    }

    Row {
        id: playerButtons
        anchors {
            left: parent.left
            right: parent.right
            bottom: footer.top
            margins: platformWindow.scale(10)
        }
        spacing: platformWindow.sx(10)
        height: (main.players > 1) ? parent.height * .2 : 0
        visible: height > 0
        opacity: (main.currentPlayer !== -1) ? (1-main.messageOpacity) : 1

        property int targetWidth: (width-(main.players-1)*spacing) / main.players

        Repeater {
            model: main.players
            anchors.margins: platformWindow.sx(10)

            delegate: SimpleButton {
                width: playerButtons.targetWidth
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }

                text: '<small>Player ' + (modelData+1) + '<br>Score: ' + main.score[index] + '</small>'
                color: (main.currentPlayer === index) ? '#aa339933' : '#88000000'

                onClicked: {
                    if (main.currentPlayer === index) {
                        main.currentPlayer = -1;
                    } else {
                        main.currentPlayer = index;
                    }
                }
            }
        }
    }
}
