; Seek -- by Phi
; http://www.autohotkey.com
; Navigating the Start Menu can be a hassle, especially
; if you have installed many programs over time. 'Seek'
; lets you specify a case-insensitive key word/phrase
; that it will use to filter only the matching programs
; and directories from the Start Menu, so that you can
; easily open your target program from a handful of
; matched entries. This eliminates the drudgery of
; searching and traversing the Start Menu.

;*****************************************************************
;
;  Program : Seek
;  Coder   : Phi
;  Updated : Mon Jan 31 10:08:37 2005
;
;  What do you seek, my friend?
;
;*****************************************************************
;
;  I have a lot of fun coding this, and hope you will
;  enjoy using it too. Feel free to drop me an email with
;  your comments and feedback at: phi1618 (*a.t*) gmail
;  :D0T: com.
;
;  Options:
;    -cache Use the cached directory-listing if available
;           (this is the default mode when no option is specified)
;    -scan  Force a directory scan to retrieve the latest
;           directory listing
;    -scex  Scan & exit (this is useful for scheduling the
;           potentially time-consuming directory-scanning as
;           a background job)
;    -help  Show this help
;
;*****************************************************************
;
; HOW TO 'SEEK':
;
; 1. 'Seek' is an AutoHotkey script. You can either run it
;    as Seek.ahk (original script) or Seek.exe (compiled
;    executable).
;
;    To obtain Seek.exe, you can download Seek.zip (includes
;    both the source code and the compiled binary) from
;    http://home.ripway.com/2004-10/188589/
;    Otherwise, you can compile Seek.ahk on your own by
;    using AutoHotkey's Ahk2Exe.exe compiler, or you can
;    ask me for a copy via email. The filesize is small at
;    about 200 kbytes. I can be reached at: phi1618 (*a.t*)
;    gmail :D0T: com.
;
;    To use Seek.ahk, first, you'll need to install
;    AutoHotkey v1.0.25 or higher on your PC (download from
;    http://www.autohotkey.com). Next, run the command:
;
;    X:\myTools\AutoHotkey\AutoHotkey.exe Y:\myAHK\Seek.ahk
;
;    Remember to replace X:\myTools and Y:\myAHK with
;    the proper directory names on your PC.
;
; 2. You can place the executable Seek.exe anywhere you
;    want. There is no installation required, it doesn't
;    write anything to your registry, and it doesn't
;    access the Internet at all (no phoning home). To
;    uninstall, simply delete Seek.exe.
;
;    The only 2 files 'Seek' creates are placed in your
;    TMP directory:
;
;      a. _Seek.key  (cache file for last query string)
;      b. _Seek.list (cache file for directory listing)
;
;    If you're a purist, you can delete them manually
;    when you decide to remove 'Seek' from your system.
;
; 3. The most convenient way to run 'Seek' is via a
;    shortcut/hotkey. If you are not already using any
;    hotkey management program on your PC, I highly
;    recommend AutoHotkey. If you don't intend to install
;    any hotkey management program at the moment, you can
;    make use of Windows shortcut feature and bind a
;    shortcut key (e.g. ALT-F1) to launch 'Seek'. This is
;    important so that you can run 'Seek' at anytime and
;    anywhere.
;
; 4. When you run 'Seek' for the first time, it'll scan
;    your Start Menu, and save the directory listing into
;    a cache file.
;
;    The following directories are included in the scanning:
;    - %A_StartMenu%
;    - %A_StartMenuCommon%
;
;    By default, subsequent runs will read from the
;    cache file so as to reduce the loading time. For
;    more info on options, run 'Seek.exe -help'. If you
;    think your Start Menu doesn't contain too many
;    programs, you can choose not to use the cache and
;    instruct 'Seek' to always do a directory scan (via
;    option -scan).  That way, you will always get the
;    latest listing.
;
; 5. When you run 'Seek', a window will appear, waiting
;    for you to enter a key word/phrase. After you have
;    entered a query string, a list of matching records
;    will be displayed. Next, you need to highlight an
;    entry and press <Enter> or click on the 'Open'
;    button to run the selected program or open the
;    selected directory.
;
;*****************************************************************
;
; TECHNICAL NOTES:
;
; - 'Seek' requires Chris Mallett's AutoHotkey v1.0.25
;   or higher version (http://www.autohotkey.com).
;   Thanks to Chris for his great work on AutoHotkey. :)
;
; - The following environment variables must be valid:
;   a. TMP
;
;*****************************************************************
;
; KNOWN PROBLEMS:
;
; - Nil
;
;*****************************************************************
;
; IMPLEMENTED SUGGESTIONS:
;
; - Highlight 1st matching record by default so that
;   user can just hit <Enter> to run it.
;   (Suggested by Yih Yeong)
;
; - Enable double-click on the listing of the search
;   results to launch the program.
;   (Suggested by Yih Yeong & Jack)
;
; - Auto real-time incremental search.
;   (Suggested by Rajat)
;
; - Fuzzy search when user enters multiple query strings,
;   separated by space.
;   (Suggested by Rajat)
;
;*****************************************************************
;
; SUGGESTED FEATURES (MAY OR MAY NOT BE IMPLEMENTED):
;
; - Log the launch history. List the most frequently
;   used programs at the top of the search results.
;   (Suggested by Yih Yeong)
;
; - Instead of using list box, can it display a series
;   of application icons so that hovering the cursor
;   over the icon will display a tooltip containing the
;   program information (path, etc).
;   (Suggested by Yih Yeong)
;
; - Instead of matching text in the middle, match only
;   those program/directory names that begin with the
;   query string.
;   (Suggested by Stefan)
;
; - Add favorites management. Launch group of programs
;   in a single run.
;   (Suggested by Atomhrt)
;
; - Integrate Seek into the Windows taskbar/toolbar so that
;   it is always available and there is no need to bind a
;   hotkey to launch Seek.
;   (Suggested by Deniz Akay)
;
; - Search by wildcards/regex.
;   (Suggested by Steve)
;
;*****************************************************************
;
; CHANGE HISTORY:
;
; * v1.1.0
; - Initial release.
;
; * v1.1.1
; - Removed maximise-window option since some programs don't
;   function well with it.
; - Added double-click detection to trigger 'Open' function.
;
; * v2.0.0
; - Integrated the 'Seek' popup window into the output screen
;   so that user can re-enter the query string to search for
;   something else without having to exit and run Seek again.
; - Added 'Scan Start-Menu' button.
; - Added real-time incremental search which will auto
;   filter for matching records while you type away,
;   without waiting for you to press <Enter>.
; - Added internal switch (TrackKeyPhrase) to track search-string.
; - Added internal switch (ToolTipFilename) to show filename
;   using tooltip.
;
; * v2.0.1
; - Added horizontal scrollbar to ListBox so that very
;   long records will not be cut-off in the middle.
;
; * v2.0.2
; - Allowed user to add their own customised list of directories
;   to be included in the scanning. User just needs to create a
;   text file 'Seek.dir' in the same directory as Seek.exe or
;   Seek.ahk, and specify the full path of the directory to be
;   added, one directory per line. Do not enclose the path in
;   quotes or double-quotes.
;
; * v2.0.3
; - Added /on option to DIR-command to sort by name.
; - Fuzzy search when user enters multiple query strings,
;   separated by space, for e.g. "med pla". It's a match
;   when all the strings ("med" & "pla") are found. This
;   will match "Media Player", "Macromedia Flash Player",
;   "Play Medieval King", "medpla", "plamed".
; - Corrected tab-movement sequence by adding all buttons
;   right from the start, but disable them until they can
;   be used.
; - Added status bar to replace tooltip-feedback.
; - Removed obsolete internal switch (ToolTipFilename).
; - Replaced the use of "dir" command with AutoHotkey's
;   own "Loop" command for scanning directory contents.
;   "dir" cannot handle extended character set and thus
;   non-English (e.g German) directory and filename are
;   captured wrongly. (Thanks Wolfgang Bujatti and
;   Sietse Fliege for testing this modification)
; - Added internal switch (ScanMode) to define whether
;   files and/or directories are to be included in scan.
; - Replaced hardcoded directory paths of Start Menu with
;   built-in variables A_StartMenu, A_StartMenuCommon.
;   With this, Seek now works for different locales with
;   different naming convention of the Start Menu.
;   (Thanks Wolfgang Bujatti and Sietse Fliege for help
;   in testing another method before these new variables
;   are available.)
; - Added the pre-selection of the last-run program
;   record so that a quick double-<ENTER> will run it.
;
;*****************************************************************

;**************************
;<--- BEGIN OF PROGRAM --->
;**************************

;==== Your Customisation ===================================

; Specify which program to use when opening a directory.
; If the program cannot be found or is not specified
; (i.e. variable is unassigned or assigned a null value),
; the default Explorer will be used.
dirExplorer = E:\utl\xplorer2_lite\xplorer2.exe

; User's customised list of additional directories to be
; included in the scanning. The full path must not be
; enclosed by quotes or double-quotes. If this file is
; missing, only the default directories will be scanned.
SeekMyDir = %A_ScriptDir%\Seek.dir

; Specify the filename and directory location to save
; the cached directory/program listing. There is no
; need to change this unless you want to.
dirListing = %A_Temp%\_Seek.list

; Specify the filename and directory location to save
; the cached key word/phrase of last search. There is
; no need to change this unless you want to.
keyPhrase = %A_Temp%\_Seek.key

; Track search string (ON/OFF)
; If ON, the last-used query string will be re-used as
; the default query string the next time you run Seek.
; If OFF, the last-used query string will not be tracked
; and there will not be a default query string value the
; next time you run Seek.
TrackKeyPhrase = ON

; Specify what should be included in scan.
; 0: Directories are excluded (only files).
; 1: All files and directories are included.
; 2: Only directories are included (no files).
ScanMode = 1

;...........................................................

; INIT
;#NoTrayIcon
StringCaseSense, Off
version = Seek v2.0.3

; DISPLAY HELP INSTRUCTIONS
If 1 in --help,-help,/h,-h,/?,-?
{
	MsgBox,, %version%, Navigating the Start Menu can be a hassle, especially if you have installed many programs over time. 'Seek' lets you specify a case-insensitive key word/phrase that it will use to filter only the matching programs and directories from the Start Menu, so that you can easily open your target program from a handful of matched entries. This eliminates the drudgery of searching and traversing the Start Menu.`n`nI have a lot of fun coding this, and hope you will enjoy using it too. Feel free to drop me an email with your comments and feedback at: phi1618 (*a.t*) gmail :D0T: com.`n`nOptions:`n  -cache`tUse the cached directory-listing if available (this is the default mode when no option is specified)`n  -scan`tForce a directory scan to retrieve the latest directory listing`n  -scex`tScan & exit (this is useful for scheduling the potentially time-consuming directory-scanning as a background job)`n  -help`tShow this help
	Goto QuitNoSave
}

; CHECK THAT THE MANDATORY ENVIRONMENT VARIABLES EXIST AND ARE VALID
; *TMP*
IfNotExist, %A_Temp% ; PATH DOES NOT EXIST
{
	MsgBox This mandatory environment variable is either not defined or invalid:`n`n    TMP = %A_Temp%`n`nPlease fix it before running Seek.
	Goto QuitNoSave
}

; IF NOT SCAN-AND-EXIT
IfNotEqual 1, -scex
{
	; RETRIEVE THE LAST USED KEY-PHRASE FROM CACHE FILE
	; TO BE USED AS THE DEFAULT QUERY STRING
	If TrackKeyPhrase = ON
	{
		FileReadLine, PrevKeyPhrase, %keyPhrase%, 1
		FileReadLine, PrevOpenTarget, %keyPhrase%, 2
	}
	NewKeyPhrase = %PrevKeyPhrase%
	NewOpenTarget = %PrevOpenTarget%

	; ADD THE TEXT BOX FOR USER TO ENTER THE QUERY STRING
	Gui, 1:Add, Edit, vFilename W600, %NewKeyPhrase%

	; ADD MY FAV TAGLINE
	Gui, 1:Add, Text, X625 Y10, What do you seek, my friend?

	; ADD THE STATUS BAR FOR PROVIDING FEEDBACK TO USER
	Gui, 1:Add, Text, vStatusBar X10 Y31 R1 W764

	; ADD THE SELECTION LISTBOX FOR DISPLAYING SEARCH RESULTS
	Gui, 1:Add, ListBox, vOpenTarget gTargetSelection X10 Y53 R28 W764 HScroll Disabled, %List%

	; ADD THESE BUTTONS, BUT DISABLE THEM FOR NOW
	Gui, 1:Add, Button, gButtonOPEN vButtonOPEN Default X10 Y446 Disabled, Open
	Gui, 1:Add, Button, gButtonOPENDIR vButtonOPENDIR X59 Y446 Disabled, Open Directory
	Gui, 1:Add, Button, gButtonSCANSTARTMENU vButtonSCANSTARTMENU X340 Y446 Disabled, Scan Start-Menu

	; ADD THE EXIT BUTTON
	Gui, 1:Add, Button, gButtonEXIT X743 Y446, Exit

	; POP-UP THE QUERY WINDOW
	Gui, 1:Show, Center, %version%
}

; ENABLE RE-SCANNING OF LATEST DIRECTORY LISTING
If 1 in -scan,-scex
	rescan = Y
; CHECK WHETHER THE DIRECTORY LISTING CACHE FILE ALREADY EXISTS. IF NOT, DO A RE-SCAN.
Else IfNotExist, %dirListing%
	rescan = Y

If rescan = Y ; DO A RE-SCAN
{
	; SHOW STATUS UNLESS USER SPECIFIES SCAN-AND-EXIT OPTION
	IfNotEqual 1, -scex
		GuiControl,, StatusBar, Scanning directory listing...

	; SCAN START-MENU AND STORE DIRECTORY/PROGRAM LISTINGS IN CACHE FILE
	Gosub ScanStartMenu

	; QUIT IF USER SPECIFIES SCAN-AND-EXIT OPTION
	IfEqual 1, -scex, Goto, QuitNoSave
}

GuiControl,, StatusBar, Retrieving last query result...

; RETRIEVE THE MATCHING LIST FOR THE LAST USED KEY-PHRASE
Gosub SilentFindMatches

; REMOVE THE STATUS TEXT
GuiControl,, StatusBar,

; DIRECTORY LISTING IS NOW LOADED. ENABLE THE OTHER BUTTONS.
; THESE BUTTONS ARE DISABLED EARLIER BECAUSE THEY SHOULD NOT
; BE FUNCTIONAL UNTIL THIS PART OF THE SCRIPT.
GuiControl, 1:Enable, ButtonOPEN
GuiControl, 1:Enable, ButtonOPENDIR
GuiControl, 1:Enable, ButtonSCANSTARTMENU

; TURN ON INCREMENTAL SEARCH
SetTimer, tIncrementalSearch, 500

; REFRESH THE GUI
Gosub EnterQuery

Return

;***********************************************************
;                                                          *
;                 END OF MAIN PROGRAM                      *
;                                                          *
;***********************************************************


;=== BEGIN ButtonSCANSTARTMENU EVENT =======================

ButtonSCANSTARTMENU:

Gui, 1:Submit, NoHide
GuiControl,, StatusBar, Scanning directory listing...

; DISABLE LISTBOX WHILE SCANNING IS IN PROGRESS
GuiControl, 1:Disable, OpenTarget
GuiControl, 1:Disable, ButtonEXIT
GuiControl, 1:Disable, ButtonOPEN
GuiControl, 1:Disable, ButtonOPENDIR
GuiControl, 1:Disable, ButtonSCANSTARTMENU

; DO THE SCANNING
Gosub ScanStartMenu

; INFORM USER THAT SCANNING HAS COMPLETED
If Filename =
{
	; IF QUERY STRING IS EMPTY...
	GuiControl, 1:Enable, ButtonEXIT
	GuiControl, 1:Enable, ButtonOPEN
	GuiControl, 1:Enable, ButtonSCANSTARTMENU
	GuiControl,, StatusBar, Scan completed.
	Gosub EnterQuery
}
Else
{
	; IF QUERY STRING EXISTS...
	; FILTER FOR SEARCH STRING WITH THE NEW LISTING
	NewKeyPhrase =
	Gosub FindMatches
}
Return

;... END ButtonSCANSTARTMENU EVENT .........................


;=== BEGIN ScanStartMenu SUBROUTINE ========================
; SCAN THE START-MENU AND STORE THE DIRECTORY/PROGRAM
; LISTINGS IN A CACHE FILE
ScanStartMenu:

; DEFINE THE DIRECTORY PATHS TO RETRIEVE.
; THE PATH MUST NOT BE ENCLOSED BY QUOTES OR DOUBLE-QUOTES.
;
; FOR ENGLISH VERSION OF WINDOWS
scanPath = %A_StartMenu%|%A_StartMenuCommon%

; INCLUDE ADDITIONAL USER-DEFINED PATHS FOR SCANNING
IfExist, %SeekMyDir%
{
	Loop, read, %SeekMyDir%
	{
		IfNotExist, %A_LoopReadLine%
			MsgBox, 8192, %version%, Processing your customised directory list...`n`n"%A_LoopReadLine%" does not exist and will be excluded from the scanning.`nPlease update [ %SeekMyDir% ].
		Else
			scanPath = %scanPath%|%A_LoopReadLine%
	} 
}

; DELETE EXISTING FILE BEFORE CREATING A NEW VERSION
FileDelete, %dirListing%

; SCAN DIRECTORY LISTING (DELIMITER = |) BY RECURSING
; EACH DIRECTORY TO RETRIEVE THE CONTENTS. HIDDEN FILES
; ARE EXCLUDED.
Loop, parse, scanPath, |
{
	Loop, %A_LoopField%\*, %ScanMode%, 1
	{
		FileGetAttrib, fileAttrib, %A_LoopFileFullPath%
		IfNotInString, fileAttrib, H ; EXCLUDE HIDDEN FILE
			FileAppend, %A_LoopFileFullPath%`n, %dirListing%
	}
}

Return

;... END ScanStartMenu SUBROUTINE ..........................


;=== BEGIN FindMatches SUBROUTINE ==========================
; SEARCH AND DISPLAY ALL MATCHING RECORDS IN THE LISTBOX
FindMatches:

Gui, 1:Submit, NoHide
CurFilename = %Filename%
GuiControl,, StatusBar, 

; CHECK FOR EMPTY QUERY STRING
If CurFilename =
{
	MsgBox, 8192, %version%, Please enter the key word/phrase to search for.
	Goto EnterQuery
}

; tIncrementalSearch IS BEING INTERRUPTED. LET IT FINISHES.
If NewKeyPhrase <> %CurFilename%
{
	; INFORM USER THAT PATIENCE IS A VIRTUE
	GuiControl,, StatusBar, Seeking...
	ResumeFindMatches = TRUE
	Return
}

If List = |
{
	; NOT EVEN A SINGLE MATCHING RECORD IS FOUND.
	; LET USER MODIFY THE QUERY STRING AND TRY AGAIN.
	MsgBox, 8192, %version%, The query string "%CurFilename%" does not match any record. Try again.
	GuiControl, 1:Disable, ButtonOPENDIR
	GuiControl, 1:Enable, ButtonSCANSTARTMENU
	Goto EnterQuery
}
Else
{
	; SELECT THE FIRST RECORD IF NO OTHER RECORD HAS BEEN SELECTED
	Gui, 1:Submit, NoHide
	GuiControl, 1:Enable, OpenTarget
	GuiControl, 1:Enable, ButtonOPEN
	GuiControl, 1:Enable, ButtonOPENDIR
	GuiControl, 1:Enable, ButtonSCANSTARTMENU
	GuiControl, Focus, OpenTarget
	If OpenTarget =
		GuiControl, 1:Choose, OpenTarget, |1
}

; REFRESH GUI
Gui, 1:Show, Center, %version%

Return

;... END FindMatches SUBROUTINE ............................


;=== BEGIN SilentFindMatches SUBROUTINE ====================

SilentFindMatches:

Gui, 1:Submit, NoHide
sfmFilename = %Filename%

; FILTER MATCHING RECORDS BASED ON USER QUERY STRING
List = |
If sfmFilename <>
{
	Loop, read, %dirListing%
	{
		Gui, 1:Submit, NoHide
		tFilename = %Filename%
		If sfmFilename <> %tFilename%
		{
			; USER HAS CHANGED THE SEARCH STRING. THERE IS NO POINT
			; TO CONTINUE SEARCHING USING THE OLD STRING, SO ABORT.
			Return
		}
		Else
		{
			; APPEND MATCHING RECORDS INTO THE LIST
			SplitPath, A_LoopReadLine, name, dir, ext, name_no_ext, drive
			MatchFound = Y
			Loop, parse, sfmFilename, %A_Space%
			{
				IfNotInString, name, %A_LoopField%
				{
					MatchFound = N
					Break
				}
			}
			IfEqual, MatchFound, Y
			{
				; ADD RECORD TO LIST
				List = %List%%A_LoopReadLine%|

				; PRE-SELECT IF THIS MATCHES THE LAST-RUN PROGRAM
				If (A_LoopReadLine = PrevOpenTarget && sfmFilename = PrevKeyPhrase)
					List = %List%|
			}
		}
	}
}

; REFRESH LIST WITH SEARCH RESULTS
GuiControl, 1:, OpenTarget, %List%

If List = |
{
	; NO MATCHING RECORD IS FOUND
	; DISABLE LISTBOX
	GuiControl, 1:Disable, OpenTarget
	GuiControl, 1:Disable, ButtonOPENDIR
}
Else
{
	; MATCHING RECORDS ARE FOUND
	; ENABLE LISTBOX
	GuiControl, 1:Enable, OpenTarget
	GuiControl, 1:Enable, ButtonOPENDIR
}

; REFRESH GUI
Gui, 1:Show, Center, %version%

Return

;... END SilentFindMatches SUBROUTINE ......................


;=== BEGIN EnterQuery SUBROUTINE ===========================
; REFRESH GUI AND LET USER ENTERS SEARCH STRING
EnterQuery:
GuiControl, Focus, Filename
GuiControl, 1:Enable, ButtonOPEN
Gui, 1:Show, Center, %version%
Return
;... END EnterQuery SUBROUTINE .............................


;=== BEGIN TargetSelection EVENT ===========================

TargetSelection:
Gui, 1:Submit, NoHide

; DOUBLE-CLICK DETECTION TO LAUNCH PROGRAM
If A_GuiControlEvent = DoubleClick
{
	Gosub ButtonOPEN
}
Else
{
	; STUB - FOR FUTURE USE
	If A_GuiControlEvent = Normal
	{
		; DO NOTHING FOR NOW
	}
}

Return

;... END TargetSelection EVENT .............................


;=== BEGIN ButtonOPEN EVENT ================================

; USER CLICKED ON 'OPEN' BUTTON OR PRESSED <ENTER>
ButtonOPEN:
Gui, 1:Submit, NoHide

; FIND OUT WHERE THE KEYBOARD FOCUS WAS. IF IT'S THE
; TEXT FIELD, RUN THE QUERY TO FIND MATCHES. ELSE, IT
; MUST BE FROM THE LISTBOX.
GuiControlGet, focusControl, 1:Focus
If focusControl = Edit1
{
	GuiControl, Focus, OpenTarget
	GuiControl, 1:Disable, OpenTarget
	GuiControl, 1:Disable, ButtonOPENDIR
	GuiControl, 1:Disable, ButtonSCANSTARTMENU
	Goto FindMatches
}

; NO RECORD FROM THE LISTBOX IS SELECTED
If OpenTarget =
{
	MsgBox, 8192, %version%, Please make a selection before hitting <Enter>.`nPress <Esc> to exit.
	Goto EnterQuery
}

; SELECTED RECORD DOES NOT EXIST (FILE OR DIRECTORY NOT FOUND)
IfNotExist, %OpenTarget%
{
	MsgBox, 8192, %version%, %OpenTarget% does not exist. This means that the directory cache is outdated. You may click on the 'Scan Start-Menu' button below to update the directory cache with your latest directory listing now.
	Goto EnterQuery
}

; CHECK WHETHER THE SELECTED RECORD IS A FILE OR DIRECTORY
FileGetAttrib, fileAttrib, %OpenTarget%
IfInString, fileAttrib, D ; IS DIRECTORY
{
	Gosub sOpenDir
}
Else If fileAttrib <> ; IS FILE
{
	Run, %OpenTarget%
}
Else
{
	MsgBox %OpenTarget% is neither a DIRECTORY or a FILE. This shouldn't happen. Seek cannot proceed. Quitting...
}

Goto Quit

;... END ButtonOPEN EVENT ..................................


;=== BEGIN ButtonOPENDIR EVENT =============================

; USER CLICKED ON 'OPEN DIRECTORY' BUTTON
ButtonOPENDIR:
Gui, 1:Submit, NoHide

; CHECK THAT USER HAS SELECTED A RECORD ALREADY
If OpenTarget =
{
	MsgBox, 8192, %version%, Please make a selection first.
	Goto EnterQuery
}

; RUN SUBROUTINE TO OPEN A DIRECTORY
Gosub sOpenDir

Goto Quit

;... END ButtonOPENDIR EVENT ...............................


;=== BEGIN sOpenDir SUBROUTINE =============================

sOpenDir:

; IF USER SELECTED A FILE-RECORD INSTEAD OF A DIRECTORY-RECORD,
; EXTRACT THE DIRECTORY PATH. (I'M USING DriveGet INSTEAD OF
; FileGetAttrib TO ALLOW THE SCENARIO WHEREBY OpenTarget IS
; INVALID BUT THE DIRECTORY PATH OF OpenTarget IS VALID.
DriveGet, status, status, %OpenTarget%
If status <> Ready ; NOT A DIRECTORY
{
	SplitPath, OpenTarget, name, dir, ext, name_no_ext, drive
	OpenTarget = %dir%
}

; CHECK WHETHER DIRECTORY EXISTS
IfNotExist, %OpenTarget%
{
	MsgBox, 8192, %version%, %OpenTarget% does not exist. This means that the directory cache is outdated. You may click on the 'Scan Start-Menu' button below to update the directory cache with your latest directory listing now.
	Goto EnterQuery
}

; OPEN THE DIRECTORY
IfExist, %dirExplorer%
{
	Run, "%dirExplorer%" "%OpenTarget%", , Max ; OPEN WITH CUSTOMISED FILE EXPLORER
}
Else
{
	Run, %OpenTarget%, , Max ; OPEN WITH DEFAULT WINDOWS FILE EXPLORER
}
Return

;... END sOpenDir SUBROUTINE ...............................


;=== BEGIN tIncrementalSearch EVENT ========================
; AUTOMATICALLY CONDUCT REAL-TIME INCREMENTAL SEARCH
; TO FIND MATCHING RECORDS WITHOUT WAITING FOR USER
; TO PRESS <ENTER>
tIncrementalSearch:

Loop
; REPEAT SEARCHING UNTIL USER HAS STOPPED CHANGING THE QUERY STRING
{
	Gui, 1:Submit, NoHide
	CurFilename = %Filename%
	If NewKeyPhrase <> %CurFilename%
	{
		OpenTarget =
		Gosub SilentFindMatches
		NewKeyPhrase = %CurFilename%
		Sleep, 100 ; DON'T HOG THE CPU!
	}
	Else
	{
		; QUERY STRING HAS STOPPED CHANGING
		Break
	}
}

; USER HAS HIT <ENTER> TO LOOK FOR MATCHING RECORDS.
; RUN FindMatches NOW.
If ResumeFindMatches = TRUE
{
	ResumeFindMatches = FALSE
	Gosub FindMatches
}

; CONTINUE MONITORING FOR CHANGES
SetTimer, tIncrementalSearch, 500

Return

;... END tIncrementalSearch EVENT ..........................


;=== BEGIN Quit SUBROUTINE =================================

Quit:
ButtonEXIT:
GuiClose:
GuiEscape:

Gui, 1:Submit, NoHide

; SAVE THE KEY WORD/PHRASE FOR NEXT RUN IF IT HAS CHANGED
If TrackKeyPhrase = ON
{
	If (PrevKeyPhrase <> Filename || PrevOpenTarget <> OpenTarget)
	{
		FileDelete, %keyPhrase%
		FileAppend, %Filename%`n, %keyPhrase%
		FileAppend, %OpenTarget%`n, %keyPhrase%
	}
}

QuitNoSave:
ExitApp ; JOB DONE. G'DAY!

;... END Quit SUBROUTINE ...................................


;************************
;<--- END OF PROGRAM --->
;************************

; /* vim: set noexpandtab shiftwidth=4: */
