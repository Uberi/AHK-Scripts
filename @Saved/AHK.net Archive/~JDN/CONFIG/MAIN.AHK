#usehook
#singleinstance force                                                                    ; prevents running multiple copies of the script
#n::msgbox MAIN
#r::reload                                                                               ; reload this HKD - used after making changes
!x::exitapp                                                                              ; exit AutoHotkey 
!^2::
 Run "c:\program files\autohotkey\autohotkey.exe" c:\aa\ahk\BARE_BONES.AHK               ; Load B1.AHK - this file is almost empty
 exitapp
 RETURN
!^3::
 Run "c:\program files\autohotkey\autohotkey.exe" c:\aa\ahk\MAIN.AHK                     ; Load H1.AHK - my "everyday" hotkey file
 exitapp
 RETURN
!+1::run "c:\program files\notetab light\note1.exe" c:\aa\ahk\EDIT_TOOLS.AHK             ; Edit ED.AHK
!+2::run "c:\program files\notetab light\note1.exe" c:\aa\ahk\BARE_BONES.AHK             ; Edit B1.AHK
!+3::run "c:\program files\notetab light\note1.exe" c:\aa\ahk\MAIN.AHK                   ; Edit H1.AHK
!+4::run "c:\program files\notetab light\note1.exe" c:\aa\ahk\EDITOR_HEADER.AHK          ; Edit T4.AHK
!+5::run "c:\program files\notetab light\note1.exe" c:\aa\ahk\WORD_PROCESSOR.AHK         ; Edit T5.AHK

`::Send !{tab}                                                                           ; *** PLAIN KEYS - NO MODS ****
pause::Send !{space}n
[::Send {down}{enter}
]::Send {up}{enter}
F8::Send !{f4}
F9::Send ^+{tab}
F10::Send ^{tab}
F11::Send ^{f4}
                                                                                         ; ************ CTL ************
^[::Send !{space}x                                                                       ; Maximize
^]::Send !{space}r                                                                       ; Restore
^.::Send !{e}ry                                                                          ; Reload text file
^/::Send {f2}{end}_712                                                                   ; Rename backup folder
                                                                                         ; ************ WIN ************
#q::Send AutoHotkey{space}
#w::Send AutoHotkey.
#a::Send c:\pp\
#s::Send c:\pp\b\
#d::Send c:\pp\blu\
#f::Send c:\pp\m\
#z::Send c:\aa\ahk\
#x::Send c:\pp\xp\
#c::Send xrq19bj379
#v::Send xrq19bj380
#j::                                                                                     ; resize active win - wide
 WinGetTitle, Title, A                                                                   ; A is Active Window
 WinMove, %Title%,, 18, 0, 1260, 994                                                     ; WID-1260 HEI-994
 RETURN
#k::                                                                                     ; resize active win - normal
 WinGetTitle, Title, A                                                                   ; A is Active Window
 WinMove, %Title%,, 118, 0, 1160, 994                                                    ; WID-1260 HEI-994
 RETURN
#m::Send regsvr32 /u %windir%\system32\zipfldr.dll                                       ; reg dll files?
                                                                                         ; ********** ALT+CTL **********
!^a::Run c:\pd\examdiff\examdiff.exe
!^b::Run c:\pd\erb\erb /hide
!^d::Run c:\pp\b\comm.bat
!^e::Run c:\progra~1\noteta~1\note1.exe
;!^g::  ***RESERVED HOTKEY (starts AutoHotkey)
;!^h::Run c:\progra~1\borland\delphi4\help\tools\hcw
!^i::Run c:\progra~1\intern~1\iexplore
!^j::
 Run, explore c:\
 Sleep 1000
 WinGetTitle, Title, A
 if WinExist(Title)
    WinMove, %Title%,, 118, -1, 1160, 1000
 RETURN
!^l::Run c:\progra~1\zabkat\xplorer2_lite\xplorer2 " /s:reg1 /1 c:\"
!^n::Run c:\progra~1\ahead\nero\nero
!^o::Run c:\progra~1\jamsof~1\treesize\treesize
!^p::Run %programfiles%\autohotkey\au3_spy.exe
!^q::Run c:\pd\calculator\calculator
!^r::Run c:\progra~1\mozilla firefox\firefox
!^s::Run c:\pp\u\startup
!^w::Run c:\progra~1\winamp\winamp
;!^x::Run c:\progra~1\zabkat\xplorer2_lite\xplorer2
;!^z::Run c:\progra~1\borland\delphi4\bin\delphi32
!^;::Run c:\progra~1\micros~2\office\winword
                                                                                         ; ********** CTL+SHI **********
^+a::Run c:\aa\ahk\note.txt                                                              ; AHK notes
^+b::Run c:\pp\blu\note.txt                                                              ; XXP notes
^+c::Run c:\pp\m\cal.txt                                                                 ; calendar
^+h::Run c:\progra~1\autohotkey\autohotkey.chm                                           ; autohotkey.chm
^+j::Run c:\du\ba\delphi.def                                                             ; delphi.def
^+n::Run c:\pp\m\note.txt                                                                ; GP note
^+y::Run c:\pp\m\note1.txt                                                               ; secondary note
                                                                                         ; ********** CTL+WIN **********
; "FOLDER OPTIONS" resolves to FOLDER~2 NOT FOLDER~1 so must specify "FOLDER OPTIONS" or FOLDER~2.LNK
; It's a mystery why we must specify the EXT (.LNK) for short-form names but not EXE files. Note .LNK precedes .EXE) in PATHEXT command
^#a::Run c:\pd\link\date and time                                                        ; date and time          *
^#b::Run c:\windows\system32\clipbrd                                                     ; system clipboard       B
^#c::Run control                                                                         ; control panel          *
^#d::Run control desk.cpl                                                                ; display properties     *
^#f::Run c:\pd\link\folder options                 ;  c:\pd\link\folder~2.lnk **BAD**    ; folder options         *
^#h::Run c:\windows\system32\charmap                                                     ; system charmap         H
^#i::Run c:\pd\link\internet options                                                     ; internet options       *
^#k::Run  control main.cpl @1                                                            ; keyboard properties    *
^#m::Run  msconfig                                                                       ; msconfig               *
^#n::Run  notepad                                                                        ; notepad                *
^#p::Run  c:\windows\system32\mspaint                                                    ; MS Paint               *
^#r::Run  c:\windows\system32\regedt32                                                   ; registry editor        *
^#s::Run  control sysdm.cpl                                                              ; system properties      *
^#t::Run  c:\windows\system32\tweakui                                                    ; tweak UI               *
^#y::Run  c:\windows\system32\sysedit                                                    ; system edit
#include c:\aa\ahk\EDIT_TOOLS.AHK