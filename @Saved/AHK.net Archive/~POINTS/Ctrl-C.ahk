#Persistent ;To keep a script running -- such as one that contains only timers
#SingleInstance force		;force a single instance
#MaxThreads 20			;use 20 (the max) instead of 10 threads
SetBatchLines, -1		;makes the script run at max speed
Thread, Interrupt, -1, -1	;make the timer uninterruptable 
SetTitleMatchMode, 3 ;title Warcraft III must match exactly

Gui, Add, Text, w220, "Warcraft III Replay Automatic Center Ctrl-C" script is now running at an interval of 10 ms (when Warcraft III is active).`n`nPress Ctrl-C to Pause/Unpause the script.`n`nPress the Exit button when you are finished.
Gui, Add, Button, Default w120 h25 x60 y120, Exit
Gui, Show, x200 y200 h150 w240, Ctrl-C

bIsPaused := false

settimer, timer_CtrlC, 10 ;check every .01 seconds (100 times a second)
timer_CtrlC:
{
  IfWinActive, Warcraft III ahk_class Warcraft III
    Send, ^c
}
Return


ButtonExit:
GuiClose:
ExitApp

#IfWinActive, Warcraft III ahk_class Warcraft III
^c::
bIsPaused := not bIsPaused
if (bIsPaused)
{
  SoundPlay,*64
  settimer, timer_CtrlC, OFF
}  
else ;if (not bIsPaused)
{
  SoundPlay,*48
  settimer, timer_CtrlC, ON
}
Return
