#NoEnv

/*
RegistryPath := "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"

If !A_IsAdmin
{
 DllCall("shell32\ShellExecute" . (A_IsUnicode ? "W" : "A"),"UInt",0,"Str","RunAs","Str",A_AhkPath,"Str","""" . A_ScriptFullPath . """","Str",A_WorkingDir,"Int",1)
 ExitApp
}

InputBox, RegistryPath, Go To Regedit Path, Enter the path to navigate to:,, W, H, X, Y,,, %RegistryPath%
If !ErrorLevel
 GoToRegeditPath(RegistryPath)
*/

GoToRegeditPath(RegistryPath)
{
 KeyDelay1 := A_KeyDelay
 SetKeyDelay, 30
 If (WindowID := WinExist("ahk_class RegEdit_RegEdit"))
  WinActivate, ahk_id %WindowID%
 Else
 {
  Run, Regedit,, UseErrorLevel
  If ErrorLevel
   Return, 1
  WinWait, ahk_class RegEdit_RegEdit
  WindowID := WinExist()
 }
 Sleep, 100
 StatusBarGetText, Temp1,, ahk_class RegEdit_RegEdit
 StringReplace, Temp1, Temp1, \, \, UseErrorLevel
 ControlSend, SysTreeView321, {Left %ErrorLevel%}, ahk_class RegEdit_RegEdit
 StringReplace, RegistryPath, RegistryPath, \, {Right}, All
 ControlSend, SysTreeView321, %RegistryPath%, ahk_class RegEdit_RegEdit
 SetKeyDelay, %KeyDelay1%
}