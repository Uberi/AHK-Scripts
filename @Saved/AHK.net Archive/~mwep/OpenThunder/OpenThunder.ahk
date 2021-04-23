; OpenThunder_??.ahk
;??????????(http://thunderplatform.xunlei.com/),??HTTP??(????ftp?)
;???:?? <healthlolicon@gmail.com>,???ANSI??,???????
;?Oaker<icaner@qq.com>??,????
;??Unicode??,??Unicode?Autohotkey,??????(CodeXchange.ahk )
;????????????(??:1.1.0.0),??(Oaker)???XLDownload,dll?reshack.exe??????????,?????200kb
;???????,???????????????,??td????(?????????)
;????/??,?????:    http://ahk.5d6d.com/thread-4266-1-1.html

#NoEnv
#SingleInstance off
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
Status=?????
Percent=0

IfExist, OpenThunder.ico
   Menu, tray, icon, OpenThunder.ico
   Menu,Tray,NoStandard
   Menu,Tray,Add,??,Exit

Gui, Color, 424242
Gui, font, s12
SplitPath, clipboard, name,,,,OutDrive
FormatTime, theDate, YYYYMMddhhmmss, yyyyMMddhhmmss
tmp_name=%theDate%.%name%
Gui, Add, Text, x10 y10 w450 cSilver, %name% ;%OutDrive% … %name%
;Gui, Add, Picture, x10 y35 h30 w300, %A_WinDir%\system32\ntimage.gif
Gui, Add, Progress, x10 y35 h30 w300 c0174DF Background585858 vMyProgress,0
Gui, Add, Text, x360 y85  cSilver vStatusText,%Status%
Gui, Add, Text, x330 y85 w30 cSilver  vPercentText,%Percent%`%
Gui, Add, Button, x20 y75 w60 h30 gNew, ??
Gui, Add, Button, x90 y75 w60 h30 gPause, ??
Gui, Add, Button, x160 y75 w60 h25 gContinue, ??
Gui, Add, Button, x230 y75 w60 h25 gOpen, ??
;Gui, Add, Button, x350 y10 w80 h15 gRename, ???
Gui, Add, Button, x330 y30 w110 h50 gDownLoad, ??
Gui, show,,??@P2P?? ? %Clipboard%
;Hotkey, Space, CheckTrigger
Return

New:
;????
run, %A_scriptDir%\%A_scriptName%
return

Open:
Run %A_Temp%\OpenThunder\%tmp_name%
return

OnExit:
GuiClose:
if hMoule!=0
	Gosub,Stop
ExitApp

DownLoad:
;??dll
hModule := DllCall("LoadLibrary", "str", "XLDownload.dll")
Rtn1:=DllCall("XLDownload\XLInitDownloadEngine")

;??
sUrl=%Clipboard%
sfile=%A_Temp%\OpenThunder\%tmp_name%
;Ansi2Unicode(sUrl, url, 0)
;Ansi2Unicode(sFile, File, 0)

rtn2:=DllCall("XLDownload\XLURLDownloadToFile","str",sfile,"str",sUrl,"Str",0,"intP",TaskID)
SetTimer,Query,1000
Return

;????
Query:
retn:=DllCall("XLDownload\XLQueryTaskInfo","int",TaskID,"intP",TaskStatus,"Uint64P",FileSize,"Uint64P",RecvSize)
if retn=0
{
	if TaskStatus=0
	{
		Status=??????
			}
	Else if TaskStatus=2
		Status=????
	Else if TaskStatus=10
	{
		SetTimer,Query,off
		Status=??
		}
	Else if TaskStatus=11
	{
		SetTimer,Query,off
		Status=????
		Gosub,Stop
		}
	Else if TaskStatus=12
	{
		Status=????
		}
	Else
		Status=??
	}
GuiControl,,StatusText,??:%Status%
Percent:=RecvSize*100//FileSize
GuiControl,,PercentText,%Percent%`%
GuiControl,,MyProgress,%Percent%
Return

;??
Pause:
DllCall("XLDownload\XLPauseTask","int",TaskID,"IntP",NewTaskID)
TaskID:=NewTaskID
Return

;??
Continue:
SetTimer,Query,1000
DllCall("XLDownload\XLContinueTask","int",TaskID)
Return

;??
Stop:
SetTimer,Query,off
GuiControl,,StatusText,??:????
GuiControl,,PercentText,0`%
GuiControl,,MyProgress,0
DllCall("XLDownload\XLStopTask","int",TaskID)
DllCall("XLDownload\XLUninitDownloadEngine")
DllCall("FreeLibrary", "UInt", hModule)
Return

;Rename:
;InputBox, newname
;name =%newname%
;Return

Exit:
ExitApp
return