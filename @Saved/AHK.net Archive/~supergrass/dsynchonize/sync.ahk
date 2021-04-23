;This script requires DSynchronize by Dimio
; Download Dsynchronize from http://dimio.altervista.org/eng/ 
;AHK forum IfNotExist, ce : http://www.autohotkey.com/forum/viewtopic.php?t=15889&highlight=xxcopy+gui
;USB detect http://www.autohotkey.com/forum/viewtopic.php?t=7501&highlight=usb+drive+letter

#NoEnv
#SingleInstance force

;find usb drive letter
StringLeft, DriveLetter,A_ScriptDir,2
ThisDrive = %DriveLetter%`\

Menu, Tray, Icon , %ThisDrive%sync.ico
Menu, Tray,  NoStandard
Menu, Tray, Tip, Fast USB Sync
Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, Exit, Exit

;check for Dsynchronize.exe in USB root directory (required)
IfNotExist, %ThisDrive%DSynchronize.exe, {
MsgBox, 48,USB Synchronize,Copy Dsynchronize.exe to the root directory
ExitApp
}


;define backup folder
IfNotExist, %A_MyDocuments%USB_backup
FileCreateDir, %A_MyDocuments%USB_backup
PCFolder = %A_MyDocuments%`\USB_backup

;decide whether to use last settings
IfExist, %ThisDrive%ahkDsync.ini, {
MsgBox, 4, USB Synchronize, Use Last Settings?
IfMsgBox, Yes
Gosub,  UpdateDriveLetter
IfMsgBox, No
Gosub, SelectFolders
}Else{
Gosub, SelectFolders
}
Return 


SelectFolders:

FileDelete, %ThisDrive%ahkDsync.ini

Gui, Add, ListView, r20 w300, Directories
Gui, Add, Button, ,Ok
Gui, Add, Button, xp+50,Cancel

; List directory names from usb drive and put them into the ListView:
Loop, %A_ScriptDir%\*, 2 ; 2 = look for dirs only
{
Stringtrimleft,Folder,A_LoopFileLongPath,3
   LV_Add("", Folder)
}
LV_ModifyCol()  ; Auto-size each column to fit its contents.
Gui, Show
return

ButtonOk:
RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
FolderNo = 0

Loop
{
   RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
   if not RowNumber  ; The above returned zero, so there are no more selected rows.
      break
      
   LV_GetText(USBFolder, RowNumber)
   KeyFolderNo := IniKey(FolderNo)
   IniWrite, +%ThisDrive%%USBFolder%,ahkDsync.ini,Settings,Origine%KeyFolderNo%
   IniWrite, +%PCFolder%\%USBFolder%,ahkDsync.ini,Settings,Destinazione%KeyFolderNo%
   IniWrite,%USBFolder%,ahkDsync.ini,LastFolders,%FolderNo% ; changed 20090204
   
   FolderNo++
   
}
Gui, Destroy

IniWrite,True,ahkDsync.ini,Settings,SyncBidirezionale
IniWrite,False,ahkDsync.ini,Settings,RealTimeSync
IniWrite,False,ahkDsync.ini,Settings,SaveOnExit ;check for effect on operations
IniWrite,True,ahkDsync.ini,Settings,SeNonEsisteCreaLaDestinazione 
IniWrite,False,ahkDsync.ini,Settings,SpegniAlTermine
IniWrite, %FolderNo%,ahkDsync.ini,LastFolders,NumberofFolders

Run, DSynchronize.exe /START /MINIMIZED /ahkDsync.ini

return

GuiClose:
ButtonCancel:
ExitApp

UpdateDriveLetter:
;delete existing mydocs references in ini file

IniRead, Folders,ahkDsync.ini,LastFolders,NumberofFolders
IniDelete, ahkDsync.ini,Settings,Destinazione0000
loop
{
If A_Index > %Folders%-1
Break
KeyFolderNo := IniKey(A_Index)
IniDelete, ahkDsync.ini,Settings,Destinazione%KeyFolderNo%
}

; add new references to mydocs
IniRead, PrevUSBFolder,ahkDsync.ini,LastFolders,0
IniWrite, +%PCFolder%\%PrevUSBFolder%,ahkDsync.ini,Settings,Destinazione0000


loop
{
If A_Index > %Folders%-1 ; 20090204 check output of ini file/dsynchronize
Break
KeyFolderNo := IniKey(A_Index)
LastFolderNo = %A_Index%
IniRead, PrevUSBFolder,ahkDsync.ini,LastFolders,%LastFolderNo%
IniWrite, +%PCFolder%\%PrevUSBFolder%,ahkDsync.ini,Settings,Destinazione%KeyFolderNo%
}
;remap source driveletter

StringLeft, MyDocDrvLtr, A_MyDocuments, 1
FileRead,OldIniFile, ahkDsync.ini
OldIniFile := RegExReplace(OldIniFile, "[^" . MyDocDrvLtr . "]:", DriveLetter, count)
FileDelete, %ThisDrive%ahkDsync.ini 
FileAppend, %OldIniFile%, ahkDsync.ini

;MsgBox, Start dsync
Run, DSynchronize.exe /START /MINIMIZED /ahkDsync.ini
Return

Settings:
IniRead, DefaultName, autorun.inf, Autorun, Label
IniRead, CheckMark, ahkdsync.ini, Settings, Autoplay

If (Checkmark = "Yes"){     ;remember checkmark
Checked = Checked
}else{
Checked =
}
Gui, 1:Add, GroupBox, x7 y6 w247 h134 , Options
Gui, 1:Add, Checkbox, x27 y18 w181 h41 vAutoplay gMakeAutoplay %Checked%, Enable Autoplay (recommended)
Gui, 1:Add, Text, x43 y58 w150 h17 , &Enter a name for USB Drive
Gui, 1:Add, Edit, x44 y81 w139 h20 vUSBname gUSBname,%DefaultName%
Gui, 1:Add, Button, x73 y106 w88 h23 gOKButton, OK
; Generated using SmartGUI Creator 4.0
Gui, 1:Show, x380 y299 h155 w262, USB Sync Settings

Return

MakeAutoplay:
Gui, 1:Submit, NoHide
If (!Autoplay){
IniWrite, No,ahkdsync.ini,Settings,Autoplay
SendInput, !e{BackSpace}
GuiControl, 1:Disable,USBname
}else{
IniWrite, Yes,ahkdsync.ini,Settings,Autoplay
GuiControl, 1:Enable,USBname
}
return

USBname:  ;not required at the moment
return

OKButton:
Gui, 1:Submit, NoHide
If (Autoplay){
Gosub, WriteAutorun
}else{
Gosub, RestoreAutorun
}
Gui, 1: Destroy
return

1GuiClose:
Gui, 1: Destroy
return

WriteAutorun:
IniRead, CheckMark, ahkdsync.ini, Settings, Autoplay
If (!CheckMark = "ERROR"){
  IniWrite, %USBname%,autorun.inf,Autorun,Label
}else{
  IfExist, autorun.inf,{  ;autorun from another program
  FileCopy, autorun.inf,autorun.old, 1
  IniDelete, autorun.inf,Autorun
  }

  If (A_IsCompiled){      
  IniWrite, sync.exe,autorun.inf,Autorun,Open
  }else{
  IniWrite, sync.ahk,autorun.inf,Autorun,Open
  }
  
  Iniwrite, Synchronize USB,Autorun.inf,Autorun,Action
  Iniwrite, sync.ico,Autorun.inf,Autorun,Icon
  IniWrite, %USBname%,autorun.inf,Autorun,Label
  ;IniWrite, 1,autorun.inf,sync,autorun
}
return

RestoreAutorun:
IfExist, autorun.old, {
  FileDelete, autorun.inf
  FileCopy, autorun.old,autorun.inf
  FileDelete,  autorun.old
}else{
  FileDelete, autorun.inf
}
return

Exit:
MsgBox, 4, USB Synchronize, Close DSynchronize?
IfMsgBox, Yes 
{
Process, Close, DSynchronize.exe
ExitApp
}Else{
ExitApp
}
Return 


;FUNCTIONS
IniKey(LoopCount)
{
  KeyFolderNo = 000%LoopCount%
  StringLen, KeyLength, KeyFolderNo
  If (KeyLength >= 5) {
  KeyFolderNo = 00%LoopCount%
  }
  Return KeyFolderNo
}
