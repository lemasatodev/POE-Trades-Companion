Load_DebugJSON() {
/*		Only works when using the ahk source
*/
	global DEBUG

	if (A_IsCompiled)
		Return

	if FileExist(A_ScriptDir "\Debug.json") {
		debugObj := JSON_Load(A_ScriptDir "\Debug.json")
		if (debugObj.enable != True)
			Return

		debugText := JSON.Dump(debugObj, "", "`t")
		AppendToLogs(A_ThisFunc "(): Loaded debug json:`n" debugText "`n")

		DEBUG.SETTINGS 		:= ObjFullyClone(debugObj.settings)
		DEBUG.CHATLOGS 		:= ObjFullyClone(debugObj.chat_logs)
	}
}