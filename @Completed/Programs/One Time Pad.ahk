#NoEnv

OTP := "19B0116612D35F58722B7E43A2C906D36FD6A3E0AC5D0EC65BAB0CF915A6CF275085119978FF037485A729D16012B4B44F48F8A834576B77795E987DA11ED4AAF6337A4FF03DC7A11E676D677D097CE2B9E1A2104C8BF276519C5813D47632219141B47E" ;default starting one time pad

Gui, Font, s12 Bold, Arial
Gui, Add, Text, x2 y0 w370 h20 +Center, One Time Pad Encryption
Gui, Font, s10
Gui, Add, Text, x2 y30 w40 h20, OTP:
Gui, Add, Text, x2 y60 w50 h20, Offset:
Gui, Add, Text, x182 y60 w100 h20, Chars Left:
Gui, Add, Button, x262 y30 w110 h20, Load From File
Gui, Font, Norm
Gui, Add, Edit, x52 y30 w210 h20 vOTP gSetOTP, %OTP%
Gui, Add, Edit, x52 y60 w70 h20 Right
Gui, Add, UpDown, vOTPOffset gSetOTP, 0
Gui, Add, Text, x282 y60 w90 h20 vCharsLeft Right
Gui, Add, Edit, x2 y90 w370 h220 vMessage gSetMessage, Message
Gui, Font, Bold
Gui, Add, Button, x2 y320 w200 h30, Encrypt
Gui, Add, Button, x202 y320 w170 h30, Decrypt
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w375 h350, OTP Encryption
Gosub, SetOTP
Gosub, SetMessage
Return

GuiEscape:
GuiClose:
ExitApp

ButtonLoadFromFile:
FileSelectFile, Temp1, 27,, Please Select A File Containing The OTP
FileRead, Temp1, %Temp1%
GuiControl,, OTP, %Temp1%
Gosub, SetOTP
Return

SetOTP:
Gui, Submit, NoHide
If OTP Is Not XDigit
{
 MsgBox, 262160, Error, OTP can only contain hexadecimal numbers.
 OTP := OTP1
}
Else
 OTP1 := OTP
CharsLeft := StrLen(OTP) // 2
GuiControl, +Range0-%CharsLeft%, OTPOffset
CharsLeft -= OTPOffset
GuiControl, +Limit%CharsLeft%, Message
GuiControl,, CharsLeft, % (CharsLeft - StrLen(Message)) . "/" . CharsLeft
Return

SetMessage:
Gui, Submit, NoHide
Temp1 := StrLen(Message)
If (Temp1 > CharsLeft) ;exceeded length, must truncate message
{
 GuiControl,, Message, %Message1%
 Message := Message1
}
Else
 Message1 := Message
GuiControl,, CharsLeft, % (CharsLeft - Temp1) . "/" . CharsLeft
Return

ButtonEncrypt:
Gui, Submit, NoHide
If (StrLen(Message) > CharsLeft) ;exceeded length, must truncate message
{
 MsgBox, 262160, Error, One time pad length is insufficient.
 Return
}
Message := OTPEncrypt(OTP,Message,OTPOffset)
GuiControl,, Message, %Message%
MsgBox, 262208, Offset, The offset to decrypt the message is %OTPOffset%
Return

ButtonDecrypt:
Gui, Submit, NoHide
StringReplace, OTP, OTP, 00,, All
Temp1 := StrLen(Message)
If (Temp1 & 1) ;message length is odd, should always be even
{
 MsgBox, 262160, Error, Message length is odd.
 Return
}
StringReplace, Message, Message, %NewLineChar%, `n, All
GuiControl,, Message, % OTPDecrypt(OTP,Message,OTPOffset)
OTPOffset += Temp1 // 2
MsgBox, 262208, Offset, The new offset is %OTPOffset%
GuiControl,, OTPOffset, %OTPOffset%
Gosub, SetOTP
Return

OTPEncrypt(ByRef OTP,Message,Offset = 0)
{
 Critical
 FormatInteger := A_FormatInteger
 SetFormat, IntegerFast, Hex
 Loop, Parse, Message
 {
  Temp1 := "0x" . SubStr(OTP,((A_Index + Offset) << 1) - 1,2) ;extract number from one time pad
  Temp1 ^= Asc(A_LoopField) ;XOR message with one time pad
  OTPMessage .= SubStr("0" . SubStr(Temp1,3),-1) ;append to output
 }
 SetFormat, IntegerFast, %FormatInteger%
 Return, OTPMessage
}

OTPDecrypt(ByRef OTP,OTPMessage,Offset = 0)
{
 Critical
 FormatInteger := A_FormatInteger
 SetFormat, IntegerFast, Hex
 Offset <<= 1
 Loop, Parse, OTPMessage
 {
  Position := (A_Index << 1) - 1
  Temp1 := "0x" . SubStr(OTP,Position + Offset,2) ;extract number from one time pad
  Temp2 := "0x" . SubStr(OTPMessage,Position,2) ;extract number from message
  Temp1 ^= Temp2 ;XOR message with one time pad
  Message .= Chr(Temp1) ;append to output
 }
 SetFormat, IntegerFast, %FormatInteger%
 Return, Message
}