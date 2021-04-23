/*

Thanks to Tic for his gdip.ahk library  http://www.autohotkey.com/forum/topic32238.html 
It needs to be in standard lib or use the #include 
Thanks to Skan for his color dialog     http://www.autohotkey.com/forum/topic59534.html
Is embedded in the code.



The original onscreen clock by Thanh00 is here  http ://www.autohotkey.com/forum/topic66207.html

I needed an alarmclock / timer that was very simple to program/start and would survive a reboot 
or hibernation.The inpiration is the clock shown in the intro of anime Steins Gate.



hotkeys:
 
Alt+o or traymenu
-parameter defeniton menu 

Alt+i
-hide / show

***********  use Alt+NumpadSub in in clickthrough mode !!!!!   *********

Rightclick or Alt+Numpadsub
-gives timer menu or reset to clock mode

esc 
-interupts input time display

enter
-input time display value is entered .

*************************************************************************************
To enter the setting of the alarm: rightclick clock ( or hotkey alt+numpad- )
(there is a timeout of 10sec)
endtime 
add  + to hhmmss example:  162012+   alarm at 16:20:12
(The position of the "t" is free so 16t2012 will do the same.)

fixed time
enter hhmmss  example  3000 =30minutes  3 = 3seconds  10003=1hour 3seconds
you cannot enter 60 for 1 hour use 10000 , not 6000
(leading zero's can be omitted)

*************************************************************************************


Click_through status is not saved !!!! Can be set in ini_file.

To set default values delete ini file.

*/








#NoEnv
#InstallKeybdHook
DetectHiddenWindows On
SetTitleMatchMode 2
OnExit gone_away
;gdip library download http://www.autohotkey.com/forum/topic32238.html 
;#include gdip.ahk  

Menu, Tray,add,enable Sound  , set_sound

Menu, Tray,add,Save Position ,save_position
Menu, Tray,add,Set Click Through ,click_through
Menu, Tray,add,Set AlwaysOnTop ,AlwaysOnTop 
Menu, Tray,add,Set edit transparent ,edittrans
Menu, Tray,add,Set hotkeys off ,hotkey_off
Menu, Tray,add
Menu, MySubmenu,add,Timer countdown , set_timercolor
Menu, MySubmenu,add,Timer endtime (+),set_timer_t_color

Menu, MySubmenu,add,Clock Color ,set_clockcolor
Menu, Tray,add,Set background opacity ,set_opacity
Menu, Tray,add, Set Colors,:MySubMenu
Menu, Tray,add
Menu, Tray,add,Exit ,gone_away
Menu, Tray,NoStandard

;---------------- hotkey alt+o menu -----------------


Menu, MyMenu,add,enable Sound  , set_sound

Menu, MyMenu,add,Save Position ,save_position
Menu, MyMenu,add,Set Click Through ,click_through
Menu, MyMenu,add,Set AlwaysOnTop ,AlwaysOnTop 
Menu, MyMenu,add,Set edit transparent ,edittrans 
Menu, MyMenu,add,Set hotkeys off ,hotkey_off
Menu, MyMenu,add
Menu, MySubmenu,add,Timer countdown , set_timercolor
Menu, MySubmenu,add,Timer endtime (+),set_timer_t_color

Menu, MySubmenu,add,Clock Color ,set_clockcolor
Menu, MyMenu,add,Set background opacity ,set_opacity
Menu, MyMenu, add, Set Colors,:MySubMenu
Menu, MyMenu,add
Menu, MyMenu,add,Exit ,gone_away
Menu, MyMenu,NoStandard
;---------------- alt+o menu -----------------


;-------------- create ini file -------------- 
IfNotExist, steins_gate.ini
{

IniWrite,"",steins_gate.ini,parameters,timerstatus
IniWrite,0,steins_gate.ini,parameters,statusend
IniWrite,"",steins_gate.ini,parameters,finaltime
IniWrite,"",steins_gate.ini,parameters,finaltime_tooltip
IniWrite,0,steins_gate.ini,parameters,sound
IniWrite,!numpadsub,steins_gate.ini,parameters,timer hotkey
IniWrite,cffC0C0FE,steins_gate.ini,parameters,timer_t_color
IniWrite,cffC0C0FE, steins_gate.ini, parameters, timer_color
IniWrite,cffE2E2E2, steins_gate.ini, parameters, clock_color
IniWrite,100, steins_gate.ini, parameters, positionx
IniWrite,100, steins_gate.ini, parameters, positiony
IniWrite,A3, steins_gate.ini, parameters, opacity     ;these are hex values!!!
IniWrite,0, steins_gate.ini, parameters, alwaysontop
IniWrite,0, steins_gate.ini, parameters, click_through
IniWrite,0, steins_gate.ini, parameters, edittrans

}
;-------------- create ini file -------------- 





;-------------- get default values -------------- 
IfExist, steins_gate.ini
{

IniRead,timer_t,steins_gate.ini,parameters,timerstatus
IniRead,status_end,steins_gate.ini,parameters,statusend
IniRead,enable_sound,steins_gate.ini,parameters,sound
IniRead,timer_hotkey,steins_gate.ini,parameters,timer hotkey,!numpadsub
IniRead,timer_t_color,steins_gate.ini,parameters,timer_t_color,cffC0C0FE
IniRead,timer_color, steins_gate.ini, parameters, timer_color,cffC0C0FE
IniRead,clock_color, steins_gate.ini, parameters, clock_color,cffE2E2E2
IniRead,posx, steins_gate.ini, parameters, positionx,100
IniRead,posy, steins_gate.ini, parameters, positiony,100
IniRead,opacity_value_hex, steins_gate.ini, parameters, opacity,A8
IniRead,alwaysontop, steins_gate.ini, parameters, alwaysontop,0
IniRead,click_through, steins_gate.ini, parameters, click_through,0
IniRead,edit_tr, steins_gate.ini, parameters, edittrans,1
}


background_color=0x%opacity_value_hex%000000
display_size:=s24
color_text_input=00FF40
status_timer=0


;-------------- get default values -------------- 


If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
Font = Arial
If !hFamily := Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
Gdip_DeleteFontFamily(hFamily)




Gui,  +E0x80000 +LastFound +OwnDialogs +Owner  -caption 
Gui,  Show, x0 y0 
gui +lastfound
hwnd:=winexist()

width =300
height =28



hbm := CreateDIBSection(width, height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
pBrush := Gdip_BrushCreateSolid(background_color)
Gdip_SetSmoothingMode(G, 4)
Gdip_FillRoundedRectangle(G, pBrush, 0, 0, width, height,10)

UpdateLayeredWindow(hwnd, hdc, 0, 0, width, height)


OnMessage(0x200,"OnMouseMove"), OnMessage(0x2A3,"OnMouseLeave")
OnMessage(0x201, "WM_LBUTTONDOWN")
VarSetCapacity(TME,16,0), NumPut(16,TME,0), NumPut(2,TME,4), NumPut(hwnd,TME,8)

WinMove, ahk_id %hwnd%, , %posX%, %posY% 
settimer,get_realtime,100

;-------------- set initial conditions

if alwaysontop
Gosub, alwaysontop

if click_through
Gosub, click_through

if enable_sound
gosub set_sound

if edit_tr
{
menu,tray,togglecheck,Set edit transparent 
menu,MyMenu,togglecheck,Set edit transparent 
}

IniRead,timer_t,steins_gate.ini,parameters,timerstatus
IniRead,finaltime,steins_gate.ini,parameters,finaltime
IniRead,finaltime_tooltip,steins_gate.ini,parameters,finaltime_tooltip

if !(finaltime="")
{
settimer,get_realtime,off
settimer,get_counter,100
status_timer=1
}

hotkey,%timer_hotkey%,guicontextmenu,on

return

;---------------- ---------------- ---------------- ---------------- ---------------- ---------------- ---------------- 


set_sound:
status_sound:=!status_sound
if !status_sound
  IniWrite,0,steins_gate.ini,parameters,sound
else
  IniWrite,1,steins_gate.ini,parameters,sound
Menu, tray,togglecheck,enable Sound
Menu, MyMenu,togglecheck,enable Sound
return



get_realtime:
if status=0
status_enter=0
if timer_t not contains r
  {
  timer_t=r
  soundplay=
  finaltime_tooltip=
  finaltime=
  IniWrite,%timer_t%,steins_gate.ini,parameters,timerstatus
  IniWrite,%finaltime%,steins_gate.ini,parameters,finaltime
  IniWrite,%finaltime_tooltip%,steins_gate.ini,parameters,finaltime_tooltip
  status_timer=0
  }

gosub write_display_text_clock
return
;-------------- write display text -------------- 

write_display_text_clock:
Gdip_GraphicsClear(G)
Gdip_FillRoundedRectangle(G, pBrush, 0, 0, width, height,5)
Gdip_SetCompositingMode(G, 0)
displaytext:=get_ex_time(1)
  Options = x0 y4  %clock_color%  Center  s18
  Gdip_TextToGraphics(G, displaytext, Options, Font, width, height)
UpdateLayeredWindow(hwnd, hdc)
return

write_display_text_timer:
display_size=s24
Gdip_SetCompositingMode(G, 1)
Gdip_FillRoundedRectangle(G, pBrush, 0, 0, width, height,5)
Gdip_SetCompositingMode(G, 0)
if (timer_t="t")
  display_color:=timer_t_color
if (timer_t="c")
  display_color:=timer_color
Options = x10 y1  %display_color%  Left  %display_size%
Gdip_TextToGraphics(G, displaytext, Options, Font, width, height)

displaytext:=get_ex_time(0)
  Options = x-10 y5  %clock_color%  Right  s14
  Gdip_TextToGraphics(G, displaytext, Options, Font, width, height)

UpdateLayeredWindow(hwnd, hdc)
return

write_display_text_info:
Gdip_GraphicsClear(G)
Gdip_FillRoundedRectangle(G, pBrush, 0, 0, width, height,5)
Gdip_SetCompositingMode(G, 0)

Options = x0 y1  cff00ff00  Center  s24
Gdip_TextToGraphics(G, displaytext, Options, Font, width, height)
UpdateLayeredWindow(hwnd, hdc)
return

get_ex_time(ex){
VarSetCapacity(sTime, 16, 0)

DllCall("GetLocalTime","Str",sTime)
    ye := NumGet(sTime, 0, "UShort")
    mo := substr(00 . NumGet(sTime, 2, "UShort"),-1)
    da := substr(00 . NumGet(sTime, 6, "UShort"),-1)

    h := substr(00 . NumGet(sTime, 8, "UShort"),-1)
    m := substr(00 . NumGet(sTime, 10, "UShort"),-1)
    s := substr(00 . NumGet(sTime, 12, "UShort"),-1)
    ms:= substr(00 . NumGet(sTime, 14, "UShort"),-1)
if ex
time=AD  %ye% . %mo% . %da%   %h%:%m%:%s% : %ms%
else
time=%h%:%m%:%s%:%ms%
return  time  
} 

get_alarmtime:
data=
gosub display_input
gosub set_input

If (alarmtime="")
{
status_display=1
goto guicontextmenu
}

IfInString, alarmtime,+
  {
  gosub timer_t
  return
  }
else
  {
  gosub timer_c
  return
  }
return



set_input:
status=1
status_edit=1
status_enter=0
data=
hotkey,Backspace,on

while status
{
Input, SingleKey,  L1 t10 ,{Enter} {Esc}

    IfInString, ErrorLevel, Timeout
    {
    hotkey,Backspace,off
    status=0
    break
    }
    
    IfInString, ErrorLevel, Escape
    {
    hotkey,Backspace,off
    status=0
    break
    }
    IfInString, ErrorLevel, Endkey:Enter
    {
    if check(data)
    {
    data_:=data
    data = error
    gosub display_input
    sleep 500
    data:=data_
    gosub display_input
    continue
    }
    status=0
    status_enter=1
    break
    }
data .=singlekey

data_:=regexreplace(data,"[^\d]")
if (strlen(data_)>6)
{
soundbeep 
stringtrimright,data,data,1
}
data:=pos(data)
gosub display_input
}
if status_enter
  alarmtime:=data
else
  alarmtime=
hotkey,Backspace,off
return

pos(data){
ifinstring,data,+
z=1
data:=regexreplace(data,"[^\d]")
loop  % strlen(data)
        {
        a:=substr(data,-1)
                if (a="")
                break
        l := a " " l
        stringtrimright,data,data,2
        }
l  :=((z=1) ? l "+" : l)
return  l  
}

check(data){
    data:=regexreplace(data,"[^\d]")
    v:=substr(a_now,1,14-(strlen(data))) . data
    if v is not time
    return 1
}

~Backspace::
stringtrimright,data,data,1
gosub display_input
return

display_input:
Gdip_GraphicsClear(G)
pBrush0 := Gdip_BrushCreateSolid(0xc0000000)
Gdip_FillRoundedRectangle(G, pBrush0, 0, 0, width, height,5)
pPen:=Gdip_CreatePen(0xffFBA71A,1)
IniRead,edit_tr, steins_gate.ini, parameters, edittrans,1
if edit_tr
brush_edit=0x30000000
else
brush_edit=0xff808080

pBrush1 := Gdip_BrushCreateSolid(brush_edit)
points=190,5 | 290,5 |290,23 |190,23 | 190,5
Gdip_SetCompositingMode(G, 1)

Gdip_FillRectangle(G, pBrush1, 190, 5, 100,18)
Gdip_DrawLines(G, pPen, Points)
UpdateLayeredWindow(hwnd, hdc)
Gdip_DeletePen(pPen)
Gdip_DeleteBrush(pBrush1)
Gdip_DeleteBrush(pBrush0)
display_text= Set time   hhmmss (+)   ?

Gdip_SetCompositingMode(G, 0)
Options = x5 y8  cffc0c0c0 Left r4 Bold s12
Gdip_TextToGraphics(G, display_text, Options, font)

display_text:= data
if !edit_tr
color_text_input=000000
Options = x192 y6 w100 cff%color_text_input% Center r4 s16
Gdip_TextToGraphics(G, display_text, Options, font)

UpdateLayeredWindow(hwnd, hdc)

return

guicontextmenu:
if status_display
  {
  settimer,get_realtime,100
  settimer,get_counter,off

  status_display=0
  status_timer=0
  exit
  }
if  !status_timer 
goto start_timer
else
  {
  settimer,get_realtime,100
  settimer,get_counter,off
  status_timer=0
  }
return


OnMouseMove( wParam, lParam, Msg ) {
global status_mouseover
global TME
global finaltime_tooltip
X := lParam & 0xFFFF 
Y := lParam >> 16 
DllCall( "TrackMouseEvent","uint",&TME )
status_mouseover=1
if ! (finaltime_tooltip="") 
tooltip % substr(finaltime_tooltip,9,2) ":" substr(finaltime_tooltip,11,2)  ":" substr(finaltime_tooltip,13,2)
}

OnMouseLeave(){
global status_mouseover
global date
status_mouseover=0
tooltip
return
}

start_timer:
settimer,get_realtime,off
gosub get_alarmtime
settimer,get_counter,100
status_timer=1
return


timer_t:
timer_t=t

date:=regexreplace(alarmtime,"\D")

message=
(
Input
for alarmclock is 6digits followed by +
5pm is 170000+
for simple timer use hhmmss (59 max input!)
10 min is 1000
)

if (strlen(date)<>6)
  {
  msgbox %message%
  exit
  }

finaltime:=substr(a_now,1,8) date
finaltime_tooltip:=finaltime
finaltime -=1970,s
IniWrite,%timer_t%,steins_gate.ini,parameters,timerstatus
IniWrite,%finaltime%,steins_gate.ini,parameters,finaltime
IniWrite,%finaltime_tooltip%,steins_gate.ini,parameters,finaltime_tooltip
return



timer_c:
timer_t=c

secs:=sec2go(alarmtime)
finaltime:=a_now
finaltime +=secs,sec
finaltime_tooltip:=finaltime
finaltime -=1970,s
IniWrite,%timer_t%,steins_gate.ini,parameters,timerstatus
IniWrite,%finaltime%,steins_gate.ini,parameters,finaltime
IniWrite,%finaltime_tooltip%,steins_gate.ini,parameters,finaltime_tooltip
return

start:
finaltime:=a_now

status_end=1
finaltime_tooltip:=finaltime
finaltime -=1970,s
IniWrite,%timer_t%,steins_gate.ini,parameters,timerstatus
IniWrite,%finaltime%,steins_gate.ini,parameters,finaltime
IniWrite,%finaltime_tooltip%,steins_gate.ini,parameters,finaltime_tooltip
settimer,get_counter,100
status_timer=1
IniWrite,%status_end%,steins_gate.ini,parameters,statusend
return




get_counter:
Tnow =
Tnow -=1970,s
if (timer_t="a")
  delta_sec:=Tnow - finaltime
else
  delta_sec:=finaltime - Tnow 
displaytext:=formatseconds(delta_sec)

if (delta_sec<0 ) and (timer_t<>"a")
  {
toggle:=!toggle
  SetTimer, get_counter,3000
  if status_sound
    soundbeep,300,100
  display_color=cffffef00
  display_size=s18
  if toggle
  {
    displaytext=Time Passed!!
  }
  else
  displaytext=%delta_sec%secs
  gosub write_display_text_info
  return
  }
gosub write_display_text_timer

return

sec2go(alarmtime){
a:=regexreplace(alarmtime,"\D")
a:=SubStr("000000" a, -5) 
s:=SubStr(a, 1,2)*3600+SubStr(a, 3,2)*60 +SubStr(a, 5,6)
return %s%
}

click_through:
Menu, tray,togglecheck,Set Click Through
Menu, MyMenu,togglecheck,Set Click Through
status:=!status
if status
  {
  msgbox Use Alt+NumpadSub instead of RightClick Mouse!!`nWindow is transparent for Mouse!!
  WinGetPos, temp_x,temp_y,,,ahk_id %hwnd%
  Gui,  destroy
  Gui,  +E0x80000 +LastFound +OwnDialogs +Owner  -caption +E0x20
  Gui,  Show, x%temp_x% y%temp_y%
  gui +lastfound
  hwnd:=winexist()
  UpdateLayeredWindow(hwnd, hdc, x%temp_x%, y%temp_y%, width, height)
  if toggle_ontop
  WinSet, alwaysontop,on,ahk_id %hwnd%
  VarSetCapacity(TME,16,0), NumPut(16,TME,0), NumPut(2,TME,4), NumPut(hwnd,TME,8)
  }
else
  {
  WinGetPos, temp_x,temp_y,,,ahk_id %hwnd%
  Gui,destroy
  
  Gui,  +E0x80000 +LastFound +OwnDialogs +Owner  -caption 
  Gui,  Show, x%temp_x% y%temp_y%
  gui +lastfound
  hwnd:=winexist()
  UpdateLayeredWindow(hwnd, hdc, x%temp_x%, y%temp_y%, width, height)
  if toggle_ontop
  WinSet, alwaysontop,on,ahk_id %hwnd%
  VarSetCapacity(TME,16,0), NumPut(16,TME,0), NumPut(2,TME,4), NumPut(hwnd,TME,8)
  }
return 
;-------------- alwaysontop -------------- 
alwaysontop:
toggle_ontop:=!toggle_ontop
IniWrite,%toggle_ontop%, steins_gate.ini, parameters, alwaysontop
menu,tray,togglecheck,set alwaysontop
menu,MyMenu,togglecheck,set alwaysontop
if toggle_ontop
WinSet, alwaysontop,on,ahk_id %hwnd%
else
WinSet, alwaysontop,off,ahk_id %hwnd%
return
;-------------- alwaysontop -------------- 



;-------------- edit transparent -------------- 
edittrans:
edit_tr:=!edit_tr
IniWrite,%edit_tr%, steins_gate.ini, parameters, edittrans
menu,tray,togglecheck,Set edit transparent 
menu,MyMenu,togglecheck,Set edit transparent 

return
;-------------- alwaysontop -------------- 



set_opacity:
opacity_h:="0x"  opacity_value_hex
setformat,integer,d
opacity_display:=floor(opacity_h*100/255)
setformat,integer,hex


InputBox, opacity_value_dec,Set Transparency 0-100,transparency level can be set `nvalue =100 is dark ,,200,150,,,,20,%opacity_display%

if opacity_value_dec not between 0 and 100
  {
  msgbox error value  %opacity_value_dec% not between 0-100
  return
  }
setformat,integer,hex
op:=floor(opacity_value_dec*2.5)+1
StringTrimLeft, opacity_value_hex,op,2
IniWrite,%opacity_value_hex%, steins_gate.ini, parameters, opacity
setformat,integer,d
Gdip_DeleteBrush(pBrush)
background_color=0x%opacity_value_hex%000000
pBrush := Gdip_BrushCreateSolid(background_color)
return 

WM_LBUTTONDOWN(wParam, lParam)
{
global status_edit
    X := lParam & 0xFFFF
    Y := lParam >> 16
if status_edit and x>146 and x<158
{
gosub help_me
exit
}

 PostMessage, 0xA1, 2
}

help_me:
message=
(
Input

for alarmclock use hhmmss and ad +
(must be 6 digits and +)
5pm is 170000+ 

for simple timer use hhmmss format
no need for preceding zero's
10 min is 1000
max value is 59 
to set 60min use 10000


Enter confirm/end  setting
Right MouseButton clear
Esc   Leave dialog no value set

TimeOut no input is 10s!!!
)
MsgBox, %message%
exit
return


;-------------- hotkeys ------------------ 
!i::  ;hide/show hotkey
Gosub, toggle_hide
return

!o::
Menu, MyMenu,show
return
;-------------- hotkeys off -------------- 

hotkey_off:
Menu, tray,togglecheck,Set hotkeys off
Hotkey, !o,toggle
Hotkey, !i,toggle
hotkey,%timer_hotkey%,toggle
return
;-------------- hotkeys off-------------- 
toggle_hide:
toggle:=!toggle
if toggle
WinHide, ahk_id %hwnd%
Else, 
WinShow, ahk_id %hwnd%
return 



;-------------- write display text -------------- 

set_timercolor:
newcolor:=ChooseColorA( 0x2255ff)
if (newcolor<>"")
  timer_color=cff%newcolor%
IniWrite, %timer_color%,steins_gate.ini,parameters,timer_color
return

set_timer_t_color:
newcolor:=ChooseColorA( 0x2255ff)
if (newcolor<>"")
  timer_t_color=cff%newcolor%
IniWrite, %timer_t_color%,steins_gate.ini,parameters,timer_t_color
return

set_clockcolor:
newcolor:=ChooseColorA( 0x2255ff)
if (newcolor<>"")
  clock_color=cff%newcolor%
  
IniWrite, %clock_color%,steins_gate.ini,parameters,clock_color
return

save_position:
WinGetPos, posx,posy,,,ahk_id %hwnd%
IniWrite, %posx%,steins_gate.ini,parameters,positionx
IniWrite, %posy%,steins_gate.ini,parameters,positiony
return 


FormatSeconds(NumberOfSeconds) 
{
    time = 19990101 
    time += %NumberOfSeconds%, seconds
    FormatTime, mmss, %time%, mm : ss
    hours:=NumberOfSeconds//3600
    hours:=(hours ? hours : "00")
    return  hours " : " mmss  
}

gone_away:
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_DeleteBrush(pBrush)
Gdip_Shutdown(pToken)
ExitApp



;  By SKAN code for choosing color http://www.autohotkey.com/forum/topic59534.html

ChooseColorA( CR=0x0, hWnd=0x0, X=25, Y=25, Title=0, CustomColors=0, RGB=1 ) {
 ; Compact and Customised ChooseColor() 36L  -  Wrapped by SKAN ( arian.suresh@gmail.com )
 ; Topic: www.autohotkey.com/forum/viewtopic.php?t=59534  |  CD:23-Jun-2010 LM:23-Oct-2010
 Static CC, Color = "000000", S22 = "                      ", StrPut := "StrPut"
 If ! ( VarSetCapacity( CC ) ) {
 CCD =     ;       CHOOSECOLOR 36 Bytes + CustomColors 64 Bytes + DialogTemplate 576 Bytes
 ( LTrim Join
   24ZV47ZV8N8J808N8H8H8J808HC0C0CH80808HFFMFFIFFFFMFFGFFGFFIFFFFGFFFFFFGC020C88G8K1P9H9P4
   3G6FG6CG6FG72G2H2H2H2H2H2H2H2H2H2H2H2H2H2H2H2H2M8G4DG53G2H53G68G65G6CG6CG2H44G6CG67LBH3
   5N6AFF0FG8CG56GDG2FFFF82TBH35O5H3G8CG1CGD102FFFF82TB1H5O7G21G6AG36GC602FFFF82TB1H5N76G2
   1G13G36GBE02FFFF82TB1H5N6H5BG2AG1BGC502FFFF82V2025O7G5BG14HCGD602FFFF82G52G47G42G3AT2G8
   35N1BG5BG14HCGC202FFFF81T2G835N31G5BG14HCGC302FFFF81T2G835N47G5BG14HCGC402FFFF81V2025O7
   G69G14HCGD302FFFF82G48G4CG53G3AT2G835N1BG69G14HCGBF02FFFF81T2G835N47G69G14HCGCG2FFFF81T
   2G835N31G69G14HCGC102FFFF81S1J5O5G7AG87H1GE603FFFF82T1H35N5FG7FG28HEH1GFFFF8H4FG4BX35N2
   FG7FG2CHEH2GFFFF8H43G61G6EG63G65G6CS
 )
 Loop 20   ;  Decompressing Nulls : www.autohotkey.com/forum/viewtopic.php?p=198560#198560
  StringReplace,CCD,CCD,% Chr(70+21-A_Index),% SubStr("000000000000000000000",A_Index),All
 Loop % VarSetCapacity(CC,StrLen(CCD)//2,0)          ;  Creating Binary Structure from Hex
  NumPut( "0x" . SubStr(CCD, 2*A_Index-1,2),CC,A_Index-1,"Char" )       ; Thanks to Laszlo
 }
 Numput( &CC+100,CC,8 ), NumPut( &CC+36,CC,16 )   ; Pointers to CustomColors & DlgTemplate
 IfNotEqual,CustomColors,0, Loop, Parse, CustomColors, |          ; Applying Custom Colors
 _ := (A_LoopField<>"" && A_Index<17) ? NumPut("0x" A_LoopField,CC,36+(4*(A_Index-1))) : 0
 If ( Title )
 Title := SubStr( Title S22,1,22 )
,A_IsUnicode ? %StrPut%( Title, &CC+122, "utf-16" )
 : DllCall( "MultiByteToWideChar", Int,0,Int,0, Str,Title,UInt,22, UInt,&CC+122, UInt,44 )
 NumPut(Y,CC,112,"UShort"), NumPut(X,CC,110,"UShort"), NumPut(hWnd,CC,4) ; Y, X, Parent ID
 WinExist( "ahk_id" hWnd ) ? NumPut(0,CC,104) : 0 ; Parent specified, Remove WS_EX_TOPMOST
 RGB ? NumPut((((CR&0xFF)<<16)|(CR&0xFF00)|((CR&0xFF0000)>>16)),CC,12) : NumPut(CR,CC,12)
 If !DllCall( "comdlg32\ChooseColor" ( A_IsUnicode ? "W" : "A" ), UInt,&CC ) || ErrorLevel
  Return
 DllCall( "msvcrt\s" (A_IsUnicode ? "w": "" )  "printf", Str,Color, Str,"%06X", UInt, RGB
  ? ( (((CR:=Numget(CC,12) )&0xFF)<<16)|(CR&0xFF00)|((CR&0xFF0000)>>16)) : Numget(CC,12) )
Return Color
}