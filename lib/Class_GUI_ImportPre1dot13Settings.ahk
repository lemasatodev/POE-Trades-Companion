; GUI_ImportPre1dot13Settings.Show()
; esc::exitapp

Class GUI_ImportPre1dot13Settings {
    Create() {
        global PROGRAM, MyDocuments
        global GuiImportPre1dot13Settings, GuiImportPre1dot13Settings_Controls, GuiImportPre1dot13Settings_Submit
        
        GUI_ImportPre1dot13Settings.Destroy()
		Gui.New("ImportPre1dot13Settings", "-Caption -Border +LabelGUI_ImportPre1dot13Settings_ +HwndhGuiImportPre1dot13Settings", "POE TC - Importing pre-1.13 settings")
		GuiImportPre1dot13Settings.Is_Created := False

		guiCreated := False
		guiFullHeight := 285, guiFullWidth := 520, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

        Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

        Gui.Margin("ImportPre1dot13Settings", 0, 0)
		Gui.Color("ImportPre1dot13Settings", "White")
		Gui.Font("ImportPre1dot13Settings", "Segoe UI", "8")

        ; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right

		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("ImportPre1dot13Settings", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		; * * Title bar
        Gui.Add("ImportPre1dot13Settings", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("ImportPre1dot13Settings", "Progress", "xp yp wp hp Background359cfc") ; Title bar background
		Gui.Add("ImportPre1dot13Settings", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - Importing pre-1.13 settings") ; Title bar text
		imageBtnLog .= Gui.Add("ImportPre1dot13Settings", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_ImportPre1dot13Settings.DragGui.bind(GUI_ImportPre1dot13Settings, GuiImportPre1dot13Settings.Handle)
		GuiControl, ImportPre1dot13Settings:+g,% GuiImportPre1dot13Settings_Controls.hTEXT_HeaderGhost,% __f
		__f := GUI_ImportPre1dot13Settings.Close.bind(GUI_ImportPre1dot13Settings)
		GuiControl, ImportPre1dot13Settings:+g,% GuiImportPre1dot13Settings_Controls.hBTN_CloseGUI,% __f

        ; * * Text
        Gui.Add("ImportPre1dot13Settings", "Text", "x" leftMost+10 " y+10 w" guiWidth-20 " hwndhTEXT_Welcome", ""
            .       "Welcome to " PROGRAM.NAME " v" PROGRAM.VERSION "!"
            . "`n"
            . "`n"  "Many changes were brought code-wise and the settings file structure need to be re-adapted."
            . "`n"  "Would you like to import your previous settings, or start with the new defaults?"
            . "`n"
            . "`n"  "Your old settings file will be kept as a backup."
            . "`n"  "Only your settings (and your trades history) will be imported. If you added custom skins, or fonts, you will be required to move them in the new folder."
            . "`n"  "Old folder: """ MyDocuments "\AutoHotkey\POE Trades Companion\"""
            . "`n"  "New folder: """ PROGRAM.MAIN_FOLDER """"
            . "`n"
            . "`n"  "In case something happens, you can always reset your settings from the Settings menu (right click on the tray icon)."
            . "")

        Gui.Add("ImportPre1dot13Settings", "Button", "x" leftMost+10 " y+15 w" (guiWidth-20)/2-6 " h50 hwndhBTN_Yes", "Yes. Import pre-1.13 settings.`n(You will have access to all your old settings)")
        Gui.Add("ImportPre1dot13Settings", "Button", "x+10 yp wp h50 hwndhBTN_No", "No. Don't import`n(You will keep 1.13 betas settings`nif they exist, or start fresh if not)")
        __f := GUI_ImportPre1dot13Settings.Choice.bind(GUI_ImportPre1dot13Settings, "Yes")
		GuiControl, ImportPre1dot13Settings:+g,% GuiImportPre1dot13Settings_Controls.hBTN_Yes,% __f
		__f := GUI_ImportPre1dot13Settings.Choice.bind(GUI_ImportPre1dot13Settings, "No")
		GuiControl, ImportPre1dot13Settings:+g,% GuiImportPre1dot13Settings_Controls.hBTN_No,% __f

        Gui.Show("ImportPre1dot13Settings", "xCenter yCenter w" guiWidth " h" guiHeight)
        return
    }

    Choice(what) {
        global MyDocuments

        Gui, ImportPre1dot13Settings:+Disabled
        
        if (what="Yes") {
            ; getting old settings converted to new
            settings := Get_Pre1dot13_Settings()
            settingsAppend := ""
            for iniSect, nothing in settings {
                AppendToLogs(A_ThisFunc "(): Parsing old settings converted to new. Section: " iniSect)
                for iniKey, iniValue in settings[iniSect] {
                    if (iniKey) && (iniValue) {
                        if (sect%iniSect% != True) {
                            sect%iniSect% := True
                            settingsAppend .= SubStr(settingsAppend, 0) = "`n" ? "[" iniSect "]`n" : "`n[" iniSect "]`n"
                        }
                        settingsAppend .= iniKey "=" iniValue "`n"
                    }
                }
            }
        }

        historyAppend := ""
        oldHistory := Get_Pre1dot13_TradeHistory()
        AppendToLogs(A_ThisFunc "(): Old history retrieved. Total index: " oldHistory.Length())
        if FileExist(PROGRAM.TRADES_HISTORY_FILE) {
            newHistory := GUI_MyStats.GetData()
            AppendToLogs(A_ThisFunc "(): New history retrieved. Total index: " newHistory.Length() )
        }
        historyIndex := 0
        for index, nothing in oldHistory {
            if IsNum(index) {
                AppendToLogs(A_ThisFunc "(): Parsing old history. Section: " index)
                historyIndex++
                historyAppend .= SubStr(historyAppend, 0) = "`n" ? "[" historyIndex "]`n" : "`n[" historyIndex "]`n"
                for iniKey, iniValue in oldHistory[index] {
                    historyAppend .= SubStr(historyAppend, 0) = "`n" ? iniKey "=" iniValue : "`n" iniKey "=" iniValue
                }
            }
        }
        for index, nothing in newHistory {
            if IsNum(index) {
                AppendToLogs(A_ThisFunc "(): Parsing new history. Section: " index)
                historyIndex++
                historyAppend .= SubStr(historyAppend, 0) = "`n" ? "[" historyIndex "]`n" : "`n[" historyIndex "]`n"
                for iniKey, iniValue in newHistory[index] {           
                    historyAppend .= SubStr(historyAppend, 0) = "`n" ? iniKey "=" iniValue : "`n" iniKey "=" iniValue
                }
            }
        }
        historyAppend := "[GENERAL]`nIndex=" historyIndex "`n" historyAppend
        
        oldHistoryFilePath := MyDocuments "\AutoHotkey\POE Trades Companion\Trades_History.ini"
        newHistoryFilePath := PROGRAM.TRADES_HISTORY_FILE
        oldSettingsFilePath := MyDocuments "\AutoHotkey\POE Trades Companion\Preferences.ini"
        newSettingsFilePath := PROGRAM.INI_FILE

        ; Rename old prefs file, to avoid detecing again
        if FileExist(oldSettingsFilePath) {
            SplitPath, oldSettingsFilePath, , folder
            FileMove,% oldSettingsFilePath,% folder "\" A_Now "_Preferences.ini", 1
        }
        if (what="Yes") {
            ; Rename current prefs file, set new content
            if FileExist(newSettingsFilePath) {
                SplitPath, newSettingsFilePath, , folder
                FileMove,% newSettingsFilePath,% folder "\" A_Now "_Preferences.ini", 1
            }
            FileAppend,% "`n" settingsAppend,% newSettingsFilePath
        }
        ; Rename old history file, to avoid detecing again
        if FileExist(oldHistoryFilePath) {
            SplitPath, oldHistoryFilePath, , folder
            FileMove,% oldHistoryFilePath,% folder "\" A_Now "_Trades_History.ini", 1
        }
        ; Rename current history file, set new content
        if FileExist(newHistoryFilePath) {
            SplitPath, newHistoryFilePath, , folder
            FileMove,% newHistoryFilePath,% folder "\" A_Now "_Trades_History.ini", 1
        }
        FileAppend,% "`n" historyAppend,% newHistoryFilePath


        msgboxTxt := "Done importing"
        msgboxTxt .= what="Yes"? " old settings and" : ""
        msgboxTxt .= " saved trades history."
        MsgBox(4096+64, "", msgboxTxt)
        GUI_ImportPre1dot13Settings.Destroy()
    }

    Show() {
		global GuiImportPre1dot13Settings

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiImportPre1dot13Settings.Handle)
		DetectHiddenWindows, %hiddenWin%

		GUI_MyStats.UpdateData()

		if (foundHwnd) {
			Gui, ImportPre1dot13Settings:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_ImportPre1dot13Settings.Show(): Non existent. Recreating.")
			GUI_ImportPre1dot13Settings.Create()
			GUI_ImportPre1dot13Settings.Show()
		}
	}

    DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

    Close() {
        MsgBox(4096+48, "", "Please make your choice!"
        . "`n" "This prompt will only appear once.")
    }

    DestroyBtnImgList() {
		global GuiImportPre1dot13Settings_Controls

		for key, value in GuiImportPre1dot13Settings_Controls
			IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

    Destroy() {
        GUI_ImportPre1dot13Settings.DestroyBtnImgList()
        GUI.Destroy("ImportPre1dot13Settings")
    }
}

Get_Pre1dot13_TradeHistory() {
    global MyDocuments
    oldHistory := MyDocuments "\AutoHotkey\POE Trades Companion\Trades_History.ini"

    if FileExist(oldHistory) {
        AppendToLogs(A_ThisFunc "(): Detected old trades history file. Retrieving settings.")
        oldHistoryObj := {}
        Loop, Parse,% INI.Get(oldHistory), "`n"
        {
            oldHistoryObj[A_LoopField] := {}

            arr := INI.Get(oldHistory, A_LoopField,,1)
            for key, value in arr
                oldHistoryObj[A_LoopField][key] := value
        }

        return oldHistoryObj
    }
    else 
        AppendToLogs(A_ThisFunc "(): Old trades history file not detected. No import.")
}

Get_Pre1dot13_Settings() {
    global MyDocuments
    oldIni := MyDocuments "\AutoHotkey\POE Trades Companion\Preferences.ini"
 
    if FileExist(oldIni) {
        AppendToLogs(A_ThisFunc "(): Detected old ini file. Retrieving settings.")
        ; Creating new settings obj
        newSettingsObj := {}
        sections := "GENERAL,UPDATING,SETTINGS_MAIN,SETTINGS_CUSTOMIZATION_SKINS,SETTINGS_CUSTOMIZATION_SKINS_UserDefined"
        Loop 9
            sections .= ",SETTINGS_CUSTOM_BUTTON_" A_Index
        Loop 5
            sections .= ",SETTINGS_SPECIAL_BUTTON_" A_Index
        Loop 8
            sections .= ",SETTINGS_HOTKEY_" A_Index
        Loop 16
            sections .= ",SETTINGS_HOTKEY_ADV_" A_Index
        Loop, Parse, sections,% ","
        {
            newSettingsObj[A_LoopField] := {}
        }


        ; Retrieving old settings, put into obj
        oldSettingsObj := {}
        Loop, Parse,% INI.Get(oldIni), "`n"
        {
            oldSettingsObj[A_LoopField] := {}

            arr := INI.Get(oldIni, A_LoopField,,1)
            for key, value in arr
                oldSettingsObj[A_LoopField][key] := value
        }


        ; Settings
        if (oldSettingsObj.PROGRAM.AutoUpdate = 1)
            newSettingsObj.UPDATING.DownloadUpdatesAutomatically := "True"

        newAndOld := { "TabsOpenTransparency"   : "Transparency"
            , "NoTabsTransparency"              : "Transparency_Active"
            , "AutoMinimizeOnAllTabsClosed"     : "Trades_Auto_Minimize"
            , "AutoMaximizeOnFirstNewTab"       : "Trades_Auto_UnMinimize"
            , "Trades_Click_Through"            : "AllowClicksToPassThroughWhileInactive"
            , "Trades_Select_Last_Tab"          : "AutoFocusNewTabs" }
        for newKey, oldKey in newAndOld {
            oldValue := oldSettingsObj.SETTINGS[oldKey]
            if IsIn(oldKey, "Transparency,Transparency_Active")
                oldValue := Round( (oldValue / 255) * 100 )

            newSettingsObj.SETTINGS_MAIN[newKey] := oldValue=1?"True" : oldValue=0?"False" : oldValue
        }
        if (oldSettingsObj.SETTINGS.Show_Mode = "InGame")
            newSettingsObj.SETTINGS_MAIN.HideInterfaceWhenOutOfGame := "True"
            

        ; Notifications
        newAndOld := { "TradingWhisperSFXToggle"        : "Trade_Toggle"
            , "TradingWhisperSFXPath"                   : "Trade_Sound_Path"
            , "RegularWhisperSFXToggle"                 : "Whisper_Toggle"
            , "RegularWhisperSFXPath"                   : "Whisper_Sound_Path"
            , "ShowTabbedTrayNotificationOnWhisper"     : "Whisper_Tray"
            , "BuyerJoinedAreaSFXToggle"                : "JoinedArea_Toggle"
            , "BuyerJoinedAreaSFXPath"                  : "JoinedArea_Sound_Path" }
        for newKey, oldKey in newAndOld {
            oldValue := oldSettingsObj.NOTIFICATIONS[oldKey]
            if InStr(oldValue, "Toggle")
                oldValue := oldValue=1?"True" : oldValue=0?"False" : oldValue

            newSettingsObj.SETTINGS_MAIN[newKey] := oldValue
        }


        ; Skin settings
        if IsIn(oldSettingsObj.CUSTOMIZATION_APPEARANCE.Active_Preset, "System,White,Dark Blue,Path of Exile,User Defined")
        && IsIn(oldSettingsObj.CUSTOMIZATION_APPEARANCE.Active_Skin, "System,White,Dark Blue,Path of Exile,User Defined") {
            if (oldSettingsObj.CUSTOMIZATION_APPEARANCE.Active_Preset = "User Defined") {
                newAndOld := { "Skin"                   : "Active_Skin"
                    , "Preset"                          : "Active_Preset"
                    , "Font"                            : "Font"
                    , "ScalingPercentage"               : "Scale_Multiplier"
                    , "FontSize"                        : "Font_Size_Custom"
                    , "FontQuality"                     : "Font_Quality_Custom"
                    , "Color_Button_Hover"              : "Color_Button_Hover"
                    , "Color_Button_Normal"             : "Color_Button_Normal"
                    , "Color_Button_Press"              : "Color_Button_Press"
                    , "Color_Border"                    : "Color_Border"
                    , "Color_Tab_Active"                : "Color_Tab_Active"
                    , "Color_Tab_Hover"                 : "Color_Tab_Hover"
                    , "Color_Tab_Inactive"              : "Color_Tab_Inactive"
                    , "Color_Tab_Joined_Active"         : "Color_Tab_Joined_Active"
                    , "Color_Tab_Joined_Hover"          : "Color_Tab_Joined_Hover"
                    , "Color_Tab_Joined_Inactive"       : "Color_Tab_Joined_Inactive"
                    , "Color_Tab_Joined_Press"          : "Color_Tab_Joined_Press"
                    , "Color_Tab_Press"                 : "Color_Tab_Press"
                    , "Color_Tab_Whisper_Active"        : "Color_Tab_Whisper_Active"
                    , "Color_Tab_Whisper_Hover"         : "Color_Tab_Whisper_Hover"
                    , "Color_Tab_Whisper_Inactive"      : "Color_Tab_Whisper_Inactive"
                    , "Color_Tab_Whisper_Press"         : "Color_Tab_Whisper_Press"
                    , "Color_Title_No_Trades"           : "Color_Title_Inactive"
                    , "Color_Title_Trades"              : "Color_Title_Active"
                    , "Color_Trade_Info_1"              : "Color_Trades_Infos_1"
                    , "Color_Trade_Info_2"              : "Color_Trades_Infos_2" }

                newSettingsObj.SETTINGS_CUSTOMIZATION_SKINS["Preset"] := "User Defined"
                for newKey, oldKey in newAndOld {
                    value := oldSettingsObj.CUSTOMIZATION_APPEARANCE[oldKey]

                    if (oldKey = "Scale_Multiplier")
                        value := StrReplace(value, ".", "")
                    else if InStr(newKey, "Color_") && !InStr(value, "0x")
                        value := "0x" value
                    
                    newSettingsObj.SETTINGS_CUSTOMIZATION_SKINS_UserDefined[newKey] := value
                }
                if (oldSettingsObj.CUSTOMIZATION_APPEARANCE.Font_Size_Mode != "Automatic")
                && (oldSettingsObj.CUSTOMIZATION_APPEARANCE.Font_Quality_Mode != "Automatic")
                    newSettingsObj.SETTINGS_CUSTOMIZATION_SKINS_UserDefined["UseRecommendedFontSettings"] := "True"
                else
                    SETTINGS_CUSTOMIZATION_SKINS_UserDefined["UseRecommendedFontSettings"] := "False"
            }
        }
        else { ; error skin unknown
            ; MsgBox,% 4096+16, POE Trades Companion,% "Custom skin detected."
        }

        ; Hotkeys
        hkIndex := 0
        Loop 8 {
            oldToggle := oldSettingsObj.HOTKEYS["HK" A_Index "_Toggle"]
            oldTxt := oldSettingsObj.HOTKEYS["HK" A_Index "_Text"]
            oldKey := oldSettingsObj.HOTKEYS["HK" A_Index "_KEY"]
            
            if (oldTxt = """Insert Command or Message""") || (oldTxt = """""")
                newTxt := "", newAcType := ""
            else
                newTxt := oldTxt, newAcType := "SEND_MSG"
            newKey := oldKey, newToggle := oldToggle=1?"True" : "False"

            if (newKey && newToggle = "True")
                hkIndex++

            newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Enabled"] := newToggle
            newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Hotkey"] := newKey
            newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Type"] := newAcType
            newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Content"] := newTxt
        }
        ; Advanced hotkeys
        hkAdvIndex := 0
        Loop 16 {
            oldToggle := oldSettingsObj.HOTKEYS_ADVANCED["HK" A_Index "_ADV_Toggle"]
            oldTxt := oldSettingsObj.HOTKEYS_ADVANCED["HK" A_Index "_ADV_Text"]
            oldKey := oldSettingsObj.HOTKEYS_ADVANCED["HK" A_Index "_ADV_KEY"]

            if (oldTxt = """""") || (oldTxt = """Insert Command or Message""")
                newTxt := "", newAcType := ""
            else
                newTxt := oldTxt, newAcType := "SENDINPUT"
            newKey := oldKey && oldToggle = 1 ? oldKey : ""

            if (newTxt) {
                hkAdvIndex++
                newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Hotkey"] := newKey
                newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Name"] := "Unnamed hotkey " hkAdvIndex
                newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_1_Type"] := newAcType
                newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_1_Content"] := newTxt
            }
        }
        

        ; Custom Buttons
        oldPosToNewPos := {"Left": 1, "Center": 2, "Right": 3, "Top": 0, "Middle": 3, "Bottom": 6}
        Loop 9 {
            cbIndex := A_Index
            oldName := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Label"]
            oldAction := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Action"]
            oldH := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_H"]
            oldV := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_V"]
            oldSize := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_SIZE"]
            oldKey := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Hotkey"]
            oldMsg1 := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Message_1"]
            oldMsg2 := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Message_2"]
            oldMsg3 := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Message_3"]
            oldSaveStats := oldSettingsObj.CUSTOMIZATION_BUTTONS_ACTIONS["Button" cbIndex "_Mark_Completed"]

            newName := oldName
            newPos := oldPosToNewPos[oldH]+oldPosToNewPos[oldV]
            newToggle := oldSize="Disabled" ? "False" : "True"
            newSize := IsIn(oldSize, "Small,Medium,Large") ? oldSize : "Small"

            newSettingsObj["SETTINGS_CUSTOM_BUTTON_" A_Index].Name := newName
            newSettingsObj["SETTINGS_CUSTOM_BUTTON_" A_Index].Size := newSize
            newSettingsObj["SETTINGS_CUSTOM_BUTTON_" A_Index].Slot := newPos
            newSettingsObj["SETTINGS_CUSTOM_BUTTON_" A_Index].Enabled := newToggle

            cbNewActions := {}, cbActionsIndex := 0
            Loop 3 {
                loopedMsg := oldMsg%A_Index%

                if IsContaining(loopedMsg, "/invite %buyerName%") {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "INVITE_BUYER", cbNewActions["Action_" cbActionsIndex "_Content"] := loopedMsg
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "SHOW_GRID", cbNewActions["Action_" cbActionsIndex "_Content"] := """"""
                }
                else if IsContaining(loopedMsg, "/kick %buyerName%") {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "KICK_BUYER", cbNewActions["Action_" cbActionsIndex "_Content"] := loopedMsg
                }
                else if IsContaining(loopedMsg, "@%buyerName%") {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "SEND_TO_BUYER", cbNewActions["Action_" cbActionsIndex "_Content"] := loopedMsg
                }
                else if IsContaining(loopedMsg, "/tradewith %buyerName%") {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "TRADE_BUYER", cbNewActions["Action_" cbActionsIndex "_Content"] := loopedMsg
                }
                else if (loopedMsg && loopedMsg != """""") {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "SEND_MSG", cbNewActions["Action_" cbActionsIndex "_Content"] := loopedMsg
                }
            }

            if (oldAction = "Clipboard Item") {
                cbActionsIndex++
                cbNewActions["Action_" cbActionsIndex "_Type"] := "COPY_ITEM_INFOS", cbNewActions["Action_" cbActionsIndex "_Content"] := """"""
            }
            else if (oldAction = "Send Message + Minimize") {
                cbActionsIndex++
                cbNewActions["Action_" cbActionsIndex "_Type"] := "FORCE_MIN", cbNewActions["Action_" cbActionsIndex "_Content"] := """"""
            }
            else if (oldAction = "Send Message + Close Tab") {
                cbActionsIndex++
                cbNewActions["Action_" cbActionsIndex "_Type"] := "CLOSE_TAB", cbNewActions["Action_" cbActionsIndex "_Content"] := """"""
                if (oldSaveStats = 1) {
                    cbActionsIndex++
                    cbNewActions["Action_" cbActionsIndex "_Type"] := "SAVE_TRADE_STATS", cbNewActions["Action_" cbActionsIndex "_Content"] := """"""
                }
            }

            for key, value in cbNewActions {
                newSettingsObj["SETTINGS_CUSTOM_BUTTON_" cbIndex][key] := value
            }
        }

        ; Special Buttons
        specialsType := ["Clipboard", "Whisper", "Invite", "Trade", "Kick"]
        specialsActions := ["COPY_ITEM_INFOS", "WRITE_TO_BUYER", "INVITE_BUYER", "TRADE_BUYER", "KICK_BUYER"]
        Loop 5 {
            oldPos := oldSettingsObj.CUSTOMIZATION_BUTTONS_UNICODE["Button_Unicode_" A_Index "_Position"]
            oldKeyToggle := oldSettingsObj.CUSTOMIZATION_BUTTONS_UNICODE["Button_Unicode_" A_Index "_Hotkey_Toggle"]
            oldKey := oldSettingsObj.CUSTOMIZATION_BUTTONS_UNICODE["Button_Unicode_" A_Index "_Hotkey"]
            
            newToggle := oldPos="Disabled" ? "False" : "True", newPos := oldPos, newKey := oldKey
            if (newToggle = "True" && newKey) {
                if (A_Index = 3) { ; Invite, need two actions. Adv hotkey
                    hkAdvIndex++
                    newTxt1 := """""", newTxt2 := """""", newAcType1 := specialsActions[A_Index], newAcType2 := "SHOW_GRID"

                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Hotkey"] := newKey
                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Name"] := "Part invite + Item grid"
                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_1_Type"] := newAcType1
                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_1_Content"] := newTxt1
                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_2_Type"] := newAcType2
                    newSettingsObj["SETTINGS_HOTKEY_ADV_" hkAdvIndex]["Action_2_Content"] := newTxt2
                }
                else { ; Only one action. Basic hotkey
                    hkIndex++
                    newTxt := """""", newAcType := specialsActions[A_Index]
                    
                    newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Enabled"] := newToggle
                    newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Hotkey"] := newKey
                    newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Type"] := newAcType
                    newSettingsObj["SETTINGS_HOTKEY_" A_Index]["Content"] := newTxt
                }
            }
            
            newSettingsObj["SETTINGS_SPECIAL_BUTTON_" A_Index]["Enabled"] := newToggle
            newSettingsObj["SETTINGS_SPECIAL_BUTTON_" A_Index]["Slot"] := newPos
            newSettingsObj["SETTINGS_SPECIAL_BUTTON_" A_Index]["Type"] := specialsType[A_Index]
        }
        
        return newSettingsObj
    }
    else 
        AppendToLogs(A_ThisFunc "(): Old ini file not detected. No import.")
}
