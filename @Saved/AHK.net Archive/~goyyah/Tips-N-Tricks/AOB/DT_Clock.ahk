/*  * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    Disclaimer:

    I do not foresee any risk in running this demo but
    you may run this file "ONLY" at your own risk. 

    * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

File Name   : DT_Clock.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/AOB/DT_Clock.ahk
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/AOB/Snapshot1.gif
Posted in   : http://www.autohotkey.com/forum/viewtopic.php?p=54403#54403

Main Title  : GUI Trick - Always@Bottom
Sub Title   : Desktop Clock

Description :  A Demonstration of setting a GUI "Always At Bottom".

               I might be technically incorrect - but in layman terms,          
               "Always On Top" window will never be below any other window - and
               "Always At Bottom" window will never be above any other window 
               because its a "Child window" of the Desktop.

               The "sticking of the GUI" is achieved by a DllCall to User32.dll function "SetParent"
               which sets the GUI to be the child window of Desktop.

               This script also demonstrates displaying of "Dynamic Text with a Shadow"
              
Author      : A.N.Suresh Kumar aka "Goyyah"
Email       : arian.suresh@gmail.com

Created     : 2006-03-27
Modified    : 2006-03-28

Scripted in : AutoHotkey Version 1.0.42.06 , www.autohotkey.com 

*/

#Persistent
WinMinimizeAll

xPos := A_ScreenWidth-200
yPos := 50
cTime := A_Now

Gui, +ToolWindow 
Gui, Color, 626500
Gui,Font, S20, Verdana

Gui,Add,Text, x3 y13 w150 h50 c000000 BackgroundTrans Center vTime2
Gui,Add,Text, x0 y10 w150 h50 cdaff00 BackgroundTrans Center vTime 
Gui, Show, x%xPos% y%yPos% w150 h60, Desktop Clock

WinSet := AlwaysAtBottom(WinExist("A")) ; sets the current GUI to be 
                                        ; the child Window of Desktop
SetTimer, UpdateClock, 10
Return


UpdateClock:

  If cTime = %A_Now%
     exit
  else
     cTime := A_Now

  SetTimer, UpdateClock, OFF
  FormatTime, Time, , HH:mm:ss

  GuiControl, , Time2, %Time%
  GuiControl, , Time , %Time%

  SetTimer, UpdateClock, 10
Return


AlwaysAtBottom(Child_ID)
 {
  WinGet, Desktop_ID, ID, ahk_class Progman
  Return DllCall("SetParent", "uint", Child_ID, "uint", Desktop_ID)
 }

GuiClose:
  ExitApp
Return