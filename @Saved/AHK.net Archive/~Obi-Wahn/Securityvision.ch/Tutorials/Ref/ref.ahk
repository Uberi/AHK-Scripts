
/*
	FUNCTION: Ref()
		Shows or Plays Images, Icons or Sounds from a Resource File
	
	Ref(Type, Resource, ResourceID [, Param1, Param2, Param3, Param4, Param5])
	
	Parameters:
		Type		Choose the Type of the Resource. Can be BITMAP, ICON, WAVE or JPEG
		Resource	Name of the Resourcefile. Tested with .dll and .exe Resource files
					The Resourcefile has to be in %A_WorkingDir% if an absolute path 
					isn't specified.
		ResourceID	The Number of the ID in the Resource
		
		Param1		In Case of BITMAP, ICON and JPEG, Param1 is the Value of the 
					X-Position of the Control
					In Case of WAVE, Param1 defines, if the Wave-Resource should
					be played at startup. If not, execute Ref() with obitted
					Param1. The Return-Value contains the Buffer, which can be launched
					with a DllCall. See Example Section.
		Param2		In Case of BITMAP, ICON and JPEG, Param2 is the Value of the 
					Y-Position of the Control. In Case of WAVE, Param2 has no function
		Param3		In Case of BITMAP, ICON and JPEG, Param3 is the Value of the 
					Width of the Control. In Case of WAVE, Param3 has no function
		Param4		In Case of BITMAP, ICON and JPEG, Param4 is the Value of the 
					Height of the Control. In Case of WAVE, Param4 has no function
		Param5		In Case of BITMAP, ICON and JPEG, Param5 is the Value of the 
					G-Label of the Control. In Case of WAVE, Param5 has no function
	
	CREDITS:
		SKAN:	http://www.autohotkey.com/forum/viewtopic.php?t=9980&p=147202#147202
				http://www.autohotkey.com/forum/viewtopic.php?t=22999
				http://www.autohotkey.com/forum/viewtopic.php?t=27410
		denick:	http://de.autohotkey.com/forum/viewtopic.php?p=31274#31274
		
	EXAMPLES:
		; Example: Show one Bitmap, one Icon and play 5 times the WAVE, when
		; clicked on the Bitmap.
		Gui, Margin, 0, 0
		Ref("BITMAP", A_ScriptName, 1, 0, 0, 500, 90, "Play")
		Ref("ICON", A_ScriptName, 200, 0, 100, 32, 32)
		Gui, Show, Center, Ref-Testgui
		Return

		GuiClose:
		Exitapp

		Play:
		Loop, 5 {
			Ref("WAVE", A_ScriptName, 666, 1)
			Sleep, 1000
		}
		Return
		
		; Example: Load Wave into Buffer, and launch Buffer later with
		; a DllCall.
		Buffer := Ref("WAVE", A_ScriptName", 666)
		; ...
		DllCall("winmm\sndPlaySoundA", UInt, Buffer, UInt, (0x4 | 0x2))
*/

Ref(Type, Resource, ResID, P1="", P2="", P3="", P4="", P5="") {
	global
	local hModule, hBitmap, hResource, hSize, hResData, Buffer, hData, pData
	      , eLvl
	hModule := DllCall("GetModuleHandle", Str, Resource)
	If (Type = "BITMAP") {
		Gui, Add, Picture, x%P1% y%P2% w%P3% h%P4% g%P5% 0xE hWndPic1
		hBitmap   := DllCall("LoadImageA", UInt, hModule, UInt, ResID
		                    , UInt, 0x0, UInt, P3, UInt, P4, UInt, 0x8000)
		SendMessage, 0x172, 0x0, hBitmap, , ahk_id %Pic1%
		Return, %Errorlevel%
	} Else If (Type = "ICON") {
		Gui, Add, Picture, x%P1% y%P2% w%P3% h%P4% g%P5% 0x3 hWndPic1
		hBitmap   := DllCall("LoadImageA", UInt, hModule, UInt, ResID
		                    , UInt, 0x1, UInt, P3, UInt, P4, UInt, 0x8000)
		SendMessage, 0x172, 0x1, hBitmap, , ahk_id %Pic1%
		Return, %Errorlevel%
	} Else If (Type = "WAVE") {
		hResource := DllCall("FindResource", UInt, hModule, UInt, ResID, UInt, 10)
		hSize     := DllCall("SizeOfResource", UInt, hModule, UInt, hResource)
		hResData  := DllCall("LoadResource", UInt, 0, UInt, hResource)
		Buffer    := DllCall("LockResource", UInt, hResData)
		If (P1 = 1) {
			DllCall("winmm\sndPlaySoundA", UInt, Buffer, UInt, (0x4 | 0x2))
			Return, 0
		} Else, Return, Buffer
	} Else If (Type = "JPEG") {
		Gui, Add, Picture, x%P1% y%P2% w%P3% h%P4% g%P5% +0xE hWndPic1
		hResource := DllCall("FindResource", UInt, hModule, UInt, ResID, UInt, 10)
		hSize     := DllCall("SizeOfResource", UInt, hModule, UInt, hResource)
		hResData  := DllCall("LoadResource", UInt, 0, UInt, hResource)
		Buffer    := DllCall("LockResource", UInt, hResData)
		hData     := DllCall("GlobalAlloc", UInt, 2, Uint, hSize)
		pData     := DllCall("GlobalLock", UInt, hData)
		DllCall("RtlMoveMemory", UInt, pData, UInt, Buffer, UInt, hSize)
		DllCall("GlobalUnlock", UInt, hData)
		DllCall("ole32\CreateStreamOnHGlobal", UInt, hData, Int, True, UIntP, pStream)
		DllCall("LoadLibary", Str, "gdiplus")
		VarSetCapacity(si, 16, 0), si := Chr(1)
		DllCall("gdiplus\GdiplusStartup", UIntP, pToken, UInt, &si, UInt, 0)
		DllCall("gdiplus\GdipCreateBitmapFromStream", UInt, pStream, UIntP, pBitmap)
		DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", UInt, pBitmap, UIntP, hBitmap, UInt, 0)
		SendMessage, 0x172, 0x0, hBitmap, , ahk_id %Pic1%
		eLvl := Errorlevel
		DllCall("gdiplus\GdipDisposeImage", UInt, pBitmap)
		DllCall("gdiplus\GdiplusShutdown", UInt, pToken)
		DllCall( NumGet( NumGet( 1*pStream ) +8 ), UInt, pStream)
		Return, eLvl
	}
}
