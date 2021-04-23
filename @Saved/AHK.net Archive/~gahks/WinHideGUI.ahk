/*
WinHide GUI v1.1
Autohotkey  v1.0.48.00
http://autohotkey.net/~gahks
2009
*/
#SingleInstance, Force
#NoEnv
;SetBatchLines, -1
;//Vars
hotkey_showgui = ~LWin & WheelUp ;Hotkey for showing the list of hidden windows
hotkey_hidegui = ~LWin & WheelDown ;Hotkey for hiding the list of hidden windows
hotkey_win_hide = ~LWin & RButton ;Hotkey for hiding a window
hotkey_win_unhideall = ~LWin & MButton ;Hotkey for unhiding all previously hidden windows
hotkey_win_unhide_last = ~LWin & 0 ;Hotkey for unhiding last hidden window in the list
hotkey_win_unhide_first = ~LWin & 1 ;Hotkey for unhiding the first hidden window in the list
timwait_autohide = 1000 ;Time to wait before hiding the gui when it loses focus - in ms
;//Autoexecute
Menu, Tray, NoStandard
Menu, Tray, add, &List Hidden Windows, ListHW
Menu, Tray, Default, &List Hidden Windows
Menu, Tray, Click, 1
Menu, Tray, add, Unhide &All Hidden Windows, UnHideHW 
Menu, Tray, Add,
Menu, Tray, Add, &Reload, Reload
Menu, Tray, Add, E&xit, Exit
Menu, CMenu, Add, &Unhide selected, UnHideHWSpec
Menu, CMenu, Default, &Unhide selected
Menu, CMenu, Add, Unhide &all, UnHideHW
Menu, CMenu, Add,
Menu, CMenu, Add, E&xit, Exit

w_lv := A_ScreenWidth/3
gui, font, s13, Arial 
Gui, +ToolWindow +AlwaysOnTop
Gui, Add, Listview, gListview  x0 -Hdr w%w_lv% r10, Name|Title|ID
Gui, Show, w%w_lv%, Hidden windows
WinGet, gui_id, id, A ;Get gui window id for autohiding
WinGet, gui_id_check, id, Hidden windows ahk_class AutoHotkeyGUI
Gui, Hide
If gui_id <> %gui_id_check% ;Make sure to get the right window id for the gui
  gui_id := gui_id_check
gui_id_check =
IconList := IL_Create(10,5)
IL_Add(IconList, "shell32.dll", 3) ;Icon of executables on XP
LV_SetImageList(IconList)

SetTimer, AutoHide, %timwait_autohide% ;Hide gui autmatically when user clicks somewhere outside the gui

;Hotkey init
Hotkey, %hotkey_showgui%, ListHW
Hotkey, %hotkey_hidegui%, HideListHW
Hotkey, %hotkey_win_hide%, Win_Hide
Hotkey, %hotkey_win_unhideall%, UnHideHW
Hotkey, %hotkey_win_unhide_last%, UnHideHW_Last
Hotkey, %hotkey_win_unhide_first%, UnHideHW_First

;//Subroutines, hotkeys
Listview:
If a_guievent = DoubleClick ;Hidden windows can be restored by clicking twice on the window's icon in the hidden windows' list
{
	LV_GetText(id_a, A_EventInfo, 3)
	WinShow, ahk_id %id_a%
	Lv_Delete(A_EventInfo)
    id_a =
}
total_hw := LV_GetCount()
Gui, Show, Hide Autosize, Hidden windows (%total_hw%)
return

GuiContextMenu:
  Menu, CMenu, Show, %a_guix%, %a_guiy%
return

Win_Hide:
If (InStr(hotkey_win_hide, "MButton") <> 0 OR InStr(hotkey_win_hide, "LButton") <> 0 OR InStr(hotkey_win_hide, "RButton") <> 0)
{
  If GetMouseTaskButton(hwnd) && hwnd
    id_a := hwnd
  Else
    MouseGetPos,,,id_a
}   
Else
  WinGet, id_a, id, A
WinGetTitle, title_a, ahk_id %id_a%
WinGet, pname_a, ProcessName, ahk_id %id_a%
;Filters
If id_a = %gui_id%
  return ;keep the script from hiding itself
If pname_a = crss.exe
  return 
If title_a = Program Manager
  return
If (pname_a = "explorer.exe" && (title_a = "" OR title_a = "Start Menu"))
  return ;desktop, taskbar, etc.
;//////////////////////////
; (edited) code from Alt+Tab replacement 
; http://www.autohotkey.com/forum/viewtopic.php?t=6422
;//////////////////////////
WS_DISABLED =0x8000000
WinGet, Style, Style, ahk_id %id_a%
If ((Style & WS_DISABLED) or ! (title_a)) ; skip unimportant windows ; ! title_a or 
    return
;get icon of the window being hidden
SendMessage, 0x7F, 1, 0,, ahk_id %id_a%
h_icon := ErrorLevel
If ( ! h_icon )
{
  SendMessage, 0x7F, 2, 0,, ahk_id %id_a%
  h_icon := ErrorLevel
    If ( ! h_icon )
    {
      SendMessage, 0x7F, 0, 0,, ahk_id %id_a%
      h_icon := ErrorLevel
        If ( ! h_icon )
        {
          h_icon := DllCall( "GetClassLong", "uint", id_a, "int", -34 ) ; GCL_HICONSM is -34
          If ( ! h_icon )
            h_icon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 ) ; IDI_APPLICATION is 32512
        }
    }
}
If ! ( h_icon = "" or h_icon = "FAIL") ; Add the HICON directly to the icon list
{
  	Gui_Icon_Number := DllCall("ImageList_ReplaceIcon", UInt, IconList, Int, -1, UInt, h_icon)
	Gui_Icon_Number ++
	LV_Add("Icon" . Gui_Icon_Number, pname_a, title_a, id_a)
}
Else
{
  LV_Add("Icon1", pname_a, title_a, id_a) ;if no icon found, set icon to the icon of executables
}   
;//////////////////////////
; end of code from Alt+Tab replacement
;//////////////////////////
LV_ModifyCol()
LV_ModifyCol(3, 0) ;not a very elegant solution... oh well
WinHide, ahk_id %id_a%
id_a =
total_hw := LV_GetCount()
Gui, Show, Hide Autosize, Hidden windows (%total_hw%)
return

ListHW:
Gui, Show
return

HideListHW:
GuiClose:
Gui, Hide
return

l_c := LV_GetCount()
UnHideHW: ;Unhide all hidden windows
Loop, %l_c%
{
	Lv_GetText(id_a, a_index, 3)
	WinShow, ahk_id %id_a%
}
LV_Delete()
total_hw := LV_GetCount()
Gui, Show, Hide Autosize, Hidden windows (%total_hw%)
return

UnHideHWSpec: ;Unhide selected windows
l_c := LV_GetCount("Selected")
Loop, %l_c% ;Unhide selected, delete em from the list
{
  r_s = 0
  r_s := LV_GetNext(r_s)
  LV_GetText(id_a, r_s, 3)
  WinShow, ahk_id %id_a%
  Lv_Delete(r_s)
}
total_hw := LV_GetCount()
Gui, Show, Autosize, Hidden windows (%total_hw%)
id_a =
return

UnHideHW_Last:
LV_GetText(id_a,1,3)
WinShow, ahk_id %id_a%
LV_Delete(1)
total_hw := LV_GetCount()
Gui, Show, Autosize, Hidden window (%total_hw%)
id_a =
return

UnHideHW_First:
last_hw := LV_GetCount()
LV_GetText(id_a, last_hw, 3)
WinShow, ahk_id %id_a%
LV_Delete(last_hw)
total_hw := LV_GetCount()
Gui, Show, Autosize, Hidden window (%total_hw%)
id_a =
last_hw =
return

Autohide: ;Hide GUI automatically when losing focus
IfWinNotActive, ahk_id %gui_id%
  If a_guievent <> guicontextmenu
    Gui, Hide
return

Reload:
l_c := LV_GetCount()
Loop, %l_c%
{
	Lv_GetText(id_a, a_index, 3)
	WinShow, ahk_id %id_a%
}	
Reload
return

Exit:
l_c := LV_GetCount()
Loop, %l_c% ;Unhide all hidden windows before exiting or reloading
{
	Lv_GetText(id_a, a_index, 3)
	WinShow, ahk_id %id_a%
}	
ExitApp
return

;//////////////////////////
; function by Lexikos 
; http://www.autohotkey.com/forum/viewtopic.php?p=168788#168788
;//////////////////////////
; Gets the index+1 of the taskbar button which the mouse is hovering over.
; Returns an empty string if the mouse is not over the taskbar's task toolbar.
; Some code and inspiration from Sean's TaskButton.ahk http://www.autohotkey.com/forum/topic18652.html
GetMouseTaskButton(ByRef hwnd)
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y, win, ctl, 2
    ; Check if hovering over taskbar.
    WinGetClass, cl, ahk_id %win%
    if (cl != "Shell_TrayWnd")
        return
    ; Check if hovering over a Toolbar.
    WinGetClass, cl, ahk_id %ctl%
    if (cl != "ToolbarWindow32")
        return
    ; Check if hovering over task-switching buttons (specific toolbar).
    hParent := DllCall("GetParent", "Uint", ctl)
    WinGetClass, cl, ahk_id %hParent%
    if (cl != "MSTaskSwWClass")
        return

   
    WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd

    hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
    pRB := DllCall("VirtualAllocEx", "Uint", hProc
        , "Uint", 0, "Uint", 20, "Uint", 0x1000, "Uint", 0x4)

    VarSetCapacity(pt, 8, 0)
    NumPut(x, pt, 0, "int")
    NumPut(y, pt, 4, "int")
   
    ; Convert screen coords to toolbar-client-area coords.
    DllCall("ScreenToClient", "uint", ctl, "uint", &pt)
   
    ; Write POINT into explorer.exe.
    DllCall("WriteProcessMemory", "uint", hProc, "uint", pRB+0, "uint", &pt, "uint", 8, "uint", 0)

;     SendMessage, 0x447,,,, ahk_id %ctl%  ; TB_GETHOTITEM
    SendMessage, 0x445, 0, pRB,, ahk_id %ctl%  ; TB_HITTEST
    btn_index := ErrorLevel
    ; Convert btn_index to a signed int, since result may be -1 if no 'hot' item.
    if btn_index > 0x7FFFFFFF
        btn_index := -(~btn_index) - 1
   
   
    if (btn_index > -1)
    {
        ; Get button info.
        SendMessage, 0x417, btn_index, pRB,, ahk_id %ctl%   ; TB_GETBUTTON
   
        VarSetCapacity(btn, 20)
        DllCall("ReadProcessMemory", "Uint", hProc
            , "Uint", pRB, "Uint", &btn, "Uint", 20, "Uint", 0)
   
        state := NumGet(btn, 8, "UChar")  ; fsState
        pdata := NumGet(btn, 12, "UInt")  ; dwData
       
        ret := DllCall("ReadProcessMemory", "Uint", hProc
            , "Uint", pdata, "UintP", hwnd, "Uint", 4, "Uint", 0)
    } else
        hwnd = 0

       
    DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
    DllCall("CloseHandle", "Uint", hProc)


    ; Negative values indicate seperator items. (abs(btn_index) is the index)
    return btn_index > -1 ? btn_index+1 : 0
}
;//////////////////////////
; end of function
; http://www.autohotkey.com/forum/viewtopic.php?p=168788#168788
;//////////////////////////