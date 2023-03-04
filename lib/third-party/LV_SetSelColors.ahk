; ==================================================================================================================================
; Sets the colors for selected rows in a ListView.
; Parameters:
;     HLV      -  handle (HWND) of the ListView control.
;     BkgClr   -  background color as RGB integer value (0xRRGGBB).
;                 If omitted or empty the ListViews's background color will be used.
;     TxtClr   -  text color as RGB integer value (0xRRGGBB).
;                 If omitted or empty the ListView's text color will be used.
;                 If both BkgColor and TxtColor are omitted or empty the control will be reset to use the default colors.
;     Dummy    -  must be omitted or empty!!!
; Return value:
;     No return value.
; Remarks:
;     The function adds a handler for WM_NOTIFY messages to the chain of existing handlers.
; ==================================================================================================================================
LV_SetSelColors(HLV, BkgClr := "", TxtClr := "", Dummy := "") {
   Static OffCode := A_PtrSize * 2              ; offset of code        (NMHDR)
        , OffStage := A_PtrSize * 3             ; offset of dwDrawStage (NMCUSTOMDRAW)
        , OffItem := (A_PtrSize * 5) + 16       ; offset of dwItemSpec  (NMCUSTOMDRAW)
        , OffItemState := OffItem + A_PtrSize   ; offset of uItemState  (NMCUSTOMDRAW)
        , OffClrText := (A_PtrSize * 8) + 16    ; offset of clrText     (NMLVCUSTOMDRAW)
        , OffClrTextBk := OffClrText + 4        ; offset of clrTextBk   (NMLVCUSTOMDRAW)
        , Controls := {}
        , MsgFunc := Func("LV_SetSelColors")
        , IsActive := False
   Local Item, H, LV, Stage
   If (Dummy = "") { ; user call ------------------------------------------------------------------------------------------------------
      If (BkgClr = "") && (TxtClr = "")
         Controls.Delete(HLV)
      Else {
         If (BkgClr <> "")
            Controls[HLV, "B"] := ((BkgClr & 0xFF0000) >> 16) | (BkgClr & 0x00FF00) | ((BkgClr & 0x0000FF) << 16) ; RGB -> BGR
         If (TxtClr <> "")
            Controls[HLV, "T"] := ((TxtClr & 0xFF0000) >> 16) | (TxtClr & 0x00FF00) | ((TxtClr & 0x0000FF) << 16) ; RGB -> BGR
      }
      If (Controls.MaxIndex() = "") {
         If (IsActive) {
            OnMessage(0x004E, MsgFunc, 0)
            IsActive := False
      }  }
      Else If !(IsActive) {
         OnMessage(0x004E, MsgFunc)
         IsActive := True
   }  }
   Else { ; system call ------------------------------------------------------------------------------------------------------------
      ; HLV : wParam, BkgClr : lParam, TxtClr : uMsg, Dummy : hWnd
      H := NumGet(BkgClr + 0, "UPtr")
      If (LV := Controls[H]) && (NumGet(BkgClr + OffCode, "Int") = -12) { ; NM_CUSTOMDRAW
         Stage := NumGet(BkgClr + OffStage, "UInt")
         If (Stage = 0x00010001) { ; CDDS_ITEMPREPAINT
            Item := NumGet(BkgClr + OffItem, "UPtr")
            If DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") { ; LVM_GETITEMSTATE, LVIS_SELECTED
               ; The trick: remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
               NumPut(NumGet(BkgClr + OffItemState, "UInt") & ~0x0011, BkgClr + OffItemState, "UInt")
               If (LV.B <> "")
                  NumPut(LV.B, BkgClr + OffClrTextBk, "UInt")
               If (LV.T <> "")
                  NumPut(LV.T, BkgClr + OffClrText, "UInt")
               Return 0x02 ; CDRF_NEWFONT
         }  }
         Else If (Stage = 0x00000001) ; CDDS_PREPAINT
            Return 0x20 ; CDRF_NOTIFYITEMDRAW
         Return 0x00 ; CDRF_DODEFAULT
}  }  }