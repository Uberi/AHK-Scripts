Version = 2.0
ScriptName = AHK CopyPassage %Version%

#SingleInstance force

SetTitleMatchMode, 2

; Read used browser and shortcut from config.ini
IniRead, UserBrowser, config.ini, Browser, BrwsrName
If (UserBrowser = "IExplorer")
  {
    IniRead, BrwsrShrtct, config.ini, BrowserShortcut, IE
  }
Else If (UserBrowser = "Firefox")
  {
    IniRead, BrwsrShrtct, config.ini, BrowserShortcut, FF
  }
Else If (UserBrowser = "Opera")
  {
    IniRead, BrwsrShrtct, config.ini, BrowserShortcut, OP
  }

; Read export dir from config.ini for preselection and export routine
IniRead, ExportDir, config.ini, ExportDirectory, ExportDir, %A_ScriptDir%\notes\exports

; Creating and checking directory structure
IfNotExist, %A_ScriptDir%\notes
  {
    FileCreateDir, %A_ScriptDir%\notes
  }

; Assign icon paths to variables
note_ico = %A_ScriptDir%\ico\note.ico
logo_ico = %A_ScriptDir%\ico\logo.ico
logo_big = %A_ScriptDir%\ico\logo_big.ico

url_bmp     = %A_ScriptDir%\ico\url.bmp
edit_bmp    = %A_ScriptDir%\ico\edit.bmp
delete_bmp  = %A_ScriptDir%\ico\delete.bmp
export_bmp  = %A_ScriptDir%\ico\export.bmp
gui_bmp     = %A_ScriptDir%\ico\gui.bmp

; Read hotkeys from inifile
IniRead, ShrtCtCopy     , config.ini, ScriptHotkeys, CopyText
IniRead, ShrtCtNameCopy , config.ini, ScriptHotkeys, NameCopyText
IniRead, ShrtCtGui      , config.ini, ScriptHotkeys, OpenGui
IniRead, ShrtCtGoogle   , config.ini, ScriptHotkeys, GoogleSearch
IniRead, ShrtCtURLLookUp, config.ini, ScriptHotkeys, URLLookUp

; Define hotkeys
Hotkey, %ShrtCtCopy%, CopyTextPassage
Hotkey, %ShrtCtNameCopy%, NameTextPassage
Hotkey, %ShrtCtGui%, NoteGui
Hotkey, %ShrtCtGoogle%, GoogleSearch
Hotkey, %ShrtCtURLLookUp%, URLLookUp

; Read previous Gui dimensions and position
IniRead, PosX, config.ini, GuiPosition  , X_Pos, 150
IniRead, PosY, config.ini, GuiPosition  , Y_Pos, 150
IniRead, GuiW, config.ini, GuiDimension , W_Gui, 681
IniRead, GuiH, config.ini, GuiDimension , H_Gui, 403

; Read previous Control dimensions
IniRead, LsVH, config.ini, ListViewSize , H_LsV, 362
IniRead, EdtW, config.ini, EditSize     , W_Edt, 500
IniRead, EdtH, config.ini, EditSize     , H_Edt, 362
IniRead, GrpW, config.ini, GroupBoxSize , W_Grp, 675
IniRead, BtnY, config.ini, ButtonYPos   , Y_Btn, 383 

; Custom Tray Icon and Tray menu
Menu, Tray, Icon, %logo_ico%
Menu, Tray, NoStandard
Menu, Tray, Add, Open GUI, NoteGUI
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitCopyPassage
Menu, Tray, Default, Open GUI
Menu, Tray, Tip, %ScriptName%

Menu_AssignBitmap("Tray", "1", gui_bmp)

; Menu bar for main gui
Menu, FileMenu, Add, Pre&ferences, CreatePreferencesGui
Menu, FileMenu, Add,
Menu, FileMenu, Add, Exit &Gui, GuiClose
Menu, FileMenu, Add, E&xit Script, ExitCopyPassage

Menu, EditMenu, Add, Open URL, CallUrlMenu
Menu, EditMenu, Add,
Menu, EditMenu, Add, Edit Note, EditNoteMenu
Menu, EditMenu, Add, Delete Note, DeleteNoteMenu
Menu, EditMenu, Add,
Menu, EditMenu, Add, Export Note, ExportNoteMenu
 
Menu, ViewMenu, Add, Refresh ListView`t  F5, RefreshGui

Menu, HelpMenu, Add, Browser Shortcuts, CreateShortCutGui
Menu, HelpMenu, Add,
Menu, HelpMenu, Add, &About..., CreateAboutGui

Menu, Menubar, Add, &File , :FileMenu
Menu, Menubar, Add, &Edit , :EditMenu
Menu, Menubar, Add, &View , :ViewMenu
Menu, Menubar, Add, &?, :HelpMenu

Menu_AssignBitmap("EditMenu", "1", url_bmp)
Menu_AssignBitmap("EditMenu", "3", edit_bmp)
Menu_AssignBitmap("EditMenu", "4", delete_bmp)
Menu_AssignBitmap("EditMenu", "6", export_bmp)

; Create custom context menu
Menu, Context, Add, Open URL, CallUrl
Menu, Context, Add
Menu, Context, Add, Edit Note, EditNote
Menu, Context, Add, Delete Note, DeleteNote
Menu, Context, Add
Menu, Context, Add, Export Note, ExportNote
Menu, Context, NoStandard

Menu_AssignBitmap("Context", "1", url_bmp)
Menu_AssignBitmap("Context", "3", edit_bmp)
Menu_AssignBitmap("Context", "4", delete_bmp)
Menu_AssignBitmap("Context", "6", export_bmp)

; Include other .ahk files
#Include functions.ahk
Return
; ##############################################################################
; ###### End of Autoexec section ###############################################
; ##############################################################################


; ##############################################################################
; ###### Hotkeys (see hotkey command in Autoexec Section) ######################
; ##############################################################################
CopyTextPassage:
  ; Save current time & date
  FormatTime, note_date,, dd.MM.yyyy HH:mm:ss

  ; Save clipboard content for later restore
  ClipSaved := ClipboardAll
  
  ; Save highlighted lines to variable 'note'
  Send, ^c
  note := ClipBoard
  
  WinGetTitle, WinTitle, A

  If WinTitle contains Internet Explorer,Mozilla,Opera
    {
      ;  Shortcut can be changed via 'Preferences' Gui - see 'File' -> 'Preferences'
      Send, %BrwsrShrtct%
  
      ; Copy to clipboard
      Send, ^c
      note_url := Clipboard
      
      ; Write note to harddisk
      note_filename =  %A_DD%$%A_MM%$%A_YYYY% - %A_Hour%~%A_Min%~%A_Sec%
      FileAppend, Date:`t%note_date%`r`n`r`nURL:`t%note_url%`r`n`r`n%note%
      , %A_ScriptDir%\notes\%note_filename%.txt
    }
  Else
    {
      note_url = %WinTitle%
      
      ; Write note to harddisk
      note_filename =  %A_DD%$%A_MM%$%A_YYYY% - %A_Hour%~%A_Min%~%A_Sec%
      FileAppend, Date:`t%note_date%`r`n`r`nWinTitle: %note_url%`r`n`r`n%note%
      , %A_ScriptDir%\notes\%note_filename%.txt
    }
  
  ; Restore clipboard content and free the memory
  Clipboard := ClipSaved
  ClipSaved =
  
  ToolTip, Text copied successfully
  SetTimer, RemoveToolTip, 2000
Return

NameTextPassage:
  ; Save current time & date
  FormatTime, note_date,, dd.MM.yyyy HH:mm:ss
  
  ; Save clipboard content for later restore
  ClipSaved := ClipboardAll
  
  ; Save highlighted lines to variable 'note'
  Send, ^c
  note := ClipBoard

  WinGetTitle, WinTitle, A

  InputBox, ExportName, Export to folder...
          , Please enter an apposite name for your folder and the text file.
          ,, 325, 130
  If ErrorLevel = 1
    Return
  If ExportName is not space
    {
      FileCreateDir, %ExportDir%\%ExportName%
      
      If WinTitle contains Internet Explorer,Mozilla,Opera
        {
          ;  Shortcut can be changed via 'Preferences' Gui - see 'File' -> 'Preferences'
          Send, %BrwsrShrtct%
      
          ; Copy to clipboard
          Send, ^c
          note_url := Clipboard
          
          ; Write note to harddisk
          note_filename =  %ExportName%
          FileAppend, Date:`t%note_date%`r`n`r`nURL:`t%note_url%`r`n`r`n%note%
          , %ExportDir%\%ExportName%\%note_filename%.txt
        }
      Else
        {
          note_url = %WinTitle%
          
          ; Write note to harddisk
          note_filename =  %ExportName%
          FileAppend, Date:`t%note_date%`r`n`r`nWinTitle: %note_url%`r`n`r`n%note%
          , %ExportDir%\%ExportName%\%note_filename%.txt
        }
      
      ; Restore clipboard content and free the memory
      Clipboard := ClipSaved
      ClipSaved =
      
      ToolTip, Text copied successfully
      SetTimer, RemoveToolTip, 2000
    }
Return

NoteGUI:
  IfWinExist, %ScriptName%
    {
      WinActivate, %ScriptName% 
      Return     
    }
  Else
    {
      ; Create GUI
      Gui, 1:Menu, Menubar
      
      Gui, 1:+Resize     
      Gui, 1:Margin, 3, 3
      
      Gui, 1:Add, Groupbox, vGrpBoxBorder x3 y-6 w%GrpW% h8
      Gui, 1:Add, Text, x3 y4 Section, Notes:
      Gui, 1:Add, Text, x178 y4, Content:
      Gui, 1:Add, ListView, gNoteFileList vNoteFileList x3 y18 h%LsVH% w170 Grid -Multi AltSubmit -Hdr
      , Filename:|SortDate:
      
      LV_ModifyCol(1, "Text 166")       ; note_filename  -> FillNoteFileList subroutine
      LV_ModifyCol(2, "Integer 0")      ; note_timestamp -> FillNoteFileList subroutine
      LV_ModifyCol(1, "NoSort")         ; disabled sorting for HiddenCol sorting trick 
      
      Gui, 1:Font,, Courier
      Gui, 1:Add, Edit, vNoteDetail x178 y18 h%EdtH% w%EdtW% ReadOnly
      Gui, 1:Font
      Gui, 1:Add, Button, gBtnGoogle vBtnGoogle x180 y%BtnY% w75 h20, Google
      Gui, 1:Add, Button, gBtnURLLookUp vBtnURLLockup x260 y%BtnY% w75 h20, URL Lookup
      
      ILStatus := IL_Create(1,1,0)
      IL_Add(ILStatus, note_ico)
      LV_SetImageList(ILStatus, 1)
      
      ; Show Gui
      Gui, 1:Show, x%PosX% y%PosY% w%GuiW% h%GuiH%, %ScriptName%
      
      ; Fill Listview with existing .txt files
      GoSub, FillNoteFileList
    }
Return

GoogleSearch:
  ; Save clipboard content for later restore
  ClipSaved := ClipboardAll
  
  ; Flush clipboard
  Clipboard =
  
  ; Save highlighted lines to variable 'word'
  Send, ^c
  ClipWait, 2
  If Clipboard is not space
    {
      word := ClipBoard
      Run, www.google.com/search?q=%word%  
    }
    
  ; Restore clipboard content and free the memory
  Clipboard := ClipSaved
  ClipSaved =
Return

URLLookUp:
  ; Save clipboard content for later restore
  ClipSaved := ClipboardAll
  
  ; Flush clipboard
  Clipboard =
  
  ; Save highlighted lines to variable 'word'
  Send, ^c
  ClipWait, 2
  If Clipboard is not space
    {
      word := ClipBoard
      Run, %word%
    }
    
  ; Restore clipboard content and free the memory
  Clipboard := ClipSaved
  ClipSaved =
Return


; ##############################################################################
; ###### General subroutines ###################################################
; ##############################################################################
; Needed for Copy Hotkey - report successful copy operation
RemoveToolTip:
  SetTimer, RemoveToolTip, Off
  ToolTip
Return

; Needed for Edit Menu entries
GetListViewHighlight:
  ActRow := LV_GetNext("F")
  If ActRow > 0
    {
      LV_GetText(note_file, ActRow)
      
      ; Translate note_file to machine readable format
      StringReplace, note_file, note_file, :, ~, All
      StringReplace, note_file, note_file, ., $, All
      note_file = %note_file%.txt
    }
Return


; ##############################################################################
; ###### Gui subroutines #######################################################
; ##############################################################################
GuiEscape:
GuiClose:
  If GuiIsNotMinimized
    {
      ; Save Gui Size and Position
      WinGetPos, PosX, PosY, GuiW, GuiH, %ScriptName%
      GuiW := GuiW - 8  ; Subtract Gui Margin and border width 
      GuiH := GuiH - 46 ; Subtract title bar and menu height
      
      IniWrite, %PosX%, config.ini, GuiPosition, X_Pos
      IniWrite, %PosY%, config.ini, GuiPosition, Y_Pos   
      IniWrite, %GuiW%, config.ini, GuiDimension, W_Gui
      IniWrite, %GuiH%, config.ini, GuiDimension, H_Gui
      
      ; Save Control sizes and positions
      ControlGetPos,,,, LsVH, SysListView321, %ScriptName%
      ControlGetPos,,, EdtW, EdtH, Edit1, %ScriptName%
      ControlGetPos,,, GrpW,, Button1, %ScriptName%
      ControlGetPos,, BtnY,,, Button2, %ScriptName%
      BtnY := BtnY - 42
      IniWrite, %LsVH%, config.ini, ListViewSize, H_LsV
      IniWrite, %EdtW%, config.ini, EditSize, W_Edt
      IniWrite, %EdtH%, config.ini, EditSize, H_Edt
      IniWrite, %GrpW%, config.ini, GroupBoxSize, W_Grp
      IniWrite, %BtnY%, config.ini, ButtonYPos, Y_Btn
    }
  
  Gui, 1:Destroy
Return

GuiSize:
  ; If Gui is not minimized
  If (A_EventInfo <> 1)
    {
      GuiIsNotMinimized := true
      
      Anchor("NoteDetail", "wh", 0, 0, EdtW, EdtH)
      Anchor("NoteFileList", "h", 0, 0, 0, LsVH)
      Anchor("GrpBoxBorder", "w", 0, 0, GrpW, 0)
      Anchor("BtnGoogle", "y", 0, BtnY, 0, 0)
      Anchor("BtnURLLockup", "y", 0, BtnY, 0, 0)
    }
  Else
    {
      GuiIsNotMinimized := false
    }
Return

GuiContextMenu:
  RowSelected := LV_GetCount("S")
  
  If (A_GuiEvent = "RightClick" AND RowSelected)
    {
      Menu, Context, Show
    }
Return

; ListView gLabel
NoteFileList:
  If (A_GuiEvent = "Normal" OR A_GuiEvent = "RightClick")
    {     
      LV_GetText(note_file, A_EventInfo)
      
      ; Translate note_file to machine readable format
      StringReplace, note_file, note_file, :, ~, All
      StringReplace, note_file, note_file, ., $, All
      note_file = %note_file%.txt
      
      FileRead, note_text, %A_ScriptDir%\notes\%note_file%
      GuiControl, 1:, NoteDetail, %note_text%
    }
Return

FillNoteFileList:
  ; Clear ListView
  LV_Delete()

  Loop, %A_ScriptDir%\notes\*.txt
    {
      ; Attention - first variable name is also used within copy hotkey
      note_filename = %A_LoopFileName%
      note_timestamp = %A_LoopFileName%
      
      StringTrimRight, note_filename, note_filename, 4        ; remove '.txt'
      StringReplace, note_filename, note_filename, ~, :, All  ; replace ~ with :
      StringReplace, note_filename, note_filename, $, ., All  ; replace $ with .
      
      ; Extract YYYYMMDDHH24MISS timestamp for second column (HiddenCol sorting trick)
      StringMid, note_year  , note_timestamp,  7, 4
      StringMid, note_month , note_timestamp,  4, 2
      StringMid, note_day   , note_timestamp,  1, 2
      StringMid, note_hour  , note_timestamp, 14, 2
      StringMid, note_minute, note_timestamp, 17, 2
      StringMid, note_second, note_timestamp, 20, 2
      
      note_timestamp = %note_year%%note_month%%note_day%%note_hour%%note_minute%%note_second%
      
      LV_Add("Icon1", note_filename, note_timestamp)
    }
  LV_ModifyCol(2, "SortDesc")      ; sort by hidden column2 in descending order   
Return

FillNoteEditControl:
  ActRow := LV_GetNext("F")
  LV_GetText(note_file, ActRow)
  
  ; Translate note_file to machine readable format
  StringReplace, note_file, note_file, :, ~, All
  StringReplace, note_file, note_file, ., $, All
  note_file = %note_file%.txt
  
  FileRead, note_text, %A_ScriptDir%\notes\%note_file%
  GuiControl, 1:, NoteDetail, %note_text%
Return

BtnGoogle:
  GuiControl, 1:Focus, NoteDetail
  Send, ^c
  If Clipboard is not space
    {
      Run, www.google.com/search?q=%Clipboard%  
    }
Return

BtnURLLookUp:
  GuiControl, 1:Focus, NoteDetail
  Send, ^c
  If Clipboard is not space
    {
      Run, %Clipboard%  
    }
Return

$F5::
  IfWinNotActive, %ScriptName%
    {
    	Send, {F5}
    	Return
    }
; Otherwise script is running and label can be executed
RefreshGui:
  GoSub, FillNoteFileList
Return

; Hotkey for Keyboard navigation within ListView
$Up::
  IfWinNotActive, %ScriptName%
    {
    	Send, {Up}
    	Return
    }
  Send, {Up}
  GoSub, FillNoteEditControl
Return

$Down::
  IfWinNotActive, %ScriptName%
    {
    	Send, {Down}
    	Return
    }
  Send, {Down}
  GoSub, FillNoteEditControl
Return

ExitCopyPassage:
  ExitApp


; ##############################################################################
; ###### Edit Menu subroutines #################################################
; ##############################################################################
CallUrlMenu:
  GoSub, GetListViewHighlight
  If ActRow > 0
    {
      GoSub, CallUrl
    }
Return

EditNoteMenu:
  GoSub, GetListViewHighlight
  If ActRow > 0
    {
      GoSub, EditNote
    }
Return

DeleteNoteMenu:
  GoSub, GetListViewHighlight
  If ActRow > 0
    {
      GoSub, DeleteNote
    }
Return

ExportNoteMenu:
  GoSub, GetListViewHighlight
  If ActRow > 0
    {
      GoSub, ExportNote
    }
Return


; ##############################################################################
; ###### Context menu routines #################################################
; ##############################################################################
CallUrl:
  FileRead, note_text, %A_ScriptDir%\notes\%note_file%
  
  Loop, Parse, note_text, `n
    {
      If A_Index = 3
        {
          StringLeft, CheckForURL, A_LoopField, 3
          If (CheckForURL = "URL")
            {
              StringTrimLeft, OpenURL, A_LoopField, 5
              StringTrimRight, OpenURL, OpenURL, 1
              Break
            }
          Else
            Return
        }
      Else
        Continue
    }
  Run, %OpenURL%
Return

EditNote:
  RunWait, %A_ScriptDir%\notes\%note_file%
  FileRead, note_text, %A_ScriptDir%\notes\%note_file%
  GuiControl, 1:, NoteDetail, %note_text%
Return

; Delete-hotkey for easier ListView cleaning
$Del::
  IfWinNotActive, %ScriptName%
    {
    	Send, {DEL}
    	Return
    }
  ActRow := LV_GetNext("F")
  If ActRow = 0
    Return
; Otherwise delete entry from ListView
DeleteNote:
  ActRow := LV_GetNext("F")
  LV_GetText(DeleteFile, ActRow)

  MsgBox, 8244, Delete Note, Are you sure you want to delete `n`n%DeleteFile% ?
  IfMsgBox, Yes
    {
      StringReplace, DeleteFile, DeleteFile, :, ~, All
      StringReplace, DeleteFile, DeleteFile, ., $, All
      FileDelete, %A_ScriptDir%\notes\%DeleteFile%.txt
      
      GoSub, FillNoteFileList
      LV_Modify(ActRow, "Select Focus")
      
      ; Fill Edit control with now selected ListView entry
      LV_GetText(note_file, ActRow)
      
      StringReplace, note_file, note_file, :, ~, All
      StringReplace, note_file, note_file, ., $, All
      note_file = %note_file%.txt
      
      FileRead, note_text, %A_ScriptDir%\notes\%note_file%
      GuiControl, 1:, NoteDetail, %note_text%
    }
Return

ExportNote:
  Gui, 1:+OwnDialogs
  ActRow := LV_GetNext("F")
  InputBox, ExportName, Export to folder...
          , Please enter an apposite name for your folder and the text file.
          ,, 325, 130
  If ErrorLevel = 1
    Return
  If ExportName is not space
    {
      FileCreateDir, %ExportDir%\%ExportName%
      FileMove, %A_ScriptDir%\notes\%note_file%, %ExportDir%\%ExportName%\%ExportName%.txt
    
      ; Rebuild ListView
      GoSub, FillNoteFileList
      LV_Modify(ActRow, "Select Focus")
      
      ; Fill Edit control with now selected ListView entry
      LV_GetText(note_file, ActRow)
      
      StringReplace, note_file, note_file, :, ~, All
      StringReplace, note_file, note_file, ., $, All
      note_file = %note_file%.txt
      
      FileRead, note_text, %A_ScriptDir%\notes\%note_file%
      GuiControl, 1:, NoteDetail, %note_text%
    }
Return


; ##############################################################################
; ###### Preferences Gui (Gui 2) ###############################################
; ##############################################################################
CreatePreferencesGui:
  ; Disable hotkeys
  Hotkey, %ShrtCtCopy%, Off
  Hotkey, %ShrtCtNameCopy%, Off
  Hotkey, %ShrtCtGui%, Off
  Hotkey, %ShrtCtGoogle%, Off
  Hotkey, %ShrtCtURLLookUp%, Off

  ; Read used browser from config.ini for preselection
  IniRead, UserBrowser, config.ini, Browser, BrwsrName
  If (UserBrowser = "IExplorer")
    {
      RadBtnNumber = 4
    }
  Else If (UserBrowser = "Firefox")
    {
      RadBtnNumber = 5
    }
  Else If (UserBrowser = "Opera")
    {
      RadBtnNumber = 6
    }

  Gui, 1:+Disabled
  Gui, 2:+ToolWindow
  Gui, 2:Margin, 3, 3
  
  ; Change used browser 
  Gui, 2:Add, GroupBox, w325 h150 Section, General Settings:
  Gui, 2:Add, Text, xs+9 ys+25, Notes will be exported to this directory
  Gui, 2:Add, Edit, vEdtExportDir xs+9 ys+45 r1 w282, %ExportDir%
  Gui, 2:Add, Button, gBtnExportDir xp+287 yp+1 h19 w19, ...
  Gui, 2:Add, Text, xs+9 ys+73,
  (Ltrim
    Exporting notes lets you specify an apposite* name for the note, 
    creates a directory under this name in the specified directory 
    above, finally renames the note to this name and moves it to 
    this directory. 
    Attention: Note is removed from the listview control after this.
  ) 
  Gui, 2:Add, GroupBox, w325 h151 xs Section, Choose your browser:
  Gui, 2:Add, Text, xs+9 ys+25
  , Change the 'browser specific' shortcut for putting focus `nto the browser's adress bar.
  
  Gui, 2:Add, Radio, gAdrBarFocus vAdrBarFocus xs+20 ys+70 w13 h13 Section
  Gui, 2:Add, Radio, gAdrBarFocus xp+60 yp w13 h13
  Gui, 2:Add, Radio, gAdrBarFocus xp+60 yp w13 h13
  
  Gui, 2:Add, Picture, gPicIE xp-102 yp-6 h23 w23, %A_ScriptDir%\ico\ie.ico
  Gui, 2:Add, Picture, gPicFF xp+62 yp h23 w23, %A_ScriptDir%\ico\firefox.ico
  Gui, 2:Add, Picture, gPicOP xp+60 yp h23 w23, %A_ScriptDir%\ico\opera.ico
  
  Gui, 2:Add, Text, xp+35 yp+5, ------->
  Gui, 2:Add, Edit, vEdtShortcut xp+40 yp-2 w30 r1, %AdrCtrlShrtCut%
  Gui, 2:Add, Button, gHelpShortcuts xp+35 yp+1 h19 w19, ?
  
  Gui, 2:Add, Text, xs-10 ys+40
  , Check 'send' command for further details concerning the syntax:
  Gui, 2:Add, Text, xp+5 yp+15, -->
  Gui, 2:Add, Text, xp+15 yp cBlue gDocLink vURL_DocLink, Send
  Gui, 2:Font, norm
  
  ; Change script hotkeys
  Gui, 2:Add, GroupBox, xm+330 ym w325 h304 Section, Change script hotkeys:
  Gui, 2:Add, Text, xs+9 ys+25, Configure the used hotkeys within the scripts to your needs.
  
  Gui, 2:Add, GroupBox, xs+10 ys+45 w305 h48 Section, Copy to textfile:
  Gui, 2:Add, Text, xs+20 ys+20, Win  +
  Gui, 2:Add, Hotkey, vHotkeyCopy xp+40 yp-2 w131
  Gui, 2:Add, Checkbox, gChkCopyWinKey vChkCopyWinKey xp+145 yp+4 h13, Use WIN Key
  
  Gui, 2:Add, GroupBox, xs ys+50 w305 h48 Section, Give name && copy to textfile:
  Gui, 2:Add, Text, xs+20 ys+20, Win  +
  Gui, 2:Add, Hotkey, vHotkeyNameCopy xp+40 yp-2 w131
  Gui, 2:Add, Checkbox, gChkNameCopyWinKey vChkNameCopyWinKey xp+145 yp+4 h13, Use WIN Key  
  
  Gui, 2:Add, GroupBox, xs ys+50 w305 h48 Section, Open GUI:
  Gui, 2:Add, Text, xs+20 ys+20, Win  +
  Gui, 2:Add, Hotkey, vHotkeyGui xp+40 yp-2 w131
  Gui, 2:Add, Checkbox, gChkGuiWinKey vChkGuiWinKey xp+145 yp+4 h13, Use WIN Key

  Gui, 2:Add, GroupBox, xs ys+50 w305 h48 Section, Google Search:
  Gui, 2:Add, Text, xs+20 ys+20, Win  +
  Gui, 2:Add, Hotkey, vHotkeyGoogle xp+40 yp-2 w131
  Gui, 2:Add, Checkbox, gChkGoogleWinKey vChkGoogleWinKey xp+145 yp+4 h13, Use WIN Key
  
  Gui, 2:Add, GroupBox, xs ys+50 w305 h48 Section, URL Lookup:
  Gui, 2:Add, Text, xs+20 ys+20, Win  +
  Gui, 2:Add, Hotkey, vHotkeyURLLookUp xp+40 yp-2 w131
  Gui, 2:Add, Checkbox, gChkURLLookUpWinKey vChkURLLookUpWinKey xp+145 yp+4 h13, Use WIN Key
  
  Gui, 2:Show,, Preferences

  ; ****** Needed for URL hover ***********************************
  ; Retrieve scripts PID
  Process, Exist
  pid_this := ErrorLevel
  
  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
  
  ; Call "HandleMessage" when script receives WM_SETCURSOR message
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "URLPrefGui")
  
  ; Call "HandleMessage" when script receives WM_MOUSEMOVE message
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "URLPrefGui")
  ; ****** End ****************************************************
  
  ; Preselect configured browser
  GuiControl, 2:, Button%RadBtnNumber%, 1
  AdrBarFocus := RadBtnNumber - 1
  GoSub, AdrBarFocus
  
  ; Disable Edit control (edit control for Adressbar focus hotkey)
  GuiControl, 2:Disable, Edit2

  ; Disable "Win  +" text control when shortcut doesn't contain WIN key
  ; Fill hotkey control with configured hotkeys in config.ini
  ; ***************************************************************
  If ShrtCtCopy not contains #
    {
      ; Uncheck 'Use WIN key' checkbox
      ; Disable 'Win  +' text control
      GuiControl, 2:, Button10, 0
      GuiControl, 2:Disable, Static12
    }
  Else
    {
      ; Check 'Use WIN key' checkbox
      GuiControl, 2:, Button10, 1
      
      ; Remove 'WIN key' from ShrtCtCopy 
      StringReplace, ShrtCtCopy, ShrtCtCopy, #
    }
  ; Assign Hotkey to hotkey control
  GuiControl, 2:, HotkeyCopy, %ShrtCtCopy%
  ; ***************************************************************
  

  ; ***************************************************************
  If ShrtCtNameCopy not contains #
    {
      ; Uncheck 'Use WIN key' checkbox
      ; Disable 'Win  +' text control
      GuiControl, 2:, Button12, 0
      GuiControl, 2:Disable, Static13
    }
  Else
    {
      ; Check 'Use WIN key' checkbox
      GuiControl, 2:, Button12, 1
      
      ; Remove 'WIN key' from ShrtCtCopy 
      StringReplace, ShrtCtNameCopy, ShrtCtNameCopy, #
    }
  ; Assign Hotkey to hotkey control
  GuiControl, 2:, HotkeyNameCopy, %ShrtCtNameCopy%
  ; ***************************************************************
  
  
  ; ***************************************************************
  If ShrtCtGui not contains #
    {
      ; Uncheck 'Use WIN key' checkbox
      ; Disable 'Win  +' text control
      GuiControl, 2:, Button14, 0
      GuiControl, 2:Disable, Static14
    }
  Else
    {
      ; Check 'Use WIN key' checkbox
      GuiControl, 2:, Button14, 1
      
      ; Remove 'WIN key' from ShrtCtGui
      StringReplace, ShrtCtGui, ShrtCtGui, #
    }
  ; Assign Hotkey to hotkey control      
  GuiControl, 2:, HotkeyGui, %ShrtCtGui%
  ; ***************************************************************


  ; ***************************************************************
  If ShrtCtGoogle not contains #
    {
      ; Uncheck 'Use WIN key' checkbox
      ; Disable 'Win  +' text control
      GuiControl, 2:, Button16, 0
      GuiControl, 2:Disable, Static15
    }
  Else
    {
      ; Check 'Use WIN key' checkbox
      GuiControl, 2:, Button16, 1
      
      ; Remove 'WIN key' from ShrtCtGui
      StringReplace, ShrtCtGoogle, ShrtCtGoogle, #
    }
  ; Assign Hotkey to hotkey control      
  GuiControl, 2:, HotkeyGoogle, %ShrtCtGoogle%
  ; ***************************************************************


  ; ***************************************************************
  If ShrtCtURLLookUp not contains #
    {
      ; Uncheck 'Use WIN key' checkbox
      ; Disable 'Win  +' text control
      GuiControl, 2:, Button18, 0
      GuiControl, 2:Disable, Static16
    }
  Else
    {
      ; Check 'Use WIN key' checkbox
      GuiControl, 2:, Button18, 1
      
      ; Remove 'WIN key' from ShrtCtGui
      StringReplace, ShrtCtURLLookUp, ShrtCtURLLookUp, #
    }
  ; Assign Hotkey to hotkey control      
  GuiControl, 2:, HotkeyURLLookUp, %ShrtCtURLLookUp%
  ; ***************************************************************
Return

2GuiClose:
  Gui, 2:Submit, NoHide

  ; Save Export directory
  ; ***************************************************************
  If EdtExportDir is not space
    {
      IniWrite, %EdtExportDir%, config.ini, ExportDirectory, ExportDir  
    }
  ; ***************************************************************


  ; Save browser and adressbar focus hotkey
  ; ***************************************************************
  If (AdrBarFocus = 1)
    {
      IniWrite, IExplorer, config.ini, Browser, BrwsrName
      IniWrite, %EdtShortcut%, config.ini, BrowserShortcut, IE
      
      ; Re-read browsername and shortcut to variable
      IniRead, UserBrowser, config.ini, Browser, BrwsrName
      IniRead, BrwsrShrtct, config.ini, BrowserShortcut, IE
    }
  Else If (AdrBarFocus = 2)
    {
      IniWrite, Firefox, config.ini, Browser, BrwsrName
      IniWrite, %EdtShortcut%, config.ini, BrowserShortcut, FF
      
      ; Re-read browsername and shortcut to variable
      IniRead, UserBrowser, config.ini, Browser, BrwsrName
      IniRead, BrwsrShrtct, config.ini, BrowserShortcut, FF
    }
  Else If (AdrBarFocus = 3)
    {
      IniWrite, Opera, config.ini, Browser, BrwsrName
      IniWrite, %EdtShortcut%, config.ini, BrowserShortcut, OP
      
      ; Re-read browsername and shortcut to variable
      IniRead, UserBrowser, config.ini, Browser, BrwsrName
      IniRead, BrwsrShrtct, config.ini, BrowserShortcut, OP
    }
  ; ***************************************************************
  
  
  ; Create new hotkeys  
  ; ***************************************************************  
  ; 'Copy' hotkey without WIN Key 
  If ChkCopyWinKey = 0
    {
      GoSub, DefineNewCopyHotkey
    }
  ; 'Copy' hotkey with WIN Key 
  Else If ChkCopyWinKey = 1
    {
      ; Add WIN key symbol
      HotkeyCopy = #%HotkeyCopy%      
      GoSub, DefineNewCopyHotkey
    }
  ; ***************************************************************
  

  ; ***************************************************************  
  ; 'NameCopy' hotkey without WIN Key 
  If ChkNameCopyWinKey = 0
    {
      GoSub, DefineNewNameCopyHotkey
    }
  ; 'NameCopy' hotkey with WIN Key 
  Else If ChkNameCopyWinKey = 1
    {
      ; Add WIN key symbol
      HotkeyNameCopy = #%HotkeyNameCopy%      
      GoSub, DefineNewNameCopyHotkey
    }
  ; ***************************************************************


  ; ***************************************************************  
  ; 'Gui' hotkey without WIN key
  If ChkGuiWinKey = 0
    {
      GoSub, DefineNewGuiHotkey
    }
  ; 'Gui' hotkey with WIN key
  If ChkGuiWinKey = 1
    {
      ; Add WIN key symbol
      HotkeyGui = #%HotkeyGui%     
      GoSub, DefineNewGuiHotkey
    }
  ; ***************************************************************


  ; ***************************************************************  
  ; 'Google' hotkey without WIN key
  If ChkGoogleWinKey = 0
    {
      GoSub, DefineNewGoogleHotkey
    }
  ; 'Google' hotkey with WIN key
  If ChkGoogleWinKey = 1
    {
      ; Add WIN key symbol
      HotkeyGoogle = #%HotkeyGoogle%     
      GoSub, DefineNewGoogleHotkey
    }
  ; *************************************************************** 
 
 
   ; ***************************************************************  
  ; 'URLLookUp' hotkey without WIN key
  If ChkURLLookUpWinKey = 0
    {
      GoSub, DefineNewURLLookUpHotkey
    }
  ; 'URLLookUp' hotkey with WIN key
  If ChkURLLookUpWinKey = 1
    {
      ; Add WIN key symbol
      HotkeyURLLookUp = #%HotkeyURLLookUp%     
      GoSub, DefineNewURLLookUpHotkey
    }
  ; ***************************************************************   
  
  ; Activate hotkeys in case new hotkey is the same as old hotkey
  Hotkey, %ShrtCtCopy%, On
  Hotkey, %ShrtCtNameCopy%, On 
  Hotkey, %ShrtCtGui%, On
  Hotkey, %ShrtCtGoogle%, On
  Hotkey, %ShrtCtURLLookUp%, On 

  Gui, 1:-Disabled
  Gui, 2:Destroy
Return

BtnExportDir:
  Gui, 2:+OwnDialogs
  FileSelectFolder, ExportDir, *%A_ScriptDir%, 3, Choose Export directory
  If ExportDir is space
    Return
  GuiControl, 2:, EdtExportDir, %ExportDir%
Return

DefineNewCopyHotkey:
  ; Save new hotkey and re-read to variable ShrtCtCopy
  IniWrite, %HotkeyCopy%, config.ini, ScriptHotkeys, CopyText
  IniRead, ShrtCtCopy, config.ini, ScriptHotkeys, CopyText
  
  ; Define new hotkey
  Hotkey, %ShrtCtCopy%, CopyTextPassage
Return

DefineNewNameCopyHotkey:
  ; Save new hotkey and re-read to variable ShrtCtCopy
  IniWrite, %HotkeyNameCopy%, config.ini, ScriptHotkeys, NameCopyText
  IniRead, ShrtCtNameCopy, config.ini, ScriptHotkeys, NameCopyText
  
  ; Define new hotkey
  Hotkey, %ShrtCtNameCopy%, NameTextPassage
Return

DefineNewGuiHotkey:  
  ; Save new hotkey and re-read to variable ShrtCtCopy
  IniWrite, %HotkeyGui%, config.ini, ScriptHotkeys, OpenGui
  IniRead, ShrtCtGui, config.ini, ScriptHotkeys, OpenGui
  
  ; Define new hotkey
  Hotkey, %ShrtCtGui%, NoteGUI 
Return

DefineNewGoogleHotkey:
  ; Save new hotkey and re-read to variable ShrtCtCopy
  IniWrite, %HotkeyGoogle%, config.ini, ScriptHotkeys, GoogleSearch
  IniRead, ShrtCtGoogle, config.ini, ScriptHotkeys, GoogleSearch
  
  ; Define new hotkey
  Hotkey, %ShrtCtGoogle%, GoogleSearch
Return

DefineNewURLLookUpHotkey:
  ; Save new hotkey and re-read to variable ShrtCtCopy
  IniWrite, %HotkeyURLLookUp%, config.ini, ScriptHotkeys, URLLookUp
  IniRead, ShrtCtURLLookUp, config.ini, ScriptHotkeys, URLLookUp
  
  ; Define new hotkey
  Hotkey, %ShrtCtURLLookUp%, URLLookUp
Return

AdrBarFocus:
  Gui, 2:Submit, NoHide
  
  ; Enable edit control (edit control for Adressbar focus hotkey)
  GuiControl, 2:Enable, Edit2
  
  If (AdrBarFocus = 1)
    {
      IniRead, AdrCtrlShrtCut, config.ini, BrowserShortcut, IE
      GuiControl,2:, EdtShortcut, %AdrCtrlShrtCut%
    }
  Else If (AdrBarFocus = 2)
    {
      IniRead, AdrCtrlShrtCut, config.ini, BrowserShortcut, FF
      GuiControl,2:, EdtShortcut, %AdrCtrlShrtCut%
    }
  Else If (AdrBarFocus = 3)
    {
      IniRead, AdrCtrlShrtCut, config.ini, BrowserShortcut, OP
      GuiControl,2:, EdtShortcut, %AdrCtrlShrtCut%    
    }
Return

PicIE:
  GuiControl, 2:, Button4, 1
  GoSub, AdrBarFocus
Return

PicFF:
  GuiControl, 2:, Button5, 1
  GoSub, AdrBarFocus  
Return

PicOP:
  GuiControl, 2:, Button6, 1
  GoSub, AdrBarFocus  
Return

HelpShortcuts:
  GoSub, CreateShortCutGui
Return

DocLink:
  Run, http://www.autohotkey.com/docs/commands/Send.htm
Return

; gLabel 'Use WIN key' checkbox (Copy Hotkey)
ChkCopyWinKey:
  Gui, 2:Submit, NoHide
  GuiControl, 2:Enable%ChkCopyWinKey%, Static12
Return

; gLabel 'Use WIN key' checkbox (NameCopy Hotkey)
ChkNameCopyWinKey:
  Gui, 2:Submit, NoHide
  GuiControl, 2:Enable%ChkNameCopyWinKey%, Static13
Return

; gLabel 'Use WIN key' checkbox (Gui Hotkey)
ChkGuiWinKey:
  Gui, 2:Submit, NoHide
  GuiControl, 2:Enable%ChkGuiWinKey%, Static14
Return

; gLabel 'Use WIN key' checkbox (Google Hotkey)
ChkGoogleWinKey:
  Gui, 2:Submit, NoHide
  GuiControl, 2:Enable%ChkGoogleWinKey%, Static15
Return

; gLabel 'Use WIN key' checkbox (URL LookUp Hotkey)
ChkURLLookUpWinKey:
  Gui, 2:Submit, NoHide
  GuiControl, 2:Enable%ChkURLLookUpWinKey%, Static16
Return

; ##############################################################################
; ###### Help Gui  (Gui 3) #####################################################
; ##############################################################################
CreateAboutGui:
  Gui, 1:+Disabled
  Gui, 3:+owner +ToolWindow
  Gui, 3:Margin, 5, 5
  
  Gui, 3:Add, Picture, xm ym+5 w32 h32 Section, %logo_big%
  Gui, 3:Font, S12 W600 
  Gui, 3:Add, Text,xp+40 yp-3, %ScriptName%
  Gui, 3:Font
  Gui, 3:Add, Text, xp yp+20, by AGermanUser a.k.a AGU
  Gui, 3:Add, Text, xs+20 yp+35, related thread in the Autohotkey Forum:
  Gui, 3:Add, Text, xp yp+15 cBlue gForumLink vURL_ForumLink, www.autohotkey.com/forum
  Gui, 3:Font, norm
  Gui, 3:Show, AutoSize, About

  ; ****** Needed for URL hover ***********************************  
  ; Retrieve scripts PID
  Process, Exist
  pid_this := ErrorLevel
  
  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
  
  ; Call "HandleMessage" when script receives WM_SETCURSOR message
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "URLAboutGui")
  
  ; Call "HandleMessage" when script receives WM_MOUSEMOVE message
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "URLAboutGui")
  ; ***************************************************************
Return

3GuiClose:
  Gui, 1:-Disabled
  Gui, 3:Destroy
Return

ForumLink:
  Run, http://www.autohotkey.com/forum/viewtopic.php?t=7914
Return


; ##############################################################################
; ###### ShortCut Gui -> HelpMenu  (Gui4) ######################################
; ##############################################################################
CreateShortCutGui:
  Gui, 4:+ToolWindow
  Gui, 4:Margin, 3, 3
  
  Gui, 4:Add, Groupbox, xm ym-4 w312 h255 Section
  Gui, 4:Add, Text, xs+20 ys+20, 
  (LTrim
      The shortcut for focusing the browser's adressbar varys
      between the different browsers. It varys even between 
      different versions and language versions of a certain 
      browser.
      
      Therefore all shortcuts I currently know of or which were 
      reported to me by other users are listed here.
      Use them to configure this script under FILE - Preferences. 
  )  
  Gui, 4:Add, Picture, xp+45 yp+130 w23 h23, %A_ScriptDir%\ico\ie.ico
  Gui, 4:Add, Picture, xp+80 yp w23 h23, %A_ScriptDir%\ico\firefox.ico
  Gui, 4:Add, Picture, xp+80 yp w23 h23, %A_ScriptDir%\ico\opera.ico  
  Gui, 4:Add, Text, xs+56 yp+40, ALT + D`nALT + S`nALT + R`n     F4
  Gui, 4:Add, Text, xp+78 yp, CTRL + L`n     F6
  Gui, 4:Add, Text, xp+98 yp, F8
  
  Gui, 4:Show, AutoSize, Browser Shortcuts
Return

4GuiClose:
  Gui, 4:Destroy
Return
