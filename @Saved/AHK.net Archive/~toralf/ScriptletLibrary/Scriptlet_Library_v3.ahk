;Scriptlet Library with TreeView to group the code snippets
;by toralf
;requires AHK 1.0.44.09
;
;original by Rajat
;www.autohotkey.com/forum/viewtopic.php?t=2510

Version = 3
ScriptName = Scriptlet Library %Version%

/*
changes to version 2:
- complete rewritten
- added tray menu and icon
- tray icon allows to exit script
- treeview to show groups of scriptlets
- easy naming/saving handling, similar to IniFileCreator
- scriplets can change groups easily
- command line parameter "/dock hwnd" to dock GUI to upper left corner of hwnd
- remembers the gui size between starts
*/

GroupStartString = <---Group_
ScriptletStartString = <---Start_
ScriptletEndString = <---End_
DefaultGroupName = Misc
DefaultNewGroupName = New Group
DefaultNewScriptletName = Scriptlet
ScriptletNameIndex = 0

#SingleInstance force
SetWorkingDir, %A_SCRIPTDIR%
GoSub, BuildTrayMenu
GoSub, BuildGui

Loop, %0% {                       ;for each command line parameter
    next := A_Index + 1           ;get next parameters number, this is nessecary if parameter is number
    If (%A_Index% = "/dock")      ;check if known command line parameter exists
        param_dock := %next%      ;assign next command line parameter as value
;     Else If (%A_Index% = "/log")
;         param_log := %next%
  }
If param_dock {
    ControlClick, , %Gui1UniqueID%, , Middle
    ControlClick, , %Gui1UniqueID%, , Right
    Gui, 1:+ToolWindow
    GoSub,DockToWindow 
    Settimer, DockToWindow
  }
Return

DockToWindow:
  WinGetPos, EditorX, EditorY, , , ahk_id %param_dock%
  Gui, 1:Show, x%EditorX% y%EditorY% NoActivate
Return

BuildTrayMenu:
  ;location of icon file
  If ( A_OSType = "WIN32_WINDOWS" )  ; Windows 9x
      IconFile = %A_WinDir%\system\shell32.dll
  Else
      IconFile = %A_WinDir%\system32\shell32.dll

  ;tray menu
  Menu, Tray, Icon, %IconFile%, 45   ;icon for taskbar and for process in task manager
  Menu, Tray, Tip, %ScriptName%
  Menu, Tray, NoStandard
  Menu, Tray, Add, Exit, GuiClose
  Menu, Tray, Default, Exit
  Menu, Tray, Click, 1
Return

ReadDataFromIni:
  ;get ini file name
  SplitPath, A_ScriptName, , , , OutNameNoExt
  IniFile = %OutNameNoExt%.ini
  
  ;create default group
  Gui, 1: Default
  Group_ID := TV_Add(DefaultGroupName, "", "Sort")
  ListOfGroupNames = `n%DefaultGroupName%`n
  Default_Group_ID := Group_ID
  
  ;read data
  Loop, Read, %IniFile%
    {
      If (InStr(A_LoopReadLine,GroupStartString)=1) {
          ;get group name
          StringTrimLeft, GroupName, A_LoopReadLine, % StrLen(GroupStartString)
          Group_ID := TV_Add(GroupName, "", "Sort")
          ListOfGroupNames = %ListOfGroupNames%%GroupName%`n
      }Else If (InStr(A_LoopReadLine,ScriptletStartString)=1) {
          ;get scriptlet name
          StringTrimLeft, ScriptletName, A_LoopReadLine, % StrLen(ScriptletStartString)
          
          ;add scriptlet
          ID := TV_Add(ScriptletName,Group_ID,"Sort")
          ScriptletInProcess := True
          Scriptlet =
      }Else If (InStr(A_LoopReadLine,ScriptletEndString)=1) {
          ScriptletInProcess := False
          StringTrimRight, Scriptlet, Scriptlet, 1
          %ID%Scriptlet = %Scriptlet%
      }Else If ScriptletInProcess {
          Scriptlet = %Scriptlet%%A_LoopReadLine%`n
        }
    }
  ;check if default group is used
  If !TV_GetChild(Default_Group_ID){
      TV_Delete(Default_Group_ID)
      StringReplace, ListOfGroupNames, ListOfGroupNames, `n%DefaultGroupName%`n, `n
    } 
  
  StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
  GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
  
  ;get previous Gui Size
  IniRead, Gui1Pos, %IniFile%, Settings, Gui1Pos, %A_Space%
  IniRead, Gui1W, %IniFile%, Settings, Gui1W, %A_Space%
  IniRead, Gui1H, %IniFile%, Settings, Gui1H, %A_Space%
Return
  
BuildGui:
  Gui, 1:+Resize
  Gui, 1:Add, Button, Section vBtnAddGroup gBtnAddGroup, +
  Gui, 1:Add, Edit,  x+1 ys+1 w200 vEdtGroupName gEdtGroupName Disabled, 
  Gui, 1:Add, Button,  x+1 ys vBtnRemoveGroup gBtnRemoveGroup Disabled, -
  
  Gui, 1:Add, Button, x+40 ys vBtnAddScriptlet gBtnAddScriptlet Disabled, +
  Gui, 1:Add, Edit,  x+1 ys+1 w150 vEdtScriptletName gEdtScriptletName Disabled, 
  Gui, 1:Add, Button,  x+1 ys vBtnRemoveScriptlet gBtnRemoveScriptlet Disabled, -
  Gui, 1:Add, DropDownList, x+40 ys w150 vDdbScriptletInGroup gDdbScriptletInGroup Sort Disabled, 
  
  Gui, 1:Add, Button, ys vBtnCopyToClipboard gBtnCopyToClipboard Disabled, Copy to &Clipboard

  Gui, 1:Add, TreeView, xs Section w250 h500 vTrvScriptlets gTrvScriptlets
  GoSub, ReadDataFromIni
  ;select first scriptlet
  TV_Modify(TV_GetChild(TV_GetNext()), "Select")
  
  Gui, 1:Font, , Courier
  Gui, 1:Add, Edit, ys w500 h500 Multi T8 vEdtScriptletData gEdtScriptletData,
  Gui, 1:Show, %Gui1Pos%, %ScriptName%
  Gui, 1: +LastFound
  Gui1UniqueID := "ahk_id " . WinExist()
  ;restore old size
  WinMove, %Gui1UniqueID%, , , , %Gui1W%, %Gui1H%

  ;roll window up and down with right mouse click or mouse move into title
  GuiRolledUp := False
  WM_RButtonDOWN = 0x204
  OnMessage(WM_RBUTTONDOWN , "RollUpDownGui1")
  WM_MButtonDOWN = 0x207
  OnMessage(WM_MBUTTONDOWN , "ToggleOnTopGui1")
Return

TrvScriptlets:
  If TreeSelectionInProcess
      Return
  TreeSelectionInProcess := True
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If ParentID {     ;its a scriptlet
      TV_GetText(GroupName, ParentID)
      TV_GetText(ScriptletName, ID)
      GuiControl,1:ChooseString, DdbScriptletInGroup, %GroupName%
      GuiControl,1:, EdtScriptletName, %ScriptletName%
      GuiControl,1:, EdtScriptletData, % %ID%Scriptlet
      GuiControl,1: Enable, EdtScriptletData
      GuiControl,1: Enable, EdtScriptletName
      GuiControl,1: Enable, BtnRemoveScriptlet
      GuiControl,1: Enable, DdbScriptletInGroup
      GuiControl,1: Enable, BtnCopyToClipboard
  }Else{
      TV_GetText(GroupName, ID)
      GuiControl,1:, EdtScriptletName,
      GuiControl,1:, EdtScriptletData,
      GuiControl,1: Disable, EdtScriptletData
      GuiControl,1: Disable, EdtScriptletName
      GuiControl,1: Disable, BtnRemoveScriptlet
      GuiControl,1: Disable, DdbScriptletInGroup
      GuiControl,1: Disable, BtnCopyToClipboard
    }
  GuiControl,1:, EdtGroupName, %GroupName%
  
  GuiControl,1: Enable, BtnAddScriptlet
  GuiControl,1: Enable, BtnRemoveGroup
  GuiControl,1: Enable, EdtGroupName
  GuiControl,1: Enable, BtnSave
  TreeSelectionInProcess := False
Return

BtnAddGroup:
  Gui, 1: Default
  ;find group name that doesn't exist yet
  Loop
      If !InStr(ListOfGroupNames, "`n" . DefaultNewGroupName . " " . A_Index . "`n"){
          NewGroupNumber := A_Index
          Break
        }
  ;add new group
  GroupName := DefaultNewGroupName " " NewGroupNumber
  ID := TV_Add(GroupName,"","Select Vis")
  ListOfGroupNames = %ListOfGroupNames%%GroupName%`n
  StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
  GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
  GuiControl, 1:Focus, EdtGroupName
  sleep,20
  Send, +{End}
Return

EdtGroupName:
  ;check if new group name already exists
  GuiControlGet, EdtGroupName 
  If InStr(ListOfGroupNames, "`n" EdtGroupName "`n")
      Return

  ;get group id
  Gui, 1: Default
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If ParentID      ;its a scriptlet
      ID = %ParentID%
  
  ;replace old name with new one in list
  TV_GetText(GroupName, ID)  
  StringReplace, ListOfGroupNames, ListOfGroupNames, `n%GroupName%`n, `n%EdtGroupName%`n
  StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
  GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%

  ;change name in tree
  TV_Modify(ID, "", EdtGroupName) 
  TV_Modify(0, "Sort") 
Return

BtnRemoveGroup:
  Gui, 1: Default
  ;get group id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If ParentID      ;its a scriptlet
      ID = %ParentID%

  ;get group name
  TV_GetText(GroupName, ID)
  
  MsgBox, 4, Delete Scriptlet Group?,
    (LTrim
      Please confirm deletion of current scriptlet group:
      %GroupName%
      
      This will also remove all scriptlets in that group !!!
    )
  IfMsgBox, Yes
    {
      ;get first scriptlet in that group and loop over all its siblings
      ScriptletID := TV_GetChild(ID)
      Loop {
          If !ScriptletID
              break
          ;remove scriptlet from memory
          %ScriptletID%Scriptlet =
          ;get next sibling in that group
          ScriptletID := TV_GetNext(ScriptletID)
        }
      ;remove group
      TV_Delete(ID) 
      ;remove group name from list
      StringReplace, ListOfGroupNames, ListOfGroupNames, `n%GroupName%`n, `n
      StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
      GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
    }
Return

BtnAddScriptlet:
  Gui, 1: Default
  ;get group id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If ParentID      ;its a scriptlet
      ID = %ParentID%

  ;add new scriptlet
  ScriptletNameIndex++
  ScriptletName = %DefaultNewScriptletName% %ScriptletNameIndex%
  ID := TV_Add(ScriptletName,ID,"Sort Select Vis")
  %ID%Scriptlet =
  GuiControl, 1:Focus, EdtScriptletName
  sleep,20
  Send, +{End}
Return

EdtScriptletName:
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  GuiControlGet, EdtScriptletName 
  ;change name in tree
  TV_Modify(ID, "", EdtScriptletName) 
  TV_Modify(ID, "Sort") 
Return

BtnRemoveScriptlet:
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  ;get scriptlet name
  TV_GetText(ScriptletName, ID)
  
  MsgBox, 4, Delete Scriptlet?,
    (LTrim
      Please confirm deletion of current scriptlet:
      %ScriptletName%
    )
  IfMsgBox, Yes
    {
      ;remove scriptlet from memory
      %ID%Scriptlet =
      ;remove group
      TV_Delete(ID) 
    }
Return

DdbScriptletInGroup:
  If TreeSelectionInProcess
      Return
  TreeSelectionInProcess := True
  Gui, 1: Default
  ;get scriptlet id and name
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return
  TV_GetText(ScriptletName, ID)
  
  ;get new group ID
  GuiControlGet, DdbScriptletInGroup
  GroupID := TV_GetNext()
  Loop {
      If !GroupID
          Return
      TV_GetText(GrouptName, GroupID)
      If (GrouptName = DdbScriptletInGroup)    
          Break
      GroupID := TV_GetNext(GroupID)
    }
  ;create new key and delete old one
  NewID := TV_Add(ScriptletName,GroupID, "Sort Select Vis")
  %NewID%Scriptlet := %ID%Scriptlet
  TV_Delete(ID)
  %ID%Scriptlet =
  TreeSelectionInProcess := False
Return

EdtScriptletData:
  If TreeSelectionInProcess
      Return
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  GuiControlGet, EdtScriptletData
  %ID%Scriptlet = %EdtScriptletData%
Return

BtnCopyToClipboard:
  GuiControlGet, EdtScriptletData
  Clipboard = %EdtScriptletData%
  Send, {Rbutton}
Return

GuiEscape:
GuiClose:
  If GuiRolledUp {
      GuiControl, 1:Move, TrvScriptlets, h%TrvScriptletsH%
      Gui, 1:Show, AutoSize
    }
  FileDelete, %IniFile%
  WinGetPos, PosX, PosY, SizeW, SizeH, %Gui1UniqueID%
  IniWrite, x%PosX% y%PosY% , %IniFile%, Settings, Gui1Pos
  IniWrite, %SizeW% , %IniFile%, Settings, Gui1W
  IniWrite, %SizeH% , %IniFile%, Settings, Gui1H
  FileAppend, `n`n, %IniFile%
  
  ID = 0
  Gui, 1: Default
  ScriptletString = 
  Loop {
      ID := TV_GetNext(ID, "Full")
      If not ID
        break
      TV_GetText(Name, ID)
      ParentID := TV_GetParent(ID)
      If ParentID { ;it's a scriptlet
          Scriptlet := %ID%Scriptlet
          ScriptletString = %ScriptletString%%ScriptletStartString%%Name%`n%Scriptlet%`n%ScriptletEndString%%Name%`n`n`n
      }Else
          ScriptletString = %ScriptletString%%GroupStartString%%Name%`n

      ;remove the `n if no extra line break should be in the INI file
      If (Mod(A_index, 100)=0) {
          FileAppend, %ScriptletString%`n, %IniFile%
          ScriptletString =
        }
    }
  If ScriptletString
      FileAppend, %ScriptletString%`n, %IniFile%
  ExitApp
Return

RollUpDownGui1(wParam, lParam, msg, hwnd) {
    global Gui1UniqueID, GuiRolledUp
    static PosX, PosY, PosW, PosH
    WM_NCMouseMove = 0xA0
    If ( GuiRolledUp and msg = WM_NCMouseMove) {
        GuiControl, 1:Move, EdtScriptletData, x%PosX% y%PosY% w%PosW% h%PosH%
        Gui, 1:Show, AutoSize
        OnMessage(WM_NCMouseMove , "")
    }Else If ( !GuiRolledUp and msg = "0x204"){
        GuiControlGet, Pos, 1:Pos, EdtScriptletData  
        WinMove, %Gui1UniqueID%,,,,280, 30
        OnMessage(WM_NCMouseMove , "RollUpDownGui1")
    }Else
        Return
    GuiRolledUp := not GuiRolledUp
  }

ToggleOnTopGui1(wParam, lParam, msg, hwnd){
    global Gui1UniqueID
    WinGet, ExStyle, ExStyle, %Gui1UniqueID%
    WinGetTitle, CurrentTitle , %Gui1UniqueID%
    If (ExStyle & 0x8){ ; 0x8 is WS_EX_Topmost
        Gui, 1: -AlwaysOnTop
        StringTrimRight, CurrentTitle, CurrentTitle, 8
        WinSetTitle, %Gui1UniqueID%, , %CurrentTitle%
    }Else{
        Gui, 1: +AlwaysOnTop
        WinSetTitle, %Gui1UniqueID%, , %CurrentTitle% - *AOT*
      }
  }

GuiSize:
  ;       ControlName         ,  xwyh , [ x     w     y     h     or True for MoveDraw]
  Anchor("EdtGroupName"       , " w  ", " 1   , 0.5 ,     ,     ")
  Anchor("BtnRemoveGroup"     , "x   ", " 0.5 , 1   ,     ,     ")
  Anchor("BtnAddScriptlet"    , "x   ", " 0.5 , 1   ,     ,     ")
  Anchor("EdtScriptletName"   , "xw  ", " 0.5 , 0.25,     ,     ")
  Anchor("BtnRemoveScriptlet" , "x   ", " 0.75,     ,     ,     ")
  Anchor("DdbScriptletInGroup", "xw  ", " 0.75, 0.25,     ,     ")
  Anchor("BtnCopyToClipboard" , "x   "                           )
  Anchor("TrvScriptlets"      , " w h", "     , 0.5 ,     , 1   ")
  Anchor("EdtScriptletData"   , "xw h", " 0.5 , 0.5 ,     , 1   ")
Return

Anchor(ctrl, a, d = false) { 
    static pos
    sig = `n%A_Gui%:%ctrl%=

    If (d = 1){
        draw = Draw
        d=1,1,1,1
    }Else If (d = 0)
        d=1,1,1,1
    StringSplit, q, d, `,

    If !InStr(pos, sig) {
      GuiControlGet, p, Pos, %ctrl%
      pos := pos . sig . px - A_GuiWidth * q1 . "/" . pw  - A_GuiWidth * q2 . "/"
        . py - A_GuiHeight * q3 . "/" . ph - A_GuiHeight * q4 . "/"
    }
    StringTrimLeft, p, pos, InStr(pos, sig) - 1 + StrLen(sig)
    StringSplit, p, p, /
    
    c = xwyh
    Loop, Parse, c
      If InStr(a, A_LoopField) {
        If A_Index < 3
          e := p%A_Index% + A_GuiWidth * q%A_Index%
        Else e := p%A_Index% + A_GuiHeight * q%A_Index%
        m = %m%%A_LoopField%%e%
      }
    
    GuiControl, %A_Gui%:Move%draw%, %ctrl%, %m%
  }
