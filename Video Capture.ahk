hModule := DllCall("LoadLibrary", "str", "avicap32.dll")

WDT := 320
HGT := 240
FPS := 15
fileJPG = vidcap.jpg
fileBMP = vidcap.bmp

Gui, Add, GroupBox, x4 y4 w492 h100, Available Video Drivers
Gui, Add, ListView, x8 y20 w400 h80 gSelectDriver vCapDriversLV, Index|Name
Gui, Add, Picture, x434 y16 w32 h32 Icon204, %A_WinDir%\system32\shell32.dll
Gui, Add, Button, x412 y50 w80 h24 gRefreshDrivers, Refresh
Gui, Add, Button, x412 y76 w80 h24 gSelectDriver vSelectDriverB, Select

; --- Video preview section of Gui
Gui, Add, GroupBox, x4 y108 w492 h262, Video
Gui, Add, CheckBox, x10 y120 w100 h24 vPreviewToggleState gPreviewToggle, Preview video
Gui, Add, Text, x10 y160, width:
Gui, Add, Edit, x70 y160 w30 vWDT gdoWDT, %WDT%
Gui, Add, Text, x10 y190, height:
Gui, Add, Edit, x70 y190 w30 vHGT gdoGHT, %HGT%
Gui, Add, Text, x10 y220, fps:
Gui, Add, Edit, x70 y220 w30 vFPS gdoFPS, %FPS%
Gui, Add, Button, x110 y190 h24 gPreviewToggle, Change
Gui, Add, Button, x400 y160 h24 gCopyToClipBoard, Copy
Gui, Add, Text, x240 y193, Desktop\
Gui, Add, Edit, x290 y190 w100 vfileJPG gdoJPG, %fileJPG%
Gui, Add, Button, x400 y190 h24 gSenToFile2, Send to &JPG
Gui, Add, Text, x240 y223, Desktop\
Gui, Add, Edit, x290 y220 w100 vfileBMP gdoBMP, %fileBMP%
Gui, Add, Button, x400 y220 h24 gSenToFile, Send to &BMP

GoSub, RefreshDrivers

Gui, Show, x200 w500 h400, Video For Windows for AutoHotkey - VFW4AHK

Return



doWDT:
   ControlGetText,WDT,Edit1,A
Return

doGHT:
   ControlGetText,HGT,Edit2,A
Return

doJPG:
   ControlGetText,fileJPG,Edit4,A
Return

doBMP:
   ControlGetText,fileBMP,Edit5,A
Return

doFPS:
   ControlGetText,FPS,Edit3,A
Return

PreviewToggle:
  ControlGet,PreviewToggleState,Checked,,Button5,A
  If PreviewToggleState
  {
   Gui, 2:Destroy
   Gui, 2:Add, Text, x0 y0 w%WDT% h%HGT% vVidPlaceholder
   GuiControl, +0x7, VidPlaceholder ; frame
   Gui 2:+LastFound
   hwndParent := WinExist()
   Gui, 2:Show, x750 w%WDT% h%HGT%, Viewer
    GoSub ConnectToDriver
  }
  Else
  {
   Gui, 2:Destroy
    GoSub DisconnectDriver
  }
Return


ConnectToDriver:
  ; --- Connect and preview - hwnd, x, y, w, h
  capHwnd := Cap_CreateCaptureWindow(hwndParent, 0, 0, WDT, HGT)

  WM_USER = 0x0400
  WM_CAP_START := WM_USER
  WM_CAP_GRAB_FRAME_NOSTOP := WM_USER + 61
  WM_CAP_FILE_SAVEDIB := WM_CAP_START + 25

  WM_CAP := 0x400
  WM_CAP_DRIVER_CONNECT := WM_CAP + 10
  WM_CAP_DRIVER_DISCONNECT := WM_CAP + 11
  WM_CAP_EDIT_COPY := WM_CAP + 30
  WM_CAP_SET_PREVIEW := WM_CAP + 50
  WM_CAP_SET_PREVIEWRATE := WM_CAP + 52
  WM_CAP_SET_SCALE := WM_CAP + 53
 
  ; Connect to driver
  if SelectedDriver =
  {
   if foundDriver
      SelectedDriver = 0
   else
   {
       MsgBox, 16, Error!, You didn't select a video driver`, and there seems to be no driver present.
       Return
   }
  }
  SendMessage, WM_CAP_DRIVER_CONNECT, %SelectedDriver%, 0, , ahk_id %capHwnd%
 
  ; Set the preview scale
  SendMessage, WM_CAP_SET_SCALE, 1, 0, , ahk_id %capHwnd%
 
  ; Set the preview rate in milliseconds
  MSC := round((1/FPS)*1000)
  SendMessage, WM_CAP_SET_PREVIEWRATE, MSC, 0, , ahk_id %capHwnd%
 
  ; Start previewing the image from the camera
  SendMessage, WM_CAP_SET_PREVIEW, 1, 0, , ahk_id %capHwnd%
 
Return



CopyToClipBoard:
  SendMessage, WM_CAP_EDIT_COPY, 0, 0, , ahk_id %capHwnd%
Return


SenToFile2:
   SendMessage, WM_CAP_EDIT_COPY, 0, 0, , ahk_id %capHwnd%
    RunWait, C:\Program Files\IrfanView\i_view32.exe /clippaste /convert=%A_Desktop%\%fileJPG%   ;copies from clipboard to file
Return


SenToFile:
    imagefile = %A_Desktop%\%fileBMP%
    SendMessage, WM_CAP_FILE_SAVEDIB, 0, &imagefile, , ahk_id %capHwnd%
return


DisconnectDriver:
  SendMessage, WM_CAP_DRIVER_DISCONNECT, 1, 0, , ahk_id %capHwnd%
Return


RefreshDrivers:
  foundDriver = 0
  LV_Delete()
  Loop
  {
    thisInfo := Cap_GetDriverDescription(A_Index-1)
    If thisInfo
    {
      foundDriver = 1
      LV_Add("", A_Index-1, thisInfo)
    }
    Else
      Break
  }
  If !foundDriver
  {
    LV_Delete()
    LV_Add("", "", "Could not get video drivers")
    GuiControl, Disable, CapDriversLV
    GuiControl, Disable, SelectDriverB
  }
Return
 
 
SelectDriver:
  FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
  if not FocusedRowNumber  ; No row is focused.
    return
  LV_GetText(SelectedDriver, FocusedRowNumber, 1)
Return


Cap_CreateCaptureWindow(hWndParent, x, y, w, h)
{
  WS_CHILD := 0x40000000
  WS_VISIBLE := 0x10000000
 
  lpszWindowName := "test"
 
  lwndC := DLLCall("avicap32.dll\capCreateCaptureWindowA"
                  , "Str", lpszWindowName
                  , "UInt", WS_VISIBLE | WS_CHILD ; dwStyle
                  , "Int", x
                  , "Int", y
                  , "Int", w
                  , "Int", h
                  , "UInt", hWndParent
                  , "Int", 0)
 
  Return lwndC
}


Cap_GetDriverDescription(wDriver)
{
  VarSetCapacity(lpszName, 100)
  VarSetCapacity(lpszVer, 100)
  res := DLLCall("avicap32.dll\capGetDriverDescriptionA"
                  , "Short", wDriver
                  , "Str", lpszName
                  , "Int", 100
                  , "Str", lpszVer
                  , "Int", 100)
  If res
    capInfo := lpszName ; " | " lpszVer
  Return capInfo
}


GuiClose:
  GoSub, DisconnectDriver
  DllCall("FreeLibrary", "str", hModule)
  ExitApp
Return