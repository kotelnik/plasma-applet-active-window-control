import QtQuick 2.6
import QtQuick.Controls 1.3
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: mainContent

    property var model
    property int orientation
    property double itemWidth
    property double itemHeight
    property bool interactive

    width: itemWidth * (orientation == ListView.Vertical ? 1 : model.count)
    height: itemHeight * (orientation == ListView.Horizontal ? 1 : model.count)

    SystemPalette {
        id: palette
    }

    // theme + svg
    property bool textColorLight: ((palette.text.r + palette.text.g + palette.text.b) / 3) > 0.5
    property string themeName: textColorLight ? 'breeze-dark' : 'default'

    signal modelOrderChanged()

    ListView {
        id: listView
        anchors.fill: parent
        model: mainContent.model
        orientation: mainContent.orientation
        delegate: OrderableItem {

            listViewParent: listView.parent

            Item {
                height: itemWidth
                width: itemHeight

                PlasmaCore.Svg {
                    id: buttonSvg
                    imagePath: Qt.resolvedUrl('../../icons/' + themeName + '/' + model.text + '.svg')
                }

                // icon
                PlasmaCore.SvgItem {
                    id: svgItem
                    anchors.fill: parent
                    width: parent.width
                    height: width
                    svg: buttonSvg
                    elementId: 'active-idle'
                }
            }

            onMoveItemRequested: {
                mainContent.model.move(from, to, 1);
                mainContent.modelOrderChanged()
            }
        }
    }
}

