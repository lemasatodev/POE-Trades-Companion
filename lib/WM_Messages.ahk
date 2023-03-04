AHK_NOTIFYICON(wParam, lParam) { 
	global CANCEL_TRAY_MENU
    if (lParam = 0x202) { ; WM_LBUTTONUP
		dblClkTime := DllCall("user32.dll\GetDoubleClickTime")
		dblClkTime := IsNum(dblClkTime)?dblClkTime:500
        SetTimer, AHK_NOTIFYICON_ShowTrayMenu,% "-" dblClkTime+20
        return 0 
    }
	return

	AHK_NOTIFYICON_ShowTrayMenu:
	 	if (CANCEL_TRAY_MENU = True) 
		 	CANCEL_TRAY_MENU := False
		else
			Menu, Tray, Show
	return
} 