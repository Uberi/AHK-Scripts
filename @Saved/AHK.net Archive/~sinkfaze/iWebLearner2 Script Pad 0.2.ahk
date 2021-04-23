;
; AutoHotkey Version: 1.0.48.05
; Language:       English
; Platform:       Win9x/NT
; Author:         sinkfaze <privateuniverse@whoever.com>
;
; Script Function:
;
; This is AHK web recorder script recording pad or 'sandbox', where code can be
; written in, tested and output to an ahk script. This is an early stage beta
; to test the base functionality of the GUI itself, pending approval functionality
; will be expanded upon for integration with the AHK web recorder itself.
;
; The default mode utilizes numerous message boxes to guide a new user through
; the process of creating a script. 'Append to Bottom' avoids more of the prompts
; by automatically appending the requested function to the bottom of the script
; on the 'pad'. 'Clipboard only' mode will also avoid more prompts while sending
; the requested function to the clipboard so the user can decide for themselves
; where to place it in the script.
;
; The 'Initialize' and 'Terminate' buttons will automatically output the
; appropriate code to initialize/uninitialize COM and obtain/release the pointer.
; The 'Initialize' button will also give an additional option to cycle through the
; existing Internet Explorer pages to select the one to initialize.
;
; The 'Test' button utilizes Lexikos' script for dynamic code execution through a
; pipe <http://www.autohotkey.com/forum/topic25867.html> so the user can test
; their code before writing it to a file.
;
; The 'Output' button gives the user the option of writing the code in the pad
; to an AHK file automatically.  It will prompt the user for a script name and
; create the script with that name or as 'Sample.ahk' by default.
/*
Here is a sample test script to execute from the 'pad'.

COM_CoInitialize()
pwb:=iWeb_getWin("How to: Run Dynamic Script... Through a Pipe!")
; above page is at http://www.autohotkey.com/forum/topic25867.html
iWeb_clickText(pwb,"Scripts & Functions")
iWeb_Complete(pwb)
MsgBox, Step 1 Complete!
iWeb_clickDomObj(pwb,"75") ; may need to adjust number to click 'AutoHotkey Community Forum Index' link
iWeb_Complete(pwb)
MsgBox, Step 2 Complete!
iWeb_clickHref(pwb,"http://www.autohotkey.com/forum/viewforum.php?f=1")
iWeb_Complete(pwb)
MsgBox, Step 3 Complete!
COM_Release(pwb)
COM_CoUninitialize()
return 
*/

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Include C:\AutoHotKey\Lib\COM.ahk
#Include C:\AutoHotKey\Lib\iWeb.ahk

Process, Exist, iexplore.exe
if ErrorLevel
	wlist:=IEGetList()
Gui, Add, DropDownList, x10 y10 w250 r3 vWindow, |Manually add window|%wlist%
Gui, Add, Button, xp+255 yp-1 gListUpdate, Refresh
Gui, Add, Edit, x10 yp+27 w350 r11 vScript,
Gui, Add, Button, xp+195 yp+155 w70 h22 gInit, Initialize
Gui, Add, Button, xp+85 wp hp gTerm, Terminate
Gui, Add, Button, xp-85 yp+25 w70 hp gTest, Test
Gui, Add, Button, xp+85 wp hp gOut2File, Output
Gui, Add, Checkbox, x10 yp-24 gClip vClip, Clipboard Only
Gui, Add, Checkbox, yp+18 gBottom vBottom, Append to Bottom 
Gui, Show, AutoSize Center, iWebBrowser2 Script Pad
return

ListUpdate:

Process, Exist, iexplore.exe
if !ErrorLevel {
	MsgBox, 48, Warning
	 , % "You currently have no Internet Explorer sessions running.`n"
	 . "The list cannot be updated without an Internet Explorer session."
	return
}
wlist:=IEGetList()
GuiControl, , Window, ||Manually add window|%wlist%
return

Init:

Gui, Submit, NoHide
if !Window
	MsgBox, 48, Initialization Warning, Please select a window to initialize and press Initialize.
else if !InStr(Script,"COM_CoInitialize()") {
	MsgBox, 36, Script Initialization
	 ,% "COM_CoInitialize()`npwb:=iWeb_getWin("
	 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n`n"
	 . "Is this the correct initialization?"
	IfMsgBox No
		MsgBox, , Re-Select, Please re-select a window and retry the command.
	else if Clip
		Clipboard:="COM_CoInitialize()`r`npwb:=iWeb_getWin("
		 . ((Window <> "Manually add window") ? """" Window """" : "") ")`r`n"
	else if Bottom
		GuiControl, Text, Script, % Script . "COM_CoInitialize()`npwb:=iWeb_getWin("
		 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n"
	else {
		MsgBox, 33, Initialization
		 , % "The initialization will be placed at the bottom of the script by default.`n"
		 . "Press Cancel if you would like to copy the initialization to the Clipboard instead."
		IfMsgBox Cancel
			Clipboard:="COM_CoInitialize()`r`npwb:=iWeb_getWin("
		 . ((Window <> "Manually add window") ? """" Window """" : "") ")`r`n"
		else
			GuiControl, Text, Script, % Script "COM_CoInitialize()`npwb:=iWeb_getWin("
			 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n"
	}
} else {
	MsgBox, 36, Initialization Warning, % "Your script already contains an initialization sequence.`n"
	 . "Would you like to add another one?"
	IfMsgBox No
		return
	MsgBox, 36, Script Initialization
	 ,% "COM_CoInitialize()`npwb:=iWeb_getWin("
	 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n`n"
	 . "Is this the correct initialization?"
	IfMsgBox No
		MsgBox, , Re-Select, Please re-select a window and retry the command.
	else if Clip
		Clipboard:="COM_CoInitialize()`r`npwb:=iWeb_getWin("
		 . ((Window <> "Manually add window") ? """" Window """" : "") ")`r`n"
	else if Bottom
		GuiControl, Text, Script, % Script . "COM_CoInitialize()`npwb:=iWeb_getWin("
		 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n"
	else {
		MsgBox, 33, Initialization
		 , % "The initialization will be placed at the bottom of the script by default.`n"
		 . "Press Cancel if you would like to copy the initialization to the Clipboard instead."
		IfMsgBox Cancel
			Clipboard:="COM_CoInitialize()`r`npwb:=iWeb_getWin("
			 . ((Window <> "Manually add window") ? """" Window """" : "") ")`r`n"
		else
			GuiControl, Text, Script, % Script "COM_CoInitialize()`npwb:=iWeb_getWin("
			 . ((Window <> "Manually add window") ? """" Window """" : "") ")`n"
	}
}
return

Term: 

Gui, Submit, NoHide
if InStr(Script,"COM_CoUninitialize()") {
	MsgBox, 52, Warning
	 , % "Your recorded script already contains a termination sequence.`n"
	 . "Are you sure you wish to add another?"
	IfMsgBox No
		return
	if Clip
		Clipboard=COM_Release(pwb)`r`nCOM_CoUninitialize()`r`n
	else if Bottom
		GuiControl, Text, Script, %Script%COM_Release(pwb)`nCOM_CoUninitialize()`n
	else {
		MsgBox, 33, Initialization
		 , % "The termination will be placed at the bottom of the script by default.`n"
		 . "Press Cancel if you would like to copy the initialization to the Clipboard instead."
				IfMsgBox Cancel
					Clipboard=COM_Release(pwb)`r`nCOM_CoUninitialize()`r`n
				else
					GuiControl, Text, Script, %Script%COM_Release(pwb)`nCOM_CoUninitialize()`n
	}
	return
}
else if Clip
	Clipboard=COM_Release(pwb)`r`nCOM_CoUninitialize()`r`n
else if Bottom
	GuiControl, Text, Script, %Script%COM_Release(pwb)`nCOM_CoUninitialize()`n
else {
	MsgBox, 33, Initialization
	 , % "The termination will be placed at the bottom of the script by default.`n"
	 . "Press Cancel if you would like to copy the initialization to the Clipboard instead."
			IfMsgBox Cancel
				Clipboard=COM_Release(pwb)`r`nCOM_CoUninitialize()`r`n
			else
				GuiControl, Text, Script, %Script%COM_Release(pwb)`nCOM_CoUninitialize()`n
}
return

Test:
; credit Lexikos, http://www.autohotkey.com/forum/topic25867.html

MsgBox, 49, Warning
 , % "You are about to dynamically execute your recorded script!`n"
 . "Please make sure the page you intend to operate on is open and ready,`n"
 . "press 'Cancel' to if you do not wish to proceed."
IfMsgBox Cancel
	return
Gui, Submit, NoHide
;InputBox, Script, Script, Enter a line of script to execute.,,, 120,,,,, MsgBox :D

pipe_name := "testpipe"

pipe_ga := CreateNamedPipe(pipe_name, 2)
pipe    := CreateNamedPipe(pipe_name, 2)
if (pipe=-1 or pipe_ga=-1) {
    MsgBox CreateNamedPipe failed.
    ExitApp
}

Run, %A_AhkPath% "\\.\pipe\%pipe_name%"

DllCall("ConnectNamedPipe","uint",pipe_ga,"uint",0)
DllCall("CloseHandle","uint",pipe_ga)
DllCall("ConnectNamedPipe","uint",pipe,"uint",0)

Script := chr(239) chr(187) chr(191) Script

if !DllCall("WriteFile","uint",pipe,"str",Script,"uint",StrLen(Script)+1,"uint*",0,"uint",0)
    MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

DllCall("CloseHandle","uint",pipe)
return

Out2File:

Gui, Submit, NoHide
InputBox, sName, Script Name
 , % "Please enter a name for your script.`n"
 . "If no name is selected the script will be named:`n"
 . """Sample.ahk"""
 , , 300, 175
If ErrorLevel
	return
else if !ErrorLevel && !sName
	sName=Sample
FileAppend
 ,`#NoEnv`nSendMode Input`nSetWorkingDir `%A_ScriptDir`%`n`n%Script%
 , %sName%.ahk
return 

GuiClose:
MsgBox, 52, Warning
 , % "If you close the script pad your data will be lost`n"
 . "Are you sure you wish to close the script pad?"
IfMsgBox Yes
	ExitApp
return

Clip:

Gui, Submit, NoHide
GuiControl, , Bottom, 0 
return

Bottom:

Gui, Submit, NoHide
GuiControl, , Clip, 0
return

CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
    return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}

IEGetList() { ; credit Sean, http://www.autohotkey.com/forum/topic19255.html

COM_Init()
;COM_Error(0)
psh :=   COM_CreateObject("Shell.Application")
psw :=   COM_Invoke(psh, "Windows")
Loop, %   COM_Invoke(psw, "Count") {
	pwb := COM_Invoke(psw, "Item", A_Index-1)
	if !(COM_Invoke(pwb, "Name") = "Windows Internet Explorer") {
		COM_Release(pwb)
		continue
	}
;	sInfo.=COM_Invoke(pwb, "LocationName") "`n", COM_Release(pwb)
	sInfo.=COM_Invoke(pwb, "LocationName") "|", COM_Release(pwb)
}
COM_Release(psw)
COM_Release(psh)
COM_Term()
StringTrimRight, sInfo, sInfo, 1
return sInfo

}