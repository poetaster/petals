#
# Petals: A brain-teasing puzzle for 1-4 players
# Copyright (C) 2013, 2015 Thomas Perl <m@thp.io>
# http://thp.io/2013/petals/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import subprocess
import os
import sys

#
# Order and a/b/c coding of flower properties:
#                    a         b         c
# 1. petal color     purple    orange    cyan
# 2. core color      yellow    red       brown
# 3. count           three     two       one
# 4. petal shape     spiky     round     drop
#
# Example: flower_a_c_b_a.png
#                 ^ ^ ^ ^
#                 | | | +- shape: spiky
#                 | | +--- count: two
#                 | +----- core color: brown
#                 +------- petals color: purple
#


# =============================================================

COLOR_MAPPING = [
    # Petal color
    ('#ff00ff', ['#a30077', '#ff7932', '#007a9d']),

    # Core color
    ('#00ffff', ['#ffe000', '#c81800', '#410f00']),
]

SIZE = 220
SPACING = 20

# =============================================================


def map_color(template, mapping, indices):
    for i, (k, v) in enumerate(mapping):
        template = template.replace(k, v[indices[i]])
    return template


def main(input_file, output_dir):
    template = open(input_file).read()

    os.makedirs(output_dir)

    for index_a, character_a in enumerate('abc'):
        for index_b, character_b in enumerate('abc'):
            svg_filename = os.path.join(output_dir, 'flowers_%s_%s.svg' % (character_a, character_b))

            with open(svg_filename, 'w') as fp:
                fp.write(map_color(template, COLOR_MAPPING, [index_a, index_b]))

            tmp_filename = svg_filename.replace('.svg', '.png')
            subprocess.check_call(['rsvg-convert', svg_filename, '-o', tmp_filename])
            os.unlink(svg_filename)

            for index_c, character_c in enumerate('abc'):
                for index_d, character_d in enumerate('abc'):
                    x = index_c * (SIZE + SPACING)
                    y = index_d * (SIZE + SPACING)
                    png_filename = tmp_filename.replace('.png', '_%s_%s.png' % (character_c, character_d))
                    area = '%dx%d+%d+%d' % (SIZE, SIZE, x, y)
                    subprocess.check_call(['convert', tmp_filename, '-crop', area, png_filename])

            os.unlink(tmp_filename)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: %s <input.svg> <output_dir>' % (sys.argv[0],))
        sys.exit(1)

    print('Generating flower images...')
    input_svg = sys.argv[1]
    output_dir = sys.argv[2]
    main(input_svg, output_dir)
