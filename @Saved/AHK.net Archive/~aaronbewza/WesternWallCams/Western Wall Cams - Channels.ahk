
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

Version = Version: 1.3.0.0
BuildDate = Build Date: July 2nd 2011

url1 = "http://switch3.castup.net/cunet/gm.asp?Clipmediaid=45486"
url2 = "http://switch3.castup.net/cunet/gm.asp?Clipmediaid=31525"
url3 = "http://switch3.Castup.Net/cunet/gm.Asp?Clipmediaid=31526"
url4 = "http://www.cast-tv.biz/play/wvx/22688/424_16229.wvx"
  
id1 = object id=kcam0
id2 = object id=kcam0
id3 = object id=kcam0
id4 = object id=kcam0

ObjDetails = <object classid="clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95" type="application/x-oleobject" width="640" height="480" bufferingtime="5" scale="aspect" mute="1">
RemainingParamNames =
  ( LTrim
    <param name="width" value="640">
    <param name="height" value="480">
    <param name="bufferingtime" value="5">
    <param name="enableContextMenu" value="0">
    <param name="ShowDisplay" value="0">
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
        body { background-color: #000000; }
        .under { position:fixed; z-order:-1; }
      </style>
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
    </head>
    <body>
      <span class="under">
        <img src="http://i1207.photobucket.com/albums/bb474/aaronbewza/westernwallcams.jpg" width="640" height="480">
      </span> 
    </body>
  </html>
  )

COM_AtlAxWinInit()
  Gui, +LastFound -Resize
    pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(hwnd:=WinExist()
  ,-2 ; left
  ,-8 ; top
  ,682 ; width
  ,520 ; height
  ,"Shell.Explorer"))
    COM_Invoke(pwb, "Navigate", "about:blank")
  Gui, Show, w660 h550, Western Wall Cams
  Gui, Color, c000000
  Gui, Font, s12 bold
  Gui, Add, Button, x5 y515 w70 h30 vCam1, Cam 1
  Gui, Add, Button, x80 y515 w70 h30 vCam2, Cam 2
  Gui, Add, Button, x155 y515 w70 h30 vCam3, Cam 3
  Gui, Add, Button, x230 y515 w70 h30 vCam4, Cam 4
  Gui, Font
    COM_Invoke(pwb, "document.write", code)
Return

F1::
ButtonCam1:
  url = %url1%
  id = %id1%
  GoSub, CodeVariableChange
Return

F2::
ButtonCam2:
  url = %url2%
  id = %id2%
  GoSub, CodeVariableChange
Return

F3::
ButtonCam3:
  url = %url3%
  id = %id3%
  GoSub, CodeVariableChange
Return

F4::
ButtonCam4:
  url = %url4%
  id = %id4%
  GoSub, CodeVariableChange
Return

CodeVariableChange: ; Replaces "code" variable with new url in the html
code =
  (
  <!DOCTYPE html>
  <html>
    <head>
      <title>Western Wall Cams</title>
      <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
      <style type="text/css">
        body { background-color: #000000; }
        .fixed { position:fixed; z-order:-1; }
      </style>
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
    </head>
    <body>
  <span class="fixed">
    <img src="http://i1207.photobucket.com/albums/bb474/aaronbewza/loading.gif" width="640" height="480">
  </span>
      <span>
        <object %id% %ObjDetails% src=%url%>
          <param name="Filename" value=%url%>
          %RemainingParamNames%
        </object>
      </span> 
    </body>
  </html>
  )
  COM_Invoke(pwb, "document.write", code)
  COM_Invoke(pwb,"document.location.reload") ; Reloads the player from Aaron's Soundclick music site
Return

GuiClose:
  Gui, Destroy
  COM_Release(pwb)
  COM_AtlAxWinTerm()
ExitApp
