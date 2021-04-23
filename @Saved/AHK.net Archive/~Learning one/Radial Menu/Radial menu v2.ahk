SetBatchLines, -1   ; just temporary, to do all Auto-execute as fast as possible


;===Description=========================================================================
/*
RADIAL MENU v2        by Learning one
AHK forum location: http://www.autohotkey.com/forum/viewtopic.php?p=308352#308352

Draws radial menu when you press & hold RButton. Touch items with mouse to select them. Release RButton to hide menu.
After each selection, mouse will bounce back to center. You can easily select multiple items at once, just with one mouse click!

When I was writing this script, my goals were (sorted by priority):
1. minimize mouse clicks
2. minimize mouse movements
3. minimize eye movements
4. support longer item names than in RADIAL MENU v1
5. not too big, practical, and nice looking menu
6. preserve normal RButton click function
7. write script in tidy, neat style to ease studying and modifying job for all members of AHK community
8. add some special effects

HOW DOES IT WORK? It simply draws 8 carefully positioned & shaped GUIs. See comments in script.
IMPORTANT: Menu items are identified by GUI's title, not by item's text. As GUI's titles are Item1, Item2 etc., we can say that items are identified by position.
I was using high GUI numbers, so you can easily implant Radial menu in your script.

SOME THOUGHTS: Don't think that 8 items are the limit of this menu! One item can be submenu that will open new radial menu! Or, selecting one "special" item
may also have effect like pressing modyfiers on you keyboard (Ctrl, Alt, etc.)! There are almost no limits! Such "special" items may have different
color or may be slightly transparent. Also try to create context sensitive radial menu (menu items are different for different active windows).
That's what I did (my private version). Add icons instead of item's text. Change item's background picture (try to use 70x70 images).
Add some sounds. Create different menu build effect. There are plenty of "make-up" and functional possibilities.

LICENCE:
Free for non-commercial use.
For commercial use, e-mail me please.
If you will use Radial menu in your free software,
mention author's name and contact.
Author:		Boris Mudrinic (Learning one on AHK forum)
Contact:	boris-mudrinic@net.hr

HOTKEYS:
RButton		; Press & hold to show menu. Touch items with mouse to select them. Release RButton to hide menu.
Escape		; ExitApp
Pause		; Pauses the script's current thread and suspends RButton Hotkey, but not Escape Hotkey!

CODE STRUCTURE:
Settings
Auto-execute
Hotkey
Subroutines
   GetSelectedItem
   RadialMenuClose
   ItemBounceOnSel
My standard ExitApp and Suspend+Pause hotkeys

For those who don't know, you can change item's action in GetSelectedItem subroutine
*/


;===Settings============================================================================
TextSize = 9		; Item's text size      Once when you get used to your radial menu, you will remember item's positions, and text size won't be so important to you. So you will select items by position in your mind, not by reading item's text.
TextColor = white	; Item's text color
Font = Arial		; Item's font
BuildDelay = 190	; menu will start to show itself after %BuildDelay% miliseconds. To show it instantly, set 0. This delay gives you opportunity to send normal RButton click without annoying menu showing. THE BEST THING TO DO is to change hotkey to XButton1 or XButton1 (if you have them - I don't) and use BuildDelay = 0. MButton is also good idea.
BuildEffect = 30	; menu items will show themself, one by one, in interval of %BuildEffect% ms. To show them all instantly, set 0.
ButtonBack = Button3.png	; Button's background


ItemBounce = 1      ; 1 means: items will bounce when you select them. 0 means: items will not bounce.
SoundOnSelect = 1	; 1 means: play sound when item is selected. 0 means: don't play sound. Of course, you can change sound...
; SoundOnShow		; Play with effects: you can easily add this by slightly modifying script...
; SoundOnDestroy	
Color = Black		; this is alternative background color, if script can't load picture (button picture).


;===Auto-execute======================================================================
IfNotExist, %A_scriptdir%\%ButtonBack%
{
   URLDownloadToFile, http://www.autohotkey.net/~Learning one/Radial Menu/%ButtonBack%, %A_scriptdir%\%ButtonBack%
   Sleep, 500
}

StringTrimRight, Sname, A_ScriptName, 4
Menu, Tray, Tip, %Sname%
Loop, 8                 ; load item's background (fake button), set altenative background and font
{
   ; If you want to change item's background, try to use 70x70 images. Some other backgrounds are available on:
   ; http://www.autohotkey.net/~Learning one/Radial Menu
   
   ; Play with effects: small deviations in Add, Picture options have interesting effect:
   ; x0 y-1 w69 h69     ; small shadow
   ; x0 y-1 w71 h71     ; no shadow
   Gui 9%A_Index%:Add, Picture, x0 y-1 w69 h69 , %A_scriptdir%\%ButtonBack%
   Gui 9%A_Index%:Font,  s%TextSize%, %Font%
   Gui 9%A_Index%: Color, %Color%
}

;======Set item names======
; This is just example. Build your own menu! You don't need to manually reposition item's text (like in Radial menu v1).

; Play with effects: Remove BackgroundTrans in GuiTextOptions and set Color = 757500 (GUI's color)
GuiTextOptions = x7 y10 w56 h50 c%TextColor% BackgroundTrans

Loop, 4
Gui 9%A_Index%:Add, Text, %GuiTextOptions% , Item%A_Index%	; Auto build items 1-5

Gui 95:Add, Text, %GuiTextOptions% , Calc					; Calculator (as Item5)
Gui 96:Add, Text, %GuiTextOptions% , Notepad				; Notepad (as Item6)
Gui 97:Add, Text, %GuiTextOptions% , Windows`nexplorer		; Windows explorer (as Item7)
Gui 98:Add, Text, %GuiTextOptions% , About					; About (as Item8)
;==========================

SetBatchLines, 10ms		; default 

;===Hotkey==============================================================================
RButton::   ; Press & hold to show menu. Touch items with mouse to select them. Release RButton to hide menu. THE BEST THING TO DO is to change hotkey to XButton1 or XButton1 if you have them ( I don't :( )
PressedTime = 0
CoordMode, mouse, Screen
MouseGetPos, mx1, my1
SetTimer, RadialMenuClose, 35

Loop, 8      ; Draw items (GUIs) at exact positions
{
   if A_index = 1
   {
     RMx := mx1-35
     RMy := my1-135
      if BuildDelay
      {
         Sleep , %BuildDelay%      ; menu will start to show itself after %BuildDelay% ms
         if not (GetKeyState("RButton","p"))
         Return
      }
   }
   Else if A_index = 2
   {
      RMx := mx1+33
      RMy := my1-103
   }
   Else if A_index = 3
   {
      RMx := mx1+65
      RMy := my1-35
   }
   Else if A_index = 4
   {
      RMx := mx1+33
      RMy := my1+33
   }
   Else if A_index = 5
   {
      RMx := mx1-35
      RMy := my1+65
   }
   Else if A_index = 6
   {
      RMx := mx1-103
      RMy := my1+33
   }
   Else if A_index = 7
   {
      RMx := mx1-135
      RMy := my1-35
   }
   Else if A_index = 8
   {
      RMx := mx1-103
      RMy := my1-103
   }

   Gui 9%A_Index%: +AlwaysOnTop +ToolWindow -caption +LastFound
   WinSet, Region, 1-0 W70 H70 R25-25
   Gui 9%A_Index%: Show, x%RMx% y%RMy% h70 w70, Item%A_Index%   
   WinSet, Transparent, 255, Item%A_Index%
   
   Sleep, %BuildEffect%
   if not (GetKeyState("RButton","p"))
   Return
}

SetTimer, GetSelectedItem, 15
Return


;===Subroutines=========================================================================
GetSelectedItem:            ; menu items are identified by GUI's title!
MouseGetPos, , , WinID
WinGetTitle, Item, ahk_id %WinID%

if Item contains Item      ; This is just example. Build your own menu!
{
   CoordMode, mouse, Screen
   MouseMove, %mx1%, %my1%
   if Item = Item8         ; About Radial menu
   {
      if ItemBounce = 1
	  Gosub, ItemBounceOnSel
	  MsgBox, 64, About, Title:%A_Tab%Radial menu v2`nAuthor:%A_Tab%Boris Mudrinic (Learning one on AHK forum)`nContact:%A_Tab%boris-mudrinic@net.hr`n`nLicence:`nFree for non-commercial use.`nFor commercial use, e-mail me please.`n`nIf you will use Radial menu in your free software,`nmention author's name and contact.
      Return
   }
   else if Item = Item7   ; Runs Windows Explorer
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, %A_WinDir%\explorer.exe
	  if ItemBounce = 1
	  Gosub, ItemBounceOnSel
      Return
   }
   else if Item = Item6   ; Runs Notepad
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, notepad
	  if ItemBounce = 1
	  Gosub, ItemBounceOnSel
      Return
   }
   else if Item = Item5   ; Runs Calculator
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, %A_WinDir%\system32\calc.exe
	  if ItemBounce = 1
	  Gosub, ItemBounceOnSel
      Return
   }
   else
   {
      if ItemBounce = 1
      Gosub, ItemBounceOnSel
      MsgBox,, You selected:, %Item%,1
	}
}
Return
   
RadialMenuClose:
PressedTime++
if not (GetKeyState("RButton","p"))
{
   if (PressedTime < 7)   ; if user holded RButton for less than 210ms ...
   SendInput, {RButton}   ; ... script will send normal RButton click
   
   SetTimer, GetSelectedItem, off
   SetTimer, RadialMenuClose, off
   
	; Fade out effect
	InitialTrans = 255 
	Loop, 17
	{
		Loop, 8
		WinSet, Transparent, %InitialTrans%, Item%A_Index%
		InitialTrans -= 15
		Sleep, 25			; change fade out speed if you wish
	}
	Loop, 8
	Gui 9%A_index%: Hide
	Return
}
Return

ItemBounceOnSel:        ; bounce effect
Critical
WinGetPos, XBounce, YBounce,,, %Item%
SetTimer, RadialMenuClose, off
SetTimer, GetSelectedItem, off
SetWinDelay, 5          ; bounce speed

if Item = Item1
{
   Loop, 8 
   {
      if A_Index <= 4
      YBounce -= 4      ; bounce lenght
      Else
      YBounce += 4
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item2
{
   Loop, 8 
   {
      if A_Index <= 4
      {
         XBounce += 4 
         YBounce -= 4
      }
      Else
      {
         XBounce -= 4 
         YBounce += 4
      }
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item3
{
   Loop, 8 
   {
      if A_Index <= 4
      XBounce += 4 
      Else
      XBounce -= 4 
     WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item4
{
   Loop, 8 
   {
      if A_Index <= 4
      {
         XBounce += 4 
         YBounce += 4
      }
      Else
      {
         XBounce -= 4 
         YBounce -= 4
      }
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item5
{
   Loop, 8 
   {
      if A_Index <= 4
      YBounce += 4
      Else
      YBounce -= 4
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item6
{
   Loop, 8 
   {
      if A_Index <= 4
      {
         XBounce -= 4 
         YBounce += 4
      }
      Else
      {
         XBounce += 4 
         YBounce -= 4
      }
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item7
{
   Loop, 8 
   {
      if A_Index <= 4
      XBounce -= 4 
      Else
      XBounce += 4
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}
else if Item = Item8
{
   Loop, 8 
   {
      if A_Index <= 4
      {
         XBounce -= 4 
         YBounce -= 4
      }
      Else
      {
         XBounce += 4 
         YBounce += 4
      }
      WinMove, %Item%, , %XBounce%, %YBounce%
   }
}

SetWinDelay, 100    ; default
SetTimer, GetSelectedItem, on
SetTimer, RadialMenuClose, on
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ExitApp
Pause::
Suspend
Pause,,1
return

Escape::
Suspend
ExitApp
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;