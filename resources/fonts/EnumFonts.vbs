' ----------------------------------------------------------------------------
' Display how many fonts there are in the Windows Fonts folder
' This is the best solution I could find. It shows the exact number of fonts as when we browse to the fonts folder
' Solutions such as EnumFonts() from AHK Forums would not show the correct number and would crashing with Unicode 32 bits
' ----------------------------------------------------------------------------

' Get script folder, define results file location
scriptFolder = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
resultsFile = scriptFolder & "\EnumFontsResults.txt"

' Delete result file if existing
On Error Resume Next ' Avoid showing error box
Set fileObj = CreateObject("Scripting.FileSystemObject") 'Calls the File System Object
fileObj.DeleteFile(resultsFile) ' Delete the file, if existing
fileObj.Close
On Error Goto 0 ' Resume error box

' Create the new result file
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set fileObj = objFSO.CreateTextFile(resultsFile, True)


' Enumerate fonts from the Windows Fonts folder
' Original Source: https://www.activexperts.com/admin/scripts/vbscript/0273/
Const FONTS = &H14&

Set objShell = CreateObject("Shell.Application")
Set objFolder = objShell.Namespace(FONTS)
Set objFolderItem = objFolder.Self
fontsCount = 0

Set colItems = objFolder.Items
For Each objItem in colItems
	fontsCount = fontsCount + 1
	fontsNames = fontsNames & strClean(objItem.Name) & vbCrLf
Next


' Write results to file
writeToFile = "Folder = " & objFolderItem.Path &_
	vbCrLf & "Count = " & fontsCount &_
	vbCrLf & vbCrLf & fontsNames

fileObj.Write writeToFile
fileObj.Close


' ----------------------------------------------------------------------------
' Function to keep only alphadecimal characters
' Original Source: http://www.code-tips.com/2009/04/vbscript-string-clean-function-remove.html
' ----------------------------------------------------------------------------
Function strClean (strtoclean)
Dim objRegExp, outputStr
Set objRegExp = New Regexp

objRegExp.IgnoreCase = True
objRegExp.Global = True
objRegExp.Pattern = "((?![a-zA-Z0-9]).)+"
outputStr = objRegExp.Replace(strtoclean, "-")

objRegExp.Pattern = "\-+"
outputStr = objRegExp.Replace(outputStr, "-")

strClean = outputStr
End Function
