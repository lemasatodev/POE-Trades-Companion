TrayMenu() {
	global PROGRAM, DEBUG

	trans := PROGRAM.TRANSLATIONS.TrayMenu

	Menu,Tray,DeleteAll
	if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
		Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
	Menu,Tray,Tip,% PROGRAM.NAME " - " PROGRAM.ALPHA
	Menu,Tray,NoStandard
	if (DEBUG.settings.open_settings_gui) {
			Menu,Tray,Add,Recreate Settings GUI, Tray_CreateSettings ; Recreate Settings GUI
	}
	Menu,Tray,Add,% trans.Settings, Tray_OpenSettings ; Settings
	Menu,Tray,Add,% trans.Stats, Tray_OpenStats ; My Stats
	; if (PROGRAM.IS_BETA = "True")
		; Menu,Tray,Add,Beta tasks, Tray_OpenBetaTasks 
	Menu,Tray,Add
	Loop, Files,% PROGRAM.CHEATSHEETS_FOLDER "\*.png"
	{
		SplitPath,% A_LoopFileName, , , , fileNameNoExt
		__f := ObjBindMethod(GUI_CheatSheet, "Show", A_LoopFileFullPath)
		Menu, TraySheetSub, Add,% fileNameNoExt,% __f
	}
	Menu,Tray,Add,Leagues Sheets, :TraySheetSub
	Menu,Tray,Add
	/* Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
	Menu,Tray,Add,% trans.Clickthrough, Tray_ToggleClickthrough ; Clickthrough?
	*/
	Menu,Tray,Add,% trans.LockPosition, Tray_ToggleLockPosition ; Lock position?
	/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
	Menu,Tray,Add
	Menu,Tray,Add,% trans.ModeWindow, Tray_ModeWindow ; Mode: Window
	
	Menu,Tray,Add,% trans.ModeDock, Tray_ModeDock ; Mode: Dock
	Menu,Tray,Add,% trans.CycleDock, Tray_CycleDock ; Cycle Dock
	*/
	Menu,Tray,Add,% trans.ResetPosition, Tray_ResetPosition ; Reset Position
	Menu,Tray,Add
	Menu,Tray,Add,% trans.Reload, Tray_Reload ; Reload
	Menu,Tray,Add,% trans.Close, Tray_Exit ; Close
	Menu,Tray,Icon
	Menu,Tray,Default,% trans.Settings ; On Double click

	; Pos lock check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
		Menu, Tray, Check,% trans.LockPosition
	else
		Menu, Tray, Uncheck,% trans.LockPosition

	; Clickthrough check
	/* Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True") 
		Menu, Tray, Check,% trans.Clickthrough
	else
		Menu, Tray, Uncheck,% trans.Clickthrough
	*/

	; TradesGUI Mode check
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window") 
		GUI_Trades_V2.Use_WindowMode(True)
	else if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Dock")
		GUI_Trades_V2.Use_DockMode(True)

	; Icons
	Menu, Tray, Icon,% trans.Settings,% PROGRAM.ICONS_FOLDER "\gear.ico"
	; Menu, Tray, Icon,,% PROGRAM.ICONS_FOLDER "\qmark.ico"
	Menu, Tray, Icon,% trans.Stats,% PROGRAM.ICONS_FOLDER "\chart.ico"
	Menu, Tray, Icon,% trans.Reload,% PROGRAM.ICONS_FOLDER "\refresh.ico"
	Menu, Tray, Icon,% trans.Close,% PROGRAM.ICONS_FOLDER "\x.ico"
}

Tray_OpenBetaTasks() {
	GUI_BetaTasks.Show()
}
Tray_GitHub() {
	global PROGRAM
	Run, % PROGRAM.LINK_GITHUB
}
Tray_Reload() {
	Reload()
}
Tray_Exit() {
	ExitApp
}
Tray_CreateSettings() {
	GUI_Settings.Create()
	GUI_Settings.Show()
}
Tray_OpenSettings() {
	global CANCEL_TRAY_MENU
	CANCEL_TRAY_MENU := True
	GUI_Settings.Show()
}
Tray_OpenStats() {
	GUI_MyStats.Show()
}
Tray_ModeWindow() {
	global PROGRAM

	GUI_Trades_V2.Use_WindowMode()
	Tray_ToggleLockPosition("Uncheck")
	Declare_LocalSettings()
	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ModeWindowEnabled_Title, PROGRAM.TRANSLATIONS.TrayNotifications.ModeWindowEnabled_Msg)
}
Tray_ModeDock() {
	global PROGRAM
	Tray_ModeWindow() ; BdO6CY5Oov - Getting rid of Dock mode as of 1.15 ALPHA 8
	TrayNotifications.Show("Dock mode no longer available", "Dock mode has been removed. Please use the Lock Position option instead.")
	return

	/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
	GUI_Trades_V2.Use_DockMode()
	Tray_ToggleLockPosition("Check")
	Declare_LocalSettings()
	trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.ModeDockEnabled_Msg, "%cycleDock%", PROGRAM.TRANSLATIONS.TrayMenu.CycleDock)
	TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ModeDockEnabled_Title, trayMsg)
	*/
}
Tray_CycleDock() {
	/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
	GUI_Trades_V2.DockMode_Cycle()
	*/
}
Tray_ToggleClickthrough() {
	global PROGRAM, GuiSettings_Controls

	GUI_Settings.TabSettingsMain_ToggleClickthroughCheckbox()
	toggle := PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive
	Menu, Tray,% toggle="True"?"Check":"Uncheck",% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
}
Tray_ToggleLockPosition(toggle="") {
	global PROGRAM

	if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
	|| (toggle = "Uncheck") {
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "False"
		Save_LocalSettings()
		Menu, Tray, Uncheck,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
	}
	else if ( (toggle = "") || (toggle = A_ThisMenuItem) ) && (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False")
	|| (toggle = "Check") {
		PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked := "True"
		Save_LocalSettings()
		Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
	}
}
Tray_ResetPosition() {
	Tray_ModeWindow()
}