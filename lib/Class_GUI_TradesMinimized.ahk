Class Gui_TradesMinimized {
	Create() {
		global PROGRAM, GAME, SKIN
		global GuiTradesMinimized, GuiTradesMinimized_Controls, GuiTradesMinimized_Submit
		static guiCreated, maxTabsToRender

		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100

		; Initialize gui arrays
		GUI_TradesMinimized.Destroy()
		Gui.New("TradesMinimized", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +LabelGUI_TradesMinimized_ +HwndhGuiTradesMinimized", "POE TC - Trades")
		guiCreated := False

		; Font name and size
		if (PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset = "User Defined") {
			settings_fontName := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Name : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.Font
			settings_fontSize := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Size : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontSize
			settings_fontQual := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.UseRecommendedFontSettings="1"?SKIN.Settings.FONT.Quality : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_UserDefined.FontQuality
		}
		else {
			settings_fontName := SKIN.Settings.FONT.Name
			settings_fontSize := SKIN.Settings.FONT.Size
			settings_fontQual := SKIN.Settings.FONT.Quality
		}

		; Gui size and positions
		borderSize := Floor(1*scaleMult)

		guiFullHeight := scaleMult*(30+(borderSize*2)), guiFullWidth := scaleMult*(95+(2*borderSize))

		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		guiMinimizedHeight := (30*scaleMult)+(2*borderSize) ; 30 = Header_H
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize	

		; Header pos
		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := scaleMult*30
		Icon_X := Header_X+(3*scaleMult), Icon_Y := Header_Y+(3*scaleMult), Icon_W := scaleMult*21, Icon_H := scaleMult*21
		MinMax_X := rightMost-((scaleMult*22)+3), MinMax_Y := Header_Y+(5*scaleMult), MinMax_W := scaleMult*22, MinMax_H := scaleMult*22
		Title_X := Icon_X+Icon_W+5, Title_Y := Header_Y, Title_W := MinMax_X-Title_X-5, Title_H := Header_H

		; Trade infos text pos + time slot auto size
		Loop 10 { ; from 0 to 9
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize("(" num num num ")", settings_fontName, settings_fontSize), thisW := txtCtrlSize.W, thisH := txtCtrlSize.H
			tabsCountWidth := (tabsCountWidth > thisW)?(tabsCountWidth):(thisW)
			tabsCountHeight := (tabsCountHeight > thisH)?(tabsCountHeight):(thisH)
		}
		TabsCount_X := (guiWidth-tabsCountWidth)-5, TimeSlot_Y := TabUnderline_Y+TabUnderline_H, TimeSlot_W := tabsCountWidth
		TradeVerify_W := 10*scaleMult, TradeVerify_H := TradeVerify_W, TradeVerify_X := TimeSlot_X-5-TradeVerify_W, TradeVerify_Y := TimeSlot_Y+3

		; Set required gui array variables
		GuiTradesMinimized.Tabs_Count := 0
		GuiTradesMinimized.Is_Created := False
		GuiTradesMinimized.Height := guiFullHeight
		GuiTradesMinimized.Width := guiFullWidth

		styles := Gui_Trades.Get_Styles()

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	CREATION
		*/

		Gui.Margin("TradesMinimized", 0, 0)
		Gui.Color("TradesMinimized", SKIN.Assets.Misc.Transparency_Color)
		Gui.Font("TradesMinimized", settings_fontName, settings_fontSize, settings_fontQual)

		; = = BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		bordersPositions := [{Position:"Top", X:0, Y:0, W:guiFullWidth, H:borderSize}, {Position:"Left", X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{Position:"Bottom", X:0, Y:guiFullHeight-borderSize, W:guiFullWidth, H:borderSize}, {Position:"Right", X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight} ; Bottom and Right
			,{Position:"BottomMinimized", X:0, Y:guiMinimizedHeight-borderSize, W:guiFullWidth, H:borderSize}] ; Bottom when minimized

		Loop 4 
			Gui.Add("TradesMinimized", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " hwndhPROGRESS_Border" bordersPositions[A_index]["Position"] " Background" SKIN.Settings.COLORS.Border)

		; = = TITLE BAR = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		Gui.Add("TradesMinimized", "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Assets.Misc.HeaderMin) ; Title bar
		; Gui.Add("TradesMinimized", "Picture", "x" Icon_X " y" Icon_Y " w" Icon_W " h" Icon_H " BackgroundTrans", SKIN.Assets.Misc.Icon) ; Icon
		imageBtnLog .= Gui.Add("TradesMinimized", "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Maximize", "", styles.Maximize, PROGRAM.FONTS[settings_fontName], settings_fontSize) ; Max
		Gui.Add("TradesMinimized", "Text", "x" Title_X " y" Title_Y " w" Title_W " h" Title_H " hwndhTEXT_Title Center BackgroundTrans +0x200 c" SKIN.Settings.COLORS.Title_No_Trades, "(0)")
		Gui.Add("TradesMinimized", "Text", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhTXT_HeaderGhost BackgroundTrans", "") ; Empty text ctrl to allow moving the gui by dragging the title bar

		__f := GUI_TradesMinimized.OnGuiMove.bind(GUI_TradesMinimized, GuiTradesMinimized.Handle)
		GuiControl, TradesMinimized:+g,% GuiTradesMinimized_Controls["hTXT_HeaderGhost"],% __f

		__f := GUI_TradesMinimized.Maximize.bind(GUI_TradesMinimized, False)
		GuiControl, TradesMinimized:+g,% GuiTradesMinimized_Controls["hBTN_Maximize"],% __f

		Gui.Show("TradesMinimized", "x0 y0 h" GuiTradesMinimized.Height " w" GuiTradesMinimized.Width " NoActivate Hide")
		GuiTradesMinimized.Is_Created := True
		Return

		Gui_TradesMinimized_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, TradesMinimized:,% ctrlHwnd

			Gui_TradesMinimized.ContextMenu(ctrlHwnd, ctrlName)
		return
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiTradesMinimized, GuiTradesMinimized_Controls
		iniFile := PROGRAM.INI_FILE

		if IsIn(CtrlHwnd, GuiTradesMinimized_Controls.hTXT_HeaderGhost "," GuiTradesMinimized_Controls.hTEXT_Title) {
			try Menu, HeaderMenu, DeleteAll
			Menu, HeaderMenu, Add,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition, Gui_TradesMinimized_ContextMenu_LockPosition
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
				Menu, HeaderMenu, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
			Menu, HeaderMenu, Show
		}
		Return

		Gui_TradesMinimized_ContextMenu_LockPosition:
			Tray_ToggleLockPosition()
		Return
	}

	Exists() {
		global GuiTradesMinimized
		hw := A_DetectHiddenWindows
		DetectHiddenWindows, On
		hwnd := WinExist("ahk_id " GuiTradesMinimized.Handle)
		DetectHiddenWindows, %hw%

		return hwnd
	}

	Show() {
		global PROGRAM, GuiTradesMinimized, GuiTrades

		; Get Trades GUI pos
		gtPos := GUI_Trades.GetPosition()
		gtmPos := GUI_TradesMinimized.GetPosition()
		foundHwnd := WinExist("ahk_id " GuiTradesMinimized.Handle) ; Check if this gui exists
		isTradesWinActive := WinActive("ahk_id " GuiTrades.Handle)

		if !(foundHwnd) ; Not found, create it
			GUI_TradesMinimized.Create()

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			xpos := gtPos.X, ypos := gtPos.Y+gtPos.H-gtmPos.H ; bottom left
		else
			xpos := gtPos.X+gtPos.W-gtmPos.W, ypos := gtPos.Y ; top right
		
		xpos := IsNum(xpos) ? xpos : IsNum( A_ScreenWidth-gtPos.W ) ? A_ScreenWidth-gtPos.W : 0
		ypos := IsNum(ypos) ? ypos : 0
		if (isTradesWinActive)
			Gui, TradesMinimized:Show, x%xpos% y%ypos%
		else Gui, TradesMinimized:Show, x%xpos% y%ypos% NoActivate
		Gui, Trades:Hide
	}

	Maximize() {
		global PROGRAM, GuiTrades, GuiTradesMinimized

		GuiTrades.Is_Maximized := True
		GuiTrades.Is_Minimized := False

		; Get Trades Min GUI pos
		gtPos := GUI_Trades.GetPosition()
		gtmPos := GUI_TradesMinimized.GetPosition()
		isTradesWinActive := WinActive("ahk_id " GuiTradesMinimized.Handle)

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			xpos := gtmPos.X, ypos := gtmPos.Y+gtmPos.H-gtPos.H ; bottom left
		else
			xpos := gtmPos.X+gtmPos.W-gtPos.W, ypos := gtmPos.Y ; top right

		xpos := IsNum(xpos) ? xpos : IsNum( A_ScreenWidth-gtPos.W ) ? A_ScreenWidth-gtPos.W : 0
		ypos := IsNum(ypos) ? ypos : 0
		if (isTradesWinActive)
			Gui, Trades:Show, x%xpos% y%ypos%
		else Gui, Trades:Show, x%xpos% y%ypos% NoActivate
		Gui, TradesMinimized:Hide

		/*
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.ShowItemGridWithoutInvite = "True")
			GUI_Trades.ShowActiveTabItemGrid()
		*/
		GUI_Trades.ShowActiveTabItemGrid()

		Gui_Trades.ResetPositionIfOutOfBounds()
	}

	OnGuiMove(GuiHwnd) {
		/*	Allow dragging the GUI 
		*/
		global PROGRAM
		if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window" && PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
		}
		KeyWait, LButton, L
		Gui_TradesMinimized.SavePosition()
		; Gui_Trades.RemoveButtonFocus()
		Gui_Trades.ResetPositionIfOutOfBounds()
	}

	GetPosition() {
		global GuiTradesMinimized
		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinGetPos, x, y, w, h,% "ahk_id " GuiTradesMinimized.Handle
		Sleep 10
		DetectHiddenWindows, %hiddenWin%
		return {x:x,y:y,w:w,h:h}
	}

	SavePosition() {
		global PROGRAM, GuiTrades, GuiTradesMinimized

		gtPos := GUI_Trades.GetPosition()
		gtmPos := GUI_TradesMinimized.GetPosition()

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToBottomLeft = "True")
			saveX := gtmPos.X, saveY := gtmPos.Y+gtmPos.H-gtPos.H
		else
			saveX := gtmPos.X+gtmPos.W-gtPos.W, saveY := gtmPos.Y
		
		if !IsNum(saveX) || !IsNum(saveY) {
			Return
		}
		
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_X", saveX)
		INI.Set(PROGRAM.INI_FILE, "SETTINGS_MAIN", "Pos_Y", saveY)
	}

	DestroyBtnImgList() {
		global GuiTradesMinimized_Controls

		for key, value in GuiTradesMinimized_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Destroy() {
		GUI_TradesMinimized.DestroyBtnImgList()
		Gui.Destroy("TradesMinimized")
	}
}
