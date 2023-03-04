/*
	v2.2 (26 oct 2019)
		Detect JSON or INI + Improved code

	v2.1a (14 Aug 2018)
		Changed ini setting with section PROGRAM and key Show_Changelogs to GENERAL and ShowChangelog

	v2.1 (21 Dec 2017)
		Added Download() and DL_Progress()
		autohotkey.com/board/topic/17915-urldownloadtofile-progress/?p=584346

	v2.0.1 (27 Nov 2017)
		Fix: Only use FileDelete on .exe files.
		Fix: The FileName key from the ini file only stores the file name.
				Since the updater file is not always located in the same folder as the script,
				we retrieve the script path from the /File_Name* parameter then add this path to the variable retrieved from the FileName ini key.
*/
#NoEnv
#Persistent
#SingleInstance Force
#Warn LocalSameAsGlobal
OnExit("Exit_Func")

DetectHiddenWindows, Off
FileEncoding, UTF-8
ListLines, Off
SetWorkingDir, %A_ScriptDir%

Menu,Tray,Tip,lemasatodev updater
Menu,Tray,NoStandard
Menu,Tray,Add,Close,Exit_Func

Start_Script()
ExitApp
Return

Start_Script() {
	global PROGRAM := {}

	if (!A_IsAdmin) {
		ReloadWithParams("", getCurrentParams:=True, asAdmin:=True)
	}

	Handle_CommandLine_Parameters()
	Declare_LocalSettings()
	Close_Program_Instancies()
	
	; Downloading the new version
	Download(PROGRAM.DOWNLOAD_LINK, PROGRAM.FileFullPath)
	if (ErrorLevel) {
		MsgBox(4096+16, PROGRAM.NAME, "Download timed out or an error occured."
		. "`n" "Updating process canceled."
		. "`n"
		. "`n" "If this error keeps happening, try updating manually.")
		ExitApp
	}
	Sleep 10
	FileSetAttrib, -H,% PROGRAM.FileFullPath
	PROGRAM.SETTINGS.GENERAL.ShowChangelog := "True"
	PROGRAM.SETTINGS.GENERAL.JustUpdated := "True"
	Save_LocalSettings(PROGRAM.SETTINGS)
	Sleep 10
	Run,% PROGRAM.FileFullPath
}

Declare_LocalSettings(settingsObj="") {
	global PROGRAM

	if !IsObject(settingsObj) {
		settingsFile := PROGRAM.SETTINGS_FILE
		SplitPath, settingsFile, , , settingsFileExt

		if (settingsFileExt = "ini")
			PROGRAM.SETTINGS := class_EasyIni(settingsFile)
		else if (settingsFileExt = "json")
			PROGRAM.SETTINGS := JSON_Load(settingsFile)
		else {
			MsgBox(4096+16, PROGRAM.NAME, "Invalid file extension: " settingsFileExt "`nUpdating process canceled.")
			ExitApp
		}
	}
	else
		PROGRAM.SETTINGS := {}, PROGRAM.SETTINGS := ObjFullyClone(settingsObj)
}

Save_LocalSettings(settingsObj) {
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE
	SplitPath, settingsFile, fileName,  , settingsFileExt
	
	; Saving content into the settings file
	if (settingsFileExt = "json") {
		jsonText := JSON.Dump(settingsObj, "", "`t")
		hFile := FileOpen(settingsFile, "w", "UTF-8")
		hFile.Write(jsonText)
		hFile.Close()
	}
	else if (settingsFileExt = "ini") {
		settingsObj.Save()
	}

	Declare_LocalSettings(settingsObj)
}

Close_Program_Instancies() {
/*		Close running instances of the program.
		Delete the file, unless it's .ahk.
 */
 	global PROGRAM
	fileFullPath := PROGRAM.FileFullPath
	programPID := PROGRAM.SETTINGS.UPDATING.PID
	SplitPath, fileFullPath, fileName, fileFolder, fileExtension
	
	Process, Exist,% PROGRAM.SETTINGS.UPDATING.PID
	if (ErrorLevel) { ; Exists
		Process, Close,% programPID
		Process, WaitClose,% programPID
		Sleep 10
	}
	if (fileName = "exe") {
		FileMove,% fileFullPath,% fileFolder "\" fileName ".bak", 1
		Sleep 10
	}
	Sleep 10
}

Handle_CommandLine_Parameters() {
	global 0
	global PROGRAM

	Loop, %0% {
		param := %A_Index%
		if RegExMatch(param, "iO)/NAME=(.*)", found)
			PROGRAM.NAME := found.1, found := ""
		else if RegExMatch(param, "iO)/FileFullPath=(.*)", found) || RegExMatch(param, "iO)/File_Name=(.*)", found)
			PROGRAM.FileFullPath := found.1, found := ""
		else if RegExMatch(param, "iO)/LOCAL_FOLDER=(.*)", found)
			PROGRAM.LOCAL_FOLDER := found.1, found := ""
		else if RegExMatch(param, "iO)/SETTINGS_FILE=(.*)", found) || RegExMatch(param, "iO)/Ini_File=(.*)", found)
			PROGRAM.SETTINGS_FILE := found.1, found := ""
		else if RegExMatch(param, "iO)/DOWNLOAD_LINK=(.*)", found) || RegExMatch(param, "iO)/NewVersion_Link=(.*)", found)
			PROGRAM.DOWNLOAD_LINK := found.1, found := ""
		else if RegExMatch(param, "iO)/cURL_Executable=(.*)", found)
			PROGRAM.CURL_EXECUTABLE := found.1, found := ""
	}
}

Get_CmdLineParameters() {
	global 0
	
	Loop, %0% {
		param := ""
		param := RegExReplace(%A_Index%, "(.*?)=(.*)", "$1=""$2""") ; Add quotes to parameters. In case any contain a space

		if (param)
			params .= A_Space . param
	}

	return params
}

ReloadWithParams(params, getCurrentParams=False, asAdmin=False) {
	if (getCurrentParams) {
		params .= " " Get_CmdLineParameters()
	}

	if (asAdmin)
		runMode := "RunAs"
	else runMode := ""

	Sleep 10
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,runMode,str,(A_IsCompiled ? A_ScriptFullPath
	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
	Sleep 10000
}

Exit_Func(ExitReason, ExitCode) {
	if ExitReason not in Reload
		ExitApp
}

#Include %A_ScriptDir%\lib\
#Include EasyFuncs.ahk
#Include Logs.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include class_EasyIni.ahk
#Include cURL.ahk
#Include Download.ahk
#Include JSON.ahk
#Include StdOutStream.ahk
#Include WinHttpRequest.ahk