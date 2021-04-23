obf_copyright := " Date: 3:52 PM Tuesday, March 19, 2013          "
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
;of your program will set the obfuscator to do dynamic obfuscation
  
;put a string assignment header like this in your program so that
;the program name and copyright info still shows up in the obfuscated ;version of this program
program_name:="obfclasses.ahk"
program_name:="Author: David Malia, Augusta, ME"
program_name:="Copyright David Malia, 2013"

;these are the minimum DUMP statements you need to use when using
;dynamic obfuscation. none of these would be required
;for 'straight' obfuscation
;ALL FUNCTIONS MUST BE MADE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!

;security fragments and triple mess fragments for common objects
;must be dumped before anything else
	;SECURITY CLASS FRAG: for class: COMMON for char: f
	kfkf%kfffffk#k#kfffkfff%f@fk%fff@ffk#ffk#kfffk#fk%f@k%kfffffffk#f@f@f@k#fkfk%fk#=%fff@fkf@kff@kfk#ff%f%f@fkfffkkfk#kfffkf%
	;SECURITY CLASS FRAG: for class: COMMON for char: k
	fff@%fkffk#k#fkfkfkf@k#kf%%k#fkfkffkfkfffffffk#kff@%k#k%kfffffk#k#fffkk#k#k#k#%#k#fffffff@k#=%fffkffffk#kffkk#k#k#fk%k%ffk#f@kffkk#k#kfffk#f@%
	;SECURITY CLASS FRAG: for class: COMMON for char: @
	f%kfkfkffkkfkfffk#%k%fkk#f@k#kfk#kfkfffff%k#f@%ffk#k#ffk#fffkk#%kff@fkff=%f@k#kffffkk#fkk#fkff%@%kfffffk#k#fffkk#k#k#k#%
	;SECURITY CLASS FRAG: for class: COMMON for char: #
	%ffk#k#k#f@k#kfkffkk#ffkf%k#f@k#%kff@ffkffkfkfkfkk#kf%f@%ffk#k#ffk#fffkk#%ffk#fkf@kfkff@k#=%fffkffffk#kffkk#k#k#fk%#%k#fkfkffkfkfffffffk#kff@%

;TRIPLE MESS FRAGMENTS FOR: f
	f@k#%fkkff@ffk#k#ffkfff%kff@k%fkkff@ffk#k#ffkfff%fk#f%fff@k#k#k#fffffff@k#%fkf@%kfkff@fkf@kfk#%@fffk:=kf%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%f@%kff@f@kffkkff@ffkff@%%kfkff@fkf@kfk#%kf@kfk#
	k%kfk#k#kffkk#ffkf%%k#f@k#f@ffk#fkf@kfkff@k#%k%kfkff@fkf@kfk#%k%k#f@k#f@ffk#fkf@kfkff@k#%f@%fkfkfkf@kfkff@f@fkkf%f@k#f@:=kf%fkffkffffkffff%k%ffk#kff@fffkk#f@fkfkfffk%ff@%kfkff@fkf@kfk#%%fff@k#k#k#fffffff@k#%f@kfk#
	ffk%kfkff@fkf@kfk#%ff%fkffk#f@f@ffk#k#kfkff@fk%%kfkff@fkf@kfk#%kff%kfkff@fkf@kfk#%fk#:=%kffffkfffkffkf%%f@fffkf@f@f@f@fkff%kf%fff@k#k#k#fffffff@k#%ff%fkk#f@kff@fkff%fkf@kfk#
	f%fkk#f@kff@fkff%%kfkff@fkf@kfk#%@f%f@k#kfk#kff@kf%%kfkff@fkf@kfk#%f@f@ffk#:=kfk%kfkff@fkf@kfk#%f%fff@ffk#ffk#kfffk#fk%@f%kff@kfkfkff@fk%k%kfkff@fkf@kfk#%@kfk#
	k#fff@%f@f@fff@kfffkfkff@f@fkf@%ffk%k#f@k#f@ffk#fkf@kfkff@k#%kffff@k%kfkff@fkf@kfk#%f@kf:=k%fkfkk#f@f@f@k#k#ffffk#ff%fk%fff@fkf@kff@kfk#ff%f%kfkff@fkf@kfk#%@%kfkff@fkf@kfk#%%fff@k#k#k#fffffff@k#%f@kfk#
	fkk%fffkkfffk#f@f@kffk%%kfkff@fkf@kfk#%%fff@k#k#k#fffffff@k#%#k#f@%kfkff@fkf@kfk#%fkfkfk#fkk#:=kf%fff@k#k#k#fffffff@k#%ff%k#fkkfk#kfkfkffffkf@fk%@%fkfkfkfkfkkfk#ffffffk#kf%fkf%fkk#f@kff@fkff%kfk#
	%fkkfkffkk#f@f@ff%kfff%kfkff@fkf@kfk#%@kf%fff@k#k#k#fffffff@k#%fkf%fff@k#k#k#fffffff@k#%#kfkf:=k%kfkfkffkkfkfffk#%f%fff@k#k#k#fffffff@k#%ff@%kfkff@fkf@kfk#%kf@%fff@k#k#k#fffffff@k#%fk#
	f@fkfff%fffffkf@fkkfkffkfkfffk%@%fff@k#k#k#fffffff@k#%#ffkff%fff@k#k#k#fffffff@k#%kff@f@kf:=kf%kfk#k#kffkk#ffkf%k%fkkff@f@fff@kffff@kf%%kfkff@fkf@kfk#%f%fkk#f@kff@fkff%%kfkff@fkf@kfk#%kf@kfk#
	f%fffkffffk#kffkk#k#k#fk%%kffkkfkff@fffkkffkkffkff%@%kfkff@fkf@kfk#%kf%fkk#f@kff@fkff%%kfkff@fkf@kfk#%fk#f@ff:=kfkf%kfkff@fkf@kfk#%%f@k#k#fffkfkk#f@ffffkf%@%kfkff@fkf@kfk#%kf@kfk#
	%ffffk#ffkffkkff@k#%fff@%kfkff@fkf@kfk#%@fkf@ff%fff@k#k#k#fffffff@k#%ff@fffkffkf:=%fff@k#k#k#fffffff@k#%fk%fkfkfkf@kfkff@f@fkkf%ff@f%fff@k#k#k#fffffff@k#%f@kfk#
	fkkf%fff@k#k#k#fffffff@k#%ffkf%f@fkfkk#fkfffff@%kf@k%k#f@k#f@ffk#fkf@kfkff@k#%ffffk#k#:=kf%fkffk#k#k#k#ffkfk#%kff%ffk#f@kffkk#k#kfffk#f@%%fkk#f@kff@fkff%fkf%fkk#f@kff@fkff%kfk#
	%kfkff@fkf@kfk#%@fkk%kfkff@fkf@kfk#%k%kfkffkf@f@fkf@%#ffk#ffk#f@k#:=kf%fffkf@f@f@f@fk%kff%fkk#f@kff@fkff%f%fff@k#k#k#fffffff@k#%f@kfk#
	kfkf%f@fkk#f@fkfkkffffkff%%kfkff@fkf@kfk#%ff%kfkff@fkf@kfk#%fff@fkk#f@:=%fff@k#k#k#fffffff@k#%fk%kff@k#fkkfkffkfk%ff%fkk#f@kff@fkff%fkf%fkk#f@kff@fkff%kfk#
	f@f%fffkfkfkf@f@kffff@%f%kfkff@fkf@kfk#%fffk%k#f@k#f@ffk#fkf@kfkff@k#%kff@f@f@ffk#f@:=k%fkffk#f@f@ffk#k#kfkff@fk%f%fff@k#k#k#fffffff@k#%ff@%kfkff@fkf@kfk#%kf%fkk#f@kff@fkff%kfk#
	f@fk%f@fffff@fffkf@k#f@f@fff@%%fff@k#k#k#fffffff@k#%#k#k#%kfkff@fkf@kfk#%ff@f%kfkff@fkf@kfk#%fkf@fk:=kf%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%f@f%fff@k#k#k#fffffff@k#%%k#kfkfkfk#ffkf%f@kfk#
	fk%kfkff@fkf@kfk#%f%fff@k#k#k#fffffff@k#%%fkfkkffkk#f@kffkk#fkf@%fkfk%fkfkfkfkfkkfk#ffffffk#kf%#f@fff@:=k%kfkff@fkf@kfk#%kf%fkkff@f@kfk#ffff%f%fkk#f@kff@fkff%fkf%f@fkfffkkfk#kfffkf%@kfk#
	%kfkff@fkf@kfk#%kf%kfkff@fkf@kfk#%k#f%kfkfkffkkfkfffk#%ff@ffk#fkf@fkk#ff:=kf%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%%kfk#k#kffkk#ffkf%f@f%ffk#k#ffk#fffkk#%kf@kfk#
	f%fkk#k#f@fff@fff@ffffffkf%ffffkf%kfkff@fkf@kfk#%k%kfkff@fkf@kfk#%k#fkffkfkfkff@:=%fff@k#k#k#fffffff@k#%%ffk#f@kffkk#k#kfffk#f@%f%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%f%f@fkk#f@fkfkkffffkff%@fkf@kfk#
	fkk#k%fkkfkffkk#f@f@ff%#k#%kfkff@fkf@kfk#%kk#%fff@k#k#k#fffffff@k#%#ff:=kfk%kfffffk#k#kfffkfff%f%kfkff@fkf@kfk#%@fkf%fkk#f@kff@fkff%kfk#
	%f@kffkf@kfk#k#k#fkkfff%kf%kfkff@fkf@kfk#%@%fkfkk#f@f@f@k#k#ffffk#ff%k#f%fkk#f@kff@fkff%k#f%kfkff@fkf@kfk#%f@fffff@f@fk:=kf%fff@k#kffkffk#fffffk%kf%kfkff@fkf@kfk#%%fkk#f@kff@fkff%f%fff@k#k#k#fffffff@k#%f@kfk#
;TRIPLE MESS FRAGMENTS FOR: k
	fk%f@k#kffffkk#fkk#fkff%f%kfkff@fkf@kfk#%fkk%kfkff@fkf@kfk#%%k#k#f@k#k#ffkffffff@fk%fkf%kfkff@fkf@kfk#%kfk#:=f%fffffkf@fkkfkffkfkfffk%ff@k%kffff@ffkffkffkff@%#k#k%k#f@k#f@ffk#fkf@kfkff@k#%ff%kfkff@fkf@kfk#%fff%kfkff@fkf@kfk#%@k#
	f@kf%fff@k#k#k#fffffff@k#%ffkf%fff@k#k#k#fffffff@k#%k#ff%kfkff@fkf@kfk#%fkff%f@fkfffkkfk#kfffkf%@:=fff@%fff@k#k#k#fffffff@k#%%f@fffkffk#k#fff@ffk#f@%#k%fff@k#kffkffk#fffffk%#%fff@k#k#k#fffffff@k#%%k#f@k#f@ffk#fkf@kfkff@k#%fffffff@k#
	%k#k#ffffkffkk#k#f@k#ffff%k%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%@kfk%kfkff@fkf@kfk#%f@kfffk#kfkf:=%kfkff@fkf@kfk#%ff@k%kffff@ffkffkffkff@%#k#k#%kfkff@fkf@kfk#%ffff%kfffffffk#f@f@f@k#fkfk%ff@k#
	kff@%kfkff@fkf@kfk#%@k%kff@f@kffkkff@ffkff@%%k#f@k#f@ffk#fkf@kfkff@k#%%kfkff@fkf@kfk#%ff@kfkf:=%f@fkk#k#fkf@fkk#k#%%k#fffkkfk#k#ffk#kfk#%f%kfkff@fkf@kfk#%f@k#%fff@k#k#k#fffffff@k#%#k#%kfkff@fkf@kfk#%ffffff@k#
	ffkfk#%kfkff@fkf@kfk#%@%kfkff@fkf@kfk#%@kffk%kfkff@fkf@kfk#%@%kfk#k#kffkk#ffkf%kfffkfk#:=f%f@fffkffk#k#fff@ffk#f@%ff%fkk#f@kff@fkff%k#%fff@k#k#k#fffffff@k#%%k#f@k#f@ffk#fkf@kfkff@k#%k#fffffff@k#
	f@k#kf%f@k#kfk#kff@kf%fkk%f@f@kfk#f@ffk#%fk#f%fff@k#k#k#fffffff@k#%f@ff%kfkff@fkf@kfk#%kkfk#:=fff%kfkff@k#ffffk#fff@%@%kffffkfffkffkf%k#k#%fff@k#k#k#fffffff@k#%%k#f@k#f@ffk#fkf@kfkff@k#%f%kfkff@fkf@kfk#%fffff@k#
	kf%f@fkf@kffkf@kff@%ffkf%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%fff@f@k#:=fff%fkffk#f@f@ffk#k#kfkff@fk%@%f@k#ffk#fkfkk#%k%k#f@k#f@ffk#fkf@kfkff@k#%%fff@k#k#k#fffffff@k#%#k#f%kfkff@fkf@kfk#%fffff@k#
	f%fkffk#f@f@ffk#k#kfkff@fk%fffk%k#f@k#f@ffk#fkf@kfkff@k#%%ffffkfkffkfkfk%%fff@k#k#k#fffffff@k#%ff%fff@k#k#k#fffffff@k#%fkfkkff@f@:=fff@%f@ffkfk#kfkffffff@fkf@kf%k#k#k%k#f@k#f@ffk#fkf@kfkff@k#%ffff%kfkff@fkf@kfk#%ff@k#
	k#k#%f@fffkfkk#fkk#%f%ffk#f@kffkk#k#kfffk#f@%kk%kfkff@fkf@kfk#%kfk#%fff@k#k#k#fffffff@k#%fkf:=%kfkff@fkf@kfk#%ff%f@fff@fff@fkf@fkkffkff%@k#k%k#f@k#f@ffk#fkf@kfkff@k#%k#fffffff@k#
	k#k#%kfkfkffkkfkfffk#%f@k#%kfffffffk#f@f@f@k#fkfk%kff%fkk#f@kff@fkff%fk%fff@k#k#k#fffffff@k#%f%fff@k#k#k#fffffff@k#%ffkfkk#:=fff@k%kffffkfffkffkf%#k#k#%kfkff@fkf@kfk#%f%kfkff@fkf@kfk#%fff%kfkff@fkf@kfk#%@k#
	ffkf%fkfkk#fff@fkk#fff@fkf@%%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%f@kfff%fff@k#k#k#fffffff@k#%ffkffk#ffk#:=fff@k%fffkfkfkf@f@kffff@%#%kfkfkffkkfkfffk#%k#%fff@k#k#k#fffffff@k#%#ffff%kfkff@fkf@kfk#%ff@k#
	f@ff%fff@k#k#k#fffffff@k#%fk%k#kfkffffkfffff@kff@%#f@%kfkff@fkf@kfk#%ffk%kfkff@fkf@kfk#%@f@k#ff:=f%kfkff@fkf@kfk#%f@%fff@k#k#k#fffffff@k#%#k#%kfk#f@fkk#kfffk#k#fkkf%k#ff%kfkff@fkf@kfk#%ffff@k#
	k#%fff@f@fkfkf@f@kff@%k#fk%fkffk#k#fkfkfkf@k#kf%k%kfkff@fkf@kfk#%%fff@k#k#k#fffffff@k#%fkfffkffkfffk:=fff@%f@kffkf@kfk#k#k#fkkfff%k#k#k%k#f@k#f@ffk#fkf@kfkff@k#%ffff%kfkff@fkf@kfk#%ff@k#
	k#%kfkff@fkf@kfk#%ffk%kfkff@fkf@kfk#%@ff%k#k#ffffkffkk#k#f@k#ffff%fkfkkffk:=f%kfkff@fkf@kfk#%f@k#%f@kfffk#fkffffk#k#fk%k#k#ff%kfkff@fkf@kfk#%ffff@k#
	f%f@fffkf@f@f@f@fkff%k%fff@k#k#k#fffffff@k#%#k#%kfkff@fkf@kfk#%@kffkk#:=fff@%kfk#kfkffff@fkkfkfkf%%kff@f@fff@kfkf%k#%fff@k#k#k#fffffff@k#%#k#%kfkff@fkf@kfk#%ffff%kfkff@fkf@kfk#%f@k#
	kff%kfkff@fkf@kfk#%%kff@f@kffkkff@ffkff@%f%fff@k#k#k#fffffff@k#%k#%kfkff@fkf@kfk#%kk#ffk#kf:=fff%fff@fkf@kff@kfk#ff%@k#k%k#f@k#f@ffk#fkf@kfkff@k#%k%k#f@k#f@ffk#fkf@kfkff@k#%ff%kfkff@fkf@kfk#%ffff@k#
	k%fffkkfffk#f@f@kffk%fkfk#f%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%fff%fff@k#k#k#fffffff@k#%#f@kff@fff@:=%f@k#k#fffkfkk#f@ffffkf%%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%f@k#k#k#fffffff@k#
	k%ffk#kff@fffkk#f@fkfkfffk%#f@ff%k#fkfkffkfkfffffffk#kff@%ffk%k#f@k#f@ffk#fkf@kfkff@k#%f%fkk#f@kff@fkff%k#f@kffk:=ff%ffffkfkffkfkfk%f@k#k%f@fffff@fffkf@k#f@f@fff@%#%fff@k#k#k#fffffff@k#%#ff%kfkff@fkf@kfk#%ffff@k#
	k#%fffkffffk#kffkk#k#k#fk%%kfkff@fkf@kfk#%@f%fff@k#k#k#fffffff@k#%fffff@k#kffk:=%fff@fkf@kff@kfk#ff%fff%fkk#f@kff@fkff%%k#kfkffffkfffff@kff@%k#%fff@k#k#k#fffffff@k#%#k%k#f@k#f@ffk#fkf@kfkff@k#%fffffff@k#
	f@f@%fkfkk#f@f@f@k#k#ffffk#ff%k#ff%kfkff@fkf@kfk#%@%kfkff@fkf@kfk#%k%kfkff@fkf@kfk#%ffk:=fff@%fff@k#k#k#fffffff@k#%#k%ffk#k#k#f@k#kfkffkk#ffkf%#%ffk#k#k#f@k#kfkffkk#ffkf%k#%kfkff@fkf@kfk#%ff%kfkff@fkf@kfk#%fff@k#
;TRIPLE MESS FRAGMENTS FOR: @
	fkk%kffkf@f@k#kfk#kfk#k#%#fk%kfffffffk#f@f@f@k#fkfk%%fff@k#k#k#fffffff@k#%ff@%kfkff@fkf@kfk#%@k%k#f@k#f@ffk#fkf@kfkff@k#%f@fkkffkff:=%kfkff@fkf@kfk#%k%fff@k#k#k#fffffff@k#%%f@k#ffk#fkfkk#%%f@fkfffkkfk#kfffkf%%k#f@k#f@ffk#fkf@kfkff@k#%f@kff@fkff
	f@f@f%ffkffkf@fkkff@fffkk#k#%%kfkff@fkf@kfk#%fkfk%fff@k#k#k#fffffff@k#%fk%k#f@k#f@ffk#fkf@kfkff@k#%f@kfkff@:=fk%fff@k#k#k#fffffff@k#%%k#f@k#f@ffk#fkf@kfkff@k#%%k#kfkffffkfffff@kff@%f@%kfk#fffkfkf@f@k#f@k#f@kf%kff@fkff
	fk%kfkff@fkf@kfk#%kfkf%kffkfffkfkffk#fkfkkf%fff%fff@k#k#k#fffffff@k#%#%fff@k#k#k#fffffff@k#%fk#ffkf:=fk%fff@k#k#k#fffffff@k#%#f%fkk#f@kff@fkff%kf%kfk#f@fkk#kfffk#k#fkkf%%kfkff@fkf@kfk#%@f%fkfkkffff@k#f@fkf@fk%kff
	f@%kff@f@kffkkff@ffkff@%f@k%kfkff@fkf@kfk#%fkf%kfk#kfkffff@fkkfkfkf%@k%k#f@k#f@ffk#fkf@kfkff@k#%f@%kfkff@fkf@kfk#%@f@f@:=fkk%k#f@k#f@ffk#fkf@kfkff@k#%f%fkk#f@kff@fkff%kff%k#fkkffkkfk#fkfk%@fkff
	%f@fff@fff@fkf@fkkffkff%fk%kfkff@fkf@kfk#%@f%fkk#f@kff@fkff%%fkffk#k#fkfkfkf@k#kf%f%fff@k#k#k#fffffff@k#%fffkfkkf:=%ffffk#ffkffkkff@k#%fkk%fkfffffffkk#fkf@k#f@%#f%fkk#f@kff@fkff%k%kfkff@fkf@kfk#%f@fkff
	%fkkff@f@fff@kffff@kf%fkk%k#f@k#f@ffk#fkf@kfkff@k#%k%fkfkkffff@k#f@fkf@fk%f%kfkff@fkf@kfk#%@f@kfffk#:=fk%fffkfkfkf@f@kffff@%%ffk#kff@fffkk#f@fkfkfffk%%fff@k#k#k#fffffff@k#%#f%fkk#f@kff@fkff%kff@fkff
	k#f%f@f@fff@kfffkfkff@f@fkf@%ffkk%kfkff@fkf@kfk#%ffff%fff@k#k#k#fffffff@k#%#%fff@k#k#k#fffffff@k#%ffffk:=fk%fff@k#k#k#fffffff@k#%#f@%f@fkk#f@fkfkkffffkff%kff%fkk#f@kff@fkff%fkf%kfkff@fkf@kfk#%
	k#%f@fkk#f@fkfkkffffkff%f%fff@k#k#k#fffffff@k#%kf%kfkff@fkf@kfk#%f%kff@fkfkffkfkffk%f%kfkff@fkf@kfk#%ffffk#k#f@kffk:=fk%fff@k#k#k#fffffff@k#%#%f@fkkfkffkfkk#ff%%kfkff@fkf@kfk#%@%f@k#k#fffkfkk#f@ffffkf%k%kfkff@fkf@kfk#%f@fkff
	k#%fff@k#k#k#fffffff@k#%#kfff%fff@k#k#k#fffffff@k#%#kff%k#k#f@k#k#ffkffffff@fk%%k#kff@fkk#f@kf%fkff@f@k#:=%kfkff@fkf@kfk#%kk#%k#fffkkfk#k#ffk#kfk#%%fkkff@f@kfk#ffff%%kfkff@fkf@kfk#%@kff@fkff
	fffkk#%fff@k#k#k#fffffff@k#%#f%fff@k#k#k#fffffff@k#%kffff@%kfkff@fkf@kfk#%k%ffk#f@kffkk#k#kfffk#f@%fkk#ff:=%kfkff@fkf@kfk#%kk#%kfkff@fkf@kfk#%%fkk#f@kff@fkff%kff%fffkf@f@f@f@fk%@fkff
	f@k%kffffkffk#k#f@fkkf%%kfkff@fkf@kfk#%fkf%fkk#f@kff@fkff%f%fkk#f@kff@fkff%fff@:=fkk%k#f@k#f@ffk#fkf@kfkff@k#%f@%f@k#ffk#fkfkk#%k%kfkff@fkf@kfk#%f@%kfk#fffff@fffkfffff@ff%fkff
	ffk%f@kffkf@kfk#k#k#fkkfff%#k%kfkff@fkf@kfk#%fk%fff@k#k#k#fffffff@k#%#fkf@ff:=fk%fff@k#k#k#fffffff@k#%%kfffffk#k#fffkk#k#k#k#%%k#f@k#f@ffk#fkf@kfkff@k#%f@%fff@k#k#k#fffffff@k#%ff@fkff
	%ffk#k#k#f@k#kfkffkk#ffkf%k%k#f@k#f@ffk#fkf@kfkff@k#%kff%fff@k#k#k#fffffff@k#%f%fkk#f@kff@fkff%kffk%kff@k#fkkffkfkfffkfkff%kfffkfkff@:=%kfk#kfkffff@fkkfkfkf%%kfkff@fkf@kfk#%kk%f@k#ffk#fkfkk#%#f@%fff@k#k#k#fffffff@k#%ff@fkff
	%fffkf@fffffkfkfkk#%%fff@fkfkf@kfk#%f@f%fff@k#k#k#fffffff@k#%f%fkk#f@kff@fkff%%kfkff@fkf@kfk#%ff@k#kffkfkffk#:=fk%kff@fkfkffkfkffk%%kffff@ffkffkffkff@%k#%kfkff@fkf@kfk#%%fkk#f@kff@fkff%k%kfkff@fkf@kfk#%f@fkff
	%kfffffk#k#fffkk#k#k#k#%k#k%kff@f@fff@kfkf%%kfkff@fkf@kfk#%f@%kfkff@fkf@kfk#%@kf%fff@k#k#k#fffffff@k#%#kfkfkf:=f%k#fkkfk#kfkfkffffkf@fk%kk%fff@ffk#ffk#kfffk#fk%#%kfkff@fkf@kfk#%%fkk#f@kff@fkff%%fff@k#k#k#fffffff@k#%ff@fkff
	k%k#f@k#f@ffk#fkf@kfkff@k#%k#%ffkffkf@fkkff@fffkk#k#%ffff%fff@k#k#k#fffffff@k#%fk%kffffkffk#k#f@fkkf%#%kfkff@fkf@kfk#%@fkf@k#f@:=f%fff@k#k#k#fffffff@k#%k#%kfkff@fkf@kfk#%@k%kfkff@fkf@kfk#%%ffkffkf@fkkff@fffkk#k#%%kfk#kfkffff@fkkfkfkf%f@fkff
	kff%fff@k#kffkffk#fffffk%kf@k#%fff@k#k#k#fffffff@k#%f%f@k#kffffkk#fkk#fkff%k%kfkff@fkf@kfk#%k#fkfkkf:=%kfkff@fkf@kfk#%k%fff@k#k#k#fffffff@k#%#%f@f@kfk#f@ffk#%%f@kffkf@kfk#k#k#fkkfff%f%fkk#f@kff@fkff%kff@fkff
	k#k%k#f@k#f@ffk#fkf@kfkff@k#%%f@fffff@fffkf@k#f@f@fff@%f@k#%fff@k#k#k#fffffff@k#%ff@f%fkk#f@kff@fkff%f@:=fkk%k#f@k#f@ffk#fkf@kfkff@k#%f@%fff@k#k#k#fffffff@k#%f%fff@fkf@kff@kfk#ff%f@f%f@f@kfk#f@ffk#%kff
	%fff@k#k#k#fffffff@k#%ff%k#fkkffkkfk#fkfk%@kf%fff@k#k#k#fffffff@k#%#f%f@fkk#k#fkf@fkk#k#%ffkffffk#k#:=f%fff@ffk#ffk#kfffk#fk%kk#%kfkff@fkf@kfk#%%fkk#f@kff@fkff%kff@fkff
	%f@fkk#f@fkfkkffffkff%f%fff@fkfkf@kfk#%kk%kfkff@fkf@kfk#%f%kfkff@fkf@kfk#%k%k#f@k#f@ffk#fkf@kfkff@k#%fkf@kf:=%f@fkf@kffkf@kff@%%fkfkkffff@k#f@fkf@fk%%kfkff@fkf@kfk#%k%fff@k#k#k#fffffff@k#%#f@kff@fkff
;TRIPLE MESS FRAGMENTS FOR: #
	fk%fffkffffk#kffkk#k#k#fk%k%kfkff@fkf@kfk#%%fff@k#k#k#fffffff@k#%%f@fkk#k#fkf@fkk#k#%#kf%kfkff@fkf@kfk#%kkff@kf:=%fff@k#k#k#fffffff@k#%#%f@fkfffkkfk#kfffkf%%fffkfkffffk#fkf@f@f@k#fk%f@k%k#f@k#f@ffk#fkf@kfkff@k#%%kfkff@fkf@kfk#%@ffk#fkf@kfkff@k#
	k#ff%fkffk#k#fkfkfkf@k#kf%%kfkff@fkf@kfk#%@fk%kfkff@fkf@kfk#%%fkk#f@kff@fkff%fff@f@kf:=k#%fkkff@f@fff@kffff@kf%f@k%k#f@k#f@ffk#fkf@kfkff@k#%f@f%kfkff@fkf@kfk#%k%k#f@k#f@ffk#fkf@kfkff@k#%fkf@kfkff@k#
	%kfkff@fkf@kfk#%%fkk#f@kff@fkff%%fff@k#k#k#fffffff@k#%#f@f%k#kfkfkfk#ffkf%fkfffffffk#:=k%fkfkkffkk#f@kffkk#fkf@%#f%fkk#f@kff@fkff%k%k#f@k#f@ffk#fkf@kfkff@k#%f%fkk#f@kff@fkff%ff%kfk#k#kffkk#ffkf%k#fkf@kfkff@k#
	f@k#%fff@k#k#k#fffffff@k#%%f@fkf@kffkf@kff@%%k#f@k#f@ffk#fkf@kfkff@k#%k#k%kfkff@fkf@kfk#%k#k#ff:=k#%f@fkk#k#fkf@fkk#k#%f@%ffkfffkfkfkffkkfk#k#fkf@%k#f@f%kfkff@fkf@kfk#%k#f%fff@k#k#k#fffffff@k#%f@kfkff@k#
	fffk%kfkff@fkf@kfk#%@f%fkk#f@kff@fkff%kfk#%kfkff@fkf@kfk#%f%kfk#k#kffkk#ffkf%%fkkff@f@fff@kffff@kf%k#fffk:=k#f@k%k#f@k#f@ffk#fkf@kfkff@k#%f@%kfkfkffkkfkfffk#%ffk%kfk#fffff@fffkfffff@ff%#f%fff@k#k#k#fffffff@k#%f@kfkff@k#
	fk%kfkff@fkf@kfk#%ff%fff@k#k#k#fffffff@k#%k%f@k#f@fkk#fkkff@kf%ffkk%kfkff@fkf@kfk#%k#f@:=k%fkfkkffff@k#f@fkf@fk%%k#f@k#f@ffk#fkf@kfkff@k#%%kfffffffk#f@f@f@k#fkfk%f@%fff@k#k#k#fffffff@k#%#%kfkff@fkf@kfk#%@ffk#fkf@kfkff@k#
	fkk%kff@k#fkkfkffkfk%%k#f@k#f@ffk#fkf@kfkff@k#%%kfkff@fkf@kfk#%kff%kfkff@fkf@kfk#%@ffff:=k#%kfkff@fkf@kfk#%@k#f@%kfkff@fkf@kfk#%fk#fkf%fkffk#f@f@ffk#k#kfkff@fk%@kfkff@k#
	f%fkk#f@kff@fkff%kfkf%fff@k#k#k#fffffff@k#%#ffk%f@fkfffkkfk#kfffkf%#kff@k#kf:=%fff@k#k#k#fffffff@k#%%k#f@k#f@ffk#fkf@kfkff@k#%f@k#%kfkff@fkf@kfk#%@ffk%k#k#f@k#k#ffkffffff@fk%#fk%ffffkfkffkfkfk%f@kfkff@k#
	k#k%kfkff@fkf@kfk#%fkf@f%kffkf@fkfkk#ff%%fff@k#k#k#fffffff@k#%fkkffff@k#:=k#f@%k#kfk#fkf@k#fkff%k#f@%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%k#f%fff@k#k#k#fffffff@k#%f@kfkff@k#
	fff@%kfffffk#k#fffkk#k#k#k#%kfk%kfkff@fkf@kfk#%k#k#%fff@k#k#k#fffffff@k#%fk#k%kfkff@fkf@kfk#%kf:=k#f@%fff@k#k#k#fffffff@k#%#f%kffff@ffkffkffkff@%@%kfkff@fkf@kfk#%fk#fkf@kfkff@k#
	%kff@kfkfkff@fk%fkfk%kfkff@fkf@kfk#%@fkf%fkk#f@kff@fkff%k#f%kfkff@fkf@kfk#%fkfkffkf:=k#f%fkk#f@kff@fkff%%fff@k#k#k#fffffff@k#%#%kfkffkf@f@fkf@%%fff@fkfkf@kfk#%f@ff%fff@k#k#k#fffffff@k#%#fkf@kfkff@k#
	kfk#%kfkff@fkf@kfk#%@%fff@k#k#k#fffffff@k#%fff%kffkf@f@k#kfk#kfk#k#%kfff:=k#f@k#%kff@k#fkkffkfkfffkfkff%f@ff%fff@k#k#k#fffffff@k#%#fkf@k%kfkff@fkf@kfk#%kff@k#
	%kfkff@fkf@kfk#%@fk%fff@k#k#k#fffffff@k#%#ff%f@k#kfk#kff@kf%%f@fkfkk#fkfffff@%fff%fkk#f@kff@fkff%f@fkfk:=k%k#f@k#f@ffk#fkf@kfkff@k#%f@%fff@k#k#k#fffffff@k#%#f%kfkff@k#ffffk#fff@%@%ffkffkf@fkkff@fffkk#k#%ff%fff@k#k#k#fffffff@k#%#fkf@kfkff@k#
	k%kffkfffkfkffk#fkfkkf%fffk%k#f@k#f@ffk#fkf@kfkff@k#%fkf@k%kfkffkf@f@fkf@%f%kfkff@fkf@kfk#%fkfkfffkf:=k#f@%fff@k#k#k#fffffff@k#%#f%f@fff@fff@fkf@fkkffkff%@f%kfffffk#k#fffkk#k#k#k#%fk#f%fff@k#k#k#fffffff@k#%%kfkff@fkf@kfk#%@kfkff@k#
	fkk#%f@fffkffk#k#fff@ffk#f@%fk%fkfkkffff@k#f@fkf@fk%f%kfkff@fkf@kfk#%kf%kfkff@fkf@kfk#%ffkk#fkff:=k%k#f@k#f@ffk#fkf@kfkff@k#%%kfkff@fkf@kfk#%@k#%kfkff@fkf@kfk#%@%k#kfkffffkfffff@kff@%ffk%f@fkk#f@fkfkkffffkff%#fkf@kfkff@k#
	f@ff%fff@k#k#k#fffffff@k#%#k#f%kfkff@fkf@kfk#%%kfkff@fkf@kfk#%ffkf%f@k#k#fffkfkk#f@ffffkf%@%kfffffk#k#kfffkfff%k#f@:=k%k#f@k#f@ffk#fkf@kfkff@k#%f@k#f@%kfkff@fkf@kfk#%f%fff@k#k#k#fffffff@k#%#fk%kff@k#fkkfkffkfk%f@kfkff@k#
	fkk%k#f@k#f@ffk#fkf@kfkff@k#%f%kfkff@fkf@kfk#%f@%fff@k#k#k#fffffff@k#%%fffkfkfkf@f@kffff@%#k%k#fkfkffkfkfffffffk#kff@%#f@fffk:=k#f%fkfkk#fff@fkk#fff@fkf@%@k%fkfkk#fff@fkk#fff@fkf@%#%kfkff@fkf@kfk#%%fkk#f@kff@fkff%ffk%k#f@k#f@ffk#fkf@kfkff@k#%fkf@kfkff@k#
	%f@k#k#fffkfkk#f@ffffkf%f@f%fff@k#k#k#fffffff@k#%k#fkf%fff@k#k#k#fffffff@k#%kff%kfkff@fkf@kfk#%k#kfk#:=%k#k#f@k#k#ffkffffff@fk%k#f@k#f%fkk#f@kff@fkff%ff%fff@k#k#k#fffffff@k#%#fkf@kfkff@k#
	k%ffk#k#k#f@k#kfkffkk#ffkf%#k%k#f@k#f@ffk#fkf@kfkff@k#%k#fkf%fffkf@f@f@f@fk%%fkk#f@kff@fkff%f@k#f@k#f@k#ff:=k#f@k%k#f@k#f@ffk#fkf@kfkff@k#%f@ffk#%kff@k#fkkffkfkfffkfkff%fkf@kfk%kfkff@fkf@kfk#%f@k#
	fkff%kfffffffk#f@f@f@k#fkfk%%kfkff@fkf@kfk#%kk%kfkff@fkf@kfk#%fkk%kfffffk#k#kfffkfff%#ffff:=k%k#f@k#f@ffk#fkf@kfkff@k#%f@k#%kfkff@fkf@kfk#%@%kfkff@fkf@kfk#%fk%f@fkfkk#fkfffff@%#fkf@kfkff@k#

;dump variable fragments 
;OBF_GLOBVAR name: mytrue
	ff%f@k#kffkkfk#fkf@fffkkfk#%%k#kfkffffkfffff@kff@%%f@fkk#fffff@f@fkfk%fkf%f@fkf@ffk#f@ff%f@k#k#=kffk%k#fff@ffk#kffff@kff@kf%k%fkk#k#f@kffkk#%ff@f%fffkfkfkf@f@kffff@%fk%fkk#fkf@fkk#kfk#k#%#kf
	fff%kff@k#fkkfkffkfk%@%k#f@ffffk#f@k#f@kffk%#f%k#f@fkfffff@k#kffk%%ffkffffkffffk#%kkfkf=kf%f@f@fff@kfffkfkff@f@fkf@%fkfkk%kffff@kfkfkfk#kfkf%f%fkk#kff@f@kfffk#%ffk#kf
	k%ffk#f@kffkk#k#kfffk#f@%#f%kffkf@k#kfkfk#fkfkkf%%k#fff@ffk#kffff@kff@kf%@ff%fkkfkffkfkf@k#ffffk#k#%ffkk#=kffk%f@f@fff@f@ffk#%%kffff@ffkffkffkff@%kkf%ffkffkf@fkkff@fffkk#k#%f@f%kffff@kfkfkfk#kfkf%k#kf
;OBF_GLOBVAR name: myfalse
	k%fkk#fkf@fkk#kfk#k#%#f@%k#fff@ffk#kffff@kff@kf%kf%f@fkk#k#k#fff@fffkf@fk%fkf@kffk=ffkff%fkfkk#fff@fkk#fff@fkf@%@fkk#%ffkfkff@kfffkffkffk#ffk#%fkffk
	%kfk#f@fkk#kfffk#k#fkkf%%f@k#kff@kfk#fkfkf@f@fffk%%fff@f@fkfkf@f@kff@%kk%fkk#fkffkffffkk#fkff%ff%fkffk#fff@ffk#fkf@fkk#ff%@k#k#fk=ffkf%kff@k#fkkffkfkfffkfkff%f@fk%k#f@ffffk#f@k#f@kffk%#kfkf%ffkffffkffffk#%k
	f%f@f@kffkf@k#f@f@f@f@%%k#fff@ffk#kffff@kff@kf%kk%fffkf@f@kfk#ffk#fffk%kf%kffkfffkfkffk#fkfkkf%ff%fffkf@f@f@f@fk%kfk#=%f@fffkffk#k#fff@ffk#f@%ffk%k#kfk#f@f@k#f@%f@fk%k#k#fkkfkfkfffkffkfffk%#kfkffk
;OBF_GLOBVAR name: securitypassed
	kfff%fkffk#f@f@ffk#k#kfkff@fk%f@fk%fkk#k#k#fkk#k#ff%ff%f@kfkffkfkk#ffffkff@%f@fk=ff%kff@kfkff@kfffk#kfkf%%fkk#f@k#kfk#kfkfffff%#f@k%k#k#k#fkf@f@k#f@k#f@k#ff%k#f@fk
	f%ffkfffkfkfkffkkfk#k#fkf@%ff%kfffffffk#f@f@f@k#fkfk%k%ffkffffkffffk#%f%kfkfk#ffffffk#f@kff@fff@%fk#k#=ff%ffk#kff@fffkk#f@fkfkfffk%k%f@kffkf@kfk#k#k#fkkfff%#%fkk#k#k#fkk#k#ff%@k#%fkk#k#f@kffkk#%#f@fk
	fkk%f@f@fff@f@ffk#%fffff%k#fffkkfk#k#ffk#kfk#%@ff%k#fff@ffk#kffff@kff@kf%@fk=%f@k#kff@kfk#fkfkf@f@fffk%fk#%k#kfk#f@f@k#f@%@k#%k#fffkkfk#k#ffk#kfk#%k#%f@fff@fff@fkf@fkkffkff%f@fk
;OBF_GLOBVAR name: usermessage
	%kfkffffffff@fkk#f@%fk#%fkfffkkffkffkfk#%#f%kff@kfkfkff@fk%kf@%f@fffkfkk#fkk#%k#k#f@=fff%kfk#fffff@fffkfffff@ff%%kfkffkf@f@fkf@%kk%fkk#fff@k#k#f@fffk%ff%ffkfk#f@f@kffkf@kfffkfk#%ffk%ffffk#kffkfkfkkff@f@%fkff@
	fk%fffffkffkfk#fkffkfkfkff@%f%f@fkk#k#k#fff@fffkf@fk%kf%fkk#k#f@fff@fff@ffffffkf%kf%fffkfkk#k#fkkffkk#fkf@ff%@ffkf=f%kffkfffkfkffk#fkfkkf%ff%ffffkfkffkfkfk%kk#%kfkffffffff@fkk#f@%%f@f@fff@f@ffk#%k%fkk#k#k#fkk#k#ff%fkkfkff@
	fff%ffkfkff@kfffkffkffk#ffk#%k#f%fff@f@fkf@ffkff@fffkffkf%fkk%f@ffkfk#kfkffffff@fkf@kf%ff@=f%ffk#kff@fffkk#f@fkfkfffk%ffk%f@fkk#k#fkf@fkk#k#%k#ff%kff@f@k#fff@kfkf%f%k#fff@ffk#kffff@kff@kf%kkfkff@
;OBF_GLOBVAR name: hexdigits
	f%fkffkffffkffff%%kffkf@k#kfkfk#fkfkkf%f@k%kfkffffffff@fkk#f@%%f@k#kff@kfk#fkfkf@f@fffk%@fkff=k#%kffkfkkffff@f@fkf@fkffkf%kfk#%fkkfk#k#f@ffkfkfk#fkk#%ff@k%ffkffffkffffk#%k#f%ffkfffkfkfkffkkfk#k#fkf@%@f@
	fk%ffffk#kffkfkfkkff@f@%#%fff@f@fkf@ffkff@fffkffkf%%k#kfk#fkf@k#fkff%@kf%kff@k#fkkffkfkfffkfkff%k#fkfk=k#kf%f@fkk#k#fkf@fkk#k#%k#f%fkk#k#k#fkk#k#ff%f%f@fkf@fff@k#kffkfkffk#%kfk#f@f@
	%fkkfkffkk#f@f@ff%k#f%kfkfk#ffffffk#f@kff@fff@%%fkkfkffkfkf@k#ffffk#k#%@fkk#fk=k#k%kfk#fffkfkf@f@k#f@k#f@kf%f%fff@fkfkf@kfk#%k%fff@kfkfk#k#kfk#kfkf%%kff@k#f@k#fff@fffff@f@fk%ff%f@f@fffkfkkfk#f@kfkff@%kfk#f@f@
;OBF_GLOBVAR name: decodekey
	ff%kffffkffk#k#f@fkkf%ff%k#fff@ffk#kffff@kff@kf%f%fkk#k#k#fkk#k#ff%%f@kfkffkfkk#ffffkff@%kfkfkf=f%kfffffk#k#kfffkfff%@kfk%fkfffkkffkkfk#f@%fff@%kffff@kfkfkfk#kfkf%@
	f%f@k#ffk#fkfkk#%@%k#fff@ffk#kffff@kff@kf%@f%f@fkkfk#ffk#ffk#f@k#%ff%ffffk#k#fkk#fkkff@f@k#fk%f@%kfkffffffff@fkk#f@%fk#=f@%k#k#fkkfkfkfffkffkfffk%f%kfkfkffkkfkfffk#%k#f%kffff@kfkfkfk#kfkf%f@f%fkk#fkkff@f@k#f@fkkffkff%
	kf%f@f@fff@f@ffk#%ff%kfk#fffkfkf@f@k#f@k#f@kf%@%f@fkkfkffkfkk#ff%fk%fffffkffkfk#fkffkfkfkff@%kk#=f%f@f@kffkf@k#f@f@f@f@%k%f@ffffffk#kff@f@f@ffk#f@%k#%f@k#kffffkk#fkk#fkff%ff%fkfkfkfkfkkfk#ffffffk#kf%%fkk#k#k#fkk#k#ff%@f@
;OBF_GLOBVAR name: ishexchar
	ff%fkfkk#f@f@f@k#k#ffffk#ff%k%fkkfkffkk#f@f@ff%#f%fkkfkffkfkf@k#ffffk#k#%k%fkffkfkfk#f@fff@%f%k#kfk#f@f@k#f@%fk=ff%kff@kfkff@kfffk#kfkf%ff%fkfkfkf@kfkff@f@fkkf%%f@f@kffkf@k#f@f@f@f@%%kfk#kfkffff@fkkfkfkf%kf%ffkffffkffffk#%@fkf@k#kf
	k#k%kff@k#f@k#fff@fffff@f@fk%k#f%kffff@ffkffkffkff@%%f@ffffffk#kff@f@f@ffk#f@%f%fkk#k#f@kffkk#%k#=%f@fkfff@k#ffkffkkff@f@kf%fkf%fkfkfkf@kfkff@f@fkkf%f@kf%kfkff@k#ffffk#fff@%f@%ffkffffkffffk#%kf@k#kf
	ff%f@k#kff@kfk#fkfkf@f@fffk%kf%kffkfffkfkffk#fkfkkf%k%kfkfk#ffffffk#f@kff@fff@%ff%kfkfkffkkfkfffk#%@%f@k#kff@kfk#fkfkf@f@fffk%fkf=%ffffk#k#fkk#fkkff@f@k#fk%ffk%kfkffffffff@fkk#f@%f@%fkk#k#f@kffkk#%%f@kffkf@kfk#k#k#fkkfff%ff@fkf@k#kf
;OBF_GLOBVAR name: useshiftkey
	k%f@fkf@ffk#f@ff%fkf%f@fkkfk#ffk#ffk#f@k#%f%fff@fkfkf@kfk#%kf%f@fkkfk#ffk#ffk#f@k#%fkk%fkfkkffkk#f@kffkk#fkf@%#f@=%fff@f@fkf@ffkff@fffkffkf%%fkfkkffkk#f@kffkk#fkf@%kf%kffkfffkfkffk#fkfkkf%ff%f@fkf@fff@k#kffkfkffk#%k%f@fkk#fffff@f@fkfk%fkfkfk
	k#%f@k#kffkkfk#fkf@fffkkfk#%%f@kfffk#fkffffk#k#fk%#f%fff@fkf@kff@kfk#ff%fk%f@fkk#k#k#fff@fffkf@fk%k%f@fkk#fffff@f@fkfk%fff@=f%kffkf@f@k#kfk#kfk#k#%kf%fkkfk#k#f@ffkfkfk#fkk#%f@%kff@f@k#fff@kfkf%%fkk#fkffkffffkk#fkff%f%kfk#fffkfkf@f@k#f@k#f@kf%kfkfk
	ff%fkffk#fff@ffk#fkf@fkk#ff%%ffkffkf@fkkff@fffkk#k#%%f@fkk#f@fkfkkffffkff%%fkfffkkffkffkfk#%kf%f@f@fff@f@ffk#%kfkkfkf=%ffffk#ffkffkkff@k#%f%kffffkk#fkk#ffk#kf%%fkffk#fff@ffk#fkf@fkk#ff%f%fffkfkk#k#fkkffkk#fkf@ff%f%f@f@kffkf@k#f@f@f@f@%k#fkfkfk

;LOS vars for function  named: creategui
;OBF_FUNC_5_LOSVAR name: h1font
	k#%k#kfk#fkf@k#fkff%fkk#ff%f@fkfff@k#ffkffkkff@f@kf%kfffff%kfffkffffff@f@k#%k#k#f@k#k#fk=kf%f@fkfffkkfk#kfffkf%k#%fkffk#fff@ffk#fkf@fkk#ff%kk%kfffffk#k#fffkk#k#k#k#%%fffkf@f@kfk#ffk#fffk%k#%fkkfkffkfkf@k#ffffk#k#%f
	ffffk#%fffkffffk#kffkk#k#k#fk%f%f@kfkffkfkk#ffffkff@%f%f@kffkf@f@fff@%fffkffffk#f@fff@=%k#k#fkkfkfkfffkffkfffk%fk%fkfffkkffkk#ffff%f%kfk#f@fkk#kfffk#k#fkkf%kk#%f@fffff@fffkf@k#f@f@fff@%k#ff
;OBF_FUNC_5_LOSVAR name: h2font
	k%fff@kfkfk#k#kfk#kfkf%kff@ff%fkffkfkfk#f@fff@%@k#%ffffkfkffkfkfk%f@k#%kffff@kfkfkfk#kfkf%kkffkf@f@=fkk%f@k#f@ffkfffffffk#%k#%f@ffffffk#kff@f@f@ffk#f@%kf@f%f@fkf@kffkf@kff@%@kff%k#fff@ffk#kffff@kff@kf%f@
	k#f%fffkffffk#kffkk#k#k#fk%@k#f%ffffk#kffkfkfkkff@f@%fkf%fkk#k#f@kffkk#%kff@=fkk%kfkffkf@f@fkf@%#k%f@fkk#fkfkkfffk#kfk#%fkf@f@%fkk#k#f@kffkk#%ffff@
;OBF_FUNC_5_LOSVAR name: basefont
	ff%ffffkffkfkk#fkfkf@kfk#k#%kffffk%fffffkffkfk#fkffkfkfkff@%@ff%k#f@fkfffff@k#kffk%#kffkffkf=f%fkkfk#k#f@ffkfkfk#fkk#%f@k%k#fff@ffk#kffff@kff@kf%f@%f@fkfkk#fkfffff@%k%f@f@kfk#f@ffk#%ff@fk
	k%fkfkk#fff@fkk#fff@fkf@%f%kff@f@k#fff@kfkf%%fkffkfkfk#f@fff@%f@fffkffkff@kffkffff=%k#fff@ffk#kffff@kff@kf%f%f@fkf@ffk#f@ff%@k%f@fkf@ffk#f@ff%f@%ffkfffkfkfkffkkfk#k#fkf@%%f@kff@fkk#fffkf@ffk#%kff@fk
;OBF_FUNC_5_LOSVAR name: mymessage
	k#%fff@f@fkf@ffkff@fffkffkf%%k#k#f@k#kff@f@f@%ff%kff@f@kffkkff@ffkff@%fff@fkf@fffk=fkf%fffkk#k#fkkffff@fkfkk#ff%f@k%fkfkk#fff@fkk#fff@fkf@%%ffkffkf@fkkff@fffkk#k#%fk%k#fff@fkf@fff@f@kf%f@%fff@f@fkf@ffkff@fffkffkf%@kfff
	kfk%fff@fkf@kff@kfk#ff%#fkkf%fkfffkkffkffkfk#%#f@f%fkk#fkkff@f@k#f@fkkffkff%k%k#kfk#f@f@k#f@%fff@kff@kf=fk%fkffkfkfk#f@fff@%%k#k#kfffk#kfffkff@f@k#%f@k%f@fkk#k#k#fff@fffkf@fk%k%fkfkkffff@k#f@fkf@fk%#f@%fffkf@fffffkfkfkk#%f@kfff
;LOS vars for function  named: decode_ihidestr
;OBF_FUNC_8_LOSVAR name: newstr
	%kfk#fffkfkf@f@k#f@k#f@kf%fff%k#fkkfk#kfkfkffffkf@fk%kkf%fkk#k#k#fkk#k#ff%kfkk%fkfffkkffkkfk#f@%fkk#ff=%f@fkkfk#ffk#ffk#f@k#%@%f@fkf@kffkf@kff@%fff%fffkk#k#fkkffff@fkfkk#ff%%k#kfk#f@f@k#f@%@f@fff@fff@k#
	%f@fkk#k#k#fff@fffkf@fk%%f@kff@fkk#fffkf@ffk#%kfff%kfffffk#k#kfffkfff%kk#%kffff@kfkfkfk#kfkf%@f%fkfffkkffkffkfk#%k#k#f@kfkff@=%fffffkffkfk#fkffkfkfkff@%%f@kffkf@f@fff@%fff%fffkk#k#fkkffff@fkfkk#ff%f%fffkfkk#k#fkkffkk#fkf@ff%@f@f%kffkkfkff@fffkkffkkffkff%ff@fff@k#
;OBF_FUNC_8_LOSVAR name: startstrlen
	%f@f@k#fff@fkfffk%fk#f@k%f@k#f@ffkfffffffk#%k#fffk%kfffffffk#f@f@f@k#fkfk%fkf@fkkf=k#kfk%f@fkf@kffkf@kff@%ff@k%f@f@fff@f@ffk#%%f@k#kff@kfk#fkfkf@f@fffk%ff%fkf@f@fkfffkfkkf%ffkffffk
	f@kfkfk%fkk#k#f@fff@fff@ffffffkf%ffkkfk%ffkffffkffffk#%kfkff@%f@fkfff@k#ffkffkkff@f@kf%fk#=k#kf%fkfkk#fff@fkk#fff@fkf@%kff@%k#f@fkfffff@k#kffk%ff%k#kfk#f@f@k#f@%f@ff%f@k#k#fffkfkk#f@ffffkf%kffffk
;OBF_FUNC_8_LOSVAR name: charnum
	fkk%fkk#k#k#fkk#k#ff%%fkfkk#f@f@f@k#k#ffffk#ff%%kffff@kfkfkfk#kfkf%ff@%kff@fkfkffkfkffk%f@%f@ffffffk#kff@f@f@ffk#f@%@k#f@ff=f%fffffkf@fkkfkffkfkfffk%ff%ffffkffkfkk#fkfkf@kfk#k#%ffkf%fkkfk#k#f@ffkfkfk#fkk#%%fkk#k#f@kffkk#%fkff@k#
	%kfkff@k#ffffk#fff@%ffkffk%f@k#ffk#fkfkk#%f@%k#fff@ffk#kffff@kff@kf%f%kff@kfkff@kfffk#kfkf%fffkffffffff@fkkf=%fkkfk#k#f@ffkfkfk#fkk#%%f@fkf@ffk#f@ff%%kfk#kfkffff@fkkfkfkf%fff%kff@k#fkkffkfkfffkfkff%kffkfkff@k#
;OBF_FUNC_8_LOSVAR name: hinibble
	fffff%fkffkffffkffff%@kf%f@fkk#k#k#fff@fffkf@fk%ff@k%f@fkfff@k#ffkffkkff@f@kf%f@ffkf%k#k#fkkfkfkfffkffkfffk%fff=f%ffkffkf@fkkff@fffkk#k#%%f@ffffffk#kff@f@f@ffk#f@%f@k#k%f@fkfff@k#ffkffkkff@f@kf%k#kffkf@
	f%f@ffkfk#kfkffffff@fkf@kf%kfkf%fffffkffkfk#fkffkfkfkff@%fkk%kffkf@fkfkk#ff%#kf%fkffkfkfk#f@fff@%@fkf@kf=%kfffffk#k#fffkk#k#k#k#%ff%f@fkk#k#k#fff@fffkf@fk%@k#%fkk#k#f@kffkk#%fk#k%fkkfkffkfkf@k#ffffk#k#%fkf@
;OBF_FUNC_8_LOSVAR name: lownibble
	k#k%fkffk#fff@ffk#fkf@fkk#ff%ff%fkfkfkf@kfkff@f@fkkf%kff@%k#k#fkkfkfk#kfkf%ff%ffffkfkffkfkfk%kk#k#=k#%ffkfk#f@f@kffkf@kfffkfk#%fk%ffkffffkffffk#%k#f%fkk#k#f@fff@fff@ffffffkf%kffk#kffkkf
	kf%fkkfk#k#f@ffkfkfk#fkk#%kff%kfffkffffff@f@k#%#kfkf%kffkf@fkfkk#ff%f@%f@kfffk#fkffffk#k#fk%fkfkkf=%fkk#k#f@kffkk#%#kfkf%ffffk#k#fkk#fkkff@f@k#fk%%ffkfk#f@f@kffkf@kfffkfk#%#fkf%f@fkk#k#k#fff@fffkf@fk%k#kffkkf
;OBF_FUNC_8_LOSVAR name: mybinary
	f@%kfk#kfkffff@fkkfkfkf%ffkf%fkk#k#k#fkk#k#ff%ff@f%k#k#fkkfkfkfffkffkfffk%ffkff@%fffffkffkfk#fkffkfkfkff@%kkffffkkf=k#k%fffkf@f@f@f@fk%#f%k#kff@f@kfk#kfkfkf%ffk%fff@k#kffkffk#fffffk%%f@ffffffk#kff@f@f@ffk#f@%fff@fkkfk#f@
	k%fkkff@f@fff@kffff@kf%ffff%k#k#f@k#k#ffkffffff@fk%k%f@fkf@ffk#f@ff%%fffkk#k#fkkffff@fkfkk#ff%kfffffkf=%f@f@k#fff@fkfffk%#k#f%kfkfkffkkfkfffk#%@%f@fkf@ffk#f@ff%fk%f@fffkf@f@f@f@fkff%%f@k#kff@kfk#fkfkf@f@fffk%fff@fkkfk#f@

;PARAMETERS for function  named: ihidestr
;OBF_FUNC_7_PARAM name: thisstr
	kf%kfkff@k#ffffk#fff@%f%kff@f@k#fff@kfkf%k#f@%kffff@kfkfkfk#kfkf%ff@fkf@kff@=%k#k#f@k#k#ffkffffff@fk%kfff%kfffkffffff@f@k#%fk#fk%k#fff@ffk#kffff@kff@kf%fkfkf
	%ffffk#k#fkk#fkkff@f@k#fk%kffk%ffkfk#f@f@kffkf@kfffkfk#%%fkkfk#kffkkff@kf%ffff%fkffkfkfk#f@fff@%@fkkfff=kff%fkfkk#f@f@f@k#k#ffffk#ff%fk%f@f@fff@f@ffk#%k#%f@k#kff@kfk#fkfkf@f@fffk%kffkfkf
;PARAMETERS for function  named: decode_ihidestr
;OBF_FUNC_8_PARAM name: startstr
	k#%fkfffffffkk#fkf@k#f@%fk%f@k#kff@kfk#fkfkf@f@fffk%kf@k#k#%k#k#fkkfkfkfffkffkfffk%fk#k#f@kfkfkf=f@f%f@fkfff@k#ffkffkkff@f@kf%kf%kff@kfkff@kfffk#kfkf%ffk%f@fffkffk#k#fff@ffk#f@%fkff
	%fff@ffk#ffk#kfffk#fk%f%fffkk#k#fkkffff@fkfkk#ff%k#%kfk#kfkffff@fkkfkfkf%%fkkfk#k#f@ffkfkfk#fkk#%fk#f@kfk#f@f@=%fffffkffkfk#fkffkfkfkff@%@f%f@fff@fff@fkf@fkkffkff%%fkffk#fff@ffk#fkf@fkk#ff%%f@k#ffk#fkfkk#%kf%f@kfkffkfkk#ffffkff@%ffkfkff
;PARAMETERS for function  named: decode_hexshiftkeys
;OBF_FUNC_9_PARAM name: startstr
	k#%k#fffkkfk#k#ffk#kfk#%f%ffkffkf@fkkff@fffkk#k#%fkf%kfkfk#ffffffk#f@kff@fff@%#%f@fkkfk#ffk#ffk#f@k#%fk#k#%kfkfk#ffffffk#f@kff@fff@%#fff@ffk#ff=kf%f@ffkfk#f@fffkf@f@k#ff%ff%f@k#kff@kfk#fkfkf@f@fffk%kf%fffkffffk#kffkk#k#k#fk%%fff@f@fkf@ffkff@fffkffkf%k%k#kfkfkfk#ffkf%kf
	%kff@kfkff@kfffk#kfkf%ff@fk%ffk#k#k#f@k#kfkffkk#ffkf%k#fkfkk%f@fkf@ffk#f@ff%ffffffk#=k%kfk#f@fkk#kfffk#k#fkkf%%k#k#ffffkffkk#k#f@k#ffff%f%kfffkffffff@f@k#%ff%fkffk#fff@ffk#fkf@fkk#ff%kffkkf
;PARAMETERS for function  named: decode_shifthexdigit
;OBF_FUNC_10_PARAM name: hexvalue
	ff%ffkffffkffffk#%@k#%kffffkk#fkk#ffk#kf%ff@f%fkfffffffkk#fkf@k#f@%@f%fkffk#f@f@ffk#k#kfkff@fk%kfkfkfkk#k#=kf%fkkfk#k#f@ffkfkfk#fkk#%@%kff@k#f@k#fff@fffff@f@fk%kkff%k#k#ffffkfk#f@fkf@k#f@%%k#k#ffffkffkk#k#f@k#ffff%f@ffff
	%f@kfkffkfkk#ffffkff@%ff@%k#k#f@k#kff@fkkfkffkfkk#%#f@%fkkff@f@kfk#ffff%f%kfkfk#ffffffk#f@kff@fff@%kff@fkf@k#fkkf=kff%ffk#k#ffk#fffkk#%%kfkffkf@f@fkf@%@fkk%f@ffffffk#kff@f@f@ffk#f@%f@f@%kfkffffffff@fkk#f@%fff
;PARAMETERS for function  named: fixescapes
;OBF_FUNC_11_PARAM name: forstr
	ffk%f@fkfkk#fkfffff@%f%ffkfffkfkfkffkkfk#k#fkf@%%kfkfk#ffffffk#f@kff@fff@%%f@fkf@ffk#f@ff%kff%kfkfk#ffffffk#f@kff@fff@%ffffkff@=ff%k#kfk#f@f@k#f@%%fff@f@fkf@ffkff@fffkffkf%%kfffffk#k#kfffkfff%%kffffkfffkffkf%k#%k#fffkf@fffkfkkffk%ff@f@
	ff%f@f@fff@kfffkfkff@f@fkf@%k%fkk#k#k#fkk#k#ff%f%kff@k#f@k#fff@fffff@f@fk%kf%k#fkkffkkfk#fkfk%%k#f@fkfffff@k#kffk%ffkfffkf@f@ffffff=f%kffff@kfkfkfk#kfkf%f%fkffk#fff@ffk#fkf@fkk#ff%k%kfkfkffkkfkfffk#%%fkfkkffkk#f@kffkk#fkf@%#%k#fffkf@fffkfkkffk%ff@f@

;for obfuscated system function calls
;OBF_SYSFUNC name: substr
	f%f@fkfffkkfk#kfffkf%k%ffffk#kffkfkfkkff@f@%#%f@f@k#fff@fkfffk%#f%fkk#k#k#fkk#k#ff%kffk=%kfffffk#k#kfffkfff%%ffk#kff@fffkk#f@fkfkfffk%s%kfkff@k#ffffk#fff@%u%f@fkf@kffkf@kff@%b%kfkffkf@f@fkf@%s%f@ffkfk#kfkffffff@fkf@kf%t%kffkfkkffff@f@fkf@fkffkf%%fkk#k#f@fff@fff@ffffffkf%
	%f@fffkffk#k#fff@ffk#f@%k%fffffkffkfk#fkffkfkfkff@%f@f@%fff@f@fkf@ffkff@fffkffkf%kfkk#=%fffkfkk#k#fkkffkk#fkf@ff%%ffffk#ffkffkkff@k#%r%fffkfkfkf@f@kffff@%%kffkfffkfkffk#fkfkkf%
	ff%kfffkffffff@f@k#%fk%ffkffffkffffk#%%kfffffffk#f@f@f@k#fkfk%kf%k#fff@ffk#kffff@kff@kf%@%fkfkfkf@kfkff@f@fkkf%kf=%f@kff@fkk#fffkf@ffk#%%ffk#k#k#f@k#kfkffkk#ffkf%s%f@kffkf@kfk#k#k#fkkfff%u%kff@f@fff@kfkf%b%kfk#k#kffkk#ffkf%s%k#kff@fkk#f@kf%%kff@kfkfkff@fk%
	%k#fff@ffk#kffff@kff@kf%fff%kff@f@fff@kfkf%%f@k#kffffkk#fkk#fkff%%k#kfk#f@f@k#f@%kf@%f@fkk#k#k#fff@fffkf@fk%@fkf@f@=%kffffkfffkffkf%%ffk#kff@fffkk#f@fkfkfffk%t%f@fffkf@f@f@f@fkff%r%f@fffff@fffkf@k#f@f@fff@%%fff@fkfkf@kfk#%
	fk%kfk#f@fkk#kfffk#k#fkkf%k%fkk#k#f@fff@fff@ffffffkf%%f@fkkfk#ffk#ffk#f@k#%k%fffffkffkfk#fkffkfkfkff@%ffk#f@f@=%kffkf@f@k#kfk#kfk#k#%%kff@k#fkkffkfkfffkfkff%s%fkfkkffff@k#f@fkf@fk%u%fkffk#k#fkfkfkf@k#kf%b%f@fkfffkkfk#kfffkf%%f@kff@fkk#fffkf@ffk#%
	f@kf%f@ffffffk#kff@f@f@ffk#f@%f%ffk#kff@fffkk#f@fkfkfffk%k#%kffffkk#fkk#ffk#kf%%f@fkk#fffff@f@fkfk%fffff@=%fkk#f@k#kfk#kfkfffff%%fkk#f@k#kfk#kfkfffff%s%k#kfk#fkf@k#fkff%t%ffk#kff@fffkk#f@fkfkfffk%r%kff@kfkfkff@fk%%f@fffkf@f@f@f@fkff%
	%fkffkfkfk#f@fff@%ff%kfkffkf@f@fkf@%%fffkfkk#k#fkkffkk#fkf@ff%kkf%fkffkfkfk#f@fff@%@%fff@f@fkf@ffkff@fffkffkf%kf@kfk#=%fkfkkffkk#f@kffkk#fkf@%%f@kff@fkk#fffkf@ffk#%s%fff@f@fkfkf@f@kff@%u%fkkff@f@kfk#ffff%b%fkffk#k#fkfkfkf@k#kf%%kffff@ffkffkffkff@%
	ff%kffkkfkff@fffkkffkkffkff%ffk%fkfkfkf@kfkff@f@fkkf%fk%f@fkkfk#ffk#ffk#f@k#%fkf%fkffk#fff@ffk#fkf@fkk#ff%fkf%k#kff@f@kfk#kfkfkf%=%kffff@ffkffkffkff@%%ffffkfkffkfkfk%s%fff@ffk#ffk#kfffk#fk%t%kffkfkkffff@f@fkf@fkffkf%r%f@f@fff@kfffkfkff@f@fkf@%%f@fkfffkkfk#kfffkf%
;OBF_SYSFUNC name: strlen
	%kffffkk#fkk#ffk#kf%#f%fkkff@ffk#k#ffkfff%%fffkffffk#kffkk#k#k#fk%@k%kfkffffffff@fkk#f@%fkf@f@fkfk=%kff@ffkffkfkfkfkk#kf%%kfk#fffff@fffkfffff@ff%s%k#fkkfk#kfkfkffffkf@fk%t%f@fff@fff@fkf@fkkffkff%r%fkffkffffkffff%%k#kfkfkfk#ffkf%
	ff%k#k#fkkfkfkfffkffkfffk%%kffkf@fkfkk#ff%#k#k%k#fff@fkf@fff@f@kf%%kff@k#f@k#fff@fffff@f@fk%kk#fkkf=%kfk#fffkfkf@f@k#f@k#f@kf%%kff@k#ffk#fkff%l%f@kffkf@kfk#k#k#fkkfff%e%f@kfffk#fkffffk#k#fk%n%fkkff@f@kfk#ffff%%ffk#k#ffk#fffkk#%
	%kfkffffffff@fkk#f@%@%fkkfkffkfkf@k#ffffk#k#%f%kfffffk#k#kfffkfff%fkf%ffkffffkffffk#%kfk#=%k#fffkkfk#k#ffk#kfk#%%fkfffffffkk#fkf@k#f@%s%fkkff@f@kfk#ffff%t%kfk#fffff@fffkfffff@ff%r%f@fkk#f@fkfkkffffkff%l%fffkfkffffk#fkf@f@f@k#fk%e%f@k#k#fffkfkk#f@ffffkf%%fkfkkffff@k#f@fkf@fk%
	k#ff%f@ffkfk#kfkffffff@fkf@kf%k%f@f@fff@f@ffk#%kffk%kff@kfkff@kfffk#kfkf%f=%k#fkkffkkfk#fkfk%%fffkfkffffk#fkf@f@f@k#fk%n%ffffk#ffkffkkff@k#%%f@ffkfk#kfkffffff@fkf@kf%
	%f@fffkf@f@f@f@fkff%f%ffkffffkffffk#%f@%f@kffkf@kfk#k#k#fkkfff%k%f@fkkfk#ffk#ffk#f@k#%f%kffkf@k#kfkfk#fkfkkf%f@ffffk#=%ffffk#k#fkk#fkkff@f@k#fk%%ffffkfkffkfkfk%s%fkfkfkf@kfkff@f@fkkf%t%fkfkfkfkfkkfk#ffffffk#kf%%fkffkffffkffff%
	k#f%kff@kfk#fffkffffk#k#%k#k%k#fff@fkf@fff@f@kf%%ffk#k#k#f@k#kfkffkk#ffkf%fkk%f@kfffk#fkffffk#k#fk%f=%kffffkfffkffkf%%ffffkffkfkk#fkfkf@kfk#k#%r%kfk#kfkffff@fkkfkfkf%l%kfffffk#k#fffkk#k#k#k#%e%kff@f@kffkkff@ffkff@%n%fff@fkf@kff@kfk#ff%%fkkff@f@kfk#ffff%
	%k#k#fkkfkfk#kfkf%#f@f%ffk#k#k#f@k#kfkffkk#ffkf%%k#k#ffffkfk#f@fkf@k#f@%kff@kfk#=%f@k#kfk#kff@kf%%f@f@kfk#f@ffk#%s%fkfkkffkk#f@kffkk#fkf@%%ffk#k#k#f@k#kfkffkk#ffkf%
	f%k#kfk#f@f@k#f@%f@%kfkfk#ffffffk#f@kff@fff@%%f@k#k#k#kfk#k#ff%%fff@f@fkfkf@f@kff@%k#fkkf=%k#k#f@k#k#ffkffffff@fk%%fkkff@ffk#k#ffkfff%t%f@f@fff@kfffkfkff@f@fkf@%r%kfkff@k#ffffk#fff@%l%fkfkk#fff@fkk#fff@fkf@%e%f@f@fff@kfffkfkff@f@fkf@%n%f@kfffk#fkffffk#k#fk%%ffkffkf@fkkff@fffkk#k#%
;OBF_SYSFUNC name: chr
	fkk%fkfkfkf@kfkff@f@fkkf%ffk%f@fkfff@k#ffkffkkff@f@kf%kff%f@fffkf@f@f@f@fkff%fk=%fkkfkffkk#f@f@ff%%fkkff@ffk#k#ffkfff%c%kfkffkf@f@fkf@%h%kff@f@kffkkff@ffkff@%%f@k#kfk#kff@kf%
	fk%f@fffkfkk#fkk#%ff%ffkfk#f@f@kffkf@kfffkfk#%#f%fkk#k#f@kffkk#%f%kff@k#f@k#fff@fffff@f@fk%k#f@=%kfk#fffff@fffkfffff@ff%%f@kff@fkk#fffkf@ffk#%r%k#k#ffffkffkk#k#f@k#ffff%%ffk#k#k#f@k#kfkffkk#ffkf%
	%fkffk#f@f@ffk#k#kfkff@fk%f%fkffkfkfk#f@fff@%f@f%k#k#f@k#kff@fkkfkffkfkk#%k%f@fkf@ffk#f@ff%kff@k#=%fff@fkfkf@kfk#%%kff@k#fkkfkffkfk%c%fff@fkf@kff@kfk#ff%h%f@fkkfkffkfkk#ff%%kfffffk#k#fffkk#k#k#k#%
	k%k#kffkf@fkfkkffff@k#%k#%kfk#fffkfkf@f@k#f@k#f@kf%kf%fffkfkffffk#fkf@f@f@k#fk%%ffkffffkffffk#%%f@k#kffkkfk#fkf@fffkkfk#%f@kffk=%k#k#f@k#k#ffkffffff@fk%%fffkffffk#kffkk#k#k#fk%r%f@ffkfk#kfkffffff@fkf@kf%%k#kff@fkk#f@kf%
	fkk%ffk#kff@fffkk#f@fkfkfffk%ffff%ffk#kffkk#fkf@ff%f%k#fkkfffffffffk#k#f@kffk%%kfffkffffff@f@k#%#f@kf=%f@k#f@fkk#fkkff@kf%%kfkffkf@f@fkf@%c%f@k#k#fffkfkk#f@ffffkf%%kffkf@f@k#kfk#kfk#k#%
	%ffkffkf@fkkff@fffkk#k#%fkfk%fkkfk#k#f@ffkfkfk#fkk#%ffkf%f@fkkfkffkfkk#ff%ff%fkfkfkffffk#kfk#ffkf%kffk=%fkfkkffff@k#f@fkf@fk%%kfk#fffkfkf@f@k#f@k#f@kf%h%f@fkkfkffkfkk#ff%r%f@fff@fff@fkf@fkkffkff%%kff@k#ffk#fkff%
	f@%fffffkf@fkkfkffkfkfffk%kf%fffkf@f@f@f@fk%%fffffkffkfk#fkffkfkfkff@%@%kfkfk#ffffffk#f@kff@fff@%#f%f@kfkffkfkk#ffffkff@%k#ff=%fffkf@f@f@f@fk%%ffffk#ffkffkkff@k#%c%f@k#ffk#fkfkk#%h%fffkfkffffk#fkf@f@f@k#fk%%ffk#kff@fffkk#f@fkfkfffk%
	fff%k#kff@fkk#f@kf%f%fkfffkkffkffkfk#%#f%fkkfffk#fkf@kf%kf%f@fkkfk#ffk#ffk#f@k#%f=%f@f@fff@kfffkfkff@f@fkf@%%f@k#k#fffkfkk#f@ffffkf%r%fkffk#k#fkfkfkf@k#kf%%kfkfkffkkfkfffk#%
;OBF_SYSFUNC name: asc
	kf%fkkfkffkfkf@k#ffffk#k#%@k#%ffffk#kffkfkfkkff@f@%%ffk#k#ffk#fffkk#%#f@fkf@=%fkkfkffkk#f@f@ff%%fkkff@f@fff@kffff@kf%a%f@kfffk#fkffffk#k#fk%%ffffkffkfkk#fkfkf@kfk#k#%
	fkff%fff@fkf@kff@kfk#ff%kff%fff@f@fkf@ffkff@fffkffkf%f@fk=%kfk#k#kffkk#ffkf%%fkfkfkfkfkkfk#ffffffk#kf%s%f@fkfkk#fkfffff@%c%fkfkkffff@k#f@fkf@fk%%fkfkfkfkfkkfk#ffffffk#kf%
	k#f%kfkffkf@f@fkf@%%kfk#fffkfkf@f@k#f@k#f@kf%k%ffffk#kffkfkfkkff@f@%%fkffkfkfk#f@fff@%k#k#kf=%f@f@kfk#f@ffk#%%fff@ffk#ffk#kfffk#fk%a%fkffkffffkffff%s%kfffffk#k#kfffkfff%%kfk#kfkffff@fkkfkfkf%
	%f@k#ffk#fkfkk#%fk%fffkffffk#kffkk#k#k#fk%%ffkfk#f@f@kffkf@kfffkfk#%f%ffkffffkffffk#%kfffkf@k#=%f@fffkfkk#fkk#%%ffffkfkffkfkfk%c%kff@f@fff@kfkf%%fffkkfffk#f@f@kffk%
	ffk%f@k#kfk#kff@kf%#f@%f@fkkfk#ffk#ffk#f@k#%%k#f@ffffk#f@k#f@kffk%f@%fffkffffk#kffkk#k#k#fk%f@fk=%kffkkfkff@fffkkffkkffkff%%fkfkk#fff@fkk#fff@fkf@%a%kff@k#fkkffkfkfffkfkff%%f@fkk#k#fkf@fkk#k#%
	fkfk%f@fff@fff@fkf@fkkffkff%f@%f@k#kffkkfk#fkf@fffkkfk#%#f%k#fff@ffk#kffff@kff@kf%k%f@k#f@ffkfffffffk#%k#k#=%f@k#k#fffkfkk#f@ffffkf%%fff@k#kffkffk#fffffk%s%k#kfkfkfk#ffkf%c%fff@fkfkf@kfk#%%fkffk#k#k#k#ffkfk#%
	ff%f@kff@fkk#fffkf@ffk#%kff%k#k#fkkfkfkfffkffkfffk%%kff@k#f@k#fff@fffff@f@fk%f%f@k#kff@kfk#fkfkf@f@fffk%%fkk#fkf@fkk#kfk#k#%kfff@ff=%fkfkk#f@f@f@k#k#ffffk#ff%%k#kfk#fkf@k#fkff%a%ffk#k#k#f@k#kfkffkk#ffkf%%ffffk#ffkffkkff@k#%
	k#%k#k#f@k#kff@fkkfkffkfkk#%%kff@f@fff@kfkf%#f%f@fkkfk#ffk#ffk#f@k#%fk%fkkff@f@fff@kffff@kf%%k#k#f@k#kff@fkkfkffkfkk#%ff@=%fkk#fkf@fkk#kfk#k#%%fkkff@ffk#k#ffkfff%s%fkffk#k#fkfkfkf@k#kf%c%fffkffffk#kffkk#k#k#fk%%f@ffkfk#kfkffffff@fkf@kf%
;OBF_SYSFUNC name: instr
	f%fffkf@f@f@f@fk%kf@%kffffkk#fkk#ffk#kf%#kf%kffff@kfkfkfk#kfkf%kk%kff@k#f@k#fff@fffff@f@fk%ff=%fkkff@f@fff@kffff@kf%%kfk#f@fkk#kfffk#k#fkkf%i%fkk#fkf@fkk#kfk#k#%n%kfkffkf@f@fkf@%s%kfk#f@fkk#kfffk#k#fkkf%t%f@fkkfkffkfkk#ff%%k#fkfkffkfkfffffffk#kff@%
	kffk%kfk#kfkffff@fkkfkfkf%k#%fkffk#fff@ffk#fkf@fkk#ff%@f%k#k#kfffk#kfffkff@f@k#%k#ff=%kffffkffk#k#f@fkkf%%kffkfkkffff@f@fkf@fkffkf%r%kffkf@fkfkk#ff%%fkffk#k#k#k#ffkfk#%
	k%kfk#fffkfkf@f@k#f@k#f@kf%#k#%kff@k#f@k#fff@fffff@f@fk%%f@kffkf@f@fff@%f%fkk#f@k#kfk#kfkfffff%@ffk#ff=%f@kffkf@kfk#k#k#fkkfff%%kffff@ffkffkffkff@%i%f@k#k#fffkfkk#f@ffffkf%%f@kff@fkk#fffkf@ffk#%
	%fkkff@f@kfk#ffff%f%kfkff@k#ffffk#fff@%@%f@ffkfk#f@fffkf@f@k#ff%%fffffkffkfk#fkffkfkfkff@%k%fkffk#fff@ffk#fkf@fkk#ff%fkf@f@f@ff=%f@k#f@fkk#fkkff@kf%%kff@kfkfkff@fk%n%kfk#fffff@fffkfffff@ff%s%kff@f@fff@kfkf%t%kff@ffkffkfkfkfkk#kf%r%fffkf@fffffkfkfkk#%%fkffkffffkffff%
	fff%k#kff@fkk#f@kf%kfff%fkkfk#k#f@ffkfkfk#fkk#%%f@ffffffk#kff@f@f@ffk#f@%%kffffkffk#k#f@fkkf%kf@k#kf=%kffkf@fkfkk#ff%%kfk#k#kffkk#ffkf%i%fff@f@fkfkf@f@kff@%n%f@fffff@fffkf@k#f@f@fff@%%kff@f@fff@kfkf%
	k#f%f@fkk#k#fkf@fkk#k#%f%f@fkf@ffk#f@ff%%fffffkffkfk#fkffkfkfkff@%fkfffkkfff=%fffkf@fffffkfkfkk#%%fkkff@f@kfk#ffff%s%kffffkfffkffkf%t%k#kff@fkk#f@kf%r%f@ffkfk#kfkffffff@fkf@kf%%fffkfkfkf@f@kffff@%
	k%fkffk#fff@ffk#fkf@fkk#ff%kfk%k#k#k#fkf@f@k#f@k#f@k#ff%k%kfk#k#kffkk#ffkf%%fkfffkkffkk#ffff%fkfkf@=%fff@ffk#ffk#kfffk#fk%%f@fffkfkk#fkk#%i%f@k#kfk#kff@kf%n%f@f@fff@kfffkfkff@f@fkf@%s%f@fffkf@f@f@f@fkff%%fkfkkffkk#f@kffkk#fkf@%
	%kfffffk#k#kfffkfff%%f@k#kff@kfk#fkfkf@f@fffk%@k%k#k#ffffkffkk#k#f@k#ffff%#f%kfkffffffff@fkk#f@%%k#f@ffffk#f@k#f@kffk%#fff@=%f@kfffk#fkffffk#k#fk%%f@kff@fkk#fffkf@ffk#%t%fkkff@ffk#k#ffkfff%r%fffkkfffk#f@f@kffk%%kffkfffkfkffk#fkfkkf%

;always use these dumps for function and label fragments when
;doing dynamic obfuscation 
;OBF_FUNC name: SECURITYTESTS_bestcodesection
	f@f%kffffkk#fkk#ffk#kf%k#f@%kfkfkffkkfkfffk#%k#k#%k#fkfkffkfkfffffffk#kff@%fffk=ff%kff@k#f@k#fff@fffff@f@fk%@%f@fkk#k#k#fff@fffkf@fk%fk%fffffkffkfk#fkffkfkfkff@%%kffkf@f@k#kfk#kfk#k#%ff%kffff@ffkffkffkff@%ffffff
	fk%f@fkf@ffk#f@ff%fk%fkffk#f@f@ffk#k#kfkff@fk%fk#%fkfkk#f@f@f@k#k#ffffk#ff%fk%fkk#k#k#fkk#k#ff%@=ff%f@k#kff@kfk#fkfkf@f@fffk%@ffk%kffkfffkfkffk#fkfkkf%fffff%fffffkffkfk#fkffkfkfkff@%fff
;OBF_FUNC name: WIREUP_bestcodesection
	f%fkkfkffkk#f@f@ff%@fff%f@k#kff@kfk#fkfkf@f@fffk%k%fkfkf@fkf@k#fffkfkffkf%kffkk#=fff%f@kfkffkfkk#ffffkff@%f%f@kfffk#fkffffk#k#fk%@k#%ffkfkff@kfffkffkffk#ffk#%ff@
	f@%f@ffffffk#kff@f@f@ffk#f@%k%fkk#k#f@fff@fff@ffffffkf%%k#f@fkfffff@k#kffk%%fffffkffkfk#fkffkfkfkff@%ffkfk#f@=fff%ffffk#kffkfkfkkff@f@%f@%k#k#fkkfkfkfffkffkfffk%#kff%ffk#kff@fffkk#f@fkfkfffk%@
;OBF_FUNC name: creategui
	fk%kfffkffffff@f@k#%#f%k#fffkkfffffk#kffffk%ffff%fff@k#kffkffk#fffffk%k#kf=ff%kfkffffffff@fkk#f@%@f%kffkfffkfkffk#fkfkkf%@%f@fkfff@k#ffkffkkff@f@kf%fk#k#f@f@
	f%f@k#kff@kfk#fkfkf@f@fffk%%f@k#f@fkk#fkkff@kf%fkk#%fkkfk#k#f@ffkfkfk#fkk#%ffkff=f%f@fkkfk#ffk#ffk#f@k#%f@%fkkff@ffk#k#ffkfff%f%fkk#kff@f@kfffk#%%k#kfk#f@f@k#f@%fk#k#f@f@
;OBF_FUNC name: testfunction
	kff%fkkfffk#fkf@kf%kf%ffk#kff@fffkk#f@fkfkfffk%f@k%k#kffkf@fkfkkffff@k#%k#=f@k%kff@ffkffkfkfkfkk#kf%#%fff@f@fkf@ffkff@fffkffkf%k%f@fkf@ffk#f@ff%k%kfkfk#ffffffk#f@kff@fff@%ff@kf
	kfk%kfkffffffff@fkk#f@%kf%f@fkkfk#ffk#ffk#f@k#%@f%fkfkk#fff@fkk#fff@fkf@%%fkkff@ffk#k#ffkfff%kfffk=f@k%k#kfkffffkfffff@kff@%%kff@k#fkkfkffkfk%%fkfffkkffkk#ffff%fk%f@k#kff@kfk#fkfkf@f@fffk%kkff@kf
;OBF_FUNC name: ihidestr
	%kfkfkffkkfkfffk#%f@%f@fff@fff@fkf@fkkffkff%kf%f@kfkffkfkk#ffffkff@%%kfffk#fkf@kfffkfkfffkf%%ffkffffkffffk#%ffkkfkf=f@%f@f@fff@f@ffk#%ff%k#fkkfffffffffk#k#f@kffk%fkf%kff@k#ffk#fkff%%ffffk#ffkffkkff@k#%f%fffffkffkfk#fkffkfkfkff@%kfkkf
	f%ffk#f@kffkk#k#kfffk#f@%@k%f@ffk#k#fffffkf@k#f@%f%f@f@k#fff@fkfffk%f@f%fffffkffkfk#fkffkfkfkff@%k#=%f@fkf@ffk#f@ff%@%fffkf@f@f@f@fk%fff@f%k#f@ffffk#f@k#f@kffk%fffkfkkf
;OBF_FUNC name: decode_ihidestr
	f%f@k#kff@kfk#fkfkf@f@fffk%k#%kfffkffffff@f@k#%fk%fff@f@fkf@ffkff@fffkffkf%%fffkfkffffk#fkf@f@f@k#fk%k%kfffffk#k#kfffkfff%#fkf@=k#f%kff@k#f@k#fff@fffff@f@fk%fff@k%kff@f@kffkkff@ffkff@%#ffk#%k#k#fkkfkfk#kfkf%f
	k#f@k%fkkfkffkfkf@k#ffffk#k#%fkf@%f@f@k#fff@fkfffk%fk#kf=k%f@k#k#k#kfk#k#ff%fff%fkk#fkf@fkk#kfk#k#%ff%f@f@kffkf@k#f@f@f@f@%k#f%fkk#k#k#fkk#k#ff%k#kf
;OBF_FUNC name: decode_hexshiftkeys
	%fkk#k#f@kffkk#%fff%ffk#k#ffk#fffkk#%ffk%kff@k#f@k#fff@fffff@f@fk%kfk#f@=kf%fff@ffk#ffk#kfffk#fk%f%k#fffkkfffffk#kffffk%kfk#%kfkffffffff@fkk#f@%ff@ff
	f@f%kfk#kfkffff@fkkfkfkf%fk#f%kffkfffkfkffk#fkfkkf%%fff@f@fkf@ffkff@fffkffkf%k#k%fff@kfkfk#k#kfk#kfkf%f@k#=kf%f@k#kff@kfk#fkfkf@f@fffk%@%fkfkk#fff@fkk#fff@fkf@%kf%kff@ffkffkfkfkfkk#kf%k#%kff@k#f@k#fff@fffff@f@fk%ff@ff
;OBF_FUNC name: decode_shifthexdigit
	f@%k#fff@ffk#kffff@kff@kf%f%ffkffffkffffk#%ff%kff@ffkffkfkfkfkk#kf%k%kfkffffffff@fkk#f@%fkffk=f%fffkfkfkf@f@kffff@%@k%kffff@kfkfkfk#kfkf%%fffkfkk#k#fkkffkk#fkf@ff%k#%k#k#fkkfkfk#kfkf%%fkfkf@fkf@k#fffkfkffkf%fffkk#
	f%fffffkf@fkkfkffkfkfffk%@%fkffk#k#k#k#ffkfk#%%fkffkfkfk#f@fff@%%fffffkffkfk#fkffkfkfkff@%%k#k#fkkfkfkfffkffkfffk%#k#ffk#=f@%ffffkffkfkk#fkfkf@kfk#k#%kfk%kfffk#fkf@kfffkfkfffkf%k#%kff@k#f@k#fff@fffff@f@fk%ffk%k#k#f@k#kff@fkkfkffkfkk#%#
;OBF_FUNC name: fixescapes
	%f@fkk#k#k#fff@fffkf@fk%@%kfk#fffff@fffkfffff@ff%fk%fkffk#k#k#k#ffkfk#%f%k#k#f@k#kff@fkkfkffkfkk#%ff%k#kfk#f@f@k#f@%@fff@=k#%kff@kfkff@kfffk#kfkf%f%fkffk#fff@ffk#fkf@fkk#ff%@%fkkfk#k#f@ffkfkfk#fkk#%fk%f@k#kffffkk#fkk#fkff%#f@%kfffffk#k#fffkk#k#k#k#%k#fk
	fk%kff@k#f@k#fff@fffff@f@fk%kf@%fkfffkkffkffkfk#%fk%k#k#k#fkf@f@k#f@k#f@k#ff%k#=%ffk#k#k#f@k#kfkffkk#ffkf%k#%kfffkffffff@f@k#%ff%k#fkkfffffffffk#k#f@kffk%ffk%f@k#k#k#kfk#k#ff%f%kffkfffkfkffk#fkfkkf%@k#fk


;OBF_LABEL name: testguisubmit
	fffk%f@fff@fff@fkf@fkkffkff%%fkffk#f@f@ffk#k#kfkff@fk%%k#fff@ffk#kffff@kff@kf%%k#fffkf@fffkfkkffk%ffkf%f@f@k#fff@fkfffk%fffkffkffffff=f%fkk#k#f@fff@fff@ffffffkf%k%fkkff@f@kfk#ffff%k%fkffkfkfk#f@fff@%k#%f@ffffffk#kff@f@f@ffk#f@%@%ffkfk#f@f@kffkf@kfffkfk#%#kfkff@fkkfk#fk
	fkkf%f@ffffffk#kff@f@f@ffk#f@%@f%fffffkffkfk#fkffkfkfkff@%fkk#fkk%fkfkk#f@f@f@k#k#ffffk#ff%#fffkfkfffkkfkfffff=f%fkfffkkffkffkfk#%k%f@k#kff@kfk#fkfkf@f@fffk%k#f@%kffkfkkffff@f@fkf@fkffkf%k#kf%kff@kfkff@kfffk#kfkf%ff@%f@kffkf@kfk#k#k#fkkfff%fkkfk#fk
;OBF_LABEL name: cancelprog
	k#fk%f@f@k#fff@fkfffk%ff%f@fffkfkk#fkk#%kf%f@k#kff@kfk#fkfkf@f@fffk%f@k#%k#fff@ffk#kffff@kff@kf%%fkkfkffkk#f@f@ff%ffffffkfk=f@k%f@k#ffk#fkfkk#%#f%f@kfkffkfkk#ffffkff@%fff@f%k#fff@ffk#kffff@kff@kf%f%f@fkk#k#k#fff@fffkf@fk%k#fffffkf@f@f@kffkfffk
	k#%k#fff@ffk#kffff@kff@kf%kfff@%k#f@ffffk#f@k#f@kffk%#k%f@fffkfkk#fkk#%%fff@f@fkf@ffkff@fffkffkf%kffkffffkf=%fkffkfkfk#f@fff@%@k#fk%f@fkk#k#k#fff@fffkf@fk%%kfk#k#kffkk#ffkf%ff@ffffk#fffffkf@f@f@kffkfffk
;OBF_LABEL name: guigosub
	fff%k#kff@f@kfk#kfkfkf%%ffffk#ffkffkkff@k#%f%f@k#kff@kfk#fkfkf@f@fffk%kfkfk#fff@fkk#kff@k#fkk#fkf@=fkfff@k%f@f@kfk#f@ffk#%#k#k#fk%ffkfkff@kfffkffkffk#ffk#%#kffff%f@ffkfk#f@fffkf@f@k#ff%f@fkf@k#
	k#%f@fkf@ffk#f@ff%kkfk#f%k#kfkffffkfffff@kff@%%fffkk#k#fkkffff@fkfkk#ff%f@kfk#fkfkk#f@k#ffk#kfffk#=fkfff@%kff@f@k#fff@kfkf%#k#k#fk%f@fffkf@f@f@f@fkff%k#kfff%fffkf@f@f@f@fk%f%kff@kfkff@kfffk#kfkf%f@fkf@k#



;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
%kff@k#fkkffkfkfffkfkff%%ffffk#kffkfkfkkff@f@%ffk%ffffk#ffkffkkff@k#%fkkf%ffffkfkffkfkfk%f@ffk#kf = 1
ffk%fff@f@fkf@ffkff@fffkffkf%%ffffk#k#fkk#fkkff@f@k#fk%f@fkk%f@ffkfk#kfkffffff@fkf@kf%#kfkffk = 0

;AUTOHOTKEY BUILT IN FUNCTIONS!
;tell obfuscator to obfuscate these autohotkey built in functions
;$OBFUSCATOR: $DEFSYSFUNCS: substr, strlen, chr, asc, instr, 

;BECAUSE THIS PROGRAM HAS 'SECURE' OBFUSCATION CLASSES
;DUMPS MUST BE DONE FOR EACH SECURE CLASS!
;they will be done in the following functions:
;'SECURITYTESTS_bestcodesection' and 'WIREUP_bestcodesection'.
;the first function will pop a dialog box to the user if they
;want to run the program simulating security passed or security failed.
;poisened DUMPS can be run in that function!

;i will DUMP good security fragments or poisened security fragments
;for a secure obfuscation class named 'bestcodesection'

fff%kff@k#fkkffkfkfffkfkff%%f@kffkf@f@fff@%%fkfkfkf@kfkff@f@fkkf%%fkffk#k#k#k#ffkfk#%ffkfffffffff()

;now i will DUMP triple mess fragments and object name fragments
;for a class named 'bestcodesection'. if poisened security fragments
;were dumped above, then the wiring up below will all be done wrong!
%f@fkkfk#ffk#ffk#f@k#%%fff@fkfkf@kfk#%ff%kff@kfkff@kfffk#kfkf%%fkk#fkf@fkk#kfk#k#%f@%f@kff@fkk#fffkf@ffk#%k#kff@()

;now i call a function that is in the 'bestcodesection' class.
;if the wiring up above has gone bad, then a call to the function
;below will end up with an ugly result or not running at all!
MsgBox, 4, RUN TEST, %kfk#fffkfkf@f@k#f@k#f@kf%%ffk#f@k#k#f@fk%%kfk#k#kffkk#ffkf%`n`nRUN TEST?`nCall the function named 'function_in_bestcodesection' in 'bestcodesection'?	
IfMsgBox Yes 
{
	%f@ffkfk#kfk#kfk#kf%%fkk#k#kfkff@%%ffk#f@kffkk#k#kfffk#f@%()
	msgbox, %fkffk#k#k#k#ffkfk#%%fkkff@ffk#k#ffkfff%%ffk#f@k#k#f@fk%`n`nINTERPRET TEST RESULTS:`nMessage '123' should have shown! Otherwise the function never executed.
}

;now i call a label that is in the 'bestcodesection' class.
;if the wiring up above has gone bad, then a call to the function
;below will end up with an ugly result or not running at all!
MsgBox, 4, RUN TEST, %ffk#f@kffkk#k#kfffk#f@%%ffk#f@k#k#f@fk%%ffk#kff@fffkk#f@fkfkfffk%`n`nRUN TEST?`nCall the label named [gosubin_bestcodesection] in 'bestcodesection'?	
IfMsgBox Yes 
{
	gosub, k%kfk#fkk#fkf@kfkfk#f@fkff%f@%k#fkk#kfk#ffkfkff@fffk%kff%fkkffkk#fkffkfk#kfk#fk%f%k#k#kfk#k#fkfkf@fkkffffkf@%ffkkffkkffffk
	msgbox, %ffk#f@k#k#f@fk%%kffff@ffkffkffkff@%%k#kfkfkfk#ffkf%`n`nINTERPRET TEST RESULTS:`nMessage 'abc' should have shown! Otherwise the label wasn't called.
}

;now i call a function that creates a gui but the gui has a reference
;to a label that will be bad if you have choosen to simulate security
;failed. 
MsgBox, 4, RUN TEST, %ffk#f@k#k#f@fk%%f@kffkf@kfk#k#k#fkkfff%%f@k#kfk#kff@kf%`n`nRUN TEST?`nCreate GUI with reference to label in`nprotected class in it?	
IfMsgBox Yes 
{
	;tests local variables, global variables, gosub label as 
	;part of a 'gui, add' statement, and variables defined as associated
	;with a gui control
	fff@%fffffkffkfk#fkffkfkfkff@%@ff%f@fkkfkffkfkk#ff%%fkfkfkfkfkkfk#ffffffk#kf%k#k#%kffffkfffkffkf%f@f@()
	
	msgbox, %ffk#f@k#k#f@fk%%kfffffk#k#fffkk#k#k#k#%%fkffk#k#k#k#ffkfk#%`n`nINTERPRET TEST RESULTS:`nThis message should show!
}
	 
RETURN

;the first statement creates a 'secure' class and the second
;statement tells it to add the function and label sections that
;follow in the source code to that class

;$OBFUSCATOR: $CREATEOBJCLASS: bestcodesection
;$OBFUSCATOR: $ADDFOLLOWING_TOCLASS: bestcodesection

;FUNCTION ORIGINAL NAME: function_in_bestcodesection
k#f@k#fkk#k#() { 
	global
	
	;yady yady yada
	
	msgbox, %fkfkkffff@k#f@fkf@fk%%ffk#f@k#k#f@fk%%ffk#k#ffk#fffkk#%`n`nInside function named [function_in_bestcodesection]`n`nMESSAGE: 123
}


;FUNCTION ORIGINAL NAME: returnfrom_bestcodesection
fkf@fkkff@f@f@ff() { 
	global
	
	return "hello from function named [returnfrom_bestcodesection]"	
}


;LABEL ORIGINAL NAME: gosubin_bestcodesection
k#f@kffffffkkffkkffffk:
	msgbox, %f@fkk#f@fkfkkffffkff%%fkkff@ffk#k#ffkfff%%ffk#f@k#k#f@fk%`n`nInside label named [gosubin_bestcodesection]`n`nMESSAGE: abc
return

;this tells the obfuscator to stop adding function and label sections
;to the class
;$OBFUSCATOR: $ADDFOLLOWING_TOCLASS:


;FUNCTION ORIGINAL NAME: SECURITYTESTS_bestcodesection
fff@ffkfffffffff() { 
	global
;$OBFUSCATOR: $DEFGLOBVARS: securitypassed
	
	MsgBox, 4, SHOULD SECURITY PASS, SHOULD SECURITY BE COUNTED AS PASSED?`n`nShould this run of this program be`ncounted as passing security?

	;the only difference in the program will be the 2 DUMPS
	;everything else remains the same with no security forks
	IfMsgBox Yes 
	{
	;SECURITY CLASS FRAG: for class: bestcodesection for char: f
	kffk%f@fkfff@k#ffkffkkff@f@kf%fk#f%fffffkffkfk#fkffkfkfkff@%ff%fff@fkf@kff@kfk#ff%ffkf%f@f@k#fff@fkfffk%#ff:=%fkffkffffkffff%fkkf%fkk#k#f@kffkk#%#k#%fkffkfkfk#f@fff@%@f%fkffk#k#fkfkfkf@k#kf%fkfkfk#fkk#
	;SECURITY CLASS FRAG: for class: bestcodesection for char: k
	fkkffk%k#k#ffffkffkk#k#f@k#ffff%f%f@f@fff@f@ffk#%f@fff@%kff@kfkff@kfffk#kfkf%#kff@f@:=k#%kff@kfkff@kfffk#kfkf%#f%fkfkfkf@kfkff@f@fkkf%@%k#kff@fkk#f@kf%%ffffk#kffkfkfkkff@f@%#kff@fkkfkffkfkk#
	;SECURITY CLASS FRAG: for class: bestcodesection for char: @
	k#%kffffkffk#k#f@fkkf%f%ffkfkff@kfffkffkffk#ffk#%fkk%fkkfk#kffkkff@kf%f%ffk#kffkk#fkf@ff%%fkkff@f@kfk#ffff%fkk#f@:=fkf@%f@fkf@ffk#f@ff%@fkff%k#kfkffffkfffff@kff@%fkfk%kfkfk#ffffffk#f@kff@fff@%f
	;SECURITY CLASS FRAG: for class: bestcodesection for char: #
	k#k%k#kfkfkfk#ffkf%#k%f@kfffk#fkffffk#k#fk%#ff%k#k#f@k#kff@fkkfkffkfkk#%#fkf%kff@f@k#fff@kfkf%ff%f@fkfff@k#ffkffkkff@f@kf%fkfk#:=%kfkfk#ffffffk#f@kff@fff@%%kfffffk#k#kfffkfff%f%ffkfk#f@f@kffkf@kfffkfk#%#f@kfffkfff
	;SECURITY CLASS FRAG: for class: bestcodesection for char: NULL
	fk%fkk#k#k#fkk#k#ff%k%k#k#fkkfkfk#kfkf%#fkf%fkkfk#k#f@ffkfkfk#fkk#%k#f%kfk#fffkfkf@f@k#f@k#f@kf%kk#k%fffkf@fffffkfkfkk#%fkf:=kffk%f@fkf@ffk#f@ff%@f%fff@fkf@kff@kfk#ff%@k%k#k#k#fkf@f@k#f@k#f@k#ff%kfk#kfk#k#

		ffk%k#kffkf@fkfkkffff@k#%f@%kfffffk#k#kfffkfff%k%kff@k#fkkffkfkfffkfkff%#k%ffk#k#ffk#fffkk#%#f@fk = SIMULATING SECURITY PASSED THIS RUN`nEverything should run as expected
	} else {
	;POISENED SECURITY CLASS FRAG: for class: bestcodesection for char: f =poisened char: #
	kffk%f@kfffk#fkffffk#k#fk%%f@fkk#k#k#fff@fffkf@fk%f%f@f@k#fff@fkfffk%#fff%k#fff@ffk#kffff@kff@kf%ffkfk#ff:=f%fff@k#kffkffk#fffffk%kk%fkkfk#kffkkff@kf%%fkffkfkfk#f@fff@%kffkffffkk#fkff
	;POISENED SECURITY CLASS FRAG: for class: bestcodesection for char: k =poisened char: NULL
	fkk%f@k#kff@kfk#fkfkf@f@fffk%f%kff@fkfkffkfkffk%k%fffffkf@fkkfkffkfkfffk%%ffkffffkffffk#%ff@%fff@f@fkf@ffkff@fffkffkf%ff@k#kff@f@:=kff%ffk#f@kffkk#k#kfffk#f@%k%fkffkfkfk#f@fff@%k%k#k#f@k#kff@fkkfkffkfkk#%ffff@%fkffkfkfk#f@fff@%@fkf@fkffkf
	;POISENED SECURITY CLASS FRAG: for class: bestcodesection for char: @ =poisened char: f
	k#f%f@kfkffkfkk#ffffkff@%fkk%fkk#fkffkffffkk#fkff%f@f%fffkkfffk#f@f@kffk%kk#f@:=f%k#fffkf@fffkfkkffk%k#k#%kfkfk#ffffffk#f@kff@fff@%#f%fff@fkf@kff@kfk#ff%kk%kfk#kfkffff@fkkfkfkf%#k#ff
	;POISENED SECURITY CLASS FRAG: for class: bestcodesection for char: # =poisened char: k
	k#%fffffkf@fkkfkffkfkfffk%k#%kfffffk#k#fffkk#k#k#k#%k%fkfffkkffkk#ffff%ff%kfffkffffff@f@k#%#fk%k#fff@ffk#kffff@kff@kf%kffffkfk#:=k#fffk%k#kfk#fkf@k#fkff%f%k#k#ffffkfk#f@fkf@k#f@%%fkffkfkfk#f@fff@%ffkfkkffk
	;POISENED SECURITY CLASS FRAG: for class: bestcodesection for char: NULL =poisened char: @
	fkf%fkkfkffkk#f@f@ff%kk#%fff@f@fkf@ffkff@fffkffkf%k%f@fkfff@k#ffkffkkff@f@kf%fk#fkk#kfkf:=k#ff%fkk#k#k#fkk#k#ff%kk%fkkff@f@fff@kffff@kf%fff%kff@f@fff@kfkf%f%fkk#k#k#fkk#k#ff%k#kffffk

		%fffffkf@fkkfkffkfkfffk%%kffff@fkfffkf@fk%%kff@f@kffkkff@ffkff@% = SIMULATING SECURITY FAILED THIS RUN`nEverything SHOULD HAVE PROBLEMS running!
	}
}


;FUNCTION ORIGINAL NAME: WIREUP_bestcodesection
fffkf@k#kff@() { 
	global	
;TRIPLE MESS FRAGMENTS for class: bestcodesection for char: f
	k#%f@kfffk#fkffffk#k#fk%k%fff@f@fkfkf@f@kff@%%fkfffkkffkkfk#f@%%f@k#kff@kfk#fkfkf@f@fffk%kkffffkfkfkffkff@:=f@fk%fkkffkfff@fff@k#kff@f@%fk#ffk%k#k#k#ffk#fkfkffffkfk#%f%kffkffk#ffffffkfk#ff%k#f@k#
	k#fff%k#fffkkfffffk#kffffk%k#%fkfffkkffkffkfk#%#ffkfk%k#kfk#fkf@k#fkff%#f%f@f@kfk#f@ffk#%@f@fkf@kf:=k#f%kffkffk#ffffffkfk#ff%f@f%kffkffk#ffffffkfk#ff%k#kf%kffkffk#ffffffkfk#ff%ff@kff@kf
	f%fkfkfkffffk#kfk#ffkf%%fffkkfffk#f@f@kffk%f@f%fkk#k#f@kffkk#%%kff@kfkfkff@fk%kff%fffffkffkfk#fkffkfkfkff@%kff@f@k#:=kff@k#f%k#fkfkk#f@fkk#f@%k#fff@f%kffkffk#ffffffkfk#ff%ff%kffkffk#ffffffkfk#ff%@f@fk
	f%fffkfkfkf@f@kffff@%@f@k#%fkk#fkf@fkk#kfk#k#%fk%ffffk#kffkfkfkkff@f@%%fkk#fff@k#k#f@fffk%kff%kff@kfkff@kfffk#kfkf%fkfffkfkf@ff:=f@f%fkkffkfff@fff@k#kff@f@%fff@%fkkffkfff@fff@k#kff@f@%#ffkffk%fkkffkfff@fff@k#kff@f@%ff@f@kf
	fk%fkfffkkffkffkfk#%fk%fkffk#fff@ffk#fkf@fkk#ff%kff%f@f@kffkf@k#f@f@f@f@%k#%ffffkffkfkk#fkfkf@kfk#k#%fkkffkkfk#fkf@:=%kffkffk#ffffffkfk#ff%kk#%fkkffkfff@fff@k#kff@f@%#k%k#k#k#ffk#fkfkffffkfk#%fkk#k#ff
	kff%f@fkf@fff@k#kffkfkffk#%k%ffkffffkffffk#%f%f@k#k#fffkfkk#f@ffffkf%kkfkffkf@:=f@fff%kffkffk#ffffffkfk#ff%ffk#k%kffkffk#ffffffkfk#ff%f@f@f@ffk#f@
	fkkff%k#f@ffffk#f@k#f@kffk%k#%kff@kfkfkff@fk%f%k#f@fkfffff@k#kffk%ffkfk#kfk#fk:=fffffkf%kffkffk#ffffffkfk#ff%kfk#f%fkkffkfff@fff@k#kff@f@%ffkfkfkff@
	f@k#kf%k#fffkf@fffkfkkffk%#f%k#kff@fkk#f@kf%fk#f%f@kfkffkfkk#ffffkff@%fkfff%kffkfkkffff@f@fkf@fkffkf%@fffkff:=fk%kffkffk#ffffffkfk#ff%fk%k#k#k#ffk#fkfkffffkfk#%f%kffkffk#ffffffkfk#ff%f@ffk#fkf@fkk#ff
	fff%f@fkf@ffk#f@ff%kff%fkfkfkfkfkkfk#ffffffk#kf%kkfff%fffkffffk#kffkk#k#k#fk%%f@kfkffkfkk#ffffkff@%fkfk#kffk:=fkk#k#%fkkffkfff@fff@k#kff@f@%%k#k#k#ffk#fkfkffffkfk#%fkk#k#ff
	%fkffk#k#k#k#ffkfk#%k#%fkk#k#f@kffkk#%ff%k#k#fkkfkfk#kfkf%kf%fkfkkffff@k#f@fkf@fk%k#k#fff@f@ffk#fff@:=fff%k#fkfkk#f@fkk#f@%f@fkf%k#fkfkk#f@fkk#f@%ff%fkkffkfff@fff@k#kff@f@%ff@fffkffkf
;TRIPLE MESS FRAGMENTS for class: bestcodesection for char: k
	kfff%k#kfk#f@f@k#f@%%f@fkfff@k#ffkffkkff@f@kf%f@fkk%kfk#fffff@fffkfffff@ff%fk#ff:=f%k#fkfkk#f@fkk#f@%f@%fkkffkfff@fff@k#kff@f@%#fff@fkfffk
	ff%fff@f@fkf@ffkff@fffkffkf%%kffkfffkfkffk#fkfkkf%f%kfkfkffkkfkfffk#%f%f@k#kff@kfk#fkfkf@f@fffk%fkf@fffkf@:=ffkf%fkkffkfff@fff@k#kff@f@%ff@kff%kffkffk#ffffffkfk#ff%kffkffk#ffk#
	f@kf%ffffk#kffkfkfkkff@f@%%f@fff@fff@fkf@fkkffkff%#ffff%fkk#k#f@kffkk#%#f@f@ffk#kfk#:=kff@kfk%kffkffk#ffffffkfk#ff%f@kfffk%k#k#k#ffk#fkfkffffkfk#%kfkf
	k#k#%fkkfkffkfkf@k#ffffk#k#%@%kff@f@k#fff@kfkf%fk#%fkk#k#f@fff@fff@ffffffkf%fkfkk#fff@f@:=kfk%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%#%kffkffk#ffffffkfk#ff%fffffk#f@kff@fff@
	k#k%k#k#ffffkffkk#k#f@k#ffff%#%kfk#fffkfkf@f@k#f@k#f@kf%kf%f@fkfff@k#ffkffkkff@f@kf%@%kfkffffffff@fkk#f@%kfk%k#fffkf@fffkfkkffk%fk#:=%kffkffk#ffffffkfk#ff%fffk%k#k#k#ffk#fkfkffffkfk#%k%kffkffk#ffffffkfk#ff%fkfkfkkff@f@
	f@f@%kff@k#fkkffkfkfffkfkff%fff%kffffkffk#k#f@fkkf%kff%kff@k#f@k#fff@fffff@f@fk%@f%fkkfk#k#f@ffkfkfk#fkk#%fk%f@ffffffk#kff@f@f@ffk#f@%kkf:=f%kffkffk#ffffffkfk#ff%kfk%kffkffk#ffffffkfk#ff%f@kfffkffkffk#ffk#
	k%fffkf@f@f@f@fk%ff%f@fffff@fffkf@k#f@f@fff@%ff@fk%f@k#kff@kfk#fkfkf@f@fffk%%f@f@k#fff@fkfffk%kffff@f@fk:=%kffkffk#ffffffkfk#ff%f%kffkffk#ffffffkfk#ff%fk#kffkfkfkkff@f@
	f@fff%fkffk#k#fkfkfkf@k#kf%kkfk#%fkffkfkfk#f@fff@%f%f@fkf@ffk#f@ff%ff@kfkfkf:=k%kffkffk#ffffffkfk#ff%fffk%fkkffkfff@fff@k#kff@f@%#f%fkkffkfff@fff@k#kff@f@%k#ffk#kf
	fk%f@fffkfkk#fkk#%fkf%f@kff@fkk#fffkf@ffk#%kfk%ffkffffkffffk#%fk#%f@fkkfk#ffk#ffk#f@k#%kfkk#ffffff:=f%k#fkfkk#f@fkk#f@%%kffkffk#ffffffkfk#ff%@k#f%kffkffk#ffffffkfk#ff%f@fkfffk
	kff%k#fkfkffkfkfffffffk#kff@%kkff@%k#f@fkfffff@k#kffk%#%fkfffkkffkffkfk#%#k#ffk#fkf@kf:=kfffk%kffkffk#ffffffkfk#ff%fffff%k#fkfkk#f@fkk#f@%f@k#
;TRIPLE MESS FRAGMENTS for class: bestcodesection for char: @
	k#%f@ffkfk#f@fffkf@f@k#ff%fk#k%kfffk#fkf@kfffkfkfffkf%f%k#kffkf@kffkkfffkfkff@%kf%kfk#f@fkk#kfffk#k#fkkf%ffkf:=k%k#k#k#ffk#fkfkffffkfk#%k%kffkffk#ffffffkfk#ff%f%k#fkfkk#f@fkk#f@%f@kfk#kfkfkf
	k%fkkfk#kffkkff@kf%k#%ffkffffkffffk#%%kff@kfk#fffkffffk#k#%f@%kfffffk#k#fffkk#k#k#k#%fk%fkfkfkf@kfkff@f@fkkf%k#f@k#kf:=f@f@ff%kffkffk#ffffffkfk#ff%kfkkfk%k#k#k#ffk#fkfkffffkfk#%f@kfkff@
	fkf@f%k#k#ffffkfk#f@fkf@k#f@%f@f@ff%k#fff@ffk#kffff@kff@kf%ff@fk%f@k#kffffkk#fkk#fkff%kfffkf:=k#k#%kffkffk#ffffffkfk#ff%@k%k#k#k#ffk#fkfkffffkfk#%kff%k#fkfkk#f@fkk#f@%f@f@
	f@kff@%fffffkffkfk#fkffkfkfkff@%%fkkfkffkk#f@f@ff%@ff%ffkfkff@kfffkffkffk#ffk#%f%fkkff@f@kfk#ffff%fkfkf@k#fkffff:=kf%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%f@k%k#k#k#ffk#fkfkffffkfk#%kfkfk#fkfkkf
	%f@ffkfk#f@fffkf@f@k#ff%f%kff@f@fff@kfkf%fkf%kfffkffffff@f@k#%fkkfkfkf:=k%k#k#k#ffk#fkfkffffkfk#%k%k#k#k#ffk#fkfkffffkfk#%f@k%k#k#k#ffk#fkfkffffkfk#%kff@f@f@
	fkk#%fkk#k#k#fkk#k#ff%ff@%kfffffk#k#kfffkfff%kfk%f@k#f@ffkfffffffk#%f@ffkfffkff@:=f%k#fkfkk#f@fkk#f@%%kffkffk#ffffffkfk#ff%@kffkf@k#f@f@f@f@
	%fff@f@fkf@ffkff@fffkffkf%fk%kfkff@k#ffffk#fff@%ff%f@fkfff@k#ffkffkkff@f@kf%fffkf@k#ff:=%kffkffk#ffffffkfk#ff%kf@%kffkffk#ffffffkfk#ff%@fkfffkfkkf
	kf%f@k#kff@kfk#fkfkf@f@fffk%%f@fkfffkkfk#kfffkf%kk#k%f@k#k#k#kfk#k#ff%k%fkfkkffff@k#f@fkf@fk%%k#k#k#fkf@f@k#f@k#f@k#ff%k#k#f@kffkkff@:=f@f@f%kffkffk#ffffffkfk#ff%fkfkk%kffkffk#ffffffkfk#ff%k%k#k#k#ffk#fkfkffffkfk#%f@kfkff@
	%fkffkfkfk#f@fff@%%k#fkfkffkfkfffffffk#kff@%%kfffffffk#f@f@f@k#fkfk%ff%fkk#fkkff@f@k#f@fkkffkff%k#kff%f@fkkfk#ffk#ffk#f@k#%fkkfffk#k#f@k#f@:=k#kff%fkkffkfff@fff@k#kff@f@%f@kffkk%kffkffk#ffffffkfk#ff%ffk%kffkffk#ffffffkfk#ff%kff@
	f%fffffkffkfk#fkffkfkfkff@%k%kff@kfkfkff@fk%f%kfkff@k#ffffk#fff@%f@f%fkfkfkffffk#kfk#ffkf%%ffkffffkffffk#%kfkk#kf:=fkkf%kffkffk#ffffffkfk#ff%fk#%kffkffk#ffffffkfk#ff%kf@k%kffkffk#ffffffkfk#ff%
;TRIPLE MESS FRAGMENTS for class: bestcodesection for char: #
	ffk#%fffffkffkfk#fkffkfkfkff@%f%ffkffffkffffk#%fk#k#%kff@k#ffk#fkff%k#f@f%kfkff@k#ffffk#fff@%kkff@:=k#k#%fkkffkfff@fff@k#kff@f@%#fkf@%kffkffk#ffffffkfk#ff%@k#%kffkffk#ffffffkfk#ff%@k#f@k#ff
	fff%k#k#kfffk#kfffkff@f@k#%%kfkfkffkkfkfffk#%fk%fkkfk#k#f@ffkfkfk#fkk#%@ff%fkffkfkfk#f@fff@%@k#ffk#:=fk%kffkffk#ffffffkfk#ff%f%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%kffkkfk#f@
	k#fk%kff@f@k#fff@kfkf%#%kff@fkfkffkfkffk%f@f@kf%fkffkfkfk#f@fff@%@k#fffk:=f@kfkf%fkkffkfff@fff@k#kff@f@%#%kffkffk#ffffffkfk#ff%%kffkffk#ffffffkfk#ff%k#kff@k#kf
	f@%f@k#kffffkk#fkk#fkff%fff@%kffkf@f@k#kfk#kfk#k#%kfkf%f@k#kffkkfk#fkf@fffkkfk#%fk#%fkkfk#k#f@ffkfkfk#fkk#%f:=fkfffk%fkkffkfff@fff@k#kff@f@%%kffkffk#ffffffkfk#ff%fkkfk#f@
	kf%fkk#k#k#fkk#k#ff%%ffk#kff@fffkk#f@fkfkfffk%@%k#k#fkkfkfk#kfkf%#f@%ffkfk#f@f@kffkf@kfffkfk#%#kf%f@f@fff@kfffkfkff@f@fkf@%fkkf:=fkf%kffkffk#ffffffkfk#ff%fkk%kffkffk#ffffffkfk#ff%f%fkkffkfff@fff@k#kff@f@%kfk#f@
	%f@ffffffk#kff@f@f@ffk#f@%ff%k#k#fkkfkfkfffkffkfffk%%fffkfkk#k#fkkffkk#fkf@ff%%ffkffkf@fkkff@fffkk#k#%k#fkfffff@f@fkfkff:=k%k#k#k#ffk#fkfkffffkfk#%fff@f%fkkffkfff@fff@k#kff@f@%f@fff@f@kf
	ffkf%fkffkffffkffff%f@%fkffk#fff@ffk#fkf@fkk#ff%kkff@%fkk#k#k#fkk#k#ff%fffk#%k#k#fkkfkfk#kfkf%fk#kf:=fkk#f%fkkffkfff@fff@k#kff@f@%%kffkffk#ffffffkfk#ff%fkffffkk#fkff
	kf%f@kff@fkk#fffkf@ffk#%f@ff%k#fffkf@fffkfkkffk%ffkk#f%k#kffkf@kffkkfffkfkff@%f@fk%k#kfk#f@f@k#f@%fkfkf:=f@k#f@f%kffkffk#ffffffkfk#ff%kffff%kffkffk#ffffffkfk#ff%ffk#
	%fffkfkk#k#fkkffkk#fkf@ff%k%kfkffffffff@fkk#f@%k#%f@k#kff@kfk#fkfkf@f@fffk%k%k#f@fkfffff@k#kffk%#fkf@kfkfk#f@fkff:=fkk%k#k#k#ffk#fkfkffffkfk#%fkf%kffkffk#ffffffkfk#ff%kffffkk#fkff
	kfkf%ffffk#kffkfkfkkff@f@%fk#fff%ffk#kff@fffkk#f@fkfkfffk%kf@fk%f@k#kff@kfk#fkfkf@f@fffk%kk#k#:=fkk#fk%kffkffk#ffffffkfk#ff%%kffkffk#ffffffkfk#ff%kff%kffkffk#ffffffkfk#ff%fkk#fkff
;TRIPLE MESS FRAGMENTS for class: bestcodesection for char: NULL
	fkf@k%f@f@kfk#f@ffk#%f%fkk#k#f@kffkk#%fk#f@k%f@k#f@ffkfffffffk#%%ffffk#kffkfkfkkff@f@%fffkffffk:=fk%fkkffkfff@fff@k#kff@f@%#k#f@f%kffkffk#ffffffkfk#ff%%kffkffk#ffffffkfk#ff%@fff@ffffffkf
	fff%fkffk#fff@ffk#fkf@fkk#ff%f@%fff@fkf@kff@kfk#ff%f@k%f@fkk#fkfkkfffk#kfk#%fkfkk%f@fkfkk#fkfffff@%#ffkfk#kfff:=kfk%k#k#k#ffk#fkfkffffkfk#%k#kf%kffkffk#ffffffkfk#ff%kk#ffkf
	fff@%k#f@fkfffff@k#kffk%%f@kfkfk#ffk#kff@k#kf%%f@fkkfk#ffk#ffk#f@k#%k%fkffk#k#k#k#ffkfk#%fkkffkf@ffk#k#kffk:=fkfkk%kffkffk#ffffffkfk#ff%fkk#f@k%kffkffk#ffffffkfk#ff%f%fkkffkfff@fff@k#kff@f@%k#fkf@
	%ffkffffkffffk#%%fkk#kff@f@kfffk#%%k#kfk#fkf@k#fkff%%fff@k#kffkffk#fffffk%%kffff@kfkfkfk#kfkf%kfkfkfkf@fffkfkf@fkffkf:=fkffk%k#k#k#ffk#fkfkffffkfk#%k#k#k%k#k#k#ffk#fkfkffffkfk#%ffkfk#
	k%k#fkkfk#kfkfkffffkf@fk%ff@f%k#fff@ffk#kffff@kff@kf%fk%kff@f@k#fff@kfkf%#k%kfkffffffff@fkk#f@%kfff:=f%fkkffkfff@fff@k#kff@f@%ffk#k#%fkkffkfff@fff@k#kff@f@%#k#ffkfk#
	f@fff%fkfkkffkk#f@kffkk#fkf@%k%fkk#k#f@kffkk#%#kfkfk%fkkfkffkfkf@k#ffffk#k#%fkf@k#%f@fkkfk#ffk#ffk#f@k#%fk#:=kff%kffkffk#ffffffkfk#ff%fff%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%#f@f@f@k#fkfk
	fk%kfffffffk#f@f@f@k#fkfk%fk%kffkf@fkfkk#ff%k#f%ffkfkff@kfffkffkffk#ffk#%fk%f@fkkfk#ffk#ffk#f@k#%@fk:=%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%ff%fkkffkfff@fff@k#kff@f@%ffffkffff
	%fkffk#fff@ffk#fkf@fkk#ff%%k#k#kfffk#kfffkff@f@k#%fff@%f@fkfff@k#ffkffkkff@f@kf%@k#fk%kffkfffkfkffk#fkfkkf%fkfk%kff@ffkffkfkfkfkk#kf%ffkff@f@ff:=fkf%kffkffk#ffffffkfk#ff%kf%kffkffk#ffffffkfk#ff%ffkf%kffkffk#ffffffkfk#ff%ff
	k#fk%f@kfkffkfkk#ffffkff@%fk%k#k#k#fkf@f@k#f@k#f@k#ff%f@f%kff@kfkfkff@fk%fk#k%f@k#k#fffkfkk#f@ffffkf%%f@fkkfk#ffk#ffk#f@k#%f@fffffkkf:=k%kffkffk#ffffffkfk#ff%fkf@f%k#fkfkk#f@fkk#f@%k#k%kffkffk#ffffffkfk#ff%k#kfk#k#
	fff@ff%f@fffkffk#k#fff@ffk#f@%kff%fkfkfkf@kfkff@f@fkkf%@k#%k#fff@ffk#kffff@kff@kf%ff%kff@kfk#fffkffffk#k#%kffkkfkf:=fffk%kffkffk#ffffffkfk#ff%@f%k#fkfkk#f@fkk#f@%f@f@%kffkffk#ffffffkfk#ff%k
	ffk#f%fffkfkfkf@f@kffff@%%fkfffkkffkffkfk#%k#%f@ffffffk#kff@f@f@ffk#f@%kffffk#kf:=%kffkffk#ffffffkfk#ff%fkff%kffkffk#ffffffkfk#ff%kfkfkffkkfk#k#fkf@
	fkkf%fffffkffkfk#fkffkfkfkff@%ff@f%fkfkk#fff@fkk#fff@fkf@%@k#%f@fkfff@k#ffkffkkff@f@kf%fk#ffkf:=%kffkffk#ffffffkfk#ff%@fkk%k#k#k#ffk#fkfkffffkfk#%k#fkf@%kffkffk#ffffffkfk#ff%kk#k#
	fkf%f@f@fff@f@ffk#%kf%f@k#kff@kfk#fkfkf@f@fffk%ffkk%kfffffk#k#kfffkfff%fk#%kfffkffffff@f@k#%#k#%kfffffk#k#kfffkfff%f@f@:=f%fkkffkfff@fff@k#kff@f@%fffff%kffkffk#ffffffkfk#ff%fkk#fkf@k#f@
	f%kffffkffk#k#f@fkkf%@f%kff@k#f@k#fff@fffff@f@fk%kf%kff@fkfkffkfkffk%k#%k#fff@ffk#kffff@kff@kf%kk%k#k#k#fkf@f@k#f@k#f@k#ff%kff@:=k#k%kffkffk#ffffffkfk#ff%kfff%kffkffk#ffffffkfk#ff%kfffff@kff@
	%f@k#kffkkfk#fkf@fffkkfk#%#fkk%f@fkk#fkfkkfffk#kfk#%kfk#ff%kfkffkf@f@fkf@%kfkff@fffk:=kff%kffkffk#ffffffkfk#ff%f%fkkffkfff@fff@k#kff@f@%ffk#k#f@fkkf
	%f@ffkfk#f@fffkf@f@k#ff%ff%k#fffkf@fffkfkkffk%f@f%kffff@ffkffkffkff@%kkf%f@k#kff@kfk#fkfkf@f@fffk%%kffkfffkfkffk#fkfkkf%ffff@k#fff@fk:=k#%kffkffk#ffffffkfk#ff%ffkkfk#%fkkffkfff@fff@k#kff@f@%#ffk#kfk#
	k#%k#f@fkfffff@k#kffk%#kfk%fkffkffffkffff%#k#fk%fkkfkffkfkf@k#ffffk#k#%kf@fkkffffkf@:=%kffkffk#ffffffkfk#ff%@k%kffkffk#ffffffkfk#ff%ffk#f%fkkffkfff@fff@k#kff@f@%ffffk#k#fk
	k#k#%ffkfkff@kfffkffkffk#ffk#%#fkf@%fkffkfkfk#f@fff@%%k#k#f@k#kff@f@f@%ffk%ffkfffkfkfkffkkfk#k#fkf@%#f@kfkf:=fk%kffkffk#ffffffkfk#ff%kkfff%kffkffk#ffffffkfk#ff%%k#fkfkk#f@fkk#f@%k#f@fkf@fk
	k%fffkf@f@f@f@fk%#f@f%fffkk#k#fkkffff@fkfkk#ff%f%k#f@ffffk#f@k#f@kffk%k%k#k#f@k#k#ffkffffff@fk%%fkfffkkffkk#ffff%ffkffkfkff:=f@%kffkffk#ffffffkfk#ff%k%fkkffkfff@fff@k#kff@f@%#k#fkf@fkk#k#
	k#kfk%f@k#kff@kfk#fkfkf@f@fffk%fkk%fkk#k#k#fkk#k#ff%%fffffkffkfk#fkffkfkfkff@%k%k#k#ffffkffkk#k#f@k#ffff%kfffk#f@fff@:=%kffkffk#ffffffkfk#ff%kff%fkkffkfff@fff@k#kff@f@%#k%k#k#k#ffk#fkfkffffkfk#%fkfkfkf@k#kf
	k%ffk#k#ffk#fffkk#%#k#f@f%k#f@ffffk#f@k#f@kffk%f@kff%f@k#kffkkfk#fkf@fffkkfk#%kff@fk%fkk#k#k#fkk#k#ff%ff@f@:=fkk#f@%fkkffkfff@fff@k#kff@f@%%k#k#k#ffk#fkfkffffkfk#%kfk#kfkfffff
	f@%k#fffkf@fffkfkkffk%f%fkffkfkfk#f@fff@%%f@fkfffkkfk#kfffkf%%kffkkfkff@fffkkffkkffkff%kfff@fkfkfkk#f@f@kffk:=ff%kffkffk#ffffffkfk#ff%@%kffkffk#ffffffkfk#ff%@fkfkf@f@kff@
	k#%f@fffff@fffkf@k#f@f@fff@%kff%kfkffkf@f@fkf@%@f@%f@kfkffkfkk#ffffkff@%f%k#k#fkkfkfk#kfkf%fff:=kfk%k#k#k#ffk#fkfkffffkfk#%k#k%kffkffk#ffffffkfk#ff%fkk#%kffkffk#ffffffkfk#ff%fkf
	kff%f@f@fff@f@ffk#%k%fff@f@fkf@ffkff@fffkffkf%fk%kfkffkf@f@fkf@%f@ffffffk#fk:=fkffk#f%k#fkfkk#f@fkk#f@%f@ffk%k#k#k#ffk#fkfkffffkfk#%k#kfkff%k#fkfkk#f@fkk#f@%fk
	%k#k#f@k#kff@fkkfkffkfkk#%%k#k#ffffkffkk#k#f@k#ffff%%fkffk#k#fkfkfkf@k#kf%#k#%kfffkffffff@f@k#%#%fkffkfkfk#f@fff@%fk#fkfkf@:=f%k#fkfkk#f@fkk#f@%f%k#fkfkk#f@fkk#f@%fff@kfffkfkff@f@fkf@
	f%fkk#fkkff@f@k#f@fkkffkff%%kff@ffkffkfkfkfkk#kf%fkk#f%f@fkkfk#ffk#ffk#f@k#%f@%fffffkffkfk#fkffkfkfkff@%fffk#k#f@ff:=f@fk%kffkffk#ffffffkfk#ff%kk%k#k#k#ffk#fkfkffffkfk#%fkfffff@
	fkk%k#k#f@k#k#ffkffffff@fk%#%fkk#k#f@kffkk#%#k%fkk#fff@k#k#f@fffk%fff%kff@f@fff@kfkf%ffk:=f%kffkffk#ffffffkfk#ff%k#k#k#%kffkffk#ffffffkfk#ff%@k#kfkffkk#ffkf
	fkfk%f@fff@fff@fkf@fkkffkff%ffkf%f@kfkffkfkk#ffffkff@%fk%fkk#fff@k#k#f@fffk%kf%kff@kfkfkff@fk%f@kffffk:=%kffkffk#ffffffkfk#ff%@%kffkffk#ffffffkfk#ff%kk#k#%kffkffk#ffffffkfk#ff%kf@fkk#k#
	ff%k#fff@ffk#kffff@kff@kf%fff%f@fffkfkk#fkk#%f%f@k#k#fffkfkk#f@ffffkf%ff%kff@kfk#fffkffffk#k#%k%fkk#fkffkffffkk#fkff%ffkff@k#:=k%kffkffk#ffffffkfk#ff%f@fkfkf%kffkffk#ffffffkfk#ff%kfkffk
	f@f@%f@kffkf@kfk#k#k#fkkfff%f@f%k#f@fkfffff@k#kffk%ff%f@kfkffkfkk#ffffkff@%#%ffk#kff@fffkk#f@fkfkfffk%k#%f@k#kffkkfk#fkf@fffkkfk#%ff@k#:=fkkfk%kffkffk#ffffffkfk#ff%fkk#%kffkffk#ffffffkfk#ff%@f@ff
	f%f@kffkf@f@fff@%ff%ffffk#k#fkk#fkkff@f@k#fk%kf%f@k#kffkkfk#fkf@fffkkfk#%#kfk%fffkf@f@kfk#ffk#fffk%kfk#kf:=ff%kffkffk#ffffffkfk#ff%%fkkffkfff@fff@k#kff@f@%%kffkffk#ffffffkfk#ff%@f@f@f@fk
	fkf@f@%f@fkf@ffk#f@ff%fk%fkffk#k#fkfkfkf@k#kf%#kfff%f@fkfff@k#ffkffkkff@f@kf%kf%k#k#fkkfkfk#kfkf%fkfffffk:=f@ff%kffkffk#ffffffkfk#ff%%k#fkfkk#f@fkk#f@%fff@fkf@fkkffkff
	kff%k#kff@fkk#f@kf%@fff%f@f@kfk#f@ffk#%kkff%k#k#fkkfkfkfffkffkfffk%k%fffkf@f@kfk#ffk#fffk%f%f@f@fff@f@ffk#%fkkf:=ffff%kffkffk#ffffffkfk#ff%kf@fkk%kffkffk#ffffffkfk#ff%kffkfkf%kffkffk#ffffffkfk#ff%fk
	kf%f@fkkfkffkfkk#ff%ff%f@ffffffk#kff@f@f@ffk#f@%@fkf@%f@ffffffk#kff@f@f@ffk#f@%ffkkf:=k#fk%kffkffk#ffffffkfk#ff%kffkf%fkkffkfff@fff@k#kff@f@%f%kffkffk#ffffffkfk#ff%fffffk#kff@
	ffkfffk%fffkf@f@kfk#ffk#fffk%fffff@f%fff@ffk#ffk#kfffk#fk%@f%f@kfkffkfkk#ffffkff@%k#fkfkf@:=%kffkffk#ffffffkfk#ff%kkf%fkkffkfff@fff@k#kff@f@%ffk%fkkffkfff@fff@k#kff@f@%#f@f@ff
	%kfk#k#kffkk#ffkf%kf%kffff@kfkfkfk#kfkf%fk#%fkkfk#k#f@ffkfkfk#fkk#%ff@fkf@kffk:=%kffkffk#ffffffkfk#ff%@fkk#k%k#k#k#ffk#fkfkffffkfk#%fkf@fkk#k#
	%kff@k#ffk#fkff%k#k%f@fkk#k#k#fff@fffkf@fk%k%kffff@kfkfkfk#kfkf%fkk#kff@f@fkk#ffk#k#:=kff%k#fkfkk#f@fkk#f@%k#%kffkffk#ffffffkfk#ff%kk%kffkffk#ffffffkfk#ff%fkfkfffkfkff
	k#k%fkfkf@fkf@k#fffkfkffkf%kf%kfk#fffkfkf@f@k#f@k#f@kf%%kff@k#f@k#fff@fffff@f@fk%ffffkfkfk:=f@ffff%kffkffk#ffffffkfk#ff%@fffkf%k#fkfkk#f@fkk#f@%k#f@f@fff@
	k%kfkffffffff@fkk#f@%k%k#fkkfk#kfkfkffffkf@fk%%fkffkfkfk#f@fff@%k%fkfkk#f@f@f@k#k#ffffk#ff%f%fff@f@fkf@ffkff@fffkffkf%fkff@kffkf@:=%kffkffk#ffffffkfk#ff%fk#k%k#k#k#ffk#fkfkffffkfk#%%fkkffkfff@fff@k#kff@f@%#f@k#kfkffkk#ffkf
	fk%fkk#fkf@fkk#kfk#k#%fkkf%f@ffkfk#kfkffffff@fkf@kf%fkfk%ffkffffkffffk#%@fk%kfkffffffff@fkk#f@%%fffffkffkfk#fkffkfkfkff@%fffkfk:=k#kfk#f%fkkffkfff@fff@k#kff@f@%f@k%k#k#k#ffk#fkfkffffkfk#%fkff

;OBF_FUNC name: function_in_bestcodesection
	%kff@kfkff@kfffk#kfkf%%kff@k#ffk#fkff%#k%f@fkf@ffk#f@ff%%kffff@kfkfkfk#kfkf%fffffkf=k%ffk#ffffk#k#k#f@fkkff@%f@%k#fkk#kfk#ffkfkff@fffk%%f@ffkfk#fkk#kff@%k%f@fff@kfkfkfk#ff%fkk#k#
	%fkffkfkfk#f@fff@%%kfffkffffff@f@k#%k%f@k#ffk#fkfkk#%#k%f@k#k#k#kfk#k#ff%kfkff@=%fkfkfkfkffk#fkfkk#ffffff%%f@fffkk#kfkfkffkf@k#ffk#%#f@%f@fffkkfk#fffff@kfkfkf%#%f@f@fkkfffkff@f@k#%kk#k#
;OBF_FUNC name: returnfrom_bestcodesection
	%kffkkfkff@fffkkffkkffkff%%kff@f@fff@kfkf%%fkk#k#k#fkk#k#ff%%ffffk#kffkfkfkkff@f@%f@ffkffkfkff=f%fffffffff@k#ffkff@k#%kf@%f@k#kfk#ffk#fkfkfff@fffkff%kk%k#fff@k#k#ffkfk#f@f@fkf@kf%f%f@kff@f@ffkffkfkf@k#fkffff%f@f@ff
	%kff@f@fff@kfkf%fff@%ffkfk#f@f@kffkf@kfffkfk#%ffkf%fff@f@fkf@ffkff@fffkffkf%fk%k#kfk#f@f@k#f@%@k#=fkf%kfffk#fff@fkf@kffk%@fk%fkf@kfkfk#f@k#kfffkffffk%%kffffff@fkkfk#ff%f%fkkfkfkff@k#fkkffkkfk#fkf@%%fff@k#kffffkkfffk#k#f@k#f@%f@f@ff
;OBF_LABEL name: gosubin_bestcodesection
	fk%fkffk#fff@ffk#fkf@fkk#ff%kff%f@fkk#f@fkfkkffffkff%k#f@k%k#kff@fkk#f@kf%%fff@kfkfk#k#kfk#kfkf%k%kff@k#f@k#fff@fffff@f@fk%kff@kfffk#k#=k%f@fffkk#kfkfkffkf@k#ffk#%#f%fkfkk#fkfkf@fk%@%kffff@fkfkkffff@f@fk%ffff%ffffkffkkfffkfkfk#kffk%f%f@kfk#ffffk#f@f@ffk#kfk#%kffkkffffk
	%kfkfk#ffffffk#f@kff@fff@%#ffffff%k#kfk#f@f@k#f@%@fkfkkf%f@k#kffffkk#fkk#fkff%k#kffkfff@f@kfffk#=k#%k#fkkfk#f@ffk#kff@fffffkkf%%fkkffkk#fkffkfk#kfk#fk%@k%f@f@k#fkk#kffkfkfffkfkf@ff%fffffkkffkkffffk

}

 
;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;FUNCTION ORIGINAL NAME: creategui
fff@f@ffk#k#f@f@() { 
	global
	local kfk#fkk#k#ff, fkk#k#fkf@f@kffff@, fff@kff@kff@fk, fkf@f@kfk#f@f@kfff
;$OBFUSCATOR: $DEFLOSVARS: h1font, h2font, basefont, mymessage

	%ffffk#fkf@fffkffffk#f@fff@%%fff@fkfkf@kfk#%%ffffkffkfkk#fkfkf@kfk#k#% 		= % "s22"
	fk%kff@f@k#fff@kfkf%#k%f@k#kffffkk#fkk#fkff%#f%fkfkk#fff@fkk#fff@fkf@%kf@f%kfffffk#k#fffkk#k#k#k#%@kffff@ 		= % "s18"	
	fff%fkfffffffkk#fkf@k#f@%@k%f@fff@fff@fkf@fkkffkff%%fff@f@fkf@ffkff@fffkffkf%%fff@fkfkf@kfk#%f@kff@fk 	= % "s14"
	fkf%kfffffk#k#fffkk#k#k#k#%@%fkffkfkfk#f@fff@%@k%kff@ffkffkfkfkfkk#kf%f%f@f@k#fff@fkfffk%#f@f@kfff := %kffffkk#fkk#ffk#kf%#fff%k#kff@fkk#f@kf%ff%f@kfffk#fkffffk#k#fk%@k%f@fkfkk#fkfffff@%#ffk#kf("95718c77bc97abb8cce79b7577b70b578b670cc577576ba8db")

	gui 2:default
	gui, destroy
	gui, margin, 20, 20
	
	;the h1font variable below should be obfuscated
	gui, font, %f@f@kfk#f@ffk#%%kff@f@kffkkff@ffkff@%%kfk#fkk#k#ff% bold
	gui, add, text, xm ym, Obfuscator Test GUI
	
	gui, font, %f@f@kfk#f@ffk#%%fff@kff@kff@fk%%fkfkk#f@f@f@k#k#ffffk#ff% norm underline
	;the gosub label below should be obfuscated
	gui, add, text, xm y+12 cblue Gk#f@kf%f@ffkfk#fkk#kff@%%f@f@fkkfffkff@f@k#%f%ffk#fkk#fkffffk#kf%fffkkffkkffffk, CALL GOSUB IN '_bestcodesection'
	
	gui, font, %fffkf@f@f@f@fk%%f@kfffk#fkffffk#k#fk%%fff@kff@kff@fk% norm
	gui, add, text, xm y+12 Gfkf%f@fkk#k#k#fff@fffkf@fk%f%kffkf@fkfkk#ff%@k#k#%ffffk#k#fkk#fkkff@f@k#fk%k#fk%fkk#k#f@fff@fff@ffffffkf%k#kffffkf@fkf@k#,
(
hello world

TESTING LITERAL STRING OBFUSCATION:
"%fkf@f@kfk#f@f@kfff%%ffk#k#k#f@k#kfkffkk#ffkf%%f@k#f@fkk#fkkff@kf%"

-press home key to test hotkeys-
)
	gui, add, text, xm y+12, enter something here to test`nvariable obfuscation
;$OBFUSCATOR: $DEFGLOBVARS: usermessage
	gui, add, edit, xm y+2 Vfff%ffkfk#f@f@kffkf@kfffkfk#%%kffffkk#fkk#ffk#kf%#ff%fff@fkfkf@kfk#%kf%kfffffk#k#fffkk#k#k#k#%f%f@fkfkk#fkfffff@%kkfkff@ r4, 
		
	gui, add, button, xm y+20 Gfkk%f@fkfffkkfk#kfffkf%fk#f%f@k#kfk#kff@kf%%f@fffff@fffkf@k#f@f@fff@%%k#kffkf@kffkkfffkfkff@%k#kfkff@fkkfk#fk, Test gui submit
	gui, add, button, x+20 yp Gf@k%fkk#fkfff@ffff%fkfff@f%f@fffff@fffkf@k#f@f@fff@%fffk#f%fff@fkfkf@kfk#%ffffk%fkfkk#f@f@f@k#k#ffffk#ff%f@f@f@kffkfffk, Cancel program
	gui, show
}


;LABEL ORIGINAL NAME: testguisubmit
fkkfk#f@k#kfkff@fkkfk#fk:
	gui, submit, nohide
	msgbox, TESTING OBF OF Vvariablename IN 'gui, add':`n`nyou entered "%fkfffffffkk#fkf@k#f@%%fffkk#ffkffkkfkff@%%k#fkkfk#kfkfkffffkf@fk%"
return


;LABEL ORIGINAL NAME: cancelprog
f@k#fkfff@ffffk#fffffkf@f@f@kffkfffk:
	exitapp
return


;LABEL ORIGINAL NAME: guigosub
fkfff@k#k#k#fkk#kffffkf@fkf@k#:
	msgbox, inside _guigosub_
return

;HOTKEYS SHOULD NOT BE OBFUSCATED!
;HOTKEY ORIGINAL NAME: home
home::
	msgbox, home key pressed!
return


;HOTKEY ORIGINAL NAME: RControl & RShift
RControl & RShift::
	msgbox, hello dave
	f@%f@k#kffkkfk#fkf@fffkkfk#%#f%f@fkkfkffkfkk#ff%kfkk%fkfkk#f@f@f@k#k#ffffk#ff%ff@kf()
return


;HOTKEY ORIGINAL NAME: ^;
^;::
	msgbox, hello world
	f%f@ffkfk#kfkffffff@fkf@kf%@%fkk#k#f@kffkk#%#%fkffk#k#k#k#ffkfk#%%f@f@fff@f@ffk#%k%fkffkffffkffff%fkkff@kf()
return	

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;(technically this one would be all right because it does not call any
;functions or use any variables inside of it)
;FUNCTION ORIGINAL NAME: testfunction
f@k#fkfkkff@kf() { 
	global
	msgbox, TESTING OBF OF A FUNCTION CALL:`n`ntestfunction has been called
}


;SKIPPED MOVING function: 'ihidestr()' to OBF CODE

;put this function in your source code. it will actually be called
;by the obfuscated code to 'decode' the obfuscated strings.
;this function and all calls to it will also be obfuscated in
;the output obfuscated program
;FUNCTION ORIGINAL NAME: decode_ihidestr
k#fffff@k#ffk#kf(f@ffkfkffkfkff) {  
	global	
;$OBFUSCATOR: $DEFGLOBVARS: hexdigits
	
	static f@fff@f@f@fff@fff@k#, k#kfkff@kffff@ffkffffk, fffffkffkfkff@k#, fff@k#kfk#kffkf@, k#kfkfk#fkffk#kffkkf, k#k#f@ffkffff@fkkfk#f@
;$OBFUSCATOR: $DEFLOSVARS: newstr, startstrlen, charnum, hinibble, lownibble, mybinary

	k#kf%k#f@fkfffff@k#kffk%%fffkfkfkf@f@kffff@%%kfk#fffff@fffkfffff@ff%#fff@kfk#f@f@ = % "0123456789abcdef"
		
	;will get the encoded key hidden in the obfuscated literal string
	k%fffffkffkfk#fkffkfkfkff@%f%kff@k#ffk#fkff%%ffk#k#k#f@k#kfkffkk#ffkf%@k%kff@k#fkkffkfkfffkfkff%fk#fff@ff(f@%ffkffffkffffk#%f%f@fkfkk#fkfffff@%kf%kfk#kfkffff@fkkfkfkf%kf%f@fkf@ffk#f@ff%kfkff)
	
	;grab encoded data
	f@f%k#kfk#f@f@k#f@%%ffkfffkfkfkffkkfk#k#fkf@%k%fffkffffk#kffkk#k#k#fk%%fkfkk#fff@fkk#fff@fkf@%fkffkfkff = % %f@ffkfk#kfkffffff@fkf@kf%%f@fff@fff@fkf@fkkffkff%%ffkfkfkff@kf%%f@k#k#fffkfkk#f@ffffkf%%fffffkf@f@fkf@f@%%f@f@kfk#f@ffk#%(f%kffkf@k#kfkfk#fkfkkf%f%k#k#ffffkffkk#k#f@k#ffff%fkf%kff@k#fkkfkffkfk%%kff@f@kffkkff@ffkff@%kffkfkff, 1, 1) . %fffkfkffffk#fkf@f@f@k#fk%%fff@fkf@kff@kfk#ff%%fkkfkfffk#f@f@%%f@kfffk#k#fffff@%%fkk#k#f@fff@fff@ffffffkf%%kffffkffk#k#f@fkkf%(f%fkfkk#fff@fkk#fff@fkf@%@%k#fff@ffk#kffff@kff@kf%%fffkfkk#k#fkkffkk#fkf@ff%%kfffffffk#f@f@f@k#fkfk%fkfkffkfkff, 6)
	k#k%fkkfk#k#f@ffkfkfk#fkk#%kf%kffff@kfkfkfk#kfkf%@%fkffkffffkffff%kff%fkk#fkf@fkk#kfk#k#%ff@f%kfk#fffff@fffkfffff@ff%fkffffk = % %kfk#f@fkk#kfffk#k#fkkf%%fff@kff@f@ffffk#%%k#kff@fkk#f@kf%%k#f@k#k#fkkf%%fffkkfffk#f@f@kffk%%f@ffkfk#kfkffffff@fkf@kf%(%fffffkf@fkkfkffkfkfffk%f@ff%kfffffk#k#fffkk#k#k#k#%kfk%f@ffffffk#kff@f@f@ffk#f@%fkfkff)
		
	%fkffk#k#k#k#ffkfk#%f%fff@fkfkf@kfk#%%k#k#kfffk#kfffkff@f@k#%f%fkffk#fff@ffk#fkf@fkk#ff%f@f@f@fff@fff@k# = 
	;reverse the hex string
	loop, % %kfk#fffkfkf@f@k#f@k#f@kf%%kfffffk#k#fffkk#k#k#k#%%k#f@f@kff@kfk#%%fff@k#k#fkkf%%ffkffkf@fkkff@fffkk#k#%%k#fkfkffkfkfffffffk#kff@%(f@ff%f@k#f@fkk#fkkff@kf%kfkf%ffffkfkffkfkfk%fkf%k#fffkf@fffkfkkffk%ff) 
		%fffkkffkfkk#fkk#ff%%kffkfffkfkffk#fkfkkf%%f@fkk#f@fkfkkffffkff% = % %fffkf@f@f@f@fk%%fffkkff@fkf@kfk#%%fkffk#k#fkfkfkf@k#kf%%ffffkfkffkfffkf@%%fkfkk#fff@fkk#fff@fkf@%%ffk#k#ffk#fffkk#%(f@f%f@k#kfk#kff@kf%fk%kffff@kfkfkfk#kfkf%kff%kffkkfkff@fffkkffkkffkff%kfkff, a_index, 1) . f@%kffff@kfkfkfk#kfkf%ff@%fkffkfkfk#f@fff@%@f@f%f@fkfkk#fkfffff@%ff@f%f@k#kffffkk#fkk#fkff%ff@k#
	
	f@%f@fkkfkffkfkk#ff%%kffkf@f@k#kfk#kfk#k#%f%fff@f@fkf@ffkff@fffkffkf%kfkffkfkff = % f@f%fffffkffkfk#fkffkfkfkff@%f@%kff@f@fff@kfkf%f@f@f%f@k#k#fffkfkk#f@ffffkf%ff@ff%kff@fkfkffkfkffk%f@k#
	f@f%fkfkfkf@kfkff@f@fkkf%ff@f%f@k#k#fffkfkk#f@ffffkf%@f@f%kffff@kfkfkfk#kfkf%%fffkf@f@f@f@fk%f@%fff@f@fkf@ffkff@fffkffkf%ff@k# = 
	ffff%kff@k#ffk#fkff%f%fffkffffk#kffkk#k#k#fk%kff%f@fffkf@f@f@f@fkff%kfk%k#fff@ffk#kffff@kff@kf%f@k# = 1
	;convert from hexidecimal to binary	
	while true
	{
		if (fff%fkkff@f@kfk#ffff%ff%f@ffkfk#f@fffkf@f@k#ff%ff%fffffkf@fkkfkffkfkfffk%kf%k#k#fkkfkfkfffkffkfffk%f%kfk#fffff@fffkfffff@ff%f@k# >k#kfk%fkk#k#k#fkk#k#ff%f@k%ffffkffkfkk#fkfkf@kfk#k#%f%fkkfkffkk#f@f@ff%fff@ffkffffk)
			break
			
		fff%kff@ffkffkfkfkfkk#kf%%k#fkkfk#kfkfkffffkf@fk%@k#%k#k#fkkfkfk#kfkf%fk#%ffkfkff@kfffkffkffk#ffk#%ffkf@ = % %k#fkfkffkfkfffffffk#kff@%%fkk#k#ffkffk%%f@fffkfkk#fkk#%%kff@f@fkfkk#%%fkffk#k#fkfkfkf@k#kf%%f@k#f@fkk#fkkff@kf%(f@%ffffkfkffkfkfk%ff%f@fkk#f@fkfkkffffkff%k%f@fkk#k#k#fff@fffkf@fk%kf%f@fkkfk#ffk#ffk#f@k#%kfkff, ff%fffkfkk#k#fkkffkk#fkf@ff%f%fffkf@f@f@f@fk%%f@fkkfkffkfkk#ff%f%ffkffffkffffk#%kf%kff@k#f@k#fff@fffff@f@fk%kfkff@k#, 1)
		;find it in hexdigits and convert to decimal number
		ff%kff@k#f@k#fff@fffff@f@fk%%ffk#kffkk#fkf@ff%k#%f@kff@fkk#fffkf@ffk#%kfk%fff@fkfkf@kfk#%#kf%kffkf@f@k#kfk#kfk#k#%fkf@ = % %kfkffkf@f@fkf@%%kfkfk#k#fkfkf@%%kffkf@fkfkk#ff%%kffff@ffkffkffkff@%%ffffk#ffkffkkff@k#%%f@k#ffk#fff@%(k#k%f@k#kffffkk#fkk#fkff%%fffkkfffk#f@f@kffk%%fkffk#fff@ffk#fkf@fkk#ff%k#f%f@fkfff@k#ffkffkkff@f@kf%f@kfk#f@f@, ff%fkffkffffkffff%f@%kffff@ffkffkffkff@%k#kf%fkkfkffkk#f@f@ff%k#k%fffffkffkfk#fkffkfkfkff@%fkf@) - 1
		
		k#%k#k#f@k#kff@fkkfkffkfkk#%f%k#k#fkkfkfkfffkffkfffk%fk#f%kfffffk#k#fffkk#k#k#k#%kff%fff@ffk#ffk#kfffk#fk%k#kffkkf = % %fkkff@ffk#k#ffkfff%%ffkfkfkff@kf%%fkk#fkf@fkk#kfk#k#%%fkfkk#fff@fkk#fff@fkf@%%k#k#ffffkffkk#k#f@k#ffff%%fffffkf@f@fkf@f@%(f@%f@fkfffkkfk#kfffkf%f%kffff@ffkffkffkff@%%f@fkf@ffk#f@ff%kf%k#fkkffkkfk#fkfk%kffkfkff, ff%k#kfk#f@f@k#f@%f%kffff@kfkfkfk#kfkf%kff%kff@f@kffkkff@ffkff@%kf%ffkffkf@fkkff@fffkk#k#%kff%fff@k#kffkffk#fffffk%@k# + 1, 1)
		;find it in hexdigits and convert to decimal number
		k#k%kfkffffffff@fkk#f@%%fkffk#k#k#k#ffkfk#%%ffffk#kffkfkfkkff@f@%%kfffffk#k#fffkk#k#k#k#%fk#f%k#k#f@k#k#ffkffffff@fk%kffk#kffkkf = % %f@k#k#fffkfkk#f@ffffkf%%fkf@k#kffkkfff%%f@fff@fff@fkf@fkkffkff%%kffkk#f@f@k#ff%%kff@ffkffkfkfkfkk#kf%%f@ffkfk#kfkffffff@fkf@kf%(k%fffkf@f@kfk#ffk#fffk%kf%k#fkkffkkfk#fkfk%k%fkk#fff@k#k#f@fffk%fff%kfk#f@fkk#kfffk#k#fkkf%%kff@f@fff@kfkf%@kfk#f@f@, k#k%fkkfkffkfkf@k#ffffk#k#%kfk%fkfffkkffkk#ffff%fkff%kffffkfffkffkf%%ffk#k#ffk#fffkk#%k#kffkkf) - 1
		
		;unshift the hex
		%fkk#f@k#kfk#kfkfffff%%fkfkfffkk#kff@fkf@kf%%fffkffffk#kffkk#k#k#fk% := f@%k#kfkfkfk#ffkf%kf%f@fkf@kffkf@kff@%k#%k#fffkf@fffkfkkffk%#%kfkffffffff@fkk#f@%ffkk#(fff@%fkfkkffff@k#f@fkf@fk%%k#k#fkkfkfk#kfkf%#kfk#%kffffkfffkffkf%kffkf@)
		k#kf%fff@k#kffkffk#fffffk%kfk#f%fkk#k#f@kffkk#%ffk%fkk#f@k#kfk#kfkfffff%#kffkkf := %f@fkkfkffkfkk#ff%%fkkfkffkk#f@f@ff%%f@ffk#k#ffk#%(k#%fff@ffk#ffk#kfffk#fk%%f@k#f@fkk#fkkff@kf%%f@f@k#fff@fkfffk%f%f@kfkffkfkk#ffffkff@%fk#fkffk#kffkkf)
		
		k#k#f%k#kffkf@kffkkfffkfkff@%f%k#k#f@k#k#ffkffffff@fk%f%k#k#ffffkffkk#k#f@k#ffff%k%fkkfk#k#f@ffkfkfk#fkk#%fff@fkkfk#f@ = % f%kff@k#fkkfkffkfk%ff%kffkf@k#kfkfk#fkfkkf%k#%fkfffkkffkffkfk#%%f@fffkffk#k#fff@ffk#f@%fk%fff@k#kffkffk#fffffk%#kffkf@ * 16 + k#%f@k#f@fkk#fkkff@kf%k%k#fff@ffk#kffff@kff@kf%k%ffkfffkfkfkffkkfk#k#fkf@%fk#fkffk#kffkkf
		f@%fkffk#fff@ffk#fkf@fkk#ff%%kffff@ffkffkffkff@%ff@%fkk#k#k#fkk#k#ff%%fffkfkffffk#fkf@f@f@k#fk%@f@fff@fff@k# .= %k#kfkfkfk#ffkf%%fff@fkkfkff@k#%%fff@fkfkf@kfk#%%k#k#kffkf@kffk%%fkkfkffkk#f@f@ff%%fff@ffk#ffk#kfffk#fk%(%kffffkf@kfffffkf%%f@k#f@fkk#fkkff@kf%%k#k#ffffkffkk#k#f@k#ffff%)
		
		%ffk#k#k#f@k#kfkffkk#ffkf%fff%kfffffk#k#kfffkfff%ff%fkfffffffkk#fkf@k#f@%kff%k#k#fkkfkfk#kfkf%fkf%k#kfk#f@f@k#f@%@k# += 2		
	}
		
	%fffkf@fffffkfkfkk#%%f@ffffffk#kff@f@f@ffk#f@%@f%ffffkffkfkk#fkfkf@kfk#k#%ff@%f@fffkfkk#fkk#%f@f@fff@fff@k# = % k#%fffkf@f@f@f@fk%%f@k#kffffkk#fkk#fkff%kff%fff@fkfkf@kfk#%@ffk%fkkfk#kffkkff@kf%f@k#fk(%kffkkfkff@fffkkffkkffkff%f@fff%fkkfffk#fkf@kf%f@%fff@f@fkfkf@f@kff@%f@fff@fff@k#)
		
	return, f@fff%kff@kfk#fffkffffk#k#%f%kfk#kfkffff@fkkfkfkf%%kfk#k#kffkk#ffkf%@f@fff@fff@k#	
}


;FUNCTION ORIGINAL NAME: decode_hexshiftkeys
kff@kfk#fff@ff(kfkfffkffkkf) { 
	global
;$OBFUSCATOR: $DEFGLOBVARS: decodekey, ishexchar, useshiftkey
	
	;these have '1's in them
	f%fffffkf@fkkfkffkfkfffk%@%fkfkk#fff@fkk#fff@fkf@%%kffkfkkffff@f@fkf@fkffkf%k%fkk#k#k#fkk#k#ff%%f@kfkffkfkk#ffffkff@%#fff@f@ := "fff@kkf1ffkfkfkfff#k1fk@kf#@fffk@#kk"
	ff%kfffffk#k#fffkk#k#k#k#%%k#k#fkkfkfk#kfkf%f%ffk#k#k#f@k#kfkffkk#ffkf%%fffffkffkfk#fkffkfkfkff@%@kf%ffk#f@kffkk#k#kfffk#f@%f@fkf@k#kf := "fff@f1ff@kffkk#f1fffffkf"
	
	;grab randomly created encrypt key
	;i hid it in the obfuscated literal string, 2 characters in
	%f@fffkfkk#fkk#%%fkfkkffkk#f@kffkk#fkf@%%f@kfk#fff@f@%%kff@k#fkkffkfkfffkfkff%%ffkff@kff@fkf@k#kf%%f@f@fff@kfffkfkff@f@fkf@%1 = % %fff@fkf@kff@kfk#ff%%fkkfkfffk#f@f@%%fffkfkk#k#fkkffkk#fkf@ff%%kffkkfkff@fffkkffkkffkff%%f@kfffk#k#fffff@%%kfffffffk#f@f@f@k#fkfk%(%f@k#kffffkk#fkk#fkff%%k#ffkfk#ffk#k#k#fff@ffk#ff%%k#k#ffffkffkk#k#f@k#ffff%, 2, 1)
	%kffkkfkff@fffkkffkkffkff%%f@kfk#fff@f@%%fkfffffffkk#fkf@k#f@%%f@fkfkk#fkfffff@%%ffkff@kff@fkf@k#kf%%kfk#fffkfkf@f@k#f@k#f@kf%2 = % %kff@ffkffkfkfkfkk#kf%%kffkkfkff@fffkkffkkffkff%%fffkkff@fkf@kfk#%%f@kffkf@kfk#k#k#fkkfff%%ffffkfkffkfffkf@%%fkffk#f@f@ffk#k#kfkff@fk%(kf%k#fkfkffkfkfffffffk#kff@%kf%kffffkffk#k#f@fkkf%%fkk#k#k#fkk#k#ff%fk%k#kfk#f@f@k#f@%fk%f@fkk#k#fkf@fkk#k#%kf, 3, 1)
	%f@kfk#fff@f@%%ffkfffkfkfkffkkfk#k#fkf@%%kffkkfkff@fffkkffkkffkff%%ffkff@kff@fkf@k#kf%%fkfkk#f@f@f@k#k#ffffk#ff%%fffkf@f@f@f@fk%3 = % %f@f@fff@kfffkfkff@f@fkf@%%fkk#k#ffkffk%%kfk#kfkffff@fkkfkfkf%%kffkfffkfkffk#fkfkkf%%kff@f@fkfkk#%%f@f@fff@kfffkfkff@f@fkf@%(k%k#kfk#f@f@k#f@%%kffkf@f@k#kfk#kfk#k#%kf%k#kfkfkfk#ffkf%ffkffkkf, 4, 1)
	%f@k#kfk#kff@kf%%f@kfk#fff@f@%%f@fkf@kffkf@kff@%%f@fkk#k#fkf@fkk#k#%%ffkff@kff@fkf@k#kf%%ffkffkf@fkkff@fffkk#k#%4 = % %k#fkkfk#kfkfkffffkf@fk%%ffkfkfkff@kf%%kffff@ffkffkffkff@%%kff@f@kffkkff@ffkff@%%fkfkk#f@f@f@k#k#ffffk#ff%%fffffkf@f@fkf@f@%(%k#k#f@k#kff@fkkfkffkfkk#%f%ffkfkff@kfffkffkffk#ffk#%ff%f@fffkf@f@f@f@fkff%fk%f@kffkf@kfk#k#k#fkkfff%ffkkf, 5, 1)
	
	;covert key values to actual numbers
	loop, 4
		%f@kfk#fff@f@%%kfffffk#k#kfffkfff%%fkfkk#f@f@f@k#k#ffffk#ff%%a_index% = % %k#k#f@f@ffk#ff%%k#kfkfkfk#ffkf%%k#kfkffffkfffff@kff@%%kfk#f@fkk#kfffk#k#fkkf%%f@kfkffkf@f@f@ff%%kfkff@k#ffffk#fff@%(%k#fffkkfk#k#ffk#kfk#%k%ffffk#ffkffkkff@k#%#kf%fkk#k#f@kffkk#%%f@ffk#k#fffffkf@k#f@%fff@kfk#f@f@, %fkkfkffkk#f@f@ff%%f@kfk#fff@f@%%k#k#ffffkffkk#k#f@k#ffff%%ffkff@kff@fkf@k#kf%%k#fkkfk#kfkfkffffkf@fk%%f@ffkfk#kfkffffff@fkf@kf%%a_index%) - 1
			
	fk%fkk#fkf@fkk#kfk#k#%f%f@fkfkk#fkfffff@%ff%kffkf@fkfkk#ff%%f@f@kffkf@k#f@f@f@f@%k#%f@fkf@ffk#f@ff%kfkfk = 0
}	


;FUNCTION ORIGINAL NAME: decode_shifthexdigit
f@kfk#k#fffkk#(kff@fkkff@f@ffff) { 
	global
	
	;each time i enter this routine i will use the next key value
	;to shift the hexvalue
	fkf%fff@f@fkfkf@f@kff@%f%f@fkk#k#k#fff@fffkf@fk%@k%fff@f@fkfkf@f@kff@%#fkfkfk++
	if (f%fffkfkffffk#fkf@f@f@k#fk%kff%kff@k#f@k#fff@fffff@f@fk%@k#%fkfkkffkk#f@kffkk#fkf@%f%f@fkk#k#fkf@fkk#k#%kfkfk > 4)
		fk%fkkff@ffk#k#ffkfff%%ffkffffkffffk#%ff@%fff@f@fkfkf@f@kff@%k#f%k#kff@fkk#f@kf%kfkfk = 1	
	
	;subtract the shift key from the hexvalue 
	%kfffffffk#f@f@f@k#fkfk%%fff@k#kff@f@fkfkfkfkk#k#%%kfkffkf@f@fkf@% -= %k#kfk#fkf@k#fkff%%f@kfk#fff@f@%%fffkf@f@f@f@fk%%fkfff@k#fkfkfk%%f@fff@fff@fkf@fkkffkff%%ffffkfkffkfkfk%
	
	;if i go under zero, just add 16
	if (kf%f@fkk#k#k#fff@fffkf@fk%@fkk%fff@fkf@kff@kfk#ff%ff@%ffffk#k#fkk#fkkff@f@k#fk%f@%ffffk#ffkffkkff@k#%ffff < 0) 
		%fkfkfkf@kfkff@f@fkkf%kff@f%fffkf@f@f@f@fk%kkf%fkkfkffkfkf@k#ffffk#k#%@f@ffff += 16
		
	return %k#fffkf@fffkfkkffk%ff@f%fkkff@ffk#k#ffkfff%kkf%f@fffkfkk#fkk#%f@f%fff@f@fkfkf@f@kff@%@ffff	
}


;FUNCTION ORIGINAL NAME: fixescapes
k#kff@ffk#f@k#fk(ffffk#kff@f@) { 
	global
	
	StringReplace, ffff%k#f@ffffk#f@k#f@kffk%#kff%f@fkfffkkfk#kfffkf%@f@, %k#kfk#f@f@k#f@%fff%ffkfffkfkfkffkkfk#k#fkf@%k#%k#kfkfkfk#ffkf%%k#f@ffffk#f@k#f@kffk%ff@f@, % "````", % "``", all
	StringReplace, fff%fkffk#f@f@ffk#k#kfkff@fk%%kffff@kfkfkfk#kfkf%k#k%kfk#f@fkk#kfffk#k#fkkf%ff@f@, f%kff@k#f@k#fff@fffff@f@fk%%f@k#kff@kfk#fkfkf@f@fffk%f%kfkfkffkkfkfffk#%k#%kffkfkkffff@f@fkf@fkffkf%k%fff@f@fkfkf@f@kff@%ff@f@, % "``n", % "`n", all
	StringReplace, %kffkf@f@k#kfk#kfk#k#%%fff@f@fkf@ffkff@fffkffkf%fff%kffff@ffkffkffkff@%k#kff@f@, f%f@fkk#f@fkfkkffffkff%f%f@fkfff@k#ffkffkkff@f@kf%fk#k%kfk#f@fkk#kfffk#k#fkkf%ff@f@, % "``r", % "`r", all
	StringReplace, ff%f@fkk#k#k#fff@fffkf@fk%fk#%kff@ffkffkfkfkfkk#kf%kf%f@k#f@fkk#fkkff@kf%f%f@fkf@fff@k#kffkfkffk#%f@, f%f@k#kff@kfk#fkfkf@f@fffk%ffk#%kffffkfffkffkf%k%f@k#k#fffkfkk#f@ffffkf%ff@f@, % "``,", % "`,", all
	StringReplace, %kff@kfkfkff@fk%%fffkf@f@f@f@fk%%ffkfffkfkffkfffkf@f@ffffff%, ff%kff@f@kffkkff@ffkff@%%fkffk#fff@ffk#fkf@fkk#ff%fk%kfkff@k#ffffk#fff@%#k%kfkffkf@f@fkf@%ff@f@, % "``%", % "`%", all	
	StringReplace, fff%fffffkffkfk#fkffkfkfkff@%%kfkfk#ffffffk#f@kff@fff@%#kf%fkfkkffkk#f@kffkk#fkf@%%f@k#f@fkk#fkkff@kf%f@f@, fff%fff@f@fkf@ffkff@fffkffkf%k%kff@k#ffk#fkff%#kff%ffffk#ffkffkkff@k#%@f@, % "``;", % "`;", all	
	StringReplace, f%f@k#k#fffkfkk#f@ffffkf%f%k#k#ffffkffkk#k#f@k#ffff%ff%k#k#fkkfkfk#kfkf%#kff@f@, ff%f@fkk#k#fkf@fkk#k#%%kff@kfkfkff@fk%%f@k#kffffkk#fkk#fkff%f%fkk#k#k#fkk#k#ff%%f@k#kffkkfk#fkf@fffkkfk#%#kff@f@, % "``t", % "`t", all
	StringReplace, %kfffffffk#f@f@f@k#fkfk%%ffkfffkfkffkfffkf@f@ffffff%%fffkkfffk#f@f@kffk%, ff%fffkkfffk#f@f@kffk%f%k#fffkkfk#k#ffk#kfk#%f%k#f@ffffk#f@k#f@kffk%%fkkff@f@fff@kffff@kf%#kff@f@, % "``b", % "`b", all
	StringReplace, %fkkfk#k#f@ffkfkfk#fkk#%ff%f@fkf@ffk#f@ff%%f@fkk#f@fkfkkffffkff%k%fkk#k#f@fff@fff@ffffffkf%#%k#kfk#fkf@k#fkff%kff@f@, ffff%kfffkffffff@f@k#%#kf%k#kfk#fkf@k#fkff%f@f@, % "``v", % "`v", all
	StringReplace, f%fffkfkfkf@f@kffff@%fffk%f@fkk#f@fkfkkffffkff%%fff@kfkfk#k#kfk#kfkf%kff@f@, %fkffk#fff@ffk#fkf@fkk#ff%%ffk#f@kffkk#k#kfffk#f@%%fkkff@f@fff@kffff@kf%f%f@fkfffkkfk#kfffkf%ff%f@f@k#fff@fkfffk%#kff@f@, % "``a", % "`a", all
	
	StringReplace, %f@fkfff@k#ffkffkkff@f@kf%ff%k#kff@fkk#f@kf%%ffkfffkfkfkffkkfk#k#fkf@%f%kffffkk#fkk#ffk#kf%#%ffkfffkfkfkffkkfk#k#fkf@%kff@f@, %fffkfkk#k#fkkffkk#fkf@ff%%ffkfkfkffkffffkff@%%kffkfkkffff@f@fkf@fkffkf%, % """""", % """", all
	
	return %fkkfk#k#f@ffkfkfk#fkk#%%f@fkk#k#k#fff@fffkf@fk%ff%kfffffk#k#kfffkfff%%fffkfkk#k#fkkffkk#fkf@ff%k#%fkkff@f@kfk#ffff%kff@f@
}

