#NoEnv

hDC := DllCall("GetDC","UPtr",0,"UPtr")
If !hDC
    throw Exception("Could not retrieve device context.")

PhysicalWidth := DllCall("GetDeviceCaps","UPtr",hDC,"Int",4) ;HORZSIZE
PhysicalHeight := DllCall("GetDeviceCaps","UPtr",hDC,"Int",6) ;VERTSIZE

Width := DllCall("GetDeviceCaps","UPtr",hDC,"Int",8) ;HORZRES
Height := DllCall("GetDeviceCaps","UPtr",hDC,"Int",10) ;VERTRES

PixelsPerInchX := DllCall("GetDeviceCaps","UPtr",hDC,"Int",88) ;LOGPIXELSX
PixelsPerInchY := DllCall("GetDeviceCaps","UPtr",hDC,"Int",90) ;LOGPIXELSY

If !DllCall("ReleaseDC","UPtr",0,"UPtr",hDC,"UPtr")
    throw Exception("Could not release device context.")

MsgBox, The monitor dimensions are %PhysicalWidth% millimeters by %PhysicalHeight% millimeters (%Width% pixels by %Height% pixels).`n`nThe pixel density is %PixelsPerInchX% pixels by %PixelsPerInchY% pixels per square inch.