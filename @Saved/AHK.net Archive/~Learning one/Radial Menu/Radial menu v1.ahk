;===Description=========================================================================
/*
RADIAL MENU v1         by Learning one
AHK forum location: http://www.autohotkey.com/forum/viewtopic.php?p=308352#308352

Draws radial menu when you press & hold RButton. Touch items with mouse to select them. Release RButton to hide menu.
After each selection, mouse will bounce back to center. You can easily select multiple items at once, just with one mouse click!
When I was writing this script, my goals were (sorted by priority):
1. minimize mouse clicks
2. minimize mouse movements
3. minimize eye movements
4. smallest possible but practical, and nice looking menu
5. keep normal RButton click function
All goals are successfully accomplished!

HOW DOES IT WORK? It simply draws 8 carefully positioned & shaped GUIs. See comments in script.
IMPORTANT: Menu items are identified by GUI's title, not by item's text. As GUI's titles are Item1, Item2 etc., we can say that items are identified by position.
SOME THOUGHTS: Don't think that 8 items are the limit of this menu! One item can be submenu that will open new radial menu! Or, selecting one "special" item
may also have effect like pressing modyfiers on you keyboard (Ctrl, Alt, etc.)! There are almost no limits! Such special items may have different color.
Also try to create context sensitive radial menu (menu items are different for different active windows). That's what I did. Add icons instead of item's text...
LICENCE : Select About in menu

HOTKEYS:
RButton         ; Press & hold to show menu. Touch items with mouse to select them. Release RButton to hide menu.
Escape         ; ExitApp
Pause         ; Pauses the script's current thread and suspends RButton Hotkey, but not Escape Hotkey!
*/


;===Settings============================================================================
TextSize = 7      ; Item's text size      I wanted very small but readable items. I do not recommend you to change text size. Once when you get used to your radial menu, you will remember item's positions, and text size won't be important to you. So you will select items by position in your mind, not by reading item's text.

TextColor = white   ; Item's text color
Font = Arial      ; Item's font

BuildDelay = 170   ; menu will start to show itself after %BuildDelay% miliseconds. To show it instantly, set 0. This delay gives you opportunity to send normal RButton click without annoying menu showing. THE BEST THING TO DO is to change hotkey to XButton1 or XButton1 (if you have them - I don't) and use BuildDelay = 0. MButton is also good idea.

BuildEffect = 30   ; menu items will show themself, one by one, in interval of %BuildEffect% ms. To show them all instantly, set 0.
DestroyEffect = 30   ; menu items will disappear, one by one, in interval of %BuildEffect% ms. To hide them all instantly, set 0.

SoundOnSelect = 1   ; 1 means: play sound when item is selected. 0 means don't play sound. Of coures you can change sound (near the end of the script).
Color = D3C419      ; this is alternative background color, if script can't load picture (button picture).

;Trans = 230      ; After few days of testing, I decided to disable this. It sets transparency of whole menu. If you want to enable this, delete semicolons in this line, and in line placed about 70 lines below ( ;WinSet, Transparent, %Trans% ). I do not recommend this procedure.


;===Auto-execute======================================================================
IfNotExist, %A_scriptdir%\Button.png
{
   URLDownloadToFile, http://www.autohotkey.net/~Learning one/Radial Menu/Button.png, %A_scriptdir%\Button.png
   Sleep, 500
}

StringTrimRight, Sname, A_ScriptName, 4
Menu, Tray, Tip, %Sname%
Loop, 8            ; load item's background (fake button), set altenative background and font
{
   Gui 9%A_Index%:Add, Picture, x0 y0 w40 h40, %A_scriptdir%\Button.png
   Gui 9%A_Index%:Font, s%TextSize%, %Font%
   Gui 9%A_Index%: Color, %Color%
}

;======Set item names======
; This is just example. Build your own menu! The bad thing is that you will sometimes have to manually reposition item's text.
Loop, 4
Gui 9%A_Index%:Add, Text, x2 y14 w36 Center BackgroundTrans c%TextColor% , Item%A_Index%   ; Auto build items 1-5

Gui 95:Add, Text, x2 y14 w36 Center BackgroundTrans c%TextColor% , Calc                  ; Calculator (as Item5)
Gui 96:Add, Text, x2 y14 w36 Center BackgroundTrans c%TextColor% , Notepad               ; Notepad (as Item6)
Gui 97:Add, Text, x2 y9 w36 Center BackgroundTrans c%TextColor% , Windows`nexplorer      ; Windows explorer (as Item7)
Gui 98:Add, Text, x2 y14 w36 Center BackgroundTrans c%TextColor% , About                  ; About (as Item8)
;==========================


;===Hotkey==============================================================================
RButton::   ; Press & hold to show menu. Touch items with mouse to select them. Release RButton to hide menu. THE BEST THING TO DO is to change hotkey to XButton1 or XButton1 if you have them ( I don't :( )
PressedTime = 0
CoordMode, mouse, Screen
MouseGetPos, mx1, my1
SetTimer, RadialMenuClose, 35

Loop, 8      ; Draw items at exact positions
{
   if A_index = 1
   {
      RMx := mx1-20
      RMy := my1-80
      if BuildDelay
      {
         Sleep , %BuildDelay%      ; menu will start to show itself after %BuildDelay% ms
         if not (GetKeyState("RButton","p"))
         Return
      }
   }
   Else if A_index = 2
   {
      RMx := mx1+25
      RMy := my1-65
   }
   Else if A_index = 3
   {
      RMx := mx1+40
      RMy := my1-20
   }
   Else if A_index = 4
   {
      RMx := mx1+25
      RMy := my1+25
   }
   Else if A_index = 5
   {
      RMx := mx1-20
      RMy := my1+40
   }
   Else if A_index = 6
   {
      RMx := mx1-65
      RMy := my1+25
   }
   Else if A_index = 7
   {
      RMx := mx1-80
      RMy := my1-20
   }
   Else if A_index = 8
   {
      RMx := mx1-65
      RMy := my1-65
   }

   Gui 9%A_Index%: +AlwaysOnTop +ToolWindow -caption +LastFound
   ;WinSet, Transparent, %Trans%
   WinSet, Region, 1-0 W40 H40 R25-25
   Gui 9%A_Index%: Show, x%RMx% y%RMy% h40 w40, Item%A_Index%   

   Sleep, %BuildEffect%
   if not (GetKeyState("RButton","p"))
   Return
}

SetTimer, GetSelectedItem, 15
Return


;===Subroutines=========================================================================
GetSelectedItem:         ; menu items are identified by GUI's title!
MouseGetPos, , , WinID
WinGetTitle, Item, ahk_id %WinID%

if Item contains Item      ; This is just example. Build your own menu!
{
   CoordMode, mouse, Screen
   MouseMove, %mx1%, %my1%
   if Item = Item8         ; About Radial menu
   {
      MsgBox, 64, About, Title:%A_Tab%Radial menu`nAuthor:%A_Tab%Learning one`nContact:%A_Tab%boris-mudrinic@net.hr`n`nLicence:`nFree for non-commercial use`nFor commercial use, e-mail me please.
      Return
   }
   else if Item = Item7   ; Runs Windows Explorer
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, %A_WinDir%\explorer.exe
      Return
   }
   else if Item = Item6   ; Runs Notepad
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, notepad
      Return
   }
   else if Item = Item5   ; Runs Calculator
   {
      if SoundOnSelect = 1
      SoundPlay, *-1    ; plays simple beep.
      Run, %A_WinDir%\system32\calc.exe
      Return
   }
   
   else
   MsgBox,, You selected:, %Item%,1.2
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
   Loop, 8
   {
      Gui 9%A_index%: Hide
      Sleep, %DestroyEffect%
   }
   
   Return
}
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