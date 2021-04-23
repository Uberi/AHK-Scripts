;Scan a folder or a file and show all contained icons
;by toralf
;requires AHK 1.0.44.09
;www.autohotkey.com/forum/topic4301.html

Version = 2
ScriptName = Icon Viewer Lite v%Version%

/*
changes since version 1:
- requires "../Anchor/Anchor_v3.3.ahk" => http://www.autohotkey.com/forum/viewtopic.php?t=4348
- added tray menu and icon
- tray icon allows to exit script
- added support of .icl files
- added resize option, needs ..\Anchor\Anchor_v3.3.ahk
- remembers position and size between starts
- remembers file between starts
- remembers ShownAs and Command settings between starts
*/

#SingleInstance force
SetBatchLines -1
ScanStatus := False

If ( A_OSType = "WIN32_WINDOWS" )  ; Windows 9x
    DefaultItem = %A_WinDir%\system\shell32.dll
Else
    DefaultItem = %A_WinDir%\system32\shell32.dll

;tray menu
Menu, Tray, Icon, %DefaultItem%, 81   ;icon for taskbar and for process in task manager
Menu, Tray, Tip, %ScriptName%
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Exit
Menu, Tray, Click, 1

;get ini file name and values
SplitPath, A_ScriptName, , , , OutNameNoExt
IniFile = %OutNameNoExt%.ini
IniRead, Gui1Pos,   %IniFile%, Settings, Gui1Pos,  %A_Space%
IniRead, Gui1W,     %IniFile%, Settings, Gui1W,    %A_Space%
IniRead, Gui1H,     %IniFile%, Settings, Gui1H,    %A_Space%
IniRead, ScanItem,  %IniFile%, Settings, ScanItem, %DefaultItem%
IniRead, RadFile,   %IniFile%, Settings, RadFile,   0
IniRead, RadReport, %IniFile%, Settings, RadReport, 0
IniRead, RadTile,   %IniFile%, Settings, RadTile,   1
IniRead, RadIcons,  %IniFile%, Settings, RadIcons,  0
IniRead, RadSmallIcons, %IniFile%, Settings, RadSmallIcons, 0
IniRead, RadList,       %IniFile%, Settings, RadList,       0
IniRead, RadAHKCommand, %IniFile%, Settings, RadAHKCommand, 1

Gui, 1:+Resize
Gui, 1:Add, GroupBox,xm w120 r1.2 ,Select
Gui, 1:Add, Radio,xp+10 yp+20 Section Checked vRadFile, File
Gui, 1:Add, Radio,ys , Folder
If RadFile = 2
    GuiControl, 1:, Folder, 1
Gui, 1:Add, Edit, ym+17 w250 r1 ReadOnly vScanItem, %ScanItem%
Gui, 1:Add, Button, ym+16 vBtnBrowse gBtnBrowse,&...
Gui, 1:Add, Button, ym+16 w50 vBtnScan gBtnScan Default, &Scan

Gui, 1:Add, ListView, xm r6 w480 -Multi AltSubmit Icons vLstOfIcons gLstOfIcons ,Icon&Nr|File name|Internal ID

Gui, 1:Add, Text, w160 vTxtIconsFound Section, 0000 icons found, shown as
Gui, 1:Add, Radio, ys Checked%RadReport% gRadReport vRadReport ,&Report
Gui, 1:Add, Radio, ys Checked%RadTile% gRadTile vRadTile , &Tile
Gui, 1:Add, Radio, ys Checked%RadIcons% gRadIcons vRadIcons , &Icons
Gui, 1:Add, Radio, ys Checked%RadSmallIcons% gRadSmallIcons vRadSmallIcons ,s&mall Icons
Gui, 1:Add, Radio, ys Checked%RadList% gRadList vRadList , &List

Gui, 1:Add, GroupBox, xm w150 r1.2 vGrbAHKCommand,AHK command
Gui, 1:Add, Radio, xp+10 yp+20 Section Checked vRadAHKCommand gRadAHKCommand,&Picture
Gui, 1:Add, Radio, ys gRadAHKCommand,Ima&geList
If RadAHKCommand = 2
    GuiControl, 1:, Ima&geList, 1
Gui, 1:Add, Edit, xm w480 r1 vAHKCommand,
Gui, 1:Add, Button, xm vBtnCopyToCB gBtnCopyToCB Section ,Cop&y to Clipboard
Gui, 1:Add, Button, ys vBtnClose gBtnClose,&Close
Gui, 1:Show, %Gui1Pos% , %ScriptName%
Gui, 1: +LastFound
Gui1UniqueID := WinExist()
;restore old size
WinMove, ahk_id %Gui1UniqueID%, , , , %Gui1W%, %Gui1H%

;If script is started with a filename as parameter, use it as if it was selected in the GUI
If (%0% <> 0) {
    File = %1%
    If FileExist(File){
        GuiControl, 1:,ScanItem, %1%
        Gosub, BtnScan
      }
  }
Return
;#############   End of autoexec section   ####################################

;#############   Browse to the folder from where the serach should start   ####
BtnBrowse:
  Gui, 1:+OwnDialogs
  Gui, 1:Submit, NoHide
  If RadFile = 1
    {
      SplitPath, ScanItem, , StartDir
      FileSelectFile, SelectedFile, S3, %StartDir%, Select file to start searching for icons, Files with icons (*.exe; *.dll; *.icl; *.ico; *.ani; *.cpl)
      If SelectedFile
        {
          GuiControl, 1:,ScanItem, %SelectedFile%
          Gosub, BtnScan
        }
    }
  Else
    {
      SplitPath, ScanItem, , StartDir
      FileSelectFolder, SelectedDir, *%StartDir%, 2, Select folder to start searching for icons
      If SelectedDir
        {
          ;remove "\" if folder is a root drive, e.g. "C:\"
          StringRight, LastChar, SelectedDir, 1
          If LastChar = \
              StringTrimRight, SelectedDir, SelectedDir, 1
    
          GuiControl, 1:,ScanItem, %SelectedDir%
          Gosub, BtnScan
        }
    }
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
  GuiControl, 1:-Redraw, LstOfIcons

  ;clear list of files
  LV_Delete()

  ;create new list of small images and replace and delete old one
  IListIDSmall := IL_Create(100, 100, False)
  ListID := LV_SetImageList(IListIDSmall)
  If ListID
      IL_Destroy(ListID)

  ;create new list of large images and replace and delete old one
  IListIDLarge := IL_Create(100, 100, True)
  ListID := LV_SetImageList(IListIDLarge)
  If ListID
      IL_Destroy(ListID)

  FileGetAttrib, Attrib , %ScanItem%
  
  i = 0
  If Attrib contains D
    	GoSub, SearchFolder
  Else
    {
    	SearchFile = %ScanItem%
    	GoSub, SearchFile
    }

  ;enable redraw for speed
  GuiControl, 1:+Redraw, LstOfIcons

  ScanStatus := False

  ;rename button to scan again
  GuiControl, 1:, BtnScan, &Scan

  ;clear edit field
  GuiControl,1:,AHKCommand,
return

SearchFile:
  ;Search for 9999 icons in the selected file
  Loop, 9999
    {
      ;get small icon
      ID := IL_Add(IListIDSmall, SearchFile , A_Index)

      ;if small icon exist
      If ID > 0
        {
          i++

          ;get large icon
          IL_Add(IListIDLarge, SearchFile , A_Index)

          ;add icon to list
          LV_Add("Icon" . A_Index, A_Index, SearchFile , i)

          GuiControl,1:,TxtIconsFound,%i% icons found, shown as
        }
      Else
          Break
      ;break loop if user pushes STOP button
      If not ScanStatus
          break
    }
return

SearchFolder:
  ;create phantom list of small images and replace and delete old one
  PhantomImageListID := IL_Create(100, 100, False)

  Loop, %ScanItem%\*, 0, 0
    {
      ;get first icon (small)
      ID := IL_Add(PhantomImageListID, A_LoopFileFullPath, 1)

      ;If it has a first Icon ...
      If ID > 0
        {
          SearchFile = %A_LoopFileFullPath%
          GoSub, SearchFile
        }
      ;break loop if user pushes STOP button
      If not ScanStatus
          break
    }
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
      ;get Icon File
      LV_GetText(IV_File, RowNumber, 2)

      ;get AHKCommand
      Gui, 1:Submit, NoHide

      ;fill edit box with AHK command
      If RadAHKCommand = 1
          GuiControl,1:,AHKCommand, Gui, Add, Picture, icon%IV_IconID% , %IV_File%
      Else
          GuiControl,1:,AHKCommand, IL_Add(ImageListID, "%IV_File%" , %IV_IconID%)

      ;new default button: copy to clipboard
      GuiControl, 1:+Default, BtnCopyToCB
    }
Return

;#############   Change of view mode for icon list   ##########################
RadReport:
  GuiControl, 1:+Report, LstOfIcons
  Gui, 1:ListView, LstOfIcons
  ;Adjust width
  LV_ModifyCol(1,"AutoHdr")
  LV_ModifyCol(2,"AutoHdr")
  LV_ModifyCol(3,"AutoHdr")
Return

RadTile:
  GuiControl, 1:+Tile, LstOfIcons
Return

RadIcons:
  GuiControl, 1:+Icon, LstOfIcons
Return

RadSmallIcons:
  GuiControl, 1:+IconSmall, LstOfIcons
Return

RadList:
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
 Anchor("ScanItem"        , "w")
 Anchor("BtnBrowse"       , "x", True)
 Anchor("BtnScan"         , "x", True)
 Anchor("LstOfIcons"      , "wh")
 Anchor("TxtIconsFound"   , "y", True)
 Anchor("RadReport"       , "y", True)
 Anchor("RadTile"         , "y", True)
 Anchor("RadIcons"        , "y", True)
 Anchor("RadSmallIcons"   , "y", True)
 Anchor("RadList"         , "y", True)
 Anchor("GrbAHKCommand"   , "y", True)
 Anchor("RadAHKCommand"   , "y", True)
 Anchor("Button13"        , "y", True)
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
  IniWrite, %ScanItem%, %IniFile%, Settings, ScanItem
  IniWrite, %RadFile%,  %IniFile%, Settings, RadFile
  IniWrite, %RadReport%, %IniFile%, Settings, RadReport
  IniWrite, %RadTile%,   %IniFile%, Settings, RadTile
  IniWrite, %RadIcons%,  %IniFile%, Settings, RadIcons
  IniWrite, %RadSmallIcons%, %IniFile%, Settings, RadSmallIcons
  IniWrite, %RadList%,       %IniFile%, Settings, RadList
  IniWrite, %RadAHKCommand%, %IniFile%, Settings, RadAHKCommand
  ExitApp
Return
;#############   End of File   ################################################
