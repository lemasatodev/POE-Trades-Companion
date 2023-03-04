/*	by lemasato
	https://github.com/lemasato

	Requirements:
		Class_GUI.ahk	EasyFuncs.ahk

	Usage example:
		hkStr := GUI_SetHotkey.WaitForHotkey()
		MsgBox % hkStr

		#Include Class_GUI.ahk
		#Include Class_GUI_SetHotkey.ahk
		#Include EasyFuncs.ahk

	How this library works:
		Clever combination of a hidden Hotkey control, ways to detect keys not normally supposed by it, and Text control.

		Any time the user is clicking on the window, the Hotkey control will be focused.
		This allows to detect any key the user is pressed, that is supported by the Hotkey control.
		Other keys that aren't normally supported (eg mouse buttons) are intercepted by our #If block.

		Normally, some key combinations (eg Ctrl+Space) aren't supported by the Hotkey control.
		But if we manually set it to ^Space, it works anyway.
		Still, some special combinations (eg mouse buttons) won't be shown on the Hotkey control, no matter what.
		This is where the Text control comes in. Any key combination will be shown on the Text control.

		The key string is being shown in a friendly readable way (eg Ctrl+Space).
		But upon closing the window, the true hotkey will be returned (eg ^Space).
*/

#MenuMaskKey vk07
#If GUI_SetHotkey.IsWinActive()
; Credits to jaco0646 for the original idea of adding non-standard keys to the Hotkey gui control
; https://autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys/

	; List of keys supported
	*F4::
	*AppsKey::
	*BackSpace::
	*Delete::
	*Enter::
	*Escape::
	*LWin::
	*RWin::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
	*XButton1::
	*XButton2::
	*WheelUp::
	*WheelDown::
	*WheelLeft::
	*WheelRight::
	*MButton::
	~*LButton::
	~*RButton::

	thisHotkey := A_ThisHotkey, modifiers := ""

	; Getting modifiers, based on key down press
	modifiers .= GetKeyState("Shift") ? "+" : "", modifiers .= GetKeyState("Ctrl") ? "^" : "", modifiers .= GetKeyState("Alt") ? "!" : ""
	modifiers .= GetKeyState("RWin") ? "#" : "", modifiers .= GetKeyState("LWin") ? "#" : ""

	; Removing *~ from hotkey if containing
	if ( SubStr(thisHotkey, 1, 2) = "~*" && StrLen(thisHotkey) > 2 )
		thisHotkey := StrTrimLeft(thisHotkey, 2)
	if ( SubStr(thisHotkey, 1, 1) = "*" && StrLen(thisHotkey) > 1 )
		thisHotkey := StrTrimLeft(thisHotkey, 1)

	thisHotkey := modifiers . thisHotkey
	
	; Prevent to continue of the hotkey is only Win or click button
	if IsIn(thisHotkey,"LWin,Rwin,LButton,RButton")
		return

	GUI_SetHotkey.SetHotkey(thisHotkey)
	return
#If


Class GUI_SetHotkey {
	
	static sGUI := {}

    Create() {
		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		this.sGUI := new GUI("SetHotkey", "-Caption -Border +HwndhGuiSetHotkey +Label" this.__class ".", "Set Hotkey")
		this.sGUI.SetMargins(0, 0), this.sGUI.SetBackgroundColor("334a5b"), this.sGUI.SetControlsColor("374a58")
		this.sGUI.SetFont("Segoe UI"), this.sGUI.SetFontSize("8"), this.sGUI.SetFontColor("0x80c4ff")

		guiFullWidth := 350, guiFullHeight := 130, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := leftMost+guiWidth
		upMost := borderSize, downMost := upMost+guiHeight

		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			this.sGUI.Add("Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		this.sGUI.Add("Hotkey", "x0 y0 w0 h0 hwndhHK_Hotkey") ; Invisible hotkey control, used to catch user key presses
		this.sGUI.Add("Text", "x" leftMost+10 " y" upMost+10 " w" guiWidth-(10*2) " Center BackgroundTrans hwndhTEXT_Tip", "Press the key combination you would like to set for this hotkey"
		. "`nOnce you are done, click on the ""Accept"" button.")
		this.sGUI.Add("Text", "xp y+15 wp Center BackgroundTrans", "Your hotkey:")
		this.sGUI.Add("Text", "xp y+5 wp Center hwndhTEXT_Hotkey BackgroundTrans Bold c0xE6E6E6", "[ Unassigned ]")	, this.sGUI.BindFunctionToControl("hHK_Hotkey", "OnHotkeyChange")
		this.sGUI.Add("Button", "x" leftMost " y" downMost-25 " w" guiWidth*0.30 " h25 hwndhBTN_Remove", "Remove"), this.sGUI.BindFunctionToControl("hBTN_Accept", "AcceptHotkey")
		this.sGUI.Add("Button", "x+0 y" downMost-25 " w" guiWidth*0.70 " h25 hwndhBTN_Accept", "Accept"), this.sGUI.BindFunctionToControl("hBTN_Remove", "UnsetHotkey")
	
		this.sGUI.BindWindowsMessage(0x202, "WM_LBUTTONUP") ; Allows to always focus the Hotkey control when releasing click on gui 
		this.sGUI.BindWindowsMessage(0x06, "WM_ACTIVATE") ; Allows to always focus the Hotkey control when activating gui
		
		this.sGUI.FocusControl("hHK_Hotkey")
        this.sGUI.Show("w" guiFullWidth " h" guiFullHeight)
		SetControlDelay(delay), SetBatchLines(batch)
    }

	SetHotkey(thisHotkey) {
		; Separating hotkey from modifiers
		if (modifiers) && ( SubStr(thisHotkey, 1, StrLen(modifiers)) = modifiers)
			hotkeyNoMods := StrTrimLeft(thisHotkey, StrLen(modifiers))
		else hotkeyNoMods := thisHotkey

		; Prevent from doing anything if hotkey is empty
		if (hotkeyNoMods="")
			return
		
	 	; Sending hotkey to control	
		this.sGUI.SetControlContent("hTEXT_Hotkey", Transform_AHKHotkeyString_Into_ReadableHotkeyString(modifiers . hotkeyNoMods))
		this.sGUI.Hotkey := modifiers . hotkeyNoMods
	}

	UnsetHotkey() {
		; Set the hotkey as unassigned
		this.sGUI.SetControlContent("hTEXT_Hotkey", "[ Unassigned ]")
		this.sGUI.Hotkey := ""
		this.sGUI.FocusControl("hHK_Hotkey")
	}

	OnHotkeyChange() {
		hkStr := this.sGUI.GetControlContent("hHK_Hotkey") ; Getting hotkey value
		modifiers .= GetKeyState("RWin") ? "#" : "", modifiers .= GetKeyState("LWin") ? "#" : "" ; Those modifiers aren't supported by the Hotkey control
																										 ; This allows them to work with basic keys
		hkStr := modifiers . hkStr

		if (hkStr="") ; Dont do anything if empty
			return
		hkSplit := SplitHotkeyFromModifiers(hkStr)
		if (hkSplit.Key = "") || IsIn(hkStr,"^,!,#,+") ; Dont do anything if only modifiers
			return

		; Set the readable hotkey on the gui, and set the global hotkey string variable
		this.sGUI.Hotkey := ""
		this.sGUI.SetControlContent("hTEXT_Hotkey", Transform_AHKHotkeyString_Into_ReadableHotkeyString(hkStr))
	}

	WaitForHotkey() {
		; Create the gui if it doesn't exist already
		if !WinExist("ahk_id " this.sGUI.Handle)
			GUI_SetHotkey.Create()
		
		; Wait for the gui, and then wait until either the return var has been set or the gui has been closed
		WinWait,% "ahk_id " this.sGUI.Handle
		while !(this.sGUI.Hotkey) || WinExist("ahk_id " this.sGUI.Handle) {
			if !WinExist("ahk_id " this.sGUI.Handle)
				Break
			Sleep 500
		}
		; Returning the value
		hkStr := this.sGUI.Hotkey
		return hkStr
	}

	AcceptHotkey() {
		; Set the global return var, allowing the end the funcs
		this.sGUI.Hotkey := AutomaticallyTransformKeyStr_ToVirtualKeyOrScanCodeStr(this.sGUI.Hotkey)
		this.sGUI.Destroy()
	}

    Destroy() {
		; Generic function
		this.sGUI.Destroy()
	}

	IsWinActive() {
		; Generic function
		if WinActive("ahk_id " this.sGUI.Handle)
			return True
	}

	WM_ACTIVATE(wParam) {
		; Focus the Hotkey control upon window activation
		if !(wParam=True && GUI_SetHotkey.IsWinActive()) ; Make sure this GUI is the one activated
			return

		this.sGUI.FocusControl("hHK_Hotkey")
	}

	WM_LBUTTONUP() {
		; Focus the Hotkey control upon releasing left click anywhere else than the accept/remove button
		if !GUI_SetHotkey.IsWinActive() ; Make sure this GUI is the one activated
			return

		mouseCtrlHwnd := Get_UnderMouse_CtrlHwnd()
		if !IsIn(mouseCtrlHwnd, this.sGUI.Controls.hBTN_Accept "," this.sGUI.Controls.hBTN_Remove)
			this.sGUI.FocusControl("hHK_Hotkey")
	}
}
