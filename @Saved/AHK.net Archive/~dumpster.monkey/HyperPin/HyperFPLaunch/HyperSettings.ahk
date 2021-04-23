;HyperPin Settings Gui v0.5 by dumspter.monkey
;AHK_L is needed to recompile
;todo:
;  visual pinbal reg settings page
;  darkfalls stuff
;  pimame1.6
;  startup and shutdown ahks for multiple programs
;  links in about
;  autoupdate  


SetBatchLines, -1 ;speedup
#SingleInstance force      ;Prevent Multiple instances
#InstallKeybdHook
SetTitleMatchMode 2        ;Use relaxed title matching
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetFormat, Float, 0.2

scriptDir = %A_ScriptDir%\
fplaunchDir = %A_ScriptDir%\HyperFPLaunch\
imagesDir = %A_ScriptDir%\HyperFPLaunch\Images\
hyperini = %A_ScriptDir%\Settings\Settings.ini
FileRead, hyperini_read, %hyperini%
keycodeini = %A_ScriptDir%\HyperFPLaunch\keycodes.ini
FileRead, keycodeini_read, %keycodeini%
Fichier_de_Config = %A_ScriptDir%\HyperFPLaunch\HyperSettings
hypersetini = %A_ScriptDir%\HyperFPLaunch\HyperSettings.ini
FileRead, hypersetini_read, %hypersetini%
helpfile = %A_ScriptDir%\HyperFPLaunch\help.html
FileRead, helpfile_read, %helpfile%
versions = %A_ScriptDir%\HyperFPLaunch\versions.txt
IfNotExist, %A_ScriptDir%\HyperFPLaunch
    FileCreateDir, %A_ScriptDir%\HyperFPLaunch
IfNotExist, %A_ScriptDir%\HyperPin.exe 
{
 MsgBox, 48, HyperPin not Found, HyperSettings must be in the same directory as HyperPin.exe
 ExitApp
}  
	
bgcolor := A_OSVersion = "WIN_7" ? "#EFEFEF" : "#EFEBDE" 

version = 0.6
Gosub readInis

aboutText = 
( 
HyperSettings GUI by dumpster.monkey (samwyze)

A quick and dirty settings editor, created because I got sick of
recompiling FPLaunch just to change a key or setting.

Many thanks to all who helped develop this version of HyperFPLaunch including, but
not limited to:

Blur, for his hard work at troubleshooting and ironing out MANY bugs in FPLaunch, 
keeping the project alive and pushing it forward, supporting users and giving ALOT
of his time.
	
BigBoss for the use of his incorperated scripts for setting sound levels, hardware
render options, and vp exe selections based on simple txt files
	
Rosve for the script additions needed to run b2s tables (and for b2s tables!).

DNA Disturber for use of pinemhi distributed with this release, as well as his custom
swf files.

The various ahk gurus, whose functions and libraries I plagarised heavily :p

All forum users who bothered to post bugs,suggestions or improvements. Without the
active forum I would never have bothered to post the original script, let alone 
develop it.

See About Tabs 'HELP' for a list of links.

I'm sure I've missed someone, so THANKS to anyone I forgot!
)	 

;set values needed for up/down increments at 0.05 instead of 1.0
udRangeLow := .5
udRangeHigh := 1
udCurrentValue := hyperScale
udIncrement := 0.05
udPrevVal := udCurrentValue

;create tabbed gui
Gui, +HWNDsettingsHwnd
Gui, Add, Tab2, x0 y0 w420 h550 vhTab, Main|Video|Future Pinball|Visual Pinball|Wheel|Controls|Startup and Shutdown|HyperFPLaunch|Update|About

;------------------------Main Tab------------------------;
Gui, Tab, Main

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, HYPERPIN   MAIN   SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90, Starting Genre
Gui, Add, DropDownList, x100 y100 w100 r4 vStarting_Genre Choose%Starting_Genre%, All Games|Future Pinball|Visual Pinball|Favorites

Gui, Add, GroupBox, x5 y130 w203 h154 Center, Volume
Gui, Add, Text, x10 y160 w70, Master Volume
Gui, Add, Slider, x79 y160 w100 vMaster_Volume gMVolumeUpdate, %Master_Volume%
Gui, Add, Edit, x178 y159 w27 vMVolume ReadOnly, %Master_Volume%
Gui, Add, Text, x10 y190 w70, Video Volume
Gui, Add, Slider, x79 y190 w100 vVideo_Volume gVVolumeUpdate, %Video_Volume%
Gui, Add, Edit, x178 y189 w27 vVVolume ReadOnly, %Video_Volume%
Gui, Add, Text, x10 y220 w70, FX Volume
Gui, Add, Slider, x79 y220 w100 vSound_FX_Volume gFXVolumeUpdate, %Sound_FX_Volume%
Gui, Add, Edit, x178 y219 w27 vFXVolume ReadOnly, %Sound_FX_Volume%
Gui, Add, Text, x10 y250 w70, Wheel Volume
Gui, Add, Slider, x79 y250 w100 vWheel_Sound_Volume gWVolumeUpdate, %Wheel_Sound_Volume%
Gui, Add, Edit, x178 y249 w27 vWVolume ReadOnly, %Wheel_Sound_Volume%

Gui, Add, GroupBox, x5 y290 w203 h124 Center, Attract Mode
Gui, Add, Text, x10 y324 w90, Active
Gui, Add, DropDownList, x100 y320 w100 r2 vActive Choose%Active%, true|false
Gui, Add, Text, x10 y354 w90, Delay
Gui, Add, Edit, x100 y350 w100 -multi number vTimeE gCheckTimeED
Gui, Add, UpDown, vTime gCheckTimeUD, %Time%
Gui, Add, Text, x10 y384 w90, Max Spin Time
Gui, Add, Edit, x100 y380 w100 -multi number limit2 vMaxSpinTimeE gCheckSpinTimeED
Gui, Add, UpDown, vMaxSpinTime Range3-10 wrap gCheckSpinTimeUD, %MaxSpinTime%

Gui, Add, GroupBox, x5 y420 w203 h94 Center, Intro Video
Gui, Add, Text, x10 y454 w90, Use Intro
Gui, Add, DropDownList, x100 y450 w100 r2 vUse_Intro Choose%Use_Intro% , true|false
Gui, Add, Text, x10 y484 w90, Skip On Keypress
Gui, Add, DropDownList, x100 y480 w100 r2 vSkip_On_Keypress Choose%Skip_On_Keypress%, true|false

Gui, Add, GroupBox, x210 y130 w203 h154 Center, Press Start Text
Gui, Add, Text, x215 y164 w90 , Enabled
Gui, Add, DropDownList, x305 y160 w100 r2 vEnabled Choose%Enabled%, true|false
Gui, Add, Text, x215 y194 w90, Text Line 1
Gui, Add, Edit, x305 y190 w100 vText1 -multi, %Text1%
Gui, Add, Text, x215 y224 w90, Text Line 2
Gui, Add, Edit, x305 y220 w100 vText2 -multi, %Text2%

Gui, Add, GroupBox, x210 y241 w203 h43 left, Text Colour
Gui, Add, text, x220 y259 -multi, 0x
Gui, Add, Edit, x+0 y256 w54 uppercase -multi vnewColor gCheckIsColor, %MainTextColor%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%MainTextColor% vtextCol
Gui, Add, Button, x330 y254 gStartTextColor, Colour Picker

Gui, Add, GroupBox, x210 y290 w203 h124 Center, Instruction Card
Gui, Add, Text, x215 y324 w90 viWidth, Width
Gui, Add, Edit, x305 y320 w100 number, %iWidth%
Gui, Add, Text, x215 y354 w90, BottomX
Gui, Add, Edit, x305 y350 w100 viBottomX number, %iBottomX%
Gui, Add, Text, x215 y384 w90, CenterY
Gui, Add, Edit, x305 y380 w100 viCenterY number, %iCenterY%

Gui, Add, GroupBox, x210 y420 w203 h94 Center, Flyer
Gui, Add, Text, x215 y454 w90, BottomX
Gui, Add, Edit, x305 y450 w100 vfBottomX number, %fBottomX%
Gui, Add, Text, x215 y484 w90, CenterY
Gui, Add, Edit, x305 y480 w100 vfCenterY number, %fCenterY%

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;-----------------------Video Tab-----------------------;
Gui, Tab, Video

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, HYPERPIN  VIDEO  SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90, Playfield Monitor
Gui, Add, DropDownList, x100 y100 w100 r2 vPlayfield_Monitor Choose%Playfield_Monitor%, Primary|Secondary
Gui, Add, Text, x10 y164 w90, Playfield Rotation
Gui, Add, DropDownList, x100 y160 w100 r4 vPlayfield_Rotation Choose%Playfield_Rotation%, 0|90|180|270
Gui, Add, Text, x10 y224 w90, Backglass Monitor
Gui, Add, DropDownList, x100 y220 w100 r2 vBackglass_Monitor Choose%Backglass_Monitor%, Primary|Secondary
Gui, Add, Text, x10 y284 w90, Quality
Gui, Add, DropDownList, x100 y280 w100 r4 vQuality Choose%Quality%, LOW|MEDIUM|HIGH|BEST
Gui, Add, Text, x10 y344 w90, Show Table Video
Gui, Add, DropDownList, x100 y340 w100 r2 vTable_Video_Enabled Choose%Table_Video_Enabled%, true|false
Gui, Add, Text, x10 y404 w90, Table Video Offset
Gui, Add, Edit, x100 y400 w100 vTable_Video_Offset number, %Table_Video_Offset%
Gui, Add, Text, x10 y464 w90, Table Video Buffer
Gui, Add, Edit, x100 y460 w100 vTable_Video_Buffer number, %Table_Video_Buffer%

Gui, Add, Text, x215 y104 w90, Use Backglass
Gui, Add, DropDownList, x305 y100 w100 r2 vUse_Backglass Choose%Use_Backglass%, true|false
Gui, Add, Text, x215 y164 w90, Backglass x
Gui, Add, Edit, x305 y160 w100 vBackglass_Image_x number, %Backglass_Image_x%
Gui, Add, Text, x215 y224 w90, Backglass y
Gui, Add, Edit, x305 y220 w100 vBackglass_Image_y number, %Backglass_Image_y%
Gui, Add, Text, x215 y284 w90, Backglass w
Gui, Add, Edit, x305 y280 w100 vBackglass_Image_w number, %Backglass_Image_w%
Gui, Add, Text, x215 y344 w90, Backglass h
Gui, Add, Edit, x305 y340 w100 vBackglass_Image_h number, %Backglass_Image_h%
Gui, Add, Text, x215 y397 w90, Backglass Rotation
Gui, Add, DropDownList, x305 y400 w100 r4 vBackglass_Image_r Choose%Backglass_Image_r%, 0|90|180|270
Gui, Add, Text, x215 y464 w90, Backglass Delay
Gui, Add, Edit, x305 y460 w100 vBackglass_Delay number, %Backglass_Delay%

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;------------------Future Pinball Tab-------------------;
Gui, Tab, Future Pinball

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, FUTURE  PINBALL  SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90 h30 , Show Games
Gui, Add, DropDownList, x100 y100 w100 h20 r2 vfpShow_Games Choose%fpShow_Games%, true|false
Gui, Add, GroupBox, x5 y146 w408 h44 right, Future Pinball Executable
Gui, Add, Text, x10 y165 w290 vfpExe, %fpPath%%fpExe%
Gui, Add, Button, x361 y160 gfpGetExe, Browse
Gui, Add, GroupBox, x5 y206 w408 h44 right, Table Path
Gui, Add, Text, x10 y225 w290 vfpTable_Path, %fpTable_Path%
Gui, Add, Button, x361 y220 gfpGetTable, Browse
Gui, Add, GroupBox, x5 y266 w408 h44 right, Table Video Path
Gui, Add, Text, x10 y285 w290 vfpTable_Video_Path, %fpTable_Video_Path%
Gui, Add, Button, x361 y280 gfpGetVidPath, Browse
Gui, Add, GroupBox, x5 y326 w408 h44 right, Table Image Path
Gui, Add, Text, x10 y345 w290 vfpTable_Image_Path, %fpTable_Image_Path%
Gui, Add, Button, x361 y340 gfpGetPicPath, Browse
Gui, Add, GroupBox, x5 y386 w408 h44 right, Backglass Image Path
Gui, Add, Text, x10 y405 w290 vfpBackglass_Image_Path, %fpBackglass_Image_Path%
Gui, Add, Button, x361 y400 gfpGetBackPicPath, Browse 

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;------------------Visual Pinball Tab-------------------;
Gui, Tab, Visual Pinball

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, VISUAL   PINBALL   SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90 h30 , Show Games
Gui, Add, DropDownList, x100 y100 w100 h20 r2 vvpShow_Games Choose%vpShow_Games%, true|false
Gui, Add, GroupBox, x5 y146 w408 h44 right, Visual Pinball Executable
Gui, Add, Text, x10 y165 w290 vvpExe, %vpPath%%vpExe%
Gui, Add, Button, x361 y160 gvpGetExe, Browse
Gui, Add, GroupBox, x5 y206 w408 h44 right, Table Path
Gui, Add, Text, x10 y225 w290 vvpTable_Path, %vpTable_Path%
Gui, Add, Button, x361 y220 gvpGetTable, Browse
Gui, Add, GroupBox, x5 y266 w408 h44 right, Table Video Path
Gui, Add, Text, x10 y285 w290 vvpTable_Video_Path, %vpTable_Video_Path%
Gui, Add, Button, x361 y280 gvpGetVidPath, Browse
Gui, Add, GroupBox, x5 y326 w408 h44 right, Table Image Path
Gui, Add, Text, x10 y345 w290 vvpTable_Image_Path, %vpTable_Image_Path%
Gui, Add, Button, x361 y340 gvpGetPicPath, Browse
Gui, Add, GroupBox, x5 y386 w408 h44 right, Backglass Image Path
Gui, Add, Text, x10 y405 w290 vvpBackglass_Image_Path, %vpBackglass_Image_Path%
Gui, Add, Button, x361 y400 gvpGetBackPicPath, Browse 

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;-----------------------Wheel Tab------------------------;
Gui, Tab, Wheel

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, HYPERPIN WHEEL SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90 , Speed
Gui, Add, DropDownList, x100 y100 w100 r3 vSpeed Choose%Speed%, low|med|high
Gui, Add, Text, x10 y164 w90, Font Style
Gui, Add, DropDownList, x100 y160 w100 r5 vText_Font Choose%Text_Font%, Style1|Style2|Style3|Style4|Style5
Gui, Add, Text, x10 y224 w90, Stroke Size
Gui, Add, Edit, x100 y220 w100 vText_Stroke_Size number -multi, %Text_Stroke_Size%
Gui, Add, GroupBox, x5 y264 w203 h43 left, Text Stroke Colour
Gui, Add, text, x15 y283 -multi, 0x
Gui, Add, Edit, x+0 y280 w54 uppercase -multi vnewStrokeColor gCheckStrokeColor, %Text_Stroke_Color%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%Text_Stroke_Color% vStrokeCol
Gui, Add, Button, x125 y278 gTextStrokeColor, Colour Picker
Gui, Add, GroupBox, x5 y324 w203 h43 left, Text Colour 1
Gui, Add, text, x15 y343 -multi, 0x
Gui, Add, Edit, x+0 y340 w54 uppercase -multi vnewTxtColor1 gCheckTxtColor1, %Text_Color1%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%Text_Color1% vTxtCol1
Gui, Add, Button, x125 y338 gTxtColor1, Colour Picker
Gui, Add, GroupBox, x5 y384 w203 h43 left, Text Colour 2
Gui, Add, text, x15 y403 -multi, 0x
Gui, Add, Edit, x+0 y400 w54 uppercase -multi vnewTxtColor2 gCheckTxtColor2, %Text_Color2%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%Text_Color2% vTxtCol2
Gui, Add, Button, x125 y398 gTxtColor2, Colour Picker
Gui, Add, GroupBox, x5 y444 w203 h43 left, Text Colour 3
Gui, Add, text, x15 y463 -multi, 0x
Gui, Add, Edit, x+0 y460 w54 uppercase -multi vnewTxtColor3 gCheckTxtColor3, %Text_Color3%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%Text_Color3% vTxtCol3
Gui, Add, Button, x125 y458 gTxtColor3, Colour Picker

Gui, Add, Text, x215 y100 w70 , Colour Ratio (Gradient)
Gui, Add, Slider, x284 y100 w100 Range1-255 vColor_Ratio gColorRatioUpdate, %Color_Ratio%
Gui, Add, Edit, x383 y99 w27 vRatio ReadOnly, %Color_Ratio%
Gui, Add, Text, x215 y164 w90, Shadow Distance
Gui, Add, Edit, x305 y160 w100 vShadow_Distance number, %Shadow_Distance%
Gui, Add, Text, x215 y220 w70, Shadow Angle
Gui, Add, Slider, x284 y220 w100 Range0-359 vShadow_Angle gShadowAngleUpdate, %Shadow_Angle%
Gui, Add, Edit, x383 y219 w27 vAngle ReadOnly, %Shadow_Angle%
Gui, Add, GroupBox, x210 y264 w203 h43 left, Shadow Colour
Gui, Add, Text, x220 y283 -multi, 0x
Gui, Add, Edit, x+0 y280 w54 uppercase -multi vnewShadowColor gCheckShadowColor, %Shadow_Color%
Gui, Add, ListView, x+5 h20 w35 ReadOnly 0x4000 +Background%Shadow_Color% vShadowCol
Gui, Add, Button, x330 y278 gShadowColor, Colour Picker
Gui, Add, Text, x215 y340 w90, Shadow Alpha
Gui, Add, CheckBox, x305 y340 w100 vShadow_Alpha Checked%Shadow_Alpha%
Gui, Add, Text, x215 y404 w90, Shadow Blur
Gui, Add, Edit, x305 y400 w100 vShadow_Blur number, %Shadow_Blur%

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;--------------------Controls Tab------------------------;
Gui, Tab, Controls

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, HYPERPIN  INPUT  SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y100, Key Delay
Gui, Add, DropDownList, x100 y100 r2 vKey_Delay Choose%Key_Delay%, true|false

Gui, Add, Edit, x10 y150 w85 ReadOnly, Start
Gui, Add, Edit, x94 y150 w28 vStart gCheckStart Limit3, %Start%
Gui, Add, Edit, x121 y150 w60 ReadOnly vREALStart, %REALStart%
Gui, Add, Button, x181 y149 h22 gSetStart, Set Key
Gui, Add, Edit, x230 y150 w52 gCheckStartBut vpwStart Limit8, %pwStart%
Gui, Add, Edit, x281 y150 w37 ReadOnly vREALpwStart, %REALpwStart%
Gui, Add, Button, x318 y149 h22 gSetStartButton, Set Button

Gui, Add, Edit, x10 y171 w85 ReadOnly, Exit
Gui, Add, Edit, x94 y171 w28 vExit gCheckExit Limit3, %Exit%
Gui, Add, Edit, x121 y171 w60 ReadOnly vREALExit, %REALExit%
Gui, Add, Button, x181 y170 h22 gSetExit, Set Key
Gui, Add, Edit, x230 y171 w52  gCheckExitBut vpwExit Limit8, %pwExit%
Gui, Add, Edit, x281 y171 w37 ReadOnly vREALpwExit, %REALpwExit%
Gui, Add, Button, x318 y170 h22 gSetExitButton, Set Button

Gui, Add, Edit, x10 y192 w85 ReadOnly, Up
Gui, Add, Edit, x94 y192 w28 vUp gCheckUp Limit3, %Up%
Gui, Add, Edit, x121 y192 w60 ReadOnly vREALUp, %REALUp%
Gui, Add, Button, x181 y191 h22 gSetUp, Set Key
Gui, Add, Edit, x230 y192 w52 gCheckExitBut vpwUp Limit8, %pwUp%
Gui, Add, Edit, x281 y192 w37 ReadOnly vREALpwUp, %REALpwUp%
Gui, Add, Button, x318 y191 h22 gSetUpButton, Set Button

Gui, Add, Edit, x10 y213 w85 ReadOnly, Down
Gui, Add, Edit, x94 y213 w28 vDown gCheckDown Limit3, %Down%
Gui, Add, Edit, x121 y213 w60 ReadOnly vREALDown, %REALDown%
Gui, Add, Button, x181 y212 h22 gSetDown, Set Key
Gui, Add, Edit, x230 y213 w52 Limit8 vpwDown gCheckDownBut, %pwDown%
Gui, Add, Edit, x281 y213 w37 ReadOnly vREALpwDown, %REALpwDown%
Gui, Add, Button, x318 y212 h22 gSetDownButton, Set Button

Gui, Add, Edit, x10 y234 w85 ReadOnly, Skip Up
Gui, Add, Edit, x94 y234 w28 vSkipUp gCheckSkipUp Limit3, %SkipUp%
Gui, Add, Edit, x121 y234 w60 ReadOnly vREALSkipUp, %REALSkipUp%
Gui, Add, Button, x181 y233 h22 gSetSkipUp, Set Key
Gui, Add, Edit, x230 y234 w52 Limit8 vpwSkipUp gCheckSkipUpBut, %pwSkipUp%
Gui, Add, Edit, x281 y234 w37 ReadOnly vREALpwSkipUp, %REALpwSkipUp%
Gui, Add, Button, x318 y233 h22 gSetSkipUpButton, Set Button

Gui, Add, Edit, x10 y255 w85 ReadOnly, Skip Down
Gui, Add, Edit, x94 y255 w28 vSkipDown gCheckSkipDown Limit3, %SkipDown%
Gui, Add, Edit, x121 y255 w60 ReadOnly vREALSkipDown, %REALSkipDown%
Gui, Add, Button, x181 y254 h22 gSetSkipDown, Set Key
Gui, Add, Edit, x230 y255 w52 Limit8 vpwSkipDown gCheckSkipDownBut, %pwSkipDown%
Gui, Add, Edit, x281 y255 w37 ReadOnly vREALpwSkipDown, %REALpwSkipDown%
Gui, Add, Button, x318 y254 h22 gSetSkipDownButton, Set Button

Gui, Add, Edit, x10 y276 w85 ReadOnly, Flyer
Gui, Add, Edit, x94 y276 w28 vFlyer gCheckFlyer Limit3, %Flyer%
Gui, Add, Edit, x121 y276 w60 ReadOnly vREALFlyer, %REALFlyer%
Gui, Add, Button, x181 y275 h22 gSetFlyer, Set Key
Gui, Add, Edit, x230 y276 w52 Limit8 vpwFlyer gCheckFlyerBut, %pwFlyer%
Gui, Add, Edit, x281 y276 w37 ReadOnly vREALpwFlyer, %REALpwFlyer%
Gui, Add, Button, x318 y275 h22 gSetFlyerButton, Set Button

Gui, Add, Edit, x10 y297 w85 ReadOnly, Instruction Card
Gui, Add, Edit, x94 y297 w28 vInstruction gCheckInstruction Limit3, %Instruction%
Gui, Add, Edit, x121 y297 w60 ReadOnly vREALInstruction, %REALInstruction%
Gui, Add, Button, x181 y296 h22 gSetInstruction, Set Key
Gui, Add, Edit, x230 y297 w52 Limit8 vpwInstruction gCheckInstructionBut, %pwInstruction%
Gui, Add, Edit, x281 y297 w37 ReadOnly vREALpwInstruction, %REALpwInstruction%
Gui, Add, Button, x318 y296 h22 gSetInstructionButton, Set Button

Gui, Add, Edit, x10 y318 w85 ReadOnly, Genre
Gui, Add, Edit, x94 y318 w28 vGenre gCheckGenre Limit3, %Genre%
Gui, Add, Edit, x121 y318 w60 ReadOnly vREALGenre, %REALGenre%
Gui, Add, Button, x181 y317 h22 gSetGenre, Set Key
Gui, Add, Edit, x230 y318 w52 Limit8 vpwGenre gCheckGenreBut, %pwGenre%
Gui, Add, Edit, x281 y318 w37 ReadOnly vREALpwGenre, %REALpwGenre%
Gui, Add, Button, x318 y317 h22 gSetGenreButton, Set Button

Gui, Add, Edit, x10 y339 w85 ReadOnly, Service
Gui, Add, Edit, x94 y339 w28 vService gCheckService Limit3, %Service%
Gui, Add, Edit, x121 y339 w60 ReadOnly vREALService, %REALService%
Gui, Add, Button, x181 y338 h22 gSetService, Set Key
Gui, Add, Edit, x230 y339 w52 Limit8 vpwService gCheckServiceBut, %pwService%
Gui, Add, Edit, x281 y339 w37 ReadOnly vREALpwService, %REALpwService%
Gui, Add, Button, x318 y338 h22 gSetServiceButton, Set Button

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;----------------Startup and Shutdown--------------------;
Gui, Tab, Startup and Shutdown

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, START  AND  EXIT  SETTINGS ; cED9F0D
Gui, Font

Gui, Add, GroupBox, x5 y100 w408 h97 Center, Startup Program
Gui, Add, Text, x10 y124 w90, Executable
Gui, Add, Edit, x100 y120 w258 vsExecutable, %sExecutable%
Gui, Add, Button, x361 y119 gsExecutable, Browse
Gui, Add, Text, x10 y149 w90, Working Directory
Gui, Add, Edit, x100 y145 w258 vsWorking_Directory, %sWorking_Directory%
Gui, Add, Button, x361 y144 gsWorking_Directory, Browse
Gui, Add, Text, x10 y174 w90, Parameters
Gui, Add, Edit, x100 y170 w170 vsParameters, %sParameters%
Gui, Add, Text, x276 y174 w100, Winstate
Gui, Add, DropDownList, x324 y170 w83 r4 vsWinstate Choose%sWinstate%, NORMAL|MINIMIZED|MAXIMIZED|HIDDEN

Gui, Add, GroupBox, x5 y200 w408 h97 Center, Exit Program
Gui, Add, Text, x10 y224 w90, Executable
Gui, Add, Edit, x100 y220 w258 veExecutable, %eExecutable%
Gui, Add, Button, x361 y219 geExecutable, Browse
Gui, Add, Text, x10 y249 w90, Working Directory
Gui, Add, Edit, x100 y245 w258 veWorking_Directory, %eWorking_Directory%
Gui, Add, Button, x361 y244 geWorking_Directory, Browse
Gui, Add, Text, x10 y274 w90, Parameters
Gui, Add, Edit, x100 y270 w170 veParameters, %eParameters%
Gui, Add, Text, x276 y274 w100, Winstate
Gui, Add, DropDownList, x324 y270 w83 r4 veWinstate Choose%eWinstate%, NORMAL|MINIMIZED|MAXIMIZED|HIDDEN

Gui, Add, GroupBox, x5 y300 w408 h108 Center, HyperPin Exit
Gui, Add, Text, x10 y324 w90, Enable Exit Screen
Gui, Add, DropDownList, x105 y320 w90 r2 vEnable_Exit_Screen Choose%Enable_Exit_Screen%, true|false
Gui, Add, Text, x220 y324 w90, Enable Shortcut 
Gui, Add, DropDownList, x317 y320 w90 r2 vEnable_Shortcut Choose%Enable_Shortcut%, true|false
Gui, Add, Text, x10 y354 w90, Show Shutdown
Gui, Add, DropDownList, x105 y350 w90 r2 vShutdown Choose%Shutdown%, true|false
Gui, Add, Text, x220 y354 w90, Shortcut Action
Gui, Add, DropDownList, x317 y350 w90 r2 vShortcut_Action Choose%Shortcut_Action%, exit|shutdown
Gui, Add, Text, x10 y384 w100, Show Exit HyperPin
Gui, Add, DropDownList, x105 y380 w90 r2 vExit_HyperPin Choose%Exit_HyperPin%, true|false
Gui, Add, Text, x220 y384 w90, Shortcut Time
Gui, Add, Edit, x317 y380 w90 vShortcut_TimeE gShortcut_TimeE number, %Shortcut_Time% 
Gui, Add, UpDown, vShortcut_TimeUD range0-5 wrap gShortcut_TimeUD, %Shortcut_Time%

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;----------------HyperFPLaunch Tab--------------------;
Gui, Tab, HyperFPLaunch

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, HYPERFPLAUNCH SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90, Exit Script Key(s)
Gui, Add, Edit, x100 y100 w40 Limit5 vexitScriptKey, %exitScriptKey%
Gui, Add, Button, x141 y99 h22 gSetExitScript, Set Key
Gui, Add, Text, x10 y144 w90, Toggle Cursor Key
Gui, Add, Edit, x100 y140 w40 vtoggleCursorKey Limit1, %toggleCursorKey%
Gui, Add, Button, x141 y139 h22 gSetToggleCursor, Set Key
Gui, Add, Text, x10 y184 w90, Hide Cursor
Gui, Add, DropDownList, x100 y180 w90 r2 vhideCursor Choose%hideCursor%, true|false
Gui, Add, Text, x10 y224 w90, Hide Desktop
Gui, Add, DropDownList, x100 y220 w90 r2 vhideDesktop Choose%hideDesktop%, true|false
Gui, Add, Text, x10 y264 w90, Hide Taskbar
Gui, Add, DropDownList, x100 y260 w90 r2 vhideTaskbar Choose%hideTaskbar%, true|false
Gui, Add, Text, x10 y297 w90, Use Exit Countdown
Gui, Add, DropDownList, x100 y300 w90 r2 vuseExitCountdown Choose%useExitCountdown%, true|false
Gui, Add, DropDownList, x100 y340 w90 r2 vuseExitMenu Choose%useExitMenu%, true|false
Gui, Add, Text, x10 y344 w90, Use Exit Menu
Gui, Add, Text, x10 y384 w90, Use Quick Pause
Gui, Add, DropDownList, x100 y380 w90 r2 vusePause Choose%usePause%, true|false
Gui, Add, Text, x10 y424 w90, Quick Pause Key
Gui, Add, Edit, x100 y420 w40 Limit1 vpauseKey, %pauseKey%
Gui, Add, Button, x141 y419 h22 gSetPause, Set Key
Gui, Add, Text, x10 y464 w90, Use Load Screen
Gui, Add, DropDownList, x100 y460 w90 r2 vuseLoadScreen Choose%useLoadScreen%, true|false
Gui, Add, Text, x220 y97 w90, Show PINemHi Scores with menu
Gui, Add, DropDownList, x317 y100 w90 r2 vmenuDMD Choose%menuDMD%, true|false
Gui, Add, Text, x220 y144 w90, PINemHi Style
Gui, Add, DropDownList, x317 y140 w90 r3 vdmdSTYLE Choose%dmdSTYLE%, DMD|HyperPin Blue|HyperPin White
Gui, Add, Text, x220 y184 w90, Image Scale
Gui, Add, Edit, x317 y180 w74 vudCurrentValue,%udCurrentValue%
Gui, Add, UpDown, x391 y180 w12 h20 Range-1-1 -16 gUDChange vudVal, 0
Gui, Add, Text, x220 y224 w90, Use FP Subfolders
Gui, Add, DropDownList, x317 y220 w90 r2 vfpSubfolders Choose%fpSubfolders%, true|false
Gui, Add, Text, x220 y264 w90, Pause FP Set as
Gui, Add, DropDownList, x317 y260 w90 r3 vpauseFPKey Choose%pauseFPKey%, LButton|MButton|RButton
Gui, Add, Text, x220 y297 w90, Control HyperPin using
Gui, Add, DropDownList, x317 y300 w90 r3 vcontrolWith Choose%controlWith%, keyboard|gamepad|both
Gui, Add, Text, x220 y344 w90, Plunger Key
Gui, Add, Edit, x317 y340 w40 vplungerKey Limit1, %plungerKey%
Gui, Add, Button, x358 y339 h22 gSetPlunger, Set Key
Gui, Add, Text, x220 y384 w90, Coin 1 Key
Gui, Add, Edit, x317 y380 w40 vcoin1Key Limit1, %coin1Key%
Gui, Add, Button, x358 y379 h22 gSetCoin1, Set Key
Gui, Add, Text, x220 y424 w90, Save FP Tables
Gui, Add, DropDownList, x317 y420 w90 r2 vsaveFPTables Choose%saveFPTables%, true|false
Gui, Add, Text, x220 y464 w90, Use LEDWiz MOD
Gui, Add, DropDownList, x317 y460 w90 r2 vLEDwiz Choose%LEDwiz%, true|false

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;-------------------Update Tab-----------------------;
Gui, Tab, Update

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, UPDATE     HYPERFPLAUNCH ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104 w90, Auto Update
Gui, Add, DropDownList, x100 y100 w90 r2 vautoUpdate Choose%autoUpdate%, true|false
 
Gui, Add, ActiveX, x10 y130 w398 h262 vWB, HTMLFile
UInfo =
( Join
<html><body bgcolor="%bgcolor%"><div align="center"><font face="Tahoma" size="2">
Press the <em>gigantic</em> button below to check for updates<br />
</div></body></html>
)
WB.Write(UInfo)

Gui, Add, GroupBox, x5 y400 w408 h97 Center
Gui, Add, Button, x9 y410 w400 h82 gUpdates, Check For Updates

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;---------------------------------------------------;
;-------------------About Tab-----------------------;
Gui, Tab, About

Gui, Add, Progress, x3 y44 w329 h26 Background261800 +0x400000 ;border
Gui, Font, s17, Arial
Gui, Add, Text, x5 y45 w390 h50 hwndhText cFFAB0F BackgroundTrans, ABOUT    HYPER    SETTINGS ; cED9F0D
Gui, Font

Gui, Add, Text, x10 y104, %aboutText%

Gui, Add, Button, x354 y45 w60 gHelp, Help
Gui, Add, Button, x230 y520 w60 gCancelandQuit, Cancel
Gui, Add, Button, x292 y520 w60 gApply, Apply
Gui, Add, Button, x354 y520 w60 gOkayandQuit, OK
;---------------------------------------------------;
Gui, Show, w420 h550,HyperPin Settings Editor version %version%
Return
;--------------------SubRoutines-------------------;
Updates:
If !ConnectedToInternet() {
 msgbox, 48, No Internet, Could not connect to internet`nEnsure you are online and retry
 Return
}
FileRead, versions_read, %versions%
FileDelete, %A_Temp%\versions.txt
UrlDownloadToFile, http://www.autohotkey.net/~dumpster.monkey/HyperPin/HyperFPLaunch/versions.txt, %A_Temp%\versions.txt
FileRead, remoteVersions, %A_Temp%\versions.txt
FileDelete, %A_ScriptDir%\HyperFPLaunch\updates.txt
FileDelete, %A_ScriptDir%\HyperFPLaunch\updateText.html
If (versions_read = remoteVersions) {
  UInfo = 
	  ( Join
	    <html><body bgcolor="%bgcolor%"><div align="center"><font 
	    face="Tahoma" size="2"><strong>All files current, no updates necessary</strong></div></body></html>
	  )
 WB.Write(UInfo)
 }
Else {
  WB.Close
  updates = 
  customs = 
  remoteVersions =  %A_Temp%\versions.txt
    Loop 
   { 
     FileReadLine, tmp1, %versions%, %A_Index% 
     FileReadLine, tmp2, %remoteVersions%, %A_Index% 
     
	 If ErrorLevel != 0 
        break 
     
	 StringLeft, isSection, tmp2, 1

	 If (isSection = "[") {
	   StringLeft, isSection, tmp2, 2
       If (isSection = "[e")
	    remUrl = %scriptDir%|http://www.autohotkey.net/~dumpster.monkey/HyperPin/
	   Else If (isSection = "[p")
	    remUrl = %imagesDir%|http://www.autohotkey.net/~dumpster.monkey/HyperPin/HyperFPLaunch/Images/
	  Else	
		remUrl = %fplaunchDir%|http://www.autohotkey.net/~dumpster.monkey/HyperPin/HyperFPLaunch/
	  Continue
	 }
    
	StringReplace, tmp1, tmp1, %A_Space%,, All
	StringReplace, tmp2, tmp2, %A_Space%,, All
	StringLeft, remoteFile, tmp2, (InStr(tmp2, "=")-1)
	StringTrimLeft, remoteVer, tmp2, InStr(tmp2, "=") 
	StringLeft, localFile, tmp1, (InStr(tmp1, "=")-1)
	StringTrimLeft, localVer, tmp1, InStr(tmp1, "=") 
	If (localVer = "")
      localVer = Not Found	
	
	If( tmp2 == tmp1 ) {
	  UInfo = 
	  ( Join
	    <html><body bgcolor="%bgcolor%"><div align="left"><font face="Tahoma" size="1">Local File: <strong>%localFile% </strong>
		Version: <strong>%localVer% </strong>Status: <font color="green"><strong>Current</strong></font><br /></div></body></html>
	  )
	  WB.Write(UInfo)
	  Continue
	}
	If (localVer = "custom") {
	  customs++
	  UInfo = 
	  ( Join
       <html><body bgcolor="%bgcolor%"><div align="left"><font face="Tahoma" size="2"><strong>CUSTOM FILE FOUND: </strong>%remoteFile%<br />
	   <font size="1">Avaliable Online: <font color="green"><strong>%remoteVer%</strong></font><br /></div></body></html>
      )
	  WB.Write(UInfo) 
	  Continue
	}
	updates++
	UInfo = 
	( Join
     <html><body bgcolor="%bgcolor%"><div align="left"><font face="Tahoma" size="2"><strong>UPDATE FOUND: </strong>%remoteFile%<br />
	 <font size="1">Local Version: <font color="red"><strong>%localVer% </strong></font>
	 Avaliable Online: <font color="green"><strong>%remoteVer%</strong></font><br /></div></body></html>
    )
	WB.Write(UInfo) 
	FileAppend, %remUrl%%remoteFile%`n, %A_ScriptDir%\HyperFPLaunch\updates.txt
  }
  if (updates > 0)
    msgbox, 36, Updates Found, %updates% update(s) found.`nCustom files will not be updated.`n`nDownload now?
  else
    msgbox, 48, No Updates, %customs% Custom file(s) will not be updated.
  IfMsgBox Yes
    Gosub updateNow  
}
Return

updateNow:
 updated = 
 FileDelete, %A_Temp%\UPDfiles.txt
 Loop 
   { 
	 FileReadLine, updateLine, %A_ScriptDir%\HyperFPLaunch\updates.txt, %A_Index% 
     StringTrimLeft, updateURL, updateLine, InStr(updateLine, "|") 
	 StringTrimLeft, updateFile, updateLine, InStr(updateLine, "/",0,0)
	 StringLeft, localDir, updateLine, (InStr(updateLine, "|")-1)
	 localPath := localDir . updateFile
	 
	 If ErrorLevel != 0 
        break 

	If ( InternetFileRead( binData, updateUrl ) > 0 && !ErrorLevel )
        If VarZ_Save( binData, localPath )
        {
            Sleep 500
            DLP( False ) ; or use Progress, off
        }
    DllCall( "FreeLibrary", UInt,DllCall( "GetModuleHandle", Str,"wininet.dll") )    
	updated++
	FileAppend, %localPath%<br />, %A_Temp%\UPDfiles.txt
	}
	updateUrl = http://www.autohotkey.net/~dumpster.monkey/HyperPin/HyperFPLaunch/versions.txt
	localPath = %A_ScriptDir%\HyperFPLaunch\versions.txt
	If ( InternetFileRead( binData, updateUrl,,,"No-Progress" ) > 0 && !ErrorLevel )
        If VarZ_Save( binData, localPath )
        {
            Sleep 500
            DLP( False ) ; or use Progress, off
        }
    DllCall( "FreeLibrary", UInt,DllCall( "GetModuleHandle", Str,"wininet.dll") ) 
	WB.Close
	FileRead, UPDfiles, %A_Temp%\UPDfiles.txt
	UInfo = 
	( Join
     <html><body bgcolor="%bgcolor%"><div align="left"><font face="Tahoma" size="2"><strong>UPDATE COMPLETE: </strong>%updated%
	 File(s) Downloaded<br /><font size="1">%UPDfiles%</div></body></html>
    )
	WB.Write(UInfo)
Return

Help:
Filedelete, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
GuiControlGet, tabName,,hTab
tabNameM := "[" . tabName
nameLength := (StrLen(tabNameM)+11)
helpText := StrX(helpfile_read, tabNameM,1,nameLength,"[",1,4)
FileAppend, 
( Join
<html><body leftmargin="10" topmargin="10"><div align="left"><p><font 
 face="Tahoma" size="2">
 )
 , %A_ScriptDir%\HyperFPLaunch\helpTemp.html
FileAppend, %helpText%, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
FileAppend, </div></body></html>, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
URL=file:///%A_ScriptDir%\HyperFPLaunch\helpTemp.html
title:=tabName . " Settings Help"
Options := "HtmDisable=0, HtmW=380, HtmH=480, Title=" . title
HtmDlg(URL, settingsHwnd, Options)
Return

Apply:
Gui, Submit, Nohide
Gosub writeinis
Filedelete, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
Return

OkayandQuit:
Gui, Submit, Nohide
Gosub writeinis
Gui, Destroy
Filedelete, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
Exitapp


CancelandQuit:
GuiClose:
Gui, Destroy
Filedelete, %A_ScriptDir%\HyperFPLaunch\helpTemp.html
Exitapp

UDChange:
   GuiControlGet udCurrentValue
   udCurrentValue := udCurrentValue + udVal * udIncrement
   If (udCurrentValue < udRangeLow)
      udCurrentValue := udRangeLow
   Else If (udCurrentValue > udRangeHigh)
      udCurrentValue := udRangeHigh
   GuiControl, , udCurrentValue, %udCurrentValue%
   GuiControl, , udVal, 0
   hyperScale := udCurrentValue
Return
;-----------------Startup Shutdown-----------------;
Shortcut_TimeUD:
Gui, Submit, Nohide 
Shortcut_TimeE := Shortcut_Time
Shortcut_TimeE:
Gui, Submit, Nohide
If Shortcut_TimeE > 5
  Shortcut_TimeE = 5
Shortcut_Time := Shortcut_TimeE
GuiControl,, Shortcut_TimeE, %Shortcut_Time%
Return

sExecutable:
IF sExecutable = 
  sERootDir = *%A_WorkingDir%
ELSE sERootDir = *%sWorking_Directory%
FileSelectFile, sExeGet, 3, %sERootDir%\%sExecutable%, Select File - Startup Program, *.exe;*.bat;*.ahk;*.cmd;*.lnk
If sExeGet <> 
  {
  SplitPath, sExeGet, sExecutable, sWorking_Directory
  sWorking_Directory = %sWorking_Directory%\
  Guicontrol,, sExecutable, %sExecutable%
  Guicontrol,, sWorking_Directory, %sWorking_Directory%
  }
Return

sWorking_Directory:
IF sWorking_Directory = 
  sWorking_RootDir = *%A_WorkingDir%
ELSE sWorking_RootDir = *%sWorking_Directory%
FileSelectFolder, sWorking_DirectoryGet, %sWorking_RootDir%, 3, Select Folder - Startup Program Working Dir
If sWorking_DirectoryGet <> 
  {
  sWorking_Directory = %sWorking_DirectoryGet%\
  Guicontrol,, sWorking_Directory, %sWorking_Directory%
  }
Return

eExecutable:
IF eExecutable = 
  eERootDir = *%A_WorkingDir%
ELSE eERootDir = *%eWorking_Directory%
FileSelectFile, eExeGet, 3, %eERootDir%\%eExecutable%, Select File - Shutdown Program, *.exe;*.bat;*.ahk;*.cmd;*.lnk
If eExeGet <> 
  {
  SplitPath, eExeGet, eExecutable, eWorking_Directory
  eWorking_Directory = %eWorking_Directory%\
  Guicontrol,, eExecutable, %eExecutable%
  Guicontrol,, eWorking_Directory, %eWorking_Directory%
  }
Return

eWorking_Directory:
IF eWorking_Directory = 
  eWorking_RootDir = *%A_WorkingDir%
ELSE eWorking_RootDir = *%eWorking_Directory%
FileSelectFolder, eWorking_DirectoryGet, %eWorking_RootDir%, 3, Select Folder - Shutdown Program Working Dir
If eWorking_DirectoryGet <> 
  {
  eWorking_Directory = %eWorking_DirectoryGet%\
  Guicontrol,, eWorking_Directory, %eWorking_Directory%
  }
Return
;---------------------Controls---------------------;
SetStartButton:
REALBut = REALpwStart
Gosub GetButton
pwStart := ini_getValue(keycodeini_read, "HPGamepad", REALpwStart)
Guicontrol,, REALpwStart, %REALpwStart%
Guicontrol,, pwStart, %pwStart%
Return

SetExitButton:
REALBut = REALpwExit
Gosub GetButton
pwExit := ini_getValue(keycodeini_read, "HPGamepad", REALpwExit)
Guicontrol,, REALpwExit, %REALpwExit%
Guicontrol,, pwExit, %pwExit%
Return

SetUpButton:
REALBut = REALpwUp
Gosub GetButton
pwUp := ini_getValue(keycodeini_read, "HPGamepad", REALpwUp)
Guicontrol,, REALpwUp, %REALpwUp%
Guicontrol,, pwUp, %pwUp%
Return

SetDownButton:
REALBut = REALpwDown
Gosub GetButton
pwDown := ini_getValue(keycodeini_read, "HPGamepad", REALpwDown)
Guicontrol,, REALpwDown, %REALpwDown%
Guicontrol,, pwDown, %pwDown%
Return

SetSkipUpButton:
REALBut = REALpwSkipUp
Gosub GetButton
pwSkipUp := ini_getValue(keycodeini_read, "HPGamepad", REALpwSkipUp)
Guicontrol,, REALpwSkipUp, %REALpwSkipUp%
Guicontrol,, pwSkipUp, %pwSkipUp%
Return

SetSkipDownButton:
REALBut = REALpwSkipDown
Gosub GetButton
pwSkipDown := ini_getValue(keycodeini_read, "HPGamepad", REALpwSkipDown)
Guicontrol,, REALpwSkipDown, %REALpwSkipDown%
Guicontrol,, pwSkipDown, %pwSkipDown%
Return

SetFlyerButton:
REALBut = REALpwFlyer
Gosub GetButton
pwFlyer := ini_getValue(keycodeini_read, "HPGamepad", REALpwFlyer)
Guicontrol,, REALpwFlyer, %REALpwFlyer%
Guicontrol,, pwFlyer, %pwFlyer%
Return

SetInstructionButton:
REALBut = REALpwInstruction
Gosub GetButton
pwInstruction := ini_getValue(keycodeini_read, "HPGamepad", REALpwInstruction)
Guicontrol,, REALpwInstruction, %REALpwInstruction%
Guicontrol,, pwInstruction, %pwInstruction%
Return

SetGenreButton:
REALBut = REALpwGenre
Gosub GetButton
pwGenre := ini_getValue(keycodeini_read, "HPGamepad", REALpwGenre)
Guicontrol,, REALpwGenre, %REALpwGenre%
Guicontrol,, pwGenre, %pwGenre%
Return

SetServiceButton:
REALBut = REALpwService
Gosub GetButton
pwService := ini_getValue(keycodeini_read, "HPGamepad", REALpwService)
Guicontrol,, REALpwService, %REALpwService%
Guicontrol,, pwService, %pwService%
Return

CheckStartBut:
Gui, Submit, NoHide
REALpwStart := ini_getValue(keycodeini_read, "Gamepad", pwStart)
Guicontrol ,, REALpwStart, %REALpwStart%
RETURN

CheckExitBut:
Gui, Submit, NoHide
REALpwExit := ini_getValue(keycodeini_read, "Gamepad", pwExit)
Guicontrol ,, REALpwExit, %REALpwExit%
RETURN

CheckUpBut:
Gui, Submit, NoHide
REALpwUp := ini_getValue(keycodeini_read, "Gamepad", pwUp)
Guicontrol ,, REALpwUp, %REALpwUp%
RETURN

CheckDownBut:
Gui, Submit, NoHide
REALpwDown := ini_getValue(keycodeini_read, "Gamepad", pwDown)
Guicontrol ,, REALpwDown, %REALpwDown%
RETURN

CheckSkipUpBut:
Gui, Submit, NoHide
REALpwSkipUp := ini_getValue(keycodeini_read, "Gamepad", pwSkipUp)
Guicontrol ,, REALpwSkipUp, %REALpwSkipUp%
RETURN

CheckSkipDownBut:
Gui, Submit, NoHide
REALpwSkipDown := ini_getValue(keycodeini_read, "Gamepad", pwSkipDown)
Guicontrol ,, REALpwSkipDown, %REALpwSkipDown%
RETURN

CheckFlyerBut:
Gui, Submit, NoHide
REALpwFlyer := ini_getValue(keycodeini_read, "Gamepad", pwFlyer)
Guicontrol ,, REALpwFlyer, %REALpwFlyer%
RETURN

CheckInstructionBut:
Gui, Submit, NoHide
REALpwInstruction := ini_getValue(keycodeini_read, "Gamepad", pwInstruction)
Guicontrol ,, REALpwInstruction, %REALpwInstruction%
RETURN

CheckGenreBut:
Gui, Submit, NoHide
REALpwGenre := ini_getValue(keycodeini_read, "Gamepad", pwGenre)
Guicontrol ,, REALpwGenre, %REALpwGenre%
RETURN

CheckServiceBut:
Gui, Submit, NoHide
REALpwService := ini_getValue(keycodeini_read, "Gamepad", pwService)
Guicontrol ,, REALpwService, %REALpwService%
RETURN

CheckStart:
Gui, Submit, NoHide
REALStart := ini_getValue(keycodeini_read, "Keyboard", Start)
Guicontrol ,, REALStart, %REALStart%
RETURN

CheckExit:
Gui, Submit, NoHide
REALExit := ini_getValue(keycodeini_read, "Keyboard", Exit)
Guicontrol ,, REALExit, %REALExit%
RETURN

CheckUp:
Gui, Submit, NoHide
REALUp := ini_getValue(keycodeini_read, "Keyboard", Up)
Guicontrol ,, REALUp, %REALUp%
RETURN

CheckSkipUp:
Gui, Submit, NoHide
REALSkipUp := ini_getValue(keycodeini_read, "Keyboard", SkipUp)
Guicontrol ,, REALSkipUp, %REALSkipUp%
RETURN

CheckSkipDown:
Gui, Submit, NoHide
REALSkipDown := ini_getValue(keycodeini_read, "Keyboard", SkipDown)
Guicontrol ,, REALSkipDown, %REALSkipDown%
RETURN

CheckDown:
Gui, Submit, NoHide
REALDown := ini_getValue(keycodeini_read, "Keyboard", Down)
Guicontrol ,, REALDown, %REALDown%
RETURN

CheckFlyer:
Gui, Submit, NoHide
REALFlyer := ini_getValue(keycodeini_read, "Keyboard", Flyer)
Guicontrol ,, REALFlyer, %REALFlyer%
RETURN

CheckInstruction:
Gui, Submit, NoHide
REALInstruction := ini_getValue(keycodeini_read, "Keyboard", Instruction)
Guicontrol ,, REALInstruction, %REALInstruction%
RETURN

CheckGenre:
Gui, Submit, NoHide
REALGenre := ini_getValue(keycodeini_read, "Keyboard", Genre)
Guicontrol ,, REALGenre, %REALGenre%
RETURN

CheckService:
Gui, Submit, NoHide
REALService := ini_getValue(keycodeini_read, "Keyboard", Service)
Guicontrol ,, REALService, %REALService%
RETURN

SetExitScript:
REALKey = ForceQuit1
Keyname = First Exit Script
Gosub GetKEY
REALKey = ForceQuit2
Keyname = Second Exit Script
Gosub GetKEY
IF ForceQuit2 = escape
  exitScriptKey := ForceQuit1
ELSE
  exitScriptKey = %ForceQuit1% & %ForceQuit2%
Guicontrol,, exitScriptKey, %exitScriptKey%
Return

SetCoin1:
REALKey = coin1Key
Keyname = Coin 1
Gosub GetKEY
Guicontrol,, coin1Key, %coin1Key%
Return

SetPlunger:
REALKey = plungerKey
Keyname = Plunger
Gosub GetKEY
Guicontrol,, plungerKey, %plungerKey%
Return

SetToggleCursor:
REALKey = toggleCursorKey
Keyname = Toggle Cursor
Gosub GetKEY
Guicontrol,, toggleCursorKey, %toggleCursorKey%
Return

SetPause:
REALKey = pauseKey
Keyname = Quick Pause
Gosub GetKEY
Guicontrol,, pauseKey, %pauseKey%
Return

SetStart:
REALKey = REALStart
Keyname = Start
Gosub GetKEY
Start := ini_getValue(keycodeini_read, "HPKeyboard", REALStart)
Guicontrol,, REALStart, %REALStart%
Guicontrol,, Start, %Start%
Return

SetExit:
REALKey = REALExit
Keyname = Exit
Gosub GetKEY
Exit := ini_getValue(keycodeini_read, "HPKeyboard", REALExit)
Guicontrol,, REALExit, %REALExit%
Guicontrol,, Exit, %Exit%
Return

SetUp:
REALKey = REALUp
Keyname = Up
Gosub GetKEY
Up := ini_getValue(keycodeini_read, "HPKeyboard", REALUp)
Guicontrol,, REALUp, %REALUp%
Guicontrol,, Up, %Up%
Return

SetDown:
REALKey = REALDown
Keyname = Down
Gosub GetKEY
Down := ini_getValue(keycodeini_read, "HPKeyboard", REALDown)
Guicontrol,, REALDown, %REALDown%
Guicontrol,, Down, %Down%
Return


SetSkipUp:
REALKey = REALSkipUp
Keyname = SkipUp
Gosub GetKEY
SkipUp := ini_getValue(keycodeini_read, "HPKeyboard", REALSkipUp)
Guicontrol,, REALSkipUp, %REALSkipUp%
Guicontrol,, SkipUp, %SkipUp%
Return

SetSkipDown:
REALKey = REALSkipDown
Keyname = SkipDown
Gosub GetKEY
SkipDown := ini_getValue(keycodeini_read, "HPKeyboard", REALSkipDown)
Guicontrol,, REALSkipDown, %REALSkipDown%
Guicontrol,, SkipDown, %SkipDown%
Return

SetFlyer:
REALKey = REALFlyer
Keyname = Flyer
Gosub GetKEY
Flyer := ini_getValue(keycodeini_read, "HPKeyboard", REALFlyer)
Guicontrol,, REALFlyer, %REALFlyer%
Guicontrol,, Flyer, %Flyer%
Return

SetInstruction:
REALKey = REALInstruction
Keyname = Instruction
Gosub GetKEY
Instruction := ini_getValue(keycodeini_read, "HPKeyboard", REALInstruction)
Guicontrol,, REALInstruction, %REALInstruction%
Guicontrol,, Instruction, %Instruction%
Return

SetGenre:
REALKey = REALGenre
Keyname = Genre
Gosub GetKEY
Genre := ini_getValue(keycodeini_read, "HPKeyboard", REALGenre)
Guicontrol,, REALGenre, %REALGenre%
Guicontrol,, Genre, %Genre%
Return

SetService:
REALKey = REALService
Keyname = Service
Gosub GetKEY
Service := ini_getValue(keycodeini_read, "HPKeyboard", REALService)
Guicontrol,, REALService, %REALService%
Guicontrol,, Service, %Service%
Return

GetKEY:
SingleKey = 
( LTrim Join 
   {Escape}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12} 
   {PrintScreen}{Pause}{ScrollLock}
   `1234567890-={Backspace} 
   {Tab}qwertyuiop[]\{{}{}} {Enter}
   {CapsLock}asdfghjkl;'
   {LShift}zxcvbnm,./{RShift} 
   {LControl}{LWin}{LAlt}{Space}{RAlt}{AppsKey}{RWin}{RControl}
   {Home}{End}{Insert}
   {Delete}{PgUp}{PgDn} 
   {Left}{Right}{Up}{Down}
   {NumLock}* 
   {Numpad7}{Numpad8}{Numpad9}+ 
   {Numpad4}{Numpad5}{Numpad6}
   {Numpad1}{Numpad2}{Numpad3} 
   {Numpad0}
   {NumpadHome}{NumpadUp}{NumpadPgUp}
   {NumpadLeft}{NumpadRight} 
   {NumpadEnd}{NumpadDown}{NumpadPgDn}
   {NumpadIns}{NumpadDel}{NumpadClear} 
   {NumpadDot}
   {NumpadDiv}{NumpadMult}{NumpadSub}
   {NumpadAdd}{NumpadEnter}
) 

IF REALKey = ForceQuit2
  Progress, zh0 m h200,Press %KeyName% Key, `n`n`n`n(press esc to use first key only),SELECT KEY
ELSE
  Progress, zh0 m zy90,Press %KeyName% Key,,SELECT KEY
Input SingleKey, L1, %SingleKey%
Progress, Off
StringLower, outputKey, errorlevel
SingleKey := outputKey
%REALKey% := SubStr(SingleKey, 8)
SingleKey = ""
Return

GetButton:
; Adapted by dumpster.monkey from AHK Joystick Test Script at
; http://www.autohotkey.com/docs/scripts/JoystickTest.htm
; If you want to unconditionally use a specific joystick number, change
; the following value from 0 to the number of the joystick (1-16).
; A value of 0 causes the joystick number to be auto-detected:
JoystickNumber = 0
; Auto-detect the joystick number if called for:
if JoystickNumber <= 0
{
    Loop 16  ; Query each joystick number to find out which ones exist.
    {
        GetKeyState, JoyName, %A_Index%JoyName
        if JoyName <>
        {
            JoystickNumber = %A_Index%
            break
        }
    }
    if JoystickNumber <= 0
    {
        MsgBox, 48, GAME CONTROL MISSING, No gamepad/joystick could be found
        Return
    }
}
StringTrimLeft, dispName, REALBut, 6
Progress, zh0 m zy90,Press %dispName% Button,,SELECT BUTTON
GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
Loop
{
    Loop, %joy_buttons%
    {
        GetKeyState, Joy%a_index%, %JoystickNumber%joy%a_index%
        if Joy%a_index% = D 
		{
            %REALBut% = Joy%a_index%
			Progress, Off
			Return
		}
    }
    Sleep, 100
}
;------------------Wheel Settings------------------;
ShadowAngleUpdate:
Gui, Submit, Nohide
GuiControl,, Angle, %Shadow_Angle%
Return

ColorRatioUpdate:
Gui, Submit, Nohide
GuiControl,, Ratio, %Color_Ratio%
Return

ShadowColor:
 ValidColor:=CheckHexC(newShadowColor) 
  If ! ValidColor 
     newShadowColor:=Shadow_Color
CurrentColor:=newShadowColor
ColorPicker(CurrentColor)
If CurrentColor <>
  Shadow_Color := CurrentColor
newShadowColor := Shadow_Color
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newShadowColor, %Shadow_Color%
GuiControl, +Background%Shadow_Color%, ShadowCol
Return

CheckShadowColor:
Gui,Submit, Nohide
If newShadowColor is not xdigit 
 {
 MsgBox, %newShadowColor% is not a valid hex colour - try using colour picker instead!
 newShadowColor := Shadow_Color
 }
If StrLen(newShadowColor) > 6
 newShadowColor := SubStr(newShadowColor, 1, 6)
If StrLen(newShadowColor) = 6
 {
 Shadow_Color := newShadowColor
 Guicontrol,, newShadowColor, %Shadow_Color%
 GuiControl, +Background%Shadow_Color%, ShadowCol
 }
Return

TxtColor3:
 ValidColor:=CheckHexC(newTxtColor3) 
  If ! ValidColor 
     newTxtColor3:=Text_Color3
CurrentColor:=newTxtColor3
ColorPicker(CurrentColor)
If CurrentColor <>
  Text_Color3 := CurrentColor
newTxtColor3 := Text_Color3
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newTxtColor3, %Text_Color3%
GuiControl, +Background%Text_Color3%, TxtCol3
Return

CheckTxtColor3:
Gui,Submit, Nohide
If newTxtColor3 is not xdigit 
 {
 MsgBox, %newTxtColor3% is not a valid hex colour - try using colour picker instead!
 newTxtColor3 := Text_Color3
 }
If StrLen(newTxtColor3) > 6
 newTxtColor3 := SubStr(newTxtColor3, 1, 6)
If StrLen(newTxtColor3) = 6
 {
 Text_Color3 := newTxtColor3
 Guicontrol,, newTxtColor3, %Text_Color3%
 GuiControl, +Background%Text_Color3%, TxtCol3
 }
Return

TxtColor2:
 ValidColor:=CheckHexC(newTxtColor2) 
  If ! ValidColor 
     newTxtColor2:=Text_Color2
CurrentColor:=newTxtColor2
ColorPicker(CurrentColor)
If CurrentColor <>
  Text_Color2 := CurrentColor
newTxtColor2 := Text_Color2
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newTxtColor2, %Text_Color2%
GuiControl, +Background%Text_Color2%, TxtCol2
Return

CheckTxtColor2:
Gui,Submit, Nohide
If newTxtColor2 is not xdigit 
 {
 MsgBox, %newTxtColor2% is not a valid hex colour - try using colour picker instead!
 newTxtColor2 := Text_Color2
 }
If StrLen(newTxtColor2) > 6
 newTxtColor2 := SubStr(newTxtColor2, 1, 6)
If StrLen(newTxtColor2) = 6
 {
 Text_Color2 := newTxtColor2
 Guicontrol,, newTxtColor2, %Text_Color2%
 GuiControl, +Background%Text_Color2%, TxtCol2
 }
Return

TxtColor1:
 ValidColor:=CheckHexC(newTxtColor1) 
  If ! ValidColor 
     newTxtColor1:=Text_Color1
CurrentColor:=newTxtColor1
ColorPicker(CurrentColor)
If CurrentColor <>
  Text_Color1 := CurrentColor
newTxtColor1 := Text_Color1
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newTxtColor1, %Text_Color1%
GuiControl, +Background%Text_Color1%, TxtCol1
Return

CheckTxtColor1:
Gui,Submit, Nohide
If newTxtColor1 is not xdigit 
 {
 MsgBox, %newTxtColor1% is not a valid hex colour - try using colour picker instead!
 newTxtColor1 := Text_Color1
 }
If StrLen(newTxtColor1) > 6
 newTxtColor1 := SubStr(newTxtColor1, 1, 6)
If StrLen(newTxtColor1) = 6
 {
 Text_Color1 := newTxtColor1
 Guicontrol,, newTxtColor1, %Text_Color1%
 GuiControl, +Background%Text_Color1%, TxtCol1
 }
Return

TextStrokeColor:
 ValidColor:=CheckHexC(newStrokeColor) 
  If ! ValidColor 
     newStrokeColor:=Text_Stroke_Color
CurrentColor:=newStrokeColor
ColorPicker(CurrentColor)
If CurrentColor <>
  Text_Stroke_Color := CurrentColor
newStrokeColor := Text_Stroke_Color
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newStrokeColor, %Text_Stroke_Color%
GuiControl, +Background%Text_Stroke_Color%, StrokeCol
Return

CheckStrokeColor:
Gui,Submit, Nohide
If newStrokeColor is not xdigit 
 {
 MsgBox, %newStrokeColor% is not a valid hex colour - try using colour picker instead!
 newStrokeColor := Text_Stroke_Color
 }
If StrLen(newStrokeColor) > 6
 newStrokeColor := SubStr(newStrokeColor, 1, 6)
If StrLen(newStrokeColor) = 6
 {
 Text_Stroke_Color := newStrokeColor
 Guicontrol,, newStrokeColor, %Text_Stroke_Color%
 GuiControl, +Background%Text_Stroke_Color%, StrokeCol
 }
Return
;-----------------Main Settings--------------------;
StartTextColor:
 ValidColor:=CheckHexC(newColor) 
  If ! ValidColor 
     newColor:=MainTextColor
CurrentColor:=newColor
ColorPicker(CurrentColor)
If CurrentColor <>
  MainTextColor := CurrentColor
newColor := MainTextColor
CurrentColor = ""
Gui,Submit,Nohide
Guicontrol,, newColor, %MainTextColor%
GuiControl, +Background%MainTextColor%, textCol
Return

MVolumeUpdate:
Gui, Submit, Nohide
GuiControl,, MVolume, %Master_Volume%
Return

VVolumeUpdate:
Gui, Submit, Nohide
GuiControl,, VVolume, %Video_Volume%
Return

FXVolumeUpdate:
Gui, Submit, Nohide
GuiControl,, FXVolume, %Sound_FX_Volume%
Return

WVolumeUpdate:
Gui, Submit, Nohide
GuiControl,, WVolume, %Wheel_Sound_Volume%
Return

CheckIsColor:
Gui,Submit, Nohide
If newColor is not xdigit 
 {
 MsgBox, %newColor% is not a valid hex colour - try using colour picker instead!
 newColor := MainTextColor
 }
If StrLen(newColor) > 6
 newColor := SubStr(newColor, 1, 6)
If StrLen(newColor) = 6
 {
 MainTextColor := newColor
 Guicontrol,, newColor, %MainTextColor%
 GuiControl, +Background%MainTextColor%, textCol
 }
Return

CheckTimeUD:
Gui,Submit, Nohide 
TimeE = %Time%
CheckTimeED:
Time = %TimeE%
Gui,Submit, Nohide 
Guicontrol,, Time, %Time%
Return

CheckSpinTimeUD:
Gui,Submit, Nohide 
MaxSpinTimeE = %MaxSpinTime%
CheckSpinTimeED:
If MaxSpinTimeE < 3
  MaxSpinTimeE = 3
If MaxSpinTimeE > 10
  MaxSpinTimeE = 10
Gui,Submit, Nohide 
MaxSpinTime = %MaxSpinTimeE%
GuiControl,, MaxSpinTime, %MaxSpinTime%
Return

;-------------Future Pin Settings------------------;
fpGetExe:
IF fpPath = 
  fpRootDir = *%A_WorkingDir%
ELSE fpRootDir = *%fpPath%
FileSelectFile, fpExeGet, 3, %fpRootDir%\%fpExe%, Select File - Future Pinball Exe, *.exe
If fpExeGet <> 
  {
  SplitPath, fpExeGet, fpExe, fpPath
  fpPath = %fpPath%\
  Guicontrol,, fpExe, %fpPath%%fpExe%
  }
Return

fpGetTable:
IF fpTable_Path = 
  fpTableRootDir = *%A_WorkingDir%
ELSE fpTableRootDir = *%fpTable_Path%
FileSelectFolder, fpTableFolderGet, %fpTableRootDir%, 3, Select Folder - Future Pinball Tables
If fpTableFolderGet <> 
  {
  fpTable_Path = %fpTableFolderGet%\
  Guicontrol,, fpTable_Path, %fpTable_Path%
  }
Return

fpGetVidPath:
IF fpTable_Video_Path = 
  fpTableVideoRootDir = *%A_WorkingDir%
ELSE fpTableVideoRootDir = *%fpTable_Video_Path%
FileSelectFolder, fpTableVideoGet, %fpTableVideoRootDir%, 3, Select Folder - Future Pinball Table Videos
If fpTableFolderGet <> 
  {
  fpTable_Video_Path = %fpTableVideoGet%\
  Guicontrol,, fpTable_Video_Path, %fpTable_Video_Path%
  }
Return

fpGetPicPath:
IF fpTable_Image_Path = 
  fpTableImageRootDir = *%A_WorkingDir%
ELSE fpTableImageRootDir = *%fpTable_Image_Path%
FileSelectFolder, fpTableImageGet, %fpTableImageRootDir%, 3, Select Folder - Future Pinball Table Images
If fpTableImageGet <> 
  {
  fpTable_Image_Path = %fpTableImageGet%\
  Guicontrol,, fpTable_Image_Path, %fpTable_Image_Path%
  }
Return

fpGetBackPicPath:
IF fpBackglass_Image_Path = 
  fpBackImageRootDir = *%A_WorkingDir%
ELSE fpBackImageRootDir = *%fpBackglass_Image_Path%
FileSelectFolder, fpBackImageGet, %fpBackImageRootDir%, 3, Select Folder - Future Pinball Backglass Images
If fpBackImageGet <> 
  {
  fpBackglass_Image_Path = %fpBackImageGet%\
  Guicontrol,, fpBackglass_Image_Path, %fpBackglass_Image_Path%
  }
Return
;-------------Visual Pin Settings------------------;
vpGetExe:
IF vpPath = 
  vpRootDir = *%A_WorkingDir%
ELSE vpRootDir = *%vpPath%
FileSelectFile, vpExeGet, 3, %vpRootDir%\%vpExe%, Select File - Visual Pinball Exe, *.exe
If vpExeGet <> 
  {
  SplitPath, vpExeGet, vpExe, vpPath
  vpPath = %vpPath%\
  Guicontrol,, vpExe, %vpPath%%vpExe%
  }
Return

vpGetTable:
IF vpTable_Path = 
  vpTableRootDir = *%A_WorkingDir%
ELSE vpTableRootDir = *%vpTable_Path%
FileSelectFolder, vpTableFolderGet, %vpTableRootDir%, 3, Select Folder - Visual Pinball Tables
If vpTableFolderGet <> 
  {
  vpTable_Path = %vpTableFolderGet%\
  Guicontrol,, vpTable_Path, %vpTable_Path%
  }
Return

vpGetVidPath:
IF vpTable_Video_Path = 
  vpTableVideoRootDir = *%A_WorkingDir%
ELSE vpTableVideoRootDir = *%vpTable_Video_Path%
FileSelectFolder, vpTableVideoGet, %vpTableVideoRootDir%, 3, Select Folder - Visual Pinball Table Videos
If vpTableFolderGet <> 
  {
  vpTable_Video_Path = %vpTableVideoGet%\
  Guicontrol,, vpTable_Video_Path, %vpTable_Video_Path%
  }
Return

vpGetPicPath:
IF vpTable_Image_Path = 
  vpTableImageRootDir = *%A_WorkingDir%
ELSE vpTableImageRootDir = *%vpTable_Image_Path%
FileSelectFolder, vpTableImageGet, %vpTableImageRootDir%, 3, Select Folder - Visual Pinball Table Images
If vpTableImageGet <> 
  {
  vpTable_Image_Path = %vpTableImageGet%\
  Guicontrol,, vpTable_Image_Path, %vpTable_Image_Path%
  }
Return

vpGetBackPicPath:
IF vpBackglass_Image_Path = 
  vpBackImageRootDir = *%A_WorkingDir%
ELSE vpBackImageRootDir = *%vpBackglass_Image_Path%
FileSelectFolder, vpBackImageGet, %vpBackImageRootDir%, 3, Select Folder - Visual Pinball Backglass Images
If vpBackImageGet <> 
  {
  vpBackglass_Image_Path = %vpBackImageGet%\
  Guicontrol,, vpBackglass_Image_Path, %vpBackglass_Image_Path%
  }
Return
;---------------Read Inis---------------------------;
readInis:
Starting_Genre := ini_getValue(hyperini_read, "Main", "Starting_Genre")
If Starting_Genre = All Games
  Starting_Genre = 1
Else If Starting_Genre = Future Pinball
  Starting_Genre = 2
Else If Starting_Genre = Visual Pinball
  Starting_Genre = 3
Else If Starting_Genre = Favorites
 Starting_Genre = 4
Else Starting_Genre = 1

iniVideo = Playfield_Monitor,Playfield_Rotation,Backglass_Monitor,Quality
,Table_Video_Enabled,Table_Video_Offset,Table_Video_Buffer,Use_Backglass
,Backglass_Image_x,Backglass_Image_y,Backglass_Image_w,Backglass_Image_h
,Backglass_Image_r,Backglass_Delay
Loop, parse, iniVideo, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Video", A_LoopField)
	  If ( A_LoopField = "Table_Video_Enabled" OR A_LoopField = "Playfield_Monitor" OR A_LoopField = "Backglass_Monitor" OR A_LoopField = "Use_Backglass" ) {
	    If ( %A_LoopField% = "true" OR %A_LoopField% = "Primary" )
	      %A_LoopField% = 1
	    If ( %A_LoopField% = "false" OR %A_LoopField% = "Secondary" )
	      %A_LoopField% = 2
		Else %A_LoopField% = 1
		}
	  If ( A_LoopField = "Playfield_Rotation" OR A_LoopField = "Backglass_Image_r" OR A_LoopField = "Quality" ) {
	    If ( %A_LoopField% = 0 OR %A_LoopField% = "LOW" )
		  %A_LoopField% = 1
		Else If ( %A_LoopField% = 90 OR %A_LoopField% = "MEDIUM" )
		  %A_LoopField% = 2
		Else If ( %A_LoopField% = 180 OR %A_LoopField% = "HIGH" )
		  %A_LoopField% = 3
		Else If ( %A_LoopField% = 270 OR %A_LoopField% = "BEST" )
		  %A_LoopField% = 4
		Else %A_LoopField% = 1
	  }
   }
   
iniFuturePinball =  Show_Games,Exe,Path,Table_Path,Table_Video_Path,Table_Image_Path
,Backglass_Image_Path
Loop, parse, iniFuturePinball, `,
   {
	  fp%A_LoopField% := ini_getValue(hyperini_read, "Future Pinball", A_LoopField)
   }
IF fpShow_Games = true
  fpShow_Games = 1
ELSE IF fpShow_Games = false
  fpShow_Games = 2
ELSE fpShow_Games = 1
   
iniVisualPinball =  Show_Games,Exe,Path,Table_Path,Table_Video_Path,Table_Image_Path
,Backglass_Image_Path
Loop, parse, iniVisualPinball, `,
   {
	  vp%A_LoopField% := ini_getValue(hyperini_read, "Visual Pinball", A_LoopField)
   }
IF vpShow_Games = true
  vpShow_Games = 1
ELSE IF vpShow_Games = false
  vpShow_Games = 2
ELSE vpShow_Games = 1
   
iniHyperFPLaunch = exitScriptKey,toggleCursorKey,pauseKey,hideCursor,hideDesktop,hideTaskbar
,useExitCountdown,useExitMenu,usePause,useLoadScreen,fadespeed,pauseFPKey,menuDMD,dmdSTYLE
,hyperScale,fpSubfolders,controlWith,plungerKey,coin1Key,saveFPTables,autoUpdate,LEDwiz
Loop, parse, iniHyperFPLaunch, `,
   {
      %A_LoopField% := ini_getValue(hypersetini_read, "HyperFPLaunch", A_LoopField)
	  If ( %A_LoopField% = "Error" Or  %A_LoopField% = "" )
	  {
        keyToAdd := A_LoopField
		Gosub Addini
	  }
	  IF %A_LoopField% = true
        %A_LoopField% = 1
      ELSE IF %A_LoopField% = false
        %A_LoopField% = 2
   }
If controlWith = keyboard
  controlWith = 1
Else If controlWith = gamepad
  controlWith = 2
Else If controlWith = both
  controlWith = 3
If dmdSTYLE = DMD
  dmdSTYLE = 1
Else If dmdSTYLE = HyperPin Blue
  dmdSTYLE = 2
Else If dmdSTYLE = HyperPin White
  dmdSTYLE = 3
If pauseFPKey = LButton
  pauseFPKey = 1
Else If pauseFPKey = MButton
  pauseFPKey = 2
Else If pauseFPKey = RButton
  pauseFPKey = 3
  
iniWheel = Speed,Text_Font,Text_Stroke_Size,Text_Stroke_Color,Text_Color1,Text_Color2
,Text_Color3,Color_Ratio,Shadow_Distance,Shadow_Angle,Shadow_Color,Shadow_Alpha,Shadow_Blur
Loop, parse, iniWheel, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Wheel", A_LoopField)
	  If ( A_LoopField = "Speed" OR A_LoopField = "Text_Font" ) {
	    If ( %A_LoopField% = "Style1" OR %A_LoopField% = "low" )
		  %A_LoopField% = 1
		Else If ( %A_LoopField% = "Style2" OR %A_LoopField% = "med" )
		  %A_LoopField% = 2
		Else If ( %A_LoopField% = "Style3" OR %A_LoopField% = "high" )
		  %A_LoopField% = 3
		Else If %A_LoopField% = "Style4"
		  %A_LoopField% = 4
		Else If %A_LoopField% = "Style5"
		  %A_LoopField% = 5  
		Else %A_LoopField% = 1
	  }
   }
Text_Stroke_Color := SubStr(Text_Stroke_Color, 3)
Text_Color1 := SubStr(Text_Color1, 3)   
Text_Color2 := SubStr(Text_Color2, 3)
Text_Color3 := SubStr(Text_Color3, 3)   
Shadow_Color := SubStr(Shadow_Color, 3) 
 
Use_Intro := ini_getValue(hyperini_read, "Intro Video", "Use_Intro")
IF Use_Intro = true
  Use_Intro = 1
ELSE IF Use_Intro = false
  Use_Intro = 2
ELSE Use_Intro = 1
Skip_On_Keypress := ini_getValue(hyperini_read, "Intro Video", "Skip_On_Keypress")
IF Skip_On_Keypress = true
  Skip_On_Keypress = 1
ELSE IF Skip_On_Keypress = false
  Skip_On_Keypress = 2
ELSE Skip_On_Keypress = 1

iniSound = Master_Volume,Video_Volume,Sound_FX_Volume,Wheel_Sound_Volume
Loop, parse, iniSound, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Sound", A_LoopField)
   }

Active := ini_getValue(hyperini_read, "AttractMode", "Active")
IF Active = true
  Active = 1
ELSE IF Active = false
  Active = 2
ELSE Active = 1
Time := ini_getValue(hyperini_read, "AttractMode", "Time")
MaxSpinTime := ini_getValue(hyperini_read, "AttractMode", "MaxSpinTime")
MaxSpinTimeE = %MaxSpinTime%
TimeE = %Time%

iniPressStart = Enabled,Text1,Text2,Color
Loop, parse, iniPressStart, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Press Start Text", A_LoopField)
   }
IF Enabled = true
  Enabled = 1
ELSE IF Enabled = false
  Enabled = 2
ELSE Enabled = 1
MainTextColor := SubStr(Color, 3)

iniKeyboard = Key_Delay,Start,Exit,Up,Down,SkipUp,SkipDown,Flyer,Instruction,Genre,Service
Loop, parse, iniKeyboard, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Keyboard", A_LoopField)
	  If %A_LoopField% <> "Key_Delay"
	   {
		keyname = REAL%A_LoopField%
		HPkey  :=  %A_LoopField%
		%keyname% := ini_getValue(keycodeini_read, "Keyboard", HPkey)
		}
   }   
IF Key_Delay = true
  Key_Delay = 1
ELSE IF Key_Delay = false
  Key_Delay = 2
ELSE Key_Delay = 1
   
iniPinWiz = Start,Exit,Up,Down,SkipUp,SkipDown,Flyer,Instruction,Genre,Service
Loop, parse, iniPinWiz, `,
   {
	  pw%A_LoopField% := ini_getValue(hyperini_read, "Pinball Wizard", A_LoopField)
	  butname = REALpw%A_LoopField%
	  HPbut  :=  pw%A_LoopField%
	  %butname% := ini_getValue(keycodeini_read, "Gamepad", HPbut)
   }   

fBottomX := ini_getValue(hyperini_read, "Flyer", "BottomX")
fCenterY := ini_getValue(hyperini_read, "Flyer", "CenterY")

iBottomX := ini_getValue(hyperini_read, "Instruction", "BottomX")
iCenterY := ini_getValue(hyperini_read, "Instruction", "CenterY")
iWidth := ini_getValue(hyperini_read, "Instruction", "Width")

iniExit = Enable_Exit_Screen,Exit_HyperPin,Shutdown,Enable_Shortcut,Shortcut_Action,Shortcut_Time
Loop, parse, iniExit, `,
   {
	  %A_LoopField% := ini_getValue(hyperini_read, "Exit", A_LoopField)
	  IF ( %A_LoopField% = "true" OR %A_LoopField% = "exit" )
        %A_LoopField% = 1
      ELSE IF ( %A_LoopField% = "false" OR %A_LoopField% = "shutdown" )
        %A_LoopField% = 2
   }   

iniStartProg = Executable,Parameters,Working_Directory,WinState
Loop, parse, iniStartProg, `,
   {
	  s%A_LoopField% := ini_getValue(hyperini_read, "Startup Program", A_LoopField)
   }   
IF sWinstate = NORMAL
  sWinstate = 1
ELSE IF sWinstate = MINIMIZED
  sWinstate = 2 
ELSE IF sWinstate = MAXIMIZED
  sWinstate = 3
ELSE IF sWinstate = HIDDEN
  sWinstate = 4
ELSE sWinstate = 1
 
iniExitProg = Executable,Parameters,Working_Directory,WinState
Loop, parse, iniExitProg, `,
   {
	  e%A_LoopField% := ini_getValue(hyperini_read, "Exit Program", A_LoopField)
   }   
IF eWinstate = NORMAL
  eWinstate = 1
ELSE IF eWinstate = MINIMIZED
  eWinstate = 2 
ELSE IF eWinstate = MAXIMIZED
  eWinstate = 3
ELSE IF eWinstate = HIDDEN
  eWinstate = 4
ELSE eWinstate = 1
  
Return
;-----------add defaults for missing keys--------------;
addIni:
iniDefaults = 
( 
  [HyperFPLaunch]
  exitScriptKey    = q & s
  toggleCursorKey  = t
  pauseKey         = p
  hideCursor       = true
  hideDesktop      = true
  hideTaskbar      = true
  useExitCountdown = true
  useExitMenu      = true
  usePause         = true
  useLoadScreen    = true
  fadespeed        = 24
  pauseFPKey       = RButton
  menuDMD          = true
  dmdSTYLE         = DMD
  hyperScale       = 0.60
  fpSubfolders     = false
  controlWith      = both
  plungerKey       = enter
  coin1Key         = 5
  saveFPTables     = false
  autoUpdate       = false
  LEDwiz           = false
)
Value := ini_getValue(iniDefaults, "HyperFPLaunch", keyToAdd)
IniWrite, %Value%, %hypersetini%, HyperFPLaunch, %keyToAdd%
%keyToAdd% = %Value%
Return
;-----------------writeinis------------------;
writeinis:
IniWrite, %Starting_Genre%, %hyperini%, Main , Starting_Genre
iniVideo = Playfield_Monitor,Playfield_Rotation,Backglass_Monitor,Quality
,Table_Video_Enabled,Table_Video_Offset,Table_Video_Buffer,Use_Backglass
,Backglass_Image_x,Backglass_Image_y,Backglass_Image_w,Backglass_Image_h
,Backglass_Image_r,Backglass_Delay
Loop, parse, iniVideo, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Video, %A_LoopField%
   }
iniFuturePinball = fpShow_Games,fpExe,fpPath,fpTable_Path,fpTable_Video_Path,fpTable_Image_Path
,fpBackglass_Image_Path
Loop, parse, iniFuturePinball, `,
   {
     iniKey := SubStr(A_LoopField, 3)
	 Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Future Pinball, %iniKey% 
   }  
iniVisualPinball = vpShow_Games,vpExe,vpPath,vpTable_Path,vpTable_Video_Path,vpTable_Image_Path
,vpBackglass_Image_Path
Loop, parse, iniVisualPinball, `,
   {
     iniKey := SubStr(A_LoopField, 3)
	 Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Visual Pinball, %iniKey% 
   }
IF useExitCountdown = 0
  useExitCountdown = false
ELSE useExitCountdown = true
IF useExitMenu = 0
  useExitMenu = false
ELSE useExitMenu = true
iniHyperFPLaunch = exitScriptKey,toggleCursorKey,pauseKey,hideCursor,hideDesktop,hideTaskbar
,useExitCountdown,useExitMenu,usePause,useLoadScreen,fadespeed,pauseFPKey,menuDMD,dmdSTYLE
,hyperScale,fpSubfolders,controlWith,plungerKey,coin1Key,saveFPTables,autoUpdate,LEDwiz
Loop, parse, iniHyperFPLaunch, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hypersetini%, HyperFPLaunch, %A_LoopField%
   }
Text_Stroke_Color = 0x%Text_Stroke_Color%
Text_Color1 = 0x%Text_Color1%  
Text_Color2 = 0x%Text_Color2%
Text_Color3 = 0x%Text_Color3%   
Shadow_Color = 0x%Shadow_Color%
iniWheel = Speed,Text_Font,Text_Stroke_Size,Text_Stroke_Color,Text_Color1,Text_Color2
,Text_Color3,Color_Ratio,Shadow_Distance,Shadow_Angle,Shadow_Color,Shadow_Alpha,Shadow_Blur
Loop, parse, iniWheel, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Wheel, %A_LoopField%
   }   
Text_Stroke_Color := SubStr(Text_Stroke_Color, 3)
Text_Color1 := SubStr(Text_Color1, 3)   
Text_Color2 := SubStr(Text_Color2, 3)
Text_Color3 := SubStr(Text_Color3, 3)   
Shadow_Color := SubStr(Shadow_Color, 3)
IniWrite, %Use_Intro%, %hyperini%, Intro Video, Use_Intro
IniWrite, %Skip_On_Keypress%, %hyperini%, Intro Video, Skip_On_Keypress   
;
iniSound = Master_Volume,Video_Volume,Sound_FX_Volume,Wheel_Sound_Volume
Loop, parse, iniSound, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Sound, %A_LoopField%
   }
IniWrite, %Active%, %hyperini%, AttractMode, Active
IniWrite, %Time%, %hyperini%, AttractMode, Time  
IniWrite, %MaxSpinTime%, %hyperini%, AttractMode, MaxSpinTime
Color = 0x%MainTextColor%
iniPressStart = Enabled,Text1,Text2,Color
Loop, parse, iniPressStart, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Press Start Text, %A_LoopField%
   }   
iniKeyboard = Key_Delay,Start,Exit,Up,Down,SkipUp,SkipDown,Flyer,Instruction,Genre,Service
Loop, parse, iniKeyboard, `,
   {
     Value := %A_LoopField%
	 IniWrite, %Value%, %hyperini%, Keyboard, %A_LoopField%
   }  
iniPinWiz = pwStart,pwExit,pwUp,pwDown,pwSkipUp,pwSkipDown,pwFlyer,pwInstruction,pwGenre,pwService
Loop, parse, iniPinWiz, `,
   {
      Value := %A_LoopField%
	  iniKey := SubStr(A_LoopField, 3)
	  IniWrite, %Value%, %hyperini%, Pinball Wizard, %iniKey%	
   } 
IniWrite, %fBottomX%, %hyperini%, Flyer, BottomX
IniWrite, %fCenterY%, %hyperini%, Flyer, CenterY  
IniWrite, %iBottomX%, %hyperini%, Instruction, BottomX
IniWrite, %iCenterY%, %hyperini%, Instruction, CenterY  
IniWrite, %iWidth%, %hyperini%, Instruction, Width  
iniExit = Enable_Exit_Screen,Exit_HyperPin,Shutdown,Enable_Shortcut,Shortcut_Action,Shortcut_Time
Loop, parse, iniExit, `,
   {
     Value := %A_LoopField% 
	 IniWrite, %Value%, %hyperini%, Exit, %A_LoopField%
   }    
iniStartProg = sExecutable,sParameters,sWorking_Directory,sWinState
Loop, parse, iniStartProg, `,
   {
     Value := %A_LoopField% 
	 iniKey := SubStr(A_LoopField, 2)
	 IniWrite, %Value%, %hyperini%, Startup Program, %iniKey%
   }   
iniExitProg = eExecutable,eParameters,eWorking_Directory,eWinState
Loop, parse, iniExitProg, `,
   {
     Value := %A_LoopField% 
	 iniKey := SubStr(A_LoopField, 2)
	 IniWrite, %Value%, %hyperini%, Exit Program, %iniKey%
   } 
Return

;---------------ColorPicker------------------;
ColorPicker(HEXString="",Title="") 
{ 
  
  Global 

  If HEXString= 
     CurrentColor:="FFFFFF" 
  else 
     CurrentColor:=HexString 

  ValidColor:=CheckHexC(CurrentColor) 
  If ! ValidColor 
     CurrentColor:="000000" 

  GradientColorBand(CurrentColor) 

  If Title= 
     WinTitle:="HyperSettings ColourPicker" 
  Else 
     WinTitle:=Title 

  GuiPos := ini_getValue(hypersetini_read, "Settings", GuiPos)
  
  If GUIPos!=ERROR 
     StringSplit,Pos,GuiPos,`, 

  GoSub, CreateGUI 
  WinWaitClose, %WinTitle% 
Return CurrentColor 
} 

;-------------------------------------------------------------------------------------------- 

CreateGUI: 

 Gui, 1:+LastFound 
 if WinExist("A") 
    { 
    Gui, 4:+Owner1 
    Gui, 4:-AlwaysOnTop 
    } 

 Gui, 4:+AlwaysOnTop 
 Gui, 4:+ToolWindow 

 Gui, 4:Font, S9  
 Gui,Margin,5,5 

 H=20 
 W=20 

 LineNo=1 

 Gui, 4:Add,GroupBox, x10      w215 h175, Basic Colours 
 Gui, 4:Add,GroupBox, x10 y+5  w215 h75 , My Favourite Colours 
 Gui, 4:Add,GroupBox, x235 y5  w215 h125 

 Gui, 4:Add, ListView, x20 y25  h%H% w%W% ReadOnly 0x4000 +BackgroundFF8080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFFFF80 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background80FF80 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background00FF80 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background80FFFF AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background0080FF AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF80C0 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF80FF AltSubmit gSelColor 

 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +BackgroundFF0000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFFFF00 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background80FF00 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background00FF40 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background00FFFF AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background0080C0 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background8080C0 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF00FF AltSubmit gSelColor 

 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +Background804040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF8040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background00FF00 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background008080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background004080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background8080FF AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background800040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF0080 AltSubmit gSelColor 

 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +Background800000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFF8000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background008000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background008040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background0000FF AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background0000A0 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background800080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background8000FF AltSubmit gSelColor 

 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +Background400000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background804000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background004000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background004040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background400040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background400080 AltSubmit gSelColor 
  
 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background808000 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background808040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background808080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background408080 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundC0C0C0 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background400040 AltSubmit gSelColor 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +BackgroundFFFFFF AltSubmit gSelColor 

 Gui, 4:Add, ListView, x20 y+35 h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor01 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor02 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor03 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor04 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor05 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor06 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor07 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor08 

 Gui, 4:Add, ListView, x20  y+5 h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor09 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor10 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor11 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor12 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor13 

 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor14 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor15 
 Gui, 4:Add, ListView, x+5      h%H% w%W% ReadOnly 0x4000 +Background000000 AltSubmit gSelColor vFColor16 

 GoSub, LoadFavColors 

 Gui, 4:Add, Text  , X245  y19 w37 h18 Center , Red 
 Gui, 4:Add, Slider, X+5   Thick16 w110 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vRSlider 
 Gui, 4:Add, Edit  , X+5   W37 h18 Right ReadOnly vRVal, % RGB1 

 Gui, 4:Add, Text  , X245  y+3 w37 h18 Center, Green 
 Gui, 4:Add, Slider, x+5   Thick16 w110 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vGSlider 
 Gui, 4:Add, Edit  , X+5   W37 h18 Right ReadOnly vGVal, % RGB2 

 Gui, 4:Add, Text  , X245  y+3 w37 h18 Center, Blue 
 Gui, 4:Add, Slider, x+5   Thick16 w110 h18 Center NoTicks Range0-255 AltSubmit gUpdateSlider vBSlider 
 Gui, 4:Add, Edit  , X+5   W37 h18 Right ReadOnly vBVal, % RGB3 

 Gui, 4:Add, Picture, x244 y+12 w192 h10 E0x200 vColorBand , %A_Temp%\ColorPicker_3x1.bmp 
 Gui, 4:Add, Slider,  x238 y+1 Thick16 Left w209 h19 NoTicks Range1-192 AltSubmit vCBSlider gColorBandSel, 96 
  
 Gui, 4:Add, Text    , x259 y137 w70 h16 Center %PrvOption% , Previous 
 Gui, 4:Add, ListView, x259 y+1  h32 w70 ReadOnly 0x4000  +Background%CurrentColor% vCColor_p      AltSubmit       gSelColor,   ; 
 Gui, 4:Add, Text    , x259 y+1      w70 Center vCurrentColor_p %PrvOption% , %CurrentColor% 
 
 Gui, 4:Add, Text    , x354 y137 w70 h16 Center, Current 
 Gui, 4:Add, ListView, x354 y+1  h32 w70 vCColor AltSubmit gSelColor ReadOnly 0x4000 +Background%CurrentColor% 
 Gui, 4:Add, Text    , x354 y+1      w70 Center vCurrentColor 
  
 Gui, 4:Add, Button, x332 Y163   w18 h16 Center 0x8000  gBASCULE_ds_PREVIOUS      , < 

 Gui, 4:Add, Button, x20 y270  h21 Center 0x8000                    gFavColors   , Add &Favourite 
  
 Gui, 4:Font, S8 
 Gui, 4:Add, Edit,   x255 y210  w60 h21 Center 0x8000  vLaCouleur                , %CurrentColor% 
  
 Gui, 4:Font, S7 
 Gui, 4:Add, Button, x+0  y210  w30 h21 Center 0x8000  gAFFICHER_La_Couleur         , &Set 
 
 Gui, 4:Font, S9 
 Gui, 4:Add, Button, x+5xz h21 Center 0x8000     gCouleur_SOUS_la_SOURIS1   , &Eyedropper      ; UnderMouse 
 
 Gui, 4:Add, Button, x250  y240     w90 h21 Center 0x8000 %ClipboardOption%  gCopy_Hex_To_Clipboard      , &Copy 
 Gui, 4:Add, Button, x+5  y240      w90 h21 Center 0x8000     gColler_Hex_To_Clipboard               , &Paste
  
 GuiControl, 4:,CurrentColor, %CurrentColor% 
 GuiControl, 4:+Background%CurrentColor%, CColor, %CurrentColor% 

 Gui, 4:Add, Button, x310 y270 w60 h21 Center 0x8000 gCancel , C&ancel 
 Gui, 4:Add, Button, x+5 w60 h21 Center 0x8000 gOkay , &Okay    
  
 GoSub, UpdateSlider 
   
 RGB := HEX2RGB(CurrentColor) 
 StringSplit,_RGB, RGB, `, 

 RSlider := _RGB1 
 GSlider := _RGB2 
 BSlider := _RGB3 

 GoSub, UpdateSlider 

 GuiControl, 4:, RSlider, % _RGB1 
 GuiControl, 4:, GSlider, % _RGB2 
 GuiControl, 4:, BSlider, % _RGB3 
;   =========================================================== % 

  if Pos1!= 
     Gui, 4:Show, x%Pos1% y%Pos2%, %WinTitle% 
  else 
     Gui, 4:Show, Center, %WinTitle% 
Gosub LISTER_les_Fichiers_Config 

Return 

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Exit Routines 

Cancel: 
4GuiEscape: 
4GuiClose: 
  CurrentColor:="" 
  Gui,4:Destroy
Return 

Okay: 
  GuiControlGet, CurrentColor, ,CurrentColor 
  Gui,4:Destroy
Return 

SavePosThenExit: 
  WinGetActiveStats, Title, Width, Height, xPos, yPos 

 IniWrite,%xPos%`,%yPos%,%hypersetini%,Settings,GuiPos 
 Gui,4:Destroy 
Return 
;-------------------------------------------------------------------------------------------- 
;-------------------------------------------------------------------------------------------- 
SelColor: 

If A_GuiEvent=Normal 
   { 
    MouseGetPos,X,Y 
    PixelGetColor,CurrentColor,%X%,%Y%,RGB 
    StringRight,CurrentColor,CurrentColor,6 

      If A_GuiControl <> ColorBand 
        { 
         GradientColorBand(CurrentColor) 
         GuiControl, 4:, ColorBand, %A_Temp%\ColorPicker_3x1.bmp 
        } 

    RGB := HEX2RGB(CurrentColor) 
    StringSplit,_RGB, RGB, `, 

    GuiControl, 4:, RSlider, % _RGB1 
    GuiControl, 4:, GSlider, % _RGB2 
    GuiControl, 4:, BSlider, % _RGB3 
  
    GuiControl, 4:,CurrentColor, % CurrentColor 
    GuiControl, 4:+Background%CurrentColor%, CurrentColor 
    GuiControl, 4:, CBSlider, 96 
    GoSub, UpdateSlider 

   } 
Return 

;-------------------------------------------------------------------------------------------- 

UpdateSlider: 

  Gui, Submit, Nohide 

  RGB1 := RSlider 
  RGB2 := GSlider 
  RGB3 := BSlider 

  RGBString = % RGB1 "," RGB2 "," RGB3      ;%;; 
  Colorr := RGB2HEX(RGBString) 
  
  GuiControl, 4:,CurrentColor, %Colorr% 
  GuiControl, 4:+Background%Colorr%, CColor,% Colorr 
  GuiControl, 4:, RVal, %RGB1% 
  GuiControl, 4:, GVal, %RGB2% 
  GuiControl, 4:, BVal, %RGB3% 

Return 

;-------------------------------------------------------------------------------------------- 

Coller_Hex_To_Clipboard:                  ; ajout soggos for the new button coller 

   CurrentColor:= Clipboard 
    GuiControl, 4:, LaCouleur, %CurrentColor% 
      Gosub AFFICHER_La_Couleur 
   Return 
;-------------------------------------------------------------------------------------------- 


;-------------------------------------------------------------------------------------------- 


Copy_Hex_To_Clipboard: 

  GuiControlGet, CurrentColor, ,CurrentColor 
  Clipboard:=CurrentColor 
Return 

;-------------------------------------------------------------------------------------------- 

LoadFavColors: 
 
  FColors := ini_getValue(hypersetini_read, "Settings", "FColors")
  IF FColors=ERROR     
     IniWrite, %Nothing%, %hypersetini%, Settings, FColors
  Else 
     StringSlice(FColors,6,"Fav") 

  Loop, % FAV0 
    { 
     VarName = % "FAV" A_Index 
     FavColor := %VarName% 
     FavIndex=0%A_Index% 
     StringRight, FavIndex, FavIndex, 2 
     FavControl = FColor%FavIndex% 
     GuiControl,4:+BackGround%FavColor%, %FavControl%, %FavColor% 
    } 
Return 

;-------------------------------------------------------------------------------------------- 

FavColors: 

  FColors := ini_getValue(hypersetini_read, "Settings", "FColors")
  
  IF FColors=ERROR 
     IniWrite,%Nothing%, %hypersetini%,Settings,FColors 	 
  Else 
     StringRight,FColors,FColors,90 

  GuiControlGet, CurrentColor, ,CurrentColor 
  FColors= % FColors CurrentColor 

  IniWrite,%FColors%, %hypersetini%,Settings,FColors  
  GoSub, LoadFavColors 
Return 

;-------------------------------------------------------------------------------------------- 

ColorBandSel: 

x:=248+CBSlider 
PixelGetColor, CBColor, %X%, 117, ALT RGB 
StringRight, CUrrentColor, CBColor, 6 

    RGB := HEX2RGB(CurrentColor) 
    StringSplit,_RGB, RGB, `, 

    GuiControl, 4:, RSlider, % _RGB1 
    GuiControl, 4:, GSlider, % _RGB2 
    GuiControl, 4:, BSlider, % _RGB3 
  
    GuiControl, 4:,CurrentColor, % CurrentColor 
    GuiControl, 4:+Background%CurrentColor%, CurrentColor 
  
    GoSub, UpdateSlider 

Return 

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - RGB & HEX Functions 

HEX2RGB(HEXString,Delimiter="") 
{ 
 If Delimiter= 
    Delimiter=, 
  
 StringMid,R,HexString,1,2 
 StringMid,G,HexString,3,2 
 StringMid,B,HexString,5,2 

 R = % "0x"R 
 G = % "0x"G 
 B = % "0x"B 
  
 R+=0 
 G+=0 
 B+=0 

 RGBString = % R Delimiter G Delimiter B 

Return RGBString 
} 


RGB2HEX(RGBString,Delimiter="") 
{ 
 If Delimiter= 
    Delimiter=, 
 StringSplit,_RGB,RGBString,%Delimiter% 

 SetFormat, Integer, Hex 
 _RGB1+=0 
 _RGB2+=0 
 _RGB3+=0 

 If StrLen(_RGB1) = 3 
    _RGB1= 0%_RGB1% 

 If StrLen(_RGB2) = 3 
    _RGB2= 0%_RGB2% 

 If StrLen(_RGB3) = 3 
    _RGB3= 0%_RGB3% 

 SetFormat, Integer, D 
 HEXString = % _RGB1 _RGB2 _RGB3 
 StringReplace, HEXString, HEXString,0x,,All 
 StringUpper, HEXString, HEXString 

Return, HEXString 
} 


CheckHexC(HEXString) 
{ 
  StringUpper, HEXString, HEXString 

  RGB:=HEX2RGB(HEXString) 
  CHK:=RGB2HEX(RGB) 

  StringUpper, CHK, CHK 

  If CHK=%HEXString% 
     Return 1 
  else 
     Return 0 
} 

GradientColorBand(RGB) { 
  file= %A_Temp%\ColorPicker_3x1.bmp 
  StringMid,R,RGB,1,2 
  StringMid,G,RGB,3,2 
  StringMid,B,RGB,5,2 

   Hs1:="424d42000000000000003600000028000000030000000100000001" 
   Hs2:="001800000000000c00000000000000000000000000000000000000" 
   Hs3:="FFFFFF" B G R "000000000000" 

   HexString:= Hs1 Hs2 Hs3 

   Handle:= DllCall("CreateFile","str",file,"Uint",0x40000000 
                ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0) 

   Loop 66 { 
     StringLeft, Hex, HexString, 2          
     StringTrimLeft, HexString, HexString, 2  
     Hex = 0x%Hex% 
     DllCall("WriteFile","UInt", Handle,"UChar *", Hex 
     ,"UInt",1,"UInt *",UnusedVariable,"UInt",0) 
    } 
  
   DllCall("CloseHandle", "Uint", Handle) 

Return File 
} 

StringSlice(String,n,ArrayName="")  
{ 
  Local k        
  IfEqual ArrayName,,SetEnv ArrayName,Array 

  k := Ceil(StrLen(String)/n) 
  Loop %k% 
    StringMid %ArrayName%%A_Index%, String, A_Index*n-n+1, n 
  %ArrayName%0 = %k% 
  Return k 
} 

; End 
;-------------------------------------------------------------------------------------------- 
; END of > ColorPicker.ahk 
;-------------------------------------------------------------------------------------------- 

; § ; =================================================================== // Ajout soggos 
;   =========================================================== %   Multiple CONFIG dans des fichiers xxx.ini (in ScriptDir) 

   LISTER_les_Fichiers_Config: 

LISTEdeCONFIG= 
ListeFichiersConfig= 
Loop, %A_ScriptDir%\*.ini                           ; Lister les fichier ini présents (chemin absolu) 
   LISTEdeCONFIG = %LISTEdeCONFIG%%A_LoopFileFullPath%`n   ; dans > LISTEdeCONFIG 

   sort , LISTEdeCONFIG                           ; faire ordre 
 LOOP , parse, LISTEdeCONFIG,`n                        ; Affichage dans le combo 
  { 
   SplitPath, A_LoopField, name, dir, ext,               ; recup que le nom (pour affichage comobo) 
   ifinstring , name, Desktop                        ; pas le fichier Desktop.ini 
   continue 
    
   StringTrimRight, name, name, 4                     ; enlever extension .ini pour affichage (je préfere car avec name_no_ext, les points dans le nom foutent grav la zone!(note perso:pénible surtout avec les dossier, faire une verification de l'attribut D....)) 
   ; StringTrimLeft,  name, name, 4                  ; pour definir un prefix 
    guicontrol , 4:, Fichier_de_Config,%name%            ; mettre le nom dans le combo 
   ListeFichiersConfig=%name%|%ListeFichiersConfig%      ; liste simple nom 
  } 

    guicontrol , 4:, Fichier_de_Config, HyperSettings||      ; mettre à jour le combo Avec le fichier ColorPicker.ini en premier selectionné 
   RETURN 
;   =========================================================== % 

;   =========================================================== %   Charger un fichier de config 

   CHARGER_Fichier_de_Config: 

    GuiControlGet , Fichier_de_Config , , Fichier_de_Config   ; Recup variable 
     
   re_Fichier_de_Config: 
    
IfNotExist %hypersetini%                     ; préférable 
   Return 
  FColors := ini_getValue(hypersetini_read, "Settings", "FColors")
  IF FColors=ERROR                                 ; problem 
     IniWrite, %Nothing%, %hypersetini%, Settings, FColors      
  
  
     StringSlice(FColors,6,"Fav")                     ; couper dans un tableau 
  Loop, % FAV0                                 ;%   ; remplir les Couleurs fav 
    { 
     VarName = % "FAV" A_Index 
     FavColor := %VarName% 
     FavIndex=0%A_Index% 
     StringRight, FavIndex, FavIndex, 2 
     FavControl = FColor%FavIndex% 
     GuiControl,4:+BackGround%FavColor%, %FavControl%, %FavColor% 
    } 
   RETURN 
;   =========================================================== % 
    
;   =========================================================== % 

   AFFICHER_La_Couleur: 

  GuiControlGet, CurrentColor, , LaCouleur 
  
    RGB := HEX2RGB(CurrentColor) 
    StringSplit,_RGB, RGB, `, 

    GuiControl, 4:, RSlider, % _RGB1 
    GuiControl, 4:, GSlider, % _RGB2 
    GuiControl, 4:, BSlider, % _RGB3 
  
    GuiControl, 4:,CurrentColor, % CurrentColor 
    GuiControl, 4:+Background%CurrentColor%, CurrentColor 

   GuiControl, 4:, CBSlider, 96 
   GoSub, UpdateSlider 
    
         GradientColorBand(CurrentColor) 
         GuiControl, 4:, ColorBand, %A_Temp%\ColorPicker_3x1.bmp 
   RETURN 
;   =========================================================== % 

;   =========================================================== % 

   BASCULE_ds_PREVIOUS: 

    GuiControl, 4:,CurrentColor_p, %CurrentColor% 
    GuiControl, 4:+Background%CurrentColor%, CColor_p 
       
   RETURN 
;   =========================================================== % 
;   ; =================================================================== // END of Ajout soggos 

; § ; =================================================================== % 
 ;------------------------------------------------------------------------ 
; Based on> WhatCOlor.ahk 
;          Show and copy the RRGGBB color under the cursor. 
;            Skrommel @2005 
;------------------------------------------------------------------------- 

   Couleur_SOUS_la_SOURIS1: 
    
   enAction=1 
    
Loop 
{ 
  Sleep,100 
  MouseGetPos,x,y 
  PixelGetColor,rgb,x,y,RGB 
  StringTrimLeft,rgb,rgb,2 
  ToolTip, %rgb%`nClick to Select Colour
  If rgb <> %Old_rgb% 
    {
	GuiControl, 4:,CurrentColor, %rgb% 
	GuiControl, 4: +Background%rgb%, CColor
	}
	
  Old_rgb:= rgb 
    GuiControl, 4:,LaCouleur, %rgb% 
	
  GetKeyState,state,Lbutton,P                     ; ATTENTE press 
  If state=D 
  { 
   Gosub AFFICHER_La_Couleur 
   Click 
   ToolTip 
   enAction=    
   Old_rgb= 
   break 
   Return 
   } 
   if enAction<>1 
   break 
} 
   RETURN 
 ;------------------------------------------------------------------------- 
;WhatCOlor.ahk 
; Show and copy the RRGGBB color under the cursor. 
;Skrommel @2005 
;------------------------------------------------------------------------- END 
;   ========================================================================= % 

; § ; =================================================================== 
; SetTimer, UPDATEDSCRIPT,1000   ; pour travailler efficacement le très bon UPDATEDSCRIPT par :> 
;  Skrommel(A real timesaver!) http://www.autohotkey.com/forum/viewtopic.php?t=135&highlight=updatedscript 

; L'execllent 
   UPDATEDSCRIPT: 
      FileGetAttrib,attribs,%A_ScriptFullPath% 
      IfInString,attribs,A 
      { 
        FileSetAttrib,-A,%A_ScriptFullPath% 
        posX = %A_CaretX% 
        posY = %A_CaretY% 
        ToolTip, Updated script> %A_ScriptName%, %posX%, %posY% 
        Sleep,500 
        Reload 
      } 
   Return 
;=================================================================== 
ini_getValue(ByRef _Content, _Section, _Key, _PreserveSpace = False)
{
    If (_Section = "")
        _Section = (?:\[.*])?
    Else
    {
         _Section = \[\s*?\Q%_Section%\E\s*?]
    }
    ; Note: The RegEx of this Function was rewritten by Mystiq.
    RegEx = `aiU)(?:\R|^)\s*%_Section%\s*(?:\R\s*|\R\s*.+\s*=\s*.*?\s*(?=\R)|\R\s*[;#].*?(?=\R))*\R\s*\Q%_Key%\E\s*=(.*)(?=\R|$)
    If RegExMatch(_Content, RegEx, Value)
    {
        If Not _PreserveSpace
        {
            Value1 = %Value1% ; Trim spaces.
            FirstChar := SubStr(Value1, 1, 1)
            If (FirstChar = """" And SubStr(Value1, 0, 1)= """"
                Or FirstChar = "'" And SubStr(Value1, 0, 1)= "'")
            {
                StringTrimLeft, Value1, Value1, 1
                StringTrimRight, Value1, Value1, 1
            }
        }
        ErrorLevel = 0
    }
    Else
    {
        ErrorLevel = 1
        Value1 =
    }
    Return Value1
}

StrX( H,  BS="",BO=0,BT=1,   ES="",EO=0,ET=1,  ByRef N="" ) { ;    | by Skan | 19-Nov-2009
Return SubStr(H,P:=(((Z:=StrLen(ES))+(X:=StrLen(H))+StrLen(BS)-Z-X)?((T:=InStr(H,BS,0,((BO
 <0)?(1):(BO))))?(T+BT):(X+1)):(1)),(N:=P+((Z)?((T:=InStr(H,ES,0,((EO)?(P+1):(0))))?(T-P+Z
 +(0-ET)):(X+P)):(X)))-P) ; v1.0-196c 21-Nov-2009 www.autohotkey.com/forum/topic51354.html
}

;                                                      _     _            _____   _
;  HtmDlg() - HTML DialogBox v0.51                    | |   | |_         (____ \ | | v0.51
;                                                     | |__ | | |_  ____  _   \ \| | ____
;  Suresh Kumar A N (arian.suresh@gmail.com)          |  __)| |  _)|    \| |   | | |/ _  |
;                                                     | |   | | |__| | | | |__/ /| ( ( | |
;  Created  : 09-Jul-2010                             |_|   |_|\___)_|_|_|_____/ |_|\_|| |
;  Last Mod : 13-Jul-2010                                                          (_____|
;
;  Usage : HtmDlg( URL, hwndOwner, Options, OptionsDelimiter )
;        :  For Options, please refer the bottom of this script
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

HtmDlg( _URL="", _Owner=0, _Options="", _ODL="," ) {

; HTML DialogBox v0.50 - scripted by SKAN : www.autohotkey.com/forum/viewtopic.php?t=60215

 static _Ins, _hDLG, _DlgT, _DlgP, _STRU, _pIWEB, _pV,                      BDef=1, BEsc=0

 If ( A_EventInfo = 0xCBF ) {                                    ; nested CallBackFunction
 hWnd := _URL,  uMsg := _Owner,  wP := _Options,  lP := _ODL

 If ( uMsg=0x112 && wP=0xF060 )  ; WM_SYSCOMMAND && SC_ClOSE
  Return DllCall( "EndDialog", UInt,_hDLG, UInt,BDEf := BEsc )

 If ( uMsg=0x111 && (wP>>16)=0 ) ; WM_COMMAND && BN_CLICKED
  Return DllCall( "EndDialog", UInt,_hDLG, UInt,BDef := (wP=2) ? BEsc : wP-100  )

 Return False
 }

 If ! ( _Ins ) {

 _Ins := DllCall( "GetModuleHandle", Str,A_AhkPath )
 _DT=
 ( Ltrim Join
   61160CD3AFCDD0118A3EGC04FC9E26EZPCHC88OAZO8G4DG53G2H53G68G65G6CG6CG2H44G6CG67Q58ZHDG741
   G74G6CG41G78G57G69G6EK7BG38G38G35G36G46G39G36G31G2DG33G34G3H41G2DG31G31G44G3H2DG41G39G3
   6G42G2DG3H3H43G3H34G46G44G37G3H35G41G32G7DT14NFBFFQ65GFFFF8Y14NFBFFQ66GFFFF8Y14NFBFFQ67
   GFFFF8Y14NFBFFQ68GFFFF8Y14NFBFFQ69GFFFF8Y14NFBFFQ6AGFFFF8Y14NFBFFQ6BGFFFF8Y14NFBFFQ6CGF
   FFF8Y14NFBFFQ6DGFFFF8T
 )

 Loop 20  ;  Decompressing Nulls : www.autohotkey.com/forum/viewtopic.php?p=198560#198560
  StringReplace,_DT,_DT,% Chr(70+21-A_Index),% SubStr("000000000000000000000",A_Index),All

 VarSetCapacity( _STRU, ( _DTLEN := StrLen(_DT) // 2 ) + 256, 0 )
 Loop %_DTLEN%                                       ;  Creating Binary Structure from Hex
  NumPut( "0x" . SubStr(_DT, 2*A_Index-1,2),_STRU,A_Index-1,"Char" )

 _pIWEB := &_STRU, _pV := &_STRU+16, _DlgT := &_STRU+32

 If ! DllCall( "GetModuleHandle", Str,"atl.dll" )
      DllCall( "LoadLibrary", Str,"atl.dll" )
      DllCall( "atl\AtlAxWinInit" )
 _DlgP := RegisterCallback( A_ThisFunc,0,4,0xCBF )

 }

 _hDLG := DllCall( "CreateDialogIndirectParam", UInt,_Ins, UInt,_DlgT, UInt, ( _Owner="" )
         ? DllCall("FindWindowA", Str,"AutoHotkey", Str,A_ScriptFullPath " - AutoHotkey v"
         . A_AhkVersion ) : _Owner, UInt,_DlgP, UInt,0 )

 VarSetCapacity( _WU,StrLen(_URL)*2+2 ), sLen := StrLen(_URL)+1
 DllCall( "MultiByteToWideChar", UInt,0, UInt,0, UInt,&_URL, Int,-1, UInt,&_WU, Int,sLen )

 _hHTM := DllCall( "GetDlgItem", UInt,_hDLG, UInt,2000, UInt )

 ; www.autohotkey.com/forum/viewtopic.php?p=103987#103987  WebBrowser Control Demo by Sean
 ; ---------------------------------------------------------------------------------------
 DllCall( "atl\AtlAxGetControl", UInt,_hHTM, UIntP,_ppunk )
 DllCall( NumGet( NumGet( _ppunk+0 )+4*0 ), UInt,_ppunk, UInt,_pIWEB, UIntP,_ppwb )
 DllCall( NumGet( NumGet( _ppunk+0 )+4*2 ), UInt,_ppunk ), _pwb := NumGet( _ppwb+0 )
 DllCall( NumGet(_pwb+4*11),UInt,_ppwb, UInt,&_WU, UInt,_pV,UInt,_pV,UInt,_pV,UInt,_pV )
 ; ---------------------------------------------------------------------------------------

 Slee:=-1, HtmD:=1
 Butt:="OK", BWid:=75, BHei:=23, BSpH:=5, BSpV:=8, BAli:=1
 DlgX:="", DlgY:="", HtmW:=280, HtmH:=140, Left:=5, TopM:=5

 Loop, Parse, _Options, =%_ODL%, %A_Space%
   A_Index & 1  ? ( __ := (SubStr(A_LoopField,1,1)="_") ? "_" : SubStr(A_LoopField,1,4))
                : ( %__% := A_LoopField )

 If ( HtmD )
   DllCall( "MoveWindow", UInt,_hHTM, UInt,0, UInt,0, UInt,HtmW, UInt,HtmH, Int,1 )
 Else {
   DllCall( "MoveWindow", UInt,_hHTM, UInt,Left, UInt,TopM, UInt,HtmW, UInt,HtmH, Int,1 )
   Control, Enable,,, ahk_id %_hHTM%
 }

 Cap := DllCall( "GetSystemMetrics", UInt,4  ) ; SM_CYCAPTION    = Window Caption
 Frm := DllCall( "GetSystemMetrics", UInt,7  ) ; SM_CXFIXEDFRAME = Window Frame
 SBW := DllCall( "GetSystemMetrics", UInt,2  ) ; SM_CXVSCROLL    = VScrollbar Width

 DlgW := Frm + HtmW + Frm + ( HtmD ? 0-SBW : Left+Left )
 DlgH := Cap + Frm + HtmH + BSpV + BHei + BSpV + Frm + ( HtmD ? 0 : TopM )
 DlgX := ( DlgX <> "" ) ? DlgX : ( A_ScreenWidth - DlgW ) // 2
 DlgY := ( DlgY <> "" ) ? DlgY : ( A_ScreenHeight - DlgH ) // 2
 ClAW := DlgW - Frm - Frm                                               ; ClientArea Width

 DllCall( "MoveWindow", UInt,_hDLG, UInt,DlgX, UInt,DlgY, UInt,DlgW, UInt,DlgH, Int,1 )

 StringReplace, Butt,Butt, /,/, UseErrorLevel
 bCount := ErrorLevel+1

 If BAli = 0                                                       
 BX := ( BSpH * 2 ) + ( HtmD ? 0 : Left )
 Else If BAli = 1                                                   
 BX := ( ClAW - (BSpH*(bCount-1)) - (BWid*bCount) ) / 2
 Else
 BX := ClAW - (BSpH*(bCount+1)) - (BWid*bCount) - ( HtmD ? 0 : Left )

 BY := HtmH + BSpV + ( HtmD ? 0 : TopM )

 Loop, Parse, Butt, /
  {
    BHwnd := DllCall( "GetDlgItem", UInt,_hDLG, UInt,100+A_Index )
    DllCall( "MoveWindow", UInt,BHwnd, UInt,BX, UInt,BY, UInt,BWid, UInt,BHei, Int,1 )
    DllCall( "SetWindowTextA", UInt,BHwnd, Str,A_LoopField ), BX := BX+BSpH+BWid
    DllCall( "ShowWindow", UInt,BHwnd, Int,True )
  }
 BDef := ( BDef<1 || BDef>bCount ) ? 1 : BDef
 DllCall( "SendMessageA", UInt,_hDLG, UInt,0x401, UInt,100+BDef, UInt,0 )    ; DM_SETDEFID
 ControlFocus,, % "ahk_id " DllCall( "GetDlgItem", UInt,_hDLG, UInt,100+BDef )

 DllCall( "SetWindowTextA", UInt,_hDLG, Str,Titl ? Titl : A_ScriptName )
 Sleep, %Slee%

 WinShow, ahk_id %_hDLG%
 WinWaitClose, ahk_id %_hDLG%,, %Time%

 If ( TimedOut := Errorlevel ) {
  DllCall( "EndDialog", UInt,_hDLG, UInt,0 )
 }

 If ( AltR=1 && BDef ) {
   StringSplit, B, Butt, /
   BDef := B%BDef%
 }

 DllCall( NumGet(_pwb+4*2), UInt,_ppwb ), DllCall( "SetLastError", UInt,TimedOut ? 1 : 0 )
Return BDEf
}

/* InternetFileRead                             
							  by SKAN ( Suresh Kumar A N, arian.suresh@gmail.com )
                                      Created: 24-Jun-2009 | LastEdit: 03-Jul-2009
                       Forum Topic: www.autohotkey.com/forum/viewtopic.php?t=45718
*/					   
InternetFileRead( ByRef V, URL="", RB=0, bSz=1024, DLP="DLP", F=0x84000000 ) {
 Static LIB="WININET\", QRL=16, CL="00000000000000", N=""
 If ! DllCall( "GetModuleHandle", Str,"wininet.dll" )
      DllCall( "LoadLibrary", Str,"wininet.dll" )
 If ! hIO:=DllCall( LIB "InternetOpenA", Str,N, UInt,4, Str,N, Str,N, UInt,0 )
   Return -1
 If ! (( hIU:=DllCall( LIB "InternetOpenUrlA", UInt,hIO, Str,URL, Str,N, Int,0, UInt,F
                                                            , UInt,0 ) ) || ErrorLevel )
   Return 0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 2
 If ! ( RB  )
 If ( SubStr(URL,1,4) = "ftp:" )
    CL := DllCall( LIB "FtpGetFileSize", UInt,hIU, UIntP,0 )
 Else If ! DllCall( LIB "HttpQueryInfoA", UInt,hIU, Int,5, Str,CL, UIntP,QRL, UInt,0 )
   Return 0 - ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) )
            - ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) ) - 4
 VarSetCapacity( V,64 ), VarSetCapacity( V,0 )
 SplitPath, URL, FN,,,, DN
 FN:=(FN ? FN : DN), CL:=(RB ? RB : CL), VarSetCapacity( V,CL,32 ), P:=&V,
 B:=(bSz>CL ? CL : bSz), TtlB:=0, LP := RB ? "Unknown" : CL,  %DLP%( True,CL,FN )
 Loop {
       If ( DllCall( LIB "InternetReadFile", UInt,hIU, UInt,P, UInt,B, UIntP,R ) && !R )
       Break
       P:=(P+R), TtlB:=(TtlB+R), RemB:=(CL-TtlB), B:=(RemB<B ? RemB : B), %DLP%( TtlB,LP )
       Sleep -1
 } TtlB<>CL ? VarSetCapacity( T,TtlB ) DllCall( "RtlMoveMemory", Str,T, Str,V, UInt,TtlB )
  . VarSetCapacity( V,0 ) . VarSetCapacity( V,TtlB,32 ) . DllCall( "RtlMoveMemory", Str,V
  , Str,T, UInt,TtlB ) . %DLP%( TtlB, TtlB ) : N
 If ( !DllCall( LIB "InternetCloseHandle", UInt,hIU ) )
  + ( !DllCall( LIB "InternetCloseHandle", UInt,hIO ) )
   Return -6
Return, VarSetCapacity(V)+((ErrorLevel:=(RB>0 && TtlB<RB)||(RB=0 && TtlB=CL) ? 0 : 1)<<64)
}
;  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; The following function is an add-on to provide "Download Progress" to InternetFileRead()
; InternetFileRead() calls DLP() dynamically, i.e., will not error-out if DLP() is missing
;  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DLP( WP=0, LP=0, Msg="" ) {
 If ( WP=1 ) {
 SysGet, m, MonitorWorkArea, 1
 y:=(mBottom-46-2), x:=(mRight-370-2), VarSetCapacity( Size,16,0 )
 DllCall( "shlwapi.dll\StrFormatByteSize64A", Int64,LP, Str,Size, UInt,16 )
 Size := ( Size="0 bytes" ) ? N : "«" Size "»"
 ;x%x% y%y% cut from below
 Progress, CWE6E3E4 CT000020 CBF73D00 w370 h46 B1 FS8 WM700 WS400 FM8 ZH8 ZY3
         ,, %Msg%  %Size%, InternetFileRead(), Tahoma
 ;WinSet, Transparent, 210, InternetFileRead()
 } Progress,% (P:=Round(WP/LP*100)),% "Completed: " wp " / " lp " [ " P "`% ]"
 IfEqual,wP,0, Progress, Off
}
;  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; The following function is a part of: VarZ 46L - Native Data Compression
; View topic : www.autohotkey.com/forum/viewtopic.php?t=45559
;  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

VarZ_Save( byRef V, File="" ) { ;   www.autohotkey.net/~Skan/wrapper/FileIO16/FileIO16.ahk
Return ( ( hFile :=  DllCall( "_lcreat", Str,File, UInt,0 ) ) > 0 )
                 ?   DllCall( "_lwrite", UInt,hFile, Str,V, UInt,VarSetCapacity(V) )
                 + ( DllCall( "_lclose", UInt,hFile ) << 64 ) : 0
}

ConnectedToInternet(flag=0x40) {
Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0)
}