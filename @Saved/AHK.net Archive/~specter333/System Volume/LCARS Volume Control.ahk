; colors tan - ffcc66   red - c45b58   orange - fe9d00

#NoEnv 
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#SingleInstance Force

Menu, Tray, Icon, Star_Trek.ico

Gui,+LastFound -border +ToolWindow -Caption
SetBatchLines, -1
Gui, Color , Black, Black
Gui, Add, Pic, x0 y0 w600 h400, bg.png
Gui, Add, Pic, x558 y5 w40 h43 vex gExit, ex.png

Gui, Font, s20 cBlack, LCARS
Gui, Add, Text, x575 y10 BackgroundTrans gReload, X

Gui, Font, s12 cBlack, LCARS
Gui, Add, Slider, x89 y35 w70 h10 -Theme NoTicks Thick10 AltSubmit Center Range-100-100 vPan1 gPan1, 0
Gui, Add, Slider, x189 y35 w70 h10 -Theme NoTicks Thick10 AltSubmit Center Range-100-100 vPan2 gPan2, 0
Gui, Add, Slider, x289 y35 w70 h10 -Theme NoTicks Thick10 AltSubmit Center Range-100-100 vPan3 gPan3, 0
Gui, Add, Slider, x389 y35 w70 h10 -Theme NoTicks Thick10 AltSubmit Center Range-100-100 vPan4 gPan4, 0
Gui, Add, Slider, x489 y35 w70 h10 -Theme NoTicks Thick10 AltSubmit Center Range-100-100 vPan5 gPan5, 0

Gui, Add, Slider, x110 y50 w25 h300 -Theme NoTicks Thick25 Vertical Invert AltSubmit Center vsystemvol gsystemvol, 0
Gui, Add, Progress, x89 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg1, 
Gui, Add, Progress, x138 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg2, 
Gui, Add, Pic, x100 y50 w22 h5 vblank1, blank.png
Gui, Add, Pic, x100 y345 w22 h5 vblank2, blank.png

Gui, Add, Slider, x210 y50 w25 h300 -Theme NoTicks Thick25 Vertical Invert AltSubmit Center vsetwavvol gwavvol, 0
Gui, Add, Progress, x189 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg3, 
Gui, Add, Progress, x238 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg4, 
Gui, Add, Pic, x200 y50 w22 h5 vblank3, blank.png
Gui, Add, Pic, x200 y345 w22 h5 vblank4, blank.png

Gui, Add, Slider, x310 y50 w25 h300 -Theme NoTicks Thick25 Vertical Invert AltSubmit Center vs3 gs3, 0
Gui, Add, Progress, x289 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg5, 
Gui, Add, Progress, x338 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg6, 
Gui, Add, Pic, x300 y50 w22 h5 vblank5, blank.png
Gui, Add, Pic, x300 y345 w22 h5 vblank6, blank.png

Gui, Add, Slider, x410 y50 w25 h300 -Theme NoTicks Thick25 Vertical Invert AltSubmit Center vs4 gs4, 0
Gui, Add, Progress, x389 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg7, 
Gui, Add, Progress, x438 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg8, 
Gui, Add, Pic, x400 y50 w22 h5 vblank7, blank.png
Gui, Add, Pic, x400 y345 w22 h5 vblank8, blank.png

Gui, Add, Slider, x510 y50 w25 h300 -Theme NoTicks Thick25 Vertical Invert AltSubmit Center vs5 gs5, 0
Gui, Add, Progress, x489 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg9, 
Gui, Add, Progress, x538 y56 w20 h285 cfe9d00 BackgroundBlack Vertical vSysProg10, 
Gui, Add, Pic, x500 y50 w22 h5 vblank9, blank.png
Gui, Add, Pic, x500 y345 w22 h5 vblank10, blank.png

Gui, Font, s21 cBlue, LCARS
Gui, Add, Pic, x85 y350 w44 h20 vch1button gch1, b1.png
Gui, Add, Text, x122 y345 Right vtch1 gch1, 000
Gui, Add, Pic, x150 y350 w10 h20 vch1cap gch1, b2.png
Gui, Font, s16 cBlack, LCARS
Gui, Add, Text, x91 y349 Right r1 BackgroundTrans, MAIN

Gui, Font, s21 cBlue, LCARS
Gui, Add, Pic, x185 y350 w44 h20 vch2button gch2, b1.png
Gui, Add, Text, x222 y345 Right vtch2 gch2, 000
Gui, Add, Pic, x250 y350 w10 h20 vch2cap gch2, b2.png
Gui, Font, s16 cBlack, LCARS
Gui, Add, Text, x191 y349 Right r1 BackgroundTrans, WAVE

Gui, Font, s21 cBlue, LCARS
Gui, Add, Pic, x285 y350 w44 h20 vch3button gch3, b1.png
Gui, Add, Text, x322 y345 Right vtch3 gch3, 000
Gui, Add, Pic, x350 y350 w10 h20 vch3cap gch3, b2.png
Gui, Font, s16 cBlack, LCARS
Gui, Add, Text, x291 y349 Right r1 BackgroundTrans, LINE

Gui, Font, s21 cBlue, LCARS
Gui, Add, Pic, x385 y350 w44 h20 vch4button gch4, b1.png
Gui, Add, Text, x422 y345 Right vtch4 gch4, 000
Gui, Add, Pic, x450 y350 w10 h20 vch4cap gch4, b2.png
Gui, Font, s16 cBlack, LCARS
Gui, Add, Text, x391 y349 Right r1 BackgroundTrans, MIC

Gui, Font, s21 cBlue, LCARS
Gui, Add, Pic, x485 y350 w44 h20 vch5button gch5, b1.png
Gui, Add, Text, x522 y345 Right vtch5 gch5, 000
Gui, Add, Pic, x550 y350 w10 h20 vch5cap gch5, b2.png
Gui, Font, s16 cBlack, LCARS
Gui, Add, Text, x491 y349 Right r1 BackgroundTrans, CD

Gui, Font, s20 cBlack, LCARS
Gui, Add, Text, x91 y10 w50 Right BackgroundTrans Hidden vmute1, MUTE
Gui, Add, Text, x191 y10 w50 Right BackgroundTrans Hidden vmute2, MUTE
Gui, Add, Text, x291 y10 w50 Right BackgroundTrans Hidden vmute3, MUTE
Gui, Add, Text, x391 y10 w50 Right BackgroundTrans Hidden vmute4, MUTE
Gui, Add, Text, x491 y10 w50 Right BackgroundTrans Hidden vmute5, MUTE

Gui, Show,  w600 h400, LCARS Volume Control  ; x250 y50
GoSub GetStats
OnMessage(0x201, "WM_LBUTTONDOWN")
GuiControl, Focus, blank1,
GuiControl, Focus, blank2,
Return
WM_LBUTTONDOWN()
	{
	PostMessage, 0xA1, 2
	} 
Return

Pan1:
Gui, Submit, NoHide
SoundSet, %Pan1%, MASTER , PAN
GuiControl, Focus, blank1,
Return

Pan2: 
Gui, Submit, NoHide
SoundSet, %Pan2%, WAVE , PAN
GuiControl, Focus, blank1,
Return

Pan3:
Gui, Submit, NoHide
SoundSet, %Pan3%, LINE , PAN
GuiControl, Focus, blank1,
Return

Pan4:
Gui, Submit, NoHide
SoundSet, %Pan4%, MICROPHONE , PAN
GuiControl, Focus, blank1,
Return

Pan5:
Gui, Submit, NoHide
SoundSet, %Pan5%, CD , PAN
GuiControl, Focus, blank1,
Return

systemvol:
Gui, Submit, NoHide
GuiControl,, SysProg1, %systemvol%
GuiControl,, SysProg2, %systemvol%
GuiControl,, tch1, %systemvol%
GuiControl, Focus, blank1,
SoundSet, %systemvol%, MASTER , VOLUME
Return

wavvol:
Gui, Submit, NoHide
GuiControl,, SysProg3, %setwavvol%
GuiControl,, SysProg4, %setwavvol%
GuiControl,, tch2, %setwavvol%
GuiControl, Focus, blank3,
SoundSet, %setwavvol%, WAVE , VOLUME
Return

s3:
Gui, Submit, NoHide
GuiControl,, SysProg5, %s3%
GuiControl,, SysProg6, %s3%
GuiControl,, tch3, %s3%
GuiControl, Focus, blank5,
SoundSet, %s3%, LINE, VOLUME
Return

s4:
Gui, Submit, NoHide
GuiControl,, SysProg7, %s4%
GuiControl,, SysProg8, %s4%
GuiControl,, tch4, %s4%
GuiControl, Focus, blank7,
SoundSet, %s4%, MICROPHONE, VOLUME
Return

s5:
Gui, Submit, NoHide
GuiControl,, SysProg9, %s5%
GuiControl,, SysProg10, %s5%
GuiControl,, tch5, %s5%
GuiControl, Focus, blank9,
SoundSet, %s5%, CD, VOLUME
Return

ch1:
Gui, Submit, NoHide
SoundGet, ch1mute, MASTER , MUTE
If ch1mute = on
	GoTo ch1b
GuiControl, , ch1button, button red.png
GuiControl, , ch1cap, cap red.png
GuiControl, Show, mute1,
SoundSet, 1, MASTER , MUTE
Return

ch1b:
SoundGet, ch1vol, MASTER , 
GuiControl, , ch1button, b1.png
GuiControl, , ch1cap, b2.png
GuiControl, Hide, mute1,
SoundSet, 0, MASTER , MUTE
Return

ch2:
Gui, Submit, NoHide
SoundGet, ch2mute, WAVE , MUTE
If ch2mute = on
	GoTo ch2b
GuiControl, , ch2button, button red.png
GuiControl, , ch2cap, cap red.png
GuiControl, Show, mute2,
SoundSet, 1, WAVE , MUTE
Return

ch2b:
SoundGet, ch2vol, WAVE , 
GuiControl, , ch2button, b1.png
GuiControl, , ch2cap, b2.png
GuiControl, Hide, mute2,
SoundSet, 0, WAVE , MUTE
Return

ch3:
Gui, Submit, NoHide
SoundGet, ch3mute,  LINE, MUTE
If ch3mute = on
	GoTo ch3b
GuiControl, , ch3button, button red.png
GuiControl, , ch3cap, cap red.png
GuiControl, Show, mute3,
SoundSet, 1,  LINE, MUTE
Return

ch3b:
SoundGet, ch3vol, LINE, 
GuiControl, , ch3button, b1.png
GuiControl, , ch3cap, b2.png
GuiControl, Hide, mute3,
SoundSet, 0, LINE, MUTE
Return

ch4:
Gui, Submit, NoHide
SoundGet, ch4mute,  MICROPHONE, MUTE
If ch4mute = on
	GoTo ch4b
GuiControl, , ch4button, button red.png
GuiControl, , ch4cap, cap red.png
GuiControl, Show, mute4,
SoundSet, 1,  MICROPHONE, MUTE
Return

ch4b:
SoundGet, ch4vol, MICROPHONE, 
GuiControl, , ch4button, b1.png
GuiControl, , ch4cap, b2.png
GuiControl, Hide, mute4,
SoundSet, 0, MICROPHONE, MUTE
Return

ch5:
Gui, Submit, NoHide
SoundGet, ch5mute,  CD, MUTE
If ch5mute = on
	GoTo ch5b
GuiControl, , ch5button, button red.png
GuiControl, , ch5cap, cap red.png
GuiControl, Show, mute5,
SoundSet, 1,  CD, MUTE
Return

ch5b:
SoundGet, ch5vol, CD, VOLUME 
GuiControl, , ch5button, b1.png
GuiControl, , ch5cap, b2.png
GuiControl, Hide, mute5,
SoundSet, 0, CD, MUTE
Return

GetStats:
SoundGet, mastvol, Master, Volume
SoundGet, mastmute, Master, Mute
SoundGet, mastpan, Master, Pan
SoundGet, wavol, Wave, Volume
SoundGet, wavmute, Wave, Mute
SoundGet, wavpan, Wave, Pan
SoundGet, linevol, Line, Volume
SoundGet, linemute, Line, Mute
SoundGet, linepan, Line, Pan
SoundGet, micvol, Microphone, Volume
SoundGet, micmute, Microphone, Mute
SoundGet, micpan, Microphone, Pan
SoundGet, cdvol, CD, Volume
SoundGet, cdmute, CD, Mute
SoundGet, cdpan, CD, Pan

GuiControl,, SysProg1, %mastvol%
GuiControl,, SysProg2, %mastvol%
GuiControl,, systemvol, %mastvol%
GuiControl,, Pan1, %mastpan%
Gui, Submit, NoHide
GuiControl,, tch1, %systemvol%
If mastmute = On
	GoSub mastmuteon

GuiControl,, SysProg3, %wavol%
GuiControl,, SysProg4, %wavol%
GuiControl,, setwavvol, %wavol%
GuiControl,, Pan2, %mastpan%
Gui, Submit, NoHide
GuiControl,, tch2, %setwavvol%
If wavmute = On
	GoSub wavmuteon

GuiControl,, SysProg5, %linevol%
GuiControl,, SysProg6, %linevol%
GuiControl,, s3, %linevol%
GuiControl,, Pan3, %linepan%
Gui, Submit, NoHide
GuiControl,, tch3, %s3%
If linemute = On
	GoSub linemuteon

GuiControl,, SysProg7, %micvol%
GuiControl,, SysProg8, %micvol%
GuiControl,, s4, %micvol%
GuiControl,, Pan4, %micpan%
Gui, Submit, NoHide
GuiControl,, tch4, %s4%
If micmute = On
	GoSub micmuteon
	
GuiControl,, SysProg9, %cdvol%
GuiControl,, SysProg10, %cdvol%
GuiControl,, s5, %cdvol%
GuiControl,, Pan5, %cdpan%
Gui, Submit, NoHide
GuiControl,, tch5, %s5%
If cdmute = On
	GoSub cdmuteon	
Return

mastmuteon:
GuiControl, , ch1button, button red.png
GuiControl, , ch1cap, cap red.png
GuiControl, Show, mute1,
Return

wavmuteon:
GuiControl, , ch2button, button red.png
GuiControl, , ch2cap, cap red.png
GuiControl, Show, mute2,
Return

linemuteon:
GuiControl, , ch3button, button red.png
GuiControl, , ch3cap, cap red.png
GuiControl, Show, mute3,
Return

micmuteon:
GuiControl, , ch4button, button red.png
GuiControl, , ch4cap, cap red.png
GuiControl, Show, mute4,
Return

cdmuteon:
GuiControl, , ch5button, button red.png
GuiControl, , ch5cap, cap red.png
GuiControl, Show, mute5,
Return

Reload:
Reload
Return

Esc::
Exit:
GuiClose:
Gui, Destroy
ExitApp
