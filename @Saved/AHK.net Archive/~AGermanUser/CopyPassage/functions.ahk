Anchor(Control, Anchors="", x=0, y=0, w=0, h=0)
  {  
    ; Thanks to Titan for this function
    ; Details under http://www.autohotkey.com/forum/viewtopic.php?p=26778
    
    ; Control         : Variable assigned to the control (e.g. "MyEdit")
    ; Anchors         : How control to be moved (e.g. "xy" for position or "wh" for size)
    ; x, y, w, h      : respective values of control 
    ;                 (note you can omit values that aren't needed by the Anchors by putting any value)
    
    global GuiW, GuiH
    
    If (not Anchors)
      Anchors = xy
    If Anchors contains x
      GuiControl, Move, % Control, % "x" x+(A_GuiWidth-GuiW)
    If Anchors contains y
      GuiControl, Move, % Control, % "y" y+(A_GuiHeight-GuiH)
    If Anchors contains w
      GuiControl, Move, % Control, % "w" w+(A_GuiWidth-GuiW)
    If Anchors contains h
      GuiControl, Move, % Control, % "h" h+(A_GuiHeight-GuiH)
  }

Menu_AssignBitmap(p_menu, p_item, p_bm_unchecked, p_unchecked_face=false, p_bm_checked=false, p_checked_face=false)
  {
    ; Thanks to shimanov for this function
    ; Details under http://www.autohotkey.com/forum/viewtopic.php?p=44577

   ; p_menu            = "MenuName" (e.g., Tray, etc.)
   ; p_item            = "MenuItemNumber" (e.g. 1, ...)
   ; p_bm_unchecked,
   ; p_bm_checked      = path to bitmap for unchecked 'n' checked menu entry/false
   ; p_unchecked_face,
   ; p_checked_face    = true/false (i.e., true = pixels with same color as 
   ;                                 first pixel are transparent)

    
    static   menu_list, h_menuDummy
    
    If h_menuDummy=
    {
      menu_list = |
    
      ; Save current 'DetectHiddenWindows' mode to reset it later
      Old_DetectHiddenWindows := A_DetectHiddenWindows
      DetectHiddenWindows, on
      
      ; Retrieve scripts PID
      Process, Exist
      pid_this := ErrorLevel
      
      ; Create menuDummy and assign to Gui99
      Menu, menuDummy, Add
      Menu, menuDummy, DeleteAll
      
      Gui, 99:Menu, menuDummy
      
      ; Retrieve menu handle (menuDummy)
      h_menuDummy := DllCall( "GetMenu", "uint", WinExist( "ahk_class AutoHotkeyGUI ahk_pid " pid_this ) )
    
      ; Remove menu bar 'menuDummy'
      Gui, 99:Menu
      
      ; Reset 'DetectHiddenWindows' mode to old setting
      DetectHiddenWindows, %Old_DetectHiddenWindows%
    }
    
    ; Assign p_menu to menuDummy and retrieve menu handle
    If (! InStr(menu_list, "|" p_menu ",", false))
      {
        Menu, menuDummy, Add, :%p_menu%    
        menu_ix := DllCall( "GetMenuItemCount", "uint", h_menuDummy ) - 1
        menu_list = %menu_list%%p_menu%,%menu_ix%|
      }
    Else
      {
        menu_ix := InStr(menu_list, ",", false, InStr( menu_list, "|" p_menu ",", false)) + 1
        StringMid, menu_ix, menu_list, menu_ix, InStr(menu_list, "|", false, menu_ix) - menu_ix
      }
    
    h_menu := DllCall("GetSubMenu", "uint", h_menuDummy, "int", menu_ix)
    
    ; Load bitmap for unchecked menu entries
    If (p_bm_unchecked)
      {
        hbm_unchecked := DllCall( "LoadImage"
                                , "uint", 0
                                , "str", p_bm_unchecked
                                , "uint", 0                             ; IMAGE_BITMAP
                                , "int", 0
                                , "int", 0
                                , "uint", 0x10|(0x20*p_unchecked_face)) ; LR_LOADFROMFILE|LR_LOADTRANSPARENT
        
        If (ErrorLevel or ! hbm_unchecked)
          {
             MsgBox, [Menu_AssignBitmap: LoadImage: unchecked] failed: EL = %ErrorLevel%
             Return, false
          }
      }
    
    ; Load bitmap for checked menu entries
    If (p_bm_checked)
      {
        hbm_checked := DllCall( "LoadImage"
                              , "uint", 0
                              , "str", p_bm_checked
                              , "uint", 0                               ; IMAGE_BITMAP
                              , "int", 0
                              , "int", 0
                              , "uint", 0x10|(0x20*p_checked_face))     ; LR_LOADFROMFILE|LR_LOADTRANSPARENT
      
        If (ErrorLevel or ! hbm_checked)
          {
             MsgBox, [Menu_AssignBitmap: LoadImage: checked] failed: EL = %ErrorLevel%
             Return, false
          }
      }
    
    ; On success assign image to menu entry
    success := DllCall( "SetMenuItemBitmaps"
                      , "uint", h_menu
                      , "uint", p_item-1
                      , "uint", 0x400                                   ; MF_BYPOSITION
                      , "uint", hbm_unchecked
                      , "uint", hbm_checked )
                      
    If (ErrorLevel or ! success)
      {
        MsgBox, [Menu_AssignBitmap: SetMenuItemBitmaps] failed: EL = %ErrorLevel%
        Return, false
      }
    
    Return, true
  }

URLPrefGui(p_w, p_l, p_m, p_hw)
  {
    ; Thanks to shimanov for this function
    ; Details under http://www.autohotkey.com/forum/viewtopic.php?p=37805
    
    ; p_w             : WPARAM value
    ; p_l             : LPARAM value
    ; p_m             : message number
    ; p_hw            : window handle HWND
    
    ; Further details can be found in the documentation for 'OnMessage()'
    
    global   WM_SETCURSOR, WM_MOUSEMOVE
    static   URL_hover, h_cursor_hand, h_old_cursor
    
    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        ; Mouse cursor hovers URL Text control
        If (A_GuiControl = "URL_DocLink")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, URL_DocLink
                
                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
                
                URL_hover := true
              }                 
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        ; Mouse cursor doesn't hover URL Text control
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue
                GuiControl, Font, URL_DocLink
                
                DllCall("SetCursor", "uint", h_old_cursor)
                
                URL_hover=
              }
          }
      }
  }

URLAboutGui(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MOUSEMOVE
    static   URL_hover, h_cursor_hand, h_old_cursor
    
    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        ; Mouse cursor hovers URL Text control
        If (A_GuiControl = "URL_ForumLink")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, URL_ForumLink
                
                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
                
                URL_hover := true
              }                 
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        ; Mouse cursor doesn't hover URL Text control
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue
                GuiControl, Font, URL_ForumLink
                
                DllCall("SetCursor", "uint", h_old_cursor)
                
                URL_hover=
              }
          }
      }
  }
