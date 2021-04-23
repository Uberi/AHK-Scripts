;;;	Hider v0.1 bLisTeRinG 2006

DetectHiddenWindows, On
DetectHiddenText, On

top = %1%
StringLen, pot, top
IfEqual,pot,0
  {
  Goto Huh
  }
IfEqual,opt,?
  {
  Goto Huh
  }

IfWinNotExist, %top%
  {
  Goto Find
  }

opt = %2%
IfEqual,opt,1
  {
  WinShow, %top%
  }
  Else
  {
  StringLen, pot, opt
  IfEqual,pot,0
    {
    WinHide, %top%
    }
  }

Exit:
ExitApp

Find:
MsgBox, Can't find: %top%
Goto Exit

Huh:
MsgBox, Command-line options are needed! Use a shortcut. `n`nTarget:`t[path\]Hider.exe "string" [1] `n`nFor "string" use the text seen in the titlebar of the window to be hidden (no quotes). `n`nUse 1 (no brackets) to unhide the window.
Goto Exit
