
HELP = ; Gui, 99
(LTrim0


ALT-TAB REPLACEMENT (WITH ICONS AND WINDOW TITLES IN A LISTVIEW).


HOTKEYS:
  Alt+Tab - move forwards in window stack
  Alt+Shift+Tab - move backwards in window stack
  Alt+CapsLock - alterative to Alt+Shift+Tab
  Alt+Esc - cancel switching window

EVENTS:
  Single-click a row to select that item and switch to it.

  Type first letter of program's title to cycle through them while still holding Alt
    (ignores "/  DIALOG" prefix if present).

  Columns can be sorted by clicking on their titles.

  Right-Click (context menu):
    Basic hotkey support for switching to specific windows (using window groups and adding window classes)
    Exclude (and un-exclude) specific windows and specific exe's - see "Window Groups" below.
    Edge-docking - dock windows to the edges of the screen and have them auto-hide (like the taskbar can)
    Window Groups - define lists of windows to easily switch between only showing certain apps

  Close windows:
    Alt+\ "hotkey"  - close selected window (while list is displayed)
    Alt+/ "hotkey"  - close ALL windows whose EXE matches that of the selected entry (while list is displayed)
    Process menu entry - end selected process or all instance of the EXE in the list.

TO EXIT:
  Kill process or remove #NoTrayIcon first

SETTINGS:
  See "; USER EDITABLE SETTINGS:" section near top of source code.


NOTE: Stroke-It (and maybe other mouse gesture programs) can cause the context menu to be shown twice/problematic.
        Solution = exclude the program within the gesture recognition program.
        
        
)



LATEST_VERSION_CHANGES = ; Gui, 98
(LTrim0


TO DO (maybe):
  add corners as menu option for docking
  save settings such as windows to exclude/hotkeys between restarts
  possible uses of OnMessage
  include a filter for docked windows to be displayed in alt-tab or not
  stick items to top or bottom of list
    use listview insert command to place windows at specific locations in list
    change window titles (for pressing 1st letter of title more easily)?
    indicate/sort min/max/normal/on top windows
  configuration window
  arrange/tile windows in list
  auto-advance in a group of windows when the active one is closed - use settimer to check
  allow for a single key to show list? user-defineable hotkeys in addition to alt-tab?
  switch from using group_add to binding hotkeys to assigning hotkeys to switch to already created groups


KNOWN BUGS:
  Icon for certain popup windows (such as shortcut properties) not retrieved - generic one used instead


LATEST VERSION CHANGES:
> 04-01-06
  Fixed a bug where the listview could be hidden if keeping Alt pressed after Alt-Esc and then Alt-Tab
  Edge-dock timers turned off if windows closed before un-docking
  Edge-docked maximised windows now not AlwaysOnTop when viewing (easier to hide them again)
  Edge-docking now returns the window's original AlwaysOnTop state and size when un-docking
  Context Menus have had a lot added to them/re-ordered
  Context Menu entries for creating groups (working sets) of windows and more powerful inclusion/exclusion options.
  Context Menu access to Help (remind user of shortcuts, etc) and latest version changes - generated from this file.
  Process Menu entry - end selected process or all instance of the exe in the list
  Alt+CapsLock - alterative to Alt+Shift+Tab
  Un-Dock - Un-Dock All menu entry added
  Alt+\ "hotkey"  - close selected window (while list is displayed)
  Alt+/ "hotkey"  - close ALL windows whose EXE matches that of the selected entry (while list is displayed)
  Process menu entry - end selected process or all instance of the EXE in the list.
> 25-12-05
  Now auto-sizes the listview height correctly, thanks to Shimanov (again!)
> 24-12-05
  Edge-docking - dock windows to the edges of the screen and have them auto-hide (like the taskbar can)
  Ability to exclude certain windows from alt-tab list (right-click menu)
  Basic hotkey support for switching to specific windows (using window groups and adding window classes) (right-click menu)
  Much more reliable handling of dialog windows by excluding ws_disabled ones
  Activating by ahk_id again (due to change listed above)
  Automatically switch to small icons if there are too many big icons to fit on the screen
  Checks for alt key state to catch quick press and release
  Doesn't display alt-tab list if alt key already released (due to change listed above)
  Y-axis positioning - center or start at specified position and size downward, then up to max height (if necessary)
  Generic icon for windows that don't return an icon due to being crashed/suspended
  Type first letter of a program to cycle through them while still holding Alt.
> 21-11-05
  "USER EDITABLE SETTINGS" section for easy customisation
  Choice of large or small icons (see "USER EDITABLE SETTINGS" section)
  Mouse wheel switching while displaying list
  Large re-structure of code to allow for more automatic sizing of the listview/gui
  Several small fixes.
> 20-11-05
  Changed to activating the PID so that the topmost window is activated (e.g. save dialog)
  Compare windows to pid of explorer.exe and include window if same - for shortcut icon changing, etc
  Icons for control panel applets (CPA) - credit to shimanov!
  Changed default icon for window not found
  Check if more than 1 pid in alt-tab list then use ahk_id instead of PID for activating
  Limit gui size when too many windows to fit on screen
  
  
)



;========================================================================================================
; USER EDITABLE SETTINGS:

  Use_Large_Icons =1 ; 0 = small icons, 1 = large icons in listview

  ; Fonts
    Font_Size =13 ; (default = 13)
    Font_Type =MS sans serif ; (default = MS sans serif)

  ; Colours
    Gui_Colour =000080 ; i.e. border/background (default = 000080)
    Listview_Colour =E4E2FC ; (default = E4E2FC)

  ; Position
    Gui_x =Center ; (Default = Center)
    Gui_y :=A_ScreenHeight * 0.25 ; ~150 pixels on 1024*768 (Default = A_ScreenHeight * 0.25 ; OR: "Center" WITH quotes)

  ; Max height
    Height_Max_Modifier =0.95 ; multiplier for screen height (e.g. 0.95 = 95% of screen height max ) (Default = 0.9)

  ; Width
    Listview_Width := A_ScreenWidth * 0.55 ; width of listview (default = A_ScreenHeight * 0.55)

  ; Edge-Docking of windows to screen edges
    Edge_Dock_Activation_Delay =750 ;  Delay in milliseconds for hovering over edge-docked window/dismissing window
    Edge_Dock_Border_Visible =5 ; number of pixels of window to remain visible on screen edge

;========================================================================================================
; USER OVERRIDABLE SETTINGS:

  ; Widths
    Col_1 =Auto ; icon column (default = Auto)
    Col_2 =0 ; hidden column for row number (default = 0)
    ; col 3 is autosized based on other column sizes
    Col_4 =Auto ; exe (default = Auto)

  ; Max height
    Height_Max := A_ScreenHeight * Height_Max_Modifier ; limit height of listview (default = A_ScreenHeight * 0.9)
    Small_to_Large_Ratio =1.6 ; height of small rows compared to large rows (default = 1.6)
;========================================================================================================
#SingleInstance Force
#Persistent
#InstallKeybdHook
#InstallMouseHook
#NoTrayIcon


Process Priority,,High
SetBatchLines, -1

WS_EX_APPWINDOW =0x40000
WS_EX_TOOLWINDOW =0x80
WS_DISABLED =0x8000000
GW_OWNER = 4

SysGet, Scrollbar_Vertical_Thickness, 2 ; 2 is SM_CXVSCROLL, Width of a vertical scroll bar


Display_List_Shown =0
Window_Hotkey =0
Use_Large_Icons_Current =%Use_Large_Icons% ; for remembering original user setting but changing on the fly
Hide_From_Listview_List =
Gui_Dock_Windows_List = ; keep track of number of docked windows
Blank = ; for If(array != blank)
Time_Since_Last_Alt_Close =0 ; initialise time for repeat rate allowed for closing windows with alt+\
Return


;>>>>>>>>>>>>>>>>>>>>>>My build in routine.<<<<<<<<<<<<<<<<<<<<<<<<
XRotine:
;Tooltip, XButtonDown2 = %XButtonDown2%
If AltTabIsActive = True
{
  If ( GetKeyState("XButton1") ) ;if xbutton1 is down.
    Return
  Else 
  {
    ;SoundBeep, 200, 200
    SetTimer, XRotine, off ;my build in timer
    If ( GetKeyState("LCtrl") )
      Return
    ;If ( GetKeyState("XButton2") )
    ;  Return
    If XButtonDown2 = True
      Return
    Gosub, ListView_Destroy ;XButtonDown2 is set to false there.
    AltTabIsActive = false
  }
}
Return
~XButton2::
If XButtonDown2 = True
  XButtonDown2 = False
Else
  XButtonDown2 = True
Return
;========================================================================================================


<^>!'::Exitapp ;emergency exit.
~XButton1 & WheelDown:: ; alt-tab hotkey
SetTimer, XRotine, 10 ;my build in timer
AltTabIsActive = true
  Critical
  Gosub, Alt_Tab_Common_Stuff
  Selected_Row += 1
  If Selected_Row >  %Window_Found_Count%
    Selected_Row =1
  LV_Modify(Selected_Row, "Focus Select")
  If ! ( GetKeyState("XButton1") ) ; Alt key released before hotkey activated
    Gosub, ListView_Destroy
  Hotkey, $*~XButton1 Up, ListView_Destroy, On ; submit
Return


~Xbutton1 & WheelUp:: ; alt-shift-tab hotkey
SetTimer, XRotine, 10 ;my build in timer
AltTabIsActive = true
;!CapsLock:: ; alternative to alt-shift-tab
  Critical
  Gosub, Alt_Tab_Common_Stuff
  Selected_Row -= 1
  If Selected_Row =0
    Selected_Row =%Window_Found_Count%
  LV_Modify(Selected_Row, "Focus Select")
  If ! ( GetKeyState("XButton1") ) ; Alt key released before hotkey activated
    Gosub, ListView_Destroy
  Hotkey, $*~XButton1 Up, ListView_Destroy, On ; submit
Return



Alt_Esc: ; abort switching
  Critical
  Hotkey, $*~XButton1 Up, Off
  Hotkey, !Esc, Off
  ;Hotkey, !WheelUp, Off ; previous window
  ;Hotkey, !WheelDown, Off ; next window
  Gui, 1: Default
  Gui, 1: Submit
  IL_Destroy(ImageListID1) ; destroy gui, listview and associated icon imagelist.
  LV_Delete()
  Gui, 1: Destroy
  WinActivate, ahk_id %Active_ID%
  Display_List_Shown =0
Return



Alt_Tab_Common_Stuff:
  Hotkey, !Esc, Alt_Esc, On ; abort
  ;Hotkey, !WheelUp, !+Tab, On ; previous window
  ;Hotkey, !WheelDown, !Tab, On ; next window

  If Display_List_Shown =0
    {
    WinGet, Active_ID, ID, A
    Gosub, Display_List

    ; limit gui height / auto-switch icon sizes
    If (Listview_NowH > Height_Max AND Use_Large_Icons_Current =1) ; switch to small icons
      {
      Use_Large_Icons_Current =0
      IL_Destroy(ImageListID1) ; destroy gui, listview and associated icon imagelist.
      LV_Delete()
      Gui, 1: Destroy
      Display_List_Shown =0
      Gosub, Display_List
      }
    If ((Listview_NowH * Small_to_Large_Ratio) < Height_Max AND Use_Large_Icons_Current =0 AND Use_Large_Icons=1) ; switch to large icons
      {
      Use_Large_Icons_Current =1
      IL_Destroy(ImageListID1) ; destroy gui, listview and associated icon imagelist.
      LV_Delete()
      Gui, 1: Destroy
      Display_List_Shown =0
      Gosub, Display_List
      }

    If ( GetKeyState("XButton1") ) ; Alt key still pressed, else gui not shown
      Gui, 1: Show, AutoSize x%Gui_x_Now% y%Gui_y_Now%

    Active_ID_Loop =0
    Active_ID_Found =0
    Loop, %Window_Found_Count% ; select active program in list (not always the top item)
      {
      Active_ID_Loop +=1
      If Window%Active_ID_Loop% =%Active_ID%
        {
        Active_ID_Found =1
        LV_Modify(Active_ID_Loop, "Focus Select")
        Break
        }
      }

    If Active_ID_Found =0 ; active window has an icon in another main window & was excluded from Alt-Tab list
      {
      WinGet, Active_Process, ProcessName, ahk_id %Active_ID%
      WinGetClass, Active_Class, ahk_id %Active_ID%

      ; If desktop/taskbar selected or nothing at all, don't select item in alt-tab list
      If (Active_Class ="Progman" OR Active_Class ="WorkerW" OR Active_Class ="Shell_TrayWnd" OR Active_Class ="")
        {
        Active_ID_Loop =1
        Active_ID_Found =1
        }
      If Active_ID_Found =0
        {
        Active_ID_Loop =0
        Loop, %Window_Found_Count% ; find top item in window list with same exe name as active window
          {
          Active_ID_Loop +=1
          If Exe_Name%Active_ID_Loop% =%Active_Process%
            {
            Active_ID_Found =1
            LV_Modify(Active_ID_Loop, "Focus Select")
            Break
            }
          }
        }
      }
    }
  Selected_Row := LV_GetNext(0, "F")
Return




;========================================================================================================



Display_List:
  Critical

  If Display_List_Shown =1 ; empty listview and image list if only updating
    {
    IL_Destroy(ImageListID1)
    LV_Delete()
    
    }

  ; Create an ImageList so that the ListView can display some icons
  ImageListID1 := IL_Create(10,5,Use_Large_Icons_Current)

  ; Gather a list of running programs:
  WinGet, Window_List, List

  Process, Exist, explorer.exe ; get PID of explorer.exe for later comparison
    Explorer_PID =%ErrorLevel%



 ;;;;;;; still necessary???
  Loop, %Window_List% ; build a list of window PIDs
    {
    wid := Window_List%A_Index%
    WinGet, PID%A_Index%, PID, ahk_id %wid%
    }

  Window_Found_Count =0
  Window_Loop_Count =0
  Loop, %Window_List%
    {
    Window_Loop_Count +=1
    wid := Window_List%Window_Loop_Count%

    ; exclude hidden windows
    If Hide_From_Listview_List contains %wid%
      Continue

    WinGet, es, ExStyle, ahk_id %wid%
    WinGet, Style, Style, ahk_id %wid%

    ; Retrieve small icon for desired window styles (i.e. those on the taskbar)
    If ( ( ! DllCall( "GetWindow", "uint", wid, "uint", GW_OWNER ) and  ! ( es & WS_EX_TOOLWINDOW )
           and ! ( Style & WS_DISABLED )) or ( es & WS_EX_APPWINDOW ) )
      {
      Window_Found_Count += 1
      Gosub, Retrive_Window_Icon
      Window_Parent_%Window_Found_Count% = ; store Parent ahk_id's to a list to later see if window is owned
      Window%Window_Found_Count% =%wid% ; store ahk_id's to a list
      WinGet, Exe_Name%Window_Found_Count%, ProcessName, ahk_id %wid% ; store processes to a list
      Continue
      }

    If ( ! DllCall( "GetWindow", "uint", wid, "uint", GW_OWNER ) and ( Style & WS_DISABLED ) ) ; e.g. generally includes WS_POPUP
      {
      Window_Found_Count += 1

      hw_popup := DllCall( "GetLastActivePopup", "uint", wid )
      SetFormat, integer, hex ; change Parent to hex format
      hw_popup += 0
      SetFormat, integer, d      
      
      Gosub, Retrive_Window_Icon
      WinGetTitle, hw_popup_title, ahk_id %hw_popup% ; over-ride title from Gosub, Retrive_Window_Icon
      Title%Window_Found_Count% := "/    DIALOG:   " hw_popup_title "  /  " Title%Window_Found_Count% new_line ; indent listview title text to stand out, / symbol to use as Alt-/ hotkey      
      Window_Parent_%Window_Found_Count% =%wid% ; store Parent ahk_id's to a list to later see if window is owned
      Window%Window_Found_Count% =%hw_popup% ; store ahk_id's to a list
      WinGet, Exe_Name%Window_Found_Count%, ProcessName, ahk_id %hw_popup% ; store processes to a list
      Continue
      }

    WinGetClass, Win_Class, ahk_id %wid%
    If ( ! ( Win_Class ="#32770" ) )
      Continue
    Parent := DllCall( "GetParent", "uint", wid )
    SetFormat, integer, hex ; change Parent to hex format
    Parent += 0
    SetFormat, integer, d
    WinGet, es, ExStyle, ahk_id %Parent%
    WinGet, Style, Style, ahk_id %Parent%


    ; Check parent to dialog isn't already included above
    If ( ( ( ! DllCall( "GetWindow", "uint", Parent, "uint", GW_OWNER ) and  ! ( es & WS_EX_TOOLWINDOW )
           and ! ( Style & WS_DISABLED )) or ( es & WS_EX_APPWINDOW ) ) )
        {
        Window_Found_Count += 1
        CPA_file_name := GetCPA_file_name( wid )
        If ( CPA_file_name )
          IL_Add( ImageListID1, CPA_file_name, 1 )
        Else
          Gosub, Retrive_Window_Icon ; retrieve parent's icon for display

        WinGetTitle, Title%Window_Found_Count%, ahk_id %wid% ; store titles to a list
        Title%Window_Found_Count% :="/    DIALOG:   "Title%Window_Found_Count% ; indent listview title text to stand out, / symbol to use as Alt-/ hotkey
        Window_Parent_%Window_Found_Count% = ; store Parent ahk_id's to a list to later see if window is owned
        Window%Window_Found_Count% =%wid% ; store ahk_id's to a list
        WinGet, Exe_Name%Window_Found_Count%, ProcessName, ahk_id %wid% ; store processes to a list
        }
    }



;loop all the above inside a function to automatically destroy unneeded variables?





  If Display_List_Shown !=1 ; no need to create gui for updating listview
    {
    ; Create the ListView gui
    Gui, 1: +AlwaysOnTop +ToolWindow -Caption
    Gui, 1: Font, s%Font_Size%, %Font_Type%
    Gui, 1: Color, %Gui_Colour%
    Gui, 1: Margin, 2, 2
    Gui, 1: Add, ListView, r%Window_Found_Count% w%Listview_Width% -E0x200 AltSubmit -Multi Background%Listview_Colour% Count10 gListView_Event vListView1,#| |Window|Exe
    }

  ; Attach the ImageLists to the ListView so that it can later display the icons:
  LV_SetImageList(ImageListID1, 1)

  Loop, %Window_Found_Count% ; add all rows to listview
    LV_Add("Icon" . A_Index,A_Space, A_Index, Title%A_Index%, Exe_Name%A_Index%) ; spaces added for layout






;;;;;;;;;;;;
/*
; manipulate and filter listview items

; use LV_Insert(RowNumber [, Options, Col1, Col2, ...]):  to add rows at end, after other windows, in middle, etc

;;;  need to write filtered windows to _another_ list and then put those in listview
; get titles, etc for final list only - for titles for dialog windows, store title to temporary location
; still need pid getting command?
*/


    DetectHiddenWindows, On ; retrieving column widths to enable calculation of col 3 width
  
    Process, Exist
    WinGet, Gui_ID, ID, ahk_class AutoHotkeyGUI ahk_pid %ErrorLevel% ; for auto-sizing columns later

  If Display_List_Shown !=1 ; no need to resize columns for updating listview
    {  
    ; resize listview columns
    LV_ModifyCol(1, Col_1) ; icon column
    LV_ModifyCol(2, Col_2) ; hidden column for row number
    ; col 3 see below
    LV_ModifyCol(4, Col_4) ; exe

    SendMessage, 0x1000+29, 0, 0, SysListView321, ahk_id %Gui_ID% ; LVM_GETCOLUMNWIDTH is 0x1000+29
      Width_Column_1 := ErrorLevel
    SendMessage, 0x1000+29, 1, 0, SysListView321, ahk_id %Gui_ID% ; LVM_GETCOLUMNWIDTH is 0x1000+29
      Width_Column_2 := ErrorLevel
    SendMessage, 0x1000+29, 3, 0, SysListView321, ahk_id %Gui_ID% ; LVM_GETCOLUMNWIDTH is 0x1000+29
      Width_Column_4 := ErrorLevel
    Col_3 := Listview_Width - Width_Column_1 - Width_Column_2 - Width_Column_4 ; total width of columns
    LV_ModifyCol(3, Col_3) ; resize title column
    }
    
  ; Automatically resize listview vertically
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
  lv_h := 2 + lv_header_h + ( lv_row_h * Window_Found_Count ) + 2 ;+64
  GuiControl, Move, SysListView321, h%lv_h% 

  GuiControlGet, Listview_Now, Pos, ListView1 ; retrieve listview dimensions/position ; for auto-sizing (elsewhere)

  ; auto-position gui upwards according to size
  Gui_x_Now := Gui_x
  Gui_y_Now := Gui_y
  If Gui_y_Now !=Center
    {
    If ((Gui_y_Now + Listview_NowH) > Height_Max) ; gui nearly off bottom of screen
      Gui_y_Now := Gui_y_Now + (Height_Max - (Listview_NowH + Gui_y_Now))
    }
  If (Listview_NowH > Height_Max AND Use_Large_Icons_Current =0) ; already using small icons -limit height
    {
    Col_3 := Col_3 - Scrollbar_Vertical_Thickness ; allow for vertical scrollbar being visible
    LV_ModifyCol(3, Col_3) ; resize title column
    Gui_y_Now := (A_ScreenHeight - Height_Max) / 2
    GuiControl, Move, ListView1, h%Height_Max%
    }

  DetectHiddenWindows, Off  

  If Display_List_Shown =1 ; resize gui for updating listview
    {
    Gui, 1: Show, AutoSize x%Gui_x_Now% y%Gui_y_Now%
    If Selected_Row >%Window_Found_Count% ; less windows
      Selected_Row =%Window_Found_Count%
    LV_Modify(Selected_Row, "Focus Select") ; select 1st entry since nothing selected
    }
  
  Display_List_Shown =1
  ; Gui 1 is shown back in Alt-Tab common section for initial creation
Return



;========================================================================================================



ListView_Event:
  Critical
  If A_GuiEvent =Normal ; activate clicked window
    Gosub, ListView_Destroy
  If A_GuiEvent =K ; letter was pressed, select next window name starting with that letter
    Gosub, Key_Pressed_1st_Letter
Return



GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
                 ; displays the menu only for clicks inside the ListView
  Selected_Row := LV_GetNext(0, "F")
  LV_GetText(RowText, Selected_Row, 2)  ; Get the row's first-column text (hidden column).
  Gui_2_wid := Window%RowText%
  Gui_2_wid_Title :=Title%RowText%
  StringLeft, Gui_2_wid_Title, Gui_2_wid_Title, 40

  If (A_GuiControl = "ListView1")
    {
    ; Add blank entry to all menus so they exist all the time for deletion command
    Menu, ContextMenu1, Add
    Menu, Gui_Dock_Windows, Add
    Menu, Gui_Exclude_Windows, Add
    Menu, Gui_Un_Exclude_Windows, Add
    Menu, Gui_Window_Group_Load, Add
    Menu, Gui_Window_Group_Delete, Add
    Menu, Gui_Processes, Add
    
    ; Clear previous entries
    Menu, ContextMenu1, DeleteAll
    Menu, Gui_Dock_Windows, DeleteAll
    Menu, Gui_Exclude_Windows, DeleteAll
    Menu, Gui_Un_Exclude_Windows, DeleteAll
    Menu, Gui_Window_Group_Load, DeleteAll
    Menu, Gui_Window_Group_Delete, DeleteAll
    Menu, Gui_Processes, DeleteAll

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
    IfNotInString, Gui_Dock_Windows_List,%Gui_2_wid%
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
      Menu, Gui_Dock_Windows, Check, % Edge_Dock_Position_%Gui_2_wid%
      }
    If Gui_Dock_Windows_List =
      Menu, Gui_Dock_Windows, Disable, Un-Dock All
    Menu, ContextMenu1, Add, Dock to Edge, :Gui_Dock_Windows

    ; Exclude Windows
    Menu, ContextMenu1, Add ; spacer
    Menu, Gui_Exclude_Windows, Add, % "Exclude All Of:  " Exe_Name%RowText% , Gui_Exclude_Windows_Exclude_Exe_Only
    Menu, Gui_Exclude_Windows, Add, % "Exclude All Except:  " Exe_Name%RowText% , Gui_Exclude_Windows_Include_Exe_Only
    Menu, Gui_Exclude_Windows, Add, Exclude All, Gui_Exclude_Windows_All
    Menu, Gui_Exclude_Windows, Add ; spacer
    Menu, Gui_Exclude_Windows, Add, %Gui_2_wid_Title% (ID=%Gui_2_wid%), Gui_Exclude_Windows_Sub_Exclude
    Menu, ContextMenu1, Add,  Exclude, :Gui_Exclude_Windows
    If Window_Found_Count =1 ; don't allow to hide all windows from alt-tab - avoids errors
      Menu, ContextMenu1, Disable, Exclude

    ; Un-exclude windows sub-menu entry
    StringTrimLeft, Hide_From_Listview_List, Hide_From_Listview_List, 1 ; remove 1st | character (empty reference otherwise)
    Loop, Parse, Hide_From_Listview_List,| ; remove entries from any closed windows
      {
      temp =%A_LoopField%
      Loop, %Window_List%
        {
        If Window_List%A_Index% contains %temp% ; i.e. window found
          Break
        If A_Index < %Window_List% ; not found but not checked all windows yet
          Continue
        StringReplace, Hide_From_Listview_List, Hide_From_Listview_List,%temp% ; remove item from list
        StringReplace, Hide_From_Listview_List, Hide_From_Listview_List,||,| ; clean up any empty entries
        }
      }
    StringSplit, Hide_From_Listview_List_Array, Hide_From_Listview_List,|
    Menu, Gui_Un_Exclude_Windows, Add, Un-Exclude All, Gui_Exclude_Windows_Sub_Un_Exclude_All
      Menu, Gui_Un_Exclude_Windows, Add ; spacer
    Loop, %Hide_From_Listview_List_Array0%
      {
      WinGetTitle, Hide_From_Listview_List_Title, % "ahk_id " Hide_From_Listview_List_Array%A_Index%
      StringLeft, Hide_From_Listview_List_Title, Hide_From_Listview_List_Title, 40
      Menu, Gui_Un_Exclude_Windows, Add, % Hide_From_Listview_List_Title " (ID=" Hide_From_Listview_List_Array%A_Index% ")", Gui_Exclude_Windows_Sub_Un_Exclude_Window
      }
    Menu, ContextMenu1, Add, Un-Exclude, :Gui_Un_Exclude_Windows
    If Hide_From_Listview_List_Array0 =0
      Menu, ContextMenu1, Disable, Un-Exclude

    ; Window Group sub-menu entry
    Menu, ContextMenu1, Add ; spacer

    Loop, Parse, Window_Group_Name_List,|
      {
      If A_LoopField contains DOTEXE
        Menu, Gui_Window_Group_Load, Add, % Window_Group_Name_%A_LoopField% , Gui_Window_Group_Load
      Else
        Menu, Gui_Window_Group_Load, Add,%A_LoopField%, Gui_Window_Group_Load
      }
    If Window_Group_Name_List = ; add something to be able to display disabled menu
      Menu, Gui_Window_Group_Load, Add
    Menu, ContextMenu1, Add, Group - Load, :Gui_Window_Group_Load
    If Window_Group_Name_List =
      Menu, ContextMenu1, Disable, Group - Load
    Menu, ContextMenu1, Add, Group - Save, Gui_Window_Group_Save
    Loop, Parse, Window_Group_Name_List,|
      {
      If A_LoopField contains DOTEXE
        Menu, Gui_Window_Group_Delete, Add, % Window_Group_Name_%A_LoopField% , Gui_Window_Group_Delete
      Else
        Menu, Gui_Window_Group_Delete, Add,%A_LoopField%, Gui_Window_Group_Delete
      }
    If Window_Group_Name_List = ; add something to be able to display disabled menu
      Menu, Gui_Window_Group_Delete, Add
    If Window_Group_Name_List =
      Menu, ContextMenu1, Disable, Group - Load
    Menu, ContextMenu1, Add, Group - Delete, :Gui_Window_Group_Delete
    If Window_Group_Name_List =
      Menu, ContextMenu1, Disable, Group - Delete

    ; Hotkeys entry
    Menu, ContextMenu1, Add ; spacer
    Menu, ContextMenu1, Add, Hotkeys, Gui_Hotkeys

    ; Processes entry
    Menu, ContextMenu1, Add ; spacer
    Menu, Gui_Processes, Color, FF3333, Single
    Menu, Gui_Processes, Add, % "End:  " Gui_2_wid_Title, End_Process_Single
    Loop, Parse, Gui_Dock_Windows_List,| ; don't close docked window - window may remember off-screen position
      {
      If A_LoopField =%Gui_2_wid%
        Menu, Gui_Processes, Disable, % "End:  " Gui_2_wid_Title
      }    
    Menu, Gui_Processes, Add ; spacer
    Menu, Gui_Processes, Add, % "End All:  " Exe_Name%RowText%, End_Process_All_Instances
    Menu, ContextMenu1, Add, Processes, :Gui_Processes

    ; Help + Latest changes
    Menu, ContextMenu1, Add ; spacer
    Menu, Gui_Help, Add, Help, HELP_and_LATEST_VERSION_CHANGES
    Menu, Gui_Help, Add, Latest Changes, HELP_and_LATEST_VERSION_CHANGES
    Menu, ContextMenu1, Add, Help, :Gui_Help

    Menu, ContextMenu1, Show, %A_GuiX%, %A_GuiY%
    }
Return



Gui_Dock_Windows:
  Edge_Dock_%Gui_2_wid% =%Gui_2_wid% ; write window ID to a unique variable
  Edge_Dock_Position_%Gui_2_wid% :=A_ThisMenuItem ; store Left, Right, etc
  WinGet, Edge_Dock_State_%Gui_2_wid%, MinMax, ahk_id %Gui_2_wid%
  If Edge_Dock_State_%Gui_2_wid% =-1 ; if window is mimised, un-minimise
    WinRestore, ahk_id %Gui_2_wid%
  WinGetPos, Edge_Dock_X_%Gui_2_wid%, Edge_Dock_Y_%Gui_2_wid%, Edge_Dock_Width_%Gui_2_wid%, Edge_Dock_Height_%Gui_2_wid%, ahk_id %Gui_2_wid%
  Edge_Dock_X_Initial_%Gui_2_wid% := Edge_Dock_X_%Gui_2_wid%
  Edge_Dock_Y_Initial_%Gui_2_wid% := Edge_Dock_Y_%Gui_2_wid%
  Edge_Dock_Width_Initial_%Gui_2_wid% := Edge_Dock_Width_%Gui_2_wid%
  Edge_Dock_Height_Initial_%Gui_2_wid% := Edge_Dock_Height_%Gui_2_wid%
  WinGet, Edge_Dock_AlwaysOnTop_%Gui_2_wid%, ExStyle, ahk_id %Gui_2_wid% ; store AlwaysOnTop original status
  If Gui_Dock_Windows_List =
    Gui_Dock_Windows_List =%Gui_2_wid% ; keep track of number of docked windows
  Else
    Gui_Dock_Windows_List =%Gui_Dock_Windows_List%|%Gui_2_wid%
  Gosub, Alt_Esc ; hides alt-tab gui
Gui_Dock_Windows_ReDock:
  Edge_Dock_X =
  Edge_Dock_Y =
  ; leave just 5 pixels (Edge_Dock_Border_Visible) of side visible
  If Edge_Dock_Position_%Gui_2_wid% contains Left
    Edge_Dock_X := - ( Edge_Dock_Width_%Gui_2_wid% - Edge_Dock_Border_Visible )
  If Edge_Dock_Position_%Gui_2_wid% contains Right
    Edge_Dock_X := A_ScreenWidth - Edge_Dock_Border_Visible
  If Edge_Dock_Position_%Gui_2_wid% contains Top
    Edge_Dock_Y := - ( Edge_Dock_Height_%Gui_2_wid% - Edge_Dock_Border_Visible )
  If Edge_Dock_Position_%Gui_2_wid% contains Bottom
    Edge_Dock_Y := A_ScreenHeight - Edge_Dock_Border_Visible
  
  WinMove, ahk_id %Gui_2_wid%,, %Edge_Dock_X%, %Edge_Dock_Y%
  WinSet, AlwaysOnTop, On, ahk_id %Gui_2_wid%
  
  SetTimer, Check_Mouse_Position, %Edge_Dock_Activation_Delay% ; change to affect response time to having mouse over edge-docked window
Return



Check_Mouse_Position:
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
      Gui_2_wid =%A_LoopField%
      Gosub, Gui_Un_Dock_Window
      }
    WinGet, Edge_Dock_State_%A_LoopField%, MinMax, ahk_id %A_LoopField%
    If Edge_Dock_State_%A_LoopField% =-1 ; if window is mimised, un-minimise
      WinRestore, ahk_id %A_LoopField%
    }

  WinGet, Previously_Active_Window_Before_Using_Docked, ID, A
  Edge_Dock_Active_Window =
  If ( Edge_Dock_%Previously_Active_Window_Before_Using_Docked% != Blank ) ; check keyboard focus
    Edge_Dock_Active_Window := Edge_Dock_%Previously_Active_Window_Before_Using_Docked%
  MouseGetPos,,, Mouse_Over_Window
  If ( Edge_Dock_%Mouse_Over_Window% != Blank ) ; over-ride keyboard with mouse "focus" if necessary
    Edge_Dock_Active_Window := Edge_Dock_%Mouse_Over_Window%

  If Edge_Dock_Active_Window != ; i.e. window is already docked
    {
    SetTimer, Check_Mouse_Position, Off

    Edge_Dock_X =
    Edge_Dock_Y =
    ; move window onto screen
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Left
      Edge_Dock_X =0
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Right
      Edge_Dock_X := A_ScreenWidth - Edge_Dock_Width_%Edge_Dock_Active_Window%
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Top
      Edge_Dock_Y =0
    If Edge_Dock_Position_%Edge_Dock_Active_Window% contains Bottom
      Edge_Dock_Y := A_ScreenHeight - Edge_Dock_Height_%Edge_Dock_Active_Window%

    WinGet, Edge_Dock_MinMax, MinMax, ahk_id %Edge_Dock_Active_Window%
    If Edge_Dock_MinMax = 1 ; window is maximised so don't keep as always on top
      WinSet, AlwaysOnTop, Off, ahk_id %Edge_Dock_Active_Window% 
  
    WinMove, ahk_id %Edge_Dock_Active_Window%,, %Edge_Dock_X%, %Edge_Dock_Y%
    WinActivate, ahk_id %Edge_Dock_Active_Window%
    SetTimer, Check_Mouse_Position_Deactivate, %Edge_Dock_Activation_Delay%
    }
Return



Check_Mouse_Position_Deactivate: ; check if not over an edge-docked window any more
  Loop, Parse, Gui_Dock_Windows_List,| ; check if windows in docked list have been closed before un-docking
    {
    IfWinNotExist, ahk_id %A_LoopField%
      {
      Gui_2_wid =%A_LoopField%
      Gui_Un_Dock_Window_No_Alt_Esc =1
      Gosub, Gui_Un_Dock_Window
      }
    }

    WinGet, Edge_Dock_MinMax, MinMax, ahk_id %Edge_Dock_Active_Window%
    If Edge_Dock_MinMax = 1 ; window is maximised so don't keep as always on top
      WinSet, AlwaysOnTop, Off, ahk_id %Edge_Dock_Active_Window% 

    ; retrieve active window focus and mouse over window - active window has priority
    WinGet, Active_Window_Now, ID, A

    If Active_Window_Now =%Edge_Dock_Active_Window%
      MouseGetPos,,, Active_Window_Now

    WinGet, PID_Edge_Dock_Active_Window, PID, ahk_id %Edge_Dock_Active_Window%
    WinGet, PID_Active_Window_Now, PID, ahk_id %Active_Window_Now%
  
    If PID_Active_Window_Now != %PID_Edge_Dock_Active_Window% ; compare pid to check that a child window is not created/active
      {
      SetTimer, Check_Mouse_Position_Deactivate, Off

      WinGet, Style, Style, ahk_id %Edge_Dock_Active_Window%
      If ( Style & WS_DISABLED ) ; don't allow disabled windows to be undocked (e.g., showing save box)
        {
        SetTimer, Check_Mouse_Position, %Edge_Dock_Activation_Delay% ; change to affect response time to having mouse over edge-docked window
        Return
        }

      WinGet, Edge_Dock_State, MinMax, ahk_id %Edge_Dock_Active_Window%
      If Edge_Dock_State =-1 ; if window is mimised, un-minimise
        WinRestore, ahk_id %Edge_Dock_Active_Window%
      WinGetPos, Edge_Dock_X_%Edge_Dock_Active_Window%, Edge_Dock_Y_%Edge_Dock_Active_Window%, Edge_Dock_Width_%Edge_Dock_Active_Window%, Edge_Dock_Height_%Edge_Dock_Active_Window%, ahk_id %Edge_Dock_Active_Window%

      WinActivate, ahk_id %Active_Window_Now%
      Gui_2_wid =%Edge_Dock_Active_Window%
      Gosub, Gui_Dock_Windows_ReDock
      }
Return



Gui_Un_Dock_Window:
  If ! ( Edge_Dock_AlwaysOnTop_%Gui_2_wid% & 0x8 ) ; 0x8 is WS_EX_TOPMOST - keep AlwaysOnTop if originally on top
    WinSet, AlwaysOnTop, Off, ahk_id %Gui_2_wid%
  WinMove, ahk_id %Gui_2_wid%,, % Edge_Dock_X_Initial_%Gui_2_wid%, % Edge_Dock_Y_Initial_%Gui_2_wid%, % Edge_Dock_Width_Initial_%Gui_2_wid%, % Edge_Dock_Height_Initial_%Gui_2_wid% ; original position

  ; erase variables
  Edge_Dock_%Gui_2_wid% =
  Edge_Dock_X_Initial_%Gui_2_wid% =
  Edge_Dock_Y_Initial_%Gui_2_wid% =
  Edge_Dock_Width_Initial_%Gui_2_wid% =
  Edge_Dock_Height_Initial_%Gui_2_wid% =
  Edge_Dock_State_%Gui_2_wid% =
  Edge_Dock_X_%Gui_2_wid% =
  Edge_Dock_Y_%Gui_2_wid% =
  Edge_Dock_Width_%Gui_2_wid% =
  Edge_Dock_Height_%Gui_2_wid% =
  Edge_Dock_Position_%Gui_2_wid% =
  Edge_Dock_AlwaysOnTop_%Gui_2_wid% =

  If Gui_Dock_Windows_List =%Gui_2_wid%
    StringReplace, Gui_Dock_Windows_List, Gui_Dock_Windows_List,%Gui_2_wid% ; keep track of number of docked windows
  Else
    StringReplace, Gui_Dock_Windows_List, Gui_Dock_Windows_List,%Gui_2_wid%| ; keep track of number of docked windows
  If Gui_Un_Dock_Window_No_Alt_Esc !=1
    Gosub, Alt_Esc ; hides alt-tab gui
  Gui_Un_Dock_Window_No_Alt_Esc =
  WinActivate, ahk_id %Gui_2_wid%
Return



Gui_Un_Dock_Windows_All:
  Loop, Parse, Gui_Dock_Windows_List,| ; check if windows in docked list have been closed before un-docking
    {
    Gui_2_wid := A_LoopField
    Gui_Un_Dock_Window_No_Alt_Esc =1
    Gosub, Gui_Un_Dock_Window
    }
Return



Gui_Hotkeys:
  Gosub, Alt_Esc
  WinGetClass, Gui_2_Class, ahk_id %Gui_2_wid%
  Gui, 2: Default ; for listview operations
  Gui, 2: +Owner + AlwaysOnTop
  Gui, 2: Add, Text,, Hotkey for  "%Gui_2_Class%" ,   Win +
  Gui, 2: Add, Hotkey, x+10 y+-15 vGui2_Hotkey_Add
  Gui, 2: Add, Button, x+10 gGui2_Hotkey_Add, Submit
  Gui, 2: Add, ListView, xm r10 w500 gListView2_Event vListView2, Hotkey|Window Class Group
  Loop, %Window_Hotkey% ; loop for number of hotkeys that exist
	 LV_Add("", Window_Hotkey%A_Index%, Window_Hotkey_Class%A_Index% " (" Gui_2_Process%A_Index% ")")
  Gui, 2: Show,, Hotkeys
Return






;;;; need to add
ListView2_Event:
Return









Gui2_Hotkey_Add:
  Gui, 2: Submit
  Gui, 2: Destroy
  Window_Hotkey +=1
  Window_Hotkey_Class%Window_Hotkey% =%Gui_2_Class%
  WinGet, Gui_2_Process%Window_Hotkey%, ProcessName, ahk_id %Gui_2_wid%
  GroupAdd, Group#%Gui2_Hotkey_Add%, ahk_class %Gui_2_Class%
  Window_Hotkey%Window_Hotkey% =%Gui2_Hotkey_Add%
  Gosub, Window_Hotkeys_Enable
  Gosub, Gui_Hotkeys
Return



Window_Hotkeys_Enable:
  Loop, %Window_Hotkey%
    {
    Window_Hotkey_temp :=Window_Hotkey%A_Index%
    Hotkey, #%Window_Hotkey_temp%, Window_Hotkey_Action, On
    }
Return



Window_Hotkey_Action:
  GroupActivate, Group%A_ThisHotkey%, R
Return



Gui_Window_Group_Load:
  Gosub, Gui_Exclude_Windows_Sub_Un_Exclude_All ; empty exclude list
  Gosub, Display_List ; re-construct alt-tab list
  If A_ThisMenuItem contains .exe
    {
    Loop, %Window_Found_Count% ; include only specified exe to generate new Hide_From_Listview_List
      {
      If Exe_Name%A_Index% =%A_ThisMenuItem%
        Continue
      Hide_From_Listview_List = % Hide_From_Listview_List "|" Window%A_Index%
      }
    }
  Else
    {
    Loop, %Window_Found_Count% ; skip items in the window group list to generate new Hide_From_Listview_List
      {
      If Window_Group_Name_%A_ThisMenuItem% contains % Window%A_Index%
        Continue
      Hide_From_Listview_List = % Hide_From_Listview_List "|" Window%A_Index%
      }
    }
  Gosub, Display_List ; update listview
Return


Gui_Window_Group_Save:
  Hotkey, $*~XButton1 Up, Off
  Gui, 1: -AlwaysOnTop
  InputBox, Window_Group_Name_Save_Input, Window Group Name,
    (
Save current list:
  Enter a name for this group of windows to restore in future.`n
Dynamic lists:
  Use the name of the selected program's exe to generate a list that always shows only its windows.
    ),,600,,,,,, % Exe_Name%RowText%
  Gui, 1: +AlwaysOnTop
  Hotkey, $*~XButton1 Up, ListView_Destroy, On
  If ErrorLevel != 0
  	Return
  temp =%Window_Group_Name_Save_Input%
  StringReplace, Window_Group_Name_Save_Input, Window_Group_Name_Save_Input,%A_Space%,_, All ; variable name can't contain period
  StringReplace, Window_Group_Name_Save_Input, Window_Group_Name_Save_Input,.exe,DOTEXE, All ; variable name can't contain period
  Window_Group_Name_List = % Window_Group_Name_List "|" Window_Group_Name_Save_Input
  If InStr(Window_Group_Name_List,"|") =1 ; remove initial |
    StringTrimLeft, Window_Group_Name_List, Window_Group_Name_List, 1
  If Window_Group_Name_Save_Input =
    Return
  If Window_Group_Name_Save_Input contains DOTEXE
    Window_Group_Name_%Window_Group_Name_Save_Input% =%temp%
  Else
    {
    temp =
    Loop, %Window_Found_Count%
      temp = % temp "|" Window%A_Index%
    Window_Group_Name_%Window_Group_Name_Save_Input% =%temp%
    }
  Gosub, Display_List ; update listview
Return


Gui_Window_Group_Delete:
  StringReplace, temp, A_ThisMenuItem,%A_Space%,_, All ; variable name can't contain period
  StringReplace, temp, temp,.exe,DOTEXE, All ; variable name can't contain period
  StringReplace, Window_Group_Name_List, Window_Group_Name_List,%temp% ; remove item from list
  StringReplace, Window_Group_Name_List, Window_Group_Name_List,||,| ; clean up any empty entries
Return







Gui_Exclude_Windows_Sub_Un_Exclude_All:
  Hide_From_Listview_List =
  Gosub, Display_List ; update listview
Return




Gui_Exclude_Windows_Sub_Exclude:
  Hide_From_Listview_List =%Hide_From_Listview_List%|%Gui_2_wid%
  Gosub, Display_List ; update listview
Return



Gui_Exclude_Windows_All:
  Loop, %Window_Found_Count%
    {
    If Window%A_Index% =% Window%RowText% ; skips matching exe name
      Continue
    Hide_From_Listview_List =% Hide_From_Listview_List "|" Window%A_Index%
    }
  Gosub, Display_List ; update listview
Return



Gui_Exclude_Windows_Exclude_Exe_Only:
  Loop, %Window_Found_Count%
    {
    If Exe_Name%A_Index% =% Exe_Name%RowText% ; skips matching exe name
      Hide_From_Listview_List =% Hide_From_Listview_List "|" Window%A_Index%
    }
  Gosub, Display_List ; update listview
Return



Gui_Exclude_Windows_Include_Exe_Only:
  Loop, %Window_Found_Count%
    {
    If Exe_Name%A_Index% =% Exe_Name%RowText% ; skips matching exe name
      Continue
    Hide_From_Listview_List =% Hide_From_Listview_List "|" Window%A_Index%
    }
  Gosub, Display_List ; update listview
Return



Gui_Exclude_Windows_Sub_Un_Exclude_Window:
  Hide_From_Listview_List =
  Loop, %Hide_From_Listview_List_Array0%
    {
    If A_ThisMenuItem contains % Hide_From_Listview_List_Array%A_Index% ; don't write back to new list - i.e. excluded
      Continue
    Hide_From_Listview_List = % Hide_From_Listview_List "|" Hide_From_Listview_List_Array%A_Index%
    }
  Gosub, Display_List ; update listview
Return



End_Process_Single:
  Loop, Parse, Gui_Dock_Windows_List,| ; don't close docked window - window may remember off-screen position
    {
    If A_LoopField =%Gui_2_wid%
      Return
    }
  PostMessage, 0x112, 0xF060,,, ahk_id %Gui_2_wid% ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
  WinWaitClose, ahk_id %Gui_2_wid%,, 1
  Gosub, Display_List ; update listview
Return



End_Process_All_Instances:
  List_of_Process_To_End = ; need to store list now as re-drawing the listview over-writes necessary variables
  Loop, %Window_Found_Count%
    {
    WinGetClass, Win_Class, % "ahk_id " Window%A_Index%
    If Win_Class = #32770 ; don't try to close dialog windows (e.g. save prompts)
      Continue
    If Exe_Name%RowText% = % Exe_Name%A_Index%
      List_of_Process_To_End =% List_of_Process_To_End "|" Window%A_Index%
    }
  StringTrimLeft, List_of_Process_To_End, List_of_Process_To_End, 1 ; remove 1st | character (empty reference otherwise)
  Loop, Parse, List_of_Process_To_End,|
    {
    Gui_2_wid := A_LoopField
    Gosub, End_Process_Single
    }
  List_of_Process_To_End = ; reset
Return



Key_Pressed_1st_Letter:
  Key_Pressed_ASCII =%A_EventInfo%

  Selected_Row := LV_GetNext(0, "F")
  LV_GetText(RowText, Selected_Row, 2)  ; Get the row's first-column text.

  ; \ key - close window
  If Key_Pressed_ASCII =220 ; Alt+\
    {
    If ( A_TickCount - Time_Since_Last_Alt_Close < 200 ) ; prevention of accidentally closing too many windows
      Return
    Time_Since_Last_Alt_Close := A_TickCount
    Gui_2_wid := Window%RowText%
    Gosub, End_Process_Single
    Return
    }

  ; / key - close all instances of exe
  If Key_Pressed_ASCII =191 ; Alt+/
    {
    If ( A_TickCount - Time_Since_Last_Alt_Close < 200 ) ; prevention of accidentally closing too many windows
      Return
    Time_Since_Last_Alt_Close := A_TickCount
    Gui_2_wid := Window%RowText%
    Gosub, End_Process_All_Instances
    Return
    }
  
  Loop, %Window_Found_Count% ; select active program in list (not always the top item)
    {
    Selected_Row +=1
    If Selected_Row > %Window_Found_Count% ; wrap around to start
      Selected_Row =1
    LV_GetText(List_Title_Text, Selected_Row, 2) ; hidden number column

    ; Check for parent's title for typing first letter
    If Window_Parent_%List_Title_Text% !=
      WinGetTitle, List_Title_Text, % "ahk_id " Window_Parent_%List_Title_Text%
    Else
      WinGetTitle, List_Title_Text, % "ahk_id " Window%Selected_Row%
    StringUpper, List_Title_Text, List_Title_Text ; need to match against upper case when alt is held down
    List_Title_Text:=Asc(List_Title_Text) ; convert to ASCII key code

    If Key_Pressed_ASCII =%List_Title_Text%
      {
      LV_Modify(Selected_Row, "Focus Select")
      Break
      }
    }
Return



ListView_Destroy:
  XButtonDown2 = False ;Leos build, for xbutton2 cancelation.
  Critical
  Hotkey, $*~XButton1 Up, Off
  Hotkey, !Esc, Off
  ;Hotkey, !WheelUp, Off ; previous window
  ;Hotkey, !WheelDown, Off ; next window
  Gui, 1: Default
  Selected_Row := LV_GetNext(0, "F")
  LV_GetText(RowText, Selected_Row, 2)  ; Get the row's first-column text.
  Gui, 1: Submit
  IL_Destroy(ImageListID1) ; destroy gui, listview and associated icon imagelist.
  LV_Delete()
  Gui, 1: Destroy
  wid := Window%RowText%
  WinGet, wid_MinMax, MinMax, ahk_id %wid%
  If wid_MinMax =-1 ;minimised
    WinRestore, ahk_id %wid%
  WinActivate, ahk_id %wid%
  Display_List_Shown =0
Return



Retrive_Window_Icon:
  ;WM_GETICON
  ;   ICON_SMALL          0
  ;   ICON_BIG            1
  ;   ICON_SMALL2         2

  If Use_Large_Icons_Current =1
    {
    SendMessage, 0x7F, 1, 0,, ahk_id %wid%
    h_icon := ErrorLevel
    }
  Else
    h_icon =
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
  If (h_icon =FAIL or ! h_icon) ; no icon found
    {
  	IL_Add(ImageListID1, "C:\WINDOWS\system32\shell32.dll" , 3) ; generic icon
    WinGetTitle, Title%Window_Found_Count%, ahk_id %wid% ; store titles to a list
    Title%Window_Found_Count% :="/      NOT RESPONDING!!!: "Title%Window_Found_Count% ; indent listview title text to stand out
    }
  If h_icon !=FAIL
    {
  	IconNumber := DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, h_icon)	; Add the HICON directly to the icon list
    WinGetTitle, Title%Window_Found_Count%, ahk_id %wid% ; store titles to a list
    }
Return



GuiClose:
GuiEscape:
  Gosub, Alt_Esc
Return



2GuiClose:
2GuiEscape:
  Gui, 1: -Disabled
  Gui, 2: Submit
  LV_Delete()
  Gui, 2: Destroy
  Gui, 1: Default
  Gosub, Alt_Esc ; hides alt-tab gui
Return

;========================================================================================================



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

   ix_b := InStr( buffer, "Control_RunDLL" )+16
   ix_e := InStr( buffer, ".cpl", false, ix_b )+3
   StringMid, CPA_file_name, buffer, ix_b, ix_e-ix_b+1

   if ( ix_e )
      return, CPA_file_name
   else
      return, false
}



;========================================================================================================



HELP_and_LATEST_VERSION_CHANGES:
  Gosub, Alt_Esc ; hides alt-tab gui
  Gui, 99: Font, s9, Courier New
  Gui, 99: Add, ListView, r25 w900 -Hdr, Text
  Gui, 99: Default
  If A_ThisMenuItem =Help
    {
    Loop, Parse, HELP,`n
      LV_Add("", A_LoopField)
    }
  If A_ThisMenuItem =Latest Changes
    {
    Loop, Parse, LATEST_VERSION_CHANGES,`n
      LV_Add("", A_LoopField)
    }
  LV_ModifyCol(1, 870)
  Gui, 99: Show,, %A_ThisMenuItem%
Return

99GuiClose:
99GuiEscape:
  LV_Delete()
  Gui, 99: Destroy
Return
