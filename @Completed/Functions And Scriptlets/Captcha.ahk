#NoEnv

/*
Loop
{
 Key := Captcha(1,1)
 Gui, Show, x1 y1
 MsgBox % Key
 KeyWait, Enter, D
 Gui, Destroy
}
Return

Esc::ExitApp
*/

Captcha(x, y, gui=1)
{
 Random, Len, 5, 8
 w := (Len * 15) + 10
 h := 35
 Gui, %gui%:Add, Progress, BackgroundWhite Border Section x%x% y%y% w%w% h%h%
 xw := x + 10 
 Loop, % Len
 {
  Styles = ,bold,underline,norm,0x7,0x4,0x1,0x10,0x11,0x8,0x5,0xC,0x80,0x100,0x2,0x1000,0x9,0x6,
  Random, Rand, 1, 17
  StringGetPos, Rand, Styles, `,, L%Rand%
  Rand += 1
  Styles := SubStr(Styles,Rand + 1,InStr(Styles,",",False,Rand + 1) - (Rand + 1))
  Random, Boldness, 1, 1000
  Random, Size, 8, 12
  Colours = ,Black,Green,Silver,Lime,Gray,Olive,Maroon,Navy,Red,Blue,Purple,Teal,Fuchsia,Aqua,White,
  Random, Rand, 1, 20
  If Rand >= 15
   Rand = 15
  StringGetPos, Rand, Colours, `,, L%Rand%
  Rand += 1
  Colours := SubStr(Colours,Rand + 1,InStr(Colours,",",False,Rand + 1) - (Rand + 1))
  Fonts = ,Arial,Courier,Courier New,Lucida Console,MS Sans Serif,MS Serif,Tahoma,Times New Roman,
  Random, Rand, 1, 8
  StringGetPos, Rand, Fonts, `,, L%Rand%
  Rand += 1
  Fonts := SubStr(Fonts,Rand + 1,InStr(Fonts,",",False,Rand + 1) - (Rand + 1))
  Gui, Font, % Styles "w" Boldness "s" Size "c" Colours, %Fonts%
  AlphaNum = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
  Random, Key, 1, 62
  StringMid, Key, AlphaNum, %Key%, 1
  If Colours <> White
   Keys = %Keys%%Key%
  Random, yw, 3, 10
  yw = ys+%yw%
  Gui, %gui%:Add, Text, BackgroundTrans x%xw% %yw%, %Key%
  Random, xw1, 10, 15
  xw += xw1
 }
 Gui, Font
 Return, Keys
}