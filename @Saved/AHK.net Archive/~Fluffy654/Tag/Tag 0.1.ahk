;*******************************************************************************
;				Information					
;*******************************************************************************
;AutoHotkey Version: 	1.0.47.06
;Language: 		English							
;Platform: 		XP/Vista						
;Author: 		Fluffy654 <rupert654@gmail.com>				
;Script Function:	Tag Window Manager	
;*******************************************************************************
;				Settings & Variables					
;*******************************************************************************
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
OnExit, ScriptExit
HiddenList :=

Loop, 4
	{
	Group%A_Index% :=
	Hotkey, ^%A_Index%, Show
	Gui, Add, ListBox, AltSubmit Multi y10 r10 w200 vListBox%A_Index%
	Gui, Add, Button, w200 gAdd, Add to Tag %A_Index%
	Gui, Add, Button, w200 gMove, Move to Tag %A_Index%
	Gui, Add, Button, w200 gDelete, Delete Group %A_Index% 
	}
Gui, Add, ListBox, AltSubmit Multi y10 r10 w200 vListBox5
Gui, Add, Button, w200 gMove, Move to Tag 5

EmptyMem()
return

F12::Reload

^5::Display()

Show:
	StringTrimLeft, N, A_ThisHotKey, 1
	Loop, 4
		IfEqual, A_Index, %N%
			Loop, Parse, Group%N%, |
				{
				StringReplace, HiddenList, HiddenList, %A_LoopField%|
				WinShow, ahk_id %A_Loopfield%
				}
		Else
			Loop, Parse, Group%A_Index%, |
				{
				HiddenList .= A_LoopField "|"
				WinHide, ahk_id %A_Loopfield%
				}
	return

Add:
	StringTrimLeft, N, A_GuiControl, 11				
	Gui, Submit
	Loop, 5								
		{
		GroupN := A_Index					
		Loop, Parse, ListBox%A_Index%, |
			{
			Position := A_LoopField				
			Loop, Parse, Group%GroupN%, |			
				{
				ID := A_LoopField
				IfEqual, Position, %A_Index%
					{
					StringReplace, Group%N%, Group%N%, %ID%|
					Group%N% .= ID "|"
					}
				}
			}
		}
	Display()
	return

Move:
	StringTrimLeft, N, A_GuiControl, 12				
	Gui, Submit							
	Loop, 5								
		{
		GroupN := A_Index
		Deleted := 0
		Loop, Parse, ListBox%A_Index%, |
			{
			Position := A_LoopField
			Loop, Parse, Group%GroupN%, |
				{
				RealIndex := A_Index + Deleted
				IfEqual, GroupN, 5, SetEnv, RealIndex, %A_Index%
				ID := A_LoopField
				IfEqual, Position, %RealIndex%
					{
					Deleted++
					Loop, 4
						{
						IfEqual, ListBox%A_Index%,, Continue
						StringReplace, Group%A_Index%, Group%A_Index%, %ID%|
						}
					IfNotInString, Group%N%, %ID%
						Group%N% .= ID "|"
					}
				}
			}
		Deleted := 0
		}
	Display()
	return

Delete:
	StringTrimLeft, N, A_GuiControl, 13
	Group%N% :=
	Display()
	return

ScriptExit:
	Loop, Parse, Group5, |
			WinShow, ahk_id %A_Loopfield%
	ExitApp

EmptyMem(PID="AHK Rocks")
	{
	pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    	h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
   	DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    	DllCall("CloseHandle", "Int", h)
	}

Display()
	{
	Global
	GroupTitle5 := "|"
	Group5 :=
	WinGet, Group5A, List
	Loop, %Group5A%
		Group5 .= Group5A%A_Index% "|"
	Loop, Parse, HiddenList, |
		Group5 .= A_LoopField "|"
	DetectHiddenWindows, On
	Loop, 4
		{
		Index := A_Index
		GroupTitle%Index% := "|"
		Loop, Parse, Group%A_Index%, |
			IfNotInString, Group5, %A_LoopField%, StringReplace, Group%Index%, Group%Index%, %A_LoopField%|
			Else
				{
				WinGetTitle, Title, ahk_id %A_LoopField%
				GroupTitle%Index% .= Title "|"
				}
		GuiControl,, ListBox%A_Index%, % GroupTitle%Index%
		GroupTitle%Index% := "|"
		}
	Loop, Parse, Group5, |
		{
		WinGetTitle, Title, ahk_id %A_LoopField%
		If Title not in ,Program Manager,%A_ScriptName%,%A_UserName%,Start Menu,Windows Task Manager
			GroupTitle5 .= Title "|"
		Else IfEqual, A_LoopField
			continue
		Else
			StringReplace, Group5, Group5, %A_LoopField%|
		}
	DetectHiddenWindows, Off
	GuiControl,, ListBox5, % GroupTitle5
	Gui, Show
	Loop 5
		PostMessage, 0x185, 0, -1, ListBox%A_Index%, %A_ScriptName%
	Loop, Parse, Group5, |
			{
			StringReplace, HiddenList, HiddenList, %A_LoopField%|
			WinShow, ahk_id %A_Loopfield%
			}
	WinActivate, Gui
	}