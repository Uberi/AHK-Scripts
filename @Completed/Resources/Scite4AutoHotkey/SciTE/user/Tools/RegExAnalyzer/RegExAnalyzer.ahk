; RegEx Analyzer (Alpha 2)

#SingleInstance ignore
#NoEnv
#NoTrayIcon
SetBatchLines, -1
Critical

s := Chr(1) ; delimiter for Gui and parsing loops
sl := Chr(2)

confLoc := A_ScriptDir . "\RegExAnalyzer.ini"
IniRead, fontCode, %confLoc%, UI, CodeFont, Courier New
IniRead, fontInfo, %confLoc%, UI, InfoFont, Verdana
IniRead, fontSz, %confLoc%, UI, CodeFontSize, s10
IniRead, fontEm, %confLoc%, UI, Emphasis, bold cNavy
IniRead, exp, %confLoc%, Autosave, Exp, "%s%``ai)^[a-z]{2,5}\.*?(?P<Char>\w+|\W?\d)\b.literalStr$%s%%s%"
IniRead, txt, %confLoc%, Autosave, Text, "abcd.-1!literalStr"
IniRead, repl, %confLoc%, Autosave, Replace, ""
i := "exp,txt,repl"
Loop, Parse, i, `,
	%A_LoopField% := RegExReplace(%A_LoopField%, "^""|""$")
StringReplace, txt, txt, ``n, `n, All

Gui, +Resize +MinSize +Delimiter%s%
Gui, Add, Tab, vTab w375 r6.4 Theme, &RegEx%s%&Context
Gui, Tab, 1
Gui, Font, %fontSz% %fontEm%, %fontCode%
Gui, Add, ComboBox, vExp Section w290 gType, % SubStr(exp, 2)
Gui, Font
Gui, Add, Button, vSave ys w50 gSave, &Delete
Gui, Font, , %fontInfo%
Gui, Add, TreeView, vTree xs w350 r5
Gui, Font
Gui, Tab, 2
Gui, Add, Edit, vTxt w350 r2.3 Limit2500 gType, %txt%
Gui, Add, Edit, vRes w350 r2.3 ReadOnly
Gui, Font
Gui, Add, Text, vReplLbl Section BackgroundTrans, Replace:
Gui, Font, %fontSz%, %fontCode%
Gui, Add, Edit, vRepl ys w295 gType, %repl%
Gui, Font
Gui, Tab
Gui, Add, ListView, vList xm w375 r3, Variable%s%Set%s%Position%s%Match
iSpl := 0.7
Gui, Show, Hide, RegEx Analyzer (Alpha 2)
Gui, Show, w600 h480 Center
OnExit, Closing

Type:
GuiControl, , Save, % (in() && ce != "") ? "&Delete" : "&Save"
GuiControl, % (ce = "") ? "Disable" : "Enable", Save
If InStr(ce, s) || InStr(ce, sl)
{
	Gui, +OwnDialogs
	MsgBox, 48, Illegal Character, Regular expression contains parsing delimiter which will be ignored., 5
	StringReplace, ce, ce, %s%, , All
	StringReplace, ce, ce, %sl%, , All
}
GuiControlGet, txt, , Txt
GuiControlGet, repl, , Repl
GuiControl, -Redraw, Tree
GuiControl, -Redraw, List
TV_Delete()
LV_Delete()
res := RegExReplace(txt, RegExReplace(ce, "``[nra](?=\w*\)"), repl)
If ErrorLevel
	TV_Add(ErrorLevel)
Else {
	Analyze(ce)
	TV_Modify(0, "Sort")
	i = 0
	Loop {
		If !(i := TV_GetNext(i, "Full"))
			Break
		TV_Modify(i, "Sort")
		TV_GetText(t, i)
		TV_Modify(i, "", int(t, true))
	}
	Match(ce, txt)
}
GuiControl, , Res, %res%
GuiControl, +Redraw, Tree
GuiControl, +Redraw, List
Return

Save:
If in()
	StringReplace, exp, exp, %s%%ce%%s%, %s%
Else
	exp .= ce . s
StringReplace, exp, exp, %s%%s%, %s%, All
GuiControl, , Exp, %exp%%s%
Goto, Type
Return

GuiSize:
Anchor("Tab", "w h" . iSpl)
Anchor("Exp", "w", true)
Anchor("Save", "x", true)
Anchor("Tree", "w h" . iSpl)
Anchor("Txt", "w h" . iSpl / 2)
Anchor("Res", "y" . iSpl / 2 . "w h" . iSpl / 2)
Anchor("ReplLbl", "y" . iSpl)
Anchor("Repl", "w y" . iSpl, true)
Anchor("List", "w y" . iSpl . " h" . 1 - iSpl)
Loop, 4
	LV_ModifyCol(A_Index, "AutoHdr")
Return

GuiClose:
ExitApp
Return

Closing:
If !in()
	exp .= ce . s
StringReplace, exp, exp, %s%%s%, %s%, All
StringReplace, exp, exp, %s%%ce%%s%, %s%%ce%%s%%s%, All
IniWrite, "%exp%", %confLoc%, Autosave, Exp
GuiControlGet, txt, , Txt
StringReplace, txt, txt, `n, ``n, All
IniWrite, "%txt%", %confLoc%, Autosave, Text
GuiControlGet, repl, , Repl
IniWrite, "%repl%", %confLoc%, Autosave, Replace
ExitApp
Return

Analyze(e, p = 0, f = 0, sk = false) {
	global s, sl
	c := "Vis"
	cx := c . " Bold Expand"
	d := ": "
	If RegExMatch(e, "^[\w\s``]+(?<!\\)\)", m)
		pm := TV_Add(int(0) . "Modifiers", p, cx)
	StringTrimLeft, e, e, StrLen(m)
	Loop, Parse, m, , )
	{
		q := A_LoopField
		If (ql = "``")
		{
			If (q = "n")
			 	t := "Using linefeed (LF/``n) for newline"
			Else If (q = "r")
			 	t := "Using carrage return (CR/``r) for newline"
			Else If (q = "a")
			 	t := "Recognizes any type of newline (CRLF/CR/LF)"
		}
		Else If (q = "i")
			t := "Case-insensitive matching"
		Else If (q = "m")
		 	t := "Multiline"
		Else If (q = "s")
		 	t := "DotAll. This causes a period (.) to match all characters including newlines"
		Else If (q = "x")
		 	t := "Ignores whitespace characters in the pattern"
		Else If (q = "A")
		 	t := "Forces the pattern to be anchored"
		Else If (q = "D")
		 	t := "Forces dollar-sign ($) to match at the very end of haystack"
		Else If (q = "J")
		 	t := "Allows duplicate named subpatterns"
		Else If (q = "U")
		 	t := "Ungreedy - *+?{}"
		Else If (q = "X")
		 	t := "Enables PCRE features that are incompatible with Perl"
		Else If (q = "P")
		 	t := "Position mode"
		Else If (q = "S")
		 	t := "Studies the pattern to try improve its performance"
		Else
		{
			ql := q
			Continue
		}
		TV_Add((ql = "``" ? ql : "") . q . d . t, pm)
		ql =
	}
	If (z := grep(e, "(?<=(?<!\\)\\Q).*?(?=(?<!\\)\\E)", v))
	{
		StringSplit, z, z, %s%
		Loop, Parse, v, %s%
		{
			If (A_LoopField != "")
			{
				t := A_LoopField
				q := TV_Add(int(z%A_Index%) . "\Q...\E: Literal String", f, cx)
				TV_Add((StrLen(t) > 5 ? SubStr(t, 1, 4) . "..." : t) . ": String", q)
				rem(e, "\Q" . t . "\E")
			}
		}
	}
	rp := "(?<=(?<!\\)\()(?:(?:[^\)]*\([^\)]*\)[^\)]*)|[^\)]*)(?<!\\)(?=\))"
	If ((sk = 0) && (z := grep(e, rp, v)))
	{
		RegExReplace(v, "(?<!\\)\(", "", q)
		If q
			z := grep(e, "(?<=(?<!\\)\()(?:(?:[^\)]*\([^\)]*\)[^\)]*)|[^\)]*)([^\(\)]*(?<!\\)\)){" . (q - 1) . "}(?<!\\)(?=\))", v)
		StringSplit, z, z, %s%
		Loop, Parse, v, %s%
		{
			If (A_LoopField = "")
				Continue
			If (InStr(A_LoopField, "?") = 1)
			{
				If (InStr(A_LoopField, "?:") = 1)
					t := "Non-capturing subpattern"
				Else If (InStr(A_LoopField, "?=") = 1)
					t := "Positive lookahead"
				Else If (InStr(A_LoopField, "?!") = 1)
					t := "Negative lookahead"
				Else If (InStr(A_LoopField, "?<=") = 1)
					t := "Positive lookbehind"
				Else If (InStr(A_LoopField, "?<!") = 1)
					t := "Negative lookbehind"
				Else If RegExMatch(A_LoopField, "(?<=^\?P<|^\?<)[^>]+|(?<=^\?<)[^>]+|(?<=^\?')[^']+", t)
					t := "Named captured subpattern: '" . t . "'"
			}
			Else
				t := "Captured subpattern"
			RegExMatch(A_LoopField, "P)^\?(?::|=|!|<=|<!|P?<[^>]+>|P?'[^']')", q)
			q1 := SubStr(A_LoopField, q + 1)
			rem(e, "(" . A_LoopField . ")")
			Analyze(q1, t := TV_Add(int(z%A_Index% + f) . t, p, cx), z%A_Index% + f, InStr(A_LoopField, "|"))
		}
	}
	If (sk != "l" && sk && (z := grep(e, "(?=(?<!\\)[\(\)]|^).*?(?<!\\)\|.*?(?=(?<!\\)[\)]|$)", v)))
	{
		If sk
			v := e, z1 := 1
		Else
		{
			RegExReplace(SubStr(v, InStr(v, "|")), "(?<!\\)\(", "", q)
			If q
				z := grep(e, "(?<=(?<!\\)\()(?:(?:[^\)]*\([^\)]*\)[^\)]*)|[^\)]*)([^\(\)]*(?<!\\)\)){" . q . "}(?<!\\)(?=\))", v)
			StringSplit, z, z, %s%
		}
		Loop, Parse, v, %s%
		{
			If (A_LoopField = "")
				Continue
			q := TV_Add(int(q1 := z%A_Index% + f) . "Alternation", p, cx)
			q2 := 0
			Loop, Parse, A_LoopField, |
			{
				Analyze(A_LoopField, TV_Add(A_Index = 1 ? "Either" : "Or", q, cx), q1 + q2)
				q2 += StrLen(A_LoopField)
			}
			rem(e, A_LoopField)
		}
	}
	If (sk != "l" && (z := grep(e, "(?:(?<!\\)(?:\[[^\]]*\]|\{[^\}]*\})|" . rp . "|\\?.)(?:\{\d+(?:,\d+)?\}|\*|\+|\?)\??", v)))
	{
		StringSplit, z, z, %s%
		Loop, Parse, v, %s%
		{
			If (A_LoopField = "")
				Continue
			Else If (A_LoopField = "(?")
				Continue
			RegExMatch(A_LoopField, "([^\*\+\?]+)(\{(\d+)(?:,(\d+))?\}|\*|\+|\?)(\?)?$", q)
			If (InStr(q2, "{") = 1)
			{
				If q4
					t := "Repeat " . q3 . " to " . q4 . " times"
				Else
					t := "Repeat " . q3 . " times"
			}
			Else If (q2 = "*")
				t := "Repeat zero or more times"
			Else If (q2 = "+")
				t := "Repeat once or more"
			Else If (q2 = "?")
				t := "Optionally match"
			rem(e, A_LoopField)
			Analyze(q1, TV_Add(int(z%A_Index% + f) . t . (q5 = "?" ? " lazily" : ""), p, cx), z%A_Index% + f)
		}
	}
	If (z := grep(e, "(?<!\\)\\x[\da-f]{1,2}|(?<!\\)\\.|\^|\$|\.|(?<!\\)\[[^\]]*(?<!\\)]|" . sl . "|[^\\\^\$\.]+", v))
	{
		StringSplit, z, z, %s%
		Loop, Parse, v, %s%
		{
			q := A_LoopField
			StringReplace, q, q, %sl%, , All
			If (q = "")
				Continue
			If (q = sl)
				Continue
			If (sk = "l")
				t := (StrLen(q) = 1) ? "Character" : "String"
			Else If (InStr(q, "\") = 1)
			{
				If (q == "\d")
					t := "Matches any single digit"
				Else If (q == "\D")
					t := "Matches any single non-digit"
				Else If (q == "\s")
					t := "Matches any single whitespace character"
				Else If (q == "\S")
					t := "Matches any single non-whitespace character"
				Else If (q == "\w")
					t := "Matches any single alphanumeric or underscore character"
				Else If (q == "\W")
					t := "Matches any single non-alphanumeric or underscore character"
				Else If (q == "\A")
					t := "Matches at the start of the string the pattern is applied to"
				Else If (q == "\Z")
					t := "Matches at the end of the string the regex pattern is applied to"
				Else If (q == "\z")
					t := "Matches the position at the end of the string the regex pattern is applied to"
				Else If (q == "\b")
					t := "Matches at the position between a word character and a non-word character"
				Else If (q == "\B")
					t := "Matches at the position between two word characters as well as two non-word characters"
				Else If RegExMatch(q, "(?<=^\\x)[\da-f]{1,2}", q1)
					t := "Character: '" . Chr("0x" . q1) . "'"
				Else
					t := "Escaped character"
			}
			Else If InStr(q, "[") = 1 {
				t := (InStr(q, "[^") = 1 ? "Negative s" : "S") . "et: "
				grep(SubStr(q, 2, -1), ".-.|\\.|.", q1)
				Loop, Parse, q1, %s%
					If (A_LoopField = "\d")
						t .= "digits, "
					Else If (A_LoopField = "\D")
						t .= "non-digits, "
					Else If (A_LoopField = "\s")
						t .= "spaces, "
					Else If (A_LoopField = "\S")
						t .= "non-spaces, "
					Else If (A_LoopField = "\w")
						t .= "word characters, "
					Else If (A_LoopField = "\W")
						t .= "non-word characters, "
					Else If RegExMatch(A_LoopField, "(.)-(.)", q1)
						t .= q11 . "..." . q12 . ", "
					Else If (A_LoopField != "" && A_LoopField != "^" && !InStr(t, "'" . A_LoopField . "'"))
						t .= "'" . A_LoopField . "', "
				t := SubStr(t, 1, -2)
			}
			Else If (q = "^")
				t := "Matches the start of the string"
			Else If (q = "$")
				t := "Matches the end of the string"
			Else If (q = ".")
				t := "Matches any character"
			Else If (StrLen(q) = 1)
				t := "Character"
			Else
				t := "String"
			If (StrLen(q) > 5)
				q := SubStr(q, 1, 4) . "..."
			TV_Add(int(z%A_Index% + f) . q . d . t, p)
		}
	}
}

in() {
	global
	GuiControlGet, ce, , Exp
	Return InStr(exp, s . ce . s)
}

rem(ByRef e, r) {
	global sl
	Loop, % StrLen(r)
		p .= sl
	StringReplace, e, e, %r%, %p%
}

int(n, v = false) {
	w = 5
	e := ": "
	If v
		Return, RegExMatch(n, "^\d{" . w . "}" . e) ? SubStr(n, w + StrLen(e) + 1) : n
	Loop, % w - StrLen(n)
		z .= 0
	Return z . n . e
}

Match(e, c) {
	global s
	e := RegExReplace(e, "``.")
	LV_Add("Vis", "", RegExMatch(c, e, v), v)
	r = (?<!\\)\((?:(?:[^\)]*\([^\)]*\)[^\)]*)|[^\)]*)(?<!\\)\)
	r = ((?:%r%|(?<!\\)(?:\[[^]]*(?<!\\)\]|\{[^\}](?<!\\)\})|(?<!\\)\\[^\.aAbBzZQE]|(?<!\\)\.)(?:\{\d+(?:,\d+)?\}|[\*\+\?])?\??)
	# = 0
	Loop
		If # := RegExMatch(e, r, qx, ++#) {
			If !InStr(q, "(" . qx . ")")
				q .= qx . s
		}
		Else Break
	e := RegExReplace(e, r, "($1)")
	RegExMatch(c, "P" . (RegExMatch(e, "^\w*(?<!\\)\)") ? "" : ")") . e, v)
	n = 0
	Loop, Parse, q, %s%
		If A_LoopField !=
		{
			q = %A_LoopField%
			If RegExMatch(q, "^\(\?[P<']{1,2}([^>']+)", t)
				t = %t1%
			Else If InStr(q, "(") = 1
				t := ++n
			Else t =
			LV_Add("", t, q, vPos%A_Index%, SubStr(c, vPos%A_Index%, vLen%A_Index%))
		}
	Loop, 4
		LV_ModifyCol(A_Index, "AutoHdr")
}

grep(h, n, ByRef v, # = 1) { ; http://www.autohotkey.net/~Titan/regexmatchall.html
	global s ; mod
	Loop
		If # := RegExMatch(h, n, t, #)
			p .= # . s, y .= t . s, # += StrLen(t)
		Else Return, p, v := y
}

Anchor(c, a, r = false) { ; v3.5.1 - Titan
	static d
	GuiControlGet, p, Pos, %c%
	If !A_Gui or ErrorLevel
		Return
	i = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%.`n%A_Gui%:%c%=
	StringSplit, i, i, .
	d .= (n := !InStr(d, i9)) ? i9 :
	Loop, 4
		x := A_Index, j := i%x%, i6 += x = 3
		, k := !RegExMatch(a, j . "([\d.]+)", v) + (v1 ? v1 : 0)
		, e := p%j% - i%i6% * k, d .= n ? e . i5 : ""
		, RegExMatch(d, RegExReplace(i9, "([[\\\^\$\.\|\?\*\+\(\)])", "\$1")
		. "(?:([\d.\-]+)/){" . x . "}", v)
		, l .= InStr(a, j) ? j . v1 + i%i6% * k : ""
	r := r ? "Draw" :
	GuiControl, Move%r%, %c%, %l%
}