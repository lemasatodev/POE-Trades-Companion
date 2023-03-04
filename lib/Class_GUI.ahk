/*
	GUI.New("MyGui", ,"Window Title")
	GUI.Font("MyGui", "Segoe UI", 10)
	GUI.Add("MyGui", "Text", "x10 y10 FontArial FontSize20 hwndhTEXT_SomeText", "Some text in another font")
	GUI.Add("MyGui", "Text", "xp y+10 ", "Some text in default font")
	GUI.Show("MyGui")

	MsgBox % GuiMyGui_Controls["hTEXT_SomeText"]
	ListVars

	Esc::ExitApp
*/

Class GUI {

	Destroy(name) {
		global
		local msgID

		Gui, %name%:Hide

		for msgID in Gui%name%_OnMessageObjs
			OnMessage(msgID, Gui%name%_OnMessageObjs[msgID], 0)

		Gui%name% := ""
		Gui%name%_Controls := ""
		Gui%name%_Submit := ""
		Gui%name%_ControlFunctions := ""
		Gui%name%_OnMessageObjs := ""

		Gui, %name%:Destroy
	}

	New(name, opts="", title="") {
		global

		local handleName, guiHandle, guiHandleBak
		local subPat := {}

		; Reset the gui
		Gui, %name%:Destroy
		Gui, %name%:New, %opts%, %title%

		if RegExMatch(opts, "O)\+Hwnd(.*?) ", subPat) { ; Mid parameter
			handleName := subPat.1
			guiHandleBak := guiHandle := %handleName% ; For some reason the value doesn't stay as hex after doing if (guiHandle)
		}
		else if RegExMatch(opts, "O)\+Hwnd(.*)", subPat) { ; End parameter
			handleName := subPat.1
			guiHandleBak :=	guiHandle := %handleName%
		}

		; Reset its associated arrays
		Gui%name% := {}
		Gui%name%_Controls := {}
		Gui%name%_Submit := {}
		Gui%name%_ControlFunctions := {}
		Gui%name%_OnMessageObjs := {}

		if (title)
			Gui%name%["Title"] := title

		if (handleName) {
			if (guiHandle) {
				Gui%name%["Handle"] := guiHandleBak
				Gui%name%["Hwnd"] 	:= guiHandleBak
			}
			else
				MsgBox Class_GUI.ahk: Failed to retrieve the GUI handle.`nGUI: %name%`nOpts: %opts%
		}
	}

	Submit(name, opts="") {
		global

		Gui%name%_Submit := {}
		for ctrlName, ctrlHandle in Gui%name%_Controls {
			GuiControlGet, ctrlcontent, %name%:,% ctrlHandle
			Gui%name%_Submit[ctrlName] := ctrlContent
		}
		Return Gui%name%_Submit
	}

	Font(name, font, size="", qual="", col="") {
		global
		local opts

		; Set values
		size := (size)?(size):(10)
		qual := (qual)?(qual):(5)
		col := (col!="")?(col):("Black")

		; Add the prefixes
		opts .= " S" size " Q" qual " c" col

		; Set the default font settings
		Gui, %name%:Font, %opts%, %font%

		; Add the default font settings values
		Gui%name%["Font"] := font
		Gui%name%["Font_Size"] := size
		Gui%name%["Font_Qual"] := qual
		Gui%name%["Font_Quality"] := qual
		Gui%name%["Font_Color"] := col
	}

	Margin(name, xMargin, yMargin) {
		global

		Gui, %name%:Margin, %xMargin%, %yMargin%
	}

	Color(name, _winColor="", _ctrlColor="") {
		global

		if (_winColor != "" && _ctrlColor="")
			Gui, %name%:Color, %_winColor%
		else if (_winColor = "" && _ctrlColor != "")
			Gui, %name%:Color, , %_ctrlColor%
		else if (_winColor != "" && _ctrlColor != "")
			Gui, %name%:Color, %_winColor%, %_ctrlColor%

		Gui%name%["Background_Color"] := _winColor!=""?_winColor : Gui%name%["Background_Color"]
		Gui%name%["Controls_Color"] := _ctrlColor!=""?_ctrlColor : Gui%name%["Controls_Color"]
	}

	Add(name, type, opts="", content="", imageBtnStyle="", imageBtnFontHandle="", imageBtnFontSize="") {
		static
		local Specials := ["FontSize", "FontQual", "Font", "CheckState", "ControlChooseString"]
		local SpecialParams := {}

		local Statics := ["Hwnd", "V"]
		local pHwnd, pV
		static vHwnd, vV
		pHwnd := "", pV := "", vHwnd := "", vV := ""

		; Parsing parameters
		Loop, Parse, opts,% A_Space
		{
			local opt := A_LoopField

			; Special parameters
			local id, special
			for id, special in Specials {
				local len := StrLen(special)
				local paramName := SubStr(opt, 1, len)
				local paramValue := SubStr(opt, len+1)

				if (paramName = special) {
					opts := StrReplace(opts, opt, "")
					if (paramName = "CheckedState") ; Make sure to have 0 or 1
						paramValue := (paramValue=1)?(1):(0)
					SpecialParams[paramName] := paramValue
					Break
				}
			}

			; Static parameters
			local id, _static
			for id, _static in Statics {
				local len := StrLen(_static)
				local paramName := SubStr(opt, 1, len)
				local paramValue := SubStr(opt, len+1)

				if (paramName = _static) {
					opts := StrReplace(opts, opt, "")
					p%paramName% := paramName
					v%paramName% := paramValue
					Break
				}
			}

		}
		; Adding var name if hwnd provided but no var name
		if (vHwnd)
			pV := "v", vV := vHwnd

		; Font special parameter
		local hasFontParams := (SpecialParams.Font || SpecialParams.FontSize || SpecialParams.FontQual)?(True):(False)
		if (hasFontParams) {
			if (SpecialParams.FontSize)
				SpecialParams.FontSize := "S" SpecialParams.FontSize
			if (SpecialParams.FontQual)
				SpecialParams.FontQual := "Q" SpecialParams.FontQual
			
			if !(SpecialParams.Font) && (SpecialParams.FontSize || SpecialParams.FontQual) ; No font. Has size/qual.
				Gui, %name%:Font,% SpecialParams.FontSize " " SpecialParams.FontQual
			else if (SpecialParams.Font) && !(SpecialParams.FontSize || SpecialParams.FontQual) ; Has font. No size/qual.
				Gui, %name%:Font,,% SpecialParams.Font
			else if (SpecialParams.Font) && (SpecialParams.FontSize || SpecialParams.FontQual) ; Has font. Has size/qual.
				Gui, %name%:Font,% SpecialParams.FontSize " " SpecialParams.FontQual,% SpecialParams.Font
		}

		; Add gui control
		try {
			if (type = "ImageButton") {
				Gui, %name%:Add, Button, %opts% %pHwnd%%vHwnd% %pV%%vV%, %content%
			}
			else
				Gui, %name%:Add, %type%, %opts% %pHwnd%%vHwnd% %pV%%vV%, %content%
		}
		catch e {
			MsgBox,% 4096+16, %A_ScriptName%,% "Class_GUI.ahk:" . "`nFailed to create control."	. "`n" . "`nMessage: " e.Message . "`nExtra: " e.Extra
				. "`n" . "`nGUI Name: " name . "`nControl type: " type . "`nOptions: " opts . "`nControl handle: " vHwnd . "`nControl variable: " vV . "`nContent: " content
		}

		; Add handle if existing
		if (vHwnd) {
			GUI.SetGlobal(name, "Controls", vHwnd, %vHwnd%)
		}

		; Restore font
		if (hasFontParams) {
			Gui, %name%:Font,% "S" Gui%name%.Font_Size " Q" Gui%name%.Font_Qual,% Gui%name%.Font
		}

		; Check box
		if (SpecialParams.CheckState = 0 || SpecialParams.CheckState = 1) {
			GuiControl, %name%:,% Gui%name%_Controls[vHwnd],% SpecialParams.CheckState
		}

		; Control choose
		if (SpecialParams.ControlChooseString) {
			param := SpecialParams.ControlChooseString
			param := StrReplace(param, "%A_Space%", " ")
			GuiControl, %name%:ChooseString,% Gui%name%_Controls[vHwnd],% param
		}

		if (type = "ImageButton") {
			if !ImageButton.Create(GUI.GetGlobal(name, "Controls", vHwnd), imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
				Gui%name%["ImageButton_Errors"] .= "GUI: """ name """"
				. "`n" "Error: """ ImageButton.LastError """"
				. "`n" "Control: """ vHwnd """ - Control Handle: """ Gui%name%_Controls[vHwnd] """"
				. "`n" "Options: """ opts """"
				. "`n" "ImageButton Font Handle: """ imageBtnFontHandle """"
				. "`n" "ImageButton Font Size: """ imageBtnFontSize """"
				. "`n" "ImageButton Style: """ JSON.Dump(imageBtnStyle) """"
				. "`n`n"
		}
	}

	ImageButtonUpdate(btnHwnd, imageBtnStyle, imageBtnFontHandle="", imageBtnFontSize="") {
		if !ImageButton.Create(btnHwnd, imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
			MsgBox % "Class_GUI.ahk: ImageButtonUpdate error."
			. "`n" "Error: " ImageButton.LastError
			. "`n"
			. "`n" "Function parameters:"
			. "`n" "Button Handle: """ btnHwnd """"
			. "`n" "ImageButton Style: """ JSON_Dump(imageBtnStyle) """"
			. "`n" "Font Handle: """ imageBtnFontHandle """"
			. "`n" "Font Size: """ imageBtnFontSize """"
	}

	ImageButtonChangeCaption(btnHwnd, btnCaption, imageBtnStyle, imageBtnFontHandle="", imageBtnFontSize="") {
		; Set caption text
		ControlSetText, , %btnCaption%, ahk_id %btnHwnd%
		; Make sure that caption is changed before continuing
		triesBeforeSetAgain := 3
		while (curCaption != btnCaption) {
			ControlGetText, curCaption, , ahk_id %btnHwnd%
			ControlSetText, , %btnCaption%, ahk_id %btnHwnd%
			/*
			triesBeforeSetAgain--
			if (triesBeforeSetAgain=0) {
				triesBeforeSetAgain := 3
				ControlSetText, , %btnCaption%, ahk_id %btnHwnd%
			}
			*/
			Sleep 1
		}
		; Calling imagebutton to set new caption
		if !ImageButton.Create(btnHwnd, imageBtnStyle, imageBtnFontHandle, imageBtnFontSize)
			MsgBox % "Class_GUI.ahk: ImageButtonChangeCaption error."
			. "`n" "Error: " ImageButton.LastError
			. "`n"
			. "`n" "Function parameters:"
			. "`n" "Button Handle: """ btnHwnd """"
			. "`n" "ImageButton Style: """ JSON_Dump(imageBtnStyle) """"
			. "`n" "Font Handle: """ imageBtnFontHandle """"
			. "`n" "Font Size: """ imageBtnFontSize """"
	}

	Show(name, opts="", title="") {
		try
			Gui, %name%:Show, %opts%, %title%
		catch e
			AppendToLogs(A_ThisFunc " failed with params:"
			. "`nname: """ name """`nopts: """ opts """`ntitle: """ title """"
			. "`nAdditional informations: what: """ e.what """`nfile: """ e.file """"
			. "`nline: """ e.line """`nmessage: """ e.message """`nextra: """ e.extra """")
	}

	GetGlobal(guiName, type="", key="") {
		global

		if type in Controls,Submit
		{
			if (key)
				return Gui%guiName%_%Type%[key]

			return Gui%guiName%_%Type%
		}
		else
			return Gui%guiName%[key]

	}
	SetGlobal(guiName, type, key, value) {
		global

		if type in Controls,Submit
		{
			if (Gui%guiName%_%Type%)
				Gui%guiName%_%Type%[key] := value
		}
	}

	GetControlPos(guiName, ctrlName) {
		global
		local ctrlPos, ctrlPosX, ctrlPosY, ctrlPosW, ctrlPosH
		GuiControlGet, ctrlPos , %guiName%:Pos,% Gui%guiname%_Controls[ctrlName]
		return {X:ctrlPosX,Y:ctrlPosY,W:ctrlPosW,H:ctrlPosH}
	}

	MoveControl(guiName, ctrlName, opts="") { 
		global
		; if IsContaining(opts, "Center")
		; 	centerCtrl := True, opts := StrReplace(opts, "Center", "")
		GuiControl, %guiName%:Move,% Gui%guiName%_Controls[ctrlName],% opts
		; if (centerCtrl)
			; GuiControl, %guiName%:+Center,% Gui%guiName%_Controls[ctrlName]
	}

	OnMessageBind(guiClass, guiName, msgID, funcName, params*) {
		global
		local __f

		if ( params.Count() )
			Gui%guiName%_OnMessageObjs[msgID] := %guiClass%[funcName].Bind(guiClass, params*)
		else
			Gui%guiName%_OnMessageObjs[msgID] := %guiClass%[funcName].Bind(guiClass)

		OnMessage(msgID, Gui%guiName%_OnMessageObjs[msgID])
	}

	BindFunctionToControl(guiClass, guiName, ctrlName, funcName, params*) {
		global
		local __f

		if ( params.Count() ) {
			__f := %guiClass%[funcName].Bind(guiClass, params*)
			Gui%guiName%_ControlFunctions[ctrlName] := {Function: funcName, Params: [params*]}
		}
		else {
			__f := %guiClass%[funcName].Bind(guiClass)
			Gui%guiName%_ControlFunctions[ctrlName] := {Function: funcName}
		}
		
		GuiControl, %guiName%:+g,% Gui%guiName%_Controls[ctrlName],% __f
	}

	DisableControlFunction(guiClass, guiName, ctrlName) {
		global
		GuiControl, %guiName%:-g,% Gui%guiName%_Controls[ctrlName]
	}

	EnableControlFunction(guiClass, guiName, ctrlName) {
		global

		if IsObject(Gui%guiName%_ControlFunctions[ctrlName].Params)
			__f := %guiClass%[Gui%guiName%_ControlFunctions[ctrlName].Function].Bind(guiclass, Gui%guiName%_ControlFunctions[ctrlName].Params*)
		else
			__f := %guiClass%[Gui%guiName%_ControlFunctions[ctrlName].Function].Bind(guiclass)
			
		GuiControl, %guiName%:+g,% Gui%guiName%_Controls[ctrlName],% __f
	}

	Get_CtrlVarName_From_Hwnd(guiName, ctrlHwnd) {
	GuiControlGet, ctrlName, %guiName%:Name,% ctrlHwnd
	return ctrlName
}

	SetDefault(guiName) {
		global
		Gui,%guiName%:Default
	}
}