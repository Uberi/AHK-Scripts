#NoEnv

FieldCount := Round((A_ScreenHeight - 40) / 30)
SavePath = %A_ScriptDir%\Reminders.txt

LastField = 0
CoordMode, Mouse
Gui, Color, Red
Gui, Font, S8 CDefault, Arial
Gui, Add, Button, x12 y10 w70 h20 gShowHide vShowHide, Hide
Loop, %FieldCount%
 Gui, Add, Edit, % "x12 y" . (((A_Index - 1) * 30) + 40) . " w250 h20 Hidden vField" . A_Index . " HwndHwndField" . A_Index
Gui, +ToolWindow -Caption +AlwaysOnTop +LastFound
WinSet, TransColor, Red
Gui, Show, x0 y0 w250 h%A_ScreenHeight%, .
SetFormat, Integer, Hex
OnMessage(0x111,"ClickedEdit")
Gosub, Load
OnExit, Save
Return

Esc::
GuiClose:
ExitApp

ShowHide:
Critical
SetFormat, Integer, D
If Not FieldsHidden
{
 HideFields()
 GuiControl,, ShowHide, Show
 FieldsHidden = 1
 ButtonHidden = 
 SetTimer, ShowButton, 100
}
Else
{
 ShowFields()
 GuiControl,, ShowHide, Hide
 FieldsHidden = 
 SetTimer, ShowButton, Off
}
Return

HideFields()
{
 global LastField
 Loop, % LastField + 2
 {
  GuiControl, Move, % "Field" . A_Index - 2, x-250
  GuiControl, Move, % "Field" . A_Index - 1, x-100
  GuiControl, Move, Field%A_Index%, x-50
  Sleep, 30
 }
}

ShowFields()
{
 global LastField
 Loop, % LastField + 2
 {
  GuiControl, Move, % "Field" . A_Index - 2, x12
  GuiControl, Move, % "Field" . A_Index - 1, x-50
  GuiControl, Move, Field%A_Index%, x-100
  Sleep, 30
 }
}

ShowButton:
Critical
SetFormat, Integer, D
MouseGetPos, Temp1
If Temp1 = 0
{
 If Not ButtonHidden
  Return
 SetTimer, ShowButton, Off
 Temp1 = -70
 Loop, 82
 {
  Temp1 ++
  GuiControl, Move, ShowHide, x%Temp1%
  Sleep, 5
 }
 ButtonHidden = 
 SetTimer, ShowButton, On
}
Else If Temp1 > 82
{
 If ButtonHidden
  Return
 Temp1 = 12
 Loop, 82
 {
  Temp1 --
  GuiControl, Move, ShowHide, x%Temp1%
  Sleep, 5
 }
 ButtonHidden = 1
}
Return

Load:
Critical
SetFormat, Integer, D
IfNotExist, %SavePath%
{
 Loop, 2
  AddNewField()
 GuiControl,, Field1, Note
 Return
}
FileRead, Temp1, %SavePath%
If Temp1 = 
{
 Loop, 2
  AddNewField()
 GuiControl,, Field1, Note
 Temp2 = 
 Return
}
Else
{
 Loop, Parse, Temp1, `n, `r
 {
  AddNewField()
  GuiControl,, Field%A_Index%, %A_LoopField%
 }
}
AddNewField()
ClearEmptyFields()
Return

Save:
Critical
SetFormat, Integer, D
Temp2 = 
Loop, %LastField%
{
 GuiControlGet, Temp1,, Field%A_Index%
 Temp2 .= Temp1 . "`n"
}
StringTrimRight, Temp2, Temp2, 1
IfExist, %SavePath%
 FileDelete, %SavePath%
FileAppend, %Temp2%, %SavePath%
ExitApp
Return

ClickedEdit(Temp1,Temp2)
{
 global
 Temp1 := (Temp1&0xFFFF0000) >> 16
 If Temp1 = 0x100
 {
  If (Temp2 = HwndField%LastField%)
   AddNewField()
 }
 Else If Temp1 = 0x200
  ClearEmptyFields()
}

AddNewField()
{
 global
 SetFormat, Integer, D
 If LastField = %FieldCount%
  Return
 LastField ++
 GuiControl, Show, Field%LastField%
}

ClearEmptyFields()
{
 global
 SetFormat, Integer, D
 If LastField = 1
  Return
 Loop, % LastField - 1
 {
  If A_Index = 1
   Continue
  GuiControlGet, Temp1,, Field%A_Index%
  If Temp1 = 
  {
   A_Index1 = %A_Index%
   Loop, % LastField - A_Index1
   {
    A_Index1 ++
    GuiControlGet, Temp1,, Field%A_Index1%
    GuiControl,, Field%A_Index1%
    GuiControl,, % "Field" . (A_Index1 - 1), %Temp1%
   }
   GuiControl, Hide, Field%LastField%
   LastField --
  }
 }
}