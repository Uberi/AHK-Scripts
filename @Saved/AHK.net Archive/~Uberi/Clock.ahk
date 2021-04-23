#NoEnv
SetBatchLines, -1

SettingsFile := A_ScriptDir . "\Settings.ini"

WinX := Round((A_ScreenWidth / 2) - 257.5)
WinY := Round((A_ScreenHeight / 2) - 257.5)

Color1 := 0xCCA9A9A9
Color2 := 0xAABBBBBB
Color3 := 0xDD000000
Color4 := 0xDD777777
Color5 := 0xDD555555
Color6 := 0xDDFFFFFF

ColorHand := 0xDD000000
ColorSecondHand := 0xDD7777FF

ParentDesktop := 0

IfExist, %SettingsFile%
{
 IniRead, WinX, %SettingsFile%, Position, WinX, %WinX%
 IniRead, WinY, %SettingsFile%, Position, WinY, %WinY%
 IniRead, ParentDesktop, %SettingsFile%, Position, ParentDesktop, %ParentDesktop%

 IniRead, Color1, %SettingsFile%, Colors, Color1, %Color1%
 IniRead, Color2, %SettingsFile%, Colors, Color2, %Color2%
 IniRead, Color3, %SettingsFile%, Colors, Color3, %Color3%
 IniRead, Color4, %SettingsFile%, Colors, Color4, %Color4%
 IniRead, Color5, %SettingsFile%, Colors, Color5, %Color5%
 IniRead, Color6, %SettingsFile%, Colors, Color6, %Color6%
 IniRead, ColorHand, %SettingsFile%, Colors, ColorHand, %ColorHand%
 IniRead, ColorSecondHand, %SettingsFile%, Colors, ColorSecondHand, %ColorSecondHand%
}

UPtr := A_PtrSize ? "UPtr" : "UInt"
hModule := DllCall("LoadLibrary","Str","gdiplus.dll")
VarSetCapacity(Temp1,16,0), NumPut(1,Temp1)
DllCall("gdiplus\GdiplusStartup",UPtr . "*",pToken,UPtr,&Temp1,UPtr,0)
OnExit, ExitSub

Gui, 1:-Caption +E0x80000 +LastFound +Owner
Gui, 1:Show, x%WinX% y%WinY% w515 h515 NoActivate, Clock
hWindow := WinExist()

hDC := DllCall("GetDC",UPtr,0)
VarSetCapacity(Temp1,40,0), NumPut(515,Temp1,4), NumPut(515,Temp1,8), NumPut(40,Temp1,0), NumPut(1,Temp1,12,"UShort"), NumPut(0,Temp1,16), NumPut(32,Temp1,14,"UShort")
hBitmap := DllCall("CreateDIBSection",UPtr,hDC,UPtr,&Temp1,"UInt",0,UPtr,0,UPtr,0,"UInt",0)
DllCall("ReleaseDC",UPtr,0,UPtr,hDC)

hDC := DllCall("CreateCompatibleDC",UPtr,0)
DllCall("gdi32\SelectObject",UPtr,hDC,UPtr,hBitmap)
DllCall("gdiplus\GdipCreateFromHDC",UPtr,hDC,UPtr . "*",pGraphics)
DllCall("gdiplus\GdipSetSmoothingMode",UPtr,pGraphics,"Int",4)

SetColor(1,Color1)
SetColor(2,Color2)
SetColor(3,Color3)
SetColor(4,Color4)
SetColor(5,Color5)
SetColor(6,Color6)
SetColor("Hand",ColorHand)
SetColor("SecondHand",ColorSecondHand)

;Menu, Tray, NoStandard
Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, Exit, ExitSub
Menu, Tray, Default, Settings
Menu, Tray, Click, 1

Gui, 2:Color, Black
Gui, 2:Font, s18 cWhite
Gui, 2:Font,, Segoe UI Light
Gui, 2:Add, Text, x2 y0 w210 h40, Settings
Gui, 2:Font, s12
Gui, 2:Add, Progress, x0 y40 w210 h1 BackgroundFFAA00, 0

SetFormat, IntegerFast, Hex

Temp1 := Color1 & 0xFFFFFF
Gui, 2:Add, Text, x10 y60 w80 h20 gSetColor, 1
Gui, 2:Add, Progress, x10 y60 w80 h20 vTempColor1 Background%Temp1%
Gui, 2:Add, Text, x100 y60 w100 h20, Color 1

Temp1 := Color2 & 0xFFFFFF
Gui, 2:Add, Text, x10 y90 w80 h20 gSetColor, 2
Gui, 2:Add, Progress, x10 y90 w80 h20 vTempColor2 Background%Temp1%
Gui, 2:Add, Text, x100 y90 w100 h20, Color 2

Temp1 := Color3 & 0xFFFFFF
Gui, 2:Add, Text, x10 y120 w80 h20 gSetColor, 3
Gui, 2:Add, Progress, x10 y120 w80 h20 vTempColor3 Background%Temp1%
Gui, 2:Add, Text, x100 y120 w100 h20, Color 3

Temp1 := Color4 & 0xFFFFFF
Gui, 2:Add, Text, x10 y150 w80 h20 gSetColor, 4
Gui, 2:Add, Progress, x10 y150 w80 h20 vTempColor4 Background%Temp1%
Gui, 2:Add, Text, x100 y150 w100 h20, Color 4

Temp1 := Color5 & 0xFFFFFF
Gui, 2:Add, Text, x10 y180 w80 h20 gSetColor, 5
Gui, 2:Add, Progress, x10 y180 w80 h20 vTempColor5 Background%Temp1%
Gui, 2:Add, Text, x100 y180 w100 h20, Color 5

Temp1 := Color6 & 0xFFFFFF
Gui, 2:Add, Text, x10 y210 w80 h20 gSetColor, 6
Gui, 2:Add, Progress, x10 y210 w80 h20 vTempColor6 Background%Temp1%
Gui, 2:Add, Text, x100 y210 w100 h20, Color 6

Temp1 := ColorHand & 0xFFFFFF
Gui, 2:Add, Text, x10 y250 w80 h20 gSetColor, Hand
Gui, 2:Add, Progress, x10 y250 w80 h20 vTempColorHand Background%Temp1%
Gui, 2:Add, Text, x100 y250 w100 h20, Hands

Temp1 := ColorSecondHand & 0xFFFFFF
Gui, 2:Add, Text, x10 y280 w80 h20 gSetColor, SecondHand
Gui, 2:Add, Progress, x10 y280 w80 h20 vTempColorSecondHand Background%Temp1%
Gui, 2:Add, Text, x100 y280 w100 h20, Second Hand

Gui, 2:Add, Checkbox, x10 y330 w200 h20 gToggleParent, Parent To Desktop
GuiControl, 2:Focus, TempColor1 ;remove focus from the control

SetFormat, IntegerFast, D

Gui, 2:+AlwaysOnTop +ToolWindow
Gui, 2:Show, w210 h365 Hide, Options

Gosub, DrawClock
SetTimer, DrawClock, 1000
OnMessage(0x201,"DragWin") ;WM_LBUTTONDOWN
OnMessage(0x204,"Settings") ;WM_RBUTTONDOWN

;parent window to the desktop if the option is set
DllCall("RegisterShellHookWindow","UInt",hWindow)
ShellHookMessage := DllCall("RegisterWindowMessage","Str","SHELLHOOK")
If ParentDesktop
 OnMessage(ShellHookMessage,"SetBottom"), SetBottom()
Return

ToggleParent:
If ParentDesktop
{
 OnMessage(ShellHookMessage,"")
 WinSet, Top,, ahk_id %hWindow%
 ParentDesktop := 0
}
Else
 OnMessage(ShellHookMessage,"SetBottom"), SetBottom(), ParentDesktop := 1
Return

SetBottom()
{
 global hWindow
 WinSet, Bottom,, ahk_id %hWindow%
}

DrawClock:
DllCall("gdiplus\GdipGraphicsClear",UPtr,pGraphics,"Int",0)

TimeDays := (A_DD / 31) * 360
TimeMonths := ((A_MM - 1) * 4.66) + (A_DD * 0.074)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen1,"Float",44,"Float",44,"Float",427,"Float",427,"Float",178,"Float",TimeDays)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen2,"Float",86,"Float",86,"Float",343,"Float",343,"Float",178 + TimeDays,"Float",360 - TimeDays)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen3,"Float",150,"Float",150,"Float",215,"Float",215,"Float",120,"Float",88)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen4,"Float",150,"Float",150,"Float",215,"Float",215,"Float",77,"Float",41)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen5,"Float",150,"Float",150,"Float",215,"Float",215,"Float",57,"Float",20)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen4,"Float",150,"Float",150,"Float",215,"Float",215,"Float",30,"Float",27)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen6,"Float",150,"Float",150,"Float",215,"Float",215,"Float",330,"Float",58)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen7,"Float",160,"Float",160,"Float",195,"Float",195,"Float",161,"Float",109)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen8,"Float",160,"Float",160,"Float",195,"Float",195,"Float",120,"Float",41)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen9,"Float",166,"Float",166,"Float",183,"Float",183,"Float",108,"Float",11)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen10,"Float",166,"Float",166,"Float",183,"Float",183,"Float",100,"Float",8)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen9,"Float",166,"Float",166,"Float",183,"Float",183,"Float",89,"Float",11)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen10,"Float",166,"Float",166,"Float",183,"Float",183,"Float",30,"Float",58)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPenOverlay,"Float",166,"Float",166,"Float",183,"Float",183,"Float",30,"Float",TimeMonths)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen11,"Float",166,"Float",166,"Float",183,"Float",183,"Float",330,"Float",29)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen3,"Float",171,"Float",171,"Float",173,"Float",173,"Float",126,"Float",82)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen5,"Float",171,"Float",171,"Float",173,"Float",173,"Float",120,"Float",6)

TimeHours := Mod((A_Hour * 30) + (A_Min // 2),360)
TimeMinutes := Mod((A_Min * 6) + (A_Sec * 0.1),360)
TimeSeconds := Mod(A_Sec * 6,360)

DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen5,"Float",180,"Float",180,"Float",155,"Float",155,"Float",270,"Float",TimeHours)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen4,"Float",180,"Float",180,"Float",155,"Float",155,"Float",TimeHours - 90,"Float",360 - TimeHours)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen4,"Float",187,"Float",187,"Float",141,"Float",141,"Float",198,"Float",TimeMinutes + 72)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen12,"Float",187,"Float",187,"Float",141,"Float",141,"Float",TimeMinutes - 90,"Float",288 - TimeMinutes)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen4,"Float",194,"Float",194,"Float",127,"Float",127,"Float",263,"Float",TimeSeconds + 7)
DllCall("gdiplus\GdipDrawArc",UPtr,pGraphics,UPtr,pPen13,"Float",194,"Float",194,"Float",127,"Float",127,"Float",TimeSeconds - 90,"Float",353 - TimeSeconds)

TimeHours += 90, TimeMinutes += 90, TimeSeconds += 90
DllCall("gdiplus\GdipDrawLine",UPtr,pGraphics,UPtr,pPenHand,"Float",257,"Float",257,"Float",257 - (108 * Cos(TimeHours * 0.017453)),"Float",257 - (108 * Sin(TimeHours * 0.017453)))
DllCall("gdiplus\GdipDrawLine",UPtr,pGraphics,UPtr,pPenHand,"Float",257,"Float",257,"Float",257 - (154 * Cos(TimeMinutes * 0.017453)),"Float",257 - (154 * Sin(TimeMinutes * 0.017453)))
DllCall("gdiplus\GdipDrawLine",UPtr,pGraphics,UPtr,pPenSecondHand,"Float",257,"Float",257,"Float",257 - (173 * Cos(TimeSeconds * 0.017453)),"Float",257 - (173 * Sin(TimeSeconds * 0.017453)))

DllCall("gdiplus\GdipFillEllipse",UPtr,pGraphics,UPtr,pBrush,"Float",251,"Float",251,"Float",12,"Float",12)

DllCall("UpdateLayeredWindow",UPtr,hWindow,"UInt",0,"UInt",0,"Int64*",0x20300000203,UPtr,hDC,"Int64*",0,"UInt",0,"UInt*",0x1FF0000,"UInt",2)
Return

Settings:
Settings()
Return

Esc::ExitApp

GuiClose:
ExitApp

SetColor:
Gui, 2:+Disabled +LastFound
WinGetPos, Temp1, Temp2
SetFormat, IntegerFast, Hex
ChosenColor := ChooseColor(Color%A_GuiControl% & 0xFFFFFF,WinExist())
If (ChosenColor != "")
{
 Temp1 := "0x" . ChosenColor, Temp1 |= (Color%A_GuiControl% & 0xFF000000)
 SetColor(A_GuiControl,Temp1)
 GuiControl, +Background%ChosenColor%, TempColor%A_GuiControl%
}
SetFormat, IntegerFast, D
Gui, 2:-Disabled
Return

Settings()
{
 Gui, 2:Show
}

SetColor(Index,ARGBColor)
{
 global
 Color%Index% := ARGBColor
 If (Index = 1)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPen1), DllCall("gdiplus\GdipDeletePen",UPtr,pPen2), DllCall("gdiplus\GdipDeletePen",UPtr,pPen3), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",87,"Int",2,UPtr . "*",pPen1), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",3,"Int",2,UPtr . "*",pPen2), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",6,"Int",2,UPtr . "*",pPen3)
 Else If (Index = 2)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPen4), DllCall("gdiplus\GdipDeletePen",UPtr,pPen7), DllCall("gdiplus\GdipDeletePen",UPtr,pPen9), DllCall("gdiplus\GdipDeletePen",UPtr,pPen11), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",6,"Int",2,UPtr . "*",pPen4), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",8,"Int",2,UPtr . "*",pPen7), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",20,"Int",2,UPtr . "*",pPen9), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",16,"Int",2,UPtr . "*",pPen11)
 Else If (Index = 3)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPen5), DllCall("gdiplus\GdipDeletePen",UPtr,pPen8), DllCall("gdiplus\GdipDeletePen",UPtr,pPen10), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",6,"Int",2,UPtr . "*",pPen5), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",8,"Int",2,UPtr . "*",pPen8), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",20,"Int",2,UPtr . "*",pPen10)
 Else If (Index = 4)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPen6), DllCall("gdiplus\GdipDeletePen",UPtr,pPen13), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",8,"Int",2,UPtr . "*",pPen6), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",6,"Int",2,UPtr . "*",pPen13)
 Else If (Index = 5)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPen12), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",6,"Int",2,UPtr . "*",pPen12)
 Else If (Index = 6)
  DllCall("gdiplus\GdipDeletePen",UPtr,pPenOverlay), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",10,"Int",2,UPtr . "*",pPenOverlay)
 Else If (Index = "Hand")
  DllCall("gdiplus\GdipDeletePen",UPtr,pPenHand), DllCall("gdiplus\GdipDeleteBrush",UPtr,pBrush), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",2,"Int",2,UPtr . "*",pPenHand), DllCall("gdiplus\GdipCreateSolidFill","Int",ARGBColor,UPtr . "*",pBrush)
 Else If (Index = "SecondHand")
  DllCall("gdiplus\GdipDeletePen",UPtr,pPenSecondHand), DllCall("gdiplus\GdipCreatePen1","Int",ARGBColor,"Float",2,"Int",2,UPtr . "*",pPenSecondHand)
}

DragWin()
{
 If (A_Gui != 1)
  Return
 Gui, 1:+LastFound
 PostMessage, 0xA1, 2
}

ChooseColor(InitialColor = 0x000000,hWindow = 0)
{
 static Dialog
 If !VarSetCapacity(Dialog)
 {
  Data := "24000000000000000000000000000000000000004700000000000000000000000000000000000000800000000080000080800000000080008000800000808000C0C0C00080808000FF00000000FF0000FFFF00000000FF00FF00FF0000FFFF00FFFFFF00C020C88008000000100000000000900090000000000043006F006C006F00720020002000200020002000200020002000200020002000200020002000200020002000000008004D00530020005300680065006C006C00200044006C00670000000B000350000000006AFF0F008C005600D002FFFF82000000000000000B00035000000000050003008C001C00D102FFFF82000000000000000B10005000000000070021006A003600C602FFFF82000000000000000B100050000000007600210013003600BE02FFFF82000000000000000B1000500000000060005B002A001B00C502FFFF8200000000000000000202500000000007005B0014000C00D602FFFF82005200470042003A0000000000000002008350000000001B005B0014000C00C202FFFF8100000000000000020083500000000031005B0014000C00C302FFFF8100000000000000020083500000000047005B0014000C00C402FFFF810000000000000000020250000000000700690014000C00D302FFFF820048004C0053003A0000000000000002008350000000001B00690014000C00BF02FFFF810000000000000002008350000000004700690014000C00C002FFFF810000000000000002008350000000003100690014000C00C102FFFF8100000000000000100000500000000005007A0087000100E603FFFF820000000000000001000350000000005F007F0028000E000100FFFF80004F004B0000000000000000000350000000002F007F002C000E000200FFFF8000430061006E00630065006C00000000000000"
  Temp1 := StrLen(Data) >> 1, VarSetCapacity(Dialog,Temp1,0)
  Loop, %Temp1%
   NumPut("0x" . SubStr(Data,(A_Index << 1) - 1,2),Dialog,A_Index - 1,"Char")
 }
 UPtr := A_PtrSize ? "UPtr" : "UInt"
 NumPut(&Dialog + 100,Dialog,8), NumPut(&Dialog + 36,Dialog,16), NumPut(hWindow,Dialog,4), NumPut(((InitialColor & 0xFF) << 16) | (InitialColor & 0xFF00) | ((InitialColor & 0xFF0000) >> 16),Dialog,12)
 If !DllCall("comdlg32\ChooseColorW",UPtr,&Dialog)
  Return
 A_FormatInteger1 := A_FormatInteger
 SetFormat, IntegerFast, Hex
 ChosenColor := NumGet(Dialog,12), ChosenColor := SubStr("00000" . SubStr(((ChosenColor & 0xFF) << 16) | (ChosenColor & 0xFF00) | ((ChosenColor & 0xFF0000) >> 16),3),-5)
 StringUpper, ChosenColor, ChosenColor
 SetFormat, IntegerFast, %A_FormatInteger1%
 Return, ChosenColor
}

ExitSub:
Gui, 1:+LastFound
WinGetPos, WinX, WinY
IniWrite, %WinX%, %SettingsFile%, Position, WinX
IniWrite, %WinY%, %SettingsFile%, Position, WinY
IniWrite, %ParentDesktop%, %SettingsFile%, Position, ParentDesktop

IniWrite, %Color1%, %SettingsFile%, Colors, Color1
IniWrite, %Color2%, %SettingsFile%, Colors, Color2
IniWrite, %Color3%, %SettingsFile%, Colors, Color3
IniWrite, %Color4%, %SettingsFile%, Colors, Color4
IniWrite, %Color5%, %SettingsFile%, Colors, Color5
IniWrite, %Color6%, %SettingsFile%, Colors, Color6
IniWrite, %ColorHand%, %SettingsFile%, Colors, ColorHand
IniWrite, %ColorSecondHand%, %SettingsFile%, Colors, ColorSecondHand

DllCall("gdiplus\GdiplusShutdown",UPtr,pToken)
DllCall("FreeLibrary",UPtr,hModule)
ExitApp