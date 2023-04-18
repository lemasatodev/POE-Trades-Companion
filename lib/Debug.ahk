Load_DebugJSON() {
/*		Only works when using the ahk source
*/
	global DEBUG

	if (A_IsCompiled)
		Return

	if FileExist(A_ScriptDir "\Debug.json") {
		FileRead, debugJSON,% A_ScriptDir "\Debug.json"
		parsed_debugJSON := JSON.Load(debugJSON)

		if (parsed_debugJSON.enable != True)
			Return

		for key, value in parsed_debugJSON
			if (value=True)
				logsStr := logsStr?logsStr ", " key "=" value : key "=" value

		if (logsStr)
			AppendToLogs(A_ThisFunc "(): Loaded debug json: " logsStr ".")

		DEBUG.SETTINGS 		:= parsed_debugJSON.settings
		DEBUG.CHATLOGS 		:= parsed_debugJSON.chat_logs
	}
}