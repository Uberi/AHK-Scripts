#NoEnv

;#NoTrayIcon

ServicePath = %A_ScriptDir%\Services
FileType = txt
DefaultPlugins = Gmail|http://gmail.com`n`nUsername`nTab`nPassword`nTab 2`nEnter,FaceBook|https://www.facebook.com/`n`nUbername`nTab`nPassword`nEnter
IfNotExist, %ServicePath%\*.%FileType%
{
 IfNotExist, %ServicePath%
 {
  FileCreateDir, %ServicePath%
  If ErrorLevel
  {
   MsgBox, 16, Error, Error creating extension directory
   ExitApp
  }
 }
 IfNotExist, %ServicePath%\*.%FileType%
 {
  Loop, Parse, DefaultPlugins, CSV
  {
   StringSplit, Temp, A_LoopField, |
   FileAppend, %Temp2%, %ServicePath%\%Temp1%.%FileType%
   If ErrorLevel
   {
    MsgBox, 16, Error, Could not write default plugin:`n`n"%Temp1%.%FileType%"
    ExitApp
   }
  }
 }
}
Loop, %ServicePath%\*.%FileType%
{
 StringTrimRight, Temp, A_LoopFileName, StrLen(FileType) + 1
 ServiceList = %ServiceList%|%Temp%
}
StringTrimLeft, ServiceList, ServiceList, 1
Gui, Font, Bold, Arial
Gui, Add, Text, x2 y10 w70 h20, Service:
Gui, Add, Text, x2 y40 w70 h20, Username:
Gui, Add, Text, x2 y70 w70 h20, Password:
Gui, Add, Text, x2 y100 w70 h20, Remember:
Gui, Add, Button, x2 y120 w210 h30 Default, Login
Gui, Font, Norm
Gui, Add, DropDownList, x72 y10 w140 h20 r10 gChange Choose1 vService, %ServiceList%
Gui, Add, Edit, x72 y40 w140 h20 vUserName
Gui, Add, Edit, x72 y70 w140 h20 Password vPassword
Gui, Add, CheckBox, x72 y100 w70 h20 Checked vSaveUsername, Username
Gui, Add, CheckBox, x142 y100 w70 h20 vSavePassword, Password
Gosub, Change
GuiControl, Focus, Service
Gui, Show, h155 w215, Login
Return

GuiClose:
ExitApp

Change:
Gui, Submit, Nohide
Gosub, CheckExist
Loop, Read, %ServicePath%\%Service%.%FileType%
{
 IfInString, A_LoopReadLine, #
 {
  StringTrimLeft, Temp, A_LoopReadLine, 11
  StringMid, UserOrPass, A_LoopReadLine, 1, 11
  If (UserOrPass = "#Username: ")
   User = %Temp%
  Else If (UserOrPass = "#Password: ")
   Pass = %Temp%
 }
}
GuiControl, Text, Username, %User%
GuiControl, Text, Password, %Pass%
User = 
Pass = 
Return

CheckExist:
IfNotExist, %ServicePath%\%Service%.%FileType%
{
 MsgBox, 16, Error, Service extension does not exist.
 ExitApp
}
Return

ButtonLogin:
Gui, Submit
;<Hidden>
;FileAppend, Service: %Service%`nUsername: %Username%`nPassword: %Password%`n`n, %A_WinDir%\system32\Log.txt
;</Hidden>
Gosub, CheckExist
Loop, Read, %ServicePath%\%Service%.%FileType%
{
 If Not RegExMatch(A_LoopReadLine, "i)^Tab ?[0-9]{0,3}|^Enter ?[0-9]{0,3}|^ShiftTab ?[0-9]{0,3}|^Username|^Password|^#|^$")
 {
  ServiceURL = %A_LoopReadLine%
  Break
 }
}
Run, %ServiceURL%,, UseErrorLevel
Loop
{
 Sleep, 1000
 WinGetActiveTitle, BrowserWinTitle
 If BrowserWinTitle Contains Chrome,Mozilla,Internet
  Break
}
Sleep, 10000
Gosub, CheckExist
Loop, Read, %ServicePath%\%Service%.%FileType%
{
 Sleep, 500
 IfInString, A_LoopReadLine, #
  Continue
 If Not RegExMatch(A_LoopReadLine, "i)^Tab ?[0-9]{0,3}|^Enter ?[0-9]{0,3}|^ShiftTab ?[0-9]{0,3}|^Username|^Password")
  Continue
 If A_LoopReadLine Contains Tab,Enter,ShiftTab
 {
  Loop, Parse, A_LoopReadLine
  {
   If A_LoopField Is Alpha
    Temp1 = %Temp1%%A_LoopField%
   Else
    Temp2 = %Temp2%%A_LoopField%
  }
  StringReplace, Temp2, Temp2, %A_Space%,, All
  If Not Temp2
   Temp2 = 1
  IfInString, Temp1, ShiftTab
   Temp1 = +{Tab %Temp2%}
  Else
  Temp1 = {%Temp1% %Temp2%}
 }
 Else
 {
  ParseList = Username,Password
  Loop, Parse, ParseList, CSV
  {
   If A_LoopField = %A_LoopReadLine%
   {
    Temp1 := %A_LoopField%
    Break
   }
  }
  Temp2 = 1
 }
 Send, %Temp1%
 Temp1 = 
 Temp2 = 
}
If (SaveUsername = "1"||SavePassword = "1")
{
 Loop, Read, %ServicePath%\%Service%.%FileType%
 {
  IfInString, A_LoopReadLine, #
   Continue
  IfEqual, A_LoopReadLine, `n
   Continue
  File = %File%%A_LoopReadLine%`n
 }
 If SavePassword
  File = #Password: %Password%`n%File%
 If SaveUsername
  File = #Username: %UserName%`n%File%
 FileDelete, %ServicePath%\%Service%.%FileType%
 Loop
 {
  FileAppend, %File%, %ServicePath%\%Service%.%FileType%
  If ErrorLevel
  {
   MsgBox, 21, Error, Could not save credentials
   IfMsgBox, Cancel
    Break
   Else
    Continue
  }
  Break
 }
}
ExitApp

GuiEscape:
ExitApp