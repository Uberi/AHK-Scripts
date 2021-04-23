/* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            
    This file is being given as an example for automating 
    a "Internet Explorer" related task through AutoHotkey 
    Script.

    Disclaimer: This is a BETA Version!  You may run this 
                file "ONLY" at your own risk. 

   * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

File Name   : IE_Auto_Refresher.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/IEAR/IE_Auto_Refresher.ahk
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/IEAR/StockTrade.gif 
Posted in   : http://www.autohotkey.com/forum/viewtopic.php?p=53704#53704

Main Title  : Internet Explorer Automation  
Sub Title   : IE Auto-Refresher Utility

Description : A Hotkey Utility to keep refreshing a target "IE Browser" periodically.

Readme      :  Run this script & bring target "IE Browser" window in focus. Press F2 and the window
               gets assigned to "IE Auto-Refresher". The "Assigned Window" will be periodically 
               auto refreshed by the script - until the script or the "Assigned Window" is closed.

               "IE Auto-Fresher" works in a different way. It does not refer the "Title" or "Text". 
               Rather, it is concerned about/refers to only the unique ID of "IE Browser" window. 

                        * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                          Do not attempt to fill a form on an "Assigned Window" as 
                          the page might reload when you are almost through!
                        * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

               F1: Toggles between "Minimizing" and "Restoring" the "IE Browser" window
               F2: Assign a window to "IE Auto Refresher" 
               F3: "Stop" and "Resume" Refreshing
               F4: Toggles "Always On Top" state of "Assigned Window"
         

               Pressing F2 on a different "IE Browser" will assign it to be the Auto-Refresh window.
               For user convenience, IE Title Bar is prefixed with [ ahk_id ].

               The script's status can be viewed by hovering mouse over the "Tray Icon".

               Note: I use this script in "Web-Based Stock Trading" to auto-refresh "Stock Quotes"

Author      : A.N.Suresh Kumar aka "Goyyah"
Email       : arian.suresh@gmail.com

Created     : 2006-03-21
Modified    : 2006-03-23

Scripted in : AutoHotkey 1.0.42.06 * Visit: www.autohotkey.com 

*/
TimerDuration=60000
Status=0

#SingleInstance, OFF
DetectHiddenWindows, OFF

OnExit, Exitt

IfExist, %windir%\System\shell32.dll
  Menu, Tray, Icon, shell32.dll,1

IfExist, %windir%\System32\shell32.dll
  Menu, Tray, Icon, shell32.dll,1

Menu,Tray,NoStandard
Menu,Tray,Add,&Minimize/Restore,MinMax
Menu,Tray,Add,
Menu,Tray,Add,&Restart Program, Reloadd
Menu,Tray,Add,E&xit IE Auto-Refresher,Exitt
Menu,Tray,Tip,[ IE Auto-Refresher - Idle ]
Menu,Tray,Default,&Minimize/Restore

F1::GoSub, MinMax
F2::GoSub, AssignWindow
F3::GoSub, StartStop
F4::WinSet, AlwaysOnTop ,, ahk_id %AHKID%

Return

AssignWindow:

  Old_AHKID := AHKID
  AHKID:=WinExist("A")

  If AHKID=%Old_AHKID%
    {
     ToolTip, `nThis is the Auto-Refresh Window!`n
     SetTimer, ToolTipTimer, 2000
     Return
    }

  WinGetClass,AHKCLASS, ahk_id %AHKID%
  
  If AHKClass != IEFrame
    {
      Msg1=Triggered by Hotkey : %A_ThisHotkey%
      Msg2=Not a IE Window! `n`n ahk_class %AHKCLASS% `n ahk_id %AHKID%
      MsgBox,16,IE Auto-Refresher,% Msg1 "`n" Msg2 ,10

      AHKID=%Old_AHKID%      
      Return
    }

  Else

    {
     PostMessage, 0x111, 41504, 0 , , ahk_id %Old_AHKID%
     WinSet, AlwaysOnTop ,OFF, ahk_id %Old_AHKID%
     SetTimer, Refresh,% TimerDuration
     Menu, Tray, Tip,[ IE Auto-Refresher - %AHKID% - Running ]
     Status=1
     GoSub, Refresh  
    }
return

Refresh:

  SetTimer, Refresh, OFF
  Menu, Tray, Tip,[ IE Auto-Refresher - %AHKID% - Reloading ]

  PostMessage, 0x111, 41504, 0 , , ahk_id %AHKID%
    If errorlevel <> 0
       GoSub, Reloadd

  Loop,
  {
   Sleep, 100
   StatusBarGetText, SBText , 1, ahk_id %AHKID%
   If SBText=Done 
      Break
   }

  WinGetTitle,WinTitle, ahk_id %AHKID%
  WinSetTitle,ahk_id %AHKID%,,[ %AHKID% ] - %WinTitle%

  SetTimer, Refresh,% TimerDuration
  Menu, Tray, Tip,[ IE Auto-Refresher - %AHKID% - Running ]
Return

StartStop:
 
  IfWinNotExist, ahk_id %AHKID%
    {
     MsgBox,16,IE Auto Refresher,Unable to Start/Stop`n`nYou are yet to Assign a Window!,5
     Exit
    }

  If Status=1
   {
     Status=0
     SetTimer, Refresh, OFF
     Menu, Tray, Tip,[ IE Auto-Refresher - %AHKID% - Paused ]
     ToolTip, `nIE Auto-Refresher Paused!`n
     SetTimer, ToolTipTimer, 2000
   }

  else

   {
     Status=1
     SetTimer, Refresh,% TimerDuration

     Menu, Tray, Tip,[ IE Auto-Refresher - %AHKID% - Running ]
     ToolTip, `nIE Auto-Refresher Running!`n
     SetTimer, ToolTipTimer, 2000
     GoSub, Refresh
   }
Return

MinMax:

  IfWinNotExist, ahk_id %AHKID%
    Exit

  WinGet,WStatus,MinMax,ahk_id %AHKID%

  If (WStatus=0 OR WStatus=1)
     WinMinimize, ahk_id %AHKID%
  else
     WinRestore, ahk_id %AHKID%
Return

TooltipTimer:

  SetTimer,TooltipTimer, OFF
  ToolTip,
Return

Reloadd:

  ToolTip, `nIE Auto-Refresher Reloading!`n
  Sleep, 500
  Reload
Return

Exitt:

  PostMessage, 0x111, 41504, 0 , , ahk_id %AHKID%
  WinSet, AlwaysOnTop ,OFF, ahk_id %AHKID%
  ExitApp
return