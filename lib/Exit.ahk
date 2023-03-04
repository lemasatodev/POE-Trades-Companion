Exit(ExitReason, ExitCode) {

	if ExitReason not in Reload
	{
		AppendToLogs(A_ThisFunc "(ExitReason=" ExitReason ", ExitCode=" ExitCode ").")
		ExitApp
	}
}

Close_PreviousInstance() {
/*		Prevents from running multiple instances of this program
*		Works by reading the last PID and process name from the .ini
*		  , checking if there is an existing match
*		  and closing if a match is found
*/
	global PROGRAM, RUNTIME_PARAMETERS

	if ( RUNTIME_PARAMETERS.NoReplace = 1 ) {
		Return
	}

	localSettings := Get_LocalSettings()	
	prevPID := localSettings.UPDATING.PID = DllCall("GetCurrentProcessId") ? 0 : localSettings.UPDATING.PID ; Prevent to close app due to same pid
	prevPName := localSettings.UPDATING.FileProcessName
	prevHwnd := localSettings.UPDATING.ScriptHwnd

	Process, Exist, %prevPID%
	existingPID := ErrorLevel
	if ( existingPID = 0 )
		Return ; No match found
	else {
		Detect_HiddenWindows("On")
		existingPName := Get_Windows_Exe(existingPID, "ahk_pid")
		Detect_HiddenWindows()

		if ( existingPName = prevPName ) { ; Match found, close the previous instance
			AppendToLogs(A_ThisFunc "(): Detected previous instance with id " prevHwnd ".")
			Detect_HiddenWindows("On")
			WinClose, ahk_id %prevHwnd%
			WinWaitClose, ahk_id %prevHwnd%,,5
			err := ErrorLevel
			Detect_HiddenWindows()
			if (err) {
				AppendToLogs(A_ThisFunc "(): Failed to close previous instance with id " prevHwnd ".")
				GUI_SimpleWarn.Show("", "Previous instance detected."
								. "`nUnable to close PID " existingPID " (could be due to missing admin rights)."
								. "`nPlease close it before continuing."
								. "`n`nThis window will be closed automatically.", "Red", "White")
				Process, WaitClose, %existingPID%
				GUI_SimpleWarn.Destroy()
			}
			else
				AppendToLogs(A_ThisFunc "(): Successfully closed previous instance with id " prevHwnd ".")
		}
	}
}