;===================================================
;== AHK Live-Manual - Lucid_Method =================
;===================================================

	AHKCommand = FileSelectFile
	Command_Version = 1.0
	Manual_Credit = Lucid_Method
	Manual_Updated = 01-04-2011
	Manual_Tags = Files|

;===============================================================
; Startup Actions
;===============================================================	
	LiveManual_Startup_Actions:
{	
	TestAHK = %A_WorkingDir%\Lib\TestAHK.ahk
	FileDelete %TestAHK%
	GoSub LiveManual_Setup
}	
	
;===============================================================
; Build GUI
;===============================================================

	LiveManual_Build_Gui:
{
#NoEnv
#Persistent
#SingleInstance force

Gui, Font, S10 Bold
Gui, Add, Button, x50 y5 w750 h25 vButton1 hwnd_Manual gLiveManual_AHK_Manual, %AHKCommand%, OutputVar [, Options, RootDir\Filename, Prompt, Filter]
	ILButton(_Manual, Manual_Ico , 18, 18, "Left")
Gui, Font

Gui, Add, GroupBox, x26 y30 w540 h50 vButton26 hwndButton26_Hwnd, (2) Output Variable
Gui, Add, Text, x36 y50 w90 h20 vStatic2 hwndStatic2_Hwnd, Output Variable:
Gui, Add, Edit, x126 y50 w240 h20 -VScroll vOutputVarName hwndEdit4_Hwnd gSubmitCode, OutputVar

Gui, Add, GroupBox, x26 y90 w540 h180 vButton9 hwndButton9_Hwnd, (3) Options
Gui, Add, CheckBox, x36 y110 w370 h20 vMultiSelect hwndButton2_Hwnd gSubmitCode, (M) Multi-Select
Gui, Add, CheckBox, x36 y130 w370 h20 vSaveButton hwndButton3_Hwnd gSubmitCode, (S) Save Button (Instead of Open)
Gui, Add, CheckBox, x36 y160 w230 h20 vFileMustExist hwndButton4_Hwnd gSubmitCode, (1) File Must Exist
Gui, Add, CheckBox, x36 y180 w230 h20 vPathMustExist hwndButton5_Hwnd gSubmitCode, (2) Path Must Exist
Gui, Add, CheckBox, x36 y200 w230 h20 vCreateNewFile hwndButton6_Hwnd gSubmitCode, (8) Prompt to Create New File
Gui, Add, CheckBox, x36 y220 w230 h20 vOverWriteFile hwndButton7_Hwnd gSubmitCode, (16) Prompt to OverWrite File
Gui, Add, CheckBox, x36 y240 w370 h20 vShortcuts hwndButton8_Hwnd gSubmitCode, (32) Shortcuts (.lnk) Selected As-Is Instead Of Following Shortcut

Gui, Add, GroupBox, x26 y270 w540 h110 vButton13 hwndButton13_Hwnd, (4) RootDir

	Gui, Add, Radio, x36 y290 w130 h20 Checked vWorkingDir hwndButton10_Hwnd gSubmitCode, Working Dir (Default)
	Gui, Add, Radio, x36 yp+20 w100 h20 vRootFolderSelected gSubmitCode, Selected Folder
	Gui, Add, Radio, x36 yp+20 w130 h20 vCustomRootDir hwndButton11_Hwnd gSubmitCode, Custom Root Dir
	Gui, Add, Radio, x36 yp+20 w130 h20 vInitialFileName hwndButton12_Hwnd gSubmitCode, Initial File Name
	
	RootFolderList = My Computer||My Documents|My Network Places|Administrative Tools|Briefcase|Control Panel|Fonts|History|Inbox|Microsoft Network|Network Computers|Network Connections|Printers and Faxes|Programs Folder|Recycle Bin|Scanners and Cameras|Scheduled Tasks|Start Menu Folder|Temporary Internet Files|Web Folders	
	Gui, Add, DropDownList, xp+130 yp-40 w150 h300 vRootFolderDDL gSubmitCode, %RootFolderList%

		Gui, Add, Button, x166 y330 w100 h20 vCustomRootDirPATH hwndButton14_Hwnd gCustom_Root_Dir, Custom Root Dir
		Gui, Add, Edit, xp+100 yp w290 h20 vRootFolderEDIT hwndButton15_Hwnd, 
	
		Gui, Add, Button, x166 y350 w100 h20 vInitialFileNamePATH hwndButton15_Hwnd gInitial_File_Name, Initial File Name
		Gui, Add, Edit, xp+100 yp w290 h20 vInitialFileNameEDIT hwndButton15_Hwnd, 


Gui, Add, GroupBox, x26 y380 w540 h70 vButton16 hwndButton16_Hwnd, (5) Prompt
Gui, Add, Radio, x36 y400 w510 h20 Checked vPromptDefault hwndButton17_Hwnd gSubmitCode, "Select File - `%A_SCRIPTNAME`%" (i.e. the name of the current script).
Gui, Add, Radio, x36 y420 w100 h20 vPromptCustom hwndButton18_Hwnd gSubmitCode, Custom Prompt
Gui, Add, Edit, x146 y420 w400 h20 vPromptCustomText hwndEdit1_Hwnd gSubmitCode, Custom Prompt Edit


Gui, Add, GroupBox, x576 y90 w260 h180 vButton30 hwndButton30_Hwnd, Misc Options
	Gui, Add, CheckBox, x586 y110 w240 h20 vOwnDialog gSubmitCode Checked, Own Dialog
	Gui, Add, CheckBox, x586 yp+20 w240 h20 vSelectedFileCode gSubmitCode, Selected File Code

Gui, Add, GroupBox, x576 y270 w260 h110 vButton25 hwndButton25_Hwnd, (6) Filters
Gui, Add, Radio, x586 y300 w230 h20 Checked vFilterAllFiles hwndButton20_Hwnd gSubmitCode, All Files (*.*)
Gui, Add, Radio, x586 y320 w230 h20 vFilterCustom hwndButton21_Hwnd gSubmitCode, Custom Filter
Gui, Add, Edit, x586 y350 w240 h20 vFilterCustomFiles hwndEdit2_Hwnd gSubmitCode, Documents (*.txt`, *.doc)

Gui, Add, Edit, x36 y460 w700 h140 vCodeDisplay hwndEdit3_Hwnd -Vscroll, Code Display

Gui, Add, Button, x36 y620 w190 h30 vButton22 hwnd_Clipboard gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 22, 22, "Left")
Gui, Add, Button, xp+195 yp wp h30 vButton29 hwnd_Play gWrite_Test_AHK, Generate/Test Code
	ILButton(_Play, Play_Ico , 22, 22, "Left")
Gui, Add, Button, xp+210 yp w80 h30 vButton24 hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 22, 22, "Left")
Gui, Add, Button, xp+85 yp w90 h30 hwnd_Exit gLiveManual_Exit, Close
	ILButton(_Exit, Exit_Ico , 22, 22, "Left")
	

		

Gui, Add, Radio, x746 y460 w90 h20 vSimpleOutput hwndButton27_Hwnd Checked, Generated
Gui, Add, Radio, x746 y480 w90 h20 vExampleOutput hwndButton28_Hwnd Disabled, Example

GoSub LiveManual_Build_MenuBar
Gui +Resize
Gui, Show, xCenter yCenter h667 w844, %AHKCommand% (AHK Live-Manual)

GoSub SubmitCode

Return
}

;===================================================
	
	SubmitCode:
{
	Gui, Submit, NoHide
	CodeLine = %AHKCommand%, %OutputVarName%
	
;=====================
; Options
;=====================
{	
	OptionsLine = 
	OptionsLineNum = 0
	
	If MultiSelect = 1 ; hwndButton2_Hwnd gSubmitCode, Multi-Select
		OptionsLine = M

	If SaveButton = 1 ; hwndButton3_Hwnd gSubmitCode, Save Button (Instead of Open)
		OptionsLine = %OptionsLine% S

	If FileMustExist = 1 ; hwndButton4_Hwnd gSubmitCode, (1) File Must Exist
		OptionsLineNum += 1
	
	If PathMustExist = 1 ; hwndButton5_Hwnd gSubmitCode, (2) Path Must Exist
		OptionsLineNum += 2
	
	If CreateNewFile = 1 ;hwndButton6_Hwnd gSubmitCode, (8) Prompt to Create New File
		OptionsLineNum += 8
	
	If OverWriteFile = 1 ;hwndButton7_Hwnd gSubmitCode, (16) Prompt to OverWrite File
		OptionsLineNum += 16
		
	If Shortcuts = 1 ;hwndButton8_Hwnd gSubmitCode, (32) Shortcuts (.lnk) Selected As-Is Instead Of Following Shortcut
		OptionsLineNum += 32
	
	If OptionsLineNum != 0 
		OptionsLine = %OptionsLine% %OptionsLineNum%
	
	If OptionsLine != 
		CodeLine = %AHKCommand%, %OutputVarName%, %OptionsLine%
	If OptionsLine = 
		CodeLine = %AHKCommand%, %OutputVarName%,
}		

;=====================
; RootDir
;=====================
{
	RootDirLine = 
	
		GuiControl, Disable, InitialFileNamePATH
		GuiControl, Disable, InitialFileNameEDIT
		GuiControl, Disable, CustomRootDirPATH
		GuiControl, Disable, RootFolderEDIT	
		GuiControl, Disable, RootFolderDDL	
		

	If WorkingDir = 1 ;hwndButton10_Hwnd Checked, Working Dir (Default)
		RootDirLine = 
		
	If RootFolderSelected = 1
		{
		GuiControl, Enable, RootFolderDDL
		If RootFolderDDL = My Computer
			RootDirLine = ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
		If RootFolderDDL = My Documents
			RootDirLine = ::{450d8fba-ad25-11d0-98a8-0800361b1103}
		If RootFolderDDL = My Network Places
			RootDirLine = ::{208d2c60-3aea-1069-a2d7-08002b30309d}
		If RootFolderDDL = Administrative Tools
			RootDirLine = ::{d20ea4e1-3957-11d2-a40b-0c5020524153}
		If RootFolderDDL = Briefcase
			RootDirLine = ::{85bbd92o-42a0-1o69-a2e4-08002b30309d}		
		If RootFolderDDL = Control Panel
			RootDirLine = ::{21ec2o2o-3aea-1o69-a2dd-08002b30309d}			
		If RootFolderDDL = Fonts
			RootDirLine = ::{d20ea4e1-3957-11d2-a40b-0c5020524152}
		If RootFolderDDL = History
			RootDirLine = ::{ff393560-c2a7-11cf-bff4-444553540000}
		If RootFolderDDL = Inbox
			RootDirLine = ::{00020d75-0000-0000-c000-000000000046}
		If RootFolderDDL = Microsoft Network
			RootDirLine = ::{00028b00-0000-0000-c000-000000000046}
		If RootFolderDDL = Network Computers
			RootDirLine = ::{1f4de370-d627-11d1-ba4f-00a0c91eedba}
		If RootFolderDDL = Network Connections
			RootDirLine = ::{7007acc7-3202-11d1-aad2-00805fc1270e}
		If RootFolderDDL = Printers and Faxes
			RootDirLine = ::{2227a280-3aea-1069-a2de-08002b30309d}
		If RootFolderDDL = Programs Folder
			RootDirLine = ::{7be9d83c-a729-4d97-b5a7-1b7313c39e0a}
		If RootFolderDDL = Recycle Bin
			RootDirLine = ::{645ff040-5081-101b-9f08-00aa002f954e}
		If RootFolderDDL = Scanners and Cameras
			RootDirLine = ::{e211b736-43fd-11d1-9efb-0000f8757fcd}
		If RootFolderDDL = Scheduled Tasks
			RootDirLine = ::{d6277990-4c6a-11cf-8d87-00aa0060f5bf}
		If RootFolderDDL = Start Menu Folder
			RootDirLine = ::{48e7caab-b918-4e58-a94d-505519c795dc}
		If RootFolderDDL = Temporary Internet Files
			RootDirLine = ::{7bd29e00-76c1-11cf-9dd0-00a0c9034933}
		If RootFolderDDL = Web Folders
			RootDirLine = ::{bdeadf00-c265-11d0-bced-00a0c90ab50f}
		}
	
	
	If CustomRootDir = 1 ; hwndButton11_Hwnd, Custom Root Dir
		{
		RootDirLine = Custom Root Dir
		GuiControl, Enable, CustomRootDirPATH
		GuiControl, Enable, RootFolderEDIT
		RootDirLine = %RootFolderEDIT%
		}
	
	If InitialFileName = 1 ; hwndButton12_Hwnd, Initial File Name
		{
		GuiControl, Enable, InitialFileNamePATH
		GuiControl, Enable, InitialFileNameEDIT
		RootDirLine = %InitialFileNameEDIT%		
		}
	

	CodeLine = %CodeLine%, %RootDirLine%
}	

;=====================
; Prompt
;=====================
{
	If PromptDefault = 1 ; hwndButton17_Hwnd Checked gSubmitCode, "Select File - `%A_SCRIPTNAME`%" (i.e. the name of the current script).
		{
		GuiControl, Disable, PromptCustomText
		PromptLine = 
		}
		
	If PromptCustom = 1 ; hwndButton17_Hwnd Checked gSubmitCode, "Select File - `%A_SCRIPTNAME`%" (i.e. the name of the current script).
		{
		GuiControl, Enable, PromptCustomText
		PromptLine = %PromptCustomText% 	
		}
		
	CodeLine = %CodeLine%, %PromptLine%
}	
	
;=====================
; Filter
;=====================
{
	If FilterAllFiles = 1 ; hwndButton20_Hwnd Checked gSubmitCode, All Files (*.*)
		{
		GuiControl, Disable, FilterCustomFiles
		FilterLine = 
		}
		
	If FilterCustom = 1 ; hwndButton21_Hwnd gSubmitCode, Custom Filter
		{
		GuiControl, Enable, FilterCustomFiles
		FilterLine = %FilterCustomFiles% 		
		}
		
	CodeLine = %CodeLine%, %FilterLine%
}	

;=====================
; Pre-Code Options
;=====================
{
	PreCodeLine = 

	If OwnDialog = 1
		PreCodeLine = Gui +OwnDialogs

	If PreCodeLine !=
		CodeLine = %PreCodeLine%`n%CodeLine%

}


;=====================
; Post-Code Options
;=====================
{
	PostCodeLine = 
	
	If SelectedFileCode = 1
		PostCodeLine = If %OutputVarName% =`n%A_Tab%Return `;No file was selected`nIf %OutputVarName% !=`n%A_Tab%Msgbox User Selected `%%OutputVarName%`%
	
	If PostCodeLine != 
		CodeLine = %CodeLine%`n%PostCodeLine%
}	
	
		
	;Update GUI with New Code To Display	
		GuiControl,,CodeDisplay, %CodeLine%
	
Return
}

	Initial_File_Name: ;Select the Initial File for FileSelectFile
{
	Gui +OwnDialogs
	FileSelectFile, UserInitialFileName, S,, Initial File Name,
	If UserInitialFileName = 
		Return
	GuiControl,,InitialFileNameEDIT, %UserInitialFileName%
	InitialFileNameEDIT = %UserInitialFileName%
	GoSub SubmitCode
	Return
}	

	Custom_Root_Dir: ;Select the Initial Root Dir for FileSelectFile
{
	Gui +OwnDialogs
	FileSelectFolder, UserInitialFolder,,3, Select Root Folder
	If UserInitialFolder = 
		Return
	GuiControl,,RootFolderEDIT, %UserInitialFolder%
	InitialFileNameEDIT = %UserInitialFileName%
	GoSub SubmitCode
	Return
}

	Write_Test_AHK:
{
FileDelete %TestAHK%

GoSub SubmitCode

FileAppend,
(
#NoEnv
#Persistent
#SingleInstance force

%CodeLine%

ExitApp

/*
Gui, Add, Button, x196 y10 w270 h30 vButton1 gFileSelectFile, %AHKCommand% (Test)
Gui, Add, Edit, x16 y50 w640 h30 vFileSelectFile , 
Gui, Add, Button, x196 y90 w270 h30 gGuiClose, Close
Gui, Show, x182 y280 h133 w667, %AHKCommand% (Test)
Gui, +AlwaysOnTop
Return
*/

FileSelectFile:
{
%CodeLine%
GuiControl,,FileSelectFile, `%%OutputVarName%`%
Return
}

GuiClose:
ExitApp

), %TestAHK%  ;End of File Append

Run %TestAHK%

Return
}

	EditBox_Test_AHK:
{
Gui, Submit, NoHide

FileDelete %TestAHK%

FileAppend,
(
#NoEnv
#Persistent
#SingleInstance force

%CodeDisplay%

ExitApp

GuiClose:
ExitApp

), %TestAHK%  ;End of File Append

Run %TestAHK%

Return
}


;===================================================


;===================================================
; INCLUDE CODE
;===================================================
#Include Lib\LiveManual_Include.ahk
;===================================================

