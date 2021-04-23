;use these statements to set obfuscation to straight obfuscation!
;$OBFUSCATOR: $FUNCS_CHANGE_DEFAULTS: ,, -1
;$OBFUSCATOR: $PARAMS_CHANGE_DEFAULTS: ,, -1
;$OBFUSCATOR: $LABELS_CHANGE_DEFAULTS: ,, -1
;$OBFUSCATOR: $GLOBVARS_CHANGE_DEFAULTS: ,, -1
;$OBFUSCATOR: $LOSVARS_CHANGE_DEFAULTS: ,, -1 
  
;put a string assignment header like this in your program so that
;the program name and copyright info still shows up in the obfuscated ;version of this program
program_name:="straightobf.ahk"
program_name:="Author: David Malia, Augusta, ME"
program_name:="Copyright David Malia, 2013"

;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
mytrue = 1
myfalse = 0

;test obfuscation of function call
testfunction()

;test obfuscation of parameters
;msgbox will show 12 if obfuscation of parameters works
msgbox, % "parameter: " . test_parameters(12)

;test obfuscation of label
gosub test_label

;tests local variables, global variables, gosub label as 
;part of a 'gui, add' statement, and variables defined as associated
;with a gui control
creategui()
	 
RETURN
;put after the end of the autoexecute section
;$OBFUSCATOR: $END_AUTOEXECUTE: 

;hotkeys SHOULD NOT be obfuscated!
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

testfunction()
{
	global
	msgbox, function: testfunction has been called	
}

;will test the correct obfuscation of the parameter 'myparam'
;if successful the function will return the value it was sent
test_parameters(myparam)
{
	global
	
	myparam:=myparam + myparam - myparam	
	return "my parameter was: " . myparam	
}

test_label:
	msgbox, inside "gosublabel"
return

creategui()
{
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
	gui, add, text, xm y+12 cblue Gguigosub, test gosub obfuscation in gui statement
	
	gui, font, %basefont% norm
	gui, add, text, xm y+12 Gguigosub,
(
hello world
message in variable:
"%mymessage%"

-press home key to test hotkeys-
)
	gui, add, text, xm y+12, enter something here to test`nvariable obfuscation
;$OBFUSCATOR: $DEFGLOBVARS: usermessage
	gui, add, edit, xm y+2 Vusermessage r4, 
		
	gui, add, button, xm y+20 Gtestguisubmit, Test gui submit
	gui, show
}

testguisubmit:
	gui, submit, nohide
	msgbox, you entered "%usermessage%"
return

guigosub:
	msgbox, inside _guigosub_
return

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

