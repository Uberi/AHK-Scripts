/*
 AutoHotkey Expression Examples: "" %% () And All That.   Version 1.19  06/01/2009
 because I can never get them right, so I made this.
 Some working examples to learn from.
 (Originally this was just going to be about IF statements, then it just started growing...)

 NOTE: ALL VARIABLES ARE STORED AS CHARACTER STRINGS !!!
       Strings containing numbers are converted to numbers when needed,
       and the result is converted back to a string.

 CONTENTS:

   A: PASSING COMMAND LINE PARAMETERS TO A SCRIPT
   B: COMMON THINGS AT THE BEGINNING OF AUTOHOTKEY SCRIPTS
   C: WHEN TO USE %% AROUND VARIABLES x,%x%,(%x%)
   D: ERASE A VARIABLE
   E: SET A VARIABLE (:=)  [store numbers, quoted strings]
   F: SET A VARIABLE (=)   [assign unquoted literal strings]
   G: COPY A VARIABLE
   H: IF STATEMENTS with ()
      H2: Comparing Numeric Values vs. Comparing Strings
   I: IF STATEMENTS without ()  [Translate the 1st, take the 2nd literally]
      I2: Comparing Numeric Values vs. Comparing Strings
   J: CHECK FOR A BLANK VARIABLE
   K: STRING MANIPULATION
      K1: Trim whitespace at the start of the string:
      K2: Trim whitespace at the end of the string:
      K3: Trim whitespace at the start and the end of the string:
      K4: Concatenate two strings together
      K5: Two ways of using MsgBox
   L: NUMBERS
      L1: Adding numbers together
      L2: Adding two strings together:
            when both can be interpreted as integers, gives the resulting integer (as a string)
            when both can be interpreted as float, gives the resulting float (as a string)
            when one or both can NOT be interpreted as a number, result is an empty string
      L3: Remove leading and trailing blanks and leading zeros from a number
      L4: Various ways to pad a number with leading zeros or spaces
   M: FILE NAMES
   N: REGULAR EXPRESSIONS
	  N1: Links to: Cheat Sheets, documentation, programs, libraries
	  N2: Examples
	  N3: RegExReplace
          N3.1: Examples
          N3.2: Extract Month, Day, Year, from 1/22/2009
          N3.3: An example of how we can step by step build up our Regular Expression
          N3.4: Find the $ dollar sign. Extract price and add a dollar sign.
   O: MISC AUTOHOTKEY NOTES, DEBUGGING TIPS
      O1: Notes
      O2: Sending debug data to a log file
      O3: Capturing a screen image during run
   P: MISC AUTOHOTKEY SCRIPTS
 P1: Misc AutoHotkey Scripts
 P2: Index of notable scripts found in the AutoHotkey Forum
 P3: AHK Functions - ƒ()
 P4: Library for Text File Manipulation
 P5: Tray Icons
 P6: Force Exit another AutoHotkey script

   Q: NAVIGATING WEB SITES
      Q1: Determining when a webpage has finished loading
      Q2: Positioning on a control
      Q3: Search for a certain colored pixel
   R: NEWBIE RECOMMENDED LEARNING SEQUENCE
   S: Press ESC to cancel this scipt


 Note: Closing */ must be first thing on line. Otherwise you'll be asking yourself,
       "Why does my script stop running at this point, as if the whole rest of
        the script was commented out?"
*/


A:
/******************************************************************************
  PASSING COMMAND LINE PARAMETERS TO A SCRIPT
*/
NumParams = %0%
Param1 = %1%
Param2 = %2%
Param3 = %3%
MsgBox NumParams = %0%
MsgBox Param1 = %1%
MsgBox Param2 = %2%
MsgBox Param3 = %3%


B:
/******************************************************************************
  COMMON THINGS OFTEN FOUND AT THE BEGINNING OF AUTOHOTKEY SCRIPTS
*/
#NoTrayIcon              ;if you don't want a tray icon for this AutoHotkey program
#NoEnv                   ;Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force    ;Skips the dialog box and replaces the old instance automatically
;;SendMode Input           ;I discovered this causes MouseMove to jump as if Speed was 0. (was Recommended for new scripts due to its superior speed and reliability.)
SetKeyDelay, 90          ;Any number you want (milliseconds)
CoordMode,Mouse,Screen   ;Initial state is Relative
CoordMode,Pixel,Screen   ;Initial state is Relative. Frustration awaits if you set Mouse to Screen and then use GetPixelColor because you forgot this line. There are separate ones for: Mouse, Pixel, ToolTip, Menu, Caret
MouseGetPos, xpos, ypos  ;Save initial position of mouse (note: no %% because it's writing to xpos, ypos)
WinGet, SavedWinId, ID, A     ;Save our current active window

;Set Up a Log File:
SetWorkingDir, %A_ScriptDir%  ;Set default directory to where this script file is located. (Note %% because it's expecting and unquoted string)
LogFile := "MyLog.txt"
FileAppend, This is a message`n, %LogFile%  ;Note the trailing (`n) to start a new line. This could instead be a leading (`n) if you want. (Note %% because it's expecting and unquoted string)

;and things at the end where we restore window and mouse cursor position

WinActivate ahk_id %SavedWinId%  ;Restore original window
MouseMove, xpos, ypos, 10        ;Restore original mouse position



MsgBox Press Esc to abort this script


C:
/******************************************************************************
WHEN TO USE %% AROUND VARIABLES
*******************************************************************************

LESSON #1 on %%:
The only place to use %x% is where a literal string NOT enclosed in
double-quotes is expected. Otherwise, don't use %% around a variable name.
*/
;Notice in the following examples that unquoted literal strings are expected.
; = assigns unquoted literal strings
n = Ishmael
x = Call me %n%
MsgBox Call me %n%

;Example
x = 500
y = 500
z = 10
MouseMove, 500, 500, 10           ;works
MouseMove, 500 - 1, 500 + 1, 10   ;works
MouseMove,  x, y, z               ;works
MouseMove,  x - 1, y + 1, z + 2   ;works

;However, this doesn't work, because MouseMove
;doesn't expect an unquoted literal string
MouseMove, %x% - 1, %y% + 1, 10   ;doesn't work


;CONFUSION IS CAUSED BECAUSE THE FOLLOWING HAPPENS TO ALSO WORK
MouseMove, %x%, %y%, %c%          ;works

;The above works because "for backward compatibility, command parameters
;    that are documented as "can be an expression" treat an isolated name
;    in percent signs (e.g. %Var%, but not Array%i%) as though the percent
;    signs are absent."
;        --AutoHotkey Documentation: Variables and Expressions

/******************************************************************************
LESSON #2 on %%:
Use (%x%) when x contains the name of a 2nd variable which in
turn contains the contents you want.
*/
a = 500    ;a = "500"
b = 200    ;b = "200"
x := "a"
y := "b"
MouseMove, (%x%), (%y%)            ;x = a, a = 500.  y = b, b = 200
MouseGetPos, xpos, ypos
MsgBox xpos=%xpos%  ypos=%ypos%    ;xpos=500  ypos=200

/******************************************************************************
LESSON #3 on %%:
Instances which look like exceptions to the rule:
*/
MyDocument := "C:\Program Files\AutoHotkey\license.txt"
Run, notepad.exe "%MyDocument%"
; Looks like we're using %% inside a quoted string,
; but actually the "" are not required, just recommended.
; This happens to also work:
Run, notepad.exe %MyDocument%
; The run function expects an unquoted string, so we use %%,
; otherwise notepad would try to open a file named 'MyDocument'.

; In the first case above, the run function is actually accepting an unquoted
; string which happens to begin and end with a double quote character.
/* Tech Note:
    I believe the 'Target' string in the AutoHotkey Run command is passed as the
    'command_line' parameter to the Windows CreateProcess() function. I see in AutoHotkey
    source file script.cpp routine Script::ActionExec the call to CreateProcess is:

       if (CreateProcess(NULL, command_line, NULL, NULL, FALSE, 0, NULL, aWorkingDir, &si, &pi))

    Doc for CreateProcess says, "If you are using a long file name that contains a space,
    use quoted strings to indicate where the file name ends and the arguments begin."

    So the beginning and ending double quote characters are actually a part of the string being passed.

(05/29/2009 - I'm testing how AutoHotkey parses the Run command. I'll post the results when I'm done.)

    CreateProcess() : http://msdn.microsoft.com/en-us/library/ms682425(VS.85).aspx
*/

D:
/******************************************************************************
 ERASE A VARIABLE
*/
v =
v := ""

E:
/******************************************************************************
 SET A VARIABLE (:=)
 colon-equal operator (:=) to store numbers and quoted strings
*/
ABC := "David"
David := "Susan"

v := "ABC"                      ; v = "ABC"
MsgBox v := "ABC"`n`nv = "%v%"

v := ABC                        ; ABC is a variable. v = "David"
MsgBox v := ABC`n`nv = "%v%"

v := %ABC%                      ; ABC is a variable containing the name of a variable. v = "Susan"
MsgBox v := `%ABC`%`n`nv="%v%"  ; NOTE: If ABC is undefined or blank, program halts!

v := "123"                      ; v = "123" (quotes NOT included)
MsgBox v := "123"`n`nv = "%v%"

v := 123                        ; v = "123" (If it can be interpreted as a number then it's a number, otherwise it's a variable name.)
MsgBox v := 123`n`nv = "%v%"

;123 can be made into a variable, as in this horrendous example:
;  123 := 456
;  MsgBox v = %123%  ; message is "v = 456"


F:
/******************************************************************************
 SET A VARIABLE (=)
 equal sign operator (=) to assign unquoted literal strings
 To include variable ABC instead of literal string "ABC", use %ABC%
*/
ABC = David
David = Susan

v =  123                        ;v = "123"
MsgBox v = 123`n`nv = "%v%"

v = 0001                        ;v = "0001"
MsgBox v = 0001`n`nv = "%v%"

v = ABC                         ;v = "ABC"
MsgBox v = ABC`n`nv = "%v%"

v = %ABC%                       ;ABC is a variable. v = "David"
MsgBox v = `%ABC`%`n`nv = "%v%" (ABC = "David")

;PROBABLY NOT WHAT YOU WANTED:
v = "ABC"                       ;v = the literal string "ABC" (including double-quotes)
MsgBox v = "ABC"`n`nv = '%v%'


G:
/******************************************************************************
 COPY A VARIABLE
*/
ABC := "David"
David := "Susan"

v := ABC                        ; ABC is a variable. v = "David"
MsgBox v := ABC`n`nv = "%v%"
v = %ABC%                       ; ABC is a variable. v = "David"
MsgBox v = `%ABC`%`n`nv = "%v%"

;PROBABLY NOT WHAT YOU WANTED:
v = ABC                         ;v = "ABC" (the literal string)
MsgBox v = ABC`n`nv = "%v%"
v := %ABC%                      ; ABC is a variable containing the name of a variable. v = "Susan"
MsgBox v := `%ABC`%`n`nv="%v%"  ; NOTE: If ABC is undefined, PROGRAM HALTS! (If David is undefined, v = "")


H:
/******************************************************************************
   IF STATEMENTS with ()
*/
H1:
SAT := "Saturday"          ;Another way to view this is:
Saturday := "Saturn"       ;  SAT --> Saturday --> Saturn
MON := "Monday"            ;  MON --> Monday --> Moon
Monday := "Moon"

MsgBox SAT := "Saturday"`nSaturday := "Saturn"`nMON := "Monday"`nMonday := "Moon"`n`n(another way to view this:)`nSAT --> Saturday --> Saturn`nMON --> Monday --> Moon`n`n#16

; =
If ("Saturday" = "Saturday")
  MsgBox ("Saturday" = "Saturday")
If ("Saturday" = "SATURDAY")
  MsgBox ("Saturday" = "SATURDAY")

; ==  (case sensitive compare)
If ("Saturday" == "Saturday")              ;== Case Sensitive
  MsgBox ("Saturday" == "Saturday")
If ("Saturday" == "SATURDAY")              ;== Case Sensitive
  MsgBox NO

;SAT = "Saturday"
If (SAT = "Saturday")       ;SAT = "Saturday", compare with "Saturday"
  MsgBox (SAT = "Saturday")
If ("Saturday" = SAT)       ;Reverse works the same
  MsgBox ("Saturday" = SAT)
If (SAT = "xxxxx")
  MsgBox NO
If ("xxxxx" = SAT)
  MsgBox NO

;%SAT% = "Saturn"
If ("Saturn" = "Saturn")
  MsgBox ("Saturn" = "Saturn")
If (%SAT% = "Saturn")  ;SAT = "Saturday", %SAT% = "Saturn", compare with "Saturn" (no problem if SAT not defined)
  MsgBox (`%SAT`% = "Saturn")`n`n(no problem if SAT not defined)
If ("Saturn" = %SAT%)  ;Reverse works the same (no problem if SAT not defined)
  MsgBox ("Saturn" = `%SAT`%)`n`n(no problem if SAT not defined)
If ("xxxxx" = %SAT%)   ;compare "xxxxx" with "Saturn"
  MsgBox NO
If (%SAT% = "xxxxx")   ;compare "Saturn" with "xxxxx"
  MsgBox NO

;"Moon" = %MON%
If ("Moon" = "Moon")
  MsgBox ("Moon" = "Moon")
If (%MON% = "Moon")    ;MON = "Monday", Monday = "Moon", compare with "Moon" (no problem if MON not defined)
  MsgBox (%MON% = "Moon")`n`nMON = "Monday", Monday = "Moon", compare with "Moon"`n`n(no problem if MON not defined)
If ("Moon" = %MON%)    ;"Moon", compare with MON = "Monday", Monday = "Moon" (no problem if MON not defined)
  MsgBox ("Moon" = `%MON`%)`n`n"Moon", compare with MON = "Monday", Monday = "Moon"`n`n(no problem if MON not defined)
If ("xxxxx" = %MON%)   ;compare "xxxxx" with "Moon"
  MsgBox NO
If (%MON% = "xxxxx")   ;compare "Moon" with "xxxxx"
  MsgBox NO

;SAT =? MON
If (SAT = MON)      ;Compare "Saturday" = "Monday" [SAT = "Saturday", MON = "Monday"]
  MsgBox NO
If (SAT < MON)      ;"Saturday" < "Moon"
  MsgBox NO
If (SAT > MON)      ;"Saturday" > "Moon"  [S > M]
  MsgBox (SAT > MON)`n`n"Saturday" > "Monday"`n`n[S > M]

;SAT =? %MON%
If (SAT = %MON%)    ;Compare "Saturday" = "Moon". [SAT = "Saturday", compare with MON = "Monday", Monday = "Moon"]
  MsgBox NO
If (SAT < %MON%)    ;"Saturday" < "Moon"
  MsgBox NO
If (SAT > %MON%)    ;"Saturday" > "Moon"  [S > M]
  MsgBox (SAT > `%MON`%)`n`n"Saturday" > "Moon"   [S > M]`n`nSAT = "%SAT%",`nMON = "%MON%", %MON% = "Moon"

;%SAT% =? MON
If (%SAT% = MON)    ;Compare "Saturn" = "Monday". [SAT = "Saturday", Saturday = "Saturn", MON = "Monday"]
  MsgBox NO
If (%SAT% < MON)    ;"Saturn" < "Monday"
  MsgBox NO
If (%SAT% > MON)    ;"Saturn" > "Monday"  [S > M]
  MsgBox (`%SAT`% > MON)`n`nSAT = "Saturday", %SAT% = "Saturn", compare with MON = "Monday"`n`n"Saturn" > "Moon"`n`n[S > M]

;%SAT% =? %MON%
If (%SAT% = %MON%)  ;Compare "Saturn" = "Moon". [SAT = "Saturday", Saturday = "Saturn", compare with MON = "Monday", Monday = "Moon"]
  MsgBox NO
If (%SAT% < %MON%)  ;"Saturn" < "Moon"
  MsgBox NO
If (%SAT% > %MON%)  ;"Saturn" > "Moon"  [S > M]
  MsgBox (`%SAT`% > `%MON`%)`n`nSAT = "Saturday", %SAT% = "Saturn", compare with`nMON = "Monday", %MON% = "Moon"`n`n"Saturn" > "Moon"`n`n[S > M]


/******************************************************************************
 H2: COMPARING NUMERIC VALUES VS. COMPARING STRINGS     if statements with ()

If they can both be interpreted as numbers, then they are compared as numbers.
Otherwise they are compared as strings.
*/

H2:
;COMPARING NUMERIC VALUES VS. COMPARING STRINGS     if statements with ()
x = 05           ; x = "05"
if (x > 3.14)    ; (5 > 3.14) ?  Compare numeric values, since both can be interpreted as numeric values.
  MsgBox if (x > 3.14)`nwith x = "05"`n`nCompare numeric values, since both "05" and "3.14" can be interpreted as numbers.`n(5 > 3.14) ?`nyes
else
  MsgBox xxxxxx

if (x > "3.14")  ; ("05" > "3.14") ?  Compare strings, since "3.14" is explicitly a string. (The " " around 3.14 say it's a string, not a number, so do a string compare.)
  MsgBox xxxxxx
else
  MsgBox if (x > "3.14")`nwith x = "05"`n`nCompare strings, since "3.14" is explicitly a string.`nThe " " around "3.14" say it's a string, not a number, so do a string compare.`n("05" > "3.14") ?`n("0" > "3") ?`n(48 > 51) ?`nno

; ASCII table:
;   /  47
;   0  48
;   1  49
;   2  50
;   3  51
;   4  52
;   5  53
;   6  54
;   7  55
;   8  56
;   9  57
;   :  58
;DEREFERENCE TESTS
y := "x"

;Compare %y% with 3.14
x = 03             ; x = "03"
if (%y% > 3.14)    ; (3 > 3.14) ?
  MsgBox xxxxxx
else
  MsgBox if (`%y`% > 3.14)`nwith y = "x"`nand x = "03"`n`nCompare numeric values, since both "03" and "3.14" can be interpreted as numbers.`n(3 > 3.14) ?`nno

x = 05             ; x = "05"
if (%y% > 3.14)    ; (5 > 3.14) ?
  MsgBox if (`%y`% > 3.14)`nwith y = "x"`nand x = "05"`n`nCompare numeric values, since both "05" and "3.14" can be interpreted as numbers.`n(5 > 3.14) ?`nyes
else
  MsgBox NO

;Compare %y% with "3.14"
x = 03               ; x = "03"
if (%y% > "3.14")    ; ("03" > "3.14") ?
  MsgBox xxxxxx
else
  MsgBox if (`%y`% > "3.14")`nwith y = "x"`nand x = "03"`n`nCompare strings, since "3.14" is explicitly a string.`nThe " " around "3.14" say it's a string, not a number, so do a string compare.`n("03" > "3.14") ?`n("0" > "3") ?`n(48 > 51) ?`nno

x = 05               ; x = "05"
if (%y% > "3.14")    ; ("05" > "3.14") ?
  MsgBox xxxxxx
else
  MsgBox if (`%y`% > "3.14")`nwith y = "x"`nand x = "05"`n`nCompare strings, since "3.14" is explicitly a string.`nThe " " around "3.14" say it's a string, not a number, so do a string compare.`n("05" > "3.14") ?`n("0" > "3") ?`n(48 > 51) ?`nno

x := "/"             ; x = "/"
if (%y% > "3.14")    ; ("/" > "3.14") ?
  MsgBox xxxxxx
else
  MsgBox if (`%y`% > "3.14")`nwith y = "x"`nand x = "/"`n`nCompare strings, since "3.14" is explicitly a string.`nThe " " around "3.14" say it's a string, not a number, so do a string compare.`n("/" > "3.14") ?`n("/" > "3") ?`n(47 > 51) ?`nno

x := ":"             ; x = ":"
if (%y% > "3.14")    ; (":" > "3.14") ?
  MsgBox if (`%y`% > "3.14")`nwith y = "x"`nand x = ":"`n`nCompare strings, since "3.14" is explicitly a string.`nThe " " around "3.14" say it's a string, not a number, so do a string compare.`n(":" > "3.14") ?`n(":" > "3") ?`n(58 > 51) ?`nyes
else
  MsgBox xxxxxx


I:
/******************************************************************************
   IF STATEMENTS without ().  Translate the 1st, take the 2nd literally
*/
I1:
SAT := "Saturday"          ;Another way to view this is:
Saturday := "Saturn"       ;  SAT --> Saturday --> Saturn
MON := "Monday"            ;  MON --> Monday --> Moon
Monday := "Moon"

MsgBox SAT := "Saturday"`nSaturday := "Saturn"`nMON := "Monday"`nMonday := "Moon"`n`n(another way to view this:)`nSAT --> Saturday --> Saturn`nMON --> Monday --> Moon

;SAT
;; If "Saturday" = .... illegal
If SAT = Saturday    ;SAT = "Saturday", compare with "Saturday"
  MsgBox If SAT = Saturday`n`nSaturday = Saturday
If SAT = %Saturday%  ;SAT = "Saturday", compare with %Saturday% = "Saturn"
  MsgBox NO
If SAT = SAT         ;SAT = "Saturday", compare with "SAT"
  MsgBox NO
If SAT = %SAT%       ;SAT = "Saturday", compare with %SAT% = "Saturday"
  MsgBox If SAT = `%SAT`%`n`nSaturday = Saturday

;%SAT%
;NOTE: if SAT is undefined or blank, program will halt!
If %SAT% = Saturn   ;SAT = "Saturday", Saturday = "Saturn", compare with "Saturn"
  MsgBox If `%SAT`% = Saturn`n`nSAT = "%SAT%", `%Saturday`% = %Saturday%, compare with "Saturn"`n`n(Note: if SAT is undefined or blank, program will halt!)
If %SAT% = xxxxx   ;SAT = "Saturday", Saturday = "Saturn", compare with "xxxxx"
  MsgBox NO

;Saturday
If Saturday = Saturn   ;Saturday = "Saturn", compare with "Saturn"
  MsgBox Saturday = Saturn`n`nSaturday="%Saturday%",compare with "Saturn"
If Saturday = xxxxx   ;Saturday = "Saturn", compare with "xxxxx"
  MsgBox NO

;%Saturday%
;NOTE: if SATURDAY is undefined or blank, program will halt!
If %Saturday% =       ;Saturday = "Saturn", Saturn = <nothing>, compare with <nothing>
  MsgBox If `%Saturday`% = `n`nSaturday=%Saturday%, Saturn=<nothing>, compare with <nothing>`n`n(NOTE: if SATURDAY is undefined or blank, program will halt!)
If %Saturday% = %Saturn%  ;Saturday = "Saturn", Saturn = <nothing>, compare with %Saturn% = <nothing> (<nothing> = <nothing>)
  MsgBox if `%Saturday`% = `%Saturn`%`n`nSaturday=%Saturday%, Saturn=<nothing>`ncompare with`%Saturn`% = <nothing>`n`n<nothing>=<nothing>
If %Saturday% = xxxxx ;Saturday = "Saturn", Saturn = <nothing>, compare with "xxxxx"
  MsgBox NO
If %Saturday% = ""    ;Saturday = "Saturn", Saturn = <nothing>, compare with literal two double-quotes (a string containing two characters, both double-quotes)
  MsgBox NO


/******************************************************************************
 I2: COMPARING NUMERIC VALUES VS. COMPARING STRINGS     if statements with ()

If they can both be interpreted as numbers, then they are compared as numbers.
Otherwise they are compared as strings.
*/
I2:
;COMPARING NUMERIC VALUES VS. COMPARING STRINGS     if statements without ()
; ASCII table:
;   !  33
;   "  34
;   #  35
;   0  48

x = 03            ; x = "03"
if x > 3.14       ; 3 > 3.14  (Compare numeric values, since both can be interpreted as numeric values)
  MsgBox xxxxxx
else
  MsgBox if x > 3.14`nwith x=%x%`n`nCompare numeric values, since both can be interpreted as numeric values`n3 > 3.14 ?`nno

x = 05            ; x = "05"
if x > 3.14       ; 5 > 3.14  (Compare numeric values, since both can be interpreted as numeric values)
  MsgBox if x > 3.14`nwith x=%x%`n`nCompare numeric values, since both can be interpreted as numeric values`n5 > 3.14 ?`nyes
else
  MsgBox xxxxxx

x = 03            ; x = "03"
if x > "3.14"     ; compare string '03' with string '"3.14"' (double quotes are part of the string). Compare ascii 0 in 03 with leading quotation mark in "3.14" (48 > 34 ?) Yes.
  MsgBox if x > "3.14"`nwith x=%x%`n`nDouble quotes are part of the string "3.14"`nso string compare 03 with "3.14"`ncompare leading '0' in 03 with leading quotation mark in "3.14"`nascii(0) = 48`nascii(") = 34`n48 > 34 (?)`nyes
else
  MsgBox xxxxxx

x = !             ; x = '!' (ascii 33)
if x > "3.14"     ;compare string '!' with string '"3.14"' (double quotes are part of the string). Compare ascii ! with leading quotation mark in "3.14" (48 > 34 ?) Yes.
; (! > ")?  --> (33 > 34) ? no
  MsgBox xxxxxx
else
 MsgBox if x > "3.14"`nwith x=%x%`nno`n`ncompare ascii ! with leading quotation mark in "3.14"`nascii(!) = 33`nascii(") = 34`n(33 > 34)?`nno

x = #             ; x = '#' (ascii 35)
if x > "3.14"     ; (! > ")?  --> (35 > 34) ? yes
  MsgBox if x > "3.14"`nwith x=%x%`nyes`n`ncompare ascii # with leading quotation mark in "3.14"`nascii(#) = 35`nascii(") = 34`n(35 > 34)?`nyes
else
  MsgBox xxxxxx


; ASCII table:
;   !  33
;   "  34
;   #  35
;   0  48
;DEREFERENCE TESTS
y := "x"

;compare %y% with 3.14
x = 03            ; x = "03"
if %y% > 3.14     ; 3 > 3.14 (?)
  MsgBox xxxxxx
else
  MsgBox if `%y`% > 3.14`nwith y := "x"`nand x = "03"`n`nCompare numeric values, since both "03" and "3.14" can be interpreted as numbers.`n3 > 3.14 (?)`nno

x = 05            ; x = "05"
if %y% > 3.14     ; 5 > 3.14 (?)
  MsgBox if `%y`% > 3.14`nwith y := "x"`nand x = "05"`n`nCompare numeric values, since both "05" and "3.14" can be interpreted as numbers.`n5 > 3.14 (?)`nyes
else
  MsgBox xxxxxx


;compare %y% with "3.14"
x = 03            ; x = "03"
if %y% > "3.14"   ; Double quotes are part of the string "3.14" so string compare '03' with string '"3.14"'. Compare ascii 0 in 03 with leading quotation mark in "3.14" (48 > 34 ?) Yes.
  MsgBox if `%y`% > "3.14"`nwith y := "x"`nand x=%x%`n`nDouble quotes are part of the string "3.14"`nso string compare 03 with "3.14"`ncompare leading '0' in 03 with leading quotation mark in "3.14"`nascii(0) = 48`nascii(") = 34`n48 > 34 (?)`nyes
else
  MsgBox xxxxxx

x = !             ; x = '!' (ascii 33)
if x > "3.14"     ;Double quotes are part of the string "3.14" so string compare '!' with string '"3.14"'. Compare '!' with leading quotation mark in "3.14" (48 > 34 ?) Yes.
  MsgBox xxxxxx
else
  MsgBox if `%y`% > "3.14"`nwith y := "x"`nand x=%x%`n`nDouble quotes are part of the string "3.14"`nso string compare ! with "3.14"`ncompare '!' with leading quotation mark in "3.14"`nascii(!) = 33`nascii(") = 34`n33 > 34 (?)`nno

x = #             ; x = '#' (ascii 35)
if x > "3.14"     ; (! > ")?  --> (35 > 34) ? yes
  MsgBox if `%y`% > "3.14"`nwith y := "x"`nand x=%x%`n`nDouble quotes are part of the string "3.14"`nso string compare # with "3.14"`ncompare '#' with leading quotation mark in "3.14"`nascii(#) = 35`nascii(") = 34`n35 > 34 (?)`nyes
else
  MsgBox xxxxxx



J:
/******************************************************************************
   CHECK FOR A BLANK VARIABLE (or undefined variable)
*/
v := ""

If v =
  MsgBox v = ""

If (v = "")
  MsgBox v = ""


K:
/******************************************************************************
 STRING MANIPULATION
*/
K1:
;Trim whitespace at the START of a string:
v := "     0001     "
MsgBox v="%v%"
v := RegExReplace( v, "\A\s+" )
MsgBox v="%v%"                  ;v = "0001     "

K2:
;Trim whitespace at the END of a string:
v := "     0001     "
MsgBox v="%v%"
v := RegExReplace( v, "\s+\z" )
MsgBox v="%v%"                  ;v = "     0001"

K3a:
;Trim whitespace at the START AND END of a string:
v := "     0001     "
MsgBox v="%v%"
v := RegExReplace( v, "(^\s+)|(\s+$)")
MsgBox v="%v%"                  ;v = "0001"

K3b:
;Trim whitespace at the START AND END of the string:
v := "     0001     "
MsgBox v="%v%"
v = %v%                         ;v = "0001" (AutoTrim ON by default)
MsgBox v="%v%"

K4:
;CONCATENATE TWO STRINGS TOGETHER
SAT := "Saturday"
MON := "Monday"
Saturday := "Saturn"
Monday := "Moon"

K4a: ; using =
v = %SAT%%MON%      ; v = "SaturdayMonday"
MsgBox v = "%v%"

K4b: ; using :=
v := "Saturday" . "Monday"  ; v = "SaturdayMonday"
MsgBox v = "%v%"

v := SAT . MON      ; v = "SaturdayMonday" (there must be a SPACE before and after dot)
MsgBox v = "%v%"

v := %SAT% . MON    ; v = "SaturnMonday"
MsgBox v = "%v%"

v := SAT . %MON%    ; v = "SaturdayMoon"
MsgBox v = "%v%"

v := %SAT% . %MON%  ; v = "SaturnMoon"
MsgBox v = "%v%"

K5:
;This is a good place to mention two ways of using MsgBox
Msgbox Var = %Var%
; OR
Msgbox % "Var = " . Var
;  string^^^^^^^^ | ^^^variable name
;           Concatenate

K6:
/* SEE ALSO :
     Library for Text File Manipulation
     http://www.autohotkey.net/~heresy/Functions/TXT.ahk
*/

L:
/******************************************************************************
 NUMBERS
 NOTE: All variables are stored as character strings.
 Strings are automatically converted to numbers when necessary,
 then converted back to strings when result is stored in a variable.
*/
L1:
;ADDING NUMBERS TOGETHER
v := "123"
v += 1
MsgBox v = "%v%"     ; v <- "124"

v := "123"
v := v + 1
MsgBox v = "%v%"     ; v <- "124"

; Probably not what you wanted:
v = 123            ; v <- "123" (the literal string)
v = v + 1          ; v <- "v + 1" (the literal string)
MsgBox v = "%v%"


L2:
;ADDING TWO STRINGS TOGETHER
; When both can be interpreted as integers, gives the resulting integer (as a string)
v1 := 123
v2 := 456
v := v1 + v2     ; v <- "579"
MsgBox v = "%v%"

; When one or both can be interpreted as float, gives the resulting float (as a string)
v1 := 1.23
v2 := 45.6
v := v1 + v2     ; v <- "46.830000"
MsgBox v = "%v%"

; When one or both can NOT be interpreted as a number, result is an empty string
v1 := "123"
v2 := "Susan"
v := v1 + v2     ; v <- "" (empty string)
MsgBox v = "%v%"


L3:
;REMOVE LEADING ZEROS FROM A NUMBER
v := 0001             ;v = "0001"
v += 0                ;v converted to integer, add zero, convert back to string
MsgBox v = "%v%"      ;v = "1" (the literal string "1"

;REMOVE LEADING BLANKS AND TRAILING BLANKS FROM A NUMBER
v := "     1     "
MsgBox v = "%v%"      ;v = "     1     "
v += 0                ;v converted to integer, add zero, convert back to string
MsgBox v = "%v%"      ;v = "1" (the literal string "1"

;REMOVE LEADING AND TRAILING BLANKS AND LEADING ZEROS FROM A NUMBER
v := "     0001     "
MsgBox v = "%v%"      ;v = "     0001     "
v += 0                ;v converted to integer, add zero, convert back to string
MsgBox v = "%v%"      ;v = "1" (the literal string "1"

;(yea it's all the same. Just do v += 0)


L4:
/************************************************
  VARIOUS WAYS TO PAD A NUMBER WITH LEADING ZEROS OR SPACES
  (To pad with spaces, substitute spaces for the zeros.)
*/
;PAD A NUMBER WITH LEADING ZEROS OR SPACES #1
; Using SubStr
; Documentation on SubStr: "If StartingPos is less than 1, it is
; considered to be an offset from the end of the string. For example, 0
; extracts the last character and -1 extracts the two last characters."
v := 123
            ;....v....1                   ....v....1
v := SubStr("0000000000" . v, -9)  ; v = "0000000123"
MsgBox v = "%v%"

v := SubStr("abcdefghij" . v, -9)  ; v = "defghij123"  (easier to see what's happening)
MsgBox v = "%v%"


;PAD A NUMBER WITH LEADING ZEROS OR SPACES #2
; Using StringRight
v := 123
     ;....v....1              ....v....1...
v := "0000000000" . v  ; v = "0000000000123"  ( or could use v = "0000000000"%v% )
StringRight, v, v, 10  ; v =    "0000000123"
MsgBox v = "%v%"


;PAD A NUMBER WITH LEADING ZEROS OR SPACES #3
; Using sprintf
StrIn := "1234"
size := VarSetCapacity(StrOut, 8)  ;want StrOut to hold 8 digits
DllCall("msvcrt\sprintf", Str, StrOut, Str, "%08d", "Int", StrIn )  ;pad with zeros
MsgBox, 0, Zeros, size=%size%`nStrIn = %StrIn%`nStrOut = %StrOut%   ;StrOut = "00000123"
DllCall("msvcrt\sprintf", Str, StrOut, Str,  "%8d", "Int", StrIn )  ;pad with blanks
MsgBox, 0, Spaces, size=%size%`nStrIn = %StrIn%`nStrOut = %StrOut%  ;StrOut = "     123"


;PAD A NUMBER WITH LEADING ZEROS OR SPACES #4
; Prepend leading zeros
v = 123
Loop, % 9-StrLen(v)            ; (9 for 9 digits total)
    v = 0%v%                   ; OR: v := 0 . v
MsgBox, 0, Zeros, v = "%v%"    ; v = "000000123"

; Prepend leading spaces
v = 123
Loop, % 9-StrLen(v)            ; (9 for 9 digits & spaces total)
    v := A_Space . v         ; OR: v := " " . v
MsgBox, 0, Spaces, v = "%v%"   ; v = "      123"

;PAD A NUMBER WITH LEADING ZEROS OR SPACES #5
; Using SetFormat
;(Note: Be wary of converting an integer to a float and back to an integer.
; An integer has 32 bits of data, whereas a float has only 27 bits of data.)
v = 1234
SetFormat, Float, 08.0 ; (08 for zero padded 8 digits total, .0 for zero decimal places)
v += 0.0               ; v converted to float, add zero, convert back to string
MsgBox v = %v%         ; v = '00001234'

v = 1234
SetFormat, Float, 8.0  ; (8 for space padded 8 digits & spaces total, .0 for zero decimal places)
v += 0.0               ; v converted to float, add zero, convert back to string
MsgBox v = %v%         ; v = '    1234'


M:
/******************************************************************************
 FILE NAMES
*/
;Set/Show Working Directory
SetWorkingDir,%A_ScriptDir%
MsgBox, 0, , A_WorkingDir=%A_WorkingDir%

;Creating a File  (note: directory must exist)
FileAppend, test 10, MyFile10.log           ;<WorkingDir>\MyFile10.log
FileAppend, test 11, \MyFile11.log          ;C:\MyFile11.log
FileAppend, test 12, SubDir\MyFile12.log    ;<WorkingDir>\SubDir\MyFile12.log
FileAppend, test 13, SubDir\\\\\\\\\\\\\MyFile13.log   ;<WorkingDir>\SubDir\MyFile13.log Doesn't seem to matter how many extra \
V := "C:\TEMP"
FileAppend, test 14, %V%MyFile14.log        ;C:\TEMPMyFile14.log
FileAppend, test 15, %V%\MyFile15.log       ;C:\TEMP\MyFile15.log
FileAppend, test 16, %V%\\\\\\\\\\\MyFile16.log   ;C:\TEMP\MyFile16.log  Doesn't seem to matter how many extra \
FileAppend, test 17, ..\MyFile17.log        ;Up one directory from WorkingDir. <WorkingDir-^>\MyFile17.log
MsgBox ErrorLevel=%ErrorLevel%              ;Test for error. 0=SUCCESS, 1=FAIL


N:
/******************************************************************************
 REGULAR EXPRESSIONS        (Note: AutoHotkey uses PCRE Perl-compatible format)
*/

N1:
/*
CHEAT SHEETS
  Regular Expressions (RegEx) - Quick Reference: http://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm
  Regular Expression Cheat Sheet: http://regexlib.com/CheatSheet.aspx
  One Page Reference Cheat Sheet: http://www.regular-expressions.info/reference.html
      Replacement Text Reference: http://www.regular-expressions.info/refreplace.html

HEAVY DOCUMENTATION
  Syntax of regular expressions in Perl: http://search.cpan.org/dist/perl/pod/perlre.pod
  Syntax of regular expressions in Perl: http://perldoc.perl.org/perlre.html
  Concatenation of the PCRE man pages:   http://www.pcre.org/pcre.txt
  Perl Compatible Regular Expressions:   http://en.wikipedia.org/wiki/PCRE

PROGRAMS
  RegExBuddy: http://www.regexbuddy.com ($40) Screenshot: http://www.regexbuddy.com/screen.html


LIBRARIES
  Regular Expression Library: http://regexlib.com/
    Categories:
    * Email
    * Uri
    * Numbers
    * Strings
    * Dates and Times
    * Misc
    * Address/Phone
    * Markup/Code

  http://www.regular-expressions.info/examples.html
    * Grabbing HTML Tags
    * Trimming Whitespace
    * Matching an IP address
    * Matching a Floating Point Number
    * Matching an Email Address
    * Matching Valid Dates
    * Finding or Verifying Credit Card Numbers
    * Matching Complete Lines
    * Removing Duplicate Lines or Items
    * Regex Examples for Processing Source Code
    * Two Words Near Each Other


  A Collection/Library Of Regular Expressions: http://www.autohotkey.com/forum/viewtopic.php?t=13544
    * Ensure that a path doesn't end with a backslash
    * Ensure that a path ends with a backslash
    * Replace characters illegal in a file name by something else (can be empty)
    * Keep only lines starting with a given string
    * Parse a date
    * trim chars on left and/or right of strings
    * How to make parsing loops work from back to front?
    * How to replace variable references in a template text file by the value of the referenced variables?
    * How to replace i with I only if it has spaces before and after
    * remove duplicate lines
*/

N2:
/*
  http://www.regular-expressions.info/numericranges.html
    Matching Floating Point Numbers with a Regular Expression
    Here are a few more common ranges that you may want to match:

     * 000..255:        ^([01][0-9][0-9]|2[0-4][0-9]|25[0-5])$
     * 0 or 000..255:   ^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$
     * 0 or 000..127:   ^(0?[0-9]?[0-9]|1[0-1][0-9]|12[0-7])$
     * 0..999:          ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
     * 000..999:        ^[0-9]{3}$
     * 0 or 000..999:   ^[0-9]{1,3}$
     * 1..999:          ^([1-9]|[1-9][0-9]|[1-9][0-9][0-9])$
     * 001..999:        ^(00[1-9]|0[1-9][0-9]|[1-9][0-9][0-9])$
     * 1 or 001..999:   ^(0{0,2}[1-9]|0?[1-9][0-9]|[1-9][0-9][0-9])$
     * 0 or 00..59:     ^[0-5]?[0-9]$
     * 0 or 000..366:   ^(0?[0-9]?[0-9]|[1-2][0-9][0-9]|3[0-6][0-9]|36[0-6])$


  http://www.codeproject.com/KB/dotnet/regextutorial.aspx
    1. elvis                 Find elvis
    2. \belvis\b             Find elvis as a whole word
    3. \belvis\b.*\balive\b  Find text with "elvis" followed by "alive"
    4. \b\d\d\d-\d\d\d\d     Find seven-digit phone number
    5. \b\d{3}-\d{4}         Find seven-digit phone number a better way
    6. \ba\w*\b              Find words that start with the letter a
    7. \d+                   Find repeated strings of digits
    8. \b\w{6}\b             Find six letter words
    9. . ^\d{3}-\d{4}$       Validate a seven-digit phone number
   10. \b\w{5,6}\b           Find all five and six letter words
   11. \b\d{3}\s\d{3}-\d{4}  Find ten digit phone numbers
   12. \d{3}-\d{2}-\d{4}     Social security number
   13. ^\w*                  The first word in the line or in the text
   14. \(?\d{3}[) ]\s?\d{3}[- ]\d{4} A ten digit phone number
   15. \S+                   All strings that do not contain whitespace characters
   16. \b\d{5}-\d{4}\b|\b\d{5}\b           Five and nine digit Zip Codes
   17. (\(\d{3}\)|\d{3})\s?\d{3}[- ]\d{4}  Ten digit phone numbers, a better way.  This expression will find phone numbers in several formats, like "(800) 325-3535" or "650 555 1212". The "\(?" searches for zero or one left parentheses, "[) ]" searches for a right parenthesis or a space. The "\s?" searches for zero or one whitespace characters. Unfortunately, it will also find cases like "650) 555-1212" in which the parenthesis is not balanced. Below, you'll see how to use alternatives to eliminate this problem.
   18. (\d{1,3}\.){3}\d{1,3}               A simple IP address finder
   19. ((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)  IP finder
   20. \b(\w+)\b\s*\1\b                Find repeated words
   21. \b(?<Word>\w+)\b\s*\k<Word>\b   Capture repeated word in a named group
   22. \b\w+(?=ing\b)        The beginning of words ending with "ing"
   23. (?<=\bre)\w+\b        The end of words starting with "re"
   24. (?<=\d)\d{3}\b        Three digits at the end of a word, preceded by a digit
   25. (?<=\s)\w+(?=\s)      Alphanumeric strings bounded by whitespace
   26. \b\w*q[^u]\w*\b       Words with "q" followed by NOT "u"
   27. \b\w*q(?!u)\w*\b      Search for words with "q" not followed by "u"
   28. \d{3}(?!\d)           Three digits not followed by another digit
   29. (?<![a-z ])\w{7}      Strings of 7 alphanumerics not preceded by a letter or space
   30. (?<=<(\w+)>).*(?=<\/\1>)   Text between HTML tags
   31. Text between HTML tags (see referenced source page above)
   32. a.*b                  The longest string starting with a and ending with b
   33. a.*?b                 The shortest string starting with a and ending with b

    Phone numbers:
    \(\d\d\d\)\s\d\d\d-\d\d\d\d
    \(\d{3}\)\s\d{3}-\d{4}
    4. \b\d\d\d-\d\d\d\d           Find seven-digit phone number
    5. \b\d{3}-\d{4}               Find seven-digit phone number a better way
    9.  ^\d{3}-\d{4}$              Validate a seven-digit phone number
    11. \b\d{3}\s\d{3}-\d{4}       Find ten digit phone numbers
    14. \(?\d{3}[) ]\s?\d{3}[- ]\d{4} A ten digit phone number
    17. (\(\d{3}\)|\d{3})\s?\d{3}[- ]\d{4} Ten digit phone numbers, a better way.  This expression will find phone numbers in several formats, like "(800) 325-3535" or "650 555 1212". The "\(?" searches for zero or one left parentheses, "[) ]" searches for a right parenthesis or a space. The "\s?" searches for zero or one whitespace characters. Unfortunately, it will also find cases like "650) 555-1212" in which the parenthesis is not balanced. Below, you'll see how to use alternatives to eliminate this problem.


Dates:

    a. (\d\d)-(\d\d)-(\d\d\d\d)    MM-DD-YYYY   (MM -& $1, DD -& $2, YYY -& $3)
    b. (\d\d\d\d)-(\d\d)-(\d\d)    YYYY-MM-DD   (YYYY -& $1, MM -& $2, DD -& $3)
    c. ^\d{1,2}\/\d{1,2}\/\d{4}$   XX/XX/YYYY where XX can be 1 or 2 digits long and YYYY is always 4 digits long.


  ;------------------------------------------------------------------------------
  http://www.codeproject.com/KB/string/re.aspx

    Swap the first two words:
    s/(\S+)(\s+)(\S+)/$3$2$1/

    Find name=value pairs:
    m/(\w+)\s*=\s*(.*?)\s*$/
    Now name is in $1, value is in $2.

    Read a date in the form YYYY-MM-DD:
    m/(\d{4})-(\d\d)-(\d\d)/
    Now YYYY is in $1, MM is in $2, DD is in $3.

    Remove the leading path from a filename:
    s/^.*\///

*/

N3:
/************************************************
  RegExReplace
*/

N3.1:

; Examples
f1 := RegExReplace("55555", "5", "five") ;f1 = "fivefivefivefivefive"
MsgBox f1=%f1%

f2 := RegExReplace("55555", "55", "x") ;f2 = "xx5"
MsgBox f2=%f2%


N3.2:
;  Regular Expression to EXTRACT Month, Day, Year, from 1/22/2009
;  (month & day can be 1 or 2 digits)
 c := "xxxxxxxx 1/22/2009 yyyyyyyyyyyy"
 month := RegExReplace(c,".*?(\d{1,2})\/(\d{1,2})\/(\d{4})(.*)","$1")
 day   := RegExReplace(c,".*?(\d{1,2})\/(\d{1,2})\/(\d{4})(.*)","$2")
 year  := RegExReplace(c,".*?(\d{1,2})\/(\d{1,2})\/(\d{4})(.*)","$3")
 MsgBox month=%month%`nday=%day%`nyear=%year%


 N3.3:
;AN EXAMPLE OF HOW WE CAN STEP BY STEP BUILD UP OUR REGULAR EXPRESSION
;Given string c, extract the data...
c := "  02-17-2009     238  Payment by Check.     314.15   9,265.35  "

;start with "(.*)" which grabs the whole string
f3 := RegExReplace(c, "(.*)", "$1") ;f3 = "02-17-2009     238  Payment by Check.     314.15   9,265.35"
MsgBox f3=%f3%

;add "(\d\d)" to parse off the first two digits (the month)
f4 := RegExReplace(c, "(\d\d)(.*)", "{$1} {$2}") ;f4 = "{02} {-17-2009     238  Payment by Check.     314.15   9,265.35}"
MsgBox f4=%f4%

;add "-" to parse off the dash
f5 := RegExReplace(c, "(\d\d)-(.*)", "{$1} {$2}") ;f5 = "{02} {17-2009     238  Payment by Check.     314.15   9,265.35}"
MsgBox f5=%f5%

;add "(\d\d)" to parse off the second two digits (the day) and save it as $2
f6 := RegExReplace(c, "(\d\d)-(\d\d)(.*)", "{$1} {$2} {$3}") ;f6 = "{02} {17} {-2009     238  Payment by Check.     314.15   9,265.35}"
MsgBox f6=%f6%

;add "(\d\d\d\d)" to parse off the year (4 digits) and save it as $3
f7 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d)(.*)", "{$1} {$2} {$3} {$4}") ;f7 = "{02} {17} {2009} {     238  Payment by Check.     314.15   9,265.35}"
MsgBox f7=%f7%

;add " +" to parse off one or more spaces
f8 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(.*)", "{$1} {$2} {$3} {$4}") ;f8 = "{02} {17} {2009} {238  Payment by Check.     314.15   9,265.35}"
MsgBox f8=%f8%

;add "(\d+)" to parse off the check number (one or more digits) and save it as $4
f9 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+)(.*)", "{$1} {$2} {$3} {$4} {$5}") ;f9 = "{02} {17} {2009} {238} {  Payment by Check.     314.15   9,265.35}"
MsgBox f9=%f9%

;add " +" to parse off one or more spaces
f10 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+) +(.*)", "{$1} {$2} {$3} {$4} {$5}") ;f10 = "{02} {17} {2009} {238} {Payment by Check.     314.15   9,265.35}"
MsgBox f10=%f10%

;add "(.*?)" to parse off the text (minimal match), followed by...
;add " {5}" to parse off 5 spaces (there apparently is always 5 spaces. This tells us when we're done parsing off the text.)
f11 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+) +(.*?) {5}(.*)", "{$1} {$2} {$3} {$4} {$5} {$6}") ;f11 = "{02} {17} {2009} {238} {Payment by Check.} {314.15   9,265.35}"
MsgBox f11=%f11%

;add "([\d,.]+)" to parse off the dollars and cents (one or more digits with possible commas and decimal point, e.g. 27,182.81)
f12 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+) +(.*?) {5}([\d,.]+)(.*)", "{$1} {$2} {$3} {$4} {$5} {$6} {$7}") ;f12 = "{02} {17} {2009} {238} {Payment by Check.} {314.15} {   9,265.35}"
MsgBox f12=%f12%

;add " {3}" to parse off 3 spaces (apparently always 3)
f13 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+) +(.*?) {5}([\d,.]+) {3}(.*)", "{$1} {$2} {$3} {$4} {$5} {$6} {$7}") ;f13 = "{02} {17} {2009} {238} {Payment by Check.} {314.15} {9,265.35}"
MsgBox f13=%f13%

;add "([\d,.]+" to parse off the dollars and cents (one or more digits with possible commas and decimal point, e.g. 27,182.81)
f14 := RegExReplace(c, "(\d\d)-(\d\d)-(\d\d\d\d) +(\d+) +(.*?) {5}([\d,.]+) {3}([\d,.]+)(.*)", "{$1} {$2} {$3} {$4} {$5} {$6} {$7} {$8}") ;f14 = "{02} {17} {2009} {238} {Payment by Check.} {314.15} {9,265.35} {}" (the last empty {} indicates there's nothing left over)
MsgBox f14=%f14%


N3.4:
;find the $ dollar sign
c := "xxx $17.25 yyy"
dollar := RegExReplace(c,"(.*?)(\$)(.*)","$2")
msgbox dollar=%dollar%

;extract price and add a dollar sign
c := "xxx 17.25 yyy"
price := RegExReplace(c,"(.*?)([\d,.]+)(.*)","$$$2")
msgbox price=%price%   ; price = "$17.25"
; DOC: For replacement RegEx only, To specify a literal $, use $$
; this is the only character that needs such special treatment in
; a RegEx replace string; backslashes are never needed to escape
; anything else in a RegEx replace string.
; (RegEx search string still needs to have many characters escaped).


O:
/******************************************************************************
  Misc AutoHotkey Notes

O1: Notes

  ALL VARIABLES ARE STORED AS CHARACTER STRINGS !!!
    Strings containing numbers are converted to numbers when needed,
    and the result is converted back to a string.

  Closing */ must be first thing on line. Otherwise you'll be asking yourself,
    "Why does my script stop running at this point, as if the whole rest of the
     script was commented out?"


  When sending text, if there are problems, sometimes it helps to
    throw in a short delay (Sleep 100), or to slow down the sending of characters
    by using SetKeyDelay (SetKeyDelay 90)

  MsgBox: You may need to manually restore focus to your current window
    after a call to MsgBox. I was debugging an AutoHotkey script by throwing
    in a bunch of MsgBox messages, and I discovered a problem that focus
    wasn't being returned to my window after the MsgBox timed out. So, I
    added a WinActivate after MsgBox to restore focus to my window, and all
    was well again. (May have been caused by cross contamination from another unrelated program.)
  Update: I had another case where this fix was exactly the wrong thing to do.
   The "current window" wasn't the one I wanted. Removing the WinExist/WinActivate
   combo fixed the problem. (Alas, no solution is universal.)
*/
;MsgBox Example:
ID := WinExist("A") ;a fast way to get the ID of the active window.
MsgBox, 0, , The window ID is %ID%, 2.0
WinActivate, ahk_id %ID%

;MsgBox Simpler Example:
WinExist("A")   ;current window becomes "Last Found Window"
MsgBox Here is my message
WinActivate     ;If all parameters are omitted, the Last Found Window will be activated.

O2:
/******************************************************************************
 SENDING DEBUG DATA TO A LOG FILE
*/
;Example 1. Log a message
O2.1:
SetWorkingDir, %A_ScriptDir%  ;Set default directory to where this script file is located
LogFile := "MyLog.txt"
FileAppend, This is a message`n, %LogFile%  ;(note the trailing (`n) to start a new line. This could instead be a leading (`n) if you want.

;Example 2. Include a time stamp
O2.2:
SetWorkingDir, %A_ScriptDir%  ;Set default directory to where this script file is located
LogFile := "MyLog.txt"
FormatTime, TimeString, , yyyy-MM-dd hh:mm:ss tt
FileAppend, `n%TimeString% : This is a message`n, %LogFile%

;Example 3. Put it all in a function named LogMsg. (This example is commented out since it all belongs in a separate .ahk file. Give it a try.)
O2.3:
/*
;BEGIN
SetWorkingDir, %A_ScriptDir%  ;Set default directory to where this script file is located
LogFile := "MyLog.txt"
LogMsg("This is a message")   ;Note LogMsg adds a leading (`n) so each message starts on a new line
LogMsg("Variable X = " . X )  ;Concatenate using the dot .
ExitApp
;---------------------------
;And here is our function:
LogMsg( msg )
{
  global LogFile
  FormatTime, TimeString, , yyyy-MM-dd hh:mm:ss tt
  FileAppend, `n%TimeString% : %msg%, %LogFile%
}
;THE END
*/

O3:
/******************************************************************************
 Capturing a screen image during run using IrfanView (www.irfanview.com)
*/
RunWait "C:\Program Files\IrfanView\i_view32.exe" "/capture=1  /convert=C:\TEMP\MyImage.bmp"


P:
/************************************************
  Misc AutoHotkey Scripts:

P1: Misc AutoHotkey Scripts:

  * System Uptime: http://www.autohotkey.com/forum/topic18534.html
  * Laptop Low Battery Alert (BatteryDeley): http://www.autohotkey.com/forum/viewtopic.php?t=40683
  * Laptop Battery Indicator (PowerCircle): http://powercircle.aldwin.us/
  * DimScreen: http://www.donationcoder.com/Software/Skrommel/#DimScreen

  * Extract Informations about TaskButtons http://www.autohotkey.com/forum/viewtopic.php?t=18652

  * Numbasechng - Number Base Change:
       http://www.autohotkey.com/wiki/index.php?title=Numbasechng
       http://www.autohotkey.com/wiki/index.php?title=Function_Listing


P2: Index of notable scripts found in the AutoHotkey Forum: http://www.autohotkey.com/wiki/index.php?title=Script_Listing
    * 1 AutoHotkey Related
          o 1.1 Ports/custom builds
                + 1.1.1 Windows NT+
                + 1.1.2 Windows CE
                + 1.1.3 Windows/Linux/Mac (.NET/Mono)
          o 1.2 Compile AutoHotkey yourself
                + 1.2.1 MS Visual C++
                + 1.2.2 GCC
          o 1.3 Use AutoHotkey with other programming/scripting languages
                + 1.3.1 Any
          o 1.4 Use other programming/scripting languages inline in AutoHotkey
                + 1.4.1 Perl
                + 1.4.2 C#/VB
                + 1.4.3 VBScript/JScript, VB/VBA/MS Office
                + 1.4.4 Assembly/Machine code
                + 1.4.5 C/C++
                + 1.4.6 Lisp/ECL
          o 1.5 Scripts
          o 1.6 Tools
          o 1.7 Editors
    * 2 GUI
          o 2.1 General
          o 2.2 All
          o 2.3 3P Controls
          o 2.4 MsgBox
          o 2.5 ListBox
          o 2.6 Splash
          o 2.7 Menu
          o 2.8 Templates
          o 2.9 Hotkey
          o 2.10 Button
          o 2.11 Hyperlink
          o 2.12 ListView
          o 2.13 Edit
          o 2.14 Other
          o 2.15 Tooltip
          o 2.16 TreeView
    * 3 Functions
    * 4 Audio and Video
    * 5 File Management and Searching
    * 6 File Reading & Parsing
    * 7 Internet related
    * 8 XML, HTML and BBCode
    * 9 Window Manipulation
    * 10 Keyboard Enhancements
    * 11 Mouse Related
    * 12 Clipboard Manipulation
    * 13 Games
          o 13.1 Game Related
    * 14 Fun
    * 15 Images
    * 16 Time and Scheduling
    * 17 Encryption / Encoding / Binary
    * 18 System Related
    * 19 Security
    * 20 Miscellaneous


P3: AHK Functions - ƒ()
http://www.autohotkey.com/forum/viewtopic.php?t=8728

AUTOHOTKEY:
  VarExist(Var) - http://www.autohotkey.com/forum/viewtopic.php?p=83371#83371
  ƒ() - Pass an array of integers to a function. http://www.autohotkey.com/forum/viewtopic.php?p=242750#242750
STRINGS:
  SetWidth(Str,Width,AlignText) - increase a string's length by adding spaces to it and aligns it Left/Center/Right.
  NumFormat( Number, Width, Dec, PadChar ) - format a float. Pad leading characters (any character) to a numeric string.
  Replicate(chr,x)
  Replicate(chr(196),80) - creates a horizontal ruling 80 characters wide
  Space(Width)
  Space(80) - 80 spaces
  UPPER(String)
  LOWER(String)
  PROPER(String)
http://www.autohotkey.com/forum/viewtopic.php?p=53028#53028
  RandStr() - Generates and returns a Random string. http://www.autohotkey.com/forum/viewtopic.php?p=217712#217712
  HashStr() - Hashes a String and returns value as hex.
  Hash() - Hashes a Byte-array and returns value as hex.
http://www.autohotkey.com/forum/viewtopic.php?p=231784#231784

Last Day Of Month (e.g. 30, 31, 28, 29) LDOM() - http://www.autohotkey.com/forum/viewtopic.php?p=54502#54502
Last Day Of Month - YearMonthDay format - http://www.autohotkey.com/forum/viewtopic.php?p=54532#54532

COLOR:
   HEX2RGB(HEXString,Delimiter="")
   RGB2HEX(RGBString,Delimiter="")
   CheckHexC(HEXString) - validates a "Hex Color Code" by calling the above two functions.
   Examples:
     HEX2RGB("FFFFFF")      -> "255,255,255"
     RGB2HEX("255,255,255") -> "FFFFFF"
     CheckHexC("FFFFFF")    -> 1
     CheckHexC("GOYYAH")    -> 0
   http://www.autohotkey.com/forum/viewtopic.php?p=58125#58125
  ChooseColor() - wrapper function for windows ChooseColor Dialog. http://www.autohotkey.com/forum/viewtopic.php?p=103432#103432
  ColorAdjL() - Adjust Luminance for a given RGB color. In other words, this function can derive a lighter / darker shade for a given RGB color. http://www.autohotkey.com/forum/viewtopic.php?p=238242#238242
  GetSysColor() - calls windows GetSysColor function http://www.autohotkey.com/forum/viewtopic.php?p=66521#66521
  windows GetSysColor function: http://msdn.microsoft.com/en-us/library/ms724371.aspx

FILES:
GetShortPathName(LongPath)
  using %A_LoopFileShortPath% - http://www.autohotkey.com/forum/viewtopic.php?p=69345#69345
  using DllCall - http://www.autohotkey.com/forum/viewtopic.php?p=69366#69366
GetFileFolderSize(fPath) - http://www.autohotkey.com/forum/viewtopic.php?p=82689#82689
DriveSpace() - Returns the FreeSpace / Capacity of a Drive in bytes. http://www.autohotkey.com/forum/viewtopic.php?p=92483#92483
ShellFileOperation() - Basic Wrapper. A shell function that can be called to Copy / Move / Delete / Rename File(s). http://www.autohotkey.com/forum/viewtopic.php?p=133249#133249
GetBinaryType() - Determines whether a file is executable, and if so, what type of executable file it is. http://www.autohotkey.com/forum/viewtopic.php?p=66383#66383
FileGetVersionInfo() - Extracts and returns version information from an executable file. http://www.autohotkey.com/forum/viewtopic.php?p=233188#233188

SOUND:
SoundCard() - Returns the number of soundcards available on a system. http://www.autohotkey.com/forum/viewtopic.php?p=88891#88891
SoundExC() - SoundEx Classic Version. Phonetic algorithm for indexing names by sound (English). http://www.autohotkey.com/forum/viewtopic.php?p=240065#240065

IMAGES:
ConvertGraphicsFile() - Converts image file format between GIF/BMP/JPG/PNG. http://www.autohotkey.com/forum/viewtopic.php?p=190227#190227

VIDEO:
AviFileInfo() - Returns the video properties of an AVI file http://www.autohotkey.com/forum/viewtopic.php?p=91036#91036

SYSTEM:
GetPriority(ProcessName) - http://www.autohotkey.com/forum/viewtopic.php?p=80548#80548
ProcessOwner() - Returns the Owner for a given Process ID. http://www.autohotkey.com/forum/viewtopic.php?p=232445#232445
ProcessCreationTime( ProcessID ) - http://www.autohotkey.com/forum/viewtopic.php?p=97186#97186
Affinity_Set() - Sets the CPU to be used in Dual/Quad/Multi core processors / Effectively, this function allows you to choose which AHK script uses what processor. http://www.autohotkey.com/forum/viewtopic.php?p=202460#202460



P4: Library for Text File Manipulation http://www.autohotkey.net/~heresy/Functions/TXT.ahk
      Basic Functions
           TXT_TotalLines
           TXT_ReadLines
           TXT_Tail
      Alignment Functions
           TXT_AlignLeft
           TXT_AlignCenter
           TXT_AlignRight
           TXT_ReverseLines
      Removement Functions
           TXT_RemoveLines
           TXT_RemoveBlankLines
           TXT_RemoveDuplicateLines
      Replacement Functions
           TXT_Replace
           TXT_RegExReplace
           TXT_ReplaceLine
      Insertion Functions
           TXT_LineNumber
           TXT_InsertLine
           TXT_InsertPrefix
           TXT_InsertSuffix
      Column Functions
           TXT_ColGet
           TXT_ColPut
           TXT_ColCut
      Trimming Functions
           TXT_TrimLeft
           TXT_TrimRight
      CSV Functions
           TXT_GetCSV
           TXT_SetCSV
      File Join/Split Functions
           TXT_ConCat


P5: TRAY ICONS
  * Master TrayIcon to control all running instances of AutoHotkey http://www.autohotkey.com/forum/viewtopic.php?p=142958#142958
  * Extract Informations about TrayIcons http://www.autohotkey.com/forum/viewtopic.php?t=17314


P6: To force Exit another AutoHotkey script (and have it's icon removed from the system tray):
    WM_COMMAND = 0x111
    ID_FILE_EXIT = 65405
    PostMessage, WM_COMMAND, ID_FILE_EXIT, 0, , <window-title>
;Example:
    WM_COMMAND = 0x111
    ID_FILE_EXIT = 65405
    PostMessage,WM_COMMAND,ID_FILE_EXIT,0,, DimScreen Screen

Note: The above only works for AutoHotkey scrips (*.ahk, or compiled to *.exe)
Note: To determine the Window Title, run Process Explorer http://technet.microsoft.com/en-us/sysinternals/bb896653.aspx
Note: AutoHotkey has the following wm_command number defined in resource.h
    ID_FILE_PAUSE     65403
    ID_FILE_SUSPEND   65404
    ID_FILE_EXIT      65405
    (0x111 is WM_COMMAND)

Other wm_command numbers defined in AutoHotkey source file resource.h
(I haven't tried any of these to see what they do)
#define ID_FILE_RELOADSCRIPT            65400
#define ID_FILE_EDITSCRIPT              65401
#define ID_FILE_WINDOWSPY               65402
#define ID_FILE_PAUSE                   65403
#define ID_FILE_SUSPEND                 65404
#define ID_FILE_EXIT                    65405
#define ID_VIEW_LINES                   65406
#define ID_VIEW_VARIABLES               65407
#define ID_VIEW_HOTKEYS                 65408
#define ID_VIEW_KEYHISTORY              65409
#define ID_VIEW_REFRESH                 65410
#define ID_HELP_USERMANUAL              65411
#define ID_HELP_WEBSITE                 65412

Another way to identify the AutoHotkey script you want to Exit(/Suspend/Pause):
DetectHiddenWindows, On

WinGet, AList, List, ahk_class AutoHotkey       ; Make a list of all running AutoHotkey programs
Loop %AList% {                                  ; Loop through the list
  ID := AList%A_Index%
  WinGetTitle, ATitle, ahk_id %ID%              ; (You'll notice this isn't the same 'window title')
  MsgBox, 3, %A_ScriptName%, %ATitle%`n`nEnd?
  IfMsgBox Cancel
    Break
  IfMsgBox Yes
    PostMessage,WM_COMMAND,ID_FILE_EXIT,0,,% "ahk_id" AList%A_Index%   ; End the process (65404 to suspend, 65403 to pause)
}
ExitApp

*/


Q:
/******************************************************************************
  NAVIGATING WEB SITES
  (See example file WebsiteNav.ahk)
*/
Q1:
/*
  DETERMINING WHEN A WEBPAGE HAS FINISHED LOADING:
    See FAQ: http://www.autohotkey.com/docs/FAQ.htm#load

    Method 1: Wait for status line to say "Done"
    (See example file WebsiteNav.ahk)

    Method 2: call IEReady()
    [Only works for Internet Explorer (afik).]
   (See example file WebsiteNav.ahk)
    See post "Determine if a WebPage is completely loaded in IE" : http://www.autohotkey.com/forum/topic19256.html
         1a. Download Com.zip from:  http://www.autohotkey.net/~Sean/Lib/COM.zip  ("COM Standard Library" post: http://www.autohotkey.com/forum/topic22923.html)
         1b. unzip and place COM.ahk here:  C:\Program Files\AutoHotkey\Lib\COM.ahk
         2a. Download function IEReady from:  http://www.autohotkey.com/forum/topic19256.html
         2b. Add fuction IEReady to your .ahk code
         3.  Place a call to IEReady() in your .ahk code when you want to wait until the page is loaded
         (See example file WebsiteNav.ahk)

     Method 3: See "Detect when a page is loaded (reliable, cross-browser)" post: http://www.autohotkey.com/forum/topic35056.html

     Methods 4,5,6,...
     For more advanced methods which are over my head, see these two posts:

       Automation IE7 Navigation and Scripting with Tabs
       http://www.autohotkey.com/forum/viewtopic.php?t=30599

       IE and Gui Browser Com Tutorial
       http://www.autohotkey.com/forum/viewtopic.php?t=34972

       ("This is left as an exercise for the student", which is what the professor says when it's over his head.)
*/

Q2:
/*
  POSITIONING ON A CONTROL
    (See example file http://www.autohotkey.net/~deleyd/xprxmp/WebsiteNav.ahk)
    [Warning: JavaScript is case sensitive.]
    Examples from simple to more complex

      Method 1. Blindly hit the {Tab} key a certain number of times to position us where we want to be. (Usually not very reliable)
        Example:
          Send {Tab 3}  ;say, 3 tabs gets us where we want to be.

      Method 2. Hit the {Tab} key until certain text appears in the status bar
        Example: on page www.autohotkey.com, hit {Tab} until we find "http://www.autohotkey.com/wiki/" in the status bar.

      Method 2.5 Hit Shift+Tab to tab backwards until certain text appears in the status bar
        (May be useful if tabbing forwards doesn't work)

      Method 3. Search for word which is link you want to click on

      Method 4. Jump directly to the control using the control ID or the control NAME, using AutoHotkey 'ControlSetText' and 'ControlSend'
        General format using ID:
          ControlSetText, Edit1, javascript:document.getElementById( '<element-ID'>)[0].focus()
          ControlSend, Edit1, {Enter}, <window-title>

        General format using NAME:
          ControlSetText, Edit1, javascript:document.getElementsByName( '<element-name>')[0].focus()
          ControlSend, Edit1, {Enter}, <window-title>

        If more than one control has the same name:
          a. Go kick George Foreman in the shin for naming all 5 of his sons "George" (and two of his daughters).
          b. Then figure out what number to use instead of [0] to get to the n'th control with that NAME.

          (Note: There is no legal way to use the NAME attribute from such tags as DIV or SPAN, according to the W3C HTML 4.01 specs. You must confine the usage of this attribute to such tags as INPUT, IMG, FRAME, IFRAME, FORM, MAP, PARAM, META, OBJECT, A, SELECT, APPLET, TEXTAREA, or BUTTON. (Those who use XML or XHTML or XFILES or whatever may have different rules to play by.)

        If the control you want has no ID or NAME:
          Argh! This is getting hard! You'll have to go read up about JavaScript and the DOM (Document Object Model)

          Some things you could try:

              javascript:document.getElementsByTagName('a')[6].focus() ; Get the 7th <A> tag in the document (numbering begins with 0).
              javascript:document.links[6].focus()                     ; Get the 7th link in the document (numbering begins with 0).

      Methods 5,6,7,...
      For more advanced methods over my head, see these two posts:

       Automation IE7 Navigation and Scripting with Tabs
       http://www.autohotkey.com/forum/viewtopic.php?t=30599

       IE and Gui Browser Com Tutorial
       http://www.autohotkey.com/forum/viewtopic.php?t=34972

       (Professor again says, "This is left as an exercise for the student.")
*/

Q3:
/*************************************************
  SEARCH FOR A COLORED PIXEL
     If I'm searching a white background for black text, I find it
     works better to search for "not white" rather than search for
     "black", because sometimes that black text isn't really black
     when you look at it closely.

     This actually goes quite fast if you comment out the moving of
     the mouse. I move the mouse here for demonstration purposes.
*/
WinGetPos, winposX, winposY, Width, Height, A  ;Get window Width, Height
;MsgBox, 0, , winposX=%winposX%`n winposY=%winposY% `nWidth=%Width% `nHeight=%Height%,

;Calculate a starting position
X := Width - 60
Y := Height / 2
MouseMove, X, Y, 7

MsgBox, 0, , Move left until we find "not white", 1.2

;move left until we find "not white"
loop 200
{
    MouseMove, X, Y, 0
    PixelGetColor, color, X, Y, RGB
    ;MsgBox, 0, , color=%color%, 0.1
    if (color <> "0xFFFFFF")
    {
      Goto FOUND_TCOLOR
    }
    X -= 1
}
;If we drop out here, it means we failed to find our target
MsgBox, 0, , Failed to find color "not white", 2
goto Exit

FOUND_TCOLOR:
MsgBox, 0, , Found "not white". color = %color%, 2

Exit:
MsgBox, 0, , The End, 2
ExitApp


R:
/************************************************
  NEWBIE RECOMMENDED LEARNING SEQUENCE
  Reference: Recommended by jaco0646 (thank you jaco0646)
  http://www.autohotkey.com/forum/viewtopic.php?t=29204)

    Commands dealing with files start with FILE
    Commands dealing with windows start with WIN
    Commands dealing with text start with STRING

   Similarly:

    Commands that retrieve data from somewhere contain GET
    Commands that apply data to somewhere contain SET


   Suggested order of study for AutoHotkey newbies:
    First:
    1: read the Tutorial
    2: the Scripts page
    3: the FAQ

   Afterwards, recommend learning concepts in the following order:

    1. Hotstrings
    2. Hotkeys
    3. Mouse Clicks & Mouse HotKeys
    4. Variables
    5. Loops - especially Parsing Loops
    6. String commands - (e.g. StringMid, StringReplace)
    7. If,Else statements
    8. Expressions
    9. Arrays & Dynamic variables - (StringSplit)
    10. GoSub & Functions
    11. GUIs
    12. Windows Messages
    13. DllCall
 */

S:
/******************************************************************************
  PRESS ESC TO CANCEL THIS SCRIPT
    A hotkey definition line stops execution at that point, so if you want the
    script to run to the end but have the ESC key available to terminate the script,
    put the hotkey definition at the end, just AFTER your ExitApp statement.
*/
;Press ESC to cancel this script
Esc::ExitApp

/*
 My title: "" %% (), And All That,
 is taken from the wonderful book, "Div, Grad, Curl, And All That" by H. M. Schey, "An Informal Text on Vector Calculus" (1973)

 http://www.autohotkey.com/forum/viewtopic.php?t=41511
*/