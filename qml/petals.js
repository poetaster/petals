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

var Petals = {
    game: null,

    Columns: 3,
    Rows: 4,

    PetalColor: {
        Purple: 0,
        Orange: 1,
        Cyan: 2,
    },

    CoreColor: {
        Yellow: 0,
        Red: 1,
        Brown: 2,
    },

    PetalCount: {
        Three: 0,
        Two: 1,
        One: 2,
    },

    PetalShape: {
        Spiky: 0,
        Round: 1,
        Drop: 2,
    },

    // easiest-to-hardest
    DifficultyLevels: [
        {
            MinimumPossible: 5,
            MaximumPossible: 10,
        },
        {
            MinimumPossible: 2,
            MaximumPossible: 8,
        },
        {
            MinimumPossible: 1,
            MaximumPossible: 5,
        },
    ],

    Card: function(x, y) {
        this.x = x;
        this.y = y;

        this.color = -1;
        this.count = -1;
        this.shape = -1;
        this.core = -1;

        this.reset();

        this.index = y*Petals.Columns + x;
        this.selected = false;
        this.dirty = false;
    },

    Game: function(painter, on_possible_updated, on_score_updated,
                  on_error_message, on_cards_replaced, players,
                  difficulty) {
        this.painter = painter;

        this.on_possible_updated = on_possible_updated;
        this.on_score_updated = on_score_updated;
        this.on_error_message = on_error_message;
        this.on_cards_replaced = on_cards_replaced;

        this.difficulty = difficulty;

        this.players = players;
        this.score = [];
        for (var i=0; i<players; i++) {
            this.score[i] = 0;
        }
        this.on_score_updated(this.score);

        this.cards = [];
        this.validation_error = [];
        for (var y=0; y<Petals.Rows; y++) {
            for (var x=0; x<Petals.Columns; x++) {
                this.cards.push(new Petals.Card(x, y));
            }
        }

        this.initialReset = true;
        this.reset(this.cards);
    },
};

Petals.Game.prototype.restart = function() {
    // Restart a completely new game
    for (var i in this.score) {
        this.score[i] = 0;
    }
    this.on_score_updated(this.score);

    // Deal new cards
    this.initialReset = true;
    this.reset(this.cards);

    // Draw the result
    this.draw();
};

Petals.Game.prototype.reset = function(selected) {
    var possible = 0;
    var i = 0;

    if (!this.initialReset) {
        var replaced = [];
        selected.forEach(function (card) {
            replaced.push({
                x: card.x,
                y: card.y,
                color: card.color,
                count: card.count,
                shape: card.shape,
                core: card.core,
            });
        });
        this.on_cards_replaced(replaced);
    } else {
        this.initialReset = false;
    }

    var level = Petals.DifficultyLevels[this.difficulty];
    while (possible < level.MinimumPossible ||
           possible > level.MaximumPossible) {
        selected.forEach(function (card) {
            card.reset();
        });
        possible = this.possible_sets().length;

        if (i > 100) {
            /**
             * If we can't find the desired amount of possible sets in 100
             * iterations, just shuffle all cards to avoid infinite loops.
             **/
            selected = this.cards;
        } else {
            i++;
        }
    }

    this.on_possible_updated(possible);
};

Petals.Game.prototype.clickCard = function(column, row, player) {
    this.cards[row * Petals.Columns + column].flip();
    this.check(player);
    this.draw();
};

Petals.Game.prototype.request_hint = function() {
    var given_hint = true;

    var possible = this.possible_sets();
    var i = possible[0][0];
    var j = possible[0][1];
    var k = possible[0][2];

    var firstSelectedIndex = -1;

    this.cards.forEach(function (card) {
        if (card.selected) {
            if (firstSelectedIndex === -1) {
                firstSelectedIndex = card.index;
            }

            if (card.index !== i && card.index !== j) {
                card.selected = false;
                card.dirty = true;
            }
        }
    });

    this.cards[i].selected = true;
    this.cards[i].dirty = true;
    if (firstSelectedIndex === i) {
        // give another hint
        if (this.cards[j].selected) {
            given_hint = false;
        }
        this.cards[j].selected = true;
        this.cards[j].dirty = true;
    }
    this.draw();

    return given_hint;
};

Petals.Game.prototype.possible_sets = function() {
    var possible = [];

    for (var i=0; i<this.cards.length; i++) {
        for (var j=i+1; j<this.cards.length; j++) {
            for (var k=j+1; k<this.cards.length; k++) {
                if (this.validate([this.cards[i], this.cards[j],
                            this.cards[k]])) {
                    possible.push([i, j, k]);
                }
            }
        }
    }

    return possible;
};

Petals.Game.prototype.validate = function(selected) {
    var properties = ['color', 'count', 'shape', 'core'];

    this.validation_error = [];

    var game = this;
    properties.forEach(function (property) {
        var v = [];

        selected.forEach(function (cell) {
            v.push(cell[property]);
        });

        if (v[0] === v[1] && v[1] === v[2]) {
            return; /* all values are equal */
        }

        if (v[0] !== v[1] && v[1] !== v[2] && v[0] !== v[2]) {
            return; /* all values are distinct */
        }

        var a = game.readableName(property, v[0]);
        var b = game.readableName(property, v[1]);
        var c = game.readableName(property, v[2]);
        var msg = property + ' (' + a + ', ' + b + ' and ' + c + ')';
        game.validation_error.push(msg);
    });

    return (this.validation_error.length === 0);
};

Petals.Game.prototype.readableName = function(property, value) {
    switch (property) {
        case 'color': return ['purple', 'orange', 'cyan'][value];
        case 'count': return ['three', 'two', 'one'][value];
        case 'shape': return ['spiky', 'round', 'drop'][value];
        case 'core': return ['yellow', 'red', 'brown'][value];
        default: return '???';
    }
};

Petals.Game.prototype.check = function(player) {
    var selected = [];

    this.cards.forEach(function (card) {
        if (card.selected) {
            selected.push(card);
        }
    });

    if (selected.length === 3) {
        if (this.validate(selected)) {
            this.score[player] = this.score[player] + 1;
            this.on_score_updated(this.score);
            this.reset(selected);
        } else {
            this.on_error_message(this.validation_error);
        }

        selected.forEach(function (card) {
            card.selected = false;
            card.dirty = true;
        });
    }
};

Petals.Game.prototype.draw = function() {
    this.painter.draw(this.cards);
};

Petals.Card.prototype.flip = function() {
    this.selected = !this.selected;
    this.dirty = true;
};

Petals.Card.prototype.reset = function() {
    this.color = parseInt(3*Math.random());
    this.count = parseInt(3*Math.random());
    this.shape = parseInt(3*Math.random());
    this.core = parseInt(3*Math.random());
    this.dirty = true;
    this.selected = false;
};

