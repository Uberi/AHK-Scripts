;refer to the readme in the same directory as this for
;information on this file

myfalse = 0
mytrue = 1

unobfuscated_1:= "hello world, autohotkey rocks"

;first try a simple test and see how it can handle that
;the statement below will have obfuscated literal text
;in the 'OUTPUT_ahkprogram_with_hidestr.ahk' program
decoded_1:= ihidestr("hello world, autohotkey rocks")

unobfuscated_2:= "`a```t`ts`n `%`,""hello`n`tworld"""

;now i'll try one with all kinds of special characters in the
;string to give it a TORTURE TEST
;the statement below will have obfuscated literal text
;in the 'OUTPUT_ahkprogram_with_hidestr.ahk' program
decoded_2:= ihidestr("`a```t`ts`n `%`,""hello`n`tworld""")

msgbox, THESE 2 SHOULD BE THE SAME:`n`nunobfuscated_1: %unobfuscated_1%`n`ndecoded_1: %decoded_1%`n`nSPECIAL CHARACTER TORTURE TEST`nTHESE 2 SHOULD BE THE SAME:`n`nunobfuscated_2: %unobfuscated_2%`n`ndecoded_2: %decoded_2%

;return from autoexecute section 
return 

;**DO NOT REMOVE THE FOLLOWING COMMENT LINE THAT STARTS OFF ';end'**
;endautoexecute

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

;necessary to handle the ' character in obfuscated literal strings
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
