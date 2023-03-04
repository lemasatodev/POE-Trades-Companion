ShellMessage_Enable() {
	ShellMessage_State(True)
}

ShellMessage_Disable() {
	ShellMessage_State(False)
}

ShellMessage_State(state) {
	Gui, ShellMsg:Destroy
	Gui, ShellMsg:New, +LastFound 

	Hwnd := WinExist()
	DllCall("RegisterShellHookWindow", UInt, Hwnd)
	MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
	OnMessage(MsgNum, "ShellMessage", state)
}

ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global PROGRAM, GAME
	global GuiTrades, GuiTrades_Controls
	global GuiSettings
	global GuiTabbedTradesCounter
	global POEGameList

	if !IsIn(wParam, "4,5,32772") ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED | 5=HSHELL_GETMINRECT 
		return

	if (lParam) { ; Ccan retrieve process infos based on lparam
		WinGet, activeWinExe, ProcessName, ahk_id %lParam%
		WinGet, activeWinHwnd, ID, ahk_id %lParam%
		WinGet, activeWinPID, PID, ahk_id %lParam%
	}
	else if ( !lParam || ( lParam && activeWinExe="" || activeWinHwnd="") ) { ; Retrieve process infos of currently active window
		WinGet, activeWinExe, ProcessName, A
		WinGet, activeWinHwnd, ID, A	
		WinGet, activeWinPID, PID, A
	}

	if IsIn(activeWinExe, POEGameList) {
		GAME.LastActivePID := activeWinPID
		if (GUI_TabbedTradesCounter.sGUI.Handle)
			GUI_TabbedTradesCounter.Destroy()
	}

	/* Useless since the Trades GUI cannot be focused anymore due to the E0x08000000
	if IsIn(lParam, GuiTrades.Buy.Handle "," GuiTrades.Sell.Handle "," GuiTrades.BuyPreview.Handle "," GuiTrades.SellPreview.Handle) {
		; Prevent these keyboard presses from interacting with the Trades GUI
		Hotkey, IfWinActive,% "ahk_id " lParam
		Hotkey, NumpadEnter, DoNothing, On
		Hotkey, Escape, DoNothing, On
		Hotkey, Space, DoNothing, On
		Hotkey, Tab, DoNothing, On
		Hotkey, Enter, DoNothing, On
		Hotkey, Left, DoNothing, On
		Hotkey, Right, DoNothing, On
		Hotkey, Up, DoNothing, On
		Hotkey, Down, DoNothing, On
		Hotkey, IfWinActive
		Return ; returning prevents from triggering Gui_Trades_Set_Position while the GUI is active
	}
	*/

	if (GuiTrades.Sell.Is_Created || GuiTrades.Buy.Is_Created) {
		sellWinExists := GUI_Trades_V2.Exists("Sell"), sellWinHandle := GuiTrades.Sell.Handle
		buyWinExists := GUI_Trades_V2.Exists("Buy"), buyWinHandle := GuiTrades.Buy.Handle

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.HideInterfaceWhenOutOfGame = "True") {
			if (activeWinPID = PROGRAM.PID) { ; Fix unable to min/max while HideInterfaceWhenOutOfGame=True
				Gui_Trades_V2.SetTransparency_Automatic("Sell")
				Gui_Trades_V2.SetTransparency_Automatic("Buy")
			}
			else if ( activeWinExe && IsIn(activeWinExe, POEGameList) )
			|| ( (activeWinHwnd && GuiSettings.Handle) && (activeWinHwnd = GuiSettings.Handle) )
			|| ( activeWinPID = PROGRAM.PID ) {
				Gui_Trades_V2.SetTransparency_Automatic("Sell")
				Gui_Trades_V2.SetTransparency_Automatic("Buy")
				if (sellWinExists)
					Gui, TradesSell:Show, NoActivate
				if (buyWinExists)
					Gui, TradesBuy:Show, NoActivate
			}
			else {
				if (sellWinExists)
					Gui, TradesSell:Hide
				if (buyWinExists)
					Gui, TradesBuy:Hide
			}
		}
		else { ; only show if tabs_count or poe is active
			if (sellWinExists) {
				if (GuiTrades.Sell.Tabs_Count || WinActive("ahk_group POEGameGroup") || WinActive("ahk_pid " PROGRAM.PID))
					Gui, TradesSell:Show, NoActivate					
				else
					Gui, TradesSell:Hide
			}
			if (buyWinExists) {
				if (GuiTrades.Buy.Tabs_Count || WinActive("ahk_group POEGameGroup") || WinActive("ahk_pid " PROGRAM.PID))
					Gui, TradesBuy:Show, NoActivate
				else
					Gui, TradesBuy:Hide
			}
		}

		if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock") {
			GUI_Trades_V2.DockMode_SetPosition()
			GUI_Trades_V2.DockMode_SetPosition()
		}

		activeTabPID := GUI_Trades_V2.GetTabContent("Sell", GuiTrades.Sell.Active_Tab).GamePID
		if (activeTabPID = activeWinPID && GuiTrades.Sell.Is_Maximized = True)
			GUI_Trades_V2.ShowItemGrid(GuiTrades.Sell.Active_Tab) ; Recreate. In case window moved.
		else
			GUI_Trades_V2.DestroyItemGrid()

		if WinActive("ahk_id" GuiTrades_Controls.Buy.GuiSearchHiddenHandle)
			GUI_Trades_V2.SetFakeSearch("Buy", makeEmpty:=True)
		else if WinActive("ahk_id" GuiTrades_Controls.Sell.GuiSearchHiddenHandle)
			GUI_Trades_V2.SetFakeSearch("Sell", makeEmpty:=True)

		if (sellWinExists) {
			Gui, TradesSell:+LastFound
			WinSet, AlwaysOnTop, On
		}
		if (buyWinExists) {
			Gui, TradesBuy:+LastFound
			WinSet, AlwaysOnTop, On
		}
	}
}
