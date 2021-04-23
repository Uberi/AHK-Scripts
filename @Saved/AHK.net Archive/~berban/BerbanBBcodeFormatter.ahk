s := "[img]http://www.autohotkey.net/~berban/spacer.png[/img]"
hl := s s "[img]http://www.autohotkey.net/~berban/HorizontalLine.png[/img]"
n := "`r`n"
TrayTip, Forum Formatter, Select a file containing your write-up and press SPACE
Return

Space::
TrayTip
If !FileExist(FileName := Clip()) {
	SoundPlay, %A_Windir%\Media\Windows Ding.wav
	Return
}
FileRead, File, %FileName%
Loop, Parse, File, % RXMS(File, "m)^([A-Z]+):$", "mHeader:1 u t c d")
	If (Header%A_Index% = "TITLE")
		  Output .= f(24, RegExReplace(A_LoopField, "^[\w()]+", "[b]$0[/b]")) n n
	Else If (Header%A_Index% = "INTRO")
		  Output .= n n f("darkred", f(12, A_LoopField)) n n
	Else If (Header%A_Index% = "FUNCTION")
		  @ := RegExReplace(A_LoopField, "^[\w]+", "[b]$0[/b]")
		, @ := RegExReplace(@, "([\w]+),", "[b][color¢darkblue]$1[/color][/b],")
		, @ := RegExReplace(@, "([\w]+)=", "[color¢blue]$1[/color]=")
		, @ := RegExReplace(@, """.*?""", "[color¢red]$0[/color]")
		, @ := RegExReplace(@, "=([0-9.]+)", "=[color¢green]$1[/color]")
		, @ := RegExReplace(@, "=([A-Za-z]+)", "=[color¢orange]$1[/color]")
		, @ := RegExReplace(@, "i)byref", "[color¢green]ByRef[/color]")
		, @ := RegExReplace(@, "¢", "=")
		, Output .= hl n n n s s s s s s f(22, @) n
	Else If (Header%A_Index% = "USAGE")
		Output .= n n f(16, f("b", "Usage: ")) f("olive", RegExReplace(RegExReplace(A_LoopField, "(\R\t+.*)+", "[/color][code]$0[/code][color=olive]"), "(\R\K\t|code]\K\R\t)")) n n
	Else If (Header%A_Index% = "PARAMETERS")
		  @ := RegExReplace(A_LoopField, "m)^(\w+):", "[*][b][color=green]$1[/color][/b]:")
		, @ := RegExReplace(@, "(\R\t+.*)+", "[/size][list][size=11]$0[/size][/list][size=12]")
		, @ := RegExReplace(@, "m)^(\t+)(\w) - (.*?):", "[*][/size][b][color=brown][size=13]$2[/size][/color][/b][size=11] - [u]$3[/u]:")
		, @ := RegExReplace(@, "\R\[\*\]", "[*]")
		, Output .= hl n n f(16, f("b", "Parameters:")) "[size=12]" f("list", @) "[/size]" n
	Else If (Header%A_Index% = "BENEFITS")
		  @ := RegExReplace(A_LoopField, "^(.*)\R", "[b][size=16][i]$1[/i][/b][/size][list][*]")
		, @ := RegExReplace(@, "m)^[^\[]", "[*]$0")
		, Output .= hl n n @ "[/list]" n
	Else If (Header%A_Index% = "EXAMPLES")
		  Output .= hl n n f(16, f("b", "Some working examples:")) n f("code", A_LoopField) n n
	Else If (Header%A_Index% = "CODE")
		  Output .= hl n n f(16, f("b", "Code:")) n f("code", A_LoopField) n n
	Else If (Header%A_Index% = "NOTES")
		  @ := RegExReplace(A_LoopField, "m)^\w", "[*]$0")
		, @ := RegExReplace(@, "\R")
		, Output .= hl n n f(16, f("i", f("u", "Notes:"))) f("list", @) n
Output .= n f(8, f("i", "~ Created with [url=http://www.autohotkey.com/forum/viewtopic.php?p=467709]Quick Functions for Forums[/url] by berban ~"))
SplitPath, FileName, , Dir, Ext, Name
FileDelete, %Dir%\%Name%_Forums.%Ext%
FileAppend, %Output%, %Dir%\%Name%_Forums.%Ext%
MsgBox, 262144, Quick Functions: All Set!, Operation completed successfully!`n`n - %Header0% section(s) found.`n - BBCode copied to clipboard.`n - %Name%_Forums.%Ext% created`n`nPress OK to exit.
ClipBoard := Output

Esc::
ExitApp

f(Formatting, String)
{
	Colors := "darkred red orange brown yellow green olive cyan blue darkblue indigo violet white black"
	Return "[" ((@ := InStr(A_Space Colors A_Space, A_Space Formatting A_Space)) ? "color=" : RegExMatch(Formatting, "^\d+$", $) ? "size=" : "") Formatting "]" String "[/" (@ ? "color" : $ ? "size" : Formatting) "]"
}

ExitApp

;=============================================[Std.ahk]=============================================

Clip(Text="", ReSelect="") ;http://www.autohotkey.com/forum/viewtopic.php?p=467710
{
	Static BackUpClip, Stored
	If (A_ThisLabel = "Clip")
		Return Stored := "", Clipboard := BackUpClip, BackUpClip := ""
	If Stored
		SetTimer, Clip, Off
	Else {
		Stored := True
		BackUpClip := ClipboardAll
	}
	Clipboard := ""
	If (Text <> "") {
		Clipboard := Text
		ClipWait, 3
		SendInput, ^v
	} Else {
		SendInput, ^c
		ClipWait, .2
	}
	SetTimer, Clip, -700
	If (Text = "")
		Return Clipboard
	Else If (ReSelect = True) or (Reselect and (StrLen(Text) < 3000)) {
		StringReplace, Text, Text, `r, , All
		SendInput, % "{Shift Down}{Left " StrLen(Text) "}{Shift Up}"
	}
	Return
	Clip:
	Return Clip()
}

RXMS(ByRef String, Needle, Options="") ;http://www.autohotkey.com/forum/viewtopic.php?p=470488
{
	Global
	Local $, @, @1, @2, @3, @4, # := 0, FoundPos := 1, LastFound := 1, Matches := 0, Splits := 0, Output := 0, StringToReturn, LastTime, Error, Delimiter, Commands := "m|s|p|c|r|d|e|t|u|i|x", Documentation := "http://www.autohotkey.com/forum/viewtopic.php?p=470488"
	;---------------------------------OPTIONS:-----------------------------------------------------------
	; INITIAL              DEFAULT                NAME                   ABOUT
	, m := "",             m_def := 0             ;m = Matches           Name of global pseudo-array in which to store matching patterns
	, s := "",             s_def := 0             ;s = Splits            Name of global pseudo-array in which to split the string
	, p := "",             p_def := 1             ;p = Pattern           Name or number of subpattern to use as a match instead of using the entire needle
	, c := "",             c_def := "ms"          ;c = Consolidate       Blank entries are ignored (excluded from pseudoarrays, r and d outputs, and match/split counts)
	, r := "",             r_def := "`n"          ;r = Return            Return a string containing all instances delimited by string passed to the r option
	, d := "",             d_def := "FirstUnused" ;d = Delimiter         Stores all matches or splits as a delimited list in the byref String variable, for a parsing loop or StringSplit
	, e := "xae",          e_def := ""            ;e = Error Behavior    Choose what the function will do upon encountering an error. Indicate/omit a, e, p, or x to turn on/off alerts (via msgbox), exiting (stops the current thread), pausing the script, or errorlevel setting, respectively. c will let the function continue executing if possible upon encountering an error; o will alert upon parameter formatting issues.
	, t := "",             t_def := "\s*"         ;t = Trim              Indicate a regular expression to trim from the beginning and end of each split segment
	, u := "",             u_def := "s"           ;u = Use match/splits  [Only applies with r or d]: 
	, i := False,          i_def := True          ;i = Ignore non-subpat [Only applies with p]: Omits segments of the match that do not match subpattern p from the split segments as well
	, x := True,           x_def := False         ;x = Trim Extremities  [Only applies with t]: Indicates whether the t option will trim from the string extremities, i.e. beginning of the first split and end of last split
	;----------------------------------------------------------------------------------------------------
	While (FoundPos := RegExMatch(Options, "Pi)\s*\K(?:" Commands ")(?:\\?[^\\ ]|\\\\|\\ )*", Output, FoundPos + Output))
		# += Output + 1, @ := SubStr(Options, FoundPos, 1), %@% := ("" = $ := RegExReplace(SubStr(Options, FoundPos + 1, Output - 1), "(?<!\\)(\\*)\1(?:\\( ))?", "$1$2")) ? %@%_def : $
	If (# := StrLen(Options) + 1 - #) and InStr(e, "o")
		Error := "Problem With Options Param [1]: The options parameter was given as follows:`n" Options "`n" # " of those characters w" (# = 1 ? "as" : "ere") " unused by the script, perhaps due to unsupported commands or extra spaces."
	Else If m and (m = s) and !InStr(e, "c")
		Error := "Duplicate Variable Name [2]: Both the m and s options are set to output to the pseudo-array named """ m """.`nPlease choose a unique name for each output array."
	Else If (@%p% := True) and RegExMatch("", Needle, @)
		Error := "Null Needle [3]: The needle is: """ Needle """`nThe needle cannot match a blank string."
	Else If and p and @%p% and (!InStr(e, "c") or (p := ""))
		Error := "Missing Subpattern [4]: The needle is: """ Needle """`n""" p """ was indicated for p (subpattern to use) but the needle does not contain this subpattern."
	Else If (d <> "")
		If (r <> "") and !InStr(e, "c")
			Error := "Invalid Option Combination [5]: You may not specify both r (return array as a string) and d (return a delimited list)."
		Else If (StrLen(d) = 1) {
			If InStr(String, d) and !InStr(e, "c")
				Error := "Problematic Delimiter Assignment [6]: The d option was specified with ASCII character number " Asc(d) " as a delimiter, but this character exists in the given string.`nIf you want to avoid this error, use the r option instead."
			Else
				Delimiter := d
		} Else If (d <> "CSV")
			Loop
				If !InStr(String, Chr(A_Index)) {
					Delimiter := Chr(A_Index)
					Break
				} Else If (A_Index = 255)
					Error := "No Available Delimiter [7]: The d option failed to find a unique delimiter for the string because the string contains all 255 ASCII characters."
	If !Error
		If m and InStr(m, ":") and !($ := "") {
			Loop, Parse, m, `n
				If !Error
					Loop, Parse, A_LoopField, :
						If (A_Index = 1) {
							If (A_LoopField <> "") {
								If (@ := RegExMatch(A_LoopField, "[^\w#@$?]")) and !InStr(e, "c")
									Error := "Unsupported Multi-Match Variable Name [8]: The m option contained a colon (:), which means that multiple match outputs were desired.`nThe variable name """ A_LoopField """ contains inappropriate chraracters. Allowed are letters, numbers, #, _, @, ?, and $."
								Else {
									$ .= ":" (@ ? RegExReplace(A_LoopField, "[^\w#@$?]") : A_LoopField) ":", FoundPos := True
									Continue
								}
							} Else If InStr(e, "o")
								Error := "Blank Multi-Match Variable Name [9]: The m option contained a colon (:), which means that multiple match outputs were desired.`nOne variable name was left blank."
							Break
						} Else If (A_LoopField <> "") and (@%A_LoopField% := True) and !RegExMatch("", Needle, @) and @%A_LoopField% and !InStr(e, "c")
							Error := "Missing Multi-Match Subpattern [10]: The m option contained a colon (:), which means that multiple match outputs were desired.`n""" A_LoopField """ was indicated for a subpattern, but the needle does not contain this subpattern."
						Else
							$ .= A_LoopField
			StringTrimLeft, m, $, 1
		} Else If RegExMatch(m, "[^\w#@$?]") and (!InStr(e, "c") or ("" = m := RegExReplace(m, "[^\w#@$?]")))
			Error := "Unsupported Match Variable Name [11]: """ m """ was given as the name of the match output variable.`nThis variable name contains inappropriate chraracters. Allowed are letters, numbers, #, _, @, ?, and $."
		Else If RegExMatch(s, "[^\w#@$?]") and (!InStr(e, "c") or ("" = s := RegExReplace(m, "[^\w#@$?]")))
			Error := "Unsupported Split Variable Name [12]: """ s """ was given as the name of the split output variable.`nThis variable name contains inappropriate chraracters. Allowed are letters, numbers, #, _, @, ?, and $."
	If !Error {
		If !RegExMatch(Needle, "^(?:[ \t]*(i|m|s|x|A|D|J|U|X|P|S|`n|`r|`a)[ \t]*)+\)", @)
			Needle := "P)" Needle
		Else If !InStr(@, "P", True)
			Needle := "P" Needle
		FoundPos := 0, Output := 1, u := (SubStr(u, 1, 1) = "s") or ((u = "") and (m = "") and (s <> "")) ? True : False
		If (s <> "") or u
			LastTime = 1
		While (FoundPos := RegExMatch(String, Needle, Output, FoundPos + Output)) or LastTime-- {
			If (LastTime <> 0) and (m or !u) and (("" <> @ := SubStr(String, p = "" ? FoundPos : OutputPos%p%, p = "" ? Output : OutputLen%p%)) or !InStr(c, "m")) {
				Matches += 1
				If m
					If !InStr(m, ":")
						%m%%Matches% := @
					Else
						Loop, Parse, m, :
							If (A_Index & 1)
								$ := A_LoopField
							Else
								%$%%Matches% := (A_LoopField = "") ? SubStr(String, FoundPos, Output) : SubStr(String, OutputPos%A_LoopField%, OutputLen%A_LoopField%)
				If !u
					If (r <> "")
						StringToReturn .= r @
					Else If (d = "CSV")
						StringToReturn .= "," CSV(@)
					Else If (d <> "")
						StringToReturn .= Delimiter @
			}
			If s or u {
				@ := LastTime ? SubStr(String, LastFound, ((p = "") or i ? FoundPos : OutputPos%p%) - LastFound) : SubStr(String, LastFound)
				If (t <> "")
					@ := RegExReplace(@, "^" ((A_Index > 1) or x ? t : "") "([\s\S]*?)" (LastTime or x ? t : "") "$", "$1") 
				If (@ <> "") or !InStr(c, "s") {
					Splits += 1
					If s
						%s%%Splits% := @
					If u
						If (r <> "")
							StringToReturn .= r @
						Else If (d = "CSV")
							StringToReturn .= "," CSV(@)
						Else If (d <> "")
							StringToReturn .= Delimiter @
				}
				If (LastTime = 0)
					Break
				LastFound := (p = "") or i ? FoundPos + Output : OutputPos%p% + OutputLen%p%
			}
			If !Output
				If (FoundPos >= StrLen(String))
					Break
				Else
					Output := 1
			If (A_Index > StrLen(String)) {
				Error := "Infinite Loop! [13]: The needle is: """ Needle """`nSomehow this needle has caused an infinite recursion in the function!`nPlease select ""YES"" below to let me know of this error in the forums."
				Break
			}
		}
	}
	If !Error {
		If m
			If !InStr(m, ":")
				%m%0 := Matches
			Else
				Loop, Parse, m, :
					If (A_Index & 1)
						%A_LoopField%0 := Matches	
		If s
			%s%0 := Splits
		If (d <> "")
			StringTrimLeft, String, StringToReturn, 1
		If InStr(e, "e")
			ErrorLevel := False
		Return (r <> "") ? SubStr(StringToReturn, StrLen(r) + 1) : (d <> "") and (StrLen(d) <> 1) and (d <> "CSV") ? Delimiter : u ? Splits : Matches
	}
	If InStr(e, "a") {
		MsgBox, 262164, % A_ScriptName " - " A_ThisFunc "(): " SubStr(Error, 1, InStr(Error, ":") - 1), % SubStr(Error, InStr(Error, ":") + 2) "`n`nView documentation online?"
		IfMsgBox YES
			Run, %Documentation%, , UseErrorLevel
		If ErrorLevel
			MsgBox, 262144, %A_ScriptName% - %A_ThisFunc%: Alert, % "Your web browser was unable to open the AutoHotkey forums. The url`n`n" (Clipboard := Documentation) "`n`nhas been copied to your clipboard."
	}
	If InStr(e, "e")
		ErrorLevel := SubStr(Error, 1, InStr(Error, ":") - 1)
	If InStr(e, "p")
		Pause, On
	If InStr(e, "x")
		Exit
}

CSV(Text)
{
	If (SubStr(Text, 1, 1) = """") or InStr(Text, ",") or InStr(Text, "`n") or InStr(Text, "`r") {
		StringReplace, Text, Text, ", "", All
		Text := """" Text """"
	}
	Return Text
}