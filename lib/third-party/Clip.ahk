Clip(Text="", Reselect="") {
/*		Credits to berban
		https://autohotkey.com/board/topic/70404-clip-send-and-retrieve-text-using-the-clipboard/

		Usage: Call it without any parameters to retrieve the text currently selected.
					Var := Clip() ; will store any selected text in %Var%
			   Or call it with some text in the first parameter to "send" that text via the clipboard and Control+V.
			   		The two are analogous. Clip() is generally preferable for larger amounts of text
					Clip("Some text")
					SendInput {Raw}Some text ; Raw because when using Clip() keyboard combinations like ^s (ctrl+s) will be sent literally. SendInput {Raw} also does this.

		Why use Clip()?
				- Can send and retrieve with one function
				- No delay while sending. Normally you have to wait 400ms or so after sending Control+V before restoring the clipboard's contents, or else sometimes it pastes the backup contents instead.
				  Clip() tasks this to a timer so your script can continue executing.
				- Improves performance by only saving & restoring the clipboard's contents once in the case of rapid clipboard operations.
				- Can reselct pasted text.
*/
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
		If (Text = "") {
			SendInput, ^{sc02e}
			ClipWait, LongCopy ? 0.6 : 0.2, True
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			SendInput, ^{sc02F}
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 50 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
		If (Text = "")
			Return LastClip := Clipboard
		Else If (ReSelect = True) or (Reselect and (StrLen(Text) < 3000)) {
			StringReplace, Text, Text, `r, , All
			SendInput, % "{Shift Down}{Left " StrLen(Text) "}{Shift Up}"
		}
	}
	Return
	Clip:
	Return Clip()
}

/*
;----------------------------------------------------------------------------------------------------
; Simple examples

^1::MsgBox, % "The selected text is: " Clip() ; displays the selected text
^2::Clip(A_Now, True) ; sends A_Now and then re-selects it
^3::Clip("""" Clip() """") ; puts quotes around the selected text. Despite calling Clip() twice, the clipboard is only backed up & restored once



;----------------------------------------------------------------------------------------------------
; More involved example
; The below hotkeys add some of the features of SciTE to notepad.

#IfWinActive ahk_class Notepad ; makes the hotkeys context-sensitive

; Duplicate the above line
^d::
	SendInput {End}+{Home}
	@ := Clip()
	SendInput {End}{Enter}
	Clip(@)
	Return

; Swap with the above line
^t::
	SendInput {End}+{Home}
	@ := Clip()
	SendInput {Del 2}{Up}{Enter}{Up}
	Clip(@)
	Return

; Indent a block of text. (This introduces a small delay for typing a normal tab; to avoid this you can use ^Tab / ^+Tab as a hotkey instead.)
$Tab::
$+Tab::
	TabChar := A_Tab ; this could be something else, say, 4 spaces
	NewLine := "`r`n"
	If ("" <> Text := Clip()) {
		@ := ""
		Loop, Parse, Text, `n, `r
			@ .= NewLine (InStr(A_ThisHotkey, "+") ? SubStr(A_LoopField, (InStr(A_LoopField, TabChar) = 1) * StrLen(TabChar) + 1) : TabChar A_LoopField)
		Clip(SubStr(@, StrLen(NewLine) + 1), 2)
	} Else
		Send % (InStr(A_ThisHotkey, "+") ? "+" : "") "{Tab}"
	Return

#IfWinActive
*/
