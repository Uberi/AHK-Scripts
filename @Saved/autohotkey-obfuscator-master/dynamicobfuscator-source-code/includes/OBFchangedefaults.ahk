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


ischangedefaultsCOMM(obfCOMM)
{
	global
	static legalchangeCOMM, legalrestoreCOMM
	
	;the template for the change and restore commands as found in the original
	;source code or translations map will be:
	;%vartype%S_CHANGE_DEFAULTS
	;%vartype%S_RESTORE_DEFAULTS
	
	loop, % numvartypes
	{
		legalchangeCOMM = % vartype%a_index% . "S_CHANGE_DEFAULTS"
		if (obfCOMM = legalchangeCOMM) {
			changeorrestoreCOMM = change
			return, % a_index		
		}		
		
		legalrestoreCOMM = % vartype%a_index% . "S_RESTORE_DEFAULTS"
		if (obfCOMM = legalrestoreCOMM) {
			changeorrestoreCOMM = restore
			return, % a_index		
		}		
	}
	return, % false
}

changeOBFdefaults(defaultsnum)
{
	global
	static curvartype, curproperty
	
	saveOBFdefaults(defaultsnum)
	
	;convert to something like 'SYSFUNC'
	curvartype = % vartype%defaultsnum%
	
	;the first parameter set Will be the CHANGE obfuscation parameters
	
	obfcreate_param0 = 0
	if (transCOMMparam0 >= 1) 
		StringSplit, obfCHANGE_param, transCOMMparam1, `,, %a_space%%a_tab%	
			
	loop, % numdefaultprop
	{
		;if no parameter was specified in the CHANGE command
		;then do not change the  current 'default' one
		if (a_index > obfCHANGE_param0 or obfCHANGE_param%a_index% = "") 
			continue		
				
		curproperty = % defaultprop%a_index%
		;use the passed parameter
		%curvartype%_%curproperty% = % obfCHANGE_param%a_index%	
	}
}


restoreOBFdefaults(defaultsnum)
{
	global	
	static vartype
	
	vartype = % vartype%defaultsnum%
	
	%vartype%_sizemin 		 = % saved_%vartype%_sizemin
	%vartype%_sizemax 		 = % saved_%vartype%_sizemax 
	%vartype%_makefragsets 	 = % saved_%vartype%_makefragsets
	%vartype%_fragsperset 	 = % saved_%vartype%_fragsperset 
	%vartype%_fragvarsizemin = % saved_%vartype%_fragvarsizemin
	%vartype%_fragvarsizemin = % saved_%vartype%_fragvarsizemin
	%vartype%_addnullfrags 	 = % saved_%vartype%_addnullfrags 
}

restoreall_OBFdefaults()
{
	global	
	
	loop, % numvartypes
		restoreOBFdefaults(a_index)
}
saveOBFdefaults(defaultsnum)
{
	global	
	static vartype
	
	vartype = % vartype%defaultsnum%	
		
	saved_%vartype%_sizemin 		= % %vartype%_sizemin
	saved_%vartype%_sizemax 		= % %vartype%_sizemax
	saved_%vartype%_makefragsets 	= % %vartype%_makefragsets
	saved_%vartype%_fragsperset		= % %vartype%_fragsperset
	saved_%vartype%_fragvarsizemin 	= % %vartype%_fragvarsizemin
	saved_%vartype%_fragvarsizemin 	= % %vartype%_fragvarsizemin
	saved_%vartype%_addnullfrags 	= % %vartype%_addnullfrags
}

init_changedefaultsCOMMs()
{
	global
	
	;these are the definitions neccesary in order to decode obfuscater commands
	;to _CHANGE_DEFAULTS or _RESTORE_DEFAULTS for a specific vartype
	
	;the template for the change and restore commands as found in the original
	;source code or translations map will be:
	;%vartype%S_CHANGE_DEFAULTS
	;%vartype%S_RESTORE_DEFAULTS
	
	restoreallCOM 	= RESTOREALL_DEFAULTS
	
	def_SYSFUNCS	= DEFSYSFUNCS
	def_FUNCS		= DEFFUNCS
	def_LABELS		= DEFLABELS
	def_PARAMS		= DEFPARAMS
	def_LOSVARS 	= DEFLOSVARS
	def_GLOBVARS	= DEFGLOBVARS
		
	def_FUNCandVARS = DEFFUNCANDVARS	
	
	;create_funcsCLASS 	= CREATEFUNCSCLASS
	
	create_objsCLASS	= CREATEOBJCLASS
	
	add_funcstoCLASS	= ADDFUNCSTOCLASS
	
	add_followingtoCLASS = ADDFOLLOWING_TOCLASS
}

initOBFdefaults()
{
	global

	defaultprop1 = sizemin
	defaultprop2 = sizemax
	defaultprop3 = makefragsets
	defaultprop4 = fragsperset
	defaultprop5 = fragvarsizemin
	defaultprop6 = fragvarsizemax	
	defaultprop7 = addnullfrags
	
	numdefaultprop = 7
	
	;definition of initial defaults
	
	sysfunc_sizemin 		= 12
	sysfunc_sizemax 		= 16
	sysfunc_makefragsets	= 4
	sysfunc_fragsperset		= 2	
	sysfunc_fragvarsizemin  = 12
	sysfunc_fragvarsizemax	= 16
	sysfunc_addnullfrags 	= 1
	
	func_sizemin 		= 12
	func_sizemax 		= 16
	func_makefragsets	= 2
	func_fragsperset	= 1	
	func_fragvarsizemin = 12
	func_fragvarsizemax	= 16
	func_addnullfrags 	= 1
	
	label_sizemin		 = 22
	label_sizemax		 = 42
	label_makefragsets	 = 2
	label_fragsperset	 = 1	
	label_fragvarsizemin = 22
	label_fragvarsizemax = 35
	label_addnullfrags	 = 1
	
	param_sizemin		 = 12
	param_sizemax		 = 16
	param_makefragsets	 = 2
	param_fragsperset	 = 1	
	param_fragvarsizemin = 14
	param_fragvarsizemax = 26
	param_addnullfrags	 = 1	
	
	LOSvar_sizemin		  = 12
	LOSvar_sizemax		  = 22
	LOSvar_makefragsets	  = 2
	LOSvar_fragsperset	  = 1	
	LOSvar_fragvarsizemin = 14
	LOSvar_fragvarsizemax = 28
	LOSvar_addnullfrags	  = 1
	
	GLOBvar_sizemin		   = 12
	GLOBvar_sizemax		   = 18
	GLOBvar_makefragsets   = 3
	GLOBvar_fragsperset    = 1
	GLOBvar_fragvarsizemin = 12
	GLOBvar_fragvarsizemax = 15
	GLOBvar_addnullfrags   = 1
	
	FUNCandVAR_sizemin		  = -1
	FUNCandVAR_sizemax		  = -1
	FUNCandVAR_makefragsets   = -1
	FUNCandVAR_fragsperset    = 2
	FUNCandVAR_fragvarsizemin = 14
	FUNCandVAR_fragvarsizemax = 20
	FUNCandVAR_addnullfrags   = 1
	
	guilabel_sizemin		 = 16
	guilabel_sizemax		 = 26
	guilabel_makefragsets	 = -1
	guilabel_fragsperset	 = 1	
	guilabel_fragvarsizemin = 12
	guilabel_fragvarsizemax = 15
	guilabel_addnullfrags	 = 1
	
	;CREATION OF CLASSES FOR FUNCTIONS
	;these are the 'start' defaults
	defaultCLASS_makenumnulls			= 40
	defaultCLASS_nullnameminsize		= 14
	defaultCLASS_nullnamemaxsize		= 26
	defaultCLASS_replacementsperchar	= 10
	defaultCLASS_replacenameminsize		= 14
	defaultCLASS_replacenamemaxsize		= 26
	
	defaultCLASSprop1 = makenumnulls
	defaultCLASSprop2 = nullnameminsize
	defaultCLASSprop3 = nullnamemaxsize
	defaultCLASSprop4 = replacementsperchar	
	defaultCLASSprop5 = replacenameminsize	
	defaultCLASSprop6 = replacenamemaxsize
	
	numdefaultCLASSprop = 6
}

/*

;---------------------------------------------------------------
;		PARAMETERS PASSED TO THE CLASS CREATE FUNCTION

makenumnulls
nullnameminsize
nullnamemaxsize

replacementsperchar
replacenameminsize
replacenamemaxsize

;---------------------------------------------------------------
;	VARIABLES CREATED BY THIS PROGRAM

CLASS_%classname% = 1

CLASS_%classname%_numnulls
CLASS_%classname%_NULL_MASTvarname
CLASS_%classname%_NULL_%curnullrow%_varname

CLASS_%classname%_numreplacements
CLASS_%classname%_replace%char%_MASTvarname
CLASS_%classname%_replace%char%_%curRnum%_varname
CLASS_%classname%_replace%char%_%curRnum%_value = % char

*/


/*
	for vartypes of 'func' and 'label'
	OBF_%vartype%_%rownum%_classname
	
	for vartypes of 'sysfunc', 'func' , 'label', 'globvar'
	OBF_%vartype%_numrows
	OBF_%vartype%_%rownum%_name
	OBF_%vartype%_%rownum%_OBFname
	OBF_%vartype%_%rownum%_numfragrows
	OBF_%vartype%_%rownum%_fragsperrow
	OBF_%vartype%_%rownum%_lastfragrowused
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_varname
	OBF_%vartype%_%rownum%_frag_%frow%_%fcol%_value

	for vartype of 'func' and subtype of 'param' or 'LOSvar' only
	OBF_%vartype%_%rownum%_param_numrows
	OBF_%vartype%_%rownum%_param_%prow%_name
	OBF_%vartype%_%rownum%_param_%prow%_OBFname
	OBF_%vartype%_%rownum%_param_%prow%_numfragrows
	OBF_%vartype%_%rownum%_param_%prow%_fragsperrow
	OBF_%vartype%_%rownum%_param_%prow%_lastfragrowused
	OBF_%vartype%_%rownum%_param_%prow%_frag_%frow%_%fcol%_varname 
	OBF_%vartype%_%rownum%_param_%prow%_frag_%frow%_%fcol%_value
	OBF_%vartype%_%rownum%_LOSvar_numrows
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_name
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_OBFname
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_replacementsdone
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_numfragrows
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_fragsperrow
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_lastfragrowused
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_frag_%frow%_%fcol%_varname
	OBF_%vartype%_%rownum%_LOSvar_%lrow%_frag_%frow%_%fcol%_value
	
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


