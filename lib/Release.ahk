CompileExe() {
	global PROGRAM

	if (A_IsCompiled) {
		MsgBox(4096+16, PROGRAM.NAME, "Cannot create release while using the executable. This parameter can only be used with the .ahk script.")
		ExitApp
	}

	_coordMode := CoordMode()
	CoordMode({"ToolTip":"Screen"})
	
	ToolTip, Compiling executable, 0, 0
	upxFullPath := A_ScriptDir "\lib\third-party\upx.exe"
	CompileFile(A_ScriptDir "\POE Trades Companion.ahk", A_ScriptDir "\POE Trades Companion.exe")
	cmds = 
	(
	@echo off
	cd %A_ScriptDir%
	"%upxFullPath%" "POE Trades Companion.exe"
	)
	if !FileExist(upxFullPath)
		MsgBox(4096+16, PROGRAM.NAME, "upx.exe missing in " upxFullPath ". Executable will not be compiled.")
	else
		RunWaitMany(cmds)

	CoordMode(_coordMode)
}

UpdateDataFiles() {
	global PROGRAM

	_coordMode := CoordMode()
	CoordMode({"ToolTip":"Screen"})

	; Data files
	ToolTip, Updating data files, 0, 0
	ToolTip, Updating data files`nPoeTrade, 0, 0
	PoeTrade_GenerateCurrencyData()

	ToolTip, Updating data files`nPoeDotCom, 0, 0
	GGG_API_CreateDataFiles()

	; League names file
	ToolTip, Updating league names file, 0, 0
	GGG_API_Generate_TradingLeaguesJson()

	CoordMode(_coordMode)
}

UpdateTranslations() {
	global PROGRAM

	_coordMode := CoordMode()
	CoordMode({"ToolTip":"Screen"})

	ToolTip, Updating translation files, 0, 0
	; First loading eng json and re-saving it to make it ordered
	FileRead, engJSON,% PROGRAM.TRANSLATIONS_FOLDER "\english.json"
	engJSON := JSON_Load(engJSON)
	jsonText := JSON_Dump(engJSON, dontReplaceUnicode:=True)
	hFile := FileOpen(A_ScriptDir "\resources\translations\english.json", "w", "UTF-8")
	hFile.Write(jsonText)
	hFile.Close()

	; Then going through other languages and adding non-existent keys
	Loop, Files,% PROGRAM.TRANSLATIONS_FOLDER "\*.json"
	{
		if (A_LoopFileName="english.json")
			Continue
		else if !Is_Json(A_LoopFileFullPath) {
			MsgBox(4096+16, PROGRAM.NAME, A_ThisFunc "(): Building translation files. This file is not JSON format. It will be ignored." A_LoopFileFullPath)
			Continue
		}
		ToolTip, Updating translation files`n%A_LoopFileName%, 0 ,0

		thisLangJSON := JSON_Load(A_LoopFileFullPath)
		thisLangJSON := ObjReplace(engJSON, thisLangJSON)
		jsonText := JSON_Dump(thisLangJSON, dontReplaceUnicode:=True)

		hFile := FileOpen(A_LoopFileFullPath, "w", "UTF-8")
		hFile.Write(jsonText)
		hFile.Close()
	}

	CoordMode(_coordMode)
}

CreateRelease() {
	global PROGRAM

	if (A_IsCompiled) {
		MsgBox(4096+16, PROGRAM.NAME, "Cannot create release while using the executable. This parameter can only be used with the .ahk script.")
		ExitApp
	}
	
	UpdateTranslations()
	UpdateDataFiles()
	; CompileExe() - Disabled, no longer including exes on the repo
	CreateZipRelease()
}

CreateZipRelease() {
	global PROGRAM

	EnvGet, ProgramW6432, ProgramW6432
	_ProgramFiles := (ProgramW6432)?(ProgramW6432):(A_ProgramFiles)
	7zip := _ProgramFiles "\7-Zip\7z.exe"

	if !FileExist(7zip) {
		MsgBox(4096+16, PROGRAM.NAME, "7zip is missing in " 7zip ". Zip release will not be created.")
		return
	}
	if !RunWaitMany("git --version") {
		MsgBox(4096+16, PROGRAM.NAME, "Failed to retrieve installed git version. Zip release will not be created.")
		return
	}

	_coordMode := CoordMode()
	CoordMode({"ToolTip":"Screen"})

	; Creating ZIP archive
	ToolTip, Building zip release based on active git branch, 0, 0
	ver := PROGRAM.VERSION
	ver := StrReplace(ver, ".", "-")
	ver := StrReplace(ver, " ", "-")
	zipFullPath := A_ScriptDir "\POE-Trades-Companion-AHK-" ver ".zip"
	if FileExist(zipFullPath)
		FileDelete(zipFullPath)
	cmds = 
	(
	@echo off
	cd "%A_ScriptDir%"
	git archive -o "%zipFullPath%" HEAD 
	)
	RunWaitMany(cmds)

	; Removing various unnecessary files/folders
	toDelete := [".gitignore",".gitattributes","_ConvertRelease.ahk","VerPatch.exe","Updater_V2.exe","Updater_V2.ahk","Updater.ahk","Updater.exe","README.MD","POE Trades Companion.exe","ISSUE_TEMPLATE.md","Debug.json", "others", "screenshots", "resources/fonts/fontreg.exe","resources/fonts/enumfonts.vbs"]
	Loop % toDelete.Count()
		deleteCmds .= "`n" """" 7zip """ d """ zipFullPath """ """ toDelete[A_Index] """"
	cmds = 
	(
	@echo off
	cd %A_ScriptDir%
	%deleteCmds%
	)
	RunWaitMany(cmds)

	CoordMode(_coordMode)
}

CompileFile(source, dest, fileDesc="NONE", fileVer="NONE", fileCopyright="NONE") {
    Run_Ahk2Exe(source, ,A_ScriptDir "\resources\icon.ico")

	_coordMode := CoordMode()
	CoordMode({"ToolTip":"Screen"})

	if (fileDesc != "NONE" || fileVer != "NONE" || fileCopyright != "NONE") {
		StringReplace fileVer,fileVer,`.,`.,UseErrorLevel
		Loop % 3-ErrorLevel {
			fileVer .= ".0"
		}

		Set_FileInfos(dest, fileVer, fileDesc, fileCopyright)
		destVer := FGP_Value(dest, 167) ; 167 = Ver
		destDesc := FGP_Value(dest, 34) ; 34 = Desc
		destCpyR := FGP_Value(dest, 25) ; 25 = Copyright
		while (destVer != fileVer) {
			ToolTip,% "Attempt #" A_Index+1
			.   "`nFailed to set file infos."
			.   "`nFile: " dest
			.   "`n"
			.   "`nFile Version: " fileVer 
			.   "`nCurrent: " destVer
			.   "`n"
			.   "`nFile Description: " fileDesc 
			.   "`nCurrent: " destDesc
			.   "`n"
			.   "`nCopyright: " fileCopyright
			.   "`nCurrent: " destCpyR, 0, 0
			Set_FileInfos(dest, fileVer, fileDesc, fileCopyright)
			Sleep 500
			destVer := FGP_Value(dest, 167) ; 167 = Ver
		}
		ToolTip
		fileInfos := ""
	}

	CoordMode(_coordMode)
}

RunWaitMany(commands) {
    DetectHiddenWindows, on
    Run, %comspec% /k ,,Hide UseErrorLevel, cPid
    WinWait, ahk_pid %cPid%,, 10
    DllCall("AttachConsole","uint",cPid)
    hCon:=DllCall("CreateFile","str","CONOUT$","uint",0xC0000000,"uint",7,"uint",0,"uint",3,"uint",0,"uint",0)

    shell := ComObjCreate("WScript.Shell")
    ; Open cmd.exe with echoing of commands disabled
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; Send the commands to execute, separated by newline
    exec.StdIn.WriteLine(commands "`nexit")  ; Always exit at the end!
    ; Read and return the output of all commands
    stdOutReturn := exec.StdOut.ReadAll()

    DllCall("CloseHandle", "uint", hCon)
    DllCall("FreeConsole")
    Process, Close, %cPid%
    return stdOutReturn
}
