class GUI_CheatSheet {

    static guiName := "CheatSheet"
    static sGUI := {}

    Create(pngFilePath) {
        global PROGRAM

        delay := SetControlDelay(0), batch := SetBatchLines(-1)
        this.sGUI := new GUI(this.guiName
            , "HwndhGui" this.guiName " +AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +Label" this.__class "."
            , PROGRAM.NAME " - " this.guiName)
        this.sGUI.SetBackgroundColor("EEAA99"), this.sGUI.TransColor("EEAA99")

        this.sGUI.Add("Picture", "0xE hwndhIMG_CheatSheet"), this.sGUI.BindFunctionToControl("hIMG_CheatSheet", this.__class ".Destroy")
        hBitMap := Gdip_CreateResizedHBITMAP_FromFile(pngFilePath, A_ScreenWidth*0.90, A_ScreenHeight*0.80, keepRatio:=True)
        this.sGUI.SetHbitmapToControl("hIMG_CheatSheet", hBitmap)

        Hotkey, IfWinActive
        this.sGUI.EscapeFuncObj := __f := ObjBindMethod(GUI_CheatSheet, "Destroy")
        Hotkey, *Esc,% __f, On
        this.sGUI.BindWindowsMessage("0x0201", this.__class ".WM_LBUTTONDOWN")

        SetControlDelay(delay), SetBatchLines(batch)
        return this.sGUI
    }

    Show(pngFilePath) {
        this.sGUI.Create(pngFilePath)
        this.sGUI.Show("xCenter yCenter AutoSize NoActivate")
    }

    Destroy() {
        __f := this.sGUI.EscapeFuncObj
        Hotkey, IfWinActive
        Hotkey, *Esc,% __f, Off
        this.sGUI.Destroy() 
    }

    WM_LBUTTONDOWN() {
        this.Destroy()
    }
}
