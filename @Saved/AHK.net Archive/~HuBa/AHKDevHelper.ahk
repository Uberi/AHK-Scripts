; Autosearch in AutoHotkey Helpfile (from clipboard or editor)
;
; This script simplifies the searching of AHK commands in the documentation.
; It resolves some limitations of the Microsoft HTML Help Viewer by automating the searching process.
;
; This can work as a standalone script or can be "#Include"-d in other script's initialization section
;
; You can utilize the context-sensitive help support by replacing "ahk_class Notepad++" to your preferred texteditor
; There is already built-in support for Microsoft Notepad
;
; Tested with AutoHotkey 1.0.46.10
;
; Created by HuBa
; Contact: http://www.autohotkey.com/forum/profile.php?mode=viewprofile&u=4693
;
; The uptodate version can be found here: http://www.autohotkey.net/~HuBa/AHKDevHelper.ahk

; === INITIALIZATION SECTION ===
#SingleInstance force
#Persistent
#NoEnv

RegRead ah_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir  ; Read AutoHotkey installation directory from Registry
if ErrorLevel  ; Use a best guess location instead
  ah_dir := A_ProgramFiles "\AutoHotkey"
ah_help_file := ah_dir "\AutoHotkey.chm"
IfNotExist %ah_help_file%  ; Check helpfile existence
{
  MsgBox 16, Error, Could not find AutoHotkey helpfile:`n`n%ah_help_file%`n`nThe script will now exit.
  ExitApp
}

ah_SearchClipboardInHelpfileHotKey = #H  ; Win+H (it will be a system-wide hotkey)
if ah_SearchClipboardInHelpfileHotKey =
  MsgBox 16, Error, ah_SearchClipboardInHelpfileHotKey not assigned.
else
  Hotkey %ah_SearchClipboardInHelpfileHotKey%, SearchClipboardInHelpfile  ; Register hotkey

Return
; === END OF INITIALIZATION SECTION ===

OpenHelpFile()
{
  global ah_help_file
  Run %ah_help_file%, , Max UseErrorLevel  ; Run helpfile maximized
  ah_OpenErrorResult := ErrorLevel  ; Save the ErrorLevel to a temporary variable
  if ah_OpenErrorResult
    MsgBox 16, Error, Cannot open AutoHotkey helpfile.  ; In case of error
  else
  {
    WinWait ahk_class HH Parent, , 3
    if ErrorLevel
      Return "ERROR"
  }
  Return ah_OpenErrorResult
}

ReopenHelpFileProper()  ; If HTMLHelpViewer doesn't start with the 3. tab,
{                       ; it rearranges the control names (Edits and Buttons)
  IfWinExist ahk_class HH Parent
  {
    SendMessage 0x130C, 2,, SysTabControl321  ; 0x130C is TCM_SETCURSEL. Select the 3. tabpage
    WinClose ahk_class HH Parent  ; Close helpfile
    Sleep 50  ; Wait for closing
  }
  Return OpenHelpFile()  ; Open the helpfile again, it will now start with the 3. tab
}

SearchFieldVisible()
{
  ControlGet ah_SearchVisible, Visible, , Edit1, ahk_class HH Parent  ; Check Edit1 control visibility
  Return ah_SearchVisible
}

SearchClipboardInHelpfile:  ; Assigned to a global hotkey (see above)
IfWinNotExist ahk_class HH Parent
  if OpenHelpFile() = "ERROR"
    Return  ; There was an error
WinActivate ahk_class HH Parent  ; Activate window before accessing the controls
ControlGet ah_SidebarVisible, Visible, , HH Child2  ; Check sidebar visibility
if not ah_SidebarVisible
{
  MsgBox 64, Information, Turn on the sidebar to enable searching.
  Return  ; We cannot go further
}
SendMessage 0x130C, 2,, SysTabControl321  ; 0x130C is TCM_SETCURSEL. Select the 3. tabpage
ProperClick("SysTabControl321")
if not SearchFieldVisible()  ; Seems like there is a problem
  if ReopenHelpFileProper() = "ERROR"  ; Try to reopen helpfile
    Return  ; Error occured
  else
    WinActivate ahk_class HH Parent  ; Helpfile successfully reopened
if not SearchFieldVisible()
{  ; The script should never go here, however it could happen in a future version of HTML Help Viewer
  MsgBox 16, Error, Invalid search field.
  Return
}
Loop Parse, Clipboard, `n, `r  ; Remove linebreaks
  if StrLen(A_LoopField) > 0 then
    ah_SearchText := A_LoopField
ControlSetText Edit1, %ah_SearchText%, ahk_class HH Parent  ; Set the search field text
ControlFocus Edit1
GoSub $Enter  ; Jump to the script of the Enter key below
Return

CopyCurrentWordAndSearchHelp:  ; CoordMode for Mouse and Caret has to be the same
ah_ClipSaved := ClipboardAll   ; Save the entire clipboard
Clipboard =  ; Clear clipboard
ControlGetFocus ah_Editor, A  ; Retrieve the name of the focused editor control
ControlGet ah_SelectedText, Selected, , %ah_Editor%, A  ; Read selected text if it supports this function
if ah_SelectedText =
{  ; There is no selection, try to find the word under the caret
  MouseGetPos ah_MouseX, ah_MouseY  ; Save current mouse position
  MouseMove %A_CaretX%, %A_CaretY%, 0  ; Move mouse cursor to current caret
  Click 2  ; Perform doubleclick
  MouseMove ah_MouseX, ah_MouseY, 0  ; Restore previous mouse position
}
Send ^c  ; Copy selected text
ClipWait 0.5, 1  ; Wait for clipboard
if not ErrorLevel 
  GoSub SearchClipboardInHelpfile  ; We can now search using the clipboard
Clipboard := ah_ClipSaved  ; Restore the original clipboard
ah_ClipSaved =  ; Free the memory
Return


; === Application specific hotkeys ===

#IfWinActive ahk_class Notepad++  ; Notepad++ (opensource texteditor)
F4::GoSub CopyCurrentWordAndSearchHelp

#IfWinActive ahk_class Notepad  ; Microsoft Notepad
F1::
F4::GoSub CopyCurrentWordAndSearchHelp


#IfWinActive ahk_class HH Parent  ; Hotkeys for HTML Help window

$F1::
$F4::  ; F4 is not used inside HTML Help Viewer, we can assign a new function to this hotkey
if not SearchFieldVisible()
  Return
ControlGetFocus ah_FocusedControl, ahk_class HH Parent
if (ah_FocusedControl = "Edit1")
  GoSub $Enter  ; Jump to the script of the Enter key below
else
  ControlFocus Edit1  ; Set focus to the search field
Return

$Enter::
ControlGetFocus ah_FocusedControl, ahk_class HH Parent
SendMessage 0x130B,,, SysTabControl321  ; 0x130B = TCM_GETCURSEL. Which tabpage is selected? Answer is ErrorLevel
if (ErrorLevel = 2 and ah_FocusedControl = "Edit1")  ; Is search field focused?
{
  ProperClick("Button2")  ; Start searching
  Sleep 100  ; Waiting to finish searching
  Loop 3
    IfWinActive ahk_class #32770  ; Is it still searching?
      Sleep 100
  IfWinActive ahk_class #32770  ; Error dialog
    WinClose  ; Close dialog, it is an error
  else
    ProperClick("Button3")  ; Show first page in the list    
}
else
  Send {Enter}  ; Just send Enter if we are not searching
Return

#IfWinActive  ; End of application specific hotkeys

ProperClick(ControlName)
{
  BlockInput MouseMove  ; Disable mouse movement to prevent user interaction
  ControlClick %ControlName%, ahk_class HH Parent, , , , NA  ; Perform the click (NA is required!)
  BlockInput MouseMoveOff  ; Enable mouse movement
}
