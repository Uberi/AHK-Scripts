; This script will calculate the APM based on using the following keys:
;  Left and Right Mouse, a-z, tab, Numpad1, Numpad2, Numpad4, Numpad5, Numpad7, 
;  Numpad8, the arrow keys and more.
; However, the keys are still counted when chatting (which is probably the way 
;  it should be).
;
; To Start the Script Press Numpad0 (you should see a message displayed)
;  At any time in the game you can press Numpad0 and the script will echo your
;  APM to warcraft via a chat message (make sure you don't press enter before 
;  pressing Numpad0).
;
; To Stop the script press NumpadDot.  You will see a message to that affect.
;
; The script automatically outputs your APM every minute.  You can change how 
;  often this occurs or under what circumstance below in the timer section.
;
; And don't forget your name, unless you like to show off your APM to everyone!
;

kstrYourName = ;/w YOURNAME  ; remove the first semi-colon and add "YOURNAME"


#SingleInstance Force

; Timer Section
settimer, timer_APM, 60000 ;check every minute
timer_APM:
{
  ifWinActive, Warcraft III
  {
    if iTimeStart
    {
      fAPM := (60000*iCount)/(A_TickCount - iTimeStart)
      ;if (fAPM < 100) ; only output if less than 100
        SendPlay, {Enter}%kstrYourName% APM:  PM%{Enter}
    }
  }
}


#IfWinActive Warcraft III ; only run when Warcraft is active

; The key to stop the script
NumpadDot::
NumpadDel::
SendPlay, {Enter}%kstrYourName% APM calculator has been reset and paused.{Enter}
iTimeStart :=
;SoundPlay,*48 ; Beeps so we know it stopped
return

; Start/Check your APM
Numpad0::
NumpadIns::
if not iTimeStart ; if we haven't started the timer yet, output this message and start the timer
{
  SendPlay, {Enter}%kstrYourName% Starting APM calculator...{Enter}
  iCount := 0 ; reset the counter so we can use it over and over
  iTimeStart := A_TickCount ; A_Tickcount stores the number of milliseconds since the computer was rebooted
  ;SoundPlay,*64 ; Beeps so we know it has started
}
else
{
  ; APM is defined as the number of actions per minute
  ;  The time is the current time minus the start time (in msec) and there are
  ;   60,000 msec per minute
  fAPM := (60000*iCount)/(A_TickCount - iTimeStart)
  SendPlay, {Enter}%kstrYourName% APM:  PM%{Enter}
}
return

; this is the list of keys we check for
~*a::
~*b::
~*c::
~*d::
~*e::
~*f::
~*g::
~*h::
~*i::
~*j::
~*k::
~*l::
~*m::
~*n::
~*o::
~*p::
~*q::
~*r::
~*s::
~*t::
~*u::
~*v::
~*w::
~*x::
~*y::
~*z::
~*tab::
~*Up::
~*Down::
~*Left::
~*Right::
~*Numpad1::
~*Numpad2::
~*Numpad4::
~*Numpad5::
~*Numpad7::
~*Numpad8::
~*NumpadEnd::
~*NumpadDown::
~*NumpadLeft::
~*NumpadClear::
~*NumpadHome::
~*NumpadUp::
~*LButton::
~*RButton::
~*WheelDown::
~*WheelUp::
~*[::
~*]::
~*Delete::
~*Insert::
~*Home::
~*End::
~*PgUp::
~*PgDn::
~*Shift::
~*Alt::
~*Ctrl::
;SoundPlay,*48 ; for debugging you can turn this beep on
if iTimeStart
  iCount++
return