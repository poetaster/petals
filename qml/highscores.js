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

// http://kunalmaemo.blogspot.com/2013/03/using-localstorage-api-from-javascipt.html
.import QtQuick.LocalStorage 2.0 as Sql

var DB_NAME = 'PetalsHighScore';
var DB_VERS = '1.0.0';
var DB_DESC = 'Highscores for Petals';
var DB_SIZE = 100000;

function initDB(tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS HighScores (difficulty INTEGER, timelimit INTEGER, scorelimit INTEGER, value INTEGER)');
}

function saveHighScore(difficulty, timelimit, scorelimit, value) {
    // one of timelimit or scorelimit is 0

    var db = Sql.LocalStorage.openDatabaseSync(DB_NAME, DB_VERS, DB_DESC, DB_SIZE);
    db.transaction(function (tx) {
        initDB(tx);
        var params = [difficulty, timelimit, scorelimit, value];
        if (timelimit === 0) {
            // score-limited round (lowest time wins - remove all higher times)
            tx.executeSql('DELETE FROM HighScores WHERE difficulty=? AND timelimit=? AND scorelimit=? AND value >= ?', params);
        } else if (scorelimit === 0) {
            // time-limited round (highest score wins - remove all lower scores)
            tx.executeSql('DELETE FROM HighScores WHERE difficulty=? AND timelimit=? AND scorelimit=? AND value <= ?', params);
        }

        tx.executeSql('INSERT INTO HighScores VALUES (?, ?, ?, ?)', params);
    });
}

function getAllHighScores(callback) {
    // one of timelimit or scorelimit is 0

    var db = Sql.LocalStorage.openDatabaseSync(DB_NAME, DB_VERS, DB_DESC, DB_SIZE);
    db.transaction(function (tx) {
        initDB(tx);
        var rs = tx.executeSql('SELECT * FROM HighScores');
        var highscores = [];
        for (var i=0; i<rs.rows.length; i++) {
            var item = rs.rows.item(i);
            highscores.push({difficulty: parseInt(item.difficulty), timelimit: parseInt(item.timelimit), scorelimit: parseInt(item.scorelimit), value: parseInt(item.value)});
        }
        callback(highscores);
    });
}
