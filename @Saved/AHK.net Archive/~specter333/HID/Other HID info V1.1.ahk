#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Gui, Add, Tab2, Buttons vseltab gseltab, Basic|Advanced
Gui, Add, ListView, x16 y40 w470 NoSortHdr LV0x10 Checked Grid AltSubmit vlvwOther gLV_Event, Name|Vendor ID
|Product ID|Version Number|Usage Page|Usage

;Set up the constants
AHKHID_UseConstants()

;Get count
iCount := AHKHID_GetDevCount()


;Retrieve info for each device
Loop %iCount% {
    
    HID0 += 1
    
    ;Get device handle, type and name
    HID%HID0%_Handle := AHKHID_GetDevHandle(HID0)
    HID%HID0%_Type   := AHKHID_GetDevType(HID0)
    HID%HID0%_Name   := AHKHID_GetDevName(HID0)
    
    ;Get device info
    
If (HID%HID0%_Type = RIM_TYPEHID) {
        HID%HID0%_VendorID      := AHKHID_GetDevInfo(HID0, DI_HID_VENDORID)
        HID%HID0%_ProductID     := AHKHID_GetDevInfo(HID0, DI_HID_PRODUCTID)
        HID%HID0%_VersionNumber := AHKHID_GetDevInfo(HID0, DI_HID_VERSIONNUMBER)
        HID%HID0%_UsagePage     := AHKHID_GetDevInfo(HID0, DI_HID_USAGEPAGE)
        HID%HID0%_Usage         := AHKHID_GetDevInfo(HID0, DI_HID_USAGE)
    }
}

;Add to listviews according to type
Loop %HID0% {

If (HID%A_Index%_Type = RIM_TYPEHID) {
        Gui, ListView, lvwOther
        LV_Add("", HID%A_Index%_Name, HID%A_Index%_VendorID, HID%A_Index%_ProductID, HID%A_Index%_VersionNumber
        , HID%A_Index%_UsagePage, HID%A_Index%_Usage)
    }
}

Gui, Tab, 1	

Gui, ListView, lvwOther
Loop 6
    LV_ModifyCol(A_Index, "AutoHdr")
LV_ModifyCol(1, 139)


Gui, Add, GroupBox, w40 h40 Center, +#
Gui, Add, GroupBox, x+5 w90 h40, Prefix
Gui, Add, GroupBox, x+5 w95 h40, Key Pressed
Gui, Add, GroupBox, x+5 w35 h40 Center, -Up
Gui, Add, GroupBox, x+5 w190 h40,  Label to Use in Script

Gui, Add, Edit, xm+11 yp+15 w30 h40 R1 voffset goffset,
Gui, Add, UpDown, vMyUpDown Range0-7, 1
Gui, Add, Edit, x+15 w80 vprefix gprefix, 
Gui, Add, Edit, x+15 w85 ReadOnly vkey, 
Gui, Add, CheckBox, xp+105 yp+3 w21 Checked vboxNo0 gNo0, 
Gui, Add, Edit, xp+35 yp-3 w180 ReadOnly vlabel,
Gui, Add, Edit, xm+5 y+10 w470 h100 vcomp, Use this box to add your commands then copy/paste into your script.
Gui, Add, Edit, xp yp w470 h100 ReadOnly Hidden vhelpbox, 

Gui, Add, Button, x375 y5 Hidden vexporthelp gexporthelp, Export Help File
Gui, Add, Button, x467 y5 vhelp ghelp, ?
Gui, Add, Button, x467 y5 Hidden vclosehelp gclosehelp, ?

Gui, Tab, 2 
Gui, Font, s6, arial
Gui, Add, GroupBox, xm+5 y+10 h40 w35 Section Center, Byte 0
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 1
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 2
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 3
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 4
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 5
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 6
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 7
Gui, Add, GroupBox, x+5 h40 w120 , Hex Data

Gui, Font, s8
Gui, Add, Edit, xm+7 yp+15 w30 h30 R1 ReadOnly vbytebox0, 
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox1
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox2
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox3
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox4
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox5
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox6
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox7
Gui, Add, Edit, x+10 w115 h30 R1 ReadOnly vhexd, 

Gui, Add, ListView, xm y+5 w475 r12 -Hdr vlvlog gLVrcClick, Byte0|Byte1|Byte2|Byte3|Byte4|Byte5|Byte6|Byte7|Hex Data
;OnMessage(0xA9, "LVrcClick")

Gui, Add, Button, xm y+10 gclearlog, Clear Log
Gui, Add, Button, x+5 Disabled vexportlog gexportlog, Export Log
Gui, Add, Groupbox, x+5 yp-7 w90 h32, 
Gui, Add, Checkbox, xp+5 yp+13 vactlog glogstate, Activate Log
Gui, Font, s7
Gui, Add, Groupbox, x+10 yp-13 w247 h32, ^#!Space:: For ahk_class of active window
Gui, Add, Edit, xp+5 yp+13 w237 h16 ReadOnly vahkclass, 
Gui, Font, s8
Gui, Show, y0, Other HID Info v1.1

Gui, Submit, NoHide
Gui, +LastFound
hGui := WinExist()
GoSub, helpboxtext
;Intercept WM_INPUT messages
WM_INPUT := 0xFF
OnMessage(WM_INPUT, "InputMsg")

;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)
register:
r := AHKHID_Register(up%A_EventInfo%, usage%A_EventInfo%, hGui, RIDEV_INPUTSINK)

;Prefix
sPrefix := prefix
Return


InputMsg(wParam, lParam) {
    Local devh, iKey, sLabel
    Critical

    ;Get handle of device
    devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)
    
    If (devh <> -1) ;Check that it is my remote
        And (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = vid)
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = pid)
        And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = ver)
      {
       
        ;Get data
        iKey := AHKHID_GetInputData(lParam, uData)
        
        ;Check for error
        If (iKey <> -1) 
		
		{
           
		   ;Get keycode 
            iKey := NumGet(uData,%oset%, "UChar")
            
             
                     
           
         
         ;Call the appropriate sub if it exists
            sLabel := sPrefix iKey
            If IsLabel(sLabel)
                Gosub, %sLabel%
            If BoxNo0 = 0
			GoTo KeyLabel
            If iKey = 0
               Return
			KeyLabel:
            Guicontrol, , prefix, %sPrefix%
            Guicontrol, , key, %iKey%
            Guicontrol, , label, %sLabel%: 
			Guicontrol, , comp, %sLabel%:`n`nReturn
		   
			iKey0 := NumGet(uData, 0, "UChar")
             	Guicontrol, , bytebox0, %iKey0%
							
            iKey1 := NumGet(uData, 1, "UChar")
				Guicontrol, , bytebox1, %iKey1%
							
			iKey2 := NumGet(uData, 2, "UChar")
				Guicontrol, , bytebox2, %iKey2% 
							
			iKey3 := NumGet(uData, 3, "UChar")
				Guicontrol, , bytebox3, %iKey3% 
			
			iKey4 := NumGet(uData, 4, "UChar")
				Guicontrol, , bytebox4, %iKey4% 
								
			iKey5 := NumGet(uData, 5, "UChar")
				Guicontrol, , bytebox5, %iKey5% 
						
			iKey6 := NumGet(uData, 6, "UChar")
				Guicontrol, , bytebox6, %iKey6% 
							
			iKey7 := NumGet(uData, 7, "UChar")
				Guicontrol, , bytebox7, %iKey7% 
							
			
			
			r := AHKHID_GetInputData(lParam, uData)
			GuiControl,, hexd, % "" ;%
			. Bin2Hex(&uData, r)
			
			IfWinActive , Other HID Info v1.1
				If startlog = yes
					{
					Gui, ListView, lvlog
					RowNumber := LV_Add(Col1, iKey0, iKey1, iKey2, iKey3, iKey4, iKey5, iKey6, iKey7, hexd)
					LV_Modify(RowNumber, "Vis")
					}
            Return
         
      }
    }
}
Return

;AHKHIDGUI===========
exit:
GuiClose:
Gui, Destroy
ExitApp
Return

No0:
Gui, Submit, NoHide
Return

offset:
oset = offset
Return

prefix:
Gui, Submit, NoHide
GoTo, register
Return

seltab:
Gui, Submit, NoHide
If seltab <> Advanced
	{
	startlog = no
	GuiControl, , actlog, 0
	}

If seltab = Advanced
	GuiControl, Focus, log
Return

logstate:
Gui, Submit, NoHide
If actlog = 1
	{
	GuiControl, Disable, exportlog
	GuiControl, Focus, log
	startlog = yes
	}
Else If actlog = 0
	{
	GuiControl, Enable, exportlog
	startlog = no
	}
Return

clearlog:
Gui, ListView, lvlog
LV_Delete() 
GuiControl, Disable, exportlog
Return

^#!Space::
WinGetClass, awinclass, A
GuiControl, , ahkclass, %awinclass%
Return

Reload:
Reload
Return

LV_Event:
Gui, ListView, lvwOther
Critical
;up4 := 

	If InStr(ErrorLevel, "c", true) 
		{
		AHKHID_Register( up%A_EventInfo%, usage%A_EventInfo%, hGui, RIDEV_REMOVE)
		up%A_EventInfo% :=
		usage%A_EventInfo% :=
		Return
        }
	
	If InStr(ErrorLevel, "C", true) 
		{
		LV_GetText(vid, A_EventInfo, 2)
		LV_GetText(pid, A_EventInfo, 3)
		LV_GetText(ver, A_EventInfo, 4)
		LV_GetText(up%A_EventInfo%, A_EventInfo, 5)
		LV_GetText(usage%A_EventInfo%, A_EventInfo, 6)
		Goto register
        }

Return


GuiSize:
    Anchor("MyTabs", "wh")
    Anchor("lvwKeyb", "wh")
    Anchor("lvwMouse", "wh")
    Anchor("lvwOther", "wh")
Return

;Anchor by Titan, adapted by TheGood
;http://www.autohotkey.com/forum/viewtopic.php?p=377395#377395
Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, gl = 0, gpi, gw, gh, z = 0, k = 0xffff, ptr
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), ptr := A_PtrSize ? "Ptr" : "UInt", z := true
	If (!WinExist("ahk_id" . i)) {
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	VarSetCapacity(gi, 68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), ptr, &gi)
		, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
	If (gp != gpi) {
		gpi := gp
		Loop, %gl%
			If (NumGet(g, cb := gs * (A_Index - 1)) == gp, "UInt") {
				gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
				Break
			}
		If (!gf)
			NumPut(gp, g, gl, "UInt"), NumPut(gw := giw, g, gl + 4, "Short"), NumPut(gh := gih, g, gl + 6, "Short"), gl += gs
	}
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	Loop, %cl%
		If (NumGet(c, cb := cs * (A_Index - 1), "UInt") == i) {
			If a =
			{
				cf = 1
				Break
			}
			giw -= gw, gih -= gh, as := 1, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, cw := dw, dw := NumGet(c, cb + 8, "Short"), ch := dh, dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "UInt", 0, "Int", dx, "Int", dy
				, "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	bx := NumGet(gi, 48, "UInt"), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52, "UInt")
	If cf = 1
		dw -= giw - gw, dh -= gih - gh
	NumPut(i, c, cb, "UInt"), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}

Bin2Hex(addr,len) {
    Static fun, ptr 
    If (fun = "") {
        If A_IsUnicode
            If (A_PtrSize = 8)
                h=
				( Join
				4533c94c8bd14585c07e63458bd86690440fb60248ffc2418bc9410fb6c0c0e8043c090fb6c00f9
				7c14180e00f66f7d96683e1076603c8410fb6c06683c1304180f8096641890a418bc90f97c166f7
				d94983c2046683e1076603c86683c13049ffcb6641894afe75a76645890ac366448909c3
				)
            Else h=
				( Join
				558B6C241085ED7E5F568B74240C578B7C24148A078AC8C0E90447BA090000003AD11BD2F7DA66F7
				DA0FB6C96683E2076603D16683C230668916240FB2093AD01BC9F7D966F7D96683E1070FB6D06603
				CA6683C13066894E0283C6044D75B433C05F6689065E5DC38B54240833C966890A5DC3
				)
        Else h=558B6C241085ED7E45568B74240C578B7C24148A078AC8C0E9044780F9090F97C2F6DA80E20702D1240F80C2303C090F97C1F6D980E10702C880C1308816884E0183C6024D75CC5FC606005E5DC38B542408C602005DC3
			 
        VarSetCapacity(fun, StrLen(h) // 2)
        Loop % StrLen(h) // 2 ;%
            NumPut("0x" . SubStr(h, 2 * A_Index - 1, 2), fun, A_Index - 1, "Char")
        ptr := A_PtrSize ? "Ptr" : "UInt"
        DllCall("VirtualProtect", ptr, &fun, ptr, VarSetCapacity(fun), "UInt", 0x40, "UInt*", 0)
    }
    VarSetCapacity(hex, A_IsUnicode ? 4 * len + 2 : 2 * len + 1)
    DllCall(&fun, ptr, &hex, ptr, addr, "UInt", len, "CDecl")
    VarSetCapacity(hex, -1) ; update StrLen
    Return hex
}

LVrcClick:
LV_GetText(ToCB1, A_EventInfo, 1)
LV_GetText(ToCB2, A_EventInfo, 2) 
LV_GetText(ToCB3, A_EventInfo, 3) 
LV_GetText(ToCB4, A_EventInfo, 4) 
LV_GetText(ToCB5, A_EventInfo, 5) 
LV_GetText(ToCB6, A_EventInfo, 6) 
LV_GetText(ToCB7, A_EventInfo, 7) 
LV_GetText(ToCB8, A_EventInfo, 8) 
LV_GetText(ToCB9, A_EventInfo, 9) 
clipboard = %ToCB1%`t%ToCB2%`t%ToCB3%`t%ToCB4%`t%ToCB5%`t%ToCB6%`t%ToCB7%`t%ToCB8%`t%ToCB9%
Return

exportlog:
Gui, Submit, NoHide
Gui, ListView, lvlog
GuiControl, Disable, exportlog
IfExist, %A_WorkingDir%/Temp HID Log File.txt
	FileDelete, %A_WorkingDir%/Temp HID Log File.txt

RowNumber = 0  
Loop % LV_GetCount()
	{
	RowNumber = %A_Index%
    LV_GetText(Text1, RowNumber, 1)
	LV_GetText(Text2, RowNumber, 2)
	LV_GetText(Text3, RowNumber, 3)
	LV_GetText(Text4, RowNumber, 4)
	LV_GetText(Text5, RowNumber, 5)
	LV_GetText(Text6, RowNumber, 6)
	LV_GetText(Text7, RowNumber, 7)
	LV_GetText(Text8, RowNumber, 8)
	LV_GetText(Text9, RowNumber, 9)
    FileAppend , %Text1%`t%Text2%`t%Text3%`t%Text4%`t%Text5%`t%Text6%`t%Text7%`t%Text8%`t%Text9%`n, %A_WorkingDir%\Temp HID Log File.txt
	}
logname = HID Log %A_Now%
FileSelectFile, New_Log, s24, %A_Desktop%\%logname%, Save HID Log File, *.txt 
FileCopy, Temp HID Log File.txt, %New_Log%.txt, 1
FileDelete, %A_WorkingDir%/Temp HID Log File.txt
Return

help:
Gui, Submit, NoHide
restorecomp = %comp%
GuiControl, Hide, help
GuiControl, Hide, comp
GuiControl, Show, closehelp
GuiControl, Show, helpbox
GuiControl, Show, exporthelp
Return

closehelp:
GuiControl, Hide, closehelp
GuiControl, Hide, helpbox
GuiControl, Hide, exporthelp
GuiControl, Show, help
GuiControl, Show, comp
GuiControl, ,comp, %restorecomp%
Return


exporthelp:
Gui, Submit, NoHide
IfExist, Other HID Info v1.0.txt
	FileDelete, Other HID Info v1.0.txt
GuiControl, Hide, exporthelp
FileAppend , %helpbox%, Other HID Info.txt
Return

helpboxtext:
GuiControl, , helpbox,
(
**  Click "?" again to return to where you previously were.  **

For easier viewing, click "Export Help File to create a text file named 
"Other HID Info.txt" in the same directory as this script.

Other HID Info v1.0   Based on the AHK HID library created by "TheGood"
http://www.autohotkey.com/forum/viewtopic.php?t=41397 
Adapted by Specter333 from his example scripts.

///
Quick Start:
1. Run Other HID Info.
2. Check the box corresponding to your HID device.
3. Activate controls on your HID device.
4. Get the corresponding codes from the “Key Pressed” box.
///

Other HID Info is designed to let you view information received from Human Interface Devices
“Other” than mice and keyboards.  This includes RF Remote Controls, Joysticks, Tablet Stylus,
Game Controllers and more.  The information received can then be used in AutoHotKey scripts
to execute commands.

Basic Page:
This page supplies all the basic information we need to get the device codes and turn them
into g-labels for AHK Scripts.  When opened Other HID Info scans for any “Other HID” devices
and list them in the HID Devices window of the “Basic” page. 
Listed in the box is:
1. Device Name as seen by the computer.
2. Vendor ID
3. Product ID
4. Version Number.  These three help us identify the device.
5. Usage Page
6. Usage.  Think of these two as the channels the device sends information on.
Together the “Usage Page” and the “Usage” are referred to as the “TLC”. (I don’t know why.)

Beneath the HID Device window is a row of controls.

1. +# - This is the byte being monitored for data. More on this in “Using Other HID Info”.   

2. Prefix - Optional user input box.  More in the “Making g-labels context sensitive” section.

3. Key Pressed - The data received from the control on the HID device.

4. -Up - Blocks events that = “0" more on this below in “Using Other HID Info”.

5. Label to Use in Script - A complete g-label to cut and paste into your script.

Beneath that is the “Work Box” which is the where this help file appears.  The beginnings of 
an AHK command, the “g-label” and “Return” are created here.  You can input the rest of your 
command in this box then copy and paste it to your AHK Script.  If you had information in 
this box when you clicked the “?” button it will be restored when you click “?” again.


Using Other HID Info:
Start by checking the box in front of the device your wanting to use.  Devices with identical 
“Vendor ID/Product ID/Version Number” entries  means the computer sees this one device as 
more than one.  Each control on the device will be assigned to one of the “TLC” channels so 
you will likely need to check all that match to receive all the controls.  It may be helpful 
to check one at a time to see which controls are assigned to which “TLC”.  There may be 
instances where a single controls send different data on more than one “TLC”.

Activate the controls on the HID device, the number of the control activated will appear in 
the “Key Pressed” box.  If you don’t receive data from the controls switch to the “Advanced” 
page.  If you see the data on a byte other than 1 switch back to the “Basic” page and change 
the number in the “+#” box to the number of the byte receiving data.  

The “Prefix” box is to make your controls context sensitive.  This is a brilliant design by 
“TheGood” to have AHK script commands only run when the corresponding application is in 
focus.  For example, say you have the volume buttons on your remote assigned as hotkeys to 
control the volume of sound effects in a game and while playing you listen to music on VLC 
Media Player.  Your prefixes could be “Game_” and “VLC_”.  When your game is in focus 
pushing the volume buttons on your remote would change the volume of the sound effects in 
the game but not change the volume of the music in VLC.  When VLC is in focus the opposite 
would be true.  If neither the game or VLC were in focus pushing the volume buttons would 
not change anything.  A copy of “TheGoods” script for using Remote Controls that are seen 
as “Other HID Devices” is at the bottom of this help file.  

The “Key Pressed” box is the exact data you are receiving from the HID device in decimal 
format. For example buttons are usually a two or three digit number.  

The “-Up” box blocks the “Up”data sent from the control of the HID device from being logged.  
A button press such as from a remote or joystick sends two pieces of data the “Down” event 
which is the number needed to create the g-label and the “Up” event which is usually “0".  
If this is not checked the controls number in the “Key Pressed” box and the “Label to Use 
in Script” box is immediately replaced with a “0".  Checking it leaves the number from the 
“Down” event in these boxes so we can complete the g-labels.  If your monitoring a dynamic 
control such as a joystick you will need to uncheck this box to see all the information it sends.

The “Label to Use in Script” box takes the information from the “Prefix” box and the 
“Key Pressed” box and adds a “:” to make a complete g-label that can be copied and pasted 
into your script.  This label and the “Return” command is also copied into the “Work Box” 
where you can complete the AHK command before copying to your script.

Advanced Page:
The Advanced page contains two types of data logs.  The first are 9 “RTD” (Real Time Data) 
display boxes across the top labeled “Byte 0 to Byte 7" and “Hex Data”.  “Byte 0 to Byte 7" 
is real time data being received from the HID device in decimal format.  “Hex Data” is the 
data before being converted to decimal. These boxes also respond to the “-Up” check box on 
the first page meaning they don’t log data that = “0" when the “-Up” box is checked.  However
they do display a "0" if they receive no data. They are useful for finding what byte your 
device is sending data on.  If data is being received on a byte other than 1 set the “+#” 
box to that byte to create your g-labels.  

The second log captures the HID device data in a scrolling edit box.  This is useful for finding
if the data from multiple bytes is related.  To start the log check “Activate Log” at the bottom
of the page, uncheck to stop logging.  If you switch back to the “Basic” page logging is 
automatically stopped.  Checking “Activate Log” again will append new data to the current log.  
Click the “Clear Log” button to start a new log.  Double clicking a row will copy that row's
contents to the clipboard.  Once stopped you may click the “Export Log” button to save the 
current data to a text file.  A prompt will ask you for the name and location to save the log
file.  A name including the current date and time is supplied but can be changed.

More complex devices will send data on several bytes simultaneously and you may need the 
data from two bytes to comprise a complete command.  

For example a “Steering Wheel” controller will likely send “Wheel Turning” data on two bytes.  
Turning the wheel from full left to full right may cycle byte one from 0 to 255 four times for 
“Fine Control” while byte two counts from 0 to 3 for “Course Control.  If you get the labels for 
byte two you would receive a label of  “0" (uncheck “-Up” to received a “0" event) for the first 
quarter of the turn, “1" for the second quarter, “2" for the third quarter and “3" for the far 
right quarter turn.  If you combine these with the data from byte one you have four controls 
each containing 255 controls.

( byte2:
If byte1 = 57)
For more practical applications try the script “Joystick Customizer” by “justcallmedrago”.
http://www.autohotkey.com/forum/viewtopic.php?t=11710

The last item on the advanced page is a box to retrieve the ahk_class of the active window.  
The class information is needed when making context sensitive labels.  
Use the hotkey Control+Win+Alt+Space (^#!space::) to insert the current active window’s 
class then copy and paste it into your script.  The Other HID Info can be minimized while
obtaining the class data.

Making g-labels context sensitive.
A complete g-label automatically appears in the “Label to Use in Script” box and in the 
“Work Box”.  It is a combination of any entry in the “Prefix” box, the information in the 
“Key Pressed” box and “:”.  If you don’t need context sensitive labels only the “Key Pressed” 
and “:” are needed for example “205:” is a complete g-label.  However if you want the g-label 
to only function when a certain application is in focus then enter a “Prefix” to identify that 
application.  For example, to control VLC Media Player you could enter the prefix “VLC_” and 
the complete g-label would appear like  “VLC_205:”.   



This is a script provided by “TheGood” in the AHKHID topic on the AutoHotKey forums.
http://www.autohotkey.com/forum/viewtopic.php?t=41397&start=1

It is to map the buttons of a Media Center Remote for use on non Media Center computers.  
The sections between rows of “;” need to be customized for your remote with the information 
and g-labels from the “Basic” page of Other HID Info.  The "Prefix Loop" ahk_class informatin
may be obtained from the advanced page.

;Must be in auto-execute section if you want to use the constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AHKHID_UseConstants() ;If AHKHID.ahk is in your library use this line as is.
; If you want to call the script from the directory your script is in or a particular directory
; you would use something like this.
;#Include C:\enter your directory path here\AHKHID.ahk 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Create GUI to receive messages
Gui, +LastFound
hGui := WinExist()

;Intercept WM_INPUT messages
WM_INPUT := 0xFF
OnMessage(WM_INPUT, "InputMsg")

;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
r := AHKHID_Register(65468, 137, hGui, RIDEV_INPUTSINK) ;Replace 65468 with your device's Usage
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
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 1118) ;Replace these three
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 109) ;numbers with your 
        And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = 272) { ;devices numbers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
        ;Get data
        iKey := AHKHID_GetInputData(lParam, uData)
       
        ;Check for error
        If (iKey <> -1) {
           
            ;Get keycode 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
            iKey := NumGet(uData, 1, "UChar") ;If you had to change "+#" to something other  
			                                  ; than 1 it must be changed here too.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	           
            ;Call the appropriate sub if it exists
            sLabel := sPrefix iKey
            If IsLabel(sLabel)
                Gosub, %sLabel%
        }
    }
}
; From here down replace these with your g-labels and commands.  These are "TheGoods" examples.
; Remeber the word "Default_" is valid for a prefix and will be active any time an application 
; for one of your other label is not in focus.  The first example can be used to open VLC Media Player 
; then the "VLC_" labels can control it.
;
Default_15:
	Run, C:\Program Files\VideoLAN\VLC\vlc.exe
Return

VLC_15: ;More
    SendInput f ;Toggle fullscreen
Return

VLC_18: ;Channel Up
    SendInput ^{Up}
Return

VLC_19: ;Channel Down
    SendInput ^{Down}
Return

VLC_21: ;Rewind
    SendInput !{Left}
Return

VLC_27: ;Previous Track
    SendInput p
Return

VLC_22: ;Play
    SendInput q
Return

VLC_24: ;Pause
    SendInput {Space}
Return

VLC_25: ;Stop
    SendInput s
Return

VLC_20: ;Forward
    SendInput !{Right}
Return

VLC_26: ;Next Track
    SendInput n
Return

MPC_15: ;More
    SendInput !{Enter} ;Toggle fullscreen
Return

MPC_18: ;Channel Up
    SendInput {Up}
Return

MPC_19: ;Channel Down
    SendInput {Down}
Return

MPC_21: ;Rewind
    SendInput !{Left}
Return

MPC_20: ;Forward
    SendInput !{Right}
Return

MPC_27: ;Previous Track
    SendInput !{End}
Return

MPC_26: ;Next Track
    SendInput !{Home}
Return

MPC_22: ;Play
    SendInput !p
Return

MPC_24: ;Pause
    SendInput {Space}
Return

MPC_25: ;Stop
    SendInput !s
Return
)

Return
