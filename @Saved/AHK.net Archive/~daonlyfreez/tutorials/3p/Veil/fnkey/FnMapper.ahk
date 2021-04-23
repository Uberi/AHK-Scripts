;
; AutoHotkey Version: 1.x
; Language.........: English
; Platform.........: NT/XP/Vista
; Author...........: Veil, Leon
; Full guide.......: http://brrp.mine.nu/fnkey/
;
; Script Function..: Remapping the Fn key
;
; Based on.........: DLLCall: Support for Human Interface devices
; By...............: Micha
; URL..............: http://www.autohotkey.com/forum/viewtopic.php?t=6367
;
; Use..............: Spread the word! Just be sure to credit the writer of the dll
;										 file and the	original config, and the authors of this file.
;

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
;#NoTrayIcon


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; DLL registration and readout of keys
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set screen title, to set the HWND
Gui, Show, x0 y0 h0 w0, FnMapper

; Variable for the modifier key, define it here, just to be sure
fnPressed := 0

; Set the homepath to the relevant dll file
HomePath=AutohotkeyRemoteControl.dll

; Load the dll
hModule := DllCall("LoadLibrary", "str", HomePath)

; On specific message from the dll, goto this function
OnMessage(0x00FF, "InputMsg")

; Register at the dll in order to receive events
EditUsage := 1
EditUsagePage := 12
HWND := WinExist("FnMapper")
nRC := DllCall("AutohotkeyRemoteControl\RegisterDevice", INT, EditUsage, INT, EditUsagePage, INT, HWND, "Cdecl UInt")
WinHide, FnMapper


; This function is called, when a WM_INPUT-msg from a device is received
InputMsg(wParam, lParam, msg, hwnd) 
{
  DeviceNr = -1
  nRC := DllCall("AutohotkeyRemoteControl\GetWM_INPUTDataType", UINT, wParam, UINT, lParam, "INT *", DeviceNr, "Cdecl UInt")
  if (errorlevel <> 0) || (nRC == 0xFFFFFFFF) 
  {
  	MsgBox GetWM_INPUTHIDData fehlgeschlagen. Errorcode: %errorlevel%
  	goto cleanup
  }
  ;Tooltip, %DeviceNr%
  ifequal, nRC, 2
  {
    ProcessHIDData(wParam, lParam)
  }
  else 
  {
  	MsgBox, Error - no HID data
  }
}
Return

ProcessHIDData(wParam, lParam)
{
	; Make sure this variable retains its value outside this function
	global fnPressed
	
  DataSize = 5000
	VarSetCapacity(RawData, %DataSize%, 0)
	RawData = 1
  nHandle := DllCall("AutohotkeyRemoteControl\GetWM_INPUTHIDData", UINT, wParam, UINT, lParam, "UINT *" , DataSize, "UINT", &RawData, "Cdecl UInt")

  ; Get the ID of the device
  ; Use the line below to check where an event was sent from, when using this code for a new HID device
  ; DeviceNumber := DllCall("AutohotkeyRemoteControl\GetNumberFromHandle", UINT, nHandle, "Cdecl UInt") 

  ;FirstValue := NumGet(RawData, 0,"UChar") ; something to do with the bits, not really relevant here
  KeyStatus := NumGet(RawData, 1, "UChar")
  
  ; MsgBox, Keystatus: %KeyStatus%
  
  ; Filter the correct bit, so that it corresponds to the key in question
  ; Add another Transform for a new key
  
  ; Filter bit 5 (Fn key)
  Transform, FnValue, BitAnd, 16, KeyStatus
  
  ; Filter bit 4 (Eject key)
  Transform, EjectValue, BitAnd, 8, KeyStatus
   
  if (FnValue = 16) {
  	; Fn is pressed
		fnPressed := 1
  } else {
    ; Fn is released
		fnPressed := 0
  }
  
  if (EjectValue = 8) {
  	; Eject is pressed
  	; Set timeout of 1 second to prevent accidental keypresses
		SetTimer, ejectDrive, 1000
  } else {
  	; If the Eject button is let go within the second it will disable the timer and skip the ejectDrive function
		SetTimer, ejectDrive, Off
  }
  
} ; END: ProcessHIDData

; If there was an error retrieving the HID data, cleanup
cleanup:
DllCall("FreeLibrary", "UInt", hModule)  ; It is best to unload the DLL after using it (or before the script exits).
ExitApp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Eject, with a delay, Apple style
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ejectDrive:
	startTime := A_TickCount
	Drive, Eject
	; If the command completed quickly, the tray was probably already ejected.
	; In that case, retract it:
	if A_TickCount - startTime < 1000 ; Adjust this time if needed.
	    Drive, Eject,, 1
	Return
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Various
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Fn + Backspace = Delete
;
$Backspace::hotkeyBS()

hotkeyBS()
{
	global fnPressed
	if (fnPressed = 1) {
		Send {Delete}
	} else {
		Send {Backspace}
	}
}
Return