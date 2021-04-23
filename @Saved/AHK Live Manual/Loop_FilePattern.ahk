;===================================================
; AHK Live Manual - Loop, FilePattern
; Lucid_Method (01-11-2011)
;===================================================

#NoEnv
#Persistent
#SingleInstance force

AHKCommand = Loop_FilePattern
Command_Version = 1.0
GoSub LiveManual_Setup

;==============================
; Loop (File Pattern)
;==============================

	Build_Loop_FilePattern_GUI:
{

Gui, Add, Button, x16 y10 w600 h30 hwnd_Manual vButton1 gLiveManual_AHK_Manual, Loop, FilePattern [, IncludeFolders?, Recurse?]
	ILButton(_Manual, Manual_Ico , 22, 22, "Left")

Gui, Add, DropDownList, x456 y50 w160 h240 vFileLoopType gTestLoopCode, A_LoopFileName||A_LoopFileExt|A_LoopFileFullPath|A_LoopFileLongPath|A_LoopFileShortPath|A_LoopFileShortName|A_LoopFileDir|A_LoopFileTimeModified|A_LoopFileTimeCreated|A_LoopFileTimeAccessed|A_LoopFileAttrib|A_LoopFileSize|A_LoopFileSizeKB|A_LoopFileSizeMB
Gui, Add, ListView, xp yp+25 wp h220 vLoopFilePattern , Loop (Testing)
Gui, Add, Button, xp y310 w160 h30 vButton3 hwnd_Play gTestLoopCode, Test Loop	
	ILButton(_Play, Play_Ico , 16, 16, "Left")
Gui, Add, Button, xp yp+30 w80 hp hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 16, 16, "Left")
Gui, Add, Button, xp+80 yp wp hp hwnd_Exit gLiveManual_Exit, Exit
	ILButton(_Exit, Exit_Ico , 22, 22)

StartDir = %A_WorkingDir%

If StartDir = %A_WorkingDir%
	StartDirDisp = `%A_WorkingDir`%
	
Gui, Add, Text, x36 y70 w120 h20 vStatic2 , Start Dir:
Gui, Add, Button, xp y90 w250 h30 vStartDir gSelect_Start_Dir, %StartDirDisp% ;Start Dir

Gui, Add, Text, xp+260 y70 w160 h20 vStatic3 , File Pattern:
Gui, Add, Edit, xp yp+20 w90 h30 -VScroll vFilePattern gTestLoopCode, *.*

Gui, Add, Text, x36 y150 w120 h20 vStatic4 , Include Folders?
Gui, Add, DropDownList, x166 y150 w220 h220 vIncludeFolders gTestLoopCode, 0 - Files Only (No Folders)||1 - All Files and Folders|2 - Only Folders (No Files)

Gui, Add, Text, x36 y200 w120 h20 vStatic5 , Recurse?
Gui, Add, DropDownList, x166 y200 w220 h220 vRecurseFolders gTestLoopCode, 0 - Subfolders are not recursed into||1 - Subfolders are recursed


Gui, Add, Edit, x26 y310 w420 h30 -VScroll vCodeDisplay , 
Gui, Add, Button, xp yp+35 wp h25 hwnd_Clipboard gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 16, 16, "Left")

GoSub LiveManual_Build_MenuBar

Gui +Resize

Gui, Show, xCenter yCenter h375 w630, %AHKCommand% (AHK Live-Manual)

GoSub TestLoopCode ;Generate Code 

Return
}

	Select_Start_Dir:
{
Gui +OwnDialogs
StartFolder=
FileSelectFolder, StartFolder,, 3, Select Start Folder
If StartFolder =
	Return ;No file was selected
If StartFolder !=
	{
	StartDir = %StartFolder%
	StringReplace, StartFolder, StartFolder, \\, \, ALL
	GuiControl,,StartDir, %StartFolder%
	GoSub TestLoopCode ;Generate Code 
	}
Return
}
	
	Submit_Loop_FilePattern:
{
	Gui, Submit, Nohide
	
	LoopLine = Loop, %StartDir%\%FilePattern%
	StringReplace, LoopLine, LoopLine, \\, \, ALL
	
	IfInString, IncludeFolders, 0 - 
		IncludeFoldersValue = 0
	IfInString, IncludeFolders, 1 - 
		IncludeFoldersValue = 1
	IfInString, IncludeFolders, 2 - 
		IncludeFoldersValue = 2		
		
	LoopLine = %LoopLine%, %IncludeFoldersValue%
		
	IfInString, RecurseFolders, 0 - 
		RecurseFoldersValue = 0
	IfInString, RecurseFolders, 1 - 
		RecurseFoldersValue = 1

	LoopLine = %LoopLine%, %RecurseFoldersValue%
		
	GuiControl,,CodeDisplay, %LoopLine%
	
	
	Return
}	

	TestLoopCode:
{
	GoSub Submit_Loop_FilePattern
	Gui, ListView, LoopFilePattern ;Define LV to Send Commands To
	LV_Delete() ;Delete Existing LV Data
	Loop, %StartDir%\%FilePattern%, %IncludeFoldersValue%, %RecurseFoldersValue%
	{
		If FileLoopType = A_LoopFileName 
			LV_Add("", A_LoopFileName)
		If FileLoopType = A_LoopFileExt 
			LV_Add("", A_LoopFileExt)
		If FileLoopType = A_LoopFileFullPath 
			LV_Add("", A_LoopFileFullPath)
		If FileLoopType = A_LoopFileLongPath 
			LV_Add("", A_LoopFileLongPath)
		If FileLoopType = A_LoopFileShortPath 
			LV_Add("", A_LoopFileShortPath)
		If FileLoopType = A_LoopFileShortName 
			LV_Add("", A_LoopFileShortName)
		If FileLoopType = A_LoopFileTimeModified 
			LV_Add("", A_LoopFileTimeModified)
		If FileLoopType = A_LoopFileTimeCreated
			LV_Add("", A_LoopFileTimeCreated)
		If FileLoopType = A_LoopFileTimeAccessed 
			LV_Add("", A_LoopFileTimeAccessed)
		If FileLoopType = A_LoopFileAttrib 
			LV_Add("", A_LoopFileAttrib)
		If FileLoopType = A_LoopFileSize 
			LV_Add("", A_LoopFileSize)
		If FileLoopType = A_LoopFileSizeKB
			LV_Add("", A_LoopFileSizeKB)
		If FileLoopType = A_LoopFileSizeMB 
			LV_Add("", A_LoopFileSizeMB)
	}
	
	Return
}	

;==============================
; Basics
;==============================

	SubmitCode: ;Required for Live_Manual
	Return

;===================================================
; INCLUDE CODE
;===================================================
#Include Lib\LiveManual_Include.ahk
;===================================================


