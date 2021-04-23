; Control Spy - Written by A.N.Suresh Kumar AKA Goyyah / 25-Aug-2006 / Version ??????
AutoTrim, OFF
^#!F12::
FileDelete, %A_Temp%\ControlList.txt
IfWinExist,Control.Spy.Report,WinActivate,Control.Spy.Report
IfWinExist,Control.Spy.Report,Exit
Clis=
ID:=WinExist("A")
WinGet, Clist, ControlList, ahk_id %ID%
WinGetTitle, Title, ahk_id %ID%
WinGetClass, Class, ahk_id %ID%
FileAppend, %Title% [Class:%Class%]`n, %A_Temp%\ControlList.txt
FileAppend,---------------------------------------------------------------------------------------------------`n, %A_Temp%\ControlList.txt
FileAppend,Sl   c_Hwnd       ClassNN                                  Control Text (40 Characters only)       `n, %A_Temp%\ControlList.txt
FileAppend,---------------------------------------------------------------------------------------------------`n, %A_Temp%\ControlList.txt

Loop, Parse, CList, `n
{
ControlGet,cHwnd, Hwnd,, %A_LoopField%, ahk_id %ID%
ControlGetText,cText,, ahk_id %cHwnd%
StringReplace,cText,cText, `n, % Chr(32), All
StringReplace,cText,cText, `r, % Chr(32), All
StringLeft,cText,cText,40
Clis = % Clis "`n"  SetWidth(A_Index,3) ". " SetWidth(cHwnd,12) " " SetWidth(A_LoopField,40) " " Ctext
}

FileAppend, %Clis%`n, %A_Temp%\ControlList.txt
FileAppend,---------------------------------------------------------------------------------------------------`n, %A_Temp%\ControlList.txt
FileAppend,* Control Spy * By Goyyah, %A_Temp%\ControlList.txt
FileRead, Report, %A_Temp%\ControlList.txt
Gui,Font, s9, Courier New
Gui,Add,Edit, w740 h540 , % Report
Gui,Add,Button, x600 gGuiClose w140 , &Copy to Clipboard
Gui,Show,,Control.Spy.Report
Send, {Home}
Return

GuiEscape:
GuiClose:
Clipboard= % "[code]`n" Report "`n[/code]"
 ReLoad
Return

SetWidth(Str,Width) {
Loop {
If (StrLen(Str)>=Width)
   Break
Else
   Str= % Str Chr(32)
}  Return Str
}