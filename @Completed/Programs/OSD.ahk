#NoEnv

~CapsLock::
If GetKeyState("CapsLock","T")
 OSD("Play")
Return

OSD(Display)
{
 Thread, Priority, 1
 If (A_TimeSincePriorHotkey <= 500 && A_PriorHotkey)
  Return
 Hotkey, %A_ThisHotkey%, Off
 DetectHiddenWindows, On
 Gui, 1:Color, Silver
 Gui, 1:Show, Hide w200 h200, OSDBACK
 Gui, 1:+ToolWindow -Caption +AlwaysOnTop +Disabled
 Gui, 1:+LastFound
 WinSet, Region, 0-0 W200 H200 R40-40
 WinSet, Transparent, 0
 Gui, 2:+Owner1
 Gui, 2:Color, White
 Gui, 2:Show, Hide w200 h200, OSDPIC
 Gui, 2:+ToolWindow -Caption +AlwaysOnTop +Disabled
 Gui, 2:+LastFound
 If Display = Up
  WinSet, Region, 160-130 40-130 100-60
 Else If Display = Down
  WinSet, Region, 40-70 160-70 100-140
 Else If Display = Play
  WinSet, Region, 70-50 70-150 140-100
 Else If Display = Pause
  WinSet, Region, 70-60 90-60 90-130 70-130 70-60 110-60 130-60 130-130 110-130 110-60
 Else If Display = Stop
  WinSet, Region, 60-60 140-60 140-140 60-140 60-60
 Else If Display = UpArrow
  WinSet, Region, 100-40 50-110 70-110 70-150 130-150 130-110 150-110
 Else If Display = DownArrow
  WinSet, Region, 100-160 50-90 70-90 70-50 130-50 130-90 150-90
 Else If Display = LeftArrow
  WinSet, Region, 40-100 110-50 110-70 150-70 150-130 110-130 110-150
 Else If Display = RightArrow
  WinSet, Region, 160-100 90-50 90-70 50-70 50-130 90-130 90-150
 WinSet, Transparent, 0
 Gui, 1:Show, NoActivate
 Gui, 2:Show, NoActivate
 Trans = 0
 While, (Trans <= 180)
 {
  WinSet, Transparent, %Trans%, OSDBACK
  WinSet, Transparent, %Trans%, OSDPIC
  Trans += 5
  Sleep, 5
 }
 StringTrimLeft, Temp1, A_ThisHotkey, 1
 KeyWait, %Temp1%
 Sleep, 500
 While Trans >= 0
 {
  WinSet, Transparent, %Trans%, OSDBACK
  WinSet, Transparent, %Trans%, OSDPIC
  Trans -= 5
  Sleep, 10
 }
 Gui, 1:Destroy
 Gui, 2:Destroy
 Hotkey, %A_ThisHotkey%, On
}

Esc::ExitApp