; Activehome X10 CM15a Command Library
; By Specter333,  I'm only half evil.
; Uses the Activehome SKD, http://www.activehomepro.com/sdk/sdk-info.html
; and the CM15a Transceiver found at http://www.x10.com
; If ahcmd.exe is not located at C:\Program Files\Common Files\X10\Common\ahcmd.exe you must
; change the file path in each command to it's location on your computer.
; Notes and an example at bottom.

; Updated 4/4/11.  ahcmd.exe location changed to common files.  The SDK notes state that Activehome
; installs the SKD in this file.  There should be no need to download it.

X10CM15a_PlcOn(code)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe  
	Run, %sdkfile% sendplc %code% On , , hide
	}
	
X10CM15a_PlcOff(code)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendplc %code% Off , , hide
	}
	
X10CM15a_PlcBright(code,percent)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendplc %code% Bright %percent% , , hide
	}
	
X10CM15a_PlcDim(code,percent)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendplc %code% Dim %percent% , , hide
	}
	
X10CM15a_RfOn(code)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendrf %code% On , , hide
	}
	
X10CM15a_RfOff(code)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendrf %code% Off , , hide
	}
	
X10CM15a_RfBright(code,percent)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendrf %code% Bright %percent% , , hide
	}
	
X10CM15a_RfDim(code,percent)
	{
	sdkfile = C:\Program Files\Common Files\X10\Common\ahcmd.exe 
	Run, %sdkfile% sendrf %code% Dim %percent% , , hide
	}
	
/*
Notes:
A typical X10 command is simply running the ahcmd.exe app and including the command.
A command may look something like this;
Run, C:\Program Files\Common Files\X10\Common\ahcmd.exe sendplc a1 On , , hide
The first part is the AHK run command and file path, then is the command you want to send.
"sendplc a1 On" is "Send power line command, house code a, unit code 1, turn on."  The "hide"
at the end keeps a Windows command prompt from popping up.  

Other commands are RF, Bright and Dim.  Use RF in place of Plc for sending radio commands.
Use Bright or Dim in place of on or off and include the percentage to brighten or dim the light.
An example of a Dim command over RF may look like this,
Run, C:\Program Files\AHSDK\bin\ahcmd.exe sendrf a1 dim 50 , , hide

Example Script:
Just enter your module's house code and unit code in the box, add the bright/dim percentage 
if using those commands.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, GroupBox, xm y+10 h40 w385, X10 Functions
Gui, Add, DDL, xp+5 yp+15 w50 vrfplc,Plc||Rf
Gui, Add, DDL, x+10 w50 vx10bank, A||B|C|D|E|F|G|H|I|J|K|L|M|N|O
Gui, Add, DDL, x+10 w50 vx10num, 1||2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
Gui, Add, DDL, x+10 w50 vx10cmd, On||Off|Bright|Dim
Gui, Add, ComboBox, x+10 w50 vx10dim, |0|10|20|30|40|50|60|70|80|90|100

Gui, Add, Button, x+10 w50 h20 gx10go, Go

Gui, Show, y0,X10 CM15A
Return

x10go: 
Gui, Submit, NoHide
If rfplc = Plc
	GoTo plc
If rfplc = Rf
	GoTo rf
Return

plc:
If x10cmd = On
	GoTo plcon
If x10cmd = Off
	GoTo plcoff
If x10cmd = Bright
	GoTo plcbright
If x10cmd = Dim
	GoTo plcdim
Return
	
plcon: 
code = %x10bank%%x10num%
X10CM15a_PlcOn(code)
Return

plcoff: 
code = %x10bank%%x10num%
X10CM15a_PlcOff(code)
Return

plcbright: 
code = %x10bank%%x10num%
X10CM15a_PlcBright(code,x10dim)
Return

plcDim: 
code = %x10bank%%x10num%
X10CM15a_PlcDim(code,x10dim)
Return

rf:
If x10cmd = On
	GoTo rfon
If x10cmd = Off
	GoTo rfoff
If x10cmd = Bright
	GoTo rfbright
If x10cmd = Dim
	GoTo rfdim
Return
	
rfon: 
code = %x10bank%%x10num%
X10CM15a_RfOn(code)
Return

rfoff: 
code = %x10bank%%x10num%
X10CM15a_RfOff(code)
Return

rfbright: 
code = %x10bank%%x10num%
X10CM15a_RfBright(code,x10dim)
Return

rfDim: 
code = %x10bank%%x10num%
X10CM15a_RfDim(code,x10dim)
Return

GuiClose:
ExitApp
*/
