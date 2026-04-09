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
import 'highscores.js' as HighScores

Screen {
    id: highScoresScreen
    property variant highscores
    property int version: 0

    function getScoreTimeLimit(difficulty, timelimit, version) {
        var score = 0;

        highscores.forEach(function (item) {
            if (item.difficulty === difficulty && item.timelimit === timelimit) {
                if (item.value > score) {
                    score = item.value;
                }
            }
        });

        return score;
    }

    function getTimeScoreLimit(difficulty, scorelimit, version) {
        var score = 0;

        highscores.forEach(function (item) {
            if (item.difficulty === difficulty && item.scorelimit === scorelimit) {
                if (item.value < score || score === 0) {
                    score = item.value;
                }
            }
        });

        return score;
    }

    Component.onCompleted: {
        HighScores.getAllHighScores(function (highscores) {
            highScoresScreen.highscores = highscores;
            highScoresScreen.version = highScoresScreen.version + 1;
        });
    }

    Column {
        anchors {
            fill: parent
            margins: platformWindow.scale(30)
        }

        spacing: platformWindow.sy(20)

        Item { height: platformWindow.sy(20); width: 1 }
        MenuLabel { heading: true; text: "Highest Scores" }

        Column {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            spacing: platformWindow.sy(10)

            Repeater {
                model: {
                    var model = [''];
                    Constants.DifficultyLevels.forEach(function (item) {
                        model.push(item);
                    });
                    return model;
                }

                delegate: Row {
                    property int difficulty: index-1
                    spacing: platformWindow.sx(10)
                    Repeater {
                        model: {
                            var model = [''];
                            Constants.TimeLimits.forEach(function (item) {
                                model.push(item);
                            });
                            return model;
                        }
                        delegate: MenuLabel {
                            width: platformWindow.sx((timelimit===-1) ? 100 : 90)
                            property int timelimit: index-1
                            horizontalAlignment: Text.AlignRight
                            text: {
                                if (difficulty === -1 && timelimit === -1) {
                                    ''
                                } else if (difficulty === -1) {
                                    Constants.TimeLimits[timelimit] + ' min'
                                } else if (timelimit === -1) {
                                    Constants.DifficultyLevels[difficulty]
                                } else {
                                    var score = getScoreTimeLimit(difficulty, Constants.TimeLimits[timelimit], version);
                                    if (score === 0) {
                                        '-'
                                    } else {
                                        score
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { height: platformWindow.sy(60); width: 1 }
        MenuLabel { heading: true; text: "Best Times" }

        Column {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            spacing: platformWindow.sy(10)

            Repeater {
                model: {
                    var model = [''];
                    Constants.DifficultyLevels.forEach(function (item) {
                        model.push(item);
                    });
                    return model;
                }

                delegate: Row {
                    property int difficulty: index-1
                    spacing: platformWindow.sx(10)
                    Repeater {
                        model: {
                            var model = [''];
                            Constants.ScoreLimits.forEach(function (item) {
                                model.push(item);
                            });
                            return model;
                        }
                        delegate: MenuLabel {
                            width: platformWindow.sx((scorelimit===-1) ? 100 : 90)
                            property int scorelimit: index-1
                            horizontalAlignment: Text.AlignRight
                            text: {
                                if (difficulty === -1 && scorelimit === -1) {
                                    ''
                                } else if (difficulty === -1) {
                                    Constants.ScoreLimits[scorelimit] + ' pts'
                                } else if (scorelimit === -1) {
                                    Constants.DifficultyLevels[difficulty]
                                } else {
                                    var time = getTimeScoreLimit(difficulty, Constants.ScoreLimits[scorelimit], version);
                                    if (time === 0) {
                                        '-'
                                    } else {
                                        Util.formatTime(time)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
