Class GUI_ChooseLang {
	
	Create(param="") {
		global PROGRAM, GAME
		global GuiChooseLang, GuiChooseLang_Controls, GuiChooseLang_Submit
		static guiCreated
		windowsDPI := Get_DpiFactor()

		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		GUI_ChooseLang.Destroy()
		Gui.New("ChooseLang", "-Caption -Border +AlwaysOnTop +LabelGUI_ChooseLang_ +HwndhGuiChooseLang", "POE TC - Language")
		GuiChooseLang.Is_Created := False
		GuiChooseLang.Windows_DPI := windowsDPI

		guiCreated := False
		guiFullHeight := 200, guiFullWidth := 320, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		GuiChooseLang.Style_CloseBtn := Style_CloseBtn := [ [0, "0xe01f1f", "", "White"] ; normal
			, [0, "0xb00c0c"] ; hover
			, [0, "0x8a0a0a"] ] ; press

		GuiChooseLang.Style_Button := Style_Button := [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"] ; normal
			, [0, "0x355e73"] ; hover
			, [0, "0x122630"] ] ; press

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("ChooseLang", 0, 0)
		Gui.Color("ChooseLang", "0x1c4563", "0x274554")
		Gui.Font("ChooseLang", "Segoe UI", "8", "5", "0x80c4ff")
		Gui, ChooseLang:Default 

		; *	* Borders
		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right
		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("ChooseLang", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " Background" borderColor)

		fakeSelectedBordersPos := [{Position:"Top", X:0, Y:0, W:37, H:2}, {Position:"Left", X:0, Y:0, W:2, H:26} ; Top and Left
			,{Position:"Bottom", X:0, Y:0, W:37, H:2}, {Position:"Right", X:0, Y:0, W:2, H:26}] ; Bottom and right
		Loop 4 
			Gui.Add("ChooseLang", "Progress", "x" fakeSelectedBordersPos[A_Index]["X"] " y" fakeSelectedBordersPos[A_Index]["Y"] " w" fakeSelectedBordersPos[A_Index]["W"] " h" fakeSelectedBordersPos[A_Index]["H"] " hwndhPROGRESS_BorderSelected" fakeSelectedBordersPos[A_index]["Position"] " Hidden Background5bcff")

		; * * Title Bar
		Gui.Add("ChooseLang", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("ChooseLang", "Progress", "xp yp wp hp Background359cfc") ; Title bar background
		Gui.Add("ChooseLang", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - Language") ; Title bar text
		Gui.Add("ChooseLang", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_CloseBtn, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_ChooseLang.DragGui.bind(GUI_ChooseLang, GuiChooseLang.Handle)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls.hTEXT_HeaderGhost,% __f
		__f := GUI_ChooseLang.Close.bind(GUI_ChooseLang)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls.hBTN_CloseGUI,% __f

		; * * TOP TEXT
		Gui.Add("ChooseLang", "Text", "x" leftMost+10 " y+20 w" guiWidth-20 " Center BackgroundTrans hwndhTEXT_TopText", PROGRAM.TRANSLATIONS.GUI_ChooseLang.hTEXT_TopText)
		; * * FLAGS
		; Calculate the space between each
		iconW := 35, iconH := 24, iconMax := 6
		spaceBetweenIcons := ( (guiWidth-20) /iconMax), iconsPerRow := 6
		firstIconX := (guiWidth-(spaceBetweenIcons*(iconsPerRow-1)+iconW))/2 ; We retrieve the blank space after the lastest icon in the row
																				 ;	then divide this space in two so icons are centered
		Gui.Add("ChooseLang", "Picture", "x" firstIconX " y+35 w" iconW " h" iconH " hwndhIMG_FlagUK", PROGRAM.IMAGES_FOLDER "\flag_uk.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagFrance", PROGRAM.IMAGES_FOLDER "\flag_france.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagChina", PROGRAM.IMAGES_FOLDER "\flag_china.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagTaiwan", PROGRAM.IMAGES_FOLDER "\flag_taiwan.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagRussia", PROGRAM.IMAGES_FOLDER "\flag_russia.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagPortugal", PROGRAM.IMAGES_FOLDER "\flag_portugal.png")

		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "english")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagUK"],% __f
		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "french")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagFrance"],% __f
		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "chinese_simplified")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagChina"],% __f
		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "chinese_traditional")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagTaiwan"],% __f
		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "russian")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagRussia"],% __f
		__f := GUI_ChooseLang.OnLanguageChange.bind(GUI_ChooseLang, "portuguese")
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hIMG_FlagPortugal"],% __f

		Gui.Add("ChooseLang", "ImageButton", "x" leftMost+10 " y+15 w" guiWidth-20 " h30 hwndhBTN_AcceptLang", PROGRAM.TRANSLATIONS.GUI_ChooseLang.hBTN_AcceptLang, Style_Button, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_ChooseLang.AcceptLang.bind(GUI_ChooseLang)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hBTN_AcceptLang"],% __f

        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (GuiChooseLang.ImageButton_Errors) {
			AppendToLogs(GuiChooseLang.ImageButton_Errors)
			TrayNotifications.Show("Choose Language Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		GuiChooseLang.Flags := {english:"UK",french:"France",chinese_simplified:"China",chinese_traditional:"Taiwan",russian:"Russia",portuguese:"Portugal"}
		global GuiChooseLang_LANG_Temp := PROGRAM.SETTINGS.GENERAL.Language
		GUI_ChooseLang.SelectFlagBasedOnLanguage(GuiChooseLang_LANG_Temp)

		Gui.Show("ChooseLang", "h" guiHeight " w" guiWidth " Hide NoActivate")
		SetControlDelay(delay), SetBatchLines(batch)
		
        Return
    }

	AcceptLang() {
		global PROGRAM, GuiChooseLang, GuiChooseLang_LANG, GuiChooseLang_LANG_Temp

		GuiChooseLang_LANG_Temp := GuiChooseLang_LANG_Temp != "" ? GuiChooseLang_LANG_Temp : "english"
		PROGRAM.SETTINGS.GENERAL.Language := GuiChooseLang_LANG_Temp
		PROGRAM.SETTINGS.GENERAL.AskForLanguage := "False"
		Save_LocalSettings()
		PROGRAM.TRANSLATIONS := GetTranslations(GuiChooseLang_LANG_Temp)

		GuiChooseLang_LANG := GuiChooseLang_LANG_Temp
		GUI_ChooseLang.Destroy()
	}

	OnLanguageChange(lang, CtrlHwnd) {
		global PROGRAM, GuiChooseLang, GuiChooseLang_Controls, GuiChooseLang_LANG_Temp
		static prevLang
		prevLang := prevLang?prevLang:PROGRAM.SETTINGS.GENERAL.Language

		PROGRAM.SETTINGS.GENERAL.Language := lang
		Save_LocalSettings()
		
		GuiChooseLang_LANG_Temp := lang
		PROGRAM.TRANSLATIONS := GetTranslations(lang)

		prevLang := lang
		GUI_ChooseLang.Create()
	}

	SelectFlagBasedOnLanguage(lang) {
		global GuiChooseLang, GuiChooseLang_Controls

		lang := lang != "" ? lang : "english"
		flag := GuiChooseLang.Flags[lang]
		imgCoords := Get_ControlCoords("ChooseLang", GuiChooseLang_Controls["hIMG_Flag" flag])

		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedTop"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedTop"],% "x" imgCoords.X " y" imgCoords.Y-2
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedLeft"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedLeft"],% "x" imgCoords.X-2 " y" imgCoords.Y-2
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedBottom"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedBottom"],% "x" imgCoords.X-2 " y" imgCoords.Y+imgCoords.H
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedRight"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedRight"],% "x" imgCoords.X+imgCoords.W " y" imgCoords.Y
	}

	WaitForLang() {
		global GuiChooseLang, GuiChooseLang_LANG

		; Create the gui if it doesn't exist already
		if !WinExist("ahk_id " GuiChooseLang.Handle)
			GUI_ChooseLang.Create()
		
		; Wait for the gui, and then wait until either the return var has been set or the gui has been closed
		WinWait,% "ahk_id " GuiChooseLang.Handle
		while !(GuiChooseLang_LANG) || WinExist("ahk_id " GuiChooseLang.Handle) {
			if !WinExist("ahk_id " GuiChooseLang.Handle)
				Break
			Sleep 500
		}
		GuiChooseLang_LANG := ""
		return
	}

	DestroyBtnImgList() {
		global GuiChooseLang_Controls

		for key, value in GuiChooseLang_Controls
			if IsContaining(key, "hBTN_")
				try ImageButton.DestroyBtnImgList(value)
	}

	Destroy() {
		GUI_ChooseLang.DestroyBtnImgList()
		Gui.Destroy("ChooseLang")
	}

	Submit(CtrlName="") {
		global GuiChooseLang_Submit, GuiChooseLang_Controls
		Gui.Submit("ChooseLang")

		if (CtrlName) {
			Return GuiChooseLang_Submit[ctrlName]
		}
	}
	
    DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

    Close() {
		GUI_ChooseLang.AcceptLang()
	}

	Redraw() {
		Gui, ChooseLang:+LastFound
		WinSet, Redraw
	}
}
