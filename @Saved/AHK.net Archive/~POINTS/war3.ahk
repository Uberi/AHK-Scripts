#SingleInstance force		;force a single instance
#HotkeyInterval 0		;disable the warning dialog if a key is held down
#InstallKeybdHook		;Forces the unconditional installation of the keyboard hook
#UseHook On			;might increase responsiveness of hotkeys
#MaxThreads 20			;use 20 (the max) instead of 10 threads
SetBatchLines, -1		;makes the script run at max speed
SetKeyDelay , -1, -1		;faster response (might be better with -1, 0)
;Thread, Interrupt , -1, -1	;not sure what this does, could be bad for timers 

;;;;; Make the icon the TFT icon (Author: NiJo?) ;;;;;  
regread, war, HKEY_CURRENT_USER, Software\Blizzard Entertainment\Warcraft III, ProgramX
menu, tray, Icon, %War%, 1, 1 

;;;;; Variables ;;;;;
InChatRoomOn := False
HealthBarOn := False
FollowOn := False

;;;;; Timers ;;;;;
;; this timer checks to see if warcraft is active and turns on the health bars
settimer, timer_Warcraft, 1000 ;check every 1 second
timer_Warcraft:
{
  ifWinActive, Warcraft III
  {
    if (HealthBarOn == False)
    {
      Send, {[ Down}
      Send, {] Down}
      HealthBarOn := True
    }
  }

  else ifWinNotActive, Warcraft III
  {
    ;; turn off stuff
    if (HealthBarOn == True)
    {
      Send, {[ Up}
      Send, {] Up}
      HealthBarOn := False
    }

    ;; same for scrollLock
    if (FollowOn == True)
    {
      Send, {LButton Up}
      FollowOn := False
    }
  }
}

OnExit, ExitSub
return

ExitSub:
ExitApp ;The only way for an OnExit script to terminate itself is to use ExitApp


;;;;; Hotkeys ;;;;;
#ifWinActive, Warcraft III ;*new to ver 1.0.41.00* only run when war3 is running

;;;;; Enable/disable all hotkeys ;;;;;
;; For some reason the *~ commands do not work with warcraft
*Enter::
Suspend, Permit
Send, {Blind}{Enter}
if (InChatRoomOn == True)
  return
Suspend
if (A_IsSuspended == 1)
  SoundPlay,*64
else
  SoundPlay,*48
return

;; use numpadenter to turn off hotkeys if we press esc or some how mess it up
*NumpadEnter::
Suspend, Permit
Send, {Blind}{NumpadEnter}
Suspend, Off
SoundPlay,*48
return

;;;; Scroll Lock to toggle follow mode (useful in replays) ;;;;;
*ScrollLock::
Send, {Blind}{ScrollLock} ; toggle the light
if FollowOn
  Send, {LButton Up}
else
  Send, {LButton Down}
FollowOn := not FollowOn
return

*Pause::
Suspend, Permit
if (InChatRoomOn == False)
{
  Suspend, On
  InChatRoomOn := True
  SoundPlay,*64
}
else
{
  Suspend, Off
  InChatRoomOn := False
  SoundPlay,*48
}
return

;;;;; Use CAPSLOCK to toggle health on/off ;;;;;
;; the health bars are automatic now and cannot be turned off
;; however if for some reason they get turned off, pressing caps will turn it on
*Capslock::
if (HealthBarOn == False)
{
  Send, {[ Down}
  Send, {] Down}
  HealthBarOn := True
}
else
{
  Send, {[ Up}
  Send, {] Up}
  HealthBarOn := False
}
return

;; the send command allows us to hold down a key and it will repeat
;; useful for casting spells (ie summons) and tp-ing asap
q::Send q
+q::Send Q
w::Send w
+w::Send W
e::Send e
+e::Send E
r::Send r
+r::Send R

a::Send a
+a::Send A
s::Send s
+s::Send S
d::Send d
+d::Send D
f::Send f
+f::Send F

z::Send z
+z::Send Z
x::Send x
+x::Send X
c::Send c
+c::Send C
v::Send v
+v::Send V


;;;;; Use tgbyhn instead of KEYPAD for inventory ;;;;;
t::Send, {Numpad7}
g::Send, {Numpad4}
b::Send, {Numpad1}
y::Send, {Numpad8}
h::Send, {Numpad5}
n::Send, {Numpad2}

+t::Send, +{Numpad7}
+g::Send, +{Numpad4}
+b::Send, +{Numpad1}
+y::Send, +{Numpad8}
+h::Send, +{Numpad5}
+n::Send, +{Numpad2}


;;;;; Use TAB like CTRL to set Control Groups ;;;;;
~Tab & 1::Send, ^1
~Tab & 2::Send, ^2
~Tab & 3::Send, ^3
~Tab & 4::Send, ^4
~Tab & 5::Send, ^5
~Tab & 6::Send, ^6
~Tab & 7::Send, ^7
~Tab & 8::Send, ^8
~Tab & 9::Send, ^9
~Tab & 0::Send, ^0


;;;; use Wheel for tab ;;;;;
*WheelUp::send, {Tab}
*WheelDown::Send +{Tab}
