obf_copyright := " Date: 3:45 PM Tuesday, March 19, 2013          "
obf_copyright := "                                                "
obf_copyright := " THE FOLLOWING AUTOHOTKEY SCRIPT WAS OBFUSCATED "
obf_copyright := " BY DYNAMIC OBFUSCATER FOR AUTOHOTKEY           "
obf_copyright := "                                                "
obf_copyright := " Copyright (C) 2011-2013  David Malia           "
obf_copyright := " DYNAMIC OBFUSCATER is released under           "
obf_copyright := " the Open Source GPL License                    "


;AUTOEXECUTE ORIGINAL NAME: autoexecute
;autoexecute
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
	;SECURITY CLASS FRAG: for class: COMMON for char: f
	fkf%fkkfffkffkffkff@fkk#fk%kffk%f@ffkfk#fkfkfkkffk%%ffkfffffffffk#k#kfk#k#fk%ff@%k#kfffkffkk#k#%k#kfkff@f@kf=%fkf@fkkfkfffffffffff%f%f@fffkfkf@kff@k#f@f@f@ff%
	;SECURITY CLASS FRAG: for class: COMMON for char: k
	fkk#k%k#k#fkfkfff@k#fk%#f%k#f@f@ffkfkfkfk#f@%@ff%k#fff@ffkfk#fkfffkfkff%k#ff%fff@ffk#fkk#kfk#%fkfkkf=%ffffffkfkffffkf@fkfkf@%k%f@f@kffff@fkk#k#fff@f@fk%
	;SECURITY CLASS FRAG: for class: COMMON for char: @
	f%kfkffkfkfff@kfk#ffkff@kf%k%fkfkfff@f@fff@kf%fkk#%ffkffkf@kfk#k#ffffk#fffk%%kffkk#ffk#ffffkf%kfkfk#kff@=%f@kfk#f@ffkffkk#kffkffk#%@%f@f@fkkffff@fff@f@fk%
	;SECURITY CLASS FRAG: for class: COMMON for char: #
	fkf%fff@ffk#fkk#kfk#%kfkk#k#%kff@k#k#f@k#kffkfkkff@%f@fkk%ffk#fkfkk#kfkffkkf%ffkkfk#kf=%f@kfkfkfkffkkf%#%fkf@k#kffkfffkf@f@fffkkf%

;TRIPLE MESS FRAGMENTS FOR: f
	f@kf%fkk#k#f@ffk#fffkfkkf%f%f@fffkfffffffkkff@kf%kfk#%fkfkffkff@k#kfkff@f@kf%fk#ff:=f%fkfff@ffffkffffk%kfkff%k#k#kfkff@f@fkfkkff@%k%fkfkffkff@k#kfkff@f@kf%f%fkfkk#kfkfk#kff@%k#kfkff@f@kf
	kffk%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%kff%fkf@fkk#fkfkk#f@kf%ffkf%fkfkk#kfkfk#kff@%f@fk:=fkfkf%fkfkffkff@k#kfkff@f@kf%kff@%k#f@fkfkfkf@k#k#k#k#%k#k%kffkk#ffk#ffffkf%fkff@%fkfkffkff@k#kfkff@f@kf%@kf
	f@f%fkfkffkff@k#kfkff@f@kf%kff%fkk#k#f@ffk#fffkfkkf%fkf@%fkkffkf@kfk#kffkfk%k#f%fff@k#k#f@kfk#fffkkfk#k#%ff@f@kfff:=fkfk%f@fkf@k#ffk#fkfkk#fk%ffk%fkfkffkff@k#kfkff@f@kf%%f@fkfff@ffk#kff@f@%f@%fkk#k#f@ffk#fffkfkkf%#kf%fkk#k#f@ffk#fffkfkkf%ff@f@kf
	f@kf%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%@fk%f@f@kffff@fkk#k#fff@f@fk%f%f@f@kfffk#f@fkf@kfkffkfk%@%fkfkffkff@k#kfkff@f@kf%kkff@kff@:=fkfkf%k#kff@fkkff@f@f@k#%f%fkk#k#f@ffk#fffkfkkf%ff%fkfkk#kfkfk#kff@%%fkk#k#f@ffk#fffkfkkf%#kfkff@f@kf
	f@%fkk#k#f@ffk#fffkfkkf%%fkfkfkk#k#f@fkkffkkfk#kf%%fff@k#fkkfk#k#f@k#ff%%fkfkffkff@k#kfkff@f@kf%@k%f@k#f@f@ffk#k#kf%ffffkk#:=fkfkff%fkk#k#f@ffk#fffkfkkf%ff%fkfkk#kfkfk#kff@%k#kf%k#kfffkffkk#k#%kff@f@kf
	f%f@fkfffkffk#fkfkf@f@%kkf%ffk#fkfkk#kfkffkkf%%fkfkffkff@k#kfkff@f@kf%@k#%fkk#k#f@ffk#fffkfkkf%#kfkff@k#:=%fkfkffkff@k#kfkff@f@kf%kfk%ffkfk#kffff@f@k#kfk#k#%ff%fkk#k#f@ffk#fffkfkkf%ff@k%fkfkfkk#k#f@fkkffkkfk#kf%kfkff@f@kf
	fkk#%f@fkf@k#ffk#fkfkk#fk%f@fk%fff@k#fkkfk#k#f@k#ff%k#k%fkfkfkk#k#f@fkkffkkfk#kf%fff@%fkk#k#f@ffk#fffkfkkf%#k#:=f%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%ff%fkfffkkfk#fff@kf%kff%fkfkk#kfkfk#kff@%k#kfkff@f@kf
	ff%fkfkffkff@k#kfkff@f@kf%@k#fff@%f@fkfff@k#k#k#kff@%f@%fkfkffkff@k#kfkff@f@kf%kkfk#kfkfk#:=fkf%fkk#k#f@ffk#fffkfkkf%%fkf@k#fkfkfkf@fkk#%f%kfk#k#ffk#fkk#kfk#k#%f%fkk#k#f@ffk#fffkfkkf%ff@k#kfkff@f@kf
	k#%k#fkffk#ffffffkf%k%fkfkfkk#k#f@fkkffkkfk#kf%fff%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%ff@%kffkf@k#k#ffkffff@kf%kfk#:=f%fff@fkfkfkk#kfff%kfk%fkfkffkff@k#kfkff@f@kf%fk%fff@ffk#fkk#kfk#%ff%fkfkk#kfkfk#kff@%k#kfkff@f@kf
	f@k#%kfffk#fkk#ffkfffkfff%f%fkfkffkff@k#kfkff@f@kf%f@f@%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%ff@f@:=fkfkf%fff@k#k#f@kfk#fffkkfk#k#%%fkfkffkff@k#kfkff@f@kf%kff@%fkk#k#f@ffk#fffkfkkf%#kf%fkk#k#f@ffk#fffkfkkf%ff@f@kf
	ffk%f@fffkfffffffkkff@kf%f%fkfkffkff@k#kfkff@f@kf%@f@%fkk#k#f@ffk#fffkfkkf%#k#k#:=%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%fkff%fkfffkk#ffkff@%kf%fkfkffkff@k#kfkff@f@kf%@k#kfkff@f@kf
	f%fkfkk#kfkfk#kff@%fff%fkfkffkff@k#kfkff@f@kf%kfk%k#k#kfkff@f@fkfkkff@%ffkf%fkfkffkff@k#kfkff@f@kf%f%k#fkf@kffkkffff@kfkf%ff@fkff:=fkfkf%ffffffkfkffffkf@fkfkf@%fkff%fkfkk#kfkfk#kff@%k#kfk%f@f@fkfffkkfffffk#%ff%fkfkk#kfkfk#kff@%f@kf
	k#k%ffkff@f@kffffkk#fkkfk#ff%#fkf%fkfkffkff@k#kfkff@f@kf%%k#k#fkfffkf@fkfkk#kfk#kf%f%fkfkffkff@k#kfkff@f@kf%k#k#kfk#:=f%fkk#k#f@ffk#fffkfkkf%fkffk%k#f@fkfkfkf@k#k#k#k#%ff@%fkk#k#f@ffk#fffkfkkf%#%fffff@kffkkfk#ffff%kfkff@f@kf
	k%fkfkfkk#k#f@fkkffkkfk#kf%ff%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%%kffkk#f@fkf@ffk#f@fk%kfkffkfkkfk#kffk:=%f@fffkfkf@kff@k#f@f@f@ff%fk%fkfkffkff@k#kfkff@f@kf%kffk%fkfkffkff@k#kfkff@f@kf%f%fkfkk#kfkfk#kff@%%fkf@k#fkf@ffkff@fk%k#kfkff@f@kf
	%fkfkffkff@k#kfkff@f@kf%@f@%fkfkffkff@k#kfkff@f@kf%fffk%k#f@fkfff@fffff@fkf@f@fk%#f@f%fkfkk#kfkfk#kff@%k#k#f@:=fkf%fkk#k#f@ffk#fffkfkkf%ff%f@kff@fff@fkf@ffkf%k%ffk#fkfkk#kfkffkkf%ff%fkfkk#kfkfk#kff@%k%fkfkfkk#k#f@fkkffkkfk#kf%kfkff@f@kf
	ffkfk%fkfkfff@f@fff@kf%%fkfkffkff@k#kfkff@f@kf%k#fk%fkk#k#f@ffk#fffkfkkf%#k#k#%k#k#fkk#kfkffkkffkk#%k#ff:=%ffkfk#f@kff@f@ffffkf%fkfkffk%fkfkffkff@k#kfkff@f@kf%f@k#%fkk#k#f@ffk#fffkfkkf%fkff@f@kf
	%fkfkffkff@k#kfkff@f@kf%@fk%f@fkfff@k#k#k#kff@%ffk%fkfkfkk#k#f@fkkffkkfk#kf%%fkfkffkff@k#kfkff@f@kf%@f@ffff:=%fkfkffkff@k#kfkff@f@kf%kfk%f@f@k#ffkff@kff@fff@kfk#%ffkff%fkfkk#kfkfk#kff@%k#%f@kff@fff@fkf@ffkf%kfkff@f@kf
	kfk#%fkfkffkff@k#kfkff@f@kf%ffkk#%kffkf@k#k#ffkffff@kf%f%ffkffkf@kfk#k#ffffk#fffk%kf%fkk#k#f@ffk#fffkfkkf%kffkf@k#kf:=fk%fkfkffkff@k#kfkff@f@kf%kffkf%fkfkffkff@k#kfkff@f@kf%@k%fkf@k#kffkfffkf@f@fffkkf%#k%fkfkffkff@k#kfkff@f@kf%kff@f@kf
	k#%fkk#k#f@ffk#fffkfkkf%#f%fkkfffkffkffkff@fkk#fk%@%fkfkffkff@k#kfkff@f@kf%@f%fkfkffkff@k#kfkff@f@kf%fffkf@:=fkf%fkk#k#f@ffk#fffkfkkf%ff%fkk#k#f@ffk#fffkfkkf%ff@k%f@kfk#f@ffkffkk#kffkffk#%#kfkf%k#kff@fkkffkfkk#kfff%f@f@kf
	kf%ffkfffffffffk#k#kfk#k#fk%f@%f@kfk#f@ffkffkk#kffkffk#%%fkk#k#f@ffk#fffkfkkf%#%fkfkffkff@k#kfkff@f@kf%ffkkffff@:=fkfkf%fkfkffkff@k#kfkff@f@kf%kff%f@kffffkk#f@f@kffk%@%fkk#k#f@ffk#fffkfkkf%#kfkf%fkfkffkff@k#kfkff@f@kf%@f@kf
;TRIPLE MESS FRAGMENTS FOR: k
	%k#kff@fkkffkfkk#kfff%f%fkfkffkff@k#kfkff@f@kf%fk%fkfkffkff@k#kfkff@f@kf%kfff%fkfkffkff@k#kfkff@f@kf%kfffkf:=fkk#%fkf@fkkfkffkf@fffk%k#%fkfkffkff@k#kfkff@f@kf%@ffk%fkfkfkk#k#f@fkkffkkfk#kf%f%fkfkffkff@k#kfkff@f@kf%fkfkkf
	fk%kfffkfk#kffffkff%fk%fkkfffkffkffkff@fkk#fk%fff%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%@f@k#kf:=fkk#%f@f@kfffk#f@fkf@kfkffkfk%k#f@f%fkfkffkff@k#kfkff@f@kf%k#f%fkfkffkff@k#kfkff@f@kf%fkfkkf
	kff%fkfffkk#ffkff@%%fkfkk#kfkfk#kff@%kfff%fkk#k#f@ffk#fffkfkkf%ff@%f@kff@fff@fkf@ffkf%ffk#f@fk:=fkk#%fkk#k#f@ffk#fffkfkkf%#%fkf@kff@kfffk#f@k#%f@%fkfkffkff@k#kfkff@f@kf%f%k#fff@ffkfk#fkfffkfkff%k#fffkfkkf
	k#%fkf@fkk#fkfkk#f@kf%f%f@f@ffkff@fkfffkfkf@fk%@k%fkfkffkff@k#kfkff@f@kf%fk%fkk#k#f@ffk#fffkfkkf%#%fkfkffkff@k#kfkff@f@kf%kkf:=%fkfkffkff@k#kfkff@f@kf%k%fkk#k#f@ffk#fffkfkkf%#%fkk#k#f@ffk#fffkfkkf%#f@%f@fffkfkf@kff@k#f@f@f@ff%f%kffkf@fffkk#kfffk#f@fk%fk#fffkfkkf
	f@f%fkfkffkff@k#kfkff@f@kf%f@%fkk#k#f@ffk#fffkfkkf%f%k#fkfffkf@fkf@kfk#k#kfff%k%ffk#kff@ffkffkfkfffk%fk#ffffk#:=f%fkk#k#f@ffk#fffkfkkf%%fkk#k#f@ffk#fffkfkkf%%fkfkfkk#k#f@fkkffkkfk#kf%k#f@%kffkk#f@fkf@ffk#f@fk%f%fkk#f@k#f@kfkffkfk%fk#fffkfkkf
	k#ff%kfffkfk#kffffkff%f@f%fkfkffkff@k#kfkff@f@kf%%fkfff@ffffkffffk%kff%fkk#k#f@ffk#fffkfkkf%fkk%fkfkffkff@k#kfkff@f@kf%kfkffff@:=fk%fkk#k#f@ffk#fffkfkkf%%fkfkfkk#k#f@fkkffkkfk#kf%%fkk#k#f@ffk#fffkfkkf%#f@f%f@ffkfk#fkfkfkkffk%fk#%f@fkfff@ffk#kff@f@%fffkfkkf
	k#%k#k#fkk#kfkffkkffkk#%fk%fkfkffkff@k#kfkff@f@kf%kk#f%fkfkffkff@k#kfkff@f@kf%k#fff@k#kffkfk:=fkk#k%fkfkfkk#k#f@fkkffkkfk#kf%%kfffk#fkk#ffkfffkfff%f@ffk%fkfkfkk#k#f@fkkffkkfk#kf%fffkfkkf
	k#f@%fkk#k#f@ffk#fffkfkkf%%ffk#fkfkk#kfkffkkf%%fkfkffkff@k#kfkff@f@kf%k#fkfkff:=fk%fkk#k#f@ffk#fffkfkkf%#k#%fkfkffkff@k#kfkff@f@kf%@ff%fkkfk#fkk#k#kfff%k#f%f@kfkfkfkffkkf%ffkfkkf
	ffk%fkfkfkk#k#f@fkkffkkfk#kf%f%fkfkffkff@k#kfkff@f@kf%fk%fkf@k#fkfkfkf@fkk#%f%f@f@kfffk#f@fkf@kfkffkfk%f%fkk#k#f@ffk#fffkfkkf%#ffk#fffkkfk#:=fkk#%kffkk#f@fkf@ffk#f@fk%k#%fkfkffkff@k#kfkff@f@kf%@ffk%f@fkfffkffk#fkfkf@f@%%fkfkfkk#k#f@fkkffkkfk#kf%f%fkfkffkff@k#kfkff@f@kf%fkfkkf
	k#%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%kfk%k#fkffk#ffffffkf%fffkfkffkkf:=fkk#%f@fffkfffffffkkff@kf%k#f%fkf@f@f@fkkff@fkk#ffk#%@%fkfkffkff@k#kfkff@f@kf%fk%fkfkfkk#k#f@fkkffkkfk#kf%ff%fkfkffkff@k#kfkff@f@kf%kfkkf
	%fkfkffkff@k#kfkff@f@kf%f%ffkffkf@kfk#k#ffffk#fffk%f@f%fkk#k#f@ffk#fffkfkkf%%ffk#fkfkk#kfkffkkf%k#fkfkfk:=fkk#%fkk#k#f@ffk#fffkfkkf%#f@ffk%fkkfk#fkk#k#kfff%#ff%fkfkffkff@k#kfkff@f@kf%kfkkf
	kf%fkfkffkff@k#kfkff@f@kf%%f@kfkfkfkffkkf%%fkk#k#f@ffk#fffkfkkf%f@f%fkfkffkff@k#kfkff@f@kf%kff%f@f@kffff@fkk#k#fff@f@fk%kfkkfk#k#f@kf:=fkk#k#%fkk#f@k#f@kfkffkfk%f%fkfkk#kfkfk#kff@%ff%fkk#k#f@ffk#fffkfkkf%#fffkfkkf
	kfkff%f@fkfffkffk#fkfkf@f@%ff%fkfkffkff@k#kfkff@f@kf%fkfkk%fkfkffkff@k#kfkff@f@kf%f@:=%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%k#k%fkfkfkk#k#f@fkkffkkfk#kf%f@f%fkfffkfkfkffkfk#f@%fk#f%f@f@ffkff@fkfffkfkf@fk%ffkfkkf
	fffk%fkk#k#f@ffk#fffkfkkf%fk#k%fkfkffkff@k#kfkff@f@kf%kfk%fkfkffkff@k#kfkff@f@kf%f@k%kffkk#f@fkf@ffk#f@fk%#kf:=fkk%k#fff@ffkfk#fkfffkfkff%#k#f%fkfkk#kfkfk#kff@%f%fkfkffkff@k#kfkff@f@kf%k#ff%fkfkffkff@k#kfkff@f@kf%kfkkf
	k#%f@fffkfffffffkkff@kf%fkk%fkfkfkk#k#f@fkkffkkfk#kf%k#fk%k#kff@fkkffkfkk#kfff%fk%fkfkffkff@k#kfkff@f@kf%kk%fkfkffkff@k#kfkff@f@kf%fkf@fk:=fk%fkk#kffkfkfkfff@kfff%k%fkfkfkk#k#f@fkkffkkfk#kf%k#f@%fkfkffkff@k#kfkff@f@kf%fk#ff%k#f@fkfff@fffff@fkf@f@fk%fkfkkf
	f@k%fffff@kffkkfk#ffff%#k#%fkk#k#f@ffk#fffkfkkf%%fkfkffkff@k#kfkff@f@kf%fkf@k#fkffffkf:=fkk#k%k#f@fkfff@fffff@fkf@f@fk%#f@%fkfkffkff@k#kfkff@f@kf%fk#f%fkfkffkff@k#kfkff@f@kf%fkfkkf
	%fkfkffkff@k#kfkff@f@kf%kff%fff@k#k#f@kfk#fffkkfk#k#%k%fkfkfkk#k#f@fkkffkkfk#kf%%fkfkffkff@k#kfkff@f@kf%ffkkfffk#:=fk%k#fkfff@k#fkfffk%k%fkfkfkk#k#f@fkkffkkfk#kf%k#%k#fkfffkf@fkf@kfk#k#kfff%f@f%fkfkffkff@k#kfkff@f@kf%k#fffkfkkf
	kffff%fkfkffkff@k#kfkff@f@kf%%ffk#fkfkk#kfkffkkf%k%fkfkffkff@k#kfkff@f@kf%f@%fkfkffkff@k#kfkff@f@kf%@fff@ffkfffkf:=f%fkk#k#f@ffk#fffkfkkf%k%fkfkfkk#k#f@fkkffkkfk#kf%k#%ffffk#kfk#ffkfffk#f@k#%%fkfkffkff@k#kfkff@f@kf%@ffk#fffkfkkf
	fk%fkk#k#f@ffk#fffkfkkf%#fkf%fkfkk#kfkfk#kff@%f@fkk%fkfkfkk#k#f@fkkffkkfk#kf%f@k%kffkk#f@fkf@ffk#f@fk%fk#ff:=%fkfkffkff@k#kfkff@f@kf%k%fkk#k#f@ffk#fffkfkkf%#k#f@f%fkk#kffkfkfkfff@kfff%fk#fffkfkkf
	f@%fkk#kffkfkfkfff@kfff%f%fkk#k#f@ffk#fffkfkkf%f@fkk#f%fkk#k#f@ffk#fffkfkkf%fkk#k#fkfk:=f%fkk#k#f@ffk#fffkfkkf%k%ffkffkfkkffkk#k#kff@fkf@%#%fkk#k#f@ffk#fffkfkkf%#f@ff%f@f@kffff@fkk#k#fff@f@fk%k#fffkfkkf
;TRIPLE MESS FRAGMENTS FOR: @
	ffkff%k#f@fkfff@fffff@fkf@f@fk%@%fkfkffkff@k#kfkff@f@kf%@fkfk%fkfkffkff@k#kfkff@f@kf%@k#kf%fkk#k#f@ffk#fffkfkkf%f:=%kffkf@fffkk#kfffk#f@fk%%fkk#kffkfkfkfff@kfff%fkf%fkk#k#f@ffk#fffkfkkf%%fkk#k#f@ffk#fffkfkkf%#%fkk#k#f@ffk#fffkfkkf%fkfk#kff@
	k#k%k#kfffkffkk#k#%#k#%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%ffk%fkfkffkff@k#kfkff@f@kf%ffffkfkk#fk:=fk%ffffk#kfk#ffkfffk#f@k#%fkk#%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%#kff@
	f%fkfkk#kfkfk#kff@%f@fff%fkfkk#kfkfk#kff@%k#k%f@f@kfkfffffff%#k%kffkkfkff@kffffff@%fffffkfkf:=fkf%fkfffkk#ffkff@%kk#%fkk#k#f@ffk#fffkfkkf%fk%fkfkffkff@k#kfkff@f@kf%%f@ffkfk#fkfkfkkffk%k#k%fkfkffkff@k#kfkff@f@kf%f@
	k%k#fkfffkf@fkf@kfk#k#kfff%#k%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%@k%fkfkfkk#k#f@fkkffkkfk#kf%f@fk%f@kff@fff@fkf@ffkf%ffkfffkf:=fkf%fkk#k#f@ffk#fffkfkkf%%fkk#k#f@ffk#fffkfkkf%#%fkk#k#f@ffk#fffkfkkf%f%fkf@k#kffkfffkf@f@fffkkf%k%fkf@f@f@fkkff@fkk#ffk#%fk#kff@
	f@f@%fkk#k#f@ffk#fffkfkkf%#f@f%fkkfk#fkk#k#kfff%@k#f%kfffk#fkk#ffkfffkfff%ffk:=fkf%f@f@fkkffff@fff@f@fk%kk#k%fkfkffkff@k#kfkff@f@kf%kfk#%f@f@fkfffkkfffffk#%kff@
	ffkf%f@kfk#f@ffkffkk#kffkffk#%f%f@k#f@f@ffk#k#kf%ffk%fkk#k#f@ffk#fffkfkkf%%fkfkffkff@k#kfkff@f@kf%fkfff@:=%fkfkk#f@k#k#k#kfk#f@%fkf%fkk#k#f@ffk#fffkfkkf%k#kf%fkk#k#f@ffk#fffkfkkf%fk#%fkk#k#f@ffk#fffkfkkf%ff@
	fkk#%f@f@fkfffkkfffffk#%kfkfk%k#k#fkfkfff@k#fk%ffkfk%fkfkffkff@k#kfkff@f@kf%kf%fkfkk#kfkfk#kff@%ffk#:=fkf%fffffff@kfffk#fffkf@%%fkk#k#f@ffk#fffkfkkf%%fkk#k#f@ffk#fffkfkkf%#k%k#f@f@ffkfkfkfk#f@%fkfk#kff@
	fff@%fkk#k#f@ffk#fffkfkkf%#ffk%fkfkfkk#k#f@fkkffkkfk#kf%%ffkffkf@kfk#k#ffffk#fffk%kf%fkk#k#f@ffk#fffkfkkf%#fkff:=%kfkffffkkff@k#k#fkk#fkfk%fkfk%fkf@k#fkfkfkf@fkk#%%fkk#k#f@ffk#fffkfkkf%#kfk%fkfkffkff@k#kfkff@f@kf%k#kff@
	%f@f@kfffk#f@fkf@kfkffkfk%%fkfkffkff@k#kfkff@f@kf%kf%fkfkk#kfkfk#kff@%k#%kffffff@k#f@fkfkk#f@k#f@%%fkfkffkff@k#kfkff@f@kf%@kff@f@fkf@:=f%fkk#k#f@ffk#fffkfkkf%fk%fkk#k#f@ffk#fffkfkkf%%f@f@ffkff@fkfffkfkf@fk%%fkfkfkk#k#f@fkkffkkfk#kf%%ffffk#kfk#ffkfffk#f@k#%kfkfk#kff@
	fkfk%fkfkffkff@k#kfkff@f@kf%@fk%fkk#k#f@ffk#fffkfkkf%ff%f@k#fkkfk#ffk#k#k#%%fkk#k#f@ffk#fffkfkkf%f@fkf@:=fk%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%k#%f@fkf@k#ffk#fkfkk#fk%k%f@fkf@k#ffk#fkfkk#fk%fkfk#kff@
	f%fkfkk#kfkfk#kff@%f@k#fk%fkk#k#f@ffk#fffkfkkf%f%f@ffkffffffffffkk#f@f@%ffffkfkfk#k#:=fkfkk%fkf@fkkfkfffffffffff%#kfk%fkfkffkff@k#kfkff@f@kf%k#k%fkfkffkff@k#kfkff@f@kf%f@
	f@%fkfkffkff@k#kfkff@f@kf%kk%fkfkfkk#k#f@fkkffkkfk#kf%%fkk#k#f@ffk#fffkfkkf%%fkf@k#f@kff@kffffffkfk%f%fkf@k#f@kff@kffffffkfk%kfk#fkf@fk:=fkf%fkk#k#f@ffk#fffkfkkf%%fkf@fkkfkfffffffffff%k%kfkffkfkfff@kfk#ffkff@kf%#kfk%fkfkffkff@k#kfkff@f@kf%k#kff@
	%fkf@fkkfkfffffffffff%fff%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%ffkfkk#kfffffkfk#k#:=fkf%fkk#k#f@ffk#fffkfkkf%k#k%ffkffkk#k#kff@ffk#fff@ff%fkfk%fkfkfkk#k#f@fkkffkkfk#kf%kff@
	f%fkk#k#f@ffk#fffkfkkf%%fkk#k#f@ffk#fffkfkkf%f%k#f@f@ffkfkfkfk#f@%%fkk#k#f@ffk#fffkfkkf%#k%f@fkfff@k#k#k#kff@%fkffkkf:=%fkf@k#fkfkfkf@fkk#%f%fkk#k#f@ffk#fffkfkkf%fkk%fkf@k#f@kff@kffffffkfk%#%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%fk#kff@
	kf%fkfkffkff@k#kfkff@f@kf%%fkf@k#fkf@ffkff@fk%kk#k%ffkffkf@kfk#k#ffffk#fffk%#kf%fkfkffkff@k#kfkff@f@kf%@fkk#fkfk:=%fff@k#k#f@kfk#fffkkfk#k#%fk%ffkfffffffffk#k#kfk#k#fk%fkk#%fkk#k#f@ffk#fffkfkkf%fk%fkfkffkff@k#kfkff@f@kf%k#kff@
	k%fkf@k#kffkfffkf@f@fffkkf%ff@k#f@%fkfkffkff@k#kfkff@f@kf%%fkfkk#kfkfk#kff@%k#fkfffkffkf:=fkfk%fkk#k#f@ffk#fffkfkkf%#%kfkffffkkff@k#k#fkk#fkfk%kf%fkk#k#f@ffk#fffkfkkf%fk#kff@
	kfff%fkk#k#f@ffk#fffkfkkf%#fk%fkk#k#f@ffk#fffkfkkf%%fkf@k#fkf@ffkff@fk%#k#%fkf@k#fkf@ffkff@fk%f@f@fffkfk:=f%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%%fkf@k#fkfkfkf@fkk#%k%kfffkfk#kffffkff%#kfkfk#kff@
	f@f%fkfkk#kfkfk#kff@%fkf%fkk#k#f@ffk#fffkfkkf%%f@ffkffffffffffkk#f@f@%k#k#f@fffffkf@:=fkf%fkk#k#f@ffk#fffkfkkf%k#%fkk#k#f@ffk#fffkfkkf%f%fkkfk#fkk#k#kfff%%fkk#k#f@ffk#fffkfkkf%fk#kff@
	kfk%fkfkfkk#k#f@fkkffkkfk#kf%ff%kffkf@fkk#fkkffk%f%k#fkfff@k#fkfffk%@fk%fkfkffkff@k#kfkff@f@kf%k%fkfkffkff@k#kfkff@f@kf%kffkfff:=%fkk#kffkfkfkfff@kfff%fkf%fkk#k#f@ffk#fffkfkkf%k#kf%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%#kff@
	%fkkfffkffkffkff@fkk#fk%%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%kfkffff@fkfkfkfkk#kfk#:=%f@f@kfkfffffff%fk%k#k#kfkff@f@fkfkkff@%fk%fkk#k#f@ffk#fffkfkkf%#k%fkfkffkff@k#kfkff@f@kf%kfk#kff@
;TRIPLE MESS FRAGMENTS FOR: #
	f@%k#f@fkfkfkf@k#k#k#k#%%fkfkffkff@k#kfkff@f@kf%@%fkfffkkfk#fff@kf%k#f%fkk#k#f@ffk#fffkfkkf%f@kff@:=fkfk%fff@fkfkfkk#kfff%fkk#k#%fkfkffkff@k#kfkff@f@kf%@f%fkk#k#f@ffk#fffkfkkf%kff%fkk#k#f@ffk#fffkfkkf%kfk#kf
	fffff%fffffff@kfffk#fffkf@%%fkk#k#f@ffk#fffkfkkf%fkk#%f@f@fkfffkkfffffk#%%fkfkffkff@k#kfkff@f@kf%@fkkffkkfkfkf:=fk%kfkffffkkff@k#k#fkk#fkfk%fkfkk%fkfkfkk#k#f@fkkffkkfk#kf%k#f@f%fkk#k#f@ffk#fffkfkkf%kffkk%fkfkffkff@k#kfkff@f@kf%k#kf
	kf%kffkf@fkk#fkkffk%kffkkf%fkfkffkff@k#kfkff@f@kf%ff@%fkk#k#f@ffk#fffkfkkf%fkfff:=f%fkk#k#f@ffk#fffkfkkf%fkfkk#%fkk#k#f@ffk#fffkfkkf%#f@f%ffk#fkk#kfk#kfkfkffkk#fk%kkffkkfk#kf
	k%fkfkfkk#k#f@fkkffkkfk#kf%f@f@%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%f%f@kff@fff@fkf@ffkf%f@k#%f@fffffffffffkfffkk#ff%fkf@fff@:=fkfk%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%k#k%fkfkfkk#k#f@fkkffkkfk#kf%f@fk%fkf@k#fkf@ffkff@fk%%fffff@kffkkfk#ffff%kffkkfk#kf
	fff%fkk#k#f@ffk#fffkfkkf%f@f%fkfkffkff@k#kfkff@f@kf%ff%f@fffffffffffkfffkk#ff%k%f@f@ffkff@fkfffkfkf@fk%%fkfkfkk#k#f@fkkffkkfk#kf%kfk#f@ff:=%fkf@kff@kfffk#f@k#%fkfk%ffkffkf@kfk#k#ffffk#fffk%fk%fkk#k#f@ffk#fffkfkkf%#k#%fkfkffkff@k#kfkff@f@kf%@fkkffkkfk#kf
	k#%fkf@fkkfkffkf@fffk%k#kff%fkfkffkff@k#kfkff@f@kf%%fkfkffkff@k#kfkff@f@kf%@ffkfkf:=fk%ffffffkfkffffkf@fkfkf@%fkf%fkk#k#f@ffk#fffkfkkf%%fkf@fkkfkfffffffffff%k#k%fkfkfkk#k#f@fkkffkkfk#kf%f@f%fkk#k#f@ffk#fffkfkkf%kffkkfk#kf
	f%fkk#k#f@ffk#fffkfkkf%f%fkkfkff@fffkf@fkkfk#ffkf%@fk%fkfkffkff@k#kfkff@f@kf%%fkk#k#f@ffk#fffkfkkf%fkffk#:=fkfkfk%fkk#k#f@ffk#fffkfkkf%#k#f%fkfkk#kfkfk#kff@%fkk%f@fffkfffffffkkff@kf%ffkk%fkfkffkff@k#kfkff@f@kf%k#kf
	k#kf%fkk#k#f@ffk#fffkfkkf%#f%f@f@ffkff@fkfffkfkf@fk%@fff%fkfkk#kfkfk#kff@%%fkfkffkff@k#kfkff@f@kf%@ffkffkff:=fkfkfk%fkf@fkk#fkfkk#f@kf%k#k#%fkfkffkff@k#kfkff@f@kf%@fkkf%fkfkffkff@k#kfkff@f@kf%kkfk#k%fkfkffkff@k#kfkff@f@kf%
	fk%fkk#f@k#f@kfkffkfk%fkk%fkfkffkff@k#kfkff@f@kf%k%fkfkffkff@k#kfkff@f@kf%k%fff@ffk#fkk#kfk#%ffkfffkff:=%fkfkffkff@k#kfkff@f@kf%kf%f@f@ffkff@fkfffkfkf@fk%%ffkffkf@kfk#k#ffffk#fffk%%fkk#k#f@ffk#fffkfkkf%f%fkk#k#f@ffk#fffkfkkf%k#k#f@fkkffkkfk#kf
	kff%fkk#fkk#fkkff@kf%f%f@f@kfffk#f@fkf@kfkffkfk%%fkfkffkff@k#kfkff@f@kf%fk%fkfkffkff@k#kfkff@f@kf%ff%fkfkffkff@k#kfkff@f@kf%@fkfkfkkf:=fk%fkf@f@f@fkkff@fkk#ffk#%f%fkk#k#f@ffk#fffkfkkf%fkk%fkfkfkk#k#f@fkkffkkfk#kf%k#f@%f@f@kfffk#f@fkf@kfkffkfk%fkkffkkfk#kf
	f%fkk#fkk#fkkff@kf%kk#kff%fkfkk#kfkfk#kff@%f%fkk#k#f@ffk#fffkfkkf%fffff@kffkff:=fkf%fkk#k#f@ffk#fffkfkkf%fkk#%f@ffkfk#fkfkfkkffk%k#f@%fkfffkkfk#fff@kf%fk%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%kkfk#kf
	k#%fkk#k#f@ffk#fffkfkkf%%fkfkffkff@k#kfkff@f@kf%f%k#fff@ffkfk#fkfffkfkff%kk%fkfkffkff@k#kfkff@f@kf%fkkfk#kfk#:=fkf%fkk#k#f@ffk#fffkfkkf%fkk#k#%ffffffkfkffffkf@fkfkf@%f@f%fkk#k#f@ffk#fffkfkkf%k%fkfkffkff@k#kfkff@f@kf%fkkfk#kf
	fkf%fkk#k#f@ffk#fffkfkkf%fk%fkfffkkfk#fff@kf%%fkfkffkff@k#kfkff@f@kf%kk#k#f@kfffkf:=%fkkffkf@kfk#kffkfk%fk%fkfkffkff@k#kfkff@f@kf%kfkk#k%fkfkfkk#k#f@fkkffkkfk#kf%f@fkkffkkfk#kf
	%fkfkffkff@k#kfkff@f@kf%kff%fkfkffkff@k#kfkff@f@kf%@%fkk#f@k#f@kfkffkfk%fff%fkfkk#kfkfk#kff@%k#fk:=fkf%fkk#k#f@ffk#fffkfkkf%fkk#k%fkfkfkk#k#f@fkkffkkfk#kf%f@fkkff%k#fff@ffkfk#fkfffkfkff%kkfk#kf
	fk%fkk#k#f@ffk#fffkfkkf%#%ffkffkf@kfk#k#ffffk#fffk%%fkfkffkff@k#kfkff@f@kf%ffffffkkffk:=fkf%f@fffkfkf@kff@k#f@f@f@ff%kfkk#k%f@f@kffff@fkk#k#fff@f@fk%#f@%fkfkffkff@k#kfkff@f@kf%kk%fkfkffkff@k#kfkff@f@kf%fkkfk#kf
	%fkfffkfkfkffkfk#f@%%fkk#k#f@ffk#fffkfkkf%#fff@%f@k#kfkff@fkff%fkkf%fkk#k#f@ffk#fffkfkkf%fkfk#ffff:=fkfkfkk%fkf@k#fkfkfkf@fkk#%#k#%fkfkffkff@k#kfkff@f@kf%@fkkff%fkk#k#f@ffk#fffkfkkf%kfk#kf
	f@f%fkk#k#f@ffk#fffkfkkf%ffk%fkfkfkk#k#f@fkkffkkfk#kf%kfk%fkf@k#f@kff@kffffffkfk%#k#%fkk#k#f@ffk#fffkfkkf%#ffk%k#kff@fkkff@f@f@k#%f:=fkfkfk%ffkffkk#k#kff@ffk#fff@ff%k#k#f%k#k#kffff@fffffk%@fk%fkk#k#f@ffk#fffkfkkf%f%fkfkffkff@k#kfkff@f@kf%kkfk#kf
	%f@kff@fff@fkf@ffkf%k%fkfkffkff@k#kfkff@f@kf%k#f%fkk#k#f@ffk#fffkfkkf%fkk%fkfkffkff@k#kfkff@f@kf%fkfffkff:=f%k#k#f@ffkfkff@kffk%kfk%kffkkfkff@fffkk#kfff%fkk#%fkk#k#f@ffk#fffkfkkf%#f@f%fkk#k#f@ffk#fffkfkkf%kf%fkfkffkff@k#kfkff@f@kf%kkfk#kf
	fkfk%f@fkfffkffk#fkfkf@f@%f@f@f%fkfkffkff@k#kfkff@f@kf%ffffk#f%fkk#k#f@ffk#fffkfkkf%k#k#f@:=%kffkkfkff@kffffff@%fkfk%fkfkffkff@k#kfkff@f@kf%kk#k%fkfkfkk#k#f@fkkffkkfk#kf%%kfffkfk#kffffkff%f@fk%fkk#k#f@ffk#fffkfkkf%ffkkfk#kf
	fkkfk%fkfkffkff@k#kfkff@f@kf%f%fkk#k#f@ffk#fffkfkkf%kfk#fk%k#f@f@ffkfkfkfk#f@%kff@f@fk:=fkfk%kffkkfkff@kffffff@%fkk%fkfkfkk#k#f@fkkffkkfk#kf%k#f@fkk%fkfkffkff@k#kfkff@f@kf%fkkfk#kf

;dump variable fragments 
;OBF_GLOBVAR name: mytrue
	k%fkf@fkfkfkffk#%f@k%k#ffffkfkffkfkkfk#kffk%%fkf@f@f@fkkff@fkk#ffk#%k#fff@f@=%kfk#k#ffk#fkk#kfk#k#%fkff%kfffk#fkk#ffkfffkfff%ffk%fkfkkfkfkffkfffkff%f@%f@fff@kfkfk#ffffk#%#fkk#
	ff%fkfffkfkfkffkfk#f@%kf%ffk#fkfkk#kfkffkkf%f%fkkff@k#k#kfkff@k#%%k#k#f@f@fffffkf@%@k#fffk=fkff%f@k#fff@f@kffff@f@%fk#%ffk#fkk#kfk#kfkfkffkk#fk%f@k%k#k#kffff@ffkfkf%fkk#
	kf%f@kfk#f@ffkffkk#kffkffk#%%k#ffkfkfffkfkffkkf%#k#k%f@ffffkfkffkfffff@fkff%f@k%kffkffkffffkf@f@fk%f@k#=%fffffff@kfffk#fffkf@%fkf%f@fffffffffffkfffkk#ff%fffk%f@f@k#fkf@kff@%f@k#%f@k#f@kffffkk#%kk#
;OBF_GLOBVAR name: myfalse
	%ffk#kff@ffkffkfkfffk%k%f@fffffffffffkfffkk#ff%#f%fkk#kfkfkffkfkfkf@ffk#%f%kfkffffffkfkkff@%f@%k#fkfkk#ffk#fff@k#kffkfk%ffkf@=k%k#kfk#f@fff@f@ffkffkff%fkf%f@ffkffffffffffkk#f@f@%ff%kfk#fff@fkfkfkffkfff%fkfff@
	%kfkffffffkfkkff@%%k#ffffkfkffkfkkfk#kffk%f@f%k#fff@ffkfk#fkfffkfkff%ff@%ffkff@f@kffffkk#fkkfk#ff%kffk=k#f%ffkffkk#k#kff@ffk#fff@ff%kff%k#k#fkffffk#k#kfk#%@%ffkff@f@k#k#k#%kf%f@k#f@kffffkk#%f@
	%f@kfkff@fkf@fkkff@kff@%@ff%f@k#fkkfk#ffk#k#k#%fkf%kffkf@ffkffkfkkfk#k#f@kf%k#f@fk=k%ffkffkfkkffkk#k#kff@fkf@%#f%k#ffkfkfffkfkffkkf%fff%fff@k#ffk#kfk#fkff%f%fkfkfffff@f@k#kf%fff@


;PARAMETERS for function  named: SOMEFUNC
;OBF_FUNC_2_PARAM name: someparam
	k%k#f@f@ffkfkfkfk#f@%ffkf%fff@k#k#f@kfk#fffkkfk#k#%fkff%f@fkffk#f@f@ffff%ff%fff@k#fff@f@fkkfk#kfkfk#%%ffkff@f@k#k#k#%fkkfkf=%fkkfffkffkffkff@fkk#fk%%f@kfkfkfk#ffk#ff%kf@%f@kfkff@fkf@fkkff@kff@%f%kffkffkffffkf@f@fk%ffkfkfk
	%kfkffffkkff@k#k#fkk#fkfk%k#%kfffffkff@f@fff@ffkfffkf%ff%k#fff@ffkffkfkkfkfkffff@%f@%k#fkk#k#fkfkfkkffkf@fk%#fffkk#f@ffkf=fk%k#kfffkffkk#k#%%f@ffffkfkffkfffff@fkff%@ff%k#k#ffffkff@kfk#%ffk%f@k#fff@f@kffff@f@%kfk
;PARAMETERS for function  named: REWIRED_SOMEFUNC
;OBF_FUNC_3_PARAM name: someparam
	k%k#kffkkffkkfk#kfk#%kff%f@k#fff@f@kffff@f@%kfffk%ffkffkf@kfk#k#ffffk#fffk%%f@f@ffffk#f@f@k#k#f@%f@fkk#f@fkkf=%fffkkfk#kfkfkff@k#kf%%fkk#fffffffkkffk%k#f%ffkffkk#k#kff@ffk#fff@ff%fk#f@k#fff@
	f@%kfk#fffkk#fkfkkffkf@k#kf%@f%f@k#fff@f@kffff@f@%ffff%fffffff@kfffk#fffkf@%kffkfff@f@=k#k#%f@k#f@kffffkk#%%f@ffffkfkffkfffff@fkff%k%fffff@kffkkfk#ffff%#f@%f@kff@fff@fkf@ffkf%k#fff@
;PARAMETERS for function  named: yourfunc
;OBF_FUNC_4_PARAM name: myparam
	kfkf%fkkffkf@kfk#kffkfk%%k#fkfkk#ffk#fff@k#kffkfk%ffff%f@fkk#kfkfk#fkf@fk%f%k#kfffkffkk#k#%fffkffkfffk=%fkfff@ffffkffffk%fk%ffkfkfk#fkk#k#k#k#ff%@kfk%k#kffkkffkkfk#kfk#%ffffff
	ff%k#ffkfkfffkfkffkkf%%fkk#fffffffkkffk%ffffk%f@k#f@f@ffk#k#kf%ff%k#k#fkffffk#k#kfk#%kffkf@f@k#k#f@=%k#k#fkffffk#k#kfk#%k%fff@fkfkfkk#kfff%f@%kffkf@fkk#fkkffk%%fkfkfffff@f@k#kf%fk%fkfkfkfkk#k#f@kfffkf%ffffff
;PARAMETERS for function  named: yourfunc_trapdoor
;OBF_FUNC_5_PARAM name: myparam
	k#ffk%kfkffkk#fkkfffffff%#%f@fkffk#f@f@ffff%f%kffkffkffffkf@f@fk%%f@kfkff@fkf@fkkff@kff@%f@kff@f@k#=k%k#ffffkfkffkfkkfk#kffk%ff%kffffff@k#f@fkfkk#f@k#f@%kf%kfffffkff@f@fff@ffkfffkf%#%kfk#k#ffk#fkk#kfk#k#%ffk#
	f%f@fkf@k#ffk#fkfkk#fk%%kfkffffffkfkkff@%%k#fkk#k#fkfkfkkffkf@fk%ff@ffkfffkffffffk=%f@f@k#ffkff@kff@fff@kfk#%%f@ffkfk#fkfkfkkffk%k%f@ffffkfkffkfffff@fkff%ffk%ffkff@f@k#k#k#%k#ffk#

;always use these dumps for function and label fragments when
;doing dynamic obfuscation 
;OBF_FUNC name: testfunction
	f%k#fff@ffkfk#fkfffkfkff%@%fff@fkk#fkfkfk%f%f@f@ffffk#f@f@k#k#f@%%k#k#fkffffk#k#kfk#%kfkfk#k#=f@%fff@fkk#fkfkfk%%k#fff@fkkfkfkfk#ffff%%k#f@kfk#fkfkff%#f%ffkfffffffffk#k#kfk#k#fk%%ffffk#kfk#ffkfffk#f@k#%kfff@kfkf
	k%f@fkf@k#ffk#fkfkk#fk%f%k#fff@ffkffkfkkfkfkffff@%f%k#f@kfk#fkfkff%%f@ffkffffffffffkk#f@f@%%k#ffffkfkffkfkkfk#kffk%fff@kf=f@%f@fkf@fkk#fkfkk#k#fkfk%#%ffk#fffkffk#ffk#fffkkfk#%#fk%fkfkfff@f@fff@kf%fff@kfkf


;OBF_LABEL name: cancelprog
	fkf@%k#f@fkfff@fffff@fkf@f@fk%fffk%ffkfkfk#fkk#k#k#k#ff%@ffk%fffkf@ffffk#kfk#f@ff%kfk#%kfffk#fkk#ffkfffkfff%f@fk=%f@k#f@f@ffk#k#kf%fff@f%kfk#fffkk#fkfkkffkf@k#kf%fkf%fkkfk#kfkffkkf%fk%k#ffffkfkffkfkkfk#kffk%ffffff@k#
	k#fk%f@kfkfkfk#ffk#ff%kf@kf%ffk#fffkffk#ffk#fffkkfk#%#f%f@k#fkkfk#ffk#k#k#%kkfk%fkfkk#f@k#k#k#kfk#f@%#k#fffk=fff@%f@ffffkfkffkfffff@fkff%%fkkff@k#k#kfkff@k#%fkf%f@f@fkfkk#k#f@fffffkf@%fkf%kffff@f@k#fkfkfff@%ffffff@k#


;if you had created 'secure' obfuscation classes then they would 
;have to have dumps for them
;for obfuscated system function calls


;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
%k#ffffkfkffkfkkfk#kffk%kfff%k#fkf@kffkkffff@kfkf%fk#f@%fkf@fkkfkfffffffffff%k#fkk# = 1
%fkf@k#kffkfffkf@f@fffkkf%%fffff@kffkkfk#ffff%%k#f@fkf@kffkf@% = 0

;to set functions as 'rewirable' functions, all you have to do
;is to use the $DUMP_REWIRE_STRAIGHT or the $DUMP_REWIREFUNCPATH
;obfuscator command comments in your code somewhere. No other
;actions by you are necessary. it is however necessary to use one
;of them before the first usage of the function in your program.

;im going to start rewiring the SOMEFUNC() function 
;to the REWIRED_SOMEFUNC() function


;DUMPING SWITCHED 'STRAIGHT' FUNC: switchfrom: SOMEFUNC
kfk%f@kfkff@fkf@fkkff@kff@%%kfkffffffkfkkff@%#k%kffkk#ffk#ffffkf%ff%k#f@fkfkfkf@k#k#k#k#%kkf=f@%fkkff@k#k#kfkff@k#%%fkk#fkf@f@fkk#f@kfk#ff%ffk#%fkfffkkfk#fff@kf%fkk#ff
ffffk%fkk#fffffffkkffk%k#%f@fkffk#f@f@ffff%fkff%kffkk#f@fkf@ffk#f@fk%@f@=%fkf@k#f@kff@kffffffkfk%%kff@k#ffffkffkkf%f%fkf@k#f@kff@f@fkf@%%kfk#fffkk#fkfkkffkf@k#kf%k%fkkff@k#k#kfkff@k#%fk#fkk#ff

;will go to the actual function
%ffk#kff@ffkffkfkfffk%%kfkfk#kffkkf%%f@kffffkk#f@f@kffk%("hello world - REWIRE STRAIGHT TEST")


;DUMPING SWITCHED FUNCS: switchfrom: SOMEFUNC switchto: REWIRED_SOMEFUNC
kf%k#ffkfkfffkfkffkkf%fk#k%fffffff@kfffk#fffkf@%%fkk#f@fkk#k#fff@k#k#%fkkf=k%ffkfk#f@kff@f@ffffkf%f%k#fff@ffkffkfkkfkfkffff@%%fkkfffk#kfffkfk#fkf@f@fk%fk%fff@k#fff@f@fkkfk#kfkfk#%f%k#f@kffkk#fkkf%fkk#f@
%fff@k#fff@f@fkkfk#kfkfk#%%ffk#fkfkk#kfkffkkf%fffk%k#kffkkffkkfk#kfk#%k#f%f@fffkfkf@kff@k#f@f@f@ff%fkff@f@=kfk%kff@k#ffffkffkkf%f%fkfkfffff@f@k#kf%%f@k#fff@f@kffff@f@%fkf%kfkffffffkfkkff@%k#f@

;it will now go to REWIRED_SOMEFUNC instead of SOMEFUNC!
%f@fffkfkf@kff@k#f@f@f@ff%%fkfffkkfk#fff@kf%%ffffk#k#ffkff@f@%("autohotkey rocks - REWIREFUNCPATH TEST")

loop, 4
{
	indexdivby2 := ((a_index // 2) * 2 == a_index) ? fk%f@k#fff@f@kffff@f@%fff%fkf@f@f@fkkff@fkk#ffk#%k#%fkfkfff@f@fff@kf%f@k#fkk# : k%k#kffkf@fff@kfkffkf@kffk%#%fkk#f@fkk#k#fff@k#k#%kff%kfffkfk#kffffkff%f@f%kfffkfk#kffffkff%kfff@
	
	;will take one of the 2 branches and will rewire the function on the fly!
	if (indexdivby2) {	

;DUMPING SWITCHED 'STRAIGHT' FUNC: switchfrom: SOMEFUNC
%f@kff@fff@fkf@ffkf%k%k#f@fkfkfkf@k#k#k#k#%%k#k#fkffffk#k#kfk#%%fffkkfk#kfkfkff@k#kf%fk%fkkfkffkkfk#fkkff@f@fk%kffkkf=%kffkkfkff@kffffff@%f@f%kfkffffffkfkkff@%f%k#ffffkfkffkfkkfk#kffk%%k#f@kffkk#fkkf%#fkk#ff
%kfffkfk#kffffkff%ff%kfkffkk#fkkfffffff%f%f@k#f@kffffkk#%%fkk#fkf@f@fkk#f@kfk#ff%#%fff@fkk#fkfkfk%#ffkff@f@=f@fk%ffkff@f@k#k#k#%fk#%f@fffffffffffkfffkk#ff%fkk#%k#ffffkfkffkfkkfk#kffk%f

	} else {

;DUMPING SWITCHED FUNCS: switchfrom: SOMEFUNC switchto: REWIRED_SOMEFUNC
kf%kffkkfkff@fffkk#kfff%kfk%kfk#fkfkkffkfffkff%%k#fkk#k#fkfkfkkffkf@fk%%k#k#fkfkfff@k#fk%ffkkf=kfk%fkk#f@fkk#k#fff@k#k#%kff%kff@k#k#f@k#kffkfkkff@%k%fkk#f@fkk#k#fff@k#k#%kk%fkkfkffkkfk#fkkff@f@fk%f@
fff%k#ffffkfkffkfkkfk#kffk%k#k#%fkfff@ffffkffffk%%fkk#f@fkk#k#fff@k#k#%fkff@f@=kfk%k#k#ffffkff@kfk#%kf%f@k#fff@f@kffff@f@%k%ffkfk#kffff@f@k#kfk#k#%fkk#f@

	}
	
	;this function can go to either function depending on which
	;path was followed in the if above!
	%fkfkfff@f@fff@kf%%kfkfk#kffkkf%%kffffff@k#f@fkfkk#f@k#f@%("`nLOOP FLIP FLOP TEST`n*EVEN INDEX GOOD, ODD REWIRED*`nmy loop index is: " . a_index)
}

;in this one i am going to use a rewired function that closes its
;own door


;DUMPING SWITCHED 'STRAIGHT' FUNC: switchfrom: yourfunc
%k#fff@ffkfk#fkfffkfkff%%f@k#fkkfk#ffk#k#k#%%k#k#ffffkff@kfk#%%fffkfkffffkfffkf%f@%k#ffkfkfffkfkffkkf%ff@k#fff@=fkf%f@k#kfkff@fkff%@ff%f@fkffk#f@f@ffff%%fkfkfffff@f@k#kf%fffffk
kf%fkf@fkkfkfffffffffff%kf%f@fkf@fkk#fkfkk#k#fkfk%f%kff@kfffkff@ffk#f@fk%%f@k#f@f@ffk#k#kf%ff%k#k#fkffffk#k#kfk#%ffkf=fk%kfkffkk#fkkfffffff%f%ffkfk#kffff@f@k#kfk#k#%@f%fkkff@k#k#kfkff@k#%f%k#f@kffkk#fkkf%fffffk

%kffkkfkff@fffkk#kfff%%fkf@kff@k#fff@%%k#k#kffff@fffffk%("DUMPED 'REWIRE_STRAIGHT' BEFORE CALLING THIS")


;DUMPING SWITCHED FUNCS: switchfrom: yourfunc switchto: yourfunc_trapdoor
f%fkffk#fffkkfffk#%%kffkf@fkk#fkkffk%f@%ffk#fffkffk#ffk#fffkkfk#%f%kfffkfk#kffffkff%%f@fkffk#f@f@ffff%@k#fff@=k#%fkf@k#kffkfffkf@f@fffkkf%k#fk%f@f@ffffk#f@f@k#k#f@%@k#%kff@kfffkff@ffk#f@fk%fffkf
kfk%f@fffkfffffffkkff@kf%fk%k#k#f@f@fffffkf@%k%f@ffffkfkffkfffff@fkff%fff%f@ffkffkfkf@k#fff@f@kfff%kf=k#k%kfk#fkfkkffkfffkff%f%f@kff@fff@fkf@ffkf%kf@k%fkfkkfkfkffkfffkff%%f@fkf@fkk#fkfkk#k#fkfk%fffkf

%fkkffkf@kfk#kffkfk%%kfkfkfkfffffkf%%f@f@fkkffff@fff@f@fk%("DUMPED 'REWIREFUNCPATH' BEFORE CALLING THIS")

%kffkf@fkk#fkkffk%%fkf@kff@k#fff@%%ffkfffffffffk#k#kfk#k#fk%("this call of this function was automatically rewired straight!")


;DUMPING SWITCHED FUNCS: switchfrom: yourfunc switchto: yourfunc_trapdoor
f%kffkf@fkk#fkkffk%k%f@kfkfkfk#ffk#ff%@k%f@fkffk#f@f@ffff%f@%f@k#k#kffkf@k#fkffffkf%#fff@=k#k#f%fkfffkkfk#fff@kf%%k#fkk#k#fkfkfkkffkf@fk%f@k#k%k#k#ffffkff@kfk#%ffkf
k%fkf@kff@kfffk#f@k#%fkf%fff@fkk#fkfkfk%fk%kfk#fffkk#fkfkkffkf@k#kf%ff%ffkff@f@k#k#k#%fkf=k#k%kfffffkffff@fkfkfkkf%fk%fkfffkfkfkffkfk#f@%f@k#%f@k#kfkff@fkff%k%kffkffkffffkf@f@fk%ffkf

%k#fkf@kffkkffff@kfkf%%kfkfkfkfffffkf%%kfk#k#ffk#fkk#kfk#k#%("*THIS SHOULD CALL THE TRAPDOOR AGAIN*")

%f@f@fkfffkkfffffk#%%fkf@kff@k#fff@%%ffkfk#kffff@f@k#kfk#k#%("trap door is now off and should not be called")

exitapp	 
RETURN

;hotkeys SHOULD NOT be obfuscated!
;HOTKEY ORIGINAL NAME: home
home::
	msgbox, home key pressed!
return


;HOTKEY ORIGINAL NAME: RControl & RShift
RControl & RShift::
	msgbox, hello dave
	%f@ffkfk#fkfkfkkffk%f%ffkffffkkffkfff@%%fkfffkkfk#fff@kf%k#k%f@fkfff@k#k#k#kff@%#fkfff@kfkf()
return


;HOTKEY ORIGINAL NAME: ^;
^;::
	msgbox, hello world
	%kfk#fffkk#fkfkkffkf@k#kf%@k%fkkfkff@fffkf@fkkfk#ffkf%%f@fkf@k#ffk#fkfkk#fk%#k#fkfff@kfkf()
return	

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;(technically this one would be all right because it does not call any
;functions or use any variables inside of it)
;FUNCTION ORIGINAL NAME: testfunction
f@k#k#fkfff@kfkf() { 
	global
	msgbox, TESTING OBF OF A FUNCTION CALL:`n`ntestfunction has been called
}


;LABEL ORIGINAL NAME: cancelprog
fff@fffkf@fkfffffff@k#:
	exitapp
return

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;FUNCTION ORIGINAL NAME: SOMEFUNC
f@fkffk#fkk#ff(fkf@fffffkfkfk) { 
	global
	msgbox, inside function: "SOMEFUNC"`n`nparameter was: %k#kff@fkkff@f@f@k#%%fkf@fffffkfkfk%%ffkffkfkkffkk#k#kff@fkf@%
	return fk%fkkff@k#k#kfkff@k#%@fff%f@fkfff@k#k#k#kff@%ff%ffk#kff@ffkffkfkfffk%kfkfk

}

;this function is never called in the unobfuscated script!
;FUNCTION ORIGINAL NAME: REWIRED_SOMEFUNC
kfkfkffkfkk#f@(k#k#ffk#f@k#fff@) { 
	global
	msgbox, inside function: "REWIRED_SOMEFUNC"`n`nparameter was: %k#k#ffk#f@k#fff@%%f@f@fkkffff@fff@f@fk%%ffk#fkk#kfk#kfkfkffkk#fk%`n`n***FUNCTION WAS REWIRED TO THIS FUNCTION***
	return
}


;FUNCTION ORIGINAL NAME: yourfunc
fkf@fffkfffffk(fkf@kfk#ffffff) { 
	global
	
	msgbox, inside 'yourfunc'`nparameter is:`n%fkf@fkkfkffkf@fffk%%fkf@kfk#ffffff%%fkk#kffkfkfkfff@kfff%

}

;this function is never called in the unobfuscated script!
;FUNCTION ORIGINAL NAME: yourfunc_trapdoor
k#k#fkf@k#kfffkf(kfffkfk#ffk#) { 
	global
;this command will close the trap door!

;DUMPING SWITCHED 'STRAIGHT' FUNC: switchfrom: yourfunc
%fkkfffkffkffkff@fkk#fk%f%f@fff@kfkfk#ffffk#%f@k%fkk#f@fkk#k#fff@k#k#%f@k%fkk#kff@fkfffff@kffkff%fff@=f%fkf@k#kffkfffkf@f@fffkkf%kf%kff@k#ffffkffkkf%@%fkk#f@fkk#k#fff@k#k#%%f@f@ffffk#f@f@k#k#f@%fkfffffk
kfk%ffk#fkk#kfk#kfkfkffkk#fk%%kffkffkffffkf@f@fk%kfk%f@k#f@kffffkk#%f%ffkff@f@k#k#k#%ffkf=%k#k#ffffkff@kfk#%k%f@kfkfkfkffkkf%%f@ffffkfkffkfffff@fkff%@f%kffkffkffffkf@f@fk%f%kfffk#fkk#ffkfffkfff%kfffffk


	;maybe do some extra security things here
	
	;i will add something on to the parameter so that it will indicate
	;that i went through this function first!
	%kffkf@fffkk#kfffk#f@fk%%k#kffkf@fff@kfkffkf@kffk%%k#ffk#fffff@kff@f@k#% .= "`n`nI WENT THOUGH A TRAP DOOR named: yourfunc_trapdoor!`n" 
	
	;NOTICE I AM CALLING THE ORIGINAL FUNCTION NOW!
	return %fffff@kffkkfk#ffff%%kfkfkfkfffffkf%%kff@k#ffffkffkkf%(k%ffffffkfkffffkf@fkfkf@%%k#ffffkfkffkfkkfk#kffk%ff%f@fffkfkf@kff@k#f@f@f@ff%kf%k#kff@fkkffkfkk#kfff%k#%fkkff@k#k#kfkff@k#%fk#)
}

