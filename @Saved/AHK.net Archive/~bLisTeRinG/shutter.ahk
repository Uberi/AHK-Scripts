;;;    Shutdown Button v0.4 for Win98se bLisTeRinG 2006

shIni=Shutter.ini
FileInstall, Shutter.ini, %A_ScriptDir%\%shIni%, 0
FileInstall, ReBoot.ico, %A_ScriptDir%\ReBoot.ico, 0
iniRead, shTst, %shIni%, options, test
#NoTrayIcon
opt = %1%
IfEqual,opt,?
  {
  Goto Help
  }
  Else
  {
  StringLen, pot, opt
  IfEqual,pot,0
    {
    opt = 9
    }
  }

WinampX:
iniRead, shChq, %shIni%, apps, winamp
  If shChq = 1
    {
    If shTst = 1
      {
      msgbox, Winamp
      }
      Else
      {
      DetectHiddenWindows, On
      DetectHiddenText, On
      WinKill, ahk_class Winamp v1.x
      }
    }

EzDesk:
iniRead, shChq, %shIni%, apps, EzDesk
  If shChq = 1
    {
    If shTst = 1
      {
      msgbox, EzDesk
      }
      Else
      {
      WinClose, EzDesk
      }
    }

Dialup:
iniRead, shChq, %shIni%, apps, Dialup
  If shChq = 1
    {
    If shTst = 1
      {
      msgbox, Dialup
      }
      Else
      {
      WinClose, Connect to
      ;;Process, Close, rnaapp.exe
      }
    }


Cleanup:
  If shTst = 1
    {
    msgbox, Cleanup
    }
    Else
    {
    FileRemoveDir, C:\Temp, 1
    FileCreateDir, C:\Temp
    FileRemoveDir, %A_WinDir%\Temp, 1
    FileCreateDir, %A_WinDir%\Temp
    FileDelete, %A_WinDir%\Recent\*.*
    Shutdown, %opt%
    }

Exit:
ExitApp

Help:
MsgBox, Syntax: Shutter.exe ?`n`n? is one of the following:`n`n0 Logoff`n1 Shutdown`n2 Reboot`n4 Force`n8 PwrOff`n9 Shut+PwrOff -default`n? This Help
Exit