/*	Source: https://gist.github.com/andreberg/55d003569f0564cd8695

	Usage example:
		Gui,Add,Button,hwndbutton1 Gbut1,Test Button 1
		AddTooltip(button1,"Press me to change my tooltip")
*/

AddToolTip(con, text, Modify=0){
    Static TThwnd, GuiHwnd
    TInfo =
    UInt := "UInt"
    Ptr := (A_PtrSize ? "Ptr" : UInt)
    PtrSize := (A_PtrSize ? A_PtrSize : 4)
    Str := "Str"
    ; defines from Windows MFC commctrl.h
    WM_USER := 0x400
    TTM_ADDTOOL := (A_IsUnicode ? WM_USER+50 : WM_USER+4)           ; used to add a tool, and assign it to a control
    TTM_UPDATETIPTEXT := (A_IsUnicode ? WM_USER+57 : WM_USER+12)    ; used to adjust the text of a tip
    TTM_SETMAXTIPWIDTH := WM_USER+24                                ; allows the use of multiline tooltips
    TTF_IDISHWND := 1
    TTF_CENTERTIP := 2
    TTF_RTLREADING := 4
    TTF_SUBCLASS := 16
    TTF_TRACK := 0x0020
    TTF_ABSOLUTE := 0x0080
    TTF_TRANSPARENT := 0x0100
    TTF_PARSELINKS := 0x1000
    If (!TThwnd) {
        Gui, +LastFound
        GuiHwnd := WinExist()
        TThwnd := DllCall("CreateWindowEx"
                    ,UInt,0
                    ,Str,"tooltips_class32"
                    ,UInt,0
                    ,UInt,2147483648
                    ,UInt,-2147483648
                    ,UInt,-2147483648
                    ,UInt,-2147483648
                    ,UInt,-2147483648
                    ,UInt,GuiHwnd
                    ,UInt,0
                    ,UInt,0
                    ,UInt,0)
    }
    ;~ DllCall("uxtheme\SetWindowTheme","Uint",TThwnd,Ptr,0,"UintP",0)	; TTM_SETWINDOWTHEME
    ; for TOOLINFO structure see http://msdn.microsoft.com/en-us/library/windows/desktop/bb760256%28v=vs.85%29.aspx
    ;   cbSize, UINT, 4
    ;   uFlags, UINT, 4
    ;   hwnd, HWND = PVOID, PtrSize
    ;   uId, UINT64_PTR, PtrSize
    ;   rect, RECT = {LONG, LONG, LONG, LONG}, 4*4=16
    ;   hinst, HINSTANCE = PVOID, PtrSize
    ;   lpszText, LPTSTR, LONG_PTR, PtrSize
    ;   lParam, LONG_PTR, PtrSize
    ;   lpReserved, LONG_PTR, PtrSize
    cbSize := 6*4+6*PtrSize
    uFlags := TTF_IDISHWND|TTF_SUBCLASS|TTF_PARSELINKS
    VarSetCapacity(TInfo, cbSize, 0)
    NumPut(cbSize, TInfo)
    NumPut(uFlags, TInfo, 4)
    NumPut(GuiHwnd, TInfo, 8)
    NumPut(con, TInfo, 8+PtrSize)
    NumPut(&text, TInfo, 6*4+3*PtrSize)
    NumPut(0,TInfo, 6*4+6*PtrSize)
    DetectHiddenWindows, On
    If (!Modify) {
        DllCall("SendMessage"
            ,Ptr,TThwnd
            ,UInt,TTM_ADDTOOL
            ,Ptr,0
            ,Ptr,&TInfo
            ,Ptr) 
        DllCall("SendMessage"
            ,Ptr,TThwnd
            ,UInt,TTM_SETMAXTIPWIDTH
            ,Ptr,0
            ,Ptr,A_ScreenWidth) 
    }
    DllCall("SendMessage"
        ,Ptr,TThwnd
        ,UInt,TTM_UPDATETIPTEXT
        ,Ptr,0
        ,Ptr,&TInfo
        ,Ptr)

}