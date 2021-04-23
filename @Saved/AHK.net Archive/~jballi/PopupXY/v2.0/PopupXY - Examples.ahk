#NoEnv
#SingleInstance Force
ListLines Off

;-- Initialize
DetectHiddenWindows On
SysGet MonitorWorkArea,MonitorWorkArea

PositionList=
   (ltrim join|
    Top Left
    Top Center
    Top Right
    Center Left
    Center
    Center Right
    Bottom Left
    Bottom Center
    Bottom Right
   )

;-- ParentGUI
gui +Resize -MaximizeBox -MinimizeBox
gui Margin,0,0
gui Add,Text,  xm h80 w400 Center
  ,`nPopupXY Test`nIf desired, you can move/resize this window before clicking a button.
gui Add,Text,   xm,Position:
gui Add,ListBox,xm w150 r9 vPosition,%PositionList%
GuiControl Choose, ListBox1,5  ;-- Center
gui Add,Button,    xm y+10 w150 gPopup1,Popup 1
gui Add,Button, xm wp gPopup2,Popup 2
gui Add,Button, xm wp gPopup3,Popup 3
gui Add,Button, xm wp gCalculator,Calculator
gui Add,Button, xm wp gNotepad,Notepad
gui Add,Button, xm wp gMsgBox,MsgBox
gui Add,Button, xm wp gInputBox,InputBox
gui Add,Button, xm wp gReload,Reload...

;-- Render, position, and show
gui Show,Hide,ParentGUI  ;-- Render but don't show
WinGetPos,,,ParentW,ParentH,ParentGUI
Random PosX,MonitorWorkAreaLeft,% MonitorWorkAreaRight-ParentW
Random PosY,MonitorWorkAreaTop,% MonitorWorkAreaBottom-ParentH
gui Show,x%PosX% y%PosY%
return


Popup1:
gui Submit,NoHide
gui 1:+Disabled
gui 2:+Owner1
gui 2:-MinimizeBox
gui 2:Add,Edit,w200 r1
gui 2:Show,Hide,Popup1  ;-- Render but don't show
PopupXY(1,2,Position,PosX,PosY)
gui 2:Show,x%PosX% y%PosY%  ;-- Show in new position
return


Popup2:
gui Submit,NoHide
gui 1:+Disabled
gui 3:+Owner1
gui 3:-MinimizeBox
gui 3:Add,Edit,w500 r5
gui 3:Show,Hide,Popup2  ;-- Render but don't show
PopupXY("ParentGUI",3,Position,PosX,PosY)
gui 3:Show,x%PosX% y%PosY%  ;-- Show in new position
return


Popup3:
gui Submit,NoHide
gui 1:+Disabled
gui 4:+Owner1
gui 4:-MinimizeBox
gui 4:Add,Edit,w200 r25
gui 4:Show,Hide,Popup3  ;-- Render but don't show
Coordinates:=PopupXY(1,"Popup3",Position)
XPos:=Coordinates & 0xFFFF  ;-- LOWORD
YPos:=Coordinates >> 16     ;-- HIWORD
gui 4:Show,x%XPos% Y%YPos%  ;-- Show in new position
return


Calculator:
;-- Note: Calc doesn't obey the hide command on startup but for other programs
;   you should be able to run the program hidden, move it, and then show it in
;   the correct location.  Although not the best example, see the Notepad code
;   below.
;
gui Submit,NoHide
Run calc.exe,,,CalcPID
WinWait ahk_pid %CalcPID%,,2
if ErrorLevel
    return
PopupXY(1,"ahk_pid " . CalcPID,Position,PosX,PosY)
WinMove ahk_pid %CalcPID%,,%PosX%,%PosY%
WinWaitClose ahk_pid %CalcPID%
return


Notepad:
gui Submit,NoHide
Run Notepad.exe,,Hide,NotepadPID
WinWait ahk_pid %NotepadPID%,,2
if ErrorLevel
    return
WinGet, hNotepad,ID,ahk_pid %NotepadPID%
WinMove ahk_pid %NotepadPID%,,,,300,150
PopupXY(1,hNotepad,Position,PosX,PosY)
WinMove ahk_pid %NotepadPID%,,%PosX%,%PosY%
WinShow ahk_pid %NotepadPID%
return


MsgBox:
gui Submit,NoHide
SetTimer MsgBox2,50
Gui +OwnDialogs  ;-- This makes the MsgBox window modal
MsgBox This is just a test message...
return

MsgBox2:
;-- Note:  This may not the most elegant way of repositioning a MsgBox window 
;   but it does work!
;
SetTimer %A_ThisLabel%,Off
hMsgBox:=WinExist("A")
PopupXY(1,"ahk_id " . hMsgBox,Position,PosX,PosY)
WinMove ahk_id %hMsgBox%,,%PosX%,%PosY%
return


InputBox:
gui Submit,NoHide
SetTimer InputBox2,50
Gui +OwnDialogs  ;-- This makes the InputBox window modal
InputBox Test
return

InputBox2:
;-- Note:  This is not the most elegant way of repositioning a InputBox window 
;   but it does work!
;
SetTimer %A_ThisLabel%,Off
hInputBox:=WinExist("A")
PopupXY(1,hInputBox,Position,PosX,PosY)
WinMove ahk_id %hInputBox%,,%PosX%,%PosY%
return


Reload:
Reload
return


GUIEscape:
GuiClose:
ExitApp

2GUIEscape:
2GUICLose:
3GUIEscape:
3GUIClose:
4GUIEscape:
4GUIClose:
gui 1:-Disabled
gui Destroy
return


#include PopupXY.ahk
