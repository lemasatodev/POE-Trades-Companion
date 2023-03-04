Class GUI_ChooseLang {

	static guiName := "ChooseLang"
    static sGUI := {}

	static flags := {"english":"UK","french":"France","chinese_simplified":"China","chinese_traditional":"Taiwan","russian":"Russia","portuguese":"Portugal"}
	static ChosenLanguage
	
	Static Skin := { "Font": "Segoe UI"
        ,"FontSize": 8
		,"FontColor": "0x80c4ff"
        ,"BackgroundColor": "0x1c4563"
		,"ControlsColor": "0x274554"
        ,"BorderColor": "0x000000"
        ,"BorderSize": 1
		,"SelectedBorderSize": 2
		,"SelectedBorderColor": "0x5bcfff"
        ,"Styles": { "Button_Close": [ [0, "0xe01f1f", "", "White"], [0, "0xb00c0c"], [0, "0x8a0a0a"] ]
			,"Button_Minimize": [ [0, "0x0fa1d7", "", "White"], [0, "0x0b7aa2"], [0, "0x096181"] ]}
			,"Button": [ [0, "0x274554", "", "0xebebeb", , , "0xd6d6d6"], [0, "0x355e73"], [0, "0x122630"] ] }

	BuildImageButtonStyles() {
		files := [PROGRAM.IMAGES_FOLDER "\flag_france.png"
			PROGRAM.IMAGES_FOLDER "\flag_china.png"
			PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"
			PROGRAM.IMAGES_FOLDER "\flag_russia.png"
			PROGRAM.IMAGES_FOLDER "\flag_portugal.png"]
	}
	
	Create(param="") {
		global PROGRAM

		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		this.sGUI := new GUI("ChooseLang"
			, "-Caption -Border +AlwaysOnTop +HwndhGui" this.guiName " +Label" this.__class "."
			, PROGRAM.NAME " - " this.guiName)

		guiFullHeight := 200, guiFullWidth := 320, borderSize := 1, borderColor := "Black"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		this.sGUI := new GUI("ChooseLang", "w" guiFullWidth " h" guiFullHeight " -Caption -Border +AlwaysOnTop +HwndhGui" this.guiName " +Label" this.__class ".", PROGRAM.NAME . this.guiName)

		this.BuildImageButtonStyles()

		hBitmapFinal := Gdip_AddColoredBorderToImage(PROGRAM.IMAGES_FOLDER "\flag_uk.png", this.Skin.SelectedBorderSize, this.Skin.SelectedBorderColor)

		styleName := [ [0, hBitmapFinal, "", "Red", "", "Blue"] ]
		this.sGUI.SetMargins(0, 0), this.sGUI.SetBackgroundColor(this.Skin.BackgroundColor), this.sGUI.SetControlsColor(this.Skin.ControlsColor)
		this.sGUI.SetFont(this.Skin.Font), this.sGUI.SetFontSize(this.Skin.FontSize), this.sGUI.SetFontColor(this.Skin.FontColor)
		this.sGUI.AddColoredBorder(this.Skin.BorderSize, this.Skin.BorderColor)

		; * * Title Bar
		this.sGUI.Add("Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", ""), this.sGUI.BindFunctionToControl("hTEXT_HeaderGhost", "DragGui", this.sGUI.Handle) ; Title bar, allow moving
		this.sGUI.Add("Progress", "xp yp wp hp Background359cfc") ; Title bar background
		this.sGUI.Add("Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans ", "POE Trades Companion - Language") ; Title bar text
		this.sGUI.AddImageButton("x+0 yp w30 hp hwndhBTN_CloseGUI", "X", this.Skin.Styles.Button_Close, PROGRAM.FONTS[this.Skin.Font], this.Skin.FontSize)
		this.sGUI.BindFunctionToControl("hTEXT_HeaderGhost", this.__class ".DragGui", this.sGUI.Handle), this.sGUI.BindFunctionToControl("hBTN_CloseGUI", this.__class ".Close")

		; * * TOP TEXT
		this.sGUI.Add("Text", "x" leftMost+10 " y+20 w" guiWidth-20 " Center BackgroundTrans hwndhTEXT_TopText", PROGRAM.TRANSLATIONS.GUI_ChooseLang.hTEXT_TopText)
		
		; * * FLAGS
		; Calculate the space between each
		iconW := 35, iconH := 24, iconMax := 6
		spaceBetweenIcons := ( (guiWidth-20) /iconMax), iconsPerRow := 6
		firstIconX := (guiWidth-(spaceBetweenIcons*(iconsPerRow-1)+iconW))/2 ; We retrieve the blank space after the lastest icon in the row
																				 ;	then divide this space in two so icons are centered
		this.sGUI.Add("ImageButton", "x" firstIconX " y+35 w" iconW " h" iconH " hwndhIMG_FlagUK", "", styleName), this.sGUI.BindFunctionToControl("hIMG_FlagUK", "OnLanguageChange", "english")
		; this.sGUI.Add("ImageButton", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagFrance", PROGRAM.IMAGES_FOLDER "\flag_france.png"), this.sGUI.BindFunctionToControl("hIMG_FlagFrance", "OnLanguageChange", "french")
		; this.sGUI.Add("ImageButton", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagChina", PROGRAM.IMAGES_FOLDER "\flag_china.png"), this.sGUI.BindFunctionToControl("hIMG_FlagChina", "OnLanguageChange", "chinese_simplified")
		; this.sGUI.Add("ImageButton", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagTaiwan", PROGRAM.IMAGES_FOLDER "\flag_taiwan.png"), this.sGUI.BindFunctionToControl("hIMG_FlagTaiwan", "OnLanguageChange", "chinese_traditional")
		; this.sGUI.Add("ImageButton", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagRussia", PROGRAM.IMAGES_FOLDER "\flag_russia.png"), this.sGUI.BindFunctionToControl("hIMG_FlagRussia", "OnLanguageChange", "russian")
		; this.sGUI.Add("ImageButton", "xp+" spaceBetweenIcons " yp wp hp hwndhIMG_FlagPortugal", PROGRAM.IMAGES_FOLDER "\flag_portugal.png"), this.sGUI.BindFunctionToControl("hIMG_FlagPortugal", "OnLanguageChange", "portuguese")

		this.sGUI.AddImageButton("x" leftMost+10 " y+15 w" guiWidth-20 " h30 hwndhBTN_AcceptLang", PROGRAM.TRANSLATIONS.GUI_ChooseLang.hBTN_AcceptLang, this.Skin.Button, PROGRAM.FONTS[this.Skin.Font], this.Skin.FontSize)
		this.sGUI.BindFunctionToControl("hBTN_AcceptLang", "AcceptLang")

        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		if (this.sGUI.ImageButtonErrors.Count()) {
			AppendToLogs(JSON_Dump(this.sGUI.ImageButtonErrors))
			TrayNotifications.Show("Choose Language Interface - ImageButton Errors", "Some buttons failed to be created successfully."
			. "`n" "The interface will work normally, but its appearance will be altered."
			. "`n" "Further informations have been added to the logs file."
			. "`n" "If this keep occuring, please join the official Discord channel.")
		}

		this.ChosenLanguage := PROGRAM.SETTINGS.GENERAL.Language
		GUI_ChooseLang.SelectFlagBasedOnLanguage(this.ChosenLanguage)

		this.sGUI.Show("h" guiHeight " w" guiWidth " Hide NoActivate")
		SetControlDelay(delay), SetBatchLines(batch)
        Return
    }

	AcceptLang() {
		global PROGRAM

		this.ChosenLanguage := this.ChosenLanguage ? this.ChosenLanguage : "english"
		PROGRAM.SETTINGS.GENERAL.Language := this.ChosenLanguage
		PROGRAM.SETTINGS.GENERAL.AskForLanguage := "False"
		Save_LocalSettings()
		PROGRAM.TRANSLATIONS := GetTranslations(this.ChosenLanguage)
		this.Destroy()
	}

	OnLanguageChange(lang, CtrlHwnd) {
		global PROGRAM
		static prevLang
		prevLang := prevLang?prevLang:this.ChosenLanguage

		PROGRAM.SETTINGS.GENERAL.Language := lang
		Save_LocalSettings()
		
		this.ChosenLanguage := lang
		PROGRAM.TRANSLATIONS := GetTranslations(lang)

		prevLang := lang
		this.Create()
	}

	SelectFlagBasedOnLanguage(lang) {
		lang := lang != "" ? lang : "english"
		flag := this.flags[lang]
	}

	WaitForLang() {
		; Create the gui if it doesn't exist already
		if !WinExist("ahk_id " this.sGUI.Handle)
			this.Create()
		
		; Wait for the gui, and then wait until either the return var has been set or the gui has been closed
		WinWait,% "ahk_id " this.sGUI.Handle
		while WinExist("ahk_id " this.sGUI.Handle) {
			if !WinExist("ahk_id " this.sGUI.Handle)
				Break
			Sleep 500
		}
		return
	}

	Destroy() {
		this.sGUI.Destroy()
	}
	
    DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

    Close() {
		this.AcceptLang()
	}

	Redraw() {
		this.sGUI.Redraw()
	}
}
