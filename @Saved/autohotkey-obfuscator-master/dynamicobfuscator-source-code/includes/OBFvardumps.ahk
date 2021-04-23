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
	
	for vartypes of 'sysfunc', 'func' , 'label', 'globvar'
	OBF_%vartype%_numrows
	OBF_%vartype%_%rownum%_name
	OBF_%vartype%_%rownum%_OBFname
	OBF_%vartype%_%rownum%_numfragrows
	OBF_%vartype%_%rownum%_fragsperrow
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_varname
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_value

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

DUMP_SECFRAGS_FORCLASSES()
{
	global ;CUR_COMMPARAMS
	
	static myoddchars = "fk@#", curoddchar, dumpsecclassvar, onesecclassvar
	
	dumpsecclassvar= 

	;break down into individual classes
	loop, parse, CUR_COMMPARAMS, `,
	{
		;remove spaces
		curclass = %a_loopfield%
		if (!curclass)
			continue
			
		if (curclass = "common") {
			dumpsecclassvar .= DUMP_SECFRAGS_FORCOMMON()
			continue
		}
		
		;class not= 'common' only!
		loop, parse, myoddchars
		{
			curoddchar = % a_loopfield
			
			onesecclassvar = % A_Tab 
				. ";SECURITY CLASS FRAG: for class: " . curclass . " for char: " . curoddchar 
				. "`r`n" . A_Tab 
				. ADD_COMMON_JUNK(CLASS_%curclass%_replace%curoddchar%_MASTvarname, "12", "23") 
				. ":=" 
				. ADD_COMMON_JUNK(REPLACE_ME_WITH_RAND_COMMON(curoddchar, "nopercents"), "12", "23") 
				. "`r`n"
			
			dumpsecclassvar .= onesecclassvar
		}
		
		onesecclassvar = % A_Tab 
			. ";SECURITY CLASS FRAG: for class: " . curclass . " for char: NULL" 
			. "`r`n" . A_Tab 
			. ADD_COMMON_JUNK(CLASS_%curclass%__NULL_MASTvarname, "12", "23") 
			. ":=" 
			. ADD_COMMON_JUNK(INSERT_RAND_COMMON_NULL("nopercents"), "12", "23") 
			. "`r`n"
				
		dumpsecclassvar .= onesecclassvar	
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpsecclassvar)
	
	return, dumpsecclassvar
}

;dump the 'security' frags ("fk@#") for the 'common' class
DUMP_SECFRAGS_FORCOMMON()
{
	global ;CUR_COMMPARAMS
	
	static myoddchars = "fk@#", curoddchar, dumpsecclassvar, onesecclassvar
	
	dumpsecclassvar= 
			
	loop, parse, myoddchars
	{
		curoddchar = % a_loopfield
		
		;DO NOT DO ANY JUNK REPLACEMENTS HERE, ONLY DO JUNK NULLS
		;PROGRAM NOT INITIALIZED ENOUGH YET
		
		addsomejunk = % ADD_COMMON_JUNK(replace%curoddchar%withOBF_MASTvarname, "34", "00")
		
		onesecclassvar = % A_Tab 
			. ";SECURITY CLASS FRAG: for class: COMMON for char: " . curoddchar 
			. "`r`n" . A_Tab 
			. addsomejunk 
			. "=" 
			. INSERT_RAND_COMMON_NULL()	. curoddchar . INSERT_RAND_COMMON_NULL() 
			. "`r`n"
		
		dumpsecclassvar .= onesecclassvar

		showsomevalues = % ""
			. "msgbox, % ""for char: " . curoddchar . " variable says: "" . "  . addsomejunk . "`r`n"
			;msgbox, % "for char:%curoddchar%" . " variable says: " . addsomejunk . "`r`n"
			
		;dumpsecclassvar .= showsomevalues
	}

	return, dumpsecclassvar
}

;dump for every class including 'common'
DUMPPOISENED_SECFRAGS_FORCLASSES()
{
	global ;CUR_COMMPARAMS
	
	static myoddchars = "fk@#0", mySWoddchars, curoddchar, dumpsecclassvar, onesecclassvar
	
	;add '0' to signify 'null'
	mySWoddchars = fk@#0
	
	;take a part of random length (len(str)-1) off of the beginning of the string and
	;move it to the end. this makes sure that they are maximum 'mixed up' with
	;no character left in its original position
	Random, movechars, 1, 4
	mySWoddchars = % substr(mySWoddchars, movechars + 1) . substr(mySWoddchars, 1, movechars)
	
	dumpsecclassvar=  
	
	loop, parse, CUR_COMMPARAMS, `,
	{
		;remove spaces
		curclass = %a_loopfield%
		if (!curclass)
			continue
			
		if (curclass = "common") {
			;dump 'poisened' not allowed for class 'common'
			dumpsecclassvar .= DUMP_SECFRAGS_FORCOMMON()
			continue
		}
					
		loop, parse, myoddchars
		{
			curoddchar = % a_loopfield
			poisenoddchar = % substr(mySWoddchars, a_index, 1)
			
			onesecclassvar = % A_Tab 
				. ";POISENED SECURITY CLASS FRAG: for class: " . curclass 
					
			;do the left side of the equals first
			;the null will be on the left side of the equals
			if (curoddchar = "0") {
				onesecclassvar .= " for char: " . "NULL" . " =poisened char: " . ((poisenoddchar)? poisenoddchar : "NULL")
					. "`r`n" . A_Tab
					. ADD_COMMON_JUNK(CLASS_%curclass%__NULL_MASTvarname, "12", "23") 
					. ":=" 
			
			} else {
				onesecclassvar .= " for char: " . curoddchar . " =poisened char: " . ((poisenoddchar)? poisenoddchar : "NULL") 
					. "`r`n" . A_Tab
					. ADD_COMMON_JUNK(CLASS_%curclass%_replace%curoddchar%_MASTvarname, "12", "23") 
					. ":=" 			
			}
			
			;do the right side of the equals
			if (poisenoddchar = "0") {
				onesecclassvar .= ADD_COMMON_JUNK(INSERT_RAND_COMMON_NULL("nopercents"), "12", "23") 
			} else {
				onesecclassvar .= ADD_COMMON_JUNK(REPLACE_ME_WITH_RAND_COMMON(poisenoddchar, "nopercents"), "12", "23")
			}
			onesecclassvar .= "`r`n"
						
			dumpsecclassvar .= onesecclassvar
		}
		
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpsecclassvar)
	
	return, dumpsecclassvar	
}

;dumps  triple mess fragments for every class including 'common'
DUMP_TMESSFRAGS_FORCLASSES()
{
	global ;CUR_COMMPARAMS
	static dumpalltripmess, curoddchar, onetripleline

	dumpalltripmess =
	
	loop, parse, CUR_COMMPARAMS, `,
	{
		curclass = %a_loopfield%
		
		;'common' is treated differently
		if (curclass = "common") {
			dumpalltripmess .= DUMP_TMESSFRAGS_FORCOMMON()	
			continue
		}
		
		;only for class not= 'common'!				
		loop, % strlen(replaceoddchars)
		{
			curoddchar = % substr(replaceoddchars, a_index, 1)
			dumpalltripmess .= ";TRIPLE MESS FRAGMENTS for class: " . curclass . " for char: " . curoddchar . "`r`n"				
			loop, % CLASS_%curclass%_numreplacements
			{
				onetripleline = % a_tab 
					. ADD_COMMON_JUNK(CLASS_%curclass%_replace%curoddchar%_%a_index%_varname, "12", "23")
					. ":="
					. ADD_JUNK_FORCLASS(REPLACE_ME_WITH_RAND_COMMON(curoddchar, "nopercents"), curclass, "00", "23", "usemastervars") 
					. "`r`n"				
				
				dumpalltripmess .= onetripleline
			}
		}
		
		;print out the nulls too for named classes
		dumpalltripmess .= ";TRIPLE MESS FRAGMENTS for class: " . curclass . " for char: NULL`r`n"
		loop, % CLASS_%curclass%_numnulls
		{
			onetripleline = % a_tab 
				. ADD_COMMON_JUNK(CLASS_%curclass%_NULL_%a_index%_varname, "12", "23")	
				. ":="
				. ADD_JUNK_FORCLASS(INSERT_RAND_COMMON_NULL("nopercents"), curclass, "00", "23", "usemastervars")
				. "`r`n"
					
			dumpalltripmess .= onetripleline
		}
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpalltripmess)
	
	return, % dumpalltripmess

}

;dumps for 'common' triple mess fragments
DUMP_TMESSFRAGS_FORCOMMON()
{
	global
	local dumpalltripmess, curoddchar, onetripleline

	dumpalltripmess =
	loop, % strlen(replaceoddchars)
	{
		curoddchar = % substr(replaceoddchars, a_index, 1)
		dumpalltripmess .= ";TRIPLE MESS FRAGMENTS FOR: " . curoddchar . "`r`n"				
		loop, % replacementsperoddchar
		{
			leftside = % ADD_COMMON_JUNK(replace%curoddchar%withOBF_%a_index%, "12", "23", "usemastervars")
			rightside = % ADD_COMMON_JUNK(replace%curoddchar%withOBF_MASTvarname, "12", "23", "usemastervars") 
			onetripleline = % a_tab 
				. leftside
				. ":="			
				. rightside
				. "`r`n"
			
			dumpalltripmess .= onetripleline
			
			showsomevalues = % ""
				. "msgbox, % ""for char:" . curoddchar . " leftside says:"" . "  . leftside . " . "" rightside says:"" . " . rightside . "`r`n"
			
			;dumpalltripmess .= showsomevalues
		}
	}
	
	return, % dumpalltripmess
	
	;template
	;replace#withOBF_1 = #
}


DUMPFRAGS_FORCLASSES()
{
	global ;CUR_COMMPARAMS
	static curclass, dumpallvars, dumponevar
	
	dumpallvars=
	loop, parse, CUR_COMMPARAMS, `,
	{		
		curclass = %a_loopfield%		
		
		dumponevar = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_FUNC", curclass)
		dumpallvars .= dumponevar
				
		dumponevar = % DUMPALL_FRAGSETS_FORVARTYPE("OBF_LABEL", curclass)
		dumpallvars .= dumponevar
	}	
	
	if (scramblefuncs) 
		scramblemylines(dumpallvars)

	return, dumpallvars
}


DUMP_REWIRE_STRAIGHT(myparams)
{
	global
	local switchfrom, switchto, switchfromfuncrow, switchtofuncrow, curfragrow, allfraglines, onefragline

	allfraglines=
	
	loop, parse, myparams, `,, %a_space%%a_tab%
	{
		switchfrom 	= % a_loopfield
		
		if (!switchfromfuncrow := FIND_VARROW("OBF_FUNC", switchfrom)) 
			return, "DUMP SWITCHED 'STRAIGHT' ERROR: switchfromfunc not found in func list`nswitchfrom: " . switchfrom
				
		allfraglines .= "`r`n;DUMPING SWITCHED 'STRAIGHT' FUNC: switchfrom: " . switchfrom  . "`r`n"
		
		loop, % OBF_FUNC_%switchfromfuncrow%_numfragrows
		{
			curfragrow = % a_index		
			
			loop, % OBF_FUNC_%switchfromfuncrow%_fragsperrow
			{			
				;the 'fromfunc' fragment variable name should be on the left side
				;of the equals sign and the right side
				
				onefragline = % ADD_COMMON_JUNK(OBF_FUNC_%switchfromfuncrow%_frag_%curfragrow%_%a_index%_varname, "12", "23")
					. "="
				onefragline .= ADD_COMMON_JUNK(OBF_FUNC_%switchfromfuncrow%_frag_%curfragrow%_%a_index%_value, "12", "23")
					. "`r`n"
					
				allfraglines .= onefragline
			}
		}
		
	}
		
	if (scramblefuncs) 
		scramblemylines(allfraglines)
	
	return, % allfraglines

}

DUMP_REWIREFUNC(myparams)
{
	global
	local switchfrom, switchto, switchfromfuncrow, switchtofuncrow, curfragrow, allfraglines, onefragline

	switchfunc_0 = 0
	;the first parameter set will be the object names
	StringSplit, switchfunc_, myparams, `,, %a_space%%a_tab%
	
	if (switchfunc_0 < 2) 
		return, "ERROR: DUMP SWITCHED FUNCS ERROR`r`n"
		
	switchfrom 	= % switchfunc_1
	switchto	= % switchfunc_2
	
	if (!switchfromfuncrow := FIND_VARROW("OBF_FUNC", switchfrom)) 
		return, "DUMP SWITCHED ERROR: switchfromfunc not found in func list`nswitchfrom: " . switchfrom . " switchto: " . switchto
		
	if (!switchtofuncrow := FIND_VARROW("OBF_FUNC", switchto)) 
		return, "DUMP SWITCHED ERROR: switchtofunc not found in func list`nswitchfrom: " . switchfrom . " switchto: " . switchto
	
	allfraglines = % "`r`n;DUMPING SWITCHED FUNCS: switchfrom: " . switchfrom . " switchto: " . switchto . "`r`n"
	
	loop, % OBF_FUNC_%switchfromfuncrow%_numfragrows
	{
		curfragrow = % a_index		
		
		loop, % OBF_FUNC_%switchfromfuncrow%_fragsperrow
		{			
			;the 'fromfunc' fragment variable name should be on the left side
			;of the equals sign
			onefragline = % ADD_COMMON_JUNK(OBF_FUNC_%switchfromfuncrow%_frag_%curfragrow%_%a_index%_varname, "12", "23")
				. "="
			;the 'tofunc' fragment variable value should be on the right side of
			;the equals
			onefragline .= ADD_COMMON_JUNK(OBF_FUNC_%switchtofuncrow%_frag_%curfragrow%_%a_index%_value, "12", "23")
				. "`r`n"
				
			allfraglines .= onefragline
		}
	}
	
	if (scramblefuncs) 
		scramblemylines(allfraglines)
	
	return, % allfraglines

}

DUMPALL_FRAGSETS_FORVARTYPE(OBFvarlistpath, forclass="")
{
	global
	static dumpallvars, dumponevar
	
	;dump all the variable name fragments for all the functions
	dumpallvars =
	loop, % %OBFvarlistpath%_numrows
	{
		
		;do not dump it here if it is a 'isswitchfunc'
		if (substr(OBFvarlistpath, 1, 8) = "OBF_FUNC" and %OBFvarlistpath%_%a_index%_isswitchfunc) {
			continue
		} 
		
		curclassname = % %OBFvarlistpath%_%a_index%_classname
		
		
		;if 'unclassed' is specified as the class, then items that 
		;have a class will be skipped
		if (forclass = "unclassed") {
			if (curclassname)
				continue

		;unsecclasses means that it has a class name but that name has
		;no 'replacements' or 'nulls' for that class and will use the
		;'common' class 'replacements' and 'null'
		} else if (forclass = "unsecclasses") {
			if (!curclassname or curclassname and (CLASS_%curclassname%_numreplacements or CLASS_%curclassname%_numnulls))
				continue
		
		;if a class is specified then items that do not have that
		;class name will be skipped
		} else if (forclass and curclassname <> forclass) {
				continue			
		}

		dumponevar = % ";" . OBFvarlistpath . " name: " . %OBFvarlistpath%_%a_index%_name . "`r`n"
		dumponevar .= DUMP_ONEVAR_FRAGSET(OBFvarlistpath . "_" . a_index, forclass)
		
		dumpallvars .= dumponevar
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpallvars)
	
	return, % dumpallvars
}


DUMPALL_FRAGSETS_FORVARTYPE_old(OBFvarlistpath, forclass="")
{
	global
	static dumpallvars, dumponevar
	
	;dump all the variable name fragments for all the functions
	dumpallvars =
	loop, % %OBFvarlistpath%_numrows
	{
		curclassname = % %OBFvarlistpath%_%a_index%_classname
		
		;if 'unclassed' is specified as the class, then items that 
		;have a class will be skipped
		if (forclass = "unclassed") {
			if (curclassname)
				continue

		;unsecclasses means that it has a class name but that name has
		;no 'replacements' or 'nulls' for that class and will use the
		;'common' class 'replacements' and 'null'
		} else if (forclass = "unsecclasses") {
			if (!curclassname or curclassname and (CLASS_%curclassname%_numreplacements or CLASS_%curclassname%_numnulls))
				continue
		
		;if a class is specified then items that do not have that
		;class name will be skipped
		} else if (forclass and curclassname <> forclass) {
				continue			
		}
		
		dumponevar = % ";" . OBFvarlistpath . " name: " . %OBFvarlistpath%_%a_index%_name . "`r`n"
		dumponevar .= DUMP_ONEVAR_FRAGSET(OBFvarlistpath . "_" . a_index, forclass)
		
		dumpallvars .= dumponevar
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpallvars)
	
	return, % dumpallvars
}

DUMP_FRAGSETS_FORA_VARLIST(varlist, forvartype)
{
	global
	static dumpallvars, dumponevar, OBFvarlistpath
	
	OBFvarlistpath = OBF_%forvartype%	
		
	;frags dump command statement template: 
	; $%fragtype%FRAGS_%fragactiontype%:
	;example: $FUNCFRAGS_Dump: (list of functions to dump frag definitions for)
	
	dumpallvars = 	
	loop, parse, varlist, `,, %a_space%%a_tab%
	{		
		if (!myvarrow := FIND_VARROW(OBFvarlistpath, a_loopfield)) {
			dumpallvars .= "#ERROR# VARIABLE NOT FOUND: %OBFvarlistpath%: %a_loopfield%`r`n"
			continue
		}
		
		dumponevar = % DUMP_ONEVAR_FRAGSET(OBFvarlistpath . "_" . myvarrow)
		
		dumpallvars .= dumponevar
	}
	return, dumpallvars
}

DUMP_ONEVAR_FRAGSET(OBFvarpath, useclass="")
{
	global
	local dumpfragsstr, onefragline
	
	if (!%OBFvarpath%_OBFname or %OBFvarpath%_OBFname = "no/obf")
		return, % ""
		
	if (%OBFvarpath%_numfragrows < 1)
		return, % ""
		
	if (useclass = "unclassed")
		useclass =
	
	issysfunc = % false
	if (substr(OBFvarpath, 1, 11) = "OBF_SYSFUNC") 
		issysfunc = % true
	
	dumpfragsstr =		
	loop, % %OBFvarpath%_numfragrows
	{
		curfragrow = % a_index			
		loop, % %OBFvarpath%_fragsperrow
		{
			curfragcol = % a_index
			;always insert 'common' junk with no class on the left side of
			;the equals when dumping frags, but insert junk stored under a
			;specific class name on the right side of the equals
			onefragline = % a_tab
				. ADD_COMMON_JUNK(%OBFvarpath%_frag_%curfragrow%_%curfragcol%_varname, "12", "23")
				. "="
			
			if (issysfunc) 
				onefragline .= hidesysfunc(%OBFvarpath%_frag_%curfragrow%_%curfragcol%_value)
			else
				onefragline .= ADD_JUNK_FORCLASS(%OBFvarpath%_frag_%curfragrow%_%curfragcol%_value, useclass, "12", "23") 
				
				
			onefragline .= "`r`n"
						
			dumpfragsstr .= onefragline
		}
	}
	
	return, % dumpfragsstr
}

hidesysfunc(sysfuncfrag)
{
	global
	local obfstr
	
	obfstr = % INSERT_RAND_COMMON_NULL() . INSERT_RAND_COMMON_NULL()
	
	Loop, Parse, sysfuncfrag
		obfstr .= a_loopfield . INSERT_RAND_COMMON_NULL()
	
	obfstr .= INSERT_RAND_COMMON_NULL()
	
	;if (strlen(obfstr) > 253)
	;	msgbox, dumping sysfuncfrags and tmess ended up greater than 253 characters - should not matter`n%obfstr%
		
	return, obfstr
}

DUMPALL_FRAGSETS_FORPARAMS()
{
	global
	
	local dumpallparams, curfuncname, dumponefunc, addtobeginning
	
	dumpallparams =
	loop, % OBF_FUNC_numrows
	{
		if (OBF_FUNC_%a_index%_PARAM_numrows > 0) {
			curfuncname = % OBF_FUNC_%a_index%_name
			
			dumponefunc = % ";PARAMETERS for function  named: " . curfuncname . "`r`n"
			dumponefunc .= DUMPALL_FRAGSETS_FORVARTYPE("OBF_FUNC_" . a_index . "_PARAM")
			
			dumpallparams .= dumponefunc
		}
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpallparams)
	
	return, % dumpallparams
}

DUMPALL_FRAGSETS_FORLOSVARS()
{
	global
	
	local dumpallLOS, curfuncname, dumponeLOS, addtobeginning
	
	dumpallLOS =
	loop, % OBF_FUNC_numrows
	{
		if (!OBF_FUNC_%a_index%_LOSVAR_numrows) 
			continue
			
		curfuncname = % OBF_FUNC_%a_index%_name		
		dumponeLOS = % ";LOS vars for function  named: " . curfuncname . "`r`n"
		dumponeLOS .= DUMPALL_FRAGSETS_FORVARTYPE("OBF_FUNC_" . a_index . "_LOSVAR")
		
		dumpallLOS .= dumponeLOS
	}
	
	if (scramblefuncs) 
		scramblemylines(dumpallLOS)
	
	return, % dumpallLOS
}

ADD_COMMON_JUNK(obfname, minmaxnulls="12", minmaxreplacements="12", usemastervars="")
{
	global
	
	return, ADD_JUNK(obfname, minmaxnulls, minmaxreplacements, "common", usemastervars)
}

ADD_JUNK_FORCLASS(obfname, forclass, minmaxnulls="12", minmaxreplacements="12", usemastervars="")
{
	global
	
	return, ADD_JUNK(obfname, minmaxnulls, minmaxreplacements, forclass, usemastervars)
}
	
;add junk from all classes including 'common', can add both nulls
;and do character 'replacements'
ADD_JUNK(obfname, minmaxnulls, minmaxreplacements, forclass="", usemastervars="")
{
	global
	
	static minnulls, maxnulls, nullstoinsert
	static minreplacements, maxreplacements, replacementstoinsert
	static curchar, uptochars, insertintome, TMESSobf, breakpoint
	static chartoreplace, myrightpart, onereplacement, onenull
	
	;insert NULLs
	minnulls = % substr(minmaxnulls, 1, 1) + 0
	maxnulls = % substr(minmaxnulls, 2, 1) + 0
	if (maxnulls)
		Random, nullstoinsert, %minnulls%, %maxnulls%
	else 
		nullstoinsert = 0
		
	;insert replacements for 'f@#k' 'replaceoddchars'
	minreplacements = % substr(minmaxreplacements, 1, 1) + 0
	maxreplacements = % substr(minmaxreplacements, 2, 1) + 0
	if (maxreplacements)
		Random, replacementstoinsert, %minreplacements%, %maxreplacements%
	else
		replacementstoinsert = 0
		
	if !(replacementstoinsert + nullstoinsert)
		return, obfname
	
	;compute my random 'consume' range
	uptochars = % strlen(obfname) // (replacementstoinsert + nullstoinsert) + 1
	if (uptochars > 8)
		uptochars = 8
		
	insertintome = % obfname
	TMESSobf=
	
	loop
	{
		;all done
		if !(replacementstoinsert + nullstoinsert)
			break
			
		;should not occur, but do to make this fail safe
		if (!insertintome or strlen(insertintome) < uptochars)
			break
			
		;break string 'insertintome' into 2 parts
		random, breakpoint, 1, % uptochars		
					
		if (replacementstoinsert and nullstoinsert) {
			;do a replacement or insert a null
			if flipcoin() 
				gosub, doareplacement
			else 
				gosub, insertanull
			
			continue
		}
		
		;do a replacement
		if (replacementstoinsert) {
			gosub, doareplacement
			continue
		}
		
		if (nullstoinsert) {
			gosub, insertanull
			continue
		}			
	}
	
	;add the final remaining part of the string on the right
	TMESSobf .= insertintome
	
	;253 characters is a limit imposed by autohotkey, if a triple messed
	;obf string is produced
	;that has a length greater than that, then the obfuscated program 
	;generated will not compile correctly, but will complain about
	;'unrecognizable command on line #'
	;i can get over the 253 limit by inserting too many extra null frags
	;or replacement frags into the string, or if the null or replacement
	;frags are individually too long or the original un triple messed obf
	;string was too long. i had to basically make all obf names from
	;12 to 24 characters, otherwise i could run over when i start adding
	;1-2 nulls plus 2-3 replacement triple messes
	
	if (strlen(TMESSobf) > 253) {
		msgbox,  
(join`s
INSIDE ADD_JUNK() OBF NAME`n
The triple messed obfuscated variable name that was generated by this progam
has exceeded the
autohotkey limit of up to 253 characters for a variable name:`n`n
%TMESSobf%

`n`nUse less null or replacement insertions or make your obf names shorter
or make your null or replacement names shorter. autohotkey will not be able
to compile or run the obfuscated code generated.
) 
	
	}
	return, TMESSobf

doareplacement:
	;add the part before the replacement
	TMESSobf .= substr(insertintome, 1, (breakpoint - 1))
	
	myrightpart = % substr(insertintome, (breakpoint + 1))
	
	;the actual character being replaced	
	chartoreplace = % substr(insertintome, breakpoint, 1)

	;do for the common class or for an actual class
	if (!forclass or forclass="common")
		if (usemastervars)
			onereplacement := REPLACE_ME_WITH_MASTER_COMMON(chartoreplace)
		else
			onereplacement := REPLACE_ME_WITH_RAND_COMMON(chartoreplace)
	else
		if (usemastervars)
			onereplacement := REPLACE_ME_WITH_MASTER_FORCLASS(chartoreplace, forclass)
		else
			onereplacement := REPLACE_ME_WITH_RAND_FORCLASS(chartoreplace, forclass)
	
	;TOO BIG OF A VARIABLE NAME HAS BEEN GENERATED, DO NOT DO THIS REPLACEMENT!
	if (strlen(TMESSobf) + strlen(onereplacement) + strlen(myrightpart) > 253) {
		TMESSobf .= chartoreplace
		replacementstoinsert = 0
		insertintome = % myrightpart		
		return
	}
	
	TMESSobf .= onereplacement
	replacementstoinsert--
	
	;set it to the part left over on the right after 
	;my insertion to prime it for the top of the loop
	insertintome = % myrightpart	
return

insertanull:
	;get the part before the null insert point
	TMESSobf .= substr(insertintome, 1, (breakpoint - 1))
	
	myrightpart = % substr(insertintome, breakpoint)
	
	;add random null

	;do for the common class or for an actual class
	if (!forclass or forclass="common")	
		onenull := INSERT_RAND_COMMON_NULL()
	else
		if (usemastervars)
			onenull := INSERT_MASTER_NULL_FORCLASS(forclass)
		else
			onenull := INSERT_RAND_NULL_FORCLASS(forclass)
	
	;TOO BIG OF A VARIABLE NAME HAS BEEN GENERATED, DO NOT DO THIS REPLACEMENT!
	if (strlen(TMESSobf) + strlen(onenull) + strlen(myrightpart) > 253) {
		nullstoinsert = 0
		insertintome = % myrightpart		
		return
	}
	
	TMESSobf .= onenull	
	nullstoinsert--
	
	;set it to the part left over on the right after 
	;my insertion to prime it for the top of the loop
	insertintome = % myrightpart
return		
}

REPLACE_ME_WITH_MASTER_COMMON(forchar, nopercents="")
{
	global
	static oddcharnum
	
	if instr(replaceoddchars, forchar) {
		if (nopercents)
			return replace%forchar%withOBF_MASTvarname
		else
			return "%" . replace%forchar%withOBF_MASTvarname . "%"
	} 
	
	;test failed, just return what was sent
	return forchar
}

REPLACE_ME_WITH_RAND_COMMON(forchar, nopercents="")
{
	global
	static oddcharnum
	
	if instr(replaceoddchars, forchar) {
		random, oddcharnum, 1, % replacementsperoddchar
		if (nopercents)
			return replace%forchar%withOBF_%oddcharnum%
		else
			return "%" . replace%forchar%withOBF_%oddcharnum% . "%"
	} 
	
	;test failed, just return what was sent
	return forchar
}

INSERT_RAND_COMMON_NULL(nopercents="")
{
	global
	static randnull
	
	random, randnull, 1, % OBF_NULL_numrows
	if (nopercents)
		return, OBF_NULL_%randnull%
	else
		return, "%" . OBF_NULL_%randnull% . "%"
}

REPLACE_ME_WITH_RAND_FORCLASS(forchar, forclass, nopercents="")
{
	global
	static oddcharrow
	
	;if the class specified has no actual replacements defined for it, then
	;just return a 'common' class replacement item
	if (!CLASS_%forclass%_numreplacements) {
		return REPLACE_ME_WITH_RAND_COMMON(forchar, nopercents) 
	}
	
	if instr(replaceoddchars, forchar) {
		random, oddcharrow, 1, % CLASS_%forclass%_numreplacements
		if (nopercents)
			return CLASS_%forclass%_replace%forchar%_%oddcharrow%_varname
		else
			return "%" . CLASS_%forclass%_replace%forchar%_%oddcharrow%_varname . "%"
	} 
	
	;test failed, just return what was sent
	return forchar	
}

REPLACE_ME_WITH_MASTER_FORCLASS(forchar, forclass, nopercents="")
{
	global
	static oddcharrow
	
	;if the class specified has no actual master replacement defined for it, 
	;then use the 'common' master replacement
	if (!CLASS_%forclass%_replace%forchar%_MASTvarname) {
		return REPLACE_ME_WITH_MASTER_COMMON(forchar, nopercents)
	}
	
	if instr(replaceoddchars, forchar) {
		if (nopercents)
			return CLASS_%forclass%_replace%forchar%_MASTvarname
		else
			return "%" . CLASS_%forclass%_replace%forchar%_MASTvarname . "%"
	} 
	
	;test failed, just return what was sent
	return forchar	
}

INSERT_RAND_NULL_FORCLASS(forclass, nopercents="")
{
	global
	static randnullrow
	
	;if the class specified has no actual null defined for it, 
	;then return a 'common'null
	if (!CLASS_%forclass%_numnulls) {
		return INSERT_RAND_COMMON_NULL(nopercents)
	}
	
	random, randnullrow, 1, % CLASS_%forclass%_numnulls
	if (nopercents)
		return, CLASS_%forclass%_NULL_%randnullrow%_varname
	else
		return, "%" . CLASS_%forclass%_NULL_%randnullrow%_varname . "%"
}

INSERT_MASTER_NULL_FORCLASS(forclass, nopercents="")
{
	global
	
	;if the class specified has no actual null defined for it, 
	;then return an empty string
	if (!CLASS_%forclass%_NULL_MASTvarname) {
		return
	}
	
	if (nopercents)
		return, CLASS_%forclass%_NULL_MASTvarname
	else
		return, "%" . CLASS_%forclass%_NULL_MASTvarname . "%"
}

scramblemylines(byref forlines)
{
	Sort, forlines, Random
}


initDUMPactiontypes()
{
	global
	
	;these will not be processed by the map function but will only be processed
	;when the source code is being parsed in order to obfuscate it
	;they will not be added to the translations map but will cause 
	;code that assigns values to variable name fragments to be inserted into
	;the obfuscated code at the place they are found in the source code
	;spin through autoexecute body looking for obf commands like dumpvars, unpackvars, 
	;  defineglobalvars, redefinevar, redefinefunc
	
	;frag statement template: $%vartype%FRAGS_%fragactiontype%:
	;example: $FUNCFRAGS_Dump: (list of functions to dump frag definitions for)
	
	numfragactiontypes = 6
	
	fragactiontype1 = DUMP
	fragactiontype2 = DUMPALL
	fragactiontype3 = UNPACK
	fragactiontype4 = UNPACKALL	
	fragactiontype5 = DUMPSWITCHED
	fragactiontype6 = UNPACKSWITCHED	
}

