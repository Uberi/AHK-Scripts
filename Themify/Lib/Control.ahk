class Control
{
    __New(hControl)
    {
        this.hControl := hControl
        this.hWindow := DllCall("GetParent","UPtr",hControl,"UPtr")
        If this.hWindow = 0
            throw Exception("Could not obtain parent window.")

        ;subclass control
        this.pControlCallback := RegisterCallback(this.ControlCallback,"Fast",6)
        If !this.pControlCallback
            throw Exception("Could not create control subclass callback.")
        If !DllCall("Comctl32\SetWindowSubclass"
            ,"UPtr",this.hControl ;window handle
            ,"UPtr",this.pControlCallback ;callback pointer
            ,"UPtr",123456 ;subclass ID
            ,"UPtr",&this) ;arbitrary data to pass to this particular subclass callback and ID
            throw Exception("Could not subclass control.")

        ;subclass window
        this.pWindowCallback := RegisterCallback(this.WindowCallback,"Fast",6)
        If !this.pWindowCallback
            throw Exception("Could not create window subclass callback.")
        If !DllCall("Comctl32\SetWindowSubclass"
            ,"UPtr",this.hWindow ;window handle
            ,"UPtr",this.pWindowCallback ;callback pointer
            ,"UPtr",123456 ;subclass ID
            ,"UPtr",&this) ;arbitrary data to pass to this particular subclass callback and ID
            throw Exception("Could not subclass window.")
    }

    __Delete()
    {
        ;remove window subclass
        If !DllCall("Comctl32\RemoveWindowSubclass","UPtr",this.hWindow,"UPtr",this.pWindowCallback,"UPtr",123456)
            throw Exception("Could not remove subclass from window.")
        If DllCall("GlobalFree","UPtr",this.pWindowCallback,"UPtr")
            throw Exception("Could not free window subclass callback.")

        ;remove control subclass
        If !DllCall("Comctl32\RemoveWindowSubclass","UPtr",this.hControl,"UPtr",this.pControlCallback,"UPtr",123456)
            throw Exception("Could not remove subclass from control.")
        If DllCall("GlobalFree","UPtr",this.pControlCallback,"UPtr")
            throw Exception("Could not free control subclass callback.")
    }

    ControlCallback(Message,wParam,lParam,SubclassID,Data)
    {
        hWindow := this
        this := Object(Data)

        Value := this.ControlMessage(hWindow,Message,wParam,lParam)
        If (Value != "")
            Return, Value

        Return, DllCall("Comctl32\DefSubclassProc","UPtr",hWindow,"UInt",Message,"UPtr",wParam,"UPtr",lParam,"UPtr") ;call the next handler in the window's subclass chain
    }

    WindowCallback(Message,wParam,lParam,SubclassID,Data)
    {
        hWindow := this
        this := Object(Data)

        Value := this.WindowMessage(hWindow,Message,wParam,lParam)
        If (Value != "")
            Return, Value

        Return, DllCall("Comctl32\DefSubclassProc","UPtr",hWindow,"UInt",Message,"UPtr",wParam,"UPtr",lParam,"UPtr") ;call the next handler in the window's subclass chain
    }
}