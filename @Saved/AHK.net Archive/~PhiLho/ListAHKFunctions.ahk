/*
ListAHKFunctions.ahk

Read an AutoHotkey script and list the function definitions with their line number
and their parameter list.

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.03.000 -- 2006/11/30 (toralf & PL) -- Better detection of hotstuff,
             splitted between hotkeys (and key remapping) and hotstrings.
             Use GUI instead of MsgBox to display results.
 1.02.001 -- 2006/11/29 (PL) -- Making labels more tolerant.
 1.02.000 -- 2006/11/21 (PL) -- Encapsulation of state handling.
 1.01.000 -- 2006/11/18 (PL) -- Added listing of labels and hotstuff.
 1.00.000 -- 2006/11/17 (PL) -- Creation.
*/
/* Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006 Philippe Lhoste / PhiLhoSoft
*/
; Test section (for working standalone)
#SingleInstance Force
#NoEnv

AskFile:
script =
scriptName =
; End of test section

; Defaults
If script =
{
	If scriptName =
	{
		FileSelectFile scriptName
		If ErrorLevel = 1
			scriptName = SyntaxFunctions.ahk
	}
	FileRead script, %scriptName%
}
; End of test section

#DEBUG := false

; Legal characters for AHK identifiers
identifierRE = ][#@$?\w
; Legal characters in function definition parameter list
parameterListRE = %identifierRE%,=".\s-
; Legal line comment
lineCommentRE = \s*(?:\s;.*)?$

functionNb := 1
labelNb := 1
hotkeyNb := 1
hotstringNb := 1
InitState()

Loop Parse, script, `n, `r
{
	line := A_LoopField
;~ 	OutputDebug [%A_Index%] %line%
	If (RegExMatch(line, "^\s*(?:;.*)?$") > 0)
	{
		; Empty line or line with comment, skip it
		; We do nothing...
	}
	Else If IsState(#COMMENT)
	{
		; In a block comment
		If (RegExMatch(line, "^\s*\*/") > 0)
		{
			; End of block comment
			RemoveState(#COMMENT, "end of comment")
			; "*/ function_def()" is legal but quite perverse... I won't support this
		}
	}
	Else If IsState(#CONTSECTION)
	{
		; In a continuation section
		If (RegExMatch(line, "^\s*\)") > 0)
		{
			; End of continuation section
			SetState(#DEFAULT, "end of continuation section")
		}
	}
	Else If (RegExMatch(line, "^\s*/\*") > 0)
	{
		; Start of block comment, to skip
		AddState(#COMMENT)
	}
	Else If (RegExMatch(line, "^\s*\(") > 0)
	{
		; Start of continuation section, to skip
		SetState(#CONTSECTION)
	}
	; Correct detection of hotstuff (hotstrings, hotkeys, key remapping) is tricky
	; but has been solved by toralf, Thanks!
	; Some false positives are still possible (eg. MsgBox Up::) but very unlikely!
	Else If (RegExMatch(line, "i)^\s*(?P<Name>[^\s:]+?(?:\s+&\s+[^\s:]+?)?(?:\s+up)?)::", hotkey) > 0)
	{
		hotkeyList#%hotkeyNb%@name := hotkeyName
		hotkeyList#%hotkeyNb%@line := A_Index
		hotkeyNb++
		SetState(#DEFAULT, "hotkey: " . hotkeyName)
	}
	; I simplified the expression for hotstrings (smaller=faster) as we don't really care to
	; have exact syntax of options...
;~ 	Else If (RegExMatch(line, "i)^\s*(?P<Name>:(?:\*0?|\?0?|B0?|C[01]?|K(?:-1|\d+)|O0?|P\d+|R0?|S[IPE]|Z0?)*:.+?)::", hotstring) > 0)
	Else If (RegExMatch(line, "i)^\s*:[*?BOCKSIPREZ\d-]*:(?P<Name>.+?)::", hotstring) > 0)
	{
		hotstringList#%hotstringNb%@name := hotstringName
		hotstringList#%hotstringNb%@line := A_Index
		hotstringNb++
		SetState(#DEFAULT, "hotstring: " . hotstringName)
	}
	; Labels are very tolerant...
	; Note: L:L: is a legal label, but I won't handle this special case.
	; Likewise, labels starting with an opening parenthesis will be seen as continuation section start.
	; I hope it is unlikely to meet them...
	Else If (RegExMatch(line, "^\s*(?P<Name>[^\s,:;``][^\s,:``]*):" . lineCommentRE, label) > 0)
	{
		labelList#%labelNb%@name := labelName
		labelList#%labelNb%@line := A_Index
		labelNb++
		SetState(#DEFAULT, "label: " . labelName)
	}
	Else If IsState(#DEFAULT)
	{
		fp := RegExMatch(line, "^\s*(?P<Name>[" . identifierRE . "]+)\((?P<Parameters>[" . parameterListRE . "]*)(?P<ClosingParen>\)\s*(?P<OpeningBrace>\{)?)?" . lineCommentRE, function)
		If (fp > 0)
		{
			; Found a function call or a function definition
			SetState(#FUNCTION, functionName)
			functionList#%functionNb%@name := functionName
			functionList#%functionNb%@parameters := functionParameters
			functionList#%functionNb%@line := A_Index
			If (functionClosingParen != "")
			{
				; With closed parameter list
				If (functionOpeningBrace != "")
				{
					; Found! This is a function definition
					functionNb++	; Validate the finding
					SetState(#DEFAULT, "Function def!")
				}
				Else
				{
					; List of parameters is closed, just search for opening brace
					AddState(#TOBRACE)
				}
			}
			Else
			{
				; With open parameter list
				; Search for closing parenthesis
				AddState(#INPARAMS)
			}
		}
	}
	Else If IsState(#FUNCTION)
	{
		; After a function definition or call
		If IsState(#INPARAMS)
		{
			; Looking for ending parenthesis
			If (RegExMatch(line, "^\s*(?P<Parameters>,[" . parameterListRE . "]+)(?P<ClosingParen>\)\s*(?P<OpeningBrace>\{)?)?" . lineCommentRE, function) > 0)
			{
				; Correct additional set of parameters
				functionList#%functionNb%@parameters := functionList#%functionNb%@parameters . functionParameters
				If (functionClosingParen != "")
				{
					; List of parameters is closed
					If (functionOpeningBrace != "")
					{
						; Found! This is a function definition
						functionNb++	; Validate the finding
						SetState(#DEFAULT, "function def!")
					}
					Else
					{
						; Just search for opening brace
						RemoveState(#INPARAMS)
						AddState(#TOBRACE)
					}
				}
				; Otherwise, we continue
			}
			Else
			{
				; Incorrect syntax for a parameter list, it was probably just a function call
				SetState(#DEFAULT, "NO function def!")
			}
		}
		Else If IsState(#TOBRACE)
		{
			; Looking for opening brace
			; There can be only empty lines and comments, which are already processed
			If (RegExMatch(line, "^\s*(?:\{)" . lineCommentRE) > 0)
			{
				; Found! This is a function definition
				functionNb++	; Validate the finding
				SetState(#DEFAULT, "function def!")
			}
			Else
			{
				; Incorrect syntax between closing parenthesis and opening brace,
				; it was probably just a function call
				SetState(#DEFAULT, "NO function def!")
			}
		}
	}
}

; Compile the collected information

functionNb--
rf =
labelNb--
rl =
hotkeyNb--
rhk =
hotstringNb--
rhs =
Loop %functionNb%
{
	pl := RegExReplace(functionList#%A_Index%@parameters
			, "\s\s*", " ")	; Replace multiple blank chars with simple space
	rf :=
( Join
	rf . "[" .
	functionList#%A_Index%@line . "] " .
	functionList#%A_Index%@name . "(" .
	pl . ")`n"
)
}
Loop %labelNb%
{
	rl :=
( Join
	rl . "[" .
	labelList#%A_Index%@line . "] " .
	labelList#%A_Index%@name . "`n"
)
}
Loop %hotkeyNb%
{
	rhk :=
( Join
	rhk . "[" .
	hotkeyList#%A_Index%@line . "] " .
	hotkeyList#%A_Index%@name . "`n"
)
}
Loop %hotstringNb%
{
	rhs :=
( Join
	rhs . "[" .
	hotstringList#%A_Index%@line . "] " .
	hotstringList#%A_Index%@name . "`n"
)
}

; Add button first to avoid having the text field content selected
Gui Add, Button, gAgain, Again
Gui Add, Edit, w500 h600 vshowResult
Gui Show

GuiControl, , showResult,
(
Found in '%scriptName%':
# %functionNb% functions:

%rf%
# %labelNb% labels:

%rl%
# %hotkeyNb% hotkeys and key remappings:

%rhk%
# %hotstringNb% hotstrings:

%rhs%
)

Return

Again:
Gui Destroy
Goto AskFile

GuiClose:
GuiEscape:
ExitApp

; Set of functions to manage the state
; By encapsulating it, I hide the gory details and
; even can change the implementation.
; Plus I can add debugging trace transparently.

SetState(_newState, _message="")
{
	global #state

	#state := _newState
	DebugState(_message)
}

AddState(_newState, _message="")
{
	global #state

	#state := #state . _newState
	DebugState(_message)
}

RemoveState(_state, _message="")
{
	global #state

	StringReplace #state, #state, %_state%
	DebugState(_message)
}

IsState(_state)
{
	global #state

	If #state contains %_state%
		Return true
	Return false
}

DebugState(_message="")
{
	local debug

	If #DEBUG
	{
		debug := "State: " . ShowState()
		If _message !=
			debug = %debug% (%_message%)
		OutputDebug %debug%
	}
}

ShowState()
{
	local sl, debug

	sl = #DEFAULT-#COMMENT-#CONTSECTION-#FUNCTION-#INPARAMS-#TOBRACE
	Loop Parse, sl, -
	{
		If IsState(%A_LoopField%)
		{
			debug = %debug% %A_LoopField%
		}
	}
	Return debug
}

; Mandatory init.
InitState()
{
	global

	; Create global variables to avoid using strings in calls, looking nicer...
	; Plus using shorter internal strings, it is slightly more efficient.
	; Plus I just hide the implementation, for example, I could have used bits
	; setting, resetting and testing, but I doubt it is much more efficient in AHK
	; and it is fun this way anyway...
	#DEFAULT = d
	#COMMENT = c
	#CONTSECTION = s
	#FUNCTION = f
	#INPARAMS = p
	#TOBRACE = b
	#state := #DEFAULT
	DebugState("Init")
}