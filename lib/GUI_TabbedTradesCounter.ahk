Class GUI_TabbedTradesCounter {

	static guiName := "TabbedTradesCounter"
	static sGUI := {}

	Static Skin := {"Font": "Segoe UI"
        ,"FontSize": 16
		,"FontColor": "0x80c4ff"
        ,"BackgroundColor": "0x1c4563"
		,"ControlsColor": "0x274554"
        ,"BorderColor": "0x000000"
        ,"BorderSize": 1
        ,"Styles": {"Button_Close": [ [0, "0xe01f1f", "", "White"], [0, "0xb00c0c"], [0, "0x8a0a0a"] ]
                   ,"Button_Minimize": [ [0, "0x0fa1d7", "", "White"], [0, "0x0b7aa2"], [0, "0x096181"] ]}
				   ,"Button": [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"], [0, "0x355e73"], [0, "0x122630"] ]}
	
	Create() {
		global PROGRAM, GAME, SKIN
		static AllStyles, AllStylesData
		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		prevCounter := IsNum(this.sGUI.Counter) ? this.sGUI.Counter : 0

		monitorPos := GetMonitorPosition(1) ; Main monitor infos
		windowsDPI := Get_WindowsResolutionDPI()
		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100
	
		; Initialize gui arrays
		this.sGUI := new GUI("TabbedTradesCounter", "-Caption -Border +AlwaysOnTop"
		. " +HwndhGui" this.guiName " +Label" this.__class "."
		. " w" (50*scaleMult)+(this.Skin.BorderSize*2) " h" (50*scaleMult)+(this.Skin.BorderSize*2)
		, PROGRAM.NAME . this.guiName)
		this.sGUI.Counter := prevCounter+1

		leftMost := this.Skin.BorderSize , rightMost := this.sGUI.Width+this.Skin.BorderSize ; +bordersize bcs of left border
		upMost := this.Skin.BorderSize , downMost := this.sGUI.Height+this.Skin.BorderSize

		counterBtn_x := leftMost, counterBtn_y := upMost
		counterBtn_w := this.sGUI.Width-this.Skin.BorderSize, counterBtn_h := this.sGUI.Height-this.Skin.BorderSize

		; = = Creating styles obj
		if !IsObject(AllStyles)
			AllStyles := {}, AllStylesData := {}
		if !IsObject(AllStyles[SKIN.Skin])
			AllStyles[SKIN.Skin] := GUI_Trades_V2.Get_Styles()

		Styles := ObjFullyClone(AllStyles[SKIN.Skin])
		
		/* * * * * * *
		* 	CREATION
		*/

		this.sGUI.SetMargins(0, 0), this.sGUI.SetBackgroundColor(this.Skin.BackgroundColor), this.sGUI.SetControlsColor(this.Skin.ControlsColor)
		this.sGUI.SetFont(this.Skin.Font), this.sGUI.SetFontSize(this.Skin.FontSize), this.sGUI.SetFontColor(this.Skin.FontColor)
		this.sGUI.AddColoredBorder(this.Skin.BorderSize, this.Skin.BorderColor)

		; * * Button
		if !IsObject(Styles.TabbedTradesCounterButton) {
			GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, "TabbedTradesCounterButton", guiWidth, guiHeight)
			AllStylesData["TabbedTradesCounterButton"] := {Width:guiWidth, Height:guiHeight}
		}
		this.sGUI.AddImageButton("x" counterBtn_x " y" counterBtn_y " w" counterBtn_w " h" counterBtn_h " hwndhBTN_Counter c" SKIN.Settings.COLORS.Trade_Info_2
			, this.sGUI.Counter, Styles.TabbedTradesCounterButton, PROGRAM.FONTS[this.sGUI.Skin.Font], this.sGUI.Skin.FontSize)
		this.sGUI.BindFunctionToControl("hBTN_Counter", "OnCounterButtonClick") 

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (this.sGUI.ImageButtonErrors.Count()) {
			AppendToLogs(JSON_Dump(this.sGUI.ImageButtonErrors))
			TrayNotifications.Show("Tabbed Trades Counter Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		AllStyles[SKIN.Skin] := ObjFullyClone(Styles)
		this.sGUI.AllStyles := ObjFullyClone(AllStyles), this.sGUI.AllStylesData := ObjFullyClone(AllStylesData)

		this.sGUI.Show("x" monitorPos.RightWA - ( (guiWidth+10)*windowsDPI )
			. " y" monitorPos.BottomWA - ( (guiHeight+10)*windowsDPI )
			. " h" guiFullHeight " w" guiFullWidth " NoActivate")
	
		hw := DetectHiddenWindows("On")
		WinWait,% "ahk_id " this.sGUI.Handle
		DetectHiddenWindows(hw)

		this.sGUI.BindWindowsMessage(0x200, "WM_MOUSEMOVE"), this.sGUI.BindWindowsMessage(0x201, "WM_LBUTTONDOWN"), this.sGUI.BindWindowsMessage(0x202, "WM_LBUTTONUP")

		this.sGUI.Is_Created := True
		SetControlDelay(delay), SetBatchLines(batch)
		Return
	}

	OnCounterButtonClick() {
		global GuiTrades
		GUI_TabbedTradesCounter.Destroy()
		WinActivate,% "ahk_pid " GUI_Trades_V2.GetTabContent("Sell", GuiTrades.Sell.Tabs_Count).GamePID
		GUI_Trades_V2.Maximize("Sell")
		GUI_Trades_V2.SetActiveTab("Sell", GuiTrades.Sell.Tabs_Count)
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	GENERAL FUNCTIONS
	*/

	Show() {
		global PROGRAM

		hw := DetectHiddenWindows("On")
		foundHwnd := WinExist("ahk_id " this.sGUI.Handle)
		DetectHiddenWindows(hw)

		if (foundHwnd) {	
			this.sGUI.Show("NoActivate")
		}
		else {
			AppendToLogs("GUI_TabbedTradesCounter.Show(): Non existent. Recreating.")
			GUI_TabbedTradesCounter.Create()
		}
		this.sGUI.Show("NoActivate")
	}

	Redraw() {
		guiName := this.Name
		Gui, %guiName%:+LastFound
		WinSet, Redraw
	}

	Destroy() {
		this.sGUI.Destroy()
	}
}
