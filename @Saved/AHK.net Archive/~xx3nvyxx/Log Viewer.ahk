;
; AutoHotkey Version: 1.0.45.2*
; Language:       English
; Platform:       Windows XP Professional*
; Author:         xx3nvyxx <xx3nvyxx@gmail.com>
;
;*tested on
;
; Script Function:
;	View and search html-type logs
;

;/**********************
;*   Global Settings   *
;**********************/
#Singleinstance, force
#NoEnv
SetBatchLines, -1
SetWinDelay, 0
DetectHiddenWindows, On
oldx := ""
oldy := ""
count := 0
OnExit, Cleanup

;/******************
;*   System Tray   *
;******************/
If (A_IsCompiled = 1)
	Menu, Tray, Nostandard
Else
	Menu, Tray, Icon, Logs.ico
Menu, Tray, Icon,,, 1
Menu, Tray, Add, Exit, exit

;/***************
;*   Password   *
;***************/
Inputbox, Pass, Password, A password is required to run., HIDE, 220, 120
If (pass != "cookie")
	{
	Msgbox,, Error, Invalid Password.
	ExitApp
	}

;/******************
;*   FileInstall   *
;******************/
FileInstall, log files\cwebpage.dll, cwebpage.dll, 1
If (A_IsCompiled = 1)
	{
	If (Errorlevel = 0)
		{
		FileSetAttrib, +H, cwebpage.dll
		}
	Else
		{
		Msgbox,, Error, The log viewer cannot be run from this location.
		ExitApp
		}
	}

;/******************
;*   Detect Logs   *
;******************/
filelist =
Loop, %A_WorkingDir%\log files\*.html, 0, 1
	{
	filelist := filelist . A_LoopFileName ","
	}
Sort, filelist, N \ D,
StringTrimRight, filelist, filelist, 1
Loop, parse, filelist, `,
	{
	If (A_index = 1)
		{
		StringLeft, date, A_LoopField, 10
		StringReplace, date, date, -,, A
		}
	Else
		Date2 := A_LoopField
	}
Stringleft, Date2, Date2, 10
StringReplace, Date2, Date2, -,, A
filelist =


;/***********
;*   Menu   *
;***********/
Menu, browserMenu, Add, Previous Log, Previous
Menu, browserMenu, Add, Next Log, Next

;/************
;*   Gui 1   *
;************/
Gui, 1:add, Text, x16 +Center, Double click the desired date or do a search.
Gui, 1:add, MonthCal, AltSubmit +0x1 x27 y25 24 gdblclick vDate Range%Date%-%Date2%, %Date%
Gui, 1:add, edit, x28 y165 w188 vsearch
Gui, 1:add, button, x73 y190 w98 Default, Search
Gui, 1:show, w244 h225, Logs %Date%-%Date2%
Gui +LastFound 
guiID := WinExist() 
ControlGet, mcID, Hwnd, , SysMonthCal321, ahk_id %guiID% 
gosub, bolddates
Return

;/*************************
;*   Closing Triggers 1   *
;*************************/
GuiEscape:
GuiClose:
ExitApp
return

;/**************************
;*   Double Clicked Date   *
;**************************/
dblclick:
If (A_GuiControlEvent = 1)
	{
	If (selected1 = date)
		{
		ctime := cl1 - A_TickCount
		If (ctime < 500)
			{
			Gui, 1:hide
			Mode = 1
			Gosub, Gui2
			}
		cl1 =
		ctime =
		}
	Else
		{
		cl1 = A_TickCount
		selected1 = %Date%
		}
	}
FormatTime, cmonth, %Date%, yyyy-MM
If (cmonth != month)
	GoSub, bolddates
Return

;/****************
;*   BoldDates   *
;****************/
bolddates:
VarSetCapacity(daysBuffer, 12, 0) 
FormatTime, month, %Date%, yyyy-MM
bolddays := ""
Loop, %A_WorkingDir%\log files\%month%-*.html, 0, 1
	{
	StringGetPos, pos, A_LoopFileLongPath, -, R
	StringLen, len, A_LoopFileLongPath
	pos := len - pos
	pos -= 3
	Stringtrimright, boldfile, A_LoopFileLongPath, %pos%
	StringRight, bolddate, boldfile, 2
	bolddays := bolddays . bolddate . ","
	}
Sort, bolddays, N U D,
addr := &daysBuffer + 4 
Loop, Parse, bolddays, `, 
	{ 
	o1 := (A_LoopField - 1) / 8 
	o2 := Mod(A_LoopField - 1, 8) 
	val := *(addr + o1) | (1 << o2) 
	DllCall("RtlFillMemory", "UInt", addr + o1, "UInt", 1, "UChar", val) 
	}
SetDayState: 
SendMessage, 0x1008, 3, &daysBuffer, , ahk_id %mcID%
Return


;/********************
;*   Search Button   *
;********************/
ButtonSearch:
Gui, 1:submit, nohide
If (search = "")
	{
	Msgbox, No searchable string entered.
	Return
	}
Else
	{
	Stringlen, len, search
	if (len < 3)
		{
		Msgbox, String too short.
		Return
		}
	Gui, 1:hide
	Mode = 2
	Gosub, Gui2
	}
Return

;/************
;*   Gui 2   *
;************/
gui2:
Gui, 2:Add, ListView, -LV0x10 -Multi R10 w536 gselectedlog, Date|Time|Medium|SN1|SN2|Chat Title
g2title := "Searching..."
Gui, 2:Show,, %g2title%
If (Mode = 1)
	gosub, search1
Else
	gosub, search2
Return

;/*************************
;*   Closing Triggers 2   *
;*************************/
2GuiEscape:
2GuiClose:
count = 0
Gui, 2:Destroy
Search := ""
Gui, 1:Show
return


;/***************
;*   Search 1   *
;***************/
search1:
Gui, 2:Default
FormatTime, file, %Date%, yyyy-MM-dd
Loop, %A_WorkingDir%\log files\%file%*.html, 0, 1
	{
	StringReplace, filepath, A_LoopFileLongPath, %A_WorkingDir%\log files\
	StringSplit, Array, filepath, \.
	If (Array3 <> "chat")
		Array6 = N/A
	StringLeft, hour, Array5, 2
	StringTrimLeft, Array5, Array5, 2
	StringLeft, minute, Array5, 2
	StringTrimLeft, Array5, Array5, 2
	StringLeft, second, Array5, 2
	Array5 = %hour%`:%minute%`:%second%
	LV_Add("", Array4, Array5, Array1, Array2, Array3, Array6)
	LV_ModifyCol("2", "Sort")
	count := LV_GetCount()
	g2newtitle = Searching... %count% found.
	WinSetTitle, %g2title%,, %g2newtitle%
	g2title = %g2newtitle%
	Sleep, 0
	}
Loop, 6
	LV_ModifyCol(A_Index, "AutoHdr")
If (count = 0)
	count = No
g2newtitle = Searching... Done! %count% log(s) found.
WinSetTitle, %g2title%,, %g2newtitle%
Return

;/***************
;*   Search 2   *
;***************/
search2:
Gui, 2:Default
Loop, %A_WorkingDir%\log files\*.html, 0, 1
	{
	FileRead, contents, %A_LoopFileLongPath%
	StringGetPos, pos, Contents, %search%
	If (Pos <> -1)
		{
		StringReplace, filepath, A_LoopFileLongPath, %A_WorkingDir%\log files\
		StringSplit, Array, filepath, \.
		If (Array3 <> "chat")
			Array6 := "N/A"
		StringLeft, hour, Array5, 2
		StringTrimLeft, Array5, Array5, 2
		StringLeft, minute, Array5, 2
		StringTrimLeft, Array5, Array5, 2
		StringLeft, second, Array5, 2
		Array5 := hour "`:" minute "`:" second
		LV_Add("", Array4, Array5, Array1, Array2, Array3, Array6)
		LV_ModifyCol("1", "Sort")
		Loop, 6
			LV_ModifyCol(A_Index, "AutoHdr")
		count := LV_GetCount()
		g2newtitle = Searching... %count% found.
		WinSetTitle, %g2title%,, %g2newtitle%
		g2title = %g2newtitle%
		}
	Sleep, 0
	If search =
		break
	}
If (count = 0)
	count = No
g2newtitle = Searching... Done! %count% log(s) found.
WinSetTitle, %g2title%,, %g2newtitle%
Loop, 6
	LV_ModifyCol(A_Index, "AutoHdr")
Return

;/******************
;*   Selected Log  *
;******************/
selectedlog:
if (A_GuiEvent = "DoubleClick")
	{
	Loop, 6
		{
		LV_GetText(Array%A_Index%, A_EventInfo, A_Index)
		}
	If (Array3 = "Medium")
		Return
	Gui, 2:hide
	StringReplace, Array2, Array2, `:,, A
	If (Array6 = "N/A")
		Array6 =
	Else
		Array6 := "."Array6
	filename := A_WorkingDir "\log files\" Array3 "\" Array4 "\" Array5 "\" Array1 "." Array2 Array6 ".html"
	FileRead, HTML2Load, %filename%
	If (search <> "")
		{
		StringLen, length, search
		replaced := ""
		Loop
			{
			StringCaseSense, off
			StringGetPos, pos, HTML2Load, %search%, L%A_Index%
			If (ErrorLevel = 1)
				Break
			pos += 1
			StringCaseSense, On
			StringMid, search, HTML2Load, %pos%, %length%
			If search in %replaced%
				Continue
			StringReplace, HTML2Load, HTML2Load, %search%, <font style="Background Color: yellow">%search%</font>, A
			If (replaced = "")
				Replaced := search
			Else
				replaced := replaced "," search
			}
		}
	Gosub, Gui3
	res := DLLCall("cwebpage\DisplayHTMLStr"
						, "uint", browserGuiHandle
						, "str", HTML2Load)
	If (res != 0 Or ErrorLevel != 0) ; error
		Goto, Cleanup
	HTML2Load =
	
	;Click the browser control to display whole page
	ControlClick,, ahk_id %browserGuiHandle%
	}
Return

;/************
;*   Gui 3   *
;************/
Gui3:
dll := 1
StringReplace, filename, filename, %A_WorkingDir%

; Load cwebpage.dll
cwebpageHandle := DllCall("LoadLibrary", "str", "cwebpage.dll") 

;Gui 3 position
If (oldx <> "")
	oldx := "x" oldx A_space
If (oldy <> "")
	oldy := "y" oldy A_space

; Parent window
Gui, 3: Add, text, y0 x0 w0 h0
Gui, 3:Show, %oldx%%oldy%w600 h400, [...]%filename%
WinGet, mainGuiHandle, ID, A

;; Child window for Browser object
Gui, 4:Margin, 0, 0
Gui, 4:+ToolWindow -Caption +Border
Gui, 4:Show, w590 h380
WinGet, browserGuiHandle, ID, A
; Set as child window to main gui
Gui, 4: +LastFound
DllCall("SetParent", "uint", WinExist(), "uint", mainGuiHandle)

; Create the Browser object
res := DLLCall("cwebpage\EmbedBrowserObject", "uint", browserGuiHandle)
If (res != 0 Or ErrorLevel != 0) ; error
  Goto, Cleanup

; Position the Browser "control" in the Gui
WinMove, ahk_id %browserGuiHandle%, , 4, 10

; Monitor for right clicks on browser control
; WM_CONTEXTMENU ; 0x7B
OnMessage(0x7B, "Web_WM_CONTEXTMENU")

Return

;/******************
;*   Right Click   *
;******************/
Web_WM_CONTEXTMENU(wParam, lParam)
	{
	mousegetpos,,,, name
	If (name = "Internet Explorer_Server1")
		Menu, browserMenu, Show
	}
Return

;/*************************
;*   Closing Triggers 3   *
;*************************/
3GuiEscape:
3GuiClose:
4GuiEscape:
WinGetPos, oldX, oldY,,, [...]%filename%
Gui, 3:Destroy
Gui, 2:Show
DLLCall("cwebpage\UnEmbedBrowserObject", "uint", browserGuiHandle)
DllCall("FreeLibrary", "uint", cwebpageHandle)
dll = 0
Return

;/*******************
;*   Menu Actions   *
;*******************/
Previous:
WinGetPos, oldX, oldY,,, [...]%filename%
filelist := ""
Loop, %A_WorkingDir%\log files\*.html, 0, 1
	{
	filelist = %filelist%%A_LoopFileLongPath%,
	}
Sort, filelist, N \ D,
filename = %A_WorkingDir%%filename%
StringGetPos, Pos, filelist, %filename%
If (pos = 0)
	{
	MsgBox, First Log Reached. Continuing with last log.
	StringTrimRight, filelist, filelist, 1
	StringGetPos, cdrive, filelist, C`:\, R
	StringTrimLeft, filename, filelist,%cdrive%
	}
Else
	{
	trim := StrLen(filelist) - Pos + 1
	StringTrimRight, filelist, filelist, %trim%
	StringGetPos, cdrive, filelist, C`:\, R
	StringTrimLeft, filename, filelist, %cdrive%
	}
filelist := ""
FileRead, HTML2Load, %filename%
If (search <> "")
	{
	StringLen, length, search
	replaced := ""
	Loop
		{
		StringCaseSense, off
		StringGetPos, pos, HTML2Load, %search%, L%A_Index%
		If (ErrorLevel = 1)
			Break
		pos += 1
		StringCaseSense, On
		StringMid, search, HTML2Load, %pos%, %length%
		If search in %replaced%
			Continue
		StringReplace, HTML2Load, HTML2Load, %search%, <font style="Background Color: yellow">%search%</font>, A
		If (replaced = "")
			Replaced := search
		Else
			replaced := replaced "," search
		}
	}
Gui, 3:Destroy
Gosub, Gui3
res := DLLCall("cwebpage\DisplayHTMLStr"
                  , "uint", browserGuiHandle
                  , "str", HTML2Load)
If (res != 0 Or ErrorLevel != 0) ; error
  Goto, Cleanup
HTML2Load =

;Click the browser control to display whole page
ControlClick,, ahk_id %browserGuiHandle%
Return

Next:
WinGetPos, oldX, oldY,,, [...]%filename%
filelist =
Loop, %A_WorkingDir%\log files\*.html, 0, 1
	{
	filelist = %filelist%%A_LoopFileLongPath%,
	}
Sort, filelist, N \ D,
filename = %A_WorkingDir%%filename%
StringGetPos, Pos, filelist, %filename%
length := StrLen(filelist) - StrLen(filename) - 1
If (pos = length)
	{
	MsgBox, Last Log Reached. Continuing with first log.
	StringGetPos, nextlog, filelist, `,C`:\
	StringLeft, filename, filelist, %nextlog%
	}
Else
	{
	Pos := StrLen(filename) + Pos + 1
	StringTrimLeft, filelist, filelist, %pos%
	StringGetPos, nextlog, filelist, `,C`:\
	StringLeft, filename, filelist, %nextlog%
	}
filelist =
FileRead, HTML2Load, %filename%
If (search <> "")
	{
	StringLen, length, search
	replaced := ""
	Loop
		{
		StringCaseSense, off
		StringGetPos, pos, HTML2Load, %search%, L%A_Index%
		If (ErrorLevel = 1)
			Break
		pos += 1
		StringCaseSense, On
		StringMid, search, HTML2Load, %pos%, %length%
		If search in %replaced%
			Continue
		StringReplace, HTML2Load, HTML2Load, %search%, <font style="Background Color: yellow">%search%</font>, A
		If (replaced = "")
			Replaced := search
		Else
			replaced := replaced "," search
		}
	}
Gui, 3:Destroy
Gosub, Gui3
res := DLLCall("cwebpage\DisplayHTMLStr"
                  , "uint", browserGuiHandle
                  , "str", HTML2Load)
If (res != 0 Or ErrorLevel != 0) ; error
  Goto, Cleanup
HTML2Load =

;Click the browser control to display whole page
ControlClick,, ahk_id %browserGuiHandle%
Return

;/******************
;*   Menu Labels   *
;******************/
Exit:
Exitapp
Return

;/**************
;*   Cleanup   *
;**************/
Cleanup:
If (dll = 1)
	{
	DLLCall("cwebpage\UnEmbedBrowserObject", "uint", browserGuiHandle)
	DllCall("FreeLibrary", "uint", cwebpageHandle)
	}
If (A_IsCompiled = 1)
	FileDelete, cwebpage.dll
ExitApp
Return