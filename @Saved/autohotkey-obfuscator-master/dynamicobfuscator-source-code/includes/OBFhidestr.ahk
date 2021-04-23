/*
	DYNAMIC OBFUSCATOR is an obfuscator for autohotkey scripts that
	can obfuscate functions, autohotkey functions, labels,
	parameters, and variables. It can automatically use the dynamic
	variable creation features of autohotkey to create breakable
	code sections and function path rewiring.

	Copyright (C) 2011-2013  David Malia

	This program is free software: you can redistribute it and/or 
	modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of
	the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see
	<http://www.gnu.org/licenses/>.

	David Malia, 11 Cedar Ct, Augusta ME, USA
	dave@dynamicobfuscator.org
	http://davidmalia.com
	
*/


replaceHIDESTRcalls(ByRef LOFbodylines)
{
	global 
	
	curline = % LOFbodylines	
	
	lookforfunc1 = ihidestr
	;lookforfunc2 = hidestr
	;lookforfunc3 = hidestrfast
	
	numfuncs = 1
		
	loop, % numfuncs
	{
		StartingPos = 1
		newline =
		
		myfuncname := lookforfunc%a_index%		
		lookforfunc := myfuncname . "("
		
		while true {
			foundfuncat = % instr(curline, lookforfunc, false, StartingPos)
			if (!foundfuncat) {
				newline .= SubStr(curline, StartingPos)
				break
			}				
			
			;add previous part first
			newline .= SubStr(curline, StartingPos, (foundfuncat - StartingPos))
			
			prevchar = % SubStr(newline, 0)
			partialVAR_ERROR = % aretheyvariablechars(prevchar)

			if (partialVAR_ERROR) {
				;msgbox, partialfuncerror function: %lookforfunc%`r`nline: %curline%
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue
			} 
			;find next ')'
			foundRparanat = % instr(curline, ")", false, foundfuncat + strlen(lookforfunc))
			if (!foundRparanat) {
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue			
			} 
			;get value between '()'
			datavalue = % SubStr(curline, foundfuncat + strlen(lookforfunc), foundRparanat - (foundfuncat + strlen(lookforfunc)))
			datavalue = %datavalue%
			;test first char
			if (SubStr(datavalue, 1, 1) <> """") {
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue			
			}
			;test last char
			if (SubStr(datavalue, 0) <> """") {
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue			
			}
			;everything OK
			strtoconvert = % SubStr(datavalue, 2, -1)

			;replace with call with call to decode function and
			;replace literal string with encoded literal string
			newline .= "decode_" . myfuncname . "(""" . encode_%myfuncname%(strtoconvert) . """)"
							
			StartingPos = % foundRparanat + 1
		}
		curline = % newline
	}

	LOFbodylines = % curline
}

;created ihidestr for public open source project!
encode_ihidestr(startstr)
{
	global
	static onechar, newstr, secstartstr, hexdigits 
	
	hexdigits = 0123456789abcdef

	createhexshiftkeys()
		
	newstr = 
	;convert to hexidecimal
	loop, % strlen(startstr)
	{
		strascii = % asc(substr(startstr, a_index, 1))
		hinibble = % strascii // 16
		lownibble = % strascii - (hinibble * 16)
		
		;shift the hex digits in order to encrypt them
		hinibble := encode_shifthexdigit(hinibble)
		lownibble := encode_shifthexdigit(lownibble)
		
		newstr .= substr(hexdigits, hinibble + 1, 1) . substr(hexdigits, lownibble + 1, 1)
	}
	
	startstr := newstr
	;now i'll reverse the hex string
	newstr = 
	loop, % strlen(startstr) 
		newstr = % substr(startstr, a_index, 1) . newstr
	
	;convert key values to hex values. i can convert directly to
	;single hex digits because my keys only range from 1-15
	allhexkeys =
	loop, 4
		allhexkeys .=  substr(hexdigits, key%a_index% + 1, 1)
	
	;stuff the key values into the string starting at character 2
	newstr := substr(newstr, 1, 1) . allhexkeys . substr(newstr, 2)
	
	return, newstr
}

encode_shifthexdigit(hexvalue)
{
	global
	
	;each time i enter this routine i will use the next key value
	;to shift the hexvalue
	useshiftkey++
	if (useshiftkey > 4)
		useshiftkey = 1	
	
	;add the shift key to the hexvalue 
	hexvalue += key%useshiftkey%
	
	;if i go over, just substract 16 to simulate a circle of hex
	if (hexvalue > 15) 
		hexvalue -= 16
		
	return hexvalue
	
}

createhexshiftkeys()
{
	global
	
	;create random 4 entry 'encrypt' key, each entry can be 1-15
	loop, 4
		random, key%a_index%, 1, 15
		
	useshiftkey = 0
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


