#NoEnv

Data = 
(
<html>
    <head>
        <title>Test Page</title>
    </head>
    <body>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
        <pre>Name = Uberi`nMsgBox, Hello`, `%Name`%!</pre>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    </body>
</html>
)
hWindow := WinExist("ahk_class SciTEWindow")
If Not hWindow
{
    MsgBox, Could not find SciTE4AutoHotkey window, required in order to syntax highlight code.
    ExitApp
}

FoundPos := 1, FoundPos1 := 1
While, (FoundPos := RegExMatch(Data,"S)<pre>([^<]+)</pre>",Match,FoundPos))
    Data1 .= SubStr(Data,FoundPos1,FoundPos - FoundPos1) . HighlightCode(Data,Match1,FoundPos), FoundPos += StrLen(Match), FoundPos1 := FoundPos
Data := Data1 . SubStr(Data,FoundPos1)
MsgBox % Data

HighlightCode(Page,Code,Position)
{
    global hWindow
    WinMenuSelectItem, ahk_id %hWindow%,, File, New
    Sleep, 100
    ClipboardOld := ClipboardAll, Clipboard := Code
    ControlSend, Scintilla1, {Ctrl Down}v{Ctrl Up}, ahk_id %hWindow%
    Clipboard := ClipboardOld
    Sleep, 100
    WinMenuSelectItem, ahk_id %hWindow%,, File, Export, As HTML
    WinWait, Export File As HTML ahk_class #32770
    FileDelete, %A_Temp%\Temp_Highlight.html
    ControlSetText, Edit1, %A_Temp%\Temp_Highlight.html
    ControlSend, Button1, {Enter}
    WinMenuSelectItem, ahk_id %hWindow%,, File, Close
    WinWait, SciTE4AutoHotkey ahk_class #32770
    ControlSend, Button1, !n
    FileRead, Temp1, %A_Temp%\Temp_Highlight.html
    RegExMatch(Temp1,"S)<span class=.*(?=</span>[^<]*</body>)",Code)
    Return, "<span class=""code"">" . Code . "</span>"
}