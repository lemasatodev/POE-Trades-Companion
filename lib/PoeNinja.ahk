PoeNinja_GetMapOverview(league) {
    /*  Retrieve map infos from poe.ninja
    */
    url := "https://poe.ninja/api/Data/GetMapOverview?league=" league
	headers := "Content-Type: text/html; charset=UTF-8"
    options := "TimeOut: 25"

    WinHttpRequest_cURL(url, data:="", headers, options), html := data

    mapsJSON := JSON_Load(html)
    return mapsJSON
}


PoeNinja_GetUniqueMapOverview(league) {
    /*  Retrieve map infos from poe.ninja
    */
    url := "https://poe.ninja/api/Data/GetUniqueMapOverview?league=" league
	headers := "Content-Type: text/html; charset=UTF-8"
    options := "TimeOut: 25"

    WinHttpRequest_cURL(url, data:="", headers, options), html := data

    uniqueMapsJSON := JSON_Load(html)
    return uniqueMapsJSON
}

PoeNinja_GetCurrencyOverview(league) {
    url := "https://poe.ninja/api/Data/GetCurrencyOverview?league=" league
	headers := "Content-Type: text/html; charset=UTF-8"
    options := "TimeOut: 25"

    WinHttpRequest_cURL(url, data:="", headers, options), html := data

    currencyJSON := JSON_Load(html)
    return currencyJSON
}

PoeNinja_CreateCurrencyPngFiles(league) {
    global PROGRAM
    currencyJSON := PoeNinja_GetCurrencyOverview(league)
    currency := {}

    ; get only needed infos
    for index, nothing in currencyJSON.currencyDetails {
        currencyName := currencyJSON.currencyDetails[index].name
        currencyImgLink := currencyJSON.currencyDetails[index].icon

        if (currencyImgLink) {
            Download(currencyImgLink, PROGRAM.CURRENCY_IMGS_FOLDER "\" currencyName ".png")
        }
    }
}

PoeNinja_CreateMapDataFile(league) {
    /*  Create our map data file from map infos of poe.ninja
    */
    mapsJSON := PoeNinja_GetMapOverview(league)
    uniqueMapsJSON := PoeNinja_GetUniqueMapOverview(league)
    excludeList := "Elder,Shaped,Blighted"
    excludeListUnique := "The Beachhead"
    maps := {}

    ; get only needed infos
    for index, nothing in mapsJSON.lines {
        mapName := mapsJSON.lines[index].name
        mapTier := mapsJSON.lines[index].mapTier

        if !IsContaining(mapName, excludeList) {
            if !IsObject(maps[mapTier])
                maps[mapTier] := {}
            maps[mapTier].Push(mapName)
        }
    }

    ; same but for unique maps
    for index, nothing in uniqueMapsJSON.lines {
        mapName := uniqueMapsJSON.lines[index].name
        baseType := uniqueMapsJSON.lines[index].baseType
        mapTier := "unique"

        if !IsContaining(mapName, excludeListUnique) {
            if !IsObject(maps[mapTier])
                maps[mapTier] := {}
            maps[mapTier].Push(mapName " " baseType)
        }
    }

    ; sort by name and re-arrange array
    mapsSorted := {}
    for index, nothing in maps {        
        tierMapsList := ""
        Loop % maps[index].Count()
            tierMapsList := tierMapsList ? tierMapsList "`n" maps[index][A_Index] : maps[index][A_Index]

        Sort, tierMapsList, D`n
        mapsSorted["tier_" index] := {}
        Loop, Parse, tierMapsList, `n, `r
        {
            mapName := A_LoopField               
            mapsSorted["tier_" index][mapName] := {}
            mapsSorted["tier_" index][mapName].pos := A_Index
        }
    }

    finalData := JSON_Dump(mapsSorted)
    finalData := StrReplace(finalData, "\u251c\u00c2", "ö")

    if (!mapsSorted.Count() || !mapsSorted["tier_unique"].Count() || StrLen(finalData) < 100) {
        MsgBox, 4096,% "",% "Error while retrieving maps data from poe.ninja"
        return
    }

    FileDelete,% A_ScriptDir "/data//mapsData.json"
    File := FileOpen(A_ScriptDir "/data//mapsData.json", "w", "UTF-8")
	File.Write(finalData)
	File.Close()
}
