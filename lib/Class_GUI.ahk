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

		Gui, %name%:Destroy

		Gui%name% := ""
		Gui%name%_Controls := ""
		Gui%name%_Submit := ""
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

	Font(name, font, size="", qual="") {
		global
		local opts

		; Set values
		size := (size)?(size):(10)
		qual := (qual)?(qual):(5)

		; Add the prefixes
		opts .= " S" size " Q" qual

		; Set the default font settings
		Gui, %name%:Font, %opts%, %font%

		; Add the default font settings values
		Gui%name%["Font"] := font
		Gui%name%["Font_Size"] := size
		Gui%name%["Font_Qual"] := qual
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
			if !ImageButton.Create(GUI.GetGlobal(name, "Controls", vHwnd), imageBtnStyle, imageBtnFontHandle, imageBtnFontSize) {
				return "GUI: """ name """"
				. "`n" "Error: """ ImageButton.LastError """"
				. "`n" "Control: """ vHwnd """ - Control Handle: """ Gui%name%_Controls[vHwnd] """"
				. "`n" "Options: """ opts """"
				. "`n" "ImageButton Font Handle: """ imageBtnFontHandle """"
				. "`n" "ImageButton Font Size: """ imageBtnFontSize """"
				. "`n" "ImageButton Style: """ JSON.Dump(imageBtnStyle) """"
				. "`n`n"
			}
		}
	}

	Show(name, opts="", title="") {
		try Gui, %name%:Show, %opts%, %title%
	}

	GetGlobal(guiName, type, key="") {
		global

		if type in Controls,FontSettings,Submit
		{
			if (key)
				return Gui%guiName%_%Type%[key]

			return Gui%guiName%_%Type%
		}

	}
	SetGlobal(guiName, type, key, value) {
		global

		if type in Controls,FontSettings,Submit
		{
			if (Gui%guiName%_%Type%)
				Gui%guiName%_%Type%[key] := value
		}
	}
}