#SingleInstance,Force
;#NoTrayIcon
#Persistent
SetBatchLines,-1
SetFormat,Float,0.2
gui, font, s8, arial   ; Preferred font.

NumberOfWords=
NumberOfDots=
NumberOfDisplayedWords=2
ReadDelay:=60000/250
DotDelay:=2*ReadDelay


transform, PercentSign, chr, 37

;Gui, +AlwaysOnTop ;  -caption  -ToolWindow -SysMenu
;gui, font,, Arial
;Gui, Font, s20 , courier new
;Gui, Add, Text, x15 y17 w100 h50 vWordLeft Right, left
Gui, Font, s31
Gui, Add, Text, x2 y2 w626 h56 vTextLargeDisplay Center, ***clipboard too small***
;Gui, Font, s20
;Gui, Add, Text, xp+400 y17 w100 h50 vWordRight Left, right
Gui, Font, s8
Gui, Add, Button, x2 y65 w50 h30 +0x8000 vButtonRead gButtonRead +bold Default, &Read >
Gui, Add, GroupBox, xp+54 y57 w50 h39, Words
Gui, Add, DropDownList, x60 y70 w41 h20 R3 vDropdownNumber gDropdownNumber,1|2||3|
Gui, Add, GroupBox, x110 y57 w520 h39, Speed (wpm)
Gui, Add, Edit, xp+4 y71 w40 h20 +center vEditSpeed gEditSpeed, 250
Gui, Add, Slider, xp+43 y71 w470 h20 vSliderSpeed gSliderSpeed Range200-1000 TickInterval50 AltSubmit, 250
Gui, Add, Progress, x0 y97 w630 h10 vProgressBar, 25
Gui, -Resize +e0x20000
Gui, Show, x336 y221 h127 w630 , SpeedReader - compile 9/13/2006 11:20AM ; 2 words display
Gui, Add, StatusBar,, Number of words in the clipboard: 0
SB_SetParts(260)
GuiControl,, ProgressBar,0
Return



OnClipboardChange:
;ToolTip Loading clipboard to SpeedReader
;Sleep 500
if A_EventInfo = 1
{
	GoSub, COUNT
	Gui, Font, s31
	GuiControl,,TextLargeDisplay,***clipboard too small***
	Gui, font, s8, arial   ; Preferred font.
}
if NumberOfWords > 10
{
	StringReplace, ClipboardString, clipboard, `r`n, , All
	GoSub, DisplayFullClipboard
	Gui, show ;+AlwaysOnTop ;  -caption  -ToolWindow -SysMenu
}
;ToolTip  ; Turn off the tip.
return


COUNT:
NumberOfWords=
Loop,Parse,Clipboard,%A_Space%
{
	NumberOfWords+=1
}
SB_SetText("Number of words in the clipboard: " NumberOfWords,1)
NumberOfDots=
Loop,Parse,Clipboard,.
{
	NumberOfDots+=1
}
GoSub, EstimateReadingTime
Return


ButtonRead:
ReadCount=
ProgressTime=
ReadBreakCode=0
DisplayTextString=
GuiControlGet,NumberOfDisplayedWords,,DropdownNumber,
GuiControl,disable,DropdownNumber
; This prevents the parsing loop to skip the last/ 2 last words
GuiControl,,TextLargeDisplay,
Gui, Font, s31, arial
GuiControl, Font, TextLargeDisplay
GuiControl, +center, TextLargeDisplay
Loop,Parse,ClipboardString,%A_Space%
{
	ifequal, ReadBreakCode, 1, break
	ReadCount+=1
	ProgressValue:=100.0*ReadCount/NumberOfWords
	GuiControl,, ProgressBar,%ProgressValue%
;	Delay:=ln(StrLen(A_LoopField))*ReadDelay
;	Sleep %Delay%
	if DoubleWord < %NumberOfDisplayedWords%
	{
		DisplayTextString=%DisplayTextString% %A_LoopField%
		DoubleWord+=1
		continue
	}
	else
	{
		GuiControl,,TextLargeDisplay,%DisplayTextString%
		StringRight, Q, DisplayTextString, 1
		IfEqual, Q,.
		{
			Sleep %DotDelay%
			ProgressTime+=DotDelay/500.0
		}
		Sleep %ReadDelay%
		DisplayTextString=%A_LoopField%
		DoubleWord=1
	}
	ProgressTime+=ReadDelay/1000.0
	String=Reading time: %ProgressTime% s
	SB_SetText(String,2)

}
GuiControl,,TextLargeDisplay,%DisplayTextString%
Sleep %ReadDelay%
Sleep %DotDelay%
GuiControl,enable,DropdownNumber
GoSub, DisplayFullClipboard
GoSub, EstimateReadingTime
GuiControl,, ProgressBar,0
Return


Pause::
pause
Return

Esc::
ReadBreakCode=1
return


SliderSpeed:
GuiControlGet,WordPerMinute,,SliderSpeed, ; WordPerMinute in wpm
ReadDelay:=60000/WordPerMinute
GoSub, EstimateReadingTime
GuiControl,,EditSpeed,%WordPerMinute%
return


EditSpeed:
GuiControlGet,WordPerMinute,,EditSpeed, ; WordPerMinute in wpm
ReadDelay:=60000/WordPerMinute
GoSub, EstimateReadingTime
GuiControl,,SliderSpeed,%WordPerMinute%
return


DropdownNumber:
GuiControlGet,NumberOfDisplayedWords,,DropdownNumber,
GuiControlGet,WordPerMinute,,EditSpeed, ; WordPerMinute in wpm
GoSub, EstimateReadingTime
return


EstimateReadingTime:
DotDelay:=2*ReadDelay
TotalTime:=(ReadDelay*NumberOfWords/NumberOfDisplayedWords+DotDelay*NumberOfDots)/1000.0
String=Estimated reading time: %TotalTime% s
SB_SetText(String,2)
return


DisplayFullClipboard:
Gui, Font, s7, small fonts
GuiControl, Font, TextLargeDisplay
GuiControl, +left, TextLargeDisplay
GuiControl,,TextLargeDisplay,%ClipboardString%
Gui, font, s8, arial   ; Preferred font.
return:


GuiSize:
If A_EventInfo=1
  Return
GuiControl,Move,listview, % "W" . (A_GuiWidth - 10) . " H" . (A_GuiHeight - 77)
GuiControl,Move,box3, % "x" (A_GuiWidth - 350) "W" . (A_GuiWidth - 300) . " H" . (72)
Return



GuiClose:
ExitApp
