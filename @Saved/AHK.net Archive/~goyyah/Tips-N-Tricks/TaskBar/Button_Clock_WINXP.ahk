/*  * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    Disclaimer:

    I do not foresee any risk in running this script but
    you may run this file "ONLY" at your own risk. 

    * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

File Name   : Button_Clock_WINXP.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/Button_Clock_WINXP.ahk
Icon        : http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/Clock.ico
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/Snapshot3.gif
Post        : http://www.autohotkey.com/forum/viewtopic.php?p=54863#54863

Main Title  : Taskbar Enhancement Utility
Sub Title   : Start Button Clock for Windows XP

Description :  A "Button Clock" in lieu of "Windows Start Button"

               This script hides the "Start Button" and adds a new Button and keeps updating the 
               "Button Caption" with a Time String - periodically - effectively making it a clock.
               
Note        :  This script will work fine with standard settings in Windows XP & may require
               modifications to suit a different theme.
          
Author      : A.N.Suresh Kumar aka "Goyyah"
Email       : arian.suresh@gmail.com

Created     : 2006-03-28
Modified    : 2006-03-30

Scripted in : AutoHotkey Version 1.0.42.06 , www.autohotkey.com 

*/

#Persistent
#SingleInstance, Ignore

IfNotExist, Clock.ico
  URLDownloadToFile
  , http://file.autohotkey.net/goyyah/Tips-N-Tricks/TaskBar/Clock.ico
  , Clock.ico

IfExist, Clock.ico
  Menu, Tray, Icon, Clock.ico
Menu, Tray, Tip, Start Button Clock for Windows XP

Control, Hide, , Button1, ahk_class Shell_TrayWnd
OnExit, Exitt  ; and restore the Start Button

cTime := A_Now
FormatTime,Time,,HH:mm:ss

Gui, +ToolWindow -Caption           
Gui, +Lastfound                     
GUI_ID := WinExist()                
WinGet, TaskBar_ID, ID, ahk_class Shell_TrayWnd
DllCall("SetParent", "uint", GUI_ID, "uint", Taskbar_ID)

Gui, Margin,0,0
Gui, Font, S14 Bold , Arial
Gui, Add,Button, w113 h30 gStartM vTime, % Time
Gui, Show,x0 y0 AutoSize, Start Button Clock - By Goyyah

SetTimer, UpdateButtonTime, 10

Return

; ----------------------------------------------------------------------------------------

UpdateButtonTime:

  If cTime = %A_Now%
     exit
  else
     cTime := A_Now

  SetTimer, UpdateButtonTime, OFF
  FormatTime,Time,,HH:mm:ss
  GuiControl,,Time , %Time%
  SetTimer, UpdateButtonTime, 10
Return


StartM:
  Send ^{ESCAPE}
return


Exitt:
  Gui,Destroy
  Control, Show, ,Button1, ahk_class Shell_TrayWnd
  ExitApp  
Return