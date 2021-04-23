#SingleInstance force
#NoTrayIcon
#NoEnv
EnvGet, UserProfile, UserProfile
EnvGet, HomeDrive, HomeDrive
SetBatchLines, -1
;
If A_OSVersion != WIN_XP
{
 MsgBox, 16, IE Cache Delete, Sorry, this program is only designed to run on Windows XP.
 ExitApp
}
Progress, zh0 fs14 b2, Searching for "index.dat" files`,`nplease wait.
Loop, %HomeDrive%\index.dat,,1
{
 If A_LoopFileLongPath = %A_WinDir%\PCHEALTH\HELPCTR\OfflineCache\index.dat
  continue
 index .= A_LoopFileLongPath "|"
}
If index = 
{
 index = No index.dat files were found on drive %HomeDrive%\.
 off = disabled
}
Progress, Off
Fldrs = CIE|COO|HIE|TIF|TOS|TWU
Paths = %UserProfile%\Local Settings\Temporary Internet Files\Content.IE5
	|%UserProfile%\Cookies
	|%UserProfile%\Local Settings\History\History.IE5
	|%UserProfile%\Local Settings\Temporary Internet Files
	|%A_Temp%
	|%A_WinDir%\SoftwareDistribution\Download
Msges = Are you sure you want to delete temporary IE files?
	|Are you sure you want to delete your Internet cookies?`nSome website features may fail (e.g. automatic login).
	|Are you sure you want to delete your Internet history?
	|Are you sure you want to delete temporary IE files?
	|Are you sure you want to delete temporary Windows files?
	|Are you sure you want to delete Windows Update files?
Loop, Parse, Fldrs, |
{
 nam := A_LoopField
 num := A_Index
 Loop, Parse, Paths, |,%A_Space%
  If num = %A_Index%
  {
   Path_%nam% := A_LoopField
   Size_%nam% := GetSize(Path_%nam%)
   break
  }
 Loop, Parse, Msges, |,%A_Space%
  If num = %A_Index%
  {
   Msg_%nam% := A_LoopField
   break
  }
}
Gui, Add, Tab, %1% w600 h400, IE Folders|Index.dat
Gui, Add, Button, w100 vCIE gRun Section, Content.IE5
Gui, Add, Button, x+15 vCIEd gDel, Delete
Gui, Add, Text, x+15 vSize_CIE, %Size_CIE%
Gui, Add, Text, xs, This folder contains temporary files downloaded from the websites you have visited.
Gui, Add, Button, w100 y+20 vCOO gRun, Cookies
Gui, Add, Button, x+15 vCOOd gDel, Delete
Gui, Add, Text, x+15 vSize_COO, %Size_COO%
Gui, Add, Text, xs, This folder contains your Internet cookies (stats and info recorded by websites).
Gui, Add, Button, w100 y+20 vHIE gRun, History.IE5
Gui, Add, Button, x+15 vHIEd gDel, Delete
Gui, Add, Text, x+15 vSize_HIE, %Size_HIE%
Gui, Add, Text, xs, This folder contains a log of the websites you have visited recently.
Gui, Add, Button, w100 y+20 vTIF gRun, Temp IE files
Gui, Add, Button, x+15 vTIFd gDel, Delete
Gui, Add, Text, x+15 vSize_TIF, %Size_TIF%
Gui, Add, Text, xs, This folder contains temporary files downloaded from the websites you have visited.
Gui, Add, Button, w100 y+20 vTOS gRun, Temp OS files
Gui, Add, Button, x+15 vTOSd gDel, Delete
Gui, Add, Text, x+15 vSize_TOS, %Size_TOS%
Gui, Add, Text, xs, This folder contains temporary files created by Windows programs.
Gui, Add, Button, w100 y+20 vTWU gRun, Temp WU files
Gui, Add, Button, x+15 vTWUd gDel, Delete
Gui, Add, Text, x+15 vSize_TWU, %Size_TWU%
Gui, Add, Text, xs, This folder contains temporary files downloaded by Windows Update.
;
Gui, Add, GroupBox, x520 y30 Section w80 h50
Gui, Add, Text, xs+10 ys+10, Composed in:
Gui, Font, bold
Gui, Add, Text, gAHK cBlue y+5, AutoHotkey
Gui, Font, norm
Gui, Add, Pic, gPic3 x550 y150 Icon81, %A_WinDir%\System32\shell32.dll
Gui, Add, Pic, gPic2 x550 y250, %A_WinDir%\System32\cleanmgr.exe
Gui, Add, Pic, gPic x550 y350 Icon39, %A_WinDir%\System32\inetcpl.cpl
;
Gui, Tab, 2
Gui, Font, bold
Gui, Add, Text, cBlue gKB Section, KB301057
Gui, Add, Text, cBlue gWiki x+15, Wikipedia
Gui, Font, norm
Gui, Add, ListBox, vIndexList gCopy w576 xs r20 sort HScroll1152 ReadOnly, %index%
Gui, Add, Button, %off% gDelIndex, Delete
Gui, Add, Button, x+15 gRefresh, Refresh
Gui, Add, Text, x540 y380 cGray gjaco0646, jaco0646
;
Gui, Show,, IE Cache Delete
links = Static14|Static18|Static19
SetTimer, URL, 100
return
Refresh:
If A_IsCompiled
 Run, %A_ScriptFullPath% /r Choose2
Else Run, %A_AhkPath% /r "%A_ScriptFullPath%" Choose2
GuiClose:
ExitApp
;
;####################
;#g-Labels: folders##
;####################
;
Run:
Run,% Path_%A_GuiControl%
return
Del:
Gui, +OwnDialogs
StringTrimRight, GuiControl, A_GuiControl, 1
MsgBox, 36, IE Cache Delete,% Msg_%GuiControl%
IfMsgBox, No
 return
Loop,% Path_%GuiControl% "\*.*",2
 FileRemoveDir, %A_LoopFileLongPath%, 1
Loop,% Path_%GuiControl% "\*.*"
 FileDelete, %A_LoopFileLongPath%
Size := GetSize(Path_%GuiControl%)
GuiControl,,Size_%GuiControl%, %Size%
StringGetPos, num, size, %A_Tab%
StringMid, num, size,% num+2, 1
If num
 MsgBox, 48, IE Cache Delete, Some files are in use and cannot be deleted.
return
;
;####################
;#g-Labels: URLs#####
;####################
;
AHK:
Run, http://www.autohotkey.com
return
Pic3:
Run, dfrg.msc
return
Pic2:
Run, cleanmgr.exe
return
Pic:
Run, inetcpl.cpl
return
KB:
Run, http://support.microsoft.com/?kbid=301057
return
Copy:
StringReplace, index2, index, |, `r`n, 1
Gui, +OwnDialogs
clipboard = 
clipboard = %index2%
ClipWait
MsgBox, 64, IE Cache Delete, The list of index.dat files has been copied to the clipboard.
return
Wiki:
Run, http://en.wikipedia.org/wiki/Index.dat
return
jaco0646:
Run, http://www.autohotkey.net/~jaco0646/
return
;
;
;####################
;#g-Labels: index####
;####################
;
DelIndex:
Gui, +OwnDialogs
MsgBox, 36, IE Cache Delete, Are you sure you want to delete these files?
(
`nWindows Explorer (explorer.exe) will temporarily be turned off.
`nClose ALL open programs before clicking Yes.
)
IfMsgBox, No
 return
SetTimer, URL, Off
RegWrite, REG_DWORD, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon, AutoRestartShell, 0
Loop
{
 Process, Close, explorer.exe
 Process, WaitClose, explorer.exe, 5
 If ErrorLevel = 0
  break
 If A_Index = 5
 {
  MsgBox, 16, IE Cache Delete, PID %ErrorLevel% (explorer.exe) could not be closed.
  Goto, OnError
 }
}
Loop, Parse, index, |
 count := A_Index - 1
Progress, b2 r0-%count%
Loop, Parse, index, |
{
 If A_LoopField = 
  continue
 Progress, %A_Index%
 FileRecycle, %A_LoopField%
 error += %ErrorLevel%
}
Progress, Off
OnError:
RegWrite, REG_DWORD, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon, AutoRestartShell, 1
SetTimer, URL
If error != 0
 MsgBox, 16, IE Cache Delete, %error% files could not be deleted.
Process, Wait, explorer.exe, 5
If ErrorLevel = 0
 Run, explorer.exe
Goto, Refresh
return
;
;####################
;#Timer##############
;####################
;
URL:
MouseGetPos,,,,where
Loop, Parse, links, |
{
 If where = %A_LoopField%
 {
  If %A_LoopField% != 1
  {
   %A_LoopField% = 1
   Gui, Font, c6495ED underline bold
   GuiControl, Font, %A_LoopField%
  }
 }
 Else If %A_LoopField% = 1
 {
  %A_LoopField% = 0
  Gui, Font, norm cBlue bold
  GuiControl, Font, %A_LoopField%
 }
}
If (where = "Static17") AND (WinActive("ahk_class AutoHotkeyGUI"))
{
 If tip != 1
 {
  tip = 1
  ToolTip, Internet Options
 }
}
Else If (where = "ListBox1") AND (WinActive("ahk_class AutoHotkeyGUI"))
{
 If tip != 1
 {
  tip = 1
  ToolTip, Click to copy index.dat list., 200,60
 }
}
Else If tip = 1
{
 tip = 0
 ToolTip
}
return
;
;####################
;#Function###########
;####################
;
GetSize(folder)
{
 Files = 0
 Size = 0
 Loop, %folder%\*.*,,1
 {
  Files = %A_Index%
  Size += %A_LoopFileSizeMB%
 }
 return Size " MB" A_Tab Files " files"
}