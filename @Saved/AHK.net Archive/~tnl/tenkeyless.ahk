; My personal scripts for tenkeyless keyboarding.
;   by tnl (tnl TA asia TOD com)
;
; It has hotkeys for apps that use NumpadSub and NumpadAdd to zoom out/zoom in
; (notably image editors):
;   AppsKey + PgUp
;   AppsKey + PgDown
;
; It also has a hotkey-activated GUI to input ASCII characters by decimal,
; or Unicode characters by hexadecimal:
;  - Press ` or Tab or LWin to interpret decimal codepoint for ASCII
;  - Press \ or Enter to interpret hexadecimal codepoint for Unicode.
;  - Press F1 to run Windows' Character Map utility.
;
; Not Todo: live GUI preview of character input... might be difficult in AHK
;

; http://www.autohotkey.com/forum/viewtopic.php?p=43496#43496
; Probably not the ideal function from there to use, but it works.
SendInputU( p_text ) ; 4 DllCalls/char + 1, reduced from 20/char + 1 
{ 
   event_count := ( StrLen(p_text)//4 )*2 
   VarSetCapacity( events, 28*event_count, 0 ) 
   base = 0 
   Loop % event_count//2 
   { 
      StringMid code, p_text, 4*A_Index-3, 4
      code = 0x4%code% 

      DllCall("RtlFillMemory", "uint", &events + base, "uint",1, "uint", 1) 
      DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&events+base+6, "uint",4, "uint",code) 
      base += 28 

      DllCall("RtlFillMemory", "uint", &events + base, "uint",1, "uint", 1) 
      DllCall("ntoskrnl.exe\RtlFillMemoryUlong", "uint",&events+base+6, "uint",4, "uint",code|(2<<16)) 
      base += 28 
   } 
   result := DllCall( "SendInput", "uint", event_count, "uint", &events, "int", 28 ) 
;   if ( ErrorLevel or result < event_count ) 
;      MsgBox SendInput failed`nErrorLevel = %ErrorLevel%`n%result% events of %event_count% 
}


#SingleInstance Force
#NoEnv
#NoTrayIcon
#HotkeyInterval 999999
#MaxHotkeysPerInterval 9999
#UseHook On
SendMode Input
SetWorkingDir, %A_ScriptDir%

WindowTitle := "ASCII/Unicode Character Input"

Gui, -SysMenu -Caption        +0x800000 ;add a border
Gui, +LastFound +Owner +ToolWindow +OwnDialogs +AlwaysOnTop
Gui, Add, Edit, x0 y0 w42 h20 r1 Right Uppercase Limit4 vCodepoint

; Create the GUI window offscreen and get its handle
SysGet, VirtualL, 76
SysGet, VirtualT, 77
SysGet, VirtualR, 78
SysGet, VirtualB, 79
VirtualR += VirtualL
VirtualB += VirtualT
Gui, Show, x%VirtualR% y%VirtualB% NoActivate
Hwnd1 := WinExist()
Gui, Cancel

OnMessage(0x01C, "WM_ACTIVATEAPP")
WM_ACTIVATEAPP(wParam, lParam)
{
  if !wParam ; gui lost focus
    GoSub, GuiClose
}

OnMessage(0x100, "WM_KEYDOWN")
WM_KEYDOWN(wParam, lParam)
{ ; hard to find some good keys to use...
  if (wParam = 91 || wParam == 9 || wParam == 192) ; LWin OR Tab OR `
  {
    GuiControlGet, seq,, Codepoint
    Gui, Cancel
    KeyWait LWin
    KeyWait RWin
    Send {ASC %seq%}
    return 1
  }
  if (wParam = 13 || wParam = 220) ; Enter OR \ 
  {
    GuiControlGet, seq,, Codepoint
    Gui, Cancel
    KeyWait LWin
    KeyWait RWin
    SendInputU(seq)
    return 1
  }
}

OnMessage(0x101, "WM_KEYUP")
WM_KEYUP(wParam, lParam)
{
  if (wParam = 112) ; F1
    Run, charmap.exe
}

AppsKey & PgUp::Send {NumpadSub}
AppsKey & PgDn::Send {NumpadAdd}
AppsKey::Send {AppsKey}
#U::
  IfWinActive, ahk_id %Hwnd1%
    return

  WinGetActiveStats, title, w, h, x, y
  x += (w - 42) // 2
  y += (h - 20) // 2

  ; Do this so the window doesn't appear until edit text is selected
  Gui, Show, x%VirtualR% y%VirtualB%
  Send ^A

  Gui, Show, x%x% y%y% w42 h20, %WindowTitle%
return

GuiClose:  ; Pressing Alt+F4
GuiEscape: ; Pressing Esc
  Gui, Cancel
return
