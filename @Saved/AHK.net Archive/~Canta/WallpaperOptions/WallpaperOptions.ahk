; AutoHotkey Version: 1.0.47.04
; Language:       English
; Platform:       Windows XP
; Title:          Wallpaper options
; Author:         canta
; Created:        2007.12.15
; Last modified:  2008.02.20
; Credits:        Sean (Com.ahk & SetWallpaper.ahk)
; Links:          http://www.autohotkey.net/~Canta/WallpaperOptions/WallpaperOptions.ahk
;                 http://www.autohotkey.com/forum/viewtopic.php?t=22923   (Com.ahk)						
; Script functions: -Choose a wallpaper for each hour of the day
;                   -Changes to a random wallpaper at a interval of your choice
;                   -Choose a regular wallpaper
;                 This script requires Com.ahk (see link above) 

trayIcon =        ; Set your desired iconfile here     

;      **    AUTO-EXECUTE    **
#Persistent ; Keeps a script permanently running
#SingleInstance, Force ; skips the dialog box and replaces the old instance automatically
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
#Include Com.ahk
SetWorkingDir %A_ScriptDir% ; unconditionally use the script's own folder as its working directory
GoSub, IniCheck	;	If a ini file dont exist, make one
Gosub, IniRead ; Read the IniFile and get variables

if State = regular
  {
    statereg = 1
    statehr = 0
    stateran= 0
    sFile := setfile
    Gosub SetWallpaper
  }
if State = random
  {
    stateran = 1
    statehr = 0
    statereg= 0
    Gosub, StateRandom
    UpdateTime *= 60000
    SetTimer, StateRandom, %UpdateTime%
  }
if State = hourly
  {
    statehr = 1
    stateran = 0
    statereg= 0
    GoSub StateHourly
    SetTimer, StateHourly, 60000    
  }

Gosub TrayMenu

tabs = 1pm|2pm|3pm|4pm|5pm|6pm|7pm|8pm|9pm|10pm|11pm|12pm
|1am|2am|3am|4am|5am|6am|7am|8am|9am|10am|11am|12am

;      **    Build the GUI   **
  Gui, +Lastfound
  Gui, Add, GroupBox, w280 h10 Section, Hourly wallpaper
  
  Gui, Add, Tab2, w280 h290 buttons, %tabs% 
  Gui, Tab
  
  Gui, Add, GroupBox, w200 h10 ys, Random wallpaper
  Gui, Add, GroupBox, w200 h55 , Choose your random wallpaper folder
  Gui, Add, GroupBox, w200 h90 , Change wallpaper every
  Gui, Add, GroupBox, w200 h53 , Include subfolders

  Gui, Add, GroupBox, w200 h10 ys Section, Regular wallpaper
  Gui, Add, GroupBox, w200 h55 , Choose your wallpaper
  Gui, Add, GroupBox, w200 h150, Preview
  
  Gui, Add, GroupBox, xm+290 y250 w410 h125 Center, Options
  Gui, Add, Radio, xp+10 yp+35 Section Checked%stateran% vRadiorandom, Use random wallpaper
  Gui, Add, Radio, Checked%statereg% vRadioregular, Use regular wallpaper
  Gui, Add, Radio, Checked%statehr% vRadiohourly, Use hourly wallpaper
  Gui, Add, Text, ys Section, Placement:
  Gui, Add, DropDownList, AltSubmit Choose%position% vDropDownPosition, Center|Tile|Strech|Max

  Gui, Font, s14
  Gui, Add, Button, xm+580 ys w80 h30, &Save
  Gui, Add, Button, xm+580 yp+40 w80 h30, &Cancel 
  Gui, Font

  Loop, 12 ; make identical controls inside each 12 tabs
  {
    Gui, Tab, %A_Index%pm
    IniRead, hr, ini.ini, 24HR, %A_Index%pm
    Gui, Add, Edit, x10 y135 w255 R1 vhr%A_Index%pm, %hr%
    Gui, Add, Button, x265 y135 w25 gButtonFileSelectFileHourspm, ...
    Gui, Add, GroupBox, x10 y165 w280 h210 Section, Preview
    Gui, Add, Picture, x25 y182 w240 h180 border Center vPic%A_Index%pm, %hr%
  }

  Loop, 12 ; make identical controls inside each 12 tabs
  {
    Gui, Tab, %A_Index%am
    IniRead, hr, ini.ini, 24HR, %A_Index%am
    Gui, Add, Edit, x10 y135 w255 R1 vhr%A_Index%am, %hr%
    Gui, Add, Button, x265 y135 w25 gButtonFileSelectFileHoursam, ...,
    Gui, Add, GroupBox, x10 y165 w280 h210 Section, Preview
    Gui, Add, Picture, x25 y182 w240 h180 border Center vPic%A_Index%am, %hr%
  }

  Gui, Tab
  Gui, Add, Edit, x310 y42 w156 R1 vEditFolder, %wallfolder%
  Gui, Add, Button, x467 y42 gButtonFileSelectFolderRandom, ..., 
  
  Gui, Font, s13
  Gui, Add, Edit, x310 y103 w80 Section vEditMinutes gEditInterval  Number
  Gui, Add, UpDown, Number 0x80 vUpDown gUpDown Range1-100000, %ut%
  Gui, Add, Edit, w40 ReadOnly vEditHours,
  Gui, Add, Text, ys, Minutes 
  Gui, Add, Text,, Hours
  Gui, Font
  
  Gui, Add, CheckBox, x310 y203 Checked%Includesub% vCheckBoxInclude,Include subfolders
  
  Gui, Add, Edit, x521 y42 w160 R1 vWallfile gEditSetFile, %setfile%
  Gui, Add, Button, x681 y42 gButtonFileSelectFileSet, ..., 
  Gui, Add, Picture, x530 y103 w160 h120 border vpSet, %setfile%

Return ; end of Auto-execute section

;########   Labels	########
ButtonCancel:
  WinClose, ahk_class AutoHotkeyGUI
Return   ;end of sub: ButtonCancel:
ButtonFileSelectFileHourspm:
  FileSelectFile, hourpm, %A_MyDocuments%
  if ErrorLevel = 0
  {
      ControlGet, tab, Tab, ,SysTabControl321, Options
      GuiControl, Text, hr%tab%pm, %hourpm%  
      GuiControl,, Pic%tab%pm, %hourpm%
  }
Return   ;end of sub: ButtonFileSelectFileHoursam
ButtonFileSelectFileHoursam:
  FileSelectFile, houram, %A_MyDocuments%
  if ErrorLevel = 0
  {
      ControlGet, tab, Tab, ,SysTabControl321, Options
      tab := tab-12
      GuiControl, Text, hr%tab%am, %houram%  
      GuiControl,, Pic%tab%am, %houram%
  }
Return   ;end of sub: ButtonFileSelectFileHoursam
ButtonFileSelectFileSet:
  FileSelectFile, wfile, %A_MyComputer%
  if ErrorLevel = 0
  GuiControl, Text, Wallfile, %wfile% 
Return   ;end of sub: ButtonFileSelectFileSet
ButtonFileSelectFolderRandom:
  IniRead, folder, ini.ini, OPTIONS, wallpaperfolder
  if wallpaperfolder = ERROR
  wallpaperfolder = %A_MyDocuments% 
  FileSelectFolder, OutputVar, *%folder%
  if ErrorLevel = 0
  GuiControl, Text, EditFolder, %OutputVar%
Return   ;end of sub: ButtonFileSelectFolderRandom
ButtonSave:
  Gui, Submit
  IniWrite, %UpDown%, ini.ini, OPTIONS, interval
  IniWrite, %EditFolder%, ini.ini, OPTIONS, wallpaperfolder
  IniWrite, %Wallfile%, ini.ini, OPTIONS, wallpaperfile
  IniWrite, %CheckBoxInclude%, ini.ini, OPTIONS, includesub
  IniWrite, %DropDownPosition%, ini.ini, OPTIONS, position
  if Radiorandom = 1
    IniWrite, random, ini.ini, OPTIONS, state
  if Radioregular = 1
    IniWrite, regular, ini.ini, OPTIONS, state
  if Radiohourly = 1
    IniWrite, hourly, ini.ini, OPTIONS, state
  Loop, 12
    {
      IniWrite, % hr%A_Index%pm, ini.ini, 24HR, %A_Index%pm
    }
  Loop, 12
    {
      IniWrite, % hr%A_Index%am, ini.ini, 24HR, %A_Index%am
    }
  Reload
Return   ;end of sub: ButtonSave:
EditInterval:
  Gui, Submit, NoHide
  hr := (EditMinutes/60)
  GuiControl, Text, EditHours, %hr%
Return   ;end of sub: EditInterval
EditSetFile:
  Gui, Submit, NoHide
  GuiControl,, pSet, %wfile%
Return
UpDown:
  Gui, Submit, NoHide
  hr := (EditMinutes/60)
  GuiControl, Text, EditHours, %hr%  
Return   ;end of sub: UpDown:
Exit:
  ExitApp  
Return   ;end of sub: Exit:
GuiClose:
  Gui Cancel
Return   ;end of sub: GuiClose
IniCheck:
  IfNotExist, ini.ini
  {
    IniWrite, 0, ini.ini, OPTIONS, includesub
    IniWrite, 45, ini.ini, OPTIONS, interval
    IniWrite, 1, ini.ini, OPTIONS, position
    IniWrite, regular, ini.ini, OPTIONS, state
    IniWrite, Empty, ini.ini, OPTIONS, wallpaperfile
    IniWrite, Empty, ini.ini, OPTIONS, wallpaperfolder
  Loop, 12
    {
      IniWrite, Empty, ini.ini, 24HR, %A_Index%pm
    }
  Loop, 12
    {
      IniWrite, Empty, ini.ini, 24HR, %A_Index%am
    }
  }
Return   ;end of sub: IniCheck
IniRead:
  IniRead, Includesub, ini.ini, OPTIONS, includesub
  IniRead, UpdateTime, ini.ini, OPTIONS, interval
  ut = %UpdateTime%
  IniRead, State, ini.ini, OPTIONS, state
  IniRead, position, ini.ini, OPTIONS, position
  if position = 1
    sOpt  := "CENTER"
  if position = 2
    sOpt  := "TILE"
  if position = 3    
    sOpt  := "STRETCH"
  if position = 4    
    sOpt  := "MAX"
  if position = 
    sOpt  := "CENTER"
  IniRead, wallfolder, ini.ini, OPTIONS, wallpaperfolder
  IniRead, setfile, ini.ini, OPTIONS, wallpaperfile
Return   ;end of sub: IniRead:
Options:
  Gui, Show,, Options
Return   ;end of sub: Options:
Pause:
  Menu, Tray, ToggleCheck, Pause Wallpaper Changer
  Pause, Toggle 
Return   ;end of sub: Pause:
Reload:
  Reload  
Return   ;end of sub: Reload:
SetWallpaper:
  RegRead, currentfile, HKEY_CURRENT_USER, Control Panel\Desktop, ConvertedWallpaper
  if sFile not in %currentfile%,"",ERROR,Empty
  {
    WPSTYLE_CENTER  := 0
    WPSTYLE_TILE    := 1
    WPSTYLE_STRETCH := 2
    WPSTYLE_MAX     := 3

COM_Init()
pad := COM_CreateObject("{75048700-EF1F-11D0-9888-006097DEACF9}", "{F490EB00-1240-11D1-9888-006097DEACF9}")

DllCall(NumGet(NumGet(1*pad)+28), "Uint", pad, "int64P", WPSTYLE_%sOpt%<<32|8, "Uint", 0)      ; SetWallpaperOptions
DllCall(NumGet(NumGet(1*pad)+20), "Uint", pad, "Uint", COM_Unicode4Ansi(wFile,sFile), "Uint", 0)      ; SetWallpaper
DllCall(NumGet(NumGet(1*pad)+12), "Uint", pad, "Uint", 7)            ; ApplyChanges

COM_Release(pad)
COM_Term()
  }
Return   ;end of sub: SetWallpaper:
StateHourly:
  Loop, 12
  {
      IniRead, %A_Index%pm, ini.ini, 24HR, %A_Index%pm
      var%A_Index% := (A_Hour - 12)
      if var%A_Index% = %A_Index%
				sFile := %A_Index%pm
  }
  Loop, 12
  {
      IniRead, %A_Index%am, ini.ini, 24HR, %A_Index%am
      var%A_Index% := (A_Hour - 12)
      if A_Hour = %A_Index%
				sFile := %A_Index%am
  }
  GoSub SetWallpaper
Return   ;end of sub: StateHourly
; Loop selected folder and choose a random file from it
StateRandom: 
  total = 0  ; http://www.autohotkey.com/forum/viewtopic.php?t=145 
  Loop, %wallfolder%\*.jpg, 0, %Includesub%
  {
        total += 1
  }
  Random, select, 1, %total%
  Loop, %wallfolder%\*.jpg, 0, %Includesub%
  {
        IfEqual, A_Index, %select%, Setenv, sFile, %A_LoopFileFullPath%
        if select = 0
        sFile = ERROR
  }
  Gosub, SetWallpaper ; Use the random file as wallpaper
Return   ;end of sub: StateRandom
TrayChooseFile:
  FileSelectFile, file, %A_MyComputer%
  if ErrorLevel = 0
  {
    IniWrite, regular, ini.ini, OPTIONS, state
    IniWrite, %file%, ini.ini, OPTIONS, wallpaperfile
    Reload
    }
Return   ;end of sub: TrayChooseFile
TrayChooseFolder:
  IniRead, folder, ini.ini, OPTIONS, wallpaperfolder
  if wallpaperfolder = ERROR
    wallpaperfolder = %A_MyDocuments% 
  FileSelectFolder, OutputVar, *%folder%, 3
  if ErrorLevel = 0
  {
    IniWrite, %OutputVar%, ini.ini, OPTIONS, wallpaperfolder
    Reload
  }
Return   ;end of sub: TrayChooseFolder
TrayEmptyLabel:
  
Return   ;end of sub: TrayEmptyLabel
TrayRegular:
  IniWrite, regular, ini.ini, OPTIONS, state
  Reload 
Return   ;end of sub: TrayFixed
TrayHourly:
  IniWrite, hourly, ini.ini, OPTIONS, state
  Reload
Return   ;end of sub: TrayHourly
TrayRandomFile:
  total = 0
  Loop, %wallfolder%\*.jpg,0, %Includesub%
  {
        total += 1
  }
  Random, select, 1, %total%
  Loop, %wallfolder%\*.jpg, 0, %Includesub%
  {
        IfEqual, A_Index, %select%, Setenv, file, %A_LoopFileFullPath%
  }
  IniWrite, random, ini.ini, OPTIONS, state
  Reload
Return   ;end of sub: TrayRandomFile
TrayMenu:
  if TrayIcon <> 0
  Menu, Tray, Icon, %trayIcon%,, 1
  Menu, Tray, Add, Set your wallpaper state under:, TrayEmptyLabel
  Menu, Tray, Add
  Menu, Tray, Add, Regular, TrayRegular
  if State = regular
    Menu, Tray, Check, Regular
  Menu, Tray, Add, Hourly, TrayHourly
  if State = Hourly
    Menu, Tray, Check, Hourly
  Menu, Tray, Add, Random (%ut% minutes), TrayRandomFile
  if State = Random
    Menu, Tray, Check, Random (%ut% minutes)
  Menu, Tray, Add
  Menu, Tray, Add, Pause Wallpaper Changer, Pause
  Menu, Tray, Add, Options..., Options
  Menu, Tray, Default, Options...
  Menu, Tray, Add, Choose a wallpaper folder, TrayChooseFolder
  Menu, Tray, Add, Choose a regular wallpaper, TrayChooseFile
  Menu, Tray, Add, Reload
  Menu, Tray, Add, Exit
  Menu, Tray, NoStandard
  Menu, Tray, Tip, Wallpaper state is:  %State%`rClick to see wallpaper options
  Menu, Tray, Color, FFFFFF
  Menu, Tray, Click, 1
Return   ;end of sub: TrayMenu
