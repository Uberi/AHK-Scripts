; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Return console output to a window.
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, off
Version=0.3
CommandLine=
Progressing=0

NumParm=%0%

if numparm=0
	goto PipeMore

Loop, %NumParm%
  Param%A_Index%:=%A_Index%

if (param1 = "/?"||param1 = "-h"||param1 = "--help")
	goto help

ExecuteProgram:
;All of the below garbage is ness to keep quotes in the command line
UserInput := DllCall("GetCommandLineA" , "Str")
if A_IsCompiled
{
	stringreplace, CommandLine, UserInput, %A_scriptname%,
	if errorlevel
	{
	stringreplace, ScriptName, A_ScriptName, .exe
	stringreplace, CommandLine, UserInput, %ScriptName%,
	}
	commandline:=commandline
}
else
{
loop, parse, UserInput, `"
{
	if a_index < 5 ;should drop the ahk and script name.
		continue
	if a_index = 5
	{
		CommandLine:=A_LoopField
		continue
	}
	if A_loopfield is space
		continue
	CommandLine=%CommandLine% "%A_LoopField%"%A_Space%
  }
}
CommandLine:=CommandLine

progress,1 M,%CommandLine%, Executing Command:,xmore Processing
settimer, MoveProgress,25
RunWait, %comspec% /c %CommandLine% >%A_Temp%\~cmdret.tmp,,UseErrorLevel Hide
progress, off
settimer, MoveProgress, off
SetWorkingDir %A_ScriptDir%
FileRead, PipeText, %A_Temp%\~cmdret.tmp
FileDelete %A_Temp%\~cmdret.tmp
if PipeText is space
{
	msgbox Error nothing retrieved.
	ExitApp
}
else
	gosub DisplayGUI

return ;Execute Program
Exit

PipeMore:
progress, 1 M, Waiting for Data, Getting Data from Pipe Buffer, Reading Data
settimer, MoveProgress,25
loop
{
	sleep 10 ;Seems to need to wait for data
	PipeBuffer:=StdIn()
    if PipeBuffer is space
        break
    PipeText:=PipeText . PipeBuffer
}
settimer, MoveProgress, Off
progress, off

if PipeText is space
{
	gosub help
	ExitApp
}
else
	gosub DisplayGUI

return ;From pipemore
Exit

DisplayGUI:
gui +resize 
gui, font, ,fixedsys
gui,margin,5,5
gui, add, edit, -Wrap readonly vEditControl multi,
gui, show,w675 h400,xmore
gui, show,w675 h400,xmore
GuiControl,,EditControl,%PipeText%
ControlClick, Edit1, xmore
return

#IfWinActive, xmore
^s::
FileSelectFile, FileName,S 16,%a_MyDocuments%, Select location to Save, *.txt
if errorlevel
	return
IfExist %FileName%
	FileDelete %FileName%
FileAppend, %PipeText%, %FileName%
return
#IFWinActive

GuiSize:
guicontrol,move, EditControl, % "w" A_GUIWidth-10 "h" A_GUIHeight-10
return ; guisize

GuiClose:
GuiEscape:
ExitApp
return ;End GUI

MoveProgress:
	if Progressing >100
		Progressing=1
	else
		Progressing+=1
	progress,%Progressing%
return

Help:
Msgbox,0,xmore Help,
(
Title: xmore
Author: Dave Earls
Version: %version%

Purpose: Capture console output and display in a sizable window.

Usage: xmore <console command> [command parameters]
or Usage: <console command> [command parameters] |xmore

Ctrl+S Save
)
ExitApp
return

StdIn(max_chars=0xfff)
{
    static hStdIn=-1
	bytesRead=
	
    if (hStdIn = -1)
    {
        hStdIn := DllCall("GetStdHandle", "UInt", -10) ; -10=STD_INPUT_HANDLE
        if ErrorLevel
            return 0
    }

    max_chars := VarSetCapacity(text, max_chars, 0)

    ret := DllCall("ReadFile"
        , "UInt", hStdIn        ; hFile
        ,  "Str", text          ; lpBuffer
        , "UInt", max_chars     ; nNumberOfBytesToRead
        , "UIntP", bytesRead    ; lpNumberOfBytesRead
        , "UInt", 0)            ; lpOverlapped

    return text
}