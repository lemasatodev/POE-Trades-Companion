Set_FileInfos(file, version="", desc="", copyright="", adds="") {
	if !FileExist("verpatch.exe") {
		MsgBox verpatch.exe not found! Operation aborted.
		ExitApp
	}

	if (version) {
		versionArr := StrSplit(version, ".")
	}
	Loop % 4- versionArr.MaxIndex() { ; File version requires four numbers
		version .= ".0"
	}

	args := "/high"
	args .= (version)?(" """ version """"):("")
	args .= (desc)?(" /s desc """ desc """"):("")
	args .= (product)?(" /s product """ product """"):("")
	args .= (copyright)?(" /s copyright """ copyright """"):("")

	RunWait, verpatch.exe "%file%" %args% %adds%,,Hide
}