SetEditCueBanner(HWND, Cue) {  ; requires AHL_L
/*	Set a gray placeholder text to a EDIT gui econtrol
	
	Credits: just me
	autohotkey.com/board/topic/76529-solvedgray-placeholder-text/?p=486765
*/
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}