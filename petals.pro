# Update/generate flower artwork from SVG template
#system(python3 artwork/update.py artwork/flowers.svg qml/images/flowers)


QT += quick qml
TARGET = petals
CONFIG += sailfishapp_qml


DISTFILES += \
        rpm/petals.spec \
        petals.desktop \
        data/petals.svg \
        qml/*.qml \
        qml/images/*.png \
        qml/images/flowers/*,png \
        qml/*.js

desktop.files = data/$${TARGET}.desktop
desktop.path = /usr/share/applications

INSTALLS += target desktop icon

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
