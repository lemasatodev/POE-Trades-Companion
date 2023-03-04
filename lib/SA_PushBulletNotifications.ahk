#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoTrayIcon
#NoEnv
ListLines, Off

SetTimer, ExitScript, -20000

cmdLineParams := Get_CmdLineParameters()
PushBulletNotification(cmdLineParams)
ExitApp
Return

ExitScript() {
    global cmdLineParamsObj

    AppendToLogs("SA_PushBulletNotifications.ahk timed out after 20s")

    ExitApp
}

PushBulletNotification(cmdLineParams) {
    global PROGRAM, cmdLineParamsObj
    ; Converting cmd line params into obj
    startPos := 1, cmdLineParamsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break

        startPos := foundPos+StrLen(outMatch.0), cmdLineParamsObj[outMatch.1] := outMatch.2
    }
    ; setting cURL location bcs of how my modified library work
    PROGRAM := {"CURL_EXECUTABLE": cmdLineParamsObj.cURL, "LOGS_FILE": cmdLineParamsObj.ProgramLogsFile}

    pbReturn := PB_PushNote(cmdLineParamsObj.PB_Token, cmdLineParamsObj.PB_Title, cmdLineParamsObj.PB_Message)
    if (pbReturn.Status && pbReturn.Status != 200)
        AppendToLogs("SA_PushBulletNotifications.ahk: Error sending PushBullet notification."
        . "`nData: """ pbReturn.Data
        . "`nHeaders: """ pbReturn.Headers)
}

#Include %A_ScriptDir%
#Include CmdLineParameters.ahk
#Include EasyFuncs.ahk
#Include Logs.ahk
#Include PushBullet.ahk

#Include %A_ScriptDir%/third-party
#Include cURL.ahk
#Include StdOutStream.ahk
#Include UriEncode.ahk
#Include WinHttpRequest.ahk
