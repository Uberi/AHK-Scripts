; Welcome to the GWKRLYUIOP club
; Enjoy your stay

#InstallKeybdHook
#KeyHistory 5000 
#maxhotkeysperinterval 5000
detecthiddenwindows,on


keyseton=1
return


; This turns the hotkeys on or off
; Ctrl + Backspace is default

ctrl & backspace::
   if keyseton=0
  {
     keyseton=1
     return
  }

  if keyseton=1
  {
    keyseton=0
     return
  }
return


*-::
SetKeyDelay -1
if keyseton=0
  Send {blind}{- downTemp}
if keyseton=1
  Send {blind}{h downTemp}
return
*- up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{- up}
if keyseton=1
  Send {blind}{h up}
return 


*q::
SetKeyDelay -1
if keyseton=0
  Send {blind}{q downTemp}
if keyseton=1
  Send {blind}{g downTemp}
return
*q up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{q up}
if keyseton=1
  Send {blind}{g up}
return 


*e::
SetKeyDelay -1
if keyseton=0
  Send {blind}{e downTemp}
if keyseton=1
  Send {blind}{k downTemp}
return
*e up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{e up}
if keyseton=1
  Send {blind}{k up}
return 

*t::
SetKeyDelay -1
if keyseton=0
  Send {blind}{t downTemp}
if keyseton=1
  Send {blind}{l downTemp}
return
*t up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{t up}
if keyseton=1
  Send {blind}{l up}
return 

*o::
SetKeyDelay -1
if keyseton=0
  Send {blind}{o downTemp}
if keyseton=1
  Send {blind}{d downTemp}
return
*o up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{o up}
if keyseton=1
  Send {blind}{d up}
return 

*a::
SetKeyDelay -1
if keyseton=0
  Send {blind}{a downTemp}
if keyseton=1
  Send {blind}{s downTemp}
return
*a up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{a up}
if keyseton=1
  Send {blind}{s up}
return 

*s::
SetKeyDelay -1
if keyseton=0
  Send {blind}{s downTemp}
if keyseton=1
  Send {blind}{a downTemp}
return
*s up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{s up}
if keyseton=1
  Send {blind}{a up}
return 

*d::
SetKeyDelay -1
if keyseton=0
  Send {blind}{d downTemp}
if keyseton=1
  Send {blind}{o downTemp}
return
*d up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{d up}
if keyseton=1
  Send {blind}{o up}
return 

*f::
SetKeyDelay -1
if keyseton=0
  Send {blind}{f downTemp}
if keyseton=1
  Send {blind}{v downTemp}
return
*f up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{f up}
if keyseton=1
  Send {blind}{v up}
return 

*g::
SetKeyDelay -1
if keyseton=0
  Send {blind}{g downTemp}
if keyseton=1
  Send {blind}{q downTemp}
return
*g up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{g up}
if keyseton=1
  Send {blind}{q up}
return 

*h::
SetKeyDelay -1
if keyseton=0
  Send {blind}{h downTemp}
if keyseton=1
  Send {blind}{- downTemp}
return
*h up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{h up}
if keyseton=1
  Send {blind}{- up}
return 

*j::
SetKeyDelay -1
if keyseton=0
  Send {blind}{j downTemp}
if keyseton=1
  Send {blind}{n downTemp}
return
*j up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{j up}
if keyseton=1
  Send {blind}{n up}
return 

*k::
SetKeyDelay -1
if keyseton=0
  Send {blind}{k downTemp}
if keyseton=1
  Send {blind}{e downTemp}
return
*k up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{k up}
if keyseton=1
  Send {blind}{e up}
return 

*l::
SetKeyDelay -1
if keyseton=0
  Send {blind}{l downTemp}
if keyseton=1
  Send {blind}{t downTemp}
return
*l up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{l up}
if keyseton=1
  Send {blind}{t up}
return 

*v::
SetKeyDelay -1
if keyseton=0
  Send {blind}{v downTemp}
if keyseton=1
  Send {blind}{f downTemp}
return
*v up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{v up}
if keyseton=1
  Send {blind}{f up}
return 

*n::
SetKeyDelay -1
if keyseton=0
  Send {blind}{n downTemp}
if keyseton=1
  Send {blind}{j downTemp}
return
*n up::
SetKeyDelay -1
if keyseton=0
  Send {blind}{n up}
if keyseton=1
  Send {blind}{j up}
return
