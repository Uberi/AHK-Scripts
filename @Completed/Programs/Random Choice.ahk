#NoEnv

Gui, Font, s16 Bold, Arial
Gui, Add, Text, x2 y0 w440 h30 Center, Enter a list of choices:
Gui, Add, Edit, x2 y30 w440 h30 vItemList gChooseItem, Red`, Green`, Blue
Gui, Add, Text, x2 y70 w440 h30 Center, The item chosen is:
Gui, Font, s44
Gui, Add, Text, x2 y100 w440 h80 vItemChoice Center, Green
Gui, +ToolWindow +AlwaysOnTop
Gosub, ChooseItem
Gui, Show, w445 h185, Random Item Chooser
Return

GuiEscape:
GuiClose:
ExitApp

ChooseItem:
GuiControlGet, ItemList,, ItemList
StringReplace, ItemList, ItemList, %A_Tab%, %A_Space%, All
ItemList = %ItemList%
ItemList := RegExReplace(ItemList,"S) *, *",",")
If (SubStr(ItemList,1,1) = ",")
 StringTrimLeft, ItemList, ItemList, 1
If (SubStr(ItemList,0,1) = ",")
 StringTrimRight, ItemList, ItemList, 1
StringReplace, ItemList, ItemList, `,, `,, UseErrorLevel
Random, Temp1, 1, ErrorLevel + 1
ItemList = ,%ItemList%,
StringGetPos, Temp1, ItemList, `,, L%Temp1%
Temp1 += 2, Temp1 := SubStr(ItemList,Temp1,InStr(ItemList,",",False,Temp1) - Temp1)
GuiControl,, ItemChoice, %Temp1%
Return