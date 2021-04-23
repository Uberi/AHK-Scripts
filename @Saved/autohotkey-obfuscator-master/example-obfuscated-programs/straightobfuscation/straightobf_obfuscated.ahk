obf_copyright := " Date: 3:39 PM Tuesday, March 19, 2013          "
obf_copyright := "                                                "
obf_copyright := " THE FOLLOWING AUTOHOTKEY SCRIPT WAS OBFUSCATED "
obf_copyright := " BY DYNAMIC OBFUSCATER FOR AUTOHOTKEY           "
obf_copyright := "                                                "
obf_copyright := " Copyright (C) 2011-2013  David Malia           "
obf_copyright := " DYNAMIC OBFUSCATER is released under           "
obf_copyright := " the Open Source GPL License                    "


;AUTOEXECUTE ORIGINAL NAME: autoexecute
;autoexecute
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
kf%kffkkffff@fkfff@kfk#f@%k%fkkfkfkfk#f@fkf@%%kfk#k#kfk#k#k#k#%f%fkk#f@kfk#kffffkk#%fk%f@fkffkfkffkk#ff%ffffffk#fkfk = 1
fkf%fff@ffkff@fffffkk#%kk#k#%kffkk#k#f@f@k#f@%f%k#kfffkffkfkffk#%ff@fkfkff = 0

;test obfuscation of function call
k#f%fffkfkkff@f@kfkfkf%@f%fkf@kff@fkf@f@%kf%ffk#k#kfk#kfffff%k%ffkffff@f@f@fkff%fff@fk()

;test obfuscation of parameters
;msgbox will show 12 if obfuscation of parameters works
msgbox, % "parameter: " . ff%k#k#fff@fkkfk#f@f@k#f@k#%f@%fkfkk#ffk#k#fffk%fk%k#k#f@kffkk#k#ffffk#kff@%k%k#f@k#f@fkk#fkf@%#%fkfkk#k#fkfkk#f@f@ffk#%fffffk(12)

;test obfuscation of label
gosub k#kf%ffffkfkfffkffkf@fk%fkkfkf%f@k#fffkk#kff@%kffk%kff@fkkffkkff@k#fffkfkk#%fff@%f@kffffff@fkfffkf@kffkff%%kff@k#f@kff@fkfkk#f@f@%kffffff@f@fkfkkf

;tests local variables, global variables, gosub label as 
;part of a 'gui, add' statement, and variables defined as associated
;with a gui control
k%kffkf@kff@f@k#f@%fk%f@f@ffffk#kffk%fk%fff@fkk#k#fkk#k#%f%k#k#kff@k#k#k#%%fkkffffkkff@k#f@k#fk%kffffk()
	 
RETURN

;hotkeys SHOULD NOT be obfuscated!
;HOTKEY ORIGINAL NAME: home
home::
	msgbox, home key pressed!
return


;HOTKEY ORIGINAL NAME: RControl & RShift
RControl & RShift::
	msgbox, hello dave
	%kfk#kff@f@fkkffk%k#f%fkfffff@kff@f@f@f@f@ff%@f%f@f@kff@fff@kffff@fff@%kf%fkfff@fkfkfkkffff@k#k#%kfff@fk()
return


;HOTKEY ORIGINAL NAME: ^;
^;::
	msgbox, hello world
	k#%fff@k#kffffffkk#kffk%%fff@kfkfkffkkfk#fkff%f@f%fffffkfff@k#k#fkffk#ff%kfkfff@fk()
return	


;FUNCTION ORIGINAL NAME: testfunction
k#f@fkfkfff@fk() { 
	global
	msgbox, function: testfunction has been called	
}

;will test the correct obfuscation of the parameter 'myparam'
;if successful the function will return the value it was sent
;FUNCTION ORIGINAL NAME: test_parameters
fff@fkk#fffffk(f@kfkfffk#ffk#) { 
	global
	
	f@kfkfffk#ffk#:=f@kfkfffk#ffk# + f@kfkfffk#ffk# - f@kfkfffk#ffk#	
	return "my parameter was: " . f@kfkfffk#ffk#	
}


;LABEL ORIGINAL NAME: test_label
k#kffkkfkfkffkfff@kffffff@f@fkfkkf:
	msgbox, inside "gosublabel"
return


;FUNCTION ORIGINAL NAME: creategui
kfkfkfkffffk() { 
;$OBFUSCATOR: $DEFLOSVARS: h1font, h2font, basefont, mymessage
	fkfkfkk#ffkf 		= % "s22"
	f@fffkf@f@k#fff@ 		= % "s18"	
	ffk#k#fkf@k#fkfkfffkfk 	= % "s14"
	fkkff@fff@fkk# := k#k#%kff@k#kfffffkfkfkfkf%ffkf%fff@fkk#k#fkk#k#%%fff@ffkff@fffffkk#%fkffkfk#("c7ad1e03ee23dd44fe73cd01a9433de3bdf33e51a9e39d340d")

	gui 2:default
	gui, destroy
	gui, margin, 20, 20
	
	;the h1font variable below should be obfuscated
	gui, font, %fkf@kff@fkf@f@%%fkfkfkk#ffkf%%fffkk#fffkkfk#f@f@ffffkf% bold
	gui, add, text, xm ym, Obfuscator Test GUI
	
	gui, font, %k#k#fff@fkkfk#f@f@k#f@k#%%kffkk#k#f@f@k#f@%%ffk#k#fkf@k#fkfkfffkfk% norm underline
	;the gosub label below should be obfuscated
	gui, add, text, xm y+12 cblue Gf@k#kf%f@kfk#f@fkfkf@fkkfk#%ff%ffk#fkf@k#ffk#fffff@%f@f%k#k#kff@k#k#k#%kfkffkf%f@f@ffffk#kffk%ffffk#ffkffkkfffk#fk, test gosub obfuscation in gui statement
	
	gui, font, %fkfkk#k#fkfkk#f@f@ffk#%%fff@f@f@fffffkfk%%ffk#k#fkf@k#fkfkfffkfk% norm
	gui, add, text, xm y+12 Gf@k#%fkfffkk#f@kfk#fff@kfk#%kffff@f%ffkff@f@ffkfk#fkf@k#fff@%kfk%k#ffkfk#kfk#f@kfk#%ffk%k#fkfkf@fkfkk#f@fkfkkf%%k#kff@kfffkfk#k#fkkf%fffffk#ffkffkkfffk#fk,
(
hello world
message in variable:
"%kffkf@kff@f@k#f@%%fkkff@fff@fkk#%%fkfkk#ffk#k#fffk%"

-press home key to test hotkeys-
)
	gui, add, text, xm y+12, enter something here to test`nvariable obfuscation
;$OBFUSCATOR: $DEFGLOBVARS: usermessage
	gui, add, edit, xm y+2 Vf@f%k#ffkff@f@k#kfk#k#%fk%kff@k#kfffffkfkfkfkf%ffff%kffkkffff@fkfff@kfk#f@%@ff%k#kfkffkf@f@k#kff@%kfkf r4, 
		
	gui, add, button, xm y+20 Gkfkf%kffkfffkkfkffkfkffff%fkk%kfk#kff@fff@fff@%fffff%fkf@kff@fkf@f@%f@f%k#fkfkkffkkfffk#ff%%k#kffkf@kfk#fff@fkf@%ffkfkffkfk#fkfkkf, Test gui submit
	gui, show
}


;LABEL ORIGINAL NAME: testguisubmit
kfkffkkffffff@fffkfkffkfk#fkfkkf:
	gui, submit, nohide
	msgbox, you entered "%fkk#fkfff@f@k#k#fffffk%%f@ffkffff@ffkfkf%%fkk#k#f@ffk#k#fkkffk%"
return


;LABEL ORIGINAL NAME: guigosub
f@k#kffff@fkfkffkfffffk#ffkffkkfffk#fk:
	msgbox, inside _guigosub_
return


;SKIPPED MOVING function: 'ihidestr()' to OBF CODE

;put this function in your source code. it will actually be called
;by the obfuscated code to 'decode' the obfuscated strings.
;this function and all calls to it will also be obfuscated in
;the output obfuscated program
;FUNCTION ORIGINAL NAME: decode_ihidestr
k#k#ffkffkffkfk#(fffkfffkk#fff@) {  
	global	
;$OBFUSCATOR: $DEFGLOBVARS: hexdigits
	
	static k#kfk#f@f@fkfffkk#kffk, fff@ffk#kffk, fkk#fkkff@fkf@k#, f@fkkffkf@f@kfffff, f@fkf@fffkff, kff@kfkfk#k#fkk#f@ff
;$OBFUSCATOR: $DEFLOSVARS: newstr, startstrlen, charnum, hinibble, lownibble, mybinary

	fkfk%f@ffk#fffkk#kffkf@%%fff@k#k#k#kfk#%k%f@ffk#fffkk#kffkf@%#kff@k#f@f@kf = % "0123456789abcdef"
		
	;will get the encoded key hidden in the obfuscated literal string
	kf%kffkf@kff@f@k#f@%f%k#f@f@f@f@fkfkfk%@%kffkfffkkfkffkfkffff%f@%fff@fkk#k#fkk#k#%fkk%ffk#k#kff@k#fffkfkfkffkf%ffffkff(fffkfffkk#fff@)
	
	;grab encoded data
	fffkfffkk#fff@ = % substr(fffkfffkk#fff@, 1, 1) . substr(fffkfffkk#fff@, 6)
	%k#kfkffkf@f@k#kff@%ff%k#k#k#fkf@k#kffff@fk%f%fffkfkkff@f@kfkfkf%@f%fffffkfff@k#k#fkffk#ff%%f@kfk#f@fkfkf@fkkfk#%fk#kffk = % strlen(fffkfffkk#fff@)
		
	k%f@kffffff@fkfffkf@kffkff%#k%f@ffk#k#fffff@fkk#%fk#%ffkffff@f@f@fkff%f%f@f@kff@fff@kffff@fff@%@f@fkfffkk#kffk = 
	;reverse the hex string
	loop, % strlen(fffkfffkk#fff@) 
		k#kfk%k#kfkfkfffk#fk%#f@f%k#f@kffff@f@fkk#kf%@f%fffkf@kfk#k#k#k#ffkf%kf%k#f@k#fkffk#f@k#fkkfk#%ffkk#kffk = % substr(fffkfffkk#fff@, a_index, 1) . k#kfk#f%kffkffk#f@fkff%@f@%fkkfkfkfk#f@fkf@%%f@k#k#kffffkffk#fkfk%fkfffkk#kffk
	
	fffkfffkk#fff@ = % k#kfk%kffkk#k#f@f@k#f@%%fkk#f@kfk#kffffkk#%%fffkfkkff@f@kfkfkf%#%k#kfkfkfffkfk#ffk#kf%f@f@fkfffkk#kffk
	k#kfk%kffkf@kff@f@k#f@%#f%fff@ffkffkfkk#kff@f@%@%fkfkk#k#fkfkk#f@f@ffk#%f@fkf%f@f@kff@fff@kffff@fff@%ffkk#kffk = 
	fkk%f@ffk#kff@fffff@fk%#f%f@k#fkfkf@fkkfff%kk%kffkfff@kfkffkkff@%ff%f@k#fkkfffk#k#ffkfffkfk#%%fff@ffkff@fffffkk#%@fkf@k# = 1
	;convert from hexidecimal to binary	
	while true
	{
		if (fkk#%kffkfffkkfkffkfkffff%fkk%fkk#fkfff@f@k#k#fffffk%ff@%kfk#kff@f@fkkffk%fkf%k#fkfkkffkkfffk#ff%@k# >f%fffffkk#fkk#k#kf%f%ffkfkfk#fkkffkf@kfffkf%f@%k#f@f@f@f@fkfkfk%f%fff@fkk#k#fkk#k#%f%f@f@fkfkk#k#fkfffkfk%k#kffk)
			break
			
		f@f%kfk#f@fkfkfkfk%kk%f@fkfffff@ffffk#k#ff%ff%k#kfkfkfffk#fk%%fkk#k#f@ffk#k#fkkffk%kf%fff@k#kffffffkk#kffk%@f@kfffff = % substr(fffkfffkk#fff@, %kffkf@kff@f@k#f@%fk%fffffkf@kfkfk#k#f@kfk#ff%k%fkk#fkkffkfkkffkfkfkfk%#fkk%fkk#k#f@ffk#k#fkkffk%ff@fkf@k#, 1)
		;find it in hexdigits and convert to decimal number
		%fffkf@kfk#k#k#k#ffkf%%fkfffkk#kff@ffkffkkfk#%f@%kff@k#f@kff@fkfkk#f@f@%%fffkf@kfk#k#k#k#ffkf%fkk%kfk#f@fkfkfkfk%ffkf@f@kfffff = % instr(fkfkk%fffkk#k#fffkfkf@%#kff@%k#f@k#fkffk#f@k#fkkfk#%k#f@f@%fkffkff@f@k#fffkfkk#ffff%kf, %k#f@k#fkffk#f@k#fkkfk#%f@f%kff@k#k#k#kfkfkf%%k#k#f@f@fkfkk#k#%kkf%f@ffk#fffkk#kffkf@%%fkkffffkkff@k#f@k#fk%fkf@f@kfffff) - 1
		
		f@%fkfffkk#f@kfk#fff@kfk#%fk%f@kfk#f@fkfkf@fkkfk#%f@%k#k#f@f@fkfkk#k#%%k#fkkffkfkkff@f@%f%fkkffffkkff@k#f@k#fk%ffkff = % substr(fffkfffkk#fff@, %k#kffkf@kfk#fff@fkf@%f%kff@k#kfffffkfkfkfkf%kk#f%fffffkk#fkk#k#kf%kkf%f@fkfffff@ffffk#k#ff%f@fkf@k# + 1, 1)
		;find it in hexdigits and convert to decimal number
		f%kff@fkkffkkff@k#fffkfkk#%@f%ffk#k#kff@k#fffkfkfkffkf%kf%f@k#fkfkf@fkkfff%@fffkff = % instr(f%fkfkfkkff@f@f@fkk#k#%k%k#kfffkffkfkffk#%fk%ffk#k#kff@k#fffkfkfkffkf%k#%f@f@kff@fff@kffff@fff@%k%f@ffk#fffkk#kffkf@%ff@k#f@f@kf, %fff@ffkffkfkk#kff@f@%f@%fkk#k#k#k#fffff@%%f@k#fffkk#kff@%fk%f@f@fkfkk#k#fkfffkfk%f@fffkff) - 1
		
		;unshift the hex
		%fffkk#ffkffkkffkkfk#ffff%f@f%kffkkffff@fkfff@kfk#f@%kkf%f@f@kff@fff@kffff@fff@%fk%f@k#fkfkf@fkkfff%f%fkk#k#f@ffk#k#fkkffk%@f@kfffff := f%kfk#k#kfk#k#k#k#%@%fkk#fkfff@f@k#k#fffffk%k%fkk#f@kfk#kffffkk#%#k%fffffkf@kfkfk#k#f@kfk#ff%fk#k#fkk#fk(f@fk%f@f@kff@fff@kffff@fff@%%k#k#f@kffkk#k#ffffk#kff@%kff%k#f@kffff@f@fkk#kf%kf@f%kffkf@kff@f@k#f@%@kfffff)
		f%f@k#fkkfffk#k#ffkfffkfk#%%k#kfkfkfffk#fk%@%fkkffffkkffffk%%fff@k#k#k#kfk#%fkf@fffkff := f@k%k#kfffkffkfkffk#%#k%k#k#ffk#fkkffk%fk#%fff@ffkffkfkk#kff@f@%k#fk%kff@kfffffkfk#kfkf%k#fk(f@f%fkfff@fkfkfkkffff@k#k#%kf@f%f@ffk#fffkk#kffkf@%ff%fkfkfkkff@f@f@fkk#k#%kff)
		
		kf%fkfkk#k#fkfkk#f@f@ffk#%f@kfk%fkkfkfkfk#f@fkf@%fk%kffkf@kff@f@k#f@%#k#fkk#f@ff = % f@fk%fkkffffkkffffk%kffkf@%kfk#kff@fff@fff@%f@k%fff@k#kffffffkk#kffk%fffff * 16 + f@f%k#ffkff@f@k#kfk#k#%kf@f%fkkffffkkff@k#f@k#fk%ffkf%kfk#k#kfk#k#k#k#%f
		k#%f@fkfffff@ffffk#k#ff%k%f@f@k#fkf@f@kfk#k#kffkf@%fk#%fff@ffkff@fffffkk#%f@f%kffkf@kff@f@k#f@%@fkfffkk#kffk .= chr(k%k#kfkfkfffk#fk%%k#f@f@f@f@fkfkfk%ff@k%f@f@kff@fff@kffff@fff@%fkfk#%fffkk#k#fffkfkf@%k#fkk#f@ff)
		
		fk%f@f@kff@fff@kffff@fff@%%fkfffkk#kff@ffkffkkfk#%k%fff@ffkffkfkk#kff@f@%#%fkkffffkkff@k#f@k#fk%fkk%k#k#kff@k#k#k#%ff@fkf@k# += 2		
	}
		
	k#%fff@fkk#k#fkk#k#%kfk%f@fkffkfkffkk#ff%#f%k#k#f@kffkk#k#ffffk#kff@%@f%kfk#f@fkfkfkfk%@fkf%kff@fkkffkkff@k#fffkfkk#%ffkk#kffk = % f%fkfff@fkfkfkkffff@k#k#%ff%ffkffff@f@f@fkff%kf%f@ffk#kff@fffff@fk%f%kffkfffkkfkffkfkffff%%f@fkfffff@ffffk#k#ff%f@kffkk#(k#%fkk#k#f@ffk#k#fkkffk%kfk#%kfk#kff@f@fkkffk%f%fff@fkk#k#fkk#k#%%fkf@kff@fkf@f@%@f@%k#f@k#f@fkk#fkf@%fkfffkk#kffk)
		
	return, k%f@k#fffkk#kff@%#kfk#%fffffkf@kfkfk#k#f@kfk#ff%f@%k#kfffkffkfkffk#%f@f%k#k#f@f@fkfkk#k#%kfffkk#kffk	
}


;FUNCTION ORIGINAL NAME: decode_hexshiftkeys
kff@f@fkkffffkff(fffkfkf@ffk#kfff) { 
	global
;$OBFUSCATOR: $DEFGLOBVARS: decodekey, ishexchar, useshiftkey
	
	;these have '1's in them
	k%kfk#k#kfk#kfkffkf@%#%kfk#f@fkfkfkfk%f%fkkffffkkff@k#f@k#fk%ff%f@ffk#fffkk#kffkf@%ffk%k#kfkfkfffkfk#ffk#kf%k#f@fkf@ := "fff@kkf1ffkfkfkfff#k1fk@kf#@fffk@#kk"
	%fffffkfff@k#k#fkffk#ff%fkk#%kff@k#kfffffkfkfkfkf%%f@k#fkfkf@fkkfff%fff%fff@ffkffkfkk#kff@f@%@ffk#fff@ := "fff@f1ff@kffkk#f1fffffkf"
	
	;grab randomly created encrypt key
	;i hid it in the obfuscated literal string, 2 characters in
	%k#fffffkk#f@fkf@%%fkkffffkkffffk%%fkk#fkfff@f@k#k#fffffk%%ffk#fkf@k#ffk#fffff@%%k#ffkff@f@k#kfk#k#%%fkk#fff@ffk#fff@%1 = % substr(fffkfkf@ffk#kfff, 2, 1)
	%fffkk#k#fffkfkf@%%k#fffffkk#f@fkf@%%f@f@kff@fff@kffff@fff@%%fkk#fff@ffk#fff@%%fff@kfkfkffkkfk#fkff%%k#f@kffff@f@fkk#kf%2 = % substr(fffkfkf@ffk#kfff, 3, 1)
	%kffkfff@kfkffkkff@%%k#fffffkk#f@fkf@%%k#ffkfk#kfk#f@kfk#%%fkk#fff@ffk#fff@%%k#k#kff@k#k#k#%%kfk#kff@fff@fff@%3 = % substr(fffkfkf@ffk#kfff, 4, 1)
	%k#f@k#fkffk#f@k#fkkfk#%%fff@k#k#k#kfk#%%k#fffffkk#f@fkf@%%ffk#k#kfk#kfffff%%f@f@kff@fff@kffff@fff@%%fkk#fff@ffk#fff@%4 = % substr(fffkfkf@ffk#kfff, 5, 1)
	
	;covert key values to actual numbers
	loop, 4
		%kfk#k#kfk#kfkffkf@%%k#fffffkk#f@fkf@%%k#kfkffkf@f@k#kff@%%a_index% = % instr(%k#k#f@kffkk#k#ffffk#kff@%fkf%k#k#f@f@fkfkk#k#%k%fkf@kff@fkf@f@%k#%fkffffffffk#fkff%k%kff@k#f@kff@fkfkk#f@f@%ff@k#f@f@kf, %kfk#k#kfk#kfkffkf@%%fkfffkk#f@kfk#fff@kfk#%%k#fffffkk#f@fkf@%%kffkk#k#f@f@k#f@%%kff@k#f@kff@fkfkk#f@f@%%fkk#fff@ffk#fff@%%a_index%) - 1
			
	kf%f@fkfffff@ffffk#k#ff%%f@k#k#kffffkffk#fkfk%%fkkfkfkfk#f@fkf@%k%f@fkfffff@ffffk#k#ff%%fkk#fff@f@kfk#f@%#fffffffff@ = 0
}	


;FUNCTION ORIGINAL NAME: decode_shifthexdigit
f@k#kfk#k#fkk#fk(f@fkk#fkk#ffk#) { 
	global
	
	;each time i enter this routine i will use the next key value
	;to shift the hexvalue
	kfk#%fkk#fkfff@f@k#k#fffffk%f%k#ffkff@f@k#kfk#k#%fff%fffkk#k#fffkfkf@%fffff@++
	if (kf%fff@fkk#k#fkk#k#%k#%ffkff@f@ffkfk#fkf@k#fff@%ff%kff@k#f@kff@fkfkk#f@f@%f%fffffkf@kfkfk#k#f@kfk#ff%%k#fkkffkfkkff@f@%ffffff@ > 4)
		kf%k#kfkffkf@f@k#kff@%k#%fff@fkk#k#fkk#k#%ff%kfk#kff@f@fkkffk%f%fff@kfkfkffkkfk#fkff%%f@k#fffkk#kff@%ffffff@ = 1	
	
	;subtract the shift key from the hexvalue 
	f@fkk#fkk#ffk# -= %k#f@k#fkffk#f@k#fkkfk#%%k#fffffkk#f@fkf@%%fkfkk#ffk#k#fffk%%fkk#fkfff@f@k#k#fffffk%%k#kfffkffkfkffk#%%kfk#fffffffff@%
	
	;if i go under zero, just add 16
	if (f@fkk#fkk#ffk# < 0) 
		f@fkk#fkk#ffk# += 16
		
	return f@fkk#fkk#ffk#	
}


;FUNCTION ORIGINAL NAME: fixescapes
fffkfff@kffkk#(fffkkffff@kf) { 
	global
	
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "````", % "``", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``n", % "`n", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``r", % "`r", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``,", % "`,", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``%", % "`%", all	
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``;", % "`;", all	
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``t", % "`t", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``b", % "`b", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``v", % "`v", all
	StringReplace, fffkkffff@kf, fffkkffff@kf, % "``a", % "`a", all
	
	StringReplace, fffkkffff@kf, fffkkffff@kf, % """""", % """", all
	
	return fffkkffff@kf
}

