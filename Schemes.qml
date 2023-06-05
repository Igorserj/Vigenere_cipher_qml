import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: scheme
    property int rowIndex: 0
    property int colIndex: 0
    ScrollView {
        width: window.width
        height: window.height - window.footer.height - window.menuBar.height
        clip: true
        contentWidth: col.width
        contentHeight: col.height
        Column {
            id: col
            Repeater {
                model: backend.alphabet
                Row {
                    id: row
                    property int colIndex: index
                    Repeater {
                        model: backend.alphabet
                        Rectangle {
                            id: rect
                            width: 0.05 * window.width
                            height: width
                            border.width: 1
                            border.color: (index === rowIndex
                                           || row.colIndex === scheme.colIndex) ? "green" : "black"
                            color: (index === rowIndex || row.colIndex
                                    === scheme.colIndex) ? ((index === rowIndex
                                                             && row.colIndex === 0)
                                                            || (index === 0
                                                                && row.colIndex === scheme.colIndex)
                                                            || (index === rowIndex
                                                                && row.colIndex === scheme.colIndex)) ? "#FF444944" : "#FFDDDDDD" : "white"
                            Text {
                                anchors.fill: parent
                                font.pointSize: 100
                                fontSizeMode: Text.Fit
                                color: ((index === rowIndex
                                         && row.colIndex === 0)
                                        || (index === 0
                                            && row.colIndex === scheme.colIndex)
                                        || (index === rowIndex && row.colIndex
                                            === scheme.colIndex)) ? "white" : "black"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: backend.alphabet[(index + row.colIndex)
                                                       % backend.alphabet.length]
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    scheme.rowIndex = index
                                    scheme.colIndex = row.colIndex
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
