;Mutated from: Martin O'Neills Excellent Numberpad Idea.
;KeyPad by bLisTeRinG v0.2 aug2006

#NoTrayIcon
SetTimer GetActiveWindow

;Gui, -Caption 
gui Color, Green, Yellow
gui +AlwaysOnTop
gui, font, S10, Arial Narrow
Gui Add, DropDownList, x5   y2  w30 h10 R4  gButton, a||b|c|d|
Gui Add, DropDownList, x34  y2  w30 R4  gButton, e||f|g|h|
Gui Add, DropDownList, x65  y2  w30 R6  gButton, i||j|k|l|m|n|
Gui Add, DropDownList, x96  y2  w30 R6  gButton, o||p|q|r|s|t|
Gui Add, DropDownList, x127 y2  w30 R6  gButton, u||v|w|x|y|z|
gui, font, S8, Arial Narrow
Gui Add, DropDownList, x5 y28 w34 h12 R12 gButton, F1||F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|
gui font, Cred S9, Arial Narrow
Gui Add, Button, x44  y29  w36 h21 gButton, Space
gui font,  CPurple) S12
Gui Add, Button, x83  y29  w36 h21 gButton, TAB
gui, font, S10, Arial Narrow
Gui Add, DropDownList, x122 y28 w35 R22 h10 gButton, .||,|;|:|\|~|!|@|#|$|^|&|(|)|?|`"|`'|
gui font, S14, Arial Bold
Gui Add, Button, x5   y52  w36 h29 gButton, 7
Gui Add, Button, x5   y82  w36 h29 gButton, 4
Gui Add, Button, x5   y112 w36 h29 gButton, 1
gui font, Arial Bold S20
Gui Add, Button, x5   y142 w17 h29 gButton vBS, «
Gui Add, Button, x24  y142 w17 h29 gButton vDel, »
gui font, Arial Bold S14
Gui Add, Button, x44  y52  w36 h29 gButton, 8
Gui Add, Button, x44  y82  w36 h29 gButton, 5
Gui Add, Button, x44  y112 w36 h29 gButton, 2
Gui Add, Button, x44  y142 w36 h29 gButton, 0
Gui Add, Button, x83  y52  w36 h29 gButton, 9
Gui Add, Button, x83  y82  w36 h29 gButton, 6
Gui Add, Button, x83  y112 w36 h29 gButton, 3
Gui Add, Button, x83  y142 w36 h29 gButton, =
Gui Add, Button, x122 y52  w36 h29 gButton, /
Gui Add, Button, x122 y82  w36 h29 gButton, *
Gui Add, Button, x122 y112 w36 h29 gButton, -
Gui Add, Button, x122 y142 w36 h29 gButton, +
Gui Add, Button, x5   y172 w75 h29 gButton, Esc
Gui Add, Button, x83  y172 w75 h29 gButton, Enter

Gui Show, x446 y364 h205 w160, Key±Pad
WinActivate Key±Pad
WinGet KPID, ID, A
return

; SEND KEYS
Button:
   WinActivate ahk_id %LastID%
   Send {%A_GuiControl%}
Return

; SEND STRING
Word:
   WinActivate ahk_id %LastID%
   Send {veniceflo}

Return
; PrintScreen?

GuiClose:
ExitApp

GetActiveWindow:
   WinGet ID, ID, A
   IfNotEqual ID,%KPID%, SetEnv LastID,%ID%
Return