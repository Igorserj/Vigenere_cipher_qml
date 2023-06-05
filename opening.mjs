WorkerScript.onMessage = function (message) {
    let textField = ""
    let request = new XMLHttpRequest()
    request.open("GET", message.file, false)
    request.onreadystatechange = function () {
        if (request.readyState === XMLHttpRequest.DONE) {
            var response = request.responseText
            textField = response
        }
    }
    request.send()

    var lines = textField.split('\n')
    const line = lines[0].split('#')
    var key = ""
    var lang = -1
    if (line[0].toString() === "300") {
        lang = 0
    } else if (line[0].toString() === "301") {
        lang = 1
    } else if (line[0].toString() === "302") {
        lang = 2
    }
    var alphabet = lang === 0 ? ["а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ю", "я"] : lang === 1 ? ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] : message.alphabet
    if (lang !== -1) {
        for (var i = 1; i < line.length; i++) {
            if (!!alphabet[line[i]])
                key += alphabet[line[i]]
        }
    } else {
        for (var i = 0; i < line.length; i++) {
            if (!!alphabet[line[i]])
                key += alphabet[line[i]]
            lang = 0
        }
    }

    //    key = key.replace("undefined", "")
    if (key !== "") {
        textField = ""
        for (var i = 1; i < lines.length; i++) {
            textField += lines[i]
        }
    }

    //    key = key.replace("undefined", "")
    WorkerScript.sendMessage({
                                 "text": textField,
                                 "key": key,
                                 "lang": lang
                             })
}
