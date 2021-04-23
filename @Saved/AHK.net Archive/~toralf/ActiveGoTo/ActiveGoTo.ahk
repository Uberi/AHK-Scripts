; SubVersion Keywords, also available: LastChangedBy, HeadURL
RegExMatch("$LastChangedRevision: 12 $"
         . "$LastChangedDate: 2006-12-07 23:01:24 +0100 (Do, 07 Dez 2006) $"
         , "(?P<Num>\d+).*?(?P<Date>(?:\d+-?){3})", SVN_Rev)

/*
bookmarklist for ahk scripts in different editors
requires AHK 1.0.46.00
original by Rajat (www.autohotkey.com/forum/topic11998.html)
mod by toralf (AHK syntax RegEx by PhiLho) 

F1 = show/hide bookmark list
F2 = switch between last and previous to last bookmark
bookmarklist has context and tray menu (one left click closes script)

;stored settings from previous session
[Settings]
Pos=x0 y38
;default x0
Size=w204
;default ""
ToggleFrame=0
;default 0
Slide=1
;default 1
ToggleLeft=1
;default 1
AdjustHeight=1
;default 1
HideOnLostFocus=0
;default 0
*/

;Hotkeys to show/hide GUI and going to last bookmark
HK_ShowGUI     = F1
HK_LastSection = F2

;___________________________________________
;____D_O_N_'_T___E_D_I_T___B_E_L_O_W________
;___________________________________________

#SingleInstance Force

;RegEx for window titles of different editors
EditorTitelRegEx =         
  (LTrim Comments 
    ^PSPad(?: - \[)?(?P<Name>.*?)(?P<UnSaved> \*)?(?: R/O)?\]?$   ;PSPad 
    ^(?P<Name>.*?) (?P<UnSaved>[-*]) SciTE$                       ;SciTE 
    ^Notepad\+\+ - (?P<Name>.*?)$                                 ;Notepad++ 
    ^(?P<UnSaved>\*)?(?P<Name>.*?)(?: \(Read only\))? - Notepad2$ ;Notepad2 
    ^ConTEXT(?: - \[)?(?P<Name>.*?)(?P<UnSaved> \*?#?)?(?: \[ReadOnly\])?\]?$ ;ConTEXT
  ) 
;Class or Window Title of GoTo Window for the different editors
GotoWinClassOrTitle =      
  (LTrim Comments 
     ahk_class TfGotoLine     ;PSPad 
     ahk_class #32770         ;SciTE 
     ahk_class #32770         ;Notepad++ 
     ahk_class #32770         ;Notepad2 
     ahk_class TForm          ;ConTEXT 
  ) 
;ShortCut for GoTo in Editor, in case it is different from Ctrl+g
GotoShortCut =
  (LTrim Comments 
     ^g     ;PSPad 
     ^g     ;SciTE 
     ^g     ;Notepad++ 
     ^g     ;Notepad2 
     ^g     ;ConTEXT 
  ) 

;Create arrays from the above three lists 
StringSplit, EditorTitelRegEx,    EditorTitelRegEx,    `n
StringSplit, GotoWinClassOrTitle, GotoWinClassOrTitle, `n
StringSplit, GotoShortCut,        GotoShortCut,        `n

;Regex to get AHK syntax right
identifierRE = ][#@$?\w                  ; Legal characters for AHK identifiers (variables and function names)
parameterListRE = %identifierRE%,=".\s-  ; Legal characters in function definition parameter list
lineCommentRE = \s*?(?:\s;.*)?$          ; Legal line comment regex for performance

;MaxVisible Rows of Listview
MaxVisibleListViewRows := A_ScreenHeight // 16

;build gui
MainWnd = Active GoTo r%SVN_RevNum%
Gui, 1:+AlwaysOnTop +ToolWindow -Caption +Border +Resize
Gui, 1:Margin, 2, 2
Gui, 1:Add, Edit, Section w130 r1 vSearch gSearch,
Gui, 1:Add, Text, ys+3 r1 vTxtOffset,Offset
Gui, 1:Add, Edit, ys w35 r1 Right Number Limit4 gFillList vOffset,
Gui, 1:Add, CheckBox, xs Section gFillList vSubFunc Check3, Only Sub/Func
Gui, 1:Add, CheckBox, ys gFillList vLimit, Filter
Gui, 1:Add, ListView, xs w200 r%MaxVisibleListViewRows% Count200 vSelItem gLSelect,Line|Label
LV_ModifyCol(1, "Integer")
Gui, 1:Add, Button, x-10 y-10 w1 h1 gSelect Default,
Gui, 1:Show, x0 Hide, %MainWnd%
Gui, 1:+LastFound
GuiHWND := WinExist()

;apply previous position and size
IniRead, Pos, %A_ScriptName%, Settings, Pos, x0
IniRead, Size, %A_ScriptName%, Settings, Size,
Gui, 1:Show, %Pos% %Size% Hide

;add HWND of GUI to the groups for context sensitive Hotkeys
GroupAdd, GuiGrp, ahk_id %GuiHWND%
GroupAdd, HtkGrp, ahk_id %GuiHWND%

;activate hotkeys for editors and gui
Hotkey, IfWinActive, ahk_group HtkGrp
Hotkey, %HK_LastSection%, LastSection
Hotkey, %HK_ShowGUI%, ShowGUI, Off
Hotkey, IfWinActive

; location of icon file
IconFile := A_WinDir . "\system" . (A_OSType = "WIN32_NT" ? "32" : "") . "\shell32.dll"
 
;tray menu
Menu, Tray, Icon, %IconFile%, 56   ;icon for taskbar and for process in task manager
Menu, Tray, Tip, %MainWnd%
Menu, Tray, NoStandard
Menu, Tray, Add, Frame, ToggleFrame
Menu, Tray, Add, Slide, Slide
Menu, Tray, Add, Slide Left, ToggleLeft
Menu, Tray, Add, Adjust Height, AdjustHeight
Menu, Tray, Add, Hide On Lost Focus, HideOnLostFocus
Menu, Tray, Add
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Exit
Menu, Tray, Click, 1

;context menu
Menu, Context, Add, Frame, ToggleFrame
Menu, Context, Add, Slide, Slide
Menu, Context, Add, Slide Left, ToggleLeft
Menu, Context, Add, Adjust Height, AdjustHeight
Menu, Context, Add, Hide On Lost Focus, HideOnLostFocus
Menu, Context, Add
Menu, Context, Add, Exit, GuiClose

;check for open editors 
GetEditorsHWNDandType()
;check for newly opened editors every 2 seconds 
SetTimer, GetEditorsHWNDandType, 2000

;check editor window title for change
SetTimer, CheckEditorTitle, 100

;set defaults by calling once with inverse value
ToggleFrame  := !ReadIni("ToggleFrame" , 0)
ToggleLeft   := !ReadIni("ToggleLeft"  , 1)
Slide        := !ReadIni("Slide"       , 1)
AdjustHeight := !ReadIni("AdjustHeight", 1)
HideOnLostFocus := !ReadIni("HideOnLostFocus", 0)
GoSub, ToggleFrame
GoSub, ToggleLeft
GoSub, Slide
GoSub, AdjustHeight
GoSub, HideOnLostFocus
Return

;activate hotkeys for gui
#IfWinActive, ahk_group GuiGrp
Up::         ControlSend, SysListView321, {Up},   ahk_id %GuiHWND%
Down::       ControlSend, SysListView321, {Down}, ahk_id %GuiHWND%
PgUp::       ControlSend, SysListView321, {PgUp}, ahk_id %GuiHWND%
PgDn::       ControlSend, SysListView321, {PgDn}, ahk_id %GuiHWND%
WheelUp::    ControlSend, SysListView321, {Up},   ahk_id %GuiHWND%
WheelDown::  ControlSend, SysListView321, {Down}, ahk_id %GuiHWND%
MButton::    GoSub, Select 
^BackSpace:: Send,^+{Left}{Del}
#IfWinActive

;check for open editors 
GetEditorsHWNDandType:
  GetEditorsHWNDandType()
Return

;check for open editors 
GetEditorsHWNDandType(){
    local IDsOfAllWindows,WinTitle,HWND
    Static ListOfHWND
    ;New editor windows get added to EType array
    ;Closed editor windows are not removed.
    ;Script should be restarted after a time to start from scratch
    ;Didn't want to re-initialize the list each time, since it might cause trouble
    ;if a goto jump is performed the same time.
    DetectHiddenWindows, On         ;detect editor also when minimized
    WinGet, IDsOfAllWindows, List
    Loop, %IDsOfAllWindows% {
        HWND := IDsOfAllWindows%A_Index%
        If HWND in %ListOfHWND%
            Continue
        WinGetTitle, WinTitle, ahk_id %HWND%
        Loop, %EditorTitelRegEx0%{
            If RegExMatch(WinTitle, EditorTitelRegEx%A_Index%, File){
                EType%HWND% = %A_Index%
                ListOfHWND .= (ListOfHWND ? "," : "") . HWND
                GroupAdd, HtkGrp, ahk_id %HWND%
              }
          }
      }
    DetectHiddenWindows, Off
  }

;check editor window title for change
CheckEditorTitle:
  CheckEditorTitle()
Return

;check editor window title for change
CheckEditorTitle(){
    local HWND,EType,WinTitle,Extension,File,FileName,FileUnSaved
    static PreviousSaveStatus,LastFileName
    If GetKeyState("Ctrl")           ;wait for ctrl key to be up again while changing tabs
        Return
                    
    HWND := WinExist("A")       ;get HWND of active window
    EType := EType%HWND%        ;and test what editor type this Window is
    If (Slide AND GuiVisible AND HWND <> GuiHWND AND (!EType OR HideOnLostFocus))
        GoSub, GuiHide         ;when slide is turned on and gui or a editor are not active, but gui is visible, hide it  
  
    If !EType                  ;No Editor active, don't update
        Return
                    
    WinGetTitle, WinTitle, ahk_id %HWND%      ;get current editor title
    RegExMatch(WinTitle, EditorTitelRegEx%EType%, File)  ;extract filename and save state

    SplitPath, FileName, , , Extension, ,   ;get extension
    If (Extension <> "ahk")                 ;don't continue when not a ahk script
        Return               
                                                   
    If ( ( FileName <> LastFileName )       ;update BM list, when filename changed
      OR (  !InStr(FileUnSaved,"*")
          AND !PreviousSaveStatus)){        ;or when file got saved           
        EditorHWND = %HWND%
        GotoWinClassOrTitle := GotoWinClassOrTitle%EType%
        GotoShortCut := GotoShortCut%EType%
        GenerateBM(FileName)                ;trigger bookmark (BM) generation
        LastFileName = %FileName%
        PreviousSaveStatus := True
    }Else If InStr(FileUnSaved,"*")
        PreviousSaveStatus := False
  }

;generate BM array
GenerateBM(FileName){
    local FileData,state,CurrLine,hotkey,hotkeyName
         ,function,functionName,functionLine,functionClosingParen,functionOpeningBrace
         ,functionParameters,functionParametersEX,hotstring,hotstringName,label,labelName
    SetBatchLines, -1
    id = 0                                        ;reset index of BM array
    FileRead, FileData, %FileName%                ;read file
    state = DEFAULT
    Loop, Parse, FileData, `n, `r                 ;search for bookmarks
      {
        CurrLine = %A_LoopField%                  ;remove spaces and tabs
        
        If RegExMatch(CurrLine, "^\s*(?:;.*)?$") ; Empty line or line with comment, skip it
            Continue
                 
        Else If InStr(state, "COMMENT"){             ; In a block comment
            If RegExMatch(CurrLine, "S)^\s*\*/")     ; End of block comment
                StringReplace state, state, COMMENT  ; Remove state
                ; "*/ function_def()" is legal but quite perverse... I won't support this
      
        }Else If InStr(state,"CONTSECTION") {        ; In a continuation section
            If RegExMatch(CurrLine, "^\s*\)")        ; End of continuation section
                state = DEFAULT
  
        }Else If RegExMatch(CurrLine, "^\s*/\*")         ; Start of block comment, to skip
            state = %state% COMMENT
      
        Else If RegExMatch(CurrLine, "^\s*\(")           ; Start of continuation section, to skip
            state = CONTSECTION
      
        ;hotstring RegEx
          ;very strict : "i)^\s*(?P<Name>:(?:\*0?|\?0?|B0?|C[01]?|K(?:-1|\d+)|O0?|P\d+|R0?|S[IPE]|Z0?)*:.+?)::"
          ;less strict : "i)^\s*:[*?BCKOPRSIEZ\d-]*:(?P<Name>.+?)::"
        ;loose         : "^\s*:[*?\w\d-]*:(?P<Name>.+?)::" 
        ;the loose RegEx doesn't need update when new features get added
      
        Else If RegExMatch(CurrLine, "^\s*:[*?\w\d-]*:(?P<Name>.+?)::", hotstring){ ;HotString
            AddToBMArray(A_Index, ".." . hotstringName . "::")
            state = DEFAULT
  
        }Else If RegExMatch(CurrLine, "i)^\s*(?P<Name>[^ \s]+?(?:\s+&\s+[^\s]+?)?(?:\s+up)?)::", hotkey){  ;Hotkey
            AddToBMArray(A_Index,hotkeyName . "::")
            state = DEFAULT
      
        }Else If RegExMatch(CurrLine, "^\s*(?P<Name>[^\s,```%]+):" . lineCommentRE, label){   ; Label are very tolerant...
            AddToBMArray(A_Index,labelName . ":", 1)
            state = DEFAULT
        
        }Else If InStr(state,"DEFAULT"){
            If RegExMatch(CurrLine, "^\s*(?P<Name>[" . identifierRE . "]+)"         ; Found a function call or a function definition
                              . "\((?P<Parameters>[" . parameterListRE . "]*)"
                              . "(?P<ClosingParen>\)\s*(?P<OpeningBrace>\{)?)?"
                              . lineCommentRE, function){
                state = FUNCTION
                functionLine := A_Index
                If functionClosingParen{        ; With closed parameter list
                    If functionOpeningBrace {     ; Found! This is a function definition
                        AddToBMArray(functionLine,functionName . "(" . functionParameters . ")", - 1)
                        state = DEFAULT
                    }Else                         ; List of parameters is closed, just search for opening brace
                        state .= " TOBRACE"
                }Else                           ; With open parameter list
                    state .= " INPARAMS"      ; Search for closing parenthesis
                  }
        
        }Else If InStr(state,"FUNCTION"){
            If InStr(state, "INPARAMS") {     ; After a function definition or call
                ; Looking for ending parenthesis
                If (RegExMatch(CurrLine, "^\s*(?P<ParametersEX>,[" . parameterListRE . "]+)"
                                   . "(?P<ClosingParen>\)\s*(?P<OpeningBrace>\{)?)?" . lineCommentRE, function) > 0){
                    functionParameters .= functionParametersEX
                    If functionClosingParen {            ; List of parameters is closed
                        If functionOpeningBrace{   ; Found! This is a function definition
                          AddToBMArray(functionLine,functionName . "(" . functionParameters . ")", -1)
                          state = DEFAULT
                        }Else                              ; Just search for opening brace
                          StringReplace state, state, INPARAMS, TOBRACE ; Remove state
                      }                                    ; Otherwise, we continue
                }Else   
                    ; Incorrect syntax for a parameter list, it was probably just a function call, e.g. contained a "+"
                    state = DEFAULT
            }Else If InStr(state,"TOBRACE"){ ; Looking for opening brace. There can be only empty lines and comments, which are already processed
                If (RegExMatch(CurrLine, "^\s*(?:\{)" . lineCommentRE) > 0){  ; Found! This is a function definition
                    AddToBMArray(functionLine,functionName . "(" . functionParameters . ")", -1)
                    state = DEFAULT
                }Else  ; Incorrect syntax between closing parenthesis and opening brace,
                    state = DEFAULT     ; it was probably just a function call
            }
          }
      }
    GoSub, FillList                                         
  }

;generate BM Array
AddToBMArray(Pos, Text, Type =""){
    global
    id++                  ;add BM to array
    Text%id% := RegExReplace(Text, "\s\s*", " ")  ; Replace multiple blank chars with simple space
    Position%id% = %Pos%
    Type%id% = %Type%
  }

;fill listview from BM array
FillList:
  SetBatchLines, -1
  Gui, 1:Submit, NoHide
  LV_Delete()                                  ;remove old content
  GuiControl, 1:-Redraw, SelItem
  If ( (Search AND !Limit AND !SubFunc)        ;show full list for search
         OR (!Search AND !SubFunc) ){          ;show full list
      Loop, %id%
          If (Position%A_Index% > Offset)
              LV_Add("", Position%A_Index%,Text%A_Index%)
  }Else If (Search AND Limit AND !SubFunc){    ;show limited list for search
      Loop, %id%
          If InStr(Text%A_Index%, Search)
              If (Position%A_Index% > Offset)
                  LV_Add("", Position%A_Index%,Text%A_Index%)
  }Else If (Search AND Limit AND SubFunc){     ;show limited subFunc list for search
      Loop, %id%
          If (InStr(Text%A_Index%, Search) and Type%A_Index% = SubFunc)
              If (Position%A_Index% > Offset)
                  LV_Add("", Position%A_Index%,Text%A_Index%)
  }Else If ( (Search AND !Limit AND SubFunc)   ;show subFunc list for search
         OR (!Search AND SubFunc) )            ;show subFunc list
      Loop, %id%
          If (Type%A_Index% = SubFunc)
              If (Position%A_Index% > Offset)
                  LV_Add("", Position%A_Index%,Text%A_Index%)
  LV_ModifyCol(1, "Auto")                     ;adjust width
  LV_ModifyCol(2, "Auto")

  If AdjustHeight {
      ListViewHeight := 45 + 14 * ( LV_GetCount() < MaxVisibleListViewRows ? LV_GetCount() : MaxVisibleListViewRows)
      GuiControl, 1:Move, SelItem, h%ListViewHeight%
      Hide := GuiVisible ? "" : "Hide"
      Gui, Show, Autosize %Hide%
    }

  GuiControl, 1:+Redraw, SelItem
  GoSub, HighlightItems                       ;reapply last search
Return

;search by user input
Search:
  GuiControlGet, Search, 1:
  If Limit
      GoSub, FillList
  Else
      GoSub, HighlightItems
Return
      
;highlight items in listview
HighlightItems:
  Loop % LV_GetCount() {             ;highlight all which contain search
      LV_GetText(Text, A_Index , 2)
      If ( InStr(Text,Search) AND Search)
          LV_Modify(A_Index,"Select")
      Else
          LV_Modify(A_Index,"-Select")
    }
  If !Search                         ;highlight first if no search text
      LV_Modify(1,"Select")
  If A_GuiControl <> Offset
      GuiControl, 1:Focus, Search
Return

;goto position on double click in listview
LSelect:                         
  IfNotEqual, A_GuiEvent, DoubleClick, Return
  GotoPos(A_EventInfo)
Return
 
;goto position of first selected (highlighted)
Select:
  Row := LV_GetNext()      
  If !Row
      Return
  GotoPos(Row)
Return

;toggle between last and last before last position
LastSection:
  GotoPos()
Return

;find goto position
GotoPos(Row=""){
    static LastPos,LastB4LastPos
    If Row {                          
        LV_GetText(Pos, Row, 1)       ;get pos of row
        SendGoTo(Pos)                 ;send position
        If !LastPos                   ;remember positions
            LastPos = %Pos%
        LastB4LastPos = %LastPos%     
        LastPos = %Pos%
    }Else {
        SendGoTo(LastB4LastPos)       ;send previous position
        swap = %LastB4LastPos%        ;swap last with previous position
        LastB4LastPos = %LastPos%
        LastPos = %swap%
      }
    GoSub, GuiEscape                  ;hide gui
  }

;send position to editor
SendGoTo(Position){
    Global EditorHWND,GotoWinClassOrTitle,GotoShortCut
    WinActivate, ahk_id %EditorHWND%
    WinWaitActive, ahk_id %EditorHWND%
    Send, %GotoShortCut%
    WinWaitActive, %GotoWinClassOrTitle%  
    Send, %Position%{Enter}
  }
                            
;show context menu
GuiContextMenu:
  Menu, Context, Show
return

;show/hide gui with slide on hotkey press
ShowGUI:
  If GuiVisible{  ;hotkey got pressed with visible window, hide it
      Gosub, GuiEscape 
      Return
    }
  GuiControl, 1:Focus, Search      ;focus search field
  DllCall( "AnimateWindow", "Int", GuiHWND, "Int", 200, "Int", AniShow )
  WinActivate, ahk_id %GuiHWND%
  GuiVisible := True
  Send, ^a                       ;select search string
Return

;exit when gui closes
GuiClose:
  If !GuiVisible
      Gui, Show, Hide
  DetectHiddenWindows, On
  WinGetPos, X, Y, , , ahk_id %GuiHWND%
  DetectHiddenWindows, Off
  IniWrite, x%X% y%Y%, %A_ScriptName%, Settings, Pos 
  ExitApp

;hide gui on ESC
GuiEscape:
  WinActivate, ahk_id %EditorHWND%
  If !Slide
      Return
GuiHide:
  DllCall( "AnimateWindow", "Int", GuiHWND, "Int", 200, "Int", AniHide )
  GuiVisible := False
Return

;toggle visibility of frame
ToggleFrame:
  If ToggleFrame
      Gui, 1:-Caption
  Else
      Gui, 1:+Caption
  MenuToggle(ToggleFrame ? "UnCheck" : "Check","Frame")
  ToggleFrame := not ToggleFrame
  IniWrite, %ToggleFrame%, %A_ScriptName%, Settings, ToggleFrame 
Return

;toggle slide of gui to left or right
ToggleLeft:
  AniShow := ToggleLeft ? "0x00040002" : "0x00040001"
  AniHide := ToggleLeft ? "0x00050001" : "0x00050002"
  MenuToggle(ToggleLeft ? "UnCheck" : "Check","Slide Left")
  ToggleLeft := not ToggleLeft
  IniWrite, %ToggleLeft%, %A_ScriptName%, Settings, ToggleLeft 
Return

;toggle slide of gui On/0ff
Slide:
  If (!GuiVisible And Slide)
      GoSub, ShowGUI
  Hotkey, IfWinActive, ahk_group HtkGrp 
  Hotkey, %HK_ShowGUI%, % Slide ? "Off" : "On"
  Hotkey, IfWinActive 
  MenuToggle(Slide ? "UnCheck" : "Check","Slide")
  Slide := not Slide
  IniWrite, %Slide%, %A_ScriptName%, Settings, Slide 
Return

;toggle auto adjust gui to number of items in list
AdjustHeight:
  ListViewHeight := 45 + 14 * ( LV_GetCount() > MaxVisibleListViewRows OR AdjustHeight OR !LV_GetCount() ? MaxVisibleListViewRows : LV_GetCount() )
  GuiControl, 1:Move, SelItem, h%ListViewHeight%
  Hide := GuiVisible ? "" : "Hide"
  Gui, Show, Autosize %Hide%
  MenuToggle(AdjustHeight ? "UnCheck" : "Check","Adjust Height")
  AdjustHeight := not AdjustHeight
  IniWrite, %AdjustHeight%, %A_ScriptName%, Settings, AdjustHeight 
Return

HideOnLostFocus:
  MenuToggle(HideOnLostFocus ? "UnCheck" : "Check","Hide On Lost Focus")
  HideOnLostFocus := not HideOnLostFocus
  IniWrite, %HideOnLostFocus%, %A_ScriptName%, Settings, HideOnLostFocus 
Return

;toggle tray and context menu checkbox
MenuToggle(State,Menu){
     Menu, Tray, %State%, %Menu%
     Menu, Context, %State%, %Menu%
  }

;return key value from script 
ReadIni(Key, Default=""){
    IniRead, Value, %A_ScriptName%, Settings, %Key%, %Default%
    Return Value
  } 

;resize gui and adjust controls
GuiSize:
  Anchor("Search",    "w",  True)
  Anchor("TxtOffset", "x",  "")
  Anchor("Offset",    "x",  True)
  Anchor("SelItem",   "wh", "")
  IniWrite, w%A_GuiWidth%, %A_ScriptName%, Settings, Size 
Return

Anchor(ctrl, a, draw = false) { ; v3.4.1 - Titan
    static d
  
    ;controls are moved/resized by a fraction of the amount the gui changes size
    ;e.g.     New pX := orig. pX  + factor * ( current guiW - orig. guiW )
  
    ;get pos/size of control and return if control or Gui do not exist
    GuiControlGet, p, Pos, %ctrl%
    If !A_Gui or ErrorLevel
        Return

    s = `n%A_Gui%:%ctrl%=                         ;unique prefix to store pos/size
    c = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%    ;multi purpose string for efficiency
    StringSplit, c, c, .

    Loop, 4     ;get scale factors
        b%A_Index% += !RegExMatch(a, c%A_Index% . "(?P<" . A_Index . ">[\d.]+)", b)

    ;on first call for this control, remember original position, size
    If !InStr(d, s)
        d .= s . px - c7 * b1 . c5 . pw - c7 * b2
          . c5 . py - c8 * b3 . c5 . ph - c8 * b4 . c5

    ;calculate new position and size
    Loop, 4
      If InStr(a, c%A_Index%) {
        c6 += A_Index > 2
        RegExMatch(d, s . "(?:(-?[\d.]+)/){" . A_Index . "}", p) ;get factor
        ;combine "x/w/y/h" with (orig. control pos/size - orig. gui width/height * factor  + current gui width/height * factor)
        m := m . c%A_Index% . p1 + c%c6% * b%A_Index%
      }

    ;move/resize control to new pos/size
    t := !draw ? "" : "Draw"
    GuiControl, Move%t%, %ctrl%, %m%
  }
