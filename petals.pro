# Update/generate flower artwork from SVG template
system(python3 artwork/update.py artwork/flowers.svg qml/images/flowers)


QT += quick qml
TARGET = petals
CONFIG += sailfishapp_qml


DISTFILES += \
        rpm/petals.spec \
        petals.desktop \
        data/petals.svg

RESOURCES += $${TARGET}.qrc
QMAKE_RESOURCE_FLAGS += -threshold 0 -compress 9

target.path = /usr/bin

desktop.files = data/$${TARGET}.desktop
desktop.path = /usr/share/applications

INSTALLS += target desktop icon

include(icons/icons.pri)
