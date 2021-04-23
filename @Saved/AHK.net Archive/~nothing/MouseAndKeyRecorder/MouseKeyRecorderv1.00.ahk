
;~ Setting
Title=Mouse And Key Recorder 1.00 created by ___x@___
kenter:=chr(10)
SetTimer,Control_tip,100
CoordMode,Mouse,Screen
SetBatchLines,-1
#NoEnv
#SingleInstance,off
;~ Tray Menu
Menu,tray,NoStandard
Menu,tray,add,Record/Pause,Rec
Menu,tray,add,Play,Play
Menu,tray,add
menu,tray,add,Show
menu,tray,add,Hide
Menu,tray,disable,show
menu,tray,add,Exit,guiclose
Menu,tray,default,Show

;~ Menu,File,add,Open...,ope
;~ Menu,File,add,Save as...,sav
;~ Menu,File,add,Exit,Guiclose

;~ Menu,Help,Add,Help
;~ Menu,Gui,add,File,:File
;~ Menu,Gui,add,Help,:Help
;~ Gui,menu,Gui

;~ Gui
Gui +lastfound
ID:=WinExist()
Gui,Font,s14 ,Webdings
;~ Button : Record,Play,Pause,Mode,Add,Change,Clear All
Gui, Add, Button, x6 y10 w40 h30 vrec gRec, =
Gui, Add, Button, x46 y10 w40 h30 gPlay, 4
Gui, Add, Button, x86 y10 w40 h30 gPause_loop, `;
Gui, Add, button, x126 y10 w40 h30 gMin vMin, 7
Gui, Add, Button, x6 y270 w40 h30 gAdd, 5
Gui, Add, Button, x46 y270 w40 h30 gChange, q
Gui, Add, Button, x86 y270 w40 h30 gRemove, r
Gui, Add, button, x126 y270 w40 h30 gClearAll, x
Gui, Add, Button, x176 y10 w40 h30 gsav, Í
Gui, Add, Button, x216 y10 w40 h30 gope, ¤
Gui, Add, Button, x176 y270 w40 h30 goptimize, ~
Gui, Add, Button, x216 y270 w40 h30 gAbout, i


Gui,Font
Gui, Font, CC0C0C0 ,
Gui,color,5D69BA,FFFFFF
Gui, Add, ListView, x6 y50 w250 h210 +NoSortHdr -LV0x10 vListview, No|Type|Info

;~ Hotkey
Gui, Add, groupbox, x266 y170 w180 h130 , Hotkey
Gui, Add, Hotkey, x346 y190 w55 h20 vhrec, F1
Gui, Add, Hotkey, x346 y210 w55 h20 vhplay, F2
Gui, Add, Hotkey, x346 y230 w55 h20 vhbreak, F3
Gui, Add, Hotkey, x346 y250 w55 h20 vhpause, F4
Gui, Add, Hotkey, x346 y270 w55 h20 vhclear, F5
Gui, Add, Text, x276 y190 w70 h20 , Record
Gui, Add, Text, x276 y210 w70 h20 , Play/Resume
Gui, Add, Text, x276 y230 w70 h20 , Stop
Gui, Add, Text, x276 y250 w70 h20 , Pause
Gui, Add, Text, x276 y270 w70 h20 , Clear
Gui, Add, Button, x401 y190 w30 h100 , Set


Gui, Add, groupbox, x266 y20 w180 h150 , Setting
Gui, Add, checkbox, x276 y40 w160 h20 vAuto_hide gAuto_hide , Auto hide
Gui, Add, Checkbox, x276 y60 w160 h20 vclear gclear, Clear data before recording
Gui, Add, CheckBox, x276 y80 w160 h20 gAuto_optimize vAuto_optimize, Auto optimize
Gui, Add, CheckBox, x276 y100 w70 h20 gRepeat vRepeat, Repeat
Gui, Add, Edit, x346 y100 w46 h20 +Number vrepn +Disabled c5D69BA,
Gui, Add, UpDown, x370 y100 w18 h20 Range1-999999,
Gui, Add, CheckBox, x276 y120 w150 h20 vMid_button gMid_button, Mid Button replace by text
Gui, Add, Edit, x276 y140 w120 h20 +Disabled vmmt c5D69BA vMid1,
Gui, Add, Button, x386 y140 w30 h20 +Disabled vMid3, ...

Gui, Add, StatusBar, x346 y330 w30 h20 , Current line :0
Gui, Show, h335 w455, %Title%

;~ Gui2: Add/Change keys or mouse moves
Gui, 2:+owner1
Gui,2: Font, CC0C0C0 ,
Gui,2: color,5D69BA,FFFFFF

Gui,2: Add, Radio, x6 y10 w180 h20 vR_Key gchange2, Add Keys
Gui,2: Add, Radio, x6 y70 w180 h20 vR_Mouse gchange2 +Checked, Add Mouse Move

Gui,2: Add, GroupBox, x6 y30 w180 h40 +Disabled,
Gui,2: Add, Text, x16 y40 w30 h20 , Keys:
Gui,2: Add, Edit, x46 y40 w90 h20 vK1 +Disabled,
;~ Gui,2: Add, Button, x146 y40 w30 h20 +Disabled vGet_key2, <<

Gui,2: Add, GroupBox, x6 y90 w180 h90 ,
Gui,2: Add, Text, x16 y100 w70 h20 , Coord Mouse:
Gui,2: Add, Text, x16 y120 w10 h20 , X:
Gui,2: Add, Edit, x26 y120 w50 h20 vM2 +Number, 0
Gui,2: Add, Text, x76 y120 w10 h20 , Y:
Gui,2: Add, Edit, x86 y120 w50 h20 vM3 +Number, 0
Gui,2: Add, Text, x146 y120 w30 h20 vGet_mouse2 gGet_mouse cRed, <<
Gui,2: Add, Text, x16 y150 w80 h20 , Mouse Button:
Gui,2: Add, DropDownList, x96 y150 w70 h20 +R4 vM1, <None>||Left|Right|Mid
Gui,2: Add, Button, x26 y190 w50 h30 , OK
Gui,2: Add, Button, x96 y190 w50 h30 , Cancel

Gui,2: +lastfound
ID2:=WinExist()
gosub,ButtonSet
Return
Rec:
if Recording   ;Stop recording
   goto,Stop_record
if Playing   ;Ignore if Playing
   Return
Gosub,hide
if clear   ;Clear data before recording
   LV_Delete()
TrayTip,%Title%,Recording...,,1
SetTimer,tip,300
SetTimer,Get_mouse_pos,1     ;Record Mouse
SetTimer,Get_key,1         ;Record Key
GuiControl,,rec,g      ;Change Record Button
Recording=1
Return
Stop_record:
   Recording=0
   SetTimer,Get_mouse_pos,off
   SetTimer,Get_key,Off
    Remove_mouse_moves()   ;optimize data
   if Auto_optimize
      Gosub optimize
   GuiControl,,rec,=
   guicontrolget,Auto_hide,,Auto_hide
   if not Auto_hide
      Gosub,show
   TrayTip,%Title%,Stopping Recording...,,1
   SetTimer,tip,500
   
Return
Pause_loop:
If Playing
{
lpause=1
Return
}
Return
Play:
If  Playing   || Recording   ;Ignore if Recording
   Return
Gosub,hide
Playing=1
lstop=0         ;Loop_stop=off
lpause=0       ;Loop_pause=off
If Mid_button   ;Replace Mid Button by text
GuiControlGet,Sfile,,Mid1
TrayTip,%Title%,Playing...,,1
SetTimer,tip,500
BlockInput,MouseMove
If Pausing
{
   Pausing=0
   Goto,resume
}
Count_repeat=1
loop:
Start_line=1      ;For Mid Button Replace by text
Count=0
resume:
loop,% LV_GetCount()
   {
      if lstop
         Break
      If lpause
       {
         Pausing=1
         Break
      }
      Count++
      LV_GetText(Temp,Count,2)
      LV_GetText(Temp2,Count,3)
      If !Temp
      Break
      if Temp=Key            ;Key
      {
         Send %Temp2%
         Continue
      }
      StringSplit,pos,Temp2 ,%A_Space%      ;Mouse click down
      Mousemove,pos1,pos2,0
       if pos3         ;Left Mouse Button
        if not waitup3
        {
         MouseClick,Left,pos1,pos2,,0,D
         waitup3=1
         SetTimer,Left,1
      }
       if pos4      ;Right Mouse Button
        if not waitup4
        {
         MouseClick,right,pos1,pos2,,0,D
         waitup4=1
         SetTimer,Right,1
      }
        if pos5         ;Mid Mouse Button
        if not waitup5
        {
         if Mid_button
         Gosub Mid_text
         Else
         MouseClick,Middle,pos1,pos2,,0,D
         waitup5=1
         SetTimer,Mid,1
      }
   SB_SetText("Current line :" Count)
   }
If !Pausing && !lstop
if Repeat
{
   GuiControlGet,repn,,repn
   if Count_repeat>=%repn%
   Goto,out
   Count_repeat++
   Goto,loop
}
out:
BlockInput,MouseMoveOff
Playing=0
lstop=0
lpause=0
TrayTip,%Title%,Stopping Playing...,,1
SetTimer,tip,700
if not Auto_hide
   Gosub,show
Return
;~ MouseClick up:
Left:
if pos3
   Return
waitup3:=0
MouseClick,Left,pos1,pos2,,0,U
SetTimer,Left,Off
Return
Right:
if pos4
   Return
waitup4:=0
MouseClick,right,pos1,pos2,,0,U
SetTimer,Right,Off
Return
Mid:
if pos5
   Return
waitup5:=0
MouseClick,m,pos1,pos2,,0,U
SetTimer,Mid,Off
Return

;--------------------

Get_mouse_pos:
LButton:=GetKeyState("LButton","P")
RButton:=GetKeyState("RButton","P")
MButton:=GetKeyState("MButton","P")
MouseGetPos,x1,y1,win,con,1
if win=%ID%
{
   LButton=0
   MButton=0
   RButton=0
   }
LV_Add("","","Mouse",x1 A_space y1 A_space LButton A_space RButton A_space MButton A_space WheelUp A_space WheelDown)
Return

;-----------------------

Get_key:
Input,C_Key,I V L1 M,{BS}{%hrec%}{%hplay%}{%hpause%}{%hbreak%}
If ErrorLevel Contains EndKey
If ErrorLevel=EndKey:Backspace
C_Key={BS}
Else Return
if C_Key=%kenter%
C_Key={Enter}
if C_Key=%A_space%
C_Key={Space}
LV_Add("","","Key",C_Key)
Return

;it will remove all the same mouse moves between 2 keys that make the sript slow down
Remove_mouse_moves()
{
Check=0
ok=0
Count=0
Loop,% LV_GetCount()
{
   Count++
   LV_GetText(Type,Count,2)
   If Type=Key
   {
      If Check=1
         If !ok
         {
            Loop % Last-First+1
               LV_Delete(First)
            Count:=First
         }
      First:=Count+1
      LV_GetText(Line1,First,3)
      Last=
      Check=1
      ok=0
      Continue
   }
   If Check=1
   {
      LV_GetText(Line2,Count,3)
      If Line2=
      Break
      If Line1=%Line2%
         Last:=Count
      Else ok=1
   }
}
Sort_list()
}
Return
Sort_list()
{
Loop,% LV_GetCount()
   LV_Modify(A_Index,"",A_Index)
}
Return
Add:
Status=Add
Gui,1: +Disabled
Gui,2: Show,h233 w193,Add
If !LV_GetNext()
Row:=LV_GetCount()+1
Else
Row:=LV_GetNext()+1
Return
Change:
Status=Change
Row:=LV_GetNext()
If !Row
   Return
LV_GetText(Temp2,Row,2)
LV_GetText(Temp3,Row,3)
If Temp2=Key
{
   GuiControl,2:,R_Key,1
   GuiControl,2:,K1,%Temp3%
}
Else
{
   GuiControl,2:,R_Mouse,1
   StringSplit,Temp,Temp3,%A_space%
   GuiControl,2:,M2,%Temp1%
   GuiControl,2:,M3,%Temp2%
   If !Temp3
   GuiControl,2: Choose,M1,1
   Else
   GuiControl,2: Choose,M1,2
   If Temp4
   GuiControl,2: Choose,M1,3
   If Temp5
   GuiControl,2: Choose,M1,4
}
Gosub,change2
Gui,2: Show,h233 w193, Change
Gui,+disabled
Return
Remove:
If !LV_GetNext()
Return
TrayTip,%Title%,Removed!,,1
SetTimer,Tip,500
LV_Delete(LV_GetNext())
Sort_list()
Return
change2:   ;Change some controls state
GuiControlGet,Temp,2:,R_Key
GuiControl,2: Enable%Temp%,K1
;~ GuiControl,2: Enable%Temp%,Get_key2
GuiControl,2: Disable%Temp%,M1
GuiControl,2: Disable%Temp%,M2
GuiControl,2: Disable%Temp%,M3
GuiControl,2: Disable%Temp%,Get_mouse2
Return
Min:
If !Min_mode
{
GuiControl,,Min,8
Min_mode:=!Min_mode
Gui,Show,h70 w260
Return
}
GuiControl,,Min,7
Min_mode:=!Min_mode
Gui,Show, h335 w455
Return
2ButtonOK:
Gui,2: submit,NoHide
If R_Key
{
If K1=
{
   MsgBox,48,Error!,Empty keys!
   Return
}
}
Else If M2="" || M3=""
{
   MsgBox,48,Error!,Empty Field(s)!
   Return
   }
If M1=<None>
M1=0 0 0
Else If M1=Left
M1=1 0 0
Else If M1=Right
M1=0 1 0
Else If M1=Mid
M1=0 0 1
Gui,1: Default
If Status=Change
If R_Key
LV_Modify(Row,"","","Key",K1)
Else
LV_Modify(Row,"","","Mouse",M2 A_Space M3 A_Space M1)

If Status=Add
If R_Key
LV_Insert(Row,"","","Key",K1)
Else
LV_Insert(Row,"","","Mouse",M2 A_Space M3 A_Space M1)
Sort_list()
2GuiClose:
2ButtonCancel:
Gui, 1:-Disabled
Gui,2: Hide
Return
Help:
MsgBox This is just a demo version!`n You can only record mouse and single keys.
Return
;~ Created by ___x@___
Control_tip:
MouseGetPos,,,Win,Control,1
;~ TrayTip,,% Win " " ID " " ID2 " " Control
If  Win=%ID%
{
If Control=%Control_old%
   Return
Else If Control=Button1
   ToolTip,Start/Stop Recording
Else If Control=Button2
   ToolTip,Play/Resume
Else If Control=Button3
   ToolTip,Pause
Else If Control=Button4
   ToolTip,Min/Nomal Mode
Else If Control=Button5
   ToolTip,Add a mouse move or keys
Else If Control=Button6
   ToolTip,Change
Else If Control=Button7
   ToolTip,Remove
Else If Control=Button8
   ToolTip,Remove all
Else If Control=Button9
   ToolTip,Save as
Else If Control=Button10
   ToolTip,Load
Else If Control=Button11
   ToolTip,Optimize
Else If Control=Button12
   ToolTip,Info
Else ToolTip
}
Else If Win=%ID2%
{
If Control=%Control_old%
   Return
;~ Else If Control=Button3
;~    ToolTip,More Keys
Else If Control=Static5
   ToolTip,Click and Drag to get the coord mouse.
Else ToolTip
}
Else ToolTip
Control_old:=Control
Return
Button...:
Gui +OwnDialogs
Last_line=0
FileSelectFile,Temp,,,,Text file(*.txt)
If Temp=
   Return
Loop,Read,%Temp%
Last_line:=A_Index
If !Last_line
{
   MsgBox,48,ERROR!,Can't read the text file.
   Return
}
Return
Mid_text:
FileReadLine,Temp,%Sfile%,%Start_line%
Send {Raw}%Temp%
Start_line++
If Start_line>%Last_line%
Start_line=1
Return
Mid_button:
GuiControlGet,Mid_button,,Mid_button
GuiControl,Enable%Mid_button%,Mid3
Return
GuiClose:
DllCall("AnimateWindow","UInt",ID,"Int",300,"UInt","0x90000")
BlockInput,MouseMoveOff ; Just in case have some problem
ExitApp
Return
Auto_optimize:
GuiControlGet,Auto_optimize,,Auto_optimize
Return
optimize:
Count=0
Loop,% LV_GetCount()-1
{
   Count++
   LV_GetText(Line1a,Count,2)
   LV_GetText(Line1b,Count,3)
   LV_GetText(Line2a,Count+1,2)
   LV_GetText(Line2b,Count+1,3)
   if (line1a=line2a) && (line1b=line2b)
   {
      LV_Delete(Count)
      Count--
   }
}
Sort_list()
Return
Repeat:
GuiControlGet,Repeat,,Repeat
if Repeat
   GuiControl,enable,repn
Else GuiControl,enable0,repn
Return
tip:
SetTimer,tip,Off
TrayTip
Return
Return
show:
gui,show
Menu,tray,disable,Show
Menu,tray,enable,Hide
Return
hide:
gui,hide
Menu,tray,disable,Hide
Menu,tray,enable,Show
Return
clear:
GuiControlGet,clear,,clear
Return
ButtonSet:
GuiControlGet,hrec,,hrec
GuiControlGet,hplay,,hplay
GuiControlGet,hbreak,,hbreak
GuiControlGet,hclear,,hclear
GuiControlGet,hpause,,hpause

Hotkey,%hrec_old%,Rec,off UseErrorLevel
Hotkey,%hrec%,Rec,on UseErrorLevel
hrec_old:=hrec

Hotkey,%hplay_old%,Play,off UseErrorLevel
Hotkey,%hplay%,Play,on UseErrorLevel
hplay_old:=hplay

Hotkey,%hbreak_old%,lstop,off UseErrorLevel
Hotkey,%hbreak%,lstop,on UseErrorLevel
hbreak_old:=hbreak

Hotkey,%hclear_old%,ClearAll,off UseErrorLevel
Hotkey,%hclear%,ClearAll,on UseErrorLevel
hclear_old:=hclear

Hotkey,%hpause_old%,Pause_loop,off UseErrorLevel
Hotkey,%hpause%,Pause_loop,on UseErrorLevel
hpause_old:=hpause
Return
lstop:
lstop=1
Pausing=0
Return
Auto_hide:
GuiControlGet,Auto_hide,,Auto_hide
Return
ope:
gui +OwnDialogs
FileSelectFile,file,,%root%,Open,Mouse Record File(*.mrc)
if file=
   Return
SplitPath,file,,root,ext
if ext<>mrc
   Return
Loop,Read,%file%
{
   StringSplit,Temp,A_loopReadLine,|
   LV_Add("",Temp1,Temp2,Temp3)
   }
Gosub,Stop_record
Return
sav:
If !LV_GetCount()
{
   MsgBox,48,Error!,Nothing to save!
   Return
   }
gui +OwnDialogs
FileSelectFile,file,S16,%root%,Save,Mouse Record File(*.mrc)
if !file
   Return
FileDelete,%file%
SplitPath,file,,root,,file
Loop % LV_GetCount()
{
   LV_GetText(Temp,A_Index,1)
   LV_GetText(Temp2,A_Index,2)
   LV_GetText(Temp3,A_Index,3)
   FileAppend,% Temp "|" Temp2 "|" Temp3 "`n",%root%\%file%.mrc
   }
Return
ClearAll:
LV_Delete()
TrayTip,%Title%,Removed all item!,,1
SetTimer,Tip,500
Return
About:
MsgBox,,About,
(
Mouse And Key Recorder  version 1.00 created by ___x@___
I hope you to enjoy it! Thanks for using.
)
Return
Get_mouse:
SetTimer,pos,10
Return

pos:
Temp:=GetKeyState("LButton",P)
If !Temp
{
   GuiControl,2:,M2,%xp%
   GuiControl,2:,M3,%yp%
   SetTimer,pos,Off
   ToolTip
}
MouseGetPos,xp,yp
ToolTip,x: %xp% `n y: %yp%
Return