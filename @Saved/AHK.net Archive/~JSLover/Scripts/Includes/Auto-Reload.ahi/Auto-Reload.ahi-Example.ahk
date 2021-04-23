;//override default reload options here...
;//Reload_Notify_disable=1
;//Reload_Notify_type=Tooltip
;//Reload_Notify_title=OVERRIDE Reloading...
;//Reload_Notify_msg=OVERRIDE %A_ScriptName%
;//Reload_Notify_ms=1019
;//Reload_Notify_options=2

Gosub, Include-Auto-Reload.ahi
msgbox, test
return

Include-Auto-Reload.ahi:
#Include Auto-Reload.ahi
return