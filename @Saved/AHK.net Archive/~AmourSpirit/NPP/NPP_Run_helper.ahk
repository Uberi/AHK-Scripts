; Notepad++ run helper
; By: Paul Moss
; March 2, 2011
; intent is to save the document the is curently open in Notepad++ and then
; run, debug or compile based on the options passed in.
; It is not possible to save and run a file using Notepad++ Run options but you can create a
; shortcut key to a run option that you have set up. This scripts makes it so the document is
; saved before it is run, that is if it needs saving
; Run Command to start your script only: AutoHotkey "YourPathToThisScript\NPP_Run_helper.ahk" "$(FULL_CURRENT_PATH)"
; Run command to start your script in debug mode: AutoHotkey "YourPathToThisScript\NPP_Run_helper.ahk" "$(FULL_CURRENT_PATH)" "debug"
; Run command to compile your script: AutoHotkey "YourPathToThisScript\NPP_Run_helper.ahk" "$(FULL_CURRENT_PATH)" "compile"
; Enter these commands in the run command of Notepad++ and assign them any shortcut keys you want
; PathToAHK is the path to AutoHotkey's executable and should be changed if it is different on your system
; PathToCompiler is the path to AutoHotkey's compiler and should be changed if it is different on your system

#NoEnv  ; Recommended for performance and compatibility w future AutoHotkey releases.
#SingleInstance Force

PathToAHK := "C:\Program Files\AutoHotkey\AutoHotkey.exe"
PathToCompiler := "C:\Program Files\AutoHotkey\Compiler\Ahk2exe.exe"

if (!1) {
	MsgBox Script not found. Run Helper script will now exit
Exit App
}

Opt2 = %2%

if (IsNppActive() = false) {
	; try to active the window and then save
	If (ActivateNpp()) {
		MsgBox Save Sent
	} else {
		MsgBox Unable to find Notpad++'nHelper Script will now close.
		ExitApp
	}
}

WinGetTitle, NppTitle, A

FoundPos := RegExMatch( NppTitle, "\*")

; The title Notepad++ window will start with * if the currently active file is dirty and needs saving
If(FoundPos = 1) {
	Sleep, 500
	SendInput, ^s
}

ScriptPath = %1%

If (Opt2 = "debug") {
	Run "%PathToAHK%" "/Debug" "%ScriptPath%"
} else if (Opt2 = "compile") {
	Run "%PathToCompiler%" "/In" "%ScriptPath%"
} else {
Run "%PathToAHK%" "%ScriptPath%"
}

ExitApp


IsNppActive() {
	Local retVal
	If WinActive("ahk_class Notepad++") {
		retVal := true
	} else {
		retVal := false
	}
return retVal
}
ActivateNpp() {
	if (IsNppActive() = false) {
		WinActivate, ahk_class Notepad++
		WinWaitActive, ahk_class Notepad++, , 5
		if ErrorLevel
		{
			;MsgBox, WinWait timed out.
			return false
		}
	}
	return true
}