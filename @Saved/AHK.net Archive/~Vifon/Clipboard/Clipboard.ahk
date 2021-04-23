	#NoEnv
	Hotkey <+<!<^c,Clipboard
Return

Clipboard:
	Hotkey ^s, SaveClip, On
	Hotkey <+<!<^c, Off
	Gui Add, Edit, x6 y9 w700 r15 vClipboard, ClipboardLook
	GuiControl Text, Clipboard, %Clipboard%
	Gui, Add, Button, x306 y217 w100 h30 gSaveClip , OK
	Gui, Add, Button, x36 y217 w70 h30 , Uppercase
	Gui, Add, Button, x116 y217 w70 h30 , Lowercase
	Gui, Add, Button, x516 y217 w70 h30 , Crop
	Gui, Add, Button, x596 y217 w80 h30 , Clear
	Gui +AlwaysOnTop
	Gui Show, w712, Clipboard
Return

ButtonUppercase:
	GuiControl Focus, Edit1
	GuiControlGet clip, ,Edit1
	StringUpper clip, clip
	GuiControl Text, Edit1, %clip%
	clip := ""
Return

ButtonLowercase:
	GuiControl Focus, Edit1
	GuiControlGet clip, ,Edit1
	StringLower clip, clip
	GuiControl Text, Edit1, %clip%
	clip := ""
Return

ButtonCrop:
	GuiControl Focus, Edit1
	GuiControl Text, Edit1, % GetSelection(1)
Return

ButtonClear:
	GuiControl Focus, Edit1
	GuiControl Text, Edit1
Return

SaveClip:
	Gui Submit
GuiClose:
GuiEscape:
	Gui Destroy
	Hotkey ^s, Off
	Hotkey <+<!<^c, On
Return



<+<!<^v::
	Clipboard =
	TrayTip ,, Clipboard and macros cleaned
	sleep 1500
	TrayTip
	MsgBox 4144, Clipboard, Clipboard cleaned.
Return

^+v::
	ClipPaste := Clipboard
	StringReplace ClipPaste, ClipPaste, ~, ~%A_Space%, 1
	Send {raw}%ClipPaste%
	ClipPaste =
Return
