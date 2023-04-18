StackClick() {
	global PROGRAM, GuiTrades
	static lastAvailable, lastTime
	static scanCode_Enter := PROGRAM.SCANCODES.Enter

	activeTab := GUI_Trades.GetActiveTab()
	tabContent := GUI_Trades.GetTabContent(activeTab)
	if !IsNum(activeTab) || !RegExMatch(tabContent.Item, "\d+") || (GuiTrades.Is_Minimized = True) { ; No tabs || not currency trade || gui minimized
		GoSub %A_ThisFunc%_SendHotkeyKeys
		return
	}
	LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount
	SendInput ^{sc02E} ; Ctrl+C

	; wait for the clipboard and do nothing if it fails 
	ClipWait,% LongCopy ? 0.6 : 0.2, 1
	if (ErrorLevel) {
		GoSub %A_ThisFunc%_SendHotkeyKeys
		ShowToolTip(PROGRAM.NAME "'s StackClick function timed out due`nto the clipboard not updating in time.")
		return
	}
	clip := Clipboard

	item := Get_CurrencyInfos(tabContent.Item).Name

	if (item && RegExMatch(clip, "i)(?:" item ")[\s\S]*: (\d+(?:[,.]\d+)*)\/(\d+(?:[,.]\d+)*)", match)) {
		available := RegexReplace(match1, "[,.]")
		stackSize := RegexReplace(match2, "[,.]")

		RegExMatch(tabContent.Item, "\d+", required) ; get required amount
		withdrawn := tabContent.WithdrawTally
		amount := (available >= stackSize) ? stackSize : available

		; if available amount hasn't changed, it's likely the previous click hasn't gone through yet
		if (available = lastAvailable) {
			tipInfo := "Stack size hasn't changed since your last click."
			. "`n" "This is normaly caused by latency issues but"
			. "`n" "could mean the macro has run into problems."
			. "`n" "Press Ctrl+Click if you think everything is fine and"
			. "`n" "need at least one more stack of currency"
			Gosub %A_ThisFunc%_ShowToolTip
			return
		}
		; Don't do anything if we've already withdrawn all we need
		if ( ((required-withdrawn) <= 0) && withdrawn ) {
			tipInfo := "You've already withdrawn the " required " " item "."
			Gosub %A_ThisFunc%_ShowToolTip
			return
		}

		if ((withdrawn + amount) < required) {
			Gosub %A_ThisFunc%_CtrlClick
		} else if ((withdrawn + amount) = required) {
			Gosub %A_ThisFunc%_CtrlClick
			Gosub %A_ThisFunc%_Finished
		} else {
			amount := required - withdrawn
			Gosub %A_ThisFunc%_ShiftClickPlus
			Gosub %A_ThisFunc%_Finished
		}

		withdrawn := withdrawn + amount ;update for tooltip
		GUI_Trades.UpdateSlotContent(activeTab, "WithdrawTally", withdrawn)
		Gosub %A_ThisFunc%_ShowToolTip
		; If transfering individual stacks, add a 250ms delay to account for lag and remove lastAvailable. Otherwise next click will do nothing
		if (available == stackSize) {
			Sleep 250
			lastAvailable := 0
		} else {
			lastAvailable := available
		}
	} else {
		Gosub %A_ThisFunc%_SendHotkeyKeys
	}
	; lastTime := A_Now A_MSec
	return

	; Using these because ^{LButton} was finicky, sometimes including shifts or not executing properly
	StackClick_CtrlClick:
		Gosub %A_ThisFunc%_GetModifiersStates
		SendInput {Ctrl Down}{LButton}{Ctrl Up}
		Gosub %A_ThisFunc%_ReturnModifiersStates
	return
	StackClick_SendHotkeyKeys:
		SendInput % Transform_AHKHotkeyString_Into_InputSring(A_ThisHotkey)
	return
	StackClick_ShiftClickPlus:
		Gosub %A_ThisFunc%_GetModifiersStates
		SendInput {Shift Down}{LButton}{Shift Up}
		SendInput, %amount%{%scanCode_Enter%}
		Gosub %A_ThisFunc%_ReturnModifiersStates
	return
	StackClick_GetModifiersStates:
		laltState := (GetKeyState("LAlt"))?("Down"):("Up")
		raltState := (GetKeyState("RAlt"))?("Down"):("Up")
		lshiftState := (GetKeyState("LShift"))?("Down"):("Up")
		rshiftState := (GetKeyState("RShift"))?("Down"):("Up")
		lctrlState := (GetKeyState("LCtrl"))?("Down"):("Up")
		rctrlState := (GetKeyState("RCtrl"))?("Down"):("Up")
		Hotkey, *LAlt, DoNothing, On
		Hotkey, *RAlt, DoNothing, On
		Hotkey, *LShift, DoNothing, On
		Hotkey, *RShift, DoNothing, On
		Hotkey, *LCtrl, DoNothing, On
		Hotkey, *RCtrl, DoNothing, On
		sleep 10
	return
	StackClick_ReturnModifiersStates:
		sleep 10
		Hotkey, *LAlt, DoNothing, Off
		Hotkey, *RAlt, DoNothing, Off
		Hotkey, *LShift, DoNothing, Off
		Hotkey, *RShift, DoNothing, Off
		Hotkey, *LCtrl, DoNothing, Off
		Hotkey, *RCtrl, DoNothing, Off
		SendInput {LAlt %laltState%}{RAlt %raltState%}{LShift %lshiftState%}{RShift %rshiftState%}{RCtrl %rctrlState%}{LCtrl %lctrlState%} ; Restore modifiers
	return
	StackClick_Finished: 
		lastAvailable := 0
		tipInfo := "Finished.`nYou should have " required " " item "."
	return
	StackClick_ShowToolTip:
		_tip := "Needed: " required
		. "`nTaken: " withdrawn

		if (tipInfo)
			_tip := tipInfo "`n`n" _tip
		; _tip := PROGRAM.Name " `n"
		; _tip .= "===============================`n"
		; _tip .= item.Name "`n"
		; _tip .= "Required: " required " | Withdrawn: "  withdrawn "`n"
		; if (tipInfo) {
		; 	_tip .= "===============================`n"
		; 	_tip .= tipInfo
		; }
		RemoveToolTip()
		ShowToolTip(_tip)
	return
}
