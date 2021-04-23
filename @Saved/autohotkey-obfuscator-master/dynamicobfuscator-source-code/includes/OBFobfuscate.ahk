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


/*
	**STRUCTURE OF THE OBFUSCATION REPLACEMENTS TABLE CREATED BY THIS PROGRAM**
	
	for vartypes of 'func'
	OBF_%vartype%_%rownum%_classname	
	
	for vartypes of 'sysfunc', 'func' , 'label', 'globvar'
	OBF_%vartype%_numrows ;number of objects of type vartype
	OBF_%vartype%_%rownum%_name ;original object name
	OBF_%vartype%_%rownum%_OBFname ;'straight obfustication value'
	OBF_%vartype%_%rownum%_numfragrows ;dynamic obfuscation rows
	OBF_%vartype%_%rownum%_fragsperrow ;dynamic obfuscation columns
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_varname ;
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_value ;

	for vartype of 'func' and subtype of 'param' or 'LOSvar' only
	OBF_%vartype%_%rownum%_param_numrows
	OBF_%vartype%_%rownum%_param_%prow%_name
	OBF_%vartype%_%rownum%_param_%prow%_OBFname
	OBF_%vartype%_%rownum%_param_%prow%_numfragrows
	OBF_%vartype%_%rownum%_param_%prow%_fragsperrow
	OBF_%vartype%_%rownum%_param_%prow%_frag_%frow%_%fcol%_varname 
	OBF_%vartype%_%rownum%_param_%prow%_frag_%frow%_%fcol%_value
	OBF_%vartype%_%rownum%_LOSvar_numrows
	OBF_%vartype%_%rownum%_LOSvar_%prow%_name
	OBF_%vartype%_%rownum%_LOSvar_%prow%_OBFname
	OBF_%vartype%_%rownum%_LOSvar_%prow%_numfragrows
	OBF_%vartype%_%rownum%_LOSvar_%prow%_fragsperrow
	OBF_%vartype%_%rownum%_LOSvar_%prow%_frag_%frow%_%fcol%_varname
	OBF_%vartype%_%rownum%_LOSvar_%prow%_frag_%frow%_%fcol%_value

	****USED FOR A SPECIAL CODING IN MY PROGRAM SPEEDY ORANGE PC SHORTCUTS***
	*   THIS CODING USES FUNCTIONS AND LOS VARIABLE NAMES THAT ARE THE SAME
	*   IGNORE REFERENCES TO THESE OBJECTS IN THIS PROGRAM
	
	for vartype of 'funcandvar' only
	OBF_%vartype%_numrows
	OBF_%vartype%_%rownum%_name
	OBF_%vartype%_%rownum%_OBFname = no/obf
	;create after obfuscation translations data object is done creation for faster lookup
	OBF_%vartype%_%rownum%_funcrow 
		
	for vartype of 'func' and subtype of 'FUNCandVAR' only
	OBF_%vartype%_%rownum%_FUNCandVAR_numrows
	OBF_%vartype%_%rownum%_FUNCandVAR_%fvrow%_name
	OBF_%vartype%_%rownum%_FUNCandVAR_%fvrow%_OBFname = no/obf
	
*/

obfuscatecode()
{
	global

	writetoOBFfilestr=
	
	initOBFdefaults()
	init_changedefaultsCOMMs()	
		
	;grab the path portion from 'myfileslistfile' and prepend to the output file name
	SplitPath, myfileslistfile,, myDir
	
	;OBFUSCATEDfile
	
	;contains replacement instructions created by the programmer
	VarSetCapacity(myTRANSCOMMS, 120000)
		 
	FileRead, myTRANSCOMMS, % myTRANSCOMMSfile
	;create replacements data object 'tree' in memory
	processTRANSmap(myTRANSCOMMS)
	
	showobfwindow()

	;createTRANSMAPmesswin()
	
	;make copyright info into a form that can survive being compiled
	;namely make it into a string assigned to a variable so it is an actual
	;program statement
	mycopyright = % write_copyright_info()
		
	writetoOBFfile(mycopyright)
		
	FileRead, fileslist, % myfileslistfile
	
	totalsourcelines = 0
	
	;after label sections and function are 'broken off'
	;this is the function name that will be called to process it
	;this can have 2 different values
	processcodesection = % "OBFcodesection"
	
	; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	Loop, parse, fileslist, `n, `r
	{
		curfilenum = %  A_Index
		;file name and the number it is in the list
		parse_onefile(A_LoopField, A_Index)
	}
	
	if (custdumporder) {
		usecustcode_dumporder()
		
	;alter the order of the function and label sections in the code
	} else if (scramblefuncs) {
		shuffleandadd_allcode()
	} else {
		dumpcompiledinfilesize_INCLUDE()
	}
	
	gui 4:default
	gui, destroy
	
	closeOBFfile()
	
	;doclasscleanup()
	
		
	;showmyprocmess("Total source code lines processed: " . totalsourcelines)

}

showobfwindow()
{
	global
	gui 4:default
	gui, destroy
	gui, margin, 20, 20	
	
	gui, font, %scl_h1font% bold
	gui, add, text, xm ym Cab7430, Obfuscating Autohotkey Script
	
	gui, font, %scl_basefont% norm
	gui, add, text, xm y+20, 
(
Please wait while your program is being obfuscated.
An 10,000 line program will take about 30 seconds.

OUTPUT FILE WILL BE:
%OBFUSCATEDfile%
)
	gui, show, , Dynamic Obfuscator

}


doclasscleanup()
{
	global
	
	local mycurclass
	msgbox, my secure classes: %foundsecclasses%
	
	loop, parse, foundsecclasses, `n
	{
		mycurclass = %a_loopfield%
		if (!mycurclass)
			continue
			
		msgbox, hello 3: %mycurclass%
		;null class list
		CLASS_%mycurclass% =
	}
}

;---------------------------------------------
;**START OBFUSCATE SECTION**
;---------------------------------------------

OBFcodesection(preLOFlines, LOFheaderline, LOFbodylines, LOFtype, LOFname)
{
	;LOCAL
	global writetoOBFfilestr, curSECTCLASS, curFUNCCALLCLASS
	global removeallwhitespace, scramblefuncs
	
	;the function name and the string within the function call
	;the obf replaces in order to 'hide strings' in the obf'ed source code
	;do not move this function
	if (LOFtype = "function" and LOFname = "ihidestr") {
		if (!removeallwhitespace)
			writetoOBFfile("`r`n;SKIPPED MOVING function: 'ihidestr()' to OBF CODE`r`n")
		return
	}
	if (LOFtype = "function" and LOFname = "hidestr") {
		if (!removeallwhitespace)
			writetoOBFfile("`r`n;SKIPPED MOVING function: 'hidestr()' to OBF CODE`r`n")
		return
	}
	if (LOFtype = "function" and LOFname = "hidestrfast") {
		if (!removeallwhitespace)
			writetoOBFfile("`r`n;SKIPPED MOVING function: 'hidestrfast()' to OBF CODE`r`n")
		return
	}		
	
	if (!rowstoproc := createsourcearray(LOFbodylines, "LOFbody")) {
		showmyprocmess("**NO PROCESSABLE LINES FOUND IN " LOFtype . ":`r`n    " . LOFheaderline)
		return
	}
	
	;it will 'shift' the opening curly brace on a function section
	;up one line if possible
	if (LOFtype = "function")  
		movecurlybracesUP(LOFheaderline, LOFbodylines, LOFname)	
	
	;take comments out of body so i can search bodies faster without having
	;to worry about comments
	strippedLOFbodylines = % removeBODYcomments(LOFbodylines)
	
	if (LOFtype = "label" or LOFtype = "hotkey") {
		if (LOFtype = "label")
			mysecttype = % "label:global"
		if (LOFtype = "hotkey")
			mysecttype = % "label:hotkey"
			
		;do not replace hotkey header with obfuscated string!
		if (LOFtype = "label")
			replaceSECTIONHEADERname("OBF_LABEL", LOFheaderline, LOFtype, LOFname)
			
		replaceNESTEDLABELheaders(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		replaceHIDESTRcalls(strippedLOFbodylines)
		
		;check body of label for calls to functions, replace with obf
		replaceFUNCCALLS("OBF_FUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		replaceFUNCCALLS("OBF_SYSFUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceLABELCALLS(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceFUNCandVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceGLOBALVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
	} else 	if (LOFtype = "function")  {
		mysecttype = % "function"
					
		;replace function header line with obf			
		replaceSECTIONHEADERname("OBF_FUNC", LOFheaderline, LOFtype, LOFname)
		
		replaceNESTEDLABELheaders(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceHIDESTRcalls(strippedLOFbodylines)
				
		;check body of functions for calls to functions, replace with obf
		replaceFUNCCALLS("OBF_FUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		replaceFUNCCALLS("OBF_SYSFUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceLABELCALLS(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replacePARAMETERS(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceLOSvars(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceFUNCandVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceGLOBALVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
					
	} else if (LOFtype = "autoexecute") {
		mysecttype = % "label:autoexecute"
		
		replaceHIDESTRcalls(strippedLOFbodylines)
		
		;check body of autoexecute for calls to functions, replace with obf, ask first
		replaceFUNCCALLS("OBF_FUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		replaceFUNCCALLS("OBF_SYSFUNC", preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceLABELCALLS(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceFUNCandVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)
		
		replaceGLOBALVARs(preLOFlines, LOFheaderline, strippedLOFbodylines, LOFtype, LOFname)

	}
	
	;put comments back in body
	LOFbodylines = % mergeBODYcomments(strippedLOFbodylines)

	;spin through body looking for obf commands like dumpvars, unpackvars, 
	findOBFcomms(preLOFlines, LOFheaderline, LOFbodylines, LOFtype, LOFname)
	
	trimbody(LOFbodylines)
	
	if (removeallwhitespace) {
		removeALLCOMMENTSandWHITESPACE(LOFbodylines)
				
		mysectstr = % LOFheaderline . "`r`n" . LOFbodylines
	} else {
		mysectstr = % preLOFlines . "`r`n"
			. ";" . ucase(LOFtype) . " ORIGINAL NAME: " . LOFname . "`r`n"
			. LOFheaderline . "`r`n"
			. LOFbodylines
	}
	
	if (scramblefuncs or custdumporder) {

		if (LOFtype = "autoexecute") {
			;safer to allways write this to file
			writetoOBFfile(mysectstr)
			
		} else if (LOFtype = "label" or LOFtype = "hotkey") {
			if (foundatrow := FIND_VARROW("OBF_LABEL", LOFname))
				savecode("OBF_LABEL_" . foundatrow, mysectstr)
			else {
				;label not found error condition, fall back to just adding it to the file
				if (LOFtype = "label")
					writetoOBFfile(";**ERROR** LOOKUP OF LABEL NOT FOUND: " . LOFname)
				writetoOBFfile(mysectstr)
			}
		} else if (LOFtype = "function") {
			if (foundatrow := FIND_VARROW("OBF_FUNC", LOFname))  {
				savecode("OBF_FUNC_" . foundatrow, mysectstr)
			} else {
				;function not found error condition, fall back to just adding it to the file
				writetoOBFfile(";**ERROR** LOOKUP OF FUNCTION NOT FOUND: " . LOFname)
				writetoOBFfile(mysectstr)
			}
		} else {
			msgbox, scramble error
			exitapp
		}	
	} else {
		writetoOBFfile(mysectstr)
	}

}

replaceSECTIONHEADERname(varlist, ByRef LOFheaderline, ByRef LOFtype, ByRef LOFname)
{
	global
	static foundatrow
	
	;not found
	if (!foundatrow := FIND_VARROW(varlist, LOFname))
		return
	
	if (!%varlist%_%foundatrow%_OBFname or %varlist%_%foundatrow%_OBFname = "no/obf")
		return
	
	;only replace with the full obfuscated name for headers like function def header
	;or label section header (label:) - it must have no '%' in what is returned	
	replacestr = % %varlist%_%foundatrow%_OBFname  
	
	;verifyreplacementwin("FUNCTION HEADER LINE", LOFheaderline, "", (LOFname . "("), (OBF_func_%foundatrow%_OBFname . "("))
	
	if (varlist = "OBF_FUNC")
		replacestr .= "("
	else if (varlist = "OBF_LABEL")
		replacestr .= ":"
	else
		return
	
	LOFheaderline = % replacestr . substr(LOFheaderline, (strlen(LOFname) + 2))
	
	return
}

replaceFUNCCALLS(funclist, ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global 
	static lookforfunc, curOBfrecnum, StartingPos, newline, foundfuncat
	
	curline = % LOFbodylines	
			
	loop, % %funclist%_numrows
	{
		if (!%funclist%_%A_Index%_OBFname or %funclist%_%A_Index%_OBFname = "no/obf")
			continue
			
		lookforfunc  = % %funclist%_%A_Index%_name . "("
		curOBfrecnum = % a_index
		StartingPos = 1
		newline =
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
			
			} else {									
				replacewithfunc = % oneofmyOBFs(funclist . "_" . curOBfrecnum)
				 
				;replacestr = %  replacewithfunc  ;verifyreplacementwin(LOFheaderline, curline, newline, lookforfunc, replacewithfunc . "(")					
				if (replacewithfunc) 
					newline .= replacewithfunc . "("
				 else
					newline .= lookforfunc
			}
				
			StartingPos = % foundfuncat + strlen(lookforfunc)							
		}
		curline = % newline					
	}
	
	LOFbodylines = % curline
}


replaceGLOBALVARs(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global
	static myfuncrow

	myfuncrow = 0	
	if (LOFtype = "function")
		myfuncrow = % FIND_VARROW("OBF_FUNC", LOFname)
		
	curline = % LOFbodylines
		
	;LOOK FOR GLOBAL VARS THAT ARE PRECEEDED BY 'V' FOR USAGE IN CONTROL VARIABLE NAMES		
		
	loop, % OBF_GLOBVAR_numrows
	{
		lookforGLOB  = % OBF_GLOBVAR_%A_Index%_name
		
		GLOB_OBFname = % OBF_GLOBVAR_%A_Index%_OBFname
		if (!GLOB_OBFname or GLOB_OBFname = "no/obf")
			continue	
		
		;check whether a variable by this name exists as a local or static
		;variable or a parameter in this function (if a function called this). 
		;skip this global var translation if it is
		if (myfuncrow) {
			if (OBF_GLOBVAR_%A_Index%_curtransfunc <> LOFname) {
				;set flags for speed
				OBF_GLOBVAR_%A_Index%_curtransfunc = % LOFname
				OBF_GLOBVAR_%A_Index%_replaceme = % true
				
				;test for local or static variable
				if FIND_VARROW("OBF_FUNC_" . myfuncrow . "_LOSVAR", lookforGLOB) 
					OBF_GLOBVAR_%A_Index%_replaceme = % false
				else if FIND_VARROW("OBF_FUNC_" . myfuncrow . "_PARAM", lookforGLOB)
					OBF_GLOBVAR_%A_Index%_replaceme = % false
			}				
		} else 
			OBF_GLOBVAR_%A_Index%_replaceme = % true
			
		if (!OBF_GLOBVAR_%A_Index%_replaceme)
			continue				
		
		GLOBrow = % a_index
		StartingPos = 1
		newline =
		while true {
			foundGLOBat = % instr(curline, lookforGLOB, false, StartingPos)
			if (!foundGLOBat) {
				newline .= SubStr(curline, StartingPos)
				break
			}				
							
			;add previous part first
			newline .= SubStr(curline, StartingPos, (foundGLOBat - StartingPos))
			
			prevchar = % SubStr(newline, 0)
			nextchar = % SubStr(curline, foundGLOBat + strlen(lookforGLOB), 1)
			partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)
			
			if (partialVAR_ERROR) {
				;check for previous char = 'v' which is the format used
				;in controls to define a variable to associate with the control
				if (prevchar = "v") {
					;backup one more character and check whether that is valid 
					;as a variable name or not
					prevprevchar = % SubStr(newline, -1, 1)
					if aretheyvariablechars(prevprevchar) {
						;dont do the translation
						newline .= lookforGLOB
					} else {
						;do the translation
						newline .= oneofmyOBFs("OBF_GLOBVAR_" . GLOBrow)
					}					
				} else {
					;msgbox, partialGLOBerror LOS: %lookforGLOB%`r`nline: %curline%
					newline .= lookforGLOB
				}
			} else {					
				;only replace with obf with no '%'s if already surrounded by '%'s
				if (prevchar = "%" and nextchar = "%")
					newline .= PUT_NULLS_AROUND(GLOB_OBFname, "nofirstlastperc")
					
				;do not replace global variables surrounded by quotes!
				else if (prevchar = """" and nextchar = """") 
					newline .= lookforGLOB
				
				;only replace with obf with no '%'s if it's a 'guilabel'
				else if (obf_globvar_%GLOBrow%_isguilabel)
					newline .= INSERT_RAND_COMMON_NULL() . GLOB_OBFname . INSERT_RAND_COMMON_NULL()
					
				;replace with triply ofuscated values
				else 
					newline .= oneofmyOBFs("OBF_GLOBVAR_" . GLOBrow)
			}
				
			StartingPos = % foundGLOBat + strlen(lookforGLOB)							
		}
		curline = % newline					
	}
	
	LOFbodylines = % curline
	
}

replaceLOSvars(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global
	
	if (!funcatrow := FIND_VARROW("OBF_FUNC", LOFname)) 
		return
		
	curbody = % LOFbodylines
	
	newbody = 
	loop, parse, curbody, `n, `r
	{
		curline = % A_Loopfield 
		trimspaces = %curline%
		;test for ';' first char
		if (substr(trimspaces, 1, 1) = ";") {
			newbody .= curline . "`r`n"
			continue
		}
		
		loop, % OBF_FUNC_%funcatrow%_LOSvar_numrows
		{			
			LOS_OBFname = % OBF_FUNC_%funcatrow%_LOSvar_%A_Index%_OBFname
			if (!LOS_OBFname or LOS_OBFname = "no/obf")
				continue
			
			LOSrow = % a_index
						
			lookforLOS  = % OBF_FUNC_%funcatrow%_LOSvar_%LOSrow%_name
			
			StartingPos = 1
			newline =
			while true {
				foundLOSat = % instr(curline, lookforLOS, false, StartingPos)
				if (!foundLOSat) {
					newline .= SubStr(curline, StartingPos)
					break
				}				
								
				;add previous part first
				newline .= SubStr(curline, StartingPos, (foundLOSat - StartingPos))
				
				prevchar = % SubStr(newline, 0)
				nextchar = % SubStr(curline, foundLOSat + strlen(lookforLOS), 1)
				partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)
				
				if (partialVAR_ERROR) {
					;msgbox, partialLOSerror LOS: %lookforLOS%`r`nline: %curline%
					newline .= lookforLOS				
				} else {
					;if it is the first replacement, replace with only the straight
					;obf with no '%'s
					replacementsdone = % OBF_FUNC_%funcatrow%_LOSvar_%LOSrow%_replacementsdone
					if (!replacementsdone or replacementsdone < 1) {
						;create first replacement done flag
						OBF_FUNC_%funcatrow%_LOSvar_%LOSrow%_replacementsdone = 1
						newline .= LOS_OBFname					
					} else {
						;only replace with obf with no '%'s if already surrounded by '%'s
						if (prevchar = "%" and nextchar = "%")
							newline .= PUT_NULLS_AROUND(LOS_OBFname, "nofirstlstperc")
						else {
							replacewithLOS = % oneofmyOBFs("OBF_FUNC_" . funcatrow . "_LOSvar_" . LOSrow)
							newline .= replacewithLOS
						}										
					}								
				}
					
				StartingPos = % foundLOSat + strlen(lookforLOS)							
			}
			curline = % newline					
		}
		newbody .= curline . "`r`n"
	}
	LOFbodylines = % newbody

}

replaceNESTEDLABELheaders(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global
	static curbody, curline, trimspaces, newline, newbody, foundatrow

	curbody = % LOFbodylines
	newbody = 
	
	loop, parse, curbody, `n, `r
	{
		curline = % A_Loopfield 
		trimspaces = %curline%
		;test for ';' first char
		if (substr(trimspaces, 1, 1) = ";") {
			newbody .= curline . "`r`n"
			continue
		}
		
		nestedLOFtype =
		nestedLOFname = 		
		if (isLOFheader(curline, nestedLOFtype, nestedLOFname, 1)) {
			;not found
			foundatrow = % FIND_VARROW("OBF_LABEL", nestedLOFname)
			if (!foundatrow or !OBF_LABEL_%foundatrow%_OBFname or OBF_LABEL_%foundatrow%_OBFname = "no/obf"){
				newbody .= curline . "`r`n"
				continue
			}
			
			;only replace with the full obfuscated name for headers like function def header
			;or label section header (label:) - it must have no '%' in what is returned	
			replacestr = % OBF_LABEL_%foundatrow%_OBFname  
			newline = % replacestr . ":" . substr(curline, strlen(nestedLOFname) + 2)
			
			;verifyreplacementwin(LOFheaderline, curline, newline, lookforfunc, replacewithfunc . "(")					
			
			newbody .= newline . "`r`n"
		} else
			newbody .= curline . "`r`n"		
	}
	
	LOFbodylines = % newbody	
}


replaceLABELCALLS(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global 
	static curbody, curline, trimspaces, newline, newbody, foundatrow, StartingPos
	static curlabelnum
	
	curline = % LOFbodylines	
			
	loop, % OBF_LABEL_numrows
	{
		if (!OBF_LABEL_%A_Index%_OBFname or OBF_LABEL_%A_Index%_OBFname = "no/obf")
			continue
		
		curlabelnum = % a_index
			
		lookforLABEL  = % OBF_LABEL_%A_Index%_name
		StartingPos = 1
		newline =
		while true {
			foundLABELat = % instr(curline, lookforLABEL, false, StartingPos)
			if (!foundLABELat) {
				newline .= SubStr(curline, StartingPos)
				break
			}				
							
			;add previous part first
			newline .= SubStr(curline, StartingPos, (foundLABELat - StartingPos))
			
			;get char before and after match				
			prevchar = % SubStr(newline, 0)
			nextchar = % SubStr(curline, foundLABELat + strlen(lookforLABEL), 1)
			
			;test for gosub label format used in controls: G%gotolabel%
			if (ucase(prevchar) = "G") {
				prevprevchar = % SubStr(newline, -1, 1)
				partialVAR_ERROR = % aretheyvariablechars(prevprevchar, nextchar)
			} else
				partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)	
			
			if (partialVAR_ERROR) {
				;msgbox, partiallabelerror label: %lookforLABEL%`r`nline: %curline%
				newline .= lookforLABEL
			} else {
				replacewithLABEL = % oneofmyOBFs("OBF_LABEL_" . curlabelnum)
				;replacestr = %  replacewithfunc  ;verifyreplacementwin(LOFheaderline, curline, newline, lookforfunc, replacewithfunc . "(")					
				if (replacewithLABEL) 
					newline .= replacewithLABEL
				 else
					newline .= lookforLABEL
			}					
			StartingPos = % foundLABELat + strlen(lookforLABEL)							
		}
		curline = % newline					
	}
		
	LOFbodylines = % curline
}


replaceFUNCandVARs(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global
	
	static curbody, curline, trimspaces, newline, newbody, StartingPos
	static FAVrow, lookforFAV, foundFAVat
	
	curline = % LOFbodylines	
		
	loop, % OBF_FUNCandVAR_numrows
	{				
		if (!usefuncatrow := OBF_FUNCandVAR_%A_Index%_funcrow)
			continue
		
		;use only full obf name, no %s
		useOBF = % OBF_FUNC_%usefuncatrow%_OBFname
		
		;no actual translation found in func list
		if (!useOBF or useOBF = "no/obf")
			continue
			
		lookforFAV  = % OBF_FUNCandVAR_%A_Index%_name
		FAVrow = % a_index
		StartingPos = 1
		newline =
		while true {
			foundFAVat = % instr(curline, lookforFAV, false, StartingPos)
			if (!foundFAVat) {
				newline .= SubStr(curline, StartingPos)
				break
			}				
							
			;add previous part first
			newline .= SubStr(curline, StartingPos, (foundFAVat - StartingPos))
			
			prevchar = % SubStr(newline, 0)
			nextchar = % SubStr(curline, foundFAVat + strlen(lookforFAV), 1)				
			partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)
			
			if (prevchar = "_" and nextchar = "_") {
				;syntax that is used to encode page name into control variable names
				newline .= INSERT_RAND_COMMON_NULL() . useOBF
			} else if (prevchar = """" and nextchar = """") {
				;syntax that is somtimes used to load a specific page
				; ie. showhelpwin("overview")
				newline .= useOBF
			} else {
				;if inside the actual functions that define the funcandvars
				;allow extra translations
				if (LOFtype = "function" and (LOFname = "getconfigwindata" or LOFname = "gethelpwindata")) {
					if (prevchar = "^" and nextchar = """") {
						;syntax that is used to refer to the corresponding
						;help or config page for the current config or help page
						newline .= useOBF
					} else if (prevchar = "^" and nextchar = "/") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF
					} else if (prevchar = "/" and nextchar = "^") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF	
					} else if (prevchar = "/" and nextchar = """") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF	
					} else if (prevchar = "/" and nextchar = "/") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF
					} else if (prevchar = "^" and nextchar = "^") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF
					} else if (prevchar = "^" and nextchar = """") {
						;syntax that is used to specify the bread crumb trail
						newline .= useOBF
					} else if (!partialVAR_ERROR) {
						;variable definitions or assignments inside property functions
						newline .= useOBF
					} else {
						;msgbox, partialFAVerror LOS: %lookforFAV%`r`nline: %curline%
						newline .= lookforFAV
					}
				} else {
					;msgbox, partialFAVerror LOS: %lookforFAV%`r`nline: %curline%
					newline .= lookforFAV						
				}						
			}									
			StartingPos = % foundFAVat + strlen(lookforFAV)							
		}
		curline = % newline					
	}
		
	LOFbodylines = % curline
}

replacePARAMETERS(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global 
	static curbody, curline, trimspaces, newline, newbody, foundFatrow, StartingPos
	
	CURLOFNAME_TRACK = % LOFname
	;find function
	if (!foundFatrow := FIND_VARROW("OBF_FUNC", LOFname))
		return
	
	curline = % LOFheaderline
	
	;find '('
	if (!foundparenat := instr(curline, "("))
		return
		
	;replace parameter usage in function header line	
	loop, % OBF_FUNC_%foundFatrow%_PARAM_numrows	
	{
		lookforparam 	= % OBF_FUNC_%foundFatrow%_PARAM_%a_index%_name
		curparamOBF 	= % OBF_FUNC_%foundFatrow%_PARAM_%a_index%_OBFname
		
		if (!curparamOBF or curparamOBF = "no/obf")
			continue
			
		newline = % SubStr(curline, 1, foundparenat)
		
		StartingPos = % foundparenat + 1
		while true {
			foundPARAMat = % instr(curline, lookforparam, false, StartingPos)
			if (!foundPARAMat) {
				newline .= SubStr(curline, StartingPos)
				break
			}				
							
			;add previous part first
			newline .= SubStr(curline, StartingPos, (foundPARAMat - StartingPos))
			
			;gets char before match
			prevchar = % SubStr(newline, 0)
			if (!prevchar) ;prevchar is required here
				partialVAR_ERROR = % true
			else {			
				;get char after match
				nextchar = % SubStr(curline, foundPARAMat + strlen(lookforparam), 1)
				partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)
			}

			if (partialVAR_ERROR) {
				;msgbox, partialVAR_ERROR label: %lookforparam%`r`nline: %curline%
				newline .= lookforparam
			} else {
				;only replace parameters in the function header line with the full
				;obf name - no '%'s
				replacestr = %  curparamOBF  ;verifyreplacementwin(LOFheaderline, curline, newline, lookforfunc, replacewithfunc . "(")					
				if (replacestr) 
					newline .= curparamOBF
				 else
					newline .= lookforparam
			}					
			StartingPos = % foundPARAMat + strlen(lookforparam)							
		}
		curline = % newline	
	}
	LOFheaderline = % curline
		
	curbody = % LOFbodylines	
	
	newbody = 
	;replace parameter usage in the function body
	loop, parse, curbody, `n, `r
	{
		curline = % A_Loopfield 
		trimspaces = %curline%
		;test for ';' first char
		if (substr(trimspaces, 1, 1) = ";") {
			newbody .= curline . "`r`n"
			continue
		}
		
		loop, % OBF_FUNC_%foundFatrow%_PARAM_numrows	
		{
			lookforparam 	= % OBF_FUNC_%foundFatrow%_PARAM_%a_index%_name
			curparamOBF 	= % OBF_FUNC_%foundFatrow%_PARAM_%a_index%_OBFname
				
			if (!curparamOBF or curparamOBF = "no/obf")
				continue
			
			curparamnum = % a_index
					
			StartingPos = 1
			newline =
			while true {
				foundPARAMat = % instr(curline, lookforparam, false, StartingPos)
				if (!foundPARAMat) {
					newline .= SubStr(curline, StartingPos)
					break
				}				
								
				;add previous part first
				newline .= SubStr(curline, StartingPos, (foundPARAMat - StartingPos))
				
				;gets char before match
				prevchar = % SubStr(newline, 0)
				;get char after match
				nextchar = % SubStr(curline, foundPARAMat + strlen(lookforparam), 1)
				
				partialVAR_ERROR = % aretheyvariablechars(prevchar, nextchar)
								
				if (partialVAR_ERROR) {
					;msgbox, partiallabelerror label: %lookforPARAM%`r`nline: %curline%
					newline .= lookforparam
				} else {
					;test for whether already surrounded by '%'s
					;if it is just replace with full obf name that has no '%'s
					if (prevchar = "%" and nextchar = "%")
						replacewithPARAM = % PUT_NULLS_AROUND(curparamOBF, "nofirstlastperc")
					else {
						;IF A PARAMETER ONLY HAS SINGLE LEVEL OBF, THEN I ASSUME
						;IT IS A 'BYREF' PARAM AND i DO NO ADD JUNK TO IT (%'S)
						;BECAUSE THAT CAN CAUSE A PROBLEM WITH USEAGE OF BYREF
						;PARAMETERS IN THE COM SECTION
						
						if (OBF_FUNC_%foundFatrow%_PARAM_%curparamnum%_numfragrows < 1)
							replacewithPARAM = % curparamOBF
						else	
							replacewithPARAM = % oneofmyOBFs("OBF_FUNC_" . foundFatrow . "_PARAM_" . curparamnum, getfullOBF)
					}
					
					if (replacewithPARAM) 
						newline .= replacewithPARAM
					 else
						newline .= lookforparam
				}					
				StartingPos = % foundPARAMat + strlen(lookforPARAM)							
			}
			curline = % newline					
		}
		newbody .= curline . "`r`n"
	}
	LOFbodylines = % newbody
}

aretheyvariablechars(charbefore, charafter = "")
{
	global
	
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

findOBFcomms(ByRef preLOFlines, ByRef LOFheaderline, ByRef LOFbodylines, LOFtype, LOFname)
{
	global
	
	newbody = 
	loop, parse, LOFbodylines, `n, `r
	{
		curline = % A_Loopfield		
		if IS_OBFCOMM(curline) {
			if (CUR_OBFCOMM = "DUMP_REWIREFUNCPATH") 
				curline = % DUMP_REWIREFUNC(CUR_COMMPARAMS)
				
			else if (CUR_OBFCOMM = "DUMP_REWIRE_STRAIGHT")
				curline = % DUMP_REWIRE_STRAIGHT(CUR_COMMPARAMS)
				
			else if (CUR_OBFCOMM = "DUMP_SECFRAGS_FORCLASSES")
				curline = % DUMP_SECFRAGS_FORCLASSES()
				
			else if (CUR_OBFCOMM = "DUMPPOISENED_SECFRAGS_FORCLASSES")
				curline = % DUMPPOISENED_SECFRAGS_FORCLASSES()	
				
			else if (CUR_OBFCOMM = "DUMP_TMESSFRAGS_FORCLASSES")
				curline = % DUMP_TMESSFRAGS_FORCLASSES()
				
			else if (CUR_OBFCOMM = "DUMPFRAGS_FORCLASSES")
				curline = % DUMPFRAGS_FORCLASSES()				
				
			else if (CUR_OBFCOMM = "FUNCFRAGS_DUMPCLASS") 
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_FUNC", CUR_COMMPARAMS)
				
			else if (CUR_OBFCOMM = "SYSFUNCFRAGS_DUMPALL") 
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_SYSFUNC")
				
			else if (CUR_OBFCOMM = "LABELFRAGS_DUMPALL") 
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_LABEL")
				
			else if (CUR_OBFCOMM = "LABELFRAGS_DUMPCLASS")
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_LABEL", CUR_COMMPARAMS)
				
			else if (CUR_OBFCOMM = "PARAMFRAGS_DUMPALL") 
				curline = % DUMPALL_FRAGSETS_FORPARAMS()
				
			else if (CUR_OBFCOMM = "LOSVARFRAGS_DUMPALL") 
				curline = % DUMPALL_FRAGSETS_FORLOSVARS()
				
			else if (CUR_OBFCOMM = "GLOBVARFRAGS_DUMPALL") 
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_GLOBVAR")

				
			else if (CUR_OBFCOMM = "TRIPLEMESSFRAGS_DUMPALL") 
				curline = % DUMP_TMESSFRAGS_FORCOMMON()
			
			else if (CUR_OBFCOMM = "FUNCFRAGS_DUMPALL")  
				curline = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_FUNC")

		}
		newbody .= curline . "`r`n"		
	}
	LOFbodylines = % newbody

}

oneofmyOBFs(currentvariable, getfullOBF = "", addtriplemess = "")
{
	global
	static usejunkclass
	
	if (!%currentvariable%_OBFname or %currentvariable%_OBFname = "no/obf")
		return, %currentvariable%_name
	
	;only use a junk class when obfuscating function or label calls	
	if (substr(currentvariable, 1, 8) = "OBF_FUNC"
			or substr(currentvariable, 1, 9) = "OBF_LABEL")
		usejunkclass = % %currentvariable%_classname
	else
		usejunkclass =
	
	
	if (getfullOBF)
		if (addtriplemess) {
			return, ADD_JUNK(%currentvariable%_OBFname, "12", "23", usejunkclass)
		} else
			return, % %currentvariable%_OBFname
	
	;this can only have a non zero value for random replacement if
	;both the '$DUMP_SECFRAGS_FORCLASSES: common'
	;and the ';$OBFUSCATOR: $DUMP_TMESSFRAGS_FORCLASSES: common'
	;have been executed in the autoexecute section before 
	;any function has been called in that section!
	
	if (%currentvariable%_numfragrows < 1) {
		newOBF = % ADD_JUNK(%currentvariable%_OBFname, "35", "00", usejunkclass)
		return, % newOBF 	
	}
	
	;make it cycle throught all available fragment sets	
	if (!%currentvariable%_lastfragrowused)
		%currentvariable%_lastfragrowused = 0
	%currentvariable%_lastfragrowused++
	if (%currentvariable%_lastfragrowused > %currentvariable%_numfragrows)
		%currentvariable%_lastfragrowused = 1
	
	if (%currentvariable%_fragsperrow = 1) {
		frow = % %currentvariable%_lastfragrowused	
		
		fragvarname = % %currentvariable%_frag_%frow%_1_varname
		fragvalue 	= % %currentvariable%_frag_%frow%_1_value

		if (ucase(substr(currentvariable, 1, 11)) = "OBF_SYSFUNC") {
			buildfragstr = % "%" . fragvarname . "%"
		} else {
			;only use 'fragvarname' if this is a function that is marked as a
			;'isswitchfunc'
			if ((substr(currentvariable, 1, 8) = "OBF_FUNC") and %currentvariable%_isswitchfunc) {
				buildfragstr = % PUT_NULLS_AROUND(fragvarname, "", usejunkclass)
						
			} else {
				if odds_5to1() {
					buildfragstr  = % ADD_JUNK(fragvalue, "23", "12", usejunkclass)
				} else
					buildfragstr = % PUT_NULLS_AROUND(fragvarname, "", usejunkclass)
			}
		}
		
		if (strlen(buildfragstr) > 253) {
			msgbox, 
(join`s
INSIDE SINGLE COLUMN OBF NAME`n
The triple messed obfuscated variable name that was generated by this progam
has exceeded the
autohotkey limit of up to 253 characters for a variable name:`n`n
%buildfragstr%

`n`nUse less null or replacement insertions or make your obf names shorter
or make your null or replacement names shorter. autohotkey will not be able
to compile or run the obfuscated code generated.
)
		}
				
		return, buildfragstr	
	}
	
	randomset = % %currentvariable%_lastfragrowused	
	
	buildfragstr =
	loop, % %currentvariable%_fragsperrow
	{
		if (ucase(substr(currentvariable, 1, 11)) = "OBF_SYSFUNC") {
			buildfragstr .= PUT_NULLS_AROUND(%currentvariable%_frag_%randomset%_%a_index%_varname)
			continue		
		}
		
		if ((ucase(substr(currentvariable, 1, 8)) = "OBF_FUNC") and %currentvariable%_isswitchfunc) {
			buildfragstr .= PUT_NULLS_AROUND(%currentvariable%_frag_%randomset%_%a_index%_varname, "", usejunkclass)
			continue
		}
		
		if (a_index = 1) {
			buildfragstr .= ADD_JUNK(%currentvariable%_frag_%randomset%_%a_index%_value, "11", "12", usejunkclass)
			continue
		}
		
		if flipcoin() { 
			buildfragstr .= ADD_JUNK(%currentvariable%_frag_%randomset%_%a_index%_value, "11", "12", usejunkclass)
		} else
			buildfragstr .= PUT_NULLS_AROUND(%currentvariable%_frag_%randomset%_%a_index%_varname, "", usejunkclass)
	}
	
	if (strlen(buildfragstr) > 253) {
		msgbox, 
(join`s
INSIDE MULTIPLE COLUMN OBF NAME`n
The triple messed obfuscated variable name that was generated by this progam
has exceeded the
autohotkey limit of up to 253 characters for a variable name:`n`n
%buildfragstr%

`n`nUse less null or replacement insertions or make your obf names shorter
or make your null or replacement names shorter. autohotkey will not be able
to compile or run the obfuscated code generated. 
)
	}
	
	return, % buildfragstr
}

PUT_NULLS_AROUND(fragvarname, nobeginlastperc="", forclass="")
{
	global
	static OBFstring
	
	;get the first NULL from the specified CLASS
	if (forclass and forclass <> "common" and CLASS_%forclass%_numnulls) {
		firstnull = % INSERT_RAND_NULL_FORCLASS(forclass)

	;OR get the first NULL from the generics list	
	} else {		
		firstnull = % INSERT_RAND_COMMON_NULL()
	}
	
	;get the second null from the generics list
	secondnull = % INSERT_RAND_COMMON_NULL()	
	
	OBFstring = % "%" . fragvarname . "%"
	
	if flipcoin() {
		;put the first null at the BEGINNING of the string
		OBFstring = % firstnull . OBFstring
	} else {
		;put the first null at the END of the string
		OBFstring = %  OBFstring . firstnull
	}
	if flipcoin() {
		;put the SECOND null at the BEGINNING of the string
		OBFstring = % secondnull . OBFstring
	} else {
		;put the SECOND null at the END of the string
		OBFstring = % OBFstring . secondnull
	}
	
	;take out the beginning and last percents. used where the original
	;variable usage already has percents around it, so this will 'normalize' it	
	
	if (nobeginlastperc) {
		;take out first '%'
		OBFstring = % substr(OBFstring, 2)
		;take out the last '%'
		OBFstring = % substr(OBFstring, 1, (strlen(OBFstring) - 1))
	}
	
	return, OBFstring
}

removeALLCOMMENTSandWHITESPACE(ByRef LOFbodylines)
{
	global
	static newbody, curline, trimspaces
	local iscontinuesect = 0
	local iscommentsect = 0
	
	newbody = 
	loop, parse, LOFbodylines, `n, `r
	{
		curline = % A_Loopfield
		
		;comment section has been opened, test for end
		if (iscommentsect) {
			;close of comment section found
			if (substr(curline, 1, 2) = "*/") {
				iscommentsect = 0
				continue
			;still waiting for end of comment section
			} else {
				continue
			}
		}
		
		;test for start of comment section
		if (substr(curline, 1, 2) = "/*") {
			iscommentsect = 1
			continue		
		}
		
		;'continuation' section has been opened, test for end
		if (iscontinuesect) {
			;close of continuation section found
			if (substr(curline, 1, 1) = ")") {
				iscontinuesect = 0
				newbody .= "`r`n" . curline
				continue
			;still waiting for end of continuation section
			} else {
				newbody .= "`r`n" . curline
				continue
			}
		}
		
		;test for start of 'continuation' section
		if (substr(curline, 1, 1) = "(") {
			iscontinuesect = 1
			newbody .= "`r`n" . curline
			continue		
		}
		
		trimspaces = %curline%
		
		;test for ';' first char
		if (!trimspaces or substr(trimspaces, 1, 1) = ";") {			
			continue
		}
		
		;test for the first instance of this concatenation
		if (newbody)
			newbody .= "`r`n" . trimspaces
		else
			newbody .= trimspaces
	}

	LOFbodylines:=newbody
}

removeBODYcomments(ByRef LOFbodylines)
{
	global
	static newbody, curline, trimspaces, commentlinenum
	
	numcommentlines = 0	
	
	newbody = 
	loop, parse, LOFbodylines, `n, `r
	{
		curline = % A_Loopfield 
		trimspaces = %curline%
		;test for ';' first char
		;comment line found, store it in array
		if (!trimspaces or substr(trimspaces, 1, 1) = ";") {			
			commentlinenum = % a_index
			if (commentlinenum < 10)
				commentlinenum = % "00" . commentlinenum
			else if (commentlinenum < 100)
				commentlinenum = % "0" . commentlinenum
			
			numcommentlines++
			;put the original line # for the body at the beginning of the line			
			commentline%numcommentlines% = % commentlinenum . curline
			continue
		}
		
		;test for the first instance of this concatenation
		if (newbody)
			newbody .= "`r`n" . curline
		else
			newbody .= curline
	}

	return, newbody

}

mergeBODYcomments(byref strippedBODY)
{
		global
	static newbody, curline, curcommentline, newbodyline
	
	curcommentline = 1
	newbodyline = 0	
	
	newbody = 
	loop, parse, strippedBODY, `n, `r
	{
		curline = % A_Loopfield 
		newbodyline++
		
		while (curcommentline <= numcommentlines and substr(commentline%curcommentline%, 1, 3) = newbodyline) {
			newbody .= substr(commentline%curcommentline%, 4) . "`r`n"
			curcommentline++
			newbodyline++			
		} 
			
		newbody .= curline . "`r`n"		
		
	}

	return, newbody

}

;had to do it this way because i have the function above set to default 'local'
;so accessing the global vars below was a problem
savecode(varpath, byref mysectstr)
{
	global
	
	%varpath%_code = % mysectstr	
}

movecurlybracesUP(ByRef LOFheaderline, ByRef LOFbodylines, LOFname)	
{
	global
	static canmoveit
	
	canmoveit = % false
	loop, parse, LOFbodylines, `n, `r
	{
		curline = %A_Loopfield%
		if (substr(curline, 1, 1) = "{") 
			canmoveit = % true
		break
	}
	if (!canmoveit)
		return
	
	;get location of closing parenthesis
	if (!foundparen := instr(LOFheaderline, ")"))
		return
	
	;check for an extra closing parenthesis, if found do not move '{'	
	if (instr(LOFheaderline, ")", false, foundparen+1)) {
		msgbox, 
(
found extra closing ')' on function header
for function: %LOFname%
complete header line:
%LOFheaderline%
MOVE OF '{' CANCELLED
)
		return		
	}
	
	;new header line with added '{'
	LOFheaderline = % substr(LOFheaderline, 1, foundparen) . " { " 
					. substr(LOFheaderline, foundparen+1)	
	
	newbody = 
	loop, parse, LOFbodylines, `n, `r
	{
		if (a_index = 1)
			continue
		
		newbody .= A_Loopfield . "`r`n"
	}
	LOFbodylines = % newbody
}


trimbody(byref LOFbodylines)
{
	global 
	
	StringSplit, curbody, LOFbodylines, `n, `r

	uselastline = % curbody0
	loop, % curbody0
	{
		lastline = % curbody0 - a_index + 1 
		
		trimme = % curbody%lastline%
		trimme = %trimme%
		;if something left
		if (trimme)
			break
			
		uselastline = % lastline
	}
	
	LOFbodylines = 
	loop, % uselastline
	{
		if (a_index > 1)
			LOFbodylines .= "`r`n"
			
		LOFbodylines .= curbody%a_index%	
	}
	
	return
}

countLOFBODYlines(byref LOFbodylines)
{	
	StringSplit, numbodylines, LOFbodylines, `n, `r
	msgbox, numbodylines: %numbodylines0%

}

shuffleandadd_allcode()	
{
	global	
	
	shuffle_numrows = 0
	addtoshufflelist("func")
	addtoshufflelist("label")
	shufflemylist(1)
	printshuffledlist()
}

usecustcode_dumporder() 
{
	global
	
	loop, % dumpcode_numrows
	{	
		curdumprow = % a_index
		
		shuffle_numrows = 0
		
		loop, % dumpcode_%curdumprow%_numrows
		{			
			oneobjclass = % dumpcode_%curdumprow%_%a_index%
			oneobjclass = %oneobjclass%
			
			;msgbox, oneobjclass: %oneobjclass%
			
			;split the string by ':'
			;the first parameter will be the object type which can be
			;'func', or 'label', or 'fandl'
			dumpcode_comm0 = 0			
			StringSplit, dumpcode_comm, oneobjclass, :, %a_space%%a_tab%
			
			if (dumpcode_comm0 < 2)
				continue
				
			if (dumpcode_comm1 = "INCLUDE" and dumpcode_comm2 = "compiledinfilesize") {
				dumpcompiledinfilesize_INCLUDE()
				continue			
			}
				
			if (dumpcode_comm1 = "func") {
				addtoshufflelist("func", dumpcode_comm2)
				continue			
			}
			
			if (dumpcode_comm1 = "label") {
				addtoshufflelist("label", dumpcode_comm2)
				continue			
			}
			
			if (dumpcode_comm1 = "fandl") {
				addtoshufflelist("func", dumpcode_comm2)
				addtoshufflelist("label", dumpcode_comm2)
				continue			
			}		
		}
	
		if (scramblefuncs)
			shufflemylist(1)
			
		printshuffledlist()
	}
	
}

dumpcompiledinfilesize_INCLUDE()
{
	;writetoOBFfile("#INCLUDE s:\includes\MYFILESIZE-autogenerated.ahk")
}

addtoshufflelist(objtype, forclass="")
{
	global
	
	loop, % OBF_%objtype%_numrows
	{
		;if i specified 'unclassed' but it has a class, then skip
		;if 'unclassed' is specified as the class, then items that 
		;have a class will be skipped
		if (forclass = "unclassed") {
			if (OBF_%objtype%_%a_index%_classname)
				continue			
		} else if (!forclass) {
		
		} else {
			;if a class is specified then items that do not have that
			;class name will be skipped
			if (OBF_%objtype%_%a_index%_classname <> forclass)
				continue
		}
		
		if (OBF_%objtype%_%a_index%_code) {
			newrow = % ++shuffle_numrows
			shuffle_%newrow%_objtype = % objtype
			shuffle_%newrow%_objrow = % a_index
		}
	}
}

shufflemylist(numpasses = 1)
{
	global

	loop, % numpasses
	{
		loop, % shuffle_numrows
		{
			curtoprow = % shuffle_numrows - a_index + 1
			if (curtoprow < 2)
				break
			
			Random, randomrow, 1, % curtoprow
			
			;switch the 'randomrow' and the current top row	
			
			;save the current top row		
			temp_objtype = % shuffle_%curtoprow%_objtype
			temp_objrow  = % shuffle_%curtoprow%_objrow
			
			;move the 'random row' to the current top row
			shuffle_%curtoprow%_objtype = % shuffle_%randomrow%_objtype
			shuffle_%curtoprow%_objrow = % shuffle_%randomrow%_objrow
			
			;move the saved current top row to the 'random row'
			shuffle_%randomrow%_objtype = % temp_objtype
			shuffle_%randomrow%_objrow = % temp_objrow
		}
	}
}

printshuffledlist()
{
	global

	if (custdumporder) 
		includedumped = % true
	else
		includedumped = % false
	randincluderange = % shuffle_numrows // 2
	
	;print them out
	loop, % shuffle_numrows
	{
		myobjtype = % shuffle_%a_index%_objtype
		myobjrow = % shuffle_%a_index%_objrow
		
		writetoOBFfile(OBF_%myobjtype%_%myobjrow%_code)
		
		if (!includedumped and a_index > randincluderange) {
			random, dumptheinclude, 1, % randincluderange
			if (dumptheinclude = 1) {
				dumpcompiledinfilesize_INCLUDE()
				includedumped = % true
			}
			randincluderange--			
		}
	}
	if (!includedumped) {
		dumpcompiledinfilesize_INCLUDE()
		includedumped = % true
	}	
}

writetoOBFfile(writethis)
{
	global 
	
	if (!writetoOBFfilestr)
		 VarSetCapacity(writetoOBFfilestr, 3000000)
		 
	writetoOBFfilestr .= writethis . "`r`n"
}
closeOBFfile()
{
	global	
	
	outputsize := strlen(writetoOBFfilestr)	
	
	msgbox, 
(
Obfuscation of your script has completed.
Your output file will now be written to.

OUTPUT FILE NAME:
%OBFUSCATEDfile%

SIZE OF OBFUSCATED SCRIPT:
%outputsize%
)
	
	;delete if already exists
	FileDelete, % OBFUSCATEDfile		
	FileAppend, % writetoOBFfilestr, % OBFUSCATEDfile	
}

;make copyright info into a form that can survive being compiled
;namely make it into a string assigned to a variable so it is an actual
;program statement
write_copyright_info()
{
	global
	
	OBFfile_startstr =
(
Date: %currenttime%

THE FOLLOWING AUTOHOTKEY SCRIPT WAS OBFUSCATED 
BY DYNAMIC OBFUSCATER FOR AUTOHOTKEY

Copyright (C) 2011-2013  David Malia
DYNAMIC OBFUSCATER is released under
the Open Source GPL License
)
	
	;find the longest line
	longest = 0
	loop, parse, OBFfile_startstr, `n, `r
		if (strlen(a_loopfield) > longest)
			longest = % strlen(a_loopfield)
	
	;add extra space 
	longest++

	spaces = % "                                                          "	
	buildstartstr =
	loop, parse, OBFfile_startstr, `n, `r
		buildstartstr .= "obf_copyright := "" " . a_loopfield . substr(spaces, 1, longest - strlen(a_loopfield)) . """`r`n"	

	return, buildstartstr 
}


verifyreplacementwin(LOFheaderline, programline, partialline, lookforfunc, replacewithfunc, CURSECTBODY="", NEWSECTBODY="")
{
	global
	
	vr_h1font 		= % "s22"
	vr_h2font 		= % "s18"
	vr_basefont 	= % "s14"
	vr_smallfont 	= % "s12"
	
	userresponse = % false
	doreplacement = % false
	
	if (vrguinum = 10) {
		vrguinum = 11
		oldvrguinum = 10
	} else {
		vrguinum = 10
		oldvrguinum = 11
	}
		
	gui, %vrguinum%:default
	gui, +Labelverifywin
	gui, margin, 20, 20
	
	gui, font, %vr_basefont%  norm
	gui, add, text, xm  y+4 Vgetspacewidth, % " "
	GuiControlGet, spacewidth, Pos, getspacewidth
	
	standcontwidth = % spacewidthW * 200
	
	gui, font, %vr_h1font% bold
	gui, add, text, xp yp, REPLACEMENT VERIFICATION WINDOW
	
	gui, font, %vr_h2font%	
	gui, add, text, xm y+10, Label or Function Header line:
	gui, font, %vr_basefont% norm
	Gui, Add, Edit, xm y+2 W%standcontwidth% readonly, % LOFheaderline
	
	gui, font, %vr_h2font%	
	gui, add, text, xm y+10, CURRENT SECTION BODY:
	gui, font, %vr_basefont% norm
	Gui, Add, Edit, xm y+2 R6 W%standcontwidth% readonly, % CURSECTBODY
	
	gui, font, %vr_h2font%	
	gui, add, text, xm y+10, NEW SECTION BODY IN CREATION:
	gui, font, %vr_basefont% norm
	Gui, Add, Edit, xm y+2 R6 W%standcontwidth% readonly, % NEWSECTBODY
	
	gui, font, %vr_h2font%
	gui, add, text, xm y+10, Full source code line:
	gui, font, %vr_basefont% norm
	gui, add, text, xm y+2, % programline
	
	gui, font, %vr_h2font%
	gui, add, text, xm y+4, REPLACE Colored?
	gui, font, %vr_basefont% norm
	gui, add, text, xm y+4, % partialline
	
	gui, add, text, x+2 yp Cred, % lookforfunc	
	
	gui, add, button, xm y+10 GreplacementOK, REPLACE With:
	gui, font, %vr_h2font%
	gui, add, text, x+10 yp+4 C009900, % replacewithfunc
	
	gui, add, button, xm y+10 GreplacementCAN, Do NOT Replace
	
	gui, add, button, xm y+20 GreplacementQUITALL, Quit all and write	
	
	
	gui, show
	
	gui, %oldvrguinum%:destroy
	
	while !userresponse 
		sleep, 120
		
	if (!doreplacement)
		return, % ""
		
	return, % replacewithfunc
	
replacementOK:
	doreplacement 	= % true
	userresponse 	= % true
return
replacementCAN:
	doreplacement 	= % false
	userresponse 	= % true
return
verifywinClose:
replacementQUITALL:
	closeOBFfile()
	exitapp
return

}


