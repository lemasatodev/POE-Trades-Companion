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
	DllCall( "RegisterShellHookWindow", UInt,Hwnd )
	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
	OnMessage( MsgNum, "ShellMessage", state)
}

ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global PROGRAM
	global GuiTrades, GuiTradesMinimized
	global GuiTradesBuyCompact, GuiTradesBuyCompact_Controls
	global GuiSettings, POEGameList
	
	if ( wParam=4 || wParam=32772 || wParam=5 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED | 5=HSHELL_GETMINRECT 
		if WinActive("ahk_id" GuiTrades.Handle) {
;		Prevent these keyboard presses from interacting with the Trades GUI
			Hotkey, IfWinActive,% "ahk_id " GuiTrades.Handle
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

		if (GuiTrades.Is_Created) {
			tradesWinExists := GUI_Trades.Exists()
			tradesMinWinExists := Gui_TradesMinimized.Exists()
			tradesBuyCompactWinExists := GUI_TradesBuyCompact.Exists()

			if (PROGRAM.SETTINGS.SETTINGS_MAIN.HideInterfaceWhenOutOfGame = "True") {
				if (lParam) {
					WinGet, activeWinExe, ProcessName, ahk_id %lParam%
					WinGet, activeWinHwnd, ID, ahk_id %lParam%
					WinGet, activeWinPID, PID, ahk_id %lParam%
					if (activeWinExe="" || activeWinHwnd="") {
						WinGet, activeWinExe, ProcessName, A
						WinGet, activeWinHwnd, ID, A	
						WinGet, activeWinPID, PID, A
					}
				}
				else {
					WinGet, activeWinExe, ProcessName, A
					WinGet, activeWinHwnd, ID, A	
					WinGet, activeWinPID, PID, A
				}

				if (activeWinHwnd = GuiTrades.Handle) || (activeWinHwnd = GuiTradesMinimized.Handle) || (activeWinPID = PROGRAM.PID) { ; Fix unable to min/max while HideInterfaceWhenOutOfGame=True
					Gui_Trades.SetTransparency_Automatic()
				}
				else if (activeWinExe && IsIn(activeWinExe, POEGameList)) || (activeWinHwnd && GuiSettings.Handle && activeWinHwnd = GuiSettings.Handle) || (activeWinPID = PROGRAM.PID) {
					Gui_Trades.SetTransparency_Automatic()
					if (GuiTrades.Is_Minimized) {
						if (tradesMinWinExists)
							Gui, TradesMinimized:Show, NoActivate
					}
					else {
						if (tradesWinExists)
							Gui, Trades:Show, NoActivate						
					}

					if (tradesBuyCompactWinExists)
						Gui, TradesBuyCompact:Show, NoActivate
				}
				else {
					if (GuiTrades.Is_Minimized) {
						if (tradesMinWinExists)
							Gui, TradesMinimized:Hide
					}
					else {
						if (tradesWinExists)
							Gui, Trades:Hide
					}

					if (tradesBuyCompactWinExists)
						Gui, TradesBuyCompact:Hide
				}
			}
			else {
				if (GuiTrades.Is_Minimized) {
					if (tradesMinWinExists)
						Gui, TradesMinimized:Show, NoActivate
				}
				else {
					if (tradesWinExists)
						Gui, Trades:Show, NoActivate
				}

				if (tradesBuyCompactWinExists)
					Gui, TradesBuyCompact:Show, NoActivate
			}

			if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock")
				GUI_Trades.DockMode_SetPosition()

			WinGet, activePID, PID, ahk_id %lParam%
			if (activePID = GUI_Trades.GetTabContent(Gui_Trades.GetActiveTab()).PID && GuiTrades.Is_Maximized = True)
				GUI_Trades.ShowActiveTabItemGrid() ; Recreate. In case window moved.
				; GUI_ItemGrid.Show() ; Just show at same pos.
			else {
				GUI_ItemGrid.Hide()
			}

			if (tradesWinExists) {
				Gui, Trades:+LastFound
				WinSet, AlwaysOnTop, On
			}
			if (tradesMinWinExists) {
				Gui, TradesMinimized:+LastFound
				WinSet, AlwaysOnTop, On
			}
			if (tradesBuyCompactWinExists) {
				Gui, TradesBuyCompact:+LastFound
				WinSet, AlwaysOnTop, On
			}
		}

		if WinActive("ahk_id" GuiTradesBuyCompact_Controls.GuiTradesBuyCompactSearchHiddenHandle) {
			GUI_TradesBuyCompact.SetFakeSearch(makeEmpty:=True)
		}

		WinGet, winPName, ProcessName, ahk_id %lParam%
		if IsIn(winPName, POEGameList)
			WinGet, LASTACTIVATED_GAMEPID, PID, ahk_id %lParam%
	}
	return
}
