Class GUI_MyStats {
	
	Create(param="") {
		global PROGRAM, GAME
		global GuiMyStats, GuiMyStats_Controls, GuiMyStats_Submit
		static guiCreated

		GUI_MyStats.Destroy()
		Gui.New("MyStats", "-Caption +Resize -MaximizeBox +MinSize720x480  +LabelGUI_MyStats_ +HwndhGuiMyStats", "POE TC - " PROGRAM.TRANSLATIONS.TrayMenu.Stats)
		; Gui.New("MyStats", "-Caption -Border +LabelGUI_MyStats_ +HwndhGuiMyStats", "MyStats")
		GuiMyStats.Is_Created := False

		guiCreated := False
		guiFullHeight := 480, guiFullWidth := 720, borderSize := 1, borderColor := "Red"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		GuiMyStats.Style_Tab := Style_Tab := [ [0, "0xEEEEEE", "", "Black", 0, , ""] ; normal
			, [0, "0xdbdbdb", "", "Black", 0] ; hover
			, [3, "0x44c6f6", "0x098ebe", "Black", 0]  ; press
			, [3, "0x44c6f6", "0x098ebe", "White", 0 ] ] ; default

		GuiMyStats.Style_RedBtn := Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("MyStats", 0, 0)
		Gui.Color("MyStats", "White")
		Gui.Font("MyStats", "Segoe UI", "8")
		Gui, MyStats:Default ; Required for LV_ cmds

		; *	* Borders
		/*
		Upon resizing a PROGRESS control, it will have some kind of "border" around it
		This end up making the border greyish as the actual PROGRESS control color starts 1-2 px away
		Since this GUI is resizable, we use a workaround that consists of adding a TEXT control with a black border via the 0x7 style

		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right
		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("MyStats", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " hwndhPROGRESS_Border" A_Index " cRed -Smooth", 100)
		*/
		Gui.Add("MyStats", "Text", "x0 y0 w" guiWidth " h" guiHeight " hwndhTEXT_Borders 0x7 BackgroundTrans")
		

		; * * Title bar
		Gui.Add("MyStats", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-31 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("MyStats", "Progress", "xp yp wp hp hwndhPROGRESS_TitleBackground Background359cfc") ; Title bar background
		Gui.Add("MyStats", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans hwndhTEXT_TitleText", "POE Trades Companion - " PROGRAM.TRANSLATIONS.TrayMenu.Stats) ; Title bar text
		imageBtnLog .= Gui.Add("MyStats", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)

        ; * * Filtering options
        Gui.Add("MyStats", "GroupBox", "x" leftMost+10 " y+10 w" guiWidth-20 " R12 c000000 hwndhGB_FilteringOptions", "Filtering Options")
        Gui.Add("MyStats", "Text", "x" leftMost+25 " yp+25 w40 hwndhTEXT_BuyerFilter", "Buyer:")
        Gui.Add("MyStats", "DropDownList", "x+0 yp-2 vvDDL_BuyerFilter hwndhDDL_BuyerFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w50 hwndhTEXT_ItemFilter", "Item:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 ToolTip hwndhDDL_ItemFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w40 hwndhTEXT_LeagueFilter", "League:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_LeagueFilter w160", "All")

        Gui.Add("MyStats", "Text", "x" leftMost+25 " y+20 w40 hwndhTEXT_GuildFilter", "Guild:")
        Gui.Add("MyStats", "DropDownList", "x+0 yp-2 hwndhDDL_GuildFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w50 hwndhTEXT_CurrencyFilter", "Currency:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_CurrencyFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w40 hwndhTEXT_TabFilter", "Tab:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_TabFilter w160", "All")

		ctrlPos := Get_ControlCoords("MyStats", GuiMyStats_Controls.hDDL_TabFilter)
		Gui.Add("MyStats", "Button", "x" leftMost+25 " y+10 w" ctrlPos.X+ctrlPos.W-(leftMost+25) " hwndhBTN_ApplyFilters", "Apply filters")		
		Gui.Add("MyStats", "Button", "x" ctrlPos.X+ctrlPos.W-115 " y+10 w115 hwndhBTN_ExportAsCSV", "Export stats as .CSV")

        ; * * Stats list
        Gui.Add("MyStats", "ListView", "x" leftMost+10 " y+30 w" guiWidth-20 " R17 +Grid hwndhLV_Stats", "#|Date|Time|Guild|Buyer|Item|Price|League|Tab|Other")

		; * * Stats parse
		GUI_MyStats.UpdateData()
        GUI_MyStats.SetFilter("All", "All")
		GUI_MyStats.SetFilter("League", StrSplit(GAME.CHALLENGE_LEAGUE, ",").1)
		GUI_MyStats.ApplyFilters()

		; Gui, Stats: Show, AutoSize NoActivate


        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		GUI_MyStats.EnableSubroutines()
        Gui.Show("MyStats", "h" guiHeight " w" guiWidth-1 " NoActivate Hide")

		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")
		OnMessage(0x84, "WM_NCHITTEST")
		OnMessage(0x83, "WM_NCCALCSIZE")
		OnMessage(0x86, "WM_NCACTIVATE")

		Gui.Show("MyStats", "h" guiHeight " w" guiWidth " NoActivate Hide")

        Return

        Gui_MyStats_Size:
            GUI_MyStats.Resize()
        Return

		Gui_MyStats_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, MyStats:,% ctrlHwnd

			Gui_MyStats.ContextMenu(ctrlHwnd, ctrlName)
		Return
    }

    DisableSubroutines() {
		GUI_MyStats.ToggleSubroutines("Disable")	
	}
	EnableSubroutines() {
		GUI_MyStats.ToggleSubroutines("Enable")	
	}

	ToggleSubroutines(enableOrDisable) {
		global GuiMyStats, GuiMyStats_Controls

		for ctrlName, ctrlHandle in GuiMyStats_Controls {
			loopedCtrl := ctrlName
			RegExMatch(loopedCtrl, "\D+", loopedCtrl_NoNum)
			RegExMatch(loopedCtrl, "\d+", loopedCtrl_NumOnly)

			if (enableOrDisable = "Disable")
				GuiControl, MyStats:-g,% GuiMyStats_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hTEXT_HeaderGhost")
					__f := GUI_MyStats.DragGui.bind(GUI_MyStats, GuiMyStats.Handle)
				else if (loopedCtrl = "hBTN_CloseGUI")
					__f := GUI_MyStats.Close.bind(GUI_MyStats)
				else if (loopedCtrl = "hLV_Stats")
					__f := GUI_MyStats.OnLVClick.bind(GUI_MyStats)
				else if (loopedCtrl = "hBTN_ExportAsCSV")
					__f := GUI_MYStats.ExportCurrentListAsCSV.bind(GUI_MYStats)
				else if (loopedCtrl = "hBTN_ApplyFilters")
					__f := GUI_MyStats.ApplyFilters.bind(GUI_MYStats)
				else
					__f := 

				if (__f)
					GuiControl, MyStats:+g,% GuiMyStats_Controls[loopedCtrl],% __f 
			}
		}
	}

	OnLVClick(hwnd, guiEvent="", eventInfo="") {
		GUI_MyStats.SetDefaultListView("hLV_Stats")

		if (guiEvent="ColClick") {
			LV_GetText(Out1, 1, eventInfo)
			LV_GetText(Out2, LV_GetCount(), eventInfo)
			isSortedDown := Out2 < Out1
			if (isSortedDown)
				LV_ModifyCol(eventInfo, "Sort") 	
			else
				LV_ModifyCol(eventInfo, "SortDesc") 
		}
	}

	StatsData_AddRow(num, what) {
		loopedData := what
		Loop {
			; Get all the Other_xx and set it in a single string
			otherIndex := A_Index
			loopedDataOther := loopedData["Other_" otherIndex]
			if (loopedDataOther != "" && loopedDataOther != "ERROR")
				loopedOther .= (loopedOther)?("     " otherIndex ": " loopedDataOther):(otherIndex ": " loopedDataOther)
			else
				Break

			if (otherIndex > 100) {
				AppendToLogs("GUI_MyStats.StatsData_AddRow(): Broke out of loop after 100")
				Break
			}
			otherIndex--
			; Add the content into the lv line
			loopedOther := (otherIndex)?(otherIndex " message ->    " loopedOther):("")
		}

		LV_Add("", loopedData.Index, loopedData.Date_YYYYMMDD, loopedData.Time, loopedData.Guild, loopedData.Buyer, loopedData.Item
			, loopedData.Price, loopedData.Location_League, loopedData.Location_Tab, loopedOther)
	}

	RemoveSelectedEntry() {
		global PROGRAM
		global GuiMyStats, GuiMyStats_Controls
		iniFile := PROGRAM.TRADES_HISTORY_FILE
		rowID := GuiMyStats.SelectedRow

		GUI_MyStats.SetDefaultListView("hLV_Stats")
		Loop {
			LV_GetText(c%A_Index%_title, 0, A_Index)
			LV_GetText(c%A_Index%_content, rowID, A_Index)
			if (c%A_Index%_title && c%A_Index%_title != "" && c%A_Index%_title != "Other") {
				title := c%A_Index%_title, content := c%A_Index%_content
				msg := msg ? msg "`n" title ": `t`t" content : title ": `t`t" content
			}
			else if (A_Index > 20)
				Break
			else Break
		}
		
		boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.MyStats_ConfirmDeleteThisEntry, "%entry%", msg)
		MsgBox(4096+4, , boxTxt)
		IfMsgBox, Yes
		{
			GUI_MyStats.DisableSubroutines()
			INI.Set(iniFile, c1_content, "Ignore", "True")
			LV_Delete(rowID)
			GUI_MyStats.EnableSubroutines()
		}
	}

	GetData() {
		global PROGRAM
		statsIniFile := PROGRAM.TRADES_HISTORY_FILE

		statsData := class_EasyIni(statsIniFile)
		EasyIni_Remove(statsData, "GENERAL")

		Loop % statsData.MaxIndex() {
			statsData[A_Index].Index := A_Index
		}

		return statsData
	}

	UpdateData() {
		global GuiMyStats, GuiMyStats_Controls
		static allBuyers, allGuilds, allItems, allCurrency, allLeagues, allTabs, allItems_parsed, listedCurrencies, unlistedCurrencies

		; Set GUI as default, needed for LV cmds. Set LV as default for gui.
		GUI_MyStats.SetDefaultListView("hLV_Stats")

		batchlines := A_BatchLines
		SetBatchLines, -1

		; Get data and parse it
		dataMaxIndex := GuiMyStats.Stats_Data.MaxIndex()
		data := GUI_MyStats.GetData(), GuiMyStats.Stats_Data := data

		loopNum := dataMaxIndex?data.MaxIndex()-dataMaxIndex : data.MaxIndex()
		GuiControl,% "MyStats:+Count" loopNum,% GuiMyStats_Controls.hLV_Stats

		bak := {allBuyers:allBuyers, allGuilds:allGuilds, allItems:allItems, allCurrency:allCurrency, allLeagues:allLeagues, allTabs:allTabs
		, allItems_parsed:allItems_parsed, listedCurrencies:listedCurrencies, unlistedCurrencies:unlistedCurrencies}

		Loop % loopNum {
			loopIndex := dataMaxIndex?dataMaxIndex+A_Index:A_Index
			loopedData := data[loopIndex]
			if (loopedData.Ignore != "True") {

				; Replace any possible comma to avoid interfer with IsIn()
				loopedBuyer := StrReplace(loopedData.Buyer, ",", "{COMMA}")
				loopedGuild := StrReplace(loopedData.Guild, ",", "{COMMA}")
				loopedItem := StrReplace(loopedData.Item_Name, ",", "{COMMA}")
				loopedCurrency := StrReplace(loopedData.Price, ",", "{COMMA}")
				loopedLeague := StrReplace(loopedData.Location_League, ",", "{COMMA}")
				loopedTab := StrReplace(loopedData.Location_Tab, ",", "{COMMA}")

				; Create the lists
				if (loopedBuyer)
					allBuyers .= (!allBuyers)?(loopedBuyer)
					: !IsIn(loopedBuyer, allBuyers)?("," loopedBuyer) : ("")
				if (loopedGuild)
					allGuilds .= (!allGuilds)?(loopedGuild)
					: !IsIn(loopedGuild, allGuilds)?("," loopedGuild) : ("")
				if (loopedItem)
					allItems .= (!allItems)?(loopedItem)
					: !IsIn(loopedItem, allItems)?("," loopedItem) : ("")
				if (loopedCurrency)
					allCurrencies .= (!allCurrencies)?(loopedCurrency)
					: !IsIn(loopedCurrency, allCurrencies)?("," loopedCurrency) : ("")
				if (loopedLeague)
					allLeagues .= (!allLeagues)?(loopedLeague)
					: !IsIn(loopedLeague, allLeagues)?("," loopedLeague) : ("")
				if (loopedTab)
					allTabs .= (!allTabs)?(loopedTab)
					: !IsIn(loopedTab, allTabs)?("," loopedTab) : ("")
			}
		}

		; Parse items, in case its currency
		if (allItems != bak.allItems) {
			Loop, Parse, allItems,% ","
			{
				cInfos := Get_CurrencyInfos(A_LoopField, dontWriteLogs:=True)
				if (cInfos.Is_Listed) && !IsIn(cInfos.Name, allItems_parsed)
					allItems_parsed .= (!allItems_parsed)?(cInfos.Name)
					: ("," cInfos.Name)
				else
					allItems_parsed .= (!allItems_parsed)?(A_LoopField)
					: ("," A_LoopField)
			}
		}

		; Parse currencies, separate unlisted and listed
		if (allCurrencies != bak.allCurrencies) {
			Loop, Parse, allCurrencies,% ","
			{
				cInfos := Get_CurrencyInfos(A_LoopField, dontWriteLogs:=True)
				if (cInfos.Is_Listed) && !IsIn(cInfos.Name, listedCurrencies)
					listedCurrencies .= (!listedCurrencies)?(cInfos.Name)
					: !IsIn(cInfos.Name, listedCurrencies)?("," cInfos.Name) : ("")
				else if (!cInfos.Is_Listed) && !IsIn(cInfos.Name, unlistedCurrencies)
					unlistedCurrencies .= (!unlistedCurrencies)?(cInfos.Name)
					: !IsIn(cInfos.Name, unlistedCurrencies)?("," cInfos.Name) : ("")
			}
		}

		; Replace comma separator with vertical bar, put back comma in place of temporary str
		; -> Sorting lists -> Declare global var -> Set GUI controls
		filters := GUI_MyStats.GetFilter("All")
		if (allBuyers != bak.allBuyers) {
			allBuyers := StrReplace(allBuyers, ",", "|"), StrReplace(allBuyers, "{COMMA}", ",")
			Sort, allBuyers,% "UD|"
			GuiMyStats.All_Buyers := allBuyers
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_BuyerFilter,% "|All|" allBuyers
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_BuyerFilter,% filters.Buyer
		}
		if (allGuilds != bak.allGuilds) {
			allGuilds := StrReplace(allGuilds, ",", "|"), StrReplace(allGuilds, "{COMMA}", ",")
			Sort, allGuilds,% "UD|"
			GuiMyStats.All_Guilds := allGuilds
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_GuildFilter,% "|All|No guild|" allGuilds
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_GuildFilter,% filters.Guild
		}
		if (allItems != bak.allItems) {
			allItems := StrReplace(allItems, ",", "|"), StrReplace(allItems, "{COMMA}", ",")
			Sort, allItems,% "UD|"
			GuiMyStats.All_Items := allItems	
		}
		if (allItems_parsed != bak.allItems_parsed) {
			allItems_parsed := StrReplace(allItems_parsed, ",", "|"), StrReplace(allItems_parsed, "{COMMA}", ",")
			Sort, allItems_parsed,% "UD|"
			GuiMyStats.All_Items_Parsed := allItems_parsed
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_ItemFilter,% "|All|" allItems_parsed
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_ItemFilter,% filters.Item
		}
		if (allCurrencies != bak.allCurrencies) {
			allCurrencies := StrReplace(allCurrencies, ",", "|"), StrReplace(allCurrencies, "{COMMA}", ",")
			Sort, allCurrencies,% "UD|"
			GuiMyStats.All_Currencies := allCurrencies
		}
		if (listedCurrencies != bak.listedCurrencies) {
			listedCurrencies := StrReplace(listedCurrencies, ",", "|"), StrReplace(listedCurrencies, "{COMMA}", ",")
			Sort, listedCurrencies,% "UD|"
			GuiMyStats.All_ListedCurrencies := listedCurrencies
		}
		if (unlistedCurrencies != bak.unlistedCurrencies) {
			unlistedCurrencies := StrReplace(unlistedCurrencies, ",", "|"), StrReplace(unlistedCurrencies, "{COMMA}", ",")
			Sort, unlistedCurrencies,% "UD|"
			GuiMyStats.All_UnlistedCurrencies := unlistedCurrencies
		}
		if (allCurrencyTypes != bak.allCurrencyTypes) {
			allCurrencyTypes := unlistedCurrencies?listedCurrencies "| |Unknown: |" unlistedCurrencies : listedCurrencies
			Sort, allCurrencyTypes,% "UD|"
			GuiMyStats.All_CurrencyTypes := allCurrencyTypes
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_CurrencyFilter,% "|All|" allCurrencyTypes
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_CurrencyFilter,% filters.Currency
		}
		if (allLeagues != bak.allLeagues) {
			allLeagues := StrReplace(allLeagues, ",", "|"), StrReplace(allLeagues, "{COMMA}", ",")
			Sort, allLeagues,% "UD|"
			GuiMyStats.All_Leagues := allLeagues
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_LeagueFilter,% "|All|" allLeagues
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_LeagueFilter,% filters.League
		}
		if (allTabs != bak.allTabs) {
			allTabs := StrReplace(allTabs, ",", "|"), StrReplace(allTabs, "{COMMA}", ",")
			Sort, allTabs,% "UD|"
			GuiMyStats.All_Tabs := allTabs
			GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_TabFilter,% "|All|" allTabs
			GuiControl, MyStats:ChooseString,% GuiMyStats_Controls.hDDL_TabFilter,% filters.Tab
		}	

		SetBatchLines, %batchlines%
	}

    GetFilter(fType="All") {
		global GuiMyStats_Submit

		Gui_MyStats.Submit()
		sub := GuiMyStats_Submit
		
		if (fType = "All") {
			return {Buyer: sub.hDDL_BuyerFilter, Item: sub.hDDL_ItemFilter, League: sub.hDDL_LeagueFilter
			, Guild: sub.hDDL_GuildFilter, Currency: sub.hDDL_CurrencyFilter, Tab: sub.hDDL_TabFilter}
		}
		else
			return sub["hDDL_" fType]
	}

    SetFilter(filterType, setContent) {
        global GuiMyStats, GuiMyStats_Controls

		if (filterType = "All") {
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_BuyerFilter,% setContent
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_ItemFilter,% setContent
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_LeagueFilter,% setContent
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_GuildFilter,% setContent
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_CurrencyFilter,% setContent
			GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_TabFilter,% setContent
		}
		else
        	GuiControl, MyStats:Choose,% GuiMyStats_Controls["hDDL_" filterType "Filter"],% setContent
    }

	ApplyFilters() {
		global GuiMyStats, GuiMyStats_Controls

		GUI_MyStats.SetDefaultListView("hLV_Stats")

		batchlines := A_BatchLines
		SetBatchLines, -1
		GuiControl, -Redraw,% GuiMyStats_Controls.hLV_Stats

		filters := GUI_MyStats.GetFilter("All")

		LV_Delete()
		addIndex := 1
		Loop % GuiMyStats.Stats_Data.MaxIndex() {
			loopIndex := A_Index
			loopedData := GuiMyStats.Stats_Data[loopIndex]
			if (loopedData.Ignore != "True") {

				cInfos_price := Get_CurrencyInfos(loopedData.Price, dontWriteLogs:=True)
				cInfos_item := Get_CurrencyInfos(loopedData.Item, dontWriteLogs:=True)
				
				if ( (loopedData.Buyer = filters.Buyer) || (filters.Buyer = "All") )
				&& ( (loopedData.Item = filters.Item) || (cInfos_item.Is_Listed && cInfos_item.Name = filters.Item) || (filters.Item = "All") )
				&& ( (loopedData.Location_League = filters.League) || (filters.League = "All") )
				&& ( (loopedData.Guild = filters.Guild) || (filters.Guild = "All") || (filters.Guild = "No guild" && loopedData.Guild = "") )
				&& ( (cInfos_price.Name = filters.Currency) || (filters.Currency = "All") )
				&& ( (loopedData.Location_Tab = filters.Tab) || (filters.Tab = "All") ) {
					GUI_MyStats.StatsData_AddRow(addIndex, loopedData)
					addindex++
				}
			}
		}

		; Autoadjust col
		Loop % LV_GetCount("Col")
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
		LV_ModifyCol(10, "NoSort")
		LV_ModifyCol(10, 100)

		SetBatchLines, %batchlines%

		GuiControl, +Redraw,% GuiMyStats_Controls.hLV_Stats
	}

	ExportCurrentListAsCSV() {
		global PROGRAM, GuiMyStats_Controls
		GUI_MyStats.SetDefaultListView("hLV_Stats") ; neccessary to use LV cmds

		; Setting file path
		filePath := PROGRAM.MAIN_FOLDER "\Exported_Stats_" A_Now
		if FileExist(filePath ".csv")
			filePath := filePath "_" RandomStr(5)
		; Saving file as CSV
		filePath := filePath ".csv"
		CSV_LVSave(filePath, GuiMyStats_Controls.hLV_Stats, "`t", OverWrite:=True, "MyStats")
		; Showing tray notification and opening locaion folder
		SplitPath, filePath, fileName, fileFolder
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.StatsExported_Msg, "%file%", fileName)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.StatsExported_Title, trayMsg)
		Run, %fileFolder%
	}

	SetTranslation(_lang="english", _ctrlName="") {
		global PROGRAM, GuiMyStats, GuiMyStats_Controls
		trans := PROGRAM.TRANSLATIONS.GUI_MyStats

		GUI_MyStats.DestroyBtnImgList()

		noResizeCtrls := "hBTN_CloseGUI,hGB_FilteringOptions,hLV_Stats"
		noSmallerCtrls := "hBTN_ApplyFilters,hBTN_ExportAsCSV"

		if (_ctrlName) {
			if (trans != "") ; selected trans
				GuiControl, MyStats:,% GuiMyStats_Controls[_ctrlName],% trans
		}
		else {
			for ctrlName, ctrlTranslation in trans {
				if !( SubStr(ctrlName, -7) = "_ToolTip" ) { ; if not a tooltip
					ctrlHandle := GuiMyStats_Controls[ctrlName]

					ctrlType := IsContaining(ctrlName, "hCB_") ? "CheckBox"
							: IsContaining(ctrlName, "hTEXT_") ? "Text"
							: IsContaining(ctrlName, "hBTN_") ? "Button"
							: IsContaining(ctrlName, "hDDL_") ? "DropDownList"
							: IsContaining(ctrlName, "hEDIT_") ? "Edit"
							: IsContaining(ctrlName, "hGB_") ? "GroupBox"
							: IsContaining(ctrlName, "hLV_") ? "ListView"
							: "Text"

					if !IsIn(ctrlName, noResizeCtrls) { ; Readjust size to fit translation
						txtSize := Get_TextCtrlSize(txt:=ctrlTranslation, fontName:=GuiMyStats.Font, fontSize:=GuiMyStats.Font_Size, maxWidth:="", params:="", ctrlType)
						txtPos := Get_ControlCoords("MyStats", ctrlHandle)

						if (IsIn(ctrlName, noSmallerCtrls) && (txtSize.W > txtPos.W))
						|| !IsIn(ctrlName, noSmallerCtrls)
							GuiControl, MyStats:Move,% ctrlHandle,% "w" txtSize.W
					}

					if (ctrlHandle) { ; set translation
						if (ctrlType = "DropDownList")
							ddlValue := GUI_MyStats.Submit(ctrlName), ctrlTranslation := "|" ctrlTranslation

						if (ctrlTranslation != "") { ; selected trans
							if (ctrlType = "ListView") {
								GUI_MyStats.SetDefaultListView(ctrlName)
								Loop, Parse, ctrlTranslation, |
									LV_ModifyCol(A_Index, Options, A_LoopField)
							}
							GuiControl, MyStats:,% ctrlHandle,% ctrlTranslation
						}

						if (ctrlType = "DropDownList")
							GuiControl, MyStats:Choose,% ctrlHandle,% ddlValue
					}

					if IsIn(ctrlName, needsCenterCtrls) {
						GuiControl, MyStats:-Center,% ctrlHandle
						GuiControl, MyStats:+Center,% ctrlHandle
					}

				}
			}
			
			GuiControl, MyStats:,% GuiMyStats_Controls["hBTN_CloseGUI"],% "X"
			ImageButton.Create(GuiMyStats_Controls["hBTN_CloseGUI"], GuiMyStats.Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)						
		}

		GUI_MyStats.Redraw()
	}

	DestroyBtnImgList() {
		global GuiMyStats_Controls

		for key, value in GuiMyStats_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Destroy() {
		GUI_MyStats.DestroyBtnImgList()
		Gui.Destroy("MyStats")
	}

	SetDefaultListView(lvName) {
        global GuiMyStats_Controls
        Gui, MyStats:Default
        Gui, MyStats:ListView,% GuiMyStats_Controls[lvName]
    }

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiMyStats, GuiMyStats_Controls

		if (CtrlHwnd = GuiMyStats_Controls.hLV_Stats) {
			GUI_MyStats.SetDefaultListView("hLV_Stats")

            rowID := LV_GetNext(0, "F")
            if (rowID = 0) {
                rowID := LV_GetCount()
            }
            LV_GetText(tradeNum, rowID, 1)
            LV_Modify(rowID, "+Select")

			GuiMyStats.SelectedRow := rowID
            
            try Menu,RClickMenu,DeleteAll
            Menu, RClickMenu, Add,% PROGRAM.TRANSLATIONS.GUI_MyStats.RMENU_RemoveThisEntry, Gui_MyStats_RClickMenu_RemoveSelectedEntry
            Menu, RClickMenu, Show
		}
		return
		
		Gui_MyStats_RClickMenu_RemoveSelectedEntry:
			GUI_MyStats.RemoveSelectedEntry()
		return
	}


	Submit(CtrlName="") {
		global GuiMyStats_Submit, GuiMyStats_Controls
		Gui.Submit("MyStats")

		if (CtrlName) {
			Return GuiMyStats_Submit[ctrlName]
		}
	}
	
    Resize() {
        global GuiMyStats, GuiMyStats_Controls

        ; Borders
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_Borders,% "x0 y0 w" A_GuiWidth " h" A_GuiHeight
        ; Title
        coords := Get_ControlCoords("MyStats", GuiMyStats_Controls.hPROGRESS_TitleBackground)
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hPROGRESS_TitleBackground,% " h26 w" A_GuiWidth-30 " "
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_HeaderGhost,% "w" A_GuiWidth-30
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_TitleText,% "w" A_GuiWidth-30
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hBTN_CloseGUI,% "x" A_GuiWidth-31 " "
        ; Filter + List
        coords := Get_ControlCoords("MyStats", GuiMyStats_Controls.hLV_Stats)
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hLV_Stats,% "w" A_GuiWidth-20 " h" A_GuiHeight-(coords.Y+10)
    	GuiControl, MyStats:Move,% GuiMyStats_Controls.hGB_FilteringOptions,% "w" A_GuiWidth-20

		GUI_MyStats.Redraw()
		; GuiControl, MyStats:+Redraw,% GuiMyStats_Controls.hTEXT_Borders
    }

    DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

    Show() {
		global PROGRAM, GuiMyStats

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiMyStats.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			GUI_MyStats.UpdateData()
			GUI_MYStats.ApplyFilters()
			GUI_MyStats.SetTranslation(PROGRAM.SETTINGS.GENERAL.Language)
			Gui, MyStats:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_MYStats.Show(): Non existent. Recreating.")
			GUI_MyStats.Create()
			GUI_MyStats.SetTranslation(PROGRAM.SETTINGS.GENERAL.Language)
			Gui, MyStats:Show, xCenter yCenter
		}
	}

    Close() {
		Gui, MyStats:Hide
	}

	Redraw() {
		Gui, MyStats:+LastFound
		WinSet, Redraw
	}
}
