class GUI_Intercom {

    static sGUI := {}

    Create() {
        this.sGUI := new GUI("Intercom", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +HwndhGuiIntercom +Label" this.__class, "Intercom")
        Loop 100 ; Making 100 slots, setting SubRoutine
            this.sGUI.Add("Edit", "x0 y0 w0 h0 hwndhEDIT_Slot" A_Index " "), this.sGUI.BindFunctionToControl("hEDIT_Slot" A_Index, "OnSlotContentChange")
        this.sGUI.Show("x0 y0 w0 w0 NoActivate Hide")
    }

    GetNextAvailableSlot() {
        ; Returns the first available slot ID
        Loop 100 {
            if ( this.IsSlotAvailable(A_Index) = True )
                return A_Index
        }
    }

    IsSlotAvailable(slotNum) {
        ; Returns whether the slot is empty or not
        return this.GetSlotContent(slotNum) = "" ? True : False
    }

    GetSlotContent(slotNum) {
        ; Returns the slot content
        return this.sGUI.GetControlContent("hEDIT_Slot" slotNum)
    }

    MakeSlotEmpty(slotNum) {
        ; Make the slot available by emptying it
        this.SetSlotContent(slotNum, "")
    }

    SetSlotContent(slotNum, content) {
        ; Set text within the slot
        this.sGUI.SetControlContent("hEDIT_Slot" slotNum, content)
    }

    ReserveSlot(slotNum) {
        ; Reserves the slot by putting text in it
        this.SetSlotContent(slotNum, "RESERVED")
    }

    GetSlotHandle(slotNum) {
        ; Return the slot handle
        return this.sGUI.Controls["hEDIT_Slot" slotNum]
    }

    OnSlotContentChange(slotNum="", CtrlHwnd="") {
        ; Handle running the functions within the slot    
        slotContent := this.GetSlotContent(slotNum)
        if (slotContent) { ; if slot has been attributed content
            funcReturnValues := {} ; obj containing the return values of the function ran
            Loop, Parse, slotContent, `n
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
            this.MakeSlotEmpty(slotNum) ; done, make sure to empty slot
        }
    }

    Destroy() {
        this.sGUI.Destroy()
    }
}
