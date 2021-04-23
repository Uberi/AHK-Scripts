#NoEnv

#Include %A_ScriptDir%\..\..\Resources\SupportLib.ahk

Path = 
VarList = Path
GetVars(VarList)
Path := URLDecode(Path)
Loop, %WebRoot%\%Path%, 1
{
 TempPath = %A_LoopFileLongPath%
 Break
}
WebPage = <p>Currently Viewing: %TempPath%</p><p>
EnvGet, WebRoot, ENV_WebRoot
If (SubStr(Path,0,1) <> "\" && Path <> "")
 Path .= "\"
Path .= "*"
Temp1 := StrLen(WebRoot) + 2
Loop, %WebRoot%\%Path%, 2
 WebPage .= "<a href=/Scripts/FileBrowser.ahk?path=" . SubStr(A_LoopFileLongPath,Temp1) . ">" . A_LoopFileName . "</a><br>"
Loop, %WebRoot%\%Path%
 WebPage .= "<a href=..\" . SubStr(A_LoopFileLongPath,Temp1) . ">" . A_LoopFileName . "</a><br>"
WebPage .= "</p><p><a href=/Scripts/FileBrowser.ahk?path=" . SubStr(Path,1,-1) . "..\>Parent Directory</a></p>"
Return

Esc::ExitApp