#NoEnv

#Persistent
IfNotExist, %A_Temp%\Cursor.ani
 FileInstall, Cursor.ani, %A_Temp%\Cursor.ani, 1
Random, Temp1, -5000, -10000
SetTimer, CursorOn, %Temp1%
Return

CursorOn:
SetCursor(A_Temp . "\Cursor.ani")
Sleep, 500
RestoreCursors()
Random, Temp1, -5000, -10000
SetTimer, CursorOn, %Temp1%
Return

SetCursor(CursorFile)
{
 SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
 If !(InStr("`n.cur`n.ani`n","`n" . SubStr(CursorFile,-3) . "`n") && FileExist(CursorFile))
  Return, 1
 Loop, Parse, SystemCursors, CSV
  FileCursor%A_Index% := DllCall("LoadImageA","UInt",0,"Str",CursorFile,"UInt",0x2,"Int",0,"Int",0,"UInt",0x10), DllCall("SetSystemCursor","UInt",FileCursor%A_Index%,"Int",SubStr(A_Loopfield,1,5))
}

RestoreCursors()
{
 DllCall("SystemParametersInfo","UInt",0x57,"UInt",0,"UInt",0,"UInt",0)
}