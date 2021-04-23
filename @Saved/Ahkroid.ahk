#SingleInstance Force
#Persistent
#NoEnv
Process, Priority, , High
SetBatchLines, -1
OnExit, ExitSub

Left:="Left"        ; turn left
Right:="Right"      ; turn right
Up:="Up"            ; move forward
Down:="Down"        ; move backward
Space:="Space"      ; use weapon

VarSetCapacity(ptWin, 16, 0)
NumPut(W:=512, ptWin, 8) , NumPut(H:=384, ptWin, 12)
Gui, Show, w%W% h%H%, Ahkroid
  hdcWin := DllCall("GetDC", "UInt", hwnd:=WinExist("A"))
  hdcMem := DllCall("CreateCompatibleDC", "UInt", hdcWin)
  hbm := DllCall("CreateCompatibleBitmap", "uint", hdcWin, "int", W, "int", H)
DllCall("SelectObject", "uint", hdcMem, "uint", hbm)

X:=W/2 , Y:=H/2 , Vx:=Vy:=Va:=cd:=score:=0 , shield:="||||||||||" , nRoid:=6
  formS1:="0,0,10,5,0,-15,-10,5,0,0"
  formS2:="0,10,10,5,0,-15,-10,5,0,10"
VarSetCapacity(ptShip, 40)

  formB1:="-1,0,0,-1,1,0,0,1,-1,0"
VarSetCapacity(ptBall, 40)

  formR1:="-12,-28,0,-20,16,-28,28,-16,16,-8,28,8,12,28,-8,20,-16,28,-28,16,-20,0,-28,-16,-12,-28"
  formR2:="-6,-14,0,-10,8,-14,14,-8,8,-4,14,4,6,14,-4,10,-8,14,-14,8,-10,0,-14,-8,-6,-14"
  formR3:="-3,-7,-0,-5,4,-7,7,-4,4,-2,7,2,3,7,-2,5,-4,7,-7,4,-5,0,-7,-4,-3,-7"
VarSetCapacity(ptRoid, 104)
loop %nRoid%
  listRoid .= "|1," rand(0, W, X) "," rand(0, H, Y) "," rand(0.0, 6)-3 "," rand(0.0, 6)-3

SetTimer, Update, 25
return

; --------------------------------

Update:
Critical

DllCall("FillRect", "uint", hdcMem, "uint", &ptWin, "uint", 0)

DllCall("TextOut", "uint", hdcMem, "uint", 16, "uint", 8, "uint", &score, "uint", StrLen(score))
DllCall("TextOut", "uint", hdcMem, "uint", 16, "uint", 24, "uint", &shield, "uint", StrLen(shield))

; ----

Va += GetKeyState(Left) ? -0.1 : GetKeyState(Right) ? 0.1 : 0
formS0:="" , form := GetKeyState(Up) ? formS2 : formS1
loop, parse, form, `,
  a_index & 1 ? i1:=a_loopfield : formS0 .= i1*cos(Va)-a_loopfield*sin(Va) "," i1*sin(Va)+a_loopfield*cos(Va) ","

Vs := GetKeyState(Up) ? 0.4 : GetKeyState(Down) ? -0.2 : 0
Vx:=Vx*0.95+sin(Va)*Vs , Vy:=Vy*0.95-cos(Va)*Vs
X:= X<0 ? W : X>W ? 0 : X+Vx , Y:= Y<0 ? H : Y>H ? 0 : Y+Vy

DllCall("DeleteObject", "UInt", hShip)
loop, parse, formS0, `,
    NumPut(a_loopfield+(a_index & 1 ? X : Y), ptShip, a_index*4-4)
DllCall("Polyline", "uint", hdcMem, "uint", &ptShip, "int", 5)
hShip := DllCall("CreatePolygonRgn", "uint", &ptShip, "int", 4, "int", 1)

; ----

cd-= cd>0 ? 1 : 0
if ( GetKeyState(Space) && cd=0 )
  cd:=5 , listBall .= "|" a_tickcount "," X+sin(Va)*10 "," Y-cos(Va)*10 "," Va

loop, parse, listBall, |
{
  if a_index=1
    continue
  loop, parse, a_loopfield, `,
    i%a_index%:=a_loopfield
  if (i1+1000 < a_tickcount) {
    StringReplace, listBall, listBall, % "|" i1 "," i2 "," i3 "," i4 ,
    continue
  }
    iX:=i2+sin(i4)*8 , iY:=i3-cos(i4)*8
    iX:= iX<0 ? W : iX>W ? 0 : iX , iY:= iY<0 ? H : iY>H ? 0 : iY
    StringReplace, listBall, listBall, % "|" i1 "," i2 "," i3 "," i4 , % "|" i1 "," iX "," iY "," i4
    loop, parse, formB1, `,
      NumPut(a_loopfield+(a_index & 1 ? iX : iY), ptBall, a_index*4-4)
    DllCall("Polyline", "uint", hdcMem, "uint", &ptBall, "int", 5)
}

; ----

loop, parse, listRoid, |
{
  id:=a_index-1
  if a_index=1
    continue
  loop, parse, a_loopfield, `,
    i%a_index%:=a_loopfield
  iX:= i2+i4<0 ? W : i2+i4>W ? 0 : i2+i4 , iY:= i3+i5<0 ? H : i3+i5>H ? 0 : i3+i5
  StringReplace, listRoid, listRoid, % "|" i1 "," i2 "," i3 "," i4 "," i5 , % "|" i1 "," iX "," iY "," i4 "," i5
  loop, parse, formR%i1%, `,
    NumPut(a_loopfield+(a_index & 1 ? iX : iY), ptRoid, a_index*4-4)
  DllCall("Polyline", "uint", hdcMem, "uint", &ptRoid, "int", 13)
  hRoid := DllCall("CreatePolygonRgn", "uint", &ptRoid, "int", 12, "int", 1)

  loop, parse, listBall, |
  {
    if a_index=1
      continue
    StringSplit, t, A_LoopField, `,
    if ( DllCall("PtInRegion", "uint", hRoid, "uint", t2, "uint", t3) <> 0 )
    {
      StringReplace, listBall, listBall, % "|" t1 "," t2 "," t3 "," t4
      StringReplace, listRoid, listRoid, % "|" i1 "," iX "," iY "," i4 "," i5
      score+=i1*5
      if (i1<3) {
        i1++
        loop 2
          listRoid .= "|" i1 "," iX "," iY "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
      }
    }
  }

  if ( DllCall("CombineRgn", "uint", hRoid, "uint", hRoid, "uint", hShip, "int", 1) <> 1 ) {
  Vx:=i4 , Vy:=i5
  shield := SubStr(shield, 1, -1)
    if (shield="") {
      msgbox %score% points
      Reload
    }
  StringReplace, listRoid, listRoid, % "|" i1 "," iX "," iY "," i4 "," i5 ,
    if (i1<3) {
      i1++
      loop 2
        listRoid .= "|" i1 "," iX "," iY "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
    }
  }

DllCall("DeleteObject", "UInt", hRoid)
}

; -----

if (id<nRoid-1) {
nRoid++ , shield.="|"
loop %nRoid%
  listRoid .= "|1," rand(0, W, X) "," rand(0, H, Y) "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
}

DllCall("BitBlt", "uint", hdcWin, "int", 0, "int", 0, "int", W, "int", H, "uint", hdcMem, "int", 0, "int", 0, "uint", 0xCC0020)
return

; --------------------------------

Rand(min=0, max=1, mask="") {
loop {
  Random, result, min, max
  if ( mask="" || result<mask-100 || result>mask+100 )
    return result
  }
}

ExitSub:
guiclose:
  DllCall("DeleteObject", "UInt", hShip)
  DllCall("DeleteObject", "UInt", hRoid)
  DllCall("DeleteObject", "UInt", hbm)
  DllCall("DeleteDC", "UInt", hdcMem)
  DllCall("ReleaseDC", "UInt", hwnd, "UInt", hdcWin)
exitapp