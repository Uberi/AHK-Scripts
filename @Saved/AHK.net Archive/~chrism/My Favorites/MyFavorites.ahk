; Easy Access to Favorite Shortcuts -- by ChrisM
; LAST UPDATED: JAN 13 2007

; http://www.autohotkey.com
; Tested with version 1.0.46.05 on Win/XP

; Based on:
; Easy Access to Favorite Folders -- by Savage

; When you click the middle mouse button while certain types of
; windows are active, this script displays a menu of your favorite
; shortcuts.  Upon selecting a favorite, the script will instantly
; switch to that folder, file or url within the active window or, if desired,
; execute the default action for that type of shortcut.  The following
; window types are supported: 1) Standard file-open or file-save
; dialogs; 2) Explorer windows; 3) Console (command prompt)
; windows; 4) Microsoft Office file Open and Save As dialogs.
; The menu can also be optionally shown for unsupported window
; types, in which case the default action for that type of shortcut will be
; executed.

; Note: In Windows Explorer, if "View > Toolbars > Address Bar" is
; not enabled, the menu will not be shown if the hotkey chosen below
; has a tilde.  If it does have a tilde, the menu will be shown
; but the favorite will be opened in a new Explorer window rather
; than switching the active Explorer window to that folder.
;
; In order to add items through the menu turn on the option ( if available )
; to display the full path in your application's title bar.

; Revisions - by JHoward
; Added support for Microsoft Office Open and Save As dialog boxes.
;
; Revisions - by Sandeep
; Menu items now point to folder shortcuts ( link files ) in the
; directory of your choice. The name of the shortcut is what appears
; in the popup menu. The shortcut's target is used to switch the
; active window.
;
; Revisions - by ChrisM
; Three menu items always appear at the bottom:
;  - Add Folder to Favorites - allows the user to add new folder shortcuts.
;  - Add File to Favorites - allows the user to add new file shortcuts.
; Valid paths can be extracted from any window title or from the clipboard.
;  - Edit Favorites Folder - conveniently opens an explorer window
; to the link files.
; Adding numbers to the start of link file names will sort the
; menu in that order. The menu is alphabetically sorted.
; Added the default shortcut name as the found path with the ':' and '\'
; replaced with spaces to make a legal link file name.
; Any shortcut file type can be shown ( .lnk .url and .pif )
; Submenus are made from subfolders in the 'f_shortcuts_folder' if they contain
; shortcuts.
; Order of items specified by putting 'menu=(integer)' anywhere in comment field
; of the shortcut. No spaces allowed. Not case sensitive.
; Seperator lines specified by putting 'menu=(integer) blank' anywhere in comment
; field of the shortcut. Spaces before 'blank' optional. Not case sensitive.

; Revisions - by Savage (again)
; Subfolders in the f_shortcuts_folder now appear as submenus in
; the popup menu. Also includes support for Directory Opus and Console


;---------------------- USER CONFIGURATION SECTION STARTS --------------------
; CONFIG: CHOOSE DIRECTORY TO HOLD SHORTCUTS
; Set the following variable to the folder name to hold all your shortcuts.
; It will be created if it does not exist. The suggested place is
; %HOMEPATH%\My Documents\Favorites for easy access from other apps.
f_shortcuts_folder = %HOMEPATH%\My Documents\Favorites

; CONFIG: CHOOSE RELOADING
; Set the following variable to 'y' to always reload the menu and 'n' to
; disable automatic reloading. Keep this 'y' unless you have a really
; long list, because it harldy takes any time to load. But if you
; don't change your list very often, then you may want to keep it 'n'.
; Enter y or n
f_AlwaysReload = y


; CONFIG: CHOOSE WHEN TO SHOW THE MENU
; Setting the following variable to 'n' tells the script to avoid showing
; the menu for unsupported window types.
; Setting the following variable to 'y' tells the script to always
; display the menu; and upon selecting a favorite while an unsupported
; window type is active, the default action will be performed on the
; selected shortcut.   Enter y or n
f_AlwaysShowMenu = y


; CONFIG: CHOOSE YOUR HOTKEYS
; If your mouse has more than 3 buttons, you could try using
; XButton1 (the 4th) or XButton2 (the 5th) instead of MButton.
; You could also use a modified mouse button (such as ^MButton) or
; a keyboard hotkey.  In the case of MButton, the tilde (~) prefix
; is used so that MButton's normal functionality is not lost when
; you click in other window types, such as a browser.
f_Hotkey1 = ^MButton

;Also define a keyboard shortcut to the menu
f_Hotkey2 = ^+f ; Control+Shift+f


; Uncomment any 'Menu' line of a Windows special folder you want in the list.
Special_Folders( a )
  {
    global

    ; Add a separator line.
    Menu, %a%, Add
    ; Add a command to open "My Computer" special folder.
    Menu, %a%, Add, My Computer, f_My_Computer
    ; Add a command to open "My Documents" special folder.
    Menu, %a%, Add, My Documents, f_My_Documents
    ; Add a command to open "Network Neighbourhood" special folder.
    Menu, %a%, Add, My Network Places, f_My_Network_Places
    ; Add a command to open "Default Navigator" special folder.
    Menu, %a%, Add, Default Navigator, f_Default_Navigator
    ; Add a command to open "Control Panel" special folder.
    ;  Menu, %a%, Add, Control Panel, f_Control_Panel
    ; Add a command to open "Printers and Faxes" special folder.
    ;  Menu, %a%, Add, Printers and Faxes, f_Printers_and_Faxes
    ; Add a command to open "Fonts" special folder.
    ;  Menu, %a%, Add, Fonts, f_Fonts
    ; Add a command to open "Scanners and Cameras" special folder.
    ;  Menu, %a%, Add, Scanners and Cameras, f_Scanners_and_Cameras
    ; Add a command to open "Network Connections" special folder.
    ;  Menu, %a%, Add, Network Connections, f_Network_Connections
    ; Add a command to open "Recycle Bin" special folder.
    ;  Menu, %a%, Add, Recycle Bin, f_Recycle_Bin
    ; Add a command to open "Scheduled Tasks" special folder.
    ;  Menu, %a%, Add, Scheduled Tasks, f_Scheduled_Tasks
    ; Add a command to open "Administration Tools" special folder.
    ;  Menu, %a%, Add, Administration Tools, f_Administration_Tools
    ; Add a command to open "Web Folders" special folder.
    ;  Menu, %a%, Add, Web Folders, f_Web_Folders

    Return
  }

;-------------------- END OF CONFIGURATION SECTION ------------------------
; Do not make changes below this point unless you want to change
; the basic functionality of the script.

#NoTrayIcon
#SingleInstance  ; Needed since the Hotkey is dynamically created.

Hotkey, %f_Hotkey1%, f_DisplayMenu
Hotkey, %f_Hotkey2%, f_DisplayMenu

; Check if %f_shortcuts_folder% exists, if not - create
FileGetAttrib, attrib, %f_shortcuts_folder%
IfNotInString, attrib, D
  {
    FileCreateDir, %f_shortcuts_folder%
    If ErrorLevel
        MsgBox, The folder %f_shortcuts_folder% could not be created
    . `nCheck that the 'f_shortcuts_folder' variable in the Config Section of the script is a valid path to a writable folder
    . `nCannot save Favorites links.
  }
f_NotFirstTime =

Return


;----Build the menu from link files found in f_shortcuts_folder.
f_CreateMenu:
  If f_AlwaysReload != y
    {
      If f_NotFirstTime = True
          Return
    }

  BuildMenu( f_shortcuts_folder, f_shortcuts_folder )

  f_NotFirstTime = True

  Special_Folders( f_shortcuts_folder )

  ; Add a separator line.
  Menu, %f_shortcuts_folder%, Add
  ; Add a command to capture the current folder address.
  Menu, %f_shortcuts_folder%, Add, Add Folder to Favorites, f_AddFolder
  ; Add a command to capture the current application.
  Menu, %f_shortcuts_folder%, Add, Add File to Favorites, f_AddFile
  ; Add a command to allow the user to edit the shortcuts.
  Menu, %f_shortcuts_folder%, Add, Edit Favorites Folder, f_EditFavorites
  ; Show Reload menu only if not set to Reload on every popup.
  If f_AlwaysReload = n
      Menu, %f_shortcuts_folder%, Add, Reload, Reload
Return


BuildMenu( testPath, menu )
  {
    local MenuName, folderList, nextMenu, fileList, MenuItemName
    local nameHash, incr, num, shortPath, len, varName

    If Menu =
        MenuName := testPath
    Else
        MenuName := Menu

    If f_NotFirstTime = True
        Menu, %MenuName%, DeleteAll

    ; Add all subfolders to menu as submenus
    Loop, %MenuName%\*, 2
        folderList = %folderList%`n%A_LoopFileFullPath%
    Sort, folderList
    Loop, Parse, folderList, `n
      {
        If A_LoopField =
            Continue
        MenuItemName := FileShortName( A_LoopField )
        nextMenu := BuildMenu(A_LoopField,"")
        If nextMenu !=
            Menu, %MenuName%, add, %MenuItemName%, :%nextMenu%
      }

    ; Add a separator line only if there were any subfolders.
    If %folderList%
        Menu, %MenuName%, Add

    ; Add all link files in this 'menuName' to the menu
    Loop, %MenuName%\*, 0
        fileList = %fileList%%A_LoopFileFullPath%`n
    ; Sort the fileList according to the number in the link comment field.
    fileList := f_LinkSort( fileList )

    shortPath := ShortenPath( MenuName )
    pathHash := String2Hex( shortPath )
    varName = f_MenuName[%pathHash%]
    f_TestVarNameLength( varName )
    array = f_MenuName[%pathHash%]
    varName = f_MenuCount[%pathHash%]
    f_TestVarNameLength( varName )
    f_MenuCount[%pathHash%] = 0
    Loop, Parse, fileList, `n
      {
        If A_LoopField =
          {
            Menu, %MenuName%, add
            Continue
          }
        MenuItemName := FileShortName( A_LoopField, "last" )

        ; Build an array of menu names to check for duplicates now and in f_AddToFavorites.
        num := f_MenuCount[%pathHash%]
        incr = 0
        Loop
          {
            If ( f_DuplicateItems( array, num, MenuItemName ) == 0 )
              {
                incr++
                MenuItemName = %MenuItemName%%incr%
              }
            Else
                Break
          }
        f_MenuCount[%pathHash%]++
        num := f_MenuCount[%pathHash%]
        Transform, %array%%num%, Deref, %MenuItemName%

        ; Build an array whose indices is the menu item name and contents is the full link file name.
        nameHash := String2Hex( MenuItemName )
        varName = f_fullName[%pathHash%][%nameHash%]
        f_TestVarNameLength( varName )
        Transform, f_fullName[%pathHash%][%nameHash%], Deref, %A_LoopField%

        Menu, %MenuName%, add, %MenuItemName%, f_OpenFavorite
      }
    If fileList =
        Return ""
    Else
        Return MenuName
  }


; Test dynamic variable name length before we assign it.
; Max variable name length allowed is 253.
f_TestVarNameLength( name )
  {
    StringLen, len, name
    If ( len > 252 )
      {
        MsgBox, Warning!`n A subfolder name or nested subfolder names is too long
        . `nThe base folder will now be opened to allow you to shorten it!
        Gosub, f_EditFavorites
        ; Exit current thread since it will fail anyway since a variable name is
        ; too long. Script will not exit since it is persistent.
        Exit
      }
    Return
  }


; Get comment of each link. Search for number after prefix. Sort by number.
; Any links without number add to end sorted by alpha on link name.
f_LinkSort( linkList )
  {
    prefix = Menu=
    Loop, Parse, linkList, `n
      {
        If ( A_LoopField == "" )
            Continue
        FileGetShortcut, %A_LoopField%,,,, comment
        StringLower, comment, comment
        ; Store comment for finding blanks later.
        shortName := FileShortName( A_LoopField )
        nameHash := String2Hex( shortName )
        varName = comment%nameHash%
        f_TestVarNameLength( varName )
        comment%nameHash% = %comment%

        StringGetPos, pos, comment, %prefix%
        If ( pos > -1 )
          {
            len := StrLen( prefix )
            pos += len
            StringTrimLeft, rem, comment, %pos%
            good =
            Loop, Parse, rem
              {
                If A_LoopField is Integer
                    good = %good%%A_LoopField%
                Else
                    Break
              }
            If %good%
              {
                Loop
                  {
                    If ( array%good% != "" )
                        good++
                    Else
                        Break
                  }
                array%good% := A_LoopField
                If ( good > maxGood )
                    maxGood = %good%
              }
          }
        Else
          {
            noIndex = %noIndex%%A_LoopField%`n
          }
      }
    Loop, %maxGood%
      {
        If ( array%A_Index% != "" )
          {
            tempvar := array%A_Index%
            newList = %newList%%tempvar%`n
          }
      }
    If ( noIndex != "" )
      {
        Sort, noIndex
        newList = %newList%%noIndex%
      }
    ; Get rid of the last newline.
    StringTrimRight, newList, newList, 1
    ; Add blank lines if 'blank' appears after 'prefix'.
    Loop, Parse, newList, `n
      {
        nl =
        shortName := FileShortName( A_LoopField )
        nameHash := String2Hex( shortName )
        varName = comment%nameHash%
        f_TestVarNameLength( varName )
        comment := comment%nameHash%
        StringGetPos, pos, comment, %prefix%
        If ( pos > -1 )
          {
            len := StrLen( prefix )
            pos += len
            StringTrimLeft, rem, comment, %pos%
            str =
            Loop, Parse, rem
              {
                str = %str%%A_LoopField%
                If str is not Integer
                  {
                    StringGetPos, pos, rem, blank
                    If ( pos + 1 = A_Index )
                        nl = `n
                    Break
                  }
              }
          }
        newerList = %newerList%%A_LoopField%`n%nl%
      }
    ; Get rid of the last newline.
    StringTrimRight, newerList, newerList, 1

    Return %newerList%
  }

Reload:
  Reload  ; The Menu will be rebuilt at next popup.
Return


;----Display the menu
f_DisplayMenu:
  ; These first few variables are set here and used by f_OpenFavorite:
  WinGet, f_window_id, ID, A
  WinGet, f_window_min, MinMax
  If ( f_window_min == -1 ) ; Only detect windows not Minimized.
      f_window_id =
  WinGetClass, f_class, ahk_id %f_window_id%
  If f_class in #32770,ExploreWClass,CabinetWClass,dopus.lister  ; Dialog or Explorer.
      ControlGetPos, f_Edit1Pos,,,, Edit1, ahk_id %f_window_id%
  If f_AlwaysShowMenu = n  ; The Menu should be shown only selectively.
    {
      If f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
        {
          If f_Edit1Pos =  ; The Control doesn't Exist, so don't display the Menu
              Return
        }
      Else If f_class <> ConsoleWindowClass
        {
          IfNotInString, f_class, bosa_sdm_  ; Microsoft Office application
              Return ; Since it's some other window type, don't display Menu.
        }
    }
  ; Otherwise, the menu should be presented for this type of window:
  Gosub f_CreateMenu
  Menu, %f_shortcuts_folder%, show
Return


;----Open the selected favorite
f_OpenFavorite:
  f_Open()
Return


f_Open()
  {
    local favPath, nameHash, fullName, ext, target, text

    favPath = %f_shortcuts_folder%
    ; Fetch the full link file name that corresponds to the selected menu item:
    shortPath := ShortenPath( A_ThisMenu )
    pathHash := String2Hex( shortPath )
    nameHash := String2Hex( A_ThisMenuItem )
    fullName := f_fullName[%pathHash%][%nameHash%]

    SplitPath, fullName, , , ext
    ; If .url, run it seperate.
    If ( ext == "url" )
      {
        Run, %fullName%,, UseErrorLevel
        StringUpper, tmp, ErrorLevel
        If ( tmp == "ERROR" )
            MsgBox, 4096, Error, Could not Run: %fullName%, 30
        ;msgbox, %A_LastError%
        Return
      }

    ; Fetch a link file's target that corresponds to the selected menu item:
    If ext in lnk,pif
        FileGetShortcut, %fullName%, target
    SplitPath, target, , , ext
    ; If executable, run it seperate.
    If ext in exe,bat,com
      {
        Run, %fullName%,, UseErrorLevel
        StringUpper, tmp, ErrorLevel
        If ( tmp == "ERROR" )
            MsgBox, 4096, Error, Could not Run: %fullName%, 30
        Return
      }
    f_Open_Target( target )
    Return
  }

f_Open_Target( target )
  {
    global f_class, f_Edit1Pos, f_window_id

    ; It's a dialog.
    If f_class = #32770
      {
        If f_Edit1Pos <>   ; And it has an Edit1 Control.
          {
            ; Activate the window so that if the user is middle-clicking
            ; outside the dialog, subsequent clicks will also work:
            WinActivate ahk_id %f_window_id%
            ; Retrieve any filename that might already be in the field so
            ; that it can be restored after the switch to the new folder:
            ControlGetText, text, Edit1, ahk_id %f_window_id%
            ControlSetText, Edit1, %target%, ahk_id %f_window_id%
            ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
            Sleep, 100  ; It needs extra time on some dialogs or in some cases.
            ControlSetText, Edit1, %text%, ahk_id %f_window_id%
            Return
          }
        ; else fall through to the bottom of the subroutine to take standard action.
      }
    ; In Explorer, switch folders.
    Else If f_class in ExploreWClass,CabinetWClass,dopus.lister
      {
        If f_Edit1Pos <>   ; And it has an Edit1 Control.
          {
            ControlSetText, Edit1, %target%, ahk_id %f_window_id%
            ; Tekl reported the following: "If I want to change to Folder L:\folder
            ; then the addressbar shows http://www.L:\folder.com. To solve this,
            ; I added a {right} before {Enter}":
            ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
            Return
          }
        ; else fall through to the bottom of the subroutine to take standard action.
      }
    ; Microsoft Office application
    Else IfInString, f_class, bosa_sdm_
      {
        ; Activate the window so that if the user is middle-clicking
        ; outside the dialog, subsequent clicks will also work:
        WinActivate ahk_id %f_window_id%
        ; Retrieve any file name that might already be in the File name
        ; control, so that it can be restored after the switch to the new
        ; folder.
        ControlGetText, text, RichEdit20W2, ahk_id %f_window_id%
        ControlClick, RichEdit20W2, ahk_id %f_window_id%
        ControlSetText, RichEdit20W2, %target%, ahk_id %f_window_id%
        ControlSend, RichEdit20W2, {Enter}, ahk_id %f_window_id%
        Sleep, 100  ; It needs extra time on some dialogs or in some case
        ControlSetText, RichEdit20W2, %text%, ahk_id %f_window_id%
        Return
      }
    ; In a console window, CD to that directory
    Else If f_class in ConsoleWindowClass,Console Main Command Window
      {
        WinActivate, ahk_id %f_window_id% ; Because sometimes the mClick deactivates it.
        SetKeyDelay, 1  ; This will be in effect only for the duration of this ThRead.
        IfInString, target, :  ; It Contains a Drive letter
          {
            StringLeft, target_Drive, target, 1
            Send %target_Drive%:{Enter}
          }
        Send, cd %target%{Enter}
        Return
      }

    ; Since the above didn't return, one of the following is true:
    ; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
    ; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
    ;    action, so instead do the default action below.
    Run, %target%,, UseErrorLevel
    StringUpper, tmp, ErrorLevel
    If ( tmp == "ERROR" )
        MsgBox, 4096, Error, Could not open: %target%, 30
    Return
  }


;---- Start of Special Folders section
f_My_Computer:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" )
Return

f_My_Documents:
  f_Open_Target( "::{450D8FBA-AD25-11D0-98A8-0800361B1103}" )
Return

f_My_Network_Places:
  f_Open_Target( "::{208D2C60-3AEA-1069-A2D7-08002B30309D}" )
Return

f_Default_Navigator:
  f_Open_Target( "::{871C5380-42A0-1069-A2EA-08002B30309D}" )
Return

f_Control_Panel:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}" )
Return

f_Printers_and_Faxes:
  f_Open_Target( "::{2227A280-3AEA-1069-A2DE-08002B30309D}" )
Return

f_Fonts:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D20EA4E1-3957-11d2-A40B-0C5020524152}" )
Return

f_Scanners_and_Cameras:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{E211B736-43FD-11D1-9EFB-0000F8757FCD}" )
Return

f_Network_Connections:
  f_Open_Target( "::{7007ACC7-3202-11D1-AAD2-00805FC1270E}" )
Return

f_Recycle_Bin:
  f_Open_Target( "::{645FF040-5081-101B-9F08-00AA002F954E}" )
Return

f_Scheduled_Tasks:
  f_Open_Target( "::{D6277990-4C6A-11CF-8D87-00AA0060F5BF}" )
Return

f_Administration_Tools:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D20EA4E1-3957-11d2-A40B-0C5020524153}" )
Return

f_Web_Folders:
  f_Open_Target( "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{BDEADF00-C265-11D0-BCED-00A0C90AB50F}" )
Return
;---- End of Special Folders section


f_AddFolder:
  f_FindPath( "Folder" )
Return

f_AddFile:
  f_FindPath( "File" )
Return


;----Try to find a valid path from the active window title or the clipboard.
f_FindPath( type )
  {
    WinActivate, ahk_id %f_window_id% ; Because sometimes the mClick deactivates it.
    WinGetActiveTitle, addFavorite

    ; First, test whole active window title as valid path.
    good := f_TestWholeString( addFavorite, type )
    If good
      {
        f_AddToFavorites( addFavorite, type )
        Return
      }

    ; Second, parse the Active window title for a valid path.
    good := f_TestSubString( addFavorite, type )
    If good
      {
        f_AddToFavorites( good, type )
        Return
      }

    ; Third, test clipboard contents for valid path.
    clip = %Clipboard%
    good := f_TestWholeString( clip, type )
    If good
      {
        f_AddToFavorites( clip, type )
        Return
      }

    ; Finally, Ask For Manual Path Entry
    StringLen, len, addFavorite
    If len < 340
        len = 340
    msg = No valid path was found.`n Enter a path.
    InputBox, newPath, Favorite Path, %msg%, ,%len%, 140
    If ErrorLevel <> 0 ; Cancel was pressed
      {
        Return
      }
    Else ; OK was pressed
      {
        newPath = %newPath% ;trim trailing/leading whiteSpace
        IfExist, %newPath%
          {
            f_AddToFavorites( newPath, type )
            Return
          }
        Else
          {
            MsgBox, The path Entered is not valid.`nTry again.
            f_FindPath( type )
            Return
          }
      }

    ; Report to user that no valid path was found.
    MsgBox, No valid path was found.
    Return
  }


f_TestWholeString( testPath, type )
  {
    If ( type == "File" )
      {
        test := FileExist( testPath )
        If test Contains A,N   ; True only If Exists and is a file.
            Return 1
      }
    Else ; type = Folder
        If InStr( FileExist( testPath ), "D" ) ; True only If Exists and is folder.
            Return 1

    Return 0  ; The path does not point to a file or folder.
  }


f_TestSubString( testPath, type )
  {
    index = 0
    goodPath = ; Initialize to blank
    ; Loop one character at a time. This is like "Loop, Count". It ensures
    ; we loop once for every character without having to find the string length.
    Loop, Parse, testPath
      {
        index++
        ; Keep adding characters from right to left.
        StringRight, newPath, testPath, %index%
        ; Get rid of everything to the right of the last "\".
        SplitPath, newPath, , outDir
        ; Only keep a path that is valid.
        IfExist, %outDir%
            goodPath = %outDir%
      }
    IfExist, %goodPath%    ; We've got and absolute path to a folder.
      {
        If ( type == "File" )
          {
            ; Get the rest of the string after 'goodPath' in 'addFavorite'.
            StringGetPos, pos, testPath, %goodPath%, R
            StringLen, len, goodPath
            pos += %len%
            StringTrimLeft, tempvar, testPath, %pos%
            ; Add characters to the right of the path position to find filename.
            newTestPath = %goodPath%%tempvar%
            index = 0
            goodPath = ; Initialize to blank
            Loop, Parse, newTestPath
              {
                index++
                ; Keep adding characters from left to right.
                StringLeft, newPath, newTestPath, %index%
                ; Only keep a path that is to a valid file.
                test := FileExist( newPath )
                If test Contains A,N   ; True only If Exists and is a file.
                  {
                    goodPath = %newPath%
                  }
              }
            IfExist, %goodPath%    ; We've got and absolute path to a file.
                Return %goodPath%
          }
        Else ; type = Folder
            If InStr( FileExist( goodPath ), "D" ) ; True only If Exists and is folder.
                Return %goodPath%
      }
    Return 0 ; There was no path pointing to a file or folder found in 'testPath'.
  }


;----Save found valid path to a new link file in f_shortcuts_folder.
f_AddToFavorites( addFavorite, type )
  {
    global f_shortcuts_folder

    ; Make a default shortcut name from the path.
    ; Replace ':' and '/' with spaces to make a legal filename.
    StringReplace, shortName, addFavorite, :, %A_Space%, All
    StringReplace, shortName, shortName, \, %A_Space%, All
    ; Resize and display inputbox.
    StringLen, len, addFavorite
    len *= 8
    If len < 340
        len = 340
    msg = Found: %addFavorite%`n`nWhat name would you like to give the Favorite shortcut?
    InputBox, shortName, Favorite %type% Name, %msg%, ,%len%, 150, , , , , %shortName%
    ; If OK was pressed, try to add menu item.
    If ErrorLevel = 0
      {
        shortName = %shortName%  ; Trim leading and trailing Spaces.
        If shortName =
          {
            MsgBox, You must supply a name for the shortcut.
            f_FindPath( type )
            Return
          }

        shortPath := ShortenPath( A_ThisMenu )
        pathHash := String2Hex( shortPath )
        num := f_MenuCount[%pathHash%]
        array = f_MenuName[%pathHash%]
        If ( f_DuplicateItems( array, num, shortName ) == 0 )
          {
            MsgBox, The name %shortName% is alReady in the Menu.`nTry again.
            f_FindPath( type )
            Return
          }

        ; Here's where we save the menu item to file.
        FileCreateShortcut, %addFavorite%, %f_shortcuts_folder%\%shortName%.lnk
        ; If errorlevel is not 0 it's most likely %f_shortName%.lnk is not
        ; a legal filename.
        ; Other possible problems are no write permissions, etc.
        If ErrorLevel <> 0
          {
            MsgBox, The name %shortName% is not a legal filename.`nTry again.
            f_FindPath( type )
            Return
          }
        Else
          {
            MsgBox, The path %addFavorite% has been added to favorites.
            Reload ; Reload so changes will show up if f_AlwaysReload = n
          }
      }
    Return
  }


;----Open explorer window to f_shortcuts_folder to allow user to edit the shortcuts.
f_EditFavorites:
  Run, %f_shortcuts_folder%,, UseErrorLevel
  StringUpper, tmp, ErrorLevel
  If ( tmp == "ERROR" )
      MsgBox, 4096, Error, Could not open: %f_shortcuts_folder%, 30
  Reload  ; The Menu will be rebuilt at next popup.
Return


;----Loop thru existing menu items to check for duplicates.
f_DuplicateItems( arrayName, count, testItem )
  {
    local test, elem, nextItem

    StringLower, test, testItem
    Loop, %Count%
      {
        elem := %arrayName%%A_Index%
        StringLower, nextItem, elem
        IfEqual nextItem, %test%
            Return 0  ; Found a duplicate
      }
    Return 1 ; No duplicates
  }


; Returns the last path element in 'testPath'.
; If 'all' is set to 'first' then it returns the last element up to the first '.'.
; If 'all' is set to 'last' then it returns the last element up to the last '.'.
; If 'all' is not set then it returns all of the last element.
FileShortName( testPath, all = "" )
  {
    StringSplit, tokens, testPath, \/
    last := tokens%tokens0%
    If all =
        Return last
    Else If ( all == "First" )
      {
        StringSplit, half, last, .
        If half1 =
            Return last
        Else
            Return half1
      }
    Else If ( all == "last" )
      {
        StringGetPos, pos, last, ., R
        If ErrorLevel <> 0
            Return last
        StringLeft, elem, last, %pos%
        Return elem
      }
  }


; Chop off the base folder from the path. This allows longer paths to be used
; in dynamically created variable names. Variable names are limited to 253 chars.
ShortenPath( testPath )
  {
    global

    StringLen, len, f_shortcuts_folder
    StringTrimLeft, new, testPath, %len%
    Return, %new%
  }


;Thanks to Lazlo Hars for these functions |
;                \ /
String2Hex(x)                 ; Convert a string to a huge hex number starting with X
  {
    StringLen Len, x
    format = %A_FormatInteger%
    SetFormat Integer, H
    hex = X
    Loop %Len%
      {
        Transform y, ASC, %x%   ; ASCII code of 1st char, 15 < y < 256
        StringTrimLeft y, y, 2  ; Remove leading 0x
        hex = %hex%%y%
        StringTrimLeft x, x, 1  ; Remove 1st char
      }
    SetFormat Integer, %format%
    Return hex
  }

; This is never used in this script, but if you copy String2Hex(x) to use in
; another script you'll want this one too.
Hex2String(x)                 ; Convert a huge hex number starting with X to string
  {
    StringTrimLeft x, x, 1     ; discard leading X
    StringLen len, x
    Loop % len/2               ; 2-Digit blocks
      {
        StringLeft hex, x, 2
        Transform y, Chr, % "0x"hex
        string = %string%%y%
        StringTrimLeft x, x, 2
      }
    Return string
  }
; End of Script
