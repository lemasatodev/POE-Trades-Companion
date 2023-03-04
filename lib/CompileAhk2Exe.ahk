Run_Ahk2Exe(fileIn, fileOut="", fileIcon="", mpress=0, binFile="Unicode 32-bit.bin") {
	EnvGet, ProgramW6432, ProgramW6432
	_ProgramFiles := (ProgramW6432)?(ProgramW6432):(A_ProgramFiles)
	ahk2ExePath := _ProgramFiles "\AutoHotkey\Compiler\Ahk2Exe.exe"


	SplitPath, fileIn, , fileInDir, , fileInNoExt
	SplitPath, fileOut, , fileOutDir, , fileOutNoExt

	if (!fileInDir)
		fileInDir := A_ScriptDir
	if (!fileOutDir)
		fileOutDir := fileInDir

	fileInParam := " /in " """" fileIn """"
	fileOutParam := (fileOut)?(fileOutDir "\" fileOut):(fileOutDir "\" fileInNoExt ".exe")
	fileOutParam := " /out " """" fileOutParam """"

	fileIconParam := (fileIcon)?(" /icon " """" fileIcon """"):("")

	mpressParam := (mpress)?(" /mpress 1"):(" /mpress 0")

	SplitPath, binFile, binFileName, binFileDir
	if (!binFileDir) {
		binFileDir := _ProgramFiles "\AutoHotkey\Compiler"
		binFileFullPath := _ProgramFiles "\AutoHotkey\Compiler\" binFile
		binParam := " /bin """ binFileFullPath """"
	}
	else {
		binFileFullPath := binFile
		binParam := " /bin " """" binFile """"
	}

	if (binFile && !FileExist(binFileFullPath)) {
		MsgBox % binFile " not found in " _ProgramFiles "\AutoHotkey\Compiler\"
		. "`nOperation aborted."
		ExitApp
	}

	RunWait, %ahk2ExePath% %fileInParam% %fileOutParam% %fileIconParam% %mpressParam% %binParam% ,,Hide
}
