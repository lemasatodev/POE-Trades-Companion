
Get_ResourceSize(resourceName) {
    if !hRes := DllCall("FindResource", Ptr, 0, Str, resourceName, Str, RT_RCDATA := "#10", Ptr)  {
      MsgBox, FindResource is failed, error: %A_LastError%
      ExitApp
   }

   szData := DllCall("SizeofResource", Ptr, 0, Ptr, hRes)
   Return szData
}
