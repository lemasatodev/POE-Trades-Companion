Reload() {
	GUI_Trades_V2.SaveBackup("Sell")
	GUI_Trades_V2.SaveBackup("Buy")
	ReloadWithParams("", getCurrentParams:=True, asAdmin:=A_IsAdmin)
	; Sleep 10
	; Reload
	; Sleep 10000
}

ReloadWithParams(params, getCurrentParams=False, asAdmin=False) {
	if (getCurrentParams) {
		params .= " " Get_CmdLineParameters()
	}

	if (asAdmin)
		runMode := "RunAs"
	else runMode := ""

	AhkPath := A_IsCompiled ? A_ScriptFullPath
			: FileExist(PROGRAM.AUTOHOTKEY_EXECUTABLE) ? PROGRAM.AUTOHOTKEY_EXECUTABLE
			: A_AhkPath
	runParameters := A_IsCompiled ? params
			: """" . A_ScriptFullPath . """" . A_Space """" . AhkPath . """" . A_Space . params

	Sleep 10
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,runMode,str, AhkPath,str,runParameters,str,A_WorkingDir,int,1)
	ExitApp
	Sleep 10000
}