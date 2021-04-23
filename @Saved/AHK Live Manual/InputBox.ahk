;===================================================
;== AHK Live-Manual - Lucid_Method =================
;===================================================

	AHKCommand = InputBox
	Command_Version = 1.1
	Manual_Credit = Lucid_Method
	Manual_Updated = 01-04-2011
	Manual_Tags = Input|
	
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

	GoSub LiveManual_Build_MenuBar

	Build_GUI:
{

#NoEnv
#Persistent
#SingleInstance force

;<GUI>
Gui, Add, Button, x16 y10 w580 h30 vButton1 hwnd_Manual gLiveManual_AHK_Manual, InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
	ILButton(_Manual, Manual_Ico, 22, 22, "Left")

Gui, Add, Text, x16 y60 w80 h20 vStatic2 hwndStatic2_Hwnd, OutputVar:
Gui, Add, Edit, x96 y60 w490 h20 vOutputVar hwndEdit1_Hwnd gSubmitCode, OutputVariable

Gui, Add, Text, x16 y90 w80 h20 vStatic3 hwndStatic3_Hwnd, Title:
Gui, Add, Edit, x96 y90 w490 h20 vTitle hwndEdit2_Hwnd gSubmitCode, 

Gui, Add, Text, x16 y120 w80 h20 vStatic4 hwndStatic4_Hwnd, Prompt:
Gui, Add, Edit, x96 y120 w490 h20 vPrompt hwndEdit3_Hwnd gSubmitCode, 

Gui, Add, CheckBox, x16 y150 w200 h20 vHideUserInput hwndButton2_Hwnd gSubmitCode, Hide User Input
Gui, Add, CheckBox, x16 yp+25 w200 h20 vOwnDialog hwndButton2_Hwnd gSubmitCode, +Own Dialogs

Gui, Add, Text, x150 y220 w50 h20 vStatic5 hwndStatic5_Hwnd, Width:
Gui, Add, Edit, xp+55 y220 w60 h20 vWidth hwndEdit4_Hwnd gSubmitCode, 375

Gui, Add, Text, x150 y240 w50 h20 vStatic6 hwndStatic6_Hwnd, Height:
Gui, Add, Edit, xp+55 y240 w60 h20 vHeight hwndEdit5_Hwnd gSubmitCode, 160 ;189 (default)

Gui, Add, Text, x16 y220 w20 h20 vStatic7 hwndStatic7_Hwnd, X:
Gui, Add, Edit, xp+25 yp w60 h20 vX hwndEdit6_Hwnd gSubmitCode, 

Gui, Add, Text, x16 y240 w20 h20 vStatic8 hwndStatic8_Hwnd, Y:
Gui, Add, Edit, xp+25 yp w60 h20 vY hwndEdit7_Hwnd gSubmitCode, 

Gui, Add, Text, x16 y280 w120 h20 vStatic9 hwndStatic9_Hwnd, Timeout (Seconds)
Gui, Add, Edit, x136 y280 w80 h20 vTimeout hwndEdit8_Hwnd gSubmitCode, 

Gui, Add, Text, x16 y310 w120 h20 vStatic10 hwndStatic10_Hwnd, Default Text:
Gui, Add, Edit, x136 y310 w450 h20 vDefaultText hwndEdit9_Hwnd gSubmitCode, 

Gui, Add, Edit, x16 y370 w580 h60 vCodeDisplay hwndEdit10_Hwnd, 
Gui, Add, Button, x16 y435 w130 h30 vButton3 hwnd_Clipboard gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 22, 22, "Left")
Gui, Add, Button, xp+140 yp w130 h30 vButton4 hwnd_Play gEditBox_Test_AHK, Test Code
	ILButton(_Play, Play_Ico , 22, 22, "Left")
Gui, Add, Button, xp+140 yp w130 h30 vButton5 hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 22, 22, "Left")
Gui, Add, Button, xp+140 yp wp hp hwnd_Exit gLiveManual_Exit, Close
	ILButton(_Exit, Exit_Ico , 22, 22, "Left")

Gui, Show, xCenter yCenter h480 w624, %AHKCommand% (AHK Live-Manual)
	
;</GUI>

GoSub SubmitCode ;Submit code on startup to generate default settings

Return
}


;===============================================================
; Submit Code
;===============================================================

	SubmitCode:
{
	Gui, Submit, NoHide
	
	If HideUserInput = 1
		CodeLine = %AHKCommand%, %OutputVar%,%Title%,%Prompt%, HIDE,%Width%,%Height%,%X%,%Y%,,%TimeOut%,%DefaultText%
		
	If HideUserInput = 0
		CodeLine = %AHKCommand%, %OutputVar%,%Title%,%Prompt%,,%Width%,%Height%,%X%,%Y%,,%TimeOut%,%DefaultText%		
	
	If OwnDialog = 1
		CodeLine = Gui +OwnDialogs +AlwaysOnTop`n%CodeLine%
	
	GuiControl,,CodeDisplay, %CodeLine%
	
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
