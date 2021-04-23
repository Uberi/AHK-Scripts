; Main Hotkeys & Hotstrings script
; you can use RunOrActivate() and FreeGuiNumber(), see below
gosub AutoExecute
return

MainGui:
#H::Run %A_AhkPath% HotManager.ahk "%A_ScriptFullPath%", %A_scriptdir%,, hotkeysman    ;MAIN HOTKEYZ MENU
ReloadButton:
#F5::Reload    ;RELOAD HOTKEYZ


;*; ---- USER DEFINED HOTKEYS AND HOTSTRINGS BELOW ------------------------
;;----   Windows Hotkeys  -------------------------
#ESC::Shutdown,1  ;Switch off computer
^#ESC::Shutdown,5  ;Forced off
!#ESC::Run, Shutdown_timer.ahk  ;Shutdown timer
#F4::DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)  ;Monitor off
+#R::Shutdown,2  ;Restart computer
+^#R::Shutdown,6  ;Forced restart
^#H::DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)  ;Hibernate


^#F4::  ;Turn off monitor
KeyWait Control
KeyWait LWin
BlockInput On
SendMessage, 0x112, 0xF170, 2,, Program Manager
BlockInput Off
return


^#F5::PostMessage 0x0112, 0xF140, 0,, Program Manager ;Launch ScreenSaver
^#L::Shutdown,0  ;Logoff

; Adjust volume by scrolling the mouse wheel over the taskbar.
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}   ;Volume Up
WheelDown::Send {Volume_Down}   ;Volume Down
#If

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

;;----   Operations on window  -------------------------
^#Down::WinMinimizeAll  ;Min All Windows
^#Up::WinMinimizeAllUndo  ;Undo Minimize All

;;----   Control Panel Extensions  -------------------------
^#K::Run control main.cpl @1  ;Keyboard properties
^#D::Run control desk.cpl  ;Desk
^#M::Run control main.cpl  ;Mouse
^#N::Run control ncpa.cpl  ;Networknhood
^#P::Run control powercfg.cpl  ;Power config
^#A::Run control appwiz.cpl  ;Add/remove
^#I::Run control inetcpl.cpl  ;IE options
^#U::Run control nusrmgr.cpl  ;User accounts
^#F::Run control firewall.cpl  ;Windows Firewall
^#B::Run control bthprops.cpl,%A_WinDir%\system32,,   ;Bluetooth Control Panel

;;----   Office & Misc  -------------------------
!#I::RunOrActivate("Iexplore.exe")  ;Internet Browser
!#W::RunOrActivate("Winword.exe")  ;Microsoft Word
!#E::RunOrActivate("excel.exe")  ;Excel
!#P::RunOrActivate("powerpnt.exe")  ;Powerpoint
#C::RunOrActivate("Calc.exe")  ;Calculator

; -------   Run code from clipboard or console -------------------------------------
!#C::    ;Run AHK code from clipboard or console
runcodegui := FreeGuiNumber()
Gui, %runcodegui%:Add, Edit, x5 y2 w720 h340 vScript, %Clipboard%
Gui, %runcodegui%:Add, Button, x365 y344 w120 h30 gRunPipe, &Run Code
Gui, %runcodegui%:Add, Button, x485 y344 w120 h30 gRunClipboard, &Clipboard
Gui, %runcodegui%:Add, Button, x605 y344 w120 h30 gruncode_Cancel, E&xit

;Gui, Show, x274 y129 h377 w732, New GUI Window
Gui %runcodegui%:Show
Return

RunClipboard:
Script := Clipboard
gosub RunClipboardAsPipe
Return

RunPipe:
   Gui %runcodegui%:Submit
RunClipboardAsPipe:
Script = ï»¿%Script% ; AHK needs leading UTF-8 BOM "ï»¿", otherwise rewinds, breaking the pipe
   pipe_name := A_Now   ; unique to prevent collision
   pip2 := CreateNamedPipe(pipe_name, 2) ; AHK calls GetFileAttributes() = close pipe. Create 2nd pipe
   pipe := CreateNamedPipe(pipe_name, 2) ; 1st instance seems to reliably be "opened" first
   if (pipe=-1 or pip2=-1) {
       MsgBox CreateNamedPipe failed.
       ExitApp
   }

   Run %A_AhkPath% "\\.\pipe\%pipe_name%"

   DllCall("ConnectNamedPipe","uint",pip2,"uint",0) ; Wait for AHK to connect via GetFileAttributes()
   DllCall("CloseHandle","uint",pip2)               ; Not needed any more
   DllCall("ConnectNamedPipe","uint",pipe,"uint",0) ; Wait for AHK to connect to open the "file"

   If !DllCall("WriteFile","uint",pipe,"str",Script,"uint",StrLen(Script)+1,"uint*",0,"uint",0)
       MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

   DllCall("CloseHandle","uint",pipe)

runcode_Cancel:
   Gui %runcodegui%:Destroy
Return

CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
    Return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
} 
; -------   End of Run code from clipboard or console -------------------------------------





;*; ---- END OF USER DEFINED HOTKEYS AND HOTSTRINGS BELOW ------------------------

;*; ---- PLEASE DO NOT MODIFY BELOW IF YOU DONT KNOW WHAT YOU ARE DOING ----------
#SingleInstance force
#Persistent

AutoExecute:
Menu, Tray, NoStandard ; only use this menu 
Menu, Standard, Standard
Menu Tray, Add, &View\Edit HotkeysWin+H, MainGui
Menu Tray, Add, &Reload HotkeysWin+F5, ReloadButton
Menu Tray, Add, &Default Menu, :Standard
Menu Tray, Add
Menu Tray, Add, Hotkeyz He&lp, MyHelp
Menu Tray, Add, &About, MyAbout
Menu Tray, Add
Menu Tray, Add, E&xit, ButtonExit
Menu Tray, Default, &View\Edit HotkeysWin+H
Menu Tray, Tip, HotKeyz v 2`nHotkeys GUI and functionality script!`nDr. Shajul`, 2006-2010.
return

MyHelp:
MsgBox, 64,Hotkeyz v1.2, Hotkeyz Help`n¯¯¯¯¯¯¯¯¯¯¯`nAutoHotkey unleashes the full potential of your keyboard
, joystick, and mouse. For example, in addition to the typical Control, Alt
, and Shift modifiers, you can use the Windows key and the Capslock key as modifiers
. `nIn fact, you can make any key or mouse button act as a modifier.`n`n- Automate almost anything by sending keystrokes and mouse clicks. `n- You can write macros by hand or use the macro recorder.`n- Remap keys and buttons on your keyboard, joystick, and mouse.
return

MyAbout:
MsgBox,64,About Hotkeyz!,Hotkeyz v1.2`n`n`nHotkeys GUI and functionality scripts!              `n`n`nDr. Shajul, 2006-2010`ndr_shajul@rediffmail.com
return


ButtonExit:
if hotkeysman           ; If hotkeys manager exists
  winkill, ahk_pid %hotkeysman%
ExitApp

FreeGuiNumber() {
   Loop 99 {
      Gui %A_Index%:+LastFoundExist
      IfWinNotExist
         Return A_Index
   }
}

; RunOrActivate =============================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;       MS Outlook might have multiple windows open (main window and email
;       windows).  This parm allows activating a specific window.
;    
; ===========================================================================

RunOrActivate(Target, WinTitle = "", WorkingDir = "", Options = "", Params = "")
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target% "%Params%", %WorkingDir%, %Options%, PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <>
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      TrayTip, , Activating PID %PID% (%TargetNameOnly%)
      WinActivate, ahk_pid %PID%
   }
}	