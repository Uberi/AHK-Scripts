;----------------------------------------------------------------------------------------------------------------------------------
;SavePictureAs Version 6.6 by Robert Jackson - Tested with Autohotkey_L Version 1.1.07.03 Ansi 32 bit
;Download the most recent SavePictureAs version here http://www.autohotkey.com/forum/viewtopic.php?p=419104#419104
;I created this program to easily save pictures from the web with Windows XP, Vista and Windows 7 using Internet Explorer, Firefox, Opera and Google Chrome.
;Placing the mouse cursor over any picture on the webpage and pressing the "CTRL AND SPACEBAR" keys will save the picture to your hard drive.
;----------------------------------------------------------------------------------------------------------------------------------
;PLEASE NOTE:
;    SavePictureAs uses 2 external files - SpaImage.jpg & SpaTrayIcon.ico - Neither is required but preferred.
;(1) The script will download both files if uncompiled. The script will extract both files from exe if the compiled version is downloaded.

;(2) If the script is uncompiled and you prefer the script not download these files then change the next line from DoNotDownLoad = 0 to DoNotDownLoad = 1
DoNotDownLoad = 0 ; 1 = (do not download SpaImage.jpg and SpaTrayIcon.ico -these files are not required but preferred)

;(3) Alternatively these can be downloaded from autohotkey.net & placed in the SavePictureAs script folder. Use the following links.
;    http://www.autohotkey.net/~DataLife/spaimage.jpg,spaimage.jpg
;    http://www.autohotkey.net/~DataLife/SpaTrayIcon.ico,spatrayicon.ico

;(4) Thanks to the following people for the following code.
;   (A) Lexikos - Scrollable Gui code from http://www.autohotkey.com/forum/viewtopic.php?t=28496&start=0
;   (B) Lexikos - Get Image Size code from http://www.autohotkey.com/forum/viewtopic.php?t=28334&highlight=imagedata
;   (C) Sean - Get right click menu contents function GetMenu(hMenu) code from http://www.autohotkey.com/forum/viewtopic.php?t=21451&start=0
;   (D) majkinetor - Common dialog for changing Gui & font colors from http://www.autohotkey.com/forum/viewtopic.php?t=17230&highlight=common+dialogs
;   (E) majkinetor - Attach.ahk from http://www.autohotkey.com/forum/viewtopic.php?t=48298&start=0
;   (F) olfen - UrlDownloadToVar from http://www.autohotkey.com/forum/viewtopic.php?t=10466&postdays=0&postorder=asc&start=0
;   (G) Huba - Left click on system tray icon from http://www.autohotkey.com/forum/viewtopic.php?t=26720
;   (H) Chris Mallett for AutoHotkey and Lexikos for continuing to develop AutoHotkey_L
;   (I) Sorry if I missed someone. If so, let me know and I will give credit where credit is due.

;----------------------------------------------------------------------------------------------------------------------------------
;Known issues:
;(1) If you change the windows color and text color to the same color then the text is not visible. Choose "Reset All Colors" on; the system tray to fix when this happens. Anyone know how to avoid this?

;(2) Found in only one occasion and only in IE the Save Picture As window combobox shows Jpeg but the image is really a gif, this causes the picture to be saved as a gif, the (ifexist filename) is looking for a jpg, this only happens if Hide Known File Types is selected in Folder options. Only found in WinXp.

;(3) For SavePictureAs to work properly, the script needs to be able to right click, send the letter v or the letter s (depending on browser), then wait for the Save Image, Save Picture or Save As window (depending on browser) to open, it will then send the new path/filename to the edit box, then click on the button labeled &Save.
;   If you get the error that the picture can not be saved, check that the above can be done manually. 

;----------------------------------------------------------------------------------------------------------------------------------
;Quirks:
;(1) Due to the way so many web pages display images and how they are named there will be times that Save Picture As will fail. Just try it again. You can right click the picture and choose Save Image or Picture and verify it is a savable picture.

;(2) Due to Save Picture As supporting 3 OS's and 4 browsers it may take alot of testing to work out the bugs. Please let me know of any issues and provide as many details as possible about the information in the Save Picture As (Internet Explorer), Save Image (Firefox), or Save As (Google and Opera) windows and type of operating system you are using.
;----------------------------------------------------------------------------------------------------------------------------------
;Notes:
;(1) SavePictureAs does not install anything on your computer. It runs from the folder you place SavePictureAs.ahk in. The first time you run SavePictureAs.ahk you will be asked where to save downloaded pictures and display program documentation. SavePictureAs.ahk will create spaconfig.ini, spaimage.jpg and ReadMeFirst.txt in the current folder.

;(2) Alot of this code was written when I was very new to autohotkey. Some of it I have went back and rewritten to be more efficent, reliable and use less code.

;(3) I plan on adding more comments but this will take awhile

;(4) While saving a picture, if open, the History Menu window will add the last picture saved to the list.

;(5) Running the program is as simple as choosing a folder location on startup and placing the mouse cursor over a picture and pressing ctrl & the spacebar. There are alot of other features in the system tray menu. 
; (A) Favorites Toolbar - Save up to 5 favorite locations to save pictures. When you see a picture on the web that you want to save you can quickly change your Saved Picture Location folder then save the picture.
; (B) The Confirmation Message (done saving picture message), splash screen, saved picture location folder, system colors, Favorites Toolbar and more are configurable from the system tray icon.

;(6) Please read the Help and Program Documentation accessed from the system tray icon for more information.
;----------------------------------------------------------------------------------------------------------------------------------
; To Do:
;(1) Change SavePictureAs_version.txt to SavePictureAs_Info and include NewestVersionNumber, FileSize, & Changes Info
;(2) Change UrlDownloadToVar to WinHttpRequest, used to check for updates and download "Changes Info"
;----------------------------------------------------------------------------------------------------------------------------------
;Version History:
;
;   Version 1.0 - Original program
;      1) copies pictures using internet explorer by placing mouse over picture and using hotkeys
;          Ctrl Space.
;
;      2) saves files in location defined in SavePictureAs-CtrlSpace.ahk. 
;
;      3) only tested in Windows XP  
;
;   Version 2.0 - Minor Update
;      1) created setup.ahk to allow user to select location to save pictures.
;  
;   Version 2.1 - Minor Update
;      1) merged setup.ahk into SavePictureAs-CtrlSpace.ahk.   
;
;   Version 2.2 - Minor Update
;      1) added code to prevent program from hanging when trying to save a picture that
;          does not have the "Save Picture As" context menu.
;
;   Version 2.3 - Minor update
;      1) added code to block user input (mouse and keyboard)  during code execution   
;
;      2) added code to clear clipboard to prevent user copied clipboard content from
;          interferring with program   
;
;      3) renamed filepath.ini to spafilepath.ini because other programs use
;          filepath.ini   
;
;      4) added title bars for dialog boxes. IE (Help, about...)   
;
;      5) changed code, now during inital setup when the user clicks on cancel instead
;          of choosing a picture location folder the program exits
;
;      6) added showonce.txt so user would be able to see splash screen again   
;
;      7) changed code so that the picture location path is not blank when the user
;          chooses to cancel the picture location select menu
;
;      8) added code to check to see if the current save picture as folder exists at
;          program startup. If the folder does not exist the program prompts user to
;          select another one.
;
;   Version 3.0 - Major update
;      1) added Confirmation Message that displays when a picture has being saved and added
;          option to disable the Confirmation Message
;
;      2) added Confirmation Message enabled/disabled status balloon to system tray,
;          and the ability to change the colors for the Confirmation Message.
;
;      3) program does not use spafilepath.ini or showsplash.txt anymore, uses
;          spaconfig.ini for all user settings. The program will create
;          spaconfig.ini with default settings if it does not exist.  
;
;      4) added ability to keep a history of pictures saved  
;
;      5) made the menu on the system tray open with left or right click  
;
;      6)  changed system tray icon from the green H to an icon showing a couple in
;           a hot tub (aka SPA) Save Picture As.  
;
;      7) added "Rename Last Picture", it also updates the history to reflect the
;          new file name.  
;
;   Version 4.0 - Major Update
;      1) added Last Saved Picture Menu to system tray menu
;         Last Saved Picture Menu includes...
;          a) View, Delete, Move, Copy & Rename last saved picture
;      2) added Splash Screen to system tray menu.
;      3) redesigned menus and display screens
;      4) added menu to change screen and text colors
;      5) added Reset All Defaults to tray menu
;      6) added picture preview to the history screen
;      7) added Saved picture locations Favorites toolbar
; 
;   Version 5.0 - Major Update
;      1) added ability to save pictures using Firefox, Opera and Google Chrome
;      2) added ability to save pictures using Windows Vista and Windows 7
; 
;   Version 5.1 - Minor Update
;      1) changed the way firefox saves pictures
;      2) made the History Menu, Program Documentation, Help Screen and Favorites Toolbar
;         configuration windows resizable.
;      3) Added Rename, Move and Copy buttons to History Menu
;      4) Removed Last Saved Picture Menu. The last saved picture can be viewed on the History Menu
;   Version 5.2 - Minor Update
;      1) minor bug fixes - removed some message boxes used for troubleshooting
;   Version 5.3 - Minor Update
;      1) add minimum size to the history window. Needed minimum size to display properly
;   Version 5.4 - Minor Update
;      1) Now if original ext was already in the edit1 control on Save Picture/Image As window then use that one otherwise do not add ext to filename
;   Version 5.5 - Minor Update
;      1) Now checks to see if user is running as admin. Windows 7 needs SavePictureAs to run as administrator due to SavePictureAs features to Move, Delete, Rename and Copy options on the History Menu.
;   Version 5.6 - Minor Update
;      1) Fixed minor bug if the folder chosen to save pictures to does not exist
;   Version 5.7 - Minor Update
;      1) Added Prompt for Filename. Now when enabled the image being saved can be given a user specified filename.
;      2) Added "Check For Updates" on startup and tray menu.
;   Version 5.8 - Minor Update
;      1) Added ability to view changes when a new version is available
;   Version 5.9 - Minor Update
;      1) Fixed issue with Firefox using different window classes across OS platforms
;   Version 6.0 - Minor Update
;      1) Found an issue with not being able to position the Confirmation Window
;   Version 6.1 - Minor Update
;      1) Removed Run As Admin and choose instead to display a message explaining UAC preventing moving and renaming pictures
;   Version 6.2 - Minor Update
;      1) Fixed issue with Google Chrome not saving images in certains conditions.
;   Version 6.3 - Minor Update
;      1) Fixed issue with Windows 7 and Firefox not able to verify image was successfully saved
;   Version 6.4 - Minor Update
;      1) Fixed issue with decimals places in History Gui X,Y, W and H values
;   Version 6.5 - Minor Update
;      1) Fixed issue with Google Chrome window class
;   Version 6.6 - Minor Update
;      1) Found a stray comma preventing Favorites Toolbar number 2 from saving the users choice
#Singleinstance Force
#NoEnv
#Persistent
ProgramName = SavePictureAs
Version = 6.6
Author = Robert Jackson
if A_IsCompiled = 1
 {
  menu, tray, deleteall
  menu, tray, NoStandard
  FileGetSize,FileSize,SavePictureAs.exe,k
 }
else
 FileGetSize,FileSize,SavePictureAs.ahk,k

if DoNotDownLoad = 0 ;download files for an uncompiled script
 {
  IfNotExist,%a_scriptdir%\spatrayicon.ico
   URLDownloadToFile,http://www.autohotkey.net/~DataLife/SpaTrayIcon.ico,spatrayicon.ico
  IfExist,%a_scriptdir%\spatrayicon.ico
   Menu, TRAY, Icon, Spatrayicon.ico ;want  icon to be SpaTrayIcon.ico as soon in the script as possible
 }
FileInstall, SpaTrayIcon.ico, %A_ScriptDir%\SpaTrayIcon.ico, 1  ;only works if the script is compiled 
If ( A_OSVersion = "win_vista" or A_OSVersion = "win_7" )
 {
  IniRead,ShowAdminMessage,Spaconfig.ini,FirstRun,ShowAdminMessage
  If (ShowAdminMessage = 0 or ShowAdminMessage = "ERROR" ) ; 0 = show / 1 = Don't show / ERROR is because SpaConfig.ini has not been created.
   {
    gui, font, s12
     Gui, add, text, w350 ,SavePictureAs allows you to Delete, Move, Copy, and Rename the pictures you downloaded.`n`nUser Account Control (UAC) included with Windows Vista and Windows 7 may prevent SavePictureAs from moving or renaming the pictures you downloaded.`n`nIf you have issues Moving or Renaming pictures using the Picture History window then you can do one of the following.`n`nRight click SavePictureAs and choose "Run As Administrator"`nOR`nTurn off or change UAC settings.`n
    IfExist,Spaconfig.ini
     Gui, add, checkbox, vChoice, Do not show this message again
    Gui, add, button,,OK
    Gui, show,,Information
    gui, color, c0c0c0
    Return
   }
 }
buttonOK:
guicancel:
IfExist,spaconfig.ini
 {
  Gui, Submit
  iniwrite, %choice%, Spaconfig.ini,FirstRun,ShowAdminMessage 
 }
Gui, destroy
IfExist,SpaConfig.ini
 IniWrite,YesShow,SpaConfig.ini,Runonce,ShowAdminMessage
IniRead,CheckForUpdates,Spaconfig.ini,CheckForUpdates,CheckForUpdates,Yes
If CheckForUpdates = Yes
 gosub CheckForUpdates
IfExist,SavePictureAs_Update.exe
 FileDelete, SavePictureAs_Update.exe
DetectHiddenWindows, On
SetFormat,float,0.
SetTitleMatchMode,2
SetWorkingDir, %A_ScriptDir%
onexit, quit
OnMessage(0x114, "OnScroll") ; Used for the Favorites Toolbar configuration Gui
VarSetCapacity(A_PicturesSF, 256) ;Need path to MyPictures for FileSelectFolder and Favorites Toolbar
DllCall( "shell32\SHGetFolderPath", "uint", 0 , "int", 0x27 , "uint", 0 , "int", 0 , "str", A_PicturesSF)
;===================================================================================================================================
;place needed files in the script directory
;===================================================================================================================================
if (A_IsCompiled <> 1 and DoNotDownLoad = 0) ;download files for an uncompiled script
 {
  IfNotExist,%a_scriptdir%\spaimage.jpg
   URLDownloadToFile,http://www.autohotkey.net/~DataLife/spaimage.jpg,spaimage.jpg
  IfNotExist,%a_scriptdir%\spatrayicon.ico
   URLDownloadToFile,http://www.autohotkey.net/~DataLife/SpaTrayIcon.ico,spatrayicon.ico
  ;ReadMeFirst.txt is created below
  ;SpaConfig.ini is created below
 }
else ;extract from exe
 {
  IfNotExist, %A_ScriptDir%\spaimage.jpg 
   FileInstall, spaimage.jpg, %A_ScriptDir%\spaimage.jpg, 1 ;only works if the script is compiled
  IfNotExist,%A_ScriptDir%\SpaTrayIcon.ico
   FileInstall, SpaTrayIcon.ico, %A_ScriptDir%\SpaTrayIcon.ico, 1  ;only works if the script is compiled
 }
IfNotExist,%A_ScriptDir%\ReadMeFirst.txt
 gosub CreateReadMeFirstTxt
;===================================================================================================================================
;===================================================================================================================================
IniRead, ShowSplashScreen, spaconfig.ini, SplashScreenStatus, ShowSplashScreen
if ShowSplashScreen = Disabled ;ShowSplashScreen will be ERROR if spaconfig.ini does not exist. So it shows on startup as designed.
 Goto SkipSplashScreen ; Skips all setup code and splash screen
;==========================================================Install Screen===========================================================
if A_IsCompiled = 1
 SavePictureAs = SavePictureAs.exe ; for display purposes in the next MsgBox
else
 SavePictureAs = SavePictureAs.ahk
ifnotexist spaconfig.ini
 MsgBox,4160,Setup Information,%SavePictureAs% does not install anything on your computer.`n`nIt runs from the folder you place %SavePictureAs% in.`n`nThe first time you run %SavePictureAs%  you will be asked to choose a folder to save your pictures in.`n`n%SavePictureAs% will create SpaConfig.ini, SpaTrayIcon.ico, SpaImage.jpg and ReadMeFirst.txt in the current folder.`n`nRun %SavePictureAs% each time you want to start the program.`n`nSetup will only run if SpaConfig.ini is not in the same folder as %SavePictureAs%
SplashScreen:
  Gui 9: font, s12, MS sans serif
  Gui 9: Add, ListBox, w740 h460  vscroll choose1 ,******************************      Thank you for choosing SavePictureAs V%Version%        ******************************
  | 
  |        Program Documentation can be accessed by clicking on the system tray icon.
  |
  |        I created this program to easily save pictures from the web with Windows XP, 
  | 
  |        Vista and Windows 7 using Internet Explorer, Firefox, Opera and Google Chrome.
  |
  |        Placing the mouse cursor over any picture on the webpage and pressing the
  |
  |        "CTRL & SPACEBAR" keys will save the picture to your hard drive. 
  |
  |        Once the program loads you can click on the tray icon to change your saved pictures location.
  | 
  |        Placing the mouse over the system tray icon will display a message that shows the current
  |
  |        location for saving pictures. 
  |
  |         SavePictureAs features include...... 
  |             1. All features and settings can be accessed by clicking the system tray icon.
  |
  |             2. History Menu - View, Delete, Move, Copy & Rename last 30 pictures saved.
  |
  |             3. Favorites toolbar - five configurable buttons for favorite folders to save pictures to.
  |
  |             4. Change screens and text colors
  |
  |             5. Saved picture successfully configurable Confirmation Message.
  |
  |             6. Exit the program by clicking the system tray icon.
  |
  |
  |                                             email savepictureas@hotmail.com with any questions
  ;***************************************************************************************************
  
  IfNotExist,spaconfig.ini ;shows setup buttons
   {
    CurrentlyInSetup=yes
    Gui 9: font, s10, MS sans serif
    Gui 9: Add, Button, x95  y475 w100 h40 0x300, Continue
    Gui 9: Add, Button, x325  y475 w120 h40  0x300, Setup Details
    Gui 9: Add, Button, x575  y475 w100 h40 0x300, Cancel Setup
    Gui 9: font, s12, MS sans serif
    Gui 9: Color,   8080ff,C0C0C0
    Gui 9: -MinimizeBox 
    Gui 9: +Resize  +MinSize +MaxSize
    Gui 9: Show, w773 h530,SavePictureAs Setup (SplashScreen)
    WinSet, alwaysontop, On ,SavePictureAs Setup (SplashScreen)
    return
    9ButtonSetupDetails:
    WinSet, alwaysontop, Off ,SavePictureAs Setup (SplashScreen)
    gui 9: +disabled
    gui 20:+owner9
    Gui 20: font, s13 , MS sans serif
    Gui 20: Add,Text, x6 y15 w753 c%HelpColorGuiTextVar%,Step 1 - Displays SplashScreen detailing key features of SavePictureAs with option to cancel the setup.`n`n`nStep 2 - Prompts user to select a folder to save pictures to . This can be changed later via the system tray icon.`n`n`nStep 3 - Displays Setup Complete Screen`n`n`n`n%SavePictureAs% does not install anything on your computer.`n`nIt runs from the folder you place %SavePictureAs% in.`n`n%SavePictureAs% will create SpaConfig.ini, SpaTrayIcon.ico, SpaImage.jpg and ReadMeFirst.txt in the current folder.`n`nRun %SavePictureAs% each time you want to start the program. `n`nSetup will only run if SpaConfig.ini is not in the same folder as %SavePictureAs%
    Gui 20: font, s10 , MS sans serif
    Gui 20: Add, Button, x336 y+35 w100 ,Close Window
    Gui 20: +Resize  +MinSize +MaxSize
    Gui 20: Show, w773 h530, SavePictureAs V%Version% (Setup Details)
    Gui 20: Color, c0c0c0
    Return
    20ButtonCloseWindow:
    20GuiEscape:
    20GuiClose:
    Gui 20: Destroy
    WinSet, alwaysontop, On ,SavePictureAs Setup (SplashScreen)
    Gui 9: -disabled  
    Return
   }  
  Else ;shows splashscreen buttons enable/disable
   {
    DoNotCheckForValidPathWhenClosingSplashScreen = 1
    iniread, SplashScreenColorGuiVar, spaconfig.ini, SystemColors, SplashScreenColorGuiVar,  8080ff
    iniread, SplashScreenColorListBoxVar, spaconfig.ini, SystemColors, SplashScreenColorListBoxVar, c0c0c0
    iniread, SplashScreenColorListBoxTextVar, spaconfig.ini, SystemColors, SplashScreenColorListBoxTextVar, 000000
    Gui 9: font, s10, MS sans serif
    Gui 9: Add, Button, x195  y475 w100 h40  0x300, Disable Splash Screen
    Gui 9: Add, Button, x195  y475 w100 h40  0x300, Enable Splash Screen
    Gui 9: Add, Button, x475  y475 w100 h40  0x300, Close Window
    Gui 9: font, s12 c%SplashScreenColorListBoxTextVar%, MS sans serif
    GuiControl, 9: Font, listbox1
    Gui 9: Color,  %SplashScreenColorGuiVar%,%SplashScreenColorListBoxVar%, 
    Gui 9: +Resize  +MinSize +MaxSize
    Gui 9: Show,  ,SavePictureAs V%Version% (SplashScreen)
    IniRead, Status, spaconfig.ini, SplashScreenStatus, ShowSplashScreen, Enabled
    if status = Disabled
     {
      Control, Disable, ,Button1, SavePictureAs V%Version% (SplashScreen)
      Control, Hide, ,Button1, SavePictureAs V%Version% (SplashScreen)
      Control, Show, ,button2, SavePictureAs V%Version% (SplashScreen)
     }
    else
     {
      Control, Disable, ,Button2, SavePictureAs V%Version% (SplashScreen)
      Control, Hide, ,Button2, SavePictureAs V%Version% (SplashScreen)
      Control, Show, ,Button1, SavePictureAs V%Version% (SplashScreen)
     }  

    WinWaitActive, SavePictureAs V%Version% (SplashScreen)
    Send {Home}
    Return 
   } 
;*************************************************************************************************
;Enable Splash Screen
;*************************************************************************************************
9ButtonEnableSplashScreen:
IniWrite, Enabled, spaconfig.ini, SplashScreenStatus, ShowSplashScreen      
Status = Enabled
Control, Disable, ,Button2, SavePictureAs V%Version% (SplashScreen)
Control, Hide, ,Button2, SavePictureAs V%Version% (SplashScreen)
Control, Enable, ,Button1, SavePictureAs V%Version% (SplashScreen)
Control, Show, ,Button1, SavePictureAs V%Version% (SplashScreen)
ToolTip, Splash Screen is [%Status%]
SetTimer, RemoveToolTipSE, 3000
return
RemoveToolTipSE:
SetTimer, RemoveToolTipSE, Off
ToolTip
Return
;**************************************************************************************************
;Disable Splash Screen
;**************************************************************************************************
9ButtonDisableSplashScreen:
IniWrite, Disabled, spaconfig.ini, SplashScreenStatus, ShowSplashScreen      
Status = Disabled
Control, Disable, ,Button1, SavePictureAs V%Version% (SplashScreen)
Control, Hide, ,Button1, SavePictureAs V%Version% (SplashScreen)
Control, Enable, ,Button2, SavePictureAs V%Version% (SplashScreen)
Control, Show, ,Button2, SavePictureAs V%Version% (SplashScreen)
ToolTip, Splash Screen is [%Status%]
SetTimer, RemoveToolTipSD, 3000
return
RemoveToolTipSD:
SetTimer, RemoveToolTipSD, Off
ToolTip
Return
;**************************************************************************************************
;*************************************End Enable/Disable Splash Screen*****************************
;**************************************************************************************************
9ButtonCancelSetup: ;cancel or continue setup
FileDelete,%a_scriptdir%\spaimage.jpg
FileDelete,%a_scriptdir%\spatrayicon.ico
FileDelete,%a_scriptdir%\readmefirst.txt
FileDelete,%A_ScriptDir%\spaconfig.ini
FileDelete,%A_ScriptDir%\spaconfig2.ini
FileDelete,%A_ScriptDir%\FirstRun.ini
CancelSetup = 1 ;prevent the OnExit Quit label from running
ExitApp
9GuiClose: ;Splashscreen gui is displayed on startup with continue and cancel setup buttons. After setup displaying the splash screen via the system tray icon shows disable/enable and close window buttons only. 9guiclose is used to just destroy the splashscreen gui, unless currently in setup, then if the X button is clicked, cancel setup. 
IfNotExist,%a_scriptdir%\spaconfig.ini 
 goto 9ButtonCancelSetup
9ButtonCloseWindow: ;Close button is only on the splash screen after setup
9ButtonContinue:
Gui 9: destroy
;====================================================Install Screen End============================================================
;====================================Create SpaConfig.Ini and Choose Picture Location==============================================
SkipSplashScreen: 
Gosub CreateSpaConfigIni ;just creates the var used in the next fileappend
IfNotExist,spaconfig.ini ;create scripts main config file
  FileAppend,%spaconfigvar%,%A_ScriptDir%\spaconfig.ini
IfExist,spaconfig2.ini
 {
  IniRead,Value,Spaconfig2.ini,CheckForUpdates,CheckForUpdates, yes ;needed to record user selection for Check For Updates
  IniWrite,%Value%,Spaconfig.ini,CheckForUpdates,CheckForUpdates ;before spaconfig.ini is created
  FileDelete,spaconfig2.ini
 }  

;During setup Currentpath is "None Selected"
;So IfNotInString, Attributes, D would be true and FileSelectedFolder would be ran
GetPictureLocation: ;code here is only executed during setup.
IniRead, OutputVar, spaconfig.ini, CurrentPath, Path, Error
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D ;make sure Save Picture location exist
 {
  menu, tray, tip, Current Folder Location (None Selected)
  FileSelectFolder, OutputVar, *%A_PicturesSF%, 3, SavePictureAs V%Version% `n`nPlease choose a folder to store your saved pictures.  
  if errorlevel  = 1
   {
    Msgbox, 8228,SavePictureAs V%Version%,You have not selected a valid location to save your pictures.`n`nDo you want to select a location now?
    IfMsgBox Yes
    Goto GetPictureLocation
    IfMsgBox no
     {
      msgbox, 8256,Information, You have not chosen a valid location.`n%A_MyDocuments% will be used.
      OutPutVar  = %A_MyDocuments%
     }
   }
  OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
  FileGetAttrib, Attributes, %OutPutVar%
  IfNotInString, Attributes, D
   {
    MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
    goto GetPictureLocation
   }
  Gosub VerifySpaconfigIniExists 
  IniWrite, %OutputVar%, spaconfig.ini, CurrentPath, Path
  CurrentPath = %OutPutVar%
  MaxChars := 100
  TextToControl = %OutPutVar%
  Gosub FixControlTextLength
  menu, tray, tip, Current Folder Location (%TextToControl%) 
 } ;ifnotexist, validpath ending bracket (under getpicturelocation label)
 ;**********************************Create Confirmation Message Gui and hide******************************************
IniRead, ConfirmationMessageValue, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus, ENABLED 
IniRead, ConfirmationMessageDelay, spaconfig.ini, ConfirmationMessage, ConfirmationMessageDelay, 1000
IniRead, TextColor, spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor, 000000
IniRead, WindowColor, spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor, 8b8b8b
IniRead, ConfirmationMessageXpos, spaconfig.ini, ConfirmationMessage, ConfirmationMessageXpos, 410
IniRead, ConfirmationMessageYpos, spaconfig.ini, ConfirmationMessage, ConfirmationMessageYpos, 215
Gui 17: -caption +owner
gui 17: font, s26 w700 , Monotype Corsiva
Gui 17: add, text, x60 y25 w190 c%textColor% , Done
Gui 17: Show, x5000 y%ConfirmationMessageYpos% w200 h200, Confirmation Message
Gui 17: Color, %windowColor%
WinSet, Region, 50-0 W100 H100 R100-100, Confirmation Message
WinGet,CMID,ID, Confirmation Message
Gui 17: Hide
;******************************************End Create Confirmation Message Gui and hide******************************************
;====================================================Tray Menu===================================================================
iniread, currentpath,spaconfig.ini, CurrentPath, Path
Menu Tray, Click, 1           ; Enable single click action on tray
Gosub AddMenu                 ; Add new default menu
Return                        ; End of initialization
Menu:
MouseGetPos MouseX, MouseY    ; Get current mouse position
Menu Tray, Show, %MouseX%, % MouseY - 10  ; Show menu a little upper to enable next click on icon
AddMenu:
Menu Tray, Add,-------SavePictureAs------- ,Menu ; Add temporary menu item
Menu Tray, Default,-------SavePictureAs-------  ; Set to default
Menu, tray, add, About, about
Menu, tray, add, Help, UserHelp 
Menu, tray, add, Program Documentation, ProgramDocumentation
Menu, tray, Add, Favorites Tool Bar, FavoritesToolbar
Menu, tray, add, History Menu, ConfigureHistory
Menu, tray, add, Open Picture Location Folder,OpenPictureLocationFolder
menu, tray, tip, Current Folder Location (%TextToControl%)
;************************
;Adds Settings on tray menu then creates Submenu1 
;************************
Menu, Submenu1, Add, Change Picture Location, ChangePath
Menu, Submenu1, Add, Prompt For Picture Name, PromptForPictureName
Menu, Submenu1, add, Program Colors, systemcolors
Menu, Submenu1, Add, Confirmation Message, ConfigureConfirmationMessageColor
Menu, Submenu1, Add, Splash Screen, SplashScreen
Menu, Submenu1, Add, Reset All Defaults, ResetAllDefaults
Menu, Submenu1, Add, Reset All Colors, ResetAllColors
Menu, Submenu1, Add, Check For Updates,CheckForUpdatesGui
Menu, tray, Add,Settings, :Submenu1
Menu,Tray, Add, Exit Program, Quit
;**********************
;end of creating Main menu called Tray
;**********************
;====================================================End of Tray Menu===============================================================
;====================================================Display Setup Complete=========================================================
If CurrentlyInSetup=yes
 {
  IfExist,%a_scriptdir%\spaimage.jpg
   {
    SplashImage,%A_ScriptDir%\SpaImage.jpg,  b fm14 zh350 zw-1 fs12 ,Now find a picture on the web and press ctrl-space and the picture will be saved to your hard drive.`n`nCheck out the system tray icon for more options.`n`nClick anywhere to continue,Setup is Complete`nSavePictureAs Verison V%Version%,
    CurrentlyInSetup=no
    KeyWait, Lbutton, D
    SplashImage, Off
   }
  else
   {
    CurrentlyInSetup=no
    MsgBox,4160,Setup,Setup is Complete`n`nNow find a picture on the web and press ctrl-space and the picture will be saved to your hard drive.`n`nCheck out the system tray icon for more options.
   }
 }
;=================================================Create Tray Tip================================================================
iniread, CurrentPath, Spaconfig.ini, CurrentPath, Path
MaxChars := 100 ;shorten filename for traytip
TextToControl = %currentpath%
Gosub FixControlTextLength
menu, tray, tip, Current Folder Location (%texttocontrol%)
Return ;for ending menus
;********************************************************************************************************************************
;*********************************************END OF AUTOEXECUTE SECTION*********************************************************
;********************************************************************************************************************************
^/::
InvalidChar1=\
InvalidChar2=/
InvalidChar3=`:
InvalidChar4=*
InvalidChar5=?
InvalidChar6="
InvalidChar7=<
InvalidChar8=>
InvalidChar9=|
InvalidChar10=.
RenameLastSavedPicture:
IniRead, LastSavedPicture, spaconfig.ini, History, LastSavedPicture,%a_space%
if LastSavedPicture = 
 {
  Msgbox 262160, File Error,No record exists for last picture saved! Save a picture then rename it.
  Return
 }
ifnotexist, %LastSavedPicture%                             
 {
  Msgbox 262160, File Error, Can not find last picture saved! (%LastSavedPicture%) Try saving the picture again then rename it.
  Return
 }
Gui, +OwnDialogs
SplitPath,LastSavedPicture,,OutDir,OutExtension,oldname
InputBox, newfilename , Rename this file?, Last Saved Picture is (%LastSavedPicture%)`nDo not include the file type in the file name. Example .jpg or .bmp,, 520, 245,,,,,%oldname% 
if (errorlevel = 1 or newfilename = "") 
return
loop 10
 {
  var := % InvalidChar%A_Index%
  IfInString,NewFilename,%var%
   {
    Msgbox 262160, Invalid File Name "%newfilename%", Can not use \ / : * ? . " < > | Please try again.
    FoundInvalidChar = 1
    break
   }
 }   
if FoundInvalidChar = 1
 goto RenameLastSavedPicture
Else
 FoundInvalidChar = 0
SplitPath,LastSavedPicture,OldName,OutDir,OutExtension
ifExist, %OutDir%\%newfilename%.%OutExtension%
 {
  Msgbox 262160, Error renaming file, Duplicate file name exist, please choose another one.
  Goto   RenameLastSavedPicture
 }
Filemove, %LastSavedPicture%, %OutDir%\%newfilename%.%OutExtension%
IniRead,Value,Spaconfig.ini,History,History1
if ( Value = LastSavedPicture or HistoryValue = "Enabled" ) ;need history1, for the History Gui, to match last saved picture even if history is turned off
 IniWrite,%OutDir%\%newfilename%.%OutExtension%,Spaconfig.ini,History,History1
IniWrite,%OutDir%\%newfilename%.%OutExtension%,spaconfig.ini,History,LastSavedPicture 
IfWinExist,SavePictureAs V%Version% (History) ;update history gui
 {
  SendMessage 394, 1, 0,, ahk_id %LB% ;LB_GETTEXTLEN
  If (ErrorLevel = 0xFFFFFFFF)
   {
    MsgBox,,SavePictureAs,An error occurred, please try again.
    Return
   }
   VarSetCapacity(sText, ErrorLevel * (1 + !!A_IsUnicode), 0)
   SendMessage 393, 1, &stext,, ahk_id %LB% ;retrieve line 1 only
   if sText <> %LastSavedPicture% ;apparently the History was disabled when the Last Picture was saved
    return
   else
    {
     SendMessage, (LB_DELETESTRING:=0x182),1,0,, ahk_id %LB% 
     String = %OutDir%\%newfilename%.%OutExtension%
     SendMessage, (LB_INSERTSTRING:=0x181),1,&String,, ahk_id %LB%
    }
  }
Return
;********************************************************************************************************************************
;******************************************Control Space Save Picture Section****************************************************
;********************************************************************************************************************************
^space:: ;Saving the picture code / determine OS and browser type
KeyWait Control  ; Wait for the key to be released.  Use one KeyWait for each of the hotkey's modifiers.
KeyWait Space
blockinput, on
Gosub VerifySpaconfigIniExists
iniread, CurrentPath, spaconfig.ini, CurrentPath, Path ;what is the current Save Picture location
MouseGetPos,,,ID ;make sure the correct window class is retrieved
WinActivate,ahk_id %id% ;activate window. Just placing the mouse over a window does not activate it
WinGetClass,class, ahk_id %id% 
if Class not contains OperaWindowClass,Chrome_WidgetWin_0,Chrome_WidgetWin_1,MozillaUIWindowClass,IEframe,MozillaWindowClass 
 {
  blockinput, Off
  MsgBox, 262160, Save Picture As (Internet Browser Check), Save Picture As V%Version% supports the following Internet Browsers`n`nInternet Explorer`nGoogle Chrome`nFirefox`nOpera`n`nIf you are trying to save a picture using one of these browsers and still get this error message please email SavePictureAs@hotmail.com and provide which browser and the version.
  return
 }
ChoosePictureLocation:
FileGetAttrib, Attributes, %CurrentPath%
IfNotInString,Attributes, D ;make sure Save Picture location exist
 {
  Outputvar = Currently Selecting New Location
  menu, tray, tip, Current Folder Location (%outputvar%)
  MouseGetPos,CursorX,CursorY ; need to know where mouse is because the picture is under the mouse and the mouse will be moved to select a new folder. After new folder is selected, the mouse will be moved back and then continue with saving picture
  blockinput, off
  FileSelectFolder, OutputVar, *%A_MyDocuments%, 3, The current location to save pictures no longer exist!`nPlease choose another picture location.
  if ErrorLevel = 1
   {
    Gosub VerifySpaconfigIniExists
    IniWrite, NoValidPathSelected, spaconfig.ini, CurrentPath, Path
    msgbox, 262160, SavePictureAs V%Version%,You chose not to select a folder for saved pictures`nYour picture will not be saved.
    return
   }
  BlockInput, On
  FileGetAttrib, Attributes, %OutPutVar%
  OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
  IfNotInString, Attributes, D
   {
    blockinput, off
    MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
    Goto ChoosePictureLocation
   }
  Gosub VerifySpaconfigIniExists
  IniWrite, %OutPutVar%, spaconfig.ini, CurrentPath, Path
  CurrentPath = %OutPutVar%
  MaxChars := 100
  TextToControl= %OutPutVar%
  Gosub FixControlTextLength
  menu, tray, tip, Current Folder Location (%TextToControl%)
  MouseMove,%CursorX%,%CursorY% ;move mouse back after folder selection
  BlockInput, On
 }
IniRead,PromptForFilename,spaconfig.ini,configuration,PromptForFilename, 0
if PromptForFilename = 1
 {
  blockinput,Off
  CoordMode,mouse,screen
  MouseGetPos,CursorX,CursorY 
  InputBoxXPos := (CursorX - 94) ;input x pos will be 104 less then where current cursor is to align cursor with the OK button. Doing it this way prevents the cursor
  InputBoxYPos := (CursorY - 104) ;from moving before or after input box is presented, unless user moves mouse off the OK button.
  SysGet,MWA,MonitorWorkArea
  CheckInputBoxEndingXPos := (InputBoxXPos+350)
  if CheckInputBoxEndingXPos > %MWARight%
   {
    InputBoxXPos := (MWARight - 350)
    NewMouseXPos := (InputBoxXPos + 94)
    MouseMove, %NewMouseXPos%,%CursorY% ;have to move mouse before inputbox is created
   }
  CheckInputBoxEndingYPos := (InputBoxYPos + 151)
  If CheckInputBoxEndingYPos > %MWABottom%
   {
    MouseGetPos,CursorXforButton, ;needed in case the MouseXPos for cursor over button change while Checking Input Box Ending XPos
    InputBoxYPos := (MWAbottom - 130)
    NewMouseYPos := (InputBoxYPos + 104)
    NewMouseXPos := (InputBoxXPos + 94)
    MouseMove, %NewMouseXPos%,%NewMouseYPos% ;have to move mouse before inputbox is created
   }
  if InputBoxYPos < %MWATop% 
   {
    InputBoxYPos = %MWATop%
    NewMouseYPos := (InputBoxYPos + 104)
    NewMouseXPos := (InputBoxXPos + 94)
    MouseMove, %NewMouseXPos%,%NewMouseYPos% ;have to move mouse before inputbox is created
   }
  if InputBoxXPos < %MWALeft%
   {
    InputBoxXPos = %MWALeft% 
    NewMouseYPos := (InputBoxYPos + 104)
    NewMouseXPos := (InputBoxXPos + 94)
    MouseMove, %NewMouseXPos%,%NewMouseYPos% ;have to move mouse before inputbox is created
   } 

  ;check for invalid filenames  
  ReturnHereIfInvalidCharFoundInNewFileName:
  InputBox,PromptForFilenameFileName,Type in a file name,Omit the file type as in JPG BMP PNG or GIF,,350, 130,%InputBoxXPos%,%InputBoxYPos%,,, 
  if (errorlevel = 1 or PromptForFilenameFileName = "") 
   return
  FoundInvalidCharPos := % RegExMatch( PromptForFilenameFileName, "[\\/:.*?""<>|]" )
  if FoundInvalidCharPos = 0 ;no invalid chars found
   goto NewFileNameIsValid
  FoundInvalidCharPos--
  StringTrimLeft,TempFileName,PromptForFilenameFileName,%FoundInvalidCharPos%
  StringLen,Length,TempFileName
  Length--
  StringTrimRight,InvalidChar,TempFileName,%Length%
  Msgbox, 262160, Invalid File Name "%PromptForFilenameFileName%", Can not use %InvalidChar%`nPlease try again.
  MouseMove, %CursorX%,%CursorY%
  goto ReturnHereIfInvalidCharFoundInNewFileName
  NewFileNameIsValid:
  SplitPath,PromptForFilenameFileName,,,,PromptForFilenameFileName
  CoordMode,mouse,screen
  MouseMove, %CursorX%,%CursorY%
  blockinput, On
 } ;ending brace for If PromptForFilename = 1

If Class = OperaWindowClass ;open Save As window - works in all os versions - no need for rbutton with Opera
 {
  send {ctrldown}{lbutton}{ctrlup}
  PictureImage = As 
 }
WinGetActiveTitle,title 
If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1" or Class = "MozillaUIWindowClass" or Class = "MozillaWindowClass"  or Class = "IEframe") ;send rbutton to open right click context menu
 {
  WinActivate,ahk_class %class% ;not sure if this is needed but won't do any harm here
  If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1" or Class = "MozillaUIWindowClass" or Class = "MozillaWindowClass") 
   {
    IfInString,Title,Google Search ;specifically added sleep due to google search image results zoom picture preview when mouse is over image. In Chrome and Firefox, until the picture enlarges (zoom) it is not a saveable picture. In IE it is a bmp file before it zooms, then a jpg after zooming. Opera does not Zoom the picture.  
     sleep 500                     
   }                              
  Send {rbutton} 
 }
If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1" or Class = "MozillaUIWindowClass"  or Class = "MozillaWindowClass") ;send v to open Save Image or Save As window
 {
  If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1")
   PictureImage = As
  If (Class = "MozillaUIWindowClass"  or Class = "MozillaWindowClass")
   PictureImage = Image
  sleep 100
  send v ;for Chrome and Firefox
 } 
If Class = IEframe
 {
  Gosub CheckWindowContents  ;if Save As is not in Right Click Menu then it gives error message and never returns to next line this by designed - If this is not a savable picture checking the right click menu times out much quicker then winwaitactive
  send s
  PictureImage = Picture
 }
IniRead,TimeOutPeriod,SpaConfig.ini,WaitForSavePictureAsWindow,TimeOutPeriod,5
if TimeOutPeriod < 5
 TimeOutPeriod = 5
WinWaitActive, Save %PictureImage%, , %TimeOutPeriod%
If Errorlevel = 1
 {
  blockinput, off
  MsgBox, 262160, SavePictureAs V%Version% Error Message, Ctrl+Space keys have been pressed. This may not be saveable picture. If you are sure this is a saveable picture, try to save it again. Some pictures are protected from download by the website creator.
  return
 }
If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1" or Class = "MozillaUIWindowClass" or Class = "MozillaWindowClass" or Class = "IEframe" or Class = "OperaWindowClass")  ;Get filename 
 {
  Filename = ;if saving the image fails after retrieving the filename and ControlGetText fails below then Filename would already contain a filename. 
  LoopCount = 0  
  Loop ;as soon as the filename is retrieved then the loop breaks
   {
    sleep 200
    LoopCount++ ; max 5 seconds (25 loops)
    ControlgetText, Filename, Edit1, Save %pictureimage%  
    If Filename <>
     break
    Else
    If LoopCount > 25
     {
      blockinput, off
      MsgBox,16,Error, Not able to retrieve the original filename.`nPlease try again.
        Return
     } ;end brace If LoopCount = 25
   } ;end brace loop
 } ;if class = ...... end bracket
;Filename has been retrieved, now prepare filename for edit1 control, history
SplitPath,Filename,,,ExtExist ;filename will always exist in Safari due to using clipboard to get the filename
If ExtExist =   ;if ext is blank (not included in filename) find out what it is
 {
  If A_OSVersion = win_xp
   {
    If (Class = "IEframe" or Class = "OperaWindowClass")
     {
      ControlGetText,ext,ComboBox3
      splitpath,ext,,,ext,
      StringTrimRight,ext,ext,1
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext%
     }    
    If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1" or Class = "MozillaUIWindowClass"  or Class = "MozillaWindowClass")
     {
      ControlGetText,ext,ComboBox3 ;firefox
      StringTrimRight,ext,ext,5
      IfInString,ext,Jpeg
       Ext = Jpg
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext% ;for history
     }
    ;If Class = {1C03B488-D53B-4a81-97F8-754559640193} ;Safari will always have ext in filename due to using the clipboard
   }  ;end xp section
  If A_OSVersion = win_vista ;no ext in filename
   {
    If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1")
     {
      ControlGetText,ext,ComboBox2
      AddExt = 0
      IfInString,ext,.. ;When the OS is Vista and the browser is Chrome sometimes chrome reports the file type as .(File).. in the combo box
       {                      ;very hard to duplicate
        ext = jpg ;saving it as a jpg works since the file type was ..
        AddExt = 1
        Goto SkipSplitpath
       }
      splitpath,ext,,,ext,
      StringTrimRight,ext,ext,1 ;ext includes the right )
      SkipSplitpath:
      If AddExt = 1
       SendFilename = %CurrentPath%\%filename%.%ext% ;probably could add ext to all SendFilename for more browsers but for others it will cause filename to be filename.ext.ext - will always exclude ext for consistency 
      Else                                        
       SendFilename = %CurrentPath%\%filename%
       HistoryFilename = %CurrentPath%\%filename%.%ext% 
     }  
    If (Class = "MozillaUIWindowClass" or Class = "MozillaWindowClass")    ;win_vista ;no ext in filename
     {
      ControlGetText,ext,ComboBox2 ;ComboBox2 in Vista
      StringTrimRight,ext,ext,5
      IfInString,ext,Jpeg
       ext = jpg
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext%
     }  
    If (Class = "IEframe" or Class = "OperaWindowClass")      ;win_vista ;no ext in filename
     {
      If Class = IEframe
       ControlGetText,ext,ComboBox2
      If Class = OperaWindowClass
       ControlGetText,ext,ComboBox3
      splitpath,ext,,,ext,
      StringTrimRight,ext,ext,1 ;ext includes the right )
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext%
     }
   } ;end of ;win_vista ;no ext in filename
  If A_OSVersion = win_7
   {
    If (Class = "MozillaUIWindowClass" or Class = "MozillaWindowClass") ;Need to add ext to the filename retrieved in firefox
     {
      ControlGetText,ext,ComboBox2 ;it is ComboBox3 in WinXp
      StringTrimRight,ext,ext,5
      IfInString,ext,Jpeg
       ext = jpg
      sendfilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext% 
     }
    If (Class = "IEframe" or Class = "OperaWindowClass")
     {
      ControlGetText,ext,ComboBox2 ;get ext type
      splitpath,ext,,,ext,
      StringTrimRight,ext,ext,1
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext%
     }
    If (Class = "Chrome_WidgetWin_0" or Class = "Chrome_WidgetWin_1")
     {
      ControlGetText,ext,ComboBox2 ;get ext type
      IfInString,ext,.. ;sometimes chrome reports the file type as .(File).. in the combo box - very hard to duplicate
       ext = jpg ;saving it as a jpg works
      else
       {
        StringTrimRight,ext,ext,5 ;get ext type
        IfInString,ext,jpeg ;only in chrome & win 7 does the ext show JPEG but saves as JPG so Ifexist HistoryFilename won't 
         ext = jpg ; find it - HistoryFilename is the name of the file saved to hard drive
       }
      SendFilename = %CurrentPath%\%filename%
      HistoryFilename = %CurrentPath%\%filename%.%ext% 
     }
   } ;end brace If A_OSVersion = win_7   
 } ;end if no ext bracket
Else
 {
  SplitPath,filename,,,Ext,Name
  SendFilename = %CurrentPath%\%name%  ;no ext - Will put in the edit1 control of Save Picture as window
  HistoryFilename = %CurrentPath%\%name%.%ext% ;ext is included in filename - Will be used for history
 }
if PromptForFilename = 1 ;has user chosen to be prompted to enter filename before saving picture
 {
  IfExist,%CurrentPath%\%PromptForFilenameFileName%.%ext% ;does user chosen filename already exist
   {
    Random, Number, 0, 99999
    SendFilename  = %CurrentPath%\%PromptForFilenameFileName%%number%
    HistoryFilename = %CurrentPath%\%PromptForFilenameFileName%%number%.%ext%
   }
  else
   {
    SendFileName = %CurrentPath%\%PromptForFilenameFileName%
    HistoryFilename = %CurrentPath%\%PromptForFilenameFileName%.%ext%
   }
 } 
else ;for If PromptForFilename = 1
 {
  IfExist,%HistoryFilename% ;HistoryFilename always includes ext
   {
    Random, Number, 0, 99999
    SplitPath, HistoryFilename,,CurrentPath,Ext,NameNoExt,
    SendFilename  = %CurrentPath%\%NameNoExt%%number%
    HistoryFilename = %CurrentPath%\%NameNoExt%%number%.%ext%
   }
 }

Verify: 
ControlFocus,Edit1,Save %PictureImage%
ControlSetText , Edit1,,Save %PictureImage% ;blank the edit box for safety
sleep 200
If ExtExist =
 Filename = %SendFileName%
else
 Filename = %SendFileName%.%ExtExist%
SendInput {Raw}%FileName% ;leave no spaces between {Raw} and %FileName%

;NOTES 1: Reason for using SendInput {Raw} instead of Send
;Send Car+Mustang+-+1999+Red+06 actually sends CarMustang_!999Red)6 (incorrect filename)
;SendInput {Raw} Car+Mustang+-+1999+Red+06 actually sends Car+Mustang+-+1999+Red+06 (exact filename match)
;NOTES 2: Reason for using SendInput {Raw} instead of ControSetText. When using some broswers on some OS's ControlSetText puts the text in the control but then when sending enter, alt s, or (ControlClick, &Save) to save the image it always tries to save the original filename without the new path and random number. For example it continues to try to save - images.jpg instead of c:\NewPath\images45334.jpg This behavior is in windows vista and windows 7.

sleep 250
SetControlDelay, -1
SetTitleMatchMode,2
blockinput, off ;turn off here in case the save picture as window is left open for any reason
ControlClick , &Save, Save %PictureImage%,,,,NA 
;NOTES 1: Reason for using &Save instead of button1 or Send Enter
;Save is button1 on some browsers in some os's in others it is button2
;Sending {Enter} instead of ControlClick was not reliable on all browsers in all os's
WinWaitNotActive,ahk_class %class%,,5
LoopCount = 0
Loop ;as soon as the file is found to exist then the loop breaks
 {
  sleep 200
  LoopCount++ ; max 5 seconds (25 loops)
  IfExist,%HistoryFilename%
   {
    DoesFileExist = yes
    break
   }
  If LoopCount = 25
   {
    DoesFileExist = no
    break
   }
 }
If DoesFileExist = no
 {
  MsgBox,16,Error, Something went wrong and the picture may not have been saved`n`nPlease try again.
  Return
 }
Gosub VerifySpaconfigIniExists
IniWrite,%HistoryFileName%,Spaconfig.ini,history,LastSavedPicture
IniRead, HistoryValue, spaconfig.ini, History, HistoryValue, ENABLED
MyList =
if HistoryValue = ENABLED ;update history
 {
  Space=
  Gosub VerifySpaconfigIniExists
  loop 30 ;read and clear history until blank line
   {
    iniread, History%a_index%, Spaconfig.ini, History, History%a_index% 
    if History%a_index% =
     break
    numberoflines := a_index
    IniWrite,%Space%,spaconfig.ini,history,history%a_index%
   }
  NumberOfLines++
  if NumberOfLines > 30 ;should not reach 31
   NumberOfLines = 30
  loop %NumberOfLines%  ;write history back
   {
    if a_index = 1
     IniWrite, %HistoryFilename%, Spaconfig.ini, History, History%a_index%
    else
     {
      AddNextLine := (a_index-1)
      IniWrite, % History%AddNextLine%, Spaconfig.ini, History, History%a_index% 
     }
   }
  IfWinExist, ahk_id %HistoryID% ;update history window
   {
    controlget,MyList,list,,listbox1,ahk_id %HistoryID%
    StringTrimLeft,MyList,MyList,65
    Mylist := ( "Use arrow keys to scroll through the pictures to view them below" "`n" HistoryFilename "`n" Mylist ) ;add last downloaded image to MyList
    SendMessage, 0x188, 0, 0, ListBox1, ahk_id %HistoryID% ;need to position highlight line after saving history
    CurrentLineSelected = %ErrorLevel% 
    CurrentLineSelected++ 
    guicontrol, 3:,listbox1, |    ;blanks listbox
    Loop, Parse, mylist ,`n,`r  ;retrieve 1 line at a time
     GuiControl, 3:, ListBox1, %A_LoopField%  ;add one line at a time back to listbox
    If CurrentLineSelected <> 1
     CurrentLineSelected++ 
    GuiControl, 3: Choose, listbox1, %CurrentLineSelected%
   }
 } ;end brace if HistoryValue = ENABLED ;update history 
if ConfirmationMessageValue = ENABLED  ;Done message
 {
  Gui 17: Show, x%ConfirmationMessageXpos% y%ConfirmationMessageYpos% , Confirmation Message
  sleep %ConfirmationMessageDelay%
  Gui 17: Hide 
 }
return
;********************************************************************************************************************************
;***************************************End Control Space Save Picture Section***************************************************
;********************************************************************************************************************************
;================================================================================================================================
;===================================================Menu Tray Labels=============================================================
;================================================================================================================================
OpenPictureLocationFolder:
Gosub VerifySpaconfigIniExists
IniRead,currentpath,spaconfig.ini,currentpath,path,%A_PicturesSF%
Run %currentpath%
Return
;*****************************************************************************************************
;Program Documentation 
;*****************************************************************************************************
ProgramDocumentation:
Gosub VerifySpaconfigIniExists
iniread, ProgramDocumentationColorGuiVar, spaconfig.ini, SystemColors, ProgramDocumentationColorGuiVar, 8080ff
iniread, ProgramDocumentationColorListboxVar, spaconfig.ini, SystemColors, ProgramDocumentationColorListboxVar,C0C0C0
iniread, ProgramDocumentationColorListboxTextVar, spaconfig.ini, SystemColors, ProgramDocumentationColorListboxTextVar,000000
SysGet, MonitorWorkArea, MonitorWorkArea ;w680 h500
ListboxWidth := (MonitorWorkAreaRight - 50)
ListboxHeight := (MonitorWorkAreaBottom - 60)
gui 7: font, s12, MS sans serif
Gui 7: Add, ListBox, hwndPDLBhandle w%ListBoxWidth% h%ListBoxHeight%  vscroll 0x100 Hscroll choose1 c%ProgramDocumentationColorListboxTextVar%, ||SavePictureAs V%Version%
|
|I created this program to easily save pictures and background wallpaper from the web using a web browser.
|   
|         * Preserves the original filename and adds a random 1-5 digit number to the end to avoid dupicate filenames. 
|         * Supports Windows XP, Vista and Windows 7 using Internet Explorer, Firefox, Opera and Google Chrome.
|
|Quick Tutorial
|         * Place mouse cursor over picture in one of the supported web browsers
|           Press Ctrl and the Spacebar and the picture will be saved to the folder you chose during setup or from the system tray icon
|    
|         * Use the system tray icon to change the location to save pictures
|
|         * Use the system tray icon to launch the Favorites Toolbar
|           Configure up to 5 buttons to quickly change the saved picture location
|
|         * Use the system tray icon to launch menu to change screen & text colors
|         
|         * Use the system tray icon to launch the history screen to view, delete, rename or copy the last 30 pictures saved
|
|         * Use the system tray icon to disable the Confirmation Message or history.
|
|         * Exit the program by clicking the system tray icon 
|
|Version History
|       Version 1.0 - Original program
|         1) copies pictures in internet explorer by placing mouse over picture and using hotkeys Ctrl Space.
|
|         2) saves files in location defined in SavePictureAs-CtrlSpace.ahk. 
|
|         3) only tested in Windows XP  
|
|       Version 2.0 - Minor Update
|         1) created setup.ahk to allow user to select location to save pictures.
|  
|       Version 2.1 - Minor Update
|         1) merged setup.ahk into SavePictureAs-CtrlSpace.ahk.   
|
|       Version 2.2 - Minor Update
|         1) added code to prevent program from hanging when trying to save a picture that does not have the "Save Picture As" context menu.
|
|       Version 2.3 - Minor update
|         1) added code to block user input (mouse and keyboard)  during code execution   
|
|         2) added code to clear clipboard to prevent user copied clipboard content from interferring with program   
|
|         3) renamed filepath.ini to spafilepath.ini because other programs use filepath.ini   
|
|         4) added title bars for dialog boxes. IE (Help, about...)   
|
|         5) changed code, now during inital setup when the user clicks on cancel instead of choosing a picture location folder the program exits
|
|         6) added showonce.txt so user would be able to see splash screen again   
|
|         7) changed code so that the picture location path is not blank when the user chooses to cancel the picture location select menu
|
|         8) added code to check to see if the current save picture as folder exists at program startup. If the folder does not exist the program prompts user to
|          select another one.
|
|      Version 3.0 - Major update
|         1) added Confirmation Message that displays when a picture has being saved and added option to disable the Confirmation Message
|
|         2) added Confirmation Message enabled/disabled status balloon to system tray, and the ability to change the colors for the Confirmation Message.
|
|         3) program does not use spafilepath.ini or showsplash.txt anymore, uses spaconfig.ini for all user settings.
|            The program will create spaconfig.ini with default settings if it does not exist.  
|
|         4) added ability to keep a history of pictures saved  
|
|         5) made the menu on the system tray open with left or right click  
|
|         6)  changed system tray icon from the green H to an icon showing a couple in a hot tub (aka SPA) Save Picture As.  
|
|         7) added "Rename Last Picture", it also updates the history to reflect the new file name.  
|
|      Version 4.0 - Major Update
|         1) added Last Saved Picture Menu to system tray menu
|         Last Saved Picture Menu includes...
|          a) View, Delete, Move, Copy & Rename last saved picture
|         2) added Splash Screen to system tray menu.
|         3) redesigned menus and display screens
|         4) added menu to change screen and text colors
|         5) added Reset All Defaults to tray menu
|         6) added picture preview to the history screen
|         7) added Saved picture locations Favorites toolbar
| 
|      Version 5.0 - Major Update
|         1) added ability to save pictures using Firefox, Opera and Google Chrome
|         2) added ability to save pictures using Windows Vista and Windows 7
| 
|      Version 5.1 - Minor Update
|         1) changed the way firefox saves pictures
|         2) made the History Menu, Program Documentation, Help Screen and Favorites Toolbar configuration windows resizable.
|         3) Added Rename, Move and Copy buttons to History Menu
|         4) Removed Last Saved Picture Menu. The last saved picture can be viewed on the History Menu
|      Version 5.2 - Minor Update
|         1) minor bug fixes - removed some message boxes used for troubleshooting
|      Version 5.3 - Minor Update
|         1) add minimum size to the history window. Needed minimum size to display properly
|      Version 5.4 - Minor Update
|         1) Now if original ext was already in the edit1 control on Save Picture/Image As window then use that one otherwise do not add ext to filename
|      Version 5.5 - Minor Update
|         1) Now checks to see if user is administrator. Windows 7 needs SavePictureAs to Run As Administrator due to SavePictureAs features
|            to Move, Delete, Rename and Copy options on the History Menu.
|      Version 5.6 - Minor Update
|         1) Fixed minor bug if the folder chosen to save pictures to does not exist
|      Version 5.7 - Minor Update
|         1) Added Prompt for Filename. Now when enabled the image being saved can be given a user specified filename.
|         2) Added "Check For Updates" on startup and tray menu.
|      Version 5.8 - Minor Update
|         1) Added ability to view changes when a new version is available
|      Version 5.9 - Minor Update
|         1) Fixed issue with Firefox using different window classes across OS platforms
|      Version 6.0 - Minor Update
|         1) Found an issue with not being able to position the Confirmation Window
|      Version 6.1 - Minor Update
|         1) Removed Run As Admin and choose instead to display a message explaining UAC preventing moving and renaming pictures
|      Version 6.2 - Minor Update
|         1) Fixed issue with Google Chrome not saving images in certains conditions.
|      Version 6.3 - Minor Update
|         1) Fixed issue with Windows 7 and Firefox not able to verify image was successfully saved
|      Version 6.4 - Minor Update
|         1) Fixed issue with decimals places in History Gui X,Y, W and H values
|      Version 6.5 - Minor Update
|         1) Fixed issue with Google Chrome window class
|      Version 6.6 - Minor Update
|         1) Found a stray comma preventing Favorites Toolbar number 2 from saving the users choice
|
|Thanks for using my program
|email savepictureas@hotmail.com with any questions and suggestions for this program. 
|Created by  -=Robert Jackson=-   2008
Gui 7: Color,  %ProgramDocumentationColorGuiVar%, %ProgramDocumentationColorListboxVar%
Gui 7: +Resize 
Gui 7: Show, ,SavePictureAs V%Version% (Program Documentation)
Attach(PDLBhandle, "p r2")
return
;*****************************************************************************************************
;Favorites ToolBar
;*****************************************************************************************************
FavoritesToolBar:
Gosub VerifySpaconfigIniExists
IniRead, ButtonFavorite1, spaconfig.ini, FavoritePaths, 1, %A_PicturesSF%
IniRead, ButtonFavorite2, spaconfig.ini, FavoritePaths, 2, %A_Desktop%
IniRead, ButtonFavorite3, spaconfig.ini, FavoritePaths, 3, %A_PicturesSF%
IniRead, ButtonFavorite4, spaconfig.ini, FavoritePaths, 4, %A_MyDocuments%
IniRead, ButtonFavorite5, spaconfig.ini, FavoritePaths, 5, %A_PicturesSF%
IniRead, ToolbarXPos,spaconfig.ini,ToolbarPos,ToolbarXpos,750
IniRead, ToolbarYPos,spaconfig.ini,ToolbarPos,ToolbarYpos,20
iniread, FavoritesToolBarGuiVar, spaconfig.ini, SystemColors, FavoritesToolBarGuiVar,  8080ff
Gui 13: Add, Button, x3 y2 w30 h30  , 1
Gui 13: Add, Button, x33 y2 w30 h30 , 2
Gui 13: Add, Button, x63 y2 w30 h30 , 3
Gui 13: Add, Button, x93 y2 w30 h30 , 4
Gui 13: Add, Button, x123 y2 w30 h30 , 5
Gui 13: Add, Button, x3 y32 w150 h20  , Configure Favorites
Gui 13: +resize   +MinSize +MaxSize -MaximizeBox
Gui 13: Show, x%ToolbarXpos% y%ToolbarYpos% h55 w156, Toolbar
Gui 13: Color, %FavoritesToolBarGuiVar%,
WinGet,ToolbarID,ID, Toolbar
WinSet, alwaysontop, On , Toolbar
SetTimer, WatchCursor1       
return
WatchCursor1:
MouseGetPos, , , id, control
WinGetTitle, title, ahk_id %id%
if ((control = "Button1" or Control = "Button2" or Control = "Button3" or Control = "Button4" or Control = "Button5") & (title = "toolbar"))
 {
 if control = button1
  ToolTip, %buttonfavorite1%
 if control = button2
  ToolTip, %buttonfavorite2%
 if control = button3
  ToolTip, %buttonfavorite3%
 if control = button4
  ToolTip, %buttonfavorite4%
 if control = button5
  ToolTip, %buttonfavorite5% 
 SetTimer, WatchCursor1end, 100
 return
 
 WatchCursor1end:
 if (title <> "toolbar" or control = "button6" or control = "")  ;removes tooltip when cursor is not over toolbar 
  ToolTip
  return
 }
Return
13Button1:
Gosub VerifySpaconfigIniExists
IniRead, CurrentPath, spaconfig.ini, FavoritePaths, 1, %A_PicturesSF%
IniWrite, %CurrentPath%, spaconfig.ini, CurrentPath, path
MaxChars := 100
TextToControl = %CurrentPath%
Gosub,FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
Return
13Button2:
Gosub VerifySpaconfigIniExists
IniRead, CurrentPath, spaconfig.ini, FavoritePaths, 2, %A_Desktop%
IniWrite, %CurrentPath%, spaconfig.ini, CurrentPath, path
MaxChars := 100
TextToControl = %CurrentPath%
Gosub,FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
Return
13Button3:
Gosub VerifySpaconfigIniExists
IniRead, CurrentPath, spaconfig.ini, FavoritePaths, 3, %A_PicturesSF%
IniWrite, %CurrentPath%, spaconfig.ini, CurrentPath, path
MaxChars := 100
TextToControl = %CurrentPath%
Gosub,FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
Return
13Button4:
Gosub VerifySpaconfigIniExists
IniRead, CurrentPath, spaconfig.ini, FavoritePaths, 4, %A_MyDocuments%
IniWrite, %CurrentPath%, spaconfig.ini, CurrentPath, path
MaxChars := 100
TextToControl = %CurrentPath%
Gosub,FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
Return
13Button5:
Gosub VerifySpaconfigIniExists
IniRead, CurrentPath, spaconfig.ini, FavoritePaths, 5, %A_PicturesSF%
IniWrite, %CurrentPath%, spaconfig.ini, CurrentPath, path
MaxChars := 100
TextToControl = %CurrentPath%
Gosub,FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
Return
13ButtonConfigureFavorites:
Gosub VerifySpaconfigIniExists
IfWinExist, Configure Favorite Picture Locations
 {
  WinActivate,Configure Favorite Picture Locations
  return
 }
Loop 5
 {
  IniRead, Value, spaconfig.ini, FavoritePaths, %A_Index%, %A_PicturesSF%
  Favorite%A_Index%Text = %Value%
 }  
width := (A_ScreenWidth * .75 )
width := Floor(width)
iniread, ConfigureFavoritesToolBarGuiVar, spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiVar, c0c0c0
iniread, ConfigureFavoritesToolBarGuiTextVar, spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiTextVar, 000000
Gui 14: font, s12, MS sans serif
Gui 14: Add, Button, x3  y29   w30 h30 , 1
Gui 14: Add, Text,   x40 y37 c%ConfigureFavoritesToolBarGuiTextVar% G14Button1, %Favorite1Text%
Gui 14: Add, Button, x3  y64  w30 h30 , 2
Gui 14: Add, Text,   x40 y72 c%ConfigureFavoritesToolBarGuiTextVar% G14Button2, %Favorite2Text%
Gui 14: Add, Button, x3  y99  w30 h30 , 3
Gui 14: Add, Text,   x40 y107 c%ConfigureFavoritesToolBarGuiTextVar% G14Button3, %Favorite3Text%
Gui 14: Add, Button, x3  y134 w30 h30 , 4
Gui 14: Add, Text,   x40 y142 c%ConfigureFavoritesToolBarGuiTextVar% G14Button4, %Favorite4Text%
Gui 14: Add, Button, x3  y169 w30 h30 , 5
Gui 14: Add, Text,   x40 y177 c%ConfigureFavoritesToolBarGuiTextVar% G14Button5, %Favorite5Text%
Gui 14: +Resize +0x300000  +MinSize +MaxSize +MinSize100x  -MaximizeBox
Gui 14: Show,  x10 y10 w%width% h230, Configure Favorite Picture Locations
Gui 14: Color, %ConfigureFavoritesToolBarGuiVar%,
Gui, +LastFound
GroupAdd, MyGui, % "ahk_id " . WinExist()
Return
14GuiSize:
 UpdateScrollBars(A_Gui, A_GuiWidth, A_GuiHeight)
return
14Button1:
Gosub VerifySpaconfigIniExists
IniRead, Favorite1, spaconfig.ini, FavoritePaths, 1, %A_PicturesSF%
FileSelectFolder, OutPutVar, *%Favorite1%, 3, Current Folder Location for Favorite 1 is`n%Favorite1%
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  Goto 14Button1
 }
IniWrite, %OutPutVar%, spaconfig.ini, FavoritePaths, 1
IniRead, ButtonFavorite1, spaconfig.ini, FavoritePaths, 1, %A_PicturesSF%
Gui 14: Destroy
Goto, 13ButtonConfigureFavorites
14Button2:
Gosub VerifySpaconfigIniExists
IniRead, Favorite2, spaconfig.ini, FavoritePaths, 2, %A_PicturesSF%
FileSelectFolder, OutPutVar, *%Favorite2%, 3, Current Folder Location for Favorite 2 is`n%Favorite2%
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  Goto 14Button2
 }
IniWrite, %OutPutVar%, spaconfig.ini, FavoritePaths, 2 
IniRead, ButtonFavorite2, spaconfig.ini, FavoritePaths, 2, %A_PicturesSF%
Gui 14: Destroy
Goto, 13ButtonConfigureFavorites
14Button3:
Gosub VerifySpaconfigIniExists
IniRead, Favorite3, spaconfig.ini, FavoritePaths, 3, %A_PicturesSF%
FileSelectFolder, OutPutVar, *%Favorite3%, 3, Current Folder Location for Favorite 3 is`n%Favorite3%
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  Goto 14Button3
 }
IniWrite, %OutPutVar%, spaconfig.ini, FavoritePaths, 3
IniRead, ButtonFavorite3, spaconfig.ini, FavoritePaths, 3, %A_PicturesSF%
Gui 14: Destroy
Goto, 13ButtonConfigureFavorites
14Button4:
Gosub VerifySpaconfigIniExists
IniRead, Favorite4, spaconfig.ini, FavoritePaths, 4, %A_PicturesSF%
FileSelectFolder, OutPutVar, *%Favorite4%, 3, Current Folder Location for Favorite 4 is`n%Favorite4%
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  Goto 14Button4
 }
IniWrite, %OutPutVar%, spaconfig.ini, FavoritePaths, 4
IniRead, ButtonFavorite4, spaconfig.ini, FavoritePaths, 4, %A_PicturesSF%
Gui 14: Destroy
Goto, 13ButtonConfigureFavorites
14Button5:
Gosub VerifySpaconfigIniExists
IniRead, Favorite5, spaconfig.ini, FavoritePaths, 5, %A_PicturesSF%
FileSelectFolder, OutPutVar, *%Favorite5%, 3, Current Folder Location for Favorite 5 is`n%Favorite5%
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  Goto 14Button5
 }
IniWrite, %OutPutVar%, spaconfig.ini, FavoritePaths, 5
IniRead, ButtonFavorite5, spaconfig.ini, FavoritePaths, 5, %A_PicturesSF%
Gui 14: Destroy
Goto, 13ButtonConfigureFavorites
13GuiEscape:
13GuiClose:
Gosub VerifySpaconfigIniExists
WinGet, State,MinMax,ahk_id %ToolbarID% ;Don't save position if minimized
if State > -1
  {
   WinGetPos,ToolbarXPos,ToolbarYPos,,,Toolbar ;position toolbar where it was last located on next use
   IniWrite, %ToolbarXPos%,spaconfig.ini,ToolbarPos,ToolbarXpos
   IniWrite, %ToolbarYPos%,spaconfig.ini,ToolbarPos,ToolbarYpos
  }
SetTimer, WatchCursor1,off
SetTimer, WatchCursor1end, off
Gui 13: Destroy
Return
14GuiEscape:
14GuiClose:
Gui 14: Destroy
Return
;*****************************************************************************************************
;Favorites ToolBar End
;*****************************************************************************************************
;*****************************************************************************************************
;History Menu
;*****************************************************************************************************
ConfigureHistory:
Gosub VerifySpaconfigIniExists
MyList =
IfWinExist, SavePictureAs V%Version% (History)
 {
  Gui 3: Show, ,SavePictureAs V%Version% (History)
  WinGet,HistoryID,ID,SavePictureAs V%Version% (History)
  return
 }  
IfNotExist, %A_ScriptDir%\spaimage.jpg
 FileInstall, SpaImage.jpg, %A_ScriptDir%\SpaImage.jpg, 1
SysGet, MonitorWorkArea, MonitorWorkArea ;place history as high on the screen as possible due to height, get monitorworkarea here in case the taskbar was moved to top of screen after SavePictureAs was started
SysGet, TitleBarHeight, 4 ;need to know the titlebar height to center the image vertically
iniread, HistoryColorGuiVar, spaconfig.ini, SystemColors, HistoryColorGuiVar,  8080ff
iniread, HistoryColorGuiTextVar, spaconfig.ini, SystemColors, HistoryColorGuiTextVar, 000000
iniread, HistoryColorListboxVar, spaconfig.ini, SystemColors, HistoryColorListboxVar, c0c0c0
iniread, HistoryColorListBoxTextVar, spaconfig.ini, SystemColors, HistoryColorListBoxTextVar,000000
iniRead, HistoryValue, spaconfig.ini, History, HistoryValue, ENABLED
GuiWidth = 740 
GuiHeight := (MonitorWorkAreabottom - titlebarheight)*.98
GuiHeight := Floor(GuiHeight)
DefaultGuiXPos := (MonitorWorkAreaRight-GuiWidth)/2
DefaultGuiXPos := Floor(DefaultGuiXPos)     ;whole numbers only
DefaultGuiYPos := (MonitorWorkAreaBottom-GuiHeight-30)/2
DefaultGuiYPos := Floor(DefaultGuiYPos)
IniRead,GuiXpos,spaconfig.ini,HistoryMenuPos,XPos,%GuiXpos%,%DefaultGuiXPos%
IniRead,GuiYpos,spaconfig.ini,HistoryMenuPos,YPos,%GuiYpos%,%DefaultGuiYPos%
if GuiXpos =
 GuiXpos = %DefaultGuiXPos%
if GuiYpos =
 GuiYpos = %DefaultGuiYPos%
Static1FontSize = 16
ListBoxheight = 148
ListboxWidth = 720
ButtonWidth = 102 
ButtonHeight = 40
ListBoxXpos = 10
ButtonXpos = 10
ButtonYpos := (GuiHeight - 55)
Gui 3: font, s14 c%HistoryColorGuiTextVar%, MS sans serif
Gui 3: Add, Text, x%ListBoxXpos% w%GuiWidth% , History is %HistoryValue%       Newest Entries on Top 
Gui 3: font, s12 c%HistoryColorListBoxTextVar%, MS sans serif
Gui 3: Add, ListBox, x%ListBoxXpos% w%ListBoxWidth% h%ListBoxHeight% hwndLB vscroll choose1 gViewHistoryItems vHighLightedLine 0x100 Hscroll,Use arrow keys to scroll through the pictures to view them below 
Gui 3: font, s10, MS sans serif
Gui 3: Add,  Button,hwndHistoryHandle1 x%ButtonXpos% y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Disable History
Gui 3: Add,  Button,hwndHistoryHandle2 x%ButtonXpos% y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Enable History
Gui 3: Add,  Button,hwndHistoryHandle3 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Clear History
Gui 3: Add,  Button,hwndHistoryHandle4 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Delete Picture
Gui 3: Add,  Button,hwndHistoryHandle5 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Move Picture
Gui 3: Add,  Button,hwndHistoryHandle6 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Copy Picture
Gui 3: Add,  Button,hwndHistoryHandle7 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Rename Picture
Gui 3: Add,  Button,hwndHistoryHandle8 x+1   y%ButtonYpos% w%ButtonWidth% h%ButtonHeight%  0x300, Image Details
Gui 3: Add, Picture,hwndHistoryHandle9 x123  y3000  w-1  h315, spaimage.jpg 
Gui 3: Color,  %HistoryColorGuiVar%,%HistoryColorListboxVar%, 
Gui 3: +Resize +MinSize340x500  
Gui 3: Show, x%GuiXpos% y%GuiYpos% w%GuiWidth% h%GuiHeight% ,SavePictureAs V%Version% (History)
loop
 {
  count++
  sleep 100
  WinGet,HistoryID,ID,SavePictureAs V%Version% (History)
  if HistoryID <>
   break
  if count > 50 ;suspect HistoryID randomly is blank
   {
    MsgBox,4112,Error,Error occurred opening the History Menu.`nSavePictureAs will need to be restarted.`nPress OK to restart SavePictureAs. 
    Reload
    sleep 5000
   }
 }
control,hide,,static2, ahk_id %HistoryID%
loop 30
 {
  iniread, History%a_index%, Spaconfig.ini, History, History%a_index% 
  if History%a_index% <>
   MyList :=  ((MyList)(History%a_index%)"|")
   if History%a_index% =
   break
 }
guicontrol, 3:,listbox1, |    ;blanks listbox
guicontrol, 3:,listbox1,Use arrow keys to scroll through the pictures to view them below
Loop, Parse, mylist ,|,`r  ;retrieve 1 line at a time
 {
  IfNotExist,%a_loopfield%
   {
    if a_loopfield <>
     guicontrol, 3:,listbox1,File does not exist----> %A_LoopField%
   }
  else
   GuiControl, 3:, ListBox1, %A_LoopField%  ;add one line at a time back to listbox
 }
GuiControl, 3:Choose, listbox1, 1
ControlGetPos,,ListBoxYpos,,ListBoxHeight,listbox1, ahk_id %HistoryID%
ControlGetPos,,ButtonYPos,,,button1,ahk_id %HistoryID%
WinGetPos,,,GuiWidth,GuiHeight,ahk_id %HistoryID%
ImageHeight := ( ButtonYpos - ListBoxYpos - ListBoxHeight -30 ) ;30 is 15 above and 15 below image spacer
ImageYpos := ((ButtonYpos - ImageHeight - (ListBoxYpos+ListBoxHeight))/2)+ListBoxYpos+ListBoxHeight
ImageYpos := Floor(ImageYpos)
guicontrol, 3: ,static2, *w-1 *h%ImageHeight% spaimage.jpg
ControlGetPos,,,ImageWidth,,static2, ahk_id %HistoryID%
ImageXpos := (GuiWidth-ImageWidth)/2
ImageXpos := Floor(ImageXpos)
ControlMove,static2,%ImageXpos%,%ImageYpos%,,,ahk_id %HistoryID%
control,show,,static2, ahk_id %HistoryID%
IniRead, HistoryValue, spaconfig.ini, History, HistoryValue, Enabled
if HistoryValue = Enabled
 {
  Control, Disable, ,Button2, SavePictureAs V%Version% (History)
  Control, Hide, ,Button2, SavePictureAs V%Version% (History)
  Control, Show, ,Button1, SavePictureAs V%Version% (History)
 }
if HistoryValue = Disabled
 {
  Control, Disable, ,Button1, SavePictureAs V%Version% (History)
  Control, Hide, ,Button1, SavePictureAs V%Version% (History)
  Control, Show, ,button2, SavePictureAs V%Version% (History)
 }   
RT = p r2
Attach(LB, RT)
Attach(HistoryHandle1, RT)
Attach(HistoryHandle2, RT)
Attach(HistoryHandle3, RT)
Attach(HistoryHandle4, RT)
Attach(HistoryHandle5, RT)
Attach(HistoryHandle6, RT)
Attach(HistoryHandle7, RT)
Attach(HistoryHandle8, RT)
Attach(HistoryHandle9, RT)
ShowHighLightedLine = %A_ScriptDir%\spaimage.jpg
MyList =
Gui 3: font, s14 c%historyColorGuiTextVar%, MS sans serif ;Main window text
GuiControl, 3: Font, static1 
Return
ViewHistoryItems:
SetTimer, PictureScroll, -10 
Return 
PictureScroll:
Gosub VerifySpaconfigIniExists
NotFound = 0
Attach(HistoryHandle9, "p r")
ControlGetPos,,ListBoxYpos,,ListBoxHeight,listbox1, SavePictureAs V%Version% (History)
ControlGetPos,,buttonYpos,,,Button1, SavePictureAs V%Version% (History)
Guicontrolget, HighLightedLine, 3:
if HighLightedLine = ;just incase something goes wrong, without these 2 lines if HighLightedLine is blank then Ifnotexist 
 return ; %HighLightedLine% below executes and changes the line to File does not exist---->.
ImageYpos :=  ((ButtonYpos - ListBoxYpos - ListBoxHeight - 315)/2) + ListBoxYpos + ListBoxHeight
ImageYpos := Floor(ImageYpos)
SendMessage, 0x188, 0, 0, ListBox1, ahk_id %HistoryID% ; 0x188 is LB_GETCURSEL 
CurrentLineSelected = %ErrorLevel% 
ShowSpaImage = 0
IfNotInString,HighLightedLine,File does not exist---->
 {
  IfNotInString,HighLightedLine,Use arrow keys to scroll through the pictures to view them below
   {
    Ifnotexist %HighLightedLine%
     {
      NotFound = 1
      NotFoundFileName = %HighLightedLine%
      SendMessage, (LB_DELETESTRING:=0x182),%CurrentLineSelected%,0,, ahk_id %LB%
      String := ("File does not exist---->" HighLightedLine )
      SendMessage, (LB_INSERTSTRING:=0x181),%CurrentLineSelected%,&String,, ahk_id %LB%
      HighLightedLine = %A_ScriptDir%\spaimage.jpg
      CurrentLineSelected++
      GuiControl, 3:Choose, listbox1, %CurrentLineSelected%
      ControlFocus,listbox1,SavePictureAs V%Version% (History)
      ShowSpaImage = 1
     }
  }
 }
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  HighLightedLine = %A_ScriptDir%\spaimage.jpg
  ShowSpaImage = 1
 }
IfInString, HighLightedLine, File does not exist---->
 {
  HighLightedLine =  %A_ScriptDir%\spaimage.jpg
  ShowSpaImage = 1
 }
if ShowSpaImage = 0 ; if ShowSpaImage = 1 then HighLightedLine does not change from spaimage.jpg
 {
  Loop 30
   {
    if CurrentLineSelected = %A_Index%
     {
      iniread, HighLightedLine, Spaconfig.ini, History, History%A_Index% ;allow to displayed line number
      break
     }
   }    
 }
if ShowHighLightedLine <> %HighLightedLine%
 {
  ShowHighLightedLine = %HighLightedLine%
  ControlGetPos,,ListBoxYPos,, ListBoxHeight,listbox1, ahk_id %HistoryID%
  ControlGetPos,,ButtonYPos,,,button1, ahk_id %HistoryID%
  WinGetPos,,,GuiWidth,GuiHeight,ahk_id %HistoryID%
  ImageData_Load(ImageData, ShowHighLightedLine) 
  ImageData_GetSize(ImageData, Width, Height)
  KeepResolution = %width%
  MaxImageHeight := ( ButtonYpos - ListBoxYPos - ListBoxHeight -30 ) 
  MaxImageWidth := (GuiWidth-34) 
  ;if original width and height are smaller then the area available then display the image without resizing
 if ( Width < MaxImageWidth and Height < MaxImageHeight )
   {
    if Width > %MaxImageWidth%
     Width = %MaxImageWidth%
    else
     MaxImageWidth = %Width%
    if Height > %MaxImageHeight%
     Height = %MaxImageHeight%
    else
     MaxImageHeight = %Height%
   }
  GuiControl, 3:Hide, static2,
  ;------------------------------------------------------------------------------
  ;---- Need to combine the next 10 lines ---------------------------------------
  ;------------------------------------------------------------------------------
  if Width > %Height% ;place image on screen based on original width and height
   guicontrol, 3: ,static2, *h-1 *w%MaxImageWidth% %ShowHighLightedLine%
  else
   guicontrol, 3: ,static2, *w-1 *h%MaxImageHeight% %ShowHighLightedLine%
  GuiControlGet, Pic, 3:Pos, Static2 ;get new resized dimensions
  ;if new sizes are too big then resize again
  if PicH > %MaxImageHeight%
  guicontrol, 3: ,static2, *w-1 *h%MaxImageHeight% %ShowHighLightedLine%
  if PicW > %MaxImageWidth%
   guicontrol, 3: ,static2, *h-1 *w%MaxImageWidth% %ShowHighLightedLine%
  ;------------------------------------------------------------------------------
  ;------------------------------------------------------------------------------
  GuiControlGet, Pic, 3:Pos, Static2 ;get new resized dimensions
  guicontrol, 3: ,static2, *h-1 *w%KeepResolution% %ShowHighLightedLine% ;Puts image back on screen at original size and resolution to keep resolution when the iamge is being enlarged due to enlarging the gui with attach.ahk. To see the results of this line, comment it out, display the history menu. Use the mouse to resize the history menu to about 1 inch by 1 inch. Use arrow keys to display a different image. Then resize gui using mouse. The image will resize but have very bad resolution. With this line and ControlMove static2 below using the PicW and PicH of the correct size picture will keep the resolution. Althrough attach does stretch the image
  ImageXpos := (GuiWidth-PicW)/2
  ImageXpos := Floor(ImageXpos)
  ImageYpos := ( (ButtonYpos - PicH - (ListBoxYpos+ListBoxHeight) )/2)+ListBoxYpos+ListBoxHeight
  ImageYpos := Floor(ImageYpos)
  ControlMove,static2,%ImageXpos%,%ImageYpos%,%PicW%,%PicH%,ahk_id %HistoryID% ;resize image to calculated dimensions
  GuiControl, 3:Show, static2,
  Attach(HistoryID)
  Attach(HistoryHandle9, "p r2")
 }
If NotFound = 1
 Msgbox, 262160, File Error, Picture was deleted, moved, or renamed!`n(%NotFoundFilename%) 
return
3ButtonEnableHistory:
Gosub VerifySpaconfigIniExists
ControlFocus,listbox1,SavePictureAs V%Version% (History)
IniWrite, ENABLED, spaconfig.ini, History, HistoryValue
IniRead, HistoryValue, spaconfig.ini, History, HistoryValue, ENABLED
Control, Disable, ,Button2, SavePictureAs V%Version% (History)
Control, Hide, ,Button2, SavePictureAs V%Version% (History)
Control, Enable, ,Button1, SavePictureAs V%Version% (History)
Control, Show, ,Button1, SavePictureAs V%Version% (History)
Guicontrol, ,static1, History is %HistoryValue%       Newest Entries on Top
ToolTip, History is [%HistoryValue%]
SetTimer, RemoveToolTipHE, 3000
return
RemoveToolTipHE:
SetTimer, RemoveToolTipHE, Off
ToolTip
Return
3ButtonDisableHistory:
Gosub VerifySpaconfigIniExists
ControlFocus,listbox1,SavePictureAs V%Version% (History)
IniWrite, DISABLED, spaconfig.ini, History, HistoryValue
IniRead, HistoryValue, spaconfig.ini, History, HistoryValue, DISABLED
Control, Disable, ,Button1, SavePictureAs V%Version% (History)
Control, Hide, ,Button1, SavePictureAs V%Version% (History)
Control, Enable, ,Button2, SavePictureAs V%Version% (History)
Control, Show, ,Button2, SavePictureAs V%Version% (History)
Guicontrol, ,static1, History is %HistoryValue%      Newest Entries on Top
ToolTip, History is [%HistoryValue%]
SetTimer, RemoveToolTipHD, 3000
return
RemoveToolTipHD:
SetTimer, RemoveToolTipHD, Off
ToolTip
Return
3ButtonClearHistory:
{
 Gosub VerifySpaconfigIniExists
 Msgbox, 4132, SavePictureAs V%Version% ,This option erases only the history of files saved.`nNo files are deleted.`n`nDo you want to continue?
 IfMsgBox Yes
  {
   loop 30
     IniWrite,%a_space% , spaconfig.ini, History, History%A_Index%
   guicontrol, 3:,listbox1, |    ;blanks listbox
   guicontrol, 3:,highlightedline ,Use arrow keys to scroll through the pictures to view them below
   GuiControl, 3:Choose, listbox1, 1
   goto viewhistoryitems
  }
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  Return
 }
3ButtonDeletePicture:
Gosub VerifySpaconfigIniExists
MyList =
Guicontrolget, HighLightedLine    
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  MsgBox, 262208, SavePictureAs V%Version% (History Menu),No picture has been selected.
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  return
 }
SendMessage, 0x188, 0, 0, ListBox1, A ; 0x188 is LB_GETCURSEL ;Line number of hightlighted line
Pos = %ErrorLevel% 
Pos++ ;add one because errorlevel starts with zero
Msgbox, 4132, Confirm File Deletion, Do you want to delete %HighLightedLine%?
IfMsgBox Yes
 {
  IfInString, HighLightedLine, File does not exist---->
   StringTrimLeft,HighLightedLine,HighLightedLine, 25
  loop 30 ;recreate MyList without the file to be deleted
   {
    iniread, History%a_index%, Spaconfig.ini, History, History%a_index% 
    if History%a_index% =
     break
    else
    if History%A_Index% <> %HighLightedLine%
      MyList :=  ((MyList)(History%a_index%)"|")
   }
   Loop 30 ;clear inifile
    iniwrite,%a_space%,spaconfig.ini,history,history%a_index%
   guicontrol, 3:,listbox1, |    ;blanks listbox
   guicontrol, 3:,listbox1,Use arrow keys to scroll through the pictures to view them below
   Loop, Parse, mylist ,|,`r  ;retrieve 1 line at a time
    {
     if a_loopfield =
      {
       BlankLine = %A_Index%
       BlankLine++
       break
      }
     iniwrite,%A_LoopField%,spaconfig.ini,history,history%a_index%
     IfNotExist,%a_loopfield%
      guicontrol, 3:,listbox1,File does not exist----> %A_LoopField%
     else
      guicontrol, 3:,listbox1,%A_LoopField%
    }
 FileSetAttrib, -R, %HighLightedLine% ;Delete file from hard drive
 FileRecycle, %HighLightedLine%
 SendMessage, (LB_GETCOUNT := 0x18B), 0, 0, ListBox1, A 
 LineCount = %ErrorLevel% 
 If Pos > %Linecount%
  Pos = %Linecount%
 GuiControl, 3:Choose, listbox1, %pos%
 ControlFocus, ListBox1, SavePictureAs V%Version% (History)
 mylist = 
 Goto ViewHistoryItems  
}
IfMsgBox no
ControlFocus, ListBox1, SavePictureAs V%Version% (History)
Return
3ButtonMovePicture:
Gosub VerifySpaconfigIniExists
MyList =
Guicontrolget, HighLightedLine    
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  MsgBox, 262208, SavePictureAs V%Version% (History Menu),No picture has been selected.
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  return
 }
IfInString, HighLightedLine, File does not exist---->
 return
SendMessage, 0x188, 0, 0, ListBox1, ahk_id %HistoryID% ;need to position highlight line after moving picture
CurrentLineSelected = %ErrorLevel% 
SplitPath,HighLightedLine,CurrentFilename
FileSelectFolder, OutPutVar, *%A_MyDocuments%, 3, Please choose a folder to move`n%CurrentFilename% to
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  goto 3ButtonMovePicture
 }
ifexist %OutPutVar%\%currentfilename%
 {
  Msgbox, 262160, File Error, %currentfilename% already exist in %OutPutVar%
  goto 3ButtonMovePicture
 }
FileSetAttrib, -R, %HighLightedLine% ;Delete file from hard drive
FileMove, %HighLightedLine%, %OutPutVar%
iniwrite, %OutPutVar%\%CurrentFileName%, spaconfig.ini, History, History%CurrentLineSelected%
controlget,MyList,list,,listbox1,ahk_id %HistoryID%
Loop, Parse, mylist ,`n,`r  ;retrieve 1 line at a time
 {
  if A_LoopField = %HighLightedLine%
   {   
    RenameLine = %a_index% 
    renameline--
    SendMessage, (LB_DELETESTRING:=0x182),%CurrentLineSelected%,0,, ahk_id %LB%
    String = %OutPutVar%\%CurrentFileName%
    SendMessage, (LB_INSERTSTRING:=0x181),%CurrentLineSelected%,&String,, ahk_id %LB%
    break
   }
 }
CurrentLineSelected++
GuiControl, 3: Choose, listbox1, %CurrentLineSelected%
ControlFocus, ListBox1, SavePictureAs V%Version% (History)
mylist = 
Goto ViewHistoryItems
return
3ButtonCopyPicture:
Gosub VerifySpaconfigIniExists
MyList =
Guicontrolget, HighLightedLine    
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  MsgBox, 262208, SavePictureAs V%Version% (History Menu),No picture has been selected.
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  return
 }
IfInString, HighLightedLine, File does not exist---->
 return
SendMessage, 0x188, 0, 0, ListBox1, ahk_id %HistoryID% ;need to position highlight line after moving picture
CurrentLineSelected = %ErrorLevel% 
SplitPath,HighLightedLine,CurrentFilename
FileSelectFolder, OutPutVar, *%A_MyDocuments%, 3, Please choose a folder to copy %CurrentFilename% to
if errorlevel = 1
return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  goto 3ButtonCopyPicture
 }
ifexist %OutPutVar%\%currentfilename%
 {
  Msgbox, 262160, File Error, %currentfilename% already exist in %OutPutVar%
  goto 3ButtonMovePicture
 }
FileCopy, %HighLightedLine%, %OutPutVar%
if ErrorLevel <> 0
 MsgBox, 4112,Error, The file was not able to be copied. Ensure the destination folder exists and is not write protected.
ControlFocus, ListBox1, SavePictureAs V%Version% (History)
return
3ButtonRenamePicture:
Gosub VerifySpaconfigIniExists
MyList =
Guicontrolget, HighLightedLine    
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  MsgBox, 262208, SavePictureAs V%Version% (History Menu),No picture has been selected.
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  return
 }
IfInString, HighLightedLine, File does not exist---->
 return
SendMessage, 0x188, 0, 0, ListBox1, A ; 0x188 is LB_GETCURSEL ;Line number of hightlighted line
CurrentLineSelected = %ErrorLevel% 
SplitPath,HighLightedLine,OriginalFileNameWithExt,OriginalPath,OriginalExt,OriginalFileNameWithoutExt
Gui, +OwnDialogs
InputBox, newfilename , Rename this file?, Type a new filename for (%OriginalFilenameWithExt%)`nDo not include the file type in the file name. Example .jpg or .bmp,, 520, 245,,,,,%OriginalFileNameWithoutExt% 
if (errorlevel = 1 or newfilename = "") 
return
FoundInvalidCharPos := % RegExMatch( NewFileName, "[\\/:.*?""<>|]" )
if FoundInvalidCharPos = 0
 goto FileNameIsValid
FoundInvalidCharPos--
StringTrimLeft,TempFileName,NewFileName,%FoundInvalidCharPos%
StringLen,Length,TempFileName
Length--
StringTrimRight,InvalidChar,TempFileName,%Length%
Msgbox, 262160, Invalid File Name "%newfilename%", Can not use %InvalidChar%`nPlease try again.
goto 3ButtonRenamePicture
TempFileName=
InvalideChar=
Length=
FileNameIsValid:
Gosub VerifySpaconfigIniExists
ifExist, %originalpath%\%newfilename%.%originalExt%
 {
  Msgbox, 262160, Error renaming file, Duplicate file name exist, please choose another one.
  Goto   3ButtonRenamePicture
 }
Filemove, %HighLightedLine%, %originalpath%\%newfilename%.%originalEXT%
if ErrorLevel <> 0
 {
  MsgBox, 4112,Error, The file was not able to be renamed. Ensure folder exists and is not write protected.
  return
 }
IniWrite, %originalpath%\%newfilename%.%originalEXT%, spaconfig.ini, History, History%CurrentLineSelected% 
controlget,MyList,list,,listbox1,ahk_id %HistoryID%
Loop, Parse, mylist ,`n,`r  ;retrieve 1 line at a time
 {
  if A_LoopField = %HighLightedLine%
   {   
    RenameLine = %a_index% 
    renameline--
    SendMessage, (LB_DELETESTRING:=0x182),%CurrentLineSelected%,0,, ahk_id %LB%
    String = %originalpath%\%newfilename%.%originalEXT%
    SendMessage, (LB_INSERTSTRING:=0x181),%CurrentLineSelected%,&String,, ahk_id %LB%
    break
   }
 }
CurrentLineSelected++
GuiControl, 3: Choose, listbox1, %CurrentLineSelected%
ControlFocus, ListBox1, SavePictureAs V%Version% (History)
Return
3ButtonImageDetails:
Gosub VerifySpaconfigIniExists
Guicontrolget, HighLightedLine
if HighLightedLine = Use arrow keys to scroll through the pictures to view them below
 {
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  Return
 }
IfInString, HighLightedLine, File does not exist---->
 {
  ControlFocus, ListBox1, SavePictureAs V%Version% (History)
  Return
 }
;some of these may have values from other places in script and my not be overwritten below.
 OutDir=
 OutFileName=
 width=
 height=
 size=
 timestamp=
 
 SendMessage, 0x188, 0, 0, ListBox1, A ; 0x188 is LB_GETCURSEL 
 CurrentLineSelected = %ErrorLevel% 
 iniread, Image, Spaconfig.ini, History, History%CurrentLineSelected%
 ImageData_Load(ImageData, Image) 
 ImageData_GetSize(ImageData, Width, Height)
 SplitPath, Image , OutFileName, OutDir
 FileGetSize, size, %Image%, k
 FileGetTime, TimeStamp, %Image%, c
 FormatTime, TimeStamp , %timestamp%, dddd MMMM d, yyyy hh:mm:ss tt
 IfExist, %Image%
  msgbox,,SavePictureAs V%Version%, Location on computer: %OutDir%`n`nImage Name: %OutFileName%`n`nImage dimensions: %width%x%height%`n`nImage Size: %size%k`n`nImage Date: %TimeStamp%
 else
  MsgBox,16,Error, Not able to retrieve picture details.
 OutDir=
 OutFileName=
 width=
 height=
 size=
 timestamp=
 ControlFocus, ListBox1, SavePictureAs V%Version% (History)
 Return
3GuiEscape:
3GuiClose:
Gosub VerifySpaconfigIniExists
WinGet, State,MinMax,ahk_id %HistoryID%
if State > -1
IfWinExist, ahk_id %HistoryID%
{
 WinGetPos,x,y,,,ahk_id %HistoryID%
 IniWrite,%x%,spaconfig.ini,HistoryMenuPos,XPos
 IniWrite,%y%,spaconfig.ini,HistoryMenuPos,YPos
} 
gui 3: destroy
Return
3GuiSize:
ControlFocus,listbox1,SavePictureAs V%Version% (History)
WinGetPos,,,GuiWidth,GuiHeight,ahk_id %HistoryID%
Static1Fontsize := ( GuiHeight * .02 )
Static1Fontsize := Floor(Static1Fontsize)
Gui 3: font, s%Static1Fontsize% c%historyColorGuiTextVar%, MS sans serif ;Main window text
GuiControl,3:font,static1
ControlGetPos,,,LBwidth,LBheight,listbox1,SavePictureAs V%Version% (History) ;sometimes id HistoryID is blank
if lbwidth = ;probably don't need this since the above line is now using the title name instead of HistoryID
return ;if the lbwidth is blank then the control move command below causes the listbox not to appear
ListboxFontsize := ( LBHeight * .08 )
ListboxFontsize := Floor(ListboxFontsize)
Gui 3: font, s%ListboxFontsize% c%HistoryColorListBoxTextVar%, ; MS sans serif
GuiControl,3: font,listbox1
GuiControl, 3: Move, listbox1, w%LBwidth% h%LBheight%, ;prevent listbox from changing sizes when changing fonts
if (GuiWidth > 100 and GuiWidth < 340)
 ButtonFontSize = 6
if (GuiWidth > 339 and GuiWidth < 461)
 ButtonFontSize = 9
if (GuiWidth > 460)
 ButtonFontSize = 11
Gui 3: font, s%ButtonFontSize%,
Loop 8
 {
  button = button%a_index%
  GuiControl,3:font,%button%
 }
return
;*****************************************************************************************************
;History Menu End
;*****************************************************************************************************
;*****************************************************************************************************
;About Gui
;*****************************************************************************************************
ABOUT:
Gosub VerifySpaconfigIniExists
iniread, AboutColorGuiVar, spaconfig.ini, SystemColors, AboutColorGuiVar, c0c0c0
iniread, AboutColorGuiTextVar, spaconfig.ini, SystemColors, AboutColorGuiTextVar, 000000
gui 5: font, s14 , MS sans serif
Gui 5: Add, Text, x6 y10 c%AboutColorGuiTextVar%, Program Name = SavePictureAs 
Gui 5: Add, Text, x6 y40 c%AboutColorGuiTextVar%, Version = %Version%     
Gui 5: Add, Text, x6 y70 c%AboutColorGuiTextVar%, Created April 2008 by -=Robert Jackson=- 
Gui 5: +Resize  +MinSize +MaxSize -MaximizeBox
Gui 5: Show, h100 w360, SavePictureAs V%Version% (About)
Gui 5: Color, %AboutColorGuiVar%,
Return
;*****************************************************************************************************
;Help Gui
;*****************************************************************************************************
USERHELP:
Gosub VerifySpaconfigIniExists
iniread, HelpColorGuiVar, spaconfig.ini, SystemColors, HelpColorGuiVar, c0c0c0
iniread, HelpColorGuiTextVar, spaconfig.ini, SystemColors, HelpColorGuiTextVar, 000000
gui 6: font, s14 , MS sans serif
Gui 6: Add, Text,hwndHelpHandle x6 y10 w770 c%HelpColorGuiTextVar%,1. Place the mouse cursor over any picture on a webpage.`n`n2. Press the "ctrl and spacebar" keys to save the picture to your hard drive.`n`n3. You can change saved picture location, configure saved pictures Confirmation Message and enable/disable the splash screen via the system tray menu items.`n`n4. Use the system tray menu item "History" to view, copy, rename and delete the last 30 saved pictures.`n`n5. Use the system tray icon to launch the Favorites Toolbar and configure up to five buttons to quickly change the saved picture location.`n`n6. Use the system tray icon to launch menu to change screen and text colors.`n`n7. Exit the program by clicking the system tray icon. 
Gui 6: +Resize  ; +MinSize +MaxSize
Gui 6: Show,  w790, SavePictureAs V%Version% (Help)
Gui 6: Color, %HelpColorGuiVar%,  
Attach(Helphandle, "p r2")
Return
;*****************************************************************************************************
;Change System Colors Gui
;*****************************************************************************************************
SystemColors:
Gosub VerifySpaconfigIniExists
IfWinExist, SavePictureAs V%Version% (Program Colors)
 Gui 15: Destroy
IniRead, ProgramColorsMenuColorGuiVar, spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiVar, c0c0c0
IniRead, ProgramColorsMenuColorGuiTextVar, spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiTextVar, 000000
SysGet,MWA,MonitorWorkArea
Gui 15: font, s10, MS sans serif
Gui 15: Add, Text,         x12 y17 c%ProgramColorsMenuColorGuiTextVar%, History Menu
Gui 15: Add, DropDownList, x12 y42 w170 h20  gHistoryColors vHistoryColors R5, Main Window|Main Window Text|Interior Window|Interior Window Text|Test Colors
Gui 15: Add, Text,         x200 y17 c%ProgramColorsMenuColorGuiTextVar%, Splash Screen
Gui 15: Add, DropDownList, x198 y42 w170 h20 gSplashScreenColors vSplashScreenColors R4, Main Window|Interior Window|Interior Window Text|Test Colors
Gui 15: Add, Text,         x12 y117 c%ProgramColorsMenuColorGuiTextVar%, Program Documentation
Gui 15: Add, DropDownList, x12 y142 w170 h20 gProgramDocumentationColors vProgramDocumentationColors R5, Main Window|Interior Window|Interior Window Text|Test Colors
Gui 15: Add, Text,         x200 y117 c%ProgramColorsMenuColorGuiTextVar%, Confirmation Message Menu
Gui 15: Add, DropDownList, x200 y142 w170 h20 gConfirmationMessageMenuColors vConfirmationMessageMenuColors R4, Main Window|Circle Color|Circle Text Color|Test Colors
Gui 15: Add, Text,          x12 y217 c%ProgramColorsMenuColorGuiTextVar%, Favorites Tool Bar
Gui 15: Add, DropDownList,  x12 y242 w170 h20 gFavoritesToolBarColors vFavoritesToolBarColors R3, Main Window|Test Colors 
Gui 15: Add, Text,          x200 y217 c%ProgramColorsMenuColorGuiTextVar%, Configure Favorites Menu
Gui 15: Add, DropDownList,  x200 y242 w170 h20 gConfigureFavoritesMenuColors vConfigureFavoritesMenuColors R3, Main Window|Main Window Text|Test Colors 
Gui 15: Add, Text,         x12 y317 c%ProgramColorsMenuColorGuiTextVar%, About Screen
Gui 15: Add, DropDownList, x12 y342 w170 h20 gAboutScreenColors vAboutScreenColors R3, Main Window|Main Window Text|Test Colors
Gui 15: Add, Text,         x200 y317 c%ProgramColorsMenuColorGuiTextVar%, Program Color Menu
Gui 15: Add, DropDownList, x200 y342 w170 h20 gProgramColorMenuColors vProgramColorMenuColors R2, Main Window|Main Window Text
Gui 15: Add, Text,         x12 y417 c%ProgramColorsMenuColorGuiTextVar%, Help Screen
Gui 15: Add, DropDownList, x12 y442 w170 h20  gHelpScreenColors vHelpScreenColors R3, Main Window|Main Window Text|Test Colors
Gui 15: Add, Text,         x200 y417 c%ProgramColorsMenuColorGuiTextVar%, Default Colors
Gui 15: Add, Button,       x200 y444 w170 h20 gResetAllColors, Reset All Colors
Gui 15: +Resize  +MinSize +MaxSize -MaximizeBox
Gui 15: Show, y%MWATop% h517 w385, SavePictureAs V%Version% (Program Colors)
Gui 15: Color, %ProgramColorsMenuColorGuiVar%
Return
15GuiEscape:
15GuiClose:
gui 15: destroy
Return
   
HistoryColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, historyColors
if historyColors = Test Colors
 {
  IfWinExist,SavePictureAs V%Version% (History)
   {
    WinActivate, SavePictureAs V%Version% (History)
    Gui 3: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 3: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, ConfigureHistory
    Gui 3: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 3: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if historyColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, historyColorGuiVar
  IniRead,HistoryColorGuiVar,Spaconfig.ini, SystemColors,historyColorGuiVar, 8080ff
 }
if historyColors = Main Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, historyColorGuiTextVar
  IniRead, historyColorGuiTextVar, Spaconfig.ini, SystemColors, historyColorGuiTextVar, 000000
 }
if historyColors = Interior Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, historyColorListBoxVar
  IniRead, historyColorListBoxVar, Spaconfig.ini, SystemColors, historyColorListBoxVar, c0c0c0
 }
if historyColors = Interior Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, historyColorListBoxTextVar
  IniRead, historyColorListBoxTextVar, Spaconfig.ini, SystemColors, historyColorListBoxTextVar, 000000
 }
IfWinExist, SavePictureAs V%Version% (History)
 {
  Gui 3: font, s12 c%historyColorGuiTextVar%, MS sans serif ;Main window text
  GuiControl, 3: Font, static1 ;Main window text
  Gui 3: font, s12 c%HistoryColorListBoxTextVar%, MS sans serif ;Listbox text
  GuiControl, 3: Font, listbox1 ;Listbox text
  Gui 3: Color,  %HistoryColorGuiVar%, %HistoryColorListboxVar% ;Main windows and listbox colors  
 }
Return
SplashScreenColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, SplashScreenColors
if SplashScreenColors = Test Colors 
 {
  IfWinExist,SavePictureAs V%Version% (SplashScreen)
   {
    WinActivate, SavePictureAs V%Version% (SplashScreen)
    Gui 9: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 9: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, SplashScreen
    Gui 9: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 9: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color =  
 Return
StringTrimLeft,Color, Color,  2
if SplashScreenColors = Main Window 
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, SplashScreenColorGuiVar
  IniRead, SplashScreenColorGuiVar, Spaconfig.ini, SystemColors, SplashScreenColorGuiVar,  8080ff
 }
if SplashScreenColors = Interior Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, SplashScreenColorListBoxVar
  IniRead, SplashScreenColorListBoxVar, Spaconfig.ini, SystemColors, SplashScreenColorListBoxVar, c0c0c0
 }
if SplashScreenColors = Interior Window Text 
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, SplashScreenColorListBoxTextVar
  IniRead, SplashScreenColorListBoxTextVar, Spaconfig.ini, SystemColors, SplashScreenColorListBoxTextVar, 000000
 }
IfWinExist, SavePictureAs V%Version% (SplashScreen) 
 {  
  Gui 9: font, s12 c%SplashScreenColorListBoxTextVar%, MS sans serif
  GuiControl, 9: Font, listbox1
  Gui 9: Color,  %SplashScreenColorGuiVar%, %SplashScreenColorListboxVar%
 }
Return
ProgramDocumentationColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, ProgramDocumentationColors
if ProgramDocumentationColors = Test Colors 
 {
  IfWinExist,SavePictureAs V%Version% (Program Documentation)
   {
    WinActivate, SavePictureAs V%Version% (Program Documentation)
    Gui 7: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 7: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, ProgramDocumentation
    Gui 7: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 7: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color =
 Return
StringTrimLeft,Color, Color,  2
if ProgramDocumentationColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ProgramDocumentationColorGuiVar
  IniRead, ProgramDocumentationColorGuiVar,Spaconfig.ini, SystemColors, ProgramDocumentationColorGuiVar, 8080ff
 }
if ProgramDocumentationColors = Interior Window 
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ProgramDocumentationColorListBoxVar
  IniRead, ProgramDocumentationColorListBoxVar, Spaconfig.ini, SystemColors, ProgramDocumentationColorListBoxVar, c0c0c0
 }
if ProgramDocumentationColors = Interior Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ProgramDocumentationColorListBoxTextVar
  IniRead, ProgramDocumentationColorListBoxTextVar, Spaconfig.ini, SystemColors, ProgramDocumentationColorListBoxTextVar, 000000
 }
IfWinExist,SavePictureAs V%Version% (Program Documentation)
 {
  Gui 7: font, s12 c%ProgramDocumentationColorListBoxTextVar%, MS sans serif
  GuiControl, 7: Font, listbox1
  Gui 7: Color,  %ProgramDocumentationColorGuiVar%, %ProgramDocumentationColorListboxVar%
 }
Return
ConfirmationMessageMenuColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, ConfirmationMessageMenuColors
if ConfirmationMessageMenuColors = Test Colors
 {
  IfWinExist, SavePictureAs V%Version% (Confirmation Message Configuration)
   {
    WinActivate, Confirmation Message
    Gui 8: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 8: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, ConfigureConfirmationMessageColor ;displays Gui 8 and Gui 17
    Gui 8: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 8: destroy
    Gui 17: Hide
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if ConfirmationMessageMenuColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ConfigureConfirmationMessageColorGuiVar
  IniRead, ConfigureConfirmationMessageColorGuiVar, Spaconfig.ini, SystemColors, ConfigureConfirmationMessageColorGuiVar,  8080ff
  Gui 8: color, %ConfigureConfirmationMessageColorGuiVar%
 }
if ConfirmationMessageMenuColors = Circle Color
 {
  IniWrite, %color%, Spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor
  IniRead, ConfirmationMessageWindowColor, Spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor, 8b8b8b
  Gui 17: color, %ConfirmationMessageWindowColor%
 }
if ConfirmationMessageMenuColors = Circle Text Color
 {
  IniWrite, %color%, Spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor
  Iniread, ConfirmationMessageTextColor, Spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor, 000000
  Gui 17: font, s26 w700 c%ConfirmationMessageTextColor% , Monotype Corsiva
  GuiControl, 17: Font, static1
 }
Return
ProgramColorMenuColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, ProgramColorMenuColors
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if ProgramColorMenuColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiVar
  IniRead, ProgramColorsMenuColorGuiVar, Spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiVar, c0c0c0
  Gui 15: Color, %ProgramColorsMenuColorGuiVar%
 }
if ProgramColorMenuColors = Main Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiTextVar
  IniRead, ProgramColorsMenuColorGuiTextVar, Spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiTextVar, 000000
  Gui 15: font, s10 c%ProgramColorsMenuColorGuiTextVar%, MS sans serif
  loop 10
  GuiControl, 15: Font, static%a_index%
 }
Return
FavoritesToolBarColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, FavoritesToolBarColors
if FavoritesToolBarColors = Test Colors
 {
  IfWinExist, Toolbar
   {
    WinActivate, SavePictureAs V%Version% (Toolbar)
    Gui 13: +disabled
    Gui 13: color, %color%
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 13: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, FavoritesToolbar
    Gui 13: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 13: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if FavoritesToolBarColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, FavoritesToolBarGuiVar
  IniRead, FavoritesToolBarGuiVar, Spaconfig.ini, SystemColors, FavoritesToolBarGuiVar,  8080ff
  Gui 13: color, %FavoritesToolBarGuiVar%
 }
Return
ConfigureFavoritesMenuColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, ConfigureFavoritesMenuColors
if ConfigureFavoritesMenuColors = Test Colors
 {
  IfWinExist, Configure Favorite Picture Locations
   {
    WinActivate, Configure Favorite Picture Locations
    Gui 14: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 14: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, 13ButtonConfigureFavorites
    Gui 14: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 14: destroy
    Return
   }
 }
IfWinExist, Configure Favorite Picture Locations
 {
  WinMove,Configure Favorite Picture Locations,,0,333
  WinActivate,Configure Favorite Picture Locations
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if ConfigureFavoritesMenuColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiVar
  IniRead, ConfigureFavoritesToolBarGuiVar, Spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiVar, c0c0c0
  Gui 14: color, %ConfigureFavoritesToolBarGuiVar%
 }
if ConfigureFavoritesMenuColors = Main Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiTextVar
  IniRead, ConfigureFavoritesToolBarGuiTextVar, Spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiTextVar, 000000
  Gui 14: font, s10 c%ConfigureFavoritesToolBarGuiTextVar%, MS sans serif
  loop 5
  GuiControl, 14: Font, static%a_index%
 }
WinActivate, SavePictureAs V%Version% (Program Colors)
Return
HelpScreenColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, HelpScreenColors
if HelpScreenColors = Test Colors
 {
  IfWinExist, SavePictureAs V%Version% (Help)
   {
    WinActivate, SavePictureAs V%Version% (Help)
    Gui 6: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 6: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, UserHelp
    Gui 6: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 6: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if HelpScreenColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, HelpColorGuiVar
  IniRead, HelpColorGuiVar, Spaconfig.ini, SystemColors, HelpColorGuiVar, c0c0c0
  Gui 6: color, %HelpColorGuiVar%
 }
if HelpScreenColors = Main Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, HelpColorGuiTextVar
  IniRead, HelpColorGuiTextVar, Spaconfig.ini, SystemColors, HelpColorGuiTextVar, 000000
  Gui 6: font, s14 c%HelpColorGuiTextVar%, MS sans serif
  GuiControl, 6: Font, static1
 }
WinActivate, SavePictureAs V%Version% (Program Colors)
Return
AboutScreenColors:
Gosub VerifySpaconfigIniExists
GuiControlGet, AboutScreenColors
if AboutScreenColors = Test Colors
 {
  IfWinExist, SavePictureAs V%Version% (About)
   {
    WinActivate, SavePictureAs V%Version% (About)
    Gui 5: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 5: -disabled
    WinActivate, SavePictureAs V%Version% (Program Colors)
    Return
   }
  Else
   {
    GoSub, About
    Gui 5: +disabled
    MsgBox,64,Preview Colors,Click Ok to continue
    Gui 5: destroy
    Return
   }
 }
CmnDlg_Color( color:= 0000FF)
if color = 
 Return
StringTrimLeft,Color, Color,  2
if AboutScreenColors = Main Window
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, AboutColorGuiVar
  IniRead, AboutColorGuiVar, Spaconfig.ini, SystemColors, AboutColorGuiVar, c0c0c0
  Gui 5: color, %AboutColorGuiVar%
 }
if AboutScreenColors = Main Window Text
 {
  IniWrite, %color%, Spaconfig.ini, SystemColors, AboutColorGuiTextVar
  IniRead, AboutColorGuiTextVar, Spaconfig.ini, SystemColors, AboutColorGuiTextVar, 000000
  Gui 5: font, s14 c%AboutColorGuiTextVar%, MS sans serif
  loop 3
  GuiControl, 5: Font, static%A_Index%
 }
 
WinActivate, SavePictureAs V%Version% (Program Colors)
Return
ConfigureConfirmationMessageColor:
Gosub VerifySpaconfigIniExists
iniread, ConfigureConfirmationMessageColorGuiVar, spaconfig.ini, SystemColors, ConfigureConfirmationMessageColorGuiVar,  8080ff
Gui 8: Add, Button, x50 y13 w65 h30 , Text
Gui 8: Add, Button, x165 y13 w65 h30 , Window
Gui 8: Add, Button, x280 y13 w65 h30 , Disable
Gui 8: Add, Button, x280 y13 w65 h30 , Enable
Gui 8: Add, Button, x395 y13 w65 h30 , Set Position
Gui 8: Add, Button, x510 y13 w65 h30 , Delay
Gui 8: +Resize  +MinSize +MaxSize -MaximizeBox
Gui 8: Show, h55 w625, SavePictureAs V%Version% (Confirmation Message Configuration)
IniRead, ConfirmationMessageValue, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus, Enabled
 if ConfirmationMessagevalue = Enabled
  {
   Control, Disable, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
   Control, Hide, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
   Control, Show, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
  }
 if ConfirmationMessagevalue = Disabled
  {
   Control, Disable, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
   Control, Hide, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
   Control, Show, ,button4, SavePictureAs V%Version% (Confirmation Message Configuration)
  }
Gui 8: Color, %ConfigureConfirmationMessageColorGuiVar%,
gui, 18:+owner8
IniRead, ConfirmationMessageDelay, spaconfig.ini, ConfirmationMessage, ConfirmationMessageDelay, 1000
IniRead, ConfirmationMessageTextColor, spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor, 000000
IniRead, ConfirmationMessageWindowColor, spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor, 8b8b8b
IniRead, ConfirmationMessageXPos,spaconfig.ini,ConfirmationMessage,ConfirmationMessageXpos, 410
IniRead, ConfirmationMessageYPos,spaconfig.ini,ConfirmationMessage,ConfirmationMessageYpos, 215
Gui 17: Show, x%ConfirmationMessageXpos% y%ConfirmationMessageYpos% , Confirmation Message
WinSet, Region, 50-0 W100 H100 R100-100, Confirmation Message
Return
;****************************End Change System Colors Gui
;*****************************************************************************************************
;===================================================================================================================================
;================================================Begin Confirmation Message=========================================================
;===================================================================================================================================
~LButton::
CoordMode, Mouse
MouseGetPos, MouseStartX, MouseStartY, MouseWin
if MouseWin <> %CMID%
 return
SetTimer, WatchMouse, 10
return
WatchMouse:
CoordMode, Mouse
MouseGetPos, MouseX, MouseY
DeltaX = %MouseX%
DeltaX -= %MouseStartX%
DeltaY = %MouseY%
DeltaY -= %MouseStartY%
MouseStartX = %MouseX%  
MouseStartY = %MouseY%
WinGetPos, CMX, CMY,,, ahk_id %CMID%
CMX += %DeltaX%
CMY += %DeltaY%
SetWinDelay, -1   
WinMove, ahk_id %CMID%,, %CMX%, %CMY%
GetKeyState, LButtonState, LButton, P
if LButtonState = U  
 {
  Gosub VerifySpaconfigIniExists
  IniWrite, %CMX%,spaconfig.ini,ConfirmationMessage,ConfirmationMessageXpos
  IniWrite, %CMY%,spaconfig.ini,ConfirmationMessage,ConfirmationMessageYpos
  ConfirmationMessageXpos = %CMX%
  ConfirmationMessageYpos = %CMY%
  SetTimer, WatchMouse, off
  return
 }
return
;*****************************************************************************************************
;Begin of change bar text window colors plus test Confirmation Message display
;*****************************************************************************************************
;continue comments here
8ButtonText:
Gosub VerifySpaconfigIniExists
color =
CmnDlg_Color( color:= "")
StringTrimLeft,color, Color,  2
if color = 
 color = %ConfirmationMessageTextColor%
IniWrite, %color%, spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor
TextColor = %color%
Gui 17: font, s26 w700 c%color% , Monotype Corsiva
GuiControl, 17: Font, static1
Return
8ButtonWindow:
Gosub VerifySpaconfigIniExists
color =
CmnDlg_Color( color:= "")
StringTrimLeft,color, Color,  2
if color = 
 color = %ConfirmationMessageWindowColor%
IniWrite, %color%, spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor
ConfirmationMessageWindowColor = %color%
IniRead, ConfirmationMessageXPos,spaconfig.ini,ConfirmationMessage,ConfirmationMessageXpos,410
IniRead, ConfirmationMessageYPos,spaconfig.ini,ConfirmationMessage,ConfirmationMessageYpos,215
Gui 17: Show, x%ConfirmationMessageXPos% y%ConfirmationMessageYPos%, Confirmation Message
Gui 17: Color, %ConfirmationMessageWindowColor%
Return
8ButtonSetPosition: 
 MsgBox,64, Set Position, Click and drag the Confirmation Message window where you want it on the screen. The position will automatically be saved.
 Return
 8ButtonDelay:
  Gui 18: 
  Gui 18: font, s12 , MS sans serif 
  Gui 18: add, text, w350 ,Enter in seconds the amount of time you want the Confirmation Message to remain on the screen
  Gui 18: font, s10 , MS sans serif 
  Gui 18: add, button, x34 y+20 w75 h25  0x300  +default -Wrap,Submit
  Gui 18: add, edit, x+57 yp w46 h25 vConfirmationMessageDelay Number Limit2
  Gui 18: add, button, x+55 yp w75 h25  0x300 -Wrap,Cancel
  Gui 18: Color,  %ConfigureConfirmationMessageColorGuiVar%
  Gui 18: +Resize  +MinSize +MaxSize -MaximizeBox
  Gui 18: Show, h160, Delay Menu
  ControlClick, edit1, Delay Menu
  Return
  18ButtonSubmit: ;Delay Menu Submit button
  GuiControlGet, ConfirmationMessageDelay
  If ConfirmationMessageDelay=
  Return
  ConfirmationMessageDelay := (ConfirmationMessageDelay*1000)
  Gosub VerifySpaconfigIniExists
  IniWrite, %ConfirmationMessageDelay%, spaconfig.ini, ConfirmationMessage, ConfirmationMessageDelay
  18ButtonCancel:
  18GuiClose:
  18GuiEscape:
  Gui 18: destroy
  Return
;**************************************************************************************************
;Begin ConfirmationMessage Enable Disable Check Section
;**************************************************************************************************
8ButtonEnable:
Gosub VerifySpaconfigIniExists
IniWrite, ENABLED, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus		      
IniRead, ConfirmationMessageValue, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus, Enabled
Control, Disable, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Hide, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Enable, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Show, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
ToolTip, Confirmation Message is [%ConfirmationMessageValue%]
SetTimer, RemoveToolTipE, 3000
return
RemoveToolTipE:
SetTimer, RemoveToolTipE, Off
ToolTip
Return
8ButtonDisable:
Gosub VerifySpaconfigIniExists
IniWrite, DISABLED, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus
IniRead, ConfirmationMessageValue, spaconfig.ini, ConfirmationMessage, ConfirmationMessageStatus, Disabled
Control, Disable, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Hide, ,Button3, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Enable, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
Control, Show, ,Button4, SavePictureAs V%Version% (Confirmation Message Configuration)
ToolTip, Confirmation Message is [%ConfirmationMessageValue%]
SetTimer, RemoveToolTipD, 3000
return
RemoveToolTipD:
SetTimer, RemoveToolTipD, Off
ToolTip
Return
8GuiEscape:
8Guiclose:
 Gui 17: Hide
 gui 8: destroy
 Return
;================================================================================================================================
;===============================================End Confirmation Message=========================================================
;================================================================================================================================
;=====================================================ChangePath=================================================================
;================================================================================================================================
CHANGEPATH:
Gosub VerifySpaconfigIniExists
IniRead, currentpath, spaconfig.ini, CurrentPath, Path, %A_MyPictureSF%
FileSelectFolder, OutputVar, *%currentpath%, 3, Please choose a folder to store your saved pictures. 
if errorlevel = 1
 return
OutPutVar := RegExReplace(OutPutVar, "\\$")  ; Removes the trailing backslash, if present.
FileGetAttrib, Attributes, %OutPutVar%
IfNotInString, Attributes, D
 {
  MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %OutputVar%`n`nPlease choose another location
  goto ChangePath
 }
IniWrite, %OutputVar%, spaconfig.ini, CurrentPath, Path
iniread,currentpath, spaconfig.ini, CurrentPath, Path, %A_MyPictureSF%
MaxChars := 100
TextToControl= %currentpath%
Gosub FixControlTextLength
menu, tray, tip, Current Folder Location (%TextToControl%)
return
;=================================================End ChangePath=================================================================
PromptForPictureName:
Gosub VerifySpaconfigIniExists
IniRead,PromptForFilename,spaconfig.ini,configuration,PromptForFilename, 0
Gui 19: font, s14
Gui 19: add, text,,Check mark below and Save Picture As will prompt you to enter a file name for`nthe picture you are saving.`n`nThe sequence will be...`n`nPlace cursor over image to save`nPress Ctrl Space`nA small window will open prompting you to enter a filename`nAfter entering a file name, click OK`nSave Picture As will place your cursor over the image, open the Save Picture As`nwindow and save the picture to the Current Folder Location with your chosen`nfile name.`n`nNote: If a file by that name already exists the program will save the new picture`nwith your chosen file name plus a random 1 to 5 digit number added to the end.
Gui 19: add, checkbox, vPromptForFilename Checked%PromptForFilename%,Prompt For Picture Name
Gui 19: add, button, x500 yp-0 w80 h25,Ok
Gui 19: add, button, x600 yp-0 w80 h25,Cancel
Gui 19: show, w700 h420,Prompt For Picture Name
Gui 19: color, c0c0c0
return
19GuiEscape:
19GuiClose:
19ButtonCancel:
Gui 19: destroy
return
19ButtonOK:
Gosub VerifySpaconfigIniExists
Gui, Submit
IniWrite,%PromptForFilename%, spaconfig.ini,Configuration,PromptForFilename
Gui 19: destroy
return
;================================================================================================================================
;================================================================================================================================
;================================================Begin Reset All defaults========================================================
ResetAllDefaults:
Gosub VerifySpaconfigIniExists
iniread, ResetAllDefaultsColorGuiVar, spaconfig.ini, SystemColors, ResetAllDefaultsColorGuiVar, c0c0c0
iniread, ResetAllDefaultsColorGuiTextVar, spaconfig.ini, SystemColors,ResetAllDefaultsColorGuiTextVar, 000000
Gui 16: font, s12, MS sans serif
Gui 16: Add, Text, , This option will restore all user configurable`nsettings back to their default settings. 
Gui 16: font, s10, MS sans serif
Gui 16: Add, Button,x87 y70 w70,Continue
Gui 16: Add, Button, x177 y70 w70,Cancel
Gui 16: +Resize  +MinSize +MaxSize
Gui 16: Show, w330 h120, SavePictureAs V%Version% (Reset All Defaults)
Gui 16: Color, %ResetAllDefaultsColorGuiVar%, %ResetAllDefaultsColorGuiTextVar%,
Return  
16ButtonContinue:
FileDelete, %A_ScriptDir%\spaconfig.ini
FileAppend,%spaconfigvar%,%A_ScriptDir%\spaconfig.ini 
Reload ;and use default configuration
sleep 5000 ;give Reload time to reload before returning 
Return
16ButtonCancel:
16GuiClose:
16GuiEscape:
Gui 16: Destroy
Return
;====================================================Reset All Colors===============================================================
ResetAllColors:
MsgBox,4132,Reset?,Do you want to reset all colors to their default colors?
IfMsgBox, Yes
 {
  Gosub VerifySpaconfigIniExists
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, HistoryColorGuiVar
  iniwrite, C0C0C0, spaconfig.ini, SystemColors, HistoryColorListboxVar
  iniwrite, 000000, spaconfig.ini, SystemColors, HistoryColorGuiTextVar
  iniwrite, 000000, spaconfig.ini, SystemColors, HistoryColorListBoxTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, ProgramDocumentationColorGuiVar
  iniwrite, C0C0C0, spaconfig.ini, SystemColors, ProgramDocumentationColorListboxVar
  iniwrite, 000000, spaconfig.ini, SystemColors, ProgramDocumentationColorListboxTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, SplashScreenColorGuiVar
  iniwrite, C0C0C0, spaconfig.ini, SystemColors, SplashScreenColorListBoxVar
  iniwrite, 000000, spaconfig.ini, SystemColors, SplashScreenColorListBoxTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, ConfigureConfirmationMessageColorGuiVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiVar
  iniwrite, 000000, spaconfig.ini, SystemColors, ProgramColorsMenuColorGuiTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, FavoritesToolBarGuiVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiVar
  iniwrite, 000000, spaconfig.ini, SystemColors, ConfigureFavoritesToolBarGuiTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, AboutColorGuiVar
  iniwrite, 000000, spaconfig.ini, SystemColors, AboutColorGuiTextVar 
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, HelpColorGuiVar
  iniwrite, 000000, spaconfig.ini, SystemColors, HelpColorGuiTextVar
  iniwrite, c0c0c0, spaconfig.ini, SystemColors, ResetAllDefaultsColorGuiVar
  iniwrite, 000000, spaconfig.ini, SystemColors,  ResetAllDefaultsColorGuiTextVar
  iniwrite, 000000, spaconfig.ini, ConfirmationMessage, ConfirmationMessageTextColor
  iniwrite, 8b8b8b, spaconfig.ini, ConfirmationMessage, ConfirmationMessageWindowColor
  MsgBox,64,SavePictureAs V%version%, All colors have been reset to the default settings.
  Return
 }
else
 Return
CheckForUpdatesGui:
IfWinExist, Check For Updates
 {
  WinActivate, Check For Updates
  return
 }
Gosub VerifySpaconfigIniExists
IniRead,Value,spaconfig.ini,CheckForUpdates,CheckForUpdates,yes
if Value = yes
 Checked = Checked
else
 Checked =
Gui 12: font, s12
Gui 12: Add, Text, x45 y20 w300 h30 , SavePictureAs current version: %version%
Gui 12: Add, Button, x22 y70 w300 h30  , Check For Updates Now
Gui 12: Add, CheckBox, x22 y130 w300 h30 vCheckForUpdatesValue %Checked% , Check for updates at program start up
Gui 12: Add, Button, x22 y190 w300 h30 , Done
Gui 12: Show, h250 w340, Check For Updates
Gui 12: color, c0c0c0
Return
12GuiClose:
Gui 12: destroy
return
12ButtonDone:
Gosub VerifySpaconfigIniExists
Gui 12: Submit
if CheckForUpdatesValue = 0
 UpdateChoice = No
else
 UpdateChoice = yes
iniwrite, %UpdateChoice%, spaconfig.ini,CheckForUpdates,CheckForUpdates
Gui 12: destroy
return
12ButtonCheckForUpdatesNow:
NewestVersionNum := UrlDownloadToVar("http://www.autohotkey.net/~DataLife/SavePictureAs_version.txt")
if (NewestVersionNum = 0 or NewestVersionNum = "")
 {
  msgbox,16,Error,There was a problem checking for updates. Make sure you are connected to the internet and try again.
  return
 }
If (Version < NewestVersionNum)
 {
  IfWinExist, Update Check
   {
    WinActivate, Update Check
    return
   }
  Changes := UrlDownloadToVar("http://www.autohotkey.net/~DataLife/SavePictureAs-changes.txt")
  if changes =
   Changes = Not able to retrieve the necessary information.
  Gui 21: font, s12 italic underline cBlue,
  Gui 21: add, text, gViewChanges,View Changes
  Gui 21: font, norm cBlack
  Gui 21: add, text,,You are currently using an out of date version of SavePictureAs.`n`nCurrent version %Version%`nNewest version %newestversionnum%`n`nWould you like to update to the newest version?
  Gui 21: add, button,   x20  y+15 w80 h25, No
  Gui 21: add, button,   x+20 yp-0 w80 h25, Yes
  Gui 21: show,,Update Check 
  Gui 21: color, c0c0c0
  return
  ViewChanges:
  MsgBox, 4160, SavePictureAs %version%,%Changes%
  return
  21GuiClose:
  21ButtonNo:
  Gui 21: destroy
  return
   
  21ButtonYes:
  Gui 21: destroy
  if A_IsCompiled <> 1
   {
    ChooseDownloadFolder:
    FileSelectFolder, DownloadFolder, *%A_MyDocuments%, 3, SavePictureAs current version %Version% `n`nSelect a folder to download Save Picture As V%NewestVersionNum% to.  
    if errorlevel  = 1
     {
      Msgbox, 8228,SavePictureAs V%Version%,You have not selected a valid location to save your file.`n`nDo you want to select a location now?
      IfMsgBox Yes
       Goto ChooseDownloadFolder
      IfMsgBox no
       {
        msgbox, 8256,Information, You have not chosen a valid location.`nThe download has been canceled
        return
       }
     }
    DownloadFolder := RegExReplace(DownloadFolder, "\\$")  ; Removes the trailing backslash, if present.
    FileGetAttrib, Attributes, %DownloadFolder%
    IfNotInString, Attributes, D
     {
      MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %DownloadFolder%`n`nPlease choose another location
      Goto ChooseDownloadFolder
     }
    IfExist,%DownloadFolder%\SavePictureAs.ahk
     {
      MsgBox 4132,Overwrite file?,SavePictureAs.ahk already exists in folder selected.`nOverwrite existing file?
      IfMsgBox No
       goto ChooseDownloadFolder
     }
    Counter = 0
    progress, B2 h80,,Downloading Update
    SetTimer,DownloadingUpdate,50
    UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs.ahk, %DownloadFolder%\SavePictureAs.ahk
    SetTimer,DownloadingUpdate,Off
    Progress,Off
    IfExist,%DownloadFolder%\SavePictureAs.ahk
     {
      MsgBox,64,Successful, SavePictureAs V%Newestversionnum% has successfully been downloaded to %DownloadFolder%
      return
     }
    Else
      MsgBox,16,Error, There seems to be a problem with the download. Please try again or visit http://www.autohotkey.com/forum/viewtopic.php?p=419104#419104 to download directly.
   return
   } ;ending brace for if A_IsCompiled <> 1
  Counter = 0
  progress, B2 h80,,Downloading Update
  SetTimer,DownloadingUpdate,50
  UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs.exe, SavePictureAs.exx
  UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs_Update.exe, SavePictureAs_Update.exe
  SetTimer,DownloadingUpdate,Off
  Progress,Off
  IfExist,SavePictureAs.exx
   {
    MsgBox,64,Successful, Update successfully downloaded.`nSavePictureAs will now restart and use the updated version.
    Run SavePictureAs_Update.exe
    exitapp
   }
  Else
    MsgBox,16,Error,There seems to be a problem with the download. Please try again or visit http://www.autohotkey.com/forum/viewtopic.php?p=419104#419104 to download directly.
 } ;bracket for If (Version < NewestVersionNum)
else
 {
  Gui 13: font, s12
  Gui 13: add, text,,You are using the newest version of SavePictureAs!
  Gui 13: add, text,x150,Version %version%
  Gui 13: add, button,x170 w50,OK
  Gui 13: show,w390,Update Check
  Gui 13: color, c0c0c0
  return
  13ButtonOK:   
  13GuiCancel:
  Gui 13: destroy
  return
 } ;else brace
  return
;==================================================Fix Text Length for Traytip======================================================
FixControlTextLength: ;fixes text length for system tray icon tray tip
VarSetCapacity( Shortp, 255 )
DllCall( "shlwapi.dll\PathCompactPathExA", Str,Shortp, Str,TextToControl, UInt,MaxChars )
TextToControl = %Shortp%
VarSetCapacity(Shortp, 0)
Return
VerifySpaconfigIniExists:
IfNotExist,spaconfig.ini ;create scripts main config file
  FileAppend,%spaconfigvar%,%A_ScriptDir%\spaconfig.ini
return
Quit:
if CancelSetup = 1
{
 blockinput, off
 exitapp
 return
}
Gosub VerifySpaconfigIniExists
WinGet, State,MinMax,ahk_id %ToolbarID% ;Don't save position if minimized 
if State > -1
IfWinExist,Toolbar ;position toolbar where it was last located on next use
  {
   WinGetPos,x,y,,,Toolbar 
   IniWrite, %x%,spaconfig.ini,ToolbarPos,ToolbarXpos
   IniWrite, %y%,spaconfig.ini,ToolbarPos,ToolbarYpos
  }
WinGet, State,MinMax,ahk_id %HistoryID%
if State > -1
IfWinExist, ahk_id %HistoryID%
{
 WinGetPos,x,y,,,ahk_id %HistoryID%
 IniWrite,%x%,spaconfig.ini,HistoryMenuPos,XPos
 IniWrite,%y%,spaconfig.ini,HistoryMenuPos,YPos
}   
blockinput, off
exitapp
;===================================================================================================================
CreateSpaConfigIni:
spaconfigvar =[CheckForUpdates]`nCheckForUpdates=Yes`n`n[SplashScreenStatus]`nShowSplashScreen=Enabled`n`n[FirstRun]`nShowAdminMessage=0`n`n[PromptForFilename]`nPromptForFilename=0`n`n[WaitforSavePictureAsWindow]`nTimeOutPeriod = 5`n`n[SystemColors]`nHistoryColorGuiVar= 8080ff`nHistoryColorListboxVar=C0C0C0`nHistoryColorGuiTextVar=000000`nHistoryColorListBoxTextVar=000000`nProgramDocumentationColorGuiVar= 8080ff`nProgramDocumentationColorListboxVar=C0C0C0`nProgramDocumentationColorListboxTextVar=000000`nSplashScreenColorGuiVar= 8080ff`nSplashScreenColorListBoxVar=C0C0C0`nSplashScreenColorListBoxTextVar=000000`nConfigureConfirmationMessageColorGuiVar= 8080ff`nProgramColorsMenuColorGuiVar=c0c0c0`nProgramColorsMenuColorGuiTextVar=000000`nFavoritesToolBarGuiVar= 8080ff`nConfigureFavoritesToolBarGuiVar=c0c0c0`nConfigureFavoritesToolBarGuiTextVar=000000`nAboutColorGuiVar=c0c0c0`nAboutColorGuiTextVar=000000`nHelpColorGuiVar=c0c0c0`nHelpColorGuiTextVar=000000`nResetAllDefaultsColorGuiVar= c0c0c0`nResetAllDefaultsColorGuiTextVar=000000`n`n[SplashScreen]`nStatus=Enabled`n`n[CurrentPath]`nPath=None Selected`n`n[ConfirmationMessage]`nConfirmationMessageStatus=ENABLED`nConfirmationMessageDelay=1000`nConfirmationMessageTextColor=000000`nConfirmationMessageWindowColor=8b8b8b`nConfirmationMessageXpos=410`nConfirmationMessageYpos=215`n`n[ToolbarPos]`nToolbarXpos=750`nToolbarYpos=20`n`n[HistoryMenuPos]`nXPos=`nYPos=`n`n[FavoritePaths]`n1=%A_PicturesSF%`n2=%A_Desktop%`n3=%A_PicturesSF%`n4=%A_MyDocuments%`n5=%A_PicturesSF%`n`n[History]`nHistoryValue=ENABLED`nHistory0=`nHistory1=`nHistory2=`nHistory3=`nHistory4=`nHistory5=`nHistory6=`nHistory7=`nHistory8=`nHistory9=`nHistory10=`nHistory11=`nHistory12=`nHistory13=`nHistory14=`nHistory15=`nHistory16=`nHistory17=`nHistory18=`nHistory19=`nHistory20=`nHistory21=`nHistory22=`nHistory23=`nHistory24=`nHistory25=`nHistory26=`nHistory27=`nHistory28=`nHistory29=`nHistory30=`n`n 
return
;=======================================================================================================================
CreateReadMeFirstTxt:
IfNotExist,%a_scriptdir%\ReadMeFirst.txt
  FileAppend,
  (
   This program was written with AutoHotkey, a GPLed open source scripting language, and includes AutoHotkey code needed to execute the program. Source code for AutoHotkey can be found at: www.autohotkey.com/download

SavePictureAs Version V%Version%
SavePictureAs does not install anything on your computer. It runs from the folder you place SavePictureAs.exe in. The first time you run SavePictureAs.exe you will be asked some setup questions. SavePictureAs.exe will create spaconfig.ini and spaimage.jpg in the current folder.
   
Spaimage.jpg is displayed on the History Menu when any other image is not displayed. Spaimage.jpg can be replaced with a picture of your choice. Just rename your picture to spaimage.jpg and place in the same folder as %SavePictureAs% is in. To restore the original spaimage.jpg just delete the current spaimage.jpg in the same folder as %SavePictureAs% and then rerun %savepictureas%. It will replace the missing file.

Spaconfig.ini is the main configuration file. If you would like to run setup again you can delete spaconfig.ini then run SavePictureAs.exe again. Keep in mind all user settings will be lost.. I.E Location to save pictures, menu colors, Favorite Toolbar settings ETC...

Program operation:
 1. Place the mouse cursor over any picture on a webpage. 
 2. Press the "ctrl and spacebar" keys to save the picture to your hard drive.
 3. Use the system tray icon to change the "Saved Picture Location" folder.
 4. You can change saved picture location, configure saved pictures Confirmation Message and enable/disable the splash screen     via the system tray menu items.
 5. Use the system tray menu item "History" to view, delete, copy and rename the last 30 saved pictures.
 6. Use the system tray icon to launch the Favorites Toolbar and configure up to five buttons to quickly change the saved         picture location.
 7. Use the system tray icon to launch menu to change screen and text colors.
 8. Exit the program by clicking the system tray icon.

SavePictureAs can save pictures using the following web browsers, and operating systems.
Internet Explorer
Firefox
Google Chrome
Opera

Windows WinXp
Windows Vista
Windows 7
Please report any suggestions, bugs or issues to savepictureas@hotmail.com
  ),%A_ScriptDir%\ReadMeFirst.txt
return
;===================================================================================================================================
;Functions
;Scrollable Gui
;Get Image Size
;Get right click menu contents
;Common dialog for changing Gui and font colors
;ScrollBar code thanks to Lexikos from http://www.autohotkey.com/forum/viewtopic.php?t=28496&start=0
;UrlDownloadToVar
#IfWinActive ahk_group MyGui
WheelUp::
WheelDown::
+WheelUp::
+WheelDown::    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, GetKeyState("Shift") ? 0x114 : 0x115, WinExist())
return
UpdateScrollBars(GuiNum, GuiWidth, GuiHeight)
 {
  static SIF_RANGE=0x1, SIF_PAGE=0x2, SIF_DISABLENOSCROLL=0x8, SB_HORZ=0, SB_VERT=1
  Gui, %GuiNum%:Default
  Gui, +LastFound
 ; Calculate scrolling area.
  Left := Top := 9999
  Right := Bottom := 0
  WinGet, ControlList, ControlList
  Loop, Parse, ControlList, `n
   {
    GuiControlGet, c, Pos, %A_LoopField%
    if (cX < Left)
     Left := cX
    if (cY < Top)
     Top := cY
    if (cX + cW > Right)
     Right := cX + cW
    if (cY + cH > Bottom)
     Bottom := cY + cH
   }
  Left -= 8
  Top -= 8
  Right += 8
  Bottom += 8
  ScrollWidth := Right-Left
  ScrollHeight := Bottom-Top
 
  ; Initialize SCROLLINFO.
  VarSetCapacity(si, 28, 0)
  NumPut(28, si) ; cbSize
  NumPut(SIF_RANGE | SIF_PAGE, si, 4) ; fMask
  ; Update horizontal scroll bar.
  NumPut(ScrollWidth, si, 12) ; nMax
  NumPut(GuiWidth, si, 16) ; nPage
  DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_HORZ, "uint", &si, "int", 1)
  
  ; Update vertical scroll bar.
  ; NumPut(SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, si, 4) ; fMask
  NumPut(ScrollHeight, si, 12) ; nMax
  NumPut(GuiHeight, si, 16) ; nPage
  DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_VERT, "uint", &si, "int", 1)
  if (Left < 0 && Right < GuiWidth)
   x := Abs(Left) > GuiWidth-Right ? GuiWidth-Right : Abs(Left)
  if (Top < 0 && Bottom < GuiHeight)
   y := Abs(Top) > GuiHeight-Bottom ? GuiHeight-Bottom : Abs(Top)
  if (x || y)
   DllCall("ScrollWindow", "uint", WinExist(), "int", x, "int", y, "uint", 0, "uint", 0)
 }
OnScroll(wParam, lParam, msg, hwnd)
 {
  static SIF_ALL=0x17, SCROLL_STEP=10
  bar := msg=0x115 ; SB_HORZ=0, SB_VERT=1
  VarSetCapacity(si, 28, 0)
  NumPut(28, si) ; cbSize
  NumPut(SIF_ALL, si, 4) ; fMask
  if !DllCall("GetScrollInfo", "uint", hwnd, "int", bar, "uint", &si)
   return
  VarSetCapacity(rect, 16)
  DllCall("GetClientRect", "uint", hwnd, "uint", &rect)
  new_pos := NumGet(si, 20) ; nPos
  action := wParam & 0xFFFF
  if action = 0 ; SB_LINEUP
   new_pos -= SCROLL_STEP
  else if action = 1 ; SB_LINEDOWN
   new_pos += SCROLL_STEP
  else if action = 2 ; SB_PAGEUP
   new_pos -= NumGet(rect, 12, "int") - SCROLL_STEP
  else if action = 3 ; SB_PAGEDOWN
   new_pos += NumGet(rect, 12, "int") - SCROLL_STEP
  else if action = 5 ; SB_THUMBTRACK
   new_pos := NumGet(si, 24, "int") ; nTrackPos
  else if action = 6 ; SB_TOP
   new_pos := NumGet(si, 8, "int") ; nMin
  else if action = 7 ; SB_BOTTOM
   new_pos := NumGet(si, 12, "int") ; nMax
  else
   return
  min := NumGet(si, 8, "int") ; nMin
  max := NumGet(si, 12, "int") - NumGet(si, 16) ; nMax-nPage
  new_pos := new_pos > max ? max : new_pos
  new_pos := new_pos < min ? min : new_pos
  old_pos := NumGet(si, 20, "int") ; nPos
  x := y := 0
  if bar = 0 ; SB_HORZ
   x := old_pos-new_pos
  else
   y := old_pos-new_pos
  
  ; Scroll contents of window and invalidate uncovered area.
  DllCall("ScrollWindow", "uint", hwnd, "int", x, "int", y, "uint", 0, "uint", 0)
  
  ; Update scroll bar.
  NumPut(new_pos, si, 20, "int") ; nPos
  DllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", &si, "int", 1)
 }
;GetImageSize code from Lexikos at http://www.autohotkey.com/forum/viewtopic.php?t=28334&highlight=imagedata
ImageData_Load(ByRef ImageData, ImageFile)
{
    static PixelFormat32bppARGB = 0x26200a
         , ImageLockModeRead = 0x1
         , ImageLockModeUserInputBuf = 0x4
   
    ; Initialize GDI+. Doing this here rather than at script
    ; startup is more convenient, at the cost of ~15ms.
    VarSetCapacity(GdiplusStartupInput, 16, 0), NumPut(1, GdiplusStartupInput)
    GdiplusModule := DllCall("LoadLibrary", "str", "Gdiplus")
    if GdiplusModule = 0
        return false, ErrorLevel:="GDIPLUS NOT FOUND"
    r := DllCall("Gdiplus\GdiplusStartup", "uint*", GdipToken, "uint", &GdiplusStartupInput, "uint", 0)
    if r != 0
        return false, ErrorLevel:=r
   
    ; Convert the filename to a unicode string.
    VarSetCapacity(wImageFile, StrLen(ImageFile)*2+1)
    DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "str", ImageFile, "int", -1, "uint", &wImageFile, "int", StrLen(ImageFile)+1)
    ; Load the image.
    r := DllCall("Gdiplus\GdipCreateBitmapFromFile", "uint", &wImageFile, "uint*", bitmap)
   
    if r != 0
        return false, ErrorLevel:=r
   
    ; Get the image's size.
    DllCall("Gdiplus\GdipGetImageWidth", "uint", bitmap, "uint*", width)
    DllCall("Gdiplus\GdipGetImageHeight", "uint", bitmap, "uint*", height)
   
    ; Make room for a BitmapData structure and the image data.
    VarSetCapacity(ImageData, 24 + width * height * 4, 0)
   
    ; Fill the BitmapData structure with details of the desired image format.
    NumPut(width, ImageData, 0, "UInt")
    NumPut(height, ImageData, 4, "UInt")
    NumPut(width * 4, ImageData, 8, "Int") ; Stride
    NumPut(PixelFormat32bppARGB, ImageData, 12, "Int") ; PixelFormat
    NumPut(&ImageData + 24, ImageData, 16, "UInt") ; Scan0
   
    ; Rect specifies the image region to lock.
    VarSetCapacity(rect, 16, 0)
    NumPut(width, rect, 8)
    NumPut(height, rect, 12)
   
    ; Lock the image and fill ImageData.
    r := DllCall("Gdiplus\GdipBitmapLockBits"
        , "uint", bitmap
        , "uint", &rect
        , "uint", ImageLockModeRead | ImageLockModeUserInputBuf
        ,  "int", PixelFormat32bppARGB
        , "uint", &ImageData)
   
    if r = 0 ; Status.Ok
    {
        ; "LockBits and UnlockBits must be used as a pair."
        DllCall("Gdiplus\GdipBitmapUnlockBits", "uint", bitmap, "uint", &ImageData)
    }
   
    ; Delete the bitmap (image in memory).
    DllCall("Gdiplus\GdipDisposeImage", "uint", bitmap)
   
    ; Uninitialize GDI+.
    DllCall("Gdiplus\GdiplusShutdown", "uint", GdipToken)
    DllCall("FreeLibrary", "uint", GdiplusModule)
   
    return r=0, ErrorLevel:=r
}
ImageData_GetSize(ByRef ImageData, ByRef Width, ByRef Height)
{
    Width := NumGet(ImageData, 0)
    Height := NumGet(ImageData, 4)
}
return
CheckWindowContents:
sleep 200 ;give the right click menu a little time to open. May not need this here because of winwait below, but doesn't hurt to keep here.
count = 0
SetBatchLines, -1
WinWait, ahk_class #32768, ,  5 
SendMessage, 0x1E1, 0, 0      ; MN_GETHMENU
hMenu := ErrorLevel
sContents := GetMenu(hMenu)
;need to change code to If sContents not in Save Picture As, Sa&ve Image As  //then test 
IfInString,sContents,Save Picture As ;IE ;does not work with firefox or opera
 count = 1
IfInString,Scontents, Sa&ve Image As ;Chrome  I think in winxp it shows  ;does not work with firefox or opera
 count = 1
If count = 0
 {
  blockinput, off
  MsgBox, 262160, SavePictureAs V%Version% Error Message, Ctrl+Space keys have been pressed. This may not be saveable picture. If you are sure this is a saveable picture, try to save it again. Some pictures are protected from download by the website creator.
  goto end ;return will not work here, it returns back to next line after Gosub CheckWindowContents. I need it to skip any code after Gosub CheckWindowContents
 }
return
GetMenu(hMenu) ;code by Sean from http://www.autohotkey.com/forum/viewtopic.php?t=21451&start=0
{
   Loop, % DllCall("GetMenuItemCount", "Uint", hMenu)
   {
      idx := A_Index - 1
      idn := DllCall("GetMenuItemID", "Uint", hMenu, "int", idx)
      nSize++ := DllCall("GetMenuString", "Uint", hMenu, "int", idx, "Uint", 0, "int", 0, "Uint", 0x400)
      VarSetCapacity(sString, nSize)
      DllCall("GetMenuString", "Uint", hMenu, "int", idx, "str", sString, "int", nSize, "Uint", 0x400)   ;MF_BYPOSITION
      If !sString
         sString := "---------------------------------------"
      sContents .= idx . " : " . idn . A_Tab . A_Tab . sString . "`n"
      If (idn = -1) && (hSubMenu := DllCall("GetSubMenu", "Uint", hMenu, "int", idx))
         sContents .= GetMenu(hSubMenu)
   }
   Return   sContents
}
;color function returns user choice in var color
;usage   CmnDlg_Color( color:=0000FF)
CmnDlg_Color(ByRef pColor, hGui=0){ 
  ;covert from rgb
    clr := ((pColor & 0xFF) << 16) + (pColor & 0xFF00) + ((pColor >> 16) & 0xFF) 
    VarSetCapacity(sCHOOSECOLOR, 0x24, 0) 
    VarSetCapacity(aChooseColor, 64, 0) 
    NumPut(0x24,		 sCHOOSECOLOR, 0)      ; DWORD lStructSize 
    NumPut(hGui,		 sCHOOSECOLOR, 4)      ; HWND hwndOwner (makes dialog "modal"). 
    NumPut(clr,			 sCHOOSECOLOR, 12)     ; clr.rgbResult 
    NumPut(&aChooseColor,sCHOOSECOLOR, 16)     ; COLORREF *lpCustColors 
    NumPut(0x00000103,	 sCHOOSECOLOR, 20)     ; Flag: CC_ANYCOLOR || CC_RGBINIT 
    nRC := DllCall("comdlg32\ChooseColorA", str, sCHOOSECOLOR)  ; Display the dialog. 
    if (errorlevel <> 0) || (nRC = 0) 
       return  false 
  
    clr := NumGet(sCHOOSECOLOR, 12) 
    
    oldFormat := A_FormatInteger 
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format. 
 ;convert to rgb 
    pColor := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16) 
    StringTrimLeft, pColor, pColor, 2 
    loop, % 6-strlen(pColor) 
		pColor=0%pColor% 
    pColor=0x%pColor% 
    SetFormat, integer, %oldFormat% 
	return true
}
;Attach.ahk by majkinetor
/*
	Function:		Attach
					Determines how a control is resized with its parent.

	hCtrl:			
					- hWnd of the control if aDef is not empty.					
					- hWnd of the parent to be reset if aDef is empty. If you omit this parameter function will use
					the first hWnd passed to it.
					With multiple parents you need to specify which one you want to reset.					
					- Handler name, if parameter is string and aDef is empty. Handler will be called after the function has finished 
					moving controls for the parent. Handler receives hWnd of the parent as its only argument.

	aDef:			
					Attach definition string. Space separated list of attach options. If omitted, function working depends on hCtrl parameter.
					You can use following elements in the definition string:
					
					- 	"x,y,w,h" letters along with coefficients, decimal numbers which can also be specified in m/n form (see example below).
					-   "r". Use "r1" (or "r") option to redraw control immediately after repositioning, set "r2" to delay redrawing 100ms for the control
						(prevents redrawing spam).
					-	"p" (for "proportional") is the special coefficient. It will make control's dimension always stay in the same proportion to its parent 
						(so, pin the control to the parent). Although you can mix pinned and non-pinned controls and dimensions that is rarely what you want. 
						You will generally want to pin every control in the parent.
					-	"+" or "-" enable or disable function for the control. If control is hidden, you may want to disable the function for 
						performance reasons, especially if control is container attaching its children. Its perfectly OK to leave invisible controls 
						attached, but if you have lots of them you can use this feature to get faster and more responsive updates. 
						When you want to show disabled hidden control, make sure you first attach it back so it can take its correct position
						and size while in hidden state, then show it. "+" must be used alone while "-" can be used either alone or in Attach definition string
						to set up control as initially disabled.

	Remarks:
					Function monitors WM_SIZE message to detect parent changes. That means that it can be used with other eventual container controls
					and not only top level windows.

					You should reset the function when you programmatically change the position of the controls in the parent control.
					Depending on how you created your GUI, you might need to put "autosize" when showing it, otherwise resetting the Gui before its 
					placement is changed will not work as intented. Autosize will make sure that WM_SIZE handler fires. Sometimes, however, WM_SIZE
					message isn't sent to the window. One example is for instance when some control requires Gui size to be set in advance in which case
					you would first have "Gui, Show, w100 h100 Hide" line prior to adding controls, and only Gui, Show after controls are added. This
					case will not trigger WM_SIZE message unless AutoSize is added.
				
				
	Examples:
	(start code)
					Attach(h, "w.5 h1/3 r2")	;Attach control's w, h and redraw it with delay.
					Attach(h, "-")				;Disable function for control h but keep its definition. To enable it latter use "+".
					Attach(h, "- w.5")			;Make attach definition for control but do not attach it until you call Attach(h, "+").
					Attach()					;Reset first parent. Use when you have only 1 parent.
					Attach(hGui2)				;Reset Gui2.
					Attach("Win_Redraw")		;Use Win_Redraw function as a Handler. Attach will call it with parent's handle as argument.
					Attach(h, "p r2")			;Pin control with delayed refreshing.

					
					; This is how to do delayed refresh of entire window.
					; To prevent redraw spam which can be annoying in some cases, 
					; you can choose to redraw entire window only when user has finished resizing it.
					; This is similar to r2 option for controls, except it works with entire parent.
					
					Attach("OnAttach")			;Set Handler to OnAttach function
					...
					
					OnAttach( Hwnd ) {
						global hGuiToRedraw := hwnd
						SetTimer, Redraw, -100
					}

					Redraw:
						Win_Redraw(hGuiToRedraw)
					return
	(end code)
	Working sample:
	(start code)
		#SingleInstance, force
			Gui, +Resize
			Gui, Add, Edit, HWNDhe1 w150 h100
			Gui, Add, Picture, HWNDhe2 w100 x+5 h100, pic.bmp 

			Gui, Add, Edit, HWNDhe3 w100 xm h100
			Gui, Add, Edit, HWNDhe4 w100 x+5 h100
			Gui, Add, Edit, HWNDhe5 w100 yp x+5 h100
			
			gosub SetAttach					;comment this line to disable Attach
			Gui, Show, autosize			
		return

		SetAttach:
			Attach(he1, "w.5 h")		
			Attach(he2, "x.5 w.5 h r")
			Attach(he3, "y w1/3")
			Attach(he4, "y x1/3 w1/3")
			Attach(he5, "y x2/3 w1/3")
		return
	(end code)

	About:
			o 1.1 by majkinetor
			o Licensed under BSD <http://creativecommons.org/licenses/BSD/> 
 */
Attach(hCtrl="", aDef="") {
	 Attach_(hCtrl, aDef, "", "")
}

Attach_(hCtrl, aDef, Msg, hParent){
	static
	local s1,s2, enable, reset, oldCritical

	if (aDef = "") {							;Reset if integer, Handler if string
		if IsFunc(hCtrl)
			return Handler := hCtrl
	
		ifEqual, adrWindowInfo,, return			;Resetting prior to adding any control just returns.
		hParent := hCtrl != "" ? hCtrl+0 : hGui
		loop, parse, %hParent%a, %A_Space%
		{
			hCtrl := A_LoopField, SubStr(%hCtrl%,1,1), aDef := SubStr(%hCtrl%,1,1)="-" ? SubStr(%hCtrl%,2) : %hCtrl%,  %hCtrl% := ""
			gosub Attach_GetPos
			loop, parse, aDef, %A_Space%
			{
				StringSplit, z, A_LoopField, :
				%hCtrl% .= A_LoopField="r" ? "r " : (z1 ":" z2 ":" c%z1% " ")
			}
			%hCtrl% := SubStr(%hCtrl%, 1, -1)				
		}
		reset := 1,  %hParent%_s := %hParent%_pw " " %hParent%_ph
	}

	if (hParent = "")  {						;Initialize controls 
		if !adrSetWindowPos
			adrSetWindowPos		:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "user32"), A_IsUnicode ? "astr" : "str", "SetWindowPos")
			,adrWindowInfo		:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "user32"), A_IsUnicode ? "astr" : "str", "GetWindowInfo")
			,OnMessage(5, A_ThisFunc),	VarSetCapacity(B, 60), NumPut(60, B), adrB := &B
			,hGui := DllCall("GetParent", "uint", hCtrl, "Uint") 

		hParent := DllCall("GetParent", "uint", hCtrl, "Uint") 
		
		if !%hParent%_s
			DllCall(adrWindowInfo, "uint", hParent, "uint", adrB), %hParent%_pw := NumGet(B, 28) - NumGet(B, 20), %hParent%_ph := NumGet(B, 32) - NumGet(B, 24), %hParent%_s := !%hParent%_pw || !%hParent%_ph ? "" : %hParent%_pw " " %hParent%_ph
		
		if InStr(" " aDef " ", "p")
			StringReplace, aDef, aDef, p, xp yp wp hp
		ifEqual, aDef, -, return SubStr(%hCtrl%,1,1) != "-" ? %hCtrl% := "-" %hCtrl% : 
		else if (aDef = "+")
			if SubStr(%hCtrl%,1,1) != "-" 
				 return
			else %hCtrl% := SubStr(%hCtrl%, 2), enable := 1 
		else {
			gosub Attach_GetPos
			%hCtrl% := ""
			loop, parse, aDef, %A_Space%
			{			
				if (l := A_LoopField) = "-"	{
					%hCtrl% := "-" %hCtrl%
					continue
				}
				f := SubStr(l,1,1), k := StrLen(l)=1 ? 1 : SubStr(l,2)
				if (j := InStr(l, "/"))
					k := SubStr(l, 2, j-2) / SubStr(l, j+1)
				%hCtrl% .= f ":" k ":" c%f% " "
			}
 			return %hCtrl% := SubStr(%hCtrl%, 1, -1), %hParent%a .= InStr(%hParent%, hCtrl) ? "" : (%hParent%a = "" ? "" : " ")  hCtrl 
		}
	}
	ifEqual, %hParent%a,, return				;return if nothing to anchor.

	if !reset && !enable {					
		%hParent%_pw := aDef & 0xFFFF, %hParent%_ph := aDef >> 16
		ifEqual, %hParent%_ph, 0, return		;when u create gui without any control, it will send message with height=0 and scramble the controls ....
	} 

	if !%hParent%_s
		%hParent%_s := %hParent%_pw " " %hParent%_ph

	oldCritical := A_IsCritical
	critical, 5000

	StringSplit, s, %hParent%_s, %A_Space%
	loop, parse, %hParent%a, %A_Space%
	{
		hCtrl := A_LoopField, aDef := %hCtrl%, 	uw := uh := ux := uy := r := 0, hCtrl1 := SubStr(%hCtrl%,1,1)
		if (hCtrl1 = "-")
			ifEqual, reset,, continue
			else aDef := SubStr(aDef, 2)	
		
		gosub Attach_GetPos
		loop, parse, aDef, %A_Space%
		{
			StringSplit, z, A_LoopField, :		; opt:coef:initial
			ifEqual, z1, r, SetEnv, r, %z2%
			if z2=p
				 c%z1% := z3 * (z1="x" || z1="w" ?  %hParent%_pw/s1 : %hParent%_ph/s2), u%z1% := true
			else c%z1% := z3 + z2*(z1="x" || z1="w" ?  %hParent%_pw-s1 : %hParent%_ph-s2), 	u%z1% := true
		}
		flag := 4 | (r=1 ? 0x100 : 0) | (uw OR uh ? 0 : 1) | (ux OR uy ? 0 : 2)			; nozorder=4 nocopybits=0x100 SWP_NOSIZE=1 SWP_NOMOVE=2
		;m(hParent, %hParent%a, hCtrl, %hCTRL%)
		DllCall(adrSetWindowPos, "uint", hCtrl, "uint", 0, "uint", cx, "uint", cy, "uint", cw, "uint", ch, "uint", flag)
		r+0=2 ? Attach_redrawDelayed(hCtrl) : 
	}
	critical %oldCritical%
	return Handler != "" ? %Handler%(hParent) : ""

 Attach_GetPos:									;hParent & hCtrl must be set up at this point
		DllCall(adrWindowInfo, "uint", hParent, "uint", adrB), 	lx := NumGet(B, 20), ly := NumGet(B, 24), DllCall(adrWindowInfo, "uint", hCtrl, "uint", adrB)
		,cx :=NumGet(B, 4),	cy := NumGet(B, 8), cw := NumGet(B, 12)-cx, ch := NumGet(B, 16)-cy, cx-=lx, cy-=ly
 return
}

Attach_redrawDelayed(hCtrl){
	static s
	s .= !InStr(s, hCtrl) ? hCtrl " " : ""
	SetTimer, %A_ThisFunc%, -100
	return
 Attach_redrawDelayed:
	loop, parse, s, %A_Space%
		WinSet, Redraw, , ahk_id %A_LoopField%
	s := ""
 return
}

UrlDownloadToVar(URL, Proxy="", ProxyBypass="")
{
AutoTrim, Off
hModule := DllCall("LoadLibrary", "str", "wininet.dll")

If (Proxy != "")
AccessType=3
Else
AccessType=1
;INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
;INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
;INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
;INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS

io_hInternet := DllCall("wininet\InternetOpenA"
, "str", "" ;lpszAgent
, "uint", AccessType
, "str", Proxy
, "str", ProxyBypass
, "uint", 0) ;dwFlags

iou := DllCall("wininet\InternetOpenUrlA"
, "uint", io_hInternet
, "str", url
, "str", "" ;lpszHeaders
, "uint", 0 ;dwHeadersLength
, "uint", 0x80000000 ;dwFlags: INTERNET_FLAG_RELOAD = 0x80000000 // retrieve the original item
, "uint", 0) ;dwContext

If (ErrorLevel != 0 or iou = 0) {
DllCall("FreeLibrary", "uint", hModule)
return 0
}

VarSetCapacity(buffer, 512, 0)
VarSetCapacity(NumberOfBytesRead, 4, 0)
Loop
{
  irf := DllCall("wininet\InternetReadFile", "uint", iou, "uint", &buffer, "uint", 512, "uint", &NumberOfBytesRead)
  NOBR = 0
  Loop 4  ; Build the integer by adding up its bytes. - ExtractInteger
    NOBR += *(&NumberOfBytesRead + A_Index-1) << 8*(A_Index-1)
  IfEqual, NOBR, 0, break
  ;BytesReadTotal += NOBR
  DllCall("lstrcpy", "str", buffer, "uint", &buffer)
  res = %res%%buffer%
}
;StringTrimRight, res, res, 2

DllCall("wininet\InternetCloseHandle",  "uint", iou)
DllCall("wininet\InternetCloseHandle",  "uint", io_hInternet)
DllCall("FreeLibrary", "uint", hModule)
AutoTrim, on
return, res
}

FtpSetCurrentDirectory(DirName) {
global ic_hInternet
r := DllCall("wininet\FtpSetCurrentDirectoryA", "uint", ic_hInternet, "str", DirName)
If (ErrorLevel != 0 or r = 0)
return 0
else
return 1
}

FtpPutFile(LocalFile, NewRemoteFile="", Flags=0) {
If NewRemoteFile=
NewRemoteFile := LocalFile
global ic_hInternet
r := DllCall("wininet\FtpPutFileA"
, "uint", ic_hInternet
, "str", LocalFile
, "str", NewRemoteFile
, "uint", Flags
, "uint", 0) ;dwContext
If (ErrorLevel != 0 or r = 0)
return 0
else
return 1
}

FtpOpen(Server, Port=21, Username=0, Password=0 ,Proxy="", ProxyBypass="") {
IfEqual, Username, 0, SetEnv, Username, anonymous
IfEqual, Password, 0, SetEnv, Password, anonymous

If (Proxy != "")
AccessType=3
Else
AccessType=1
global ic_hInternet, io_hInternet, hModule
hModule := DllCall("LoadLibrary", "str", "wininet.dll")

io_hInternet := DllCall("wininet\InternetOpenA"
, "str", A_ScriptName ;lpszAgent
, "UInt", AccessType
, "str", Proxy
, "str", ProxyBypass
, "UInt", 0) ;dwFlags

If (ErrorLevel != 0 or io_hInternet = 0) {
FtpClose()
return 0
}

ic_hInternet := DllCall("wininet\InternetConnectA"
, "uint", io_hInternet
, "str", Server
, "uint", Port
, "str", Username
, "str", Password
, "uint" , 1 ;dwService (INTERNET_SERVICE_FTP = 1)
, "uint", 0 ;dwFlags
, "uint", 0) ;dwContext

If (ErrorLevel != 0 or ic_hInternet = 0)
return 0
else
return 1
}

FtpClose() {
global ic_hInternet, io_hInternet, hModule
DllCall("wininet\InternetCloseHandle",  "UInt", ic_hInternet)
DllCall("wininet\InternetCloseHandle",  "UInt", io_hInternet)
DllCall("FreeLibrary", "UInt", hModule)
}
return
CheckForUpdates:
NewestVersionNum:= UrlDownloadToVar("http://www.autohotkey.net/~DataLife/SavePictureAs_version.txt")
if (NewestVersionNum = 0 or NewestVersionNum = "")
 {
  TrayTip,Error-SavePictureAs,There was a problem checking for updates. Make sure you are connected to the internet and try again.,30
  return
 }
If (Version < NewestVersionNum)
   {
    Changes := UrlDownloadToVar("http://www.autohotkey.net/~DataLife/SavePictureAs-changes.txt")
    if changes =
     Changes = Not able to retrieve the necessary information.
    Gui 11: font, s12 italic underline cBlue,
    Gui 11: add, text, gViewChanges1,View Changes
    Gui 11: font, norm cBlack
	Gui 11: add, text,,You are currently using an out of date version of SavePictureAs.`n`nCurrent version %Version%`nNewest version %newestversionnum%`n`nWould you like to update to the newest version?
    Gui 11: add, button,   x20  y+15 w80 h25, No
    Gui 11: add, button,   x+20 yp-0 w80 h25, Yes
	Gui 11: font, s10
	Gui 11: add, checkbox, x10  y+15 VUpdateChoice,Do not check for updates when program starts
    Gui 11: show,,Update Check 
    Gui 11: color, c0c0c0
    Loop
     {
      if StillSleeping <> 0 ;a return here causes the script to go back to where it came from and continue with the script.
       sleep 1              ;I need the script to wait here until Checking for Updates is finished
      else
       break
     }
    11GuiCancel:
    Gui 11: destroy
    StillSleeping = 0
    return
    ViewChanges1:
    MsgBox, 4160, SavePictureAs V%version%,%Changes%
    return        
    11ButtonNo:
    Gui 11: Submit
    if UpdateChoice = 1
     UpdateChoice = No
    else
     UpdateChoice = yes
    IfExist,spaconfig.ini
     iniwrite, %UpdateChoice%, spaconfig.ini,CheckForUpdates,CheckForUpdates
    else
     iniwrite, %UpdateChoice%, spaconfig2.ini,CheckForUpdates,CheckForUpdates
    StillSleeping = 0
    Gui 11: destroy
    return
      
    11ButtonYes:
    Gui 11: Submit
    if UpdateChoice = 1
     UpdateChoice = No
    else
     UpdateChoice = yes
    IfExist,spaconfig.ini
     iniwrite, %UpdateChoice%, spaconfig.ini,CheckForUpdates,CheckForUpdates
    else
     iniwrite, %UpdateChoice%, spaconfig2.ini,CheckForUpdates,CheckForUpdates
    StillSleeping = 0
    Gui 11: destroy
    if A_IsCompiled <> 1
     {
      ChooseDownloadLocation:
      FileSelectFolder, DownloadFolder, *%A_MyDocuments%, 3, SavePictureAs current version %Version% `n`nSelect a folder to download Save Picture As V%NewestVersionNum% to.  
      if errorlevel  = 1
       {
        Msgbox, 8228,SavePictureAs V%Version%,You have not selected a valid location to save your file.`n`nDo you want to select a location now?
        IfMsgBox Yes
         Goto ChooseDownloadLocation
        IfMsgBox no
         {
          msgbox, 8256,Information, You have not chosen a valid location.`nThe download has been canceled
          return
         }
       }
      DownloadFolder := RegExReplace(DownloadFolder, "\\$")  ; Removes the trailing backslash, if present.
      FileGetAttrib, Attributes, %DownloadFolder%
      IfNotInString, Attributes, D
       {
        MsgBox, 262160, SavePictureAs V%Version%,You have not chosen a valid folder. %DownloadFolder%`n`nPlease choose another location
        Goto ChooseDownloadLocation
       }
      IfExist,%DownloadFolder%\SavePictureAs.ahk
       {
        MsgBox 4132,Overwrite file?,SavePictureAs.ahk already exists in folder selected.`nOverwrite existing file?
        IfMsgBox No
         goto ChooseDownloadLocation
       }
      Counter = 0
      progress, B2 h80,,Downloading Update
      SetTimer,DownloadingUpdate,50
      UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs.ahk, %DownloadFolder%\SavePictureAs.ahk
      SetTimer,DownloadingUpdate,Off
      Progress,Off
      IfExist,%DownloadFolder%\SavePictureAs.ahk
       {
        MsgBox,64,Successful, SavePictureAs V%Newestversionnum% has successfully been downloaded to %DownloadFolder%
        return
       }
      Else
       {
        MsgBox,16,Error, There seems to be a problem with the download. Please try again or visit http://www.autohotkey.com/forum/viewtopic.php?p=419104#419104 to download directly.
       }
      return
     } ;ending brace for if A_IsCompiled <> 1
    Counter = 0
    progress, B2 h80,,Downloading Update
    SetTimer,DownloadingUpdate,50
    UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs.exe, SavePictureAs.exx
    UrlDownloadToFile, http://www.autohotkey.net/~DataLife/SavePictureAs_Update.exe, SavePictureAs_Update.exe
    SetTimer,DownloadingUpdate,Off
    Progress,Off
    IfExist,SavePictureAs.exx
     {
      MsgBox,64,Successful, Update successfully downloaded.`nSavePictureAs will now restart and use the updated version.
      Run SavePictureAs_Update.exe
      exitapp
     }
    Else
     MsgBox,16,Error, There seems to be a problem with the download. Please try again or visit http://www.autohotkey.com/forum/viewtopic.php?p=419104#419104 to download directly.
   } ;bracket for If (Version < NewestVersionNum)
  else
   {
    TrayTip,Save Picture As V%version%,You are using the latest version,5,17
    SetTimer,CloseToolTip,250
   }
return
CloseToolTip:
Sleep 3000
Traytip
SetTimer,CloseToolTip,off
return
DownloadingUpdate: ;progress bar only
Counter++
if A_IsCompiled <> 1
 Ext = ahk
else
 Ext = exx
FileReadLine OutputVar, SavePictureAs.%Ext%, 1 ;this causes the filesize to update in windows explorer
FileGetSize,Size,SavePictureAs.%Ext%,K
progress,%Counter%,%Size%K of %FileSize%K ,Downloading Update
if counter > 100
 counter = 0
return
end: ;needed for CheckWindowContents: label
