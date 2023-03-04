class GUI_SimpleWarn {
	
	Show(_title, _msg, _colorBckgrnd, _colorMsg, params="") {
		global GuiSimpleWarn, GuiSimpleWarn_Controls, GuiSimpleWarn_Submit

		delay := SetControlDelay(0), batch := SetBatchLines(-1)

		baseWidth := 350, baseHeight := 50
		fontName := "Consolas", fontSize := "10 Bold"

		borderSize := 2
		xOffset := 10, yOffset := 5

		msgTexTSize := Get_TextCtrlSize(_msg, "Consolas", "10 Bold")
		titleTextSize := Get_TextCtrlSize(_title, "Consolas", "10 Bold")
		guiWidth := (msgTexTSize.W > baseWidth-(xOffset*2))?(msgTexTSize.W+(xOffset*2)):(baseWidth)
		guiHeight := (_title && _msg)?(titleTextSize.H+msgTexTSize.H-(2*yOffset))
					:(_title && !_msg)?(titleTextSize.H(2*yOffset))
					:(!_title && _msg)?(msgTexTSize.H+(2*yOffset))
					:(titleTextSize.H+msgTexTSize.H-(2*yOffset))

		Gui.New("SimpleWarn", "+AlwaysOnTop +ToolWindow -Caption -Border +LabelGUI_SimpleWarn_ +HwndhGuiSimpleWarn", "POE TC - Warning")
		Gui.Margin("SimpleWarn", 0, 0)
		
		Gui.Color("SimpleWarn", _colorBckgrnd)
		Gui.Font("SimpleWarn", fontName, "10 Bold")
		Gui.Add("SimpleWarn", "Progress", "x0" . " y0" . " h" borderSize . " w" guiWidth . " Background" _colorMsg) ; Top
		if (_title) {
			Gui.Add("SimpleWarn", "Text", "x" xOffset " w" guiWidth-(xOffset*2) " y" yOffset " c" _colorMsg "  Center BackgroundTrans Section", _title)
			Gui.Add("SimpleWarn", "Progress", "x" xOffset . " y+5 h" borderSize . " w" guiWidth-(xOffset*2) . " Background" _colorMsg " Section") ; Underline
		}
		Gui.Add("SimpleWarn", "Progress", "x" guiWidth-borderSize . " y0" . " h" guiHeight . " w" borderSize . " Background" _colorMsg) ; Right
		Gui.Add("SimpleWarn", "Progress", "x0" . " y" guiHeight-borderSize . " h" borderSize . " w" guiWidth . " Background" _colorMsg) ; Bot
		Gui.Add("SimpleWarn", "Progress", "x0" . " y0" . " h" guiHeight . " w" borderSize . " Background" _colorMsg) ; Left
		Gui.Add("SimpleWarn", "Text", "x" xOffset " ys+" yOffset " w" guiWidth-(xOffset*2) " hwndhMsg c" _colorMsg " Center BackgroundTrans", _msg)

		Gui.Add("SimpleWarn", "Text", "x0 y0 w" guiWidth " h" guiHeight " BackgroundTrans gGUI_SimpleWarn_OnLeftClick")
		Gui.Show("SimpleWarn", "w" guiWidth " h" guiHeight)
		SetControlDelay(delay), SetBatchLines(batch)

		WinWait,% "ahk_id " GUISimpleWarn.Hwnd

		if (params.CloseOnClick) {
			static closeOnClick
			closeOnClick := True
		}

		if (params.CountDown) {
			static _count
			_count := params.CountDown_Count, _timer := (params.CountDown_Timer)?(params.CountDown_Timer):(1000)
			SetTimer, GUI_SimpleWarn_CountDown,% _timer
		}
		if (params.WaitClose) {
			WinWaitClose,% "ahk_id " GUISimpleWarn.Hwnd
		}
		Return

		GUI_SimpleWarn_ContextMenu:
			GoSub GUI_SimpleWarn_OnLeftClick
		Return

		GUI_SimpleWarn_OnLeftClick:
			if (closeOnClick) {
				GUI_SimpleWarn.Destroy()
			}
		Return

		GUI_SimpleWarn_CountDown:
			if (!_count || _count=1) {
				
				GUI_SimpleWarn.Destroy()
				Return
			}

			GUI_SimpleWarn.Submit()
			textContent := GuiSimpleWarn_Submit["hMsg"]

			StringReplace, newTextContent, textContent, %_count%,%  _count-1
			GuiControl, SimpleWarn:,% GuiSimpleWarn_Controls["hMsg"],% newTextContent

			_count--
		Return

		GUI_SimpleWarn_Close:
			Gui_SimpleWarn.Destroy()
		Return
		GUI_SimpleWarn_Escape:
			GoSub GUI_SimpleWarn_Close
		Return
	}

	Submit() {
		Gui.Submit("SimpleWarn")
	}

	Destroy() {
		SetTimer, GUI_SimpleWarn_CountDown, Delete
		Gui.Destroy("SimpleWarn")
	}
}
