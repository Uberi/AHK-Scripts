; TotalWindow

; win-Left/Right/Up/Down
; To move the active window to the Top, Bot, Left, Right of the desktop using the arrow keys
; When moved the window will occupy the entire width or height

; Win-Alt-Left/Right/Up/Down
; To size windows in place by .1 of the screen width/height using the arrow keys

; Win-Ctl-Left/Right/Up/Down
; To move windows around the screen using the arrow keys

; Win-Shit-Left/Right/Up/Down
; To maximize windows the the left/right/top/bottom of the screen using the arrow keys



WindowSegments = 4
WindowMoveBy   = 5  ; pixels per move
WindowResizeBy = .1 ; portion of workarea per resize



#include *i C:\Documents and Settings\mattess\My Documents\AutoHotKey\Util\DisplayDefinedHotKeys.ahk



;-------------------------------------------------------
; set active window transparent while keys are held
;-------------------------------------------------------
#rcontrol:: ; set the active window transparent
  WinGetActiveTitle, WinTitle
  WinSet, Transparent, 75, %WinTitle%
return

#rcontrol up:: ; restore active window to non-transparent
  WinGetActiveTitle, WinTitle
  WinSet, Transparent, 255, %WinTitle%
return



;-------------------------------------------------------
; move window to center of, and 3/4 of, useable area
;-------------------------------------------------------
#enter:: ; resize the active window to 3/4s of workarea and center it in workarea
  WinGetActiveTitle, WinTitle
  
  GoSub, GetSizes
  
  Height := WorkingHeight * .75
  Width  := WorkingWidth  * .75
  
  Left   := WorkingWidth  * .25 / 2
  Top    := WorkingHeight * .25 / 2
  
  WinMove, %WinTitle%, , %left%, %top%, %Width%, %Height%
  OutputDebug, TotalWindow: #enter - WinMove, %wintitle%, , %left%, %top%, %width%, %height%
  
return


;-------------------------------------------------------
; window moving to hug the top/bottom/left/right
;-------------------------------------------------------
#+left:: ; maximize the active window towards the left side of the screen
  WinGetActiveTitle, wintitle

  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%
  
  gosub, GetSizes
  
  left   := 0
  width  := ScrX + ScrWidth
  
  WinMove, %wintitle%, , %left%, , %width%
  OutputDebug, TotalWindow: #+left - WinMove, %wintitle%, , %left%, , %width%
return
 
#+right:: ; maximize the active window towards the right side of the screen
  WinGetActiveTitle, wintitle

  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%
  
  gosub, GetSizes
  
  width  := WorkingWidth - ScrX
  
  WinMove, %wintitle%, , , , %width%
  OutputDebug, TotalWindow: #+right - WinMove, %wintitle%, , , , %width%
return 

#+up:: ; maximize the active window towards the top of the screen
  WinGetActiveTitle, wintitle

  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%
  
  gosub, GetSizes
  
  top    := 0
  height := ScrY + ScrHeight
  
  WinMove, %wintitle%, , , %top%, , %height%
  OutputDebug, TotalWindow: #+up - WinMove, %wintitle%, , , %top%, , %height%
return

#+down:: ; maximize the active window towards the bottom of the screen
  WinGetActiveTitle, wintitle

  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%
  
  gosub, GetSizes
  
  height := WorkingHeight - ScrY
  
  WinMove, %wintitle%, , , , , %height%
  OutputDebug, TotalWindow: #+down - WinMove, %wintitle%, , , , , %height%
return



;-------------------------------------------------------
; window moving to hug the top/bottom/left/right
;-------------------------------------------------------
#left:: ; move the active window to cover the left of the screen 
  WinGetActiveTitle, wintitle

  gosub, GetSizes
  
  left   := WorkingLeft 
  top    := WorkingTop
  width  := WorkingWidth / WindowSegments
  height := WorkingHeight
  
  WinMove, %wintitle%, , %left%, %top%, %width%, %height%
  OutputDebug, TotalWindow: #left - WinMove, %wintitle%, , %left%, %top%, %width%, %height%
return
 
#right:: ; move the active window to cover the right of the screen 
  WinGetActiveTitle, wintitle

  gosub, GetSizes
  
  left   := WorkingRight - ( WorkingWidth / WindowSegments )
  top    := WorkingTop
  width  := WorkingWidth / WindowSegments
  height := WorkingHeight
  
  WinMove, %wintitle%, , %left%, %top%, %width%, %height%
  OutputDebug, TotalWindow: #right - WinMove, %wintitle%, , %left%, %top%, %width%, %height%
return 

#up:: ; move the active window to cover the top of the screen
  WinGetActiveTitle, wintitle

  gosub, GetSizes
  
  left   := WorkingLeft
  top    := WorkingTop
  width  := WorkingWidth 
  height := WorkingHeight / WindowSegments
  
  WinMove, %wintitle%, , %left%, %top%, %width%, %height%
  OutputDebug, TotalWindow: #up - WinMove, %wintitle%, , %left%, %top%, %width%, %height%
return

#down:: ; move the active window to cover the bottom of the screen
  WinGetActiveTitle, wintitle

  gosub, GetSizes
  
  left   := WorkingLeft
  top    := WorkingBottom - ( WorkingHeight / WindowSegments )
  width  := WorkingWidth 
  height := WorkingHeight / WindowSegments
  
  WinMove, %wintitle%, , %left%, %top%, %width%, %height%
  OutputDebug, TotalWindow: #down - WinMove, %wintitle%, , %left%, %top%, %width%, %height%
return



;-------------------------------------------------------
; window moving left/right
;-------------------------------------------------------
#^left:: ; move the active window to the left 
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, , , , %WinTitle%

  ScrX := ScrX - WindowMoveBy
  
  WinMove, %wintitle%, , %ScrX%
  OutputDebug, TotalWindow: #^left - WinMove, %wintitle%, , %ScrX%
return
 
#^right:: ; move the active window to the right
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, , , , %WinTitle%

  ScrX := ScrX + WindowMoveBy
  
  WinMove, %wintitle%, , %ScrX%
  OutputDebug, TotalWindow: #^left - WinMove, %wintitle%, , %ScrX%
return 

#^up:: ; move the active window up 
  WinGetActiveTitle, wintitle

  WinGetPos, , ScrY , , , %WinTitle%

  ScrY := ScrY - WindowMoveBy
  
  WinMove, %wintitle%, , , %ScrY%
  OutputDebug, TotalWindow: #^left - WinMove, %wintitle%, , , %ScrY%
return

#^down:: ; move the active window down 
  WinGetActiveTitle, wintitle

  WinGetPos, , ScrY , , , %WinTitle%

  ScrY := ScrY + WindowMoveBy
  
  WinMove, %wintitle%, , , %ScrY%
  OutputDebug, TotalWindow: #^left - WinMove, %wintitle%, , , %ScrY%
return



;-------------------------------------------------------
; window resizing
;
; if the current position and width/height of the active window indicates that it is hugging the edges
; then ensure that it stays that way
;-------------------------------------------------------
#!left:: ; resize the active window width smaller by a portion of the total working area width
; if the window is hugging the left of the screen
;    leave the top
;    leave the left
;    decrease the width
;    leave the height
;
; if the window is hugging the right of the screen
;    leave the top
;    increase the left
;    decrease the width
;    leave the height
;
; if the window is not hugging any side of the screen
;    leave the top
;    leave the left
;    decrease the width
;    leave the height
;
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%

  gosub, GetSizes
  
  left := ScrX
  ifequal, ScrHeight, %WorkingHeight%
  {
    Scr := ScrX + ScrWidth
    ifequal, Scr, %WorkingWidth%
    {
      Left := ScrX + ( WorkingWidth * WindowResizeBy )
    }
  }
   
  width  := ScrWidth - ( WorkingWidth * WindowResizeBy )
  
  WinMove, %wintitle%, , %left%, , %width%
  OutputDebug, TotalWindow: #!left - WinMove, %wintitle%, , %left%, , %width%
return
 
#!right:: ; resize the active window width larger by a portion of the total working area width 
; if the window is hugging the left of the screen
;    leave the top
;    leave the left
;    increase the width
;    leave the height
;
; if the window is hugging the right of the screen
;    leave the top
;    decrease the left
;    increase the width
;    leave the height
;
; if the window is not hugging any side of the screen
;    leave the top
;    leave the left
;    increase the width
;    leave the height
;
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%

  gosub, GetSizes
  
  left := ScrX
  ifequal, ScrHeight, %WorkingHeight%
  {
    Scr := ScrX + ScrWidth
    ifequal, Scr, %WorkingWidth%
    {
      Left := ScrX - ( WorkingWidth * WindowResizeBy )
    }
  }
   
  width  := ScrWidth + ( WorkingWidth * WindowResizeBy )
  
  WinMove, %wintitle%, , %left%, , %width%
  OutputDebug, TotalWindow: #!left - WinMove, %wintitle%, , %left%, , %width%
return
 
#!up:: ; resize the active window height smaller by a portion of the total working area height
; if the window is hugging the top of the screen
;    leave the top
;    leave the left
;    leave the width
;    decrease the height
;
; if the window is hugging the bottom of the screen
;    increase the top
;    leave the left
;    leave the width
;    decrease the height
;
; if the window is not hugging any side of the screen
;    leave the top
;    leave the left
;    leave the width
;    decrease the height
;
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%

  gosub, GetSizes
  
  top := ScrY
  ifequal, ScrWidth, %WorkingWidth%
  {
    Scr := ScrY + ScrHeight
    ifequal, Scr, %WorkingHeight%
    {
      Top := ScrY + ( WorkingHeight * WindowResizeBy )
    }
  }
   
  Height  := ScrHeight - ( WorkingHeight * WindowResizeBy )
  
  WinMove, %wintitle%, , , %top%, , %height%
  OutputDebug, TotalWindow: #!left - WinMove, %wintitle%, , , %top%, , %height%
return
 
#!down:: ; resize the active window height larger by a portion of the total working area height
; if the window is hugging the top of the screen
;    leave the top
;    leave the left
;    leave the width
;    increase the height
;
; if the window is hugging the bottom of the screen
;    decrease the top
;    leave the left
;    leave the width
;    increase the height
;
; if the window is not hugging any side of the screen
;    leave the top
;    leave the left
;    leave the width
;    increase the height
;
  WinGetActiveTitle, wintitle
  WinGetPos, ScrX, ScrY, ScrWidth, ScrHeight, %WinTitle%

  gosub, GetSizes
  
  top := ScrY
  ifequal, ScrWidth, %WorkingWidth%
  {
    Scr := ScrY + ScrHeight
    ifequal, Scr, %WorkingHeight%
    {
      Top := ScrY - ( WorkingHeight * WindowResizeBy )
    }
  }
   
  height  := ScrHeight + ( WorkingHeight * WindowResizeBy )
  
  WinMove, %wintitle%, , , %top%, , %height%
  OutputDebug, TotalWindow: #!left - WinMove, %wintitle%, , , %top%, , %height%
return
 

 
; get the working area of the monitor and calculate the height and width
GetSizes:  
  SysGet, Working, MonitorWorkarea

  WorkingWidth := ( WorkingRight - WorkingLeft )
  WorkingHeight := ( WorkingBottom - WorkingTop )
  
  OutputDebug, TotalWindow: GetSizes - %WorkingLeft%, %WorkingTop%, %WorkingRight%, %WorkingBottom%, %WorkingWidth%, %WorkingHeight%
return
