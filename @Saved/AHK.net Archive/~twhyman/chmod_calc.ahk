#NoTrayIcon
#SingleInstance off
Gui, Font, CBlue Underline s10
Gui, Add, Text, x12 y12 w310 h20 +Center , CHMOD Calculator
Gui, Add, Text, x12 y42 w70 h20 +Center, Permission
Gui, Add, Text, x92 y42 w70 h20 +Center, Owner
Gui, Add, Text, x172 y42 w70 h20 +Center, Group
Gui, Add, Text, x252 y42 w70 h20 +Center, Other
Gui, Font
Gui, Font, CBlue s10
Gui, Add, Text, x12 y162 w70 h20 +Center, Result:
Gui, Add, Text, x12 y72 w70 h20 +Center, Read
Gui, Add, Text, x12 y102 w70 h20 +Center, Write
Gui, Add, Text, x12 y132 w70 h20 +Center, Execute
Gui, Add, Text, x12 y192 w310 h20 +Center, Created by: Twhyman
Gui, Font
Gui, Add, CheckBox, x122 y72 w15 h20 vCB_O_Read gClicked_O, 
Gui, Add, CheckBox, x122 y102 w15 h20 vCB_O_Write gClicked_O, 
Gui, Add, CheckBox, x122 y132 w15 h20 vCB_O_Execute gClicked_O, 
Gui, Add, CheckBox, x202 y72 w15 h20 vCB_G_Read gClicked_G, 
Gui, Add, CheckBox, x202 y102 w15 h20 vCB_G_Write gClicked_G, 
Gui, Add, CheckBox, x202 y132 w15 h20 vCB_G_Execute gClicked_G, 
Gui, Add, CheckBox, x282 y72 w15 h20 vCB_Other_Read gClicked_Other, 
Gui, Add, CheckBox, x282 y102 w15 h20 vCB_Other_Write gClicked_Other, 
Gui, Add, CheckBox, x282 y132 w15 h20 vCB_Other_Execute gClicked_Other,
Gui, Add, Edit, x92 y162 w70 h20 vOwner_Edit +Center, 0
Gui, Add, Edit, x172 y162 w70 h20 vGroup_Edit +Center, 0
Gui, Add, Edit, x252 y162 w70 h20 vOther_Edit +Center, 0

Gui, Show, h215 w336, CHMOD Calculator
Return

Clicked_O:
Gui, Submit, NoHide
If (CB_O_Read=1)
 O_Read=4
Else
 O_Read=0

If (CB_O_Write=1)
 O_Write=2
Else
 O_Write=0

If (CB_O_Execute=1)
 O_Execute=1
Else
 O_Execute=0

O_Result:=(O_Read+O_Write+O_Execute)
GuiControl,, Owner_Edit, %O_Result%
Return


Clicked_G:
Gui, Submit, NoHide
If (CB_G_Read=1)
 G_Read=4
Else
 G_Read=0

If (CB_G_Write=1)
 G_Write=2
Else
 G_Write=0

If (CB_G_Execute=1)
 G_Execute=1
Else
 G_Execute=0

G_Result:=(G_Read+G_Write+G_Execute)
GuiControl,, Group_Edit, %G_Result%
Return

Clicked_Other:
Gui, Submit, NoHide
If (CB_Other_Read=1)
 Other_Read=4
Else
 Other_Read=0

If (CB_Other_Write=1)
 Other_Write=2
Else
 Other_Write=0

If (CB_Other_Execute=1)
 Other_Execute=1
Else
 Other_Execute=0

Other_Result:=(Other_Read+Other_Write+Other_Execute)
GuiControl,, Other_Edit, %Other_Result%
Return

GuiClose:
ExitApp


