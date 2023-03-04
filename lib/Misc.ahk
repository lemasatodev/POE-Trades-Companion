Get_CurrencyInfos(currency, dontWriteLogs=False) {
/*		Compare the specified currency with poe.trade abridged currency names to retrieve the real currency name.
		When the string is plural, check if the full list of currencies contains its non-plural counterpart.
 */
 	global PROGRAM
	isCurrencyListed := False

	if RegExMatch(currency, "See Offer") {
		Return {Name:currency, Is_Listed:False}
	}
	else if (!currency || currency = "" || currency = " ")
		return {Name:currency, Is_Listed:False}

	currency := RegExReplace(currency, "\d")
	AutoTrimStr(currency) ; Remove whitespaces
	lastChar := SubStr(currency, 0) ; Get last char
	if (lastChar = "s") ; poeapp adds an "s" for >1 currencies
		StringTrimRight, currencyWithoutS, currency, 1

	if RegExMatch(currency, "O) Map$", pat) ; If ends with map
        StringTrimRight, currencyWithoutMap, currency,% StrLen(pat.0) ; Remove it from name

	currencyToCheckList := []
	currencyToCheckList.Push(currency)
	if (currencyWithoutS)
		currencyToCheckList.Push(currencyWithoutS)
	if (currencyWithoutMap)
		currencyToCheckList.Push(currencyWithoutMap)

	isCurrencyListed := False, currencyFullName := ""
	Loop % currencyToCheckList.MaxIndex() {
		thisCurrency := currencyToCheckList[A_Index]
		if !IsIn(thisCurrency, PROGRAM.DATA.CURRENCY_LIST) {
			currencyFullName := PROGRAM.DATA.POETRADE_CURRENCY_DATA[thisCurrency] ? PROGRAM.DATA.POETRADE_CURRENCY_DATA[thisCurrency]
				:	PROGRAM.DATA.POEDOTCOM_CURRENCY_DATA[thisCurrency] ? PROGRAM.DATA.POEDOTCOM_CURRENCY_DATA[thisCurrency]
				:	""
			isCurrencyListed := currencyFullName?True:False
		}
		else { ; Currency is in list
			isCurrencyListed := True, currencyFullName := thisCurrency
		}

		if (isCurrencyListed=True)
			Break
	}
	if (!currencyFullName && dontWriteLogs=False) ; Unknown currency name 
		AppendToLogs(A_ThisFunc "(currency=" currency "): Unknown currency name.")

	Return {Name:currencyFullName, Is_Listed:isCurrencyListed}
}

Do_Action(actionType, actionContent="", _buyOrSell="", tabNum="", uniqueNum="") {
	global PROGRAM, GuiTrades, GuiTrades_Controls
	static prevNum, ignoreFollowingActions, prevActionType, prevActionContent
	if !(tabNum) && (_buyOrSell)
		tabNum := GuiTrades[_buyOrSell].Active_Tab

	if (uniqueNum) && (uniqueNum = prevNum) && (ignoreFollowingActions) {
		prevNum := uniqueNum, ignoreFollowingActions := False
		AppendToLogs(A_thisFunc "(actionType=" actionType ", actionContent=" actionContent ", isHotkey=" isHotkey ", uniqueNum=" uniqueNum "): Action ignored."
		. "`n" "ignoreFollowingActions=""" ignoreFollowingActions """, prevActionType=""" prevActionType """, prevActionContent=""" prevActionContent """.")
		Return
	}

	if (SubStr(actionContent, 1, 1) = """") && (SubStr(actionContent, 0) = """") ; Removing quotes
		actionContent := StrTrimLeft(actionContent, 1), actionContent := StrTrimRight(actionContent, 1)

	if (ACTIONS_FORCED_CONTENT[actionType]) && !(actionContent)
		actionContent := ACTIONS_FORCED_CONTENT[actionType]

	actionContentWithVariables := Replace_TradeVariables(_buyOrSell, tabNum, actionContent)
	if !VerifyActionContentValidity(actionContent, actionContentWithVariables)
		return

	if IsIn(prevActionType, "COPY_ITEM_INFOS,WRITE_MSG,SENDINPUT,SENDEVENT") {
		; AppendToLogs(A_thisFunc "(actionType=" actionType ", actionContent=" actionContent ", isHotkey=" isHotkey ", uniqueNum=" uniqueNum "):"
		; . "Sleeping for 10ms due to previous action (" prevActionType ") being listed as using the clipboard.")
		Sleep 10
	}

	if RegExMatch(actionType, "iO)(.*)_INTERFACE_CUSTOM_BUTTON_ROW_(\d+)_NUM_(\d+)", matchObj) {
		GUI_Trades_V2.DoCustomButtonAction(matchObj.1, matchObj.2, matchObj.3, tabNum)
		; ControlClick,,% "ahk_id " GuiTrades.Handle " ahk_id " GuiTrades_Controls["hBTN_Custom" actionType_NumOnly],,,, NA
	}
	else if (actionType = "SEND_MSG") {
		if IsContaining(actionContent, "%myself%") {
			if (!PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.Count())
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToKickSelf_Title, PROGRAM.TRANSLATIONS.TrayNotifications.FailedToKickSelf_Msg)
			else
				Send_GameMessage("WRITE_SEND", actionContentWithVariables, gamePID)
		}
		else
			Send_GameMessage("WRITE_SEND", actionContentWithVariables, gamePID)
	}
	else if (actionType = "WRITE_MSG") {
		Send_GameMessage("WRITE_DONT_SEND", actionContentWithVariables, gamePID)
		ignoreFollowingActions := True
	}
	else if (actionType = "WRITE_THEN_GO_BACK") {
		Send_GameMessage("WRITE_GO_BACK", actionContentWithVariables, gamePID)
		ignoreFollowingActions := True
	}

	else if (actionType = "COPY_ITEM_INFOS")
		GoSub, GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab_Timer
	else if (actionType = "GO_TO_NEXT_TAB")
		GUI_Trades_V2.SelectNextTab(_buyOrSell)
	else if (actionType = "GO_TO_PREVIOUS_TAB")
		GUI_Trades_V2.SelectPreviousTab(_buyOrSell)
	else if (actionType = "CLOSE_TAB")
		GUI_Trades_V2.RemoveTab(_buyOrSell, tabNum)
	else if (actionType = "CLOSE_ALL_TABS")
		GUI_Trades_V2.CloseAllTabs(_buyOrSell)
	else if (actionType = "TOGGLE_MIN_MAX")
		GUI_Trades_V2.Toggle_MinMax(_buyOrSell)
	else if (actionType = "FORCE_MIN")
		GUI_Trades_V2.Minimize(_buyOrSell)
	else if (actionType = "FORCE_MAX")
		GUI_Trades_V2.Maximize(_buyOrSell)
	else if (actionType = "SAVE_TRADE_STATS")
		GUI_Trades_V2.SaveStats(_buyOrSell, tabNum)
	else if (actionType = "SHOW_LEAGUE_SHEETS")
		GUI_Trades_V2.HotBarButton(_buyOrSell, "LeagueHelp")

	else if (actionType = "SLEEP")
		Sleep %actionContentWithVariables%
	else if (actionType = "SENDINPUT")
		SendInput,%actionContentWithVariables%
	else if (actionType = "SENDEVENT")
		SendEvent,%actionContentWithVariables%
	else if (actionType = "IGNORE_SIMILAR_TRADE")
		GUI_Trades_V2.AddTrade_To_IgnoreList(tabNum, actionContent)
	else if (actionType = "CLOSE_SIMILAR_TABS")
		GUI_Trades_V2.CloseOtherTabsForSameItem(_buyOrSell, tabNum)
	else if (actionType = "SHOW_GRID")
		GUI_Trades_V2.ShowItemGrid(tabNum)

	prevNum := uniqueNum, prevActionType := actionType, prevActionContent := actionContentWithVariables	
}

VerifyActionContentValidity(acContent, acContentWithVar) {
	global PROGRAM

	StringSplit, contentWords, acContentWithVar,% A_Space
	if ( SubStr(acContentWithVar, 1, 2) = "@ ") {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceledVarEmpty_Msg, "%name%", contentWords1)
		trayMsg := StrReplace(trayMsg, "%variable%", acContent)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceled_Title, trayMsg)
		return 0
	}
	else if ( SubStr(contentWords1, 2, 1) = "%" || SubStr(contentWords1, 0, 1) = "%" ) {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceledVarTypo_Msg, "%variable%", acContent)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.MessageCanceled_Title, trayMsg)
		return 0
	}
	return 1
}

Get_Changelog(removeTrails=False) {
	global PROGRAM

	if (PROGRAM.IS_BETA = "True")
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE_BETA
	else
		FileRead, changelog,% PROGRAM.CHANGELOG_FILE

	if (removeTrails=True) {
		changelog := StrReplace(changelog, A_Tab, "")
		AutoTrimStr(changelog)
	}

	len := StrLen(changelog)
	if ( len > 60000 ) {
		trim := len - 60000
		StringTrimRight, changelog, changelog, %trim%
		changelog .= "`n`n`n[ Changelog file trimmed. See full changelog file GitHub ]"
	}

	return changelog
}

Set_Clipboard(str) {
	global PROGRAM
	global SET_CLIPBOARD_CONTENT

	Clipboard := str, tickCount := A_TickCount
	while (Clipboard != str) {
		Clipboard := ""
		Clipboard := str
		ClipWait, 2
		if (Clipboard = str)
			break

		if (A_TickCount-tickCount > 2000) {
			trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ClipboardFailedToUpdate_Msg, "%message%", str)
			TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ClipboardFailedToUpdate_Title, trayMsg)
			return
		}
		Sleep 100
	}

	SET_CLIPBOARD_CONTENT := str
}

Reset_Clipboard() {
	global SET_CLIPBOARD_CONTENT
	if (Clipboard = SET_CLIPBOARD_CONTENT)
		Clipboard := ""
}

Replace_TradeVariables(_buyOrSell, tabNum="", string="") {
	global PROGRAM, GuiTrades, GAME
	static lastCharacterLogged, timeSinceRetrievedChar

	if (tabNum) {
		tabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, tabNum)
		string := StrReplace(string, "%buyer%", tabContent.Buyer), string := StrReplace(string, "%buyerName%", tabContent.Buyer)
		string := StrReplace(string, "%seller%", tabContent.Seller), string := StrReplace(string, "%sellerName%", tabContent.Seller)
		string := StrReplace(string, "%item%", tabContent.Item), string := StrReplace(string, "%itemName%", tabContent.Item)
		string := StrReplace(string, "%price%", tabContent.Price != ""? tabContent.Price : "[unpriced]"), string := StrReplace(string, "%itemPrice%", tabContent.Price != ""?tabContent.Price : "[unpriced]")
		string := StrReplace(string, "%tradingWhisper%", tabContent.WhisperMsg), string := StrReplace(string, "%tradingWhisperMsg%", tabContent.WhisperMsg)
	}
	string := StrReplace(string, "%lastWhisper%", GuiTrades.Last_Whisper_Name), string := StrReplace(string, "%lastWhisperReceived%", GuiTrades.Last_Whisper_Name), string := StrReplace(string, "%lwr%", GuiTrades.Last_Whisper_Name)
	string := StrReplace(string, "%sentWhisper%", GuiTrades.Last_Whisper_Sent_Name), string := StrReplace(string, "%lastWhisperSent%", GuiTrades.Last_Whisper_Sent_Name), string := StrReplace(string, "%lws%", GuiTrades.Last_Whisper_Sent_Name)

	if IsContaining(string, "%myself%") {
		firstAcc := PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.1
		if (!lastCharacterLogged)
			poeLoggedChar := GGG_API_GetLastActiveCharacter(firstAcc)
		lastCharacterLogged := poeLoggedChar?poeLoggedChar:lastCharacterLogged

		string := StrReplace(string, "%myself%", lastCharacterLogged)
	}

	if IsContaining(string, "%myzone%") {
		if (tabNum)
			playerZone := GAME[tabContent.GamePID].PlayerZone
		else {
			prevTitleMatchMode := SetTitleMatchMode("RegEx")
			if WinActive("[a-zA-Z0-9_] ahk_group POEGameGroup")
				WinGet, activePID, PID, A
			else
				WinGet, activePID, PID,% "[a-zA-Z0-9_] ahk_group POEGameGroup"
			SetTitleMatchMode(prevTitleMatchMode)
			playerZone := GAME[activePID].PlayerZone
		}
		playerZone := playerZone ? playerZone : "Undefined Area"
		string := StrReplace(string, "%myzone%", playerZone)
	}

	return string
}

Get_SkinAssetsAndSettings() {
	global PROGRAM

	presetName := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset
	skinName := presetName="Custom" ? PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom.Skin : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Skin
	skinFolder := PROGRAM.SKINS_FOLDER "\" skinName
	skinAssetsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Assets.ini"
	skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini"

	skinAssets := {}
	iniSections := Ini.Get(skinAssetsFile)
	Loop, Parse, iniSections, `n, `r
	{
		skinAssets[A_LoopField] := {}
		keysAndValues := INI.Get(skinAssetsFile, A_LoopField,, 1)

		for key, value in keysAndValues	{
			SplitPath, value, , , fileExt
			if IsIn(fileExt, "jpg,png,ico,jpeg,gif,bmp") 
				skinAssets[A_LoopField][key] := skinFolder "\" value
			else
				skinAssets[A_LoopField][key] := value
		}
	}

	skinSettings := {}
	skinSettingsFile := PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini"
	iniSections := INI.Get(skinSettingsFile)
	Loop, Parse, iniSections, `n, `r
	{
		skinSettings[A_LoopField] := {}
		keysAndValues := INI.Get(skinSettingsFile, A_LoopField,, 1)

		for key, value in keysAndValues {
			skinSettings[A_LoopField][key] := value
		}
	}

	if (presetName = "Custom") {
		userSkinSettings := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom
		skinSettings.FONT.Name := userSkinSettings.Font
		skinSettings.FONT.Size := userSkinSettings.FontSize
		skinSettings.FONT.Quality := userSkinSettings.FontQuality

		/*
		for iniKey, iniValue in userSkinSettings {
			iniKeySubStr := SubStr(iniKey, 1, 6)
			if (iniKeySubStr = "Color_" ) {
				iniKeyRestOfStr := SubStr(iniKey, 7)
				skinSettings.COLORS[iniKeyRestOfStr] := iniValue
			}
		}
		*/
	}



	Skin := {}
	Skin.Preset := presetName
	Skin.Skin := skinName
	Skin.Skin_Folder := skinFolder
	Skin.Assets := skinAssets
	Skin.Settings := skinSettings

	return Skin
}

Declare_SkinAssetsAndSettings(_skinSettingsAll="") {
	; TO_DO proper func when compact is fully released
	global SKIN

	/* TO_DO temporarily disabled as bandaid, forcing to get skin settings no matter if param is passed or not
	skinSettingsAll := _skinSettingsAll
	if !IsObject(_skinSettingsAll)
		skinSettingsAll := Get_SkinAssetsAndSettings()
	*/
	skinSettings := Get_SkinAssetsAndSettings()

	SKIN := skinSettings
}
