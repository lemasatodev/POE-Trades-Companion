AssetsExtract() {
	; _TO_BE_ADDED_
	global PROGRAM
	static 0 ; Bypass warning "local same as global" for var 0

	if (A_IsCompiled) {
		FileInstall_Cmds()
		Return
	}

;	File location
	installFile := A_ScriptDir "\FileInstall_Cmds.ahk"
	FileDelete(installFile)

;	Pass PROGRAM to file
	appendToFile .= ""
	.		"if (!A_IsCompiled && A_ScriptName = ""FileInstall_Cmds.ahk"") {"
	. "`n"	"	#Include %A_ScriptDir%/lib/Logs.ahk"
	. "`n"	"	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk"
	. "`n"
	. "`n"	"	if (!PROGRAM)"
	. "`n"	"		PROGRAM := {}"
	. "`n"
	. "`n"	"	Loop, %0% {"
	. "`n"	"		paramAE := `%A_Index`%"
	. "`n"	"		if RegExMatch(paramAE, ""O)/(.*)=(.*)"", foundAE)"
	. "`n"	"			PROGRAM[foundAE.1] := foundAE.2"
	. "`n"	"	}"
	. "`n"
	. "`n"	"	FileInstall_Cmds()"
	. "`n"	"}"
	. "`n"	"; --------------------------------"
	. "`n"
	. "`n"


	appendToFile .= ""
	. 		"FileInstall_Cmds() {"
	. "`n"	"global PROGRAM"
	. "`n"
	. "`n"
	. "`n"	"if !(PROGRAM.MAIN_FOLDER) {"
	. "`n" 	"	Msgbox You cannot run this file manually!"
	. "`n"	"ExitApp"
	. "`n"	"}"
	. "`n"
	. "`n"

;	- - - - CURL
	filePath := "lib\third-party\curl.exe"
	appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "curl.exe" """", 2)

;	- - - - LINK SHORTCUTS
	filePath := "Wiki.url"
	appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "Wiki.url" """", 2)
	filePath := "GitHub.url"
	appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" "GitHub.url" """", 2)

;	- - - - DATA
	allowedExtensions := "txt,json"
	Loop, Files,% A_ScriptDir "\data\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\data\\(.*)", path)
		filePath := "data\" path.1

		if IsIn(A_LoopFileExt, allowedExtensions)
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.DATA_FOLDER """ "\" A_LoopFileName """", 2)
	}

;	- - - - RESOURCES
	allowedFiles := "changelog.txt,icon.ico,changelog_beta.txt"
	Loop, Files,% A_ScriptDir "\resources\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\(.*)", path)
		filePath := "resources\" path.1

		if (IsIn(A_LoopFileName, allowedFiles))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.MAIN_FOLDER """ "\" A_LoopFileName """", 2)
	}

;	- - - - FONTS
	allowedExtensions := "ttf"
	; allowedFiles := "FontReg.exe,EnumFonts.vbs,Settings.ini"
	allowedFiles := "Settings.ini"
	Loop, Files,% A_ScriptDir "\resources\fonts\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\fonts\\(.*)", path)
		filePath := "resources\fonts\" path.1

		if (IsIn(A_LoopFileName, allowedFiles) || IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.FONTS_FOLDER """ "\" path.1 """", 2)
	}
	
;	- - - - ICONS
	allowedExtensions := "ico"
	Loop, Files,% A_ScriptDir "\resources\icons\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\icons\\(.*)", path)
		filePath := "resources\icons\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.ICONS_FOLDER """ "\" path.1 """", 2)
	}

;	- - - - IMAGES
	allowedExtensions := "png"
	Loop, Files,% A_ScriptDir "\resources\imgs\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\imgs\\(.*)", path)
		filePath := "resources\imgs\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.IMAGES_FOLDER """ "\" path.1 """", 2)
	}

;	- - - - SFX
	allowedExtensions := "wav,mp3"
	Loop, Files,% A_ScriptDir "\resources\sfx\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\sfx\\(.*)", path)
		filePath := "resources\sfx\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.SFX_FOLDER """ "\" path.1 """", 2)
	}

	; - - - - SKINS
	allowedFiles := "Assets.ini,Settings.ini"
	allowedExtensions := "png,ico"
	forceReplaceFiles := "Assets.ini,Settings.ini"
	Loop,% A_ScriptDir "\resources\skins\*", 1, 1
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\skins\\(.*)", path)
		filePath := "resources\skins\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions) || IsIn(A_LoopFileName, allowedFiles)) {
			replaceFlag := IsIn(A_LoopFileName, forceReplaceFiles) ? 1 : 2
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.SKINS_FOLDER """ "\" path.1 """", replaceFlag)
		}
	}
	
	; - - - - TRANSLATIONS
	allowedExtensions := "json"
	Loop,% A_ScriptDir "\resources\translations\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\translations\\(.*)", path)
		filePath := "resources\translations\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.TRANSLATIONS_FOLDER """ "\" path.1 """", 2)
	}

	; - - - - CURRENCY IMGS
	allowedExtensions := "png"
	Loop,% A_ScriptDir "\resources\currency_imgs\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\currency_imgs\\(.*)", path)
		filePath := "resources\currency_imgs\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.CURRENCY_IMGS_FOLDER """ "\" path.1 """", 2)
	}

	; - - - - CHEAT SHEETS
	allowedExtensions := "png"
	Loop,% A_ScriptDir "\resources\cheatsheets\*"
	{
		RegExMatch(A_LoopFileFullPath, "O)\\resources\\cheatsheets\\(.*)", path)
		filePath := "resources\cheatsheets\" path.1

		if (IsIn(A_LoopFileExt, allowedExtensions))
			appendToFile .= FileInstall("""" filePath """", "PROGRAM.CHEATSHEETS_FOLDER """ "\" path.1 """", 2)
	}

	; - - - - 
	appendToFile .= ""
	. "`n"	
	. "`n"	"if (errorLog)"
	. "`n"	"	MsgBox, 4096, POE Trades Companion,% ""One or multiple files failed to be extracted. Please check the logs file for details."""
	. "`n"	"	.	PROGRAM.LOGS_FILE "
	. "`n"
	. "`n"	"}"

;	ADD TO FILE
	FileAppend,% appendToFile "`n",% installFile
	Sleep 10

/*	No longer required. Was only ran if the script is uncompiled. But assets are now being loaded from the AHK folder itself, instead of being extracted into the "main folder"
	; https://autohotkey.com/board/topic/6717-how-to-find-autohotkey-directory/
	cl := DllCall( "GetCommandLine", "str" )
	StringMid, path_AHk, cl, 2, InStr( cl, """", true, 2 )-2

	installFile_run_cmd := % """" path_AHk """" " /r " """" installFile """"
	.		" /MAIN_FOLDER=" 			"""" PROGRAM.MAIN_FOLDER """"
	.		" /SFX_FOLDER=" 			"""" PROGRAM.SFX_FOLDER """"
	.		" /LOGS_FOLDER=" 			"""" PROGRAM.LOGS_FOLDER """"
	.		" /SKINS_FOLDER=" 			"""" PROGRAM.SKINS_FOLDER """"
	.		" /FONTS_FOLDER=" 			"""" PROGRAM.FONTS_FOLDER """"
	.		" /IMAGES_FOLDER=" 			"""" PROGRAM.IMAGES_FOLDER """"
	.		" /DATA_FOLDER=" 			"""" PROGRAM.DATA_FOLDER """"
	.		" /ICONS_FOLDER=" 			"""" PROGRAM.ICONS_FOLDER """"
	. 		" /TEMP_FOLDER="			"""" PROGRAM.TEMP_FOLDER """"
	. 		" /TRANSLATIONS_FOLDER="	"""" PROGRAM.TRANSLATIONS_FOLDER """"
	. 		" /CURRENCY_IMGS_FOLDER="	"""" PROGRAM.CURRENCY_IMGS_FOLDER """"
	. 		" /CHEATSHEETS_FOLDER="		"""" PROGRAM.CHEATSHEETS_FOLDER """"
	.		" /LOGS_FILE="				"""" PROGRAM.LOGS_FILE """"

	RunWait,% installFile_run_cmd,% A_ScriptDir
	*/
}