Get_TradingLeagues(forceScriptLeagues=False) {
/*		Retrieves leagues from the API
		Parse them, to keep only non-solo or non-ssf leagues
		Return the resulting list
*/
	global PROGRAM, GAME, LEAGUES

	challengeLeagues := GAME.CHALLENGE_LEAGUE
	Loop, Parse, challengeLeagues,% ","
		scriptLeagues := scriptLeagues ? scriptLeagues "," A_LoopField ",Hardcore " A_LoopField : A_LoopField ",Hardcore " A_LoopField
	scriptLeagues := scriptLeagues ? scriptLeagues ",Standard,Hardcore" : "Standard,Hardcore"

	if (forceScriptLeagues = True) {
		LEAGUES := scriptLeagues
		return scriptLeagues
	}

	; HTTP Request
	url := "http://api.pathofexile.com/leagues?type=main"	
	headers :=	"Host: api.pathofexile.com"
	. "`n" 		"Connection: keep-alive"
	. "`n" 		"Cache-Control: max-age=0"
	. "`n" 		"Content-type: application/x-www-form-urlencoded; charset=UTF-8"
	. "`n" 		"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
	. "`n" 		"User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36"
	options := "TimeOut: 25"
	
	WinHttpRequest(url, data:="", headers, options), leaguesJSON := data

	; Parse league names
	apiLeagues		:= ""
	try parsedLeaguesJSON := JSON.Load(leaguesJSON)
	Loop % parsedLeaguesJSON.MaxIndex() {
		arrID 		:= parsedLeaguesJSON[A_Index]
		leagueName 	:= arrID.ID
		if !IsIn(leagueName, apiLeagues) {
 			apiLeagues .= leagueName ","
		}
	}
	StringTrimRight, apiLeagues, apiLeagues, 1
	apiLeagues := IsContaining(apiLeagues, "Standard")?apiLeagues:""

	; Parse trading leagues only
	excludedWords 		:= "SSF,Solo"
	apiTradingLeagues 		:= ""
	Loop, Parse, apiLeagues,% ","
	{
		if !IsContaining(A_LoopField, excludedWords)
			apiTradingLeagues .= A_LoopField ","
	}
	StringTrimRight, apiTradingLeagues, apiTradingLeagues, 1

	; In case leagues api is down, get from my own list on github
	if !(apiTradingLeagues) {
		url := "http://raw.githubusercontent.com/" PROGRAM.GITHUB_USER "/" PROGRAM.GITHUB_REPO "/master/data/TradingLeagues.txt"

		options := "TimeOut: 25"
		WinHttpRequest(url, data:="", headers:="", options), rawFile := data

		if IsContaining(rawFile, "Error,404") {
			AppendToLogs(A_ThisFunc "(forceScriptLeagues=" forceScriptLeagues "): Failed to get leagues from GitHub file."
			. "`nrawFile: """ rawFile """")
			rawFile := ""
		}
		gitLeagues := ""		
		Loop, Parse, rawFile,% "`n",% "`r"
			if (A_LoopField)
				gitLeagues .= A_LoopField ","
		StringTrimRight, gitLeagues, gitLeagues, 1
		AppendToLogs("Leagues API: Couldn't retrieve leagues from Leagues API. Retrieving list from GitHub repo: " gitLeagues)
	}

	; Set LEAGUES var content
	tradingLeagues := apiTradingLeagues?apiTradingLeagues : gitLeagues?gitLeagues : scriptLeagues
	Loop, Parse, scriptLeagues,% ","
	{
		loopedLeague := A_LoopField
		if !IsIn(loopedLeague, tradingLeagues)
			tradingLeagues := tradingLeagues ? tradingLeagues "," loopedLeague : loopedLeague
	}
	LEAGUES := tradingLeagues

	AppendToLogs("Leagues API: Retrieved leagues: " tradingLeagues)

	return tradingLeagues
}

Send_GameMessage(actionType, msgString, gamePID="") {
	global PROGRAM, GAME
	global MyDocuments
	scanCode_v := PROGRAM.SCANCODES.v, scanCode_Enter := PROGRAM.SCANCODES.Enter

	Thread, NoTimers

	sendMsgMode := PROGRAM.SETTINGS.SETTINGS_MAIN.SendMsgMode

;	Retrieve the virtual key id for chat opening
	chatVK := GAME.SETTINGS.ChatKey_VK ? GAME.SETTINGS.ChatKey_VK : "0xD"

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx ; RegEx = Fix some case where specifying only the pid does not work

	firstChar := SubStr(msgString, 1, 1) ; Get first char, to compare if its a special chat command

	if (gamePID) {
		WinActivate,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%, ,2
		isToolSameElevation := Is_Tool_Elevation_SameLevel_As_GameInstance(gamePID)
	}
	else {
		WinActivate,[a-zA-Z0-9_] ahk_group POEGameGroup
		WinWaitActive,[a-zA-Z0-9_] ahk_group POEGameGroup, ,2
		WinGet, gamePID, PID, A
		isToolSameElevation := Is_Tool_Elevation_SameLevel_As_GameInstance(gamePID)
	}
	if (ErrorLevel) {
		AppendToLogs(A_ThisFunc "(actionType=" actionType ", msgString=" msgString ", gamePID=" gamePID "): WinWaitActive timed out.")
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.GameWindowFocusTimedOut_Title, PROGRAM.TRANSLATIONS.TrayNotifications.GameWindowFocusTimedOut_Msg)
		return "WINWAITACTIVE_TIMEOUT"
	}

	if (!isToolSameElevation) {
		MsgBox(4096+48+4, PROGRAM.NAME " - " PROGRAM.TRANSLATIONS.MessageBoxes.ReloadAsAdmin_Title, PROGRAM.TRANSLATIONS.MessageBoxes.ReloadAsAdmin_Msg)

		IfMsgBox, Yes
		{
			GUI_Trades.SaveBackup()
			ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
		}
		else return
	}

	GoSub, Send_GameMessage_OpenChat
	GoSub, Send_GameMessage_ClearChat

	if (actionType = "WRITE_SEND") {
		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err) {
				SendEvent, {Ctrl Down}{%scanCode_v%}{Ctrl Up}
			}
			else
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Title, PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Msg)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendInput,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%

		SendEvent,{%scanCode_Enter%}
	}
	else if (actionType = "WRITE_DONT_SEND") {
		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err)
				SendEvent, {Ctrl Down}{%scanCode_v%}{Ctrl Up}
			else
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Title, PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Msg)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendEvent,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%
	}
	else if (actionType = "WRITE_GO_BACK") {
		foundPos := InStr(msgString, "{X}"), _strLen := StrLen(msgString), leftPresses := _strLen-foundPos+1-3
		msgString := StrReplace(msgString, "{X}", "")

		if (sendMsgMode = "Clipboard") {
			While (Clipboard != msgString) {
				Set_Clipboard(msgString)

				if (Clipboard = msgString)
					break

				else if (A_Index > 100) {
					err := True
					break
				}
				Sleep 50
			}
			if (!err)
				SendEvent, {Ctrl Down}{%scanCode_v%}{Ctrl Up}
			else
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Title, PROGRAM.TRANSLATIONS.TrayNotifications.FailedToSendMessage_Msg)
			; SetTimer, Reset_Clipboard, -700
		}
		else if (sendMsgMode = "SendInput")
			SendInput,%msgString%
		else if (sendMsgMode = "SendEvent")
			SendEvent,%msgString%

		if (!err)
			SendInput {Left %leftPresses%}
	}

	SetTitleMatchMode, %titleMatchMode%
	Return

	Send_GameMessage_ClearChat:
		if !IsIn(firstChar, "/,%,&,#,@") { ; Not a command. We send / then remove it to make sure chat is empty
			SendEvent,{Space}/{BackSpace}
		}
	Return

	Send_GameMessage_OpenChat:
		if IsIn(chatVK, "0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F") { ; Mouse buttons
			keyDelay := A_KeyDelay, keyDuration := A_KeyDuration, titleMatchMode := A_TitleMatchMode, controlDelay := A_ControlDelay
			keyName := chatVK="0x1"?"L" : chatVk="0x2"?"R" : chatVK="0x4"?"M" ; Left,Right,Middle
				: chatVK="0x5"?"X1" : chatVK="0x6"?"X2" ; XButton1,XButton2
				: chatVK="0x9C"?"WL" : chatVK="0x9D"?"WR" ; WheelLeft,WheelRight
				: chatVK="0x9E"?"WD" : chatVK="0x9F"?"WU" ; WheelDown,WheelUp
				: ""
				
			SetKeyDelay, 10, 10
			SetTitleMatchMode, RegEx
			SetControlDelay, -1
			if WinExist("[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " gamePID) {
				if !WinActive("[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " gamePID) {
					WinActivate, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%
					WinWaitActive, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%, , 3
				}
				ControlClick, , [a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID%, ,%keyName%, 1, NA
				/* Old way that seemed to be a bit buggy for some reason after creating the Settings GUI.
				Sending the hotkey before the Settings GUI was created would make things work correctly.
				But sending it after would effectively send the chat key, but not keep the chat window activated.
				Probably related to some internal ahk variable or something. Doesn't matter, ControlClick is more reliable.
				
				ControlSend, ,{VK%chatVK%}, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																								  ;  Therefore, we need to send the key to the actual game window.
				*/
			}
			else {
				WinGet, activeWinHandle, ID, A
				WinActivate, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_id %activeWinHandle%
				WinWaitActive, [a-zA-Z0-9_] ahk_group POEGameGroup ahk_id %activeWinHandle%, , 3
				ControlClick, , [a-zA-Z0-9_] ahk_group POEGameGroup ahk_id %activeWinHandle%, ,%keyName%, 1, NA
			}
			SetKeyDelay,% keyDelay,% keyDuration
			SetTitleMatchMode,% titleMatchMode
			SetControlDelay,% controlDelay
		}
		else
			SendEvent,{VK%chatVK%}
		Sleep 10
	Return
}

Get_RunningInstances() {
	global POEGameArr

	runningInstances := {}
	runningInstances.Count := 0

	for id, pName in POEGameArr {
		hwndList := Get_Windows_ID(pName, "ahk_exe")
		if (hwndList) {
			matchingHwnd .= hwndList ","
		}
	}
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
	if (minsSinceLast >= 5) {
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
				GUI_Trades.DockMode_Cycle()

			trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.MonitoringGameLogsFileSuccess_Msg, "%file%", gameFoldersStr) ; TO_DO change to folder instead of file
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
			; TO_DO_V2 tray notification
		}
		prevTimer := timer
	return
}

Parse_GameLogs(strToParse) {
	global PROGRAM, GuiTrades, LEAGUES, GuiTradesBuyCompact, GAME

	; poe.trade
	static poeTradeRegex 			:= {String:"(.*)Hi, I would like to buy your (.*) listed for (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeTradeUnpricedRegex 	:= {String:"(.*)Hi, I would like to buy your (.*) in (.*)"
										, Other:1, Item:2, League:3}
	static poeTradeCurrencyRegex	:= {String:"(.*)Hi, I'd like to buy your (.*) for my (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeTradeStashRegex 		:= {String:"\(stash tab ""(.*)""; position: left (\d+), top (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static poeTradeQualityRegEx 		:= {String:"level (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}
	; poeapp.com
	static poeAppRegEx 				:= {String:"(.*)wtb (.*) listed for (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeAppUnpricedRegex 		:= {String:"(.*)wtb (.*) in (.*)"
										, Other:1, Item:2, League:3}
	static poeAppCurrencyRegex		:= {String:"(.*)I'd like to buy your (.*) for my (.*) in (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static poeAppStashRegex 		:= {String:"\(stash ""(.*)""; left (\d+), top (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static poeAppQualityRegEx 		:= {String:"(.*) \((\d+)/(\d+)%\)"
										, Item:1, Level:2, Quality:3}
	; pathofexile.com/trade
	; doesn't need ENG str as its same than poe.trade
	static RUS_gggRegEx				:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static RUS_gggUnpricedRegEx		:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) в лиге (.*)"
                                        , Other:1, Item:2, League:3}
	static RUS_gggCurrencyRegEx		:= {String:"(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
                                        , Other:1, Item:2, Price:3, League:4}
	static RUS_gggStashRegEx		:= {String:"\(секция ""(.*)""; позиция: (\d+) столбец, (\d+) ряд\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static RUS_gggQualityRegEx 		 := {String:"уровень (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

	static POR_gggRegEx 			:= {String:"(.*)Olá, eu gostaria de comprar o seu item (.*) listado por (.*) na (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static POR_gggUnpricedRegEx 	:= {String:"(.*)Olá, eu gostaria de comprar o seu item (.*) na (.*)"
											, Other:1, Item:2, League:3}
	static POR_gggCurrencyRegEx 	:= {String:"(.*)Olá, eu gostaria de comprar seu\(s\) (.*) pelo\(s\) meu\(s\) (.*) na (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static POR_gggStashRegEx 		:= {String:"\(aba do baú: ""(.*)""; posição: esquerda (\d+), topo (\d+)\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static POR_gggQualityRegEx 		:= {String:"nível (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

	static THA_gggRegEx				:= {String:"(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน ราคา (.*) ใน (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static THA_gggUnpricedRegEx		:= {String:"(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน (.*)"
										, Other:1, Item:2, League:3}
	static THA_gggCurrencyRegEx		:= {String:"(.*)สวัสดี เรามีความต้องการจะชื้อ (.*) ของคุณ ฉันมี (.*) ใน (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static THA_gggStashRegEx		:= {String:"\(stash tab ""(.*)""; ตำแหน่ง: ซ้าย (\d+), บน (.*)\)(.*)" ; Top position is bugged from GGG side and appears as {{TOP}) for priced items, so we use (.*) instead of (\d+)
										, Tab:1, Left:2, Top:3, Other:4}
	static THA_gggQualityRegEx		:= {String:"level (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

	static GER_gggRegEx 			:= {String:"(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von (.*) in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, Price:3, League:4, Other2:5}
	static GER_gggUnpricedRegEx		:= {String:"(.*)Hi, ich möchte '(.*)' in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, League:3, Other2:4}
	static GER_gggCurrencyRegEx		:= {String:"(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von '(.*)' in der '(.*)'-Liga kaufen(.*)"
										, Other:1, Item:2, Price:3, League:4, Other2:5}
	static GER_gggStashRegEx		:= {String:"\(Truhenfach ""(.*)""; Position: (\d+). von links, (\d+). von oben\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static GER_gggQualityRegEx		:= {String:"Stufe (\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3} 

	static FRE_gggRegEx				:= {String:"(.*)Bonjour, je souhaiterais t'acheter (.*) pour (.*) dans la ligue (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static FRE_gggUnpricedRegEx		:= {String:"(.*)Bonjour, je souhaiterais t'acheter (.*) dans la ligue (.*)"
										, Other:1, Item:2, League:3}
	static FRE_gggCurrencyRegEx		:= {String:"(.*)Bonjour, je voudrais t'acheter (.*) contre (.*) dans la ligue (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static FRE_gggStashRegEx		:= {String:"\(onglet de réserve ""(.*)"" \; (\d+)e en partant de la gauche, (\d+)e en partant du haut\)(.*)"
										, Tab:1, Left:2, Top:3, Other:4}
	static FRE_gggQualityRegEx		:= {String:"(.*) de niveau (\d+) à (\d+)% de qualité"
										, Item:1, Level:2, Quality:3}

	static SPA_gggRegEx				:= {String:"(.*)Hola, quisiera comprar tu (.*) listado por (.*) en (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static SPA_gggUnpricedRegEx 	:= {String:"(.*)Hola, quisiera comprar tu (.*) en (.*)"
										, Other:1, Item:2, League:3}
	static SPA_gggCurrencyRegEx		:= {String:"(.*)Hola, me gustaría comprar tu\(s\) (.*) por mi (.*) en (.*)"
										, Other:1, Item:2, Price:3, League:4}
	static SPA_gggStashRegEx		:= {String:"\(pestaña de alijo ""(.*)""; posición: izquierda(\d+), arriba (\d+)\)"
										, Tab:1, Left:2, Top:3, Other:4}
	static SPA_gggQualityRegEx		:= {String:"(.*) nivel (\d+) (\d+)%"
										, Item:1, Level:2, Quality:3}

	static KOR_gggRegEx				:= {String:"(.*)안녕하세요, (.*)에 (.*)\(으\)로 올려놓은 (.*)\(을\)를 구매하고 싶습니다(.*)"
										, Other:1, League:2, Price:3, Item:4, Other2:5}
	static KOR_gggUnpricedRegEx 	:= {String:"(.*)안녕하세요, (.*)에 올려놓은 (.*)\(을\)를 구매하고 싶습니다(.*)"
										, Other:1, League:2, Item:3, Other2:4}
	static KOR_gggCurrencyRegEx		:= {String:"(.*)안녕하세요, (.*)에 올려놓은(.*)\(을\)를 제 (.*)\(으\)로 구매하고 싶습니다(.*)"
										, Other:1, League:2, Item:3, Price:4, Other2:5}
	static KOR_gggStashRegEx		:= {String:"\(보관함 탭 ""(.*)"", 위치: 왼쪽 (\d+), 상단 (\d+)\)"
										, Tab:1, Left:2, Top:3}
	static KOR_gggQualityRegEx		:= {String:"(\d+) (\d+)% (.*)"
										, Level:1, Quality:2, Item:3}

    static TWN_gggRegEx             := {String:"(.*)你好，我想購買 (.*) 標價 (.*) 在 (.*)"
                                        , Other:1, Item:2, Price:3, League:4}
    static TWN_gggUnpricedRegEx     := {String:"(.*)你好，我想購買 (.*) 在 (.*)"
                                        , Other:1, Item:2, League:3}
    static TWN_gggCurrencyRegEx     := {String:"(.*)你好，我想用 (.*) 購買 (.*) in (.*)"
                                        , Other:1, Item:2, Price:3, League:4} 										
    static TWN_gggStashRegEx        := {String:"\(倉庫頁 ""(.*)""; 位置: 左 (\d+), 上 (\d+)\)"
                                        , Tab:1, Left:2, Top:3}
    static TWN_gggQualityRegEx      := {String:"等級 (\d+) (\d+)% (.*)"
                                        , Level:1, Quality:2, Item:3}
	; huge thanks to orzmashi for helping me understand twn patterns
	static TWN_poedbRegEx			:= {String:"(.*)您好，我想買在 (.*) 的 (.*) 價格 (.*)" ; poedb twn have some useless quote before the actual whisper
										, UselessQuote:1, League:2, Item:3, Price: 4}
	static TWN_poeDbUnpricedRegEx	:= {String:"(.*)您好，我想買在 (.*) 的 (.*)"
										, UselessQuote:1, League:2, Item:3}
	static TWN_poeDbCurrencyRegEx 	:= {String:"(.*)您好，我想買在 (.*) 的 (.*) 個 (.*) 直購價 (.*)"
										, UselessQuote:1, League:2, Item:3, Item2:4, Price:5}
	static TWN_poeDbStashRegEx		:= {String:"\[倉庫:(.*) 位置: 左(\d+), 上 (\d+)\]"
										, Tab:1, Left:2, Top:3}
	static TWN_poeDbQualityRegEx	:= {String:"的 (.*) \(等級(\d+)\/(\d+)%)"
										, Item:1, Level:2, Quality:3}

	static allTradingRegex := {"poeTrade":poeTradeRegex
		,"poeTrade_Unpriced":poeTradeUnpricedRegex
		,"currencyPoeTrade":poeTradeCurrencyRegex
		,"poeApp":poeAppRegEx
		,"poeApp_Unpriced":poeAppUnpricedRegex
		,"poeApp_Currency":poeAppCurrencyRegex}

	langs := "RUS,POR,THA,GER,FRE,SPA,KOR,TWN"
	Loop, Parse, langs,% "," ; Adding ggg trans regex to allTradingRegEx
	{
		allTradingRegex["ggg_" A_LoopField] := %A_LoopField%_gggRegEx
		allTradingRegex["ggg_" A_LoopField "_unpriced"] := %A_LoopField%_gggUnpricedRegEx
		allTradingRegex["ggg_" A_LoopField "_currency"] := %A_LoopField%_gggCurrencyRegEx
	}
	allTradingRegEx["poeDb_TWN"] := TWN_poedbRegEx
	allTradingRegEx["poeDb_TWN_unpriced"] := TWN_poeDbUnpricedRegEx
	allTradingRegEx["poeDb_TWN_currency"] := TWN_poeDbCurrencyRegEx

	static ENG_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) has joined the area.*") 
	static ENG_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) has left the area.*") 
	static ENG_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK mode is now ON.*") 
	static ENG_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK mode is now OFF.*") 

	static FRE_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) a rejoint la zone.*") 
	static FRE_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) a quitté la zone.*") 
	static FRE_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Le mode Absent \(AFK\) est désormais activé.*") 
	static FRE_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Le mode Absent \(AFK\) est désactivé.*") 

	static GER_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) hat das Gebiet betreten.*") 
	static GER_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) hat das Gebiet verlassen.*")
	static GER_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK-Modus ist nun AN.*") 
	static GER_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : AFK-Modus ist nun AUS.*") 

	static POR_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) entrou na área.*") 
	static POR_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) saiu da área.*") 
	static POR_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Modo LDT Ativado.*") 
	static POR_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Modo LDT Desativado.*") 

	static RUS_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) присоединился.*") 
	static RUS_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) покинул область.*") 
	static RUS_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Режим ""отошёл"" включён.*") 
	static RUS_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : Режим ""отошёл"" выключен.*") 

	static THA_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) เข้าสู่พื้นที่.*") 
	static THA_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) ออกจากพื้นที่.*") 
	static THA_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : เปิดโหมด AFK แล้ว.*") 
	static THA_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : ปิดโหมด AFK แล้ว.*") 

	static SPA_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) se unió al área.*") 
	static SPA_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) abandonó el área.*") 
	static SPA_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : El modo Ausente está habilitado.*") 
	static SPA_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : El modo Ausente está deshabilitado.*")

	static KOR_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?)(이)가 구역에 들어왔습니다.*") 
	static KOR_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?)(이)가 구역에서 나갔습니다.*") 
	static KOR_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : 자리 비움 모드를 설정했습니다.*") 
	static KOR_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : 자리 비움 모드를 해제했습니다.*")

	static TWN_areaJoinedRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) 進入了此區域.*")
    static TWN_areaLeftRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : (.*?) 離開了此區域.*")
    static TWN_afkOnRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : 暫離模式啟動.*")
    static TWN_afkOffRegexStr := ("^(?:[^ ]+ ){6}(\d+)\] : 暫離模式關閉.*")

	allAreaJoinedRegEx := [ENG_areaJoinedRegexStr, FRE_areaJoinedRegexStr, GER_areaJoinedRegexStr, POR_areaJoinedRegexStr
		, RUS_areaJoinedRegexStr, THA_areaJoinedRegexStr, SPA_areaJoinedRegexStr, KOR_areaJoinedRegexStr, TWN_areaJoinedRegexStr]
	allAreaLeftRegEx := [ENG_areaLeftRegexStr, FRE_areaLeftRegexStr, GER_areaLeftRegexStr, POR_areaLeftRegexStr
		, RUS_areaLeftRegexStr, THA_areaLeftRegexStr, SPA_areaLeftRegexStr, KOR_areaLeftRegexStr, TWN_areaLeftRegexStr]
	allAfkOnRegEx := [ENG_afkOnRegexStr, FRE_afkOnRegexStr, GER_afkOnRegexStr, POR_afkOnRegexStr
		, RUS_afkOnRegexStr, THA_afkOnRegexStr, SPA_afkOnRegexStr, KOR_afkOnRegexStr, TWN_afkOnRegexStr]
	allAfkOffRegEx := [ENG_afkOffRegexStr, FRE_afkOffRegexStr, GER_afkOffRegexStr, POR_afkOffRegexStr
		, RUS_afkOffRegexStr, THA_afkOffRegexStr, SPA_afkOffRegexStr, KOR_afkOffRegexStr, TWN_afkOffRegexStr]

	Loop, Parse,% strToParse,`n,`r ; For each line
	{
		parsedLogsMsg := A_LoopField
		
		; Check if area joined
		for index, regexStr in allAreaJoinedRegEx {
			if RegExMatch(parsedLogsMsg, "SO)" regexStr, joinedPat) {
				instancePID := joinedPat.1, playerName := joinedPat.2
				GUI_Trades.SetTabStyleJoinedArea(playerName)
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXToggle = "True") && FileExist(PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath) {
					try
						SoundPlay,% PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath
					catch
						PlaySound(PROGRAM.SETTINGS.SETTINGS_MAIN.BuyerJoinedAreaSFXPath)
				}
				break
			}
		}
		for index, regexStr in allAreaLeftRegEx {
			if RegExMatch(parsedLogsMsg, "SO)" regexStr, leftPat) {
				instancePID := leftPat.1, playerName := leftPat.2
				GUI_Trades.UnSetTabStyleJoinedArea(playerName)
				break
			}
		}

		; Check if afk mode
		for index, regexStr in allAfkOnRegEx {
			if RegExMatch(parsedLogsMsg, "iSO)" regexStr, afkOnPat) {
				instancePID := afkOnPat.1
				GuiTrades[instancePID "_AfkState"] := True
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to ON.")
				break
			}
		}
		for index, regexStr in allAfkOffRegEx {
			if RegExMatch(parsedLogsMsg, "iSO)" regexStr, afkOffPat) {
				instancePID := afkOffPat.1
				GuiTrades[instancePID "_AfkState"] := False
				AppendToLogs("AFK mode for instance PID """ instancePID """ set to OFF.")
				break
			}
		}

		; Check if whisper sent
		isWhisperSent := isWhisper := isWhisperReceived := False
		if RegExMatch(parsedLogsMsg, "SO)^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:To|À|An|Para|Кому|ถึง|발신|向) (.*?): (.*)", whisperPat) {
			isWhisperSent := True, isWhisper := True
			instancePID := whisperPat.1, whispNameFull := whisperPat.2, whispMsg := whisperPat.3
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Sent_Name := whispName
		}
		; Check if whisper received
		else if RegExMatch(parsedLogsMsg, "SO)^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:From|De|От кого|จาก|Von|Desde|수신|來自) (.*?): (.*)", whisperPat ) {
			isWhisperReceived := True, isWhisper := True
			instancePID := whisperPat.1, whispNameFull := whisperPat.2, whispMsg := whisperPat.3
			nameAndGuild := SplitNameAndGuild(whispNameFull), whispName := nameAndGuild.Name, whispGuild := nameAndGuild.Guild
			GuiTrades.Last_Whisper_Name := whispName
		}

		; Retrieve the regEx pattern specific to the whisper type
		if (isWhisper=True) {
			for subRegEx, nothing in allTradingRegex {
				if RegExMatch(whispMsg, "iS)" allTradingRegex[subRegEx]["String"]) { ; Match found
					matchingRegEx := allTradingRegex[subRegEx]
					tradeRegExStr := allTradingRegex[subRegEx]["String"]
					tradeRegExName := subRegEx
					Break
				}
			}
		}

		if (matchingRegEx) { ; Trade whisper match
			RegExMatch(whispMsg, "iSO)" tradeRegExStr, tradePat)

			isPoeTrade := IsIn(tradeRegExName, "poeTrade,poeTrade_Unpriced,currencyPoeTrade")
			isPoeApp := IsIn(tradeRegExName, "poeApp,poeApp_Currency,poeApp_Unpriced")
			isGGGRus := IsContaining(tradeRegExName, "ggg_rus")
			isGGGPor := IsContaining(tradeRegExName, "ggg_por")
			isGGGTha := IsContaining(tradeRegExName, "ggg_tha")
			isGGGGer := IsContaining(tradeRegExName, "ggg_ger")
			isGGGFre := IsContaining(tradeRegExName, "ggg_fre")
			isGGGSpa := IsContaining(tradeRegExName, "ggg_spa")
			isGGGKor := IsContaining(tradeRegExName, "ggg_kor")
			isGGGTwn := IsContaining(tradeRegExName, "ggg_twn")
			isPoeDbTwn := IsContaining(tradeRegExName, "poeDb_twn")
			
			qualRegEx := isPoeTrade ? poeTradeQualityRegEx
				: isPoeApp ? poeAppQualityRegEx
				: isGGGRus ? RUS_gggQualityRegEx
				: isGGGPor ? POR_gggQualityRegEx
				: isGGGTha ? THA_gggQualityRegEx
				: isGGGGer ? GER_gggQualityRegEx
				: isGGGFre ? FRE_gggQualityRegEx
				: isGGGSpa ? SPA_gggQualityRegEx
				: isGGGKor ? KOR_gggQualityRegEx
				: isGGGTwn ? TWN_gggQualityRegEx
				: isPoeDbTwn ? TWN_poeDbQualityRegEx
				: ""
			stashRegEx := isPoeTrade ? poeTradeStashRegex
				: isPoeApp ? poeAppStashRegex
				: isGGGRus ? RUS_gggStashRegEx
				: isGGGPor ? POR_gggStashRegEx
				: isGGGTha ? THA_gggStashRegEx
				: isGGGGer ? GER_gggStashRegEx
				: isGGGFre ? FRE_gggStashRegEx
				: isGGGSpa ? SPA_gggStashRegEx
				: isGGGKor ? KOR_gggStashRegEx
				: isGGGTwn ? TWN_gggStashRegEx
				: isPoeDbTwn ? TWN_poeDbStashRegEx
				: ""

			whisperLang := isPoeTrade ? "ENG"
				: isPoeApp ? "ENG"
				: isGGGRus ? "RUS"
				: isGGGPor ? "POR"
				: isGGGTha ? "THA"
				: isGGGGer ? "GER"
				: isGGGFre ? "FRE"
				: isGGGSpa ? "SPA"
				: isGGGKor ? "KOR"
				: isGGGTwn ? "TWN"
				: isPoeDbTwn ? "TWN"
				: ""

			tradeBuyerName := whispName, tradeBuyerGuild := whispGuild
			tradeOtherStart := tradePat[matchingRegEx["Other"]]
			tradeItem := tradePat[matchingRegEx["Item"]], tradeItem .= tradePat[matchingRegEx["Item2"]] ? " " tradePat[matchingRegEx["Item2"]] : "", AutoTrimStr(tradeItem)
			tradePrice := tradePat[matchingRegEx["Price"]]
			tradeLeagueAndMore := tradePat[matchingRegEx["League"]]
			tradeLeagueAndMore .= tradePat[matchingRegEx["Other2"]]

			; German priced whisper is the same as currency whisper. Except that currency whisper has '' between price name
			; while the normal whisper doesn't have them. Fix: Remove '' in price if detected
			if (whisperLang = "GER") && ( SubStr(tradePrice, 1, 1) = "'" ) && ( SubStr(tradePrice, 0, 1) = "'") {
				StringTrimLeft, tradePrice, tradePrice, 1
				StringTrimRight, tradePrice, tradePrice, 1
			}

			AutoTrimStr(tradeBuyerName, tradeItem, tradePrice, tradeOtherStart)

			leagueMatches := [], leagueMatchesIndex := 0
			leaguesList := LEAGUES
			if (GAME.CHALLENGE_LEAGUE_TRANS[whisperLang])
				for index in GAME.CHALLENGE_LEAGUE_TRANS[whisperLang]
					leaguesList .= "," GAME.CHALLENGE_LEAGUE_TRANS[whisperLang][index]
			if (GAME.STANDARD_LEAGUE_TRANS[whisperLang])
				for index in GAME.STANDARD_LEAGUE_TRANS[whisperLang]
					leaguesList .= "," GAME.STANDARD_LEAGUE_TRANS[whisperLang][index]
			
			Loop, Parse, leaguesList,% ","
			{
				parsedLeague := A_LoopField
				parsedLeague := StrReplace(parsedLeague, "(", "\(")
				parsedLeague := StrReplace(parsedLeague, ")", "\)")
				if RegExMatch(tradeLeagueAndMore, "iSO)" parsedLeague "(.*)", leagueAndMorePat) {
					leagueMatchesIndex++
					tradeLeague := A_LoopField
					restOfWhisper := leagueAndMorePat.1
					AutoTrimStr(tradeLeague, restOfWhisper)

					leagueMatches[leagueMatchesIndex] := {Len:StrLen(A_LoopField), Str:A_LoopField}
				}
			}
			Loop % leagueMatches.MaxIndex() {
				if (leagueMatches[A_Index].Len > biggestLen) {
					biggestLen := leagueMatches[A_Index].Len, tradeLeague := leagueMatches[A_Index].Str
				}
			}

			if (!tradeLeague)
				restOfWhisper := tradeLeagueAndMore

			if RegExMatch(tradeItem, "iSO)" qualRegEx.String, qualPat) && (qualRegEx.String) {
				tradeItem := qualPat[qualRegEx["Item"]]
				tradeItemLevel := qualPat[qualRegEx["Level"]]
				tradeItemQual := qualPat[qualregEx["Quality"]]
				AutoTrimStr(tradeItem, tradeItemLevel, tradeItemQual)

				tradeItemFull := tradeItem " (Lvl:" tradeItemLevel " / Qual:" tradeItemQual "%)"
			}
			else {
				tradeItemFull := tradeItem
				AutoTrimStr(tradeItemFull)
			}
			if RegExMatch(restOfWhisper, "iSO)" stashRegEx.String, stashPat) && (stashRegEx.String) {
				tradeStashTab := stashPat[stashRegEx["Tab"]]
				tradeStashLeft := stashPat[stashRegEx["Left"]]
				tradeStashTop := stashPat[stashRegEx["Top"]]
				tradeOtherEnd := stashPat[stashRegEx["Other"]]
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
			: ("ERROR")

			timeStamp := A_YYYY "/" A_MM "/" A_DD " " A_Hour ":" A_Min ":" A_Sec

			if (isWhisperReceived=True) {
				currencyInfos := Get_CurrencyInfos(tradePrice, dontWriteLogs:=False)
				currencyName := currencyInfos.Is_Listed?currencyInfos.Name : tradePrice
				currencyCount := RegExReplace(tradePrice, "\D")
				tradePrice := currencyInfos.Is_Listed ? currencyCount " " currencyName : tradePrice
				tradeOther := tradeOther?"[" A_Hour ":" A_Min "] @From: " tradeOther : ""
				
				tradeInfos := {Buyer:tradeBuyerName, Item:tradeItemFull, Price:tradePrice, Stash:tradeStashFull, OtherFull:tradeOther
					,BuyerGuild:tradeBuyerGuild, TimeStamp:timeStamp,PID:instancePID, IsInArea:False, HasNewMessage:False, WithdrawTally:0, Time: A_Hour ":" A_Min
					,WhisperSite:tradeRegExName, UniqueID:GUI_Trades.GenerateUniqueID(), TradeVerify:"Grey", WhisperLang:whisperLang}
				err := Gui_Trades.PushNewTab(tradeInfos)

				if !(err) {
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
						if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades[instancePID "_AfkState"] = True)
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
				RegExMatch(tradePrice, "O)(\d+.\d+|\d+) (.*)", tradePricePat), currencyCount := tradePricePat.1, currencyName := tradePricePat.2
				currencyInfos := Get_CurrencyInfos(currencyName, dontWriteLogs:=False)
				currencyName := currencyInfos.Is_Listed?currencyInfos.Name : currencyName	
				
				tradeOther := tradeOther?"[" A_Hour ":" A_Min "] @To: " tradeOther : ""
				tradeInfos := {Seller:tradeBuyerName, Item:tradeItemFull, Price:currencyCount, Currency:currencyName, Stash:tradeStashFull, AdditionalMsgFull:tradeOther
					,TimeStamp:timeStamp, PID:instancePID, TimeSent: A_Hour ":" A_Min
					,WhisperSite:tradeRegExName, UniqueID:GUI_TradesBuyCompact.GenerateUniqueID(), WhisperLang:whisperLang}
				err := GUI_TradesBuyCompact.PushNewTab(tradeInfos)
			}
		}
		else if (parsedLogsMsg && !matchingRegEx && isWhisper=True) { ; No trading whisper match
			; Add whisper to buyer's tab if existing
			if (isWhisperReceived) {
				Loop % GuiTrades.Tabs_Count {
					tabInfos := Gui_Trades.GetTabContent(A_Index)
					if (tabInfos.Buyer = whispName) {
						Gui_Trades.UpdateSlotContent(A_Index, "OtherFull", "[" A_Hour ":" A_Min "] @From: " whispMsg)
						GUI_Trades.SetTabStyleWhisperReceived(whispName)
					}
				}
				Loop % GuiTradesBuyCompact.Tabs_Count {
					tabInfos := GUI_TradesBuyCompact.GetSlotContent(A_Index)
					if (tabInfos.Seller = whispName) {
						GUI_TradesBuyCompact.UpdateSlotContent(A_Index, "AdditionalMsgFull", "[" A_Hour ":" A_Min "] @From: " whispMsg)
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
					if (PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletOnlyWhenAFK = "True" && GuiTrades[instancePID "_AfkState"] = True)
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
				Loop % GuiTradesBuyCompact.Tabs_Count {
					tabInfos := GUI_TradesBuyCompact.GetSlotContent(A_Index)
					if (tabInfos.Seller = whispName) {
						GUI_TradesBuyCompact.UpdateSlotContent(A_Index, "AdditionalMsgFull", "[" A_Hour ":" A_Min "] @To: " whispMsg)
					}
				}
				Loop % GuiTrades.Tabs_Count {
					tabInfos := GUI_Trades.GetTabContent(A_Index)
					if (tabInfos.Buyer = whispName) {
						GUI_Trades.UpdateSlotContent(A_Index, "OtherFull", "[" A_Hour ":" A_Min "] @To: " whispMsg)
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
	; Make sure it starts with @ and doesnt contain line break
	firstChar := SubStr(str, 1, 1)
	if InStr(str, "`n") || (firstChar != "@")  {
		Return False
	}

	allTradingRegEx := { "currencyPoeTrade": "(.*)Hi, I'd like to buy your (.*) for my (.*) in (.*)"
		, "ggg_FRE": "(.*)Bonjour, je souhaiterais t'acheter (.*) pour (.*) dans la ligue (.*)"
		, "ggg_FRE_currency": "(.*)Bonjour, je voudrais t'acheter (.*) contre (.*) dans la ligue (.*)"
		, "ggg_FRE_unpriced": "(.*)Bonjour, je souhaiterais t'acheter (.*) dans la ligue (.*)"
		, "ggg_GER": "(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von (.*) in der '(.*)'-Liga kaufen(.*)"
		, "ggg_GER_currency": "(.*)Hi, ich möchte '(.*)' zum angebotenen Preis von '(.*)' in der '(.*)'-Liga kaufen(.*)"
		, "ggg_GER_unpriced": "(.*)Hi, ich möchte '(.*)' in der '(.*)'-Liga kaufen(.*)"
		, "ggg_KOR": "(.*)안녕하세요, (.*)에 (.*)\(으\)로 올려놓은 (.*)\(을\)를 구매하고 싶습니다(.*)"
		, "ggg_KOR_currency": "(.*)안녕하세요, (.*)에 올려놓은(.*)\(을\)를 제 (.*)\(으\)로 구매하고 싶습니다(.*)"
		, "ggg_KOR_unpriced": "(.*)안녕하세요, (.*)에 올려놓은 (.*)\(을\)를 구매하고 싶습니다(.*)"
		, "ggg_POR": "(.*)Olá, eu gostaria de comprar o seu item (.*) listado por (.*) na (.*)"
		, "ggg_POR_currency": "(.*)Olá, eu gostaria de comprar seu\(s\) (.*) pelo\(s\) meu\(s\) (.*) na (.*)"
		, "ggg_POR_unpriced": "(.*)Olá, eu gostaria de comprar o seu item (.*) na (.*)"
		, "ggg_RUS": "(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
		, "ggg_RUS_currency": "(.*)Здравствуйте, хочу купить у вас (.*) за (.*) в лиге (.*)"
		, "ggg_RUS_unpriced": "(.*)Здравствуйте, хочу купить у вас (.*) в лиге (.*)"
		, "ggg_SPA": "(.*)Hola, quisiera comprar tu (.*) listado por (.*) en (.*)"
		, "ggg_SPA_currency": "(.*)Hola, me gustaría comprar tu\(s\) (.*) por mi (.*) en (.*)"
		, "ggg_SPA_unpriced": "(.*)Hola, quisiera comprar tu (.*) en (.*)"
		, "ggg_THA": "(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน ราคา (.*) ใน (.*)"
		, "ggg_THA_currency": "(.*)สวัสดี เรามีความต้องการจะชื้อ (.*) ของคุณ ฉันมี (.*) ใน (.*)"
		, "ggg_THA_unpriced": "(.*)สวัสดี, เราต้องการจะชื้อของคุณ (.*) ใน (.*)"
		, "ggg_TWN": "(.*)你好，我想購買 (.*) 標價 (.*) 在 (.*)"
		, "ggg_TWN_currency": "(.*)你好，我想用 (.*) 購買 (.*) in (.*)"
		, "ggg_TWN_unpriced": "(.*)你好，我想購買 (.*) 在 (.*)"
		, "poeApp": "(.*)wtb (.*) listed for (.*) in (.*)"
		, "poeApp_Currency": "(.*)I'd like to buy your (.*) for my (.*) in (.*)"
		, "poeApp_Unpriced": "(.*)wtb (.*) in (.*)"
		, "poeDb_TWN": "(.*)您好，我想買在 (.*) 的 (.*) 價格 (.*)"
		, "poeDb_TWN_currency": "(.*)您好，我想買在 (.*) 的 (.*) 個 (.*) 直購價 (.*)"
		, "poeDb_TWN_unpriced": "(.*)您好，我想買在 (.*) 的 (.*)"
		, "poeTrade": "(.*)Hi, I would like to buy your (.*) listed for (.*) in (.*)"
		, "poeTrade_Unpriced": "(.*)Hi, I would like to buy your (.*) in (.*)" }	

	; Check if trading whisper
	for regexName in allTradingRegEx { ; compare whisper with regex
		if (allTradingRegEx[regexName]) && RegExMatch(str, "iS)" allTradingRegEx[regexName]) { ; Trading whisper detected
			return True
		}
	}
}

Is_Tool_Elevation_SameLevel_As_GameInstance(gamePID) {
	isElevated := Is_Game_Elevated(gamePID)
	
	isSameLevel := (isElevated = True) && (A_IsAdmin) ? True
		: (isElevated = False) ? True
		: (isElevated = True) ? False
		: False

	return isSameLevel
}

Is_Game_Elevated(gamePID) {
	
	WinGet, pName, ProcessName, ahk_pid %gamePID%
	processInfos := Get_ProcessInfos(pName, gamePID)
	isProcessElevated := (processInfos[1]["TokenIsElevated"])?(True):(processInfos=2)?(True):(False)

	return isProcessElevated
}