Get_ProcessInfos(_processName="", _processID="", _userName="") {
/*		Slightly modified version of the function by Oldman
   		autohotkey.com/board/topic/109575-how-to-detect-if-a-processapplication-is-running-with-elevated-rights/?p=652327

  		Usage example: pInfos := Get_ProcessInfos("PathOfExile.exe")
   		When successful, pInfos will become an array containing a subArray for every instance found.
   		pInfos[1]["ProcessID"] for example contains the PID of the first instance found.
        Using the process PID as second parameter will allow to retrieve infos for that specific PID only.

   		Return values:
   			Array: Contains a sub key for every matching instance found
   				   Name, ProcessID, CommandLine, TokenIsElevated, ElevationType

    		Empty: Non-existent process
    		0: Process is not elevated
            2: Unable to access process.
            Script that used the function is not elevated, but _processName most likely is.
    		3: Error occured

    */
   	STANDARD_RIGHTS_READ      = 0x00020000
   	TOKEN_QUERY               = 0x0008
   	TOKEN_READ               := STANDARD_RIGHTS_READ | TOKEN_QUERY
    	
   	wbemFlagForwardOnly       = 0x20
   	wbemFlagReturnImmediately = 0x10
   	Flags := wbemFlagForwardOnly | wbemFlagReturnImmediately
     
   	TokenElevationType        = 18
   	TokenElevation            = 20
    	
   	PROCESS_ALL_ACCESS        = 0x1F0FFF
   	PROCESS_QUERY_INFORMATION = 0x0400
     
   	TokenElevationTypeDefault = 1
   	TokenElevationTypeFull    = 2
   	TokenElevationTypeLimited = 3
     
   	Arr := []
   	SubArr := {}
    	
   	if !hModule := DllCall("kernel32.dll\LoadLibrary", "Str", "advapi32.dll", "Ptr")
    {
   		MsgBox, % "LoadLibrary(advpi.dll) failed " A_LastError
   		return 2
   	}

   	Query := "Select Name, Handle, ProcessId, CommandLine From Win32_Process"
   	
   	if _processName
   		Query .= " Where Name = '" _processName "'"

   	if _processID {
   		if Query contains Where
   			Query .= " And ProcessID = '" _processID "'"
   		else 
   			Query .= " Where ProcessID = '" _processID "'"
   	}
    	
   	UserName := ComVar()

   	for p in ComObjGet("winmgmts:").ExecQuery(Query, "WQL", Flags)
   	{
   		p.GetOwner(UserName.ref, Domain.ref)
    		
   		if _userName
   			if (UserName[] <> _userName)
   				continue
    		
   		if !hProcess := DllCall("kernel32.dll\OpenProcess", "UInt", PROCESS_QUERY_INFORMATION
   																		  , "Int" , true
   																		  , "UInt", p.ProcessId)
   		{
   			; MsgBox, % "OpenProcess() failed " A_LastError
   			gosub, IsProcessElevated_CloseHandles
   			gosub, IsProcessElevated_FreeLibrary
   			return 2
   		}
    		
   		if !DllCall("advapi32.dll\OpenProcessToken", "Ptr" , hProcess
 															  , "UInt", TOKEN_READ
   															  , "UIntP", hToken)
   		{
   			MsgBox, % "OpenProcessToken() failed " A_LastError
   			gosub, IsProcessElevated_CloseHandles
   			gosub, IsProcessElevated_FreeLibrary
   			return 3
   		}
   		
   		TokenIsElevated := 0
   		TokenLength     := 0
   		if !DllCall("advapi32.dll\GetTokenInformation", "Ptr"  , hToken
   																  , "UInt" , TokenElevation
   																  , "UIntP", TokenIsElevated
   																  , "UInt" , 4
   																  , "UIntP", TokenLength)
   		{
   			MsgBox, % "GetTokenInformation(TokenElevation) failed " A_LastError
   			gosub, IsProcessElevated_CloseHandles
   			gosub, IsProcessElevated_FreeLibrary
   			return 3
   		}
    		
   		ElevationType   := 0
   		ElevationLength := 0
   		if !DllCall("advapi32.dll\GetTokenInformation", "Ptr"  , hToken
   																  , "UInt" , TokenElevationType
   																  , "UIntP", ElevationType
   																  , "UInt" , 4
   																  , "UIntP", ElevationLength)
   		{
   			MsgBox, % "GetTokenInformation(TokenElevationType) failed " A_LastError
   			gosub, IsProcessElevated_CloseHandles
   			gosub, IsProcessElevated_FreeLibrary
   			return 3
   		}
    		
   		gosub, IsProcessElevated_CloseHandles

   		SubArr["Name"] := p.Name
   		SubArr["ProcessID"] := p.ProcessID
   		SubArr["CommandLine"] := p.CommandLine
   		SubArr["TokenIsElevated"] := TokenIsElevated
   		SubArr["ElevationType"] := ElevationType
    		
   		Arr.Insert(SubArr)
   	}

   	gosub, IsProcessElevated_FreeLibrary
   	return Arr
     
    IsProcessElevated_CloseHandles:
    	if hToken
    		if !DllCall("kernel32.dll\CloseHandle", "Ptr", hToken)
    			MsgBox, % "CloseHandle(hToken) failed " A_LastError
     
    	if hProcess
    		if !DllCall("kernel32.dll\CloseHandle", "Ptr", hProcess)
    			MsgBox, % "ClasHandle(hProcess) failed " A_LastError
    return
     
    IsProcessElevated_FreeLibrary:
    	if hModule
    		DllCall("kernel32.dll\FreeLibrary", "Ptr", hModule)
    return
}
     
     
ComVar(Type=0xC) {
   	static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
   	; Create an array of 1 VARIANT.  This method allows built-in code to take
   	; care of all conversions between VARIANT and AutoHotkey internal types.
   	arr := ComObjArray(Type, 1)
   	; Lock the array and retrieve a pointer to the VARIANT.
   	if DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
   		return false
    	
   	; Store the array and an object which can be used to pass the VARIANT ByRef.
   	return { ref: ComObjParameter(0x4000|Type, arr_data), _: arr, base: base }
}
     
ComVarGet(cv, p*) {  ; Called when script accesses an unknown field.
   	if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]
   		return cv._[0]
}
     
ComVarSet(cv, v, p*) {  ; Called when script sets an unknown field.
   	if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]:=v
    	return cv._[0] := v
}
     
ComVarDel(cv) {  ; Called when the object is being freed.
   	; This must be done to allow the internal array to be freed.
   	DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}
     