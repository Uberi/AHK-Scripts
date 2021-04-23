#NoEnv

ProgramExt = ahk

SplitPath, A_MyDocuments,, StartFolder
Gui, Font, S8 CDefault bold, Verdana
Gui, Add, Text, x2 y0 w230 h40 +Center, This program shows the total amount of programs you have written and their total sizes
Gui, Font, S8 CDefault norm, Verdana
Gui, Add, Text, x2 y50 w160 h20, Search for source code in:
Gui, Add, Radio, x2 y70 w100 h20 gShowInfo vShowInfo Checked, All Drives
Gui, Add, Radio, x2 y90 w100 h20 gShowInfo, Primary Drive
Gui, Add, Radio, x2 y110 w100 h20 gShowInfo, Custom Folder
Gui, Add, Text, x112 y80 w120 h40 vInfo
Gui, Add, Edit, x2 y130 w200 h20 vFolder +Disabled +ReadOnly, %StartFolder%
Gui, Add, Button, x202 y130 w30 h20 gSelectFile vSelectFile +Disabled, ...
Gui, Add, Button, x2 y160 w230 h20 +Default, Search
Gosub, ShowInfo
Gui, Show, w235 h185, Catalog Programs
Return

GuiEscape:
GuiClose:
ExitApp

ShowInfo:
Gui, Submit, NoHide
GuiControl,, Info, % ((ShowInfo = 1) ? "Search in all hard drives detected on this computer" : ((ShowInfo = 2) ? "Search only in the drive Windows is installed on" : "Manually select a folder to search"))
ShowInfo := (ShowInfo = 3)
GuiControl, Enable%ShowInfo%, Folder
GuiControl, Enable%ShowInfo%, SelectFile
Return

SelectFile:
FileSelectFolder, Folder, *%StartFolder%,, Please select a folder to search.
If ErrorLevel
 Return
GuiControl,, Folder, %Folder%
Return

ButtonSearch:
Gui, Submit
Folder := ((ShowInfo = 2) ? SubStr(A_WinDir,1,3) : ((ShowInfo = 3) ? Folder : ""))
If ShowInfo = 1
{
 DriveGet, Temp1, List, FIXED
 Loop, Parse, Temp1
  Folder .= A_LoopField . ":|"
 StringTrimRight, Folder, Folder, 1
}
Else If ShowInfo = 2
 SplitPath, A_WinDir,,,,, Folder
Else
{
 IfNotExist, %Folder%
 {
  MsgBox, 16, Error, Folder does not exist.
  ExitApp
 }
}
Progress, P999 R0-1000, Searching..., Searching for programs..., Search
TotalSize = 0
ProgramCount = 0
SetBatchLines, -1
Loop, Parse, Folder, |
{
 Loop, %A_LoopField%\*.%ProgramExt%,, 1
 {
  AverageList .= A_LoopFileSize . "`n"
  ProgramCount ++
  TotalSize += A_LoopFileSize
 }
}
Progress, Off
StringReplace, AverageList, AverageList, `n, `n, UseErrorLevel
Temp1 = %ErrorLevel%
StringTrimRight, AverageList, AverageList, 1
Loop, Parse, AverageList, `n
 Average += A_LoopField
Average /= Temp1 * 1024
TotalSize /= 1024

MsgBox, 64, Statistics, Average size of source code:%A_Tab%%Average% KB`nTotal size of all source code:%A_Tab%%TotalSize% KB`nTotal number of programs:%A_Tab%%ProgramCount%
ExitApp