Version = 8
ScriptName = IniFileCreator %Version%
/*
A GUI to create ini files easily
that can be used with the IniSettingsEditor function.

by toralf
www.autohotkey.com/forum/viewtopic.php?p=69534#69534

Tested OS: Windows XP Pro SP2
AHK_version= 1.0.44.09     ;(http://www.autohotkey.com/download/)
Language: English
Date: 2006-08-25

features:
=========
- compatible with IniSettingsEditor function
- create and save Ini files with only a few mouse clicks
- see Ini file structured with a tree of sections and keys
- set easily "special" properties for each key and section
- test Ini file as it will be seen with the function in your app

When you run the program, most options are self explanatory. 

KeyType Options: 
These are options for the "Key Type" menu item. 
You may insert any options you would normally use in ahk for that "key type" 
Example, If you choose "text" for your "key type" you can put Limit5 in
the "KeyType Options" to limit the amount of characters for the text to 5. 


ideas:
======

change history:
===============
changes since version 7
- requires "../Anchor/Anchor_v3.3.ahk" => http://www.autohotkey.com/forum/viewtopic.php?t=4348
- added context menu to change resize behavior (needs restart)
- changed text above the format field to be more descriptive
- added tooltips (default on)
- added context menu to turn tooltips on/off (saved between sessions)
- improved handling of IniFileNeedsSave, but not solved completely (sometimes wrong warning even that nothing changed)
changes since version 6
- possibility to copy a section with all its keys (checkbox in add gui)
- a section or key can be moved up/down in its siblings in the tree
- for integer key type nothing and integer numbers are allowed as value
- for float key type nothing, a dot ("."), integer and float numbers are allowed as value
- improved speed of reading and writing ini files (and thus also to open the test gui)
changes since 5:
- add key type "checkbox" with custom control name
- added key field options (will only apply in Editor window)
- whole sections can be set hidden
- reorganized code in Editor and Creator
- some fixes and adjustments
changes since 1.4
- Creator and Editor GUIs are resizeable (thanks Titan). The shortened Anchor function
   is added with a long name, to avoid naming conflicts and avoid dependencies.
- switched from 1.x version numbers to full integer version numbers
- requires AHK version 1.0.44.09
*/

#SingleInstance force

;set working dir, in case this script is called from some other script in a different dir 
SetWorkingDir, %A_ScriptDir%
SplitPath, A_Scriptname, , , , OutNameNoExt, 
IniFile = %OutNameNoExt%.ini
IniFileNeedsSave := False

GoSub, BuildGui

KeyDataList = Type,Typ,For,Val,ChkN,Def,Hid,Opt,Des
SectionDataList = Type,Hid,Des

Return
;end of auto-exec

#Include Func_IniSettingsEditor_v6.ahk

BuildGui:
  ;create context menu
  ;resize all controls
  IniRead, ResizeAllControls, %IniFile%, General, ResizeAllControls, 0
  Menu, ContextMenu , Add, Resize All Controls (needs to restart), ToggleResizeAllControls
  If ResizeAllControls
      Menu, ContextMenu, ToggleCheck, Resize All Controls (needs to restart)

  ;tooltips
  IniRead, ShowToolTips, %IniFile%, General, ShowToolTips, 1
  Menu, ContextMenu , Add, Show Tooltips, ToggleShowToolTips
  If ShowToolTips {
      Menu, ContextMenu, ToggleCheck, Show Tooltips
      OnMessage(0x200,"WM_MOUSEMOVE")
    }

  ;create GUI 
  Gui, 1:+Default +Resize +LabelGuiIniFileCreator
  Gui, 1:Add, Button, vBtnOpenINI gBtnOpenINI Section x15 y60 , Open Ini
  BtnOpenINI_TT = Open an existing ini to edit it
  Gui, 1:Add, Button, vBtnEmptyIni gBtnEmptyIni x+1 ys Disabled, Empty Ini
  BtnEmptyIni_TT = Start a new ini from scratch
  Gui, 1:Add, Button, vBtnMoveItemUp gBtnMoveItem x+1 ys Disabled, Up
  BtnMoveItemUp_TT = move selected section or key one position up
  Gui, 1:Add, Button, vBtnMoveItemDown gBtnMoveItem x+1 ys Disabled, Down
  BtnMoveItemDown_TT =  move selected section or key one position down
  Gui, 1:Add, TreeView, vTrvSelect gTrvSelect xs y+2 w180 h240 0x400
  TrvSelect_TT = selected section or key to modify them
  Gui, 1:Add, Button, vBtnAdd gBtnAdd Section xs y+2, +
  BtnAdd_TT = add or copy section or key to ini
  Gui, 1:Add, Edit, vEdtName gNameChanged x+1 ys+1 w145 Disabled,
  EdtName_TT = change the name of section or key
  Gui, 1:Add, Button, vBtnRemove gBtnRemove x+1 ys Disabled, -
  BtnRemove_TT = remove selected section or key from ini

  Gui, 1:Add, DropDownList, vDdlKeyType gDdlKeyType Choose9 x215 y85 w80 r10 Disabled
              ,Text|Integer|Float|File|Folder|DateTime|Hotkey|DropDown|Checkbox
  DdlKeyType_TT = choose a specific key type to limit input
  Gui, 1:Add, Edit, vEdtKeyFormat gChangedField x300 y85 w255 Disabled,
  EdtKeyFormat_TT = specify a predifined format or list of choices
  Gui, 1:Add, Edit, vEdtKeyValue gChangedField x215 y135 w340 Disabled,
  EdtKeyValue_TT = specify an initial value
  Gui, 1:Add, CheckBox, vChkKeyDefault gChangedField x255 y115 Disabled, Use as default
  ChkKeyDefault_TT = set inital value as default
  Gui, 1:Add, CheckBox, vChkKeyHidden gChangedField x350 y115 Disabled, Hidden
  ChkKeyHidden_TT = hide this section or key from user
  Gui, 1:Add, Button, vBtnBrowseKeyValueEditor gBtnBrowseKeyValueEditor x505 y110 Hidden, B&rowse
  BtnBrowseKeyValueEditor_TT = browse to file or folder
  Gui, 1:Add, DateTime, vDatKeyValue gChangedField x215 y135 w340 Hidden,
  DatKeyValue_TT = specify an initial value
  Gui, 1:Add, Hotkey, vHotKeyValue gChangedField x215 y135 w340 Hidden,
  HotKeyValue_TT = specify an initial value
  Gui, 1:Add, DropDownList, vDdlKeyValue gChangedField x215 y135 w340 r10 Hidden,
  DdlKeyValue_TT = select an initial value
  Gui, 1:Add, CheckBox, vChkKeyValue gChangedField Check3 x215 y138 w25 Hidden,
  ChkKeyValue_TT = specify the initial state
  Gui, 1:Add, Edit, vEdtChkName gChangedField x240 y135 w315 Hidden,
  EdtChkName_TT = specify a name for the checkbox
  Gui, 1:Add, Edit, vEdtKeyOptions gChangedField x300 y162 w255 Disabled,
  EdtKeyOptions_TT = add gui control options for the key type`nsee "GUI Control Types" in manual
  Gui, 1:Add, Edit, vEdtKeyDes gChangedField x215 y210 w340 h75 Disabled,
  EdtKeyDes_TT = add a description to help users to fill correct data
  Gui, 1:Add, Edit, vEdtIniFile gEdtIniFile x265 y296 w265,
  EdtIniFile_TT = specify an ini file this data is written to
  Gui, 1:Add, Button, vBtnBrowseIniFile gBtnBrowseIniFile x535 y295, ...
  BtnBrowseIniFile_TT = browse to an ini file
  Gui, 1:Add, Button, vBtnTestIni gBtnTestIni x150 y360 w130 h30 Disabled, Test Ini
  BtnTestIni_TT = show current ini how it will look like for the user
  Gui, 1:Add, Button, vBtnSaveToFile gBtnSaveToFile x290 y360 w130 h30 Disabled, Save to file
  BtnSaveToFile_TT = save current ini data to file

  Gui, 1:Add, GroupBox, vGrb x4 y48 w560 h305 , 
  Gui, 1:Font, Bold 
  Gui, 1:Add, Text, vTxtType x215 y65, Key Type 
  Gui, 1:Add, Text, vTxtFormat x300 y65 w255, Format or List of Choices 
  Gui, 1:Add, Text, vTxtValue x215 y115, Value 
  Gui, 1:Add, Text, vTxtOptions x215 y165, Field Options 
  Gui, 1:Add, Text, vTxtDescription x215 y190, Description 
  Gui, 1:Add, Text, vTxtIniFile x215 y300, Ini File 
  Gui, 1:Font, S16 CDefault Bold, Verdana 
  Gui, 1:Add, Text, vTxtHeadline x45 y13 w480 h35 +Center, Create Ini file - Settings

  ;show Gui and get UniqueID
  IniRead, GuiPos, %IniFile%, General, GuiPos, % ""
  Gui, 1:Show, %GuiPos%, %ScriptName% - Create Ini file for IniSettingsEditor 
  Gui, 1:+LastFound
  GuiID := WinExist() 
  OnMessage(0x24, "WM_GETMINMAXINFO")
Return

ToggleShowToolTips:
  ShowToolTips := not ShowToolTips
  Menu, ContextMenu, ToggleCheck, Show Tooltips
  If ShowToolTips
      OnMessage(0x200,"WM_MOUSEMOVE")
  Else
      OnMessage(0x200,"")
Return

;show tooltips after 1 second for 2.5 second when user moves mouse on a button 
WM_MOUSEMOVE(wParam, lParam, msg, hwnd) { 
    global ToolTipPrevControl
    If (A_GuiControl <> ToolTipPrevControl) { 
        ToolTipPrevControl := A_GuiControl
        If (%ToolTipPrevControl%_TT <> "")  ;??? array in function
            SetTimer, ShowToolTip, 1000
      } 
  } 
ShowToolTip:
  SetTimer, ShowToolTip, Off
  ToolTip, % %ToolTipPrevControl%_TT
  Sleep, 2500
  ToolTip  
Return

GuiIniFileCreatorContextMenu:
  Menu, ContextMenu, Show
Return

ToggleResizeAllControls:
  ResizeAllControls := not ResizeAllControls
  Menu, ContextMenu, ToggleCheck, Resize All Controls (needs to restart)
  GoSub, GuiIniFileCreatorClose
Return

BtnMoveItem:
  GuiControl, Disable, %A_GuiControl%
  Gui, 1: Default
  SelectedID := TV_GetSelection()
  PrevPrevID := TV_GetPrev(TV_GetPrev(SelectedID)) 
  NextID := TV_GetNext(SelectedID) 
  ParentID := TV_GetParent(SelectedID)
  If (A_GuiControl = "BtnMoveItemUp" AND PrevPrevID = 0)
      AddAtID = First
  Else If (A_GuiControl = "BtnMoveItemUp" AND PrevPrevID)
      AddAtID = %PrevPrevID%
  Else If (A_GuiControl = "BtnMoveItemDown" AND NextID)
      AddAtID = %NextID%
  Else
      Return
      
  ;get old key or section name
  TV_GetText(Name, SelectedID) 
  If ParentID { ;move key
      ;create new key
      ID := TV_Add(Name,ParentID,"Select Vis " AddAtID)
      ;copy data from old key to new one and empty old array
      Loop, Parse, KeyDataList, `,
        {
        	%ID%%A_LoopField% := %SelectedID%%A_LoopField%
        	%SelectedID%%A_LoopField% =
        }
  }Else{        ;move section
      ;create new section
      SectionID := TV_Add(Name,"","Select Vis " AddAtID)
      ;copy data from old section to new section and empty old array
      Loop, Parse, SectionDataList, `,
        {
        	%SectionID%%A_LoopField% := %SelectedID%%A_LoopField%
        	%SelectedID%%A_LoopField% =
        }
      
      ;get first child and loop over all childs to copy them
      KeyID := TV_GetChild(SelectedID)
      Loop {
          If !KeyID
              break
          
          ;create key with data from old key
          TV_GetText(Name,KeyID)
          ID := TV_Add(Name,SectionID)
          Loop, Parse, KeyDataList, `,
            {
            	%ID%%A_LoopField% := %KeyID%%A_LoopField%
            	%KeyID%%A_LoopField% =
            }
          
          ;get next sibling in old section
          KeyID := TV_GetNext(KeyID)
        }
    }  
  ;remove old key or section
  TV_Delete(SelectedID)
  GuiControl, Enable, %A_GuiControl%
  IniFileNeedsSave := True
Return

BtnOpenINI:
  ;turn off tooltips, speeds up loading
  OnMessage(0x200,"")

  Gui, 1: Default
  
  ;warn user, if data isn't saved
  If (TV_GetCount() and IniFileNeedsSave) {
      MsgBox, 292, Open Ini File,
        (LTrim
           There are settings that aren't saved.
           Are you sure you want to open a new file?
           All current settings will be removed.
           Press Yes to continue.
        ) 
      IfMsgBox, No
          Return
    }
  IniFileNeedsSave := False

  ;empty all arrays, so that no old data is available and no memory leak
  ID = 0
  If TV_GetCount()
      Loop {
          ID := TV_GetNext(ID, "Full")
          If not ID
            break
          If (%ID%Type = "Section")
              Loop, Parse, SectionDataList, `,
                	%ID%%A_LoopField% =
          Else
              Loop, Parse, KeyDataList, `,
                	%ID%%A_LoopField% =
        }
        
  ;remove old tree
  GuiControl, -Redraw, TrvSelect 
  TV_Delete()
  GuiControl, +Redraw, TrvSelect 
  
  ;get new ini filename
  GuiControlGet, EdtIniFile
  SelectFile("EdtIniFile", EdtIniFile, "to open","3","Ini files (*.ini)")
  GuiControlGet, EdtIniFile

  ;read data from ini file, build tree and store values and description in arrays 
  GuiControl, -Redraw, TrvSelect 
  Loop, Read, %EdtIniFile% 
    { 
      CurrLine = %A_LoopReadLine% 
      CurrLineLength := StrLen(CurrLine) 
  
      ;blank line 
      If CurrLine is space 
          Continue 

      ;description (comment) line 
      If ( InStr(CurrLine,";") = 1 ){
          StringLeft, chk2, CurrLine, % CurrLength + 2 
          StringTrimLeft, Des, CurrLine, % CurrLength + 2 
          ;description of key
          If ( %CurrID%Type = "Key" AND ";" CurrKey A_Space = chk2){ 
              ;handle key types  
              If ( InStr(Des,"Type: ") = 1 ){ 
                  StringTrimLeft, Typ, Des, 6 
                  Typ = %Typ% 
                  ;handle format or list  
                  If (InStr(Typ,"DropDown ") = 1) {
                      StringTrimLeft, Format, Typ, 9
                      %CurrID%For = %Format%
                      Typ = DropDown
                  }Else If (InStr(Typ,"DateTime") = 1) {
                      StringTrimLeft, Format, Typ, 9
                      If Format is space
                          Format = dddd MMMM d, yyyy HH:mm:ss tt 
                      %CurrID%For = %Format%
                      Typ = DateTime
                    }
                  ;set type
                  %CurrID%Typ := Typ 
                  Des = 
              ;handle default value
              }Else If ( InStr(Des,"Default:") = 1 ){ 
                  %CurrID%Def = 1 
                  Des =
              ;handle custom options  
              }Else If ( InStr(Des,"Options: ") = 1 ){ 
                  StringTrimLeft, Opt, Des, 9 
                  %CurrID%Opt = %Opt%
                  Des =
              ;handle hidden keys
              }Else If ( InStr(Des,"Hidden:") = 1 ){  
                  %CurrID%Hid = 1 
                  Des = 
              ;handle checkbox name
              }Else If ( InStr(Des,"CheckboxName: ") = 1 ){  
                  StringTrimLeft, ChkN, Des, 14 
                  %CurrID%ChkN = %ChkN%
                  Des = 
                } 
              ;set description
              %CurrID%Des := %CurrID%Des "`n" Des 
          ;description of section 
          } Else If ( %CurrID%Type = "Section" AND ";" CurrSec A_Space = chk2 ) 
              ;set description
              %CurrID%Des := %CurrID%Des "`n" Des 
              
          ;remove leading and trailing whitespaces and new lines
          If ( InStr(%CurrID%Des, "`n") = 1 )
              StringTrimLeft, %CurrID%Des, %CurrID%Des, 1  
          Continue 
        } 
  
      ;section line 
      If ( InStr(CurrLine, "[") = 1 And InStr(CurrLine, "]", "", 0) = CurrLineLength) { 
          ;extract section name
          StringTrimLeft, CurrSec, CurrLine, 1 
          StringTrimRight, CurrSec, CurrSec, 1
          CurrSec = %CurrSec% 
          CurrLength := StrLen(CurrSec)  ;to easily trim name off of following comment lines
          
          ;add to tree
          CurrSecID := TV_Add(CurrSec)
          CurrID = %CurrSecID%
          %CurrID%Type = Section
          %CurrID%Hid = 0
          Continue 
        } 
  
      ;key line 
      Pos := InStr(CurrLine,"=") 
      If ( Pos AND CurrSecID ){ 
          ;extract key name and its value
          StringLeft, CurrKey, CurrLine, % Pos - 1 
          StringTrimLeft, CurrVal, CurrLine, %Pos% 
          CurrKey = %CurrKey%             ;remove whitespaces
          CurrVal = %CurrVal% 
          CurrLength := StrLen(CurrKey)
          
          ;add to tree and store value
          CurrID := TV_Add(CurrKey,CurrSecID) 
          %CurrID%Val := CurrVal
          %CurrID%Type = Key
          
          ;set default values
          %CurrID%Typ = Text
          %CurrID%Def = 0
          %CurrID%Hid = 0
        } 
    } 

  ;select first key of first section and expand section
  TV_Modify(TV_GetChild(TV_GetNext()), "Select")
  GuiControl, +Redraw, TrvSelect 

  ;turn tooltips back on 
  If ShowToolTips
      OnMessage(0x200,"WM_MOUSEMOVE")
Return

TrvSelect:
  If (A_GuiEvent = "S"){
      TrvSelectInProgress := True
      Old_IniFileNeedsSave := IniFileNeedsSave
      CurrentSel := A_EventInfo
      TV_GetText(Name, CurrentSel)
      GuiControl, ,EdtName, %Name%
      If (%CurrentSel%Type = "Section") {
          GuiControl, ChooseString, DdlKeyType, Text
          GoSub, DdlKeyType
          GuiControl, , EdtKeyFormat, 
          GuiControl, , EdtKeyValue, 
          GuiControl, , DatKeyValue, 
          GuiControl, , HotKeyValue, 
          GuiControl, , DdlKeyValue, |
          GuiControl, , ChkKeyValue, 0
          GuiControl, , EdtChkName, 

          GuiControl, , ChkKeyDefault, 0
          GuiControl, , ChkKeyHidden, % %CurrentSel%Hid
          GuiControl, , EdtKeyOptions,
          GuiControl, , EdtKeyDes, % %CurrentSel%Des
          SelectionIsSection := True
      }Else{
          FillGuiWithData(CurrentSel)
          SelectionIsSection := False
        }
      ;de-/activate controls depending if section or key is selected    
      Controls = DdlKeyType,EdtKeyValue,DatKeyValue,HotKeyValue,DdlKeyValue,ChkKeyValue,EdtChkName,ChkKeyDefault,EdtKeyOptions
      Loop, Parse, Controls, `,
        	GuiControl, Disable%SelectionIsSection%, %A_LoopField%
      
      ;activate controls on first selection, which means a tree is there and controls have meaning
      Controls = BtnEmptyIni,BtnMoveItemUp,BtnMoveItemDown,EdtName,BtnRemove,EdtKeyDes,BtnTestIni,ChkKeyHidden
      Loop, Parse, Controls, `,
        	GuiControl, Enable, %A_LoopField%
        IniFileNeedsSave := True
      IniFileNeedsSave := Old_IniFileNeedsSave   ;no change in state just by selection 
      TrvSelectInProgress := False
    }
Return

FillGuiWithData(ID){
    GuiControl, ChooseString, DdlKeyType, % %ID%Typ
    GoSub,DdlKeyType 
    GuiControl, , EdtKeyFormat, % %ID%For
    GuiControl, , EdtKeyValue, % %ID%Val
    GuiControl, , DatKeyValue, % %ID%Val
    GuiControl, , HotKeyValue, % %ID%Val
    GuiControl, , DdlKeyValue, % "|" %ID%For
    GuiControl, ChooseString, DdlKeyValue, % %ID%Val
    If (%ID%Typ = "CheckBox"){
        GuiControl, , ChkKeyValue, % %ID%Val
        GuiControl, , EdtChkName, % %ID%ChkN
      }
    GuiControl, , ChkKeyDefault, % %ID%Def
    GuiControl, , ChkKeyHidden, % %ID%Hid
    GuiControl, , EdtKeyOptions,  % %ID%Opt
    GuiControl, , EdtKeyDes, % %ID%Des
  }

NameChanged:
  If TrvSelectInProgress
      Return
  GuiControlGet, EdtName 
  TV_Modify(CurrentSel, "", EdtName)
  IniFileNeedsSave := True
Return

BtnRemove:
  Gui, 1: Default
  SelectedID := TV_GetSelection()
  TV_GetText(Name,SelectedID)
  Type := %SelectedID%Type
  MsgBox, 292, Delete %Type% "%Name%",
    (LTrim
       Are you sure you want to delete the %Type% "%Name%"?
       In case of sections all keys will be removed as well.
    ) 
  IfMsgBox, Yes
      TV_Delete(SelectedID)
  IniFileNeedsSave := True
Return

DdlKeyType:
  IniFileNeedsSave := True
  GuiControlGet, DdlKeyType
  ID := TV_GetSelection()
  %ID%Typ = %DdlKeyType%
  If DdlKeyType in File,Folder
      GuiControl, Show, BtnBrowseKeyValueEditor
  Else
      GuiControl, Hide, BtnBrowseKeyValueEditor
  
  If (DdlKeyType = "DateTime") {
      ControlInUse = DatKeyValue
      GuiControl, Enable, EdtKeyFormat 
  }Else If (DdlKeyType = "Hotkey") {
      ControlInUse = HotKeyValue
      GuiControl, Disable, EdtKeyFormat 
  }Else If (DdlKeyType = "DropDown") {
      ControlInUse = DdlKeyValue
      GuiControl, Enable, EdtKeyFormat 
  }Else If (DdlKeyType = "CheckBox") {
      ControlInUse = ChkKeyValue
      GuiControl, Disable, EdtKeyFormat 
  }Else {
      ControlInUse = EdtKeyValue
      GuiControl, Disable, EdtKeyFormat 
    }
  ;show/hide controls based on type
  Controls = DatKeyValue,HotKeyValue,DdlKeyValue,ChkKeyValue,EdtKeyValue
  Loop, Parse, Controls, `,
     	GuiControl, % iif(A_LoopField = ControlInUse,"Show","Hide"), %A_LoopField%

  ;show browse button for files and folders
  If (DdlKeyType = "CheckBox")
      GuiControl, Show, EdtChkName
  Else
      GuiControl, Hide, EdtChkName

  ;show browse button for files and folders
  If (DdlKeyType = "File" OR DdlKeyType = "Folder")
      GuiControl, Show, BtnBrowseKeyValueEditor
  Else
      GuiControl, Hide, BtnBrowseKeyValueEditor

  ;activate format field for datetime and dropdown fieled
  If (DdlKeyType = "DateTime" OR DdlKeyType = "DropDown")
      GuiControl, Enable, EdtKeyFormat
  Else
      GuiControl, Disable, EdtKeyFormat
  
  ;change title of format field for datetime and dropdown fieled 
  If (DdlKeyType = "DateTime")
      GuiControl, Text , TxtFormat, Format (e.g. dddd MMMM d, yyyy hh:mm:ss)
  Else If ( DdlKeyType = "DropDown")
      GuiControl, Text , TxtFormat, List of Choices (pipe-delimited)
  Else
      GuiControl, Text , TxtFormat, Format or List of Choices 
Return

ChangedField:
  If TrvSelectInProgress
      Return
  ;save setting in array
  Gui, 1:Submit, NoHide
  ID := TV_GetSelection()
  IniFileNeedsSave := True
  %ID%Des = %EdtKeyDes%
  %ID%Hid = %ChkKeyHidden%
  If (%ID%Type = "Key") {
      %ID%For = %EdtKeyFormat%
      %ID%Opt = %EdtKeyOptions%
      %ID%Def = %ChkKeyDefault%
      Val := %ControlInUse%
      ;consistency check if type is integer or float
      If (DdlKeyType = "Integer")
        If Val is not space
          If Val is not Integer
            {
              GuiControl, , %ControlInUse%, %OldVal%
              Return
            }
   
      If (DdlKeyType = "Float")
        If Val is not space
          If Val is not Integer
            If (Val <> ".")
              If Val is not Float
                {
                  GuiControl, , %ControlInUse%, %OldVal%
                  Return
                }
      %ID%Val = %Val%
      If DdlKeyType in DateTime,DropDown
        {
          GuiControl, Text, DatKeyValue, %EdtKeyFormat%
          GuiControl, , DdlKeyValue, |%EdtKeyFormat%
          GuiControl, ChooseString, DdlKeyValue, %DdlKeyValue%
        }                
      If (DdlKeyType = "Checkbox")
          %ID%ChkN = %EdtChkName%
      OldVal = %Val%    
    } 
Return

EdtIniFile:
  GuiControlGet, EdtIniFile
  If EdtIniFile is space
     	GuiControl, Disable, BtnSaveToFile
 	Else
     	GuiControl, Enable, BtnSaveToFile
Return

BtnTestIni:
  WriteSettingsToFile(IniFile)
  IniSettingsEditor("Test Ini", IniFile, 1, 1)
  FileDelete, %IniFile%  
Return

BtnSaveToFile:
  GuiControlGet, EdtIniFile
  GuiControl, Disable, BtnSaveToFile
  WriteInProgress := True
  WriteSettingsToFile(EdtIniFile)
  WriteInProgress := False
  GuiControl, Enable, BtnSaveToFile
  IniFileNeedsSave := False
Return

WriteSettingsToFile(Filename){
    FileDelete, %Filename%
    ID = 0
    Gui, 1: Default
    INIString = 
    Loop {
        ID := TV_GetNext(ID, "Full")
        If not ID
          break
        TV_GetText(Name, ID)
        If (%ID%Type = "Section"){
            INIString = %INIString%[%Name%]`n

            Des := %ID%Des
            Loop, Parse, Des, `n
                If A_LoopField is not space
                    INIString = %INIString%`;%Name% %A_LoopField%`n
        }Else{
            Val := %ID%Val
            INIString = %INIString%%Name%=%Val%`n

            Des := %ID%Des
            Loop, Parse, Des, `n
                If A_LoopField is not space
                  	INIString = %INIString%`;%Name% %A_LoopField%`n

            Typ := %ID%Typ
            For := %ID%For
           	INIString = %INIString%`;%Name% Type: %Typ% %For%`n

           	If %ID%Def 
                INIString = %INIString%`;%Name% Default: %Val%`n

            Opt := %ID%Opt
           	If Opt 
                INIString = %INIString%`;%Name% Options: %Opt%`n

            ChkN := %ID%ChkN
           	If ChkN 
                INIString = %INIString%`;%Name% CheckboxName: %ChkN%`n
          }
       	If %ID%Hid 
            INIString = %INIString%`;%Name% Hidden:`n

        ;remove the `n if no extra line break should be in the INI file
        If (Mod(A_index, 100)=0) {
            FileAppend, %INIString%`n, %Filename%
            INIString =
          }
      }
    If INIString
        FileAppend, %INIString%`n, %Filename%
    Return 1
  }
    
BtnEmptyIni:
  GoSub, CheckSaveState 
  Reload
Return 

GuiIniFileCreatorClose:
  GoSub, CheckSaveState 
  ExitApp
Return

CheckSaveState:
  ;turn off tooltips, speeds up loading
  OnMessage(0x200,"")
  MessageText =
  If WriteInProgress
      MessageText = Saving to file is still in progress!`n`n
  If IniFileNeedsSave {
      MsgBox, 292, Closing GUI, 
        (Ltrim
          %MessageText%The ini file you created hasn't been saved
          with the latest changes. Press Yes if you
          want to close this window. Press No to go
          back to the window.
        )
      ;turn tooltip back on
      If ShowToolTips
          OnMessage(0x200,"WM_MOUSEMOVE")
      IfMsgBox, No 
          Return
    }
  WinGetPos, PosX, PosY, SizeW, SizeH, ahk_id %GuiID%
  IniWrite, x%PosX% y%PosY%, %IniFile%, General, GuiPos
  IniWrite, %ResizeAllControls%, %IniFile%, General, ResizeAllControls
  IniWrite, %ShowToolTips%, %IniFile%, General, ShowToolTips
Return
  
BtnAdd:
  ;if tree is empty add a new section and don't show Gui
  If (TV_GetCount() = 0){
      ChkAddCopy := False
      GoSub, AddNewSectionToTree 
      GuiControl, 1:Focus, EdtName
  }Else{
      Gui, 1: +Disabled  
      ;open new GUI to add section or key
      Gui, 2: +Owner1 +ToolWindow
      Gui, 2:Add, Text, , Add new
      Gui, 2:Add, Radio, Section vRadAddChoice gChkAddCopy, Section or
      Gui, 2:Add, Radio, x+5 ys Checked gChkAddCopy, Key
      Gui, 2:Add, CheckBox, xm vChkAddCopy gChkAddCopy, Copy data from current 
      Gui, 2:Add, CheckBox, xm vChkAddCopyKeys Disabled Checked, Copy keys as well 
      Gui, 2:Add, Button, Section xm gBtnAddOK Default, Ok
      Gui, 2:Add, Button, ys gBtnAddCancel, Cancel 
      Gui, 2:Show, ,Add new section or key 
    }
Return

ChkAddCopy:
  Gui, 2:Submit,NoHide
  If (RadAddChoice = 1 AND ChkAddCopy = 1)
      GuiControl, 2:Enable, ChkAddCopyKeys
  Else
      GuiControl, 2:Disable, ChkAddCopyKeys
Return

BtnAddOK:
  Gui, 2:Submit,NoHide
  If (RadAddChoice = 1)
      GoSub, AddNewSectionToTree
  Else
      GoSub, AddNewKeyToTree
  GoSub, 2GuiClose 
  GuiControl, 1:Focus, EdtName
  IniFileNeedsSave := True
Return

;add section to tree
AddNewSectionToTree:
  Gui, 1: Default
  If ChkAddCopy {
      ;get section ID
      SID := TV_GetSelection()
      SelectedID := TV_GetParent(SID) ;get section in case a key is selected
      If not SelectedID               ;in case no key is selected
          SelectedID := SID

      ;copy section to new section
      TV_GetText(Name,SelectedID)
      SectionID := TV_Add(Name,"","Select Vis")
      Loop, Parse, SectionDataList, `,
        	%SectionID%%A_LoopField% := %SelectedID%%A_LoopField%
      
      ;copy keys from section to new section
      If ChkAddCopyKeys {
          ;get first key in old section and loop over all siblings
          KeyID := TV_GetChild(SelectedID)
          Loop {
              If !KeyID
                  break
              
              ;create key with data from old key
              TV_GetText(Name,KeyID)
              ID := TV_Add(Name,SectionID)
              Loop, Parse, KeyDataList, `,
                	%ID%%A_LoopField% := %KeyID%%A_LoopField%
              
              ;get next sibling in old section
              KeyID := TV_GetNext(KeyID)
            }
        }
  }Else{
      ;add new section
      SectionNumber++
      SectionID := TV_Add("New Section " SectionNumber,"","Select Vis")
      %SectionID%Type = Section
      %SectionID%Hid = 0
    }
Return

;get selected section and add key to tree
AddNewKeyToTree:
  Gui, 1: Default
  SelectedID := TV_GetSelection()
  SelectedSection := TV_GetParent(SelectedID)
  If not SelectedSection            ;in case a section is selected
      SelectedSection := SelectedID
  If not SelectedSection
      MsgBox, No Section selected. Please select one.
  Else {
      If ChkAddCopy {
          ;copy old key to new key
          TV_GetText(Name,SelectedID)
          ID := TV_Add(Name,SelectedSection,"Select Vis")
          Loop, Parse, KeyDataList, `,
            	%ID%%A_LoopField% := %SelectedID%%A_LoopField%
      }Else {
          ;add new key
          KeyNumber++
          ID := TV_Add("New Key " KeyNumber,SelectedSection,"Select Vis")
          %ID%Type = Key
          %ID%Def = 0
          %ID%Hid = 0

          ;make text the default key type.
          ;if this isn't specified the previous key type is kept for the new key
          GuiControl, ChooseString, DdlKeyType, Text
          GoSub,DdlKeyType 
        }
    }
Return

BtnAddCancel:
2GuiClose:
  Gui, 1: -Disabled
  Gui, 2:Destroy
Return

BtnBrowseIniFile:  
  ;get current value
  GuiControlGet, EdtIniFile
  ;select ini file
  SelectFile("EdtIniFile", EdtIniFile, "to save ini settings","S16","Ini files (*.ini)")
Return

SelectFile(Control, OldFile, Text, Options="", Extentions=""){
    Gui, 1:+OwnDialogs
    IfExist %A_ScriptDir%\%OldFile%
        StartFolder = %A_ScriptDir%
    Else IfExist %OldFile%
        SplitPath, OldFile, , StartFolder
    Else 
        StartFolder = 
    FileSelectFile, SelectedFile, %Options%, %StartFolder%, Select file %Text%, %Extentions%
    If SelectedFile {
        StringReplace, SelectedFile, SelectedFile, %A_ScriptDir%\
        GuiControl, 1: ,%Control%, %SelectedFile%
      }
  }

BtnBrowseKeyValueEditor: 
  ;get current value
  GuiControlGet, EdtKeyValue
  ;Select file or folder
  If (DdlKeyType = "File") 
      SelectFile("EdtKeyValue", EdtKeyValue, "")
  Else 
      SelectFolder("EdtKeyValue", EdtKeyValue,"")
  IniFileNeedsSave := True
Return

SelectFolder(Control, OldPath, Text, Options=3){
    Gui, 1:+OwnDialogs
    IfExist %A_ScriptDir%\%OldPath%
        StartFolder = %A_ScriptDir%\%OldPath%
    Else IfExist %OldPath%
        StartFolder = %OldPath%
    Else 
        StartFolder = 
    FileSelectFolder, SelectedDir, *%StartFolder% , %Options%, Select folder %Text%
    StringRight, LastChar, SelectedDir, 1
    If LastChar = \
	      StringTrimRight, SelectedDir, SelectedDir, 1
    If SelectedDir {
        StringReplace, SelectedDir, SelectedDir, %A_ScriptDir%\
        GuiControl, 1: ,%Control%, %SelectedDir%
      }
  }

  
#Include ../Anchor/Anchor_v3.3.ahk     ;http://www.autohotkey.com/forum/viewtopic.php?t=4348
GuiIniFileCreatorSize:
  If ResizeAllControls {
      ;       ControlName        , xwyh with factors [, True for MoveDraw]
      Anchor("TrvSelect"         ,"w0.5h")      
      Anchor("BtnAdd"            ,"y",true)  
      Anchor("EdtName"           ,"yw0.5")      
      Anchor("BtnRemove"         ,"x0.5y",true) 
      Anchor("DdlKeyType"        ,"x0.5")       
      Anchor("EdtKeyFormat"      ,"x0.5w0.5")       
      Anchor("EdtKeyValue"       ,"x0.5w0.5")       
      Anchor("ChkKeyDefault"     ,"x0.5",true)  
      Anchor("ChkKeyHidden"      ,"x0.5",true)  
      Anchor("BtnBrowseKeyValueEditor" ,"x",true) 
      Anchor("DatKeyValue"       ,"x0.5w0.5")       
      Anchor("HotKeyValue"       ,"x0.5w0.5")       
      Anchor("DdlKeyValue"       ,"x0.5w0.5")       
      Anchor("ChkKeyValue"       ,"x0.5")       
      Anchor("EdtChkName"        ,"x0.5w0.5")       
      Anchor("EdtKeyOptions"     ,"x0.5w0.5")     
      Anchor("EdtKeyDes"         ,"x0.5w0.5h")      
      Anchor("EdtIniFile"        ,"x0.5w0.5y")      
      Anchor("BtnBrowseIniFile"  ,"xy",true) 
      Anchor("BtnSaveToFile"     ,"x0.5y",true) 
      Anchor("BtnTestIni"        ,"x0.5y",true) 
      Anchor("Grb"               ,"wh",true) 
      Anchor("TxtType"           ,"x0.5")       
      Anchor("TxtFormat"         ,"x0.5w0.5")       
      Anchor("TxtValue"          ,"x0.5")       
      Anchor("TxtOptions"        ,"x0.5")       
      Anchor("TxtDescription"    ,"x0.5")       
      Anchor("TxtIniFile"        ,"x0.5y")
      Anchor("TxtHeadline"       ,"x0.5")
  }Else{
      ;       ControlName        , xwyh with factors [, True for MoveDraw]
      Anchor("TrvSelect"         ,"wh")      
      Anchor("BtnAdd"            ,"y",true)  
      Anchor("EdtName"           ,"yw")      
      Anchor("BtnRemove"         ,"xy",true) 
      Anchor("DdlKeyType"        ,"x")       
      Anchor("EdtKeyFormat"      ,"x")       
      Anchor("EdtKeyValue"       ,"x")       
      Anchor("ChkKeyDefault"     ,"x",true)  
      Anchor("ChkKeyHidden"      ,"x",true)  
      Anchor("BtnBrowseKeyValueEditor" ,"x",true) 
      Anchor("DatKeyValue"       ,"x")       
      Anchor("HotKeyValue"       ,"x")       
      Anchor("DdlKeyValue"       ,"x")       
      Anchor("ChkKeyValue"       ,"x")       
      Anchor("EdtChkName"        ,"x")       
      Anchor("EdtKeyOptions"     ,"x")     
      Anchor("EdtKeyDes"         ,"xh")      
      Anchor("EdtIniFile"        ,"xy")      
      Anchor("BtnBrowseIniFile"  ,"xy",true) 
      Anchor("BtnSaveToFile"     ,"x0.5y",true) 
      Anchor("BtnTestIni"        ,"x0.5y",true) 
      Anchor("Grb"               ,"wh",true) 
      Anchor("TxtType"           ,"x")       
      Anchor("TxtFormat"         ,"x")       
      Anchor("TxtValue"          ,"x")       
      Anchor("TxtOptions"        ,"x")       
      Anchor("TxtDescription"    ,"x")       
      Anchor("TxtIniFile"        ,"xy")
      Anchor("TxtHeadline"       ,"x0.5")
    }
Return

WM_GETMINMAXINFO(wParam, lParam, msg, hwnd) {
    static pos 
  	sig = `n%A_Gui%=
    If !A_Gui
  		  Return
  	If !InStr(pos, sig) {
        WinWait, ahk_id %hwnd%,,0.01
        If ErrorLevel 
            Return 0
        WinGetPos, , , w, h, ahk_id %hwnd% 
    		pos := pos . sig . w . "/" . h . "/"
      }
  	StringTrimLeft, p, pos, InStr(pos, sig) - 1 + StrLen(sig)
  	StringSplit, p, p, /
    InsertIntegerAtAddress(p1, lParam, 24, 4)
    InsertIntegerAtAddress(p2, lParam, 28, 4)
	  Return 0
  }

InsertIntegerAtAddress(pInteger, pAddress, pOffset = 0, pSize = 4) {
    mask := 0xFF
    Loop %pSize% {
		    DllCall("RtlFillMemory", UInt, pAddress + pOffset + A_Index - 1, UInt, 1, UChar, (pInteger & mask) >> 8 * (A_Index - 1))
		    mask := mask << 8
      }
  }

iif(expr, a, b=""){
    If expr
        Return a
    Return b
  }
