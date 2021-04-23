/*
	< ZIZORZ > (Heritage: ScreenCapture (Sean), ScreenClipping (Learning One), ScreenClipping (Sumon), ScreenClipper (Sumon), Zizor (Sumon), Zizorz (Sumon) - due to correct grammar & SEO
    
      Script Function:
      Copy, save or upload a part of the screen as an image.  
    
	Version: 0.94 
	Author: Simon Strålberg [sumon @ Autohotkey forums, simon . stralberg @ gmail . com]
    Based on: Learning one's ScreenClipping with inspiration from Zonanic, Sean & more...  [History: http://www.autohotkey.com/forum/viewtopic.php?t=49950]
	Autohotkey version: AHK_L (ANSI!) <--- Due to the image function
	Dependencies:
		- Notify.ahk by gwarble & more [http://www.autohotkey.com/forum/viewtopic.php?t=48668]
        - httpQuery [http://www.autohotkey.com/forum/topic33506.html]
		
	CHANGELOG:
	v.
        - v 0.94 (20110409) Added Settings & Help (NICE GUI), cleaned up some unneeded functions, renamed to Zizorz, added Winkey support, changed hotkeys (Leftclick again)
		- v 0.9 (20110407) Added version numbers, removed httpQuery (added requirement)
		- v 0.x Changed mousebutton, made sure it worked in Ansi, fixed GUI
        - v 0.xx Added sounds
	
	TODO:

	LICENSE: If no license documentation exists, [http://www.autohotkey.net/~sumon/license.html]
	Script created using Autohotkey [http://www.autohotkey.com]
	
*/


#SingleInstance force
SetBatchLines, 10ms
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
IfNotExist, data\img\zizorz_header.jpg
   Gosub, Install
IniRead, ImgFolder, data\ZizorSettings.ini, Folder, Path, PrintScreens
If (!ImgFolder)
   ImgFolder := A_ScriptDir . "\data\PrintScreens"
IfNotExist, %ImgFolder%
   FileCreateDir, %ImgFolder%
Menu, Tray, Icon, data\img\Zizorz.ico
NotifyID := Notify("Zizorz:", "Drag to capture an area (or)`nhold [Win] to capture target window`n[+Shift] Upload`n[+Ctrl] Copy`n[+Alt] File", 8,, "data\img\Zizorz.ico") 
; ======== Hotkeys ========

Hotkey, *+LButton, UploadClip ; Shift (Upload)
Hotkey, *^LButton, CopyClip ; Ctrl (Clipboard)
;~ Hotkey, #LButton, WinClip ; Win (Window) [ Winkey is held IN ADDITION TO another key ]
Hotkey, *!LButton, SaveClip ; Alt (File)
Hotkey, F1, Settings
SetSystemCursor("IDC_Cross") ; To show that you can click-drag, and give better precision
Sleep 8000
If (!ClipType)
   Traytip, Zizorz:, Need help? Press F1 to access help & settings, 16, 1
return

~Esc:: Gosub, Exit
return
;=== Define type of clipping =========================================================================

SaveClip:
ClipType := "Save"
DragBoxColor := "EACD56"
Gosub, ClipDrag
return

UploadClip:
ClipType := "Upload"
DragBoxColor := "6EB5C5"
Gosub, ClipDrag
return

CopyClip:
ClipType := "Copy"
DragBoxColor := "78DF45"
Gosub, ClipDrag
return

;=== Clipdrag, "Main function" =========================================================================

ClipDrag:
;~ SetTimer, NotifyOff, -100 : Doesn't really work all too well
If (GetKeyState("LWin")) ; If LWin was also being held
{   
   ;~ Send !{PrintScreen} ; Capture current window to clipboard
   MouseGetPos,,, MouseWin
   Wingetpos, MX, MY, W, H, ahk_id %MouseWin%
   WinSet, AlwaysOnTop, Toggle, ahk_id %MouseWin%
   MXEnd := MX + W
   MYEnd := MY + H
   Area = %MX%, %MY%, %MXend%, %MYend%
   CaptureScreenLeft(Area)
   WinSet, AlwaysOnTop, Toggle, ahk_id %MouseWin%
   win_Flash(MouseWin, "b85bea")
   Gosub, ClipDragDone
   return
}
CoordMode, Mouse ,Screen
MouseGetPos, MX, MY
Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
WinSet, Transparent, 80
Gui, Color, %DragBoxColor%
   
While, (GetKeyState("LButton", "p"))
{
   MouseGetPos, MXend, MYend
   Send {control up}
   w := abs(MX - MXend)
   h := abs(MY - MYend)
   If ( MX < MXend )
   X := MX
   Else
   X := MXend
   If ( MY < MYend )
   Y := MY
   Else
   Y := MYend
   Gui, Show, x%X% y%Y% w%w% h%h%
   Sleep, 10
}

; Disable all hotkeys
Hotkey, *+LButton, Off ; Shift (Upload)
Hotkey, *^LButton, Off ; Ctrl (Clipboard)
;~ Hotkey, #LButton, Off ; Win (Window)
Hotkey, *!LButton, Off ; Alt (File)
RestoreCursors() ; Restore here too for more responsiveness


MouseGetPos, MXend, MYend
Gui, Destroy
If ( MX > MXend )
{
   temp := MX
   MX := MXend
   MXend := temp
}
If ( MY > MYend )
{
   temp := MY
   MY := MYend
   MYend := temp
}
Area = %MX%, %MY%, %MXend%, %MYend%
Sleep, 50   ; if omitted, GUI sometimes stays in picture [100]
CaptureScreenLeft(Area)   ; Saves selected area without cursor in Clipboard.

; <<<<<<<<<<<<<< This is where the three different cliptypes go different ways >>>>>>>>>
ClipDragDone:
RestoreCursors()
SoundPlay, data\sounds\scissors.wav
If (ClipType = "Copy")
   Traytip, Zizorz:, Copied to clipboard, 3 ; Maybe a preview or something?
else
   Gosub, ImageSave
Sleep 3000
Gosub, Exit
Return

NotifyOff: ; Trigger this when starting to drag
Notify("","",0,"Wait",NotifyID) ; Notification OFF - it's memory requiring, so...
return

;=== ImageSave (& ImageUpload) =========================================================

ImageSave: 
Sleep, 100   ; if omitted, GUI sometimes stays in picture
IfNotExist, %ImgFolder%
   FileCreateDir, %ImgFolder%


; Find an available filename.

countLoop := 1
loopFileName:
   countLoopString := countLoop
      
      loopStringAddZeroes:
         if (StrLen(countLoopString) < 4)
         {
            countLoopString := "0" countLoopString
            Goto, loopStringAddZeroes
         }
      newFileName := ImgFolder . "\img_" countLoopString ".jpg"
      IfExist, % newFileName
      {
         countLoop++
         Goto, loopFileName
      }
; Loop finished

/*
 * Capture screenshot.
 */
CaptureScreen(Area, False, newFileName, 100)
If (ClipType = "Save") ; If we just wanted to save an image, we are done now :)
   {
   Slash = \
   IfExist, %newFileName%
      {
         Traytip, Zizorz:, File saved as:`n%newFileName%, 4
         SplitPath, newFileName,, OutDir
         ClipBoard := OutDir ; Saves the directory instead, because Word and more programs behave better with this. Besides, the user probably just wants to see the image and choose what $he does with it, instead of opening it.
         Sleep 4000
      }
   else
      Traytip, Zizorz:, Error. File could not be created, 4 ; Something went wrong in creating file
   Gosub, Exit
   }
; --------------
; START OF Imgshack UPLOAD, Upload function from AHK forums -> HTTPQuery, @ http://www.autohotkey.com/forum/viewtopic.php?t=33506, modified by author Sumon
; --------------
ImageUpload: ; Is not called from what I know, but I'll name it anyway
   image := newfilename
   FileGetSize,size,%image%
   SplitPath,image,OFN
   FileRead,img,%image%
   VarSetCapacity(placeholder,size,32)
   boundary := makeProperBoundary()
   post:="--" boundary "`ncontent-disposition: form-data; name=""MAX_FILE_SIZE""`n`n"
      . "1048576`n--" boundary "`ncontent-disposition: form-data; name=""xml""`n`nyes`n--"
      . boundary "`ncontent-disposition: form-data; name=""fileupload""; filename="""
      . ofn """`nContent-type: " MimeType(img) "`nContent-Transfer-Encoding: binary`n`n" 
      . placeholder "`n--" boundary "--"
   headers:="Content-type: multipart/form-data, boundary=" boundary "`nContent-Length: " strlen(post)
   DllCall("RtlMoveMemory","uInt",(offset:=&post+strlen(post)-strlen(Boundary)-size-5)
         ,"uInt",&img,"uInt",size)
   size := httpQuery(result:="","http://www.imageshack.us/index.php",post,headers)
   VarSetCapacity(result,-1)
   ;~ Gui,Add,Edit,w800 h600, % result
   ;~ Gui,Show
LinkTextPos := RegExMatch(Result, "<image_link>(.*)</image_link>", LinkText)
LinkText := LinkText1
; End of "Upload"
ClipBoard := LinkText
IfExist, Data\Zizor_UploadedIMGs.txt
FileAppend, `n%Linktext%, Data/Zizor_UploadedIMGs.txt
; GuiClose:
; GuiEscape:
;   ExitApp

; END OF "Include" part
; END OF UPLOAD
If (Clipboard)
   TrayTip, Zizorz:, DONE! Link is in your clipboard`n%Clipboard%, 4
else
   TrayTip, Zizorz:, There was an error in uploading your image. Try again., 4
Sleep 3000
GoSub, Exit
return

; === Settings ======

Settings:
If WinExist("Zizorz Settings")
{
   WinActivate, Zizorz Settings ; Just activate it again, no need to redraw
  return
}
RestoreCursors() ; For normal cursor at GUI
Gui, 5: Default
Gui, Destroy
Gui, Color, FFffFF
Gui, Font, s10, Verdana
Gui, Add, Pic, x0 gGuiDrag, data\img\zizorz_header.jpg
AddGraphicButton("ChangeDir", "data\img\filedir.ico", "x10 w40 h40 gGuiChangeDir")
StringRight, DisplayDir, ImgFolder, 30
Gui, Add, Text, x60 yp+10 vImgFolder w250, {... %DisplayDir%}
AddGraphicButton("CreateShortCut", "data\img\shortcut.ico", "x10 w40 h40 gGuiCreateShortcut")
Gui, Add, Text, x60 yp+10 w250, Create a shortcut && hotkey for Zizorz
;~ Gui, Add, Button, x200 yp h40, Save && Exit
AddGraphicButton("HelpButton", "data\img\help.ico", "x200 w40 h40 gGuiHelp")
AddGraphicButton("ExitButton", "data\img\exit.ico", "x245 yp w40 h40 gGuiClose")
AddGraphicButton("SaveButton", "data\img\save.ico", "x290 yp w40 h40 gGuiSubmit default")
Gui, -Caption +Border
Gui, Show,, Zizorz Settings
return

GuiHelp:
MsgBox, 32, Zizorz help, Zizorz is a tool to create`, save & upload images quickly and intuitively`, making it easier to create & share content with others.`nZizors (tm) was made by Simon Strålberg in 2011 using Autohotkey (http://www.autohotkey.com)`n`nTo capture an area`, hold and drag the left mouse button. To capture a window`, hold the windows (#) key and leftclick. Depending on what modifier you use (you must use one)`, you can achieve one of following three options:`n`n[ + Shift ] Upload to imageshack.us`n[ + Ctrl ] Copy to clipboard`n[ + Alt ] Save as a file in the pre-chosen folder`n`nIn cases 1 & 3`, the link to the URL respectively file folder will be in your clipboard.`n`nZizorz will not run in the background`, but instead exits when finished`, so it doesn't require memory when not used. Therefore`, it is recommended that you launch Zizorz using an applauncher such as Appifyer (tm).
return

GuiChangeDir:
FileSelectFolder, ImgFolder, *ImgFolder, 3, Select the folder that your saved images will go to
If Errorlevel
   return
StringRight, DisplayDir, ImgFolder, 30
GuiControl,, ImgFolder, {... %DisplayDir%}
return

GuiCreateShortCut:
FileCreateShortcut, %A_ScriptDir%\%A_ScriptName%, %A_Desktop%\Zizorz.lnk, %A_ScriptDir%,, Launch Zizorz, %A_ScriptDir%\data\img\Zizorz.ico, Z
MsgBox, 64, Shortcut created, Created a shortcut for Zizorz on your desktop.`nAdded the default hotkey Ctrl+Alt+Z to launch Zizorz.`nYou may change the hotkey by editing the shortcut.
return

GuiClose:
Gui, 5:Destroy
Hotkey, F1, Off ; Can't reenable Help upon exiting
Gosub, Exit
return

GuiSubmit: 
Gui, Submit
Hotkey, F1, Off ; Can't reenable Help upon exiting
IniWrite, %ImgFolder%, data\ZizorSettings.ini, Folder, Path
return


GuiDrag:
PostMessage, 0xA1, 2,,, A
return
; === Extra subroutines ======================
; Change if you want to have it running constantly

Install:
Gui, 33:Default
gui, font, s10, Verdana  ; Set 10-point Verdana.
Gui, Add, Text, vInstallText, This is the first time you run Zizorz! `n`nExtract required data to "/data" directory?
Gui, Add, Button, x10 w125 h40 gInstallFiles default, Sure!
Gui, Add, Button, x135 w125 yp h40 gExit, No thanks!
Gui, -Caption +Border
Gui, Color, ffFFff
Gui, Show,, Extract files?
WinWaitClose, Extract files?,, 30 ; Wait max 30s
return

InstallFiles:
GuiControl,, InstallText, Extracting...
GuiControl, Disable, Sure!
GuiControl, Disable, No thanks!
Traytip, Zizorz:, Extracting files..., 3
   FileCreateDir, Data
   FileCreateDir, Data\sounds
   FileCreateDir, Data\img
   FileInstall, data\img\Zizorz.ico, data\img\Zizorz.ico
   FileInstall, data\img\exit.ico, data\img\exit.ico
   FileInstall, data\img\filedir.ico, data\img\filedir.ico
   FileInstall, data\img\shortcut.ico, data\img\shortcut.ico
   FileInstall, data\img\save.ico, data\img\save.ico
   FileInstall, data\img\help.ico, data\img\help.ico
   FileInstall, data\img\zizorz_header.jpg, data\img\zizorz_header.jpg
   FileInstall, data\ZizorSettings.ini, data\ZizorSettings.ini
   FileInstall, data\sounds\scissors.wav, data\sounds\scissors.wav
   
Traytip, Zizorz:, Done!, 1
Gui, 33:Submit
return

Exit:
RestoreCursors() ; If unexpected exit
Sleep 1500
ExitApp
return
;===Functions==========================================================================
imgurUpload(image) ; Not functioning yet
{
	API_key := "75388cba9c4224693dc2a8d7f59e0fb5" ; Key for Zizorz
	http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), main := "http://api.imgur.com/2/upload?"
	post := "key=" . API_key . "&image=" . image
    Clipboard := main . post
    http.open("POST", main . post, false)
    http.send()
    return RegexReplace(http.ResponseText, "\r?\n?")
}

RestoreCursors()
{
   SPI_SETCURSORS := 0x57
   DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
   BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
   
   SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
   ,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
   ,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
   ,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
   
   If Cursor = ; empty, so create blank cursor 
   {
      VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
      BlankCursor = 1 ; flag for later
   }
   Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
   {
      Loop, Parse, SystemCursors, `,
      {
         CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
         CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
         SystemCursor = 1
         If ( CursorName = Cursor )
         {
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            Break               
         }
      }   
      If CursorHandle = ; invalid cursor name given
      {
         Msgbox,, SetCursor, Error: Invalid cursor name
         CursorHandle = Error
      }
   }   
   Else If FileExist( Cursor )
   {
      SplitPath, Cursor,,, Ext ; auto-detect type
      If Ext = ico 
         uType := 0x1   
      Else If Ext in cur,ani
         uType := 0x2      
      Else ; invalid file ext
      {
         Msgbox,, SetCursor, Error: Invalid file type
         CursorHandle = Error
      }      
      FileCursor = 1
   }
   Else
   {   
      Msgbox,, SetCursor, Error: Invalid file path or cursor name
      CursorHandle = Error ; raise for later
   }
   If CursorHandle != Error 
   {
      Loop, Parse, SystemCursors, `,
      {
         If BlankCursor = 1 
         {
            Type = BlankCursor
            %Type%%A_Index% := DllCall( "CreateCursor"
            , Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }         
         Else If SystemCursor = 1
         {
            Type = SystemCursor
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            %Type%%A_Index% := DllCall( "CopyImage"
            , Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )      
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }
         Else If FileCursor = 1
         {
            Type = FileCursor
            %Type%%A_Index% := DllCall( "LoadImageA"
            , UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
            DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )         
         }          
      }
   }   
}

CaptureScreenLeft(aRect)
{
   StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
   LnL := rt1 ; Since CaptureScreen (for fileupload) used s
   LnT := rt2
   LnW := rt3 - rt1
   LnH := rt4 - rt2
   LznW := rt5
   LznH := rt6

   LmDC := DllCall("CreateCompatibleDC", "Uint", 0)
   LhBM := CreateDIBSection(LmDC, LnW, LnH)
   LoBM := DllCall("SelectObject", "Uint", LmDC, "Uint", LhBM)
   LhDC := DllCall("GetDC", "Uint", 0)
   DllCall("BitBlt", "Uint", LmDC, "int", 0, "int", 0, "int", LnW, "int", LnH, "Uint", LhDC, "int", LnL, "int", LnT, "Uint", 0x40000000 | 0x00CC0020)
   DllCall("ReleaseDC", "Uint", 0, "Uint", LhDC)
   DllCall("SelectObject", "Uint", LmDC, "Uint", LoBM)
   DllCall("DeleteDC", "Uint", LmDC)
   SetClipboardData(LhBM)
}
CaptureScreen(aRect = 0, bCursor = False, sFile = "", nQuality = "")
{
   If   !aRect
   {
      SysGet, nL, 76
      SysGet, nT, 77
      SysGet, nW, 78
      SysGet, nH, 79
   }
   Else If   aRect = 1
      WinGetPos, nL, nT, nW, nH, A
   Else If   aRect = 2
   {
      WinGet, hWnd, ID, A
      VarSetCapacity(rt, 16, 0)
      DllCall("GetClientRect" , "Uint", hWnd, "Uint", &rt)
      DllCall("ClientToScreen", "Uint", hWnd, "Uint", &rt)
      nL := NumGet(rt, 0, "int")
      nT := NumGet(rt, 4, "int")
      nW := NumGet(rt, 8)
      nH := NumGet(rt,12)
   }
   Else If   aRect = 3
   {
      VarSetCapacity(mi, 40, 0)
      DllCall("GetCursorPos", "int64P", pt)
      DllCall("GetMonitorInfo", "Uint", DllCall("MonitorFromPoint", "int64", pt, "Uint", 2), "Uint", NumPut(40,mi)-4)
      nL := NumGet(mi, 4, "int")
      nT := NumGet(mi, 8, "int")
      nW := NumGet(mi,12, "int") - nL
      nH := NumGet(mi,16, "int") - nT
   }
   Else
   {
      StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
      nL := rt1
      nT := rt2
      nW := rt3 - rt1
      nH := rt4 - rt2
      znW := rt5
      znH := rt6
   }

   mDC := DllCall("CreateCompatibleDC", "Uint", 0)
   hBM := CreateDIBSection(mDC, nW, nH)
   oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
   hDC := DllCall("GetDC", "Uint", 0)
   DllCall("BitBlt", "Uint", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", hDC, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)
   DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
   If   bCursor
      CaptureCursor(mDC, nL, nT)
   DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
   DllCall("DeleteDC", "Uint", mDC)
   If   znW && znH
      hBM := Zoomer(hBM, nW, nH, znW, znH)
   If   sFile = 0
      SetClipboardData(hBM)
   Else   Convert(hBM, sFile, nQuality), DllCall("DeleteObject", "Uint", hBM)
   return
}

CaptureCursor(hDC, nL, nT)
{
   VarSetCapacity(mi, 20, 0)
   mi := Chr(20)
   DllCall("GetCursorInfo", "Uint", &mi)
   bShow   := NumGet(mi, 4)
   hCursor := NumGet(mi, 8)
   xCursor := NumGet(mi,12)
   yCursor := NumGet(mi,16)

   VarSetCapacity(ni, 20, 0)
   DllCall("GetIconInfo", "Uint", hCursor, "Uint", &ni)
   xHotspot := NumGet(ni, 4)
   yHotspot := NumGet(ni, 8)
   hBMMask  := NumGet(ni,12)
   hBMColor := NumGet(ni,16)

   If   bShow
      DllCall("DrawIcon", "Uint", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "Uint", hCursor)
   If   hBMMask
      DllCall("DeleteObject", "Uint", hBMMask)
   If   hBMColor
      DllCall("DeleteObject", "Uint", hBMColor)
}

win_Flash(FlashID="", Color="c0edeb") ; Optionally enter Win ID & color (HEX). Default is active window
{
 If (!FlashID)
  WinGet, FlashID, ID, A
 WinGetPos, X, Y, W, H, ahk_id %FlashID%
 Gui, 15: Default
 Gui, Destroy
 Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
 Gui, Color, %Color%
 WinSet, Transparent, 0
 Gui, Show, x%X% y%Y% w%w% h%h%
 T:=0
 Loop, 25
 {
  Sleep 15
  T += 2
  WinSet, Transparent, %T% 
 }
 Loop, 25
 {
  Sleep 15
  T -= 2
  WinSet, Transparent, %T% 
 }
 Gui, Destroy
 return
}

Zoomer(hBM, nW, nH, znW, znH)
{
   mDC1 := DllCall("CreateCompatibleDC", "Uint", 0)
   mDC2 := DllCall("CreateCompatibleDC", "Uint", 0)
   zhBM := CreateDIBSection(mDC2, znW, znH)
   oBM1 := DllCall("SelectObject", "Uint", mDC1, "Uint",  hBM)
   oBM2 := DllCall("SelectObject", "Uint", mDC2, "Uint", zhBM)
   DllCall("SetStretchBltMode", "Uint", mDC2, "int", 4)
   DllCall("StretchBlt", "Uint", mDC2, "int", 0, "int", 0, "int", znW, "int", znH, "Uint", mDC1, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", 0x00CC0020)
   DllCall("SelectObject", "Uint", mDC1, "Uint", oBM1)
   DllCall("SelectObject", "Uint", mDC2, "Uint", oBM2)
   DllCall("DeleteDC", "Uint", mDC1)
   DllCall("DeleteDC", "Uint", mDC2)
   DllCall("DeleteObject", "Uint", hBM)
   Return   zhBM
}

Convert(sFileFr = "", sFileTo = "", nQuality = "")
{
   If   sFileTo  =
      sFileTo := A_ScriptDir . "\screen.bmp"
   SplitPath, sFileTo, , sDirTo, sExtTo, sNameTo

   If Not   hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll")
      Return   sFileFr+0 ? SaveHBITMAPToFile(sFileFr, sDirTo . "\" . sNameTo . ".bmp") : ""
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)

   If   !sFileFr
   {
      DllCall("OpenClipboard", "Uint", 0)
      If    DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2))
      DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", hBM, "Uint", 0, "UintP", pImage)
      DllCall("CloseClipboard")
   }
   Else If   sFileFr Is Integer
      DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", sFileFr, "Uint", 0, "UintP", pImage)
   Else   DllCall("gdiplus\GdipLoadImageFromFile", "Uint", Unicode4Ansi(wFileFr,sFileFr), "UintP", pImage)

   DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
   VarSetCapacity(ci,nSize,0)
   DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "Uint", &ci)
   Loop, %   nCount
      If   InStr(Ansi4Unicode(NumGet(ci,76*(A_Index-1)+44)), "." . sExtTo)
      {
         pCodec := &ci+76*(A_Index-1)
         Break
      }
   If   InStr(".JPG.JPEG.JPE.JFIF", "." . sExtTo) && nQuality<>"" && pImage && pCodec
   {
   DllCall("gdiplus\GdipGetEncoderParameterListSize", "Uint", pImage, "Uint", pCodec, "UintP", nSize)
   VarSetCapacity(pi,nSize,0)
   DllCall("gdiplus\GdipGetEncoderParameterList", "Uint", pImage, "Uint", pCodec, "Uint", nSize, "Uint", &pi)
   Loop, %   NumGet(pi)
      If   NumGet(pi,28*(A_Index-1)+20)=1 && NumGet(pi,28*(A_Index-1)+24)=6
      {
         pParam := &pi+28*(A_Index-1)
         NumPut(nQuality,NumGet(NumPut(4,NumPut(1,pParam+0)+20)))
         Break
      }
   }

   If   pImage
      pCodec   ? DllCall("gdiplus\GdipSaveImageToFile", "Uint", pImage, "Uint", Unicode4Ansi(wFileTo,sFileTo), "Uint", pCodec, "Uint", pParam) : DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Uint", pImage, "UintP", hBitmap, "Uint", 0) . SetClipboardData(hBitmap), DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)

   DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
   DllCall("FreeLibrary", "Uint", hGdiPlus)
}

CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
   NumPut(0,  bi,16)
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", 0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

SaveHBITMAPToFile(hBitmap, sFile)
{
   DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
   hFile:=   DllCall("CreateFile", "Uint", &sFile, "Uint", 0x40000000, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 0, "Uint", 0)
   DllCall("WriteFile", "Uint", hFile, "int64P", 0x4D42|14+40+NumGet(oi,44)<<16, "Uint", 6, "UintP", 0, "Uint", 0)
   DllCall("WriteFile", "Uint", hFile, "int64P", 54<<32, "Uint", 8, "UintP", 0, "Uint", 0)
   DllCall("WriteFile", "Uint", hFile, "Uint", &oi+24, "Uint", 40, "UintP", 0, "Uint", 0)
   DllCall("WriteFile", "Uint", hFile, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44), "UintP", 0, "Uint", 0)
   DllCall("CloseHandle", "Uint", hFile)
}

SetClipboardData(hBitmap)
{
   DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
   hDIB :=   DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
   pDIB :=   DllCall("GlobalLock", "Uint", hDIB)
   DllCall("RtlMoveMemory", "Uint", pDIB, "Uint", &oi+24, "Uint", 40)
   DllCall("RtlMoveMemory", "Uint", pDIB+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
   DllCall("GlobalUnlock", "Uint", hDIB)
   DllCall("DeleteObject", "Uint", hBitmap)
   DllCall("OpenClipboard", "Uint", 0)
   DllCall("EmptyClipboard")
   DllCall("SetClipboardData", "Uint", 8, "Uint", hDIB)
   DllCall("CloseClipboard")
}

Unicode4Ansi(ByRef wString, sString)
{
   nSize := DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
   VarSetCapacity(wString, nSize * 2)
   DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize)
   Return   &wString
}

Ansi4Unicode(pString)
{
   nSize := DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
   VarSetCapacity(sString, nSize)
   DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
   Return   sString
}

/*
=========== MORE FUNCTIONS
*/

makeProperBoundary(){
   Loop,26
      n .= chr(64+a_index)
   n .= "0123456789"
   Loop,% StrLen(A_Now) {
      Random,rnd,1,% StrLen(n)
      Random,UL,0,1
      b .= RegExReplace(SubStr(n,rnd,1),".$","$" (round(UL)? "U":"L") "0")
   }
   Return b
}

MimeType(ByRef Binary) {
   MimeTypes:="424d image/bmp|4749463 image/gif|ffd8ffe image/jpeg|89504e4 image/png|4657530"
          . " application/x-shockwave-flash|49492a0 image/tiff"
   @:="0123456789abcdef"
   Loop,8
      hex .= substr(@,(*(a:=&Binary-1+a_index)>>4)+1,1) substr(@,((*a)&15)+1,1)
   Loop,Parse,MimeTypes,|
      if ((substr(hex,1,strlen(n:=RegExReplace(A_Loopfield,"\s.*"))))=n)
         Mime := RegExReplace(A_LoopField,".*?\s")
   Return (Mime!="") ? Mime : "application/octet-stream"
}
; START OF "Include" part (HttpQuery)
; Requires httpQuery to be in your standard library OR to be included
; httpQuery-0-3-5.ahk

/*
 *====================================================================================
 *                           END OF FILE
 *====================================================================================
 */