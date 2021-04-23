HELP = ; Gui, 99
(LTrim0

ALT-TAB REPLACEMENT (WITH ICONS AND WINDOW TITLES IN A LISTVIEW).
      Latest version can be found at: http://file.autohotkey.net/evl/AltTab/AltTab.ahk
      Forum topic for discussion: http://www.autohotkey.com/forum/viewtopic.php?t=6422

HOTKEYS:
  Default:    Alt+Tab - move forwards in window stack
              Alt+Shift+Tab - move backwards in window stack
              Alt+Esc - cancel switching window
              Mouse wheel over the taskbar scrolls the list - Middle button selects a window in this mode.
  Window Groups can be assigned hotkeys to load the group/cycle through the windows.

EVENTS:
  Double-click a row to select that item and switch to it.

  Type first letter of program's title to cycle through them while still holding Alt

  Columns can be sorted by clicking on their titles.

  Tabs (window groups) can be re-ordered by drag-and-drop.

  Right-Click (context menu):
    Basic hotkey support for switching to specific windows (using window groups and adding window classes)
    Exclude (and un-exclude) specific windows and specific .EXEs - see "Window Groups" below.
    Edge-docking - dock windows to the edges of the screen and have them auto-hide (like the taskbar can).
    Window Groups - define lists of windows to easily switch between only showing certain apps.
    Manage groups of windows and processes (min/max all, close all, etc).

  Close windows:
    Alt+Middle mouse - close window under the mouse pointer in the Alt-Tab listview.
    Alt+\ "hotkey"  - close selected window (while list is displayed)
    Alt+/ "hotkey"  - close ALL windows whose EXE matches that of the selected entry (while list is displayed)
    Process menu entry - end selected process or all instance of the EXE in the list.

SETTINGS:
  See "; USER EDITABLE SETTINGS:" section near top of source code.

TO EXIT:
  Choose Exit from the system tray icon's menu.

NOTE: Stroke-It (and maybe other mouse gesture programs) can cause the context menu to be shown twice/problematic.
        Solution: exclude the program within the gesture recognition program (window title = Alt-Tab Replacement).
)


LATEST_VERSION_CHANGES = ; Gui, 98
(LTrim0

TO DO (maybe):
  settings window
  save other settings between restarts
  include a filter for docked windows to be displayed in alt-tab or not (ie a tab for docked windows) - perhaps alter title? e.g. DOCKED***
  stick items to top or bottom of list
    use listview insert command to place windows at specific locations in list?

LATEST VERSION CHANGES:
since 25-04-06:
  +: Groups of windows are shown in tabs - they can be re-arranged by drag-and-drop.
  +: Settings tab.
  + & FIX: Updates to the listview colour code - much smoother now (thanks to ambi for updating the Listview script).
  + & FIX: Sorting of columns with direction indication ([+] or [-])
  +: Mouse wheel over the TASKBAR scrolls the list - Middle button SELECTS a window in this mode (it normally CLOSES a window!).
  +: Save data on big changes (in addition to program exit) - e.g. new group created, hotkeys changed
  CHANGE: Selections with the mouse are now made with a double click (or just release the Alt key) instead of a single one.
  CHANGE: Adjusted display position to be centered by default.
  CHANGE: Dialog windows only indicated by red higlight (not by title too).
  CHANGE: Not Responding windows indicated in a new column (not by title).
  CHANGE: Many speed optimisations and code improvements (it's almost decipherable now ;-))
  FIX: Handling of "Not Responding" windows with no delays.


> For older changes, see the forum: http://www.autohotkey.com/forum/viewtopic.php?t=6422

)


;========================================================================================================
; USER EDITABLE SETTINGS:

  ; Icons
    Use_Large_Icons =1 ; 0 = small icons, 1 = large icons in listview

  ; Fonts
    Font_Size =12
    Font_Size_Tab =8
    Font_Type_Tab =Courier New
    Font_Type =Arial

  ; Position
    Gui_x =Center
    Gui_y =Center

  ; Max height
    Height_Max_Modifier =0.92 ; multiplier for screen height (e.g. 0.92 = 92% of screen height max )

  ; Width
    Listview_Width := A_ScreenWidth * 0.55
    SB_Width := Listview_Width / 4 ; StatusBar section sizes
    Exe_Width_Max := Listview_Width / 5 ; Exe column max width

  ; Edge-Docking of windows to screen edges
    Edge_Dock_Activation_Delay =750 ;  Delay in milliseconds for hovering over edge-docked window/dismissing window
    Edge_Dock_Border_Visible =5 ; number of pixels of window to remain visible on screen edge

;========================================================================================================
; USER OVERRIDABLE SETTINGS:

  ; Widths
    Col_1 =Auto ; icon column
    Col_2 =0 ; hidden column for row number
    ; col 3 is autosized based on other column sizes
    Col_4 =Auto ; exe
    Col_5 =AutoHdr ; State
    Col_6 =Auto ; OnTop
    Col_7 =Auto ; Status - e.g. Not Responding
    Gui1_Tab__width := Listview_Width - 2

  ; Max height
    Height_Max := A_ScreenHeight * Height_Max_Modifier ; limit height of listview
    Small_to_Large_Ratio =1.6 ; height of small rows compared to large rows

  ; Colours in RGB hex
    Tab_Colour =C4C5FB
    Listview_Colour =E1E2FD ; does not need converting as only used for background
    StatusBar_Background_Colour =C4C5FB
    
  ; convert colours to correct format for listview color functions:
    Listview_Colour_Min_Text :=       RGBtoBGR("0x000000") ; highlight minimised windows
    Listview_Colour_Min_Back :=       RGBtoBGR("0xC2C6FC")
    Listview_Colour_OnTop_Text :=     RGBtoBGR("0x000000") ; highlight alwaysontop windows
    Listview_Colour_OnTop_Back :=     RGBtoBGR("0x8079FB")
    Listview_Colour_Dialog_Text :=    RGBtoBGR("0x000000")
    Listview_Colour_Dialog_Back :=    RGBtoBGR("0xFB5959")
    Listview_Colour_Selected_Text :=  RGBtoBGR("0xFFFFFF")
    Listview_Colour_Selected_Back :=  RGBtoBGR("0x000071")
    Listview_Colour_Not_Responding_Text := RGBtoBGR("0xFFFFFF")
    Listview_Colour_Not_Responding_Back := RGBtoBGR("0xFF0000")


;========================================================================================================

#NoEnv
#SingleInstance force
#Persistent
#InstallKeybdHook
#InstallMouseHook
#NoTrayIcon
Process Priority,,High
SetWinDelay, -1
SetBatchLines, -1

IniFile_Data("Read")

OnExit, OnExit_Script_Closing

OnMessage( 0x06, "WM_ACTIVATE" ) ; alt tab list window lost focus > hide list

LV_ColorInitiate() ; initiate listview color change procedure

Gosub, Initiate_Hotkeys ; initiate Alt-Tab and Alt-Shift-Tab hotkeys and translate some modifier symbols

WS_EX_CONTROLPARENT =0x10000
WS_EX_DLGMODALFRAME =0x1
WS_CLIPCHILDREN =0x2000000
WS_EX_APPWINDOW =0x40000
WS_EX_TOOLWINDOW =0x80
WS_DISABLED =0x8000000
WS_VSCROLL =0x200000
WS_POPUP =0x80000000

SysGet, Scrollbar_Vertical_Thickness, 2 ; 2 is SM_CXVSCROLL, Width of a vertical scroll bar
If A_OSVersion =WIN_2000
  lv_h_win_2000_adj =2 ; adjust height of main listview by +2 pixels to avoid scrollbar in windows 2000
Else
  lv_h_win_2000_adj =0

WinGet, TaskBar_ID, ID, ahk_class Shell_TrayWnd ; for docked windows check

Display_List_Shown =0
Window_Hotkey =0
Use_Large_Icons_Current =%Use_Large_Icons% ; for remembering original user setting but changing on the fly
Gui_Dock_Windows_List = ; keep track of number of docked windows
Time_Since_Last_Alt_Close =0 ; initialise time for repeat rate allowed for closing windows with alt+\
Viewed_Window_List =

Col_Title_List =#| |Window|Exe|View|Top|Status
StringSplit, Col_Title, Col_Title_List,| ; create list of listview header titles

~WheelUp::
  Gosub, ~WheelDown
  If (Scroll_Over_wID = TaskBar_ID)
    Loop, 2
      Gosub, Alt_Shift_Tab
Return

~WheelDown::
  MouseGetPos, JUNK, JUNK, Scroll_Over_wID
    If ! (Scroll_Over_wID = TaskBar_ID)
      Return
    Gosub, Single_Key_Show_Alt_Tab
    Hotkey, %Alt_Hotkey%%Use_AND_Symbol%Mbutton, ListView_Destroy, %state% UseErrorLevel ; select the window if launched from the taskbar
Return


;========================================================================================================


Initiate_Hotkeys:
  Use_AND_Symbol = ; initiate
  ; If both Alt and Tab are modifier keys, write Tab as a word not a modifier symbol, else Alt-Tab is invalid hotkey
  If Alt_Hotkey contains #,!,^,+
    {
    If Tab_Hotkey contains #,!,^,+
      Replace_Modifier_Symbol( "Tab_Hotkey" , "Tab_Hotkey" )
    }
  Else If Alt_Hotkey contains XButton1,XButton2
    Use_AND_Symbol :=" & "
  Else If Tab_Hotkey contains WheelUp,WheelDown
    Use_AND_Symbol :=" & "
  Hotkey, %Alt_Hotkey%%Use_AND_Symbol%%Tab_Hotkey%, Alt_Tab, On ; turn on alt-tab hotkey here to be able to turn it off for simple switching of apps in script
  Hotkey, %Alt_Hotkey%%Use_AND_Symbol%%Shift_Tab_Hotkey%, Alt_Shift_Tab, On ; turn on alt-tab hotkey here to be able to turn it off for simple switching of apps in script

  If Single_Key_Show_Alt_Tab !=
    Hotkey, *%Single_Key_Show_Alt_Tab%, Single_Key_Show_Alt_Tab, On

  Replace_Modifier_Symbol( "Alt_Hotkey" , "Alt_Hotkey2" )

  If (! InStr(Tab_Hotkey, "Wheel") and ! InStr(Shift_Tab_Hotkey, "Wheel")) ; wheel isn't used as an alt-tab hotkey so can be used for scrolling list instead
    Use_Wheel_Scroll_List =1
Return


Alt_Tab: ; alt-tab hotkey
  Alt_Tab_Common_Function("Alt_Tab")
Return

Alt_Shift_Tab: ; alt-shift-tab hotkey
  Alt_Tab_Common_Function("Alt_Shift_Tab")
Return

Alt_Tab_Common_Function(Key) ; Key = "Alt_Tab" or "Alt_Shift_Tab"
{
  Global
  If Display_List_Shown =0
    {
    WinGet, Active_ID, ID, A
    Gosub, Custom_Group__make_array_of_contents
    Gosub, Display_List
    Gosub, Alt_Tab_Common__Check_auto_switch_icon_sizes ; limit gui height / auto-switch icon sizes
    Gosub, Alt_Tab_Common__Highlight_Active_Window
    If ( GetKeyState(Alt_Hotkey2, "P") or GetKeyState(Alt_Hotkey2)) ; Alt key still pressed, else gui not shown
      {
      Gui, 1: Show, AutoSize x%Gui_x% y%Gui_y%, Alt-Tab Replacement
      Hotkeys_Toggle_Temp_Hotkeys("On") ; (state = "On" or "Off") ; ensure hotkeys are on
      }
    }
  Selected_Row := LV_GetNext(0, "F")
  If Key =Alt_Tab
    {
    Selected_Row += 1
    If (Selected_Row > Window_Found_Count)
      Selected_Row =1
    }
  Else If Key =Alt_Shift_Tab
    {
    Selected_Row -= 1
    If Selected_Row < 1
      Selected_Row := Window_Found_Count
    }
  LV_Modify(Selected_Row, "Focus Select Vis") ; get selected row and ensure selection is visible
  SetTimer, Check_Alt_Hotkey2_Up, 30

  GuiControl, Focus, Listview1 ; workaround for gui tab bug - gosub not activated when already activated button clicked on again

  Gosub, SB_Update__ProcessCPU
  SetTimer, SB_Update__ProcessCPU, 1000
  Return

  Alt_Tab_Common__Check_auto_switch_icon_sizes: ; limit gui height / auto-switch icon sizes
    If (Listview_NowH > Height_Max AND Use_Large_Icons_Current =1) ; switch to small icons
      {
      Use_Large_Icons_Current =0
      Gosub, Alt_Tab_Common__Switching_Icon_Sizes
      }
    If ((Listview_NowH * Small_to_Large_Ratio) < Height_Max AND Use_Large_Icons_Current =0 AND Use_Large_Icons=1) ; switch to large icons
      {
      Use_Large_Icons_Current =1
      Gosub, Alt_Tab_Common__Switching_Icon_Sizes
      }
  Return

  Alt_Tab_Common__Switching_Icon_Sizes:
    Gui, 1: Destroy
    Display_List_Shown =0
    Gosub, Display_List ; update colours
  Return

  Alt_Tab_Common__Highlight_Active_Window:
    Active_ID_Found =0 ; init
    Loop, %Window_Found_Count% ; select active program in list (not always the top item)
      {
      LV_GetText(RowText, A_Index, 2)  ; Get hidden column numbers
      If (Window%RowText% = Active_ID)
        {
        Active_ID_Found :=A_Index
        Break
        }
      }
    If Active_ID_Found =0 ; active window has an icon in another main window & was excluded from Alt-Tab list
      {
      WinGet, Active_Process, ProcessName, ahk_id %Active_ID%
      WinGetClass, Active_Class, ahk_id %Active_ID%
      ; If desktop/taskbar selected or nothing at all, don't select item in alt-tab list
      If ( !(Active_Class ="Progman" OR Active_Class ="WorkerW" OR Active_Class ="Shell_TrayWnd" OR Active_Class =""))
        Loop, %Window_Found_Count% ; find top item in window list with same exe name as active window
          If (Exe_Name%A_Index% = Active_Process)
            {
            Active_ID := Window%A_Index% ; find this new ID in the listview
            LV_GetText(RowText, A_Index, 2)  ; Get hidden column numbers
            If (Window%RowText% = Active_ID)
              {
              Active_ID_Found :=A_Index
              Break
              }
            }
      }
    If Active_ID_Found !=0
      LV_Modify(Active_ID_Found, "Focus Select Vis")
  Return
}


Single_Key_Show_Alt_Tab:
  Single_Key_Show_Alt_Tab_Used =1
  Send, {%Alt_Hotkey2% down}
  Gosub, Alt_Tab
  Hotkey, *%Single_Key_Hide_Alt_Tab%, ListView_Destroy, On
Return


Alt_Esc: ; abort switching
  Alt_Esc =1
  Gosub, ListView_Destroy
Return


Alt_Esc_Check_Alt_State: ; hides alt-tab gui - shows again if alt still pressed
  Gosub, Alt_Esc
  If ( GetKeyState(Alt_Hotkey2, "P") or GetKeyState(Alt_Hotkey2)) ; Alt key still pressed - show alt-tab again
    Gosub, Alt_Tab
Return


Hotkeys_Toggle_Temp_Hotkeys(state) ; (state = "On" or "Off")
{
  Global
; UseErrorLevel in case of exiting script before hotkey created
  Hotkey, %Alt_Hotkey%%Use_AND_Symbol%%Esc_Hotkey%, Alt_Esc, %state% UseErrorLevel ; abort
  If Use_Wheel_Scroll_List =1
    {
    Hotkey, %Alt_Hotkey%%Use_AND_Symbol%WheelUp,    Alt_Shift_Tab, %state% UseErrorLevel ; previous window
    Hotkey, %Alt_Hotkey%%Use_AND_Symbol%WheelDown,  Alt_Tab,     %state% UseErrorLevel ; next window
    }
  Hotkey, %Alt_Hotkey%%Use_AND_Symbol%Mbutton, MButton_Close, %state% UseErrorLevel ; close the window clicked on
  Hotkey, *~LButton, LButton_Tab_Check, %state% UseErrorLevel ; check if user clicked/dragged a tab
}


Check_Alt_Hotkey2_Up:
  If ! ( GetKeyState(Alt_Hotkey2, "P") or GetKeyState(Alt_Hotkey2)) ; Alt key released
    Gosub, ListView_Destroy
Return


;========================================================================================================


Display_List:
  LV_ColorChange() ; clear all highlighting
  If Display_List_Shown =1 ; empty listview and image list if only updating - e.g. when closing a window (mbutton)
    LV_Delete()
  Else ; not shown - need to create gui for updating listview
    {
    ; Create the ListView gui
    Gui, 1: +AlwaysOnTop +ToolWindow -Caption
    Gui, 1: Color, %Tab_Colour% ; i.e. border/background (default = 404040) ; barely visible - right and bottom sides only
    Gui, 1: Margin, 0, 0
    ; Tab stuff
    Gui, 1: Font, s%Font_Size_Tab%, %Font_Type_Tab%
    Gui, 1: Add, Tab2, vGui1_Tab HWNDhw_Gui1_Tab Background w%Gui1_Tab__width% -0x200, %Group_List% ; -0x200 = ! TCS_MULTILINE
    Gui, 1: Tab, %Group_Active%,, Exact ; Future controls are owned by this tab
    Gui, 1: Add, StatusBar, Background%StatusBar_Background_Colour% ; add before changing font
    Gui, 1: Font, s%Font_Size%, %Font_Type%
    Gui, 1: Add, ListView, x-1 y+-4 r%Window_Found_Count% w%Listview_Width% AltSubmit -Multi NoSort Background%Listview_Colour% Count10 gListView_Event vListView1 HWNDhw_LV_ColorChange,%Col_Title_List%
    LV_ModifyCol(2, "Integer") ; sort hidden column 2 as numbers
    SB_SetParts(SB_Width, SB_Width, SB_Width)
    Gosub, SB_Update__CPU
    SetTimer, SB_Update__CPU, 1000
    }
  GuiControl,, Gui1_Tab, |%Group_List% ; update in case of changes
  GuiControl, ChooseString, Gui1_Tab, %Group_Active%

  ImageListID1 := IL_Create(10,5,Use_Large_Icons_Current) ; Create an ImageList so that the ListView can display some icons
  LV_SetImageList(ImageListID1, 1) ; Attach the ImageLists to the ListView so that it can later display the icons

  Gosub, Display_List__Find_windows_and_icons
  If Window_Found_Count =0
    {
    Window_Found_Count =1
    LV_Add("","","","","","","") ; No Windows Found! - avoids an error on selection if nothing is added
    }

  ColumnClickSort(Sort_By_Column, 1) ; Col = column clicked on, Update = 1 if true else blank (apply only, not change order)

  Gosub, Gui_Resize_and_Position
  If Display_List_Shown =1 ; resize gui for updating listview
    {
    Gui, 1: Show, AutoSize x%Gui_x% y%Gui_y%, Alt-Tab Replacement
    If Selected_Row >%Window_Found_Count% ; less windows now - select last one instead of default 1st row
      Selected_Row =%Window_Found_Count%
    LV_Modify(Selected_Row, "Focus Select Vis") ; select 1st entry since nothing selected
    }
  Display_List_Shown =1 ; Gui 1 is shown back in Alt_Tab_Common_Function() for initial creation
Return


Display_List__Find_windows_and_icons:
  WinGet, Window_List, List ; Gather a list of running programs

  Window_Found_Count =0
  Loop, %Window_List%
    {
    wid := Window_List%A_Index%
    WinGetTitle, wid_Title, ahk_id %wid%
    WinGet, Style, Style, ahk_id %wid%

    If ((Style & WS_DISABLED) or ! (wid_Title)) ; skip unimportant windows ; ! wid_Title or 
        Continue

    WinGet, es, ExStyle, ahk_id %wid%
    Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
    WinGet, Style_parent, Style, ahk_id %Parent%
    Owner := Decimal_to_Hex( DllCall( "GetWindow", "uint", wid , "uint", "4" ) ) ; GW_OWNER = 4
    WinGet, Style_Owner, Style, ahk_id %Owner%

    If (((es & WS_EX_TOOLWINDOW)  and !(Parent)) ; filters out program manager, etc
        or ( !(es & WS_EX_APPWINDOW)
          and (((Parent) and ((Style_parent & WS_DISABLED) =0)) ; These 2 lines filter out windows that have a parent or owner window that is NOT disabled -
            or ((Owner) and ((Style_Owner & WS_DISABLED) =0))))) ; NOTE - some windows result in blank value so must test for zero instead of using NOT operator!
      continue

    WinGet, Exe_Name, ProcessName, ahk_id %wid%
    WinGetClass, Win_Class, ahk_id %wid%
    hw_popup := Decimal_to_Hex(DllCall("GetLastActivePopup", "uint", wid))

    ; CUSTOM GROUP FILTERING
    If (Group_Active != "Settings" AND Group_Active != "ALL") ; i.e. list is filtered, check filter contents to include
      {
      Custom_Group_Include_wid_temp = ; initialise/reset

      Loop, %Group_Active_0% ; check current window id against the list to filter
        {
        Loop_Item := Group_Active_%A_Index%
        StringLeft, Exclude_Item, Loop_Item, 1
        If Exclude_Item =! ; remove ! for matching strings
          StringTrimLeft, Loop_Item, Loop_Item, 1
        If ((Loop_Item = Exe_Name) or InStr(wid_Title, Loop_Item)) ; match exe name, title
          {
          Custom_Group_Include_wid_temp =1 ; include this window
          Break
          }
        }

      If  (((Custom_Group_Include_wid_temp =1) and (Exclude_Item ="!"))
          or ((Custom_Group_Include_wid_temp !=1) and (Exclude_Not_In_List =1)))
        Continue
      }

    Dialog =0 ; init/reset
    If (Parent and ! Style_parent)
      CPA_file_name := GetCPA_file_name( wid ) ; check if it's a control panel window
    Else
      CPA_file_name =
    If (CPA_file_name or (Win_Class ="#32770") or ((style & WS_POPUP) and (es & WS_EX_DLGMODALFRAME)))
      Dialog =1 ; found a Dialog window
    If (CPA_file_name)
      {
      Window_Found_Count += 1
      Gui_Icon_Number := IL_Add( ImageListID1, CPA_file_name, 1 )
      }
    Else
      Get_Window_Icon(wid, Use_Large_Icons_Current) ; (window id, whether to get large icons)
    Window__Store_attributes(Window_Found_Count, wid, "") ; Index, wid, parent (or blank if none)
    LV_Add("Icon" . Window_Found_Count,"", Window_Found_Count, Title%Window_Found_Count%, Exe_Name%Window_Found_Count%, State%Window_Found_Count%, OnTop%Window_Found_Count%, Status%Window_Found_Count%)
    }
Return


Window__Store_attributes(Index, wid, ID_Parent) ; Index = Window_Found_Count, wid = window id, ID_Parent = parent or blank if none
{
  Local State_temp
  Window%Index% =%wid%                    ; store ahk_id's to a list
  Window_Parent%Index% =%ID_Parent%       ; store Parent ahk_id's to a list to later see if window is owned
  Title%Index% := wid_Title               ; store titles to a list
  hw_popup%Index% := hw_popup             ; store the active popup window to a list (eg the find window in notepad)
  WinGet, Exe_Name%Index%, ProcessName, ahk_id %wid% ; store processes to a list
  WinGet, PID%Index%, PID, ahk_id %wid% ; store pid's to a list
  Dialog%Index% := Dialog  ; 1 if found a Dialog window, else 0
  WinGet, State_temp, MinMax, ahk_id %wid%
    If State_temp =1
      State%Index% =Max
    Else If State_temp =-1
      State%Index% =Min
    Else If State_temp =0
      State%Index% =
    WinGet, es_hw_popup, ExStyle, ahk_id %hw_popup% ; eg to detect on top status of zoomplayer window
    If ((es & 0x8) or (es_hw_popup & 0x8))  ; 0x8 is WS_EX_TOPMOST.
      {
      OnTop%Index% =Top
      OnTop_Found =1
      }
    Else
      OnTop%Index% =
  If Responding
    Status%Index% =
  Else
    {
    Status%Index% =Not Responding
    Status_Found =1
    }
  ; Listview Higlighting Colours
    If Status%Index% =Not Responding
      LV_ColorChange(Index, Listview_Colour_Not_Responding_Text, Listview_Colour_Not_Responding_Back)
    Else If Dialog%Index%
      LV_ColorChange(Index, Listview_Colour_Dialog_Text, Listview_Colour_Dialog_Back)
    Else If OnTop%Index% =Top
      LV_ColorChange(Index, Listview_Colour_OnTop_Text, Listview_Colour_OnTop_Back)
    Else If State%Index% =Min
      LV_ColorChange(Index, Listview_Colour_Min_Text, Listview_Colour_Min_Back)
}


LButton_Tab_Check:
  Tab_Button_Clicked := TCM_HITTEST()
  If Tab_Button_Clicked
    {
    Tab_Button_Clicked_Text := Tab_Button_Get_Text(Tab_Button_Clicked)
    SetTimer, Tab__Drag_and_Drop, 60 ; check status of drag operation
    }
Return

Tab__Drag_and_Drop:
  If ! GetKeyState("LButton")
    {
    SetTimer, Tab__Drag_and_Drop, Off
    Group_Active := Tab_Button_Clicked_Text
    Gosub, Gui_Window_Group_Load__part2
    Return
    }
  If TCM_HITTEST()
    Tab_Button_Over := TCM_HITTEST()
  Tab_Button_Over_Text := Tab_Button_Get_Text(Tab_Button_Over)
  If (Tab_Button_Over < Tab_Button_Clicked)
    Tab_Swap(Group_List, Tab_Button_Clicked_Text, Tab_Button_Over_Text)
  Else If (Tab_Button_Over > Tab_Button_Clicked)
    Tab_Swap(Group_List, Tab_Button_Over_Text, Tab_Button_Clicked_Text)
Return

Tab_Swap(ByRef Tab_List, ByRef Text1, ByRef Text2)
{
  Global
  StringReplace, Tab_List, Tab_List, %Text1% , %Text2%
  StringReplace, Tab_List, Tab_List, %Text2% , %Text1%
  Tab_Button_Clicked := Tab_Button_Over ; update
  GuiControl,, Gui1_Tab, |%Group_List%
  GuiControl, ChooseString, Gui1_Tab, %Tab_Button_Clicked_Text%
}

TCM_HITTEST() ; returns 1-based index of clicked tab
{
  Global hw_Gui1_Tab
  MouseGetPos, mX, mY, hWnd, Control, 2 
  If (Control != hw_Gui1_Tab) ; not clicked on tab control
    Return, False
  ControlGetPos, cX, cY,,,, ahk_id %Control%
  x:=mX-cX, y:=mY-cY ; co-ordinatess relative to tab control
  VarSetCapacity(lparam, 12, 0)
  NumPut(x, lparam, 0, "Int")
  NumPut(y, lparam, 4, "Int")
  SendMessage, 0x130D, 0, &lparam,, ahk_id %Control% ; TCM_HITTEST
  result := ErrorLevel ; 0-based index, FAIL, or 0xFFFFFFFF (in a tab but not the button)
  If (result = "FAIL" or result = 0xFFFFFFFF)
    Return, False
  Else
    Return, result + 1 ; change to 1-based index
}

Tab_Button_Get_Text(Tab_Index)
{
  Global
  If Tab_Index
    Loop, Parse, Group_List,|
      If (A_Index = Tab_Index)
        Return,  A_LoopField
}


Gui_Settings_Tab:
    
Return


Gui_Resize_and_Position:
  DetectHiddenWindows, On ; retrieving column widths to enable calculation of col 3 width
  Gui, +LastFound
  Gui_ID := WinExist() ; for auto-sizing columns later
  If Display_List_Shown =0 ; resize listview columns - no need to resize columns for updating listview
    {
    LV_ModifyCol(1, Col_1) ; icon column
    LV_ModifyCol(2, Col_2) ; hidden column for row number
    ; col 3 - see below
    LV_ModifyCol(4, Col_4) ; exe
    SendMessage, 0x1000+29, 3, 0,, ahk_id %hw_LV_ColorChange% ; LVM_GETCOLUMNWIDTH is 0x1000+29
      Width_Column_4 := ErrorLevel
      If Width_Column_4 > %Exe_Width_Max%
        LV_ModifyCol(4, Exe_Width_Max) ; resize title column
    LV_ModifyCol(5, Col_5) ; State
    If OnTop_Found
      LV_ModifyCol(6, Col_6) ; OnTop
    Else
      LV_ModifyCol(6, 0) ; OnTop
    If Status_Found
      LV_ModifyCol(7, Col_7) ; Status
    Else
      LV_ModifyCol(7, 0) ; Status
    Loop, 7
      {
      SendMessage, 0x1000+29, A_Index -1, 0,, ahk_id %hw_LV_ColorChange% ; LVM_GETCOLUMNWIDTH is 0x1000+29
        Width_Column_%A_Index% := ErrorLevel
      }
    Col_3_w := Listview_Width - Width_Column_1 - Width_Column_2 - Width_Column_4 - Width_Column_5 - Width_Column_6 - Width_Column_7 - 4 ; total width of columns - 4 for border
    LV_ModifyCol(3, Col_3_w) ; resize title column
    }
  ListView_Resize_Vertically(Gui_ID) ; Automatically resize listview vertically - pass the gui id value
  GuiControlGet, Listview_Now, Pos, ListView1 ; retrieve listview dimensions/position ; for auto-sizing (elsewhere)
  ; resize listview according to scrollbar presence
  If (Listview_NowH > Height_Max AND Use_Large_Icons_Current =0) ; already using small icons so limit height
    {
    Col_3_w -= Scrollbar_Vertical_Thickness ; allow for vertical scrollbar being visible
    LV_ModifyCol(3, Col_3_w) ; resize title column
    GuiControl, Move, ListView1, h%Height_Max%
    }
  DetectHiddenWindows, Off
Return


SB_Update__CPU:
  Format_Float := A_FormatFloat
  SetFormat, Float, 4.1
  SB_SetText( "CPU (%): " GetSystemTimes(), 1)
  SetFormat, Float, %Format_Float%
Return
SB_Update__ProcessCPU:
  Format_Float := A_FormatFloat
  SetFormat, Float, 4.1
  Get__Selected_Row_and_RowText()
  SB_SetText( "Process CPU (%): " GetProcessTimes(PID%RowText%), 2)
  SetFormat, Float, %Format_Float%
Return


Get__Selected_Row_and_RowText()
{
  Global
  If ListView1__Disabled = 1 ; don't update - for statusbar (timer)
    Return
  Selected_Row := LV_GetNext(0, "F")
  LV_GetText(RowText, Selected_Row, 2)  ; Get the row's 2nd column's text for real order number (hidden column).
}

;========================================================================================================


ListView_Event:
  If MButton_Clicked =1 ; closing a window so don't process events
    Return
  If A_GuiEvent =DoubleClick ; activate clicked window
    Gosub, ListView_Destroy
  If A_GuiEvent =K ; letter was pressed, select next window name starting with that letter
    Gosub, Key_Pressed_1st_Letter
  If A_GuiEvent =ColClick ; column was clicked - do custom sort to allow for sorting hidden column + remembering state
    ColumnClickSort(A_EventInfo) ; A_EventInfo = column clicked on
Return


GuiContextMenu:  ; right-click or press of the Apps key -> displays the menu only for clicks inside the ListView
  If Menu__Gui_1 ; destroy previously generated menus
  Get__Selected_Row_and_RowText()
  Gui_wid := Window%RowText%
  Gui_wid_Title :=Title%RowText%
  StringLeft, Gui_wid_Title, Gui_wid_Title, 40

  Menu, Tray, UseErrorLevel 
  ; Clear previous entries
  Menu, ContextMenu1, DeleteAll
  Menu, Gui_MinMax_Windows, DeleteAll
  Menu, Gui_Dock_Windows, DeleteAll
  Menu, Gui_Un_Exclude_Windows, DeleteAll
  Menu, Gui_Window_Group_Load, DeleteAll
  Menu, Gui_Window_Group_Delete, DeleteAll
  Menu, Gui_Processes, DeleteAll
  Menu, Gui_Settings_Help, DeleteAll

  ; Min/Max windows
  Menu, Gui_MinMax_Windows, Add, % "Maximize all:  " Exe_Name%RowText%, Gui_MinMax_Windows
  Menu, Gui_MinMax_Windows, Add, % "Minimize all:   " Exe_Name%RowText%, Gui_MinMax_Windows
  Menu, Gui_MinMax_Windows, Add
  Menu, Gui_MinMax_Windows, Add, % "Normal all:     " Exe_Name%RowText%, Gui_MinMax_Windows
  Menu, ContextMenu1, Add, &Min / Max, :Gui_MinMax_Windows

  ; Dock to Screen Edge entries
  Menu, Gui_Dock_Windows, Add, Left, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Right, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Top, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Bottom, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add
  Menu, Gui_Dock_Windows, Add, Corner - Top Left, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Corner - Top Right, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Corner - Bottom Left, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add, Corner - Bottom Right, Gui_Dock_Windows
  Menu, Gui_Dock_Windows, Add
  Menu, Gui_Dock_Windows, Add, Un-Dock, Gui_Un_Dock_Window
  Menu, Gui_Dock_Windows, Add, Un-Dock All, Gui_Un_Dock_Windows_All
  IfNotInString, Gui_Dock_Windows_List,%Gui_wid%
    Menu, Gui_Dock_Windows, Disable, Un-Dock
  Else
    {
    Menu, Gui_Dock_Windows, Disable, Left
    Menu, Gui_Dock_Windows, Disable, Right
    Menu, Gui_Dock_Windows, Disable, Top
    Menu, Gui_Dock_Windows, Disable, Bottom
    Menu, Gui_Dock_Windows, Disable, Corner - Top Left
    Menu, Gui_Dock_Windows, Disable, Corner - Top Right
    Menu, Gui_Dock_Windows, Disable, Corner - Bottom Left
    Menu, Gui_Dock_Windows, Disable, Corner - Bottom Right
    If (Edge_Dock_Position_%Gui_wid% !="") ; produces error if doesn't exist
      Menu, Gui_Dock_Windows, Check, % Edge_Dock_Position_%Gui_wid%
    }
  If Gui_Dock_Windows_List =
    Menu, Gui_Dock_Windows, Disable, Un-Dock All
  Menu, ContextMenu1, Add, &Dock to Edge, :Gui_Dock_Windows

  ; Window Group sub-menu entry
  Menu, ContextMenu1, Add ; spacer
  Menu, ContextMenu1, Add, Group - &No Filter, Gui_Window_Group_No_Filter
  If (Group_Active != "Settings" AND Group_Active != "ALL")
    Menu, ContextMenu1, Disable, Group - &No Filter

  Loop, Parse, Group_List,|
    If (A_LoopField != "Settings")
      Menu, Gui_Window_Group_Load, Add,%A_LoopField%, Gui_Window_Group_Load
  Menu, Gui_Window_Group_Load, Check, %Group_Active%
  Menu, ContextMenu1, Add, Group - &Load, :Gui_Window_Group_Load
  Menu, ContextMenu1, Add, Group - &Save/Edit, Gui_Window_Group_Save_Edit
  Menu, ContextMenu1, Add, Group - Global &Include, Gui_Window_Group_Global_Include
  Menu, ContextMenu1, Add, Group - Global &Exclude, Gui_Window_Group_Global_Exclude

  Loop, Parse, Group_List,|
    If (A_LoopField != "Settings" AND A_LoopField != "ALL")
      Menu, Gui_Window_Group_Delete, Add,%A_LoopField%, Gui_Window_Group_Delete
  Menu, Gui_Window_Group_Delete, Check, %Group_Active%
  Menu, Gui_Window_Group_Delete, Color, E10000, Single ; warning colour
  Menu, ContextMenu1, Add, Group - &Delete, :Gui_Window_Group_Delete

  ; Hotkeys entry
  Menu, ContextMenu1, Add ; spacer
  Menu, ContextMenu1, Add, &Hotkeys, Gui_Hotkeys

  ; Processes entry
  Menu, ContextMenu1, Add ; spacer
  Menu, Gui_Processes, Add, % "End:      " Gui_wid_Title, End_Process_Single
  Menu, Gui_Processes, Add ; spacer
  Menu, Gui_Processes, Add, % "End All:  " Exe_Name%RowText%, End_Process_All_Instances
  Menu, Gui_Processes, Color, E10000, Single ; warning colour
  Menu, ContextMenu1, Add, &Processes, :Gui_Processes

  ; Help + Latest changes
  Menu, ContextMenu1, Add ; spacer
  Menu, Gui_Settings_Help, Add, Delete Settings (.ini) && Reload, Delete_Ini_File_Settings
  Menu, Gui_Settings_Help, Add, ; spacer
  Menu, Gui_Settings_Help, Add, Help, HELP_and_LATEST_VERSION_CHANGES
  Menu, Gui_Settings_Help, Add, Latest Changes, HELP_and_LATEST_VERSION_CHANGES
  Menu, ContextMenu1, Add, Settings && Help, :Gui_Settings_Help

 Menu, ContextMenu1, Show, %A_GuiX%, %A_GuiY%
Return


Gui_MinMax_Windows:
  Gosub, GuiControl_Disable_ListView1
  List_of_Process_To_MinMax = ; need to store list now as re-drawing the listview over-writes necessary variables
  Loop, %Window_Found_Count%
    {
    If ( Exe_Name%A_Index% = Exe_Name%RowText% and ! Dialog%A_Index% ) ; don't try to act on dialog windows (e.g. save prompts)
        List_of_Process_To_MinMax .= "|" . Window%A_Index%
    }
  StringTrimLeft, List_of_Process_To_MinMax, List_of_Process_To_MinMax, 1 ; remove 1st | character (empty reference otherwise)
  If A_ThisMenuItem contains Maximize
    MinMax_Message =0xF030 ; SC_MAXIMIZE
  Else If A_ThisMenuItem contains Minimize
    MinMax_Message =0xF020 ; SC_MINIMIZE
  Else If A_ThisMenuItem contains Normal
    MinMax_Message =0xF120 ; SC_RESTORE
  Loop, Parse, List_of_Process_To_MinMax,|
    PostMessage, 0x112, %MinMax_Message%,,, ahk_id %A_LoopField% ; 0x112 = WM_SYSCOMMAND
  Sleep, 50 ; wait for min/max state to change otherwise updated listview will be wrong
  Gosub, Display_List
  Gosub, GuiControl_Enable_ListView1
Return

GuiControl_Disable_ListView1:
  OnMessage( 0x06, "" ) ; turn off: no alt tab list window lost focus -> hide list
  ListView1__Disabled = 1
  GuiControl, Disable, ListView1
Return

GuiControl_Enable_ListView1:
  GuiControl, Enable, ListView1
  GuiControl, Focus, ListView1
  ListView1__Disabled = 0
  OnMessage( 0x06, "WM_ACTIVATE" ) ; turn on again - alt tab list window lost focus > hide list
Return


; DOCKED WINDOWS MENU SECTION:
;============================================================================================================================

Gui_Dock_Windows:
  Edge_Dock_%Gui_wid% =%Gui_wid% ; write window ID to a unique variable
  Edge_Dock_Position_%Gui_wid% :=A_ThisMenuItem ; store Left, Right, etc
  WinGet, Edge_Dock_State_%Gui_wid%, MinMax, ahk_id %Gui_wid%
  If Edge_Dock_State_%Gui_wid% =-1 ; if window is mimised, un-minimise
    WinRestore, ahk_id %Gui_wid%
  WinGetPos, Edge_Dock_X_%Gui_wid%, Edge_Dock_Y_%Gui_wid%, Edge_Dock_Width_%Gui_wid%, Edge_Dock_Height_%Gui_wid%, ahk_id %Gui_wid%
  Edge_Dock_X_Initial_%Gui_wid% := Edge_Dock_X_%Gui_wid%
  Edge_Dock_Y_Initial_%Gui_wid% := Edge_Dock_Y_%Gui_wid%
  Edge_Dock_Width_Initial_%Gui_wid% := Edge_Dock_Width_%Gui_wid%
  Edge_Dock_Height_Initial_%Gui_wid% := Edge_Dock_Height_%Gui_wid%
  WinGet, Edge_Dock_AlwaysOnTop_%Gui_wid%, ExStyle, ahk_id %Gui_wid% ; store AlwaysOnTop original status
  If Gui_Dock_Windows_List =
    Gui_Dock_Windows_List =%Gui_wid% ; keep track of number of docked windows
  Else
    Gui_Dock_Windows_List .="|" Gui_wid
  WinSet, AlwaysOnTop, On, ahk_id %Gui_wid%
  Gosub, Alt_Esc_Check_Alt_State ; hides alt-tab gui - shows again if alt still pressed
Gui_Dock_Windows_ReDock:
  Edge_Dock_X =
  Edge_Dock_Y =
  ; leave just 5 pixels (Edge_Dock_Border_Visible) of side visible
  If Edge_Dock_Position_%Gui_wid% contains Left
    Edge_Dock_X := - ( Edge_Dock_Width_%Gui_wid% - Edge_Dock_Border_Visible )
  Else If Edge_Dock_Position_%Gui_wid% contains Right
    Edge_Dock_X := A_ScreenWidth - Edge_Dock_Border_Visible
  If Edge_Dock_Position_%Gui_wid% contains Top
    Edge_Dock_Y := - ( Edge_Dock_Height_%Gui_wid% - Edge_Dock_Border_Visible )
  Else If Edge_Dock_Position_%Gui_wid% contains Bottom
    Edge_Dock_Y := A_ScreenHeight - Edge_Dock_Border_Visible
  WinMove, ahk_id %Gui_wid%,, %Edge_Dock_X%, %Edge_Dock_Y%

  SetTimer, Check_Mouse_Position, %Edge_Dock_Activation_Delay% ; change to affect response time to having mouse over edge-docked window
Return


Check_Mouse_Position:
  Gosub, Check_Docked_Windows_Exist
  WinGet, Previously_Active_Window_Before_Using_Docked, ID, A
  Edge_Dock_Active_Window =
  If ( Edge_Dock_%Previously_Active_Window_Before_Using_Docked% != "" ) ; check keyboard focus
    {
    CoordMode, Mouse, Screen
    MouseGetPos,Check_Mouse_Position_X, Check_Mouse_Position_Y
    Edge_Dock_Active_Window := Previously_Active_Window_Before_Using_Docked
    }
  MouseGetPos,,, Mouse_Over_Window
  If ( Edge_Dock_%Mouse_Over_Window% != "" ) ; over-ride keyboard with mouse "focus" if necessary
    {
    Edge_Dock_Active_Window := Mouse_Over_Window
    WinActivate, ahk_id %Mouse_Over_Window%
    }
  If Edge_Dock_Active_Window != ; i.e. window is already docked
    {
    SetTimer, Check_Mouse_Position, Off
    WinGet, PID_Edge_Dock_Active_Window, PID, ahk_id %Edge_Dock_Active_Window%
    Edge_Dock_X =
    Edge_Dock_Y =
    ; move window onto screen
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Left
      Edge_Dock_X =0
    Else If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Right
      Edge_Dock_X := A_ScreenWidth - Edge_Dock_Width_%Edge_Dock_Active_Window%
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Top
      Edge_Dock_Y =0
    Else If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Bottom
      Edge_Dock_Y := A_ScreenHeight - Edge_Dock_Height_%Edge_Dock_Active_Window%
    WinSet, AlwaysOnTop, Off, ahk_id %Edge_Dock_Active_Window%
    WinMove, ahk_id %Edge_Dock_Active_Window%,, %Edge_Dock_X%, %Edge_Dock_Y%
    SetTimer, Check_Mouse_Position_Deactivate, %Edge_Dock_Activation_Delay%
    }
Return

Check_Docked_Windows_Exist:
  If Gui_Dock_Windows_List = ; keep track of number of docked windows
    {
    SetTimer, Check_Mouse_Position, Off
    SetTimer, Check_Mouse_Position_Deactivate, Off
    Return
    }
  Loop, Parse, Gui_Dock_Windows_List,| ; check if windows in docked list have been closed before un-docking
    {
    IfWinNotExist, ahk_id %A_LoopField%
      {
      Gui_wid =%A_LoopField%
      Gui_Un_Dock_Window_No_Alt_Esc =1
      Gosub, Gui_Un_Dock_Window
      }
    }
Return


Check_Mouse_Position_Deactivate: ; check if not over an edge-docked window any more
  Gosub, Check_Docked_Windows_Exist

  WinGet, Style, Style, ahk_id %Edge_Dock_Active_Window%
  If ( Style & WS_DISABLED ) ; don't allow disabled windows to be re-docked (e.g., showing save box)
    Return

  ; retrieve active window focus and mouse over window - active window has priority
  WinGet, PID_Active_Window_Now, PID, A
  WinGet, Active_Window_Now_ID, ID, A
  WinGetTitle, Active_Window_Now_Title, A ; use titles to check if in same program title but over a problematic control such as xplorer2 dropdownbox (different id and pid)
  WinGetTitle, Edge_Dock_Active_Window_Title, ahk_id %Edge_Dock_Active_Window%
  WinGetTitle, Active_Window_Now_Mouse_Title, ahk_id %Active_Window_Now_Mouse%

  CoordMode, Mouse, Screen
  MouseGetPos,Active_Window_Now_Mouse_X, Active_Window_Now_Mouse_Y, Active_Window_Now_Mouse
  If ((Check_Mouse_Position_X >= Active_Window_Now_Mouse_X -10 and Check_Mouse_Position_X <= Active_Window_Now_Mouse_X +10) ; ; mouse not moved - e.g. clicked taskbar
    and (Check_Mouse_Position_Y >= Active_Window_Now_Mouse_Y -10 and Check_Mouse_Position_Y <= Active_Window_Now_Mouse_Y +10)
    and (Active_Window_Now_Title = Edge_Dock_Active_Window_Title))
      Return

  If (Active_Window_Now_Title = Edge_Dock_Active_Window_Title and Active_Window_Now_Mouse_Title = ""
        and (Active_Window_Now_ID != TaskBar_ID and Active_Window_Now_Mouse != TaskBar_ID))
      Return
  If (PID_Active_Window_Now != PID_Edge_Dock_Active_Window) ; compare pid to check that a child window is not created/active
    Gosub, Gui_Dock_Windows_ReDock_Initiate
  Else
    {
    WinGet, PID_Active_Window_Now_Mouse, PID, ahk_id %Active_Window_Now_Mouse%
    If (PID_Active_Window_Now_Mouse != PID_Edge_Dock_Active_Window)
      {
      Gosub, Gui_Dock_Windows_ReDock_Initiate
      If Gui_Dock_Windows_List contains %Previously_Active_Window_Before_Using_Docked% ; activate window under mouse to prevent looping
        WinActivate, ahk_id %Active_Window_Now_Mouse%
      Else
        WinActivate, ahk_id %Previously_Active_Window_Before_Using_Docked%
      }
    }
Return


Gui_Dock_Windows_ReDock_Initiate:
  SetTimer, Check_Mouse_Position_Deactivate, Off
  WinSet, AlwaysOnTop, On, ahk_id %Edge_Dock_Active_Window%
  WinGetPos, Edge_Dock_X_%Edge_Dock_Active_Window%, Edge_Dock_Y_%Edge_Dock_Active_Window%, Edge_Dock_Width_%Edge_Dock_Active_Window%
    , Edge_Dock_Height_%Edge_Dock_Active_Window%, ahk_id %Edge_Dock_Active_Window%
  Gui_wid =%Edge_Dock_Active_Window%
  Gosub, Gui_Dock_Windows_ReDock
Return


Gui_Un_Dock_Window:
  If Gui_Un_Dock_Window_No_Alt_Esc !=1
    Gosub, Alt_Esc_Check_Alt_State ; hides alt-tab gui - shows again if alt still pressed
  Gui_Un_Dock_Window_No_Alt_Esc = ; reset
  If ! ( Edge_Dock_AlwaysOnTop_%Gui_wid% & 0x8 ) ; 0x8 is WS_EX_TOPMOST - keep AlwaysOnTop if originally on top
    WinSet, AlwaysOnTop, Off, ahk_id %Gui_wid%
  WinMove, ahk_id %Gui_wid%,, % Edge_Dock_X_Initial_%Gui_wid%, % Edge_Dock_Y_Initial_%Gui_wid%, % Edge_Dock_Width_Initial_%Gui_wid%
    , % Edge_Dock_Height_Initial_%Gui_wid% ; original position

  ; erase variables
  Edge_Dock_%Gui_wid% =
  Edge_Dock_X_Initial_%Gui_wid% =
  Edge_Dock_Y_Initial_%Gui_wid% =
  Edge_Dock_Width_Initial_%Gui_wid% =
  Edge_Dock_Height_Initial_%Gui_wid% =
  Edge_Dock_State_%Gui_wid% =
  Edge_Dock_X_%Gui_wid% =
  Edge_Dock_Y_%Gui_wid% =
  Edge_Dock_Width_%Gui_wid% =
  Edge_Dock_Height_%Gui_wid% =
  Edge_Dock_Position_%Gui_wid% =
  Edge_Dock_AlwaysOnTop_%Gui_wid% =

  StringReplace, Gui_Dock_Windows_List, Gui_Dock_Windows_List,%Gui_wid%| ; remove entry
  If ErrorLevel =1
    StringReplace, Gui_Dock_Windows_List, Gui_Dock_Windows_List,%Gui_wid% ; last window so no delimiter to replace too
Return


Gui_Un_Dock_Windows_All:
  Loop, Parse, Gui_Dock_Windows_List,| ; check if windows in docked list have been closed before un-docking
    {
    Gui_wid := A_LoopField
    Gui_Un_Dock_Window_No_Alt_Esc =1
    Gosub, Gui_Un_Dock_Window
    }
Return


; HOTKEYS MENU SECTION:
;============================================================================================================================

Gui_Hotkeys:
  Gosub, Alt_Esc
  Gui, 2: Default ; for listview operations
  Gui, 2: Font, s10
  Gui, 2: Add, Text, xm y+15, Main hotkeys:
  Gui, 2: Font
  Gui, 2: Add, Text, x+5 yp+2, (Note that "Alt" must be either Alt, Ctrl, Shift, Win or mouse XButton1 / 2 - but using XButton requires "Shift+Tab" is a single key!)
  ; Gui_Add_Hotkey(Gui number, Text, Comment, variable name)
  Gui_Add_Hotkey(2, "Alt","(key in Alt+Tab)", "Alt_Hotkey")
    GuiControl, 2: Disable, Alt_Hotkey_Tab
    GuiControl, 2: Disable, Alt_Hotkey_Esc
    GuiControl, 2: Disable, Alt_Hotkey_Enter
    GuiControl, 2: Disable, Alt_Hotkey_WheelUp
    GuiControl, 2: Disable, Alt_Hotkey_WheelDown
    GuiControl, 2: Disable, Alt_Hotkey_Hotkey
  Gui_Add_Hotkey(2, "Tab","(key in Alt+Tab)", "Tab_Hotkey")
  Gui_Add_Hotkey(2, "Shift+Tab","(Key(s) in Alt+Shift+Tab)", "Shift_Tab_Hotkey")
  Gui_Add_Hotkey(2, "Esc","(key in Alt+Esc)", "Esc_Hotkey")
    Gui, 2: Font, s10
  Gui, 2: Add, Text,xm y+15, Single keys:
    Gui, 2: Font
  Gui, 2: Add, Text, x+5 yp+2, (Alternative way to show the Alt+Tab list by 1 key (blank for no hotkey) and another for selection)
  Gui_Add_Hotkey(2, "Alt+Tab list", "", "Single_Key_Show_Alt_Tab")
  Gui_Add_Hotkey(2, "Alt+Tab selection", "", "Single_Key_Hide_Alt_Tab")
    Gui, 2: Font, s10
  Gui, 2: Add, Text,xm y+30, Group hotkeys:
    Gui, 2: Font
  GuiControl, 2: Focus, Static1

  Gui, 2: Add, ListView, section xm r15 w470 -Multi, Group name|Assigned hotkey
  Loop, Parse, Group_List, |
    If (A_LoopField != "Settings")
  	   LV_Add("", A_LoopField, %A_LoopField%_Group_Hotkey)
  Gui, 2: Add, Button, x+10 yp+40 gGui_2_Group_Hotkey_Assign w170, Assign hotkey to selected group:
  Gui, 2: Add, Hotkey, vGui_2_Group_Hotkey xp y+5, %Hotkey%
  Gui, 2: Add, Button, xp y+30 gGui_2_Group_Hotkey_Clear w170, Clear hotkey of selected group
  Gui, 2: Add, Text, xp y+30, ( Key: !=Alt, ^=Ctrl, +=Shift, #=Win )
  Gui, 2: Add, Text, xm+250, WARNING! No error checking for hotkeys - be careful what you choose! (Delete the .ini file to reset settings)
  Gui, 2: Add, Button, xm+430 g2GuiClose w100, &Cancel
  Gui, 2: Add, Button, x+20 gGui_2_OK wp Default, &OK
  Gui, 2: Show,, Hotkeys
Return


Gui_2_Group_Hotkey_Assign:
  Gui, 2: Submit, NoHide
  Selected_Row := LV_GetNext(0, "F")
  If (! Selected_Row or ! Gui_2_Group_Hotkey)
    Return
  Loop, Parse, Group_List,|
    If %A_LoopField%_Group_Hotkey =%Gui_2_Group_Hotkey%
      {
      Msgbox, Hotkey already exists! Please clear the duplicate hotkey first.
      Return
      }
  LV_GetText(Gui_2_Group_Selected, Selected_Row)
  %Gui_2_Group_Selected%_Group_Hotkey := Gui_2_Group_Hotkey
  LV_Modify(Selected_Row, "Col2", Gui_2_Group_Hotkey)
Return


Gui_2_Group_Hotkey_Clear:
  Selected_Row := LV_GetNext(0, "F")
  If not Selected_Row
    Return
  LV_Modify(Selected_Row, "Col2", "")
Return


Gui_2_OK:
  Loop, % LV_GetCount() ; process group hotkeys from listview
    {
    LV_GetText(Group_Name, A_Index, 1)
    LV_GetText(Group_Hotkey, A_Index, 2)
    %Group_Name%_Group_Hotkey =%Group_Hotkey%
    }
  Gui, 2: Submit
  Gui, 2: Destroy
  Gui_Read_Hotkey(2, "Alt_Hotkey") ; Gui_Read_Hotkey(Gui number, associated variable)
  Gui_Read_Hotkey(2, "Tab_Hotkey")
  Gui_Read_Hotkey(2, "Shift_Tab_Hotkey")
  Gui_Read_Hotkey(2, "Esc_Hotkey")
  Gui_Read_Hotkey(2, "Single_Key_Show_Alt_Tab")
  Gui_Read_Hotkey(2, "Single_Key_Hide_Alt_Tab")
  IniFile_Data("Write")
  Reload
Return


Gui_Read_Hotkey(Gui, var_name)
{
  Global
  %var_name% =
  If %var_name%_Alt =1
    %var_name% = % %var_name% "!"
  If %var_name%_Ctrl =1
    %var_name% = % %var_name% "^"
  If %var_name%_Shift =1
    %var_name% = % %var_name% "+"
  If %var_name%_Win =1
    %var_name% = % %var_name% "#"
  If %var_name%_Tab =1
    %var_name% = % %var_name% "Tab"
  If %var_name%_Esc =1
    %var_name% = % %var_name% "Esc"
  If %var_name%_Enter =1
    %var_name% = % %var_name% "Enter"
  If %var_name%_XButton1 =1
    %var_name% = % %var_name% "XButton1"
  If %var_name%_XButton2 =1
    %var_name% = % %var_name% "XButton2"
  If %var_name%_WheelUp =1
    %var_name% = % %var_name% "WheelUp"
  If %var_name%_WheelDown =1
    %var_name% = % %var_name% "WheelDown"
  If (%var_name%_Hotkey != "None" and %var_name% = "")
    %var_name% = % %var_name% %var_name%_Hotkey
}


Gui_Add_Hotkey(Gui, Text, Comment, var_name)
{
  Local Alt, Ctrl, Shift, Win, Tab, Esc, Enter, XButton1, XButton2, WheelUp, WheelDown, Hotkey, hotkey_temp, hotkey_list__symbols, hotkey_list__symbols0, hotkey_list__vars, hotkey_list__vars0, symbol_temp, var_temp
  hotkey_temp := %var_name%

  hotkey_list__symbols =!|^|+|#|Tab|Esc|Enter|XButton1|XButton2|WheelUp|WheelDown
  hotkey_list__vars =Alt|Ctrl|Shift|Win|Tab|Esc|Enter|XButton1|XButton2|WheelUp|WheelDown
  StringSplit, hotkey_list__symbols, hotkey_list__symbols ,|
  StringSplit, hotkey_list__vars, hotkey_list__vars ,|
  Loop, %hotkey_list__symbols0%
    {
    symbol_temp := hotkey_list__symbols%A_Index%
    var_temp    := hotkey_list__vars%A_Index%
    If hotkey_temp contains %symbol_temp%
      {
      %var_temp% =1
      StringReplace, hotkey_temp, hotkey_temp, %symbol_temp%, ; remove it from list
      }
    Else
      %var_temp% =0
    }
  Hotkey=%hotkey_temp% ; remainder

  Gui, %Gui%: Font, bold
  Gui, %Gui%: Add, Text, xm, %Text%
  Gui, %Gui%: Font
  If Comment !=
    Gui, %Gui%: Add, Text, x80 yp, %Comment%
  Gui, %Gui%: Add, Checkbox, v%var_name%_Alt Checked%Alt% x200 yp, Alt
  Gui, %Gui%: Add, Checkbox, v%var_name%_Ctrl Checked%Ctrl% x+10, Ctrl
  Gui, %Gui%: Add, Checkbox, v%var_name%_Shift Checked%Shift% x+10, Shift
  Gui, %Gui%: Add, Checkbox, v%var_name%_Win Checked%Win% x+10, Win
  Gui, %Gui%: Add, Checkbox, v%var_name%_Tab Checked%Tab% x+10, Tab
  Gui, %Gui%: Add, Checkbox, v%var_name%_Esc Checked%Esc% x+10, Esc
  Gui, %Gui%: Add, Checkbox, v%var_name%_Enter Checked%Enter% x+10, Enter
  Gui, %Gui%: Add, Text, x+10, XButton:
  Gui, %Gui%: Add, Checkbox, v%var_name%_XButton1 Checked%XButton1% x+2, 1
  Gui, %Gui%: Add, Checkbox, v%var_name%_XButton2 Checked%XButton2% x+2, 2
  Gui, %Gui%: Add, Text, x+10, Wheel:
  Gui, %Gui%: Add, Checkbox, v%var_name%_WheelUp Checked%WheelUp% x+2, Up
  Gui, %Gui%: Add, Checkbox, v%var_name%_WheelDown Checked%WheelDown% x+2, Down
  Gui, %Gui%: Add, Hotkey, v%var_name%_Hotkey x+10 yp-3, %Hotkey%
}


; GROUPS MENU SECTION:
;============================================================================================================================

Gui_Window_Group_No_Filter:
  Group_Active =ALL
  Gosub, Alt_Esc_Check_Alt_State
Return


Gui_Window_Group_Load:
  Group_Active =%A_ThisMenuItem%
Gui_Window_Group_Load__part2:
  Gosub, Custom_Group__make_array_of_contents
  Gosub, Alt_Esc_Check_Alt_State ; hides alt-tab gui - shows again if alt still pressed
Return

Custom_Group__make_array_of_contents:
  Exclude_Not_In_List =
  If (Group_Active != "Settings" AND Group_Active != "ALL")
    {
    Group_Active_Contents := %Group_Active%
    If Group_Active_Contents contains Exclude_Not_In_List
      {
      Exclude_Not_In_List =1
      StringReplace, Group_Active_Contents, Group_Active_Contents, Exclude_Not_In_List|, ; remove text
      }
    StringSplit, Group_Active_, Group_Active_Contents,|
    }
Return

Gui_Window_Group_Save_Edit:
  Gosub, Alt_Esc
  Gui, 3: Default ; for listview operations
  Gui, 3: Add, Text, y+15,
(
Choose window titles/exes to include/exclude when LOADING a list:

  - Double-click / F2 to rename an entry.
  - Titles match anywhere within a target window's title or parent's title (exe is ignored).
  - Delete the title completely to match the EXE instead.
  - To EXCLUDE a window, prefix title or EXE with an exclamation: e.g. !notepad.exe, or only ! in title column.
  - "Exclude all windows not in list?" ignores new windows that do not match the list.
  - Only ticked items are added to the list. Unticked are removed.
  - Priority of rules is top (highest) to bottom (lowest).
  - Not case sensitive.
)

  Gui, 3: Add, ListView, xm y+15 r15 w500 Checked -ReadOnly -Multi NoSortHdr AltSubmit gListView3_Event, (Partial) Window Title|EXE
    Gui_3_ImageList:= IL_Create(15,5,0)
    LV_SetImageList(Gui_3_ImageList, 1)
    IL_Add( Gui_3_ImageList, "shell32.dll" , 110) ; not included icon

  Gui, 3: Add, Picture, icon48 x+10 yp+100 gGui_3_ListView_Swap_Rows_Up, C:\WINDOWS\system32\progman.exe ; up arrow
  Gui, 3: Add, Picture, icon45 gGui_3_ListView_Swap_Rows_Down, C:\WINDOWS\system32\progman.exe ; down arrow
  Gui, 3: Add, Text, xm+20, Manual add:
  Gui_3_Manual_Allow_Blank =1
  Gui, 3: Add, Edit, x+5 w200 gGui_3_Manual_Exe_Blank vGui_3_Manual_Title, [window title]
  Gui, 3: Add, Edit, x+5 w100 gGui_3_Manual_Title_Blank vGui_3_Manual_Exe, [program.exe]
  Gui, 3: Add, Button, x+10 w80 gGui3_Manual_Add, A&dd
  Gui, 3: Add, Text, xm+20 y+30, Group name:

  Gui, 3: Add, ComboBox, x+5 w200 vCustom_Name, %Group_List%
    GuiControl, ChooseString, Custom_Name, %Group_Active%
  Gui, 3: Add, Checkbox, x+20 vExclude_Not_In_List Checked, Exclude all windows not in list?
  If %Group_Active% not contains Exclude_Not_In_List
    GuiControl,, Exclude_Not_In_List, 0 ; check box

  Gui, 3: Add, Button, xm+10 y+20 w80 gGui3_RESET, &Reset List
  Gui, 3: Add, Button, x+20 wp gGui3_SelectALL, Select &All
  Gui, 3: Add, Button, x+20 wp gGui3_SelectNONE, Select &None
  Gui, 3: Add, Button, x+20 wp g3GuiClose, &Cancel
  Gui, 3: Add, Button, x+20 wp Default gGui3_OK, &OK

  If (Global_Include_Edit or Global_Exclude_Edit)
    {
    GuiControl, 3: Disable, Exclude_Not_In_List
    GuiControl, 3: Disable, Custom_Name
    }

  If Global_Include_Edit =1
    Gui_3_Listview_Populate("Global_Include")
  Else If Global_Exclude_Edit =1
    Gui_3_Listview_Populate("Global_Exclude")

  Else If (Group_Active = "Settings" OR Group_Active = "ALL")
    Loop, %Window_Found_Count% ; populate listview
      LV_Add("Check Icon2", Title%A_Index%, Exe_Name%A_Index%) ; Icon 1 = not included icon, Icon 2 = blank
  Else
    Gui_3_Listview_Populate(Group_Active)
  Gosub, Gui_3_Update_Icons

  DetectHiddenWindows, On
  Gui, 3: +LastFound
  Gui_3_ID := WinExist() ; for auto-sizing columns later
  LV_ModifyCol(1, 350)
  ControlGet, Gui_3_Listview_Style, Style,, SysListView321, ahk_id %Gui_3_ID%
  If ( Gui_3_Listview_Style & WS_VSCROLL ) ; has a vertical scrollbar - reduced width for listview
    Gui_3_Col_2_w := 500 - 350 - Scrollbar_Vertical_Thickness - 4
  Else
    Gui_3_Col_2_w := 500 - 350 - 4
  LV_ModifyCol(2, Gui_3_Col_2_w)
  Gui, 3: Show,, Group - Save/Edit
Return


Gui_3_Listview_Populate(list)
{
  Global
  Loop, Parse, %list%,|
    {
    If A_LoopField =Exclude_Not_In_List
      Continue
    If A_LoopField contains .exe
      LV_Add("Check Icon2" ,"", A_LoopField) ; Icon 1 = not included icon, Icon 2 = blank
    Else
      LV_Add("Check Icon2" ,A_LoopField,"") ; Icon 1 = not included icon, Icon 2 = blank
    }
}


Gui_3_ListView_Swap_Rows_Up:
  ListView_Swap_Rows("Up") ; "move" selected row up 1 - higher priority
Return


Gui_3_ListView_Swap_Rows_Down:
  ListView_Swap_Rows("Down") ; "move" selected row down 1 - lower priority
Return


ListView_Swap_Rows(Direction) ; Direction=Up/Down -swaps all text in each column of 2 adjacent rows and their checked states
{
  Row_Selected := LV_GetNext("Focused")
  If Row_Selected =0 ; no row selected
    {
    LV_Modify(1, "Select Focus")
    Return
    }
  If Direction =Up
    {
    Row_Swap_With := Row_Selected -1
    If Row_Swap_With =0 ; reached top of listview
      Return
    }
  Else
    {
    Row_Swap_With := Row_Selected +1
    If ( Row_Swap_With > LV_GetCount() ) ; reached end of listview
      Return
    }
  Loop, % LV_GetCount("Col")
    {
    LV_GetText(Row_Text_%Row_Selected%_%A_Index%, Row_Selected, A_Index)
    LV_GetText(Row_Text_%Row_Swap_With%_%A_Index%, Row_Swap_With, A_Index)
    }
  If ( LV_GetNext(Row_Selected - 1, "C") = Row_Selected ) ; save box checked states
    Row_Selected_Checked =Check
  Else
    Row_Selected_Checked =-Check
  If ( LV_GetNext(Row_Swap_With - 1, "C") = Row_Swap_With )
    Row_Swap_With_Checked =Check
  Else
    Row_Swap_With_Checked =-Check
  Loop, % LV_GetCount("Col")
    {
    LV_Modify(Row_Selected, Row_Swap_With_Checked . " -Focus -Select Col" . A_Index, Row_Text_%Row_Swap_With%_%A_Index%)
    LV_Modify(Row_Swap_With, Row_Selected_Checked . " Focus Select Vis Col" . A_Index, Row_Text_%Row_Selected%_%A_Index%)
    }
  Gosub, Gui_3_Update_Icons
}


Gui3_OK:
  Gui, 3: Submit

  If Global_Include_Edit
    {
    Custom_Name =Global_Include
    Exclude_Not_In_List =
    }
  Else If Global_Exclude_Edit
    {
    Custom_Name =Global_Exclude
    Exclude_Not_In_List =
    }

  If (Custom_Name = "" OR Custom_Name = "Settings" OR Custom_Name = "ALL")
    {
    MsgBox, 48, ERROR, Enter a valid name for the group!
    Gui, 3: Show
    Return
    }
  StringReplace, Custom_Name, Custom_Name,%A_Space%,_,All

  If Exclude_Not_In_List =1 ; checked - add suffix to variable name to filter
    %Custom_Name% = |Exclude_Not_In_List ; add first entry - will parse and process when filtering alt-tab listview
  Else
    %Custom_Name% = ; make sure it is empty in case it previously existed (over-writing)
  RowNumber = 0 ; init
  Loop
    {
  	RowNumber := LV_GetNext(RowNumber, "C")  ; Resume the search at the row after that found by the previous iteration.
  	If not RowNumber  ; The above returned zero, so there are no more checked rows.
  		Break
  	LV_GetText(Title_temp, RowNumber)
  	If Title_temp = ; blank therefore set the exe name instead
    	LV_GetText(Title_temp, RowNumber, 2)
  	If Title_temp =! ; exclude exe name instead
      {
    	LV_GetText(Title_temp, RowNumber, 2)
    	If Title_temp not contains !
      	Title_temp =!%Title_temp%
    	}
    %Custom_Name% .= "|" . Title_temp
    }
  StringTrimLeft, %Custom_Name%, %Custom_Name%, 1 ; trim initial |
  If ! (Global_Include_Edit or Global_Exclude_Edit)
    {
    If Group_List not contains %Custom_Name%
      Group_List .= "|" Custom_Name ; store name to a list for finding later
    Group_Active := Custom_Name ; automatically apply the saved group filter
    }
  Gosub, 3GuiClose
  IniFile_Data("Write")
  Global_Include_Edit = ; reset
  Global_Exclude_Edit =
  Gosub, Alt_Esc_Check_Alt_State ; hides alt-tab gui - shows again if alt still pressed
Return


ListView3_Event:
  If A_GuiEvent = E ; edited a row
    Gosub, Gui_3_Update_Icons
  If A_GuiEvent = DoubleClick
     SendMessage, 0x1017, LV_GetNext(0, "Focused") - 1, 0, SysListView321  ; 0x1017 is LVM_EDITLABEL
Return


Gui_3_Update_Icons:
  Loop, % LV_GetCount()
    {
    Gui_3_Row_To_Modify := A_Index
    Gui_3_Icon =2 ; blank icon as default
    Loop, 2 ; check column 1 and 2
      {
      LV_GetText(Title_temp, Gui_3_Row_To_Modify, A_Index)
      If Title_temp contains !
        Gui_3_Icon =1 ; not included icon
      }
    LV_Modify(Gui_3_Row_To_Modify, "Icon" . Gui_3_Icon)
    }
Return


Gui3_Manual_Add:
  Gui, 3: Submit, NoHide
  Gui_3_Manual_Allow_Blank =1
  Gosub, Gui_3_Manual_Title_Blank
  Gui_3_Manual_Allow_Blank =1
  Gosub, Gui_3_Manual_Exe_Blank
  Gui_3_Icon =2 ; blank icon
  If Gui_3_Manual_Title contains !
    Gui_3_Icon =1 ; not included icon
  If Gui_3_Manual_Exe contains !
    Gui_3_Icon =1
  LV_Add("Check Icon" . Gui_3_Icon,Gui_3_Manual_Title,Gui_3_Manual_Exe)
  GuiControl, Focus, &OK
  Sleep, 50
  GuiControl, +Default, &OK
Return


Gui3_RESET:
  Gui, 3: Destroy
  Gosub, Gui_Window_Group_Save_Edit
Return


Gui3_SelectALL:
  Loop, %Window_Found_Count%
    LV_Modify(A_Index, "Check")
Return


Gui3_SelectNONE:
  Loop, %Window_Found_Count%
    LV_Modify(A_Index, "-Check")
Return


Gui_3_Manual_Title_Blank:
  If Gui_3_Manual_Allow_Blank =1
    GuiControl,, Gui_3_Manual_Title, ; blank
  Gui_3_Manual_Allow_Blank =0
  GuiControl, +Default, A&dd
Return


Gui_3_Manual_Exe_Blank:
  If Gui_3_Manual_Allow_Blank =1
    GuiControl,, Gui_3_Manual_Exe, ; blank
  Gui_3_Manual_Allow_Blank =0
  GuiControl, +Default, A&dd
Return



Gui_Window_Group_Global_Include:
  Global_Include_Edit =1
  Gosub, Gui_Window_Group_Save_Edit
  Return
Gui_Window_Group_Global_Exclude:
  Global_Exclude_Edit =1
  Gosub, Gui_Window_Group_Save_Edit
Return


Gui_Window_Group_Delete:
  If Group_Active =%A_ThisMenuItem%
    Group_Active = ALL

  StringReplace, temp_List, Group_List, %A_ThisMenuItem% ; remove item from list
  Group_List =
  Loop, Parse, temp_List,|
    If A_LoopField
      Group_List .= "|" A_LoopField
  StringTrimLeft, Group_List, Group_List, 1 ; remove leading |

  Hotkey, % %A_ThisMenuItem%_Group_Hotkey, Off, UseErrorLevel
  IniDelete, Alt_Tab_Settings.ini, Groups, %A_ThisMenuItem%
  IniDelete, Alt_Tab_Settings.ini, Groups, %A_ThisMenuItem%_Group_Hotkey
  Gosub, Alt_Esc_Check_Alt_State ; hides alt-tab gui - shows again if alt still pressed
Return


Group_Hotkey: ; from loading ini file - determine hotkey behaviour based on current hotkey
  Group_Active_Before := Group_Active
  Loop, Parse, Group_List,|
    {
    If %A_LoopField%_Group_Hotkey =%A_ThisHotkey% ; find which group to activate
      {
      If Group_Active !=%A_LoopField%
        {
        Group_Active=%A_LoopField% ; load custom group
        Gosub, Custom_Group__make_array_of_contents
        }
      ; check if currently active window is in the newly loaded group, else switch to 1st
      Gosub, Single_Key_Show_Alt_Tab ; show list to generate updated variables to check
      Viewed_Window_List .="|" Active_ID
      Loop, %Window_Found_Count% ; abort switching and start to cycle through windows in list next
        {
        If (! InStr(Viewed_Window_List, Window%A_Index%) or Window_Found_Count <=1)
          {
          Gosub, ListView_Destroy
          WinActivate, % "ahk_id" Window%A_Index%
          If A_Index =%Window_Found_Count%
            Viewed_Window_List = ; viewed all windows so reset list
          Break
          }
        }
      Break
      }
    }
  Group_Active := Group_Active_Before
Return


MButton_Close:
  MButton_Clicked =1
  MouseGetPos,,, Mouse_Over_Gui
  If Mouse_Over_Gui =%Gui_ID% ; check to be safe
    {
    SetTimer, MButton_Close_Cont, 50
    Click, Left
    ; weird pause after left click - hence using timers - continues after moving mouse
    }
  MButton_Clicked =
Return

MButton_Close_Cont:
  SetTimer, MButton_Close_Cont, Off
  Get__Selected_Row_and_RowText()
  Gui_wid =% Window%RowText%
  If Gui_wid ; prevent error if nothing was selected due to delay in program
    Gosub, End_Process_Single
Return


End_Process_Single:
  Gosub, GuiControl_Disable_ListView1
  Selected_Row ++ ; find window after window to close for positioning focus in listview afterwards
  LV_GetText(RowText, Selected_Row, 2)  ; Get the row's hidden text
  Window_After_1st_Ending_Window_ID := Window%RowText%
  Gosub, End_Process_Subroutine
  Gosub, End_Process_Update_Listview
Return


End_Process_Subroutine:
  Loop, Parse, Gui_Dock_Windows_List,| ; un-dock docked window first (might remember off-screen position)
    If A_LoopField =%Gui_wid%
      {
      Gui_Un_Dock_Window_No_Alt_Esc =1
      Gosub, Gui_Un_Dock_Window
      }
  PostMessage, 0x112, 0xF060,,, ahk_id %Gui_wid% ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
  WinWaitClose, ahk_id %Gui_wid%,, 1
Return


End_Process_All_Instances:
  Gosub, GuiControl_Disable_ListView1
  List_of_Process_To_End = ; need to store list now as re-drawing the listview over-writes necessary variables
  Loop, %Window_Found_Count%
    {
    If Dialog%A_Index% ; don't try to close dialog windows (e.g. save prompts)
      Continue
    If Exe_Name%RowText% = % Exe_Name%A_Index%
      List_of_Process_To_End .= "|" . Window%A_Index%
    }
  StringTrimLeft, List_of_Process_To_End, List_of_Process_To_End, 1 ; remove 1st | character (empty reference otherwise)

  Window_After_1st_Ending_Window_ID := Selected_Row + 1 ; find window after window to close for positioning focus in listview afterwards
  LV_GetText(RowText, Window_After_1st_Ending_Window_ID, 2)  ; Get the row's hidden text
  Window_After_1st_Ending_Window_ID =% Window%RowText% ; over-ridden below if necessary
  If Exe_Name%RowText% = % Exe_Name%Selected_Row% ; find an earlier window which won't be closed
    {
    Loop, %Window_Found_Count%
      {
      Window_After_1st_Ending_Window_ID := Selected_Row + 1 + A_Index
      If Window_After_1st_Ending_Window_ID =% Window_Found_Count
        {
        LV_GetText(RowText, %Window_Found_Count%, 2)  ; Get the row's hidden text
        If RowText not between 1 and %Window_Found_Count% ; avoid an error when closing all windows
          Break
        Window_After_1st_Ending_Window_ID =% Window%RowText%
        Break
        }
      LV_GetText(RowText, Window_After_1st_Ending_Window_ID, 2)  ; Get the row's hidden text
      If Exe_Name%RowText% != % Exe_Name%Selected_Row% ; find an earlier window which won't be closed
        {
        Window_After_1st_Ending_Window_ID =% Window%RowText%
        Break
        }
      }
    }
  Loop, Parse, List_of_Process_To_End,|
    {
    Gui_wid := A_LoopField
    Gosub, End_Process_Subroutine
    }
  List_of_Process_To_End = ; reset
  Gosub, End_Process_Update_Listview
Return


End_Process_Update_Listview:
  Gosub, Display_List
  Loop, %Window_Found_Count%
    {
    If Window%A_Index% =%Window_After_1st_Ending_Window_ID%
      {
      LV_GetText(RowText, A_Index, 2)  ; Get the row's hidden text
      LV_Modify(RowText, "Focus Select Vis")
      }
    }
  Gosub, GuiControl_Enable_ListView1
Return


Key_Pressed_1st_Letter:
  Key_Pressed_ASCII =%A_EventInfo%
  Get__Selected_Row_and_RowText()

  If Key_Pressed_ASCII =93 ; Alt+Apps key - context menu
    {
    Gosub, GuiContextMenu
    Return
    }

  If (Key_Pressed_ASCII =40) ; Down arrow
    {
    GoSub Alt_Tab
    Return
    }
  If (Key_Pressed_ASCII =38) ; Up arrow
    {
    GoSub Alt_Shift_Tab
    Return
    }

  ; \ key - close window
  If (Key_Pressed_ASCII =92 or Key_Pressed_ASCII =220) ; \ or Alt+\
    {
    If ( A_TickCount - Time_Since_Last_Alt_Close < 200 ) ; prevention of accidentally closing too many windows
      Return
    Time_Since_Last_Alt_Close := A_TickCount
    Gui_wid := Window%RowText%
    Gosub, End_Process_Single
    Return
    }

  ; / key - close all instances of exe
  If (Key_Pressed_ASCII =47 or Key_Pressed_ASCII =191) ; / or Alt+/
    {
    If ( A_TickCount - Time_Since_Last_Alt_Close < 200 ) ; prevention of accidentally closing too many windows
      Return
    Time_Since_Last_Alt_Close := A_TickCount
    Gui_wid := Window%RowText%
    Gosub, End_Process_All_Instances
    Return
    }

  Loop, %Window_Found_Count%
    {
    Selected_Row +=1
    If Selected_Row > %Window_Found_Count% ; wrap around to start
      Selected_Row =1
    LV_GetText(List_Title_Text, Selected_Row, 2) ; hidden number column

    ; Check for parent's title for typing first letter
    If Window_Parent%List_Title_Text% !=
      WinGetTitle, List_Title_Text, % "ahk_id " Window_Parent%List_Title_Text%
    Else
      WinGetTitle, List_Title_Text, % "ahk_id " Window%List_Title_Text%
    StringUpper, List_Title_Text, List_Title_Text ; need to match against upper case when alt is held down
    List_Title_Text:=Asc(List_Title_Text) ; convert to ASCII key code

    If Key_Pressed_ASCII =%List_Title_Text%
      {
      LV_Modify(Selected_Row, "Focus Select Vis")
      Break
      }
    }
Return


ColumnClickSort(Col, Update="") ; Col = column clicked on, Update = 1 if true else blank (apply only, not change order)
{
  Global
  If Update=
    {
    If ((Sort_By_Direction = "Sort") and (Col = Sort_By_Column)) ; opposite sort direction - unless choosing a new column
      {
      Sort_By_Direction =SortDesc
      Sort_Direction_Symbol =[-]
      }
    Else
      {
      Sort_By_Direction =Sort
      Sort_Direction_Symbol =[+]
      }
    }
  Loop, %Col_Title0% ; reset column titles to remove [+] or [-] suffix
    {
    Col_Title_temp := Col_Title%A_Index%
    LV_ModifyCol(A_Index,"", Col_Title_temp)
    }
  If (Col ="1" or Col ="2") ; Col 1 sorts using Col 2 (hidden)
    {
    LV_ModifyCol(2, Sort_By_Direction)
    LV_ModifyCol(1,"", Col_Title1 " " Sort_Direction_Symbol)
    }
  Else
    LV_ModifyCol(Col, Sort_By_Direction, Col_Title%Col% " " Sort_Direction_Symbol)
  If Update=1
    Return
  Sort_By_Column := Col ; store
  Display_List_Shown =0 ; set to execute update of listview widths
  Gosub, Gui_Resize_and_Position
  Display_List_Shown =1
}


ListView_Destroy:
  SetTimer, Check_Alt_Hotkey2_Up, Off
  SetTimer, SB_Update__CPU, Off
  SetTimer, SB_Update__ProcessCPU, Off
  If Single_Key_Show_Alt_Tab_Used =1
    {
    Send, {%Alt_Hotkey2% up}
    Hotkey, *%Single_Key_Hide_Alt_Tab%, Off
    Single_Key_Show_Alt_Tab_Used = ; reset
    }
  Hotkeys_Toggle_Temp_Hotkeys("Off") ; (state = "On" or "Off")
  Gui, 1: Default
  If Alt_Esc != 1 ; i.e. not called from Alt_Esc
    Get__Selected_Row_and_RowText()
  Display_List_Shown =0
  If Status%RowText% =Not Responding ; do not activate a Not Responding window (O/S unstable)
    Alt_Esc =1
  If Alt_Esc != 1 ; i.e. not called from Alt_Esc
    {
    wid := Window%RowText%
    hw_popup := hw_popup%RowText%
    WinGet, wid_MinMax, MinMax, ahk_id %wid%
    If wid_MinMax =-1 ;minimised
      WinRestore, ahk_id %wid%
    If hw_popup
      WinActivate, ahk_id %hw_popup%
    Else
      WinActivate, ahk_id %wid%
    }
  Else If Alt_Esc =1 ; WM_ACTIVATE - clicked outside alt-tab gui 1
    WinActivate, ahk_id %Active_ID%
  Gui, 1: Destroy ; destroy after switching to avoid re-activation of some windows
  LV_ColorChange() ; clear all highlighting
  OnTop_Found = ; reset
  Status_Found = ; reset
  Alt_Esc = ; reset
Return


Get_Window_Icon(wid, Use_Large_Icons_Current) ; (window id, whether to get large icons)
{
  Local NR_temp, h_icon
  Window_Found_Count += 1
  ; check status of window - if window is responding or "Not Responding"
  NR_temp =0 ; init
  h_icon =
  Responding := DllCall("SendMessageTimeout", "UInt", wid, "UInt", 0x0, "Int", 0, "Int", 0, "UInt", 0x2, "UInt", 150, "UInt *", NR_temp) ; 150 = timeout in millisecs
  If (Responding)
    {
    ; WM_GETICON values -    ICON_SMALL =0,   ICON_BIG =1,   ICON_SMALL2 =2
    If Use_Large_Icons_Current =1
      {
      SendMessage, 0x7F, 1, 0,, ahk_id %wid%
      h_icon := ErrorLevel
      }
    If ( ! h_icon )
      {
      SendMessage, 0x7F, 2, 0,, ahk_id %wid%
      h_icon := ErrorLevel
        If ( ! h_icon )
          {
          SendMessage, 0x7F, 0, 0,, ahk_id %wid%
          h_icon := ErrorLevel
          If ( ! h_icon )
            {
            If Use_Large_Icons_Current =1
              h_icon := DllCall( "GetClassLong", "uint", wid, "int", -14 ) ; GCL_HICON is -14
            If ( ! h_icon )
              {
              h_icon := DllCall( "GetClassLong", "uint", wid, "int", -34 ) ; GCL_HICONSM is -34
              If ( ! h_icon )
                h_icon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 ) ; IDI_APPLICATION is 32512
              }
            }
          }
        }
      }
  If ! ( h_icon = "" or h_icon = "FAIL") ; Add the HICON directly to the icon list
  	Gui_Icon_Number := DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, h_icon)
  Else	; use a generic icon
  	Gui_Icon_Number := IL_Add(ImageListID1, "shell32.dll" , 3)
}


2GuiClose:
2GuiEscape:
  Gui, 2: Destroy
  Gui, 1: Default
Return

3GuiClose:
3GuiEscape:
  Gui, 3: Destroy
  Gui, 1: Default
Return


IniFile_Data(Read_or_Write)
{
  Global
  IniFile_Read_or_Write := Read_or_Write ; store
; Hotkeys
  IniFile("Alt_Hotkey",               "Hotkeys", "!")
  IniFile("Tab_Hotkey",               "Hotkeys", "Tab")
  IniFile("Shift_Tab_Hotkey",         "Hotkeys", "+Tab")
  IniFile("Esc_Hotkey",               "Hotkeys", "Esc")
  IniFile("Single_Key_Show_Alt_Tab",  "Hotkeys", "")
  IniFile("Single_Key_Hide_Alt_Tab",  "Hotkeys", "Enter")

; Sort_Order
  IniFile("Sort_By_Column",           "Sort_Order", "2") ; initial column to sort (2 is a hidden column)
  IniFile("Sort_By_Direction",        "Sort_Order", "Sort") ; initial sort direction
  IniFile("Sort_Direction_Symbol",    "Sort_Order", "[+]") ; initial sort direction

; Groups + Group_Hotkey - remember lists of windows
  IniFile("Group_List",               "Groups", "Settings|ALL")
  If ! (Global_Include_Edit or Global_Exclude_Edit)
  IniFile("Global_Include",           "Groups", "")
  IniFile("Global_Include",           "Groups", "")
  IniFile("Group_Active",             "Groups", "ALL")
  Loop, Parse, Group_List,|
    {
    IniFile(A_LoopField,                  "Groups", "")
    IniFile(A_LoopField . "_Group_Hotkey","Groups", "")
    If %A_LoopField%_Group_Hotkey
      {
      Hotkey_temp := A_LoopField . "_Group_Hotkey"
      Hotkey, % %Hotkey_temp%, Group_Hotkey, On
      }
    }
}
Return

IniFile(Var, Section, Default="")
{
  Global
  If IniFile_Read_or_Write =Read
    {
    IniRead, %Var%, Alt_Tab_Settings.ini, %Section%, %Var%, %Default%
    If %Var% =ERROR
      %Var% = ; set to blank value instead of "error"
    }
  Else If IniFile_Read_or_Write =Write
    IniWrite, % %Var%, Alt_Tab_Settings.ini, %Section%, %Var%
}


;============================================================================================================================


Replace_Modifier_Symbol( Variable_Name , New_Variable_Name )
{
  ; replace 1st modifier symbol in Alt_Hotkey,etc with its equivalent text (for hotkey up event compatability)
  Global
  %New_Variable_Name% :=%Variable_Name%
  StringReplace, %New_Variable_Name%, %New_Variable_Name%,#,LWin
  StringReplace, %New_Variable_Name%, %New_Variable_Name%,!,Alt
  StringReplace, %New_Variable_Name%, %New_Variable_Name%,^,Control
  StringReplace, %New_Variable_Name%, %New_Variable_Name%,+,Shift
  StringReplace, %New_Variable_Name%, %New_Variable_Name%,%A_Space%&%A_Space%, ; remove & for hotkeys like XButton1
}


ListView_Resize_Vertically(Gui_ID) ; Automatically resize listview vertically
{
  Global Window_Found_Count, lv_h_win_2000_adj
  SendMessage, 0x1000+31, 0, 0, SysListView321, ahk_id %Gui_ID% ; LVM_GETHEADER
  WinGetPos,,,, lv_header_h, ahk_id %ErrorLevel%
  VarSetCapacity( rect, 16, 0 )
  SendMessage, 0x1000+14, 0, &rect, SysListView321, ahk_id %Gui_ID% ; LVM_GETITEMRECT ; LVIR_BOUNDS
  y1 := 0
  y2 := 0
  Loop, 4
    {
    y1 += *( &rect + 3 + A_Index )
    y2 += *( &rect + 11 + A_Index )
    }
  lv_row_h := y2 - y1
  lv_h := 4 + lv_header_h + ( lv_row_h * Window_Found_Count ) + lv_h_win_2000_adj
  GuiControl, Move, SysListView321, h%lv_h%
}


GetCPA_file_name( p_hw_target ) ; retrives Control Panel applet icon
{
   WinGet, pid_target, PID, ahk_id %p_hw_target%
   hp_target := DllCall( "OpenProcess", "uint", 0x18, "int", false, "uint", pid_target )
   hm_kernel32 := DllCall( "GetModuleHandle", "str", "kernel32.dll" )
   pGetCommandLineA := DllCall( "GetProcAddress", "uint", hm_kernel32, "str", "GetCommandLineA" )
   buffer_size = 6
   VarSetCapacity( buffer, buffer_size )
   DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pGetCommandLineA, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   loop, 4
      ppCommandLine += ( ( *( &buffer+A_Index ) ) << ( 8*( A_Index-1 ) ) )
   buffer_size = 4
   VarSetCapacity( buffer, buffer_size, 0 )
   DllCall( "ReadProcessMemory", "uint", hp_target, "uint", ppCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   loop, 4
      pCommandLine += ( ( *( &buffer+A_Index-1 ) ) << ( 8*( A_Index-1 ) ) )
   buffer_size = 260
   VarSetCapacity( buffer, buffer_size, 1 )
   DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   DllCall( "CloseHandle", "uint", hp_target )
   IfInString, buffer, desk.cpl ; exception to usual string format
     return, "C:\WINDOWS\system32\desk.cpl"

   ix_b := InStr( buffer, "Control_RunDLL" )+16
   ix_e := InStr( buffer, ".cpl", false, ix_b )+3
   StringMid, CPA_file_name, buffer, ix_b, ix_e-ix_b+1
   if ( ix_e )
      return, CPA_file_name
   else
      return, false
}


;============================================================================================================================

WM_ACTIVATE(wParam)
{
  Global
  If ( wParam =0 and A_Gui =1 and Display_List_Shown =1) ; i.e. don't trigger when submitting gui
    {
    Alt_Esc =1
    Gosub, Alt_Esc ; hides alt-tab gui
    }
}


OnExit_Script_Closing:
  IniFile_Data("Write")
  Gui_Un_Dock_Windows_All_No_Alt_Esc = 1
  Gosub, Gui_Un_Dock_Windows_All
  ExitApp
Return


;============================================================================================================================
; Listview color highlighting functions
;============================================================================================================================

LV_ColorInitiate() ; initiate listview color change procedure
{
  global
  ; MUST include HWNDhw_LV_ColorChange when creating listview (Gui, Add, ListView, ... HWNDhw_LV_ColorChange)
  VarSetCapacity(LvItem, 36, 0)
  OnMessage( 0x4E, "WM_NOTIFY" )
}


LV_ColorChange(Index="", TextColor="", BackColor="") ; change specific line's color or reset all lines
{
  global
  If Index =
    Loop, %Window_Found_Count% ; or use another count if listview not visible
      LV_ColorChange(A_Index)

  Else
    {
    Line_Color_%Index%_Text := TextColor
    Line_Color_%Index%_Back := BackColor
    WinSet, Redraw,, ahk_id %hw_LV_ColorChange%
    }
}


WM_NOTIFY( p_w, p_l, p_m )
{
  local draw_stage, Current_Line, Index, IsSelected=0
  Critical
  if ( DecodeInteger( "uint4", p_l, 0 ) = hw_LV_ColorChange ) {      ; NMHDR->hwndFrom
     if ( DecodeInteger( "int4", p_l, 8 ) = -12 ) {                ; NMHDR->code ; NM_CUSTOMDRAW
       draw_stage := DecodeInteger( "uint4", p_l, 12 )                     ; NMCUSTOMDRAW->dwDrawStage
      Current_Line := DecodeInteger( "uint4", p_l, 36 )+1               ; NMCUSTOMDRAW->dwItemSpec
      if ( draw_stage = 1 )                                       ; CDDS_PREPAINT
        return, 0x20                                              ; CDRF_NOTIFYITEMDRAW
      else if ( draw_stage = 0x10000|1 ) {                        ; CDDS_ITEMPREPAINT
           If ( DllCall("GetFocus") = hw_LV_ColorChange ) {                ; Control has Keyboard Focus?
               SendMessage, 4140, Current_Line-1, 2, , ahk_id %hw_LV_ColorChange% ; LVM_GETITEMSTATE
               IsSelected := ErrorLevel
               If ( IsSelected = 2 ) {                                                 ; LVIS_SELECTED
; custom selected color highlighting
                  EncodeInteger( Listview_Colour_Selected_Text, 4, p_l, 48 )           ; NMCUSTOMDRAW->clrText ; foreground
                  EncodeInteger( Listview_Colour_Selected_Back, 4, p_l, 52 )           ; NMCUSTOMDRAW->clrTextBk ; background
                   EncodeInteger(0x0, 4, &LvItem, 12)                            ; LVITEM->state
                  EncodeInteger(0x2, 4, &LvItem, 16)                            ; LVITEM->stateMask ; LVIS_SELECTED
                SendMessage, 4139, Current_Line-1, &LvItem, , ahk_id %hw_LV_ColorChange% ; Disable Highlighting
                ; We want item post-paint notifications
                Return, 0x00000010                                                    ; CDRF_NOTIFYPOSTPAINT
              }
            ; change the 3rd parameter in the line below if the line number isn't in the 2nd column!
              LV_GetText(Index, Current_Line, 2)
              If (Line_Color_%Index%_Text != "") {
              EncodeInteger( Line_Color_%Index%_Text, 4, p_l, 48 ) ; NMLVCUSTOMDRAW->clrText ; foreground
              EncodeInteger( Line_Color_%Index%_Back, 4, p_l, 52 ) ; NMLVCUSTOMDRAW->clrTextBk ; background
           }
           }
        }
        else if ( draw_stage = 0x10000|2 )                  ; CDDS_ITEMPOSTPAINT
            If ( IsSelected ) {
               EncodeInteger(0x02, 4, &LvItem, 12)            ; LVITEM->state
               EncodeInteger(0x02, 4, &LvItem, 16)            ; LVITEM->stateMask ; LVIS_SELECTED
               SendMessage, 4139, Current_Line-1, &LvItem, , ahk_id %hw_LV_ColorChange% ; LVM_SETITEMSTATE
            }
    }
  }
}


;============================================================================================================================
; MISC
;============================================================================================================================

Decimal_to_Hex(var)
{
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}


DecodeInteger( p_type, p_address, p_offset, p_hex=true )
{
  old_FormatInteger := A_FormatInteger
  ifEqual, p_hex, 1, SetFormat, Integer, hex
  else, SetFormat, Integer, dec
  StringRight, size, p_type, 1
  loop, %size%
      value += *( ( p_address+p_offset )+( A_Index-1 ) ) << ( 8*( A_Index-1 ) )
  if ( size <= 4 and InStr( p_type, "u" ) != 1 and *( p_address+p_offset+( size-1 ) ) & 0x80 )
      value := -( ( ~value+1 ) & ( ( 2**( 8*size ) )-1 ) )
  SetFormat, Integer, %old_FormatInteger%
  return, value
}

EncodeInteger( p_value, p_size, p_address, p_offset )
{
  loop, %p_size%
    DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) )
}


RGBtoBGR(oldValue)
{
  return (oldValue & 0x00ff00) + ((oldValue & 0xff0000) >> 16) + ((oldValue & 0x0000ff) << 16)
}


GetProcessTimes(pid)    ; Individual CPU Load of the process with pid
{
  Static oldKrnlTime, oldUserTime
  Static newKrnlTime, newUserTime
  Static PreviousPID

  oldKrnlTime := newKrnlTime
  oldUserTime := newUserTime

  hProc := DllCall("OpenProcess", "Uint", 0x400, "int", 0, "Uint", pid)
  DllCall("GetProcessTimes", "Uint", hProc, "int64P", CreationTime, "int64P", ExitTime, "int64P", newKrnlTime, "int64P", newUserTime)
  DllCall("CloseHandle", "Uint", hProc)
  If (PreviousPID != pid)
    {
    PreviousPID := pid
    Return 0 +0.0
    }
  Return (newKrnlTime-oldKrnlTime + newUserTime-oldUserTime)/10000000 * 100   ; 1sec: 10**7
}

GetSystemTimes()    ; Total CPU Load
{
  Static oldIdleTime, oldKrnlTime, oldUserTime
  Static newIdleTime, newKrnlTime, newUserTime

  oldIdleTime := newIdleTime
  oldKrnlTime := newKrnlTime
  oldUserTime := newUserTime

  DllCall("GetSystemTimes", "int64P", newIdleTime, "int64P", newKrnlTime, "int64P", newUserTime)
  Return (1 - (newIdleTime-oldIdleTime)/(newKrnlTime-oldKrnlTime + newUserTime-oldUserTime)) * 100
}


;============================================================================================================================

Delete_Ini_File_Settings:
  MsgBox, 1, ALT-TAB REPLACEMENT, Delete Settings (.ini) and load defaults?
  IfMsgbox, Cancel
    Return
  FileDelete, Alt_Tab_Settings.ini
  IniFile_Data("Read") ; load defaults
Return


HELP_and_LATEST_VERSION_CHANGES:
  Gosub, Alt_Esc ; hides alt-tab gui
  Gui, 99: Font, s9, Courier New
  Gui, 99: Default
  If A_ThisMenuItem =Help
    Gui, 99: Add, Edit, vGui_99_Edit ReadOnly, %HELP%
  If A_ThisMenuItem =Latest Changes
    Gui, 99: Add, Edit, vGui_99_Edit ReadOnly, %LATEST_VERSION_CHANGES%
  Gui, 99: Show,, %A_ThisMenuItem%
  WinWaitActive, %A_ThisMenuItem%
  ControlSend, Edit1, ^{Home}, %A_ThisMenuItem%
Return

99GuiClose:
99GuiEscape:
  Gui, 99: Destroy
Return