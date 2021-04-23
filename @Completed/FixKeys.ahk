SetKeyDelay, -1
SetTitleMatchMode, RegEx
Return

#Hotstring EndChars -()[]{}':;"/\,.?!`n `t^

#UseHook

^F1::Reload

CapsLock::Esc

HideToolTip:
ToolTip
Return

#MaxHotkeysPerInterval 200
#IfWinActive ahk_class Chrome_WidgetWin_1

LControl & WheelUp::Return
LControl & WheelDown::Return

#IfWinActive

;better media keys on mech keyboard
#F5::Media_Play_Pause
#F6::Media_Stop
#F7::Media_Prev
#F8::Media_Next
#F10::Volume_Mute
#F11::Volume_Down
#F12::Volume_Up

;better media keys on builtin keyboard
#Home::Media_Play_Pause
#PGUP::Media_Stop
#PGDN::Media_Prev
#End::Media_Next

;prevent F1 from showing the obnoxious help dialong in Explorer
#IfWinActive ahk_class CabinetWClass|Progman
F1::
ToolTip, The help dialog is obnoxious!
SetTimer, HideToolTip, -1000
Return
#IfWinActive

#IfWinNotActive GIMP

;some abbreviations to write notes faster
::cts::continuous
::abilitities::abilities
::diff.::differentiable
::fn.::function
::fo::of
::adn::and
::trig::trigonometric
::towards::toward
::quants::quantities
::intertial::inertial
::teh::the
::occuring::occurring
::rando::random
::ifff::if and only if

;remap the left backslash key on the main laptop to shift, since any NORMAL keyboard would have a shift key there
VKE2::LShift

;convenience shortcuts for for matched braces, especially useful when writing LISP or LaTeX
^(::Send, (){Left}
^[::Send, []{Left}
^{::Send, {{}{}}{Left}
^+;::
^$::
Send, $${Left}
Input, _, V, {Enter}{LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Capslock}{Numlock}{PrintScreen}{Pause}
If (ErrorLevel = "EndKey:Enter")
    Send, {BS}{Right}
Return
^`::Send, ````{Left}
^<::Send, <>{Left}
^+'::Send, ""{Left}
^'::Send, ''{Left}
^*::Send, **{Left}

^+k::Send, \Phi_S(x)

;some shortcuts to speed up writing LaTeX without resorting to shortening macros
:?O:\aln::$$`n\begin{{}align{}}`n`n\end{{}align{}}`n$${Left 15}
:?O:\aln*::\begin{{}align*{}}`n`n\end{{}align{}}{Up}
:?O:\enum::\begin{{}enumerate{}}`n`n`n`n\end{{}enumerate{}}{Up 2}
:?O:\ans::\begin{{}answer{}}`n;wip`n\end{{}answer{}}
:?O:\itm::\item{{}`n`n{}}{Up}
:?O:\itemm::\item{{}`n$\displaystyle $`n{}}{Left 3}
:?O:\op::\operatorname{{}{}}{Left}
^!s:: ;convert LaTeX code into a form that can be evaluated with calculators and WolframAlpha
Clipboard := ConvertLaTeX(Clipboard,_ := 1)
ToolTip, Copied!
SetTimer, HideToolTip, -1000
Return
^+v::
Send, \vec{{}{}}{Left}
Input, _, V L1, abcdefghijklmnopqrstuvwxyz0123456789
If (ErrorLevel != "max")
    Send, {Right}
Return
^+q::
Send, \mb{{}{}}{Left}
Input, _, V L1, abcdefghijklmnopqrstuvwxyz0123456789
If (ErrorLevel != "max")
    Send, {Right}
Return
^+g::
Send, \mathcal{{}{}}{Left}
Input, _, V L1, abcdefghijklmnopqrstuvwxyz0123456789
If (ErrorLevel != "max")
    Send, {Right}
Return
^+d::Send, \frac{{}\dee{}}{{}\dee t{}}
^+s::Send, \set{{}{}}{Left}
^+c::Send, \begin{{}bmatrix{}}  \end{{}bmatrix{}}{Left 14}
^+j::Send, \abs{{}{}}{Left}
^+h::Send, \tup{{}{}}{Left}

ConvertLaTeX(Code,ByRef Position)
{
    Result := ""
    Loop
    {
        CurrentChar := SubStr(Code,Position,1)
        If (CurrentChar = "" || CurrentChar = ")" || CurrentChar = "}" || CurrentChar = "]") ;end of input
            Break
        If RegExMatch(Code,"iAS)[\w\.\+\-\*\^!]+",Match,Position) ;variable or number
        {
            Position += StrLen(Match)
            Result .= Match . " "
        }
        Else If RegExMatch(Code,"iAS)\\\w+",Match,Position) ;command
        {
            Position += StrLen(Match)
            If (Match = "\frac") ;fraction command
            {
                Position ++ ;move past the opening curly brace
                Result .= "(" ConvertLaTeX(Code,Position)
                Position += 2 ;move past closing and opening brace
                Result .= "/" . ConvertLaTeX(Code,Position) . ")"
                Position ++ ;move past closing brace
            }
            Else If (Match = "\sqrt") ;root command
            {
                Position ++ ;move past the opening curly brace
                Result .= "sqrt" . ConvertLaTeX(Code,Position) . ""
                Position ++ ;move past closing brace
            }
            Else If (Match = "\cdot")
                Result .= "*"
            Else If (Match = "\sin" || Match = "\cos" || Match = "\tan" || Match = "\sec" || Match = "\csc" || Match = "\cot" || Match = "\arcsin" || Match = "\arccos" || Match = "\arctan" || Match = "\gcd" || Math = "\pi")
                Result .= SubStr(Match,2) . " "
            Else If (Match = "\dee")
                Result .= "d"
            Else If (Match = "\begin")
            {
                If RegExMatch(Code,"isAS)\{bmatrix\}(.*?)\\end\{bmatrix\}",Match,Position)
                {
                    Position += StrLen(Match)
                    StringReplace, Match1, Match1, \\, }`,{, All
                    StringReplace, Match1, Match1, &, `,, All
                    StringReplace, Match1, Match1, `r,, All
                    StringReplace, Match1, Match1, `n,, All
                    Result .= "{{" . Match1 . "}}"
                }
            }
            Else If (Match = "\left" || Match = "\right")
            {
            }
            Else
                Result .= Match . " "
        }
        Else If (CurrentChar = "\") ;non-command escape
        {
            Position += 2
            Result .= SubStr(Code,Position - 1,1)
        }
        Else If (CurrentChar = "(" || CUrrentChar = "{" || CurrentChar = "[") ;opening brace
        {
            Position ++ ;move past the opening brace
            Result .= ConvertLaTeX(Code,Position)
            Position ++ ;move past closing brace
        }
        Else ;unknown
            Position ++
    }
    Return, "(" . Result . ")"
}

;some convenience stuff to deal with the frustrating parts of Texstudio
#IfWinActive TeXstudio ahk_class QWidget
Home::Send, +{Home}{Right}{Left} ;for some reason Home moves the preview even when in the editor
End::Send, +{End}{Left}{Right} ;for some reason End moves the preview even when in the editor
#IfWinActive

/*
;some hotkeys to allow typing on an old broken keyboard
!j::Send, m
!k::Send, `,
!l::Send, .
!'::Send, {Enter}
!Home::Send, {PGUP}
!End::Send, {PGDN}

+!j::Send, +m
+!k::Send, +`,
+!l::Send, +.
+!'::Send, +{Enter}
+!Home::Send, +{PGUP}
+!End::Send, +{PGDN}