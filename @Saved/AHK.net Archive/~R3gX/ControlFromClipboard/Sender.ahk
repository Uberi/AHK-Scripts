+F1::	; Send a message
TrayTip, Sender : Sample 1, A message should be displayed!`n(This is a message sample!)
SetTimer, RemoveTips, 5000
Clipboard := "Receiver.ahk This is a message sample!"
Return

+F2::	; Set dynamically a variable
TrayTip, Sender : Sample 2, Look at the Receiver.ahk tray icon! [S] or [H]
SetTimer, RemoveTips, 5000
Clipboard := "Receiver.ahk suspend_script <= 1"
Return

+F3::	; Normal use of the clipboard
TrayTip, Sender : Sample 3, Normal use of the clibpoard!
SetTimer, RemoveTips, 5000
Clipboard := "It won't be used by ControlFromClipboard() !!!"
Return

+F4::	; Stop the two scripts
TrayTip, Sender : Sample 4, Both Sender.ahk & Receiver.ahk`nshould be stopped in 7 seconds!, 30
Sleep, 7000
Clipboard := "Receiver.ahk exit_script <= 1"
ExitApp
Return

RemoveTips:
Traytip
ToolTip
Return