#NoEnv
#Include Class_CTLCOLORS.ahk
OnExit, GuiClose
; ----------------------------------------------------------------------------------------------------------------------
LB_SETCURSEL := 0x186
CB_SETCURSEL := 0x14E
Red := "FF0000"
Green := "00C000"
Blue := "0000FF"
Pink := "FF20FF"
; ----------------------------------------------------------------------------------------------------------------------
Gui, Margin, 10, 10
Gui, Add, Radio, vSTDRB1 gSTDRBG hwndRBID1 Checked, Standard Radio 1
CTLCOLORS.Attach(RBID1, "Lime", "")
Gui, Add, Radio, x+55 ym vSTDRB2 gSTDRBG hwndRBID2, Standard Radio 2
Gui, Add, CheckBox, xm vSTDCB1 gSTDCB1 hwndCBID1, Standard CheckBox
CTLCOLORS.Attach(CBID1, "C0C0C0", "Red")
; ----------------------------------------------------------------------------------------------------------------------
Gui, Add, Text, xm w292 h2 +0x1000
; "Faked" RadioButtons -------------------------------------------------------------------------------------------------
; Note: Minimum width and height are font, font size and OS dependend, if you get below the limit, nothing is shown!!!
Gui, Add, Radio, xm w15 h20 gRBG vRB1 Section Group Checked
Gui, Add, Radio, xm wp hp gRBG vRB2
Gui, Add, Radio, xm wp hp gRBG vRB3
Gui, Add, Text, ys x+5 w50 hp 0x200 cBlue gRBG vRT1 hwndRTID1, % "Radio 1"
Gui, Add, Text, xp y+10 wp hp 0x200 cBlue gRBG vRT2 hwndRTID2, % "Radio 2"
Gui, Add, Text, xp y+10 wp hp 0x200 cBlue gRBG vRT3 hwndRTID3, % "Radio 3"
RBGA := 1
CTLCOLORS.Attach(RTID%RBGA%, "Yellow", "Blue")
; "Faked" CheckBox -----------------------------------------------------------------------------------------------------
; Note: for minimum width see "Faked" RadioButtons
Gui, Add, CheckBox, ys x+80 w15 h20 gCB1 vCB1 Section
Gui, Add, Text, x+5 yp hp 0x200 gCB1 vCT1 hwndCTID1, % " Check me! "
CTLCOLORS.Attach(CTID1, "", "Green")
; ComboBox -------------------------------------------------------------------------------------------------------------
Gui, Add, Combobox, xs y+40 w141 gCBB1 vCBB1 hwndCBBID1
   , ComboBox 1||ComboBox 2|ComboBox 3
GuiControl, , CT1, % (CBBID1 + 0)
CTLCOLORS.Attach(CBBID1, "Aqua", "404040")
; ----------------------------------------------------------------------------------------------------------------------
Gui, Add, Text, xm w292 h2 +0x1000
; ListBox --------------------------------------------------------------------------------------------------------------
Gui, Add, ListBox, xm w292 r4 gLB1 vLB1 hwndLBID1
   , ListBox Red|ListBox Green|ListBox Blue|ListBox Pink
CTLCOLORS.Attach(LBID1, Red, "White")
GuiControl, Choose, LB1, |1
; ----------------------------------------------------------------------------------------------------------------------
Gui, Add, Text, xm w292 h2 +0x1000
; Edit -----------------------------------------------------------------------------------------------------------------
Gui, Font, s10
Gui, Add, Edit, xm w292 r10 vED1 hwndEDID1, I'm an Edit, edit me!
CTLCOLORS.Attach(EDID1, "606060", "Aqua")
Gui, Add, Edit, xm w292 vED2 hwndEDID2 Disabled, % " I'm disabled!"
CTLCOLORS.Attach(EDID2, "Gray", "White")
; ----------------------------------------------------------------------------------------------------------------------
Gui, Show, , Colored Controls
Return
; ----------------------------------------------------------------------------------------------------------------------
GuiClose:
GuiEscape:
   Gui, Destroy
   CTLCOLORS.Free()
ExitApp
; ----------------------------------------------------------------------------------------------------------------------
GuiSize:
   If (A_EventInfo != 1) {
      Gui, %A_Gui%:+LastFound
      WinSet, ReDraw
   }
Return
; ----------------------------------------------------------------------------------------------------------------------
STDRBG:
   GuiControlGet, STDRB1
   CTLCOLORS.Change(RBID1, (STDRB1 ? "Lime" : ""), "006000")
   CTLCOLORS.Change(RBID2, (STDRB1 ? "" : "Lime"), "006000")
Return
; ----------------------------------------------------------------------------------------------------------------------
STDCB1:
   GuiControlGet, STDCB1
   CTLCOLORS.Change(CBID1, (STDCB1 ? "Lime" : "C0C0C0"), "Red")
   Return
; ----------------------------------------------------------------------------------------------------------------------
RBG:
   RBG := SubStr(A_GuiControl, 3)
   If (RBG != RBGA) {
      CTLCOLORS.Detach(RTID%RBGA%)
      CTLCOLORS.Attach(RTID%RBG%, "Yellow", "Blue")
      GuiControl, , RB%RBG%, 1
      RBGA := RBG
   }
Return
; ----------------------------------------------------------------------------------------------------------------------
LB1:
   GuiControlGet, LB1
   StringSplit, LC, LB1, %A_Space%
   If (%LC2%) {
      BG := %LC2%, TX := "White"
      CTLCOLORS.Change(LBID1, BG, TX)
      SendMessage, LB_SETCURSEL, -1, 0, , ahk_id %LBID1%
   }
Return
; ----------------------------------------------------------------------------------------------------------------------
CB1:
   GuiControlGet, CB1
   If (A_GuiControl = "CT1")
      CB1 ^= True
   If (CB1)
      CTLCOLORS.Change(CTID1, "Lime", "406060")
   Else
      CTLCOLORS.Change(CTID1, "", "Green")
   GuiControl, , CB1, %CB1%
Return
; ----------------------------------------------------------------------------------------------------------------------
CBB1:
Return