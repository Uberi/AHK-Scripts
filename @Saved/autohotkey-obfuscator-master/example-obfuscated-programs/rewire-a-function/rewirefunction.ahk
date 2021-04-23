#SingleInstance

;Since the obfuscator is set to do Dynamic obfuscation by default,
;leaving off obfuscator CHANGE_DEFAULTS statements at the beginning
;of your program is enough set the obfuscator to do dynamic obfuscation
  
;put a string assignment header like this in your program so that
;the program name and copyright info still shows up in the obfuscated ;version of this program
program_name:="rewirefunction.ahk"
program_name:="Author: David Malia, Augusta, ME"
program_name:="Copyright David Malia, 2013"

;YOU MUST ALREADY BE USING DYNAMIC OBFUSCATION IN ORDER TO
;USE THE REWIRE FUNCTION ABILITY OF THIS OBFUSCATOR
;SO THE MINIMUM DUMP STATEMENTS YOU WILL NEED TO USE ARE SHOWN BELOW

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
;always use these dumps for function and label fragments when
;doing dynamic obfuscation 
;$OBFUSCATOR: $FUNCFRAGS_DUMPCLASS: unclassed
;$OBFUSCATOR: $FUNCFRAGS_DUMPCLASS: unsecclasses
;$OBFUSCATOR: $LABELFRAGS_DUMPCLASS: unclassed
;$OBFUSCATOR: $LABELFRAGS_DUMPCLASS: unsecclasses
;if you had created 'secure' obfuscation classes then they would 
;have to have dumps for them
;for obfuscated system function calls
;$OBFUSCATOR: $SYSFUNCFRAGS_DUMPALL: 

;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
mytrue = 1
myfalse = 0

;to set functions as 'rewirable' functions, all you have to do
;is to use the $DUMP_REWIRE_STRAIGHT or the $DUMP_REWIREFUNCPATH
;obfuscator command comments in your code somewhere. No other
;actions by you are necessary. it is however necessary to use one
;of them before the first usage of the function in your program.

;im going to start rewiring the SOMEFUNC() function 
;to the REWIRED_SOMEFUNC() function

;$OBFUSCATOR: $DUMP_REWIRE_STRAIGHT: SOMEFUNC
;will go to the actual function
SOMEFUNC("hello world - REWIRE STRAIGHT TEST")

;$OBFUSCATOR: $DUMP_REWIREFUNCPATH: SOMEFUNC, REWIRED_SOMEFUNC
;it will now go to REWIRED_SOMEFUNC instead of SOMEFUNC!
SOMEFUNC("autohotkey rocks - REWIREFUNCPATH TEST")

loop, 4
{
	indexdivby2 := ((a_index // 2) * 2 == a_index) ? mytrue : myfalse
	
	;will take one of the 2 branches and will rewire the function on the fly!
	if (indexdivby2) {	
;$OBFUSCATOR: $DUMP_REWIRE_STRAIGHT: SOMEFUNC	
	} else {
;$OBFUSCATOR: $DUMP_REWIREFUNCPATH: SOMEFUNC, REWIRED_SOMEFUNC	
	}
	
	;this function can go to either function depending on which
	;path was followed in the if above!
	SOMEFUNC("`nLOOP FLIP FLOP TEST`n*EVEN INDEX GOOD, ODD REWIRED*`nmy loop index is: " . a_index)
}

;in this one i am going to use a rewired function that closes its
;own door

;$OBFUSCATOR: $DUMP_REWIRE_STRAIGHT: yourfunc
yourfunc("DUMPED 'REWIRE_STRAIGHT' BEFORE CALLING THIS")

;$OBFUSCATOR: $DUMP_REWIREFUNCPATH: yourfunc, yourfunc_trapdoor
yourfunc("DUMPED 'REWIREFUNCPATH' BEFORE CALLING THIS")

yourfunc("this call of this function was automatically rewired straight!")

;$OBFUSCATOR: $DUMP_REWIREFUNCPATH: yourfunc, yourfunc_trapdoor
yourfunc("*THIS SHOULD CALL THE TRAPDOOR AGAIN*")

yourfunc("trap door is now off and should not be called")

exitapp	 
RETURN
;put after the end of the autoexecute section:
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

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;(technically this one would be all right because it does not call any
;functions or use any variables inside of it)
testfunction()
{
	global
	msgbox, TESTING OBF OF A FUNCTION CALL:`n`ntestfunction has been called
}

cancelprog:
	exitapp
return

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
SOMEFUNC(someparam)
{
	global
	msgbox, inside function: "SOMEFUNC"`n`nparameter was: %someparam%
	return someparam

}
;this function is never called in the unobfuscated script!
REWIRED_SOMEFUNC(someparam)
{
	global
	msgbox, inside function: "REWIRED_SOMEFUNC"`n`nparameter was: %someparam%`n`n***FUNCTION WAS REWIRED TO THIS FUNCTION***
	return
}

yourfunc(myparam)
{
	global
	
	msgbox, inside 'yourfunc'`nparameter is:`n%myparam%

}

;this function is never called in the unobfuscated script!
yourfunc_trapdoor(myparam)
{
	global
;this command will close the trap door!
;$OBFUSCATOR: $DUMP_REWIRE_STRAIGHT: yourfunc	

	;maybe do some extra security things here
	
	;i will add something on to the parameter so that it will indicate
	;that i went through this function first!
	myparam .= "`n`nI WENT THOUGH A TRAP DOOR named: yourfunc_trapdoor!`n" 
	
	;NOTICE I AM CALLING THE ORIGINAL FUNCTION NOW!
	return yourfunc(myparam)
}
