/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Companion																														*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasatodev/POE-Trades-Companion/																							*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

; #Warn LocalSameAsGlobal, StdOut
; #ErrorStdOut
#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

OnExit("Exit")

DetectHiddenWindows, Off
FileEncoding, UTF-8 ; Cyrilic characters
SetWinDelay, 0
ListLines, Off
SetTitleMatchMode("RegEx", "Fast")

; Basic tray menu
if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
	Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
Menu,Tray,Tip,POE Trades Companion
Menu,Tray,NoStandard
Menu,Tray,Add,Tool is loading..., DoNothing
Menu,Tray,Disable,Tool is loading...
Menu,Tray,Add,GitHub,Tray_GitHub
Menu,Tray,Add
Menu,Tray,Add,Reload,Tray_Reload
Menu,Tray,Add,Close,Tray_Exit
Menu,Tray,Icon
; Left click
OnMessage(0x404, "AHK_NOTIFYICON") 

Hotkey, IfWinActive,[a-zA-Z0-9_] ahk_group POEGameGroup
Hotkey, ^RButton, StackClick

Hotkey, IfWinActive,% "ahk_pid " DllCall("GetCurrentProcessId")

; try {
	Start_Script()
; }
; catch e {
; 	MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
;         . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
; }
Return

f5::reload


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Cancel_AutoWhisper() {
	global PROGRAM, AUTOWHISPER_CANCEL, AUTOWHISPER_WAITKEYUP
	if (AUTOWHISPER_WAITKEYUP) {
		AUTOWHISPER_CANCEL := True
		ShowToolTip(PROGRAM.NAME "`nEasy whisper canceled.")
	}
}  

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Start_Script() {

	global DEBUG 							:= {} ; Debug values
	global PROGRAM 							:= {} ; Specific to the program's informations
	global GAME								:= {} ; Specific to the game config files
	global RUNTIME_PARAMETERS 				:= {}

	global Stats_TradeCurrencyNames 		:= {} ; Abridged currency names from poe.trade
	global Stats_RealCurrencyNames 			:= {} ; All currency full names

	global MyDocuments
	scriptStartTime := A_TickCount

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Handle_CmdLineParameters() 		; RUNTIME_PARAMETERS
	Load_DebugJSON()

	MyDocuments 					:= (RUNTIME_PARAMETERS.MyDocuments)?(RUNTIME_PARAMETERS.MyDocuments):(A_MyDocuments)

	; Set global - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.NAME					:= "POE Trades Companion"
	PROGRAM.VERSION 				:= "1.15.BETA_9993" ; code on par with 1.15.BETA_9993
	PROGRAM.IS_BETA					:= IsContaining(PROGRAM.VERSION, "beta")?"True":"False"
	PROGRAM.ALPHA					:= "Discord ALPHA 11"

	PROGRAM.GITHUB_USER 			:= "lemasatodev"
	PROGRAM.GITHUB_REPO 			:= "POE-Trades-Companion"
	PROGRAM.GITHUB_BRANCH			:= PROGRAM.IS_BETA ? "dev" : "master"

	PROGRAM.MAIN_FOLDER 			:= MyDocuments "\lemasatodev\" PROGRAM.NAME
	PROGRAM.LOGS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Logs"
	PROGRAM.TEMP_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Temp"
	PROGRAM.DATA_FOLDER				:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Data":"\data")
	PROGRAM.SFX_FOLDER 				:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\SFX":"\resources\sfx")
	PROGRAM.SKINS_FOLDER 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Skins":"\resources\skins")
	PROGRAM.FONTS_FOLDER 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Fonts":"\resources\fonts")
	PROGRAM.IMAGES_FOLDER			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Images":"\resources\imgs")
	PROGRAM.ICONS_FOLDER			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Icons":"\resources\icons")
	PROGRAM.TRANSLATIONS_FOLDER		:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Translations":"\resources\translations")
	PROGRAM.CURRENCY_IMGS_FOLDER	:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\CurrencyImages":"\resources\currency_imgs")
	PROGRAM.CHEATSHEETS_FOLDER		:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\Cheatsheets":"\resources\cheatsheets")
	PROGRAM.AUTOHOTKEY_EXECUTABLE 	:= A_IsCompiled ? "" : (A_ScriptDir "\resources\AutoHotKey.exe")

	prefsFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Preferences"):("Preferences")
	sellBackupFileName 				:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Sell_Trades_Backup"):("Sell_Trades_Backup")
	buyBackupFileName 				:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_Trades_Backup"):("Buy_Trades_Backup")
	tradesSellHistoryFileName 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Sell_History"):("Sell_History")
	tradesBuyHistoryFileName 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_History"):("Buy_History")
	tradesSellHistoryFileNameOld 	:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_History"):("Trades_History")
	tradesBuyHistoryFileNameOld 	:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_History"):("Buy_History")
	PROGRAM.FONTS_SETTINGS_FILE		:= PROGRAM.FONTS_FOLDER "\Settings.ini"
	PROGRAM.SETTINGS_FILE			:= PROGRAM.MAIN_FOLDER "\" prefsFileName ".json"
	PROGRAM.SETTINGS_FILE_OLD		:= PROGRAM.MAIN_FOLDER "\" prefsFileName ".ini"
	PROGRAM.LOGS_FILE 				:= PROGRAM.LOGS_FOLDER "\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "h" A_Min "m" A_Sec "s.txt"
	PROGRAM.CHANGELOG_FILE 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog.txt":"\resources\changelog.txt")
	PROGRAM.CHANGELOG_FILE_BETA 	:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog_beta.txt":"\resources\changelog_beta.txt")
	PROGRAM.TRADES_SELL_HISTORY_FILE 		:= PROGRAM.MAIN_FOLDER "\" tradesSellHistoryFileName ".json"
	PROGRAM.TRADES_SELL_HISTORY_FILE_OLD 	:= PROGRAM.MAIN_FOLDER "\" tradesSellHistoryFileNameOld ".ini"
	PROGRAM.TRADES_BUY_HISTORY_FILE			:= PROGRAM.MAIN_FOLDER "\" tradesBuyHistoryFileName ".json"
	PROGRAM.TRADES_BUY_HISTORY_FILE_OLD 	:= PROGRAM.MAIN_FOLDER "\" tradesBuyHistoryFileNameOld ".ini"
	PROGRAM.TRADES_SELL_BACKUP_FILE	:= PROGRAM.MAIN_FOLDER "\" sellBackupFileName ".json"
	PROGRAM.TRADES_BUY_BACKUP_FILE	:= PROGRAM.MAIN_FOLDER "\" buyBackupFileName ".json"
	PROGRAM.TRADING_LEAGUES_JSON	:= PROGRAM.DATA_FOLDER "\tradingLeagues.json"

	PROGRAM.NEW_FILENAME			:= PROGRAM.MAIN_FOLDER "\POE-TC-NewVersion.exe"
	PROGRAM.UPDATER_FILENAME 		:= PROGRAM.MAIN_FOLDER "\POE-TC-Updater.exe"
	PROGRAM.LINK_UPDATER 			:= "https://raw.githubusercontent.com/" PROGRAM.GITHUB_USER "/" PROGRAM.GITHUB_REPO "/" PROGRAM.GITHUB_BRANCH "/Updater_v2.exe"
	PROGRAM.LINK_CHANGELOG 			:= "https://raw.githubusercontent.com/" PROGRAM.GITHUB_USER "/" PROGRAM.GITHUB_REPO "/" PROGRAM.GITHUB_BRANCH "/resources/changelog.txt"

	PROGRAM.CURL_EXECUTABLE			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\curl.exe":"\lib\third-party\curl.exe")

	PROGRAM.LINK_REDDIT 			:= "https://www.reddit.com/user/lemasatodev/submitted/"
	PROGRAM.LINK_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	PROGRAM.LINK_GITHUB 			:= "https://github.com/lemasatodev/POE-Trades-Companion"
	PROGRAM.LINK_SUPPORT 			:= "https://www.paypal.me/masato/"
	PROGRAM.LINK_DISCORD 			:= "https://discord.gg/UMxqtfC"

	GAME.MAIN_FOLDER 				:= MyDocuments "\my games\Path of Exile"
	GAME.INI_FILE 					:= GAME.MAIN_FOLDER "\production_Config.ini"
	GAME.INI_FILE_COPY 		 		:= PROGRAM.MAIN_FOLDER "\production_Config.ini"
	GAME.EXECUTABLES 				:= "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe,PathOfExile_KG.exe,PathOfExile_x64_KG.exe,PathOfExileEGS.exe,PathOfExile_x64EGS.exe"
	GAME.LEAGUES		 			:= []

	PROGRAM.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% PROGRAM.MAIN_FOLDER

	if !(RUNTIME_PARAMETERS.IsRanThroughBundledAhkExecutable) {
		asAdminOrNot := RUNTIME_PARAMETERS.SkipAdmin || DEBUG.SETTINGS.skip_admin ? False : True
		ReloadWithParams(" /IsRanThroughBundledAhkExecutable /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdminOrNot)
	}

	; Create local directories - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	directories := PROGRAM.MAIN_FOLDER "`n" PROGRAM.SFX_FOLDER "`n" PROGRAM.LOGS_FOLDER "`n" PROGRAM.SKINS_FOLDER
	. "`n" PROGRAM.FONTS_FOLDER "`n" PROGRAM.IMAGES_FOLDER "`n" PROGRAM.DATA_FOLDER "`n" PROGRAM.ICONS_FOLDER
	. "`n" PROGRAM.TEMP_FOLDER "`n" PROGRAM.TRANSLATIONS_FOLDER "`n" PROGRAM.CURRENCY_IMGS_FOLDER "`n" PROGRAM.CHEATSHEETS_FOLDER

	Loop, Parse, directories, `n, `r
	{
		if (!InStr(FileExist(A_LoopField), "D")) {
			AppendtoLogs("Local directory non-existent. Creating: """ A_LoopField """")
			FileCreateDir, % A_LoopField
			if (ErrorLevel && A_LastError) {
				AppendtoLogs("Failed to create local directory. System Error Code: " A_LastError ". Path: """ A_LoopField """")
			}
		}
	}

	if (RUNTIME_PARAMETERS.CreateRelease)
		CreateRelease()
	if (RUNTIME_PARAMETERS.CreateZip)
		CreateZipRelease()
	if (RUNTIME_PARAMETERS.CompileExecutable)
		CompileExe()
	if (RUNTIME_PARAMETERS.CreateRelease || RUNTIME_PARAMETERS.CreateZip || RUNTIME_PARAMETERS.CompileExecutable)
		ExitApp
	
	if (RUNTIME_PARAMETERS.UpdateDataFiles)
		UpdateDataFiles()
	if (RUNTIME_PARAMETERS.UpdateTranslations)
		UpdateTranslations()
	

	; Extracting assets
	if !(DEBUG.settings.skip_assets_extracting)
		AssetsExtract()

	; Creating settings and file
	; LocalSettings_CreateFileIfNotExisting()
	; LocalSettings_VerifyEncoding()

	Delete_OldLogsFile()
	Create_LogsFile()

	; Loading global GDIP 
	GDIP_Startup()
	
	; Loading fonts
	LoadFonts() 

	; Closing previous instance
	if (!RUNTIME_PARAMETERS.NewInstance)
		Close_PreviousInstance()
	TrayRefresh()

	; More local settings stuff
	Set_LocalSettings()
	Update_LocalSettings()
	Declare_LocalSettings()
	PROGRAM.TRANSLATIONS := GetTranslations(PROGRAM.SETTINGS.GENERAL.Language)
	Declare_SkinAssetsAndSettings()

	; Game executables groups
	global POEGameArr := []
	Loop, Parse,% GAME.EXECUTABLES, % ","
		POEGameArr.Push(A_LoopField)
	global POEGameList := GAME.EXECUTABLES	
	for nothing, executable in POEGameArr
		GroupAdd, POEGameGroup, ahk_exe %executable%

	; Warning stuff
	if !FileExist(PROGRAM.TRANSLATIONS_FOLDER "\english.json") {
		Run,% PROGRAM.LINK_GITHUB "/releases"
		MsgBox(4096+48,PROGRAM.NAME " - IMPORTANT"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "Unable to find translation files."
		. "`n" "The GitHub releases page has been opened, please re-download the application."
		. "`n" "Details are included on the post of 1.15.BETA_1 release."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
	requiredVer := "1.1.30.03", unicodeOrAnsi := A_IsUnicode?"Unicode":"ANSI", 32or64bits := A_PtrSize=4?"32bits":"64bits"
	if (!A_IsUnicode) {
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48, "POE Trades Companion - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application isn't compatible with ANSI versions of AutoHotKey."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "Please download and install AutoHotKey Unicode 32/64 or use the compiled executable."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
	if (A_AhkVersion < "1.1") ; Smaller than 1.1.00.00
	|| (A_AhkVersion < "1.1.00.00")
	|| (A_AhkVersion < requiredVer) { ; Smaller than required
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48,PROGRAM.NAME " - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application requires AutoHotKey v" requiredVer " or higher."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "AutoHotKey website has been opened, please update to the latest version."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
	if (A_AhkVersion >= "2.0")
	|| (A_AhkVersion >= "2.0.00.00") { ; Higher or equal to 2.0.00.00
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48,PROGRAM.NAME " - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application isn't compatible with AutoHotKey v2."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "AutoHotKey v" requiredVer " or higher is required."
		. "`n" "Please downgrade, or compile the executable with v" requiredVer "."
		. "`n" "AutoHotKey website has been opened, please update to the latest version."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}

	; Loading currency data for stats gui
	PROGRAM.DATA := {}
	FileRead, allCurrency,% PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	Loop, Parse, allCurrency, `n, `r
	{
		if (A_LoopField)
			currencyList .= A_LoopField ","
	}
	StringTrimRight, currencyList, currencyList, 1 ; Remove last comma
	PROGRAM.DATA.CURRENCY_LIST := currencyList
	FileRead, poeTradeCurrencyData,% PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
    PROGRAM.DATA.POETRADE_CURRENCY_DATA := JSON_Load(poeTradeCurrencyData), poeTradeCurrencyData := ""

	; Loading maps data for item grid
	FileRead, mapsData,% PROGRAM.DATA_FOLDER "\mapsData.json"
	PROGRAM.DATA.MAPS_DATA := JSON_Load(mapsData)
	FileRead, uniqueMapsList,% PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	PROGRAM.DATA.UNIQUE_MAPS_LIST := uniqueMapsList

	; Loading whisper regexes data
	FileRead, whisperRegexes,% PROGRAM.DATA_FOLDER "\tradingRegexes.json"
	PROGRAM.DATA.TRADING_REGEXES := JSON_Load(whisperRegexes)

	; Game settings
	Declare_GameSettings(gameSettings)
	GGG_API_Get_ActiveTradingLeagues()

	if RegExMatch(GetKeyboardLayout(), "i)^(0xF002|0xF01B|0xF01A|0xF01C0809|0xF01C0409).*")
		TrayNotifications.Show(PROGRAM.NAME, "Dvorak keyboard layout detected, scancode fix applied.")
	PROGRAM.SCANCODES := GetScanCodes()

	; Update checking
	if !(DEBUG.settings.skip_update_check) {
		periodicUpdChk := PROGRAM.SETTINGS.UPDATE.CheckForUpdatePeriodically
		updChkTimer := (periodicUpdChk="OnStartOnly")?(0)
			: (periodicUpdChk="OnStartAndEveryFiveHours")?(18000000)
			: (periodicUpdChk="OnStartAndEveryDay")?(86400000)
			: (0)
		
		if (updChkTimer)
			SetTimer, UpdateCheck, %updChkTimer%

		if (DEBUG.settings.force_update_check)
			UpdateCheck(checkType:="forced")
		else {
			if (A_IsCompiled)
				UpdateCheck(checktype:="on_start")
			else
				UpdateCheck(checkType:="on_start", "box")
		}
	}

	if (PROGRAM.SETTINGS.GENERAL.AskForLanguage = "True")
		GUI_ChooseLang.WaitForLang()
	
	TrayMenu()
	EnableHotkeys()

	GUI_Intercom.Create()
	; ImageButton_TestDelay()

	; GUI_Trades_V2.Create(, buyOrSell:="Sell", stackOrTabs:=PROGRAM.SETTINGS.SELL_INTERFACE.Mode)
	; GUI_Trades_V2.Create(, buyOrSell:="Buy", stackOrTabs:=PROGRAM.SETTINGS.BUY_INTERFACE.Mode)
	; GUI_Trades_V2.LoadBackup("Sell")
	; GUI_Trades_V2.LoadBackup("Buy")

	; Parse debug msgs
	if (DEBUG.settings.use_chat_logs) {
		Loop % DEBUG.chatlogs.MaxIndex()
			Parse_GameLogs(DEBUG.chatlogs[A_Index])
	}
	Monitor_GameLogs()

	if !WinExist("ahk_id " GUI_Settings.sGUI.Handle)
		GUI_Settings.Create()
	if (DEBUG.settings.open_settings_gui)
		GUI_Settings.Show()

	if (DEBUG.settings.open_mystats_gui)
		GUI_MyStats.Show()

	if (PROGRAM.SETTINGS.PROGRAM.Show_Changelogs = True) 
	|| (PROGRAM.SETTINGS.GENERAL.ShowChangelog = "True") {
		PROGRAM.SETTINGS.Delete("PROGRAM") ; old section
		PROGRAM.SETTINGS.GENERAL.ShowChangelog := "False"
		Save_LocalSettings()
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Msg, "%version%", PROGRAM.VERSION)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Title, trayMsg)
		GUI_Settings.Show("Updating")
	}

	; Shellmessage, after all gui are created	
	ShellMessage_Enable()
	WinGet, activeHwnd, ID, A
	ShellMessage(4, activeHwnd)

	; Clipboard change funcs + refresh list
	OnClipboardChange("OnClipboardChange_Func")
	SetTimer, GUI_Trades_V2_Sell_RefreshIgnoreList, 35000 ; 35s

	; Showing tray notification
	trayMsg := PROGRAM.TRANSLATIONS.TrayNotifications.AppLoaded_Msg
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency <= 20)
		trayMsg .= "`n`n" . StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.AppLoadedTransparency_Msg, "%number%", PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency)
	TrayNotifications.Show(PROGRAM.NAME, trayMsg)

	; msgbox % A_TickCount-scriptStartTime
	AppendtoLogs("Took " A_TickCount-scriptStartTime " to start the script completely.")
}

DoNothing:
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Include %A_ScriptDir%\lib\
#Include AssetsExtract.ahk
#Include Class_GUI.ahk
#Include Class_INI.ahk
#Include CmdLineParameters.ahk
#Include CompileAhk2Exe.ahk
#Include Debug.ahk
#Include EasyFuncs.ahk
#Include Exit.ahk
#Include FileInstall.ahk
#Include Game.ahk
#Include Game_File.ahk
#Include GGG_API.ahk
#Include GitHubAPI.ahk
#Include GUI_CheatSheet.ahk
#Include GUI_ImportPre1dot13Settings.ahk
#Include GUI_SimpleWarn.ahk
#Include GUI_ChooseInstance.ahk
#Include GUI_ChooseLang.ahk
#Include GUI_ItemGrid.ahk
#Include GUI_MyStats.ahk
#Include GUI_SetHotkey.ahk
#Include GUI_Settings.ahk
#Include GUI_TabbedTradesCounter.ahk
#Include GUI_Trades.ahk
#Include Hotkeys.ahk
#Include Intercom_Receiver.ahk
#Include Local_File.ahk
#Include Logs.ahk
#Include ManageFonts.ahk
#Include Misc.ahk
#Include OnClipboardChange.ahk
#Include PoeTrade.ahk
#Include PushBullet.ahk
#Include Release.ahk
#Include Reload.ahk
#Include SetFileInfos.ahk
#Include ShellMessage.ahk
#Include ShowToolTip.ahk
#Include SplashText.ahk
#Include StackClick.ahk
#Include Translations.ahk
#Include TrayMenu.ahk
#Include TrayRefresh.ahk
#Include Updating.ahk
#Include WM_Messages.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include AddToolTip.ahk
#Include ChooseColor.ahk
#Include class_EasyIni.ahk
#Include Class_ImageButton.ahk
#Include Class_OD_Colors.ahk
#Include Clip.ahk
#Include cURL.ahk
#Include CSV.ahk
#Include Download.ahk
#Include Extract2Folder.ahk
#Include FGP.ahk
#Include GDIP.ahk
#Include Get_ProcessInfos.ahk
#Include IEComObj.ahk
#Include JSON.ahk
#Include LV_SetSelColors.ahk
#Include SetEditCueBanner.ahk
#Include StdOutStream.ahk
#Include StringtoHex.ahk
#Include TilePicture.ahk
#Include UriEncode.ahk
#Include WinHttpRequest.ahk


if (A_IsCompiled) {
	#Include %A_ScriptDir%/FileInstall_Cmds.ahk
	Return
}

/*	H5auEc7KA0 (AllowClicksToPassThroughWhileInactive)
	1.15.BETA_xxx Trades Overhaul: Clickthrough only enabled if the interface is fully transparent.
	+ The buying interface will always be 100% transparent if there is no trades, effectively hidding it.
	+ The Toolbar has been moved to the Selling interface.
	These changes make accessing the toolbar much better.
*/

/*	jsZTTcBTWV (AutoMinimizeOnAllTabsClosed)
	1.15.BETA_xxx Trades Overhaul: Interface always minimize itself when the last tab is closed.
	This change is due to the interface header being a toolbar.
*/

/* BdO6CY5Oov
	Getting rid of Dock mode completely as of 1.15 ALPHA 8
	Window mode will now be default - Dock was always buggy and unreliable and "Lock Position" with Window is better anyways
*/
