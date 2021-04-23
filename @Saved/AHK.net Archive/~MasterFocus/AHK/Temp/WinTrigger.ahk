;========================================================================
; 
; Template:     WinTrigger (former OnOpen/OnClose)
; Description:  Act upon (de)activation/(un)existance of programs/windows
; Online Ref.:  http://www.autohotkey.com/forum/topic43826.html#267338
; * WARNING *   Online version (above) is the old OnOpen/OnClose template!
;
; Last Update:  15/Mar/2010 17:30
;
; Created by:   MasterFocus
;               http://www.autohotkey.net/~MasterFocus/AHK/
;
; Thanks to:    Lexikos, for improving it significantly
;
;========================================================================
;
; This template contains two examples by default. You may remove them.
;
; * HOW TO ADD A PROGRAM to be checked upon (de)activation/(un)existance:
;
; 1. Add a variable named ProgWinTitle# (Configuration Section)
; containing the desired title/ahk_class/ahk_id/ahk_group
;
; 2. Add a variable named WinTrigger# (Configuration Section)
; containing the desired trigger ("Exist" or "Active")
;
; 3. Add labels named LabelTriggerOn# and/or LabelTriggerOff#
; (Custom Labels Section) containing the desired actions
;
; 4. You may also change CheckPeriod value if desired
;
;========================================================================

#Persistent

; ------ ------ CONFIGURATION SECTION ------ ------

; Program Titles
ProgWinTitle1 = ahk_class Notepad
WinTrigger1 = Exist
ProgWinTitle2 = Calculator
WinTrigger2 = Active

; SetTimer Period
CheckPeriod = 200

; ------ END OF CONFIGURATION SECTION ------ ------

SetTimer, LabelCheckTrigger, %CheckPeriod%
Return

; ------ ------ ------

LabelCheckTrigger:
  While ( ProgWinTitle%A_Index% != "" && WinTrigger := WinTrigger%A_Index% )
    if ( !ProgRunning%A_Index% != !Win%WinTrigger%( ProgWinTitle := ProgWinTitle%A_Index% ) )
      GoSubSafe( "LabelTriggerO" ( (ProgRunning%A_Index% := !ProgRunning%A_Index%) ? "n" : "ff" ) A_Index )
Return

; ------ ------ ------

GoSubSafe(mySub)
{
  if IsLabel(mySub)
    GoSub %mySub%
}

; ------ ------ CUSTOM LABEL SECTION ------ ------

LabelTriggerOn1:
LabelTriggerOff1:
LabelTriggerOn2:
  MsgBox % "A_ThisLabel:`t" A_ThisLabel "`nProgWinTitle:`t" ProgWinTitle "`nWinTrigger:`t" WinTrigger
Return

; ------ END OF CUSTOM LABEL SECTION ------ ------