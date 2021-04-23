#NoTrayIcon
Menu, Tray, Icon, User32.dll,6

IfNotExist, gb1v.bmp
  UrlDownloadToFile
  , http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/gb1v.bmp
  , gb1v.bmp

IfNotExist, gb1h.bmp
  UrlDownloadToFile
  , http://file.autohotkey.net/goyyah/Tips-N-Tricks/Gradients/gb1h.bmp
  , gb1h.bmp

Text=* Linear Gradients *
LVG = gb1v.bmp ; The Linear Vertical Gradient
LHG = gb1h.bmp ; The Linear Horizontal Gradient


Gui, +E0x200 -Sysmenu +ToolWindow
Gui, Margin,0,0
Gui, Font, s36 Bold, Verdana


Gui, Add, Picture, x0   y0  w640 h480, %LVG%
Gui, Add, Picture, x0   y80 w640 h3, %LVG%
Gui, Add, Picture, x0   y0  w20 h480 , %LHG%
Gui, Add, Picture, x619 y0  w20 h480 , %LHG%

Gui, Add,Text,x0 y20 w640 h80 vText1 c000000 Center BackgroundTrans, % Text
Gui, Add,Text,x0 y15 w640 h80 vText2 cFFFFFF Center BackgroundTrans, % Text 


Gui, Font, s10 Bold, Verdana

Gui, Add, Picture, x30 y120 w125 h23 E0x200   vButton11 gButton1, %LVG%
Gui, Add, Picture, x30 y120 w125 h23 0x400000 vButton10 gButton1, %LVG%
Gui, Add, Text   , x37 y125 w115 h20 BackgroundTrans cFFFFFF gButton1, Button 1

Gui, Add, Picture, x30 y160 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y200 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y240 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y280 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y320 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y360 w125 h23 0x400000, %LVG%
Gui, Add, Picture, x30 y400 w125 h23 0x400000, %LVG%

Gui, Show, AutoSize 
, Using 2 Pixel BITMAP to create Linear Gradient Effects

Return

GuiEscape:
GuiClose:
 ExitApp
Return

Button1:
GuiControl Hide, Button10
sleep 250
GuiControl Show, Button10
Msgbox, You press Button 1
Return
