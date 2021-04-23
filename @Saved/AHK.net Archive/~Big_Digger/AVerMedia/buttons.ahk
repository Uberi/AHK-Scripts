; Example showing how to configure buttons to control Windows Media Center

ProgressOff:
Progress, Off
Return

Power:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, !{F4} ; Close Windows Media Center
Else, SendInput, #!{Enter} ; Open Windows Media Center
Return

TV:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK54} ; Go to live TV
Return

CD:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^+{VK4D} ; Go to the DVD menu
Return

Teletext:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK47} ; Go to the Guide
Return

Video:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK45} ; Go to Videos
Return

Audio:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK4D} ; Go to Music
Return

FullScreen:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, !{Enter} ; Go in and go out of windowed mode
Return

Preview:
Return

ChannelLoop:
Progress, b2 zh0 fs28 ws700, % (Numeric := Numeric = 1 ? 0 : 1) = 1 ? "Numeric Keys" : "Arrow Keys"
SetTimer, ProgressOff, -1000
Return

Display:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK44} ; Display the context menu
Return

Autoscan:
Return

Capture:
Return

Mute:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, {F8} ; Mute volume
Return

Record:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK52} ; Record
Return

TimeShift:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK50} ; Pause or resume
Return

Stop:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^+{VK53} ; Stop
Return

Play:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^+{VK50} ; Play
Return

Red:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^+{VK42} ; Rewind
Return

Green:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK42} ; Skip back
Return

Yellow:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^+{VK46} ; Fast forward
Return

Blue:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, ^{VK46} ; Skip forward
Return

VolumeDown:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, {F9} ; Turn down volume
Return

VolumeUp:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, {F10} ; Turn up volume
Return

ChannelDown:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, {PgDn} ; Go to the previous channel/page
Return

ChannelUp:
IfWinActive, ahk_class eHome Render Window, , , , SendInput, {PgUp} ; Go to the next channel/page
Return

Channel0:
Channel1:
Channel2:
Channel3:
Channel4:
Channel5:
Channel6:
Channel7:
Channel8:
Channel9:
IfEqual, Numeric, 1, SendInput, % SubStr(A_ThisLabel, 0)
Else IfEqual, A_ThisLabel, Channel0, SendInput, {Backspace} ; Go back to the previous screen
Else IfEqual, A_ThisLabel, Channel1, SendInput, {Home} ; Go to the first item in a list
Else IfEqual, A_ThisLabel, Channel2, SendInput, {Up} ; Move up
Else IfEqual, A_ThisLabel, Channel3, SendInput, {PgUp} ; Go to the next channel/page
Else IfEqual, A_ThisLabel, Channel4, SendInput, {Left} ; Move left
Else IfEqual, A_ThisLabel, Channel5, SendInput, {Enter} ; Accept the selection
Else IfEqual, A_ThisLabel, Channel6, SendInput, {Right} ; Move right
Else IfEqual, A_ThisLabel, Channel7, SendInput, {End} ; Go to the last item in a list
Else IfEqual, A_ThisLabel, Channel8, SendInput, {Down} ; Move down
Else IfEqual, A_ThisLabel, Channel9, SendInput, {PgDn} ; Go to the previous channel/page
Return
