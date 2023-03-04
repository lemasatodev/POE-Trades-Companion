/*	Dynamically returns FileInstall commands so you can write them in an external ahk file.
	Flag=2 allows to only replace if the sizes are different

	Since FileInstall commands #Include'ed from an external file will not be considered, I would advise to create a function containing those commands.
	
	(Supposing the external file is FileInstall_Cmds.ahk)
	Don't forget that, when using an ahk source script, the FileInstall_Cmds file will not have all the updated path since they are written on run-time.
	For this reason, you cannot #Include FileInstall_Cmds when running a source. You must run the FileInstall_Cmds file manually.

	Though, for compiled scripts, you can simply add:
		if (A_IsCompiled) {
			#Include FileInstall_Cmds.ahk
		}
	At the end of your script.


	# ! # ! # ! # ! # ! # ! # ! # ! # ! # ! 
	One flaw of this script is that when using flag=2, the file sizes are compared
	If both the source and dest files have the same size, but have different content, it will NOT be overwritten
	It is recommended to only use flag=2 for files that have a high chance of having a different file size upon modification
*/

FileInstall(source, dest, flag=0) {

	sourceNoQuotes := StrReplace(source, """", "")
	destWithPercent := "% " dest

	SplitPath, dest, , destFolder

	appendToFile .= ""
	. 			"if !InStr(FileExist(" destFolder """" "), ""D"")"
	. "`n"		"	FileCreateDir,% " destFolder """"
	. "`n"
	. "`n"

	if (flag=2) {
		appendToFile .= ""
		. 			"if (A_IsCompiled) {"
		. "`n"		"	sourceFileSize := Get_ResourceSize(" source ")"
		. "`n"		"	FileGetSize, destFileSize, " destWithPercent
		. "`n"		"}"
		. "`n"		"else {"
		. "`n"		"	FileGetSize, sourceFileSize, " sourceNoQuotes
		. "`n"		"	FileGetSize, destFileSize, " destWithPercent
		. "`n"		"}"
		. "`n"		"if (sourceFileSize != destFileSize)"
		. "`n"		"	FileInstall, " sourceNoQuotes ", " destWithPercent ", 1"
	}
	else {
		appendToFile .= "FileInstall, " sourceNoQuotes ", " destWithPercent ", " flag
	}

	errorTxt := """Failed to extract file!"""
		.	"`n	.	""``nSource: " sourceNoQuotes """"
		.	"`n	.	""``nDest: "" " dest
		.	"`n	.	""``nFlag: "" " flag

	appendToFile .= ""
	. "`n"			"if (ErrorLevel) {"
	. "`n"			"	AppendToLogs(" errorTxt ")"
	. "`n"			"	errorLog .= ""``n``n""" errorTxt
	. "`n"			"}"

	appendToFile .= "`n`n; ----------------------------`n"
	Return appendToFile
}

