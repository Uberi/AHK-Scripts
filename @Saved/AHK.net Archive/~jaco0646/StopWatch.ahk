#SingleInstance force
#NoTrayIcon
#NoEnv
DateTimeStamp = %A_Year%%A_Mon%%A_DD%000000
HMS = 00:00:00.0
StringLeft, Day, A_DD, 1
If Day = 0
   StringRight, Day, A_DD, 1
Else Day := A_DD
Gui, Color, EEAA99
Gui, +Lastfound -Caption +AlwaysOnTop
WinSet, TransColor, EEAA99
Gui, Font, s10
Gui, Add, Button, w50 gUp, UP
Gui, Add, Button, w50 gDown x+30 ym, DOWN
Gui, Add, Text, x+10, %A_DDDD%`n%A_MMM%. %Day%
Gui, Font, w1000 s30
Gui, Add, Text, xm vtime, %HMS%
Gui, Font, s10
Gui, Add, Text, xm cBlue vAHK gAHK, AHK
Gui, Font, w400
Gui, Add, Button, x+15 vStop gStop, EXIT
Gui, Add, DDL, w22 x+5 vColor gColor
, Clear||Default|Aqua|Blue|Fuchsia|Gray|Green|Lime|Maroon|Navy|Olive|Purple|Red|Silver|Teal|White|Yellow
Gui, Add, Text, x+50, %A_YYYY%
Gui, Show, x60 y40, StopWatch
WinGetPos,,,w1
SetTimer, Focus
SetTimer, Blink, 500
return
GuiClose:
ExitApp
;
;#########
;#gLabels#
;#########
;
Up:
SetTimer, Count, 100
up = 1
TimerOn = 1
SetTimer, Blink, Off
GuiControl, Show, time
GuiControl,, Stop, STOP
return
Down:
SetTimer, Count, 100
up = 0
TimerOn = 1
SetTimer, Blink, Off
GuiControl, Show, time
GuiControl,, Stop, STOP
return
Color:
Gui, Submit, NoHide
If Color = Clear
{
   Color = EEAA99
   Gui, -Caption
}
Else Gui, +Caption
Gui, Color, %Color%
Loop
{
   Gui, Show, AutoSize
   WinGetPos,,,w2
   If (w2 >= w1)
      break
}
return
AHK:
Run, http://www.autohotkey.com/forum/viewtopic.php?t=13884
return
;
;#########
;##Timer##
;#########
;
Count:
If up
{
   tenth++
   If tenth > 9
   {
      DateTimeStamp += 1, seconds
      tenth = 0
      FormatTime, HMS, %DateTimeStamp%, HH:mm:ss
   }
}
Else
{
   tenth--
   If tenth < 0
   {
      DateTimeStamp += -1, seconds
      tenth = 9
      FormatTime, HMS, %DateTimeStamp%, HH:mm:ss
   }
   If (red != 1) AND (HMS = "00:00:00") AND (tenth = 0)
   {
      SoundBeep
      Gui, Font, Norm cRed w1000 s30
      GuiControl, Font, time
      red = 1
      up = 1
   }
}
GuiControl,, time, %HMS%.%tenth%
return
;
;#########
;##Stop###
;#########
;
Stop:
If timerOn
{
   SetTimer, Count, Off
   timerOn = 0
   If red = 1
   {
      Gui, Font, Norm cBlack w1000 s30
      GuiControl, Font, time
      red = 0
   }
}
Else
{
   GuiControlGet, ButtonName,, Stop
   If ButtonName = Exit
      ExitApp
   DateTimeStamp = %A_Year%%A_Mon%%A_MDay%000000
   HMS = 00:00:00.0
   tenth = 0
   GuiControl,, time, %HMS%
   GuiControl,, Stop, EXIT
   SetTimer, Blink, On
}
return
;
;#########
;##Blink##
;#########
;
Blink:
If toggle
 toggle = 0
Else toggle = 1
GuiControl, Hide%toggle%, time
return
;
;#########
;##DDL####
;#########
;
Focus:
GuiControlGet, focus, Focus
If (focus = "ComboBox1") AND (expand != 1)
{
   GuiControl, Move, Color, w70
   Control, ShowDropDown,, ComboBox1, StopWatch
   expand = 1
}
Else If (focus != "") AND (focus != "ComboBox1") AND (expand = 1)
{
   GuiControl, Move, Color, w22
   expand = 0
}
MouseGetPos,,,,focus
If (focus = "Static3") AND (Static3 != 1)
{
   Static3 = 1
   Gui, Font, Norm s10 w1000 c6495ED underline
   GuiControl, Font, AHK
}
Else If (focus != "Static3") AND (Static3 = 1)
{
   Static3 = 0
   Gui, Font, Norm s10 w1000 cBlue
   GuiControl, Font, AHK
}
return