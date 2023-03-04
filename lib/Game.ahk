IsGameWindowActive() {
	global POEGameList
	WinGet, activeWinExe, ProcessName, A
	return IsIn(activeWinExe, POEGameList)
}

Send_GameMessage(actionType, msgString, gamePID="") {
	global PROGRAM, GAME
	global MyDocuments
	static openChatStr, clearChatStr
	openChatStr := "", clearChatStr := ""
	scanCode_v := PROGRAM.SCANCODES.v, scanCode_Enter := PROGRAM.SCANCODES.Enter

	Thread, NoTimers

;	Retrieve the virtual key id for chat opening
	chatVK := GAME.SETTINGS.ChatKey_VK ? GAME.SETTINGS.ChatKey_VK : "0xD"
	prevTitleMatchMode := SetTitleMatchMode("RegEx") ; RegEx = Fix some case where specifying only the pid does not work
	firstChar := SubStr(msgString, 1, 1) ; Get first char, to compare if its a special chat command

	if !(gamePID)
		WinGet, gamePID, PID, [a-zA-Z0-9_] ahk_group POEGameGroup

	WinActivate,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%
	if !WinActive("[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " gamePID) {
		WinWaitActive,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%, ,2
		waitActiveErrLvl := ErrorLevel
	}

	if (waitActiveErrLvl) {
		SetTitleMatchMode(prevTitleMatchMode) 
		AppendToLogs(A_ThisFunc "(actionType=" actionType ", msgString=" msgString ", gamePID=" gamePID "): WinWaitActive timed out.")
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.GameWindowFocusTimedOut_Title, PROGRAM.TRANSLATIONS.TrayNotifications.GameWindowFocusTimedOut_Msg)
		return "WINWAITACTIVE_TIMEOUT"
	}

	isToolSameElevation := Is_Tool_Elevation_SameLevel_As_GameInstance(gamePID)
	if (!isToolSameElevation) {
		MsgBox(4096+48+4, PROGRAM.NAME " - " PROGRAM.TRANSLATIONS.MessageBoxes.ReloadAsAdmin_Title, PROGRAM.TRANSLATIONS.MessageBoxes.ReloadAsAdmin_Msg)

		IfMsgBox, Yes
		{
			GUI_Trades_V2.SaveBackup("Sell")
			ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
		}
		else {
			SetTitleMatchMode(prevTitleMatchMode) 
			return
		}
	}

	if (actionType = "WRITE_DONT_SEND") && IsContaining(msgString, "%goBackHere%") {
		foundPos := InStr(msgString, "%goBackHere%"), _strLen := StrLen(msgString), leftPresses := _strLen-foundPos+1-StrLen("%goBackHere%")
		msgString := StrReplace(msgString, "%goBackHere%", "")
	}

	GoSub, Send_GameMessage_GetOpenChatStr
	GoSub, Send_GameMessage_GetClearChatStr

	Set_Clipboard(msgString)
	pasteMsgStr := "{Ctrl Down}{" scanCode_v "}{Ctrl Up}"
	if (leftPresses)
		pressLeftStr := "{Left " leftPresses "}"
	if (actionType = "WRITE_SEND")
		pressEnterStr := "{" scanCode_Enter "}"
	SendInput,% openChatStr . clearChatStr . pasteMsgStr . pressLeftStr . pressEnterStr
	Sleep 100 ; Giving time to process Ctrl+V - If clipboard were to be changed too soon, it would be reflected on our Ctrl+V. Strange stuff
	SetTitleMatchMode(prevTitleMatchMode) 
	Return

	Send_GameMessage_GetClearChatStr:
		if !IsIn(firstChar, "/,%,&,#,@") ; Not a command. We send / then remove it to make sure chat is empty
			clearChatStr := "{Space}/{BackSpace}"
	Return

	Send_GameMessage_GetOpenChatStr:
		if IsIn(chatVK, "0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F") { ; Mouse buttons
			keyName := chatVK="0x1"?"L" : chatVk="0x2"?"R" : chatVK="0x4"?"M" ; Left,Right,Middle
				: chatVK="0x5"?"X1" : chatVK="0x6"?"X2" ; XButton1,XButton2
				: chatVK="0x9C"?"WL" : chatVK="0x9D"?"WR" ; WheelLeft,WheelRight
				: chatVK="0x9E"?"WD" : chatVK="0x9F"?"WU" ; WheelDown,WheelUp
				: ""
			
			if WinExist("[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " gamePID)
				winRegex := "[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " gamePID
			else {
				WinGet, activeWinHandle, ID, A
				winRegex := "[a-zA-Z0-9_] ahk_group POEGameGroup ahk_id " activeWinHandle
			}

			keyDelay := SetKeyDelay(10, 10), prevTitleMatchMode_oc := SetTitleMatchMode("RegEx"), ctrlDelay := SetControlDelay(-1)
			if !WinActive(winRegex) {
				WinActivate,%winRegex%
				WinWaitActive,%winRegex%, , 3
			}
			ControlClick, ,%winRegex%, ,%keyName%, 1, NA
			/* Old way that seemed to be a bit buggy for some reason after creating the Settings GUI.
			Sending the hotkey before the Settings GUI was created would make things work correctly.
			But sending it after would effectively send the chat key, but not keep the chat window activated.
			Probably related to some internal ahk variable or something. Doesn't matter, ControlClick is more reliable.
			
			ControlSend, ,{VK%chatVK%}, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																								;  Therefore, we need to send the key to the actual game window.
			*/
			SetKeyDelay(keyDelay.1, keyDelay.2), SetTitleMatchMode(prevTitleMatchMode_oc), SetControlDelay(ctrlDelay)
		}
		else
			openChatStr := "{VK" chatVK "}"
	Return
}

Get_RunningInstances() {
	global POEGameArr

	runningInstances := {}
	runningInstances.Count := 0

	matchingHwnd := ""
	hw := DetectHiddenWindows("Off")
	for id, pName in POEGameArr {
		hwndList := Get_Windows_ID(pName, "ahk_exe")
		if (hwndList) {
			matchingHwnd .= hwndList ","
		}
	}
	DetectHiddenWindows(hw)
	StringTrimRight, matchingHwnd, matchingHwnd, 1

	Loop, Parse, matchingHwnd,% ","
	{
		runningInstances[A_Index] := {}
		runningInstances.Count := A_Index

		WinGet, pPID, PID, ahk_id %A_LoopField%
		WinGet, pPath, ProcessPath, ahk_id %A_LoopField%
		SplitPath, pPath, pFile, pFolder

		runningInstances[A_Index]["Hwnd"] := A_LoopField
		runningInstances[A_Index]["Folder"] := pFolder
		runningInstances[A_Index]["File"] := pFile
		runningInstances[A_Index]["PID"] := pPID
	}
	
	return runningInstances
}

Get_GameLogsFile() {
	global PROGRAM, POEGameArr

	runningInstances := Get_RunningInstances()
	Loop % runningInstances.Count {
		thisInstanceFolder := runningInstances[A_Index]["Folder"]
		hasDifferentFolders := (thisInstanceFolder && prevInstanceFolder && thisInstanceFolder != prevInstanceFolder)?(True):(False)
		prevInstanceFolder := thisInstanceFolder
	}
	if (runningInstances.Count = 0)
		Return
	else if (runningInstances.Count > 1 && hasDifferentFolders) {
		instanceInfos := GUI_ChooseInstance.Create(runningInstances, "Folder")
		logsFile := instanceInfos["Folder"] "\logs\Client.txt"
	}
	else {
		logsFile := runningInstances[1]["Folder"] "\logs\Client.txt"
	}
	if !FileExist(logsFile) && (logsFile != "\logs\Client.txt") {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.GameLogsFileNotFound_Msg, "%file%", logsFile)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.GameLogsFileNotFound_Title, trayMsg)
		Return
	}

	Return logsFile
}

Monitor_GameLogs() {
	global PROGRAM, POEGameArr, RUNTIME_PARAMETERS
	static gameLogsFileNames := ["Client.txt","KakaoClient.txt"]
	static lastCheckTime, prevTimer
	static allLogsObj, gameFoldersObj
	if !(lastCheckTime)
		lastCheckTime := 1994010101010101
	if !IsObject(gameFoldersObj)
		gameFoldersObj := []
	if !IsObject(allLogsObj)
		allLogsObj := {}

	; Retrieve new folders if it has been more than 5 mins
	minsSinceLast := A_Now
	minsSinceLast -= lastCheckTime, Minutes
	if (minsSinceLast >= 5 || !gameFoldersObj.Count()) {
		GoSub Monitor_GameLogs_GetFolders
	}

	; Parse all logs file
	Loop % allLogsObj.Count() {
		allLogsObjIndex := A_Index
		Loop % allLogsObj[allLogsObjIndex].Count() {
			allLogsObjSubIndex := A_Index
			tempFileObj := FileOpen(allLogsObj[allLogsObjIndex][allLogsObjSubIndex].FilePath, "r", "UTF-8")
			tempFileObj.Pos := allLogsObj[allLogsObjIndex][allLogsObjSubIndex].Pos
			newFileContent := tempFileObj.Read(), allLogsObj[allLogsObjIndex][allLogsObjSubIndex].Pos := tempFileObj.Pos
			if (newFileContent) {
				Loop, Parse,% newFileContent,`n,`r
				{
					if !(A_LoopField)
						Continue
					Parse_GameLogs(A_LoopField)
				}
			}
			tempFileObj.Close(), tempFileObj := ""
		}
	}
	return

	Monitor_GameLogs_GetFolders:
		foldersObjCount := gameFoldersObj.Count()

		; Add instance folders to gameFoldersObj
		if (RUNTIME_PARAMETERS.GameFolder) { ; Detected GameFolder parameter, use that folder only
			lastCheckTime := 2050010101010101 ; So that it never checks again
			gameFoldersObj[foldersObjCount+1] := RUNTIME_PARAMETERS.GameFolder
		}
		else { ; No param detected, loop all running instances
			lastCheckTime := A_Now, gameInstances := Get_RunningInstances() 
			Loop % gameInstances.Count { ; Going through folders of all running instances
				gameInstances_loopIndex := A_Index, gameInstances_loopFolder := gameInstances[gameInstances_loopIndex].Folder
				Loop % loopEndIndex := foldersObjCount ? foldersObjCount : 1 { ; Make sure to loop at least once
					gameFolders_loopIndex := A_Index, gameFolders_loopFolder := gameFoldersObj[gameFolders_loopIndex]
					if (gameInstances_loopFolder = gameFolders_loopFolder) ; Already has the folder, skip to next
						break
					else if (gameFolders_loopIndex = loopEndIndex) ; Reached end of loop and no match, add to obj
						gameFoldersObj.Push(gameInstances_loopFolder)
				}
			}
		}

		newFoldersObjCount := gameFoldersObj.Count()
		if (newFoldersObjCount > foldersObjCount) {
			; Add logs file to allLogsObj
			loopIndex := foldersObjCount+1
			Loop % newFoldersObjCount-foldersObjCount { ; Only newly added matches
				loopedLogsFolder := gameFoldersObj[loopIndex]
				allLogsObjNextIndex := allLogsObj.Count()+1
				Loop % gameLogsFileNames.Count() { ; For every logs file name we know
					loopedLogFileName := gameLogsFileNames[A_Index], loopedLogsFullPath := loopedLogsFolder "\logs\" loopedLogFileName
					if FileExist(loopedLogsFullPath) { ; Make a sub array for this logs file in this folder
						if !IsObject(allLogsObj[allLogsObjNextIndex])
							allLogsObj[allLogsObjNextIndex] := {}
						thisSubObjCount := allLogsObj[allLogsObjNextIndex].Count()
						allLogsObj[allLogsObjNextIndex][thisSubObjCount+1] := {}
						allLogsObj[allLogsObjNextIndex][thisSubObjCount+1].FilePath := loopedLogsFullPath
						tempFileObj := FileOpen(loopedLogsFullPath, "r", "UTF-8"), tempFileObj.Read()
						allLogsObj[allLogsObjNextIndex][thisSubObjCount+1].Pos := tempFileObj.Pos
						tempFileObj.Close(), tempFileObj := ""
						AppendToLogs("Monitoring logs file: """ loopedLogsFullPath """.")
					}
				}
				loopIndex++
			}

			; Show a notification about folders being monitored
			Loop % newFoldersObjCount {
				gameFoldersStr .= "`n" """" gameFoldersObj[A_Index] """"
			}
			if ( SubStr(gameFoldersStr, 1, 2) = "`n" )
				StringTrimLeft, gameFoldersStr, gameFoldersStr, 2

			if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock" && !foldersObjCount) ; Cycle dock mode if its the first time
				GUI_Trades_V2.DockMode_Cycle()

			trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MonitoringGameLogsFileSuccess_Msg, "%file%", gameFoldersStr)
			TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.MonitoringGameLogsFileSuccess_Title, trayMsg)
		}

		; Deciding on timer based on if game is running or not
		processExists := False
		Loop,% POEGameArr.Count() {
			Process, Exist,% POEGameArr[A_Index]
			if (ErrorLevel) {
				processExists := True
				Break
			}
		}
		timer := processExists?500:5000
		if (timer != prevTimer) || (!prevTimer) {
			try SetTimer,% A_ThisFunc, Delete
			SetTimer,% A_ThisFunc,% timer
		}
		prevTimer := timer
	return
}

Parse_GameLogs(strToParse, preview=False) {
	global PROGRAM, GuiTrades, GAME
	static logPrefix := "^(?:[^ ]+ ){6}(\d+)\]"
	static fromVariants, toVariants, tradingWhisperRegexes
	if !(fromVariants)
		for lang, variant in PROGRAM.DATA.TRADING_REGEXES.From
			fromVariants .= fromVariants ? "|" variant : variant
	if !(toVariants)
		for lang, variant in PROGRAM.DATA.TRADING_REGEXES.To
			toVariants .= toVariants ? "|" variant : variant
	if !(tradingWhisperRegexes) {
		tradingWhisperRegexes := {}
		for regexName in PROGRAM.DATA.TRADING_REGEXES
			if (PROGRAM.DATA.TRADING_REGEXES[regexName].Regular) {
				tradingWhisperRegexes[regexName] := ObjFullyClone(PROGRAM.DATA.TRADING_REGEXES[regexName])
			}
	}

	Loop, Parse,% strToParse,`n,`r ; For each line
	{
		parsedLogsMsg := A_LoopField

		; Check if entered zone
		for lang, regexStr in PROGRAM.DATA.TRADING_REGEXES.ZoneEntered {
			if RegExMatch(parsedLogsMsg, "SO)" logPrefix " : " regexStr, zonePat) {
				instancePID := zonePat.1, zone := zonePat.2
				if !IsObject(GAME[instancePID])
					GAME[instancePID] := {}
				GAME[instancePID].PlayerZone := zone
				break
			}
		}
		
		; Check if area joined
		for lang, regexStr in PROGRAM.DATA.TRADING_REGEXES.JoinedArea {
			if RegExMatch(parsedLogsMsg, "SO)" logPrefix " : " regexStr, joinedPat) {
				instancePID := joinedPat.1, playerName := joinedPat.2
				success := GUI_Trades_V2.SetTabStyleJoinedArea(playerName)
				if (success && PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXToggle = "True" && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath)) {
					try
						SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath
					catch
						PlaySound(PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath)
				}
				break
			}
		}
		for lang, regexStr in PROGRAM.DATA.TRADING_REGEXES.LeftArea {
			if RegExMatch(parsedLogsMsg, "SO)" logPrefix " : " regexStr, leftPat) {
				instancePID := leftPat.1, playerName := leftPat.2
				GUI_Trades_V2.UnSetTabStyleJoinedArea(playerName)
				break
			}
		}

		; Check if afk mode
		for lang, regexStr in PROGRAM.DATA.TRADING_REGEXES.AfkOn {
			if RegExMatch(parsedLogsMsg, "iSO)" logPrefix . regexStr, afkOnPat) {
				instancePID := afkOnPat.1
				GuiTrades.Sell[instancePID "_AfkState"] := True
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to ON.")
				break
			}
		}
		for lang, regexStr in PROGRAM.DATA.TRADING_REGEXES.AfkOn {
			if RegExMatch(parsedLogsMsg, "iSO)" logPrefix . regexStr, afkOffPat) {
				instancePID := afkOffPat.1
				GuiTrades.Sell[instancePID "_AfkState"] := False
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to OFF.")
				break
			}
		}

		; Check if whisper sent
		isWhisperSent := isWhisper := isWhisperReceived := False
		if RegExMatch(parsedLogsMsg, "SO)" logPrefix " (?=[^#$&%]).*@(?:" toVariants ") (.*?): (.*)", whisperPat) {
			isWhisperSent := True, isWhisper := True
			instancePID := whisperPat.1, whispNameFull := whisperPat.2, whispMsg := whisperPat.3
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Sent_Name := whispName
		}
		; Check if whisper received
		else if RegExMatch(parsedLogsMsg, "SOi)" logPrefix " (?=[^#$&%]).*@(?:" fromVariants ") (.*?): (.*)", whisperPat) {
			isWhisperReceived := True, isWhisper := True
			instancePID := whisperPat.1, whispNameFull := whisperPat.2, whispMsg := whisperPat.3
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Name := whispName
		}

		; Retrieve the regEx pattern specific to the whisper type
		if (isWhisper=True) {
			matchingRegEx := ""
			for regexName in tradingWhisperRegexes {
				for subRegexName in tradingWhisperRegexes[regexName] {
					if IsIn(subRegexName, "GemQuality,StashLocation")
						Continue

					if RegExMatch(whispMsg, "SO)" tradingWhisperRegexes[regexName][subRegexName].String, matchObj) { ; Match found
						matchingRegEx := ObjFullyClone(tradingWhisperRegexes[regexName][subRegexName])
						matchingRegex.Name := regexName, matchingRegex.SubName := subRegexName
						qualityRegEx := ObjFullyClone(tradingWhisperRegexes[regexName].GemQuality)
						stashRegEx := ObjFullyClone(tradingWhisperRegexes[regexName].StashLocation)
						Break
					}
				}
				if (matchingRegEx)
					break
			}
		}

		if IsIn(matchingRegex.SubName, "Regular,Currency,RegularUnpriced") { ; Trade whisper match
			whisperLang := RegExMatch(matchingRegex.Name, "_(\D+)$").1

			tradeBuyerName := whispName, tradeBuyerGuild := whispGuild
			tradeOtherStart := matchObj[matchingRegEx.Other]
			tradeItem := matchObj[matchingRegEx.Item], tradeItem .= matchObj[matchingRegEx.Item2] ? " " matchObj[matchingRegEx.Item2] : "", AutoTrimStr(tradeItem)
			tradePrice := matchObj[matchingRegEx.Price]
			tradeLeagueAndMore := matchObj[matchingRegEx.League]
			tradeLeagueAndMore .= matchObj[matchingRegEx.Other2]

			; German priced whisper is the same as currency whisper. Except that currency whisper has '' between price name
			; while the normal whisper doesn't have them. Fix: Remove '' in price if detected
			if (whisperLang = "GER") && ( SubStr(tradePrice, 1, 1) = "'" ) && ( SubStr(tradePrice, 0, 1) = "'") {
				StringTrimLeft, tradePrice, tradePrice, 1
				StringTrimRight, tradePrice, tradePrice, 1
			}

			AutoTrimStr(tradeBuyerName, tradeItem, tradePrice, tradeOtherStart)

			for index, league in GAME.LEAGUES {			
				league := StrReplace(league, "(", "\(")
				league := StrReplace(league, ")", "\)")
				if RegExMatch(tradeLeagueAndMore, "iSO)" league "(.*)", leagueAndMorePat) {
					leagueMatchesIndex++
					tradeLeague := league
					restOfWhisper := leagueAndMorePat.1
					AutoTrimStr(tradeLeague, restOfWhisper)

					leagueMatches[leagueMatchesIndex] := {Len:StrLen(league), Str:league}
				}
			}
			Loop % leagueMatches.MaxIndex() {
				if (leagueMatches[A_Index].Len > biggestLen) {
					biggestLen := leagueMatches[A_Index].Len, tradeLeague := leagueMatches[A_Index].Str
				}
			}

			if (!tradeLeague)
				restOfWhisper := tradeLeagueAndMore

			if RegExMatch(tradeItem, "iSO)" qualityRegEx.String, qualPat) && (qualityRegEx.String) {
				tradeItem := qualPat[qualityRegEx.Item]
				tradeItemLevel := qualPat[qualityRegEx.Level]
				tradeItemQual := qualPat[qualityRegEx.Quality]
				AutoTrimStr(tradeItem, tradeItemLevel, tradeItemQual)

				tradeItemFull := tradeItem " (Lvl:" tradeItemLevel " / Qual:" tradeItemQual "%)"
			}
			else {
				tradeItemFull := tradeItem
				AutoTrimStr(tradeItemFull)
			}
			if RegExMatch(restOfWhisper, "iSO)" stashRegEx.String, stashPat) && (stashRegEx.String) {
				tradeStashTab := stashPat[stashRegEx.Tab]
				tradeStashLeft := stashPat[stashRegEx.Left]
				tradeStashTop := stashPat[stashRegEx.Top]
				tradeOtherEnd := stashPat[stashRegEx.Other]
				AutoTrimStr(tradeStashTab, tradeStashLeft, tradeStashTop, tradeOtherEnd)

				tradeStashLeftAndTop := tradeStashLeft ";" tradeStashTop
			}
			else {
				tradeOtherEnd := restOfWhisper
				AutoTrimStr(tradeOtherEnd)
			}

			if ( SubStr(tradeOtherEnd, 1, 1) = "." ) ; Remove dot from end at some whispers
				StringTrimLeft, tradeOtherEnd, tradeOtherEnd, 1
			tradeOther := (tradeOtherStart && tradeOtherEnd)?(tradeOtherStart "`n" tradeOtherEnd)
			: (tradeOtherStart && !tradeOtherEnd)?(tradeOtherStart)
			: (tradeOtherEnd && !tradeOtherStart)?(tradeOtherEnd)
			: ("")

			tradeStashFull := (tradeLeague && !tradeStashTab)?(tradeLeague)
			: (tradeLeague && tradeStashTab)?(tradeLeague " (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
			: (!tradeLeague && tradeStashTab) ? ("??? (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
			: (!tradeLeague) ? ("???")
			: ("")

			tradeLocation := (tradeLeague && !tradeStashTab)?(tradeLeague)
			: (tradeLeague && tradeStashTab)?(tradeLeague " (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
			: (!tradeLeague && tradeStashTab) ? ("??? (Tab:" tradeStashTab " / Pos:" tradeStashLeftAndTop ")")
			: (!tradeLeague) ? ("???")
			: ("")

			if (isWhisperReceived=True || isWhisperSent=True) {
				RegExMatch(tradePrice, "O)(\d+.\d+|\d+) (.*)", tradePricePat), priceCurrencyCount := tradePricePat.1, priceCurrencyName := tradePricePat.2
				priceCurrencyFullName := Get_CurrencyFullName(priceCurrencyName, whisperLang), priceCurrencyName := priceCurrencyFullName ? priceCurrencyFullName : priceCurrencyName
				RegExMatch(tradeItem, "O)(\d+.\d+|\d+) (.*)", tradeItemPat), itemCurrencyCount := tradeItemPat.1, itemCurrencyName := tradeItemPat.2
				itemCurrencyFullName := Get_CurrencyFullName(itemCurrencyName, whisperLang), itemCurrencyName := itemCurrencyFullName ? itemCurrencyFullName : itemCurrencyName
			}

			if (isWhisperReceived=True)	{	
				tradeOther := tradeOther?"[" A_Hour ":" A_Min "] @From: " tradeOther : ""

				tradeInfos := {Buyer:tradeBuyerName, Item:tradeItem, Price:tradePrice, AdditionalMessageFull:tradeOther
				,ItemCurrency:itemCurrencyName, ItemCount:itemCurrencyCount
				,PriceCurrency:priceCurrencyName, PriceCount:priceCurrencyCount
				,League:tradeLeague, StashTab:tradeStashTab, StashX:tradeStashLeft, StashY:tradeStashTop
				,Guild:tradeBuyerGuild
				,GemLevel:tradeItemLevel, GemQuality:tradeItemQual
				,TimeReceived:A_Hour ":" A_Min, TimeStamp:A_YYYY A_MM A_DD A_Hour A_Min A_Sec
				,WhisperMsg:whispMsg, WhisperRegEx:matchingRegex.Name, WhisperLanguage:whisperLang
				,GamePID:instancePID
				,UniqueID:GUI_Trades_V2.GenerateUniqueID()}
				
				guiName := preview=False?"Sell":"SellPreview"
				err := GUI_Trades_V2.PushNewTab(guiName, tradeInfos)

				if !(err) && (preview=False) {
					if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXPath) {
						try 
							SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXPath
						catch
							PlaySound(PROGRAM.SETTINGS.SETTINGS_MAIN.TradingWhisperSFXPath)
					}
						
					if !WinActive("ahk_pid " instancePID) { ; If the instance is not active
						if ( PROGRAM.SETTINGS.SETTINGS_MAIN.ShowTabbedTrayNotificationOnWhisper = "True" ) {
							trayTitle := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.TradingWhisperReceived_Title, "%buyer%", whispName)
							trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.TradingWhisperReceived_Msg, "%item%", A_Tab tradeItemFull)
							trayMsg := StrReplace(trayMsg, "%price%", A_Tab tradePrice)
							trayMsg := StrReplace(trayMsg, "%stash%", A_Tab tradeStashFull)
							trayMsg := StrReplace(trayMsg, "%other%", A_Tab tradeOther)
							TrayNotifications.Show(trayTitle, trayMsg)
						}
					}

					pbNoteOnTradingWhisper := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnTradingWhisper
					if (pbNoteOnTradingWhisper = "True") {
						if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades.Sell[instancePID "_AfkState"] = True)
							doPBNote := True
						else if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "False")
							doPBNote := True
					}

					if (doPBNote = True) && StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) > 5 {
						cmdLineParamsObj := {}
						cmdLineParamsObj.PB_Token := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken
						cmdLineParamsObj.PB_Title := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.TradingWhisperReceived_Title, "%buyer%", whispName)

						pbTxt := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.TradingWhisperReceived_Msg, "%item%", A_Tab tradeItemFull)
						pbTxt := StrReplace(pbTxt, "%price%", A_Tab tradePrice)
						pbTxt := StrReplace(pbTxt, "%stash%", A_Tab tradeStashFull)
						pbTxt := StrReplace(pbTxt, "%other%", A_Tab tradeOther)
						pbTxt := StrReplace(pbTxt, "`n", "\n"), pbTxt := StrReplace(pbTxt, "`r", "\r"), pbTxt := StrReplace(pbTxt, "`t", "\t"), pbTxt := StrReplace(pbTxt, A_Tab, "\t")

						cmdLineParamsObj.PB_Message := pbTxt
						
						GoSub, Parse_GameLogs_PushBulletNotifications_SA
					}
				}
			}
			else if (isWhisperSent=True) {	
				tradeOther := tradeOther?"[" A_Hour ":" A_Min "] @To: " tradeOther : ""
				
				tradeInfos := {Seller:tradeBuyerName, Item:tradeItem, Price:tradePrice, AdditionalMessageFull:tradeOther
				,ItemCurrency:itemCurrencyName, ItemCount:itemCurrencyCount
				,PriceCurrency:priceCurrencyName, PriceCount:priceCurrencyCount
				,League:tradeLeague, StashTab:tradeStashTab, StashX:tradeStashLeft, StashY:tradeStashTop
				,Guild:tradeBuyerGuild
				,GemLevel:tradeItemLevel, GemQuality:tradeItemQual
				,TimeSent:A_Hour ":" A_Min, TimeStamp:A_YYYY A_MM A_DD A_Hour A_Min A_Sec
				,WhisperMsg:whispMsg, WhisperRegEx:matchingRegex.Name, WhisperLanguage:whisperLang
				,GamePID:instancePID
				,UniqueID:GUI_Trades_V2.GenerateUniqueID()}
				
				guiName := preview=False?"Buy":"BuyPreview"
				err := GUI_Trades_V2.PushNewTab(guiName, tradeInfos)
			}
		}
		else if (parsedLogsMsg && !matchingRegEx && isWhisper=True) { ; No trading whisper match
			; Add whisper to buyer's tab if existing
			if (isWhisperReceived) {
				Loop % GuiTrades.Sell.Tabs_Count {
					tabInfos := GUI_Trades_V2.GetTabContent("Sell", A_Index)
					if (tabInfos.Buyer = whispName) {
						GUI_Trades_V2.UpdateSlotContent("Sell", A_Index, "AdditionalMessageFull", "[" A_Hour ":" A_Min "] @From: " whispMsg)
						GUI_Trades_V2.SetTabStyleWhisperReceived(whispName)
					}
				}
				Loop % GuiTrades.Buy.Tabs_Count {
					tabInfos := GUI_Trades_V2.GetSlotContent("Buy", A_Index)
					if (tabInfos.Seller = whispName) {
						GUI_Trades_V2.UpdateSlotContent("Buy", A_Index, "AdditionalMessageFull", "[" A_Hour ":" A_Min "] @From: " whispMsg)
					}
				}
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXPath) {
					try 
						SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXPath
					catch
						PlaySound(PROGRAM.SETTINGS.SETTINGS_MAIN.RegularWhisperSFXPath)
				}

				if !WinActive("ahk_pid " instancePID) { ; If the instance is not active
					if ( PROGRAM.SETTINGS.SETTINGS_MAIN.ShowTabbedTrayNotificationOnWhisper = "True" ) {
						trayTitle := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.RegularWhisperReceived_Title, "%name%", whispName)
						TrayNotifications.Show(trayTitle, whispMsg)
					}
				}

				pbNoteOnRegularWhisper := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnWhisperMessage
				if (pbNoteOnRegularWhisper = "True") {
					if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades.Sell[instancePID "_AfkState"] = True)
						doPBNote := True
					else if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "False")
						doPBNote := True
				}

				if (doPBNote = True) && StrLen(PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken) > 5 {
					cmdLineParamsObj := {}
					cmdLineParamsObj.PB_Token := PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken
					cmdLineParamsObj.PB_Title := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.RegularWhisperReceived_Title, "%name%", whispName)
					
					pbTxt := whispMsg
					pbTxt := StrReplace(pbTxt, "`n", "\n"), pbTxt := StrReplace(pbTxt, "`r", "\r"), pbTxt := StrReplace(pbTxt, "`t", "\t"), pbTxt := StrReplace(pbTxt, A_Tab, "\t")
					cmdLineParamsObj.PB_Message := pbTxt
					
					GoSub, Parse_GameLogs_PushBulletNotifications_SA
				}
			}
			else if (isWhisperSent) {
				Loop % GuiTrades.Buy.Tabs_Count {
					tabInfos := GUI_Trades_V2.GetSlotContent("Buy", A_Index)
					if (tabInfos.Seller = whispName) {
						GUI_Trades_V2.UpdateSlotContent("Buy", A_Index, "AdditionalMessageFull", "[" A_Hour ":" A_Min "] @To: " whispMsg)
					}
				}
				Loop % GuiTrades.Sell.Tabs_Count {
					tabInfos := GUI_Trades_V2.GetTabContent("Sell", A_Index)
					if (tabInfos.Buyer = whispName) {
						GUI_Trades_V2.UpdateSlotContent("Sell", A_Index, "AdditionalMessageFull", "[" A_Hour ":" A_Min "] @To: " whispMsg)
					}
				}
			}
		}
	}
	return

	Parse_GameLogs_PushBulletNotifications_SA:
		global PROGRAM, GuiIntercom, GuiIntercom_Controls

		intercomSlotNum := GUI_Intercom.GetNextAvailableSlot()
		intercomSlotHandle := GUI_Intercom.GetSlotHandle(intercomSlotNum)
		GUI_Intercom.ReserveSlot(intercomSlot)

		cmdLineParams := ""
		for key, value in cmdLineParamsObj
			cmdLineParams .= " /" key "=" """" value """"

		cl := DllCall( "GetCommandLine", "str" )
		StringMid, path_AHk, cl, 2, InStr( cl, """", true, 2 )-2

		saFile := A_ScriptDir "\lib\SA_PushBulletNotifications.ahk"
		saFile_run_cmd := % """" path_AHk """" A_Space """" saFile """"
		.		" " cmdLineParams
		.		" /IntercomHandle=" """" GuiIntercom.Handle """"
		.		" /IntercomSlotHandle=" """" intercomSlotHandle """"
		.		" /ProgramLogsFile=" """" PROGRAM.LOGS_FILE """"
		
		Run,% saFile_run_cmd,% A_ScriptDir
	return
}

SplitNameAndGuild(str) {
	if RegExMatch(str, "O)<(.*)>(.*)", guildPat) {
		guild := guildPat.1
		name := guildPat.2

		_autoTrim := A_AutoTrim
		AutoTrim, On
		name = %name%
		guild = %guild%
		AutoTrim, %_autoTrim%

		Return {Guild:guild,Name:name}
	}
	else
		Return {Guild:"",Name:str}
}

IsTradingWhisper(str) {
	global PROGRAM
	static tradingWhisperRegexes
	
	; Make sure it starts with @ and doesnt contain line break
	firstChar := SubStr(str, 1, 1)
	if InStr(str, "`n") || (firstChar != "@")  {
		Return False
	}

	if !(tradingWhisperRegexes) {
		tradingWhisperRegexes := {}
		for regexName in PROGRAM.DATA.TRADING_REGEXES
			if (PROGRAM.DATA.TRADING_REGEXES[regexName].Regular) {
				tradingWhisperRegexes[regexName] := ObjFullyClone(PROGRAM.DATA.TRADING_REGEXES[regexName])
			}
	}

	for regexName in tradingWhisperRegexes {
		for subRegexName in tradingWhisperRegexes[regexName] {
			if IsIn(subRegexName, "GemQuality,StashLocation")
				Continue
			
			if RegExMatch(str, "S)" tradingWhisperRegexes[regexName][subRegexName].String)
				return True
		}
	}
}

Is_Tool_Elevation_SameLevel_As_GameInstance(gamePID) {
	if (A_IsAdmin)
		return True

	if Is_Game_Elevated(gamePID)
		return False

	return True
}

Is_Game_Elevated(gamePID) {
	
	WinGet, pName, ProcessName, ahk_pid %gamePID%
	processInfos := Get_ProcessInfos(pName, gamePID)
	isProcessElevated := (processInfos[1]["TokenIsElevated"])?(True):(processInfos=2)?(True):(False)

	return isProcessElevated
}

Get_CurrencyEnglishName(currencyName, lang) {
	global PROGRAM
	if (lang="ENG")
		return currencyName

	Loop 2 {
		loopLang := A_Index=1 ? lang : "ENG"
		poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" loopLang "_poeDotComStaticData.json")
		Loop % poeStaticData.Count() {
			loop1Index := A_Index
			Loop % poeStaticData[loop1Index].entries.Count() {
				thisEntry := poeStaticData[loop1Index].entries[A_Index]				
				if (loopLang=lang && thisEntry.text = currencyName) {
					matchID := thisEntry.id
					break
				}
				else if (loopLang="ENG" && thisEntry.id = matchID)
					return thisEntry.text
			}
			if (matchID)
				break
		}
	}
}

Get_CurrencyFullName(currencyName, lang="ENG", lastResort=True) {
	global PROGRAM
	; Checking if currency isn't already full name
	if IsIn(currencyName, PROGRAM.DATA.CURRENCY_LIST)
		return currencyName
	; Checking in poetrade currency data
	if (PROGRAM.DATA.POETRADE_CURRENCY_DATA[currencyName])	
		return PROGRAM.DATA.POETRADE_CURRENCY_DATA[currencyName]
	; Checking for poeapp.com, which sometimes add 's' as plural
	lastChar := SubStr(currencyName, 0, 1)
	if (lastChar = "s") {
		currencyNameTemp := StrTrimRight(currencyName, 1)
		if ( currencyNameTemp := Get_CurrencyFullName(currencyNameTemp,lang) )
			return currencyNameTemp
	}
	else if RegExMatch(currencyName, "iO) Map$", matchObj) {
		currencyNameTemp := StrTrimRight(currencyName, StrLen(matchObj.0))
		if ( currencyNameTemp := Get_CurrencyFullName(currencyNameTemp,lang) )
			return currencyNameTemp
	}

	; Checking in poedotcom currency data
	langs := lang ? [lang,"ENG"] : ["ENG"]
	Loop % langs.Count() {
		lang := langs[A_Index]
		poeStaticData := JSON_Load(PROGRAM.DATA_FOLDER "\" lang "_poeDotComStaticData.json")
		Loop % poeStaticData.Count() {
			loop1Index := A_Index
			Loop % poeStaticData[loop1Index].entries.Count() {
				thisEntry := poeStaticData[loop1Index].entries[A_Index]				
				if (thisEntry.id = currencyName)
					return thisEntry.text
				else if (thisEntry.text = currencyName)
					return thisEntry.text
			}
		}
	}

	if (lastResort=True) {
		Loop, Parse, currencyName,% A_Space
		{
			str := str ? str " " A_LoopField : A_LoopField
			currencyNameTemp := Get_CurrencyFullName(str, lang, lastResort=False)
			if (currencyNameTemp)
				return currencyNameTemp
		}
	}

	return ""
}