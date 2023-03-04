Class GUI_TabbedTradesCounter {
	
	Create(whichTab="") {
		global PROGRAM, GAME, SKIN
		global GuiTabbedTradesCounter, GuiTabbedTradesCounter_Controls, GuiTabbedTradesCounter_Submit
		global GuiTrades
		static AllStyles, AllStylesData
		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		prevCounter := IsNum(GuiTabbedTradesCounter.Counter) ? GuiTabbedTradesCounter.Counter : 0

		; Monitor infos
		SysGet, MonitorCount, MonitorCount
		SysGet, MonitorPrimary, MonitorPrimary
		SysGet, MonitorWorkArea, MonitorWorkArea,% MonitorPrimary

		windowsDPI := Get_DpiFactor()
		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100
	
		; Initialize gui arrays
		GUI_TabbedTradesCounter.Destroy()
		Gui.New("TabbedTradesCounter", "+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border +LabelGUI_TabbedTradesCounter_ +HwndhGuiTabbedTradesCounter", "POE TC - Tabbed Trades Counter")
		GuiTabbedTradesCounter.Is_Created := False
		GuiTabbedTradesCounter.Windows_DPI := windowsDPI
		GuiTabbedTradesCounter.Counter := prevCounter+1

		borderSize := Floor(1*scaleMult), borderSize := borderSize >= 1 ? borderSize : 1, borderColor := "Black"

		guiCreated := False
		guiFullHeight := (50*scaleMult)+(borderSize*2), guiFullWidth := (50*scaleMult)+(borderSize*2)
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth+borderSize ; +bordersize bcs of left border
		upMost := borderSize, downMost := guiHeight+borderSize

		counterBtn_x := leftMost, counterBtn_y := upMost, counterBtn_w := guiWidth, counterBtn_h := guiHeight

		; = = Creating styles obj
		if !IsObject(AllStyles)
			AllStyles := {}, AllStylesData := {}
		if !IsObject(AllStyles[SKIN.Skin])
			AllStyles[SKIN.Skin] := GUI_Trades_V2.Get_Styles()

		Styles := ObjFullyClone(AllStyles[SKIN.Skin])
		
		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("TabbedTradesCounter", 0, 0)
		Gui.Color("TabbedTradesCounter", GuiTrades.Sell.Background_Color, GuiTrades.Sell.Controls_Color)
		Gui.Font("TabbedTradesCounter", GuiTrades.Sell.Font, GuiTrades.Sell.Font_Size*2, GuiTrades.Sell.Font_Quality, GuiTrades.Sell.Font_Color)
		Gui, TabbedTradesCounter:Default ; Required for LV_ cmds

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right
		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("TabbedTradesCounter", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Button
		
		if !IsObject(Styles.TabbedTradesCounterButton) {
			GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, "TabbedTradesCounterButton", guiWidth, guiHeight)
			AllStylesData["TabbedTradesCounterButton"] := {Width:guiWidth, Height:guiHeight}
		}
		Gui.Add("TabbedTradesCounter", "ImageButton", "x" counterBtn_x " y" counterBtn_y " w" counterBtn_w " h" counterBtn_h " hwndhBTN_Counter c" SKIN.Settings.COLORS.Trade_Info_2, GuiTabbedTradesCounter.Counter, Styles.TabbedTradesCounterButton, PROGRAM.FONTS[GuiTabbedTradesCounter.Font], GuiTabbedTradesCounter.Font_Size)
		Gui.BindFunctionToControl("GUI_TabbedTradesCounter", "TabbedTradesCounter", "hBTN_Counter", "OnTabbedTradesCounterButtonClick") 

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (GuiTabbedTradesCounter.ImageButton_Errors) {
			AppendToLogs(GuiTabbedTradesCounter.ImageButton_Errors)
			TrayNotifications.Show("Tabbed Trades Counter Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		AllStyles[SKIN.Skin] := ObjFullyClone(Styles)
		GuiTabbedTradesCounter.AllStyles := ObjFullyClone(AllStyles), GuiTabbedTradesCounter.AllStylesData := ObjFullyClone(AllStylesData)

		; gtPos := GUI_Trades_V2.GetPosition("Sell")
		showX := MonitorWorkAreaRight - ( (guiWidth+10)*windowsDPI ), showY := MonitorWorkAreaBottom - ( (guiHeight+10)*windowsDPI )
		Gui.Show("TabbedTradesCounter", "x" showX " y" showY " h" guiFullHeight " w" guiFullWidth " NoActivate")
	
		hw := DetectHiddenWindows("On")
		WinWait,% "ahk_id " GuiTabbedTradesCounter.Handle
		DetectHiddenWindows(hw)

		Gui.OnMessageBind("GUI_TabbedTradesCounter", "TabbedTradesCounter", 0x200, "WM_MOUSEMOVE")
		Gui.OnMessageBind("GUI_TabbedTradesCounter", "TabbedTradesCounter", 0x201, "WM_LBUTTONDOWN")
		Gui.OnMessageBind("GUI_TabbedTradesCounter", "TabbedTradesCounter", 0x202, "WM_LBUTTONUP")

		GuiTabbedTradesCounter.Is_Created := True
		SetControlDelay(delay), SetBatchLines(batch)
		Return

		GUI_TabbedTradesCounter_Close:
		Return

		GUI_TabbedTradesCounter_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, TabbedTradesCounter:,% ctrlHwnd
		return
	}

	OnTabbedTradesCounterButtonClick() {
		global GuiTrades
		GUI_TabbedTradesCounter.Destroy()
		WinActivate,% "ahk_pid " GUI_Trades_V2.GetTabContent("Sell", GuiTrades.Sell.Tabs_Count).GamePID
		GUI_Trades_V2.Maximize("Sell")
		GUI_Trades_V2.SetActiveTab("Sell", GuiTrades.Sell.Tabs_Count)
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	GENERAL FUNCTIONS
	*/

	CreateODcObj() {
		return odcObj := {T: 0x80c4ff, B: 0x274554}
	}

	CreateODCObjFromActionsList(actionsList) {
		sectionsArr := []
		Loop, Parse, actionsList,% "|"
			if ( SubStr(A_LoopField, 1, 2) = "->" )
				sectionsArr.Push(A_Index)
		odcObj := GUI_TabbedTradesCounter.CreateOdcObj()
		Loop % sectionsArr.Count()
			odcObj[sectionsArr[A_Index]] := {T: 0xf5f5f5, B:0x0078D7}

		return odcObj
	}

	GetPosition() {
		global GuiTabbedTradesCounter
		hw := DetectHiddenWindows("On")
		WinGetPos, x, y, w, h,% "ahk_id " GuiTabbedTradesCounter.Handle
		DetectHiddenWindows(hw)
		
		return {x:x,y:y,w:w,h:h}
	}

	IsVisible() {
		global GuiTabbedTradesCounter
		hw := DetectHiddenWindows("Off")
		winHwnd := WinExist("ahk_id " GuiTabbedTradesCounter.Handle)
		DetectHiddenWindows(hw)
		return winHwnd
	}

	DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

	Show() {
		global PROGRAM, SKIN
		global GuiTabbedTradesCounter, GuiTabbedTradesCounter_Controls

		hw := DetectHiddenWindows("On")
		foundHwnd := WinExist("ahk_id " GuiTabbedTradesCounter.Handle)
		DetectHiddenWindows(hw)

		if (foundHwnd) {	
			GUI_TabbedTradesCounter.Create()
			Gui, TabbedTradesCounter:Show, NoActivate
		}
		else {
			AppendToLogs("GUI_TabbedTradesCounter.Show(" whichTab "): Non existent. Recreating.")
			GUI_TabbedTradesCounter.Create()
			Gui, TabbedTradesCounter:Show, NoActivate
		}
	}

	Submit(CtrlName="") {
		global GuiTabbedTradesCounter_Submit
		Gui.Submit("TabbedTradesCounter")

		if (CtrlName) {
			Return GuiTabbedTradesCounter_Submit[ctrlName]
		}
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiTabbedTradesCounter
		
	}

	DestroyBtnImgList() {
		global GuiTabbedTradesCounter_Controls

		for key, value in GuiTabbedTradesCounter_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Redraw() {
		Gui, TabbedTradesCounter: +LastFound
		WinSet, Redraw
	}

	Destroy() {
		GUI_TabbedTradesCounter.DestroyBtnImgList()
		Gui.Destroy("TabbedTradesCounter")
	}
}
