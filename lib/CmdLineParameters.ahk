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
	/*
		User params:
		/SkipAdmin 								-	Prevent from auto elevating as admin on script start
		/NewInstance 							-	Prevent closing the previous instance and allows to start a new separate one instead
									 				Note that this is not recommended. It's best to use /InstanceName="Something" instead
		/InstanceName="Something" 				-	Allows starting a separate instance with a specific name that will be used for config files
													This make it so this specific instance configs are separate from other configs 
		/GameFolder="C:\Games\Path of Exile\" 	- 	Force to only scan logs from that folder. Useful when used with /InstanceName and multiple game instances


		Devs params:
			/MyDocuments="C:\Users\Masato\Documents\" - Used automatically when reloading the app as admin so we use the original user's Documents folder instead of Admin's

			/CreateRelease		-	Used to create the corresponding files
			/CreateZip			-	Used to create the corresponding files
			/CompileExecutable	-	Used to create the corresponding files
			/UpdateDataFiles	-	Used to create the corresponding files
			/UpdateTranslations	-	Used to create the corresponding files

		Other params:
			/MiniFrizzle		- Special parameter just for MiniFrizzle
								  Switch the position between RMENU_CloseAllTabs and RMENU_CloseOtherTabsForSameItem
	*/
	global 0, PROGRAM, GAME, RUNTIME_PARAMETERS

	programName := PROGRAM.NAME

	Loop, %0% {
		param := %A_Index%

		; User params
		if IsIn(param,"/NoAdmin,/SkipAdmin")
			RUNTIME_PARAMETERS["SkipAdmin"] := True
		else if IsIn(param,"/NoReplace,/NewInstance")
			RUNTIME_PARAMETERS["NewInstance"] := True
		else if RegExMatch(param, "iO)/InstanceName=(.*)", found)
			RUNTIME_PARAMETERS["InstanceName"] := found.1, found := ""
		else if RegExMatch(param, "iO)/MyDocuments=(.*)", found)
			RUNTIME_PARAMETERS["MyDocuments"] := found.1, found := ""
		else if RegExMatch(param, "iO)/GamePath=(.*)", found) || RegExMatch(param, "iO)/GameFolder=(.*)", found) {
			if FileExist(found.1 "\Client.exe") || FileExist(found.1 "\PathOfExile*.exe")
				RUNTIME_PARAMETERS["GameFolder"] := found.1, found := ""
			else
				Msgbox(4096+16, "", "Parameter invalid: Client.exe or PathOfExile*.exe not found in the folder.`n`nParam: " param "`nFolder: " found.1)
		}

		; Dev params
		else if (param="/CreateRelease")
			RUNTIME_PARAMETERS["CreateRelease"] := True
		else if (param="/CreateZip")
			RUNTIME_PARAMETERS["CreateZip"] := True
		else if (param="/CompileExecutable")
			RUNTIME_PARAMETERS["CompileExecutable"] := True
		else if (param="/UpdateDataFiles")
			RUNTIME_PARAMETERS["UpdateDataFiles"] := True
		else if (param="/UpdateTranslations")
			RUNTIME_PARAMETERS["UpdateTranslations"] := True

		; Other params
		else if (param="/MiniFrizzle")
			RUNTIME_PARAMETERS["MiniFrizzle"] := True
		else if (param="/IsRanThroughBundledAhkExecutable")
			RUNTIME_PARAMETERS["IsRanThroughBundledAhkExecutable"] := True

		; Dead params
		else if RegExMatch(param, "i)/Screen_DPI=.*")
			MsgBox(4096+48, "", "Parameter invalid: This parameter was removed due to it being unnecessary.`n`nParam: " param)
		else if RegExMatch(param, "i)/PrefsFile=.*")
			MsgBox(4096+48, "", "Parameter invalid: This parameter has been replaced with /InstanceName=""exampleName"".`nPlease report to the wiki to see some usage example.`n`nParam: " param)
	}
}