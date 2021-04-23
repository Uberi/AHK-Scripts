#Include GDIplusWrapper.ahk

OnExit, handle_Exit

main:
  Menu, Tray, Tip, ScreenShooter`nWin+Z - Thumb`nWin+C - Full`nWin+V - Frame`nWin+X - Close
  FileCreateDir, Screens
  FileCreateDir, Thumbs
  FileCreateDir, Frames
  noParams = NONE

  SetFormat, Float, 02.0
  Counter:=0.0	; thumbnails
  Counter_f:=0.0 ; fullScreens
  Counter_w:=0.0 ; fullScreens
  thumb_w:= 200 ; thumbs width
  thumb_h:= Ceil( thumb_w * A_ScreenHeight / A_ScreenWidth ) ; keep Screenratio
  use_antialize := 1 ; 0 for speed, 1 for quality in thumbnails

  WinGet, hw_frame, id, "Program Manager"   ; Desktop ?
  hdc_frame := DllCall( "GetDC", "uint",  hw_frame )
  hdc_buffer := DllCall( "gdi32.dll\CreateCompatibleDC"     , "uint", hdc_frame )
  hbm_buffer := DllCall( "gdi32.dll\CreateCompatibleBitmap" , "uint", hdc_frame, "int", thumb_w, "int", thumb_h )
  r          := DllCall( "gdi32.dll\SelectObject"           , "uint", hdc_buffer, "uint", hbm_buffer )

  If use_antialize = 1
    DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_buffer, "int", 4 )  ; Halftone better quality with stretch

Return


#z::
  Counter++
  FormatTime, myTime, , dd-MMM-yyyy_HH'h'mm'm'ss's'
  fileNameDest = Thumbs\T_%myTime%_%Counter%.png

  If (GDIplus_Start() != 0)
    Goto GDIplusError

  DllCall( "gdi32.dll\StretchBlt"
          , "uint", hdc_buffer, "int", 0, "int", 0, "int", thumb_w, "int", thumb_h
          , "uint", hdc_frame,  "int", 0, "int", 0, "int", A_ScreenWidth, "int", A_ScreenHeight, "uint", 0x00CC0020 )

  DllCall( "GDIplus\GdipCreateBitmapFromHBITMAP", uint, hbm_buffer, uint, 0, uintp, bitmap )

  If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_png) != 0)
    Goto GDIplusError

  If (GDIplus_SaveImage(bitmap, fileNameDest, pngEncoder, noParams) != 0)
    Goto GDIplusError

  Goto GDIpluSend
Return



#c::
  Counter_f++
  FormatTime, myTime, , dd-MMM-yyyy_HH'h'mm'm'ss's'
  fileNameDest = Screens\S_%myTime%_%Counter_f%.png

  If (GDIplus_Start() != 0)
    Goto GDIplusError

  If (GDIplus_CaptureScreenRectangle(bitmap) != 0)
    Goto GDIplusError

  If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_png) != 0)
    Goto GDIplusError

  If (GDIplus_SaveImage(bitmap, fileNameDest, pngEncoder, noParams) != 0)
    Goto GDIplusError

  Goto GDIpluSend
Return



#v::
  Counter_w++
  FormatTime, myTime, , dd-MMM-yyyy_HH'h'mm'm'ss's'
  WinGetActiveStats, myTitle, myW, myH, myX, myY
  WinGet, pname, ProcessName, A
  fileNameDest = Frames\W_%pname%_%myTime%_%Counter_w%.png

  If (GDIplus_Start() != 0)
    Goto GDIplusError

  If (GDIplus_CaptureScreenRectangle(bitmap, myX, myY, myW, myH) != 0)
    Goto GDIplusError

  If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_png) != 0)
    Goto GDIplusError

  If (GDIplus_SaveImage(bitmap, fileNameDest, pngEncoder, noParams) != 0)
    Goto GDIplusError

  Goto GDIpluSend

Return


GDIplusError:
  If (#GDIplus_lastError != "")
    MsgBox 16, GDIplus Test, Error in %#GDIplus_lastError% (at %step%)

GDIplusEnd:
  GDIplus_FreeImage(bitmap)
  GDIplus_Stop()
Return


#x::
handle_exit:
  Gosub GDIplusEnd
  ExitApp
Return