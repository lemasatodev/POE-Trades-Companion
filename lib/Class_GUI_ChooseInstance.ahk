class GUI_ChooseInstance {
	Create(instancesInfos, mode) {
		global PROGRAM, CHOOSEN_INSTANCE
		global GuiChooseInstance, GuiChooseInstance_Controls, GuiChooseInstance_Submit
		static guiWidth, guiHeight

		GUI_ChooseInstance.Destroy()
		Gui.New("ChooseInstance", "+AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +LabelGUI_ChooseInstance_ +HwndhGuiChooseInstance", "POE TC - Game Instances")

		GameIcon_W := 48, GameIcon_H := 48
		FillSelected_W := GameIcon_W, FillSelected_H := GameIcon_H

		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	CREATION
		*/

		Gui.Margin("ChooseInstance", 0, 0)
		Gui.Font("ChooseInstance", "Segoe UI", "8")

		topMessage := (mode="Folder")?("Multiple instances running in different folders were detected."
			. "`n`nThe following icons correspond to game instances."
			. "`nThey are grouped based on their folder."
			. "`n`nPlease click on an icon from the folder you would like to monitor and continue.")
					 :(mode="PID")?("The game instance for this tab does not exist anymore."
			. "`n`nThe following icons correspond to game instances."
			. "`nClick on them to activate their corresponding window."
			. "`n`nPlease select the instance you would like to send this message on and continue.")
					:("ERROR: Invalid value for ""mode"" parameter: """ mode """.")

			; = = FAKE "SELECTED" BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		fakeSelectedBordersPos := [{Position:"Top", X:0, Y:0, W:52, H:2}, {Position:"Left", X:0, Y:0, W:2, H:52} ; Top and Left
							,{Position:"Bottom", X:0, Y:0, W:52, H:2}, {Position:"Right", X:0, Y:0, W:2, H:52}] ; Bottom and right

		; Loop 4 {
			; Gui.Add("ChooseInstance", "Progress", "x" fakeSelectedBordersPos[A_Index]["X"] " y" fakeSelectedBordersPos[A_Index]["Y"] 
				; . " w" fakeSelectedBordersPos[A_Index]["W"] " h" fakeSelectedBordersPos[A_Index]["H"] " hwndhPROGRESS_BorderSelected" fakeSelectedBordersPos[A_index]["Position"] " Hidden Background5bcff")
		; }
		Gui.Add("ChooseInstance", "Text", "x0 y0 w" FillSelected_W " h" FillSelected_H " hwndhTEXT_FillSelectedGhost Hidden BackgroundTrans")
		Gui.Add("ChooseInstance", "Progress", "xp yp wp hp hwndhPROGRESS_FillSelected Hidden Background5bcff")
		
		__f := GUI_ChooseInstance.ActivateChosenInstanceWindow.bind(GUI_ChooseInstance)
		GuiControl, ChooseInstance:+g,% GuiChooseInstance_Controls.hTEXT_FillSelectedGhost,% __f

			; = = TOP MESSAGE = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		
		Gui.Add("ChooseInstance", "GroupBox", "x5 y0 w440 R7 c000000 BackgroundTrans")
		Gui.Add("ChooseInstance", "Text", "xp yp+15 wp Center BackgroundTrans", topMessage)

			; = = mode=FOLDER: INSTANCES ICONS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

		groupedInstances := {}, instancesInfos_copy := instancesInfos
		Loop % instancesInfos_copy.Count { ; For every instance
			thisInstanceIndex := A_Index, groupedInstancesIndex := 1
			thisInstanceFolder := instancesInfos_copy[thisInstanceIndex]["Folder"], thisInstancePID := instancesInfos_copy[thisInstanceIndex]["PID"], thisInstanceHwnd := instancesInfos_copy[thisInstanceIndex]["Hwnd"]

			if (thisInstancePID) {

				groupedInstances[thisInstanceIndex] := {}
				groupedInstances[thisInstanceIndex][groupedInstancesIndex] := {}
				groupedInstances[thisInstanceIndex][groupedInstancesIndex]["Folder"] := thisInstanceFolder
				groupedInstances[thisInstanceIndex][groupedInstancesIndex]["PID"] := thisInstancePID
				groupedInstances[thisInstanceIndex][groupedInstancesIndex]["Hwnd"] := thisInstanceHwnd
			}

			instancesInfos_copy[thisInstanceIndex]["Folder"] := instancesInfos_copy[thisInstanceIndex]["PID"] := instancesInfos_copy[thisInstanceIndex]["Hwnd"] := ""

			Loop % instancesInfos_copy.Count { ; We compare with other instances
				comparedInstanceIndex := A_Index, comparedInstanceFolder := instancesInfos_copy[comparedInstanceIndex]["Folder"], comparedInstancePID := instancesInfos_copy[comparedInstanceIndex]["PID"], comparedInstanceHwnd := instancesInfos_copy[comparedInstanceIndex]["Hwnd"]

				if (thisInstanceFolder && thisInstanceFolder = comparedInstanceFolder && thisInstancePID != comparedInstancePID) {
					groupedInstancesIndex++
					groupedInstances[thisInstanceIndex][groupedInstancesIndex] := {}
					groupedInstances[thisInstanceIndex][groupedInstancesIndex]["Folder"] := comparedInstanceFolder
					groupedInstances[thisInstanceIndex][groupedInstancesIndex]["PID"] := comparedInstancePID
					groupedInstances[thisInstanceIndex][groupedInstancesIndex]["Hwnd"] := comparedInstanceHwnd

					instancesInfos_copy[comparedInstanceIndex]["Folder"] := instancesInfos_copy[comparedInstanceIndex]["PID"] := instancesInfos_copy[comparedInstanceIndex]["Hwnd"] := ""
				}
			}
		}

		for groupID, nothing in groupedInstances {
			ypos := (A_Index=1)?("+25"):("+15")
			Gui.Add("ChooseInstance", "Edit", "x5 y" ypos " w440 ReadOnly", groupedInstances[groupID][1]["Folder"]) ; Add folder for this group
			for subGroupID, something in groupedInstances[groupID] {
				xpos := (A_Index=1)?("5"):("+5"), ypos := (A_Index=1)?("+5"):("p")
				Gui.Add("ChooseInstance", "Picture", "x" xpos " y" ypos " w" GameIcon_W " h" GameIcon_H " hwndhIMG_Instance" groupID "_" subGroupID " BackgroundTrans", PROGRAM.ICONS_FOLDER "\PoE.ico") ; Add picture for each instance


				ctrlHwnd := GuiChooseInstance_Controls["hIMG_Instance" groupID "_" subGroupID]
				__f := GUI_ChooseInstance.OnInstanceClick.bind(GUI_ChooseInstance, ctrlHwnd, groupedInstances, groupID, subGroupID)
				GuiControl, ChooseInstance:+g,% ctrlHwnd,% __f
			}
		}

		Gui.Add("ChooseInstance", "Button", "x" 440/2-300/2 " y+20 w300 h25 hwndhBTN_Continue", "Continue")
		__f := GUI_ChooseInstance.OnGUIClose.bind(GUI_ChooseInstance)
		GuiControl, ChooseInstance:+g,% GuiChooseInstance_Controls.hBTN_Continue,% __f

		Gui.Show("ChooseInstance", "Hide")
		Gui.Show("ChooseInstance", "w" guiWidth+5 " h" guiHeight+5)
		WinWait,% "ahk_id " GuiChooseInstance.Handle
		WinWaitClose,% "ahk_id " GuiChooseInstance.Handle
		chosenInstance := ObjFullyClone(CHOOSEN_INSTANCE)
		CHOOSEN_INSTANCE := ""
		Return chosenInstance

		GUI_ChooseInstance_Close:
			GUI_ChooseInstance.OnGUIClose()
		Return

		GUI_ChooseInstance_Size:
			guiWidth := A_GuiWidth, guiHeight := A_GuiHeight
		Return
	}

	OnGUIClose() {
		global PROGRAM, GuiChooseInstance, CHOOSEN_INSTANCE
		CHOOSEN_INSTANCE := ObjFullyClone(GuiChooseInstance.Instance)

		if !(CHOOSEN_INSTANCE.Folder) {
			MsgBox(4096+16, , PROGRAM.TRANSLATIONS.MessageBoxes.ChooseInstance_NoGameInstanceChosen)
		}
		else {
			GUI_ChooseInstance.Destroy()
		}
	}

	OnInstanceClick(CtrlHwnd, instancesGroupArray, instanceGroupID, instanceSubGroupID) {
		global GuiChooseInstance, GuiChooseInstance_Controls

		; Put fill around pic
		imgCoords := Get_ControlCoords("ChooseInstance", CtrlHwnd)
		GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hTEXT_FillSelectedGhost"]
		GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hTEXT_FillSelectedGhost"],% "x" imgCoords.X " y" imgCoords.Y
		GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hPROGRESS_FillSelected"]
		GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hPROGRESS_FillSelected"],% "x" imgCoords.X " y" imgCoords.Y	

		/* Borders instead of fill
			GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedTop"]
			GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedTop"],% "x" imgCoords.X " y" imgCoords.Y-2
			GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedLeft"]
			GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedLeft"],% "x" imgCoords.X-2 " y" imgCoords.Y-2
			GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedBottom"]
			GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedBottom"],% "x" imgCoords.X-2 " y" imgCoords.Y+imgCoords.H
			GuiControl, ChooseInstance:Show,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedRight"]
			GuiControl, ChooseInstance:Move,% GuiChooseInstance_Controls["hPROGRESS_BorderSelectedRight"],% "x" imgCoords.X+imgCoords.W " y" imgCoords.Y
		*/

		choosenInstance := instancesGroupArray[instanceGroupID][instanceSubGroupID]
		GuiChooseInstance.Instance := choosenInstance

		GUI_ChooseInstance.ActivateChosenInstanceWindow()
	}

	ActivateChosenInstanceWindow() {
		global GuiChooseInstance

		DllCall("FlashWindow", UInt, GuiChooseInstance.Instance.Hwnd, Int, 1)
		WinActivate,% "ahk_id " GuiChooseInstance.Instance.Hwnd
	}

	Destroy() {
		Gui.Destroy("ChooseInstance")
	}
}

; GUI_ChooseInstance(_type, arr) {
; 	static
; 	global ProgramValues

; 	if WinExist("ahk_id " hGUIChooseInstance) ; Cancel if GUI already exists.
; 		Return

; ;	Initiate GUI
; 	Controls := {}
; 	guiName := "ChooseInstance"
; 	Gui, %guiName%:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +hwndhGUIChooseInstance,% ProgramValues.Name
; 	Gui, %guiName%:Font,S8,Segoe UI

; ;	Progress to simulate "selected" on click
; 	Loop 4 {
; 		local i := A_Index, w := (i=1||i=2)?(50):(2), h := (i=1||i=2)?(2):(50)

; 		Gui, %guiName%:Add, Progress, x0 y0 w%w% h%h% Hidden hwndhProgress%i% BackgroundBlue
; 		Controls["Border_" i] := hProgress%i%
; 	}

; ;	Top message
; 	local msg := (_type="multiple")?("Multiple instances running in different folders were detected.`nPlease select which one you would like to monitor.")
; 		  :(_type="replace")?("The game instance for this tab does not exist anymore.`nPlease select which existing instance should replace it.")
; 		  :("Unknown. Please report.")
; 	msg .= "`n`nThe following icons correspond to game instances.`nClicking on them will help you dinstinguish them."

; 	Gui, %guiName%:Add, GroupBox, x10 y10 w350 h90 c000000 BackgroundTrans
; 	Gui, %guiName%:Add, Text, xp yp+15 wp Center BackgroundTrans,% msg

; ;	Icon for each instance
; 	for key, handle in arr {
; 		local thisRowContains
; 		local isNewRow := (thisRowContains >= 6)?(true):(false) ; Start new row on 7th item. 6 items per row.
; 		thisRowContains := (isNewRow)?(0):(thisRowContains)
; 		local x := (isNewRow || A_Index = 1)?("x15"):("x+10")

; 		Gui, %guiName%:Add, Picture,% x " w48 h48 g" guiName "_OnSelect vPIC_" key " hwndhPIC_" key " BackgroundTrans",% ProgramValues.Others_Folder "/Icons/POE.ico"
; 		Controls["PIC_" key] := hPIC_%key%
; 		thisRowContains++
; 	}
; 	key := handle := 

; 	Gui, %guiName%:Add, Text,x10 y+10,Location: 
; 	Gui, %guiName%:Add, Edit,x+5 yp-3 w297 hwndhEDIT_Location ReadOnly
; 	Controls["EDIT_Location"] := hEDIT_Location

; 	Gui, %guiName%:Add, Button, x10 y+5 w280 h30 g%guiName%_Accept,Accept
; 	Gui, %guiName%:Add, Button, xp+280 yp w70 h30 g%guiName%_Cancel,Cancel

; ;	Showing the GUI
; 	Gui, %guiName%:Show, NoActivate
; 	WinWait, ahk_id %hGUIChooseInstance%
; 	WinWaitClose, ahk_id %hGUIChooseInstance%
; 	Return selected

; 	ChooseInstance_OnSelect:
; 	/*	Select the clicked instance icon,
; 	 *	 make its taskbar button blink and set as return value
; 	*/
; 		RegExMatch(A_GuiControl, "\d+", btnID)
; 		selected := arr[btnID]

; 		; Simulate "selected"
; 		coords := Get_Control_Coords(A_Gui,Controls[A_GuiControl])
; 		Loop 4 {
; 			local i := A_Index, x := (i=1||i=2)?(coords.X):(i=3)?(coords.X-2):(i=4)?(coords.X+coords.W):(0), y := (i=1||i=3||i=4)?(coords.Y):(i=2)?(coords.Y+coords.H):(0)

; 			GuiControl, %guiName%:Show,% Controls["Border_" i]
; 			GuiControl, %guiName%:Move,% Controls["Border_" i],% "x" x " y" y
; 		}

; 		; Set "location:"
; 		local path
; 		WinGet, path, ProcessPath, ahk_id %selected%
; 		GuiControl, %guiName%:,% Controls["EDIT_Location"],% path

; 		; This make the taskbar button flash once then stop since the window is still active
; 		DllCall("FlashWindow", UInt, selected, Int, 1)
; 		WinActivate, ahk_id %selected%
; 	Return

; 	ChooseInstance_Accept:
; 		if (selected)
; 			Gui,%guiName%:Destroy
; 	Return
; 	ChooseInstance_Cancel:
; 		selected := 
; 		Gui,%guiName%:Destroy
; 	Return
; }