#SingleInstance force
#NoEnv
SetBatchLines, -1
VarSetCapacity(buffer, 10000)
Menu, Tray, Icon, shell32.dll, 101

EM_GetLine	:= 0xC4
EM_GetLineCount	:= 0xBA
EM_GetSel	:= 0xB0
EM_LineFromChar	:= 0xC9
EM_LineIndex	:= 0xBB
EM_LineLength	:= 0xC1
EM_SetSel	:= 0xB1

delimiters = ,,,(,),%A_Tab%,%A_Space%,{,},[,]


~LButton::
MouseGetPos,,,,ctrl, 1
If (InStr(ctrl,"Edit",1) != 1)
OR (A_TimeSincePriorHotkey > 200)
OR !(A_PriorHotkey)
 return

Click
SendMessage, EM_GetSel, &buffer,,%ctrl%, A
caret := NumGet(buffer)
KeyWait, LButton
KeyWait, LButton, D T0.2
num := ErrorLevel

SendMessage, EM_LineFromChar, -1,,%ctrl%, A
lineNum := ErrorLevel

buffer = 10000
SendMessage, EM_GetLine, lineNum, &buffer, %ctrl%, A
text := buffer
length := ErrorLevel

SendMessage, EM_LineIndex, -1,,%ctrl%, A
frstChar := ErrorLevel
caret2 := caret - frstChar + 1

If (caret2 > length)
{
 caret--
 caret2--
}
If (caret2 < 1) OR (caret2 > length)
 return
frstChar = 0
lastChar = 0
forw = 1
back = 1
If num
 GoSub, 2x
Else GoSub, 3x
SendMessage, EM_SetSel, caret-frstChar, caret+lastChar+1, %ctrl%, A
return

2x:
char := SubStr(text,caret2,1)
If char is alpha
 type = alpha
Else If char is digit
 type = digit
Else type=
Loop
{
 If forw
 {
  If (char := SubStr(text,(caret2+A_Index),1)) OR (char=0)
   If type
    If char is %type%
     lastChar++
    Else forw = 0
   Else
    If char is not alnum
     lastChar++
    Else forw = 0
  Else forw = 0
 }
 If back
 {
  If (caret2 = A_Index)
  {
   back = 0
   continue
  }
  If (char := SubStr(text,(caret2-A_Index),1)) OR (char=0)
   If type
    If char is %type%
     frstChar++
    Else back = 0
   Else
    If char is not alnum
     frstChar++
    Else back = 0
  Else back = 0
 }
 If (forw=0) AND (back=0)
  break
}
return

3x:
Loop
{
 If forw
 {
  If (char := SubStr(text,(caret2+A_Index),1)) OR (char=0)
   If char not in %delimiters%
    lastChar++
   Else forw = 0
  Else forw = 0
 }
 If back
 {
  If (caret2 = A_Index)
  {
   back = 0
   continue
  }
  If (char := SubStr(text,(caret2-A_Index),1)) OR (char=0)
   If char not in %delimiters%
    frstChar++
   Else back = 0
  Else back = 0
 }
 If (forw=0) AND (back=0)
  break
}
return

; (hello.world1234foobar) .