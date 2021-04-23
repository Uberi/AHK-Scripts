#NoEnv

;wip: console version with exact same functionality
;wip: get errors from stdout and restart the thread
;wip: ANSI/64 bit support

Gui, REPL:Font, s12, Courier New
Gui, REPL:Add, Edit, x10 y10 vScrollback hwndhScrollBack ReadOnly Multi
Gui, REPL:Font, s14
Gui, REPL:Add, Edit, x10 h50 vLine gTyping hwndhLine Multi -WantReturn
Gui, REPL:Add, Button, w40 h50 vExecute gExecute Default, ->
Gui, REPL:+Resize +MinSize200x400 +OwnDialogs
GuiControl, REPL:Focus, Line
Gosub, Typing

Gosub, Initialize

Gui, REPL:Show, w800 h540
Return

#Include <AhkDllThread>
;#Include <GetLineActionType>

REPLGuiClose:
AHKThread.ahkTerminate()
ExitApp

REPLGuiSize:
GuiControl, REPL:Move, Scrollback, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 80)
GuiControl, REPL:Move, Line, % "y" . (A_GuiHeight - 60) . " w" . (A_GuiWidth - 60)
GuiControl, REPL:Move, Execute, % "x" . (A_GuiWidth - 50) . " y" . (A_GuiHeight - 60)
Return

Initialize:
History := []
History[0] := ""
ScrollIndex := 0
SettingLine := True

Random, VarName, 0, 10000
VarName := "___internal___" . VarName

Suffix := (A_IsUnicode ? "U" : "A") . ((A_PtrSize = 4) ? "32" : "64")
AHKThread := AhkDllThread(A_ScriptDir . "\Lib\AutoHotkey" . Suffix . ".dll")
AHKThread.ahktextdll()

ValueTypes := {ACT_ASSIGNEXPR: True
              ,ACT_EXPRESSION: True
              ,ACT_ADD: True
              ,ACT_SUB: True
              ,ACT_MULT: True
              ,ACT_DIV: True}
Return

Typing:
GuiControlGet, Line, REPL:, Line
If (Line = "")
    GuiControl, REPL:Disable, Execute
Else
    GuiControl, REPL:Enable, Execute

If SettingLine
    History[0] := Line
Else
    SettingLine := True
Return

Execute:
GuiControlGet, Line, REPL:, Line
GuiControl, REPL:, Line
GuiControl, REPL:Focus, Line

History.Insert(Line)
ScrollIndex := 0

;add line to scrollback
Value := ">>> " . Line . "`n"
SendMessage, 0x0E, 0, 0,, ahk_id %hScrollBack% ;WM_GETTEXTLENGTH
SendMessage, 0xB1, ErrorLevel, ErrorLevel,, ahk_id %hScrollBack% ;EM_SETSEL
SendMessage, 0xC2, 0, &Value,, ahk_id %hScrollBack% ;EM_REPLACESEL

AHKThread.ahkassign[VarName] := "" ;clear the result variable
;If ValueTypes[GetLineActionType(Line)]
    ;Line := VarName . ":=(" . Line . ")"

;execute the script line
;wip: ahkExec also seems to be possible here
NewLine := AHKThread.addScript(Line,False) ;add but do not execute the line
ToolTip % AHKThread.ahkReady()
;wip: check for load time errors here
;AHKThread.ahkExecuteLine(NewLine,1,True) ;UNTIL_RETURN, wait for execution to finish

;obtain the result
Value := AHKThread.ahkgetvar[VarName] . "`n"
SendMessage, 0x0E, 0, 0,, ahk_id %hScrollBack% ;WM_GETTEXTLENGTH
SendMessage, 0xB1, ErrorLevel, ErrorLevel,, ahk_id %hScrollBack% ;EM_SETSEL
SendMessage, 0xC2, 0, &Value,, ahk_id %hScrollBack% ;EM_REPLACESEL
Return

#If CheckLineUp()

CheckLineUp() ;ensure the control is focused and the caret is at the top line
{
    global hLine
    GuiControlGet, FocusedControl, REPL:FocusV
    ControlGet, Line, CurrentLine,,, ahk_id %hLine%
    Return, FocusedControl = "Line" && Line = 1
}

Up::
ScrollIndex --
If ScrollIndex < 0
    ScrollIndex := History.MaxIndex()
SettingLine := False
GuiControl, REPL:, Line, % History[ScrollIndex]
Return

#If CheckLineDown()

CheckLineDown() ;ensure the control is focused and the caret is at the bottom line
{
    global hLine
    GuiControlGet, FocusedControl, REPL:FocusV
    ControlGet, LastLine, LineCount,,, ahk_id %hLine%
    ControlGet, Line, CurrentLine,,, ahk_id %hLine%
    Return, FocusedControl = "Line" && Line = LastLine
}

Down::
ScrollIndex ++
If (ScrollIndex > History.MaxIndex())
    ScrollIndex := 0
SettingLine := False
GuiControl, REPL:, Line, % History[ScrollIndex]
Return