#Include GDIplusWrapper.ahk

fileNameOrig = OriginalImage.bmp
fileNameDestJ = ResultImage.jpg
fileNameDestP = ResultImage.png
fileNameDestT = ResultImage.tif

noParams = NONE

step = GDIplus_Start
If (GDIplus_Start() != 0)
	Goto GDIplusError

;~ Goto TestClipboard	; Uncomment to test the clipboard capture
;~ Goto TestScreenshot	; Uncomment to test the screenshot
; If both are commented, we just test image conversion...
; I know, it is primitive, but enough for my tests...

; Load image

step = GDIplus_LoadBitmap
If (GDIplus_LoadBitmap(bitmap, fileNameOrig) != 0)
	Goto GDIplusError
GDIplus_GetImageDimension(bitmap, w, h)
MsgBox %w% %h%

; Save to JPeg

step = GDIplus_GetEncoderCLSID for JPG
If (GDIplus_GetEncoderCLSID(jpgEncoder, #GDIplus_mimeType_JPG) != 0)
	Goto GDIplusError

GDIplus_InitEncoderParameters(jpegEncoderParams, 1)
jpegQuality = 3	; Warning! Low quality to show off artifacts, you can go up to 100...
step = GDIplus_AddEncoderParameter for JPG
If (GDIplus_AddEncoderParameter(jpegEncoderParams, #EncoderQuality, jpegQuality) != 0)
	Goto GDIplusError

step = GDIplus_SaveImage for JPG
If (GDIplus_SaveImage(bitmap, fileNameDestJ, jpgEncoder, jpegEncoderParams) != 0)
	Goto GDIplusError

; Save to PNG

step = GDIplus_GetEncoderCLSID for PNG
If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_PNG) != 0)
	Goto GDIplusError

step = GDIplus_SaveImage for PNG
If (GDIplus_SaveImage(bitmap, fileNameDestP, pngEncoder, noParams) != 0)
	Goto GDIplusError

; Save to TIF

step = GDIplus_GetEncoderCLSID for TIF
If (GDIplus_GetEncoderCLSID(tiffEncoder, #GDIplus_mimeType_TIF) != 0)
	Goto GDIplusError

GDIplus_InitEncoderParameters(tiffEncoderParams, 2)
; For some reason, values 1, 4, 8 which are supposed to be legal, are rejected with Win32Error
; Perhaps it doesn't do conversion, so it accepts only values legal for the current file.
tiffColorDepth := 24
tiffColorDepth := 32
step = GDIplus_AddEncoderParameter for TIF (color depth)
If (GDIplus_AddEncoderParameter(tiffEncoderParams, #EncoderColorDepth, tiffColorDepth) != 0)
	Goto GDIplusError

tiffCompression := #EncoderValueCompressionNone
tiffCompression := #EncoderValueCompressionRle	; Not accepted with TIFF 32
tiffCompression := #EncoderValueCompressionLZW
step = GDIplus_AddEncoderParameter for TIF (compression)
If (GDIplus_AddEncoderParameter(tiffEncoderParams, #EncoderCompression, tiffCompression) != 0)
	Goto GDIplusError
;~ MsgBox % DumpDWORDs(tiffEncoderParams, 4 + 2 * #sizeOfEncoderParameter)

step = GDIplus_SaveImage for TIF
If (GDIplus_SaveImage(bitmap, fileNameDestT, tiffEncoder, tiffEncoderParams) != 0)
	Goto GDIplusError

GDIplus_DisposeImage(bitmap)

Goto GDIplusEnd


TestClipboard:

; Load image

step = GDIplus_LoadBitmapFromClipboard
If (GDIplus_LoadBitmapFromClipboard(bitmap) != 0)
   Goto GDIplusError

; Save to PNG

step = GDIplus_GetEncoderCLSID for clipboard
If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_PNG) != 0)
   Goto GDIplusError

step = GDIplus_SaveImage for clipboard
If (GDIplus_SaveImage(bitmap, fileNameDestP, pngEncoder, noParams) != 0)
   Goto GDIplusError

GDIplus_DisposeImage(bitmap)

Goto GDIplusEnd


TestScreenshot:

fileName = ScreenCapture.png
test = TopLeft
;~ test = SysTray
;~ test = Window
;~ test = WholeWindow
;~ test = WholeScreen

If test = TopLeft
{
	If (GDIplus_CaptureScreenRectangle(bitmap, 0, 0, 32, 32) != 0)
		Goto GDIplusError
}
Else If test = SysTray
{
	If (GDIplus_CaptureScreenRectangle(bitmap, 1200, 1000, 80, 24) != 0)
		Goto GDIplusError
}
Else If test = Window
{
	WinGet hwnd, ID, AutoHotkey Help
	If (GDIplus_CaptureScreenRectangle(bitmap, 270, 55, 300, 32, hwnd) != 0)
		Goto GDIplusError
}
Else If test = WholeWindow
{
	WinGet hwnd, ID, AutoHotkey Help
	If (GDIplus_CaptureScreenRectangle(bitmap, 0, 0, 32, 32, hwnd, true) != 0)
		Goto GDIplusError
}
Else If test = WholeScreen
{
	If (GDIplus_CaptureScreenRectangle(bitmap) != 0)
		Goto GDIplusError
}

; Save to PNG

step = GDIplus_GetEncoderCLSID for PNG (screenshot)
If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_PNG) != 0)
   Goto GDIplusError

step = GDIplus_SaveImage for PNG (screenshot)
If (GDIplus_SaveImage(bitmap, fileNameDestP, pngEncoder, noParams) != 0)
   Goto GDIplusError

GDIplus_DisposeImage(bitmap)

Goto GDIplusEnd



GDIplusError:
	If (#GDIplus_lastError != "")
		MsgBox 16, GDIplus Test, Error in %#GDIplus_lastError% (at %step%)
GDIplusEnd:
	GDIplus_Stop()

Return
