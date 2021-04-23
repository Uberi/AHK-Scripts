;this is a program for testing the literal string
;obfuscator function. this program will read in an
;autohotkey script
;and look for ihidestr()'s in the autoexecute section
;of the file and then write the script to a new
;file which will then have encoded literal 

myfalse:=0
mytrue:=1

FileRead, ahkprogram, INPUT_ahkprogram_with_hidestr.ahk

;to make it easy, i'm just going to process lines up to
;the end of the autoexecute section of the input program
;i'll only replace hidestr()'s there
endauto := instr(ahkprogram, ";endautoexecute")
LOFbodylines:= substr(ahkprogram, 1, endauto - 1)

;find and replace
replaceHIDESTRcalls(LOFbodylines)

;to make it a complete program, im sticking the original end
;of the original program back on the end
newahkprogram:= LOFbodylines . substr(ahkprogram, endauto)

;write out the new program with hidestr() replacements
FileDelete, OUTPUT_ahkprogram_with_hidestr.ahk
FileAppend, % newahkprogram, OUTPUT_ahkprogram_with_hidestr.ahk

return

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
			;test first char, should be a quote
			if (SubStr(datavalue, 1, 1) <> """") {
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue			
			}
			;test last char, should be a quote
			if (SubStr(datavalue, 0) <> """") {
				newline .= lookforfunc
				StartingPos = % foundfuncat + strlen(lookforfunc)
				continue			
			}
			;everything OK
			strtoconvert = % SubStr(datavalue, 2, -1)

			;replace with call to decode function and replace
			;literal string with encoded literal string
			newline .= "decode_" . myfuncname . "(""" . encode_%myfuncname%(strtoconvert) . """)"
							
			StartingPos = % foundRparanat + 1
		}
		curline = % newline
	}

	LOFbodylines = % curline
}

;will encode any literal strings passed as parameters to ihidestr()
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

aretheyvariablechars(charbefore, charafter = "")
{
	global
	
	oddvarnameallowedchars = #@$?[]_
	
	if (charbefore) {
		if charbefore is alnum
			return, % true
		if InStr(oddvarnameallowedchars, charbefore)
			return, % true
	}
				
	if (charafter) {
		if charafter is alnum
			return, % true
		if InStr(oddvarnameallowedchars, charafter)
			return, % true
	}
		
	;if both the before and after chars are '%', evaluate as valid 
	if (charbefore = "%" and charafter = "%")
		return, % false
		
	;if one but not the other is a '%' evaluate as invalid
	if (charbefore = "%" or charafter = "%")
		return, % true
		
	;if both the before and after chars are '"', evaluate as valid 
	if (charbefore = """" and charafter = """")
		return, % false
		
	;if one but not the other is a '"' evaluate as invalid
	if (charbefore = """" or charafter = """")
		return, % true
		
	return, % false

}

