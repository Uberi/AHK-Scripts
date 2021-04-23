;Creator: Eedis
;Email: Eedis@gmx.us

;;;;;;;;;;;;;;
;Auto Execute;
;;;;;;;;;;;;;;
setbatchlines, -1
settimer, time, 1000
mpos=Bottom-Right
yy=%A_ScreenHeight%
yy-=73
xx=%A_Screenwidth%
xx-=120

;;;;;;;;;;;;;;;;
;Gui/Menu build;
;;;;;;;;;;;;;;;;
menu, tray, NoStandard
menu, Possub, Add, Top-Left, tleft
menu, Possub, Add, Top-Right, tright
menu, Possub, Add, Bottom-Left, bleft
menu, Possub, Add, Bottom-Right, bright
menu, Possub, check, Bottom-Right

menu, tray, add, Set position, :Possub
menu, tray, add, About, About
menu, tray, add
menu, tray, add, Exit, Exit

Gui, 2:Color, FF8040
Gui, 2:Font, S11 CGreen, Papyrus
Gui, 2:Add, Button, gokay x132 y320 w100 h30 , Okay
Gui, 2:Add, Text, x14 y75 w340 h240 , A Binary Clock is simply a clock that tells you what time it is in binary. The dots on the far left represents the hour`, then the minutes`, then the seconds. A solid dot means 1`, and hollow dot means 0.`n`nAuthor: Eedis`nEmail: Eedis@gmx.us`nWebsite: http://www.autohotkey.net/~Eedis`nLanguage: AutoHotKey`nVersion: 1.0
Gui, 2:Font, S24 CGreen Bold Underline, Papyrus
Gui, 2:Add, Text, x77 y10 w210 h50 , Binary Clock

Gui, Color, FF8040
gui, -border toolwindow AlwaysOnTop
Gui, Add, Picture, vh16 x5 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vh8 x20 y5 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vh4 x20 y20 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vh2 x20 y35 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vh1 x20 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, x35 y5 w3 h55 , %A_ProgramFiles%\Binary Clock\sep.bmp
Gui, Add, Picture, vm32 x45 y35 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vm16 x45 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vm8 x60 y5 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vm4 x60 y20 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vm2 x60 y35 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vm1 x60 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, x75 y5 w3 h55 , %A_ProgramFiles%\Binary Clock\sep.bmp
Gui, Add, Picture, vs32 x85 y35 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vs16 x85 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vs8 x100 y5 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vs4 x100 y20 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vs2 x100 y35 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Add, Picture, vs1 x100 y50 w10 h10 , %A_ProgramFiles%\Binary Clock\0.bmp
Gui, Show, x%xx% y%yy% w115 h65, Binary Clock
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Set position labels/functions;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tleft:
gui, hide
Gui, Show, x0 y0 w115 h65, Binary Clock
menu, Possub, togglecheck, Top-Left
menu, Possub, togglecheck, %mpos%
mpos=Top-Left
Return

tright:
gui, hide
Gui, Show, x%xx% y0 w115 h65, Binary Clock
menu, Possub, togglecheck, Top-Right
menu, Possub, togglecheck, %mpos%
mpos=Top-Right
Return

bleft:
gui, hide
Gui, Show, x0 y%yy% w115 h65, Binary Clock
menu, Possub, togglecheck, Bottom-Left
menu, Possub, togglecheck, %mpos%
mpos=Bottom-Left
Return

bright:
gui, hide
Gui, Show, x%xx% y%yy% w115 h65, Binary Clock
menu, Possub, togglecheck, Bottom-Right
menu, Possub, togglecheck, %mpos%
mpos=Bottom-Right
Return

;;;;;;;;;;;;;;
;About window;
;;;;;;;;;;;;;;
about:
Gui, 2:Show, w360 h355, About Binary Clock
Return

okay:
gui, 2:hide
Return

;;;;;;;;;;;;;;;;;;;;
;Runs the functions;
;;;;;;;;;;;;;;;;;;;;
time:
BinConvrt(A_sec)
sec=%num%
BinConvrt(A_min)
min=%num%
BinConvrt(A_hour)
hour=%num%
UpdateClock(hour, min, sec)
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function to update clock GUI;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateClock(hour, min, sec)
{
	global
	bit=256
	loop, parse, sec
		{
			bit/=2
			guicontrol,, s%bit%, %A_ProgramFiles%\Binary Clock\%A_loopfield%.bmp
		}
	bit=256
	loop, parse, min
		{
			bit/=2
			guicontrol,, m%bit%, %A_ProgramFiles%\Binary Clock\%A_loopfield%.bmp
		}
	bit=256
	loop, parse, hour
		{
			bit/=2
			guicontrol,, h%bit%, %A_ProgramFiles%\Binary Clock\%A_loopfield%.bmp
		}
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function to convert number to binary where 'cn' is the number;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BinConvrt(cn)
{
global
Num=
Bit=256
Loop 8
{
	Bit/=2
	cn2=%Cn%
	cn2/=%bit%
	if (cn2 < 1)
		num=%num%0
	Else
		{
			num=%num%1
			cn-=%bit%
		}
}	
}
Return

;;;;;;;;;;;
;Exits App;
;;;;;;;;;;;
exit:
GuiClose:
2guiclose:
ExitApp