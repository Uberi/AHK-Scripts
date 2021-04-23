;===================================================
; AHK Live Manual - SoundBeep
; Lucid_Method (01-04-2011)
;===================================================

#NoEnv
#Persistent
#SingleInstance force

TestAHK = %A_WorkingDir%\Lib\TestAHK.ahk
FileDelete %TestAHK%
AHKCommand = SoundBeep
Command_Version = 1.0
GoSub LiveManual_Setup

;===================================================

LiveManual_Build_SoundBeep:
{

Gui, Add, Button, x16 y10 w450 h30 vButton1 hwnd_Manual gLiveManual_AHK_Manual, SoundBeep [, Frequency, Duration]
	ILButton(_Manual, Manual_Ico , 16, 16, "Left")

Gui, Add, Text, x56 y60 w110 h20 vStatic2 , Frequency:
Gui, Add, Edit, x176 y60 w110 h20 vFrequency gSubmitCode, 523

Gui, Add, Text, x56 y100 w110 h20 vStatic3 , Duration:
Gui, Add, Edit, x176 y100 w110 h20 vDuration gSubmitCode, 150

Gui, Add, Edit, x26 y150 w440 h20 vCodeDisplay , ;Code Display
Gui, Add, Button, x26 y170 w440 h23 hwnd_Clipboard vButton2 gLiveManual_CopyCode, Copy Code
	ILButton(_Clipboard, Clipboard_Ico , 16, 16, "Left")

Gui, Add, Button, x26 y200 w250 h30 vButton3 hwnd_Play gLiveManual_Write_Test_AHK, Test Code
	ILButton(_Play, Play_Ico , 16, 16, "Left")
Gui, Add, Button, x276 y200 w100 h30 vButton4 hwnd_Reload gLiveManual_Reload, Reload
	ILButton(_Reload, Refresh_Ico , 16, 16, "Left")
Gui, Add, Button, x376 y200 w90 h30 vButton5 hwnd_Exit gLiveManual_Exit, Exit
	ILButton(_Exit, Exit_Ico , 22, 22)

Gui +Resize
GoSub LiveManual_Build_MenuBar
Gui, Show, xCenter yCenter h257 w482, %AHKCommand% (AHK Live-Manual)
GoSub SubmitCode

Return
}


;===================================================

SubmitCode:
{
	Gui, Submit, NoHide
	CodeLine = %AHKCommand%, %Frequency%, %Duration%
	GuiControl,,CodeDisplay, %CodeLine%
	Return
}
	
	
	
	

;===================================================
; INCLUDE CODE
;===================================================
#Include Lib\LiveManual_Include.ahk
;===================================================
