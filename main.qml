import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import io.qt.examples.backend 1.0

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Шифр Віженера")
    menuBar: MenuBar {
        Menu {
            id: fileMenu
            title: qsTr("Файл")
            Action {
                text: "Відкрити..."
                enabled: ui.state == "default"
                onTriggered: ui.item.openDialog.open()
            }
            Action {
                text: "Зберегти як..."
                enabled: ui.state == "default"
                onTriggered: ui.item.saveDialog.open()
            }
            Action {
                text: "Вихід"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            id: langMenu
            title: "Алфавіт (UA)"
            Action {
                id: uaLocale
                text: "Український"
                enabled: false
                onTriggered: {
                    backend.lang = 0
                }
            }
            Action {
                id: engLocale
                text: "Англійський"
                onTriggered: {
                    backend.lang = 1
                }
            }
            Action {
                id: myLocale
                text: "Свій"
                onTriggered: {
                    backend.lang = 2
                    drawer.open()
                }
            }
        }
        Menu {
            title: qsTr("?")
            Action {
                text: "Про програму"
                onTriggered: help.open()
            }
            Action {
                id: schemesAction
                text: "Схема"
                onTriggered: ui.state == "default" ? ui.state = "schemes" : ui.state = "default"
            }
        }
    }
    footer: ToolBar {
        id: foot
        Behavior on height {
            PropertyAnimation {
                target: foot
                property: "height"
                duration: 250
            }
        }
        RowLayout {
            anchors.fill: parent
            Label {
                id: textCipher
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Label.ElideMiddle
                Layout.fillWidth: true
            }
            ScrollView {
                width: 0.4 * parent.width
                Layout.fillWidth: true
                visible: ui.state !== "schemes"
                TextArea {
                    id: curFile
                    anchors.fill: parent
                    enabled: false
                    color: "white"
                }
            }
        }
    }
    Loader {
        id: ui
        state: "default"
        sourceComponent: uiComponent
        states: [
            State {
                name: "schemes"
                PropertyChanges {
                    target: ui
                    sourceComponent: schemesComponent
                }
                PropertyChanges {
                    target: schemesAction
                    text: "Шифрування"
                }
                PropertyChanges {
                    target: textCipher
                    text: (ui.item.colIndex > backend.alphabet.length
                           || ui.item.rowIndex > backend.alphabet.length) ? "" : backend.alphabet[ui.item.colIndex].toUpperCase() + backend.alphabet[ui.item.rowIndex].toUpperCase()
                }
            },
            State {
                name: "default"
                PropertyChanges {
                    target: ui
                    sourceComponent: uiComponent
                }
                PropertyChanges {
                    target: schemesAction
                    text: "Схема"
                }
                PropertyChanges {
                    target: curFile
                    text: ui.item.currentFile
                }
            }
        ]
    }
    Dialog {
        id: help
        title: "Про програму"
        standardButtons: Dialog.Close
        anchors.centerIn: parent
        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: "AlignHCenter"
            text: "Розробив студент\nгрупи ІШІ-501\nСергієнко Ігор"
        }
    }
    Drawer {
        id: drawer
        height: 0.25 * window.height
        width: window.width
        edge: "BottomEdge"

        Rectangle {
            anchors.fill: parent
            ScrollView {
                anchors.fill: parent
                anchors.margins: 0.02 * parent.width
                TextArea {
                    id: myAlphabet
                    wrapMode: TextEdit.WrapAnywhere
                    placeholderText: "Алфавіт"
                    selectByMouse: true
                    selectByKeyboard: true
                }
            }
        }
    }

    Component {
        id: uiComponent
        UserInterface {}
    }
    Component {
        id: schemesComponent
        Schemes {}
    }
    Scripts {
        id: backend
    }
    BackEnd {
        id: back
    }
}
