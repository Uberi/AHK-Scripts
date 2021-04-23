#SingleInstance Force
Gui, Color, Black
Gui, +LastFound
SplitPath, A_ScriptDir,  OutDir
GoSub GetList
Gui, Font, s18
Gui, Add , DDL, x5 y40 w230 r7 vsnd,  %Oldread%

Gui, Font, s18 cGray  
Gui, Add, Text, x5 y5 w210 h40 vFolder, %OutDir%
Gui, Add, Text, x215 y5 w25 h40 gExit, X

Gui, Font, s10 cWhite   
Gui, Add, Text, x75 y280 w150 vptext, Tap FX to play.
Gui, Add, Text, x75 y280 w150 Hidden vstext, Tap FX to stop.

Gui, Font, s35 c323232   
Gui, Add, Text, x50 y65, SOUND
Gui, Font, s150 c323232   
Gui, Add, Text, x5 y70 gPlay, FX

Gui, Show, x0 y0 h320 w240, Sound FX Player
Return

Play:
Gui, Submit, NoHide
If snd = 
	GoTo Stop
If snd = stop.wav
	GoTo Stop
SoundPlay,%A_ScriptDir%\%snd%
GuiControl, Choose, snd, 1
GuiControl, Hide, ptext,
GuiControl, Show, stext,
Return

Stop:
SoundPlay, %A_ScriptDir%\stop.wav
GuiControl, Choose, snd, 1
GuiControl, Show, ptext,
GuiControl, Hide, stext,
Return

GetList:
Loop, %A_ScriptDir%\*.wav
	Oldread = %Oldread%|%A_LoopFileName%
Return

Exit:
GuiClose:
SoundPlay, %A_ScriptDir%\stop.wav
Gui, Destroy
ExitApp