IsUpdateAvailable() {
	global PROGRAM
	if !IsObject(PROGRAM.SETTINGS)
		Declare_LocalSettings()

	useBeta := PROGRAM.SETTINGS.UPDATING.UseBeta, useBeta := useBeta="True"?True:False
	PROGRAM.SETTINGS.UPDATING.LastUpdateCheck := A_Now
	Save_LocalSettings()

	recentRels := GitHubAPI_GetRecentReleases(PROGRAM.GITHUB_USER, PROGRAM.GITHUB_REPO)
	if !(recentRels) {
		AppendToLogs(A_ThisFunc "(): Recent releases is empty!")
		SplashTextOn(PROGRAM.NAME " - Updating Error", "Unable to retrieve recent releases from API."
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1)
		return "ERROR"
	}
	latestRel := recentRels.1
	for index, value in recentRels {
		if (foundStableTag && foundBetaTag)
			Break

		isPreRelease := recentRels[index].prerelease
		if (isPreRelease && !foundBetaTag)
			latestBeta := recentRels[index], foundBetaTag := True
		else if (!isPreRelease && !foundStableTag)
			latestStable := recentRels[index], foundStableTag := True
	}
	stableTag := latestStable.tag_name, betaTag := latestBeta.tag_name

	PROGRAM.SETTINGS.UPDATING.LatestStable := stableTag
	PROGRAM.SETTINGS.UPDATING.LatestBeta := betaTag
	Save_LocalSettings()

	; Determine if stable or beta is better
	stableSplit := StrSplit(stableTag, "."), stable_main := stableSplit.1, stable_patch := stableSplit.2, stable_fix := stableSplit.3
    betaSplit := StrSplit(betaTag, "."), beta_main := betaSplit.1, beta_patch := betaSplit.2, beta_fix := StrSplit(betaSplit.3, "BETA_").2
	
	stableBetter := (stable_main > beta_main) ? True
		: (stable_main = beta_main) && (stable_patch >= beta_patch) ? True
		: False

	; Determine if update is better than current ver
	betterRelTag := stableBetter=True?stableTag:betaTag
	currentSplit := StrSplit(PROGRAM.VERSION, "."), current_main := currentSplit.1, current_patch := currentSplit.2, current_fix := IsContaining(currentSplit.3, "BETA_") ? StrSplit(currentSplit.3, "BETA_").2 : currentSplit.3
	betterTagSplit := StrSplit(betterRelTag, "."), better_main := betterTagSplit.1, better_patch := betterTagSplit.2, better_fix := IsContaining(betterTagSplit.3, "BETA_") ? StrSplit(betterTagSplit.3, "BETA_").2 : betterTagSplit.3
	
	updBetterThanCurrent := (better_main > current_main) ? True
		: (better_main = current_main) && (better_patch > current_patch) ? True
		: (better_main = current_main) && (better_patch = current_patch) && (better_fix > current_fix) ? True
		: False

	; Determine if update is actually available
	updateRel := (!updBetterThanCurrent) ? ""
		: (stableBetter && updBetterThanCurrent) ? latestStable
		: (!stableBetter && updBetterThanCurrent && useBeta) ? latestBeta
		: ""

	if (updateRel = "")
		return False

	relTag := updateRel.tag_name
	relNotes := updateRel.body
	Loop {
		assetName := updateRel.assets[A_Index].name
		SplitPath, assetName, assetFileName, , assetExt
		if (assetExt = "exe")
			exeDL := updateRel.assets[A_Index].browser_download_url
		else if (assetExt = "zip")
			zipDL := updateRel.assets[A_Index].browser_download_url
		else if (assetName = "") || (A_Index > 10)
			Break
	}
	relDL := A_IsCompiled?exeDL : zipDL

	if (relTag && relDL) && (relTag != PROGRAM.VERSION) {
		AppendToLogs(A_ThisFunc "(): Update check: Update found. Tag: " updateRel.tag_name ", Download: " relDL)
		Return {tag:updateRel.tag_name, notes:updateRel.body, download:relDL}
	}
	else if (relTag = PROGRAM.VERSION) {
		AppendToLogs(A_ThisFunc "(): Update check: No update available.")
		return False
	}
	else if (relTag && !relDL) {
		AppendToLogs(A_ThisFunc "(): Update check: Update found but missing asset download. Tag: " updateRel.tag_name ", Download (exe): " exeDL ", Download (zip): " zipDL)
		SplashTextOn(PROGRAM.NAME " - Updating Error", "An update has been detected but cannot be downloaded yet."
		.											"`nPlease try again in a few minutes."
		.											"`n"
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1)
		return "ERROR"
	}
	else {
		AppendToLogs(A_ThisFunc "(): Update check: Failed to retrieve releases from GitHub API.")
		SplashTextOn(PROGRAM.NAME " - Updating Error", "There was an issue when retrieving the latest release from GitHub API"
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1)
		return "ERROR"
	}
}

UpdateCheck(checkType="normal", notifOrBox="notif") {
	global PROGRAM, SPACEBAR_WAIT
	if !IsObject(PROGRAM.SETTINGS)
		Declare_LocalSettings()

	autoupdate := PROGRAM.SETTINGS.UPDATING.DownloadUpdatesAutomatically
	lastUpdateCheck := PROGRAM.SETTINGS.UPDATING.DownloadUpdatesAutomatically.LastUpdateCheck
	if (checkType="forced") ; Fake the last update check, so it's higher than set limit
		lastUpdateCheck := 1994010101010101

	timeDif := A_Now
	timeDif -= lastUpdateCheck, Minutes

	if FileExist(PROGRAM.UPDATER_FILENAME)
		FileDelete,% PROGRAM.UPDATER_FILENAME

	if !(timeDif > 5) ; Hasn't been longer than 5mins since last check, cancel to avoid spamming GitHub API
		Return

	updateRel := IsUpdateAvailable()
	if !(updateRel) {
		trayMsg := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.NoUpdateFound_Msg, "%version%", A_Tab PROGRAM.VERSION)
		trayMsg := StrReplace(trayMsg, "%stable%", A_Tab PROGRAM.SETTINGS.UPDATING.LatestStable)
		trayMsg := StrReplace(trayMsg, "%beta%", A_Tab PROGRAM.SETTINGS.UPDATING.LatestBeta)
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.NoUpdateFound_Title, trayMsg)
		return
	}
	if (updateRel = "ERROR") {
		TrayNotifications.Show(PROGRAM.TRANSLATIONS.TrayNotifications.ErrorOnUpdateCheck_Title, PROGRAM.TRANSLATIONS.TrayNotifications.ErrorOnUpdateCheck_Msg)
		return
	}

	updTag := updateRel.tag, updDL := updateRel.download, updNotes := updateRel.notes
	global UPDATE_TAGNAME, UPDATE_DOWNLOAD, UPDATE_NOTES
	UPDATE_TAGNAME := updTag, UPDATE_DOWNLOAD := updDL, UPDATE_NOTES := updNotes

	if (checkType="on_start") && (autoupdate = "True") {
		DownloadAndRunUpdater()
		return
	}

	if (notifOrBox="box")
		ShowUpdatePrompt(updTag, updDL)
	else if (notifOrBox="notif") {
		trayTitle := StrReplace(PROGRAM.TRANSLATIONS.TrayNotifications.UpdateAvailable_Title, "%update%", updTag)
		TrayNotifications.Show(trayTitle, PROGRAM.TRANSLATIONS.TrayNotifications.UpdateAvailable_Msg, {Is_Update:1, Fade_Timer:20000})
	}
}

ShowUpdatePrompt(ver, dl) {
	global PROGRAM

	boxMsg := StrReplace(PROGRAM.TRANSLATIONS.MessageBoxes.UpdatePrompt_Msg, "%version%", PROGRAM.VERSION)
	boxMsg := StrReplace(boxMsg, "%update%", ver)
	MsgBox(4100, PROGRAM.NAME " - " PROGRAM.TRANSLATIONS.MessageBoxes.UpdatePrompt_Title, boxMsg)
	IfMsgBox, Yes
	{
		DownloadAndRunUpdater(dl)
	}
}

DownloadAndRunUpdater(dl="") {
	global PROGRAM, UPDATE_DOWNLOAD

	if InStr(FileExist(A_ScriptDir "\.git"), "D") {
		MsgBox(4096+48, "", "Updating canceled!"
		. "`n" ".git folder detected at script location."
		. "`n" "Updating has been canceled to avoid overwritting changes.")
		return
	}

	dl := dl?dl : UPDATE_DOWNLOAD
	if !(dl) {
		MsgBox(4096, "", "Dowload URL empty, canceling! ")
		return
	}

	if (!A_IsCompiled) {
		SplitPath, dl, dlFileName
		if FileExist(PROGRAM.MAIN_FOLDER "\Source.zip")
			FileDelete,% PROGRAM.MAIN_FOLDER "\Source.zip"
		if FileExist(PROGRAM.MAIN_FOLDER "\" dlFileName)
			FileDelete,% PROGRAM.MAIN_FOLDER "\" dlFileName

		success := Download(dl, PROGRAM.MAIN_FOLDER "\" dlFileName)
		if !(success) {
			MsgBox(4096+16, "", "Failed to download update!")
			return
		}

		updateFolder := PROGRAM.MAIN_FOLDER "\_UPDATE"
		if FolderExist(updateFolder) {
			FileRemoveDir,% updateFolder, 1
			if (ErrorLevel) {
				MsgBox(4096+16, "", "Failed to delete the old _UPDATE folder!"
				. "`n" updateFolder)
				return
			}
		}

		FileCreateDir,% updateFolder
		Extract2Folder(PROGRAM.MAIN_FOLDER "\" dlFileName, updateFolder)
		FileDelete,% PROGRAM.MAIN_FOLDER "\" dlFileName
		if FileExist(updateFolder "\POE Trades Companion.ahk") {
			extractedFolder := updateFolder
		}
		Else {
			Loop, Files,% updateFolder "\*", RD
			{
				if FileExist(A_LoopFileFullPath "\POE Trades Companion.ahk") {
					extractedFolder := A_LoopFileFullPath
					Break
				}
			}
		}

		if !(extractedFolder) {
			MsgBox(4096+16, "", "Couldn't locate the folder containing updated files.`nPlease try updating manually.")
			FileRemoveDir,% updateFolder, 1
			return
		}

		UnloadFonts()
		if FolderExist(A_ScriptDir "_backup")
			FileRemoveDir,% A_ScriptDir "_backup", 1
		FileCopyDir,% A_ScriptDir,% A_ScriptDir "_backup", 1 ; Make backup
		FileCopyDir,% extractedFolder,% A_ScriptDir, 1 ; Copy new files into current folder
		if (ErrorLevel) {
			MsgBox(4096+16, "", "Failed to copy the new files into the folder.`nThis may be due to an external application currently using " PROGRAM.NAME "'s folder.`nPlease try updating manually.")
			FileRemoveDir,% A_ScriptDir ; Delete folder
			FileCopyDir,% A_ScriptDir "_backup",% A_ScriptDir, 1 ; Restore backup
			FileRemoveDir,% A_ScriptDir "_backup", 1
			FileRemoveDir,% updateFolder, 1
			LoadFonts()
			return
		}
		PROGRAM.SETTINGS.GENERAL.ShowChangelog := "True"
		Save_LocalSettings()
		FileRemoveDir,% A_ScriptDir "_backup", 1
		FileRemoveDir,% updateFolder, 1
		Reload()
	}
	else {
		success := Download(PROGRAM.LINK_UPDATER, PROGRAM.UPDATER_FILENAME)
		if !(success) {
			MsgBox(4096+16, "", "Failed to download the updater!")
			return
		}
		
		Run_Updater(dl)
	}
}

Run_Updater(downloadLink) {
	global PROGRAM

	PROGRAM.SETTINGS.UPDATING.LastUpdate := A_Now
	Save_LocalSettings()

	Run,% PROGRAM.UPDATER_FILENAME 
	. " /Name=""" PROGRAM.NAME  """"
	. " /FileFullPath=""" A_ScriptFullPath """"
	. " /Local_Folder=""" PROGRAM.MAIN_FOLDER """"
	. " /Settings_File=""" PROGRAM.SETTINGS_FILE """"
	. " /Download_Link=""" downloadLink """"
	. " /cURL_Executable=""" PROGRAM.CURL_EXECUTABLE
	ExitApp
}
