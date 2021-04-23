#NoEnv
#Include, ref.ahk

Gui, Margin, 0, 0
Ref("BITMAP", A_ScriptName, 1, 0, 0, 500, 90, "Play")
Ref("ICON", A_ScriptName, 200, 0, 100, 32, 32)
Gui, Show, Center, Ref-Testgui
Return

GuiClose:
Exitapp

Play:
Loop, 5 {
	Ref("WAVE", A_ScriptName, 666, 1)
	Sleep, 1000
}
Return
