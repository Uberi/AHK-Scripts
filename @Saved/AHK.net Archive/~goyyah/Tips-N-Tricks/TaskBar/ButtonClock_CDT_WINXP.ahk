/*  

File Name   : ButtonClock_CDT_WINXP.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/ButtonClock_CDT_WINXP.ahk 
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/Snapshot7.gif 
Post        : http://www.autohotkey.com/forum/viewtopic.php?p=54863#54863 

Main Title  : Taskbar Enhancement Utility 
Sub Title   : Start Button Clock and CountDown Timer for Windows XP 

Description : A "Button Clock" in lieu of "Windows Start Button"
              Add On: A Count Down Timer

Author      : Thalon

Credit      : Adapted from Laszlo's Code - Taskbar Clock/Calendar with Processor and Memory Load bars
                                           @ http://www.autohotkey.com/forum/viewtopic.php?t=6290
Created     : 2006-04-02 
Modified    : 2006-04-02

Scripted in : AutoHotkey Version 1.0.42.07 , www.autohotkey.com 

*/ 

#Persistent 
SetFormat, float, 02.0 

Control, Hide, , Button1, ahk_class Shell_TrayWnd 
OnExit, Exitt  ; and restore the Start Button 

cTime := A_Now 
FormatTime,Time,,HH:mm:ss 

Gui, +ToolWindow -Caption            
Gui, +Lastfound                      
GUI_ID := WinExist()                
WinGet, TaskBar_ID, ID, ahk_class Shell_TrayWnd 
DllCall("SetParent", "uint", GUI_ID, "uint", Taskbar_ID) 

Menu, Tray, Tip, Start Button Clock and Countdown Timer 
Gui, Margin,0,0 
Gui, Font, S9 Bold, Arial 
Gui, Add, Button, w55 h30 gStartM vTime, % Time 
Gui, Add, Button, w55 h30 x55 y0 gStartTimer vCountdown, 00:00:00 
Gui, Show,x0 y0 AutoSize, Start Button Clock & Countdown Timer - By Thalon

SetTimer, UpdateButtonTime, 10 

;CountDown 
IniRead, UseMessage, Config.cfg, Countdown, UseMessage, 0 
IniRead, DefinedTime, Config.cfg, Countdown, DefinedTime, -1 
IniRead, DefinedMessage, Config.cfg, Countdown, DefinedMessage, No message 
IniRead, ResetKey, Config.cfg, CountDown, ResetKey, Pause 
if ResetKey != Off      ;Use the word "Off" to disable this option 
   Hotkey, %ResetKey%, Reset 
IniRead, Reset2ZeroKey, Config.cfg, CountDown, Reset2ZeroKey, PrintScreen 
if Reset2ZeroKey != Off      ;Use the word "Off" to disable this option 
   Hotkey, %Reset2ZeroKey%, Reset2Zero 

Gui, 2:Add, Groupbox, x10 r2.5 w180 section, Enter Time 
Gui, 2:Add, Text, xs+10 ys+20 section, HH / MM / SS 
Gui, 2:Add, Edit, xs+0 ys+20 w35 h20 vHours gFastInputHour Number Limit2, 00 
Gui, 2:Add, UpDown, Range00-23 
Gui, 2:Add, Edit, xs+40 ys+20 w35 h20 vMinutes gFastInputMinutes Number Limit2, 00 
Gui, 2:Add, UpDown, Range00-59 
Gui, 2:Add, Edit, xs+80 ys+20 w35 h20 vSeconds gFastInputSeconds Number Limit2, 00 
Gui, 2:Add, UpDown, Range00-59 
Gui, 2:Add, Groupbox, x10 y80 w180 h95 section, Define Message 
Gui, 2:Add, Checkbox, xs+10 ys+20 vUseMessage Checked%UseMessage% section, Use message 
Gui, 2:Add, Text, xs+90 ys+0, Time: 
Gui, 2:Add, Edit, xs+120 ys-3 w40 vDefinedTime, %DefinedTime% 
Gui, 2:Add, Edit, xs+10 ys+20 w150 r3 Multi vDefinedMessage section, %DefinedMessage% 
Gui, 2:Add, Button, xs+0 ys+60 gSubmitTime Default section, OK 
Gui, 2:Add, Button, xs+40 ys+0 gHide, Hide 
Gui, 2:Add, Button, xs+90 ys+0 gExitt, Exit 
Gui, 2:Show, Hide, Countdown 

Reset = 0 
Reset2Zero = 0 
Return 

; ---------------------------------------------------------------------------------------- 

UpdateButtonTime: 
  If cTime = %A_Now% 
     exit 
  else 
     cTime := A_Now 

  SetTimer, UpdateButtonTime, OFF 
  FormatTime,Time,,HH:mm:ss 
  GuiControl,,Time , %Time% 
  SetTimer, UpdateButtonTime, 500 
Return 
  
UpdateCountdown: 
  ;Countdown-Update 
   T = 20000101%CountDown% 
   ;Resets Countdown to last entered time 
   if Reset = 0 
   { 
      ;Sets Countdown to 00:00:00 without the defined message 
      if Reset2Zero = 0 
      { 
         T += (C - A_TickCount)/1000,Seconds 
         FormatTime FormdT, %T%, HH:mm:ss 
      } 
      else 
         FormdT = 00:00:00 

      GuiControl, , Countdown, %FormdT% 
      IfEqual FormdT, 00:00:00 
      { 
         SetTimer UpdateCountdown, Off 
         if (UseMessage = 1 and Reset2Zero = 0) 
         { 
            if DefinedTime > 0   ;Do not Timeout Messagebox if value is lower zero or not valid 
               msgbox, 4096, It's time!, %DefinedMessage%, %DefinedTime% 
            else 
               msgbox, 4096, It's time!, %DefinedMessage% 
         } 
         else if Reset2Zero = 1 
            Reset2Zero = 0 
      } 
   } 
   else 
   { 
      C = %A_TickCount% 
      Reset = 0 
   } 
Return 

;Show Window for Timer 
^!o:: 
StartTimer: 
WinShow, Countdown 
WinActivate, Countdown 
GuiControl, Focus, Hours 
return 

;For better usage of Mouse and UpDown-Buttons 
#IfWinActive, Countdown 
~WheelUp:: 
~WheelDown:: 
~Up:: 
~Down:: 
return 
#IfWinActive 

;Focus jumps to next control if 2 characters are typed 
FastInputHour: 
if A_TimeSinceThisHotkey > 100 
{ 
   Gui, 2:Submit, NoHide 
   Chars := StrLen(Hours) 
   if Chars = 2 
   { 
      Send, {Home} 
      GuiControl, Focus, Minutes 
      Send, {SHIFTDOWN}{END}{SHIFTUP} 
   }       
} 
return 

;Focus jumps to next control if 2 characters are typed 
FastInputMinutes: 
if A_TimeSinceThisHotkey > 100 
{ 
   Gui, 2:Submit, NoHide 
   Chars := StrLen(Minutes) 
   if Chars = 2 
   { 
      Send, {Home} 
      GuiControl, Focus, Seconds 
      Send, {SHIFTDOWN}{END}{SHIFTUP} 
   } 
} 
return 

;Focus jumps to next control if 2 characters are typed 
FastInputSeconds: 
if A_TimeSinceThisHotkey > 100 
{ 
   Gui, 2:Submit, NoHide 
   Chars := StrLen(Seconds) 
   if Chars = 2 
   { 
      Send, {Home} 
      GuiControl, Focus, Hours 
      Send, {SHIFTDOWN}{END}{SHIFTUP} 
   } 
} 
return 

;Set new time for Timer 
SubmitTime: 
GuiControl, Focus, Hours 
Gui, 2:Submit, 
Hours += 0.0 
Minutes += 0.0 
Seconds += 0.0 
CountDown = %Hours%%Minutes%%Seconds%  ; 6 digits = HHmmSS 
C = %A_TickCount% 
SetTimer UpdateCountdown, 500 

IniWrite, %UseMessage%, Config.cfg, Countdown, UseMessage 
IniWrite, %DefinedTime%, Config.cfg, Countdown, DefinedTime 
IniWrite, %DefinedMessage%, Config.cfg, Countdown, DefinedMessage 
return 

;Hide Countdown-Window 
Hide: 
GuiControl, Focus, Hours 
WinHide, Countdown 
return 

;Resets Countdown to last entered time 
Reset: 
Reset = 1 
SetTimer UpdateCountdown, 500      ;Re-Enable Timer if Timer run out (00:00:00) 
return 

;Sets Countdown to 00:00:00 without the defined message 
Reset2Zero: 
Reset2Zero = 1 
return 

StartM: 
Send ^{ESCAPE} 
return 

Exitt: 
  Gui, Destroy
  Control, Show, ,Button1, ahk_class Shell_TrayWnd 
  ExitApp  
Return