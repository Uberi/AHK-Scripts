/* TheGood
Wallpaper Changer
*/

#NoTrayIcon
#NoEnv

;Make sure the program is registered as a startup item
;If not compiled, prepend "[path to autohotkey.exe]"%A_Space%" to "%A_ScriptFullPath%"%A_Space%"startup"
RegWrite REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Run, WPChanger, "%A_ScriptFullPath%"%A_Space%"startup"

;Get settings
RegRead sDir, HKCU, SOFTWARE\AutoHotkey, Dir
RegRead bStartupChange, HKCU, SOFTWARE\AutoHotkey, StartupChange
RegRead iDayWait, HKCU, SOFTWARE\AutoHotkey, DayWait
RegRead bRand, HKCU, SOFTWARE\AutoHotkey, Random
RegRead bStretch, HKCU, SOFTWARE\AutoHotkey, Stretch
RegRead bRecurse, HKCU, SOFTWARE\AutoHotkey, Recurse

;Set defaults if there's no reg settings
bStartupChange := (bStartupChange = "") ? False : bStartupChange
iDayWait := (iDayWait = "") ? 1 : iDayWait
bRand := (bRand = "") ? True : bRand
bStretch := (bStretch = "") ? True : bStretch
bRecurse := (bRecurse = "") ? False : bRecurse
sTemp := A_AppData . "\Microsoft\Windows\wp.bmp"

;Get current wallpaper
RegRead sCurrentWP, HKCU, Control Panel\Desktop, OriginalWallpaper

;Check if launch was at startup
If (%1% := "startup") {
   
   ;Check if we have a directory
   If (sDir = "")
      ExitApp
      
   ;Check if day changing is enabled
   If bStartupChange
      bChange := True
   Else {
      
      ;Retrieve last time the wallpaper has been changed
      RegRead, iDays, HKCU, SOFTWARE\Autohotkey, LastWPChange

      ;Check if a change is needed
      If ErrorLevel
         bChange := True
      Else {   
         If ((A_YDay - iDays) >= iDayWait)
            bChange := True
         Else If (A_YDay < iDays)   ;We changed year
            bChange := True
         Else
            bChange := False
      }
   }
   
   ;Remove that section if you don't need that functionality
   ;Check if the user is forcing anything
   If (GetKeyState("LShift"))
      bChange := True
   Else If (GetKeyState("LCtrl"))
      bChange := False
   
   ;Change if needed
   if bChange {
      
      ;Check if we're going randomly
      If bRand {
         
         ;Count the number of wallpapers
         Loop %sDir%\*.*, 0, %bRecurse%
            If A_LoopFileExt in jpg,jpeg,bmp
               iCount += 1
         
         ;Get random number
         Random, iRand, 1, iCount
         
         ;Get chosen wallpaper
         Loop %sDir%\*.*, 0, %bRecurse%
         {
            If A_LoopFileExt in jpg,jpeg,bmp
               iPos += 1
            
            If (iPos = iRand) {
               sChosenWP := A_LoopFileLongPath
               Break
            }
         }
      
      ;We're going sequentially
      } Else {

         ;Check if the current wallpaper is in the given directory
         If InStr(sCurrentWP, sDir) {
            
            ;Find its position
            bFound := False
            Loop %sDir%\*.*, 0, %bRecurse%
            {
               If bFound {
                  If A_LoopFileExt in jpg,jpeg,bmp
                  {
                     sChosenWP := A_LoopFileLongPath
                     Break
                  }
               }
               
               If (A_LoopFileLongPath = sCurrentWP)
                  bFound := True
            }
                     
         ;It's not in the given directory. Choose the first pic
         } Else {
            
            Loop %sDir%\*.*, 0, %bRecurse%
            {
               If A_LoopFileExt in jpg,jpeg,bmp
               {
                  sChosenWP := A_LoopFileLongPath
                  Break
               }
            }
         }
      }
      
      ;Change wallpaper
      pToken := Gdip_Startup()
      ConvertImage(sChosenWP, sTemp)
      Gdip_Shutdown(pToken)
      RegWrite REG_SZ, HKCU, Control Panel\Desktop, OriginalWallpaper, %sChosenWP%
      RegWrite REG_SZ, HKCU, Control Panel\Desktop, Wallpaper, %sTemp%
      RegWrite REG_SZ, HKCU, Control Panel\Desktop, TileWallpaper, 0
      RegWrite REG_SZ, HKCU, Control Panel\Desktop, WallpaperStyle, % (bStretch ? 2 : 0)
      DllCall("SystemParametersInfoA", int, 20, int, 0, int, &sTemp, int, 3)   ;%
      
      ;Update value
      RegWrite, REG_DWORD, HKCU, SOFTWARE\AutoHotkey, LastWPChange, %A_YDay%
      
   }

;We have to show the GUI   
} Else {
   
   ;Build GUI
   Gui, -MinimizeBox -MaximizeBox -Resize
   Gui, Add, Text, x7 y13 w47 h15, Folder:
   Gui, Add, Edit, x56 y10 w240 h20 +ReadOnly -Multi vtxtDir, %sDir%
   Gui, Add, Button, x306 y10 w30 h20 gbtnBrowse, ...
   Gui, Add, CheckBox, x56 y30 w240 h20 vchkRecurse, Include subdirectories
   Gui, Add, Radio, x6 y60 w130 h20 voptDays goptDaysChecked, Change wallpaper every
   Gui, Add, Radio, x6 y90 w330 h20 voptStartup goptStartupChecked, Change wallpaper when the computer starts
   Gui, Add, Edit, x139 y61 w30 h18 +Number -Multi vtxtDays, %iDayWait%
   Gui, Add, Text, x177 y64 w33 h13, day(s)
   Gui, Add, CheckBox, x6 y110 w330 h20 vchkStretch, Stretch wallpaper (leave unchecked to center)
   Gui, Add, CheckBox, x6 y130 w330 h20 vchkRandom, Select in random order
   Gui, Add, Button, x236 y160 w100 h30 gbtnOK, &OK
   Gui, Add, Button, x116 y160 w100 h30 gbtnCancel, Cancel

   ;Set values
   GuiControl,, chkRecurse, %bRecurse%
   GuiControl,, % (bStartupChange ? "optStartup" : "optDays"), 1   ;%
   GuiControl,, chkStretch, %bStretch%
   GuiControl,, chkRandom, %bRand%
   GuiControl, % (bStartupChange ? "Disable" : "Enable"), txtDays   ;%
   
   ;Show GUI
   Gui, Show, x131 y91 h202 w349, Wallpaper Changer
   Return
   

}

;We're done
GuiClose:
btnCancel:
ExitApp

btnBrowse:
   FileSelectFolder, sDir, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, 0, Select folder containing wallpapers
   If Not ErrorLevel
      GuiControl,, txtDir, %sDir%
Return

optDaysChecked:
   GuiControl, Enable, txtDays
Return

optStartupChecked:
   GuiControl, Disable, txtDays
Return

btnOK:
   
   ;Write data back to the registry
   Gui Submit
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, Dir, %txtDir%
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, StartupChange, %optStartup%
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, DayWait, %txtDays%
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, Random, %chkRandom%
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, Stretch, %chkStretch%
   RegWrite REG_SZ, HKCU, SOFTWARE\AutoHotkey, Recurse, %chkRecurse%
   
   ;Done
   ExitApp
   
Return

;###############################################################################################################
;
; ConvertImage() by Tariq Porter (tic) 04/05/08
; Version:      1.01
;
; sInput:         Location of the input file to be converted. May be of filetype jpg,bmp,png,tiff,gif
; sOutput:      Location to save the converted file. Extension determines the output filetype jpg,bmp,png,tiff,gif
; Width:        Width either in pixels or percentage (depending on Method) to save the converted file
; Height:         Height either in pixels or percentage (depending on Method) to save the converted file
;            Width or Height may also be -1 to keep the aspect ratio the same
; Method:         Can either be "Percent" or "Pixels" to determine the width and height of the converted file
;
; Return:      0=Success; -1=Could not create a bitmap from file; -2=Source file has no width or height
;            -3=Resize method must be either Precentage or Pixels; -4=Error resizing image;
;            -5=Could not get a list of filetype encoders on the system; -6=Could not find matching codec
;            -7=Wide file output could not be created; -8=File could not be written to disk

;###############################################################################################################

Gdip_Startup()
{
   If !DllCall("GetModuleHandle", "Str", "gdiplus")
   DllCall("LoadLibrary", "Str", "gdiplus")
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UInt*", pToken, "UInt", &si, "UInt", 0)
   VarSetCapacity(si, 0)
   Return, pToken
}

;###############################################################################################################

Gdip_Shutdown(pToken)
{
   DllCall("gdiplus\GdiplusShutdown", "UInt", pToken)
   If hModule := DllCall("GetModuleHandle", "Str", "gdiplus")
   DllCall("FreeLibrary", "UInt", hModule)
   Return, 0
}

;###############################################################################################################

ConvertImage(sInput, sOutput, Width="", Height="", Method="Percent")
{
   StringSplit, OutputArray, sOutput, .
    Extension := "." OutputArray%OutputArray0%
   
   VarSetCapacity(wInput, 1023)
   DllCall("kernel32\MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sInput, "Int", -1, "UInt", &wInput, "Int", 512)
   DllCall("gdiplus\GdipCreateBitmapFromFile", "UInt", &wInput, "UInt*", pBitmap)
   If !pBitmap
   Return, -1
   
   If (Width && Height)
   {
      DllCall("gdiplus\GdipGetImageWidth", "UInt", pBitmap, "UInt*", sWidth)
      DllCall("gdiplus\GdipGetImageHeight", "UInt", pBitmap, "UInt*", sHeight)
      If !(sWidth && sHeight)
      {
         DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
         Return, -2
      }
         
      If (Method = "Percent")
      {
         Width := (Width = -1) ? Height : Width, Height := (Height = -1) ? Width : Height
         dWidth := Round(sWidth*(Width/100)), dHeight := Round(sHeight*(Height/100))
      }
      Else If (Method = "Pixels")
      {
         If (Width = -1)
         dWidth := Round((Height/sHeight)*sWidth), dHeight := Height
         Else If (Height = -1)
         dHeight := Round((Width/sWidth)*sHeight), dWidth := Width
         Else
         dWidth := Width, dHeight := Height
      }
      Else
      {
         DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
         Return, -3
      }
     
      DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", dWidth, "Int", dHeight, "Int", 0, "Int", 0x26200A, "UInt", 0, "UInt*", FpBitmap)
      DllCall("gdiplus\GdipGetImageGraphicsContext", "UInt", FpBitmap, "UInt*", G)
      DllCall("gdiplus\GdipSetInterpolationMode", "UInt", G, "Int", 7)
     
      E := DllCall("gdiplus\GdipDrawImageRectRectI", "UInt", G, "UInt", pBitmap
      , "Int", 0, "Int", 0, "Int", dWidth, "Int", dHeight
      , "Int", 0, "Int", 0, "Int", sWidth, "Int", sHeight
      , "Int", 2, "UInt", ImageAttr, "UInt", 0, "UInt", 0)
     
      DllCall("gdiplus\GdipDeleteGraphics", "UInt", G)
      DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
      pBitmap := FpBitmap
      
      If E
      {
         DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
         Return, -4
      }
   }
   
   DllCall("gdiplus\GdipGetImageEncodersSize", "UInt*", nCount, "UInt*", nSize)
    VarSetCapacity(ci, nSize)
    DllCall("gdiplus\GdipGetImageEncoders", "UInt", nCount, "UInt", nSize, "UInt", &ci)
   If !(nCount && nSize)
   {
      DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
      Return, -5
   }
   
    Loop, %nCount%
    {
        nSize := DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0, "UInt", NumGet(ci, 76*(A_Index-1)+44), "Int", -1, "UInt", 0, "Int",  0, "UInt", 0, "UInt", 0)
        VarSetCapacity(sString, nSize)
        DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0, "UInt", NumGet(ci, 76*(A_Index-1)+44), "Int", -1, "Str", sString, "Int", nSize, "UInt", 0, "UInt", 0)
   
        If !InStr(sString, Extension)
        Continue
        pCodec := &ci+76*(A_Index-1)
        Break
    }
   If !pCodec
   {
      DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
      Return, -6
   }
   
   nSize := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sOutput, "Int", -1, "UInt", 0, "Int", 0)
   VarSetCapacity(wOutput, nSize*2)
   DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sOutput, "Int", -1, "UInt", &wOutput, "Int", nSize)
   VarSetCapacity(wOutput, -1)
   If !VarSetCapacity(wOutput)
   {
      DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
      Return, -7
   }

   E := DllCall("gdiplus\GdipSaveImageToFile", "UInt", pBitmap, "UInt", &wOutput, "UInt", pCodec, "UInt", 0)
   DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
   If E
   DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
   Return, E ? -8 : 0
}