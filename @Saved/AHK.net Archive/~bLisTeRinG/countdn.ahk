;;;   CountDn by Gavin & Alice Quinn   ;;;

FileInstall,CountDn.ini, %A_ScriptDir%\CountDn.ini, 0
FileInstall, CountDn1.ico, %A_ScriptDir%\CountDn1.ico, 0
FileInstall, CountDn2.ani, %A_ScriptDir%\CountDn2.ani, 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables
tkVer= CountDn v0.6 bLisTeRinG 2005

tkInit=%A_ScriptDir%\CountDn.ini
iniRead, db, %tkInit%, options, debug
iniRead, tkHide, %tkInit%, options, hide
iniRead, tkTTip, %tkInit%, options, tooltip

iniRead, tkTH, %tkInit%, count, hours
iniRead, tkTM, %tkInit%, count, minutes
iniRead, tkTS, %tkInit%, count, seconds

iniRead, tkCbt, %tkInit%, menu, colourtext
iniRead, tkCdo, %tkInit%, menu, colourset
iniRead, tkCgo, %tkInit%, menu, colourgo
iniRead, tkCbk, %tkInit%, menu, colourback
iniRead, tkPic1, %tkInit%, menu, picture1
iniRead, tkPic2, %tkInit%, menu, picture2
iniRead, tkAmen1, %tkInit%, menu, Menu1
iniRead, tkAmen2, %tkInit%, menu, Menu2
iniRead, tkAmen3, %tkInit%, menu, Menu3
iniRead, tkAmen4, %tkInit%, menu, Menu4
iniRead, tkAmen5, %tkInit%, menu, Menu5

iniRead, tkAdd, %tkInit%, action, actions
iniRead, tkAct3, %tkInit%, action, action3
iniRead, tkAct4, %tkInit%, action, action4
iniRead, tkAct5, %tkInit%, action, action5

iniRead, tkApp1, %tkInit%, application, application1
iniRead, tkApp2, %tkInit%, application, application2
iniRead, tkApp3, %tkInit%, application, application3
iniRead, tkApp4, %tkInit%, application, application4
iniRead, tkApp5, %tkInit%, application, application5

iniRead, tkApp4x, %tkInit%, application, Application4Extra

iniRead, tkAfi1, %tkInit%, application, ApplicationTypes1
iniRead, tkAfi2, %tkInit%, application, ApplicationTypes2
iniRead, tkAfi3, %tkInit%, application, ApplicationTypes3
iniRead, tkAfi4, %tkInit%, application, ApplicationTypes4
iniRead, tkAfi5, %tkInit%, application, ApplicationTypes5

;;; Commandline input...
;;; CountDn.exe <hours> [<mins> [<secs> [<mediafile>]]]
If 1 <> 
  {
  tkTH= %3%
  tkTM= %2%
  tkTS= %1%
  }
IfExist %4% 
  {
  tkAct3= %4%
  If 5 contains 1,2,3,4,
    {
    xx%5%=1
    tkAdd= %xx1%|%xx2%|%xx3%|%xx4%
    xx=%5%
    tkAct%5%= %4%
    }
  tkHide= 1
  }

tkTX= 0
tkTY= 0
tkTkH= %tkTH%
tkTkM= %tkTM%
tkTkS= %tkTS%
tkTkX= 0
tkTkY= 0
wdX= x100
wdY= y30
tkTTx=158
tkTTy=38
If db = 1
  {
  setKeyDelay, 75
  setMouseDelay, 75
  }
  Else
  {
  Gui, -Caption
  }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; setup gui
#SingleInstance Off
Gui, +ToolWindow
Gui, Color, %tkCdo%
Gui, add, Pic, gtkHelp vtkHelp x200 y6 w64 h-1, %tkPic1%
GoSub, tkStyle2
Gui, add, Tab, x5 y5 Buttons ,Hours|Minutes|Seconds||
 Gui, Tab, Hours
  GoSub, tkStyle1
  Gui, Add, Text, x12 y40 w180 h40 gWinDrag, Hours?
  Gui, Add, Slider, gtkUpdate vtkTH TickInterval3 ToolTipTop Page1 Range0-24 Left x10 y75 w260 h30, +%tkTH%
  GoSub, tkStyle2
 Gui, Tab, Minutes
  GoSub, tkStyle1
  Gui, Add, Text, x12 y40 w180 h40 gWinDrag, Minutes?
  Gui, Add, Slider, gtkUpdate vtkTM TickInterval5 ToolTipTop Page10 Range0-60 Left x10 y75 w260 h30, +%tkTM%
  GoSub, tkStyle2
 Gui, Tab, Seconds
  GoSub, tkStyle1
  Gui, Add, Text, x12 y40 w180 h40 gWinDrag, Seconds?
  Gui, Add, Slider, gtkUpdate vtkTS TickInterval10 ToolTipTop Page10 Range0-60 Left x10 y75 w257 h30, +%tkTkS%
  GoSub, tkStyle2
 Gui, Tab,
  Gui, Add, Button, x267 y5 w10 h10, &x ; gtkXtt
  Gui, Add, Button, x267 y20 w10 h10, &y
  Gui, Add, Button, x267 y35 w10 h10, &z
  Gui, Add, Progress, Range-1-100 vtkProg +E0x200 background%tkCdo% c%tkCbt% x10 y113 w257 h7, 
  Gui, Add, Button, x10 y130 w80 h20, &Cancel
  Gui, Add, Button, x100 y130 w80 h20, &Action
  Gui, Add, Button, x190 y130 w80 h20 default, &Go!
  If hide <> 1
    {
    Gui, Show, x%wdX% y%wdY% h160 w280, %tkVer%
    }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; setup menu
If db <> 1
  {
  Menu,Tray,NoStandard
  }
Loop,
  {
  Transform, x, deref, `%tkAmen%a_index%`%
  ; MsgBox, Menu %a_index% is %x%
  If x <>
    {
    Menu,Action,add,%x%,tkAA
    Menu,Reset,add,%x%,tkAny
    }
    Else
    {
    Break
    }
  }
Menu,Reset,add,&Reset All,tkAll
Menu,Action,add,&Reset,:Reset
Menu,Tray,add,&Action,:Action
Menu,Tray,add,&Hide,tkHide
Menu,Tray,add,&ToolTip,tkTip
Menu,Tray,add,&Debug,tkDB
Menu,Tray,add
Menu,Tray,add,E&xit,GuiExit
Menu,Tray,Color,%tkCbt%
Menu,Reset,Color,%tkCbt%
Menu,Tray,icon,%tkpic1%, 
GoSub tkUpdate
GoSub tkCompleted
GoSub tkTip%tkTTip%
GoSub tkHide%tkHide%
GoSub tkAct
IfExist %4%
  {
  Gosub ButtonGo!
  Sleep, 5000
  Goto ButtonCancel
  }
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; button routines
ButtonCancel:
Buttonx:
IfWinExist, CountDn Help
  {
  WinClose, CountDn Help
  Return
  }
If Loopy = 1
  {
  tkTkY= -1
  Return
  }
Goto GuiClose

ButtonAction:
;;; while counting, this is a ReSet button.
If Loopy = 1
  {
  ;;; delete uncounted (TkY) time from grand total (TkZ)
  ;;;to get counted time so far (ss)...
  ss= %tkTkZ%
  EnvSub, ss, %tkTkY%
  ;;; add new time (TkX) selected...
  EnvAdd, ss, %tkTkX%
  ;;; for new grand total.
  tkTkZ= %ss%
  ;;; use tooltip format routine for HrMnSc...
  tkTkY= %ss%
  GoSub tkToolTip
  ;;; fix counter...
  tkTkY= %tkTkX%
  ;;; format the countdown-complete tooltip.
  tkTH = %tkHr%
  tkTM = %tkMn%
  tkTS = %tkSc%
  GoSub tkCompleted
  ;;; fix counter total (tkTkX) & progress bar.
  tkTkX= %tkTkY%
  GoSub tkProgress
  Return
  }
Menu,Action,Show, 
Return

ButtonGo!:
Gui, Color, %tkCgo%
GuiControl, +backgroundred, tkTkS
GuiControl, +background%tkCgo%, tkProg
GuiControl, Text, &Cancel, &Stop!
GuiControl, Text, &Action, &ReStart
GuiControl,, tkHelp,%tkPic2%

;;; Format the tooltip. Set countdown & grand total.
GoSub tkCompleted
GoSub tkProgress
If tkTkX = 0
  {
  Goto tkAbort
  }
tkTkY= %tkTkX%
tkTkZ= %tkTkX%
Loopy= 1
Loop
  {
  If tkTkY = 0
    {
    Break
    }
  GoSub tkToolTip
  StringLen, x, tkMn
  StringLen, y, tkSc
  tkTkY--
  If tkTkY < 0
    {
    tkTkY= 0
    Tooltip,
    Goto tkAbort
    }
  IfEqual, y, 1
    {
    If tkMn <> 0
      {
      tkSc= 0%tkSc%
      }
      Else
      {
      If tkHr <> 0
        {
        tkSc= 0%tkSc%
        }
        Else
        {
        tkSc= %tkSc%
        }
      }
    }
    Else
    {
    tkSc= %tkSc%
    }
  If tkHr <> 0
    {
    tkTX= %tkHr%.
    IfEqual, x, 1
      {
      tkTX= %tkTX%0%tkMn%:%tkSc%
      }
      Else
      {
      tkTX= %tkTX%%tkMn%:%tkSc%
      }
    }
    Else
    {
    If tkMn <> 0
      {
      tkTX= %tkMn%:%tkSc%
      }
      Else
      {
      tkTX= %tkSc%
      }
    }
;;; Position and update the tooltip each second.
  xx=%tkTTx%
  yy=%tkTTy%
  If tkHide = 1
    {
    xx=
    yy=
    }
    Else
    {
    CoordMode, ToolTip, relative
    StringLen, zz, tkTX
    EnvMult, zz, 9
    EnvSub, xx, %zz%
    }
  If tkTTip = 1
    {
    Tooltip, %a_space%%tkTX%%a_space%,%xx%,%yy%
    }
  Menu,tray,tip, %a_space%%tkTX%%a_space%
  xx= 
  yy=
  zz=
  EnvSub, tkTZz, %tkTZ%
  GuiControl,, tkProg, %tkTZz%
  Sleep, 1000   ;   one second.
  }

;;; Show countdown-complete info and do alert.
;GuiControl, Text, Hours?, Hours~%tkTY%
;GuiControl, Text, Minutes?, Minutes~%tkTY%
;GuiControl, Text, Seconds?, Seconds~%tkTY%
ToolTip, `n%a_space%Time's Up! (%tkTY%)%a_space%`n
SetTimer, tkTipX, 7000

;;; Now do any Actions.
GoSub tkAction

tkAbort:
tkTZz= 
Loopy= 
Gui, Color, %tkCdo%
GuiControl, +backgroundred, tkTkS
GuiControl, +background%tkCdo%, tkProg
GuiControl, Text, &Stop, &Cancel
GuiControl, Text, &ReStart, &Action
GuiControl,, tkHelp,%tkPic1%
Return

Buttony:
Reload
Return

GuiClose:
GuiEscape:
GuiExit:
Gui, submit
DetectHiddenWindows, On
SetTitleMatchMode, 2
WinClose, Sound
ToolTip,
ExitApp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; action subroutines
tkAll:
StringSplit, xx, tkAdd,|
Loop,
  {
  x=%a_index%
  GoSub tkAny
  Transform, tkAxx, deref, `%xx%x%`%
  If tkAxx = 0
    {
    }
    Else
    {
    Break
    }
  }
Return

tkAny:
If %a_index% = 0
  {
  x= %a_ThisMenuItemPos%
  }
  Transform, tkAxx, deref, `%xx%x%`%
  If tkAxx = 1
    {
    Transform, tkAmen, deref, `%tkAmen%x%`%
    Transform, tkAct, deref, `%tkAct%x%`%
    tkAct%x%=
    GoSub tkActOff
    }
tkAdd= %xx1%|%xx2%|%xx3%|%xx4%|%xx5%|%xx6%|%xx7%|%xx8%|%xx9%
Return

tkAct:
StringSplit, xx, tkAdd,|
Loop,
  {
  x=%a_index%
  Transform, tkAxx, deref, `%xx%x%`%
  If tkAxx <>
    {
    Transform, tkAmen, deref, `%tkAmen%x%`%
    If tkAxx = 1
      {
    Transform, tkAppx, deref, `%tkApp%x%x`%
      GoSub tkActOn
      }
      Else
      {
      GoSub tkActOff
      }
    }
    Else
    {
    Break
    }
  }
Return

tkAA:
;;; Filename in 			"tkAct"
;;; from 				"tkAct(n)"
;;; FileSelectFile dialog filter in	"tkAfi"
;;; All toggle states in 		"tkAdd"
;;;  via 				"xx(n)"
;;; Extra app to run in 		"tkApp(n)x"
;;; This toggle state in 		"tkAxx"
;;; Menu-name in 			"tkAmen(n)"

x=%A_ThisMenuItemPos%
StringSplit, xx, tkAdd,|
Transform, tkAct, deref, `%tkAct%x%`%
Transform, tkAfi, deref, `%tkAfi%x%`%
  Transform, tkApp, deref, `%tkApp%x%`%
Transform, tkAppx, deref, `%tkApp%x%x`%
Transform, tkAxx, deref, `%xx%x%`%
Transform, tkAmen, deref, `%tkAmen%x%`%
IfExist %tkAct%
  {
  If tkAxx = 1
    {
    GoSub tkActOff
    }
    Else
    {
    GoSub tkActOn
    }
  }
  Else
  {
  FileSelectFile, tkAct%x%, 1,, Select %tkAmen% File, %tkAfi%
  If ErrorLevel <> 0
    {
    GoSub tkActOff
    Return
    }
  GoSub tkActOn
;;;;;;;;;;;; Use temp var(tkAct111) for 1 loop to get Short path/name;
  Transform, tkAct111, deref, `%tkAct%x%`%
  Loop, %tkAct111%
    {
    tkAct%x% = %A_LoopFileShortPath%
    tkAct1111 = 
    }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;%A_LoopFileShortName%
;%A_LoopFileShortName%

  }
tkAdd= %xx1%|%xx2%|%xx3%|%xx4%|%xx5%|%xx6%|%xx7%|%xx8%|%xx9%
If db = 1
  {
  MsgBox, tkAdd=%tkAdd% `nxx=%xx% xx1=%xx1% xx2=%xx2% xx3=%xx3% xx4=%xx4% xx5=%xx5% `ntkAmen=%tkAmen% - xx%x% was %tkAxx% (tkAxx) `n`nAct=%tkAct%`nAct1=%tkAct1% `nAct2=%tkAct2% `nAct3=%tkAct3% `nAct4=%tkAct4% `nAct5=%tkAct5% `n`nApp=%tkApp% `nApp1=%tkApp1% `nApp2=%tkApp2% `nApp3=%tkApp3% `nApp4=%tkApp4% `nApp5=%tkApp5%
  }
Return

tkActOff:
Menu, Action, Uncheck, %tkAmen%
xx%x%=0
Return

tkActOn:
Menu, Action, Check, %tkAmen%
xx%x%=1
IfExist %tkAppx%
  {
  GoSub tkAct%x%Xtra
  }
Return

tkAct4Xtra:
tkAct1Xtra:
DetectHiddenWindows, On
IfWinExist, ahk_class AfxFrameOrView42
  {
  Return
  }
  Else
  {
  IfExist %tkApp4x%
    {
    Clipboard=
    Run, %tkApp4x%
    WinWaitActive, ahk_class #32770
    ControlSend,, {ENTER}, ahk_class #32770
    }
  }
Return

tkActionB:
  If xx1 = 1
    {
    IfExist, %tkAct1%
      {
      Run, %tkApp1% %tkAct1%
      }
    }
If xx2 = 1
  {
  tooltip, tkApp2: %tkApp2% tkAct2: %tkAct2% yy%yy%
  IfExist, %tkAct2%
    {
    tooltip, tkApp2: %tkApp2% tkAct2: %tkAct2% yy%yy%
    Run, %tkApp2% %tkAct2%,,UseErrorLevel,yy
    If errorlevel = 0
      {
      WinWaitActive, %yy%
      }
      Else
      {
      MsgBox,, CountDn Help,Run %tkApp2% %tkAct2% err:%yy%,7
      }
    }
  }
If xx3 = 1
  {
  IfExist, %tkAct3%
    {
    Run, %tkApp3% %tkAct3%
    }
  }
If xx4 = 1
  {
  IfExist %tkApp4x%
    {
    GoSub tkAct4Xtra
    }
  IfExist, %tkAct4%
    {
    Run, %tkApp4% %tkAct4%
    }
  }
xx=
yy=
Return

tkAction:
StringSplit, xx, tkAdd,|
Loop,
  {
  Transform, tkAxx, deref, `%xx%a_index%`%
  Transform, tkApp, deref, `%tkApp%a_index%`%
  Transform, tkAppx, deref, `%tkApp%a_index%x`%
  Transform, tkAct, deref, `%tkAct%a_index%`%
  If tkAxx = 
    {
    Break
    }
  If db = 1
    {
    MsgBox,, CountDn Help, Loop#: %a_index% `n`nApplication: `n%tkApp% `n`nExtra: `n%tkAppx% `n`n`nFile: `n%tkAct% 
    }
    Else
    {
    If tkAxx =1
      {
      IfExist %tkAppx%
        {
        GoSub tkAct%x%Xtra
        }
      IfExist, %tkAct%
        {
        Run, %tkApp% %tkAct%
        } 
      }		; end tkAxx One?
    }		; end debug msg/else
  }		; end loop
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; visual formatting
tkCompleted:
;;; pre/re-format countdown-complete.
StringLen, x, tkTH
IfEqual, x, 1
  {
  tkTY= 0%tkTH%.
  }
  Else
  {
  tkTY= %tkTH%.
  }
StringLen, x, tkTM
IfEqual, x, 1
  {
  tkTY= %tkTY%0%tkTM%:
  }
  Else
  {
  tkTY= %tkTY%%tkTM%:
  }
StringLen, x, tkTS
IfEqual, x, 1
  {
  tkTY= %tkTY%0%tkTS%
  }
  Else
  {
  tkTY= %tkTY%%tkTS%
  }
x=
Return

tkDB:
If db = 1
  {
  db = 0
  Menu, Tray, Uncheck, &Debug
  }
  Else
  {
  db = 1
  Menu, Tray, Check, &Debug
  }
Return

tkHelp:
If db = 1
  {
  MsgBox, 4096,CountDn Help,Hours`tMinutes`tSeconds`tTotal `nTkH:%tkTkH%`tTkM:%tkTkM%`tTkS:%tkTkS% `tTkX:%tkTkX%`nTH:  %tkTH%`tTM:  %tkTM%`tTS:  %tkTS% `tTkY:%tkTkY%`nHr:  %tkHr%`tMn:  %tkMn%`tSc:  %tkSc% `tTkZ:%tkTkZ%`n`nEndCountString`tCountString `nTY: %tkTY%   `tTX: %tkTX% `n`nProgress bar`tTZz:%tkTZz% `nShrink bar ea sec`tTZ:   %tkTZ%`n,
  Return
  }
ww= %tkTkX%
EnvSub, ww, %tkTkY%
xx= %tkTkH%
EnvSub, xx, %tkHr%
yy= %tkTkM%
EnvSub, yy, %tkMn%
zz= %tkTkS%
EnvSub, zz, %tkSc%
vv= %tkTkZ%
EnvSub, vv, %tkTkX%
EnvAdd, vv, %ww%
MsgBox, 4096,CountDn Help,%a_space%      %tkVer%`n%a_space%      _______________________`n`t>>> PAUSE <<<`n`n`tHours`tMinutes`tSeconds`nTotal`t%tkTkH%`t%tkTkM%`t%tkTkS%`nTo go`t%tkHr%`t%tkMn%`t%tkSc% `nOver`t%xx%`t%yy%`t%zz%`n`n`tSeconds(s):`nTotal`t%tkTkX%`tGrand`t%tkTkZ%`nTo go`t%tkTkY%`nOver`t%ww%`tAllOver`t%vv% `n%tkAct% `n`n%tkAct1% `n%tkAct2% `n%tkAct3% `n%tkAct4% `n%tkAct5%
vv=
ww=
xx=
yy=
zz=
Return

tkHide:
;;; hide the window to tray
Buttonz:
If tkHide = 0
  {
  Goto tkHide1
  }
  Else
  {
  Menu,Tray,rename,&Show,&Hide
  Goto tkHide0
  }

tkHide0:
Menu,Tray,default,&Hide
WinShow, CountDn v
WinActivate, CountDn v
tkHide= 0
Return

tkHide1:
tkHide= 1
Menu,Tray,rename,&Hide,&Show
Menu,Tray,default,&Show
WinHide, CountDn v
Return

tkProgress:
;;; pre/re-set progress-bar variables.
If tkTkX = 0
  {
  MsgBox,0, CountDn Help,No Hours Minutes or Seconds ,4
  Return
  }
tkTZz= %tkTkX%.
tkTZ= 100.
EnvDiv, tkTZ, %tkTkX%
tkTZz= 100.
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Styles
tkStyle1:
Gui, Font, s18 c%tkCbt% w800, Arial
Gui, Font, s22, MS serif
Gui, Font, s14, LithographLight
Return

tkStyle2:
Gui, Font, s10 w100 c%tkCbt%, Verdana
Gui, Font, s8 w100 c%tkCbt%, LithographLight
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; tooltip routines
tkToolTip:
;;; Tooltip format
tkHr=
tkMn= 
tkSc= 
tkSc= %tkTkY%
tkHr= %tkSc%
 EnvDiv, tkHr, 3600
 EnvMult, tkHr, 3600
  EnvSub, tkSc, %tkHr%
  EnvDiv, tkHr, 3600
tkMn= %tkSc%
 EnvDiv, tkMn, 60
 EnvMult, tkMn, 60
  EnvSub, tkSc, %tkMn%
  EnvDiv, tkMn, 60
Return

tkTip:
;;; tooltip menu-toggle
If tkTTip = 1
  {
  Goto tkTip0
  }
  Else
  {
  Goto tkTip1
  }

tkTip0:
tkTTip= 0
Menu, Tray, Uncheck, &ToolTip

tkTipX:
SetTimer, tkTipX, Off
ToolTip,
Return

tkTip1:
tkTTip= 1
Menu, Tray, Check, &ToolTip
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; update variables
tkUpdate:
;;; sort out the hours, minutes and seconds (maths).
tkTkX= 0
If tkTH <> 0
  {
  tkTkH= %tkTH%
  EnvMult, tkTkH, 3600
  EnvAdd, tkTkX, %tkTkH%
  EnvDiv, tkTkH, 3600
  }
If tkTM <> 0
  {
  tkTkM= %tkTM%
  EnvMult, tkTkM, 60
  EnvAdd, tkTkX, %tkTkM%
  EnvDiv, tkTkM, 60
  }
tkTkS= %tkTS%
EnvAdd, tkTkX, %tkTkS%
Return

tkXtt:
tooltip, This is Exit!
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; drag the Window.
WinDrag:
DetectHiddenWindows, On
SetTitleMatchMode, 2
MouseGetPos, wdX, wdY, wdW
SetTimer, WinGo, 10
Return

WinGo:
CoordMode, Mouse, Screen
MouseGetPos, wdX, wdY
EnvSub, wdX, 105
EnvSub, wdY, 50
Sleep, 10
WinMove, ahk_id %wdW%,, %wdX%, %wdY%
GetKeyState, wdZ, LButton, P
If wdZ= U
  {
  SetTimer, WinGo, off
  wdW=
  wdX=
  wdY=
  wdZ=
 }
Return

