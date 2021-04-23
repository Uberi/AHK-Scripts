; example of using imagesearch


  ifwinnotexist, AutoHotkey Help
  {
    run, C:\Program Files\AutoHotkey\AutoHotkey.chm
  }
  
  WinWaitActive, AutoHotkey Help


  ; make sure that the help is the top most window
  winactivate, AutoHotkey Help
  winwaitactive, AutoHotkey Help

  ; make sure that Help is on the clipwait entry
  Send, {alt down}n{alt up}
  Send, {home}
  Send, {shift down}{end}{shift up}
  send, ClipWait
  send, {enter}
  

  CoordMode, pixel, screen


  loop, 255
  {
    ; find the newly created image on screen
    variation = %a_index%

    imagesearch, outx, outy, 0, 0, 1000, 1000, *%a_index% %a_ScriptDir%\clipwait.bmp

    ifequal, errorlevel, 0
      break
  }

  if ErrorLevel = 2
      MsgBox Could not conduct the search.
  else if ErrorLevel = 1
      MsgBox The clip could not be found on the screen.
  else
      MsgBox The clip was found at %outX%x%outY% variation=%variation%.

    
    
exitapp