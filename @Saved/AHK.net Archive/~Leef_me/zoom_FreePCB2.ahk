#singleinstance force
SetTitleMatchMode, 2



;=============================================================================
; Zoom for FreePCB v0.01
; an Autohotkey script for FreePCB (pcb layout program)
; Written by Leef_me 
;
; Current hotkeys are as follows

/*

;=============================================================================
; these hotkeys are for interaction with FreePCB
; if FreePCB is not the active window, these hotkeys will not trigger
;=============================================================================
    :: is the symbol that marks the end of a hotkey 
     + means hold down the shift key, F1...F12 are those keys, esc means the escape key

	any single letters mean to press that letter
	for example press 'p' to toggle the 'parts' selection mask

 r::	; toggle ratsnest	

 +s::	; toggle top silk

 s::	; toggle bottom silk

 +t::	; toggle top copper

 t::	; toggle bottom copper


 p::	; toggle parts

 c::	; toggle copper areas

 b::	; toggle board outline

+a::	; all selection masks on

+n::	; no selection masks on

f:: 	; find a part by reference number


~F1::	; if a component's reference text is selected and you press F1
	; the Reference Text Properties window will be opened, Ahk will show a tooltip

	; the ~ this hotkey triggers in parallel with its normal action in FreePCB



While the Reference Text Properties window is open, these hotkeys are enabled

 c::	; copy component references properties, Units, char height, stroke width

 v::	; paste component references properties

 z::	; component references properties, switches to currently copied "Units"
	; so you can see if the setting for the current part reference match those previously copied


;=============================================================================
; these hotkeys help 'calibrate' the script to your system
;=============================================================================


+F1:: 	; mark and capture images of the "selection" and "selection mask" texts on FreePCB window

+F7::	; find all the checkboxes, needs to be done if you move FreePCB between monitors

;=============================================================================
; these hotkeys are related directly to AHk editing and debugging
;=============================================================================

F11::   listvars
F12::   reload ; reload the script
+F12::  edit	; edit the script
+esc::  exitapp ; exit the script


*/



;
;=============================================================================


; I am using an icon so I can easily see the system tray icon for this script 
;  disabled for now
;menu, tray, icon, 1321300762_dog.ico

;; for winboard
window= Reference Text Properties ahk_class #32770 

image1=one_square.bmp
select1=select1.bmp	; the word "selection" captured from the FreePCB window
select2=select2.bmp	; the words "selection mask" captured from the FreePCB window


sleeper=100

if 1	; screen coordinates
  coord=screen
else
  coord=relative
tooltip, %coord%
sleep, 500

CoordMode, ToolTip, %coord%
CoordMode, Pixel, %coord%
CoordMode, Mouse, %coord%
CoordMode, Caret, %coord%
CoordMode, Menu, %coord%
tooltip, % a_scriptdir
sleep, 500
tooltip, 

WinGetPos , xxX, yyY, ww ,hh, FreePCB - 

gosub read_parameters




return


#ifwinactive, FreePCB - 

;=============================================================================
; layers checkboxes
;=============================================================================

 r::	; toggle ratsnest
mousegetpos, mxx, myy
mouseclick, left, layerbox_X, layerbox7y
mousemove, mxx, myy
return

 +s::	; toggle top silk
mousegetpos, mxx, myy
mouseclick, left, layerbox_X, layerbox8y
mousemove, mxx, myy
return

 s::	; toggle bottom silk
mousegetpos, mxx, myy
mouseclick, left, layerbox_X, layerbox9y
mousemove, mxx, myy
return

 +t::	; toggle top copper
mousegetpos, mxx, myy
mouseclick, left, layerbox_X, layerbox16y
mousemove, mxx, myy
return

 t::	; toggle bottom copper
mousegetpos, mxx, myy
mouseclick, left, layerbox_X, layerbox13y
mousemove, mxx, myy
return
;=============================================================================
; mask checkboxes
;=============================================================================

 p::	; toggle parts
mousegetpos, mxx, myy
mouseclick, left, selbox_X, selbox1y
mousemove, mxx, myy
sleep, 100
return

 c::	; toggle copper areas
mousegetpos, mxx, myy
mouseclick, left, selbox_X, selbox7y
mousemove, mxx, myy
sleep, 100
return

 b::	; toggle board outline
mousegetpos, mxx, myy
mouseclick, left, selbox_X, selbox10y
mousemove, mxx, myy
return


+a::	; all selection masks on

color_2_click:=0xff0000 ;  red
goto click_color

+n::	; no selection masks on

color_2_click:=0x00ff00 ; green

click_color:

mousegetpos, mxx, myy	; save current mouse location so we can return later
loop, 11
{
  PixelGetColor, this_color, selbox_X, selbox%a_index%y, RGB 
;  msgbox % this_color
  if this_color = %color_2_click%
     mouseclick, left, selbox_X, selbox%a_index%y
}
mousemove, mxx, myy
return





;=============================================================================
; find a part
;=============================================================================

f:: 	; find a part by reference number

WinGetPos , xxX, yyY, ww ,hh, FreePCB - 
InputBox, q1, find ref, enter a reference to find,,200,120,xxx+500,yyy+500
if ErrorLevel
  return
else
StringUpper, q1, q1

 WinMenuSelectItem, FreePCB,, View, Show Part...
    if errorlevel
	oops(Errorlevel, A_LineNumber, A_LineFile, "WinMenuSelectItem")

tooltip, winwait
sleep, %sleeper%


  WinWait, 1, Reference designator , 3
  if errorlevel	
	oops(Errorlevel, A_LineNumber, A_LineFile, "WinWait")

;tooltip, send q1
sleep, %sleeper%

  Winactivate, 1, Reference designator

  send %q1%

sleep, %sleeper%
  send {enter}


tooltip, send should be done
sleep, %sleeper%

tooltip, 
return

;=============================================================================
;=============================================================================

~F1::	; if a component's reference text is selected and you press F1
	; the Reference Text Properties window will be opened, Ahk will show a tooltip

tooltip, wait
WinWaitActive , Reference Text Properties ahk_class #32770 , , 2, 
If ErrorLevel =1 
{
  tooltip,
  return
}
WinGetPos, xx, yy, ww, hh, %window% 
settimer, watch_ref,100
;listvars
;gui, show, x%xx% y%yy%, txt prop
gui, add, TEXT, x40 , Reference
gui, add, TEXT, xm, Units
gui, add, edit, yp x80 w60, %measure_unit1%
gui, add, TEXT, xm, char height
gui, add, edit, yp x80 w60, %measureh1%
gui, add, TEXT, xm, stroke width
gui, add, edit, yp x80 w60, %measurew1% 
xxa:=xx
yya:=yy-20
;gui, show, x%xxa% y%yya%, txt prop
;listvars
 tooltip, Units  height  width `r %measure_unit1% %a_tab% %measureh1% %a_tab% %measurew1% , xxa, yya

return

watch_ref:
ifwinnotexist, %window%
{
  tooltip
  settimer, watch_ref,off
}
return
;=============================================================================
;=============================================================================

#ifwinactive, Reference Text Properties ahk_class #32770 
;=============================================================================
; copy and paste text references
;=============================================================================

 c::	; copy component references properties, Units, char height, stroke width

Controlget, measure_unit1, choice, , ComboBox1, %window%
Controlgettext, measureh1,  Edit2, %window% 
Controlgettext, measurew1,  Edit3, %window% 
 tooltip, Units  height  width `r %measure_unit1% %a_tab% %measureh1% %a_tab% %measurew1% , xxa, yya
return

 v::	; paste component references properties, same as copy

Control, check, , Button1, %window%
Control, ChooseString, %measure_unit1%, ComboBox1, %window%
Control, check, , Button2, %window%

ControlSetText, Edit2, %measureh1%, %window% 
ControlSetText, Edit3, %measurew1%, %window% 

;send {enter}
return

 z::	; component references properties, switches to currently copied "Units"
	; so you can see if the setting for the current part reference match those previously copied

Control, check, , Button1, %window%
Control, ChooseString, %measure_unit1%, ComboBox1, %window%

;send {enter}
return



oops(Err, LineN, LineF, cmd)
{
  listvars
  msgbox, ,OOPS!,Command was %cmd%<<`nErrorlevel = %Err%`nA_LineNumber - %LineN%`nA_LineFile = %LineF%
}

#ifwinactive
;=============================================================================
;=============================================================================


#ifwinactive, FreePCB - 



+f1:: ; mark and capture images of the "selection" and "selection mask" texts on FreePCB window

capture_selection_mask:

KeyWait, LButton, D 

mousegetpos, s1x, s1y
tooltip, %s1x% %s1y%,s1x+100,,1

KeyWait, LButton, U 

mousegetpos, e1x, e1y

tooltip, %s1x% %s1y% %e1x% %e1y%,e1x+100,,1

;=================================

KeyWait, LButton, D 

mousegetpos, s2x, s2y
tooltip, %s2x% %s2y%,s2x+100,,2

KeyWait, LButton, U 

mousegetpos, e2x, e2y

tooltip, %s2x% %s2y% %e2x% %e2y%,e2x+100,,2

;WinGetPos , xxX, yyY, ww ,hh, FreePCB - 
;WinMove, FreePCB -, , xxX, yyY, ww ,hh

sleep, 100
WinSet, Redraw, , FreePCB - 

sleep, 500
filename=select
b_index=1
CaptureScreen(s1x "," s1y "," e1x "," e1y ","" ,", false, filename b_index ".bmp")

b_index=2
CaptureScreen(s2x "," s2y "," e2x "," e2y ","" ,", false, filename b_index ".bmp")

tooltip,,,,1
tooltip,,,,2
listvars

return
#include ScreenCapture.ahk



+f7::	; find all the checkboxes


mousegetpos, mxx, myy

WinGetPos, xx, yy, ww, hh, FreePCB
;mousemove, xx, yy
find_select_mask:

;====================================================================

WinGetPos, xx, yy, ww, hh, FreePCB - 

ImageSearch, FX, FY, xx,yy, xx+ww, yy+hh, *Trans0xffff00 %select1%
if ErrorLevel = 2
    MsgBox Could not conduct the search.
else if ErrorLevel = 1
  {
    MsgBox Icon could not be found on the screen. sel mask
      return
  } 
else
{
    mousemove, FX, FY, 10
 ;   MsgBox,,, The icon was found at %FX%x%FY%,2
}
ffx:=fx
ffy:=fy
fy-=20
loop, 16
{
  ImageSearch, fx, fy, xx,fy+5, xx+100, fy+300, *Trans0xffff00 %image1%
;  tooltip, %fx% %fy% %xx% %fy% %xx% 
  if ErrorLevel = 2
  {
      MsgBox Could not conduct the search. loop %a_index%
      return
  }
  else if ErrorLevel = 1
  {
      MsgBox Icon could not be found on the screen. loop %a_index%
      return
  } 
  else
  {
 ;   mousemove, FX, FY, 10
   ; MsgBox,,, The icon was found at %FX%x%FY%,
  ; sleep, 1000

    layerbox%a_index%y:=fy+8
    if a_INDEX = 1
	layerbox_X:=fX+8
  }
}

mousemove, layerbox_X, layerbox16y
;====================================================================

;====================================================================

ImageSearch, FX, FY, xx,yy, xx+ww, yy+hh, *Trans0xffff00 %select2%

if ErrorLevel = 2
  {
    MsgBox Could not conduct the search.
      return
  } 
else if ErrorLevel = 1
    MsgBox Icon could not be found on the screen. sel mask
else
{
;    MsgBox,,, The icon was found at %FX%x%FY%,2
    mousemove, FX, FY, 10
}
ffx:=fx
ffy:=fy

loop, 11
{
  ImageSearch, fx, fy, xx,fy+5, xx+100, fy+300, *Trans0xffff00 %image1%
;  tooltip, %fx% %fy% %xx% %fy% %xx% 
  if ErrorLevel = 2
  {
      MsgBox Could not conduct the search. loop %a_index%
      return
  }
  else if ErrorLevel = 1
      MsgBox Icon could not be found on the screen. loop %a_index%
  else
  {
;    MsgBox,,, The icon was found at %FX%x%FY%,2
;    mousemove, FX, FY, 10
    selbox%a_index%y:=fy+8
    if a_INDEX = 1
	selbox_X:=fX+8
  }
;  mousemove, mxx, myy
}


;====================================================================


mousemove, selbox_X, selbox11y
sleep, 100
mousemove, mxx, myy
tooltip,
;msgbox done

return


f11::listvars
f12::reload ; reload the script
+f12::edit	; edit the script
+esc::exitapp ; exit the script

#ifwinactive
;====================================================================
;====================================================================

read_parameters:

inifile=zoom_FreePCB.ini

IfExist, %inifile%
{
  ;------- read inifile




  param=xxX,yyY,ww,hh

  loop, parse, param, `,
    IniRead, %A_LoopField% , %inifile%, window, % A_LoopField



  loop, parse, param, `,
    IniRead, %A_LoopField% , %inifile%, screens, % A_LoopField


    selbox%a_index%y:=fy+8
    if a_INDEX = 1
	selbox_X:=fX+8

    layerbox%a_index%y:=fy+8
    if a_INDEX = 1
	layerbox_X:=fX+8







  param=Prim_montop,Prim_monleft,Prim_monright,Prim_monbottom,Prim_monwidth,Prim_monheight,toolbarx,toolbary
  loop, parse, param, `,
    IniRead, %A_LoopField% , %inifile%, screens, % A_LoopField


  monitor_offsetx+=Prim_monleft
  monitor_offsety+=Prim_montop

;  goto Normal_mode
}
return


write_parameters:
param=Prim_montop,Prim_monleft,Prim_monright,Prim_monbottom,Prim_monwidth,Prim_monheight
loop, parse, param, `,

  IniWrite, % %A_LoopField%, %inifile%, screens, % A_LoopField


return
