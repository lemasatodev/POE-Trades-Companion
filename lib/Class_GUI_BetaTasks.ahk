Class GUI_BetaTasks {
    Create() {
        global PROGRAM
		global GuiBetaTasks, GuiBetaTasks_Controls, GuiBetaTasks_Submit

        ; Initialize gui arrays
        GUI_BetaTasks.Destroy()
        Gui.New("BetaTasks", "+LabelGUI_BetaTasks_ +HwndhGuiBetaTasks", "POE TC - Beta Tasks")
        Gui.Font("BetaTasks", "Segoe UI", "8")

        guiHeight := 170, guiWidth := 710

        Gui.Add("BetaTasks", "Text", "hwndhTXT_Welcome", ""
            .       "Welcome to " PROGRAM.NAME " betas!"
            . "`n"
            . "`n"  "Usually, these updates are very stable as I make sure to test it myself."
            . "`n"  "This update has brought a lot of changes code-wise, and it could possible that some bugs are still there."
            . "`n"  "If possible, I would really appreciate it if you could help me to make sure the tool works properly before pushing the update as stable."
            . "`n"  "It is up to you to decide, you could try the new features, or simply use the tool as you normally would."
            . "`n"
            . "`n"  "In case you encounter an issue, you can:"
            . "`n"  "- Open an issue on GitHub"
            . "`n"  "- Contact me on the PoE forums on the thread or via PM"
            . "`n"  "- Contact me on Reddit via PM"
            . "`n"  "- Join the discord channel")

        ; Gui.Add("BetaTasks", "Picture", "x" guiWidth-120 " y" guiHeight-45 " hwndhIMG_Paypal", PROGRAM.IMAGES_FOLDER "\DonatePaypal.png")
        Gui.Add("BetaTasks", "Picture", "x" guiWidth-50 " y" guiHeight-45 " w40 h40 hwndhIMG_Discord", PROGRAM.IMAGES_FOLDER "\Discord.png")
		; Gui.Add("BetaTasks", "Picture", "xp-70 yp w40 h40 hwndhIMG_Discord", PROGRAM.IMAGES_FOLDER "\Discord.png")
		Gui.Add("BetaTasks", "Picture", "xp-45 yp w40 h40 hwndhIMG_Reddit", PROGRAM.IMAGES_FOLDER "\Reddit.png")
		Gui.Add("BetaTasks", "Picture", "xp-45 yp w40 h40 hwndhIMG_PoE", PROGRAM.IMAGES_FOLDER "\PoE.png")
		Gui.Add("BetaTasks", "Picture", "xp-45 yp w40 h40 hwndhIMG_GitHub", PROGRAM.IMAGES_FOLDER "\GitHub.png")

        __f := GUI_BetaTasks.OnPictureLinkClick.bind(GUI_BetaTasks, "Paypal")
		GuiControl, BetaTasks:+g,% GuiBetaTasks_Controls["hIMG_Paypal"],% __f
		__f := GUI_BetaTasks.OnPictureLinkClick.bind(GUI_BetaTasks, "Discord")
		GuiControl, BetaTasks:+g,% GuiBetaTasks_Controls["hIMG_Discord"],% __f
		__f := GUI_BetaTasks.OnPictureLinkClick.bind(GUI_BetaTasks, "Reddit")
		GuiControl, BetaTasks:+g,% GuiBetaTasks_Controls["hIMG_Reddit"],% __f
		__f := GUI_BetaTasks.OnPictureLinkClick.bind(GUI_BetaTasks, "PoE")
		GuiControl, BetaTasks:+g,% GuiBetaTasks_Controls["hIMG_PoE"],% __f
		__f := GUI_BetaTasks.OnPictureLinkClick.bind(GUI_BetaTasks, "GitHub")
		GuiControl, BetaTasks:+g,% GuiBetaTasks_Controls["hIMG_GitHub"],% __f

        Gui.Show("BetaTasks", "w" guiWidth " h" guiHeight " NoActivate Hide")
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

    Show() {
		global GuiBetaTasks

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiBetaTasks.Handle)
		DetectHiddenWindows, %hiddenWin%

		if (foundHwnd) {
			Gui, BetaTasks:Show, xCenter yCenter
		}
		else {
			AppendToLogs("GUI_BetaTasks.Show(): Non existent. Recreating.")
			GUI_BetaTasks.Create()
			GUI_BetaTasks.Show()
		}
	}

	Destroy() {
		Gui.Destroy("BetaTasks")
	}
}

