#NoEnv

Gui, +LastFound +Resize
hWindow := WinExist()
Gosub, Subclass
Gui, Show, w200 h200
Sleep, 1000000
Return

/*
Gui, Add, Text, hwndhControl, Here is some text that is given`na custom background color.
Gui, +LastFound
hWindow := WinExist()

Color := 0x0000FF
hBrush := DllCall("CreateSolidBrush","UInt",Color,"UPtr")

Gosub, Subclass

Gui, Show
Return
*/

GuiClose:
Gosub, RemoveSubclass
ExitApp

;/* ;Comctl32 subclassing method
Subclass:
SubclassID := 123456 ;an arbitrary number that uniquely identifies a particular subclass when paired with a particular subclass callback
pCallback := RegisterCallback("SubclassProc","Fast",6,hControl)
If !pCallback
    throw Exception("Could not create subclass callback.")
If !DllCall("Comctl32\SetWindowSubclass"
    ,"UPtr",hWindow ;window handle
    ,"UPtr",pCallback ;callback pointer
    ,"UPtr",SubclassID ;subclass ID
    ,"UPtr",Color) ;arbitrary data to pass to this particular subclass callback and ID
    throw Exception("Could not subclass window.")
Return

SubclassProc(hWindow,Message,wParam,lParam,SubclassID,Data)
{
    global hBrush
    If Message = 0x138 ;WM_CTLCOLORSTATIC
    {
        DllCall("SetBkColor","UPtr",wParam,"UInt",Data) ;set the background color
        Return, hBrush ;return the colored brush
    }
    Return, DllCall("Comctl32\DefSubclassProc","UPtr",hWindow,"UInt",Message,"UPtr",wParam,"UPtr",lParam,"UPtr") ;call the next handler in the window's subclass chain
}

RemoveSubclass:
If !DllCall("Comctl32\RemoveWindowSubclass","UPtr",hWindow,"UPtr",pCallback,"UPtr",SubclassID)
    throw Exception("Could not remove subclass from window.")
If DllCall("GlobalFree","UPtr",pCallback,"UPtr")
    throw Exception("Could not free subclass callback.")
Return
*/

/* ;original subclassing method
Subclass:
Color := 0x0000FF
hBrush := DllCall("CreateSolidBrush","UInt",Color,"UPtr")

pCallback := RegisterCallback("WindowProc","Fast",4,hControl)
If !pCallback
    throw Exception("Could not create subclass callback.")
hPreviousCallback := DllCall("SetWindowLong" . ((A_PtrSize != 4) ? "Ptr" : "")
    ,"UPtr",hWindow ;window handle
    ,"Int",-4 ;GWL_WNDPROC
    ,"UPtr",pCallback ;callback pointer
    ,"UPtr")
If !hPreviousCallback
    throw Exception("Could not subclass window.")
Return

WindowProc(hWindow,Message,wParam,lParam)
{
    Critical
    global Color, hBrush, hPreviousCallback
    If Message = 0x138 ;WM_CTLCOLORSTATIC
    {
        DllCall("SetBkColor","UPtr",wParam,"UInt",Color) ;set the background color
        Return, hBrush ;return the colored brush
    }
    Return, DllCall("CallWindowProc","UPtr",hPreviousCallback,"UPtr",hWindow,"UInt",Message,"UInt",wParam,"UInt",lParam,"UPtr") ;call the original message handler
}

RemoveSubclass:
If !DllCall("SetWindowLong" . ((A_PtrSize != 4) ? "Ptr" : "")
    ,"UPtr",hWindow ;window handle
    ,"Int",-4 ;GWL_WNDPROC
    ,"UPtr",hPreviousCallback ;original callback pointer
    ,"UPtr")
    throw Exception("Could remove subclass from window.")
Return
*/