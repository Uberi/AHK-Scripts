;SETTINGS
snap_prox = 15 ;in px
reaction_speed = 100 ;in ms
;Window snapper code
SysGet, screen, MonitorWorkArea
Loop
{
WinGetActiveStats, title_act, w_act, h_act, x_act, y_act ;active window title and dimensions
If (w_act < screenright-snap_prox)
{
If (x_act > screenleft-snap_prox AND x_act < screenleft OR x_act < screenleft+snap_prox AND x_act > screenleft)
   WinMove, %title_act%,, screenLeft
If (x_act + w_act > screenright-snap_prox AND x_act + w_act < screenright OR x_act + w_act < screenright+snap_prox AND x_act + w_act > screenright)
   WinMove, %title_act%,, (screenright-w_act)
}
If (h_act < screenbottom-snap_prox)
{
If (y_act > screentop-snap_prox AND y_act < screentop OR y_act < screentop+snap_prox AND y_act > screentop)
   WinMove, %title_act%,,, screentop
If (y_act + h_act > screenbottom-snap_prox AND y_act + h_act  < screenbottom OR y_act + h_act < screenbottom+snap_prox AND y_act + h_act > screenbottom)
   WinMove, %title_act%,,, (screenbottom-h_act)
}
Sleep, %reaction_speed%
} 