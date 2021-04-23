; ******* INFO *******
; < DLPaste > (working name)
ScriptVersion:=0.72
; Script created using Autohotkey (http://www.autohotkey.com)
; AUTHOR: sumon @ the Autohotkey forums, < simon.stralberg (@) gmail.com>
; SCRIPT FUNCTION: Get the latest addition to your downloads folder, and copy it to current folder location
;
; New functions: Silent mode. No traytips at all.
; To-do-list:
; Add functionality for "select another file" or multiple
; Add settings
; 

; ******* Initiate script *******
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
OnExit, Exit

; ******* Auto-Execute *******
IniRead, DownloadFolder, DLPaste.ini, General, DownloadFolder, 0
If (DownloadFolder = 0)
	{
	RegRead, DownloadFolder, HKCU, Software\Microsoft\Internet Explorer, Download Directory
	FileSelectFolder, DownloadFolder, *Downloadfolder, , Please select your downloads folder (one last time...!)
	DownloadFolder = %DownloadFolder%
	IniWrite, %DownloadFolder%, DLPaste.ini, General, DownloadFolder
	TrayTip, DLPaste:, %DownloadFolder% selected.`nTo change - edit or delete the DLPaste.ini file, 2, 1
	}
LastFile:=""
LastFileDate:=0
Loop, %DownloadFolder%\*.*, 0
	{
	if (A_LoopFileTimeModified>LastFileDate)
		LastFile:=A_LoopFileName, LastFileDate:=A_LoopFileTimeModified
	FileSource:=DownloadFolder . "\" . LastFile
	}
; Note: No return, label below continues with copying the file	
; ******* Labels *******

; Spy info: >>>>>>>>>>>( Visible Window Text )<<<<<<<<<<<
; Address: C:\Users\Simon\Desktop\Scripts\DLPaste
WinGetActiveTitle, ActiveWinTitle
WinGetText, FileDest, %ActiveWinTitle%, Address:
StringSplit, Output, FileDest, `n, %A_Space%
StringTrimLeft, FileDest, Output1, 9 ; Remove the "Adress:"
StringTrimRight, FileDest, Filedest, 1 ; Remove a space

FileCopy, %FileSource%, %FileDest%
If (DoDeleteFiles = 1)
	FileDelete, %FileSource%
SetTimer, Exit, -5000
return

; ******* Exitlabel *******
Exit:
TrayTip, DLPaste:, Copied %LastFile%, 2, 1
Sleep 3000
ExitApp


; ******* Functions *******