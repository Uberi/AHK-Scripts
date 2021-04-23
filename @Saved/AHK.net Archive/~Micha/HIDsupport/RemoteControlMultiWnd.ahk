;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoHotkey script.
;
; PLEASE DO NOT DELETE THE FOLLOWING LINES

;Path to AutohotkeyRemoteControl.dll
HomePath=AutohotkeyRemoteControl.dll
;HomePath=release\AutohotkeyRemoteControl.dll
;Load the dll
hModule := DllCall("LoadLibrary", "str", HomePath)  ; Avoids the need for DllCall() in 
OnMessage(0x00FF, "InputMsg")
DetectHiddenWindows, on
;SetTimer,UPDATEDSCRIPT,1000 
ReadIni()
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
  ifequal, Vals, 040100, gosub Homepg
  ifequal, Vals, 048000, gosub RED  
  ifequal, Vals, 040800, gosub GREEN
  ifequal, Vals, 041000, gosub GELB
  ifequal, Vals, 042000, gosub BLAU
  ifequal, Vals, 040200, gosub LineTV
  ifequal, Vals, 03800000, gosub Record
  ifequal, Vals, 03040000, gosub Radio_
  ifequal, Vals, 040010, gosub SAP
  ifequal, Vals, 040020, gosub TELETEXT
  ifequal, Vals, 040040, gosub LastCH
  ifequal, Vals, 040008, gosub Subtitle
  ifequal, Vals, 040002, gosub Language
  ifequal, Vals, 010001, gosub Angle
  ifequal, Vals, 03000400, gosub BACK
  ifequal, Vals, 03000002, gosub InfoEPG
  ifequal, Vals, 040004, gosub DVDMENUE
  ifequal, Vals, 03000100, gosub Chanelplus
  ifequal, Vals, 03000200, gosub Chanelmin
  ifequal, Vals, 03000040, gosub Play
  ifequal, Vals, 03000004, gosub REV
  ifequal, Vals, 03000080, gosub PAUSE_
  ifequal, Vals, 03000008, gosub FWD
  ifequal, Vals, 03020000, gosub slower
  ifequal, Vals, 03001000, gosub Stop
  ifequal, Vals, 03010000, gosub faster
  
}
return

Homepg:
DoKey("Homepage")
return

RED:
DoKey("RedButton")
return

GREEN:
DoKey("GreenButton")
return

GELB:
Msgbox Gelbe taste
return

BLAU:
Msgbox Blaue taste
SendDVDKey("z")
return

LineTV:
Msgbox LineTV
return

Record:
Msgbox Record
return

Radio_:
Msgbox Radio
return

SAP:
Msgbox SAP
return

TELETEXT:
Msgbox TELETXT
return

LastCH:
Msgbox LastCH
return

Subtitle:
Msgbox subtitle
return

Language:
Msgbox Language
return

Angle:
Msgbox Angle
return

BACK:
Msgbox back
return

InfoEPG:
Msgbox InfoEPG
return

DVDMENUE: 
SendDVDKey("^m")
return

Chanelmin:
Msgbox Chanel minus
return

Chanelplus:
Msgbox Chanel Plus
return

Play:
SendDVDKey("{ENTER}")
return

REV:
SendDVDKey("r")
return

PAUSE_:
SendDVDKey("{SPACE}")
return

FWD:
SendDVDKey("f")
return

slower:
SendDVDKey("B{up 9}{enter}")
WinWait, Video Center
Mouseclick, left, 400, 40
Sleep, 100
ControlClick, Button2
Sleep, 300
ControlClick, Button7
return

Stop:
SendDVDKey("{END}")
return

faster:
SendDVDKey("B{up 9}{enter}")
WinWait, Video Center
Mouseclick, left, 400, 40
Sleep, 100
ControlClick, Button3
Sleep, 300
ControlClick, Button7
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

;Search the array for the remotekey
DoKey(Remotekey)
{
  global
  ;Get active Title
  WinGetActiveTitle, ActTitle  
  loop, %KeyArray0%
  {
    KeyofArray := KeyArray%a_index%
    ;if key is the wrong key, try the next entry    
    if KeyofArray != %Remotekey%
      continue
    TitleOfArray := AppArray%a_index%    
    IfnotInString, ActTitle, %TitleOfArray%    
     continue     
    ;We have found the correct key and the correct application. Send the Key
    Key2Send := SendArray%a_index%
    Send, %Key2Send%
    return 
  }
}

SendDVDKey(Key)
{
  IfWinNotExist , InterVideo WinDVD 7
  {
    return 
  }
  Winactivate, InterVideo WinDVD 7
  Send, %Key%
}


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

ReadIni()
{
  global
  IfNotExist, .\RemoteControlMultiWnd.ini
  {
    MsgBox, Inifile RemoteControlMultiWnd.ini not found in current folder
    ExitApp , 2
  }
  IniRead, Counter, .\RemoteControlMultiWnd.ini, RemoteControl, Entrycount
  KeyArray0 := Counter
  AppArray0 := Counter
  SendArray0 := Counter
  loop, %Counter%
  {
    IniRead, IniLine, .\RemoteControlMultiWnd.ini, RemoteControl, %a_index%
    StringSplit, OutputArray, IniLine , `;
    KeyArray%a_index% := OutputArray1
    AppArray%a_index% := OutputArray2
    SendArray%a_index% := OutputArray3
  }
} 
