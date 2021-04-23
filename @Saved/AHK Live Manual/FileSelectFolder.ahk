;===================================================
; AHK Live Manual - FileSelectFolder
; Lucid_Method (01-04-2011)
;===================================================

#NoEnv
#Persistent
#SingleInstance force

TestAHK = %A_WorkingDir%\Lib\TestAHK.ahk
FileDelete %TestAHK%
AHKCommand = FileSelectFolder
Command_Version = 1.0
GoSub LiveManual_Setup


LiveManual_Build_FileSelectFolder:
{
Gui, Font, S10 Bold
Gui, Add, Button, x50 y5 w750 h25 vButton1 hwnd_Manual gLiveManual_AHK_Manual, %AHKCommand%`, OutputVar [`, StartingFolder`, Options`, Prompt]
	ILButton(_Manual, Manual_Ico , 16, 16, "Left")
Gui, Font

Gui, Add, GroupBox, x26 y30 w540 h50 vButton26 hwndButton26_Hwnd, (1) Output Variable
Gui, Add, Text, x36 y50 w90 h20 vStatic2 hwndStatic2_Hwnd, Output Variable:
Gui, Add, Edit, x126 y50 w240 h20 -VScroll vOutputVarName hwndEdit4_Hwnd gSubmitCode, OutputVar

Gui, Add, GroupBox, x26 y90 w540 h120 vButton9 hwndButton9_Hwnd, (3) Options
	Gui, Add, CheckBox, x36 y110 w370 h20 vOptionsDisabled gSubmitCode, (0) Options Below Disabled
	Gui, Add, CheckBox, xp yp+20 wp hp vOptionsNewFolders gSubmitCode Checked, (+1) New Folders Button (Default)
	Gui, Add, CheckBox, xp yp+20 wp hp vOptionsNewFolderEdit gSubmitCode Checked, (+2) Add Edit Field for New Folder
	Gui, Add, CheckBox, xp yp+20 wp hp vOptionsNoNewFolder gSubmitCode, (+4) Remove "Make New Folder" Button

Gui, Add, GroupBox, x26 y220 w540 h160 vButton13 hwndButton13_Hwnd, (2) Starting Folder
	Gui, Add, Radio, xp+10 y240 w330 h20 Checked vWorkingDir hwndButton10_Hwnd gSubmitCode, Blank (Defaults to My Docs or My Computer)
	Gui, Add, Radio, xp yp+20 w100 h20 vRootFolderSelected gSubmitCode, Selected Folder
	Gui, Add, Radio, xp yp+20 w130 h20 vCustomRootDir hwndButton11_Hwnd gSubmitCode, Custom Start Folder
	RootFolderList = A_WorkingDir|A_ScriptDir|My Computer||My Documents|My Network Places|Administrative Tools|Briefcase|Control Panel|Fonts|History|Inbox|Microsoft Network|Network Computers|Network Connections|Printers and Faxes|Programs Folder|Recycle Bin|Scanners and Cameras|Scheduled Tasks|Start Menu Folder|Temporary Internet Files|Web Folders	
	Gui, Add, DropDownList, xp+130 yp-20 w150 h300 vRootFolderDDL gSubmitCode, %RootFolderList%
		Gui, Add, Button, x166 yp+20 w100 h20 vCustomRootDirPATH hwndButton14_Hwnd gCustom_Root_Dir, Starting Folder
		Gui, Add, Edit, xp+100 yp w290 h20 vRootFolderEDIT hwndButton15_Hwnd, 
	Gui, Add, Checkbox, x36 yp+40 w130 h20 vAllowNavigation gSubmitCode, Allow Navigation
		Gui, Add, Button, x166 yp w100 h20 vNavigationRootButton gUpperMost_Dir, Uppermost Dir
		Gui, Add, Edit, xp+100 yp w290 h20 vNavigationRoot hwndButton15_Hwnd,


Gui, Add, GroupBox, x26 y380 w540 h70 vButton16 hwndButton16_Hwnd, (4) Prompt
	Gui, Add, Radio, x36 y400 w510 h20 Checked vPromptDefault hwndButton17_Hwnd gSubmitCode, "Select File - `%A_SCRIPTNAME`%" (i.e. the name of the current script).
	Gui, Add, Radio, x36 y420 w100 h20 vPromptCustom hwndButton18_Hwnd gSubmitCode, Custom Prompt
	Gui, Add, Edit, x146 y420 w400 h20 vPromptCustomText hwndEdit1_Hwnd gSubmitCode, Custom Prompt Edit


Gui, Add, GroupBox, x576 y90 w160 h180 vButton30 hwndButton30_Hwnd, (5) Misc Options
	Gui, Add, CheckBox, x586 y110 w120 h20 vOwnDialog gSubmitCode Checked, Own Dialog
	Gui, Add, CheckBox, x586 yp+20 w140 h20 vSelectedFileCode gSubmitCode, Selected File Code

Gui, Add, Edit, x36 y460 w650 h140 vCodeDisplay hwndEdit3_Hwnd -Vscroll, Code Display
	
;Gui, Add, Button, xp+195 yp wp h30 vButton23 hwndButton23_Hwnd gEditBox_Test_AHK, Test EditBox Code

	
Gui, Add, Button, x36 y620 w190 h30 vButton22 hwnd_Clipboard gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 22, 22, "Left")
Gui, Add, Button, xp+195 yp wp h30 vButton29 hwnd_Play gWrite_Test_AHK, Generate/Test Code
	ILButton(_Play, Play_Ico , 22, 22, "Left")
Gui, Add, Button, xp+210 yp w80 h30 vButton24 hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 22, 22, "Left")
Gui, Add, Button, xp+85 yp w90 h30 hwnd_Exit gLiveManual_Exit, Close
	ILButton(_Exit, Exit_Ico , 22, 22, "Left")
	
;Gui, Add, Radio, x746 y460 w90 h20 vSimpleOutput hwndButton27_Hwnd Checked, Generated
;Gui, Add, Radio, x746 y480 w90 h20 vExampleOutput hwndButton28_Hwnd Disabled, Example

GoSub LiveManual_Build_MenuBar
Gui +Resize
Gui, Show, xCenter yCenter h667 w800, %AHKCommand% (AHK Live-Manual)

GoSub SubmitCode

Return
}


;===================================================

SubmitCode:
{
	Gui, Submit, NoHide
	CodeLine = %AHKCommand%, %OutputVarName%
	
;=====================
; StartingFolder
;=====================
{
	RootDirLine = 
	
		GuiControl, Disable, InitialFileNamePATH
		GuiControl, Disable, InitialFileNameEDIT
		GuiControl, Disable, CustomRootDirPATH
		GuiControl, Disable, RootFolderEDIT	
		GuiControl, Disable, RootFolderDDL	
		GuiControl, Disable, NavigationRoot
		GuiControl, Disable, NavigationRootButton		
		

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
		If RootFolderDDL = A_WorkingDir
			RootDirLine = `%A_WorkingDir`%
		If RootFolderDDL = A_ScriptDir
			RootDirLine = `%A_ScriptDir`%			
			
		If AllowNavigation = 1
			{
			GuiControl, Enable, NavigationRoot
			GuiControl, Enable, NavigationRootButton
			RootDirLine = *%RootDirLine%
			}
		}
	
	
	If CustomRootDir = 1 ; hwndButton11_Hwnd, Custom Root Dir
		{
		RootDirLine = Custom Root Dir
		GuiControl, Enable, CustomRootDirPATH
		GuiControl, Enable, RootFolderEDIT
		
		If AllowNavigation = 1
			{
			GuiControl, Enable, NavigationRoot
			GuiControl, Enable, NavigationRootButton
			RootDirLine = *%RootFolderEDIT%
			If UpperMostFolder != 
				RootDirLine = %UpperMostFolder% *%RootFolderEDIT%
			}
		If AllowNavigation != 1
			RootDirLine = %RootFolderEDIT%			
		}
	
	
	CodeLine = %CodeLine%, %RootDirLine%
}		
	
	
	
;=====================
; Options
;=====================
{	
	OptionsLine = 0
	
	If OptionsDisabled = 1
		{
		GuiControl,,OptionsNewFolders, 0
		GuiControl,,OptionsNewFolderEdit, 0
		GuiControl,,OptionsNoNewFolder, 0
		
		GuiControl, Disable, OptionsNewFolders
		GuiControl, Disable, OptionsNewFolderEdit
		GuiControl, Disable, OptionsNoNewFolder
		OptionsLine = 0
		}
		
	If OptionsDisabled != 1
		{
		GuiControl, Enable, OptionsNewFolders
		GuiControl, Enable, OptionsNewFolderEdit
		GuiControl, Enable, OptionsNoNewFolder
		}		

	If OptionsNewFolders = 1 
		OptionsLine += 1
		
	If OptionsNewFolderEdit = 1 
		OptionsLine += 2		
		
	If OptionsNoNewFolder = 1 
		{
		;--Disable Previous 2 Options - Remove Value If Checked Already
		If OptionsNewFolders = 1 
			OptionsLine -= 1
		If OptionsNewFolderEdit = 1 
			OptionsLine -= 2
		GuiControl,,OptionsNewFolders, 0
		GuiControl,,OptionsNewFolderEdit, 0		
		GuiControl, Disable, OptionsNewFolders
		GuiControl, Disable, OptionsNewFolderEdit		
		OptionsLine += 4
		}

	CodeLine = %CodeLine%, %OptionsLine%
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
	
UpperMost_Dir: 
{
	Gui +OwnDialogs
	Gui, Submit, NoHide
	If RootFolderEDIT != 
		FileSelectFolder, UpperMostFolder,*%RootFolderEDIT%,3, Select Uppermost Folder
	If RootFolderEDIT = 
		FileSelectFolder, UpperMostFolder,,3, Select Uppermost Folder		
	
	If UpperMostFolder = 
		Return
	GuiControl,,NavigationRoot, %UpperMostFolder%
	;InitialFileNameEDIT = %UserInitialFileName%
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

