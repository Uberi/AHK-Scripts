InputBox, newjumplist, NEW JUMPLIST,`r`n GIVE NAME FOR NEW EMPTY JUMPLIST`r`n`r`n OR PRESS OK TO COPY CURRENT JUMPLIST,,,,,,,, COPY
if ErrorLevel
	Exitapp
if newjumplist = COPY
	goto copy
else
	goto new
return


copy:
InputBox, newjumplist, JUMPLIST COPIED..,`r`n RENAME COPIED JUMPLIST,,,,,,,, COPY
if ErrorLevel
	Exitapp
else
run robocopy .\ ..\%newjumplist% *.* /E,, hide
goto properties
return

new:
run robocopy .\ ..\%newjumplist% Jumplistlauncher.exe jumpman.ahk,, hide
goto properties
return

properties:
sleep 500
run explorer /select`,..\%newjumplist%\jumplistlauncher.exe,,max
winwaitactive %newjumplist%
send +{f10}s
sleep 500
send {F2}EDIT %newjumplist%{Enter}
send !{enter}
winwaitactive EDIT %newjumplist% Properties
send !C
winwait Change Icon
send imageres.dll{Enter}
WinWaitClose Change Icon
send {TAB 2}{Enter}
send +{f10}k
sleep 500
winclose %newjumplist%
run ..\%newjumplist%\EDIT %newjumplist%.lnk
return