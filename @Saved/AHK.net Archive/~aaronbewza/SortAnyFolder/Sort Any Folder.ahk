
; Sort Any Folder v1.2.1.0 (adapted by Aaron Bewza)

; Creates subfolders in selected folder and sorts files into them.
; User is then given choices to move sorted documents and pictures into
; User's regular Documents, Pictures and Music folders
; (Uses My Documents, My Pictures and My Music folders in XP).

;Subfolders created in User-selected folder (if files exist):

;Unsorted AHK Scripts
;Unsorted Documents
;Unsorted EXE Files
;Unsorted Music
;Unsorted PDF Files
;Unsorted Pictures
;Unsorted Video
;Unsorted Zip Files

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
  }

RegRead, KeyCheck, HKEY_CLASSES_ROOT, Folder\shell\Sort This Folder\command
If KeyCheck = ; If key does not exist
  GoSub WriteContextMenuKey

If (%0% <= 0) ; If User opens program instead of using the right-click function
  {
    FileSelectFolder, ChosenFolder, *%UserProfile%, 0, Hello`, %A_UserName%`.`nPlease select folder you wish to organize`:
    If ChosenFolder =
      GoSub, NoFolder ; If no folder is chosen, program exits
    If ChosenFolder = %A_ProgramFiles%
      GoSub, DoNotSort ; If Program Files folder is selected, User is denied
    If ChosenFolder = %A_WinDir%
      GoSub, DoNotSort ; If Windows folder is selected, User is denied
    If ChosenFolder = %A_Desktop%
      GoSub, DoNotSort ; If Desktop is selected, User is denied
  }
Else
  ChosenFolder = %1% ; Hooks up the location from the right-click "Sort This Folder" context menu

SetWorkingDir %ChosenFolder% ; Sets script working directory to selected folder
MsgBox, 4,,
  ( LTrim
    Are you sure you want to organize
    the folder located at`:

    %ChosenFolder%?

    Files will be moved to subfolders
    based on their extension names.
  )
IfMsgBox Yes
  GoSub, Organize ; Calls subroutine to create folders and organize files into them
IfMsgBox No
  {
    MsgBox, Operation aborted.`nProgram will now exit
    ExitApp
  }
Return


Organize: ; Checks for file extensions and only creates folders for existing extension names

FileTypes := "ahk,ahk.bak,bak" ; AutoHotkey script files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted AHK scripts ; Creates folder if any matches are found

FileTypes := "exe,msi" ; EXE files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted EXE Files ; Creates folder if any matches are found

FileTypes := "aac,aif,iff,m3u,mid,mpa,ra,wav,mp3" ; Music files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted Music ; Creates folder if any matches are found

FileTypes := "ini,wps,wpd, wpt,wrd,wri,msg,rtf,doc,docx,dot,dotx,log,wks,xls,xlsx,nfo,txt,htm,html,xhtml,xml,js,csv,egt,lwp,odm,odt,ott" ; Document files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted Documents ; Creates folder if any matches are found

FileTypes := "bmp,jpg,jpeg,ico,png,psd,psp,pspimage,thm,raw,tif,gif" ; Picture files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted Pictures ; Creates folder if any matches are found

FileTypes := "zip,rar,7z,gzip" ; Zip files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted Zip Files ; Creates folder if any matches are found

FileTypes := "3g2,3gp,asf,asx,avi,mov,mp4,mkv,mpg,mpeg,wmv,flv,swf,vob,rm,ram" ; Video files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
IfExist, *.%A_LoopField% ; Looks for file extension names from FileTypes line
  FileCreateDir, Unsorted Video ; Creates folder if any matches are found

IfExist, *.pdf ; Looks for PDF files
  FileCreateDir, Unsorted PDF Files ; Creates folder if any matches are found


; Sorts and moves files into created folders without overwriting identical file names

FileTypes := "ahk,ahk.bak,bak" ; AutoHotkey script files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted AHK scripts, 0 ; Moves files which match extension names

FileTypes := "exe,msi,dll" ; EXE files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted EXE Files, 0 ; Moves files which match extension names

FileTypes := "aac,aif,iff,m3u,mid,mpa,ra,wav,mp3" ; Music files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted Music, 0 ; Moves files which match extension names

FileTypes := "ini,wps,wpd,msg,rtf,doc,docx,log,wks,xls,xlsx,nfo,txt" ; Document files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted Documents, 0 ; Moves files which match extension names

FileTypes := "bmp,jpg,jpeg,ico,png,psd,psp,pspimage,thm,raw,tif,gif" ; Picture files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted Pictures, 0 ; Moves files which match extension names

FileTypes := "zip,rar,7z,gzip,ace,alz,at3,bke,arc,arj,ba,big,bik,bkf,bzip2,c4,cab,cals,daa,deb,eea,ecab,ess,gho,jar,lbr,lqr" ; Zip files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted Zip files, 0 ; Moves files which match extension names

FileTypes := "3g2,3gp,asf,asx,avi,mov,mp4,mkv,mpg,mpeg,wmv,flv,swf,vob,rm,ram" ; Video files
Loop, Parse, FileTypes, `, ; Parse using comma as a delimiter
FileMove, *.%A_LoopField%, Unsorted Video, 0 ; Moves files which match extension names

FileMove, *.pdf, Unsorted PDF Files, 0 ; Moves files which match extension names

Sleep 1000 ; Waits a second for FileMove to be completed


; Confirms sorting is finished and asks if User wants to move contents of Unsorted Documents into User's Documents folder (My Documents in XP)
MsgBox, 4,,
  ( LTrim
    Sorting completed!
    Do you want to move the documents inside`:

    %ChosenFolder%\Unsorted Documents

    ...into your Documents folder?

    (Files with the same names as in
    your Documents folder will not be moved)
  )
IfMsgBox Yes
  GoSub, MoveDocs ; Calls subroutine to move contents of Unsorted Documents

; Asks if User wants to move contents of Unsorted Pictures into User's Pictures folder (My Pictures in XP)
MsgBox, 4,,
  ( LTrim
    Do you want to move the pictures inside`:

    %ChosenFolder%\Unsorted Pictures

    ...into your Pictures folder?

    (Files with the same names as in
    your Pictures folder will not be moved)
  )
IfMsgBox Yes
  GoSub, MovePics ; Calls subroutine to move contents of Unsorted Pictures

; Asks if User wants to move contents of Unsorted Music into User's Music folder (My Music in XP)
MsgBox, 4,,
  ( LTrim
    Do you want to move the music inside`:

    %ChosenFolder%\Unsorted Music

    ...into your Music folder?

    (Files with the same names as in
    your Music folder will not be moved)
    )
IfMsgBox Yes
  GoSub, MoveMusic ; Calls subroutine to move contents of Unsorted Music
IfMsgBox No
  MsgBox, Operation finished.`nProgram will now exit.
  ExitApp
Return

; Subroutines

NoFolder:
  MsgBox, You didn't select a folder.`nProgram will now exit.
  ExitApp
Return

DoNotSort:
  MsgBox, It would be a bad idea to sort this folder:`n`n%ChosenFolder%`n`nPlease select a different folder.
  Reload
Return

WriteContextMenuKey:
MsgBox,4,,
  ( LTrim
    Would you like to add a "Sort This Folder" entry
    to your right-click context menu? This will allow
    you to right-click any folder and sort it,
    without running the program first.
  )
IfMsgBox Yes
  {
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT, Folder\shell\Sort This Folder\command,, %A_ScriptDir%\Sort Any Folder.exe "`%1"
    FileDelete, %A_ScriptDir%\Remove Context Menu Entry.reg
    FileAppend,
      ( LTrim
        Windows Registry Editor Version 5.00`n
        [-HKEY_CLASSES_ROOT\Folder\shell\Sort This Folder]
      ), %A_ScriptDir%\Remove Context Menu Entry.reg ; Creates .reg file that removes right-click context menu item
    MsgBox,
      ( LTrim
      "Sort Any Folder" is now in your right-click context menu.
      To remove this entry, use the "Remove Context Menu Entry.reg" file that
      was just created in your current script directory. If you
      have to move the exe file after you've created the menu entry,
      please remove the menu entry or it won't point to the exe anymore.
      )
    ExitApp ; Exits program if entry is written in context menu... User can simply right-click from this point on
  }
IfMsgBox No
Return

MoveDocs:
  FileMove, %ChosenFolder%\Unsorted Documents\*.*, %A_MyDocuments%, 0 ; Moves contents of Unsorted Documents into User's Documents folder (My Documents in XP)
  Sleep 500 ; Waits half a second for FileMove to be completed
Return

MovePics:
  RegRead, MyPicturesVar, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, My Pictures ; looks for User's Pictures folder location
  FileMove, %ChosenFolder%\Unsorted Pictures\*.*, %MyPicturesVar%, 0 ; Moves contents of Unsorted Pictures into User's Pictures folder (My Pictures in XP)
  Sleep 500 ; Waits half a second for FileMove to be completed
Return

MoveMusic:
  RegRead, MyMusicVar, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, My Music ; looks for User's Music folder location
  FileMove, %ChosenFolder%\Unsorted Music\*.*, %MyMusicVar%, 0 ; Moves contents of Unsorted Music into User's Music folder (My Music in XP)
  Sleep 500 ; Waits half a second for FileMove to be completed
  MsgBox, Operation finished.`nProgram will now exit. ; Displays when FileMove is completed
ExitApp
Return
