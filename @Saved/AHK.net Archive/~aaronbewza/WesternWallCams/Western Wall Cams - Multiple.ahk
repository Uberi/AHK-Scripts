
If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp
  }
;  ________               __                      ________         __ __   ______                       
; |  |  |  |.-----.-----.|  |_.-----.----.-----. |  |  |  |.---.-.|  |  | |      |.---.-.--------.-----.
; |  |  |  ||  -__|__ --||   _|  -__|   _|     | |  |  |  ||  _  ||  |  | |   ---||  _  |        |__ --|
; |________||_____|_____||____|_____|__| |__|__| |________||___._||__|__| |______||___._|__|__|__|_____|
;
; streamed from http://neverbesilent.org/en/live-webcam-kotel-western-wall.html
; by Aaron Bewza

Version = Version: 1.2.0.0
BuildDate = Build Date: June 29th 2011

ObjDetails = classid="clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95" type="application/x-oleobject" width="400" height="320" bufferingtime="5" scale="aspect"
RemainingParamNames =
  ( LTrim
    <param name="width" value="400">
    <param name="height" value="320">
    <param name="bufferingtime" value="5">
    <param name="enableContextMenu" value="0">
    <param name="mute" value="1">
    <param name="scale" value="aspect">
    <param name="showControls" value="0">
  )

code =
  (
  <!DOCTYPE html>
  <html>
    <head>
      <title>Western Wall Cams</title>
      <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
      <style type="text/css">
        body { margin:10px 10px 10px 10px; background-color: #111111; font-size:24px; font-family:Arial; font-weight:bold; }
        #pos { position:fixed; }
      </style>
    </head>
    <body>
      <script type = "text/javascript">
        var message="";
        function clickIE()
        {if (document.all)
          {(message);return false;}}
        function clickNS(e) {
          if
          (document.layers||(document.getElementById&&!document.all))
            {
            if (e.which==2||e.which==3) {(message);return false;}}}
        if (document.layers)
          {document.captureEvents(Event.MOUSEDOWN);document.  onmousedown=clickNS;}
        else
          {document.onmouseup=clickNS;document.oncontextmenu  =clickIE;}
        document.oncontextmenu=new Function("return false")
      </script>
      <span id="pos">
        <object id=kcam0 %ObjDetails%>
          <param name="Filename" value="http://switch3.castup.net/cunet/gm.asp?Clipmediaid=45486">
          %RemainingParamNames%>
        </object>&nbsp;
        <object id=kcam1 %ObjDetails%>
          <param name="Filename" value="http://switch3.castup.net/cunet/gm.asp?Clipmediaid=31525">
          <%RemainingParamNames%>
        </object>
        <object id=kcam2 %ObjDetails%> 
          <param name="Filename" value="http://switch3.Castup.Net/cunet/gm.Asp?Clipmediaid=31526">
          <%RemainingParamNames%>
        </object>&nbsp;
        <object id="wmp_p" %ObjDetails%>
          <param name="Filename" value="http://www.cast-tv.biz/play/wvx/22688/424_16229.wvx">
          <%RemainingParamNames%>
        </object>
      </span>
    </body>
  </html>
  )

COM_AtlAxWinInit()
  Gui, +LastFound -Resize
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(hwnd:=WinExist()
  , -2
  , -2 ; top
  , 849 ; width
  , 670 ; height
  , "Shell.Explorer"))
COM_Invoke(pwb, "Navigate", "about:blank")
  OnMessage(0x200,"MouseHover") ; Calls function for ToolTip hover text
  Gui, Show, w828 h705, Western Wall Cams
  Gui, Color, c000000
  Gui, Font, s14 bold
  Gui, Add, Button, x5 y672 w140 h30 vReload, Reload
  Gui, Add, Button, x150 y672 w140 h30 vInfo, Info
  Gui, Add, Button, x295 y672 w70 h30 vAbout, ?
  Gui, Font
COM_Invoke(pwb, "document.write", code)
Return

ButtonReload:
  COM_Invoke(pwb,"document.location.reload") ; Reloads the cameras
Return

ButtonInfo:
  Run, http://en.wikipedia.org/wiki/Western_Wall
Return

Button?:
Gui, +OwnDialogs
  MsgBox, Western Wall Cams`n(By Aaron Bewza)`n`n%Version%`n%BuildDate%`n
Return

GuiClose:
  Gui, Destroy
  COM_Release(pwb)
  COM_AtlAxWinTerm()
ExitApp


 ; ------------- Functions ----------------------------------------------------------------------------->>

MouseHover() { ; Function for mouse hover text
  TT_1_Reload = - Reloads videos -`nUse if the cameras get`nglitchy or stop working
  TT_1_Info = - Opens Wikipedia website -`nabout the Western Wall
  TT_1_About = - About this software -

  Cntrl = %A_GuiControl% ; Detects which control mouse is over, results sent to "cntrl" variable
  While RegExMatch(Cntrl, "[-;\\. `n]") ; Looks for these characters from inside [] brackets
    Cntrl := RegExReplace(Cntrl, "[-;\\. `n]") ; Removes these characters from inside [] brackets and sends results to "cntrl" variable
  tt := TT_%A_Gui%_%Cntrl% ; Creates "tt" variable from results put together from these variables
  ToolTipSmooth(tt) ; Calls function (below) for mouse hover text using "tt" variable...
}
ToolTipSmooth(Text="", WhichToolTip=16, xOffset=16, yOffset=16) { ; Smooth tooltip, follows mouse
  Static LastText, hwnd, VirtualScreenWidth, VirtualScreenHeight ; Gets this information
  If (VirtualScreenWidth = "" or VirtualScreenHeight = "") { ; If virtual screen width or height is nothing
    SysGet, VirtualScreenWidth, 78 ; Gets virtual screen width this way
    SysGet, VirtualScreenHeight, 79 ; Gets virtual screen height this way
  }
  If (Text = "") { ; If there is no text, nothing is displayed
    ToolTip,,,, % WhichToolTip ; Destroys tooltip
    LastText := "", hwnd := "" ; Displays nothing
    Return
  }
  Else { ; Moves or recreates tooltip
    CoordMode, Mouse, Screen ; Retrieves absolute screen coordinates for mouse
    MouseGetPos, x,y ; Finds out which window or control mouse is hovering over
    x += xOffset, y += yOffset ; I'm not sure how this adds up yet
    WinGetPos,,,w,h, ahk_id %hwnd% ; Retrieves the position and size of the window
    If ((x+w) > VirtualScreenWidth) ; Adjusts Tooltip position--------------------------------------->>>
      AdjustX := 1 ; Moves tooltip in increments of 1px horizontally?
    If ((y+h) > VirtualScreenHeight)
      AdjustY := 1 ; Moves tooltip in increments of 1px vertically?
    If (AdjustX and AdjustY)
      x := x - xOffset*2 - w, y := y - yOffset*2 - h ; Adjusts tooltip position diagonally?
    Else If AdjustX ; If mouse moves horizontally?...
      x := VirtualScreenWidth - w ; ...Adjusts tooltip position horizontally?
    Else If AdjustY ; If mouse moves vertically?...
      y := VirtualScreenHeight - h ; ...Adjusts tooltip position vertically?-------------------------<<<
    If (Text = LastText) ; Moves tooltip
      DllCall("MoveWindow", A_PtrSize ? "UPTR" : "UInt",hwnd,"Int",x,"Int",y,"Int",w,"Int",h,"Int",0) ; Moves tooltip instead of redrawing?
    Else ; Recreates tooltip
      {
        CoordMode, ToolTip, Screen ; Retrieves absolute screen coordinates for tooltip
        ToolTip,,,, % WhichToolTip ; Destroys tooltip
        ToolTip, % Text, x, y, % WhichToolTip ; Shows new tooltip
        hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " DllCall("GetCurrentProcessId")), LastText := Text ; Sends this info to "hwnd" variable
        %A_ThisFunc%(Text, WhichToolTip, xOffset, yOffset) ; Moves new tooltip
      }
    WinSet, AlwaysOnTop, On, ahk_id %hwnd% ; Sets tooltip to be always on top
  }
}
Return
