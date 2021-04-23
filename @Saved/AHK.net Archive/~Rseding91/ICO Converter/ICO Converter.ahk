#NoEnv
SetBatchLines,-1
Ptr := A_PtrSize ? "Ptr" : "UInt"

FileSelectFile, Files, M, %A_ScriptDir%, Select the image(s), *.PNG

If (Files = "")
	ExitApp

Loop, Parse, Files, `n
{
	If (A_Index = 1)
		Directory := A_LoopField
	Else
		All_Files .= Directory . "\" A_LoopField "`r`n"
}

Generate_Icon(All_Files, A_ScriptDir "\new icon.ico")

Generate_Icon(_Files, _OutputName, _Sizes = "")
{
	Static ICO_BaseSize = 6
	, ICO_ContainerSize = 16
	
	pToken := Gdip_Startup()
	, O := 0
	, Total_PotentialSize := ICO_BaseSize
	
	If (!InStr(_Files,"`r") And !InStr(_Files, "`n"))
		_Files .= "`r`n"
	
	Loop, Parse, _Files, `r, `n
	{
		Size := ELP_FileGetSize(A_LoopField)
		If (Size)
			Total_PotentialSize += ICO_ContainerSize + Size
	}
	
	VarSetCapacity(ICO_Data, Total_PotentialSize, 0)
	, O := 0
	, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;reserved - always 0
	, NumPut(1, ICO_Data, O, "UShort"), O += 2 ;ico = 1, cur = 2
	, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;number of images in file
	
	Loop, Parse, _Files, `r, `n
	{
		If (A_LoopField = "")
			Continue
		
		pBitmap := Gdip_CreateBitmapFromFile(A_LoopField)
		, Gdip_GetImageDimensions(pBitmap, Image_Width, Image_Height)
		, Gdip_DisposeImage(pBitmap)
		
		If (Image_Width <= 256 And Image_Height <= 256){
			H := ELP_OpenFileHandle(A_LoopField, "Read", Image_Size)
			
			If (Image_Size){
				ELP_ReadData(H, &ICO_Data + O + ICO_ContainerSize, Image_Size)
				, ELP_CloseFileHandle(H)
				
				, NumPut(Image_Width, ICO_Data, O, "UChar"), O += 1 ;image width: 256 = 0
				, NumPut(Image_Height, ICO_Data, O, "UChar"), O += 1 ;image height: 256 = 0
				, NumPut(0, ICO_Data, O, "UChar"), O += 1 ;color palatte: 0 if not used
				, NumPut(0, ICO_Data, O, "UChar"), O += 1 ;reserved - always 0
				, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;ico - color planes (0/1), cur - horizontal coordinates of the hotspot in pixels from left
				, NumPut(32, ICO_Data, O, "UShort"), O += 2 ;ico - bits per pixel, cur - vertical coordinates of hotspot in pixels from top
				, NumPut(Image_Size, ICO_Data, O, "UInt"), O += 4 ;Size of image data in bytes
				, NumPut(O + 4, ICO_Data, O, "UInt"), O += 4 ;Offset of image data from begining of ico/cur file
				, O += Image_Size
				
				, NumPut(NumGet(ICO_Data, 4, "UShort") + 1, ICO_Data, 4, "UShort") ;Adds one to the total number of images
			} Else
				ELP_CloseFileHandle(H)
		}
	}
	
	If (O > 6){
		FileDelete, % _OutputName
		H := ELP_OpenFileHandle(_OutputName, "Write")
		, ELP_WriteData(H, &ICO_Data, O)
		, ELP_CloseFileHandle(H)
		
		, VarSetCapacity(ICO_Data, O, 0)
		, VarSetCapacity(ICO_Data, 0)
	}
	
	Gdip_Shutdown(pToken)
}

Exitapp




; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
;
;#####################################################################################
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
;
; Ok =						= 0
; GenericError				= 1
; InvalidParameter			= 2
; OutOfMemory				= 3
; ObjectBusy				= 4
; InsufficientBuffer		= 5
; NotImplemented			= 6
; Win32Error				= 7
; WrongState				= 8
; Aborted					= 9
; FileNotFound				= 10
; ValueOverflow				= 11
; AccessDenied				= 12
; UnknownImageFormat		= 13
; FontFamilyNotFound		= 14
; FontStyleNotFound			= 15
; NotTrueTypeFont			= 16
; UnsupportedGdiplusVersion	= 17
; GdiplusNotInitialized		= 18
; PropertyNotFound			= 19
; PropertyNotSupported		= 20
; ProfileNotFound			= 21
;
;#####################################################################################
;#####################################################################################
; FUNCTIONS
;#####################################################################################
;
; UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
; BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
; StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster="")
; SetImage(hwnd, hBitmap)
; Gdip_BitmapFromScreen(Screen=0, Raster="")
; CreateRectF(ByRef RectF, x, y, w, h)
; CreateSizeF(ByRef SizeF, w, h)
; CreateDIBSection
;
;#####################################################################################

; Function:     			UpdateLayeredWindow
; Description:  			Updates a layered window with the handle to the DC of a gdi bitmap
; 
; hwnd        				Handle of the layered window to update
; hdc           			Handle to the DC of the GDI bitmap to update the window with
; Layeredx      			x position to place the window
; Layeredy      			y position to place the window
; Layeredw      			Width of the window
; Layeredh      			Height of the window
; Alpha         			Default = 255 : The transparency (0-255) to set the window transparency
;
; return      				If the function succeeds, the return value is nonzero
;
; notes						If x or y omitted, then layered window will use its current coordinates
;							If w or h omitted then current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)

	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
   
	return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
	, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}

;#####################################################################################

; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle 
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				StretchBlt
; Description			The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle, 
;						stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;						The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination rectangle
; dh					height of destination rectangle
; sdc					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt		

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
	return DllCall("gdi32\StretchBlt", "uint", ddc, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				SetStretchBltMode
; Description			The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc					handle to the DC
; iStretchMode			The stretching mode, describing how the target will be stretched
;
; return				If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; STRETCH_ANDSCANS 		= 0x01
; STRETCH_ORSCANS 		= 0x02
; STRETCH_DELETESCANS 	= 0x03
; STRETCH_HALFTONE 		= 0x04

SetStretchBltMode(hdc, iStretchMode=4)
{
	return DllCall("gdi32\SetStretchBltMode", "uint", hdc, "int", iStretchMode)
}

;#####################################################################################

; Function				SetImage
; Description			Associates a new image with a static control
;
; hwnd					handle of the control to update
; hBitmap				a gdi bitmap to associate the static control with
;
; return				If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}

;#####################################################################################

; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				If the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor=15)
{
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor)
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}

;#####################################################################################

; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}

	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_BitmapFromHWND
; Description			Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd					handle to the window to get a bitmap from
;
; return				If the function succeeds, the return value is a pointer to a gdi+ bitmap
;
; notes					Window must not be not minimised in order to get a handle to it's client area

Gdip_BitmapFromHWND(hwnd)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}

;#####################################################################################

; Function    			CreateRectF
; Description			Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}

;#####################################################################################

; Function    			CreateRect
; Description			Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
;#####################################################################################

; Function		    	CreateSizeF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")     
}
;#####################################################################################

; Function		    	CreatePointF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")     
}
;#####################################################################################

; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
	hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}

;#####################################################################################

; Function				PrintWindow
; Description			The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd					A handle to the window that will be copied
; hdc					A handle to the device context
; Flags					Drawing options
;
; return				If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY			= 1

PrintWindow(hwnd, hdc, Flags=0)
{
	return DllCall("PrintWindow", "uint", hwnd, "uint", hdc, "uint", Flags)
}

;#####################################################################################

; Function				DestroyIcon
; Description			Destroys an icon and frees any memory the icon occupied
;
; hIcon					Handle to the icon to be destroyed. The icon must not be in use
;
; return				If the function succeeds, the return value is nonzero

DestroyIcon(hIcon)
{
   return DllCall("DestroyIcon", "uint", hIcon)
}

;#####################################################################################

PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", "uint", hdc)
}

;#####################################################################################

CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", "uint", hdc, "int", w, "int", h)
}

;#####################################################################################

; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context					
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", "uint", hdc)
}

;#####################################################################################

; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
   return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}

;#####################################################################################

; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
   return DllCall("DeleteObject", "uint", hObject)
}

;#####################################################################################

; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd=0)
{
	return DllCall("GetDC", "uint", hwnd)
}

;#####################################################################################

; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags=0, hrgnClip=0)
{
    return DllCall("GetDCEx", "uint", hwnd, "uint", hrgnClip, "int", flags)
}

;#####################################################################################

; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

ReleaseDC(hdc, hwnd=0)
{
   return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}

;#####################################################################################

; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
   return DllCall("DeleteDC", "uint", hdc)
}
;#####################################################################################

; Function				Gdip_LibraryVersion
; Description			Get the current library version
;
; return				the library version
;
; notes					This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion()
{
	return 1.45
}

;#####################################################################################

; Function:    			Gdip_BitmapFromBRA
; Description: 			Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn			The variable for a BRA file read to memory
; File					The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate				Changes whether the File parameter is the file name or its number
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1 = The BRA variable is empty
;						-2 = The BRA has an incorrect header
;						-3 = The BRA has information missing
;						-4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4

	hData := DllCall("GlobalAlloc", "uint", 2, "uint", FileInfo2)
	pData := DllCall("GlobalLock", "uint", hData)
	DllCall("RtlMoveMemory", "uint", pData, "uint", &BRAFromMemIn+Info2+FileInfo1, "uint", FileInfo2)
	DllCall("GlobalUnlock", "uint", hData)
	DllCall("ole32\CreateStreamOnHGlobal", "uint", hData, "int", 1, "uint*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", "uint", pStream, "uint*", pBitmap)
	DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_DrawRectangle
; Description			This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawRoundedRectangle
; Description			This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}

;#####################################################################################

; Function				Gdip_DrawEllipse
; Description			This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle the ellipse will be drawn into
; y						y-coordinate of the top left of the rectangle the ellipse will be drawn into
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawEllipse", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawBezier
; Description			This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the bezier
; y1					y-coordinate of the start of the bezier
; x2					x-coordinate of the first arc of the bezier
; y2					y-coordinate of the first arc of the bezier
; x3					x-coordinate of the second arc of the bezier
; y3					y-coordinate of the second arc of the bezier
; x4					x-coordinate of the end of the bezier
; y4					y-coordinate of the end of the bezier
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
   return DllCall("gdiplus\GdipDrawBezier", "uint", pgraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2
   , "float", x3, "float", y3, "float", x4, "float", y4)
}

;#####################################################################################

; Function				Gdip_DrawArc
; Description			This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the arc
; y						y-coordinate of the start of the arc
; w						width of the arc
; h						height of the arc
; StartAngle			specifies the angle between the x-axis and the starting point of the arc
; SweepAngle			specifies the angle between the starting and ending points of the arc
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawArc", "uint", pGraphics, "uint", pPen, "float", x
   , "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawPie
; Description			This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the pie
; y						y-coordinate of the start of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawPie", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawLine
; Description			This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the line
; y1					y-coordinate of the start of the line
; x2					x-coordinate of the end of the line
; y2					y-coordinate of the end of the line
;
; return				status enumeration. 0 = success		

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
   return DllCall("gdiplus\GdipDrawLine", "uint", pGraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2)
}

;#####################################################################################

; Function				Gdip_DrawLines
; Description			This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success				

Gdip_DrawLines(pGraphics, pPen, Points)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipDrawLines", "uint", pGraphics, "uint", pPen, "uint", &PointF, "int", Points0)
}

;#####################################################################################

; Function				Gdip_FillRectangle
; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
   return DllCall("gdiplus\GdipFillRectangle", "uint", pGraphics, "int", pBrush
   , "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRoundedRectangle
; Description			This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}

;#####################################################################################

; Function				Gdip_FillPolygon
; Description			This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success
;
; notes					Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate 			= 0
; Winding 				= 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }   
   return DllCall("gdiplus\GdipFillPolygon", "uint", pGraphics, "uint", pBrush, "uint", &PointF, "int", Points0, "int", FillMode)
}

;#####################################################################################

; Function				Gdip_FillPie
; Description			This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the pie
; y						y-coordinate of the top left of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipFillPie", "uint", pGraphics, "uint", pBrush
   , "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_FillEllipse
; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the ellipse
; y						y-coordinate of the top left of the ellipse
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillEllipse", "uint", pGraphics, "uint", pBrush, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRegion
; Description			This function uses a brush to fill a region in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Region
;
; return				status enumeration. 0 = success
;
; notes					You can create a region Gdip_CreateRegion() and then add to this

Gdip_FillRegion(pGraphics, pBrush, Region)
{
	return DllCall("gdiplus\GdipFillRegion", "uint", pGraphics, "uint", pBrush, "uint", Region)
}

;#####################################################################################

; Function				Gdip_FillPath
; Description			This function uses a brush to fill a path in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Path
;
; return				status enumeration. 0 = success

Gdip_FillPath(pGraphics, pBrush, Path)
{
	return DllCall("gdiplus\GdipFillPath", "uint", pGraphics, "uint", pBrush, "uint", Path)
}

;#####################################################################################

; Function				Gdip_DrawImagePointsRect
; Description			This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; Points				Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}

	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
		
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	E := DllCall("gdiplus\GdipDrawImagePointsRect", "uint", pGraphics, "uint", pBitmap
	, "uint", &PointF, "int", Points0, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_DrawImage
; Description			This function draws a bitmap into the Graphics of another bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination image
; dh					height of destination image
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source image
; sh					height of source image
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Gdip_DrawImage performs faster
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter. For example:
;						MatrixBright=
;						(
;						1.5		|0		|0		|0		|0
;						0		|1.5	|0		|0		|0
;						0		|0		|1.5	|0		|0
;						0		|0		|0		|1		|0
;						0.05	|0.05	|0.05	|0		|1
;						)
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
	, "float", dx, "float", dy, "float", dw, "float", dh
	, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_SetImageAttributesColorMatrix
; Description			This function creates an image matrix ready for drawing
;
; Matrix				a matrix used to alter image attributes when drawing
;						passed with any delimeter
;
; return				returns an image matrix on sucess or 0 if it fails
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_SetImageAttributesColorMatrix(Matrix)
{
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
	return ImageAttr
}

;#####################################################################################

; Function				Gdip_GraphicsFromImage
; Description			This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap				Pointer to a bitmap to get the pointer to its graphics
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					a bitmap can be drawn into the graphics of another bitmap

Gdip_GraphicsFromImage(pBitmap)
{
    DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GraphicsFromHDC
; Description			This function gets the graphics from the handle to a device context
;
; hdc					This is the handle to the device context
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					You can draw a bitmap into the graphics of another bitmap

Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", "uint", pGraphics, "uint*", hdc)
	return hdc
}

;#####################################################################################

; Function				Gdip_ReleaseDC
; Description			This function releases a device context from use for further use
;
; pGraphics				Pointer to the graphics of a bitmap
; hdc					This is the handle to the device context
;
; return				status enumeration. 0 = success

Gdip_ReleaseDC(pGraphics, hdc)
{
	return DllCall("gdiplus\GdipReleaseDC", "uint", pGraphics, "uint", hdc)
}

;#####################################################################################

; Function				Gdip_GraphicsClear
; Description			Clears the graphics of a bitmap ready for further drawing
;
; pGraphics				Pointer to the graphics of a bitmap
; ARGB					The colour to clear the graphics to
;
; return				status enumeration. 0 = success
;
; notes					By default this will make the background invisible
;						Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", "uint", pGraphics, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_BlurBitmap
; Description			Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap				Pointer to a bitmap to be blurred
; Blur					The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return				If the function succeeds, the return value is a pointer to the new blurred bitmap
;						-1 = The blur parameter is outside the range 1-100
;
; notes					This function will not dispose of the original bitmap

Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100) || (Blur < 1)
		return -1	
	
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}

;#####################################################################################

; Function:     		Gdip_SaveBitmapToFile
; Description:  		Saves a bitmap to a file in any supported format onto disk
;   
; pBitmap				Pointer to a bitmap
; sOutput      			The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      			If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return      			If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
	if !(nCount && nSize)
		return -2
   
	Loop, %nCount%
	{
		Location := NumGet(ci, 76*(A_Index-1)+44)
		if !A_IsUnicode
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
		}
		else
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			sString := ""
			Loop, %nSize%
				sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
			if !InStr(sString, "*" Extension)
				continue
		}
		pCodec := &ci+76*(A_Index-1)
		break
	}
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
			Loop, % NumGet(EncoderParameters)      ;%
			{
				if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
				{
				   p := (28*(A_Index-1))+&EncoderParameters
				   NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
				   break
				}
			}      
	  }
	}

	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

;#####################################################################################

; Function				Gdip_GetPixel
; Description			Gets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				Returns the ARGB value of the pixel

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", "uint", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}

;#####################################################################################

; Function				Gdip_SetPixel
; Description			Sets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				status enumeration. 0 = success

Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   return DllCall("gdiplus\GdipBitmapSetPixel", "uint", pBitmap, "int", x, "int", y, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_GetImageWidth
; Description			Gives the width of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the width in pixels of the supplied bitmap

Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
   return Width
}

;#####################################################################################

; Function				Gdip_GetImageHeight
; Description			Gives the height of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the height in pixels of the supplied bitmap

Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
   return Height
}

;#####################################################################################

; Function				Gdip_GetDimensions
; Description			Gives the width and height of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
}

;#####################################################################################

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}

;#####################################################################################

Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", "uint", pBitmap, "uint*", Format)
	return Format
}

;#####################################################################################

; Function				Gdip_GetDpiX
; Description			Gives the horizontal dots per inch of the graphics of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", "uint", pGraphics, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
	return DllCall("gdiplus\GdipBitmapSetResolution", "uint", pBitmap, "float", dpix, "float", dpiy)
}

;#####################################################################################

Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		VarSetCapacity(buf, 40)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, "uint*", hIcon, "uint*", 0, "uint", 1, "uint", 0)
			if !hIcon
				continue

			if !DllCall("GetIconInfo", "uint", hIcon, "uint", &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			hbmColor := NumGet(buf, 16)
			hbmMask  := NumGet(buf, 12)

			if !(hbmColor && DllCall("GetObject", "uint", hbmColor, "int", 24, "uint", &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"),  Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)

		if !DllCall("DrawIconEx", "uint", hdc, "int", 0, "int", 0, "uint", hIcon, "uint", Width, "uint", Height, "uint", 0, "uint", 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}

		VarSetCapacity(dib, 84)
		DllCall("GetObject", "uint", hbm, "int", 84, "uint", &dib)
		Stride := NumGet(dib, 12), Bits := NumGet(dib, 20)

		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "uint", Bits, "uint*", pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if !A_IsUnicode
		{
			VarSetCapacity(wFile, 1023)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sFile, "int", -1, "uint", &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &wFile, "uint*", pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &sFile, "uint*", pBitmap)
	}
	return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
	return hbm
}

;#####################################################################################

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", "uint", hIcon, "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", "uint", pBitmap, "uint*", hIcon)
	return hIcon
}

;#####################################################################################

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
    Return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromClipboard()
{
	if !DllCall("OpenClipboard", "uint", 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_SetBitmapToClipboard(pBitmap)
{
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
	pdib := DllCall("GlobalLock", "uint", hdib)
	DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
	DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
	DllCall("GlobalUnlock", "uint", hdib)
	DllCall("DeleteObject", "uint", hBitmap)
	DllCall("OpenClipboard", "uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, "uint", hdib)
	DllCall("CloseClipboard")
}

;#####################################################################################

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h
	, "int", Format, "uint", pBitmap, "uint*", pBitmapDest)
	return pBitmapDest
}

;#####################################################################################
; Create resources
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
   return pPen
}

;#####################################################################################

Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", "uint", pBrush, "float", w, "int", 2, "uint*", pPen)
	return pPen
}

;#####################################################################################

Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "int", ARGB, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "int", ARGBfront, "int", ARGBback, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", "uint", pBitmap, "int", WrapMode, "uint*", pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", "uint", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", "uint", &PointF1, "uint", &PointF2, "int", ARGB1, "int", ARGB2, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", "uint", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", "uint", pBrush, "uint*", pBrushClone)
	return pBrushClone
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}

;#####################################################################################

Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", "uint", pBrush)
}

;#####################################################################################

Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}

;#####################################################################################

Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}

;#####################################################################################

Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}

;#####################################################################################

Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", "uint", hFont)
}

;#####################################################################################

Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", "uint", hFormat)
}

;#####################################################################################

Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", "uint", hFamily)
}

;#####################################################################################

Gdip_DeleteMatrix(Matrix)
{
   return DllCall("gdiplus\GdipDeleteMatrix", "uint", Matrix)
}

;#####################################################################################
; Text functions
;#####################################################################################

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}

;#####################################################################################

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}
	else
	{
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}	
}

;#####################################################################################

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)   
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	else
	{
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

; Near = 0
; Center = 1
; Far = 2
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", "uint", hFormat, "int", Align)
}

; StringFormatFlagsDirectionRightToLeft    = 0x00000001
; StringFormatFlagsDirectionVertical       = 0x00000002
; StringFormatFlagsNoFitBlackBox           = 0x00000004
; StringFormatFlagsDisplayFormatControl    = 0x00000020
; StringFormatFlagsNoFontFallback          = 0x00000400
; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
; StringFormatFlagsNoWrap                  = 0x00001000
; StringFormatFlagsLineLimit               = 0x00002000
; StringFormatFlagsNoClip                  = 0x00004000 
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, "uint*", hFormat)
   return hFormat
}

; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", "uint", hFamily, "float", Size, "int", Style, "int", 0, "uint*", hFont)
   return hFont
}

Gdip_FontFamilyCreate(Font)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", &wFont, "int", nSize)
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &wFont, "uint", 0, "uint*", hFamily)
	}
	else
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &Font, "uint", 0, "uint*", hFamily)
	return hFamily
}

;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "uint*", Matrix)
   return Matrix
}

Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", "uint*", Matrix)
   return Matrix
}

;#####################################################################################
; GraphicsPath functions
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "uint*", Path)
	return Path
}

Gdip_AddPathEllipse(Path, x, y, w, h)
{
	return DllCall("gdiplus\GdipAddPathEllipse", "uint", Path, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(Path, Points)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   

	return DllCall("gdiplus\GdipAddPathPolygon", "uint", Path, "uint", &PointF, "int", Points0)
}

Gdip_DeletePath(Path)
{
	return DllCall("gdiplus\GdipDeletePath", "uint", Path)
}

;#####################################################################################
; Quality functions
;#####################################################################################

; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", "uint", pGraphics, "int", RenderingHint)
}

; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}

; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   return DllCall("gdiplus\GdipSetCompositingMode", "uint", pGraphics, "int", CompositingMode)
}

;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
	if !DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("FreeLibrary", "uint", hModule)
	return 0
}

; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipRotateWorldTransform", "uint", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipScaleWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipTranslateWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics)
{
	return DllCall("gdiplus\GdipResetWorldTransform", "uint", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 3.14159, TAngle := Angle*(pi/180)	

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

; RotateNoneFlipNone   = 0
; Rotate90FlipNone     = 1
; Rotate180FlipNone    = 2
; Rotate270FlipNone    = 3
; RotateNoneFlipX      = 4
; Rotate90FlipX        = 5
; Rotate180FlipX       = 6
; Rotate270FlipX       = 7
; RotateNoneFlipY      = Rotate180FlipX
; Rotate90FlipY        = Rotate270FlipX
; Rotate180FlipY       = RotateNoneFlipX
; Rotate270FlipY       = Rotate90FlipX
; RotateNoneFlipXY     = Rotate180FlipNone
; Rotate90FlipXY       = Rotate270FlipNone
; Rotate180FlipXY      = RotateNoneFlipNone
; Rotate270FlipXY      = Rotate90FlipNone 

Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
	return DllCall("gdiplus\GdipImageRotateFlip", "uint", pBitmap, "int", RotateFlipType)
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect", "uint", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipPath", "uint", pGraphics, "uint", Path, "int", CombineMode)
}

Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", "uint", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", "uint" pGraphics, "uint*", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	return DllCall("gdiplus\GdipSetClipRegion", "uint", pGraphics, "uint", Region, "int", CombineMode)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "uint*", Region)
	return Region
}

Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", "uint", Region)
}

;#####################################################################################
; BitmapLockBits
;#####################################################################################

Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{   
	CreateRect(Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 21, 0)
	E := DllCall("Gdiplus\GdipBitmapLockBits", "uint", pBitmap, "uint", &Rect, "uint", LockMode, "int", PixelFormat, "uint", &BitmapData)
	Stride := NumGet(BitmapData, 8)
	Scan0 := NumGet(BitmapData, 16)
	return E
}

;#####################################################################################

Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
	return DllCall("Gdiplus\GdipBitmapUnlockBits", "uint", pBitmap, "uint", &BitmapData)
}

;#####################################################################################

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride))
}

;#####################################################################################

Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
	return NumGet(Scan0+0, (x*4)+(y*Stride))
}

;#####################################################################################

Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
	static PixelateBitmap
	if !PixelateBitmap
	{
		MCode_PixelateBitmap := "83EC388B4424485355568B74245C99F7FE8B5C244C8B6C2448578BF88BCA894C241C897C243485FF0F8E2E0300008B44245"
		. "499F7FE897C24448944242833C089542418894424308944242CEB038D490033FF397C2428897C24380F8E750100008BCE0FAFCE894C24408DA4240000"
		. "000033C03BF08944241089442460894424580F8E8A0000008B5C242C8D4D028BD52BD183C203895424208D3CBB0FAFFE8BD52BD142895424248BD52BD"
		. "103F9897C24148974243C8BCF8BFE8DA424000000008B5C24200FB61C0B03C30FB619015C24588B5C24240FB61C0B015C24600FB61C11015C241083C1"
		. "0483EF0175D38B7C2414037C245C836C243C01897C241475B58B7C24388B6C244C8B5C24508B4C244099F7F9894424148B44245899F7F9894424588B4"
		. "4246099F7F9894424608B44241099F7F98944241085F60F8E820000008D4B028BC32BC18D68038B44242C8D04B80FAFC68BD32BD142895424248BD32B"
		. "D103C18944243C89742420EB038D49008BC88BFE0FB64424148B5C24248804290FB644245888010FB644246088040B0FB644241088040A83C10483EF0"
		. "175D58B44243C0344245C836C2420018944243C75BE8B4C24408B5C24508B6C244C8B7C2438473B7C2428897C24380F8C9FFEFFFF8B4C241C33D23954"
		. "24180F846401000033C03BF2895424108954246089542458895424148944243C0F8E82000000EB0233D2395424187E6F8B4C243003C80FAF4C245C8B4"
		. "424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC2408BFD2BFA8B54241889442424895424408B4424200FB614080FB60101542414"
		. "8B542424014424580FB6040A0FB61439014424600154241083C104836C24400175CF8B44243C403BC68944243C7C808B4C24188B4424140FAFCE99F7F"
		. "9894424148B44245899F7F9894424588B44246099F7F9894424608B44241099F7F98944241033C08944243C85F60F8E7F000000837C2418007E6F8B4C"
		. "243003C80FAF4C245C8B4424280FAFC68D530203CA8D0C818BC32BC283C003894424208BC32BC2408BFB2BFA8B54241889442424895424400FB644241"
		. "48B5424208804110FB64424580FB654246088018B4424248814010FB654241088143983C104836C24400175CF8B44243C403BC68944243C7C818B4C24"
		. "1C8B44245C0144242C01742430836C2444010F85F4FCFFFF8B44245499F7FE895424188944242885C00F8E890100008BF90FAFFE33D2897C243C89542"
		. "45489442438EB0233D233C03BCA89542410895424608954245889542414894424400F8E840000003BF27E738B4C24340FAFCE03C80FAF4C245C034C24"
		. "548D55028BC52BC283C003894424208BC52BC2408BFD03CA894424242BFA89742444908B5424200FB6040A0FB611014424148B442424015424580FB61"
		. "4080FB6040F015424600144241083C104836C24440175CF8B4424408B7C243C8B4C241C33D2403BC1894424400F8C7CFFFFFF8B44241499F7FF894424"
		. "148B44245899F7FF894424588B44246099F7FF894424608B44241099F7FF8944241033C08944244085C90F8E8000000085F67E738B4C24340FAFCE03C"
		. "80FAF4C245C034C24548D53028BC32BC283C003894424208BC32BC2408BFB03CA894424242BFA897424448D49000FB65424148B4424208814010FB654"
		. "24580FB644246088118B5424248804110FB644241088043983C104836C24440175CF8B4424408B7C243C8B4C241C403BC1894424407C808D04B500000"
		. "00001442454836C2438010F858CFEFFFF33D233C03BCA89542410895424608954245889542414894424440F8E9A000000EB048BFF33D2395424180F8E"
		. "7D0000008B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC240894424248BC52BC28B54241"
		. "8895424548DA424000000008B5424200FB6140A015424140FB611015424588B5424240FB6140A015424600FB614010154241083C104836C24540175CF"
		. "8B4424448B4C241C403BC1894424440F8C6AFFFFFF0FAF4C24188B44241499F7F9894424148B44245899F7F9894424588B44246099F7F9894424608B4"
		. "4241099F7F98944241033C03944241C894424540F8E7B0000008B7C241885FF7E688B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D530203CA8D"
		. "0C818BC32BC283C003894424208BC32BC2408BEB894424242BEA0FB65424148B4424208814010FB65424580FB644246088118B5424248804110FB6442"
		. "41088042983C10483EF0175D18B442454403B44241C894424547C855F5E5D33C05B83C438C3"
		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		Loop % StrLen(MCode_PixelateBitmap)//2		;%
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "char")
	}

	Gdip_GetImageDimensions(pBitmap, Width, Height)
	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3

	E := DllCall(&PixelateBitmap, "uint", Scan01, "uint", Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}

;#####################################################################################

Gdip_ToARGB(A, R, G, B)
{
	return (A << 24) | (R << 16) | (G << 8) | B
}

;#####################################################################################

Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}

;#####################################################################################

Gdip_AFromARGB(ARGB)
{
	return (0xff000000 & ARGB) >> 24
}

;#####################################################################################

Gdip_RFromARGB(ARGB)
{
	return (0x00ff0000 & ARGB) >> 16
}

;#####################################################################################

Gdip_GFromARGB(ARGB)
{
	return (0x0000ff00 & ARGB) >> 8
}

;#####################################################################################

Gdip_BFromARGB(ARGB)
{
	return 0x000000ff & ARGB
}



;ELP Library


ELP_FileMoveDirectory(_FromDirectory, _ToDirectory, _Flags = 0)
{
	;_Flags
	;R | Rename
	;0 | Fail if exists
	;1 | Overwrite
	;2 | Overwrite
	;3 | Overwrite and always remove source files
	
	Global Ptr
	Static MY_ID := "ELPCF", ERROR_ALREADY_EXISTS := 183, Am_Root
	
	If (SubStr(_FromDirectory, 0, 1) != "\")
		_FromDirectory .= "\"
	
	If (SubStr(_ToDirectory, 0, 1) != "\")
		_ToDirectory .= "\"
	
	Failed_Moves := 0
	
	If (_Flags = "R"){
		ELP_ConvertPath(_FromDirectory)
		, ELP_ConvertPath(_ToDirectory)
		, Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
	} Else If (_Flags = 1 Or _Flags = 2){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromDirectory . "*.*", "Close", 0, FileInfo, MY_ID)
		, Failed_Moves += ELP_FileMove(_FromDirectory . "*.*", _ToDirectory . "*.*", 1, 1)
		, Source_Length := StrLen(_FromDirectory) + 1
		
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 2, 0, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
			Temp_ToDirectory := _ToDirectory . SubStr(FromFile, Source_Length)
			, Failed_Moves += ELP_FileMoveDirectory(FromFile, Temp_ToDirectory, _Flags)
		}
		
		Failed_Moves += ELP_FileRemoveDirectory(_FromDirectory)
	} Else If (_Flags = 0 Or _Flags = 3){
		If (ELP_FileExists(_ToDirectory, 1, 0, 0))
			Failed_Moves := 1
		Else {
			From_Device := ELP_GetPathRoot(_FromDirectory)
			, To_Device := ELP_GetPathRoot(_ToDirectory)
			
			If (From_Device = To_Device){
				ELP_ConvertPath(_FromDirectory)
				, ELP_ConvertPath(_ToDirectory)
				, Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
			} Else {
				Failed_Moves := ELP_FileCopyDirectory(_FromDirectory, _ToDirectory)
				
				If (!Failed_Moves Or _Flags = 3)
					ELP_FileRemoveDirectory(_FromDirectory, 1)
			}
		}
	}
	
	Return ErrorLevel := Failed_Moves
}

ELP_FileMove(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFM", ERROR_ALREADY_EXISTS := 183
	
	If (_IsPattern){
		If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile),"D"))
			Return ErrorLevel := 1
		
		P := InStr(_FromFile, "\", False, 0)
		
		If (InStr(_FromFile, "*", False, P))
			Source_IsPattern := True
		Else
			Source_IsPattern := False
		
		P := InStr(_ToFile, "\", False, 0)
		
		If (InStr(_ToFile, "*", False, P))
			Destination_IsPattern := True
		Else
			Destination_IsPattern := False
		
		If (!Destination_IsPattern){
			If (SubStr(_ToFile, 0, 1) = "\")
				Destination_IsPattern := True
			Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
				_ToFile .= "\", Destination_IsPattern := True
			
			If (!Source_IsPattern And Destination_IsPattern){
				_ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
				, Destination_IsPattern := False
			}
		}
		
		If (!Source_IsPattern And !Destination_IsPattern)
			_IsPattern := False
	}
	
	Failed_Moves := 0
	
	If (_CreateDestination){
		Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
		
		If (!ELP_FileExists(Directory, 1, 0, 0))
			ELP_FileCreateDirectory(Directory)
	}
	
	From_Device := ELP_GetPathRoot(_FromFile)
	, To_Device := ELP_GetPathRoot(_ToFile)
	
	If (From_Device != To_Device)
		Method_Copy := True
	
	If (!_IsPattern){
		If (Method_Copy){
			Failed_Moves := ELP_FileCopy(_FromFile, _ToFile, _OverWrite, 0, 0)
			
			If (!Failed_Moves)
				ELP_FileDelete(_FromFile, 1, 0)
		} Else {
			__FromFile := _FromFile
			, __ToFile := _ToFile
			, ELP_ConvertPath(__FromFile)
			, ELP_ConvertPath(__ToFile)
			, Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
			
			If (Failed_Moves And _OverWrite And A_LastError = ERROR_ALREADY_EXISTS){
				If (!ELP_FileDelete(_ToFile, 1, 0))
					Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
			}
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
		
		Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
		If (Destination_Pattern != ""){
			_ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
			
			StringSplit,FN_,Destination_Pattern,.
			
			Dest_Name := FN_1
			, Dest_Extension := FN_2
		}
		
		;MsgBox % _ToFile "`n" Dest_Name "`n" Dest_Extension
		
		Loop
		{
			MoveFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
			
			If (MoveFromFile = "")
				Break
			
			;Populate the Copy-To variable with the Copy-From file name
			Source_Name := SubStr(MoveFromFile, InStr(MoveFromFile, "\", False, 0) + 1)
			
			If (Destination_Pattern){
				MoveTo_Name := Dest_Name
				, MoveTo_Extension := Dest_Extension
				, P := InStr(Source_Name, ".", False, 0)
				
				If (P){
					SFN_1 := SubStr(Source_Name, 1, P - 1)
					, SFN_2 := SubStr(Source_Name, P + 1)
				} Else {
					SFN_1 := Source_Name
					, SFN_2 := ""
				}
				
				If (InStr(MoveTo_Name,"*")){
					StringReplace, MoveTo_Name, MoveTo_Name, *, %SFN_1%
					StringReplace, MoveTo_Name, MoveTo_Name, *,, A
				}
				
				If (InStr(MoveTo_Extension,"*")){
					StringReplace, MoveTo_Extension, MoveTo_Extension, *, %SFN_2%
					StringReplace, MoveTo_Extension, MoveTo_Extension, *,, A
				}
				
				If (MoveTo_Extension)
					MoveToFile := _ToFile . MoveTo_Name . "." . MoveTo_Extension
				Else
					MoveToFile := _ToFile . MoveTo_Name
			} Else
				MoveToFile := _ToFile . Source_Name
			
			;MsgBox % "Source file: " MoveFromFile "`nDestination file: " MoveToFile
			
			If (Method_Copy){
				E := ELP_FileCopy(MoveFromFile, MoveToFile, _OverWrite, 0, 0)
			
				If (!E)
					ELP_FileDelete(MoveFromFile, 1, 0)
				Else
					Failed_Moves ++
			} Else {
				ELP_ConvertPath(MoveFromFile)
				, ELP_ConvertPath(MoveToFile)
				, E := DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
				;MsgBox % E "`n`n" A_LastError
				If (E){
					If (_OverWrite And A_LastError = ERROR_ALREADY_EXISTS And !ELP_FileDelete(_ToFile, 1, 0))
						Failed_Moves += DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
					Else
						Failed_Moves ++
				}
			}
		}
	}
	
	Return Failed_Moves
}

ELP_FileCopyDirectory(_FromDirectory, _ToDirectory, _Overwrite = 0)
{
	Global Ptr
	Static MY_ID := "ELPFCD"
	
	If (SubStr(_FromDirectory, 0, 1) != "\")
		_FromDirectory .= "\"
	
	If (SubStr(_ToDirectory, 0, 1) != "\")
		_ToDirectory .= "\"
	
	If (_FromDirectory = _ToDirectory)
		Return ErrorLevel := 1
	
	If (SubStr(_ToDirectory, 1, StrLen(_FromDirectory)) = _FromDirectory)
		Method := 2
	Else
		Method := 1
	
	Destination_Exists := ELP_FileExists(_ToDirectory, 1, 0, 0)
	
	If (Destination_Exists And !_Overwrite)
		Return ErrorLevel := 1
	
	Errored_Directories := 0
	, Errored_Files := 0
	
	, From_BaseLength := StrLen(_FromDirectory)
	, To_BaseLength := StrLen(_ToDirectory)
	
;	MsgBox % _ToDirectory "`n" _FromDirectory "`n" SubStr(_ToDirectory,1,StrLen(_FromDirectory))
	
;	MsgBox % Method "`n" From_BaseLength "`n" _ToDirectory "`n" _FromDirectory
	
	If (Method = 1){
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
			CopyFile := SubStr(FromFile, From_BaseLength + 1)
			
			If (ELP_IsDirectoryFromFI(FileInfo)){
				If (ELP_FileCreateDirectory(_ToDirectory . CopyFile))
					Errored_Directories ++
			} Else {
				If (ELP_FileCopy(_FromDirectory . CopyFile, _ToDirectory . CopyFile, _Overwrite, 0, 0))
					Errored_Files ++
			}
		}
	} Else If (Method = 2){
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
;			MsgBox % FromFile
			
			If (SubStr(FromFile,1,To_BaseLength) = _ToDirectory)
				Continue
			
			FromFile := SubStr(FromFile, From_BaseLength + 1)
			
;			MsgBox % FromFile
			
			If (ELP_IsDirectoryFromFI(FileInfo))
				DirectoryContents .= DirectoryContents ? "|" . FromFile . "\" : FromFile . "\"
			Else
				DirectoryContents .= DirectoryContents ? "|" . FromFile : FromFile
		}
		
		If (!Destination_Exists And ELP_FileCreateDirectory(_ToDirectory))
			Return ErrorLevel := 1
		
		Loop,Parse,DirectoryContents,|
		{
			If (SubStr(A_LoopField, 0, 1) = "\"){
				If (ELP_FileCreateDirectory(_ToDirectory . A_LoopField))
					Errored_Directories ++
			} Else {
				If (ELP_FileCopy(_FromDirectory . A_LoopField, _ToDirectory . A_LoopField, _Overwrite, 0, 0))
					Errored_Files ++
			}
		}
		
		VarSetCapacity(DirectoryContents, 0)
	}
	
	If (Errored_Directories Or Errored_Files)
		Return Errored_Directories . "|" . Errored_Files
}

ELP_FileCopy(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFC"
	
	If (_IsPattern){
		If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile), "D"))
			Return ErrorLevel := 1
		
		P := InStr(_FromFile, "\", False, 0)
		
		If (InStr(_FromFile, "*", False, P))
			Source_IsPattern := True
		Else
			Source_IsPattern := False
		
		P := InStr(_ToFile, "\", False, 0)
		
		If (InStr(_ToFile, "*", False, P))
			Destination_IsPattern := True
		Else
			Destination_IsPattern := False
		
		If (!Destination_IsPattern){
			If (SubStr(_ToFile, 0, 1) = "\")
				Destination_IsPattern := True
			Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
				_ToFile .= "\", Destination_IsPattern := True
			
			If (!Source_IsPattern And Destination_IsPattern){
				_ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
				, Destination_IsPattern := False
			}
		}
		
		If (!Source_IsPattern And !Destination_IsPattern)
			_IsPattern := False
	}
	
	Failed_Copies := 0
	
	If (_CreateDestination){
		Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
		
		If (!ELP_FileExists(Directory, 1, 0, 0))
			ELP_FileCreateDirectory(Directory)
	}
	
	If (!_IsPattern){
		__FromFile := _FromFile
		, __ToFile := _ToFile
		, ELP_ConvertPath(__FromFile)
		, ELP_ConvertPath(__ToFile)
		, Failed_Copies := DllCall("CopyFileW", Ptr, &__FromFile, Ptr, &__ToFile, "Int", !_OverWrite) = 0 ? 1 : 0
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
		
		Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
		If (Destination_Pattern != ""){
			_ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
			
			StringSplit, FN_, Destination_Pattern, .
			
			Dest_Name := FN_1
			, Dest_Extension := FN_2
		}
		
		;MsgBox % _ToFile "`n" Dest_Name "`n" Dest_Extension
		
		Loop
		{
			CopyFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
			
			If (CopyFromFile = "")
				Break
			
			;Populate the Copy-To variable with the Copy-From file name
			Source_Name := SubStr(CopyFromFile, InStr(CopyFromFile, "\", False, 0) + 1)
			
			If (Destination_Pattern){
				CopyTo_Name := Dest_Name
				, CopyTo_Extension := Dest_Extension
				, P := InStr(Source_Name, ".", False, 0)
				
				If (P){
					SFN_1 := SubStr(Source_Name, 1, P - 1)
					, SFN_2 := SubStr(Source_Name, P + 1)
				} Else {
					SFN_1 := Source_Name
					, SFN_2 := ""
				}
				
				If (InStr(CopyTo_Name,"*")){
					StringReplace, CopyTo_Name, CopyTo_Name, *, %SFN_1%
					StringReplace, CopyTo_Name, CopyTo_Name, *,, A
				}
				
				If (InStr(CopyTo_Extension,"*")){
					StringReplace, CopyTo_Extension, CopyTo_Extension, *, %SFN_2%
					StringReplace, CopyTo_Extension, CopyTo_Extension, *,, A
				}
				
				If (CopyTo_Extension)
					CopyToFile := _ToFile . CopyTo_Name . "." . CopyTo_Extension
				Else
					CopyToFile := _ToFile . CopyTo_Name
			} Else
				CopyToFile := _ToFile . Source_Name
			
			;MsgBox % "Source file: " CopyFromFile "`nDestination file: " CopyToFile
			ELP_ConvertPath(CopyFromFile)
			, ELP_ConvertPath(CopyToFile)
			, Failed_Copies += DllCall("CopyFileW", Ptr, &CopyFromFile, Ptr, &CopyToFile, "Int", !_OverWrite) = 0 ? 1 : 0
		}
	}
	
	Return Failed_Copies
}

ELP_FileGetVersion(_FileName, _Which = 1)
{
	Global Ptr
	
	ELP_ConvertPath(_FileName)
	, Size := DllCall("Version.dll\GetFileVersionInfoSizeW", Ptr, &_FileName, Ptr, 0)
	
	If (!Size){
		ErrorLevel := 1
		Return
	}
	
	VarSetCapacity(FileVersion,Size,0)
	, DllCall("Version.dll\GetFileVersionInfoW", Ptr, &_FileName, "Int", 0, "Int", Size, Ptr, &FileVersion)
	, VarSetCapacity(SL, 2, 0)
	, NumPut(Asc("\"), SL, 0, "UShort")
	
	If (!DllCall("Version.dll\VerQueryValueW", Ptr, &FileVersion, Ptr, &SL, "Int64*", pFFI, "UInt*", uSize)){
		VarSetCapacity(FileVersion, Size, 0)
		, VarSetCapacity(FileVersion, 0)
		, ErrorLevel := 1
		
		Return
	}
	
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms646997(v=vs.85).aspx
	
	If (_Which = 1){
		FVMS := NumGet(pFFI+0, 8, "Int")
		, FVLS := NumGet(pFFI+0, 12, "Int")
		, Version := (FVMS >> 16) . "." . (FVMS & 0xFFFF) . "." . (FVLS >> 16) . "." . (FVLS & 0xFFFF)
	} Else If (_Which = 2){
		PVMS := NumGet(pFFI+0, 8, "Int")
		, PVLS := NumGet(pFFI+0, 12, "Int")
		, Version := (PVMS >> 16) . "." . (PVMS & 0xFFFF) . "." . (PVLS >> 16) . "." . (PVLS & 0xFFFF)
	}
	
	;Cleanup
	VarSetCapacity(FileVersion, Size, 0)
	, VarSetCapacity(FileVersion, 0)
	
	Return Version
}

ELP_FileRemoveDirectory(_Directory, _Recurse = 0)
{
	Global Ptr
	Static MY_ID := "ELPFRD"
	
	If (SubStr(_Directory,0) != "\")
		_Directory .= "\"
	
	__Directory := _Directory
	, ELP_ConvertPath(__Directory)
	, E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
	
	If (!_Recurse And !E){
		;If (A_LastError
		Return ErrorLevel := 1
	} Else If (_Recurse And !E){
		E := ELP_FileDelete(_Directory . "*.*")
		
		If (E){
			ErrorLevel := 1
			
			Return E
		}
		
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
		
		Loop
		{
			Folder := ELP_LoopFilePattern(_Directory . "*.*", 2, 0, FileInfo, MY_ID)
			
			If (Folder = "")
				Break
			
			E := ELP_FileRemoveDirectory(Folder, _Recurse)
			
			If (E){
				ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
				, ErrorLevel := 1
				
				Return E
			}
		}
		
		__Directory := _Directory
		, ELP_ConvertPath(__Directory)
		, E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
		
		If (!E)
			Return ErrorLevel := 1
	}
}

ELP_FileExists(_FileName, _IncludeFolders = 1, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFE"
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	If (_IncludeFolders != 1 Or _Recurse)
		_IsPattern := True
	Else If (!_IsPattern){
		__FileName := _FileName
		ELP_ConvertPath(__FileName)
		, E := DllCall("GetFileAttributesW", Ptr, &__FileName)
		
		If (E = -1) ;Try the find-file method
			_IsPattern := True, E := False
	}
	
	If (_IsPattern){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		, FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
		
		If (FileName != ""){
			ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
			, E := True
		}
	}
	
	Return E
}

ELP_FileDelete(_FileName, _ForceDelete = 1, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFD"
	
	FailedDeletes := 0
	, __FileName := _FileName
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	If (!_IsPattern){
		ELP_ConvertPath(__FileName)
		, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
		
		If (A_LastError != 2){
			If (E = 5 And _ForceDelete){
				If (ELP_FileSetAttributes("-R", _FileName, 0, 0, _IsPattern))
					FailedDeletes ++
				Else If (!DllCall("DeleteFileW", Ptr, &__FileName))
					FailedDeletes ++
			} Else If (E)
				FailedDeletes ++
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		Loop
		{
			FileName := ELP_LoopFilePattern(_FileName, 0, 0, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			__FileName := FileName
			, ELP_ConvertPath(__FileName)
			, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
			
			If (A_LastError != 2){
				If (E = 5 And _ForceDelete){
					Original_Attributes := ELP_FileGetAttributesFromFI(FileInfo, 1)
					
					If (Original_Attributes){
						New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, "-R")
						
						If (New_Attributes != Original_attributes){
							ELP_FileSetRAWAttributes(FileName, New_Attributes)
							, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
						}
					}
				}
				
				If (E)
					FailedDeletes ++
			}
		}
	}
	
	Return FailedDeletes
}

ELP_FileSetAttributes(_Attributes, _FileName, _IncludeFolders = 0, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFSA"
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	FailedAttributeChanges := 0
	
	If (!_IsPattern){
		Original_Attributes := ELP_FileGetAttributes(_FileName, 1)
		
		If (Original_Attributes = -1)
			FailedAttributeChanges ++
		Else {		
			New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
			
			If (New_Attributes != Original_Attributes){
				ELP_FileSetRAWAttributes(_FileName, New_Attributes)
				
				If (ErrorLevel)
					FailedAttributeChanges ++
			}
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		Loop
		{
			FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			Original_Attributes := ELP_FileGetAttributes(FileName, 1)
			
			If (Original_Attributes = -1)
				FailedAttributeChanges ++
			Else {		
				New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
				
				If (New_Attributes != Original_Attributes){
					ELP_FileSetRAWAttributes(_FileName, New_Attributes)
					
					If (ErrorLevel)
						FailedAttributeChanges ++
				}
			}
		}
	}
	
	Return FailedAttributeChanges
}

ELP_ChangeRawAttributes(New_Attributes, _NewAttributes)
{
	Static FILE_ATTRIBUTE_ARCHIVE := 32
	, FILE_ATTRIBUTE_HIDDEN := 2
	, FILE_ATTRIBUTE_NORMAL := 128
	, FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
	, FILE_ATTRIBUTE_OFFLINE := 4096
	, FILE_ATTRIBUTE_READONLY := 1
	, FILE_ATTRIBUTE_SYSTEM := 4
	, FILE_ATTRIBUTE_TEMPORARY := 256
	, Allowed_Attributes := "AHN2ORST"
	
	Mode := -1
	
	Loop,Parse,_NewAttributes
	{
		If (A_LoopField = "-")
			Mode := -1
		Else If (A_LoopField = "+")
			Mode := 1
		Else If (A_LoopField = "^")
			Mode := 0
		Else If (InStr(Allowed_Attributes, A_LoopField)){
			If (A_LoopField = "R")
				Temp_Attribute := FILE_ATTRIBUTE_READONLY
			Else If (A_LoopField = "A")
				Temp_Attribute := FILE_ATTRIBUTE_ARCHIVE
			Else If (A_LoopField = "H")
				Temp_Attribute := FILE_ATTRIBUTE_HIDDEN
			Else If (A_LoopField = "N")
				Temp_Attribute := FILE_ATTRIBUTE_NORMAL
			Else If (A_LoopField = 2)
				Temp_Attribute := FILE_ATTRIBUTE_NOT_CONTENT_INDEXED
			Else If (A_LoopField = "O")
				Temp_Attribute := FILE_ATTRIBUTE_OFFLINE
			Else If (A_LoopField = "S")
				Temp_Attribute := FILE_ATTRIBUTE_SYSTEM
			Else If (A_LoopField = "T")
				Temp_Attribute := FILE_ATTRIBUTE_TEMPORARY
			
			If (Mode < 0)
				New_Attributes := New_Attributes & ~Temp_Attribute
			Else If (Mode > 0)
				New_Attributes := New_Attributes | Temp_Attribute
			Else
				New_Attributes := New_Attributes ^ Temp_Attribute
		}
	}
	
	Return New_Attributes
}

ELP_FileSetRAWAttributes(_FileName, _Attributes)
{
	Global Ptr
	
	If _Attributes Is Not Number
	{
		ErrorLevel := -1
		Return
	}
	
	ELP_ConvertPath(_FileName)
	, ErrorLevel := DllCall("SetFileAttributesW", Ptr, &_FileName, "Int", _Attributes) = 0 ? 1 : 0
}

ELP_ConvertRAWAttributes(_RawAttributes)
{
	Static FILE_ATTRIBUTE_ARCHIVE := 32
	, FILE_ATTRIBUTE_COMPRESSED := 2048
	, FILE_ATTRIBUTE_DEVICE := 64
	, FILE_ATTRIBUTE_DIRECTORY := 16
	, FILE_ATTRIBUTE_ENCRYPTED := 16384
	, FILE_ATTRIBUTE_HIDDEN := 2
	, FILE_ATTRIBUTE_NORMAL := 128
	, FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
	, FILE_ATTRIBUTE_OFFLINE := 4096
	, FILE_ATTRIBUTE_READONLY := 1
	, FILE_ATTRIBUTE_REPARSE_POINT := 1024
	, FILE_ATTRIBUTE_SPARSE_FILE := 512
	, FILE_ATTRIBUTE_SYSTEM := 4
	, FILE_ATTRIBUTE_TEMPORARY := 256
	, FILE_ATTRIBUTE_VIRTUAL := 65536
	
	Attributes .= _RawAttributes & FILE_ATTRIBUTE_ARCHIVE ? "A" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_COMPRESSED ? "C" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_DEVICE ? "1" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_DIRECTORY ? "D" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_ENCRYPTED ? "E" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_HIDDEN ? "H" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_NORMAL ? "N" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_NOT_CONTENT_INDEXED ? "2" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_OFFLINE ? "O" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_READONLY ? "R" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_REPARSE_POINT ? "3" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_SPARSE_FILE ? "4" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_SYSTEM ? "S" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_TEMPORARY ? "T" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_VIRTUAL ? "V" : ""
	
	Return Attributes
}

ELP_FileGetAttributes(_FileName, _Raw = 0)
{
	Global Ptr
	
	ELP_ConvertPath(_FileName)
	, RAW_Attributes := DllCall("GetFileAttributesW", Ptr, &_FileName)
	
	If (RAW_Attributes = -1)
		Return -1
	
	If (_Raw)
		Return RAW_Attributes
	Else 
		Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetSize(_FileName, _Units = "B", _Floor = 0)
{
	Static MY_ID := "ELPFGS"
	
	If (!ELP_FileExists(_FileName))
		Return 0
	
	Handle := ELP_OpenFileHandle(_FileName, "Read", FileSize)
	
	If (Handle = -1){
		ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID) ;Just incase this search pattern was done before - rare but it might happen
		If (ELP_LoopFilePattern(_FileName, 1, 0, FileInfo) = "")
			FileSize := 0
		Else {
			FileSize := ELP_GetFileSizeFromFI(FileInfo)
			, ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID)
		}
	} Else
		ELP_CloseFileHandle(Handle)
	
	If (_Units = "K")
		FileSize := FileSize / 1024
	Else If (_Units = "M")
		FileSize := FileSize / 1024 / 1024
	Else If (_Units = "G")
		FileSize := FileSize / 1024 / 1024 / 1024
	
	If (_Floor)
		FileSize := Floor(FileSize)
	
	Return FileSize
}

ELP_GetFileSizeFromFI(ByRef _FileInfo, _Units = "B", _Floor = 0)
{
	Static FileSizeOffset := 28, MAXDWORD := 4294967295
	
	HighOrder := NumGet(_FileInfo, FileSizeOffset, "Int")
	, LowOrder := NumGet(_FileInfo, FileSizeOffset + 4, "Int")
	
	FileSize := (HighOrder * (MAXDWORD+1)) + LowOrder
	
	If (_Units = "K")
		FileSize := FileSize / 1024
	Else If (_Units = "M")
		FileSize := FileSize / 1024 / 1024
	Else If (_Units = "G")
		FileSize := FileSize / 1024 / 1024 / 1024
	
	If (_Floor)
		FileSize := Floor(FileSize)
	
	Return FileSize
}

ELP_FileGetAttributesFromFI(ByRef _FileInfo, _Raw = 0)
{
	Static FileAttributesOffset := 0
	
	RAW_Attributes := NumGet(_FileInfo, FileAttributesOffset, "Int")
	
	If (_Raw)
		Return RAW_Attributes
	Else
		Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetTimeFromFI(ByRef _FileInfo, _Which = "M", _Style = 1)
{
	Global Ptr
	Static CO := 4, AO := 12, MO := 20
	
	
	If (_Which = "C")
		Address := &_FileInfo + CO
	Else If (_Which = "A")
		Address := &_FileInfo + AO
	Else 
		Address := &_FileInfo + MO
	
	VarSetCapacity(FSystemTime,16,0) ;8*2
	
	If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
		Year := NumGet(FSystemTime, 0, "Short") 
		, Month := NumGet(FSystemTime, 2, "Short") 
		;, WDay := NumGet(FSystemTime, 4, "Short")
		, Day := NumGet(FSystemTime, 6, "Short")
		, Hour := NumGet(FSystemTime, 8, "Short")
		, Minute := NumGet(FSystemTime, 10, "Short")
		, Second := NumGet(FSystemTime, 12, "Short")
		, Milisecond := NumGet(FSystemTime, 14, "Short")
		, VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		
		If (_Style = 1){
			RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
			, RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
			Return RVal
		} Else If (_Style = 2)
			Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
	} Else {
		VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		, ErrorLevel := 3
	}
}

ELP_FileGetTime(_FileName, _Which = "M", _Style = 1)
{
	Global Ptr
	Static CO := 4, AO := 12, MO := 20
	
	Handle := ELP_OpenFileHandle(_FileName, "Read")
	
	If (Handle = -1){
		ErrorLevel := 1
		Return
	}
	
	VarSetCapacity(FileInformation, 52, 0) ;13*4
	
	If (!DllCall("GetFileInformationByHandle", Ptr, Handle, Ptr, &FileInformation)){
		ErrorLevel := 2
		, ELP_CloseFileHandle(Handle)
		, VarSetCapacity(FileInformation, 52, 0)
		, VarSetCapacity(FileInformation, 0)
		
		Return
	} Else
		ELP_CloseFileHandle(Handle)
	
	If (_Which = "C")
		Address := &FileInformation + CO
	Else If (_Which = "A")
		Address := &FileInformation + AO
	Else 
		Address := &FileInformation + MO
	
	VarSetCapacity(FSystemTime,16,0) ;8*2
	
	If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
		Year := NumGet(FSystemTime, 0, "Short") 
		, Month := NumGet(FSystemTime, 2, "Short") 
		;, WDay := NumGet(FSystemTime, 4, "Short")
		, Day := NumGet(FSystemTime, 6, "Short")
		, Hour := NumGet(FSystemTime, 8, "Short")
		, Minute := NumGet(FSystemTime, 10, "Short")
		, Second := NumGet(FSystemTime, 12, "Short")
		, Milisecond := NumGet(FSystemTime, 14, "Short")
		, VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		
		If (_Style = 1){
			RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
			, RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
			Return RVal
		} Else If (_Style = 2)
			Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
	} Else {
		VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		, ErrorLevel := 3
	}
}


ELP_FileAppend(_String, _FileName)
{
	Global Ptr
	
	If (_FileName = ""){
		ErrorLevel := 2
		Return
	}
	
	If (SubStr(_FileName, 1, 1) = "*"){
		Binary_Mode := True
		, _FileName := SubStr(_FileName, 2)
	}
	
	If (P := InStr(_FileName, ",")){
		CodePage := SubStr(_FileName, P + 1)
		, _FileName := SubStr(_FileName, 1, P-1)
	} Else If (A_FileEncoding)
		CodePage := A_FileEncoding
	
	Handle := ELP_OpenFileHandle(_FileName, "Write", FileSize)
	
	If (Handle = -1){
		ErrorLevel := 1
		Return
	}
	
	If (CodePage = "")
		W_CP := 0
	Else If (CodePage = "UTF-8" Or CodePage = "UTF-8-RAW")
		W_CP := 65001
	Else If (CodePage = "UTF-16" Or CodePage = "UTF-16-RAW")
		W_CP := 1200
	Else If (SubStr(CodePage, 1, 2) = "CP"){
		W_CP := SubStr(CodePage, 2)
		
		If W_CP Is Not Number
			W_CP := 0
	} Else
		W_CP := 0
	
	If (!Binary_Mode){
		If (!InStr(_String, "`r`n") And InStr(_String, "`n"))
			StringReplace, _String, _String, "`n", "`r`n", 1
	}
	
	If (A_IsUnicode){
		If (W_CP != 1200){
			If (W_CP = 0)
				W_CP := DllCall("GetACP")
			
			StringLength := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(__String, StringLength, 0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength, Ptr, 0, Ptr, 0)
			, Converted := True
		}
	} Else If (W_CP != 0){
		StringLength := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0)
		, VarSetCapacity(__String, StringLength * 2, 0)
		, DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength)
		
		If (W_CP != 1200){
			Temp_StringLength := StringLength
			StringLength := DllCall("WideCharToMultiByte","UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(_String,StringLength,0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, &_String, "Int", StringLength, Ptr, 0, Ptr, 0)
			, VarSetCapacity(__String, Temp_StringLength * 2, 0)
			, VarSetCapacity(__String, 0)
		} Else
			StringLength *= 2
		
		Converted := True
	}
	
	If (FileSize = 0){
		If (CodePage = "UTF-8"){
			VarSetCapacity(BOM, 3, 0)
			, NumPut(239, BOM,0, "UChar")
			, NumPut(187, BOM,1, "UChar")
			, NumPut(191, BOM,2, "UChar")
			, ELP_WriteData(Handle, &BOM, 3)
			, FileSize += 3
			, VarSetCapacity(BOM, 3, 0)
			, VarSetCapacity(BOM, 0)
		} Else If (CodePage = "UTF-16"){
			VarSetCapacity(BOM, 2, 0)
			, NumPut(255, BOM, 0, "UChar")
			, NumPut(254, BOM, 1, "UChar")
			, ELP_WriteData(Handle, &BOM, 2)
			, FileSize += 2
			, VarSetCapacity(BOM, 2, 0)
			, VarSetCapacity(BOM, 0)
		}
	}
	
	ELP_SetFilePointer(Handle, FileSize)
	
	If (Converted){
		If (A_IsUnicode Or W_CP = 1200){
			ELP_WriteData(Handle, &__String, StringLength)
			, VarSetCapacity(__String, StringLength, 0)
			, VarSetCapacity(__String, 0)
		} Else {
			ELP_WriteData(Handle, &_String, StringLength)
			, VarSetCapacity(_String, StringLength, 0)
			, VarSetCapacity(_String, 0)
		}
	} Else
		ELP_WriteData(Handle, &_String, StrLen(_String) * (A_IsUnicode ? 2 : 1))
	
	ELP_CloseFileHandle(Handle)
}

ELP_LoopFilePattern(_FileName, _IncludeFolders = 0, _DoRecurse = 0, ByRef FileInfo = "", Override_ID = "")
{
	Static
	;Ensures that atleast the first entry of the common sets are static
	Static @0__CurrentFileName, @0__CurrentPath, @0__Handle, @0__FN, Stored__Handles
	, @0_ELPFRD_CurrentFileName, @0_ELPFRD_CurrentPath, @0_ELPFRD_Handle, @0_ELPFRD_FN, Stored_ELPFRD_Handles
	, @0_ELPFE_CurrentFileName, @0_ELPFE_CurrentPath, @0_ELPFE_Handle, @0_ELPFE_FN, Stored_ELPFE_Handles
	, @0_ELPFD_CurrentFileName, @0_ELPFD_CurrentPath, @0_ELPFD_Handle, @0_ELPFD_FN, Stored_ELPFD_Handles
	, @0_ELPFSA_CurrentFileName, @0_ELPFSA_CurrentPath, @0_ELPFSA_Handle, @0_ELPFSA_FN, Stored_ELPFSA_Handles
	, @0_ELPFGS_CurrentFileName, @0_ELPFGS_CurrentPath, @0_ELPFGS_Handle, @0_ELPFGS_FN, Stored_ELPFGS_Handles
	, @0_ELPCF_CurrentFileName, @0_ELPCF_CurrentPath, @0_ELPCF_Handle, @0_ELPCF_FN, Stored_ELPCF_Handles
	, @0_ELPFM_CurrentFileName, @0_ELPFM_CurrentPath, @0_ELPFM_Handle, @0_ELPFM_FN, Stored_ELPFM_Handles
	, @0_ELPFCD_CurrentFileName, @0_ELPFCD_CurrentPath, @0_ELPFCD_Handle, @0_ELPFCD_FN, Stored_ELPFCD_Handles
	, @0_ELPFC_CurrentFileName, @0_ELPFC_CurrentPath, @0_ELPFC_Handle, @0_ELPFC_FN, Stored_ELPFC_Handles
	Global Ptr
	Local FileName, FilePath, SearchPattern, Folders
	, P1, P2, Handle, __FileName, __ID, ID, FoundName ;, Recursed := 0
	
	ELPLFP_Start:
	
	If (Last_OverrideID = Override_ID And Last_FileName = _FileName){
		__ID := Last___ID
		, FileName := @%__ID%_%Override_ID%_CurrentFileName
		, CurrentPath := @%__ID%_%Override_ID%_CurrentPath
		, Handle := @%__ID%_%Override_ID%_Handle
	} Else If (P1 := InStr(Stored_%Override_ID%_Handles,"|" . _FileName . "|")){
		P2 := P1 + StrLen(_FileName) + 2
		, __ID := SubStr(Stored_%Override_ID%_Handles, P2, InStr(Stored_%Override_ID%_Handles, "|", False, P2) - P2)
		, FileName := @%__ID%_%Override_ID%_CurrentFileName
		, CurrentPath := @%__ID%_%Override_ID%_CurrentPath
		, Handle := @%__ID%_%Override_ID%_Handle
		, Last_FileName := _FileName
		, Last___ID := __ID
		, Last_OverrideID := Override_ID
	} Else If (_IncludeFolders != "Close"){
		FileName := _FileName
		, __ID := 0
		
		While (InStr(Stored_%Override_ID%_Handles,"|" . __ID . "|"))
			__ID ++
		
		@%__ID%_%Override_ID%_FN := 0
		, Stored_%Override_ID%_Handles .= Stored_%Override_ID%_Handles ? _FileName . "|" . __ID . "|" : "|" . _FileName . "|" . __ID . "|"
		, Last_FileName := _FileName
		, Last___ID := __ID
		, Last_OverrideID := Override_ID
	}
	
	If (_IncludeFolders = "Close"){
		ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
		If (__ID != ""){
			VarSetCapacity(@%__ID%_%Override_ID%_CurrentFileName, 0)
			, VarSetCapacity(@%__ID%_%Override_ID%_CurrentPath, 0)
			, ELP_FindClose(@%__ID%_%Override_ID%_Handle)
			, VarSetCapacity(@%__ID%_%Override_ID%_Handle, 0)
			
			Loop,% @%__ID%_%Override_ID%_FN
				VarSetCapacity(@Folder_%A_Index%_%Override_ID%, 0)
			
			VarSetCapacity(@%__ID%_%Override_ID%_FN, 0)
		}
		
		VarSetCapacity(Last_FileName, 0)
		, VarSetCapacity(Last___ID, 0)
		, VarSetCapacity(Last_OverrideID, 0)
		, VarSetCapacity(FileInfo, 1140, 0)
		, VarSetCapacity(FileInfo, 0)
		
		Return
	}
	
	If (!Handle){
		__FileName := FileName
		, ELP_ConvertPath(__FileName)
		, VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		, Handle := DllCall("FindFirstFileW", Ptr, &__FileName, Ptr, &FileInfo)
		
		If (Handle = -1){
			If (_DoRecurse){
				Folders := ELP_FindFolders(FileName, _DoRecurse)

				If (Folders != ""){
					P1 := InStr(FileName, "\", False, 0)
					, FilePath := SubStr(FileName, 1, P1)
					, SearchPattern := SubStr(FileName, P1+1)
					
					Loop,Parse,Folders,|
					{
						@%__ID%_%Override_ID%_FN ++
						ID := @%__ID%_%Override_ID%_FN
						@Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
					}
				}
			}
		} Else {
			FoundName := ELP_GetNameFromFI(FileInfo)
			, @%__ID%_%Override_ID%_CurrentFileName := FileName
			, CurrentPath := @%__ID%_%Override_ID%_CurrentPath := SubStr(FileName, 1, InStr(FileName, "\", False, 0))
			, @%__ID%_%Override_ID%_Handle := Handle
			
			If (FoundName = "." Or FoundName = ".."){
				FoundName := ""
				, VarSetCapacity(FileInfo, 0)
				GoTo,ELPLFP_Start
			} Else If (!_IncludeFolders){
				If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			} Else If (_IncludeFolders = 2){
				If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			}
		}
	} Else {
		VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		
		If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
			ELP_FindClose(Handle)
			, Handle := @%__ID%_%Override_ID%_Handle := ""
			
			If (_DoRecurse){
				Folders := ELP_FindFolders(FileName, _DoRecurse)
				
				If (Folders != ""){
					P1 := InStr(FileName, "\", False, 0)
					, FilePath := SubStr(FileName, 1, P1)
					, SearchPattern := SubStr(FileName, P1+1)
					
					Loop, Parse, Folders, |
					{
						@%__ID%_%Override_ID%_FN ++
						ID := @%__ID%_%Override_ID%_FN
						@Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
					}
				}
			}
		} Else {
			FoundName := ELP_GetNameFromFI(FileInfo)
			
			If (FoundName = "." Or FoundName = ".."){
				FoundName := ""
				, VarSetCapacity(FileInfo, 0)
				GoTo,ELPLFP_Start
			} Else If (!_IncludeFolders){
				If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			} Else If (_IncludeFolders = 2){
				If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			}
		}
	}
	
	If (FoundName != "")
		Return CurrentPath . FoundName
	Else If (@%__ID%_%Override_ID%_FN){
		ID := @%__ID%_%Override_ID%_FN
		, @%__ID%_%Override_ID%_FN --
		, @%__ID%_%Override_ID%_CurrentFileName := @Folder_%ID%_%Override_ID%
		, VarSetCapacity(@Folder_%ID%_%Override_ID%, 0)
		GoTo,ELPLFP_Start
	} Else {
		If (InStr(Stored_%Override_ID%_Handles, "|" . _FileName . "|")){
			ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
			, @%__ID%_%Override_ID%_CurrentFileName := ""
			, @%__ID%_%Override_ID%_CurrentPath := ""
			, @%__ID%_%Override_ID%_Handle := ""
			, Last_FileName := Last___ID := Last_OverrideID := ""
		}
	}
}

ELP_DeleteFileHandle(ByRef _StoredHandles, _FileName)
{
	P1 := InStr(_StoredHandles, "|" . _FileName . "|")
	
	If (P1){
		P2 := P1 + StrLen(_FileName) + 2
		, New_1 := SubStr(_StoredHandles, 1, P1 - 1)
		, New_2 := SubStr(_StoredHandles, InStr(_StoredHandles, "|", False, P2))
		, _StoredHandles := New_1 . New_2
		
		If (_StoredHandles = "|")
			VarSetCapacity(_StoredHandles, 0)
	}
}

ELP_FindFolders(_FileName, _DoRecurse)
{
	Global Ptr
	
	If (_DoRecurse = 2)
		__FilePath := _FileName
	Else
		__FilePath := SubStr(_FileName, 1, InStr(_FileName, "\", False, 0)) . "*.*"
	
	ELP_ConvertPath(__FilePath)
	, VarSetCapacity(FileInfo, 1140, 0) 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
	, Handle := DllCall("FindFirstFileW", Ptr, &__FilePath, Ptr, &FileInfo)
	
	If (Handle = -1)
		Return
	
	Loop
	{
		FolderName := ELP_GetNameFromFI(FileInfo)
		
		If (FolderName != "." And FolderName != ".."){
			If (ELP_IsDirectoryFromFI(FileInfo))
				AllFolders .= AllFolders ? "|" . FolderName : FolderName
		}
			
		VarSetCapacity(FileInfo, 1140, 0) 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
			ELP_FindClose(Handle)
			
			Return AllFolders
		}
	}
}

ELP_GetNameFromFI(ByRef _FileInfo)
{
	Global Ptr
	Static NameOffset := 44, L_Name := "StrGet"
	
	If (A_IsUnicode)
		Name := %L_Name%(&_FileInfo + NameOffset,-1,"UTF-16")
	Else
		Name := StrGetB(&_FileInfo + NameOffset,-1,"UTF-16")
	
	Return Name
}

StrGetB(Address, Length=-1, Encoding=0)
{
	; Flexible parameter handling:
	if Length is not integer
	Encoding := Length,  Length := -1

	; Check for obvious errors.
	if (Address+0 < 1024)
		return

	; Ensure 'Encoding' contains a numeric identifier.
	if Encoding = UTF-16
		Encoding = 1200
	else if Encoding = UTF-8
		Encoding = 65001
	else if SubStr(Encoding,1,2)="CP"
		Encoding := SubStr(Encoding,3)

	if !Encoding ; "" or 0
	{
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "uint", Address)
		VarSetCapacity(String, Length)
		DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
	}
	else if Encoding = 1200 ; UTF-16
	{
		char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
		VarSetCapacity(String, char_count)
		DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
	}
	else if Encoding is integer
	{
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
		VarSetCapacity(String, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
		String := StrGetB(&String, char_count, 1200)
	}
	
	return String
}

ELP_IsDirectoryFromFI(ByRef _FileInfo)
{
	Static FILE_ATTRIBUTE_DIRECTORY := 0x10
	
	Return NumGet(_FileInfo, 0, "UInt") & FILE_ATTRIBUTE_DIRECTORY
}

ELP_FindClose(_Handle)
{
	Global Ptr
	
	Return DllCall("FindClose", Ptr, _Handle)
}










ELP_SetEndOfFile(_Handle, _Size)
{
	Global Ptr
	
	Old_Pointer := ELP_GetFilePointer(_Handle)
	, ELP_SetFilePointer(_Handle, _Size)
	, ErrorLevel := DllCall("SetEndOfFile", Ptr, _Handle) = 0 ? 1 : 0
	, ELP_SetFilePointer(_Handle, Old_Pointer)
	
	Return ErrorLevel
}

ELP_WOW64FileRedirect(_NewState)
{
	Global Ptr
	Static OldValue, CurrentValue := "Enabled"
	
	If ((_NewState = 0 Or _NewState = "Disable") And CurrentValue != "Disabled"){
		VarSetCapacity(OldValue, 500, 0)
		, E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
		, CurrentValue := "Disable"
	} Else If ((_NewState = 1 Or _NewState = "Enable") And CurrentValue != "Enabled"){
		E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
		, CurrentValue := "Enabled"
	}
	
	Return E
}

ELP_OpenFileHandle(_FileName, _DesiredAccess, ByRef _FileSize = 0)
{
	Global Ptr
	Static GENERIC_ALL := 0x10000000
	, GENERIC_READ = 0x80000000
	, GENERIC_WRITE := 0x40000000
	, GENERIC_EXECUTE  := 0x20000000
	, FILE_SHARE_DISABLE := 0x00000000
	, FILE_SHARE_DELETE := 0x00000004
	, FILE_SHARE_READ := 0x00000001
	, FILE_SHARE_WRITE := 0x00000002
	, FILE_SHARE_READ_WRITE := 0x00000003
	
	ELP_ConvertPath(_FileName)
	
	If (_DesiredAccess = "Read")
		Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_READ, "UInt", FILE_SHARE_READ_WRITE, "UInt", 0, "UInt", 3, "UInt", 0, "UInt", 0)
	Else If (_DesiredAccess = "Write")
		Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_WRITE, "UInt", FILE_SHARE_READ, "UInt", 0, "UInt", 4, "UInt", 0, "UInt", 0)
	
	_FileSize := 0
	If (Handle_ = -1)
		ErrorLevel := 1
	Else {
		DllCall("GetFileSizeEx", Ptr, Handle_, "Int64*", _FileSize)
		, _FileSize := _FileSize = -1 ? 0 : _FileSize
	}
	
	Return Handle_
}

ELP_SetFilePointer(_Handle, _DesiredValue)
{
	Global Ptr
	
	DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", _DesiredValue, "UInt *", P, "Int", 0)
}

ELP_WriteData(ByRef _Handle, _DataAddress, _BytesToWrite, _AttemptV = 1)
{
	Global Ptr
	Static Original_FilePointer, Current_FilePointer
	
	If (_AttemptV)
		Verify_Writes := ELP_MasterSettings("Get", "Verify_Writes")
	
	If (Verify_Writes And _AttemptV)
		Original_FilePointer := ELP_GetFilePointer(_Handle)
	
	DllCall("WriteFile", Ptr, _Handle, Ptr, _DataAddress, "UInt", _BytesToWrite, "UInt", 0, "UInt", 0)
	If (ELP_MasterSettings("Get", "Count_BytesWritten"))
		ELP_StoreBytes("AddWrite", _BytesToWrite)
	
	If (Verify_Writes And _AttemptV){
		Current_FilePointer := ELP_GetFilePointer(_Handle)
		, ELP_VerifyWrite(_Handle, _DataAddress, _BytesToWrite, Original_FilePointer, Current_FilePointer)
	}
}

ELP_ReadData(_Handle, _DataAddress, _BytesToRead, _AttemptV = 1)
{
	Global Ptr
	Static Original_FilePointer, Current_FilePointer
	
	If (_AttemptV)
		ELP_VerifyReads := ELP_MasterSettings("Get", "ELP_VerifyReads")
	
	If (ELP_VerifyReads And _AttemptV)
		Original_FilePointer := ELP_GetFilePointer(_Handle)
	
	DllCall("ReadFile", Ptr, _Handle, Ptr, _DataAddress, "UInt", _BytesToRead, "UInt", 0, "UInt", 0)
	If (ELP_MasterSettings("Get", "Count_BytesRead"))
		ELP_StoreBytes("AddRead", _BytesToRead)
	
	If (ELP_VerifyReads And _AttemptV){
		Current_FilePointer := ELP_GetFilePointer(_Handle)
		, ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, Current_FilePointer)
	}
}

ELP_CloseFileHandle(_Handle)
{
	Global Ptr
	
	DllCall("CloseHandle", Ptr, _Handle)
}

ELP_GetFilePointer(_Handle)
{
	Global Ptr
	Static Current_FilePointer
	
	DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", 0, "Int64*", Current_FilePointer, "Int", 1)
	
	Return Current_FilePointer
}

ELP_VerifyWrite(ByRef _Handle, _DataAddress, _BytesToWrite, Original_FilePointer, Current_FilePointer)
{
	FileName := ELP_GetPathFromHandle(_Handle)
	
	If (FileName = -1)
		Return
	
	VarHash := ELP_CalcMD5(_DataAddress, _BytesToWrite)
	
	, ELP_CloseFileHandle(_Handle)
	
	, H := ELP_OpenFileHandle(FileName, "Read", FileSize)
	, ELP_SetFilePointer(H, Original_FilePointer)
	, VarSetCapacity(TempData, _BytesToWrite, 0)
	
	, ELP_ReadData(H, &TempData, _BytesToWrite, 0)
	, ELP_CloseFileHandle(H)
	, FileHash := ELP_CalcMD5(&TempData, _BytesToWrite)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	, VarSetCapacity(TempData, 0)
	
	, _Handle := ELP_OpenFileHandle(FileName, "Write") ;Open the file back up to it's original state
	, ELP_SetFilePointer(_Handle, Current_FilePointer)
	
	If (VarHash != FileHash)
		ErrorLevel := -100
}

ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, Current_FilePointer)
{
	VarHash := ELP_CalcMD5(_DataAddress, _BytesToRead)
	
	, ELP_SetFilePointer(_Handle, Original_FilePointer)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	
	, ELP_ReadData(_Handle, &TempData, _BytesToRead, 0)
	, FileHash := ELP_CalcMD5(&TempData, _BytesToRead)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	, VarSetCapacity(TempData, 0)
	
	, ELP_SetFilePointer(_Handle, Current_FilePointer)
	
	If (VarHash != FileHash)	
		ErrorLevel := -101
}

ELP_GetPathFromHandle(_Handle)
{
	Global Ptr
	Static CallName
	, Old_OperatingSystems := "WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_2000,WIN_2003,WIN_XP"
	
	If (InStr("," . Old_OperatingSystems . ",", "," . A_OSVersion . ",")) ;Requires Vista/Server 2008 or later
		Return -1
	
	CallName := A_IsUnicode ? "Kernel32.dll\GetFinalPathNameByHandleW" : "Kernel32.dll\GetFinalPathNameByHandleA"
	, PathLength := DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", 0, "UInt", 0)
	, VarSetCapacity(FileName, PathLength * 2, 0)
	, DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", PathLength * 2, "UInt", 0)
	, VarSetCapacity(FileName, -1)
	
	Return FileName
}

ELP_GetPathRoot(_FileName)
{
	If (SubStr(_FileName, 2, 2) = ":\") ;Local file
		I := 3
	Else If (SubStr(_FileName, 1, 9) = "\\?\UNC\\"){ ;Long network path
		P := InStr(_FileName, "\", False, 10) + 2
		If (SubStr(_FileName, P, 2) = "$\") ;Long admin network share
			I := P + 1
		Else ;Long normal network share
			I := InStr(_FileName, "\", False, P + 2)
	} Else If (SubStr(_FileName, 1, 4) = "\\?\") ;Long local path
		I := 7
	Else If (SubStr(_FileName, 1, 2) = "\\") ;Network path
		I := InStr(_FileName, "\", False, InStr(_FileName, "\", False, 3) + 1)
	Else
		Return
	
	Return SubStr(_FileName, 1, I)
}

ELP_FileCreateDirectory(_Directory, _CreateParents = 1)
{
	Global Ptr
	Static ERROR_ALREADY_EXISTS := 183
	
	__Directory := _Directory
	, ELP_ConvertPath(__Directory)
	, E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
	
	If (E Or A_LastError = ERROR_ALREADY_EXISTS) ;Directory already exists != critical error
		ErrorLevel := 0
	Else If (_CreateParents){
		If (SubStr(_Directory, 0) != "\")
			_Directory .= "\"
		
		Part_Length := StrLen(ELP_GetPathRoot(_Directory))
		, I := StrLen(_Directory)
		
		While (Part_Length < I){
			Part_Length := InStr(_Directory, "\", False, Part_Length + 1)
			, __Directory :=  SubStr(_Directory, 1, Part_Length)
			, ELP_ConvertPath(__Directory)
			, E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
		}
		
		If (E Or A_LastError = ERROR_ALREADY_EXISTS)
			ErrorLevel := 0
		Else
			ErrorLevel := 1
	}
	
	Return ErrorLevel
}

ELP_CalcMD5(_VarAddress, _VarSize)
{
	Global Ptr
	Static Hex = "123456789ABCDEF0"
	
	VarSetCapacity(MD5_CTX, 104, 0)
	, DllCall("advapi32\MD5Init", Ptr, &MD5_CTX)
	, DllCall("advapi32\MD5Update", Ptr, &MD5_CTX, Ptr, _VarAddress, "UInt", _VarSize)
	, DllCall("advapi32\MD5Final", Ptr, &MD5_CTX)
	
	Loop,16
		MD5 .= NumGet(MD5_CTX, 87 + A_Index, "UChar")
	;N := NumGet(MD5_CTX, 87 + A_Index, "Char"), MD5 .= SubStr(Hex, N >> 4, 1) . SubStr(Hex, N & 15, 1)
	
	Return MD5
}

ELP_ConvertPath(ByRef _String)
{
	Global Ptr
	
	If (SubStr(_String, 1, 4) != "\\?\"){
		If (SubStr(_String, 1, 2) = "\\")
			String_C := "\\?\UNC\" . SubStr(_String, 3)
		Else
			String_C := "\\?\" . _String
	} Else
		String_C := _String
	
	If (A_IsUnicode){
		_String := String_C
		Return
	} Else {
		CodePage := DllCall("GetACP")
		, Size := DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, 0, "Int", 0)
		, VarSetCapacity(_String, 2 * Size, 0)
		, DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, &_String, "Int", Size)
	}
}

ELP_StoreBytes(_Cmd, _V = 0)
{
	Static BW := 0, BR := 0
	
	If (_Cmd = "AddRead")
		BR += _V
	Else If (_Cmd = "AddWrite")
		BW += _V
	Else If (_Cmd = "GetRead")
		Return BR
	Else If (_Cmd = "GetWrite")
		Return BW
	Else If (_Cmd = "ResetRead")
		BR := 0
	Else If (_Cmd = "ResetWrite")
		BW := 0
}

ELP_MasterSettings(_Cmd, _Value, _NewValue = "")
{
	Static Verify_Writes :=  False
	, Verify_Reads := False
	, Count_BytesWritten := False
	, Count_BytesRead := False
	, Version := 0.94
	
	If (_Cmd = "Get"){
		If (_Value = "Verify_Writes"){
			Return Verify_Writes
		} Else If (_Value = "Verify_Reads"){
			Return Verify_Reads
		} Else If (_Value = "Count_BytesWritten"){
			Return Count_BytesWritten
		} Else If (_Value = "Count_bytesRead"){
			Return Count_bytesRead
		} Else If (_Value = "Version"){
			Return Version
		}
	} Else If (_Cmd = "Set"){
		If (_Value = "Verify_Writes"){
			Verify_Writes := _NewValue
		} Else If (_Value = "Verify_Reads"){
			Verify_Reads := _NewValue
		} Else If (_Value = "Count_BytesWritten"){
			Count_BytesWritten := _NewValue
		} Else If (_Value = "Count_bytesRead"){
			Count_bytesRead := _NewValue
		}
	}
}