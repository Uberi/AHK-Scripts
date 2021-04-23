#NoEnv

If Not A_IsAdmin
{
 MsgBox, 36, Detection, This program detects more processes when running with elevated privileges.`n`nWould you like to elevate the program now?
 IfMsgBox, Yes
 {
  DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
  ExitApp
 }
}
Gui, Add, Text, x2 y0 w120 h30 +Center, Regex Process Termination
Gui, Add, Text, x2 y40 w120 h20 +Center, PCRE:
Gui, Add, Edit, x2 y60 w120 h20 vRegex, *
Gui, Add, Button, x2 y90 w120 h20 +Default gTerminate, Terminate All Matches
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w125 h115, Regex Process Termination
Return

GuiEscape:
GuiClose:
ExitApp

Terminate:
Gui, Submit
ProcessList := GetProcessList()
ProcessCount = 0
Failed = 0
MsgBox % ProcessList
Loop, Parse, ProcessList, `n
{
 If RegExMatch(A_LoopField,"iS)" . Regex)
 {
  MsgBox % A_LoopField
  ProcessCount ++
  ;Process, Close, %A_LoopField%
  ;If Not ErrorLevel
  ; Failed ++
 }
}
Temp1 := ProcessCount - Failed
MsgBox, 64, Info, Statistics:`n`nTotal Matching: %ProcessCount%`nTotal Terminated: %Temp1%`nTotal Failed: %Failed%
ExitApp

GetProcessList()
{
 s := 4096
 Process, Exist
 h := DllCall("OpenProcess", "UInt", 0x0400, "Int", False, "UInt", ErrorLevel)
 DllCall("Advapi32.dll\OpenProcessToken", "UInt", h, "UInt", 32, "UIntP", t)
 VarSetCapacity(ti, 16, 0)
 NumPut(1, ti, 0)
 DllCall("Advapi32.dll\LookupPrivilegeValueA", "UInt", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
 NumPut(luid, ti, 4, "int64")
 NumPut(2, ti, 12)
 DllCall("Advapi32.dll\AdjustTokenPrivileges", "UInt", t, "Int", False, "UInt", &ti, "UInt", 0, "UInt", 0, "UInt", 0)
 DllCall("CloseHandle", "UInt", h)
 hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")
 s := VarSetCapacity(a, s)
 c := 0
 DllCall("Psapi.dll\EnumProcesses", "UInt", &a, "UInt", s, "UIntP", r)
 Loop, % r // 4
 {
  id := NumGet(a, A_Index * 4)
  h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id)
  VarSetCapacity(n, s, 0)
  e := DllCall("Psapi.dll\GetModuleBaseNameA", "UInt", h, "UInt", 0, "Str", n, "UInt", s)
  DllCall("CloseHandle", "UInt", h)
  If (n && e)
   l .= n . "`n", c ++
 }
 DllCall("FreeLibrary", "UInt", hModule)
 StringTrimRight, l, l, 1
 Return, l
}