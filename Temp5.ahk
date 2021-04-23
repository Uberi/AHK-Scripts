Gui, Color, E0DEDE
Gui, Add, Progress, x10 y10 w180 h580 BackgroundD5D0D0, 0
    Gui, Font, c222222 s8 q4, Segoe UI
    Gui, Add, Progress, x20 y20 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y28 w60 h20 Center BackgroundTrans, File
    Gui, Add, Progress, x20 y60 w60 h30 BackgroundCAC3C3, 0
    Gui, Add, Text, x20 y68 w60 h20 Center BackgroundTrans, Edit
        Gui, Add, Progress, x100 y20 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y28 w80 h20 Center BackgroundTrans, Undo
        Gui, Add, Progress, x100 y60 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y68 w80 h20 Center BackgroundTrans, Redo
        Gui, Add, Progress, x100 y100 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y108 w80 h20 Center BackgroundTrans, Cut
        Gui, Add, Progress, x100 y140 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y148 w80 h20 Center BackgroundTrans, Copy
        Gui, Add, Progress, x100 y180 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y188 w80 h20 Center BackgroundTrans, Paste
        Gui, Add, Progress, x100 y220 w80 h30 BackgroundCAC3C3, 0
        Gui, Add, Text, x100 y228 w80 h20 Center BackgroundTrans, Find/Replace
        Gui, Add, Progress, x100 y260 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y268 w80 h20 Center BackgroundTrans, Autoindent
        Gui, Add, Progress, x100 y300 w80 h30 BackgroundE0DEDE, 0
        Gui, Add, Text, x100 y308 w80 h20 Center BackgroundTrans, Versions
    Gui, Add, Text, x20 y68 w60 h20 Center BackgroundTrans, Edit
    Gui, Add, Progress, x20 y100 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y108 w60 h20 Center BackgroundTrans, Tools
    Gui, Add, Progress, x20 y140 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y148 w60 h20 Center BackgroundTrans, Actions
    Gui, Add, Progress, x20 y180 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y188 w60 h20 Center BackgroundTrans, Window
    Gui, Add, Progress, x20 y220 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y228 w60 h20 Center BackgroundTrans, About
    
    Gui, Font, s10
    Gui, Add, Text, x20 y380 w50 h20 BackgroundTrans, Find
    Gui, Add, Progress, x70 y380 w110 h20
    Gui, Add, Text, x20 y410 w50 h20 BackgroundTrans, Replace
    Gui, Add, Progress, x70 y410 w110 h20
    
    Gui, Add, Progress, x20 y440 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x20 y445 w60 h20 Center BackgroundTrans, Search
    Gui, Add, Progress, x120 y440 w60 h30 BackgroundE0DEDE, 0
    Gui, Add, Text, x120 y445 w60 h20 Center BackgroundTrans, Replace
    
    Gui, Font, s12 c777777
    Gui, Add, Text, x20 y540 w160 h40 BackgroundTrans, Line 28`nColumn 5

Gui, Font, s10 c3F3333, Courier New
Gui, Add, Progress, x200 y10 w590 h540 BackgroundD5D0D0, 0
    Gui, Add, Text, x210 y20 w560 h520 BackgroundTrans, 
(
; Normal comment
/*
Block comment
*/

; Directives, keywords
#SingleInstance Force
#NoTrayIcon

; Command, literal text, escape sequence
MsgBox, Hello World `; This isn't a comment

; Operators
Bar = Foo  ; operators
Foo := Bar ; expression assignment operators

; String
Var := "This is a test"

; Number
Num = 40 + 4

; Dereferencing
Foo := `%Bar`%

; Flow of control, built-in-variables, BIV dereferencing
if true
	MsgBox, This will always be displayed
Loop, 3
	MsgBox Repetition #`%A_Index`%

; Built-in-function call
MsgBox `% SubStr("blaHello Worldbla", 4, 11)
)
    Gui, Add, Progress, x770 y80 w10 h60 BackgroundAA9999, 0

Gui, Font, s8 c555555, Segoe UI

Gui, Add, Progress, x200 y560 w80 h30 BackgroundCAC3C3, 0
Gui, Add, Text, x200 y568 w80 h20 Center BackgroundTrans, Test.ahk

Gui, Add, Progress, x290 y560 w80 h30 BackgroundD5D0D0, 0
Gui, Add, Text, x290 y568 w80 h20 Center BackgroundTrans, SomeFile.ahk

Gui, Add, Progress, x380 y560 w80 h30 BackgroundD5D0D0, 0
Gui, Add, Text, x380 y568 w80 h20 Center BackgroundTrans, Script.ahk

Gui, Show, w800 h600, AHK Studio v0.3 Beta - Test.ahk
Return

GuiClose:
ExitApp