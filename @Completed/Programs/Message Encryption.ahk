#NoEnv

MinPasswordLen = 5
Salt = SomeRandomSalt

Gui, Font, s12 Bold, Arial
Gui, Add, Text, x2 y0 w350 h30 Center, Message Encryption/Decryption
Gui, Font, s8 Norm
Gui, Add, Radio, x2 y30 w170 h20 Checked gSetEncrypt vSetEncrypt, Create an encrypted message
Gui, Add, Radio, x182 y30 w170 h20 gSetDecrypt vSetDecrypt, Decrypt an encrypted message
Gui, Add, Text, x2 y60 w60 h20, MessagePassword:
Gui, Add, Edit, x62 y60 w290 h20 MessagePassword* vPassword
Gui, Add, Text, x2 y90 w350 h20 Center, Message
Gui, Add, Edit, x2 y110 w350 h190 vMessage
Gui, Font, s12
Gui, Add, Button, x2 y310 w350 h30 vSetAction gProcess, Encrypt
Gui, Show, w355 h345, Encryption
Return

GuiEscape:
GuiClose:
ExitApp

SetEncrypt:
GuiControl,, SetAction, Encrypt
Return

SetDecrypt:
GuiControl,, SetAction, Decrypt
Return

Process:
Gui, Submit, NoHide
If (StrLen(MessagePassword) < MinPasswordLen)
{
 MsgBox, 262160, Error, MessagePassword must be at least %MinPasswordLen% characters long.
 Return
}
If Message = 
{
 MsgBox, 262160, Error, Message cannot be blank.
 Return
}
If RegExMatch(MessagePassword,"iS)[^[[:alnum:]][[:space:]][[:punct:]]]")
{
 MsgBox, 262160, Error, MessagePassword can only contain alphanumeric`, whitespace`, and punctuation characters.
 Return
}
If RegExMatch(Message,"iS)[^[[:alnum:]][[:space:]][[:punct:]]]")
{
 MsgBox, 262160, Error, Message can only contain alphanumeric`, whitespace`, and punctuation characters.
 Return
}
If SetEncrypt
{
 Encrypt()
 GuiControl,, SetDecrypt, 1
 GuiControl,, SetAction, Decrypt
}
Else
{
 If Decrypt()
  Return
 GuiControl,, SetEncrypt, 1
 GuiControl,, SetAction, Encrypt
}
GuiControl,, Message, %Message%
Return

Encrypt()
{
 global
 Message .= ":" . MD5(Message . Salt)
 Message := RC4Encrypt(Message,MessagePassword)
}

Decrypt()
{
 local MD5
 Message := RC4Decrypt(Message,MessagePassword)
 If (SubStr(Message,-32,1) <> ":")
 {
  MsgBox, 262160, Error, Could not decrypt message.
  Return, 1
 }
 MD5 := SubStr(Message,-31)
 StringTrimRight, Message, Message, 33
 If (MD5(Message . Salt) <> MD5)
 {
  MsgBox, 262164, Error, Message has failed verification. Continue?
  IfMsgBox, Yes
   Return
  Return, 1
 }
}

MD5(ByRef V)
{
 L := StrLen(V)
 VarSetCapacity(MD5_CTX,104,0)
 DllCall("advapi32\MD5Init",Str,MD5_CTX)
 DllCall("advapi32\MD5Update",Str,MD5_CTX,Str,V,UInt,L ? L : VarSetCapacity(V))
 DllCall("advapi32\MD5Final",Str,MD5_CTX)
 Loop, % StrLen(Hex := "123456789ABCDEF0")
 {
  N := NumGet(MD5_CTX,87 + A_Index,"Char")
  MD5 .= SubStr(Hex,N >> 4,1) . SubStr(Hex,N & 15,1)
 }
 Return, MD5
}

RC4Encrypt(Data,Pass)
{
 Format := A_FormatInteger
 SetFormat Integer, Hex
 b := 0
 j := 0
 VarSetCapacity(Result,StrLen(Data) * 2)
 Loop, 256
 {
  a := A_Index - 1
  Key%a% := Asc(SubStr(Pass,Mod(a,StrLen(Pass)) + 1,1))
  sBox%a% = %a%
 }
 Loop, 256
 {
  a := A_Index - 1
  b := b + sBox%a% + Key%a% & 255
  T := sBox%a%
  sBox%a% := sBox%b%
  sBox%b% := T
 }
 Loop, Parse, Data
 {
  i := A_Index & 255
  j := sBox%i% + j & 255
  k := sBox%i% + sBox%j% & 255
  Result .= SubStr(Asc(A_LoopField) ^ sBox%k%,-1,2)
 }
 StringReplace, Result, Result, x, 0, All
 SetFormat, Integer, %Format%
 Return, Result
}

RC4Decrypt(Data,Pass)
{
 b := 0
 j := 0
 x = 0x
 VarSetCapacity(Result,StrLen(Data) // 2)
 Loop, 256
 {
  a := A_Index - 1
  Key%a% := Asc(SubStr(Pass,Mod(a,StrLen(Pass)) + 1,1))
  sBox%a% = %a%
 }
 Loop, 256
 {
  a := A_Index - 1
  b := b + sBox%a% + Key%a% & 255
  T := sBox%a%
  sBox%a% := sBox%b%
  sBox%b% = %T%
 }
 Loop, % StrLen(Data) // 2
 {
  i := A_Index & 255
  j := sBox%i% + j & 255
  k := sBox%i% + sBox%j% & 255
  Result .= Chr((x . SubStr(Data,2 * A_Index - 1,2)) ^ sBox%k%)
 }
 Return, Result
}