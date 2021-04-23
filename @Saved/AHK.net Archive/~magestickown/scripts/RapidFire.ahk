;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                               ;;;
;;; This program was made by Magestickown, with help from users of AutoHotKey.com ;;;
;;; Including: Engunneer, Lazslo, Jake4 (?is that his name?), Leef me             ;;;
;;; and much more                                                                 ;;;
;;;                                                                               ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

config =
(
[MDelaySettings]
mouseDelay=30
minMouseDelay=10
[MButtonSettings]
RButtonEnabled=false
LButtonEnabled=true
[BurstSettings]
BurstFire=false
burst=3
[NoRecoilSettings]
norecoil=false
movedown=2
[CrossHairSettings]
crosshairColor=000000
[VersionInfo]
major=1
minor=8
)

IfNotExist config.ini
	FileAppend %config%, config.ini

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Constants Includes ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv
#InstallKeybdHook
#InstallMouseHook
#include AutomaticUpdate.ahk
;; Version info ;;
major := getIni("config.ini", "VersionInfo", "major")
minor := getIni("config.ini", "VersionInfo", "minor")
version := major "." minor
tfVersion := major " point " minor

if(A_IsCompiled == true)
updateUrl := "http://autohotkey.net/~magestickown/scripts/RapidFire.exe"
else
updateUrl := "http://autohotkey.net/~magestickown/scripts/RapidFire.ahk"

ini := "http://autohotkey.net/~magestickown/scripts/RapidFire.ini"
;; TTS ;;
ttsEnabled = true
ttsVol = 100

SetWinDelay 0
Coordmode Mouse, Screen
OldX := -1, OldY := -1

;;;;;;;;;;;;;;;;;
;;; Functions ;;;
;;;;;;;;;;;;;;;;;
SAPI := ComObjCreate("SAPI.SpVoice")
SAPI.volume := 100

say(msg) { ;Text to speech using integrated COM
	global ttsEnabled
	if(ttsEnabled == "true") {
		global SAPI
		SAPI.speak(msg,1)
	}
}

MouseMoveDown(movedownRate) {
	MouseGetPos x, y
	MouseMove x, y+movedownRate
}

getIni(config, section, key) {
	IniRead value, %config%, %section%, %key%
	return value
}

OldX := -1, OldY := -1

ID1 := Box(1,1,A_ScreenHeight)
ID2 := Box(2,A_ScreenWidth,1)

Box(n,w,h) { ;;By Lazslo from autohotkey.com
	Gui %n%:-Caption +ToolWindow +E0x20 ; No title bar, No taskbar button, Transparent for clicks
	Gui %n%: Show, X0 Y0 W%w% H%h%      ; Show it
	cColor := getIni("config.ini", "CrossHairSettings", "crosshairColor")
	Gui 1:Color, %cColor%
	Gui 2:Color, %cColor%
	WinGet ID, ID, A                    ; ...with HWND/handle ID
	Winset AlwaysOnTop,ON,ahk_id %ID%   ; Keep it always on the top
	WinSet Transparent,255,ahk_id %ID%  ; Opaque
	Return ID
}

RGBtoHEX(R, G, B) {
	SetFormat, integer, hex
	R += 0 ; Convert from decimal to hex.
	G += 0
	B += 0
	RGB := (R*0x10000) + (G*0x100) + (B*0x1)
	return %RGB%
}

;;;;;;;;;;;;;;;;;;;;;;;
;;; Startup message ;;;
;;;;;;;;;;;;;;;;;;;;;;;
welcomeMsg = Universal Rapid Fire version %tfVersion% has finished loading. You can get help by pressing CONTROL PLUS SHIFT PLUS H
say(welcomeMsg) ;Loading message
check4update(updateUrl, ini, A_ScriptName, version)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Variables and configuration ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mouse delay settings ;;
mouseDelay := getIni("config.ini", "MDelaySettings", "mouseDelay")
minMouseDelay := getIni("config.ini", "MDelaySettings", "minMouseDelay")
;; Mouse button settings ;;
RButtonEnabled := getIni("config.ini", "MButtonSettings", "RButtonEnabled")
LButtonEnabled := getIni("config.ini", "MButtonSettings", "LButtonEnabled")
;; Burst settings ;;
BurstFire := getIni("config.ini", "BurstSettings", "BurstFire")
burst := getIni("config.ini", "BurstSettings", "burst")
;; No recoil settings ;;
norecoil := getIni("config.ini", "NoRecoilSettings", "norecoil")
movedown := getIni("config.ini", "NoRecoilSettings", "movedown")
;; Crosshair settings ;;
crosshairColor := getIni("config.ini", "CrossHairSettings", "crosshairColor")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Application settings ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^+s:: ;Temporarily suspends the application
	Suspend, Toggle
return

^+e:: ;Exits the application
	GoSub ExitSub
return

^+u::
	check4update(updateUrl, ini, A_ScriptName, version)
return

!+s:: ;Toggle TTS
	if(ttsEnabled == "false") {
		ttsEnabled = true
		say("Text to speech has been enabled")
	} else {
		say("Text to speech has been disabled")
		ttsEnabled = false
	}
return


^+RButton::
	if(RButtonEnabled == "false") {
		RButtonEnabled = true
		say("Right mouse button is now rapid fire enabled")
	} else {
		RBUttonEnabled = false
		say("Right mouse button is now rapid fire disabled")
	}
return

^+LButton::
	if(LButtonEnabled == "false") {
		LButtonEnabled = true
		say("Left mouse button is now rapid fire enabled")
	} else {
		LBUttonEnabled = false
		say("Left mouse button is now rapid fire disabled")
	}	
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mouse delay settings ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^+d:: ;Says the current mouse delay
	msg = Your current mouse delay is %mouseDelay%.
	say(msg)
return

^+up:: ;Increase the mouse delay
	mouseDelay := mouseDelay + 10
return

^+down:: ;Decrease the mouse delay
	if(mouseDelay > minMouseDelay) {
		mouseDelay := mouseDelay - 10
	} else {
		msg = The mouse delay cannot go below %minMouseDelay%.
		say(msg)
	}
return

;;;;;;;;;;;;;;;;;;;;;;
;;; Burst settings ;;;
;;;;;;;;;;;;;;;;;;;;;;
^+b:: ;Toggles burst fire (x-shots/30ms)
	if(BurstFire == "false") {
		BurstFire = true
	} else {
		BurstFire = false
	}
return

!+b:: ;Says the current burst amount
	msg = Your current burst amount is %burst%.
	say(msg)
return

!+up:: ;Increase burst amount
	burst := burst + 1
return

!+down:: ;Decrease burst amount
	if(burst > 1) {
		burst := burst - 1
	} else {
		msg = The burst amount cannot go below 1
		say(msg)
	}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; No recoil settings ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
^+n::
	if(norecoil == "false") {
		norecoil = true
		say("No recoil has been enabled")
	} else {
		norecoil = false
		say("No recoil has been disabled")
	}
return

^+m::
	msg = No recoil: %movedown%
	say(msg)
return

#+up::
	movedown := movedown + 1
return

#+down::
	movedown := movedown - 1
return

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Crosshair settings ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
^+c:: ;Toggles crosshair
	If OldX = -1
	   SetTimer crosshair, 1
	Else
	{
	   SetTimer crosshair, Off
	   Gui 1: Show, X0 Y0
	   Gui 2: Show, X0 Y0
	   ToolTip
	   OldX := -1, OldY := -1
	}
return

#+c:: ;Crosshair color
	InputBox, R, Color selection, Please enter the amount of red to use
	InputBox, G, Color selection, Please enter the amount of green to use
	InputBox, B, Color selection, Please enter the amount of blue to use

	crosshairColor := RGBtoHEX(R, G, B)
	
	Gui 1:Color, %crosshairColor%
	Gui 2:Color, %crosshairColor%
	msgbox The crosshair color has been changed to %crosshairColor%
return

;;;;;;;;;;;;;;;;;;;;;;
;;; Misc. commands ;;;
;;;;;;;;;;;;;;;;;;;;;;
^+h::
	Run, http://www.autohotkey.com/forum/viewtopic.php?p=477703#477703
return

;;;;;;;;;;;;;;;;;;;;
;;; Key bindings ;;;
;;;;;;;;;;;;;;;;;;;;
^+MButton:: ;Make a 360 degree turn (lol trick shots)
	MouseGetPos x, y
	MouseMove X+790, Y
return


#if LButtonEnabled == "true"
~$LButton:: ;Left mouse button rapid fire
	if(BurstFire == "false") {
		Loop {
			SetMouseDelay mouseDelay
			Click
			if (norecoil == "true")
				MouseMoveDown(movedown)
			if (GetKeyState("LButton", "P")=0)
				break
		}
	} else {
		Loop %burst% {
			Click
			Sleep 30
		}
		Sleep 300
	}
return

#if RButtonEnabled == "true"
~$RButton:: ;Right mouse button rapid fire
	if(BurstFire == "false") {
		Loop {
			SetMouseDelay mouseDelay
			Click right
			if (norecoil == "true")
				MouseMoveDown(movedown)
			if (GetKeyState("RButton", "P")=0)
				break
		}
	} else {
		Loop %burst% {
			Click right
			Sleep 30
		}
		Sleep 300
	}
return

crosshair:
   MouseGetPos RulerX, RulerY
   If (OldX <> RulerX) {
       OldX := RulerX
       WinMove ahk_id %ID1%,, %RulerX%
   }
   If (OldY <> RulerY) {
       OldY := RulerY
       WinMove ahk_id %ID2%,,,%RulerY%
   }
Return

#Persistent
OnExit, ExitSub
return

ExitSub:
IniWrite %mouseDelay%, config.ini, MDelaySettings, mouseDelay
IniWrite %minMouseDelay%, config.ini, MDelaySettings, minMouseDelay
IniWrite %RButtonEnabled%, config.ini, MButtonSettings, RButtonEnabled
IniWrite %LButtonEnabled%, config.ini, MButtonSettings, LButtonEnabled
IniWrite %BurstFire%, config.ini, BurstSettings, BurstFire
IniWrite %burst%, config.ini, BurstSettings, burst
IniWrite %norecoil%, config.ini, NoRecoilSettings, norecoil
IniWrite %movedown%, config.ini, NoRecoilSettings, movedown
IniWrite %crosshairColor%, config.ini, crosshairSettings, CrosshairColor
ExitApp
Return