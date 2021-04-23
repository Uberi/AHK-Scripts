;------------------------------------------------------------------------------
; AutoHotKey script to show or hide Gadgets
; when a keyboard shortcut is pressed.

; Override the shortcut Win+G
; Note: Change it to any shortcut you prefer
#g::

; Check if Gadgets is running
Process, Exist, sidebar.exe

; Gadgets is not running
if ErrorLevel = 0
{
    ; Start Gadgets
    ; Note: Command option to sidebar was discovered using Process Explorer
    Run, "C:\Program Files\Windows Sidebar\sidebar.exe" /stopHidingGadgets
}
; Gadgets is running
else
{
    ; Kill Gadgets
    ; Note: Ideally Gadgets should be hidden, not killed.
    ;       Do not know of command option to achieve that. 
    Process, Close, sidebar.exe
}

return
;------------------------------------------------------------------------------
