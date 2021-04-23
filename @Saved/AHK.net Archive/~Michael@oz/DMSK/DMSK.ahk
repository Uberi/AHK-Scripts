#NoTrayIcon ; Stop the default ahk icon flashing up before own icon is loaded
; DMSK.ahk	Dinovo Mini Special Keys
;			(c) 2010 - free for personal use
; ToDo		?
; v-0-7b	Add a scroll wheel functional replacement 
; v-0-7a	Add Esc & Tab keys, 
;			Allow Shift, Control, Win and SoftAlt for F1-9
;			Changed activation key to FN+>>| ie NextTrack & added FN+9 as F9
;			Rejiged Menu 
;			Added Navigation Key submenu
;			Save/restore mouse position for clicks ie the click will occur where the mouse was when
;				the menu was activated, rather than where it was when you clicked on the menu.
; v-0-6b	Removed debug code (stupid!)
; v-0-6a	Bug fix re Numpad keys
; v-0-6		Add missing Fn keys and some other keys
;
; 			Press FN+>>|, Double-Tap >>| or single-click the try icon to activate a menu of missing keys
;			See the Help/About menu item or see the help at the end of the script.
;
;			Another tip; I found some tiny transparent self adheasive bumps in the craft section of K-mart
;			they look like water drops of various sizes. Stick the small ones on anchor/positioning keys to
;			assist using it in the dark or whithout looking, I did the >>|, Y, N, 0, dot, and Win keys
;			
; 			Incase you are wondering, the FM prefix used stands for Function Menu,
;			an earlier name for the script.
;
; Global settings
#NoEnv
#SingleInstance force
FMVersion:="v-0-7b"
Gosub, FM_Globals
;
; Options
; =======
FM2TapTime:=250	; The time difference used to detect a double key tap
;
;
; Setup Traymenu & Gui
Gosub, FM_TraynGui
;
; Use FN+(1-9 for F1-F9, FN+>>| for menu of other keys
;
*>!1::
*>!2::
*>!3::
*>!4::
*>!5::
*>!6::
*>!7::
*>!8::
*>!9::
; Note FN+0 is DELETE
gosub FMDoFn					; Handle FN+n keys
Return
;
; Pop-up menu keys
;
vkFFsc072 up::gosub FMenu		; menu for other F-Keys and more missing keys, 
								; this is the FN key plus the >>| NextTrack Key
^>!e::gosub FMenu				; a second activation key FN plus D - I hope the code is the same with drivers loaded
;
; Scroll Mode - simulated scroll wheel
;
^>!s::gosub FMScrollMode		; Gui to support scroll, move mouse up/down to scroll, move more/less for speed.
;
; These scan codes are WITHOUT the Logitec S/W installed,
;   you will need to change the vknnscnnn codes below if you use the driver.
;
; Remap media keys - note Rec key is not recognised ????
; Original Media Functions remapped as Atl+Key
;
; Comment these out if you wish - also delete the bits in help below
vkB1sc110::SendInput, ^x   ;Back Track key 	- CUT	Think |< deletes like <- DEL Key
vkB2sc124::Sendinput, ^c   ;Stop key 		- COPY	Think in order this is cut COPY paste
vkB3sc122::SendInput, ^v   ;play/pause key	- PASTE	Think >|| inserts
; Media Functions Alt+key
!vkB1sc110::SendInput, {Media_Prev}
!vkB2sc124::Sendinput, {Media_Stop}
!vkB3sc122::SendInput, {Media_Play_Pause}
!vkB0sc119::SendInput, {Media_Next}
;

; Forward Track key for a one h|anded operation - use Right hand for mouse & click & right click
;  also a double press pops up the Special Keys menu
FM2TapCount=0	; 2Tap Count
$sc119::
If (!FM2TapCount)
	Settimer, FM2Tap, -%FM2TapTime%		; minus = Run once timer
FM2TapCount+=1
Return
FM2Tap:
If (FM2TapCount=1)				; 1 press
	SendInput, {rbutton}         
Else
	Gosub FMenu				; >1 presses. Could add a third etc option
FM2TapCount=0
Return
;
FNMenuSet = 0       ; Menus have not been created
Return
; END of Autoexec
; --------------------------------------------------------------------------------------------
;
;
; Handle Menu
;
FMTrayDM:
FMenu:
; grab mouse coords for clicks
MouseGetPos, FMMouseX, FMMouseY
; Setup menus
; Use F9 to choose between F9, F10, F11 & F12 & other keys
if (!FNMenuSet) {
	; Function Menu NumPad with numlock oN
	; 0123456789./*+-
	menu, FMNPNSM, Add, Numpad&0, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&1, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&2, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&3, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&4, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&5, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&6, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&7, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&8, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&9, FMNPSMDoit
	menu, FMNPNSM, Add, NumpadD&ot, FMNPSMDoit
     menu, FMNPNSM, Add, ; Seperator
	menu, FMNPNSM, Add, NumpadDi&v, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&Mult, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&Add, FMNPSMDoit
	menu, FMNPNSM, Add, Numpad&Sub, FMNPSMDoit
	menu, FMNPNSM, Add, NumpadEn&ter, FMNPSMDoit
	
	; Function Menu NumPad with numlock oFf SubMenu
	;  Ins,End,Down,PgDn,Left,Clear,Right,Home,Up,PgUp,Del,/,*,+,-
	menu, FMNPFSM, Add, Numpad&Ins, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&End, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Down, FMNPSMDoit
	menu, FMNPFSM, Add, NumpadPgD&n, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Left, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Clear, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Right, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Home, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Up, FMNPSMDoit
	menu, FMNPFSM, Add, NumpadPgU&p, FMNPSMDoit
	menu, FMNPFSM, Add, NumpadDe&l, FMNPSMDoit
     menu, FMNPFSM, Add, ; Seperator
	menu, FMNPFSM, Add, NumpadDi&v, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Mult, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Add, FMNPSMDoit
	menu, FMNPFSM, Add, Numpad&Sub, FMNPSMDoit
	menu, FMNPFSM, Add, NumpadEn&ter, FMNPSMDoit	

	; Function Menu Function SubMenu
	menu, FMFSM, Add, F1, FMDoFn
	menu, FMFSM, Add, F2, FMDoFn
	menu, FMFSM, Add, F3, FMDoFn
	menu, FMFSM, Add, F4, FMDoFn
	menu, FMFSM, Add, F5, FMDoFn
	menu, FMFSM, Add, F6, FMDoFn
	menu, FMFSM, Add, F7, FMDoFn
	menu, FMFSM, Add, F8, FMDoFn
	menu, FMFSM, Add, F9, FMDoFn
	menu, FMFSM, Add, F10, FMDoFn
	menu, FMFSM, Add, F11, FMDoFn
	menu, FMFSM, Add, F12, FMDoFn

	; Function Menu Function SubMenu2
	menu, FMFSM2, Add, F1&3, FMDoFn
	menu, FMFSM2, Add, F1&4, FMDoFn
	menu, FMFSM2, Add, F1&5, FMDoFn
	menu, FMFSM2, Add, F1&6, FMDoFn
	menu, FMFSM2, Add, F1&7, FMDoFn
	menu, FMFSM2, Add, F1&8, FMDoFn
	menu, FMFSM2, Add, F1&9, FMDoFn
	menu, FMFSM2, Add, F2&0, FMDoFn
	menu, FMFSM2, Add, F2&1, FMDoFn
	menu, FMFSM2, Add, F2&2, FMDoFn
	menu, FMFSM2, Add, F2&3, FMDoFn
	menu, FMFSM2, Add, F2&4, FMDoFn
	
	; Function Menu Char SubMenu 
	 menu, FMCSM, Add, Tip - Use FN+Key, CloseMenu ; Do nothing
     menu, FMCSM, Add, &Q=``, FMDoChar			; `` is escape seq for a single `
     menu, FMCSM, Add, &W=~,  FMDoChar			; DoChar sends the 4th char in the menu item
     menu, FMCSM, Add, &X=|,  FMDoChar
     menu, FMCSM, Add, &J={,  FMDoChar
     menu, FMCSM, Add, &K=},  FMDoChar
     menu, FMCSM, Add, &L=[,  FMDoChar
     menu, FMCSM, Add, &;=] SemiColon,  FMDoChar

	; Function Menu Special Keys SubMenu
	menu, FMSKSM, Add, Print&Screen,	FMDoKey		; it is removed before sending.
	menu, FMSKSM, Add, &Alt-PrintScreen, FMDoKey	; Use Alt- if needed (case sensitive)
	menu, FMSKSM, Add, &Pause,			FMDoKey		; You can add any AHK Key name
	menu, FMSKSM, Add, &Break,			FMDoKey
	menu, FMSKSM, Add, &Ctrl-Break,		FMDoKey
	
	; Function Menu Navigation SubMenu
	menu, FMNSM, Add, &Left,		FMDoKey
	menu, FMNSM, Add, &Right,		FMDoKey
	menu, FMNSM, Add, &Up,			FMDoKey
	menu, FMNSM, Add, &Down,		FMDoKey
	menu, FMNSM, Add, &Home,		FMDoKey
	menu, FMNSM, Add, &End,			FMDoKey
	menu, FMNSM, Add, PgU&p,		FMDoKey
	menu, FMNSM, Add, PgD&n,		FMDoKey
;	menu, FMNSM, Add, &
;	menu, FMNSM, Add, &
	
	; Main Menu
;     menu, FM, Add, F&9, 						FMDoFn
     menu, FM, Add, Mouse S&croll, 	FMScrollMode
     menu, FM, Add, F&1-F12, 		:FMFSM		; Add F1-F12 Submenu
;     menu, FM, Add, F1&2, 						FMDoFn
	 menu, FM, Add, F1&3-F24,		:FMFSM2		; Add F13-F24 Submenu
     menu, FM, Add, ; Seperator
	 menu, FM, Add, &Navigation,	:FMNSM
	 menu, FM, Add, E&xtra Keys,	:FMCSM
     menu, FM, Add, ; Seperator
	 menu, FM, Add, &Del,			FMDoKey		; NOTE these MUST be same as AHK Key name ie {Home}
;     menu, FM, Add, &Home,			FMDoKey
     menu, FM, Add, &Tab,			FMDoKey	
	 menu, FM, Add, &Esc,			FMDoKey		; The & can be anyware as long as it is unique, 
     menu, FM, Add, Click &Middle,	FMDoKey		; Possibly useful??
     menu, FM, Add, Click &Right, 	FMDoKey
     menu, FM, Add, ; Seperator
     menu, FM, Add, &Ins,		FMDoKey		; If u change these five keys also change in FMCheckTog calls below
	 menu, FM, Add, Soft-A&lt,	FMDoAltTog	; If toggled on, send keys with an Alt (ie !), for one press only
     menu, FM, Add, &CapsLock,	FMDoLock    	; DoKey didn't work, so DoLock, hence Ctrl etc can't be used
     menu, FM, Add, &ScrollLock,FMDoLock
     menu, FM, Add, N&umLock,	FMDoLock  	; Got no idea what this may do?? 
										; Seems nothing even no effect on simulated Numpad keys
     menu, FM, Add, ; Seperator
	 menu, FM, Add, Special &Keys, :FMSKSM
	 menu, FM, Add, Numpad O&ff Keys, :FMNPFSM	; Submenus
	 menu, FM, Add, Numpad &On Keys,  :FMNPNSM
;	 menu, FM, Add, E&xtra Keys,	   :FMCSM
     menu, FM, Add, ; Seperator
     menu, FM, Add, Help/&About, FMKeyHelp	; explain the following can be usef via FN+x
     menu, FM, Add, Close& menu, CloseMenu
	FMAltToggle := false	; AltToggle is off
	FNMenuSet := true	; Flag that menus have been created
}
FMCheckTog("&CapsLock")  ; check menu item if ON
FMCheckTog("&ScrollLock")
FMCheckTog("N&umLock")
FMCheckTog("&Ins")
FMCheckTog("Soft-A&lt")		; if u change this also change inside function
menu, FM, Show				;Display the menu
Return
;
; Menu Handlers
; ---------------------------------------------------------------------------------------------
;
CloseMenu:
Return			; Do nothing
;
; Fn Keys
FMDoFn:
;ToolTip, %A_ThisHotkey%`,%A_ThisMenu%`,%A_ThisMenuItem%`,%A_ThisMenuItemPos%`,%A_TimeSinceThisHotkey%
if (A_TimeSinceThisHotkey=0)
	FNum:=SubStr(A_ThisHotkey,4,1)			; if called from the F1-9 extract key number
else										; Else get it from menu position
	{
	FNum := A_ThisMenu="FMFSM" ? 0 : 12		; adjust depending on which menu
	FNum += A_ThisMenuItemPos
}
FMSendModified("{F" . FNum . "}")				; take care of control/shift/win modifiers
Return
;
; Other Keys
FMDoKey:
; Menu item name (minus &) is a AHK key name
FMKey := RegExReplace(A_ThisMenuItem,"&")		; Remove the &
MouseMove, FMMouseX, FMMouseY ; return mouse to pos it was when menu activated
if (SubStr(FMKey,1,4)="Alt-") {
	FMKey:=SubStr(FMKey,5)
	FMSendModified("!{" . FMKey . "}")
	}
else
	FMSendModified("{" . FMKey . "}")
Return

FMDoChar:
; Menu item name has the key at char position 4
FMKey:=SubStr(A_ThisMenuItem,4,1)
FMSendModified("{" . FMKey . "}")				; Needs wrapper as Key can be a { or } or `
Return

FMDoAltTog:
FMAltToggle:=!FMAltToggle
Return

FMDoLock:       ; FMDoKeys didn't work for capslock hence..
FMKey := RegExReplace(A_ThisMenuItem,"&")	; Remove the &
FMNewMode := GetKeyState(FMKey,"T") ? "Off" : "On"
if (FMKey="Capslock")
SetCapsLockState, %FMNewMode%
if (FMKey="Scrolllock")
SetScrollLockState, %FMNewMode%
if (FMKey="Numlock")
SetNumLockState, %FMNewMode%
Return

FMNPSMDoit:	; NumPad Keys 
if (A_ThisMenu="FMNPFSM") 
	FMNPKeys:= 
		(Join LTrim 
		"{NumpadIns},{NumpadEnd},{NumpadDown},{NumpadPgDn},{NumpadLeft},{NumpadClear},{NumpadRight},
		{NumpadHome},{NumpadUp},{NumpadPgUp},{NumpadDel},{NumpadDiv},{NumpadMult},{NumpadAdd},
		{NumpadSub},{NumpadEnter}"	
		)
	Else
	FMNPKeys:= 
		(Joim LTrim 
		"{Numpad0},{Numpad1},{Numpad2},{Numpad3},{Numpad4},{Numpad5},{Numpad6},{Numpad7},{Numpad8},
		{Numpad9},{NumpadDot},{NumpadDiv},{NumpadMult},{NumpadAdd},{NumpadSub},{NumpadEnter}"
		)
FMNPKPos:= A_ThisMenuItemPos<12 ? A_ThisMenuItemPos : A_ThisMenuItemPos-1	; allow for seperator
Loop, Parse, FMNPKeys,`,
	If (A_Index=FMNPKPos)			; match found
		FMKey:=A_LoopField			; Grab the key
FMKL := StrLen(FMKey)
FMSendModified(FMKey)
Return
;
; Scroll Mode - mouse simulation of scroll wheel
;
FMScrollMode:
MouseGetPos, FMStartX, FMStartY
FMStartY:=FMSGuiY:=FMSMon1Bottom/2	; middle of screen
FMSGuiY-=15
MouseMove,FMStartX, FMStartY, 0
;DllCall("SetCursorPos", int, FMStartX, int, FMStartY) 
Sleep,10
Hotkey,LButton ,FMStop, On
Process, Priority,,AboveNormal
SetTimer, FMSUpdate, 200
Gosub, FMSUpdate  ; Make the first update immediate rather than waiting for the timer.
Gui, Show, NoActivate x%FMStartX% y%FMSGuiY% ; NoActivate avoids deactivating the currently active window.
return
;
; Handle Scroll Mode Gui input and click
;
FMSClicked:
FMStop:
SetTimer, FMSUpdate, Off
Hotkey, LButton, Off
Gui, Hide
Process, Priority,,Normal
Return
;
; Scroll mode Timer
;
FMSUpdate:
MouseGetPos, FMSMouseX, FMSMouseY
FMSpeed:=Abs(Round(((FMSMouseY-FMStartY)/FMSTolerance)/2))
If (FMSpeed>9)
	FMSpeed:=9
FMSDirection:=FMSStopChr
if (FMSMouseY>((FMStartY+FMSTolerance))) {
	FMSDirection:=chr(234)
	Send, {WheelDown %FMSpeed%}
}
if (FMSMouseY<((FMStartY-FMSTolerance))) {
	FMSDirection:=chr(233)
	Send, {WheelUp %FMSpeed%}
}
GuiControl,Text, FMSArrow, %FMSDirection%
GuiControl,Text, FMSSpeedNum, % chr(128+FMSpeed)
return
;
; Functions
; ---------------------------------------------------------------------------------------------
FMSendModified(FMKey)	; Cater for user holding Shift/Control/Win when selecting menu key
{
; FMKey should be {} deliminated if necessary, may have ! for Alt
; user can't hold Alt key as this clears the menu - will think about adding an Alt toggle??
;
Global FMAltToggle
; Get Key Modifiers
FMMod:=GetKeyState("Control","P") ? "^" : ""		; Dinovo Mini only has LControl
FMMod.=GetKeyState("LWin","P") ? "#" : ""		;  only has LWin
If !InStr(FMKey,"!")						; If not already Alt
	FMMod.=FMAltToggle ? "!" : ""			; Check for Synthetic Alt
FMLSMod:=GetKeyState("LShift","P")				; both shifts
FMRSMod:=GetKeyState("RShift","P")				;
; Handle shifts as Down Up pairs surounding the actual key
FMFirst:=FMLSMod ? "{LShift Down}" : ""
FMFirst.=FMRSMod ? "{RShift Down}" : ""
FMLast:= FMRSMod ? "{RShift Up}" : ""
FMLast.= FMLSMod ? "{LShift Up}" : ""
; Send it
SendInput, %FMFirst%%FMMod%%FMKey%%FMLast% 		; eg {LShift Down}^#{somekey}{LShift Up}
;ToolTip, "%FMFirst%"`,"%FMMod%"`,"%FMKey%"`,"%FMLast%",2		; Handy for debugging
FMAltToggle:= FAltToggle ? false : False		; Turn off the soft toggle
}
;
;
FMCheckTog(FMKey) ; Use menu check to indicate key lock state
{
	Global FMAltToggle
	If ((FMKey="Soft-A&lt" and FMAltToggle) 	; Synthetic Alt
	or (FMKey<>"Soft-A&lt" and GetKeyState(RegExReplace(FMKey,"&"),"T")))
          menu, FM, Check, %FMKey%
     Else   
          menu, FM, UnCheck, %FMKey%
}
;
; Global settings
; ---------------
FM_Globals:
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
SendMode Input  		; Recommended for new scripts due to its superior speed and reliability.
FMSTolerance:=30
FMSColor:="Red"  		; Can be any RGB color (it will be made transparent below).
FMSStopChr:=chr(244) 	; up&down arrow
SysGet, FMSMon1, Monitor

Return
;
; Setup tray & Gui for Scroll mode
;       ----------
FM_TraynGui:
; Make Icon & Tray menu pretty
menu, Tray, NoStandard
menu, Tray, Add, DMSK &Menu, FMTrayDM
menu, Tray, Default, DMSK &Menu
menu, Tray, Standard
menu, Tray, Icon, Shell32.dll, 45
menu, Tray, Tip, Dinovo Mini Special Keys`nClick for Menu and help`n%FMVersion%
menu, Tray, Icon
menu, Tray, Click, 1      ; single click tray icon
; Setup Gui for Scroll mode
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %FMSColor%,
Gui, Font, s16, Wingdings 
Gui, Add, Text, , % chr(56)					; mouse picture
Gui, Add, Text, s14 x+1 vFMSArrow, %FMSStopChr%		; up&down arrow
Gui, Add, Text, x+1  vFMSSpeedNum, % chr(128)		; zero
;Gui, Font		; reset to defualt font & size
;Gui, Font, s12  ; Set a large font size.
Gui, Add, Text, x+1 centre, % chr(120)  			; close box
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %FMSColor% 150
Return
;
; Help
; -----------------------------------------------------------------------------------------------
FMKeyHelp:
MsgBox,,Dinovo Mini Special Keys - Help/About, 
(
F1 thru F9 are remapped to FN+n. Note FN+0 is the Delete key. Use the popup menu to get F10.

FN+>>| (the Next Track key) pops up a menu to select other keys missing from the Dinobo Mini 
plus some keys useful for one handed (right thumb) operation.

The Mouse Scroll menu item allows scroll wheel emulation. It displays a picture of a mouse 
plus an arrow showing scroll direction, a numder showing scroll speed (move the mouse further 
up/down to increase the speed) and a close box. Click anywhere to exit Mouse Scroll mode.

Pressing FN + the keys shown in the 'Extra Keys' menu produces these characters without using 
this menu, e.g. FN+L produces a '['. Use FN+>>| for a handy reminder.

The keys next to BACK have been remaped to CUT, COPY, PASTE and Right-Click,
`t<<`tas Cut,
`tSTOP`tas Copy,
`t>||`tas Paste,`t`tyou don't need the cramped control key.
  
`t>>|`tas Right-Click*,`tthis is handy for single handed operation,
`t`tie Right Thumb Right-Click without needing the FN key.

* The >>| Key has a double function, one press is RightClick, two quick presses within a 
quarter of a second activates the Special Keys menu; handy when mousing with one hand.

The original Media control functions of these four keys have been remapped, use ALT+ the 
relevant key to get the media function, e.g. ALT+>>| is Next Track.

The CapsLock, ScrollLock, NumLock and Insert key states can be changed by selecting the 
corresponding menu item. Menu check marks represents the state of these keys. NumLock
doesn't seem to have any effect on the Dinovo Mini, it may be usefull in some Applications.

The Numpad submenu keys sent are not affected by the NumLock State, so for example NumpadUp 
will be sent even if NumLock is ON.

The menu keys can be used with modifier keys such as Shift, Control & Win.
Click the menu item while holding the modifier. Alt can't be used, it closes the menu.
 (unfortunately modifiers don't work with CapsLock, NumLock and ScrollLock)
 [may be some issues with Win modifier? Not tested much yet]
 
To allow the Alt modifier, there is a soft toggle. Selecting  the Soft-Alt menu item toggles
Soft-Alt ON, the next special key will be sent with an Alt key. This then resets the Soft-Alt,
i.e. it is one time only. Soft-Alt is shown with a menu check mark

You can also Single-Click the Tray Icon to open the Menu, or Right-Click and choose DMSK Menu.

About:
`tDMSK v0-7 by Michael@Oz using AutoHotkey. See autohotkey.com
 :)`tLightly tested on Windows XP.
`tWritten & Tested using Logitec Dinovo Mini  :|
`tWritten for use without the Logitec Driver.
)
Return
;
; END -----------------------------------------------------------------------------------------