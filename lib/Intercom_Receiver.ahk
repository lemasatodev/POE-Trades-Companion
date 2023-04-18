class GUI_Intercom {
    Create() {
        global GuiIntercom, GuiIntercom_Controls
        ; Creating GUI
        GUI_Intercom.Destroy()
        Gui.New("Intercom", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +LabelGUI_Intercom_ +HwndhGuiIntercom", "Intercom")
        ; Making 100 slots, setting SubRoutine
        Loop 100 {
            Gui.Add("Intercom", "Edit", "x0 y0 w0 h0 hwndhEDIT_Slot" A_Index " ")
            __f := GUI_Intercom.OnSlotContentChange.bind(GUI_Intercom, A_Index)
            GuiControl, Intercom:+g,% GuiIntercom_Controls["hEDIT_Slot" A_Index],% __f
        }
        ; Show GUI, hidden
        Gui.Show("Intercom", "x0 y0 w0 w0 NoActivate Hide")
    }

    GetNextAvailableSlot() {
        ; Returns the first available slot ID
        Loop 100 {
            if ( GUI_Intercom.IsSlotAvailable(A_Index) = True )
                return A_Index
        }
    }

    IsSlotAvailable(slotNum) {
        ; Returns whether the slot is empty or not
        if ( GUI_Intercom.GetSlotContent(slotNum) = "")
            return True
        else return False
    }

    GetSlotContent(slotNum) {
        ; Returns the slot content
        global GuiIntercom_Controls
        return GUI_Intercom.Submit("hEDIT_Slot" slotNum)
    }

    EmptySlot(slotNum) {
        ; Make the slot available by emptying it
        global GuiIntercom_Controls
        GUI_InterCom.SetSlotContent(slotNum,"")
    }

    SetSlotContent(slotNum, content) {
        ; Set text within the slot
        global GuiIntercom_Controls
        GuiControl, Intercom:,% GuiIntercom_Controls["hEDIT_Slot" slotNum],%content%
    }

    ReserveSlot(slotNum) {
        ; Reserves the slot by putting text in it
        global GuiIntercom_Controls
        GUI_InterCom.SetSlotContent(slotNum,"RESERVED")
    }

    GetSlotHandle(slotNum) {
        ; Return the slot handle
        global GuiIntercom_Controls
        return GuiIntercom_Controls["hEDIT_Slot" slotNum]
    }

    OnSlotContentChange(slotNum="", CtrlHwnd="") {
        ; Handle running the functions within the slot
        global GuiIntercom_Controls
        _ctrl := GuiIntercom_Controls["hEDIT_Slot1"]
    
        newContent := GUI_Intercom.GetSlotContent(slotNum)
        if (newContent) { ; if slot has been attributed content
            funcReturnValues := {} ; obj containing the return values of the function ran
            Loop, Parse, newContent, `n
            {
                ; Detect the kind of function string
                funcStr_return := funcStr_funcName := funcStr_funcParams := ""
                if RegExMatch(A_LoopField, "O)(.*?) := (.*?)\((.*)\)", match) ; func with return
                    funcStr_return := match.1, funcStr_funcName := match.2, funcStr_funcParams := match.3
                else if RegExMatch(A_LoopField, "O)(.*?)\((.*)\)", match) ; normal func
                    funcStr_funcName := match.1, funcStr_funcParams := match.2
                
                params_split := StrSplit(funcStr_funcParams, ",") ; Split params into an array
                if ( params_split.Count() > 10 )  
                    MsgBox % "Intercom can only take up to 10 parameters, function has " params_split.Count()
                    . "`n" A_LoopField
                Loop % params_split.Count() { ; Replace the %varName% with the actual variable content
                    if RegExMatch(params_split[A_Index], "O)%(.*)%", paramVarName) {
                        params_split[A_Index] := funcReturnValues[paramVarName.1]
                    }
                }
             
                func_ref := Func(funcStr_funcName) ; reference to func
                func_bind := func_ref.bind(empty) ; workaround allowing to use functions within class
                func_return := func_bind.call(params_split.1, params_split.2, params_split.3, params_split.4, params_split.5, params_split.6, params_split.7, params_split.8, params_split.9, params_split.10) ; call the function
                if (funcStr_return) { ; if the function had a return string, add the values into an obj with that return variable's name
                    funcReturnValues[funcStr_return] := func_return
                }
            }
            GUI_InterCom.EmptySlot(slotNum) ; done, make sure to empty slot
        }
    }

    Submit(CtrlName="") {
        ; Update all control values into GuiIntercom_Submit
        ; Return the value of the specified control
		global GuiIntercom_Submit
		Gui.Submit("Intercom")

		if (CtrlName) {
			Return GuiIntercom_Submit[ctrlName]
		}
	}

    Destroy() {
        Gui.Destroy("Intercom")
    }
}
