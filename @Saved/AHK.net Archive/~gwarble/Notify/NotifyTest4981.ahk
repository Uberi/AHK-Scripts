GoSub, Initialize

 Notify("Notify() Demo Script...","General usage/syntax demonstration...",0,"SI=500 Image=44")
 Notify("Option=  vs.  Option_=","GC=Yellow TS_=20 SI=100","","GC=Yellow TS_=20 SI=200")
 Notify("Notify() Demo Script...","Static/One-time options...",0,"SI=500 Image=44")
 n1:=Notify("Saving style example...","Use Style=Load later to repeat this style...",30,"Image=167 GC_=aaaaff BC_=0000ff Style=Save")

 Notify("Error!","This is an error style!",60,"Style=Error GW=200 GH=100")
 Notify("Warning...","You destroyed a 100 Megabuck lander.",15,"Style=Warning GW=200 GH=100")
 Notify("Info","Red 5 standing by...",7,"Style=Info GW=200 GH=100")
 Notify("Now look!!!","i'm loading the style...","","Style=Load")

 Notify("","","","Wait=" Notify("I'm pausing the script until clicked","the Wait=All command next will kill em all",0,"Style=Default Image=44"))
 Notify("","",-.01,"Wait=All") ; kills all open notify's

 Notify("Notify() Demo Script...","General usage/syntax demonstration...",0,"SI=500 Image=44")
 Notify("","ToolTip Style",60,"Style=ToolTip")
 Notify("Balloon Tip","Style, kinda...","","Style=BalloonTip")
 Notify("Progress","Style",0,"Style=Progress")
 Notify("Now look!!!","i'm loading the style...","","Style=Load")

 Nid3:=Notify("Installing...","Initializing...",0,"SI=500 ST=250  ST=250 WP=gradient.bmp PG=50  PH=20 Image=163 IW=64 IH=64")
 sleep,100
 SetTimer, UpdateProgress, % A := 100

 sleep,500
 Failure = Title=The action failed... Duration=20 GC=Red GW=300 BC_=Maroon TC_=White MC_=White Image=132 IH=16 IW=16 BT_=255 BR_=0 GR_=0 BW_=3 SI=_200
 Success = Title=Finished successfully! Duration=200 GW=300 GC_=Green BC_=Lime TC_=White MC_=White Image=44 IW=16 IH=16 BT_=255 BR_=0 GR_=0 BW_=3 SI=_200
 Notify("","","",Success)
 Notify("","","",Success)
 Notify("","","",Failure)

 Sleep,2000
 Notify("","","","Wait=" Notify("I'm pausing the script until clicked","the Wait=All command next will kill em all",0,"Style=Default Image=44"))
 Notify("","",-.01,"Wait=All") ; kills all open notify's
 Notify("Notify() Demo Script...","when this one is clicked it`nwill kill the script via negative duration","-0","Style=Default Image=44")
Return

UpdateProgress:
 Notify("",A-- "% left to go...","+1","Update=" Nid3)
 If A < 50
 {
  SetTimer, UpdateProgress, Off
  Notify("","Finished!","","Update=" Nid3)
 }
Return

Initialize:
 #SingleInstance, Force
 SetWorkingDir, %A_ScriptFullPath%
 GradientFile = Gradient.bmp
 IfExist, % GradientFile
  Return
{
 _ =
( join
424d46000000000000003600000028000000020000000200000001
001800000000001000000000000000000000000000000000000000
ead999ead9990000
ffffffffffff0000
)
 WriteFile(GradientFile,_)
}
Return
WriteFile(file,data)
{
 Handle :=  DllCall("CreateFile","str",file,"Uint",0x40000000
               ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
  Loop
  {
   if strlen(data) = 0
    Break
   StringLeft, Hex, data, 2         
   StringTrimLeft, data, data, 2
   Hex = 0x%Hex%
   DllCall("WriteFile","UInt", Handle,"UChar *", Hex
  ,"UInt",1,"UInt *",UnusedVariable,"UInt",0)
 }
 DllCall("CloseHandle", "Uint", Handle)
 Return
}




;——————————————————————————————————————————————————————
;—————   Notify() 0.4981 by gwarble           ——————————
;———       multiple tray area notifications    ————————
;—                                               ——————
;  Notify([Title,Message,Duration,Options])
;
; Duration  seconds to show notification [Default: 30]
;             0  for permanent/remain until clicked (flashing)
;            -3  negative value to ExitApp on click/timeout
;           "-0" for permanent and ExitApp when clicked
;
; Options   string of options, space seperated, ie:
;           "TS=16 TM=8 TF=Times New Roman GC_=Blue SI_=1000"
;           most options are remembered (static), some not (local)
;           Option_= can be used for non-static call, ie:
;           "GC=Blue" makes all future blue, "GC_=Blue" only takes effect once
;           "Wait=ID"   to wait for a notification
;           "Update=ID" to change Title, Message, and Progress Bar (with 'Duration')
;
; Return   ID (Gui Number used)
;          0 if failed (too many open most likely)
;          VarValue if Options includes: Return=VarName
;——————————————————————————————————————————————————————————————————————————————————
Notify(Title="Notify()",Message="",Duration="",Options="")
{
 static GNList, ACList, ATList, AXList, Exit, _Wallpaper_, _Title_, _Message_, _Progress_, _Image_, Saved
 static GF := 50 			; Gui First Number
 static GL := 74 			; Gui Last  Number (defining range)
 static GC,GR,GT,BC,BK,BW,BR,BT,BF
 static TS,TW,TC,TF,MS,MW,MC,MF
 static SI,SC,ST,IW,IH,IN,XC,XS,XW,PC,PB
 If (Options)
 {
  Options.=" "
  Loop,Parse,Options,= 			;= parse options string, needs better whitespace handling
  {
      If A_Index = 1
        Option := A_LoopField
      Else
      {
        %Option% := SubStr(A_LoopField, 1, (pos := InStr(A_LoopField, A_Space, false, 0))-1)
        Option   := SubStr(A_LoopField, pos+1)
      }
  }
  If Wait <>
  {
      If Wait Is Number			;= wait for a specific notify
      {
        Gui %Wait%:+LastFound
        If NotifyGuiID := WinExist()
        {
          WinWaitClose, , , % Abs(Duration)
          If (ErrorLevel && Duration < 1)
          {
            Gui, % Wait + GL - GF + 1 ":Destroy"
            If ST
              DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
            Gui, %Wait%:Destroy
          }
        }
      }
      Else				;= wait for all notify's
      {
        Loop, % GL-GF
        {
          Wait := A_Index + GF - 1
          Gui %Wait%:+LastFound
          If NotifyGuiID := WinExist()
          {
            WinWaitClose, , , % Abs(Duration)
            If (ErrorLevel && Duration < 1)
            {
              Gui, % Wait + GL - GF + 1 ":Destroy"
              If ST
                DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
              Gui, %Wait%:Destroy
            }
          }
        }
        GNList := ACList := ATList := AXList := ""
      }
      Return
  }
  If Update <>
  {
      If Title <>
       GuiControl, %Update%:,_Title_,%Title%
      If Message <>
       GuiControl, %Update%:,_Message_,%Message%
      If Duration <>
       GuiControl, %Update%:,_Progress_,%Duration%
      Return
  }
  If Style = Save
  {
   Saved := Options " GC=" GC " GR=" GR " GT=" GT " BC=" BC " BK=" BK " BW=" BW " BR=" BR " BT=" BT " BF=" BF
   Saved .= " TS=" TS " TW=" TW " TC=" TC " TF=" TF " MS=" MS " MW=" MW " MC=" MC " MF=" MF
   Saved .= " IW=" IW " IH=" IH " IN=" IN " PW=" PW " PH=" PH " PC=" PC " PB=" PB " XC=" XC " XS=" MS " XW=" XW
   Saved .= " SI=" SI " SC=" SC " ST=" ST " WF=" Image " IF=" IF
  }
  If Return <>
   Return, % (%Return%)
  If Style <>
  {
   If Style = Default
    Return % Notify(Title,Message,Duration,
(
"GC= GR= GT= BC= BK= BW= BR= BT= BF= TS= TW= TC= TF= 
 MS= MW= MC= MF= SI= ST= SC= IW=
 IH= IN= XC= XS= XW= PC= PB= " Options "Style=")
)
   Else If Style = ToolTip
    Return % Notify(Title,Message,Duration,"SI=50 GC=FFFFAA BC=00000 GR=0 BR=0 BW=1 BT=255 TS=8 MS=8 " Options "Style=")
   Else If Style = BalloonTip
    Return % Notify(Title,Message,Duration,"SI=350 GC=FFFFAA BC=00000 GR=13 BR=15 BW=1 BT=255 TS=10 MS=8 AX=1 XC=999922 IN=8 Image=" A_WinDir "\explorer.exe " Options "Style=")
   Else If Style = Error
    Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=10 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
   Else If Style = Warning
    Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=9 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
   Else If Style = Info
    Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=8 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
   Else If Style = Question
    Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 Image=24 IW=32 IH=32 " Options "Style=")
   Else If Style = Progress
    Return % Notify(Title,Message,Duration,"SI=100 GC=Default BC=00000 GR=9 BR=13 BW=2 BT=105 TS=10 MS=10 PG=100 PH=10 GW=300 " Options "Style=")
   Else If Style = Huge
    Return % Notify(Title,Message,Duration,"SI=100 ST=200 SC=200 GC=FFFFAA BC=00000 GR=27 BR=39 BW=6 BT=105 TS=24 MS=22 " Options "Style=")
   Else If Style = Load
    Return % Notify(Title,Message,Duration,Saved)
  }
 }
;—————— end if options ————————————————————————————————————————————————————————————————————————————

  GC_ := GC_<>"" ? GC_ : GC := GC<>"" ? GC : "FFFFAA"
  GR_ := GR_<>"" ? GR_ : GR := GR<>"" ? GR : 9
  GT_ := GT_<>"" ? GT_ : GT := GT<>"" ? GT : "Off"
  BC_ := BC_<>"" ? BC_ : BC := BC<>"" ? BC : "000000"
  BK_ := BK_<>"" ? BK_ : BK := BK<>"" ? BK : "Silver"
  BW_ := BW_<>"" ? BW_ : BW := BW<>"" ? BW : 2
  BR_ := BR_<>"" ? BR_ : BR := BR<>"" ? BR : 13
  BT_ := BT_<>"" ? BT_ : BT := BT<>"" ? BT : 105
  BF_ := BF_<>"" ? BF_ : BF := BF<>"" ? BF : 350
  TS_ := TS_<>"" ? TS_ : TS := TS<>"" ? TS : 10
  TW_ := TW_<>"" ? TW_ : TW := TW<>"" ? TW : 625
  TC_ := TC_<>"" ? TC_ : TC := TC<>"" ? TC : "Default"
  TF_ := TF_<>"" ? TF_ : TF := TF<>"" ? TF : "Default"
  MS_ := MS_<>"" ? MS_ : MS := MS<>"" ? MS : 10
  MW_ := MW_<>"" ? MW_ : MW := MW<>"" ? MW : "Default"
  MC_ := MC_<>"" ? MC_ : MC := MC<>"" ? MC : "Default"
  MF_ := MF_<>"" ? MF_ : MF := MF<>"" ? MF : "Default"
  SI_ := SI_<>"" ? SI_ : SI := SI<>"" ? SI : 0
  SC_ := SC_<>"" ? SC_ : SC := SC<>"" ? SC : 0
  ST_ := ST_<>"" ? ST_ : ST := ST<>"" ? ST : 0
  IW_ := IW_<>"" ? IW_ : IW := IW<>"" ? IW : 32
  IH_ := IH_<>"" ? IH_ : IH := IH<>"" ? IH : 32
  IN_ := IN_<>"" ? IN_ : IN := IN<>"" ? IN : 0
  XF_ := XF_<>"" ? XF_ : XF := XF<>"" ? XF : "Arial Black"
  XC_ := XC_<>"" ? XC_ : XC := XC<>"" ? XC : "Default"
  XS_ := XS_<>"" ? XS_ : XS := XS<>"" ? XS : 12
  XW_ := XW_<>"" ? XW_ : XW := XW<>"" ? XW : 800
  PC_ := PC_<>"" ? PC_ : PC := PC<>"" ? PC : "Default"
  PB_ := PB_<>"" ? PB_ : PB := PB<>"" ? PB : "Default"

  wPW := ((PW<>"") ? ("w" PW) : (""))
  hPH := ((PH<>"") ? ("h" PH) : (""))
  If GW <>
  {
   wGW = w%GW%
   wPW := "w" GW - 20
  }
  hGH := ((GH<>"") ? ("h" GH) : (""))
  wGW_ := ((GW<>"") ? ("w" GW - 20) : (""))
  hGH_ := ((GH<>"") ? ("h" GH - 20) : (""))
;————————————————————————————————————————————————————————————————————————
 If Duration =
  Duration = 30
 GN := GF
 Loop
  IfNotInString, GNList, % "|" GN
   Break
  Else
   If (++GN > GL)
    Return 0            	  ;=== too many notifications open!
 GNList .= "|" GN
 GN2 := GN + GL - GF + 1

 If AC <>
  ACList .= "|" GN "=" AC
 If AT <>
  ATList .= "|" GN "=" AT
 If AX <>
  AXList .= "|" GN "=" AX


 P_DHW := A_DetectHiddenWindows
 P_TMM := A_TitleMatchMode
 DetectHiddenWindows On
 SetTitleMatchMode 1
 If (WinExist("_Notify()_GUI_"))  ;=== find all Notifications from ALL scripts, for placement
  WinGetPos, OtherX, OtherY       ;=== change this to a loop for all open notifications?
 DetectHiddenWindows %P_DHW%
 SetTitleMatchMode %P_TMM%

 Gui, %GN%:-Caption +ToolWindow +AlwaysOnTop -Border
 Gui, %GN%:Color, %GC_%
 If FileExist(WP)
 {
  Gui, %GN%:Add, Picture, x0 y0 w0 h0 v_Wallpaper_, % WP
  ImageOptions = x+8 y+4
 }
 If Image <>
 {
  If FileExist(Image)
   Gui, %GN%:Add, Picture, w%IW_% h%IH_% Icon%IN_% v_Image_ %ImageOptions%, % Image
  Else
   Gui, %GN%:Add, Picture, w%IW_% h%IH_% Icon%Image% v_Image_ %ImageOptions%, %A_WinDir%\system32\shell32.dll
  ImageOptions = x+10
 }
 If Title <>
 {
  Gui, %GN%:Font, w%TW_% s%TS_% c%TC_%, %TF_%
  Gui, %GN%:Add, Text, %ImageOptions% BackgroundTrans v_Title_, % Title
 }
 If PG
  Gui, %GN%:Add, Progress, Range0-%PG% %wPW% %hPH% c%PC_% Background%PB_% v_Progress_
 Else
  If ((Title) && (Message))
   Gui, %GN%:Margin, , -5
 If Message <>
 {
  Gui, %GN%:Font, w%MW_% s%MS_% c%MC_%, %MF_%
  Gui, %GN%:Add, Text, BackgroundTrans v_Message_, % Message
 }
 If ((Title) && (Message))
  Gui, %GN%:Margin, , 8
 Gui, %GN%:Show, Hide %wGW% %hGH%, _Notify()_GUI_
 Gui  %GN%:+LastFound
 WinGetPos, GX, GY, GW, GH
 GuiControl, %GN%:, _Wallpaper_, % "*w" GW " *h" GH " " WP
 GuiControl, %GN%:MoveDraw, _Title_,    % "w" GW-20 " h" GH-10
 GuiControl, %GN%:MoveDraw, _Message_,  % "w" GW-20 " h" GH-10
 If AX <>
 {
  GW += 10
  Gui, %GN%:Font, w%XW_% s%XS_% c%XC_%, Arial Black
  Gui, %GN%:Add, Text, % "x" GW-15 " y-2 Center w12 h20 g_Notify_Kill_" GN - GF + 1, ×
 } ; ×
 Gui, %GN%:Add, Text, x0 y0 w%GW% h%GH% BackgroundTrans g_Notify_Action_Clicked_ ; to catch clicks
 If (GR_)
  WinSet, Region, % "0-0 w" GW " h" GH " R" GR_ "-" GR_
 If (GT_)
  WinSet, Transparent, % GT_

 SysGet, Workspace, MonitorWorkArea
 NewX := WorkSpaceRight-GW-5
 If (OtherY)
  NewY := OtherY-GH-2-BW_*2
 Else
  NewY := WorkspaceBottom-GH-5
 If NewY < % WorkspaceTop
  NewY := WorkspaceBottom-GH-5

 Gui, %GN2%:-Caption +ToolWindow +AlwaysOnTop -Border +E0x20
 Gui, %GN2%:Color, %BC_%
 Gui  %GN2%:+LastFound
 If (BR_)
  WinSet, Region, % "0-0 w" GW+(BW_*2) " h" GH+(BW_*2) " R" BR_ "-" BR_
 If (BT_)
  WinSet, Transparent, % BT_

 Gui, %GN2%:Show, % "Hide x" NewX-BW_ " y" NewY-BW_ " w" GW+(BW_*2) " h" GH+(BW_*2), _Notify()_BGGUI_
 Gui, %GN%:Show,  % "Hide x" NewX " y" NewY " w" GW, _Notify()_GUI_
 Gui  %GN%:+LastFound
 If SI_
  DllCall("AnimateWindow","UInt",WinExist(),"Int",SI_,"UInt","0x00040008")
 Else
  Gui, %GN%:Show, NA, _Notify()_GUI_
 Gui, %GN2%:Show, NA, _Notify()_BGGUI_
 WinSet, AlwaysOnTop, On

 If ((Duration < 0) OR (Duration = "-0"))
  Exit := GN
 If (Duration)
  SetTimer, % "_Notify_Kill_" GN - GF + 1, % - Abs(Duration) * 1000
 Else
  SetTimer, % "_Notify_Flash_" GN - GF + 1, % BF_

Return %GN%

;==========================================================================
;========================================== when a notification is clicked:
_Notify_Action_Clicked_:
 ; Critical
 SetTimer, % "_Notify_Kill_" A_Gui - GF + 1, Off
 Gui, % A_Gui + GL - GF + 1 ":Destroy"
 If SC
 {
  Gui, %A_Gui%:+LastFound
  DllCall("AnimateWindow","UInt",WinExist(),"Int",SC,"UInt", "0x00050001")
 }
 Gui, %A_Gui%:Destroy
 If (ACList)
  Loop,Parse,ACList,|
   If ((Action := SubStr(A_LoopField,1,2)) = A_Gui)
   {
    Temp_Notify_Action:= SubStr(A_LoopField,4)
    StringReplace, ACList, ACList, % "|" A_Gui "=" Temp_Notify_Action, , All
    If IsLabel(_Notify_Action := Temp_Notify_Action)
     Gosub, %_Notify_Action%
    _Notify_Action =
    Break
   }
 StringReplace, GNList, GNList, % "|" A_Gui, , All
 SetTimer, % "_Notify_Flash_" A_Gui - GF + 1, Off
 If (Exit = A_Gui)
  ExitApp
Return

;==========================================================================
;=========================================== when a notification times out:
_Notify_Kill_1:
_Notify_Kill_2:
_Notify_Kill_3:
_Notify_Kill_4:
_Notify_Kill_5:
_Notify_Kill_6:
_Notify_Kill_7:
_Notify_Kill_8:
_Notify_Kill_9:
_Notify_Kill_10:
_Notify_Kill_11:
_Notify_Kill_12:
_Notify_Kill_13:
_Notify_Kill_14:
_Notify_Kill_15:
_Notify_Kill_16:
_Notify_Kill_17:
_Notify_Kill_18:
_Notify_Kill_19:
_Notify_Kill_20:
_Notify_Kill_21:
_Notify_Kill_22:
_Notify_Kill_23:
_Notify_Kill_24:
_Notify_Kill_25:
 Critical
 StringReplace, GK, A_ThisLabel, _Notify_Kill_
 SetTimer, _Notify_Flash_%GK%, Off
 GK := GK + GF - 1
 Gui, % GK + GL - GF + 1 ":Destroy"
 If ST
 {
  Gui, %GK%:+LastFound
  DllCall("AnimateWindow","UInt",WinExist(),"Int",ST,"UInt", "0x00050001")
 }
 Gui, %GK%:Destroy
 StringReplace, GNList, GNList, % "|" GK, , All
 If (Exit = GK)
  ExitApp
Return 1

;==========================================================================
;======================================== flashes a permanent notification:
_Notify_Flash_1:
_Notify_Flash_2:
_Notify_Flash_3:
_Notify_Flash_4:
_Notify_Flash_5:
_Notify_Flash_6:
_Notify_Flash_7:
_Notify_Flash_8:
_Notify_Flash_9:
_Notify_Flash_10:
_Notify_Flash_11:
_Notify_Flash_12:
_Notify_Flash_13:
_Notify_Flash_14:
_Notify_Flash_15:
_Notify_Flash_16:
_Notify_Flash_17:
_Notify_Flash_18:
_Notify_Flash_19:
_Notify_Flash_20:
_Notify_Flash_21:
_Notify_Flash_22:
_Notify_Flash_23:
_Notify_Flash_24:
_Notify_Flash_25:
 StringReplace, FlashGN, A_ThisLabel, _Notify_Flash_
 FlashGN += GF - 1
 FlashGN2 := FlashGN + GL - GF + 1
 If Flashed%FlashGN2% := !Flashed%FlashGN2%
  Gui, %FlashGN2%:Color, %BK%
 Else
  Gui, %FlashGN2%:Color, %BC%
Return
}