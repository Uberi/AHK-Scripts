;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    Inner Wheel     ;;;;;;;;;;;;;;;;;;;;;;
VLC_2_:
VLCHTTP_VolumeChange(iKey2)
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     First Row          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VLC_4_1:
VLCHTTP_Play()
Return

VLC_4_2:
VLCHTTP_Pause()
Return

VLC_4_4:
VLCHTTP_FullScreen()
Return

VLC_4_8:
VLCHTTP_Stop()
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     Second Row          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VLC_4_16:
SetTimer, RW30, Off
SetTimer, RW10, Off
SetTimer, FF10, Off
SetTimer, FF30, Off
SetTimer, RW30, 500
Return
RW30:
VLCHTTP_JumpBackward(30)
Return

VLC_4_32:
SetTimer, RW30, Off
SetTimer, RW10, Off
SetTimer, FF10, Off
SetTimer, FF30, Off
SetTimer, RW10, 500
Return

RW10:
VLCHTTP_JumpBackward(10)
Return

VLC_4_64:
SetTimer, RW30, Off
SetTimer, RW10, Off
SetTimer, FF10, Off
SetTimer, FF30, Off
Return

VLC_4_128:
SetTimer, RW30, Off
SetTimer, RW10, Off
SetTimer, FF10, Off
SetTimer, FF30, Off
SetTimer, FF10, 500
Return
FF10:
VLCHTTP_JumpForward(10)
Return

VLC_5_1:
SetTimer, RW30, Off
SetTimer, RW10, Off
SetTimer, FF10, Off
SetTimer, FF30, Off
SetTimer, FF30, 500
Return
FF30:
VLCHTTP_JumpForward(30)
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     Wheel         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VLC_1_0:
Send `=
Return

VLC_1_1:
Send `=
Send {NumpadAdd}
Return
VLC_1_2:
Send `=
Send {NumpadAdd}
Send {NumpadAdd}
Return
VLC_1_3:
Send `=
Loop, 3
	{
	Send {NumpadAdd}
	}
Return
VLC_1_4:
Send `=
Loop, 4
	{
	Send {NumpadAdd}
	}
Return
VLC_1_5:
Send `=
Loop, 5
	{
	Send {NumpadAdd}
	}
Return
VLC_1_6:
Send `=
Loop, 6
	{
	Send {NumpadAdd}
	}
Return
VLC_1_7:
Send `=
Loop, 7
	{
	Send {NumpadAdd}
	}
Return

VLC_1_255:
Send `=
Send -
Return
VLC_1_254:
Send `=
Send -
Send -
Return
VLC_1_253:
Send `=
Loop, 3
	{
	Send -
	}
Return
VLC_1_252:
Send `=
Loop, 4
	{
	Send -
	}
Return
VLC_1_251:
Send `=
Loop, 5
	{
	Send -
	}
Return
VLC_1_250:
Send `=
Loop, 6
	{
	Send -
	}
Return
VLC_1_249:
Send `=
Loop, 7
	{
	Send -
	}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     Bottom 4          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VLC_5_2:
VLCHTTP_VolumeChange(32)
Return

VLC_5_4:
VLCHTTP_VolumeChange(64)
Return

VLC_5_8:
VLCHTTP_VolumeChange(96)
Return

VLC_5_16:
VLCHTTP_VolumeChange(128)
Return
