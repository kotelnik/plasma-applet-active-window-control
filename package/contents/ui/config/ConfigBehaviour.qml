import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

    property alias cfg_showForCurrentScreenOnly: showForCurrentScreenOnly.checked

    GridLayout {
        columns: 2

        CheckBox {
            id: showForCurrentScreenOnly
            text: i18n("Show active window only for plasmoid's screen")
            Layout.columnSpan: 2
        }

    }

}
