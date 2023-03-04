WinWaitTitle(winTitle, waitTime="inf", detectHiddenWin=False) {
	waitTime := waitTime="inf" ? "" : waitTime
	if (detectHiddenWin)
		hw := DetectHiddenWindows("On")
	WinWait,% winTitle,,% waitTime
	errLvl := ErrorLevel
	if (detectHiddenWin)
		DetectHiddenWindows(hw)
	return ErrorLevel
}

Get_WindowsResolutionDPI() {
	return A_ScreenDPI=96?1:A_ScreenDPI/96

	/*	From Registry
	; Credits to ANT-ilic
	; autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/?p=77893
	
	RegRead, regValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	dpiFactor := (ErrorLevel || regValue=96)?(1):(regValue/96)
	return dpiFactor
	*/
}

Get_WindowsResolutionDPIBlurryFixState() {
	RegRead, regValue, HKEY_CURRENT_USER, Control Panel\Desktop, EnablePerProcessSystemDPI 
	regValue := regValue=1?True:False
	return regValue
}


GetMonitorPosition(monIndex=1) {
    SysGet, Mon, Monitor,% monIndex
    SysGet, MonWA, MonitorWorkArea,% monIndex
    MonitorPosition := {"Left": MonLeft, "Right": MonRight, "Top": MonTop, "Bottom": MonBottom
                       ,"LeftWA": MonWALeft, "RightWA": MonWARight, "TopWA": MonWATop, "BottomWA": MonWABottom}    
    return MonitorPosition
}

Get_HotkeyString(_hotkey, simpleString=False) {
	Loop 3 {
		char := SubStr(_hotkey, A_Index, 1)
		restOfString := SubStr(_hotkey, A_Index)
		if (simpleString)
			keyStr := (char="^")?("Ctrl"):(char="!")?("Alt"):(char="+")?("Shift"):("")
		else 
			keyStr := (char="^")?("{Ctrl Down}"):(char="!")?("{Alt Down}"):(char="+")?("{Shift Down}"):("")

		if !(keyStr)
			Break

		if (simpleString)
			hotkeyString .= (keyStr)?(keyStr "+"):("")
		else 
			hotkeyString .= (keyStr)?(keyStr):("")
	}

	if (simpleString) {
		hotkeyString .= restOfString
		Return hotkeyString
	}

	hotkeyString .= "{" restOfString " Down}"

	split := StrSplit(hotkeyString, "Down}")
	for key, element in split {
		if (element)
			maxIndex++
	}
	splitIndex := maxIndex
			
	Loop, %maxIndex% {
		hotkeyString .= split[splitIndex] "Up}"
		splitIndex--
	}

	Return hotkeyString
}

SplitPath(fileOrPath) {
	SplitPath, fileOrPath, fileName, fileDir, fileExt, fileNameNoExt, fileDrive
	
    returnObj := {}
	if RegExMatch(fileName, "iO)(.*)\.(.*) (.*)|(.*)\.(.*)", match)
        fileName := match.1 "." match.2, fileNameNoExt := match.1, fileExt := match.2, fileParams := match.3
	else if (!fileExt) && (fileName)
		fileDir := fileDir "\" fileName, fileName := ""

    returnObj := {FileName: fileName, FileExt: fileExt, FileParams: fileParams, FileNameNoExt: fileNameNoExt
    ,Folder: fileDir, Drive: fileDrive}
	return returnObj
}

EnvGet(var) {
	EnvGet, ret, %var%
	return ret
}

VerifyAHKVersion() {
	global PROGRAM
	requiredVer := "1.1.30.03", unicodeOrAnsi := A_IsUnicode?"Unicode":"ANSI", 32or64bits := A_PtrSize=4?"32bits":"64bits"

	if (!A_IsUnicode) {
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48,PROGRAM.NAME " - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application isn't compatible with ANSI versions of AutoHotKey."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "Please download and install AutoHotKey Unicode 32/64 or use the compiled executable."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
	if (A_AhkVersion < "1.1") ; Smaller than 1.1.00.00
	|| (A_AhkVersion < "1.1.00.00")
	|| (A_AhkVersion < requiredVer) { ; Smaller than required
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48,PROGRAM.NAME " - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application requires AutoHotKey v" requiredVer " or higher."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "AutoHotKey website has been opened, please update to the latest version."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
	if (A_AhkVersion >= "2.0")
	|| (A_AhkVersion >= "2.0.00.00") { ; Higher or equal to 2.0.00.00
		Run,% "https://www.autohotkey.com/"
		MsgBox(4096+48,PROGRAM.NAME " - Wrong AutoHotKey Version"
		, "/!\ PLEASE READ CAREFULLY /!\"
		. "`n"
		. "`n" "This application isn't compatible with AutoHotKey v2."
		. "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
		. "`n" "AutoHotKey v" requiredVer " or higher is required."
		. "`n" "Please downgrade, or compile the executable with v" requiredVer "."
		. "`n" "AutoHotKey website has been opened, please update to the latest version."
		. "`n"
		. "`n" "If you need help, you can contact me on GitHub / Discord / POE Forums. Links are available on the GitHub repository."
		. "`n" "The application will terminate upon closing this box."
		. "`n"
		. "`n" PROGRAM.LINK_GITHUB)
		ExitApp
	}
}

FileDelete(filePath) {
	while FileExist(filePath) {
		FileDelete,% filePath
		Sleep 100
	}
}

AutomaticallyTransformKeyStr_ToVirtualKeyOrScanCodeStr(hk) {
	if IsContaining( SubStr(hk, 1, 2), "SC,VK" )
		return hk
		
	hkSC := TransformKeyStr_ToScanCodeStr(hk)
	if !(hkSC)
		hkSC := TransformKeyStr_ToVirtualKeyStr(hk)
	
	return hkSC
}

TransformKeyStr_ToVirtualKeyStr(hk) {
	hkStr := hk, hkLen := StrLen(hk)
	Loop 9 {
		char := SubStr(hkStr, A_Index, 1)
		if IsIn(char, "^,+,!,#,<,>,*,~,$") && (hkLen > A_Index)
			hkStr_final .= char
		else
			Break
	}
	StringTrimLeft, hkStr_noMods, hkStr,% StrLen(hkStr_final)
	hkVK := GetKeyVK(hkStr_noMods), hkVK := Format("VK{:X}", hkVK)
	hkStr_final .= hkVK

    if (hkVK = "VK0")
        return

	return hkStr_final
}

TransformKeyStr_ToScanCodeStr(hk) {
	hkStr := hk, hkLen := StrLen(hk)
	Loop 9 {
		char := SubStr(hkStr, A_Index, 1)
		if IsIn(char, "^,+,!,#,<,>,*,~,$") && (hkLen > A_Index)
			hkStr_final .= char
		else
			Break
	}
	StringTrimLeft, hkStr_noMods, hkStr,% StrLen(hkStr_final)
	hkSC := GetKeySC(hkStr_noMods), hkSC := Format("SC{:X}", hkSC)
	hkStr_final .= hkSC

    if (hkSC = "SC0")
        return

	return hkStr_final
}

RemoveModifiersFromHotkeyStr(hk, returnMods=False) {
	hkStr := hk, hkLen := StrLen(hk), charsToRemove := 0
	Loop 9 {
		char := SubStr(hkStr, A_Index, 1)
		if IsIn(char, "^,+,!,#,<,>,*,~,$") && (hkLen > A_Index)
			charsToRemove++
		else
			Break
	}
	if (returnMods=False) {
		StringTrimLeft, hkStrNoMods, hkStr, %charsToRemove%
		return hkStrNoMods
	}
	else {
		StringTrimLeft, hkStrNoMods, hkStr, %charsToRemove%
		StringTrimRight, hkStrOnlyMods, hkStr,% hkLen-charsToRemove
		return [hkStrNoMods,hkStrOnlyMods]
	}
}

Sort(varName, options="") {
	Sort, varName, %options%
	return varName
}

SetBatchLines(value) {
	current := A_BatchLines
	SetBatchLines,%value%
	return current
}

SetControlDelay(value) {
	current := A_ControlDelay
	SetControlDelay,%value%
	return current
}

SetKeyDelay(delay, duration, play=False) {
	if (play=True) {
		currentDelay := A_KeyDelayPlay, currentDuration := A_KeyDurationPlay
		SetKeyDelay,%delay%,%duration%,Play
	}
	else {
		currentDelay := A_KeyDelay, currentDuration := A_KeyDuration
		SetKeyDelay,%delay%,%duration%
	}
	return [currentDelay, currentDuration]
}

WinHttpRequest_cURL(URL, ByRef data="", ByRef headers="", options="", isBinaryDL=false) {
	sentData := data, sentHeaders := headers, sentOptions := options
	httpRet := WinHttpRequest(URL, data, headers, options)
	if (httpRet != "") {
		return httpRet
	}
	else {
		logsStr := "Failed WinHttpRequest:"
		. "`n-------URL-------`n" url
		. "`n`n-------SENT DATA-------`n" sentData
		. "`n`n-------SENT HEADERS-------`n" sentHeaders
		. "`n`n-------SENT OPTIONS-------`n" sentOptions
		. "`n`n-------RETURNED DATA-------`n" data
		. "`n`n-------RETURNED HEADERS-------`n" headers
		AppendToLogs(logsStr)
	}

	; Try a cURL request
	data := sentData, headers := sentHeaders, options := sentOptions
	headersObj := []
	Loop, Parse, headers,% "`n"
	{
		headersObj.Push(A_LoopField)
	}
	data := cURL_Download(url, data, headersObj, options, useFallback:=false, critical:=False, binaryDL:=isBinaryDL, "", curlHeaders, handleAccessForbidden:=True, returnCurlCmd:=True)
	headers := headersObj, curlCmd := returnCurlCmd

	if (data != "") {
		return
	}
	else {
		logsStr := "Failed cURL Request:"
		. "`n-------URL-------`n" url
		. "`n`n-------CURL HEADERS-------`n" curlHeaders
		. "`n`n-------CURL CMD-------`n" curlCmd
		. "`n`n-------SENT DATA-------`n" sentData
		. "`n`n-------SENT HEADERS-------`n" sentHeaders
		. "`n`n-------SENT OPTIONS-------`n" sentOptions
		. "`n`n-------RETURNED DATA-------`n" data
		. "`n`n-------RETURNED HEADERS-------`n" headers
		AppendToLogs(logsStr)
	}	
}

CaculateCenter(howManyElements, startingX, startingY, elementWidth, elementHeight, maxElementsPerRow, spaceWidth) {
	; Calculate the space between each
	spaceBetweenElements := (spaceWidth/howManyElements)

	While (maxElementsPerRow > maxElementsPerRow) { ; So that icons do not overlap
		maxElementsPerRow := (maxElementsPerRow)?(maxElementsPerRow-1):(howManyElements-1)
		spaceBetweenElements := (spaceWidth/maxElementsPerRow)
	}
	spaceBetweenElements := Round(spaceBetweenElements)
	firstElementX := (spaceWidth-(spaceBetweenElements*(maxElementsPerRow-1)+elementWidth))/2 ; We retrieve the blank space after the lastest icon in the row
																				 			  ;	then divide this space in two so icons are centered
	firstElementX := Round(firstElementX)
	firstElementX += startingX
	; Create the game icon buttons
	elementsPositions := {}
	Loop % howManyElements {
		thisRow++
		if (thisRow > maxElementsPerRow) { ; Draw a new row
			thisRow := 1, ypos += elementHeight
			divider := (remainingElements <= maxElementsPerRow)?(remainingElements):(maxElementsPerRow) ; Caculate the divider, so we can center the new row
			firstElementX := (spaceWidth-(spaceBetweenElements*(divider-1)+elementWidth))/2 ; Same thing as the firstElementX above
		}
		xpos := (thisRow=1)?(firstElementX)
			   :(xpos+spaceBetweenElements)
		ypos := (!ypos)?(startingY):(ypos)

		elementsPositions[A_Index] := {}
		elementsPositions[A_Index]["X"] := xpos
		elementsPositions[A_Index]["Y"] := ypos

		remainingElements--
	}

	Return elementsPositions
}

StrTrimLeft(var, trimCount) {
	StringTrimLeft, var, var, %trimCount%
	return var
}

StrTrimRight(var, trimCount) {
	StringTrimRight, var, var, %trimCount%
	return var
}

ControlGetPos(ctrlHwnd) {
	global
	local X, Y, W, H
	ControlGetPos, X, Y, W, H,, % "ahk_id " ctrlHwnd
	return {X:X,Y:Y,W:W,H:H}
}

GetScanCodes() {
	; Credits to TradeMacro for the IDs
	; example results: 0xF0020809/0xF01B0809/0xF01A0809
	; 0809 is for "English United Kingdom"
	; 0xF002 = "Dvorak"
	; 0xF01B = "Dvorak right handed"
	; 0xF01A = "Dvorak left handed"
	; 0xF01C0809 = some other Dvorak layout
	; 0xF01C0409 = programmer's dvorak

	kbLayoutID := GetKeyboardLayout()
	if RegExMatch(kbLayoutID, "i)^(0xF002|0xF01B|0xF01A|0xF01C0809|0xF01C0409).*") { ; dvorak
		scanCodes := {"c": "sc017", "v": "sc034", "f": "sc015", "a": "sc01E", "Enter": "sc01C"}
	}
	else { ; default
		scanCodes := {"c": "sc02E", "v": "sc02f", "f": "sc021", "a": "sc01E", "Enter": "sc01C"}
	}
	return scanCodes
}

GetKeyboardLayout() {
	; Credits: YMP
	; https://autohotkey.com/board/topic/43043-get-current-keyboard-layout/?p=268123
	formatInteger := A_FormatInteger
	SetFormat, Integer, H
	WinGet, WinID, , A
	ThreadID := DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
	InputLocaleID := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")	
	SetFormat, Integer,% formatInteger

	return InputLocaleID
}

GetGlobalVar(var) {
	global
	local retValue
	retValue := %var%
	return retValue
}

ObjReplace(obj1, obj2) {
/*  Modified version of ObjFullyClone
    Any key from obj2 will replace obj1 keys, as long as they also exist in obj1
    If they don't exist, they will be deleted from the returned obj
*/
	if IsObject(obj1) && !IsObject(obj2)
		return obj1
	else if !IsObject(obj1) && IsObject(obj2)
		return obj2 

    nobj1 := obj1.Clone()
    nobj2 := obj2.Clone()
    nobj3 := obj1.Clone()

    for k,v in nobj1 {
        if IsObject(v) && !IsObject(nobj3[k]) && !nobj3.HasKey(k)
            nobj3[k] := ObjFullyClone(v)
        else if IsObject(v) && IsObject(nobj3[k])
            nobj3[k] := A_ThisFunc.(nobj3[k], obj1[k])
        else {
            if !nobj3.HasKey(k)
                nobj3[k] := v   
            for k2,v2 in v
                if !nobj3[k].HasKey(k2)
                    nobj3[k][k2] := v2         
        }
    }
 
    for k,v in nobj2 {
        if IsObject(v) && IsObject(nobj1[k]) && nobj1.HasKey(k)
            nobj3[k] := A_ThisFunc.(nobj1[k], v)
        else if IsObject(v) && IsObject(nobj1[k])
            nobj3[k] := A_ThisFunc.(nobj3[k], obj2[k])
        else {
            if (nobj1.HasKey(k)) && !IsObject(nobj1[k]) && !IsObject(v)
                nobj3[k] := v
            else if !nobj1.HasKey(k)
                nobj3.Delete(k)
            for k2,v2 in v
                if nobj1[k].HasKey(k2)
                    nobj3[k][k2] := v2
                else
                    nobj3[k].Delete(k2)
        }
    }

	return nobj3
}

ObjMerge(obj1, obj2) {
/*  Modified version of ObjFullyClone to allow merging two objects
	In case value exists both in obj1 and obj2, obj1 will be prioritary
*/
	if IsObject(obj1) && !IsObject(obj2)
		return obj1
	else if !IsObject(obj1) && IsObject(obj2)
		return obj2 

    nobj1 := obj1.Clone()
    nobj2 := obj2.Clone()
    nobj3 := obj1.Clone()

    for k,v in nobj1 {
        if IsObject(v) && !IsObject(nobj3[k]) && !nobj3.HasKey(k)
            nobj3[k] := ObjFullyClone(v)
        else if IsObject(v) && IsObject(nobj3[k])
            nobj3[k] := A_ThisFunc.(nobj3[k], obj1[k])
        else {
            if !nobj3.HasKey(k)
                nobj3[k] := v   
            for k2,v2 in v
                if !nobj3[k].HasKey(k2)
                    nobj3[k][k2] := v2         
        }
    }
 
    for k,v in nobj2 {
        if IsObject(v) && !IsObject(nobj3[k]) && !nobj3.HasKey(k)
            nobj3[k] := ObjFullyClone(v)
        else if IsObject(v) && IsObject(nobj3[k])
            nobj3[k] := A_ThisFunc.(nobj3[k], obj2[k])
        else {
            if !nobj3.HasKey(k)
                nobj3[k] := v  
            for k2,v2 in v
                if !nobj3[k].HasKey(k2)
                    nobj3[k][k2] := v2
        }
    }

	return nobj3
}

ObjFullyClone(obj) {
/*	Credits: fincs
	autohotkey.com/board/topic/69542-objectclone-doesnt-create-a-copy-keeps-references/?p=440435
*/
	nobj := obj.Clone()
	for k,v in nobj
		if IsObject(v)
			nobj[k] := A_ThisFunc.(v)
	return nobj
}


FolderExist(folder) {
	if InStr(FileExist(folder), "D")
		return True
}

PlaySound(sndFile) {
	; 0x1 allows sound to be interrupted by next one
	return DllCall("winmm.dll\PlaySound", AStr, sndFile, UInt, 0, UInt, 0x1)
}

IsWindowInScreenBoundaries(_win, _screen="All", _adv=False) {
/*	Returns whether at least 1/3 of the window is within the screen or not
*/
	hw := DetectHiddenWindows("On")

	WinGetPos, x, y, w, h,% _win
	win := {x:x,y:y,h:h,w:w}

	DetectHiddenWindows(hw)

	mons := {}
	if (_screen="All") { ; get all mons wa into their own sub array
		SysGet, monCount, MonitorCount
		Loop %monCount% {
			SysGet, mon, Monitor, %A_Index%
			mons[A_Index] := {T:monTop,B:monBottom,L:monLeft,R:monRight}
		}	
	}
	else { ; only selected monitor into its own sub array
		SysGet, mon, Monitor, %_screen%
		mons.1 := {T:monTop,B:monBottom,L:monLeft,R:monRight}
	}

	if (_adv)
		advObj := {}
	for monIndex, nothing in mons { ; for every subarray
		mon := mons[monIndex]

		; check if 1/3 of window is in horizontal boundaries
		if (win.x < mon.l) ; left 
			hor := IsBetween(win.x+win.w/1.5, mon.l, mon.r)
		else ; right
			hor := IsBetween(win.x+win.w/3, mon.l, mon.r)
		; check if 1/3 of window is in vertical boundaries
		if (win.y < mon.t) ; top
			ver := IsBetween(win.y+win.h/1.5, mon.t, mon.b)
		else ; bottom
			ver := IsBetween(win.y+win.h/3, mon.t, mon.b)

		isInHor := hor=True?True:isInHor
		isInVer := ver=True?True:isInVer

		if (_adv)
			advObj[monIndex] := {"Mon_T": mon.t, "Mon_B": mon.b, "Mon_L": mon.l, "Mon_R": mon.r
				, "Win_X": win.x, "Win_Y": win.y, "Win_W": win.w, "Win_H": win.h
				, "IsInBoundaries_H": hor, "IsInBoundaries_V": ver}
	}
	if (isInHor=True && isInVer=True && _adv=False)
		return True

	if (_adv)
		return advObj
}

GetKeyStateFunc(which) {

	if (which = "All") {
		shiftState := (GetKeyState("Shift"))?("Down"):("Up")
		shiftStateL := (GetKeyState("LShift"))?("Down"):("Up")
		shiftStateR := (GetKeyState("RShift"))?("Down"):("Up")

		ctrlState := (GetKeyState("Ctrl"))?("Down"):("Up")
		ctrlStateL := (GetKeyState("LCtrl"))?("Down"):("Up")
		ctrlStateR := (GetKeyState("RCtrl"))?("Down"):("Up")

		altState := (GetKeyState("Alt"))?("Down"):("Up")
		altStateL := (GetKeyState("LAlt"))?("Down"):("Up")
		altStateR := (GetKeyState("RAlt"))?("Down"):("Up")

		WinStateL := (GetKeyState("LWin"))?("Down"):("Up")
		WinStateR := (GetKeyState("RWin"))?("Down"):("Up")

		obj := {Shift: shiftState, LShift: shiftStateL, RShift: shiftStateR
			, Ctrl: ctrlState, LCtrl: ctrlStateL, RCtrl: ctrlStateR
			, Alt: altState, LAlt: altStateL, RAlt: altStateR
			, LWin: WinStateL, RWin: WinStateR}

		return obj
	}
	else {
		obj := {}
		Loop, Parse, which,% ","
		{
			key := A_LoopField, _count := A_Index
			%key%State := (GetKeyState(key))?("Down"):("Up")
			obj[key] := %key%State
		}

		if (_count = 1) {
			return %key%State
		}
		else 
			return obj
	}
}

SetKeyStateFunc(which) {
	for key, state in which
		str .= "{" key " " state "}"

	if (str)
		Send %str%
}

GetWindowClientInfos(winName) {
/*	Source:
		noname: 		http://autohotkey.com/board/topic/77915-get-client-window/?p=495250
		arcaine.net: 	http://arcaine.net/l2/AtomixMacro/Unsupported/CP&CTRL.ahk
						http://arcaine.net/l2/AtomixMacro/AtomixMacro.ahk

    Edited to add support on AHK U64

	Allows to get a window client infos
*/
    WinGet, hwnd , ID, %winName%

    WinGetPos, , , , Window_Height, ahk_id %hwnd%
    VarSetCapacity(rcClient, 12+A_PtrSize, 0)          ; rcClient Structure 
    DllCall("user32\GetClientRect","uint", hwnd ,"uint",&rcClient)  
    rcClient_x   := NumGet(rcClient, 0, "int")
    rcClient_y   := NumGet(rcClient, 4, "int")
    rcClient_r   := NumGet(rcClient, 8, "int")
    rcClient_b   := NumGet(rcClient, 12, "int")

    VarSetCapacity(pwi, 64+A_PtrSize, 0)
    DllCall("GetWindowInfo", "UInt", hwnd, "UInt", &pwi)
    
    bx := NumGet(pwi, 48, "int") ; border width
    by := NumGet(pwi, 52, "int") ; border height
    RealX := bx
    RealY := Window_Height - by - rcClient_b
    RealWidth := rcClient_r
    RealHeight := rcClient_b

    return {X:RealX, Y:Realy, W:RealWidth, H:RealHeight}
}


RemoveTrailingZeroes(num) {
	num := RTrim(num, "0")
	if ( SubStr(num, 0) = "." ) {
		StringTrimRight, num, num, 1
	}
	return num
}

MultiplyBy(byWhat, ByRef num1, ByRef num2="", ByRef num3="", ByRef num4="", ByRef num5="", ByRef num6="", ByRef num7="", ByRef num8="", ByRef num9="", ByRef num10="") {
	num1 *= byWhat
	num2 *= byWhat
	num3 *= byWhat
	num4 *= byWhat
	num5 *= byWhat
	num6 *= byWhat
	num7 *= byWhat
	num8 *= byWhat
	num9 *= byWhat
	num10 *= byWhat
}

RandomStr(l = 24, i = 48, x = 122) { ; length, lowest and highest Asc value
	/*	Credits: POE-TradeMacro
		https://github.com/PoE-TradeMacro/POE-TradeMacro
	*/
	Loop, %l% {
		Random, r, i, x
		s .= Chr(r)
	}
	s := RegExReplace(s, "\W", "i") ; only alphanum.
	
	Return, s
}

SplitHotkeyFromModifiers(_hotkey) {
	len := StrLen(_hotkey)
	
	Loop, Parse,% _hotkey
    {
        parseIndex := A_Index
        curChar := A_LoopField, nextChar := SubStr(_hotkey, parseIndex+1, 1), curAndNextChars := curChar . nextChar

        if (skipNextChar) {
            skipNextChar := False
        }
        else if IsIn(curAndNextChars, "<^,>^,<!,>!,<+,>+,<#,>#") {
            mod := curChar = "<" ? "L" : curChar = ">" ? "R" : ""
            mod .= nextChar = "^" ? "Ctrl" : nextChar = "!" ? "Alt" : nextChar = "+" ? "Shift" : nextChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
            skipNextChar := True
        }
        else if IsIn(curChar, "^,!,+,#") && (parseIndex < len) {
            mod := curChar = "^" ? "Ctrl" : curChar = "!" ? "Alt" : curChar = "+" ? "Shift" : curChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
        }
        else {
            hkNoMods := SubStr(_hotkey, parseIndex)
            StringUpper, hkNoMods, hkNoMods, T
            Break
        }
    }

	hkModsOnly := StrTrimRight(_hotkey, StrLen(hkNoMods))
	return {Key:hkNoMods, Modifiers:hkModsOnly}
}

Transform_ReadableHotkeyString_Into_AHKHotkeyString(_hotkey, _delimiter="+") {
	len := StrLen(_hotkey)
    Loop 2 {
        mainLoopIndex := A_Index
        Loop, Parse,% _hotkey,% _delimiter
        {
            parseIndex := A_Index

            if (mainLoopIndex = 1) 
                parseTotal := parseIndex
            else {
                firstChar := SubStr(A_LoopField, 1, 1)
                if IsIn(A_LoopField, "Ctrl,LCtrl,RCtrl") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<^" : firstChar = "R" ? ">^" : "^"
                else if IsIn(A_LoopField, "Shift,LShift,RShift") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<+" : firstChar = "R" ? ">+" : "+"
                else if IsIn(A_LoopField, "Alt,LAlt,RAlt") && (parseIndex < parseTotal)
                    mod .= firstChar = "L" ? "<!" : firstChar = "R" ? ">!" : "!"
                else if IsIn(A_LoopField, "LWin,RWin") && (parseIndex < parseTotal)
                    mod .= "#" ; firstChar = "L" ? "<#" : firstChar = "R" ? ">#" : "#"
                else
                    hk := A_LoopField
            }
        }
    }

    lastChar := SubStr(_hotkey, 0, 1)
    if (lastChar = _delimiter) && (hk = "")
        hk := lastChar

    fullHk := mod . hk
    return fullHk
}

Transform_AHKHotkeyString_Into_InputSring(_hotkey) {
	readable := Transform_AHKHotkeyString_Into_ReadableHotkeyString(_hotkey)
	len := StrLen(_hotkey), inputsObj := {}
    Loop 2 {
        mainLoopIndex := A_Index
        Loop, Parse,% readable,% "+"
        {
            parseIndex := A_Index

            if (mainLoopIndex = 1) 
                parseTotal := parseIndex
            else {
                firstChar := SubStr(A_LoopField, 1, 1)
                if IsIn(A_LoopField, "Ctrl,LCtrl,RCtrl") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "Shift,LShift,RShift") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "Alt,LAlt,RAlt") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else if IsIn(A_LoopField, "LWin,RWin") && (parseIndex < parseTotal)
                    inputsObj.Push(A_LoopField)
                else
                    inputsObj.Push(A_LoopField)
            }
        }
    }

	for index, _input in inputsObj {
        downInputs .= "{" _input " Down}"
        upInputs := "{" _input " Up}" upInputs
    }

	downAndUpInputs := downInputs . upInputs
    return downAndUpInputs
}

Transform_AHKHotkeyString_Into_ReadableHotkeyString(_hotkey, _delimiter="+") {
	len := StrLen(_hotkey)

	Loop, Parse,% _hotkey
    {
        parseIndex := A_Index
        curChar := A_LoopField, nextChar := SubStr(_hotkey, parseIndex+1, 1), curAndNextChars := curChar . nextChar

        if (skipNextChar) {
            skipNextChar := False
        }
        else if IsIn(curAndNextChars, "<^,>^,<!,>!,<+,>+,<#,>#") {
            mod := curChar = "<" ? "L" : curChar = ">" ? "R" : ""
            mod .= nextChar = "^" ? "Ctrl" : nextChar = "!" ? "Alt" : nextChar = "+" ? "Shift" : nextChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
            skipNextChar := True
        }
        else if IsIn(curChar, "^,!,+,#") && (parseIndex < len) {
            mod := curChar = "^" ? "Ctrl" : curChar = "!" ? "Alt" : curChar = "+" ? "Shift" : curChar = "#" ? "Win" : ""
            modStr .= modStr ? "+" mod : mod
        }
        else {
            hkNoMods := SubStr(_hotkey, parseIndex), hkNoMods := IsContaining(hkNoMods, "SC,VK") ? GetKeyName(hkNoMods) : hkNoMods
            StringUpper, hkNoMods, hkNoMods, T
            Break
        }
    }

    hkStr := modStr ? modStr "+" hkNoMods : hkNoMods
    return hkStr
}

Get_UnderMouse_CtrlHwnd() {
	MouseGetPos, , , , ctrlHwnd, 2
	return ctrlHwnd
}

AutoTrimStr(ByRef string1, ByRef string2="", ByRef string3="", ByRef string4="", ByRef string5="", ByRef string6="", ByRef string7="", ByRef string8="", ByRef string9="", ByRef string10="") {
	_autotrim := A_AutoTrim
	AutoTrim, On

	string1 = %string1%
	string2 = %string2%
	string3 = %string3%
	string4 = %string4%
	string5 = %string5%
	string6 = %string6%
	string7 = %string7%
	string8 = %string8%
	string9 = %string9%
	string10 = %string10%

	AutoTrim, %_autotrim%
}

Set_Format(_NumberType="", _Format="") {
	static prevNumberType, prevFormat
	prevNumberType := _NumberType
	prevFormat := A_FormatFloat

	if (_NumberType = "") && (_Format = "")
		SetFormat, %prevNumberType%, %prevFormat%
	else if (_NumberType) && (_Format = "")
		SetFormat, %_NumberType%, %prevFormat%
	else
		SetFormat, %_NumberType%, %_Format%
}

SetTitleMatchMode(matchMode, matchSpeed="") {
	prevMatchMode := A_TitleMatchMode, prevMatchSpeed := A_TitleMatchModeSpeed

	SetTitleMatchMode,% matchMode
	if (matchSpeed) && IsIn(matchSpeed, "Fast,Slow") {
		SetTitleMatchMode,% matchSpeed
		return [prevMatchMode, prevMatchSpeed]
	}
	return prevMatchMode
}

MsgBox(_opts="", _title="", _text="", _timeout="") {
	global PROGRAM

	if (_title = "")
		_title := PROGRAM.NAME

	MsgBox,% _opts,% _title,% _text,% _timeout
}

Detect_HiddenWindows(state="") {
	return DetectHiddenWindows(state)
}

DetectHiddenWindows(hwNewState="") {
	static hwPrevState
	if (hwNewState="" && hwPrevState) {
		DetectHiddenWindows,% hwPrevState
		Return
	}

	hwPrevState := A_DetectHiddenWindows
	hwNewState := IsIn(hwNewState, True ",On") ? "On" 
		: IsIn(hwNewState, False ",Off") ? "Off" : "Off"
	DetectHiddenWindows,% hwNewState

	return hwPrevState
}

Get_Windows_Title(_filter="", _filterType="", _delimiter="`n") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "Title")
	return returnList
}

Get_Windows_PID(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "PID")
	return returnList
}

Get_Windows_ID(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "ID")
	return returnList
}

Get_Windows_Exe(_filter="", _filterType="", _delimiter=",") {
	returnList := Get_Windows_List(_filter, _filterType, _delimiter, "Exe")
	return returnList
}

Get_Windows_List(_filter, _filterType, _delimiter, _what) {

	_whatAllowed := "ID,PID,ProcessID,Exe,ProcessName,Title"
	if !IsIn(_what, _whatAllowed) {
		Msgbox %A_ThisFunc%(): "%_what%" is not allowed`nAllowed: %_whatAllowed%
		return
	}
	_filterTypeAllowed := "ahk_exe,ahk_id,ahk_pid,Title"
	if !IsIn(_filterType, _filterTypeAllowed) {
		Msgbox %A_ThisFunc%(): "%_filterType%" is not allowed`nAllowed: %_filterTypeAllowed%
		return
	}

	; Assign Cmd
	Cmd := (IsIn(_what, "PID,ProcessID"))?("PID")
			:(IsIn(_what, "Exe,ProcessName"))?("ProcessName")
			:(_what)

	; Assign filter
	filter := (IsIn(_filterType, "ahk_exe,ahk_id,ahk_pid"))?(_filterType " " _filter):(_filter)

	; Assign return
	valuesList := ""
	if IsIn(_delimiter, "Array,[]")
		returnList := []
	else
		returnList := ""

	; Loop through pseudo array
	WinGet, winHwnds, List
	Loop, %winHwnds% {
		loopField := winHwnds%A_Index%
		WinGetTitle, winTitle, %filter% ahk_id %loopField%
		if (_what = "Title")
			value := winTitle
		else 
			WinGet, value, %Cmd%, %filter% ahk_id %loopField%

		if (value) && !IsIn(value, valuesList) && !IsIn(winTitle, "MSCTFIME UI,Default IME") {
			valuesList := (valuesList)?(valuesList "," value):(value)

			if IsIn(_delimiter, "Array,[]")
				returnList.Push(value)
			else
				returnList := (returnList)?(returnList . _delimiter . value):(value)
		}
	}

	Return returnList
}

IsContaining_Parse(_string, _list, _delimiter="`n", _ignore="`r", _getMatch=False) {
	Loop, Parse, _list,%_delimiter%,%_ignore%
		if IsContaining(_string, A_LoopField) {
			if (_getMatch=True)
				return [True, A_LoopField]
			else
				return True
		}
}

IsIn_Parse(_string, _list, _delimiter="`n", _ignore="`r") {
	Loop, Parse, _list,%_delimiter%,%_ignore%
		if (A_LoopField = _string)
			return True
}

IsIn(_string, _list) {
	if _string in %_list%
		return True
}

IsContaining(_string, _keyword) {
	if (_keyword = ",")
		_keyword := ",," ; Need two commas to detect a literal comma

	if _string contains %_keyword%
		return True
}

CoordMode(obj="") {
/*	Param1
 *	ToolTip: Affects ToolTip.
 *	Pixel: Affects PixelGetColor, PixelSearch, and ImageSearch.
 *	Mouse: Affects MouseGetPos, Click, and MouseMove/Click/Drag.
 *	Caret: Affects the built-in variables A_CaretX and A_CaretY.
 *	Menu: Affects the Menu Show command when coordinates are specified for it.

 *	Param2
 *	If Param2 is omitted, it defaults to Screen.
 *	Screen: Coordinates are relative to the desktop (entire screen).
 *	Relative: Coordinates are relative to the active window.
 *	Window [v1.1.05+]: Synonymous with Relative and recommended for clarity.
 *	Client [v1.1.05+]: Coordinates are relative to the active window's client area, which excludes the window's title bar, menu (if it has a standard one) and borders. Client coordinates are less dependent on OS version and theme.
*/
	if !(obj) { ; No param specified. Return current settings
		CoordMode_Settings := {}

		CoordMode_Settings.ToolTip 	:= A_CoordModeToolTip
		CoordMode_Settings.Pixel 	:= A_CoordModePixel
		CoordMode_Settings.Mouse 	:= A_CoordModeMouse
		CoordMode_Settings.Caret 	:= A_CoordModeCaret
		CoordMode_Settings.Menu 	:= A_CoordModeMenu

		return CoordMode_Settings
	}

	for param1, param2 in obj { ; Apply specified settings.
		if param1 not in ToolTip,Pixel,Mouse,Caret,Menu
			MsgBox, Wrong Param1 for CoordMode: %param1%
		else if param2 not in Screen,Relative,Window,Client
			Msgbox, Wrong Param2 for CoordMode: %param2%
		else
			CoordMode,%param1%,%param2%
	}
}

IsBetween(value, first, last) {
   if value between %first% and %last%
      return true
   else
      return false
}

Convert_TrueFalse_String_To_Value(ByRef value) {
	value := (value="True")?(True):(value="False")?(False):(value)
}

Get_MatchingValue_From_Object_Using_Index(obj, specifiedIndex) {
	matchingValue := ""
	for index, value in obj {
		if (index = specifiedIndex) {
			matchingValue := value
			Break
		}
	}
	return matchingValue
}

Get_MatchingIndex_From_Object_Using_Value(obj, specifiedValue) {
	matchingIndex := ""
	for index, value in obj {
		if (value = specifiedValue) {
			matchingIndex := index
			Break
		}
	}
	return matchingIndex
}

IsDigit(str) {
	if str is digit
		return true
	return false
}

IsHex(str) {
	if str is xdigit
		return true
	return false
}

IsSpace(str) {
	if str is Space
		return true
	return false
}

IsInteger(str) {
	str2 := Round(str)
	str := (str=str2)?(str2):(str) ; Fix trailing zeroes
	
	if str is integer
		return true
	return false
}

IsNum(str) {
	if str is number
		return true
	return false
}

Get_ControlCoords(guiName, ctrlHandler) {
/*		Retrieve a control's position and return them in an array.
		The reason of this function is because the variable content would be blank
			unless its sub-variables (coordsX, coordsY, ...) were set to global.
			(Weird AHK bug)
*/
	GuiControlGet, coords, %guiName%:Pos,% ctrlHandler
	return {X:coordsX,Y:coordsY,W:coordsW,H:coordsH}
}

StringIn(string, _list) {
	if string in %_list%
		return true
}

StringContains(string, match) {
	if string contains %match%
		return true
}

Get_TextCtrlSize(txt, fontName, fontSize, maxWidth="", params="", ctrlType="Text") {
/*		Create a control with the specified text to retrieve
 *		the space (width/height) it would normally take
*/
	Gui, GetTextSize:Destroy
	Gui, GetTextSize:Font, S%fontSize%,% fontName
	if (maxWidth) 
		Gui, GetTextSize:Add, %ctrlType%,x0 y0 +Wrap w%maxWidth% hwndTxtHandler,% txt
	else 
		Gui, GetTextSize:Add, %ctrlType%,x0 y0 %params% hwndTxtHandler,% txt
	coords := Get_ControlCoords("GetTextSize", TxtHandler)
	Gui, GetTextSize:Destroy

	return coords

/*	Alternative version, with auto sizing

	Gui, GetTextSize:Font, S%fontSize%,% fontName
	Gui, GetTextsize:Add, Text,x0 y0 hwndTxtHandlerAutoSize,% txt
	coordsAuto := Get_ControlCoords("GetTextSize", TxtHandlerAutoSize)
	if (maxWidth) {
		Gui, GetTextSize:Add, Text,x0 y0 +Wrap w%maxWidth% hwndTxtHandlerFixedSize,% txt
		coordsFixed := Get_ControlCoords("GetTextSize", TxtHandlerFixedSize)
	}
	Gui, GetTextSize:Destroy

	if (maxWidth > coords.Auto)
		coords := coordsAuto
	else
		coords := coordsFixed

	return coords
*/
}

FileDownload(url, dest) {
	UrlDownloadToFile,% url,% dest
	if (ErrorLevel) {
		MsgBox Failed to download file!`nURL: %url%`nDest: %dest%
		return 0
	}
	return 1
}
