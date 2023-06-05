import QtQuick 2.15

Item {
    property alias encryption: myScript
    property alias opening: myScript2
    property var key: []
    property int lang: 0
    property var alphabet: lang === 0 ? ["а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ю", "я"] : lang
                                        === 1 ? ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] : myAlphabet.text.replace(
                                                    /\s/g,
                                                    '').toLowerCase().split('')
    onLangChanged: {
        lang === 1 ? [langMenu.title = "Алфавіт (EN)", uaLocale.enabled
                      = true, engLocale.enabled = false, myLocale.text
                      = "Свій"] : lang === 0 ? [langMenu.title = "Алфавіт (UA)", uaLocale.enabled = false, engLocale.enabled = true, myLocale.text = "Свій"] : [langMenu.title = "Алфавіт (MY)", uaLocale.enabled = true, engLocale.enabled = true, myLocale.text = 'Відкрити']
    }
    WorkerScript {
        id: myScript
        source: "calculations.mjs"
        onMessage: {
            ui.item.cipherText.text = messageObject.cipher
            key = messageObject.key
        }
    }
    WorkerScript {
        id: myScript2
        source: "opening.mjs"
        onMessage: {
            ui.item.openText.text = messageObject.text
            key = messageObject.key
            lang = messageObject.lang
            ui.item.keyText.text = key
            ui.item.encrypt()
        }
    }
}
