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

Screen {
    id: stagePack
    property variant activePage: children[children.length-1]

    Item {
        id: toolbar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: platformWindow.sy(70)

        Row {
            anchors.fill: parent

            ImageButton {
                height: parent.height
                width: height

                visible: (stagePack.children.length > 2) && activePage !== null && activePage.hasBackButton
                source: {
                    if (stagePack.activePage.requestClose === undefined) {
                        'images/back.png'
                    } else {
                        'images/pause.png'
                    }
                }

                onClicked: {
                    if (stagePack.children.length <= 2 || slideOutTimer.running) {
                        return;
                    }

                    if (stagePack.activePage.requestClose !== undefined) {
                        stagePack.activePage.requestClose();
                        return;
                    }

                    stagePack.pop();
                }
            }
        }
    }

    function easingFunction(value) {
        var overshoot = 1.1;

        // Overshooting easing function ("Out back")
        return (overshoot+1)*Math.pow(value, 3) - overshoot*Math.pow(value, 2);
    }

    property int animationInterval: 30
    property real animationStep: .07

    function animateSlideOut(target, value) {
        target.setSlide(1-value);
        if (stagePack.children.length > 2) {
            stagePack.children[stagePack.children.length-2].setSlide(-value);
        }
    }

    function finishSlideOut(target) {
        target.destroy();
    }

    function animateSlideIn(target, value) {
        target.setSlide(value);
        if (children.length > 2) {
            children[children.length-2].setSlide(value-1);
        }
    }

    function finishSlideIn(target) {
        target.setSlide(0);

        for (var i=1; i<children.length-1; i++) {
            children[i].visible = false;
        }

        if (slideInTimer.replace) {
            if (children.length > 2) {
                children[children.length-2].destroy();
            }
        }
    }

    Timer {
        property variant target
        property real value
        property bool replace: false
        id: slideInTimer
        interval: stagePack.animationInterval
        repeat: true

        onTriggered: {
            value -= stagePack.animationStep;
            stagePack.animateSlideIn(target, stagePack.easingFunction(value));
            if (value <= 0) {
                running = false;
                stagePack.finishSlideIn(target);
            }
        }
    }

    Timer {
        property variant target
        property real value
        id: slideOutTimer
        interval: stagePack.animationInterval
        repeat: true

        onTriggered: {
            value -= stagePack.animationStep;
            stagePack.animateSlideOut(target, stagePack.easingFunction(value));
            if (value <= 0) {
                running = false;
                stagePack.finishSlideOut(target);
            }
        }
    }

    function push_qml(filename, properties, replace) {
        finishAllTimers();

        if (replace === true) {
            slideInTimer.replace = true;
        } else {
            slideInTimer.replace = false;
        }

        var component = Qt.createComponent(filename);

        if (component.status !== Component.Ready) {
            console.log('Error: ' + component.errorString());
        }

        var item;
        if (properties !== undefined) {
            item = component.createObject(stagePack, properties);
        } else {
            item = component.createObject(stagePack);
        }

        item.anchors.left = stagePack.left;
        item.anchors.top = stagePack.top;

        item.anchors.bottom = toolbar.top;
        item.setSlide(1);

        slideInTimer.target = item;
        slideInTimer.value = 1;
        slideInTimer.running = true;
    }

    function finishAllTimers() {
        if (slideInTimer.running) {
            slideInTimer.running = false;
            finishSlideIn(slideInTimer.target);
        }

        if (slideOutTimer.running) {
            slideOutTimer.running = false;
            finishSlideOut(slideOutTimer.target);
        }
    }

    function pop(count) {
        finishAllTimers();

        if (count === undefined) {
            count = 1;
        }

        if (stagePack.children.length < 1 + count) {
            return;
        }

        var tmp = [];
        for (var i=0; i<children.length; i++ ) {
            tmp.push(children[i]);
        }

        // pop (count-1) extra pages
        for (var i=0; i<count-1; i++) {
            var removed = tmp.splice(tmp.length-2, 1);
            removed[0].destroy();
        }

        var item = tmp[tmp.length-1];

        // make next-to-topmost child visible on the left side of the screen for pop
        tmp[tmp.length-2].setSlide(-1);
        tmp[tmp.length-2].visible = true;

        slideOutTimer.target = item;
        slideOutTimer.value = 1;
        slideOutTimer.running = true;
    }
}
