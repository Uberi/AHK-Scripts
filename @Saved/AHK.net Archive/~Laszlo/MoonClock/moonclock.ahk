W:=H:=124, gL:=3, gT:=22               ; Clock Width,Height and Gaps (Left,Top)

#SingleInstance Force
#NoEnv
#Persistent

SetWinDelay -1
CoordMode Mouse, Screen                ; for moving the clock window
OnExit Exit

Menu Tray, NoStandard                  ; Short tray menu:
Menu Tray, Add, Move, Move             ; Move the clock with the mouse
Menu Tray, Add, Exit, Exit
Menu Tray, Icon, %A_WinDir%\system32\SHELL32.dll,266

WinGet ID, ID, A                       ; ID of active window
Run rundll32.exe shell32`,Control_RunDLL timedate.cpl`,`,0,,,PID
WinWait ahk_pid %PID%
WinSet AlwaysOnTop, ON, ahk_pid %PID%
WinGetPos wX0, wY0,,, ahk_pid %PID%    ; Default position of Date/Time settings
ControlGetPos cX,cY,cW,cH, ClockWndMain1, ahk_pid %PID%

wX := gL - cX,    wY := gT - cY        ; Initial clock position: Top left of screen
oX := W//2 - wX,  oY := H//2 - wY      ; Origin = center of clock
Rg := -wX . "-" . -wY . " E w"W " h" H ; Shape of clock (Region)

SetTimer Status                        ; Activate | Exit script if clock is closed
WinActivate ahk_id %ID%                ; Activate original window

Status:                                ; Check if Clock is active | closed
   IfWinNotExist ahk_pid %PID%         ; Clock shown when "Date and Time Settings" is inactive
      ExitApp
   If WinActive("ahk_pid " PID) {
      If(Full = 0)                     ; Make Full window
         Full := Pos("","","+0x800000","","Off",wX0,wY0,PID)
   }
   Else
      If(Full = "")                    ; Truncate window, click-through (Initial case)
         Full := Pos(0,Rg,"-0x800000","0x20",200,wX,wY,PID)
Return

Move:
   mX0 := wX+oX,  mY0 := wY+oY         ; remember starting mouse position
   MouseMove mX0, mY0, 10              ; move cursor to center of clock
   SetTimer Drag, 10                   ; start dragging
   HotKey LButton, Stop, On            ; Click: stop
Return

Drag:
   MouseGetPos mX, mY                  ; current cursor position
   wX += mX-mX0,  wY += mY-mY0         ; new clock position
   WinMove ahk_pid %PID%,, %wX%, %wY%
   mX0 := mX,  mY0 := mY               ; remember cursor
Return

Stop:                                  ; Stop dragging
   SetTimer Drag, Off
   HotKey LButton,Off
Return

Exit:                                  ; Close clock at Exit script
   WinClose ahk_pid %PID%
ExitApp

Pos(P,R,S,E,T,X,Y,PID) {               ; Set the clock window full or truncated
   WinSet Region, %R%, ahk_pid %PID%
   WinSet Style,  %S%, ahk_pid %PID%
   WinSet ExStyle,%E%, ahk_pid %PID%
   WinSet Transparent, %T%, ahk_pid %PID%
   WinMove ahk_pid %PID%,, %X%, %Y%
   Return P
}
