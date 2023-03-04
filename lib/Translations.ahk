GetTranslation(_lang, _section, _ctrlName) {
    return GetTranslations(_lang, _section)[_ctrlName]
}

GetTranslations(_lang, _section="") {
    global PROGRAM

    FileRead, content,% PROGRAM.TRANSLATIONS_FOLDER "/english.json"
    engTrans := JSON_Load(content)
    FileRead, content,% PROGRAM.TRANSLATIONS_FOLDER "/" _lang ".json"
    transJSON := JSON_Load(content)

    if (_lang != "english") { ; replace missing trans with english txt
        for jsonSubArr, nothing in engTrans {
            if IsObject(engTrans[jsonSubArr]) && !IsObject(transJSON[jsonSubArr])
                transJSON[jsonSubArr] := {}
            for ctrlName, translation in engTrans[jsonSubArr]
                if (transJSON[jsonSubArr][ctrlName] = "")
                    transJSON[jsonSubArr][ctrlName] := translation
        }
    }

    return transJSON
}
