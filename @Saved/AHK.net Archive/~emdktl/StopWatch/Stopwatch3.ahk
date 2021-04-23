; Gui, 1: +LastFound -Caption +Border ;+Alwaysontop +Owner
; SplitPath, A_ScriptFullPath, exeNameExt, exeDir, exeExt, ExeName, ExeDrive 
#SingleInstance force
MainIcon=%A_ScriptDir%\Stopwatch.ico
if !A_IsCompiled	; Autocompiling
	{
	SplitPath, A_ScriptFullPath, , OutDir, , OutName
	Icon:= MainIcon ? "/icon """ MainIcon """ " : ""
	Process,Close, %OutName%.exe
	Process,WaitClose, %OutName%.exe
	RunWait, "%A_AhkPath%\..\Compiler\Ahk2Exe.exe" /in "%A_ScriptFullPath%" %Icon%/out "%OutDir%\%OutName%.exe"
	Run, %OutDir%\%OutName%.exe
	ExitApp
	}
WinTitle:="StopWatch"
FileInstall, StopWatchb.ico, %A_ScriptDir%\StopWatchb.ico, 0	;
FileInstall, StopWatchr.ico, %A_ScriptDir%\StopWatchR.ico, 0	
; FileInstall, Stopwatch.ahk, %A_ScriptDir%\Stopwatch.ahk, 0		; Sourcecode
FileInstall, Stopwatch.ico, %A_ScriptDir%\Stopwatch.ico, 0		; MainIcon
_1_=666666
_2_=777777
_3_=888888
_4_=999999
_5_=AAAAAA
_6_=BBBBBB
_7_=CCCCCC
_8_=DDDDDD
_9_=EEEEEE
_10_=FFFFFF
menu,tray,nostandard
menu,tray,icon,%A_ScriptDir%\StopWatchb.ico
menu,tray,add,toggle GUI,GuiToggle
menu,tray,add,exit,exit
Menu,Tray,Default,toggle GUI	; Changes the menu's default item 
Menu,Tray,Click,1 				; Single-click to activate the tray menu's default menu item.

Gui,Destroy
Gui,+LastFound -Caption +Border +ToolWindow +Alwaysontop +Owner ;+resize
GUI_ID:=WinExist()	; Get the Handle of the Window
Gui,Color,Black
Gui,font, S9 , webdings ; Set the font for the text
Gui,Add, Button, x0 yp w20 h20 Center hwndhStartSplit vStartSplit gPlay,= ;`;
Gui,Add, Button, x+0 yp wp hp Center hwndhTimerReset vTimerReset gTimerReset,<
Gui,Add, Button, x+0 yp wp hp Center hwndhViewLog vViewLog gViewLog,t
Gui,Add, Button, x+0 yp wp hp Center hwndhAbout vAbout gAbout,i
; Gui,Add, Button,x+0 yp w16 h16 Center gSettings,@
Gui,font, S9 bold, Arial
Gui,Add, Text, x+0 yp wp hp 0x4 gGuiMove vGuiMove
Gui, Add, Text,x+10 yp hp wp cBlack vTitle BackgroundTrans,%WinTitle%
Gui,font, S9 , webdings ; Set the font for the text
Gui,Add, Button,Center x+0 yp w20 hp Center hwndhGuiClose vGuiClose gGuiClose,r ; Close
Gui,font, S9 bold, Arial
Loop 10 {
	FontSize:=10+(A_index*2)
	FontColor:=_%A_index%_
	Gui, Font, c%FontColor% s%FontSize%, Tahoma
	Gui, Add, Text,x10 y+0 vTimer%A_index%,00:00:00
	}
GuiControlGet, Timer ,Pos, Timer10
gw:=10 + Timerx + TimerW + 10
GuiControlGet, GuiMove ,Pos, GuiMove
GuiControlGet, GuiClose ,Pos, GuiClose
GuiControl,Move, GuiClose,% "x" GW-GuiCloseW
GuiControl,Move, GuiMove,% "w"   GW-GuiMoveX-GuiCloseW
GuiControl,Move, Title,% "w"  GW-16-16-16-16-16
Loop 9						; 
	GuiControl,,Timer%A_index% ,				; set the text to nothing
AddTooltip(hStartSplit,"Start the timer or set a mark (Space)")
AddTooltip(hTimerReset,"Stop and Reset The Timer (Enter or BackSpace)")
AddTooltip(hViewLog,"View the Log File (F4)")
AddTooltip(hAbout,"About (F1)")
AddTooltip(hGuiClose,"Close to Tray (Escape)")
	
	x:=A_ScreenWidth-6-GW
Gui, Show,x%x% w%gw%,Stopwatch ;,w200
Hotkey, IfWinActive, ahk_id %GUI_ID%	; Activate hotkeysonly for this program
Hotkey, Space, TimerStart				; space wil start the timer
Hotkey, Enter, TimerReset				; enter wil reset the timer
Hotkey, BS, TimerReset				; enter wil reset the timer
Hotkey, F1, About						; F1 show the about dialog
Hotkey, F4, ViewLog					; F4 will open the log file
Hotkey, Esc, GuiClose					; escape wil close the program to the tray
return ;ExitApp
Millisec2Min_Sec_HSec(MilliSec) {
	Global _0_, SS, MM
	_0_:= SubStr("00" . (Mod(MilliSec,1000)//10),-1)
	SS:= SubStr("00" . Mod(MilliSec//1000, 60),-1)
	MM:= SubStr("00" . Mod((MilliSec//1000)//60, 60),-1)
	return,% MM ":" SS ":" _0_
	}
Play:
	gosub,% StartTime ? "Timersplit" : "TimerStart"
	Return
TimerUpdate:
	GuiControl,,Timer10 ,% Millisec2Min_Sec_HSec(A_TickCount-StartTime)	; changethe time
	return
TimerStart:
	StartTime := A_TickCount
	PrevTime := 0
	FormatTime,Section,,M_d_yyyy_HH:mm	; a section wil look like [5_26_2011_00:03]
	SetTimer, TimerUpdate, 1				; start updating the gui
	SetTimer, ToggleTrayIcon, 500			; start blinking the trayicon
	Hotkey, Space, Timersplit				; change the space hotkey to do a timersplit
	return
Timersplit:     ; Update non counting items
	T_:=Millisec2Min_Sec_HSec(NewTime:= A_TickCount-StartTime)
	IniWrite,% Millisec2Min_Sec_HSec(NewTime-PrevTime), %A_ScriptDir%\StopWatch.log, %Section%,%T_%
	Loop 8 {								; loop our non coun ting controls
		next:=A_index+1					; (the next control is more recent)
		GuiControlGet, _ , , Timer%next%	; get the text from the next control
		GuiControl,,Timer%A_index% ,%_%	; Set the text of tis control to the text of the next one
		}
	GuiControl,,Timer9 ,%T_%				; set the text for the last (noncounting) control
	PrevTime:=NewTime						; New time becomes the old time
	return
TimerReset:
	Loop 9									; Loop to hide unused controls
		GuiControl,,Timer%A_index% ,		; Remove the text from all controls
	GuiControl,,Timer10 ,00:00:00		; reset the main time control
	SetTimer, TimerUpdate, Off			; Stop updating the gui
	Hotkey, Space, TimerStart				; pressing space wil start the timer
	SetTimer, ToggleTrayIcon, Off			; stop blinking the tray icon
	menu, tray, icon,%A_ScriptDir%\StopWatchB.ico	; set the grayed out icon for the tray
	StartTime:=""							; reset the starttime
	return
Exit:
	Exitapp
	return
About:
	Msgbox,Stopwatch by Emmanuel
	Return
ViewLog:
	Run,"%A_ScriptDir%\StopWatch.log"
	return
GuiEsc:
GuiClose:
GuiToggle:
	Gui,% (GuiHidden:=!GuiHidden) ? "hide" : "Show"
	return
GuiMove:
	PostMessage, 0xA1, 2,,, A
	Return
ToggleTrayIcon:
	menu, tray, icon,% A_ScriptDir "\StopWatch" ((TrayIcon:=!TrayIcon) ? "R" : "B") ".ico"
	return
AddToolTip(con,text,Modify = 0){ ; http://www.autohotkey.com/forum/viewtopic.php?t=30300
  Static TThwnd,GuiHwnd
  If (!TThwnd){
    Gui,+LastFound
    GuiHwnd:=WinExist()
    TThwnd:=DllCall("CreateWindowEx"
				,"Uint",0
				,"Str","TOOLTIPS_CLASS32"
				,"Uint",0
				,"Uint",2147483648 | 3
				,"Uint",-2147483648
				,"Uint",-2147483648
				,"Uint",-2147483648
				,"Uint",-2147483648
				,"Uint",GuiHwnd
				,"Uint",0
				,"Uint",0
				,"Uint",0)
  }
  Varsetcapacity(TInfo,44,0)
  Numput(44,TInfo)
  Numput(1|16,TInfo,4)
  Numput(GuiHwnd,TInfo,8)
  Numput(con,TInfo,12)
  Numput(&text,TInfo,36)
  Detecthiddenwindows,on
  IfEqual,Modify,%true%,SendMessage,1036,0,&TInfo,,ahk_id %TThwnd%
  Else {
    Sendmessage,1028,0,&TInfo,,ahk_id %TThwnd%
    SendMessage,1048,0,300,,ahk_id %TThwnd%
  }
}
