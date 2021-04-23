;
; AutoHotkey Version: 1.0.47.04
; Language:       English
; Platform:       WinXP, Win2003, WinVista
; Author:         Jeff Fahland
;
; Script Function:
;    Enables all buttons on the Snapstream Firefly Mini remote control. Includes
;    generic support for all applications and special support for: CyberLink
;    PowerDVD, Windows Media Player, Intervideo WinDVD, and Intervideo WinDVR.
;    Does not require any Beyond TV software on your system, and it will not
;    interfere with Beyond TV if you are using it.
;    
;    Compatible with Windows XP and newer, including 64-bit x64 editions.
;
;    Based on Autohotkey HID-Support package by Michael Simon:
;    http://www.autohotkey.net/~Micha/HIDsupport/Autohotkey.html
;
;    Setup Instructions:
;
;    1. Install AutoHotkey: http://www.autohotkey.com/
;
;    2. Download Autohotkey HID-Support:
;	   http://www.autohotkey.net/~Micha/HIDsupport/Autohotkey.html
;       Extract the files and run vcredist_x86.exe to install required files.
;
;    3. Put the FireflyMini.ahk script file in the same folder with the files
;       you just extracted and double-click it to run. The other Firefly Mini
;       buttons should now work. You can put a shortcut to this script in your
;       Startup folder to start with Windows.
;
;
;Path to AutohotkeyRemoteControl.dll
HomePath=AutohotkeyRemoteControl.dll
;HomePath=release\AutohotkeyRemoteControl.dll
;Load the dll
hModule := DllCall("LoadLibrary", "str", HomePath)  ; Avoids the need for DllCall() in 
OnMessage(0x00FF, "InputMsg")
DetectHiddenWindows, on
;SetTimer,UPDATEDSCRIPT,1000 

;Register my device
EditUsage = 136
EditUsagePage = 65468
Gui, Show, x0 y0 h0 w0, Autohotkey HID-Support
;HWND := WinActive("F:\myprg\Win\Autohotkeyremote\AutohotkeyRemoteControl\RemoteControl.ahk")
HWND := WinExist("Autohotkey HID-Support")
nRC := DllCall("AutohotkeyRemoteControl\RegisterDevice", INT, EditUsage, INT, EditUsagePage, INT, HWND, "Cdecl UInt")
if (errorlevel <> 0) || (nRC == -1)
{
	MsgBox RegisterDevice fehlgeschlagen. Errorcode: %errorlevel%
	goto cleanup
}
;Register another device
EditUsage = 1
EditUsagePage = 12
nRC := DllCall("AutohotkeyRemoteControl\RegisterDevice", INT, EditUsage, INT, EditUsagePage, INT, HWND, "Cdecl UInt")
Winhide, Autohotkey HID-Support
return

InputMsg(wParam, lParam, msg, hwnd)
{
  IfWinActive, ahk_class Streamzap.WM.D3D  ;Beyond TV
    return

  DataSize = 5000
	VarSetCapacity(RawData, %DataSize%)
   ;MsgBox eingetroffen %wParam% %lParam% %msg% %HWND%
	;Write something into the var, so the script won't be aborted :
  ;(g_script.ScriptError("This DllCall requires a prior VarSetCapacity. The program is now unstable and will exit.");)
	RawData = 1
  nRC := DllCall("AutohotkeyRemoteControl\GetWM_INPUTHIDData", UINT, wParam, UINT, lParam, "UINT *" , DataSize, "UINT", &RawData, "Cdecl UInt")    
  if (errorlevel <> 0) || (nRC == -1) 
  {
  	MsgBox GetWM_INPUTHIDData fehlgeschlagen. Errorcode: %errorlevel%
  	goto cleanup
  }     
 	loop, %DataSize%
  {
    ;Zahl := ExtractInteger(RawData, a_index-1,false,1)
    Zahl := NumGet(RawData, a_index-1,"UChar")
    Zahl := Dez2Hex(Zahl)    
    Vals = %Vals%%Zahl%     
  }  
  ;msgbox %vals%

  ;buttons not assigned by Windows
  if Vals = 0302
    button = ch_up
  if Vals = 0303
    button = ch_down
  if Vals = 0301
    button = last
  if Vals = 031b
    button = option
  if Vals = 030f
    button = menu
  if Vals = 0314
    button = guide

  ;the Firefly Mini app will handle these if running
  IfWinNotExist, Firefly Mini Options
  {
    if Vals = 031a
      button = close
    if Vals = 0310
      button = firefly
  }

  ;buttons not assigned by Windows 2003 and XP x64
  if A_OSVersion = WIN_2003
  {
    if Vals = 030b
      button = rec
    if Vals = 0304
      button = play
    if Vals = 030a
      button = pause
    if Vals = 0306
      button = rew
    if Vals = 0305
      button = fwd
  }

  if button =
    return

  if WinActive("ahk_class ATL:004AFC48") or WinActive("CyberLink PowerDVD")
  {
    PowerDVD7(button)
    return
  }
  if WinActive("ahk_class WMPlayerApp") or WinActive("ahk_class WMPTransition") or WinActive("ahk_class WMP Skin Host")
  {
    WindowsMediaPlayer(button)
    return
  }
  IfWinActive, ahk_class WinDVRClass
  {
    WinDVR3(button)
    return
  }
  IfWinActive, ahk_class WinDVDClass
  {
    WinDVD8(button)
    return
  }

  Default(button)
}
return

cleanup:
DllCall("FreeLibrary", "UInt", hModule)  ; It is best to unload the DLL after using it (or before the script exits).
ExitApp


UPDATEDSCRIPT: 
FileGetAttrib,attribs,%A_ScriptFullPath% 
IfInString,attribs,A 
{ 
	FileSetAttrib,-A,%A_ScriptFullPath% 
	SplashTextOn,,,Updated script, 
	Sleep,500 
	Reload 
} 
Return 

Dez2Hex(Number)
{
    format = %A_FormatInteger%    ; save original integer format
    SetFormat Integer, Hex        ; for converting bytes to hex
    Number += 0
    SetFormat Integer, %format%   ; restore original format
    StringTrimLeft, Number, Number, 2
    Stringlen := StrLen(Number)
    if Stringlen < 2
    Number = 0%Number%
    return Number
}


Default(button)
{
  if button = ch_up
  {
    SendInput {PgUp}
    return
  }
  if button = ch_down
  {
    SendInput {PgDn}
    return
  }
  if button = last
  {
    SendInput {Tab}
    return
  }
  if button = option
  {
    SendInput {AppsKey}
    return
  }
  if button = menu
  {
    SendInput {Alt}
    return
  }
  if button = guide
  {
    SendInput {LWin}
    return
  }
  if button = close
  {
    SendInput !{F4}
    return
  }
  if button = firefly
  {
    if WinExist("ahk_class ATL:004AFC48") or WinExist("CyberLink PowerDVD")
      WinActivate
    else
      Run, powerdvd, , UseErrorLevel
      if ErrorLevel = 0
      {
        WinWaitActive, ahk_class ATL:004AFC48, , 5
        if ErrorLevel = 0
          SendInput Z  ; fullscreen
      }
    return
  }
  if button = rec
  {
    return
  }
  if button = play
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = pause
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = rew
  {
    SendInput {WheelUp}
    return
  }
  if button = fwd
  {
    SendInput {WheelDown}
    return
  }
}

PowerDVD7(button)
{
  if button = ch_up
  {
    SendInput {PgDn}
    return
  }
  if button = ch_down
  {
    SendInput {PgUp}
    return
  }
  if button = option
  {
    SendInput U  ;subtitle
    return
  }
  if button = menu
  {
    SendInput J  ;dvd menu
    return
  }
  if button = guide
  {
    SendInput O  ;open
    return
  }
  if button = rec
  {
    SendInput C  ;capture
    return
  }
  if button = play
  {
    SendInput {Enter}
    return
  }
  if button = pause
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = rew
  {
    SendInput {WheelUp}
    return
  }
  if button = fwd
  {
    SendInput {WheelDown}
    return
  }

  Default(button)
}

WindowsMediaPlayer(button)
{
  if button = option
  {
    SendPlay ^+C  ;subtitle
    return
  }
  if button = menu
  {
    SendInput {AppsKey}DT  ;dvd menu
    return
  }
  if button = guide
  {
    SendInput {F11}{Tab}  ;fullscreen. tab sets focus on the video for dvd menu navigation
    return
  }
  if button = play
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = pause
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = rew
  {
    SendPlay ^+B  ;rewind
    return
  }
  if button = fwd
  {
    SendPlay ^+F  ;fast forward
    return
  }

  Default(button)
}

WinDVR3(button)
{
  if button = ch_up
  {
    SendInput {PgUp}
    return
  }
  if button = ch_down
  {
    SendInput {PgDn}
    return
  }
  if button = last
  {
    SendInput L  ;last channel
    return
  }
  if button = option
  {
    SendInput {AppsKey}
    return
  }
  if button = menu
  {
    SendInput I  ;video input source
    return
  }
  if button = guide
  {
    SendInput K  ;channel surf
    return
  }
  if button = rec
  {
    SendInput {Home}  ;record
    return
  }
  if button = play
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = pause
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = rew
  {
    SendInput R  ;instant replay
    return
  }
  if button = fwd
  {
    SendInput S  ;skip commercial
    return
  }

  Default(button)
}

WinDVD8(button)
{
  if button = option
  {
    SendInput S  ;subtitle
    return
  }
  if button = menu
  {
    SendInput ^T  ;dvd menu
    return
  }
  if button = guide
  {
    SendInput {AppsKey}
    return
  }
  if button = play
  {
    SendInput {Enter}
    return
  }
  if button = pause
  {
    SendInput {Media_Play_Pause}
    return
  }
  if button = rew
  {
    SendInput R
    return
  }
  if button = fwd
  {
    SendInput F
    return
  }

  Default(button)
}
