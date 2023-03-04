Class GUI_Trades_V2 {

	Preview_AddCustomButtonsToRow(_buyOrSell, rowNum) {
		whichTab := IsContaining(_buyOrSell, "Buy") ? "Buying" : "Selling"
		GUI_Settings.Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum) 
	}

	Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, btnsCount, btnNum) {
		global GuiTrades, GuiSettings
		static prevBtn := {}
		fadeOutCode := GUI_Settings.ShowFadeout()

		whichTab := IsContaining(_buyOrSell, "Buy") ? "Buying" : "Selling"
		guiName := "Trades" _buyOrSell "_Slot1"
		thisBtn := "hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum
		
		if (prevBtn[_buyOrSell]) {
			GuiControl, %guiName%:-Disabled,% GuiTrades[_buyOrSell]["Slot1_Controls"][prevBtn[_buyOrSell]]
			; GUI_Settings.Customization_SellingBuying_SaveAllCurrentButtonActions(whichTab) ; Possible cause of the bug: "Clicking a button overwrite its actions with the previously selected button actions"
		}
		GuiControl, %guiName%:+Disabled,% GuiTrades[_buyOrSell]["Slot1_Controls"][thisBtn]
		prevBtn[_buyOrSell] := thisBtn

		GuiSettings.CUSTOM_BUTTON_SELECTED_ROW := rowNum
		GuiSettings.CUSTOM_BUTTON_SELECTED_MAX := btnsCount
		GuiSettings.CUSTOM_BUTTON_SELECTED_NUM := btnNum

		SetTimer, GUI_Settings_Customization_%whichTab%_OnActionContentChange, Delete
		Sleep 10

		GUI_Settings.Customization_SellingBuying_LoadButtonSettings(whichTab, rowNum, btnNum)
		GUI_Settings.Customization_SellingBuying_SelectListviewRow(whichTab, 1)

		Sleep 10
		SetTimer, GUI_Settings_Customization_%whichTab%_OnActionContentChange, Delete

		GUI_Trades_V2.RemoveButtonFocus(_buyOrSell)
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	CreatePreview(_buyOrSell, _guiMode) {

		GUI_Trades_V2.Create(1, buyOrSell:=_buyOrSell, stackOrTabs:=_guiMode, preview:=True)
		if (_guiMode="Disabled")
			return

		if (_buyOrSell="Buy")
			Parse_GameLogs("2017/06/04 17:31:02 105384166 355 [INFO Client 6416] @To SensualApples: Hi, I would like to buy your Shaped Beach Map (T6) listed for 1 chaos in Standard offer 3 alch?", preview:=True)
		else if (_buyOrSell="Sell")
			Parse_GameLogs("2017/06/04 17:31:02 105384166 355 [INFO Client 6416] @From SensualApples: Hi, I would like to buy your Shaped Beach Map (T6) listed for 1 chaos in Standard offer 3 alch?", preview:=True)
	}
	
	Create(_tabsToRender=50, _buyOrSell="", _guiMode="", _isPreview=False) {
		global PROGRAM, GAME, SKIN
        global GuiTrades, GuiTrades_Controls
        global GuiTradesBuy, GuiTradesBuy_Controls
        global GuiTradesSell, GuiTradesSell_Controls
		static AllStyles, AllStylesData
        scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100, scaleMult := _isPreview ? 1 : scaleMult
        windowsDPI := Get_WindowsResolutionDPI()
        _tabsToRender := IsNum(_tabsToRender)?_tabsToRender:50
		
        if !IsIn(_buyOrSell, "Buy,Sell") || !IsIn(_guiMode, "Tabs,Stack,Disabled") {
			errorMsg := "Failed to create " _buyOrSell " Interface due to a wrong parameter:"
			. "`n_buyOrSell: " _buyOrSell
			. "`n_guiMode: " _guiMode
			AppendToLogs(A_ThisFunc ": " errorMsg)
            MsgBox(4096+16, "", errorMsg)
            return
        }

        ; = = Init GUI Obj
		if (_isPreview)
			_buyOrSell .= "Preview"
        guiName := "Trades" _buyOrSell

		if (_guiMode="Disabled") {
			AppendToLogs(A_ThisFunc ": Cancel to create interface """ _buyOrSell """ due to _guiMode being """ _guiMode """.")
			GUI_Trades_V2.Destroy(guiName)
			return
		}

		delay := SetControlDelay(0), batch := SetBatchLines(-1)

        GUI_Trades_V2.Destroy(guiName)
		if (_isPreview=True)
			Gui.New(guiName, "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +LabelGUI_Trades_V2_ +ParentSettings +HwndhGui" guiName, "POE TC - Trades " _buyOrSell)
		else Gui.New(guiName, "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +LabelGUI_Trades_V2_ +HwndhGui" guiName, "POE TC - Trades " _buyOrSell)
        Gui.SetDefault(guiName)
        Gui%guiName%.Windows_DPI := windowsDPI

        ; = = Define font name and size
        skinPreset := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.Preset, skinSettings := skinPreset="Custom" ? PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom : PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS
        guifontName := skinSettings.Font
        guifontSize := skinSettings.FontSize*scaleMult
        guifontQual := skinSettings.FontQuality
        Gui.Font(guiName, guifontName, guifontSize, guifontQual) 
        Gui.Color(guiName, SKIN.Assets.Misc.Transparency_Color)
        Gui.Margin(guiName, 0, 0)
        guifontName := guifontSize := guifontQual := useRecommendedFontSettings := useRecommendedFontSettings := userCustomCopy := ""

        ; = = Define general gui size
		guiIniSection := IsContaining(_buyOrSell, "Sell")?"SELL_INTERFACE":"BUY_INTERFACE"
		additionalRowsCount := IsContaining(_buyOrSell, "Preview") ? 3
			: PROGRAM.SETTINGS[guiIniSection].CUSTOM_BUTTON_ROW_4.Buttons_Count ? 3
			: PROGRAM.SETTINGS[guiIniSection].CUSTOM_BUTTON_ROW_3.Buttons_Count ? 2
			: PROGRAM.SETTINGS[guiIniSection].CUSTOM_BUTTON_ROW_2.Buttons_Count ? 1
			: 0

        borderSize := Floor(1*scaleMult), borderSize := borderSize >= 1 ? borderSize : 1
        oneTextLineSize := Get_TextCtrlSize("SomeText", PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size, "", "R1").H
		TabContentSlot_H := borderSize+(5*scaleMult)+oneTextLineSize+(5*scaleMult)+(25*scaleMult)+(5*scaleMult) ; minimal required // 25 = custom button height
		if (additionalRowsCount) {
			TabContentSlot_H := TabContentSlot_H + (additionalRowsCount*(25*scaleMult))
			TabContentSlot_H := TabContentSlot_H + (additionalRowsCount*(5*scaleMult))
		}
		
        if (_guiMode="Stack") {
			Gui%guiName%.Height_Minimized			:= guiMinimizedHeight 	:= (borderSize)+(30*scaleMult)+(borderSize) ; 30=header
			Gui%guiName%.Height_Maximized 			:= guiFullHeight		:= (guiMinimizedHeight+(22*scaleMult)+TabContentSlot_H) ; 22=header2
			Gui%guiName%.Height_Maximized_OneSlot 	:= ( guiMinimizedHeight+(22*scaleMult)+TabContentSlot_H )
			Gui%guiName%.Slot_Height				:= TabContentSlot_H
			Gui%guiName%.Height_Maximized_TwoSlot 	:= Gui%guiName%.Height_Maximized_OneSlot + Gui%guiName%.Slot_Height
			Gui%guiName%.Height_Maximized_ThreeSlot := Gui%guiName%.Height_Maximized_TwoSlot + Gui%guiName%.Slot_Height
			Gui%guiName%.Height_Maximized_FourSlot 	:= guiFullHeight := Gui%guiName%.Height_Maximized_ThreeSlot + Gui%guiName%.Slot_Height
			Gui%guiName%.Height 					:= guiMinimizedHeight
			Gui%guiName%.Width 						:= guiFullWidth := (398*scaleMult)+(2*borderSize)

			guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
            leftMost := borderSize, rightMost := guiWidth+borderSize ; +bordersize bcs of left border
            upMost := borderSize, downMost := guiHeight+borderSize
			TabContentSlot_W := guiWidth
			TabContentAvailableWidth := TabContentSlot_W-(15*scaleMult) ; 15=CloseTabVertical_W
        }
        else if (_guiMode="Tabs") {
            Gui%guiName%.Height_Minimized	:= guiMinimizedHeight 	:= (borderSize)+(30*scaleMult)+(borderSize) ; 30=header
			Gui%guiName%.Height_Maximized 	:= guiFullHeight	 	:= ( guiMinimizedHeight+(22*scaleMult)+TabContentSlot_H ) ; 22=header2
			Gui%guiName%.Slot_Height		:= TabContentSlot_H
			Gui%guiName%.Height 			:= guiMinimizedHeight
			Gui%guiName%.Width 				:= guiFullWidth 		:= (398*scaleMult)+(2*borderSize)

			guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
            leftMost := borderSize, rightMost := guiWidth+borderSize ; +bordersize bcs of left border
            upMost := borderSize, downMost := guiHeight+borderSize
			TabContentSlot_W := guiWidth
			TabContentAvailableWidth := TabContentSlot_W
        }

        ; = = Define general gui slots
        if (_guiMode="Stack") {
            maxTabsToShow := 4
        }
        else if (_guiMode="Tabs") {
            maxTabsToShow := 8
        }

        ; = = Define general gui elements positioning
            ; Header
		Header_X := leftMost, Header_Y := upMost, Header_W := guiWidth, Header_H := 30*scaleMult
        ToolBar_Button1_X := 5*scaleMult, ToolBar_Button1_Y := 5*scaleMult, ToolBar_Button1_W := 30*scaleMult, ToolBar_Button1_H := 22*scaleMult
		MinMax_X := rightMost-((22*scaleMult)+(3*scaleMult)), MinMax_Y := Header_Y+(4*scaleMult), MinMax_W := 22*scaleMult, MinMax_H := 22*scaleMult
		Title_X := "_CUSTOM_", Title_Y := Header_Y, Title_W := "_CUSTOM_", Title_H := Header_H
        ToolBar_SpaceBetweenButtons := 8*scaleMult

            ; Second bar
        if (_guiMode="Stack") {
            Header2_X := leftMost, Header2_Y := Header_Y+Header_H, Header2_H := 22*scaleMult
            RightArrow_W := 25*scaleMult, RightArrow_H := Header2_H
            LeftArrow_W := RightArrow_W, LeftArrow_H := RightArrow_H       

            LeftArrow_X := rightMost-LeftArrow_W-RightArrow_W, LeftArrow_Y := Header2_Y
            RightArrow_X := LeftArrow_X+LeftArrow_W, RightArrow_Y := Header2_Y
            
            Header2_W := Header_W-LeftArrow_W-RightArrow_W

            SearchBox_X := Header2_X+(10*scaleMult), SearchBox_Y := Header2_Y, SearchBox_W := (139*scaleMult), SearchBox_H := Header2_H
        }
        else if (_guiMode="Tabs") {
            TabsBackground_X := leftMost, TabsBackground_Y := Header_Y+Header_H, TabsBackground_H := 22*scaleMult
            RightArrow_W := 25*scaleMult, RightArrow_H := TabsBackground_H
            LeftArrow_W := RightArrow_W, LeftArrow_H := RightArrow_H     
            CloseTab_W := RightArrow_W, CloseTab_H := RightArrow_H

            LeftArrow_X := rightMost-CloseTab_W-LeftArrow_W-RightArrow_W, LeftArrow_Y := TabsBackground_Y
            RightArrow_X := LeftArrow_X+LeftArrow_W, RightArrow_Y := TabsBackground_Y
            CloseTab_X := RightArrow_X+RightArrow_W, CloseTab_Y := TabsBackground_Y
            
            TabsBackground_W := Header_W-LeftArrow_W-RightArrow_W-CloseTab_W

            TabButton1_Y := TabsBackground_Y, TabButton1_W := 39*scaleMult, TabButton1_H := TabsBackground_H
            Loop % maxTabsToShow
                Gui%guiName%["TabButton" A_Index "_X"] := xpos := TabButton%A_Index%_X := A_Index=1 ? TabsBackground_X : xpos+TabButton1_W+(1*scaleMult)
        }

            ; Tabs content
        Loop 10 { ; from 0 to 9, for time slot width
			num := (A_Index=10)?("0"):(A_Index)
			txtCtrlSize := Get_TextCtrlSize(num num ":" num num, Gui%guiName%.Font, Gui%guiName%.Font_Size)
			Time_W := (Time_W > txtCtrlSize.W)?(Time_W):(txtCtrlSize.W)
		}

        BackgroundImg_X := 0, BackgroundImg_Y := 0, BackgroundImg_W := Ceil(TabContentAvailableWidth*windowsDPI)*scaleMult, BackgroundImg_H := Ceil(TabcontentSlot_H*windowsDPI)*scaleMult

        CloseTabVertical_W := 15*scaleMult, CloseTabVertical_H := TabContentSlot_H, CloseTabVertical_X := rightMost-CloseTabVertical_W, CloseTabVertical_Y := 0

        firstRowX := leftMost+(5*scaleMult), firstRowY := upMost+(5*scaleMult), firstRowW := (guiWidth/2)-(5*scaleMult)-CloseTabVertical_W ; 5= spacing
        secondRowX := firstRowX, secondRowY := firstRowY+oneTextLineSize+(5*scaleMult) ; 5= spacing
        firstColX := firstRowX, firstColY := upMost+(5*scaleMult) ; 5= spacing
        secondColX := (guiWidth/2)+firstRowX+(5*scaleMult), secondColY := firstColY ; 5= spacing  
        
        ItemName_X := firstRowX, ItemName_Y := firstRowY, ItemName_W := ( (guiWidth-CloseTabVertical_W)/2 )-(5*scaleMult) ; ItemName_W: 5=spacing
        SellerName_X := ItemName_X+ItemName_W+(10*scaleMult), SellerName_Y := ItemName_Y, SellerName_W := ItemName_W ; SellerName_X: 10=spacing*2
        CurrencyImg_X := secondRowX, CurrencyImg_Y := secondRowY, CurrencyImg_W := 20*scaleMult, CurrencyImg_H := 20*scaleMult
        PriceCount_X := CurrencyImg_X+CurrencyImg_W, PriceCount_Y := CurrencyImg_Y+( (CurrencyImg_H-oneTextLineSize)/2 ), PriceCount_W := 50*scaleMult
        AdditionalMsg_X := PriceCount_X+PriceCount_W, AdditionalMsg_Y := PriceCount_Y, AdditionalMsg_W := 200*scaleMult
        SmallButton_X := SellerName_X, SmallButton_Y := secondRowY, SmallButton_W := 35*scaleMult, SmallButton_H := 25*scaleMult, SmallButton_Space := 5*scaleMult, SmallButton_Count := 4
        if (_guiMode="Stack")
            Time_X := CloseTabVertical_X-Time_W-(3*scaleMult), Time_Y := 0 ; 3=spacing
        else if (_guiMode="Tabs")
            Time_X := rightMost-Time_W-(3*scaleMult), Time_Y := 0 ; 3=spacing

        SmallButton1_X := CloseTabVertical_X-(SmallButton_Count* (SmallButton1_W+SmallButton_Space))-(15*scaleMult), SmallButton1_Y := "_CUSTOM_"

		CustomButtonOneThird_W := Ceil( (guiWidth)/3 )-(5*scaleMult) , CustomButtonTwoThird_W := (CustomButtonOneThird_W*2)+(5*scaleMult), CustomButtonThreeThird_W := (CustomButtonOneThird_W*3)+(10*scaleMult)
		CustomButtonLeft_X := leftMost+(5*scaleMult), CustomButtonMiddle_X := CustomButtonLeft_X+CustomButtonOneThird_W+(5*scaleMult), CustomButtonRight_X := CustomButtonMiddle_X+CustomButtonOneThird_W+(5*scaleMult)
		CustomButton_H := 25*scaleMult

        TradeVerify_W := 10*scaleMult, TradeVerify_H := TradeVerify_W, TradeVerify_X := Time_X-(5*scaleMult)-TradeVerify_W, TradeVerify_Y := Time_Y+(3*scaleMult)

        ; = = Getting ready to create the GUI
		Gui%guiName%.Active_Tab := 0
		Gui%guiName%.Tabs_Count := 0
		Gui%guiName%.Tabs_Limit := _tabsToRender
		Gui%guiName%.Max_Tabs_Per_Row := maxTabsToShow
		Gui%guiName%.Is_Created := False
		Gui%guiName%.Is_Tabs := _guiMode="Tabs"?True:False
		Gui%guiName%.Is_Stack := _guiMode="Stack"?True:False
		Gui%guiName%.Skin := SKIN.Skin
		Gui%guiName%.SkinAssets := ObjFullyClone(SKIN.Assets)

		; = = Creating styles obj
		if !IsObject(AllStyles)
			AllStyles := {}, AllStylesData := {}
		if !IsObject(AllStyles[SKIN.Skin])
			AllStyles[SKIN.Skin] := GUI_Trades_V2.Get_Styles()

		Styles := ObjFullyClone(AllStyles[SKIN.Skin])

        ; = = Borders
        if (_guiMode="Stack") {
            bordersObj := { Top: {X:0, Y:0, W:guiFullWidth, H:borderSize}
				,Left: {X:0, Y:0, W:borderSize, H:guiFullHeight}
				,Right: {X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight}
				,Bottom_Minimized: {X:0, Y:Header_Y+Header_H, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized_OneSlot: {X:0, Y:Gui%guiName%.Height_Maximized_OneSlot-borderSize, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized_TwoSlots: {X:0, Y:Gui%guiName%.Height_Maximized_TwoSlot-borderSize, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized_ThreeSlots: {X:0, Y:Gui%guiName%.Height_Maximized_ThreeSlot-borderSize, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized_FourSlots: {X:0, Y:Gui%guiName%.Height_Maximized_FourSlot-borderSize, W:guiFullWidth, H:borderSize} }
		}
        else if (_guiMode="Tabs") {
            bordersObj := { Top: {X:0, Y:0, W:guiFullWidth, H:borderSize}
				,Left: {X:0, Y:0, W:borderSize, H:guiFullHeight}
				,Right: {X:guiFullWidth-borderSize, Y:0, W:borderSize, H:guiFullHeight}
				,Bottom_Minimized: {X:0, Y:guiMinimizedHeight, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized: {X:0, Y:guiHeight+borderSize, W:guiFullWidth, H:borderSize}
				,Bottom_Maximized_OneSlot: {X:0, Y:guiHeight+borderSize, W:guiFullWidth, H:borderSize} }
		}
		borders := []
		for objName, nothing in bordersObj
			bordersObj[objName].Name := objName, borders.Push(bordersObj[objName])

        Loop % borders.Count()
            Gui.Add(guiName, "Progress", "x" borders[A_Index]["X"] " y" borders[A_Index]["Y"] " w" borders[A_Index]["W"] " h" borders[A_Index]["H"] " Background" SKIN.Settings.COLORS.Border " c" SKIN.Settings.COLORS.Border " hwndhPROGRESS_Border" borders[A_Index].Name, 100)

        ; = = Header
		if !IsObject(Styles.Minimize)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Minimize", MinMax_W, MinMax_H, "Minimize")
		if !IsObject(Styles.Maximize)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Maximize", MinMax_W, MinMax_W, "Maximize")
		if !IsObject(Styles.Toolbar_Hideout)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Toolbar_Hideout", ToolBar_Button1_W, ToolBar_Button1_H, "Hideout", {CenterRatio:0.70})
		if !IsObject(Styles.Toolbar_Sheet)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Toolbar_Sheet", ToolBar_Button1_W, ToolBar_Button1_H, "Sheet", {CenterRatio:0.70})
		if !IsObject(Styles.Toolbar_Link)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Toolbar_Link", ToolBar_Button1_W, ToolBar_Button1_H, "Link", {CenterRatio:0.70})
		if !IsObject(Styles.Arrow_Left)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Arrow_Left", LeftArrow_W, LeftArrow_H, "ArrowLeft", {CenterRatio:0.70, Right:{Skip:True}})
		if !IsObject(Styles.Arrow_Right)
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Arrow_Right", RightArrow_W, RightArrow_H, "ArrowRight", {CenterRatio:0.70, Left:{Skip:True}})
		if !IsObject(Styles.Close_Tab) && (_guiMode="Tabs")
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Close_Tab", RightArrow_W, RightArrow_H, "Cross", {CenterRatio:0.60})
		if !IsObject(Styles.Close_Tab_Vertical) && (_guiMode="Stack")
			GUI_Trades_V2.CreateGenericIconButtonStyle_2(Styles, "Close_Tab_Vertical", CloseTabVertical_W, CloseTabVertical_H, "Cross", {CenterRatio:0.65, Top:{Skip:True}, Bottom:{Skip:True}, Background: {FillVertically:True, UseBackground2:True}})

		Gui.Add(guiName, "Picture", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhIMG_Header BackgroundTrans", SKIN.Assets.Misc.Header)
		Gui.Add(guiName, "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Minimize", "", styles.Minimize, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
		Gui.Add(guiName, "ImageButton", "x" MinMax_X " y" MinMax_Y " w" MinMax_W " h" MinMax_H " BackgroundTrans hwndhBTN_Maximize Hidden", "", styles.Maximize, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
		if IsContaining(_buyOrSell, "Sell") {
			Gui.Add(guiName, "ImageButton", "x" ToolBar_Button1_X " y" ToolBar_Button1_Y " w" ToolBar_Button1_W " h" ToolBar_Button1_H " BackgroundTrans hwndhBTN_Hideout", "", Styles.Toolbar_Hideout, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
			Gui.Add(guiName, "ImageButton", "x+" ToolBar_SpaceBetweenButtons " yp wp hp BackgroundTrans hwndhBTN_LeagueHelp", "", styles.Toolbar_Sheet, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
			Gui.Add(guiName, "ImageButton", "x+" ToolBar_SpaceBetweenButtons " yp wp hp BackgroundTrans hwndhBTN_QuickLinks", "", styles.Toolbar_Link, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
		}
        Gui.Add(guiName, "Text", "x" Header_X " y" Header_Y " w" Header_W " h" Header_H " hwndhTXT_HeaderGhost BackgroundTrans", "") ; Empty text ctrl to allow moving the gui by dragging the title bar

        minBtnPos := Gui.GetControlPos(guiName, "hBTN_Minimize"), lastToolBtnPos := Gui.GetControlPos(guiName, "hBTN_What3")
        Title_X := lastToolBtnPos.X+lastToolBtnPos.W+(3*scaleMult), Title_W := Header_W-(lastToolBtnPos.X+lastToolBtnPos.W+(3*scaleMult))-(Header_W-(minBtnPos.X-minBtnPos.W))
        ; Gui.Add(guiName, "Text", "x" Title_X " y" Title_Y " w" Title_W " h" Title_H " hwndhTEXT_Title Center BackgroundTrans +0x200 c" SKIN.Settings.COLORS.Title_No_Trades, PROGRAM.NAME)
	
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hTXT_HeaderGhost", "OnGuiMove", _buyOrSell) 
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_Minimize", "Minimize", _buyOrSell) 
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_Maximize", "Maximize", _buyOrSell) 
        
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_Hideout", "HotBarButton", _buyOrSell, "Hideout")
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_LeagueHelp", "HotBarButton", _buyOrSell, "LeagueHelp")
		Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_QuickLinks", "HotBarButton", _buyOrSell, "QuickLinks")

        ; = = Header 2
		/*	Due to the fact that we want to use a skinned search box, we have to simulate it by:
			- Creating a child gui with the edit box, and set the transparency 1
			- Add a text control on the same exact location on the parent gui

			( this part only matters if using the +E0x08000000 style for parent gui)
			- Compare the control size for an edit box and a text control with the same text 
			  (an edit box and a text control will have difference in sizes due to the edit box borders which the text control doesnt have)
			  Based on the size difference, move the text control a bit

			- Due to the +E0x08000000 style, we can't focus the search box
			  We work around it by creating yet another gui (not child) with an edit box, which will be hidden
			- Using WM_LButtonDown and WM_LButtonUp, we detect when the user is clicking the child gui search box
			  and we focus our hidden gui edit box so we can type in
			- Anything typed in the hidden edit box will be reflected on our parent gui text control
		*/

        if (_guiMode="Stack") {
            global GuiTradesBuySearch, GuiTradesBuySearch_Controls
            global GuiTradesSellSearch, GuiTradesSellSearch_Controls
			global GuiTradesBuyPreviewSearch, GuiTradesBuyPreviewSearch_Controls
            global GuiTradesSellPreviewSearch, GuiTradesSellPreviewSearch_Controls
			Gui.New(guiName "Search", "-Caption -Border +ToolWindow -SysMenu +AlwaysOnTop +LastFound +E0x08000000 +Parent" guiName " +HwndhGui" guiName "Search")
            Gui.SetDefault(guiName "Search")
            Gui.Margin(guiName "Search", 0, 0)
            Gui.Color(guiName "Search", "White")
            Gui.Font(guiName "Search", Gui%guiName%.Font, Gui%guiName%.Font_Size, Gui%guiName%.Font_Quality)
            Gui.Add(guiName "Search", "Edit", "x" 0 " y" 0 " w" SearchBox_W " h" SearchBox_H " FontQuality5 BackgroundTrans hwndhEDIT_SearchBar cWhite Limit1")
            WinSet, Transparent, 1
            
            global GuiTradesBuySearchHidden, GuiTradesBuySearchHidden_Controls
            global GuiTradesSellSearchHidden, GuiTradesSellSearchHidden_Controls
			global GuiTradesBuyPreviewSearchHidden, GuiTradesBuyPreviewSearchHidden_Controls
            global GuiTradesSellPreviewSearchHidden, GuiTradesSellPreviewSearchHidden_Controls
			Gui.New(guiName "SearchHidden", "-Caption -Border +ToolWindow -SysMenu +AlwaysOnTop +E0x08000000 +LastFound +HwndhGui" guiName "SearchHidden")
            Gui.SetDefault(guiName "SearchHidden")
            Gui.Margin(guiName "SearchHidden", 0, 0)
            Gui.Color(guiName "SearchHidden", "White")
            Gui.Font(guiName "SearchHidden", Gui%guiName%.Font, Gui%guiName%.Font_Size, Gui%guiName%.Font_Quality)
			
            Gui.Add(guiName "SearchHidden", "Edit", "x" 0 " y" 0 " w" SearchBox_W " h" SearchBox_H " FontQuality5 BackgroundTrans hwndhEDIT_HiddenSearchBar")

            Gui%guiName%_Controls["GuiSearchHandle"] := Gui%guiName%Search.Handle
            Gui%guiName%_Controls["GuiSearchHiddenHandle"] := Gui%guiName%SearchHidden.Handle
            Gui%guiName%_Controls.hEDIT_SearchBar := Gui%guiName%Search_Controls.hEDIT_SearchBar
            Gui%guiName%_Controls.hEDIT_HiddenSearchBar := Gui%guiName%SearchHidden_Controls.hEDIT_HiddenSearchBar

			Gui.BindFunctionToControl("GUI_Trades_V2", guiName "SearchHidden", "hEDIT_HiddenSearchBar", "SetFakeSearch", _buyOrSell, makeEmpty:=False) 

            Gui.SetDefault(guiName)
        }

        if (_guiMode="Stack") {
            sample1 := Get_TextCtrlSize("EXTREMELY_UNNECESSARILY_LONG_SAMPLE_TEXT", PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size, maxWidth:="", params="R1", ctrlType:="Text").W
            sample2 := Get_TextCtrlSize("EXTREMELY_UNNECESSARILY_LONG_SAMPLE_TEXT", PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size, maxWidth:="", params="R1", ctrlType:="Edit").W
            Gui.Add(guiName, "Picture", "x" Header2_X " y" Header2_Y " w" Header2_W " h" Header2_H " hwndhIMG_Header2 BackgroundTrans", SKIN.Assets.Misc.Header2) ; Title bar
            Gui.Add(guiName, "Text", "x" SearchBox_X+( (sample2-sample1)/2 ) " y" SearchBox_Y " w" SearchBox_W-( (sample2-sample1)/2 ) " h" SearchBox_H " FontQuality5 BackgroundTrans +0x200 c" SKIN.Settings.COLORS.SearchBar_Empty " hwndhTEXT_SearchBarFake", "...")
        }
        if (_guiMode="Tabs") {
            Gui.Add(guiName, "Picture", "x" TabsBackground_X " y" TabsBackground_Y " w" TabsBackground_W " h" TabsBackground_H " hwndhIMG_TabsBackground BackgroundTrans", SKIN.Assets.Misc.Tabs_Background) ; Title bar
        }
            
        Gui.Add(guiName, "ImageButton", "x" LeftArrow_X " y" LeftArrow_Y " w" LeftArrow_W " h" LeftArrow_H " hwndhBTN_LeftArrow", "", styles.Arrow_Left, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
        Gui.Add(guiName, "ImageButton", "x" RightArrow_X " y" RightArrow_Y " w" RightArrow_W " h" RightArrow_H " hwndhBTN_RightArrow", "", styles.Arrow_Right, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
        if (_guiMode="Tabs")
            Gui.Add(guiName, "ImageButton", "x" CloseTab_X " y" CloseTab_Y " w" CloseTab_W " h" CloseTab_H " hwndhBTN_CloseTab", "", styles.Close_Tab, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)

        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_LeftArrow", "ScrollUp", _buyOrSell) 
        Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_RightArrow", "ScrollDown", _buyOrSell)
        if (_guiMode="Tabs")
            Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_CloseTab", "RemoveTab", _buyOrSell, tabNum:=0, massRemove:=False)

        if (_guiMode="Tabs") {
            Loop % _tabsToRender {
                xpos := IsBetween(A_Index, 1, maxTabsToShow) ? TabButton%A_Index%_X : TabButton%maxTabsToShow%_X
                Gui.Add(guiName, "ImageButton", "x" xpos " y" TabButton1_Y " w" TabButton1_W " h" TabButton1_H " hwndhBTN_TabDefault" A_Index " Hidden", A_Index, Styles.Tab, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
                Gui.Add(guiName, "ImageButton", "x" xpos " y" TabButton1_Y " w" TabButton1_W " h" TabButton1_H " hwndhBTN_TabJoinedArea" A_Index " Hidden", A_Index, Styles.Tab_Joined, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
                Gui.Add(guiName, "ImageButton", "x" xpos " y" TabButton1_Y " w" TabButton1_W " h" TabButton1_H " hwndhBTN_TabWhisperReceived" A_Index " Hidden", A_Index, Styles.Tab_Whisper, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)

                Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_TabDefault" A_Index, "SetActiveTab", _buyOrSell, tabName:=A_Index, autoScroll:=True)
                Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_TabJoinedArea" A_Index, "SetActiveTab", _buyOrSell, tabName:=A_Index, autoScroll:=True)
                Gui.BindFunctionToControl("GUI_Trades_V2", guiName, "hBTN_TabWhisperReceived" A_Index, "SetActiveTab", _buyOrSell, tabName:=A_Index, autoScroll:=True)

                Gui%guiName%["Tab_" A_Index] := Gui%guiName%_Controls["hBTN_TabDefault" A_Index]
            }            
        }

        Loop % _tabsToRender {
			tabNum := A_Index, slotGuiName := guiName "_Slot" tabNum
            Gui.New(slotGuiName, "-Caption -Border +AlwaysOnTop +Parent" guiName " +LabelGUI_Trades_V2_Slot_ +HwndhGui" slotGuiName, "POE TC - Item Slot " tabNum)
            Gui.SetDefault(slotGuiName)
			Gui.Margin(slotGuiName, 0, 0)
			Gui.Color(slotGuiName, SKIN.Assets.Misc.Transparency_Color)
			Gui.Font(slotGuiName, Gui%guiName%.Font, Gui%guiName%.Font_Size, Gui%guiName%.Font_Quality)

			Gui.Add(slotGuiName, "Text", "x0 y0 w0 h0 BackgroundTrans Hidden hwndhTEXT_HiddenInfos", "")

			Gui.Add(slotGuiName, "Picture", "x" BackgroundImg_X " y" BackgroundImg_Y " hwndhIMG_Background BackgroundTrans", SKIN.Assets.Misc.Background)
			TilePicture(slotGuiName, Gui%guiName%_Slot%tabNum%_Controls.hIMG_Background, BackgroundImg_W, BackgroundImg_H) ; Fill the background
			
			Gui.Add(slotGuiName, "Text", "x" ItemName_X " y" ItemName_Y " w" ItemName_W " R1 BackgroundTrans hwndhTEXT_ItemName c" SKIN.Settings.COLORS.Trade_Info_2)
			Gui.Add(slotGuiName, "Text", "x" SellerName_X " y" SellerName_Y " w" SellerName_W " R1 BackgroundTrans hwndhTEXT_SellerName c" SKIN.Settings.COLORS.Trade_Info_2)
			Gui.Add(slotGuiName, "Picture", "x" CurrencyImg_X " y" CurrencyImg_Y " w" CurrencyImg_W " h" CurrencyImg_H " 0xE BackgroundTrans  hwndhIMG_CurrencyIMG")
			Gui.Add(slotGuiName, "Text", "x" PriceCount_X " y" PriceCount_Y " w" PriceCount_W " R1 BackgroundTrans hwndhTEXT_PriceCount c" SKIN.Settings.COLORS.Trade_Info_2)
			Gui.Add(slotGuiName, "Text", "x" AdditionalMsg_X " y" AdditionalMsg_Y " w" AdditionalMsg_W " R1 BackgroundTrans  hwndhTEXT_AdditionalMessage c" SKIN.Settings.COLORS.Trade_Info_2)
			Gui.Add(slotGuiName, "Text", "x" Time_X " y" Time_Y " w" Time_W " R1 BackgroundTrans hwndhTEXT_TimeSent c" SKIN.Settings.COLORS.Trade_Info_2)
			if (_buyOrSell="Sell") {
				Gui.Add(slotGuiName, "Picture", "x" TradeVerify_X " y" TradeVerify_Y " w" TradeVerify_W " h" TradeVerify_H " hwndhIMG_TradeVerifyColor BackgroundTrans", SKIN.Assets.Trade_Verify.Grey)
			}
            if (_guiMode="Stack") {
			    Gui.Add(slotGuiName, "ImageButton", "x" CloseTabVertical_X " y" CloseTabVertical_Y " w" CloseTabVertical_W " h" CloseTabVertical_H " hwndhBTN_CloseTab", "", Styles.Close_Tab_Vertical, PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
			}

			Loop 4 { ; Max 4 rows
				rowNum := A_Index
				rowH := SmallButton_H, rowW := rowNum=1 ? TabContentAvailableWidth-SellerName_X-5 : TabContentAvailableWidth-( (5*scaleMult)+(5*scaleMult) )
				row1Y := SmallButton_Y, row2Y := SmallButton_Y+rowH+(5*scaleMult), row3Y := row2Y+rowH+(5*scaleMult), row4Y := row3Y+rowH+(5*scaleMult)
				rowX := IsBetween(rowNum, 2, 4) ? leftMost+(5*scaleMult) : SmallButton_X, rowY := row%rowNum%Y

				; Preview only - Creating row button and style
				if (_isPreview=True) {				
					styleName := "CustomButton_" _buyOrSell "_Row" rowNum
					if !IsObject(Styles[styleName]) {
						; Loop 4 {
							; otherRowStyleName := RegExReplace(styleName, "_Row\d+", A_Index)
							; if IsObject(Styles[otherRowStyleName]) {
							; 	Styles[styleName] := ObjFullyClone(Styles[otherRowStyleName])
							; 	AllStylesData[styleName] := ObjFullyClone(AllStylesData[otherRowStyleName])
							; }
							; else {
								GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, styleName, rowW, rowH)
								AllStylesData[styleName] := {Width:rowW, Height:rowH}
							; }
						; }
					}					

					Gui.Add(slotGuiName, "ImageButton", "x" rowX " y" rowY " w" rowW " h" rowH " hwndhBTN_CustomRowSlot" rowNum " c" SKIN.Settings.COLORS.Trade_Info_2, "[ + ]", Styles[styleName], PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
					Gui.BindFunctionToControl("GUI_Trades_V2", slotGuiName, "hBTN_CustomRowSlot" rowNum, "Preview_AddCustomButtonsToRow", _buyOrSell, rowNum) 
				}
				; Creating buttons
				userThisRowMaxCount := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count
				spaceBetweenBtns := 4
				if (_isPreview) {
					Loop % rowNum=1?5:10 {
						thisRowMaxCount := A_Index

						Loop % thisRowMaxCount {
							btnsCount := thisRowMaxCount, btnNum := A_Index
							if ( Mod(btnNum, 2) = 0 ) {
								btnX := btnNum=1?rowX:"+"Floor(spaceBetweenBtns/2), btnY := rowY
								btnWidth := Floor(rowW/btnsCount), btnWidth := btnsCount>1 ? btnWidth - Floor(spaceBetweenBtns/2) : btnWidth, btnHeight := rowH
							}
							else {
								btnX := btnNum=1?rowX:"+"Ceil(spaceBetweenBtns/2), btnY := rowY
								btnWidth := Ceil(rowW/btnsCount), btnWidth := btnsCount>1 ? btnWidth - Ceil(spaceBetweenBtns/2) : btnWidth, btnHeight := rowH
							}
							btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
							btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
							styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"

							; Creating imagebutton style
							if !IsObject(Styles[styleName]) && (btnsCount = userThisRowMaxCount) {
							; 	otherRowStyleName := RegExReplace(styleName, "_Row\d+", A_Index)
							; 	if IsObject(Styles[otherRowStyleName]) {
							; 		Styles[styleName] := ObjFullyClone(Styles[otherRowStyleName])
							; 		AllStylesData[styleName] := ObjFullyClone(AllStylesData[otherRowStyleName])
							; 	}
							; 	else {
									if (btnIcon)
										GUI_Trades_V2.CreateGenericIconButtonStyle(Styles, styleName, btnWidth, btnHeight, btnIcon)
									else
										GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, styleName, btnWidth, btnHeight)
									AllStylesData[styleName] := {Width:btnWidth, height:btnHeight}
							; 	}
							}

							; Preview only - Button size data, used to create imagebuttons later
							if (_isPreview) {
								if !IsObject(AllStylesData["CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount "_Text"])
									AllStylesData["CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount "_Text"] := {Width:btnWidth, height:btnHeight}
								for iconName, iconFile in SKIN.Assets.Icons
									if !IsObject(AllStylesData["CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount "_Icon_" iconName])
										AllStylesData["CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount "_Icon_" iconName] := {Width:btnWidth, height:btnHeight}
							}

							if (_isPreview && btnsCount != userThisRowMaxCount)
								Gui.Add(slotGuiName, "Button", "x" btnX " y" btnY " w" btnWidth " h" btnHeight " hwndhBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum " c" SKIN.Settings.COLORS.Trade_Info_2 " Hidden", !btnIcon?btnName:"")
							else
								Gui.Add(slotGuiName, "ImageButton", "x" btnX " y" btnY " w" btnWidth " h" btnHeight " hwndhBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum " c" SKIN.Settings.COLORS.Trade_Info_2 " Hidden", !btnIcon?btnName:"", Styles[styleName], PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
							Gui.BindFunctionToControl("GUI_Trades_V2", slotGuiName, "hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum, "Preview_CustomizeThisCustomButton", _buyOrSell, rowNum, btnsCount, btnNum)
						}
					}
				}
				else {
					Loop % userThisRowMaxCount {
						btnsCount := userThisRowMaxCount, btnNum := A_Index
						if ( Mod(btnNum, 2) = 0 ) {
							btnX := btnNum=1?rowX:"+"Floor(spaceBetweenBtns/2), btnY := rowY
							btnWidth := Floor(rowW/btnsCount), btnWidth := btnsCount>1 ? btnWidth - Floor(spaceBetweenBtns/2) : btnWidth, btnHeight := rowH
						}
						else {
							btnX := btnNum=1?rowX:"+"Ceil(spaceBetweenBtns/2), btnY := rowY
							btnWidth := Ceil(rowW/btnsCount), btnWidth := btnsCount>1 ? btnWidth - Ceil(spaceBetweenBtns/2) : btnWidth, btnHeight := rowH
						}
						btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
						btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
						styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"

						; Creating imagebutton style
						if !IsObject(Styles[styleName]) {		
							Loop 4 {					
								otherRowStyleName := RegExReplace(styleName, "_Row(\d+?)", "_Row" A_Index)
								if IsObject(Styles[otherRowStyleName]) {
									Styles[styleName] := ObjFullyClone(Styles[otherRowStyleName])
									AllStylesData[styleName] := ObjFullyClone(AllStylesData[otherRowStyleName])
									Break
								}
								else if (A_Index=4) {
									if (btnIcon)
										GUI_Trades_V2.CreateGenericIconButtonStyle(Styles, styleName, btnWidth, btnHeight, btnIcon)
									else
										GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, styleName, btnWidth, btnHeight)
									AllStylesData[styleName] := {Width:btnWidth, height:btnHeight}
								}
							}
						}

						Gui.Add(slotGuiName, "ImageButton", "x" btnX " y" btnY " w" btnWidth " h" btnHeight " hwndhBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum " c" SKIN.Settings.COLORS.Trade_Info_2, !btnIcon?btnName:"", Styles[styleName], PROGRAM.FONTS[Gui%guiName%.Font], Gui%guiName%.Font_Size)
						Gui.BindFunctionToControl("GUI_Trades_V2", slotGuiName, "hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" btnNum, "DoCustomButtonAction", _buyOrSell, rowNum, btnNum, tabNum)
					}
				}
			}
					
			Gui%guiName%["Slot" tabNum] := Gui%guiName%_Slot%tabNum% ; adding gui array to our main gui array as a sub array
			Gui%guiName%["Slot" tabNum "_Controls"] := Gui%guiName%_Slot%tabNum%_Controls

            if (_guiMode="Stack")
                Gui.BindFunctionToControl("GUI_Trades_V2", slotGuiName, "hBTN_CloseTab", "RemoveTab", _buyOrSell, tabNum) 

			; Gui.Show(slotGuiName, "x0 y0 w" guiWidth+borderSize " h" TabContentSlot_H " Hide")	
			Gui.Show(slotGuiName, "w" TabContentSlot_W " h" TabContentSlot_H " Hide")	

            Gui%guiName%.ImageButton_Errors .= Gui%guiName%["Slot" tabNum].ImageButton_Errors
        }

        if (_guiMode="Stack") {
            ; calculate slot positions
            Gui%guiName%["Slot1_Pos"] := (Header2_Y+Header2_H)*windowsDPI
            Gui%guiName%["Slot2_Pos"] := Gui%guiName%["Slot1_Pos"] + (Gui%guiName%.Slot1.Height*windowsDPI)
            Gui%guiName%["Slot3_Pos"] := Gui%guiName%["Slot2_Pos"] + (Gui%guiName%.Slot1.Height*windowsDPI)
            Gui%guiName%["Slot4_Pos"] := Gui%guiName%["Slot3_Pos"] + (Gui%guiName%.Slot1.Height*windowsDPI)
        }
        else if (_guiMode="Tabs")
            Gui%guiName%["Slot1_Pos"] := (TabsBackground_Y+TabsBackground_H)*windowsDPI

        if (Gui%guiName%.ImageButton_Errors) {
			global GuiErrorLogBuy, GuiErrorLogBuyPreview, GuiErrorLogSellPreview, GuiErrorLogSell

			AppendToLogs(Gui%guiName%.ImageButton_Errors)
			TrayNotifications.Show(guiName " Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

        if !IsObject(GuiTrades)
            GuiTrades := {}
        if !IsObject(GuiTrades_Controls)
            GuiTrades_Controls := {}
	    GuiTrades[_buyOrSell] := Gui%guiName%, GuiTrades_Controls[_buyOrSell] := Gui%guiName%_Controls
		AllStyles[SKIN.Skin] := ObjFullyClone(Styles)
		GuiTrades.AllStyles := ObjFullyClone(AllStyles), GuiTrades.AllStylesData := ObjFullyClone(AllStylesData)

		if (_isPreview) {
			showHeight := _guiMode="Stack" ? Gui%guiName%.Height_Maximized_OneSlot : Gui%guiName%.Height_Maximized
        	Gui.Show(guiName, "x0 y0 h" showHeight " w" guiFullWidth " Hide")
		}
		else {
			guiIniSection := _buyOrSell="Sell"?"SELL_INTERFACE":"BUY_INTERFACE"
			savedXPos := PROGRAM.SETTINGS[guiIniSection].Pos_X, savedYPos := PROGRAM.SETTINGS[guiIniSection].Pos_Y
			savedXPos := IsNum(savedXPos) ? savedXPos : 0, savedYPos := IsNum(savedYPos) ? savedYPos : 0
			Gui.Show(guiName, "x" savedXPos " y" savedYPos " h" guiMinimizedHeight " w" guiFullWidth " Hide")
		}
        if (_guiMode="Stack") { 
            Gui.Show(guiName "Search", "x" SearchBox_X " y" SearchBox_Y " ")
            Gui.Show(guiName "SearchHidden", "x0 y0 w0 h0 NoActivate") ; Not hidden on purpose so it can work with ShellMessage to empty on click
        }
        GuiTrades[_buyOrSell].Is_Created := True

        GUI_Trades_V2.Minimize(_buyOrSell)

		if !(_isPreview) {
			Gui.OnMessageBind("GUI_Trades_V2", guiName, 0x200, "WM_MOUSEMOVE")
			Gui.OnMessageBind("GUI_Trades_V2", guiName, 0x20A, "WM_MOUSEWHEEL")
			Gui.OnMessageBind("GUI_Trades_V2", guiName, 0x201, "WM_LBUTTONDOWN")
			Gui.OnMessageBind("GUI_Trades_V2", guiName, 0x202, "WM_LBUTTONUP")
			WinGet, activeHwnd, ID, A
			ShellMessage(4, activeHwnd)

			GUI_Trades_V2.SetTransparency_Inactive(_buyOrSell)
			/* Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				GUI_Trades_V2.Enable_ClickThrough(_buyOrSell)
			*/

			GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)

			GUI_Trades_V2.EnableHotkeys(_buyOrSell)
		}

		if (_isPreview) {
			GuiTrades[_buyOrSell].Preview := True, GuiTrades[_buyOrSell].Is_Preview := True
			GUI_Trades_V2.SetTransparencyPercent(_buyOrSell, 100)
			if IsContaining(_buyOrSell, "Buy")
				GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Buying")
			else
				GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Selling")
		}
		SetControlDelay(delay), SetBatchLines(batch)
		Return

		GUI_Trades_V2_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, %A_Gui%:Name,% ctrlHwnd
			_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"
			_buyOrSell .= IsContaining(A_Gui, "Preview") ? "Preview" : ""
			
			if !(GuiTrades[_buyOrSell].Is_Preview)
				GUI_Trades_V2.ContextMenu(_buyOrSell, ctrlName)
		Return

        GUI_Trades_V2_Slot_Size:
			; So we can know the Slot gui height
			if (A_Gui)
				Gui%A_Gui%["Height"] := A_GuiHeight, Gui%A_Gui%["Width"] := A_GuiWidth
		Return

		GUI_Trades_V2_Slot_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, %A_Gui%:Name,% ctrlHwnd
			_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"
			_buyOrSell .= IsContaining(A_Gui, "Preview") ? "Preview" : ""
			
			if !(GuiTrades[_buyOrSell].Is_Preview)
				GUI_Trades_V2.ContextMenu(_buyOrSell, ctrlName)
			else
				GUI_Trades_V2.Preview_ContextMenu(_buyOrSell, ctrlName)
		return
    }

	Preview_ContextMenu(_buyOrSell, CtrlName) {
		global PROGRAM
		if RegExMatch(CtrlName, "iO)hBTN_CustomButtonRow(\d+)Max\d+Num(\d+)", matchObj) {
			try Menu, RClickMenu, DeleteAll
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.CreateHotkeyForThisButton, GUI_Trades_V2_CreateHotkeyForThisButton
			Menu, RClickMenu, Show
		}
		return

		GUI_Trades_V2_CreateHotkeyForThisButton:
			whichTab := IsContaining(_buyOrSell, "Buy") ? "Buying" : "Selling"
			GUI_Settings.Customization_SellingBuying_CreateHotkeyForThisButton(whichTab, matchObj.1, matchObj.2)
		return
	}

    ContextMenu(_buyOrSell, CtrlName) {
		global PROGRAM, GuiTrades, GuiTrades_Controls, GuiSettings, RUNTIME_PARAMETERS
		isStack := GuiTrades[_buyOrSell].Is_Stack
		isTabs := GuiTrades[_buyOrSell].Is_Tabs
		if (isStack) {
			if RegExMatch(A_Gui, "iO)Trades" _buyOrSell "_Slot(\d+)", slotIDPat)
				thisSlotID := slotIDPat.1
		}
		else if (isTabs) {
			thisSlotID := GuiTrades[_buyOrSell].Active_Tab
		}

		; Creating the menu
		try Menu, RClickMenu, DeleteAll
		Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition, GUI_Trades_V2_ContextMenu_LockPosition
		Menu, RClickMenu, Add
		if (RUNTIME_PARAMETERS.MiniFrizzle) { ; Switch RMENU_CloseAllTabs and RMENU_CloseOtherTabsForSameItem
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseOtherTabsForSameItem, GUI_Trades_V2_ContextMenu_CloseOtherTabsWithSameItem
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseAllTabs, GUI_Trades_V2_ContextMenu_CloseAllTabs
		}
		else {
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseAllTabs, GUI_Trades_V2_ContextMenu_CloseAllTabs
			Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseOtherTabsForSameItem, GUI_Trades_V2_ContextMenu_CloseOtherTabsWithSameItem
		}
		Menu, RClickMenu, Add
		Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.TrayMenu.Settings, GUI_Trades_V2_ContextMenu_OpenTrayMenu
		; Check - Disable - etc
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "True")
			Menu, RClickMenu, Check,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
		if (!GuiTrades[_buyOrSell].Tabs_Count)
			Menu, RClickMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseAllTabs
		if (!GuiTrades[_buyOrSell].Tabs_Count) || (isStack && !thisSlotID)
			Menu, RClickMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Trades.RMENU_CloseOtherTabsForSameItem
		; Show
		Menu, RClickMenu, Show		
		Return

		GUI_Trades_V2_ContextMenu_OpenTrayMenu:
			Menu,Tray,Show
		return

		GUI_Trades_V2_ContextMenu_LockPosition:
			Tray_ToggleLockPosition()
		Return

		GUI_Trades_V2_ContextMenu_CloseAllTabs:
			GUI_Trades_V2.CloseAllTabs(_buyOrSell)
		return

		GUI_Trades_V2_ContextMenu_CloseOtherTabsWithSameItem:
			GUI_Trades_V2.CloseOtherTabsForSameItem(_buyOrSell, thisSlotID)
		return
	}
	
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
     *
     * NEEDS ADAPTATION OR CHANGE
     *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    */

    DoCustomButtonAction(_buyOrSell, rowNum, btnNum, tabNum) {
		global PROGRAM
		global GuiTrades, GuiTrades_Controls
		static uniqueNum
		tabGamePID := GUI_Trades_V2.GetTabContent(_buyOrSell, tabNum).GamePID
		guiIniSection := _buyOrSell="Sell"?"SELL_INTERFACE":"BUY_INTERFACE"

		if !IsBetween(tabNum, 1, GuiTrades[_buyOrSell].Tabs_Count)
			return
		
		prevTitleMatchMode := SetTitleMatchMode("RegEx")
		if WinExist("[a-zA-Z0-9_] ahk_group POEGameGroup ahk_pid " tabGamePID) && (tabGamePID) {
			uniqueNum := !uniqueNum
			keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")

			thisBtnActions := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Actions
			Loop % thisBtnActions.Count() {
				actionType := thisBtnActions[A_Index].Type, actionContent := thisBtnActions[A_Index].Content

				if (actionType = "APPLY_ACTIONS_TO_BUY_INTERFACE")
					_buyOrSell := "Buy"
				else if (actionType = "APPLY_ACTIONS_TO_SELL_INTERFACE")
					_buyOrSell := "Sell"

				if (actionType != "COPY_ITEM_INFOS") ; Make sure to only copy item infos after all actions have been done
					Do_Action(actionType, actionContent, _buyOrSell, tabNum, uniqueNum)
				else
					doCopyActionAtEnd := True
			}
			if (doCopyActionAtEnd=True) {
				Sleep 100
				Do_Action("COPY_ITEM_INFOS", "", _buyOrSell, tabNum, uniqueNum)
			}
		}
		else { ; Instance doesn't exist anymore, replace and do btn action
			runningInstances := Get_RunningInstances()
			if !(runningInstances.Count) {
				TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.NoGameInstanceFound_Title, PROGRAM.TRANSLATIONS.TrayNotifications.NoGameInstanceFound_Msg)
				Return
			}
            else if (runningInstances.Count = 1)
                newInstancePID := runningInstances.1.PID
            else
			    newInstancePID := GUI_ChooseInstance.Create(runningInstances, "PID").PID

			Loop % GuiTrades[_buyOrSell].Tabs_Count {
				loopTabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, A_Index)
				looptabGamePID := loopTabContent.GamePID

				if (looptabGamePID = tabGamePID)
					GUI_Trades_V2.UpdateSlotContent(_buyOrSell, A_Index, "GamePID", newInstancePID)
			}
			GUI_Trades_V2.DoCustomButtonAction(_buyOrSell, rowNum, btnNum, tabNum)
		}
		SetTitleMatchMode(prevTitleMatchMode)
	}

    SaveStats(_buyOrSell, tabNum) {
		global PROGRAM, DEBUG
		
		; Load tab content obj
		tabContent := ObjFullyClone(GUI_Trades_V2.GetTabContent(_buyOrSell, tabNum))
		if (DEBUG.settings.use_chat_logs || tabContent.Seller = "iSellStuff" || tabContent.Buyer = "iSellStuff") {
			TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.iSellStuffNotSaved_Title, PROGRAM.TRANSLATIONS.TrayNotifications.iSellStuffNotSaved_Msg)
			Return
		}

		; Remove empty lines from tab content obj
		for key, value in tabContent {
			if (value = "")
				keysToRemoveDueToEmpty := keysToRemoveDueToEmpty ? keysToRemoveDueToEmpty "," key : key
		}
		Loop, Parse, keysToRemoveDueToEmpty,% ","
			tabContent.Delete(A_LoopField)
			
		; Add to the file obj
		histFile := _buyOrSell="Buy" ? PROGRAM.TRADES_BUY_HISTORY_FILE : PROGRAM.TRADES_SELL_HISTORY_FILE
		if !FileExist(histFile)
			histfileObj := {}
		else
			histfileObj := JSON_Load(histFile)
		histfileObj.Push(ObjFullyClone(tabContent))

		; Making backup of old file
		SplitPath, histFile, fileName
		FileMove,% histFile,% PROGRAM.TEMP_FOLDER "\" fileName ".bak", 1

		; Writting the new content
		jsonText := JSON.Dump(histfileObj, "", "`t")
		hFile := FileOpen(histFile, "w", "UTF-8")
		hFile.Write(jsonText)
		hFile.Close()
	}

    PushNewTab(_buyOrSell, infos) {
        ; FINISHED_V2
		global PROGRAM, SKIN
		global GuiTrades, GuiTrades_Controls
		windowsDPI 		:= GuiTrades[_buyOrSell].Windows_DPI
        tabsLimit       := GuiTrades[_buyOrSell].Tabs_Limit
		tabsCount       := GuiTrades[_buyOrSell].Tabs_Count
        maxTabsToShow   := GuiTrades[_buyOrSell].Max_Tabs_Per_Row
        isStack         := GuiTrades[_buyOrSell].Is_Stack
        isTabs          := GuiTrades[_buyOrSell].Is_Tabs
		isFirstTab      := tabsCount=0 ? True : False

		if (_buyOrSell="Buy" && PROGRAM.SETTINGS.BUY_INTERFACE.Mode="Disabled")
		|| (_buyOrSell="Sell" && PROGRAM.SETTINGS.SELL_INTERFACE.Mode="Disabled")
			return "InterfaceDisabled"
		
        ; Comparing if we already have a tab with same exact infos
		existingTabID := GUI_Trades_V2.IsTabAlreadyExisting(_buyOrSell, infos)
		if (existingTabID)
			Return "TabAlreadyExists"
		if GUI_Trades_V2.IsTrade_In_IgnoreList(infos) {
			AppendToLogs(A_ThisFunc "(): Canceled creating new tab due to trade being in ignore list:" 
			. "Buyer: """ tabInfos.Buyer """ - Item: """ tabInfos.Item """ - Price: """ tabInfos.Price """ - Stash:""" tabInfos.Stash """")
			return "TabIgnored"
		}
        ; If tabs limit is close, allocate more slots
		if (tabsCount+1 >= tabsLimit) && !IsContaining(_buyOrSell, "Preview") {
			GUI_Trades_V2.IncreaseTabsLimit(_buyOrSell)
			GUI_Trades_V2.PushNewTab(_buyOrSell, infos)
			return
		}

        ; Putting infos to slot
        newTabsCount := (tabsCount <= 0) ? 1 : tabsCount+1
		GUI_Trades_V2.SetSlotContent(_buyOrSell, tabsCount+1, infos)
        if (isStack)
		    GUI_Trades_V2.SetSlotPosition(_buyOrSell, tabsCount+1, tabsCount+1)
        else if (isTabs) {
            if IsBetween(newTabsCount, 1, maxTabsToShow) { ; Show new tab btn if its in the row
                GuiControl, Trades%_buyOrSell%:Show,% GuiTrades[_buyOrSell]["Tab_" newTabsCount]
            }
            GUI_Trades_V2.SetSlotPosition(_buyOrSell, tabsCount+1, 1)
		}
		GuiTrades[_buyOrSell]["Tab" tabsCount+1 "Content"] := infos
        GuiTrades[_buyOrSell].Tabs_Count := newTabsCount

        ; Maximize if setting is enabled
		if (isFirstTab) {
            GUI_Trades_V2.SetActiveTab(_buyOrSell, 1)
			GUI_Trades_V2.SetTransparency_Active(_buyOrSell)
            if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMaximizeOnFirstNewTab = "True")
			    GUI_Trades_V2.Maximize(_buyOrSell)
		}

        ; Update the title text with new tabs count
		if (newTabsCount > 0) {
			GuiControl,Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell]["hTEXT_Title"],% PROGRAM.NAME " (" newTabsCount ")"
			; GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
			GuiControl,% "Trades" _buyOrSell ": +c" SKIN.Settings.COLORS.Title_Trades,% GuiTrades_Controls[_buyOrSell]["hTEXT_Title"]
			; GuiControl,% "TradesMinimized: +c" SKIN.Settings.COLORS.Title_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			GUI_Trades_V2.SetTransparency_Active(_buyOrSell)
			GUI_Trades_V2.Disable_ClickThrough(_buyOrSell)
			GUI_Trades_V2.Redraw(_buyOrSell)
		}

        ; Update the GUI height if the mode is slots
        if (isStack) {
			gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
			GuiTrades[_buyOrSell].Height_Maximized := guiHeightMax := newTabsCount = 0 ? GuiTrades[_buyOrSell].Height_Minimized
				: newTabsCount = 1 ? GuiTrades[_buyOrSell].Height_Maximized_OneSlot
				: newTabsCount = 2 ? GuiTrades[_buyOrSell].Height_Maximized_TwoSlot
				: newTabsCount = 3 ? GuiTrades[_buyOrSell].Height_Maximized_ThreeSlot
				: newTabsCount >= 4 ? GuiTrades[_buyOrSell].Height_Maximized_FourSlot
				: GuiTrades[_buyOrSell].Height_Maximized_FourSlot
			sizeDiff := (GuiTrades[_buyOrSell].Height_Maximized*windowsDPI)-gtPos.H

			if (GuiTrades[_buyOrSell].Is_Minimized) {
				Gui.Show("Trades" _buyOrSell, "h" GuiTrades[_buyOrSell].Height_Minimized " NoActivate")
			}
			else if (GuiTrades[_buyOrSell].Is_Maximized) {
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToTheBottom = "True") {
					guiY := "y" gtPos.Y-sizeDiff
				}
				Gui.Show("Trades" _buyOrSell, guiY " h" guiHeightMax " NoActivate")
			}
        }
		if (_buyOrSell="Sell") 
			GUI_Trades_V2.VerifyItemPrice( GUI_Trades_V2.GetTabContent(_buyOrSell, newTabsCount) )
		GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)

		if (_buyOrSell="Sell" && !IsGameWindowActive() && PROGRAM.SETTINGS.SETTINGS_MAIN.ShowTabbedTradesCounterButton = "True") {
			GUI_TabbedTradesCounter.Show()
		}
	}

	SetSlotContent(params*) {
		return GUI_Trades_V2.SetTabContent(params*)
	}

    SetTabContent(_buyOrSell, slotNum, tabInfos, isNewlyPushed=False, updateOnly=False) {
		; Set the content of the Slot gui, increase tab count
		global PROGRAM
		global GuiTrades, GuiTrades_Controls
		windowsDPI := GuiTrades[_buyOrSell].Windows_DPI

        ; Get current tab content + merge current and new content keys
		cTabCont := GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum)
		if IsObject(tabInfos)
			merged := ObjMerge(cTabCont, tabInfos)
		else {
			merged := ObjFullyClone(cTabCont), tabInfos := {}
			for key, value in merged
				tabInfos[key] := ""
		}

		allSlots := ""
		for key, value in merged
			allSlots .= "," key
		if ( SubStr(allSlots, 1, 1) = "," )
			StringTrimLeft, allSlots, allSlots, 1

        ; Creating the new content obj
		newContent := {}
		Loop, Parse, allSlots,% ","
		{
			loopedKey := A_LoopField
			currentValue := cTabCont[loopedKey]
			newValue := tabInfos[loopedKey]

			finalValue := updateOnly && !newValue ? currentValue : newValue
			AutoTrimStr(finalValue)
			newContent[loopedKey] := finalValue
		}
		newAdditionalMsgFull := StrReplace(newContent.AdditionalMessageFull, "`n", "\n"), newAdditionalMsgFull := StrReplace(newAdditionalMsgFull, "`r", "\n")
		numberOfMsgs := 0
		additionalMsgSplit := StrSplit(newAdditionalMsgFull, "\n"), numberOfMsgs := additionalMsgSplit.MaxIndex()
		if (numberOfMsgs = 0 || numberOfMsgs=1 || numberOfMsgs="")
			RegExMatch( StrSplit(newAdditionalMsgFull, "\n").1 , "O)\[\d+\:\d+\] \@(?:To|From)\: (.*)", outPat), newAdditionalMsg := outPat.1
		else
			newAdditionalMsg := numberOfMsgs " total messages. Click here to see."

		AutoTrimStr(newAdditionalMsgFull, newAdditionalMsg)
		newContent.AdditionalMessageFull := newAdditionalMsgFull, newContent.AdditionalMessage := newAdditionalMsg

        ; Setting default visible text
		visibleSeller := newContent.Seller ? newContent.Seller : newContent.Buyer
		visibleItem := newContent.GemLevel && newContent.GemQuality ? newContent.Item " (Lvl " newContent.GemLevel " " newContent.GemQuality "%)"
			: newContent.GemLevel && !newContent.GemQuality ? newContent.Item " (Lvl " newContent.GemLevel ")"
			: !newContent.GemLevel && newContent.GemQuality ? newContent.Item " (" newContent.GemQuality "%)"
			: newContent.Item
		visiblePrice := newContent.PriceCount
		visibleStash := newContent.StashTab ? newContent.StashTab " (" newContent.StashX "," newContent.tradeStashY ")"
		visibleTime := newContent.TimeSent ? newContent.TimeSent : newContent.TimeReceived
		visibleAdditionalMsg := newContent.AdditionalMessage

		; Trim strings based on size
		itemSlotSizeMax := Get_ControlCoords("Trades" _buyOrSell "_Slot" slotNum, GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_ItemName).W
		newItemTxtSize := Get_TextCtrlSize(txt:=visibleItem, fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W
		sellerSlotSizeMax := Get_ControlCoords("Trades" _buyOrSell "_Slot" slotNum, GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_SellerName).W
		newSellerTxtSize := Get_TextCtrlSize(txt:=visibleSeller, fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W
        addMsgSlotSizeMax := Get_ControlCoords("Trades" _buyOrSell "_Slot" slotNum, GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_AdditionalMessage).W
		newAddMsgTxtSize := Get_TextCtrlSize(txt:=visibleAdditionalMsg, fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W

		if (newItemTxtSize >= itemSlotSizeMax-10) {	
			cutStr := visibleItem
			Loop % Ceil( StrLen(visibleItem)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W
				if !(newSize >= itemSlotSizeMax-10)
					Break
			}
			visibleItem := cutStr "..."
			hiddenInfosWall .= "`n" "ItemIsCut:"		A_Tab True
		}
		else
			hiddenInfosWall .= "`n" "ItemIsCut:"		A_Tab False

		if (newSellerTxtSize >= sellerSlotSizeMax) {	
			cutStr := visibleSeller
			Loop % Ceil( StrLen(visibleSeller)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W
				if !(newSize >= sellerSlotSizeMax)
					Break
			}
			visibleSeller := cutStr "..."
			hiddenInfosWall .= "`n" "SellerIsCut:"		A_Tab True
		}
		else
			hiddenInfosWall .= "`n" "SellerIsCut:"		A_Tab False

		if (newAddMsgTxtSize >= addMsgSlotSizeMax) {	
			cutStr := visibleAdditionalMsg
			Loop % Ceil( StrLen(visibleAdditionalMsg)/3 ) {
				StringTrimRight, cutStr, cutStr, 3
				newSize := Get_TextCtrlSize(txt:=cutStr "...", fontName:=GuiTrades[_buyOrSell].Font, fontSize:=GuiTrades[_buyOrSell].Font_Size).W
				if !(newSize >= addMsgSlotSizeMax)
					Break
			}
			visibleAdditionalMsg := cutStr "..."
		}

        ; Creating the block of txt containing all infos
		for key, value in newContent
			hiddenInfosWall .= "`n" key ":" value
		if ( SubStr(hiddenInfosWall, 1, 1) = "`n" )
			StringTrimLeft, hiddenInfosWall, hiddenInfosWall, 1

		; Setting content to controls
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_HiddenInfos,% hiddenInfosWall
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_ItemName,% visibleItem
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_SellerName,% visibleSeller
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_PriceCount,% visiblePrice
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_AdditionalMessage,% visibleAdditionalMsg
		GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_TimeSent,% visibleTime
		
		; Reduce some controls size based on their content + move them to make it look better
            ; PriceCount - Cutting control size
        priceCountW := Get_TextCtrlSize(visiblePrice, GuiTrades[_buyOrSell].Font, GuiTrades[_buyOrSell].Font_Size, "", "R1").W
		GuiControl, Move,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_PriceCount,% "w" priceCountW*windowsDPI
		    ; Move AdditionalMessage next to PriceCount
        priceCountPos := ControlGetPos(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_PriceCount)
        whisperSeller := ControlGetPos(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hBTN_WhisperSeller)
		GuiControl, Move,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hTEXT_AdditionalMessage,% "x" (priceCountPos.x+priceCountPos.w+10)/windowsDPI " w" (whisperSeller.x-( priceCountPos.x+priceCountPos.w+10 )-10)/windowsDPI

		; Set currency IMG 
		if (newContent.PriceCurrency != cTabCont.PriceCurrency) {
			if (newContent.PriceCurrency = "") {
				GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_CurrencyIMG,% newContent.PriceCurrency
			}
			else {
				if FileExist(PROGRAM.CURRENCY_IMGS_FOLDER "\" newContent.PriceCurrency ".png")
					currencyPngFile := PROGRAM.CURRENCY_IMGS_FOLDER "\" newContent.PriceCurrency ".png"
				else if (tabInfos.WhisperLanguage != "ENG") {
					currencyEngName := Get_CurrencyEnglishName(newContent.PriceCurrency, tabInfos.WhisperLanguage)
					currencyPngFile := PROGRAM.CURRENCY_IMGS_FOLDER "\" currencyEngName ".png"
				}
				else 
					currencyPngFile := PROGRAM.CURRENCY_IMGS_FOLDER "\Unknown.png"

                imgSlotPos := ControlGetPos(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_CurrencyIMG)				
				hBitMap := Gdip_CreateResizedHBITMAP_FromFile(currencyPngFile, imgSlotPos.W, imgSlotPos.H, PreserveAspectRatio:=False)
				SetImage(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_CurrencyIMG, hBitmap)
			}
			GuiControl, Hide,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_CurrencyIMG ; basically "redraw", fixes old pic still there behind
			GuiControl, Show,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_CurrencyIMG
		}

		; Set color dot IMG
		if (_buyOrSell="Sell") {
			if (newContent.TradeVerifyColor != cTabCont.TradeVerifyColor) {
				if (newContent.TradeVerifyColor = "") {
					GuiControl, ,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_TradeVerifyColor,% newContent.TradeVerifyColor
				}
				else {
					priceVerifyColorPng := GuiTrades[_buyOrSell].SkinAssets.Trade_Verify[newContent.TradeVerifyColor]
					imgSlotPos := ControlGetPos(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_TradeVerifyColor)				
					hBitMap := Gdip_CreateResizedHBITMAP_FromFile(priceVerifyColorPng, imgSlotPos.W, imgSlotPos.H, PreserveAspectRatio:=False)
					SetImage(GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_TradeVerifyColor, hBitmap)
				}
				GuiControl, Hide,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_TradeVerifyColor ; basically "redraw", fixes old pic still there behind
				GuiControl, Show,% GuiTrades[_buyOrSell]["Slot" slotNum "_Controls"].hIMG_TradeVerifyColor
			}
		}

		hasNewMsgChanged := newContent.HasNewMessage != cTabCont.HasNewMessage ? True : False
		hasIsInAreaChanged := newContent.IsInArea != cTabCont.IsInArea ? True : False
		if (hasNewMsgChanged && newContent.HasNewMessage)
			GUI_Trades_V2.SetTabStyleWhisperReceived(slotNum)
		else if (hasIsInAreaChanged && newContent.IsInArea)
			GUI_Trades_V2.SetTabStyleJoinedArea(slotNum)
		else if (hasNewMsgChanged && hasIsInAreaChanged && !newContent.HasNewMessage && !newContent.IsInArea)
		|| (hasNewMsgChanged && !newContent.HasNewMessage && !newTabCont.IsInArea)
		|| (hasIsInAreaChanged && !newContent.IsInArea && !newTabCont.HasNewMessage) {
			GUI_Trades_V2.SetTabStyleDefault(slotNum)
		}

	}
	
	VerifyItemPrice(tabInfos) {
	/*
		Verify an item's price based on the information we have
		User acc name, item name, item level & qual for gems, stash tab & stash position
	*/
		global PROGRAM

		tabNum := GUI_Trades_V2.GetTabNumberFromUniqueID("Sell", tabInfos.UniqueID)
		if (A_IsCompiled) {
			GUI_Trades_V2.UpdateSlotContent("Sell", tabNum, "TradeVerifyColor", "Orange")
			GUI_Trades_V2.UpdateSlotContent("Sell", tabNum, "TradeVerifyText", "Automated price verifying has been"
			. "\n disabled for the executable version due to issues"
			. "\n\nPlease use the AHK version if you wish to use this feature")
			return
		}
		GUI_Trades_V2.UpdateSlotContent("Sell", tabNum, "TradeVerifyColor", "Grey")
		GUI_Trades_V2.UpdateSlotContent("Sell", tabNum, "TradeVerifyText", "Verifying price...")

		cmdLineParamsObj := {}, cmdLineParamsObj.TradeData := ObjFullyClone(tabInfos)
		cmdLineParamsObj.Accounts := ObjFullyClone(PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts)

		intercomSlotNum := GUI_Intercom.GetNextAvailableSlot()
		intercomSlotHandle := GUI_Intercom.GetSlotHandle(intercomSlotNum)
		GUI_Intercom.ReserveSlot(intercomSlot)
		cmdLineParamsObj.Intercom := {"GuiHandle": GUI_Intercom.sGUI.Handle, "SlotHandle": intercomSlotHandle}
		cmdLineParamsObj.PROGRAM := {"CURL_EXECUTABLE": PROGRAM.CURL_EXECUTABLE, "LOGS_FILE": PROGRAM.LOGS_FILE, "DATA_FOLDER": PROGRAM.DATA_FOLDER}

		; Adding params to temp json file
		cmdLineParamsJSON := PROGRAM.TEMP_FOLDER "\CmdLine_" RandomStr(10)
		Loop 10 {
			ranStr := RandomStr(10)
			if !FileExist(PROGRAM.TEMP_FOLDER "\CmdLine_" ranStr ".json") {
				cmdLineParamsJSON := PROGRAM.TEMP_FOLDER "\CmdLine_" RandomStr(10) ".json"
				Break
			}
			Sleep 10
		}
		hFile := FileOpen(cmdLineParamsJSON, "w", "UTF-8")
        hFile.Write(JSON_Dump(cmdLineParamsObj))
        hFile.Close()

		; Running StandAlone file
		cl := DllCall( "GetCommandLine", "str" )
		StringMid, path_AHk, cl, 2, InStr( cl, """", true, 2 )-2

		saFile := A_ScriptDir "\lib\SA_PriceVerify.ahk"
		saFile_run_cmd := % """" path_AHk """" A_Space """" saFile """"
		.		" /CmdLineParamsJSON=""" cmdLineParamsJSON """"
		
		Run,% saFile_run_cmd,% A_ScriptDir
	}

	Use_WindowMode(checkOnly=False) {
		global PROGRAM, GuiTrades

		if (checkOnly=False) {
			PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode := "Window"
			GuiTrades.Sell.Docked_Window_Handle := ""

			GUI_Trades_V2.ResetPosition("Buy")
			GUI_Trades_V2.ResetPosition("Sell")
			Save_LocalSettings()
		}

		/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
			Menu, Tray, UnCheck,% PROGRAM.TRANSLATIONS.TrayMenu.ModeDock
			Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.ModeWindow
			Menu, Tray, Disable,% PROGRAM.TRANSLATIONS.TrayMenu.CycleDock

			Menu, Tray, Enable,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition
		}
		*/
	}

	Use_DockMode(checkOnly=False) {
		global PROGRAM, GuiTrades
		TrayNotifications.Show("Dock mode no longer available", "Dock mode has been removed. Please use the Lock Position option instead.")
		GUI_Trades_V2.Use_WindowMode() ; On purpose. Disabling Dock mode as of 1.15 ALPHA 8
		return

		/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
		if (checkOnly=False) {
			PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode := "Dock"
			GuiTrades.Sell.Docked_Window_Handle := ""

			GUI_Trades_V2.ResetPosition("Buy")
			GUI_Trades_V2.ResetPosition("Sell")
			Save_LocalSettings()
		}

		Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.ModeDock
		Menu, Tray, UnCheck,% PROGRAM.TRANSLATIONS.TrayMenu.ModeWindow
		Menu, Tray, Enable,% PROGRAM.TRANSLATIONS.TrayMenu.CycleDock

		Tray_ToggleLockPosition("Check")
		Menu, Tray, Disable,% PROGRAM.TRANSLATIONS.TrayMenu.LockPosition

		GUI_Trades_V2.DockMode_Cycle()
		*/
	}

	DockMode_Cycle(dontSetPos=False) {
		/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
		global GuiTrades

		gameInstances := Get_RunningInstances()
		Loop % gameInstances.Count {
			if (gameInstances[A_Index]["Hwnd"] = GuiTrades.Sell.Docked_Window_Handle)
				cycleIndex := A_Index=gameInstances.Count ? 1 : A_Index+1
		}
		cycleIndex := cycleIndex ? cycleIndex : 1
		GuiTrades.Sell.Docked_Window_Handle := gameInstances[cycleIndex]["Hwnd"]

		if (dontSetPos=False)
			GUI_Trades_V2.DockMode_SetPosition()
		*/
	}

	DockMode_SetPosition() {
		/* BdO6CY5Oov - Intentionally disabled - Getting rid of Dock mode as of 1.15 ALPHA 8
		global GuiTrades
		TrayNotications.Show("Dock mode disabled.", "Dock mode has been disabled for now. It may actually be completely be scrapped off in the future.")
		GUI_Trades_V2.Use_WindowMode()
		return

		if !WinExist("ahk_id " GuiTrades.Sell.Docked_Window_Handle " ahk_group POEGameGroup") {
			GUI_Trades_V2.DockMode_Cycle(dontSetPos:=True)
			return
		}

		hw := DetectHiddenWindows("On")

		WinGet, isMinMax, MinMax,% "ahk_id " GuiTrades.Sell.Docked_Window_Handle
		isWinMinimized := isMinMax=-1?True:False

		WinGetPos, dockedX, dockedY, dockedW, dockedH,% "ahk_id " GuiTrades.Sell.Docked_Window_Handle
		clientInfos := GetWindowClientInfos("ahk_id " GuiTrades.Sell.Docked_Window_Handle)
		dockedX -= clientInfos.X, dockedY += clientInfos.Y
		
		gtPos := GUI_Trades_V2.GetPosition()
		
		if (GuiTrades.Is_Minimized)
			moveToX := (dockedX+dockedW)-gtmPos.W, moveToY := dockedY 
		else moveToX := (dockedX+dockedW)-gtPos.W, moveToY := dockedY 

		if IsNum(dockedX) && ( (GuiTrades.Is_Minimized && gtPos.X = moveToX && gtPos.Y = moveToY) || (GuiTrades.Is_Minimized && gtmPos.X = moveToX && gtmPos.Y = moveToY) ) {
			DetectHiddenWindows(hw)
			Return
		}
		else if !IsNum(dockedX) || (isWinMinimized) {
			AppendToLogs(A_ThisFunc "(): Couldn't dock Trades GUI to game window. Resetting pos and cycling to next game window.")
			GUI_Trades_V2.ResetPosition("Buy", dontWrite:=True)
			GUI_Trades_V2.ResetPosition("Sell", dontWrite:=True)
			GUI_Trades_V2.DockMode_Cycle(dontSetPos:=True)
		}
		else {
			if (GuiTrades.Is_Minimized)
				WinMove,% "ahk_id " GuiTradesMinimized.Handle, ,% moveToX,% moveToY
			else WinMove,% "ahk_id " GuiTrades.Handle, ,% moveToX,% moveToY
		}

		if (GuiTrades.Is_Minimized)
			GUI_TradesMinimized.SavePosition()
		else  {
			GUI_Trades_V2.SavePosition("Buy")
			GUI_Trades_V2.SavePosition("Sell")
		}
		
		DetectHiddenWindows(hw)
		*/
	}

	SetOrUnsetTabStyle(setOrUnset="", styleToApply="", playerOrTab="", applyToThisTabOnly=False) {
		global GuiTrades, GuiTrades_Controls

		if (!GuiTrades.Sell.Is_Tabs)
			return

		if !(setOrUnset) || !(playerOrTab) || (!styleToApply) {
			MsgBox(4096, "", "Invalid use of GUI_Trades_V2.SetOrUnsetTabStyle()`n`nsetOrUnset: " setOrUnset "`nplayerOrTab: " playerOrTab "`nstyleToApply: " styleToApply)
			return
		}

		tabNum := IsNum(playerOrTab) ? tabNum : ""
		buyerName := IsNum(playerOrTab) ? GUI_Trades_V2.GetTabContent("Sell", playerOrTab).Buyer : playerOrTab

		; Retrieve which tabs this buyer owns
		if (applyToThisTabOnly=True && tabNum) {
			tabContent := GUI_Trades_V2.GetTabContent("Sell", buyerName)
			buyerTabs := tabNum, tab%playerOrTab%IsInArea := tabContent.IsInArea, tab%playerOrTab%HasNewMessage := tabContent.HasNewMessage
		}
		else {
			Loop % GuiTrades.Sell.Tabs_Count {
				tabContent := GUI_Trades_V2.GetTabContent("Sell", A_Index)
				if (tabContent.Buyer = buyerName) {
					buyerTabs .= A_Index ",", tab%A_Index%IsInArea := tabContent.IsInArea, tab%A_Index%HasNewMessage := tabContent.HasNewMessage
				}
			}
			StringTrimRight, buyerTabs, buyerTabs, 1
		}

		Loop, Parse, buyerTabs,% ","
		{
			styleCurrentHwnd := GuiTrades.Sell["Tab_" A_LoopField]
			styleCurrent := styleCurrentHwnd = GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField] ? "Default"
				: styleCurrentHwnd = GuiTrades_Controls.Sell["hBTN_TabJoinedArea" A_LoopField] ? "JoinedArea"
				: styleCurrentHwnd = GuiTrades_Controls.Sell["hBTN_TabWhisperReceived" A_LoopField] ? "WhisperReceived"
				: "Default"

			if (setOrUnset = "Set") {
				styleToBeAppliedHwnd := styleToApply="Default"?GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField]
					: styleToApply = "JoinedArea"?GuiTrades_Controls.Sell["hBTN_TabJoinedArea" A_LoopField]
					: styleToApply = "WhisperReceived"?GuiTrades_Controls.Sell["hBTN_TabWhisperReceived" A_LoopField]
					: GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField]
			}
			else if (setOrUnset = "UnSet") {
				styleToBeAppliedHwnd := styleToApply="JoinedArea" && tab%A_LoopField%HasNewMessage = True ? GuiTrades_Controls.Sell["hBTN_TabWhisperReceived" A_LoopField]
					: styleToApply="JoinedArea" && tab%A_LoopField%HasNewMessage != True ? GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField]
					: styleToApply="WhisperReceived" && tab%A_LoopField%IsInArea = True ? GuiTrades_Controls.Sell["hBTN_TabJoinedArea" A_LoopField]
					: styleToApply="WhisperReceived" && tab%A_LoopField%IsInArea != True ? GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField]
					: GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField]
			}

			styleToBeApplied := styleToBeAppliedHwnd = GuiTrades_Controls.Sell["hBTN_TabDefault" A_LoopField] ? "Default"
				: styleToBeAppliedHwnd = GuiTrades_Controls.Sell["hBTN_TabJoinedArea" A_LoopField] ? "JoinedArea"
				: styleToBeAppliedHwnd = GuiTrades_Controls.Sell["hBTN_TabWhisperReceived" A_LoopField] ? "WhisperReceived"
				: "Default"

			tabContent := GUI_Trades_V2.GetTabContent("Sell", A_LoopField)
			if (styleToApply = "JoinedArea" && !tabContent.IsInArea)
				GUI_Trades_V2.UpdateSlotContent("Sell", A_LoopField, "IsInArea", setOrUnset="Set"? True : False)
			else if (styleToApply = "WhisperReceived" && !tabContent.HasNewMessage)
				GUI_Trades_V2.UpdateSlotContent("Sell", A_LoopField, "HasNewMessage", setOrUnset="Set"? True : False)
			else if (styleToApply = "Default") && (tabContent.HasNewMessage || tabContent.IsInArea) {
				GUI_Trades_V2.UpdateSlotContent("Sell", A_LoopField, {HasNewMessage:False, IsInArea:False}, False)
			}

			if (styleCurrent != styleToBeApplied) {
				if (setOrUnset="Set" && styleToBeApplied="WhisperReceived" && styleCurrent="JoinedArea") {
					; Don't do anything. Joined area has priority over WhisperReceived.
				}
				else {
					GuiControl, TradesSell:Show,% styleToBeAppliedHwnd
					GuiControl, TradesSell:Hide,% styleCurrentHwnd
					GuiTrades.Sell["Tab_" A_LoopField] := styleToBeAppliedHwnd
					if (A_LoopField = GuiTrades.Sell.Active_Tab) {
						GuiControl, TradesSell:+Disabled,% styleToBeAppliedHwnd
						GuiControl, TradesSell:-Disabled,% styleCurrentHwnd
					}
					styleChanged := True
				}
			}
		}

;		if (styleChanged = True) {
;			GUI_Trades_V2.SetActiveTab( tabName:=GUI_Trades_V2.GetActiveTab(), autoScroll:=True)
;		}

		return styleChanged
	}

	SetTabStyleDefault(playerOrTab) {
		return GUI_Trades_V2.SetOrUnsetTabStyle("Set", "Default", playerOrTab)
	}

	SetTabStyleJoinedArea(playerOrTab) {
		return GUI_Trades_V2.SetOrUnsetTabStyle("Set", "JoinedArea", playerOrTab)
	}

	UnSetTabStyleJoinedArea(playerOrTab) {
		return GUI_Trades_V2.SetOrUnsetTabStyle("Unset", "JoinedArea", playerOrTab)
	}

	SetTabStyleWhisperReceived(playerOrTab) {
		return GUI_Trades_V2.SetOrUnsetTabStyle("Set", "WhisperReceived", playerOrTab)
	}

	UnSetTabStyleWhisperReceived(playerOrTab) {
		return GUI_Trades_V2.SetOrUnsetTabStyle("Unset", "WhisperReceived", playerOrTab, applyToThisTabOnly:=True)
	}

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
     *
     * WILL NEED SOME REVIEWING
     *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    */

	ShowItemGrid(tabNum) {
		global PROGRAM, GuiTrades
		; static prev_tabXPos, prev_tabYPos, prev_tabStashTab
		; static prev_winX, prev_winY, prev_clientInfos

		tabInfos := GUI_Trades_V2.GetTabContent("Sell", tabNum)
		tabXPos := tabInfos.StashX, tabYPos := tabInfos.StashY, tabStashTab := tabInfos.StashTab, tabStashItem := tabInfos.Item

		if !IsNum(tabXPos) || !IsNum(tabYPos) {
			GUI_Trades_V2.DestroyItemGrid()
			return
		}
		
		if (tabXPos && tabYPos) && WinExist("ahk_pid " tabInfos.GamePID " ahk_group POEGameGroup") {
			WinGetPos, winX, winY, winW, winH,% "ahk_pid " tabInfos.GamePID " ahk_group POEGameGroup"
			clientInfos := GetWindowClientInfos("ahk_pid" tabInfos.GamePID " ahk_group POEGameGroup")

			if RegExMatch(tabInfos.Item, "O)(.*) \(T(\d+)\)$", itemPat) {
				itemType := "Map", mapTier := itemPat.2
				if IsContaining_Parse(tabStashItem, PROGRAM.DATA.UNIQUE_MAPS_LIST, "`n", "`r")
					mapTier := "unique"
			}

			if (clientInfos.Y = 0) && IsIn(clientInfos.H, "606,774,870,726,806,966,1030,1056,1086,1206") ; Fix issue where +6 is added to res H
				clientInfos.H -= 6	

			; itemGridExists := GUI_ItemGrid.Exists()
			; if !(itemGridExists) ; if not visible, or visible and one variable changed
			;  || (itemGridExists) && ( (prev_tabXPos != tabXPos) || (prev_tabYPos != tabYPos) || (prev_tabStashTab != tabStashTab)
			;  || (prev_winX != winX) || (prev_winY != winY)
			;  || (prev_clientInfos.X != clientInfos.X) || (prev_clientInfos.Y != clientInfos.Y) || (prev_clientInfos.H != clientInfos.H) ) {
				; GUI_Trades_V2.UpdateSlotContent("Sell", tabNum, "IsBuyerInvited", True)
				GUI_ItemGrid.Create(tabXPos, tabYPos, tabStashItem, tabStashTab, winX, winY, clientInfos.H, clientInfos.X, clientInfos.Y, itemType, mapTier)
			; }
			; else
				; GUI_ItemGrid.Show()
		}
		else
			GUI_Trades_V2.DestroyItemGrid()

		prev_tabXPos := tabXPos, prev_tabYPos := tabYPos, prev_tabStashTab := tabStashTab
		prev_winX := winX, prev_winY := winY, prev_clientInfos := clientInfos
	}
	DestroyItemGrid() {
		GUI_ItemGrid.Destroy()
	}

    HotBarButton(_buyOrSell, btnType) {
		global PROGRAM, GAME
		
		if (btnType="Hideout") {
			keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")
			Send_GameMessage("WRITE_SEND", "/hideout", GAME.LastActivePID)
			SetKeyStateFunc(keysState)
		}
		else if (btnType="LeagueHelp") {
			try Menu, HelpMenu, DeleteAll
			Menu, HelpMenu, Add, Betrayal, GUI_Trades_V2_LeagueHelpMenu
			Menu, HelpMenu, Add, Delve, GUI_Trades_V2_LeagueHelpMenu
			Menu, HelpMenu, Add, Essence, GUI_Trades_V2_LeagueHelpMenu
			Menu, HelpMenu, Add, Harvest, GUI_Trades_V2_LeagueHelpMenu
			Menu, HelpMenu, Add, Incursion, GUI_Trades_V2_LeagueHelpMenu
			Menu, HelpMenu, Show
		}
		else if (btnType="QuickLinks") {
			try Menu, QuickLinksMenu, DeleteAll
			Menu, QuickLinksMenu, Add, poe.trade, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add, poeapp.com, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add, pathofexile.com, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add,
			Menu, QuickLinksMenu, Add, poemap.live, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add, poelab.com, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add, poe.ninja, GUI_Trades_V2_QuickLinksMenu
			Menu, QuickLinksMenu, Add,
			Menu, QuickLinksMenu, Add, Vorici Chromatic Calc, GUI_Trades_V2_QuickLinksMenu

			Menu, QuickLinksMenu, Show
		}
		else {
			ShowToolTip("This button isn't implemented yet.")
			SetTimer, RemoveToolTip, -2000
		}		
		return

		GUI_Trades_V2_QuickLinksMenu:
			link := A_ThisMenuItem="poe.trade"?"https://poe.trade"
				: A_ThisMenuItem="poeapp.com"?"https://www.poeapp.com"
				: A_ThisMenuItem="pathofexile.com"?"https://www.pathofexile.com/trade"
				: A_ThisMenuItem="poemap.live"?"https://poemap.live"
				: A_ThisMenuItem="poelab.com"?"https://www.poelab.com/nttsb"
				: A_ThisMenuItem="poe.ninja"?"https://poe.ninja/nttsb"
				: A_ThisMenuItem="Vorici Chromatic Calc"?"https://siveran.github.io/calc.html"
				: ""
			if (!link)
				return

			Run,% link
		return

		GUI_Trades_V2_LeagueHelpMenu:
			GUI_CheatSheet.Show(A_ThisMenuItem)
		return
	}

	Toggle_MinMax(_buyOrSell) {
		global GuiTrades

		if (GuiTrades[_buyOrSell].Is_Maximized)
			GUI_Trades_V2.Minimize(_buyOrSell)
		else 
			GUI_Trades_V2.Maximize(_buyOrSell)
	}

    Minimize(_buyOrSell) {
		global GuiTrades, GuiTrades_Controls
		global PROGRAM
		heightMin := GuiTrades[_buyOrSell].Height_Minimized, heightMax := GuiTrades[_buyOrSell].Height_Maximized, winDPI := GuiTrades[_buyOrSell].Windows_DPI

		if IsContaining(_buyOrSell, "Preview")
			return

		Detect_HiddenWindows("On")
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToTheBottom = "True") {
			gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
			WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , ,% gtPos.Y+gtPos.H-( (heightMin*winDPI) ), ,% (heightMin*winDPI)
			gtPosNow := GUI_Trades_V2.GetPosition(_buyOrSell)

			if (gtPos.y+gtPos.h != gtPosNow.y+gtPosNow.h)
				WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , ,% gtPosNow.y + ( (gtPos.y+gtPos.h) - (gtPosNow.y+gtPosNow.h) )
		}
		else
			WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , , , ,% heightMin*winDPI
		Detect_HiddenWindows()

		GuiControl, Trades%_buyOrSell%:Show,% GuiTrades_Controls[_buyOrSell].hBTN_Maximize
		GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades_Controls[_buyOrSell].hBTN_Minimize

		GuiControl, Trades%_buyOrSell%:Show,% GuiTrades_Controls[_buyOrSell].hPROGRESS_BorderBottom_Minimized
		; GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades_Controls[_buyOrSell].hPROGRESS_BorderBottom

		GuiTrades[_buyOrSell].Is_Maximized := False
		GuiTrades[_buyOrSell].Is_Minimized := True

		if (_buyOrSell="Sell")
        	GUI_Trades_V2.DestroyItemGrid()

		GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)
		; GUI_Trades_V2.ToggleTabSpecificAssets("Off")
		; TO_DO_V2 Possibly hide tabs to avoid overlap on border? Maybe specific tab name that, when active, hides everything - would also solve maximize after removetab issues where elements are still shown
	}

    Maximize(_buyOrSell) {
		global GuiTrades, GuiTrades_Controls
		global PROGRAM
		heightMin := GuiTrades[_buyOrSell].Height_Minimized, heightMax := GuiTrades[_buyOrSell].Height_Maximized, winDPI := GuiTrades[_buyOrSell].Windows_DPI

		if IsContaining(_buyOrSell, "Preview")
			return
		; if (!GuiTrades[buyOrSell].Tabs_Count)
			; return

        Detect_HiddenWindows("On")
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToTheBottom = "True") {
			gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
			WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , ,% gtPos.Y+gtPos.H-( (heightMax*winDPI) ), ,% (heightMax*winDPI)
			gtPosNow := GUI_Trades_V2.GetPosition(_buyOrSell)

			if (gtPos.y+gtPos.h != gtPosNow.y+gtPosNow.h)
				WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , ,% gtPosNow.y + ( (gtPos.y+gtPos.h) - (gtPosNow.y+gtPosNow.h) )
		}
		else {
			WinMove,% "ahk_id " GuiTrades[_buyOrSell].Handle, , , , ,% heightMax*winDPI
		}
		Detect_HiddenWindows()

		GuiControl, Trades%_buyOrSell%:Show,% GuiTrades_Controls[_buyOrSell].hBTN_Minimize
		GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades_Controls[_buyOrSell].hBTN_Maximize

		; GuiControl, Trades%_buyOrSell%:Show,% GuiTrades_Controls[_buyOrSell].hPROGRESS_BorderBottom
		GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades_Controls[_buyOrSell].hPROGRESS_BorderBottom_Minimized

		GuiTrades[_buyOrSell].Is_Maximized := True
		GuiTrades[_buyOrSell].Is_Minimized := False

		if (_buyOrSell="Sell")
			GUI_Trades_V2.ShowItemGrid(GuiTrades.Sell.Active_Tab)
		GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)
		; GUI_Trades_V2.ToggleTabSpecificAssets("On")
	}

    SetFakeSearch(_buyOrSell, makeEmpty=False) {
		global SKIN, GuiTrades, GuiTrades_Controls

		GuiControlGet, search, Trades%_buyOrSell%SearchHidden:,% GuiTrades_Controls[_buyOrSell].hEDIT_HiddenSearchBar
		if (search!="") {
			GuiControl,% "Trades" _buyOrSell ": +c" SKIN.Settings.COLORS.SearchBar_NotEmpty,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake
			GuiControl, Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake,% search
		}
		else {
			GuiControl,% "Trades" _buyOrSell ": +c" SKIN.Settings.COLORS.SearchBar_Empty,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake
			GuiControl, Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake,% "..."
		}

		if (makeEmpty=True) {
			GuiControl,% "Trades" _buyOrSell ": +c" SKIN.Settings.COLORS.SearchBar_Empty,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake
			GuiControl, Trades%_buyOrSell%SearchHidden:,% GuiTrades_Controls[_buyOrSell].hEDIT_HiddenSearchBar,% ""
			GuiControl, Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell].hTEXT_SearchBarFake,% "..."
		}

		if (_buyOrSell="Buy")
			SetTimer, GUI_Trades_V2_Search_Buy, -500
		else if (_buyOrSell="Sell")
			SetTimer, GUI_Trades_V2_Search_Sell, -500
	}

	Search(_buyOrSell) {
		/*	Starting a search will look through tabs to find match
			Any matching tab will be added to the list
			Once done, replace all tabs with matches

			TO_DO solution when sending whisper with search box still with text
		*/
		global GuiTrades, GuiTrades_Controls

		GuiControlGet, search, ,% GuiTrades_Controls[_buyOrSell].hEDIT_HiddenSearchBar
		
		matches := 0
		if (search != "") {
			contents := {}
			Loop % GuiTrades[_buyOrSell].Tabs_Count {
				content := GuiTrades[_buyOrSell]["Tab" A_Index "Content"]
				if IsContaining(content.Seller, search) || IsContaining(content.Buyer, search) || IsContaining(content.Item, search)
					contents[matches+1] := content, matches++
			}
			if (matches) {
				ShowToolTip("""" search """`n" matches " matches found")
				SetTimer, RemoveToolTip, -2000
				Loop % GuiTrades[_buyOrSell].Tabs_Count
					GUI_Trades_V2.SetSlotContent(_buyOrSell, A_Index, "")
				
                
                Loop % matches
					GUI_Trades_V2.SetSlotContent(_buyOrSell, A_Index, contents[A_Index])
			}
			else {
				ShowToolTip("""" search """`nNo matches found")
				SetTimer, RemoveToolTip, -2000
			}
		}
		else {
			Loop % GuiTrades[_buyOrSell].Tabs_Count {
				GUI_Trades_V2.SetSlotContent(_buyOrSell, A_Index, GuiTrades[_buyOrSell]["Tab" A_Index "Content"])
			}
		}
		GUI_Trades_V2.Redraw(_buyOrSell)
	}

    IsTabAlreadyExisting(_buyOrSell, contentInfos) {
		global GuiTrades, GuiTrades_Controls

		Loop % GuiTrades[_buyOrSell].Tabs_Count {
			loopedcontentInfos := GUI_Trades_V2.GetTabContent(_buyOrSell, A_Index)
			if ( (contentInfos.Seller = loopedcontentInfos.Seller && _buyOrSell="Buy") || (contentInfos.Buyer = loopedcontentInfos.Buyer && _buyOrSell="Sell") )
			&& (contentInfos.Item = loopedcontentInfos.Item)
			&& (contentInfos.PriceCurrency = loopedcontentInfos.PriceCurrency)
			&& (contentInfos.PriceCount = loopedcontentInfos.PriceCount)
			&& (contentInfos.League = loopedcontentInfos.League)
			&& (contentInfos.StashTab = loopedcontentInfos.StashTab)
			&& (contentInfos.StashX = loopedcontentInfos.StashX)
			&& (contentInfos.StashY = loopedcontentInfos.StashY)
				Return A_Index
		}
	}

    ResetPosition(_buyOrSell, dontWrite=False) {
		global PROGRAM, GuiTrades
		windowsDPI := GuiTrades[_buyOrSell].Windows_DPI
		scaleMult := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS.ScalingPercentage / 100

		if (GuiTrades[_buyOrSell].Is_Minimized)
			GUI_Trades_V2.Maximize(_buyOrSell)

		/*
		gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
		try {
			Gui.Show("Trades" _buyOrSell, "x" Ceil(A_ScreenWidth-gtPos.W) " y0 NoActivate")
		}
		catch e {
			AppendToLogs(A_ThisFunc "(dontWrite=" dontWrite "): Failed to set GUI pos based on screen width. Setting to 0,0.")
			Gui.Show("Trades" _buyOrSell, "x0 y0 NoActivate")
		}
		*/
		defaultSettings := Get_LocalSettings_DefaultValues()
		Gui.Show("Trades" _buyOrSell, "x" defaultSettings[_buyOrSell "_INTERFACE"].Pos_X*windowsDPI*scaleMult " y" defaultSettings[_buyOrSell "_INTERFACE"].Pos_Y*windowsDPI*scaleMult " NoActivate")
		if (dontWrite=False)
			GUI_Trades_V2.SavePosition(_buyOrSell)
	}

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
     *
     * SHOULD BE OK FOR V2
     *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    */

	ScrollUp(_buyOrSell) {
		; Tabs: Re-arrange the tabs buttons to simulate scrolling left
		; Stack: Re-arrange the slots to simulate scrolling up
		global GuiTrades, GuiTrades_Controls
		tabsRange := GUI_Trades_V2.GetTabsRange(_buyOrSell)
		isStack := GuiTrades[_buyOrSell].Is_Stack
		isTabs := GuiTrades[_buyOrSell].Is_Tabs

		if !(tabsRange.1 > 1) ; We can't scroll further
			return

		if (isTabs) {
			newFistTab := tabsRange.1-1, tabMoving := newFistTab
			While (tabMoving != tabsRange.2) {
				tabX := GuiTrades[_buyOrSell]["TabButton" A_Index "_X"] ; Get tab slot X pos
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabDefault" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabJoinedArea" tabMoving],% "x" tabX
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabWhisperReceived" tabMoving],% "x" tabX

				tabMoving++ ; Move onto the next tab to move
			}
			GuiControl, Trades%_buyOrSell%:Show,% GuiTrades[_buyOrSell]["Tab_" newFistTab] ; Show new tab on left most
			GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades[_buyOrSell]["Tab_" tabsRange.2] ; Hide previous tab on right most
		}
        else if (isStack) {
			slotNum := tabsRange.1
			GUI_Trades_V2.SetSlotPosition(_buyOrSell, slotNum-1, 1) ; Show new first slot
			Loop 4 { ; Handle the other slots
				GUI_Trades_V2.SetSlotPosition(_buyOrSell, slotNum, A_Index+1)
				slotNum++
			}	
        }
	}

	ScrollDown(_buyOrSell) {
		; Tabs: Re-arrange the tabs buttons to simulate scrolling right
		; Stack: Re-arrange the slots to simulate scrolling down
		global GuiTrades, GuiTrades_Controls
		tabsRange := GUI_Trades_V2.GetTabsRange(_buyOrSell)
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		isStack := GuiTrades[_buyOrSell].Is_Stack
		isTabs := GuiTrades[_buyOrSell].Is_Tabs

		if !(tabsCount > tabsRange.2) ; We can't scroll further
			return

		if (isTabs) {
			newFistTab := tabsRange.1+1, newLastTab := tabsRange.2+1, tabMoving := newFistTab
			While (tabMoving != newLastTab) {
				tabX := GuiTrades[_buyOrSell]["TabButton" A_Index "_X"] ; Get tab slot X pos
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabDefault" tabMoving],% "x" tabX ; Move tab to said pos
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabJoinedArea" tabMoving],% "x" tabX
				GuiControl, Trades%_buyOrSell%:Move,% GuiTrades_Controls[_buyOrSell]["hBTN_TabWhisperReceived" tabMoving],% "x" tabX

				tabMoving++ ; Move onto the next tab to move
			}

			GuiControl, Trades%_buyOrSell%:Show,% GuiTrades[_buyOrSell]["Tab_" newLastTab] ; Show new tab on right most
			GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades[_buyOrSell]["Tab_" tabsRange.1] ; Hide previous tab on left most
		}
        else if (isStack) {
			slotNum := tabsRange.1
			Loop 4 { ; Handle the other slots
				GUI_Trades_V2.SetSlotPosition(_buyOrSell, slotNum, A_Index-1)
				slotNum++
			}
			GUI_Trades_V2.SetSlotPosition(_buyOrSell, slotNum, 4) ; Show new last slot
		}
	}

	CloseTab(params*) {
		GUI_Trades_V2.RemoveTab(params*)
	}

	RemoveTab(_buyOrSell, tabNum, massRemove=False) {
		global PROGRAM, SKIN
		global GuiTrades, GuiTrades_Controls
		windowsDPI := GuiTrades[_buyOrSell].Windows_DPI
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		tabsRange := GUI_Trades_V2.GetTabsRange(_buyOrSell)
		isStack := GuiTrades[_buyOrSell].Is_Stack
		isTabs := GuiTrades[_buyOrSell].Is_Tabs
		activeTab := GuiTrades[_buyOrSell].Active_Tab

		if IsContaining(_buyOrSell, "Preview")
			return
		if (!tabsCount)
			return

		tabNum := isTabs && !tabNum ? activeTab : tabNum
		; Removing tab and adjusting others if needed
		if (tabNum < tabsCount) {
			tabIndex := tabNum+1
			Loop % tabsCount-tabNum {
				tabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, tabIndex)
				GuiTrades[_buyOrSell]["Tab" tabIndex-1 "Content"] := ObjFullyClone(tabContent) ; Used for search feature
				GUI_Trades_V2.SetSlotContent(_buyOrSell, tabIndex-1, tabContent) ; Set tab content to previous tab
				tabIndex++
			}
			GUI_Trades_V2.SetSlotContent(_buyOrSell, tabIndex-1, "") ; Make last tab empty
			GuiTrades[_buyOrSell]["Tab" tabIndex-1 "Content"] := {}
			GUI_Trades_V2.SetTabStyleDefault(tabIndex-1)
		}
		else if (tabNum = tabsCount) {
			GUI_Trades_V2.SetSlotContent(_buyOrSell, tabNum, "")
			GuiTrades[_buyOrSell]["Tab" tabNum "Content"] := {}
		}
		
		; Scroll up if needed
		if (tabsRange.2 = tabsCount)
			GUI_Trades_V2.ScrollUp(_buyOrSell)
		; Change active tab if needed
		if (activeTab = tabsCount) && (tabsCount != 1)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, tabsCount-1, False) ; autoScroll=False
		; Hide tab assets is required
		else if (tabsCount = 1) {
			; GUI_Trades_V2.ToggleTabSpecificAssets("OFF") ; TO_DO_V2
			; GUI_Trades_V2.SetActiveTab("No Trades On Queue")
		}
		else if (tabsCount > tabNum) && (massRemove=False) ; Re-activate same
			GUI_Trades_V2.SetActiveTab(_buyOrSell, tabNum)

		; Hide last tab
		if (isTabs)
			GuiControl, Trades%_buyOrSell%:Hide,% GuiTrades[_buyOrSell]["Tab_" tabsCount]
		; Updating tab count var
		GuiTrades[_buyOrSell].Tabs_Count := GuiTrades[_buyOrSell].Tabs_Count <= 0 ? 0 : GuiTrades[_buyOrSell].Tabs_Count-1
		; Updating height var if is stack
		if (isStack) {
			gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
			GuiTrades[_buyOrSell].Height_Maximized := GuiTrades[_buyOrSell].Tabs_Count = 0 ? GuiTrades[_buyOrSell].Height_Minimized
				: GuiTrades[_buyOrSell].Tabs_Count = 1 ? GuiTrades[_buyOrSell].Height_Maximized_OneSlot
				: GuiTrades[_buyOrSell].Tabs_Count = 2 ? GuiTrades[_buyOrSell].Height_Maximized_TwoSlot
				: GuiTrades[_buyOrSell].Tabs_Count = 3 ? GuiTrades[_buyOrSell].Height_Maximized_ThreeSlot
				: GuiTrades[_buyOrSell].Tabs_Count >= 4 ? GuiTrades[_buyOrSell].Height_Maximized_FourSlot
				: GuiTrades[_buyOrSell].Height_Maximized_FourSlot
			sizeDiff := (GuiTrades[_buyOrSell].Height_Maximized*windowsDPI)-gtPos.H
		}
		; Do stuff if tabs count is zero
		if (GuiTrades[_buyOrSell].Tabs_Count = 0) {
			GuiControl,Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell]["hTEXT_Title"],% PROGRAM.NAME
			GuiControl,% "Trades" _buyOrSell ": +c" SKIN.Settings.COLORS.Title_No_Trades,% GuiTrades_Controls[_buyOrSell]["hTEXT_Title"]
			; GuiControl,TradesMinimized:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(0)"
			; GuiControl,% "TradesMinimized: +c" SKIN.Settings.COLORS.Title_No_Trades,% GuiTradesMinimized_Controls["hTEXT_Title"]
			/* Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				GUI_Trades_V2.Enable_ClickThrough(_buyOrSell)
			*/
			/* Disabled - Search ID jsZTTcBTWV in POE Trades Companion.ahk for infos
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AutoMinimizeOnAllTabsClosed = "True")
				GUI_Trades_V2.Minimize(_buyOrSell)
			*/
			GUI_Trades_V2.SetTransparency_Inactive(_buyOrSell)
			GUI_Trades_V2.Redraw(_buyOrSell)
			GUI_Trades_V2.Minimize(_buyOrSell)
			if (_buyOrSell="Sell")
				GUI_Trades_V2.DestroyItemGrid()
		}
		; Do stuff if tabs count is not zero
		else {
			GuiControl,Trades%_buyOrSell%:,% GuiTrades_Controls[_buyOrSell]["hTEXT_Title"],% PROGRAM.NAME " (" GuiTrades[_buyOrSell].Tabs_Count ")"
			if (isStack) {
				if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToTheBottom = "True") {
					guiY := "y" gtPos.Y-sizeDiff
				}
				Gui.Show("Trades" _buyOrSell, guiY " h" GuiTrades[_buyOrSell].Height_Maximized " NoActivate")
			}
			; GuiControl,TradesBuyCompact:,% GuiTradesMinimized_Controls["hTEXT_Title"],% "(" GuiTrades.Tabs_Count ")"
		}
		GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)
	}

	SetActiveTab(_buyOrSell, tabName, autoScroll=True) {
		global PROGRAM, GuiTrades, GuiTrades_Controls
        prevActiveTab   := GuiTrades[_buyOrSell].Active_Tab
		tabsCount       := GuiTrades[_buyOrSell].Tabs_Count
        tabsLimit       := GuiTrades[_buyOrSell].Tabs_Limit
        tabsRange        := GUI_Trades_V2.GetTabsRange(_buyOrSell)

        ; Invalid tab name
		if IsNum(tabName) && !IsBetween(tabName, 1, tabsCount) {
			AppendToLogs("Cannot select tab """ tabName """ because it exceed the tabs count (" tabsCount "). Selecting tab """ tabsCount """ instead.")
			tabName := tabsCount
		}

        ; Need to scroll to make tab visible
		if ( autoScroll && IsNum(tabName) && !IsBetween(tabName, tabsRange.1, tabsRange.2) ) {
			if (tabName < tabsRange.1) {
				diff := tabsRange.1-tabName
				Loop % diff
					GUI_Trades_V2.ScrollLeft(_buyOrSell)
			}
			else if (tabName > tabsRange.2) {
				diff := tabName-tabsRange.2
				Loop % diff
					GUI_Trades_V2.ScrollRight(_buyOrSell)
			}
		}

        ; Setting "Active" tab style, and removing it from any other tab
        ; + Make sure that the slot is on the first position, show it, and hide any other slot
		Loop % tabsLimit {
            slotGuiName := "Trades" _buyOrSell "_Slot" A_Index
			if (A_Index = tabName) {
				GuiControl, Trades%_buyOrSell%:+Disabled,% GuiTrades[_buyOrSell]["Tab_" A_Index]
                GUI_Trades_V2.SetSlotPosition(_buyOrSell, tabName, 1)
                Gui.Show(slotGuiName, "x0 y" GuiTrades[_buyOrSell]["Slot1_Pos"]  " NoActivate")
            }
			else {
				GuiControl, Trades%_buyOrSell%:-Disabled,% GuiTrades[_buyOrSell]["Tab_" A_Index]
                Gui, %slotGuiName%:Hide
            }
		}
        GuiTrades[_buyOrSell].Active_Tab := tabName

        ; Showing item grid as long as interface is maximized
		if (_buyOrSell="Sell" && GuiTrades.Sell.Is_Maximized = True)
			GUI_Trades_V2.ShowItemGrid(tabName)

		; Don't do these if only the tab style changed.
		; Avoid an issue where upon removing a tab, it would copy the item infos again due to the tab style func re-activating the tab
		if (styleChanged=False) {
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.CopyItemInfosOnTabChange = "True" && IsNum(tabName)) {
				GoSub, GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab_Timer
			}
		}
	}

    RecreateGUI(_buyOrSell, tabsLimit="") {
		global PROGRAM, GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		maxTabsPerRow := GuiTrades[_buyOrSell].Max_Tabs_Per_Row
		tabsRange := GUI_Trades_V2.GetTabsRange(_buyOrSell)
        tabsOrStack := GuiTrades[_buyOrSell].Is_Stack ? "Stack" : "Tabs"

		if (tabsLimit = "")
			tabsLimit := GuiTrades[_buyOrSell].Tabs_Limit

		firstRangeTab := tabsRange.1
		Loop % tabsCount { ; Get all tabs content
			tabInfos%A_Index% := GUI_Trades_V2.GetTabContent(_buyOrSell, A_Index)
		}
		
		if (tabsLimit)
			GUI_Trades_V2.Create(tabsLimit, _buyOrSell, tabsOrStack) ; Recreate GUI with more tabs
		else
			GUI_Trades_V2.Create("", _buyOrSell, tabsOrStack) ; No limit specific, just use default limit
		Loop % tabsCount { ; Set tabs content
			GUI_Trades_V2.PushNewTab(_buyOrSell, tabInfos%A_Index%)
		}

		Loop % tabsRange.2-maxTabsPerRow
			GUI_Trades_V2.ScrollDown(_buyOrSell)

		if (tabsCount) {
			GUI_Trades_V2.SetTransparency_Active(_buyOrSell)
			GUI_Trades_V2.Disable_ClickThrough(_buyOrSell)
		}
		else  {
			GUI_Trades_V2.SetTransparency_Inactive(_buyOrSell)
			/* Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
			if (PROGRAM.SETTINGS.SETTINGS_MAIN.AllowClicksToPassThroughWhileInactive = "True")
				GUI_Trades_V2.Enable_ClickThrough(_buyOrSell)
			*/
		}
	}

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
     *
     * FINISHED FOR V2
     *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    */

	GetTabNumberFromUniqueID(_buyOrSell, uniqueID) {
		global GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count

		Loop % tabsCount {
			tabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, A_Index)
			if (tabContent.UniqueID = uniqueID) {
				return A_Index
			}
		}

		AppendToLogs(A_ThisFunc "(uniqueId=" uniqueId "): Couldn't find any tab ID matching this unique ID")
		return
	}

	GetActiveTab(_buyOrSell) {
		global GuiTrades
		return GuiTrades[_buyOrSell].Active_Tab
	}

	SelectNextTab(_buyOrSell) {
		global GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		activeTab := GuiTrades[_buyOrSell].Active_Tab

		if (!GuiTrades[_buyOrSell].Is_Tabs)
			return
		if !IsNum(activeTab)
			Return

		if (tabsCount > activeTab)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, activeTab+1)
		else ; if (tabsCount = activeTab)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, 1)
	}

	SelectPreviousTab(_buyOrSell) {
		global GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		activeTab := GuiTrades[_buyOrSell].Active_Tab

		if (!GuiTrades[_buyOrSell].Is_Tabs)
			return
		if !IsNum(activeTab)
			Return

		if (activeTab > 1)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, activeTab-1)
		else ; if (activeTab = 1)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, tabsCount)
	}

	EnableHotkeys(_buyOrSell) {
		global GuiTrades, PROGRAM
		
		for hk, value in PROGRAM.HOTKEYS {
			noModsHKArr := RemoveModifiersFromHotkeyStr(hk, returnMods:=True), noModsHK := noModsHKArr.1, onlyModsHK := noModsHKArr.2
			hkKeyName := GetKeyName(noModsKey)
			
			if (keyName = "Tab") && IsContaining(onlyModsHK, "^") && !IsContaining(onlyModsHK, "+,#,!")
				hasCtrlTabHK := True
			if (keyName = "Tab") && IsContaining(onlyModsHK, "^") && IsContaining(onlyModsHK, "+") && !IsContaining(onlyModsHK, "#,!")
				hasCTrlShiftTabHK := True
			/* Disabled in favour of WM_MOUSEWHEEL
			; if (keyName = "WheelDown") && IsContaining(onlyModsHK, "^") && !IsContaining(onlyModsHK, "+,#,!")
			; 	hasCtrlWheelDownHK := True
			; if (keyName = "WheelUp") && IsContaining(onlyModsHK, "^") && !IsContaining(onlyModsHK, "+,#,!")
			; 	hasCtrlWheelUpHK := True
			*/
		}

		GuiTrades[_buyOrSell].HOTKEYS := {}
		if (!hasCtrlTabHK)
			GuiTrades[_buyOrSell].HOTKEYS.Push("^SC00F")
		if (!hasCTrlShiftTabHK)
			GuiTrades[_buyOrSell].HOTKEYS.Push("^+SC00F")
		/* Disabled in favour of WM_MOUSEWHEEL
		if (!hasCtrlWheelDownHK)
			GuiTrades[_buyOrSell].HOTKEYS.Push("^WheelDown")
		if (!hasCtrlWheelUpHK)
			GuiTrades[_buyOrSell].HOTKEYS.Push("^WheelUp")
		*/
		
		Loop % GuiTrades[_buyOrSell].HOTKEYS.MaxIndex() {
			Hotkey, IfWinActive
			Hotkey,% "~" GuiTrades[_buyOrSell].HOTKEYS[A_Index], GUI_Trades_V2_SelectTab_Hotkey, On
		} 
	}

	DisableHotkeys(_buyOrSell) {
		global GuiTrades
		if !(GuiTrades[_buyOrSell].Handle)
			return

		try {
			Loop % GuiTrades[_buyOrSell].HOTKEYS.MaxIndex() { 
				Hotkey, IfWinActive
				Hotkey,% "~" GuiTrades[_buyOrSell].HOTKEYS[A_Index], Off
			}
		}
	}

	IsTrade_In_IgnoreList(tradeInfos) {
		global TRADES_IGNORE_LIST
		
		Loop % TRADES_IGNORE_LIST.Count() {
			loopIndex := A_Index

			if (TRADES_IGNORE_LIST[loopIndex].Item = tradeInfos.Item)
			 && (TRADES_IGNORE_LIST[loopIndex].ItemCurrency = tradeInfos.ItemCurrency)
			 && (TRADES_IGNORE_LIST[loopIndex].ItemCount = tradeInfos.ItemCount)
			 && (TRADES_IGNORE_LIST[loopIndex].PriceCurrency = tradeInfos.PriceCurrency)
			 && (TRADES_IGNORE_LIST[loopIndex].PriceCount = tradeInfos.PriceCount)
			 && (TRADES_IGNORE_LIST[loopIndex].StashTab = tradeInfos.StashTab)
			 && (TRADES_IGNORE_LIST[loopIndex].StashX = tradeInfos.StashX)
			 && (TRADES_IGNORE_LIST[loopIndex].StashY = tradeInfos.StashY)
			 && (TRADES_IGNORE_LIST[loopIndex].GemLevel = tradeInfos.GemLevel)
			 && (TRADES_IGNORE_LIST[loopIndex].GemQuality = tradeInfos.GemQuality) {
			 	return loopIndex
			}
		}
		
		return False
	}

	AddTrade_To_IgnoreList(tabNum, duration=10) {
		global GuiTrades, TRADES_IGNORE_LIST
		duration := IsNum(duration)?duration:10
		matchingElements := ["Item","ItemCurrency","ItemCount","PriceCurrency","PriceCount","StashTab","StashX","StashY","GemLevel","GemQuality"]
		if !IsObject(TRADES_IGNORE_LIST)
			TRADES_IGNORE_LIST := {}
		
		if !IsNum(tabNum || tabNum=0)
			return

		tabContent := GUI_Trades_V2.GetTabContent("Sell", tabNum)
		inIgnoreIndex := GUI_Trades_V2.IsTrade_In_IgnoreList(tabContent)
		if (inIgnoreIndex) {
			TRADES_IGNORE_LIST[inIgnoreIndex].IgnoreDuration := duration
			; AppendToLogs(A_ThisFunc "(): Tab is already in ignore list. Canceling."
			; . "`nBuyer: """ tabContent.Buyer """ - Item: """ tabContent.Item """ - Price: """ tabContent.Price """ - Stash: """ tabContent.Stash """")
			return
		}
		if !(tabContent.Item) {
			return
		}

		ignoreCount := TRADES_IGNORE_LIST.Count() ? TRADES_IGNORE_LIST.Count() : 0
		TRADES_IGNORE_LIST[ignoreCount+1] := {}
		Loop % matchingElements.Count()
			TRADES_IGNORE_LIST[ignoreCount+1][matchingElements[A_Index]] := tabContent[matchingElements[A_Index]]
		TRADES_IGNORE_LIST[ignoreCount+1].Time := A_Now
		TRADES_IGNORE_LIST[ignoreCount+1].IgnoreDuration := duration

		AppendToLogs(A_ThisFunc "(): Successfully added tab to ignore list for " duration "mins: "
		. "`nBuyer: """ tabContent.Buyer """ - Item: """ tabContent.Item """ - Price: """ tabContent.Price """ - Stash: """ tabContent.Stash """")
	}
	
	RefreshIgnoreList() {
		global TRADES_IGNORE_LIST
		
		if !TRADES_IGNORE_LIST.Count()
			return

		Loop % TRADES_IGNORE_LIST.Count() {
			loopIndex := A_Index
			timeAdded := TRADES_IGNORE_LIST[loopIndex].Time, timeDif := A_Now
			timeDif -= timeAdded, Seconds
			ignoreDuration := TRADES_IGNORE_LIST[loopIndex].IgnoreDuration*60 ; convert mins into seconds

			if (timeDif > ignoreDuration) {
				replaceIndex := loopIndex

				Loop % TRADES_IGNORE_LIST.Count() - loopIndex {
					TRADES_IGNORE_LIST[replaceIndex] := {}
					TRADES_IGNORE_LIST[replaceIndex] := ObjFullyClone(TRADES_IGNORE_LIST[replaceIndex+1])
					replaceIndex++
				}
				TRADES_IGNORE_LIST.Delete(TRADES_IGNORE_LIST.Count())
				GUI_Trades_V2.RefreshIgnoreList()
				return
				; AppendToLogs(A_ThisFunc "(): Removed item from ignore list after " ignoreDuration "mins.")
			}
		}			
	}

	CopyItemInfos(_buyOrSell, tabID="") {
		global GuiTrades
		tabID := tabID="" ? GuiTrades[_buyOrSell].Active_Tab : tabID

		tabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, tabID)
		item := tabContent.Item, whisLang := tabContent.WhisperLanguage
		if RegExMatch(item, "O)(.*?) \(Lvl:(.*?) \/ Qual:(.*?)%\)", itemPat) {
			gemName := itemPat.1, gemLevel := itemPat.2, gemQual := itemPat.3
		}
		else if RegExMatch(item, "O)(.*?) \(T(.*?)\)", itemPat)
		|| RegExMatch(item, "O)(.*?) \(階級(.*?)\)", itemPat) {
			mapName := itemPat.1, mapTier := itemPat.2
		}

		if (gemName) {
			Gui_Trades_V2_CopyItemInfos_GemString:
			searchLvlPrefix := whisLang = "ENG" ? "l" ; level
				: whisLang = "RUS" ? "ь" ; Уровень
				: whisLang = "FRE" ? "u" ; Niveau
				: whisLang = "POR" ? "l" ; Nível
				: whisLang = "THA" ? "ล" ; เลเวล
				: whisLang = "GER" ? "e" ; Stufe
				: whisLang = "SPA" ? "l" ; Nivel
				: whisLang = "KOR" ? "벨" ; 레벨
				: whisLang = "TWN" ? "級" ; 等級
				: "l"
			searchQualPrefix := whisLang = "ENG" ? "y" ; quality
				: whisLang = "RUS" ? "о" ; Качество
				: whisLang = "FRE" ? "é" ; Qualité
				: whisLang = "POR" ? "e" ; Qualidade
				: whisLang = "THA" ? "พ" ; คุณภาพ
				: whisLang = "GER" ? "t" ; Qualität
				: whisLang = "SPA" ? "d" ; Calidad
				: whisLang = "KOR" ? "티" ; 퀄리티
				: whisLang = "TWN" ? "質" ; 品質
				: "y"

			searchGemStr := """" gemName """"
			searchLvlStr := """" searchLvlPrefix ": " gemLevel """"
			searchQualStr := """" searchQualPrefix ": +" gemQual "%"""
			searchString := searchGemStr
			searchString .= (gemLevel && !gemQual)?(" " searchLvlStr):(gemLevel && gemQual)?(" " searchLvlStr " " searchQualStr):("")

			searchStrLen := StrLen(searchString)
			if (searchStrLen > 50) {
				charsToRemove := searchStrLen-50
				StringTrimRight, gemName, gemName, %charsToRemove%
				GoTo Gui_Trades_V2_CopyItemInfos_GemString
			}
		}
		else if (mapName) {
			Gui_Trades_V2_CopyItemInfos_MapString:
			if RegExMatch(mapName, "O)^\d+ (.*)", mapNameOut)
				mapName := mapNameOut.1
			/*	Disabled tier:x doesn't work on map tab map section
			searchMapStr := mapName, searchTierStr := "tier:" mapTier
			searchString := searchMapStr
			searchString .= (mapTier)?(" " searchTierStr):("")
			*/
			searchString := mapName

			searchStrLen := StrLen(searchString)
			if (searchStrLen > 50) {
				charsToRemove := searchStrLen-50
				StringTrimRight, mapName, mapName, %charsToRemove%
				GoTo, Gui_Trades_V2_CopyItemInfos_MapString
			}
		}
		else { ; Remove numbers from str, so we only keep item name
			searchString := RegExReplace(item, "\d")
			AutoTrimStr(searchString)
		}

		clipContent := (searchString)?(searchString):(item)
		if (clipContent) {
			Set_Clipboard(clipContent)
		}
	}

	SaveBackup(_buyOrSell) {
	/*		Save all pending trades in a file.
	 */
	 	global PROGRAM, GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		backupFile := PROGRAM["TRADES_" _buyOrSell "_BACKUP_FILE"]

		if (!tabsCount)
			Return

		FileDelete,% backupFile
		tabInfos := {}
		Loop % tabsCount { ; Get all tabs content
			tabInfos[A_Index] := GUI_Trades_V2.GetTabContent(_buyOrSell, A_Index)
		}
		
		jsonText := JSON.Dump(tabInfos, "", "`t")
		hFile := FileOpen(backupFile, "w", "UTF-8")
		hFile.Write(jsonText)
		hFile.Close()
	}

	LoadBackup(_buyOrSell) {
	/*		Read the backup file, and send those trades requests to the Trades GUI
	 */
		global PROGRAM, GuiTrades
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count
		backupFile := PROGRAM["TRADES_" _buyOrSell "_BACKUP_FILE"]

		if !FileExist(backupFile)
			Return
		if !Is_JSON(backupFile) {
			FileDelete,% backupFile
			return
		}

		tabInfos := JSON_Load(backupFile)
		Loop % tabInfos.Count() {
			GUI_Trades_V2.PushNewTab(_buyOrSell, tabInfos[A_Index])
		}
		
		FileDelete,% backupFile
	}

	RemoveButtonFocus(_buyOrSell) {
		global GuiTrades
		ControlFocus,,% "ahk_id " GuiTrades[_buyOrSell].Handle ; Remove focus
		Loop % GuiTrades[_buyOrSell].Tabs_Count
			ControlFocus,,% "ahk_id " GuiTrades[_buyOrSell]["Slot" A_Index].Handle
	}

	ScrollLeft(params*) {
        return GUI_Trades_V2.ScrollUp(params*)
    }
    ScrollRight(params*) {
        return GUI_Trades_V2.ScrollDown(params*)
    }

	GetTabsRange(_buyOrSell) {
		; Gets the first and last visible tabs, based on control visibility
		global GuiTrades

		Loop % GuiTrades[_buyOrSell].Tabs_Count {
			if (GuiTrades[_buyOrSell].Is_Stack) {
				guiName := "Trades" _buyOrSell "_Slot" A_Index
				GuiControlGet, isVisible, %guiName%:Visible,% GuiTrades[_buyOrSell]["Slot" A_Index "_Controls"].hTEXT_TimeSent
			}
			else if (GuiTrades[_buyOrSell].Is_Tabs) {
				GuiControlGet, isVisible, Trades%_buyOrSell%:Visible,% GuiTrades[_buyOrSell]["Tab_" A_Index]
			}

			if (firstVisibleTab = "" && isVisible)
				firstVisibleTab := A_Index
			if (isVisible)
				lastVisibleTab := A_Index

			if (firstVisibleTab && lastVisibleTab && !isVisible)
				Break
		}
		Return [firstVisibleTab, lastVisibleTab]
	}

	GetTabContent(_buyOrSell, tabName) {
		; Parse the hidden infos wall to return an obj with the whole tab content
		global GuiTrades

		GuiControlGet, hiddenInfosWall, ,% GuiTrades[_buyOrSell]["Slot" tabName "_Controls"]["hTEXT_HiddenInfos"]

		tabInfos := {}
		Loop, Parse, hiddenInfosWall, `n, `r
		{
			if RegExMatch(A_LoopField, "O)(.*?):(.*)", matchPat) {
				matchKey := matchPat.1, matchValue := matchPat.2
				AutoTrimStr(matchKey, matchValue)
				tabInfos[matchKey] := matchValue
			}
		}

		return tabInfos
    }

	GetSlotContent(params*) {
       return GUI_Trades_V2.GetTabContent(params*)
	}

	SetSlotPosition(_buyOrSell, slotNum, slotPos) {
        ; Only used with the Stack gui mode
		; Set the position of the Slot gui
		; If position is higher than the allocated slot count, it will be hidden
		global GuiTrades

		guiName := "Trades" _buyOrSell "_Slot" slotNum
        guiSlot := GuiTrades[_buyOrSell]["Slot" slotPos "_Pos"] 
		if (guiSlot)
			Gui.Show(guiName, "x0 y" guiSlot " NoActivate")
		else Gui, %guiName%:Hide
	}

	CloseOtherTabsForSameItem(_buyOrSell, tabNum) {
		global GuiTrades
		isStack := GuiTrades[_buyOrSell].Is_Stack
		isTabs := GuiTrades[_buyOrSell].Is_Tabs
		tabsCount := GuiTrades[_buyOrSell].Tabs_Count

		
		activeTab := GuiTrades[_buyOrSell].Active_Tab
		activeTabInfos := GUI_Trades_V2.GetTabContent(_buyOrSell, activeTab)
		tabsToLoop := tabsCount, tabsToGoBack := 0

		; Parse every tab, from highest to lowest so when we close it, it doesn't affect tab order
		Loop % tabsCount {
			loopedTab := tabsToLoop
			if (loopedTab != activeTab) {
				tabInfos := GUI_Trades_V2.GetTabContent(_buyOrSell, loopedTab)
				if (_buyOrSell = "Buy")
					isSameItem := tabInfos.Item = activeTabInfos.Item ? True : False
				else if (_buyOrSell = "Sell") {
					isSameItem := (tabInfos.Item = activeTabInfos.Item)
					&& (tabInfos.PriceCurrency = activeTabInfos.PriceCurrency)
					&& (tabInfos.PriceCount = activeTabInfos.PriceCount)
					&& (tabInfos.League = activeTabInfos.League)
					&& (tabInfos.StashTab = activeTabInfos.StashTab)
					&& (tabInfos.StashX = activeTabInfos.StashX)
					&& (tabInfos.StashY = activeTabInfos.StashY) ? True : False
				}
				if (isSameItem) {
					if (loopedTab > activeTab)
						tabsToGoBack++
					GUI_Trades_V2.RemoveTab(_buyOrSell, loopedTab, massRemove:=True)
					AppendToLogs(A_ThisLabel ": Removed tab " loopedTab)
				}
			}
			tabsToLoop--
		}
		if (isTabs)
			GUI_Trades_V2.SetActiveTab(_buyOrSell, activeTab-tabsToGoBack)
	}

	IncreaseTabsLimit(_buyOrSell) {
		global GuiTrades
		static prevLimit
		tabsLimit := GuiTrades[_buyOrSell].Tabs_Limit

		limits := [50,100,251]
		nextLimit := !tabsLimit || tabsLimit="" ? limits.1
			: IsBetween(tabsLimit, 0, limits.1) ? limits.2
			: IsBetween(tabsLimit, limits.1, limits.1) ? limits.3
			: limits.3

		prevLimit := nextLimit
           
		if (nextLimit = limits.3) && (prevLimit != limits.3) {
			TrayNotifications.Show("Maximal tabs limit reached", "You have reached the maximal tabs limit: " limits.3
			. "`nNew tabs cannot be created.")
		}

		TrayNotifications.Show("Increasing tabs limit to " nextLimit, "")
		
		GUI_Trades_V2.RecreateGUI(_buyOrSell, nextLimit)
	}


    Exists(_buyOrSell) {
		global GuiTrades
		hw := DetectHiddenWindows("On")
		hwnd := WinExist("ahk_id " GuiTrades[_buyOrSell].Handle)
		DetectHiddenWindows(hw)

		return hwnd
	}

	Enable_ClickThrough(_buyOrSell) {
		global GuiTrades
		Gui, Trades%_buyOrSell%: +LastFound
		WinSet, ExStyle, +0x20
	}

	Disable_ClickThrough(_buyOrSell) {
		global GuiTrades
		Gui, Trades%_buyOrSell%: +LastFound
		WinSet, ExStyle, -0x20
	}

	SetTransparencyPercent(_buyOrSell, transPercent) {
		global GuiTrades

		if !IsNum(transPercent) {
			AppendToLogs(A_ThisFunc "(transPercent=" transPercent "): Not a number. Setting transparency to max.")
			transValue := 255
		}
		else
			transValue := (255/100)*transPercent

		Gui, Trades%_buyOrSell%:+LastFound
		WinSet, Transparent,% transValue
	}

	SetTransparency_Automatic(_buyOrSell) {
		global GuiTrades
		if (GuiTrades[_buyOrSell].Tabs_Count = 0)
			GUI_Trades_V2.SetTransparency_Inactive(_buyOrSell)
		else
			GUI_Trades_V2.SetTransparency_Active(_buyOrSell)
	}

	SetTransparency_Inactive(_buyOrSell) {
		global PROGRAM, GuiTrades

		if IsContaining(_buyOrSell, "Preview")
			return

		transPercent := IsContaining(_buyOrSell, "Buy") ? 0 : PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency
		GUI_Trades_V2.SetTransparencyPercent(_buyOrSell, transPercent)
		if (transPercent = 0)
			GUI_Trades_V2.Enable_ClickThrough(_buyOrSell)
	}

	SetTransparency_Active(_buyOrSell) {
		global PROGRAM, GuiTrades

		if IsContaining(_buyOrSell, "Preview")
			return

		transPercent := PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency
		GUI_Trades_V2.SetTransparencyPercent(_buyOrSell, transPercent)
	}

	CloseAllTabs(_buyOrSell) {
		global GuiTrades

		Loop % GuiTrades[_buyOrSell].Tabs_Count {
			GUI_Trades_V2.RemoveTab(_buyOrSell, A_Index)
		}
	}

    GenerateUniqueID() {
		return RandomStr(l := 24, i := 48, x := 122)
	}

    UpdateSlotContent(_buyOrSell, slotNum, slotsObj, newContent) {
        ; FINISHED_V2
		global GuiTrades_Controls

		if !IsNum(slotNum) {
			AppendToLogs(A_ThisFunc "(slotNum=" tabID ")): tabID is not a number.")
			return
		}

		slotContent := GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum)
		if !IsObject(slotsObj)
			slotName := slotsObj, slotsObj := {}, slotsObj[slotName] := newContent
		for key, value in slotsObj
			if (key="AdditionalMessageFull")
				slotsObj[key] := slotContent.AdditionalMessageFull?slotContent.AdditionalMessageFull "\n" value : value
		 GUI_Trades_V2.SetSlotContent(_buyOrSell, slotNum, slotsObj, isNewlyPushed:=False, updateOnly:=True)
	}

	CreateGenericStyleAndUpdateButton(btnHwnd, btnType, ByRef Styles, styleName, iconOrText="") {
		global GuiTrades, PROGRAM
		_buyOrSell := GuiTrades.Sell.Handle ? "Sell" : "Buy"

		width := GuiTrades.AllStylesData[styleName].Width, height := GuiTrades.AllStylesData[styleName].Height
		if (btnType="Icon") {
			ret := GUI_Trades_V2.CreateGenericIconButtonStyle(Styles, styleName, width, height, iconOrText)
			Gui.ImageButtonUpdate(btnHwnd, Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
		}
		else if (btnType="Text") {
			ret := GUI_Trades_V2.CreateGenericTextButtonStyle(Styles, styleName, width, height)
			Gui.ImageButtonChangeCaption(btnHwnd, iconOrText, Styles[styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
		}
		return ret
	}

	CreateGenericIconButtonStyle_2(ByRef styles, styleName, width, height, _icon, specialOpts="") {
		global SKIN
		optionsDefault := {"CenterRatio":0.60},	options := JSON_Load(SKIN.Assets.Button_Generic2.Options), options := ObjMerge(optionsDefault, options)
		if IsObject(specialOpts)
			options := ObjMerge(specialOpts, options)

		styleObj := {}, assets := ["Background", "Left", "Right", "Top", "Bottom"]
		for index, asset in assets {
			if (options[asset].Skip)
				Continue
				
			assetSuffix := asset = "Background" && options.Background.UseBackground2=True ? "2" : ""
			styleObj[asset] := SKIN.Assets.Button_Generic2[asset assetSuffix]
			styleObj[asset "Hover"] := SKIN.Assets.Button_Generic2[asset assetSuffix "_Hover"]
			styleObj[asset "Press"] := SKIN.Assets.Button_Generic2[asset assetSuffix "_Press"]
			styleObj[asset "Default"] := SKIN.Assets.Button_Generic2[asset assetSuffix "_Default"]
		}
		styleObj.Center := SKIN.Assets.Icons[_icon], styleObj.CenterHover := SKIN.Assets.Icons[_icon], styleObj.CenterPress := SKIN.Assets.Icons[_icon], styleObj.CenterDefault := SKIN.Assets.Icons[_icon], 
		styleObj.Color := SKIN.Settings.Colors.Button_Normal, styleObj.ColorHover := SKIN.Settings.Colors.Button_Hover, styleObj.ColorPress := SKIN.Settings.Colors.Button_Press, styleObj.ColorDefault := SKIN.Settings.Colors.Button_Default, styleObj.ColorTransparency := SKIN.Assets.Misc.Transparency_Color
		styleObj.Width := width, styleObj.Height := height
		
		return GUI_Trades_V2.Create_Style(styles, styleName, styleObj, options, debug:=False)
	}

	CreateGenericIconButtonStyle(ByRef styles, styleName, width, height, _icon) {
		global SKIN
		optionsDefault := {"CenterRatio":0.60},	options := JSON_Load(SKIN.Assets.Button_Generic.Options), options := ObjMerge(optionsDefault, options)
		styleObj := {}, assets := ["Background", "Left", "Right", "Top", "Bottom"]
		for index, asset in assets {
			if (options[asset].Skip)
				Continue
				
			assetSuffix := asset = "Background" && options.Background.UseBackground2=True ? "2" : ""
			styleObj[asset] := SKIN.Assets.Button_Generic[asset assetSuffix]
			styleObj[asset "Hover"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Hover"]
			styleObj[asset "Press"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Press"]
			styleObj[asset "Default"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Default"]
		}
		styleObj.Center := SKIN.Assets.Icons[_icon], styleObj.CenterHover := SKIN.Assets.Icons[_icon], styleObj.CenterPress := SKIN.Assets.Icons[_icon], styleObj.CenterDefault := SKIN.Assets.Icons[_icon], 
		styleObj.Color := SKIN.Settings.Colors.Button_Normal, styleObj.ColorHover := SKIN.Settings.Colors.Button_Hover, styleObj.ColorPress := SKIN.Settings.Colors.Button_Press, styleObj.ColorDefault := SKIN.Settings.Colors.Button_Default, styleObj.ColorTransparency := SKIN.Assets.Misc.Transparency_Color
		styleObj.Width := width, styleObj.Height := height

		return GUI_Trades_V2.Create_Style(styles, styleName, styleObj, options, debug:=false)
	}

	CreateGenericTextButtonStyle(byRef styles, styleName, width, height) {
		global SKIN
		options := JSON_Load(SKIN.Assets.Button_Generic.Options)
		styleObj := {}, assets := ["Background", "Left", "Right", "Top", "Bottom"]
		for index, asset in assets {
			if (options[asset].Skip)
				Continue
				
			assetSuffix := asset = "Background" && options.Background.UseBackground2=True ? "2" : ""
			styleObj[asset] := SKIN.Assets.Button_Generic[asset assetSuffix]
			styleObj[asset "Hover"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Hover"]
			styleObj[asset "Press"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Press"]
			styleObj[asset "Default"] := SKIN.Assets.Button_Generic[asset assetSuffix "_Default"]
		}
		styleObj.Color := SKIN.Settings.Colors.Button_Normal, styleObj.ColorHover := SKIN.Settings.Colors.Button_Hover, styleObj.ColorPress := SKIN.Settings.Colors.Button_Press, styleObj.ColorDefault := SKIN.Settings.Colors.Button_Default, styleObj.ColorTransparency := SKIN.Assets.Misc.Transparency_Color
		styleObj.Width := width, styleObj.Height := height

		return GUI_Trades_V2.Create_Style(styles, styleName, styleObj, options, debug:=false)
	}

	Create_Style(ByRef styles, styleName, styleInfos, options="", debug=False) {
		global SKIN
	
		normalObj := {}, hoverObj := {}, pressObj := {}, defaultObj := {}, assets := ["Background", "Left", "Right", "Top", "Bottom", "Center"]
		for index, asset in assets {
			if (styleInfos[asset])
				normalObj[asset] := styleInfos[asset]
			if (styleInfos[asset "Hover"])
				hoverObj[asset] := styleInfos[asset "Hover"]
			if (styleInfos[asset "Press"])
				pressObj[asset] := styleInfos[asset "Press"]
			if (styleInfos[asset "Default"])
				defaultObj[asset] := styleInfos[asset "Default"]
		}
		sizesObj := {Width: styleInfos.Width, Height: styleInfos.Height}, optionsObj := options

		normalImg 	:= Gdip_AssembleBitmap(normalObj, sizesObj, optionsObj, debug:=debug)
		hoverImg 	:= Gdip_AssembleBitmap(hoverObj, sizesObj, optionsObj, debug:=debug)
		pressImg 	:= Gdip_AssembleBitmap(pressObj, sizesObj, optionsObj, debug:=debug)
		defaultimg 	:= Gdip_AssembleBitmap(defaultObj, sizesObj, optionsObj, debug:=debug)
		
		return styles[styleName] := [ [0, normalImg, "", styleInfos.Color, "", styleInfos.ColorTransparency]
			, [0, hoverImg, "", styleInfos.ColorHover, "", styleInfos.ColorTransparency]
			, [0, pressImg, "", styleInfos.ColorPress, "", styleInfos.ColorTransparency]
			, [0, defaultimg, "", styleInfos.ColorDefault, "", styleInfos.ColorTransparency] ]
	}

    Get_Styles() {
        ; FINISHED_V2
		global PROGRAM, SKIN

		skinSettings := SKIN.Settings
		skinAssets := SKIN.Assets
		skinColors := skinSettings.COLORS

		styles := {}
		for sect, nothing in skinAssets {
			if (skinAssets[sect].Normal && skinAssets[sect].Hover && skinAssets[sect].Press) {
				if (skinAssets[sect].Default) {
					%sect% := [ [0, skinAssets[sect].Normal, "", skinColors[sect "_Normal"], "", skinAssets.Misc.Transparency_Color]
							, [0, skinAssets[sect].Hover, "", skinColors[sect "_Hover"], "", skinAssets.Misc.Transparency_Color]
							, [0, skinAssets[sect].Press, "", skinColors[sect "_Press"], "", skinAssets.Misc.Transparency_Color]
							, [0, skinAssets[sect].Default, "", skinColors[sect "_Default"], "", skinAssets.Misc.Transparency_Color] ]
				}
				else {
					%sect% := [ [0, skinAssets[sect].Normal, "", skinColors.Button_Normal, "", skinAssets.Misc.Transparency_Color]
							, [0, skinAssets[sect].Hover, "", skinColors.Button_Hover, "", skinAssets.Misc.Transparency_Color]
							, [0, skinAssets[sect].Press, "", skinColors.Button_Press, "", skinAssets.Misc.Transparency_Color] ]
				}
			}
			else {
				%sect% := {}
				for key, value in skinAssets[sect] 
					%sect%[key] := value
			}
			styles[sect] := %sect%
		}

		Return styles
	}

	DestroyBtnImgList(_buyOrSell) {
		global GuiTrades, GuiTrades_Controls

		for key, value in GuiTrades_Controls[_buyOrSell]
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
		
		Loop % GuiTrades[_buyOrSell].Tabs_Limit
			for key, value in GuiTrades[_buyOrSell]["Slot" A_Index "_Controls"]
				if IsContaining(key, "hBTN_")
					try ImageButton.DestroyBtnImgList(value)
	}

	Destroy(_buyOrSell) {
		global GuiTrades
		
		GUI_Trades_V2.DestroyBtnImgList(_buyOrSell)
        if (GuiTrades[_buyOrSell].Is_Stack) {
            Gui.Destroy("Trades" _buyOrSell "Search")
            Gui.Destroy("Trades" _buyOrSell "SearchHidden")
        }
		Loop % GuiTrades[_buyOrSell].Tabs_Limit
			Gui.Destroy("Trades" _buyOrSell "_Slot" A_Index)
		Gui.Destroy(_buyOrSell)
		GuiTrades.Delete(_buyOrSell)
	}

	Submit(_buyOrSell, CtrlName="") {
		global GuiTrades, GuiTrades_Controls
		Gui.Submit(_buyOrSell)

		if (CtrlName) {
			Return GuiTrades_Submit[_buyOrSell][ctrlName]
		}
	}

    OnGuiMove(_buyOrSell) {
        ; FINISHED_V2
		/*	Allow dragging the GUI
		*/
		global PROGRAM, GuiTrades
		if IsContaining(_buyOrSell, "Preview")
			return

		if ( PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Mode = "Window" && PROGRAM.SETTINGS.SETTINGS_MAIN.TradesGUI_Locked = "False" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " GuiTrades[_buyOrSell].Handle
		}
		KeyWait, LButton, L
		GUI_Trades_V2.SavePosition(_buyOrSell)
		GUI_Trades_V2.RemoveButtonFocus(_buyOrSell)
		GUI_Trades_V2.ResetPositionIfOutOfBounds(_buyOrSell)
	}

	SavePosition(_buyOrSell) {
		global PROGRAM, GuiTrades
		guiIniSection := _buyOrSell="Sell"?"SELL_INTERFACE":"BUY_INTERFACE"

		gtPos := GUI_Trades_V2.GetPosition(_buyOrSell)
		if !IsNum(gtPos.X) || !IsNum(gtPos.Y)
			Return

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.MinimizeInterfaceToTheBottom = "True") {
			heightMin := GuiTrades[_buyOrSell].Height_Minimized, heightMax := GuiTrades[_buyOrSell].Height_Maximized, winDPI := GuiTrades[_buyOrSell].Windows_DPI
			if (GuiTrades[_buyOrSell].Is_Minimized) {	
				savedX := gtPos.X, savedY := gtPos.Y
				PROGRAM.SETTINGS[guiIniSection].Pos_X := savedX, PROGRAM.SETTINGS[guiIniSection].Pos_Y := savedY
			}
			else if (GuiTrades[_buyOrSell].Is_Maximized) {
				savedX := gtPos.X, savedY := gtPos.Y+gtPos.H-(heightMin*winDPI)
				PROGRAM.SETTINGS[guiIniSection].Pos_X := savedX, PROGRAM.SETTINGS[guiIniSection].Pos_Y := savedY
			}
		}
		else
			PROGRAM.SETTINGS[guiIniSection].Pos_X := gtPos.X, PROGRAM.SETTINGS[guiIniSection].Pos_Y := gtPos.Y
		
		Save_LocalSettings()
	}

	GetPosition(_buyOrSell) {
		global GuiTrades
		hw := DetectHiddenWindows("On")
		WinGetPos, x, y, w, h,% "ahk_id " GuiTrades[_buyOrSell].Handle
        DetectHiddenWindows(hw)
		
		return {x:x,y:y,w:w,h:h}
	}

	ResetPositionIfOutOfBounds(_buyOrSell) {
		global PROGRAM, GuiTrades

		if ( !GUI_Trades_V2.Exists(_buyOrSell) )
			return

		; winHandle := GuiTrades.Is_Minimized ? GuiTradesMinimized.Handle : GuiTrades.Handle
		winHandle := GuiTrades[_buyOrSell].Handle
		if (!winHandle)
			return
		
		if !IsWindowInScreenBoundaries(_win:="ahk_id " winHandle, _screen:="All", _adv:=False) {
			bounds := IsWindowInScreenBoundaries(_win:="ahk_id " winHandle, _screen:="All", _adv:=True)
			appendTxtFinal := "Win_X: " bounds[1].Win_X " | Win_Y: " bounds[1].Win_Y " - Win_W: " bounds[1].Win_W " | Win_H: " bounds[1].Win_H
			for index, nothing in bounds {
				appendTxt := "Monitor ID: " index
				. "`nMon_L: " bounds[index].Mon_L " | Mon_T: " bounds[index].Mon_T " | Mon_R: " bounds[index].Mon_R " | Mon_B: " bounds[index].Mon_B
				. "`nIsInBoundaries_H: " bounds[index].IsInBoundaries_H " | IsInBoundaries_V: " bounds[index].IsInBoundaries_V
				appendTxtFinal := appendTxtFinal ? appendTxtFinal "`n" appendTxt : appendTxt
			}
			AppendToLogs("Reset GUI Trades" _buyOrSell " position due to being deemed out of bounds."
			. "`n" appendTxtFinal)
			GUI_Trades_V2.ResetPosition(_buyOrSell)
			
			TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.PositionHasBeenReset_Title, PROGRAM.TRANSLATIONS.TrayNotifications.PositionHasBeenReset_Msg)
		}
	}

    Show(_buyOrSell) {
		global GuiTrades, PROGRAM
        tabsOrStack := GuiTrades[_buyOrSell].Is_Stack ? "Stack" : "Tabs"
		
		if (PROGRAM.SETTINGS.SETTINGS_MAIN.DisableBuyInterface="True")
			return

		hw := DetectHiddenWindows("On")
		foundHwnd := WinExist("ahk_id " GuiTrades[_buyOrSell].Handle)
		DetectHiddenWindows(hw)

		if (foundHwnd) {
			Gui, Trades%_buyOrSell%:Show, NoActivate
		}
		else {
			AppendToLogs("GUI_Trades_V2.Show(" _buyOrSell "): Non existent. Recreating.")
			GUI_Trades_V2.Create("", _buyOrSell, tabsOrStack)
			Gui, Trades%_buyOrSell%:Show, NoActivate
		}
	}

	Redraw(_buyOrSell) {
		Gui, Trades%_buyOrSell%:+LastFound
		WinSet, Redraw
	}

	WM_LBUTTONDOWN() {
		global GuiTrades, GuiTrades_Controls

		if !IsContaining(A_Gui, "Trades")
			return

		_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"
		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)
		RegExMatch(A_Gui, "\d+", slotNum)

		if (underMouseName = "hTEXT_AdditionalMessage") {
			tabContent := Gui_Trades_V2.GetTabContent(_buyOrSell, slotNum)
			if (tabContent.AdditionalMessageFull) {
				GuiTrades[_buyOrSell].HasToolTip := True
				ShowToolTip( StrReplace(tabContent.AdditionalMessageFull,"\n","`n") , , , 20, 20)
			}
		}
		else if (underMouseName = "hIMG_TradeVerifyColor") {
			GuiTrades[_buyOrSell].HasClickedTradeVerifyDot := True
		}
		else if IsContaining(A_Gui, "Search")
			GuiTrades[_buyOrSell].HasClickedSearch := True
	}

	WM_LBUTTONUP() {
		global GuiTrades, GuiTrades_Controls

		if !IsContaining(A_Gui, "Trades")
			return

		_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"
		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)
		RegExMatch(A_Gui, "\d+", slotNum)

		if (GuiTrades[_buyOrSell].HasToolTip) {
			RemoveToolTip()
		}

		if (GuiTrades[_buyOrSell].HasClickedTradeVerifyDot) {
			tabContent := GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum)
			GUI_Trades_V2.VerifyItemPrice(tabContent)
		}
		
		if (GuiTrades[_buyOrSell].HasClickedSearch && IsContaining(A_Gui, "Search")) {
			hw := DetectHiddenWindows("On")
			GUI_Trades_V2.SetFakeSearch(_buyOrSell, makeEmpty:=True) 
			WinActivate,% "ahk_id " GuiTrades_Controls[_buyOrSell].GuiSearchHiddenHandle
			DetectHiddenWindows(hw)
		}
		; GUI_Trades_V2.RemoveButtonFocus() ; Don't do this. It will prevent buttons from working.
		GuiTrades[_buyOrSell].HasToolTip := False
		GuiTrades[_buyOrSell].HasClickedSearch := False
		GuiTrades[_buyOrSell].HasClickedTradeVerifyDot := False
	}

	WM_MOUSEMOVE() {
		global PROGRAM, DEBUG
		global GuiTrades, GuiTrades_Controls
		static mouseX, mouseY, prevMouseX, prevMouseY
		static ctrlToolTip, underMouseHwnd, prevUnderMouseHwnd

		if !IsContaining(A_Gui, "Trades")
			return
		MouseGetPos, mouseX, mouseY
		if (mouseX = prevMouseX && mouseY = prevMouseY)
			Return

		_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"
		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)
		RegExMatch(A_Gui, "\d+", slotNum)

		ctrlToolTip := (underMouseName = "hBTN_CloseTab") ? "Close this trade window"
			: (underMouseName = "hBTN_Minimize") ? "Minimize this interface"
			: (underMouseName = "hBTN_Maximize") ? "Maximize this interface"
			: (underMouseName = "hBTN_Hideout") ? "Go to your hideout"
			: (underMouseName = "hBTN_LeagueHelp") ? "See league informative sheets"
			: (underMouseName = "hBTN_LeftArrow") ? "Scroll to the left"
			: (underMouseName = "hBTN_RightArrow") ? "Scroll to the right"		
			: (underMouseName = "hTEXT_BuyerName" && GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).BuyerIsCut) ? GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).Buyer
			: (underMouseName = "hTEXT_SellerName" && GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).SellerIsCut) ? GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).Seller
			: (underMouseName = "hTEXT_ItemName" && GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).IsItemCut) ? GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).Item
			: (underMouseName = "hIMG_CurrencyIMG") ? GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).PriceCurrency
			: (underMouseName = "hTEXT_AdditionalMessage" && ( GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).AdditionalMessage != GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).AdditionalMessageFull ) ) ? StrReplace(GUI_Trades_V2.GetTabContent(_buyOrSell, slotNum).AdditionalMessageFull, "\n", "`n")
			: IsContaining(A_Gui, "Search") ? "Search by name or item"
			: ""
		if (underMouseName = "hIMG_TradeVerifyColor") {
			ctrlToolTip := GUI_Trades_V2.GetTabContent("Sell", slotNum).TradeVerifyText
			ctrlToolTip := StrReplace(ctrlToolTip, "\n", "`n")
		}
		; Tooltip % A_Gui "`n" underMouseName "`n" underMouseHwnd "`n" ctrlToolTip	
		
		If (underMouseHwnd != prevUnderMouseHwnd) {
			if (ctrlToolTip) {
				timer := DEBUG.SETTINGS.instant_settings_tooltips ? -10
					: IsIn(underMouseName, "hIMG_TradeVerifyColor,hIMG_CurrencyIMG,hTEXT_BuyerName,hTEXT_SellerName,hTEXT_ItemName,hTEXT_AdditionalMessage") ? -10
					: -1000
				SetTimer, GUI_Trades_V2_WM_MOUSEMOVE_DisplayToolTip,% timer
				if (underMouseName="hTEXT_AdditionalMessage" && _buyOrSell="Sell")
					GUI_Trades_V2.UnSetTabStyleWhisperReceived(slotNum)
			}

			prevUnderMouseHwnd := underMouseHwnd
		}

		prevMouseX := mouseX, prevMouseY := mouseY
		return

		GUI_Trades_V2_WM_MOUSEMOVE_DisplayToolTip:
			if (Get_UnderMouse_CtrlHwnd() != underMouseHwnd)
				return

			try ShowToolTip(ctrlToolTip)
			SetTimer, GUI_Trades_V2_WM_MOUSEMOVE_RemoveToolTip, -5000
		return

		GUI_Trades_V2_WM_MOUSEMOVE_RemoveToolTip:
			RemoveToolTip()
		return
	}

	WM_MOUSEWHEEL(wParam, lParam) {
		; A_EventInfo: Contains 0 if the message was sent via SendMessage. If sent via PostMessage, it contains the tick-count time the message was posted.
		; For some reason this function is always triggering twice upon scrolling once. Most likely related to my limited understanding of this message
		static MK_CONTROL 	:= 0x0008
		static MK_LBUTTON 	:= 0x0001
		static MK_MBUTTON 	:= 0x0010
		static MK_RBUTTON 	:= 0x0002
		static MK_SHIFT 	:= 0x0004
		static MK_XBUTTON1 	:= 0x0020
		static MK_XBUTTON2 	:= 0x0040
		static WheelDelta := 120 << 16

		static eventInfoBak
		if (A_EventInfo=eventInfoBak) {
			; Prevent from running the function multiple times from a single scroll
			return
		}

		if !IsIn(A_Gui, "TradesSell,TradesBuy") {
			; Scrolling on a child element somehow triggers the function for the child and then the parent
			;	We block it here for the child, so that it only runs once for the parent 
			; Update the backup value so that next scroll will be blocked if it's the same
			eventInfoBak := A_EventInfo
			return
		}
		_buyOrSell := IsContaining(A_Gui, "Buy") ? "Buy" : "Sell"

		ctrl_pressed := wParam & MK_CONTROL ? True : False
		mks := ["CONTROL","LBUTTON","MBUTTON","RBUTTON","SHIFT","XBUTTON1","XBUTTON2"]
		Loop % mks.Count() {
			thisMK := mks[A_Index]
			if (wParam & MK_%thisMK%)
				wParam := wParam - MK_%thisMK%
		}
		isWheelUp := WheelDelta = wParam ? True : False

		if (isWheelUp) {
			if (ctrl_pressed) ; ctrl pressed
				GUI_Trades_V2.SelectPreviousTab(_buyOrSell)
			else
				GUI_Trades_V2.ScrollUp(_buyOrSell)
		}
		else {
			if (ctrl_pressed) ; ctrl pressed
				GUI_Trades_V2.SelectNextTab(_buyOrSell)
			else 
				GUI_Trades_V2.ScrollDown(_buyOrSell)
		}

		eventInfoBak := A_EventInfo
	}
}

GUI_Trades_V2_Search_Buy:
	GUI_Trades_V2.Search("Buy")
return
GUI_Trades_V2_Search_Sell:
	GUI_Trades_V2.Search("Sell")
return

/*
GUI_Trades_V2_Buy_CopyItemInfos_CurrentTab_Timer:
	SetTimer, GUI_Trades_V2_Buy_CopyItemInfos_CurrentTab, Delete
	SetTimer, GUI_Trades_V2_Buy_CopyItemInfos_CurrentTab, -500
return
GUI_Trades_V2_Buy_CopyItemInfos_CurrentTab:
	GUI_Trades_V2.CopyItemInfos(_buyOrSell)
return
*/

GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab_Timer:
	SetTimer, GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab, Delete
	SetTimer, GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab, -500
return
GUI_Trades_V2_Sell_CopyItemInfos_CurrentTab:
	GUI_Trades_V2.CopyItemInfos(_buyOrSell)
return

GUI_Trades_V2_Sell_RefreshIgnoreList:
	GUI_Trades_V2.RefreshIgnoreList()
return

GUI_Trades_V2_SelectTab_Hotkey:
	; Ctrl+WheelDown hotkey was disabled in favour of WM_MOUSEWHEEL
	; Ctrl+Tab and Ctrl+Shift+Tab still work
	global GuiTrades
	MouseGetPos, , , undermouseWinHwnd
	if IsIn(underMouseWinHwnd, GuiTrades.Buy.Handle "," GuiTrades.Sell.Handle) {
		StringTrimLeft, thishotkey, A_ThisHotkey, 1 ; Removes ~
		if IsIn(thishotkey, "^SC00F,^WheelDown") { ; Ctrl+Tab / Ctrl+WheelDown
			if (underMouseWinHwnd=GuiTrades.Buy.Handle)
				GUI_Trades_V2.SelectNextTab("Buy")
			else if (underMouseWinHwnd=GuiTrades.Sell.Handle)
				GUI_Trades_V2.SelectNextTab("Sell")
		}
		else if IsIn(thishotkey, "^+SC00F,^WheelUp") { ; Ctrl+Shift+Tab / Ctrl+WheelUp
			if (underMouseWinHwnd=GuiTrades.Buy.Handle)
				GUI_Trades_V2.SelectPreviousTab("Buy")
			else if (underMouseWinHwnd=GuiTrades.Sell.Handle)
				GUI_Trades_V2.SelectPreviousTab("Sell")
		}
	}
return