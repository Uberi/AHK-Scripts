#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%
SendMode Input
IniRead browser, Translator.ini, Translator, Browser, %A_Space%

if browser
{
	Gui Add, Edit, x6 y49 w504 r1 -WantReturn vwords, 
	Gui Add, Button, x133 y79 w100 h30 default gOK , OK
	Gui Add, Button, x283 y79 w100 h30 gGuiClose, Cancel
	Gui Add, Radio, x16 y15 r1 gEN, PL<->EN
	Gui Add, Radio, x136 y15 r1 gDE, PL<->DE
	Gui Add, Radio, x256 y15 r1 gFR, PL<->FR
	Gui Add, Radio, x376 y5 r1 gGoogleTrEn checked, Google Translate EN
	Gui Add, Radio, x376 y25 r1 gGoogleTr, Google Translate Auto
	lang = GoogleEn

	Gui +LastFound
	WinSet Transparent, 200
	WinSet AlwaysOnTop, On
	Gui Show, h116 w516, Translator
	Hotkey #Enter, Translate
	Return
}

Gui 2: Add, Text, x156 y9 w160 h20 , What is your default browser?
Gui 2: Add, Button, x46 y59 w100 h30 gIE, Internet Explorer
Gui 2: Add, Button, x187 y59 w100 h30 gFx, Mozilla Firefox
Gui 2: Add, Button, x326 y59 w100 h30 gOp, Opera
Gui 2: Add, Button, x187 y109 w100 h30 gnope, Safari
Gui 2: Add, Button, x46 y109 w100 h30 gGC, Google Chrome
Gui 2: Add, Button, h167 w479 gnope, Other

Gui 2: Show, h186 w477, Select Browser
Return

nope:
	Gui 2: +OwnDialogs
	MsgBox 48, Sorry, Sorry`, not supported yet.
ExitApp

IE:
	browser = IEFrame
	GoSub BrowserSubmit
	Reload
Return

Fx:
	browser = MozillaUIWindowClass
	GoSub BrowserSubmit
	Reload
Return

Op:
	browser = OpWindow
	GoSub BrowserSubmit
	Reload
Return

GC:
	browser = Chrome_XPFrame
	GoSub BrowserSubmit
	Reload
Return


BrowserSubmit:
	IniWrite %browser%, Translator.ini, Translator, Browser
	MsgBox 4160, Readme, After you click OK, press WinKey+Enter to show main window.
Return

;====================!Main Part====================
Translate:
	Hotkey #Enter, Off
	GuiControl Text, Edit1, % GetSelection(1)
	GuiControl Focus, Edit1
	Gui Show
Exit

EN:
	lang = ang
	GuiControl Focus, Edit1
Return

DE:
	lang = nie
	GuiControl Focus, Edit1
Return

FR:
	lang = fra
	GuiControl Focus, Edit1
Return

GoogleTrEn:
	lang = GoogleEn
	GuiControl Focus, Edit1
Return

GoogleTr:
	lang = Google
	GuiControl Focus, Edit1
Return

OK:
	Gui Submit
	StringReplace words, words, a, `%B1, 1
	StringReplace words, words, e, `%EA, 1
	StringReplace words, words, s, `%B6, 1
	StringReplace words, words, c, `%E6, 1
	StringReplace words, words, z, `%BF, 1
	StringReplace words, words, z, `%BC, 1
	StringReplace words, words, n, `%F1, 1
	StringReplace words, words, l, `%B3, 1
	StringReplace words, words, ó, `%F3, 1
	StringReplace words, words, ö, `%F6, 1
	StringReplace words, words, ü, `%FC, 1
	StringReplace words, words, ä, `%E4, 1
	Loop Parse, words, `,, %A_Space%%A_Tab%
	{
		if (lang = "GoogleEn")
			Run http://translate.google.com/translate_t#en|pl|%A_LoopField%
		else if (lang = "Google")
			Run http://translate.google.com/translate_t#auto|pl|%A_LoopField%
		WinWait ahk_class %browser%, , 30
	}
	GuiControl Text, words
	Hotkey #Enter, On
Return

GuiEscape:
GuiClose:
	Gui Hide
	Hotkey #Enter, On
Return


GetSelection(wait = "")
{
	ClipBack := ClipboardAll
	Clipboard := ""
	Send ^c
	if wait
		ClipWait 0.05
	Selection := Clipboard
	Clipboard := ClipBack
	Return Selection
}
