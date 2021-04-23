#NoEnv

;wip: multiple simultaneous viewports with independent views
;wip: undo/redo
;wip: selection filling/moving/copying/pasting

/*
Copyright 2012 Anthony Zhang <azhang9@gmail.com>

This file is part of MeseconEdit. Source code is available at <https://github.com/Uberi/MeseconEdit>.

MeseconEdit is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#Warn All
#Warn LocalSameAsGlobal, Off

Width := 800
Height := 600

FileVersion := "Mesecon Schematic Version 1"

FileModified := False

Tools := [Object("Name","&Draw",   "Class",ToolActions.Draw)
         ,Object("Name","&Remove", "Class",ToolActions.Remove)
         ,Object("Name","&Select", "Class",ToolActions.Select)
         ,Object("Name","&Actuate","Class",ToolActions.Actuate)]

Menu, FileMenu, Add, &New, FileNew
Menu, FileMenu, Add, &Open, FileOpen
Menu, FileMenu, Add
Menu, FileMenu, Add, &Save, FileSave
Menu, FileMenu, Add, Save &As, FileSaveAs
Menu, FileMenu, Add
Menu, FileMenu, Add, &Import, FileImport
Menu, FileMenu, Add, &Export, FileExport
Menu, FileMenu, Add
Menu, FileMenu, Add, E&xit, MainGuiClose

;Menu, OptionsMenu, Add, &Simulation, ShowSimulationOptions

Menu, HelpMenu, Add, &Manual, ShowHelp
Menu, HelpMenu, Add, &About, ShowAbout

Menu, MenuBar, Add, &File, :FileMenu
;Menu, MenuBar, Add, &Options, :OptionsMenu
Menu, MenuBar, Add, &Help, :HelpMenu
Menu, MenuBar, Color, White

Gui, Main:Menu, MenuBar

Gui, Main:Add, Text, vDisplay gDisplayClick hwndhControl

InitializeViewport(hControl,Width,Height)

For Index, Tool In Tools
    Gui, Main:Add, Radio, w80 h20 vTool%Index% gSelectTool, % Tool.Name
GuiControl, Main:, Tool1, 1

Gui, Main:Add, ListBox, w80 h200 vSubtools
GuiControl, Main:Focus, Subtools
SelectTool(1)

Gui, Main:+Resize +MinSize400x320 +LastFound
GroupAdd, Main, % "ahk_id " . WinExist()
Gui, Main:Show, w800 h600 Hide

Gosub, FileNew

Gosub, Draw
SetTimer, Draw, 50
Return

#IfWinActive ahk_group Main

class ToolActions
{
    #Include Tools\Draw.ahk
    #Include Tools\Remove.ahk
    #Include Tools\Select.ahk
    #Include Tools\Actuate.ahk
}

class Nodes
{
    #Include %A_ScriptDir%\Nodes\Basis.ahk
    #Include %A_ScriptDir%\Nodes\Blinky Plant.ahk
    #Include %A_ScriptDir%\Nodes\Inverter.ahk
    #Include %A_ScriptDir%\Nodes\Mesecon.ahk
    #Include %A_ScriptDir%\Nodes\Meselamp.ahk
    #Include %A_ScriptDir%\Nodes\Plug.ahk
    #Include %A_ScriptDir%\Nodes\Power Plant.ahk
    #Include %A_ScriptDir%\Nodes\Sign.ahk
    #Include %A_ScriptDir%\Nodes\Socket.ahk
    #Include %A_ScriptDir%\Nodes\Solid.ahk
    #Include %A_ScriptDir%\Nodes\Switch.ahk
}

FileNew:
Gui, Main:+OwnDialogs
If FileModified
{
    MsgBox, 35, Confirm, Save current schematic?
    IfMsgBox, Cancel
        Return
    IfMsgBox, Yes
        Gosub, FileSave
}
Viewport := Object("X",-14.5,"Y",-14.5,"W",30,"H",30)
CurrentFile := "<Untitled>"
Grid := []

SetModified(False)

ResizeWindow(Width,Height)
Return

FileOpen:
Gui, Main:+OwnDialogs
If FileModified
{
    MsgBox, 35, Confirm, Save current schematic?
    IfMsgBox, Cancel
        Return
    IfMsgBox, Yes
        Gosub, FileSave
}

FileSelectFile, FileName, 35,, Open mesecon schematic, Mesecon Schematic (*.mesecon)
If ErrorLevel
    Return
CurrentFile := FileName
FileRead, Value, %CurrentFile%
If ErrorLevel
{
    MsgBox, 16, Error, Could not read file "%FileName%".
    Return
}

If RegExMatch(Value,"sS)^" . FileVersion . "\s+(?P<X>-?[\d\.]+)[ \t]+(?P<Y>-?[\d\.]+)[ \t]+(?P<W>-?[\d\.]+)[ \t]+(?P<H>-?[\d\.]+)\s+(?P<Data>.*)$",Field)
{
    try Grid := Deserialize(FieldData)
    catch e
    {
        MsgBox, 20, Error, Could not recognize file entries.`n`nLoad anyway?
        IfMsgBox, Yes
            Grid := Deserialize(FieldData,True)
        Else
            Return
    }

    ;load viewport position
    Viewport.X := FieldX
    Viewport.Y := FieldY
    Viewport.W := FieldW
    Viewport.H := FieldH
}
Else
{
    MsgBox, 20, Error, Could not recognize file version.`n`nLoad anyway?
    IfMsgBox, Yes
        Grid := Deserialize(Value,True)
    Else
        Return
}

SetModified(False)
Return

FileSave:
Gui, Main:+OwnDialogs
If (CurrentFile = "<Untitled>")
{
    Gosub, FileSaveAs
    Return
}
FileDelete, %CurrentFile%
Value := FileVersion . "`n" . Viewport.X . " " . Viewport.Y . " " . Viewport.W . " " . Viewport.H . "`n" . Serialize(Grid)
FileAppend, %Value%, %CurrentFile%
If ErrorLevel
    MsgBox, 16, Error, Could not save file as "%CurrentFile%".
Else
    SetModified(False)
Return

FileSaveAs:
Gui, Main:+OwnDialogs
FileSelectFile, FileName, S48,, Save mesecon schematic, Mesecon Schematic (*.mesecon)
If ErrorLevel
    Return
CurrentFile := FileName
Gui, Main:Show,, MeseconEdit - %CurrentFile%
Gosub, FileSave
Return

FileImport:
Gui, Main:+OwnDialogs
If FileModified
{
    MsgBox, 35, Confirm, Save current schematic?
    IfMsgBox, Cancel
        Return
    IfMsgBox, Yes
        Gosub, FileSave
}

FileSelectFile, FileName, 35,, Load worldedit schematic, WorldEdit Schematic (*.we)
If ErrorLevel
    Return
FileRead, Value, %CurrentFile%
If ErrorLevel
{
    MsgBox, 16, Error, Could not read file "%FileName%".
    Return
}
Grid := Import(Value)
Return

FileExport:
Gui, Main:+OwnDialogs
FileSelectFile, FileName, S48,, Save worldedit schematic, WorldEdit Schematic (*.we)
If ErrorLevel
    Return
FileDelete, %FileName%
FileAppend, % Export(Grid), %FileName%
If ErrorLevel
{
    Gui, Main:+OwnDialogs
    MsgBox, 16, Error, Could not export file as "%FileName%".
}
Return

ShowHelp:
;wip: open manual here
Return

ShowAbout:
Gui, Main:+Disabled
Gui, About:+OwnerMain +ToolWindow
Gui, About:Color, White
Gui, About:Add, Picture, x10 y10 w140 h140, % A_IsCompiled ? A_ScriptFullPath : (A_ScriptDir . "\Icon.ico")
Gui, About:Font, s48, Arial
Gui, About:Add, Text, x170 y10 w400 h70, MeseconEdit
Gui, About:Font, s8 Bold
Gui, About:Add, Text, x170 y80 w200 h20, v1.7 Stable
Gui, About:Font, s12 Norm
Gui, About:Add, Link, x170 y110 w400 h20, Licensed under the <a href="http://www.gnu.org/licenses/">GNU Affero General Public License</a>.
Gui, About:Font, s8
Gui, About:Add, Text, x170 y130 w200 h20, Copyright Anthony Zhang 2012.
Gui, About:Show, w570 h160, About
Return

AboutGuiEscape:
AboutGuiClose:
Gui, Main:-Disabled
Gui, About:Destroy
Return

MainGuiClose:
If FileModified
{
    MsgBox, 35, Confirm, Save current schematic?
    IfMsgBox, Cancel
        Return
    IfMsgBox, Yes
        Gosub, FileSave
}
SetTimer, Draw, Off
UninitializeViewport(hControl)
ExitApp

MainGuiSize:
Critical
If A_EventInfo = 1 ;window minimised
    Return
Width := A_GuiWidth
Height := A_GuiHeight
ResizeWindow(Width,Height)
Sleep, 10
Return

SelectTool:
SelectTool(SubStr(A_GuiControl,5))
Return

Draw:
Draw(hDC,hMemoryDC,Grid,Width,Height,Viewport)
Return

SelectTool(ToolIndex)
{
    global Tools
    static PreviousToolIndex := 0
    static Subtools := []

    If PreviousToolIndex > 0
    {
        ;store the current subtool of the previously selected tool
        Gui, Main:+LastFound
        SendMessage, 0x188, 0, 0, ListBox1 ;LB_GETCURSEL
        Subtools[PreviousToolIndex] := ErrorLevel + 1
    }
    PreviousToolIndex := ToolIndex

    ;select the tool
    Result := ""
    For Index, ToolName In Tools[ToolIndex].Class.Select()
        Result .= "|" . ToolName
    GuiControl, Main:, Subtools, %Result%

    ;restore the previously selected subtool
    If !Subtools.HasKey(ToolIndex)
        Subtools[ToolIndex] := 1
    GuiControl, Main:Choose, Subtools, % Subtools[ToolIndex]
}

SetModified(Value)
{
    global CurrentFile, FileModified
    If Value
    {
        Gui, Main:Show,, * MeseconEdit - %CurrentFile%
        Menu, FileMenu, Enable, &Save
        FileModified := True
    }
    Else
    {
        Gui, Main:Show,, MeseconEdit - %CurrentFile%
        Menu, FileMenu, Disable, &Save
        FileModified := False
    }
}

~RButton::
SetModified(True)

CoordMode, Mouse, Client
MouseGetPos, OffsetX, OffsetY
ViewportX1 := Viewport.X, ViewportY1 := Viewport.Y
While, GetKeyState("RButton","P")
{
    MouseGetPos, MouseX, MouseY
    PositionX := MouseX - OffsetX
    PositionY := MouseY - OffsetY
    Viewport.X := ViewportX1 - ((PositionX / Width) * Viewport.W)
    Viewport.Y := ViewportY1 - ((PositionY / Height) * Viewport.H)

    ;obtain the position of the viewport
    GuiControlGet, TempPosition, Main:Pos, Display
    If (MouseX < TempPositionX) ;mouse past left edge of viewport
    {
        OffsetX += TempPositionW
        MouseMove, TempPositionX + TempPositionW, MouseY, 0
    }
    Else If (MouseX > TempPositionX + TempPositionW) ;mouse past right edge of viewport
    {
        OffsetX -= TempPositionW
        MouseMove, TempPositionX, MouseY, 0
    }
    If (MouseY < TempPositionY) ;mouse past top edge of viewport
    {
        OffsetY += TempPositionH
        MouseMove, MouseX, TempPositionY + TempPositionH, 0
    }
    Else If (MouseY > TempPositionY + TempPositionH) ;mouse past bottom edge of viewport
    {
        OffsetY -= TempPositionH
        MouseMove, MouseX, TempPositionY, 0
    }

    Sleep, 50
}
Return

DisplayClick:
Gui, Main:Submit, NoHide
For Index, Tool In Tools
{
    If Tool%Index%
    {
        Tool.Class.Activate(Grid)
        Break
    }
}

SetModified(True)
Return

~PGUP::
~WheelUp::
If Viewport.W > 2
{
    Viewport.W *= 0.8, Viewport.H *= 0.8
    Viewport.X += Viewport.W * 0.1, Viewport.Y += Viewport.H * 0.1

    SetModified(True)
}
Return

~PGDN::
~WheelDown::
If Viewport.W < 80
{
    Viewport.X -= Viewport.W * 0.1, Viewport.Y -= Viewport.H * 0.1
    Viewport.W *= 1.25, Viewport.H *= 1.25

    SetModified(True)
}
Return

Serialize(Grid)
{
    Result := ""
    For IndexX, Column In Grid
    {
        For IndexY, Node In Column
        {
            Value := Node.Serialize()

            ;escape data
            StringReplace, Value, Value, \, \5C, All
            FormatInteger := A_FormatInteger, FoundPos := 0
            SetFormat, IntegerFast, Hex
            While, FoundPos := RegExMatch(Value,"S)[^\w \t``\-=\[\]\\;',\./~!@#\$%\^&\*\(\)_\+\{\}|:""<>\?]",Char,FoundPos + 1)
                StringReplace, Value, Value, %Char%, % "\" . SubStr("0" . SubStr(Asc(Char),3),-1), All
            SetFormat, IntegerFast, %FormatInteger%

            Result .= IndexX . "`t" . IndexY . "`t" . Node.__Class . "`t" . Value . "`n"
        }
    }
    Return, SubStr(Result,1,-1)
}

Deserialize(Value,Lenient = False)
{
    global Nodes

    ;create a mapping of node class names to node classes
    NodeClasses := Object()
    For Name, Node In Nodes
    {
        If IsObject(Node)
            NodeClasses[Node.__Class] := Node
    }

    Grid := []
    StringReplace, Value, Value, `r,, All
    Value := Trim(Value,"`n")
    Loop, Parse, Value, `n
    {
        If !RegExMatch(A_LoopField,"sS)^(?P<X>-?[\d\.]+)[ \t]+(?P<Y>-?[\d\.]+)[ \t]+(?P<Type>[^ \t]+)[ \t]+(?P<Data>.*)$",Field)
        {
            If Lenient
                Continue
            throw Exception("Invalid node entry: " . A_LoopField . ".")
        }
        If !(Lenient || NodeClasses.HasKey(FieldType))
            throw Exception("Invalid node class: " . FieldType . ".")

        ;unescape data
        FoundPos := 0
        While, FoundPos := InStr(FieldData,"\",False,FoundPos + 1)
        {
            If (Temp1 := SubStr(FieldData,FoundPos + 1,2)) != "5C"
                StringReplace, FieldData, FieldData, \%Temp1%, % Chr("0x" . Temp1), All
        }
        StringReplace, FieldData, FieldData, \5C, \, All

        Grid[FieldX,FieldY] := NodeClasses[FieldType].Deserialize(FieldX,FieldY,FieldData)
    }
    Return, Grid
}

Import(Data)
{
    global Nodes
    static NodeMap := Object("default:dirt",                            Nodes.Solid
                            ,"mesecons:mesecon_off",                    Nodes.Mesecon
                            ,"mesecons:mesecon_on",                     Nodes.Mesecon
                            ,"mesecons_blinkyplant:blinky_plant_off",   Nodes.BlinkyPlant
                            ,"mesecons_blinkyplant:blinky_plant_on",    Nodes.BlinkyPlant
                            ,"mesecons_lamp:lamp_off",                  Nodes.Meselamp
                            ,"mesecons_lamp:lamp_on",                   Nodes.Meselamp
                            ,"mesecons_powerplant:power_plant",         Nodes.PowerPlant
                            ,"mesecons_temperest:mesecon_inverter_off", Nodes.Inverter
                            ,"mesecons_temperest:mesecon_inverter_on",  Nodes.Inverter
                            ,"mesecons_temperest:mesecon_plug",         Nodes.Plug
                            ,"mesecons_temperest:mesecon_socket_off",   Nodes.Socket
                            ,"mesecons_temperest:mesecon_socket_on",    Nodes.Socket
                            ,"mesecons_switch:mesecon_switch_off",      Nodes.Switch
                            ,"mesecons_switch:mesecon_switch_on",       Nodes.Switch)

    Loop, Parse, Data, `n, `r%A_Space%%A_Tab%
    {
        If RegExMatch(A_LoopField,"aS)(?P<X>[+-]?\d+)\s+(?P<Y>[+-]?\d+)\s+(?P<Z>[+-]?\d+)\s+(?P<Name>[^\s]+)",Field)
        {
            If NodeMap.HasKey(FieldName)
            {
                Node := NodeMap[FieldName]
                Grid[FieldX,FieldY] := new Node(FieldX,FieldY)
            }
        }
    }
    Return, Grid
}

Export(Grid)
{
    static NodeMap := Object("Nodes.BlinkyPlant",["mesecons_blinkyplant:blinky_plant_on"  ,"mesecons_blinkyplant:blinky_plant_off"]
                            ,"Nodes.Inverter",   ["mesecons_temperest:mesecon_inverter_on","mesecons_temperest:mesecon_inverter_off"]
                            ,"Nodes.Mesecon",    ["mesecons:mesecon_on"                   ,"mesecons:mesecon_off"]
                            ,"Nodes.Meselamp",   ["mesecons_lamp:lamp_on"                 ,"mesecons_lamp:lamp_off"]
                            ,"Nodes.Plug",       ["mesecons_temperest:mesecon_plug"       ,"mesecons_temperest:mesecon_plug"]
                            ,"Nodes.PowerPlant", ["mesecons_powerplant:power_plant"       ,"mesecons_powerplant:power_plant"]
                            ,"Nodes.Socket",     ["mesecons_temperest:mesecon_socket_on"  ,"mesecons_temperest:mesecon_socket_off"]
                            ,"Nodes.Switch",     ["mesecons_switch:mesecon_switch_on"     ,"mesecons_switch:mesecon_switch_off"]
                            ,"Nodes.Solid",      ["default:dirt"                          ,"default:dirt"])
    static Padding := "   "

    Result := ""
    For IndexX, Column In Grid
    {
        For IndexY, Node In Column
        {
            NodeName := NodeMap[Node.__Class][Node.State ? 1 : 2]
            Result .= IndexX . " " . IndexY . " 0 " . NodeName . " 0 0`n"
        }
    }
    Return, SubStr(Result,1,-1)
}

GetMouseCoordinates(Width,Height,ByRef MouseX,ByRef MouseY)
{
    global Viewport
    ;obtain the mouse position
    CoordMode, Mouse, Client
    MouseGetPos, MouseX, MouseY

    ;obtain the viewport position
    GuiControlGet, Offset, Main:Pos, Display

    ;calculate the cell the mouse in in
    MouseX -= OffsetX, MouseY -= OffsetY
    MouseX := Floor(Viewport.X + ((MouseX / Width) * Viewport.W))
    MouseY := Floor(Viewport.Y + ((MouseY / Height) * Viewport.H))
}

InitializeViewport(hWindow,Width,Height)
{
    global hDC, hMemoryDC, hOriginalBitmap
    hDC := DllCall("GetDC","UPtr",hWindow)
    If !hDC
        throw Exception("Could not obtain window device context.")
    hMemoryDC := DllCall("CreateCompatibleDC","UPtr",hDC)
    If !hMemoryDC
        throw Exception("Could not obtain window device context.")

    hOriginalBitmap := 0

    ResizeViewport(Width,Height)
}

UninitializeViewport(hWindow)
{
    global hDC, hMemoryDC, hBitmap
    If hBitmap && !DllCall("DeleteObject","UPtr",hBitmap) ;delete the bitmap
        throw Exception("Could not delete bitmap.")
    If !DllCall("DeleteObject","UPtr",hMemoryDC) ;delete the memory device context
        throw Exception("Could not delete memory device context.")
    If !DllCall("ReleaseDC","UPtr",hWindow,"UPtr",hDC) ;release the window device context
        throw Exception("Could not release window device context.")
}

Draw(hDC,hMemoryDC,Grid,Width,Height,Viewport)
{
    static hPen := DllCall("CreatePen","Int",0,"Int",0,"UInt",0x888888,"UPtr") ;PS_SOLID

    ;clear the bitmap
    If !DllCall("BitBlt","UPtr",hMemoryDC,"Int",0,"Int",0,"Int",Width,"Int",Height,"UPtr",hMemoryDC,"Int",0,"Int",0,"UInt",0x42) ;BLACKNESS
        throw Exception("Could not transfer pixel data to window device context.")

    ;determine the dimensions of each cell
    BlockW := Width / Viewport.W, BlockH := Height / Viewport.H
    IndexX := Floor(Viewport.X), IndexY := Floor(Viewport.Y)

    ;determine the horizontal position of the first cell
    BlockX := Mod(-Viewport.X,1) * BlockW
    If BlockX > 0
        BlockX -= BlockW

    ;determine the vertical position of the first cell
    BlockY := Mod(-Viewport.Y,1) * BlockH
    If BlockY > 0
        BlockY -= BlockH

    ;draw grid lines
    IndexX1 := IndexX, BlockX1 := BlockX
    hOriginalPen := DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hPen,"UPtr") ;select the pen
    Loop, % Ceil(Viewport.W)
    {
        BlockX1 += BlockW
        DllCall("MoveToEx","UPtr",hMemoryDC,"Int",BlockX1,"Int",0,"UPtr",0)
        DllCall("LineTo","UPtr",hMemoryDC,"Int",BlockX1,"Int",Height)
    }
    IndexY1 := IndexY, BlockY1 := BlockY
    Loop, % Ceil(Viewport.H)
    {
        BlockY1 += BlockH
        DllCall("MoveToEx","UPtr",hMemoryDC,"Int",0,"Int",BlockY1,"UPtr",0)
        DllCall("LineTo","UPtr",hMemoryDC,"Int",Width,"Int",BlockY1)
    }
    DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hOriginalPen,"UPtr") ;deselect the pen

    ;draw cells
    Loop, % Ceil(Viewport.W) + 1
    {
        IndexY1 := IndexY, BlockY1 := BlockY
        Loop, % Ceil(Viewport.H) + 1
        {
            If Grid[IndexX,IndexY1]
                Grid[IndexX,IndexY1].Draw(hMemoryDC,BlockX,BlockY1,BlockW,BlockH)
            IndexY1 ++, BlockY1 += BlockH
        }
        IndexX ++, BlockX += BlockW
    }

    ;transfer pixel data to window device context
    If !DllCall("BitBlt","UPtr",hDC,"Int",0,"Int",0,"Int",Width,"Int",Height,"UPtr",hMemoryDC,"Int",0,"Int",0,"UInt",0xCC0020) ;SRCCOPY
        throw Exception("Could not transfer pixel data to window device context.")
}

ResizeWindow(Width,Height)
{
    global Viewport, Tools
    ViewportWidth := Width - 110, ViewportHeight := Height - 20
    GuiControl, Main:Move, Display, x10 y10 w%ViewportWidth% h%ViewportHeight%
    ResizeViewport(ViewportWidth,ViewportHeight)
    Viewport.Y += Viewport.H / 2
    Viewport.H := (Height / Width) * Viewport.W
    Viewport.Y -= Viewport.H / 2

    Temp1 := 10
    For Index In Tools
        GuiControl, Main:Move, Tool%Index%, % "x" . (Width - 90) . " y" . Temp1, Temp1 += 20

    Temp1 += 20
    GuiControl, Main:Move, Subtools, % "x" . (Width - 90) . " y" . Temp1
}

ResizeViewport(Width,Height)
{
    global hDC, hMemoryDC, hOriginalBitmap, hBitmap
    If hOriginalBitmap
    {
        If !DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hOriginalBitmap,"UPtr") ;deselect the bitmap
            throw Exception("Could not select original bitmap into memory device context.")
    }
    hBitmap := DllCall("CreateCompatibleBitmap","UPtr",hDC,"Int",Width,"Int",Height,"UPtr") ;create a new bitmap
    If !hBitmap
        throw Exception("Could not create bitmap.")
    hOriginalBitmap := DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hBitmap,"UPtr")
    If !hOriginalBitmap
        throw Exception("Could not select bitmap into memory device context.")
}