/*          
    * * * * * * * * * * * * * * * * * * * * * * * * * * * *
            
    Disclaimer:

    I do not foresee any risk in running this demo but
    you may run this file "ONLY" at your own risk. 

    * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

File Name   : ST_Demo.ahk

Download    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/Shadowed_Text/ST_Demo.ahk
SnapShot    : http://file.autohotkey.net/goyyah/Tips-N-Tricks/Shadowed_Text/Snapshot1.gif
Posted in   : http://www.autohotkey.com/forum/viewtopic.php?p=54227#54227

Main Title  : GUI-Trick
Sub Title   : Displaying Shadowed Text

Description :  Two Similar Texts (with Transparent background) can be overlapped (superimposed)
               one over the another (with a slight offset) to create a shadowed text. 
               These texts have to be colored in contrast with each other.
               
               This a GUI to demonstrate the said effect.

Author      : A.N.Suresh Kumar aka "Goyyah"
Email       : arian.suresh@gmail.com

Created     : 2006-03-27
Modified    : 2006-03-27

Scripted in : AutoHotkey Version 1.0.42.06 , www.autohotkey.com 

*/

Text=This is Shadowed Text
Offset=4

Gui, +ToolWindow
Gui, Color, 5E43FF

Gui,Font, s36 Bold, Verdana

Gui, Add,Text,x5 y25 w384 h200 Center vText1 c000000 BackgroundTrans, % Text
Gui, Add,Text,x5 y25 w384 h200 Center vText2 cFFFFFF BackgroundTrans, % Text
Gui, Add, Slider,x10 y250 w100  ToolTip Thick25 NoTicks Range-6-6 gShadowOffset vOffset AltSubmit, % Offset

Gui,Font, s10 Bold, Verdana

Gui, Add, Edit, x+5 y250 w200 Limit21 vText, % Text
Gui, Add, Button, x+3 y250 w60 h25 gChangeText, Go

Gui,Show,w400 h300,SuperImposing Texts to create Shadow effect

GoSub, ShadowOffset

return

Guiclose:
GuiEscape:
 exitapp
return


ShadowOffset:

  Gui, Submit, Nohide
  Xpos := 5+Offset
  Ypos := 25+Offset

  GuiControl, Move, Text1, x%Xpos% y%YPos% w384
  GuiControl, , Text2, % Text
return

ChangeText:

  Gui, Submit, NoHide
  GuiControl, , Text1, % Text
  GuiControl, , Text2, % Text
Return