;Mango: Clipboard Stuff
; Creator: tidbit
; Version: 1.10
/*
Hide
Options:
(X) 	on/off: Mode: Add to clipboard.
(X) 	on/off: Notify on change.
(X) 	on/off: Save cliptext to a file.
(X) 	on/off: Load on Startup.
(X) 	on/off: Auto Save settings?
	-----
(X)	Save Settings
        Restart
        ExitApp
Count
Clipboard:
        Revert to Previous
        Save to file.
        View (.clp)
        -----
        UPPERCASE.
        lowercase.
        Sentence case.
        Title Case.
        iNVERSE cASE.
        -----
        Sort
        Spaces-->Tabs
        Tabs-->Spaces
        Remove trailing spaces
        Remove leading spaces
        Remove double blank lines
        -----
        Force Close current window.
        Get window under mouse.
        -----
        Google search
        Google Image search
        Run AHK code.
History:
        1-20
        Saved Clips
Plugins:
        Find/Replace
        Tag Stripper
(~)	Trim left/right
(~)	Paste special
(X)	Color Picker


*/
/*
Credits:
JDN			NVERT cASE
Rajat		Smart GUI Creator
kiu			Clipboard History
*/

#SingleInstance Force
SetWorkingDir %A_ScriptDir%
j=0
numberOfElements:=20 


previousClip= 
clipIndex:=0 
pom=enabled 
menu, tray, NoStandard 
menu, tray, add, Paste Only mode, pom 
menu, tray, add, Paste/Edit/Save mode,pesm 
menu, tray, add, History features, features 
menu, tray, add, Exit,exitapplication 
Menu,History2,add,Paste,clipPaste 
Menu,History2,add,Edit,clipPaste 
Menu,History2,add,Save,clipPaste 
IfNotExist, data 
   FileCreateDir, data 
IfNotExist, data\saved 
   FileCreateDir, data\saved 

;~ Menu, options, add, Mode: Add to clipboard., addmode
;~ Menu, options, add, Notify clipboard changes., notifychange
;~ Menu, options, add, save clipboard text to a file., savetofile
;~ Menu, options, add, Load on System startup?, startup
;~ Menu, options, add, Autosave settings?, savesettings
;~ Menu, options, add
;~ Menu, options, add, save Settings., savesettings
Menu, options, add, restart Mango., restart
Menu, options, add, Exit Mango., exitscript


Menu, tools, add, -Tools-, disabled
Menu, tools, add, &A    Revert to previous., prev
Menu, tools, add, &B    save to file, save
Menu, tools, add, &C    view (.clp), view
Menu, tools, add, -Case-, disabled
Menu, tools, add, &D    UPPERCASE., ucase
Menu, tools, add, &E    lowercase., lcase
Menu, tools, add, &F    Sentence case., scase
Menu, tools, add, &G    Title Case., tcase
Menu, tools, add, &H    iNVERSE cASE., icase
Menu, tools, add, -Organization-, disabled
Menu, tools, add, &I    Sort A-Z, sortaz
Menu, tools, add, &J    Sort Z-A, sortza
Menu, tools, add, &K    Sort random, sortrand
Menu, tools, add, &L    Spaces-->Tabs, StoT
Menu, tools, add, &M    Tabs-->Spaces, TtoS
Menu, tools, add, &N    Remove leading whiteSpaces, leading
Menu, tools, add, &O    Remove trailing whiteSpaces, trailing
Menu, tools, add, &P    Remove double blank Lines, doublelines
Menu, tools, add, -System-, disabled
Menu, tools, add, &Q    Force Close current window., force
Menu, tools, add, &R    Get window under Mouse., window
Menu, tools, add, -Misc-, disabled
Menu, tools, add, &S    Google search, google
Menu, tools, add, &T    Google Image search, googleimage
Menu, tools, add, &U   Run AHK code, runcode

Menu, plugins, add, -plugins-, disabled
Loop, %A_ScriptDir%\Plugins\*.ahk
		Menu, plugins, add, %A_LoopFileName%, plugins

Menu, plugins, Disable,     -plugins-
Menu, Tools, Disable,     -Tools-
Menu, Tools, Disable,     -Case-
Menu, Tools, Disable,     -Organization-
Menu, Tools, Disable,     -System-
Menu, Tools, Disable,     -Misc-
;~ Menu, options, UnCheck, Mode: Add to clipboard.
;~ Menu, options, UnCheck, Notify clipboard changes.
;~ Menu, options, Check, save clipboard text to a file.
;~ Menu, options, UnCheck, Load on System startup?
;~ Menu, options, Check, Autosave settings?

Menu, clipmenu, add, hide, hide
Menu, clipmenu, add, count, count
Menu, clipmenu, add,
Menu, clipmenu, add, Options:, :options
Menu, clipmenu, add, &Tools:, :tools
clipMenu() 
Menu, clipmenu, add, &History:, :History
Menu, clipmenu, add, &Plugins:, :plugins
Return

RAlt::
clipMenu() 
	winget, pid, PID, A
		Menu, clipmenu, Show
return

disabled:
hide:
Return

count:
	len:=StrLen(Clipboard)
	Spaces=
	newline=
	chars=
	Tabs=
	Loop, Parse, Clipboard, `n
			newline++
	Loop, Parse, Clipboard
		{
			If A_loopField=%A_Space%
					Spaces++
			If A_loopField=%A_Tab%
					tabs++
		}

	If tabs=
			tabs:=0
	If Spaces=
			Spaces:=0

	chars:= len-Spaces-tabs

	msgbox,4160, Mango,
		(
Length: %len%
Spaces: %spaces%
Tabs: %Tabs%
Characters: %chars%
Lines: %newline%
		)
Return

;OPTIONS
;OPTIONS
;OPTIONS
addmode:
	Menu, options, ToggleCheck, Mode: Add to clipboard.
Return
notifychange:
	Menu, options, ToggleCheck, Notify clipboard changes.
Return
savetofile:
	Menu, options, ToggleCheck, save clipboard text to a file.
Return
startup:
	Menu, options, ToggleCheck, Load on System startup?
Return
savesettings:
	Menu, options, ToggleCheck, Autosave settings?
Return



; TOOLS
; TOOLS
; TOOLS
prev:
	prevtemp:=ClipPrev
	ClipPrev:=Clipboard
	Clipboard:=prevtemp
	prevtemp=
Return
save:
	FormatTime, logname,, dddd_MMMM_d_yyyy_h_mm_ss

	name=%A_scriptdir%\%logname%.txt
	Fileappend, %Clipboard%, %name%
	msg= Clipboard saved to: `n%name%
	Toast("savepopupClick", msg, "Clipboard Saved, Click to open.", 0, "Center", "ff4400", 8)
Return
view:
	FileAppend,, %A_Temp%\mago_temp.clp
	run, %A_Temp%\mago_temp.clp
Return


ucase:
	StringUpper, Clipboard, Clipboard
Return
lcase:
	StringLower, Clipboard, Clipboard
Return
scase:
	Clipboard := RegExReplace(Clipboard, "([.?\s!]\s\w)|^(\.\s\b\w)|^(.)", "$U0")
Return
tcase:
	StringUpper, Clipboard, Clipboard, T
Return
icase:
	; Thanks JDN
	Lab_Invert_Char_Out:= ""
	Loop % Strlen(Clipboard) { ;%
			Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
			If Lab_Invert_Char is Upper
					Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) + 32)
			Else If Lab_Invert_Char is Lower
					Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) - 32)
			Else
					Lab_Invert_Char_Out:= Lab_Invert_Char_Out Lab_Invert_Char
		}
	Clipboard:=Lab_Invert_Char_Out
Return


sortaz:
	sort, Clipboard,
Return
sortza:
	sort, Clipboard,  R
Return
sortrand:
	sort, Clipboard,  Random
Return
StoT:
	StringReplace, Clipboard, Clipboard, %A_Space%, %A_Tab%, All
Return
TtoS:
	StringReplace, Clipboard, Clipboard, %A_Tab%, %A_Space%, All
Return
leading:
	Clipboard := RegExReplace(Clipboard, "m)(^[ \t]+)", "")
Return
trailing:
	Clipboard := RegExReplace(Clipboard, "m)([ \t]+$)","")
Return
doublelines:
	StringReplace, Clipboard, Clipboard, `r`n`r`n, `r`n, All
Return

force:
	winkill, ahk_pid %pid%
Return
window:
	WinGetTitle, Clipboard , ahk_pid %pid%
Return

google:
	Run, http://www.google.com/search?source=ig&hl=en&rlz=&q=%Clipboard%&btnG=Google+Search&aq=f
Return
googleimage:
	Run, http://images.google.com/images?um=1&hl=en&newwindow=1&safe=off&client=opera&rls=en&q=%Clipboard%&btnG=Search+Images
Return
runcode:
	FileDelete %A_ScriptDir%\temp.ahk
	FileAppend , #SingleInstance force`n`n%Clipboard%`n`n`n`n ~esc::ExitApp, %A_ScriptDir%\temp.ahk
	Run   %A_ScriptDir%\temp.ahk
	Sleep 5000
Return

; PLUGINS
; PLUGINS
; PLUGINS
plugins:
	Run, %A_Scriptdir%\Plugins\%A_Thismenuitem%
Return

OnClipboardChange:
   if(A_EventInfo=1) 
      { 
         currentClip=%clipboard% 
         currentClip_b=%clipboardall% 
         IfEqual,currentClip, %previousClip% 
            return 
         else 
            previousClip=%clipboard% 
      } 
   saveClip() 


	j+=1

	If j=1
		{
			ClipPrev:=Clipboard
			Clipboard:=ClipboardAll
		}

	If j>2
			j=1

   Return

savepopupclick:
	run, %name%
Return

restart:
	reload
return
exitscript:
	ExitApp
Return



;-----------------------
;----------TOASTER POPUP
;-----------------------
Toast(goto="", text="", title="", pos=1, align="Left", color="Default", size=11, font="Arial", life=5000, time=10)
	{
		;popup UI
		Gui, 99: Destroy
		Gui, 99: +Owner -SysMenu
		Gui, 99: font, s%size% w600 c%Color%, %font%
		Gui, 99: Add, text, x2  +%align% w222 g%Goto% , %text%
		Gui, 99: Show,x%A_ScreenWidth% y%A_ScreenHeight%, %title%
		Gosub, popup
		Return

popup:
	WinGetPos, , , Width, Height, %title%
	hy:=A_ScreenHeight-22


	If (pos=0)
			wx=0
	If (pos=1)
			wx=% A_ScreenWidth-Width

	SetTimer, life, %life%

	Loop, %time%
		{
			hy-=Height/time
			WinMove, %title%,, %wx%, %hy%
		}
Return

life:
	Gui, 99: Destroy
Return
}






















;                                                                                                                     ;                  
;           author:Salvatore Agostino Romeo - romeo84@gmail.com                      
;                                                                                                                    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
/*                                                                                                                      
          kiu-clipSave - It keeps trace of last 20(or customize it) 
          text (or files) items copied on clipboard and                      
          shows them in a menu to quickly paste, edit                
          or save something later. Now you can choose 
          if to work in paste only mode, or paste/edit/save mode. 
          CTRL+WIN+C lets you switch between modes 
          
               New in version 0.8: 
               In Paste only mode: 
               -if you hold down CTRL while clicking on an item, you will edit that item 
               -if you hold down SHIFT key while clicking on an item you'll be able to save it. 
               -if you hold down LWIN key while clicking on an item you'll be able to preview it 
                on a tooltip(press LButton to unshow the tooltip) 
                                                                   
          Version: 0.8                                                                              
          License:GPL                                                                                  
          Note: sub-project of kiu-radialM                                                
*/                                                                                                                      
^#c:: 
   if(toggleMode()) 
      pom=enabled 
   else 
      pom=disabled 
return 

pom: 
   pom=enabled 
return 

pesm: 
   pom=disabled 
return 

clipMenu() 
   { 
      global 
      startIndex:=clipIndex 
      Menu,History,add 
      Menu,History,DeleteAll 
      Loop,%numberOfElements% 
         { 
            zero= 
            puntini= 
            if(StrLen(startIndex)=1) 
               zero=0 
            FileReadLine, filec, data\%zero%%startIndex%.txt, 1 
            FileReadLine, filec, data\%zero%%startIndex%.txt, 1 
            if(StrLen(filec)>35) 
               { 
                        toCut:=StrLen(filec)-18 
                        StringMid, itemTemp1, filec, 1, 12 
                  StringTrimLeft, itemTemp2, filec, %toCut% 
                  itemTemp=%itemTemp1%...%itemTemp2% 
                     } 
            else 
               itemTemp=%filec% 
            if(A_Index<10)    
               Menu,History,add,%A_Space%%A_Space%%A_Index%. %itemTemp%,clipSelect 
            else 
               Menu,History,add,%A_Index%. %itemTemp%,clipSelect 
            startIndex-- 
            if(startIndex=0) 
               startIndex:=numberOfElements 
         } 
      Menu,History,add 
      Menu,HistorySaved,add 
         Menu,HistorySaved,deleteAll 
         Loop,data\saved\*.txt                
               { 
                  if(StrLen(A_Index)=1) 
               zero=0 
                  Menu,HistorySaved,add,%zero%%A_Index%. %A_LoopFileName%,clipSaved 
               } 

         Menu,History,add,Saved Clips, :HistorySaved 
      return 
   } 
saveClip() 
   { 
      global 
         currentIndex() 
      FileDelete, data\%clipIndex%.txt 
      FileAppend, %currentClip%, data\%clipIndex%.txt 
      FileDelete, data\%clipIndex%_b.txt 
      FileAppend, %currentClip_b%, data\%clipIndex%_b.txt 
      return 
   } 
;index of the clip.This is done to implement a sort of queue structure 
currentIndex() 
   { 
      global 
      clipIndex++ 
      If(clipIndex=21) 
         clipIndex=1 
      if(StrLen(clipIndex)=1) 
         clipIndex=0%clipIndex% 
      return 
   } 

Cancel: 
return    

clipSaved: 
   StringTrimLeft, OutputVar, A_ThisMenuItem, 4 
   Run,data\saved\%OutputVar% 
return 
clipSelect: 
   if(pom="enabled") 
      { 
         clipSelectedItemPos:= A_ThisMenuItemPos 
         goto,clipPaste 
      } 
   else 
      { 
         MouseGetPos, x, y 
         clipSelectedItemPos:= A_ThisMenuItemPos 
         inX:=x-25 
         inY:=y-10 
         Menu,History2,show, %inX%, %inY% 
      } 
return 
;when pressing an item of a menu 
clipPaste: 
   fileNum := clipIndex - clipSelectedItemPos + 1 
   if(fileNum < 0) 
      fileNum := numberOfElements + fileNum 
  if(StrLen(fileNum)=1) 
         fileNum=0%fileNum% 
   selection=%A_ThisMenuItemPos% 
   if(pom="enabled") 
   { 
         if(GetKeyState("CTRL" , "P")) 
           { 
              Run,data\%fileNum%.txt 
              return 
           } 
         if(GetKeyState("Shift" , "P")) 
           { 
              InputBox, name, Name of the clip, Select the name for the clip 
              FileCopy,data\%fileNum%.txt,data\saved\%name%.txt 
              return 
           } 
         if(GetKeyState("LWIN" , "P")) 
           { 
              FileRead, content, data\%fileNum%.txt 
              tooltip, %content% 
              KeyWait, LButton, D 
              tooltip, 
              return 
           } 
    } 
    else 
      {    
         if(selection=2) 
            { 
               Run,data\%fileNum%.txt 
               return 
            } 
         if(selection=3) 
            { 
               InputBox, name, Name of the clip, Select the name for the clip 
               FileCopy,data\%fileNum%.txt,data\saved\%name%.txt 
               return 
            } 
      } 
  FileRead, clip, data\%fileNum%.txt 
  clipboard= 
  clipboard=%clip% 
  Send,^v 
  SetTitleMatchMode, 2 
  IfWinExist, xplore 
         IfWinActive, xplore 
            { 
               FileRead,clip_b, *c data\%fileNum%_b.txt 
               clipboard=%clip_b% 
               Send,^v 
            } 
   IfWinExist, ahk_class ExploreWClass 
         IfWinActive, ahk_class ExploreWClass 
            { 
               FileRead,clip_b, *c data\%fileNum%_b.txt 
               clipboard=%clip_b% 
               Send,^v 
            } 
return 

toggleMode() 
{ 
 static m 
 m := !m 
 Return, m 
} 


features: 
msgbox, 
( 
Clipboardmenu's features: 
The hotkey to show the menu is WIN+SPACE . 
To paste an item simple click that item in the menu. If you hold down CTRL while clicking 
on an item, you will edit that item. If you hold down SHIFT key while clicking on an item 
you'll be able to save it. 

ClipboardMenu support another working mode called Paste/Edit/Save mode. 
This will let you paste/edit/save your clips using mouse only. 
The hotkey to switch between modes is CTRL+WIN+C . 

To work with paste/edit/save mode(PES mode) select this mode 
from tray menu or use the hotkey. Then, when selecting an item 
from clipboard menu, another menu will let you past, edit or 
save that item. To quickly paste an item in PES mode, just 
double click that item. 

If you copy a file: in explorer you will paste the file, 
in an editor you will paste the file path 
) 
return 

exitapplication: 
exitapp 
return