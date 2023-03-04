class GUI_ChooseInstance {

	static guiName := "ChooseInstance"
    static sGUI := {}

	static GuiWidth, GuiHeight, chosenInstance	
	static gameIcon_w := gameIcon_h := 48
	static topMessage_modeFolder := "Multiple instances running in different folders were detected."
			. "`n`nThe following icons correspond to game instances."
			. "`nThey are grouped based on their folder."
			. "`n`nPlease click on an icon from the folder you would like to monitor and continue."
	static topMessage_modePID := "The game instance for this tab does not exist anymore."
			. "`n`nThe following icons correspond to game instances."
			. "`nClick on them to activate their corresponding window."
			. "`n`nPlease select the instance you would like to send this message on and continue."
	
	Create(instancesInfos, mode) {
		global PROGRAM

		delay := SetControlDelay(0), batch := SetBatchLines(-1)
		this.sGUI := new GUI(this.guiName
			, "HwndhGui" this.guiName " +AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +Label" this.__class "."
			, PROGRAM.NAME . this.guiName)
		this.sGUI.SetMargins(0, 0), this.sGUI.SetFont(PROGRAM.FONTS["Segoe UI"]), this.sGUI.SetFontSize(8)

		; = = FAKE "SELECTED" BORDERS = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		fakeSelectedBordersPos := [{Position:"Top", X:0, Y:0, W:52, H:2}, {Position:"Left", X:0, Y:0, W:2, H:52} ; Top and Left
							,{Position:"Bottom", X:0, Y:0, W:52, H:2}, {Position:"Right", X:0, Y:0, W:2, H:52}] ; Bottom and right
		this.sGUI.Add("Text", "x0 y0 w" FillSelected_W " h" FillSelected_H " hwndhTEXT_FillSelectedGhost Hidden BackgroundTrans")
		this.sGUI.Add("Progress", "xp yp wp hp hwndhPROGRESS_FillSelected Hidden Background5bcff"), this.sGUI.BindFunctionToControl("hTEXT_FillSelectedGhost", "ActivateChosenInstanceWindow")

		; = = TOP MESSAGE = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
		this.sGUI.Add("GroupBox", "x5 y0 w440 R7 c000000 BackgroundTrans")
		this.sGUI.Add("Text", "xp yp+15 wp Center BackgroundTrans", mode := folder ? this.topMessage_modeFolder : this.topMessage_modePID)

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
			this.sGUI.Add("Edit", "x5 y" ypos " w440 ReadOnly", groupedInstances[groupID][1]["Folder"]) ; Add folder for this group
			for subGroupID, something in groupedInstances[groupID] {
				xpos := (A_Index=1)?("5"):("+5"), ypos := (A_Index=1)?("+5"):("p")
				this.sGUI.Add("Picture", "x" xpos " y" ypos " w" GameIcon_W " h" GameIcon_H " hwndhIMG_Instance" groupID "_" subGroupID " BackgroundTrans", PROGRAM.ICONS_FOLDER "\PoE.ico") ; Add picture for each instance
				this.sGUI.BindFunctionToControl("hIMG_Instance" groupID "_" subGroupID, "OnInstanceClick", "hIMG_Instance" groupID "_" subGroupID, groupedInstances, groupID, subGroupID)
			}
		}

		this.sGUI.Add("Button", "x" 440/2-300/2 " y+20 w300 h25 hwndhBTN_Continue", "Continue"), this.sGUI.BindFunctionToControl("hBTN_Continue", "OnGUIClose")

		this.sGUI.Show("Hide"),	this.sGUI.Show("w" this.GuiWidth+5 " h" this.GuiHeight+5)
		SetControlDelay(delay), SetBatchLines(batch)
		WinWait,% "ahk_id " this.sGUI.Handle
		WinWaitClose,% "ahk_id " this.sGUI.Handle
		Return ObjFullyClone(this.chosenInstance)
	}

	Size() {
		this.GuiWidth := A_GuiWidth, this.GuiHeight := A_GuiHeight
	}

	Close() {
		this.OnGUIClose()
	}

	OnGUIClose() {
		global PROGRAM
		if !(this.chosenInstance.Folder) {
			MsgBox(4096+16, , PROGRAM.TRANSLATIONS.MessageBoxes.ChooseInstance_NoGameInstanceChosen)
		}
		else {
			this.Destroy()
		}
	}

	OnInstanceClick(ctrlHandleName, instancesGroupArray, instanceGroupID, instanceSubGroupID) {
		guiName := this.Name
		; Put fill around pic
		imgPos := this.sGUI.GetControlPos(ctrlHandleName)
		this.sGUI.ShowControl("hTEXT_FillSelectedGhost"), this.sGUI.MoveControl("hTEXT_FillSelectedGhost", "x" imgPos.X " y" imgPosY)
		this.sGUI.ShowControl("hPROGRESS_FillSelected"), this.sGUI.MoveControl("hPROGRESS_FillSelected", "x" imgPos.X " y" imgPosY)

		this.chosenInstance := instancesGroupArray[instanceGroupID][instanceSubGroupID]
		this.ActivateChosenInstanceWindow()
	}

	ActivateChosenInstanceWindow() {
		DllCall("FlashWindow", UInt, this.chosenInstance.Hwnd, Int, 1)
		WinActivate,% "ahk_id " this.chosenInstance.Hwnd
	}

	Destroy() {
		this.sGUI.Destroy()
	}
}
