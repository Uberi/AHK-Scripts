; Keyboard Debouncer -- by debouncer
; http://www.autohotkey.com
; This script addresses a problem in some laptops where the keyboard
; "bounces", resulting in doubled keystrokes (sometimes tripled in
; really bad cases). Because the keystrike repeat is usually very
; fast, it can be detected and filtered out. The filter window is
; set by the first command-line argument, in milliseconds. (If left
; blank, it defaults to 40 msec.) Set it longer for better filtering
; of bounces.
;
; All primary keys are bounce-filtered with their shifts, but not their
; Alt, Ctrl, or Win variants (feel free to add them if you really need
; to have them). The num-keypad keys are also not filtered.  All
; movement keys (including Enter, BS, Del, Esc) are filtered with no
; variants. Shift, Ctrl, Alt and Win as basic keys are not filtered.
; Keys that are not filtered are passed through (i.e. no hotkeys are
; assigned to them).
;
; The Capslock key (which I dis-affectionately call the cAPSLOCK key)
; is mapped to function normally by default. It can be disabled by
; adding a second command-line argument, typically a number that is
; not zero (0). If 0 is indeed used, then cAPSLOCK will be back to
; doing its dirty work again. When disabled, neither cAPSLOCK nor
; Shift+cAPSLOCK will do anything (yay!), but just in case, both
; Ctrl+cAPSLOCK and Alt+cAPSLOCK will work as as normal cAPSLOCK.
;
; The auto-repeat feature on most keyboards is usually set fast enough
; to falsely trigger the bounce filter. So, to prevent false filtering
; of auto-repeats, the auto-repeat pattern is detected (as multiple
; "bounce" detections in a row) and then not filtered (passed through)
; as long as the auto-repeat pattern continues. This does result in a
; slight delay before the key repeat finally kicks in. The default
; threshold for auto-repeat detection is set to three (3) repeated
; bounce detections in a row, and can be changed by passing a different
; number through the third command-line argument. Passing in a smaller
; number than 3 can reduce the delay, but with the danger that bad
; bounces could start getting through the bounce filter. Note: For best
; performance, set the auto-repeat rate faster than the gate time of
; the bounce filter. (This should be good news to those who like fast
; auto-repeat rates.) 
;
; Credit goes to Jon for his KeyboardOnScreen script, where I learned
; the handy trick of assigning hotkeys from the ASCII table in a loop.


; ---- setups
#UseHook On
SetStoreCapslockMode Off


; ---- initialize parameters
NumParams = %0%
Param1 = %1%
Param2 = %2%
Param3 = %3%


if (NumParams > 0)
	k_TimeThreshold := Param1
else
	k_TimeThreshold := 40
;k_TimeThreshold := 1000  ; for debugging

fKillCaps := (NumParams > 1  AND  Param2 > 0)

if (NumParams > 2)
	k_RptThreshold := Param3
else
	k_RptThreshold := 3



; ---- initialize variables
k_LastHotkey := 0
k_RptKeyCnt := 0
k_LastTick := A_TickCount



; ---- Set all ASCII as keys as hotkeys (see www.asciitable.com)
k_ASCII = 33
Loop
{
	Transform, k_char, Chr, %k_ASCII%

	Hotkey, %k_char%, k_KeyPress

       	if ((k_char Not In +,^)  AND  (k_ASCII != 123  AND  k_ASCII != 125))
	{
		Hotkey, +%k_char%, k_KeyPress		; shift
		; Hotkey, ^%k_char%, k_KeyPress		; control
		; Hotkey, !%k_char%, k_KeyPress		; alt
		; Hotkey, #%k_char%, k_KeyPress		; win
	}

	if k_ASCII = 64
		k_ASCII = 91
	else if k_ASCII = 126
		break
	else
		k_ASCII++
}
return 


; ---- End of auto-execute section.


; ---- Hotkey-execute section


; ---- Conditionally remap Capslock key
Capslock::
+Capslock::
if (fKillCaps)
{
	;SendInput %NumParams% %Param1% %k_TimeThreshold% %Param2%  ; for debug
}
else
{
	;SendInput %NumParams% %Param1% %k_TimeThreshold% %Param2%  ; for debug
	SendInput {Capslock}
}
return


; ---- When a key is pressed by the user, send it forward only if it's not a "bounce"
; ---- A "repeat" is defined as: "key is same as last"  AND  "time since last key is very short"
; ---- A "bounce" is defined as: "key is not a repeat"  AND  "number of key repeats is small"
Enter::
Space::
Tab::
Esc::
BS::
Del::
Ins::
Home::
End::
PgUp::
PgDn::
Up::
Down::
Left::
Right::
k_KeyPress:
{
	k_ThisHotkey := A_ThisHotkey		; grab the current hotkey
	k_ThisTick := A_TickCount		; grab the current tick
	ElapsedTime := k_ThisTick - k_LastTick	; time since last hotkey (ticks)

	fNotRepeat := (ElapsedTime > k_TimeThreshold  ||  k_ThisHotkey <> k_LastHotkey)

	if (fNotRepeat)
		k_RptKeyCnt := 0
	else
		k_RptKeyCnt++

	if (fNotRepeat  ||  k_RptKeyCnt > k_RptThreshold)
	{
		if k_ThisHotkey In !,#,^,+,{,},Enter,Space,Tab,Esc,BS,Del,Ins,Home,End,PgUp,PgDn,Up,Down,Left,Right
			SendInput {%k_ThisHotkey%}
		else
			SendInput %k_ThisHotkey%
		;SendInput %ElapsedTime%  ; for debugging
	}

	k_LastHotkey := k_ThisHotkey	; store the current hotkey for next time
	k_LastTick := k_ThisTick	; store the current tick for next time
}
return

; ---- other keys that could be filtered (but caused issues on some keyboards)
;LWin::
;RWin::
;LAlt::
;RAlt::
