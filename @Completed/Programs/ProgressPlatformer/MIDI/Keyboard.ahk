#NoEnv

StartIndex := 40

Gui, Add, Edit, x10 y10 w480 h480 vScrollback hwndhScrollback
Gui, Show, w500 h500, Note Keyboard

Device := new MIDIOutputDevice
Device.Sound := 9

KeyList = qwertyuiopasdfghjklzxcvbnm
Loop, Parse, KeyList
{
    Hotkey, %A_LoopField%, PlayNote
    Hotkey, %A_LoopField% Up, StopNote
}
Return

GuiEscape:
GuiClose:
ExitApp

Space::Clear()

PlayNote:
Index := StartIndex + InStr(KeyList,A_ThisHotkey) - 1
Device.NoteOn(Index,60)
Append("Note " . Index . "`n")
KeyWait, %A_ThisHotkey%
Return

StopNote:
Index := StartIndex + InStr(KeyList,SubStr(A_ThisHotkey,1,1)) - 1
Device.NoteOff(Index,60)
Return

Append(InputText)
{
    global hScrollBack
    SendMessage, 0x0E, 0, 0,, ahk_id %hScrollBack% ;WM_GETTEXTLENGTH
    SendMessage, 0xB1, ErrorLevel, ErrorLevel,, ahk_id %hScrollBack% ;EM_SETSEL
    SendMessage, 0xC2, 0, &InputText,, ahk_id %hScrollBack% ;EM_REPLACESEL
}

Clear()
{
    GuiControl,, Scrollback
}

#Include ..\Music.ahk