#SingleInstance force
#NoTrayIcon
#NoEnv
Loop,4
{
 RegRead, ID, HKLM,HARDWARE\DEVICEMAP\VIDEO,% "\Device\Video" A_Index-1
 StringMid, Key1, ID, 97,4
 StringMid, ID, ID, 58,38
 RegRead, ID2, HKLM,HARDWARE\DEVICEMAP\VIDEO,% "\Device\Video" A_Index
 StringMid, Key2, ID2, 97,4
 StringMid, ID2, ID2, 58,38
 If (ID=ID2)
  break
 If A_Index=4
 {
  MsgBox,16,DDT,Primary and Secondary IDs do not match.
  ExitApp
 }
}
RegReads:
Loop,2
{
 abc := A_Index=1 ? "Pri":"Sec"
 Key := A_Index=1 ? Key1:Key2
 %abc%_Mons=
 Loop, HKCC, System\CurrentControlSet\Control\VIDEO\%ID%\%Key%,2
  %abc%_Mons .= "\" A_LoopRegName "|"
 RegRead, %abc%_XRes, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , DefaultSettings.XResolution
 RegRead, %abc%_YRes, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , DefaultSettings.YResolution
 %abc%_wide := %abc%_XRes/%abc%_YRes >= 1.5 ? 1:0
 RegRead, %abc%_CQ, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , DefaultSettings.BitsPerPel
 RegRead, %abc%_RR, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , DefaultSettings.VRefresh
 RegRead, %abc%_Pos, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , Attach.RelativeX
 RegRead, %abc%_Ext, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%
 , Attach.ToDesktop
}
Loop,2
{
 abc := A_Index=1 ? "Pri":"Sec"
 xyz := A_Index=1 ? "Sec":"Pri"
 %abc%_Pri := %abc%_Pos=0 ? 1:0
 %abc%_LoR := %abc%_Pos > %xyz%_XRes ? 1:0
}
If Refresh
 return
;
;##############
;#### GUI: ####
;##############
;
Gui, Add, Radio, vPri_Dis gRadio checked Section, Primary Display
Gui, Add, Radio, vSec_Dis gRadio x+10, Secondary Display
Gui, Add, Text, x+10 vRes, %Pri_XRes% x %Pri_YRes% %A_Space%
Gui, Add, CheckBox, x+15 vWide, Widescreen
Gui, Add, Pic, x+10 w16 h16 gPic, %A_WinDir%\System32\desk.cpl
Gui, Add, GroupBox, xs w250 h60 Section, Screen Resolution
Gui, Add, Text, vLeft, Less
Gui, Add, Text, vRight, More
Gui, Add, Slider
, Buddy1Left Buddy2Right xs+33 ys+20 w180 vSlider gSlider AltSubmit Range640-1940 TickInterval100
Gui, Add, GroupBox, ys h60, Color Quality
Gui, Add, DDL, xp+10 yp+20 vCQ AltSubmit
,256 Colors (8 bit)|High Color (16 bit)|True Color (24 bit)|True Color (32 bit)|
Gui, Add, GroupBox, xp-10 ys+70, Refresh Rate
Gui, Add, DDL, xp+10 yp+20 vRR AltSubmit, 60 Hertz|75 Hertz|85 Hertz|100 Hertz|
Gui, Add, CheckBox, vPri xs ys+70, Use this device as the primary monitor.
Gui, Add, CheckBox, vExt gExt, Extend my Windows desktop onto this monitor.
Gui, Add, CheckBox, vPos, Position secondary monitor to the left of primary.
Gui, Add, Button, xs w50 gID, Identify
Gui, Add, Button, xp+231 w50 gOK, OK
Gui, Add, Button, x+10 w50 gCancel, Cancel
Gui, Add, Button, x+10 w50 gApply, Apply
GoSub, Radio
Gui, Show,,Dual Display Toggle (DDT)
return
GuiClose:
ExitApp
;
;##############
;## gLabels: ##
;##############
;
Radio:
Gui, Submit, NoHide
abc := Pri_Dis=1 ? "Pri":"Sec"
xyz := Pri_Dis=1 ? "Sec":"Pri"
GuiControl,,Res,% %abc%_XRes " x " %abc%_YRes
GuiControl,,Slider,% %abc%_XRes
GuiControl,,Wide,% %abc%_wide
GuiControl,,Pri,% %abc%_Pri
GuiControl,,Ext,% %abc%_Ext
GuiControl,% "Disable" %abc%_Pri,Ext
GuiControl,% "Disable" %abc%_Pri,Pos
CQ := CQ(%abc%_CQ)
GuiControl,Choose,CQ,%CQ%
RR := RR(%abc%_RR)
GuiControl,Choose,RR,%RR%
If (%abc%_Pri=1) OR (%abc%_Ext=0)
 GuiControl,Disable,Pri
Else GuiControl,Enable,Pri
If %abc%_Pri
 GuiControl,,Pos,% %xyz%_LoR
Else GuiControl,,Pos,% %abc%_LoR
return
Pic:
Run, control desk.cpl`,`,4
return
Slider:
GuiControlGet,Wide,,Wide
If Wide
{
 If Slider < 787
 {
  GuiControl,,Slider,720
  GuiControl,,Res,720 x 480
 }
 Else If Slider < 1003
 {
  GuiControl,,Slider,854
  GuiControl,,Res,854 x 480
 }
 Else If Slider < 1216
 {
  GuiControl,,Slider,1152
  GuiControl,,Res,1152 x 768
 }
 Else If Slider < 1280
 {
  GuiControl,,Slider,1279
  GuiControl,,Res,1280 x 720
 }
 Else If Slider < 1360
 {
  GuiControl,,Slider,1280
  GuiControl,,Res,1280 x 854
 }
 Else If Slider < 1560
 {
  GuiControl,,Slider,1440
  GuiControl,,Res,1440 x 960
 }
 Else If Slider < 1800
 {
  GuiControl,,Slider,1680
  GuiControl,,Res,1680 x 1050
 }
 Else If Slider < 1920
 {
  GuiControl,,Slider,1919
  GuiControl,,Res,1920 x 1080
 }
 Else
 {
  GuiControl,,Slider,1920
  GuiControl,,Res,1920 x 1200
 }
}
Else
{
 If Slider < 704
 {
  GuiControl,,Slider,640
  GuiControl,,Res,640 x 480
 }
 Else If Slider < 784
 {
  GuiControl,,Slider,768
  GuiControl,,Res,768 x 576
 }
 Else If Slider < 912
 {
  GuiControl,,Slider,800
  GuiControl,,Res,800 x 600
 }
 Else If Slider < 1152
 {
  GuiControl,,Slider,1024
  GuiControl,,Res,1024 x 768
 }
 Else If Slider < 1280
 {
  GuiControl,,Slider,1279
  GuiControl,,Res,1280 x 960
 }
 Else If Slider < 1340
 {
  GuiControl,,Slider,1280
  GuiControl,,Res,1280 x 1024
 }
 Else If Slider < 1500
 {
  GuiControl,,Slider,1400
  GuiControl,,Res,1400 x 1050
 }
 Else
 {
  GuiControl,,Slider,1600
  GuiControl,,Res,1600 x 1200
 }
}
return
Ext:
GuiControlGet,Ext,,Ext
GuiControl,Enable%Ext%,Pri
If Ext=0
 GuiControl,,Pri,0
return
ID:
SysGet,num,80
Loop,%num%
{
 SysGet,Mon%A_Index%,Monitor,%A_Index%
 YRes := Mon%A_Index%Bottom*.67
 SysGet,Mon%A_Index%,MonitorWorkArea,%A_Index%
 num2 := A_Index+1
 Gui, %num2%:+AlwaysOnTop -Caption +LastFound +ToolWindow
 Gui, %num2%:Font, bold cWhite s%YRes%,Arial
 Gui, %num2%:Color, EEAA99
 Gui, %num2%:Margin,0,0
 Gui, %num2%:Add,Text,,%A_Index%
 WinSet, TransColor, EEAA99
 Gui, %num2%:Show,Hide
 WinGetPos,,,Width,Height
 If Mon%A_Index%Left < 0
  XRes := Mon%A_Index%Left-(Mon%A_Index%Left/2)-(Width/2)
 Else XRes := Mon%A_Index%Left+((Mon%A_Index%Right-Mon%A_Index%Left)/2)-(Width/2)
 WinMove, %XRes%,(Mon%A_Index%Bottom/2)-(Height/2)
}
Loop,%num%
 Gui,% A_Index+1 ":Show",NA
Sleep,3000
Loop,%num%
 Gui,% A_Index+1 ":Destroy"
return
Apply:
Refresh=1
OK:
Gui, Submit
GuiControlGet,Res,,Res
Loop, Parse, Res, %A_Space%
{
 If A_Index=1
  XRes := A_LoopField
 Else If A_Index=3
  YRes := A_LoopField
}
xyz := Pri_Dis=1 ? "Sec":"Pri"
If Pri
{
 Pos2 := Pos=1 ? (4294967296-%xyz%_XRes):XRes
 Pos=0
}
Else
{
 Pos := Pos=1 ? (4294967296-XRes):%xyz%_XRes
 Pos2=0
}
CQ := CQ(CQ)
RR := RR(RR)
Key := Pri_Dis=1 ? Key1:Key2
Mons := Pri_Dis=1 ? Pri_Mons:Sec_Mons
Loop, Parse, Mons, |
{
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , Attach.RelativeX, %Pos%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , Attach.RelativeY, 0
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , Attach.ToDesktop, %Ext%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , DefaultSettings.BitsPerPel, %CQ%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , DefaultSettings.VRefresh, %RR%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , DefaultSettings.XResolution, %XRes%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , DefaultSettings.YResolution, %YRes%
}
Key := Pri_Dis=1 ? Key2:Key1
Mons := Pri_Dis=1 ? Sec_Mons:Pri_Mons
Loop, Parse, Mons, |
{
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , Attach.RelativeX, %Pos2%
 RegWrite, REG_DWORD, HKCC
 , System\CurrentControlSet\Control\VIDEO\%ID%\%Key%%A_LoopField%
 , Attach.RelativeY, 0
}
DllCall("ChangeDisplaySettings","UInt",0,"UInt",0)
If Refresh
{
 GoSub, RegReads
 GoSub, Radio
 Refresh=0
 Gui, Show
 return
}
Cancel:
ExitApp
;
;##############
;# Functions: #
;##############
;
CQ(CQ)
{
 If CQ < 5
  CQ *= 8
 Else CQ /= 8
 return, CQ
}
RR(RR)
{
 If RR < 5
 {
  RR := Round(RR*13+50,-1)
  If (RR > 60) AND (RR < 100)
   RR-=5
 }
 Else RR := Round((RR-50)/13)
 return, RR
}