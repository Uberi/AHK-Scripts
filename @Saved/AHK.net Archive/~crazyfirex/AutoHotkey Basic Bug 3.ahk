;! AutoHotkey Basic
#Persistent
SetTimer, Label, -0
return

Label:
 MsgBox This should run exactly once.
return


;! AutoHotkey_L
#Persistent
SetTimer, Label, -0
return

Label:
 MsgBox This is run exactly once.
return