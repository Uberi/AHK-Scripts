;
;
; Name:           AutoScriptPlayer.ahk
; Version:        0.1
; Date:           03 May 2006
; Author:         Johny
; Platform:       Win9x/XP
;
; Script Function:
;	AutoScriptWriter Play back macro
;       This macro can execute directly what has been recorded in AutoScriptWriter. 
; It use Win+p (play) to save and execute AutoScriptWriter text content in a temporary macro. 
; The temporary macro use Win+q to execute (can be changed)
;
; Requirements:
;  AutoHotKey Ver 1.0.40.12 or better installed with AutoScriptWriter II
;

;Functionnal variables. To preserve.
AppNameAndVer=AutoScriptPlayer Ver0.1
NoErr = .
TempEndSection = .
ErrorMsg = %NoErr%
WinWaitDelay=2


;User variables, To adjust as desired
AutoScriptWriterPath=%A_AhkPath%
AutoHotKeyPath=%A_AhkPath%
TempFile=%A_ScriptDir%\TempMacro.ahk

; Template added to temprary file, so it will be ready if macro is preserved
; Preserve the temporary macro execution key, last header line. Can be modified.
TempHeader1=; Name:           TempMacro.ahk
TempHeader2=; Version:        0.1
FormatTime, TimeString,,MMM yyyy
TempHeader3=; Date:           %TimeString%
TempHeader4=; Author:         Me <myemail@mydomain.org>
TempHeader5=; Platform:       Win9x/XP
TempHeader6=;
TempHeader7=; Script Function:
TempHeader8=;    Temporary script created with %AppNameAndVer%
TempHeader9=;
TempHeader10=; Use Windows+Q to execute
TempHeader11=`#q`::
TempHeader12=%TempEndSection%
TempFooter1=return
TempFooter2=%TempEndSection%


; Check if AutoScriptWriter is activated. Activate it if not.
IfWinNotExist, AutoScriptWriter II - ( by Larry Keys ),
{
   Run, AutoScriptWriter.exe, %AutoScriptWriterPath%   
}


;"Save and execute" key sequence pressed
#p::

   ; Prepare environment: 
   ;   Initialise variables
   ErrorMsg = %NoErr%      
   
   ;   Make AutoScriptWriter the active window
   WinWait, AutoScriptWriter II - ( by Larry Keys ),,%WinWaitDelay%
   if ErrorLevel
   {
      ErrorMsg="AutoScriptWriter" application not started or not found.
   } 
   else 
   {
      IfWinNotActive, AutoScriptWriter II - ( by Larry Keys ), , WinActivate, AutoScriptWriter II - ( by Larry Keys ), 
      WinWaitActive, AutoScriptWriter II - ( by Larry Keys ),       
   }

   ; Save AutoScriptWriter text to a temporary file
   ;  Use AutoScriptWriter "Save" button.
   if ErrorMsg = %NoErr%
   {
      Sleep, 100
      ControlFocus, Button12, AutoScriptWriter II - ( by Larry Keys )
      Sleep, 100
      Send, {TAB}{ALTDOWN}ss{ALTUP} ;Just in case ControlFocus wasn't sucessfull
      Sleep, 100      
      Send, %TempFile%{ENTER}
      Sleep, 200
      ;  minimize AutoScriptWriter, get it out of the way for macro playback
      WinMinimize, AutoScriptWriter II - ( by Larry Keys ),      
   }
      
   ; Read AutoScriptWriter temporary file   
   if ErrorMsg = %NoErr%
   {
      ; Open & read TempFile
      FileRead, TextFileData, %TempFile%
      if ErrorLevel
      {
         ErrorMsg="%TempFile%" read error
      } 
   }

   ; Add extra text to temporary file data
   if ErrorMsg = %NoErr%
   {
      ;  Add header & footer info         
      TempHeaderAll=
      Loop
      {
         CurrentTempLine:=TempHeader%A_Index%
         if CurrentTempLine=%TempEndSection%
         {
            ; Header is build, quit loop
            break
         }            
         TempHeaderAll=%TempHeaderAll%%CurrentTempLine%`r`n
      }
      TempFooterAll=
      Loop
      {
         CurrentTempLine:=TempFooter%A_Index%
         if CurrentTempLine=%TempEndSection%
         {
            ; Footer is build, quit loop
            break
         }            
         TempFooterAll=%TempFooterAll%%CurrentTempLine%`r`n
      }
      TextFileData=%TempHeaderAll%%TextFileData%`r`n%TempFooterAll%
   }
   
   ;  Update temporary file, replace if exist
   if ErrorMsg = %NoErr%
   {
      IfExist, %TempFile%
      {
         FileDelete, %TempFile%
         if ErrorLevel
         {
            ErrorMsg="%TempFile%" access error - cannot be deleted
         }                  
      }
   }
   if ErrorMsg = %NoErr%
   {
      FileAppend, %TextFileData%, %TempFile%
      if ErrorLevel
      {
         ErrorMsg="%TempFile%" write error
      }                        
   }

   ; Execute temporary file
   ;  If this macro has been activated before, the folloging execution will generate 
   ;  a message box saying "this macro exist, replace it?". This will be keept as is.
   if ErrorMsg = %NoErr%
   {
      Run, AutoHotkey.exe "%TempFile%", %AutoHotKeyPath%, UseErrorLevel
      if ErrorLevel
      {
         ErrorMsg="%TempFile%" execution error
      }                              
   }
   
   ; Error management
   if ErrorMsg <> %NoErr%
   {
      MsgBox, 16, %AppNameAndVer%, Error: %ErrorMsg%, 
      ExitApp, 1
   }  
return
