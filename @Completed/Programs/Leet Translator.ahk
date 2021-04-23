#NoEnv

SetBatchLines, -1

Gui, Add, Edit, x6 y10 w370 h20 vLeetAlpha gStartTranslate
Gui, Add, Edit, x6 y40 w370 h20 vAlphaLeet gStartTranslate
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w380 h75, The 1337 Translator
Return

GuiEscape:
GuiClose:
ExitApp

StartTranslate:
SetTimer, Translate, -300
Return

Translate:
GuiControlGet, Temp1, FocusV
If Temp1 = AlphaLeet
 Gosub, LeetToAlpha
Else
 Gosub, AlphaToLeet
Return

AlphaToLeet:
Gui, Submit, NoHide
Temp1 := AlphaToLeet(LeetAlpha)
GuiControl,, AlphaLeet, %Temp1%
Return

LeetToAlpha:
Gui, Submit, NoHide
Temp1 := LeetToAlpha(AlphaLeet)
GuiControl,, LeetAlpha, %Temp1%
Return

AlphaToLeet(String)
{
 Alphabet = abcdefghijklmnopqrst
 Leet = 48cd3f9hijk1mn0pqr57
 Loop, Parse, Alphabet
  StringReplace, String, String, %A_LoopField%, % SubStr(Leet,A_Index,1), All
 Return, String
}

LeetToAlpha(String)
{
 Alphabet = abcdefghijklmnopqrst
 Leet = 48cd3f9hijk1mn0pqr57
 Loop, Parse, Leet
  StringReplace, String, String, %A_LoopField%, % SubStr(Alphabet,A_Index,1), All
 Return, String
}