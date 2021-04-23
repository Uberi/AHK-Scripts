#SingleInstance

;Since the obfuscator is set to do Dynamic obfuscation by default,
;leaving off obfuscator CHANGE_DEFAULTS statements at the beginning
;of your program will set the obfuscator to do dynamic obfuscation
  
;put a string assignment header like this in your program so that
;the program name and copyright info still shows up in the obfuscated ;version of this program
program_name:="obfclasses.ahk"
program_name:="Author: David Malia, Augusta, ME"
program_name:="Copyright David Malia, 2013"

;these are the minimum DUMP statements you need to use when using
;dynamic obfuscation. none of these would be required
;for 'straight' obfuscation
;ALL FUNCTIONS MUST BE MADE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!

;security fragments and triple mess fragments for common objects
;must be dumped before anything else
;$OBFUSCATOR: $DUMP_SECFRAGS_FORCLASSES: common
;$OBFUSCATOR: $DUMP_TMESSFRAGS_FORCLASSES: common
;dump variable fragments 
;$OBFUSCATOR: $GLOBVARFRAGS_DUMPALL:
;$OBFUSCATOR: $LOSVARFRAGS_DUMPALL:
;$OBFUSCATOR: $PARAMFRAGS_DUMPALL:
;for obfuscated system function calls
;$OBFUSCATOR: $SYSFUNCFRAGS_DUMPALL: 
;always use these dumps for function and label fragments when
;doing dynamic obfuscation 
;$OBFUSCATOR: $FUNCFRAGS_DUMPCLASS: unclassed
;$OBFUSCATOR: $FUNCFRAGS_DUMPCLASS: unsecclasses
;$OBFUSCATOR: $LABELFRAGS_DUMPCLASS: unclassed
;$OBFUSCATOR: $LABELFRAGS_DUMPCLASS: unsecclasses

;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
mytrue = 1
myfalse = 0

;AUTOHOTKEY BUILT IN FUNCTIONS!
;tell obfuscator to obfuscate these autohotkey built in functions
;$OBFUSCATOR: $DEFSYSFUNCS: substr, strlen, chr, asc, instr, 

;BECAUSE THIS PROGRAM HAS 'SECURE' OBFUSCATION CLASSES
;DUMPS MUST BE DONE FOR EACH SECURE CLASS!
;they will be done in the following functions:
;'SECURITYTESTS_bestcodesection' and 'WIREUP_bestcodesection'.
;the first function will pop a dialog box to the user if they
;want to run the program simulating security passed or security failed.
;poisened DUMPS can be run in that function!

;i will DUMP good security fragments or poisened security fragments
;for a secure obfuscation class named 'bestcodesection'

SECURITYTESTS_bestcodesection()

;now i will DUMP triple mess fragments and object name fragments
;for a class named 'bestcodesection'. if poisened security fragments
;were dumped above, then the wiring up below will all be done wrong!
WIREUP_bestcodesection()

;now i call a function that is in the 'bestcodesection' class.
;if the wiring up above has gone bad, then a call to the function
;below will end up with an ugly result or not running at all!
MsgBox, 4, RUN TEST, %securitypassed%`n`nRUN TEST?`nCall the function named 'function_in_bestcodesection' in 'bestcodesection'?	
IfMsgBox Yes 
{
	function_in_bestcodesection()
	msgbox, %securitypassed%`n`nINTERPRET TEST RESULTS:`nMessage '123' should have shown! Otherwise the function never executed.
}

;now i call a label that is in the 'bestcodesection' class.
;if the wiring up above has gone bad, then a call to the function
;below will end up with an ugly result or not running at all!
MsgBox, 4, RUN TEST, %securitypassed%`n`nRUN TEST?`nCall the label named [gosubin_bestcodesection] in 'bestcodesection'?	
IfMsgBox Yes 
{
	gosub, gosubin_bestcodesection
	msgbox, %securitypassed%`n`nINTERPRET TEST RESULTS:`nMessage 'abc' should have shown! Otherwise the label wasn't called.
}

;now i call a function that creates a gui but the gui has a reference
;to a label that will be bad if you have choosen to simulate security
;failed. 
MsgBox, 4, RUN TEST, %securitypassed%`n`nRUN TEST?`nCreate GUI with reference to label in`nprotected class in it?	
IfMsgBox Yes 
{
	;tests local variables, global variables, gosub label as 
	;part of a 'gui, add' statement, and variables defined as associated
	;with a gui control
	creategui()
	
	msgbox, %securitypassed%`n`nINTERPRET TEST RESULTS:`nThis message should show!
}
	 
RETURN
;put after the end of the autoexecute section:
;$OBFUSCATOR: $END_AUTOEXECUTE:

;the first statement creates a 'secure' class and the second
;statement tells it to add the function and label sections that
;follow in the source code to that class

;$OBFUSCATOR: $CREATEOBJCLASS: bestcodesection
;$OBFUSCATOR: $ADDFOLLOWING_TOCLASS: bestcodesection

function_in_bestcodesection()
{
	global
	
	;yady yady yada
	
	msgbox, %securitypassed%`n`nInside function named [function_in_bestcodesection]`n`nMESSAGE: 123
}

returnfrom_bestcodesection()
{
	global
	
	return "hello from function named [returnfrom_bestcodesection]"	
}

gosubin_bestcodesection:
	msgbox, %securitypassed%`n`nInside label named [gosubin_bestcodesection]`n`nMESSAGE: abc
return

;this tells the obfuscator to stop adding function and label sections
;to the class
;$OBFUSCATOR: $ADDFOLLOWING_TOCLASS:


SECURITYTESTS_bestcodesection()
{
	global
;$OBFUSCATOR: $DEFGLOBVARS: securitypassed
	
	MsgBox, 4, SHOULD SECURITY PASS, SHOULD SECURITY BE COUNTED AS PASSED?`n`nShould this run of this program be`ncounted as passing security?

	;the only difference in the program will be the 2 DUMPS
	;everything else remains the same with no security forks
	IfMsgBox Yes 
	{
;$OBFUSCATOR: $DUMP_SECFRAGS_FORCLASSES: bestcodesection 
		securitypassed = SIMULATING SECURITY PASSED THIS RUN`nEverything should run as expected
	} else {
;$OBFUSCATOR: $DUMPPOISENED_SECFRAGS_FORCLASSES: bestcodesection
		securitypassed = SIMULATING SECURITY FAILED THIS RUN`nEverything SHOULD HAVE PROBLEMS running!
	}
}

WIREUP_bestcodesection()
{
	global	
;$OBFUSCATOR: $DUMP_TMESSFRAGS_FORCLASSES: bestcodesection
;$OBFUSCATOR: $DUMPFRAGS_FORCLASSES: bestcodesection
}

 
;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
creategui()
{
	global
	local h1font, h2font, basefont, mymessage
;$OBFUSCATOR: $DEFLOSVARS: h1font, h2font, basefont, mymessage

	h1font 		= % "s22"
	h2font 		= % "s18"	
	basefont 	= % "s14"
	mymessage := ihidestr("from Dynamic Obfuscator")

	gui 2:default
	gui, destroy
	gui, margin, 20, 20
	
	;the h1font variable below should be obfuscated
	gui, font, %h1font% bold
	gui, add, text, xm ym, Obfuscator Test GUI
	
	gui, font, %basefont% norm underline
	;the gosub label below should be obfuscated
	gui, add, text, xm y+12 cblue Ggosubin_bestcodesection, CALL GOSUB IN '_bestcodesection'
	
	gui, font, %basefont% norm
	gui, add, text, xm y+12 Gguigosub,
(
hello world

TESTING LITERAL STRING OBFUSCATION:
"%mymessage%"

-press home key to test hotkeys-
)
	gui, add, text, xm y+12, enter something here to test`nvariable obfuscation
;$OBFUSCATOR: $DEFGLOBVARS: usermessage
	gui, add, edit, xm y+2 Vusermessage r4, 
		
	gui, add, button, xm y+20 Gtestguisubmit, Test gui submit
	gui, add, button, x+20 yp Gcancelprog, Cancel program
	gui, show
}

testguisubmit:
	gui, submit, nohide
	msgbox, TESTING OBF OF Vvariablename IN 'gui, add':`n`nyou entered "%usermessage%"
return

cancelprog:
	exitapp
return

guigosub:
	msgbox, inside _guigosub_
return

;HOTKEYS SHOULD NOT BE OBFUSCATED!
home::
	msgbox, home key pressed!
return

RControl & RShift::
	msgbox, hello dave
	testfunction()
return

^;::
	msgbox, hello world
	testfunction()
return	

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;(technically this one would be all right because it does not call any
;functions or use any variables inside of it)
testfunction()
{
	global
	msgbox, TESTING OBF OF A FUNCTION CALL:`n`ntestfunction has been called
}

;******************************************
;	PUT THESE FUNCTIONS IN YOUR ACTUAL AUTOHOTKEY SCRIPT FILE

;put this function in your source code and then surround the literal ;strings you wish to be obfuscated with it
ihidestr(thisstr)
{
	return thisstr
}

;put this function in your source code. it will actually be called
;by the obfuscated code to 'decode' the obfuscated strings.
;this function and all calls to it will also be obfuscated in
;the output obfuscated program
decode_ihidestr(startstr) 
{
	global	
;$OBFUSCATOR: $DEFGLOBVARS: hexdigits
	
	static newstr, startstrlen, charnum, hinibble, lownibble, mybinary
;$OBFUSCATOR: $DEFLOSVARS: newstr, startstrlen, charnum, hinibble, lownibble, mybinary

	hexdigits = % "0123456789abcdef"
		
	;will get the encoded key hidden in the obfuscated literal string
	decode_hexshiftkeys(startstr)
	
	;grab encoded data
	startstr = % substr(startstr, 1, 1) . substr(startstr, 6)
	startstrlen = % strlen(startstr)
		
	newstr = 
	;reverse the hex string
	loop, % strlen(startstr) 
		newstr = % substr(startstr, a_index, 1) . newstr
	
	startstr = % newstr
	newstr = 
	charnum = 1
	;convert from hexidecimal to binary	
	while true
	{
		if (charnum >startstrlen)
			break
			
		hinibble = % substr(startstr, charnum, 1)
		;find it in hexdigits and convert to decimal number
		hinibble = % instr(hexdigits, hinibble) - 1
		
		lownibble = % substr(startstr, charnum + 1, 1)
		;find it in hexdigits and convert to decimal number
		lownibble = % instr(hexdigits, lownibble) - 1
		
		;unshift the hex
		hinibble := decode_shifthexdigit(hinibble)
		lownibble := decode_shifthexdigit(lownibble)
		
		mybinary = % hinibble * 16 + lownibble
		newstr .= chr(mybinary)
		
		charnum += 2		
	}
		
	newstr = % fixescapes(newstr)
		
	return, newstr	
}
decode_hexshiftkeys(startstr)
{
	global
;$OBFUSCATOR: $DEFGLOBVARS: decodekey, ishexchar, useshiftkey
	
	;these have '1's in them
	decodekey := "fff@kkf1ffkfkfkfff#k1fk@kf#@fffk@#kk"
	ishexchar := "fff@f1ff@kffkk#f1fffffkf"
	
	;grab randomly created encrypt key
	;i hid it in the obfuscated literal string, 2 characters in
	%decodekey%%ishexchar%1 = % substr(startstr, 2, 1)
	%decodekey%%ishexchar%2 = % substr(startstr, 3, 1)
	%decodekey%%ishexchar%3 = % substr(startstr, 4, 1)
	%decodekey%%ishexchar%4 = % substr(startstr, 5, 1)
	
	;covert key values to actual numbers
	loop, 4
		%decodekey%%a_index% = % instr(hexdigits, %decodekey%%ishexchar%%a_index%) - 1
			
	useshiftkey = 0
}	

decode_shifthexdigit(hexvalue)
{
	global
	
	;each time i enter this routine i will use the next key value
	;to shift the hexvalue
	useshiftkey++
	if (useshiftkey > 4)
		useshiftkey = 1	
	
	;subtract the shift key from the hexvalue 
	hexvalue -= %decodekey%%useshiftkey%
	
	;if i go under zero, just add 16
	if (hexvalue < 0) 
		hexvalue += 16
		
	return hexvalue	
}

fixescapes(forstr)
{
	global
	
	StringReplace, forstr, forstr, % "````", % "``", all
	StringReplace, forstr, forstr, % "``n", % "`n", all
	StringReplace, forstr, forstr, % "``r", % "`r", all
	StringReplace, forstr, forstr, % "``,", % "`,", all
	StringReplace, forstr, forstr, % "``%", % "`%", all	
	StringReplace, forstr, forstr, % "``;", % "`;", all	
	StringReplace, forstr, forstr, % "``t", % "`t", all
	StringReplace, forstr, forstr, % "``b", % "`b", all
	StringReplace, forstr, forstr, % "``v", % "`v", all
	StringReplace, forstr, forstr, % "``a", % "`a", all
	
	StringReplace, forstr, forstr, % """""", % """", all
	
	return forstr
}


