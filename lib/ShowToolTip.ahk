/*	Slightly modified version from the one I used in Trades companion.
	This one fixes the issue where the tip would be offset when -Border is not part of the GUI params
*/

RemoveToolTip() {
/*	Reset ShowToolTip() parameters used to detect previous tip and previous tip existence, and remove ToolTip.
*/
	ShowToolTip("",0,0,0,0)
}

ShowToolTip(_tip, tipX=0, tipY=0, radiusX=10, radiusY=10, coord="") {
/*	Show a tooltip at the cursor position, unless specified.
	Tooltip disappears upon moving the mouse outside specified radius.
*/
	static mouseX, mouseY, currentX, currentY, tipRadiusX, tipRadiusY, previousTip, previousTipExists

;	Get current CoordMode settings and set CoordMode
	CoordMode(coord)

;	RemoveToolTip()
	if (!_tip && _tip != 0) {
		previousTip := 
		previousTipExists := false
		ToolTip
		SetTimer, %A_ThisFunc%_Remove, Delete
		CoordMode(coordSettings) ;	Revert CoordMode settings
		Return
	}

;	Radius and mouse position. Used for removal on mouse move out of radius.
	tipRadiusX := radiusX, tipRadiusY := radiusY ; Backup of parameters, so we can declare as static.
	MouseGetPos, mouseX, mouseY

;	Showing the ToolTip
	if (previousTip != _tip || !previousTipExists) {
		ToolTip ; Reset tooltip. Avoid uninteded tooltip style such as underline.
		if (tipX || tipY) { ; Show tip at specified position.
			ToolTip,% _tip,% tipX,% tipY 
		}
		else { ; Let AHK handle position.
			ToolTip,% _tip
		}
	}

	previousTip := _tip ; Avoid replacing previous tip, when previous still exists.
	GoSub, %A_ThisFunc%_Remove ; Run "out of radius" timer.
	return

	ShowToolTip_Remove:
	/*	Remove the tooltip once the mouse exists the square radius.
	*/
	;	Get current CoordMode settings and set CoordMode
		coordSettings := CoordMode()
		CoordMode(coord)

		previousTipExists := true
		MouseGetPos, currentX, currentY

		outOfXRadius := (currentX - mouseX) ** 2 > tipRadiusX ** 2
		outOfYRadius := (currentY - mouseY) ** 2 > tipRadiusY ** 2
		if (outOfXRadius || outOfYRadius) { ; Out of radius. Remove Tip.
			SetTimer, %A_ThisLabel%, Delete
			RemoveToolTip()
			; ToolTip,% mouseX " - " currentX " - " tipRadiusX " - " mouseY " - " currentY " - " tipRadiusY
			previousTipExists := false
		}
		else {
			SetTimer, %A_ThisLabel%, -100
		}

	;	Revert CoordMode settings
		CoordMode(coordSettings)
	return
}