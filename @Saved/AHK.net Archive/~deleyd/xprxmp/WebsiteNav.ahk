/*************************************************    (Version 2.01  05/29/2009)
 Examples of various ways to Navigate a Web Site
 *************************************************

 This demo requires the COM Standard library (COM.ahk):
    1. Download Com.zip from:  http://www.autohotkey.net/~Sean/Lib/COM.zip
    2. unzip and place COM.ahk here:  C:\Program Files\AutoHotkey\Lib\COM.ahk
    (See "COM Standard Library" post: http://www.autohotkey.com/forum/topic22923.html)

 This demo creates a log file named "WebsiteNav.txt"
   (in the same directory as this .ahk script file)

 This demo does:
   1. Goes to www.autohotkey.com
   2. Moves focus to the "Wiki" link
   3. Positions in the Search box of the Wiki page, fills it in
   4. Searches horizontally for a non-white color


 1. SOME STARTUP STUFF
*/
;^z::                      ;press CTRL+Z to go. (Uncomment if you want script to wait until you press CTRL+Z)
#NoEnv                     ;Recommended for performance and compatibility with future AutoHotkey releases.
;;SendMode Input           ;I discovered this causes MouseMove to jump as if Speed was 0. (was Recommended for new scripts due to its superior speed and reliability.)
#SingleInstance force      ;Skips the message, "An older instance of this script is already running. Replace it with this instance?"
WinGet, SavedWinId, ID, A  ;Save our current active window
MouseGetPos, xpos, ypos    ;Save initial position of mouse (note: no %% because it's writing output to xpos, ypos)
SetKeyDelay, 60            ;Any number you want (milliseconds)
CoordMode,Mouse,Screen     ;Initial state is Relative
CoordMode,Pixel,Screen     ;Initial state is Relative. Frustration awaits if you set Mouse to Screen and then use GetPixelColor because you forgot this line. There are separate ones for: Mouse, Pixel, ToolTip, Menu, Caret
MouseMove, 0, 0, 0         ;Prevents the status bar from showing a mouse-hover link instead of "Done". (We need to move the mouse out of the way _before_ we go to a webpage.)

MsgBox, 0, demo, Press Esc to abort this script, 2.0

/*************************************************
  2. SET UP A LOG FILE
*/
SetWorkingDir, %A_ScriptDir%  ;Set default directory to where this script file is located
LogFile := "websiteNav.txt"
LogMsg(";--------------------------------------------------------------`n`nBEGIN EXAMPLE OF NAVIGATING WEBSITE:")


/*************************************************
  3. GO TO THE WEBSITE (AutoHotkey website for example)
     We could simply do:
     Run, http://www.autohotkey.com/ , , max
     but we want to make sure we use Internet Explorer for this,
     so we'll do this instead:
*/
run, iexplore.exe http://www.autohotkey.com/
WaitLoad("AutoHotkey")


/*************************************************
  4. POSITION US ON A CERTAIN CONTROL
     Examples from simple to more complex
*/
; Method 1. Blindly hit the {Tab} key a certain number of times to position us where we want to be.
;           Usually not very accurate.
Send {Tab 3}  ;say, 3 tabs gets us where we want to be.

; Method 2. Hit the {Tab} key until certain text appears in the status bar
; For example, Tab until we find the autoHotkey "Forum" link
; When we tab to the AutoHotkey "Forum" link, the status bar says "http://www.autohotkey.com/docs/"
target := "http://www.autohotkey.com/wiki/"
ShoMsg("{Tab} until we find the Wiki link: " . target, "3.0")
loop, 20
{
  Send, {Tab}
  sleep 10  ;this pause may help
  StatusBarGetText, StatBar, , AutoHotkey
  ShoMsg(" Loop=" . A_Index . "`nStatus bar = """ . StatBar . """", "0.3")
  if (StatBar = target)
  {
    ShoMsg("FOUND IT! Status bar = """ . target . """", "3.0" )
    goto F
  }
}
; If we drop out here, it means we failed to find our target
; I had a case where {TAB} just circled around the top where
; the Google toolbar was. It never made it into the actual page.
; Method 2.5
ShoMsg("Failed to find " . target . "`n`nLet's try tabbing backwards (shift-tab)", "3.1" )
SetKeyDelay, 40
Send +{Tab 20}   ;first a bunch of backward tabs to get us going
loop, 90
{
  Send, +{Tab}
  sleep 10  ;this pause may help
  StatusBarGetText, StatBar, , AutoHotkey
  ;ShoMsg(" Tabbing Backwards.`nLoop=" . A_Index . "`nStatus bar = """ . StatBar . """", "0.3")
  if (StatBar = target)
  {
    ShoMsg("FOUND IT TABBING BACKWARDS! Status bar = """ . target . """", "3.0" )
    goto F
  }
}

ExitApp


/*******************************************************
  5. CLICK ON THE LINK TO GO TO THE AUTOHOTKEY WIKI PAGE
*/
F:
;Found the AutoHotkey "wiki" link. Click on it (actually we just press {Return} key)
ShoMsg("{Return}", "2.0")
Send {Return}


/************************************************
  6. WAIT FOR NEW PAGE TO LOAD
     (Just as we did before)
*/
WaitLoad("AutoHotkey")

Sleep 1500  ;give the user a moment to see the new page


/********************************************************************
  7. POSITION US IN THE SEARCH FIELD OF THE AUTOHOTKEY WIKI PAGE
     Here we demonstrate a faster more complex technique,
     using ControlSetText and ControlSend

     The JavaScript method. We place some JavaScript code in the address
     bar and execute it to jump directly to the control. This is a
     faster and more reliable technique, but it's a bit more
     complicated to set up. We use AutoHotkey ControlSetText to
     place the JavaScript code in the address bar, specifying the
     HTML control ID, or the control NAME, of the control we want
     to jump to, then we use AutoHotkey ControlSend to execute
     that JavaScript.

     Determine the ID or NAME of the control
     Method 1: Read and decypher the HTML source code. Look for " ID="
               e.g. for page http://www.autohotkey.com/wiki/
               we find this line of code:

                   <INPUT id=searchInput title="Search AutoHotkey [f]" accessKey=f name=search>
                             ^^^^^^^^^^^                                                ^^^^^^
                   In this example our ID is "searchInput", and our NAME is "search" (we only need one, ID or NAME)

     Method 2: Use a tool to help us find the ID or NAME
               Use the Microsoft "Internet Explorer Developer Toolbar" for Internet Explorer 7
                    (Note: for Internet Explorer 8, see "Discovering Internet Explorer Developer Tools" at http://msdn.microsoft.com/en-us/library/cc848894(VS.85).aspx
                 a. Download and install : http://www.microsoft.com/downloads/details.aspx?familyid=E59C3964-672D-4511-BB3E-2D5E1DB91038&displaylang=en
                 b. Navigate to your webpage (using Internet Explorer 7)
                 c. Bring up the "IE Developer Toolbar". (Note: If you do not see the "IE Developer Toolbar" button on the toolbar, it may be off to the right. Click the right-facing arrows at the end of the IE7 command bar to view all available toolbar buttons.)
                 d. FIND -> SELECT ELEMENT BY CLICK
                 e. Move your mouse to the desired element and click.
                 f. In the middle pane ('Attribute:') scroll down and find the ID string.
                    If there is no ID string, find the NAME string.
                    If there is no NAME string, cripes, it gets a bit difficult. You'll
                      have to read up on Javascript and the DOM (Document Object Model).

                 There are other similar programs to help you examine the source code for web pages. Here are a few:
                 Debugbar http://www.debugbar.com/
                 PageSpy http://www.sembel.net/
*/

;DEMONSTRATE POSITIONING TO A CONTROL USING CONTROL'S ID
; warning: "getElementById" is case sensitive! I originally tried "getElementByID" (last leter "D" instead of "d") and it didn't work.
ShoMsg("Positioning to search box`nusing ID", "2.0")
ControlSetText, Edit1, javascript:document.getElementById( 'searchInput').focus()
ControlSend, Edit1, {Enter}, AutoHotkey
Sleep 100     ;give it a moment to do it's thing (important)
sleep 3000    ;(give the user a moment to see that we are now positioned in the search field)
ShoMsg("filling in search box", "2.0")
SetKeyDelay, 90
Send AutoHotkey Expression Examples
sleep 2000    ;(give the user a moment to see)
ShoMsg("Let's erase that", "2.0")
Send {Backspace 30}
sleep 2000    ;(give the user a moment to see)
/*
  Alternatively, if we didn't have an ID but did have a NAME,
  we could use the NAME (which in this example is "search")
*/
ShoMsg("moving away from search box", "2.0")
loop, 5
{
  Send {Tab}
  Sleep 400   ;just for show
}
sleep 2000    ;(give the user a moment to see that we are now positioned in the search field)


;DEMONSTRATE POSITIONING TO A CONTROL USING CONTROL'S NAME
ShoMsg("Positioning to search box`nusing NAME", "2.0")
ControlSetText, Edit1, javascript:document.getElementsByName( 'search')[0].focus()
ControlSend, Edit1, {Enter}, AutoHotkey
Sleep 100     ;give it a moment to do it's thing (important)
sleep 2000    ;(give the user a moment to see that we are now positioned in the search field)


;fill in the search field
ShoMsg("filling in search box", "2.0")
SetKeyDelay, 90
Send AutoHotkey Expression Examples
sleep 2000    ;(give the user a moment to see)
ShoMsg("{Return}", "2.0")
Send {Return}
WaitLoad()  ;and wait for the new page to load


/********************************************************************
  8. SEARCH FOR A COLOR

     If I'm searching a white background for black text, I find it
     works better to search for "not white" rather than search for
     "black", because sometimes that black text isn't really black
     when you look at it closely.

     This actually goes quite fast if you comment out the moving of
     the mouse. I move the mouse here for demonstration purposes.
*/
CoordMode,Mouse, Relative
CoordMode,Pixel, Relative
WinGetPos, winposX, winposY, Width, Height, A  ;Get window Width, Height
LogMsg("winposX=" . winposX . "`nwinposY=" . winposY . "`nWidth=" . Width . "`nHeight=" . Height)

;Calculate a starting position
X := Width - 60
Y := Height / 2
MouseMove, X, Y, 7

;Move left until we find a non-white pixel
ShoMsg( "Demonstrate moving left looking for a non-white pixel color", "2.0")
loop 1000
{
    MouseMove, X, Y, 0
    PixelGetColor, color, X, Y, RGB
    ;ShoMsg( "color= " . color, "0.1" )
    if (color <> "0xFFFFFF")
    {
      Goto FOUND_TCOLOR
    }
    X -= 1
}
;If we drop out here, it means we failed to find a non-white colored pixel
ShoMsg( "Failed to find a non-white color`n(This is just a demo)", "2.0" )
goto Exit


FOUND_TCOLOR:
ShoMsg( "Found a non-white color`npixel color = " . color, "2.0" )

Exit:
sleep 1000
ShoMsg( "End of Demonstration.", "4.0" )
ExitApp


;---END OF AUTO-EXECUTE CODE---------------------------------------------------
/******************************************************************************
  PRESS ESC TO CANCEL THIS SCRIPT
    A hotkey definition line stops execution at that point, so if you want the
    script to run to the end but have the ESC key available to terminate the script,
    put the hotkey definition at the end, just AFTER your ExitApp statement.
*/
Esc::ExitApp


/****************************************
  and now, some functions...
*/
;------------------------------------------------------------------------------
LogMsg( msg )
{
  global LogFile
  FormatTime, TimeString, , yyyy-MM-dd hh:mm:ss tt
  FileAppend, `n%TimeString% : %msg%, %LogFile%
  ;Note: I've had problems with heavy use of FileAppend. Sometimes it fails.
  ;You can check ErrorLevel, but can't get any further info on why it failed.
  ;FileAppend closes the file each time. That can be a lot of opening/closing.
}


/**********************************************************************
  ShoMsg
    I was debugging an AutoHotKey script by throwing in a bunch of MsgBox
    messages, and I discovered a problem that focus wasn't being returned
    to my window after the MsgBox timed out. So, I added a WinActivate
    after MsgBox to restore focus to my window, and all was well again.

    Update: I had another case where this was exactly the _wrong_ thing
            to do. (The "current window" wasn't the one I wanted.)
*/
ShoMsg( msg, Timeout = "" )
{
  LogMsg( msg )   ;might as well log the message too
  ;WinExist("A")   ;current window becomes "Last Found Window"
  MsgBox, 0, demo, %msg%, %Timeout%
  ;WinActivate     ;activate "Last Found Window" (precaution after using MsgBox)
}


/******************************************************************************
  WaitLoad - Wait For Website Page To Load

  DETERMINING WHEN A WEBPAGE HAS FINISHED LOADING:
    See FAQ: http://www.autohotkey.com/docs/FAQ.htm#load

    Method 1: Wait for status line to say "Done"

    Method 2: call IEReady()
    [Only works for Internet Explorer (afik).]
    See post "Determine if a WebPage is completely loaded in IE" : http://www.autohotkey.com/forum/topic19256.html
         1a. Download Com.zip from:  http://www.autohotkey.net/~Sean/Lib/COM.zip  ("COM Standard Library" post: http://www.autohotkey.com/forum/topic22923.html)
         1b. unzip and place COM.ahk here:  C:\Program Files\AutoHotkey\Lib\COM.ahk
         2a. Download function IEReady from:  http://www.autohotkey.com/forum/topic19256.html
         2b. Add fuction IEReady to your .ahk code
         3.  Place a call to IEReady() in your .ahk code when you want to wait until the page is loaded

     Method 3: See "Detect when a page is loaded (reliable, cross-browser)" post: http://www.autohotkey.com/forum/topic35056.html

     Methods 4,5,6,...
     For more advanced methods which are over my head, see these two posts:

       Automation IE7 Navigation and Scripting with Tabs
       http://www.autohotkey.com/forum/viewtopic.php?t=30599

       IE and Gui Browser Com Tutorial
       http://www.autohotkey.com/forum/viewtopic.php?t=34972


  Function : WaitLoad - Wait For Website Page To Load
  Input    : Window Title (optional)
*/
WaitLoad( WinTitle = "" )
{
  ShoMsg("Waiting for webpage to load...", "2.0")

  ; Wait for window title to appear (optional).
  ; Careful, the window title is case sensitive! 10 second timeout.
  IF (WinTitle <> "")
  {
    WinWaitActive, %WinTitle%, , 10
    if ErrorLevel
    {
       ShoMsg("Timeout waiting for window title " . WinTitle )
       ExitApp
    }
    ShoMsg("Waiting for webpage to load...`nFound window title """ . WinTitle . """", "2.0")
  }


  ; WAIT FOR WEB PAGE TO FINISH LOADING
  ; Test #1. Call IEReady (I think this only works for Internet Explorer?)
  IEReady()
  ShoMsg("Waiting for webpage to load...`nIEReady() says we're ready", "2.0")


  ; Test #2. Wait for "Done" to appear in browser status bar
  StatusBarWait, Done, 10
  if ErrorLevel
  {
     ShoMsg("Timed out waiting for ""Done"" to appear in status bar")
     ExitApp
  }
  ShoMsg("Waiting for webpage to load...`nFound ""Done"" in the status bar", "2.0")
  Return
}


/**********************************************************************
  IEReady()
    From post "Determine if a WebPage is completely loaded in IE" : http://www.autohotkey.com/forum/topic19256.html

    Requires the COM.ahk library:
       (See "COM Standard Library" post: http://www.autohotkey.com/forum/topic22923.html)
       1a. Download Com.zip from:  http://www.autohotkey.net/~Sean/Lib/COM.zip
       1b. unzip and place COM.ahk here:  C:\Program Files\AutoHotkey\Lib\COM.ahk
*/
IEReady(hIESvr = 0)
{
   If Not   hIESvr
   {
      Loop,   50
      {
         ControlGet, hIESvr, hWnd, , Internet Explorer_Server1, A ; ahk_class IEFrame
         If   hIESvr
            Break
         Else   Sleep 100
      }
      If Not   hIESvr
         Return   """Internet Explorer_Server"" Not Found."
   }
   Else
   {
      WinGetClass, sClass, ahk_id %hIESvr%
      If Not   sClass == "Internet Explorer_Server"
         Return   "The specified control is not ""Internet Explorer_Server""."
   }

   COM_Init()
   If   DllCall("SendMessageTimeout", "Uint", hIESvr, "Uint", DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT"), "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 1000, "UintP", lResult)
   &&   DllCall("oleacc\ObjectFromLresult", "Uint", lResult, "Uint", COM_GUID4String(IID_IHTMLDocument2,"{332C4425-26CB-11D0-B483-00C04FD90119}"), "int", 0, "UintP", pdoc)=0
   &&   pdoc && pweb:=COM_QueryService(pdoc,IID_IWebBrowserApp:="{0002DF05-0000-0000-C000-000000000046}")
      Loop
         If   COM_Invoke(pweb, "ReadyState") = 4
            Break
         Else    Sleep 500
   COM_Release(pdoc)
   COM_Release(pweb)
   COM_Term()
   Return   pweb ? "DONE!" : False
}