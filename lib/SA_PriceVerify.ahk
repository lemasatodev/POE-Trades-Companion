#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoTrayIcon
#NoEnv
ListLines, Off

; SetTimer, ExitScript, -20000

cmdLineParams := Get_CmdLineParameters()
VerifyItemPrice(cmdLineParams)
ExitApp
Return

ExitScript() {
    global cmdLineParamsObj

    SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "The request took more than 20 seconds and was canceled."})
}

SendDataBack(obj) {
    global cmdLineParamsObj

    ; Construct data string that'll be transmited to intercom
    data := "tabNum := GUI_Trades_V2.GetTabNumberFromUniqueID(Sell," cmdLineParamsObj.TradeData.UniqueID ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerifyColor," obj.VerifyColor ")"
    . "`n"  "GUI_Trades_V2.UpdateSlotContent(Sell,%tabNum%,TradeVerifyText," obj.VerifyTxt ")"

    ControlSetText, ,% data,% "ahk_id " cmdLineParamsObj.Intercom.SlotHandle
}

VerifyItemPrice(cmdLineParams) {
    global PROGRAM, cmdLineParamsObj

    ; Converting cmdLineParams into obj
    startPos := 1, cmdLineParamsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break
        startPos := foundPos+StrLen(outMatch.0), cmdLineParamsObj[outMatch.1] := outMatch.2
    }
    jsonFile := cmdLineParamsObj.CmdLineParamsJSON
    cmdLineParamsObj := "", cmdLineParamsObj := JSON_Load(jsonFile)
    FileDelete,% jsonFile

    PROGRAM := ObjFullyClone(cmdLineParamsObj.PROGRAM)
    tabInfos := cmdLineParamsObj.TradeData
    logsFolder := PROGRAM.LOGS_FILE
    SplitPath, logsFolder, , logsFolder

    if (tabInfos.ItemCurrency && tabInfos.ItemCount) { ; Currency trade
        buyerWantsType := tabInfos.ItemCurrency, buyerWantsCount := tabInfos.ItemCount
        buyerGivesType := tabInfos.PriceCurrency, buyerGivesCount := tabInfos.PriceCount
        saleRatio := RemoveTrailingZeroes(buyerGivesCount/buyerWantsCount)

        poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" tabInfos.WhisperLanguage "_poeDotComStaticData.json")
        Loop % poeStaticData.Count() {
            loop1Index := A_Index
            Loop % poeStaticData[loop1Index].entries.Count() {
                thisEntry := poeStaticData[loop1Index].entries[A_Index]
                if (thisEntry.text = buyerWantsType)
                    buyerWantsID := thisEntry.id
                if (thisEntry.text = buyerGivesType)
                    buyerGivesID := thisEntry.id
                if (buyerWantsID && buyerGivesID)
                    Break 
            }
            if (buyerWantsID && buyerGivesID)
                Break
        }

        if (!buyerWantsType || !buyerWantsCount || !buyerWantsID || !buyerGivesType || !buyerGivesCount || !buyerGivesID) {
            SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Failed to retrieve informations for this currency trade"
                . "\n" "Buyer wants type: " buyerWantsType
                . "\n" "Buyer wants type ID: " buyerWantsID
                . "\n" "Buyer wants count: " buyerWantsCount
                . "\n" "Buyer gives type: " buyerGivesType
                . "\n" "Buyer gives type ID: " buyerGivesID
                . "\n" "Buyer gives count: " buyerGivesCount
                . "\n"
                . "\n" "If you think this is a bug and you can clearly see your own item online"
                . "\n" "then please contact me on GitHub with your logs folder in a zip archive"
                . "\n" "Logs folder location: " logsFolder})
            AppendToLogs("Failed to retrieve informations for currency trade"
                . "\n" "Buyer wants type: " buyerWantsType
                . "\n" "Buyer wants type ID: " buyerWantsID
                . "\n" "Buyer wants count: " buyerWantsCount
                . "\n" "Buyer gives type: " buyerGivesType
                . "\n" "Buyer gives type ID: " buyerGivesID
                . "\n" "Buyer gives count: " buyerGivesCount
                . "\n" "CmdLineParamsObj Dump: " JSON_Dump(cmdLineParamsObj))
            return
        }

        for index, accName in cmdLineParamsObj.Accounts
        {
            exchangeSearchObj := {Want:buyerWantsID, Have:buyerGivesID
                ,Account:accName, Ratio:saleRatio, Online:"any", Language:tabInfos.WhisperLanguage, League:tabInfos.League}
            matchingListings := GGG_API_GetMatchingExchangeData(exchangeSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                onlineRatio := RemoveTrailingZeroes(thisListing.price.exchange.amount / thisListing.price.item.amount)
                ratioTxt := "Online: `t1 " buyerWantsType " = " onlineRatio " " buyerGivesType
                    . "\n" "Whisper: `t1 " buyerWantsType " = " saleRatio " " buyerGivesType

                if (onlineRatio = saleRatio)
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Ratio is matching\n" ratioTxt})
                else if (onlineRatio < saleRatio)
                    SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Ratio is advantageous\n" ratioTxt})
                else if (onlineRatio > saleRatio)
                    SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Ratio is incorrect and lower\n" ratioTxt})
            }
        }
        SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Could not find any listing matching this currency trade"
            . "\n" "Buyer wants type: " buyerWantsType
            . "\n" "Buyer wants type ID: " buyerWantsID
            . "\n" "Buyer wants count: " buyerWantsCount
            . "\n" "Buyer gives type: " buyerGivesType
            . "\n" "Buyer gives type ID: " buyerGivesID
            . "\n" "Buyer gives count: " buyerGivesCount
            . "\n"
            . "\n" "If you think this is a bug and you can clearly see your own item online"
            . "\n" "then please contact me on GitHub with your logs folder in a zip archive"
            . "\n" "Logs folder location: " logsFolder})
        AppendToLogs("Could not find any listing matching this currency trade"
            . "\n" "Buyer wants type: " buyerWantsType
            . "\n" "Buyer wants type ID: " buyerWantsID
            . "\n" "Buyer wants count: " buyerWantsCount
            . "\n" "Buyer gives type: " buyerGivesType
            . "\n" "Buyer gives type ID: " buyerGivesID
            . "\n" "Buyer gives count: " buyerGivesCount
            . "\n" "CmdLineParamsObj Dump: " JSON_Dump(cmdLineParamsObj))
    }
    else { ; Regular trade
        priceType := tabInfos.PriceCurrency, priceCount := tabInfos.PriceCount
        langs := tabInfos.WhisperLanguage="ENG" ? ["ENG"] : ["ENG",tabInfos.WhisperLanguage]

        if (priceType && priceCount) {
            Loop % langs.Count() {
                lang := langs[A_Index]
                poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" lang "_poeDotComStaticData.json")
                Loop % poeStaticData.Count() {
                    loop1Index := A_Index
                    Loop % poeStaticData[loop1Index].entries.Count() {
                        thisEntry := poeStaticData[loop1Index].entries[A_Index]
                        if (thisEntry.text = priceType)
                            priceID := thisEntry.id
                        if (priceID)
                            Break
                    }
                    if (priceID)
                        Break
                }
                if (priceID)
                    Break
            }
        }
        else
            isUnpriced := True

        if (!priceType || !priceCount || !priceID) && (!isUnpriced) {
            SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Failed to retrieve informations for this trade"
                . "\n" "Item Name: " tabInfos.Item
                . "\n" "Price Currency: " priceType
                . "\n" "Price Currency ID: " priceID
                . "\n" "Price Count: " priceCount
                . "\n"
                . "\n" "If you think this is a bug and you can clearly see your own item online"
                . "\n" "then please contact me on GitHub with your logs folder in a zip archive"
                . "\n" "Logs folder location: " logsFolder})
            AppendToLogs("Failed to retrieve informations for this trade"
                . "\n" "Item Name: " tabInfos.Item
                . "\n" "Price Currency: " priceType
                . "\n" "Price Currency ID: " priceID
                . "\n" "Price Count: " priceCount
                . "\n" "CmdLineParamsObj Dump: " JSON_Dump(cmdLineParamsObj))
            return
        }

        for index, accName in cmdLineParamsObj.Accounts
        {
            itemSearchObj := {Item:tabInfos.Item
                ,GemQualityMin:tabInfos.GemQuality, GemQualityMax:tabInfos.GemQuality
                ,GemLevelMin:tabInfos.GemLevel, GemLevelMax:tabInfos.GemLevel
                ,MapTierMin:tabInfos.MapTier, MapTierMax:tabInfos.MapTier
                ,League:tabInfos.League, StashTab:tabInfos.StashTab, StashX:tabInfos.StashX, StashY:tabInfos.StashY
                ,Account:accName, Online:"any", Language:tabInfos.WhisperLanguage}
            matchingListings := GGG_API_GetMatchingItemsData(itemSearchObj)

            if !IsObject(matchingListings)
                Continue ; Go with next account

            Loop % matchingListings.Count() {
                thisListing := matchingListings[A_Index].listing
                listingPriceCurrency := thisListing.price.currency, listingPriceCount := thisListing.price.amount

                priceTxt := !IsObject(thisListing.price) ? "Online: `t No listed price" : "Online: `t " listingPriceCount " " listingPriceCurrency
                priceTxt .= isUnpriced ? "\nWhisper: `t No listed price" : "\nWhisper: `t " tabInfos.PriceCount " " priceID
                    
                if (isUnpriced) {
                    if (listingPriceCurrency) ; Online has price but whisper not
                        SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "Whisper does not contain price\n" priceTxt}), finish := True
                    else ; Whisper has price but online not
                        SendDataBack({"VerifyColor": "Green", "VerifyTxt": "This item is not priced\n" priceTxt}), finish := True
                }
                else if (listingPriceCurrency && priceID) {
                    if (listingPriceCurrency = priceID && listingPriceCount = tabInfos.PriceCount) ; Currency type and count match
                        SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Price is matching\n" priceTxt}), finish := True
                    else if (listingPriceCurrency = priceID && listingPriceCount < tabInfos.PriceCount) ; Currency type match and count is higher
                        SendDataBack({"VerifyColor": "Green", "VerifyTxt": "Price is advantageous\n" priceTxt}), finish := True
                    else if (listingPriceCurrency = priceID && listingPriceCount > tabInfos.PriceCount) ; Currency type match but count is lower
                        SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Price is incorrect\n" priceTxt}), finish := True
                    else if (listingPriceCurrency != priceID) ; Currency count match but type is different
                        SendDataBack({"VerifyColor": "Red", "VerifyTxt": "Currency is incorrect\n" priceTxt}), finish := True
                }

                if (finish)
                    return
            }
        }
        SendDataBack({"VerifyColor": "Orange", "VerifyTxt": "/!\ Could not find any listing matching the same item trade"
            . "\n" "Item Name: " tabInfos.Item
            . "\n" "Price Currency: " priceType
            . "\n" "Price Currency ID: " priceID
            . "\n" "Price Count: " priceCount
            . "\n"
            . "\n" "If you think this is a bug and you can clearly see your own item online"
            . "\n" "then please contact me on GitHub with your logs folder in a zip archive"
            . "\n" "Logs folder location: " logsFolder})
        AppendToLogs("Could not find any listing matching the same item trade"
            . "\n" "Item Name: " tabInfos.Item
            . "\n" "Price Currency: " priceType
            . "\n" "Price Currency ID: " priceID
            . "\n" "Price Count: " priceCount
            . "\n" "CmdLineParamsObj Dump: " JSON_Dump(cmdLineParamsObj))
    }
}

#Include %A_ScriptDir%
#Include CmdLineParameters.ahk
#Include EasyFuncs.ahk
#Include Logs.ahk
#Include GGG_API.ahk
#Include PoeTrade.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%/third-party
#Include cURL.ahk
#Include JSON.ahk
#Include StdOutStream.ahk
#Include UriEncode.ahk
#Include WinHttpRequest.ahk
