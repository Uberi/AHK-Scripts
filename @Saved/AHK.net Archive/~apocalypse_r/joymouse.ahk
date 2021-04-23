;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

coordmode, mouse, screen
mousegetpos, px, py

iniread, cx, joymouse.ini, Left Analog, center_x, 50
iniread, cy, joymouse.ini, Left Analog, center_y, 50
iniread, drx, joymouse.ini, Left Analog, deadrange_x, 5
iniread, dry, joymouse.ini, Left Analog, deadrange_y, 5
iniread, lsensativity, joymouse.ini, Left Analog, sensativity, 1
iniread, cr, joymouse.ini, Right Analog, center_x, 50
iniread, cu, joymouse.ini, Right Analog, center_y, 50
iniread, drr, joymouse.ini, Right Analog, deadrange_x, 5
iniread, dru, joymouse.ini, Right Analog, deadrange_y, 5
iniread, rsensativity, joymouse.ini, Right Analog, sensativity, 1
iniread, hotkey1, joymouse.ini, Custom Hotkeys, upleft, %a_space%
iniread, hotkey2, joymouse.ini, Custom Hotkeys, downleft, %a_space%
iniread, hotkey3, joymouse.ini, Custom Hotkeys, upright, %a_space%

gui, add, text, , UpLeft
gui, add, edit, w150 vhotkey1, % nobrackets(hotkey1)
gui, add, text, , DownLeft
gui, add, edit, w150 vhotkey2, % nobrackets(hotkey2)
gui, add, text, , UpRight
gui, add, edit, w150 vhotkey3, % nobrackets(hotkey3)
gui, -sysmenu

lastl = U
lastr = U
if 1 = /PAUSE
  pause = 1
else
  pause = 0
last_r = 0
last_u = 0
shiftnext = 0
numnext = 0

loop
{
  if pause
  {
    sleep 16
    continue
  }
  getkeystate, mx, joyx
  getkeystate, my, joyy
  getkeystate, mr, joyr
  getkeystate, mu, joyu
  getkeystate, mz, joyz
  getkeystate, pov, joypov
  getkeystate, A, joy1
  getkeystate, B, joy2
  if pov <> 13500
  {
    if povl = 13500
      send, {lalt up}
  }
  if (pov <> -1)
  {
    povl := povcontrol(pov, mz, a_index)
  }
  else
  {
    povl = -1
  }
  if (lastl <> A)
  {
    if A = D
      send, {lbutton down}
    else
      send, {lbutton up}
    lastl = %a%
  }
  if (lastr <> B)
  {
    if B = D
      send, {rbutton down}
    else
      send, {rbutton up}
    lastr = %b%
  }
  if (abs(mx - cx) - drx < 0)
    mx := cx
  else if (mx < cx)
    mx := mx + drx
  else if (mx > cx)
    mx := mx - drx
  px := px + (mx - cx) * lsensativity
  if px > %a_screenwidth%
    px = %a_screenwidth%
  if px < 0
    px = 0
  if py > %a_screenheight%
    py = %a_screenheight%
  if py < 0
    py = 0
  if abs(my - cy) - dry < 0
    my := cy
  else if (my < cy)
    my := my + dry
  else if (my > cy)
    my := my - dry
  py := py + (my - cy) * lsensativity
  if (abs(mr - cr) - drr < 0)
    pr = 0
  else if (mr < cr)
    pr := 20 / ((mr + drr - cr) * rsensativity)
  else if (mr > cr)
    pr := 20 / ((mr - drr - cr) * rsensativity)
  if (abs(mu - cu) - dru < 0)
    pu = 0
  else if (mu < cu)
    pu := 20 / ((mu + dru - cu) * rsensativity)
  else if (mu > cu)
    pu := 20 / ((mu - dru - cu) * rsensativity)
  if (pr > 0)
  {
    if (a_index - last_r >= abs(pr))
    {
      loop, % 1 + floor(1 / abs(pr))
        scrolldown()
      last_r = %a_index%
    }
  }
  if (pr < 0)
  {
    if (a_index - last_r >= abs(pr))
    {
      loop, % 1 + floor(1 / abs(pr))
        scrollup()
      last_r = %a_index%
    }
  }
  if (pu > 0)
  {
    if (a_index - last_u >= abs(pu))
    {
      loop, % 1 + floor(1 / abs(pu))
        scrollright()
      last_u = %a_index%
    }
  }
  if (pu < 0)
  {
    if (a_index - last_u >= abs(pu))
    {
      loop, % 1 + floor(1 / abs(pu))
        scrollleft()
      last_u = %a_index%
    }
  }
  mousemove, %px%, %py%, 0
  sleep, 16
}

joy3::			;X button
send, {mbutton}
return

joy4::			;Y button
send, {lwin}
return

joy5::			;Left Button
getkeystate, z, joyz
if z < 25
  shiftnext := 1 - shiftnext
else
  send, {backspace}
return

joy6::			;Right Button
getkeystate, z, joyz
if z > 75
  numnext := 1 - numnext
else
  send, {enter}
return

joy7::			;Select
gosub, calibrate
return

^lbutton::		;Ctrl + Left Mouse Button

joy8::			;Start
pause := 1 - pause
return

calibrate:
pause = 1
getkeystate, jxmin, joyx
jxmax = %jxmin%
getkeystate, jymin, joyy
jymax = %jymin%
getkeystate, jrmin, joyr
jrmax = %jrmin%
getkeystate, jumin, joyu
jumax = %jumin%
msgbox, Even while calibrating, this and other message boxes can be dismissed with the Right Button. (RB)
msgbox, This system personalizes the controller you have to work best with this system.`nStep 1 - move the analog sticks around in their dead spots.  Push lightly, but do not move the sticks into anything other than their neutral range.`nWhen you are finished, press A, or press B to skip this step.
loop
{
  getkeystate, jx, joyx
  if (jx > jxmax)
    jxmax = %jx%
  if (jx < jxmin)
    jxmin = %jx%
  getkeystate, jy, joyy
  if (jy > jymax)
    jymax = %jy%
  if (jy < jymin)
    jymin = %jy%
  getkeystate, jr, joyr
  if (jr > jrmax)
    jrmax = %jr%
  if (jr < jrmin)
    jrmin = %jr%
  getkeystate, ju, joyu
  if (ju > jumax)
    jumax = %ju%
  if (ju < jumin)
    jumin = %ju%
  getkeystate, A, joy1
  getkeystate, B, joy2
  if (A = "D" or B = "D")
    break
}
if B = U
{
  xc := (jxmin + jxmax) / 2
  drx := xc - jxmin
  yc := (jymin + jymax) / 2
  dry := yc - jymin
  rc := (jrmin + jrmax) / 2
  drr := rc - jrmin
  uc := (jumin + jumax) / 2
  dru := uc - jumin
}
msgbox, This next step calibrates the speed of mouse movement.  When the messagebox is dismissed, you should see the mouse moving back and forth between two places.  Tilt the left stick horizontally to change the sensitivity.`nLonger mouse movement means higher sensitivity.`nWhen you have chosen your sensitivity, without releasing the stick, click the left stick button.
lsensativity := modify("joy9", "joyx")
msgbox, The final step calibrates the scroll speed.  Perform the same actions as in the previous test, except using the right stick instead of the left.
rsensativity := modify("joy10", "joyu")
savesettings()
pause = 0
return

scrollup()
{
  ControlGetFocus, control, A
  SendMessage, 0x115, 0, 0, %control%, A
  return
}

scrolldown()
{
  ControlGetFocus, control, A
  SendMessage, 0x115, 1, 0, %control%, A
  return
}

scrollleft()
{
  ControlGetFocus, control, A
  SendMessage, 0x114, 0, 0, %control%, A
  return
}

scrollright()
{
  ControlGetFocus, control, A
  SendMessage, 0x114, 1, 0, %control%, A
  return
}

^rbutton::
pause = 1
gui, show, w170 h146, DPad hotkeys
return

guiclose:
gui, submit, nohide
savesettings()
gui, hide
return

modify(button, axis)
{
  global px, py
  loop
  {
    getkeystate, jx, %axis%
    mousemove, %jx%, %jx%, 0, R
    mousemove, %px%, %py%, 0
    getkeystate, b, %button%
    if b = D
      return (jx / 50)
  }
}

nobrackets(str)
{
  stringreplace, str, str, {, , A
  stringreplace, str, str, }, , A
  return str
}

nhotkey(number)
{
  global shiftnext
  if shiftnext = 1
  {
    shiftnext = 0
    if number = 0
      return chr(33)
    else if number = 1
      return chr(64)
    else if number = 2
      return chr(35)
    else if number = 3
      return chr(36)
    else if number = 4
      return chr(37)
    else if number = 5
      return chr(94)
    else if number = 6
      return chr(38)
    else if number = 7
      return chr(42)
    else if number = 8
      return chr(40)
    else if number = 9
      return chr(41)
    else if number = 10
      return chr(126)
    else if number = 11
      return chr(95)
    else if number = 12
      return chr(43)
    else if number = 13
      return chr(123)
    else if number = 14
      return chr(125)
    else if number = 15
      return chr(124)
    else if number = 16
      send, {printscreen}
    else if number = 20
      send, !{printscreen}
  }
  else if number < 9
    return chr(number + 49)
  else if number = 9
    return chr(48)
  else if number = 10
    return chr(96)
  else if number = 11
    return chr(45)
  else if number = 12
    return chr(61)
  else if number = 13
    return chr(91)
  else if number = 14
    return chr(93)
  else if number = 15
    return chr(92)
  else if number = 16
    send, {volume_up}
  else if number = 18
    send, {volume_mute}
  else if number = 20
    send, {volume_down}
  else if (number >= 24 and number <= 35)
    send, % "{F" . floor(number - 23) . "}"
  return ""
}

ahotkey(number)
{
  global shiftnext
  if shiftnext = 1
  {
    shiftnext = 0
    if (number >= 0 and number <= 15)
      return chr(number + 65)
    else if number = 16
      send, {pgup}
    else if number = 17
      send, {del}
    else if number = 18
      send, {end}
    else if number = 19
      send, {ins}
    else if number = 20
      send, {pgdn}
    else if number = 21
      send, {pause}
    else if number = 22
      send, {home}
    else if number = 23
      send, {esc}
    else if (number >= 24 and number <= 33)
      return, % chr(number + 57)
    else if number = 34
      return, "<"
    else if number = 35
      return, ">"
    else if number = 36
      return, "?"
    else if number = 37
      return, ";"
    else if number = 38
      return, ":"
    else if number = 39
      return, """"
  }
  else if (number >= 0 and number <= 15)
    return, chr(number + 97)
  else if number = 16
    send, {UP}
  else if number = 18
    send, {RIGHT}
  else if number = 19
    send, {alt down}
  else if number = 20
    send, {DOWN}
  else if number = 22
    send, {LEFT}
  else if (number >= 24 and number <= 33)
    return, chr(number + 89)
  else if number = 34
    send, {Space}
  else if number = 35
    return "."
  else if number = 36
    return a_tab
  else if number = 37
    return ","
  else if number = 38
    return "/"
  else if number = 39
    return "'"
  return ""
}

specialhotkey(number)
{
  global hotkey1, hotkey2, hotkey3
  if number = 23
    send, %hotkey1%
  else if number = 21
    send, %hotkey2%
  else if number = 17
    send, %hotkey3%
}

savesettings()
{
  global
  filedelete, joymouse.ini
  loop, 7
    stringlower, hotkey%a_index%, hotkey%a_index%, 
  loop, 7
  {
    index = %a_index%
      hotkey%a_index% := nobrackets(hotkey%a_index%)
    loop, 24
      stringreplace, hotkey%index%, hotkey%index%, F%a_index%, {F%a_index%}
  }
  fileappend, [left analog]`ncenter_x="%cx%"`ncenter_y-"%cy%"`ndeadrange_x="%drx%"`ndeadrange_y="%dry%"`nsensativity="%lsensativity%"`n[right analog]`ncenter_x="%cr%"`ncenter_y-"%cu%"`ndeadrange_x="%drr%"`ndeadrange_y="%dru%"`nsensativity="%rsensativity%"`n[Custom Hotkeys]`nupleft=%hotkey1%`ndownleft=%hotkey2%`nupright=%hotkey3%, joymouse.ini
  return
}

povcontrol(pov, axis, index)
{
  global numnext, shiftnext, povtime, povl
  if (index - povtime = 4 and pov = povl)
  {
    if (axis > 95)
    {
      if numnext
        sendraw, % nhotkey(pov / 4500)
      else
        sendraw, % ahotkey(pov / 4500)
    }
    else if (axis <= 95 and axis > 55)
    {
      if numnext
        sendraw, % nhotkey(pov / 4500 + 8)
      else
        sendraw, % ahotkey(pov / 4500 + 8)
    }
    else if (axis <= 55 and axis >= 45)
    {
      if numnext
        sendraw, % nhotkey(pov / 4500 + 16)
      else
        sendraw, % ahotkey(pov / 4500 + 16)
    }
    else if (axis < 45 and axis >= 5)
    {
      if numnext
        sendraw, % nhotkey(pov / 4500 + 24)
      else
        sendraw, % ahotkey(pov / 4500 + 24)
    }
    else if (axis < 5)
    {
      if numnext
        sendraw, % nhotkey(pov / 4500 + 32)
      else
        sendraw, % ahotkey(pov / 4500 + 32)
    }
  }
  else if (index - povtime = 12 and pov = povl and axis <= 55 and axis >= 45)
  {
    specialhotkey(pov / 4500 + 16)
  }
  else if (mod(index - povtime, 30) = 5 and pov = povl and pov = 13500 and axis <= 55 and axis >= 45 and shiftnext = 0 and numnext = 0)
    send, {tab}
  else if (mod(index - povtime + 5, 10) = 9 and pov = povl and (pov = 0 or pov = 18000) and axis <= 55 and axis >= 45 and shiftnext = 0 and numnext = 1)
  {
    if pov = 0
      send, {volume_up}
    if pov = 18000
      send, {volume_down}
  }
  else if (pov <> povl)
    povtime = %index%
  if (povl = 13500 and pov <> 13500)
    send, {alt up}
  return pov
}