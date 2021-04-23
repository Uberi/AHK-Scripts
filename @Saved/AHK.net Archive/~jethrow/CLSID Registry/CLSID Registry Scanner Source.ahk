; http://blogs.msdn.com/b/vikas/archive/2009/04/09/howto-query-information-related-to-progid-clsid-verify-where-the-image-is-loaded-from-disk.aspx

{ ; AutoExecute:
	#NoTrayIcon
	SetBatchLines, -1
	title := "CLSID Registry Scanner"
	
	; Right Click Menu
	Menu, RClickMenu, Add, Copy CLSID, RClick
	Menu, RClickMenu, Add, Copy ProgID, RClick
	Menu, RClickMenu, Add  ; Add a separator line.
	Menu, RClickMenu, Add, Export Data, RClick
	
	; Find GUI Definition
	Gui 2: +AlwaysOnTop +ToolWindow
	Gui 2: Add, Edit, x6 y10 w270 h20 vFind 
	Gui 2: Add, Button, x65 y40 w60 h20 Default, Find
	Gui 2: Add, Button, x155 y40 w50 h20 , cancel

	; Main GUI Definition
	Gui, Add, ListView, x6 y10 w900 h350 AltSubmit -Multi -LV0x10 vLView gLView, Class ID|ProgID|Description
	Gui, Add, GroupBox, x6 y370 w900 h50 , Filter By:
	Gui, Font, s6 w600
	Gui, Add, Radio, x16 y385 w60 h15 checked vNormal, Normal
	Gui, Add, Radio, x16 y400 w60 h15 vRegEx, RegEx
	gui, font
	Gui, Add, Text, x86 y393 w40 h20 , ProgID:
	Gui, Add, Edit, x126 y390 w240 h20 vID
	Gui, Add, Text, x396 y393 w60 h20 , Description:
	Gui, Add, Edit, x456 y390 w240 h20 vDesc
	Gui, Add, Button, x716 y390 w80 h20 Default, Filter
	Gui, Add, Button, x806 y390 w80 h20 , Reset
	Gui, Add, StatusBar, gSBar
	SB_SetParts(100)
	entries := object(), n:=Normal:=1

	; Scan Registry
	GuiControl, -Redraw, LView
	Loop, HKCR, CLSID, 1
	{
		if ( SubStr(A_LoopRegName,1,1)="{" ) {
			RegRead, ProgID, HKCR, CLSID\%A_LoopRegName%\ProgID
			RegRead, Description, HKCR, %ProgID%
			LV_Add(	""
				,	entries[n,"CLSID"] := A_LoopRegName
				,	entries[n,"ProgID"] := ProgID
				,	entries[n++,"Description"] := Description	)
		}
	}
	GuiControl, +Redraw, LView
	LV_ModifyCol()
	Gui, Show, , % title " - " LV_GetCount() " Entries"
	GuiHwnd := WinExist("ahk_class AutoHotkeyGUI")
	Return
}

ButtonReset: ; when Reset Button is clicked
{
	; Reset GUI Fields & StatysBar
	GuiControl, , ID,
	GuiControl, , Desc,
	SB_SetText("",1)
	SB_SetText("",2)
	InprocServer32:=""
	LV_Delete()
	
	GuiControl, -Redraw, LView
	Gui, Show, , % title " - Loading Entries..."
	For, Each, item in entries
		LV_Add(	"",item.CLSID,item.ProgID,item.Description)
	GuiControl, +Redraw, LView
	LV_ModifyCol()
	Gui, Show, , % title " - " LV_GetCount() " Entries"
	return
}

ButtonFilter: ; when Filter Button is clicked
{
	Gui, Submit, NoHide
	GuiControl, -Redraw, LView
	LV_Delete()
	if Normal { ; Filter: Normal
		if ( ID<>"" && Desc<>"" ) {
			For, Each, item in entries
				if InStr(item.ProgID,ID) && InStr(item.Description,Desc)
					LV_Add("",item.CLSID,item.ProgID,item.Description)
		} else if ( ID<>"" ) {
			For, Each, item in entries
				if InStr(item.ProgID,ID)
					LV_Add("",item.CLSID,item.ProgID,item.Description)
		} else if ( Desc<>"" ) {
			For, Each, item in entries
				if InStr(item.Description,Desc)
					LV_Add("",item.CLSID,item.ProgID,item.Description)	
		}
	} else if RegEx { ; Filter: RegEx
		if ( ID<>"" && Desc<>"" ) {
			For, Each, item in entries
				if (item.ProgID ~= "i)" ID) && (item.Description ~= "i)" Desc)
					LV_Add("",item.CLSID,item.ProgID,item.Description)
		} else if ( ID<>"" ) {
			For, Each, item in entries
				if (item.ProgID ~= "i)" ID)
					LV_Add("",item.CLSID,item.ProgID,item.Description)
		} else if ( Desc<>"" ) {
			For, Each, item in entries
				if (item.Description ~= "i)" Desc)
					LV_Add("",item.CLSID,item.ProgID,item.Description)	
		}
	}
	GuiControl, +Redraw, LView
	LV_ModifyCol()
	if Not LV_GetCount()
		Loop, 3
			LV_ModifyCol(A_Index,100)
	Gui, Show, , % title " - " LV_GetCount() " Entries"
	return
}

LView: ; when ListViw control is clicked
{
	if ( A_GuiEvent="Normal" )
		UpdateSBar(A_EventInfo)
	return
}

UpdateSBar(row) { ; update the Status Bar
	global InProcServer32
	Gui 1: Default
	LV_GetText(ProgID,row,2)
	LV_GetText(CLSID,row,1)
	RegRead, Registered, HKCR, %ProgID%\CLSID
	RegRead, InprocServer32, HKCR, CLSID\%CLSID%\InprocServer32
	
	; Modify "InprocServer32", if necessary
	if (InprocServer32<>"")
		if Not FileExist(InprocServer32)
			if FileExist(A_WinDir "\system32\" InprocServer32)
				InProcServer32 := A_WinDir "\system32\" InprocServer32
	Loop, %InProcServer32%
		if FileExist(A_LoopFileLongPath)
			InProcServer32 := A_LoopFileLongPath
	StringReplace, InProcServer32, InProcServer32, `%SystemRoot`%, %SystemRoot%
	
	SB_SetText("Registered: " (Registered="" ? "NO":"YES"),1)
	SB_SetText(InprocServer32="" ? "" : "InProcServer: " InprocServer32,2)
}

SBar: ; when the StatusBar is Clicked
{
	if ( A_GuiEvent="DoubleClick" ) && (InprocServer32<>"")
		Run, % "explorer /select, " InProcServer32
	return
}

GuiContextMenu: ; when GUI is RightClicked
{
	if (A_GuiControl="LView")
		Menu, RClickMenu, Show
	return
}

RClick: ; when a RightClick Menu Item is selected
{
	if ( A_ThisMenuItem = "Copy CLSID" )
		LV_GetText(txt,LV_GetNext(),1)
		, Clipboard := txt
	else if (A_ThisMenuItem = "Copy ProgID" )
		LV_GetText(txt,LV_GetNext(),2)
		, Clipboard := txt
	else if ( A_ThisMenuItem = "Export Data" ) {
		SetTimer, SaveAs, -10
		FileSelectFile, FileName, S16, %A_ScriptDir%, Save As, Comma Delimited (*.csv)
		if ( FileName<>"" ) {	
			SaveTxt := "CLSID,ProgID,Description`r`n"
			Loop, % LV_GetCount() {
				row := A_Index
				Loop, 3 {
					LV_GetText(txt,row,A_Index)
					if InStr(txt,",")
						SaveTxt .= """" txt """" (A_Index=3 ? "`r`n":",")
					else
						SaveTxt .= txt (A_Index=3 ? "`r`n":",")
				}
			}
			FileName := RegExReplace(FileName,"i)\.csv$") ".csv"
			FileDelete, %FileName%
			FileAppend, %SaveTxt%, %FileName%
		}
	}
	return
}

SaveAs: ; remove "All Files" from File Type in "Save As" Window
{
	WinWaitActive, Save As ahk_class #32770, , 2
	Control, Delete, 2, ComboBox3, Save As
	return
}

#If WinActive("ahk_id" GuiHwnd)
{
^f:: ; find text in the ListView
{
	Gui 2: Show, x368 y260 w285 h65, % "  Find:"
	Return

	2ButtonFind:
		Gui 2: Submit
		Gui 1: Default
		Sel_Row := curr_row := LV_GetNext()
		curr_row++
		Loop {
			Loop, 3
				LV_GetText(col%A_Index%,curr_row,A_Index)
			if InStr(col1,Find) || InStr(col2,Find) || InStr(col3,Find)
				break
			else if ( curr_row>=LV_GetCount() )
				curr_row := 1
			else 
				curr_row++
		} Until (curr_row = Sel_Row)
		
		if (curr_row <> Sel_Row) {
			LV_Modify(curr_row, "Select")
			, LV_Modify(curr_row, "Focus")
			, LV_Modify(curr_row, "Vis")
			, UpdateSBar(curr_row)
			GuiControl, Focus, LView
		} else
			MsgBox, 0, No Match Found, The word "%Find%" could not be located.
		return
		
	2GuiClose:
	2Buttoncancel:
		Gui 2: Cancel
		return
}
#If
}

GuiClose:
	ExitApp

	
	

