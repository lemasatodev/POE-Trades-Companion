class TrayNotification {

    Static GUIs := {}
    Static User32Dll := A_WinDir "\system32\user32.dll"
    Static User32DllIconsIndex := {"Warning":2, "Question":3, "Error":4, "Information":5}
    Static Skin := {"Font": "Segoe UI"
        ,"FontSize": 10
        ,"IconSizeMin": 16
        ,"BackgroundColor": "0x252627"
        ,"BorderColor": "0x000000"
        ,"BorderSize": 1
        ,"TitleFontSize": "20"
        ,"TitleTextColor": "0xFFFFFF"
        ,"MessageFontSize": "10"
        ,"MessageTextColor": "0x959595"}

	__New(title, message, iconPath="Information", disappearAfter=6, SkinCustom="") {
        screenDPI := this.GetScreenDPI()
        mainScreenWA := this.GetMonitorsInformations()
        thisGuiNum := this.GetNextAvailableNum()

        if IsObject(SkinCustom)
            this.Skin := ObjMerge(SkinCustom, this.Skin)

        gui_name := "TrayNotification" thisGuiNum
        gui_width := 330 ; gui height is variable and set automatically by gui cmds
        title_height := GUI.PredictControlSize("Text", "w" gui_width " Font'" this.Skin.Font "' FontSize" this.Skin.TitleFontSize, title).H
        message_height := GUI.PredictControlSize("Text", "w" gui_width " Font'" this.Skin.Font "' FontSize" this.Skin.MessageFontSize, message).H
        gui_parameters := "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border HwndGuiTrayNotification Font'" this.Skin.Font "' FontSize" this.Skin.FontSize

        if IsIn(iconPath, "Information,Warning,Error,Question")
            iconName := iconPath, iconPath := this.User32Dll, iconDllIndexParam := "Icon" this.User32DllIconsIndex[iconName]
        
        iconSize := title_height := title_height > this.Skin.IconSizeMin ? title_height : this.Skin.IconSizeMin
        this.GUIs[gui_name] := new GUI(gui_name, gui_parameters)
        thisGui := this.GUIs[gui_name]

        thisGui.SetBackgroundColor(this.Skin.BackgroundColor)
      
        thisGui.Add("Picture", "x5 y5 w" iconSize " h" iconSize " hwndhIMG_Icon " iconDllIndexParam, iconPath)
        thisGui.Add("Text", "x+5 yp w" gui_width " h" title_height " hwndhTEXT_Title c" this.Skin.TitleTextColor " FontSize" this.Skin.TitleFontSize, title)
        thisGui.Add("Text", "x5 y+0 w" gui_width " h" message_height " hwndhTEXT_Message c" this.Skin.MessageTextColor " FontSize" this.Skin.MessageFontSize, message)
        thisGui.AddColoredBorder(this.Skin.BorderSize, this.Skin.BorderColor)

        show_right_margin := 5, show_bottom_margin := 5, space_between_notifications := 2
        gui_position := thisGui.GetPosition(), gui_width := gui_position.Width, gui_height := gui_position.Height

        thisGui.SpaceBetweenNotifications := space_between_notifications

        gui_x := mainScreenWA.Right - ( (gui_width+show_right_margin)*screenDPI )
        gui_y_default := mainScreenWA.Bottom - ( (gui_height+show_bottom_margin)*screenDPI )
        gui_existing_highest_pos := this.GetHighestNotificationPosition()
        gui_y := gui_existing_highest_pos.Y ? gui_existing_highest_pos.Y - gui_existing_highest_pos.H - space_between_notifications : gui_y_default
        thisGui.Show("x" gui_x " y" gui_y)

        thisGui.BindWindowsMessage(0x0201, this.__class ".WM_LBUTTONDOWN")

        obj := ObjBindMethod(thisGui, "Destroy")
        SetTimer,% obj,% disappearAfter*1000

        return thisGui
    }

    Destroy() {
        if (!A_Gui)
            return

        destroyedPos := this.GUIs[A_Gui].GetPosition()
        this.GUIs[A_Gui].Destroy()
        for guiName in this.GUIs {
            if (A_Gui = guiName)
                Continue

            thisGuiPos := this.GUIs[guiName].GetPosition()
            if (thisGuiPos.Y < destroyedPos.Y) {
                WinMove,% "ahk_id " this.GUIs[guiName].Handle, , ,% thisGuiPos.Y + destroyedPos.Height + this.GUIs[guiName].SpaceBetweenNotifications
            }
        }
    }

    GetHighestNotificationPosition() {
        highest_y := "", highest_h := ""
        for guiName in this.GUIs {
            guiPos := this.GUIs[guiName].GetPosition(onlyIfVisible:=True)
            if IsNum(guiPos.Y) && ( (guiPos.Y < highest_y) || !IsNum(highest_y) ) {
                highest_y := guiPos.Y, highest_h := guiPos.Height
            }
        }

        return {H:highest_h, Y:highest_y}
    }

    WM_LBUTTONDOWN() {
        this.Destroy()
    }

    GetNextAvailableNum() {
        nextAvailableNum := 1, takenNumsList := ""
        for guiName in this.GUIs {
            RegExMatch(guiName, "O)(\d+)", out), guiNum := out.1
            takenNumsList := takenNumsList ? takenNumsList "|" guiNum : guiNum
        }
        Sort, takenNumsList, N D|

        Loop, Parse, takenNumsList,% "|"
        {
            currentParsedNum := A_LoopField
            if (A_Index > 1) && (currentParsedNum != previousParsedNum+1) {
                nextAvailableNum := currentParsedNum-1
                Break
            }
            else {
                nextAvailableNum := currentParsedNum+1
            }
            previousParsedNum := currentParsedNum
        }
        
        return nextAvailableNum
    }
    GetScreenDPI() {
        return A_ScreenDPI=96?1:A_ScreenDPI/96
    }
    GetMonitorsInformations() {
        SysGet, MonitorCount, MonitorCount
		SysGet, MonitorPrimary, MonitorPrimary
		SysGet, MonitorWorkArea, MonitorWorkArea,% MonitorPrimary
        return {Left:MonitorWorkAreaLeft, Top:MonitorWorkAreaTop, Right:MonitorWorkAreaRight, Bottom:MonitorWorkAreaBottom}
    }
}
