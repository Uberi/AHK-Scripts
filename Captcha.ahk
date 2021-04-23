#NoEnv

;make a version that uses GDI or GDIP, drawing chars using lines and other non-text funcs
;modify to use guicontrolget

CaptchaTries = 4
CaptchaTimePerChar = 2

Loop
{
 CaptchaKey := Captcha(1,1,CaptchaLen)
 CaptchaTimer := Round(CaptchaTimePerChar * StrLen(CaptchaKey))
 Gui, Add, Text, x2 y40 w%CaptchaLen% h30 +Center, Type in the code to continue:
 Gui, Add, Edit, x2 y70 w%CaptchaLen% h20 vCaptchaText
 Gui, Add, Button, x2 y90 w%CaptchaLen% h20 +Default, Submit
 Gui, Add, Text, x2 y110 w40 h20, Timer:
 Gui, Add, Text, % "x" . (CaptchaLen - 40) . " y110 w40 h20 +Right vCaptchaTimeLeft", %CaptchaTimer%
 Gui, Add, Text, x2 y130 w40 h20, Tries:
 Gui, Add, Text, % "x" . (CaptchaLen - 40) . " y130 w40 h20 +Right vCaptchaTries", %CaptchaTries%
 Gui, +AlwaysOnTop + ToolWindow
 GuiControl,, CaptchaTimer, %CaptchaTimer1%
 Gui, Show, % "w" . (CaptchaLen + 5) . " h145", Captcha
 ToolTip % CaptchaKey
 SetTimer, CaptchaTimer, 1000
 While (!Submitted)
  Sleep, 100
 Submitted = 
 Gui, Destroy
}
Return

GuiClose:
ExitApp

CaptchaTimer:
CaptchaTimer --
If CaptchaTimer = 0
{
 CaptchaTries --
 GuiControl,, CaptchaTries, %CaptchaTries%
 Submitted = 1
 If CaptchaTries = 0
 {
  Gosub, Failed
  SetTimer, CaptchaTimer, Off
  Return
 }
}
GuiControl,, CaptchaTimeLeft, %CaptchaTimer%
Return

ButtonSubmit:
GuiControlGet, CaptchaText,, CaptchaText
If CaptchaText = %CaptchaKey%
 Submitted = 1
Else
{
 CaptchaTries --
 If CaptchaTries = 0
 {
  Gosub, Failed
  Return
 }
 Submitted = 1
}
GuiControl,, CaptchaTries, %CaptchaTries%
Return

Failed:
MsgBox, Out of tries.
ExitApp
Return

Esc::ExitApp

Captcha(x,y,ByRef w,gui=1)
{
 Random, Len, 5, 8
 w := (Len * 15) + 10
 h := 40
 Gui, %gui%:Add, Progress, BackgroundWhite Border Section x%x% y%y% w%w% h%h%
 xw := x + 10
 Loop, % Len
 {
  Random, Size, 8, 12
  Colours = ,Black,Green,Silver,Lime,Gray,Olive,Maroon,Navy,Red,Blue,Purple,Teal,Fuchsia,Aqua,White,
  Random, Rand, 1, 20
  If Rand >= 15
   Rand = 15
  StringGetPos, Rand, Colours, `,, L%Rand%
  Rand += 1
  Colours := SubStr(Colours,Rand + 1,InStr(Colours,",",False,Rand + 1) - (Rand + 1))
  Gui, Font, s%Size% c%Colours%
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