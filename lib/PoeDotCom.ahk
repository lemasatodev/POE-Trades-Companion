PoeDotCom_GenerateCurrencyData() {
    jsonData := PoeDotCom_GetCurrencyData()

    if !(jsonData.chaos) {
        MsgBox(4096, "", "Function: " A_ThisFunc "`nCurrency JSON data is invalid, cancelling.")
        return
    }

    fileLocation := A_ScriptDir "/data/poeDotComCurrencyData.json"
    dump := JSON.Dump(jsonData)
    nice := JSON.Beautify(dump)

    if (!nice || StrLen(nice) < 100) {
        MsgBox, 4096,% "",% "Error while retrieving currency data from pathofexile.com"
        return
    }

    FileDelete,% fileLocation
    FileAppend,% nice,% fileLocation
}


PoeDotCom_GetCurrencyData() {

    wb := ComObjCreate("InternetExplorer.Application") ;create a IE instance
    ; wb.Visible := True
    wb.Navigate("pathofexile.com/trade/about")
    IELoad(wb)
    
    ; Custom check to make sure page is loaded
    while !InStr( wb.document.getElementsByClassName("filter-title filter-title-clickable").item(0).innerText, "Item tags")
        sleep 10

    ; Expand div
    Loop {
        div := wb.document.getElementsByClassName("filter-title filter-title-clickable").item(A_Index-1)
        if InStr(div.innerText, "Item tags") { ; Click on it to show currency names
            div.Click()
        }
        else Break
    }

    ; Get currency data
    currencies := {}
    Loop {
        tag := wb.document.getElementsByClassName("form-control text").item(A_Index-1)
        if (StrLen(tag.value) > 0) && (tag.parentElement.className = "filter") {
            curShort := tag.value, curLong := tag.parentElement.textcontent
            curLong := StrReplace(curLong, "`n", "")
            curLong = %curLong%

            currencies[curShort] := curLong
        }
        else
            Break
    }

    wb.quit(), wb := ""

    return currencies
}

PoeDotCom_GetCurrentlyLoggedCharacter(accName) {
    global PROGRAM
    
    if !(accName)
        return

    url := "https://www.pathofexile.com/character-window/get-characters?accountName=" accName
    headers := "Content-Type: application/json"
    . "`n"     "Cache-Control: no-store, no-cache, must-revalidate"
    options := "TimeOut: 7"
    . "`n"     "Charset: UTF-8"

    WinHttpRequest(url, data:="", headers, options), charsJSON := data
    charsJSON := JSON.Load(charsJSON)

    for index, nothing in charsJSON  {
        if (charsJSON[index].lastActive = True) {
            lastChar := charsJSON[index].name  
            Break
        }
    }

    if !(lastChar) {
        trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Msg, "%account%", accName)
        TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Title, trayMsg)
    }
    
    return lastChar        
}
