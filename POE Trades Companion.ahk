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

Hotkey, IfWinActive, ahk_group POEGameGroup
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

	global LEAGUES 							:= [] ; Trading leagues
	global MyDocuments

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Handle_CmdLineParameters() 		; RUNTIME_PARAMETERS
	Load_DebugJSON()

	MyDocuments 					:= (RUNTIME_PARAMETERS.MyDocuments)?(RUNTIME_PARAMETERS.MyDocuments):(A_MyDocuments)

	; Set global - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.NAME					:= "POE Trades Companion"
	PROGRAM.VERSION 				:= "1.16"
	PROGRAM.IS_BETA					:= IsContaining(PROGRAM.VERSION, "beta")?"True":"False"

	PROGRAM.GITHUB_USER 			:= "lemasatodev"
	PROGRAM.GITHUB_REPO 			:= "POE-Trades-Companion"
	PROGRAM.GITHUB_BRANCH			:= "master"

	PROGRAM.MAIN_FOLDER 			:= MyDocuments "\lemasato\" PROGRAM.NAME
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

	prefsFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Preferences.ini"):("Preferences.ini")
	backupFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_Backup.ini"):("Trades_Backup.ini")
	tradesHistoryFileName 			:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_History.ini"):("Trades_History.ini")
	tradesHistoryBuyFileName 		:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Buy_History.ini"):("Buy_History.ini")
	PROGRAM.FONTS_SETTINGS_FILE		:= PROGRAM.FONTS_FOLDER "\Settings.ini"
	PROGRAM.INI_FILE 				:= PROGRAM.MAIN_FOLDER "\" prefsFileName
	PROGRAM.LOGS_FILE 				:= PROGRAM.LOGS_FOLDER "\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "h" A_Min "m" A_Sec "s.txt"
	PROGRAM.CHANGELOG_FILE 			:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog.txt":"\resources\changelog.txt")
	PROGRAM.CHANGELOG_FILE_BETA 	:= (A_IsCompiled?PROGRAM.MAIN_FOLDER:A_ScriptDir) . (A_IsCompiled?"\changelog_beta.txt":"\resources\changelog_beta.txt")
	PROGRAM.TRADES_HISTORY_FILE 	:= PROGRAM.MAIN_FOLDER "\" tradesHistoryFileName
	PROGRAM.TRADES_HISTORY_BUY_FILE	:= PROGRAM.MAIN_FOLDER "\" tradesHistoryBuyFileName
	
	PROGRAM.TRADES_BACKUP_FILE		:= PROGRAM.MAIN_FOLDER "\" backupFileName

	PROGRAM.NEW_FILENAME			:= PROGRAM.MAIN_FOLDER "\POE-TC-NewVersion.exe"
	PROGRAM.UPDATER_FILENAME 		:= PROGRAM.MAIN_FOLDER "\POE-TC-Updater.exe"
	PROGRAM.LINK_UPDATER 			:= "https://raw.githubusercontent.com/lemasatodev/POE-Trades-Companion/master/Updater_v2.exe"
	PROGRAM.LINK_CHANGELOG 			:= "https://raw.githubusercontent.com/lemasatodev/POE-Trades-Companion/master/resources/changelog.txt"

	PROGRAM.CURL_EXECUTABLE			:= PROGRAM.MAIN_FOLDER "\curl.exe"

	PROGRAM.LINK_REDDIT 			:= "https://www.reddit.com/user/lemasatodev/submitted/"
	PROGRAM.LINK_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	PROGRAM.LINK_GITHUB 			:= "https://github.com/lemasatodev/POE-Trades-Companion"
	PROGRAM.LINK_SUPPORT 			:= "https://www.paypal.me/masato/"
	PROGRAM.LINK_DISCORD 			:= "https://discord.gg/UMxqtfC"

	GAME.MAIN_FOLDER 				:= MyDocuments "\my games\Path of Exile"
	GAME.INI_FILE 					:= GAME.MAIN_FOLDER "\production_Config.ini"
	GAME.INI_FILE_COPY 		 		:= PROGRAM.MAIN_FOLDER "\production_Config.ini"
	GAME.EXECUTABLES 				:= "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe,PathOfExile_KG.exe,PathOfExile_x64_KG.exe,PathOfExileEGS.exe,PathOfExile_x64EGS.exe"
	GAME.CHALLENGE_LEAGUE 			:= "Ritual"
	GAME.STANDARD_LEAGUE_TRANS		:= {RUS:["Стандарт","Одна жизнь"], KOR:["스탠다드","하드코어"], TWN:["標準模式","專家模式"]} ; STD, HC
	GAME.CHALLENGE_LEAGUE_TRANS		:= {RUS:["Ритуал","Ритуал Одна жизнь"], KOR:["의식","하드코어 의식"], TWN:["劫盜聯盟","劫盜聯盟（專家）"]} ; Rest don't have translations. Translated whispers suck and are inconsistent

	PROGRAM.SETTINGS.SUPPORT_MESSAGE 	:= "@%buyerName% " PROGRAM.NAME ": view-thread/1755148"

	PROGRAM.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% PROGRAM.MAIN_FOLDER

	; Auto admin reload - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	if (!A_IsAdmin && !RUNTIME_PARAMETERS.SkipAdmin && !DEBUG.SETTINGS.skip_admin) {
		ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
	}

	; Game executables groups - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	global POEGameArr := []
	Loop, Parse,% GAME.EXECUTABLES, % ","
		POEGameArr.Push(A_LoopField)
	global POEGameList := GAME.EXECUTABLES	
	for nothing, executable in POEGameArr
		GroupAdd, POEGameGroup, ahk_exe %executable%

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

	; Logs files
	Create_LogsFile()
	Delete_OldLogsFile()

	if (!RUNTIME_PARAMETERS.NewInstance)
		Close_PreviousInstance()
	TrayRefresh()

	if !(DEBUG.settings.skip_assets_extracting)
		AssetsExtract()

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

	; Currency names for stats gui - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.DATA := {}
	FileRead, allCurrency,% PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	Loop, Parse, allCurrency, `n, `r
	{
		if (A_LoopField)
			currencyList .= A_LoopField ","
	}
	StringTrimRight, currencyList, currencyList, 1 ; Remove last comma
	PROGRAM.DATA.CURRENCY_LIST := currencyList

	FileRead, JSONFile,% PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
    PROGRAM["DATA"]["POETRADE_CURRENCY_DATA"] := JSON.Load(JSONFile)

	FileRead, gggCurrency,% PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	PROGRAM["DATA"]["POEDOTCOM_CURRENCY_DATA"] := JSON.Load(gggCurrency)

	; Maps data for ITemGrid - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	FileRead, mapsData,% PROGRAM.DATA_FOLDER "\mapsData.json"
	PROGRAM.DATA.MAPS_DATA := JSON.Load(mapsData)

	FileRead, uniqueMapsList,% PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	PROGRAM.DATA.UNIQUE_MAPS_LIST := uniqueMapsList

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	GDIP_Startup()

	; Fonts related
	LoadFonts() 

	; Import old settings if accepted
	oldIni := MyDocuments "\AutoHotkey\POE Trades Companion\Preferences.ini"
	if FileExist(oldIni) {
		hasAsked := INI.Get(PROGRAM.INI_File, "GENERAL", "HasAskedForImport")
		INI.Set(PROGRAM.INI_File, "GENERAL", "HasAskedForImport", "True")
		if (hasAsked != "True") {
			AppendToLogs("Showing import pre1.13 settings GUI.")
			GUI_ImportPre1dot13Settings.Show()
			global GuiImportPre1dot13Settings
			WinWait,% "ahk_id " GuiImportPre1dot13Settings.Handle
			WinWaitClose,% "ahk_id " GuiImportPre1dot13Settings.Handle
			AppendToLogs("Successfully closed pre1.13 settings GUI.")
		}
	}
	
	; Local settings
	LocalSettings_VerifyEncoding()
	Set_LocalSettings()
	Update_LocalSettings()
	localSettings := Get_LocalSettings()
	Declare_LocalSettings(localSettings)
	PROGRAM.TRANSLATIONS := GetTranslations(PROGRAM.SETTINGS.GENERAL.Language)

	; Game settings
	gameSettings := Get_GameSettings()
	Declare_GameSettings(gameSettings)

	Declare_SkinAssetsAndSettings()

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

	Get_TradingLeagues() ; Getting leagues

	if (PROGRAM.SETTINGS.GENERAL.AskForLanguage = "True")
		GUI_ChooseLang.Show()
	
	TrayMenu()
	EnableHotkeys()

	; ImageButton_TestDelay()
	GUI_Intercom.Create()
	GUI_TradesMinimized.Create()
	Gui_Trades.Create()
	GUI_Trades.LoadBackup()
	GUI_TradesBuyCompact.Create()
	GUI_TradesBuyCompact.Show()

	; Parse debug msgs
	if (DEBUG.settings.use_chat_logs) {
		Loop % DEBUG.chatlogs.MaxIndex()
			Parse_GameLogs(DEBUG.chatlogs[A_Index])
	}
	Monitor_GameLogs()

	global GuiSettings
	if !WinExist("ahk_id " GuiSettings.Handle)
		Gui_Settings.Create()
	if (DEBUG.settings.open_settings_gui) {
		Gui_Settings.Show()
	}

	if (DEBUG.settings.open_mystats_gui) {
		GUI_MyStats.Show()
	}

	if (PROGRAM.SETTINGS.PROGRAM.Show_Changelogs = True) 
	|| (PROGRAM.SETTINGS.GENERAL.ShowChangelog = "True") {
		INI.Remove(PROGRAM.INI_FILE, "PROGRAM")
		INI.Set(PROGRAM.INI_FILE, "GENERAL", "ShowChangelog", "False")
		PROGRAM.SETTINGS.PROGRAM.Show_Changelogs := ""
		PROGRAM.SETTINGS.GENERAL.ShowChangelog := "False"
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Msg, "%version%", PROGRAM.VERSION)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateSuccessful_Title, trayMsg)
		GUI_Settings.Show("Misc Updating")
	}
	
	ShellMessage_Enable()
	OnClipboardChange("OnClipboardChange_Func")
	SetTimer, GUI_Trades_RefreshIgnoreList, 60000 ; One min

	trayMsg := PROGRAM.TRANSLATIONS.TrayNotifications.AppLoaded_Msg
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency <= 20)
		trayMsg .= "`n`n" . StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.AppLoadedTransparency_Msg, "%number%", PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency)
	if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
		trayMsg .= "`n`n" PROGRAM.TRANSLATIONS.TrayNotifications.AppLoadedClickthrough_Msg
	TrayNotifications.Show(PROGRAM.NAME, trayMsg)
}

DoNothing:
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Include %A_ScriptDir%\lib\

#Include Class_GUI.ahk
#Include Class_GUI_BetaTasks.ahk
#Include Class_GUI_CheatSheet.ahk
#Include Class_GUI_ImportPre1dot13Settings.ahk
#Include Class_GUI_SimpleWarn.ahk
#Include Class_Gui_ChooseInstance.ahk
#Include Class_GUI_ChooseLang.ahk
#Include Class_Gui_ItemGrid.ahk
#Include Intercom_Receiver.ahk
#Include Class_Gui_MyStats.ahk
#Include Class_Gui_Settings.ahk
#Include Class_Gui_Trades.ahk
#Include Class_Gui_TradesMinimized.ahk
#Include Class_GUI_TradesBuyCompact.ahk
#Include WM_Messages.ahk

#Include AssetsExtract.ahk
#Include Class_INI.ahk
#Include CmdLineParameters.ahk
#Include CompileAhk2Exe.ahk
#Include Debug.ahk
#Include EasyFuncs.ahk
#Include Exit.ahk
#Include FileInstall.ahk
#Include Game.ahk
#Include Game_File.ahk
#Include GitHubAPI.ahk
#Include Hotkeys.ahk
#Include Local_File.ahk
#Include Logs.ahk
#Include ManageFonts.ahk
#Include Misc.ahk
#Include OnClipboardChange.ahk
#Include PoeDotCom.ahk
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
#Include TrayNotifications.ahk
#Include TrayRefresh.ahk
#Include Updating.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include AddToolTip.ahk
#Include ChooseColor.ahk
#Include class_EasyIni.ahk
#Include Class_ImageButton.ahk
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
#Include WinHttpRequest.ahk


if (A_IsCompiled) {
	#Include %A_ScriptDir%/FileInstall_Cmds.ahk
	Return
}
