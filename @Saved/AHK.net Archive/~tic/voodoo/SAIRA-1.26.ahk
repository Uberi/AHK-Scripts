#NoTrayIcon
#SingleInstance, Ignore
;SetBatchLines, -1
CoordMode, Mouse, Screen
Thread, interrupt, 0

;#Include, Gdip.ahk

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

AppName = SAIRA
VersionNum = 1.26

SysGet, MonitorPrimary, MonitorPrimary
Sysget, WA, MonitorWorkArea, %MonitorPrimary%
WaWidth := WARight-WALeft, WAHeight := WABottom-WATop

Font = Arial
Format = jpg|bmp|tiff|png

Menu, Context, Add, Open, MenuOpen
Menu, Context, Add, Remove, Remove
Menu, Context, Add, Clear, Remove

Gui, 1: +LastFound +OwnDialogs +Resize
hwnd1 := WinExist()

Menu, FileMenu, Add, &Add File(s), MenuFileAdd
Menu, FileMenu, Add, &Add Folder, MenuFolderAdd
Menu, FileMenu, Add, E&xit, Exit

Menu, EditMenu, Add, &Open, MenuOpen
Menu, EditMenu, Add, &Remove Selected, MenuRemove
Menu, EditMenu, Add, &Clear all, MenuClear

Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Edit, :EditMenu
Gui, 1: Menu, MyMenuBar

Gui, 1: Add, Listview, x0 y0 h0 w0 Grid vListview gListView Altsubmit, File|Size (kB)|DPI|Original Size|Converted Size
;LV_ModifyCol(1, 300)
LV_ModifyCol(2, "60 Integer Center")
LV_ModifyCol(3, "60 Integer Center")
LV_ModifyCol(4, 145)
LV_ModifyCol(5, 145)

Gui, 1: Add, GroupBox, x0 y0 w300 h135 vGroupBox1, Resize
Gui, 1: Add, Text, x0 y0 w60 r1 -Multi -Wrap vText1, Resize by:
Gui, 1: Add, Radio, x0 y0 w80 Checked Group vResizeMethodPercent gChangeResizeMethod r1 -Multi -Wrap, Percent
Gui, 1: Add, Radio, x0 y0 w80 vResizeMethodDimension gChangeResizeMethod r1 -Multi -Wrap, Dimension

Gui, 1: Add, Text, x0 y0 w60 vText2, Resize to:

Gui, 1: Add, Edit, x0 y0 w100 vResize gResize r1 -Multi -Wrap, 100
Gui, 1: Add, Text, x0 y0 w10 vControl1 r1 -Multi -Wrap, `%

Gui, 1: Add, Text, x0 y0 w40 r1 -Multi -Wrap vControl2, Width:
Gui, 1: Add, Edit, x0 y0 w60 vResizeWidth gResizeDimension r1 -Multi -Wrap
Gui, 1: Add, Text, x0 y0 w40 r1 -Multi -Wrap vControl3, Height:
Gui, 1: Add, Edit, x0 y0 w60 vResizeHeight gResizeDimension r1 -Multi -Wrap

Gui, 1: Font, cGray
Gui, 1: Add, Text, x0 y0 w280 vResizeExplanation r4
Gui, 1: Font

GoSub, ChangeResizeMethod

Gui, 1: Add, GroupBox, x0 y0 w270 h135 vGroupBox2, Convert
Gui, 1: Add, Checkbox, x0 y0 w110 vConvert gConvert, Convert format
Loop, Parse, Format, |
	Gui, 1: Add, Radio, % "x0 y0 w50 Disabled v" A_LoopField ((A_Index = 1) ? " Checked Group" : ""), %A_LoopField%

Gui, 1: Font, cGray
Gui, 1: Add, Text, x0 y0 w250 vConvertExplanation r3, If checked then all the images will be converted to the chosen file type
Gui, 1: Font

Gui, 1: Add, Picture, x0 y0 w155 h135 0xE vPreview

Gui, 1: Add, Text, x0 y0 w60 vText3 r1 -Multi -Wrap, Output:
Gui, 1: Add, Edit, x0 y0 w505 vOutFolder r1 -Multi -Wrap, %A_WorkingDir%\Resize
Gui, 1: Add, Button, x0 y0 w75 gBrowse vBrowse r1 -Multi -Wrap, &Browse
Gui, 1: Add, Button, x0 y0 w75 gGo vGo r1 -Multi -Wrap, &Go

Gui, 1: Add, Picture, x0 y0 w745 h20 0xE vProgress

Gui, 1: Add, Button, Hidden Default gListViewEnter, ListViewEnter

Gui, 1: Show, w765 h500, %AppName% - v%VersionNum% by Tariq Porter
GoSub, ClearProgress
Gui, 1: +MinSize

GuiControlGet, Pos, Pos, Preview
GuiControlGet, hwnd, hwnd, Preview
	
pBitmapPreview := Gdip_CreateBitmap(Posw, Posh), GPreview := Gdip_GraphicsFromImage(pBitmapPreview)
Gdip_SetInterpolationMode(GPreview, 7)
return

;##############################################################################################

GuiSize:
GuiControl, -Redraw, ListView
NewWidth := A_GuiWidth
NewHeight := A_GuiHeight
y := 10
x := 10
; GuiControl, MoveDraw, ListView, % "x" x " y" y " w" A_GuiWidth-20 " h" A_GuiHeight-230			;%
; LV_ModifyCol(1, A_GuiWidth-450)
y += A_GuiHeight-220
ygroup := y
GuiControl, Move, GroupBox1, % "x" x " y" ygroup			;%
y += 20
x += 10
GuiControl, Move, Text1, % "x" x " y" y			;%
x += 90
GuiControl, Move, ResizeMethodPercent, % "x" x " y" y			;%
x += 90
GuiControl, Move, ResizeMethodDimension, % "x" x " y" y			;%
y += 25
x := 20
GuiControl, Move, Text2, % "x" x " y" y			;%
x += 70
GuiControl, Move, Resize, % "x" x " y" y			;%
x += 110
GuiControl, Move, Control1, % "x" x " y" y			;%
x -= 110
GuiControl, Move, Control2, % "x" x " y" y			;%
x += 40
GuiControl, Move, ResizeWidth, % "x" x " y" y			;%
x += 70
GuiControl, Move, Control3, % "x" x " y" y			;%
x += 40
GuiControl, Move, ResizeHeight, % "x" x " y" y			;%
x := 20
y += 30
GuiControl, Move, ResizeExplanation, % "x" x " y" y			;%
x := 325
y := ygroup
GuiControl, Move, GroupBox2, % "x" x " y" ygroup			;%
x += 10
y += 20
GuiControl, Move, Convert, % "x" x " y" y			;%
x += 110

Loop, Parse, Format, |
{
	GuiControl, Move, %A_LoopField%, % "x" x " y" y			;%
	if (A_Index = 1 || A_Index = 3)
		x += 50
	else if (A_Index = 2)
		x -= 50, y += 20
}

x := 340
y += 35
GuiControl, Move, ConvertExplanation, % "x" x " y" y			;%

x += 260
y := ygroup
GuiControl, Move, Preview, % "x" x " y" y		;%

x := 10
y := A_GuiHeight-60
GuiControl, Move, Text3, % "x" x " y" y			;%
x += 70
GuiControl, Move, OutFolder, % "x" x " y" y " w" A_GuiWidth-250			;%
x += A_GuiWidth-245
GuiControl, Move, Browse, % "x" x " y" y		;%
x += 80
GuiControl, Move, Go, % "x" x " y" y		;%

GuiControl, Move, ListView, % "x" 10 " y" 10 " w" A_GuiWidth-20 " h" A_GuiHeight-230			;%
LV_ModifyCol(1, A_GuiWidth-455)

GuiControl, Move, Progress, % "x" 10 " y" A_GuiHeight-30 " w" A_GuiWidth-20		;%
;GoSub, ClearProgress

GuiControl, +Redraw, ListView
WinSet, Redraw,, ahk_id %hwnd1%
return

;##############################################################################################

MenuFileAdd:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
FileSelectFile, File, M,, Select image(s) to add, Image files (*.bmp; *.dib; *.rle; *.jpg; *.jpeg; *.jpe; *.jfif; *.gif; *.tif; *.tiff; *.png)
if !File
	return
StringSplit, File, File, `n
Resize := Resize/100
Loop, % File0-1		;%
{
	NextIndex := A_Index+1
	AddFile(File1 "\" File%NextIndex%)
}
return

;##############################################################################################

MenuFolderAdd:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
FileSelectFolder, Folder,,, Select a folder to add
If !Folder
	return
	Resize := Resize/100
Loop, %Folder%\*.*
{
	SplitPath, A_LoopFileFullPath,,, ext
	If ext in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		AddFile(A_LoopFileFullPath)
}
return

;##############################################################################################

MenuClear:
LV_Delete()

GuiControlGet, hwnd, hwnd, Preview
SetSysColorToControl(hwnd)
return

;##############################################################################################

MenuRemove:
Loop, % LV_GetCount()			;%
	Row := LV_GetNext(Row), LV_Delete(Row)
	
GuiControlGet, hwnd, hwnd, Preview
SetSysColorToControl(hwnd)
return

;##############################################################################################

MenuOpen:
LV_GetText(FileName, LV_GetNext(Row), 1)
if FileExist(FileName)
	Run, %FileName%
return

;##############################################################################################

Gdip_SetProgress(ByRef Variable, Percentage, Foreground, Background=0x00000000, Text="", TextOptions="x0p y15p s60p Center cff000000 r4 Bold", Font="Arial")
{
	ListLines Off
	;Gui, 1: +OwnDialogs
	GuiControlGet, Pos, Pos, Variable
	GuiControlGet, hwnd, hwnd, Variable

	pBrushFront := Gdip_BrushCreateSolid(Foreground), pBrushBack := Gdip_BrushCreateSolid(Background)
	pBitmap := Gdip_CreateBitmap(Posw, Posh), G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_FillRectangle(G, pBrushBack, 0, 0, Posw, Posh), Gdip_FillRectangle(G, pBrushFront, 4, 4, (Posw*(Percentage/100))-8, Posh-8)
	
	Gdip_TextToGraphics(G, (Text != "") ? Text : Round(Percentage) "`%", TextOptions, Font, Posw, Posh)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(hwnd, hBitmap)
	
	Gdip_DeleteBrush(pBrushFront), Gdip_DeleteBrush(pBrushBack)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	ListLines On
	return 0
}

;##############################################################################################

GetNewDimensions(Width, Height, ResizeWidth="", ResizeHeight="", ByRef OutputWidth="", ByRef OutputHeight="")
{
	if !(ResizeWidth || ResizeHeight)
	{
		OutputWidth := Width
		OutputHeight := Height
	}
	else if (ResizeWidth && !ResizeHeight)
	{
		if (Width <= ResizeWidth)
		{
			OutputWidth := Width
			OutputHeight := Height
		}
		else
		{
			OutputWidth := ResizeWidth
			OutputHeight := Round((OutputWidth/Width)*Height)
		}
	}
	else if (ResizeHeight && !ResizeWidth)
	{
		if (Height <= ResizeHeight)
		{
			OutputWidth := Width
			OutputHeight := Height
		}
		else
		{
			OutputHeight := ResizeHeight
			OutputWidth := Round((OutputHeight/Height)*Width)
		}
	}
	else
	{
		if (Width <= ResizeWidth) && (Height <= ResizeHeight)
		{
			OutputWidth := Width
			OutputHeight := Height
		}
		else if (Width <= ResizeWidth)
		{
			; Height is greater than specified
			OutputHeight := ResizeHeight
			OutputWidth := Round((OutputHeight/Height)*Width)
		}
		else if (Height <= ResizeHeight)
		{
			; Width is greater than specified
			OutputWidth := ResizeWidth
			OutputHeight := Round((OutputWidth/Width)*Height)
		}
		else
		{
			; Width and height are greater than specified
			if (Width/ResizeWidth <= Height/ResizeHeight)
			{
				OutputHeight := ResizeHeight
				OutputWidth := Round((OutputHeight/Height)*Width)
			}
			else
			{
				OutputWidth := ResizeWidth
				OutputHeight := Round((OutputWidth/Width)*Height)
			}
		}
	}
}

;##############################################################################################

ChangeResizeMethod:
Gui, 1: Submit, NoHide
if ResizeMethodPercent
{
	GuiControl, Hide, Control2
	GuiControl, Hide, ResizeWidth
	GuiControl, Hide, Control3
	GuiControl, Hide, ResizeHeight
	
	GuiControl, Show, Resize
	GuiControl, Show, Control1
	
	GuiControl, Text, ResizeExplanation, Will resize all the images to the specified percentage of their original size
	GoSub, Resize
}
else
{
	GuiControl, Hide, Resize
	GuiControl, Hide, Control1
	
	GuiControl, Show, Control2
	GuiControl, Show, ResizeWidth
	GuiControl, Show, Control3
	GuiControl, Show, ResizeHeight
	
	GuiControl, Text, ResizeExplanation, Will resize images to the specified dimensions unless the image is smaller. Width and/or Height can be used. Aspect ratio will always be maintained
	GoSub, ResizeDimension
}
return

;##############################################################################################

ListViewEnter:
Gui, 1: Default

GuiControlGet, FocusedControl, FocusV
if (FocusedControl != "ListView")
    return

LV_GetText(FileName, LV_GetNext(0, "Focused"), 1)
if FileExist(FileName)
	Run, %FileName%
return

;##############################################################################################

ListView:
Gui, 1: Default
if (A_GuiEvent = "RightClick")
	Menu, Context, Show
else if (A_GuiEvent = "I" && InStr(ErrorLevel, "S", 1))
{
	SetTimer, ChangePreview, -50
	ThisRow := A_EventInfo
}
else if (A_GuiEvent = "DoubleClick")
{
	LV_GetText(FileName, A_EventInfo, 1)
	if FileExist(FileName)
		Run, %FileName%
}
return

;##############################################################################################

ChangePreview:
Gui, 1: Default
LV_GetText(FileName, ThisRow, 1)
LoadPreview(Preview, FileName)
return

;##############################################################################################

LoadPreview(ByRef Variable, File)
{
	global pBitmapPreview, GPreview

	GuiControlGet, Pos, Pos, Variable
	GuiControlGet, hwnd, hwnd, Variable
	
	If !pBitmap := Gdip_CreateBitmapFromFile(File)
		return
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	
	if (Posw/Width >= Posh/Height)
		NewHeight := Posh, NewWidth := Round(Width*(NewHeight/Height))
	else
		NewWidth := Posw, NewHeight := Round(Height*(NewWidth/Width))
	
	Gdip_GraphicsClear(GPreview)
	Gdip_DrawImage(GPreview, pBitmap, (Posw-NewWidth)//2, (Posh-NewHeight)//2, NewWidth, NewHeight, 0, 0, Width, Height)
	
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmapPreview)
	SetImage(hwnd, hBitmap)

	DeleteObject(hBitmap)
	Gdip_DisposeImage(pBitmap)
}

;##############################################################################################

IsWIndowVisible(hwnd)
{
	return, DllCall("IsWindowVisible", "UInt", hwnd)
}

;##############################################################################################

Remove:
If (A_ThisMenuItem = "Clear")
	LV_Delete()
else If (A_ThisMenuItem = "Remove")
{
	Loop, % LV_GetCount()			;%
		Row := LV_GetNext(Row), LV_Delete(Row)
}

GuiControlGet, hwnd, hwnd, Preview
SetSysColorToControl(hwnd)
return

;##############################################################################################

Convert:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
Loop, Parse, Format, |
	GuiControl, % Convert ? "Enable" : "Disable", %A_LoopField%
return

;##############################################################################################

Resize:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
Resize := Resize/100
Loop, % LV_GetCount()		;%
{
	LV_GetText(Resolution, A_Index, 4)
	Pos := RegExMatch(Resolution, "(\d+) x (\d+) / (\d+) x (\d+) cm", Resolution)
	if Resize
		LV_Modify(A_Index, "Col5", Round(Resolution1*Resize) " x " Round(Resolution2*Resize) " / " Round(Resolution3*Resize) " x " Round(Resolution4*Resize) " cm")
	else
		LV_Modify(A_Index, "Col5", Resolution1 " x " Resolution2 " / " Resolution3 " x " Resolution4 " cm")
}
return

;##############################################################################################

ResizeDimension:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
ResizeWidth := ResizeWidth*1
ResizeHeight := ResizeHeight*1
Loop, % LV_GetCount()		;%
{
	LV_GetText(Resolution, A_Index, 4)
	Pos := RegExMatch(Resolution, "(\d+) x (\d+) / (\d+) x (\d+) cm", Resolution)

	GetNewDimensions(Resolution1, Resolution2, ResizeWidth, ResizeHeight, OutputWidth, OutputHeight)
	LV_Modify(A_Index, "Col5", OutputWidth " x " OutputHeight " / " Round((OutputWidth/Resolution1)*Resolution3) " x " Round((OutputHeight/Resolution2)*Resolution4) " cm")
}
return

;##############################################################################################

Go:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide

if (OutFolder = "ERROR")
{
	ListLines
	return
}

Started := !Started

ChosenFormat := ""
Loop, Parse, Format, |
{
	If !Convert || ChosenFormat
		break
	ChosenFormat := %A_LoopField% ? A_LoopField : ""
}

If !Rows := LV_GetCount()
	return

If !FileExist(OutFolder)
	FileCreateDir, %OutFolder%

if ResizeMethodPercent
{
	if !Resize
		return
	Resize := Resize/100
}
else if !(ResizeWidth || ResizeHeight)
	return

if Started
{
	GuiControl,, Go, &Stop
	SetTimer, GoStop, -1
}
else
	GuiControl,, Go, &Go
return

;##############################################################################################

GoStop:
;Critical, Off

Gdip_SetProgress(Progress, 0, 0xff0993ea, 0xffbde5ff)
Loop, %Rows%
{
	if !Started
	{
		GuiControl,, Go, &Go
		;Tooltip, here2:%Started%
		Gdip_SetProgress(Progress, "", 0xff0993ea, 0xffbde5ff, "Cancelled!")
		SetTimer, ClearProgress, -3000
		return
	}
	
	LV_GetText(File, A_Index, 1)
	If !pBitmap := Gdip_CreateBitmapFromFile(File)
		Continue
	
	G := Gdip_GraphicsFromImage(pBitmap)
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	SplitPath, File,,, Extension, FileName
	ThisFormat := ChosenFormat ? ChosenFormat : Extension
	
	if ResizeMethodPercent
	{
		If (Resize != 1)
		{
			pBitmapNew := Gdip_CreateBitmap(Round(Width*Resize), Round(Height*Resize)), GNew := Gdip_GraphicsFromImage(pBitmapNew)
			Gdip_SetInterpolationMode(GNew, 7)
			
			Gdip_DrawImage(GNew, pBitmap, 0, 0, Round(Width*Resize), Round(Height*Resize), 0, 0, Width, Height)

			E := Gdip_SaveBitmapToFile(pBitmapNew, OutFolder "\" FileName "." ThisFormat)
			Gdip_DeleteGraphics(GNew), Gdip_DisposeImage(pBitmapNew)
		}
		else
		{
			E := Gdip_SaveBitmapToFile(pBitmap, OutFolder "\" FileName "." ThisFormat)
			
			; When converting some tifs to jpg
			if (E = -5)
			{
				pBitmapNew := Gdip_CreateBitmap(Width, Height), GNew := Gdip_GraphicsFromImage(pBitmapNew)
				Gdip_DrawImage(GNew, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height)
				Gdip_SaveBitmapToFile(pBitmapNew, OutFolder "\" FileName "." ThisFormat)
				Gdip_DeleteGraphics(GNew), Gdip_DisposeImage(pBitmapNew)
			}
		}
	}
	else
	{
		GetNewDimensions(Width, Height, ResizeWidth, ResizeHeight, OutputWidth, OutputHeight)
			
		pBitmapNew := Gdip_CreateBitmap(OutputWidth, OutputHeight), GNew := Gdip_GraphicsFromImage(pBitmapNew)
		Gdip_SetInterpolationMode(GNew, 7)
		
		Gdip_DrawImage(GNew, pBitmap, 0, 0, OutputWidth, OutputHeight, 0, 0, Width, Height)
		Gdip_SaveBitmapToFile(pBitmapNew, OutFolder "\" FileName "." ThisFormat)
		
		Gdip_DeleteGraphics(GNew), Gdip_DisposeImage(pBitmapNew)
	}
	
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
	Gdip_SetProgress(Progress, Round(A_Index*(100/Rows)), 0xff0993ea, 0xffbde5ff)
}
Gdip_SetProgress(Progress, "", 0xff0993ea, 0xffbde5ff, "Done!")
SetTimer, ClearProgress, -3000
return

;##############################################################################################

ClearProgress:
Started := 0
GuiControl,, Go, &Go
Gdip_SetProgress(Progress, 0, 0xff0993ea, 0xffbde5ff, " ")
return

;##############################################################################################

AddFile(Path)
{
	Global
	
	If !pBitmap := Gdip_CreateBitmapFromFile(Path)
		return
	FileGetSize, Size, %Path%
	Size := Ceil(Size/1024)
	
	G := Gdip_GraphicsFromImage(pBitmap)
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	DpiX := Gdip_GetImageHorizontalResolution(pBitmap), DpiY := Gdip_GetImageVerticalResolution(pBitmap)
	
	if ResizeMethodPercent
	{
		LV_Add("", Path, Size, DpiX, Width " x " Height " / " Round(2.54*(Width/DpiX)) " x " Round(2.54*(Height/DpiY)) " cm"
		, Round(Resize*Width) " x " Round(Resize*Height) " / " Round(Resize*2.54*(Width/DpiX)) " x " Round(Resize*2.54*(Height/DpiY))  " cm")
	}
	else
	{
		GetNewDimensions(Width, Height, ResizeWidth, ResizeHeight, OutputWidth, OutputHeight)
		
		LV_Add("", Path, Size, DpiX, Width " x " Height " / " Round(2.54*(Width/DpiX)) " x " Round(2.54*(Height/DpiY)) " cm"
		, OutputWidth " x " OutputHeight " / " Round((OutputWidth/Width)*2.54*(Width/DpiX)) " x " Round((OutputHeight/Height)*2.54*(Height/DpiY))  " cm")
	}
	
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
}

;##############################################################################################

GuiDropFiles:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
Resize := Resize/100
Loop, Parse, A_GuiEvent, `n
{
	SplitPath, A_LoopField,,, ext
	If ext in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		AddFile(A_LoopField)
}
return

;##############################################################################################

Browse:
Gui, 1: Default
Gui, 1: +OwnDialogs
Gui, 1: Submit, NoHide
FileSelectFolder, Folder,,, Select the output folder to save the images
If !Folder
	return
GuiControl,, OutFolder, %Folder%
return

;##############################################################################################

Esc::
GuiClose:
Exit:
Gdip_Shutdown(pToken)
ExitApp
return