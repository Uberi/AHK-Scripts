
#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#SingleInstance Force
;Must be in auto-execute section if you want to use the constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AHKHID_UseConstants() ;If AHKHID.ahk is in your library use this line.
;#Include AHKHID.ahk ;Otherwise use this line in which case AHKHID.ahk
;must be in the same folder as this script.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Create GUI to receive messages
Gui, +LastFound +AlwaysOnTop
hGui := WinExist()
Gui, Color, Black
Gui, Font, s12, Impact
Gui, Add, Text, x0 y3 w410 Center cBlue, Shuttle Pro Input Monitor
Gui, Add, Text, x0 y2 w410 Center BackgroundTrans cWhite vTitle, Shuttle Pro Input Monitor
Gui, Font, s8, Arial
Gui, Add, Button, x355 y5 w15  h15 gHelp, ?
Gui, Add, Button, x375 y5 w15 h15 Center gMin, _
Gui, Add, Button, x390 y5 w15 h15 Center gExit, X

Gui, Add, Edit, x5 y25 w170 r1 vEdit1,
Gui, Font, cWhite
Gui, Add, Checkbox, x180 y30 Checked vNo0, No Zero Labels

Gui, Add, Radio, x5 y50 Checked vStat, Static Label
Gui, Add, Radio, x90 y50 vStream, Streaming Label

Gui, Add, Button, x200 y48 w205 h20 gAddSub, Add Subroutine

Gui, Font, cBlack
Gui, Add, Edit, x5 y70 w400 -Wrap r10 vEdit2,

Menu, tray, add 
Menu, tray, add, Input Monitor Help, Help 
Menu, tray, add, Show Input Monitor, ShowIPM
Gui, -Caption +0x400000
Gui, Show, y10 w410 h225 Hide, I. M.  
GuiControl, Focus, Edit1
OnMessage(0x201, "WM_LBUTTONDOWN") 
;
;Intercept WM_INPUT messages
WM_INPUT := 0xFF
OnMessage(WM_INPUT, "InputMsg")

;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
r := AHKHID_Register(12, 1, hGui, RIDEV_INPUTSINK) ;Replace 65468 with your device's Usage
;Page number and 137 with you device's Usage number.  If your device has more than 1 Usage Page/Usage
;Make a copy of this line for each one.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Prefix loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Replace the prefixes with the prefixes you used to make your g-label.  These must match exactly.
Loop {
    Sleep 1000
    If WinActive("ahk_class QWidget") Or WinActive("ahk_class VLC DirectX")
        sPrefix := "VLC_"
    Else If WinActive("ahk_class Winamp v1.x") Or WinActive("ahk_class Winamp Video")
        sPrefix := "Winamp_"
    Else If WinActive("ahk_class MediaPlayerClassicW")
        sPrefix := "MPC_"
    Else sPrefix := "Default_" ;If you're using labels without prefixes delete the word "Default".
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
Return

InputMsg(wParam, lParam) {
    Local devh, iKey, sLabel

    Critical

    ;Get handle of device
    devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)


    ;Check for error
    If (devh <> -1) ;Check that it is my HP remote
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        And (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 1523) ;Replace these three
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 576) ;numbers with your
        And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = 513) { ;devices numbers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;Get data
        iKey := AHKHID_GetInputData(lParam, uData)

        ;Check for error
        If (iKey <> -1) {

								
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			iKey0 := NumGet(uData, 0, "UChar")
			If iKey0 = %Old0%
					iKey0 = -1
			If iKey0 > -1
				{
				sLabel := sPrefix "1_" iKey0
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey0 = 0
						GoTo Numb0
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb0:
				Old0 = %iKey0%
				StreamLabel := sPrefix "0_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey1 := NumGet(uData, 1, "UChar")
			If iKey1 = %Old1%
					iKey1 = -1
			If iKey1 > -1
				{
				sLabel := sPrefix "1_" iKey1
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey1 = 0
						GoTo Numb1
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb1:
				Old1 = %iKey1%
				StreamLabel := sPrefix "1_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey2 := NumGet(uData, 2, "UChar")	
			If iKey2 = %Old2%
					iKey2 = -1
			If iKey2 > -1
				{
				sLabel := sPrefix "2_" iKey2
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey2 = 0
						GoTo Numb2
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb2:
				Old2 = %iKey2%
				StreamLabel := sPrefix "2_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey3 := NumGet(uData, 3, "UChar")	
			If iKey3 = %Old3%
					iKey3 = -1
			If iKey3 > -1
				{
				sLabel := sPrefix "3_" iKey3
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey3 = 0
						GoTo Numb3
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb3:
				Old3 = %iKey3%
				StreamLabel := sPrefix "3_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey4 := NumGet(uData, 4, "UChar")
			If iKey4 = %Old4%
					iKey4 = -1
			If iKey4 > -1
				{
				sLabel := sPrefix "4_" iKey4
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey4 = 0
						GoTo Numb4
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb4:
				Old4 = %iKey4%
				StreamLabel := sPrefix "4_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey5 := NumGet(uData, 5, "UChar")	
			If iKey5 = %Old5%
					iKey5 = -1
			If iKey5 > -1
				{
				sLabel := sPrefix "5_" iKey5
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey5 = 0
						GoTo Numb5
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb5:
				Old5 = %iKey5%
				StreamLabel := sPrefix "5_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey6 := NumGet(uData, 6, "UChar")
			If iKey6 = %Old6%
					iKey6 = -1
			If iKey6 > -1
				{
				sLabel := sPrefix "6_" iKey6
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey6 = 0
						GoTo Numb6
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb6:
				Old6 = %iKey6%
				StreamLabel := sPrefix "6_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			iKey7 := NumGet(uData, 7, "UChar")	
			If iKey7 = %Old7%
					iKey7 = -1
			If iKey7 > -1
				{
				sLabel := sPrefix "7_" iKey7
				Gui, Submit, NoHide
				If No0 = 1
					{
					If iKey7 = 0
						GoTo Numb7
					}
				If Stat = 1
					GuiControl, , Edit1, %sLabel%:
				Numb7:
				Old7 = %iKey7%
				StreamLabel := sPrefix "7_" 
				If Stream = 1
					GuiControl, , Edit1, %StreamLabel%:
				If IsLabel(StreamLabel)
					Gosub, %StreamLabel%
				}
			If IsLabel(sLabel)
                Gosub, %sLabel%
        }
    }

}
;;;;;;;;;;;;;;;     Gui Subroutine Section     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Exit:
GuiClose:
Gui, Destroy
ExitApp

ShowIPM:
Gui, Show
GuiControl, Focus, Title
Return

Min:
Gui, Hide
Return

WM_LBUTTONDOWN()
	{
	PostMessage, 0xA1, 2
	}

^Up::
Reload:
Run, C:\Documents and Settings\Rich\Desktop\AHK\Test Scripts\Save & Launch Current NP++ Script\Save&Launch NP++.ahk
Return

AddSub:
Gui, Submit, NoHide
If Edit1 = 
	{
	GuiControl, , Edit1, Please add a label.
	Return
	}
If Edit1 = Please add a label.
	Return
If Edit2 =
	{ 
	GuiControl, , Edit2, Please add a subroutine.
	Return
	}
If Edit2 = Please add a label.
	Return
SR = %Edit1%`n%Edit2%`n
FileAppend, %SR%, %A_WorkingDir%\ShuttlePro Input Monitor.ahk
Sleep, 250
Run, ShuttlePro Input Monitor.ahk
Return
Help:
IfWinExist, I. M. Help
	Return
HelpText = 
(Join
The Shuttle Pro input monitor is a copy of TheGoods' "AHKHID" scripts.`n
http://www.autohotkey.com/forum/viewtopic.php?t=41397`n
and an extension of "Other HID Devices"`n
http://www.autohotkey.com/forum/viewtopic.php?t=67522`n`n
The main difference with this script is instead of choosing one byte number to receive
 data from, the byte number is included as part of the g-label allowing all bytes to be
 used simultaneously.  This also allows the use of only the byte number as the label
 and passing the byte's value as a parameter for instance to use as a volume control.
 An example is included at the top of the subroutine section.`n`n
Usage,`n
The Input Monitor starts minimized to the system tray.  Right click on the AHK icon and 
 select "Show Input Monitor" to show the window.`n`n
The top edit window will display the labels generated by the Shuttle Pro.  Each buttons
 gives a number when pressed and 0 when released.  To use the pressed label check the "No
Zero" box.  Otherwise only the 0 label will be displayed.  The 0 label can be used for
 labels such as stopping timers.  For instance two buttons may start fast forward and 
 rewind timers when pressed which are stopped when released.`n`n
Below the label box are "Static Label" and "Streaming Label" radio buttons.`n`n  
Static labels are for buttons or controls which only have an on/off state.  The byte
 number and the bytes' value are both used in the label.`n`n
Streaming labels use only the byte number in the label and the bytes' value is passed as
 a parameter to the subroutine.`n`n
The large edit box is for adding subroutines.  Clicking the "Add Subroutine" button copies
 the label and subroutine to the bottom of the script and restarts it making the subroutine
 imediatly available for use.
)
Gui, 2:Font, s16 , Impact
Gui, 2:Add, Edit, w50 Hidden vHideEdit
Gui, 2:Add, Text, x20 y5 w370 Center vG2title, Shuttle Pro I. M. Help File
Gui, 2:Add, Text, x395 y5 gCloseHelp, X 
Gui, 2:Font, s8 , Arial
Gui, 2:Add, Edit, x5 y35 w400 r26, %HelpText%
Gui, 2:-Caption +0x400000
WinGetPos, IMX, IMY, , , I. M. 
yPos := imy+230
Gui, 2:Show, x%IMX% y%yPos% h410 w410,I. M. Help
GuiControl, 2:Focus, HideEdit
Return

CloseHelp:
Gui, 2:Destroy
Return

;;;;;;;;;;;;;;;     Start Subroutine Section     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
Example of using byte number as a label and it's value as a parameter.
Default_2_:  ; Change Windows master volume with the scroll wheel.
SoundSet, %iKey2%, MASTER , VOLUME
Return
*/

