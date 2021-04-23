#NoEnv

#Include %A_ScriptDir%\..\..\Resources\SupportLib.ahk

VarList = PageName
GetVars(VarList)
FileRead, Temp1, %PageName%
WebPage = <p>The following page was requested: %PageName%<br><br>File Contents:<blockquote>%Temp1%</blockquote></p>
Return