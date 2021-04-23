/*                _         _     _
   /\  /\__ _ ___| |__     (_)___| |__   String/File Hash Generator GUI for CRC32/MD5/SHA1
  / /_/ / _` / __| '_ \ ___| / __| '_ \                                  v1.0, 12-Oct-2012
 / __  / (_| \__ \ | | |___| \__ \ | | |
 \/ /_/ \__,_|___/_| |_|   |_|___/_| |_|                            SKAN, Suresh Kumar A N
                                                                  arian.suresh @ gmail.com
 -----------------------------------------------------------------------------------------
 http://www.autohotkey.com/community/viewtopic.php?t=93900
 http://tinyurl.com/skanbox/AutoHotkey/Hashish/v1.0/Hashish.ahk
 _________________________________________________________________________________________
*/

#SingleInstance, Force
Filepath = %1%
SetWorkingDir  % A_ScriptDir
DllCall( "LoadLibrary", Str,"advapi32.dll" )
DllCall( "LoadLibrary", Str,"ntdll.dll" )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Config begin

BG_COLOR   := 0xD8D8D8
FG_COLOR   := 0x111111
EditW      := 375
HexCase    := "UpperCase"
Settings   := "Hashish" ( A_IsUnicode ? "W" : "A" ) ".ini"
FileFolder := "::{20d04fe0-3aea-1069-a2d8-08002b30309d}"

OnMessage( 0x138, "WM_CTLCOLOR" ), OnMessage( 0x133, "WM_CTLCOLOR" )
Gui, Font, S10, Tahoma

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Config end

Gui +AlwaysOnTop
Gui, Margin, 10, 10

Gui, Add, Edit, xm+55 ym vText w%EditW% R3 hwndhText gHashText +0x40
Gui, Add, Text, xm yp w45 hp 0x202, Text

Gui, Add, Edit, % "xm+55 y+10 ReadOnly vFile BackgroundTrans hwndhEdit w" EditW - 35

Gui, Add, Button, x+5 w30 hp vButton gSelectFile, ...
Gui, Add, Text, xm yp w45 hp 0x202, File

Gui, Add, Edit, xm+55 y+20 %HexCase% ReadOnly w80 vEditCRC hwndErrorLevel
ControlGetPos,,,,BH,, ahk_id %ErrorLevel%

Gui, Add, Text, x+5 w50 hp 0x202 vffSize
Gui, Add, Text, x+0 w90 yp 0x202 vQPX h%BH%

ProgW := EditW - 275
Gui, Add, Progress, x+10 yp+5 Hidden w%ProgW% hp-10 c225599 BackgroundD8D8D8 vProg
Gui, Add, Text,     x+00 yp-5 w40 h%BH% 0x202 vPercentage
Gui, Add, Text, xm yp w45 hp 0x202, CRC32

Gui, Add, Edit, xm+55 y+5  %HexCase% ReadOnly w%EditW% hp vEditMD5
Gui, Add, Text, xm yp w45 hp 0x202, MD5

Gui, Add, Edit, xm+55 y+5  %HexCase% ReadOnly w%EditW% hp vEditSHA
Gui, Add, Text, xm yp w45 hp 0x202, SHA1

Gui, Add, Edit, % HexCase " xm+55 y+20 Limit40 vVerify gVerifyHash w" EditW - 67
Gui, Add, Edit, x+2 w65 hp vHashOk ReadOnly Center
Gui, Add, Text, xm yp w45 hp 0x202, Verify

IniRead, X, %Settings%, WinPos, X, %A_Space%
IniRead, Y, %Settings%, WinPos, Y, %A_Space%
WinPos := ( ( X <> "" ) ? "x" X : "xCenter" ) A_Space ( ( Y <> "" ) ? "y" Y : "yCenter" )
Gui, Show, %WinPos%, Hash-ish GUI
Gui +LastFound
WinSet, Redraw
GoTo, LoadFile
Return ;                                                 // end of auto-execute section //


HashText:
 If ! Bytes := ControlGetText_UTF8( Text, hText ) {
   GuiControl,, HashOk
   GuiControl,, EditCRC
   GuiControl,, EditMD5
   GuiControl,, EditSHA
   Return
 }

 StrHashCMS( Text, Bytes, CRC, MD5, SHA )

 If ( File<>"" ) {
   GuiControl,, File, % File := ""
   GuiControl,, ffSize, % Bytes " bytes"
   GuiControl,  Hide, Prog
   GuiControl,, Percentage
 }
 GuiControl,, EditCRC, %CRC%
 GuiControl,, EditMD5, %MD5%
 GuiControl,, EditSHA, %SHA%
 GoSub, VerifyHash
Return


SelectFile:
 Gui +OwnDialogs
 FileSelectFile, Filepath, 3, %FileFolder%, Select File, Any file (*.*)
 If ( ErrorLevel=0 && FileExist( FilePath ) )
   Goto LoadFile
Return


GuiDropFiles:
 IfGreater, ErrorLevel, 1, Return
LoadFile:
 FileGetSize, Bytes, % FilePath := ( A_ThisLabel = "LoadFile" ) ? FilePath : A_GuiEvent
 IfLess, Bytes, 1, Return
 VarSetCapacity( ffSize,16,0 )
 ffSize := DllCall( "shlwapi.dll\StrFormatByteSize64A"
                  , Int64,Bytes, Str,ffSize, UInt,32, A_IsUnicode ? "AStr" : "Str" )
 GuiControl,, ffSize, %ffSize%
 SplitPath, Filepath, File, FileFolder
 GuiControl,, File, %File%
 GuiControl,, Text
 GuiControl, Focus, File
 GuiControl,,Text
 GuiControl, Show, Prog
 GuiControl, Disable, Text
 GuiControl, Disable, Button
 oBM := DllCall( "SendMessage", UInt,hPic, UInt,0x172, UInt,0, UInt,0x0 ) ; STM_SETIMAGE
 DllCall( "DeleteObject", UInt,oBM )
 FileHashCMS( FilePath )
 GoSub, VerifyHash
 SoundPlay *-64
 GuiControl, Enable, Button
 GuiControl, Enable, Text
 SetTimer, HideProgress, -3000
Return


HideProgress:
 GuiControl, Hide, Prog
 GuiControl,, Percentage
Return


VerifyHash:
 GuiControlGet, Verify
 GuiControl,, HashOk, % HashOk( Verify, CRC, MD5, SHA )
Return


GuiEscape:
GuiClose:
 WinGetPos, X, Y, W, H, A
 IniWrite, %X%, %Settings%, WinPos, X
 IniWrite, %Y%, %Settings%, WinPos, Y
 ExitApp
Return


StrHashCMS( ByRef Buffer, Bytes, ByRef CRC="", ByRef MD5="", ByRef SHA="" ) {
 SetFormat, Integer, % SubStr( ( A_FI := A_FormatInteger ) "H", 0 )
 CRC32 := DllCall( "NTDLL\RtlComputeCrc32", UInt,0, UInt,&Buffer, UInt,Bytes, UInt )
 CRC   := SubStr( CRC32 | 0x1000000000, -7 )
 SetFormat, Integer, %A_FI%

 VarSetCapacity( MD5_CTX,104,0 ),  DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, UInt,&Buffer, UInt,Bytes )
 DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 MD5 := HexGet( &MD5_CTX+8,  16 )
 
 VarSetCapacity( SHA_CTX,136,0 ),  DllCall( "advapi32\A_SHAInit", UInt,&SHA_CTX )
 DllCall( "advapi32\A_SHAUpdate", UInt,&SHA_CTX, UInt,&Buffer, UInt,Bytes )
 DllCall( "advapi32\A_SHAFinal", UInt,&SHA_CTX, UInt,&SHA_CTX + 116 )
 SHA := HexGet( &SHA_CTX+116,20 )
}


FileHashCMS( sFile ) {
 Global EditMD5, EditSHA, EditCRC, Prog, Percentage, SHA, MD5, CRC
 QPX(1)
 cSz := 1*(1024*1024), VarSetCapacity( Buffer,cSz,0 )
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return

 DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),
 fSz := NumGet( Buffer,0,"Int64" )

 CRC32 := 0, ATC := A_TickCount, Read := 0
 VarSetCapacity( MD5_CTX,104,0 ),  DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 VarSetCapacity( SHA_CTX,136,0 ),  DllCall( "advapi32\A_SHAInit", UInt,&SHA_CTX )
 Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
 {
   DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,Bytes, UInt,0 )
   CRC32 := DllCall( "NTDLL\RtlComputeCrc32", UInt,CRC32, UInt,&Buffer, UInt,Bytes, UInt )
   SetFormat, Integer, % SubStr( ( A_FI := A_FormatInteger ) "H", 0 )
   CRC := SubStr( CRC32 + 0x1000000000, -7 )
   SetFormat, Integer, %A_FI%
   DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, UInt,&Buffer, UInt,Bytes )
   DllCall( "advapi32\A_SHAUpdate", UInt,&SHA_CTX, UInt,&Buffer, UInt,Bytes )

   GuiControl,, EditCRC, % CRC
   GuiControl,, EditMD5, % HexGet( &MD5_CTX+08, 16 )
   GuiControl,, EditSHA, % HexGet( &SHA_CTX+24, 20 )

   Prog := Floor( ( ( Read := Read + Bytes ) / fSz ) * 100 )
   Secs := ( A_TickCount - ATC ) / 1000
   GuiControl,,Percentage, % Prog "%"
   GuiControl,,Prog, %Prog%
   GuiControl,, QPX, % Secs "s"
 }
 DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 DllCall( "advapi32\A_SHAFinal", UInt,&SHA_CTX, UInt,&SHA_CTX + 116 )
 GuiControl,, EditMD5, % MD5 := HexGet( &MD5_CTX+8,  16 )
 GuiControl,, EditSHA, % SHA := HexGet( &SHA_CTX+116,20 )
 DllCall( "CloseHandle", UInt,hFil )
 GuiControl,, QPX, % QPX(0) "s"
}


ControlGetText_UTF8( ByRef UTF8_Text, hWnd ) {
 TChars := DllCall( "GetWindowTextLengthW", UInt,hWnd, UInt )
 VarSetCapacity( Text, TChars*2  )
 DllCall( "GetWindowTextW", UInt,hWnd, UInt,&Text, UInt,TChars+1 )
 UTF8Len := DllCall( "WideCharToMultiByte", Int,65001, Int,0, UInt,&Text, UInt,TChars
                                          , Int,0, Int,0, Int,0, Int,0, UInt )
 VarSetCapacity( UTF8_Text, UTF8Len  )
 DllCall( "WideCharToMultiByte", Int,65001, Int,0, UInt,&Text, UInt,TChars
                               , UInt,&UTF8_Text, Int,UTF8Len, Int,0, Int,0 )
Return UTF8Len
}


HexGet( Addr, Sz ) {
 DllCall( "Crypt32.dll\CryptBinaryToString" ( A_IsUnicode ? "W" : "A" )
        , UInt,Addr, UInt,Sz, UInt,4, Int,0, UIntP,ReqSz, "CDECL UInt" )
 VarSetCapacity( Hex, ReqSz := ReqSz * ( A_IsUnicode ? 2 : 1 ) )
 DllCall("Crypt32.dll\CryptBinaryToString" ( A_IsUnicode ? "W" : "A" )
        , UInt,Addr, UInt,Sz, UInt,4, Str,Hex, UIntP,ReqSz+1, "CDECL UInt")
Return RegExReplace( Hex, "[^a-fA-F0-9]" )
}


HashOk( Hash, CRC32, MD5, SHA1 ) {
 IfEqual,Hash,%CRC32%, Return  "CRC OK"
 IfEqual,Hash,%MD5%,   Return  "MD5 OK"
 IfEqual,Hash,%SHA1%,  Return  "SHA OK"
}


QPX( N=0 ) {       ;  Wrapper for  QueryPerformanceCounter()by SKAN  | CD: 06/Dec/2009
 Static F,A,Q,P,X  ;  www.autohotkey.com/forum/viewtopic.php?t=52083 | LM: 10/Dec/2009
 If ( N && !P )
    Return  DllCall("QueryPerformanceFrequency",Int64P,F) + (X:=A:=0)
          + DllCall("QueryPerformanceCounter",Int64P,P)
 DllCall("QueryPerformanceCounter",Int64P,Q), A:=A+Q-P, P:=Q, X:=X+1
Return ( N && X=N ) ? (X:=X-1)<<64 : ( N=0 && (R:=A/X/F) ) ? ( R + (A:=P:=X:=0) ) : 1
}


WM_CTLCOLOR( wParam, lParam, msg, hwnd  ) {
 Static hBrush
 Global BG_COLOR, FG_COLOR
 IfEqual, hBrush,, SetEnv, hBrush, % DllCall( "CreateSolidBrush", UInt,BG_COLOR )

 WinGetClass, Class, ahk_id %lParam%

 If ( Class = "Edit" ) {
   DllCall( "SetTextColor", UInt,wParam, UInt,FG_COLOR )
   DllCall( "SetBkColor", UInt,wParam, UInt,BG_COLOR )
   DllCall( "SetBkMode", UInt,wParam, UInt,2 )
   Return hBrush
   }

 If ( Class = "Static" ) {
   DllCall( "SetTextColor", Uint,wParam, UInt,FG_COLOR )
   }
}
