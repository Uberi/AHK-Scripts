; RemoteKC by Kane Casolari


SetStoreCapslockMode Off ; Send commands will not affect Caps Lock
Mode := 0 ; 1 is keyboard, 2 is mouse, 0 is suspended
Suspend On ; Start suspended
Clicked := 0 ; keeps track of whether or not left mouse key is held down for dragging: 1 is yes, 0 is no
SendMode Play ; Input mode caused some problems when a number key cycled through to its own number


+8:: 
Suspend , permit
Mode++ ; * changes Modes
Keywait, 8
If Mode = 3
Mode:=0
If Mode = 0
{
IfWinExist Magnifier
WinClose ; close magnifier if it's open
Progress, B2 fs24 zh0 WS700 CWC63C25 CTFFFFFF, Suspended, , , Courier New ; show current mode onscreen
SetTimer, RemoveNotice, 3000 ; remove mode notice after 3 seconds
Suspend On ; suspend program
Return
}
If Mode = 1
{
Suspend Off ; make sure program is active
Progress, B2 fs24 zh0 WS700 CW0E4D9A CTFFFFFF, Keyboard Mode, , , Courier New
SetTimer, RemoveNotice, 3000
Return
}
If Mode = 2
{
Suspend Off
Progress, B2 fs24 zh0 WS700 CW0E4D9A CTFFFFFF, Mouse Mode, , , Courier New
SetTimer, RemoveNotice, 3000
Return
}
Return



RemoveNotice:
SetTimer, RemoveNotice, Off
Progress, Off
return



1::
If Mode = 1 ; keyboard mode
CharacterCycle("@/\-_1")
Else If Mode = 2 ; mouse mode
MouseMoveWin7(-10, -10, 0, "R")  ; Move cursor upward and left
Return

2::
If Mode = 1
CharacterCycle("abc2")
Else If Mode = 2
MouseMoveWin7(0, -10, 0, "R")  ; Move cursor upward
Return

3::
If Mode = 1
CharacterCycle("def3")
Else If Mode = 2
MouseMoveWin7(10, -10, 0, "R")  ; Move cursor upward and right
Return

4::
If Mode = 1
CharacterCycle("ghi4")
Else If Mode = 2
MouseMoveWin7(-10, 0, 0, "R")  ; Move cursor to the left
Return

5::
If Mode = 1
CharacterCycle("jkl5")
Else If Mode = 2 ; Left Click
{
SendEvent {Blind}{LButton down}
KeyWait, 5  ; Prevents keyboard auto-repeat from repeating the mouse click.
SendEvent {Blind}{LButton up}
}
Return

6::
If Mode = 1
CharacterCycle("mno6")
Else If Mode = 2
MouseMoveWin7(10, 0, 0, "R")  ; Move cursor to the right
Return

7::
If Mode = 1
CharacterCycle("pqrs7")
Else If Mode = 2
MouseMoveWin7(-10, 10, 0, "R")  ; Move cursor downward and left
Return

8::
If Mode = 1
CharacterCycle("tuv8")
Else If Mode = 2
MouseMoveWin7(0, 10, 0, "R")  ; Move cursor downward
Return

9::
If Mode = 1
CharacterCycle("wxyz9")
Else If Mode = 2
MouseMoveWin7(10, 10, 0, "R")  ; Move cursor downward and right
Return

0::
If Mode = 1
CharacterCycle(" .,':;0")
Else If Mode = 2 ; left-click and hold
{
Clicked := 1-Clicked
If Clicked = 1
SendEvent {Blind}{Click down}
Else
SendEvent {Blind}{Click up}
KeyWait, 0 ; Prevents keyboard auto-repeat from repeating the mouse click.
}
Return


Esc:: ; Clear turns magnifier on and off in keyboard and mouse modes
If Mode <> 0
{
IfWinExist Magnifier
WinClose ; close magnifier if it's open
Else
Run magnify.exe,,Min ; open magnifier if it's closed
}
Return


Up::
If Mode = 2
MouseMoveWin7(0, -10, 0, "R")  ; Move cursor upward
Else
Send {Up}
Return

Right::
If Mode = 2
MouseMoveWin7(10, 0, 0, "R")  ; Move cursor to the right
Else
Send {Right}
Return

Down::
If Mode = 2
MouseMoveWin7(0, 10, 0, "R")  ; Move cursor downward
Else
Send {Down}
Return

Left::
If Mode = 2
MouseMoveWin7(-10, 0, 0, "R")  ; Move cursor to the left
Else
Send {Left}
Return


Browser_Back:: ; Back button is backspace in keyboard mode
If Mode = 1
Send {BS}
Else
Send {Browser_Back}
Return

Enter::  ; Enter => Left-click
If Mode = 2
{
SendEvent {Blind}{LButton down}
KeyWait, Enter ; Prevents keyboard auto-repeat from repeating the mouse click.
SendEvent {Blind}{LButton up}
}
Else
Send {Enter}
Return

+3:: ; #
If Mode = 1
{GetKeyState, Caps, Capslock, T    ; use # as caps lock in keyboard mode
If Caps =  U
SetCapsLockState, On
Else
SetCapsLockState, Off
}
Else If Mode = 2
{
SendEvent {Blind}{RButton down} ;  => Right-click in mouse mode
KeyWait AppsKey  ; Prevents keyboard auto-repeat from repeating the mouse click.
SendEvent {Blind}{RButton up}
}
Return




MouseMoveWin7(x, y, speed, relative) ; Win7 replacement for mouse move
{
    ; Note: Speed is not implemented for this function
    
    if (relative = "R")
    {  
        ; MouseGetPos, xpos, ypos
        VarSetCapacity(MyStruct, 8, 0)
        DllCall("GetCursorPos", UInt, &MyStruct)
        xpos := NumGet(MyStruct, 0)
        ypos := NumGet(MyStruct, 4)        

        DllCall("SetCursorPos", int, xpos+x, int, ypos+y)
    }
    Else 
    {
        DllCall("SetCursorPos", int, x, int, y)
    }
}
Return



CharacterCycle(list) ; cycles through characters
{
   Static i
   If (A_ThisHotKey = A_PriorHotKey and A_TimeSincePriorHotkey < 1000) ; if you press the same key within 1 sec, cycle through characters
   {
      Send {BS}      ; erases the last character put in
      i++            ; selects the next character
   }
   Else i = 1        ; if you press a new key, select the first character
   If (i > StrLen(list))
      i = 1          ; wrap around at the end of list
   StringMid c, list, i, 1
   Send %c%          ; sends the selected character
}

Return