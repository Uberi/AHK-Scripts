; ScreenCaptureToPNG Ext-1    Forum Topic : www.autohotkey.com/forum/viewtopic.php?t=19475 
; Author:  Suresh Kumar A N                 ; Created 30-Aug-2008 / Modified : 04-Sep-2008
; Credit:  Adapted from  www.autohotkey.com/forum/viewtopic.php?p=97591#97591  by XavierGr  
 
BMPF:=A_Temp "\screen.bmp", OUTF:=A_scriptDir "\screen.png", THM:=A_scriptDir "\Thumb.jpg"    
 
#IfWinActive, ahk_class ShImgVw:CPreviewWnd
  r::GenerateThumbnail( BMPF, WxH )

  s::
  If % ConvertGraphicsFile( BMPF, THM )  
      Run, Rundll32.exe %A_Windir%\system32\shimgvw.dll`,ImageView_Fullscreen %THM%
  Return
#IfWinActive

#IfWinNotActive, ahk_class ShImgVw:CPreviewWnd
  ~PrintScreen::                                           
 ~!PrintScreen::
  If  % ( WxH := SaveClipboardImageAs( BMPF ) ) 
      If % ConvertGraphicsFile( BMPF, OUTF )  
         Run, Rundll32.exe %A_Windir%\system32\shimgvw.dll`,ImageView_Fullscreen %OUTF%
  Return
#IfWinNotActive
 
SaveClipboardImageAs( tImg="" ) {
 If ( DllCall( "IsClipboardFormatAvailable", UInt,2 ) = 0 )
   Return 0 
 $CB := ClipboardAll
 W:=NumGet($CB,20), H:=NumGet($CB,24), B:=NumGet($CB,30,"UShort"), Dsz:=NumGet($CB,36)
 VarSetCapacity($BM,(Hdr:=54)+DSz,0), NumPut(NumGet((Id:="BM"),0,"UShort"),$BM,0,"UShort")
 NumPut(Hdr+DSz,$BM,2), NumPut(Hdr,$BM,10), NumPut(40,$BM,14), NumPut(W,$BM,18)
 NumPut(H,$BM,22), NumPut(B,$BM,28,"UShort"), NumPut(DSz,$BM,34)
 DllCall( "RtlMoveMemory", UInt,&$BM+54, UInt,&$CB+68, UInt,DSz ) 
 If ( (Z:=DllCall( "_lcreat",Str,tImg,UInt,0)) = -1 
 ||DllCall( "_lwrite",UInt,Z,Str,$BM,UInt,Hdr+Dsz )=-1 || DllCall( "_lclose",UInt,Z )=-1 )
   Return 0 
 Return W "x" H    
}

ConvertGraphicsFile( Src, Trg, Ov=1 ) { 
 Static shlwapi,ShConvertGraphics ; www.autohotkey.com/forum/viewtopic.php?p=190227#190227
 if ( shlwapi = "" )  { 
   shlwapi := DllCall( "LoadLibrary",Str,"shlwapi.dll" ) 
   ShConvertGraphics := DllCall( "GetProcAddress", UInt,shlwapi, UInt,488 ) 
                      }  
 VarSetCapacity( uSrc, ( sSz := StrLen(Src)*2+1) ) 
 DllCall( "MultiByteToWideChar", Int,0, Int,0, Str,Src, Int,-1, Str,uSrc, Int,sSz ) 
 VarSetCapacity( uTrg, ( tSz := StrLen(Trg)*2+1) ) 
 DllCall( "MultiByteToWideChar", Int,0, Int,0, Str,Trg, Int,-1, Str,uTrg, Int,tSz ) 
Return ! DllCall( ShConvertGraphics, Str,uSrc, Str,uTrg, UInt,Ov ) 
} 
  
GenerateThumbnail( BMPF, Byref WxH ) {
 Gui, -Caption +Owner +AlwaysOnTop
 Gui, Margin, 0,0
 StringSplit, D, WxH, x
 Gui, Add, Picture, % "x0 y0 w" ((D1*75)/100) " h" ((D2*75)/100), %BMPF%  
 Gui, Show
 Send {Alt Down}{PrintScreen}{Alt Up}
 Gui, Destroy
 If ( WxH:=SaveClipboardImageAs( BMPF ) )
      Run, Rundll32.exe %A_Windir%\system32\shimgvw.dll`,ImageView_Fullscreen %BMPF% 
} 