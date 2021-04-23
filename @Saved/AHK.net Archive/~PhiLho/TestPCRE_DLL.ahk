#SingleInstance Force
#NoEnv

#Include PCRE_DLL.ahk

Gosub BaseTest
;~ Gosub TestReplacingSyntax
;~ Gosub TestReplacing1
;~ Gosub TestReplacing2
;~ Gosub TestReplacing3

Gosub GetIP

;===== End of all tests

PCRE_End()
ExitApp

Escape::ExitApp

;===== Base test framework, also example of use for the library.

BaseTest:

stringToSearch = You can do /Regular Expressions/ in AutoHotkey too!

; Compile regular expression and get a reference to the result

; With error
hRE := PCRE_RegisterRegExp("R(A|H)(u|o)**")
if (hRE = 0)
	PCRE_ShowLastError()

; Without error
hRE := PCRE_RegisterRegExp("R.*(A|H)(u|o)")

; Get the position of a match on the given string.
pos := PCRE_GetMatch(hRE, stringToSearch)
res := PCRE_GetMatch(hRE, stringToSearch, 1, #PCRE_GETLENGTH)
match := PCRE_GetMatch(hRE, stringToSearch, 1, #PCRE_GETSTRING)

MsgBox,
(
hRE: %hRE% (%ErrorLevel%)
Pos: %pos%
Pos&Len: %res%
Match: %match%
)

; Get matches of this RE on the given string, as a reference for use in further calls
hMatch := PCRE_Match(hRE, stringToSearch)
n := PCRE_GetMatchedCaptureNumber(hMatch) ; How many captures we got

; Get position and length of matches
PCRE_GetMatchVals(hMatch, 0, pos0, len0) ; Whole match
PCRE_GetMatchVals(hMatch, 1, pos1, len1) ; First capture
PCRE_GetMatchVals(hMatch, 2, pos2, len2) ; Second capture

MsgBox,
(
hMatch: %hMatch% (%ErrorLevel%)
n: %n%
0: %pos0% %len0%
1: %pos1% %len1%
2: %pos2% %len2%
)

; Get strings of matches
s0 := PCRE_GetMatchStr(hMatch, 0) ; Whole match
s1 := PCRE_GetMatchStr(hMatch, 1) ; First capture
s2 := PCRE_GetMatchStr(hMatch, 2) ; Second capture

MsgBox,
(
hMatch: %hMatch% (%ErrorLevel%)
n: %n%
0: %s0%
1: %s1%
2: %s2%
)

; Non matching
hMatch := PCRE_Match(hRE, "This will not match!")
n := PCRE_GetMatchedCaptureNumber(hMatch) ; How many captures we got
MsgBox,
(
hMatch: %hMatch% (%ErrorLevel%)
n: %n%
)

; Several matches
hRE := PCRE_RegisterRegExp("([A-Z][a-z])")
hMatch := PCRE_Match(hRE, stringToSearch, 2)
s1 := PCRE_GetMatchStr(hMatch, 0)

; Find next match and update the reference
PCRE_MatchNext(hRE, hMatch)
s2 := PCRE_GetMatchStr(hMatch, 0)

PCRE_MatchNext(hRE, hMatch)
s3 := PCRE_GetMatchStr(hMatch, 0)

PCRE_MatchNext(hRE, hMatch)
s4 := PCRE_GetMatchStr(hMatch, 0)

PCRE_MatchNext(hRE, hMatch)
; No match, ErrorLevel = -1
s5 := PCRE_GetMatchStr(hMatch, 0)

MsgBox,
(
hRE: %hRE%, hMatch: %hMatch% (%ErrorLevel%)
1: %s1%
2: %s2%
3: %s3%
4: %s4%
5: %s5%
)

; Note that PCRE_MatchNext(hRE, hMatch) is similar to:
; hMatch := PCRE_Match(hRE, stringToSearch, pos0 + len0)
; but the later is less efficient, creating another reference.

; No capture except the default one (whole match)
hRE := PCRE_RegisterRegExp("[A-Z][a-z]")
hMatch := PCRE_Match(hRE, stringToSearch, 2)
n := PCRE_GetMatchedCaptureNumber(hMatch) ; How many captures we got
s0 := PCRE_GetMatchStr(hMatch, 0) ; Whole match

MsgBox,
(
hMatch: %hMatch% (%ErrorLevel%)
n: %n%
0: %s0%
)

Return


;===== Replacing

TestReplacing1:

stringToSearch = You can do /Regular Expressions/ in AutoHotkey too!

hRE1 := PCRE_RegisterRegExp("[A-Z][a-z]")
hRE2 := PCRE_RegisterRegExp(".")
hRE3 := PCRE_RegisterRegExp("\w+")

hRepl := PCRE_RegisterReplaceString("<Plain Replacement>")

r := PCRE_Replace(hRE1, hRepl, stringToSearch, 1)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch, 2)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch)

MsgBox Plain replacement 1:`n%r%

hRepl := PCRE_RegisterReplaceString(".")
r := PCRE_Replace(hRE2, hRepl, stringToSearch)

MsgBox Plain replacement 2:`n%r%
If (StrLen(r) != StrLen(stringToSearch))
	MsgBox BUG!

hRepl := PCRE_RegisterReplaceString("word")
r := PCRE_Replace(hRE3, hRepl, stringToSearch)

MsgBox Plain replacement 3:`n%r%


hRepl := PCRE_RegisterReplaceString("<$0>")

r := PCRE_Replace(hRE1, hRepl, stringToSearch, 1)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch, 2)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch)

MsgBox Simple replacement 1:`n%r%

hRepl := PCRE_RegisterReplaceString(".:$0!?")
r := PCRE_Replace(hRE2, hRepl, stringToSearch)

MsgBox Simple replacement 2:`n%r%

hRepl := PCRE_RegisterReplaceString("~w=$0=w~")
r := PCRE_Replace(hRE3, hRepl, stringToSearch)

MsgBox Simple replacement 3:`n%r%

Return


TestReplacing2:

stringToSearch = You can do /Regular Expressions/ in AutoHotkey too!

hRE1 := PCRE_RegisterRegExp("([A-Z])([a-z])")
hRE2 := PCRE_RegisterRegExp("(.)(.)(.)")
hRE3 := PCRE_RegisterRegExp("([aeiouy])")

hRepl := PCRE_RegisterReplaceString("_$2-$1_")

r := PCRE_Replace(hRE1, hRepl, stringToSearch, 1)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch, 2)
r := r . "`n" . PCRE_Replace(hRE1, hRepl, stringToSearch)

MsgBox Replacement 1:`n%r%

hRepl := PCRE_RegisterReplaceString("$3$1$2")
r := PCRE_Replace(hRE2, hRepl, stringToSearch)

MsgBox Replacement 2:`n%r%

hRepl := PCRE_RegisterReplaceString("$1-$1")
r := PCRE_Replace(hRE3, hRepl, stringToSearch)

MsgBox Replacement 3:`n%r%


stringToSearch = a b c	456	11	78/Abc-9
hRE := PCRE_RegisterRegExp("(.*?)\t(\d{3})\t(\d{2})\t(\d{2}/\w{3}-\d)")
hRepl := PCRE_RegisterReplaceStringEx("${4},${3},${2},${1}")
r := PCRE_Replace(hRE, hRepl, stringToSearch)

MsgBox Replacement 4:`n%r%

stringToSearch = Everybody has something to hide except me and my monkey
hRE := PCRE_RegisterRegExp("(\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+)")
hRepl := PCRE_RegisterReplaceString("1:$1_2:$2_3:$3_4:$4_5:$5_6:$6_7:$7_8:$8_9:$9")
r := PCRE_Replace(hRE, hRepl, stringToSearch)

MsgBox Replacement 5:`n%r%

Return


TestReplacing3:

; NP	Forum	Topics	Posts	Last Post
stringToSearch =
(
New posts	Ask for Help | Ask questions and (hopefully) get answers. Post helpful tips and tricks.	6659	39225	2006-06-21 16:20 / Chris
No new posts	Scripts & Functions | Share your favorite scripts, functions, and AutoHotkey-specific software.	955	8764	2006-06-21 15:08 / Goyyah
No new posts	Bug Reports | Found a problem? Please post it here.	556	2937	2006-06-21 16:18 / PhiLho
No new posts	Wish List | Request changes and new features.	731	5112	2006-06-21 17:11 / sunshine
No new posts	Announcements | Info about new releases, etc.	66	866	2006-06-21 14:38 / Chris
No new posts	Utilities & Resources | Discuss and recommend command-line utilities, helper apps, Internet resources, etc.	368	1789	2006-06-21 16:42 / BoBo
No new posts	General Chat | Talk about anything.	433	3311	2006-06-21 10:47 / majkinetor
)

parseRE = (.*?)\t(.*?) \| (.*?)\t(\d+)\t(\d+)\t(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}) / (.*)
replace1 = $2 ($3) has $4 topics cumulating $5 posts. Last post is by $8, posted on $6 at $7.
replace2 = ${2} (${3}) has ${4} topics cumulating ${5} posts. Last post is by ${8}, posted on ${6} at ${7}.

hRE := PCRE_RegisterRegExp(parseRE)
hRepl1 := PCRE_RegisterReplaceString(replace1)
hRepl2 := PCRE_RegisterReplaceStringEx(replace2)
r := PCRE_Replace(hRE, hRepl1, stringToSearch)

MsgBox %r%

Return

GetIP:

ipAndTrash =
(
1st address is 192.168.1.1
2nd: 127.0.0.1!
Last: 209.59.172.74 (current autohotkey.com... at 2006.07.11)
)

hRE := PCRE_RegisterRegExp("(?:\d{1,3}\.){3}\d{1,3}")
hMatch := PCRE_Match(hRE, ipAndTrash)
If (ErrorLevel != 0)
{
	MsgBox No IP found!
	ExitApp
}
Loop
{
	ip := PCRE_GetMatchStr(hMatch, 0)
	ips = %ips%`n%ip%
	; Find next match and update the reference
	r := PCRE_MatchNext(hRE, hMatch)
	If (r = 0)
		Break
}
MsgBox %ips%

Return


;===== Replacing Syntax

/*
Note: PCRE provides only functions to find/match strings, it provides nothing to replace strings.
So I have to code myself this functionnality, choosing my own syntax.

Perl has variable substitution in strings, like %var% in AHK,
ie. in "A $var B", $var will be replaced by the value of this variable.
In Perl, in the replace section of regular expressions, $nn (where nn is an integer) variables
are set to the corresponding capture, ie. $1 contains the first capture, etc.
Java, JavaScript and some other languages followed this syntax.
Some Unix tools like sed, and Posix REs use \0 to \9. So does Python.

Problem: Perl allows more than 9 captures, so $12 can be either $1 followed by a 2,
or the twelfth capture.
Perl resolves that by using ${1}2, which is still a regular variable substitution syntax.
Java solves this by using $1\2 because, like in Perl, backslash is the escape sequence
in the replace expression. So \$ is also a literal $.
Neither syntax seem to be available in JavaScript, and I see no way to resolve this.
In JavaScript, we must write $$ for a literal $.

\0 or $0 is the (implicit) capture of the whole match, except in JS were it has no meaning.
If there are less than n found matches (but enough captures), $n always resolve to an empty string.
If there are less than n captures, Java raises an error, Perl puts an empty string,
JavaScript leaves the $n as is.

http://www.koralsoft.com/regextester/
http://www.fileformat.info/tool/regex.htm

So, it seems that there no universal rule for regexp replacements.
I can safely make my own... ;-)
I started with simplified syntax, then I found out that I could easily (more or less...) make
it more flexible.
For those familiar with the popular Perl syntax, I finally chose to set it as default.
To simplify the algorithm (easier to maintain, faster), I chose to support either
the $0 ... $9 syntax, OR the ${0} ... ${65535} syntax, but not both in the same replace string.
The first one, with $$ to mark a plain $, is faster to type and probably enough in 99% of cases.
The second one, with ${} to mark a plain ${, as no practical limits!

Rule: $d and ${n} where d is any digit (0 to 9) and n is any number (less than 65536...)
is mapped to the capture # d or n.
$$ is always mapped to $ and ${} is always mapped to ${,
so "$$1" is just a plain "$1" and "${}1}" is plain "${1}".
Note that "a$ 1", "a$b", "${1a}" or "3 ${ 5" are OK (left untouched).

If there are less than d or n found matches (captures), $d and $ {n}
always resolve to an empty string.

A replace string is precompiled as it can be used often.

The first form is precompiled with:
PCRE_RegisterReplaceString(replaceString, replaceSymbol)
where replaceSymbol can be omitted (defaults to $).
You can use a symbol with several chars:
PCRE_RegisterReplaceString("\_2 = \_1", "\_")
Here, "\_\_" will become a plain "\_".

The second form is precompiled with:
PCRE_RegisterReplaceStringEx(replaceString, replaceSymbolStart, replaceSymbolEnd)
with defaults to ${ and }
Again, several chars can be used:
PCRE_RegisterReplaceStringEx("[[#2]] = [[#1]]", "[[#", "]]")
Here, " [[#]]" will become a plain " [[#".

*/

TestReplacingSyntax:

PCRE_TestReplaces("abc", "abc")
PCRE_TestReplaces("abc@1efg", "abc«1»efg")
PCRE_TestReplaces("abc@@1efg", "abc@1efg")
PCRE_TestReplaces("abc@2@1efg", "abc«2»«1»efg")
PCRE_TestReplaces("abc@2@15efg", "abc«2»«1»5efg")
PCRE_TestReplaces("abc@2@@15efg", "abc«2»@15efg")
PCRE_TestReplaces("abc@1", "abc«1»")
PCRE_TestReplaces("abc@", "abc@")	;
PCRE_TestReplaces("abc@ ", "abc@ ")
PCRE_TestReplaces("@1abc", "«1»abc")
PCRE_TestReplaces("@abc", "@abc")	;
PCRE_TestReplaces("@ abc", "@ abc")
PCRE_TestReplaces("@1abc@", "«1»abc@")	;
PCRE_TestReplaces("@abc@ ", "@abc@ ")	;
PCRE_TestReplaces("@ abc@1", "@ abc«1»")

PCRE_TestReplacesEx("abc", "abc")
PCRE_TestReplacesEx("abc@1~efg", "abc«1»efg")
PCRE_TestReplacesEx("abc@@1~efg", "abc@«1»efg")
PCRE_TestReplacesEx("abc@2@1~efg", "abc@2«1»efg")
PCRE_TestReplacesEx("abc@2x@1~efg", "abc@2x«1»efg")
PCRE_TestReplacesEx("abc@2x~@1~efg", "abc@2x~«1»efg")
PCRE_TestReplacesEx("abc@2~@15efg", "abc«2»@15efg")
PCRE_TestReplacesEx("abc@2~@1~5efg", "abc«2»«1»5efg")
PCRE_TestReplacesEx("abc@2~xyz@15efg", "abc«2»xyz@15efg")
PCRE_TestReplacesEx("abc@1~", "abc«1»")
PCRE_TestReplacesEx("abc@~", "abc@")	;
PCRE_TestReplacesEx("abc@ ~", "abc@ ~")
PCRE_TestReplacesEx("@1~abc", "«1»abc")
PCRE_TestReplacesEx("@~abc", "@abc")	;
PCRE_TestReplacesEx("@ ~abc", "@ ~abc")
PCRE_TestReplacesEx("@1~abc@~", "«1»abc@")	;
PCRE_TestReplacesEx("@~abc@ ~", "@abc@ ~")	;
PCRE_TestReplacesEx("@ ~abc@1~", "@ ~abc«1»")
PCRE_TestReplacesEx("abc@65535~efg@44~@ ~hij", "abc«65535»efg«44»@ ~hij")
PCRE_TestReplacesEx("abc@65535~@1~efg@44~@~5~hij", "abc«65535»«1»efg«44»@5~hij")	;
PCRE_TestReplacesEx("abc@65536~efg@4a4~@ ~hij", "abc@65536~efg@4a4~@ ~hij")
MsgBox End of tests, everything is OK if you had no message box before this one...

Return


;===== Helper functions

PCRE_TestReplaces(_replaceString, _resultString)
{
	;Default
	PCRE_TestReplace(_replaceString, _resultString)
	; Simple
	PCRE_TestReplace(_replaceString, _resultString, "^")
	PCRE_TestReplace(_replaceString, _resultString, "?")
	; Creative
	PCRE_TestReplace(_replaceString, _resultString, "\_")
	PCRE_TestReplace(_replaceString, _resultString, "~=>")
	; Tricky
	PCRE_TestReplace(_replaceString, _resultString, "\\\")
	PCRE_TestReplace(_replaceString, _resultString, "...")
	; High-Ascii
	PCRE_TestReplace(_replaceString, _resultString, "²")
	PCRE_TestReplace(_replaceString, _resultString, "µ")
	; Silly
	PCRE_TestReplace(_replaceString, _resultString, "|Capture#")
}

PCRE_TestReplacesEx(_replaceString, _resultString)
{
	;Default
	PCRE_TestReplace(_replaceString, _resultString, "Ex")
	; Simple
	PCRE_TestReplace(_replaceString, _resultString, "^", "~")
	; Creative
	PCRE_TestReplace(_replaceString, _resultString, "-=(", ")=-")
	PCRE_TestReplace(_replaceString, _resultString, "?!/", "\!?")
	; Tricky
	PCRE_TestReplace(_replaceString, _resultString, "\\\", "///")
	; High-Ascii
	PCRE_TestReplace(_replaceString, _resultString, "Š", "Ê")
	; Silly
	PCRE_TestReplace(_replaceString, _resultString, "|Capture#", "-=#=-")
}

PCRE_TestReplace(_rs, _result, _s="", _e="")
{
	local rs, er, n, rr, rr_

;~ 	OutputDebug %_s% %_e% - %_rs% // %_result%
	If (_e = "")
	{
		If (_s = "" or _s = "Ex")
		{
			; Test default
			If (_s = "Ex")
			{
				StringReplace rs, _rs, @, ${, A
				StringReplace rs, rs, ~, }, A
				n := PCRE_RegisterReplaceStringEx(rs)
				StringReplace er, _result, @, ${, A
				StringReplace er, er, ~, }, A
			}
			Else
			{
				StringReplace rs, _rs, @, $, A
				n := PCRE_RegisterReplaceString(rs)
				StringReplace er, _result, @, $, A
			}
		}
		Else
		{
			StringReplace rs, _rs, @, %_s%, A
			n := PCRE_RegisterReplaceString(rs, _s)
			StringReplace er, _result, @, %_s%, A
		}
	}
	Else
	{
		StringReplace rs, _rs, @, %_s%, A
		StringReplace rs, rs, ~, %_e%, A
		n := PCRE_RegisterReplaceStringEx(rs, _s, _e)
		StringReplace er, _result, @, %_s%, A
		StringReplace er, er, ~, %_e%, A
	}
	rr := PCRE_RebuildReplace(n)
	If (rr != er)
		MsgBox,
(
[%n%]
replStr: %_rs% with "%_s%" and "%_e%", expected result: %_result%
Post-processing: %rs% expecting %er%
Result: %rr%
)
}

PCRE_RebuildReplace(_replRef)
{
	local refNb, varREf, repl

	refNb := #PCREParsedReplace#%_replRef%_refNb
	If (refNb = 0)
	{
		repl := #PCREParsedReplace#%_replRef%_string1
;~ 		OutputDebug %_replRef% - Plain string: %repl%
		Return repl
	}
	Loop %refNb%
	{
		varRef := #PCREParsedReplace#%_replRef%_ref%A_Index%
		repl := repl #PCREParsedReplace#%_replRef%_string%A_Index% "«" varRef "»"
	}
	refNb++
	repl := repl #PCREParsedReplace#%_replRef%_string%refNb%

	Return repl
}
