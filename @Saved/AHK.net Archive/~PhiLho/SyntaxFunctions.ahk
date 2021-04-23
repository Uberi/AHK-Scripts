/*
A pseudo-source file, that does nothing,
that looks strange, but it has perfectly legal syntax.

This is only to test a program extracting function definitions,
labels and hotstuff (hotkeys, hotstrings, key remapping):

ListAHKFunctions.ahk
*/
x = Some string

a =
(
Function4(      x          )
{
Return "Bar"
}

/*
Continuation sections must be skipped
at least because it is faster...
*/
                    )

              Function1()
/*
Comments too,
just zoom to
closing line.
*/
{
	Function3(")", x, 5)
	Return "Foo"
	}

	Function2(a, [b], ?c="", d=8, f=1.6)	; ( With a comment )


		{		; Doo Wap!

		Labels!Can_Be/In\Functions...:
		/*
		Some comment
		*/
		Return a = c
}

Function3(	_a
				, ByRef @b	; Foo
			; Bar
		, c?=""
	,__d__=65536
	/* Doh
	*/
,    #f=-3.14   ) ;      Lot of spaces, eh? ;
; Line comment
/* Bloc comment
*/

; Other line comment
{
	Return a * b
}

Function4(               )
{
Return "Bar"
}

Function5(   x
     , y       )                  {
    If InStr(x,"::"){
	MsgBox
	}
Else If (RegExMatch(line, "^\s*(?P<Name>.+?)::", hotstuff) > 0)
      If (InStr(y,"::") = 0) {     ;line is start of a subroutine
MsgBox ::
msgbox up:: No longer False positive!
tooltip & foo:: No longer False positive!
a =::
}
Return "OTB"
}

Function2(3, a, "3")

Function3( 5 + x, x, 7 *5 )

Function4(  )

X:		; Trick!
{
Function1()
}

MsgBox Syntax is correct!

Numpad0 & F1::
MsgBox
Escape::ExitApp
a::q	; Qwerty?
q::a   ; Or Azerty?
z::w
w::z
::rtfm::Read the foolish manual ; Doh!
:*c:kk::[code][/code]{Left 7}

<^>!m::MsgBox You pressed AltGr+m.
<^<!m::MsgBox You pressed LeftControl+LeftAlt+m.
LControl & RAlt::MsgBox You pressed AltGr itself.
*ScrollLock::MsgBox ScrollLock
~RButton & C::MsgBox You pressed C while holding down the right mouse button.
Numpad0 & Numpad2::MsgBox Numpad0 & Numpad2
Numpad1   &   Numpad2::MsgBox Numpad1 & Numpad2
~*Escape:: Return
x  &   y     up::	MsgBox