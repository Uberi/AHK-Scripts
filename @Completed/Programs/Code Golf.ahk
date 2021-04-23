;Code Golf
;Create a snippet of code that accomplishes a task with as few characters as possible. Carriage returns (`r) do not count towards the code length

Challenge := 12
If IsLabel("Challenge" . Challenge)
 Gosub, Challenge%Challenge%
Else
 MsgBox, Invalid Challenge.
ExitApp

;Show a triangle (60 chars)
Challenge1:
Loop,% i:=10{
Loop,% i--
t.=" "
t.=(l.=" .")"`n"
}MsgBox,%t%
Return

;Print out a list of numbers, with "Fizz" instead of the multiples of 3, "Buzz" instead of multiples of 5, and "FizzBuzz" instead of multiples of 15. (84 chars)
Challenge2:
i=0
Loop,20
f.=((t:=(Mod(++i,3)?"":"Fizz")(Mod(i,5)?"":"Buzz"))?t:i)"`n"
MsgBox,%f%
Return

;Parse CSV, formatting it into columns of equal width by padding items with spaces. (243 chars)
Challenge3:
i=Test1,Test2 abc`nbla123 test,Bla2
f=A_LoopField
Loop,Parse,i,`n
{c=0
Loop,Parse,%f%,CSV
c++t:=StrLen(%f%),t>m%c%?m%c%:=t
}Loop,Parse,i,`n
{t=0
r.="`n"
Loop,Parse,%f%,CSV
{r.=%f%
Loop,% ++t=c?:2+m%t%-StrLen(%f%)
r.=" "
}}
MsgBox,% SubStr(r,2)
Return

;A game where the user guesses a number, and the script shows whether or not it is a correct guess. The game must reset on a successful guess. (69 chars)
Challenge4:
Loop{
Random,r,0,9
While,g!=r{
Input,g,L1V
MsgBox,% g=r?"Yes":"No"
}}
Return

;Decimal to binary converter. (37 chars)
Challenge5:
d=5
While,d
t:=d&1 t,d>>=1
MsgBox,%t%
Return

;Find all factors of a number. (86 chars)
Challenge6:
i=0
Loop,% Sqrt(n:=64)//1
Mod(n,++i)?:o.=(i=1?"":",")i ","n//i
Sort,o,NUD`,
MsgBox,%o%
Return

;Convert numbers from one base to another (173 chars)
Challenge7:
n=42
i=12
o=10
InStr(n,"-")?(s:="-",n:=SubStr(n,2))
t:=0,c:=StrLen(n)
Loop,Parse,n
t+=(Asc(A_LoopField)-48)*i**--c
While,t>0
r:=Chr(Mod(t,o)+48)r,t//=o
MsgBox,% s (r=""?0:r)
Return

;Caesar cipher encryption and decryption (74 chars)
Challenge8:
s=HIZ
k=1
Loop,Parse,s
r.=Chr(Mod(Asc(A_LoopField)-65+k,26)+65)
MsgBox,%r%

/* ;AHK ANSI versions only (63 chars)
s=HI
k=1
p:=&s
While,*p
r.=Chr(Mod(*p++-65+k,26)+65)
MsgBox,%r%
*/
Return

;Bubble sort array (119 chars)
Challenge9:
a:=[3,2,1]
While,!f&j:=f:=1
Loop,% a.MaxIndex()-1
a[i:=j++]>a[j]?(t:=a[i],a[i]:=a[j],a[j]:=t,f:=0)
MsgBox % a.1 a.2 a.3
Return

;String padding with left and right alignment and ellipses for overflow (134 chars)
Challenge10:
MsgBox,% p(5,"abcdef")
p(c,s){
l:=StrLen(s)-a:=Abs(c)
Return,l<0?p(c,c<0?" "s:s " "):l?SubStr(s,1,Ceil(o:=a/2-2))"..."SubStr(s,-o):s
}
Return

;URL encoding (132 chars)
Challenge11:
s=I <3 golf
SetFormat,Integer,H
Loop,Parse,s
o.=RegExMatch(l:=A_LoopField,"[\w-\.~]")?l:"%"SubStr("0"SubStr(Asc(l),3),-1)
MsgBox %o%

;Case inversion (119 chars)
Challenge12:
s=CaSe sensitivity`ncAsE SENSITIVITY
loop,parse,s
a:=Asc(A_LoopField),r.=chr(a>64&&a<91||a>96&&a<123?a^32:a)
MsgBox,%r%
Return

Tab::
StringReplace, Temp1, Clipboard, `r,, All
MsgBox, % StrLen(Temp1)
Return