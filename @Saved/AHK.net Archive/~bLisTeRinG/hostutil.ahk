;;;	Hosts-file Utility v0.3 bLisTeRinG 2006

#Persistent
#SingleInstance
FileInstall, HostUtil.ini, %A_ScriptDir%\HostUtil.ini, 0
FileInstall, Hosts1.ico, %A_ScriptDir%\Hosts1.ico, 0
FileInstall, Hosts2.ico, %A_ScriptDir%\Hosts2.ico, 0

;;;      Locate an ini-file -check the Command-line.
in = %A_ScriptDir%\HostUtil.ini
If %0% <> 0
  {
  iPath = %1%
  }
Else
  {
  iniRead, iPath, %in%, options, iniPath
  }
If iPath = ERROR
 iPath = %in%
IfNotExist, %iPath%
  GoSub, hoIniSet

iniRead, ico1, %iPath%, options, OnIcon
iniRead, ico2, %iPath%, options, OffIcon
iniRead, iCol1, %iPath%, options, OnCol
iniRead, iCol2, %iPath%, options, OffCol
iniRead, sMenu, %iPath%, options, StartMenuPos

;;;   Locate the Hosts-file.
iniRead, ho, %iPath%, options, HostsFile
oh = %ho%.off
IfNotExist, %ho%
  IfNotExist, %oh%
    {
    ho = C:\Windows\Hosts
    oh = %ho%.off
    IfNotExist, %ho%
      IfNotExist, %oh%
        {
        ho = C:\Windows\System32\Etc\Hosts
        oh = %ho%.off
        IfNotExist, %ho%
          IfNotExist, %oh%
            GoSub, hoHoSet
        }
    }

;;;   Locate an Editor.
iniRead, ed, %iPath%, options, Editor
IfNotExist, %ed%
  {
  ed = %A_Windir%\NotePad.exe
  IfNotExist, %ed%
    GoSub, hoEdSet
  }

;;;   Check status of Hosts-file & Setup Tray-Menu.

Menu, tray, add, &Active, hoToggle
IfExist %ho%
  {
  tg = 1
  Menu, tray, Check, &Active
  IfExist, %ico1%
    Menu, Tray, Icon, %ico1%
  }
Else
  {
  tg = 0
  Menu, tray, UnCheck, &Active
  IfNotExist %oh%
    GoSub hoHoSet
  IfExist, %ico2%
    Menu, Tray, Icon, %ico2%
  }
Menu, tray, Default, &Active
Menu, tray, add, &Edit, hoEdit
Menu, tray, add, &Paste, hoPaste
Menu, tray, add  ;separator
Menu, tray, add, &Setup, hoSet
Menu, tray, add, &Help, hoHelp
Menu, tray, add, E&xit, hoExit
Menu, tray, NoStandard
Return

;;;   All the routines in alphabetical order.

hoChk:
IfExist %ho%
  {
  tg = 1
  Menu, tray, Check, &Active
  }
Else
  {
  tg = 0
  Menu, tray, UnCheck, &Active
  }
Return

hoEdit:
GoSub hoChk
If tg = 1
  {
  Run, %ed% %ho%
  }
Else
  {
  Run, %ed% %oh%
  }
Return

hoEdSet:
FileSelectFile, hoho, 8, *.exe;*.ahk, Choose Editor (%ed%)
If ErrorLevel = 1,
  {
  Return
  }
MsgBox, 4100, Choose Editor, `nOld Editor:`n%ed%`n`nNew Editor:`n%hoho%, 8
IfMsgBox, No
  {
  Return
  }
iniWrite, %hoho%, %iPath%, options, Editor
ed = %hoho%
hoho =
GuiControl,, Ednew, Editor-%ed%

Return

hoExit:
ed =
ho =
hoho =
in =
iPath =
oh =
tg =
ExitApp

hoHelp:
GoSub hoChk
If tg = 1
  {
  hoho = %ho%
  }
Else
  {
  hoho = %oh%
  }
MsgBox, `nActive:`tToggles the Filtering On/Off.`nEdit:`tEdit the Hosts-file.`nPaste:`tNew server address(es)`n`t...to Hosts-file to be filtered.`n`nHosts:`t%hoho%`n`nEditor:`t%ed%`n`nini-file:`t%iPath%`n`nHotkey:`tWin+Alt
Return

hoHoSet:
FileSelectFile, hoho, 8, C:\Windows\ hosts*, Choose Hosts File (%ho%)
If ErrorLevel = 1,
  {
  Return
  }
MsgBox, 4100, Choose Hosts File, `nOld Hosts File:`n%ho%`n`nNew Hosts File:`n%hoho%, 8
IfMsgBox, No
  {
  If ed = 
    Return
  hoho = 1
  Return
  }
iniWrite, %hoho%, %iPath%, options, HostsFile
ho = %hoho%
oh = %ho%.off
hoho =
Return

hoHotKey:
#ALT::
GoSub hoChk
;			; Colour(s) to find in Tray-icon.
If tg = 1
  {
  try = %iCol1%
  }
Else
  {
  try = %iCol2%
  }
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
;			; If StartMenu at top of screen.
MouseGetPos, hoX, hoY, hoID
If sMenu = top
  {
  xy = 1
  yy = 30
  MouseMove, 640, 1
  }
Else
  {
  xy = %A_ScreenHeight%
  yy = %A_ScreenHeight%
  EnvSub, xy, 30
  EnvSub, yy, 1
  MouseMove, 640, %yy%
  }
yx = %A_ScreenWidth%
EnvSub, yx, 4
xx = %yx%
EnvSub, xx, 100
MouseMove, %yx%, %xy%
PixelSearch, x, y, %xx%, %xy%, %yx%, %yy%, %try%, 2,RGB
If ErrorLevel <> 0,
  {
  Return
  }
MouseClick, R, %x%, %y%, , 0
MouseMove, %hoX%, %hoY%
WinActivate, %hoID%
hoX =
hoY =
hoID =
hoCtl =
x =
y =
xx =
yy =
xy =
yx =
try =
Return

hoIniSet:
FileSelectFile, hoho, 8, %A_ScriptDir%\ *.ini, Choose Initialization File (%iPath%)
If ErrorLevel = 1,
  {
  Return
  }
MsgBox, 4100, Choose Initialization File, `nOld iniFile:`n%iPath%`n`nNew iniFile:`n%hoho%, 
IfMsgBox, No
  {
  If ed = 
    Return
  hoho = 1
  Return
  }
iniWrite, %hoho%, %in%, options, iniPath
iniWrite, %hoho%, %hoho%, options, iniPath
If ed <> 0
  {
  Reload
  Sleep, 1000
  }
iPath = %hoho%
hoho =
Return

hoPaste:
GoSub hoChk
Inputbox, hoho, Clipboard, Entries should look something like this:`n   www.greedypigs.com,,280,140,,,,,%clipboard%
If ErrorLevel = 1
  {
  Return
  }
If tg = 1
  {
  FileAppend, `n0 %hoho%, %ho%
  }
Else
  {
  FileAppend, `n0 %hoho%, %oh%
  }
Return

hoSet:
GUI, Add, Button, GhoIniSet, Ini file-%iPath%
GUI, Add, Button, GhoHoSet, Hosts file-%ho%
GUI, Add, Button, vEdnew GhoEdSet, Editor-%ed%
Gui, Add, Button, Default, Ok
GUI, Show, 
Return

hoSetX:
GuiClose:
GuiEscape:
GuiOk:
Gui, submit
GUI, destroy
Return

hoToggle:
GoSub hoChk
If tg = 1
  {
  FileMove, %ho%, %oh%
  tg = 0
  Menu, tray, UnCheck, &Active
  IfExist, %ico2%
    Menu, Tray, Icon, %ico2%
  }
Else
  {
  FileMove, %oh%, %ho%
  tg = 1
  Menu, tray, Check, &Active
  IfExist, %ico1% 
    Menu, Tray, Icon, %ico1%
  }
Return

