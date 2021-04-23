#NoEnv

FileName = %A_ScriptDir%\NotesList.txt

FileRead, FileList, %FileName%
Loop, Parse, FileList, `n
{
 SplitPath, A_LoopField,,,, Temp1
 WordList = %WordList%`n%Temp1%
 Temp2 = %A_Index%
}
StringTrimLeft, WordList, WordList, 1
StringReplace, WordList, WordList, `n, |, All
StringReplace, WordList, WordList, |, ||
Gui, Add, Text, x2 y0 w230 h20 +Center, Note:
Gui, Add, Edit, x2 y20 w230 h110 vNote
Gui, Add, Text, x2 y130 w20 h20, File:
Gui, Add, DropDownList, x22 y130 w130 h10 r%Temp2% AltSubmit vFile, %WordList%
Gui, Add, Button, x152 y130 w80 h20 Default, Add Note
Gui, +AlwaysOnTop
Gui, Show, w235 h155 Hide, Append Note
Return

GuiEscape:
GuiClose:
Gui, Hide
GuiControl,, Note
GuiControl, Choose, File, 1
GuiControl, Focus, Note
Return

ButtonAddNote:
Critical
Gui, Submit
Loop, Parse, FileList, `n
{
 If A_Index = %File%
  FileName = %A_LoopField%
}
Loop
{
 FileAppend, %Note%`n`n`n, %FileName%
 If ErrorLevel
 {
  MsgBox, 262164, File Error, Could not write file. Retry?
  IfMsgBox, No
  {
   Gui, Show
   Return
  }
 }
 Else
  Break
}
Return

+Space::Gui, Show