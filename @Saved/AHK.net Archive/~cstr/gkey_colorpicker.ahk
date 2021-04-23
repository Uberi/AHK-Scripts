#Singleinstance force
#NoEnv
#notrayicon
; Menu, Tray, Icon, colorpicker.ico
Menu, Tray, Tip, Color Picker

#!z:: ;显示鼠标位置颜色 win+Alt+z hotkey. ez colorpicker

{		MouseGetPos, MouseX, MouseY
		PixelGetColor, ecolor, %MouseX%, %MouseY%,Alt|Slow|RGB
		Colorcalc(ecolor)
		colorstr:=SubStr(ecolor,3)
	
		StringUpper,colorstr,colorstr
	
		 if (ErrorLevel<>1 and ErrorLevel<>0)
			{
			msgbox,Error: %ErrorLevel%
			}
			
		ifWinExist ,ezCP
		{
			Gui Destroy 
		}
		else
		{
			CreateGui()	
			hGui := WinExist("ezCP")
		}
return
}

CreateGui()
		{
		global
		wx := A_ScreenWidth - 200
		wy := 50
		gui,+AlwaysOnTop -MaximizeBox -MinimizeBox  +Owner +ToolWindow 
		Gui, Margin,1,1

			;gui, Add, Text,vMyText w80 section,X:%MouseX% Y:%MouseY%
			;gui, Add, Button, w40 x+0 yp-4 gOnBtn  ,&Pick

			;gui, Add, Text,xs y+10 w10 cred,R
			gui, Add, Edit,xs+0 y+0 vEditR w30 Number Limit3 cred gOnEdit,%CRED%
			;gui, Add, TEXT,xs y+0 w10 cgreen,G
			gui, Add, Edit,xs+0 y+0  vEditG w30 Number Limit3 cgreen gOnEdit,%CGREEN%
			;gui, Add, TEXT,xs y+0 w10 cblue, B
			gui, Add, Edit,xs+0 y+0  vEditB w30 Number Limit3 cblue gOnEdit,%CBLUE%
			
			gui, Add, ListView, -Hdr  +AltSubmit  x+0 yp-40 w60 h60 Background%colorstr% vMyColor gOnBtn
			
			Gui, Font, underline

			Gui, Add, text, xs y+3 vHexColorEdit c5566bb gOnBtn w40 h20,%colorstr%
			Gui, Font, norm

			
			gui, Show,X%wx% Y%wy% NoActivate  NA,ezCP %version%
			}
		return	
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
Gui Destroy 
return 

OnBtn:
{
	; msgbox,gui:%a_gui%'n gui %a_guiControl%
	if A_GuiControl = HexColorEdit
	{
		clipboard = %colorstr%
		ToolTip,%colorstr% Copied to clipboard,
		SetTimer, RemoveToolTip, 2000
	}
	if A_GuiControl = MyColor
	{
		if A_guiEvent=DoubleClick
		 if CmnDlg_Color(ecolor, hGui )
		{	
		colorstr:=ecolor
		;msgbox,cp_currC:%cp_currC% colorstr:%colorstr% color:%color%	
		StringUpper,colorstr,colorstr
		 Set(colorstr)	
		 Colorcalc(ecolor)
		GuiControl,, EditR,%CRED%
		GuiControl,, EditG,%CGREEN%
		GuiControl,, EditB,%CBLUE%
		GuiControl +Background%colorstr%, MyColor 	
		}
	}

return
}

OnEdit:
{
		GuiControlGet,CRED, ,EditR
			if CRED >255
			{
			CRED =255
			GuiControl,,EditR,%CRED%
			}
		GuiControlGet,CGREEN, ,EditG
		if CGREEN >255
			{
			CGREEN =255
			GuiControl,,EditG,%CGREEN%
			}
		GuiControlGet,CBLUE, ,EditB
		if CBLUE >255
			{
			CBLUE =255
			GuiControl,,EditB,%CBLUE%
			}
			
		ecolor:=ColorRecalc(CRED,CGREEN,CBLUE)
		colorstr:=SubStr(ecolor,3)
		StringUpper,colorstr,colorstr
		GuiControl,,HexColorEdit,%colorstr%
		Colorcalc(ecolor)
	
		GuiControl,+Background%colorstr%, MyColor 
		
return 
}

Set(txt)
{
   ControlSetText, HexColorEdit, %txt%
}

Colorcalc(var)
{
		global CRED,CGREEN,CBLUE
		if (StrLen(var)=8)
		{
	
			CRED:=SubStr(var,3,2)		
			CGREEN:=SubStr(var,5,2)
			CBLUE:=SubStr(var,7,2)
			hex2decimal(CRED)
			hex2decimal(CGREEN)
			hex2decimal(CBLUE)
		return
		}
		else if(StrLen(var)=6)
		{
			
			CRED:=SubStr(var,1,2)		
			CGREEN:=SubStr(var,3,2)
			CBLUE:=SubStr(var,5,2)
			hex2decimal(CRED)
			hex2decimal(CGREEN)
			hex2decimal(CBLUE)
		return
		}
}

ColorRecalc(red,green,blue)
{
		SetFormat, integer, hex
		red += 0
		green += 0
		blue += 0
		total:=red*0x10000+green*0x100+blue
		StringTrimLeft, total, total, 2 
		loop, % 6-strlen(total) 	
		total=0%total% 
		total=0x%total% 
		SetFormat, integer, d
		return total
}

hex2decimal(ByRef var)
{	
ifInString, var, 0x
	{
	SetFormat, integer, d
	var+=0
	}
	else 
	{
	var=0x%var%
	SetFormat, integer, d
	var+=0
	}
	return
}


  







;----------------------------------------------------------------------------------------------
#v::
{
 ; OClip:=Clipboard
 send ^c
 ClipText:=Clipboard
 if StrLen(Cliptext)=3
     {
	 duplicate_hex(Cliptext)
      ValidColor:=CheckHexC(ClipText)
      
      if ValidColor
        {

       displayColor(ClipText)
          ; Clipboard:=OClip
         
        }
    }
	else if StrLen(Cliptext)=4
    {
      StringLeft, FChar, Cliptext, 1,

      if (FChar=# or FChar=c)
        {
          StringTrimLeft, ClipText, ClipText, 1
		   duplicate_hex(Cliptext)
          ValidColor:=CheckHexC(ClipText)

          if ValidColor
            {
			      displayColor(ClipText)
    
              ; Clipboard:=OClip
            }
        }
    }
  else if StrLen(Cliptext)=6
    {
      ValidColor:=CheckHexC(ClipText)
      
      if ValidColor
        {

       displayColor(ClipText)
          ; Clipboard:=OClip
         
        }
    }
	
 else if StrLen(Cliptext)=7
    {
      StringLeft, FChar, Cliptext, 1,

      if (FChar=# or FChar=c)
        {
          StringTrimLeft, ClipText, ClipText, 1
          ValidColor:=CheckHexC(ClipText)

          if ValidColor
            {
			      displayColor(ClipText)
    
              ; Clipboard:=OClip
            }
        }
    }
else	  if StrLen(Cliptext)=8
    {
      StringLeft, FChar, Cliptext, 2	
      if (FChar="0x" or  FChar="0X")
        {
          StringTrimLeft, ClipText, ClipText, 2
          ValidColor:=CheckHexC(ClipText)

          if ValidColor
            {
			
			displayColor(ClipText)
              ; Clipboard:=OClip
            }
        }
    }
	else
	{
	tooltip,Warning:`nYou Should choose a colorText First
	}
	SetTimer,Removetooltip,3000
}

 duplicate_hex(Byref hex)
{

	StringSplit, hex_arr, hex
	hex := ""
	loop %hex_arr0%
	{
	hex := hex . hex_arr%a_index% . hex_arr%a_index% 
	}
	return
} 
HEX2RGB(HEXString,Delimiter="")
{
	 if Delimiter=
	    Delimiter=,
	 
	 StringMid,R,HexString,1,2
	 StringMid,G,HexString,3,2
	 StringMid,B,HexString,5,2

	 R = % "0x"R 
	 G = % "0x"G
	 B = % "0x"B
	 
	 R+=0
	 G+=0
	 B+=0
	 loop % 3-StrLen(R)
	R=0%R%
	loop % 3-StrLen(G)
	G=0%G%
	 loop % 3-StrLen(B)
	B=0%B%
	
	 RGBString = % R Delimiter G Delimiter B

return RGBString
}

;将RGB颜色转换为16进制
RGB2HEX(RGBString,Delimiter="") 
{ 
 if Delimiter=
    Delimiter=,
 StringSplit,_RGB,RGBString,%Delimiter%

 SetFormat, Integer, Hex 
 _RGB1+=0
 _RGB2+=0
 _RGB3+=0

 if StrLen(_RGB1) =3
    _RGB1= 0%_RGB1%

 if StrLen(_RGB2) =3
    _RGB2= 0%_RGB2%

 if StrLen(_RGB3) = 3
    _RGB3= 0%_RGB3%

 SetFormat, Integer, D 
 HEXString = % _RGB1 _RGB2 _RGB3
 StringReplace, HEXString, HEXString,0x,,All
 StringUpper, HEXString, HEXString

return, HEXString
} 


CheckHexC(HEXString)
{
  StringUpper, HEXString, HEXString

  RGB:=HEX2RGB(HEXString)
  CHK:=RGB2HEX(RGB)

  StringUpper, CHK, CHK

  if CHK=%HEXString%
     return 1
  else
     return 0
}

displayColor(colvar)
{
		Gui ,+LastFoundExist
		ifWinNotExist
		CreateGui()
		
	
		colrgb:=HEX2RGB(colvar)
		CRED:=substr(colrgb,1,3)
		CGREEN:=substr(colrgb,5,3)
		CBLUE:=substr(colrgb,9,3)
		
		GuiControl,, EditR,%CRED%
		GuiControl,, EditG,%CGREEN%
		GuiControl,, EditB,%CBLUE%	
		GuiControl,, HexColorEdit,%colvar%
		GuiControl,+Background%colvar%, MyColor 
}







;----------------------------------------------------------------------------------------------
















;----------------------------------------------------------------------------------------------
RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
;----------------------------------------------------------------------------------------------