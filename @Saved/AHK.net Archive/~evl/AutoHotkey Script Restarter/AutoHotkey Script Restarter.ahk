OnExit, HandleExit 

success := DllCall( "advapi32.dll\LookupPrivilegeValueA" 
                  , "uint", 0 
                  , "str", "SeDebugPrivilege" 
                  , "int64*", luid_SeDebugPrivilege ) 
if ( ReportError( ErrorLevel or !success 
            , "LookupPrivilegeValue: SeDebugPrivilege" 
            , "success = " success ) ) 
   ExitApp 

Process, Exist 
pid_this := ErrorLevel 

hp_this := DllCall( "OpenProcess" 
                  , "uint", 0x400                                 ; PROCESS_QUERY_INFORMATION 
                  , "int", false 
                  , "uint", pid_this ) 
if ( ReportError( ErrorLevel or hp_this = 0 
            , "OpenProcess: pid_this" 
            , "hp_this = " hp_this ) ) 
   ExitApp 

success := DllCall( "advapi32.dll\OpenProcessToken" 
                  , "uint", hp_this 
                  , "uint", 0x20                                 ; TOKEN_ADJUST_PRIVILEGES 
                  , "uint*", ht_this ) 
if ( ReportError( ErrorLevel or !success 
            , "OpenProcessToken: hp_this" 
            , "success = " success ) ) 
   ExitApp 

VarSetCapacity( token_info, 4+( 8+4 ), 0 ) 
   EncodeInteger( 1, 4, &token_info, 0 ) 
   EncodeInteger( luid_SeDebugPrivilege, 8, &token_info, 4 ) 
      EncodeInteger( 2, 4, &token_info, 12 )                           ; SE_PRIVILEGE_ENABLED 

success := DllCall( "advapi32.dll\AdjustTokenPrivileges" 
                  , "uint", ht_this 
                  , "int", false 
                  , "uint", &token_info 
                  , "uint", 0 
                  , "uint", 0 
                  , "uint", 0 ) 
if ( ReportError( ErrorLevel or !success 
            , "AdjustTokenPrivileges: ht_this; SeDebugPrivilege ~ SE_PRIVILEGE_ENABLED" 
            , "success = " success ) ) 
   ExitApp 

total := EnumProcesses( pid_list ) 

Gui, Add, Text,,`nBelow is a list of all running scripts that haven't been compiled. They need to be closed before AutoHotkey can be updated.`n
Gui, Add, ListView, w700 h250 vListview, PID|Script path

AHK_PID_List = ; intialise
AHK_Path_List =
loop, parse, pid_list, | 
  {
  Command_Line := GetRemoteCommandLine( A_LoopField )
  If Command_Line contains AutoHotkey.exe
    {
    If A_LoopField = %pid_this% ; skip script's own process
      Continue
    StringGetPos, Script_Path_Colon, Command_Line, :, R
    Script_Path_Colon -=1
    StringTrimLeft, Script_Path, Command_Line, %Script_Path_Colon%
    StringGetPos, Script_Path_End_Quote, Command_Line, ", R
    Script_Path_End_Quote := StrLen(Command_Line) - Script_Path_End_Quote
    StringTrimRight, Script_Path, Script_Path, %Script_Path_End_Quote%
    LV_Add( "", A_LoopField,  Script_Path ) 
    AHK_PID_List =%AHK_PID_List%|%A_LoopField% ; store
    AHK_Path_List =%AHK_Path_List%|%Script_Path%
    }
  }

LV_ModifyCol( 1, 0 ) 
LV_ModifyCol( 2, 696 ) 

Gui, Add, Button, w250 xm+410 gStop_Selected_Processes vStop_Selected_Processes, Stop ONLY selected processes && EXIT

Gui, Add, Checkbox, xm+200 y+35 Checked vClose_Help_File, Close AutoHotkey Help file?
Gui, Add, Button, w150 x+20 yp-5 gStop_Processes vStop_Processes, Stop all processes
Gui, Add, Button, w150 x+20 gRestart_Processes vRestart_Processes, Restart all processes
GuiControl, Disable, Restart_Processes
Gui, Show
Return 



Stop_Selected_Processes:
  GuiControl, Disable, Stop_Processes
  GuiControl, Disable, Restart_Processes
  GuiControl, Disable, Listview
  AHK_PID_List=
  RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
  Loop
    {
  	RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
  	if not RowNumber  ; The above returned zero, so there are no more selected rows.
  		break
  	LV_GetText(Text, RowNumber)
    AHK_PID_List =%AHK_PID_List%|%Text% ; store
    }
    Loop, Parse, AHK_PID_List, |
      {
      If A_LoopField =
        Continue
      Process, Close, %A_LoopField%
      }
  Msgbox, Processes ended. Now exiting.
  Gosub, GuiClose
Return



Stop_Processes:
  Gui, Submit, NoHide
  GuiControl, Disable, Stop_Processes
  GuiControl, Disable, Stop_Selected_Processes
  GuiControl, Disable, Listview
  Loop, Parse, AHK_PID_List, |
    {
    If A_LoopField =
      Continue
    Process, Close, %A_LoopField%
    }
  If Close_Help_File
    {
    GroupAdd, Close_Help_File, AutoHotkey Help ; in case more than 1 window open
    WinClose, ahk_group Close_Help_File
    }
  GuiControl, Enable, Restart_Processes
  Msgbox, Processes ended. Update AutoHotkey now, then restart the processes.
Return


Restart_Processes:
  Loop, Parse, AHK_Path_List, |
    {
    If A_LoopField =
      Continue
    StringGetPos, Script_Path_End_Slash, A_LoopField, \, R
    StringMid, Script_WorkingDir, A_LoopField,1, %Script_Path_End_Slash%
    Run, %A_LoopField%, %Script_WorkingDir%
;    Sleep, 300
    }
  Msgbox, Finished restarting process. Now exiting.
  Gosub, GuiClose
Return



GuiClose:
GuiEscape:
HandleExit: 
   DllCall( "CloseHandle", "uint", ht_this ) 
   DllCall( "CloseHandle", "uint", hp_this ) 
ExitApp 



EncodeInteger( p_value, p_size, p_address, p_offset ) 
{ 
   loop, %p_size% 
      DllCall( "RtlFillMemory", "uint", p_address+p_offset+A_Index-1, "uint", 1, "uchar", p_value >> ( 8*( A_Index-1 ) ) ) 
} 

ReportError( p_condition, p_title, p_extra ) 
{ 
   if p_condition 
      MsgBox, 
         ( LTrim 
            [Error] %p_title% 
            EL = %ErrorLevel%, LE = %A_LastError% 
             
            %p_extra% 
         ) 
    
   return, p_condition 
} 

EnumProcesses( byref r_pid_list ) 
{ 
   if A_OSVersion in WIN_95,WIN_98,WIN_ME 
   { 
      MsgBox, This Windows version (%A_OSVersion%) is not supported. 
      return, false 
   } 
    
   pid_list_size := 4*1000 
   VarSetCapacity( pid_list, pid_list_size ) 
    
   status := DllCall( "psapi.dll\EnumProcesses", "uint", &pid_list, "uint", pid_list_size, "uint*", pid_list_actual ) 
   if ( ErrorLevel or !status ) 
      return, false 
       
   total := pid_list_actual//4 

   r_pid_list= 
   address := &pid_list 
   loop, %total% 
   { 
      r_pid_list := r_pid_list "|" ( *( address )+( *( address+1 ) << 8 )+( *( address+2 ) << 16 )+( *( address+3 ) << 24 ) ) 
      address += 4 
   } 
    
   StringTrimLeft, r_pid_list, r_pid_list, 1 
    
   return, total 
} 

GetModuleFileNameEx( p_pid ) 
{ 
   if A_OSVersion in WIN_95,WIN_98,WIN_ME 
   { 
      MsgBox, This Windows version (%A_OSVersion%) is not supported. 
      return 
   } 

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid ) 
   if ( ErrorLevel or h_process = 0 ) 
      return 
    
   name_size = 255 
   VarSetCapacity( name, name_size ) 
    
   result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size ) 
    
   DllCall( "CloseHandle", h_process ) 
    
   return, name 
} 

GetRemoteCommandLine( p_pid_target ) 
{ 
   hp_target := DllCall( "OpenProcess" 
                     , "uint", 0x10                              ; PROCESS_VM_READ 
                     , "int", false 
                     , "uint", p_pid_target ) 
   if ( ErrorLevel or hp_target = 0 ) 
   { 
      result = < error: OpenProcess > EL = %ErrorLevel%, LE = %A_LastError%, hp_target = %hp_target% 
      Gosub, return 
   } 

   hm_kernel32 := DllCall( "GetModuleHandle", "str", "kernel32.dll" ) 

   pGetCommandLineA := DllCall( "GetProcAddress", "uint", hm_kernel32, "str", "GetCommandLineA" ) 

   buffer_size = 6 
   VarSetCapacity( buffer, buffer_size ) 

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pGetCommandLineA, "uint", &buffer, "uint", buffer_size, "uint", 0 ) 
   if ( ErrorLevel or !success ) 
   { 
      result = < error: ReadProcessMemory 1 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
      Gosub, return 
   } 

   loop, 4 
      ppCommandLine += ( ( *( &buffer+A_Index ) ) << ( 8*( A_Index-1 ) ) ) 
    
   buffer_size = 4 
   VarSetCapacity( buffer, buffer_size, 0 ) 

   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", ppCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 ) 
   if ( ErrorLevel or !success ) 
   { 
      result = < error: ReadProcessMemory 2 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
      Gosub, return 
   } 

   loop, 4 
      pCommandLine += ( ( *( &buffer+A_Index-1 ) ) << ( 8*( A_Index-1 ) ) ) 

   buffer_size = 32768 
   VarSetCapacity( result, buffer_size, 1 ) 
    
   success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 ) 
   if ( !success ) 
   { 
      loop, %buffer_size% 
      { 
         success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine+A_Index-1, "uint", &result, "uint", 1, "uint", 0 ) 
          
         if ( !success or Asc( result ) = 0 ) 
         { 
            buffer_size := A_Index 
            break 
         } 
      } 
      success := DllCall( "ReadProcessMemory", "uint", hp_target, "uint", pCommandLine, "uint", &result, "uint", buffer_size, "uint", 0 ) 
      if ( ErrorLevel or !success ) 
      { 
         result = < error: ReadProcessMemory 3 > EL = %ErrorLevel%, LE = %A_LastError%, success = %success% 
         Gosub, return 
      } 
   } 

return: 
   DllCall( "CloseHandle", "uint", hp_target ) 
    
   return, result 
}
