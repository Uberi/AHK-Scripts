; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.


SetTitleMatchMode, 2
TagInfoFound = false
FreeDBFound = false
SetTimer, ProcessOnWindowText, 1000


ProcessOnWindowText:
IfWinExist, Tag-Information bearbeiten
{
  WinMove, Tag-Information bearbeiten, , 400, 300, 400, 600,
  ControlGet, EditInfo, hwnd, , Edit2,Tag-Information bearbeiten
  WinMove, ahk_id %EditInfo%, , 10, 65, 360, 500,

  ControlGet, BtnInfo, hwnd, , Button1,Tag-Information bearbeiten
  WinMove, ahk_id %BtnInfo%, , 330, 5, 60, 20,

  ControlGet, BtnInfo, hwnd, , Button2,Tag-Information bearbeiten
  WinMove, ahk_id %BtnInfo%, , 330, 30, 60, 20,
}


^f11:: ;leiser
IfWinNotExist, Winamp,   ; Adjust this if your Winamp is not 2.x
{
	return
}
ControlSend, ahk_parent, {down 5} ;leiser
return

^f12:: ;lauter
IfWinNotExist, Winamp,
{
	return
}
ControlSend, ahk_parent, {up 5} ;lauter
return


+f12::
IfWinNotExist, Winamp,   ; Adjust this if your Winamp is not 2.x
{
	IfWinNotExist, Player Window,   ; Adjust this if your Winamp is not 2.x
	{
		return
	}
}
ControlSend, ahk_parent, v ;stop
return

f12::
IfWinNotExist, Winamp,   ; Adjust this if your Winamp is not 2.x
{
	return
}
ControlSend, ahk_parent, c ;pause
return

f11::
IfWinNotExist, Winamp,   ; Adjust this if your Winamp is not 2.x
{
	return
}
ControlSend, ahk_parent, x ;play
sleep, 300

return

f10::
IfWinNotExist, PaceMaker 2.1,   ; Adjust this if your Winamp is not 2.x
{
	return
}
ControlSend, msctls_trackbar321, {RIGHT 5}, ;schneller
return

f9::
IfWinNotExist, PaceMaker 2.1,   ; Adjust this if your Winamp is not 2.x
{
	return
}
ControlSend, msctls_trackbar321, {LEFT 5}, ;langsamer
return

+f9::
IfWinNotExist, PaceMaker 2.1,
{
	return
}
ControlSend, msctls_trackbar321, {HOME}, ;langsamer
return

^f7:: ;5 sekunden vorher
IfWinNotExist, Winamp,
{
	return
}
ControlSend, ahk_parent, {left} ;- 5 Sekunden
return

^f8:: ;5 sekunden nachher
IfWinNotExist, Winamp,
{
	return
}
ControlSend, ahk_parent, {right} ;+ 5 Sekunden
return

;WinWait, Player Window,
;IfWinNotActive, Player Window, , WinActivate, Player Window,
;WinWaitActive, Player Window,


return
