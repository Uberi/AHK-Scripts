; Mouse Moves V1.1, Added mouse click commands.
; Moves the mouse pointer a set number of pixels.  Either
; to an absolute positing in the active window or a relative
; position to the current mouse coordinates.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SplitPath, A_ScriptDir, , OutDir,
SetWorkingDir %OutDir%
#NoTrayIcon
#SingleInstance Force

WinGetPos, posx, posy, , , EasyAutoEdit AHK,
showx := posx+402
showy := posy+290

rora = 
Gui, Font, s14 , Verdana Bold Italic
Gui, Add, Text, x150 y5, Mouse Moves
Gui, Font, s8 , Arial
Gui, Add, Button, x330 y5 w20 h20 ghelp, ?
Gui, add, Button, x355 y5 w20 h20 gexit, X

Gui, Add, Tab2,x5 y5 Buttons, Click|Send|Mode
Gui, Tab, 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Gui, Add, GroupBox, x5 y30 w100 h50, Down or Up
Gui, Add, DDL, x10 y50 w90 vUpDown gFillEdit, Both||Down|Up

Gui, Add, GroupBox, x110 y30 w105 h50, Button or Wheel
Gui, Add, DDL, x115 y50 w95 vBorW gFillEdit, Left||Middle|Right|X1|X2|WheelDown|WheelUp

Gui, Add, GroupBox, x220 y30 w75 h50, X
Gui, Add, Edit, x225 y50 w65 Right vXcoor gFillEdit,
Gui, Add, UpDown, Range-2048-2048, 0

Gui, Add, GroupBox, x300 y30 w75 h50, Y
Gui, Add, Edit, x305 y50 w65 Right vYcoor gFillEdit,
Gui, Add, UpDown, Range-2048-2048, 0

Gui, Add, GroupBox, x5 y85 w50 h50 Center, Count
Gui, Add, Edit, x10 y105 w40 r1 Number Right vCcount gFillEdit,
Gui, Add, UpDown, Range1-99, 1

Gui, Add, GroupBox, x60 y85 w75 h50, Where
Gui, Add, Radio, x65 y100 Checked vRscreen gFillEdit, Absolute
Gui, Add, Radio, x65 y115 vRrel gFillEdit, Relative

Gui, Add, GroupBox, x140 y85 w235 h50, Use This Click Command
Gui, Add, Button, x145 y105 w225 vClickCmd gSendT1,

Gui, Add, Text, x5 y140 w370, Down or Up - Both=normal click, Down=holds button, Up=releases button. 
Gui, Add, Text, x5 y160 w370, Button or Wheel - "Down or Up" is not active when "Wheel" is selected.
Gui, Add, Text, x5 y180 w370, X- Y- Horizontal and Verticle steps to move.
Gui, Add, Text, x5 y200 w370, Count - Number of times to click button or turn wheel.
Gui, Add, Text, x5 y220 w370, Where - Absolute = Moves to exact coordinates on screen or in active window.  First use "Mode" tab to preselect.
Gui, Add, Text, x5 y250 w370, Where - Relative = Moves relative to current mouse position.  CoordMode has no effect when "Relative" is selected.

Gui, Add, Edit, x5 y250 w370 r1 Hidden vClickCmd2, 

Gui, Tab, 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, GroupBox, x5 y35 w115 h100,
Gui, Add, Radio, x15 y50 Checked vrada grada, Absolute
Gui, Add, Radio, x15 y70 vradr gradr, Relative
Gui, Add, Text, x12 y87 w105 BackgroundTrans vARtext, Use mode tab to select CoordMode screen or window.

Gui, Add, GroupBox, x135 y35 w110 h100,
Gui, Add, Edit, x145 y50 w75 r1 Right vmx gmx,
Gui, Add, UpDown, Range-2048-2048, 0
Gui, Add, Edit, x145 y80 w75 r1 Right vmy gmy,
Gui, Add, UpDown, Range-2048-2048, 0
Gui, Add, Edit, x145 y110 w75 r1 Number Right vspeed,
Gui, Add, UpDown, Range0-100, 0
Gui, Font, s10, Verdana Bold Italic
Gui, Add, Text, x225 y50, X
Gui, Add, Text, x225 y80, Y
Gui, Add, Text, x225 y110, S

Gui, Font, s8, Arial

Gui, Add, GroupBox, x260 y35 w115 h100,
Gui, Add, Text, x265 y60 w105 r2 Center, Use These Coordinates
Gui, Add, Button, x265 y95 w105 vMcoord gSend, 

Gui, Add, GroupBox, x260 y140 w115 h130,
Gui, Add, Text, x265 y155 w105 Center, Mouse Clicks
Gui, Add, ComboBox, x265 y175 w105 vsmode, Send||SendInput|SendRaw|SendPlay
Gui, Add, ComboBox, x265 y205 w105 vsclick, |{Lbutton}|{RButton}|{Mbutton}|{WheelDown}|{WheelUp}|{XButton1}|{XButton2}|{Lbutton down}|{Lbutton up} ;click
Gui, Add, Button, x270 y240 w95 gSendClick, Send Click

Gui, Font, s9, Arial 
Gui, Add, Text, x5 y140, Uses seperate commands for move and click.
Gui, Font, s8, Arial
Gui, Add, Text, x5 y165, Absolute - Moves to exact coordinates on screen
Gui, Add, Text, x5 y180, or in active window.  Set CoordMode first. 
Gui, Add, Text, x5 y200, Relative - Moves from current Mouse position.
Gui, Add, Text, x5 y220, X - Horizontal coordinates.
Gui, Add, Text, x5 y240, Y - Verticle coordinates.
Gui, Add, Text, x5 y260, S - Speed, 0 = Fastest, 100 = Slowest.

Gui, Tab, 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, GroupBox, x5 y30 w370 h55, CoordMode, Mouse
Gui, Add, Radio, x10 y50 w100 Checked vRT3S gRT3, Screen
Gui, Add, Radio, x10 y65 w100 vRT3A gRT3, Active Window
Gui, Add, Button, x130 y50 w220 vSetMode gSetMode, Set CoordMode Screen
Gui, Add, Text, x5 y90 w370, 
(Join
When "Absolute" is selected on the "Click" or "Send" tabs "CoordMode, Mouse" sets
 whether to move the mouse to the coordinates on the screen or
 in the active window.`n`nFor example, if the coordinates X0, Y0 are chosen
 , "Screen" will move the cursor to the top left corner of the monitor.  
 "Active Window" will move the cursor to the top left corner of the active
 window regardless of it's position on the monitor.`n`nIf "Relative" is selected
 on the "Click" or "Send" tabs then the mouse moves relative to it's current
 position and CoordMode has no effect.`n`nSet the CoordMode BEFORE using mouse
 moves or clicks.
 )

;   Show   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, -Caption +ToolWindow
Gui, Show, x%showx% y%showy% h280 w380, Cmd Mouse Moves
Return

;;;;;;;;;;;;;; Tab 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FillEdit:
Gui, Submit, NoHide
If UpDown = Both
	UpDown = 
Else UpDown = %UpDown%
If BorW = WheelDown
	{
	GuiControl, , UpDown, |Both|Down|Up
	UpDown = 
	}
If BorW = WheelUp
	{
	GuiControl, , UpDown, |Both|Down|Up
	UpDown = 
	}
StringReplace, Xcoor, Xcoor, `,, , A 
StringReplace, Ycoor, Ycoor, `,, , A 
XYcoor = , %Xcoor%, %Ycoor%,
If XYcoor = , 0, 0,
	XYcoor =
If Rscreen = 1
	SR = 
If Rrel = 1
	SR = Rel
GuiControl, , ClickCmd, Click %UpDown%%XYcoor% %BorW%, %Ccount%, %SR%
GuiControl, , ClickCmd2, Click %UpDown%%XYcoor% %BorW%, %Ccount%, %SR%
Return

SendT1:
Gui, Submit, NoHide
eaemsg = %ClickCmd2%
SendMessage, 0x0C, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0x0C, 0, &eaemsg, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return

;;;;;;;;;;;;;; Tab 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rada:
Gui, Submit, NoHide
If rada = 1
	{
	rora =
	GuiControl, , ARtext, Use mode tab to select on screen or active window.
	}
	
Return
radr:
Gui, Submit, NoHide
If radr = 1
	{
	rora = R
	GuiControl, , ARtext, CoordMode has no effect when "Relative" is selected.
	}
Return

mx:
my:
Gui, Submit, NoHide
StringReplace, mx, mx, `,, , A 
StringReplace, my, my, `,, , A 
GuiControl, , Mcoord, X%mx%  Y%my%
Return

Send:
Gui, Submit, NoHide
If speed =
	speed = 0
If mx = 
	mx = 0
If my = 
	my = 0
StringReplace, mx, mx, `,, , A 
StringReplace, my, my, `,, , A 
eaemsg = MouseMove, %mx%, %my%, %speed% , %rora% 
SendMessage, 0x0C, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0x0C, 0, &eaemsg, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return

SendClick:
Gui, Submit, NoHide
If sclick = 
	Return
eaemsg2 = %smode%, %sclick%
SendMessage, 0x0C, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0x0C, 0, &eaemsg2, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return

;;;;;;;;;;;;;; Tab 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RT3:
Gui, Submit, NoHide
If RT3S = 1
	GuiControl, , SetMode, Set CoordMode Screen
If RT3A = 1
	GuiControl, , SetMode, Set CoordMode Active Window
Return

SetMode:
Gui, Submit, NoHide
If RT3S = 1
	eaemsg3 = CoordMode, Mouse, Screen
If RT3A = 1
	eaemsg3 = CoordMode, Mouse, Relative `; Active Window
SendMessage, 0x0C, 0, "CMD", Edit2, EasyAutoEdit AHK 
SendMessage, 0x0C, 0, &eaemsg3, Edit3, EasyAutoEdit AHK 
SendMessage, 0xC, 0, "Yes", Edit5, EasyAutoEdit AHK 
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
help:
Run, AutoHotkey.exe "Help\Easy Automation AHK Help.ahk" "" "" "Cmd Mouse Moves.ahk"
Return

exit:
GuiClose:
Gui, destroy
ExitApp
