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


;---------------------------------------------
;**START PROCESS TRANSLATIONS MAP SECTION**
;---------------------------------------------

processTRANSmap(ByRef replacemap)	;$OBF_StartDefault
{
	global
	
	;zero class array if exists
	if (numclassesfound) {
		loop, % numclassesfound
		{
			mycurclass := foundclassname_%a_index%
			foundclass_%mycurclass% =
		}
	}
			
	messedupnames_recs = 0
	numalreadyused 	   = 0
	
	CLASS_numclasses	= 0
	dumpcode_numrows	= 0
	numswitchedfuncs	= 0
	
	OBF_SYSFUNC_numrows 	= 0
	OBF_FUNC_numrows 		= 0	
	OBF_LABEL_numrows 		= 0
	OBF_GUILABEL_numrows	= 0
	OBF_PARAM_numrows 		= 0
	OBF_LOSVAR_numrows 		= 0
	OBF_GLOBVAR_numrows 	= 0
	OBF_FUNCandVAR_numrows 	= 0
	OBF_NULL_numrows 		= 0
	
	SYSFUNC_time 	= 0
	FUNC_time 		= 0	
	LABEL_time 		= 0
	PARAM_time 		= 0
	LOSVAR_time 		= 0
	GLOBVAR_time 	= 0
	FUNCandVAR_time 	= 0
	changeorrestoretime = 0
	obfcreatetime = 0
	intofragstime = 0
	makeobftime = 0
	
	FormatTime, currenttime

	writetranstablemessheader()
	
	if !createsourcearray(replacemap, "replacemap") {
		write_transtablemess("*THE TRANSLATIONS COMMANDS FILE IS EMPTY*")
		write_transtablemess("*File Name: " . replacemapfile)
		return false	
	}

	While !ENDOFSOURCE("replacemap") {
		curline = %	nextsourceline("replacemap")
		if ENDOFSOURCE("replacemap")
			break
			
		if !IS_OBFTRANSCOMM(curline)  
			continue
	
		if (changedefaultnum := ischangedefaultsCOMM(CUR_OBFTRANSCOMM)) {
			timestart = % A_TickCount
			if (changeorrestoreCOMM = "change") 				
				changeOBFdefaults(changedefaultnum)
			else if (changeorrestoreCOMM = "restore")
				restoreOBFdefaults(changedefaultnum)
			changeorrestoretime += A_TickCount - timestart
			continue		
		}

		if (CUR_OBFTRANSCOMM = create_objsCLASS) {
			timestart = % A_TickCount
			create_objCLASS() 
			continue					
		}

		if (CUR_OBFTRANSCOMM = add_followingtoCLASS) {
			timestart = % A_TickCount
			add_followingtoCLASS() 
			continue					
		}
		
		if (CUR_OBFTRANSCOMM = def_SYSFUNCS) {
			timestart = % A_TickCount
			add_sysfunc_OBFentry() 
			SYSFUNC_time += A_TickCount - timestart
			continue					
		}		
		if (CUR_OBFTRANSCOMM = def_FUNCS) {
			timestart = % A_TickCount
			add_func_OBFentry() 
			FUNC_time += A_TickCount - timestart
			continue					
		}
		if (CUR_OBFTRANSCOMM = def_LABELS) {
			timestart = % A_TickCount
			add_label_OBFentry()
			label_time += A_TickCount - timestart
			continue					
		}
		
		;USED TO SPECIFY THE ORDER IN WHICH FUNCTION AND LABEL
		;CODE SECTIONS ARE TO BE DUMPED
		if (CUR_OBFTRANSCOMM = "DUMP_FUNCandLABEL_CODE") {
			add_dumpcode_entry()
			continue	
		}
		
		;used to 'rewire' functions so that they can call other functions
		;instead any time i want
		if (CUR_OBFTRANSCOMM = "DUMP_REWIREFUNCPATH") {
			add_rewirefunc_entry()
			continue	
		}
		
		;SPECIAL CASE when the gui, +Label????? is used with a gui
		if (CUR_OBFTRANSCOMM 	= "DEFGUICLOSELAB") {
			add_GUIlabel_entry()
			continue	
		}
		if (CUR_OBFTRANSCOMM = def_PARAMS) {
			timestart = % A_TickCount
			add_param_OBFentry()
			param_time += A_TickCount - timestart
			continue					
		}
		if (CUR_OBFTRANSCOMM = def_LOSVARS) {
			timestart = % A_TickCount
			add_LOSvar_OBFentry()
			LOSvar_time += A_TickCount - timestart
			continue					
		}
			
		if (CUR_OBFTRANSCOMM = def_FUNCandVARS) {
			timestart = % A_TickCount
			add_funcandvar_OBFentry()
			FUNCandvar_time += A_TickCount - timestart
			continue					
		} 
		
		if (CUR_OBFTRANSCOMM = def_GLOBVARS) {
			timestart = % A_TickCount
			add_GLOBALvar_OBFentry()
			GLOBVAR_time += A_TickCount - timestart
			continue					
		}
	}
	
	setup_switchedfuncs()
	
	createNULLSlist()
	createREPLACEMENTSlist()
	
	markFUNCANDVARwithfuncrow()

	showobfstats()
	
	close_transtablemess()	
}

add_followingtoCLASS()
{
	global
	
	;set it to null class name
	if (transCOMMparam0 < 1) {
		USE_CLASS_NAME =
		return
	}
	
	transCOMMparam1 = %transCOMMparam1%
	
	USE_CLASS_NAME = % transCOMMparam1
}

create_objCLASS()
{
	global
	static newclassname, classfoundat, newclassrow
	
	if !set_CLASSCREATE_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, CLASS name, is required ")
		return
	}	
	
	set_CLASSCREATE_params()

	loop, % obfcreate_CLASSname0
	{
		newclassname = % obfcreate_CLASSname%a_index%
		
		if (CLASS_%newclassname%) {
			write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
				. " found but CLASS NAME: " . newclassname . " already exists ")
			continue
		}			
	
		CLASS_%newclassname% = 1
		
		createCLASSNULLSlist(newclassname, obfCLASS_makenumnulls, obfCLASS_nullnameminsize, obfCLASS_nullnamemaxsize)

		createCLASSreplacementslist(newclassname, obfCLASS_replacementsperchar, obfCLASS_replacenameminsize, obfCLASS_replacenamemaxsize)
	}
	
}

createCLASSNULLSlist(forclass, makenumnulls, nullnameminsize,nullnamemaxsize)
{
	global
	
	CLASS_%forclass%__NULL_MASTvarname	
		= % randomOBFname(nullnameminsize, nullnamemaxsize)
		
	if (makenumnulls < 1) {
		CLASS_%forclass%_numnulls = 0
		return
	}
	
	loop, % makenumnulls
	{		
		CLASS_%forclass%_NULL_%a_index%_varname
			= % randomOBFname(nullnameminsize, nullnamemaxsize)
	}
	
	CLASS_%forclass%_numnulls = % makenumnulls
}

createCLASSreplacementslist(forclass, replacementsperchar, replacenameminsize, replacenamemaxsize)
{
	global
	local replaceoddchars, curoddchar
	
	replaceoddchars = % "fk@#" 
	
	if (replacementsperchar < 1) {
		CLASS_%forclass%_numreplacements = % 0
		return
	}
	
	loop, % strlen(replaceoddchars)
	{
		curoddchar = % substr(replaceoddchars, a_index, 1)
		
		CLASS_%forclass%_replace%curoddchar%_MASTvarname
			= % randomOBFname(replacenameminsize, replacenamemaxsize)
		
		loop, % replacementsperchar
		{
			CLASS_%forclass%_replace%curoddchar%_%a_index%_varname
				= % randomOBFname(replacenameminsize, replacenamemaxsize)			
		}
	}
	
	CLASS_%forclass%_numreplacements = % replacementsperchar
}


set_CLASSCREATE_names()
{
	global
	
	if (transCOMMparam0 < 1) 
		return, % false
		
	obfcreate_CLASSname0 = 0
	;the first parameter set will be the CLAS names
	StringSplit, obfcreate_CLASSname, transCOMMparam1, `,, %a_space%%a_tab%
	
	if (!obfcreate_CLASSname0)
		return, % false
		
	return, % true
}

set_CLASSCREATE_params()
{
	global
	static curproperty	
	
	;the first parameter set will be the CLASS names
	;the second set will be the optional CLASS TRIPLEMESS obfuscation parameters
	obfcreateCLASS_param0 = 0
	if (transCOMMparam0 >= 2) 
		StringSplit, obfcreateCLASS_param, transCOMMparam2, `,, %a_space%%a_tab%
			
	loop, % numdefaultCLASSprop
	{
		curproperty = % defaultCLASSprop%a_index%
		
		;if no parameter was specified in the translations command
		;then use the current 'default' one for CLASSES
		if (a_index > obfcreateCLASS_param0 or obfcreateCLASS_param%a_index% = "") {
			obfCLASS_%curproperty% = % defaultCLASS_%curproperty%
			continue		
		}
		;use the passed parameter
		obfCLASS_%curproperty% = % obfcreateCLASS_param%a_index%	
	}
}

;*********NOT NEEDED??

findclass(classname)
{
	global
	
	if (!CLASS_numclasses)
		return, % false
	
	classname = % ucase(classname)		
	loop, % CLASS_numclasses
		if (ucase(CLASS_%a_index%_name) = classname) 
			return, % a_index
	
	return, % false
}


add_sysfunc_OBFentry() 
{
	global
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, function name, is required ")
		return
	}	
	
	;'1' stands for vartype of 'SYSFUNC'
	set_obfcreate_params(1)
	
	OBFclass = % SYSFUNC_class	
	addnew_OBFentry("OBF_SYSFUNC") 
}

setup_switchedfuncs()
{
	global
	
	loop, % numswitchedfuncs
	{
		switchfrom 	= % switched_%a_index%_switchfrom
		switchto	= % switched_%a_index%_switchto
		
		if (!switchfromfuncrow := FIND_VARROW("OBF_FUNC", switchfrom)) {
			msgbox, 4096,, ERROR: switchfromfunc not found in func list`nswitchfrom: %switchfrom% switchto: %switchto%
			continue
		}
		
		if (!switchtofuncrow := FIND_VARROW("OBF_FUNC", switchto)) {
			msgbox, 4096,,  ERROR: switchtofunc not found in func list`nswitchfrom: %switchfrom% switchto: %switchto%
			continue
		}
		
		;check that they have the same class name
		if (OBF_FUNC_%switchfromfuncrow%_classname <> OBF_FUNC_%switchtofuncrow%_classname) {
			switchfromclass = % OBF_FUNC_%switchfromfuncrow%_classname
			switchtoclass = % OBF_FUNC_%switchtofuncrow%_classname
			msgbox, 4096,,  
(join`s
ERROR: switchfromfunc and switchtofunc do not have the same class name
switchfrom: %switchfrom% classname: %switchfromclass% switchto: %switchto% classname: %switchtoclass%
)
			continue
		}
		
		;check that they both have obf's and that they have 'double' level obf's
		if (!OBF_FUNC_%switchfromfuncrow%_OBFname) {
			msgbox, 4096,, ERROR: switchedfromfunc does not have OBFname`nswitchfrom: %switchfrom% switchto: %switchto%
		}
		
		if (!OBF_FUNC_%switchtofuncrow%_OBFname) {
			msgbox, 4096,, ERROR: switchedtofunc does not have OBFname`nswitchfrom: %switchfrom% switchto: %switchto%
		}
		
		;check that they have the same number of fragment rows and columns
		
		if (OBF_FUNC_%switchfromfuncrow%_numfragrows <> OBF_FUNC_%switchtofuncrow%_numfragrows) {
			msgbox, 4096,, ERROR: switchfromfunc and switchtofunc have different number of frag rows`nwitchfrom: %switchfrom% switchto: %switchto%
		}
		
		if (OBF_FUNC_%switchfromfuncrow%_fragsperrow <> OBF_FUNC_%switchtofuncrow%_fragsperrow) {
			msgbox, 4096,, ERROR: switchfromfunc and switchtofunc have different number of frags per row`nwitchfrom: %switchfrom% switchto: %switchto%
		}
		
		;PUT A FLAG ON BOTH THE SWITCHFROM AND THE SWITCHTO FUNC SO THAT
		;THEY ARE NOT DUMPED WITH THE OTHER FUNCTIONS OF THEIR CLASS OR 'UNCLASSED'
		;OR 'UNSECCLASSES'
		;ALSO THE FUNCTIONS MUST BE PREVENTED FROM BEING CALLED USING THE
		;SINGLE LEVEL 'OBFNAME' STRING OR USING SOMETHING LIKE:
		;%obfname1%straightfrag(), the straightfrag part would be the problem
		;THE ABOVE SHOULD ONLY BE CALLED LIKE THIS %obfname1%%obfname2%()
	
		OBF_FUNC_%switchfromfuncrow%_isswitchfunc = true
		OBF_FUNC_%switchtofuncrow%_isswitchfunc = true
	}

}

add_rewirefunc_entry()
{
	GLOBAL
	
	if (!set_obfcreate_names() or obfcreate_varname0 < 2) {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but less than the 2 required parameters (switchfuncfrom, switchfuncto) were found")
		return
	}

	;DO NOT DUPLICATE ENTRIES!
	if (numswitchedfuncs) { 
		loop, % numswitchedfuncs
			if (switched_%a_index%_switchfrom = obfcreate_varname1)
				return	
	}
	
	numswitchedfuncs++
	
	switched_%numswitchedfuncs%_switchfrom	= % obfcreate_varname1
	switched_%numswitchedfuncs%_switchto	= % obfcreate_varname2
}

add_func_OBFentry()
{
	GLOBAL
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, function name, is required ")
		return
	}	
	
	;'2' stands for vartype of 'FUNC'
	set_obfcreate_params(2)
	
	OBFclass = % FUNC_class
	addnew_OBFentry("OBF_FUNC") 
}

add_label_OBFentry()
{
	GLOBAL 
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, LABEL name, is required ")
		return
	}	
	
	;'3' stands for vartype of 'LABEL'
	set_obfcreate_params(3)
	
	OBFclass = % LABEL_class
	addnew_OBFentry("OBF_LABEL") 
	
}

add_GUIlabel_entry()
{
	GLOBAL 
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, GUILABEL name, is required ")
		return
	}	
	
	;'8' stands for vartype of 'LABEL'
	set_obfcreate_params(8)
	
	OBFclass = % "" ;LABEL_class
	
	if (!OBF_GUILABEL_numrows)
		OBF_GUILABEL_numrows = 0
	
	;loop thru the list of names to create
	loop, % obfcreate_varname0
	{			
		temp2 = % obfcreate_varname%a_index%
		obfcreate_varname%a_index% = %temp2%
		if (!obfcreate_varname%a_index%)
			continue
			
		guiCLOSElabel 	= % obfcreate_varname%a_index% . "Close"
		guiESCAPElabel 	= % obfcreate_varname%a_index% . "Escape"
		guilabellabel 	= % "Label" . obfcreate_varname%a_index%
		
		;check for dup definition of this guilabel var in the globvar section		
		if FIND_VARROW("OBF_GLOBVAR", guilabellabel) {
			msgbox, 4096,, % "GUILABEL def duplication: '" . obfcreate_varname%a_index% . "'"
			continue
		}
		
		;check for dup definition of this guilabel var in the label section		
		if (FIND_VARROW("OBF_LABEL", guiCLOSElabel) or FIND_VARROW("OBF_LABEL", guiESCAPElabel)) {
			msgbox, 4096,, % "GUILABEL def duplication: '" . obfcreate_varname%a_index% . "'"
			continue
		}
							
		if (obf_sizemax < obf_sizemin)
			obf_sizemax = % obf_sizemin	
			
		guilabelOBF = % randomOBFname(obf_sizemin, obf_sizemax)
		
		;CREATE NEW ROW IN 'GLOBVAR'
		newrow = % ++obf_globvar_numrows
		obf_globvar_%newrow%_name = % "Label" . obfcreate_varname%a_index%
		obf_globvar_%newrow%_OBFname = % "Label" . guilabelOBF
		;necessary hack so that the 'NEW_replaceGLOBALVARs(' function
		;will not add extra %s
		obf_globvar_%newrow%_isguilabel = % true
		obf_globvar_%newrow%_classname = % OBFclass
		obf_globvar_%newrow%_numfragrows = 0
		
		;CREATE NEW ROWS IN LABEL SECTION, ONE FOR 'CLOSE' AND ONE FOR 'ESCAPE'
		newrow = % ++obf_label_numrows
		obf_label_%newrow%_name = % obfcreate_varname%a_index% . "Close"
		obf_label_%newrow%_OBFname = % guilabelOBF . "Close"
		obf_label_%newrow%_classname = % OBFclass
		obf_label_%newrow%_numfragrows = 0
		
		newrow = % ++obf_label_numrows
		obf_label_%newrow%_name = % obfcreate_varname%a_index% . "Escape"
		obf_label_%newrow%_OBFname = % guilabelOBF . "Escape"
		obf_label_%newrow%_classname = % OBFclass
		obf_label_%newrow%_numfragrows = 0		
			
		
		write_transtablemess("`r`n#FOUND: " . CUR_OBFTRANSCOMM 
			. " Name: " . obfcreate_varname%a_index% 
			. "`r`n    Created obfuscated name: " . guilabelOBF)
	}
	
}

add_param_OBFentry()
{
	GLOBAL
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, parameter name, is required ")
		return
	}	
	
	;'4' stands for vartype of 'PARAM'
	set_obfcreate_params(4)
	
	;assume these parameters belong to the last function created
	funcnum = % OBF_FUNC_numrows
	
	OBFclass = % PARAM_class
	addnew_OBFentry("OBF_FUNC_" . funcnum . "_PARAM") 
	
}
add_LOSvar_OBFentry()
{
	GLOBAL
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, parameter name, is required ")
		return
	}	
	
	;'5' stands for vartype of 'LOS'
	set_obfcreate_params(5)
	
	;assume these parameters belong to the last function created
	funcnum = % OBF_FUNC_numrows
	
	OBFclass = % LOSvar_class
	addnew_OBFentry("OBF_FUNC_" . funcnum . "_LOSvar") 
	
}

add_dumpcode_entry()
{
	global
	local newrow
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters found, 1 parameter, 'objtype:objclass' is required")
		return
	}	
	
	dumpcode_numrows++
	newrow = % dumpcode_numrows
	
	loop, % obfcreate_varname0
	{
		dumpcode_%newrow%_%a_index% = % obfcreate_varname%a_index%
		dumpcode_%newrow%_numrows = % a_index	
	}	
	
}

add_GLOBALvar_OBFentry()
{
	global
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters, 1 parameter, global var name, is required ")
		return
	}	
	
	;'6' stands for vartype of 'globvar'
	set_obfcreate_params(6)	
	
	OBFclass = % GLOBVAR_class
	addnew_OBFentry("OBF_GLOBVAR") 
}

add_funcandvar_OBFentry()
{
	GLOBAL 
	
	if !set_obfcreate_names() {
		write_transtablemess("`r`n#ERROR: " . CUR_OBFTRANSCOMM 
			. " command found but no parameters - 1 parameter, parameter name, is required ")
		return
	}	
	
	;'6' stands for vartype of 'FUNCANDVAR'
	set_obfcreate_params(6)
	
	;assume these items belong to the last function created
	funcnum = % OBF_FUNC_numrows
	
	OBFclass = 
	;add the items to this specific function
	addnew_OBFentry("OBF_FUNC_" . funcnum . "_FUNCandVAR")
	
	;add the items to the generic funcandvar array	
	addnew_OBFentry("OBF_FUNCandVAR") 

}

addnew_OBFentry(varlistname) 
{
	global
	
	if (!%varlistname%_numrows)
		%varlistname%_numrows = 0
	
	;loop thru the list of names to create
	loop, % obfcreate_varname0
	{			
		temp2 = % obfcreate_varname%a_index%
		obfcreate_varname%a_index% = %temp2%
		if (!obfcreate_varname%a_index%)
			continue
			
		;check for dup definition of this global var
		if (varlistname = "OBF_GLOBVAR") {
			if FIND_VARROW(varlistname, obfcreate_varname%a_index%) {
				msgbox, 4096,, % "global var def duplication2: '" . obfcreate_varname%a_index% . "'"
				continue
			}		
		}			
		
		newrow = % ++%varlistname%_numrows
		%varlistname%_%newrow%_name = % obfcreate_varname%a_index%
		
		;set these values to zero for newly created function entries
		if (varlistname = "OBF_FUNC") {
			%varlistname%_%newrow%_param_numrows := 0
			%varlistname%_%newrow%_LOSvar_numrows := 0
		}
		
		;a flag used so that the first LOSvar in a function will not
		;have %'s in it
		if (substr(varlistname, -5) = "LOSvar") {
			;msgbox, hello
			%varlistname%_%newrow%_replacementsdone = 0
		}
		;set a class name marker for functions and labels
		if (varlistname = "OBF_FUNC" or varlistname = "OBF_LABEL") {
			%varlistname%_%newrow%_classname = % USE_CLASS_NAME
			;msgbox, my class name: %USE_CLASS_NAME%
		}
		
		if (varlistname = "OBF_SYSFUNC") {
			;set 'obfname' = 'name' for sysfuncs
			%varlistname%_%newrow%_OBFname = % %varlistname%_%newrow%_name
		} else {			
			if (obf_sizemax < obf_sizemin)
				obf_sizemax = % obf_sizemin
				
			;request to create unobfuscated, 'stub' entry
			if (obf_sizemin < 1 or obf_sizemax < 1) {
				%varlistname%_%newrow%_OBFname = no/obf			
				%varlistname%_%newrow%_numfragrows = 0
				continue		
			}
			%varlistname%_%newrow%_OBFname = % randomOBFname(obf_sizemin, obf_sizemax)
		}
		
		write_transtablemess("`r`n#FOUND: " . CUR_OBFTRANSCOMM 
			. " funcname: " . %varlistname%_%newrow%_name 
			. "`r`n    Created obfuscated name: " . %varlistname%_%newrow%_OBFname)
		
		if (obf_makefragsets > 0 and obf_fragsperset > 0) 
			%varlistname%_%newrow%_numfragrows = % divideintofrags(varlistname . "_" . newrow) 	
		else 
			%varlistname%_%newrow%_numfragrows = 0
				
		%varlistname%_%newrow%_addnullfrags = % obf_addnullfrags		
	}
}

createREPLACEMENTSlist()
{
	global
	
	replaceoddchars = % "fk@#" 
	
	replacementsperoddchar = 20
	replacewithOBF_replacementsperoddchar = % replacementsperoddchar
	
	loop, % strlen(replaceoddchars)
	{
		curoddchar = % substr(replaceoddchars, a_index, 1)
	
		;master 'security' variable name
		replace%curoddchar%withOBF_MASTvarname = % randomOBFname(12, 24)
		
		loop, % replacementsperoddchar
			replace%curoddchar%withOBF_%a_index% = % randomOBFname(14, 24)		
	}
	
	;template
	;replace#withOBF_MASTvarname = obfname	
	;replace#withOBF_1 = replace#withOBF_MASTvarname
	;replace#withOBF_2 = replace#withOBF_MASTvarname
	;replace#withOBF_3 = replace#withOBF_MASTvarname
	
	;replace@withOBF_MASTvarname = obfname	
	;replace@withOBF_1 = replace@withOBF_MASTvarname
	;replace@withOBF_2 = replace@withOBF_MASTvarname
	;replace@withOBF_3 = replace@withOBF_MASTvarname
}

createNULLSlist()
{
	global
	
	while OBF_NULL_numrows < 100
	{
		newrow = % ++OBF_NULL_numrows
		OBF_NULL_%newrow% = % randomOBFname(14, 24)
	}
}

randomOBFname(sizemin, sizemax)
{
	global
	
	;the underline is not used in creation of obfuscated names
	;but is included here because this variable is used in the testing of 
	;whether a substring match has allowable variable characters before or after it
	;in which case the match would be evaluated as INVALID
	oddvarnameallowedchars = #@$?[]_  
	
	;full list of autohotkey allowable chars for varnames and func names
	; # _ @ $ ? [ ]
	;"##########$$$$$$$$$$[[[[[[[[[[]]]]]]]]]]
	
makeobfstarttime = % A_TickCount
	
	static obfSTARTchars := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	static obfchars 	:= "######@@@@@@$$$$$$??????[[[[[[]]]]]]######@@@@@@$$$$$$??????[[[[[[]]]]]]ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678901234567890123456789"
	static numrandstartchars, numrandobfchars
	
	static charset1 := "fk", charset2 := "kf", charset3 := "ff", charset4 := "f@", charset5 := "k#" 
	static charset6 := "f?", charset7 := "f]", charset8 := "cu", charset9 := "cc", charset10 := "aa"
	static numcharsets = 5
		
	numrandstartchars 	= % strlen(obfSTARTchars)
	numrandobfchars 	= % strlen(obfchars)
	
	Random, makelength, % sizemin, % sizemax
	while true {
		OBFstr = 

		while strlen(OBFstr) < makelength {
			Random, randcharset, 1, % numcharsets
			OBFstr .= charset%randcharset%
		}
		
		if find_messedupname(OBFstr) {
			numalreadyused++
			continue		
		} 

		add_messedupname(OBFstr)
		messedupnames_recs++
		;messedupnames_%messedupnames_recs% = % OBFstr
makeobftime += A_TickCount - makeobfstarttime
		return, % OBFstr		
	}
}

divideintofrags(varloc) 
{
	global

	intofragsstarttime = % A_TickCount	
	
	if (!%varloc%_OBFname or  %varloc%_OBFname = "no/obf")
		return, 0
	
	%varloc%_numfragrows = 0
	%varloc%_fragsperrow = % obf_fragsperset
	
	if (obf_makefragsets < 1 or obf_fragsperset < 1) 		
		return, 0
		
	newrec = 0
	;just the case where i divide it into only one 'frag'
	if (obf_fragsperset = 1) {
		loop, % obf_makefragsets
		{
			newfragname = % randomOBFname(obf_fragvarsizemin, obf_fragvarsizemax)
			newrec++
			%varloc%_frag_%newrec%_1_varname = % newfragname
			%varloc%_frag_%newrec%_1_value 	 = % %varloc%_OBFname			
		}
		%varloc%_numfragrows = % newrec	
intofragstime += A_TickCount - intofragsstarttime		
		return, % newrec
	}
	
	OBFnamelen = % strlen(%varloc%_OBFname)
	newrec = 0
	if (obf_fragsperset = 2) {
		loop, % obf_makefragsets
		{			
			qpart = % OBFnamelen // 4
			if (!qpart)
				qpart = 1
				
			;randomly divide the full obfuscated name into 2 parts
			;so i have at least 4 characters per string
						
			Random, randdivide, % qpart, % OBFnamelen - qpart
			
			leftstr = % substr(%varloc%_OBFname, 1, randdivide)
			rightstr = % substr(%varloc%_OBFname, randdivide + 1)
			
			newfragname1 = % randomOBFname(obf_fragvarsizemin, obf_fragvarsizemax)
			newfragname2 = % randomOBFname(obf_fragvarsizemin, obf_fragvarsizemax)
			
			newrec++
			%varloc%_frag_%newrec%_1_varname = % newfragname1
			%varloc%_frag_%newrec%_1_value 	 = % leftstr
			%varloc%_frag_%newrec%_2_varname = % newfragname2
			%varloc%_frag_%newrec%_2_value 	 = % rightstr			
		}
		%varloc%_numfragrows = % newrec
intofragstime += A_TickCount - intofragsstarttime			
		return, % newrec
	}
	
	%varloc%_numfragrows = 0
	%varloc%_fragsperrow = 0

intofragstime += A_TickCount - intofragsstarttime		
	return, 0
}

set_obfcreate_names()
{
	global
	
	if (transCOMMparam0 < 1) 
		return, % false
		
	obfcreate_varname0 = 0
	;the first parameter set will be the object names
	StringSplit, obfcreate_varname, transCOMMparam1, `,, %a_space%%a_tab%
	
	if (!obfcreate_varname0)
		return, % false
		
	return, % true
}

set_obfcreate_params(vartypenum)
{
	global
	static curvartype, curproperty
	
	obfcreatestarttime = % A_TickCount
	
	;convert to something like 'SYSFUNC'
	curvartype = % vartype%vartypenum%
	
	;the first parameter set will be the object names
	;the second set will be the optional obfuscation parameters
	obfcreate_param0 = 0
	if (transCOMMparam0 >= 2) 
		StringSplit, obfcreate_param, transCOMMparam2, `,, %a_space%%a_tab%
			
	loop, % numdefaultprop
	{
		curproperty = % defaultprop%a_index%
		
		;if no parameter was specified in the translations command
		;then use the current 'default' one for that vartype
		if (a_index > obfcreate_param0 or obfcreate_param%a_index% = "") {
			obf_%curproperty% = % %curvartype%_%curproperty%
			continue		
		}
		;use the passed parameter
		obf_%curproperty% = % obfcreate_param%a_index%
	
	}
	
	obfcreatetime += A_TickCount - obfcreatestarttime
}

IS_OBFTRANSCOMM(ByRef programline)
{
	;early return test
	if (SubStr(programline, 1, 1) <> "$")
		return, % false
	
	return, % getobfTRANScomm(programline)
	
}

getobfTRANScomm(ByRef programline)
{
	global 
	local endTRANScomm, TRANScommparams
	
	transCOMMparam0 = 0
	
	if (!endTRANScomm := InStr(programline, ":", false, 2))
		return, % false
			
	CUR_OBFTRANSCOMM = % SubStr(programline, 2, (endTRANScomm - 2))	
	
	if !strlen(CUR_OBFTRANSCOMM)
		return, % false
		
	transCOMMparams = % SubStr(programline, (endTRANScomm + 1))
	
	;break into command/parameters/../
	StringSplit, transCOMMparam, TRANScommparams, /, %A_Tab%%A_Space%
	
	return, % true			
}

add_messedupname(messedupname)
{
	global
	
	if (!messedupnamelist) {
		VarSetCapacity(messedupnamelist, 2000000)
		messedupnamelist = % "`n"	
	}
	
	messedupnamelist .= messedupname . "`n"
}

find_messedupname(messedupname)
{
	global
	
	findstr = % "`n" . messedupname . "`n"
	
	if instr(messedupnamelist, findstr)
		return, true
	else
		return, false
}

markFUNCANDVARwithfuncrow()
{
	global
	local myfuncname, usefuncatrow
	
	loop, % OBF_FUNCandVAR_numrows
	{			
		myfuncname = % OBF_FUNCandVAR_%A_Index%_name
		
		;no actual translation found in func list
		if (usefuncatrow := FIND_VARROW("OBF_FUNC", myfuncname))  
			OBF_FUNCandVAR_%A_Index%_funcrow = % usefuncatrow			
		else
			OBF_FUNCandVAR_%A_Index%_funcrow = 0
		
	}
}

writetranstablemessheader()
{
	global
	local headerstr
	
	headerstr =
(

	OBFUSCATOR TRANSLATION TABLE CREATION MESSAGES FILE
	Date: %currenttime%

	#FILE IN WHICH THE TRANSLATION COMMANDS WERE FOUND:
	%replacemapfile%

)
	write_transtablemess(headerstr)
}

write_transtablemess(writethis)
{
	GLOBAL transtablemessstr
	
	;decided not to create this file!
	return
	
	if (!transtablemessstr)
		 VarSetCapacity(transtablemessstr, 160000)
		 
	transtablemessstr .=  "`r`n" . writethis
}
close_transtablemess()
{
	global

	;decided not to create this file!
	return	
	
	;messages concerning the translation table created will be written here
	transtable_messfile = % replacemapfile . "_RMESS.txt"
	
	;delete if already exists
	FileDelete, % transtable_messfile	
	FileAppend, % transtablemessstr, % transtable_messfile	
}

countparamsandLOSvars()
{
	global
	
	totalparams = 0
	totalLOSvars = 0
	loop, % OBF_FUNC_NUMROWS
	{
		if (OBF_FUNC_%a_index%_PARAM_numrows > 0)
			totalparams += OBF_FUNC_%a_index%_PARAM_numrows
		if (OBF_FUNC_%a_index%_LOSvar_numrows > 0)
			totalLOSvars += OBF_FUNC_%a_index%_LOSvar_numrows
	}
}

showclassesfound()
{
	global
	local mycurclass, numreplacements
	
	numclassesfound = 0
	unclassedfuncsfound = 0
	unclassedlabelsfound = 0
	
	;accumulate function class statistics 
	loop, % OBF_FUNC_numrows
	{
		;no class name found
		if (!mycurclass := OBF_FUNC_%a_index%_classname) {
			unclassedfuncsfound++
			continue			
		}		
		
		;found the first one for this class
		if(!foundclass_%mycurclass%) {
			foundclass_%mycurclass% = 1
			foundclass_%mycurclass%_numfuncfound = 0
			foundclass_%mycurclass%_numlabfound = 0
			numclassesfound++
			foundclassname_%numclassesfound% = % mycurclass
		} 
		
		foundclass_%mycurclass%_numfuncfound++		
	}	
		
	;accumulate label statistics 
	loop, % OBF_LABEL_numrows
	{
		;no class name found
		if (!mycurclass := OBF_LABEL_%a_index%_classname) {
			unclassedlabelsfound++
			continue
		}
		
		;found the first one for this class
		if(!foundclass_%mycurclass%) {
			foundclass_%mycurclass% = 1
			foundclass_%mycurclass%_numfuncfound = 0
			foundclass_%mycurclass%_numlabfound = 0
			numclassesfound++
			foundclassname_%numclassesfound% = % mycurclass
		} 
		
		foundclass_%mycurclass%_numlabfound++		
	}	

	foundsecclasses=
	
	;find the 'secure' classes and build a list
	loop, % numclassesfound
	{
		mycurclass = % foundclassname_%a_index%
		numnulls = % CLASS_%mycurclass%_numnulls
		numreplacements = % CLASS_%mycurclass%_numreplacements
		
		if (!numnulls and !numreplacements)
			continue
			
		foundsecclasses .= mycurclass . "`n"			
	}
	
	;sort the list
	Sort, foundsecclasses	
	
	foundclasses = **SECURED CLASSES FOUND**(funcs, labels)
	
	;print them out
	loop, parse, foundsecclasses, `n
	{
		mycurclass = % a_loopfield
		mycurclass = %mycurclass%
		if (!mycurclass)
			continue
			
		numnulls = % CLASS_%mycurclass%_numnulls
		numreplacements = % CLASS_%mycurclass%_numreplacements
		
		foundclasses .=  "`n" . mycurclass . addtabs(mycurclass) 
			. foundclass_%mycurclass%_numfuncfound 
			. ", " . foundclass_%mycurclass%_numlabfound 
			
		foundclasses .= "`n" . a_tab . "num NULLS: " . numnulls 
			. "     replacements: " . numreplacements 
	
	}
	
	foundnonsecclasses=
	
	;find the non'secure' classes and build a list
	loop, % numclassesfound
	{
		mycurclass = % foundclassname_%a_index%
		numnulls = % CLASS_%mycurclass%_numnulls
		numreplacements = % CLASS_%mycurclass%_numreplacements
		
		if (numnulls or numreplacements)
			continue
			
		foundnonsecclasses .= mycurclass . "`n"			
	}
	
	;sort the list
	Sort, foundnonsecclasses	
	
	foundclasses .= "`n`n**NON SECURED CLASSES FOUND**(funcs, labels)"		
			
	;print them out
	loop, parse, foundnonsecclasses, `n
	{
		mycurclass = % a_loopfield
		mycurclass = %mycurclass%
		if (!mycurclass)
			continue
			
		foundclasses .=  "`n" . mycurclass . addtabs(mycurclass) 
			. foundclass_%mycurclass%_numfuncfound 
			. ", " . foundclass_%mycurclass%_numlabfound 
	
	}

	foundclasses .= "`n`n**'UNCLASSED' funcs: " . unclassedfuncsfound 
	foundclasses .= "  labels: " . unclassedlabelsfound . "`n"
	
	return, foundclasses	
}

addtabs(mycurclass)
{
	if (strlen(mycurclass) > 18)
		return a_tab
		
	if (strlen(mycurclass) > 9)
		return a_tab . a_tab
		
	return a_tab . a_tab . a_tab
}
show_switched_funcs()
{
	global
	
	foundswitched= **SWITCHED FUNCS**`n
	loop, % numswitchedfuncs
	{
		foundswitched .= switched_%a_index%_switchfrom . " -> " 
			. switched_%a_index%_switchto . "`n"		
	}
	return, foundswitched
}
	
showobfstats()
{
	global
	
	countparamsandLOSvars()
	
	myshowclasses = % showclassesfound()
	myshowswitched = % show_switched_funcs()
	
	msgbox, 4096,, 
(
messedupnames_recs: %messedupnames_recs%   already used: %numalreadyused%
functions found: %OBF_FUNC_numrows%
System functions found: %OBF_SYSFUNC_numrows%
LABEL HEADERS found: %OBF_LABEL_numrows%
Total parameters found: %totalparams%
Total LOS vars found: %totalLOSvars%
total GLOBAL vars found: %OBF_GLOBVAR_numrows%
Total FUNCandVARs found: %OBF_FUNCANDVAR_numrows%
dumpcode_numrows: %dumpcode_numrows%
%myshowswitched%

%myshowclasses%
)
}
