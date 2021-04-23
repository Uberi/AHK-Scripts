; a collection of fixes for some annoyances i've encountered.

#HotkeyInterval 999999
#MaxHotkeysPerInterval 999999
#NoEnv
#SingleInstance, Force
#NoTrayIcon
#Persistent

SetDefaultMouseSpeed, 0
; for SendPlay (more convenient than SendInput and Sleep, i guess?)
SetKeyDelay, 5, 10, Play

; http://www.autohotkey.com/forum/topic28332.html post by uogpjf
; disable the winkeys hit alone, without disabling hotkey using win as a modifier
; win95ism ctrl+esc  still works im cool with that
~LWin Up::return
~RWin Up::return

; this is meant for games. it's kind of optimistic to want this to work with all of them.
; it doesn't work for games that don't let you set a windowed resolution equal to the display resolution
SetTimer, RemoveFullscreenWindowedBorders, -1 ; make new thread


; Make right clicks at the resize area right click on titlebars as well.
;
; #moredocsthancode
;
; this obscure behavior is only useful for if you use an app such as winroll
; in win7. the height of the resize box for at least my visual style is 8px.
; useful for when you dock windows to the top edge of your desktop area
; (creating an infinitely large target according to Fitts' Law)
; 
; assume coord mode is relative to window (default for ahk)
; do not override default behavior for rclick, since on a resize area it does
; nothing anyway. i've found overriding default breaks mouse gesture software
~RButton::
  MouseGetPos,, my, hwnd
  WinGet, ws, Style, ahk_id %hwnd%
  ; WS_SIZEBOX := 0x040000    window has a border for resizing
  ; WS_CAPTION := 0xC00000    window has a titlebar
  if ((my < 8) && (ws & 0x40000) && (ws & 0xC00000)) 
    MouseClick, R, 0, 8,, 0,, R
return


; http://www.howtogeek.com/howto/8955/make-backspace-in-windows-7-or-vista-explorer-go-up-like-xp-did/
; my tweak to make it treat (My) Computer as the topmost level as WinXP does it.

; a side-effect of this shit is that it mistriggers a hotkey I use often: Alt+Backspace.
; i'll have to fix that one day
#IfWinActive, ahk_class CabinetWClass
Backspace::
  ControlGet, renamestatus, Visible,, Edit1, A
  ControlGetFocus, focused, A
  if (renamestatus != 1 && (focused == "DirectUIHWND3" || focused == "SysTreeView321")) {
    ControlGetText, address, ToolbarWindow322, A
    ; just in case you held down backspace and script did not catch the control text change in time, overshooting Computer
    if (address == "Address: Desktop")
      SendInput, Computer{Enter}
    else if (address != "Address: Computer")
      SendInput, {Alt Down}{Up}{Alt Up}
  }
  else
    SendInput, {Backspace}
return
#IfWinActive


; make F1 do nothing for certain apps. everyone googles for help nowadays
#IfWinActive, ahk_class IrfanView
F1::return
#IfWinActive
#IfWinActive, ahk_class FullScreenClass
F1::return
#IfWinActive


; fixes (IMO) weirdass Google Chrome behaviour
#IfWinActive, ahk_class Chrome_WidgetWin_0
^WheelUp::SendInput, {Ctrl Down}={Ctrl Up}
^WheelDown::SendInput, {Ctrl Down}-{Ctrl Up}
#IfWinActive


; focuses search query editbox in Everything because of webbrowser habit
; - useful if you allow multiple search instances (why did i make this comment)
#IfWinActive, ahk_class EVERYTHING
^l::
  ControlGetFocus, focused, A
  if (focused != "Edit1")
    SendInput, {Tab}
return
#IfWinActive



WinGetMonitor(spec) {
  WinGetPos, x, y, w, h, %spec%
  wx := x + w//2
  wy := y + h//2
  SysGet, n, MonitorCount
  if (n == 1)
    return 1
  closest := -1
  Loop, %n% {
    SysGet, m, Monitor, %A_Index%
    mw := mRight - mLeft
    mh := mBottom - mTop
    mx := mLeft + mw//2
    my := mTop + mh//2
    distance := sqrt( (wx-mx)**2 + (wy-my)**2 )
    if (closest < 0 || distance < closest) {
      closest := distance
      monitor := A_Index
    }
  }
  return monitor  
}


WinIsTopmost(spec) {
  static WS_EX_TOPMOST := 0x8
  WinGet, s, ExStyle, %spec%
  return (s & %WS_EX_TOPMOST%)
}

; iono, i just wanted local variables so i put everything into a function
; refine this to check for WS_SIZEBOX/THICKFRAME and WS_BORDER? idk how :(
RemoveFullscreenWindowedBorders:
  RemoveFullscreenWindowedBordersForever()
return
RemoveFullscreenWindowedBordersForever() {
  Gui, +LastFound +Disabled -SysMenu +Owner
  Gui, Show, x9999 y9999 w200 h120 NoActivate, %A_Space%
  WinGetPos _, _, BorderW, BorderH
  Gui, Destroy
  BorderW -= 200
  BorderH -= 120
  Loop { ; Forever
    hwnd := WinActive("A")
    WinGetPos, , , w, h, A
    SysGet, mon, Monitor, % WinGetMonitor("A")
    monw := monRight - monLeft + BorderW
    monh := monBottom - monTop + BorderH
    monh2 := monBottom - monTop + BorderH//2
    ; ridiculous and likely doesn't catch enough cases
    if ((!WinIsTopmost("A")) && ((w == monw) || (h == monh) || (h == monh2))) {
      WinSet, Style, -0x00800000 ; WS_BORDER
      WinSet, Style, -0x00C00000 ; WS_CAPTION
      WinSet, Style, -0x00040000 ; WS_THICKFRAME
      WinMove, A, , %monLeft%, %monTop%, % (monRight - monLeft), % (monBottom - monTop)
    }
    WinWaitNotActive, ahk_id %hwnd%
  }
}

; autoclear clipboard after 3mins due to ocd
OnClipboardChange:
  if (clipboard != "")
  {
    SetTimer, ClearClipboard, Off
    SetTimer, ClearClipboard, -180000
  }
return
ClearClipboard:
  clipboard := ""
return
