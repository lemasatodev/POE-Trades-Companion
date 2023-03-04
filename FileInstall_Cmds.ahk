if (!A_IsCompiled && A_ScriptName = "FileInstall_Cmds.ahk") {
	#Include %A_ScriptDir%/lib/Logs.ahk
	#Include %A_ScriptDir%/lib/WindowsSettings.ahk
	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk

	if (!PROGRAM)
		PROGRAM := {}

	Loop, %0% {
		paramAE := %A_Index%
		if RegExMatch(paramAE, "O)/(.*)=(.*)", foundAE)
			PROGRAM[foundAE.1] := foundAE.2
	}

	FileInstall_Cmds()
}
; --------------------------------

FileInstall_Cmds() {
global PROGRAM


if !(PROGRAM.MAIN_FOLDER) {
	Msgbox You cannot run this file manually!
ExitApp
}

if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("lib\third-party\curl.exe")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
else {
	FileGetSize, sourceFileSize, lib\third-party\curl.exe
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
if (sourceFileSize != destFileSize)
	FileInstall, lib\third-party\curl.exe, % PROGRAM.MAIN_FOLDER "\curl.exe", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("Wiki.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
else {
	FileGetSize, sourceFileSize, Wiki.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, Wiki.url, % PROGRAM.MAIN_FOLDER "\Wiki.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("GitHub.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
else {
	FileGetSize, sourceFileSize, GitHub.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, GitHub.url, % PROGRAM.MAIN_FOLDER "\GitHub.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\CurrencyNames.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
else {
	FileGetSize, sourceFileSize, data\CurrencyNames.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\CurrencyNames.txt, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\ENG_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\ENG_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\ENG_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\ENG_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\ENG_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\ENG_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\ENG_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\ENG_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\ENG_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\ENG_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\ENG_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\ENG_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\ENG_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\ENG_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\ENG_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\ENG_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\ENG_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\ENG_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\ENG_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\ENG_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\FRE_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\FRE_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\FRE_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\FRE_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\FRE_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\FRE_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\FRE_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\FRE_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\FRE_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\FRE_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\FRE_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\FRE_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\FRE_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\FRE_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\FRE_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\FRE_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\FRE_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\FRE_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\FRE_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\FRE_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\GER_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\GER_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\GER_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\GER_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\GER_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\GER_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\GER_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\GER_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\GER_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\GER_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\GER_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\GER_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\GER_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\GER_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\GER_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\GER_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\GER_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\GER_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\GER_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\GER_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\KOR_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\KOR_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\KOR_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\KOR_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\KOR_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\KOR_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\KOR_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\KOR_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\KOR_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\KOR_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\KOR_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\KOR_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\KOR_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\KOR_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\KOR_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\KOR_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\KOR_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\KOR_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\KOR_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\KOR_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\mapsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
else {
	FileGetSize, sourceFileSize, data\mapsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\mapsData.json, % PROGRAM.DATA_FOLDER "\mapsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\poeTradeCurrencyData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
else {
	FileGetSize, sourceFileSize, data\poeTradeCurrencyData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\poeTradeCurrencyData.json, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\POR_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\POR_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\POR_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\POR_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\POR_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\POR_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\POR_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\POR_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\POR_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\POR_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\POR_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\POR_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\POR_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\POR_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\POR_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\POR_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\POR_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\POR_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\POR_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\POR_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\RUS_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\RUS_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\RUS_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\RUS_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\RUS_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\RUS_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\RUS_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\RUS_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\RUS_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\RUS_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\RUS_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\RUS_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\RUS_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\RUS_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\RUS_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\RUS_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\RUS_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\RUS_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\RUS_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\RUS_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\SPA_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\SPA_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\SPA_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\SPA_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\SPA_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\SPA_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\SPA_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\SPA_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\SPA_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\SPA_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\SPA_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\SPA_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\SPA_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\SPA_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\SPA_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\SPA_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\SPA_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\SPA_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\SPA_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\SPA_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\THA_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\THA_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\THA_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\THA_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\THA_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\THA_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\THA_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\THA_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\THA_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\THA_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\THA_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\THA_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\THA_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\THA_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\THA_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\THA_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\THA_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\THA_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\THA_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\THA_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\tradingLeagues.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\tradingLeagues.json"
}
else {
	FileGetSize, sourceFileSize, data\tradingLeagues.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\tradingLeagues.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\tradingLeagues.json, % PROGRAM.DATA_FOLDER "\tradingLeagues.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\tradingLeagues.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\tradingLeagues.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\tradingLeagues.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\tradingLeagues.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\tradingRegexes.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\tradingRegexes.json"
}
else {
	FileGetSize, sourceFileSize, data\tradingRegexes.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\tradingRegexes.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\tradingRegexes.json, % PROGRAM.DATA_FOLDER "\tradingRegexes.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\tradingRegexes.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\tradingRegexes.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\tradingRegexes.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\tradingRegexes.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\TWN_poeDotComItemsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\TWN_poeDotComItemsData.json"
}
else {
	FileGetSize, sourceFileSize, data\TWN_poeDotComItemsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\TWN_poeDotComItemsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\TWN_poeDotComItemsData.json, % PROGRAM.DATA_FOLDER "\TWN_poeDotComItemsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\TWN_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\TWN_poeDotComItemsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\TWN_poeDotComItemsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\TWN_poeDotComItemsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\TWN_poeDotComStaticData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\TWN_poeDotComStaticData.json"
}
else {
	FileGetSize, sourceFileSize, data\TWN_poeDotComStaticData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\TWN_poeDotComStaticData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\TWN_poeDotComStaticData.json, % PROGRAM.DATA_FOLDER "\TWN_poeDotComStaticData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\TWN_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\TWN_poeDotComStaticData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\TWN_poeDotComStaticData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\TWN_poeDotComStaticData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\UniqueMaps.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
else {
	FileGetSize, sourceFileSize, data\UniqueMaps.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\UniqueMaps.txt, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog.txt, % PROGRAM.MAIN_FOLDER "\changelog.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog_beta.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog_beta.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog_beta.txt, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icon.ico")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icon.ico
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icon.ico, % PROGRAM.MAIN_FOLDER "\icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Consolas.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Consolas.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Consolas.ttf, % PROGRAM.FONTS_FOLDER "\Consolas.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-Regular.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-Regular.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-Regular.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-SmallCaps.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-SmallCaps.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-SmallCaps.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Segoe UI.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Segoe UI.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Segoe UI.ttf, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Settings.ini")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Settings.ini
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Settings.ini, % PROGRAM.FONTS_FOLDER "\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\TC_Symbols.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\TC_Symbols.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\TC_Symbols.ttf, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\chart.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\chart.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\chart.ico, % PROGRAM.ICONS_FOLDER "\chart.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\gear.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\gear.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\gear.ico, % PROGRAM.ICONS_FOLDER "\gear.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\POE.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\POE.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\POE.ico, % PROGRAM.ICONS_FOLDER "\POE.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\qmark.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\qmark.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\qmark.ico, % PROGRAM.ICONS_FOLDER "\qmark.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\refresh.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\refresh.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\refresh.ico, % PROGRAM.ICONS_FOLDER "\refresh.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\x.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\x.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\x.ico, % PROGRAM.ICONS_FOLDER "\x.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord.png, % PROGRAM.IMAGES_FOLDER "\Discord.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big.png, % PROGRAM.IMAGES_FOLDER "\Discord_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big_forums.png, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\DonatePaypal.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\DonatePaypal.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\DonatePaypal.png, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_china.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_china.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_china.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_china.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_china.png, % PROGRAM.IMAGES_FOLDER "\flag_china.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_china.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_china.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_china.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_china.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_france.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_france.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_france.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_france.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_france.png, % PROGRAM.IMAGES_FOLDER "\flag_france.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_france.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_france.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_france.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_france.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_portugal.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_portugal.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_portugal.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_portugal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_portugal.png, % PROGRAM.IMAGES_FOLDER "\flag_portugal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_portugal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_portugal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_portugal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_portugal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_russia.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_russia.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_russia.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_russia.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_russia.png, % PROGRAM.IMAGES_FOLDER "\flag_russia.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_russia.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_russia.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_russia.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_russia.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_taiwan.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_taiwan.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_taiwan.png, % PROGRAM.IMAGES_FOLDER "\flag_taiwan.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_taiwan.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_taiwan.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\flag_uk.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_uk.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\flag_uk.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\flag_uk.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\flag_uk.png, % PROGRAM.IMAGES_FOLDER "\flag_uk.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\flag_uk.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_uk.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\flag_uk.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\flag_uk.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub.png, % PROGRAM.IMAGES_FOLDER "\GitHub.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big_forums.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE.png, % PROGRAM.IMAGES_FOLDER "\POE.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE_big.png, % PROGRAM.IMAGES_FOLDER "\POE_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit.png, % PROGRAM.IMAGES_FOLDER "\Reddit.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit_big.png, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Gleam.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Gleam.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Gleam.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Hey.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Hey.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Hey.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_3.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_CopyErase_Start.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_CopyErase_Start.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_CopyErase_Start.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_Letter.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_Letter.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_Letter.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate1.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate2.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate3.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate4.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate4.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate4.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Assets.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Background.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackground.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackground2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackground2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackground2.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackground2Hover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Hover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackground2Hover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Hover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackground2Hover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Hover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Hover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Hover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackground2Press.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Press.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackground2Press.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Press.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackground2Press.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Press.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Press.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackground2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackground2Press.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackgroundHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackgroundHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackgroundHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericBackgroundPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericBackgroundPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericBackgroundPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericEdge.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdge.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericEdge.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdge.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericEdge.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdge.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericEdge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdge.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericEdge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdge.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericEdgeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdgeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericEdgeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdgeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericEdgeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdgeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericEdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdgeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericEdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericEdgeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericLeftRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericLeftRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericLeftRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericLeftRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericLeftRightPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericLeftRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericLeftRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericLeftRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericLeftRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericLeftRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonGenericTopBottomPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericTopBottomPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonGenericTopBottomPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericTopBottomPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonGenericTopBottomPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericTopBottomPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericTopBottomPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericTopBottomPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonGenericTopBottomPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonGenericTopBottomPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Header.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Header2.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Icon.ico, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconArrowRight.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconClipboard.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconCross.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconCross.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconCross.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconCross.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconCross.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconCross.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconCross.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconCross.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconHideout.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconInvite.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconKick.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconLink.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconLink.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconLink.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconLink.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconLink.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconLink.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconLink.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconLink.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconMaximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMaximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconMaximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMaximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconMaximize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMaximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconMaximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconMaximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconMinimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMinimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconMinimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMinimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconMinimize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconMinimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconMinimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconMinimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconSheet.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconThumbsDown.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsDown.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconThumbsDown.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsDown.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconThumbsDown.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsDown.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsDown.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsDown.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconThumbsUp.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsUp.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconThumbsUp.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsUp.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconThumbsUp.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsUp.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsUp.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconThumbsUp.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconTrade.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\IconWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\IconWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\IconWhisper.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\IconWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\IconWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Preview_Buy.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Buy.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Preview_Buy.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Buy.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Preview_Buy.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Buy.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Buy.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Buy.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Preview_Sell.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Sell.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Preview_Sell.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Sell.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Preview_Sell.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Sell.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Sell.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview_Sell.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Settings.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabsUnderline.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabsUnderline.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabsUnderline.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Assets.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Background.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2Background.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2Background2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2Background2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2Background2.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2Background2Hover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Hover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2Background2Hover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Hover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2Background2Hover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Hover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Hover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Hover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2Background2Press.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Press.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2Background2Press.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Press.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2Background2Press.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Press.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Press.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Background2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Background2Press.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2BackgroundHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2BackgroundHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2BackgroundHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2BackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2BackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2BackgroundPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2BackgroundPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2BackgroundPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2BackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2BackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2BackgroundPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2Edge.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Edge.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2Edge.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Edge.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2Edge.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Edge.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Edge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Edge.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2Edge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2Edge.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2EdgeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2EdgeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2EdgeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2EdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2EdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGeneric2EdgePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGeneric2EdgePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGeneric2EdgePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2EdgePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGeneric2EdgePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGeneric2EdgePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericBackground.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericBackgroundHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericBackgroundHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericBackgroundHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericBackgroundPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericBackgroundPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericBackgroundPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericLeft.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericRight.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericVerticalBottom.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalBottom.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericVerticalBottom.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalBottom.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericVerticalBottom.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalBottom.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericVerticalBottom.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalBottom.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericVerticalBottom.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalBottom.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonGenericVerticalTop.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalTop.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonGenericVerticalTop.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalTop.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonGenericVerticalTop.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalTop.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericVerticalTop.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalTop.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonGenericVerticalTop.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonGenericVerticalTop.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Header.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Header2.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Icon.ico, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconArrowRight.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconClipboard.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconCross.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconCross.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconCross.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconCross.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconCross.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconCross.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconCross.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconCross.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconHideout.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconInvite.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconKick.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconLink.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconLink.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconLink.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconLink.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconLink.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconLink.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconLink.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconLink.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconMaximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMaximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconMaximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMaximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconMaximize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMaximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconMaximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconMaximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconMinimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMinimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconMinimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMinimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconMinimize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconMinimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconMinimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconMinimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconSheet.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconThumbsDown.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsDown.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconThumbsDown.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsDown.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconThumbsDown.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsDown.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsDown.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsDown.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconThumbsUp.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsUp.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconThumbsUp.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsUp.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconThumbsUp.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsUp.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsUp.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconThumbsUp.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconTrade.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\IconWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\IconWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\IconWhisper.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\IconWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\IconWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Preview_Buy.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Buy.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Preview_Buy.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Buy.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Preview_Buy.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Buy.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Buy.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Buy.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Preview_Sell.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Sell.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Preview_Sell.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Sell.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Preview_Sell.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Sell.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Sell.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview_Sell.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Settings.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Assets.ini, % PROGRAM.SKINS_FOLDER "\White\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Background.png, % PROGRAM.SKINS_FOLDER "\White\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackground.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackground2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackground2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackground2.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackground2Hover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Hover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackground2Hover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Hover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackground2Hover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Hover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Hover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2Hover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Hover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackground2Press.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Press.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackground2Press.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Press.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackground2Press.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Press.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Press.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackground2Press.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackground2Press.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackgroundHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackgroundHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackgroundHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackgroundHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericBackgroundPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericBackgroundPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericBackgroundPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericBackgroundPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericBackgroundPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericEdge.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdge.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericEdge.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdge.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericEdge.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdge.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericEdge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdge.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericEdge.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdge.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericEdgeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdgeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericEdgeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdgeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericEdgeHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdgeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericEdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdgeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericEdgeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericEdgeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericLeftRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericLeftRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericLeftRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericLeftRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericLeftRightPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericLeftRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericLeftRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericLeftRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericLeftRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericLeftRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonGenericTopBottomPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericTopBottomPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonGenericTopBottomPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericTopBottomPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonGenericTopBottomPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonGenericTopBottomPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericTopBottomPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericTopBottomPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonGenericTopBottomPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonGenericTopBottomPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Header.png, % PROGRAM.SKINS_FOLDER "\White\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Header2.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header2.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Header2.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header2.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Header2.png, % PROGRAM.SKINS_FOLDER "\White\Header2.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header2.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Header2.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header2.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Icon.ico, % PROGRAM.SKINS_FOLDER "\White\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconArrowLeft.png, % PROGRAM.SKINS_FOLDER "\White\IconArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconArrowRight.png, % PROGRAM.SKINS_FOLDER "\White\IconArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconClipboard.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconClipboard.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconClipboard.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconClipboard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconClipboard.png, % PROGRAM.SKINS_FOLDER "\White\IconClipboard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconClipboard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconClipboard.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconClipboard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconCross.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconCross.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconCross.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconCross.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconCross.png, % PROGRAM.SKINS_FOLDER "\White\IconCross.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconCross.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconCross.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconCross.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconHideout.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconHideout.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconHideout.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconHideout.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconHideout.png, % PROGRAM.SKINS_FOLDER "\White\IconHideout.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconHideout.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconHideout.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconHideout.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconInvite.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconInvite.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconInvite.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconInvite.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconInvite.png, % PROGRAM.SKINS_FOLDER "\White\IconInvite.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconInvite.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconInvite.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconInvite.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconKick.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconKick.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconKick.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconKick.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconKick.png, % PROGRAM.SKINS_FOLDER "\White\IconKick.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconKick.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconKick.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconKick.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconLink.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconLink.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconLink.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconLink.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconLink.png, % PROGRAM.SKINS_FOLDER "\White\IconLink.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconLink.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconLink.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconLink.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconMaximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconMaximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconMaximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconMaximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconMaximize.png, % PROGRAM.SKINS_FOLDER "\White\IconMaximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconMaximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconMaximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconMaximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconMinimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconMinimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconMinimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconMinimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconMinimize.png, % PROGRAM.SKINS_FOLDER "\White\IconMinimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconMinimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconMinimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconMinimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconSheet.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconSheet.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconSheet.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconSheet.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconSheet.png, % PROGRAM.SKINS_FOLDER "\White\IconSheet.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconSheet.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconSheet.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconSheet.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconThumbsDown.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconThumbsDown.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconThumbsDown.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconThumbsDown.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconThumbsDown.png, % PROGRAM.SKINS_FOLDER "\White\IconThumbsDown.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconThumbsDown.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconThumbsDown.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconThumbsDown.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconThumbsUp.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconThumbsUp.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconThumbsUp.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconThumbsUp.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconThumbsUp.png, % PROGRAM.SKINS_FOLDER "\White\IconThumbsUp.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconThumbsUp.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconThumbsUp.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconThumbsUp.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconTrade.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconTrade.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconTrade.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconTrade.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconTrade.png, % PROGRAM.SKINS_FOLDER "\White\IconTrade.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconTrade.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconTrade.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconTrade.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\IconWhisper.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconWhisper.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\IconWhisper.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\IconWhisper.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\IconWhisper.png, % PROGRAM.SKINS_FOLDER "\White\IconWhisper.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconWhisper.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\IconWhisper.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\IconWhisper.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Preview_Buy.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview_Buy.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Preview_Buy.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview_Buy.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Preview_Buy.png, % PROGRAM.SKINS_FOLDER "\White\Preview_Buy.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview_Buy.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview_Buy.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview_Buy.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Preview_Sell.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview_Sell.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Preview_Sell.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview_Sell.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Preview_Sell.png, % PROGRAM.SKINS_FOLDER "\White\Preview_Sell.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview_Sell.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview_Sell.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview_Sell.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Settings.ini, % PROGRAM.SKINS_FOLDER "\White\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabActive.png, % PROGRAM.SKINS_FOLDER "\White\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabHover.png, % PROGRAM.SKINS_FOLDER "\White\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabsUnderline.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabsUnderline.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabsUnderline.png, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\chinese_simplified.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\chinese_simplified.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\chinese_simplified.json, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\chinese_simplified.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\chinese_simplified.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_simplified.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\chinese_traditional.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\chinese_traditional.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\chinese_traditional.json, % PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\chinese_traditional.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\chinese_traditional.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\chinese_traditional.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\english.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\english.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\english.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\english.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\english.json, % PROGRAM.TRANSLATIONS_FOLDER "\english.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\english.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\english.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\english.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\english.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\french.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\french.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\french.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\french.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\french.json, % PROGRAM.TRANSLATIONS_FOLDER "\french.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\french.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\french.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\french.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\french.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\portuguese.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\portuguese.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\portuguese.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\portuguese.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\portuguese.json, % PROGRAM.TRANSLATIONS_FOLDER "\portuguese.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\portuguese.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\portuguese.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\portuguese.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\portuguese.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.TRANSLATIONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.TRANSLATIONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\translations\russian.json")
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
}
else {
	FileGetSize, sourceFileSize, resources\translations\russian.json
	FileGetSize, destFileSize, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\translations\russian.json, % PROGRAM.TRANSLATIONS_FOLDER "\russian.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\translations\russian.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\translations\russian.json"
	.	"`nDest: " PROGRAM.TRANSLATIONS_FOLDER "\russian.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Ancient Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Ancient Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Ancient Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Ancient Reliquary Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Ancient Reliquary Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Ancient Reliquary Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Ancient Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Ancient Reliquary Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Annulment Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Annulment Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Annulment Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Annulment Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Annulment Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Annulment Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Apprentice Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Apprentice Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Apprentice Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Apprentice Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Apprentice Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Apprentice Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Apprentice Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Apprentice Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Armourer's Scrap.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Armourer's Scrap.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Armourer's Scrap.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Armourer's Scrap.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Armourer's Scrap.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Armourer's Scrap.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blacksmith's Whetstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blacksmith's Whetstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blacksmith's Whetstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blacksmith's Whetstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blacksmith's Whetstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blacksmith's Whetstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessed Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessed Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessed Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessed Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessed Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessed Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Chayula.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Chayula.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Chayula.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Chayula.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Esh.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Esh.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Esh.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Esh.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Tul.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Tul.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Tul.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Tul.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Uul-Netol.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Uul-Netol.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Uul-Netol.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Uul-Netol.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Blessing of Xoph.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Blessing of Xoph.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Blessing of Xoph.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Blessing of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Blessing of Xoph.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Cartographer's Chisel.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Cartographer's Chisel.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Cartographer's Chisel.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Cartographer's Chisel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Cartographer's Chisel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Cartographer's Chisel.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chaos Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chaos Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chaos Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chaos Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chaos Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chaos Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chayula's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chayula's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chayula's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chayula's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chayula's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Chromatic Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Chromatic Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Chromatic Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chromatic Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Chromatic Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Chromatic Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Divine Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Divine Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Divine Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Divine Vessel.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Divine Vessel.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Divine Vessel.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Vessel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Divine Vessel.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Divine Vessel.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Eber's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Eber's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Eber's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eber's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eber's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eber's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Engineer's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Engineer's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Engineer's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Engineer's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Engineer's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Engineer's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Esh's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Esh's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Esh's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Esh's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Esh's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Eternal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Eternal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Eternal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eternal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Eternal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Eternal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Exalted Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Exalted Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Exalted Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Exalted Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Exalted Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Exalted Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Exalted Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Exalted Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Chimera.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Chimera.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Chimera.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Chimera.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Chimera.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Chimera.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Hydra.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Hydra.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Hydra.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Hydra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Hydra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Hydra.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Minotaur.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Minotaur.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Minotaur.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Minotaur.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Minotaur.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Minotaur.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Fragment of the Phoenix.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Fragment of the Phoenix.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Fragment of the Phoenix.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Phoenix.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Fragment of the Phoenix.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Fragment of the Phoenix.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Gemcutter's Prism.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Gemcutter's Prism.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Gemcutter's Prism.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Gemcutter's Prism.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Gemcutter's Prism.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Gemcutter's Prism.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Glassblower's Bauble.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Glassblower's Bauble.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Glassblower's Bauble.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Glassblower's Bauble.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Glassblower's Bauble.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Glassblower's Bauble.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Harbinger's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Harbinger's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Harbinger's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Harbinger's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Harbinger's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Harbinger's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Inya's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Inya's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Inya's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Inya's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Inya's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Inya's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Jeweller's Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Jeweller's Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Jeweller's Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Jeweller's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Jeweller's Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Jeweller's Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Journeyman Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Journeyman Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Journeyman Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Journeyman Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Journeyman Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Journeyman Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Journeyman Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Journeyman Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Master Cartographer's Seal.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Master Cartographer's Seal.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Master Cartographer's Seal.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Seal.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Seal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Master Cartographer's Sextant.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Master Cartographer's Sextant.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Master Cartographer's Sextant.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Master Cartographer's Sextant.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Master Cartographer's Sextant.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mirror of Kalandra.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mirror of Kalandra.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mirror of Kalandra.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror of Kalandra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror of Kalandra.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror of Kalandra.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mirror Shard.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mirror Shard.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mirror Shard.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mirror Shard.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mirror Shard.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Grief.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Grief.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Grief.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Grief.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Grief.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Grief.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Hope.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Hope.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Hope.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Hope.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Hope.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Hope.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Ignorance.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Ignorance.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Ignorance.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Ignorance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Ignorance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Ignorance.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Rage.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Rage.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Rage.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Rage.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Rage.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Rage.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Mortal Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Mortal Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Mortal Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Mortal Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Mortal Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Offering to the Goddess.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Offering to the Goddess.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Offering to the Goddess.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Offering to the Goddess.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Offering to the Goddess.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Offering to the Goddess.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Alchemy.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Alchemy.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Alchemy.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alchemy.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alchemy.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alchemy.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Alteration.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Alteration.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Alteration.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alteration.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Alteration.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Alteration.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Annulment.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Annulment.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Annulment.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Annulment.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Annulment.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Annulment.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Augmentation.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Augmentation.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Augmentation.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Augmentation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Augmentation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Augmentation.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Binding.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Binding.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Binding.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Binding.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Binding.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Binding.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Chance.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Chance.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Chance.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Chance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Chance.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Chance.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Fusing.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Fusing.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Fusing.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Fusing.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Fusing.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Fusing.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Horizons.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Horizons.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Horizons.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Horizons.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Horizons.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Horizons.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Regret.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Regret.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Regret.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Regret.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Regret.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Regret.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Scouring.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Scouring.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Scouring.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Scouring.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Scouring.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Scouring.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Orb of Transmutation.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Orb of Transmutation.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Orb of Transmutation.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Transmutation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Orb of Transmutation.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Orb of Transmutation.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Pale Court Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Pale Court Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Pale Court Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Pale Court Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Pale Court Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Pale Court Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Perandus Coin.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Perandus Coin.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Perandus Coin.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Perandus Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Perandus Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Perandus Coin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Portal Scroll.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Portal Scroll.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Portal Scroll.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Portal Scroll.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Portal Scroll.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Portal Scroll.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Regal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Regal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Regal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Regal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Regal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Regal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Dawn.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Dawn.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Dawn.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dawn.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dawn.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dawn.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Dusk.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Dusk.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Dusk.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dusk.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Dusk.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Dusk.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Midnight.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Midnight.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Midnight.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Midnight.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Midnight.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Midnight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice at Noon.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice at Noon.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice at Noon.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Noon.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice at Noon.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice at Noon.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Sacrifice Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Sacrifice Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Sacrifice Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Sacrifice Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Sacrifice Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Scroll of Wisdom.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Scroll of Wisdom.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Scroll of Wisdom.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Scroll of Wisdom.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Scroll of Wisdom.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Scroll of Wisdom.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Shaper Set.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Shaper Set.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Shaper Set.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Shaper Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Shaper Set.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Shaper Set.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Silver Coin.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Silver Coin.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Silver Coin.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Silver Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Silver Coin.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Silver Coin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Chayula.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Chayula.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Chayula.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Chayula.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Chayula.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Esh.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Esh.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Esh.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Esh.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Esh.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Tul.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Tul.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Tul.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Tul.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Tul.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Uul-Netol.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Uul-Netol.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Uul-Netol.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Uul-Netol.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Uul-Netol.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Splinter of Xoph.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Splinter of Xoph.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Splinter of Xoph.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Splinter of Xoph.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Splinter of Xoph.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Stacked Deck.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Stacked Deck.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Stacked Deck.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Stacked Deck.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Stacked Deck.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Stacked Deck.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Eternal Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Eternal Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Eternal Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Eternal Empire Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Eternal Empire Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Eternal Empire Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Empire Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Eternal Empire Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Eternal Empire Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Karui Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Karui Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Karui Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Karui Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Karui Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Karui Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Karui Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Karui Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Maraketh Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Maraketh Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Maraketh Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Maraketh Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Maraketh Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Maraketh Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Maraketh Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Maraketh Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Templar Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Templar Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Templar Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Templar Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Templar Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Templar Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Templar Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Templar Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Vaal Emblem.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Vaal Emblem.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Vaal Emblem.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Emblem.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Emblem.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeless Vaal Splinter.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeless Vaal Splinter.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeless Vaal Splinter.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeless Vaal Splinter.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeless Vaal Splinter.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Timeworn Reliquary Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Timeworn Reliquary Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Timeworn Reliquary Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeworn Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Timeworn Reliquary Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Timeworn Reliquary Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Tul's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Tul's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Tul's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Tul's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Tul's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Unknown.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Unknown.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Unknown.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Unknown.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Unknown.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Uul-Netol's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Uul-Netol's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Uul-Netol's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Uul-Netol's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Uul-Netol's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Vaal Orb.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Vaal Orb.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Vaal Orb.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Vaal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Vaal Orb.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Vaal Orb.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Volkuur's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Volkuur's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Volkuur's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Volkuur's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Volkuur's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Volkuur's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Charged Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Charged Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Charged Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Charged Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Charged Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Enriched Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Enriched Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Enriched Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Enriched Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Enriched Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Xoph's Pure Breachstone.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Xoph's Pure Breachstone.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Xoph's Pure Breachstone.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Xoph's Pure Breachstone.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Xoph's Pure Breachstone.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CURRENCY_IMGS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CURRENCY_IMGS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\currency_imgs\Yriel's Key.png")
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
}
else {
	FileGetSize, sourceFileSize, resources\currency_imgs\Yriel's Key.png
	FileGetSize, destFileSize, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\currency_imgs\Yriel's Key.png, % PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Yriel's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\currency_imgs\Yriel's Key.png"
	.	"`nDest: " PROGRAM.CURRENCY_IMGS_FOLDER "\Yriel's Key.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Betrayal.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Betrayal.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Betrayal.png, % PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Betrayal.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Betrayal.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Betrayal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Delve.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Delve.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Delve.png, % PROGRAM.CHEATSHEETS_FOLDER "\Delve.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Delve.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Delve.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Delve.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Essence.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Essence.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Essence.png, % PROGRAM.CHEATSHEETS_FOLDER "\Essence.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Essence.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Essence.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Essence.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Heist.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Heist.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Heist.png, % PROGRAM.CHEATSHEETS_FOLDER "\Heist.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Heist.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Heist.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Heist.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.CHEATSHEETS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.CHEATSHEETS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\cheatsheets\Incursion.png")
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
}
else {
	FileGetSize, sourceFileSize, resources\cheatsheets\Incursion.png
	FileGetSize, destFileSize, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\cheatsheets\Incursion.png, % PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Incursion.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\cheatsheets\Incursion.png"
	.	"`nDest: " PROGRAM.CHEATSHEETS_FOLDER "\Incursion.png"
	.	"`nFlag: " 2
}

; ----------------------------


if (errorLog)
	MsgBox, 4096, POE Trades Companion,% "One or multiple files failed to be extracted. Please check the logs file for details."
	.	PROGRAM.LOGS_FILE 

}
