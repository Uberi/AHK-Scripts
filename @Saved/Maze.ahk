; MazeSolver.ahk by infogulch for AutoHotkey_L UNICODE v1.1.0.04+
; 
; READ FIRST
; 
; 1. This script **requires** you have the DejaVu font installed. 
;    You can download it here: http://dejavu-fonts.org/wiki/Download 
;    (one of the first two links, they're the same just compressed differently)
;    (This is a really awesome font, excellent & accurate Unicode support, open source,
;      and has an awesome monospace version.)
; 
; 2. This file must be saved as utf-8 because it contains unicode characters.
; 

#SingleInstance, Force
#NoEnv
SetBatchLines, -1

MazeW := 23
MazeH := 23
MazeSeed := 0

Gui, Add, edit, vedtMaze w600 h600 hwndhMaze -wrap +HScroll +ReadOnly

; Create a font instance based on DejaVu Sans Mono with equal width and height (12,12) so it's square
; DEFAULT_CHARSET := 1, OUT_TT_PRECIS := 4,  CLIP_DEFAULT_PRECIS := 0,PROOF_QUALITY := 2, FF_DONTCARE := 0
hFont := CreateFont(12,12,0,0,0,0,0,0,1,4,0,2,0,"DejaVu Sans Mono")
Font(hMaze, hFont, True)

Gui, Add, Text, w65, Maze Width:
Gui, Add, Edit, w50 yp xp+70 number
Gui, Add, UpDown, Range8-1000 vMazeW, %MazeW%

Gui, Add, Text, w65 yp xp+55, Maze Height:
Gui, Add, Edit, w50 yp xp+70 number
Gui, Add, UpDown, Range8-1000 vMazeH, %MazeH%

Gui, Add, CheckBox, yp xp+55 w90 vMazeDoSeed -check gDoSeed, Random Seed
Gui, Add, Edit, w100 yp xp+95 number disabled vMazeSeedEdit
Gui, Add, UpDown, vMazeSeed, %MazeSeed%

Gui, Add, Button, gNewMaze w75 xm, NewMaze
Gui, Add, Button, gSolveMaze yp w75 xp+80, Solve
Gui, Add, Button, yp xp+80 gExit, Exit

Gui, +LastFound
hwnd := WinExist()

Gui, Show, , MazeSolver

NewMaze:
    if MAZE_WORKING
        return
    MAZE_WORKING := True
NewMazeF:
    GuiControlGet, MazeW
    GuiControlGet, MazeH
    if MazeDoSeed
    {
        GuiControlGet, MazeSeed
        Random, , MazeSeed
    }
    maze := makemaze(MazeW,MazeH)
    maze := SetChar(maze, 2, 1, "∏")
    maze := SetChar(maze, MazeW*2, MazeH*2+1, " ")
    solving := maze
    solving_x := 2
    solving_y := 2
    DisplayMaze(maze)
    MAZE_SOLVED := False
    MAZE_WORKING := False
return

SolveMaze:
    if MAZE_WORKING
        return
    MAZE_WORKING := True
    if MAZE_SOLVED
        GoSub NewMazeF
    solution := SolveMaze(maze)
    DisplayMaze(solution ? solution "`n`nSolved!" : maze "`n`n???")
    MAZE_SOLVED := True
    MAZE_WORKING := False
return

DoSeed:
    GuiControlGet, MazeDoSeed
    GuiControl, Enable%MazeDoSeed%, MazeSeedEdit
return

#If WinActive("ahk_id" hwnd)

Up::
Down::
Right::
Left::
    if !MAZE_SOLVED && !MAZE_WORKING && !MAZE_SOLVED
        TryMove(), TryMove()
return

TryMove() {
    global
    local n, d, c
    n := GetNeighbors(solving, solving_x, solving_y, Width(solving), Height(solving))
    d := { Right:1,Up:2,Left:3,Down:4 }[A_ThisHotkey]
    c := SubStr(n, d, 1)
    if (c = " " || c = "✓")
    {
        solving := SetChar(solving, solving_x, solving_y, "✓")
        solving_x += round(cos((d-1)*1.5708))
        solving_y -= round(sin((d-1)*1.5708))
        solving := SetChar(solving, solving_x, solving_y, "▮")
        if (solving_x = Width(solving)-1 && solving_y = Height(solving)) 
        {
            MsgBox Yay you solved it!
            GoSub SolveMaze
            return
        }
        DisplayMaze(solving)
    }
}

DisplayMaze( maze ) {
    global edtMaze
    GuiControl, , edtMaze, %maze%
}

GuiClose:
GuiEscape:
Exit:
    ExitApp

MakeMaze(width=11, height=8) {
    h := height*2+1
    w := width*2+1
    Loop % h
    {
        maze .= "`n"
        maze .= A_Index = 1 ? "┌" : A_Index = h ? "└" : A_Index & 1 ? "├" : "│"
        a := A_Index = 1 ? "─┬" : A_Index = h ? "─┴" : A_Index & 1 ? "─┼" : "0│"
        Loop % Width
            maze .= a
        maze := SubStr(maze, 1, -1)
        maze .= A_Index = 1 ? "┐" : A_Index = h ? "┘" : A_Index & 1 ? "┤" : "│"
    }
    maze := Walk(SubStr(maze,2))
    maze := Clean(maze, width, height)
    return maze
}
Clean(maze, width, height) {
    w := width*2+1
    h := height*2+1
    types := { "0000": " ", "0001": "╷", "0010": "╴", "0011": "┐", "0100": "╵", "0101": "│", "0110": "┘", "0111": "┤"
        , "1000": "╶", "1001": "┌", "1010": "─", "1011": "┬", "1100": "└", "1101": "├", "1110": "┴", "1111": "┼" }
    loop % height + 1
    {
        yp := 1 + (A_Index-1)*2
        loop % w
        {
            xp := A_Index
            if GetChar(maze, xp, yp) == " "
                continue
            n := GetNeighbors(maze, xp, yp, w, h)
            k := ""
            loop % 4
                k .= SubStr(n,A_Index,1) != " " && SubStr(n,A_Index,1) != "*"
            maze := SetChar(maze, xp, yp, types[k ""], True)
        }
    }
    return maze
}
Walk(s) {
    ; by nimda, heavily modified by infogulch
    ; notes: the original algorithym is recursive but this consistently overflows the stack
    ;        at 25x25 or larger, so I implemented my own 'stack' and made it non-recursive
    stack := []
    stack.SetCapacity((Width(s)//2)*(Height(s)//2))
    stack.insert(Cell(s,Rand(1, Width(s)//2), Rand(1, Height(s)//2)))
    while ObjMaxIndex(stack)
    {
        ; current cell
        c := Stack[ObjMaxIndex(Stack)]
        ; iterate through cell's neighbors, saving a different i for each cell
        while ++c.i <= ObjMaxIndex(c.n)
        {
            ; this neighbor
            n := c.n[c.i]
            ; has neighbor been visited?
            if GetChar(s, n.x*2, n.y*2) == "0" {
                ; set neighbor as visited
                s := SetChar(s, n.x*2, n.y*2, " ")
                ; break wall between cell and neighbor
                s := SetChar(s, c.x+n.x, c.y+n.y, " ")
                ; make new cell with neighbor's coordinates
                ; & push it first in the stack in front of current cell
                stack.insert(Cell(s, n.x, n.y))
                ; go back through, neighbor becomes current, current's state is saved in stack
                GoTo End
            }
        }
        ; all neighbors have been iterated through, current cell is done
        stack.remove()
        End:
    }
    return s
}
Cell(s,x,y) {
    c := []
    c.x := x
    c.y := y
    c.i := 0
    c.n := NeighborCells(s,x,y)
    return c
}
NeighborCells(s, x, y) {
    n := [{ x: x+1, y: y },{ x:x, y:y-1 },{ x:x-1, y:y },{ x:x, y:y+1 }]
    r := []
    loop 4
    {
        ins := n.remove(Rand(1, n.MaxIndex()))
        ; only include valid neighbor positions
        if (ins.x >= 1 && ins.x <= Width(s)//2 && ins.y >= 1 && ins.y <= Height(s)//2)
            r.insert(ins)
    }
    return r
}

SolveMaze( s, entr_x = 2, entr_y = 1, exit_x = "", exit_y = "", x="", y="", d="", w="", h="" ) {
    ; d: 1,2,3,4 == right, up, left, down
    if !w
        w := Width(s), h := Height(s)
    if !exit_x
        exit_x := w-1, exit_y := h
    if !x
    {
        s := SetChar(s, exit_x, exit_y, " ") ; make sure the exit point is a space
        x := entr_x, y := entr_y
    }
    while (x != exit_x || y != exit_y) && InStr(n := GetNeighbors(s,x,y,w,h), " ")
    {   ; ["→","↑","←","↓"] ["▶","▲","◀","▼"] ["▸","▴","◂","▾"]
        c := x=entr_x&&y=entr_y ? "∏" : ["▶","▲","◀","▼"][d+1] 
        s := SetChar(s, x, y, c)
        loop, parse, n
            if (A_LoopField == " ") {
                i:=A_Index-1, nx:=x+round(cos(i*1.5708)), ny:=y-round(sin(i*1.5708))
                if !cx ; carry to next iteration
                    cx := nx, cy := ny, cd := i
                else if s_ := SolveMaze(s, entr_x, entr_y, exit_x, exit_y, nx, ny, i, w, h)
                    return s_
            }
        x := cx, y := cy, d := cd, cx := 0
    }
    if (x == exit_x && y == exit_y)
        return SetChar(s, x, y, "▮")
}

Rand(f, l) {
    Random, r, f, l
    return r
}
GetChar(s, x, y){
	return SubStr(s, CharPos(s,x,y), 1)
}
SetChar(s, x, y, c, DEBUG=0) {
    p := CharPos(s,x,y)
	return SubStr(s, 1, p-1) c SubStr(s, p+1)
}
CharPos(s, x, y, r=0) {
    return (Width(s)+1+!!r)*(y-1)+x
}
Width(s) {
    return StrLen(SubStr(s,1,InStr(s,"`n")-1))
}
Height(s) {
    StringReplace, s, s, `n, `n, UseErrorLevel
    return ErrorLevel+1
}
GetNeighbors(s, x, y, w, h) {
    loop 4
    {
        x_ := x + (A_Index == 1 ?  1 : A_Index == 3 ? -1 : 0)
        y_ := y + (A_Index == 2 ? -1 : A_Index == 4 ?  1 : 0)
        if (x_ >= 1 && y_ >= 1 && x_ <= w && y_ <= h)
            ret .= GetChar(s,x_,y_)
        else
            ret .= "*"
    }
    return ret
}

CreateFont(Height, Width, Escapement, Orientation, Weight, Italic, Underline, StrikeOut, CharSet, OutputPrecision, ClipPrecision, Quality, PitchAndFamily, Face) {
    return DllCall("CreateFont", "int", Height
                               , "int", Width
                               , "int", Escapement
                               , "int", Orientation
                               , "int", Weight
                               , "uint", !!Italic
                               , "uint", !!Underline
                               , "uint", !!StrikeOut
                               , "uint", CharSet
                               , "uint", OutputPrecision
                               , "uint", ClipPrecision
                               , "uint", Quality
                               , "uint", PitchAndFamily
                               , "str", Face)
}


/* Group: About
	o Version 1.0 by majkinetor.
	o Licensed under BSD <http://creativecommons.org/licenses/BSD/>.
 */

/* Title:	Font
			
			This module can create font for in memory and return its handle that can be used with some Windows API's.
			It can also assign this font to the control, draw text on screen and measure it using <DrawText> with CALCRECT flag.
 */

/*
 Function:  Font
			Creates the font and optimally, sets it for the control.

 Parameters:
			HCtrl - Handle of the control. If omitted, function will create font and return its handle.
			Font  - AHK font definition ("s10 italic, Courier New"). If you already have created font, pass its handle here.
			BRedraw	  - If this parameter is TRUE, the control redraws itself. By default FALSE.

 Returns:	
			Font handle.
 */
Font(HCtrl="", Font="", BRedraw=false) {
	static WM_SETFONT := 0x30
	
	if Font is not integer
	{
		StringSplit, font, Font, `,,%A_Space%%A_Tab%	;fontStyle := font1, fontFace := font2

	  ;parse font 
		italic      := InStr(Font1, "italic")    ?  1    :  0 
		underline   := InStr(Font1, "underline") ?  1    :  0 
		strikeout   := InStr(Font1, "strikeout") ?  1    :  0 
		weight      := InStr(Font1, "bold")      ? 700   : 400 

	  ;height 
		RegExMatch(font1, "(?<=[S|s])(\d{1,2})(?=[ ,]*)", height) 
		ifEqual, height,, SetEnv, height, 10
;		RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels 
	    logPixels := DllCall("GetDeviceCaps", "uint", DllCall("GetDC", "uint", hGui), "uint", 90)	;LOGPIXELSY
		height := -DllCall("MulDiv", "int", height, "int", logPixels, "int", 72) 
	
		IfEqual, font2,,SetEnv Font2, MS Sans Serif

	 ;create font 
		hFont   := DllCall("CreateFont", "int",  height, "int",  0, "int",  0, "int", 0
						  ,"int",  weight,   "Uint", italic,   "Uint", underline 
						  ,"uint", strikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", font2, "Uint")
	} else hFont := Font
	ifNotEqual, HCtrl,,SendMessage, WM_SETFONT, hFont, BRedraw,,ahk_id %HCtrl%
	return hFont
}

/*
 Function: DrawText
		   Draws text using specified font on device context or calculates width and height of the text.

 Parameters: 
		Text	- Text to be drawn or measured. 
		DC		- Device context to use. If omitted, function will use Desktop's DC.
		Font	- If string, font description in AHK syntax. If number, font handle. If omitted, uses the system font to calculate text metrics.
		Flags	- Drawing/Calculating flags. Space separated combination of flag names.
		Rect	- Bounding rectangle. Space separated list of left,top,right,bottom coordinates. 
				  Width could also be used with CALCRECT WORDBREAK style to calculate word-wrapped height of the text given its width.
				
 Flags:
		BOTTOM, CALCRECT, CENTER, VCENTER, TABSTOP, SINGLELINE, RIGHT, NOPREFIX, NOCLIP, INTERNAL, EXPANDTABS, AHKSIZE.

		For the description of the flags see <http://msdn.microsoft.com/en-us/library/ms901121.aspx>.

 Returns:
		Decimal number. Width "." Height of text. If AHKSIZE flag is set, the size will be returned as w%w% h%h%

 */    
Font_DrawText(Text, DC="", Font="", Flags="", Rect="") {
	static DT_AHKSIZE:=0, DT_WORDBREAK:=0x10, DT_BOTTOM:=0x8, DT_CALCRECT:=0x400, DT_CENTER:=0x1, DT_VCENTER:=0x4, DT_TABSTOP:=0x80, DT_SINGLELINE:=0x20, DT_RIGHT:=0x2, DT_NOPREFIX:=0x800, DT_NOCLIP:=0x100, DT_INTERNAL:=0x1000, DT_EXPANDTABS:=0x40

	hFlag := (Rect = "") ? DT_NOCLIP : 0

	StringSplit, Rect, Rect, %A_Space%
	loop, parse, Flags, %A_Space%
		ifEqual, A_LoopField,,continue
		else hFlag |= DT_%A_LoopField%

	if Font is integer
		hFont := Font, bUserHandle := 1
	else if (Font != "")
		hFont := Font( "", Font) 
	else hFlag |= DT_INTERNAL

	IfEqual, hDC,,SetEnv, hDC, % DllCall("GetDC", "Uint", 0, "Uint")
	ifNotEqual, hFont,, SetEnv, hOldFont, % DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

	VarSetCapacity(RECT, 16)
	if (Rect0 != 0)
		loop, 4
			NumPut(Rect%A_Index%, RECT, (A_Index-1)*4)

	h := DllCall("DrawTextA", "Uint", hDC, "Str", Text, "int", StrLen(Text), "uint", &RECT, "uint", hFlag)

  ;clean
   	ifNotEqual, hOldFont,,DllCall("SelectObject", "Uint", hDC, "Uint", hOldFont) 
	ifNotEqual, bUserHandle, 1, DllCall("DeleteObject", "Uint", hFont)
	ifNotEqual, DC,,DllCall("ReleaseDC", "Uint", 0, "Uint", hDC) 

	return InStr(Flags, "AHKSIZE") ? "w" NumGet(RECT, 8) " h" h : NumGet(RECT, 8) "." h
}