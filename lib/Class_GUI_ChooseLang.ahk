Class GUI_ChooseLang {
	
	Create(param="") {
		global PROGRAM, GAME
		global GuiChooseLang, GuiChooseLang_Controls, GuiChooseLang_Submit
		static guiCreated

		GUI_ChooseLang.Destroy()
		Gui.New("ChooseLang", "-Caption -Border +AlwaysOnTop +LabelGUI_ChooseLang_ +HwndhGuiChooseLang", "POE TC - Language")
		GuiChooseLang.Is_Created := False

		guiCreated := False
		guiFullHeight := 200, guiFullWidth := 300, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		GuiChooseLang.Style_Tab := Style_Tab := [ [0, "0xEEEEEE", "", "Black", 0, , ""] ; normal
			, [0, "0xdbdbdb", "", "Black", 0] ; hover
			, [3, "0x44c6f6", "0x098ebe", "Black", 0]  ; press
			, [3, "0x44c6f6", "0x098ebe", "White", 0 ] ] ; default

		GuiChooseLang.Style_RedBtn := Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("ChooseLang", 0, 0)
		Gui.Color("ChooseLang", "White")
		Gui.Font("ChooseLang", "Segoe UI", "8")
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
		imageBtnLog .= Gui.Add("ChooseLang", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)
		__f := GUI_ChooseLang.DragGui.bind(GUI_ChooseLang, GuiChooseLang.Handle)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls.hTEXT_HeaderGhost,% __f
		__f := GUI_ChooseLang.Close.bind(GUI_ChooseLang)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls.hBTN_CloseGUI,% __f

		; * * TOP TEXT
		Gui.Add("ChooseLang", "Text", "x" leftMost+10 " y+20 w" guiWidth-20 " Center hwndhTEXT_TopText", "Thank you for using POE Trades Companion!`nBefore you can start trading,`nplease select your language below:")
		; * * FLAGS
		; Calculate the space between each
		iconW := 35, iconH := 24, iconMax := 5
		spaceBetweenIcons := ( (guiWidth-20) /iconMax), iconsPerRow := 5
		firstIconX := (guiWidth-(spaceBetweenIcons*(iconsPerRow-1)+iconW))/2 ; We retrieve the blank space after the lastest icon in the row
																				 ;	then divide this space in two so icons are centered
		Gui.Add("ChooseLang", "Picture", "x" firstIconX " y+35 w" iconW " h" iconH " hwndhIMG_FlagUK", PROGRAM.IMAGES_FOLDER "\flag_uk.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagFrance", PROGRAM.IMAGES_FOLDER "\flag_france.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagChina", PROGRAM.IMAGES_FOLDER "\flag_china.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagTaiwan", PROGRAM.IMAGES_FOLDER "\flag_taiwan.png")
		Gui.Add("ChooseLang", "Picture", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagRussia", PROGRAM.IMAGES_FOLDER "\flag_russia.png")

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

		Gui.Add("ChooseLang", "Button", "x" leftMost+10 " y+15 w" guiWidth-20 " h30 hwndhBTN_AcceptLang", "Continue with: English")
		__f := GUI_ChooseLang.AcceptLang.bind(GUI_ChooseLang)
		GuiControl, ChooseLang:+g,% GuiChooseLang_Controls["hBTN_AcceptLang"],% __f

        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		Gui.Show("ChooseLang", "h" guiHeight " w" guiWidth " Hide NoActivate")
		
        Return
    }

	AcceptLang() {
		global PROGRAM, GuiChooseLang

		lang := GuiChooseLang.ChoosenLang != "" ? GuiChooseLang.ChoosenLang : "english"
		INI.Set(PROGRAM.INI_FILE, "GENERAL", "Language", lang)
		INI.Set(PROGRAM.INI_FILE, "GENERAL", "AskForLanguage", "False")
		PROGRAM.TRANSLATIONS := GetTranslations(lang)

		GUI_ChooseLang.Destroy()
	}

	OnLanguageChange(lang, CtrlHwnd) {
		global PROGRAM, GuiChooseLang, GuiChooseLang_Controls
		static prevLang
		prevLang := prevLang?prevLang:PROGRAM.SETTINGS.GENERAL.Language

		INI.Set(PROGRAM.INI_FILE, "GENERAL", "Language", lang)
		PROGRAM.SETTINGS.GENERAL.Language := lang
		PROGRAM.TRANSLATIONS := GetTranslations(lang)
		
		GuiChooseLang.ChoosenLang := lang
		GUI_ChooseLang.SetTranslation(lang)
		PROGRAM.TRANSLATIONS := GetTranslations(lang)

		imgCoords := Get_ControlCoords("ChooseLang", CtrlHwnd)
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedTop"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedTop"],% "x" imgCoords.X " y" imgCoords.Y-2
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedLeft"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedLeft"],% "x" imgCoords.X-2 " y" imgCoords.Y-2
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedBottom"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedBottom"],% "x" imgCoords.X-2 " y" imgCoords.Y+imgCoords.H
		GuiControl, ChooseLang:Show,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedRight"]
		GuiControl, ChooseLang:Move,% GuiChooseLang_Controls["hPROGRESS_BorderSelectedRight"],% "x" imgCoords.X+imgCoords.W " y" imgCoords.Y

		prevLang := lang
	}

	SetTranslation(_lang="english", _ctrlName="") {
		global PROGRAM, GuiChooseLang, GuiChooseLang_Controls
		trans := PROGRAM.TRANSLATIONS.GUI_ChooseLang

		GUI_ChooseLang.DestroyBtnImgList()

		noResizeCtrls := "hBTN_CloseGUI,hBTN_AcceptLang"
		noSmallerCtrls := "hTEXT_TopText"
		needsCenterCtrls := "hTEXT_TopText"

		if (_ctrlName) {
			if (trans != "") ; selected trans
				GuiControl, ChooseLang:,% GuiChooseLang_Controls[_ctrlName],% trans
		}
		else {
			for ctrlName, ctrlTranslation in trans {
				if !( SubStr(ctrlName, -7) = "_ToolTip" ) { ; if not a tooltip
					ctrlHandle := GuiChooseLang_Controls[ctrlName]

					ctrlType := IsContaining(ctrlName, "hCB_") ? "CheckBox"
							: IsContaining(ctrlName, "hTEXT_") ? "Text"
							: IsContaining(ctrlName, "hBTN_") ? "Button"
							: IsContaining(ctrlName, "hDDL_") ? "DropDownList"
							: IsContaining(ctrlName, "hEDIT_") ? "Edit"
							: IsContaining(ctrlName, "hGB_") ? "GroupBox"
							: IsContaining(ctrlName, "hLV_") ? "ListView"
							: "Text"

					if !IsIn(ctrlName, noResizeCtrls) { ; Readjust size to fit translation
						txtSize := Get_TextCtrlSize(txt:=ctrlTranslation, fontName:=GuiChooseLang.Font, fontSize:=GuiChooseLang.Font_Size, maxWidth:="", params:="", ctrlType)
						txtPos := Get_ControlCoords("ChooseLang", ctrlHandle)

						if (IsIn(ctrlName, noSmallerCtrls) && (txtSize.W > txtPos.W))
						|| !IsIn(ctrlName, noSmallerCtrls)
							GuiControl, ChooseLang:Move,% ctrlHandle,% "w" txtSize.W
					}

					if (ctrlHandle) { ; set translation
						if (ctrlType = "DropDownList")
							ddlValue := GUI_ChooseLang.Submit(ctrlName), ctrlTranslation := "|" ctrlTranslation

						if (ctrlTranslation != "") { ; selected trans
							if (ctrlType = "ListView") {
								GUI_ChooseLang.SetDefaultListView(ctrlName)
								Loop, Parse, ctrlTranslation, |
									LV_ModifyCol(A_Index, Options, A_LoopField)
							}
							GuiControl, ChooseLang:,% ctrlHandle,% ctrlTranslation
						}

						if (ctrlType = "DropDownList")
							GuiControl, ChooseLang:Choose,% ctrlHandle,% ddlValue
					}

					if IsIn(ctrlName, needsCenterCtrls) {
						GuiControl, ChooseLang:-Center,% ctrlHandle
						GuiControl, ChooseLang:+Center,% ctrlHandle
					}

				}
			}
			
			GuiControl, ChooseLang:,% GuiChooseLang_Controls["hBTN_CloseGUI"],% "X"
			ImageButton.Create(GuiChooseLang_Controls["hBTN_CloseGUI"], GuiChooseLang.Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)						
		}

		GUI_ChooseLang.Redraw()
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

    Show() {
		global GuiChooseLang

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiChooseLang.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			Gui, ChooseLang:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_ChooseLang.Show(): Non existent. Recreating.")
			GUI_ChooseLang.Create()
			Gui, ChooseLang:Show, xCenter yCenter
		}
		WinWait,% "ahk_id " GuiChooseLang.Handle
		WinWaitClose,% "ahk_id " GuiChooseLang.Handle
	}

    Close() {
		GUI_ChooseLang.AcceptLang()
	}

	Redraw() {
		Gui, ChooseLang:+LastFound
		WinSet, Redraw
	}
}
