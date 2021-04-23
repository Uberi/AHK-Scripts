
SetWorkingDir,% A_ScriptDir
#SingleInstance,Ignore
global TextID,InSetPos,InReSize,ControlOwner,XGuiCreator,LastGuiName,CurrentGuiName,DisabledCtrl,OptionGuiName,LastCtrlName,BlackList="|XGuiCreatorMain|XGuiCreatorSelectArea|XGuiCreatorControlInfo|XGuiCreatorToolBar|XGuiCreatorAddGuiInfo|XGuiCreatorGuiOption|XGuiCreatorGrid",A_WinColor,HGrid,SnapGuiW=5,SnapGuiH=10,TitleName="X-Gui Creator v0.4.4 beta by ___x@___ (anhnhoktvn@gmail.com)",GridColor="ffffff",GridBGRColor="dddddd",Version=0.4.1
LastTickCount := A_TickCount
DetectHiddenWindows,On
SetBatchLines,-1
SetWorkingDir, % A_ScriptDir
SetWinDelay,0
SetKeyDelay,-1
SetMouseDelay,-1

GuiGridW = 10
GuiGridH = 10
SnapGuiW = 5
SnapGuiH = 10
GridColor = ffffff
GridBGRColor = dddddd
Version =
btns =
(LTrim
New GUI, 1, ,
Open, 2, ,
Save To AHK, 3, ,
Copy To Clipboard, 4, ,
GUI Option, 5, ,
GUI Grid, 6, ,
Preview, 7, ,
-
Button, 8, ,
CheckBox, 9, ,
Radio, 10, ,
Edit, 11, ,
UpDown, 12, ,
Text, 13, ,
GroupBox, 14, ,
Picture, 15, ,
DropDownList, 16, ,
ComboBox, 17, ,
ListBox, 18, ,
ListView, 19, ,
TreeView, 20, ,
Tab, 21, ,
Hotkey, 22, ,
Slider, 23, ,
DateTime, 24, ,
MonthCal, 25, ,
Progress, 26, ,
)
A_WinColor := GetSysColor(15)
A_CtrlColor := GetSysColor(5)
A_FontColor := GetSysColor(8)
A_GuiFont     := GuiDefaultFont()
A_GuiFontSize := A_LastError + 2
FontColor := A_FontColor
WinColor := A_WinColor
CtrlColor := A_CtrlColor
GdipToken := Gdip_Startup()
OnMessage(0x204,"WM_RBUTTONDOWN")
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x232,"WM_EXITSIZEMOVE")
OnMessage(0x231,"WM_ENTERSIZEMOVE")
OnMessage( 0x136, "WM_CTLCOLORDLG" )
OnMessage( 0x112, "WM_SYSCOMMAND" )
OnMessage( 0x21, "WM_MOUSEACTIVATE" )
Menu, ControlMenu, Add, Duplicate Control, Duplicate
Menu, ControlMenu, Add, Move Then Resize, MoveCtrlThenSetSize
Menu, ControlMenu, Add, Move Control, MoveCtrl
Menu, ControlMenu, Add, Resize Control, SetSize
Menu, ControlMenu, Add, Delete Control, DelCtrl
Menu, ControlMenu, Add, Change Text, ChangeText
Menu, ControlMenu, Add, Center Horizontally, CenterH
Menu, ControlMenu, Add, Center Vertically, CenterV
Menu, ControlMenu, Add, Other Options, Options
Menu,SelectArea, Add,  Duplicate Controls (Hold Ctrl+ Double Click), Duplicate
Menu,SelectArea, Add,  Move Then Resize (Hold Ctrl + Click + Drag (CD)), MoveCtrlThenSetSize
Menu,SelectArea, Add,  Move Controls (Hold Shift + CD), MoveCtrl
Menu,SelectArea, Add,  Resize Controls (Hold Alt + CD), SetSize
Menu,SelectArea, Add,  Delete Controls, DelCtrl
Menu,SelectArea, Add, Center Horizontally, CenterH
Menu,SelectArea, Add, Center Vertically, CenterV
TempVar := "Button,Checkbox,ComboBox,DateTime,DropDownList,Edit,GroupBox,ListBox,ListView,TreeView,MonthCal,Progress,Picture,Radio,Slider,Tab,Text,UpDown,Hotkey"
Loop,Parse,TempVar,CSV
Menu, AddCtrl, Add,% A_LoopField, MenuAddCtrl
Menu, GuiMenu, Add, Gui Options,GuiOption
Menu, GuiMenu, Add, New Gui,NewGUI
Menu, GuiMenu, Add, Destroy Gui,DestroyGUI
Menu, GuiMenu, Add, Add Control,:AddCtrl
Menu, GuiMenu, Add, Show/Hide Grid,GridShowHide
Menu, GuiMenu, Add, Save to New AHK File,SaveToAHK
Menu, GuiMenu, Add, Copy to Clipboard,CopyToClipboard
Menu, GuiMenu, Add, Preview,Preview
Gui, XGuiCreatorMain: Add, Text, x0 y45 w3200 h2400 +0x4 +HwndTextID
Gui, XGuiCreatorMain: Add, StatusBar
Gui, XGuiCreatorMain:+HwndXGuiCreatorMainID +Resize
Gui, XGuiCreatorMain: Show,% " h" A_ScreenHeight-150 " w" A_ScreenWidth  " Hide", % TitleName
hIL := IML_Load( "X-GUI Creator Data\Icon" )
hToolbar := Toolbar_Add(XGuiCreatorMainID, "OnToolbar", "ADJUSTABLE FLAT LIST TOOLTIPS nodivider", hIL,"x0 y0 h45 w" A_ScreenWidth)
Toolbar_Insert(hToolbar, btns ? btns : "New GUI,1`nOpen,2`nSave To AHK,3`nCopy To Clipboard,4`nGUI Option,5`nGUI Grid,6`nPreview,7`n-`nButton,8`nCheckBox,9`nRadio,10`nEdit,11`nUpDown,12`nText,13`nGroupBox,14`nPicture,15`nDropDownList,16`nComboBox,17`nListBox,18`nListView,19`nTreeView,20`nTab,21`nHotkey,22`nSlider,23`nDateTime,24`nMonthCal,25`nProgress,26")
Gui, XGuiCreatorControlInfo: Add, Text, x10 y20 w30 h20,Text:
Gui, XGuiCreatorControlInfo: Add, Edit, x40 y20 w130 h20   +HwndInfoTextID vInfoText,
Gui, XGuiCreatorControlInfo: Add, Text, x10 y40 w75 h20,Variable Name:
Gui, XGuiCreatorControlInfo: Add, Edit, x85 y40 w85 h20 vInfoVar,
Gui, XGuiCreatorControlInfo: Add, Text, x10 y60 w35 h20,Label:
Gui, XGuiCreatorControlInfo: Add, Edit, x45 y60 w125 h20 vInfoLabel,
Gui, XGuiCreatorControlInfo: Add, Button, x280 y80 w15 h20,Go
Gui, XGuiCreatorControlInfo: Add, GroupBox, x5 y0 w170 h95 vGui_Control,Control
Gui, XGuiCreatorControlInfo: Add, GroupBox, x5 y100 w170 h65,Position-Size
Gui, XGuiCreatorControlInfo: Add, Text, x10 y120 w50 h20,Pos (X-Y):
Gui, XGuiCreatorControlInfo: Add, Text, x10 y140 w50 h20,Size(W-H):
Gui, XGuiCreatorControlInfo: Add, Edit, x60 y120 w55 h20 vInfoX,0
Gui, XGuiCreatorControlInfo: Add, UpDown, x260 y30 w90 h20   Range0-99999,0
Gui, XGuiCreatorControlInfo: Add, Edit, x115 y120 w50 h20 vInfoY,0
Gui, XGuiCreatorControlInfo: Add, UpDown, x260 y30 w90 h20   Range0-99999,0
Gui, XGuiCreatorControlInfo: Add, Edit, x60 y140 w55 h20 vInfoW,0
Gui, XGuiCreatorControlInfo: Add, UpDown, x260 y30 w90 h20   Range1-99999,0
Gui, XGuiCreatorControlInfo: Add, Edit, x115 y140 w50 h20 vInfoH,0
Gui, XGuiCreatorControlInfo: Add, UpDown, x260 y30 w90 h20   Range1-99999,0
Gui, XGuiCreatorControlInfo: Add, Edit, x10 y190 w155 h20   +HwndInfoOptionID vInfoOption,
Gui, XGuiCreatorControlInfo: Add, Button, x5 y225 w75 h30   +Default gUpdateCtrlInfo,Update
Gui, XGuiCreatorControlInfo: Add, Button, x95 y225 w70 h30 gDuplicate,Duplicate
Gui, XGuiCreatorControlInfo: Add, GroupBox, x5 y170 w170 h50,Other Options
Gui, XGuiCreatorControlInfo:  +HwndXGuiCreatorToolbarID +OwnerXGuiCreatorMain +AlwaysOnTop -SysMenu
DllCall("SetParent", "UInt", XGuiCreatorToolbarID, "UInt", TextID)
Gui, XGuiCreatorControlInfo: Show,x0 y0 w176 h258, Control Info
Gui, XGuiCreatorGuiOption:Add, GroupBox, x10 y10 w240 h50 , Title
Gui, XGuiCreatorGuiOption:Add, Edit, x20 y30 w220 h20 vGuiTitle,
Gui, XGuiCreatorGuiOption:Add, GroupBox, x250 y10 w110 h50 , Gui Name/Count
Gui, XGuiCreatorGuiOption:Add, Edit, x260 y30 w90 h20 vGuiName,
Gui, XGuiCreatorGuiOption:Add, UpDown, x260 y30 w90 h20 Range1-99,1
Gui, XGuiCreatorGuiOption:Add, GroupBox, x10 y60 w350 h50 , Size
Gui, XGuiCreatorGuiOption:Add, Text, x20 y80 w40 h20 , Width:
Gui, XGuiCreatorGuiOption:Add, Edit, x60 y80 w100 h20 vGuiW, 500
Gui, XGuiCreatorGuiOption:Add, UpDown, x260 y30 w90 h20 Range1-99999,500
Gui, XGuiCreatorGuiOption:Add, Text, x170 y80 w40 h20 , Height:
Gui, XGuiCreatorGuiOption:Add, Edit, x210 y80 w100 h20 vGuiH, 500
Gui, XGuiCreatorGuiOption:Add, UpDown, x260 y30 w90 h20 Range1-99999,500
Gui, XGuiCreatorGuiOption:Add, GroupBox, x10 y110 w350 h50 , Option
Gui, XGuiCreatorGuiOption:Add, Edit, x20 y130 w330 h20 vGuiOption,
Gui, XGuiCreatorGuiOption:Add, GroupBox, x10 y160 w350 h50 , Color
Gui, XGuiCreatorGuiOption:Add, Text, x20 y180 w70 h20 , BackGround:
Gui, XGuiCreatorGuiOption:Add, ListView, x90 y180 w70 h20 -Hdr vWinColor gWinColor +Background%A_WinColor%,
Gui, XGuiCreatorGuiOption:Add, ListView, x220 y180 w70 h20 -Hdr vCtrlColor gCtrlColor +Background%A_CtrlColor%,
Gui, XGuiCreatorGuiOption:Add, Text, x180 y180 w40 h20 , Control:
Gui, XGuiCreatorGuiOption:Add, Button, x310 y180 w40 h20 gDefaultGuiColor, Default
Gui, XGuiCreatorGuiOption:Add, GroupBox, x10 y210 w350 h80 , Font
Gui, XGuiCreatorGuiOption:Add, Text, x20 y230 w40 h20 , Name:
Gui, XGuiCreatorGuiOption:Add, Edit, x60 y230 w130 h20 vFontName, % A_GuiFont
Gui, XGuiCreatorGuiOption:Add, Text, x20 y260 w40 h20 , Style:
Gui, XGuiCreatorGuiOption:Add, Edit, x60 y260 w130 h20 vFontStyle,
Gui, XGuiCreatorGuiOption:Add, Text, x200 y260 w40 h20 , Color:
Gui, XGuiCreatorGuiOption:Add, ListView, x240 y260 w50 h20 -Hdr vFontColor gFontColor +Background%A_FontColor%,
Gui, XGuiCreatorGuiOption:Add, Text, x200 y230 w40 h20 , Size:
Gui, XGuiCreatorGuiOption:Add, Edit, x240 y230 w50 h20 vFontSize, % A_GuiFontSize
Gui, XGuiCreatorGuiOption:Add, Button, x300 y230 w50 h20 gChangeFont, Change
Gui, XGuiCreatorGuiOption:Add, Button, x300 y260 w50 h20 gDefaultFont, Default
Gui, XGuiCreatorGuiOption:Add, Button, x372 y260 w80 h30 gXGuiCreatorGuiOptionGuiClose, Close
Gui, XGuiCreatorGuiOption:Add, Button, x372 y20 w80 h30 gGuiUpdateTitle , Update Name
Gui, XGuiCreatorGuiOption:Add, Button, x372 y120 w80 h30 gGuiUpdateOption, Update Option
Gui, XGuiCreatorGuiOption:Add, Button, x372 y70 w80 h30 gGuiUpdateSize, Update Size
Gui, XGuiCreatorGuiOption:Add, Button, x372 y170 w80 h30 gGuiAddColor, Change Color
Gui, XGuiCreatorGuiOption:Add, Button, x372 y220 w80 h30 gGuiAddFont, Change Font
Gui, XGuiCreatorGuiOption:Add, Button, x72 y300 w100 h30 gGuiOptionCreate, Create
Gui, XGuiCreatorGuiOption:Add, Button, x192 y300 w100 h30 gXGuiCreatorGuiOptionGuiClose, Cancel
Gui, XGuiCreatorGuiOption: +HwndXGuiCreatorGuiOptionID  +OwnerXGuiCreatorMain +ToolWindow +AlwaysOnTop
Gui, XGuiCreatorGrid: Font, s10 ,  MS Shell Dlg
Gui, XGuiCreatorGrid: Color, White, FFFFFF
Gui, XGuiCreatorGrid: Add, Edit, x10 y20 w65 h20 +Number vSnapGuiW,
Gui, XGuiCreatorGrid: Add, UpDown, x85 y20 w15 h20 Range1-100,% SnapGuiW
Gui, XGuiCreatorGrid: Add, Edit, x80 y20 w65 h20 +Number vSnapGuiH,
Gui, XGuiCreatorGrid: Add, UpDown, x175 y20 w15 h20 Range1-100,% SnapGuiH
Gui, XGuiCreatorGrid: Add, Button, x5 y190 w80 h30 gUpdateGrid,Done
Gui, XGuiCreatorGrid: Add, GroupBox, x0 y0 w155 h50,Snap to Grip Size (w-h)
Gui, XGuiCreatorGrid: Add, GroupBox, x0 y50 w155 h50,Grid square Size (W-H)
Gui, XGuiCreatorGrid: Add, GroupBox, x0 y105 w155 h80,Grid Color
Gui, XGuiCreatorGrid: Add, ListView, x15 y155 w80 h20 -Hdr +Background%GridBGRColor% +gGridBGRColor vGridBGRColor,
Gui, XGuiCreatorGrid: Add, ListView, x15 y130 w80 h20 -Hdr +Background%GridColor% +gGridColor vGridColor,
Gui, XGuiCreatorGrid: Add, Picture, x100 y130 w45 h45 hwndGridPreview +0xE
Gui, XGuiCreatorGrid: Add, Button, x85 y190 w70 h30 gDefaultGrid,Default
Gui, XGuiCreatorGrid: Add, Edit, x10 y75 w65 h20 +Number vGuiGridW,10
Gui, XGuiCreatorGrid: Add, UpDown, x85 y75 w20 h20 Range1-100,% GuiGridW
Gui, XGuiCreatorGrid: Add, Edit, x80 y75 w65 h20 +Number vGuiGridH,10
Gui, XGuiCreatorGrid: Add, UpDown, x175 y75 w20 h20 Range1-100,% GuiGridH
Gui, XGuiCreatorGrid: +HwndXGuiCreatorGridID  +OwnerXGuiCreatorMain +ToolWindow +AlwaysOnTop
SetImage(GridPreview, CreateGridBitmap(45,45,GridBGRColor,GridColor))
Sleep 100
Gui, XGuiCreatorMain: Show,Maximize
Hotkey,RButton Up,nothing,Off
XGuiCreator := Object()
OnExit,AskExit
return

return
CtrlMax2(GuiData,GuiName,CtrlName) {
if CtrlName in Text,Picture
List := "Text,Picture"
else if CtrlName in Checkbox,Radio,GroupBox,Button
List := "Checkbox,Radio,GroupBox,Button"
else if CtrlName in DropDownList,ComboBox
List := "DropDownList,ComboBox"
else List := CtrlName
Loop,Parse,List,CSV
MaxIndex := ((M := GuiData[GuiName,"Ctrl",A_LoopField].MaxIndex())>MaxIndex ? M : MaxIndex)
MaxIndex += 0
return MaxIndex
}
GuiMax2(GuiData,GuiName,Type) {
MaxIndex :=  GuiData[GuiName,"Gui",Type].MaxIndex()
MaxIndex += 0
return MaxIndex
}
SaveToAHK(GuiName,IsTest=0){
Result := "`n;~ This Gui is generated by X-GuiCreator (___x@___)"
if ($$ := SubStr(GuiName,5))
$$ := ($$<>1 ? $$ ": " : "")
Order := Trim(XGuiCreator[GuiName,"GuiSetting","CtrlOrder"],"|")
CurrentTab := 0
Loop,Parse,Order,|
{
IfInString,A_LoopField,Del_,continue
if InStr(A_LoopField,"Color") {
Result .= "`nGui, " $$ "Color, " Trim(XGuiCreator[GuiName,"Gui","Color",CtrlNumber(A_LoopField),"Win"]) ", " Trim(XGuiCreator[GuiName,"Gui","Color",CtrlNumber(A_LoopField),"Ctrl"])
continue
}
if InStr(A_LoopField,"Font") {
Result .= "`nGui, " $$ "Font,"  ((Size := Trim(XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Size"])) ? " s" Size : "") ((Style := Trim(XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Style"])) ? " " Style : "") ((Color := Trim(XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Color"]))<>"" ? " c" Color : "")  ((Name := Trim(XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Name"])) ? ", " Name : "")
continue
}
if InStr(A_LoopField,"Option") {
Result .= "`nGui, " $$ ( IsTest ? " " RegExReplace(XGuiCreator[GuiName,"Gui","Option",CtrlNumber(A_LoopField)],"i)(\+|-| |)\b(Owner|Parent)[\w$]+") : XGuiCreator[GuiName,"Gui","Option",CtrlNumber(A_LoopField)])
continue
}
CtrlName := SubStr(A_LoopField,1,Instr(A_LoopField,"_")-1)
if (Pos := InStr(A_LoopField,"Tab_")) {
TempVar := Substr(A_LoopField,Pos+4)
if (CurrentTab<>TempVar) {
CurrentTab := TempVar
StringSplit,TempVar,TempVar,_
Result .= "`nGui, " $$ "Tab," TempVar2 "," TempVar1
}
} else if (CurrentTab &&  CtrlSName(CtrlName)<>"Tab") {
CurrentTab := 0
Result .= "`nGui, " $$ "Tab"
}
Result .= "`nGui, "  $$ "Add, " ((C:=CtrlSName(CtrlName))="Tab" ? (CurrentTab := "Tab2") : C) "," ((X := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"X"])="" ? "" : " x" X) ((Y := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Y"])="" ? "" : " y" Y) ((W := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"W"])="" ? "" : " w" W) ((H := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"H"])="" ? "" : " h" H) ((O := Trim(XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Option"])) ? " " O : "") ((V := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Var"])="" ? "" : IsTest ? "" : " v" V) ((L := XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Label"])="" ? "" : IsTest ? "" : " g" L) ","  XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Text"]
}
Result .= "`nGui, " $$ "Show,"  ((W := XGuiCreator[GuiName,"GuiSetting","Size","W"]) ? " w" W : "" ) ((H := XGuiCreator[GuiName,"GuiSetting","Size","H"]) ? " h" H : "" ) ", " XGuiCreator[GuiName,"GuiSetting","Title"]
StringReplace,$$,$$,:%A_Space%
Result .= "`nReturn`n`n" (IsTest ? $$ "GuiEscape:`n" : "") $$ "GuiClose:`nExitApp"
return  Result
}
GenerateGui(GuiName) {
Gui,% GuiName ":New", +Resize +OwnerXGuiCreatorMain,% ((T := XGuiCreator[GuiName,"GuiSetting","Title"]) ? T : GuiName)
Order := Trim(XGuiCreator[GuiName,"GuiSetting","CtrlOrder"],"|")
Loop,Parse,Order,|
{
if InStr(A_LoopField,"Color") {
Gui,% GuiName ":Color",,% XGuiCreator[GuiName,"Gui","Color",CtrlNumber(A_LoopField),"Ctrl"]
continue
}
else if InStr(A_LoopField,"Option") {
Gui,% GuiName ": "  RegExReplace(XGuiCreator[GuiName,"Gui","Option",CtrlNumber(A_LoopField)],"i)(\+|-| |)\b(Hwnd[\w$]+|AlwaysOnTop)") " +Resize +OwnerXGuiCreatorMain "
continue
}
else if InStr(A_LoopField,"Font") {
Gui,% GuiName ":Font",%  ((Size := XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Size"]) ? " s" Size : "") ((Style := XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Style"]) ? " " Style : "") ((Color := XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Color"]) ? " c" Color : "") , % XGuiCreator[GuiName,"Gui","Font",CtrlNumber(A_LoopField),"Name"]
continue
}
else if (Pos:=InStr(A_LoopField,"Tab_")) {
TempVar := Substr(A_LoopField,Pos+4)
StringSplit,TabNum,TempVar,_
Gui,% GuiName ":Tab",% TabNum2,% TabNum1
} else if (TabNum1) {
Gui,% GuiName ":Tab"
TabNum1 := 0
}
CtrlName := SubStr(A_LoopField,1,Instr(A_LoopField,"_")-1)
CtrlSName:=CtrlSName(CtrlName)
CtrlOption := ""
IfInString,CtrlSName,Tab
CtrlOption .= "-0x4000000 +AltSubmit +gToggleGrid"
IfInString,CtrlName,ListView
CtrlOption .= " -Multi"
IfInString,CtrlName,Edit
CtrlOption .= " +Multi"
Gui,% GuiName ":Add",% (CtrlSName="Tab" ? "Tab2" : CtrlSName), % ((X:=XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"X"])<>"" ? " x" X : "") ((Y:=XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Y"])<>"" ? " y" Y : "") ((W:=XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"W"]) ? " w" W : "") ((H:=XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"H"]) ? " h" H : "")  " " XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Option"] (CtrlOption ? CtrlOption: "") (CtrlSName="UpDown" ? " -16" : CtrlSName="Picture" ? " +0xE" : "") (Instr(A_LoopField,"Del_") ? " +Hidden" : ""), % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlName),CtrlNumber(CtrlName),"Text"]
if !(X && Y && W && H)
CtrlUpdate(GuiName,CtrlSName(CtrlName),CtrlNumber(CtrlName))
if (CtrlSName="Tab")
Gui,% GuiName ":Tab"
}
If IsObject(XGuiCreator[GuiName,"GuiSetting","Size"])
Gui,% GuiName ":Show",% ((W := XGuiCreator[GuiName,"GuiSetting","Size","W"]) ? " w" W : "" ) ((H := XGuiCreator[GuiName,"GuiSetting","Size","H"]) ? " h" H : " h500" ),
else Gui,% GuiName ":Show", AutoSize
}
LoadAHK(FilePath) {
if !FilePath
return
Gui_Data := {}
GuiNameDefault := "XGC_1"
Loop,Read,% FilePath
{
CheckGui := RegExReplace(Trim(A_LoopReadLine),"\s+"," ")
if (!(Instr("#" CheckGui,"#Gui ") or Instr("#" CheckGui,"#Gui,")) ) {
continue
}
if (CheckGui="return")
break
if RegExMatch(CheckGui,"i)^Gui [\w$]")
StringReplace,CheckGui,CheckGui,% "Gui ",% "Gui ,"
StringReplace,CheckGui,CheckGui,Delimiter`,,AHK_DComma,All
StringReplace,CheckGui,CheckGui,Delimiter:,AHK_DColon,All
StringSplit,T,CheckGui,`,
if T0>3
T5 := SubStr(CheckGui,Instr(CheckGui,T4)+Strlen(T4)+1)
Loop,% T0
{
StringReplace,T%A_index%,T%A_index%,AHK_DComma,Delimiter`,,All
StringReplace,T%A_index%,T%A_index%,AHK_DColon,Delimiter:,All
}
Pos:= InStr(T2,":")
GuiAction := Trim(SubStr(T2,Pos+1))
if Pos
GuiName := "XGC_" ((N:=Trim(SubStr(T2,1,Pos-1)))="" ? 1 : N)
else GuiName := GuiNameDefault
StringReplace,GuiName,GuiName,`%,XGC_A_Percent,All
if GuiAction in Submit,Destroy,Cancel,Margin,Menu,Flash
continue
if GuiAction not in Add,Font,Color,Show,Tab,New,Default
{
if (O:=FixOption(SubStr(T2,Pos+1))) {
Gui_Data[Guiname,"Gui","Option",GuiMax2(Gui_Data,Guiname,"Option")+1]  := O
Gui_Data[Guiname,"GuiSetting","CtrlOrder"] .= "|" "Option" GuiMax2(Gui_Data,Guiname,"Option") "_"
}
}
else if (GuiAction="Default") {
GuiNameDefault := GuiName
continue
}
else if (GuiAction="New") {
Gui_Data[Guiname,"GuiSetting","Title"] := T4
if (O:=FixOption(T3)) {
Gui_Data[Guiname,"Gui","Option",GuiMax2(Gui_Data,Guiname,"Option")+1] := O
Gui_Data[Guiname,"GuiSetting","CtrlOrder"] .= "|" "Option" GuiMax2(Gui_Data,Guiname,"Option") "_"
}
}
else if (GuiAction="Font") {
Gui_Data[Guiname,"Gui",GuiAction,GuiMax2(Gui_Data,Guiname,GuiAction)+1]:= GetFontOption(T3,T4)
Gui_Data[Guiname,"GuiSetting","CtrlOrder"] .= "|" GuiAction GuiMax2(Gui_Data,Guiname,GuiAction) "_"
}
else if (GuiAction="Color") {
Gui_Data[Guiname,"Gui",GuiAction,GuiMax2(Gui_Data,Guiname,GuiAction)+1]:= {"Win":T3,"Ctrl":T4}
Gui_Data[Guiname,"GuiSetting","CtrlOrder"] .= "|" GuiAction GuiMax2(Gui_Data,Guiname,GuiAction) "_"
}
else if (GuiAction="Tab")
CurentTabCtrl := (T4 ? T4 : T3 ? CurentTabCtrl : 0), CurrentTabItem := T3
else if (GuiAction="Show") {
Gui_Data[Guiname,"GuiSetting","Size"] := GetGuiSize(T3)
Gui_Data[Guiname,"GuiSetting","Title"] := T4
}
else if (GuiAction="Add") {
CtrlName := Trim(T3)
CtrlName := (CtrlName="Pic" ? "Picture" : CtrlName="Tab2" ? "Tab" : CtrlName)
if CtrlName not in Button,Checkbox,ComboBox,DateTime,DropDownList,Edit,GroupBox,ListBox,ListView,TreeView,MonthCal,Progress,Picture,Radio,Slider,Tab,Text,UpDown,Hotkey
continue
Number := CtrlMax2(Gui_Data,Guiname,CtrlName)+1
if (CtrlName="Tab")
CurentTabCtrl := Number , CurrentTabItem := 1
Gui_Data[Guiname,"Ctrl",CtrlName,Number] := GetCtrlOption(CtrlName,T4,T5)
Gui_Data[Guiname,"GuiSetting","CtrlOrder"] .= "|" CtrlName Number "_" (CurentTabCtrl && CtrlName<>"Tab" ? "Tab_" CurentTabCtrl "_" CurrentTabItem :"")
}
Loop, % T0
T%A_Index% := ""
}
return Gui_Data
}
ChooseColor( Color=0x0, hPar=0x0, ccFile="")  {
Color := SubStr(Color,1,2)="0x" ? Color : "0x" Color      ; Check & Prefix Color with "0x"
VarSetCapacity(CHOOSECOLOR, 36, 0) , mainPtr := (&CHOOSECOLOR)     ; Create Main structure
DllCall( "RtlFillMemory", UInt,mainPtr+0, Int,1, UChar,36 ) ; Insert size of the Structure
hPar := WinExist(ahk_id %hPar%) ; Validate the passed Parent window ID
H1 := hPar>>0 & 255,   H2 := hPar>>8 & 255,   H3 := hPar>>16 & 255,   H4 := hPar>>24 & 255
Loop 4                       ; Insert Parent window ID to CHOOSECOLOR structure @ Offset 4
DllCall( "RtlFillMemory", UInt,mainPtr+3+A_Index, Int,1, UChar,H%A_Index% )
RGB1 := Color>>16 & 255,    RGB2 := Color>>8  & 255,    RGB3 := Color>>0  & 255
Loop 3                      ; Insert R,G and B values to CHOOSECOLOR structure @ Offset 12
DllCall( "RtlFillMemory", UInt,mainPtr+11+A_Index, Int,1, UChar,RGB%A_Index% )
VarSetCapacity(CUS1, 64, 0),   aPtr := (&CUS1),   VarSetCapacity(CUS2, 64, 0)
IfEqual,ccFile,, SetEnv,ccFile,%A_WinDir%\CUSTOMCOLOR.BIN ; Assign default save filename
IfExist,%ccFile%,  FileRead,CUS1, *m64 %ccFile%           ; Array CUS1 will be overwritten
Loop 64                                                   ; Copy data from CUS1 to CUS2
oS:=A_Index-1, DllCall( "RtlFillMemory", UInt,&CUS2+oS, Int,1, UChar,*(&CUS1+oS) )
A1 := aPtr>>0 & 255,   A2 := aPtr>>8 & 255,   A3 := aPtr>>16 & 255,   A4 := aPtr>>24 & 255
Loop 4        ; Insert pointer to Custom colors array to CHOOSECOLOR structure @ Offset 16
DllCall( "RtlFillMemory", UInt,mainPtr+15+A_Index, Int,1, UChar,A%A_Index% )
DllCall( "RtlFillMemory", UInt,mainPtr+20, Int,1,UChar,3  ) ; CC_RGBINIT=1 + CC_FULLOPEN=2
DllCall( "RtlFillMemory", UInt,mainPtr+21, Int,1,UChar,1  ) ; CC_ANYCOLOR=256
If ! DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR) OR errorLevel   ; Call ChooseColor
Return -1            ; and return -1 in case of an error or if no color was selected.
Loop 64 ; Compare data CUS2 and CUS1, if custom color changed, then save array to BIN file
If ( *(&CUS1+A_Index-1) != *(&CUS2+A_Index-1) )   {       ; Check byte by byte
h := DllCall( "_lcreat", Str,ccFile, Int,0 )         ; Overwrite/create file
DllCall( "_lwrite", UInt,h, Str,CUS1, Int,64 )  ; write the array,
DllCall( "_lclose", UInt,h )                    ; close the file,
Break                                           ; break the loop.
}
Hex := "123456789ABCDEF0",   RGB := mainPtr+11
Loop 3 ; Extract nibbles directly from main structure and convert it into Hex (initd. abv)
HexColorCode .=  SubStr(Hex, (*++RGB >> 4), 1) . SubStr(Hex, (*RGB & 15), 1)
Return HexColorCode ; finally ... phew!
}
chooseFont(hwndOwner) { ; by Nicolas Schneider, modified 12/03/27
static CF_EFFECTS := 0x00000100, CF_SCREENFONTS := 0x00000001, FW_BOLD := 700
VarSetCapacity(lpLogFont, 92), VarSetCapacity(struct, 60, 0)
NumPut(60, struct, 0), Numput(hwndOwner, struct, 4)
NumPut(&lpLogFont, struct, 12), NumPut(CF_EFFECTS | CF_SCREENFONTS, struct, 20)
if !DllCall("comdlg32\ChooseFont", "Str", struct) {
return -1
}
rgbColors := NumGet(struct, 24)
font := {"size": NumGet(struct, 16) // 10, "color": ((rgbColors & 0xff) << 16) | ((rgbColors >> 8) & 0xff) | (rgbColors >> 16)
, "bold": NumGet(lpLogFont, 16) = FW_BOLD, "italic": *(&lpLogFont + 20) >> 7, "underline": *(&lpLogFont + 21)
, "strikeOut": *(&lpLogFont + 22), "charset": *(&lpLogFont + 23), "name": StrGet(&lpLogFont + 28, 64)}
return font
}
GuiDefaultFont() {        ; By SKAN www.autohotkey.com/forum/viewtopic.php?p=465438#465438
hFont := DllCall( "GetStockObject", UInt,17 ) ; DEFAULT_GUI_FONT
VarSetCapacity( LF, szLF := 60*( A_IsUnicode ? 2:1 ) )
DllCall("GetObject", UInt,hFont, Int,szLF, UInt,&LF )
hDC := DllCall( "GetDC", UInt,hwnd ), DPI := DllCall( "GetDeviceCaps", UInt,hDC, Int,90 )
DllCall( "ReleaseDC", Int,0, UInt,hDC ), S := Round( ( -NumGet( LF,0,"Int" )*72 ) / DPI )
Return DllCall( "MulDiv",Int,&LF+28, Int,1,Int,1, Str ), DllCall( "SetLastError", UInt,S )
}
SelectArea(Options="") {   ; created by Learning one , ( modified by nothing)
/*
Returns selected area. Return example: 22|13|243|543
Options: (White space separated)
- c color. Default: Blue.
- t transparency. Default: 50.
- g GUI number. Default: 99.
- m CoordMode. Default: s. s = Screen, r = Relative, c = Client
- h Hotkey. Default: A_ThisHotkey
*/
CoordMode, Mouse, Screen
MouseGetPos, MX, MY
CoordMode, Mouse, Relative
MouseGetPos, rMX, rMY
CoordMode, Mouse, Client
MouseGetPos, cMX, cMY
CoordMode, Mouse, Screen
loop, parse, Options, %A_Space%
{
Field := A_LoopField
FirstChar := SubStr(Field,1,1)
if FirstChar contains c,t,g,m,h
{
StringTrimLeft, Field, Field, 1
%FirstChar% := Field
}
}
c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g , m := (m = "") ? "s" : m , h := (h = "") ? A_ThisHotkey : h
Gui %g%: Destroy
Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound
WinSet, Transparent, %t%
Gui %g%: Color, %c%
Hotkey := RegExReplace(h,"^(\w* & |\W*)")
While, (GetKeyState(Hotkey, "p"))
{
Sleep 1
MouseGetPos, MXend, MYend
w := abs(MX - MXend), h := abs(MY - MYend)
X := (MX < MXend) ? MX : MXend
Y := (MY < MYend) ? MY : MYend
Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
}
Gui %g%: Destroy
if m = s   ; Screen
{
MouseGetPos, MXend, MYend
If ( MX > MXend )
temp := MX, MX := MXend, MXend := temp
If ( MY > MYend )
temp := MY, MY := MYend, MYend := temp
Return MX "|" MY "|" MXend "|" MYend
}
else if m = r  ; Relative
{
CoordMode, Mouse, Relative
MouseGetPos, rMXend, rMYend
If ( rMX > rMXend )
temp := rMX, rMX := rMXend, rMXend := temp
If ( rMY > rMYend )
temp := rMY, rMY := rMYend, rMYend := temp
Return rMX "|" rMY "|" rMXend "|" rMYend
}
else	; Client
{
CoordMode, Mouse, Client
MouseGetPos, cMXend, cMYend
If ( cMX > cMXend )
temp := cMX, cMX := cMXend, cMXend := temp
If ( cMY > cMYend )
temp := cMY, cMY := cMYend, cMYend := temp
Return cMX "|" cMY "|" cMXend "|" cMYend
}
}
IsKeyDown(KeyName="",Time=25) {
LastTickCount := A_TickCount
while (A_TickCount-LastTickCount<Time)
if !GetKeyState(KeyName,"P")
return 0
return 1
}
GetSysColor(d_element) {
A_FI:=A_FormatInteger
SetFormat, Integer, Hex
BGR:=DllCall("GetSysColor"
,Int,d_element)+0x1000000
SetFormat,Integer,%A_FI%
StringMid,R,BGR,8,2
StringMid,G,BGR,6,2
StringMid,B,BGR,4,2
RGB := R G B
StringUpper,RGB,RGB
Return RGB
}
GetListCtrlInArea(GuiName,Area) {
StringSplit,Info,Area,|
if (Info1=Info3 or Info2=Info4)
return
Order := Trim(XGuiCreator[GuiName,"GuiSetting","CtrlOrder"],"|")
Loop,Parse,Order,|
{
IfInString, A_LoopField,Del_,continue
IfInString, A_LoopField,Color,continue
IfInString, A_LoopField,Font,continue
IfInString, A_LoopField,Option,continue
if (Pos:= Instr(A_LoopField,"Tab_")) {
TabInfo := SubStr(A_LoopField,Pos+4)
StringSplit,TabInfo,TabInfo,_
GuiControlGet,TabNumber,% GuiName ":",% "SysTabControl32" TabInfo1
if (TabInfo2 != TabNumber)
continue
}
CtrlFullName := SubStr(A_LoopField,1,Instr(A_LoopField,"_")-1)
if IsInArea(XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"X"] "|" XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Y"] "|"  XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"W"] + XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"X"] "|" XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"H"] + XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Y"] ,Area)
if !Result
Result := CtrlFullName
else Result .= "|" CtrlFullName
}
return Result
}
SetCtrlPos(GuiName,ListCtrl,Resize=1,FixPos=0) {
if !ListCtrl or InStr( "|" BlackList "|","|" GuiName "|")
return
if IsKeyDown("LButton",250)
return
InSetPos := 1
CoordMode,Mouse,Client
Gui, %GuiName%: +HwndGuiID
if ListCtrl not contains Button,Checkbox,Radio,Tab,Edit
MoveType := "MoveDraw"
else 	MoveType := "Move"
if (Resize != -1) {			;Move
IfWinNotActive,ahk_id %GuiID%
WinActivate,ahk_id%GuiID%
MinPos(GuiName,ListCtrl,X_Min,Y_Min)
if (FixPos) {
MaxPos(GuiName,ListCtrl,X_Max,Y_Max)
GetClientSize(GuiID, W, H)
if (2*X_Max-X_min<=W) {
Loop,Parse,ListCtrl,|
XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"X"] += X_Max-X_Min
X_Min := X_Max
}
else {
Loop,Parse,ListCtrl,|
XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"Y"] += Y_Max-Y_Min
Y_Min := Y_Max
}
}
MouseMove,% X_Min ,% Y_Min,0
while (!GetKeyState("LButton","P")) {
Sleep 1
IfWinNotActive,ahk_id %GuiID%
WinActivate,ahk_id%GuiID%
MouseGetPos,X,Y
if (X_Old Y_Old = X Y)
continue
Loop,Parse,ListCtrl,|
GuiControl, %GuiName%:%MoveType%,% CtrlGuiName(A_LoopField),% "x" Ceil((XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"X"] +Floor((X-X_Min)/SnapGuiW)*SnapGuiW)/SnapGuiW)*SnapGuiW " y"  Ceil((XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"Y"] + Floor((Y-Y_Min)/SnapGuiH)*SnapGuiH)/SnapGuiH)*SnapGuiH
X_Old := X, Y_Old := Y
}
Loop,Parse,ListCtrl,|
{
GuiControl,%GuiName%:MoveDraw,% CtrlGuiName(A_LoopField)
CtrlUpdate(GuiName, CtrlSName(A_LoopField),CtrlNumber(A_LoopField))
}
}
if Resize && !IsKeyDown("LButton",250) {		;Resize
IfWinNotActive,ahk_id%GuiID%
WinActivate,ahk_id%GuiID%
MaxPos(GuiName,ListCtrl,X_Max,Y_Max)
MouseMove,% X_Max ,% Y_Max,0
while (!GetKeyState("LButton","P")) {
Sleep 1
IfWinNotActive,ahk_id %GuiID%
WinActivate,ahk_id%GuiID%
MouseGetPos,X,Y
if (X_Old Y_Old = X Y)
continue
Loop,Parse,ListCtrl,|
GuiControl, %GuiName%: %MoveType% , % CtrlGuiName(A_LoopField) ,% " w" Ceil((XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"W"] + Floor((X-X_Max)/SnapGuiW)*SnapGuiW)/SnapGuiW)*SnapGuiW  " h" Ceil((XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"H"] + Floor((Y-Y_Max)/SnapGuiH)*SnapGuiH)/SnapGuiH)*SnapGuiH
X_Old := X, Y_Old := Y
}
}
Loop,Parse,ListCtrl,|
{
GuiControlGet,Ctrl,%GuiName%:Pos,% CtrlGuiName(A_LoopField)
if ( CtrlW>0 && CtrlH>0)
CtrlUpdate(GuiName, CtrlSName(A_LoopField),CtrlNumber(A_LoopField))
else GuiControl, %GuiName%: %MoveType%, % CtrlGuiName(A_LoopField),% " w" XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"W"] " h" XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField) ,"H"]
LastCtrlFullName := A_LoopField
}
IsKeyDown("LButton",50)
UpdateInfo(GuiName,LastCtrlFullName,0)
InSetPos := 0
}
IsOn() {
ID := WinActive("A")
for K in XGuiCreator
{
Gui, %K%: +HwndGuiID
if (ID=GuiID)
return 1
}
return 0
}
WM_MOUSEMOVE(){
CurrentGuiName := A_Gui
if (A_Gui="XGuiCreatorToolBar" && InStr(A_GuiControl,"TB")) {
ToolTip % SubStr(A_GuiControl,3)
SetTimer,ToolTipOff,500
}
if (A_Gui="XGuiCreatorMain" && !InSetPos) {
MouseGetPos,,,,C
IfInString,C,ToolBar,GuiControl,XGuiCreatorMain:Focus,C
}
}
WM_RBUTTONDOWN() {
if InsetPos or  InStr( "|" BlackList "|","|" A_Gui "|")
return
if !UpdateInfo(A_Gui, CtrlFullName(A_Gui,GetCtrlGuiName(A_Gui)),0) {
Menu,ControlMenu,Show
Hotkey,RButton Up,On
Sleep 10
Hotkey,RButton Up,Off
}
else Menu,GuiMenu,Show
}
WM_ENTERSIZEMOVE() {
InReSize := 1
}
WM_EXITSIZEMOVE(wParam, lParam, msg, hwnd) {
InReSize := 0
if InStr( "|" BlackList "|","|" A_Gui "|")
return
Gui, %A_Gui%: +HwndGuiID
GetClientSize(GuiID,w,h)
XGuiCreator[A_Gui,"GuiSetting","Size","W"] := W
XGuiCreator[A_Gui,"GuiSetting","Size","H"] := H
ToggleGrid(A_Gui),ToggleGrid(A_Gui)
}
WM_SYSCOMMAND(wParam) {
if InSetPos or InStr( "|" BlackList "|","|" A_Gui "|")
return
LastGuiName := A_Gui
if (wParam=61536)
return DestroyGUI(LastGuiName)
}
WM_MOUSEACTIVATE() {
if InSetPos or InStr( "|" BlackList "|","|" A_Gui "|")
return
UpdateInfo(A_Gui, CtrlFullName(A_Gui,GetCtrlGuiName(A_Gui)),0)
}
GetCtrlOption(CtrlName,var,Text="") {
RegExMatchArray(var, "i)\bx\d+\b", X,1,,2)
X:= X[X.MaxIndex()]
RegExMatchArray(var, "i)\by\d+\b", Y,1,,2)
Y:= Y[Y.MaxIndex()]
RegExMatchArray(var, "i)\bw\d+\b", W,1,,2)
W:= W[W.MaxIndex()]
RegExMatchArray(var, "i)\bh\d+\b", H,1,,2)
H:= H[H.MaxIndex()]
var := RegExReplace(var,"i)(\+|-| |)\b(x|y|w|h)\d+\b")
RegExMatchArray(var, "i)\bv[\w$]+\b", V,1,,2)
for K,Val in V
if (Val="ertical" && CtrlName="Slider")
continue
else {
StringReplace,Val,Val,$,\$,All
var := RegExReplace(var,"i)(\+|-| |)\bv" Val)
}
V:= ( (V[V.MaxIndex()]="ertical" && CtrlName="Slider") ? V[V.MaxIndex()-1] : V[V.MaxIndex()])
RegExMatchArray(var, "i)\bg[\w$]+\b", G,1,,2)
for K,Val in G
if (Val="rid" && CtrlName="ListView")
continue
else {
StringReplace,Val,Val,$,\$,All
var := RegExReplace(var,"i)(\+|-| |)\bg" Val)
}
G:= ((G[G.MaxIndex()]="rid" && CtrlName="ListView") ? G[G.MaxIndex()-1] : G[G.MaxIndex()])
Loop,Parse,var,% A_Space
if (!IsCtrlOption(CtrlName,A_LoopField))
O .= " " A_LoopField
return {"X":X,"Y":Y,"W":W,"H":H,"Var":V,"Label":G,"Option":O,"Text":Text}
}
GetFontOption(var,Name) {
RegExMatchArray(var, "i)\bs\d+\b", S,1,,2)
S:= S[S.MaxIndex()]
RegExMatchArray(var, "i)\bc\w+\b", C,1,,2)
C:= C[C.MaxIndex()]
St := RegExReplace(RegExReplace(var, "i)\bc\w+\b"), "i)\bs\d+\b")
if (C<>"")
if C is alpha
GetColor(C)
return {"Size":S,"Color":C,"Style":St,"Name":Name}
}
GetGuiSize(var) {
RegExMatchArray(var, "i)\bw\d+\b", W,1,,2)
W:= W[W.MaxIndex()]
RegExMatchArray(var, "i)\bh\d+\b", H,1,,2)
H:= H[H.MaxIndex()]
return {"W":W,"H":H}
}
RegExMatchArray(H, N, ByRef Obj, Pos=1, SubPat="",SubStartPos=1,SubLen=0)  {
Obj := Object()
While ( Pos := RegExMatch(H, N, Match, Pos + StrLen(Match)) )
Obj[A_Index] := SubStr(Match%SubPat%,SubStartPos,(SubLen ? SubLen : StrLen(Match%SubPat%)) )
return
}
GetColor(ByRef C) {
Black = 000000
Green = 008000
Silver = C0C0C0
Lime = 00FF00
Gray = 808080
Olive = 808000
White = FFFFFF
Yellow = FFFF00
Maroon = 800000
Navy = 000080
Red = FF0000
Blue = 0000FF
Purple = 800080
Teal = 008080
Fuchsia = FF00FF
Aqua = 00FFFF
if (%C% ="")
C := 0
else C := %C%
}
OnToolbar(hwnd, event, txt, pos, id) {
global CtrlFullName
if (event = "hot")
return
StringReplace,CtrlFullName,txt,% A_Space,,All
if (InSetPos or !LastGuiName)
if CtrlFullName not in NewGUI,Open,GUIGrid
return
if (event = "Click")
if CtrlFullName in Button,Checkbox,ComboBox,DateTime,DropDownList,Edit,GroupBox,ListBox,ListView,TreeView,MonthCal,Progress,Picture,Radio,Slider,Tab,Text,UpDown,Hotkey
gosub, AddCtrlName
else gosub, %CtrlFullName%
}
XWinMove(KeyName="") {
SetWinDelay,0
CoordMode,Mouse
MouseGetPos,X_Old,Y_Old
WinGetPos,WinX,WinY,,,A
WinID := WinActive("A")
KeyName := ((KeyName="") ? A_ThisHotkey : KeyName)
while (GetKeyState(KeyName,"P")) {
Sleep 1
MouseGetPos,X_New,Y_New
WinMove,ahk_id%WinID%,,% WinX + X_New-X_Old,% WinY + Y_New-Y_Old
}
}
XWinResize(KeyName="") {
SetWinDelay,0
CoordMode,Mouse
MouseGetPos,X_Old,Y_Old
WinGetPos,,,WinW,WinH,A
WinID := WinActive("A")
KeyName := ((KeyName="") ? A_ThisHotkey : KeyName)
while (GetKeyState(KeyName,"P")) {
Sleep 1
MouseGetPos,X_New,Y_New
WinMove,ahk_id%WinID%,,,,% WinW + X_New-X_Old ,% WinH + Y_New-Y_Old
}
}
DestroyGUI(GuiName) {
GuiName := GuiName="" ? LastGuiName : GuiName
Gui,XGuiCreatorMain:+OwnDialogs
MsgBox,4131,% TitleName,% "Do you want to Save GUI " SubStr(GuiName,5) " ?`n`nYes - Save to AHK File then Exit`nNo - Copy to Clipboard then Exit`nCancel - Return"
IfMsgBox,Yes
gosub, SaveToAHK
IfMsgBox,No
gosub, CopyToClipboard
IfMsgBox,Cancel
return 0
Gui, %GuiName%:Destroy
XGuiCreator.Remove(GuiName)
}
CreateGridBitmap(Width, Height, GridColor="B5B3AA", BackgroundColor="F4F2E4") {
pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4)
pBrush := Gdip_BrushCreateSolid("0xff" BackgroundColor)
Gdip_FillRectangle(G, pBrush, 0, 0, Width, Height)
Gdip_DeleteBrush(pBrush)
pPen := Gdip_CreatePen("0xff" GridColor, 1)
Gdip_DrawLine(G, pPen, 0,0, 0,Height)
Gdip_DrawLine(G, pPen, 0,0, Width,0)
Gdip_DeletePen(pPen), Gdip_DeleteGraphics(G)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
Gdip_DisposeImage(pBitmap)
return hBitmap
}

return
Open:
FileSelectFile,SFile,,% root,Load Gui,X-GuiCreator (*.XGC;*.AHK)
if !SFile
return
SplitPath,SFile,,root,ext
IfNotEqual,ext,AHK, return
GuiData := LoadAHK(SFile)
if !GuiData
return
Gui, XGuiCreatorMain:+OwnDialogs
for K in GuiData
if !(IsVarName(K))
if XGuiCreator.HasKey(K)
{
MsgBox, 262194, Unvaliable Gui Name,% " GuiName: [" SubStr(K,5) "] has Been Used. Please choose:`nAbort -  Abort This Gui.`nRetry - Change This Gui Name.`nIgnore - Overwrite the Old Gui."
IfMsgBox,Abort
continue
IfMsgBox,Retry
{
Loop
{
InputBox,NewName,Input New Name,Please input a new available name:
NewName := "XGC_" (NewName="" ? 1 : NewName)
if (ErrorM := IsGuiName(NewName)) {
TrayTip,Error!,% "Error Message: " ErrorM,2,3
continue
}
else break
}
}
IfMsgBox,Ignore
{
NewName := K
Gui, %K%:Destroy
}
XGuiCreator.Insert(NewName,GuiData[K])
GenerateGui(NewName)
} else {
XGuiCreator.Insert(K,GuiData[K])
GenerateGui(K)
}
GuiData := ""
return
MenuAddCtrl:
KeyWait,LButton,T30
if ErrorLevel
return
CtrlFullName :=  A_ThisMenuItem
AddCtrlName:
if !LastGuiName
return
Gui,XGuiCreatorMain: +OwnDialogs
CtrlText := CtrlFullName
IfInString,CtrlFullName,Tab
CtrlText := "Item1" GetDelimiter(LastGuiName) "Item2"
if CtrlFullName in DateTime,TreeView
CtrlText := ""
if CtrlFullName in Progress,Slider
CtrlText := 25
IfInString,CtrlFullName,Picture
{
FileSelectFile,SFile,,% root,Select Image,Image File (*.jpg;*.gif;*.bmp;*.png)
if SFile
CtrlText := SFile
}
Gui,% LastGuiName ": +HwndGuiID"
SetCtrlPos(LastGuiName,CtrlAdd(LastGuiName,CtrlFullName,{"Text" : CtrlText,"X":10}))
return
return
NewGUI:
gosub, DefaultGuiColor
gosub, DefaultFont
Gui, XGuiCreatorGuiOption:Show, h338 w365, Add Gui
InSetPos := 1
return
GuiOptionCreate:
Gui, XGuiCreatorGuiOption:Submit,NoHide
GuiOption := FixOption(GuiOption)
GuiName := "XGC_" (GuiName="" ? 1 : GuiName)
if (ErrorM := GuiCreate(GuiName,GuiOption)) {
TrayTip,Error!,% "Error Message: " ErrorM,2,3
return
}
Gui, %GuiName%:Show,w%GuiW% h%GuiW%
GuiUpdateSize(GuiName)
GuiAdd(GuiName,"Font",{"Name":FontName,"Style":FontStyle,"Size":FontSize,"Color":FontColor})
GuiUpdateTitle(GuiName,GuiTitle)
GuiAdd(GuiName,"Color",{"Win":WinColor,"Ctrl":CtrlColor})
GuiAdd(GuiName,"Option",GuiOption)
XGuiCreatorGuiOptionGuiClose:
Gui, XGuiCreatorGuiOption:Hide
InSetPos := 0
return
GuiUpdateTitle:
Gui, XGuiCreatorGuiOption:Submit,NoHide
GuiName := "XGC_" (GuiName="" ? 1 : GuiName)
if (OptionGuiName <> GuiName) {
if (ErrorM := IsGuiName(GuiName)) {
TrayTip,Error!,% "Error Message: " ErrorM,2,3
return
}
GuiData := XGuiCreator[OptionGuiName].Clone()
XGuiCreator.Remove(OptionGuiName)
XGuiCreator.Insert(GuiName,GuiData)
Gui,% OptionGuiName ":Destroy"
GenerateGui(GuiName)
OptionGuiName := GuiName
}
GuiUpdateTitle(OptionGuiName,GuiTitle)
gosub, XGuiCreatorGuiOptionGuiClose
return
GuiUpdateOption:
Gui, XGuiCreatorGuiOption:Submit,NoHide
GuiAdd(OptionGuiName,"Option",FixOption(GuiOption))
return
GuiUpdateSize:
Gui, XGuiCreatorGuiOption:Submit,NoHide
Gui, %OptionGuiName%:Show,w%GuiW% h%GuiW%
GuiUpdateSize(OptionGuiName)
return
GuiAddColor:
Gui, XGuiCreatorGuiOption:Submit,NoHide
GuiAdd(OptionGuiName,"Color",{"Win":WinColor,"Ctrl":CtrlColor})
return
GuiAddFont:
Gui, XGuiCreatorGuiOption:Submit,NoHide
GuiAdd(OptionGuiName,"Font",{"Name":FontName,"Style":FontStyle,"Size":FontSize,"Color":FontColor})
return
GridColor:
GridBGRColor:
FontColor:
WinColor:
CtrlColor:
ChosenColor := ChooseColor( %A_ThisLabel% )
If (  ChosenColor >=0) {
%A_ThisLabel% := ChosenColor
if A_ThisLabel contains Grid
{
GuiControl, XGuiCreatorGrid: +Background%ChosenColor%, % A_ThisLabel
SetImage(GridPreview, CreateGridBitmap(45,45,GridBGRColor,GridColor))
}
else GuiControl, XGuiCreatorGuiOption: +Background%ChosenColor%, % A_ThisLabel
}
return
GuiOption:
if !LastGuiName
return
OptionGuiName := LastGuiName
MaxColor := GuiMax(OptionGuiName,"Color")
MaxFont := GuiMax(OptionGuiName,"Font")
WinColor := ((W:=Trim(XGuiCreator[OptionGuiName,"Gui","Color",MaxColor,"Win"]))="" ? A_WinColor : W)
CtrlColor := ((C:=Trim(XGuiCreator[OptionGuiName,"Gui","Color",MaxColor,"Ctrl"]))="" ? A_CtrlColor : C)
FontColor := ((F:=Trim(XGuiCreator[OptionGuiName,"Gui","Font",MaxFont,"Color"]))="" ? A_FontColor : F)
GuiControl, XGuiCreatorGuiOption:,GuiTitle,% XGuiCreator[OptionGuiName,"Gui","Title"]
GuiControl, XGuiCreatorGuiOption:,GuiName,% SubStr(OptionGuiName,5)
GuiControl, XGuiCreatorGuiOption:,GuiW,% XGuiCreator[OptionGuiName,"GuiSetting","Size","W"]
GuiControl, XGuiCreatorGuiOption:,GuiH,% XGuiCreator[OptionGuiName,"GuiSetting","Size","H"]
GuiControl, XGuiCreatorGuiOption:,GuiOption,% XGuiCreator[OptionGuiName,"GuiSetting","Option"]
GuiControl, XGuiCreatorGuiOption:,FontName,% XGuiCreator[OptionGuiName,"Gui","Font",MaxFont,"Name"]
GuiControl, XGuiCreatorGuiOption:,FontStyle,% XGuiCreator[OptionGuiName,"Gui","Font",MaxFont,"Style"]
GuiControl, XGuiCreatorGuiOption:,FontSize,%  XGuiCreator[OptionGuiName,"Gui","Font",MaxFont,"Size"]
GuiControl, XGuiCreatorGuiOption: +BackGround%FontColor%,FontColor
GuiControl, XGuiCreatorGuiOption: +BackGround%WinColor%,WinColor
GuiControl, XGuiCreatorGuiOption: +BackGround%CtrlColor%,CtrlColor
Gui, XGuiCreatorGuiOption:Show,h295 w462,Change Gui Option
InSetPos := 1
return
DefaultGuiColor:
WinColor := A_WinColor
CtrlColor := A_CtrlColor
GuiControl, XGuiCreatorGuiOption: +Background%WinColor%,WinColor
GuiControl, XGuiCreatorGuiOption: +Background%CtrlColor%,CtrlColor
return
DefaultFont:
FontColor := A_GuiFontColor
GuiControl,XGuiCreatorGuiOption:, FontName,% A_GuiFont
GuiControl,XGuiCreatorGuiOption:, FontSize,% A_GuiFontSize
GuiControl,XGuiCreatorGuiOption:, FontStyle,
GuiControl, XGuiCreatorGuiOption: +Background%FontColor%,FontColor
return
ChangeFont:
Gui, XGuiCreatorGuiOption:+HwndGuiID
if ((font := chooseFont(GuiID)) = -1) {
return
}
GuiControl,XGuiCreatorGuiOption:, FontName, % font.name
GuiControl,XGuiCreatorGuiOption:, FontSize, % font.size
FontColor := font.color
GuiControl, XGuiCreatorGuiOption: +BackGround%FontColor%, FontColor
FontStyle := (font.bold ? " bold" : "") (font.italic ? " Italic" : "") (font.underline ? " Underline" : "") (font.strikeOut ? " StrikeOut" : "")
GuiControl,XGuiCreatorGuiOption:, FontStyle, % FontStyle
return
GridShowHide:
if LastGuiName
ToggleGrid(LastGuiName)
return
nothing:
return
return
Duplicate:
MoveCtrlThenSetSize:
MoveCtrl:
SetSize:
DelCtrl:
CenterV:
CenterH:
Gui, XGuiCreatorControlInfo:Submit,NoHide
GuiControlGet,GuiName,XGuiCreatorControlInfo:,Gui_Control
StringSplit,GuiInfo,GuiName,:,% A_Space
if !GuiInfo1 or (!GuiInfo2 && !ListCtrl)
return
if ListCtrl
GuiInfo2 := ListCtrl
if (A_ThisLabel="MoveCtrl")
SetCtrlPos(GuiInfo1, GuiInfo2,0)
else if (A_ThisLabel="MoveCtrlThenSetSize")
SetCtrlPos(GuiInfo1, GuiInfo2 ,1)
else if (A_ThisLabel="SetSize")
SetCtrlPos(GuiInfo1, GuiInfo2 ,-1)
else if (A_ThisLabel="DelCtrl")
CtrlDel(GuiInfo1,GuiInfo2)
else if (A_ThisLabel="Duplicate") {
ListCtrl := ""
Loop,Parse,GuiInfo2,|
{
GuiData := XGuiCreator[GuiInfo1,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField)].clone() , GuiData.Remove("Var")
ListCtrl .= "|" CtrlAdd(GuiInfo1,CtrlSName(A_LoopField),GuiData)
}
GuiData := ""
ListCtrl := Trim(ListCtrl,"|")
SetCtrlPos(GuiInfo1, ListCtrl ,1,1)
}
else if (A_ThisLabel="CenterH" or A_ThisLabel="CenterV") {
Gui, %GuiInfo1%: +HwndGuiID
GetClientSize(GuiID, w, h)
MinPos(GuiInfo1,GuiInfo2,X_Min,Y_Min)
MaxPos(GuiInfo1,GuiInfo2,X_Max,Y_Max)
StringSplit,Pos1,Pos1,|
StringSplit,Pos2,Pos2,|
if (A_ThisLabel="CenterH") {
X := Round((W-X_Max+X_Min)/2)-X_Min
Loop,Parse,GuiInfo2,|
GuiControl,%GuiInfo1%:MoveDraw,% CtrlGuiName(A_LoopField),% "x" (XGuiCreator[GuiInfo1,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"X"] +=  X)
}
else {
Y := Round((H-Y_Max+Y_Min)/2)-Y_Min
Loop,Parse,GuiInfo2,|
GuiControl,%GuiInfo1%:MoveDraw,% CtrlGuiName(A_LoopField),% "y" (XGuiCreator[GuiInfo1,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"Y"] += Y)
}
}
ListCtrl := ""
return
ChangeText:
Options:
Gui,XGuiCreatorControlInfo:Show
if (A_ThisLabel="ChangeText")
TempVar := InfoTextID
else TempVar := InfoOptionID
GuiControl,XGuiCreatorControlInfo:Focus,% TempVar
SendMessage, 0x0B1, 0, -1, , ahk_id %TempVar%
return
UpdateCtrlInfo:
Gui, XGuiCreatorControlInfo:Submit,NoHide
GuiControlGet,GuiName,XGuiCreatorControlInfo:,Gui_Control
StringSplit,GuiInfo,GuiName,:,% A_Space
if !GuiInfo1 or !GuiInfo2 or InSetPos
return
InfoVar := Trim(InfoVar)
if (ErrorM := IsVarName(InfoVar,GuiInfo1,GuiInfo2)) {
TrayTip,Error!,% "Error Message: " ErrorM,2,3
return
}
if (ErrorM := IsCtrlOption(RegExReplace(GuiInfo2,"\d+"),InfoOption)) {
TrayTip,Error!,% "Error Message: " ErrorM,2,3
return
}
if (ErrorM := IsVarName(InfoLabel)) {
TrayTip,Error!,Error Message: Invalid Variable Name.,1,3
return
}
CtrlUpdate(GuiInfo1, CtrlSName(GuiInfo2),CtrlNumber(GuiInfo2), {"X":InfoX,"Y":InfoY,"W":InfoW,"H":InfoH,"Label":InfoLabel,"Text":InfoText,"Var":InfoVar,"Option":FixOption(InfoOption,CtrlSName(GuiInfo2))})
return
CopyToClipboard:
if !LastGuiName
return
Clipboard := SaveToAHK(LastGuiName)
TrayTip,% TitleName,% "Copied GUI " SubStr(LastGuiName,5) " to Clipboard.",1,1
return
SaveToAHK:
if !LastGuiName
return
Gui, XGuiCreatorMain:+OwnDialogs
FileSelectFile,SFile,S,% root,Export to AHK file - %TitleName%,AutoHotkey (*.ahk)
if !SFile
return
SplitPath,SFile,,root,ext
if (ext<>"ahk")
SFile .= ".ahk"
IfExist,% SFile
{
MsgBox,52,Warning!,Existed File Name : %SFile%	`n Do you want to replace?
IfMsgBox,No
return
FileDelete,% SFile
}
FileAppend,% SaveToAHK(LastGuiName),% SFile
TrayTip,% TitleName,Saved to %SFile%.,1,1
return
GuiGrid:
Gui, XGuiCreatorGrid: Show, w157 h224
return
UpdateGrid:
Gui, XGuiCreatorGrid:Submit
GuiGridW := (GuiGridW ? GuiGridW : 1) , GuiGridH := (GuiGridH ? GuiGridH : 1),SnapGuiW := (SnapGuiW ? SnapGuiW : 1) , SnapGuiH := (SnapGuiH ? SnapGuiH : 1)
hBrush := ""
for K in XGuiCreator
ToggleGrid(K),ToggleGrid(K)
return
DefaultGrid:
GridColor := "ffffff",GridBGRColor := "dddddd"
GuiControl, XGuiCreatorGrid: +Background%GridBGRColor%,GridBGRColor
GuiControl, XGuiCreatorGrid: +Background%GridColor%,GridColor
SetImage(GridPreview, CreateGridBitmap(45,45,GridBGRColor,GridColor))
GuiControl, XGuiCreatorGrid:, GuiGridW,% (GuiGridW:=10)
GuiControl, XGuiCreatorGrid:, GuiGridH,% (GuiGridH:=10)
return
XGuiCreatorMainGuiClose:
ExitApp
return
#If IsOn()
^RButton:: XWinMove("RButton")
+RButton:: XWinResize("RButton") , GuiUpdateSize(LastGuiName)
return
$~*LButton::
if InsetPos
return
if InStr( "|" BlackList "|","|" CurrentGuiName "|")
if	!InStr(LastCtrlFullName,"DropDownList")
return
else CurrentGuiName := LastGuiName
LastGuiName := CurrentGuiName
ListCtrl := ""
LastCtrlFullName := CtrlFullName(LastGuiName,GetCtrlGuiName(LastGuiName))
UpdateInfo(LastGuiName,LastCtrlFullName)
if (A_TickCount-LastTickCount<250 && LastCtrlFullName )
if GetKeyState("Ctrl","P")
gosub, Duplicate
else SetTimer,SetCtrlPos,-1
else if IsKeyDown("LButton",50)
if !InResize
SetTimer,SelectArea,-1
LastTickCount := A_TickCount
#If
return
SelectArea:
InsetPos := 1
if (ListCtrl := GetListCtrlInArea(LastGuiName,SelectArea("hLButton gXGuiCreatorSelectArea mc"))) {
if ((S := ( GetKeyState("Ctrl","P") ? 1 : GetKeyState("Shift","P") ? 0 : GetKeyState("Alt","P") ? -1 : 2))=2)
Menu,SelectArea,Show
else {
SetCtrlPos(LastGuiName,ListCtrl,S)
ListCtrl := ""
}
}
InsetPos := 0
return
SetCtrlPos:
SetCtrlPos(LastGuiName,LastCtrlFullName)
LastCtrlFullName := ""
return
ToggleGrid:
ToggleGrid(LastGuiName)
ToggleGrid(LastGuiName)
return
ToolTipOff:
ToolTip
return
Preview:
if !LastGuiName
return
IfExist, X-GUI Creator Data\XGuiCreatorPreview.ahk
FileDelete,X-GUI Creator Data\XGuiCreatorPreview.ahk
FileAppend,% SaveToAHK(LastGuiName,1),X-GUI Creator Data\XGuiCreatorPreview.ahk
Run,X-GUI Creator Data\XGuiCreatorPreview.ahk,,UseErrorLevel
return
DestroyGUI:
DestroyGUI(LastGuiName)
return
AskExit:
Gui, XGuiCreatorMain:+OwnDialogs
MsgBox, 4132, Confirm to Exit, Do you want to Exit ?
IfMsgBox,No
return
GuiGridW := (GuiGridW ? GuiGridW : 1) , GuiGridH := (GuiGridH ? GuiGridH : 1),SnapGuiW := (SnapGuiW ? SnapGuiW : 1) , SnapGuiH := (SnapGuiH ? SnapGuiH : 1)
IfExist,X-GUI Creator Data\Config
FileDelete,X-GUI Creator Data\Config
btns := Toolbar_Define(hToolbar)
FileAppend,
(
GuiGridW = %GuiGridW%
GuiGridH = %GuiGridH%
SnapGuiW = %SnapGuiW%
SnapGuiH = %SnapGuiH%
GridColor = %GridColor%
GridBGRColor = %GridBGRColor%
Version = %Version%
btns =
`(LTrim
%btns%
`)
),X-GUI Creator Data\Config
Gdip_Shutdown(pToken)
ExitApp
return

WM_CTLCOLORDLG() {
global hBrush,GuiGridW,GuiGridH,GridBGRColor,GridColor,GridPreview
if InStr( "|" BlackList "|","|" A_Gui "|")
return
If !hBrush
{
Gui, XGuiCreatorGrid:Submit
HGrid := CreateGridBitmap(GuiGridW,GuiGridH,GridBGRColor,GridColor)
}
hBrush := DllCall( "CreatePatternBrush", UInt,HGrid )
Return hBrush
}
IsInArea(Region1="",Region2="") {
StringSplit,Info1,Region1,|
StringSplit,Info2,Region2,|
if (Info11>=Info21 && Info13<=Info23 && Info12>=Info22 && Info14<=Info24)
return 1
return 0
}
return
ToggleGrid(GuiName) {
static
if (%GuiName%_Grid := !%GuiName%_Grid)
Gui,% GuiName ":Color", % XGuiCreator[GuiName,"Gui","Color",GuiMax(GuiName,"Color"),"Win"]
else Gui,% GuiName ":Color",Default
}
UpdateInfo(GuiName,CtrlFullName,IsTab=1) {
if IsTab
{
IfInString,CtrlFullName,Tab,GuiControl,XGuiCreatorMain:,msctls_statusbar321,% "Control Owner : <Tab> " CtrlFullName
else GuiControl,XGuiCreatorMain:,msctls_statusbar321,% "Control Owner : <GUI> " GuiName
}
GuiControlGet,GuiInfo,XGuiCreatorControlInfo:,Gui_Control
StringSplit,GuiInfo,GuiInfo,:,% A_Space
if (!CtrlFullName) {
if (GuiInfo1<>GuiName)
GuiControl,XGuiCreatorControlInfo:,Gui_Control,% GuiName ": " CtrlFullName
return 1
}
GuiControl, XGuiCreatorControlInfo:, InfoText, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Text"]
GuiControl, XGuiCreatorControlInfo:, InfoVar, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Var"]
GuiControl, XGuiCreatorControlInfo:, InfoLabel, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Label"]
GuiControl, XGuiCreatorControlInfo:, InfoX, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"X"]
GuiControl, XGuiCreatorControlInfo:, InfoY, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Y"]
GuiControl, XGuiCreatorControlInfo:, InfoW, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"W"]
GuiControl, XGuiCreatorControlInfo:, InfoH, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"H"]
GuiControl, XGuiCreatorControlInfo:, InfoOption, % XGuiCreator[GuiName,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Option"]
GuiControl,XGuiCreatorControlInfo:,Gui_Control,% GuiName ": " CtrlFullName
return 0
}
CtrlGuiName(_) {
__ :=  RegExReplace(_,"\D+") , _ := RegExReplace(_,"\d+")
return, (_="ListView" ? "SysListView32" : _="TreeView" ? "SysTreeView32" : _="DateTime" ? "SysDateTimePick32" : _="DropDownList" ? "ComboBox" : _="CheckBox" ? "Button" : _="GroupBox" ? "Button" : _="Hotkey" ? "msctls_hotkey32" : _="MonthCal" ? "SysMonthCal32" : _="Picture" ? "Static" : _="Progress" ? "msctls_progress32" : _="Radio" ? "Button" : _="Slider" ? "msctls_trackbar32" : _="Tab" ? "SysTabControl32" : _="Text" ? "Static" : _="UpDown" ? "msctls_UpDown32" : _="Picture" ? "Static" : _)  __
}
CtrlFullName(GuiName,CtrlGuiName) {
if !GuiName
return
_ := RegExReplace(CtrlGuiName,"\d+")
StringReplace,Number,CtrlGuiName,% _
if CtrlGuiName contains ListView,TreeView,DateTime,MonthCal,progress,trackbar,hotkey,updown,tab,Edit,ListBox
return  (_="msctls_hotkey" ? "Hotkey" Substr(Number,3)  : _="msctls_progress" ? "Progress" Substr(Number,3)  : _="msctls_trackbar" ? "Slider" Substr(Number,3)  : _="SysTabControl" ? "Tab" Substr(Number,3)  : _="SysDateTimePick" ? "DateTime" Substr(Number,3)  : _="SysListView" ? "ListView" Substr(Number,3)  : _="SysTreeView" ? "TreeView" Substr(Number,3)  : _="SysMonthCal" ? "MonthCal" Substr(Number,3)  : _="msctls_UpDown" ? "UpDown" Substr(Number,3) : _ Number )
else if _ not contains Static,Button,ComboBox
return
Gui,%GuiName%: +HwndGuiID
ControlGet, St, Style,,% CtrlGuiName, ahk_id %GuiID%
return, ((_="Static") ? ((St&0xF)=14 ?  "Picture" Number : "Text" Number) : (_="Button") ? ((St&0xF)=2 || (St&0xF)=3 || (St&0xF)=5 || (St&0xF)=6 ? "Checkbox" Number : (St&0xF)=4 || (St&0xF)=9 ? "Radio" Number : (St&0xF)=7 ? "GroupBox" Number : "Button" Number) : (St&0xF)=3 ? "DropDownList" Number : "ComboBox" Number )
}
GetCtrlGuiName(GuiName=0) {
if InStr( "|" BlackList "|","|" GuiName "|")
return
LastGuiName := GuiName
MouseGetPos,,,,CtrlGuiName
if !CtrlGuiName
return
if InStr(CtrlGuiName,"SysHeader") {
StringReplace,CtrlGuiName,CtrlGuiName,SysHeader,SysListview
return CtrlGuiName
}
if Instr(CtrlGuiName,"Edit") {
if (InStr(XGuiCreator[GuiName,"Ctrl","Edit",SubStr(CtrlGuiName,5),"Label"],"Owner:"))
return SubStr(XGuiCreator[GuiName,"Ctrl","Edit",SubStr(CtrlGuiName,5),"Label"],7)
}
return CtrlGuiName
}
CtrlSName(CtrlFullName){
return RegExReplace(CtrlFullName,"\d+")
}
CtrlNumber(CtrlFullName){
return RegExReplace(CtrlFullName,"\D+")
}
GuiCreate(GuiName="XGC_Default",Option="") {
if (ErrorM := IsGuiName(GuiName))
return ErrorM
try Gui,% GuiName ":New",% RegExReplace(Option,"i)(\+|-| |)\b(Hwnd[\w$]+|AlwaysOnTop)") " +Resize +OwnerXGuiCreatorMain"
catch e {
return e.Message
}
XGuiCreator[GuiName] := {}
LastGuiName := GuiName
GuiControl,XGuiCreatorMain:,msctls_statusbar321,% "Control Owner : <GUI> " LastGuiName
}
GuiAdd(GuiName,Type,Par="") {
if (Type="Option" && !Par)
return
Number := GuiMax(GuiName,Type)+1
XGuiCreator[GuiName,"Gui",Type,Number] := Par
XGuiCreator[GuiName,"GuiSetting","CtrlOrder"] .= "|" Type Number "_"
if (Type="Font")
try Gui,% GuiName ":Font",%  Par["Style"] (Par["Size"]="" ? "" : " s" Par["Size"])  (Par["Color"] <>"" ? " c" Par["Color"] : "") ,% Par["Name"]
else if (Type="Color") {
try Gui,% GuiName ":Color",,% Par["Ctrl"]
ToggleGrid(GuiName),ToggleGrid(GuiName)
}
else {
try Gui,% GuiName ":" RegExReplace(Par,"i)(\+|-| |)\b(Hwnd[\w$]+|AlwaysOnTop)")
try Gui,% GuiName ": Show",% "w" Trim(XGuiCreator[GuiName,"GuiSetting","Size","W"]) " h" Trim(XGuiCreator[GuiName,"GuiSetting","Size","H"])
}
}
GuiUpdateSize(GuiName) {
Gui,%GuiName%:+HwndGuiID
GetClientSize(GuiID,GuiW,GuiH)
if (GuiW<=0 or GuiH<=0) {
Gui,% GuiName ":Show",AutoSize
GetClientSize(GuiID,GuiW,GuiH)
} else 	Gui,% GuiName ":Show",%  " w" GuiW " h" GuiH
XGuiCreator[GuiName,"GuiSetting","Size","W"] := GuiW
XGuiCreator[GuiName,"GuiSetting","Size","H"] := GuiH
}
GuiUpdateTitle(GuiName,Title="") {
try Gui,% GuiName ":Show",,% (Title<>"" ? Title : "Gui: " GuiName)
XGuiCreator[GuiName,"GuiSetting","Title"] := Title
}
CtrlAdd(GuiName,CtrlName,Par="") {
Number := CtrlMax(GuiName,CtrlName)+1
if !IsObject(XGuiCreator[GuiName,"Ctrl",CtrlName,Number])
XGuiCreator[GuiName,"Ctrl",CtrlName,Number] := {}
MergeObj(Par,XGuiCreator[GuiName,"Ctrl",CtrlName,Number])
return CtrlCreate(Guiname,CtrlName,Par)
}
CtrlCreate(Guiname,CtrlName,Par="") {
Number := CtrlMax(GuiName,CtrlName)
GuiControlGet,ControlOwner,XGuiCreatorMain:,msctls_statusbar321
if ( InStr(ControlOwner,"<GUI>") or CtrlName="Tab")
{
Gui,%GuiName%:Tab
XGuiCreator[GuiName,"GuiSetting","CtrlOrder"] .= "|" CtrlName Number "_"
if (CtrlName="Tab")
GuiControl,XGuiCreatorMain:,msctls_statusbar321,% "Control Owner : <GUI> " GuiName
}
else {
ControlOwner := SubStr(ControlOwner,InStr(ControlOwner,"> ")+2)
GuiControlGet,TabNumber,% GuiName ":",% "SysTabControl32" RegExReplace(ControlOwner,"\D+")
Gui,%GuiName%:Tab,% TabNumber,% RegExReplace(ControlOwner,"\D+")
XGuiCreator[GuiName,"GuiSetting","CtrlOrder"] .= "|" CtrlName Number "_Tab_" RegExReplace(ControlOwner,"\D+") "_" TabNumber
}
CtrlOption := Par["Option"] (CtrlName="Tab" ? " +AltSubmit +gToggleGrid" : CtrlName="ListView" ? " -Multi" : CtrlName="Edit" ? " +Multi" : CtrlName="UpDown" ? " -16" : CtrlName="Picture" ? " +0xE" : "")
Gui,%GuiName%:Add,% (CtrlName="Tab" ? "Tab2" : CtrlName) ,%  (Par["X"]="" ? " x10" : " x" Par["X"]) (Par["Y"]="" ? " y10" : " y" Par["Y"]) (Par["W"]="" ? "" : " w" Par["W"]) (Par["H"]="" ? "" : " h" Par["H"]) " " CtrlOption , % Par["Text"]
if (CtrlName = "ComboBox") {
if !IsObject(XGuiCreator[GuiName,"Ctrl","Edit"])
XGuiCreator[GuiName,"Ctrl","Edit"] := {}
XGuiCreator[GuiName,"Ctrl","Edit"].Insert(CtrlMax(GuiName,"Edit")+1,{"Label":"Owner:ComboBox" Number } )
}
CtrlUpdate(GuiName,CtrlName,Number)
return CtrlName  Number
}
CtrlUpdate(GuiName,CtrlName,Number,Par="") {
if IsObject(Par) {
CtrlOption := Par["Option"]
if (Par.HasKey("X") && Par.HasKey("W"))
GuiControl, %GuiName%:MoveDraw,% CtrlGuiName(CtrlName Number),% "x" Par["X"] " y" Par["Y"] " w" Par["W"] " h" Par["H"]
if Par.HasKey("Text") {
CtrlText := Par["Text"]
StringReplace,CtrlText,CtrlText,``n,`r`n,All
if CtrlName in Tab,DropDownList,ComboBox,ListBox
GuiControl, %GuiName%:,% CtrlGuiName(CtrlName Number),% GetDelimiter(GuiName,CtrlName Number) CtrlText
else if CtrlName in Checkbox,Radio
GuiControl, %GuiName%:Text,% CtrlGuiName(CtrlName Number),% CtrlText
else if CtrlName in ListView,TreeView
Par.Remove("Text")
else GuiControl, %GuiName%:,% CtrlGuiName(CtrlName Number),% CtrlText
}
if (CtrlOption<>XGuiCreator[GuiName,"Ctrl",CtrlName,Number,"Option"])
{
CtrlOption := RegExReplace(CtrlOption,"i)(\+|-| |)\b(Hwnd[\w$]+|AlwaysOnTop)")
CtrlOption .= (CtrlName="Tab" ? " +AltSubmit +gToggleGrid" : CtrlName="ListView" ? " -Multi" : CtrlName="Edit" ? " +Multi" : CtrlName="UpDown" ? " -16" : CtrlName="Picture" ? " +0xE" : "")
if XGuiCreator[GuiName,"Ctrl",CtrlName,Number,"Option"]
try GuiControl,% GuiName ": " ReverseOption(XGuiCreator[GuiName,"Ctrl",CtrlName,Number,"Option"]) ,% CtrlGuiName(CtrlName Number)
if CtrlOption
{
try GuiControl,% GuiName ": " CtrlOption ,% CtrlGuiName(CtrlName Number)
GuiControl,% GuiName ": MoveDraw" ,% CtrlGuiName(CtrlName Number)
}
}
MergeObj(Par,XGuiCreator[GuiName,"Ctrl",CtrlName,Number])
}
else {
GuiControlGet,T, %GuiName%:Pos,% CtrlGuiName(CtrlName Number)
MergeObj({"X" : Tx, "Y" : Ty, "W" : Tw, "H" : Th},XGuiCreator[GuiName,"Ctrl",CtrlName,Number])
}
}
CtrlMax(GuiName,CtrlName) {
if CtrlName in Text,Picture
List := "Text,Picture"
else if CtrlName in Checkbox,Radio,GroupBox,Button
List := "Checkbox,Radio,GroupBox,Button"
else if CtrlName in DropDownList,ComboBox
List := "DropDownList,ComboBox"
else List := CtrlName
Loop,Parse,List,CSV
MaxIndex := ((M := XGuiCreator[GuiName,"Ctrl",A_LoopField].MaxIndex())>MaxIndex ? M : MaxIndex)
MaxIndex += 0
return MaxIndex
}
GuiMax(GuiName,Type) {
MaxIndex :=  XGuiCreator[GuiName,"Gui",Type].MaxIndex()
MaxIndex += 0
return MaxIndex
}
CtrlDel(GuiName,CtrlList) {
TempVar :=  XGuiCreator[GuiName,"GuiSetting","CtrlOrder"]
Loop,Parse,CtrlList,|
{
StringReplace,TempVar,TempVar,% "|" A_LoopField "_",% "|" A_LoopField "_Del_"
GuiControl, %GuiName%:Hide,% CtrlGuiName(A_LoopField)
}
XGuiCreator[GuiName,"GuiSetting","CtrlOrder"]  := TempVar
Gui, XGuiCreatorControlInfo:Show,NA
GuiControl,XGuiCreatorControlInfo:,Gui_Control
GuiControl,XGuiCreatorMain:,msctls_statusbar321,% "Control Owner : <GUI> " GuiName
ToggleGrid(GuiName),ToggleGrid(GuiName)
}
CtrlRestore(GuiName,ListCtrl){
TempVar := XGuiCreator[GuiName,"GuiSetting","CtrlOrder"]
Loop,Parse,ListCtrl,|
{
StringReplace,TempVar,TempVar,% "|" A_LoopField "_Del_",% "|" A_LoopField "_"
Gui, %GuiName%:Show,% CtrlGuiName(A_LoopField)
}
XGuiCreator[GuiName,"GuiSetting","CtrlOrder"] := TempVar
}
FixOption(var,CtrlName="") {
var := RegExReplace(Trim(var),"\s+"," ")
Loop,Parse,var,% A_Space
{
if (!A_Loopfield)
continue
Check := (CtrlName ? IsCtrlOption(CtrlName,A_Loopfield) : IsGuiOption(A_Loopfield))
if Check
continue
TempVar := SubStr(A_LoopField,1,1)
if TempVar in +,-
Result .=  " " A_LoopField
else Result .=  " +" A_LoopField
}
return Result
}
IsGuiOption(Option) {
if (RegExMatch(Option,"i)(\+|-| |)\b(Owner|Parent)[\w\$]+"))
return 0
try Gui,XGuiCreatorTest: %Option%
catch e {
return e.Message
}
Gui,XGuiCreatorTest:Destroy
return 0
}
IsCtrlOption(CtrlName,Option) {
try Gui,XGuiCreatorTest:Add,% CtrlName,% Option
catch e {
return e.Message
}
Gui,XGuiCreatorTest:Destroy
return 0
}
ReverseOption(var) {
Loop,Parse,var,% A_Space
{
if !A_Loopfield
continue
TempVar := SubStr(A_LoopField,1,1)
if (TempVar="-")
Result .=  " +" SubStr(A_LoopField,2)
else if (TempVar="+")
Result .=  " -" SubStr(A_LoopField,2)
else Result .=  " -" A_LoopField
}
return Trim(Result)
}
IsGuiName(GuiName) {
if IsVarName(GuiName)
return, "The Gui Name is invalid."
for K in XGuiCreator
if (K=GuiName)
return,"This Gui Name has been used."
return,0
}
IsVarName(CtrlVar="",GuiNameOld="",CtrlFullNameOld="") {
if RegExMatch(CtrlVar,"[^\w$]")
return "Invalid Variable Name."
if (GuiNameOld="" or CtrlVar="")
return 0
for Gui in XGuiCreator
for CtrlFullName in XGuiCreator[Gui,"Ctrl"]
if ( XGuiCreator[Gui,"Ctrl",CtrlSName(CtrlFullName),CtrlNumber(CtrlFullName),"Var"]=CtrlVar &&  Gui CtrlFullName <> GuiNameOld CtrlFullNameOld)
return "The variable name is not available.`nIt belongs to   " Gui ": " CtrlFullName
}
MinPos(GuiName,ListCtrl,ByRef X_Min,ByRef Y_Min) {
if !ListCtrl
return
X_Min := 99999,Y_Min := 99999
Loop,Parse,ListCtrl,|
{
X_Min := ( (T :=XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"X"])<X_Min ? T : X_Min)
Y_Min := ( (T :=XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"Y"])<Y_Min ? T : Y_Min)
}
}
MaxPos(GuiName,ListCtrl,ByRef X_Max,ByRef Y_Max) {
X_Max := "",Y_Max := ""
Loop,Parse,ListCtrl,|
{
X_Max := ( (T :=XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"X"]+XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"W"])>X_Max ? T : X_Max)
Y_Max := ( (T :=XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"Y"]+XGuiCreator[GuiName,"Ctrl",CtrlSName(A_LoopField),CtrlNumber(A_LoopField),"H"])>Y_Max ? T : Y_Max)
}
}
GetClientSize(hwnd, ByRef w, ByRef h) {
VarSetCapacity(rc, 16)
DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
w := NumGet(rc, 8, "int")
h := NumGet(rc, 12, "int")
}
MergeObj(SourceObj,TargetObj) {
if !IsObject(TargetObj)
TargetObj :={}
For K,V in SourceObj {
if IsObject(V) {
if !TargetObj.Haskey(K)
TargetObj[K] :={}
MergeObj(V,TargetObj[K])
} else {
TargetObj[K] := V
}
}
}
GetDelimiter(GuiName,CtrlName="") {
List := Trim(XGuiCreator[GuiName,"GuiSetting","CtrlOrder"],"|")
Loop, Parse,List,|
{
IfInString,A_LoopField,% CtrlName "_", break
IfNotInString,A_LoopField,Option, continue
TempVar := XGuiCreator[GuiName,"Gui","Option",CtrlNumber(A_LoopField)] " "
if !(Pos := InStr(TempVar,"+Delimiter"))
continue
Result := SubStr( TempVar,Pos+10,InStr(TempVar,A_Space,0,Pos+11)-Pos-10)
}
return ( StrLen(Result)>1 ? (Result := A_%Result%) : StrLen(Result)=1 ? Result : "|")
}
IML_Load( File ) {               ; by SKAN  www.autohotkey.com/forum/viewtopic.php?t=72282
If ( hF := DllCall( "CreateFile", Str,File, UInt,0x80000000, UInt,3    ;  CD: 24-May-2011
, Int,0, UInt,3, Int,0, Int,0 ) ) < 1               ;  LM: 25-May-2011
|| ( nSiz := DllCall( "GetFileSize", UInt,hF, Int,0, UInt ) ) < 1
Return ( ErrorLevel := 1 ) >> 64,  DllCall( "CloseHandle",UInt,hF )
hData := DllCall("GlobalAlloc", UInt,2, UInt,nSiz )
pData := DllCall("GlobalLock",  UInt,hData )
DllCall( "_lread", UInt,hF, UInt,pData, UInt,nSiz )
DllCall( "GlobalUnlock", UInt,hData ), DllCall( "CloseHandle",UInt,hF )
DllCall( "ole32\CreateStreamOnHGlobal", UInt,hData, Int,True, UIntP,pStream )
himl := DllCall( "ImageList_Read", UInt,pStream )
DllCall( NumGet( NumGet( 1*pStream ) + 8 ), UInt,pStream )
DllCall( "GlobalFree", UInt,hData )
Return himl
}
ImageBtn(GuiName,Num) {
GuiControlGet,CtrlID,%GuiName%:Hwnd,% "Button" Num
BtnO := [{BC: "D:\IT\Autohotkey\InResearch\ImageButton\Normal.jpg", TC: "Green", 3D: 9,G:1}]
BtnO[2] := {BC: "D:\IT\Autohotkey\InResearch\ImageButton\Over.JPG", TC: "Green", 3D: 9,G:1}
BtnO[3] := {BC: "D:\IT\Autohotkey\InResearch\ImageButton\Press.JPG", TC: "Green", 3D: 9,G:1}
If !CreateImageButton(CtrlID, BtnO)
TrayTip,% TitleName, %ErrorLevel%,3,1
}

CreateImageButton(HWND, Options, Margins = 0) {
Static HTML := {BLACK:  "000000", GRAY:   "808080", SILVER:  "C0C0C0", WHITE: "FFFFFF"
, MAROON: "800000", PURPLE: "800080", FUCHSIA: "FF00FF", RED:   "FF0000"
, GREEN:  "008000", OLIVE:  "808000", YELLOW:  "FFFF00", LIME:  "00FF00"
, NAVY:   "000080", TEAL:   "008080", AQUA:    "00FFFF", BLUE:  "0000FF"}
Static BS_CHECKBOX := 0x2  , BS_RADIOBUTTON := 0x4
, BS_GROUPBOX := 0x7  , BS_AUTORADIOBUTTON := 0x9
, BS_LEFT := 0x100    , BS_RIGHT := 0x200
, BS_CENTER := 0x300  , BS_TOP := 0x400
, BS_BOTTOM := 0x800  , BS_VCENTER := 0xC00
, BS_BITMAP := 0x0080
, SA_LEFT := 0x0      , SA_CENTER := 0x1
, SA_RIGHT := 0x2     , WM_GETFONT := 0x31
, IMAGE_BITMAP := 0x0 , BITSPIXEL := 0xC
, RCBUTTONS := BS_CHECKBOX | BS_RADIOBUTTON | BS_AUTORADIOBUTTON
, BCM_SETIMAGELIST := 0x1602
, BUTTON_IMAGELIST_ALIGN_LEFT := 0
, BUTTON_IMAGELIST_ALIGN_RIGHT := 1
, BUTTON_IMAGELIST_ALIGN_CENTER := 4
Static OptionKeys := ["TC", "BC", "3D", "G"]
Static Defaults := {TC: "000000", BC: "000000", 3D: 0, G: 0}
ErrorLevel := ""
GDIPDll := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "Ptr")
VarSetCapacity(SI, 24, 0)
Numput(1, SI)
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GDIPToken, "Ptr", &SI, "Ptr", 0)
If (!GDIPToken) {
ErrorLevel := "GDIPlus could not be started!`n`nImageButton won't work!"
Return False
}
If !(DllCall("User32.dll\IsWindow", "Ptr", HWND)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Invalid parameter HWND!"
Return False
}
If !(IsObject(Options)) || (Options.MinIndex() = "") || (Options.MinIndex() > 1) || (Options.MaxIndex() > 6) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Invalid parameter Options!"
Return False
}
Margins := SubStr(Margins, 1, 1)
If (Margins = "") || !(Instr("01234", Margins))
Margins := 0
WinGetClass, BtnClass, ahk_id %HWND%
ControlGet, BtnStyle, Style, , , ahk_id %HWND%
If (BtnClass != "Button") || ((BtnStyle & 0xF ^ BS_GROUPBOX) = 0) || ((BtnStyle & RCBUTTONS) > 1) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "You can use ImageButton only for PushButtons!"
Return False
}
GDIPFont := 0
DC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
BPP := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", BITSPIXEL)
HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
DllCall("Gdi32.dll\SelectObject", "Ptr", DC, "Ptr", HFONT)
DllCall("Gdiplus.dll\GdipCreateFontFromDC", "Ptr", DC, "PtrP", GDIPFont)
DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", DC)
If !(GDIPFont) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's font!"
Return False
}
VarSetCapacity(RECT, 16, 0)
If !(DllCall("User32.dll\GetClientRect", "Ptr", HWND, "Ptr", &RECT)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's rectangle!"
Return False
}
W := NumGet(RECT,  8, "Int") - (Margins * 2)
H := NumGet(RECT, 12, "Int") - (Margins * 2)
BtnCaption := ""
Len := DllCall("User32.dll\GetWindowTextLength", "Ptr", HWND) + 1
If (Len > 1) {   ; Button has a caption
VarSetCapacity(BtnCaption, Len * (A_IsUnicode ? 2 : 1), 0)
If !(DllCall("User32.dll\GetWindowText", "Ptr", HWND, "Str", BtnCaption, "Int", Len)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's caption!"
Return False
}
VarSetCapacity(BtnCaption, -1)
}
BitMaps := []
While (A_Index <= Options.MaxIndex()) {
If !(Options.HasKey(A_Index))
Continue
Option := Options[A_Index]
If !(Option.HasKey("BC")) {
GoSub, CreateImageButton_FreeBitmaps
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Missing option BC in Options[" . A_Index . "]!"
Return False
}
For Each, K In Defaults {
If !(Option.HasKey(K)) || (Option[K] = "")
Option[K] := Defaults[K]
}
BitMap := ""
GC := SubStr(Option.G, 1, 1)
If !InStr("01", GC)
GC := Defaults.G
3D := SubStr(Option.3D, 1, 1)
If !InStr("01239", 3D)
3D := Defaults.3D
If (3D < 4) {
BkgColor := Option.BC
If InStr(BkgColor, "|") {
StringSplit, BkgColor, BkgColor, |
} Else {
BkgColor1 := Option.3D = 0 ? BkgColor : Defaults.BC
BkgColor2 := BkgColor
}
If HTML.HasKey(BkgColor1)
BkgColor1 := HTML[BkgColor1]
If HTML.HasKey(BkgColor2)
BkgColor2 := HTML[BkgColor2]
} Else {
Image := Option.BC
}
TxtColor := Option.TC
If HTML.HasKey(TxtColor)
TxtColor := HTML[TxtColor]
DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", W, "Int", H, "Int", 0
, "UInt", 0x26200A, "Ptr", 0, "PtrP", PBITMAP)
DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", PBITMAP, "PtrP", PGRAPHICS)
DllCall("Gdiplus.dll\GdipSetSmoothingMode", "Ptr", PGRAPHICS, "UInt", 0)
If (3D < 4) { ; Create a BitMap
VarSetCapacity(POINTS, 4 * 8, 0)
NumPut(W - 1, POINTS,  8, "UInt"), NumPut(W - 1, POINTS, 16, "UInt")
NumPut(H - 1, POINTS, 20, "UInt"), NumPut(H - 1, POINTS, 28, "UInt")
DllCall("Gdiplus.dll\GdipCreatePathGradientI", "Ptr", &POINTS, "Int", 4, "Int", 0, "PtrP", PBRUSH)
Color1 := "0xFF" . BkgColor1
Color2 := "0xFF" . BkgColor2
VarSetCapacity(COLORS, 12, 0)
NumPut(Color1, COLORS, 0, "UInt"), NumPut(Color2, COLORS, 4, "UInt")
VarSetCapacity(RELINT, 12, 0)
NumPut(0.00, RELINT, 0, "Float"), NumPut(1.00, RELINT, 4, "Float")
DllCall("Gdiplus.dll\GdipSetPathGradientPresetBlend", "Ptr", PBRUSH, "Ptr", &COLORS, "Ptr", &RELINT, "Int", 2)
DH := H / 2
XScale := (3D = 1 ? (W - DH) / W : 3D = 2 ? 1 : 0)
YScale := (3D = 1 ? (H - DH) / H : 3D = 3 ? 1 : 0)
DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", PBRUSH, "Float", XScale, "Float", YScale)
DllCall("Gdiplus.dll\GdipSetPathGradientGammaCorrection", "Ptr", PBRUSH, "Int", GC)
DllCall("Gdiplus.dll\GdipFillRectangleI", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Int", 0, "Int", 0
, "Int", W, "Int", H)
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
} Else { ; Create a bitmap from HBITMAP or file
If (Image + 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromHBITMAP", "Ptr", Image, "Ptr", 0, "PtrP", PBM)
Else
DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", Image, "PtrP", PBM)
DllCall("Gdiplus.dll\GdipDrawImageRectI", "Ptr", PGRAPHICS, "Ptr", PBM, "Int", 0, "Int", 0
, "Int", W, "Int", H)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBM)
}
If (BtnCaption) {
DllCall("Gdiplus.dll\GdipCreateStringFormat", "Int", 0x5404, "UInt", 0, "PtrP", HFORMAT)
DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", "0xFF" . TxtColor, "PtrP", PBRUSH)
HALIGN := (BtnStyle & BS_CENTER) = BS_CENTER ? SA_CENTER
: (BtnStyle & BS_CENTER) = BS_RIGHT  ? SA_RIGHT
: (BtnStyle & BS_CENTER) = BS_Left   ? SA_LEFT
: SA_CENTER
DllCall("Gdiplus.dll\GdipSetStringFormatAlign", "Ptr", HFORMAT, "Int", HALIGN)
VALIGN := (BtnStyle & BS_VCENTER) = BS_TOP ? 0
: (BtnStyle & BS_VCENTER) = BS_BOTTOM ? 2
: 1
DllCall("Gdiplus.dll\GdipSetStringFormatLineAlign", "Ptr", HFORMAT, "Int", VALIGN)
DllCall("Gdiplus.dll\GdipSetTextRenderingHint", "Ptr", PGRAPHICS, "Int", 0)
NumPut(0.0, RECT,  0, "Float")
NumPut(0.0, RECT,  4, "Float")
NumPut(W,   RECT,  8, "Float")
NumPut(H,   RECT, 12, "Float")
DllCall("Gdiplus.dll\GdipDrawString", "Ptr", PGRAPHICS, "WStr", BtnCaption, "Int", -1
, "Ptr", GDIPFont, "Ptr", &RECT, "Ptr", HFORMAT, "Ptr", PBRUSH)
}
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", PBITMAP, "PtrP", HBITMAP, "UInt", 0X00FFFFFF)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBITMAP)
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
DllCall("Gdiplus.dll\GdipDeleteStringFormat", "Ptr", HFORMAT)
DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", PGRAPHICS)
BitMaps[A_Index] := HBITMAP
}
DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", GDIPFont)
HIL := DllCall("Comctl32.dll\ImageList_Create", "UInt", W, "UInt", H, "UInt", BPP, "Int", 6, "Int", 0, "Ptr")
Loop, % (BitMaps.MaxIndex() > 1 ? 6 : 1) {
HBITMAP := BitMaps.HasKey(A_Index) ? BitMaps[A_Index] : BitMaps[1]
DllCall("Comctl32.dll\ImageList_Add", "Ptr", HIL, "Ptr", HBITMAP, "Ptr", 0)
}
VarSetCapacity(BIL, 20 + A_PtrSize, 0)
NumPut(HIL, BIL, 0, "Ptr")
Numput(BUTTON_IMAGELIST_ALIGN_CENTER, BIL, A_PtrSize + 16, "UInt")
Control, Style, +%BS_BITMAP%,,ahk_id %HWND%
SendMessage, BCM_SETIMAGELIST, 0, 0, , ahk_id %HWND%
SendMessage, BCM_SETIMAGELIST, 0, &BIL, , ahk_id %HWND%
GoSub, CreateImageButton_FreeBitmaps
GoSub, CreateImageButton_GDIPShutdown
Return True
CreateImageButton_FreeBitmaps:
For I, HBITMAP In BitMaps {
DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
}
Return
CreateImageButton_GDIPShutdown:
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GDIPToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", GDIPDll)
Return
}

/*
Object from/to file or string - another way to set/get/edit/store data structures. By Learning one.
Very easy for both humans and machines to read and write. Fast, simple, flexible.
Hierarchy in data structure string is defined by using indentation, more precisely; tab character. Can be changed.
Functions, obligatory parameters, and return values:
ObjFromFile(FilePath)		; creates object from file. 	Returns: object
ObjToFile(Object, FilePath)	; saves object to file. 		Returns: 1 if there was a problem or 0 otherwise
ObjFromStr(String) 			; creates object from string. 	Returns: object
ObjToStr(Object) 			; converts object to string. 	Returns: string
Link:	http://www.autohotkey.com/forum/viewtopic.php?t=71503
*/
ObjFromStr(String, Indent="`t", Rows="`n", Equal="=") {		; creates object from string which represents data structure.
obj := Object(), kn := Object()	; kn means "key names" - simple array object
IndentLen := StrLen(Indent)
Loop, parse, String, %Rows%
{
if A_LoopField is space
continue
Field := RTrim(A_LoopField, " `t`r")
CurLevel := 1, k := "", v := ""	; clear, reset
While (SubStr(Field,1,IndentLen) = Indent) {
StringTrimLeft, Field, Field, %IndentLen%
CurLevel++
}
EqualPos := InStr(Field, Equal)
if (EqualPos = 0)
k := Field
else
k := SubStr(Field, 1, EqualPos-1), v := SubStr(Field, EqualPos+1)
k := Trim(k, " `t`r"), v := Trim(v, " `t`r")
kn[CurLevel] := k
if !(EqualPos = 0)	; key-value
{
if (CurLevel = 1)
obj[kn.1] := v
else if (CurLevel = 2)
obj[kn.1][k] := v
else if (CurLevel = 3)
obj[kn.1][kn.2][k] := v
else if (CurLevel = 4)
obj[kn.1][kn.2][kn.3][k] := v
else if (CurLevel = 5)
obj[kn.1][kn.2][kn.3][kn.4][k] := v
else if (CurLevel = 6)
obj[kn.1][kn.2][kn.3][kn.4][kn.5][k] := v
else if (CurLevel = 7)
obj[kn.1][kn.2][kn.3][kn.4][kn.5][kn.6][k] := v		; etc...
}
else	; sub-object
{
if (CurLevel = 1)
obj.Insert(kn.1,Object())
else if (CurLevel = 2)
obj[kn.1].Insert(kn.2,Object())
else if (CurLevel = 3)
obj[kn.1][kn.2].Insert(kn.3,Object())
else if (CurLevel = 4)
obj[kn.1][kn.2][kn.3].Insert(kn.4,Object())
else if (CurLevel = 5)
obj[kn.1][kn.2][kn.3][kn.4].Insert(kn.5,Object())
else if (CurLevel = 6)
obj[kn.1][kn.2][kn.3][kn.4][kn.5].Insert(kn.6,Object())		; etc...
}
}
return obj
}
ObjToStr(Obj, Indent="`t", Rows="`n", Equal=" = ", Depth=7, CurIndent="") {	; converts object to string
For k,v in Obj
ToReturn .= CurIndent . k . (IsObject(v) && depth>1 ? Rows . ObjToStr(v, Indent, Rows, Equal, Depth-1, CurIndent . Indent) : Equal . v) . Rows
return RTrim(ToReturn, Rows)
}	; http://www.autohotkey.com/forum/post-426623.html#426623
ObjFromFile(FilePath, Indent="`t", Rows="`n", Equal="=") {		; creates object from file
if !FileExist(FilePath)
return
FileRead, String, %FilePath%
return ObjFromStr(String, Indent, Rows, Equal)	; creates and returns object from string
}
ObjToFile(Obj, FilePath, Indent="`t", Rows="`n", Equal=" = ", Depth=7) {	; saves object to file
if FileExist(FilePath)
FileDelete, %FilePath%	; delete old
FileAppend, % ObjToStr(Obj, Indent, Rows, Equal, Depth), %FilePath%, UTF-8	; store new
return ErrorLevel
}

/* Title:    Toolbar
Toolbar control.
(see toolbar.png)
The module is designed with following goals in mind :
* To allow programmers to quickly create toolbars in intuitive way.
* To allow advanced (non-typical) use, such as dynamic toolbar creation in such way that it doesn't complicate typical toolbar usage.
* To allow users to customize toolbar and programmer to save changed toolbar state.
* Not to have any side effects on your script.
*/
/* Function:  Add
Add a Toolbar to the GUI
Parameters:
hGui		- HWND of the GUI. GUI must have defined size.
Handler		- User function that handles Toolbar events. See below.
Style		- Styles to apply to the toolbar control, see list of styles bellow.
ImageList	- Handle of the image list that contains button images. Otherwise it specifies number and icon size of the one of the 3 system catalogs (see Toolbar_catalogs.png).
Each catalog contains number of common icons in large and small size -- S or L (default). Defaults to "1L" (first catalog, large icons)
Pos			- Position of the toolbar specified - any space separated combination of the x y w h keywords followed by the size.
Control Styles:
adjustable	- Allows users to change a toolbar button's position by dragging it while holding down the SHIFT key and to open customization dialog by double clicking Toolbar empty area, or separator.
border		- Creates a Toolbar that has a thin-line border.
bottom		- Causes the control to position itself at the bottom of the parent window's client area.
flat		- Creates a flat toolbar. In a flat toolbar, both the toolbar and the buttons are transparent and hot-tracking is enabled. Button text appears under button bitmaps. To prevent repainting problems, this style should be set before the toolbar control becomes visible.
list		- Creates a flat toolbar with button text to the right of the bitmap. Otherwise, this style is identical to FLAT style. To prevent repainting problems, this style should be set before the toolbar control becomes visible.
tooltips	- Creates a ToolTip control that an application can use to display descriptive text for the buttons in the toolbar.
nodivider	- Prevents a two-pixel highlight from being drawn at the top of the control.
tabstop		- Specifies that a control can receive the keyboard focus when the user presses the TAB key.
wrapable	- Creates a toolbar that can have multiple lines of buttons. Toolbar buttons can "wrap" to the next line when the toolbar becomes too narrow to include all buttons on the same line. When the toolbar is wrapped, the break will occur on either the rightmost separator or the rightmost button if there are no separators on the bar. This style must be set to display a vertical toolbar control when the toolbar is part of a vertical rebar control.
vertical	- Creates vertical toolbar.
menu		- Creates a toolbar that simulates Windows menu.
Handler:
> Handler(Hwnd, Event, Txt, Pos, Id)
Hwnd	- Handle of the Toolbar control sending the message.
Event	- Event name. See bellow.
Txt		- Button caption.
Pos		- Button position.
Id		- Button ID.
Events:
click	- User has clicked on the button.
rclick  - User has clicked the right button.
menu	- User has clicked on the dropdown icon.
hot		- User is hovering the button with the mouse.
change	- User has dragged the button using SHIFT + drag.
adjust	- User has finished customizing the toolbar.
Returns:
Control's handle or error message.
Remarks:
To avoid lost messages and/or script lockup, events triggered by the toolbar buttons should complete quickly.
If an event takes more than a few milliseconds to complete, consider creating an independent thread to accomplish the task:
(start code)
if event=click
if button=BigFatRoutine
{
SetTimer MyBigFatRoutine,0
return
}
(end code)
If you happen to have unusual control behavior-missing events, redrawing issues etc... try adding _Critical_ command (or better Critical N) at the start of the Toolbar_onNotify function.
It helps to improve the odds that no messages are dropped. The drawback of using the command is that the function refuses to be interrupted.
This is not a problem if the developer is very careful not to call any routines or functions that use anything more than a few milliseconds.
However, any little mistake -- an unexpected menu, prompt, MsgBox, etc., and the script will lock up.
Without the Critical command, the function is a lot more forgiving.
The developer should still be careful but the script won't shut down if something unexpected happens.
*/
Toolbar_Add(hGui, Handler, Style="", ImageList="", Pos="") {
static MODULEID
static WS_CHILD := 0x40000000, WS_VISIBLE := 0x10000000, WS_CLIPSIBLINGS = 0x4000000, WS_CLIPCHILDREN = 0x2000000, TBSTYLE_THICKFRAME=0x40000, TBSTYLE_TABSTOP = 0x10000
static TBSTYLE_WRAPABLE = 0x200, TBSTYLE_FLAT = 0x800, TBSTYLE_LIST=0x1000, TBSTYLE_TOOLTIPS=0x100, TBSTYLE_TRANSPARENT = 0x8000, TBSTYLE_ADJUSTABLE = 0x20, TBSTYLE_VERTICAL=0x80
static TBSTYLE_EX_DRAWDDARROWS = 0x1, TBSTYLE_EX_HIDECLIPPEDBUTTONS=0x10, TBSTYLE_EX_MIXEDBUTTONS=0x8
static TB_BUTTONSTRUCTSIZE=0x41E, TB_SETEXTENDEDSTYLE := 0x454, TB_SETUNICODEFORMAT := 0x2005
static TBSTYLE_NODIVIDER=0x40, CCS_NOPARENTALIGN=0x8, CCS_NORESIZE = 0x4, TBSTYLE_BOTTOM = 0x3, TBSTYLE_MENU=0, TBSTYLE_BORDER=0x800000
if !MODULEID {
old := OnMessage(0x4E, "Toolbar_onNotify"),	MODULEID := 80609
if old != Toolbar_onNotify
Toolbar("oldNotify", RegisterCallback(old))
}
Style .= Style="" ? "WRAPABLE" : "", ImageList .= ImageList="" ? "1L" : ""
hStyle := 0
hExStyle := TBSTYLE_EX_MIXEDBUTTONS ; TBSTYLE_EX_HIDECLIPPEDBUTTONS
if bMenu := InStr(Style, "MENU")
hStyle |= TBSTYLE_FLAT | TBSTYLE_LIST | WS_CLIPSIBLINGS		;set this style only if custom flag MENU is set. It serves only as a mark later
else hExStyle |= TBSTYLE_EX_DRAWDDARROWS
loop, parse, Style, %A_Tab%%A_Space%, %A_Tab%%A_Space%
ifEqual, A_LoopField,,continue
else hStyle |= A_LoopField+0 ? A_LoopField : TBSTYLE_%A_LoopField%
ifEqual, hStyle, ,return A_ThisFunc "> Some of the styles are invalid."
if (Pos != ""){
x := y := 0, w := h := 100
loop, parse, Pos, %A_Tab%%A_Space%, %A_Tab%%A_Space%
{
ifEqual, A_LoopField, , continue
p := SubStr(A_LoopField, 1, 1)
if p not in x,y,w,h
return A_ThisFunc ">  Invalid position specifier"
%p% := SubStr(A_LoopField, 2)
}
hStyle |= CCS_NOPARENTALIGN | TBSTYLE_NODIVIDER | CCS_NORESIZE
}
hCtrl := DllCall("CreateWindowEx"
, "uint", 0
, "str",  "ToolbarWindow32"
, "uint", 0
, "uint", WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | hStyle
, "uint", x, "uint", y, "uint", w, "uint", h
, "uint", hGui
, "uint", MODULEID
, "uint", 0
, "uint", 0, "Uint")
ifEqual, hCtrl, 0, return 0
SendMessage, TB_BUTTONSTRUCTSIZE, 20, 0, , ahk_id %hCtrl%
SendMessage, TB_SETEXTENDEDSTYLE, 0, hExStyle, , ahk_id %hCtrl%
SendMessage, TB_SETUNICODEFORMAT, A_IsUnicode,,, ahk_id %hCtrl% ; Ansi = 0, Unicode !=0
if(ImageList != "")
Toolbar_SetImageList(hCtrl, ImageList)
if IsFunc(Handler)
Toolbar(hCtrl "Handler", Handler)
return hCtrl
}
/*
Function:  AutoSize
Causes a toolbar to be resized.
Parameters:
Align	 - How toolbar is aligned to its parent. bottom left (bl), bottom right (br), top right (tr), top left (tl) or fit (doesn't reposition control
resizes it so it takes minimum possible space with all buttons visible)
Remarks:
An application calls the AutoSize function after causing the size of a toolbar to
change either by setting the button or bitmap size or by adding strings for the first time.
*/
Toolbar_AutoSize(hCtrl, Align="fit"){
if align !=
{
dhw := A_DetectHiddenWindows
DetectHiddenWindows,on
Toolbar_GetMaxSize(hCtrl, w, h)
SysGet, f, 8		;SM_CYFIXEDFRAME , Thickness of the frame around the perimeter of a window that has a caption but is not sizable
SysGet, c, 4		;SM_CYCAPTION: Height of a caption area, in pixels.
hParent := DllCall("GetParent", "uint", hCtrl)
WinGetPos, ,,pw,ph, ahk_id %hParent%
if Align = fit
ControlMove,,,,%w%,%h%, ahk_id %hCtrl%
else if Align = tr
ControlMove,,pw-w-f,c+f+2,%w%,%h%, ahk_id %hCtrl%
else if Align = tl
ControlMove,,f,c+f+2,%w%,%h%, ahk_id %hCtrl%
else if Align = br
ControlMove,,pw-w-f,ph-h-f,%w%,%h%, ahk_id %hCtrl%
else if Align = bl
ControlMove,,,ph-h-f,%w%,%h%, ahk_id %hCtrl%
DetectHiddenWindows, %dhw%
}
else SendMessage,0x421,,,,ahk_id %hCtrl%
}
/*
Function:  Clear
Removes all buttons from the toolbar, both current and available
*/
Toolbar_Clear(hCtrl){
loop % Toolbar_Count(hCtrl)
SendMessage, 0x416, , , ,ahk_id %hCtrl%		;TB_DELETEBUTTON
Toolbar_mfree( Toolbar( hCtrl "aBTN", "" ) )
SendMessage,0x421,,,,ahk_id %hCtrl%				;Autosize
}
/*
Function:  Count
Get count of buttons on the toolbar
Parameters:
pQ			- Query parameter, set to "c" to get the number of current buttons (default)
Set to "a" to get the number of available buttons. Set to empty string to return both.
Returns:
if pQ is empty function returns rational number in the form cntC.cntA otherwise  requested count
*/
Toolbar_Count(hCtrl, pQ="c") {
static TB_BUTTONCOUNT = 0x418
SendMessage, TB_BUTTONCOUNT, , , ,ahk_id %hCtrl%
c := ErrorLevel
IfEqual, pQ, c, return c
a := NumGet( Toolbar(hCtrl "aBTN") )
ifEqual, pQ, a, return a
return c "." a
}
/*
Function:  CommandToIndex
Retrieves the button position given the ID.
Parameters:
ID	- Button ID, number > 0.
Returns:
0 if button with that ID doesn't exist, pos > 0 otherwise.
*/
Toolbar_CommandToIndex( hCtrl, ID ) {
static TB_COMMANDTOINDEX=0x419
SendMessage, TB_COMMANDTOINDEX, ID,, ,ahk_id %hCtrl%
ifEqual, ErrorLevel, 4294967295, return 0
return ErrorLevel + 1
}
/*
Function:  Customize
Launches customization dialog
(see Toolbar_customize.png)
*/
Toolbar_Customize(hCtrl) {
static TB_CUSTOMIZE=0x41B
SendMessage, TB_CUSTOMIZE,,,, ahk_id %hCtrl%
}
/*
Function:  CheckButton
Get button information
Parameters:
WhichButtton - One of the ways to identify the button: 1-based button position or button ID.
If WhichButton is negative, the information about available (*) button on position -WhichButton will be returned.
bCheck		 - Set to 1 to check the button (default).
Returns:
Returns TRUE if successful, or FALSE otherwise.
Remarks:
With groupcheck use this function to check button. Using <SetButton> function will not uncheck other buttons in the group.
*/
Toolbar_CheckButton(hCtrl, WhichButton, bCheck=1) {
static TB_CHECKBUTTON = 0x402
if (WhichButton >= 1){
VarSetCapacity(TBB, 20)
SendMessage, TB_GETBUTTON, --WhichButton, &TBB,,ahk_id %hCtrl%
WhichButton := NumGet(&TBB+0, 4)
} else WhichButton := SubStr(WhichButton, 2)
SendMessage, TB_CHECKBUTTON, WhichButton, bCheck, ,ahk_id %hCtrl%
}
/*
Function:  Define
Get the toolbar definition list.
Parameters:
pQ	- Query parameter. Specify "c" to get only current buttons, "a" to get only available buttons.
Leave empty to get all buttons.
Returns:
Button definition list. You can use the list directly with <Insert> function.
*/
Toolbar_Define(hCtrl, pQ="") {
if pQ !=
if pQ not in a,c
return A_ThisFunc "> Invalid query parameter: " pQ
if (pQ = "") or (pQ = "c")
loop, % Toolbar_Count(hCtrl)
btns .= Toolbar_GetButton(hCtrl, A_Index) "`n"
ifEqual, pQ, c, return SubStr(btns, 1, -2)
if (pQ="") or (pQ = "a"){
ifEqual, pQ, , SetEnv, btns, %btns%`n
cnta := NumGet( Toolbar(hCtrl "aBTN") )
loop, %cnta%
btns .= Toolbar_GetButton(hCtrl, -A_Index) "`n"
return SubStr(btns, 1, -2)
}
}
/* Function:  DeleteButton
Delete button from the toolbar.
Parameters:
Pos		- 1-based position of the button, by default 1.
To delete one of the available buttons, specify "*" before the position.
Returns:
TRUE if successful.
*/
Toolbar_DeleteButton(hCtrl, Pos=1) {
static TB_DELETEBUTTON = 0x416
if InStr(Pos, "*") {
Pos := SubStr(Pos, 2),  aBTN := Toolbar(hCtrl "aBTN"),  cnta := NumGet(aBTN+0)
if (Pos > cnta)
return FALSE
if (Pos < cnta)
Toolbar_memmove( aBTN + 20*(Pos-1) +4, aBTN + 20*Pos +4, aBTN + 20*Pos +4)
NumPut(cnta-1, aBTN+0)
return TRUE
}
SendMessage, TB_DELETEBUTTON, Pos-1, , ,ahk_id %hCtrl%
return ErrorLevel
}
/*
Function:  GetButton
Get button information
Parameters:
WhichButtton - One of the ways to identify the button: 1-based button position or button ID.
If WhichButton is negative, the information about available (*) button on position -WhichButton will be returned.
pQ			- Query parameter, can be C (Caption) I (Icon number), S (State), L (styLe) or ID.
If omitted, all information will be returned in the form of button definition.
Returns:
If pQ is omitted, button definition, otherwise requested button information.
Examples:
(start code)
s := GetButton(hCtrl, 3)			 ;returns button definition for the third button.
c := GetButton(hCtrl, 3, "c")	 ;returns only caption of that button.
d := GetButton(hCtrl,-2, "id")	 ;returns only id of the 2nd button from the group of available (*) buttons.
s := GetButton(hCtrl, .101, "s")	 ;returns the state of the button with ID=101.
(end code)
*/
Toolbar_GetButton(hCtrl, WhichButton, pQ="") {
static TB_GETBUTTON=0x417, TB_GETBUTTONTEXTA=0x42D, TB_GETBUTTONTEXTW=0x44B, TB_GETSTRINGA=0x45C, TB_GETSTRINGW=0x45B, TB_COMMANDTOINDEX=0x419
if WhichButton is not number
return A_ThisFunc "> Invalid button position or ID: " WhichButton
if (WhichButton < 0)
a := Toolbar(hCtrl "aBTN"), aBtn := a + 4,  cnta := NumGet(a+0),  WhichButton := -WhichButton,   a := true
else if (WhichButton < 1){
ifEqual, WhichButton, 0, return A_ThisFunc "> 0 is invalid position and ID"
SendMessage, TB_COMMANDTOINDEX, SubStr(WhichButton, 2),, ,ahk_id %hCtrl%
ifEqual, ErrorLevel, 4294967295, return A_ThisFunc "> No such ID " SubStr(WhichButton, 2)
WhichButton := ErrorLevel + 1
}
WhichButton--
if (a AND (cnta < WhichButton)) OR (!a and (Toolbar_Count(hCtrl) < WhichButton) )
return A_ThisFunc "> Button position is too large: " WhichButton
VarSetCapacity(TBB, 20), aTBB := &TBB
if a
aTBB := aBtn + WhichButton*20
else SendMessage, TB_GETBUTTON, WhichButton, aTBB,,ahk_id %hCtrl%
id := NumGet(aTBB+0, 4)
IfEqual, pQ, id, return id
if NumGet(aTBB+0, 9, "Char") = 1  {
loop, % NumGet(TBB)//10 + 1
buf .= "-"
return buf
}
VarSetCapacity( buf, 256 ), sIdx := NumGet(aTBB+0, 16)
SendMessage, A_IsUnicode ? TB_GETSTRINGW : TB_GETSTRINGA , (sIdx<<16)|128, &buf, ,ahk_id %hCtrl%			;SendMessage, TB_GETBUTTONTEXT,id,&buf,,ahk_id %hCtrl%
VarSetCapacity( buf, -1 )
if a
buf := "*" buf
ifEqual, pQ, c, return buf
state := Toolbar_getStateName(NumGet(aTBB+0, 8, "Char"))
ifEqual, pQ, S, return state
icon := NumGet(aTBB+0)+1
ifEqual, pQ, I, return icon
style := Toolbar_getStyleName(NumGet(aTBB+0, 9, "Char"))
ifEqual, pQ, L, return style
buf :=  buf ", " icon ", " state ", " style (id < 10000 ? ", " id : "")
return buf
}
/*
Function:	GetButtonSize
Gets the size of the buttons.
Parameters:
W, H - Output width & height.
*/
Toolbar_GetButtonSize(hCtrl, ByRef W, ByRef H) {
static TB_GETBUTTONSIZE=1082
SendMessage, TB_GETBUTTONSIZE, , , ,ahk_id %hCtrl%
W := ErrorLevel & 0xFFFF, H := ErrorLevel >> 16
}
/*
Function:  GetMaxSize
Retrieves the total size of all of the visible buttons and separators in the toolbar.
Parameters:
Width, Height		- Variables which will receive size.
Returns:
Returns TRUE if successful.
*/
Toolbar_GetMaxSize(hCtrl, ByRef Width, ByRef Height){
static TB_GETMAXSIZE = 0x453
VarSetCapacity(SIZE, 8)
SendMessage, TB_GETMAXSIZE, 0, &SIZE, , ahk_id %hCtrl%
res := ErrorLevel, 	Width := NumGet(SIZE), Height := NumGet(SIZE, 4)
return res
}
/*
Function:  GetRect
Get button rectangle
Parameters:
pPos		- Button position. Leave blank to get dimensions of the toolbar control itself.
pQ			- Query parameter: set x,y,w,h to return appropriate value, or leave blank to return all in single line.
Returns:
String with 4 values separated by space or requested information
*/
Toolbar_GetRect(hCtrl, Pos="", pQ="") {
static TB_GETITEMRECT=0x41D
if pPos !=
ifLessOrEqual, Pos, 0, return "Err: Invalid button position"
VarSetCapacity(RECT, 16)
SendMessage, TB_GETITEMRECT, Pos-1,&RECT, ,ahk_id %hCtrl%
IfEqual, ErrorLevel, 0, return A_ThisFunc "> Can't get rect"
if Pos =
DllCall("GetClientRect", "uint", hCtrl, "uint", &RECT)
x := NumGet(RECT, 0), y := NumGet(RECT, 4), r := NumGet(RECT, 8), b := NumGet(RECT, 12)
return (pQ = "x") ? x : (pQ = "y") ? y : (pQ = "w") ? r-x : (pQ = "h") ? b-y : x " " y " " r-x " " b-y
}
/*
Function:  Insert
Insert button(s) on the Toolbar.
Parameters:
Btns		- The button definition list. Each button to be added is specified on separate line
using button definition string. Empty lines will be skipped.
Pos			- Optional 1-based index of a button, to insert the new buttons to the left of this button.
This doesn't apply to the list of available buttons.
Button Definition:
Button is defined by set of its characteristics separated by comma:
caption		- Button caption. All printable letters are valid except comma.
"-" can be used to add separator. Add more "-" to set the separator width. Each "-" adds 10px to the separator.
iconNumber  - Number of icon in the image list
states		- Space separated list of button states. See bellow list of possible states.
styles		- Space separated list of button styles. See bellow list of possible styles.
ID			- Button ID, unique number you choose to identify button. On customizable toolbars position can't be used to set button information.
If you need to setup button information using <SetButton> function or obtain information using <GetButton>, you need to use button ID
as user can change button position any time.
It can by any number. Numbers > 10,000 are choosen by module as auto ID feature, that module does on its own when you don't use this option.
In most typical scenarios you don't need to use ID or think about them to identify the button. To specify ID in functions that accept it
put dot infront of it, for instance .427 represents ID=427. This must be done in order to differentiate IDs from button position.
Button Styles:
AUTOSIZE	- Specifies that the toolbar control should not assign the standard width to the button. Instead, the button's width will be calculated based on the width of the text plus the image of the button.
CHECK		- Creates a dual-state push button that toggles between the pressed and nonpressed states each time the user clicks it.
CHECKGROUP	- Creates a button that stays pressed until another button in the group is pressed, similar to option buttons (also known as radio buttons).
DROPDOWN	- Creates a drop-down style button that can display a list when the button is clicked.
NOPREFIX	- Specifies that the button text will not have an accelerator prefix associated with it.
SHOWTEXT	- Specifies that button text should be displayed. All buttons can have text, but only those buttons with the SHOWTEXT button style will display it.
This button style must be used with the LIST style. If you set text for buttons that do not have the SHOWTEXT style, the toolbar control will
automatically display it as a ToolTip when the cursor hovers over the button. For this to work you must create the toolbar with TOOLTIPS style.
You can create multiline tooltips by using `r in the tooltip caption. Each `r will be replaced with new line.
Button States:
CHECKED		- The button has the CHECK style and is being clicked.
DISABLED	- The button does not accept user input.
HIDDEN		- The button is not visible and cannot receive user input.
WRAP		- The button is followed by a line break. Toolbar must not have WRAPABLE style.
Remarks:
Using this function you can insert one or more buttons on the toolbar. Furthermore, adding group of buttons to the end (omiting pPos) is the
fastest way of adding set of buttons to the toolbar and it also allows you to use some automatic features that are not available when you add button by button.
If you omit some parameter in button definition it will receive default value. Button that has no icon defined will get the icon with index that is equal to
the line number of its defintion list. Buttons without ID will get ID automaticaly, starting from 10 000.
You can use `r instead `n to create multiline button captions. This make sense only for toolbars that have LIST TOOLTIP toolbar style and no SHOWTEXT button style
(i.e. their captions are seen as tooltips and are not displayed.
*/
Toolbar_Insert(hCtrl, Btns, Pos=""){
static TB_ADDBUTTONSA=0x414, TB_ADDBUTTONSW=0x444, TB_INSERTBUTTONA=0x415, TB_INSERTBUTTONW = 0x443
cnt := Toolbar_compileButtons(hCtrl, Btns, cBTN)
if Pos =
SendMessage, A_IsUnicode ? TB_ADDBUTTONSW : TB_ADDBUTTONSA, cnt, cBTN ,, ahk_id %hCtrl%
else loop, %cnt%
SendMessage, A_IsUnicode ? TB_INSERTBUTTONW : TB_INSERTBUTTONA, Pos+A_Index-2, cBTN + 20*(A_Index-1) ,, ahk_id %hCtrl%
Toolbar_mfree(cBTN)
SendMessage,0x421,,,,ahk_id %hCtrl%	;autosize
SendMessage,0x421,,,,ahk_id %hCtrl%	;autosize
}
/*
Function:  MoveButton
Moves a button from one position to another.
Parameters:
Pos		- 1-based position of the button to be moved.
NewPos	- 1-based position where the button will be moved.
Returns:
Returns nonzero if successful, or zero otherwise.
*/
Toolbar_MoveButton(hCtrl, Pos, NewPos) {
static TB_MOVEBUTTON = 0x452
SendMessage, TB_MOVEBUTTON, Pos-1, NewPos-1, ,ahk_id %hCtrl%
return ErrorLevel
}
/*
Function:  SetBitmapSize
Sets the size of the bitmapped images to be added to a toolbar.
Parameters:
Width, Height - Width & heightin pixels, of the bitmapped images. Defaults to 0,0
Returns:
TRUE if successful, or FALSE otherwise.
Remarks:
The size can be set only before adding any bitmaps to the toolbar.
If an application does not explicitly set the bitmap size, the size defaults to 16 by 15 pixels.
*/
Toolbar_SetBitmapSize(hCtrl, Width=0, Height=0) {
static TB_SETBITMAPSIZE=1056
SendMessage, TB_SETBITMAPSIZE, Width,Height, ,ahk_id %hCtrl%
}
/*
Function:  SetButton
Set button information
Parameters:
WhichButton	- One of the 2 ways to identify the button: 1-based button position or button ID
State		- List of button states to set, separated by white space.
Width		- Button width (can't be used with LIST style)
Returns:
Nonzero if successful, or zero otherwise.
*/
Toolbar_SetButton(hCtrl, WhichButton, State="", Width=""){
static TBIF_TEXT=2, TBIF_STATE=4, TBIF_SIZE=0x40,
static TB_SETBUTTONINFO=0x442, TB_GETSTATE=0x412, TB_GETBUTTON = 0x417
static TBSTATE_CHECKED=1, TBSTATE_ENABLED=4, TBSTATE_HIDDEN=8, TBSTATE_ELLIPSES=0x40, TBSTATE_DISABLED=0
if WhichButton is not number
return A_ThisFunc "> Invalid button position or ID: " WhichButton
if (WhichButton >= 1){
VarSetCapacity(TBB, 20)
SendMessage, TB_GETBUTTON, --WhichButton, &TBB,,ahk_id %hCtrl%
WhichButton := NumGet(&TBB+0, 4)
} else WhichButton := SubStr(WhichButton, 2)
SendMessage, TB_GETSTATE, WhichButton,,,ahk_id %hCtrl%
hState := ErrorLevel
mask := 0
,mask |= State != "" ?  TBIF_STATE : 0
,mask |= Width != "" ?  TBIF_SIZE  : 0
if InStr(State, "-disabled") {
hState |= TBSTATE_ENABLED
StringReplace, State, State, -disabled
}
else if InStr(State, "disabled")
hState &= ~TBSTATE_ENABLED
loop, parse, State, %A_Tab%%A_Space%, %A_Tab%%A_Space%
{
ifEqual, A_LoopField,,continue
if SubStr(A_LoopField, 1, 1) != "-"
hState |= TBSTATE_%A_LOOPFIELD%
else  k := SubStr(A_LoopField, 2),    k := TBSTATE_%k%, 	hState &= ~k
}
ifEqual, hState, , return A_ThisFunc "> Some of the states are invalid: " State
VarSetCapacity(BI, 32, 0)
NumPut(32,		BI, 0)
NumPut(mask,	BI, 4)
NumPut(hState,	BI, 16, "Char")
NumPut(Width,	BI, 18, "Short")
SendMessage, TB_SETBUTTONINFO, WhichButton, &BI, ,ahk_id %hCtrl%
res := ErrorLevel
SendMessage, 0x421, , ,,ahk_id %hCtrl%	;autosize
return res
}
/*
Function:  SetButtonWidth
Sets button width.
Parameters:
Min, Max - Minimum and maximum button width. If you omit pMax it defaults to pMin.
Returns:
TRUE if successful.
*/
Toolbar_SetButtonWidth(hCtrl, Min, Max=""){
static TB_SETBUTTONWIDTH=0x43B
ifEqual, Max, , SetEnv, Max, %Min%
SendMessage, TB_SETBUTTONWIDTH, 0,(Max<<16) | Min,,ahk_id %hCtrl%
return ErrorLevel
}
/*
Function:  SetDrawTextFlags
Sets the text drawing flags for the toolbar.
Parameters:
Mask  - One or more of the DT_ flags, specified in DrawText, that indicate which bits in dwDTFlags will be used when drawing the text.
Flags - One or more of the DT_ flags, specified in DrawText, that indicate how the button text will be drawn.
This value will be passed to the DrawText API when the button text is drawn.
Returns:
Returns the previous text drawing flags.
Remarks:
See <http://msdn.microsoft.com/en-us/library/bb787425(VS.85).aspx> for more info.
Example:
Toolbar_SetDrawTextFlags(hToolbar, 3, 2) ;right align text
*/
Toolbar_SetDrawTextFlags(hCtrl, Mask, Flags) {
static TB_SETDRAWTEXTFLAGS = 1094
SendMessage, TB_SETDRAWTEXTFLAGS, Mask,Flags,,ahk_id %hCtrl%
return ErrorLevel
}
/*
Function:	SetButtonSize
Sets the size of buttons.
Parameters:
W, H	- Width & Height. If you omit height, it defaults to width.
Remarks:
With LIST style, you can only set the height.
*/
Toolbar_SetButtonSize(hCtrl, W, H="") {
static TB_SETBUTTONSIZE = 0x41F
IfEqual, H, ,SetEnv, H, %W%
SendMessage, TB_SETBUTTONSIZE, ,(H<<16)|W ,,ahk_id %hCtrl%
}
/*
Function:  SetImageList
Set toolbar image list.
Parameters:
hIL	- Image list handle.
Returns:
Handle of the previous image list.
*/
Toolbar_SetImageList(hCtrl, hIL="1S"){
static TB_SETIMAGELIST = 0x430, TB_LOADIMAGES=0x432, TB_SETBITMAPSIZE=0x420
hIL .= 	if StrLen(hIL) = 1 ? "S" : ""
if hIL is Integer
SendMessage, TB_SETIMAGELIST, 0, hIL, ,ahk_id %hCtrl%
else {
size := SubStr(hIL,2,1)="L" ? 24:16,  cat := (SubStr(hIL,1,1)-1)*4 + (size=16 ? 0:1)
SendMessage, TB_SETBITMAPSIZE,0,(size<<16)+size, , ahk_id %hCtrl%
SendMessage, TB_LOADIMAGES, cat, -1,,ahk_id %hCtrl%
}
return ErrorLevel
}
/*
Function:  SetMaxTextRows
Sets the maximum number of text rows displayed on a toolbar button.
Parameters:
iMaxRows	- Maximum number of rows of text that can be displayed.
Remarks:
Returns nonzero if successful, or zero otherwise. To cause text to wrap, you must set the maximum
button width by using <SetButtonWidth>. The text wraps at a word break. Text in LIST styled toolbars is always shown on a single line.
*/
Toolbar_SetMaxTextRows(hCtrl, iMaxRows=0) {
static TB_SETMAXTEXTROWS = 0x43C
SendMessage, TB_SETMAXTEXTROWS,iMaxRows,,,ahk_id %hCtrl%
res := ErrorLevel
return res
}
/*	Function:	ToggleStyle
Toggle specific toolbar creation style
Parameters:
Style	- Style to toggle, by default "LIST". You can also specify numeric style value.
*/
Toolbar_ToggleStyle(hCtrl, Style="LIST"){
static TBSTYLE_WRAPABLE = 0x200, TBSTYLE_FLAT = 0x800, TBSTYLE_LIST=0x1000, TBSTYLE_TOOLTIPS=0x100, TBSTYLE_TRANSPARENT = 0x8000, TBSTYLE_ADJUSTABLE = 0x20,  TBSTYLE_BORDER=0x800000, TBSTYLE_THICKFRAME=0x40000, TBSTYLE_TABSTOP = 0x10000
static TB_SETSTYLE=1080, TB_GETSTYLE=1081
s := Style+0 != "" ? Style : TBSTYLE_%Style%
ifEqual, s, , return A_ThisFunc "> Invalid style: " Style
WinSet, Style, ^%s%, ahk_id %hCtrl%
if (s = TBSTYLE_LIST) {
Toolbar_SetMaxTextRows(hCtrl, 0)
Toolbar_SetMaxTextRows(hCtrl, 1)
}
}
/*
Parse button definition list and compile it the into binary array. Add strings to pull. Return number of current buttons.
cBTN	- Pointer to the compiled button array of current buttons
Btns - Button definition list
aBTN - Pointer to the compiled button array of available buttons
Button definition:
[*]caption, icon, state, style, id
*/
Toolbar_compileButtons(hCtrl, Btns, ByRef cBTN) {
static BTNS_SEP=1, BTNS_CHECK =2, BTNS_CHECKGROUP = 6, BTNS_DROPDOWN = 8, BTNS_A=16, BTNS_AUTOSIZE = 16, BTNS_NOPREFIX = 32, BTNS_SHOWTEXT = 64
static TBSTATE_CHECKED=1, TBSTATE_ENABLED=4, TBSTATE_HIDDEN=8, TBSTATE_DISABLED=0, TBSTATE_WRAP = 0x20
static TB_ADDSTRINGA=0x41C, TB_ADDSTRINGW=0x44D, WS_CLIPSIBLINGS = 0x4000000
static id=10000								;automatic IDing starts form 10000,     1 <= userID < 10 000
WinGet, bMenu, Style, ahk_id %hCtrl%
bMenu := bMenu & WS_CLIPSIBLINGS
aBTN := Toolbar(hCtrl "aBTN")
if (aBTN = "")
aBTN := Toolbar_malloc( 50 * 20 + 4),  Toolbar(hCtrl "aBTN", aBTN)	 ;if space for array of * buttons isn't reserved and there are definitions of * buttons reserve it for 50 buttons + some more so i can keep some data there...
StringReplace, _, Btns, `n, , UseErrorLevel
btnNo := ErrorLevel + 1
cBTN := Toolbar_malloc( btnNo * 20 )
a := cnt := 0, 	cnta := NumGet(aBTN+0)		;get number of buttons in the array
loop, parse, Btns, `n, %A_Space%%A_Tab%
{
ifEqual, A_LoopField, ,continue			;skip emtpy lines
a1:=a2:=a3:=a4:=a5:=""					;a1-caption;  a2-icon_num;  a3-state;  a4-style;	a5-id;
StringSplit, a, A_LoopField, `,,%A_Space%%A_Tab%
if (bMenu AND a2="") or (a2=0)
a2 := -1		;so to become I_IMAGENONE = -2
a := SubStr(a1,1,1) = "*"
if a
a1 := SubStr(a1,2), o := aBTN + 4
else o := cBTN
hState := InStr(a3, "disabled") ? 0 : TBSTATE_ENABLED
loop, parse, a3, %A_Tab%%A_Space%, %A_Tab%%A_Space%
{
ifEqual, A_LoopField,,continue
hState |= TBSTATE_%A_LOOPFIELD%
}
ifEqual, hState, , return A_ThisFunc "> Some of the states are invalid: " a3
hStyle := bMenu ? BTNS_SHOWTEXT | BTNS_DROPDOWN : 0
hstyle |= (A_LoopField >= "-") and (A_LoopField <= "-------------------") ? BTNS_SEP : 0
sep += (hStyle = BTNS_SEP) ? 1 : 0
loop, parse, a4, %A_Tab%%A_Space%, %A_Tab%%A_Space%
{
ifEqual, A_LoopField,,continue
hstyle |= BTNS_%A_LOOPFIELD%
}
ifEqual, hStyle, , return A_ThisFunc "> Some of the styles are invalid: " a4
if a2 is not Integer					;if user didn't specify icon, use button number as icon index (don't count separators)
a2 := cnt+cnta+1-sep
o += 20 * (a ? cnta : cnt)				;calculate offset o of this structure in array of TBBUTON structures.
if (hStyle != BTNS_SEP) {
StringReplace a1, a1, `r, `n, A		;replace `r with new lines (for multiline tooltips)
VarSetCapacity(buf, StrLen(a1)*2+2, 0), buf := a1	 ;Buf must be double-NULL-terminated, use unicode length in both cases.
sIdx := DllCall("SendMessage","uint",hCtrl,"uint", A_IsUnicode ? TB_ADDSTRINGW : TB_ADDSTRINGA, "uint", 0, "str", buf)  ;returns the new index of the string within the string pool
} else sIdx := -1,  a2 := (StrLen(A_LoopField)-1)*10 + 1			;if separator, lentgth of the "-" string determines width of the separation. Each - adds 10 pixels.
bid := a5 ? a5 : ++id 					;user id or auto id makes button id
NumPut(a2-1,	o+0, 0, "Int")			;Zero-based index of the button image. If the button is a separator, determines the width of the separator, in pixels
NumPut(bid,		o+0, 4, "Int")			;Command identifier associated with the button
NumPut(hstate,  o+0, 8, "Char")			;Button state flags
NumPut(hStyle,  o+0, 9, "Char")			;Button style
NumPut(0,		o+0, 12)				;User data
NumPut(sIdx,	o+0, 16, "Int")			;Zero-based index of the button string
if a
{
if (cnta = 50)
warning := true
else cnta++
}
else cnt++
}
NumPut(cnta, aBTN + 0)
if warning
msgbox You exceeded the limit of available (*) buttons (50)
return cnt									;return number of buttons in the array
}
Toolbar_onNotify(Wparam,Lparam,Msg,Hwnd) {
static MODULEID = 80609, oldNotify="*"
static NM_CLICK=-2, NM_RCLICK=-5, NM_LDOWN=-20, TBN_DROPDOWN=-710, TBN_HOTITEMCHANGE=-713, TBN_ENDDRAG=-702, TBN_GETBUTTONINFOA=-700, TBN_GETBUTTONINFOAW=-720, TBN_QUERYINSERT=-706, TBN_QUERYDELETE=-707, TBN_BEGINADJUST=-703, TBN_ENDADJUST=-704, TBN_RESET=-705, TBN_TOOLBARCHANGE=-708, TB_COMMANDTOINDEX=0x419
static cnt, cnta, cBTN, inDialog, tc=0
if (_ := (NumGet(Lparam+4))) != MODULEID
ifLess _, 10000, return	;if ahk control, return asap (AHK increments control ID starting from 1. Custom controls use IDs > 10000 as its unlikely that u will use more then 10K ahk controls.
else {
ifEqual, oldNotify, *, SetEnv, oldNotify, % Toolbar("oldNotify")
if oldNotify !=
return DllCall(oldNotify, "uint", Wparam, "uint", Lparam, "uint", Msg, "uint", Hwnd)
}
hw :=  NumGet(Lparam+0), code := NumGet(Lparam+8, 0, "Int"),  handler := Toolbar(hw "Handler")
ifEqual, handler,, return
iItem  := (code != TBN_HOTITEMCHANGE) ? NumGet(lparam+12) : NumGet(lparam+16)
SendMessage, TB_COMMANDTOINDEX,iItem,,,ahk_id %hw%
pos := ErrorLevel + 1 , txt := Toolbar_GetButton( hw, pos, "c")
if (code=TBN_ENDDRAG) {
IfEqual, pos, 4294967296, return
tc := A_TickCount
}
if (code=NM_CLICK) {
IfEqual, pos, 4294967296, return
if !(A_TickCount - tc)
%handler%(hw, "click", txt, pos, iItem)
}
if (code=NM_RCLICK)
ifEqual, pos, 4294967296, return
else  %handler%(hw,"rclick", txt, pos, iItem)
if (code = TBN_DROPDOWN)
%handler%(hw, "menu", txt, pos, iItem)
if (code = TBN_HOTITEMCHANGE) {
IfEqual, pos, 4294967296, return
return %handler%(hw, "hot", txt, pos,  iItem)
}
if (code = TBN_BEGINADJUST) {
cnta := NumGet( Toolbar(hw "aBTN") ) , cnt := Toolbar_getButtonArray(hw, cBTN), inDialog := true
if (cnt=0) && (cnta=0)
Msgbox Nothing to customize
return
}
if (code = TBN_GETBUTTONINFOA || code = TBN_GETBUTTONINFOAW)   {
if (iItem = cnt + cnta)					;iItem is position, not identifier. Win keeps sending incresing numbers until we say "no more" (return 0)
return 0
TBB := lparam + 16						;The OS buffer where to put the button structure
o := (iItem < cnt) ?  cBTN + 20*iItem : Toolbar( hw "aBTN") + 20*(iItem-cnt) + 4
Toolbar_memcpy( TBB, o, 20) ;copy the compiled item into notification struct
return 1
}
if (code = TBN_QUERYINSERT) or (code = TBN_QUERYDELETE) {
if (cnta="" or cnta=0) AND (cnt=0)
return FALSE
return TRUE
}
if (code=TBN_ENDADJUST) {
Toolbar_onEndAdjust(hw, cBTN, cnt), inDialog := false
return %handler%(hw, "adjust", "", "", "")
}
if (code = TBN_TOOLBARCHANGE) and !inDialog
return %handler%(hw, "change", "", "", "")
}
Toolbar_getButtonArray(hCtrl, ByRef cBtn){
static TB_GETBUTTON = 0x417
cnt := Toolbar_Count(hCtrl)
cBtn := Toolbar_malloc( cnt * 20 )
loop, %cnt%
SendMessage, TB_GETBUTTON, A_Index-1, cbtn + (A_Index-1)*20,,ahk_id %hCtrl%
return cnt
}
Toolbar_getStateName( hState ) {
static TBSTATE_HIDDEN=8, TBSTATE_PRESSED = 0x2, TBSTATE_CHECKED=1, TBSTATE_ENABLED=0x4
static states="hidden,pressed,checked,enabled"
if !(hState & TBSTATE_ENABLED)
state := "disabled "
ifEqual,hState, %TBSTATE_ENABLED%, return
loop, parse, states, `,
if (hState & TBSTATE_%A_LoopField%)
state .= A_LoopField " "
StringReplace state, state, %A_Space%enabled%A_Space%
return state
}
Toolbar_getStyleName( hStyle ) {
static BTNS_CHECK=2, BTNS_GROUP = 4, BTNS_DROPDOWN = 8, BTNS_AUTOSIZE = 16, BTNS_NOPREFIX = 32, BTNS_SHOWTEXT = 64
static styles="check,group,dropdown,autosize,noprefix,showtext"
loop, parse, styles, `,
if (hStyle & BTNS_%A_LoopField%)
style .= A_LoopField " "
StringReplace, style, style, check group, checkgroup		;I don't use group flag at all
return style
}
/*
After the customization dialog finishes, order and placements of buttons of the left and right side is changed.
As I keep available buttons as part of the AHK API, I must rebuild array of available buttons; add to it buttons
that are removed from the toolbar and remove buttons that are added to the toolbar.
*/
Toolbar_onEndAdjust(hCtrl, cBTN, cnt) {
static TB_COMMANDTOINDEX = 0x419, BTNS_SEP=1
a := Toolbar(hCtrl "aBTN")
aBtn := a+4, cnta := NumGet(a+0)
size := cnt+cnta,  size := size<50 ? 50 : size			;reserve memory for new aBTN array, minimum 50 buttons
buf := Toolbar_malloc( size * 20 + 4)
cnta2 := 0
loop, %cnt%
{
o := cBTN + 20*(A_Index-1),	id := NumGet(o+0, 4)
SendMessage, TB_COMMANDTOINDEX,id,,,ahk_id %hCtrl%
if Errorlevel != 4294967295							;if errorlevel = -1 button isn't on toolbar
continue
if NumGet(o+0, 9, "Char") = BTNS_SEP				;skip separators
continue
Toolbar_memcpy( buf + cnta2++*20 +4, o, 20) ;copy the button struct into new array
}
Toolbar_mfree(cBTN)
loop, %cnta%
{
o := aBTN + 20*(A_Index-1),	id := NumGet(o+0, 4)
SendMessage, TB_COMMANDTOINDEX,id,,,ahk_id %hCtrl%
if Errorlevel != 4294967295							;if errorlevel = -1 button isn't on toolbar
continue
Toolbar_memcpy(buf + cnta2++*20 +4, o, 20) ;copy the button struct into new array
}
Toolbar_mfree(aBTN)
NumPut(cnta2, buf+0)		;save array
Toolbar( hCtrl "aBTN", buf)
}
Toolbar_malloc(pSize){
static MEM_COMMIT=0x1000, PAGE_READWRITE=0x04
return DllCall("VirtualAlloc", "uint", 0, "uint", pSize, "uint", MEM_COMMIT, "uint", PAGE_READWRITE)
}
Toolbar_mfree(pAdr) {
static MEM_RELEASE = 0x8000
return DllCall("VirtualFree", "uint", pAdr, "uint", 0, "uint", MEM_RELEASE)
}
Toolbar_memmove(dst, src, cnt) {
return DllCall("MSVCRT\memmove", "uint", dst, "uint", src, "uint", cnt)
}
Toolbar_memcpy(dst, src, cnt) {
return DllCall("MSVCRT\memcpy", "UInt", dst, "UInt", src, "uint", cnt)
}
Toolbar_add2Form(hParent, Txt, Opt) {
static f := "Form_Parse"
%f%(Opt, "x# y# w# h# style IL* g*", x,y,w,h,style,il,handler)
pos := (x!="" ? " x" x : "") (y!="" ? " y" y : "") (w!="" ? " w" w : "") (h!="" ? " h" h : "")
h := Toolbar_Add(hParent, handler, style, il, pos)
if Txt !=
Toolbar_Insert(h, Txt)
return h
}
Toolbar(var="", value="~`a", ByRef o1="", ByRef o2="", ByRef o3="", ByRef o4="", ByRef o5="", ByRef o6="") {
static
if (var = "" ){
if ( _ := InStr(value, ")") )
__ := SubStr(value, 1, _-1), value := SubStr(value, _+1)
loop, parse, value, %A_Space%
_ := %__%%A_LoopField%,  o%A_Index% := _ != "" ? _ : %A_LoopField%
return
} else _ := %var%
ifNotEqual, value, ~`a, SetEnv, %var%, %value%
return _
}
/*
Group: Examples
(start code)
Gui, +LastFound
hGui := WinExist()
Gui, Show , w500 h100 Hide                              ;set gui width & height prior to adding toolbar (mandatory)
hCtrl := Toolbar_Add(hGui, "OnToolbar", "FLAT TOOLTIPS", "1L")    ;add the toolbar
btns =
(LTrim
new,  7,            ,dropdown showtext
open, 8
save, 9, disabled
-
undo, 4,            ,dropdown
redo, 5,            ,dropdown
-----
state, 11, checked  ,check
)
Toolbar_Insert(hCtrl, btns)
Toolbar_SetButtonWidth(hCtrl, 50)                   ;set button width & height to 50 pixels
Gui, Show
return
OnToolbar(hCtrl, Event, Txt, Pos){
tooltip %Event% %Txt% (%Pos%), 0, 0
}
(end code)
*/
/*
Group: About
o Ver 2.5 by majkinetor. See http://www.autohotkey.com/forum/topic27382.html
o Parts of code in Toolbar_onNotify by jballi.
o Toolbar Reference at MSDN: <http://msdn2.microsoft.com/en-us/library/bb760435(VS.85).aspx>
o Licensed under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>
*/
