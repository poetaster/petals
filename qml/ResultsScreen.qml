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
import 'highscores.js' as HighScores
import 'util.js' as Util

Screen {
    id: resultsScreen

    property variant score: {0: 0}

    property int usedHints: 0
    property int usedTime: 0

    property int gameType: 0
    property int scoreLimit: 0
    property int timeLimit: 0

    property int difficulty: 0
    property int players: 1

    MenuLabel {
        anchors.centerIn: parent
        color: 'white'
        font.pixelSize: platformWindow.scale(51)
        text: {
            var result = ['Game over', ''];

            if (players === 1) {
                // single player
                result.push('Final score: ' + resultsScreen.score[0] + ' pts');
                result.push('Total time: ' + Util.formatTime(resultsScreen.usedTime));
            } else {
                // multiplayer
                var winner = [];
                var best = 0;
                for (var i=0; i<resultsScreen.score.length; i++) {
                    var score = resultsScreen.score[i];
                    result.push('Player ' + (i+1) + ': ' + score + ' pts');
                    if (score > best) {
                        winner = ['Player ' + (i+1)];
                        best = score;
                    } else if (score === best) {
                        winner.push('Player ' + (i+1));
                    }
                }


                if (best > 0 || true) {
                    result.push('');
                    if (winner.length === 1) {
                        result.push('Winner: ' + winner[0]);
                    } else {
                        result.push('Winners:\n - ' + winner.join('\n - '));
                    }
                }
            }

            result.join('\n')
        }
    }

    Component.onCompleted: {
        if (players === 1) {
            if (gameType === Constants.TimeLimitMode) {
                HighScores.saveHighScore(difficulty, timeLimit, 0, score[0]);
            } else if (gameType === Constants.ScoreLimitMode) {
                HighScores.saveHighScore(difficulty, 0, scoreLimit, usedTime);
            }
        }
    }
}
