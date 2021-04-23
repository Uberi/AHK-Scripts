;
; AutoHotkey Version: 1.x
; Language.........: English
; Platform.........: Win9x/NT/XP/Vista
; Author...........: Veil <veilure@gmail.com>
; Full guide.......: http://brrp.mine.nu/fnkey/
;
; Script Function..: Special characters, OSX style
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#UseHook
!VKC0SC029::Return 	; grave -> the grave ` accent gave some probs, used the virtualkey + scancode instead
!e::Return         	; acute
!i::Return				 	; circumflex
!t::Return         	; tilde
!u::Return				 	; umlaut

;                  1 2 3 4 5 6 7 8 9 1
;                                    0
;              r   g G a A c C t T u U
*a::diacritic("a","�,�,�,�,�,�,�,�,�,�")
*e::diacritic("e","�,�,�,�,�,�,e,E,�,�")
*i::diacritic("i","�,�,�,�,�,�,i,I,�,�")
*o::diacritic("o","�,�,�,�,�,�,�,�,�,�")
*u::diacritic("u","�,�,�,�,�,�,u,U,�,�")
*n::diacritic("n","n,N,n,N,n,N,�,�,n,N")
*y::diacritic("y","y,Y,y,Y,y,Y,y,Y,�,�")

diacritic(regular,accentedCharacters) {
	StringSplit, char, accentedCharacters, `,
	graveOption            := char1
	graveShiftOption       := char2
	acuteOption      			 := char3
	acuteShiftOption       := char4
	circumflexOption       := char5
	circumflexShiftOption  := char6
	tildeOption            := char7
	tildeShiftOption       := char8
	umlautOption           := char9
	umlautShiftOption      := char10
	
	if (A_PriorHotKey = "!VKC0SC029" && A_TimeSincePriorHotkey < 2000) {
		if (GetKeyState("Shift")) {
			SendInput % graveShiftOption
		} else {
			SendInput % graveOption
		}
	} else if (A_PriorHotKey = "!e" && A_TimeSincePriorHotkey < 2000) {
		if (GetKeyState("Shift")) {
			SendInput % acuteShiftOption
		} else {
			SendInput % acuteOption
		}
	} else if (A_PriorHotKey = "!i" && A_TimeSincePriorHotkey < 2000) {
		if (GetKeyState("Shift")) {
			SendInput % circumflexShiftOption
		} else {
			SendInput % circumflexOption
		}		
	} else if (A_PriorHotKey = "!t" && A_TimeSincePriorHotkey < 2000) {
		if (GetKeyState("Shift")) {
			SendInput % tildeShiftOption
		} else {
			SendInput % tildeOption
		}
	} else if (A_PriorHotKey = "!u" && A_TimeSincePriorHotkey < 2000) {
		if (GetKeyState("Shift")) {
			SendInput % umlautShiftOption
		} else {
			SendInput % umlautOption
		}
	} else {
		if (GetKeyState("Shift")) {
			SendInput % "+" regular
		} else {
			SendInput % regular
		}
	}
}

;
; Alt + Shift + key
;
*!1::altShift("�","/")
*!2::altShift("�","�")
*!3::altShift("�","�")
*!4::altShift("�","�")
*!5::altShift("8","fi")
*!6::altShift("�","fl")
*!7::altShift("�","�")
*!8::altShift("�","�")
*!9::altShift("�","�")
*!0::altShift("�","�")

*!a::altShift("�","�")
*!b::altShift("integral","i")
*!c::altShift("�","�")
*!d::altShift("partial difference","�")
*!e::altShift("�","�")
*!f::altShift("�","�")
*!g::altShift("�","�")
*!h::altShift("overdot","�")
*!i::altShift("^","�")
*!j::altShift("delta","�")
*!k::altShift("�","Apple")
*!l::altShift("�","�")
*!m::altShift("�","�")
*!n::altShift("~","�")
*!o::altShift("�","�")
*!p::altShift("pi","Pi")
*!q::altShift("�","�")
*!r::altShift("�","�")
*!s::altShift("�","�")
;*!t::altShift("�","�")
*!u::altShift("�","�")
*!v::altShift("v","lozenge")
*!w::altShift("epsilon","�")
*!x::altShift("approximately equal","�")
*!y::altShift("�","�")
*!z::altShift("Omega","�")

*!-::altShift("�","�")
*!=::altShift("!=","�")
*![::altShift("�","�")
*!]::altShift("�","�")
*!`;::altShift("�","�")
*!'::altShift("�","�")
*!\::altShift("�","�")
*!,::altShift("<=","�")
*!.::altShift(">=","breve")
*!/::altShift("�","�")	
	
altShift(accented,accentedShift) {
	if (!GetKeyState("Shift")) {
		SendInput % accented
	} else {
		SendInput % accentedShift
	}
}