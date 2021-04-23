/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\The Alex Jones Radio Show.exe
No_UPX=1
Created_Date=1
Execution_Level=3
[VERSION]
Set_Version_Info=1
Company_Name=Aaron Bewza Music
File_Description=The Alex Jones Radio Show
File_Version=1.0.0.0
Inc_File_Version=0
Internal_Name=The Alex Jones Radio Show
Legal_Copyright=Aaron Bewza Music
Original_Filename=The Alex Jones Radio Show
Product_Name=The Alex Jones Radio Show
Product_Version=1.0.0.0
Language_ID=42
[ICONS]
Icon_1=%In_Dir%\icon.ico

* * * Compile_AHK SETTINGS END * * *
*/

/*
----------------------- Version History ------------------------->>
v1.00 - March 14th 2012 - built beta script, should need nothing
-----------------------------------------------------------------<<

Adobe Flash Player is required!

*/

Version = 1.00
BuildDate = March 14th 2012

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Gui, Color, 000000 ; Black background for slider control
Gui, Add, Slider, x2 y10 w220 h30 -Theme Thick25 NoTicks Range0-100 Center vVolumeControl gVolumeGLabel AltSubmit, 100 ; Last number is position of slider (0 - 100)
Gui, Add, Button, x222 y12 w40 h26 -Theme gMuteVolumeButton, Mute
Gui, Font, cFFFFFF s16 q5
Gui, Add, Text, x270 y10 w165 h30 vVolumeDisplay +Left +0x200 BackgroundTrans, Volume: 100`%
Gui, Add, ActiveX, x0 y0 h0 w0 vStation, Shell.Explorer
Gui, Show, w440 h50, The Alex Jones Radio Show
Station.Navigate("http://www.infowars.com/audiobox.html")
Station.silent := true
Return

VolumeGLabel: ; Sets volume, controlled by slider
	Gui, Submit, NoHide
	SoundSet, %VolumeControl%, Wave
	GuiControl,, VolumeDisplay, Volume: %VolumeControl%`%
Return

MuteVolumeButton:
	toggle := !toggle ; Toggles "Mute" button for on/off effect
	If toggle
		{
			GuiControl, Text, VolumeDisplay, Volume: (muted)
			GuiControl, Disable, VolumeControl
			SoundSet, 0, Wave
		}
	If !toggle
		{
			Gui, Submit, NoHide
			GuiControl, Text, VolumeDisplay, Volume: %VolumeControl%`%
			GuiControl, Enable, VolumeControl
			SoundSet, %VolumeControl%, Wave
		}
Return

GuiClose:
ExitApp