;AutoHotkey:    1.x
;Language:      English
;Platform:      Win9x/NT
;Author:        eryksun
;Version:       1.0
;
;Script Function:
;Chime a bell at the specified minutes of the hour over a 
;range of hours during the day

#Persistent
#SingleInstance
#NoEnv  ; for performance and compatibility
SendMode Input  ; superior speed and reliability
SetWorkingDir %A_ScriptDir%  ; consistent starting directory

;sound file for the bell
WAV = %A_WinDir%\Media\Windows Notify.wav

;hours range
HOURMIN = 7    ;7am
HOURMAX = 17   ;5pm

;minutes list (e.g. 00 05 30 45)
MINUTES = 00 15 30 45

;intialize the tray icon
menu, tray, icon, bell.icl, 1
menu, tray, tip, Bell Enabled
menu, tray, noStandard
menu, tray, add, Enabled, EnableToggle
menu, tray, check, Enabled
menu, tray, default, Enabled ;icon d-click toggles enable
menu, tray, add  ;separator
menu, tray, add, Exit, QuitChimer

;state variables
enabled := true    ;default to enabled
prevMinute = -1    ;limits bell to once/minute

;update once per second
SetTimer, CheckTime, 1000
return


CheckTime:
if (enabled) {
    FormatTime, hour, %A_now%, H
    FormatTime, minute, %A_now%, mm
    if (hour >= HOURMIN && hour <= HOURMAX) { 
        if ( instr(MINUTES, minute) && minute != prevMinute) {
            SoundPlay, %WAV%
            prevMinute = %minute%
        }
    }
}
return


EnableToggle:
if (enabled) {  
    ;disable the bell
    menu, tray, uncheck, Enabled
    menu, tray, icon, bell.icl, 2
    menu, tray, tip, Bell Disabled
    SetTimer, CheckTime, Off
    enabled := false
}
else {          
    ;enable the bell
    menu, tray, check, Enabled
    menu, tray, icon, bell.icl, 1
    menu, tray, tip, Bell Enabled
    SetTimer, CheckTime, On
    enabled := true
    prevMinute = -1
}
return


QuitChimer:
ExitApp
