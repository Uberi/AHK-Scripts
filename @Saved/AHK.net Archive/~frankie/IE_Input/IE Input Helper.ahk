; IE Input Helper
; This script is useful for logging into websites through COM with AutoHotkey_L
; Script by Frankie		Forum topic: <link here>
; Thanks to tidbid for helping on IRC and to a4u and sinkfaze 
; for helping with the regex
; Use:
;	Run it and type in the URL of the site you are trying to enter data into
;	Press the 'LAbel Website Fields' button
;	Now IE should open and each field and button will have a number
;	Those numbers are in the ListView and you can assign the fields values and 
;	clicks to the buttons
;	When done save or copy your script, thats it.
; Enjoy!
SetWorkingDir, %A_ScriptDir%
OnExit, ExitSub
SysGet, Mon, MonitorWorkArea
W := (MonRight - MonLeft) // 3 - 5
H := (MonBottom - MonTop) - 30
X := W*2
Y := 0
Gui, Font, s14
Gui, Add, Button, % "x" (W*1//10) " y10 gChangeLabels Default", Label Website Fields
Gui, Add, Button, % "x" (W*7//10) " y10 gStartOver", Restart
Gui, Add, ListView, % "gLVAction x10 y70 w" . (W*0.95) . " h" . (LVH:=(H+30)*3//10)
, #     |Name                           |Type
Gui, Add, Edit, % "vValue w" (W*5//10) " x" (W*3//10) " y" (VY:=LVH+75), Value
Gui, Add, Text, % "right x" (W*1//10) " y" (VY) " w" (W*2//10-10), Text:
Gui, Add, ListBox, % "gRemoveItem vCodeOut AltSubmit x10 y" . (LBY:=120+LVH) 
. " w" . (W*0.95) . " h" . (LBH:=H-(LVH+100)-(H*1//10))
Gui, +Delimiter`n
Gui, Add, Button, % "gSaveCode x" . (W*1//10) . " y" . (SBY:=LBY+LBH+5), Save
Gui, Add, Button, % "gCopyCode x" . (W*3//10) . " y" . (SBY), Copy
Gui, Add, Button, % "gRemoveItemButton x" . (W*5//10) . " y" . (SBY), Remove

; URL Prompt, it's displayed first
Gui, 2: Margin, 0, 0
If FileExist("Web.jpg")
	Gui, 2: Add, Picture, w300 h100, Web.jpg
Gui, 2: Font, s14
Gui, 2: Add, Edit, vURL +BackgroundTrans x30 y30 w240, www.
Gui, 2: Add, Button, x500 y150 gEnterURL Default, Hidden_Button
Gui, 2: Show, w300 h100, Enter the URL
return

SetCode(Code="") {
	GuiControl,, CodeOut, `n%Code%
}

; -----------------------------------------------------------------------------
; Triggered when enter is pressed in URL windows
; -----------------------------------------------------------------------------
EnterURL:
Gui, 2: Submit
pwb := ComObjCreate("InternetExplorer.Application")
pwb.Silent := true
pwb.Navigate(URL)
pwb.Left := 0, pwb.Top := 0
, pwb.Width := W*2-15, pwb.Height := H+30
While pwb.readystate != 4
	Sleep 100
Gui, 1: Show, +LastFound w%W% h%H% x%X% y%Y%, IE Input Helper
DllCall("SetParent", "uint", WinExist(), "uint", pwb.HWND)
Code =
(LTrim Join`r`n
	pwb := ComObjCreate("InternetExplorer.Application")
	pwb.Visible := true
	pwb.Navigate("%URL%")
	While (pwb.readyState != 4)
	`tSleep 100
	
)
return

; -----------------------------------------------------------------------------
; Label of change labels button
; Shows IE/website, reassigns all input fields, lists their values in LV
; -----------------------------------------------------------------------------
ChangeLabels:
While pwb.readystate != 4
	Sleep 100
HTML := pwb.Document.body.innerhtml
Pos=1
N = is)<input \K[^>]+ ; Match properites of an <input> tag
Inputs := Object()
LV_Delete() ; Clear the Listview
While   Pos :=   RegExMatch(HTML, N, M, Pos + StrLen(M))
{
	i := A_Index
	Loop, Parse, M, %A_Space%, `n`r
	{
		StringSplit, Part, A_LoopField, =
		Inputs[i, Part1] := Part2
	}
	LV_Add("", "#" i, Inputs[i, "id"], Inputs[i, "type"])
	If (id := Inputs[i, "id"])
	{
		pwb.document.all(id).value := i
	}
}
pwb.Visible := true
return

; -----------------------------------------------------------------------------
; Detects double clicks on the ListView
; When this happens we want to add code for that object to ListBox
; -----------------------------------------------------------------------------
LVAction:
If A_GuiEvent != DoubleClick
	return
GuiControlGet, Value,, Value ; The value the user entered, usually a username or password
i := A_EventInfo
type := Inputs[i, "type"]
If (type = "submit")
	Code .= "pwb.document.all." . Inputs[i, "id"] . ".click()`r`n"
else if (type = "text") || (type = "password")
	Code .= "pwb.document.all." . Inputs[i, "id"] . ".value := """ Value """`r`n"
SetCode(Code)
return

; -----------------------------------------------------------------------------
; Delete one selected line of code
; RemoveItem is for double clicks on the ListBox
; RemoveItemButton is for selecting a line of code and clicking Remove button
; -----------------------------------------------------------------------------
RemoveItem:
If A_GuiEvent != DoubleClick
	return
RemoveItemButton:
GuiControlGet, Pos,, CodeOut
CodeOld := Code
Code := ""
Loop, Parse, CodeOld, `n, `r
	Code .= (A_Index = Pos ? "" : A_LoopField . "`r`n")
StringReplace, Code, Code, `r`n`r`n, `r`n, All
SetCode(Code)
return

; -----------------------------------------------------------------------------
; Save the code in the ListBox to a file, triggered by Save button
; -----------------------------------------------------------------------------
SaveCode:
FileSelectFile, Path, S, %A_MyDocuments%\Output.ahk, Save your script, AutoHotkey Scripts (*.ahk, *.txt)
If !Path
	return
If !InStr(Path, ".ahk") and !InStr(Path, ".txt")
	Path .= ".ahk"
FileDelete, %Path%
FileAppend, %Code%, %Path%
return

; -----------------------------------------------------------------------------
; Copy ListBox code to clipboard
; A msgbox pops up telling what code was coppied
; -----------------------------------------------------------------------------
CopyCode:
Clipboard := Code
; Confirm copied code
CodeDisplay := ">> " . RegExReplace(Code, "`n(.)", "`n>> $1") 
; Put a '>>' before each line
Msgbox, 0, Copy to Clipboard, The code was copied sucessfully.`n%CodeDisplay%
return

; -----------------------------------------------------------------------------
; Subs for handling changes in program state
; -----------------------------------------------------------------------------
StartOver:
Reload
return

GuiClose:
2GuiClose:
ExitApp
return

ExitSub:
ComObjError(false)
pwb.Quit()
pwb = 
ExitApp
return