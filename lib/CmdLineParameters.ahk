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

Handle_CmdLineParameters() {
	global 0, PROGRAM, GAME, RUNTIME_PARAMETERS

	programName := PROGRAM.NAME

	Loop, %0% {
		param := %A_Index%
		
		if RegExMatch(param, "iO)/MyDocuments=(.*)", found) {
			RUNTIME_PARAMETERS["MyDocuments"] := found.1, found := ""
		}
		else if (param="/NoAdmin" || param="/SkipAdmin") {
			RUNTIME_PARAMETERS["SkipAdmin"] := True
		}
		else if (param="/NoReplace" || param="/NewInstance") {
			RUNTIME_PARAMETERS["NewInstance"] := True
		}
		else if RegExMatch(param, "iO)/InstanceName=(.*)", found) {
			RUNTIME_PARAMETERS["InstanceName"] := found.1, found := ""
		}
		else if RegExMatch(param, "iO)/GamePath=(.*)", found) || RegExMatch(param, "iO)/GameFolder=(.*)", found) {
			if FileExist(found.1 "\Client.exe") || FileExist(found.1 "\PathOfExile*.exe") {
				RUNTIME_PARAMETERS["GameFolder"] := found.1, found := ""
			}
			else
				Msgbox(4096+16, "", "Parameter invalid: Client.exe or PathOfExile*.exe not found in the folder."
				. "`n`nParam: " param "`nFolder: " found.1)
		}
		else if RegExMatch(param, "iO)/Screen_DPI=(.*)", found) {
			MsgBox(4096+48, "", "Parameter invalid: This parameter was removed due to it being unnecessary."
			. "`n`nParam: " param)
			found := ""
		}
		else if RegExMatch(param, "iO)/PrefsFile=(.*)", found) {
			MsgBox(4096+48, "", "Parameter invalid: This parameter has been replaced with /InstanceName=""exampleName""."
			. "`nPlease report to the wiki to see some usage example."
			. "`n`nParam: " param)
			found := ""
		}
	}
}