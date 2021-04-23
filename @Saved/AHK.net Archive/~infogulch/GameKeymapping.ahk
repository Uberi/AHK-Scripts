;*** ----------------<<<General Info, Instructions, and Expansion>>>-------------------
/*
....:::Info:::...
Made for: AutoHotkey Ver. 1.0.47.06

Made by user: infogulch
Version: 1.1
Date released: 

Adapted by: 
Adaptation version: 
Adaptation release date:


()()()()()()()()()()()Instructions()()()()()()()()()()()
I don't really know how to start, so I'll just throw it all at
you and hope you get it. ;)

This script is made to click at user defined spots in a window.
It has been set up to pull nearly everything from a csv file 
in the same directory as this script, so it's easily compiled
while still maintaning it's customizeablilty. It was originally 
intended for DragonFable, (http://dragonfable.battleon.com/game/)
but that's a limited user group and it's possibilities are 
much larger. You can even have multiple csv files for multiple
configurations

TO USE, it is highly recommended that you open up the csv file 
with a SPREADSHEET PROGRAM, as it is much easier to edit in 
that than just plain text. (try OpenOffice.org, or google docs, 
if you don't have one)

Because it's a csv, it's devoid of formatting/protection that
would make it easier to understand, but fyi, the first, third, 
fourth, fifth and sixth rows are to explain things a little 
bit, and aren't read by this program. You might be able to
understand it all from there, but if not, here goes:

Cell a2 = the title of the window to limit these keystrokes to.
Cell b2 = the contents of this cell modifies all clicks for x
Cell c2 = the contents of this cell modifies all clicks for y
Cell d2 = the number of lines to read (corresponds to the num
	in col E)

Cells a7 down = the x coordinate for each click
Cells b7 down = the y coordinate for each click
Cells c7 down = turn each hotkey on or off
Cells d7 down = the hotkey for this command

An Example:
DragonFable is a flash game, and I never 
had luck using "controlclick" on it, so I just decided to use 
regular "click". The game itself stays the same size, but I 
noticed that the game automatically centers itself in the 
browser, expected, but it added some complication. I found 
that if I have it "get" the window width, and divide it in half, 
that gives me the center of the window, and in turn, the center 
of the game. If I took that, and subtracted half of the 
game's width, I'd have the edge of the game, always, even if 
the window was resized. Half the game's width is what you put 
in the "OverallX" variable that you set up in the csv. The 
"OverallY" is from the top of the window to the top of your game.

What all this does is reposition the 0,0 click coordinates to 
the top left corner of the game, not the window, so now you can 
just focus on the game's internal click coordinates. You can find 
these out by taking a screenshot of the button you want to click, 
(Ctrl+PrintScreen) croping it right at the edges of the game, and 
using an editor other than mspaint, (try Paint.NET. Search for it.)
move your mouse over the place you want to click and look at the 
bottom of the editor - it shows you the coordinates.

Here's the simplified formula that is given to the "click" command:

The x coord:
WindowWidth//2 + X + OverallX

The y coord:
Y + OverallY

to combine them:
 . ", " . 


()()()()()()()()()()()Expansion()()()()()()()()()()()
If 36 hotkeys aren't enough for you, this is your section. 
To expand this script to use more than 36 click spots, copy the 
"script expansion1" line to the bottom of the <<<Hotkeys>>> 
section, and the "script expansion2" lines to the bottom of the 
<<<Labels>>> section. "Find and Replace" the "@" symbol in your
editor with the next number in series. (so if the hotkey above
is 43, replace @ with 44) (Try going "down", without "wrapping"
in your find dialog, that way you can just "replace all")

Rember to set the csv file to read as many lines as there are 
hotkeys in the <<<hotkeys>>> section and to always assign a hotkey, 
even if you turn it off. Otherwise it will error out on you.

script expansion1: (1 Line)
HotKey, %Game_@_Key%, Game_@_ClickSpot, %Game_@_OnOff%


script expansioin2: (3 Lines)
Game_@_ClickSpot:
	FuncClick(Game_@_x, Game_@_y, @)
return


....:::Other:::....
Whew!! That was some doozy instructions, but now they're over! woohoo! ;)
Now you can use it! Good luck!!

To Do:
1. Write a better description and instructions. 
	(it's first on the list but will probably be done last. :P)
2. Add "Random" to the click formula - DONE!
3. Pull the formulas for clicking from the csv file.
4. Pull the random min and max from the csv file.
5. Try adding controlclick agian
6. Compile this script.
7. I'll think of something, there's always something...
*/
;*

SetTitleMatchMode, 2
GroupAdd, ThisScript, %A_ScriptName% ;For "SaveDoesReload" at the bottom of the script

FileReadLine, Game_TempFirst, %A_ScriptDir%\GameArrayInfo.csv , 2
StringSplit, Game_BaseInfo, Game_TempFirst, `,,"

Game_WindowTitle := Game_BaseInfo1
Game_OverallX := Game_BaseInfo2
Game_OverallY := Game_BaseInfo3

GroupAdd, Game_WinTitle, %Game_WindowTitle%

;Debug:
;MsgBox,1,, Window Title: %Game_BaseInfo1% `n`nOverall X: %Game_BaseInfo2% `nOverall Y: %Game_BaseInfo3% `n`n Number of lines to read: `n%Game_BaseInfo4% `n`nIs this correct?
;IfMsgBox Cancel
;	return

Loop %Game_BaseInfo4%
{
	Game_LineNum := A_Index + 6
	FileReadLine, Game_TempSecond, %A_ScriptDir%\GameArrayInfo.csv , %Game_LineNum%
	StringSplit, Game_Temp, Game_TempSecond, `,, "
	Game_%A_Index%_x := Game_Temp1
	Game_%A_Index%_y := Game_Temp2
	Game_%A_Index%_OnOff := Game_Temp3
	Game_%A_Index%_Key := Game_Temp4
	;Debug:
	;MsgBox,1, Read Number %A_Index%, X, Y: %Game_Temp1%, %Game_Temp2% `n`nON/OFF: %Game_Temp3%`n`n KeyName: %Game_Temp4%
	;IfMsgBox Cancel
	;	return
}

;*** ----------------<<<HotKeys>>>-------------------
Hotkey, IfWinActive, ahk_group Game_WinTitle
HotKey, %Game_1_Key%, Game_1_ClickSpot, %Game_1_OnOff%
HotKey, %Game_2_Key%, Game_2_ClickSpot, %Game_2_OnOff%
HotKey, %Game_3_Key%, Game_3_ClickSpot, %Game_3_OnOff%
HotKey, %Game_4_Key%, Game_4_ClickSpot, %Game_4_OnOff%
HotKey, %Game_5_Key%, Game_5_ClickSpot, %Game_5_OnOff%
HotKey, %Game_6_Key%, Game_6_ClickSpot, %Game_6_OnOff%
HotKey, %Game_7_Key%, Game_7_ClickSpot, %Game_7_OnOff%
HotKey, %Game_8_Key%, Game_8_ClickSpot, %Game_8_OnOff%
HotKey, %Game_9_Key%, Game_9_ClickSpot, %Game_9_OnOff%
HotKey, %Game_10_Key%, Game_10_ClickSpot, %Game_10_OnOff%
HotKey, %Game_11_Key%, Game_11_ClickSpot, %Game_11_OnOff%
HotKey, %Game_12_Key%, Game_12_ClickSpot, %Game_12_OnOff%
HotKey, %Game_13_Key%, Game_13_ClickSpot, %Game_13_OnOff%
HotKey, %Game_14_Key%, Game_14_ClickSpot, %Game_14_OnOff%
HotKey, %Game_15_Key%, Game_15_ClickSpot, %Game_15_OnOff%
HotKey, %Game_16_Key%, Game_16_ClickSpot, %Game_16_OnOff%
HotKey, %Game_17_Key%, Game_17_ClickSpot, %Game_17_OnOff%
HotKey, %Game_18_Key%, Game_18_ClickSpot, %Game_18_OnOff%
HotKey, %Game_19_Key%, Game_19_ClickSpot, %Game_19_OnOff%
HotKey, %Game_20_Key%, Game_20_ClickSpot, %Game_20_OnOff%
HotKey, %Game_21_Key%, Game_21_ClickSpot, %Game_21_OnOff%
HotKey, %Game_22_Key%, Game_22_ClickSpot, %Game_22_OnOff%
HotKey, %Game_23_Key%, Game_23_ClickSpot, %Game_23_OnOff%
HotKey, %Game_24_Key%, Game_24_ClickSpot, %Game_24_OnOff%
HotKey, %Game_25_Key%, Game_25_ClickSpot, %Game_25_OnOff%
HotKey, %Game_26_Key%, Game_26_ClickSpot, %Game_26_OnOff%
HotKey, %Game_27_Key%, Game_27_ClickSpot, %Game_27_OnOff%
HotKey, %Game_28_Key%, Game_28_ClickSpot, %Game_28_OnOff%
HotKey, %Game_29_Key%, Game_29_ClickSpot, %Game_29_OnOff%
HotKey, %Game_30_Key%, Game_30_ClickSpot, %Game_30_OnOff%
HotKey, %Game_31_Key%, Game_31_ClickSpot, %Game_31_OnOff%
HotKey, %Game_32_Key%, Game_32_ClickSpot, %Game_32_OnOff%
HotKey, %Game_33_Key%, Game_33_ClickSpot, %Game_33_OnOff%
HotKey, %Game_34_Key%, Game_34_ClickSpot, %Game_34_OnOff%
HotKey, %Game_35_Key%, Game_35_ClickSpot, %Game_35_OnOff%
HotKey, %Game_36_Key%, Game_36_ClickSpot, %Game_36_OnOff%
;*

EndAutoExec:
return

;*** ----------------<<<Lables>>>-------------------

Game_1_ClickSpot:
	WinGetPos ,,, Game_WinWidth, Game_WinHeight, ahk_group Game_WinTitle
	Game_Click := Game_WinWidth//2+Game_1_x+Game_OverallX . ", " . Game_1_y+Game_OverallY
	;Debug:
	;MsgBox,1,, For Number: 1 (Test. Note: This click is not random.) `n`nClick Coord: %Game_Click% `n`nOverall Modifiers: `n%Game_OverallX%, %Game_OverallY% `n`n Individual Modifiers: %x%, %y% `n`nWindow Width: %Game_WinWidth%`n`n Is this correct?
	;IfMsgBox Cancel
	;	return
	Click %Game_Click%
return

Game_2_ClickSpot:
	FuncClick(Game_2_x, Game_2_y, 2)
return

Game_3_ClickSpot:
	FuncClick(Game_3_x, Game_3_y, 3)
return

Game_4_ClickSpot:
	FuncClick(Game_4_x, Game_4_y, 4)
return

Game_5_ClickSpot:
	FuncClick(Game_5_x, Game_5_y, 5)
return

Game_6_ClickSpot:
	FuncClick(Game_6_x, Game_6_y, 6)
return

Game_7_ClickSpot:
	FuncClick(Game_7_x, Game_7_y, 7)
return

Game_8_ClickSpot:
	FuncClick(Game_8_x, Game_8_y, 8)
return

Game_9_ClickSpot:
	FuncClick(Game_9_x, Game_9_y, 9)
return

Game_10_ClickSpot:
	FuncClick(Game_10_x, Game_10_y, 10)
return

Game_11_ClickSpot:
	FuncClick(Game_11_x, Game_11_y, 11)
return

Game_12_ClickSpot:
	FuncClick(Game_12_x, Game_12_y, 12)
return

Game_13_ClickSpot:
	FuncClick(Game_13_x, Game_13_y, 13)
return

Game_14_ClickSpot:
	FuncClick(Game_14_x, Game_14_y, 14)
return

Game_15_ClickSpot:
	FuncClick(Game_15_x, Game_15_y, 15)
return

Game_16_ClickSpot:
	FuncClick(Game_16_x, Game_16_y, 16)
return

Game_17_ClickSpot:
	FuncClick(Game_17_x, Game_17_y, 17)
return

Game_18_ClickSpot:
	FuncClick(Game_18_x, Game_18_y, 18)
return

Game_19_ClickSpot:
	FuncClick(Game_19_x, Game_19_y, 19)
return

Game_20_ClickSpot:
	FuncClick(Game_20_x, Game_20_y, 20)
return

Game_21_ClickSpot:
	FuncClick(Game_21_x, Game_21_y, 21)
return

Game_22_ClickSpot:
	FuncClick(Game_22_x, Game_22_y, 22)
return

Game_23_ClickSpot:
	FuncClick(Game_23_x, Game_23_y, 23)
return

Game_24_ClickSpot:
	FuncClick(Game_24_x, Game_24_y, 24)
return

Game_25_ClickSpot:
	FuncClick(Game_25_x, Game_25_y, 25)
return

Game_26_ClickSpot:
	FuncClick(Game_26_x, Game_26_y, 26)
return

Game_27_ClickSpot:
	FuncClick(Game_27_x, Game_27_y, 27)
return

Game_28_ClickSpot:
	FuncClick(Game_28_x, Game_28_y, 28)
return

Game_29_ClickSpot:
	FuncClick(Game_29_x, Game_29_y, 29)
return

Game_30_ClickSpot:
	FuncClick(Game_30_x, Game_30_y, 30)
return

Game_31_ClickSpot:
	FuncClick(Game_31_x, Game_31_y, 31)
return

Game_32_ClickSpot:
	FuncClick(Game_32_x, Game_32_y, 32)
return

Game_33_ClickSpot:
	FuncClick(Game_33_x, Game_33_y, 33)
return

Game_34_ClickSpot:
	FuncClick(Game_34_x, Game_34_y, 34)
return

Game_35_ClickSpot:
	FuncClick(Game_35_x, Game_35_y, 35)
return

Game_36_ClickSpot:
	FuncClick(Game_36_x, Game_36_y, 36)
return

;*

FuncClick(x,y,z)
{
	global
	Random, Rand1, -2, 2
	Random, Rand2, -2, 2
	WinGetPos ,,, Game_WinWidth, Game_WinHeight, ahk_group Game_WinTitle
	Game_Click := Game_WinWidth//2+x+Game_OverallX+Rand1 . ", " . y+Game_OverallY+Rand2
	;Debug:
	;MsgBox,1,, For Number: %z% `n`nClick Coord: %Game_Click% `n`nOverall Modifiers: %Game_OverallX%, %Game_OverallY% `n`nIndividual Modifiers: %x%, %y% `n`nWindow Width: %Game_WinWidth% `n`nRandom: %Rand1%, %Rand2% `n`nIs this correct?
	;IfMsgBox Cancel
	;	return
	Click %Game_Click%
}

;*** <<<SaveDoesReload>>>
#IfWinActive ahk_group ThisScript
~^s::
	#SingleInstance force
	ToolTip, %A_ScriptName%   -   Updating in 3. ,
	Sleep, 250
	ToolTip, %A_ScriptName%   -   Updating in 2. . ,
	Sleep, 200
	ToolTip, %A_ScriptName%   -   Updating in 1. . . ,
	Sleep, 200
	ToolTip, Updating. . . . ,
	Run, %A_ScriptFullPath%
return
;*