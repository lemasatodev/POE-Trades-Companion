Class GUI_MyStats {

	Create(params="") {
		global PROGRAM, GAME, SKIN
		global GuiMyStats, GuiMyStats_Controls, GuiMyStats_Submit
		static guiCreated
		windowsDPI := Get_WindowsResolutionDPI()
	
		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		; Initialize gui arrays
		GUI_MyStats.Destroy()
		Gui.New("MyStats", "-Caption +Resize -MaximizeBox +MinSize720x480 +LabelGUI_MyStats_ +HwndhGuiMyStats", "POE TC - " PROGRAM.TRANSLATIONS.TrayMenu.Stats)
		GuiMyStats.Is_Created := False
		GuiMyStats.Windows_DPI := windowsDPI

		guiCreated := False
		guiFullHeight := 480, guiFullWidth := 720, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := leftMost+guiWidth
		upMost := borderSize, downMost := upMost+guiHeight
	
		GuiMyStats.Style_Tab := Style_Tab := [ [0, "0x132f44", "", "0x0f8fff"] ; normal
			,  [0, "0x275474"] ; hover
			,  [0, "0x275474"]  ; press
			,  [0, "0x1c4563" ] ] ; default

		GuiMyStats.Style_CloseBtn := Style_CloseBtn := [ [0, "0xe01f1f", "", "White"] ; normal
			, [0, "0xb00c0c"] ; hover
			, [0, "0x8a0a0a"] ] ; press

		GuiMyStats.Style_MinimizeBtn := Style_MinimizeBtn := [ [0, "0x0fa1d7", "", "White"] ; normal
			, [0, "0x0b7aa2"] ; hover
			, [0, "0x096181"] ]  ; press

		GuiMyStats.Style_Button := Style_Button := [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"] ; normal
			, [0, "0x355e73"] ; hover
			, [0, "0x122630"] ] ; press

		; Used for coloring DropDownList controls
		odcObj := GUI_MyStats.CreateODCObj()

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("MyStats", 0, 0)
		Gui.Color("MyStats", "0x1c4563", "0x274554")
		Gui.Font("MyStats", "Segoe UI", "8", "5", "0x80c4ff")
		OD_Colors.SetItemHeight("S" GuiMyStats.Font_Size, GuiMyStats.Font)
		Gui, MyStats:Default ; Required for LV_ cmds

		; *	* Borders
		/*
		Can't use the traditional way of using a PROGRESS control as a border bar because this GUI is resizeable
		When resizing a PROGRESS control, a gray border appears around it
		This messes up with our border as the actual PROGRESS control color is a few pixels away
		Instead, we use a TEXT control with the +0x7 style, which adds a black border around it
		*/
		Gui.Add("MyStats", "Text", "x0 y0 w" guiWidth " h" guiHeight " hwndhTEXT_Borders 0x7 BackgroundTrans")

		; * * Title bar
		Gui.Add("MyStats", "Text", "x" leftMost " y" upMost " w" guiWidth-30-30 " h20 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("MyStats", "Progress", "xp yp wp hp hwndhPROGRESS_TitleBackground Background0b6fcc") ; Title bar background
		Gui.Add("MyStats", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - " PROGRAM.TRANSLATIONS.TrayMenu.Stats) ; Title bar text
		Gui.Add("MyStats", "ImageButton", "x+0 yp w30 hp 0x200 Center hwndhBTN_MinimizeGUI", "-", Style_MinimizeBtn, PROGRAM.FONTS[GuiMyStats.Font], GuiMyStats.Font_Size*1.20)
		Gui.Add("MyStats", "ImageButton", "x+0 yp wp hp hwndhBTN_CloseGUI", "X", Style_CloseBtn, PROGRAM.FONTS[GuiMyStats.Font], GuiMyStats.Font_Size)
		Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hTEXT_HeaderGhost", "DragGui", GuiMyStats.Handle)
		Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hBTN_MinimizeGUI", "Minimize")
		Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hBTN_CloseGUI", "Close")		

		; ** Filters
		Gui.Add("MyStats", "Text", "x" leftMost+5 " y" upMost+25, "Filters:`n   - To be added -")

		; * * Buttons
		; imageBtnLog .= Gui.Add("MyStats", "ImageButton", "x" leftMost+25 " y+10 w" ctrlPos.X+ctrlPos.W-(leftMost+25) " hwndhBTN_ApplyFilters", PROGRAM.TRANSLATIONS.GUI_MyStats.hBTN_ApplyFilters, Style_Button, PROGRAM.FONTS[GuiMyStats.Font], GuiMyStats.Font_Size)
		; Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hBTN_ApplyFilters", "ApplyFilters")

        ; * * Stats list
        Gui.Add("MyStats", "ListView", "x" leftMost+150 " y20 w" guiWidth-leftMost-150 " R17 hwndhLV_Stats", PROGRAM.TRANSLATIONS.GUI_MyStats.hLV_Stats), lvPos := GUI.GetControlPos("MyStats", "hLV_Stats"), Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hLV_Stats", "OnLVClick")
		LV_SetSelColors(GuiMyStats_Controls.hLV_Stats, "0x0b6fcc", "0xFFFFFF")

		Gui.Add("MyStats", "ImageButton", "x" leftMost " y" lvPos.y+lvPos.h-25 " h25 w150 hwndhBTN_ExportAsCSV", PROGRAM.TRANSLATIONS.GUI_MyStats.hBTN_ExportAsCSV, Style_Button, PROGRAM.FONTS[GuiMyStats.Font], GuiMyStats.Font_Size)
		Gui.BindFunctionToControl("GUI_MyStats", "MyStats", "hBTN_ExportAsCSV", "ExportCurrentListAsCSV")

		; * * Stats parse
		GUI_MyStats.UpdateData()
        GUI_MyStats.SetFilter("All", "All")
		GUI_MyStats.SetFilter("League", StrSplit(GAME.CHALLENGE_LEAGUE, ",").1)
		GUI_MyStats.ApplyFilters()

        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (GuiMyStats.ImageButton_Errors) {
			AppendToLogs(GuiMyStats.ImageButton_Errors)
			TrayNotifications.Show("My Stats Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		Gui.OnMessageBind("GUI_MyStats", "MyStats", 0x83, "WM_NCCALCSIZE")
		Gui.OnMessageBind("GUI_MyStats", "MyStats", 0x84, "WM_NCHITTEST")
		Gui.OnMessageBind("GUI_MyStats", "MyStats", 0x86, "WM_NCACTIVATE")
		Gui.OnMessageBind("GUI_MyStats", "MyStats", 0x201, "WM_LBUTTONDOWN")
		Gui.OnMessageBind("GUI_MyStats", "MyStats", 0x202, "WM_LBUTTONUP")

        Gui.Show("MyStats", "h" guiHeight " w" guiWidth-1 " NoActivate Hide")
		Gui.Show("MyStats", "h" guiHeight " w" guiWidth " NoActivate Hide")

		SetControlDelay(delay), SetBatchLines(batch)
        Return

        Gui_MyStats_Size:
            GUI_MyStats.OnResize()
        Return

		Gui_MyStats_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, MyStats:,% ctrlHwnd

			if (ctrlHwnd = GuiMyStats_Controls.hLV_Stats)
				Gui_MyStats.OnListviewRightClick()
			else 
				Gui_MyStats.ContextMenu(ctrlHwnd, ctrlName)
		Return
    }

	OnFilterCheckboxToggle(ctrlName) {
		global GuiMyStats
		global GuiMyStatsFilter, GuiMyStatsFilter_Controls, GuiMyStatsFilter_Submit
		isEnabled := GUI_MyStats.Submit(ctrlName)
		
		if (isEnabled) {
			fadeOutCode := GUI_MyStats.ShowFadeout()

			myStatsGuiPos := GUI_MyStats.GetPosition()
			Gui.Destroy("MyStatsFilter")
			Gui.New("MyStatsFilter", "-Caption -Border +Toolwindow +Lastfound +AlwaysOnTop +HwndhGuiMyStatsFilter ")
			Gui.Margin("MyStatsFilter", 0, 0)
			Gui.Color("MyStatsFilter", "334a5b", "374a58")
			Gui.Font("MyStatsFilter", "Segoe UI", "8", "5", "0x80c4ff")

			guiFullWidth := 800, guiFullHeight := 600, borderSize := 1, borderColor := "Black"
			guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
			leftMost := borderSize, rightMost := leftMost+guiWidth
			upMost := borderSize, downMost := upMost+guiHeight

			buyers := GuiMyStats.FiltersAll.Buyer
			Loop, Parse, buyers, |
			{
				xpos := A_Index=1?leftMost+5 : xpos, ypos := A_Index=1?upMost+5 : "+15"
				Gui.Add("MyStatsFilter", "Checkbox", "x" xpos " y" ypos, A_LoopField)
			}

			guiX := myStatsGuiPos.X-( (guiFullWidth-myStatsGuiPos.W)/2 ), guiY := myStatsGuiPos.Y-( (guiFullHeight-myStatsGuiPos.H)/2 )
			Gui.Show("MyStatsFilter", "x" guiX " y" guiY " w" guiFullWidth " h" guiFullHeight " NoActivate")

			Sleep 2000

			Gui.Destroy("MyStatsFilter")
			
			GUI_MyStats.HideFadeout(fadeOutCode)
		}
		else {

		}
	}

	DisableSubroutines() {
		controlsList := "hTEXT_HeaderGhost,hBTN_CloseGUI,hLV_Stats,hBTN_ExportAsCSV,hBTN_ApplyFilters"

		Loop, Parse, controlsList,% ","
		{
			GUI.EnableControlFunction("GUI_MyStats", "MyStats", A_LoopField)
		}
	}

	EnableSubroutines() {
		controlsList := "hTEXT_HeaderGhost,hBTN_CloseGUI,hLV_Stats,hBTN_ExportAsCSV,hBTN_ApplyFilters"

		Loop, Parse, controlsList,% ","
		{
			GUI.DisableControlFunction("GUI_Settings", "Settings", A_LoopField)
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

		timeStamp := loopedData.TimeStamp
		FormatTime, timeStamp, %timeStamp%, yyyy-MM-dd HH:mm

		LV_Add("", loopedData.Index, timeStamp, loopedData.Guild, loopedData.Buyer, loopedData.Item
			, loopedData.Price, loopedData.League, loopedData.StashTab)
	}

	RemoveSelectedEntry() {
		; TO_DO_V2 TRADES_SELL_HISTORY_FILE
		global PROGRAM
		global GuiMyStats, GuiMyStats_Controls
		historyFile := PROGRAM.TRADES_SELL_HISTORY_FILE
		historyDataFromFile := JSON_Load(historyFile)

		GUI_MyStats.SetDefaultListView("hLV_Stats")
		selectedRow := GUI_MyStats.GetListviewSelectedRow()
		Loop {
			LV_GetText(c%A_Index%_title, 0, A_Index)
			LV_GetText(c%A_Index%_content, selectedRow, A_Index)
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
			fadeoutCode := GUI_MyStats.ShowFadeout()
			GUI_MyStats.SetDefaultListView("hLV_Stats")
			LV_Delete(selectedRow)

			historyDataFromFile[c1_content].Ignore := "True"
			jsonText := JSON.Dump(historyDataFromFile, "", "`t")
			hFile := FileOpen(historyFile, "w", "UTF-8")
			hFile.Write(jsonText)
			hFile.Close()

			GUI_MyStats.HideFadeout(fadeoutCode)
		}
	}

	GetData() {
		global PROGRAM
		historyFile := PROGRAM.TRADES_SELL_HISTORY_FILE

		historyDataFromFile := JSON_Load(historyFile)
		historyDataForInterface := {}
		for key in historyDataFromFile {
			if !IsNum(key)
				Continue

			historyDataForInterface.Push(ObjFullyClone(historyDataFromFile[key]))
		}

		return historyDataForInterface
	}

	UpdateData() {
		global GuiMyStats, GuiMyStats_Controls
		GUI_MyStats.SetDefaultListView("hLV_Stats")
		delay := SetControlDelay(0), batch := SetBatchLines(-1)

		currentEntriesCount := GuiMyStats.HistoryData.Count() ? GuiMyStats.HistoryData.Count() : 0
		sellHistory := GUI_MyStats.GetData()
		newEntriesCount := sellHistory.Count() ? sellHistory.Count() : 0
		GuiMyStats.HistoryData := "", GuiMyStats.HistoryData := ObjFullyClone(sellHistory)

		GuiControl,% "MyStats:+Count" newEntriesCount,% GuiMyStats_Controls.hLV_Stats
		entriesCountToAdd := newEntriesCount-currentEntriesCount

		if !(entriesCountToAdd)
			return

		loopIndex := currentEntriesCount?currentEntriesCount:1
		Loop % entriesCountToAdd {
			GuiMyStats.HistoryData[loopIndex].Index := loopIndex
			currentLoopedItem := ObjFullyClone(GuiMyStats.HistoryData[loopIndex])

			; if (currentLoopedItem.Ignore = "True")
				; Continue

			for key, value in currentLoopedItem ; Replacing commas to avoid interfering with the IsIn() function
				currentLoopedItem[key] := StrReplace(value, ",", "{COMMA}")
			
			if (currentLoopedItem.Buyer)
				buyersList := !buyersList ? currentLoopedItem.Buyer : !IsIn(currentLoopedItem.Buyer, buyersList) ? buyersList "," currentLoopedItem.Buyer : buyersList
			if (currentLoopedItem.Guild)
				guidsList := !guidsList ? currentLoopedItem.Guild : !IsIn(currentLoopedItem.Guild, guidsList) ? guidsList "," currentLoopedItem.Guild : guidsList
			if (currentLoopedItem.Item)
				itemsList := !itemsList ? currentLoopedItem.Item : !IsIn(currentLoopedItem.Item, itemsList) ? itemsList "," currentLoopedItem.Item : itemsList
			if (currentLoopedItem.ItemCurrency)
				itemsList := !itemsList ? currentLoopedItem.ItemCurrency : !IsIn(currentLoopedItem.ItemCurrency, itemsList) ? itemsList "," currentLoopedItem.ItemCurrency : itemsList
			if (currentLoopedItem.PriceCurrency)
				priceCurrencyList := !priceCurrencyList ? currentLoopedItem.PriceCurrency : !IsIn(currentLoopedItem.PriceCurrency, priceCurrencyList) ? priceCurrencyList "," currentLoopedItem.PriceCurrency : priceCurrencyList
			if (currentLoopedItem.League)
				leaguesList := !leaguesList ? currentLoopedItem.League : !IsIn(currentLoopedItem.League, leaguesList) ? leaguesList "," currentLoopedItem.League : leaguesList
			if (currentLoopedItem.StashTab)
				stashTabsList := !stashTabsList ? currentLoopedItem.StashTab : !IsIn(currentLoopedItem.StashTab, stashTabsList) ? stashTabsList "," currentLoopedItem.StashTab : stashTabsList

			if (A_Index <= currentEntriesCount+entriesCountToAdd)
				loopIndex++
		}

		GuiMyStats.FiltersAll := {}
		buyersList := StrReplace(buyersList, ",", "|"), StrReplace(buyersList, "{COMMA}", ","), Sort(buyersList, "UD|"), GuiMyStats.FiltersAll.Buyer := buyersList
		guidsList := StrReplace(guidsList, ",", "|"), StrReplace(guidsList, "{COMMA}", ","), Sort(guidsList, "UD|"), GuiMyStats.FiltersAll.Guild := guidsList
		itemsList := StrReplace(itemsList, ",", "|"), StrReplace(itemsList, "{COMMA}", ","), Sort(itemsList, "UD|"), GuiMyStats.FiltersAll.ItemName := itemsList
		priceCurrencyList := StrReplace(priceCurrencyList, ",", "|"), StrReplace(priceCurrencyList, "{COMMA}", ","), Sort(priceCurrencyList, "UD|"), GuiMyStats.FiltersAll.PriceCurrency := priceCurrencyList
		leaguesList := StrReplace(leaguesList, ",", "|"), StrReplace(leaguesList, "{COMMA}", ","), Sort(leaguesList, "UD|"), GuiMyStats.FiltersAll.League := leaguesList
		stashTabsList := StrReplace(stashTabsList, ",", "|"), StrReplace(stashTabsList, "{COMMA}", ","), Sort(stashTabsList, "UD|"), GuiMyStats.FiltersAll.StashTab := stashTabsList

		SetControlDelay(delay), SetBatchLines(batch)
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
		delay := SetControlDelay(0), batch := SetBatchLines(-1)

		filters := GUI_MyStats.GetFilter("All"), LV_Delete(), addIndex := 0

		Loop % GuiMyStats.HistoryData.Count() {
			currentLoopedItem := ObjFullyClone(GuiMyStats.HistoryData[A_Index])

			if (currentLoopedItem.Ignore = "True")
				Continue

		; 	if ( (currentLoopedItem.Buyer = filters.Buyer) || (filters.Buyer = "All") )
		; 		&& ( (currentLoopedItem.Item = filters.Item)  || (filters.Item = "All") )
		; 		&& ( (currentLoopedItem.League = filters.League) || (filters.League = "All") )
		; 		&& ( (currentLoopedItem.Guild = filters.Guild) || (filters.Guild = "All") || (filters.Guild = "No guild" && currentLoopedItem.Guild = "") )
		; 		&& ( (currentLoopedItem.PriceCurrency = filters.Currency) || (filters.Currency = "All") )
		; 		&& ( (currentLoopedItem.StashTab = filters.Tab) || (filters.Tab = "All") ) {
					addIndex++
					GUI_MyStats.StatsData_AddRow(addIndex, currentLoopedItem)
		; 		}
		}

		GUI_MyStats.AdjustListviewHeaders()
	}

	ExportCurrentListAsCSV() {
		global PROGRAM, GuiMyStats_Controls
		GUI_MyStats.SetDefaultListView("hLV_Stats")

		; Setting file path
		csvFilePath := PROGRAM.MAIN_FOLDER "\Exported_Stats_" A_Now
		if FileExist(csvFilePath ".csv")
			csvFilePath := csvFilePath "_" RandomStr(5)

		; Saving file as CSV
		csvFilePath := csvFilePath ".csv"
		CSV_LVSave(csvFilePath, GuiMyStats_Controls.hLV_Stats, "`t", OverWrite:=True, "MyStats")

		; Showing tray notification and opening locaion folder
		SplitPath, csvFilePath, csvFileName, csvFileFolder
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.StatsExported_Msg, "%file%", csvFileName)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.StatsExported_Title, trayMsg)
		Run, %csvFileFolder%
	}

	OnListviewRightClick() {
		global PROGRAM

		try Menu, RMenu, DeleteAll
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_MyStats.RMENU_RemoveThisEntry, Gui_MyStats_OnListviewRightClick_RemoveSelectedEntry
		Menu, RMenu, Show
		return		

		Gui_MyStats_OnListviewRightClick_RemoveSelectedEntry:
			GUI_MyStats.RemoveSelectedEntry()
		return
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiMyStats, GuiMyStats_Controls
	}
	
    OnResize() {
        global GuiMyStats, GuiMyStats_Controls
        ; Borders
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_Borders,% "x0 y0 w" A_GuiWidth " h" A_GuiHeight
        ; Title
        headerPos := Get_ControlCoords("MyStats", GuiMyStats_Controls.hPROGRESS_TitleBackground)
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hPROGRESS_TitleBackground,% "w" A_GuiWidth-30-31
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_HeaderGhost,% "w" A_GuiWidth-30
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_TitleText,% "w" A_GuiWidth-30
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hBTN_MinimizeGUI,% "x" A_GuiWidth-30-31 " "
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hBTN_CloseGUI,% "x" A_GuiWidth-31 " "
        ; List
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hLV_Stats,% "w" A_GuiWidth-150-2 " h" A_GuiHeight-headerPos.H-1
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hBTN_ExportAsCSV,% "y" A_GuiHeight-25-1

		GUI_MyStats.Redraw()
		; GuiControl, MyStats:+Redraw,% GuiMyStats_Controls.hTEXT_Borders
    }

    Show() {
		global PROGRAM, GuiMyStats

		hw := DetectHiddenWindows("On")
		foundHwnd := WinExist("ahk_id " GuiMyStats.Handle)
		DetectHiddenWindows(hw)

		if (foundHwnd) {
			GUI_MyStats.UpdateData()
			GUI_MYStats.ApplyFilters()
			Gui, MyStats:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_MYStats.Show(): Non existent. Recreating.")
			GUI_MyStats.Create()
			Gui, MyStats:Show, xCenter yCenter
		}
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	GENERAL FUNCTIONS
	*/

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

	AdjustListviewHeaders() {
		GUI_MyStats.SetDefaultListView("hLV_Stats")
		Loop % LV_GetCount("Col")
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
	}

	SetDefaultListView(lvName) {
        global GuiMyStats_Controls
        Gui, MyStats:Default
        Gui, MyStats:ListView,% GuiMyStats_Controls[lvName]
    }

	GetListviewSelectedRow() {
		GUI_MyStats.SetDefaultListView("hLV_Stats")
		return LV_GetNext(0, "F")
	}

	Submit(CtrlName="") {
		global GuiMyStats_Submit, GuiMyStats_Controls
		Gui.Submit("MyStats")

		if (CtrlName) {
			Return GuiMyStats_Submit[ctrlName]
		}
	}

	DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

	Close() {
		Gui, MyStats:Hide
	}

	Redraw() {
		Gui, MyStats:+LastFound
		WinSet, Redraw
	}

	GetPosition() {
		global GuiMyStats
		hw := DetectHiddenWindows("On")
		WinGetPos, x, y, w, h,% "ahk_id " GuiMyStats.Handle
		DetectHiddenWindows(hw)
		
		return {x:x,y:y,w:w,h:h}
	}

	IsVisible() {
		global GuiMyStats
		hw := DetectHiddenWindows("Off")
		winHwnd := WinExist("ahk_id " GuiMyStats.Handle)
		DetectHiddenWindows(hw)
		return winHwnd
	}

	ShowFadeout() {
		/* 	Puts a black transparency on the GUI to indicate that it's disabled
			Returns a random code that must be given to the HideFadeout() func
			This is to make sure that, in case multiple functions called ShowFadeout(), only the very first one is able to call HideFadeout()
		*/
		global GuiMyStats

		if !IsObject(GuiMyStats.Fadeout)
			GuiMyStats.Fadeout := {}

		if (GUI_MyStats.IsVisible() && !GuiMyStats.FadeOut.Handle) {
			Gui, MyStats:+Disabled
			myStatsGuiPos := GUI_MyStats.GetPosition(), fadeOutCode := RandomStr(10)
			Gui.Destroy("MyStatsFadeout")
			Gui.New("MyStatsFadeout", "-Caption -Border +Toolwindow +Lastfound +AlwaysOnTop +HwndhGuiMyStatsFadeout ")
			WinSet, Transparent,% (255/100)*20
			WinSet, ExStyle, +0x20 ; Clickthrough
			Gui.Margin("MyStatsFadeout", 0, 0)
			Gui.Color("MyStatsFadeout", "0x000000")
			Gui.Show("MyStatsFadeout", "x" myStatsGuiPos.X " y" myStatsGuiPos.Y " w" myStatsGuiPos.W " h" myStatsGuiPos.H " NoActivate")

			GuiMyStats.Fadeout.FadeoutCode := fadeOutCode
			return fadeOutCode
		}
	}

	HideFadeout(fadeOutCode) {
		global GuiMyStats

		if (!fadeOutCode) || (fadeOutCode != GuiMyStats.FadeOut.FadeoutCode)
			return

		Gui, MyStats:-Disabled
		Gui.Destroy("MyStatsFadeout")
		WinActivate,% "ahk_id " GuiMyStats.Handle
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	MISC FUNCTIONS
	*/

	CreateODcObj() {
		return odcObj := {T: 0x80c4ff, B: 0x274554}
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	WM FUNCTIONS
	*/

	WM_NCCALCSIZE() {
		; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
		; Sizes the client area to fill the entire window.

		if (A_Gui != "MyStats")
			return
		
		return 0
	}

	WM_NCACTIVATE() {
		; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
		; Prevents a border from being drawn when the window is activated.

		if (A_Gui != "MyStats")
			return

		if (A_Gui)
			return 1
	}

	WM_NCHITTEST(wParam, lParam) {
		; Credits: Lexikos - autohotkey.com/board/topic/23969-resizable-window-border/?p=155480
		; Redefine where the sizing borders are.  This is necessary since
		; returning 0 for WM_NCCALCSIZE effectively gives borders zero size.
		static border_size = 6

		if (A_Gui != "MyStats")
			return		
		
		WinGetPos, gX, gY, gW, gH
		
		x := lParam<<48>>48, y := lParam<<32>>48
		
		hit_left    := x <  gX+border_size
		hit_right   := x >= gX+gW-border_size
		hit_top     := y <  gY+border_size
		hit_bottom  := y >= gY+gH-border_size
		
		if hit_top
		{
			if hit_left
				return 0xD
			else if hit_right
				return 0xE
			else
				return 0xC
		}
		else if hit_bottom
		{
			if hit_left
				return 0x10
			else if hit_right
				return 0x11
			else
				return 0xF
		}
		else if hit_left
			return 0xA
		else if hit_right
			return 0xB
		
		; else let default hit-testing be done
	}
}
