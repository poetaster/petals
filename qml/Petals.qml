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

import 'petals.js' as GameLib
import 'util.js' as Util

Item {
    id: main

    property alias running: usedTimeTimer.running
    property alias messageOpacity: message.opacity

    // Game state
    property int possible: 0
    property variant score: {0: 0}

    property int usedHints: 0
    property int usedTime: 0

    property int gameType: 0
    property int scoreLimit: 0
    property int timeLimit: 0

    property int difficulty: 0
    property int players: 1
    property int currentPlayer: -1

    onCurrentPlayerChanged: {
        if (currentPlayer !== -1) {
            message.opacity = 0;
        }
    }

    function finishGame() {
        var props = {
            "players": players,

            "gameType": gameType,
            "scoreLimit": scoreLimit,
            "timeLimit": timeLimit,

            "difficulty": difficulty,

            "score": score,
            "usedTime": usedTime,

            "usedHints": usedHints,
        };
        stagePack.push_qml('ResultsScreen.qml', props, true);
    }

    onUsedTimeChanged: {
        if (timeLimit > 0 && usedTime >= timeLimit*60) {
            finishGame();
        }
    }

    onScoreChanged: {
        if (scoreLimit > 0) {
            for (var i=0; i<score.length; i++) {
                if (score[i] >= scoreLimit) {
                    finishGame();
                }
            }
        }
    }

    function request_hint() {
        var game = GameLib.Petals.game;
        if (game.request_hint()) {
            usedHints += 1;
        }
    }

    function new_game() {
        var game = GameLib.Petals.game;
        game.restart();
        usedHints = 0;
        usedTimeTimer.restart();
        usedTime = 0;
        message.opacity = 0;
    }

    Timer {
        id: usedTimeTimer
        running: true
        repeat: true
        onTriggered: main.usedTime += 1;
        interval: 1000
    }

    Item {
        id: layout
        visible: false

        width: (parent.width * .9 - spacing * (GameLib.Petals.Columns - 1)) / GameLib.Petals.Columns
        height: (parent.height * .9 - spacing * (GameLib.Petals.Rows - 1)) / GameLib.Petals.Rows

        property int spacing: 10
        property int leftBorder: (parent.width - ((width + spacing) * GameLib.Petals.Columns) + spacing) / 2
        property int topBorder: (parent.height - ((height + spacing) * GameLib.Petals.Rows) + spacing) / 2
    }

    MenuLabel {
        anchors.centerIn: parent
        visible: !platformWindow.active
        text: 'Game paused'
    }

    Repeater {
        id: repeater

        delegate: Rectangle {
            color: modelData.selected ? '#535759' : '#ffffff'

            x: layout.leftBorder + modelData.x * (layout.width + layout.spacing)
            y: layout.topBorder + modelData.y * (layout.height + layout.spacing)

            width: layout.width
            height: layout.height

            Image {
                anchors.fill: parent

                fillMode: Image.PreserveAspectFit
                smooth: true

                source: Util.cardImageUrl(modelData)
            }

            visible: layout.width > 0 && layout.height > 0 && platformWindow.active

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (main.players === 1 && main.currentPlayer === -1) {
                        main.currentPlayer = 0;
                    }

                    if (main.currentPlayer !== -1) {
                        var x = modelData.x;
                        var y = modelData.y;
                        GameLib.Petals.game.clickCard(x, y, main.currentPlayer);
                    } else {
                        messageText.text = 'Select a player first.';
                        message.opacity = 1;
                    }
                }
            }
        }
    }

    Item {
        id: flyaway

        Timer {
            repeat: true
            running: flyaway.children.length > 0
            interval: 1000/60
            onTriggered: {
                var trash = [];

                for (var i=0; i<flyaway.children.length; i++) {
                    var card = flyaway.children[i];

                    card.scale *= .95;
                    if (card.scale < .1) {
                        trash.push(card);
                    }
                }

                for (var i=0; i<trash.length; i++) {
                    trash[i].destroy();
                }
            }
        }
    }

    Rectangle {
        id: message
        anchors {
            left: parent.left
            top: parent.top
        }
        width: stagePack.width
        height: stagePack.height
        z: 100

        opacity: 0
        Behavior on opacity { PropertyAnimation { } }
        enabled: opacity > 0

        color: '#ee000000'

        Text {
            id: messageText
            color: 'white'
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            scale: parent.opacity
            font.pixelSize: platformWindow.scale(30)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.opacity = 0
        }
    }

    function init() {
        function Painter() {
        }

        Painter.prototype.draw = function (cards) {
            repeater.model = cards;
        };

        function on_possible_updated(possible) {
            main.possible = possible;
        }

        function on_score_updated(score) {
            main.score = score;
        }

        function on_error_message(error_message) {
            messageText.text = '<b>Not all-distinct or all-equal:</b><br>';
            messageText.text += error_message.join('<br>');
            message.opacity = 1;
        }

        function on_cards_replaced(replaced) {
            replaced.forEach(function (card) {
                var item = Qt.createQmlObject('import QtQuick 2.0; Image { opacity: Math.sqrt(scale) }', flyaway);
                item.x = layout.leftBorder + card.x * (layout.width + layout.spacing);
                item.y = layout.topBorder + card.y * (layout.height + layout.spacing);

                item.sourceSize.width = layout.width;
                item.sourceSize.height = layout.height;

                card.selected = false;
                item.source = Util.cardImageUrl(card);
            });

            main.currentPlayer = -1;
        }

        var painter = new Painter();

        GameLib.Petals.game = new GameLib.Petals.Game(painter,
                on_possible_updated, on_score_updated,
                on_error_message, on_cards_replaced,
                main.players, main.difficulty);
        GameLib.Petals.game.draw();
    }
}
