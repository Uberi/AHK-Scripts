obf_copyright := " Date: 2:15 PM Tuesday, March 19, 2013          "
obf_copyright := "                                                "
obf_copyright := " THE FOLLOWING AUTOHOTKEY SCRIPT WAS OBFUSCATED "
obf_copyright := " BY DYNAMIC OBFUSCATER FOR AUTOHOTKEY           "
obf_copyright := "                                                "
obf_copyright := " Copyright (C) 2011-2013  David Malia           "
obf_copyright := " DYNAMIC OBFUSCATER is released under           "
obf_copyright := " the Open Source GPL License                    "


;AUTOEXECUTE ORIGINAL NAME: autoexecute
;autoexecute
;Since the obfuscator is set to do Dynamic obfuscation by default,
;leaving off obfuscator CHANGE_DEFAULTS statements at the beginning
;of your program will set the obfuscator to do dynamic obfuscation
  
;put a string assignment header like this in your program so that
;the program name and copyright info still shows up in the obfuscated ;version of this program
program_name:="mindynobf.ahk"
program_name:="Author: David Malia, Augusta, ME"
program_name:="Copyright David Malia, 2013"

;these are the minimum DUMP statements you need to use when using
;dynamic obfuscation. none of these would be required
;for 'straight' obfuscation
;ALL FUNCTIONS MUST BE MADE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!

;security fragments and triple mess fragments for common objects
;must be dumped before anything else
	;SECURITY CLASS FRAG: for class: COMMON for char: f
	ff%fff@kfffk#fffkfkkf%k#k%k#ffkfffk#f@kff@k#%#fkfff%fkf@k#fkfffff@ffkfkff@kf%fk#kffkf@fk=%kffffkffk#fkffk#f@%f%fkffk#f@f@kff@fkk#%
	;SECURITY CLASS FRAG: for class: COMMON for char: k
	kfk#%fffkf@k#f@kfff%ff%fff@fff@k#fkfkffk#%f@kf%fkf@f@fkfkk#k#k#fk%ffff=%kff@fffkfffffkk#kf%k%fff@fff@k#fkfkffk#%
	;SECURITY CLASS FRAG: for class: COMMON for char: @
	kfkfff%fffffkfff@k#f@fkfkf@k#%f@f@ff%fkf@f@fkfkk#k#k#fk%%fkf@k#ffkff@f@k#ffkf%f@fkfff@ff=%fkffkff@f@ffk#f@kffffk%@%f@k#fkk#k#fkf@fffk%
	;SECURITY CLASS FRAG: for class: COMMON for char: #
	f%k#fffkf@kff@kfkfffkfkfkf%%fkfkfkk#f@k#ffffff%fk#%k#k#fffffkfkkffk%f@fkkff@f@ff=%f@fff@fkkfkffkf@%#%fff@k#f@f@ffffffk#fk%

;TRIPLE MESS FRAGMENTS FOR: f
	kfkf%f@f@k#fkfkkffffkfff@f@%k#k#kf%ffk#k#fkffffk#kffkf@fk%fkf%kfk#fff@kfffff%fk#fffkfk:=ff%kfk#fff@kfffff%#k#%ffk#k#fkffffk#kffkf@fk%kffff%f@ffffk#fkfffk%k#%kfk#fff@kfffff%ffkf@fk
	k%ffk#k#fkffffk#kffkf@fk%f@%f@fkkfk#kfk#f@k#k#fkfffk%f%kfk#fff@kfffff%%kffffkfkffk#fffk%kf%ffk#k#fkffffk#kffkf@fk%@f@f@:=ffk#k%ffk#f@fkkff@f@ff%fkf%ffk#k#fkffffk#kffkf@fk%ffk%k#k#fffffkfkkffk%#kffk%fffkffkfkfkfk#ffk#fkfk%f@fk
	fkkffk%fffkffkfkfkfk#ffk#fkfk%%ffk#k#fkffffk#kffkf@fk%kf%kfkffff@f@fff@fkfff@ff%k%ffk#k#fkffffk#kffkf@fk%k#f@f@k#ffk#:=ff%kfk#fff@kfffff%%ffk#f@fkkff@f@ff%k#fkfff%ffk#fkfffff@fkk#kf%fk#kffkf@fk
	%k#ffkff@k#ffkffkkfff%f@%ffk#k#fkffffk#kffkf@fk%@k#k%ffk#f@fkkff@f@ff%%ffk#k#fkffffk#kffkf@fk%kkfk#k#k#:=ffk#%kfffkfkfk#ffkfk#fkf@k#f@%k#f%f@f@f@k#fkfffkkff@k#%kff%ffk#k#fkffffk#kffkf@fk%fk%ffk#f@fkkff@f@ff%kffkf@fk
	kf%kfk#fkk#f@k#f@kffkk#%%fkfkkfkfkffkf@ffk#f@kf%k%ffk#f@fkkff@f@ff%fk%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%ffk#ff:=ffk#%kfk#fff@kfffff%%ffk#f@fkkff@f@ff%fkff%k#k#f@k#fffkfffkfkff%%f@fff@fkkfkffkf@%ffk#kffkf@fk
	k#ff%ffk#k#fkffffk#kffkf@fk%kffk#%kfk#fff@kfffff%#k#k#:=%k#ffkff@k#ffkffkkfff%ff%kfk#fff@kfffff%#k#fkff%ffk#k#fkffffk#kffkf@fk%fk#kffkf@fk
	f@%f@f@kfkffkffkffkk#ffkf%fff%f@fkkfk#kfk#f@k#k#fkfffk%%kfk#fff@kfffff%kffk%ffk#k#fkffffk#kffkf@fk%ff@%ffk#k#fkffffk#kffkf@fk%kk#ff:=f%fff@fkk#f@k#f@ffk#fffk%fk#k#%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%fffk#kffkf@fk
	%ffk#k#fkffffk#kffkf@fk%fkf%kfk#fkk#f@k#f@kffkk#%f%kffff@fff@f@f@f@kfkfk#%kf%kfkffff@f@fff@fkfff@ff%f@f@%ffk#k#fkffffk#kffkf@fk%kf@kffk:=ffk#%kfk#fff@kfffff%#f%kfk#fff@kfffff%ffff%kfk#fkfffkfkfff@f@%k#kf%fkf@f@fkfkk#k#k#fk%fkf@%ffk#k#fkffffk#kffkf@fk%k
	f@k#%kfk#fff@kfffff%%fkf@f@fkfkk#k#k#fk%#k%f@fkkfk#kfk#f@k#k#fkfffk%#%kfk#fff@kfffff%fk%ffk#f@fkkff@f@ff%fffff@fkfk:=f%ffk#k#fkffffk#kffkf@fk%k#k#f%ffkff@f@fffkfff@kfk#k#kf%kfff%f@f@k#fffkk#fkkffkfkfkff%fk#k%ffk#k#fkffffk#kffkf@fk%fkf@fk
	k#fff%kfkffff@f@fff@fkfff@ff%fkfk%kfk#fkk#f@k#f@kffkk#%f%kfk#fff@kfffff%ffkf%f@f@f@k#fkfffkkff@k#%ffk#:=ffk#k%ffk#f@fkkff@f@ff%fk%ffk#k#fkffffk#kffkf@fk%fffk%f@f@f@k#fkfffkkff@k#%#k%fff@f@f@k#k#k#ff%ffkf@fk
	fkk%ffk#k#fkffffk#kffkf@fk%f@%kfk#fff@kfffff%f%ffk#k#fkffffk#kffkf@fk%ffff@%k#kffkffkfk#fk%ffffk#:=f%kffkfkkff@kfkff@f@k#%fk#%kffkkff@fkk#f@f@kfkf%k#fk%ffk#k#fkffffk#kffkf@fk%f%ffk#k#fkffffk#kffkf@fk%fk#k%ffk#k#fkffffk#kffkf@fk%fkf@fk
	%fkfkkfkfkffkf@ffk#f@kf%f%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%f@k#ffk#fkk#ffk#f@k#:=ffk#%kffff@fff@f@f@f@kfkfk#%k#fk%fkfffkkfkffkkff@f@%ffffk%ffk#f@fkkff@f@ff%k%ffk#k#fkffffk#kffkf@fk%fkf@fk
	k#f%k#ffkfffk#f@kff@k#%kk%ffk#k#fkffffk#kffkf@fk%fkff%ffk#k#fkffffk#kffkf@fk%k%kfk#fff@kfffff%#f@f@f@:=%kffffkfffffkfkf@%ffk#%kffff@fff@f@f@f@kfkfk#%k#f%kfk#fff@kfffff%ffff%kfk#fff@kfffff%#kff%kfk#fff@kfffff%f@fk
	f%f@fffkfkkff@k#fffkkf%@%f@fkf@f@k#fkf@f@fff@fkfk%f@%ffk#k#fkffffk#kffkf@fk%kf@k%ffk#f@fkkff@f@ff%kfkff@:=ff%kffkkff@fkk#f@f@kfkf%k%ffk#f@fkkff@f@ff%%kfk#fff@kfffff%#fkffffk#kffkf@fk
	f@%k#ffkff@k#ffkffkkfff%k%f@f@k#fffkk#fkkffkfkfkff%f%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%k#k%ffk#k#fkffffk#kffkf@fk%fkkff@ff:=f%f@fffkfkkff@k#fffkkf%%f@f@fkk#fffkk#%%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%#k#%ffk#k#fkffffk#kffkf@fk%kffffk#kffkf@fk
	k#f@%ffk#k#fkffffk#kffkf@fk%@f%ffk#k#fkffffk#kffkf@fk%kf%kfffkfkfk#ffkfk#fkf@k#f@%%fkk#k#f@kfk#k#kfk#fkfk%f@k%ffk#f@fkkff@f@ff%k#ffk#f@ff:=ffk#%fff@fkk#f@k#f@ffk#fffk%%kfk#fff@kfffff%#f%kfk#fff@kfffff%ffffk%ffk#f@fkkff@f@ff%kffkf@fk
	fkfk%kfk#fff@kfffff%#ff%kffffkffk#fkffk#f@%kfff%f@fkf@k#f@fkfkffk#kfff%k%ffk#f@fkkff@f@ff%fkffkf:=ffk#%kfk#fff@kfffff%#f%kffkfkkff@kfkff@f@k#%kf%ffk#k#fkffffk#kffkf@fk%ffk%fffkf@k#f@kfff%#%kfk#fff@kfffff%ffkf@fk
	kfk%fff@fkk#f@k#f@ffk#fffk%ff@f%kfk#k#ffkffkfkf@kfff%@kf%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%k#ffk#:=f%k#kffkffkfk#fk%fk#k%ffk#f@fkkff@f@ff%fkffff%kfk#fff@kfffff%#kffkf@fk
	f%k#kffkffkfk#fk%@%ffk#k#fkffffk#kffkf@fk%kf%kfkffff@f@fff@fkfff@ff%kfk#k%f@kffff@kffffffffkk#f@k#%#fff@k#k#ffk#:=ffk#%ffkff@kfk#f@fkffk#ff%k%ffk#f@fkkff@f@ff%fkff%ffk#k#fkffffk#kffkf@fk%fk#kf%ffk#k#fkffffk#kffkf@fk%kf@fk
	fkf%kfk#fff@kfffff%fkk%f@f@f@k#fkfffkkff@k#%f%ffkff@kfk#f@fkffk#ff%fk%ffk#k#fkffffk#kffkf@fk%@%ffk#k#fkffffk#kffkf@fk%fkfk#k#fk:=ffk%f@f@f@k#f@kfk#fkfk%#k%ffk#f@fkkff@f@ff%fkff%ffk#k#fkffffk#kffkf@fk%fk#k%k#fff@kfkff@fkkfkffk%ffkf@fk
;TRIPLE MESS FRAGMENTS FOR: k
	fkff%fffffkfff@k#f@fkfkf@k#%f%ffk#k#fkffffk#kffkf@fk%fff%ffk#k#fkffffk#kffkf@fk%fkf@%ffk#k#fkffffk#kffkf@fk%kffkffkff:=kfk%k#ffkff@k#ffkffkkfff%#f%ffk#fkfffkffkfk#f@k#f@kf%ff%kfkffff@f@fff@fkfff@ff%kff%ffk#k#fkffffk#kffkf@fk%ff
	%ffk#k#fkffffk#kffkf@fk%kf@%kfk#fff@kfffff%#k#f%fkffk#f@f@kff@fkk#%ff%k#kfffkfkff@f@kfk#%ff%kfkffff@f@fff@fkfff@ff%f@k#kf:=kfk%fff@fff@k#fkfkffk#%#ff%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%kfffff
	%ffffkfkff@kfkff@f@ff%%k#k#ffkfkff@fkf@fff@fk%k%ffk#f@fkkff@f@ff%f@k%ffk#f@fkkff@f@ff%f@kff@kff@fff@:=%kfk#fff@kfffff%%ffk#ffkff@kff@f@%fk%ffk#f@fkkff@f@ff%%ffkff@kfk#f@fkffk#ff%fff@kfffff
	%ffk#k#fkffffk#kffkf@fk%kfkkf%fkf@fff@fkk#fff@ffffk#f@%fffk%k#fff@kff@kffffkff%f%kfkffff@f@fff@fkfff@ff%fkffkfkfkf:=kf%kfk#fff@kfffff%#f%k#k#kfffk#k#fkfffffkk#%ff%kfkffff@f@fff@fkfff@ff%k%ffffkff@f@f@kfkfkff@%ff%ffk#k#fkffffk#kffkf@fk%ff
	fffkf@%kfk#k#ffkffkfkf@kfff%fkf@%kfk#fff@kfffff%fffkff%kfkffff@f@fff@fkfff@ff%kf:=kfk#%ffk#fkfffff@fkk#kf%fff@%kfk#fff@kfffff%ffff%ffk#k#fkffffk#kffkf@fk%
	%f@f@kfkffkffkffkk#ffkf%kfk#f%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%kf@f@f@kfk#:=k%ffk#k#fkffffk#kffkf@fk%k%ffk#f@fkkff@f@ff%fff%kfk#k#ffkffkfkf@kfff%%kfkffff@f@fff@fkfff@ff%kfffff
	kfk%ffk#f@fkkff@f@ff%fkk%fkk#fkk#k#k#fkkff@fk%fff%kfk#fff@kfffff%ff%f@k#f@f@ffffk#kfff%@k#fkfff@:=kfk%f@f@f@k#fkfffkkff@k#%#%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%f@kfffff
	k%fffkf@k#f@kfff%fk%ffk#k#fkffffk#kffkf@fk%fkkff%kfk#fff@kfffff%f@%ffk#k#fkffffk#kffkf@fk%kffffkf:=kf%k#k#fffffkfkkffk%%k#fff@kff@kffffkff%k%ffk#f@fkkff@f@ff%f%ffk#k#fkffffk#kffkf@fk%f%kfkffff@f@fff@fkfff@ff%kfffff
	kfffk%ffk#f@fkkff@f@ff%f%kfk#fff@kfffff%fff@%fkfkk#k#fffkf@k#fkkfffkf%fff@ff:=%fkffffkfk#fffkffk#k#k#%kfk#%ffk#k#fkffffk#kffkf@fk%ff@k%ffk#k#fkffffk#kffkf@fk%ffff
	f@%ffk#k#fkffffk#kffkf@fk%ffk%kfk#fff@kfffff%#ff%k#f@f@fkfkkffkkf%k%fffkffkfkfkfk#ffk#fkfk%#fffk:=kfk%k#ffkfffk#f@kff@k#%#f%ffk#k#fkffffk#kffkf@fk%f@k%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%fff
	k%k#f@f@fkfkkffkkf%f%fkf@fffffkf@f@k#fkk#f@%%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%kkffkfkfk:=k%f@ffkffff@fffffkkff@%f%kfk#fff@kfffff%%ffk#f@fkkff@f@ff%f%ffk#k#fkffffk#kffkf@fk%f@kfffff
	%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%%k#k#kffkfff@fkfkkf%k#f%kfk#fff@kfffff%f%f@fkkfk#kfk#f@k#k#fkfffk%ffffffffk:=kfk%kfk#fkfffkfkfff@f@%%ffk#f@fkkff@f@ff%%ffk#k#fkffffk#kffkf@fk%ff@%kfk#fff@kfffff%fffff
	%ffk#k#fkffffk#kffkf@fk%fk#fk%ffk#k#fkffffk#kffkf@fk%@kff@%fkf@k#fkfffff@ffkfkff@kf%f@fkf%kfk#fkfffkfkfff@f@%fkfffk#:=kf%kfk#fff@kfffff%%ffk#f@fkkff@f@ff%%kffffkffk#fkffk#f@%%ffffkfkff@kfkff@f@ff%fff@kfffff
	ffff%kffkfkkff@kfkff@f@k#%fk%k#fff@k#fkfffffkk#fk%ffk%ffk#k#fkffffk#kffkf@fk%k#f%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%@kff@k#ff:=k%ffk#k#fkffffk#kffkf@fk%%fffffkfff@k#f@fkfkf@k#%%kfk#fff@kfffff%#%fkfffkkfkffkkff@f@%fff@kfffff
	kff%ffkff@f@fffkfff@kfk#k#kf%%f@ffffk#fkfffk%%ffk#k#fkffffk#kffkf@fk%fk%ffk#k#fkffffk#kffkf@fk%kk#f%kfk#fff@kfffff%fffff@f@:=kfk%fkf@f@fkfkk#k#k#fk%%ffk#f@fkkff@f@ff%ff%fkfkk#k#fffkf@k#fkkfffkf%f@%kfk#fff@kfffff%fffff
	kf%ffk#k#fkffffk#kffkf@fk%%fkfkfkk#f@k#ffffff%kf%kfkffff@f@fff@fkfff@ff%ffkff@k#:=%f@kfkffff@fffk%k%ffk#k#fkffffk#kffkf@fk%k#f%ffk#k#fkffffk#kffkf@fk%f@%kfk#fff@kfffff%fffff
	%k#k#fffkfff@f@kf%f@%ffkff@kfk#f@fkffk#ff%%ffk#k#fkffffk#kffkf@fk%k%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%ffk#fkkf:=kf%fkf@fff@fkk#fff@ffffk#f@%k#f%f@f@fkk#fffkk#%ff%kfkffff@f@fff@fkfff@ff%kff%ffk#k#fkffffk#kffkf@fk%ff
	f@k#f%kfkffff@f@fff@fkfff@ff%f@f@f%fffkk#fkfffkffkffk%ffffk:=k%ffk#k#fkffffk#kffkf@fk%k%ffk#f@fkkff@f@ff%%f@ffffk#fkfffk%ff%kffkkfffkff@fkffffk#kf%f@kfffff
	k%ffk#k#fkffffk#kffkf@fk%f%kfk#fff@kfffff%ffffk%fkkfkfkffkkfk#fkf@kf%ffkk%ffk#f@fkkff@f@ff%k#fkkffkk#:=k%k#ffkfffk#f@kff@k#%%f@k#fkk#k#fkf@fffk%%ffk#k#fkffffk#kffkf@fk%k%ffk#f@fkkff@f@ff%%ffk#k#fkffffk#kffkf@fk%ff@kfffff
	f@fkk%kffffkffk#fkffk#f@%#%ffk#k#fkffffk#kffkf@fk%%ffkff@kfk#f@fkffk#ff%kk%ffk#f@fkkff@f@ff%f@fffffkfff@ff:=k%fkfkkfkfkffkf@ffk#f@kf%fk#%ffk#k#fkffffk#kffkf@fk%ff%ffkff@kfk#f@fkffk#ff%@%kfk#fff@kfffff%fffff
;TRIPLE MESS FRAGMENTS FOR: @
	f@f%k#f@f@fkfkkffkkf%kk%ffk#k#fkffffk#kffkf@fk%%fff@fkk#f@k#f@ffk#fffk%k#kf%ffk#k#fkffffk#kffkf@fk%f%kfk#fff@kfffff%fk#kfk#f@:=kf%kfk#fff@kfffff%f%k#fff@kfkff@fkkfkffk%ff%ffk#k#fkffffk#kffkf@fk%@f@%k#k#ffkfkff@fkf@fff@fk%fff@fkfff@ff
	f@f@%ffk#k#fkffffk#kffkf@fk%f%fffkk#fkfffkffkffk%f@k%k#k#kffkfff@fkfkkf%#fkf%kfk#fff@kfffff%ffk#%ffk#k#fkffffk#kffkf@fk%kf@fk:=kfkff%fkfkkfkfkffkf@ffk#f@kf%ff@f@%f@f@fkk#f@ffk#kf%%ffk#k#fkffffk#kffkf@fk%ff@fk%ffk#k#fkffffk#kffkf@fk%ff@ff
	k#f%kffffkfkffk#fffk%kffk%ffk#k#fkffffk#kffkf@fk%f@%ffk#k#fkffffk#kffkf@fk%%kffff@fff@f@f@f@kfkfk#%kffk#fkfff@kf:=k%kffffffkkff@fkk#k#fk%fkf%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%f@f@%kfffkfffkffkfk%%ffk#k#fkffffk#kffkf@fk%ff@fkfff@ff
	%fkffk#fkfkfff@kfkffkfk%%f@k#f@ffk#k#kfffk#%kff%kfk#fff@kfffff%f@%kfk#fff@kfffff%#%ffk#k#fkffffk#kffkf@fk%kfffkff:=kfk%ffk#k#fkffffk#kffkf@fk%fff%kfkffff@f@fff@fkfff@ff%f@f%fkfkk#k#fffkf@k#fkkfffkf%ff@fk%fkfkfkk#f@k#ffffff%fff@ff
	f%f@k#fkk#k#fkf@fffk%%kfkffff@f@fff@fkfff@ff%kffkf@%ffk#k#fkffffk#kffkf@fk%kf@kff%f@k#f@ffk#k#kfffk#%kfff@fkk#:=k%ffk#k#fkffffk#kffkf@fk%kfff%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%%fkf@k#ffkff@f@k#ffkf%f%f@kffff@kffffffffkk#f@k#%@fff@fkfff@ff
	f%kfkffff@f@fff@fkfff@ff%%k#k#kfffk#k#fkfffffkk#%fffff%ffk#k#fkffffk#kffkf@fk%f@k#ffk#fkfkk#k#:=kfk%k#k#fffffkfkkffk%ffff%kfkffff@f@fff@fkfff@ff%f@%ffk#k#fkffffk#kffkf@fk%ff@fkfff@ff
	kfk%f@kfk#k#f@k#kff@fffkfk%#ffk#f%ffk#k#fkffffk#kffkf@fk%f%kfkffff@f@fff@fkfff@ff%kfk#fkkf:=%fffkk#fkfkk#fffkfffkk#fk%kf%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%fff@f%kfkffff@f@fff@fkfff@ff%fff@fkfff@ff
	f%kfkffff@f@fff@fkfff@ff%f%kfkffff@f@fff@fkfff@ff%k#f%fff@fff@k#fkfkffk#%%kfk#fff@kfffff%f@%k#f@ffk#ffffk#ff%ffk#kfkfk#f@f@:=%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%ffff@%kffffffkkff@fkk#k#fk%f@fff@fkfff@ff
	fff%fff@kfffk#fffkfkkf%fk%ffk#f@fkkff@f@ff%k%ffk#k#fkffffk#kffkf@fk%f%kfk#fff@kfffff%ff%kfk#fkfffkfkfff@f@%fkk#:=kfkf%ffk#k#fkffffk#kffkf@fk%ff%kfkffff@f@fff@fkfff@ff%f@%ffk#k#fkffffk#kffkf@fk%ff@fk%fkfffkkfkffkkff@f@%fff@ff
	fffk%ffk#k#fkffffk#kffkf@fk%@f@%fffkk#fkfffkffkffk%ff%fkkfkfkffkkfk#fkf@kf%%kfk#fff@kfffff%#ff%kfk#fff@kfffff%#k#kff@f@:=kfkf%fff@kfffk#fffkfkkf%ff%f@k#k#ffk#kffkff%f@%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%fff@fkfff@ff
	kfk#k%fkfkkfkfkffkf@ffk#f@kf%#fkfkf%kfk#fff@kfffff%f@ffk#:=k%ffk#k#fkffffk#kffkf@fk%kff%fkfffkkfkffkkff@f@%f%ffk#k#fkffffk#kffkf@fk%@f@ff%ffk#k#fkffffk#kffkf@fk%@fkfff@ff
	f@%ffk#k#fkffffk#kffkf@fk%kkf%kfk#fff@kfffff%%fkfkkfk#kfkff@ff%fff%kffkkfffkff@fkffffk#kf%f@fkk#fkfkkf:=kfk%ffk#k#fkffffk#kffkf@fk%fff@%ffk#k#fkffffk#kffkf@fk%@ff%ffk#k#fkffffk#kffkf@fk%%f@f@f@k#f@kfk#fkfk%@f%fkf@fff@fkk#fff@ffffk#f@%kfff@ff
	f%fffkf@k#f@kfff%ff%kfkffff@f@fff@fkfff@ff%f@k#f%kfkffff@f@fff@fkfff@ff%f@ffk#ff:=k%f@ffffk#fkfffk%f%kfk#fff@kfffff%%ffk#k#fkffffk#kffkf@fk%ff%ffk#k#fkffffk#kffkf@fk%@f@fff@fkfff@ff
	ffkf%kfk#fff@kfffff%ffff%ffk#k#fkffffk#kffkf@fk%ff%fkkfkfkffkkfk#fkf@kf%kffk:=%kfk#fff@kfffff%%f@f@k#fkfkkffffkfff@f@%f%f@fkkfkfkfkffkf@kf%kff%ffk#k#fkffffk#kffkf@fk%f@%ffk#k#fkffffk#kffkf@fk%@fff@fkfff@ff
	kffk%ffk#k#fkffffk#kffkf@fk%%f@kfkffff@fffk%@%ffk#k#fkffffk#kffkf@fk%k%kffffkfffffkfkf@%f@ffkfkfkfff:=kfkf%f@k#fkk#k#fkf@fffk%%ffk#k#fkffffk#kffkf@fk%ff%kfkffff@f@fff@fkfff@ff%f@fff@fkfff@ff
	fk%ffk#k#fkffffk#kffkf@fk%k%f@f@k#k#ffkff@fffkffk#fk%f@f%f@fff@fkkfkffkf@%fk%ffk#k#fkffffk#kffkf@fk%ffk#:=k%ffk#k#fkffffk#kffkf@fk%k%f@fkkfk#kfk#f@k#k#fkfffk%ff%kfk#f@fffffffkfkkffkk#%ff%kfkffff@f@fff@fkfff@ff%f@ff%ffk#k#fkffffk#kffkf@fk%@fkfff@ff
	f@k#%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%k#k#k%kff@fffkfffffkk#kf%#k#fkfkf@kffk:=kfkf%ffk#k#fkffffk#kffkf@fk%%f@f@k#fkfkkffffkfff@f@%%ffk#k#fkffffk#kffkf@fk%f@%ffk#k#fkffffk#kffkf@fk%@fff%fff@fff@k#fkfkffk#%@fkfff@ff
	ff%ffk#k#fkffffk#kffkf@fk%ff%k#k#f@k#fffkfffkfkff%kk#%kffffkffk#fkffk#f@%fkfk%ffk#k#fkffffk#kffkf@fk%fkf:=kf%k#fffkkffkfffkf@f@f@%k%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%ff@%ffk#k#fkffffk#kffkf@fk%@%kfk#k#ffkffkfkf@kfff%fff@fkfff@ff
	f@%ffk#k#fkffffk#kffkf@fk%kfkk%fffkk#fkfkk#fffkfffkk#fk%#k%fffkffkfkfkfk#ffk#fkfk%%ffk#f@fkkff@f@ff%k#%kfk#fff@kfffff%#k#k#fk:=kfkfff%f@f@k#fffkk#fkkffkfkfkff%f@f%kfkffff@f@fff@fkfff@ff%fff@%ffk#k#fkffffk#kffkf@fk%kfff@ff
	%kfk#fff@kfffff%#ffk%fffkk#fkfkk#fffkfffkk#fk%#fkk%ffk#k#fkffffk#kffkf@fk%fk%fff@f@f@k#k#k#ff%fff%kfk#fff@kfffff%fffkk#kf:=%k#fffkfkfffkfkk#%kfk%fkfkkfk#kfkff@ff%ffff@%ffk#k#fkffffk#kffkf@fk%@fff%kfkffff@f@fff@fkfff@ff%fkfff@ff
;TRIPLE MESS FRAGMENTS FOR: #
	k#%kfk#fff@kfffff%#f%kfk#fff@kfffff%%fkffk#fkfkfff@kfkffkfk%%k#kfffkfkff@f@kfk#%k#f@f@k#k#ff:=f%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%%k#ffkff@k#ffkffkkfff%%f@kfk#k#f@k#kff@fffkfk%%ffk#f@fkkff@f@ff%f@fkkff@f@ff
	fk%fkffk#f@f@kff@fkk#%f@f@kf%ffk#k#fkffffk#kffkf@fk%@fkffk%ffk#k#fkffffk#kffkf@fk%f@:=ffk%ffk#f@fkkff@f@ff%f@f%kffkfkkff@kfkff@f@k#%kkff%f@kffff@kffffffffkk#f@k#%%kfkffff@f@fff@fkfff@ff%f@ff
	k#%f@kffff@kffffffffkk#f@k#%f@k%ffk#f@fkkff@f@ff%k#k#%kfk#fff@kfffff%fk%f@k#f@f@ffffk#kfff%%ffk#f@fkkff@f@ff%fkfff@:=%ffk#k#fkffffk#kffkf@fk%%k#kffkffkfk#fk%%ffk#k#fkffffk#kffkf@fk%k#f@fkkff@f@ff
	f%k#fff@kff@kffffkff%f%ffk#k#fkffffk#kffkf@fk%ff%kfkffff@f@fff@fkfff@ff%f%ffk#k#fkffffk#kffkf@fk%k#fkff:=ffk%ffk#f@fkkff@f@ff%f@fk%fkf@f@fkfkk#k#k#fk%kff@%ffk#k#fkffffk#kffkf@fk%@ff
	k#f%kff@fffkfffffkk#kf%%f@kffff@kffffffffkk#f@k#%%ffk#k#fkffffk#kffkf@fk%f%kfkffff@f@fff@fkfff@ff%%ffk#k#fkffffk#kffkf@fk%fk#f@ffkff@:=f%f@fkkfkfkfkffkf@kf%fk#f%kfkffff@f@fff@fkfff@ff%%ffk#k#fkffffk#kffkf@fk%kkff@f@ff
	kf%kffffkffk#fkffk#f@%f@f%f@kfkffff@fffk%ff%kfkffff@f@fff@fkfff@ff%kff%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%@ffkffff@:=ff%fkf@f@fkfkk#k#k#fk%k#%ffk#k#fkffffk#kffkf@fk%%kffffffkkff@fkk#k#fk%@%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%kff@f@ff
	f%fkfkk#ffkfkfk#fk%%kfkffff@f@fff@fkfff@ff%f%kfk#fff@kfffff%f@k#k#kffff@:=ffk%k#fff@k#fkfffffkk#fk%%ffk#f@fkkff@f@ff%%f@f@k#k#ffkff@fffkffk#fk%f@f%kfk#fff@kfffff%%kfk#fff@kfffff%ff@f@ff
	k#%ffk#k#fkffffk#kffkf@fk%@fk%ffk#k#fkffffk#kffkf@fk%f%ffk#k#fkffffk#kffkf@fk%fk%f@f@k#fkfkkffffkfff@f@%%fkk#fkk#k#k#fkkff@fk%#k#fkf@ffk#fk:=ffk%ffk#f@fkkff@f@ff%f@f%kffffffkkff@fkk#k#fk%k%kfk#fff@kfffff%ff@%ffk#k#fkffffk#kffkf@fk%@ff
	fk%f@f@fkk#fffkk#%%kfk#fff@kfffff%f%kfk#fff@kfffff%%fff@fkk#f@k#f@ffk#fffk%#k%ffk#f@fkkff@f@ff%fkf@kf:=ffk%ffk#f@fkkff@f@ff%f%kfkffff@f@fff@fkfff@ff%fkkf%fkfkfkk#f@k#ffffff%f%f@fkkfk#kfk#f@k#k#fkfffk%@f@ff
	f@kf%kfk#fff@kfffff%#%f@fkkfkfkfkffkf@kf%ff%ffk#k#fkffffk#kffkf@fk%%kfkffff@f@fff@fkfff@ff%kfkff@ff:=f%f@ffffk#fkfffk%f%fkfkfkk#f@k#ffffff%k%ffk#f@fkkff@f@ff%f@fk%kfk#fff@kfffff%ff@f@ff
	f%kfk#fff@kfffff%f@kff%kff@fffkfffffkk#kf%ff@fff%ffk#k#fkffffk#kffkf@fk%f@k#kf%ffk#ffkff@kff@f@%fff@:=f%f@kfk#k#f@k#kff@fffkfk%fk#f%kfkffff@f@fff@fkfff@ff%f%kfk#fff@kfffff%kff@f@ff
	fkfff%kfk#fff@kfffff%ffk#%ffk#k#fkffffk#kffkf@fk%@f%k#fffkkffkfffkf@f@f@%ff@fkk#:=%ffk#k#fkffffk#kffkf@fk%fk#%k#k#kfffk#k#fkfffffkk#%f%f@f@fkk#f@ffk#kf%@f%kfk#fff@kfffff%k%ffk#k#fkffffk#kffkf@fk%f@f@ff
	fk%kfffkfffkffkfk%k#f%kfkffff@f@fff@fkfff@ff%f%ffk#k#fkffffk#kffkf@fk%f%kfkffff@f@fff@fkfff@ff%f@kfkfffkf:=%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%k#f@%ffkffkf@fkffkff@fff@f@k#%fkkff@f@ff
	kf%ffk#k#fkffffk#kffkf@fk%f%ffk#k#fkffffk#kffkf@fk%%kfk#fff@kfffff%k#f@%kffkkff@fkk#f@f@kfkf%%k#fffkkffkfffkf@f@f@%ffffffkfffkf:=ffk%ffk#f@fkkff@f@ff%f@f%kfk#fff@kfffff%kff%fkfffff@fkfkk#k#kfk#k#%%kfkffff@f@fff@fkfff@ff%%fffkk#fkfffkffkffk%f@ff
	kfk%ffk#k#fkffffk#kffkf@fk%k#f@f%kfkffff@f@fff@fkfff@ff%kfffff%fkf@k#ffkff@f@k#ffkf%f@k#:=ffk#%ffk#k#fkffffk#kffkf@fk%@%kffkkfffkff@fkffffk#kf%fkkff%kfkffff@f@fff@fkfff@ff%f@ff
	f%ffk#fkfffff@fkk#kf%%kfkffff@f@fff@fkfff@ff%k%k#f@ffk#ffffk#ff%%ffk#k#fkffffk#kffkf@fk%fkk%ffk#f@fkkff@f@ff%ffkffkfff@fkkffk:=f%f@fkf@f@k#fkf@f@fff@fkfk%f%kfk#fff@kfffff%#%ffk#k#fkffffk#kffkf@fk%@%fffkk#fkfffkffkffk%fkkff@f@ff
	fk%ffk#k#fkffffk#kffkf@fk%@%kfk#fff@kfffff%#f@k#%k#kffkffkfk#fk%f@k#fffff@:=ffk#f%kfkffff@f@fff@fkfff@ff%%ffk#k#fkffffk#kffkf@fk%kkf%f@f@k#f@fff@f@k#%f@f@ff
	fkf%kff@ffk#kffkffk#k#fk%fkfk%ffk#f@fkkff@f@ff%f%f@f@f@k#f@kfk#fkfk%%kfk#fff@kfffff%k#f@fkfk:=ffk%fkffk#f@f@kff@fkk#%#f@%k#fffkkffkfffkf@f@f@%f%kfk#fff@kfffff%k%ffk#k#fkffffk#kffkf@fk%%ffk#k#fkffffk#kffkf@fk%@f@ff
	k%f@fkf@f@k#fkf@f@fff@fkfk%f%fff@kfffk#fffkfkkf%%ffk#k#fkffffk#kffkf@fk%fkf%kfk#fff@kfffff%#%ffk#k#fkffffk#kffkf@fk%ffff@ffk#:=ffk#%ffk#k#fkffffk#kffkf@fk%@fkkf%ffk#k#fkffffk#kffkf@fk%@f@ff
	%ffk#k#fkffffk#kffkf@fk%%fkffffkfk#fffkffk#k#k#%kfk%kffkfkkff@kfkff@f@k#%kfk%ffk#k#fkffffk#kffkf@fk%fkf@f@f@f@:=f%fff@fkk#f@k#f@ffk#fffk%fk%ffk#f@fkkff@f@ff%f@f%fkffffkfk#fffkffk#k#k#%kkf%ffk#k#fkffffk#kffkf@fk%@f@ff

;dump variable fragments 
;OBF_GLOBVAR name: mytrue
	%kfkffkkffkfkfk%ff%fkfkf@ffkfffk#%fkkf%k#fffkfkfffkfkk#%f%kfkfk#k#kfffkfkfk#fffkfk%f@f@kf=%kffkf@ffkff@k#%#k%fkffk#f@f@kff@fkk#%ffk%fkfkfkkffkf@ffkfk#k#fk%k%f@k#k#k#kfk#fffff@fkfk%@kf
	%fffffkffkfk#fff@kff@k#ff%%k#fff@kfkff@fkkfkffk%%fkffkfk#fkk#f@fkfk%k#%fkffkff@f@ffk#f@kffffk%%fkkff@kffffff@ffffk#%@fkfffkf@=k%fkf@k#fkfffff@ffkfkff@kf%#%fffffkffkfk#fff@kff@k#ff%ffk%kfkfk#k#kfffkfkfk#fffkfk%%f@k#f@f@f@fffffk%f@kf
	%ffffkff@f@f@kfkfkff@%f@%f@kfk#k#f@k#kff@fffkfk%f%f@k#f@f@f@fffffk%f%fkkff@kffffff@ffffk#%k#k%f@fkf@k#k#kffff@%ffk#k#=%ffk#ffkff@kff@f@%%fkfkkffffkf@fkffkfkfkf%#%k#f@k#f@kff@kff@fff@%%fkf@k#ffkff@f@k#ffkf%ffkfkf@kf
;OBF_GLOBVAR name: myfalse
	ff%f@f@f@k#f@kfk#fkfk%%ffk#fkf@kff@f@fkffkfffk#%%fkkfk#k#fkf@kf%f@fkf@fk=f@%kfk#fkkfffkff@k#fkfff@%fk%f@k#f@ffk#k#kfffk#%ff%k#f@ffk#ffffk#ff%@%kfkff@f@kffkk#ffk#%@%k#fkkffkfffkk#f@f@f@%k
	f%f@fkkfk#kfffkfk#kfk#f@%%k#fff@fkfkfkffkfffk#%k%f@f@fkf@k#kfkff@%ff%kfffkfkfk#ffkfk#fkf@k#f@%%fff@k#f@f@ffffffk#fk%@k#kffkf@=%kffffffkkff@fkk#k#fk%%f@fff@fkkfkffkf@%%f@fkf@kfk#k#fff@k#k#ffk#%@k%f@k#k#k#kfk#fffff@fkfk%%f@fkk#fkk#f@fffffkfff@ff%ff@f@fk
	k%f@fkf@k#k#kffff@%kfk%kff@fff@kffff@ffkffff@%k%k#ffkfffk#f@kff@k#%fffffff=f@%k#k#f@k#fffkfffkfkff%k%kfkfk#k#kfffkfkfk#fffkfk%k%k#f@f@ffkff@k#k#ffk#f@ff%f@f%kfk#k#fkfkfkf@ffk#%fk
;OBF_GLOBVAR name: usermessage
	fk%k#kffffkffk#fffff@ff%kf%fkf@f@k#ffk#fkk#ffk#f@k#%f%f@fkk#fkk#f@fffffkfff@ff%#ffkffff@=f%ffk#ffkff@kff@f@%fk%k#fff@fkfkfkffkfffk#%k%k#f@f@ffkff@k#k#ffk#f@ff%%fffkf@fkf@kfffkff@kf%fkfkf
	ffk%k#fff@k#fkfffffkk#fk%ff%kfk#fkf@ffk#ff%ff%kfkff@f@kffkk#ffk#%kkf%fkf@fff@fkk#fff@ffffk#f@%k#=ffk%k#k#fffffkfkkffk%fkf%fffkk#fkfffkffkffk%%fffffkffkfk#fff@kff@k#ff%fk%fkfkk#ffkfffk#fkffkf%kf
	f@f%k#fff@fkfkfkffkfffk#%f@k%k#f@f@ffkff@k#k#ffk#f@ff%fkf%fkf@k#ffkff@f@k#ffkf%@k#fk=%ffkffkf@f@f@fkf@kffk%fkf%fffkf@fkf@kfffkff@kf%fk%kfffkfffkffkfk%f%fffffkffkfk#fff@kff@k#ff%fkf
;OBF_GLOBVAR name: hexdigits
	fkk%ffk#fkfffff@fkk#kf%fkf%k#fff@fkfkfkffkfffk#%@%k#fff@fkfkfkffkfffk#%fk%kfffkfk#fffff@ffk#%kf=f%f@fkf@kfk#k#fff@k#k#ffk#%ff%k#ffkfffk#f@kff@k#%f@%fkf@f@k#ffk#fkk#ffk#f@k#%ff@f@ffffff
	fk%ffkffkf@fkffkff@fff@f@k#%kf%k#f@f@ffkff@k#k#ffk#f@ff%kk%kfkff@f@kffkk#ffk#%%f@f@k#k#fkkfk#k#k#%@ffkf=fffff@%ffk#fkfffkffkfk#f@k#f@kf%ff%k#fkkffkfffkk#f@f@f@%@%f@f@fkf@k#kfkff@%@ffffff
	k#%kfkff@f@kffkk#ffk#%fff%kff@ffk#kffkffk#k#fk%f@f%f@fkkfk#kfffkfk#kfk#f@%k#=f%fffkffkffkfkkfffffkffff@%ffff%kffkf@k#fkfffkff%%fkfkk#ffkfffk#fkffkf%%k#fffkffk#k#k#k#%f@f@ffffff
;OBF_GLOBVAR name: decodekey
	kf%fkf@fffffkf@f@k#fkk#f@%f%k#fff@kff@kffffkff%fk%kfk#fkf@ffk#ff%f%ffk#fkf@kff@f@fkffkfffk#%f%f@k#k#k#kfk#fffff@fkfk%k#kf=f%fff@fff@k#fkfkffk#%ffkk%kfk#f@fffffffkfkkffkk#%#fkf%kffkf@fkf@ffkfkfkfff%ffk#%f@k#k#k#kfk#fffff@fkfk%f
	f%fkf@f@k#ffk#fkk#ffk#f@k#%fkf%k#kfffkfkff@f@kfk#%@k%kffffffkkff@fkk#k#fk%fk%ffkffkf@f@f@fkf@kffk%kfkf=ff%k#f@f@ffkff@k#k#ffk#f@ff%%ffk#fkfffkffkfk#f@k#f@kf%k%kfk#fkkfffkff@k#fkfff@%#fkf%f@f@k#fkf@ffk#kfkfk#f@f@%ffk#ff
	%kffffkffk#fkffk#f@%k%fkf@f@k#ffk#fkk#ffk#f@k#%f@%kfk#fffkf@f@f@kfk#%#k#ffkfkf=f%k#f@f@ffkff@k#k#ffk#f@ff%fkk%ffk#fkfffff@fkk#kf%#fk%k#fkkffkfffkk#f@f@f@%@%fkf@f@k#ffk#fkk#ffk#f@k#%fk#ff
;OBF_GLOBVAR name: ishexchar
	fkf%kfffkfkfk#ffkfk#fkf@k#f@%@%ffkffkf@f@f@fkf@kffk%ff%fff@f@k#f@f@ffk#ff%f@fkf@=k#kf%k#ffkff@k#ffkffkkfff%fff%k#f@f@ffkff@k#k#ffk#f@ff%k#f@%fkf@f@k#ffk#fkk#ffk#f@k#%ff@
	%kfkffkkffkfkfk%#k%fffkffkfkfkfk#ffk#fkfk%f%k#k#f@k#fffkfffkfkff%k#k%kffffkk#f@ffffffkfffkf%kff%fkfkk#ffkfffk#fkffkf%k#f@=k#kff%ffkffkf@f@f@fkf@kffk%f%fkf@f@k#ffk#fkk#ffk#f@k#%k#f@%fkffk#fkfkfff@kfkffkfk%fff@
	ff%fffffffff@k#kff@ffk#fk%%kffffkfkffk#fffk%%kff@fkkff@f@f@%%fkf@k#k#fffff@f@k#kf%%kffkf@ffkff@k#%#fkf@kff@=%kfk#fkkfffkff@k#fkfff@%%k#f@fkffffk#k#fkf@ffk#fk%kfff%kffffffkkff@fkk#k#fk%f%fff@kfffk#fffkfkkf%fk#f@fff@
;OBF_GLOBVAR name: useshiftkey
	f%kffkf@k#fkfffkff%f%kfk#fkkfffkff@k#fkfff@%f@%kffkkfffkff@fkffffk#kf%%k#k#fffffkfkkffk%ffkffk=ffk%kfffkfk#fffff@ffk#%f@%kffkkff@fkk#f@f@kfkf%kff%ffkff@kfk#f@fkffk#ff%f%ffkffkf@f@f@fkf@kffk%kff%fkfkkffffkf@fkffkfkfkf%#
	fkf@%ffk#ffkff@kff@f@%%fkkff@kffffff@ffffk#%fkfk%kfkfk#f@f@kffffff@k#%k#k%f@f@f@k#f@kfk#fkfk%ff@=ffk#%fkk#fkk#k#k#fkkff@fk%f@kf%f@fkf@kfk#k#fff@k#k#ffk#%ffkf%fkfkfkkffkf@ffkfk#k#fk%k#
	fkk%kffffffkkff@fkk#k#fk%#%kfk#fffkf@f@f@kfk#%#%f@k#f@f@f@fffffk%#f@f%f@fkkfk#kfk#f@k#k#fkfffk%@fkk#=ff%k#k#fffffkfkkffk%k#%ffkffkf@f@f@fkf@kffk%@%kffffkfkk#fkfffff@f@%%fkkffkfkf@kfk#f@f@k#ffk#%f%kffff@fff@f@f@f@kfkfk#%ffkffk#

;LOS vars for function  named: creategui
;OBF_FUNC_4_LOSVAR name: h1font
	kff@%k#f@ffk#ffffk#ff%k#%f@f@k#k#fkkfk#k#k#%kf%f@f@fff@k#fkfkffk#fkf@fk%k%k#fff@fkfkfkffkfffk#%f@kf=k%f@fkf@k#k#kffff@%%fkkff@kffffff@ffffk#%@f%fffkf@f@ffk#ffk#k#kff@f@%%kffkkfffkff@fkffffk#kf%k%fffkf@k#f@kfff%fk#ffkff@
	fff%fkffk#fkfkfff@kfkffkfk%ff@%kfk#fkf@ffk#ff%%kffkf@fkf@ffkfkfkfff%ffk%f@fkf@k#f@fkfkffk#kfff%ff@fk=k#%k#fffkf@kff@kfkfffkfkfkf%f@%k#kfffkfkff@f@kfk#%f@kf%kffkf@ffkff@k#%#%f@k#k#k#kfk#fffff@fkfk%fkff@
;OBF_FUNC_4_LOSVAR name: h2font
	%f@f@k#f@fff@f@k#%fkf%f@fkkfk#kfffkfk#kfk#f@%%f@fffkk#ffk#fffk%#ffk%kffkkfffkff@fkffffk#kf%ff%f@fkkfkffff@fkk#fkfkkf%kfk#fkk#f@kf=f@%kfk#fkf@ffk#ff%@k%kfkff@f@kffkk#ffk#%fkf%k#kffkffkfk#fk%kkf%kff@fkkff@f@f@%f
	kfk%kfkfk#k#kfffkfkfk#fffkfk%fkf%kfk#fffkf@f@f@kfk#%kff%f@f@k#fkf@ffk#kfkfk#f@f@%k#k#=%kfffkfffkffkfk%f@%kfkff@f@kffkk#ffk#%@k%f@fkf@kfk#k#fff@k#k#ffk#%%kffkfkkff@kfkff@f@k#%%fkf@f@k#ffk#fkk#ffk#f@k#%kfkkfff
;OBF_FUNC_4_LOSVAR name: basefont
	kff@%fkf@f@k#ffk#fkk#ffk#f@k#%kkfk#%kfkff@f@kffkk#ffk#%fk#k%kffkfkkff@kfkff@f@k#%#kf%f@fff@fkkfkffkf@%f@ffkf=%k#ffkff@k#ffkffkkfff%fkfk%k#f@f@ffkff@k#k#ffk#f@ff%%f@f@k#fffkk#fkkffkfkfkff%kff%f@fffkkffkfff@fkk#ff%%f@fffffff@k#ffk#fkfkk#k#%k#kffkf@k#fk
	%f@fkkfk#kfk#f@k#k#fkfffk%%kff@fkkff@f@f@%kk#%fkkffkfkf@kfk#f@f@k#ffk#%@k#fkfffff@ffkfkfff=fkfkf%kfk#fkfffffffffk%f%f@kfkffff@fffk%ff@k#%k#f@k#f@kff@kff@fff@%f%k#fff@fkfkfkffkfffk#%kf@k#fk
;OBF_FUNC_4_LOSVAR name: mymessage
	%k#fff@fkfkfkffkfffk#%@%k#f@f@ffkff@k#k#ffk#f@ff%f%fff@fff@k#fkfkffk#%%f@fffkkffkfff@fkk#ff%ff@fff@k#f@ffffffk#f@=kf%fkf@f@k#ffk#fkk#ffk#f@k#%%fkkfk#f@f@f@kff@%%fkfkkfkfkffkf@ffk#f@kf%@k%k#fkkffkfffkk#f@f@f@%ffkffkk#k#
	k%f@fkf@f@k#fkf@f@fff@fkfk%%f@k#f@f@ffffk#kfff%f%fkkff@kffffff@ffffk#%@%f@f@fkf@k#kfkff@%@f%kfkffkkffkf@fkffffkf%k#kff@=%ffk#fkf@kff@f@fkffkfffk#%ff@%k#f@ffk#ffffk#ff%k%kfkff@f@kffkk#ffk#%ffkffkk#k#
;LOS vars for function  named: decode_ihidestr
;OBF_FUNC_6_LOSVAR name: newstr
	%f@ffkffff@fffffkkff@%%fkf@fff@fkk#fff@ffffk#f@%kff%f@k#f@k#k#k#k#fkfkf@kffk%f@f%kffkf@fkf@ffkfkfkfff%k#%f@kffkk#kffkkff@ff%@fkkf=%fkk#fkk#k#k#fkkff@fk%k#fkk%fffkffkffkfkkfffffkffff@%#f@f%ffk#fkf@kff@f@fkffkfffk#%f%fkkffkfkf@kfk#f@f@k#ffk#%fkfffff@
	fkf%ffffkff@f@f@kfkfkff@%%fffffkffkfk#fff@kff@k#ff%k#%fkkff@kffffff@ffffk#%%kfkffkkffkf@fkffffkf%kfkffffff@ffff=k#%fkfkk#k#fffkf@k#fkkfffkf%fkk%f@kffkk#ffkffkfff@fkkffk%f%kffkf@fkf@ffkfkfkfff%fkf%k#fff@fkfkfkffkfffk#%f%k#fff@k#fkfffffkk#fk%kfffff@
;OBF_FUNC_6_LOSVAR name: startstrlen
	f@f%fkfkf@ffkfffk#%fkff%fff@fkk#f@k#f@ffk#fffk%f@fkf%k#fff@fkfkfkffkfffk#%%fkkffkfkf@kfk#f@f@k#ffk#%fffkff@fkf@=fff%kffkkff@fkk#f@f@kfkf%ff%ffkff@kfk#f@fkffk#ff%@f@%f@k#k#k#kfk#fffff@fkfk%%ffkffkf@f@f@fkf@kffk%%fkfkfkkffkf@ffkfk#k#fk%ffff@
	kffkf%fkkff@kffffff@ffffk#%kfff%k#k#kffkfff@fkfkkf%f%f@fkkfkffff@fkk#fkfkkf%f@%kfk#fkkfffkff@k#fkfff@%fk#kffk=ff%kfkff@f@kffkk#ffk#%ff@%fffkf@k#f@kfff%f%kfk#ffk#fff@kfk#fkkf%ff%k#f@f@ffkff@k#k#ffk#f@ff%ffff@
;OBF_FUNC_6_LOSVAR name: charnum
	k#fkkf%fkfkk#ffkfffk#fkffkf%@ffkfk%f@k#fkk#k#fkf@fffk%#kf%kfkffkkffkf@fkffffkf%f%k#fffkffk#k#k#k#%@kffkkf=f@f%f@fkkfkffff@fkk#fkfkkf%fffk%fkffk#f@f@kff@fkk#%k#fff%ffffk#kffkfffkk#%fkfkf@
	f%kfk#fkkfffkff@k#fkfff@%%kfk#k#ffkffkfkf@kfff%%ffkffkf@f@f@fkf@kffk%fk#%k#fff@k#fkfffffkk#fk%k%f@fkf@k#k#kffff@%fkkffkffk#ffkf=f@f%kfffkfffkffkfk%@f%fffkk#fkfffkffkffk%ffkk%fkffkfk#fkk#f@fkfk%%fkkff@kffffff@ffffk#%ff@%k#f@f@ffkff@k#k#ffk#f@ff%kfkf@
;OBF_FUNC_6_LOSVAR name: hinibble
	f%fffkf@fkf@kfffkff@kf%k#fkffk%fkkfk#k#fkf@kf%%kfk#fkfffkfkfff@f@%f@%f@fkf@ffk#fkkf%ffkf@f@f@f@fkk#=f%f@k#k#ffk#kffkff%%fffkf@fkf@kfffkff@kf%fkf%fkfffffffffkf@fkffkffkff%k#kffffff@
	ffkfk#%kfkffkfkkfffk#fff@k#f@kf%%k#f@f@ffkff@k#k#ffk#f@ff%%ffk#fkf@kff@f@fkffkfffk#%fkfkk#k#fkf@kfkf=%f@f@fkf@k#kfkff@%k%k#fffkf@kff@kfkfffkfkfkf%fkf%kffffffkkff@fkk#k#fk%kk#%f@fffkk#ffk#fffk%%fkfkfkkffkf@ffkfk#k#fk%fffff@
;OBF_FUNC_6_LOSVAR name: lownibble
	fkf@%fkfkkffffkf@fkffkfkfkf%fk#k%kfk#f@fffffffkfkkffkk#%#k#k%f@k#f@f@ffffk#kfff%fk%f@fkf@kfk#k#fff@k#k#ffk#%k#%k#fkkffkfffkk#f@f@f@%fk#=f%ffffk#kffkfffkk#%%f@f@k#k#ffkff@fffkffk#fk%f%fkf@k#k#fffff@f@k#kf%fkkf%f@fkf@ffk#fkkf%ff@fkffkf
	%kfk#fkf@ffk#ff%kfk%f@fkf@k#f@fkfkffk#kfff%fkfk%f@f@k#k#fkkfk#k#k#%kf@f@=%k#fffkffk#k#k#k#%@%f@kffkk#kffkkff@ff%kf%fkkfkfkffkkfk#fkf@kf%kk%f@kfkffff@fffk%fkf%kff@fkkff@f@f@%@fkffkf
;OBF_FUNC_6_LOSVAR name: mybinary
	f%fffkk#fkfkk#fffkfffkk#fk%@%f@kffkk#kffkkff@ff%k%kfk#fkkfffkff@k#fkfff@%#f@%fkf@f@fkfkk#k#k#fk%kf%k#fkkffkfffkk#f@f@f@%@k#fk=ff%fkkffkfkf@kfk#f@f@k#ffk#%f%kfkffkkffkf@fkffffkf%#ff%fkk#k#f@kfk#k#kfk#fkfk%f@kfkfk#fkfk
	ff%k#fff@k#fkfffffkk#fk%k#k%fkf@fff@fkk#fff@ffffk#f@%#f%fkfkfkkffkf@ffkfk#k#fk%%fkf@k#k#fffff@f@k#kf%#k#k#k#ffk#=%fff@kfffk#fffkfkkf%%k#fkkffkfffkk#f@f@f@%fffk%k#f@k#k#k#kfk#fkfff@%fff@kfkfk#fkfk

;PARAMETERS for function  named: test_parameters
;OBF_FUNC_3_PARAM name: myparam
	fk%k#k#ffkfkff@fkf@fff@fk%fffkff%f@kffkk#kffkkff@ff%fkffkf@%kfk#fkkfffkff@k#fkfff@%#f@fk=k%kffff@fff@f@f@f@kfkfk#%f%kff@fkkff@f@f@%k%kffffffkkff@fkk#k#fk%ff%kfkffkkffkf@fkffffkf%#fkffkf
	k%ffk#fkfffff@fkk#kf%%k#fff@fkfkfkffkfffk#%fk%f@f@k#k#fkkfk#k#k#%ffkfff@k#k#ffk#fkkfk#=kf%kfkffkfkkfffk#fff@k#f@kf%fkf%k#f@f@ffkff@k#k#ffk#f@ff%k#%f@f@fkf@k#kfkff@%%kffkffffkffkk#k#fkkffkk#%ffkf
;PARAMETERS for function  named: ihidestr
;OBF_FUNC_5_PARAM name: thisstr
	fk%f@kfk#k#f@k#kff@fffkfk%k#ff%ffk#fkf@kff@f@fkffkfffk#%#%kff@fkkff@f@f@%@%f@fkk#fkk#f@fffffkfff@ff%#fkf@=f%kfffk#fkfff@fff@ff%k%kfffkfk#fffff@ffk#%f@%f@k#f@f@f@fffffk%ff%fffffffff@k#kff@ffk#fk%@ffk#k#
	k%k#ffkff@k#ffkffkkfff%ff@%kfk#fkfffkfkfff@f@%fk%fkfffffffffkf@fkffkffkff%#%f@k#k#k#kfk#fffff@fkfk%%f@fkkfkffff@fkk#fkfkkf%kffff@ff=fkk%fkkfk#k#fkf@kf%%f@fkf@k#f@fkfkffk#kfff%f@%f@fffkk#ffk#fffk%f%f@fkkfkfkfkffkf@kf%%fkkff@kffffff@ffffk#%@ffk#k#
;PARAMETERS for function  named: decode_ihidestr
;OBF_FUNC_6_PARAM name: startstr
	k%fkk#f@fff@f@kfkfffkf%f@f%kfkff@f@kffkk#ffk#%%k#fffkkffkfffkf@f@f@%fff@fkf@f@k#kffk=ff%fkk#k#f@kfk#k#kfk#fkfk%%k#ffkff@k#ffkffkkfff%k%kff@fff@kffff@ffkffff@%%kfkfk#k#kfffkfkfk#fffkfk%k%fffffkffkfk#fff@kff@k#ff%#kfffff
	%fkfffffffffkf@fkffkffkff%#fkf%f@f@kfkffkffkffkk#ffkf%f%fkkfkfkffkkfk#fkf@kf%ffk%k#fff@fkfkfkffkfffk#%kff@fk=ff%kfkffkkffkf@fkffffkf%#fk%kfkffkkffkf@fkffffkf%%f@f@fkk#f@ffk#kf%%f@kfkffff@fffk%#kfffff
;PARAMETERS for function  named: decode_hexshiftkeys
;OBF_FUNC_7_PARAM name: startstr
	f@%f@k#f@f@f@fffffk%fk%k#fffkffk#k#k#k#%kff%fffkf@fkf@kfffkff@kf%ffk%kffffkffk#fkffk#f@%#f@=k%fkfkfkkffkf@ffkfk#k#fk%ff%fkk#fkk#k#k#fkkff@fk%%kfk#fkf@ffk#ff%kf%k#fffkkffkfffkf@f@f@%kfff@kf
	ff%fkf@k#k#fffff@f@k#kf%ffkf%fkf@k#k#fffff@f@k#kf%f@ff%f@k#k#k#kfk#fffff@fkfk%fff%fff@f@f@k#k#k#ff%kff@=kff%fkfkkfkfkffkf@ffk#f@kf%%fkk#k#f@kfk#k#kfk#fkfk%ffk%f@f@k#k#fkkfk#k#k#%k%fkkff@kffffff@ffffk#%ff@kf
;PARAMETERS for function  named: decode_shifthexdigit
;OBF_FUNC_8_PARAM name: hexvalue
	f%fkffk#fkfkfff@kfkffkfk%f%ffkffkf@f@f@fkf@kffk%%kffffkfkk#fkfffff@f@%kffk%f@k#k#k#kfk#fffff@fkfk%@kffkfkfkkf=%fkfffffffffkf@fkffkffkff%fff%k#ffkfffk#f@kff@k#%k#k%f@f@fkk#fffkk#%#f%fkkffkfkf@kfk#f@f@k#ffk#%%fkfkk#ffkfffk#fkffkf%@fffk
	f@k#f%ffk#fkfffkffkfk#f@k#f@kf%%fffkf@fkf@kfffkff@kf%k#%k#f@k#f@kff@kff@fff@%%fffkf@k#f@kfff%%kfkff@f@kffkk#ffk#%k#f@fkk#f@fkf@fk=kfff%k#k#fffffkfkkffk%k#%fffkf@fkf@kfffkff@kf%%fkf@f@kff@fkffkff@%fff@fffk
;PARAMETERS for function  named: fixescapes
;OBF_FUNC_9_PARAM name: forstr
	f@fk%f@f@fkk#fffkk#%kffkk%fkk#f@fff@f@kfkfffkf%fkf@f@%fffkf@fkf@kfffkff@kf%%f@f@k#k#fkkfk#k#k#%fkffk#ff=fkkf%f@kffkk#kffkkff@ff%@f@%fkffkff@f@ffk#f@kffffk%kfk%ffk#fkfffkffkfk#f@k#f@kf%ffkf%kfk#fffkf@f@f@kfk#%
	f@kf%fkkfkfkffkkfk#fkf@kf%fffk%fkfkkffffkf@fkffkfkfkf%ff@kfk#%k#fffkffk#k#k#k#%ff@f@fk=%f@f@k#k#ffkff@fffkffk#fk%fk%kfkffkfkkfffk#fff@k#f@kf%kff%kffkf@fkf@ffkfkfkfff%f@%fkfkkffffkf@fkffkfkfkf%fk%f@f@fkf@k#kfkff@%fkfk

;always use these dumps for function and label fragments when
;doing dynamic obfuscation 
;OBF_FUNC name: helloworld
	ff%fffkk#fkfkk#fffkfffkk#fk%ff%kfkff@f@kffkk#ffk#%fk#%kfkff@f@kffkk#ffk#%kfk%kffkf@ffkff@k#%#=kf%ffffkff@f@f@kfkfkff@%k#ff%f@k#k#k#kfk#fffff@fkfk%%kfffk#fkfff@fff@ff%kfkf
	f%k#fffkffk#k#k#k#%kf%f@fkf@kfk#k#fff@k#k#ffk#%%f@fff@fkkfkffkf@%f%fkfkkfk#kfkff@ff%kffkkfk#ff=kf%kffkffffkffkk#k#fkkffkk#%#%fkf@f@k#ffk#fkk#ffk#f@k#%f%f@k#k#k#kfk#fffff@fkfk%%fkffffkfk#fffkffk#k#k#%kkfkf
;OBF_FUNC name: testfunction
	%fkkfk#f@f@f@kff@%%f@kffff@kffffffffkk#f@k#%f@%kffkffffkffkk#k#fkkffkk#%f%f@f@fkf@k#kfkff@%kk#f@k#k#ff=f%f@k#k#ffk#kffkff%kff%kfkffkkffkfkfk%%f@f@k#k#fkkfk#k#k#%ffk#fffk
	k%k#f@k#k#k#kfk#fkfff@%k#f@f%fkfkk#k#fffkf@k#fkkfffkf%@k#%kfk#fkkfffkff@k#fkfff@%#fkk#=fkf%kfk#k#ffkffkfkf@kfff%fkf%f@f@k#k#fkkfk#k#k#%f%kfk#fffkf@f@f@kfk#%#f%fkfkk#ffkfffk#fkffkf%fk
;OBF_FUNC name: test_parameters
	fkk%fkkff@kffffff@ffffk#%k#%kfk#fkk#f@k#f@kffkk#%ff%f@fffkk#ffk#fffk%f%kffkkff@fkk#f@f@kfkf%f@kfkf=f@f%fkffk#fkfkfff@kfkffkfk%%f@fkk#fkk#f@fffffkfff@ff%%f@f@k#k#fkkfk#k#k#%%kfkfk#k#kfffkfkfk#fffkfk%kff@ffkf
	f@%fkf@f@k#ffk#fkk#ffk#f@k#%fff%f@fkf@k#f@fkfkffk#kfff%%kfk#f@fffffffkfkkffkk#%k%k#f@fkffffk#k#fkf@ffk#fk%k#fkk#=f@fk%f@ffffk#fkfffk%ffkf%k#fff@fkfkfkffkfffk#%@f%f@fkf@kfk#k#fff@k#k#ffk#%kf
;OBF_FUNC name: creategui
	k#%k#k#fffkfff@f@kf%kfk%k#k#fkk#f@f@k#k#ff%fk%fkfkfkkffkf@ffkfk#k#fk%ffkkffk=f@%kffffkfkk#fkfffff@f@%#%f@fkkfk#kfk#f@k#k#fkfffk%f%kfk#fkfffffffffk%f%f@kffkk#kffkkff@ff%fk%k#f@f@fkfkkffkkf%kffk
	f@%ffkff@kfk#f@fkffk#ff%%f@fkf@ffk#fkkf%#%fkfkk#ffkfffk#fkffkf%@%f@kffkk#kffkkff@ff%ff%fffkk#fkfffkffkffk%@f@ff=f%ffffk#kffkfffkk#%%ffk#fkf@kff@f@fkffkfffk#%#f%k#ffkff@k#ffkffkkfff%kfffkkffk
;OBF_FUNC name: ihidestr
	ff%kfk#fkk#f@k#f@kffkk#%fff%fff@f@k#f@f@ffk#ff%kff@%kfffk#fkfff@fff@ff%#k#=f@fk%kfkffkfkkfffk#fff@k#f@kf%fffk%f@f@k#k#fkkfk#k#k#%@%f@k#f@f@f@fffffk%f%kfkffkfkkfffk#fff@k#f@kf%k#kf
	k%kfk#fkf@ffk#ff%k%f@k#k#ffk#kffkff%%fkkff@kffffff@ffffk#%f%kfffkfffkffkfk%@fffkfk=f%kffkf@k#fkfffkff%f%f@fkf@ffk#fkkf%ff%fkf@k#fkfffff@ffkfkff@kf%%f@k#fkk#k#fkf@fffk%fkf@kfk#kf
;OBF_FUNC name: decode_ihidestr
	fff%k#k#kffkfff@fkfkkf%f%kfffk#fkfff@fff@ff%#%fkkff@kffffff@ffffk#%@kf%ffk#fkf@kff@f@fkffkfffk#%#=%fkkff@kffffff@ffffk#%f%fkfkfkkffkf@ffkfk#k#fk%%kffkkff@fkk#f@f@kfkf%@k#k#kffkkf
	%f@k#f@f@ffffk#kfff%%k#fff@fkfkfkffkfffk#%@kf%f@fffkkffkfff@fkk#ff%@%kfkff@f@kffkk#ffk#%ffkff=fff%k#ffk#fkkffkfffkfffkk#kf%k%k#k#fffkfff@f@kf%%fkk#f@fff@f@kfkfffkf%k#k%kffffffkkff@fkk#k#fk%ffkkf
;OBF_FUNC name: decode_hexshiftkeys
	fkk%fkf@fff@fkk#fff@ffffk#f@%ffk%k#kffffkffk#fffff@ff%kf%k#fkkffkfffkk#f@f@f@%kff=kf%k#fkkffkfffkk#f@f@f@%%f@kfkffff@fffk%@%f@k#f@ffk#k#kfffk#%f@%fkf@f@k#ffk#fkk#ffk#f@k#%k%kfkff@f@kffkk#ffk#%@fffk
	%kfkff@f@kffkk#ffk#%@f%kff@fffkfffffkk#kf%fk%fkfkk#ffkfffk#fkffkf%k%f@fkkfk#kfk#f@k#k#fkfffk%ff%fff@f@k#f@f@ffk#ff%ffk#=kf%f@k#k#k#kfk#fffff@fkfk%@f%k#kffkffkfk#fk%@fk%f@fkf@kfk#k#fff@k#k#ffk#%%fkk#k#f@kfk#k#kfk#fkfk%@fffk
;OBF_FUNC name: decode_shifthexdigit
	%k#fkkffkfffkk#f@f@f@%kf%kfkffkkffkfkfk%k#%kffffffkkff@fkk#k#fk%fkk%k#k#kffkfff@fkfkkf%fkffkkf=f%kffkf@ffkff@k#%%fkf@f@fkfkk#k#k#fk%f@%f@fkf@k#f@fkfkffk#kfff%f%fkkff@kffffff@ffffk#%f%fffffkk#fkfkffkf%k#k#
	f%k#f@f@ffkff@k#k#ffk#f@ff%%f@ffffk#fkfffk%f%fff@fkk#f@k#f@ffk#fffk%%f@fkf@ffk#fkkf%%k#fkkffkfffkk#f@f@f@%@kfkffkkf=f%fffkk#fkfkk#fffkfffkk#fk%kf%f@f@fkk#fffkk#%@f%f@f@k#k#fkkfk#k#k#%f@%kfk#fffkf@f@f@kfk#%#k#
;OBF_FUNC name: fixescapes
	f%kff@fkkff@f@f@%k%k#fff@k#fkfffffkk#fk%%fkk#fkk#k#k#fkkff@fk%ff%f@fkfkk#k#k#k#k#k#fk%f%kfk#ffk#fff@kfk#fkkf%kfk#=%f@fffkkffkfff@fkk#ff%fkf%fkffk#fkfkfff@kfkffkfk%fk%k#k#fffffkfkkffk%f@f%f@fkkfkffff@fkk#fkfkkf%f@
	f%f@fkf@k#f@fkfkffk#kfff%f%k#fffkfkfffkfkk#%%kfkffkkffkfkfk%ffk%fkfkkffffkf@fkffkfkfkf%fk#kf=%f@f@k#k#fkkfk#k#k#%fkf%fkfffff@fkfkk#k#kfk#k#%f%f@fkk#fkk#f@fffffkfff@ff%f%f@fkkfkfkfkffkf@kf%@f@f@


;OBF_LABEL name: test_label
	k%kffff@fff@f@f@f@kfkfk#%fkf%k#fffkffk#k#k#k#%kfkf%f@fkf@ffk#fkkf%fkfkkfk#kfkfk#k#fff@=k#k%f@fffkkffkfff@fkk#ff%ffk#%kfk#fkfffffffffk%ff%kfk#fkk#f@k#f@kffkk#%kffk%kfk#f@fffffffkfkkffkk#%#k#kff@f@kf
	fffkfk%f@fkf@f@k#fkf@f@fff@fkfk%fkf@k#%kfkffkkffkf@fkffffkf%#%fkfkkffffkf@fkffkfkfkf%ffkff%f@fffkkffkfff@fkk#ff%@k#kfk#fkf@kff@=k#kf%f@fkf@k#f@fkfkffk#kfff%ffk#kf%ffkffkf@f@f@fkf@kffk%kffk#%ffk#fkf@kff@f@fkffkfffk#%#kff@%f@fkf@kfk#k#fff@k#k#ffk#%@kf
;OBF_LABEL name: testguisubmit
	f@f%kffff@fff@f@f@f@kfkfk#%@k#%f@fkf@kfk#k#fff@k#k#ffk#%%k#fkkffkfffkk#f@f@f@%fff%k#fff@fkfkfkffkfffk#%kf%kff@fffkfffffkk#kf%f@ffffkff@kffk=fkffk#%k#k#fffffkfkkffk%fk%kfkfk#k#kfffkfkfk#fffkfk%@fk%kffkffffkffkk#k#fkkffkk#%%kfkfk#f@f@kffffff@k#%fkffk#kfffk#k#
	kfkfk%fkfkk#ffkfffk#fkffkf%f@fff%fkfffffffffkf@fkffkffkff%fkk%fkfkfkk#f@k#ffffff%#f@f@%kffffkfkk#fkfffff@f@%#fkk%fff@kfffk#fffkfkkf%#kfk#kf=%f@fkf@kfk#k#fff@k#k#ffk#%kf%fff@fff@k#fkfkffk#%fk#f%f@f@fkk#fffkk#%kf@fkk%k#f@fkffffk#k#fkf@ffk#fk%fkffk#kfffk#k#
;OBF_LABEL name: cancelprog
	fffkkf%f@fkkfkfkfkffkf@kf%f%fkf@f@k#ffk#fkk#ffk#f@k#%k#ffk%k#f@k#k#k#kfk#fkfff@%kfffkff@kf=%fkk#k#f@kfk#k#kfk#fkfk%f@fff%fkfkk#ffkfffk#fkffkf%k#%f@fkf@kfk#k#fff@k#k#ffk#%@kf%k#fffkffk#k#k#k#%@kffkfff@
	ff%k#f@f@ffkff@k#k#ffk#f@ff%kkff@%ffkffkf@f@f@fkf@kffk%@fkfk%f@k#fkk#k#fkf@fffk%fffffkk#kfk#f@=f@f%fkf@k#fkfffff@ffkfkff@kf%%k#fff@fkfkfkffkfffk#%f%fkkff@kffffff@ffffk#%k#f%k#kfffkfkff@f@kfk#%@k%fkfkfkkffkf@ffkfk#k#fk%f@kffkfff@
;OBF_LABEL name: guigosub
	fk%fkfkk#k#fffkf@k#fkkfffkf%%f@kffkk#kffkkff@ff%%ffkfkfffffffkffk%fkk#fffkffk#k#f@f@ffk#k#=fkf%k#fffkffk#k#k#k#%k#fkf%f@fkf@k#f@fkfkffk#kfff%fffff%f@f@f@k#fkfffkkff@k#%k#fffk%f@f@k#k#fkkfk#k#k#%kkfkf%f@f@fkf@k#kfkff@%kfk
	ff%fkfffffffffkf@fkffkffkff%#%fkf@f@k#ffk#fkk#ffk#f@k#%ff@f@k%f@f@f@k#fkfffkkff@k#%#k%fkk#f@fff@f@kfkfffkf%fkfkfkkffkk#fkf@=f%fkfffffffffkf@fkffkffkff%%f@kfk#k#f@k#kff@fffkfk%ffk#f%f@fkf@ffk#fkkf%%k#fff@fkfkfkffkfffk#%fffffk#fffkfkkfkffkfk


;if you had created 'secure' obfuscation classes then they would 
;have to have dumps for them
;for obfuscated system function calls
;OBF_SYSFUNC name: DllCall
	fkk%k#fff@fkfkfkffkfffk#%ffk%kfkff@f@kffkk#ffk#%f@%k#ffkff@k#ffkffkkfff%k#f%kffff@fff@f@f@f@kfkfk#%@kf=%kfk#f@fffffffkfkkffkk#%%fffffffff@k#kff@ffk#fk%D%kfffkfffkffkfk%%f@fkkfkfkfkffkf@kf%
	k%ffffkfkff@kfkff@f@ff%fk#%fkkffkfkf@kfk#f@f@k#ffk#%%fkfkkfkfkffkf@ffk#f@kf%ffk%f@fkf@ffk#fkkf%ff@ff=%k#k#fffffkfkkffk%%f@fffkfkkff@k#fffkkf%l%k#fff@k#fkfffffkk#fk%l%fffffffff@k#kff@ffk#fk%C%fkf@fff@fkk#fff@ffffk#f@%a%f@ffffk#fkfffk%l%fkffkff@f@ffk#f@kffffk%l%kffffkfkffk#fffk%%f@f@f@k#f@kfk#fkfk%
	f%fff@k#f@f@ffffffk#fk%f%f@fkf@ffk#fkkf%%f@kffkk#ffkffkfff@fkkffk%k#f%fkfkfkkffkf@ffkfk#k#fk%f%ffkff@f@fffkfff@kfk#k#kf%@fkk#f@=%kfk#fkfffkfkfff@f@%%fkf@f@fkfkk#k#k#fk%D%kffkfkkff@kfkff@f@k#%l%kfk#f@fffffffkfkkffkk#%%k#fff@k#fkfffffkk#fk%
	f%kfk#k#ffkffkfkf@kfff%kff%f@kffff@kffffffffkk#f@k#%k#f@%f@f@fkf@k#kfkff@%%kffkf@ffkff@k#%fkf@f@=%fff@kfffk#fffkfkkf%%fff@k#f@f@ffffffk#fk%l%k#fff@k#fkfffffkk#fk%C%k#ffkfffk#f@kff@k#%a%fff@k#f@f@ffffffk#fk%l%fffkf@k#f@kfff%l%f@k#f@f@ffffk#kfff%%f@kffff@kffffffffkk#f@k#%
	%k#f@f@ffkff@k#k#ffk#f@ff%fk#%k#f@f@ffkff@k#k#ffk#f@ff%%fkfkk#ffkfkfk#fk%@f%k#ffk#fkkffkfffkfffkk#kf%k%f@fkf@f@k#fkf@f@fff@fkfk%#ffffk#=%fkk#fkk#k#k#fkkff@fk%%f@fff@fkkfkffkf@%D%f@fkf@k#f@fkfkffk#kfff%l%fkffffkfk#fffkffk#k#k#%l%fkkfk#f@f@f@kff@%C%fff@fff@k#fkfkffk#%a%f@f@kfkffkffkffkk#ffkf%%f@f@f@k#f@kfk#fkfk%
	%fff@kfffk#fffkfkkf%fkk%fkfkkfkffkf@f@f@f@%f%f@f@fkk#fffkk#%%ffffk#kffkfffkk#%ff%kfkff@f@kffkk#ffk#%@k#k#k#=%kfk#k#ffkffkfkf@kfff%%f@f@f@k#fkfffkkff@k#%l%kfffkfkfk#ffkfk#fkf@k#f@%l%k#ffkfffk#f@kff@k#%%k#fff@kfkff@fkkfkffk%
	f@%f@ffkffff@fffffkkff@%f%f@fkkfkffff@fkk#fkfkkf%f%f@f@f@k#f@kfk#fkfk%%kff@fkkff@f@f@%f%f@k#f@f@f@fffffk%k#kf=%fkfkkfkfkffkf@ffk#f@kf%%k#kfffkfkff@f@kfk#%D%ffk#ffkff@kff@f@%l%k#k#ffkfkff@fkf@fff@fk%%k#k#kffkfff@fkfkkf%
	fkf%kffffkffk#fkffk#f@%kk#f%ffffk#kffkfffkk#%f@f@f%k#fffkffk#k#k#k#%fk=%fffkffkfkfkfk#ffk#fkfk%%fff@kfffk#fffkfkkf%l%k#f@f@fkfkkffkkf%C%fkfffkkfkffkkff@f@%a%k#ffkff@k#ffkffkkfff%l%f@fkf@f@k#fkf@f@fff@fkfk%l%k#k#kffkfff@fkfkkf%%f@k#f@f@ffffk#kfff%
;OBF_SYSFUNC name: WinExist
	f%fff@k#f@f@ffffffk#fk%@kfk%kfffkfk#fffff@ffk#%f%k#fffkffk#k#k#k#%fff@k#=%fffkf@k#f@kfff%%k#fff@kfkff@fkkfkffk%W%k#fffkfkfffkfkk#%i%ffkff@kfk#f@fkffk#ff%%f@k#f@f@ffffk#kfff%
	fff%f@fkkfkffff@fkk#fkfkkf%fk%kff@fkkff@f@f@%fk#f%f@fkf@f@k#fkf@f@fff@fkfk%@ffkf=%fffkk#fkfffkffkffk%%k#k#kfffk#k#fkfffffkk#%n%f@f@fkk#f@ffk#kf%E%fffffkfff@k#f@fkfkf@k#%x%fkffk#fkfkfff@kfkffkfk%i%f@f@f@k#f@kfk#fkfk%s%f@fkf@f@k#fkf@f@fff@fkfk%t%f@f@fkk#f@ffk#kf%%f@f@kfkffkffkffkk#ffkf%
	k#kf%f@fkkfk#kfk#f@k#k#fkfffk%fff@%fffffffff@k#kff@ffk#fk%f%fkfkkffffkf@fkffkfkfkf%k#f%kfffk#fkfff@fff@ff%k#=%k#f@f@fkfkkffkkf%%f@f@k#fkfkkffffkfff@f@%W%kffffffkkff@fkk#k#fk%i%fkfkk#k#fffkf@k#fkkfffkf%n%k#kffffkffk#fffff@ff%%f@k#fkk#k#fkf@fffk%
	kf%fkkff@kffffff@ffffk#%kk%kffffkffk#fkffk#f@%#%f@fkf@kfk#k#fff@k#k#ffk#%k%f@f@f@k#f@kfk#fkfk%f%fkf@f@k#ffk#fkk#ffk#f@k#%fff@=%k#f@ffk#ffffk#ff%%kfk#fkk#f@k#f@kffkk#%E%kfk#fkk#f@k#f@kffkk#%x%fkfkk#ffkfkfk#fk%i%kffkkfffkff@fkffffk#kf%s%fffffkfff@k#f@fkfkf@k#%t%f@fffkfkkff@k#fffkkf%%ffkffkf@fkffkff@fff@f@k#%
	%f@f@k#k#fkkfk#k#k#%ff%fkk#fkk#k#k#fkkff@fk%kfk%f@f@fkf@k#kfkff@%@ff%f@k#f@f@f@fffffk%fkf=%kfk#k#ffkffkfkf@kfff%%k#kffkffkfk#fk%W%fkffkff@f@ffk#f@kffffk%i%k#kfffkfkff@f@kfk#%n%kfk#k#ffkffkfkf@kfff%E%fff@kfffk#fffkfkkf%x%k#fffkfkfffkfkk#%i%k#ffkff@k#ffkffkkfff%%ffkff@f@fffkfff@kfk#k#kf%
	f%fkf@f@k#ffk#fkk#ffk#f@k#%f@fk%f@ffkffff@fffffkkff@%f@%f@f@fkf@k#kfkff@%ffk=%ffk#fkfffff@fkk#kf%%k#k#kffkfff@fkfkkf%s%kffkkfffkff@fkffffk#kf%t%k#fffkfkfffkfkk#%%f@fkf@k#f@fkfkffk#kfff%
	kf%fkf@k#k#fffff@f@k#kf%f%k#fffkffk#k#k#k#%fk%kfk#fkf@ffk#ff%kfk%fkffk#f@f@kff@fkk#%#fk=%f@f@k#fkfkkffffkfff@f@%%fkk#fkk#k#k#fkkff@fk%W%kffffffkkff@fkk#k#fk%i%f@f@fkk#f@ffk#kf%n%f@f@kfkffkffkffkk#ffkf%%ffkff@f@fffkfff@kfk#k#kf%
	f@f%k#fff@kfkff@fkkfkffk%%k#fkkffkfffkk#f@f@f@%fkk%f@fffkkffkfff@fkk#ff%f@k%k#fkkffkfffkk#f@f@f@%k#=%f@k#f@f@ffffk#kfff%%fff@f@f@k#k#k#ff%E%kfffkfffkffkfk%x%fkf@k#ffkff@f@k#ffkf%i%kffkfkkff@kfkff@f@k#%s%fkfkkfk#kfkff@ff%t%f@fffkfkkff@k#fffkkf%%fkf@k#fkfffff@ffkfkff@kf%


;$OBFUSCATOR: $DEFGLOBVARS: mytrue, myfalse
k#k%fkfkk#ffkfffk#fkffkf%fkf%fkkfk#f@f@f@kff@%kf%fkfkkfkfkffkf@ffk#f@kf%@kf = 1
%k#kfk#kfffffff%%ffffkfkff@kfkff@f@ff%%fkfffff@fkfkk#k#kfk#k#% = 0

;AUTOHOTKEY BUILT IN FUNCTIONS!
;tell obfuscator to obfuscate these autohotkey built in functions
;$OBFUSCATOR: $DEFSYSFUNCS: DllCall, WinExist 

DetectHiddenWindows On
;test obfuscation of dllcall(), winexist()
if not %k#fffkfkfffkfkk#%%ffk#f@f@k#ffffk#%%fkfkkfk#kfkff@ff%%kfk#f@fffffffkfkkffkk#%%k#fff@k#fkfffffkk#fk%%fkk#f@fff@k#k#k#%("IsWindowVisible", "UInt", %fkfkfkk#f@k#ffffff%%f@f@fkk#fffkk#%%fffkfkf@ffkfkf%%k#k#kffkfff@fkfkkf%%fff@fkf@fffk%%kfk#fkfffkfkfff@f@%("Untitled - Notepad"))  
    MsgBox, TESTING OBF OF BUILT IN AUTOHOTKEY FUNCTIONS:`n`nThe notepad window IS NOT visible.
else
	 MsgBox, TESTING OBF OF BUILT IN AUTOHOTKEY FUNCTIONS:`n`nThe notepad window IS visible.

;test obfuscation of function call
fkff%f@fffkk#ffk#fffk%fffk%fffkk#fkfffkffkffk%#%f@k#f@f@ffffk#kfff%fffk()

;test obfuscation of parameters
;msgbox will show 12 if obfuscation of parameters works
msgbox, % "TEST OF OBF OF PARAMETERS:`n`nparameter: " . f@%fkfkfkk#f@k#ffffff%f%k#k#f@k#fffkfffkfkff%%f@fffkk#ffk#fffk%ff%ffkff@kfk#f@fkffk#ff%kf%f@f@fkf@k#kfkff@%@ffkf(12)

;test obfuscation of label
gosub k%fkfffkffk#f@fff@fkk#%kf%f@f@k#k#fkkfk#k#k#%f%fkfkfkk#f@k#ffffff%k#kffk%f@fkf@k#f@fkfkffk#kfff%ffk#k#kff@f@kf

;tests local variables, global variables, gosub label as 
;part of a 'gui, add' statement, and variables defined as associated
;with a gui control
%f@k#fkk#k#fkf@fffk%%kfkff@f@kffkk#ffk#%@k#%k#fff@kff@kffffkff%fkfffkkffk()
	 
RETURN

;hotkeys SHOULD NOT be obfuscated!
;;but functions and variables inside hotkeys shoulb be
;HOTKEY ORIGINAL NAME: home
home::
	msgbox, home key pressed!
return


;HOTKEY ORIGINAL NAME: RControl & RShift
RControl & RShift::
	msgbox, right control + right shift pressed!
	%kffkkff@fkk#f@f@kfkf%%ffffffk#fkfkk#%%fkfffff@fkfkk#k#kfk#k#%()
return


;HOTKEY ORIGINAL NAME: ^;
^;::
	msgbox, control + semicolon pressed
	%ffk#fkf@kff@f@fkffkfffk#%fk%kffffffkkff@fkk#k#fk%#%fkf@fffffkf@f@k#fkk#f@%fffkkfkf()
return


;FUNCTION ORIGINAL NAME: helloworld
kfk#fffkkfkf() { 
	msgbox, hello world!
}	

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;(technically this one would be all right because it does not call any
;functions or use any variables inside of it)
;FUNCTION ORIGINAL NAME: testfunction
fkffkfffk#fffk() { 
	global
	msgbox, TESTING OBF OF A FUNCTION CALL:`n`ntestfunction has been called	
}

;will test the correct obfuscation of the parameter 'myparam'
;if successful the function will return the value it was sent
;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;FUNCTION ORIGINAL NAME: test_parameters
f@fkffkff@ffkf(kffkffk#fkffkf) { 
	global
	
	%fkfffkffffkffkf@k#f@fk%%f@fffkfkkff@k#fffkkf%%k#ffkfffk#f@kff@k#%:=%f@f@k#f@fff@f@k#%%kffkfffkfff@k#k#ffk#fkkfk#%%f@f@k#fkfkkffffkfff@f@% + k%k#fffkkffkfffkf@f@f@%ff%fkfffffffffkf@fkffkffkff%%f@f@k#fkfkkffffkfff@f@%ffk%fffff@ffk#fkff%fkffkf - kff%kfk#fffkf@f@f@kfk#%ffk#%fkffk#fkfkfff@kfkffkfk%fk%fkf@k#fkfffff@ffkfkff@kf%ffkf	
	return %fkfffkffffkffkf@k#f@fk%%k#ffkff@k#ffkffkkfff%%kff@fffkfffffkk#kf%	
}


;LABEL ORIGINAL NAME: test_label
k#kfffk#kffkffk#k#kff@f@kf:
	msgbox, TESTING OBF OF A LABEL CALL:`n`ninside "gosublabel"
return

;MUST BE ASSUME GLOBAL FOR DYNAMIC OBFUSCATION!
;FUNCTION ORIGINAL NAME: creategui
f@k#fkfffkkffk() { 
	global
	local k#f@f@kfk#ffkff@, f@f@kffkfkkfff, fkfkfkfff@k#kffkf@k#fk, kff@kfffkffkk#k#
;$OBFUSCATOR: $DEFLOSVARS: h1font, h2font, basefont, mymessage

	%kff@fffkfffffkk#kf%%kff@k#fkf@kff@kf%%fkkfkfkffkkfk#fkf@kf% 		= % "s22"
	f@f@%kfk#fffkf@f@f@kfk#%ffkf%f@f@f@k#f@kfk#fkfk%kkf%k#k#kfffk#k#fkfffffkk#%ff 		= % "s18"	
	%ffkff@kfk#f@fkffk#ff%%kff@fkkfk#ffk#k#kff@ffkf%%fff@fkk#f@k#f@ffk#fffk% 	= % "s14"
	kf%f@fkf@kfk#k#fff@k#k#ffk#%@kff%f@f@kfkffkffkffkk#ffkf%fkff%fkffk#f@f@kff@fkk#%kk#k# := %f@f@k#k#ffkff@fffkffk#fk%%ffffk#f@kfk#%%fkffkff@f@ffk#f@kffffk%("1bf2a29832b821d942081196fdd88178018882e6fd78e1c951")

	gui 2:default
	gui, destroy
	gui, margin, 20, 20
	
	;the h1font variable below should be obfuscated
	gui, font, %kfffkfffkffkfk%%k#f@f@kfk#ffkff@%%k#k#kfffk#k#fkfffffkk#% bold
	gui, add, text, xm ym, Obfuscator Test GUI
	
	gui, font, %k#fff@kff@kffffkff%%kffffkffk#fkffk#f@%%fkfkfkfff@k#kffkf@k#fk% norm underline
	;the gosub label below should be obfuscated
	gui, add, text, xm y+12 cblue G%fkf@fkk#fffkffk#k#f@f@ffk#k#%%k#fff@kff@kffffkff%%k#ffkfffk#f@kff@k#%, test gosub obfuscation in gui statement
	
	gui, font, %fkfkfkfff@k#kffkf@k#fk%%kfk#k#ffkffkfkf@kfff%%k#fffkfkfffkfkk#% norm
	gui, add, text, xm y+12 Gfkff%kfffk#fkfff@fff@ff%%k#k#fkk#f@f@k#k#ff%fkfff%kffffkfffffkfkf@%fffk#%f@f@f@k#f@kfk#fkfk%fffkfkkfkffkfk,
(
hello world

TESTING LITERAL STRING OBFUSCATION:
"%fkfffkkfkffkkff@f@%%kff@kfffkffkk#k#%%fffkffkffkfkkfffffkffff@%"

-press home key to test hotkeys-
)
	gui, add, text, xm y+12, enter something here to test`nvariable obfuscation
;$OBFUSCATOR: $DEFGLOBVARS: usermessage
	gui, add, edit, xm y+2 Vf%k#fffkffk#k#k#k#%kfk%fkkfk#f@f@f@kff@%fk%fkkfkfkffkkfk#fkf@kf%fkfkf r4, 
		
	gui, add, button, xm y+20 Gfkff%kffkf@ffkff@k#%#fkf%k#k#ffkfkff@fkf@fff@fk%%f@fkkfkffff@fkk#fkfkkf%%k#fff@kfkff@fkkfkffk%fkk#%k#fffkfkfffkfkk#%fkffk#kfffk#k#, Test gui submit
	gui, add, button, x+20 yp Gf@f%ffkffkf@f@f@fkf@kffk%ffk#%kfkfk#k#kfffkfkfk#fffkfk%@kf%f@kfk#k#f@k#kff@fffkfk%f%f@f@fkk#f@ffk#kf%@%k#ffkff@k#ffkffkkfff%kffkfff@, Cancel program
	gui, show
}


;LABEL ORIGINAL NAME: testguisubmit
fkffk#fkf@fkk#fkffk#kfffk#k#:
	gui, submit, nohide
	msgbox, TESTING OBF OF Vvariablename IN 'gui, add':`n`nyou entered "%ffkfkfkfkfkf%%ffkff@f@fffkfff@kfk#k#kf%%f@fkkfkfkfkffkf@kf%"
return


;LABEL ORIGINAL NAME: cancelprog
f@ffffk#f@kff@kffkfff@:
	exitapp
return


;LABEL ORIGINAL NAME: guigosub
fkffk#fkffffffk#fffkfkkfkffkfk:
	msgbox, inside _guigosub_
return


;SKIPPED MOVING function: 'ihidestr()' to OBF CODE

;put this function in your source code. it will actually be called
;by the obfuscated code to 'decode' the obfuscated strings.
;this function and all calls to it will also be obfuscated in
;the output obfuscated program
;FUNCTION ORIGINAL NAME: decode_ihidestr
fff@k#k#kffkkf(ffk#fkk#kfffff) {  
	global	
;$OBFUSCATOR: $DEFGLOBVARS: hexdigits
	
	static k#fkk#f@fkfffkfffff@, fffff@f@fffffff@, f@f@fffkk#fff@fkfkf@, fkfkfkk#kffffff@, f@fkfkkfkff@fkffkf, ffffk#fff@kfkfk#fkfk
;$OBFUSCATOR: $DEFLOSVARS: newstr, startstrlen, charnum, hinibble, lownibble, mybinary

	ff%fkkfk#f@f@f@kff@%f%fkffffkfk#fffkffk#k#k#%ff@%f@fffkkffkfff@fkk#ff%ff%fff@f@k#f@f@ffk#ff%f@%fkf@fff@fkk#fff@ffffk#f@%ffffff = % "0123456789abcdef"
		
	;will get the encoded key hidden in the obfuscated literal string
	%fffffkffkfk#fff@kff@k#ff%ff%kfffkfffkffkfk%@f@%kffffffkkff@fkk#k#fk%fkf@fffk(ffk#%f@fkkfkfkfkffkf@kf%fkk%fff@f@f@k#k#k#ff%%f@kfk#fff@kfkff@ff%kfffff)
	
	;grab encoded data
	%f@ffkffff@fffffkkff@%%fkfkfkkffkf@ffkfk#k#fk%%f@fffkkffkfff@fkk#ff%%kfffkfffkffkfk%k#fkk#kfffff = % substr(f%f@kfkffff@fffk%f%f@fkf@ffk#fkkf%%f@fkf@k#k#kffff@%fk%f@f@f@k#f@kfk#fkfk%k#%kffkkfffkff@fkffffk#kf%kfffff, 1, 1) . substr(ff%fffffkffkfk#fff@kff@k#ff%#fk%fkk#fkk#k#k#fkkff@fk%%fkfkfkk#f@k#ffffff%k#k%fkkff@kffffff@ffffk#%ffff, 6)
	%f@f@fkfff@fkffffffkff@fkf@%%kffkfkkff@kfkff@f@k#%%f@f@kfkffkffkffkk#ffkf% = % strlen(ffk%fkf@f@fkfkk#k#k#fk%%f@kffkk#ffkffkfff@fkkffk%%fkfkkfk#kfkff@ff%fk%fkkfk#f@f@f@kff@%k#kfffff)
		
	k%fkffkfk#fkk#f@fkfk%fk%f@fkf@f@k#fkf@f@fff@fkfk%k#f@%k#fffkffk#k#k#k#%kf%kffkfkkff@kfkff@f@k#%f%f@f@k#fffkk#fkkffkfkfkff%fkfffff@ = 
	;reverse the hex string
	loop, % strlen(f%fkfkk#ffkfffk#fkffkf%k%k#fffkf@kff@kfkfffkfkfkf%#%fkkfk#f@f@f@kff@%f%kff@fffkfffffkk#kf%%fkfffffffffkf@fkffkffkff%k#kfffff) 
		k#%fff@k#f@f@ffffffk#fk%fkk#f%kfk#k#fkfkfkf@ffk#%fkf%fffffkfff@k#f@fkfkf@k#%ffkff%fkfkk#ffkfffk#fkffkf%ff@ = % substr(ff%kffffkfkffk#fffk%k#%f@kffkk#kffkkff@ff%%f@fkk#fkk#f@fffffkfff@ff%k#k%f@fkkfkfkfkffkf@kf%fffff, a_index, 1) . %fff@f@f@k#k#k#ff%%kff@f@f@k#f@fkkf%%f@fkf@k#f@fkfkffk#kfff%
	
	ffk#%fffkffkfkfkfk#ffk#fkfk%%kff@fkkff@f@f@%k%k#k#fffkfff@f@kf%k#kfffff = % k#f%kffkkfffkff@fkffffk#kf%kk#%k#fffkkffkfffkf@f@f@%f%f@k#f@k#k#k#k#fkfkf@kffk%%fkkffkfkf@kfk#f@f@k#ffk#%kff%kff@ffk#kffkffk#k#fk%fkfffff@
	%kff@f@f@k#f@fkkf%%fff@k#f@f@ffffffk#fk%%f@k#f@f@ffffk#kfff% = 
	f@f@%k#fkkffkfffkk#f@f@f@%f%kfkfk#k#kfffkfkfk#fffkfk%k%fffffkfff@k#f@fkfkf@k#%k#f%kff@fffkfffffkk#kf%ff%f@fkf@f@k#fkf@f@fff@fkfk%@fkfkf@ = 1
	;convert from hexidecimal to binary	
	while true
	{
		if (f@f@%f@fkf@kfk#k#fff@k#k#ffk#%ffkk%ffk#fkfffff@fkk#kf%#fff@%f@f@k#k#fkkfk#k#k#%kfkf@ >f%f@f@fkf@k#kfkff@%f%fkk#k#f@kfk#k#kfk#fkfk%ff@f%fffffffff@k#kff@ffk#fk%@fffffff@)
			break
			
		f%kfffk#fkfff@fff@ff%fk%ffkff@f@fffkfff@kfk#k#kf%fkk#%f@k#fkk#k#fkf@fffk%kffffff@ = % substr(ff%kfk#fkfffffffffk%%kfk#fkfffkfkfff@f@%%f@fffkfkkff@k#fffkkf%#fkk#kfffff, %k#fkkff@ffkfk#kfkff@kffkkf%%kfffkfkfk#ffkfk#fkf@k#f@%%kfffkfffkffkfk%, 1)
		;find it in hexdigits and convert to decimal number
		%f@k#k#k#kfk#fffff@fkfk%kfk%k#f@f@fkfkkffkkf%f%kfkffkkffkfkfk%k#%f@fkkfkfkfkffkf@kf%kff%fkfkk#k#fffkf@k#fkkfffkf%ffff@ = % instr(ffff%fkffffkfk#fffkffk#k#k#%f@fff@%fkfkk#ffkfffk#fkffkf%@ff%f@fkkfkfkfkffkf@kf%ffff, %f@fkkfkfkfkffkf@kf%%f@ffkffff@fffffkkff@%%fkk#fkffk#f@kffkf@f@f@f@fkk#%) - 1
		
		f@fk%fkf@f@k#ffk#fkk#ffk#f@k#%kk%kffkkfffkff@fkffffk#kf%%k#fkkffkfffkk#f@f@f@%k%fkfkkfkfkffkf@ffk#f@kf%ff@fkffkf = % substr(ff%f@fkf@f@k#fkf@f@fff@fkfk%k%k#kffffkffk#fffff@ff%%k#fff@ffk#f@ffkff@%fkk#kfffff, %f@fff@fkkfkffkf@%%fkffk#k#fkkffkffk#ffkf%%f@fff@fkkfkffkf@% + 1, 1)
		;find it in hexdigits and convert to decimal number
		f%kfk#f@fffffffkfkkffkk#%@fkf%ffk#fkf@kff@f@fkffkfffk#%kfk%ffkff@kfk#f@fkffk#ff%%kfkfk#k#kfffkfkfk#fffkfk%f@fkffkf = % instr(fffff@%fkfkfkkffkf@ffkfk#k#fk%ff@%kfk#fkfffkfkfff@f@%f@ff%fkf@k#ffkff@f@k#ffkf%ffff, f@f%fkffkff@f@ffk#f@kffffk%kfk%fkffffkfk#fffkffk#k#k#%k%f@fffkkffkfff@fkk#ff%kff%ffkfkfffffffkffk%fkffkf) - 1
		
		;unshift the hex
		%fkfkkfk#kfkff@ff%%f@fffkfkkff@k#fffkkf%%ffkfk#fkfkfkk#k#fkf@kfkf% := %kff@fffkfffffkk#kf%%fkfkk#fkkfkffkkf%%fkffk#fkfkfff@kfkffkfk%(%fkk#fkffk#f@kffkf@f@f@f@fkk#%%kffkkff@fkk#f@f@kfkf%%f@f@k#k#ffkff@fffkffk#fk%)
		f@f%f@fffkk#ffk#fffk%fkk%f@f@k#fkfkkffffkfff@f@%%f@kfk#k#f@k#kff@fffkfk%fkff%k#k#f@k#fffkfffkfkff%@fkffkf := %kfk#fkf@ffk#ff%kf@%f@k#k#ffk#kffkff%fff%k#kffkffkfk#fk%@k%fkffffkfk#fffkffk#k#k#%#k#(f@fk%k#fkkffkfffkk#f@f@f@%kk%kfk#fkf@ffk#ff%k%fkfffff@fkfkk#k#kfk#k#%%kfk#fkk#f@k#f@kffkk#%ff@fkffkf)
		
		ffff%fffkf@k#f@kfff%k%fff@fkk#f@k#f@ffk#fffk%#f%fkf@f@fkfkk#k#k#fk%%k#fff@fkfkfkffkfffk#%f%ffffk#kffkfffkk#%kfkfk#fkfk = % fkfk%k#f@f@ffkff@k#k#ffk#f@ff%kk%fff@kfffk#fffkfkkf%#%fkk#fkk#k#k#fkkff@fk%kffffff@ * 16 + f@f%kfk#fkfffffffffk%fk%fff@k#f@f@ffffffk#fk%kfk%f@k#fkk#k#fkf@fffk%ff@%fff@fkk#f@k#f@ffk#fffk%fkffkf
		%f@f@fkk#f@ffk#kf%k%fkfffff@fkfkk#k#kfk#k#%#fk%kfk#fkfffffffffk%#f@fkfffkfffff@ .= chr(ffff%k#k#fffffkfkkffk%k#%f@f@k#k#fkkfk#k#k#%ff@%kffffkfkk#fkfffff@f@%f%kfk#fkfffkfkfff@f@%kfk#fkfk)
		
		f%fffffffff@k#kff@ffk#fk%%f@fkkfk#kfk#f@k#k#fkfffk%@f%f@f@fff@k#fkfkffk#fkf@fk%%f@f@fkf@k#kfkff@%ffkk#fff@fkfkf@ += 2		
	}
		
	k#fk%kfffk#fkfff@fff@ff%#f@fk%fffkffkfkfkfk#ffk#fkfk%fffkf%f@fkkfk#kfk#f@k#k#fkfffk%ffff@ = % %f@fkf@f@k#fkf@f@fff@fkfk%%f@k#f@ffk#k#kfffk#%%ffkff@f@kfk#%(k#fkk#%kff@ffk#kffkffk#k#fk%f@fkf%kfkfk#k#kfffkfkfk#fffkfk%fkfff%fff@kfffk#fffkfkkf%ff@)
		
	return, k#%f@f@fkk#f@ffk#kf%%f@f@k#fkfkkffffkfff@f@%fk%fkf@fff@fkk#fff@ffffk#f@%k#f@f%kfk#fkfffffffffk%fffkfffff@	
}


;FUNCTION ORIGINAL NAME: decode_hexshiftkeys
kff@f@fkf@fffk(kffffkfkfff@kf) { 
	global
;$OBFUSCATOR: $DEFGLOBVARS: decodekey, ishexchar, useshiftkey
	
	;these have '1's in them
	f%k#f@f@fkfkkffkkf%f%fkfkk#ffkfffk#fkffkf%%fffkffkffkfkkfffffkffff@%kk#%k#fkkffkfffkk#f@f@f@%%fkf@f@fkfkk#k#k#fk%kf@ffk#ff := "fff@kkf1ffkfkfkfff#k1fk@kf#@fffk@#kk"
	%fffkk#fkf@kff@%%kfk#fkfffkfkfff@f@%%fkk#k#f@kfk#k#kfk#fkfk% := "fff@f1ff@kffkk#f1fffffkf"
	
	;grab randomly created encrypt key
	;i hid it in the obfuscated literal string, 2 characters in
	%f@k#f@f@ffffk#kfff%%fffkk#fkf@ffk#ff%%k#k#kfffk#k#fkfffffkk#%%k#f@f@fkfkkffkkf%%k#kfffffk#f@fff@%%ffkffkf@fkffkff@fff@f@k#%1 = % substr(kfff%f@fffkkffkfff@fkk#ff%%fkfkk#k#fffkf@k#fkkfffkf%kf%fkk#k#f@kfk#k#kfk#fkfk%kfff@kf, 2, 1)
	%fkfffkkfkffkkff@f@%%fffkk#fkf@ffk#ff%%kfk#k#ffkffkfkf@kfff%%ffffkfkff@kfkff@f@ff%%k#kfffffk#f@fff@%%fff@f@f@k#k#k#ff%2 = % substr(%kffffkfkffk#fffk%kf%f@fkkfk#kfk#f@k#k#fkfffk%%f@fkf@kfk#k#fff@k#k#ffk#%ff%f@fff@fkkfkffkf@%kf%kfkffkkffkf@fkffffkf%fff@kf, 3, 1)
	%ffkff@f@fffkfff@kfk#k#kf%%fffkk#fkf@ffk#ff%%ffk#fkfffkffkfk#f@k#f@kf%%fkf@k#ffkff@f@k#ffkf%%k#kfffffk#f@fff@%%fkf@fff@fkk#fff@ffffk#f@%3 = % substr(k%f@k#k#k#kfk#fffff@fkfk%ff%f@fkf@f@k#fkf@f@fff@fkfk%%f@fkkfk#kfk#f@k#k#fkfffk%%k#fffkffk#k#k#k#%kfkfff@kf, 4, 1)
	%fffkffkfkfkfk#ffk#fkfk%%fffkk#fkf@ffk#ff%%f@ffkffff@fffffkkff@%%k#kfffffk#f@fff@%%kfk#fkk#f@k#f@kffkk#%%kfk#fkfffkfkfff@f@%4 = % substr(kf%kfkff@f@kffkk#ffk#%%f@k#f@ffk#k#kfffk#%ff%f@fffkfkkff@k#fffkkf%kf%fff@f@f@k#k#k#ff%kfff@kf, 5, 1)
	
	;covert key values to actual numbers
	loop, 4
		%k#fffkf@kff@kfkfffkfkfkf%%fffkk#fkf@ffk#ff%%kffff@fff@f@f@f@kfkfk#%%a_index% = % instr(%ffffkff@f@f@kfkfkff@%%k#fffff@f@k#%%kfk#fkk#f@k#f@kffkk#%, %fkf@f@fkfkk#k#k#fk%%fffkk#fkf@ffk#ff%%ffk#fkfffkffkfk#f@k#f@kf%%f@kfkffff@fffk%%k#kfffffk#f@fff@%%fff@f@f@k#k#k#ff%%a_index%) - 1
			
	ff%f@f@kfkffkffkffkk#ffkf%k#f@%fffkffkfkfkfk#ffk#fkfk%%kfkffkkffkfkfk%ffffkffk# = 0
}	


;FUNCTION ORIGINAL NAME: decode_shifthexdigit
fkf@fff@k#k#(kfffk#k#fff@fffk) { 
	global
	
	;each time i enter this routine i will use the next key value
	;to shift the hexvalue
	%f@f@k#fffkk#fkkffkfkfkff%%k#fffkkffkfffkf@f@f@%%f@fkf@ffkffk%++
	if (%kfkfk#k#kfffkfkfk#fffkfk%%f@f@fkf@k#kfkff@%k#f%k#k#fffffkfkkffk%@%ffkff@f@fffkfff@kfk#k#kf%kff%fkffk#f@f@kff@fkk#%ffkffk# > 4)
		ffk#%f@kffkk#kffkkff@ff%%k#fff@kff@kffffkff%%f@k#fkk#k#fkf@fffk%%k#k#kfffk#k#fkfffffkk#%@kffffkffk# = 1	
	
	;subtract the shift key from the hexvalue 
	kff%fkfkkfkfkffkf@ffk#f@kf%fk%k#k#fkk#f@f@k#k#ff%%kffffkfkffk#fffk%k#ff%k#fffkkffkfffkf@f@f@%f@fffk -= %f@f@f@k#f@kfk#fkfk%%fffkk#fkf@ffk#ff%%k#fffkfkfffkfkk#%%ffffkfkff@kfkff@f@ff%%f@k#fkk#k#fkf@fffk%%ffk#f@kffffkffk#%
	
	;if i go under zero, just add 16
	if (%k#k#fffkfff@f@kf%%f@k#fkk#kfk#f@fkk#f@fkf@fk%%ffffkfkff@kfkff@f@ff% < 0) 
		kf%kfkffkfkkfffk#fff@k#f@kf%ffk%fkf@k#f@k#f@k#fffff@%k%kffffkk#f@ffffffkfffkf%f%k#ffkfffk#f@kff@k#%ff@%f@f@kfkffkffkffkk#ffkf%fffk += 16
		
	return k%k#f@f@ffkff@k#k#ffk#f@ff%f%f@f@k#k#fkkfk#k#k#%k%ffkff@f@fffkfff@kfk#k#kf%#k%f@k#k#ffk#kffkff%#fff@fffk	
}


;FUNCTION ORIGINAL NAME: fixescapes
ffkffkf@f@f@(fkkff@f@kfkffkfk) { 
	global
	
	StringReplace, fkk%ffkffkf@f@f@fkf@kffk%f@%k#k#fffkfff@f@kf%f@%fkk#k#f@kfk#k#kfk#fkfk%kfkffkfk, f%kffffkfkk#fkfffff@f@%%f@fkk#fkk#f@fffffkfff@ff%%kffffkfffffkfkf@%%kffkkff@fkk#f@f@kfkf%ff@f@kfkffkfk, % "````", % "``", all
	StringReplace, %k#fff@kfkff@fkkfkffk%fkk%fkkffkfkf@kfk#f@f@k#ffk#%f@f%f@f@k#fffkk#fkkffkfkfkff%@k%f@ffffk#fkfffk%f%f@fkk#fkk#f@fffffkfff@ff%ffkfk, %f@fff@fkkfkffkf@%%k#k#fffffkfkkffk%%f@kffffkkff@kfk#fff@f@fk%, % "``n", % "`n", all
	StringReplace, fkk%f@k#f@ffk#k#kfffk#%f%k#fkkffkfffkk#f@f@f@%%fffkffkffkfkkfffffkffff@%@f@%f@fkkfk#kfk#f@k#k#fkfffk%kfkffkfk, fkk%f@kffff@kffffffffkk#f@k#%f%ffkffkf@f@f@fkf@kffk%@f@%f@fkk#fkk#f@fffffkfff@ff%fk%k#fff@k#fkfffffkk#fk%ffk%k#kffkffkfk#fk%fk, % "``r", % "`r", all
	StringReplace, fkk%k#fkkffkfffkk#f@f@f@%f@%fkf@f@k#ffk#fkk#ffk#f@k#%@k%fffkk#fkfkk#fffkfffkk#fk%fkf%kff@fffkfffffkk#kf%f%k#kffkffkfk#fk%kfk, fkkf%f@k#fkk#k#fkf@fffk%f%fff@fkk#f@k#f@ffk#fffk%@f@%f@f@f@k#f@kfk#fkfk%kf%kffffkfkk#fkfffff@f@%ffkfk, % "``,", % "`,", all
	StringReplace, fk%fkfkkfk#kfkff@ff%kf%f@kffkk#kffkkff@ff%%f@fffffff@k#ffk#fkfkk#k#%%fkfffff@fkfkk#k#kfk#k#%f%f@f@fkk#f@ffk#kf%@kfkffkfk, f%kfk#fffkf@f@f@kfk#%kf%kfk#fkfffkfkfff@f@%%fkkffkfkf@kfk#f@f@k#ffk#%@f@%fkfffff@fkfkk#k#kfk#k#%kfk%f@k#f@f@ffffk#kfff%ffkfk, % "``%", % "`%", all	
	StringReplace, fkkf%fffkffkffkfkkfffffkffff@%f%kfk#k#ffkffkfkf@kfff%@f%ffkfkfffffffkffk%kfkffkfk, fk%ffk#fkf@kff@f@fkffkfffk#%f%fkffffkfk#fffkffk#k#k#%f@f@%kfk#fffkf@f@f@kfk#%%fff@fkk#f@k#f@ffk#fffk%fkffkfk, % "``;", % "`;", all	
	StringReplace, %f@fffkfkkff@k#fffkkf%fkk%kffffkfffffkfkf@%ff@f%kff@ffk#kffkffk#k#fk%@kfk%f@f@fkf@k#kfkff@%fkfk, fk%ffk#fkf@kff@f@fkffkfffk#%%k#fkkffkfffkk#f@f@f@%f%f@f@fkk#f@ffk#kf%@f@%k#k#ffkfkff@fkf@fff@fk%k%ffkff@kfk#f@fkffk#ff%fkffkfk, % "``t", % "`t", all
	StringReplace, fkkf%kfk#fkf@ffk#ff%@f@k%k#fff@fkfkfkffkfffk#%%f@f@kfkffkffkffkk#ffkf%kf%f@k#fkk#k#fkf@fffk%fkfk, f%kffkkff@fkk#f@f@kfkf%k%kfkffkkffkfkfk%f%kff@ffk#kffkffk#k#fk%f@f@%fkfkkfk#kfkff@ff%kfkffkfk, % "``b", % "`b", all
	StringReplace, %kffff@fff@f@f@f@kfkfk#%%f@fkkffkk#fkf@f@kffkffk#ff%%fffffkfff@k#f@fkfkf@k#%, fk%kffkfkkff@kfkff@f@k#%k%kffffkfffffkfkf@%f%k#fff@fkfkfkffkfffk#%@f%fffkf@k#f@kfff%@kf%kfk#fkfffffffffk%ffkfk, % "``v", % "`v", all
	StringReplace, fk%k#k#kffkfff@fkfkkf%k%f@f@k#k#fkkfk#k#k#%%kffffffkkff@fkk#k#fk%f@f@kfkffkfk, f%ffkff@f@fffkfff@kfk#k#kf%%kfkffkkffkf@fkffffkf%kff%ffffk#kffkfffkk#%f@%f@ffkffff@fffffkkff@%kfkffkfk, % "``a", % "`a", all
	
	StringReplace, fkkf%f@fkkfkfkfkffkf@kf%%fkkfk#f@f@f@kff@%f@f@%fff@kfffk#fffkfkkf%%f@fkf@ffk#fkkf%fkffkfk, fk%kfffk#fkfff@fff@ff%ff%f@fkfkk#k#k#k#k#k#fk%f@k%f@k#fkk#k#fkf@fffk%fk%k#k#kfffk#k#fkfffffkk#%ffkfk, % """""", % """", all
	
	return %k#fffkfkfffkfkk#%f%f@fffkk#ffk#fffk%k%fkkffkfkf@kfk#f@f@k#ffk#%f@%fffffffff@k#kff@ffk#fk%f@%k#kffffkffk#fffff@ff%kfkffkfk
}

