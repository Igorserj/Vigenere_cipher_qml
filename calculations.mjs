WorkerScript.onMessage = function (message) {
    var alphabet = []
    var openText = message.open.toLowerCase()
    var key = message.key.toLowerCase().replace(/\s/g, '')
    var cipher = []
    var spaces = []
    var enters = []
    var notCipher = []
    var notCipherId = []

    if (message.lang === 0)
        alphabet = ["а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ю", "я"]
    else if (message.lang === 1)
        alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    else
        alphabet = message.alphabet

    for (var i = 0; i < openText.length; i++) {
        if (!alphabet.includes(openText[i])) {
            notCipher.push(openText[i])
            notCipherId.push(i)
            openText = openText.slice(0, i) + "А" + openText.slice(i + 1)
        }
    }

    if (message.mode === "decrypt") {
        var keyText = []
        for (var i = 0; i < key.length; i++) {
            keyText.push(alphabet[(alphabet.length - alphabet.indexOf(
                                       key[i])) % alphabet.length])
        }
        keyText = keyText.join('')
    } else
        var keyText = key

    var openText2 = openText.replace(/А/g, '')
    for (i = 0; i < openText2.length; i++) {
        cipher.push((alphabet.indexOf(openText2[i]) + alphabet.indexOf(
                         keyText[i % keyText.length])) % alphabet.length)
    }
    var cipher2 = []
    for (i = 0; i < cipher.length; i++) {
        cipher2.push(alphabet[cipher[i]])
    }

    for (i = 0; i < notCipher.length; i++) {
        cipher2.splice(notCipherId[i], 0, notCipher[i])
    }

    var keyCipher = []
    for (i = 0; i < keyText.length; i++) {
        keyCipher.push((alphabet.length - alphabet.indexOf(
                            keyText[i])) % alphabet.length)
    }

    WorkerScript.sendMessage({
                                 "cipher": cipher2.join(''),
                                 "key": keyCipher.join('#') + '#'
                             })
}
