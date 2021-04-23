CoordMode, Mouse, Screen
gui, font, s12, Arial bold
Gui, Color, bed3e8

Gui, Add, Button, x10 y10 w100 h30 , Programs
Gui, Add, Button, x10 y50 w100 h30 , Volume
Gui, Add, Button, x10 y90 w100 h30 , Utilities
Gui, Add, Button, x120 y10 w100 h30 , Clipboard
Gui, Add, Button, x120 y50 w100 h30 , Hide/Show
Gui, Add, Button, x120 y90 w100 h30 , Shutdown
gui, show, h130 w230
return

ButtonPrograms:
Menu, Launch, Add, Explorer
Menu, Launch, Add, Firefox
Menu, Launch, Add, CCleaner
Menu, Launch, Add, IE
Menu, Launch, Add, Taskmgr
Menu, Launch, Add 
Menu, Launch, Add, Desktop
Menu, Launch, Add, StartMenu
Menu, Launch, Add, Startup
menu, Launch, show
Menu, Launch, Deleteall
return

Explorer:
run, nircmd.exe exec show "explorer.exe" "c:\program files"
return

Firefox:
run, nircmd.exe exec show "c:\program files\mozilla firefox\firefox.exe"
return

CCleaner:
run, nircmd.exe exec show "c:\program files\ccleaner\ccleaner.exe"
return

IE:
run, nircmd.exe exec show "c:\program files\internet explorer\iexplore.exe"
return

Taskmgr:
run, nircmd.exe exec show "taskmgr.exe"
return

Desktop:
run, nircmd.exe shexec "open" "~$folder.desktop$"
return

StartMenu:
run, nircmd.exe shexec "open" "~$folder.programs$"
return

Startup:
run, nircmd.exe shexec "open" "~$folder.startup$"
return

;====================================================================

ButtonVolume:
Menu, Vol, Add, Up
Menu, Vol, Add, Down
Menu, Vol, Add, Mute
Menu, Vol, Add, UnMute
menu, Vol, show
Menu, Vol, Deleteall
return

Up:
run, nircmd.exe changesysvolume 30000
return

Down:
run, nircmd.exe changesysvolume -30000
return

Mute:
run, nircmd.exe mutesysvolume 1
return

UnMute:
run, nircmd.exe mutesysvolume 0
return

;====================================================================

ButtonUtilities:
Menu, util, Add, Screensaver
Menu, util, Add, OpenCDrom
Menu, util, Add, CloseCDrom
Menu, util, Add, Time/Date
menu, util, Add, ScreenshotDesktop
Menu, util, Add, ScreenshotWindow
Menu, util, show
Menu, util, Deleteall
return

screensaver:
run, nircmd.exe screensaver
return

OpenCDrom:
run, nircmd.exe cdrom open d:
return

CloseCDrom:
run, nircmd.exe cdrom close d:
return

Time/Date:
run, nircmd.exe infobox "~$currtime.HH:mm$ ~$currdate.MM/dd/yyyy$" "Time/Date"
return

ScreenshotDesktop:
run, nircmd.exe cmdwait 2000 savescreenshot "shot.png"
return

ScreenshotWindow:
run, nircmd.exe cmdwait 2000 savescreenshotwin "winshot.png"
return

;====================================================================

ButtonClipboard:
Menu, clip, Add, Speak
Menu, clip, Add, Clear
Menu, clip, Add, Save1
Menu, clip, Add, Save2
menu, clip, Add, Save3
Menu, clip, Add, Save4
Menu, clip, Add, Restore1
Menu, clip, Add, Restore2
Menu, clip, Add, Restore3
Menu, clip, Add, Restore4
Menu, clip, show
Menu, clip, Deleteall
return

speak:
run, nircmd.exe speak text ~$clipboard$
return

Clear:
run, nircmd.exe clipboard clear
return

Save1:
{
run, nircmd.exe filldelete "clip1.txt"
sleep 1000
run, nircmd.exe clipboard addfile "clip1.txt"
}
return

Save2:
{
run, nircmd.exe filldelete "clip2.txt"
sleep 1000
run, nircmd.exe clipboard addfile "clip2.txt"
}
return

Save3:
{
run, nircmd.exe filldelete "clip3.txt"
sleep 1000
run, nircmd.exe clipboard addfile "clip3.txt"
}
return

Save4:
{
run, nircmd.exe filldelete "clip4.txt"
sleep 1000
run, nircmd.exe clipboard addfile "clip4.txt"
}
return

Restore1:
{
run, nircmd.exe clipboard readfile "clip1.txt"
run, nircmd.exe exec show "notepad.exe" "clip1.txt"
}
return

Restore2:
{
run, nircmd.exe clipboard readfile "clip2.txt"
run, nircmd.exe exec show "notepad.exe" "clip2.txt"
}
return

Restore3:
{
run, nircmd.exe clipboard readfile "clip3.txt"
run, nircmd.exe exec show "notepad.exe" "clip3.txt"
}
return

Restore4:
{
run, nircmd.exe clipboard readfile "clip4.txt"
run, nircmd.exe exec show "notepad.exe" "clip4.txt"
}
return

;====================================================================

ButtonHide/Show:
Menu, hide, Add, HideFirefox
Menu, hide, Add, ShowFirefox
Menu, hide, Add, HideSL
Menu, hide, Add, ShowSL
menu, hide, Add, HideIcons
Menu, hide, Add, ShowIcons
Menu, hide, Add, MinimizeAll
Menu, hide, Add, RestoreAll
Menu, hide, show
Menu, hide, Deleteall
return

HideFirefox:
run, nircmd.exe win hide class "MozillaUIWindowClass"
return

ShowFirefox:
run, nircmd.exe win show class "MozillaUIWindowClass"
return

HideSL:
run, nircmd.exe win hide class "Second Life"
return

ShowSL: 
run, nircmd.exe win show class "Second Life"
return

HideIcons:
run, nircmd.exe win hide class progman 
return

ShowIcons:
run, nircmd.exe win show class progman
return

MinimizeAll:
run, nircmd.exe win min alltopnodesktop
return

RestoreAll:
run, nircmd.exe win normal alltopnodesktop
return

;====================================================================

ButtonShutdown:
Menu, Shut, Add, Standby
Menu, Shut, Add, Logoff
Menu, Shut, Add, Reboot
Menu, Shut, Add, Shutdown
Menu, Shut, show
Menu, Shut, Deleteall
return

Standby:
run, nircmd.exe qboxcom "Do you want standby?" "question" standby
return

Logoff:
run, nircmd.exe qboxcom "Do you want to logoff?" "question" exitwin logoff
return

Reboot:
run, nircmd.exe qboxcom "Do you want to reboot?" "question" exitwin reboot
return

Shutdown:
run, nircmd.exe qboxcom "Do you want to shutdown?" "question" exitwin poweroff
return

;====================================================================


mbutton::
MouseGetPos, x, y
mgx:=x-115
mgy:=y-85
Gui Show, x%mgx% y%mgy%
gui, show
return
 
mbutton & rbutton::
{
run, nircmd.exe win hide class "MozillaUIWindowClass"
run, nircmd.exe win hide class "Second Life"
} 
return

