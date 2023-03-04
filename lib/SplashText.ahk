SplashTextOn(title, msg, waitForClose=false) {
	Gui, Splash:Destroy
	Gui, Splash:+AlwaysOnTop -SysMenu +hwndhGUISplash
	Gui, Splash:Margin, 0, 0
	Gui, Splash:Font, S10 cBlack, Segoe UI

	Gui, Splash:Add, Text, Center hwndhMSG,% msg "`n`nThis window will close itself in five seconds"
	coords := Get_ControlCoords("Splash", hMSG)
	w := coords.W, h := coords.H
	GuiControl, Splash:Move,% hMSG,% "x5 w" coords.W " h" coords.H

	Gui, Splash:Show,% "w" coords.W+10 " h" coords.H+5,% title
	WinWait, ahk_id %hGUISplash%
	SetTimer, SplashTextOff, -5000
	if (waitForClose)
		WinWaitClose, ahk_id %hGUISplash%	
}

SplashTextOff() {
	global SplashTextOnWaitForSpace
	SplashTextOnWaitForSpace := false

	Gui, Splash:Destroy
}
