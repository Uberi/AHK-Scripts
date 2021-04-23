MODIFIED =20071213  1.03b
NAME1    =LVX_TITAN_103b
/*
................ Titan
................ http://www.autohotkey.com/forum/topic26541.html
................ a small example
                 -edit with rightclick columns, enter to save or escape
                 -add new
                 -delete marked lines
                 -start program with doubleclick
*/

setworkingdir, %a_scriptdir%

F11=File11.txt
ifnotexist,%F11%
   {
   fileappend,AAAA1;BBBB1`r`n,%F11%
   fileappend,AAAA2;BBBB2`r`n,%F11%
   fileappend,VOLUME;%A_windir%\system32\sndvol32.exe`r`n,%F11%
   fileappend,CHARMAP;%A_windir%\system32\charmap.exe`r`n,%F11%
   fileappend,AAAA5;BBBB5`r`n,%F11%
   fileappend,AAAA6;BBBB6`r`n,%F11%
   }

Gui,2:default
Gui,2:Font, s12
T1:=120
T2:=120
Gui,2:Add, ListView,  backgroundSilver  grid x100 y10  +hscroll altsubmit h200 w270  vMLV2A gMLV2B, A|B
LV_ModifyCol(1,T1)
LV_ModifyCol(2,T2)

gosub,filllistview
Gui,2:add,button,x4 y20 h25 w90 gCADD    ,ADD        ;button after LV
Gui,2:add,button,x4 y50 h25 w90 gCDELETE ,DELETE

Gui,2: Show,x100 y100 h240 w400,%name1%
Return


FillListview:
Gui,2:default
Gui,2:submit,nohide
Gui,2:ListView,MLV2A
LVX_Setup("MLV2A")
LV_Delete()
I=0
loop,read,%F11%
  {
  I++
  BX1=
  BX2=
  stringsplit,BX,A_LoopReadLine,`;,
  SplitPath,BX2,,,ext,,
  LV_Add("",BX1,BX2)
  if ext=exe                              ;when column2 is exe make it green
  LVX_SetColour(I, 0x008000)
  if I=1
  LVX_SetColour(I, 0xce0000, 0xffffff)    ;red    white   mark first row
  }
LVX_SetColour(I, 0xff8000, 0xffff00)    ;orange yellow last row

/*
LVX_SetColour(2, 0x008000)              ;green  swart
LVX_SetColour(3, 0xce0000, 0xffffff)    ;red    white
LVX_SetColour(5, 0xff8000, 0xffff00)    ;orange yellow
LVX_SetColour(6, 0xffffff, 0x0000bb)    ;       blue
LVX_SetColour(7, 0xffffff, 0x0000ff)    ;       blue
*/

return
;-----------------------------------------------------------------

MLV2B:
Gui,2:ListView,MLV2A
     RN:=LV_GetNext("C")
     RF:=LV_GetNext("F")
     GC:=LV_GetCount()
     if (RF="" OR RF=0)
     return

If A_GuiEvent = Normal
   {
   LV_GetText(C1,A_EventInfo,1)
   LV_GetText(C2,A_EventInfo,2)
   Return
   }


If A_GuiEvent = RightClick
   {
   LV_GetText(C1,A_EventInfo,1)
   LV_GetText(C2,A_EventInfo,2)
   LVX_CellEdit()
   sleep,200
   LV_GetText(C11,A_EventInfo,1)
   LV_GetText(C12,A_EventInfo,2)
   goto,CEDIT
   Return
   }


If A_GuiEvent = DoubleClick
   {
   LV_GetText(C21,A_EventInfo,1)
   LV_GetText(C22,A_EventInfo,2)
   ifexist,%C22%
       run,%C22%
   Return
   }
return


2GuiClose:
ExitApp


CEDIT:
Gui,2:submit,nohide
  FileRead, fcx, %F11%
  FileDelete, %F11%
  StringReplace, fcx, fcx, %C1%`;%C2%,%C11%`;%C12%
  FileAppend, %fcx%, %F11%
  Gosub, FillListView
return


;------------------ ADD --------------------------------------
CADD:
Gui,2:submit,nohide
Gui,11:Font,  S10 CDefault , FixedSys
Gui,11:Add,Text, x1  y5   w80  h20, A
Gui,11:Add,Edit, x80 y5   w500 h20 vA31,

Gui,11:Add,Text, x1  y30  w80  h20, B
Gui,11:Add,Edit, x80 y30  w500 h20 vA32,

Gui,11:Add, Button, x550 y60 w40 h25, OK
Gui,11:Show, x2 y100 w600 h95, NEW11
GuiControl,11:Focus,A31
return
;---------------------------------------
11GuiClose:
11GuiEscape:
Gui,11:Destroy
return

11ButtonOK:
Gui,11:submit
FILEAPPEND,%A31%`;%A32%`r`n,%F11%
Gui,11: Destroy
gosub,FillListview
return
;----------------------------------------------




;------------------ DELETEMULTIPLE Lines in file F4 ------------------
CDELETE:
C1x=
RF = 0
RFL =
Loop
   {
   RF:=LV_GetNext(RF)
   if RF=0
      break
   RFL = %RF%|%RFL%
   LV_GetText(C1_Temp, RF, 1)
   C1x = %C1x%`n%C1_Temp%
  }

if C1x !=
  {
   MsgBox, 4, ,Want you delete these lines in textfile %F11%`n%C1x% ?
   IfMsgBox,No
      Return
   Else
     {

      Loop, parse, RFL, |
             {
             LV_Delete(A_LoopField)
             }

     filedelete,%F11%
     Loop % LV_GetCount()
            {
            BX1=
            BX2=
            LV_GetText(BX1,A_INDEX,1)
            LV_GetText(BX2,A_INDEX,2)
            fileappend,%BX1%;%BX2%`r`n,%F11%
            }
       }

  }
gosub,filllistview
return
;------------------ END DELETE ------------------------------------





;====================== 1.03b  ESC ENTER NumpadEnter ===============================================================
/*
		Title: LVX Library

		Row colouring and cell editing functions for ListView controls.

		Remarks:
			Cell editing code adapted from Michas <http://www.autohotkey.com/forum/viewtopic.php?t=19929>;
			row colouring by evl <http://www.autohotkey.com/forum/viewtopic.php?t=9266>.
			Many thanks to them for providing the code base of these functions!

		License:
			- Version 1.03b by Titan <http://www.autohotkey.net/~Titan/#lvx>
			- zlib License <http://www.autohotkey.net/~Titan/zlib.txt>
*/

/*

		Function: LVX_Setup
			Initalization function for the LVX library. Must be called before all other functions.

		Parameters:
			name - associated variable name (or Hwnd) of ListView control to setup for colouring and cell editing.

*/
LVX_Setup(name) {
	global lvx
	If name is xdigit
		h = %name%
	Else GuiControlGet, h, Hwnd, %name%
	VarSetCapacity(lvx, 4 + 255 * 9, 0)
	NumPut(h + 0, lvx)
	OnMessage(0x4e, "WM_NOTIFY")
	LVX_SetEditHotkeys() ; initialize default hotkeys
}

/*

		Function: LVX_CellEdit
			Makes the specified cell editable with an Edit control overlay.

		Parameters:
			r - (optional) row number (default: 1)
			c - (optional) column (default: 1)
			set - (optional) true to automatically set the cell to the new user-input value (default: true)

*/
LVX_CellEdit(set = true) {
	global lvx, lvxb
	static i = 1, z = 48, e, h, k = "Enter|Esc|NumpadEnter"
	If i
	{
		Gui, %A_Gui%:Add, Edit, Hwndh ve Hide
		h += i := 0
	}
	If r < 1
		r = %A_EventInfo%
	If !LV_GetNext()
		Return
	If !(A_Gui or r)
		Return
	l := NumGet(lvx)
  SendMessage, 4135, , , , ahk_id %l% ; LVM_GETTOPINDEX
  vti = %ErrorLevel%
  VarSetCapacity(xy, 16, 0)
  by = 0
  ControlGetPos, bx, by, , , , ahk_id %l%
  bh = 0
  bw = 0
  bpw = 0
  bp = 0
  SendMessage, 4136, , , , ahk_id %l% ; LVM_GETCOUNTPERPAGE
  Loop, %ErrorLevel% {
  	cr = %A_Index%
		NumPut(cr - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
		SendMessage, 4152, vti + cr - 1, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
		If !bph
			bph := by - NumGet(xy, 4)
		by += bh := NumGet(xy, 12) - NumGet(xy, 4)
		If (LV_GetNext() - vti == cr)
			Break
	}
	cr--
	by -= bh - Ceil(bph / 2)
  VarSetCapacity(xy, 16, 0)
  CoordMode, Mouse, Relative
  MouseGetPos, mx
  Loop, % LV_GetCount("Col") {
		cc = %A_Index%
		NumPut(cc - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
		SendMessage, 4152, cr, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
		bx += bw := NumGet(xy, 8) - NumGet(xy, 0)
		If !bpw
			bpw := NumGet(xy, 0)
		If (mx <= bx)
			Break
	}
	bx -= bw - bpw
	LV_GetText(t, cr + 1, cc)
	GuiControl, , e, %t%
	GuiControl, Move, e, x%bx% y%by% w%bw% h%bh%
	GuiControl, Show, e
	GuiControl, Focus, e
	VarSetCapacity(g, z, 0)
	NumPut(z, g)
	LVX_SetEditHotkeys(~1, h)
	Loop {
		DllCall("GetGUIThreadInfo", "UInt", 0, "Str", g)
		If (lvxb or NumGet(g, 12) != h)
			Break
		Sleep, 100
	}
	GuiControlGet, t, , e
	If (set and lvxb != 2)
		LVX_SetText(t, cr + 1, cc)
	GuiControl, Hide, e
	Return, lvxb == 2 ? "" : t
}

_lvxc:
lvxb++
_lvxb:
lvxb++
LVX_SetEditHotkeys(~1, -1)
Return

LVX_SetText(text, row = 1, col = 1) {
	global lvx
	l := NumGet(lvx)
	row--
	VarSetCapacity(d, 60, 0)
	SendMessage, 4141, row, &d, , ahk_id %l%  ; LVM_GETITEMTEXT
	NumPut(col - 1, d, 8)
	NumPut(&text, d, 20)
	SendMessage, 4142, row, &d, , ahk_id %l% ; LVM_SETITEMTEXT
}

LVX_SetEditHotkeys(enter = "Enter,NumpadEnter", esc = "Esc") {
	global lvx, lvxb
	static h1, h0
	If (enter == ~1) {
		If esc > 0
		{
			s = On
			lvxb = 0
			Hotkey, IfWinNotActive, ahk_id %esc%
		}
		Else s = Off
		Loop, Parse, h1, `,
			Hotkey, %A_LoopField%, _lvxb, %s%
		Loop, Parse, h0, `,
			Hotkey, %A_LoopField%, _lvxc, %s%
		Hotkey, IfWinActive
		Return
	}
	If enter !=
		h1 = %enter%
	If esc !=
		h0 = %esc%
}

/*

		Function: LVX_SetColour
			Set the background and/or text colour of a specific row on a ListView control.

		Parameters:
			index - row index (1-based)
			back - (optional) background row colour, must be hex code in RGB format (default: 0xffffff)
			text - (optional) similar to above, except for font colour (default: 0x000000)

		Remarks:
			Sorting will not affect coloured rows.

*/
LVX_SetColour(index, back = 0xffffff, text = 0x000000) {
	global lvx
	a := (index - 1) * 9 + 5
	NumPut(LVX_RevBGR(text) + 0, lvx, a)
	If !back
		back = 0x010101 ; since we can't use null
	NumPut(LVX_RevBGR(back) + 0, lvx, a + 4)
	h := NumGet(lvx)
	WinSet, Redraw, , ahk_id %h%
}

/*

		Function: LVX_RevBGR
			Helper function for internal use. Converts RGB to BGR.

		Parameters:
			i - BGR hex code

*/
LVX_RevBGR(i) {
	Return, (i & 0xff) << 16 | (i & 0xffff) >> 8 << 8 | i >> 16
}

/*
		Function: LVX_Notify
			Handler for WM_NOTIFY events on ListView controls. Do not use this function.
*/
LVX_Notify(wParam, lParam, msg) {
	global lvx
	If (NumGet(lParam + 0) == NumGet(lvx) and NumGet(lParam + 8, 0, "Int") == -12) {
		st := NumGet(lParam + 12)
		If st = 1
			Return, 0x20
		Else If (st == 0x10001) {
			a := NumGet(lParam + 36) * 9 + 9
			If NumGet(lvx, a)
      	NumPut(NumGet(lvx, a - 4), lParam + 48), NumPut(NumGet(lvx, a), lParam + 52)
		}
	}
}


WM_NOTIFY(wParam, lParam, msg, hwnd) {
	; if you have your own WM_NOTIFY function you will need to merge the following three lines:
	global lvx
	If (NumGet(lParam + 0) == NumGet(lvx))
		Return, LVX_Notify(wParam, lParam, msg)
}

;====================================== END FUNCTION ==================================================






