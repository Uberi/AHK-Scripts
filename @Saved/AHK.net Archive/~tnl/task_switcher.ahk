#NoEnv
#NoTrayIcon
#SingleInstance, Force


WM_USER := 0x400
VW_CHANGEDESK := WM_USER + 10
VW_STEPPREV := WM_USER + 1
VW_STEPNEXT := WM_USER + 2

Sleep, 5000 ; execute laterrr

SetWinDelay, -1
SetBatchLines, -1

; forgive the lack of a unique script name so far.
; this is merely a task switcher i wrote after upgrading to win7 from winxp, still disliking change.
; it also makes clicks on unused desktop return focus to the current app
; i use a random visual style on devart where it's hard to distinguish between active and inactive windows oo;
; and i'm too lazy to change it for the time being
;
; -------------------------------------------
; what this script currently does:
; - visually highlight app windows with a prettiful border whenever focus changes
; - make left clicks on the desktop return focus to the current window
; - mousewheeling the desktop or taskbar cycles through windows (on the current desktop) abusing windows' alt esc hotkey
; - mousewheeling window titles cycles through virtual desktops for VirtuaWin
;   (protip: you can move them to other desktops by moving/click-holding them)


#Include, Gdip.ahk

; color used for temporarily displaying a frame over the active window after switching windows
HAW_color := 0xFFAACC
HAW_thickness := 24
HAW_hwnd_old = undefined

; thanks evl  http://www.autohotkey.com/forum/topic30626.html
WS_EX_TOOLWINDOW := 0x80
WS_DISABLED      := 0x8000000
WS_CAPTION       := 0xC00000
GW_OWNER         := 4

if (!pToken := Gdip_Startup()) {
  MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
  ExitApp
  return
}
OnExit, Exit



Gui, 2: -Caption +LastFound +OwnDialogs -SysMenu +Owner
Gui, 2: Show, x9999 y9999 w0 h0, ReturnFocusElsewhere
Gui, 2: Cancel


;WS_EX_TRANSPARENT = E0x20
Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +ToolWindow +AlwaysOnTop +E0x20
hwnd1 := WinExist()


SetTimer, HighlightWindowChanged, -1


; Hotkey: Win Tab
;#Tab::SendInput, {Shift Down}{Alt Down}{Esc}{Alt Up}{Shift Up}
; Hotkey: Win Backtick
;#`::SendInput, {Alt Down}{Esc}{Alt Up}
return


MouseIsOverDesktopOrTaskbar() {
  global WS_CAPTION, WCLASS, IN_TITLEBAR
  CoordMode, Screen
  MouseGetPos,, sy
  CoordMode, Window
  MouseGetPos,, y, id
  WinGet, ws, Style, ahk_id %id%
  WinGetClass, wclass, ahk_id %id%
  WinGetTitle, title, ahk_id %id%
  
  IN_TITLEBAR := sy < 2 or y < 8 or (y < 24 && (ws & WS_CAPTION))
  return title == "task_switcher" or IN_TITLEBAR or wclass == "Progman" or wclass == "WorkerW" or wclass == "Shell_TrayWnd" ;or title == "virtualdeskedge0" or title == "virtualdeskedge1"
}
#If MouseIsOverDesktopOrTaskbar()
WheelUp::
  ;if (wclass == "Shell_TrayWnd")
  if (IN_TITLEBAR)
    PostMessage, %VW_CHANGEDESK%, %VW_STEPPREV%, 0,, ahk_class VirtuaWinMainClass
  else
  {
    SendInput, {Shift Down}{Alt Down}{Esc}{Alt Up}{Shift Up}
    goto, HighlightActiveWindow
  }
return
WheelDown::
  ;if (wclass == "Shell_TrayWnd")
  if (IN_TITLEBAR)
    PostMessage, %VW_CHANGEDESK%, %VW_STEPNEXT%, 0,, ahk_class VirtuaWinMainClass
  else {
    SendInput, {Alt Down}{Esc}{Alt Up}
    goto, HighlightActiveWindow
  }
return
#If


DrawRect(hwnd1, alpha, rrggbb, x, y, width, height, thickness=24) {
  halfthick := thickness//2
  hbm := CreateDIBSection(width, height)
  hdc := CreateCompatibleDC()
  obm := SelectObject(hdc, hbm)
  G := Gdip_GraphicsFromHDC(hdc)
  Gdip_SetSmoothingMode(G, 4)
  colr := rrggbb | (alpha << 24)
  pPen := Gdip_CreatePen(colr, thickness)
  Gdip_DrawRectangle(G, pPen, halfthick, halfthick, width - thickness, height - thickness)
  Gdip_DeletePen(pPen)
  UpdateLayeredWindow(hwnd1, hdc, x, y, width, height)
  SelectObject(hdc, obm)
  DeleteObject(hbm)
  DeleteDC(hdc)
  Gdip_DeleteGraphics(G)  
}

HighlightActiveWindow:
  HAW_hwnd := hwnd
  if (HAW_hwnd == HAW_hwnd_old)
    return
  HAW_hwnd_old := HAW_hwnd
  SetTimer, HighlightActiveWindowFadeout, Off
  WinGetPos, HAW_x, HAW_y, HAW_w, HAW_h, A
  HAW_a := 0xCC
  DrawRect(hwnd1, HAW_a, HAW_color, HAW_x, HAW_y, HAW_w, HAW_h, HAW_thickness)
  Gui, 1: +AlwaysOnTop
  Gui, 1: Show, NoActivate, task_switcher
  SetTimer, HighlightActiveWindowFadeout, -150
return

HighlightActiveWindowFadeout:
  if (HAW_a > 0) {
    DrawRect(hwnd1, HAW_a, HAW_color, HAW_x, HAW_y, HAW_w, HAW_h, HAW_thickness)
    HAW_a -= 0x24
    SetTimer, HighlightActiveWindowFadeout, -24
  } else {
    Gui, 1: Hide 
    ;if (RClick)
    ;  MouseClick, R, %mx%, %my%
    ;RClick = 0
  }
return

HighlightWindowChanged:
  Loop { ; Forever
    hwnd := WinActive("A")
    ;if (GetKeyState("Alt") && IsTopLevelWindow())
    if (IsTopLevelWindow())
      GoSub, HighlightActiveWindow
    WinWaitNotActive, ahk_id %hwnd%
  }
return

Exit:
  Gdip_Shutdown(pToken)
  ExitApp
return

;#h::isTopLevelWindow(1)
isTopLevelWindow(debug=0) {
  global GW_OWNER, WS_DISABLED, WS_EX_TOOLWINDOW
  static prev_wid := -1
  wid := WinActive("A")
  if (wid == prev_wid)
    return 0
  prev_wid := wid
  WinGetTitle, title, ahk_id %wid%
  WinGet, ws, Style, ahk_id %wid%
  WinGet, es, ExStyle, ahk_id %wid%
  WinGet, mm, MinMax, ahk_id %wid%
  if (mm > 0) ;maximized
    WinRestore, ahk_id %wid%
  owner := DllCall("GetWindow", "uint", wid, "uint", GW_OWNER)
  if (debug)
    Tooltip, hwnd: %wid%`ntitle: %title%`nowner: %owner% 
  return !((ws & WS_DISABLED) || (es & WS_EX_TOOLWINDOW) || !(title) || owner)
}



; Make clicks on unused desktop area return focus to the current application. Great since you don't use the desktop.

; http://www.autohotkey.com/forum/topic71162.html
~LButton Up::
  MouseGetPos,,,winid
  WinGetClass,winclass,ahk_id %winid% ;retrieves current winclass

  if (winclass == "Progman" or winclass == "WorkerW") ;if desktop. (i've seen WorkerW on some 64 bit Windows 7 OS's)
  {
    SendMessage,4100,0,0,SysListView321,Program Manager ahk_class Progman ;retrieves desktop icon count
    icon_number := ErrorLevel
  
    SendMessage,4157,0,0,SysListView321,Program Manager ahk_class Progman ;retrieves the clicked desktop icons index.If empty space was clicked,returns a very large integer, or simply a negative value
    temp_Index := ErrorLevel
  
    if (temp_Index < 0 || temp_Index > icon_number) ;if desktop icon wasn't clicked..
    {
	  ; Switch back to active task
      Gui, 2: Show
      Gui, 2: Cancel
    }
  }
return
