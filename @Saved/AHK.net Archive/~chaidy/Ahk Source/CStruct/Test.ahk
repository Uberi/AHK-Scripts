#include CStruct.ahk
#SingleInstance Force
#NoEnv

^\::ExitApp

;show 'used structure class' template
F5::CStruct_Base.TreeView()


F8::    ;** NOTIFYICONDATA struct **
   ; tray icon change to notepad.ext main icon.
   FileName := "c:\windows\notepad.exe"
   NID := new CNotifyIconData
   NID.hwnd := DllCall( "FindWindow", Str,"AutoHotkey" , Str, A_ScriptFullPath ( A_IsCompiled ? "" : " - AutoHotkey v" A_AhkVersion ) )
   NID.uID := 1028
   NID.uFlags := 0x2|0x4
   NID.szTip := "tooltip test..."
   NID.hIcon := DllCall("Shell32\ExtractAssociatedIcon" (A_IsUnicode ? "W" : "A")
         , ptr, DllCall("GetModuleHandle", ptr, 0, ptr), str, FileName, "ushort*", lpiIcon, ptr) 
   NID.TreeView("NOTIFYICONDATA struct") ; <<== checking struct data.
   DllCall( "shell32\Shell_NotifyIcon" (A_IsUnicode? "W":"A"), UInt,0x1, UInt,NID[""] )
   DllCall( "DestroyIcon", UInt,NID.hIcon )
return


F9::    ;** DISPLAYDEVICE struct **
   DisplayDevice := new CDisplayDevice
   DllCall("EnumDisplayDevices", "PTR",0 , UINT,0 , Ptr,DisplayDevice[""] , UINT,0)
   DisplayDevice.TreeView("DISPLAYDEVICE struct ")
return


F10::   ;** WINDOWINFO struct **
   WinGet, hwnd, id, A
   WI := new CWindowInfo  ;CWindowInfo has 2 CRect member.
   DllCall("user32.dll\GetWindowInfo", "Ptr", hwnd, "Ptr", WI.ptr)
   
   Gui, Destroy
   Gui, +LastFound
   Gui, Add, ListView, w400 h200 r9 NoSortHdr, Key       |Value1     |Value2|Value3|Value4
   Gui, Show,, WINDOWINFO
   LV_Add("", "Window", WI.rcWindow.left, WI.rcWindow.top, WI.rcWindow.right, WI.rcWindow.bottom)
   LV_Add("", "Client", WI.rcClient.left, WI.rcClient.top, WI.rcClient.right, WI.rcClient.bottom)
   LV_Add("", "Styles", WI.dwStyle)
   LV_Add("", "ExStyles", WI.dwExStyle)
   LV_Add("", "Status", WI.dwWindowStatus)
   LV_Add("", "XBorders", WI.cxWindowBorders)
   LV_Add("", "YBorders", WI.cyWindowBorders)
   LV_Add("", "Type", WI.atomWindowType)
   LV_Add("", "Version", WI.wCreatorVersion)
   WI.TreeView("WINDOWINFO struct")
Return


F11::   ;** WINDOWPLACEMENT struct **
   ; movement selected window)
   WinGet, hwnd, id, A
   WP := new CWindowPlacement
   DllCall("user32.dll\GetWindowPlacement", "Uint", hwnd, "Ptr", WP.ptr)
   WP.rcNormalPosition.left  += 5
   WP.rcNormalPosition.right += 5
   DllCall("user32.dll\SetWindowPlacement", "Uint", hwnd, "Ptr", WP.ptr)
return


F12::   ;** SYSTEMTIME & TIMEZONEINFOMATION struct **
   timezone := new CTimeZoneInformation
   DllCall("kernel32.dll\GetTimeZoneInformation", "Ptr", timezone.ptr)
   str := "<timezone>`n" timezone.tostring()
   
   systemTime := new CSystemTime
   DllCall("kernel32.dll\GetLocalTime", "Ptr", systemTime.ptr)
   str .= "`n`n<systemtime>`n" systemTime.tostring()
     
   ;struct member modify
   timezone.StandardDate := systemTime
   timezone.TreeView("SYSTEMTIME & TIMEZONEINFOMATION struct")
   MsgBox, % str "`n`n<data modify>`nsystemTime -> timezone.StandardDate`n"timezone.tostring()
return



*/