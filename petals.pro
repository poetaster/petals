# Update/generate flower artwork from SVG template
system(python3 artwork/update.py artwork/flowers.svg qml/images/flowers)

CONFIG += sailfishapp_qml

QT += quick qml

TARGET = petals

TEMPLATE = app

SOURCES += src/main.cpp

RESOURCES += $${TARGET}.qrc
QMAKE_RESOURCE_FLAGS += -threshold 0 -compress 9

target.path = /usr/bin

desktop.files = data/$${TARGET}.desktop
desktop.path = /usr/share/applications

icon.files = data/$${TARGET}.svg
icon.path = /usr/share/icons/hicolor/scalable/apps/

INSTALLS += target desktop icon
