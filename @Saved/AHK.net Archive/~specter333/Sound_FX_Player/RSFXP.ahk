
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
;Menu, Tray, Icon, RSFXP.exe

fadetime = 50
xstats = stopped
popmsg = notyet
pagenumber:= 1
#SingleInstance, force
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows,On
Gui,+LastFound -border +ToolWindow -Caption

SetBatchLines, -1
settitlematchmode 2

soundset,0,master,mute
SoundGet, master_volume
actualvolume:= master_volume+1


FileList =
Loop, %A_ScriptDir%\*.wav,0, 0
    FileList = %FileList%%A_LoopFileName%`n

Loop, %A_ScriptDir%\*.mp3,0, 0
    FileList = %FileList%%A_LoopFileName%`n

Loop, %A_ScriptDir%\*.wma,0, 0
    FileList = %FileList%%A_LoopFileName%`n

SoundGet, master_volume
actualvolume:= master_volume+1

Gui, Font, s10, Impact
mycount = no
over60 = no
over120 = no
over180 = no

Gui, Font, cGray s14, Arial Black
Gui, Add, Text, x3 y5 Section vnowplay, Now Playing
Gui, Font, cWhite s14, Arial Black
Gui, Add, Text, xp+184 w15 Center Section gExit, X


Gui, Font, s10 cblue ,Arial
Gui, Add, GroupBox, x3 yp+20 w200 h40,
Gui, Add, Text, xp+4 yp+15 w190 Left vplaying, Click a button to start playback.

Gui, Font, s10 cWhite ,Arial
Gui, Add, GroupBox, x3 yp+40 w64 h40 Center, Elasped
Gui, Add, GroupBox, x+4 w64 h40 Center, Total
Gui, Add, GroupBox, x+4 w64 h40 Center, Remaining
Gui, Font, s12 cblue ,Arial
Gui, Add, Text, x7 yp+20 w54 Center vsongpos, 0:00
Gui, Add, Text, xp+68 w54 Center vsongtime, 0:00
Gui, Add, Text, xp+68 w54 Center vcdown, 0:00

Gui, Font, cWhite s18, Arial Black
Gui, Add, Button, x3 y150 h100 w140 vxstop gStop, Stop
Gui, Add, Slider, x170 y140 h225 Vertical Invert Center AltSubmit vVolume gVolumex, %actualvolume%
Gui, Add, Button,  x3 y257 h100 w140 vxfade gfadeout, Fade Out

Gui, Font, s10 cWhite, Arial
Gui, Add, Text, x70 y365 w100 Right, System Volume
Gui, Add, Text,  x+10 w20 Center vVolumeText,
gosub, Volumex

Gui, Add, Text, x60 y385 Right, Fade steps in ms.
Gui, Font, s10 cBlack, Arial
Gui, Add, Edit, x+5 y380 w40 Left vfadetime, 50


Sort, FileList,
Loop, parse,  FileList, `n
{
    if A_LoopField =
	Continue

    if a_index = 1
	{
	Gui, Add, Button, x225 y5 w250 R1 Left Section -Wrap gwave, %A_LoopField%
	mycount = positive
	}

    if a_index between 2 and 20
	Gui, Add, Button, u+5 w250 R1 Left -Wrap gwave , %A_LoopField%

    if a_index = 21
	    Gui, Add, Button, x485 y5 w250 R1 Left Section -Wrap gwave, %A_LoopField%


    if a_index between 22 and 40
	Gui, Add, Button, w250 R1 Left -Wrap gwave, %A_LoopField%

    if a_index = 41
	    Gui, Add, Button, x745 y5 w250 R1 Left Section -Wrap gwave, %A_LoopField%


    if a_index between 42 and 60
	Gui, Add, Button, w250 R1 Left -Wrap gwave , %A_LoopField%

    if a_index = 61
	    {
		Gui, Add, Button, x225 y5 w250 R1 Left Hidden -Wrap gwave, %A_LoopField%
	    over60 = yes
		}

	if a_index between 62 and 80
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 81
	    Gui, Add, Button, x485 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 82 and 100
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave, %A_LoopField%

    if a_index = 101
	    Gui, Add, Button, x745 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 102 and 120
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 121
	    {
		Gui, Add, Button, x225 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%
		over120 = yes
		}

	if a_index between 122 and 140
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 141
	    Gui, Add, Button, x485 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 142 and 160
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave, %A_LoopField%

    if a_index = 161
	    Gui, Add, Button, x745 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 162 and 180
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 181
	    {
		Gui, Add, Button, x225 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%
		over180 = yes
        }

	if a_index between 182 and 200
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 201
	    Gui, Add, Button, x485 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 202 and 220
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave, %A_LoopField%

    if a_index = 221
	    Gui, Add, Button, x745 y5 w250 R1 Left Section Hidden -Wrap gwave, %A_LoopField%


	if a_index between 222 and 240
	Gui, Add, Button, w250 R1 Left Hidden -Wrap gwave , %A_LoopField%

    if a_index = 241
	    songcount = showmsg
}


If mycount = positive
    GoTo, addpagenum

Gui, Font, s14 cWhite, Arial Black
Gui, Add, Text, x225 y15 w200 Center, No Files Found.

Gui, Font, s10 cWhite, Arial

Gui, Add, Text, w200 Center, To use "Richard's Sound FX Player" copy it into a folder containing mp3, wma or wave`nfiles and run it.`n`nThe player will read the files and create a play button for each one.
Goto, BuildGui

addpagenum:
Gui, Font, s10 cBlack, Arial Black

Gui, Font, s10 cWhite, Arial
If over60 = no
    Goto, BuildGui

Gui, Add, Text, x12 y730 Disabled Underline Center vOver00 gOver00, Page 1
Gui, Add, Text, xp+50 Underline Center vOver60 gOver60, Page 2

If over120 = no
    Goto, BuildGui
Gui, Add, Text, xp+50 Underline Center vOver120 gOver120, Page 3

If over180 = no
    Goto, BuildGui
Gui, Add, Text, xp+50 Underline Center vOver180 gOver180, Page 4


BuildGui:

FADE       := 524288
SHOW       := 131072
HIDE       := 65536

FADE_SHOW  := FADE+SHOW
FADE_HIDE  := FADE+HIDE



SetFormat, Integer, Hex
FADE_SHOW+=0
FADE_HIDE+=0
SetFormat, Integer, d

Duration = 250

GUI_ID:=WinExist()

Gui, +LastFound
Gui, Color, black
Gui, -Caption
Gui, +0x400000
Gui, Margin , 3, 3

Gui, show, Hide, Richard's Sound FX Player ( Fade-In / Fade-Out )
AnimateWindow(GUI_ID, Duration, FADE_SHOW)

GoSub, showornot

GuiControl,, fadetime, %fadetime%
Gui, Submit, NoHide

OnMessage(0x201, "WM_LBUTTONDOWN")

return

showornot:
if songcount = showmsg
    Goto, 240msg
Return

240msg:
if popmsg = done
    Return
if popmsg = notyet
    {
    Msgbox, No more the 240 files may be loaded.
    popmsg = done
	}
Return

VolumeX:
Gui, Submit, NoHide
SoundSet,%volume%,master
GuiControl,, VolumeText, %volume%
GuiControl,, VolumeText2, %volume%
Return


wave:
Status := MCI_Status(LastMedia)
If Status = 
	Status = Stopped
If Status != Stopped
	Return
MCI_Stop(hMedia)
MCI_Close(hMedia)
GuiControl, , playing, %A_GuiControl%
Gui, Font, s14 cWhite, Arial Black
GuiControl, Font, nowplay,
hMedia:=MCI_Open(A_GuiControl)
LastMedia = %hMedia%
MCI_Play(hMedia)

GoTo, pos
return

pos:
ytime:=MCI_Length(hMedia)
xtime:=MCI_ToHHMMSS(ytime)
GuiControl, , songtime, %xtime%
GuiControl, , cdown, %xtime%
Loop,
    {
	Sleep, 1000
	ypos:=A_index*1000
    xpos:=MCI_ToHHMMSS(ypos)
    GuiControl, , songpos, %xpos%
	xstats:=MCI_Status(hMedia)
    GuiControl, , songstat, %xstats%
	If xstats = stopped
	    Break
	countdown:=ytime-(A_index*1000)
	cdpos:=MCI_ToHHMMSS(countdown)
	GuiControl, , cdown,%cdpos%
	}

GoTo, reset
return

fadeout:
Gui, Submit, NoHide
xstats:=MCI_Status(hMedia)
If xstats <> playing
    Return
fadeactive = yes
SoundGet, master_volume
ReturnMast := master_volume+1
Gui, Font, cBlue s10, Arial
GuiControl, Font, playing
GuiControl, , playing, Wait for fade to complete.
Loop,
    {
    SoundSet -1
    SoundGet, master_volume
    GuiControl, , Volume, %master_volume%
    gosub, Volumex
    Sleep, %fadetime%
    If 0 = %master_volume%
	    Break
	xstats:=MCI_Status(hMedia)
	If xstats = stopped
	    Break
    }

MCI_Stop(hMedia)
Sleep, 250
SoundSet, %ReturnMast%,master
SoundGet, master_volume
GuiControl, , Volume, %master_volume%
gosub, Volumex
GuiControl,, VolumeText, %volume%
Goto, reset
return

Stop:
MCI_Stop(hMedia)
Goto, reset
return

reset:
xstats:=MCI_Status(hMedia)
Gui, Font, s10 cBlue ,Arial
GuiControl, Font, playing,
GuiControl, , playing, Click a button to start playback.
GuiControl, , songpos, 0:00
GuiControl, , songtime, 0:00
GuiControl, , cdown, 0:00
Gui, Font, cGray s14, Arial Black
GuiControl, Font, nowplay,

Return

Over00:
GuiControl, Enable, Over60
GuiControl, Enable, Over120
GuiControl, Enable, Over180
GuiControl, disable, Over00


If pagenumber = 2
	Loop, 60
		{
		columncount2:= A_index+66
		GuiControl, Hide, Button%columncount2%
		}

If pagenumber = 3
	Loop, 60
		{
		columncount3:= A_index+126
		GuiControl, Hide, Button%columncount3%
		}

If pagenumber = 4
	Loop, 60
		{
		columncount4:= A_index+186
		GuiControl, Hide, Button%columncount4%
		}

Sleep, 100
Loop, 60
	{
	columncount1:= A_index+6
	GuiControl, Show, Button%columncount1%
	}

Gui, Show, x10 y2 AutoSize
pagenumber:= 1
Gui, Submit, NoHide
Return

Over60:
GuiControl, Enable, Over00
GuiControl, Enable, Over120
GuiControl, Enable, Over180
GuiControl, disable, Over60

If pagenumber = 1
	Loop, 60
		{
		columncount1:= A_index+6
		GuiControl, Hide, Button%columncount1%
		}

If pagenumber = 3
	Loop, 60
		{
		columncount3:= A_index+126
		GuiControl, Hide, Button%columncount3%
		}

If pagenumber = 4
	Loop, 60
		{
		columncount4:= A_index+186
		GuiControl, Hide, Button%columncount4%
		}


Sleep, 100
Loop, 60
    {
	columncount2:= A_index+66
	GuiControl, Show, Button%columncount2%
	}

Gui, Show, x10 y2 AutoSize
pagenumber:= 2
Gui, Submit, NoHide
Return

Over120:
GuiControl, Enable, Over00
GuiControl, Enable, Over60
GuiControl, Enable, Over180
GuiControl, disable, Over120

If pagenumber = 1
	Loop, 60
		{
		columncount1:= A_index+6
		GuiControl, Hide, Button%columncount1%
		}

If pagenumber = 2
	Loop, 60
		{
		columncount2:= A_index+66
		GuiControl, Hide, Button%columncount2%
		}

If pagenumber = 4
	Loop, 60
		{
		columncount4:= A_index+186
		GuiControl, Hide, Button%columncount4%
		}

Sleep, 100
Loop, 60
    {
	columncount3:= A_index+126
	GuiControl, Show, Button%columncount3%
	}

Gui, Show, x10 y2 AutoSize
pagenumber:= 3
Gui, Submit, NoHide
Return

Over180:
GuiControl, Enable, Over00
GuiControl, Enable, Over60
GuiControl, Enable, Over120
GuiControl, disable, Over180

If pagenumber = 1
	Loop, 60
		{
		columncount1:= A_index+6
		GuiControl, Hide, Button%columncount1%
		}

If pagenumber = 2
	Loop, 60
		{
		columncount2:= A_index+66
		GuiControl, Hide, Button%columncount2%
		}

If pagenumber = 3
	Loop, 60
		{
		columncount3:= A_index+126
		GuiControl, Hide, Button%columncount3%
		}

Sleep, 100
Loop, 60
    {
	columncount4:= A_index+186
	GuiControl, Show, Button%columncount4%
	}

Gui, Show, x10 y2 AutoSize
pagenumber:= 4
Gui, Submit, NoHide

Return

Exit:
MCI_Stop(hMedia)
MCI_Close(hMedia)
AnimateWindow(GUI_ID, Duration, FADE_HIDE)
Gui, Destroy
ExitApp
return

AnimateWindow(hWnd,Duration,Flag) {
Return DllCall("AnimateWindow","UInt",hWnd,"Int",Duration,"UInt",Flag)
}

WM_LBUTTONDOWN()
{
    PostMessage, 0xA1, 2
}

