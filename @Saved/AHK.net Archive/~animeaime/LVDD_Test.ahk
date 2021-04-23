#SingleInstance Force
#NoEnv

/*
ListView Drag & Drop
*/

;use LVM_MAPINDEXTOID and LVM_MAPIDTOINDEX to associate an object with a ListView item
;store this unique ID with the object
;what if the item is moved (via drag drop? - or otherwise?)

;regardless of CoordMode setting, drag/drop works
CoordMode, Mouse, Screen

Gui, Font, s16
Method2 := false

;add a menu
Menu, FileMenu, add, &New, DoNothing
Menu, FileMenu, add
Menu, FileMenu, add, E&xit, CloseProgram

Menu, MenuBar, add, &File, :FileMenu

Gui, Menu, MenuBar

; Gui, -Caption

Gui, Add, Button, , Ok
Gui, Add, Edit

Gui, Add, ListView, Grid Count20 r10 w203 gMyListView vMyListView, Name|Age

GuiControl, -Redraw, MyListView

LV_ModifyCol(1, 100)
LV_ModifyCol(2, 100)

;add items
Loop, 20
{
    LV_Add("", "Item" A_Index)
}

GuiControl, +Redraw, MyListView

Gui, Add, ListView, Grid Count7 r9 yp+20 x+10 gMyListView2 vMyListView2, Name|Age
LV_ModifyCol(1, 100)

GuiControl, -Redraw, MyListView2
;add items
Loop, 7
{
    LV_Add("", "Item" A_Index)
}

GuiControl, +Redraw, MyListView2

Gui, Show

return

DoNothing:
return

GuiEscape:
if (LV_DragDrop)
    return
    
CloseProgram:
GuiClose:
ExitApp

MyListView2:
MyListView:
{
    ;Only part the user touches
    if (A_GuiEvent = "D")
    {
        ;gives the Gui control keyboard focus when a drag begins (optional)
        GuiControl, Focus, %A_GuiControl%
        
;         CoordMode, Mouse, Relative

        if (DropLocation := LV_DragDrop())
        {
            ;InsertAfter is a boolean (either true or false)
            ;Position is the one-based insertion point
            LV_ParseDDResults(DropLocation, InsertAfter, Position)
            
            MsgBox, % "Move from " . A_EventInfo . " to "
                . (InsertAfter ? "after " : "before ") . Position
        }
        else
            MsgBox, % "No drop takes place"
    }

    return
}

LV_DragDrop()
{
    ;add check to verify that CurrentWindow is the GUI's window??
    ;not really needed, minor optimization
    
    ;LVM_FIRST = 0x1000

    static ScrollBarWidth, ScrollBarHeight, BorderX, BorderY
    
    global LV_DragDrop := true
    
    if (!ScrollBarWidth)
    {
        SysGet, ScrollBarWidth, 2
        SysGet, ScrollBarHeight, 3

        ;not really sure where these comes from
        ;but it is used to have the X and Y values mimic that of MouseMove
        BorderX := 2
        BorderY := 2
    }

    ;Initialize structures
    Point_create(Point)
    Rectangle_create(InsertMark)

;     iItem := A_EventInfo
    MouseGetPos, , , ThisWindow, ThisControl, 2
    
    Used_HWND := ThisControl
    hDC := DllCall("GetDC", "uint", ThisWindow)

    ControlGetPos, ControlX, ControlY, ControlW, ControlH, , ahk_id %Used_HWND%
    GuiControlGet, ControlPos, Pos, %A_GuiControl%

    ;Get Gui cordinates (used to convert from Screen to Gui relative coords)
    WinGetPos, GuiX, GuiY, , , ahk_id %ThisWindow%

    ;Orgin for Control (relative to Gui window)
    ControlOriginX := ControlX + BorderX
    ControlOriginY := ControlY + BorderY

    ;Origin for ControlPos (relative to Gui area)
    ControlPosOriginX := ControlPosX + BorderX
    ControlPosOriginY := ControlPosY + BorderY

    ;Get mouse position relative to the control (regardless of CoordMode setting)
    DllCall("GetCursorPos", "uint", &Point)

    X := Point_getX(Point) - GuiX - ControlOriginX
    Y := Point_getY(Point) - GuiY - ControlOriginY


    ;Get HScrollBar info
    VarSetCapacity(HScrollBar, 60), NumPut(60, HScrollBar)

    ;OBJID_HSCROLL = -6
    DllCall("GetScrollBarInfo", "uint", Used_HWND, "int", -6, "uint", &HScrollBar)

    ;STATE_SYSTEM_INVISIBLE = 0x8000
    hasHScrollBar := !(NumGet(HScrollBar, 36) & 0x8000)

    if (hasHScrollBar)
        ControlPosH -= ScrollBarHeight + 2


    ;Get VScrollBar info
    VarSetCapacity(VScrollBar, 60), NumPut(60, VScrollBar)

    ;OBJID_VSCROLL = -5
    DllCall("GetScrollBarInfo", "uint", Used_HWND, "int", -5, "uint", &VScrollBar)

    ;STATE_SYSTEM_INVISIBLE = 0x8000
    hasVScrollBar := !(NumGet(VScrollBar, 36) & 0x8000)

    if (hasVScrollBar)
        ControlPosW -= ScrollBarWidth + 2


    ;LVM_GETHEADER = LVM_FIRST + 31 = 0x101F
    SendMessage, 0x101F, 0, 0, , ahk_id %Used_HWND%
    ListViewHeader := ErrorLevel

    ;LVM_GETCOUNTPERPAGE = LVM_FIRST + 40 = 0x1028
    SendMessage, 0x1028, 0, 0, , ahk_id %Used_HWND%
    NumberOfVisibleItems := ErrorLevel

    ;LVM_GETITEMCOUNT = LVM_FIRST + 4 = 0x1004
    SendMessage, 0x1004, 0, 0, , ahk_id %Used_HWND%
    ItemCount := ErrorLevel

    if (NumberOfVisibleItems > ItemCount)
        NumberOfVisibleItems := ItemCount

    ;Used for InsertMark
    StartX := ControlPosX
    EndX := ControlPosX + ControlPosW

    ;Used to detect hovering
    LastX := X
    LastY := Y

    ;Initialize return values
    InsertAfter := false
    InsertPosition := 0
    
    
    ;Cache InsertMark locations
    VarSetCapacity(InsertMarks, 4 * (NumberOfVisibleItems + 1))

    ;LVM_GETTOPINDEX = LVM_FIRST + 39 = 0x1027
    SendMessage, 0x1027, 0, 0, , ahk_id %Used_HWND%

    TopIndex := ErrorLevel
    CurrentIndex := 0

    Loop, % NumberOfVisibleItems - 1
    {
        ;LVM_GETITEMPOSITION = LVM_FIRST + 16 = 0x1010
        SendMessage, 0x1010, CurrentIndex + TopIndex, &Point, , ahk_id %Used_HWND%
        
        StartY := ControlPosY + Point_getY(Point) + BorderY
        
        NumPut(StartY, InsertMarks, 4 * CurrentIndex, "int")
        
        CurrentIndex++
    }

    ;save last item's top and bottom
    Rectangle_create(ItemBounds)
    
    ;LVM_GETITEMRECT = LVM_FIRST + 14 = 0x100E
    ;LVIR_BOUNDS = 0 (set as the LEFT member)
    SendMessage, 0x100E, CurrentIndex + TopIndex, &ItemBounds, , ahk_id %Used_HWND%

    StartY := ControlPosY + Rectangle_getTop(ItemBounds) + BorderY
    NumPut(StartY, InsertMarks, 4 * CurrentIndex, "int")
    
    StartY := ControlPosY + Rectangle_getBottom(ItemBounds) + BorderY
    NumPut(StartY, InsertMarks, 4 * (CurrentIndex + 1), "int")
    
    ItemWidth := Rectangle_getRight(ItemBounds) - Rectangle_getLeft(ItemBounds)
    
    BelowLastItem := Rectangle_getBottom(ItemBounds)
    
    ;LVM_CREATEDRAGIMAGE = LVM_FIRST + 33 = 0x1021
    ;-1 converts from one-based to zero-based index
;     SendMessage, 0x1021, iItem - 1, &Point, , ahk_id %Used_HWND%
    
;     MsgBox, % Point_getX(Point) . " " . Point_getY(Point)
;     MsgBox, % ErrorLevel
    
    Loop
    {
        if !GetKeyState("LButton")
            break

        if GetKeyState("Escape")
        {
            DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "uint", false)
            InsertPosition := 0
            break
        }

        MouseGetPos, , , CurrentWindow, CurrentControl, 2

        ;Get Mouse Position relative to the Gui (regardless of CoordMode setting)
        DllCall("GetCursorPos", "uint", &Point)

        X := Point_getX(Point) - GuiX - ControlOriginX
        Y := Point_getY(Point) - GuiY - ControlOriginY

        ;CurrentControl = "" if not over a control
        
;         if (CurrentControl != "")
;             ControlGet, CurrentControl_HWND, HWND, , %CurrentControl%, ahk_id %CurrentWindow%
;         else
;             CurrentControl_HWND := 0
        
        if (CurrentControl = ThisControl || CurrentControl = ListViewHeader)
        {
            ;LVM_GETTOPINDEX = LVM_FIRST + 39 = 0x1027
            SendMessage, 0x1027, 0, 0, , ahk_id %Used_HWND%

            ;+1 converts from zero-based to one-based index
            TopIndex := ErrorLevel + 1
            
            ;-1 to get last visible item
            BottomIndex := TopIndex + NumberOfVisibleItems - 1

            Point_setPoint(Point, X, Y)
            LV_InsertMarkHitTest(Used_HWND, Point, After, iItem, iSubItem)

            if (CurrentControl = ListViewHeader)
            {
                ;On header
                
                After := 0
                iItem := TopIndex
;                 iItem = 0

                onHScrollBar := false
            }
            else if (Y <= BelowLastItem)
            {
                ;In ListView
                
                onHScrollBar := false
            }
            else
            {
                ;Below last item
                
                After := 1
                iItem := BottomIndex

                ;+BorderY to compensate for earlier subtraction
                onHScrollBar := hasHScrollBar && Y + BorderY >= ControlPosH
            }

            ;+BorderX to compensate for earlier subtraction
            onVScrollBar := hasVScrollBar && X + BorderX >= ControlPosW

;             ToolTip, % (onVScrollBar ? "On VBar" : "Not on VBar") . hasVScrollBar
;                 . "`n" . (OnHScrollBar ? "On HBar" : "Not on HBar") . hasHScrollBar
;                 . "`n" . X . "," . Y
;                 . "`n" . ControlPosW . "," . ControlPosH
;                 . "`n" . After . " " . iItem . " " . iSubItem
                
            ItemInBounds := iItem >= TopIndex && After + iItem <= BottomIndex + 1
            
            if (ItemInBounds)
            {
                ;change return values
                InsertAfter := After
                InsertPosition := iItem

                ;clear previous InsertMark
                if (LastAfter + LastPosition != After + iItem)
                {
                    LastItemInBounds := LastPosition >= TopIndex
                        && LastAfter + LastPosition <= BottomIndex + 1
                        
                    if (LastItemInBounds)
                    {
                        CurrentIndex := LastAfter + LastPosition - TopIndex
                        StartY := NumGet(InsertMarks, 4 * CurrentIndex)

                        ;A rectangle of height 2
                        Rectangle_setPoints(InsertMark, StartX, StartY, EndX, StartY + 2)
                        
                        DllCall("InvalidateRect", "uint", ThisWindow
                            , "uint", &InsertMark, "uint", false)
                    }

                    LastAfter := After
                    LastPosition := iItem
                }

                CurrentIndex := After + iItem - TopIndex
                StartY := NumGet(InsertMarks, 4 * CurrentIndex)

                ;A rectangle of height 2
                Rectangle_setPoints(InsertMark, StartX, StartY, EndX, StartY + 2)
                
                ;A rectangle of height 2
                DllCall("Rectangle", "uint", hDC, "int", StartX, "int", StartY
                    , "int", EndX, "int", StartY + 2)

                Sleep, 1
            }
            else if (InsertPosition)
            {
                ;clear InsertMark (item not in bounds)
                DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "int", true)
                InsertPosition := 0
            }
        }
        else if (InsertPosition)
        {
            ;clear InsertMark (mouse not in "active" control)
            DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "int", true)
            InsertPosition := 0
        }
        
        if (LastX = X && LastY = Y)
        {
            if (CurrentControl = ThisControl || CurrentControl = ListViewHeader)
            {
                ;checks "Hover" time
                if (Last && (A_TickCount - Last) >= 400)
                {
                    ;scroll on bounds

                    if (iItem <= TopIndex && TopIndex != 1)
                    {
                        ;clear previous InsertMark
                        DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "int", true)
                        InsertPosition := 0

                        Sleep, 1

                        ;LVM_ENSUREVISIBLE = LVM_FIRST + 19
                        ;-1 converts form one-based to zero-based index
                        ;fPartialOK = false
                        SendMessage, 0x1013, (TopIndex - 1) - 1, false, , ahk_id %Used_HWND%
                    }

                    if (iItem >= BottomIndex && BottomIndex != ItemCount)
                    {
                        ;clear previous InsertMark
                        DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "int", true)
                        InsertPosition := 0

                        Sleep, 1
                        
                        ;LVM_ENSUREVISIBLE = LVM_FIRST + 19
                        ;-1 converts form one-based to zero-based index
                        ;fPartialOK = false
                        SendMessage, 0x1013, (BottomIndex - 1) + 1, false, , ahk_id %Used_HWND%
                    }

                    Last := A_TickCount
                }

                if (!Last)
                    Last := A_TickCount
            }

            continue
        }

        Last := 0
        LastX := X
        LastY := Y
    }

    ;clean up
    VarSetCapacity(InsertMarks, 0)
    VarSetCapacity(HScrollBar, 0)
    VarSetCapacity(VScrollBar, 0)
    
;     ToolTip
    DllCall("ReleaseDC", "uint", 0, "uint", hDC)

    if (!InsertPosition)
    {
        LV_DragDrop := false
        return 0
    }
        
    ;clear previous InsertMark
    DllCall("InvalidateRect", "uint", ThisWindow, "uint", &InsertMark, "int", true)

    Sleep, 1
    
    LV_DragDrop := false
    return InsertAfter . " " . InsertPosition
}

LV_ParseDDResults(DragDropResults, ByRef InsertAfter, ByRef Position)
{
    StringSplit, DragDropResults, DragDropResults, %A_Space%
    
    InsertAfter := DragDropResults1
    Position := DragDropResults2
}

/*
Drag/drop utility functions
*/

LV_InsertMarkHitTest(ThisControl, ByRef Point, ByRef After, ByRef iItem, ByRef iSubItem = 0)
{
    LV_HitTestInfo_create(LV_HitTestInfo, Point_getX(Point), Point_getY(Point))
    
    ;LVM_SUBITEMHITTEST = LVM_FIRST + 57 = 0x1039
    SendMessage, 0x1039, 0, &LV_HitTestInfo, , ahk_id %ThisControl%
    
    flags := LV_HitTestInfo_getFlags(LV_HitTestInfo)
    iItem := LV_HitTestInfo_getItem(LV_HitTestInfo)
    iSubItem := LV_HitTestInfo_getSubItem(LV_HitTestInfo)

    if (ErrorLevel = -1 || iItem <= 0)
    {
        ;not on an item
        After := 0
        iItem = 0
        
        return
    }

    Rectangle_create(Rectangle)

    ;LVM_GETITEMRECT = LVM_FIRST + 14 = 0x100E
    ;-1 converts from one-based to zero-based index
    ;LVIR_BOUNDS = 0 (set as the LEFT member)
    SendMessage, 0x100E, iItem - 1, &Rectangle, , ahk_id %ThisControl%

    X := Point_getX(Point)
    Y := Point_getY(Point)

    Top := Rectangle_getTop(Rectangle)
    Bottom := Rectangle_getBottom(Rectangle)
    Height := Bottom - Top
    
    if (Y - Top < (Height >> 1))
        After := false
    else
        After := true
}

/*
Structures Used
*/

Point_create(ByRef Point, X = 0, Y = 0)
{
    VarSetCapacity(Point, 8), Point_setPoint(Point, X, Y)
}

Point_getPoint(ByRef Point, ByRef X, ByRef Y)
{
    X := Point_getX(Point)
    Y := Point_getY(Point)
}

Point_setPoint(ByRef Point, X, Y)
{
    Point_setX(Point, X)
    Point_setY(Point, Y)
}

Point_getX(ByRef Point)
{
    return NumGet(Point, 0, "int")
}

Point_setX(ByRef Point, X)
{
    NumPut(X, Point, 0, "int")
}

Point_getY(ByRef Point)
{
    return NumGet(Point, 4, "int")
}

Point_setY(ByRef Point, Y)
{
    NumPut(Y, Point, 4, "int")
}

Rectangle_create(ByRef Rectangle, Left = 0, Top = 0, Right = 0, Bottom = 0)
{
    VarSetCapacity(Rectangle, 16)
        , Rectangle_setTopLeft(Rectangle, Left, Top)
        , Rectangle_setBottomRight(Rectangle, Right, Bottom)
}

Rectangle_getPoints(ByRef Rectangle, ByRef Left, ByRef Top, ByRef Right, ByRef Bottom)
{
    Left := Rectangle_getLeft(Rectangle)
    Top := Rectangle_getTop(Rectangle)
    Right := Rectangle_getRight(Rectangle)
    Bottom := Rectangle_getBottom(Rectangle)
}

Rectangle_setPoints(ByRef Rectangle, Left, Top, Right, Bottom)
{
    Rectangle_setLeft(Rectangle, Left)
    Rectangle_setTop(Rectangle, Top)
    Rectangle_setRight(Rectangle, Right)
    Rectangle_setBottom(Rectangle, Bottom)
}

Rectangle_getTopLeft(ByRef Rectangle, ByRef Left, ByRef Top)
{
    Left := Rectangle_getLeft(Rectangle)
    Top := Rectangle_getTop(Rectangle)
}

Rectangle_setTopLeft(ByRef Rectangle, Left, Top)
{
    Rectangle_setLeft(Rectangle, Left)
    Rectangle_setTop(Rectangle, Top)
}

Rectangle_getTopLeftPoint(ByRef Rectangle, ByRef TopLeft)
{
    Left := Rectangle_getLeft(Rectangle)
    Top := Rectangle_getTop(Rectangle)
    
    Point_create(TopLeft, Left, Top)
}

Rectangle_setTopLeftPoint(ByRef Rectangle, ByRef TopLeft)
{
    Rectangle_setLeft(Rectangle, Point_getX(TopLeft))
    Rectangle_setTop(Rectangle, Point_getY(TopLeft))
}

Rectangle_getBottomRight(ByRef Rectangle, ByRef Right, ByRef Bottom)
{
    Right := Rectangle_getRight(Rectangle)
    Bottom := Rectangle_getBottom(Rectangle)
}

Rectangle_setBottomRight(ByRef Rectangle, Right, Bottom)
{
    Rectangle_setRight(Rectangle, Right)
    Rectangle_setBottom(Rectangle, Bottom)
}

Rectangle_getBottomRightPoint(ByRef Rectangle, ByRef BottomRight)
{
    Right := Rectangle_getRight(Rectangle)
    Bottom := Rectangle_getBottom(Rectangle)
    
    Point_create(BottomRight, Right, Bottom)
}

Rectangle_setBottomRightPoint(ByRef Rectangle, ByRef BottomRight)
{
    Rectangle_setRight(Rectangle, Point_getX(BottomRightt))
    Rectangle_setBottom(Rectangle, Point_getY(BottomRight))
}

Rectangle_getLeft(ByRef Rectangle)
{
    return NumGet(Rectangle, 0, "int")
}

Rectangle_setLeft(ByRef Rectangle, Left)
{
    NumPut(Left, Rectangle, 0, "int")
}

Rectangle_getTop(ByRef Rectangle)
{
    return NumGet(Rectangle, 4, "int")
}

Rectangle_setTop(ByRef Rectangle, Top)
{
    NumPut(Top, Rectangle, 4, "int")
}

Rectangle_getRight(ByRef Rectangle)
{
    return NumGet(Rectangle, 8, "int")
}

Rectangle_setRight(ByRef Rectangle, Right)
{
    NumPut(Right, Rectangle, 8, "int")
}

Rectangle_getBottom(ByRef Rectangle)
{
    return NumGet(Rectangle, 12, "int")
}

Rectangle_setBottom(ByRef Rectangle, Bottom)
{
    NumPut(Bottom, Rectangle, 12, "int")
}

LV_HitTestInfo_create(ByRef LV_HitTestInfo, X, Y, flags = 0xE)
{
;     flags = LVHT_ONITEM (default)

;     LVHT_ONITEMICON := 0x2
;     LVHT_ONITEMLABEL := 0x4
;     LVHT_ONITEMSTATEICON := 0x8
;     LVHT_ONITEM := (LVHT_ONITEMICON | LVHT_ONITEMLABEL | LVHT_ONITEMSTATEICON)

    VarSetCapacity(LV_HitTestInfo, 20, 0)
        , LV_HitTestInfo_setPoint(LV_HitTestInfo, X, Y)
        , LV_HitTestInfo_setFlags(LV_HitTestInfo, flags)
}

LV_HitTestInfo_getPoint(ByRef LV_HitTestInfo, ByRef X, ByRef Y)
{
    X := LV_HitTestInfo_getX(LV_HitTestInfo)
    Y := LV_HitTestInfo_getY(LV_HitTestInfo)
}

LV_HitTestInfo_setPoint(ByRef LV_HitTestInfo, X, Y)
{
    LV_HitTestInfo_setX(LV_HitTestInfo, X)
    LV_HitTestInfo_setY(LV_HitTestInfo, Y)
}

LV_HitTestInfo_getX(ByRef LV_HitTestInfo)
{
    return NumGet(LV_HitTestInfo, 0, "int")
}

LV_HitTestInfo_setX(ByRef LV_HitTestInfo, X)
{
    NumPut(X, LV_HitTestInfo, 0, "int")
}

LV_HitTestInfo_getY(ByRef LV_HitTestInfo)
{
    return NumGet(LV_HitTestInfo, 4, "int")
}

LV_HitTestInfo_setY(ByRef LV_HitTestInfo, Y)
{
    NumPut(Y, LV_HitTestInfo, 4, "int")
}

LV_HitTestInfo_getFlags(ByRef LV_HitTestInfo)
{
    return NumGet(LV_HitTestInfo, 8)
}

LV_HitTestInfo_setFlags(ByRef LV_HitTestInfo, flags)
{
    NumPut(flags, LV_HitTestInfo, 8)
}

LV_HitTestInfo_getItem(ByRef LV_HitTestInfo)
{
    ;+1 converts from zero-based to one-based index
    return NumGet(LV_HitTestInfo, 12, "int") + 1
}

LV_HitTestInfo_setItem(ByRef LV_HitTestInfo, iItem)
{
    ;-1 converts from one-based to zero-based index
    NumPut(iItem - 1, LV_HitTestInfo, 12, "int")
}

LV_HitTestInfo_getSubItem(ByRef LV_HitTestInfo)
{
    ;+1 converts from zero-based to one-based index
    return NumGet(LV_HitTestInfo, 16, "int") + 1
}

LV_HitTestInfo_setSubItem(ByRef LV_HitTestInfo, iSubItem)
{
    ;-1 converts from one-based to zero-based index
    NumPut(iSubItem - 1, LV_HitTestInfo, 16, "int")
}