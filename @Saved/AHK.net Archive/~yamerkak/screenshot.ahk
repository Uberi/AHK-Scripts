; Script Name:   ScreenShot Hotkey
; Version:   v1.3.2
; Author:   silveredge78
{
;
; This script uses Irfanview's command line options to create a screenshot
; and then automatically save it to a specified directory, with the filename
; including a timestamp.
;
; It is based off of the script found at
; http://www.ghisler.ch/wiki/index.php/AutoHotkey:_Make_a_Screenshot_of_the_current_Window_with_Irfanview
;
; Template structure based off of toralf's template.ahk found at
; http://www.autohotkey.com/forum/topic7551.html
;
; Changelog:
; v1.3.2, 09/17/07
; - Added checking for SS_Ext to be JPG or TIF, and if so to allow for a default save quality/compression.
; - Added variable SS_JPG and SS_TIF to set the default save quality/compression, declared in the function.
;   - TIF Compression levels: 0 - None, 1 - LZW, 2 - Packbits, 3 - Fax3, 4 - Fax4, 5 = Huffman, 6 - JPG, 7 - ZIP
; - Added SS_Extra to allow for the extra parameter to be passed in the command line call.
;
; v1.3.1, 08/07/07
; - Moved SS_Folder, SS_IView, SS_Ext variables back to inside of TakeScreenshot() function to allow for
;   use as an include
;
; v1.3.0, 08/03/07
; - Cleaned up script structure to be more consistent
; - Moved SS_Folder, SS_IView to variable declaration section
;   - Adjusted Capture function to look for those as global variables
; - Added SS_Ext variable for easy changing of file type
; - Adjusted TrayTip function to report what file type it is captured using.
;
; v1.2.1, 01/24/07
; - Adjusted filename to be HHMM.SS instead of HH.MM.SS.
;
; v1.2.0, 08/10/06
; - Added traytips to notify the user that the capture completed.
;
; v1.1.1, 08/04/06
; - Changed SS_Folder to open minimized directly rather than after opening
; - Added pause before opening SS_Folder to allow capture to finish to prevent incorrect capture
;
; v1.1.0, 08/01/06
; - Added FolderOpen function to check for whether SS_Folder is open & if not, open & minimize the folder
; - Commented out function for !Printscreen so as to not bypass normal screen capture ability
; - Added variable for SS_IView, for easier setting of Iview32.exe location
; - Moved declaration of SS_Folder and SS_IView to beginning of TakeScreenshot function
;
; v1.0.0, 07/25/06
; - Added ability to use variants of PrintScreen to be used to capture
;   desktop, window, client area
; - Cleaned up original script to run via a function
; - Added in system variables for less manual configuration of folders

;********** Settings, variable declarations **********

#SingleInstance Force
OnExit, quit

ProgramName = Screenshot Hotkey
programVersion = 1.3.2
programFullName = %ProgramName% v%programVersion%
programAuthor = silveredge78
}
;********** Auto-execute section **********

; set representative icon - DEBUG: optional
Menu, Tray, Icon, Shell32.dll, 95, 1
; process command line parameters
GoSub, getParams
; construct tray menu - DEBUG: optional
GoSub, trayMenu
  CapMethod = 4   ; Takes a screenshot of selection, with tags
  fileread, ovar, screenvar.txt
  inputbox, var, Tags,,,,,,,,,%ovar%
  if (ErrorLevel)
  ExitApp
  Else
  TakeScreenshot(CapMethod,var)
; end of auto-execute section
Return

;********** hotkeys **********
{
;~ ^AppsKey::   ; Whole Desktop
;~   CapMethod = 0   ; Takes a screenshot of the whole desktop
;~   TakeScreenshot(CapMethod,"")
;~ Return

;~ ^!AppsKey::   ; Active window
;~   CapMethod = 2   ; Takes a screenshot of the active window
;~   TakeScreenshot(CapMethod,"")
;~ Return
;~ !AppsKey::   ;Takes a selection
;~   CapMethod = 4   ; Takes a screenshot 
;~   TakeScreenshot(CapMethod,"")
;~ Return

;~ #AppsKey::   ; 
;~   CapMethod = 4   ; Takes a screenshot of selection, with tags
;~   inputbox,var,Tags
;~   TakeScreenshot(CapMethod,var)
;~ Return

;~ ^#AppsKey::   ; Takes a screenshot of whole screen, with tags
;~   CapMethod = 0    
;~   inputbox,var,Tags
;~   TakeScreenshot(CapMethod,var)
;~ Return
}

/*
!PrintScreen::   ; [Alt]+[PrintScreen]
  CapMethod = 2   ; Takes a screenshot of the client area
  TakeScreenshot(CapMethod)
Return

!Esc::      ; [ALT]+[ESC]: terminate script
  Suspend ; exempt from suspension - DEBUG: optional
  GoSub, quit
Return
*/

;********** Functions **********
; Function to capture screenshot
TakeScreenshot(CapMethod,var)
{
  SS_Folder = C:\Users\Nathan\Documents\screenshot\%var%              ; Sets the folder to save in
  SS_IView = C:\Program Files (x86)\IrfanView\i_view32.exe      ; Sets the location of Irfanview
  SS_Ext = jpg                     ; Sets the extension (file type) to save with
  SS_JPG = 100                     ; Sets the default JPG save quality (0-100)
  SS_TIF = 0                     ; Sets the default TIF compression level
  filedelete, screenvar.txt
  fileappend, %var%,screenvar.txt
  IfNotExist, %SS_Folder%               ; Checks if the folder exists
    FileCreateDir, %SS_Folder%               ; If it doesn't, it creates it

  FormatTime, TimeStamp,A_now,yyyy-MM-dd_HHmm.ss      ; Formats the current timestamp for naming purposes

  If SS_Ext = jpg
    SS_Extra = /jpgq=%SS_JPG%               ; Sets the extra command line for JPG
  Else If SS_EXT = tif
    SS_Extra = /tifc=%SS_TIF%               ; Sets the extra command line for TIF

  ; Runs Irfanview via command line, using capture method selected by hotkey, & filetype specified above.
  Run, %SS_IView% "/capture=%CapMethod% /convert=%SS_Folder%\screenshot-%TimeStamp%_%var%.%SS_Ext% %SS_Extra%"
  Sleep 1000
  ;FolderOpen(SS_Folder)
  InfoTrayTip(CapMethod,SS_Ext)
}

; Function to popup tray tip, notifying user what kind of capture was made
InfoTrayTip(CapMethod,SS_Ext)
{
  If CapMethod = 1
    Tip = Desktop
  Else
    Tip = Active Window
  TrayTip,%ProgramName%, %Tip% captured as %SS_Ext%,,1
  SetTimer, RemoveTrayTip, 2000
}

; Function to check if SS_Folder is open or not, if not, it will open & minimize
FolderOpen(SS_Folder)
{
  IfWinExist, %SS_Folder%
    Return
  Else
    Run, %SS_Folder%, , Min
}

;********** Subroutines **********
   
RemoveTrayTip:
  SetTimer, RemoveTrayTip, Off
  TrayTip
Return

; construct tray menu - DEBUG: optional
trayMenu:
  ; disable standard menu items
  Menu, Tray, NoStandard
  ; show info message
  Menu, Tray, Add, &About, About
  ; separator
  Menu, Tray, Add
  ; terminate script
  Menu, Tray, Add, &Quit, quit
Return

; process command line parameters
getParams:
  If 0 > 0
  {
    Loop, %0% ; for each parameter
    {
      param := %A_Index%
      ; check for switches
      StringLeft, paramType, param, 1
      If paramType = - ; switch indicator
      {
        ; determine type of switch
        StringMid, switch, param, 2, 1
        ; switch
        If switch = x ; DEBUG: template (replace "x")
        {
          ; access value (= next parameter)
          param = % A_Index + 1
          var_x := %param% ; DEBUG: template (replace "var_x")
          MsgBox, var_x:`n%var_x% ; DEBUG: template (replace "var_x")
        }
      }
    }
  }
Return

; Show info message - DEBUG: toDo
About:
  MsgBox, 64, %programFullName%,
  ( LTrim Join
  %programFullName%`n
  Author: %programAuthor%`n
  `n
  This script uses Irfanview's command line options to create a screenshot`n
  and then automatically save it to a specified directory, with the filename`n
  including a timestamp.`n
  `n
  Use [Ctrl]+[PrintScreen] to take a screenshot of the whole desktop.`n
  Use [Ctrl]+[Alt]+[PrintScreen] to take a screenshot of the active window.`n
  `n
  Use [ALT]+[ESC] to terminate the program.
  )
Return

; Terminate script
Quit:
  ExitApp
Return