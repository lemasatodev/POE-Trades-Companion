/*  TO_DO
    Some funcs to convert TC obj to API obj
    Also make better slots to Trades GUI
    Like MapTier slot or something?
*/

GGG_API_GetLastActiveCharacter(accName) {
    global PROGRAM

    if !(accName) {
        trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Msg, "%account%", accName)
        TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToRetrieveAccountCharacters_Title, trayMsg)
        return
    }
	
	poeURL := GetPoeDotComUrlBasedOnLanguage("ENG")
	url := poeURL "/character-window/get-characters?accountName=" UriEncode(accName)
    headers := "Accept: application/json"
    . "`n" "Content-Type: application/json"
    . "`n" "Cache-Control: max-age=0"
    options := "TimeOut: 7"
    . "`n"     "Charset: UTF-8"
    WinHttpRequest_cURL(url, data:="", headers, options), charsJSON := JSON_Load(data)

    if !IsObject(charsJSON) {
        static accNameCopy
        accNameCopy := accName
        SetTimer, GGG_API_GetLastActiveCharacter_TryAgain, -60000
        return
    }
    
    Loop % charsJSON.Count() {
        if (charsJSON[A_Index].lastActive = True) {
            lastChar := charsJSON[A_Index].name
            return lastChar  
        }
    }
    return

    GGG_API_GetLastActiveCharacter_TryAgain:
        GGG_API_GetLastActiveCharacter(accNameCopy)
    return
}

GGG_API_CreateDataFiles() {
    global PROGRAM
    langs := ["ENG","RUS","FRE","POR","THA","GER","SPA","KOR","TWN"]
	
	Loop % langs.Count() {
		thisLang := langs[A_Index]
		poeURL := GetPoeDotComUrlBasedOnLanguage(thisLang)
		url := poeURL "/api/trade/data/static", url2 := poeURL "/api/trade/data/items"
		headers := "Content-Type:application/json;charset=UTF-8", headers2 := headers
		options := "TimeOut: 25"
		. "`n"  "Charset: UTF-8", options2 := options
		WinHttpRequest_cURL(url, data:="", headers, options), html := data, jsonData := JSON_Load(html)
        WinHttpRequest_cURL(url2, data:="", headers2, options2), html2 := data, jsonData2 := JSON_Load(html2)

        jsonFinal := ObjFullyClone(jsonData.result), jsonFinal2 := ObjFullyClone(jsonData2.result)
        fileLocation := PROGRAM.DATA_FOLDER "/" thisLang "_poeDotComStaticData.json", fileLocation2 := PROGRAM.DATA_FOLDER "/" thisLang "_poeDotComItemsData.json"
        jsonText := JSON_Dump(jsonFinal, dontReplaceUnicode:=True), jsonText2 := JSON_Dump(jsonFinal2, dontReplaceUnicode:=True)
        hFile := FileOpen(fileLocation, "w", "UTF-8"), hFile2 := FileOpen(fileLocation2, "w", "UTF-8")
        hFile.Write(jsonText), hFile2.Write(jsonText2)
        hFile.Close(), hFile2.Close()
	}
}

GGG_API_BuildItemSearchObj(obj) {
/*  Convert POE TC slot infos into an item search obj
*/
/*  Informations when builing the search URL
    If the search is english, we can use the "term" field instead of splitting the item into "name" and "type"
    But for other languages, this doesn't seem to work. We are forced to use "name" and "type" fields
*/
/*
    Empty filter:
        {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    Full filter:
        {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"type_filters":{"filters":{"category":{"option":"weapon.one"},"rarity":{"option":"normal"}}},"weapon_filters":{"filters":{"damage":{"min":1,"max":2},"aps":{"min":3,"max":4},"crit":{"min":5,"max":6},"dps":{"min":7,"max":8},"pdps":{"min":9,"max":10},"edps":{"min":11,"max":12}}},"armour_filters":{"filters":{"ar":{"min":13,"max":14},"ev":{"min":15,"max":16},"es":{"min":17,"max":18},"block":{"min":19,"max":20}}},"socket_filters":{"filters":{"sockets":{"r":21,"g":22,"b":23,"w":24,"min":25,"max":26},"links":{"r":27,"g":28,"b":29,"w":30,"min":31,"max":32}}},"req_filters":{"filters":{"lvl":{"min":33,"max":34},"str":{"min":35,"max":36},"dex":{"min":37,"max":38},"int":{"min":39,"max":40}}},"map_filters":{"filters":{"map_tier":{"min":41,"max":42},"map_packsize":{"min":43,"max":44},"map_iiq":{"min":45,"max":46},"map_iir":{"min":47,"max":48},"map_shaped":{"option":"true"},"map_elder":{"option":"true"},"map_series":{"option":"legion"}}},"misc_filters":{"filters":{"quality":{"min":49,"max":50},"ilvl":{"min":51,"max":52},"gem_level":{"min":53,"max":54},"gem_level_progress":{"min":55,"max":56},"shaper_item":{"option":"true"},"elder_item":{"option":"true"},"synthesised_item":{"option":"true"},"alternate_art":{"option":"true"},"fractured_item":{"option":"true"},"corrupted":{"option":"true"},"crafted":{"option":"true"},"enchanted":{"option":"true"},"veiled":{"option":"true"},"mirrored":{"option":"true"},"identified":{"option":"true"},"talisman_tier":{"min":57,"max":58}}},"trade_filters":{"filters":{"account":{"input":"59"},"indexed":{"option":"3days"},"sale_type":{"option":"priced"},"price":{"option":"chaos","min":60,"max":61}}}}},"sort":{"price":"asc"}}
*/
/*  
    Unique weapon       {"query":{"status":{"option":"any"},"name":"","type":"","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Gem                 {"query":{"status":{"option":"any"},"type":"Faster Attacks Support","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"misc_filters":{"filters":{"quality":{"max":99,"min":1},"gem_level":{"max":99,"min":1}},"disabled":false},"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Map                 {"query":{"status":{"option":"any"},"type":{"option":"Cemetery Map","discriminator":"warfortheatlas"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false},"map_filters":{"filters":{"map_tier":{"min":1,"max":99}}}}},"sort":{"price":"asc"}}
    Jewel               {"query":{"status":{"option":"any"},"name":"","type":"","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}

    Unique weapon       {"query":{"status":{"option":"any"},"name":"Oro's Sacrifice","type":"Infernal Sword","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    (+ jewel)
    Gem                 {"query":{"status":{"option":"any"},"type":"Faster Attacks Support","stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"misc_filters":{"filters":{"quality":{"max":99,"min":1},"gem_level":{"max":99,"min":1}},"disabled":false},"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false}}},"sort":{"price":"asc"}}
    Map                 {"query":{"status":{"option":"any"},"type":{"option":"Cemetery Map","discriminator":"warfortheatlas"},"stats":[{"type":"and","filters":[],"disabled":false}],"filters":{"trade_filters":{"filters":{"account":{"input":"z0rhawk"}},"disabled":false},"map_filters":{"filters":{"map_tier":{"min":1,"max":99}}}}},"sort":{"price":"asc"}}
*/
    itemSplit := SplitItemNameAndBaseType(obj.Item, obj.Language), itemName := itemSplit.Name, itemBaseType := itemSplit.BaseType, itemCategory := itemSplit.Category
    if (itemName) {
        itemName_obj := {query:{term:itemName}}
        itemName_obj_trans := {query:{name:itemName}}
        itemName_obj := obj.Language="ENG" ? itemName_obj : itemName_obj_trans
    }
    if (itemBaseType)
        itemBaseType_obj := {"query":{"type":itemBaseType}}
    if (obj.GemQualityMin || obj.GemQualityMax)
        gemQual_obj := {"query":{"filters":{"misc_filters":{"filters":{"quality":{"min":obj.GemQualityMin,"max":obj.GemQualityMax}}}}}}
    if (obj.GemLevelMin || obj.GemLevelMax)
        gemLevel_obj := {"query":{"filters":{"misc_filters":{"filters":{"gem_level":{"min":obj.GemLevelMin,"max":obj.GemLevelMax}}}}}}
    if (obj.MapTierMin || obj.MapTierMax)
        mapTier_obj := {"query":{"filters":{"map_filters":{"filters":{"map_tier":{"min":obj.MapTierMin,"max":obj.MapTierMax}}}}}}
    if (obj.Account)
        accountName_obj := {"query":{"filters":{"trade_filters":{"filters":{"account":{"input":obj.Account}}}}}}
    if (obj.Online)
        online_obj := {"query":{"status":{"option":obj.Online}}}

    ; Building final obj
    ; baseObj := {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    baseObj := {"query":{"status":{"option":"any"},"stats":[{"type":"and","filters":[],"disabled":false}]},"sort":{"price":"asc"}}
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, itemName_obj)
    searchObj := ObjMerge(searchObj, itemBaseType_obj)
    searchObj := ObjMerge(searchObj, gemQual_obj)
    searchObj := ObjMerge(searchObj, gemLevel_obj)
    searchObj := ObjMerge(searchObj, mapTier_obj)
    searchObj := ObjMerge(searchObj, accountName_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj)

    return searchObj
}

/*
GGG_API_BuildExchangeSearchObj(obj) {
    if (obj.Account)
        account_obj := {exchange:{account:obj.Account}}
    if (obj.Online)
        online_obj := {exchange:{status:{option:obj.Online}}}
    if (obj.Fulfillable)
        fulfillable_obj := {exchange:{fulfillable:null}}
    if (obj.Minimum)
        minimum_obj := {exchange:{minimum:obj.Minimum}}
    if (obj.Want)
        if IsObject(obj.Want)
            want_obj := {exchange:{want:obj.Want}}
        else
            want_obj := {exchange:{want:[obj.Want]}}
    if (obj.Have)
        if IsObject(obj.Have)
            have_obj := {exchange:{have:obj.Have}}
        else
            have_obj := {exchange:{have:[obj.Have]}}

    ; Building final obj
    baseObj := {"exchange":{"status":{"option":"online"},"have":[],"want":[]}}
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, account_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj) ; TO_DO param to force merge, and also inspect why it doesnt merge - does key exist already?
    searchObj := ObjMerge(searchObj, fulfillable_obj)
    searchObj := ObjMerge(searchObj, minimum_obj)
    searchObj := ObjMerge(searchObj, want_obj)
    searchObj := ObjMerge(searchObj, have_obj)

    return searchObj
}
*/

GGG_API_GetMatchingExchangeData(obj) {
    ; Building the search obj based on provided infos, then retrieving results
    poeURL := GetPoeDotComUrlBasedOnLanguage(obj.Language), poeSearchObj := GGG_API_BuildExchangeSearchObj(obj)
    url := poeURL "/api/trade/exchange/" obj.League
    headers := "Content-Type:application/json;charset=UTF-8"
    data := JSON_Dump(poeSearchObj)
    options := "TimeOut: 25"
    . "`n"  "Charset: UTF-8"
    WinHttpRequest_cURL(url, data, headers, options), html := data, jsonData := JSON_Load(html)

    ; Making result list, retrieving individual items, then parsing those
    resultsListCount := 0, resultsIDList := ""
    resultsTotalCount := jsonData.result.Count()
    matchingObj := {}, matchIndex := 0
    Loop % jsonData.result.Count() {
        resultsIndex := A_Index, thisResultID := jsonData.result[resultsIndex], resultsListCount++
        resultsIDList := resultsIDList?resultsIDList "," thisResultID : thisResultID
        if (resultsListCount=20 || resultsIndex=resultsTotalCount) {
            url := poeURL "/api/trade/fetch/" resultsIDList "?exchange=true&query=" jsonData.id
            headers := "Content-Type:application/json;charset=UTF-8"
            options := "TimeOut: 25"
            . "`n"  "Charset: UTF-8"
            WinHttpRequest_cURL(url, data:="", headers, options), html := data, resultsJson := JSON_Load(html)

            Loop % resultsListCount {
                thisResult := resultsJson.result[A_Index]
                isDataMatching := GGG_API_IsExchangeDataMatching(obj, {Ratio:thisResult.listing.price.exchange.amount / thisResult.listing.price.item.amount})
                if (isDataMatching) {
                    matchingObj := {}
                    matchingObj.1 := resultsJson.result[A_Index]
                    Break
                }
                else {
                    matchIndex++
                    matchingObj[matchIndex] := resultsJson.result[A_Index]
                }
            }

            if (isDataMatching)
                Break

            ; FileDelete, html.txt
            ; FileAppend,% JSON_Dump(resultsJson), html.txt, utf-8
            resultsIDList := 0, resultsIDList := ""
        }
    }

    return matchingObj
}

GGG_API_BuildExchangeSearchObj(obj) {
    baseObj := {"exchange":{"status":{"option":"online"},"have":[],"want":[]}}

    if (obj.Account)
        account_obj := {"exchange":{"account":obj.Account}}
    if (obj.Online)
        online_obj := {"exchange":{"status":{"option":obj.Online}}}
    if (obj.Fulfillable)
        fulfillable_obj := {"exchange":{"fulfillable":null}}
    if (obj.Minimum)
        minimum_obj := {"exchange":{"minimum":obj.Minimum}}
    if (obj.Want)
        if IsObject(obj.Want)
            want_obj := {"exchange":{"want":obj.Want}}
        else
            want_obj := {"exchange":{"want":[obj.Want]}}
    if (obj.Have)
        if IsObject(obj.Have)
            have_obj := {"exchange":{"have":obj.Have}}
        else
            have_obj := {"exchange":{"have":[obj.Have]}}

    ; Building final obj
    searchObj := ObjFullyClone(baseObj)
    searchObj := ObjMerge(searchObj, account_obj)
    searchObj := ObjMerge(searchObj, online_obj)
    searchObj := ObjMerge(online_obj, searchObj)
    searchObj := ObjMerge(searchObj, fulfillable_obj)
    searchObj := ObjMerge(searchObj, minimum_obj)
    searchObj := ObjMerge(searchObj, want_obj)
    searchObj := ObjMerge(searchObj, have_obj)

    return searchObj
}

GGG_API_IsExchangeDataMatching(obj, obj2) {
    ratio1 := obj.Ratio, ratio2 := obj2.Ratio
    AutoTrimStr(ratio1, ratio2)
    ratio1 := RemoveTrailingZeroes(ratio1)
    ratio2 := RemoveTrailingZeroes(ratio2)

    if (ratio1 = ratio2)
        return True
    else return False
}

GGG_API_GetMatchingItemsData(obj) {
    ; Building the search obj based on provided infos, then retrieving results
    poeURL := GetPoeDotComUrlBasedOnLanguage(obj.Language), poeSearchObj := GGG_API_BuildItemSearchObj(obj)
    url := poeURL "/api/trade/search/" obj.League
    data := JSON_Dump(poeSearchObj)

    headers := "Accept: application/json"
    . "`n" "Content-Type: application/json"
    . "`n" "Cache-Control: max-age=0"
    options := "TimeOut: 25"
    . "`n"  "Charset: UTF-8"
    WinHttpRequest_cURL(url, data, headers, options), html := data, jsonData := JSON_Load(html)

    ; Making result list, retrieving individual items, then parsing those
    resultsListCount := 0, resultsIDList := ""
    resultsTotalCount := jsonData.result.Count()
    matchingObj := {}, matchIndex := 0
    Loop % jsonData.result.Count() {
        resultsIndex := A_Index, thisResultID := jsonData.result[resultsIndex], resultsListCount++
        resultsIDList := resultsIDList?resultsIDList "," thisResultID : thisResultID
        if (resultsListCount=10 || resultsIndex=resultsTotalCount) {
            url := poeURL "/api/trade/fetch/" resultsIDList "?query=" jsonData.id
            headers := "Content-Type:application/json;charset=UTF-8"
            options := "TimeOut: 25"
            . "`n"  "Charset: UTF-8"
            WinHttpRequest_cURL(url, data:="", headers, options), html := data, resultsJson := JSON_Load(html)

            Loop % resultsListCount {
                loopedResult := resultsJson.result[A_Index]
                isDataMatching := GGG_API_IsItemDataMatching(obj, {StashTab:loopedResult.listing.stash.name, StashX:loopedResult.listing.stash.x+1, StashY:loopedResult.listing.stash.y+1})
                if (isDataMatching) {
                    matchingObj := {}
                    matchingObj.1 := resultsJson.result[A_Index]
                    Break
                }
                else {
                    matchIndex++
                    matchingObj[matchIndex] := resultsJson.result[A_Index]
                }
            }

            if (isDataMatching)
                Break

            ; FileDelete, html.txt
            ; FileAppend,% JSON_Dump(jsonData), html.txt, utf-8
            resultsIDList := 0, resultsIDList := ""
        }
    }
    if (isDataMatching)
        return matchingObj
}

GGG_API_IsItemDataMatching(obj, obj2) {    
    if (obj.StashTab = obj2.StashTab)
    && (obj.StashX = obj2.StashX)
    && (obj.StashY = obj2.StashY)
        return True
}

SplitItemNameAndBaseType(itemFull, LANG="ENG") {
    global PROGRAM

    ; Labels := {"Accessories":1,"Armour":2,"Cards":3,"Currency":4,"Flasks":5,"Gems":6,"Jewels":7,"Maps":8,"Weapons":9,"Leaguestones":10,"Prophecies":11,"Captured Beasts":12}
    ; ENG_Labels := ["Accessories","Armour","Cards","Currency","Flasks","Gems","Jewels","Maps","Weapons","Leaguestones","Prophecies","Captured Beasts"]
    ; FRE_Labels := ["Accessoires","Armure","Cartes divinatoires","Objets monétaires","Flacons","Gemmes","Joyaux","Cartes","Armes","Pierres de ligue","Prophéties","Bêtes capturées"]
    ; GER_Labels := ["Schmuck","Rüstung","Weissagungskarten","Währung","Fläschchen","Gemmen","Juwelen","Karten","Waffen","Liga-Steine","Prophezeiungen","Eingefangene Bestien"]
    ; KOR_Labels := ["장신구","방어구","카드","화폐","플라스크","젬","주얼","지도","무기","리그스톤","예언","포획한 야수"]
    ; POR_Labels := ["Acessórios","Armadura","Cartas","Itens Monetários","Frascos","Gemas","Joias","Mapas","Armas","Pedras de Ligas","Profecias","Bestas Capturadas"]
    ; RUS_Labels := ["Бижутерия","Броня","Гадальные карты","Валюта","Флаконы","Камни","Самоцветы","Карты","Оружие","Камни лиги","Пророчества","Пойманные животные"]
    ; SPA_Labels := ["Accesorios","Armaduras","Cartas","Moneda","Frascos","Gemas","Joyas","Mapas","Armas","Piedras de Liga","Profecías","Bestias capturadas"]
    ; THA_Labels := ["เครื่องประดับ","เกราะ","การ์ด","เคอเรนซี่","ขวดยา","Gems","Jewels","แผนที่","อาวุธ","Leaguestones","Prophecies","สัตว์ที่ถูกจับ"]

    itemsJSON := JSON_Load(PROGRAM.DATA_FOLDER "\" LANG "_poeDotComItemsData.json")
 
    Loop % itemsJSON.Count() {
        loop1Index := A_Index, sectName := itemsJSON[loop1Index].label
        Loop % itemsJSON[loop1Index].entries.Count() {
            entryIndex := A_Index, thisEntry := itemsJSON[loop1Index].entries[A_Index]
            isUnique := thisEntry.flags.unique = True ? True : False
            isAccessory := sectName = "Accessories" ? True : False
            isArmour := sectName = "Armour" ? True : False
            isCard := sectName = "Cards" ? True : False
            isCurrency := sectName = "Currency" ? True : False
            isFlask := sectName = "Flasks" ? True : False
            isGem := sectName = "Gems" ? True : False
            isJewel := sectName = "Jewels" ? True : False
            isMap := sectName = "Maps" ? True : False
            isWeapon := sectName = "Weapons" ? True : False
            isLeaguestone := sectName = "Leaguestones" ? True : False
            isProphecy := thisEntry.flags.prophecy = True ? True : sectName = "Prophecies" ? True : False
            isCapturedBeast := sectName = "Captured Beasts" ? True : False

            ; if (thisEntry.name " " thisEntry.type = itemFull) && ( StrLen(thisEntry.name " " thisEntry.type) = StrLen(itemFull) ) ; unique items
            ;     Return {Name:thisEntry.name, BaseType:thisEntry.type} 
            ; else if (thisEntry.type = itemFull) ; other items with base type, white
            ;     Return {Name:thisEntry.name, BaseType:thisEntry.type}
            ; else if IsContaining(itemFull, thisEntry.type) { ; other items with base type, magic or rare
            ;     longestMatch := !longestMatch ? thisEntry ; making sure to only get the longest match
            ;         : longestMatch && StrLen(longestMatch) < StrLen(thisEntry.type) ? thisEntry
            ;         : longestMatch
            ; }

            if (isUnique) { ; Unique always have full name - .name then .type
                if (thisEntry.name " " thisEntry.type = itemFull) ; if match perfectly, that's our item
                    Return {Name:thisEntry.name, BaseType:thisEntry.type, Category:sectName}
            }
            else if (isCard || isCurrency || isMap || isGem) { ; .type is actual full name
                if (thisEntry.type = itemFull)
                    Return {Name:thisEntry.name, BaseType:thisEntry.type, Category:sectName}
            }
            else if (isProphecy) {

            }

            if (!isUnique || !thisEntry.name) ; if there is no .name, means this entry is not unique
                && IsContaining(itemFull, thisEntry.type) { ; if our item contains .type, it may be the one we're looking for

                longestMatch_bak := longestMatch
                longestMatch := !longestMatch ? thisEntry.type ; making sure to only get the longest match
                    : longestMatch && StrLen(longestMatch) < StrLen(thisEntry.type) ? thisEntry.type
                    : longestMatch
                if (longestMatch != longestMatch_bak) {
                    category := sectName
                    RegExMatch(itemFull, "iO)(.*?)" longestMatch, itemPat), itemName := itemPat.1, itemType := longestMatch
                    ; itemMatchSplit := StrSplit(itemFull, longestMatch), itemName := itemMatchSplit.1, itemType := itemMatchSplit.2
                    AutoTrimStr(itemName, itemType)
                }
            }
        }
    }
    Return {Name:itemName, BaseType:itemType, Category:category}
}

GGG_API_Generate_TradingLeaguesJson() {
    global PROGRAM

    FileDelete(PROGRAM.TRADING_LEAGUES_JSON)
    leaguesObj := GGG_API_Get_ActiveTradingLeagues()
    fileLocation := PROGRAM.TRADING_LEAGUES_JSON
    jsonText := JSON_Dump(leaguesObj, dontReplaceUnicode:=True)
    hFile := FileOpen(fileLocation, "w", "UTF-8")
    hFile.Write(jsonText)
    hFile.Close()
}

GGG_API_Get_ActiveTradingLeagues() {
/*		Retrieves leagues from the API
*/
	global PROGRAM, GAME
	static langIndex

    langs := ["ENG","RUS","KOR","TWN"]
    /* Not required with new API link
    excludedWords := "SSF,Solo" ; ENG,FRE,POR,THA,GER,SPA,KOR - all using english league names
        . ",Соло" ; RUS
        . ",自力" ; TWN
        . "" ; KOR - Korean API sucks. League name is ENG on both the API and Forums thread - But on the trading whisper it's translated. Once again "translated whispers suck and are inconsistent"
        */
    tradingLeagues := [], tradingLeaguesList := ""
	
	Loop % langs.Count() {
        if IsNum(langIndex) && (langIndex > A_Index) { ; This means we are running the function again after failing a request. We are starting again at the last index we stopped at
            AppendtoLogs(A_ThisFunc "() - Now running again and skipping index " A_Index " of langs array.")
            isRunningAgain := True
            Continue
        }
        if (isRunningAgain)
            AppendtoLogs(A_ThisFunc "() - Now running again and going with index " A_Index " of langs array.")

        langIndex := A_Index
		thisLang := langs[langIndex]
		poeURL := GetPoeDotComUrlBasedOnLanguage(thisLang)
		url := poeURL "/api/trade/data/leagues"
        headers := "Host: " StrSplit(poeURL, "https://").2
        . "`n" "Accept: application/json"
        . "`n" "Accept-Language: en-US,en;q=0.5"
        ; . "`n" "Accept-Encoding: gzip, deflate, br"
        . "`n" "Upgrade-Insecure-Requests: 1"
        . "`n" "Cache-Control: max-age=0"
        options := "TimeOut: 25"
		    . "`n"  "Charset: UTF-8"
        WinHttpRequest_cURL(url, data:="", headers, options), html := data, resultsJson := JSON_Load(html)   
        if (resultsJson.error || !IsObject(resultsJson)) {
            AppendtoLogs("Error when reaching league API: "
            . "`n" "URL: " url
            . "`n`n" JSON_Dump("HTML: " resultsJson)
            . "`n`n" "Headers: " headers)

            Loop, Parse, headers, `n, `r
            {
                if RegExMatch(A_LoopField, "iO)Retry-After: (/d+)", retryAfter) {
                    retryAfter := retryAfter.1
                }
            }
            if IsNum(retryAfter) {
                AppendtoLogs(A_ThisFunc "() - Retry-After header detected (" retryAfter "). Will retry again shortly after timeout.")
                if (!hasWarned_rate)
                    TrayNotifications.Show("League API - Rate Limited", "Waiting " retryAfter " seconds before trying to reach API again.")
                hasWarned_rate := True
            }
            else {
                retryAfter := 300
                AppendtoLogs(A_ThisFunc "() - Unable to detect the Retry-After header. Skipping league names for this lang.")
                if (!hasWarned_fail)
                    TrayNotifications.Show("Failed to reach League API", "Retrying in " Round(retryAfter/60) " minutes.")
                hasWarned_fail := True
            }

            SetTimer,% A_ThisFunc,% "-" (retryAfter+1)*1000
            retryAfter := 
        }        
        else if (data && resultsJson) {
            Loop % resultsJson.result.Count() {
                leagueName := resultsJson.result[A_Index].text

                if (leagueName) && !IsIn(leagueName, tradingLeaguesList) { ; && !IsContaining(leagueName, excludedWords) {
                    tradingLeagues.Push(leagueName)
                    tradingLeaguesList := tradingLeaguesList ? tradingLeaguesList "," leagueName : leagueName
                }
            }
        }
        Sleep 500 ; No need to hurry, this only happens once at script start - avoid api spam
    }

    localLeaguesJSON := JSON_Load(PROGRAM.TRADING_LEAGUES_JSON)
    tradingLeagues := ObjMerge(localLeaguesJSON, tradingLeagues)
    GAME.LEAGUES := ObjMerge(GAME.LEAGUES, tradingLeagues)
	Return tradingLeagues
}

GetPoeDotComUrlBasedOnLanguage(lang) {
    poeUrlPrefix := lang="ENG"?"www"
        : lang = "RUS" ? "ru"
        : lang = "FRE" ? "fr"
        : lang = "POR" ? "br"
        : lang = "THA" ? "th"
        : lang = "GER" ? "de"
        : lang = "SPA" ? "es"
        : lang = "KOR" ? "" ; not needed, they use different url
        : lang = "TWN" ? "" ; same
        : "www"

    poeUrl := lang="KOR" ? "https://poe.game.daum.net"
        : lang="TWN" ? "https://web.poe.garena.tw"
        : "https://" poeUrlPrefix ".pathofexile.com"

    return poeUrl
}
