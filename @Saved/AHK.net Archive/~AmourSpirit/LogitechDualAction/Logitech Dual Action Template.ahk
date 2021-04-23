; Logitech Dual Action Gamepad Template for AutoHotkey
; By Paul Moss
; February 28, 2011
; ver 0.1
; Resourece: http://www.autohotkey.com/forum/viewtopic.php?t=41397&postdays=0&postorder=asc&start=0
#SingleInstance

;Add in #Includes Statement to AHKHID.ahk if it is not in your library foldery
; Can Be located at http://www.autohotkey.net/~TheGood/AHKHID/AHK_L/AHKHID.ahk
AHKHID_UseConstants() ; Comment this line out if you use the #Include AHKHID.ahk

; Byte 0 seems to be unused
; Byte 1 and 2 are for left joystick, Byte 5 is for POV this is
; reversed with shift On, Byte 1 and 2 are for POV and Byte 5 is Left Joystick
; Byte 3 and 4 are for right joystick
; Byte 5 also used for buttons 1-4
; Byte 6 buttons 5-10
; Byte 7 Shift button

Gui, Add, Text, x2 y0 w340 h30 , % "Logitech Dual Action Gamepad output.`nStart Pushing Buttons!"
Gui, Add, Text, x12 y40 w340 h20, % "Output"
Gui, Add, Edit, x12 y60 w320 h240 vJOutput ReadOnly, % ""

Gui, Font, s6, arial
Gui, Add, GroupBox, xm+5 y+10 h40 w35 Section Center, Byte 0
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 1
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 2
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 3
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 4
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 5
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 6
Gui, Add, GroupBox, x+5 h40 w35 Center, Byte 7

Gui, Font, s8
Gui, Add, Edit, xm+7 yp+15 w30 h30 R1 ReadOnly vbytebox0, 
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox1
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox2
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox3
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox4
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox5
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox6
Gui, Add, Edit, x+10 w30 h30 R1 ReadOnly vbytebox7

Gui, Add, Button, x232 y+10 w100 h30 gBtnOk Default, % "OK"

Gui, Show, w345 h400, % "Logitech Dual Action Gamepad Output"

Gui, Submit, NoHide
Gui, +LastFound
hGui := WinExist()

;Button Flags
BTN_01 := 0x10   ; Byte 5 = 16, 1
BTN_02 := 0x20   ; Byte 5 = 32, 2
BTN_03 := 0x40   ; Byte 5 = 64, 3
BTN_04 := 0x80   ; Byte 5 = 128, 4

BTN_05 := 0x01   ; Byte 6 = 1, 5
BTN_06 := 0x02   ; Byte 6 = 2, 6
BTN_07 := 0x04   ; Byte 6 = 4, 7
BTN_08 := 0x08   ; Byte 6 = 8, 8
BTN_09 := 0x10   ; Byte 6 = 16, 9
BTN_10 := 0x20   ; Byte 6 = 32, 10
BTN_Shift := 0x08

ShiftON := false    ; Var to hold if the shift is off or on for the joystick
LastShiftON := false
POVPos := 8
LastPOVPos := 8
LastLeftRightPos1 := 128
LeftRightPos1 := 128
LastUpDownPos1 := 128
UpDownPos1 := 128

LastLeftRightPos2 := 128
LeftRightPos2 := 128
LastUpDownPos2 := 128
UpDownPos2 := 128

;Intercept WM_INPUT messages
WM_INPUT := 0xFF
OnMessage(WM_INPUT, "InputMsg")

;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)
r := AHKHID_Register(1, 4, hGui, RIDEV_INPUTSINK )
Return

Button01: ; 1
   ShiftON ? AddInput("Pressed Button Shift 1"):AddInput("Pressed Button 1")
return

Button02: ; 2
   ShiftON ? AddInput("Pressed Button Shift 2"):AddInput("Pressed Button 2")
return

Button03: ; 3
   ShiftON ? AddInput("Pressed Button Shift 3"):AddInput("Pressed Button 3")
return

Button04: ; 4
   ShiftON ? AddInput("Pressed Button Shift 4"):AddInput("Pressed Button 4")
return

Button05: ; 5
   ShiftON ? AddInput("Pressed Button Shift 5"):AddInput("Pressed Button 5")
return

Button06: ; 6
   ShiftON ? AddInput("Pressed Button Shift 6"):AddInput("Pressed Button 6")
return

Button07: ; 7
   ShiftON ? AddInput("Pressed Button Shift 7"):AddInput("Pressed Button 7")
return

Button08: ; 8
   ShiftON ? AddInput("Pressed Button Shift 8"):AddInput("Pressed Button 8")
return

Button09: ; 9
   ShiftON ? AddInput("Pressed Button Shift 9"):AddInput("Pressed Button 9")
return

Button10: ; 10
   ShiftON ? AddInput("Pressed Button Shift 10"):AddInput("Pressed Button 10")
return

ButtonShift: ; Mode
   ShiftON ? AddInput("Shift Button ON"):AddInput("Shift Button OFF")
return

PovPosition:
   AddInput("POV Position:" . POVPos)
return

LeftRightMovement1:
   ; 128 is center postion but sometime the joystick might return to 127 instead etc
   ; so it would not hurt to relax the value a little and not respond directly at 128
   
   if (LeftRightPos1 < 120) {
      AddInput("Moved Left")
      return
   }
   if (LeftRightPos1 > 136) {
      AddInput("Moved Right")
   }
return

UpDownMovement1:
   ; 128 is center postion but sometime the joystick might return to 127 instead etc
   ; so it would not hurt to relax the value a little and not respond directly at 128
   if (UpDownPos1 < 120) {
      AddInput("Moved Up")
      return
   }
   if (UpDownPos1 > 136) {
      AddInput("Moved Down")
   }
return

LeftRightMovement2:
   ; 128 is center postion but sometime the joystick might return to 127 instead etc
   ; so it would not hurt to relax the value a little and not respond directly at 128
   
   if (LeftRightPos2 < 120) {
      AddInput("Moved Left")
      return
   }
   if (LeftRightPos2 > 136) {
      AddInput("Moved Right")
   }
return

UpDownMovement2:
   ; 128 is center postion but sometime the joystick might return to 127 instead etc
   ; so it would not hurt to relax the value a little and not respond directly at 128
   if (UpDownPos2 < 120) {
      AddInput("Moved Up")
      return
   }
   if (UpDownPos2 > 136) {
      AddInput("Moved Down")
   }
return

BtnOk:
GuiClose:
ExitApp


InputMsg(wParam, lParam) {
    Local devh, iKey, j , ButSet02, ThrottleFlag, CurrentSensorON
   Critical   ;Or otherwise you could get ERROR_INVALID_HANDLE

   ;Get device type
    j := AHKHID_GetInputInfo(lParam, II_DEVTYPE) 

   If (j = RIM_TYPEHID) {
      ;Get handle of device
        devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)
        If (devh <> -1) ;Check that it is Sidewinder
        And (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 1133)
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 49686)
        And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = 768) {
       
            ;Get data
            iKey := AHKHID_GetInputData(lParam, uData)

            ;Check for error
            If (iKey <> -1) {
            ; Get keycode (located at the 1st byte)
            Byte0 := NumGet(uData, 0, "UChar")
            
            ; Get keycode (located at the 2nd byte)
            Byte1 := NumGet(uData, 1, "UChar")
            
            ; Get keycode (located at the 3th byte)
            Byte2 := NumGet(uData, 2, "UChar")
            
            ; Get keycode (located at the 4th byte)
            Byte3 := NumGet(uData, 3, "UChar")
            
            ; Get keycode (located at the 5th byte)
            ; Values range from 8-15, 0-7
            Byte4 := NumGet(uData, 4, "UChar")
            
            ; Get keycode (located at the 6th byte)
            ; buttons 1- 4
            Byte5 := NumGet(uData, 5, "UChar")
            
            ;Get keycode (located at the 8th byte)
            ; Buttons 5-10
            Byte6 := NumGet(uData, 6, "UChar")
            
            ;Get keycode (located at the 8th byte)
            ; Buttons 5-10
            Byte7 := NumGet(uData, 7, "UChar")
            
            ; This section can be commeted out
            Guicontrol, , bytebox0, %Byte0%
            Guicontrol, , bytebox1, %Byte1%
            Guicontrol, , bytebox2, %Byte2%
            Guicontrol, , bytebox3, %Byte3%
            Guicontrol, , bytebox4, %Byte4%
            Guicontrol, , bytebox5, %Byte5%
            Guicontrol, , bytebox6, %Byte6%
            Guicontrol, , bytebox7, %Byte7%
            ; End section can be commeted out
         
            if (IsFlagSet(Byte5,BTN_01 )) { ; Button 1
               Gosub, Button01
            }
            if (IsFlagSet(Byte5,BTN_02 )) {   ; Button 2
               Gosub, Button02
            }
            if (IsFlagSet(Byte5,BTN_03 )) {   ; Button 3
               Gosub, Button03
            }
            if (IsFlagSet(Byte5,BTN_04 )) {   ; Button 4
               Gosub, Button04
            }
            if (IsFlagSet(Byte6,BTN_05 )) {   ; Button 5
               Gosub, Button05
            }
            if (IsFlagSet(Byte6,BTN_06 )) {   ; Button 6
               Gosub, Button06
            }
            if (IsFlagSet(Byte6,BTN_07 )) {   ; Button 7
               Gosub, Button07
            }
            if (IsFlagSet(Byte6,BTN_08 )) {   ; Button 8
               Gosub, Button08
            }
            if (IsFlagSet(Byte6,BTN_09 )) {   ; Button 9
               Gosub, Button09
            }
            if (IsFlagSet(Byte6,BTN_10 )) {   ; Button 10
               Gosub, Button10
            }

            if (IsFlagSet(Byte7,BTN_Shift )) {   ; Mode Button
               ShiftON := true
               if (LastShiftON <> ShiftON) {
                  LastShiftON := ShiftON
                  Gosub, ButtonShift
               }
            } else {
               ShiftON := false
               if (LastShiftON <> ShiftON) {
                  LastShiftON := ShiftON
                  Gosub, ButtonShift
               }
            }
            POVPos := GetHatPos(Byte5)
            if (POVPos <> LastPOVPos) {
               LastPOVPos := POVPos
               ;POVPos := GetHatPos(Byte5)
               Gosub, PovPosition
            }
            if (ShiftON) {
               
            } else {

            }
            
            LeftRightPos1 := Byte1
            if (LastLeftRightPos1 <> LeftRightPos1) {
               LastLeftRightPos1 := LeftRightPos1
               Gosub, LeftRightMovement1
            }
            UpDownPos1 := Byte2
            if (LastUpDownPos1 <> UpDownPos1) {
               LastUpDownPos1 := UpDownPos1
               Gosub, UpDownMovement1
            }
            
            LeftRightPos2 := Byte3
            if (LastLeftRightPos2 <> LeftRightPos2) {
               LastLeftRightPos2 := LeftRightPos2
               Gosub, LeftRightMovement2
            }
            UpDownPos2 := Byte4
            if (LastUpDownPos2 <> UpDownPos2) {
               LastUpDownPos2 := UpDownPos2
               Gosub, UpDownMovement2
            }
            
            }
        }
   }
   
}

IsFlagSet(varFlags,varTestFlag) {
   if ((varFlags & varTestFlag) > 0)
      return true
   
   return false
}


AddInput(strInput) {
   GuiControlGet JOutput
   strNew := strInput . "`n" . JOutput  
   GuiControl,,JOutput, %strNew%
   return
}
; Gets the Position of the hat based on the flags set.
; The positon may have Button Flags attached to it so we must
; remove the button flags first to get to the actual hat position
GetHatPos(Flags) {
   global
   Flags := Flags & ~BTN_01 ; Remove Flag
   Flags := Flags & ~BTN_02 ; Remove Flag
   Flags := Flags & ~BTN_03 ; Remove Flag
   Flags := Flags & ~BTN_04 ; Remove Flag
   return Flags
}
