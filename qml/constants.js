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

// Game modes as defined in SetupScreen.qml
var TimeLimitMode = 0;
var ScoreLimitMode = 1;

// Values for the minute time limits in High Score mode
var TimeLimits = [5, 15, 30];

// Values for the set count in Time Attack mode
var ScoreLimits = [10, 20, 50];

// Names of difficulty levels
var DifficultyLevels = ['Easy', 'Medium', 'Hard'];
