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
;
;
; Name:           AutoScriptPlayer.ahk
; Version:        0.2
; Date:           19 September 2006
; Author:         Johny
;
; Description:
;   Modify macro to support several "save & record" and "play" keys. The keys assigned are now:
;	  win+shift+q -> Save & execute a macro that will be played with win+q
;	  win+shift+a -> Save & execute a macro that will be played with win+a
;	  win+shift+z -> Save & execute a macro that will be played with win+z
;	  win+shift+w -> Save & execute a macro that will be played with win+w
;	  win+shift+s -> Save & execute a macro that will be played with win+s
;	  win+shift+x -> Save & execute a macro that will be played with win+x
;   win+shift+SpaceBar -> Direct Save & execute
 
 
;Functionnal variables. To preserve.
AppNameAndVer=AutoScriptPlayer Ver0.2
NoErr = .
TempEndSection = .
ErrorMsg = %NoErr%
WinWaitDelay=2


;User variables, To adjust as desired
AutoScriptWriterPath=%A_AhkPath%
AutoHotKeyPath=%A_AhkPath%
TempFilePath=%A_ScriptDir%

; Template added to temprary file, so it will be ready if macro is preserved
; Modify the "TempHeaderKey.." numbers if you add or remove some header lines.
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
TempHeaderKeyCommentNb=10
; This index will be assigned to something like: ";TempHeader10=; Use Windows+Q to execute" 
TempHeaderKeyNb=11
; This index will be assigned to something like: ";TempHeader11=`#q`::"
TempHeader12=%TempEndSection%
TempFooter1=return
TempFooter2=%TempEndSection%


; Check if AutoScriptWriter is activated. Activate it if not.
IfWinNotExist, AutoScriptWriter II - ( by Larry Keys ),
{
   Run, AutoScriptWriter.exe, %AutoScriptWriterPath%   
}


; *** Hotkey processing ***
;	  win+shift+q -> Save & execute a macro that will be played with win+q
+#q::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+Q to execute
  TempHeader%TempHeaderKeyNb%=`#q`::
  TempFile=%TempFilePath%\TempMacroQ.ahk 
  GoSub, FctSaveAndExec
return

;	  win+shift+a -> Save & execute a macro that will be played with win+a
+#a::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+A to execute
  TempHeader%TempHeaderKeyNb%=`#a`::
  TempFile=%TempFilePath%\TempMacroA.ahk
  GoSub, FctSaveAndExec
return

;	  win+shift+z -> Save & execute a macro that will be played with win+z
+#z::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+Z to execute
  TempHeader%TempHeaderKeyNb%=`#z`::
  TempFile=%TempFilePath%\TempMacroZ.ahk
  GoSub, FctSaveAndExec
return

;	  win+shift+w -> Save & execute a macro that will be played with win+w
+#w::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+W to execute
  TempHeader%TempHeaderKeyNb%=`#w`::
  TempFile=%TempFilePath%\TempMacroW.ahk
  GoSub, FctSaveAndExec
return

;	  win+shift+s -> Save & execute a macro that will be played with win+s
+#s::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+S to execute
  TempHeader%TempHeaderKeyNb%=`#s`::
  TempFile=%TempFilePath%\TempMacroS.ahk
  GoSub, FctSaveAndExec
return

;	  win+shift+x -> Save & execute a macro that will be played with win+x
+#x::
  TempHeader%TempHeaderKeyCommentNb%=; Use Windows+X to execute
  TempHeader%TempHeaderKeyNb%=`#x`::
  TempFile=%TempFilePath%\TempMacroX.ahk
  GoSub, FctSaveAndExec
return

;   win+shift+SpaceBar -> Direct Save & execute
+#Space::
  TempHeader%TempHeaderKeyCommentNb%=; No hotkey, direct execution
  TempHeader%TempHeaderKeyNb%=;
  TempFile=%TempFilePath%\TempMacroSpc.ahk
  GoSub, FctSaveAndExec
return


; *** Subroutines ***
; Name:   SaveAndExec
; by: Johny
; Description: 
;  - Save what's present in "AutoScriptWriter" text windows in a temporary file, 
;  - add the header and footer info into the temporary file
;  - execute the temporary file

FctSaveAndExec:
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
