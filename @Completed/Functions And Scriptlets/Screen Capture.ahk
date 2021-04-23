;AHK v1
#NoEnv

/*
MouseGetPos, PosX, PosY
CaptureScreen(PosX - 100,PosY - 100,200,200,A_Desktop . "\Screenshot.png")
*/

CaptureScreen(PosX,PosY,Width,Height,FileName,CaptureCursor = True)
{
    ;create a memory device context for the bitmap
    hMemoryDC := DllCall("CreateCompatibleDC","UPtr",0,"UPtr")
    If !hMemoryDC
        throw Exception("Could not create memory device context")

    ;set up BITMAPINFOHEADER structure
    VarSetCapacity(BitmapInfoHeader,40)
    NumPut(40,BitmapInfoHeader,0,"UInt") ;biSize
    NumPut(Width,BitmapInfoHeader,4,"UInt") ;biWidth
    NumPut(Height,BitmapInfoHeader,8,"UInt") ;biHeight
    NumPut(1,BitmapInfoHeader,12,"UShort") ;biPlanes
    NumPut(32,BitmapInfoHeader,14,"UShort") ;biBitCount: 32-bit image
    NumPut(0,BitmapInfoHeader,16,"UShort") ;biCompression = BI_RGB
    NumPut(0,BitmapInfoHeader,20,"UInt") ;biSizeImage
    NumPut(0,BitmapInfoHeader,24,"UInt") ;biXPelsPerMeter
    NumPut(0,BitmapInfoHeader,28,"UInt") ;biYPelsPerMeter
    NumPut(0,BitmapInfoHeader,32,"UInt") ;biClrUsed: all colors should be available
    NumPut(0,BitmapInfoHeader,36,"UInt") ;biClrImportant: all colors are required

    ;create bitmap
    hBitmap := DllCall("CreateDIBSection"
        ,"UPtr",hMemoryDC
        ,"UPtr",&BitmapInfoHeader ;attributes of bitmap
        ,"UInt",0 ;DIB_RGB_COLORS
        ,"UInt*",0 ;output pointer to bit values
        ,"UPtr",0 ;have system allocate memory for bitmap
        ,"UInt",0 ;ignored file mapping object offset
        ,"UPtr")
    If !hBitmap
        throw Exception("Could not create bitmap")

    ;select the bitmap into the memory device context
    hOriginalBitmap := DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hBitmap,"UPtr")
    If !hOriginalBitmap
        throw Exception("Could not select bitmap into device context")

    ;obtain screen device context
    hDC := DllCall("GetDC","UPtr",0,"UPtr")
    If !hDC
        throw Exception("Could not obtain screen device context")

    ;copy screen image data to bitmap
    If !DllCall("BitBlt"
        ,"UPtr",hMemoryDC ;destination device context
        ,"Int",0 ;destination x-axis coordinate
        ,"Int",0 ;destination y-axis coordinate
        ,"Int",Width ;region width
        ,"Int",Height ;region height
        ,"UPtr",hDC ;source device context
        ,"Int",PosX ;source x-axis coordinate
        ,"Int",PosY ;source y-axis coordinate
        ,"UInt",0x40CC0020) ;CAPTUREBLT | SRCCOPY
        throw Exception("Could not copy screen image data to bitmap")

    ;release screen device context
    If !DllCall("ReleaseDC","UPtr",0,"UPtr",hDC)
        throw Exception("Could not release device context")

    If CaptureCursor ;cursor should also be captured
    {
        ;obtain cursor information
        Size := 16 + A_PtrSize
        VarSetCapacity(CursorInfo,Size,0)
        NumPut(Size,CursorInfo,0,"UChar")
        If !DllCall("GetCursorInfo","UPtr",&CursorInfo)
            throw Exception("Could not obtain cursor information")
        CursorShown := NumGet(CursorInfo,4,"UInt")
        hCursor := NumGet(CursorInfo,8)
        CursorX := NumGet(CursorInfo,8 + A_PtrSize,"UInt")
        CursorY := NumGet(CursorInfo,12 + A_PtrSize,"UInt")

        ;obtain cursor icon information
        VarSetCapacity(IconInfo,12 + 2 * A_PtrSize,0)
        If !DllCall("GetIconInfo","UInt",hCursor,"UPtr",&IconInfo)
            throw Exception("Could not obtain cursor icon information")
        HotspotX := NumGet(IconInfo,4,"UInt")
        HotspotY := NumGet(IconInfo,8,"UInt")
        hBitmapMask := NumGet(IconInfo,12)
        hBitmapColor := NumGet(IconInfo,12 + A_PtrSize)
        If CursorShown = 1 ;CURSOR_SHOWING
        {
            ;draw cursor on bitmap
            If !DllCall("DrawIcon","UPtr",hMemoryDC,"Int",CursorX - (PosX + HotspotX),"Int",CursorY - (PosY + HotspotY),"UPtr",hCursor)
                throw Exception("Could not add cursor image to bitmap")
        }

        ;clean up icon resources
        If hBitmapMask && !DllCall("DeleteObject","UPtr",hBitmapMask)
            throw Exception("Could not delete icon bitmask")
        If hBitmapColor && !DllCall("DeleteObject","UPtr",hBitmapColor)
            throw Exception("Could not delete icon color bitmap")
    }

    ;clean up resources
    If !DllCall("SelectObject","UPtr",hMemoryDC,"UPtr",hOriginalBitmap,"UPtr")
        throw Exception("Could not deselect bitmap from device context")
    If !DllCall("DeleteDC","UPtr",hMemoryDC)
        throw Exception("Could not delete device context")

    ;start GDI+ library
    hGDIP := DllCall("LoadLibrary","Str","gdiplus","UPtr")
    VarSetCapacity(GDIPStartupInput,16,0)
    NumPut(1,GDIPStartupInput,0,"UChar")
    pToken := 0
    If DllCall("gdiplus\GdiplusStartup","UPtr*",pToken,"UPtr",&GDIPStartupInput,"UPtr",0) != 0 ;Status.Ok
        throw Exception("Could not start GDI+ library")

    ;create GDI+ image
    pImage := 0
    If DllCall("gdiplus\GdipCreateBitmapFromHBITMAP","UPtr",hBitmap,"UPtr",0,"UPtr*",pImage) != 0 ;Status.Ok
        throw Exception("Could not create GDI+ bitmap")

    ;clean up bitmap
    If !DllCall("DeleteObject","UPtr",hBitmap)
        throw Exception("Could not delete bitmap")

    ;obtain ImageCodecInfo object array
    EncodersCount := 0, Size := 0
    If DllCall("gdiplus\GdipGetImageEncodersSize","UInt*",EncodersCount,"UInt*",Size) != 0 ;Status.Ok
        throw Exception("Could not obtain image encoder information")
    VarSetCapacity(ImageCodecInfoArray,Size,0)
    If DllCall("gdiplus\GdipGetImageEncoders","UInt",EncodersCount,"UInt",Size,"UPtr",&ImageCodecInfoArray) != 0 ;Status.Ok
        throw Exception("Could not obtain image encoders")

    ;find the PNG encoder
    pEncoders := &ImageCodecInfoArray
    Found := False
    Loop, %EncodersCount%
    {
        If StrGet(NumGet(pEncoders + 32 + A_PtrSize * 2),"UTF-16") = "PNG" ;FormatDescription
        {
            Found := True
            Break
        }
        pEncoders += 48 + 7 * A_PtrSize
    }
    If !Found ;PNG encoder not found
        throw Exception("Could not find PNG encoder")

    ;save image to file
    If DllCall("gdiplus\GdipSaveImageToFile","UPtr",pImage,"WStr",FileName,"UPtr",pEncoders,"UPtr",0) != 0 ;Status.Ok
        throw Exception("Could not save image to file")

    ;clean up GDI+ resources
    If DllCall("gdiplus\GdipDisposeImage","UPtr",pImage) != 0 ;Status.Ok
        throw Exception("Could not delete GDI+ image")
    DllCall("gdiplus\GdiplusShutdown","UPtr",pToken)
    If !DllCall("FreeLibrary","UPtr",hGDIP)
        throw Exception("Could not free GDI+ library")
}