LocalSettings_CreateFileIfNotExisting() {
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE

	if !FileExist(settingsFile) {
		defaultSettings := Get_LocalSettings_DefaultValues()
		Save_LocalSettings(defaultSettings)
	}
	else if FileExist(settingsFile) && !Is_JSON(PROGRAM.SETTINGS_FILE) {
		settings := Get_LocalSettings_DefaultValues()
		Save_LocalSettings(settings)
	}
}

Set_LocalSettings() {
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE
	; Set default settings if first time running
	defaultSettings := Get_LocalSettings_DefaultValues()
	if !FileExist(settingsFile) {
		LocalSettings_CreateFileIfNotExisting()
		return
	}
	LocalSettings_Verify()
	; Load settings and reset updating related settings
	localSettings := Get_LocalSettings()
	localSettings.UPDATING.ScriptHwnd := defaultSettings.UPDATING.ScriptHwnd
	localSettings.UPDATING.FileProcessName := defaultSettings.UPDATING.FileProcessName
	localSettings.UPDATING.FileName := defaultSettings.UPDATING.FileName
	localSettings.UPDATING.PID 	:= defaultSettings.UPDATING.PID
	Save_LocalSettings(localSettings)

	/*
	Loop 3 {
		rowNum := A_Index
		Loop % settingsDefaultValues["SETTINGS_CUSTOM_BUTTON_ROW_" A_Index].Buttons_Count {
			btnNum := A_Index
			for key, value in localSettings["SETTINGS_CUSTOM_BUTTON_ROW_" rowNum "_Num" btnNum] {
				doesCustomBtnRow%rowNum%Num%btnNum%Exist := True
				Break
			}
		}
	}

	; Set the order to go through sections
	order := ""
	Loop, Parse, sectsOrder,% ","
	{
		loopedSect := A_LoopField
		for iniSect, nothing in settingsDefaultValues {
			if IsContaining(iniSect, loopedSect) && !IsIn(iniSect, order)
				order .= iniSect ","
		}
	}
	StringTrimRight, order, order, 1
	; Make sure each value is valid
	Loop, Parse, order,% ","
	{
		iniSect := A_LoopField
		for iniKey, defValue in settingsDefaultValues[iniSect] {
			iniValue := localSettings[iniSect][iniKey]
			isValueValid := LocalSettings_IsValueValid(iniSect, iniKey, iniValue)
			if RegExMatch(iniSect, "O)SETTINGS_CUSTOM_BUTTON_ROW_(\d+)_NUM_(\d+)", iniSectPat) {
				rowNum := iniSectPat.1, btnNum := iniSectPat.2

				isValueValid := iniKey="Name"?isValueValid
				: doesCustomBtnRow%rowNum%Num%btnNum%Exist=True?True
				: False
			}

			if (!isValueValid) {
				if (IsFirstTimeRunning != "True")
				&& !IsIn(iniKey, "IsFirstTimeRunning,AddShowGridActionToInviteButtons,HasAskedForImport,RemoveCopyItemInfosIfGridActionExists,ReplaceOldTradeVariables,UpdateKickMyselfOutOfPartyHideoutHotkey,LastUpdateCheck,AskForLanguage")
				&& (iniValue != "")
					warnMsg .= "Section: " iniSect "`nKey: " iniKey "`nValue: " iniValue "`nDefault value: " defValue "`n`n"
				Restore_LocalSettings(iniSect, iniKey)
			}
		}
	}
	; Show which values were restored to default
	warnMsg := ""
	if (warnMsg) {
		Gui, ErrorLog:New, +AlwaysOnTop +ToolWindow +hwndhGuiErrorLog
		Gui, ErrorLog:Add, Text, x10 y10,% "One or multiple ini entries were deemed invalid and were reset to their default value."
		Gui, ErrorLog:Add, Edit, xp y+5 w500 R25 ReadOnly,% warnMsg
		Gui, ErrorLog:Add, Link, xp y+5,% "If you need assistance, you can contact me on: "
		. "<a href=""" PROGRAM.LINK_GITHUB """>GitHub</a> - <a href=""" PROGRAM.LINK_REDDIT """>Reddit</a> - <a href=""" PROGRAM.LINK_GGG """>PoE Forums</a> - <a href=""" PROGRAM.LINK_DISCORD """>Discord</a>"
		Gui, ErrorLog:Show,xCenter yCenter,% PROGRAM.NAME " - Error log"
		WinWait, ahk_id %hGuiErrorLog%
		WinWaitClose, ahk_id %hGuiErrorLog%
	}
	*/
}

Get_LocalSettings() {
	global PROGRAM
	/*
	; if Is_JSON(PROGRAM.SETTINGS_FILE) {
		settings := JSON_Load(PROGRAM.SETTINGS_FILE)
		return settings
	; }
	; else {
	; 	settings := Get_LocalSettings_DefaultValues()
	; 	Save_LocalSettings(settings)
	; 	Get_LocalSettings()
	; }
	*/
	return JSON_Load(PROGRAM.SETTINGS_FILE)
}

Update_LocalSettings() {
	global PROGRAM
	iniFile := PROGRAM.SETTINGS_FILE_OLD
	localSettings := Get_LocalSettings(), defaultSettings := Get_LocalSettings_DefaultValues()
	iniSettings := class_EasyIni(iniFile)

	importPre1Dot15IniSettings := localSettings.GENERAL.ImportPre1Dot15IniSettings
	if (importPre1Dot15IniSettings = "True" && FileExist(iniFile)) {
		Update_LocalSettings_IniFile()
		Convert_IniSettings_To_JsonSettings()
		localSettings := Get_LocalSettings()
		keysToRemove := {GENERAL:["AddShowGridActionToInviteButtons","HasAskedForImport","RemoveCopyItemInfosIfGridActionExists","ReplaceOldTradeVariables","UpdateKickMyselfOutOfPartyHideoutHotkey","HasUpdatedActionsAfter1_15_ActionsRevamp","HasImportedTradesHistoryFromIniToJson"]
			,SETTINGS_MAIN:["Compact_Pos_X","Compact_Pos_Y","AllowClicksToPassThroughWhileInactive","DisableBuyInterface","MinimizeInterfaceToBottomLeft","Pos_X","Pos_Y","SendMsgMode"]}
		for sect in keysToRemove {
			Loop % keysToRemove[sect].Count()
				localSettings[sect].Remove(keysToRemove[sect][A_Index])
		}
		; localSettings.GENERAL.Remove("IsFirstTimeRunning")
		localSettings.GENERAL.ImportPre1Dot15IniSettings := "False"
		Save_LocalSettings(localSettings)
		Set_LocalSettings()
	}

	isFirstTimeRunning := localSettings.GENERAL.IsFirstTimeRunning
	if (isFirstTimeRunning="True") { ; First time running
		localSettings.GENERAL.IsFirstTimeRunning := "False"
		Save_LocalSettings(localSettings)
		Set_LocalSettings()
	}

	; Splitting version in case of need
	priorVersion := localSettings.UPDATING.Version
	priorVersionSplit := StrSplit(priorVersion, "."), prior_main := priorVersionSplit.1, prior_patch := priorVersionSplit.2, prior_fix := IsContaining(priorVersionSplit.3, "BETA_") ? StrSplit(priorVersionSplit.3, "BETA_").2 : priorVersionSplit.3
	; Reset version setting
	localSettings.UPDATING.Version := defaultSettings.UPDATING.Version
	Save_LocalSettings(localSettings)
}

Get_LocalSettings_DefaultValues() {
	; Gets the default values of the settings file
	global PROGRAM
	; Getting default poe skin settings
	poeSkinSettings := GUI_Settings.TabCustomizationSkins_GetSkinDefaultSettings("Path of Exile")
	; Getting current preset and skin settings
	if Is_JSON(PROGRAM.SETTINGS_FILE) {
		currentPreset := JSON_Load(PROGRAM.SETTINGS_FILE).SETTINGS_CUSTOMIZATION_SKINS.Preset
		currentSkin := currentPreset="Custom"?JSON_Load(PROGRAM.SETTINGS_FILE).SETTINGS_CUSTOMIZATION_SKINS_Custom.Skin
					: JSON_Load(PROGRAM.SETTINGS_FILE).SETTINGS_CUSTOMIZATION_SKINS.Skin
		currentSkin := (currentSkin && currentSkin != "" && currentSkin != "ERROR") ? currentSkin : settings.SETTINGS_CUSTOMIZATION_SKINS.Skin
	}
	defaultSkinSettings := GUI_Settings.TabCustomizationSkins_GetSkinDefaultSettings(currentSkin)
	; Getting process name + Setting some other vars
	hw := DetectHiddenWindows("On")
	WinGet, filePName, ProcessName,% "ahk_pid " DllCall("GetCurrentProcessId")
	DetectHiddenWindows(hw)
	ScriptName := A_ScriptName, ScriptHwnd := A_ScriptHwnd, ProgramVersion := PROGRAM.VERSION, ScriptPid := DllCall("GetCurrentProcessId"), sfxFolder := StrReplace(PROGRAM.SFX_FOLDER, "\", "\\")
	poeSkin := poeSkinSettings.Skin, poeFontSize := poeSkinSettings.FontSize, poeFontQuality := poeSkinSettings.FontQuality, poeFontName := poeSkinSettings.Font
	; Creating the default values obj
	settings =
	(
		{
			"GENERAL": { 
				"IsFirstTimeRunning": "True",
				"ImportPre1Dot15IniSettings" : "True",
				"AskForLanguage": "True",
				"Language": "english"
			},

			"SETTINGS_MAIN": {
				"TradingWhisperSFXPath": "%sfxFolder%\\WW_MainMenu_Letter.wav",
				"RegularWhisperSFXPath": "",
				"BuyerJoinedAreaSFXPath": "",
				"NoTabsTransparency": "100",
				"TabsOpenTransparency": "100",
				"HideInterfaceWhenOutOfGame": "True",
				"ShowTabbedTradesCounterButton": "True",
				"CopyItemInfosOnTabChange": "False",
				"AutoFocusNewTabs": "False",
				"AutoMaximizeOnFirstNewTab": "False",
				"SendTradingWhisperUponCopyWhenHoldingCTRL": "True",
				"SendWhoisWithTradingWhisperCTRLCopy": "True",
				"TradingWhisperSFXToggle": "True",
				"RegularWhisperSFXToggle": "False",
				"BuyerJoinedAreaSFXToggle": "False",
				"ShowTabbedTrayNotificationOnWhisper": "True",
				"TradesGUI_Mode": "Window",
				"TradesGUI_Locked": "False",
				"PushBulletToken": "",
				"PushBulletOnTradingWhisper": "True",
				"PushBulletOnPartyMessage": "False",
				"PushBulletOnWhisperMessage": "False",
				"PushBulletOnlyWhenAfk": "True",
				"PoeAccounts": {},
				"MinimizeInterfaceToTheBottom": "True",
				"ItemGridHideNormalTab": "False",
				"ItemGridHideQuadTab": "False",
				"ItemGridHideNormalTabAndQuadTabForMaps": "False"
			},

			"SETTINGS_CUSTOMIZATION_SKINS": {
				"Preset": "%poeSkin%",
				"Skin": "%poeSkin%",
				"UseRecommendedFontSettings": "True",
				"FontSize": "%poeFontSize%",
				"FontQuality": "%poeFontQuality%",
				"Font": "%poeFontName%",
				"ScalingPercentage": "100",
				"Colors": {
					`%poeSettingsColors`%
				}
			},

			"SETTINGS_CUSTOMIZATION_SKINS_Custom": {
				
			},

			"SELL_INTERFACE": {
				"Mode": "Tabs",
				"Pos_X": "0",
				"Pos_Y": "0",
				"CUSTOM_BUTTON_ROW_1": {
					"Buttons_Count": 4,
					"1": {
						"Icon": "Whisper",
						"Actions": {
							"1": {
								"Type": "WRITE_MSG",
								"Content": "\"@`%buyer`% \""
							}
						}
					},
					"2": {
						"Icon": "Invite",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"/invite `%buyer`%\""
							},
							"2": {
								"Type": "SEND_MSG",
								"Content": "\"@`%buyer`% Party invite sent (`%item`% for `%price`%)\""
							}
						}
					},
					"3": {
						"Icon": "Trade",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"/tradewith `%buyer`%\""
							}
						}
					},
					"4": {
						"Icon": "ThumbsUp",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%buyer`% Thank you & good luck!\""
							},
							"2": {
								"Type": "SEND_MSG",
								"Content": "\"/kick `%buyer`%\""
							},
							"3": {
								"Type": "SAVE_TRADE_STATS",
								"Content": "\"\""
							},
							"4": {
								"Type": "CLOSE_TAB",
								"Content": "\"\""
							}
						}
					}
				},
				"CUSTOM_BUTTON_ROW_2": {
					"Buttons_Count": 2,
					"1": {
						"Text": "Busy",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%buyer`% Busy for now, will invite asap (`%item`% for `%price`%)\""
							},
							"2": {
								"Type": "FORCE_MIN",
								"Content": "\"\""
							}
						}
					},
					"2": {
						"Text": "Sold+Ignore",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%buyer`% Already sold, sorry (`%item`% for `%price`%)\""
							},
							"2": {
								"Type": "IGNORE_SIMILAR_TRADE",
								"Content": "\"\""
							},
							"3": {
								"Type": "CLOSE_TAB",
								"Content": "\"\""
							}
						}
					}
				},
				"CUSTOM_BUTTON_ROW_3": {
					"Buttons_Count": 0
				},
				"CUSTOM_BUTTON_ROW_4": {
					"Buttons_Count": 0
				}
			},
			"BUY_INTERFACE": {
				"Mode": "Stack",
				"Pos_X": "405",
				"Pos_Y": "0",
				"CUSTOM_BUTTON_ROW_1": {
					"Buttons_Count": 4,
					"1": {
						"Icon": "Whisper",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%seller`% `%tradingWhisperMsg`%\""
							},
							"2": {
								"Type": "SEND_MSG",
								"Content": "\"/whois `%seller`%\""
							}
						}
					},
					"2": {
						"Icon": "Hideout",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"/hideout `%seller`%\""
							}
						}
					},
					"3": {
						"Icon": "ThumbsUp",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%seller`% ty, gl!\""
							},
							"2": {
								"Type": "SEND_MSG",
								"Content": "\"/kick `%myself`%\""
							},
							"3": {
								"Type": "SEND_MSG",
								"Content": "\"/hideout\""
							},
							"4": {
								"Type": "SAVE_TRADE_STATS",
								"Content": "\"\""
							},
							"5": {
								"Type": "CLOSE_TAB",
								"Content": "\"\""
							}
						}
					},
					"4": {
						"Icon": "ThumbsDown",
						"Actions": {
							"1": {
								"Type": "SEND_MSG",
								"Content": "\"@`%seller`% Sorry, got another\""
							},
							"2": {
								"Type": "CLOSE_TAB",
								"Content": "\"\""
							}
						}
					}
				},
				"CUSTOM_BUTTON_ROW_2": {
					"Buttons_Count": 0
				},
				"CUSTOM_BUTTON_ROW_3": {
					"Buttons_Count": 0
				},
				"CUSTOM_BUTTON_ROW_4": {
					"Buttons_Count": 0
				}
			},

			"HOTKEYS": {
				"1": {
					"Name": "Hideout",
					"Hotkey": "F2",
					"Actions": {
						"1": {
							"Type": "SEND_MSG",
							"Content": "\"/hideout\""
						}
					}
				},
				"2": {
					"Name": "Kick self + Hideout",
					"Hotkey": "+F2",
					"Actions": {
						"1": {
							"Type": "SEND_MSG",
							"Content": "\"/kick `%myself`%\""
						},
						"2": {
							"Type": "SEND_MSG",
							"Content": "\"/hideout\""
						}
					}
				}
			},

			"UPDATING": {
				"PID": %ScriptPid%,
				"FileName": "%ScriptName%",
				"FileProcessName": "%filePName%",
				"ScriptHwnd": "%ScriptHwnd%",
				"Version": "%ProgramVersion%",
				"CheckForUpdatePeriodically": "OnStartAndEveryFiveHours",
				"DownloadUpdatesAutomatically": "True",
				"UseBeta": "True",
				"LastUpdateCheck": "19940426000000"
			}
		}
	)
	; Replacing paths n stuff
	for key, value in poeSkinSettings.COLORS {
		newAppend := """" key """: " """" value """"
		fullAppend := fullAppend?fullAppend "`n," newAppend : newAppend
	}
	settings := StrReplace(settings, "%poeSettingsColors%", fullAppend)
	
	; Loading json obj, return
	return JSON_Load(settings)	
}

LocalSettings_VerifyValuesValidity(ByRef userSettingsObj, defaultSettingsObj, nextObj="", key="", ByRef invalidLogs="") {
	; Assigning obj values
	nextObj := IsObject(nextObj) ? ObjFullyClone(nextObj) : [], nextObj.Push(key)

	; Creating list of parent obj
	for key, value in nextObj
		params2_list := params2_list ? params2_list "`n" value : value
	parents := []
	Loop, Parse, params2_list, `n, `r
		if (A_LoopField != "")
			parents.Push(A_LoopField)

	; The core of the func
	for k, v in userSettingsObj {
		if IsObject(v) ; Start this func again, to go deeper
            A_ThisFunc.(userSettingsObj[k], defaultSettingsObj[k], nextObj, k, invalidLogs)
        else { ; React based on key and parent list
			lastParent := parents[parents.Count()], parentsCount := parents.Count()
			userValue := v, defaultValue := defaultSettingsObj[k]
			; BUY_INTERFACE and SELL_INTERFACE
			if IsIn(parents.1, "BUY_INTERFACE,SELL_INTERFACE") {
				if (k="Mode")
					isValid := IsIn(v, "Tabs,Stack,Disabled")
				else if (k="Buttons_Count") && RegExMatch(lastParent, "iO)CUSTOM_BUTTON_ROW_(\d+)", matchPat)
					isValid := (matchPat.1=1) && IsBetween(userValue, 0, 5) ? True  :  IsBetween(matchPat.1, 2, 4) && IsBetween(userValue, 0, 10) ? True : False
				else if (k="Icon") ; && IsContaining(parents[parentsCount-1], "CUSTOM_BUTTON_ROW_")
					isValid := IsIn(userValue, "Clipboard,Cross,Hideout,Invite,Kick,ThumbsUp,ThumbsDown,Trade,Whisper") ? True : False
				else if (k="Text") ; && IsContaining(parents[parentsCount-1], "CUSTOM_BUTTON_ROW_")
					isValid := True
				else if (k="Content") ; && (parents[parentsCount-1]="Actions")
					isValid := True
				else if (k="Type") ; && (parents[parentsCount-1]="Actions")
					isValid := True
				else if IsIn(k, "Pos_X,Pos_Y")
					isValid := True ; isValid := IsNum(userValue) ? True : False
				else 
					isValid := False
			}
			else if (parents.1 = "GENERAL") {
				if IsIn(k, "AddShowGridActionToInviteButtons,AskForLanguage,HasAskedForImport,IsFirstTimeRunning,RemoveCopyItemInfosIfGridActionExists"
				. ",ReplaceOldTradeVariables,UpdateKickMyselfOutOfPartyHideoutHotkey,ImportPre1Dot15IniSettings")
					isValid := IsIn(userValue, "True,False") ? True : False
				else if (k="Language")
					isValid := IsIn(userValue, "chinese_simplified,chinese_traditional,english,french,russian,portuguese") ? True : False
				else isValid := False
			}
			else if (parents.1 = "HOTKEYS") {
				isValid := True 
			}
			else if IsIn(parents.1, "SETTINGS_CUSTOMIZATION_SKINS,SETTINGS_CUSTOMIZATION_SKINS_Custom") {
				if (lastParent="Colors")
					isValid := IsHex(userValue) && (StrLen(userValue) = 8) ? True : False
				else if (k="Font")
					isValid := True
				else if (k="FontQuality")
					isValid := IsBetween(userValue, 0, 5) ? True : False
				else if IsIn(k, "FontSize,ScalingPercentage")
					isValid := IsNum(userValue) ? True : False
				else if IsIn(k, "Preset,Skin")
					isValid := True
				else if (k="UseRecommendedFontSettings")
					isValid := IsIn(userValue, "True,False") ? True : False
				else isValid := False
			}
			else if (parents.1 = "SETTINGS_MAIN") {
				if IsIn(k, "AllowClicksToPassThroughWhileInactive,AutoFocusNewTabs,AutoMaximizeOnFirstNewTab,AutoMinimizeOnAllTabsClosed,BuyerJoinedAreaSFXToggle"
				. ",CopyItemInfosOnTabChange,HideInterfaceWhenOutOfGame,ShowTabbedTradesCounterButton,ItemGridHideNormalTab,ItemGridHideNormalTabAndQuadTabForMaps,ItemGridHideQuadTab"
				. ",MinimizeInterfaceToTheBottom,PushBulletOnlyWhenAfk,PushBulletOnPartyMessage,PushBulletOnTradingWhisper,PushBulletOnWhisperMessage,"
				. ",RegularWhisperSFXToggle,SendTradingWhisperUponCopyWhenHoldingCTRL,SendWhoisWithTradingWhisperCTRLCopy,ShowTabbedTrayNotificationOnWhisper,TradesGUI_Locked,TradingWhisperSFXToggle")
					isValid := IsIn(userValue, "True,False") ? True : False
				else if IsIn(k, "BuyerJoinedAreaSFXPath,RegularWhisperSFXPath,TradingWhisperSFXPath")
					isValid := (userValue) && FileExist(userValue) ? True : !userValue ? True : False
				else if IsIn(k, "NoTabsTransparency,TabsOpenTransparency")
					isValid := IsNum(userValue) ? True : False
				else if (k="TradesGUI_Mode")
					isValid := IsIn(userValue, "Dock,Window") ? True : False
				else if (k="PushBulletToken" || parents.2 = "PoeAccounts")
					isValid := True
			}
			else if (parents.1 = "UPDATING") {
				if IsIn(k, "DownloadUpdatesAutomatically,UseBeta,UseBeta")
					isValid := IsIn(userValue, "True,False") ? True : False
				if (k="CheckForUpdatePeriodically")
					isValid := IsIn(userValue, "OnStartOnly,OnStartAndEveryFiveHours,OnStartAndEveryDay") ? True : False
				if IsIn(k, "FileName,FileProcessName,LastUpdateCheck,PID,ScriptHwnd,Version")
					isValid := True
			}
			else isValid := False

			if (!isValid && defaultSettingsObj.HasKey(k)) {
				userSettingsObj[k] := defaultValue
				GoSub LocalSettings_VerifyValuesValidity_AppendToLogs
			}
        }
    }
	return

	LocalSettings_VerifyValuesValidity_AppendToLogs:
		logsLine := ""
		for index, parentName in parents
			logsLine := logsLine ? logsLine "." parentName : parentName
		logsLine .= "." k "`nInvalid value: " userValue "`nHas been set to: " defaultValue
		invalidLogs := invalidLogs ? invalidLogs "`n`n" logsLine : logsLine
	return
}

LocalSettings_VerifyFileIntegrity(ByRef userSettingsObj, defaultSettingsObj, nextObj="", key="", ByRef invalidLogs="") {
	; Assigning obj values
	nextObj := IsObject(nextObj) ? ObjFullyClone(nextObj) : [], nextObj.Push(key)

	; Creating list of parent obj
	for key, value in nextObj
		params2_list := params2_list ? params2_list "`n" value : value
	parents := []
	Loop, Parse, params2_list, `n, `r
		if (A_LoopField != "")
			parents.Push(A_LoopField)

	; The core of the func
	for k, v in defaultSettingsObj {

		; parentsList := ""
		; for index, parent in parents
		; 	parentsList .= "`n" index ": " parent
		; StringTrimLeft, parentsList, parentsList, 1

		if IsObject(v) {
			if !userSettingsObj.HasKey(k) {
				if ( IsIn(parents.1, "BUY_INTERFACE,SELL_INTERFACE") && RegExMatch(parents.2, "iO)CUSTOM_BUTTON_ROW_\d+") && IsNum(k) )
				|| ( (parents.1="HOTKEYS") && IsNum(k) )
					Continue

				; msgbox % "ONE`n" parentsList "`nKey: " k

				userSettingsObj[k] := ObjFullyClone(v)
				GoSub LocalSettings_VerifyFileIntegrity_AppendToLogs
			}
			else ; Start this func again, to go deeper
            	A_ThisFunc.(userSettingsObj[k], defaultSettingsObj[k], nextObj, k, invalidLogs)
		}
        else { ; React based on key and parent list
			lastParent := parents[parents.Count()], parentsCount := parents.Count()
			userValue := v, defaultValue := defaultSettingsObj[k]

			if !userSettingsObj.HasKey(k) {
				if ( IsIn(parents.1, "BUY_INTERFACE,SELL_INTERFACE") && RegExMatch(parents.2, "iO)CUSTOM_BUTTON_ROW_\d+") && IsNum(parents.3) ) {
					if ( (k="Icon") && userSettingsObj.HasKey("Text") ) || ( (k="Text") && userSettingsObj.HasKey("Icon") )
						Continue
				}

				; msgbox,4096,, % "TWO`n" parentsList "`nKey: " k

				userSettingsObj[k] := defaultValue
				GoSub LocalSettings_VerifyFileIntegrity_AppendToLogs
			}
		}
	}
	return

	LocalSettings_VerifyFileIntegrity_AppendToLogs:
		logsLine := ""
		for index, parentName in parents
			logsLine := logsLine ? logsLine "." parentName : parentName
		if (parentName)
			logsLine .= "." k "`nInexistent key. Has been set to: " defaultValue
		else logsLine .= k "`nInexistent section. Has been set to default."
		invalidLogs := invalidLogs ? invalidLogs "`n`n" logsLine : logsLine
	return
}

LocalSettings_Verify() {
	; Make sure values are valid, and reset them if not 
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE

	; Getting settings
	defaultSettings := Get_LocalSettings_DefaultValues()
	if !FileExist(settingsFile) { ; Just saving default and return
		Save_LocalSettings(defaultSettings)
		return
	}
	settings := Get_LocalSettings(), settings := IsObject(settings) ? settings : {}
	finalSettings := ObjFullyClone(defaultSettings)
	LocalSettings_VerifyValuesValidity(settings, defaultSettings, "", "", validityLogs)
	LocalSettings_VerifyFileIntegrity(settings, defaultSettings, "", "", integrityLogs)

	allLogs := StrLen(validityLogs) && !StrLen(integrityLogs) ? validityLogs ; only validity
		: !StrLen(validityLogs) && StrLen(integrityLogs) ? integrityLogs  ; only integrity
		: StrLen(validityLogs) && StrLen(integrityLogs) ? validityLogs "`n`n" integrityLogs
		: "" ; nothing

	if (validityLogs)
		AppendToLogs(validityLogs)
	if (integrityLogs)
		AppendToLogs(integrityLogs)
	
	if StrLen(allLogs) {
		global GuiValidityError, GuiValidityErrorBuyPreview, GuiValidityErrorSellPreview, GuiValidityErrorSell
		errorLog := errorLogNoTrim := allLogs
		if ( StrLen(errorLog) > 60000 ) {
			errorLog := StrTrimRight(errorLog, StrLen(errorLog) - 60000)
			errorLog .= "`n`n`n[ Logs trimmed due to AHK length restriction ]"
			AppendToLogs(errorLogNoTrim)
		}
		
		SplitPath, settingsFile, settingsFileName
		Gui.New("ValidityError", "+AlwaysOnTop +ToolWindow +HwndhGui", "GUI Trades Local File Error Logs")
		Gui.Add("ValidityError", "Text", "x10 y10", "The following keys were invalid in the " settingsFileName " file and have been reset to default.")
		Gui.Add("ValidityError", "Edit", "xp y+5 w800 R30 ReadOnly", errorLog)
		Gui.Add("ValidityError", "Link", "xp y+5", "If you need assistance, you can contact me on: "
		. "<a href=""" PROGRAM.LINK_GITHUB """>GitHub</a> - <a href=""" PROGRAM.LINK_REDDIT """>Reddit</a> - <a href=""" PROGRAM.LINK_GGG """>PoE Forums</a> - <a href=""" PROGRAM.LINK_DISCORD """>Discord</a>")
		Gui.Show("ValidityError", "xCenter yCenter")
	}

	Save_LocalSettings(settings)
	return

	/*
	; GENERAL section
	for key in defaultSettings.GENERAL {
		value := settings.GENERAL[key], defValue := defaultSettings.GENERAL[key]

		if IsIn(key, "IsFirstTimeRunning,AddShowGridActionToInviteButtons,HasAskedForImport,RemoveCopyItemInfosIfGridActionExists"
		. ",ReplaceOldTradeVariables,UpdateKickMyselfOutOfPartyHideoutHotkey,AskForLanguage")
			isValid := IsIn(value, "True,False") ? True : False
		else if (key = "Language")
			isValid := IsIn(iniValue, "english,french,chinese_simplified,chinese_traditional,russian,portuguese") ? True : False
		else isValid := False

		finalSettings.GENERAL[key] := isValid?value:defValue
	}
	; SETTINGS_MAIN section
	for key in defaultSettings.SETTINGS_MAIN {
		value := settings.SETTINGS_MAIN[key], defValue := defaultSettings.SETTINGS_MAIN[key]

		if IsIn(key, "TradingWhisperSFXToggle,RegularWhisperSFXToggle,BuyerJoinedAreaSFXToggle"
		. ",HideInterfaceWhenOutOfGame,CopyItemInfosOnTabChange,AutoFocusNewTabs,AutoMinimizeOnAllTabsClosed,AutoMaximizeOnFirstNewTab,SendTradingWhisperUponCopyWhenHoldingCTRL"
		. ",TradesGUI_Locked,AllowClicksToPassThroughWhileInactive,ShowTabbedTrayNotificationOnWhisper,PushBulletOnlyWhenAfk,PushBulletOnTradingWhisper,PushBulletOnPartyMessage,PushBulletOnWhisperMessage"
		. ",MinimizeInterfaceToTheBottom,ItemGridHideNormalTab,ItemGridHideQuadTab,ItemGridHideNormalTabAndQuadTabForMaps,ShowItemGridWithoutInvite,DisableBuyInterface")
			isValid := IsIn(value, "True,False") ? True : False
		else if IsIn(key, "TradingWhisperSFXPath,RegularWhisperSFXPath,BuyerJoinedAreaSFXPath")
			isValid := FileExist(value) ? True : False
		else if IsIn(key, "NoTabsTransparency,TabsOpenTransparency")
			isValid := IsBetween(value, 0, 100) && (key="NoTabsTransparency") ? True : IsBetween(value, 30, 100) && (key="TabsOpenTransparency") ? True : False
		else if (key = "TradesGUI_Mode")
			isValid := IsIn(value, "Window,Dock") ? True : False
		else if IsIn(key, "PushBulletToken,PoeAccounts")
			isValid := True
		else isValid := False

		finalSettings.SETTINGS_MAIN[key] := isValid?value:defValue
	}
	; SETTINGS_CUSTOMIZATION_SKINS section
	skinList := GUI_Settings.TabCustomizationSkins_GetAvailablePresets(), skinsList := StrReplace(skinsList, "|", ",")
	fontsList := GUI_Settings.TabCustomizationSkins_GetAvailableFonts(), fontsList := StrReplace(fontsList, "|", ",")
	Loop 2 {
		sectionKey := A_Index=1?"SETTINGS_CUSTOMIZATION_SKINS":"SETTINGS_CUSTOMIZATION_SKINS_Custom"
		for key in defaultSettings[sectionKey] {
			value := settings[sectionKey][key], defValue := defaultSettings[sectionKey][key]

			if IsIn(key, "UseRecommendedFontSettings")
				isValid := IsIn(value, "True,False") ? True : False
			else if IsIn(key, "FontSize,FontQuality,ScalingPercentage")
				isValid := IsNum(value) ? True : False
			else if IsIn(key, "Preset,Skin")
				isValid := IsIn(value, skinList) ? True : False
			else if (key = "Font")
				isValid := IsIn(value, fontsList) ? True : False
			else isValid := False 

			finalSettings[sectionKey][key] := isValid?value:defValue
		}
		for key in defaultSettings[sectionKey].COLORS {
			value := settings[sectionKey].COLORS[key], defValue := defaultSettings[sectionKey].COLORS[key]
			isValid := IsHex(value) && (StrLen(value) = 8) ? True : False
			finalSettings[sectionKey].COLORS[key] := isValid?value:defValue
		}
	}
	; SELL_INTERFACE section
	; /*
	for key, value in settings.SELL_INTERFACE { ; For every row name
		if IsObject(settings.SELL_INTERFACE[key]) {
			for key2, value2 in settings.SELL_INTERFACE[key] { ; For every button num
				if (key2 = "Buttons_Count")
					isValid := IsNum(value2) ? True : False
				else if IsObject(settings.SELL_INTERFACE[key][key2]) {
					for key3, value3 in settings.SELL_INTERFACE[key][key2] {
						
					}
				}
				else isValid := False  
			}
		}
	}
	; */

	; HOTKEYS section
	for key, value in settings.HOTKEYS {
		isValid := True
	}

	; UPDATING section
	for key in defaultSettings.UPDATING {
		value := settings.UPDATING[key], defValue := defaultSettings.UPDATING[key]

		if IsIn(iniKey, "UseBeta,DownloadUpdatesAutomatically")
			isValid := IsIn(value,"True,False") ? True : False
		else if (key = "CheckForUpdatePeriodically")
			isValid := IsIn(value, "OnStartOnly,OnStartAndEveryFiveHours,OnStartAndEveryDay") ? True : False
		else if (key = "LastUpdateCheck") {
			FormatTime, timeF, %value%, yyyyMMddhhmmss
			isValid := (value > A_Now || timeF > A_Now || StrLen(value) != 14)?False : True
		}

		finalSettings.UPDATING[key] := isValid?value:defValue
	}
	
	Save_LocalSettings(finalSettings)
	*/
}

Restore_LocalSettings(obj, iniKey="") {
	global PROGRAM
	defaultSettings := Get_LocalSettings_DefaultValues()
	settings := Get_LocalSettings()

	

	if (iniKey = "") { ; Replace entire section
		for key, value in PROGRAM.SETTINGS[iniSect]
			INI.Remove(iniFile, iniSect, key)

		for key, value in defSettings[iniSect]
			INI.Set(iniFile, iniSect, key, value)
	}
	else {
		INI.Set(iniFile, iniSect, iniKey, defSettings[iniSect][iniKey])
	}
}

LocalSettings_VerifyEncoding() {
	; Make sure encoding is UTF 16
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE

	; Opening obj and verifying encoding
	hFile := FileOpen(settingsFile, "r")
	if (hFile.Encoding != "UTF-8") { ; Wrong encoding
		; Read file content
		AppendToLogs(A_ThisFunc "(): Wrong ini file encoding (" hFile.Encoding "). Making backup and creating new file with UTF-8 encoding.")
		fileContent := hFile.Read()
		hFile.Close()
		; Rename old file
		SplitPath, settingsFile, fileName
		FileMove,% settingsFile,% PROGRAM.TEMP_FOLDER "\" fileName ".bak", 1
		; Make new file with old content
		hFile := FileOpen(settingsFile, "w", "UTF-8")
		hFile.Write(fileContent)
		hFile.Close()
	}
}

Save_LocalSettings(settingsObj="") {
	; Save the content of PROGRAM.SETTINGS in the local settings file
	global PROGRAM
	settingsFile := PROGRAM.SETTINGS_FILE
	if !IsObject(settingsObj)
		settingsObj := ObjFullyClone(PROGRAM.SETTINGS)
	; Making backup of old file
	SplitPath, settingsFile, fileName
	FileMove,% settingsFile,% PROGRAM.TEMP_FOLDER "\" fileName ".bak", 1
	; Setting content into the settings file
	jsonText := JSON.Dump(settingsObj, "", "`t")
	hFile := FileOpen(settingsFile, "w", "UTF-8")
	hFile.Write(jsonText)
	hFile.Close()
	Declare_LocalSettings(settingsObj)
}

Declare_LocalSettings(settingsObj="") {
	global PROGRAM

	if !IsObject(settingsObj)
		settingsObj := Get_LocalSettings()

	PROGRAM.SETTINGS := {}, PROGRAM.SETTINGS := ObjFullyClone(settingsObj)
}

Update_LocalSettings_IniFile() {
	global PROGRAM
	iniFile := PROGRAM.SETTINGS_FILE_OLD
	localSettings := Get_LocalSettings(), defaultSettings := Get_LocalSettings_DefaultValues()
	iniSettings := class_EasyIni(iniFile)
	oldIni := MyDocuments "\AutoHotkey\POE Trades Companion\Preferences.ini"

	; Import old settings if accepted
	if FileExist(oldIni) {
		hasAsked := INI.Get(PROGRAM.SETTINGS_FILE_OLD, "GENERAL", "HasAskedForImport")
		INI.Set(PROGRAM.SETTINGS_FILE_OLD, "GENERAL", "HasAskedForImport", "True")
		if (hasAsked != "True") {
			AppendToLogs("Showing import pre1.13 settings GUI.")
			GUI_ImportPre1dot13Settings.Show()
			global GuiImportPre1dot13Settings
			WinWait,% "ahk_id " GuiImportPre1dot13Settings.Handle
			WinWaitClose,% "ahk_id " GuiImportPre1dot13Settings.Handle
			AppendToLogs("Successfully closed pre1.13 settings GUI.")
		}
	}

	if !FileExist(iniFile)
		return

	if (iniSettings.GENERAL.AddShowGridActionToInviteButtons = "True") {
		AppendToLogs(A_ThisFunc "(): AddShowGridActionToInviteButtons detected as True."
		. "`n" "Adding SHOW_GRID action to all buttons containing the INVITE_BUYER action.")
		Loop {
			cbIndex := A_Index
			loopedSetting := iniSettings["SETTINGS_CUSTOM_BUTTON_" cbIndex]
			if IsObject(loopedSetting) {
				hasInvite := False, hasGrid := False
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedSetting["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50)
						Break
					
					else if IsContaining(loopedActionContent, "/invite %buyer%") || IsContaining(loopedActionContent, "/invite %buyerName%")
					|| (loopedActionType = "INVITE_BUYER")
						hasInvite := True

					else if (loopedActionType = "SHOW_GRID")
						hasGrid := True
				}
				if (hasInvite = True && hasGrid = False) {
					AppendToLogs(A_ThisFunc "(): Adding SHOW_GRID action to button with"
					. "`n" "ID: """ cbIndex """ - Action index: """ loopActionIndex """")
					INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Content", "")
					INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Type", "SHOW_GRID")
				}
			}
			else if (cbIndex > 20)
				Break
			else
				Break
		}
		AppendToLogs(A_ThisFunc "(): Finished adding SHOW_GRID action.")
		INI.Set(iniFile, "GENERAL", "AddShowGridActionToInviteButtons", "False")
	}

	if (iniSettings.GENERAL.RemoveCopyItemInfosIfGridActionExists = "True") {
		AppendToLogs(A_ThisFunc "(): RemoveCopyItemInfosIfGridActionExists detected as True."
		. "`n" "Removing COPY_ITEM_INFOS action to all buttons containing the SHOW_GRID action.")
		Loop {
			cbIndex := A_Index
			loopedSetting := iniSettings["SETTINGS_CUSTOM_BUTTON_" cbIndex]
			if IsObject(loopedSetting) {
				hasCopy := False, hasGrid := False
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedSetting["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50) {
						loopActionIndex--
						Break
					}
					
					else if (loopedActionType = "COPY_ITEM_INFOS")
						hasCopy := True, copyActionIndex := loopActionIndex

					else if (loopedActionType = "SHOW_GRID")
						hasGrid := True, gridActionIndex:= loopActionIndex
				}
				if (hasCopy = True && hasGrid = True) {
					AppendToLogs(A_ThisFunc "(): Removing COPY_ITEM_INFOS action to button with" . "`t" "ID: """ cbIndex """ - Action index: """ loopActionIndex """. Action ID: """ copyActionIndex """")

					; Reduce action num by one, for every action after COPY_ITEM_INFOS
					startReplaceIndex := copyActionIndex
					Loop % loopActionIndex - copyActionIndex {
						INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" startReplaceIndex "_Content", """" loopedSetting["Action_" startReplaceIndex+1 "_Content"] """")
						INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" startReplaceIndex "_Type", loopedSetting["Action_" startReplaceIndex+1 "_Type"])
						startReplaceIndex++

						AppendToLogs(A_ThisFunc "(): Reducing action index by one for button with" . "`t" "ID: """ cbIndex """ - Action index: """ loopActionIndex """. Action ID: """ startReplaceIndex+1 """")
					}
					; Remove COPY_ITEM_INFOS action
					INI.Remove(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Content")
					INI.Remove(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Type")					
				}
			}
			else if (cbIndex > 20)
				Break
			else
				Break
		}
		AppendToLogs(A_ThisFunc "(): Finished removing COPY_ITEM_INFOS action to buttons with SHOW_GRID action.")
		INI.Set(iniFile, "GENERAL", "RemoveCopyItemInfosIfGridActionExists", "False")
	}

	if (iniSettings.GENERAL.ReplaceOldTradeVariables = "True") {
		AppendToLogs(A_ThisFunc "(): ReplaceOldTradeVariables detected as True."
		. "`n" "Replacing trade variables with new updated names.")
		variablesToReplace := {"%buyerName%":"%buyer%", "%itemName%":"%item%", "%itemPrice%":"%price%", "%lastWhisper%":"%lwr%"
		, "%lastWhisperReceived%":"%lwr%", "%sentWhisper%":"%lws%", "%lastWhisperSent%":"%lws%"}
		; custom buttons
		Loop {
			cbIndex := A_Index
			loopedBtn := iniSettings["SETTINGS_CUSTOM_BUTTON_" cbIndex]
			if IsObject(loopedBtn) {
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedBtn["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedBtn["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50) {
						loopActionIndex--
						Break
					}

					hasReplaced := False, replaceCount := 0
					for key, value in variablesToReplace {
						if IsContaining(loopedActionContent, key) {
							loopedActionContent := StrReplace(loopedActionContent, key, value, replaceCount)
						}
						hasReplaced := hasReplaced=True?True : replaceCount?True : False
					}

					if (hasReplaced) {
						AppendToLogs(A_ThisFunc "(): Replacing " key " variable to button with" . "`t" "ID: """ cbIndex """ - Action index: """ loopActionIndex """")
						INI.Set(iniFile, "SETTINGS_CUSTOM_BUTTON_" cbIndex, "Action_" loopActionIndex "_Content", """" loopedActionContent """")
					}
				}
			}
			else if (cbIndex > 20)
				Break
			else
				Break
		}
		; hotkeys basic
		Loop 15 {
			hkIndex := A_Index
			loopedHK := iniSettings["SETTINGS_HOTKEY_" hkIndex]

			loopedActionContent := loopedHK["Content"]
			loopedActionType := loopedHK["Type"]

			hasReplaced := False, replaceCount := 0
			for key, value in variablesToReplace {
				if IsContaining(loopedActionContent, key)
					loopedActionContent := StrReplace(loopedActionContent, key, value, replaceCount)
				hasReplaced := hasReplaced=True?True : replaceCount?True : False
			}
			
			if (hasReplaced) {
				AppendToLogs(A_ThisFunc "(): Replacing " key " variable to hotkey with"	. "`t" "ID: """ cbIndex """")
				INI.Set(iniFile, "SETTINGS_HOTKEY_" hkIndex, "Content", """" loopedActionContent """")
			}
		}
		; hotkeys adv
		Loop {
			hkIndex := A_Index
			loopedHK := iniSettings["SETTINGS_HOTKEY_ADV_" hkIndex]
			if IsObject(loopedHK) {
				Loop {
					loopActionIndex := A_Index
					loopedActionContent := loopedHK["Action_" loopActionIndex "_Content"]
					loopedActionType := loopedHK["Action_" loopActionIndex "_Type"]

					if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50) {
						loopActionIndex--
						Break
					}

					hasReplaced := False, replaceCount := 0
					for key, value in variablesToReplace {
						if IsContaining(loopedActionContent, key) {
							loopedActionContent := StrReplace(loopedActionContent, key, value, replaceCount)
						}
						hasReplaced := hasReplaced=True?True : replaceCount?True : False
					}

					if (hasReplaced) {
						AppendToLogs(A_ThisFunc "(): Replacing " key " variable to hotkey adv with" . "`t" "ID: """ cbIndex """ - Action index: """ loopActionIndex """")	
						INI.Set(iniFile, "SETTINGS_HOTKEY_ADV_" hkIndex, "Action_" loopActionIndex "_Content", """" loopedActionContent """")
					}
				}
			}
			else if (hkIndex > 200)
				Break
			else
				Break
		}

		AppendToLogs(A_ThisFunc "(): Finished replacing trade variables with new updated names.")
		INI.Set(iniFile, "GENERAL", "ReplaceOldTradeVariables", "False")
	}

	if (iniSettings.GENERAL.UpdateKickMyselfOutOfPartyHideoutHotkey = "True") {
		AppendToLogs(A_ThisFunc "(): UpdateKickMyselfOutOfPartyHideoutHotkey detected as True."
		. "`n" "Replacing adv hotkey with new action.")

		if (iniSettings.SETTINGS_HOTKEY_ADV_1.Name = "Kick myself out of party + hideout") {
			/* Disabled due to incompatibility when converting to JSON (missing functions and settings)
			INI.Remove(iniFile, "SETTINGS_HOTKEY_ADV_1")
			Restore_LocalSettings("SETTINGS_HOTKEY_ADV_1")
			*/
		}

		AppendToLogs(A_ThisFunc "(): Finished replacing adv hotkey with new action.")
		INI.Set(iniFile, "GENERAL", "UpdateKickMyselfOutOfPartyHideoutHotkey", "False")
	}

	if (iniSettings.GENERAL.HasUpdatedActionsAfter1_15_ActionsRevamp != "True") {
		Loop 2 { ; Once for custom buttons, another for adv hotkeys
			firstLoopIndex := A_Index
			Loop {
				cbIndex := A_Index
				iniSection := firstLoopIndex=1 ? "SETTINGS_CUSTOM_BUTTON_" cbIndex
					: firstLoopIndex=2 ? "SETTINGS_HOTKEY_ADV_" cbIndex : ""
				loopedSetting := iniSettings[iniSection]
				if IsObject(loopedSetting) {
					thisBtnActionsCount := 0
					Loop {
						loopActionIndex := A_Index
						loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

						if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50)
							Break
						
						thisBtnActionsCount++
					}
					Loop {
						loopActionIndex := A_Index
						loopedActionContent := loopedSetting["Action_" loopActionIndex "_Content"]
						loopedActionType := loopedSetting["Action_" loopActionIndex "_Type"]

						if (!loopedActionType) || (loopedActionType = "") || (loopActionIndex > 50)
							Break

						acIndex := loopActionIndex, totalAcCount := thisBtnActionsCount
						acType := loopedActionType, acContent := loopedActionContent

						GoSub Update_LocalSettings_IniFile_ReplaceOldSendActions
						GoSub Update_LocalSettings_IniFile_ReplaceOldWriteActions
						GoSub Update_LocalSettings_IniFile_ReplaceOldWriteGoBackActions
						GoSub Update_LocalSettings_IniFile_RemoveShowGridAction
						GoSub Update_LocalSettings_IniFile_ReplaceIgnoreSimilarTradeAction
					}
				}
				else if (cbIndex > 50)
					Break
				else
					Break
			}
		}

		Loop 15 { ; 15 basic hk
			isBasicHk := True, cbIndex := A_Index
			iniSection := "SETTINGS_HOTKEY_" cbIndex
			loopedSetting := iniSettings[iniSection]
			acType := loopedSetting.Type, acContent := loopedSetting.Content

			GoSub Update_LocalSettings_IniFile_ReplaceOldSendActions
			GoSub Update_LocalSettings_IniFile_ReplaceOldWriteActions
			GoSub Update_LocalSettings_IniFile_ReplaceOldWriteGoBackActions
			GoSub Update_LocalSettings_IniFile_RemoveShowGridAction
			GoSub Update_LocalSettings_IniFile_ReplaceIgnoreSimilarTradeAction
			isBasicHk := False
		}

		INI.Set(iniFile, "GENERAL", "HasUpdatedActionsAfter1_15_ActionsRevamp", "True")
	}

	if (iniSettings.GENERAL.HasImportedTradesHistoryFromIniToJson != "True") {
		oldBuyFile := PROGRAM.TRADES_BUY_HISTORY_FILE_OLD, newBuyFile := PROGRAM.TRADES_BUY_HISTORY_FILE
		oldSellFile := PROGRAM.TRADES_SELL_HISTORY_FILE_OLD, newSellFile := PROGRAM.TRADES_SELL_HISTORY_FILE

		FileDelete,% oldBuyFile ; It was bugged, nothing was being saved inside

		oldSellObj := class_EasyIni(oldSellFile)
		newSellObj := {"Pre_1_15":{}}
		Loop % oldSellObj.GENERAL.Index {
			newSellObj["Pre_1_15"][A_Index] := ObjFullyClone(oldSellObj[A_Index])
		}
		; Making backup of old file
		SplitPath, oldSellFile, fileName
		FileMove,% oldSellFile,% PROGRAM.TEMP_FOLDER "\" A_Now "_" fileName ".bak", 1
		; Making backup of new file if exist
		SplitPath, newSellFile, fileName
		FileMove,% newSellFile,% PROGRAM.TEMP_FOLDER "\" A_Now "_" fileName ".bak", 1
		; Setting content into the settings file
		jsonText := JSON.Dump(newSellObj, "", "`t")
		hFile := FileOpen(newSellFile, "w", "UTF-8")
		hFile.Write(jsonText)
		hFile.Close()

		INI.Set(iniFile, "GENERAL", "HasImportedTradesHistoryFromIniToJson", "True")
	}

	if (PROGRAM.IS_BETA = "True")
		INI.Set(iniFile, "UPDATING", "UseBeta", "True")
	
	return

	Update_LocalSettings_IniFile_ReplaceOldSendActions:
		if IsIn(acType, "SEND_TO_LAST_WHISPER,SEND_TO_LAST_WHISPER_SENT,SEND_TO_BUYER,INVITE_BUYER,TRADE_BUYER,KICK_BUYER,KICK_MYSELF"
		. ",CMD_AFK,CMD_AUTOREPLY,CMD_DND,CMD_HIDEOUT,CMD_OOS,CMD_REMAINING,CMD_WHOIS") {
			INI.Set(iniFile, iniSection, isBasicHk ? "Type" : "Action_" acIndex "_TYPE", "SEND_MSG")
			AppendToLogs(A_ThisFunc "(): Replaced " acType " action with SEND_MSG to button:"
			. "`n" "Section: """ iniSection """ - Action Index: """ acIndex """")
		}	
	return

	Update_LocalSettings_IniFile_ReplaceOldWriteActions:
		if IsIn(acType, "WRITE_MSG,WRITE_TO_LAST_WHISPER,WRITE_TO_LAST_WHISPER_SENT,WRITE_TO_BUYER") {
			INI.Set(iniFile, iniSection, isBasicHk ? "Type" : "Action_" acIndex "_TYPE", "WRITE_MSG")
			AppendToLogs(A_ThisFunc "(): Replaced " acType " action with WRITE_MSG to button:"
			. "`n" "Section: """ iniSection """ - Action Index: """ acIndex """")
		}
	return

	Update_LocalSettings_IniFile_ReplaceOldWriteGoBackActions:
		if (acType = "WRITE_THEN_GO_BACK") {
			INI.Set(iniFile, iniSection, isBasicHk ? "Content" : "Action_" acIndex "_CONTENT", StrReplace(acContent, "{X}", "%goBackHere%") )
			INI.Set(iniFile, iniSection, isBasicHk ? "Type" : "Action_" acIndex "_TYPE", "WRITE_MSG")
			AppendToLogs(A_ThisFunc "(): Replaced WRITE_THEN_GO_BACK to WRITE_MSG and {X} to %goBackHere%"
			. "`n" "Section: """ iniSection """ - Action Index: """ acIndex """")
		}
	return

	Update_LocalSettings_IniFile_RemoveShowGridAction:
		if (acType = "SHOW_GRID") {
			if (isBasicHk) {
				INI.Remove(iniFile, iniSection)
			}
			else {
				acToReplaceCount := totalAcCount-acIndex, acStartReplaceIndex := acIndex
				GoSub Update_LocalSettings_IniFile_MoveActionsUp
			}
		}
	return

	Update_LocalSettings_IniFile_MoveActionsUp:
		iniSettingsCopy := ObjFullyClone(iniSettings)
		currentReplaceIndex := acStartReplaceIndex
		Loop % acToReplaceCount {
			nextAcType := iniSettingsCopy[iniSection]["Action_" currentReplaceIndex+1 "_Type"]
			nextAcContent := iniSettingsCopy[iniSection]["Action_" currentReplaceIndex+1 "_Content"]
			nextAcContent := SubStr(nextAcContent, 1, 1) = """" ? nextAcContent : """" nextAcContent, nextAcContent := SubStr(nextAcContent, 0, 1) = """" ? nextAcContent : nextAcContent """"

			INI.Set(iniFile, iniSection, "Action_" currentReplaceIndex "_Content", nextAcContent)
			INI.Set(iniFile, iniSection, "Action_" currentReplaceIndex "_Type", nextAcType)
			AppendToLogs(A_ThisFunc "(): Reducing action index by one"
			. "`n" "Section: """ iniSection """ - Action Index: """ acIndex """")

			currentReplaceIndex++
		}
		INI.Remove(iniFile, iniSection, "Action_" totalAcCount "_Content")
		INI.Remove(iniFile, iniSection, "Action_" totalAcCount "_Type")	
	return

	Update_LocalSettings_IniFile_ReplaceIgnoreSimilarTradeAction:
		if (acType = "IGNORE_SIMILAR_TRADE") {
			INI.Set(iniFile, iniSection, "Action_" acIndex "_CONTENT", "10")
			AppendToLogs(A_ThisFunc "(): Set 10 as IGNORE_SIMILAR_TRADE value to button:"
			. "`n" "Section: """ iniSection """ - Action Index: """ acIndex """")
		}
	return
}

Convert_IniSettings_To_JsonSettings() {
	global PROGRAM
	iniFile := PROGRAM.SETTINGS_FILE_OLD
	defaultSettings := Get_LocalSettings_DefaultValues(), iniSettings := class_EasyIni(iniFile)
	newJsonSettings := ObjFullyClone(defaultSettings)

	; * * * * Importing sections
	newJsonSettings.GENERAL := ObjReplace(newJsonSettings.GENERAL, iniSettings.GENERAL)
	newJsonSettings.SETTINGS_MAIN := ObjReplace(newJsonSettings.SETTINGS_MAIN, iniSettings.SETTINGS_MAIN)
	newJsonSettings.UPDATING := ObjReplace(newJsonSettings.UPDATING, iniSettings.UPDATING)

	; * * * * Importing account list
	accounts := iniSettings.SETTINGS_MAIN.PoeAccounts
	newJsonSettings.SETTINGS_MAIN.PoeAccounts := {}
	Loop, Parse, accounts,% ","
		newJsonSettings.SETTINGS_MAIN.PoeAccounts.Push(A_LoopField)

	; * * * * Importing positions
	newJsonSettings.BUY_INTERFACE.Pos_X := iniSettings.SETTINGS_MAIN.Compact_Pos_X
	newJsonSettings.BUY_INTERFACE.Pos_Y := iniSettings.SETTINGS_MAIN.Compact_Pos_Y
	newJsonSettings.SELL_INTERFACE.Pos_X := iniSettings.SETTINGS_MAIN.Pos_X
	newJsonSettings.SELL_INTERFACE.Pos_Y := iniSettings.SETTINGS_MAIN.Pos_Y

	/*	Disabled. It's better to reset them to default.
	; * * * * Importing skin settigns
	Loop 2 { ; Normal and Custom
		iniSections := ["SETTINGS_CUSTOMIZATION_SKINS","SETTINGS_CUSTOMIZATION_SKINS_UserDefined"]
		jsonSections := ["SETTINGS_CUSTOMIZATION_SKINS","SETTINGS_CUSTOMIZATION_SKINS_Custom"]
		newJsonSettings[iniSection] := {}, newJsonSettings[iniSection].COLORS := {}
		for key, value in iniSettings[iniSection] {
			if RegExMatch(key, "iO)Color_(.*)", keyOut)
				newJsonSettings[iniSection].COLORS[keyOut.1] := value 
			else 
				newJsonSettings[iniSection][key] := value
		}
	}
	*/

	; * * * * Importing custom buttons
	CustomButtons_1 := {}, CustomButtons_2 := {}, CustomButtons_3 := {}
	Loop 9 { ; Once to get settings
		loopIndex := A_Index
		iniSection := "SETTINGS_CUSTOM_BUTTON_" loopIndex
		if (iniSettings[iniSection].Enabled = "True") { ; Forcing actions based on one of our new buttons
			slotNum := iniSettings[iniSection].Slot
			CustomButtons_1[slotNum] := iniSettings[iniSection]
		}
	}

	for num, nothing in CustomButtons_1 ; Another to make sure it starts in order
		CustomButtons_2[A_Index] := CustomButtons_1[num]

	for num, nothing in CustomButtons_2 { ; And last to adapt it to json
		actionsObj := {}
		for key, value in CustomButtons_2[num] { ; Creating array of actions
			if RegExMatch(key, "iO)Action_(\d+)_(.*)", outVarObj) {
				if !IsObject(actionsObj[outVarObj.1])
					actionsObj[outVarObj.1] := {}
				actionsObj[outVarObj.1][outVarObj.2] := value
			}
		}
		CustomButtons_3[num] := {Text: CustomButtons_2[num].Name, Actions: ObjFullyClone(actionsObj)}
	}
	CustomButtons := ObjFullyClone(CustomButtons_3), CustomButtons_1 := CustomButtons_2 := CustomButtons_3 := ""

	; * * * * Building the SELL_INTERFACE obj
		; Adding special buttons row
	newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_1 := ObjFullyClone(defaultSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_1)
		; Creating obj for custom buttons
	if ( CustomButtons.Count() ) {
		Loop 3
			newJsonSettings.SELL_INTERFACE["CUSTOM_BUTTON_ROW_" A_Index+1] := {}
	}
	newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_2.Buttons_Count := ( CustomButtons.Count() >= 5 ) ? 5 : CustomButtons.Count()
	newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_3.Buttons_Count := ( CustomButtons.Count() >= 5 ) ? CustomButtons.Count() - 5 : CustomButtons.Count()
	newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_4.Buttons_Count := 0
		; Adding custom buttons
	Loop % CustomButtons.Count() {
		if IsBetween(A_Index, 1, 5)
			newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_2[A_Index] := CustomButtons[A_Index]
		else
			newJsonSettings.SELL_INTERFACE.CUSTOM_BUTTON_ROW_3[A_Index-5] := CustomButtons[A_Index]
	}

	; * * * * Building the BUY_INTERFACE obj
	if (iniSettings.SETTINGS_MAIN.DisableBuyInterface = "True") {
		newJsonSettings.BUY_INTERFACE.Mode := "Disabled"
	}

	; * * * * Importing hotkeys
	miscTrans := PROGRAM.TRANSLATIONS.MISC
	newJsonSettings.HOTKEYS := {}
	; First, adv hotkeys as they have a profile name
	for iniSect in iniSettings {
		if !RegExMatch(iniSect, "i)SETTINGS_HOTKEY_ADV_\d+")
			Continue

		thisHK := iniSettings[iniSect]
		hkCount := newJsonSettings.HOTKEYS.Count()
		newJsonSettings.HOTKEYS[hkCount+1] := {"Name": thisHK.Name, "Hotkey": thisHK.Hotkey, "Actions": {}}
		for iniKey, iniValue in iniSettings[iniSect] {
			if ( RegExMatch(iniKey, "iO)Action_(\d+)_Type", matchObj) || RegExMatch(iniKey, "iO)Action_(\d+)_Content", matchObj) )
			&& !IsObject(newJsonSettings.HOTKEYS[hkCount+1].Actions[matchObj.1])
				newJsonSettings.HOTKEYS[hkCount+1].Actions[matchObj.1] := {}

			if RegExMatch(iniValue, "iO)CUSTOM_BUTTON_(\d+)", matchObj) { ; Convert the button hotkey
				if (matchObj.1 <= 5)
					iniValue := "SELL_INTERFACE_CUSTOM_BUTTON_ROW_2_NUM_" matchObj.1
				else
					iniValue := "SELL_INTERFACE_CUSTOM_BUTTON_ROW_3_NUM_" matchObj.1-5
			}

			if RegExMatch(iniKey, "iO)Action_(\d+)_Type", matchObj)
				newJsonSettings.HOTKEYS[hkCount+1].Actions[matchObj.1].Type := iniValue
			else if RegExMatch(iniKey, "iO)Action_(\d+)_Content", matchObj)
				newJsonSettings.HOTKEYS[hkCount+1].Actions[matchObj.1].Content := iniValue
		}
	}
	; Now basic hotkeys
	Loop 15 {
		iniSect := "SETTINGS_HOTKEY_" A_Index
		thisHK := iniSettings[iniSect]

		if (!thisHk.Type)
			Continue

		hkCount := newJsonSettings.HOTKEYS.Count()
		thisHkHotkey := thisHk.Enabled = "True" ? thisHK.Hotkey : "", hkType := thisHK.Type

		if RegExMatch(hkType, "iO)CUSTOM_BUTTON_(\d+)", matchObj) { ; Convert the button hotkey
			if (matchObj.1 <= 5)
				hkType := "SELL_INTERFACE_CUSTOM_BUTTON_ROW_2_NUM_" matchObj.1
			else
				hkType := "SELL_INTERFACE_CUSTOM_BUTTON_ROW_3_NUM_" matchObj.1-5
		}
		
		newJsonSettings.HOTKEYS[hkCount+1] := {"Name": "New hotkey " hkCount+1, "Hotkey": thisHkHotkey, "Actions": [{"Type": hkType, "Content": thisHk.Content}]}
	}

	; Now converting ini into json
	Save_LocalSettings(newJsonSettings)
	SplitPath, iniFile, fileName
	FileMove,% iniFile,% PROGRAM.TEMP_FOLDER "\" A_Now "_" fileName, 1
}
