OnClipboardChange_Func(_Type) {
	global PROGRAM, GAME
	global AUTOWHISPER_HISTORY, AUTOWHISPER_WAITKEYUP, AUTOWHISPER_CANCEL
	static isFunctionRunning, previousStr

	if !IsObject(AUTOWHISPER_HISTORY)
		AUTOWHISPER_HISTORY := []

	maxHistory := 5
	chatKeyVK := GAME.SETTINGS.ChatKey_VK
	isEnabled := PROGRAM.SETTINGS.SETTINGS_MAIN.SendTradingWhisperUponCopyWhenHoldingCTRL
	modKeyVK := "0x11" ; CTRL

	if (isFunctionRunning || isEnabled != "True")
		Return

	isFunctionRunning := True, clipboardStr := Clipboard
	if !IsTradingWhisper(clipboardStr) { ; Not a trading whisper, cancel
		GoSub OnClipboardChange_Func_Finished
		Return
	}
	
	; Check if whisper is in history
	for histID, histContent in AUTOWHISPER_HISTORY {
		if (clipboardStr = histContent) { ; whisper is in history
			isWhisperInHistory := True
			Break
		}
	}


	isModKeyDown := GetKeyState("VK" modKeyVK)
	if !(isModKeyDown) {
		GoSub OnClipboardChange_Func_Finished
		Return
	}
	if (isWhisperInHistory) { ; whisper sent not long ago, cancel
		ShowToolTip(PROGRAM.NAME "`nThis whisper was sent within`nthe last " maxHistory " previous whispers`nOperation canceled.")
		GoSub OnClipboardChange_Func_Finished
		Return
	}
	Hotkey, IfWinActive
	Hotkey, *Space, Cancel_AutoWhisper, On
	ShowToolTip(PROGRAM.NAME "`nThis whisper will be sent upon releasing CTRL.`nPress [ SPACE ] to cancel.")
	AUTOWHISPER_WAITKEYUP := True
	KeyWait, VK%modKeyVK%, L
	RemoveToolTip()
	AUTOWHISPER_WAITKEYUP := False
	Hotkey, *Space, Cancel_AutoWhisper, Off

	if (AUTOWHISPER_CANCEL) {
		AUTOWHISPER_CANCEL := False
		GoSub OnClipboardChange_Func_Finished
		Return
	}

	; Sending the message
	err := Send_GameMessage("WRITE_SEND", clipboardStr, GAME.LastActivePID)
	if (err) {
		ShowToolTip(PROGRAM.NAME " - " err "`nFailed to send the whisper in-game.")
		Return
	}
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.SendWhoisWithTradingWhisperCTRLCopy = "True") {
		RegExMatch(clipboardStr, "iO)@(.*?) .*", match)
		Send_GameMessage("WRITE_SEND", "/whois " match.1, GAME.LastActivePID)
	}

	; Update AUTOWHISPER_HISTORY array
	if (AUTOWHISPER_HISTORY.MaxIndex() >= maxHistory) { ; Re-organize previous whispers array
		Loop % AUTOWHISPER_HISTORY.MaxIndex() {
			if (A_Index < maxHistory)
				AUTOWHISPER_HISTORY[A_Index] := AUTOWHISPER_HISTORY[A_Index+1]
			else
				AUTOWHISPER_HISTORY.RemoveAt(A_Index)
		}
	}
	AUTOWHISPER_HISTORY.Push(clipboardStr) ; Add whisper to array

	previousStr := clipboardStr
	GoSub OnClipboardChange_Func_Finished
	Return

	OnClipboardChange_Func_Finished:
		isFunctionRunning := False
	Return
}
