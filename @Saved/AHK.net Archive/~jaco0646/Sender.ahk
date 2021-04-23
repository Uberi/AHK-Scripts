;Receiver <--
IfNotExist, Receiver.ahk
{
 code =
 (
  #SingleInstance ignore
  #NoEnv
  SetBatchLines, -1

  hWnd = `%1`%
  OnMessage(0x1001,"myFunction")

  Gui, Add, Edit, r20 w500 vEdit
  Gui, Show
  return
  GuiClose:
   WinClose, ahk_id `%hWnd`%
   ExitApp

  myFunction(wParam) {
   global Edit
   Gui, Submit, NoHide
   GuiControl,,Edit,`% Edit Chr(wParam)
  }
 )
 FileAppend, %code%, Receiver.ahk
}
;Sender -->
#SingleInstance force
#NoEnv

Gui, +LastFound
hWnd := WinExist()
Run, %A_AhkPath% Receiver.ahk "%hWnd%"
WinWait, Receiver.ahk,,5
If ErrorLevel
 ExitApp
WinGet, hWnd, ID

Gui, Add, Edit, vEdit
Gui, Add, Button, wp Default, Send Message
Gui, Show
return
GuiClose:
 WinClose, ahk_id %hWnd%
 ExitApp

ButtonSendMessage:
 Gui, Submit, NoHide
 Edit .= "`n"
 Loop,% StrLen(Edit)
  SendMessage, 0x1001, Asc(SubStr(Edit,A_Index,1)),,,ahk_id %hWnd%
 If ErrorLevel
  MsgBox,16, Error: %ErrorLevel%
 Else GuiControl,,Edit
return