.pragma library

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

function formatTime(time) {
    var result = [];

    var minutes = parseInt(time / 60);
    var seconds = time % 60;

    if (minutes < 10) {
        result.push('0' + minutes);
    } else {
        result.push(minutes);
    }

    result.push(':');

    if (seconds < 10) {
        result.push('0' + seconds);
    } else {
        result.push(seconds);
    }

    return result.join('');
}

function cardImageUrl(content) {
    var ch = ['a', 'b', 'c'];
    return 'images/flowers/flowers_' + ch[content.color] + '_' + ch[content.core] + '_' + ch[content.count] + '_' + ch[content.shape] + '.png';
}
