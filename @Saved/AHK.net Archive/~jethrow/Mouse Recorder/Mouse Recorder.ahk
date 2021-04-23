; http://www.autohotkey.com/forum/viewtopic.php?t=64464

{ ; Auto-Execute
	#NoTrayIcon
	SetBatchLines, -1
	CoordMode, Mouse, Screen
	Gui, +ToolWindow +AlwaysOnTop
}
{ ; Command Line
	File = %1%
	if File {
		if FileExist(File) {
			FileRead, script, %File%
			GoSub, ButtonPlay
		}
		else,
			MsgBox, 262160, File Error, Cannot access File:`n%File%
		ExitApp
	}
	Menu, Tray, Icon	
}
{ ; GUI
	Menu, Playback, Add, Once, Playback
	Menu, Playback, Add, Loop, Playback
	Menu, Playback, Check, Once
	Playback := "Once"
	
	Menu, Sub, Add, Open, Open
	Menu, Sub, Add, Save, Save
	Menu, Sub, Add, Copy, Copy
	Menu, Sub, Add, Playback, :Playback

	Gui, Menu, Sub
	Gui, Add, Button, x6 y10 w50 h20 vRecord, Record
	Gui, Add, Button, x66 y10 w50 h20 vStop, Stop
	Gui, Add, Button, x126 y10 w50 h20 vPlay, Play
	Gui, Show, w191 h39, Mouse Recorder
	GuiControl("Stop=0,Play=0")
}
{ ; Hotkeys
	Loop, 3 {
		Hotkey, % "~" SubStr("LRM",A_Index,1) "Button", ClickHotkeys
		Hotkey, % "~" SubStr("LRM",A_Index,1) "Button Up", ClickHotkeys
	}
	Hotkey, ~WheelDown, ClickHotkeys
	Hotkey, ~WheelUp, ClickHotkeys	
	^+r:: GoSub, ButtonRecord
	^+s:: GoSub, ButtonStop
	^+p:: GoSub, ButtonPlay

	ClickHotkeys:
		if recording
			script .= SubStr(A_ThisHotkey, 2) (InStr(A_ThisHotkey, " Up")? "":" Down") "."
		return
}	

; Menu Options
Open: ; Open Script
{
	GoSub, ButtonStop
	FileSelectFile, OpenDir, 2, %A_ScriptDir%, Select File:, Script - Mouse Recorder (*.smr) 
	if Not ErrorLevel {
		FileRead, script, %OpenDir%
		GuiControl("Play=1")
	}
	return
}
Save: ; Save Script
{
	GoSub, ButtonStop
	FileSelectFile, SaveDir, S2, %A_ScriptDir%, Save As:, Script - Mouse Recorder (*.smr)
	if Not ErrorLevel {
		SaveDir := RegExReplace(SaveDir, "i)\.smr") ".smr"
		FileDelete, %SaveDir%
		FileAppend, %script%, %SaveDir%
	}
	return
}
Copy: ; Copy Script to clipboard
{
	if Not script
		return
	Clipboard := script
	ToolTip, Script Copied to Clipboard
	SetTimer, RemoveToolTip, 1000
	return
	RemoveToolTip:
		ToolTip
		return
}
Playback: ; Once vs Loop playback
{
	Playback := A_ThisMenuItem
	Menu, Playback, Check, %A_ThisMenuItem%
	Menu, Playback, UnCheck, % (A_ThisMenuItem="Once"? "Loop":"Once")
	return
}
GuiClose:
{
	ExitApp
}

; GUI Buttons
ButtonRecord: ; Start Recording
{
	StoredX := StoredY := ""
	GuiControl("Record=0,Stop=1,Play=0")
	Gui, Show, , Recording ...
	CoordMode, Mouse, Screen
	recording := true
	script := ""
	while recording {
		MouseGetPos, X, Y
		if (StoredX=X and StoredY=Y)
			script .= "+."
		else {
			script .= X "," Y "."
			StoredX:=X, StoredY:=Y
		}
		Sleep, 10
	}
	script := SubStr(script, 1, -1)
	return
}
ButtonStop: ; Stop Recording
{
	if playing {
		playing := false
		return
	}
	Gui, Show, , Mouse Recorder
	GuiControl("Record=1,Stop=0,Play=1")
	recording := false ; Stop Recording
	return
}
ButtonPlay: ; Playback
{
	Gui, Show, , Playing ...
	StoredX := StoredY := ""
	playing := true
	Loop, Parse, script, .
	{
		Sleep, -1
		if Not playing
			break
		else if RegExMatch(A_LoopField,"(\d+),(\d+)",p) {
			MouseMove, %p1%, %p2%, 0
			StoredX:=p1, StoredY:=p2
		} else if (A_LoopField = "+")
			MouseMove, %StoredX%, %StoredY%, 0
		else,
			Send, {%A_LoopField%}
	}
	if (Playback = "Loop") and Playing
		GoTo, ButtonPlay
	playing := false
	Gui, Show, , Mouse Recorder
	return
}

GuiControl(option) {
	Loop, Parse, option, `,
	{
		StringSplit, item, A_LoopField, =
		GuiControl, % (item2 ? "En":"Dis") "able", %item1%
	}
}
