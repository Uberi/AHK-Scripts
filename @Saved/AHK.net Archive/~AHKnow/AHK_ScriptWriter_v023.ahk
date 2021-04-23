; Written by Thalon with parts from Skrommel (www.donationcoders.com/skrommel)
; Tested and parts written by AHKnow

;record={LCtrl}{F12}
;keydelay=10			;xxx Not used at the moment
;windelay=100		;xxx Not used at the moment

;Get informations for abort-condition
StringReplace, endrecord, record, }, %A_Space%Down}
StringLen, length, endrecord



#SingleInstance,Force
#Persistent
SetTitleMatchMode, Slow
SetBatchLines, -1
PID := DllCall("GetCurrentProcessId")
AutoTrim, Off
CoordMode, Mouse, Relative
modifiers =LCTRL,RCTRL,LALT,RALT,LSHIFT,RSHIFT,LWIN,RWIN,LButton,RButton,MButton,XButton1,XButton2
recording = 0
playing = 0
SendFlag = 0		;Flag for keyboard-recording
ControlSendFlag = 0	;Flag for special record-mode
Stop := ""
SelectedExe := ""
ExeHold := ""
Run = Run,
File := A_Temp . "\TempPlay.ahk"  
ScriptHold := ""
VersionMark := ASWv02
GoSub, InitStyle
GoSub, Traymenu
Return

Traymenu:

Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, Add, &Gui, ShowGUI1
Menu, Tray, Add, E&xit, ButtonExit
Menu, Tray, Add, &Record, ButtonRecord
Menu, Tray, Add, &Stop, ButtonStop!
Menu, Tray, Add, &Pause, Pause
Menu, Tray, Add, Play&back, ButtonPlay
Menu, Tray, Add, Re&load, Reload
Return

ShowGUI2: ; Creates little STOP button in upper left hand corner
Gui, font, s10 w700, Arial
Gui, Add, Button, w45 h20, Stop!
Gui, +AlwaysOnTop -SysMenu +Owner -Border
Gui, Color, EEAA99
Gui, +Lastfound ; Make the GUI window the last found window. 
WinSet, TransColor, EEAA99 
Gui, Show, x0 y0, ASWv02 
Return

ShowGUI1: ; GUI that is launched from Traymenu 
Gui, font, s9
Gui, Add, Button, x6 y149 w80 h39 +Center, Sh&rink
Gui, Add, Edit, x106 y27 w340 h20 , 
Gui, Add, Button, x456 y27 w50 h20 , &Browse
Gui, Add, GroupBox, x96 y7 w420 h50 , Initiate the following 'Run' line upon Record
Gui, Add, Button, x7 y208 w79 h40 , &Save
Gui, Add, Button, x6 y267 w80 h40 , E&xit
Gui, Add, Edit, x96 y57 w420 h250 vScriptEdit, 
Gui, Add, ComboBox, x-25 y-81 w41 h89 +Menu, ComboBox
Gui, font, s12
Gui, Add, Button, x6 y87 w80 h40 , &Play
Gui, font, s12, MS sans serif
Gui, Add, Button, x6 y8 w80 h59 , &Record
Gui, font, s10 w700, Arial
Gui, Add, Checkbox, x96 y316 w100 h20 vToolTipOption gToolTipShow, ToolTip
Gui, Show, x230 y182 h360 w528, AHK ScriptWriter v.023 Alpha


Menu, HelpMenu, Add, &About, Help
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar

Return


Help:

Msgbox, Nothing yet.  More detailed help will be in a later version.
Return

ButtonShrink:

Msgbox, Nothing yet.  Will be used in a later version to reduce code to the smallest amount.
Return

ButtonBrowse: ; This is so you can select an .exe and show its path

FileSelectFile, SelectedExe, 3,, Select .EXE to run, Executables (*.exe) 
Gosub ExeShowBrowseEdit1

ExeShowBrowseEdit1:
    IfExist, %SelectedExe%
    	GuiControl,,Edit1,%SelectedExe%
       
    Else
        MsgBox, You did not select anything or an .EXE file.
ExeHold = %SelectedExe%  
return

ExeRunBrowseEdit1: ; This is so you can run an .exe/application file before using the mouse on its window or menus

IfEqual, ExeHold,
{ 
return
}    
IfNotEqual, ExeHold,
{
Run, %ExeHold%
Sleep, 1000
GuiControl,,Edit1,
}   	
return
    

ButtonSave: ; This is so you can save your script

Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window. 
FileSelectFile, SelectedFileName, S16,, Save File, AutoHotkey Script (*.ahk) 
if SelectedFileName =  ; No file selected.
{ 
return
} 
Gosub SaveCurrentFile 
return 

SaveCurrentFile: ; Saves your AutoHotkey script

GuiControlGet, ScriptEdit
FileDelete, %SelectedFileName%.ahk 
FileAppend, %ScriptEdit%, %SelectedFileName%.ahk
return 

ButtonStop!: ; Stops the recording

Recording = 0
ToolTipOption = 0
SetTimer, Check_Modifier_Keys, Off
Gui, Destroy
;Send recorded data to clipboard
Clipboard = %keys%
ToolTip, 
Gosub, ShowGUI1
IfEqual, ExeHold, 
{ 
FileAppend, %keys%, %File%
}
Else
{
FileAppend, %Run%%ExeHold%`r`n%keys%, %File%
}
Sleep, 1000
FileRead, ScriptUP, %File%
GoSub, RemoveMark
GuiControl,,ScriptEdit, %ScriptUP%`r`nExit
Switch = %ScriptUP%`r`nExit
ScriptUP = %Switch% ; This is a kind of "backup" variable that may be used in a later version 
FileDelete, %File%
ScriptHold := ""
SelectedExe := ""
ExeHold := ""
LButtonDownTime =
Return 

RemoveMark: ; This kills the last line that is recorded when you press Stop in the little GUI

IfInString, ScriptUP, ASWv02
{
StringGetPos, lastline, ScriptUP, ASWv02, R ; Used to find unwanted line
CutMe := strlen(ScriptUP) - lastline
newlastline := lastline - 23
CutMeMore := strlen(ScriptUP) - newlastline
StringTrimRight, ScriptUP, ScriptUP, %CutMeMore%
return
}
Else
{
return
}

ButtonPlay: ; Play back script shown on GUI and Tooltip.

FileDelete, %File%
GuiControlGet, ScriptEdit ; Gets recorded data and any corrections you made before play
FileAppend, %ScriptEdit%, %File%
Sleep, 1000
Gui, Destroy
RunWait, %File%,, UseErrorLevel
if ErrorLevel = ERROR
{
RunWait, %A_ScriptDir%\AutoHotkey.exe "%File%",, UseErrorLevel
	If ErrorLevel = ERROR
	{
	Msgbox, AutoHotkey NOT found OR you may need to associate .AHK files with AutoHotkey.exe
	}
}
Sleep, 500
Gosub, ShowGUI1
FileRead, ScriptUP, %File%
GuiControl,,ScriptEdit, %ScriptUP%
FileDelete, %File%
return

ButtonRecord:   ; RECORD

GuiControl,,ScriptEdit,
ScriptHold := ""
keys =
Gui, Destroy
Gosub Record_On
Return


Record_On:

Gosub, ShowGUI2
Gosub ExeRunBrowseEdit1
CoordMode, Mouse , Screen

If recording = 0
{
Recording = 1
  ;Start recording if all modifier-keys are unpressed
	GetKeyState, state, LShift, P
  If state = d
  Loop
  {
    GetKeyState, state, LShift, P
    If state = U
      Break
  }
  GetKeyState, state, LCtrl, P
  If state = d
  Loop
  {
    GetKeyState, state, LCtrl, P
    If state = U
      Break
  }
  GetKeyState, state, LAlt, P
  If state = d
  Loop
  {
    GetKeyState, state, LAlt, P
    If state = U
      Break
  }
  GetKeyState, state, LWin, P
  If state = d
  Loop
  {
    GetKeyState, state, LWin, P
    If state = U
      Break
  }
  
  ;Start Recording
  recording = 1
  ToolTip, Recording... 
;  Process, Priority, %PID%, High	  ;Sets Priority to high, but may cause trouble on older and slower computers
  Gosub, Record_Loop
;  Process, Priority, %PID%, Normal	;Sets Priority to high
  
;  ToolTip, Recording finished
  
  ;Send recorded data to clipboard
	Clipboard = %keys%
  
  Sleep, 1000
  ToolTip,
  recording = 0
}
Else
{
	recording = 0
	SetTimer, Check_Modifier_Keys, Off
}
Return

Record_Loop:
SetTimer, Check_Modifier_Keys, 30
OldWinID =
keys =
Loop
{
  if recording = 0
  	break
	Input, key, M B C V I L1 T1, {BackSpace}{Space}{WheelDown}{WheelUp}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}{ENTER}{ESCAPE}{TAB}{DELETE}{INSERT}{UP}{DOWN}{LEFT}{RIGHT}{HOME}{END}{PGUP}{PGDN}{CapsLock}{ScrollLock}{NumLock}{APPSKEY}{SLEEP}{Numpad0}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadEnter}{NumpadMult}{NumpadDiv}{NumpadAdd}{NumpadSub}{NumpadDel}{NumpadIns}{NumpadClear}{NumpadUp}{NumpadDown}{NumpadLeft}{NumpadRight}{NumpadHome}{NumpadEnd}{NumpadPgUp}{NumpadPgDn}{BROWSER_BACK}{BROWSER_FORWARD}{BROWSER_REFRESH}{BROWSER_STOP}{BROWSER_SEARCH}{BROWSER_FAVORITES}{BROWSER_HOME}{VOLUME_MUTE}{VOLUME_DOWN}{VOLUME_UP}{MEDIA_NEXT}{MEDIA_PREV}{MEDIA_STOP}{MEDIA_PLAY_PAUSE}{LAUNCH_MAIL}{LAUNCH_MEDIA}{LAUNCH_APP1}{LAUNCH_APP2}{PRINTSCREEN}{CTRLBREAK}{PAUSE}
  endkey = %ErrorLevel%
	if (key = "" AND Errorlevel = "Timeout")   ;No key pressed
  	Continue
  
	GoSub, CheckWindow		;Check window-changes before key-record

  IfInString, endkey, EndKey:
  {
    StringTrimLeft, key, endkey, 7
    key = {%key%}
  }
  GoSub, Start_Send
	keys = %keys%%key%
  
  IfInString, keys, %endrecord%		;Finish-Shortcut was pressed
  {
		StringTrimRight, keys, keys, % length		;Remove Finish-Shortcut from record
		
		if (ControlSendFlag = 1)	;If "ControlSend" is recorded (due to pressing Finish-Shortcut)
		{
			StringRight, CheckTrimMode, keys, % 14 + StrLen(Controlname)
			if CheckTrimMode = ControlSend`, %Controlname%`,		;Check if Controlsend-Mode was initialized by Finish-Shortcut or if other letters where typed
				StringTrimRight, keys, keys, % 14 + StrLen(Controlname)		;Remove Controlsend-Command
			else		;Other letters typed --> Finish Controlsend-Command
				keys = %keys%`, %WinTitle%
		}
		else	;If "Send" is recorded (due to pressing Finish-Shortcut)
		{
			StringRight, CheckTrimMode, keys, % 5
			if CheckTrimMode = Send`,		;Check if Send-Mode was initialized by Finish-Shortcut or if other letters where typed
				StringTrimRight, keys, keys, 5		;Remove Send-Command
		}

			
    recording = 0
  }
  If recording = 0
  {
    SetTimer, Check_Modifier_Keys, Off
    Break
  }
}
Return

Check_Modifier_Keys:
Loop, Parse, modifiers, `,
{
  GetKeyState, state, %A_LoopField%, P
  If (state = "d" AND state%A_Index% = "")
  {
		GoSub, CheckWindow		;Check window-changes before key-record
		state%A_Index% = d
    if InStr(A_LoopField, "Button")
    {
	    GoSub, End_Send
;			keys = %keys%Sleep`, %A_TimeSincePriorHotkey%`n  ;Wofür war das?
			
			if (WinClass = "Progman" or WinClass = "WorkerW")		;Desktop
			{
;				CoordMode, Mouse, Screen
				MouseGetPos, XPos, YPos
				keys = %keys%
;				(
MouseMove, %XPos%,%YPos%, 5
;Loop,
;{
;MouseGetPos, , , WinID
WinGetClass, WinClass, ahk_id `%WinID`%
;	if WinClass != "Progman" and WinClass != "WorkerW"
;	{
;    Send, #m
;	   Break
;	}	
;	else
;	break
;}		
;)	
				CoordMode, Mouse, Screen
				GoSub, MouseClick
			}
			else	;"normal" Window
			{
				;Getting style for clearer information
				MouseGetPos, XPos, YPos, WinID, Controlname
				ControlGet, ControlStyle, Style, , %Controlname%, ahk_id %WinID%

				if InStr(Controlname, "Button")	;Normaler Button, Checkbox, Radio, 
				{
				 ControlStyle := (ControlStyle & 0xF)		;Es ist nur B0000 bis B1111 interessant
					IfEqual, WinClass, Shell_TrayWnd
					if WinTitle != ASWv02
					if WinTitle =
					{
				 	keys = %keys%ControlClick`, %Controlname%`, ahk_class Shell_TrayWnd`, `, Left`, 1`, %state%`n
					}
					
					if (ControlStyle = BS_PUSHBUTTON OR ControlStyle = BS_DEFPUSHBUTTON)
					if WinTitle != ASWv02
					if WinTitle != Start Menu
					if WinTitle != 
					IfNotEqual, WinClass, Shell_TrayWnd 
					{
						LButtonDownTime = %A_TickCount%
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`, %state%`n
	;					keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`,, `n
					}
					else if (ControlStyle = BS_3STATE OR ControlStyle = BS_AUTO3STATE)
					{
						SendMessage, BM_GETSTATE, 0, 0, %Controlname%, %WinTitle%
				  	state := ErrorLevel
				  	;Obey: The previous state has to be used for check...
				  	If (state & 0x3 = BST_UNCHECKED)	;State = CHECKED
							keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
						Else If (state & 0x3 = BST_CHECKED)		;State = INDETERMINATE
							keys = %keys%SendMessage`, %BM_SETCHECK%`, %BST_INDETERMINATE%`, 0`, %Controlname%, %WinTitle%`n
						Else If (state & 0x3 = BST_INDETERMINATE)		;State = UNCHECKED
							keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
					}
					else if (ControlStyle = BS_CHECKBOX OR ControlStyle = BS_AUTOCHECKBOX)
					{
						ControlGet, Checked?, Checked, , %Controlname%, %WinTitle%
						if Checked? = 1	;Beachte: Mausklick erfolgt erst nach Statuserfassung!
							keys = %keys%Control`, UnCheck`, `, %Controlname%`, %WinTitle%`n
						else
							keys = %keys%Control`, Check`, `, %Controlname%`, %WinTitle%`n
					}
					
					else if (ControlStyle = BS_RADIOBUTTON OR ControlStyle = BS_AUTORADIOBUTTON)
					if WinTitle != Start Menu
					if WinTitle != ASWv02
					IfNotEqual, WinClass, Shell_TrayWnd 
					{
						keys = %keys%ControlClick`, %Controlname%`, %WinTitle%`, `, Left`, 1`n
					}	
					else	;Unhandled Button-Type
					{
						LButtonDownTime = %A_TickCount%
						keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n
					}
				}
				else if InStr(Controlname, "Edit")		;Edit, Combobox (here only Edit-part)
				{
					GoSub, MouseClick
					keys = %keys%ControlFocus`, %Controlname%`, %WinTitle%`n
				}
/*
			
				else if InStr(Controlname, "ComboBox")	;DropDown, Combobox (hier nur Button zum droppen)
				{
					
				}
				else if InStr(Controlname, "Listbox")	;Listbox
				{
					
				}
				else if InStr(Controlname, "Hotkey")	;Hotkey-Control
				{
					History = %History%ControlFocus`, %Controlname%`, %WinTitle%`n
				}
				else if InStr(Controlname, "Trackbar")	;Slider
				{
					
				}
				
*/
				else	;Klick somewhere in the window or unknown control
				{
					GoSub, MouseClick
				}
			}

 
    }
    Else
    {
			GoSub, Start_Send
			keys = %keys%{%A_LoopField% Down}
		}
  }
  
  GetKeyState, state, %A_LoopField%, P
  If (state = "u" AND state%A_Index% = "d") 
  {
;		GoSub, CheckWindow		;Check window-changes before key-record
		
    if InStr(A_LoopField, "Button")
    {
      GoSub, End_Send
			
			if LButtonDownTime !=
			{
				LButtonDownDuration := A_TickCount - LButtonDownTime
;	 			MouseGetPos, XPos, YPos
				keys = %keys%Sleep`, %LButtonDownDuration%`nMouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n
				LButtonDownTime =
			}
    }
    Else
    {
			GoSub, Start_Send
			keys = %keys%{%A_LoopField% Up}
		}
    state%A_Index%=
  }
}
If keys = {LShift Up}
  keys =
If keys = {LCtrl Up}
  keys =
If keys = {LAlt Up}
  keys =
If keys = {LWin Up}
  keys =
StringRight, ScriptHold, keys, 500 ; Number of characters being displayed by ToolTip.  Too small (like 50) = Problems
Gosub, ToolTipShow
Return

ToolTipShow:
Gui, Submit, NoHide
IfEqual, ToolTipOption, 1
{
ToolTip, %ScriptHold% ; DISPLAYS ToolTip contents on screen
return
}
Else
Return

MouseClick:		;Saves a mouseclick (unknown controls or for controls where position is needed (Edit-Control for example)
LButtonDownTime = %A_TickCount%
MouseGetPos, XPos, YPos
keys = %keys%MouseClick`, Left`, %XPos%`, %YPos%`, `, `, %state%`n  ; state comes from getkeystate above
return


/*
TRAYRECORD:
WinActivate, ahk_id %currentid%
WinWaitActive, ahk_id %currentid%, , 2
Gosub, Record_On		
Return
*/


CheckWindow:

WinGet, WinID, ID, A

If WinID <> %OldWinID%
{
	GoSub, End_Send
	

	WinGetClass, WinClass, ahk_id %WinID%
	WinGetTitle, WinTitle, ahk_id %WinID%

	if (WinClass = "Progman" OR WinClass = "WorkerW")
	{
		keys = %keys%{LWIN Down}m{LWIN UP}
		Gosub, MouseClick
		return
	}
	else 

	if WinTitle != Start Menu	; Prevents WinWait, etc... from being added to this window
	if WinTitle != ASWv02 	; Prevents WinWait, etc... from being added to this window
	if WinTitle != 			; Adds WinWait, WinActivate, and WinWaitActive commands to found Window Title.
	{
			keys = %keys%WinWait`, %WinTitle%`nWinActivate`, %WinTitle%`nWinWaitActive`, %WinTitle%`n
	}
;
; WinWait, WinActivate, and WinWaitActive better than just WinActivate and WinWaitActive, so changed.
;

  OldWinID = %WinID%
  
}
return

Start_Send:
if SendFlag = 0		;If "Send" was not already added it is added just before the keypress...
{
	ControlGetFocus, Controlname, ahk_id %WinID%
	if InStr(Controlname, "Edit")		;If control is of Edit-Type use "ControlSend" instead of "Send"
	{
		ControlSendFlag = 1
		keys = %keys%ControlSend`, %Controlname%`,
	}
	else
		keys = %keys%Send`,
	SendFlag = 1
}
return

End_Send:
if ControlSendFlag = 1
{
	SendFlag = 0
	ControlSendFlag = 0
	keys = %keys%`, %WinTitle%`n
	Controlname = 	;Delete Last Controlname on Windowchange
}
else if SendFlag = 1
{
	SendFlag = 0
	keys = %keys%`n		
}
return

;Set constants
InitStyle:
;Borderstyles
BS_PUSHBUTTON = 0x0
BS_DEFPUSHBUTTON = 0x1
BS_CHECKBOX = 0x2
BS_AUTOCHECKBOX = 0x3
BS_RADIOBUTTON = 0x4 
BS_3STATE = 0x5
BS_AUTO3STATE = 0x6
BS_GROUPBOX = 0x7
BS_AUTORADIOBUTTON = 0x9
;BS_PUSHLIKE = 0x1000

;Constants for retreive/set 3rd state of a checkbox
BM_GETSTATE = 0xF2
BST_UNCHECKED = 0x0
BST_CHECKED = 0x1
BST_INDETERMINATE = 0x2
BM_SETCHECK = 0xF1
return

Reload:
Reload

Pause::Pause
Reload

Esc::ExitApp

ButtonExit:
ExitApp

GuiClose:
ExitApp