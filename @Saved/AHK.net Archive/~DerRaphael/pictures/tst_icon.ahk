#Persistent
  Menu, Tray, Icon, neoAHK_m2_tstAll_16x16x4.icl,1
  Menu, Tray, NoStandard

  Menu, Tray, Add, &Open, NoGo
  Menu, Tray, Default, &Open

  Menu, Tray, Add, &Help, NoGo
  Menu, Tray, Add
  Menu, Tray, Add, Window Spy, NoGo
  Menu, Tray, Add, Reload This Script, GoReload
  Menu, Tray, Add, Edit This Script, GoEdit
  Menu, Tray, Add
  Menu, Tray, Add, &Suspend Hotkeys, Suspend
  Menu, Tray, Add, &Pause Script, Pause
  Menu, Tray, Add, &Exit, AppExit
Return

GoReload:
  reload
GoEdit:
  Edit
NoGo:
  Return

Pause:
  if (!s)
  {
    Menu, Tray, Icon, neoAHK_m2_tstAll_16x16x4.icl, % (p:=!p) ? 3:1, 1
    Menu, Tray, ToggleCheck, &Pause Script
  }
return

Suspend:
  s := !s
  Menu, Tray, Icon, neoAHK_m2_tstAll_16x16x4.icl
      , % ((p)&&(s))? 4:(((!p)&&(s))? 2:(((!p)&&(!s))? 1:3)), 1
  Menu, Tray, ToggleCheck, &Suspend Hotkeys
return

AppExit:
  ExitApp