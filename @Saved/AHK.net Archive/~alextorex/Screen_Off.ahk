; SCREEN OFF - DIM
;
; - Automatically dims the screen after 5 mins (default - see "Idle_Time_Before_Dimming")
;     (leave the mouse in the top left corner of the screen to keep the screen from dimming)
; - Alt+B toggles dimming the background - useful if watching a video and don't want to make it fullscreen.
; - Ctrl+Alt+Z - turns the screen off (requires left click/Spacebar/Esc/or several seconds of mouse movement to break)


#NoTrayIcon 
#SingleInstance force
#Persistent
Coordmode, Mouse, Screen

Idle_Time_Before_Dimming =300000 ; 5 mins

Gui_Shown =0 ; initiate
Return



!b::
  Gui_Shown := ! Gui_Shown
  If Gui_Shown
    {
    Gosub, Create_Gui
    Gui, -AlwaysOnTop
    WinSet, Transparent, 170, ahk_id %Gui_ID%
    }
  Else
    Gui, Destroy
Return



;^!z:: ; go straight to screen off
#q:: ; go straight to screen off
  Gosub, Create_Gui
  Gosub, Hotkeys_to_Abort
  Gosub, Abort_Prompt
  If ((MouseMoveCount =0) or (Aborting =1)) ; keep screen on
    Return
  Gosub, Screen_Off_Immediate
  Transparency =254.9 ; allow transparency to be set to 255 in next increment later
Return


Screen_Off_Immediate:  
  SetTimer, Dim_Screen, 50
Return



Create_Gui:
  ; Set up transparent GUI. 
  Gui, +LastFound +AlwaysOnTop -Caption +Owner   ; +Owner stops taskbar button appearing. 
  Gui_ID := WinExist()
  Gui, Color, 000000
  WinSet, TransColor, 000000 0
  Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%

  Aborting =0
Return



Hotkeys_to_Abort:
  Hotkey, ~LButton, Abort, On
  Hotkey, ~Space, Abort, On
  Hotkey, ~Escape, Abort, On
Return

Hotkeys_to_Abort_off:
  Hotkey, ~LButton, Off
  Hotkey, ~Space, Off
  Hotkey, ~Escape, Off
Return



Dim_Screen:
  If CheckMouseMoved()
    Gosub, Abort
  Else
    {
    Transparency += 0.1
    If Transparency <= 255
      WinSet, Transparent, %Transparency%, ahk_id %Gui_ID%
    Else
      {
      SetTimer, Dim_Screen, off
    	SendMessage, 0x112, 0xF170, 2,, Program Manager ; Turn Monitor Off
      SetTimer, Screen_Off_CheckMouseMoved, 500 ; wait for mouse to move
      }
    }
Return



Screen_Off_CheckMouseMoved:
  If CheckMouseMoved()
    Gosub, Abort_Prompt
Return



Abort_Prompt:
  SetTimer, Screen_Off_CheckMouseMoved, Off
  WinSet, Transparent, 120, ahk_id %Gui_ID%
  MouseMoveCount = 3 ; count down from 3 for movement in secs
  MouseMoveCountLooped =0
  Gui, 2: +Toolwindow +Alwaysontop -Sysmenu -Caption +Border
  Gui, 2: Margin, 4, 4
  Gui, 2: Color, FFFF00
  Gui, 2: Font, 000000 s8 wbold, Verdana
  Gui, 2: Add, Text, +Center vMouseTooltipInfo, KEEP SCREEN ON:`nClick mouse /`n Move for %MouseMoveCount% more seconds
  SetTimer, MouseCoordsTooltipInfo, 100

  Loop ; Check for 3 secs of mouse movement, allowing for 6 secs max
    {
    If Aborting =1
      Return
    MouseMoveCountLooped += 1
    MouseGetPos, xMouse, yMouse
    Sleep, 1000
    MouseGetPos, xMouse2, yMouse2
    If ( ( xMouse != xMouse2 ) or ( yMouse != yMouse2 ) )
      {
      MouseMoveCount -= 1
      MouseMoveCountLooped -= 2 ; allow longer for total time to complete 3 secsonds of mouse movement
      If MouseMoveCount = 0
        Break
      }
    Else If MouseMoveCountLooped = 3
      Break
    }
  SetTimer, MouseCoordsTooltipInfo, Off
  Gui, 2: Destroy
  If MouseMoveCount =0 ; keep screen on
    {
    Gosub, Abort
    Return
    }
  Else
    {
   	MouseGetPos, xMouseOrig, yMouseOrig
    SetTimer, Screen_Off_CheckMouseMoved, On
  	SendMessage, 0x112, 0xF170, 2,, Program Manager ; Turn Monitor Off
    }
Return



Abort:
  Aborting =1
  SetTimer, MouseCoordsTooltipInfo, Off
  Gui, 2: Destroy
  SetTimer, Screen_Off_CheckMouseMoved, Off
  SetTimer, Dim_Screen, Off
  Gosub, Hotkeys_to_Abort_off  
  Gui, Destroy
Return



MouseCoordsTooltipInfo:
  Mousegetpos, MouseXTooltipInfo, MouseYTooltipInfo
  If (MouseXTooltipInfo > (A_Screenwidth * 0.90))
    TooltipInfoX := MouseXTooltipInfo - 160
  Else
    TooltipInfoX := MouseXTooltipInfo + 20
  If (MouseYTooltipInfo > (A_Screenheight * 0.92))
    TooltipInfoY := MouseYTooltipInfo - 80
  Else
    TooltipInfoY := MouseYTooltipInfo + 20
  Guicontrol, 2: , MouseTooltipInfo, KEEP SCREEN ON:`nClick mouse /`n Move for %MouseMoveCount% more seconds
  Gui, 2: Show, Noactivate x%TooltipInfoX% y%TooltipInfoY%, MouseTooltipInfo
Return



CheckMouseMoved()
{
  Global xMouseOrig, yMouseOrig
	MouseGetPos, xMouseNow, yMouseNow
	If ( ( xMouseNow != xMouseOrig ) or ( yMouseNow != yMouseOrig ) )
		{
		xMouseChange := ( xMouseNow - xMouseOrig ) * ( xMouseNow - xMouseOrig ) ;squared to always be positive values
		yMouseChange := ( yMouseNow - yMouseOrig ) * ( yMouseNow - yMouseOrig )
		If ( ( xMouseChange > 25 ) or ( yMouseChange > 25 ) ) ;sqrt of 25 = 5 pixels of movement
      Return 1 ; i.e. CheckMouseMoved = true
    }
}


