; autohotkey directives
#SingleInstance force
#NoEnv ; more speed
SetBatchLines, -1 ; more speed

; xml file
RCXmlFile := "Rosetta+Code-20090603051048.xml"
RCXmlFileURL := "http://rosettacode.org/files/" . RCXmlFile

; download xml file
IfNotExist, %RCXmlFile%
  UrlDownloadToFile, %RCXmlFileURL%, %RCXmlFile%

; create gui
Gui, +Resize MinSize620x420
Gui, Font, Bold
Gui, Add, Text, x10 y4 w340 vTxt1, XML file data, default sorted on RevTS (TimeStamp):


Gui, Add, Text, x360 y4 w200 cRed vLoading, XML file is loading... Please wait!

Gui, Font
Gui, Add, ListView, x10 y20 w600 h200 vRCLV gTriggerRCLV AltSubmit
      , Page|Title|PageId|RevId|RevTS|UserName|ContrId|Comment|IP|isMinor

; add info field
Gui, Font, Bold
Gui, Add, Text, x10 y230 w180 vTxt2, Row info:
Gui, Font
Gui, Add, Edit, x10 y250 w300 h160 vInfoField

; add <text> contents field
Gui, Font, Bold
Gui, Add, Text, x310 y230 w200 vTxt3, <text> contents:
Gui, Font
Gui, Add, Edit, x310 y250 w300 h160 vTxtField

; show gui
Gui, Show, w620 h420, RosettaCode Q&D Gui mashup

; prevent redraw because of filling the listview
GuiControl, -Redraw, RCLV

; variables
pageCount = 0
inPage = 0
inRev = 0
inContr = 0
inTxt = 0
isMinor = 0

; read xml file, line-by-line and fill listview
Loop, Read, %RCXmlFile%
{
  aLine := A_LoopReadLine
  If InStr(aLine, "<page>") != 0
  {
    If pageCount != 0
    {
      ; add <text> contents to array
      allTxt%pageCount% := allTxt
      ; add info to listview
      LV_Add("", pageCount, aTitle, aPageId, aRevId, aRevTS, aUserName, aContrId, aComment, aIP, isMinor)
    }
    pageCount++
    inPage = 1
    isMinor = 0
  }
  Else If InStr(aLine, "<title>") != 0
    aTitle := TagTxt(aLine, "title")
  Else If InStr(aLine, "<id>") != 0 ; 3 different IDs
  {
    If !inRev
      aPageId := TagTxt(aLine, "id")
    Else If inContr
      aContrId := TagTxt(aLine, "id")
    Else
      aRevId := TagTxt(aLine, "id")   
  }
  Else If InStr(aLine, "<revision>") != 0
    inRev = 1
  Else If InStr(aLine, "<timestamp>") != 0
    aRevTS := TagTxt(aLine, "timestamp")
  Else If InStr(aLine, "<contributor>") != 0
    inContr = 1
  Else If InStr(aLine, "<username>") != 0
    aUserName := TagTxt(aLine, "username")
  Else If InStr(aLine, "<ip>") != 0
    aIP := TagTxt(aLine, "ip")
  Else If InStr(aLine, "<comment>") != 0
    aComment := TagTxt(aLine, "comment")
  Else If InStr(aLine, "<minor/>") != 0
    isMinor = 1
  Else If InStr(aLine, "<text xml:space=""preserve"">") != 0
  {
    inTxt = 1
    txtStr = <text xml:space="preserve">
    firstTxtPos := InStr(aLine, txtStr)
    allTxt := SubStr(aLine, firstTxtPos + StrLen(txtStr)) . "`n"
  }
  Else If InStr(aLine, "</text>") != 0
    inTxt = 0
  Else If InStr(aLine, "</contributor>") != 0
    inContr = 0
  Else If InStr(aLine, "</revision>") != 0
    inRev = 0
  Else If inTxt
    allTxt .= aLine . "`n"
}

; set listview header widths
LV_ModifyCol(1, 40)
LV_ModifyCol(2, 140)
LV_ModifyCol(3, 50)
LV_ModifyCol(4, 50)
LV_ModifyCol(5, 130)
LV_ModifyCol(6, 80)
LV_ModifyCol(7, 50)
LV_ModifyCol(8, 140)
LV_ModifyCol(9, 100)

; sort listview by timestamp, newest first
LV_ModifyCol(5, "SortDesc") 

; enable redraw again
GuiControl, +Redraw, RCLV

GuiControl, , Loading, Done loading!

Return


TriggerRCLV:
If (A_GuiEvent = "I") ; click on listview
{
  currRow := LV_GetNext(0, "Focused")
  LV_GetText(thisPage, currRow, 1) 
  LV_GetText(thisTitle, currRow, 2)
  LV_GetText(thisPageId, currRow, 3)
  LV_GetText(thisRevId, currRow, 4)
  LV_GetText(thisRevTS, currRow, 5)
  LV_GetText(thisUserName, currRow, 6)
  LV_GetText(thisContId, currRow, 7)
  LV_GetText(thisComment, currRow, 8)
  LV_GetText(thisIP, currRow, 9)
  LV_GetText(thisIsMinor, currRow, 10)
  
  ; set InfoField
  allInfo =
  (LTrim Join`n
  Page = %thisPage%
  Title = %thisTitle%
  PageId = %thisPageId%
  RevId = %thisRevId%
  RevTS = %thisRevTS%
  UserName = %thisUserName%
  ContrId = %thisContId%
  Comment = %thisComment%
  IP = %thisIP%
  isMinor = %thisIsMinor%
  )
  GuiControl,, InfoField, % allInfo
  
  ; set TxtField
  GuiControl,, TxtField, % allTxt%thisPage%
}
Return

GuiSize:
  Anchor("RCLV", "wh")
  Anchor("InfoField", "y")
  Anchor("TxtField", "wy")
  Anchor("Txt2", "y")
  Anchor("Txt3", "y")
Return

GuiClose:
  ExitApp


TagTxt(Haystack, Tag)
{
  beforeString := "<" . Tag . ">"
  afterString := "</" . Tag . ">"
  foundAtPos := RegExMatch(Haystack
          , "is)\Q" . beforeString . "\E(.*?)\Q" . afterString . "\E"
          , result)
  Return result1
}

/*

	Function: Anchor
		Defines how controls should be automatically positioned relative to the new dimensions of a GUI when resized.
	
	Parameters:
		cl - a control HWND, associated variable name or ClassNN to operate on
		a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
				optionally followed by a relative factor, e.g. "x h0.5"
		r - (optional) true to redraw controls, recommended for GroupBox and Button types
	
	Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height
	
	Remarks:
		Anchor must always be called within a GuiSize label where AutoHotkey assigns a real value to A_Gui.
		The only exception is when the second and third parameters are omitted to reset the stored positions for a control.
		For a complete example see anchor-example.ahk.
	
	License:
		- Version 4.56 by Titan <http://www.autohotkey.net/~Titan/#anchor>
		- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

*/

Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If a =
	{
		StringLeft, gn, i, 2
		If gn contains :
		{
			StringTrimRight, gn, gn, 1
			t = 2
		}
		StringTrimLeft, i, i, t ? t : 3
		If gn is not digit
			gn := gx
	}
	Else gn := A_Gui
	If i is not xdigit
	{
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	gb := (gn - 1) * gs
	Loop, %cx%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			Else gx := A_Gui
			d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
				, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	If (!NumGet(g, gb)) {
		Gui, %gn%:+LastFound
		WinGetPos, , , , gh
		VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
			, NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
			, NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
	}
	Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	If cf = 1
	{
		Gui, %gn%:+LastFound
		WinGetPos, , , gw, gh
		d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
	}
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}