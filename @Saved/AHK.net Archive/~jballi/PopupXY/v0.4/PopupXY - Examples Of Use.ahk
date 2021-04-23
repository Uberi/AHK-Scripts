#NoEnv
#SingleInstance Force
ListLines Off

;-- Initialize
DetectHiddenWindows On
SysGet MonitorWorkArea,MonitorWorkArea

;-- ParentGUI
gui +Resize -MaximizeBox -MinimizeBox
gui Margin,0,0
gui Add,Text,  xm h90 w400 Center
  ,`nPopupXY Test`nIf desired, you can move/resize this window before clicking a button.
gui Add,Button,xm w150  gPopup1,Popup 1
gui Add,Button,xm hp wp gPopup2,Popup 2
gui Add,Button,xm hp wp gPopup3,Popup 3
gui Add,Button,xm hp wp gCalculator,Calculator
gui Add,Button,xm hp wp gNotepad,Notepad
gui Add,Button,xm hp wp gMsgBox,MsgBox
gui Add,Button,xm hp wp gInputBox,InputBox
gui Add,Button,xm hp wp gReload,Reload...

;-- Render, position, and show
gui Show,Hide,ParentGUI  ;-- Render but don't show
WinGetPos,,,ParentW,ParentH,ParentGUI
Random PosX,MonitorWorkAreaLeft,% MonitorWorkAreaRight-ParentW
Random PosY,MonitorWorkAreaTop,% MonitorWorkAreaBottom-ParentH
gui Show,x%PosX% y%PosY%
return


Popup1:
gui 1:+Disabled
gui 2:+Owner1
gui 2:-MinimizeBox
gui 2:Add,Edit,w200 r1
gui 2:Show,Hide,Popup1  ;-- Render but don't show
PopupXY(1,2,PosX,PosY)
gui 2:Show,x%PosX% y%PosY%  ;-- Show in new position
return


Popup2:
gui 1:+Disabled
gui 3:+Owner1
gui 3:-MinimizeBox
gui 3:Add,Edit,w500 r5
gui 3:Show,Hide,Popup2  ;-- Render but don't show
PopupXY("ParentGUI",3,PosX,PosY)
gui 3:Show,x%PosX% y%PosY%  ;-- Show in new position
return


Popup3:
gui 1:+Disabled
gui 4:+Owner1
gui 4:-MinimizeBox
gui 4:Add,Edit,w200 r25
gui 4:Show,Hide,Popup3  ;-- Render but don't show
Coordinates:=PopupXY(1,"Popup3")
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
Run calc.exe,,,CalcPID
WinWait ahk_pid %CalcPID%,,2
if ErrorLevel
    return
PopupXY(1,"ahk_pid " . CalcPID,PosX,PosY)
WinMove ahk_pid %CalcPID%,,%PosX%,%PosY%
WinWaitClose ahk_pid %CalcPID%
return


Notepad:
Run Notepad.exe,,Hide,NotepadPID
WinWait ahk_pid %NotepadPID%,,2
if ErrorLevel
    return
WinGet, hNotepad,ID,ahk_pid %NotepadPID%
WinMove ahk_pid %NotepadPID%,,,,300,150
PopupXY(1,hNotepad,PosX,PosY)
WinMove ahk_pid %NotepadPID%,,%PosX%,%PosY%
WinShow ahk_pid %NotepadPID%
return


MsgBox:
SetTimer MsgBox2,50
Gui +OwnDialogs  ;-- This makes the MsgBox window modal
MsgBox This is just a test message...
return

MsgBox2:
;-- Note:  This may not the most elegant way of repositioning a MsgBox window 
;   but it does work!
;
SetTimer %A_ThisLabel%,Off
MsgBox_hWnd:=WinExist("A")
PopupXY(1,"ahk_id " . MsgBox_hWnd,PosX,PosY)
WinMove ahk_id %MsgBox_hWnd%,,%PosX%,%PosY%
return


InputBox:
SetTimer InputBox2,50
Gui +OwnDialogs  ;-- This makes the InputBox window modal
InputBox Test
return

InputBox2:
;-- Note:  This is not the most elegant way of repositioning a InputBox window 
;   but it does work!
;
SetTimer %A_ThisLabel%,Off
InputBox_hWnd:=WinExist("A")
PopupXY(1,"ahk_id " . InputBox_hWnd,PosX,PosY)
WinMove ahk_id %InputBox_hWnd%,,%PosX%,%PosY%
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
