Class GUI_Settings {
	
	Create(whichTab="") {
		global PROGRAM, GAME, SKIN
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit
		global GuiTrades, GuiTrades_Controls
		static guiCreated
		windowsDPI := Get_DpiFactor()
	
		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		; Initialize gui arrays
		GUI_Settings.Destroy()
		Gui.New("Settings", "-Caption -Border +LabelGUI_Settings_ +HwndhGuiSettings", "POE TC - " PROGRAM.TRANSLATIONS.TrayMenu.Settings)
		GuiSettings.Is_Created := False
		GuiSettings.Windows_DPI := windowsDPI

		guiCreated := False
		guiFullHeight := 600, guiFullWidth := 650, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := leftMost+guiWidth
		upMost := borderSize, downMost := upMost+guiHeight

		GuiSettings.Style_Tab := Style_Tab := [ [0, "0x132f44", "", "0x0f8fff"] ; normal
			,  [0, "0x275474"] ; hover
			,  [0, "0x275474"]  ; press
			,  [0, "0x1c4563" ] ] ; default
        
		GuiSettings.Style_CloseBtn := Style_CloseBtn := [ [0, "0xe01f1f", "", "White"] ; normal
			, [0, "0xb00c0c"] ; hover
			, [0, "0x8a0a0a"] ] ; press

		GuiSettings.Style_MinimizeBtn := Style_MinimizeBtn := [ [0, "0x0fa1d7", "", "White"] ; normal
			, [0, "0x0b7aa2"] ; hover
			, [0, "0x096181"] ]  ; press

		GuiSettings.Style_ResetBtn := Style_ResetBtn := [ [0, "0xf9a231", "", "Black"] ; normal
			, [0, "0xffb24d"] ; hover
			, [0, "0xe98707"] ] ; press

		GuiSettings.Style_Button := Style_Button := [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"] ; normal
			, [0, "0x355e73"] ; hover
			, [0, "0x122630"] ] ; press

		global ACTIONS_SECTIONS := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.SECTIONS
			ACTIONS_SECTIONS[key] := value

		global ACTIONS_TEXT_NAME := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.TEXT_NAME
			ACTIONS_TEXT_NAME[key] := value

		global ACTIONS_TIPS := {}
		for key, value in PROGRAM.TRANSLATIONS.ACTIONS.TIPS
			ACTIONS_TIPS[key] := value

		/*	Not required anymore after actions revamp
		global ACTIONS_FORCED_CONTENT := { "":""
			, "SEND_TO_LAST_WHISPER":"@%lwr% "
			, "WRITE_TO_LAST_WHISPER":"@%lwr% "
			, "SEND_TO_LAST_WHISPER_SENT":"@%lws% "
			, "WRITE_TO_LAST_WHISPER_SENT":"@%lws% "
			, "SEND_TO_BUYER":"@%buyer% "
			, "WRITE_TO_BUYER":"@%buyer% "
			, "INVITE_BUYER":"/invite %buyer%"
			, "TRADE_BUYER":"/tradewith %buyer%"
			, "KICK_BUYER":"/kick %buyer%"
			, "KICK_MYSELF":"/kick %myself%"

			, "CMD_AFK":"/afk "
			, "CMD_AUTOREPLY":"/autoreply "
			, "CMD_DND":"/dnd "
			, "CMD_HIDEOUT":"/hideout"
			, "CMD_OOS":"/oos"
			, "CMD_REMAINING":"/remaining"
			, "CMD_WHOIS":"/whois"
			, "":""}
		*/
		global ACTIONS_FORCED_CONTENT := {}

		global ACTIONS_READONLY := "APPLY_ACTIONS_TO_BUY_INTERFACE,APPLY_ACTIONS_TO_SELL_INTERFACE,CLOSE_TAB"
		. ",CLOSE_SIMILAR_TABS,CLOSE_ALL_TABS,COPY_ITEM_INFOS,GO_TO_NEXT_TAB,GO_TO_PREVIOUS_TAB"
		. ",SAVE_TRADE_STATS,FORCE_MAX,FORCE_MIN,TOGGLE_MIN_MAX,SHOW_LEAGUE_SHEETS"
		Loop 2 { ; buy and sell
			whichInterface := A_Index=1 ? "BUY_INTERFACE" : "SELL_INTERFACE"
			Loop 4 { ; four rows
				rowIndex := A_Index
				Loop 10 { ; then buttons max per row
					btnIndex := A_Index
					ACTIONS_READONLY .= "," whichInterface "_CUSTOM_BUTTON_ROW_" rowIndex "_NUM_" btnIndex
				}
			}
		}
		global ACTIONS_EMPTY := ACTIONS_READONLY

		global ACTIONS_WRITE := "WRITE_MSG,WRITE_THEN_GO_BACK"

		global COLORS_TYPES := {}
		for key, value in PROGRAM.TRANSLATIONS.GUI_Settings.COLORS_TYPES
			COLORS_TYPES[key] := value

		global ACTIONS_AVAILABLE := ""
		. "-> " ACTIONS_SECTIONS.Chat_Messages
		. "|" ACTIONS_TEXT_NAME.SEND_MSG
		. "|" ACTIONS_TEXT_NAME.WRITE_MSG
		; . "|" ACTIONS_TEXT_NAME.WRITE_THEN_GO_BACK
		. "| "
		. "|-> " ACTIONS_SECTIONS.TC_Interfaces
		. "|" ACTIONS_TEXT_NAME.GO_TO_NEXT_TAB
		. "|" ACTIONS_TEXT_NAME.GO_TO_PREVIOUS_TAB
		. "|" ACTIONS_TEXT_NAME.CLOSE_TAB
		. "|" ACTIONS_TEXT_NAME.CLOSE_SIMILAR_TABS
		. "|" ACTIONS_TEXT_NAME.CLOSE_ALL_TABS
		. "|" ACTIONS_TEXT_NAME.COPY_ITEM_INFOS
		. "|" ACTIONS_TEXT_NAME.IGNORE_SIMILAR_TRADE
		. "|" ACTIONS_TEXT_NAME.SAVE_TRADE_STATS
		. "| "
		. "|" ACTIONS_TEXT_NAME.FORCE_MAX
		. "|" ACTIONS_TEXT_NAME.FORCE_MIN
		. "|" ACTIONS_TEXT_NAME.TOGGLE_MIN_MAX
		. "|" ACTIONS_TEXT_NAME.SHOW_LEAGUE_SHEETS
		. "| "
		. "|-> " ACTIONS_SECTIONS.AutoHotKey_Commands
		. "|" ACTIONS_TEXT_NAME.SENDINPUT
		. "|" ACTIONS_TEXT_NAME.SENDEVENT
		. "|" ACTIONS_TEXT_NAME.SLEEP

		global ACTIONS_AVAILABLE_HOTKEYS := ACTIONS_AVAILABLE
		split := StrSplit(ACTIONS_AVAILABLE_HOTKEYS,  "|-> " ACTIONS_SECTIONS.TC_Interfaces)
		ACTIONS_AVAILABLE_HOTKEYS := split.1
		. "|-> " ACTIONS_SECTIONS.TC_Interfaces
		. "|" ACTIONS_TEXT_NAME.APPLY_ACTIONS_TO_BUY_INTERFACE
		. "|" ACTIONS_TEXT_NAME.APPLY_ACTIONS_TO_SELL_INTERFACE
		. "| " split.2

		; Used for the OD_Colors class, so we know which number should have different colors
		odcObj := GUI_Settings.CreateODCObj()
		odcObjActions := GUI_Settings.CreateODCObjFromActionsList(ACTIONS_AVAILABLE)
		odcObjActionsHK := GUI_Settings.CreateODCObjFromActionsList(ACTIONS_AVAILABLE_HOTKEYS)
		
		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("Settings", 0, 0)
		Gui.Color("Settings", "0x1c4563", "0x274554")
		Gui.Font("Settings", "Segoe UI", "8", "5", "0x80c4ff")
		OD_Colors.SetItemHeight("S" GuiSettings.Font_Size, GuiSettings.Font)
		Gui, Settings:Default ; Required for LV_ cmds

		Loop, Parse, ACTIONS_AVAILABLE_HOTKEYS, |
		{
			ctrlSize := Get_TextCtrlSize(A_LoopField, GuiSettings.Font, GuiSettings.Font_Size)
			longestActionName := ctrlSize.W > longestActionName ? ctrlSize.W : longestActionName
		}
		GuiSettings.AlternativeActionTypeDDLWidth := longestActionName+25

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("Settings", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Title bar
		Gui.Add("Settings", "Text", "x" leftMost " y" upMost " w" guiWidth-30-30 " h20 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("Settings", "Progress", "xp yp wp hp Background0b6fcc") ; Title bar background
		Gui.Add("Settings", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - " PROGRAM.TRANSLATIONS.TrayMenu.Settings) ; Title bar text
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x+0 yp w30 hp 0x200 Center hwndhBTN_MinimizeGUI", "-", Style_MinimizeBtn, PROGRAM.FONTS["Segoe UI"], 10)
		imageBtnLog .= Gui.Add("Settings", "ImageButton", "x+0 yp wp hp hwndhBTN_CloseGUI", "X", Style_CloseBtn, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hTEXT_HeaderGhost", "DragGui", GuiSettings.Handle)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_MinimizeGUI", "Minimize")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CloseGUI", "Close")

		; * * Tab controls
		allTabs := ["Settings", "Skins", "Buying", "Selling", "Hotkeys", "Updating", "About"]
		for index, tabName in allTabs
			allTabsList .= "|" tabName
		Gui.Add("Settings", "Tab2", "x0 y0 w0 h0 vTab_AllTabs hwndhTab_AllTabs Choose1", allTabsList) ; Make our list of tabs
		Gui, Settings:Tab ; Whatever comes next will be on all tabs

		; * * Tab buttons
		tabWidth := (guiWidth)/(allTabs.Count()), tabHeight := 30
		for index, tabName in allTabs {
			xpos := A_Index=1?leftMost:xpos+tabWidth, ypos := upMost+20
			Gui.Add("Settings", "ImageButton", "x" xpos " y" ypos " w" tabWidth " h" tabHeight " hwndhBTN_Tab" tabName, tabName, Style_Tab, PROGRAM.FONTS["Segoe UI"], 8)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_Tab" tabName, "OnTabBtnClick", tabName)
		}
		leftMost2 := leftMost+10, rightMost2 := rightMost-10, upMost2 := ypos+tabHeight+10, downMost2 := downMost-50-10
		GuiSettings.LeftMost := leftMost, GuiSettings.LeftMost2 := leftMost2, GuiSettings.RightMost := rightMost2, GuiSettings.RightMost2 := rightMost2
		GuiSettings.UpMost := upMost, GuiSettings.UpMost2 := upMost2, GuiSettings.DownMost := downMost, GuiSettings.DownMost := downMost2

		/* * * * * * * * * * *
		*	TAB SETTINGS
		*/
		Gui, Settings:Tab, Settings

		; * * Accounts
		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " Center hwndhTEXT_POEAccountsList", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_POEAccountsList), poeAccTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_POEAccountsList)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" poeAccTxtPos.W-2-25 " hwndhDDL_PoeAccounts +0x0210", "")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_PoeAccounts, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "ImageButton", "x+2 yp w25 hp hwndhBTN_EditPoeAccountsList", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		poeAccDdlPos := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_PoeAccounts)

		; * * Buying selling modes
		Gui.Add("Settings", "Text", "x+20 y" upMost2 " Center hwndhTEXT_BuyingInterfaceMode", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_BuyingInterfaceMode), buyIntefaceTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_BuyingInterfaceMode)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" buyIntefaceTxtPos.W " AltSubmit hwndhDDL_BuyingInterfaceMode +0x0210", "Tabs|Stack|Disabled")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_BuyingInterfaceMode, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB

		Gui.Add("Settings", "Text", "x+20 y" upMost2 " Center hwndhTEXT_SellingInterfaceMode", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_SellingInterfaceMode), sellIntefaceTxtPos := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_SellingInterfaceMode)
		Gui.Add("Settings", "DropDownList", "xp y+3 w" sellIntefaceTxtPos.W " AltSubmit hwndhDDL_SellingInterfaceMode +0x0210", "Tabs|Stack|Disabled")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_SellingInterfaceMode, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		upMost3 := poeAccDdlPos.Y+poeAccDdlPos.H+25
		
		; * * Interface
		Gui.Add("Settings", "CheckBox", "x" leftMost2 " y" upMost3 " hwndhCB_HideInterfaceWhenOutOfGame", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_HideInterfaceWhenOutOfGame)
		Gui.Add("Settings", "CheckBox", "xp y+3 hwndhCB_ShowTabbedTradesCounterButton", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ShowTabbedTradesCounterButton)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_MinimizeInterfaceToTheBottom", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_MinimizeInterfaceToTheBottom)
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_CopyItemInfosOnTabChange", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_CopyItemInfosOnTabChange)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_AutoFocusNewTabs", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoFocusNewTabs)
		/* Disabled - Search ID jsZTTcBTWV in POE Trades Companion.ahk for infos
		Gui.Add("Settings", "CheckBox", "xp y+15 hwndhCB_AutoMinimizeOnAllTabsClosed", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoMinimizeOnAllTabsClosed)
		*/
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_AutoMaximizeOnFirstNewTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AutoMaximizeOnFirstNewTab)
		Gui.Add("Settings", "CheckBox", "xp y+12 hwndhCB_SendTradingWhisperUponCopyWhenHoldingCTRL Center", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_SendTradingWhisperUponCopyWhenHoldingCTRL)
		Gui.Add("Settings", "CheckBox", "xp+8 y+3 hwndhCB_SendWhoisWithTradingWhisperCTRLCopy Center", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_SendWhoisWithTradingWhisperCTRLCopy)

		; * * Map Tab settings
		Gui.Add("Settings", "Checkbox", "xp-8 y+10 hwndhCB_ItemGridHideNormalTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideNormalTab)
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_ItemGridHideQuadTab", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideQuadTab)
		Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_ItemGridHideNormalTabAndQuadTabForMaps", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ItemGridHideNormalTabAndQuadTabForMaps)

		; * * Transparency
		/*	Disabled - Search ID H5auEc7KA0 in POE Trades Companion.ahk for infos
		Gui.Add("Settings", "Checkbox", "xp y+12 Center hwndhCB_AllowClicksToPassThroughWhileInactive", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_AllowClicksToPassThroughWhileInactive)
		*/
		Gui.Add("Settings", "Text", "xp y+20 Center hwndhTEXT_NoTabsTransparency", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_NoTabsTransparency)
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range0-100 hwndhSLIDER_NoTabsTransparency")
		Gui.Add("Settings", "Text", "x" leftMost2 " y+5 Center hwndhTEXT_TabsOpenTransparency", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_TabsOpenTransparency)
		Gui.Add("Settings", "Slider", "x+1 yp w120 AltSubmit ToolTip Range30-100 hwndhSLIDER_TabsOpenTransparency")

		; * * Notifications
		secondColX := 300
		Gui.Add("Settings", "Text", "x300 y" upMost3 " hwndhTEXT_PlaySoundNotificationWhen", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PlaySoundNotificationWhen)
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+10 hwndhCB_TradingWhisperSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_TradingWhisperSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_TradingWhisperSFXPath")
		Gui.Add("Settings", "ImageButton", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseTradingWhisperSFX", "O", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+6 hwndhCB_RegularWhisperSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_RegularWhisperSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_RegularWhisperSFXPath")
		Gui.Add("Settings", "ImageButton", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseRegularWhisperSFX", "O", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+6 hwndhCB_BuyerJoinedAreaSFXToggle", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_BuyerJoinedAreaSFXToggle)
		Gui.Add("Settings", "Edit", "x+5 yp-4 w100 R1 ReadOnly hwndhEDIT_BuyerJoinedAreaSFXPath")
		Gui.Add("Settings", "ImageButton", "x+2 yp w25 hp ReadOnly hwndhBTN_BrowseBuyerJoinedAreaSFX", "O", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "CheckBox", "x" secondColX " y+6 hwndhCB_ShowTabbedTrayNotificationOnWhisper Center", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_ShowTabbedTrayNotificationOnWhisper)

		Gui.Add("Settings", "Text", "x" secondColX " y+20 hwndhTEXT_PushBulletNotifications", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PushBulletNotifications)
		Gui.Add("Settings", "Text", "xp+10 y+10 hwndhTEXT_PushBulletToken", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_PushBulletToken)
		Gui.Add("Settings", "Edit", "x+2 yp-3 w180 R1 hwndhEDIT_PushBulletToken")
		Gui.Add("Settings", "CheckBox", "x" secondColX+10 " y+5 hwndhCB_PushBulletOnTradingWhisper", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_PushBulletOnTradingWhisper)
		Gui.Add("Settings", "CheckBox", "xp y+5 hwndhCB_PushBulletOnlyWhenAfk", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_PushBulletOnlyWhenAfk)
		
		; * * Reset
		resetBtnW := Get_TextCtrlSize(PROGRAM.TRANSLATIONS.GUI_Settings.hBTN_ResetToDefaultSettings, "Segoe UI", 8, "", "", ctrlType:="Button").W
		Gui.Add("Settings", "ImageButton", "x" rightMost2-resetBtnW " y" downMost2-30 " h30 hwndhBTN_ResetToDefaultSettings", PROGRAM.TRANSLATIONS.GUI_Settings.hBTN_ResetToDefaultSettings, Style_ResetBtn, PROGRAM.FONTS["Segoe UI"], 8)
		
		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB CUSTOMIZATION SKINS
		*/
		Gui, Settings:Tab, Skins

		; * * Preset
		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w130 Center hwndhTEXT_Preset", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_Preset)
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinPreset")

		; * * Skin base
		Gui.Add("Settings", "Text", "x+10 y" upMost2 " w130 Center hwndhTEXT_SkinBase", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_SkinBase)
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinBase")
		
		; * * Font
		Gui.Add("Settings", "Text", "x+10 y" upMost2 " w130 Center hwndhTEXT_TextFont", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_TextFont)
		Gui.Add("Settings", "ListBox", "xp y+5 wp R5 hwndhLB_SkinFont")

		; * * Options
		Gui.Add("Settings", "Checkbox", "x+5 yp hwndhCB_UseRecommendedFontSettings", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_UseRecommendedFontSettings)
		useFontSettingsCbPos := Get_ControlCoords("Settings", GuiSettings_Controls.hCB_UseRecommendedFontSettings)
		Gui.Add("Settings", "Text", "x" useFontSettingsCbPos.X " y+10 hwndhTEXT_FontSize", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_FontSize)
		Gui.Add("Settings", "Edit", "x+2 yp-3 w50 R1 ReadOnly hwndhEDIT_SkinFontSize")
		Gui.Add("Settings", "UpDown", "Range1-24 hwndhUPDOWN_SkinFontSize")
		Gui.Add("Settings", "Text", "x" useFontSettingsCbPos.X " y+5 hwndhTEXT_FontQuality", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_FontQuality)
		Gui.Add("Settings", "Edit", "x+2 yp-3 w50 R1 ReadOnly hwndhEDIT_SkinFontQuality")
		Gui.Add("Settings", "UpDown", "Range0-5 hwndhUPDOWN_SkinFontQuality")
		Gui.Add("Settings", "Text", "x" useFontSettingsCbPos.X " y+15 hwndhTEXT_ScalingSize", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_ScalingSize)
		Gui.Add("Settings", "Edit", "x+5 yp-3 w55 R1 ReadOnly hwndhEDIT_SkinScalingPercentage")
		Gui.Add("Settings", "UpDown", "Range5-200 hwndhUPDOWN_SkinScalingPercentage")

		; * * Text colors TO_DO_V2 find new way of doing things
		; Gui.Add("Settings", "Text", "x" leftMost2+15 " y+80 hwndhTEXT_TextColor","Text color:")
		; Gui.Add("Settings", "DropDownList", "x+5 yp-3 w140 hwndhDDL_ChangeableFontColorTypes +0x0210")
		; OD_Colors.Attach(GuiSettings_Controls.hDDL_ChangeableFontColorTypes, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		; ddlHeight := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_ChangeableFontColorTypes).H
		; Gui.Add("Settings", "Progress", "x+5 yp w" ddlHeight " h" ddlHeight " BackgroundRed hwndhPROGRESS_ColorSquarePreview")
		; Gui.Add("Settings", "Button", "x+5 yp-1  hwndhBTN_ShowColorPicker R1", "Show Color Picker")

		; * * Preview btn
		Gui.Add("Settings", "ImageButton", "x" rightMost2-215 " y" downMost2-30 " w215 h30 hwndhBTN_RecreateTradesGUI", PROGRAM.TRANSLATIONS.GUI_Settings.hBTN_RecreateTradesGUI, Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		
		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB Customization Selling
		*/
		Gui, Settings:Tab, Selling

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w" rightMost2-leftMost2 " hwndhTEXT_CustomizationSellingInterfaceDisabledText Center Hidden", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_CustomizationSellingInterfaceDisabledText)

		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y" upMost2 " w25 h25 hwndhBTN_CustomizationSellingButtonMinusRow1 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp hwndhBTN_CustomizationSellingButtonPlusRow1 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow2 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow2 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow3 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow3 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationSellingButtonMinusRow4 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationSellingButtonPlusRow4 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w0 h200", "")
		Gui.Add("Settings", "DropDownList", "x" ( (rightMost2-leftMost2) /2)-(80/2)-(150/2) " y+10 w80 hwndhDDL_CustomizationSellingButtonType Choose1 Hidden +0x0210", "Text|Icon")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationSellingButtonType, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Edit", "x+3 yp w150 R1 hwndhEDIT_CustomizationSellingButtonName Hidden", "Button Name")
		Gui.Add("Settings", "DropDownList", "xp yp wp hwndhDDL_CustomizationSellingButtonIcon Choose1 Hidden +0x0210", "Clipboard|Invite|Kick|Hideout|ThumbsDown|ThumbsUp|Trade|Whisper")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationSellingButtonIcon, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "DropDownList", "x" leftMost2 " y+5 w250 R100 hwndhDDL_CustomizationSellingActionType Choose2 Hidden +0x0210", ACTIONS_AVAILABLE), acTypeDDLPos := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_CustomizationSellingActionType)
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationSellingActionType, odcObjActions) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Edit", "x+3 yp w" rightMost2-acTypeDDLPos.X-acTypeDDLPos.W-3 " R1 hwndhEDIT_CustomizationSellingActionContent Hidden")
		Gui.Add("Settings", "Link", "x" leftMost2 " y+5 w" rightMost2-leftMost2 " R3 hwndhTEXT_CustomizationSellingActionTypeTip Hidden")
		Gui.Add("Settings", "ListView", "x" leftMost2 " y+10 w" rightMost2-leftMost2 " R8 hwndhLV_CustomizationSellingActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10 Hidden", "#|Type|Content")
		LV_SetSelColors(GuiSettings_Controls.hLV_CustomizationSellingActionsList, "0x0b6fcc", "0xFFFFFF")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB Customization Buying
		*/
		Gui, Settings:Tab, Buying

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w" rightMost2-leftMost2 " hwndhTEXT_CustomizationBuyingInterfaceDisabledText Center Hidden", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_CustomizationBuyingInterfaceDisabledText)

		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y" upMost2 " w25 h25 hwndhBTN_CustomizationBuyingButtonMinusRow1 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow1 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow2 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow2 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow3 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow3 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x" leftMost2 " y+3 wp hp hwndhBTN_CustomizationBuyingButtonMinusRow4 Hidden", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+2 yp wp hp wp hp hwndhBTN_CustomizationBuyingButtonPlusRow4 Hidden", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w0 h200", "")
		Gui.Add("Settings", "DropDownList", "x" ( (rightMost2-leftMost2) /2)-(80/2)-(150/2) " y+10 w80 hwndhDDL_CustomizationBuyingButtonType Choose1 Hidden +0x0210", "Text|Icon")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationBuyingButtonType, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Edit", "x+3 yp w150 R1 hwndhEDIT_CustomizationBuyingButtonName R1 Hidden", "Button Name")
		Gui.Add("Settings", "DropDownList", "xp yp wp hwndhDDL_CustomizationBuyingButtonIcon Choose1 Hidden +0x0210", "Clipboard|Invite|Kick|Hideout|ThumbsDown|ThumbsUp|Trade|Whisper")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationBuyingButtonIcon, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "DropDownList", "x" leftMost2 " y+5 w250 R100 hwndhDDL_CustomizationBuyingActionType Choose2 Hidden +0x0210", ACTIONS_AVAILABLE), acTypeDDLPos := Get_ControlCoords("Settings", GuiSettings_Controls.hDDL_CustomizationBuyingActionType)
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CustomizationBuyingActionType, odcObjActions) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Edit", "x+3 yp w" rightMost2-acTypeDDLPos.X-acTypeDDLPos.W-3 " R1 hwndhEDIT_CustomizationBuyingActionContent Hidden")
		Gui.Add("Settings", "Link", "x" leftMost2 " y+5 w" rightMost2-leftMost2 " R3 hwndhTEXT_CustomizationBuyingActionTypeTip Hidden")
		Gui.Add("Settings", "ListView", "x" leftMost2 " y+10 w" rightMost2-leftMost2 " R8 hwndhLV_CustomizationBuyingActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10 Hidden", "#|Type|Content")
		LV_SetSelColors(GuiSettings_Controls.hLV_CustomizationBuyingActionsList, "0x0b6fcc", "0xFFFFFF")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB HOTKEYS
		*/
		Gui, Settings:Tab, Hotkeys

		Gui.Add("Settings", "ListBox", "x" leftMost2 " y" upMost2 " w130 h" downMost2-upMost2-25-3 " hwndhLB_HotkeyProfiles AltSubmit"), hkListBoxPos := Get_ControlCoords("Settings", GuiSettings_Controls.hLB_HotkeyProfiles), leftMost3 := hkListBoxPos.X+hkListBoxPos.W+10
		Gui.Add("Settings", "ImageButton", "xp y+3 w" (130/2)-(4/2) " h25 hwndhBTN_HotkeyRemoveSelectedProfile", "-", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "ImageButton", "x+4 yp wp hp hwndhBTN_HotkeyAddNewProfile", "+", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)

		centeredX := rightMost2-leftMost3-160-(160/2)-(15/2)
		Gui.Add("Settings", "Text", "x" centeredX " y" upMost2 " Center hwndhTEXT_HotkeyProfileName", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_HotkeyProfileName)
		Gui.Add("Settings", "Edit", "xp y+3 w160 R1 hwndhEDIT_HotkeyProfileName", ""), editHkProfNamePos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyProfileName)
		Gui.MoveControl("Settings", "hTEXT_HotkeyProfileName", "w" editHkProfNamePos.W)
		
		Gui.Add("Settings", "Text", "x+15 y" upMost2 " Center hwndhTEXT_HotkeyProfileHotkey", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_HotkeyProfileHotkey)
		Gui.Add("Settings", "Edit", "xp y+3 w130 hwndhEDIT_HotkeyProfileHotkey R1 ReadOnly", ""), editHkProfHotkeyPos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HotkeyProfileHotkey)
		Gui.Add("Settings", "ImageButton", "x+0 yp w30 hp hwndhBTN_EditHotkey", "O", Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.MoveControl("Settings", "hTEXT_HotkeyProfileHotkey", "w" editHkProfHotkeyPos.W)

		availableWidth := rightMost2-leftMost3
		Gui.Add("Settings", "Text", "x" leftMost3 " y+25 w" availableWidth " Center hwndhTEXT_Actions", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_Actions)
		Gui.Add("Settings", "DropDownList", "x" leftMost3 " y+5 w" availableWidth*0.45 " R100 hwndhDDL_HotkeyActionType Choose2 +0x0210", ACTIONS_AVAILABLE_HOTKEYS)
		OD_Colors.Attach(GuiSettings_Controls.hDDL_HotkeyActionType, odcObjActions) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Edit", "x+3 yp w" availableWidth*0.55-3 " R1 hwndhEDIT_HotkeyActionContent")
		Gui.Add("Settings", "Link", "x" leftMost3 " y+5 w" availableWidth " R3 hwndhTEXT_HotkeyActionTypeTip")
		Gui.Add("Settings", "ListView", "x" leftMost3 " y+10 w" availableWidth " R8 hwndhLV_HotkeyActionsList -Multi AltSubmit +LV0x10000 NoSortHdr NoSort -LV0x10", "#|Type|Content")
		LV_SetSelColors(GuiSettings_Controls.hLV_HotkeyActionsList, "0x0b6fcc", "0xFFFFFF")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC UPDATING
		*/
		Gui, Settings:Tab, Updating

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " hwndhTEXT_YourVersion", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_YourVersion)
		Gui.Add("Settings", "Text", "x+30 yp BackgroundTrans hwndhTEXT_ProgramVer")
		yourVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_YourVersion)
		programVerCoords := Get_ControlCoords("Settings", GuiSettings_Controls.hTEXT_ProgramVer)

		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+10 hwndhTEXT_LatestStable", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_LatestStable)
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestStableVer")
		Gui.Add("Settings", "Text", "x" yourVerCoords.X " y+5 hwndhTEXT_LatestBETA", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_LatestBETA)
		Gui.Add("Settings", "Text", "x" programVerCoords.X " yp BackgroundTrans hwndhTEXT_LatestBetaVer")
		Gui.Add("Settings", "ImageButton", "x" yourVerCoords.X " y+10 h25 hwndhBTN_CheckForUpdates", PROGRAM.TRANSLATIONS.GUI_Settings.hBTN_CheckForUpdates, Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.Add("Settings", "Text", "x+5 yp+7 hwndhTEXT_MinsAgo", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_MinsAgo)

		; Gui.Add("Settings", "Checkbox", "x400 y" upMost2+20 " hwndhCB_AllowToUpdateAutomaticallyOnStart", "Allow to update automatically on start?")
		; Gui.Add("Settings", "Checkbox", "xp y+5 hwndhCB_AllowPeriodicUpdateCheck", "Allow automatic update check every 2hours?")
		Gui.Add("Settings", "Text", "x350 y" upMost2+10 " hwndhTEXT_CheckForUpdatesWhen", PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_CheckForUpdatesWhen)
		Gui.Add("Settings", "DropDownList", "x+5 yp-2 w155 hwndhDDL_CheckForUpdate AltSubmit +0x0210", "Only on application start|On start + every 5 hours|On start + every day")
		OD_Colors.Attach(GuiSettings_Controls.hDDL_CheckForUpdate, odcObj) ; Requires +0x0210 for DDL and +0x0050 for LB
		Gui.Add("Settings", "Checkbox", "x350 y+10 hwndhCB_UseBeta", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_UseBeta)
		Gui.Add("Settings", "Checkbox", "x+5 yp hwndhCB_DownloadUpdatesAutomatically", PROGRAM.TRANSLATIONS.GUI_Settings.hCB_DownloadUpdatesAutomatically)
		
		Gui.Add("Settings", "Edit", "x" leftMost2 " y" upMost2+125 " w" rightMost2-leftMost2 " R10 hwndhEDIT_ChangeLogs ReadOnly", Get_Changelog(removeTrails:=True) ), chgLogEditPos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_ChangeLogs)
		Gui.MoveControl("Settings", "hEDIT_ChangeLogs", "h" downMost2-chgLogEditPos.Y)

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB MISC ABOUT
		*/
		Gui, Settings:Tab, About

		Gui.Add("Settings", "Text", "x" leftMost2 " y" upMost2 " w" rightMost2-leftMost2 " Center BackgroundTrans hwndhTEXT_About" , PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_About)

		Gui.Add("Settings", "Edit", "x" leftMost2 " y+15 wp R10 ReadOnly Center hwndhEDIT_HallOfFame", "Hall of Fame`nThank you for your support!`n`n[Hall of Fame loading]"), hofPos := Get_ControlCoords("Settings", GuiSettings_Controls.hEDIT_HallOfFame)
		Gui.MoveControl("Settings", "hEDIT_HallOfFame", "h" downMost2-hofPos.Y)

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	TAB - ALL
		*/
		Gui, Settings:Tab

		Gui.New("SettingsFooter", "-Caption -Border +ToolWindow -SysMenu +AlwaysOnTop +LastFound +E0x08000000 +ParentSettings +HwndhGuiSettingsFooter")
		Gui.Margin("SettingsFooter", 0, 0)
		Gui.Color("SettingsFooter", "0b6fcc")
		guiFooterW := guiWidth, guiFooterH := 50
		guiFooterX := leftMost*windowsDPI, guiFooterY := (downMost-guiFooterH)*windowsDPI

		Gui.Add("SettingsFooter", "Picture", "x5 y20 w35 h24 hwndhIMG_FlagUK BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_uk.png")
		Gui.Add("SettingsFooter", "Picture", "x+3 yp wp hp hwndhIMG_FlagFrance BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_france.png")
		Gui.Add("SettingsFooter", "Picture", "x+3 yp wp hp hwndhIMG_FlagChina BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_china.png")
		Gui.Add("SettingsFooter", "Picture", "x+3 yp wp hp hwndhIMG_FlagTaiwan BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_taiwan.png")
		Gui.Add("SettingsFooter", "Picture", "x+3 yp wp hp hwndhIMG_FlagRussia BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_russia.png")
		Gui.Add("SettingsFooter", "Picture", "x+3 yp wp hp hwndhIMG_FlagPortugal BackgroundTrans", PROGRAM.IMAGES_FOLDER "\flag_portugal.png")

		Gui.Add("SettingsFooter", "Picture", "x" guiFooterW-120 " y5 w115 h40 hwndhIMG_Paypal BackgroundTrans", PROGRAM.IMAGES_FOLDER "\DonatePaypal.png")
		Gui.Add("SettingsFooter", "Picture", "xp-70 yp w40 h40 hwndhIMG_Discord BackgroundTrans", PROGRAM.IMAGES_FOLDER "\Discord.png")
		Gui.Add("SettingsFooter", "Picture", "xp-45 yp w40 h40 hwndhIMG_Reddit BackgroundTrans", PROGRAM.IMAGES_FOLDER "\Reddit.png")
		Gui.Add("SettingsFooter", "Picture", "xp-45 yp w40 h40 hwndhIMG_PoE BackgroundTrans", PROGRAM.IMAGES_FOLDER "\PoE.png")
		Gui.Add("SettingsFooter", "Picture", "xp-45 yp w40 h40 hwndhIMG_GitHub BackgroundTrans", PROGRAM.IMAGES_FOLDER "\GitHub.png")

		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagUK", "OnLanguageChange", "english")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagFrance", "OnLanguageChange", "french")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagChina", "OnLanguageChange", "chinese_simplified")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagTaiwan", "OnLanguageChange", "chinese_traditional")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagRussia", "OnLanguageChange", "russian")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_FlagPortugal", "OnLanguageChange", "portuguese")

		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_Paypal", "OnPictureLinkClick", "Paypal")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_Discord", "OnPictureLinkClick", "Discord")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_Reddit", "OnPictureLinkClick", "Reddit")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_PoE", "OnPictureLinkClick", "PoE")
		Gui.BindFunctionToControl("GUI_Settings", "SettingsFooter", "hIMG_GitHub", "OnPictureLinkClick", "GitHub")

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (GuiSettings.ImageButton_Errors) {
			global GuiErrorLogBuy, GuiErrorLogBuyPreview, GuiErrorLogSellPreview, GuiErrorLogSell

			AppendToLogs(GuiSettings.ImageButton_Errors)
			TrayNotifications.Show("Settings Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		GUI_Settings.TabsSettingsMain_SetUserSettings()
		GUI_Settings.TabCustomizationSkins_SetUserSettings()
		GUI_Settings.TabHotkeys_SetUserSettings()
		GUI_Settings.TabUpdating_SetUserSettings()
		GUI_Settings.TabAbout_UpdateAllOfFame()

		GUI_Settings.TabSettingsMain_SetSubroutines()
		GUI_Settings.TabCustomizationSkins_SetSubroutines()
		GUI_Settings.TabCustomizationBuying_SetSubroutines()
		GUI_Settings.TabCustomizationSelling_SetSubroutines()
		GUI_Settings.TabHotkeys_SetSubroutines()
		GUI_Settings.TabUpdating_SetSubroutines()

		Gui.Show("Settings", "h" guiFullHeight " w" guiFullWidth " NoActivate Hide")
		Gui.Show("SettingsFooter", "x" guiFooterX " y" guiFooterY " w" guiFooterW " h" guiFooterH " NoActivate")

		; Gui.Show("Settings", "h" guiHeight " w" guiWidth " x-" guiWidth+10 " y" 1010-guiHeight " NoActivate " param)
		hw := DetectHiddenWindows("On")
		WinWait,% "ahk_id " GuiSettings.Handle
		DetectHiddenWindows(hw)

		Gui.OnMessageBind("GUI_Settings", "Settings", 0x200, "WM_MOUSEMOVE")
		Gui.OnMessageBind("GUI_Settings", "Settings", 0x201, "WM_LBUTTONDOWN")
		Gui.OnMessageBind("GUI_Settings", "Settings", 0x202, "WM_LBUTTONUP")

		if (whichTab)
			Gui_Settings.OnTabBtnClick(whichTab)

		; Gui_Settings.OnTabBtnClick("Settings Main")
		; Gui_Settings.OnTabBtnClick("Customization Skins")
		; Gui_Settings.OnTabBtnClick("Hotkeys Basic")
		; Gui_Settings.OnTabBtnClick("Hotkeys Advanced")
		; Gui_Settings.OnTabBtnClick("Misc Updating")
		; Gui_Settings.OnTabBtnClick("Misc About")
		; GUI_Settings.TabAbout_UpdateAllOfFame()

		GuiSettings.Is_Created := True
		SetControlDelay(delay), SetBatchLines(batch)
		Return

		GUI_Settings_Close:
		Return

		GUI_Settings_ContextMenu:
			ctrlHwnd := Get_UnderMouse_CtrlHwnd()
			GuiControlGet, ctrlName, Settings:,% ctrlHwnd

			if (ctrlHwnd = GuiSettings_Controls.hLV_CustomizationSellingActionsList)
				GUI_Settings.Customization_Selling_OnListviewRightClick()
			else if (ctrlHwnd = GuiSettings_Controls.hLV_CustomizationBuyingActionsList)
				GUI_Settings.Customization_Buying_OnListviewRightClick()
			else if (ctrlHwnd = GuiSettings_Controls.hLV_HotkeyActionsList)
				GUI_Settings.TabHotkeys_OnListviewRightClick()
			else if (ctrlHwnd = GuiSettings_Controls.hLB_HotkeyProfiles)
				GUI_Settings.TabHotkeys_OnHotkeysProfilesListBoxRightClick()
			else
				GUI_Settings.ContextMenu(ctrlHwnd, ctrlName)
		return
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB SETTINGS MAIN													 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabsSettingsMain_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.SETTINGS_MAIN)

		controlsList := "hDDL_PoeAccounts,hDDL_BuyingInterfaceMode"
			. ",hDDL_SellingInterfaceMode,hCB_HideInterfaceWhenOutOfGame,hCB_ShowTabbedTradesCounterButton,hCB_MinimizeInterfaceToTheBottom,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs,hCB_AutoMinimizeOnAllTabsClosed"
			. ",hCB_AutoMaximizeOnFirstNewTab,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_SendWhoisWithTradingWhisperCTRLCopy,hCB_ItemGridHideNormalTab,hCB_ItemGridHideQuadTab,hCB_ItemGridHideNormalTabAndQuadTabForMaps"
			. ",hCB_AllowClicksToPassThroughWhileInactive,hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency"
			. ",hCB_TradingWhisperSFXToggle,hEDIT_TradingWhisperSFXPath,hCB_RegularWhisperSFXToggle,hEDIT_RegularWhisperSFXPath"
			. ",hCB_BuyerJoinedAreaSFXToggle,hEDIT_BuyerJoinedAreaSFXPath,hBTN_BrowseBuyerJoinedAreaSFX,hCB_ShowTabbedTrayNotificationOnWhisper"
			. ",hEDIT_PushBulletToken,hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnlyWhenAfk"

		Loop, Parse,% controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlType = "hCB") {
				trueFalseVal := thisTabSettings[settingsKey] = "True" ? True : False
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% trueFalseVal
			}
			else if (ctrlName="hDDL_PoeAccounts") {
				Loop % thisTabSettings.PoeAccounts.Count()
					poeAccList .= "|" thisTabSettings.PoeAccounts[A_Index]
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% poeAccList
				GuiControl, Settings:ChooseString,% GuiSettings_Controls[ctrlName],% thisTabSettings.PoeAccounts.1
				odcObj := GUI_Settings.CreateODCObj()
				OD_Colors.Attach(GuiSettings_Controls[ctrlName], odcObj)
			}
			else if IsIn(ctrlName, "hDDL_BuyingInterfaceMode,hDDL_SellingInterfaceMode") {
				settingValue := ctrlName="hDDL_BuyingInterfaceMode" ? PROGRAM.SETTINGS.BUY_INTERFACE.Mode : PROGRAM.SETTINGS.SELL_INTERFACE.Mode
				chooseNum := settingValue="Tabs"?1 : settingValue="Stack"?2 : settingValue="Disabled"?3 : 1
				GuiControl, Settings:Choose,% GuiSettings_Controls[ctrlName],% settingValue
			}
			else if (ctrlType = "hDDL") {
				GuiControl, Settings:ChooseString,% GuiSettings_Controls[ctrlName],% thisTabSettings[settingsKey]
			}
			else {
				GuiControl, Settings:,% GuiSettings_Controls[ctrlName],% thisTabSettings[settingsKey]
			}
		}

		if (PROGRAM.SETTINGS.SETTINGS_MAIN.SendTradingWhisperUponCopyWhenHoldingCTRL = "True")
			GuiControl, Settings:Enable,% GuiSettings_Controls.hCB_SendWhoisWithTradingWhisperCTRLCopy
		else
			GuiControl, Settings:Disable,% GuiSettings_Controls.hCB_SendWhoisWithTradingWhisperCTRLCopy
	}

	TabSettingsMain_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hCB_HideInterfaceWhenOutOfGame,hCB_ShowTabbedTradesCounterButton,hCB_MinimizeInterfaceToTheBottom,hCB_CopyItemInfosOnTabChange,hCB_AutoFocusNewTabs,hCB_AutoMinimizeOnAllTabsClosed"
			. ",hCB_AutoMaximizeOnFirstNewTab,hCB_SendTradingWhisperUponCopyWhenHoldingCTRL,hCB_SendWhoisWithTradingWhisperCTRLCopy,hCB_ItemGridHideNormalTab,hCB_ItemGridHideQuadTab,hCB_ItemGridHideNormalTabAndQuadTabForMaps"
			. ",hCB_AllowClicksToPassThroughWhileInactive,hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency"
			. ",hCB_TradingWhisperSFXToggle,hBTN_BrowseTradingWhisperSFX,hCB_RegularWhisperSFXToggle,hBTN_BrowseRegularWhisperSFX"
			. ",hCB_BuyerJoinedAreaSFXToggle,hBTN_BrowseBuyerJoinedAreaSFX,hCB_ShowTabbedTrayNotificationOnWhisper"
			. ",hCB_PushBulletOnTradingWhisper,hCB_PushBulletOnlyWhenAfk"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlType="hCB")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnCheckboxToggle", ctrlName)
			else if IsIn(ctrlName,"hSLIDER_NoTabsTransparency,hSLIDER_TabsOpenTransparency")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnTransparencySliderMove", ctrlName)
			else if IsIn(ctrlName,"hBTN_BrowseTradingWhisperSFX,hBTN_BrowseRegularWhisperSFX,hBTN_BrowseBuyerJoinedAreaSFX")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabSettingsMain_OnSFXBrowse", ctrlName)
		}

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_EditPoeAccountsList", "TabSettingsMain_EditPoeAccountsList")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_BuyingInterfaceMode", "TabSettingsMain_OnBuyingInterfaceModeChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_SellingInterfaceMode", "TabSettingsMain_OnSellingInterfaceModeChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_PushBulletToken", "TabSettingsMain_OnPushBulletTokenChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_ResetToDefaultSettings", "ResetToDefaultSettings")
	}

	TabSettingsMain_OnBuyingInterfaceModeChange() {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls

		currentMode := PROGRAM.SETTINGS.BUY_INTERFACE.Mode
		mode := GUI_Settings.Submit("hDDL_BuyingInterfaceMode")
		mode := mode=1 ? "Tabs" : mode=2 ? "Stack" : mode=3 ? "Disabled" : ""
		if (currentMode=mode)
			return

		fadeOutCode := GUI_Settings.ShowFadeout()
		PROGRAM.SETTINGS.BUY_INTERFACE.Mode := mode
		Save_LocalSettings()
		GUI_Trades_V2.CreatePreview("Buy", mode)
		GUI_Settings.HideFadeout(fadeOutCode)
	}
	
	TabSettingsMain_OnSellingInterfaceModeChange() {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls

		currentMode := PROGRAM.SETTINGS.SELL_INTERFACE.Mode
		mode := GUI_Settings.Submit("hDDL_SellingInterfaceMode")
		mode := mode=1 ? "Tabs" : mode=2 ? "Stack" : mode=3 ? "Disabled" : ""
		if (currentMode=mode)
			return

		fadeOutCode := GUI_Settings.ShowFadeout()
		PROGRAM.SETTINGS.SELL_INTERFACE.Mode := mode
		Save_LocalSettings()
		GUI_Trades_V2.CreatePreview("Sell", mode)
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	TabSettingsMain_OnCheckboxToggle(CtrlName) {	
		global PROGRAM, GuiTrades, GuiSettings_Controls

		settingKey := SubStr(CtrlName, 5)
		cbState := GUI_Settings.Submit(CtrlName), settingValue := cbState=1?"True":"False"
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingKey] := settingValue
		Save_LocalSettings()

		if (CtrlName = "hCB_AllowClicksToPassThroughWhileInactive") {
			if (settingValue = "True") {
				if (GuiTrades.Buy.Tabs_Count = 0)
					GUI_Trades_V2.Enable_ClickThrough("Buy")
				if (GuiTrades.Sell.Tabs_Count = 0)
					GUI_Trades_V2.Enable_ClickThrough("Sell")
				Menu, Tray, Check,% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
			}
			else {
				if (GuiTrades.Buy.Tabs_Count)
					GUI_Trades_V2.Disable_ClickThrough("Buy")
				if (GuiTrades.Sell.Tabs_Count)
					GUI_Trades_V2.Disable_ClickThrough("Sell")
				Menu, Tray, UnCheck,% PROGRAM.TRANSLATIONS.TrayMenu.Clickthrough
			}
		}
		if (CtrlName = "hCB_SendTradingWhisperUponCopyWhenHoldingCTRL") {
			if (settingValue = "True")
				GuiControl, Settings:Enable,% GuiSettings_Controls.hCB_SendWhoisWithTradingWhisperCTRLCopy
			else
				GuiControl, Settings:Disable,% GuiSettings_Controls.hCB_SendWhoisWithTradingWhisperCTRLCopy
		}
	}

	TabSettingsMain_OnPushBulletTokenChange() {
		global PROGRAM
		PROGRAM.SETTINGS.SETTINGS_MAIN.PushBulletToken := GUI_Settings.Submit("hEDIT_PushBulletToken")
		Save_LocalSettings()
	}

	TabSettingsMain_EditPoeAccountsList() {
		global PROGRAM
		global GuiPoeAccounts, GuiPoeAccounts_Controls, GuiPoeAccounts_Submit
		Gui, Settings:+Disabled
		windowsDPI := Get_DpiFactor()

		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		GUI_Settings.GUI_PoeAccounts_Destroy()
		Gui.New("PoeAccounts", "-Caption -Border +AlwaysOnTop +LabelGUI_PoeAccounts_ +HwndhGuiPoeAccounts", "POE TC - Accounts")
		GuiPoeAccounts.Is_Created := False
		GuiPoeAccounts.Windows_DPI := windowsDPI

		guiCreated := False
		guiFullHeight := 210, guiFullWidth := 320, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiFullWidth-borderSize
		upMost := borderSize, downMost := guiFullHeight-borderSize

		GuiPoeAccounts.Style_CloseBtn := Style_CloseBtn := [ [0, "0xe01f1f", "", "White"] ; normal
			, [0, "0xb00c0c"] ; hover
			, [0, "0x8a0a0a"] ] ; press

		GuiPoeAccounts.Style_Button := Style_Button := [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"] ; normal
			, [0, "0x355e73"] ; hover
			, [0, "0x122630"] ] ; press

		Gui.Margin("PoeAccounts", 0, 0)
		Gui.Color("PoeAccounts", "0x1c4563", "0x274554")
		Gui.Font("PoeAccounts", "Segoe UI", "8", "5", "0x80c4ff")

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("PoeAccounts", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Title bar
		Gui.Add("PoeAccounts", "Text", "x" leftMost " y" upMost " w" guiWidth-30 " h20 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("PoeAccounts", "Progress", "xp yp wp hp Background0b6fcc") ; Title bar background
		Gui.Add("PoeAccounts", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - " PROGRAM.TRANSLATIONS.TrayMenu.Settings) ; Title bar text
		imageBtnLog .= Gui.Add("PoeAccounts", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_CloseBtn, PROGRAM.FONTS["Segoe UI"], 8)
		Gui.BindFunctionToControl("GUI_Settings", "PoeAccounts", "hBTN_CloseGUI", "GUI_PoeAccounts_Close")

		; * * TOP TEXT
		Gui.Add("PoeAccounts", "Link", "x" leftMost+10 " y+5 w" guiWidth-20 " Center hwndhTEXT_TopText", PROGRAM.TRANSLATIONS.GUI_Settings.GuiPoeAccounts_TopText), topTextPos := GUI.GetControlPos("PoeAccounts", "hTEXT_TopText")
		firstColX := leftMost+5, firstColY := 130
		Gui.Add("PoeAccounts", "Edit", "x" firstColX " y" firstColY " w" (rightMost-20)/2 " R1 hwndhEDIT_Account1", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.1), acc1Pos := GUI.GetControlPos("PoeAccounts", "hEDIT_Account1")
		Gui.Add("PoeAccounts", "Edit", "xp y+5 wp R1 hwndhEDIT_Account2", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.2)
		Gui.Add("PoeAccounts", "Edit", "xp y+5 wp R1 hwndhEDIT_Account3", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.3)
		secondColX := firstColX+( (rightMost-20)/2 )+10,
		Gui.Add("PoeAccounts", "Edit", "x" secondColX " y" acc1Pos.Y " w" (rightMost-20)/2 " R1 hwndhEDIT_Account4", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.4)
		Gui.Add("PoeAccounts", "Edit", "xp y+5 wp R1 hwndhEDIT_Account5", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.5)
		Gui.Add("PoeAccounts", "Edit", "xp y+5 wp R1 hwndhEDIT_Account6", PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts.6)
		Gui.Show("PoeAccounts", "xCenter yCenter w" guiFullWidth " h" guiFullHeight)
		SetControlDelay(delay), SetBatchLines(batch)
		return
	}

	GUI_PoeAccounts_Close() {
		global PROGRAM, GuiPoeAccounts_Submit, GuiPoeAccounts_Controls
		Gui.Submit("PoeAccounts")
		accountsObj := []
		Loop 6
			if (GuiPoeAccounts_Submit["hEDIT_Account" A_Index])
				accountsObj.Push(GuiPoeAccounts_Submit["hEDIT_Account" A_Index])
		
		PROGRAM.SETTINGS.SETTINGS_MAIN.PoeAccounts := ObjFullyClone(accountsObj)
		Save_LocalSettings()
		GUI_Settings.TabsSettingsMain_SetUserSettings()

		for key, value in GuiPoeAccounts_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
		Gui.Destroy("PoeAccounts")

		Gui, Settings:-Disabled
		GUI_Settings.Show(GUI_Settings.GetSelectedTab())
	}

	TabSettingsMain_ToggleClickthroughCheckbox() {
		global PROGRAM, GuiSettings_Controls

		cbState := GUI_Settings.Submit("hCB_AllowClicksToPassThroughWhileInactive")
		GuiControl, Settings:,% GuiSettings_Controls["hCB_AllowClicksToPassThroughWhileInactive"],% !cbState
		GUI_Settings.TabSettingsMain_OnCheckboxToggle("hCB_AllowClicksToPassThroughWhileInactive")
	}

	TabSettingsMain_OnSFXBrowse(CtrlName) {
		global PROGRAM, GuiSettings_Controls

		FileSelectFile, soundFile, ,% PROGRAM.SFX_FOLDER,% PROGRAM.NAME " - Select an audio file",Audio (*.wav; *.mp3)
		if (!soundFile || ErrorLevel)
			Return

		EditBoxHwnd := CtrlName="hBTN_BrowseTradingWhisperSFX" ? GuiSettings_Controls.hEDIT_TradingWhisperSFXPath
			: CtrlName = "hBTN_BrowseRegularWhisperSFX" ? GuiSettings_Controls.hEDIT_RegularWhisperSFXPath
			: CtrlName = "hBTN_BrowseBuyerJoinedAreaSFX" ? GuiSettings_Controls.hEDIT_BuyerJoinedAreaSFXPath
			: ""
		GuiControl, %A_Gui%:,% EditBoxHwnd,% soundFile

		settingsKey := StrSplit(CtrlName, "hBTN_Browse").2, settingsKey .= "Path"
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingsKey] := soundFile
		Save_LocalSettings()
	}

	TabSettingsMain_OnTransparencySliderMove(CtrlName) {
		global PROGRAM, GuiTrades,

		sliderValue := GUI_Settings.Submit(CtrlName)
		settingsKey := StrSplit(CtrlName, "hSLIDER_").2
		PROGRAM.SETTINGS.SETTINGS_MAIN[settingsKey] := sliderValue
		Save_LocalSettings()

		GUI_Trades_V2.SetTransparencyPercent("Buy", sliderValue)
		GUI_Trades_V2.SetTransparencyPercent("Sell", sliderValue)

		if IsIn(A_GuiControlEvent,"Normal,4") {
			buyUserTrans := GuiTrades.Buy.Tabs_Count ? PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency : 0
			sellUserTrans := GuiTrades.Sell.Tabs_Count ? PROGRAM.SETTINGS.SETTINGS_MAIN.TabsOpenTransparency : PROGRAM.SETTINGS.SETTINGS_MAIN.NoTabsTransparency

			GUI_Trades_V2.SetTransparencyPercent("Buy", buyUserTrans)
			GUI_Trades_V2.SetTransparencyPercent("Sell", sellUserTrans)
			if (sellUserTrans)
				GUI_Trades_V2.Disable_ClickThrough("Sell")
		}
	}




	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB CUSTOMIZATION SKIN												 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabCustomizationSkins_SetUserSettings() {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		iniSettings := PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS

		availablePresets := GUI_Settings.TabCustomizationSkins_GetAvailablePresets()
		availableSkins := GUI_Settings.TabCustomizationSkins_GetAvailableSkins()
		availableFonts := GUI_Settings.TabCustomizationSkins_GetAvailableFonts()

		GUI_Settings.TabCustomizationSkins_SetAvailablePresets(availablePresets)
		GUI_Settings.TabCustomizationSkins_SetAvailableSkins(availableSkins)
		GUI_Settings.TabCustomizationSkins_SetAvailableFonts(availableFonts)

		GUI_Settings.TabCustomizationSkins_SetPreset(iniSettings.Preset) ; This function will take care of choosing skin/font/etc based on preset
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hEDIT_SkinFontSize,hUPDOWN_SkinFontSize,hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality,hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if IsIn(ctrlName,"hEDIT_SkinFontSize,hUPDOWN_SkinFontSize")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnFontSizeChange")
			if IsIn(ctrlName,"hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnFontQualityChange")
			if IsIn(ctrlName,"hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabCustomizationSkins_OnScalePercentageChange")

			; TabCustomizationsSkins_OnChangeableColorTypeChange
			; TabCustomizationSkins_ShowColorPicker
			; TabCustomizationSkins_RecreateTradesGUI
		}

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLB_SkinPreset", "TabCustomizationSkins_OnPresetChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLB_SkinBase", "TabCustomizationSkins_OnSkinChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLB_SkinFont", "TabCustomizationSkins_OnFontChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hCB_UseRecommendedFontSettings", "TabCustomizationSkins_OnRecommendedFontSettingsToggle")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_RecreateTradesGUI", "TabCustomizationSkins_RecreateTradesGUI")
	}

	TabCustomizationSkins_EnableSubroutines() {
		controlsList := "hLB_SkinPreset,hLB_SkinBase,hLB_SkinFont,hCB_UseRecommendedFontSettings,hEDIT_SkinFontSize"
		. ",hUPDOWN_SkinFontSize,hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality,hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage"

		Loop, Parse, controlsList,% ","
		{
			GUI.EnableControlFunction("GUI_Settings", "Settings", A_LoopField)
		}
	}

	TabCustomizationSkins_DisableSubroutines() {
		controlsList := "hLB_SkinPreset,hLB_SkinBase,hLB_SkinFont,hCB_UseRecommendedFontSettings,hEDIT_SkinFontSize"
		. ",hUPDOWN_SkinFontSize,hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality,hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage"

		Loop, Parse, controlsList,% ","
		{
			GUI.DisableControlFunction("GUI_Settings", "Settings", A_LoopField)
		}
	}



	TabCustomizationSkins_GetSkinDefaultSettings(skinName) {
		global PROGRAM

		skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "FONT",,1)
		skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" skinName "\Settings.ini", "COLORS",,1)

		skinDefSettings := { Skin:skinName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
			,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True, Colors: skinColorSettings }

		Return skinDefSettings
	}

	TabCustomizationSkins_GetPresetSettings(presetName) {
		global PROGRAM

		if (presetName = "Custom") { ; Get settings from user ini
			userCustomSettings := ObjFullyClone(PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom)
			; presetSettings := {	Name: userCustomSettings.Name,	Skin: userCustomSettings.Skin,	Font: userCustomSettings.Font,	FontSize: userCustomSettings.FontSize
				; , FontQuality: userCustomSettings.FontQuality, ScalingPercentage: userCustomSettings.ScalingPercentage, UseRecommendedFontSettings: userCustomSettings.UseRecommendedFontSettings }
			presetSettings := {}
			for iniKey, iniValue in userCustomSettings
				presetSettings[iniKey] := iniValue
		}
		else { ; Get settings from fonts folder ini
			skinFontSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "FONT",,1)
			skinColorSettings := Ini.Get(PROGRAM.SKINS_FOLDER "\" presetName "\Settings.ini", "COLORS",,1)

			presetSettings := { Name:presetName, Skin:presetName, Font:skinFontSettings.Name, FontSize:skinFontSettings.Size
				,FontQuality:skinFontSettings.Quality, ScalingPercentage:100, UseRecommendedFontSettings:True }
			for iniKey, iniValue in skinColorSettings
				presetSettings["Color_" iniKey] := iniValue
		}

		Return presetSettings
	}

	TabCustomizationSkins_GetFontRecommendedSettings(_fontName="") {
		global PROGRAM
		fontName := _fontName

		if (fontName = "")
			fontName := GUI_Settings.Submit("hLB_SkinFont")

		fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", fontName,1)
		fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", fontName,1)
		
		if !IsNum(fontSize)
			fontSize := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Size", "Default",1)
		if !IsNum(fontQuality)
			fontQuality := INI.Get(PROGRAM.FONTS_SETTINGS_FILE, "Quality", "Default",1)

		Return {Size:fontSize,Quality:fontQuality}
	}

	TabCustomizationSkins_GetAvailablePresets() {
		global PROGRAM

		availablePresets := "Custom|"

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availablePresets .= A_LoopFileName "|"
		}
		StringTrimRight, availablePresets, availablePresets, 1

		return availablePresets
	}

	TabCustomizationSkins_GetAvailableSkins() {
		global PROGRAM

		Loop,% PROGRAM.SKINS_FOLDER "\*", 1, 0
		{
			if FileExist(A_LoopFileFullPath "\Assets.ini")
				availableSkins .= A_LoopFileName "|"
		}
		StringTrimRight, availableSkins, availableSkins, 1

		return availableSkins
	}

	TabCustomizationSkins_GetAvailableFonts() {
		global PROGRAM

		for fontTitle, fontHandle in PROGRAM.FONTS {
			if (fontTitle != "TC_Symbols")
				availableFonts .= fontTitle "|"
		}
		StringTrimRight, availableFonts, availableFonts, 1	

		return availableFonts
	}



	TabCustomizationSkins_SetAvailablePresets(presetsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinPreset,% "|" presetsList
	}

	TabCustomizationSkins_SetAvailableSkins(skinsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinBase,% "|" skinsList	
	}

	TabCustomizationSkins_SetAvailableFonts(fontsList) {
		global GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hLB_SkinFont,% "|" fontsList	
	}

	TabCustomizationSkins_SetChangeableFontColorTypes() {
		global GuiSettings_Controls, COLORS_TYPES

		for iniKey, typeName in COLORS_TYPES {
			if (iniKey)
				typesList .= "|" typeName
		}

		GuiControl, Settings:,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes,% typesList
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_ChangeableFontColorTypes, 1
		GUI_Settings.TabCustomizationsSkins_OnChangeableColorTypeChange()
	}

	TabCustomizationsSkins_OnChangeableColorTypeChange() {
		global GuiSettings_Controls, COLORS_TYPES
		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")

		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hLB_SkinPreset"))
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		GuiControl,% "Settings:+Background" presetSettings["Color_" typeShortName],% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
	}

	Get_ColorTypeShortName_From_LongName(longName) {
		global COLORS_TYPES

		for sName, lName in COLORS_TYPES
			if (lName = longName)
				return sName
	}

	Get_ColorTypeLongName_From_ShortName(shortName) {
		global COLORS_TYPES
		return COLORS_TYPES[shortName]
	}

	TabCustomizationSkins_ShowColorPicker() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		colType := GUI_Settings.Submit("hDDL_ChangeableFontColorTypes")
		typeShortName := GUI_Settings.Get_ColorTypeShortName_From_LongName(colType)
		presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(GUI_Settings.Submit("hLB_SkinPreset"))
		
		Colors := []
		for settingType, settingValue in presetSettings {
			if ( SubStr(settingType, 1, 6) = "Color_") && !IsIn(settingValue, colorsList) {
				colorsList := !colorsList?settingValue : colorsList "," settingValue
				Colors.Push(settingValue)
			}
		}

	    MyColor := ChooseColor(presetSettings["Color_" typeShortName], GuiSettings.Handle, , , Colors*)
		GuiControl, Settings:+Background%MyColor%,% GuiSettings_Controls.hPROGRESS_ColorSquarePreview
		if (!ErrorLevel && MyColor != presetSettings["Color_" typeShortName]) {
			GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"
			PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom.COLORS[typeShortName] := MyColor
			GUI_Settings.TabCustomizationSkins_SaveSettings()
			Save_LocalSettings()
		}
	}

	TabCustomizationSkins_SaveDefaultSkinSettings_To_Custom(skinName) {
		global PROGRAM

		if !(skinName)
			skinName := Gui_Settings.Submit(hLB_SkinBase)

		skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(GUI_Settings.Submit("hLB_SkinBase"))
		for key, value in skinDefSettings {
			if InStr(key, "Color_") {
				PROGRAM.SETTINGS.SETTINGS_CUSTOMIZATION_SKINS_Custom.COLORS[key] := skinDefSettings[key]
			}
		}
		Save_LocalSettings()
	}

	TabCustomizationSkins_SaveSettings(saveAsCustom=False) {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls, GuiSettings_Submit

		GUI_Settings.Submit()
		sub := GuiSettings_Submit

		iniSection := (saveAsCustom)?("SETTINGS_CUSTOMIZATION_SKINS_Custom"):("SETTINGS_CUSTOMIZATION_SKINS")
		skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(sub.hLB_SkinBase)

		PROGRAM.SETTINGS[iniSection].Preset := sub.hLB_SkinPreset
		PROGRAM.SETTINGS[iniSection].Skin := sub.hLB_SkinBase
		PROGRAM.SETTINGS[iniSection].Font := sub.hLB_SkinFont
		PROGRAM.SETTINGS[iniSection].ScalingPercentage := IsNum(sub.hEDIT_SkinScalingPercentage) ? sub.hEDIT_SkinScalingPercentage : 100
		PROGRAM.SETTINGS[iniSection].FontSize := IsNum(sub.hEDIT_SkinFontSize) ? sub.hEDIT_SkinFontSize : skinDefSettings.FontSize
		PROGRAM.SETTINGS[iniSection].FontQuality := IsNum(sub.hEDIT_SkinFontQuality) ? sub.hEDIT_SkinFontQuality : skinDefSettings.FontQuality
		PROGRAM.SETTINGS[iniSection].UseRecommendedFontSettings := sub.hCB_UseRecommendedFontSettings=0 ? "False" : "True"

		/*
		if (saveAsCustom) {
			skinDefSettings := Gui_Settings.TabCustomizationSkins_GetSkinDefaultSettings(sub.hLB_SkinBase)
			userSkinSettings := Get_LocalSettings().SETTINGS_CUSTOMIZATION_SKINS_Custom
			for key, value in skinDefSettings {
				if InStr(key, "Color_") {
					presetVal := skinDefSettings[key], userVal := userSkinSettings[key]
					iniValue := IsHex(userVal) && (StrLen(userVal) = 8) ? userVal : presetVal

					PROGRAM.SETTINGS[iniSecttion][key] := iniValue
				}
			}
		}
		*/

		Save_LocalSettings()

		if (saveAsCustom=True)
			Return
		else if (sub.hLB_SkinPreset = "Custom")
			GUI_Settings.TabCustomizationSkins_SaveSettings(True)
	}

	TabCustomizationSkins_SetPreset(presetName="", presetSettings="") {
		global GuiSettings, GuiSettings_Controls

		; Prevent user from switching preset while we apply current settings
		fadeOutCode := GUI_Settings.ShowFadeout()
		GuiSettings.Is_Changing_Preset := True
		GUI_Settings.TabCustomizationSkins_DisableSubroutines()
		GuiControl, Settings:Disable,% GuiSettings_Controls.hLB_SkinPreset

		; If no preset name specified, get current preset selected instead
		if (presetName = "")
			presetName := GUI_Settings.Submit("hLB_SkinPreset")

		; If no settings specified, get preset's settings
		if !IsObject(presetSettings) {
			presetSettings := GUI_Settings.TabCustomizationSkins_GetPresetSettings(presetName)
			for key, element in currentPresetSettings {
				if (presetSettings[key] = "")
					presetSettings[key] := element
			}
		}

		; Choose the preset and apply its settings
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% presetName
		GUI_Settings.TabCustomizationSkins_SetSkin(presetSettings.Skin)
		GUI_Settings.TabCustomizationSkins_SetFont(presetSettings.Font)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(presetSettings.FontSize, presetSettings.FontQuality)
		GUI_Settings.TabCustomizationSkins_SetScalePercentage(presetSettings.ScalingPercentage)
		GUI_Settings.TabCustomizationSkins_SetRecommendedFontSettings(presetSettings.UseRecommendedFontSettings)
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()

		; Done applying settings
		; Sleep 100 ; Slight sleep to prevent subroutine from detecting IsChangingPreset change
		GUI_Settings.TabCustomizationSkins_EnableSubroutines()
		GuiControl, Settings:Enable,% GuiSettings_Controls["hLB_SkinPreset"]
		GuiControl, Settings:Focus,% GuiSettings_Controls["hLB_SkinPreset"]
		
		; Save newly applied settings
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GuiSettings.Is_Changing_Preset := False
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	TabCustomizationSkins_SetSkin(skinName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinBase,% skinName
	}

	TabCustomizationSkins_SetFont(fontName) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinFont,% fontName
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetFontSizeAndQuality(fontSize, fontQual) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontSize,% fontSize
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinFontQuality,% fontQual
	}

	TabCustomizationSkins_SetRecommendedFontSettings(checkState) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		checkState := checkState=1 || checkState="True" ? 1 : checkState=0 || checkState="False" ? 0 : 1
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseRecommendedFontSettings,% checkState
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))
	}

	TabCustomizationSkins_SetScalePercentage(scalePercentage) {
		global PROGRAM, GuiSettings, GuiSettings_Controls
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_SkinScalingPercentage,% scalePercentage
	}

	TabCustomizationSkins_SetFontSettingsState(state) {
		global PROGRAM, GuiSettings_Controls 

		enableOrDisable := (state=1 || state = "Disable")?("Disable")
		: (state=0 || state = "Enable")?("Enable")
		: ("")

		if (state = "") {
			MsgBox(4096, "", "Invalid usage of " A_ThisFunc "`nParam: " state "`nenableOrDisable: " enableOrDisable)
			Return
		}

		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hEDIT_SkinFontQuality
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontSize
		GuiControl, Settings:%enableOrDisable%,% GuiSettings_Controls.hUPDOWN_SkinFontQuality

		if (state = "Disable") {
			selectedFont := GUI_Settings.Submit("hLB_SkinFont")
			fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
			GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(selectedFont.Size, selectedFont.Quality)
		}
	}

	TabCustomizationSkins_RecreateTradesGUI() {
		global PROGRAM

		fadeOutCode := GUI_Settings.ShowFadeout()
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.RecreatingTradesWindow_Title, PROGRAM.TRANSLATIONS.TrayNotifications.RecreatingTradesWindow_Msg)
		UpdateHotkeys()
		Declare_SkinAssetsAndSettings()
		; Gui_TradesMinimized.Create()
		GUI_Trades_V2.RecreateGUI("Buy")
		GUI_Trades_V2.RecreateGUI("Sell")
		GUI_Trades_V2.CreatePreview("Sell", PROGRAM.SETTINGS.SELL_INTERFACE.Mode)
		GUI_Trades_V2.CreatePreview("Buy", PROGRAM.SETTINGS.BUY_INTERFACE.Mode)
		Sleep 500
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	TabCustomizationSkins_OnFontChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedFont := GUI_Settings.Submit("hLB_SkinFont")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"

		fontSettings := GUI_Settings.TabCustomizationSkins_GetFontRecommendedSettings(selectedFont)
		GUI_Settings.TabCustomizationSkins_SetFontSizeAndQuality(fontSettings.Size, fontSettings.Quality)
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnSkinChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"

		GUI_Settings.TabCustomizationSkins_SaveDefaultSkinSettings_To_Custom(GUI_Settings.Submit("hLB_SkinBase"))
		GUI_Settings.TabCustomizationSkins_SaveSettings()
		GUI_Settings.TabCustomizationSkins_SetChangeableFontColorTypes()
	}

	TabCustomizationSkins_OnPresetChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		selectedPreset := GUI_Settings.Submit("hLB_SkinPreset")
		GUI_Settings.TabCustomizationSkins_SetPreset(selectedPreset)
		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnScalePercentageChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		KeyWait, LButton, L
		SetTimer, GUI_Settings_TabCustomizationSkins_OnScalePercentageChange_Sub, -100

		; scalePercent := GUI_Settings.Submit("hEDIT_SkinScalingPercentage")
		; GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"

		; GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontQualityChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; fontQual := GUI_Settings.Submit("hEDIT_SkinFontQuality")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}

	TabCustomizationSkins_OnFontSizeChange() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; fontSize := GUI_Settings.Submit("hEDIT_SkinFontSize")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()

	}

	TabCustomizationSkins_OnRecommendedFontSettingsToggle() {
		global PROGRAM, GuiSettings, GuiSettings_Controls

		if (GuiSettings.Is_Changing_Preset)
			Return

		; cbState := GUI_Settings.Submit("hCB_UseRecommendedFontSettings")
		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"
		GUI_Settings.TabCustomizationSkins_SetFontSettingsState(GUI_Settings.Submit("hCB_UseRecommendedFontSettings"))

		GUI_Settings.TabCustomizationSkins_SaveSettings()
	}


	

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB CUSTOMIZATION BUYING SELLING									 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabCustomizationBuying_SetSubroutines() {
		Loop 4 {
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationBuyingButtonMinusRow" A_Index, "Customization_Buying_RemoveOneButtonFromRow", A_Index, skipCreateStyle:=False)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationBuyingButtonPlusRow" A_Index, "Customization_Buying_AddOneButtonToRow", A_Index, skipCreateStyle:=False, dontActivateButton:=False)
		}
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingButtonType", "Customization_Buying_OnButtonTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationBuyingButtonName", "Customization_Buying_OnButtonNameChange", doAgainAfter100ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingButtonIcon", "Customization_Buying_OnButtonIconChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationBuyingActionType", "Customization_Buying_OnActionTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hTEXT_CustomizationBuyingActionTypeTip", "Universal_OnActionTypeTipLinkClick") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationBuyingActionContent", "Customization_Buying_OnActionContentChange", doAgainAfter100ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLV_CustomizationBuyingActionsList", "Customization_Buying_OnListviewClick") 
	}

	TabCustomizationSelling_SetSubroutines() {
		Loop 4 {
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationSellingButtonMinusRow" A_Index, "Customization_Selling_RemoveOneButtonFromRow", A_Index, skipCreateStyle:=False)
			Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CustomizationSellingButtonPlusRow" A_Index, "Customization_Selling_AddOneButtonToRow", A_Index, skipCreateStyle:=False, dontActivateButton:=False)
		}
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingButtonType", "Customization_Selling_OnButtonTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationSellingButtonName", "Customization_Selling_OnButtonNameChange", doAgainAfter100ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingButtonIcon", "Customization_Selling_OnButtonIconChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CustomizationSellingActionType", "Customization_Selling_OnActionTypeChange") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hTEXT_CustomizationSellingActionTypeTip", "Universal_OnActionTypeTipLinkClick") 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_CustomizationSellingActionContent", "Customization_Selling_OnActionContentChange", doAgainAfter100ms:=True) 
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLV_CustomizationSellingActionsList", "Customization_Selling_OnListviewClick") 
	}

	Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle=False, dontActivateButton=False) {
		global PROGRAM, GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"] := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]?GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]:0
		btnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiName := "Trades" _buyOrSell "_Slot1"
		guiSkin := GuiTrades[_buyOrSell].Skin

		if (rowNum=1 && btnsCount=5)
		|| (IsBetween(rowNum, 2, 4) && btnsCount=10)
			return

		fadeOutCode := GUI_Settings.ShowFadeout()

		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]++
		newBtnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count := newBtnsCount
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()

		if (!btnsCount) {
			; Hiding the row button
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowNum]
			; Defaulting to show 1 buttons
			GuiSettings.CUSTOM_BUTTON_SELECTED_NUM := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM?GuiSettings.CUSTOM_BUTTON_SELECTED_NUM:1
		}

		Loop % btnsCount ; Hiding previous buttons
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" A_Index]
		Loop % newBtnsCount { ; Showing new ones
			btnNum := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" newBtnsCount "Num" btnNum]
			btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
			btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
			styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" newBtnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"
			if !IsObject(GuiTrades.AllStyles[guiSkin][styleName]) && (skipCreateStyle=False) {
				style%styleName%DidntExist := True
				GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, btnIcon?"Icon":"Text", GuiTrades.AllStyles[guiSkin], styleName, btnIcon?btnIcon:btnName)
			}
			if (style%styleName%DidntExist && btnIcon)
				Gui.ImageButtonUpdate(btnHwnd, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			else if (style%styleName%DidntExist && btnName)
				Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			else if (style%styleName%DidntExist && !btnIcon && !btnName) {
				Gui.ImageButtonChangeCaption(btnHwnd, btnNum, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
					PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
				PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text := btnNum
				Save_LocalSettings()
			}
				
			GuiControl, %guiName%:Show,% btnHwnd
		}

		; Make sure new button is chosen
		if IsNum(rowNum) && IsNum(newBtnsCount) && (dontActivateButton=False)
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)

		GUI_Settings.HideFadeout(fadeOutCode)
	}
	
	Customization_SellingBuying_RemoveOneButtonFromRow(whichTab, rowNum, skipCreateStyle=False) {
		global PROGRAM, GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"] := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]?GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]:0
		btnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiName := "Trades" _buyOrSell "_Slot1"
		guiSkin := GuiTrades[_buyOrSell].Skin
		
		if (!btnsCount)
			return

		fadeOutCode := GUI_Settings.ShowFadeout()

		GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]--
		newBtnsCount := GuiTrades[_buyOrSell]["PreviewRow" rowNum "_Count"]
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count := newBtnsCount
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()

		Loop % btnsCount ; Hiding previous buttons, skipCreateStyle=False
			GuiControl, %guiName%:Hide,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnsCount "Num" A_Index]

		if (btnsCount=1) ; Show the row button bcs no buttons left
			GuiControl, %guiName%:Show,% GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowNum]
		else { ; Show new buttons
			Loop % newBtnsCount {
				btnNum := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" newBtnsCount "Num" btnNum]
				btnName := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text
				btnIcon := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" newBtnsCount, styleName .= btnIcon ? "_Icon_" btnIcon : "_Text"

				if !IsObject(GuiTrades.AllStyles[guiSkin][styleName]) && (skipCreateStyle=False) {
					style%styleName%DidntExist := True
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, btnIcon?"Icon":"Text", GuiTrades.AllStyles[guiSkin], styleName, btnIcon?btnIcon:btnName)
				}
				if (style%styleName%DidntExist && btnIcon)
					Gui.ImageButtonUpdate(btnHwnd, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				else if (style%styleName%DidntExist && btnName)
					Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
				else if (style%styleName%DidntExist && !btnIcon && !btnName) {
					Gui.ImageButtonChangeCaption(btnHwnd, btnNum, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
					if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
						PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
					PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text := btnNum
					Save_LocalSettings()
				}

				GuiControl, %guiName%:Show,% btnHwnd
			}
		}

		; Make sure new button is chosen
		if (newBtnsCount >= GuiSettings.CUSTOM_BUTTON_SELECTED_NUM) && IsNum(rowNum) && IsNum(newBtnsCount) && (newBtnsCount > 0) { ; We can still choose same one, bcs num still exists
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)
		}
		else ; Choose last button, bcs our button doesn't exist anymore
			if IsNum(rowNum) && IsNum(newBtnsCount) && (newBtnsCount > 0)
				GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, rowNum, newBtnsCount, newBtnsCount)

		GUI_Settings.HideFadeout(fadeOutCode)
	}

	Customization_SellingBuying_SetPreviewPreferences(whichTab) {
		global PROGRAM, GuiTrades, GuiTrades_Controls, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"

		Loop 4 {
			rowNum := A_Index
			buttonsCount := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum].Buttons_Count
			Loop % buttonsCount {
				/*
				; if (A_Index = buttonsCount)
				; GUI_Settings.Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle:=False, dontActivateButton:=True)
				*/
				GUI_Settings.Customization_SellingBuying_AddOneButtonToRow(whichTab, rowNum, skipCreateStyle:=True, dontActivateButton:=True)
			}
		}

		; Try to select the first existing button
		Loop 4 {
			if (PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" A_Index].Buttons_Count) {
				GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, A_Index, PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" A_Index].Buttons_Count, 1)
				hasExistingButtons := True
				Break
			}
		}
		; Select the first row button if failure
		if (!hasExistingButtons)
			GUI_Trades_V2.Preview_CustomizeThisCustomButton(_buyOrSell, 1, 1, 1)
	}

	Customization_SellingBuying_AdjustPreviewControls(whichTab) {
		global GuiTrades, GuiSettings, GuiSettings_Controls
		windowsDPI := GuiSettings.Windows_DPI
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"

		Loop 4 {
			rowIndex := A_Index
			rowPos := ControlGetPos(GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomRowSlot" rowIndex])
			minusBtnPos := ControlGetPos(GuiSettings_Controls["hBTN_Customization" whichTab "ButtonMinusRow" rowIndex])
			plusBtnPos := ControlGetPos(GuiSettings_Controls["hBTN_Customization" whichTab "ButtonPlusRow" rowIndex])
			guiPos := ControlGetPos(GuiTrades[_buyOrSell].Handle)

			if (rowPos.X && minusBtnPos.X) {
				minusX := guiPos.X+guiPos.W+3, plusX := minusX+minusBtnPos.W+3, plusY := minusY := rowPos.Y
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_Customization" whichTab "ButtonMinusRow" rowIndex],% "x" minusX/windowsDPI " y" minusY/windowsDPI
				GuiControl, Settings:Move,% GuiSettings_Controls["hBTN_Customization" whichTab "ButtonPlusRow" rowIndex],% "x" plusX/windowsDPI " y" plusY/windowsDPI
			}
		}

		controlsList := "hBTN_Customization" whichTab "ButtonMinusRow1,hBTN_Customization" whichTab "ButtonPlusRow1,hBTN_Customization" whichTab "ButtonMinusRow2"
		. ",hBTN_Customization" whichTab "ButtonPlusRow2,hBTN_Customization" whichTab "ButtonMinusRow3,hBTN_Customization" whichTab "ButtonPlusRow3"
		. ",hBTN_Customization" whichTab "ButtonMinusRow4,hBTN_Customization" whichTab "ButtonPlusRow4,hDDL_Customization" whichTab "ButtonType"
		. ",hEDIT_Customization" whichTab "ButtonName,hDDL_Customization" whichTab "ButtonIcon,hDDL_Customization" whichTab "ActionType"
		. ",hEDIT_Customization" whichTab "ActionContent,hTEXT_Customization" whichTab "ActionTypeTip,hLV_Customization" whichTab "ActionsList"

		showOrHide := GUI_Trades_V2.Exists(_buyOrSell) ? "Show" : "Hide"
		Loop, Parse, controlsList,% ","
		{
			GuiControl, Settings:%showOrHide%,% GuiSettings_Controls[A_LoopField]
		}
		if GUI_Trades_V2.Exists(_buyOrSell)
			GuiControl, Settings:Hide,% GuiSettings_Controls["hTEXT_Customization" whichTab "InterfaceDisabledText"]
		else
			GuiControl, Settings:Show,% GuiSettings_Controls["hTEXT_Customization" whichTab "InterfaceDisabledText"]
	}

	Customization_SellingBuying_LoadButtonSettings(whichTab, rowNum, btnNum) {
		global PROGRAM, GuiSettings
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		btnSettings := ObjFullyClone(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])

		if (btnSettings.Text) {
			GUI_Settings.Customization_SellingBuying_ShowButtonNameControl(whichTab)
			GUI_Settings.Customization_SellingBuying_SetButtonType(whichTab, "Text", noTrigger:=True)
			GUI_Settings.Customization_SellingBuying_SetButtonName(whichTab, btnSettings.Text, noTrigger:=True)
		}
		else if (btnSettings.Icon) {
			GUI_Settings.Customization_SellingBuying_ShowButtonIconControl(whichTab)
			GUI_Settings.Customization_SellingBuying_SetButtonType(whichTab, "Icon", noTrigger:=True)
			GUI_Settings.Customization_SellingBuying_SetButtonIcon(whichTab, btnSettings.Icon, noTrigger:=True)
		}

		GUI_Settings.Customization_SellingBuying_LoadButtonActions(whichTab, rowNum, btnNum)
	}

	Customization_SellingBuying_LoadButtonActions(whichTab, rowNum, btnNum) {
		return GUI_Settings.Universal_LoadActionsIntoListview(whichTab, rowNum, btnNum)
	}

	Customization_SellingBuying_SaveAllCurrentButtonActions(whichTab, isTimedSave=False) {
		return GUI_Settings.Universal_SaveAllActions(whichTab, isTimedSave)
	}

	Customization_SellingBuying_SetButtonType(whichTab, btnType, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonType"],% btnType
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonTypeChange(whichTab)
	}

	Customization_SellingBuying_ShowButtonNameControl(whichTab) {
		global PROGRAM, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"SELL":"BUY"

		if (PROGRAM.SETTINGS[_buyOrSell "_INTERFACE"].Mode = "Disabled")
			return
		GuiControl, Settings:Show,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
		GuiControl, Settings:Hide,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
	}

	Customization_SellingBuying_ShowButtonIconControl(whichTab) {
		global PROGRAM, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"SELL":"BUY"

		if (PROGRAM.SETTINGS[_buyOrSell "_INTERFACE"].Mode = "Disabled")
			return
		GuiControl, Settings:Show,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
		GuiControl, Settings:Hide,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
	}

	Customization_SellingBuying_OnButtonTypeChange(whichTab) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		ddlHwnd := GuiSettings_Controls["hDDL_Customization" whichTab "ButtonType"]
		ddlContent := GUI_Settings.Submit("hDDL_Customization" whichTab "ButtonType")

		if (ddlContent = "Text") {
			GUI_Settings.Customization_SellingBuying_ShowButtonNameControl(whichTab)
			GUI_Settings.Customization_SellingBuying_OnButtonNameChange(whichTab)
		}
		else if (ddlContent = "Icon") {
			GUI_Settings.Customization_SellingBuying_ShowButtonIconControl(whichTab)
			GUI_Settings.Customization_SellingBuying_OnButtonIconChange(whichTab)
		}
		else {
			MsgBox Something has gone wrong.`nCustomization_SellingBuying_OnButtonTypeChange`n%ddlContent%
		}
	}

	Customization_SellingBuying_SetButtonIcon(whichTab, btnIcon, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		GuiControl, Settings:ChooseString,% GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"],% btnIcon
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonIconChange(whichTab)
	}

	Customization_SellingBuying_OnButtonIconChange(whichTab) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		ddlHwnd := GuiSettings_Controls["hDDL_Customization" whichTab "ButtonIcon"]
		ddlContent := GUI_Settings.Submit("hDDL_Customization" whichTab "ButtonIcon")
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiSkin := GuiTrades[_buyOrSell].Skin

		; Getting activated button variables
		rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
		btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
		btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
		; Couldnt save notification
		if (!rowNum || !btnsCount || !btnNum) {
			; TrayNotifications.Show("", "COULDN'T SAVE BUTTON NAME"
			; . "`nRow: " rowNum
			; . "`nCount: " btnsCount
			; . "`nNum: " btnNum
			; . "`nTab: " whichTab)
			return
		}

		if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Icon := ddlContent
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Delete("Text")
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()

		btnMax := rowNum=1 ? 5 : IsBetween(rowNum, 2, 4) ? 10 : 0
		Loop % btnMax {
			if (btnNum <= A_Index) { ; Otherwise it can't exist, eg: Num3 can't exist if Max2
				btnMax := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnMax "Num" btnNum]
				btnIcon := ddlContent
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnMax, styleName .= "_Icon_" btnIcon
				if !IsObject(GuiTrades.AllStyles[guiSkin][styleName]) 
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, "Icon", GuiTrades.AllStyles[guiSkin], styleName, btnIcon)
				else
					Gui.ImageButtonUpdate(btnHwnd, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			}
		}
	}

	Customization_SellingBuying_OnButtonNameChange(whichTab, doAgainAfter100ms=False) {
		global PROGRAM
		global GuiTrades, GuiSettings, GuiSettings_Controls
		_buyOrSell := whichTab="Selling"?"Sell":"Buy", _buyOrSell .= "Preview"
		editBoxHwnd := GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"]
		editBoxContent := GUI_Settings.Submit("hEDIT_Customization" whichTab "ButtonName")
		guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
		guiSkin := GuiTrades[_buyOrSell].Skin

		; Getting activated button variables
		rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
		btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
		btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
		; Couldnt save notification
		if (!rowNum || !btnsCount || !btnNum) {
			; TrayNotifications.Show("", "COULDN'T SAVE BUTTON NAME"
			; . "`nRow: " rowNum
			; . "`nCount: " btnsCount
			; . "`nNum: " btnNum
			; . "`nTab: " whichTab)
			return
		}

		if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Text := editBoxContent
		PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Delete("Icon")
		Save_LocalSettings()
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()

		btnMax := rowNum=1 ? 5 : IsBetween(rowNum, 2, 4) ? 10 : 0
		Loop % btnMax {
			if (btnNum <= A_Index) { ; Otherwise it can't exist, eg: Num3 can't exist if Max2
				btnMax := A_Index, btnHwnd := GuiTrades[_buyOrSell]["Slot1_Controls"]["hBTN_CustomButtonRow" rowNum "Max" btnMax "Num" btnNum]
				btnName := editBoxContent
				styleName := "CustomButton_" _buyOrSell "_Row" rowNum "Max" btnMax, styleName .= "_Text"
				if !IsObject(GuiTrades.AllStyles[guiSkin][styleName])
					GUI_Trades_V2.CreateGenericStyleAndUpdateButton(btnHwnd, "Text", GuiTrades.AllStyles[guiSkin], styleName, btnName)
				else
					Gui.ImageButtonChangeCaption(btnHwnd, btnName, GuiTrades.AllStyles[guiSkin][styleName], PROGRAM.FONTS[GuiTrades[_buyOrSell].Font], GuiTrades[_buyOrSell].Font_Size)
			}
		}

		if (doAgainAfter100ms=True) {
			if (whichTab="Selling")
				GoSub, GUI_Settings_Customization_Selling_OnButtonNameChange_Timer
			else if (whichTab="Buying")
				GoSub, GUI_Settings_Customization_Buying_OnButtonNameChange_Timer
		}
	}

	Customization_SellingBuying_SetButtonName(whichTab, btnName, dontTriggerOnChange=False) {
		global GuiSettings_Controls
		if (dontTriggerOnChange=True)
			Gui.DisableControlFunction("GUI_Settings", "Settings", "hEDIT_Customization" whichTab "ButtonName")

		GuiControl, Settings:,% GuiSettings_Controls["hEDIT_Customization" whichTab "ButtonName"],% btnName
		
		if (dontTriggerOnChange=False)
			GUI_Settings.Customization_SellingBuying_OnButtonNameChange()
		else
			Gui.EnableControlFunction("GUI_Settings", "Settings", "hEDIT_Customization" whichTab "ButtonName")
	}

	Customization_SellingBuying_CreateHotkeyForThisButton(whichTab, rowNum, btnNum) {
		global PROGRAM
		miscTrans := PROGRAM.TRANSLATIONS.MISC

		_buyOrSell := whichTab="Buying" ? "BUY" : "SELL"
		guiIniSection := _buyOrSell="BUY" ? "BUY_INTERFACE" : "SELL_INTERFACE"
		hotkeyObj := {"Name": _buyOrSell " " miscTrans.Row " " rowNum " " miscTrans.Number " " btnNum, Hotkey: "", "Actions":[{"Type":guiIniSection "_CUSTOM_BUTTON_ROW_" rowNum "_NUM_" btnNum,"Content":""""}]}
		return GUI_Settings.TabHotkeys_AddNewHotkeyProfile(hotkeyObj)
	}

	Customization_SellingBuying_OnActionTypeChange(whichTab) {
		return GUI_Settings.Universal_OnActionTypeChange(whichTab)
	}
	
	Customization_SellingBuying_OnActionContentChange(whichTab, doAgainAfter100ms=False) {
		return GUI_Settings.Universal_OnActionContentChange(whichTab, doAgainAfter100ms)
	}

	Customization_SellingBuying_ListViewModifySelectedAction(whichTab, actionType="", actionContent="") {
		return GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, actionType, actionContent)
	}

	Customization_SellingBuying_OnListviewRightClick(whichTab) {
		return GUI_Settings.Universal_OnListviewRightClick(whichTab)
	}

	Customization_SellingBuying_MoveActionUp(whichTab, rowNum) {
		return GUI_Settings.Universal_MoveActionUp(whichTab, rowNum)
	}

	Customization_SellingBuying_MoveActionDown(whichTab, rowNum) {
		return GUI_Settings.Universal_MoveActionDown(whichTab, rowNum)
	}

	Customization_SellingBuying_GetListviewSelectedRow(whichTab) {
		return GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
	}

	Customization_SellingBuying_RemoveAction(whichTab, actionNum) {
		return GUI_Settings.Universal_RemoveAction(whichTab, actionNum)
	}

	Customization_SellingBuying_GetListViewContent(whichTab) {
		return GUI_Settings.Universal_GetListViewContent(whichTab)
	}

	Customization_SellingBuying_AddNewAction(whichTab, actionType, actionContent) {
		return GUI_Settings.Universal_AddNewAction(whichTab, actionType, actionContent)
	}

	Customization_SellingBuying_AdjustListviewHeaders(whichTab) {
		return GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
	}

	Customization_SellingBuying_OnListviewClick(whichTab, params*) {
		return GUI_Settings.Universal_OnListviewClick(whichTab, params*)
	}

	Customization_SellingBuying_SetActionType(whichTab, actionType) {
		return GUI_Settings.Universal_SetActionType(whichTab, actionType)
	}

	Customization_SellingBuying_SetActionContent(whichTab, actionContent) {
		return GUI_Settings.Universal_SetActionContent(whichTab, actionContent)
	}

	Customization_SellingBuying_SelectListviewRow(whichTab, rowNum) {
		return GUI_Settings.Universal_SelectListViewRow(whichTab, rowNum)
	}

	Customization_Buying_CreateHotkeyForThisButton(params*) {
		return GUI_Settings.Customization_SellingBuying_CreateHotkeyForThisButton("Buying", rowNum, btnNum)
	}
	Customization_Selling_CreateHotkeyForThisButton(params*) {
		return GUI_Settings.Customization_SellingBuying_CreateHotkeyForThisButton("Selling", rowNum, btnNum)
	}
	Customization_Buying_SelectListviewRow(params*) {
		return GUI_Settings.Customization_SellingBuying_SelectListviewRow("Buying", params*)
	}
	Customization_Selling_SelectListviewRow(params*) {
		return GUI_Settings.Customization_SellingBuying_SelectListviewRow("Selling", params*)
	}
	Customization_Selling_SetActionType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionType("Selling", params*)
	}
	Customization_Buying_SetActionType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionType("Buying", params*)
	}
	Customization_Selling_SetActionContent(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionContent("Selling", params*)
	}
	Customization_Buying_SetActionContent(params*) {
		return GUI_Settings.Customization_SellingBuying_SetActionContent("Buying", params*)
	}
	Customization_Selling_OnListviewClick(params*) {
		return GUI_Settings.Customization_SellingBuying_OnListviewClick("Selling", params*)
	}
	Customization_Buying_OnListviewClick(params*) {
		return GUI_Settings.Customization_SellingBuying_OnListviewClick("Buying", params*)
	}
	Customization_Selling_AdjustListviewHeaders() {
		return GUI_Settings.Customization_SellingBuying_AdjustListviewHeaders("Selling")
	}
	Customization_Buying_AdjustListviewHeaders() {
		return GUI_Settings.Customization_SellingBuying_AdjustListviewHeaders("Buying")
	}
	Customization_Selling_AddNewAction(params*) {
		return GUI_Settings.Customization_SellingBuying_AddNewAction("Selling", params*)
	}
	Customization_Buying_AddNewAction(params*) {
		return GUI_Settings.Customization_SellingBuying_AddNewAction("Buying", params*)
	}
	Customization_Selling_GetListViewContent() {
		return GUI_Settings.Customization_SellingBuying_GetListViewContent("Selling")
	}
	Customization_Buying_GetListViewContent() {
		return GUI_Settings.Customization_SellingBuying_GetListViewContent("Buying")
	}
	Customization_Selling_RemoveAction(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveAction("Selling", params*)
	}
	Customization_Buying_RemoveAction(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveAction("Buying", params*)
	}
	Customization_Selling_GetListviewSelectedRow() {
		return GUI_Settings.Customization_SellingBuying_GetListviewSelectedRow("Selling")
	}
	Customization_Buying_GetListviewSelectedRow() {
		return GUI_Settings.Customization_SellingBuying_GetListviewSelectedRow("Buying")
	}
    Customization_Selling_MoveActionDown(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionDown("Selling", params*)
	}
	Customization_Buying_MoveActionDown(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionDown("Buy", params*)
	}
    Customization_Selling_MoveActionUp(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionUp("Selling", params*)
	}
	Customization_Buying_MoveActionUp(params*) {
		return GUI_Settings.Customization_SellingBuying_MoveActionUp("Buying", params*)
	}
    Customization_Selling_OnListviewRightClick() {
		return GUI_Settings.Customization_SellingBuying_OnListviewRightClick("Selling")
	}
	Customization_Buying_OnListviewRightClick() {
		return GUI_Settings.Customization_SellingBuying_OnListviewRightClick("Buying")
	}
    Customization_Selling_ListViewModifySelectedAction(params*) {
		return GUI_Settings.Customization_SellingBuying_ListViewModifySelectedAction("Selling", params*)
	}
	Customization_Buying_ListViewModifySelectedAction(params*) {
		return GUI_Settings.Customization_SellingBuying_ListViewModifySelectedAction("Buying", params*)
	}
    Customization_Selling_OnActionContentChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnActionContentChange("Selling", params*)
	}
	Customization_Buying_OnActionContentChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnActionContentChange("Buying", params*)
	}
    Customization_Selling_OnActionTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnActionTypeChange("Selling")
	}
	Customization_Buying_OnActionTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnActionTypeChange("Buying")
	}
    Customization_Selling_SetButtonName(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonName("Selling", params*)
	}
	Customization_Buying_SetButtonName(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonName("Buying", params*)
	}
    Customization_Selling_OnButtonNameChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnButtonNameChange("Selling", params*)
	}
	Customization_Buying_OnButtonNameChange(params*) {
		return GUI_Settings.Customization_SellingBuying_OnButtonNameChange("Buying", params*)
	}
    Customization_Selling_OnButtonIconChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonIconChange("Selling")
	}
	Customization_Buying_OnButtonIconChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonIconChange("Buying")
	}
    Customization_Selling_SetButtonIcon(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonIcon("Selling", params*)
	}
	Customization_Buying_SetButtonIcon(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonIcon("Buying", params*)
	}
    Customization_Selling_OnButtonTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonTypeChange("Selling")
	}
	Customization_Buying_OnButtonTypeChange() {
		return GUI_Settings.Customization_SellingBuying_OnButtonTypeChange("Buying")
	}
    Customization_Selling_ShowButtonNameControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonNameControl("Selling")
	}
	Customization_Buying_ShowButtonNameControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonNameControl("Buying")
	}
	Customization_Selling_ShowButtonIconControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonIconControl("Selling")
	}
	Customization_Buying_ShowButtonIconControl() {
		return GUI_Settings.Customization_SellingBuying_ShowButtonIconControl("Buying")
	}
    Customization_Selling_SetButtonType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonType("Selling", params*)
	}
	Customization_Buying_SetButtonType(params*) {
		return GUI_Settings.Customization_SellingBuying_SetButtonType("Buying", params*)
	}
    Customization_Selling_SaveAllCurrentButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_SaveAllCurrentButtonActions("Selling", params*)
	}
	Customization_Buying_SaveAllCurrentButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_SaveAllCurrentButtonActions("Buying", params*)
	}
    Customization_Selling_LoadButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonActions("Selling", params*)
	}
	Customization_Buying_LoadButtonActions(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonActions("Buying", params*)
	}
    Customization_Selling_LoadButtonSettings(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonSettings("Selling", params*)
	}
	Customization_Buying_LoadButtonSettings(params*) {
		return GUI_Settings.Customization_SellingBuying_LoadButtonSettings("Buying", params*)
	}
    Customization_Selling_AdjustPreviewControls() {
		return GUI_Settings.Customization_SellingBuying_AdjustPreviewControls("Selling")
	}
	Customization_Buying_AdjustPreviewControls() {
		return GUI_Settings.Customization_SellingBuying_AdjustPreviewControls("Buying")
	}
    Customization_Selling_SetPreviewPreferences(params*) {
		return GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Selling", params*)
	}
	Customization_Buying_SetPreviewPreferences(params*) {
		return GUI_Settings.Customization_SellingBuying_SetPreviewPreferences("Buying", params*)
	}
    Customization_Selling_AddOneButtonToRow(params*) {
		return GUI_Settings.Customization_SellingBuying_AddOneButtonToRow("Selling", params*)
	}
	Customization_Buying_AddOneButtonToRow(params*) {
		return GUI_Settings.Customization_SellingBuying_AddOneButtonToRow("Buying", params*)
	}
	Customization_Selling_RemoveOneButtonFromRow(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveOneButtonFromRow("Selling", params*)
	}
	Customization_Buying_RemoveOneButtonFromRow(params*) {
		return GUI_Settings.Customization_SellingBuying_RemoveOneButtonFromRow("Buying", params*)
	}




	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*										TAB HOTKEYS													 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	TabHotkeys_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLB_HotkeyProfiles", "TabHotkeys_OnHotkeyProfileChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_HotkeyProfileName", "TabHotkeys_OnHotkeyProfileNameChange", doAgainAfter100ms:=True)
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_HotkeyProfileHotkey", "TabHotkeys_OnHotkeyProfileHotkeyChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_HotkeyActionType", "TabHotkeys_OnActionTypeChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hEDIT_HotkeyActionContent", "TabHotkeys_OnActionContentChange")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hLV_HotkeyActionsList", "TabHotkeys_OnListviewClick")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_HotkeyAddNewProfile", "TabHotkeys_AddNewHotkeyProfile")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_HotkeyRemoveSelectedProfile", "TabHotkeys_RemoveSelectedHotkeyProfile")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hTEXT_HotkeyActionTypeTip", "Universal_OnActionTypeTipLinkClick")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_EditHotkey", "TabHotkeys_ChangeHotkeyProfileHotkey")
	}

	TabHotkeys_SetUserSettings() {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls
		controlsList := "hLB_HotkeyProfiles"

		Loop, Parse,% controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlName="hLB_HotkeyProfiles") {
				GUI_Settings.TabHotkeys_UpdateAvailableProfiles()
				GuiControl, Settings:Choose,% GuiSettings_Controls[ctrlName], 1
				GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
			}
		}
	}

	TabHotkeys_UpdateAvailableProfiles() {
		global PROGRAM, GuiSettings_Controls
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		for index, hkObj in PROGRAM.SETTINGS.HOTKEYS
			hkList := hkList ? hkList "|" hkObj.Name : hkObj.Name
		GuiControl, Settings:,% GuiSettings_Controls.hLB_HotkeyProfiles,% "|" hkList
		if (selectedHkNum)
			GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% selectedHkNum
	}

	TabHotkeys_AddNewHotkeyProfile(hotkeyObj="") {
		global PROGRAM, GuiSettings_Controls
		fadeOutCode := GUI_Settings.ShowFadeout()
		hotkeysCount := PROGRAM.SETTINGS.HOTKEYS.Count(), newHotkeysCount := hotkeysCount+1
		hotkeyObj := IsObject(hotkeyObj) ? hotkeyObj : {"Name":"New hotkey " newHotkeysCount, Hotkey: "", "Actions":[{"Type":"SEND_MSG","Content":"""Write something here"""}]}
		PROGRAM.SETTINGS.HOTKEYS[newHotkeysCount] := ObjFullyClone(hotkeyObj)
		Save_LocalSettings()
		UpdateHotkeys()
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()
		GUI_Settings.TabHotkeys_SetUserSettings()
		GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% newHotkeysCount
		GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
		GUI_Settings.Universal_SelectListViewRow("Hotkeys", LV_GetCount())
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	TabHotkeys_RemoveSelectedHotkeyProfile() {
		global PROGRAM, GuiSettings_Controls
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		MsgBox(4096+4, "", PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name
		. "`n" PROGRAM.TRANSLATIONS.MessageBoxes.Settings_RemoveSelectedHotkeyProfile)
		IfMsgBox, Yes
		{
			fadeOutCode := GUI_Settings.ShowFadeout()
			hotkeysCount := PROGRAM.SETTINGS.HOTKEYS.Count()
			if (selectedHkNum=hotkeysCount) ; Can just delete the last hk 
				PROGRAM.SETTINGS.HOTKEYS.Delete(selectedHkNum)
			else { ; Need to re-arrange the obj
				hotkeysCopy := ObjFullyClone(PROGRAM.SETTINGS.HOTKEYS)
				loopedHK := selectedHkNum
				Loop % hotkeysCount-selectedHkNum {
					PROGRAM.SETTINGS.HOTKEYS[loopedHK] := ObjFullyClone(hotkeysCopy[loopedHK+1])
					loopedHK++
				}
				PROGRAM.SETTINGS.HOTKEYS.Delete(hotkeysCount)
			}
			Save_LocalSettings()
			UpdateHotkeys()
			GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()
			GUI_Settings.TabHotkeys_SetUserSettings()
			GuiControl, Settings:Choose,% GuiSettings_Controls.hLB_HotkeyProfiles,% (hotkeysCount > selectedHkNum ? selectedHkNum : hotkeysCount-1)
			GUI_Settings.TabHotkeys_OnHotkeyProfileChange()
			GUI_Settings.HideFadeout(fadeOutCode)
		}
	}

	TabHotkeys_GetSelectedHotkeyProfile() {
		return GUI_Settings.Submit("hLB_HotkeyProfiles")
	}

	TabHotkeys_OnHotkeyProfileChange() {
		global PROGRAM, GuiSettings_Controls, GuiSettings_ControlFunctions
		fadeOutCode := GUI_Settings.ShowFadeout()
		SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
		Sleep 10
		
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		GUI_Settings.TabHotkeys_SetHotkeyProfileName(PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name)
		GUI_Settings.TabHotkeys_SetHotkeyProfileHotkey(PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Hotkey)
		GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()
		GUI_Settings.TabHotkeys_LoadHotkeyActions(selectedHkNum)
		GUI_Settings.TabHotkeys_SelectListviewRow(1)
		if !(GuiSettings_ControlFunctions.hLV_HotkeyActionsList)
			GUI_Settings.TabHotkeys_OnListviewClick()

		Sleep 10
		SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
		GUI_Settings.HideFadeout(fadeOutCode)
	}

	TabHotkeys_SetHotkeyProfileName(hkName, dontTriggerSub=True) {
		global GuiSettings_Controls
		if (dontTriggerSub)
			GUI.DisableControlFunction("GUI_Settings", "Settings", "hEDIT_HotkeyProfileName")
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyProfileName,% hkName
		if (dontTriggerSub)
			GUI.EnableControlFunction("GUI_Settings", "Settings", "hEDIT_HotkeyProfileName")
	}

	TabHotkeys_GetHotkeyProfileName() {
		return GUI_Settings.Submit("hEDIT_HotkeyProfileName")
	}

	TabHotkeys_OnHotkeyProfileNameChange(doAgainAfter100ms=False) {
		global PROGRAM
		selectedHkNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		hkName := GUI_Settings.TabHotkeys_GetHotkeyProfileName()

		if (!selectedHkNum)
			return
		if (hkName="") {
			GUI_Settings.TabHotkeys_SetHotkeyProfileName("New hotkey " selectedHkNum)
			return
		}

		PROGRAM.SETTINGS.HOTKEYS[selectedHkNum].Name := hkName
		Save_LocalSettings()
		UpdateHotkeys()
		GUI_Settings.TabHotkeys_UpdateAvailableProfiles()

		if (doAgainAfter100ms=True)
			GoSub, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange_Timer
	}

	TabHotkeys_GetHotkeyProfileHotkey() {
		return GUI_Settings.Submit("hEDIT_HotkeyProfileHotkey")
	}

	TabHotkeys_SetHotkeyProfileHotkey(hkStr, dontTriggerSub=True) {
		global GuiSettings_Controls
		if (dontTriggerSub)
			GUI.DisableControlFunction("GUI_Settings", "Settings", "hEDIT_HotkeyProfileHotkey")
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HotkeyProfileHotkey,% Transform_AHKHotkeyString_Into_ReadableHotkeyString(hkStr)
		if (dontTriggerSub)
			GUI.EnableControlFunction("GUI_Settings", "Settings", "hEDIT_HotkeyProfileHotkey")
	}

	TabHotkeys_ChangeHotkeyProfileHotkey() {
		global PROGRAM, GuiSettings

		Gui, Settings:+Disabled
		hkStr := GUI_SetHotkey.WaitForHotkey()
		GUI_Settings.TabHotkeys_SetHotkeyProfileHotkey(hkStr)
		Gui, Settings:-Disabled

		GUI_Settings.Show(GUI_Settings.GetSelectedTab())

		profileNum := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
		PROGRAM.SETTINGS.HOTKEYS[profileNum].Hotkey := hkStr
		Save_LocalSettings()
		UpdateHotkeys()
	}

	TabHotkeys_OnHotkeyProfileHotkeyChange() {
		global PROGRAM, GuiSettings_Controls		
	}

	TabHotkeys_OnActionTypeChange() {
		return GUI_Settings.Universal_OnActionTypeChange("Hotkeys")
	}

	TabHotkeys_OnActionContentChange() {
		return GUI_Settings.Universal_OnActionContentChange("Hotkeys", doAgainAfter100ms:=True)
	}

	TabHotkeys_LoadHotkeyActions(hkNum) {
		return GUI_Settings.Universal_LoadActionsIntoListview("Hotkeys", hkNum)
	}

	TabHotkeys_SelectListviewRow(rowNum) {
		return GUI_Settings.Universal_SelectListViewRow("Hotkeys", rowNum)
	}

	TabHotkeys_OnListviewClick(params*) {
		global GuiSettings_Controls
		return GUI_Settings.Universal_OnListviewClick("Hotkeys", params*)
	}

	TabHotkeys_OnListviewRightClick() {
		return GUI_Settings.Universal_OnListviewRightClick("Hotkeys")
	}

	TabHotkeys_OnHotkeysProfilesListBoxRightClick() {
		global PROGRAM
		try Menu, RMenu, DeleteAll
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.AddANewProfile, GUI_Settings_TabHotkeys_OnHotkeysProfilesListBoxRightClick_AddNewHotkeyProfile
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.DeleteThisProfile, GUI_Settings_TabHotkeys_OnHotkeysProfilesListBoxRightClick_RemoveSelectedHotkeyProfile
		Menu, RMenu, Show
		return

		GUI_Settings_TabHotkeys_OnHotkeysProfilesListBoxRightClick_AddNewHotkeyProfile:
			GUI_Settings.TabHotkeys_AddNewHotkeyProfile()
		return

		GUI_Settings_TabHotkeys_OnHotkeysProfilesListBoxRightClick_RemoveSelectedHotkeyProfile:
			GUI_Settings.TabHotkeys_RemoveSelectedHotkeyProfile()
		return
	}

	TabHotkeys_UpdateActionsListAutomatically() {
		global PROGRAM, GuiSettings_Controls, ACTIONS_AVAILABLE_HOTKEYS, ACTIONS_TEXT_NAME
		miscTranslations := PROGRAM.TRANSLATIONS.MISC
		GUI_Settings.SetDefaultListViewBasedOnTabName("Hotkeys")

		actionTypeCtrlName := "hDDL_HotkeyActionType"
		actionTypeHwnd := GuiSettings_Controls[actionTypeCtrlName]

		; Retrieve the number of the ddl item
		GuiControl, Settings:+AltSubmit,% actionTypeHwnd
		chosenItemNum := GUI_Settings.Submit(actionTypeCtrlName)
		GuiControl, Settings:-AltSubmit,% actionTypeHwnd

		; Get informations about modifying this action
		lvContent := GUI_Settings.Universal_GetListViewContent("Hotkeys")

		Loop 2 {
			_buyOrSell := A_Index=1 ? "BUY" : "SELL"
			guiIniSection := _buyOrSell="BUY" ? "BUY_INTERFACE" : "SELL_INTERFACE"
			
			hotkeysActionsAvailable := guiIniSection="BUY_INTERFACE" ? ACTIONS_AVAILABLE_HOTKEYS "| |-> " PROGRAM.TRANSLATIONS.ACTIONS.SECTIONS["BUTTONS_BUY_INTERFACE"]
				: hotkeysActionsAvailable "| |-> " PROGRAM.TRANSLATIONS.ACTIONS.SECTIONS["BUTTONS_SELL_INTERFACE"]

			Loop 4 { ; 4 rows
				rowIndex := A_Index
				Loop % PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowIndex].Buttons_Count {
					btnIndex := A_Index
					thisBtnSettings := PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowIndex][btnIndex]
					rowInfoTxt := "(" _buyOrSell " " miscTranslations.Row " " rowIndex " " miscTranslations.Number " " btnIndex ")"
					actionName := thisBtnSettings.Text ? thisBtnSettings.Text " " rowInfoTxt
						: thisBtnSettings.Icon ? miscTranslations.Icon " " thisBtnSettings.Icon " " rowInfoTxt
						: rowInfoTxt

					if (btnIndex=1 && rowIndex>1)
						hotkeysActionsAvailable .= "| "
					hotkeysActionsAvailable .= "|" actionName
					ACTIONS_TEXT_NAME[guiIniSection "_CUSTOM_BUTTON_ROW_" rowIndex "_NUM_" btnIndex] := actionName
				}
			}
		}
		AutoTrimStr(hotkeysActionsAvailable)
		if ( SubStr(hotkeysActionsAvailable, -1) = "|" )
			hotkeysActionsAvailable := StrTrimRight(hotkeysActionsAvailable, 1)
		GUI.DisableControlFunction("GUI_Settings", "Settings", actionTypeCtrlName)
		GuiControl, Settings:,% actionTypeHwnd,% "|" hotkeysActionsAvailable
		GuiControl, Settings:Choose,% actionTypeHwnd,% chosenItemNum
		GUI.EnableControlFunction("GUI_Settings", "Settings", actionTypeCtrlName)

		odcObjHK := GUI_Settings.CreateODCObjFromActionsList(hotkeysActionsAvailable)
		OD_Colors.Attach(actionTypeHwnd, odcObjHK) ; Requires +0x0210 for DDL and +0x0050 for LB
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC UPDATING
	*/

	TabUpdating_SetSubroutines() {
		global GuiSettings, GuiSettings_Controls
		controlsList := "hCB_UseBeta,hCB_DownloadUpdatesAutomatically"

		Loop, Parse, controlsList,% ","
		{
			ctrlName := A_LoopField, ctrlSplit := StrSplit(ctrlName, "_"), ctrlType := ctrlSplit.1, settingsKey := ctrlSplit.2

			if (ctrlType="hCB")
				Gui.BindFunctionToControl("GUI_Settings", "Settings", ctrlName, "TabUpdating_OnCheckboxToggle", ctrlName)
		}

		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hBTN_CheckForUpdates", "TabUpdating_CheckForUpdates")
		Gui.BindFunctionToControl("GUI_Settings", "Settings", "hDDL_CheckForUpdate", "TabUpdating_OnCheckForUpdatesDDLChange", GuiSettings_Controls.hDDL_CheckForUpdate)
	}

	TabUpdating_SetUserSettings() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		GUI_Settings.TabUpdating_UpdateVersionsText()
		; Set checkbox state
		for key, value in thisTabSettings {
			if IsIn(key, "AllowToUpdateAutomaticallyOnStart,AllowPeriodicUpdateCheck,UseBeta,DownloadUpdatesAutomatically") {
				cbValue := value="True"?1 : value="False"?0 : value
				thisTabSettings[key] := cbValue
			}
			if (key = "CheckForUpdatePeriodically") {
				ddlValue := value="OnStartOnly" ? 1
					: value="OnStartAndEveryFiveHours" ? 2
					: value="OnStartAndEveryDay" ? 3
					: 1
				thisTabSettings[key] := ddlValue
			}
		}
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowToUpdateAutomaticallyOnStart ,% thisTabSettings.AllowToUpdateAutomaticallyOnStart
		; GuiControl, Settings:,% GuiSettings_Controls.hCB_AllowPeriodicUpdateCheck ,% thisTabSettings.AllowPeriodicUpdateCheck
		GuiControl, Settings:Choose,% GuiSettings_Controls.hDDL_CheckForUpdate,% thisTabSettings.CheckForUpdatePeriodically
		GuiControl, Settings:,% GuiSettings_Controls.hCB_UseBeta,% thisTabSettings.UseBeta
		GuiControl, Settings:,% GuiSettings_Controls.hCB_DownloadUpdatesAutomatically,% thisTabSettings.DownloadUpdatesAutomatically
	}

	TabUpdating_UpdateVersionsText() {
		global PROGRAM, GuiSettings_Controls, UPDATE_TAGNAME
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		; Get time diff since update check
		timeDiff := timeDiffS A_Now, lastTimeChecked := thisTabSettings.LastUpdateCheck
		timeDiffS -= lastTimeChecked, Seconds
		timeDiff -= lastTimeChecked, Minutes
		timeDiff := timeDiffS < 61 ? 1 : timeDiff
		; Set groupbox title
		/* No longer used, no more GB control
		if (UPDATE_TAGNAME != "")
			GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% updAvailable " is available!"
		else GuiControl, Settings:,% GuiSettings_Controls.hGB_UpdateCheck,% "You are up to date!"
		*/

		; Set field content
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_ProgramVer,% PROGRAM.VERSION
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestStableVer,% thisTabSettings.LatestStable
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_LatestBetaVer,% thisTabSettings.LatestBeta
		GuiControl, Settings:,% GuiSettings_Controls.hTEXT_MinsAgo,% StrReplace(PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_MinsAgo, "%time%", timeDiff)
		; Update control size
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_ProgramVer,% "w" Get_TextCtrlSize(PROGRAM.VERSION, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestStableVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestStable, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_LatestBetaVer,% "w" Get_TextCtrlSize(thisTabSettings.LatestBeta, "Segoe UI", "8").W
		GuiControl, Settings:Move,% GuiSettings_Controls.hTEXT_MinsAgo,% "w" Get_TextCtrlSize(StrReplace(PROGRAM.TRANSLATIONS.GUI_Settings.hTEXT_MinsAgo, "%time%", timeDiff), "Segoe UI", "8").W
	}

	TabUpdating_OnCheckboxToggle(CtrlName) {
		global PROGRAM

		iniKey := SubStr(CtrlName, 5)

		val := GUI_Settings.Submit(CtrlName)
		val := val=0?"False":val=1?"True":val

		PROGRAM.SETTINGS.UPDATING[iniKey] := val
		Save_LocalSettings()
	}

	TabUpdating_CheckForUpdates() {
		global PROGRAM, GuiSettings_Controls
		thisTabSettings := ObjFullyClone(PROGRAM.SETTINGS.UPDATING)

		UpdateCheck(checkType:="forced", notifOrBox:="box")
		GUI_Settings.TabUpdating_UpdateVersionsText()
	}

	TabUpdating_OnCheckForUpdatesDDLChange(CtrlName, CtrlHwnd) {
		global PROGRAM, GuiSettings_Controls
	
		ddlVal := GUI_Settings.Submit(CtrlName)
		valStr := ddlVal=1 ? "OnStartOnly"
			: ddlVal=2 ? "OnStartAndEveryFiveHours"
			: ddlVal=3 ? "OnStartAndEveryDay"
			: "OnStartAndEveryFiveHours"

		PROGRAM.SETTINGS.UPDATING.CheckForUpdatePeriodically := valStr
		Save_LocalSettings()
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	*	Tab MISC ABOUT
	*/

	TabAbout_UpdateAllOfFame() {
		SetTimer, GUI_Setting_TabAbout_UpdateAllOfFame_Timer, -10
		Return

		GUI_Setting_TabAbout_UpdateAllOfFame_Timer:
			hof := GUI_Settings.TabAbout_GetHallOfFame()
			GUI_Settings.TabAbout_SetHallOfFame(hof)
		Return
	}

	TabAbout_SetHallOfFame(hof) {
		global GuiSettings_Controls

		txt := "Hall of Fame`nThank you for your support!`n`n" hof
		GuiControl, Settings:,% GuiSettings_Controls.hEDIT_HallOfFame,% txt
	}

	TabAbout_GetHallOfFame() {
		global PROGRAM

		url := "https://github.com/lemasato/POE-Trades-Companion/wiki/Support"
    	headers := "Content-Type: text/html, charset=UTF-8"
    	options := "TimeOut: 7"
    	. "`n"     "Charset: UTF-8"

    	WinHttpRequest_cURL(url, data:="", headers, options), html := data

		hallOfFame := ""
		if RegExMatch(html,"\<table.*\>(.*)\<\/table\>", match) {
			Loop, Parse, match,% "`n",% "`r"
			{
				if RegExMatch(A_LoopField,"\<td\>(.*?)\<\/td\>", name) {
					name := StrReplace(name, "<td>")
					name := StrReplace(name, "</td>")
					hallOfFame .= name "`n"
				}
			}
			Sort, hallOfFame, D`n
		}
		else 
			hallOfFame := "[Failed to retrieve Hall of Fame]"
		
		return hallOfFame		
	}

	/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*								UNIVERSAL ACTION FUNCTIONS											 *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	*/

	Universal_SelectListViewRow(whichTab, rowNum=1) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		LV_Modify(rowNum, "+Select +Focus")
	}

	Universal_LoadActionsIntoListview(whichTab, params*) {
		global PROGRAM, GuiSettings
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		if IsIn(whichTab, "Selling,Buying") {
			rowNum := params.1, btnNum := params.2
			guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
			actionsObj := ObjFullyClone(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum].Actions)
		}
		else if (whichTab="Hotkeys") {
			hkIndex := params.1
			actionsObj := ObjFullyClone(PROGRAM.SETTINGS.HOTKEYS[hkIndex].Actions)
		}

		Loop % LV_GetCount()
			LV_Delete()
		Loop % actionsObj.Count() {
			actionType := actionsObj[A_Index].Type
			if (SubStr(actionContent, 1, 1) = """") && (SubStr(actionContent, 0) = """") ; Removing quotes
				actionContent := StrTrimLeft(actionContent, 1), actionContent := StrTrimRight(actionContent, 1)
			actionContent := StrTrimLeft(actionsObj[A_Index].Content, 1), actionContent := StrTrimRight(actionContent, 1) ; Removing quotes
			actionLongName := GUI_Settings.Get_ActionLongName_From_ShortName(actionType)

			LV_Add("", A_Index, actionLongName, actionContent)
		}
		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
	}

    Universal_SaveAllActions(whichTab, isTimedSave=False) {
		global PROGRAM, GuiSettings
		static prevNumObj := {}
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Getting activated button variables
		if IsIn(whichTab, "Selling,Buying") {
			guiIniSection := whichTab="Selling"?"SELL_INTERFACE":"BUY_INTERFACE"
			rowNum := GuiSettings.CUSTOM_BUTTON_SELECTED_ROW
			btnsCount := GuiSettings.CUSTOM_BUTTON_SELECTED_MAX
			btnNum := GuiSettings.CUSTOM_BUTTON_SELECTED_NUM
			; Couldnt save notification
			if (!rowNum || !btnsCount || !btnNum) {
				; TrayNotifications.Show("", "COULDN'T SAVE BUTTON"
				; . "`nRow: " rowNum
				; . "`nCount: " btnsCount
				; . "`nNum: " btnNum
				; . "`nTab: " whichTab)
				return
			}
		}
		; Save new actions
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		if IsIn(whichTab, "Buying,Selling") {
			if (isTimedSave && prevNumObj[whichTab] && prevNumObj[whichTab] != rowNum btnNum) {
				prevNumObj[whichTab] := rowNum btnNum
				return
			}
				
			if !IsObject(PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum])
				PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum] := {}
			PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum]["Actions"] := {}
			for index, nothing in lvContent {
				actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lvContent[index].ActionType)
				PROGRAM.SETTINGS[guiIniSection]["CUSTOM_BUTTON_ROW_" rowNum][btnNum]["Actions"][index] := {Content: """" lvContent[index].ActionContent """", Type: actionShortName}
			}
			prevNumObj[whichTab] := rowNum btnNum
		}
		else if (whichTab="Hotkeys") {
			hkIndex := GUI_Settings.TabHotkeys_GetSelectedHotkeyProfile()
			if (isTimedSave && prevNumObj[whichTab] && prevNumObj[whichTab] != hkIndex) {
				prevNumObj[whichTab] := hkIndex
				return
			}

			if !IsObject(PROGRAM.SETTINGS.HOTKEYS[hkIndex])
				PROGRAM.SETTINGS.HOTKEYS[hkIndex] := {}
			PROGRAM.SETTINGS.HOTKEYS[hkIndex]["Actions"] := {}
			for index, nothing in lvContent {
				actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lvContent[index].ActionType)
				PROGRAM.SETTINGS.HOTKEYS[hkIndex]["Actions"][index] := {Content: """" lvContent[index].ActionContent """", Type: actionShortName}
			}
			prevNumObj[whichTab] := hkIndex
		}

		Save_LocalSettings()
		UpdateHotkeys()
		if (whichTab="Hotkeys")
			GUI_Settings.TabHotkeys_UpdateActionsListAutomatically()
	}

	Universal_ShowActionTypeTip(whichTab, actionTypeShort) {
		global GuiSettings_Controls
		actionTypeTipCtrlName := whichTab="Buying"?"hTEXT_CustomizationBuyingActionTypeTip"
			: whichTab="Selling"?"hTEXT_CustomizationSellingActionTypeTip"
			: whichTab="Hotkeys"?"hTEXT_HotkeyActionTypeTip"
			: ""

		actionTypeTip := GUI_Settings.Get_ActionTypeTip_From_ShortName(actionTypeShort)
		GuiControl, Settings:,% GuiSettings_Controls[actionTypeTipCtrlName],% actionTypeTip
	}

	Universal_OnActionTypeTipLinkClick(CtrlHwnd, GuiEvent, LinkIndex, HrefOrID) {
		global PROGRAM
		if (HrefOrID="TradingVariables") {
			ShowToolTip(PROGRAM.TRANSLATIONS.ToolTips.TradingVariables)
		}
	}

    Universal_OnActionTypeChange(whichTab) {
		global GuiSettings_Controls
		global ACTIONS_READONLY, ACTIONS_FORCED_CONTENT

		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
		
		actionTypeHwnd := GuiSettings_Controls[actionTypeCtrlName]
		actionContentHwnd := GuiSettings_Controls[actionContentCtrlName]

		; Get current action type & content
		actionType := GUI_Settings.Submit(actionTypeCtrlName), AutoTrimStr(actionType) ; Trim so space to separate sections is made empty
		actionContent := GUI_Settings.Submit(actionContentCtrlName)
		; Get infos concerning this action
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		GUI_Settings.Universal_ShowActionTypeTip(whichTab, actionShortName)
				
		; Avoid selecting actions with -> in name or empty
		if IsContaining(actionType, "-> ") || (actionType = "") {
			; Check if one arrow was being pressed
			isUpPressed := GetKeyState("Up"), isDownPressed := GetKeyState("Down")
			isLeftPressed := GetKeyState("Left"), isRightPressed := GetKeyState("Right")
			; Retrieve the number of the ddl item
			GuiControl, Settings:+AltSubmit,% actionTypeHwnd
			chosenItemNum := GUI_Settings.Submit(actionTypeCtrlName)
			GuiControl, Settings:-AltSubmit,% actionTypeHwnd
			; Select whichever is next, based on arrow press
			if (isUpPressed || isLeftPressed) {
				if (chosenItemNum = 1)
					GuiControl, Settings:Choose,% actionTypeHwnd,% 2
				else {
					pressDiff := (actionType="") ? 1 : 2 ; 1 = difference between empty space and previous action
					GuiControl, Settings:Choose,% actionTypeHwnd,% chosenItemNum-pressDiff
				}
			}
			else {
				pressDiff := (actionType="") ? 2 : 1 ; 2 = difference between empty space and next action
				GuiControl, Settings:Choose,% actionTypeHwnd,% chosenItemNum+pressDiff
			}

			; Start the function again
			Sleep 10
			GUI_Settings.Universal_OnActionTypeChange(whichTab)
			Return
		}
		; Make read only if action is supposed to be
		if IsIn(actionShortName, ACTIONS_READONLY)
			GuiControl, Settings:+ReadOnly,% actionContentHwnd
		else
			GuiControl, Settings:-ReadOnly,% actionContentHwnd
		; Retrieve forced content if action is supposed to be
		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		; Set the forced content if contains any, otherwise make content empty
		if (forcedContent)
			GUI_Settings.Universal_SetActionContent(whichTab, forcedContent)
		else if IsIn(actionShortName, "SEND_MSG,WRITE_MSG,WRITE_THEN_GO_BACK,SENDINPUT,SENDEVENT")
			GUI_Settings.Universal_SetActionContent(whichTab, actionContent)
		; else
			; GUI_Settings.Universal_SetActionContent(whichTab, "")

		; Update currently selected action
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if IsNum(selectedRow) && (selectedRow > 0) {
			GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, actionType, "")
		}
	}

    Universal_OnActionContentChange(whichTab, doAgainAfter100ms=False) {
		/* The doAgainAfter100ms trick allows to make sure that the function is ran correctly if the user typed way too fast somehow
		*/
		global PROGRAM, GuiSettings, GuiSettings_Controls

		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""

		if !(actionTypeCtrlName || actionContentCtrlName) {
			MsgBox(4096, "", "Invalid use of " A_ThisFunc ". Unknown tab: """ whichTab """")
			return
		}

		; Get current action type & content
		actionType := GUI_Settings.Submit(actionTypeCtrlName), AutoTrimStr(actionType)
		actionContent := GUI_Settings.Submit(actionContentCtrlName)
		; Get infos concerning this action
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionForcedContent := GUI_Settings.Get_ActionForcedContent_From_ActionShortName(actionShortName)

		; Make sure that forced content is within string
		if (actionForcedContent) {
			strL := StrLen(actionForcedContent)
			contentSubStr  := SubStr(actionContent, 1, strL)

			if (contentSubStr != actionForcedContent) {
				GUI_Settings.Universal_SetActionContent(whichTab, actionForcedContent)
				ShowToolTip( StrReplace(PROGRAM.TRANSLATIONS.ToolTips.StringHasToStartWith, "%text%", "actionForcedContent") )
				tipWarn := True, actionContent := actionForcedContent
			}
		}
		else if (actionShortName = "SLEEP") {
			AutoTrimStr(actionContent)

			if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
				GUI_Settings.Universal_SetActionContent(whichTab, 100)
				ShowToolTip(PROGRAM.TRANSLATIONS.ToolTips.ValueCanBeIntegerOnly)
				tipWarn := True, actionContent := 100
			}
			else if IsDigit(actionContent) && (actionContent > 5000) {
				GUI_Settings.Universal_SetActionContent(whichTab, 5000)
				ShowToolTip( StrReplace(PROGRAM.TRANSLATIONS.ToolTips.MaxValueIs, "%value%", 5000) )
				tipWarn := True, actionContent := 1000
			}
		}
		else if (actionShortName = "IGNORE_SIMILAR_TRADE") {
			AutoTrimStr(actionContent)

			if (actionContent) && ( !IsDigit(actionContent) || IsContaining(actionContent, ".") ) {
				GUI_Settings.Universal_SetActionContent(whichTab, 10)
				ShowToolTip(PROGRAM.TRANSLATIONS.ToolTips.ValueCanBeIntegerOnly)
				tipWarn := True, actionContent := 10
			}
		}

		; Update currently selected action
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if IsNum(selectedRow) && (selectedRow > 0) {
			GUI_Settings.Universal_ListViewModifySelectedAction(whichTab, "", actionContent)
		}

		; Show a tooltip of current contet
		; if (!tipWarn) && (actionContent) && (actionContent != actionForcedContent)
			; ShowToolTip(actionContent)
		
		if (doAgainAfter100ms=True) {
			if (whichTab="Selling")
				GoSub, GUI_Settings_Customization_Selling_OnActionContentChange_Timer
			else if (whichTab="Buying")
				GoSub, GUI_Settings_Customization_Buying_OnActionContentChange_Timer
			else if (whichTab="Hotkeys")
				GoSub, GUI_Settings_Hotkeys_OnActionContentChange_Timer
		}
	}

    Universal_ListViewModifySelectedAction(whichTab, actionType="", actionContent="") {
		global PROGRAM, ACTIONS_WRITE, ACTIONS_EMPTY
		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
			
		; Get informations about modifying this action
		actionType := actionType?actionType: GUI_Settings.Submit(actionTypeCtrlName)
		actionContent := actionContent?actionContent: GUI_Settings.Submit(actionContentCtrlName)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		; Get informations about the last action
		LV_GetText(lastActionType, LV_GetCount(), 2), LV_GetText(lastActionContent, LV_GetCount(), 3)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)

		; Prevent continuing if action isn't valid
		if !(actionShortName) {
			; MsgBox(4096, "Invalid action name", "Type: """ actionType """"
			; . "`nContent: """ actionContent """"
			; . "`nShort name: """ actionShortName """")
			return
		}
		; Prevent adding action if it does a write/close action and the last action is write
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB,CLOSE_ALL_TABS") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, ACTIONS_WRITE) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsWrite, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		; Prevent adding action if it does a write/close action and last action is close
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB,CLOSE_ALL_TABS") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, "CLOSE_TAB,CLOSE_ALL_TABS") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsCloseTab, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		else {
			GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
			lvCtrlName := GUI_Settings.GetListViewControlNameBasedOnTabName(whichTab)
			GUI.DisableControlFunction("GUI_Settings", "Settings", lvCtrlName)
			 ; Replacing before last line with our action
			if IsIn(actionShortName, ACTIONS_EMPTY)
				LV_Modify(selectedRow, , selectedRow, actionType, "")
			else if (actionShortName="SLEEP" && !IsNum(actionContent))
				LV_Modify(selectedRow, , selectedRow, actionType, 10)
			else
				LV_Modify(selectedRow, , selectedRow, actionType, actionContent)
			GUI.EnableControlFunction("GUI_Settings", "Settings", lvCtrlName)
		}
		
		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_OnListviewRightClick(whichTab) {
		global PROGRAM
		global GuiSettings, GuiSettings_Controls
		global ACTIONS_TEXT_NAME, ACTIONS_FORCED_CONTENT
		
		try Menu, RMenu, DeleteAll
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.AddANewAction, Universal_OnListviewRightClick_AddNewAction
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.RemoveThisAction, Universal_OnListviewRightClick_RemoveSelectedAction
		Menu, RMenu, Add
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.MoveThisActionUp, Universal_OnListviewRightClick_MoveSelectedActionUp
		Menu, RMenu, Add,% PROGRAM.TRANSLATIONS.GUI_Settings.MoveThisActionDown, Universal_OnListviewRightClick_MoveSelectedActionDown

		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if (selectedRow = 1 || !selectedRow)
			Menu, RMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Settings.MoveThisActionUp
		if (selectedRow = LV_GetCount() || !selectedRow)
			Menu, RMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Settings.MoveThisActionDown
		if (!selectedRow)
			Menu, RMenu, Disable,% PROGRAM.TRANSLATIONS.GUI_Settings.RemoveThisAction
		Menu, RMenu, Show
		return

		Universal_OnListviewRightClick_AddNewAction:
			/*
			GUI_Settings.SetDefaultListView("hLV_CustomizationSellingActionsList")
			actionType := GUI_Settings.Submit("hDDL_CustomizationSellingActionType"), AutoTrimStr(actionType)
			actionContent := GUI_Settings.Submit("hEDIT_CustomizationSellingActionContent")
			if (actionType)
			*/
				actionText := "Write something here"
				if (whichTab="Buying")
					actionText := "@%seller% " actionText
				else if (whichTab="Selling")
					actionText := "@%buyer% " actionText
				else if (whichTab="Hotkeys")
					actionText := actionText
				GUI_Settings.Universal_AddNewAction(whichTab, ACTIONS_TEXT_NAME.SEND_MSG, actionText)
		return

		Universal_OnListviewRightClick_RemoveSelectedAction:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			if IsNum(selectedRow) && (selectedRow > 0) {
				GUI_Settings.Universal_RemoveAction(whichTab, selectedRow)
			}
		return

		Universal_OnListviewRightClick_MoveSelectedActionUp:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			GUI_Settings.Universal_MoveActionUp(whichTab, selectedRow)
		return
		Universal_OnListviewRightClick_MoveSelectedActionDown:
			selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
			GUI_Settings.Universal_MoveActionDown(whichTab, selectedRow)
		return
	}

    Universal_MoveActionUp(whichTab, rowNum) {
		global PROGRAM, GuiSettings_Controls, ACTIONS_WRITE
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Get informations about modifying this action
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		actionType := lvContent[rowNum].ActionType, actionContent := lvContent[rowNum].ActionContent
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionNum := rowNum
		; Get informations about the last action
		lastActionType := lvContent[LV_GetCount()].ActionType, lastActionContent := lvContent[LV_GetCount()].ActionContent
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		lastActionNum := lvContent[LV_GetCount()].Num
		
		if IsIn(lastActionShortName, ACTIONS_WRITE)
		&& (lastActionNum = actionNum) {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsWrite)
			Return
		}
		else if IsIn(lastActionShortName, "CLOSE_TAB,CLOSE_ALL_TABS")
		&& (lastActionNum = actionNum) {
			MsgBox(4096, "", PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveUpBcsItsCloseTab)
			Return
		}

		LV_Modify(rowNum-1, , rowNum-1, lvContent[rowNum].ActionType, lvContent[rowNum].ActionContent) ; Replacing above action with our action
		LV_Modify(rowNum, , rowNum, lvContent[rowNum-1].ActionType, lvContent[rowNum-1].ActionContent) ; Replacing our action with action above

		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_MoveActionDown(whichTab, rowNum) {
		global PROGRAM, GuiSettings_Controls, ACTIONS_WRITE
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		; Get informations about modifying this action
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		actionType := lvContent[rowNum].ActionType, actionContent := lvContent[rowNum].ActionContent
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		actionNum := rowNum
		; Get informations about the last action
		lastActionType := lvContent[LV_GetCount()].ActionType, lastActionContent := lvContent[LV_GetCount()].ActionContent
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		lastActionNum := lvContent[LV_GetCount()].Num

		if IsIn(lastActionShortName, ACTIONS_WRITE)
		&& (lastActionNum = actionNum+1) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsWrite, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}

		else if IsIn(lastActionShortName, "CLOSE_TAB,CLOSE_ALL_TABS")
		&& (lastActionNum = actionNum+1) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_CannotMoveDownBcsLastIsCloseTab, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			Return
		}

		LV_Modify(rowNum+1, , rowNum+1, lvContent[rowNum].ActionType, lvContent[rowNum].ActionContent) ; Replacing under action with our action
		LV_Modify(rowNum, , rowNum, lvContent[rowNum+1].ActionType, lvContent[rowNum+1].ActionContent) ; Replacing our action with action under

		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_GetListviewSelectedRow(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		return LV_GetNext(0, "F")
	}

    Universal_RemoveAction(whichTab, actionNum) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)

		newLvContent := {}
		Loop % lvContent.Count() {
			if (A_Index < actionNum) { ; If lower, just add it
				newLvContent[A_Index] := ObjFullyClone(lvContent[A_Index])
			}
			else if (A_Index > actionNum) { ; If higher, add to index minus one
				newLvContent[A_Index-1] := ObjFullyClone(lvContent[A_Index])
				newLvContent[A_Index-1].Num := lvContent[A_Index].Num - 1
			}
			; notice we don't do anything if equal, effectively skipping
		}
		; Adding new action list
		selectedLvNum := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		newLvSelectedNum := selectedLvNum = LV_GetCount() ? selectedLvNum-1 : selectedLvNum
		Loop % LV_GetCount()
			LV_Delete()
		Loop % newLvContent.Count()
			LV_Add("", newLvContent[A_Index].Num, newLvContent[A_Index].ActionType, newLvContent[A_Index].ActionContent)
		GUI_Settings.Universal_SelectListViewRow(whichTab, newLvSelectedNum)

		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_GetListViewContent(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		content := {}
		Loop % LV_GetCount() {			
			LV_GetText(rowNum, A_Index, 1)
			LV_GetText(actionType, A_Index, 2)
			LV_GetText(actionContent, A_Index, 3)
			content[A_Index] := {Num:rowNum, ActionType:actionType, ActionContent:actioncontent}
		}
		return content
	}

    Universal_AddNewAction(whichTab, actionType, actionContent) {
		global PROGRAM, ACTIONS_WRITE
		global GuiSettings, GuiSettings_Controls
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		LV_GetText(lastActionType, LV_GetCount(), 2), LV_GetText(lastActionContent, LV_GetCount(), 3)
		lastActionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lastActionType)
		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)

		; Prevent continuing if action isn't valid
		if !(actionShortName) {
			MsgBox(4096, "Invalid action name", "Type: """ actionType """"
			. "`nContent: """ actionContent """"
			. "`nShort name: """ actionShortName """")
			return
		}
		; Prevent adding action if it does a write/close action and the last action is write
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB,CLOSE_ALL_TABS") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, ACTIONS_WRITE) {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsWrite, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}
		; Prevent adding action if it does a write/close action and last action is close
		else if IsIn(actionShortName, ACTIONS_WRITE ",CLOSE_TAB,CLOSE_ALL_TABS") && ( selectedRow != LV_GetCount() )
		&& IsIn(lastActionShortName, "CLOSE_TAB,CLOSE_ALL_TABS") {
			boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_LastActionIsCloseTab, "%thisAction%", actionType)
			boxTxt := StrReplace(boxTxt, "%lastAction%", lastActionType)
			MsgBox(4096, "", boxTxt)
			return
		}

		; Decides where to add the new action
		if IsIn(lastActionShortName, ACTIONS_WRITE ",CLOSE_TAB,CLOSE_ALL_TABS")
			isLastCloseOrWrite := True
		; Adding the new action
		if (isLastCloseOrWrite) { ; Adding new blank action, then modifying list to accomodate and make new action previous to last
			currentLvCount := LV_GetCount(), actionLvNum := currentLvCount
			LV_Add("", currentLvCount+1, "", ""), currentLvCount := LV_GetCount() ; Adding new line
			LV_Modify(actionLvNum, , actionLvNum, actionType, actionContent) ; Replacing before last line with our action
			LV_Modify(currentLvCount, , currentLvCount, lastActionType, lastActionContent) ; Replacing last line with the old last action
			GUI_Settings.Universal_SelectListViewRow(whichTab, actionLvNum)
		}
		else { ; Just adding the new action at end of list
			currentLvCount := LV_GetCount(), actionLvNum := currentLvCount+1
			LV_Add("", actionLvNum, actionType, actionContent)
			GUI_Settings.Universal_SelectListViewRow(whichTab, actionLvNum)
		}

		GUI_Settings.Universal_AdjustListviewHeaders(whichTab)
		if (whichTab="Selling")
			GoSub, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Buying")
			GoSub, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer
		else if (whichTab="Hotkeys")
			GoSub, GUI_Settings_Hotkeys_SaveAllActions_Timer
	}

    Universal_AdjustListviewHeaders(whichTab) {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)
		Loop 3
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
	}

    Universal_OnListviewClick(whichTab, CtrlHwnd="", GuiEvent="", EventInfo="", GuiEvent2="") {
		GUI_Settings.SetDefaultListViewBasedOnTabName(whichTab)

		if !IsIn(GuiEvent, "DoubleClick,Normal,D,I,K")
			return

		selectedRow := GUI_Settings.Universal_GetListviewSelectedRow(whichTab)
		if (!selectedRow)
			return

		LV_Modify(selectedRow, "+Select")

		lvContent := GUI_Settings.Universal_GetListViewContent(whichTab)
		GUI_Settings.Universal_SetActionType(whichTab, lvContent[selectedRow].ActionType)
		GUI_Settings.Universal_SetActionContent(whichTab, lvContent[selectedRow].ActionContent)
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(lvContent[selectedRow].ActionType)
		GUI_Settings.Universal_ShowActionTypeTip(whichTab, actionShortName)
	}

    Universal_SetActionType(whichTab, actionType, dontTriggerSub=True) {
		global GuiSettings_Controls, ACTIONS_READONLY
		actionTypeCtrlName := whichTab="Buying"?"hDDL_CustomizationBuyingActionType"
			: whichTab="Selling"?"hDDL_CustomizationSellingActionType"
			: whichTab="Hotkeys"?"hDDL_HotkeyActionType"
			: ""
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
		actionTypeHwnd := GuiSettings_Controls[actionTypeCtrlName]
		actionContentHwnd := GuiSettings_Controls[actionContentCtrlName]

		; Make read only if action is supposed to be
		actionShortName := GUI_Settings.Get_ActionShortName_From_LongName(actionType)
		if IsIn(actionShortName, ACTIONS_READONLY)
			GuiControl, Settings:+ReadOnly,% actionContentHwnd
		else
			GuiControl, Settings:-ReadOnly,% actionContentHwnd

		if (dontTriggerSub)
			GUI.DisableControlFunction("GUI_Settings", "Settings", actionTypeCtrlName)
		GuiControl, Settings:ChooseString,% actionTypeHwnd,% actionType
		if (dontTriggerSub)
			GUI.EnableControlFunction("GUI_Settings", "Settings", actionTypeCtrlName)
	}
	
    Universal_SetActionContent(whichTab, actionContent, dontTriggerSub=True) {
		global GuiSettings_Controls
		actionContentCtrlName := whichTab="Buying"?"hEDIT_CustomizationBuyingActionContent"
			: whichTab="Selling"?"hEDIT_CustomizationSellingActionContent"
			: whichTab="Hotkeys"?"hEDIT_HotkeyActionContent"
			: ""
		ctrlHwnd := GuiSettings_Controls[actionContentCtrlName]
		if (dontTriggerSub)
			GUI.DisableControlFunction("GUI_Settings", "Settings", actionContentCtrlName)
		GuiControl, Settings:,% ctrlHwnd,% actionContent
		if (dontTriggerSub)
			GUI.EnableControlFunction("GUI_Settings", "Settings", actionContentCtrlName)
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
		odcObj := GUI_Settings.CreateOdcObj()
		Loop % sectionsArr.Count()
			odcObj[sectionsArr[A_Index]] := {T: 0xf5f5f5, B:0x0078D7}

		return odcObj
	}

	GetPosition() {
		global GuiSettings
		hw := DetectHiddenWindows("On")
		WinGetPos, x, y, w, h,% "ahk_id " GuiSettings.Handle
		DetectHiddenWindows(hw)
		
		return {x:x,y:y,w:w,h:h}
	}

	IsVisible() {
		global GuiSettings
		hw := DetectHiddenWindows("Off")
		winHwnd := WinExist("ahk_id " GuiSettings.Handle)
		DetectHiddenWindows(hw)
		return winHwnd
	}

	ShowFadeout() {
		/* 	Puts a black transparency on the GUI to indicate that it's disabled
			Returns a random code that must be given to the HideFadeout() func
			This is to make sure that, in case multiple functions called ShowFadeout(), only the very first one is able to call HideFadeout()
		*/
		global GuiSettingsFadeout

		if (GUI_Settings.IsVisible() && !GuiSettingsFadeout.Handle) {
			Gui, Settings:+Disabled
			settingsGuiPos := GUI_Settings.GetPosition(), fadeOutCode := RandomStr(10)
			Gui.Destroy("SettingsFadeout")
			Gui.New("SettingsFadeout", "-Caption -Border +Toolwindow +Lastfound +AlwaysOnTop +HwndhGuiSettingsFadeout ")
			WinSet, Transparent,% (255/100)*20
			WinSet, ExStyle, +0x20 ; Clickthrough
			Gui.Margin("SettingsFadeout", 0, 0)
			Gui.Color("SettingsFadeout", "0x000000")
			; Gui.Add("SettingsFadeout", "Picture", "x30 y30", )
			Gui.Show("SettingsFadeout", "x" settingsGuiPos.X " y" settingsGuiPos.Y " w" settingsGuiPos.W " h" settingsGuiPos.H " NoActivate")

			GuiSettingsFadeout.FadeoutCode := fadeOutCode
			return fadeOutCode
		}
	}

	HideFadeout(fadeOutCode) {
		global GuiSettings, GuiSettingsFadeout

		if (!fadeOutCode) || (fadeOutCode != GuiSettingsFadeout.FadeoutCode)
			return

		Gui, Settings:-Disabled
		Gui.Destroy("SettingsFadeout")
		WinActivate,% "ahk_id " GuiSettings.Handle
	}

	DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

	Minimize() {
		Gui, Settings:Show, Minimize
	}

	Close() {
		global PROGRAM
		Gui, Settings:Hide
		GUI_Settings.TabCustomizationSkins_RecreateTradesGUI()
	}

	OnPictureLinkClick(picName) {
		global PROGRAM

		urlLink := picName="Paypal"?PROGRAM.LINK_SUPPORT
		: picName="Discord"?PROGRAM.LINK_DISCORD
		: picName="Reddit"?PROGRAM.LINK_REDDIT
		: picName="PoE"?PROGRAM.LINK_GGG
		: picName="GitHub"?PROGRAM.LINK_GITHUB
		: ""

		if (urlLink)
			Run,% urlLink
	}

	OnLanguageChange(lang) {
		global PROGRAM, GuiSettings, GuiMyStats
		static prevLang
		prevLang := prevLang?prevLang:PROGRAM.SETTINGS.GENERAL.Language

		PROGRAM.SETTINGS.GENERAL.Language := lang
		Save_LocalSettings()
		PROGRAM.TRANSLATIONS := GetTranslations(lang)
		
		TrayMenu() ; Re-creating tray menu
		settingsWinExists := WinExist("ahk_id " GuiSettings.Handle)
		if (settingsWinExists) {
			settingsTab := GUI_Settings.GetSelectedTab()
			GUI_Trades_V2.Destroy("BuyPreview")
			GUI_Trades_V2.Destroy("SellPreview")
			GUI_Settings.Create()
			GUI_Settings.Show(settingsTab)
		}
		else
			GUI_Settings.Create()
		statsWinExists := WinExist("ahk_id " GuiMyStats.Handle)
		if (statsWinExists) {
			GUI_MyStats.Create()
			GUI_MyStats.Show()
		}

		prevLang := lang
	}

	Show(whichTab="Settings") {
		global PROGRAM, GuiSettings, GuiTrades

		hw := DetectHiddenWindows("On")
		foundHwnd := WinExist("ahk_id " GuiSettings.Handle)
		DetectHiddenWindows(hw)

		if (foundHwnd) {
			if !(GuiTrades.SellPreview.Handle)
				GUI_Trades_V2.CreatePreview("Sell", PROGRAM.SETTINGS.SELL_INTERFACE.Mode)
			if !(GuiTrades.BuyPreview.Handle)
				GUI_Trades_V2.CreatePreview("Buy", PROGRAM.SETTINGS.BUY_INTERFACE.Mode)

			Gui, Settings:Show, xCenter yCenter
			Gui_Settings.OnTabBtnClick(whichTab)
		}
		else {
			AppendToLogs("GUI_Settings.Show(" whichTab "): Non existent. Recreating.")
			GUI_Settings.Create()
			GUI_Settings.Show()
		}
	}

	ResetToDefaultSettings() {
		global PROGRAM

		boxTxt := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.Settings_ConfirmResetToDefault, "%folder%", PROGRAM.TEMP_FOLDER)
		MsgBox(4096+48+4, "", boxTxt)

		IfMsgBox, Yes
		{
			settingsFile := PROGRAM.SETTINGS_FILE
			SplitPath, settingsFile, fileName
			FileMove,% settingsFile,% PROGRAM.TEMP_FOLDER "\" A_Now "_" fileName, 1
			Reload()
		}
	}

	Get_ActionForcedContent_From_ActionShortName(actionShortName) {
		global ACTIONS_FORCED_CONTENT

		forcedContent := ""
		for sName, fContent in ACTIONS_FORCED_CONTENT {
			if (sName = actionShortName) {
				forcedContent := fContent
				Break
			}
		}
		return forcedContent
	}

	Get_ActionTypeTip_From_ShortName(shortName) {
		global ACTIONS_TIPS
		return ACTIONS_TIPS[shortName]
	}

	Get_ActionLongName_From_ShortName(shortName) {
		global ACTIONS_TEXT_NAME

		return ACTIONS_TEXT_NAME[shortName]
	}

	Get_ActionShortName_From_LongName(longName) {
		global ACTIONS_TEXT_NAME

		for sName, lName in ACTIONS_TEXT_NAME
			if (lName = longName)
				return sName
	}

	OnTabBtnClick(whichTab) {
		global GuiTrades
		global GuiSettings, GuiSettings_Controls
		static prevTab

		if (whichTab = GUI_Settings.GetSelectedTab())
			return

		GuiControl, Settings:ChooseString,% GuiSettings_Controls.hTab_AllTabs,% whichTab

		GuiControl, Settings:+Disabled,% GuiSettings_Controls["hBTN_Tab" whichTab]
		GuiControl, Settings:-Disabled,% GuiSettings_Controls["hBTN_Tab" prevTab]
		prevTab := whichTab
		
		if (whichTab = "Selling") {
			if GUI_Trades_V2.Exists("SellPreview") {
				guiX := ( (GuiSettings.RightMost2-GuiSettings.LeftMost2) /2)-(GuiTrades.SellPreview.Width/2), guiX *= GuiSettings.Windows_DPI
				guiY := GuiSettings.UpMost2, guiY *= GuiSettings.Windows_DPI
				Gui, TradesSellPreview:+LastFound +AlwaysOnTop
				Gui, TradesSellPreview:Show,% "x" guiX " y" guiY
			}
			GUI_Settings.Customization_Selling_AdjustPreviewControls()
			GUI_Trades_V2.Preview_CustomizeThisCustomButton("SellPreview", GuiSettings.CUSTOM_BUTTON_SELECTED_ROW,	GuiSettings.CUSTOM_BUTTON_SELECTED_MAX,	GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)
		}
		else
			Gui, TradesSellPreview:Hide

		if (whichTab = "Buying") {
			if GUI_Trades_V2.Exists("BuyPreview") {
				guiX := ( (GuiSettings.RightMost2-GuiSettings.LeftMost2) /2)-(GuiTrades.BuyPreview.Width/2), guiX *= GuiSettings.Windows_DPI
				guiY := GuiSettings.UpMost2, guiY *= GuiSettings.Windows_DPI
				Gui, TradesBuyPreview:+LastFound +AlwaysOnTop
				Gui, TradesBuyPreview:Show,% "x" guiX " y" guiY
			}
			GUI_Settings.Customization_Buying_AdjustPreviewControls()
			GUI_Trades_V2.Preview_CustomizeThisCustomButton("BuyPreview", GuiSettings.CUSTOM_BUTTON_SELECTED_ROW,	GuiSettings.CUSTOM_BUTTON_SELECTED_MAX,	GuiSettings.CUSTOM_BUTTON_SELECTED_NUM)
		}
		else
			Gui, TradesBuyPreview:Hide
	}

	Submit(CtrlName="") {
		global GuiSettings_Submit
		Gui.Submit("Settings")

		if (CtrlName) {
			Return GuiSettings_Submit[ctrlName]
		}
	}

	ContextMenu(CtrlHwnd, CtrlName) {
		global PROGRAM, GuiSettings
		
	}

	GetSelectedTab() {
		return GUI_Settings.Submit("hTab_AllTabs")
	}

	GetControlToolTip(ctrlName) {
		global PROGRAM, DEBUG
		
		_tip := (ctrlName = "hSLIDER_NoTabsTransparency") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_NoTabsTransparency_ToolTip"]
			: (ctrlName = "hSLIDER_TabsOpenTransparency") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TabsOpenTransparency_ToolTip"]
			: (ctrlName = "hEDIT_TradingWhisperSFXPath") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hCB_TradingWhisperSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_RegularWhisperSFXPath") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hCB_RegularWhisperSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_BuyerJoinedAreaSFXPath") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hCB_BuyerJoinedAreaSFXToggle_ToolTip"]
			: (ctrlName = "hEDIT_PushBulletToken") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_PushBulletToken_ToolTip"]
			: (ctrlName = "hTEXT_GetPBNotificationsFor") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_PushBulletNotifications_ToolTip"]
			: (ctrlName = "hEDIT_PoeAccounts") ? 				PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_POEAccountsList_ToolTip"]
			: (ctrlName = "hLB_SkinPreset") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_Preset_ToolTip"]
			: (ctrlName = "hLB_SkinBase") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_SkinBase_ToolTip"]
			: (ctrlName = "hLB_SkinFont") ? 					PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TextFont_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinScalingPercentage,hUPDOWN_SkinScalingPercentage") ?		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_ScalingSize_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinFontSize,hUPDOWN_SkinFontSize") ? 						PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_FontSize_ToolTip"]
			: IsIn(ctrlName, "hEDIT_SkinFontQuality,hUPDOWN_SkinFontQuality") ?	 				PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_FontQuality_ToolTip"]
			: IsIn(ctrlName, "hDDL_ChangeableFontColorTypes,hPROGRESS_ColorSquarePreview") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_TextColor_ToolTip"]
			: IsContaining(ctrlName, "hBTN_CustomBtn_") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hBTN_CustomBtn_1_ToolTip"]
			: IsContaining(ctrlName, "hTEXT_CustomBtnSlot_") ? 		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_CustomBtnSlot_1_ToolTip"]
			: IsContaining(ctrlName, "hBTN_UnicodeBtn_") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hBTN_UnicodeBtn_1_ToolTip"]
			: IsContaining(ctrlName, "hTEXT_UnicodeBtnSlot_") ?		PROGRAM.TRANSLATIONS.GUI_Settings["hTEXT_UnicodeBtnSlot_1_ToolTip"]
			: IsContaining(ctrlName, "hDDL_HotkeyActionType") ? 	PROGRAM.TRANSLATIONS.GUI_Settings["hDDL_HotkeyActionType1_ToolTip"]
			: IsContaining(ctrlName, "hEDIT_HotkeyActionContent") ? PROGRAM.TRANSLATIONS.GUI_Settings["hEDIT_HotkeyActionContent1_ToolTip"]
			: IsContaining(ctrlName, "hCB_HotkeyToggle") ?		 	PROGRAM.TRANSLATIONS.GUI_Settings["hCB_HotkeyToggle1_ToolTip"]
			: IsContaining(ctrlName, "hHK_HotkeyKeys") ? 			PROGRAM.TRANSLATIONS.GUI_Settings["hHK_HotkeyKeys1_ToolTip"]
			: PROGRAM.TRANSLATIONS.GUI_Settings[ctrlName "_ToolTip"]

		if (DEBUG.SETTINGS.instant_settings_tooltips)
			_tip := _tip? _tip "`n`n" ctrlName : "No tooltip for this control`n`n" ctrlName

		if (DEBUG.SETTINGS.settings_copy_ctrlname && ctrlName)
			Set_Clipboard(ctrlName)

		return _tip
	}

	DestroyBtnImgList() {
		global GuiSettings_Controls

		for key, value in GuiSettings_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Redraw() {
		Gui, Settings: +LastFound
		WinSet, Redraw
	}

	GetListViewControlNameBasedOnTabName(tabName) {
		lvCtrlName := tabName="Selling"?"hLV_CustomizationSellingActionsList"
			: tabName="Buying"?"hLV_CustomizationBuyingActionsList"
			: tabName="Hotkeys"?"hLV_HotkeyActionsList"
			: ""
		return lvCtrlName
	}

	SetDefaultListViewBasedOnTabName(tabName) {
		lvCtrlName := GUI_Settings.GetListViewControlNameBasedOnTabName(tabName)
		GUI_Settings.SetDefaultListView(lvCtrlName)
	}

	SetDefaultListView(lvName) {
        global GuiSettings_Controls
        Gui, Settings:Default
        Gui, Settings:ListView,% GuiSettings_Controls[lvName]
    }

	Destroy() {
		GUI_Settings.DestroyBtnImgList()
		Gui.Destroy("Settings")
	}

	WM_MOUSEMOVE() {
		/* Settings: Allow dragging custom buttons
		*/
		global PROGRAM, DEBUG
		global GuiSettings, GuiSettings_Controls
		static mouseX, mouseY, prevMouseX, prevMouseY
		static ctrlToolTip, underMouseHwnd, prevUnderMouseHwnd, prevUnderMouseName

		if (A_Gui != "Settings")
			return
		MouseGetPos, mouseX, mouseY
		if (mouseX = prevMouseX && mouseY = prevMouseY)
			Return

		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)
		if (underMouseHwnd != prevUnderMouseHwnd) {

			ctrlToolTip := GUI_Settings.GetControlToolTip(underMouseName)
			if (ctrlToolTip)
				SetTimer, GUI_Settings_WM_MOUSEMOVE_DisplayToolTip,% DEBUG.SETTINGS.instant_settings_tooltips ? -10 : -1000
			else
				Gosub, GUI_Settings_WM_MOUSEMOVE_RemoveToolTip

			if IsIn(underMouseName, "hDDL_CustomizationBuyingActionType,hDDL_CustomizationSellingActionType,hDDL_HotkeyActionType") { ; Resize the action type DDL to fit all actions
				static ddlBak, editBak
				actionContentCtrlName := StrReplace(underMouseName, "hDDL_", "hEDIT_"), actionContentCtrlName := StrReplace(actionContentCtrlName, "ActionType", "ActionContent")
				ddlBak := Gui.GetControlPos(A_Gui, underMouseName), editBak := Gui.GetControlPos(A_Gui, actionContentCtrlName)
				Gui.MoveControl(A_Gui, underMouseName, "w" GuiSettings.AlternativeActionTypeDDLWidth)
				Gui.MoveControl(A_Gui, actionContentCtrlName, "x" ddlBak.X+GuiSettings.AlternativeActionTypeDDLWidth+(editBak.X- (ddlBak.X+ddlBak.W) ) " w" editBak.W-(GuiSettings.AlternativeActionTypeDDLWidth-ddlBak.W))
			}
			else if IsIn(prevUnderMouseName, "hDDL_CustomizationBuyingActionType,hDDL_CustomizationSellingActionType,hDDL_HotkeyActionType") { ; Put the controls back to normal size
				actionContentCtrlName := StrReplace(prevUnderMouseName, "hDDL_", "hEDIT_"), actionContentCtrlName := StrReplace(actionContentCtrlName, "ActionType", "ActionContent")
				Gui.MoveControl(A_Gui, prevUnderMouseName, "w" ddlBak.W)
				Gui.MoveControl(A_Gui, actionContentCtrlName, "x" editBak.X " w" editBak.W)
			}

			if RegExMatch(underMouseName, "hTEXT_.*ActionTypeTip") {
				ShowtoolTip(GUI_Settings.Submit(underMouseName))
			}

			prevUnderMouseHwnd := underMouseHwnd, prevUnderMouseName := underMouseName
		}
		return

		prevMouseX := mouseX, prevMouseY := mouseY
		return

		GUI_Settings_WM_MOUSEMOVE_DisplayToolTip:
			if (Get_UnderMouse_CtrlHwnd() != underMouseHwnd)
				return

			if (ctrlToolTip) {
				try ShowToolTip(ctrlToolTip)
				SetTimer, GUI_Settings_WM_MOUSEMOVE_RemoveToolTip, -20000
			}
			else {
				RemoveToolTip()
			}
		return

		GUI_Settings_WM_MOUSEMOVE_RemoveToolTip:
			RemoveToolTip()
		return
	}

	WM_LBUTTONDOWN() {
		global GuiSettings, GuiSettings_Controls

		if (A_Gui != "Settings")
			return

		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)

		if (underMouseName = "hEDIT_HotkeyProfileHotkey") {
			GuiSettings.HasClickedHotkeyEditBox := True
		}
	}

	WM_LBUTTONUP() {
		global GuiSettings, GuiSettings_Controls

		if (A_Gui != "Settings")
			return

		underMouseHwnd := Get_UnderMouse_CtrlHwnd(), underMouseName := Gui.Get_CtrlVarName_From_Hwnd(A_Gui, underMouseHwnd)

		if (GuiSettings.HasClickedHotkeyEditBox) {
			GUI_Settings.TabHotkeys_ChangeHotkeyProfileHotkey()
		}
		GuiSettings.HasClickedHotkeyEditBox := False
	}
}

/*
	Labels 
*/

GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions:
	global SaveAllCurrentSellingActions_After100ms
	GUI_Settings.Customization_Selling_SaveAllCurrentButtonActions(isTimedSave:=True)
	if (SaveAllCurrentSellingActions_After100ms=True) {
		SaveAllCurrentSellingActions_After100ms := False
		GoSub GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer_2
	}
return
GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer:
	global SaveAllCurrentSellingActions_After100ms
	SaveAllCurrentSellingActions_After100ms := True
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, -100
return
GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions_Timer_2:
	; Starts 100ms after saving to make sure save is ok
	global SaveAllCurrentSellingActions_After100ms
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Selling_SaveAllCurrentButtonActions, -100
return

GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions:
	global SaveAllCurrentBuyingActions_After100ms
	GUI_Settings.Customization_Buying_SaveAllCurrentButtonActions(isTimedSave:=True)
	if (SaveAllCurrentBuyingActions_After100ms=True) {
		SaveAllCurrentBuyingActions_After100ms := False
		GoSub GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer_2
	}
return
GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer:
	global SaveAllCurrentBuyingActions_After100ms
	SaveAllCurrentBuyingActions_After100ms := True
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, -100
return
GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions_Timer_2:
	; Starts 100ms after saving to make sure save is ok
	global SaveAllCurrentBuyingActions_After100ms
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, Delete
	SetTimer, GUI_Settings_Customization_Buying_SaveAllCurrentButtonActions, -100
return

GUI_Settings_Hotkeys_SaveAllActions:
	global SaveAllHotkeysActions_After100ms
	GUI_Settings.Universal_SaveAllActions("Hotkeys", isTimedSave:=True)
	if (SaveAllHotkeysActions_After100ms=True) {
		SaveAllHotkeysActions_After100ms := False
		GoSub GUI_Settings_Hotkeys_SaveAllActions_Timer_2
	}
return
GUI_Settings_Hotkeys_SaveAllActions_Timer:
	global SaveAllHotkeysActions_After100ms
	SaveAllHotkeysActions_After100ms := True
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, Delete
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, -100
return
GUI_Settings_Hotkeys_SaveAllActions_Timer_2:
	; Starts 100ms after saving to make sure save is ok
	global SaveAllHotkeysActions_After100ms
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, Delete
	SetTimer, GUI_Settings_Hotkeys_SaveAllActions, -100
return


GUI_Settings_Customization_Selling_OnButtonNameChange:
	GUI_Settings.Customization_Selling_OnButtonNameChange(doAgainAfter100ms:=False)
return
GUI_Settings_Customization_Selling_OnButtonNameChange_Timer:
	SetTimer, GUI_Settings_Customization_Selling_OnButtonNameChange, Delete
	SetTimer, GUI_Settings_Customization_Selling_OnButtonNameChange, -100
return

GUI_Settings_Customization_Buying_OnButtonNameChange:
	GUI_Settings.Customization_Buying_OnButtonNameChange(doAgainAfter100ms:=False)
return
GUI_Settings_Customization_Buying_OnButtonNameChange_Timer:
	SetTimer, GUI_Settings_Customization_Buying_OnButtonNameChange, Delete
	SetTimer, GUI_Settings_Customization_Buying_OnButtonNameChange, -100
return

GUI_Settings_Customization_Selling_OnActionContentChange:
	GUI_Settings.Customization_Selling_OnActionContentChange(doAgainAfter100ms:=False)
return
GUI_Settings_Customization_Selling_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Customization_Selling_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Customization_Selling_OnActionContentChange, -100
return

GUI_Settings_Customization_Buying_OnActionContentChange:
	GUI_Settings.Customization_Buying_OnActionContentChange(doAgainAfter100ms:=False)
return
GUI_Settings_Customization_Buying_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Customization_Buying_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Customization_Buying_OnActionContentChange, -100
return

GUI_Settings_Hotkeys_OnActionContentChange:
	GUI_Settings.Universal_OnActionContentChange("Hotkeys", doAgainAfter100ms:=False)
return
GUI_Settings_Hotkeys_OnActionContentChange_Timer:
	SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, Delete
	SetTimer, GUI_Settings_Hotkeys_OnActionContentChange, -100
return

GUI_Settings_Hotkeys_OnHotkeyProfileNameChange:
	GUI_Settings.TabHotkeys_OnHotkeyProfileNameChange(doAgainAfter100ms:=False)
return
GUI_Settings_Hotkeys_OnHotkeyProfileNameChange_Timer:
	SetTimer, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange, Delete
	SetTimer, GUI_Settings_Hotkeys_OnHotkeyProfileNameChange, -100
return


GUI_Settings_TabCustomizationSkins_OnScalePercentageChange_Sub:
	GuiControl, Settings:ChooseString,% GuiSettings_Controls.hLB_SkinPreset,% "Custom"
	GUI_Settings.TabCustomizationSkins_SaveSettings()
return