;Scan harddrive for files and show all contained icons
;by toralf
;requires AHK 1.0.44.09
;www.autohotkey.com/forum/topic4301.html

Version = 6
ScriptName = Icon Viewer v%Version%

/*
changes since version 5:
- requires "../Anchor/Anchor_v3.3.ahk" => http://www.autohotkey.com/forum/viewtopic.php?t=4348
- added support of .icl files
- added resize option, needs ..\Anchor\Anchor_v3.3.ahk
- remembers position and size between starts
- remembers all states of GUI between starts
- added tray menu
- tray icon allows to exit script
*/

#SingleInstance force
#NoTrayIcon
SetBatchLines -1
ScanStatus := False

If ( A_OSType = "WIN32_WINDOWS" )  ; Windows 9x
    ScanFolder = %A_WinDir%\system
Else
    ScanFolder = %A_WinDir%\system32

;tray menu
Menu, Tray, Icon, %ScanFolder%\shell32.dll, 81   ;icon for taskbar and for process in task manager
Menu, Tray, Tip, %ScriptName%
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Exit
Menu, Tray, Click, 1

;get ini file name and values
SplitPath, A_ScriptName, , , , OutNameNoExt
IniFile = %OutNameNoExt%.ini
IniRead, Gui1Pos,      %IniFile%, Settings, Gui1Pos,      %A_Space%
IniRead, Gui1W,        %IniFile%, Settings, Gui1W,        %A_Space%
IniRead, Gui1H,        %IniFile%, Settings, Gui1H,        %A_Space%
IniRead, ScanFolder,   %IniFile%, Settings, ScanFolder,   %ScanFolder%
IniRead, CkbRecursive,       %IniFile%, Settings, CkbRecursive,       0
IniRead, RadFilesReport,     %IniFile%, Settings, RadFilesReport,     0
IniRead, RadFilesTile,       %IniFile%, Settings, RadFilesTile,       0
IniRead, RadFilesIcons,      %IniFile%, Settings, RadFilesIcons,      0
IniRead, RadFilesSmallIcons, %IniFile%, Settings, RadFilesSmallIcons, 0
IniRead, RadFilesList,       %IniFile%, Settings, RadFilesList,       1
IniRead, RadIconsReport,     %IniFile%, Settings, RadIconsReport,     0
IniRead, RadIconsTile,       %IniFile%, Settings, RadIconsTile,       0
IniRead, RadIconsIcons,      %IniFile%, Settings, RadIconsIcons,      1
IniRead, RadIconsSmallIcons, %IniFile%, Settings, RadIconsSmallIcons, 0
IniRead, RadIconsList,       %IniFile%, Settings, RadIconsList,       0
IniRead, RadAHKCommand,      %IniFile%, Settings, RadAHKCommand,      1

Gui, 1:+Resize
Gui, 1:Add, Text, Section , Scan folder
Gui, 1:Add, Edit, ys-3 w245 r1 ReadOnly vScanFolder, %ScanFolder%
Gui, 1:Add, Button, ys-5 vBtnBrowseFolder gBtnBrowseFolder,&...
Gui, 1:Add, Button, ys-5 w50 vBtnScan gBtnScan Default, &Scan
Gui, 1:Add, Checkbox, ys vCkbRecursive Checked%CkbRecursive%, Rec&ursive

Gui, 1:Add, ListView, xm r11 w480 -Multi AltSubmit List vLstOfFiles gLstOfFiles ,Icon Nr.1 & File name|Path

Gui, 1:Add, Text, w140 vTxtFilesFound Section, 0000 files found, shown as
Gui, 1:Add, Radio, ys Checked%RadFilesReport% vRadFilesReport gRadFilesReport ,&Report
Gui, 1:Add, Radio, ys Checked%RadFilesTile% vRadFilesTile gRadFilesTile , &Tile
Gui, 1:Add, Radio, ys Checked%RadFilesIcons% vRadFilesIcons gRadFilesIcons , &Icons
Gui, 1:Add, Radio, ys Checked%RadFilesSmallIcons% vRadFilesSmallIcons gRadFilesSmallIcons ,s&mall Icons
Gui, 1:Add, Radio, ys Checked%RadFilesList% vRadFilesList gRadFilesList , &List

Gui, 1:Add, ListView, xm r2 w480 -Multi AltSubmit Icon vLstOfIcons gLstOfIcons,Icon

Gui, 1:Add, Text, w140 vTxtIconsFound Section, 0000 Icons found, shown as
Gui, 1:Add, Radio, ys Checked%RadIconsReport% vRadIconsReport gRadIconsReport ,Report
Gui, 1:Add, Radio, ys Checked%RadIconsTile% vRadIconsTile gRadIconsTile ,Til&e
Gui, 1:Add, Radio, ys Checked%RadIconsIcons% vRadIconsIcons gRadIconsIcons , Ic&ons
Gui, 1:Add, Radio, ys Checked%RadIconsSmallIcons% vRadIconsSmallIcons gRadIconsSmallIcons ,sm&all Icons
Gui, 1:Add, Radio, ys Checked%RadIconsList% vRadIconsList gRadIconsList , List

Gui, 1:Add, GroupBox, xm w150 r1.2 vGrbAHKCommand,AHK command
Gui, 1:Add, Radio, xp+10 yp+20 Section Checked vRadAHKCommand gRadAHKCommand,&Picture
Gui, 1:Add, Radio, ys gRadAHKCommand,Ima&geList
If RadAHKCommand = 2
    GuiControl, 1:, Ima&geList, 1
Gui, 1:Add, Edit, xm w480 r1 vAHKCommand,
Gui, 1:Add, Button, xm vBtnCopyToCB gBtnCopyToCB Section ,Cop&y to Clipboard
Gui, 1:Add, Button, ys vBtnClose gBtnClose,&Close
Gui, 1:Show, %Gui1Pos%, %ScriptName%
Gui, 1: +LastFound
Gui1UniqueID := WinExist()
;restore old size
WinMove, ahk_id %Gui1UniqueID%, , , , %Gui1W%, %Gui1H%

Return
;#############   End of autoexec section   ####################################

;#############   Browse to the folder from where the serach should start   ####
BtnBrowseFolder:
  Gui, 1:+OwnDialogs
  FileSelectFolder, SelectedDir, *%ScanFolder%, 2, Select folder to start searching for icons
  If SelectedDir
    {
      ;remove "\" if folder is a root drive, e.g. "C:\"
      StringRight, LastChar, SelectedDir, 1
      If LastChar = \
          StringTrimRight, SelectedDir, SelectedDir, 1

      GuiControl, 1:,ScanFolder, %SelectedDir%
    }
  Gosub, BtnScan
Return

;#############   Start or stop scanning for files   ###########################
BtnScan:
  If ScanStatus
      ;break scan loop
      ScanStatus := False
  Else
      ;start a new thread for scaning
      SetTimer, Scan, 20
return

;#############   Scan the folder for files with icons   #######################
Scan:
  SetTimer, Scan, Off

  ScanStatus := True

  Gui, 1:Submit, NoHide

  ;change lable and make default button: scan/stop
  GuiControl, 1:, BtnScan, &STOP
  GuiControl, 1:+Default, BtnScan
      
  ;disable redraw for speed
  GuiControl, 1:-Redraw, LstOfFiles

  ;set list of files as default
  Gui, 1:ListView, LstOfFiles

  ;clear list of files
  LV_Delete()

  ;create new list of small images and replace and delete old one
  IListIDFilesSmall := IL_Create(100, 100, False)
  ListID := LV_SetImageList(IListIDFilesSmall)
  If ListID
      IL_Destroy(ListID)

  ;create new list of large images and replace and delete old one
  IListIDFilesLarge := IL_Create(100, 100, True)
  ListID := LV_SetImageList(IListIDFilesLarge)
  If ListID
      IL_Destroy(ListID)

  ;Search all files
  i = 0
  Loop, %ScanFolder%\*, 0, %CkbRecursive%
    {
      ;If their extention is exe,dll,ico,ani,cpl,icl ...
      If A_LoopFileExt Contains exe,dll,ico,ani,cpl,icl
        {
          ;... get first icon (small) ...
          ID := IL_Add(IListIDFilesSmall, A_LoopFileFullPath, 1)

          ;... And If they have a first Icon ...
          If ID > 0
            {
              ;get large icon
              IL_Add(IListIDFilesLarge, A_LoopFileFullPath, 1)

              ;count this file
              i++

              ;add file to ListView
              LV_Add("Icon" . i, A_LoopFileName, A_LoopFileDir)

              GuiControl,1:,TxtFilesFound,%i% files found, shown as
            }
        }
      ;break loop if user pushes STOP button
      If not ScanStatus
          break
    }

  ScanStatus := False

  ;Enable redraw for speed
  GuiControl, 1:+Redraw, LstOfFiles

  ;Adjust width
  LV_ModifyCol()

  ;rename button to scan again
  GuiControl, 1:, BtnScan, &Scan
Return

;#############   A file got selelected in list   ##############################
LstOfFiles:
  ;file is selected with mouse or by keyboard
  If ( A_GuiEvent = "I" )
    {
      ;set list of files as default
      Gui, 1:ListView, LstOfFiles

      ;get selected file
      RowNumber := LV_GetNext()
      LV_GetText(IV_File, RowNumber, 1)
      LV_GetText(IV_Path, RowNumber, 2)


      ;set list of icons as default
      Gui, 1:ListView, LstOfIcons

      ;diable redraw for speed
      GuiControl, 1:-Redraw, LstOfIcons

      ;clear list
      LV_Delete()

      ;create new list of small images and replace and delete old one
      IListIDIconsSmall := IL_Create(10, 10, False)
      ListID := LV_SetImageList(IListIDIconsSmall)
      If ListID
          IL_Destroy(ListID)

      ;create new list of large images and replace and delete old one
      IListIDIconsLarge := IL_Create(10, 10, True)
      ListID := LV_SetImageList(IListIDIconsLarge)
      If ListID
          IL_Destroy(ListID)

      i = 0
      ;Search for 9999 icons in the selected file
      Loop, 9999
        {
          ;get small icon
          ID := IL_Add(IListIDIconsSmall, IV_Path . "\" . IV_File , A_Index)

          ;if small icon exist
          If ID > 0
            {
              ;get large icon
              IL_Add(IListIDIconsLarge, IV_Path . "\" . IV_File , A_Index)

              i++
              
              ;add icon to list
              LV_Add("Icon" . A_Index, A_Index)

              GuiControl,1:,TxtIconsFound,%i% icons found, shown as
            }
          Else
              Break
        }
      ;enable redraw for speed
      GuiControl, 1:+Redraw, LstOfIcons

      ;clear edit field
      GuiControl,1:,AHKCommand,
    }
Return

;#############   Change of view mode for file list   ##########################
RadFilesReport:
  GuiControl, 1:+Report, LstOfFiles
  Gui, 1:ListView, LstOfFiles
  LV_ModifyCol()
Return

RadFilesTile:
  GuiControl, 1:+Tile, LstOfFiles
Return

RadFilesIcons:
  GuiControl, 1:+Icon, LstOfFiles
Return

RadFilesSmallIcons:
  GuiControl, 1:+IconSmall, LstOfFiles
Return

RadFilesList:
  GuiControl, 1:+List, LstOfFiles
Return

;#############   A icon got selected in list   ################################
LstOfIcons:
  ;icon is selected with mouse or by keyboard
  If ( A_GuiEvent = "I" )
      GoSub, RadAHKCommand
return

;#############   AHK command got changed   ####################################
RadAHKCommand:
  ;set list of icons as default
  Gui, 1:ListView, LstOfIcons

  ;get selected
  RowNumber := LV_GetNext()

  ;If something is selected (might not be true if RadAHKCommand is calling)
  If RowNumber
    {
      ;get Icon number
      LV_GetText(IV_IconID, RowNumber, 1)

      ;get AHKCommand
      Gui, 1:Submit, NoHide

      ;fill edit box with AHK command
      If RadAHKCommand = 1
          GuiControl,1:,AHKCommand, Gui, Add, Picture, icon%IV_IconID% , %IV_Path%\%IV_File%
      Else
          GuiControl,1:,AHKCommand, IL_Add(ImageListID, "%IV_Path%\%IV_File%" , %IV_IconID%)

      ;new default button: copy to clipboard
      GuiControl, 1:+Default, BtnCopyToCB
    }
Return

;#############   Change of view mode for icon list   ##########################
RadIconsReport:
  GuiControl, 1:+Report, LstOfIcons
  Gui, 1:ListView, LstOfIcons
  LV_ModifyCol()
Return

RadIconsTile:
  GuiControl, 1:+Tile, LstOfIcons
Return

RadIconsIcons:
  GuiControl, 1:+Icon, LstOfIcons
Return

RadIconsSmallIcons:
  GuiControl, 1:+IconSmall, LstOfIcons
Return

RadIconsList:
  GuiControl, 1:+List, LstOfIcons
Return

;#############   Copy AHKcommand from edit box to clipboard   #################
BtnCopyToCB:
  Gui, 1:Submit, NoHide
  Clipboard = %AHKCommand%
Return

;#############   Resize window   ##############################################
#Include ..\Anchor\Anchor_v3.3.ahk
GuiSize:
  ;       ControlName     , xwyh with factors [, True for MoveDraw]
 Anchor("ScanFolder"      , "w")
 Anchor("BtnBrowseFolder" , "x", True)
 Anchor("BtnScan"         , "x", True)
 Anchor("CkbRecursive"    , "x")

 Anchor("LstOfFiles"      , "wh0.2")
 Anchor("TxtFilesFound"   , "y0.2w", True)
 Anchor("RadFilesReport"  , "y0.2w", True)
 Anchor("RadFilesTile"    , "y0.2w", True)
 Anchor("RadFilesIcons"   , "y0.2w", True)
 Anchor("RadFilesSmallIcons" , "y0.2w", True)
 Anchor("RadFilesList"     , "y0.2w", True)

 Anchor("LstOfIcons"      , "y0.2wh0.8")
 Anchor("TxtIconsFound"   , "y", True)
 Anchor("RadIconsReport"  , "y", True)
 Anchor("RadIconsTile"    , "y", True)
 Anchor("RadIconsIcons"   , "y", True)
 Anchor("RadIconsSmallIcons" , "y", True)
 Anchor("RadIconsList"    , "y", True)

 Anchor("GrbAHKCommand"   , "y", True)
 Anchor("RadAHKCommand"   , "y", True)
 Anchor("Button16"        , "y", True)
 Anchor("AHKCommand"      , "yw")
 Anchor("BtnCopyToCB"     , "y", True)
 Anchor("BtnClose"        , "y", True)
Return

;#############   Close window   ###############################################
BtnClose:
GuiClose:
GuiEscape:
  WinGetPos, PosX, PosY, SizeW, SizeH, ahk_id %Gui1UniqueID%
  IniWrite, x%PosX% y%PosY% , %IniFile%, Settings, Gui1Pos
  IniWrite, %SizeW% , %IniFile%, Settings, Gui1W
  IniWrite, %SizeH% , %IniFile%, Settings, Gui1H
  Gui, 1:Submit
  IniWrite, %ScanFolder%,         %IniFile%, Settings, ScanFolder
  IniWrite, %CkbRecursive%,       %IniFile%, Settings, CkbRecursive      
  IniWrite, %RadFilesReport%,     %IniFile%, Settings, RadFilesReport    
  IniWrite, %RadFilesTile%,       %IniFile%, Settings, RadFilesTile      
  IniWrite, %RadFilesIcons%,      %IniFile%, Settings, RadFilesIcons     
  IniWrite, %RadFilesSmallIcons%, %IniFile%, Settings, RadFilesSmallIcons
  IniWrite, %RadFilesList%,       %IniFile%, Settings, RadFilesList      
  IniWrite, %RadIconsReport%,     %IniFile%, Settings, RadIconsReport    
  IniWrite, %RadIconsTile%,       %IniFile%, Settings, RadIconsTile      
  IniWrite, %RadIconsIcons%,      %IniFile%, Settings, RadIconsIcons     
  IniWrite, %RadIconsSmallIcons%, %IniFile%, Settings, RadIconsSmallIcons
  IniWrite, %RadIconsList%,       %IniFile%, Settings, RadIconsList      
  IniWrite, %RadAHKCommand%,      %IniFile%, Settings, RadAHKCommand     
  ExitApp
Return
;#############   End of File   ################################################
