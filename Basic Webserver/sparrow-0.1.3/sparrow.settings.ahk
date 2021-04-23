; Part of Sparrow Webserver Core Version 0.1.3
;  - (w) Sep, 23 2008 derRaphael - 
;
; This is the sparrow setting file
; ======================================
;   SparrowSettings Version 0.2
;   Date: Sep, 19 2008
;   Written by DerRaphael
; ======================================
; 

   Sparrow[BindToAddress]  := "0.0.0.0"
   Sparrow[ListenToPort]   := "81"
   
   Sparrow[ServerVersion]  := "0.1.3"
   Sparrow[httpProtocol]   := "HTTP/1.1"
   Sparrow[documentRoot]   := A_ScriptDir "\www"
   Sparrow[tmpDir]         := A_ScriptDir "\tmp"
   Sparrow[DftIndexFiles]  := "index.htm|index.html|default.htm|default.html|index.hkml|default.hkml"
   Sparrow[errorDocPath]   := Sparrow[documentRoot]
   Sparrow[IncludeDir]     := a_scriptdir
   Sparrow[Custom_Err_404] := "404spec.hkml"
   
   Sparrow[ShowServerSig]  := "on"
   
   Sparrow[hkmlEnabled]    := "on"

   Sparrow[hkmlDescriptor] := "hkml - ParsingCore enabled"
   
   Sparrow[showMods]       := "on"
   
   Sparrow[modifications]  := ((Sparrow[hkmlEnabled]="on") ? Sparrow[hkmlDescriptor] : "")

   Sparrow[ServerName]     := "Sparrow AutoHotkeyWebServer"
   
   Sparrow[ServerSig]      := Sparrow[ServerName] " " Sparrow[ServerVersion] 
                           .  " AHK " A_AhkVersion 
                           . ((Sparrow[showMods]="on") ? " [" Sparrow[modifications] "]": "")

   Sparrow[debugToolTips]  := "off"
   
   Sparrow[PubLicVars]     := "on"
