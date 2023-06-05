import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

ScrollView {
    id: interf
    property alias cipherText: cipherText
    property alias openDialog: openDialog
    property alias saveDialog: saveDialog
    property alias openText: openText
    property alias keyText: keyText
    property int transtionTime: 1000
    property string currentFile: ""
    height: window.height
    width: window.width
    contentHeight: content.height + cipherRect.height + window.menuBar.height + window.footer.height
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

    Rectangle {
        id: content
        height: window.height * 4 / 5
        width: window.width
        Column {
            id: col
            anchors.fill: parent
            spacing: window.width / 40
            Row {
                id: row
                spacing: window.width / 20
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    width: window.width / 2 - row.spacing
                    height: window.height / 3 * 2
                    ScrollView {
                        anchors.fill: parent
                        TextArea {
                            id: openText
                            placeholderText: "Відкритий текст"
                            selectByMouse: true
                            selectByKeyboard: true
                        }
                    }
                }
                Rectangle {
                    width: window.width / 2 - row.spacing
                    height: window.height / 3 * 2
                    ScrollView {
                        anchors.fill: parent
                        TextArea {
                            id: keyText
                            placeholderText: "Ключ"
                            selectByMouse: true
                            selectByKeyboard: true
                        }
                    }
                }
            }
            Row {
                spacing: window.width / 40
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: "Шифрування"
                    onClicked: interf.encrypt()
                }
                Button {
                    text: "Розшифрування"
                    onClicked: interf.encrypt("decrypt")
                }
            }
        }
    }
    Rectangle {
        id: cipherRect
        anchors.top: content.bottom
        width: window.width - row.spacing
        height: window.height / 3 * 2
        x: (window.width - width) / 2
        ScrollView {
            anchors.fill: parent
            TextArea {
                id: cipherText
                readOnly: true
                placeholderText: "Результат"
                selectByMouse: true
                selectByKeyboard: true
            }
        }
    }

    FileDialog {
        id: openDialog
        title: "Оберіть текстовий файл"
        nameFilters: ["Текстовий документ (*.txt)", "Всі файли (*)"]
        onAccepted: {
            backend.opening.sendMessage({
                                            "file": openDialog.fileUrl,
                                            "lang": backend.lang,
                                            "alphabet": myAlphabet.text.replace(
                                                            /\s/g,
                                                            '').toLowerCase(
                                                            ).split('')
                                        })
            interf.currentFile = openDialog.fileUrl.toString().slice(8)
        }
    }
    FileDialog {
        id: saveDialog
        title: "Оберіть куди зберегти"
        nameFilters: ["Текстовий документ (*.txt)"]
        selectExisting: false
        onAccepted: {
            backend.lang === 0 ? back.writing(saveDialog.fileUrl.toString().slice(8),
                                              300 + "#" + backend.key + "\n" + cipherText.text) : backend.lang === 1 ? back.writing(saveDialog.fileUrl.toString().slice(8), 301 + "#" + backend.key + "\n" + cipherText.text) : back.writing(saveDialog.fileUrl.toString().slice(8), 302 + "#" + backend.key + "\n" + cipherText.text)
            backend.opening.sendMessage({
                                            "file": saveDialog.fileUrl,
                                            "lang": backend.lang,
                                            "alphabet": myAlphabet.text.replace(
                                                            /\s/g,
                                                            '').toLowerCase(
                                                            ).split('')
                                        })
            interf.currentFile = saveDialog.fileUrl.toString().slice(8)
        }
    }
    function encrypt(mode = "encrypt") {
        backend.encryption.sendMessage({
                                           "open": openText.text,
                                           "key": keyText.text,
                                           "lang": backend.lang,
                                           "alphabet": backend.alphabet,
                                           "mode": mode
                                       })
    }
}
