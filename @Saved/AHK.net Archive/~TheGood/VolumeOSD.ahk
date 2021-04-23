/*! TheGood
    VolumeOSD - A volume OSD using GDI+
*/

;This script requires tic's amazing GDI+ wrapper which can be found at:
;http://www.autohotkey.com/forum/viewtopic.php?t=32238

;Needed for SendMessage to work properly
DetectHiddenWindows, On

;You first need to start up GDI+
pToken := Gdip_Startup()

;Check for error
If Not pToken {
   MsgBox, 16, VolumeOSD, % "GDI+ failed to start. Please ensure you have GDI+ on your system." ;%
    . "`nThe program will now exit."
   ExitApp
}

;So that we can shutdown GDI+ nicely
OnExit, ExitingApp

;Create a layered window
Gui, 1:-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
hGui1 := WinExist()
Gui, 2:-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
hGui2 := WinExist()
Gui, 3:-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
hGui3 := WinExist()

;Get the current data so that it won't automatically show on startup
SoundGet, iOldMaster, Master, Volume
SoundGet, bOldMaster, Master, Mute
SoundGet, iOldWave, Wave, Volume
SoundGet, bOldWave, Wave, Mute

;Check if Winamp exists
hWinamp := WinExist("ahk_class Winamp v1.x")
If hWinamp {
    SendMessage 0x400, -666, 122,, ahk_id %hWinamp%
    iOldWinamp := (ErrorLevel / 255) * 100
}

;Main loop
Loop {
   
    ;Get master volume and update OSD
    SoundGet, iMaster, Master, Volume
    SoundGet, bMaster, Master, Mute
   
    ;Check for changes
    If (iMaster <> iOldMaster) Or (bOldMaster <> bMaster) {
        VolumeOSD(hGui1, (A_ScreenWidth - 200) / 2, (A_ScreenHeight - 170) / 2, "Master Volume", iMaster
        , Round(iMaster) "%", 0xFFCCCCCC, (bMaster = "OFF") ? 0xFF0F0FFF : 0xFFFF0000, 0xFF000000, 0xFFFFFFFF)
        iLastMaster := A_TickCount
    }
   
    iOldMaster := iMaster
    bOldMaster := bMaster
   
    ;Get wave volume and update OSD
    SoundGet, iWave, Wave, Volume
    SoundGet, bWave, Wave, Mute
   
    ;Check for changes
    If (iWave <> iOldWave) Or (bOldWave <> bWave) {
        VolumeOSD(hGui2, (A_ScreenWidth - 200) / 2, ((A_ScreenHeight - 170) / 2) + 60, "Wave Volume", iWave
        , Round(iWave) "%", 0xFFCCCCCC, (bWave = "OFF") ? 0xFF0F0FFF : 0xFFFF0000, 0xFF000000, 0xFFFFFFFF)
        iLastWave := A_TickCount
    }
   
    iOldWave := iWave
    bOldWave := bWave
   
    If hWinamp {
       
        ;Get Winamp volume and update OSD
        SendMessage 0x400, -666, 122,, ahk_id %hWinamp%
        iWinamp := (ErrorLevel / 255) * 100
       
        ;Check for changes
        If (iWinamp <> iOldWinamp) {
            VolumeOSD(hGui3, (A_ScreenWidth - 200) / 2, ((A_ScreenHeight - 170) / 2) + 120, "Winamp Volume", iWinamp
            , Round(iWinamp) "%", 0xFFCCCCCC, 0xFF0F0FFF, 0xFF000000, 0xFFFFFFFF)
            iLastWinamp := A_TickCount
        }
       
        iOldWinamp := iWinamp
    }
   
    ;Check if we can leave
    If (A_TickCount - iLastMaster > 1000)
        Gui, 1:Hide
    If (A_TickCount - iLastWave > 1000)
        Gui, 2:Hide
    If (A_TickCount - iLastWinamp > 1000)
        Gui, 3:Hide
   
    ;Get some sleep
    Sleep, 50
}

;hwnd       - Handle of the GUI
;iX         - X coordinate of the GUI
;iY         - Y coordinate of the GUI
;sText      - Text to display
;iProgress  - Percentage value of the progress bar (eg. 50) - can have decimals
;sProgText  - Text to display on top of the progress bar
;cText      - Forecolor of sText in ARGB
;cProgFill  - Color of the progress bar in ARGB
;cProgShape - Color of the outline of the progress bar in ARGB
;cPercent   - Forecolor of sProgText in ARGB
VolumeOSD(hwnd, iX, iY, sText, iProgress, sProgText, cText, cProgFill, cProgShape, cPercent) {
    iW := 200, iH := 50
   
    ;Create a GDI bitmap
    hbm := CreateDIBSection(iW, iH)
   
    ;Get a device context compatible with the screen
    hdc := CreateCompatibleDC()
   
    ;Select the bitmap into the device context
    obm := SelectObject(hdc, hbm)
   
    ;Get a pointer to the graphics of the bitmap, for use with drawing functions
    G := Gdip_GraphicsFromHDC(hdc)
   
    ;Set the smoothing mode to antialias = 4 to make shapes appear smother
    Gdip_SetSmoothingMode(G, 4)
   
    ;Create a partially transparent to draw a rounded rectangle with
    pBrush := Gdip_BrushCreateSolid(0xCC000000)
   
    ;Fill the graphics of the bitmap with a rounded rectangle using the brush created
    Gdip_FillRoundedRectangle(G, pBrush, 0, 0, iW, iH, 10)
   
    ;Delete the brush as it is no longer needed and wastes memory
    Gdip_DeleteBrush(pBrush)
   
    ;Fix cText and cPercent so that they become option compatible with Gdip_TextToGraphic()
    cText := "c" SubStr(cText, 3), cPercent := "c" SubStr(cPercent, 3)
   
    ;Draw the main text at (6, 6) in specified color with AA at size 16
    Options = x6 y6 %cText% r4 s16
    Gdip_TextToGraphics(G, sText, Options, "Arial")
   
    ;It's now time to fill the shape. Prepare a brush
    pBrush := Gdip_BrushCreateSolid(cProgFill)
   
    ;Fill the shape
   Gdip_FillRoundedRectangle(G, pBrush, 8, 28, (iProgress / 100) * (iW - 16), 15, (iProgress >= 2) ? 2 : 0)
   
    ;We're done with the brush now
    Gdip_DeleteBrush(pBrush)
   
    ;Create a pen for the outline of the progress bar
    pBorderPen := Gdip_CreatePen(cProgShape, 1)
   
    ;We can now draw the outline
    Gdip_DrawRoundedRectangle(G, pBorderPen, 8, 28, iW - 16, 15, 2)
   
    ;We're done with the pen now
    Gdip_DeletePen(pBorderPen)
   
    ;Draw the progress bar text over the progress bar in specified color with AA at size 10
    Options := "x8 y29 h14 w" (iW - 16) " " cPercent " r4 s12 Center Bold"
    Gdip_TextToGraphics(G, sProgText, Options, "Arial")
   
    ;Update the specified window we have created with a handle to our bitmap
    UpdateLayeredWindow(hwnd, hdc, iX, iY, iW, iH)
   
    ; Select the object back into the hdc
    SelectObject(hdc, obm)
   
    ; Now the bitmap may be deleted
    DeleteObject(hbm)
   
    ; Also the device context related to the bitmap may be deleted
    DeleteDC(hdc)
   
    ; The graphics may now be deleted
    Gdip_DeleteGraphics(G)
   
    ;Show the GUI if it's not showing already
    If Not DllCall("IsWindowVisible", "UInt", hwnd)
        DllCall("ShowWindow", "UInt", hwnd, "UInt", 8)  ;SW_SHOWNA
   
    Return
}

;Shutdown GDI+ and get out
ExitingApp:
    Gdip_Shutdown(pToken)
    ExitApp
Return