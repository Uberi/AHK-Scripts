/*

Start Button Clock with cpu and memory usage bars.

  - default positions/size for Windows XP classic appearance (old style windows look).

*/

#NoTrayIcon                ; Save space w/o icon/menu
Process Priority,,High

;----- edit here for best look -----

X_Pos = 0 ; x co-ordinate on taskbar
Y_Pos = 0 ; y co-ordinate on taskbar

Clock_Width   = 58            ; width of the clock and progress bars (fit to taskbar)
ProgressBar_H = 8              ; height of the progress bars


CPU_Usage_Bar_Color = Navy
Mem_Usage_Bar_Color = Red

Clock_Color     = White          ; Background
Clock_Font_Color = Black          ; Font
Clock_Font      = Arial
Clock_Pts       = 10
Clock_Font_Style = bold
Clock_Pattern   = h:mm:ss
Clock_H         = 14             ; height of the clock



;----- code starts here -----

VarSetCapacity( IdleTicks,    2*4 )
VarSetCapacity( memorystatus, 100 )


Menu ClockMenu, Add, &Adjust Date/Time, DTSet
Menu ClockMenu, Add, &Copy Date/Time, DTcopy
Menu ClockMenu, Add, E&xit,  7GuiClose
Menu ClockMenu, Add, Canc&el,DTCancel


; seperate gui for each thing to allow cropping of borders for maximum space
Gui, 7: Margin, 0, 0
Gui, 7: -Caption +ToolWindow  ; no title, no taskbar icon
Gui, 7: Color, %Clock_Color%
Gui, 7: font, S%Clock_Pts% %Clock_Font_Style% c%Clock_Font_Color%, %Clock_Font%
Gui, 7: Add, Text, x5 y-1 vClock w%Clock_Width% h%Clock_H% vDT


ProgressBar_W := Clock_Width +4
Gui, 8: Margin, 0, 0
Gui, 8: -Caption +ToolWindow  ; no title, no taskbar icon
Gui, 8: Add, Progress, vProcLoad x-2 y-2 w%ProgressBar_W% h%ProgressBar_H% c%CPU_Usage_Bar_Color%

Gui, 9: Margin, 0, 0
Gui, 9: -Caption +ToolWindow  ; no title, no taskbar icon
Gui, 9: Add, Progress, vMemLoad x-2 y-2 w%ProgressBar_W% h%ProgressBar_H% c%Mem_Usage_Bar_Color%

Bar_H := ProgressBar_H - 4 ; 2*2 border pixels
Bar_H_plus_Clock_H := Bar_H + Clock_H
Gui, 7: Show, x%X_Pos% y%Bar_H% w%Clock_Width% h%Clock_H%, Clock
Gui, 8: Show, x%X_Pos% y%Y_Pos% w%Clock_Width% h%Bar_H%, Processor Load
Gui, 9: Show, x%X_Pos% y%Bar_H_plus_Clock_H% w%Clock_Width% h%Bar_H%, Memory Load

Dock2TaskBar(7)
Dock2TaskBar(8)
Dock2TaskBar(9)

SetTimer ClockUpdate, 1000 ; Update bars, redraw clock, tooltip
OnMessage(0x200,"Hover")   ; 0x200 = WM_MOUSEMOVE used instead of WM_MOUSEHOVER
OnMessage(0x201,"LClick")  ; 0x201 = WM_LBUTTONDOWN
Return



ClockUpdate:
  FormatTime time,,%Clock_Pattern%
  GuiControl 7:,DT,%time% ; Update date/time in preset format

  IdleTime0 = %IdleTime%  ; Save previous values
  Tick0 = %Tick%
  DllCall("kernel32.dll\GetSystemTimes", "uint",&IdleTicks, "uint",0, "uint",0)
  IdleTime := *(&IdleTicks)
  Loop 7                  ; Ticks when Windows was idle
    IdleTime += *( &IdleTicks + A_Index ) << ( 8 * A_Index )
  Tick := A_TickCount     ; Ticks all together
  load := 100 - 0.01*(IdleTime - IdleTime0)/(Tick - Tick0)
  GuiControl 8: , ProcLoad, %load% ; Update progress bar

  DllCall("kernel32.dll\GlobalMemoryStatus", "uint",&memorystatus)
  mem := *( &memorystatus + 4 ) ; last byte is enough, mem = 0..100
  GuiControl 9: , MemLoad, %mem% ; Update progress bar
Return



DTCancel:                  ; Do nothing in popup menu
Return



7GuiContextMenu:           ; Right click popup menu
  ToolTip                 ; Erase
  Menu ClockMenu, Show    ; Show context menu
Return



7GuiClose:                 ; Exit
  ExitApp



DTSet:                     ; Adjust date and time
  Run timedate.cpl
Return



DTcopy:                    ; Copy Date/Time to the ClipBoard
  Clipboard := FullDT()
Return



LClick()                   ; show start menu
{
  Send, {LWIN}
}



Hover()                    ; When the mouse hovers DT
{
  Global load, mem
  
  If A_Gui = 7 ; Mouse cursor hovers DT control
    {
    ToolTip, % FullDT()   ; Show full date/time info
    SetTimer, Check_If_Mouse_Not_Hover, 500
    Return
    }
  
   If A_Gui = 8 ; Mouse cursor hovers DT control
    {
    SetFormat, float, 0.0
    load := load + 0
    ToolTip, % "CPU: " load "%"   ; Show cpu usage
    SetTimer, Check_If_Mouse_Not_Hover, 500
    Return
    }
  
   If A_Gui = 9 ; Mouse cursor hovers DT control
    {
    ToolTip, % "Memorage used: " mem "%"   ; Show memory usage
    SetTimer, Check_If_Mouse_Not_Hover, 500
    Return
    }
  
   ToolTip              ; Erase
}



Check_If_Mouse_Not_Hover:
  MouseGetPos,,, Mouse_Over_Win
  If Mouse_Over_Win not contains %Gui_ID_7%, %Gui_ID_8%, %Gui_ID_9%
    {
    Tooltip ; hide tooltip
    SetTimer, Check_If_Mouse_Not_Hover, Off
    }
Return


Dock2TaskBar(Gui_Number)              ; Active window to be docked to the taskbar, NEEDS hw_tray value
{
  Global ; for checking tooltip with mousegetpos
  hw_tray := DllCall( "FindWindowEx", "uint",0, "uint",0, "str","Shell_TrayWnd", "uint",0 )
  Gui, %Gui_Number%: +LastFound
  Gui_ID_%Gui_Number% := WinExist()
  DllCall( "SetParent", "uint", Gui_ID_%Gui_Number%, "uint", hw_tray )
}



FullDT()  ; Returns current date/time info
{
  FormatTime wday,,dddd
  FormatTime day,, yDay
  FormatTime week,,yWeek
  StringTrimLeft week, week, 4
  ;----- edit here for best look -----
  FormatTime DT,,d MMMM yyyy
  Return wday " " DT "   (Day: " day ", Week: " week ")"
  ;----- edit here for best look -----
}
