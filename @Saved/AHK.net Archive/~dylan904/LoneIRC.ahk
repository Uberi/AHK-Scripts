#SingleInstance Force

ChatStartup:
FileCreateDir, %A_ScriptDir%\Extras
SetWorkingDir, %A_ScriptDir%\Extras
SetBatchLines, -1
OnExit, ExitSub
If !FileExist("redbutton.ico")
   UrlDownloadToFile, http://www.autohotkey.net/~dylan904/redbutton.ico, redbutton.ico
If !FileExist("favicon (1).ico")
   UrlDownloadToFile, http://www.autohotkey.net/~dylan904/favicon (1).ico, favicon (1).ico
If !FileExist("grad.png")
   UrlDownloadToFile, http://www.autohotkey.net/~dylan904/grad.png, grad.png
   
ChanCounter := 0, Version_Number := 1.115
Check_ForUpdate(1)

Gui, 80: +LastFound
Gui, 80: Add, Edit, x10 y475 w630 vTextBox gCancelTabbing -WantReturn
Gui, 80: Add, Button, x643 y474 w30 w20 gSendText vSender +Default, Send
Gui, 80: Add, Button, +BackgroundTrans x700 yp vCloseConvo gCloseConvo, Close Tab

IniRead, ReadDefName, IRC.ini, User, Name, % ""
IniRead, ReadDefChan, IRC.ini, User, Channel, % ""

Gui, 81: Add, Picture, x0 y0 h190 w280 0x4000000, grad.png
Gui, 81: Font, s12, Arial
Gui, 81: Add, Text, Center W270 yp+20 x5 +BackgroundTrans, Desired NickName
Gui, 81: Add, Edit, vNickName W150 yp+20 xp+60, %ReadDefName%
Gui, 81: Add, Text, Center W270 yp+30 x5 +BackgroundTrans, Channel To Join
Gui, 81: Add, Edit, vChannel1 W150 yp+20 xp+60, %ReadDefChan%
Gui, 81: Add, Button, +BackgroundTrans +Default xm h40 xm y+20 w90 -Wrap hwndhBtn, Join
  ILButton(hbtn, "favicon (1).ico", 32, 32, "left")
81GuiShow:
Gui, 81: Show, w280 h190

Return
81GuiClose:
ExitApp
81ButtonJoin:
Gui, 81: Submit
If (NickName = "" or Channel1 = "")
	GoTo, 81GuiShow
Channel1 := (SubStr(Channel1, 1, 1) = "#") ? Channel1 : "#" Channel1
IniWrite, %NickName%, IRC.ini, User, Name
IniWrite, %Channel1%, IRC.ini, User, Channel
Menu, ChatOps, Add, &Add Channel, AddChan
Menu, MyMenuBar, Add, &Options, :ChatOps
Gui, 80: Menu, mymenubar
GoTo, ContinueChat	;Skip The Label Below

AddChan:
Gui, 82: Add, Picture, x0 y0 h130 w280 0x4000000, grad.png
Gui, 82: Font, s12, Arial
Gui, 82: Add, Text, Center W270 yp+20 x5 +BackgroundTrans, New Channel
Gui, 82: Add, Edit, vChannel W150 yp+20 xp+60
Gui, 82: Add, Button, +BackgroundTrans +Default xm h40 xm y+20 w90 -Wrap hwndhBtn, Join
	ILButton(hbtn, "favicon (1).ico", 32, 32, "left")
Gui, 82: Show, w280 h130
return
82ButtonJoin:
Gui, 82: Submit
ChanAndOne := ChanCounter + 1, ChosenUser := Channel%ChanAndOne%, JoinChan := 1, SendMes := 0
Channel%ChanAndOne% := SubStr(TextBox, 7), Channel%ChanAndOne% := (SubStr(Channel%ChanAndOne%, 1, 1) = "#") ? Channel%ChanAndOne% : "#" Channel%ChanAndOne%
Join(Channel%ChanAndOne%)
Return

ContinueChat: 

Gui, 80: Add, Button, y3 xm vonlinetab1 gButton1, %Channel1%
Gui, 80: Add, Button, yp xp+70 vonlinetab2 gButton2 Hidden, 
Gui, 80: Add, Button, yp xp+70 vonlinetab3 gButton3 Hidden, 
Gui, 80: Add, Button, yp xp+70 vonlinetab4 gButton4 Hidden, 
Gui, 80: Add, Button, yp xp+70 vonlinetab5 gButton5 Hidden, 
Gui, 80: Add, Button, yp xp+70 vonlinetab6 gButton6 Hidden, 
Gui, 80: Add, Button, yp xp+70 vonlinetab7 gButton7 Hidden, 
Gui, 80: +LastFound
hwndRich := WinExist()
Chat1 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border ReadOnly")
Chat2 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Chat3 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Chat4 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Chat5 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Chat6 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Chat7 := RichEdit_Add(hwndRich, 10, 27, 680, 440, "MultiLine Border Hidden ReadOnly")
Loop, 7 {
	RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9",,, "All")
	RichEdit_AutoUrlDetect(Chat%A_Index%, True)
}
Gui, 80: Default
GuiControlGet, OnlineTab1, Pos
Gui, 1: Default
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x%OnlineTab1X% y%OnlineTab1Y% h%OnlineTab1H% w%OnlineTab1W% vredbutton1 gbutton1, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 y3 vredbutton2 gbutton2, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 yp vredbutton3 gbutton3, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 yp vredbutton4 gbutton4, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 yp vredbutton5 gbutton5, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 yp vredbutton6 gbutton6, redbutton.ico
Gui, 80: Add, Picture, +AltSubmit +backgroundtrans Hidden x30 yp vredbutton7 gbutton7, redbutton.ico
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers1 hwndhwndListView4, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers2 hwndhwndListView5 Hidden, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers3 hwndhwndListView6 Hidden, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers4 hwndhwndListView7 Hidden, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers5 hwndhwndListView8 Hidden, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers6 hwndhwndListView9 Hidden, % "  Online Users"
Gui, 80: Add, ListView, y27 x700 w140 h440 Sort NoSortHdr gOnlineClick vOnlineUsers7 hwndhwndListView10 Hidden, % "  Online Users"
UserTabCount := 1, CurrentTabList := Channel1, WantNick := NickName
GoSub, Button1
Gui,80: Font, s10, Arial
GuiControl, 80: Font, OnlineUsers
ListView_HeaderFontSet(hwndListView4, "b")
ListView_HeaderFontSet(hwndListView5, "b")
ListView_HeaderFontSet(hwndListView6, "b")
ListView_HeaderFontSet(hwndListView7, "b")
ListView_HeaderFontSet(hwndListView8, "b")
Gui, 80: Show,, LoneIRC - %WantNick%
WinGet, 80PID, PID, LoneIRC - %WantNick%
GuiControl, 80: Disable, Sender
CurrTextLen := RichEdit_GetTextLength(Chat1)
RichEdit_SetText(Chat1, "==  Connecting.", "SELECTION", -1)
RichEdit_SetSel(Chat1, 0, 2)
RichEdit_SetCharFormat(Chat1, "Segoe", "s9", "0xFF0000", "", "Selection")
RichEdit_SetSel(Chat1, -1, -1)
RichEdit_SetCharFormat(Chat1, "Segoe", "s9", "0x000000", "", "Selection")
DOTDOTDOT := 1, DotText := "Connecting"
DOTDOTDOT("1", True)
CONNECT(NickName, NickName, NickName, "", "irc.freenode.net", 6667)
ROMF("Message_Recieved")
JOIN(Channel1)
SetTimer, JOIN, 20000

#If WinActive("ahk_pid " 80PID) and (ControlFocused() = "Edit1")
Esc::
GuiControl, 80: , TextBox
Return
Tab::
If !Matches {
    AutoComplete := ""
	Gui, 80: Default
	Gui, 80: ListView, OnlineUsers%CurrentTabNum%
	IRCCount := LV_GetCount()
	Loop, %IRCCount% {
		LV_GetText(C, A_Index)
		AutoComplete .= C ","
	}
	Gui, 1: Default
    StringTrimRight, AutoComplete, AutoComplete, 1
	Edit_GetSelection(StartPos, EndPos, "A")
	If (StartPos <> EndPos)
        Return
	Gui, 80: Submit, NoHide
	Matches := 0, ThisMatch := 0, RegExMatch(SubStr(TextBox, 1, StartPos), "\w+$", Word), StartPos -= StrLen(Word), Append := InStr(TextBox, A_Space) ? A_Space : ":" A_Space
	Loop, Parse, AutoComplete, CSV
		If (InStr(A_LoopField, Word) = 1) and (Word <> A_LoopField)
			Matches += 1, Match%Matches% := A_LoopField
	If !(Matches)
		Return
}
GoTo, Replace
Return

Replace:
Tabbing := True, ThisMatch := ThisMatch = Matches ? 1 : ThisMatch + 1
Gui, 80: Default
GuiControl, , TextBox, % SubStr(TextBox, 1, StartPos) Match%ThisMatch% Append SubStr(TextBox, EndPos + 1)
Gui 1: Default
Edit_Select(StartPos + StrLen(Match%ThisMatch% Append), StartPos + StrLen(Match%ThisMatch% Append), "A")
Return

CancelTabbing:
If (Tabbing)
    Tabbing--
Else
    Matches = 0
Return

DOTDOTDOT(ID, Power=True)
{
	Global IDC
	If !(Power) {
		If (ID != "") And InStr(IDC, ID){
			IDC := SubStr(IDC,1, InStr(IDC, ID)-1) SubStr(IDC, InStr(IDC, ID)+1)
			SetTimer, DOTDOTDOT, 1000
		}
		Else If (IDC = "")
			SetTimer, DOTDOTDOT, Off
	}
	Else {
		If (ID != "" And !InStr(IDC, ID)) {
			IDC .= " " ID
			If (Trim(IDC) != "")
				SetTimer, DOTDOTDOT, 1000
		}
	}
}
Return

DOTDOTDOT:
DOTDOTDOT := (DOTDOTDOT = 3 || DOTDOTDOT = "") ? 1 : ++ DOTDOTDOT
DotCount := (DOTDOTDOT = 1) ? DotText "." : (DOTDOTDOT = 2) ? DotText ".." : (DOTDOTDOT = 3) ? DotText "..." : ""
PrevDotCount := (DOTDOTDOT = 1) ? DotText "..." : (DOTDOTDOT = 2) ? DotText "." : (DOTDOTDOT = 3) ? DotText ".." : ""
Loop, Parse, IDC, %A_Space%
{	
	RichEdit_SetSel(Chat%A_LoopField%, RichEdit_GetTextLength(Chat%A_LoopField%)-StrLen(PrevDotCount), -1)
	RichEdit_ReplaceSel(Chat%A_LoopField%, DotCount)
	RichEdit_SetSel(Chat%A_LoopField%, RichEdit_GetTextLength(Chat%A_LoopField%)-StrLen(DotCount), -1)
}
PrevDotCount := StrLen(DotCount)
Return

JOIN:
Loop, %ChanCounter%
	JOIN(Channel%A_Index%)
Return
 
SendText:
While (RecMes){
    Sleep 30
}
SendMes := True
Gui, 80: Default
GuiControlGet, TextBox
Gui, 1: Default
If (Trim(TextBox) = ""){
	SendMes := 0
    Return
}
Else If (SubStr(TextBox, 1, 5) = "/join"){
	ChanAndOne := ChanCounter + 1, Channel%ChanAndOne% := (SubStr(TextBox, 7, 1) = "#") ? SubStr(TextBox, 7) : "#" SubStr(TextBox, 7), ChosenUser := Channel%ChanAndOne%
	Join(Channel%ChanAndOne%)
	JoinChan := 1, SendMes := False
	GuiControl, 80: , TextBox
	Return
}
Else If (SubStr(TextBox, 1, 6) = "/whois") Or (SubStr(TextBox, 1, 4) = "/who") Or (SubStr(TextBox, 1, 7) = "/whowas"){
	SendRaw(SubStr(TextBox, 2))
	AwaitQuery := True, SendMes := False, QNum := CurrentTabNum
	GuiControl, 80: , TextBox
	Return
}
Else If (SubStr(TextBox, 1, 5) = "/nick"){
	SendRaw(SubStr(TextBox, 2))
	AwaitQuery := True, SendMes := False, QNum := CurrentTabNum
	GuiControl, 80: , TextBox
	Return
}
Else If (SubStr(TextBox, 1, 3) = "/me"){
	ACTION(Channel%CurrentTabNum%, SubStr(TextBox, 5))
	RichEdit_SetSel(Chat%CurrentTabNum%, -1,-1)
	RichEdit_SetText(Chat%CurrentTabNum%, "  *  " WantNick "  " SubStr(TextBox, 5) "`r`n", "SELECTION", -1)
	SendMes := False
	GuiControl, 80: , TextBox
	Return
}

MSG(Channel%CurrentTabNum%, TextBox)
RichEdit_SetSel(%CurrentUserTab%, -1,-1)
RichEdit_SetText(%CurrentUserTab%, "[" A_Hour ":" A_Min "] <" WantNick "> " TextBox "`r`n", "SELECTION", -1)
ScrollPos := RichEdit_ScrollPos(Chat%CurrentTabNum%)
If (ScrollPos != "0/0")
	RichEdit_ShowScrollBar(Chat%CurrentTabNum%, "V", True)
SendMessage, 0x115, 7, 0,, % "ahk_id " %CurrentUserTab%   ;WM_VSCROLL
GuiControl, 80: , TextBox
SendMes := False
Return
 
GetTextSize(pStr, pSize=8, pFont="", pHeight=false) {
   Gui 9:Font, %pSize%, %pFont%
   Gui 9:Add, Button, , %pStr%
   GuiControlGet T, 9:Pos, Button1
   Gui 9:Destroy
   Return pHeight ? TW "," TH : TW
}
 
ChatDecrypt(Data)
{
	StringSplit, Data, Data, %A_Space%
    i := 4
    Data := "", Data := 
    While i <= Data0
    {   Data .= Data%i% . " "
        i++
    }
    Data := Trim(Data)
    who := SubStr(Data, 2, InStr(Data, "!") - 2)
    Header := SubStr(Data, 1, 1)
    If (Header = ":"){
        Message := SubStr(Data, 2)
        Return Message
    }
    Return 0
}

Message_Recieved(Message)
{
    Global 
	Local Who, AlertingChat
    While (SendMes = 1)
        Sleep 30
    RecMes := True, ChanAndOne := ChanCounter + 1
    If InStr(Message, "`r`n"){
		Loop, PARSE, Message, `n, `r
            Message_Recieved(A_LoopField)
		RecMes := False
        Return
    }
    StringSplit, Message, Message, %A_Space%
    who := SubStr(Message1, 2, InStr(Message1, "!") - 2) 
	If (Message2 = 332)
		v332 := True, HoldTopic := SubStr(Message, InStr(Message, Message5)+1)
	Else If (AwaitQuery) {
		RepeatWho:
		RichEdit_SetSel(Chat%QNum%, -1,-1)
		CurrTextLen := RichEdit_GetTextLength(Chat%QNum%)
		If (Message2 = 311 And !Wait311)
			RichEdit_SetText(Chat%QNum%, "==  " Message4 " [" Message5 "@" Message6 "]`r`n", "SELECTION", -1), Wait311 := True
		Else If (Message2 = 311 And Wait311)
			RichEdit_SetText(Chat%QNum%, "==    RealName : " SubStr(message8, 2) " - " Message10 "`r`n", "SELECTION", -1), Wait311 := ""
		Else If (Message2 = 312)
			RichEdit_SetText(Chat%QNum%, "==    Server        : " Message5 " - [" SubStr(Message, Instr(Message, Message6) + 1) "]`r`n", "SELECTION", -1)
		Else If (Message2 = 314)
			RichEdit_SetText(Chat%QNum%, "==    Account  : " Message4 "`r`n", "SELECTION", -1)
		Else If (Message2 = 318)
			RichEdit_SetText(Chat%QNum%, "==  End of WHOIS`r`n", "SELECTION", -1), AwaitQuery := False 	
		Else If (Message2 = 319)
			RichEdit_SetText(Chat%QNum%, "==    Channels   : " SubStr(Message, Instr(Message, Message5) + 1) "`r`n", "SELECTION", -1)
		Else If (Message2 = 369)
			RichEdit_SetText(Chat%QNum%, "==  End of WHOWAS`r`n", "SELECTION", -1), AwaitQuery := False, Wait369 := ""
		Else If (Message2 = 401)
			RichEdit_SetText(Chat%QNum%, "==  No Such Nick/Channel: " Message4 "`r`n", "SELECTION", -1)
		Else If (Message2 = 406)
			RichEdit_SetText(Chat%QNum%, "==  No Such NickName: " Message4 "`r`n", "SELECTION", -1), Wait369 := True, Message2 := 369
		Else If (Message2 = 433)
			RichEdit_SetText(Chat%QNum%, "==  NickName Is Already In Use: " Message4 "`r`n", "SELECTION", -1)
		Else If (Message2 = "NICK" And SubStr(Message1, 2, Instr(Message1, "!") - 2) = WantNick) {
			WantNick := SubStr(Message3, 2), NickName := WantNick, RichEdit_SetText(Chat%QNum%, "==  " SubStr(Message1, 2, Instr(Message1, "!") - 2) " has changed nick to " WantNick "`r`n", "SELECTION", -1)
			IniWrite, %NickName%, IRC.ini, User, Name
			Gui, 80: Default
			Loop, %UserTabCount% {
				Gui, 80: ListView, OnlineUsers%A_Index%
				NumOfChatters := LV_GetCount(), ChatNum := A_Index
				Loop, %NumOfChatters% {
					LV_GetText(A, A_Index)
					If (A = SubStr(Message1, 2, Instr(Message1, "!") - 2))
						LV_Delete(A_Index), LV_Add("", WantNick)
				}
			}
		}
		RichEdit_SetSel(Chat%QNum%, CurrTextLen, CurrTextLen + 2)
		RichEdit_SetCharFormat(Chat%QNum%, "Segoe", "s9", "0xFF0000", "", "Selection")
		RichEdit_SetSel(Chat%QNum%, -1, -1)
		RichEdit_SetCharFormat(Chat%QNum%, "Segoe", "s9", "0x000000", "", "Selection")
		RichEdit_SetSel(Chat%QNum%, CurrTextLen , -1)
		If (Wait311) or (Wait369)
			GoTo RepeatWho
	}
    Else If(Message1 = "PING")
        gggg=1 ;SENDRAW("PONG " Message2)
    Else If(Message2 = "PING")
        ggggg=2 ;SENDRAW("PONG " Message3)
    Else If ((Message2 = 001) And (WantNick != Message3)) {
		WantNick := Message3, NickName := Message3
		WinSetTitle, LoneIRC,, LoneIRC - %WantNick%
	}
    Else If (Message2 = 433){
		SENDRAW("NICK " Message4 "_")
        NickName := Message4 . "_"
        JOIN(Channel%ChanAndOne%)
    }
	Else If (SubStr(Message, InStr(Message, Message5)) = "Looking up your hostname...")
		ServerStatus := SubStr(Message1,2)
    Else If ((Message2 = "QUIT") And (Message3 = ":Ping") And (Message4 = "timeout:")) {
		GuiControl, 80: Disable, Sender
		CONNECT(NickName, NickName, NickName, "", "irc.freenode.net", 6667)
		Loop, %UserTabCount% {
			GuiControlGet, BT,, OnlineTab%A_Index%
			If InStr(BT, "#"){
				RichEdit_SetSel(Chat%A_Index%, -1,-1)
				CurrTextLen := RichEdit_GetTextLength(Chat%A_Index%)
				RichEdit_SetText(Chat%A_Index%, "==  Re-Connecting.", "SELECTION", -1)
				RichEdit_SetSel(Chat%A_Index%, CurrTextLen, CurrTextLen + 2)
				RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0xFF0000", "", "Selection")
				RichEdit_SetSel(Chat%A_Index%, -1, -1)
				RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0x000000", "", "Selection")
				RichEdit_SetSel(Chat%A_Index%, CurrTextLen , -1)
				DotText := "Re-Connecting"
				DOTDOTDOT(A_Index, True)
				JOIN(Channel%ChanCounter%)
			}
			Gui, 80: ListView, OnlineUsers%A_Index%
			LV_Delete()
		}
    }
    Else If (Message2 = "JOIN"){
		ChosenUser := (SubStr(Message3, 2) = "") ? Channel%CurrentTabNum% : Message3, SelListUser := Message3
		DOTDOTDOT(CurrentTabNum, False)
        If (Who = WantNick) And InStr(ChosenUser, "#"){
			++ ChanCounter
			GoSub, ReceivedClick
			If !InStr(ListChans, ChosenUser) {
				RichEdit_ReplaceSel(Chat%CurrentTabNum%, "Connected To " ChosenUser ":`r`n`r`n")
				ListChans .= ChosenUser
			}
			Else{
				Loop, %UserTabCount%
					RichEdit_ReplaceSel(Chat%A_Index%, "Re-Connected!`r`n`r`n")
			}
		}
		GuiControl, 80: Enable, Sender
		Gui, 80: Default
		Loop, %UserTabCount% {
			GuiControlGet, ControlAH, , OnlineTab%A_Index%
			If (ControlAH = ChosenUser) And (Who != WantNick){
				Gui, 80: ListView, OnlineUsers%A_Index%
				LV_Add("", Who)
				LV_ModifyCol(1, "AutoHdr")
				RichEdit_SetSel(Chat%A_Index%, -1,-1)
				CurrTextLen := RichEdit_GetTextLength(Chat%A_Index%)
				RichEdit_SetText(Chat%A_Index%, "==  " Who " [" SubStr(Message1, Instr(Message1, "!")+1) "] has joined!`r`n", "SELECTION", -1)
				RichEdit_SetSel(Chat%A_Index%, CurrTextLen, CurrTextLen + 2)
				RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0xFF0000", "", "Selection")
				RichEdit_SetSel(Chat%A_Index%, -1, -1)
				RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0x000000", "", "Selection")
			}
		} 
		Gui, 1: Default
    }
    Else If (Message2 = 353) Or (CollectingData) {
		If (Message2 = 366) {
			DirMsg := 0, CollectingData := False
			If (Trim(Users) = "")
				RichEdit_SetText(Chat%CurrentTabNum%, "==  " WantNick ", You're all alone!`r`n", "SELECTION", -1)
			Else {
				Gui, 80: Default
				Loop, %ChanCounter% {
					GuiControlGet, ControlAH, , OnlineTab%A_Index%
					If (ControlAH = ChosenUser){
						Gui, 80: ListView, OnlineUsers%A_Index%
						FoundTab := True, T%A_Index% := (v332) ? HoldTopic : "No Topic Set"
						If (CurrentTabNum = A_Index)
							WinSetTitle, LoneIRC,, % "LoneIRC - " WantNick " [" T%A_Index% "]"
						break
					}
					Else If (ControlAH = SubStr(ChosenUser, 2)){
						Gui, 80: ListView, OnlineUsers%A_Index%
						FoundTab := True, T%A_Index% := (v332) ? HoldTopic : "No Topic Set"
						If (CurrentTabNum = A_Index)
							WinSetTitle, LoneIRC,, % "LoneIRC - " WantNick " [" T%A_Index% "]"
						break
					}
				} 
				If (FoundTab) {
					Loop, Parse, Users, %A_Space%
					{	If (A_LoopField != "") And (A_LoopField != SubStr(NickName, 2)){
							LV_Add("", A_LoopField)
							LV_ModifyCol(1, "AutoHdr")
							FoundTab := False, Users := ""
						}
					}
				}
				Gui, 1: Default
			}
		}
		Else {
			CollectingData := True, Users .= (Users = "") ? SubStr(Message, InStr(Message, Message6)+1) : " " SubStr(Message, InStr(Message, Message6)+1)
		}
	}
	Else If (Message2 = 328){
		RecMes := 0
		Return
	}
    Else If (Message2 = "PART" || Message2 = "QUIT"){ 
        If (Who = NickName){				
			Loop, %UserTabCount% {
				GuiControlGet, BT,, OnlineTab%A_Index%
				If InStr(BT, "#") {
					RichEdit_SetSel(Chat%A_Index%, -1,-1)
					CurrTextLen := RichEdit_GetTextLength(Chat%A_Index%)
					RichEdit_SetText(Chat%A_Index%, "==  You have left!`r`n`r`n", "SELECTION", -1)
					RichEdit_SetSel(Chat%A_Index%, CurrTextLen, CurrTextLen + 2)
					RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0xFF0000", "", "Selection")
					RichEdit_SetSel(Chat%A_Index%, -1, -1)
					RichEdit_SetCharFormat(Chat%A_Index%, "Segoe", "s9", "0x000000", "", "Selection")
				}
			}
		}
        Else {
			Gui, 80: Default
			Loop, %UserTabCount% {
				Gui, 80: ListView, OnlineUsers%A_Index%
				NumOfChatters := LV_GetCount(), ChatNum := A_Index
				Loop, %NumOfChatters% {
					LV_GetText(A, A_Index)
					If (A = Who)
						LV_Delete(A_Index)
				}
				RichEdit_SetSel(Chat%ChatNum%, -1,-1)
				CurrTextLen := RichEdit_GetTextLength(Chat%ChatNum%)
				RichEdit_SetText(Chat%ChatNum%, "==  " Who " [" SubStr(Message1, Instr(Message1, "!")+1) "] has left!`r`n", "SELECTION", -1)
				RichEdit_SetSel(Chat%ChatNum%, CurrTextLen, CurrTextLen + 2)
				RichEdit_SetCharFormat(Chat%ChatNum%, "Segoe", "s9", "0xFF0000", "", "Selection")
				RichEdit_SetSel(Chat%ChatNum%, -1, -1)
				RichEdit_SetCharFormat(Chat%ChatNum%, "Segoe", "s9", "0x000000", "", "Selection")
			}
			Gui, 1: Default				
		}
    }
	Else If (Message2 = "NICK") {
		Gui, 80: Default
		Loop, %UserTabCount% {
			Gui, 80: ListView, OnlineUsers%A_Index%
			NumOfChatters := LV_GetCount(), ChatNum := A_Index
			Loop, %NumOfChatters% {
				LV_GetText(A, A_Index)
				If (A = Who) {
					LV_Delete(A_Index)
					LV_Add("", SubStr(Message3, 2))
					FoundNick := True
					RichEdit_SetSel(Chat%ChatNum%, -1,-1)
					CurrTextLen := RichEdit_GetTextLength(Chat%ChatNum%)
					RichEdit_SetSel(Chat%ChatNum%, -1,-1)
					CurrTextLen := RichEdit_GetTextLength(Chat%ChatNum%)
					RichEdit_SetText(Chat%ChatNum%, "==  " Who " has changed nick to " SubStr(Message3, 2) "`r`n", "SELECTION", -1)
					RichEdit_SetSel(Chat%ChatNum%, CurrTextLen, CurrTextLen + 2)
					RichEdit_SetCharFormat(Chat%ChatNum%, "Segoe", "s9", "0xFF0000", "", "Selection")
					RichEdit_SetSel(Chat%ChatNum%, -1, -1)
					RichEdit_SetCharFormat(Chat%ChatNum%, "Segoe", "s9", "0x000000", "", "Selection")
					Break
				}
			}
		}
		Gui, 1: Default
	}
	Else If (SubStr(Message1,2) = ServerStatus Or Who = "NickServ" Or Who = "ChanServ" Or SubStr(Message1, 1, 1) != ":" Or Message2 = "MODE" Or InStr(ServerStatus, SubStr(Message1,2))) {
		RecMes := False
		return
	}
	Else {
		Message := ChatDecrypt(Message)
		Gui, 80: Default
		Loop, %UserTabCount% {
			GuiControlGet, ControlAH, , OnlineTab%A_Index%
			If (ControlAH = Message3){
				MsgBox found
				DirNum := A_Index
				If !InStr(ListChans, Message3)
					DirMsg := True
				break
			}
			Else {
				SelListUser := Who, ChosenUser := Who, AlertingChat := 1
				GoSub, ReceivedClick
				DirNum := UserTabCount, T%CurrentTabNum% := "Private Chat With " Who
				WinSetTitle, LoneIRC,, % "LoneIRC - " WantNick " [" T%CurrentTabNum% "]"
			}
		}
		Gui, 1: Default
		If (Message != 0 And !InStr(Message, ServerStatus)) {
			If InStr(Message, WantNick) OR (DirMsg) {   
				If (DirMsg And DirNum = ""){
					ChosenUser := Who, AlertingChat := 1
					GoSub, ReceivedClick
					DirNum := UserTabCount
				}
				SoundBeep
				RichEdit_SetSel(Chat%DirNum%, -1,-1)
				RichEdit_SetText(Chat%DirNum%, "[" A_Hour ":" A_Min "] <" Who , "SELECTION", -1)
				TxtLenATM := RichEdit_GetTextLength(Chat%DirNum%)
				NameLength := StrLen(Who)
				RichEdit_SetSel(Chat%DirNum%, TxtLenATM - NameLength, TxtLenATM)
				RichEdit_SetCharFormat(Chat%DirNum%, "Segoe", "s9", "0xFF0000", "", "Selection")
				RichEdit_SetSel(Chat%DirNum%, TxtLenATM, TxtLenATM)
				RichEdit_SetCharFormat(Chat%DirNum%, "Segoe", "s9", "0x000000", "", "Selection")
				RichEdit_SetText(Chat%DirNum%, "> " Message "`r`n", "SELECTION", -1)
				If (CurrentTabNum != DirNum) {
					If (DirMsg) {
						Gui, 80: Default
						GuiControlGet, OnlineTab%DirNum%, Pos
						Gui, 1: Default
						GuiControl, 80: Move, redbutton%DirNum%, % "x" OnlineTab%DirNum%X " y" OnlineTab%DirNum%Y " h" OnlineTab%DirNum%H " w" OnlineTab%DirNum%W
					}
					SetTimer, blinker%DirNum%, 50
				}
			}
			Else{
				RichEdit_SetSel(Chat%CurrentTabNum%, -1,-1)
				If (SubStr(Message, 1, InStr(Message, A_Space) -1) = Chr(1) "ACTION")
					RichEdit_SetText(Chat%CurrentTabNum%, "  *  " Who "  " SubStr(Message, Instr(Message, A_Space)+1, Instr(Message, Chr(1), False, 1, 2)-Instr(Message, A_Space)-1) "`r`n", "SELECTION", -1)
				Else
					RichEdit_SetText(Chat%CurrentTabNum%, "[" A_Hour ":" A_Min "] <" Who "> " Message "`r`n", "SELECTION", -1)
			}
		}
		SendMessage, 0x115, 7, 0,, % "ahk_id " Chat%DirNum%
		ScrollPos := RichEdit_ScrollPos(Chat%DirNum%)
		If (ScrollPos != "0/0")
			RichEdit_ShowScrollBar(Chat%DirNum%, "V", True)
	}
	RecMes := False
}

onlineclick:
CurrentUserNum := A_EventInfo, PrevUserNum := A_EventInfo - 1
Gui, 80: ListView, OnlineUsers
LV_GetText(SelListUser, A_EventInfo)
ReceivedClick:
Loop, Parse, CurrentTabList, `,
{	If (A_LoopField = SelListUser)
		Return
}
CurrentTabList .= "," SelListUser, PreceedingTab := UserTabCount, ++ UserTabCount
GuiControl, 80: Text, OnlineTab%UserTabCount%, %SelListUser%
ButtonWide%UserTabCount% := GetTextSize(SelListUser, 12, "Arial")
Gui, 80: Default
Loop, 6 
    GuiControlGet, OnlineTab%A_Index%, Pos
Gui, 1: Default
GuiControl, 80: Move, OnlineTab%UserTabCount%, % "w" ButtonWide%UserTabCount% " x"OnlineTab%PreceedingTab%X  + OnlineTab%PreceedingTab%W + 3
GuiControl, 80: Show, OnlineTab%UserTabCount%
If !(AlertingChat)
    GoSub, Button%UserTabCount%
If !InStr(ChosenUser, "#") {
	RichEdit_SetSel(Chat%UserTabCount%, -1,-1)
	RichEdit_SetText(Chat%UserTabCount% , "Private Chat With " SelListUser ":`r`n`r`n", "SELECTION", -1)
	T%UserTabCount% := "Private Chat With " Who 
	WinSetTitle, LoneIRC,, % "LoneIRC - " WantNick " [" T%CurrentTabNum% "]"
}
Return 
 
button1:
button2:
button3:
button4:
button5:
button6:
button7:
CurrentTabNum := SubStr(A_ThisLabel, 0)
WinSetTitle, LoneIRC,, % "LoneIRC - " WantNick " [" T%CurrentTabNum% "]"
If (CurrentTabNum != PrevTabNum){
	Control, Hide,,, % "ahk_id " %CurrentUserTab%
	GuiControl, 80: Hide, OnlineUsers%PrevTabNum%
	CurrentUserTab := "Chat" CurrentTabNum, AssociatedButton := "OnlineTab" CurrentTabNum
	Control, Show,,, % "ahk_id " %CurrentUserTab%
	GuiControl, 80: Show, OnlineUsers%CurrentTabNum%
	SetTimer, Blinker%CurrentTabNum%, Off
	Gui, 80: Default
	GuiControlGet, Addressing,, %AssociatedButton%
	Gui, 1: Default
	GuiControl, 80: Focus, TextBox
	PrevTabNum := CurrentTabNum
}
Return

CloseConvo:
Gui, 80: Default
GuiControlGet, ButtonToDelete,, %AssociatedButton%
Gui, 1: Default
If (ButtonToDelete = "")
    Return
If InStr(CurrentTabList, ButtonToDelete) {
	GuiControl, 80: Hide, %AssociatedButton%
    ChatTabRotation := UserTabCount - CurrentTabNum, OtherIndex := CurrentTabNum, OtherNum := CurrentTabNum + 1, MinNum := CurrentTabNum - 1
	Gui, 80: Default
	Part(Channel%CurrentTabNum%, "Leaving Channel")
    Loop, %ChatTabRotation% {
        GuiControlGet, OnlineTab%OtherIndex%, Pos
		If (CurrentTabNum = 1 And OtherNum = 2)
			GuiControl, 80: Move, OnlineTab%OtherNum%, x10
		Else If (OtherNum = CurrentTabNum + 1)
			GuiControl, 80: Move, OnlineTab%OtherNum%, % "x"OnlineTab%MinNum%X + OnlineTab%MinNum%W + 3
		Else
			GuiControl, 80: Move, OnlineTab%OtherNum%, % "x"OnlineTab%OtherIndex%X + OnlineTab%OtherIndex%W + 3
		Channel%OtherIndex% := Channel%OtherNum%, ++ OtherNum, ++OtherIndex
    }
	Gui, 1: Default
    StringReplace, CurrentTabList, CurrentTabList, %ButtonToDelete%
    --UserTabCount, -- ChanCounter
	RichEdit_SetText(%CurrentUserTab%, "", "DEFAULT")
	If IsLabel("Button" CurrentTabNum - 1)
		Gosub % "Button" CurrentTabNum - 1
	Else If IsLabel("Button" CurrentTabNum + 1)
		Gosub % "Button" CurrentTabNum + 1
}
Return

OMF(Socket, Data)
{
    ListLines, Off
    global OMF
    StringTrimRight, Data, Data, 2
    %OMF%(Data)
    ListLines, On
}
ROMF(Function)
{
    ListLines, Off
    global OMF
    OMF := Function
    ListLines, On
}
CONNECT(Nick, User, Name, Pass, Server, Port, Mode="8")
{
    ListLines, Off
    global Socket
	Socket := WS2_Connect(Server . ":" . Port)
    If (!Socket OR Socket = -1)
		MsgBox, 16, %A_ScriptName% - ERROR, There was an error while connecting to %Server%:%Port%!
    WS2_AsyncSelect(Socket, "OMF")
    Result := "NICK " . Nick . "`r`n"
	DllCall("Ws2_32\send","UInt",Socket,"AStr",Result,"Int",StrLen(Result),"Int",0)
    Result := "USER " . User . " " . Mode . " * :" . Name . "`r`n"
	DllCall("Ws2_32\send","UInt",Socket,"AStr",Result,"Int",StrLen(Result),"Int",0)
    WS2_SendData(Socket, "PASS " . Pass . "`r`n")
    ListLines, On
}
ID(Nick, User, Name, Pass, Mode="8")
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "NICK " . Nick . "`r`n")
    WS2_SendData(Socket, "USER " . User . " " . Mode . " * :" . Name . "`r`n")
    WS2_SendData(Socket, "PASS " . Pass . "`r`n")
    ListLines, On
}
JOIN(Channel)
{
	global
    ListLines, Off
	Channel := (SubStr(Channel, 1, 1) = "#") ? Channel : "#" Channel
	WS2_SendData(Socket, "JOIN " . Channel . "`r`n")
    ListLines, On
}
MSG(Name, Message)
{
    ListLines, Off
    global Socket, Addressing
    WS2_SendData(Socket, "PRIVMSG " . Name . " :" . Message . "`r`n")
    ListLines, On
}
QUERY(Name, Message)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "QUERY " . Name . " :" . Message . "`r`n")
    ListLines, On
}
SENDRAW(rawIRC)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, rawIRC . "`r`n")
    ListLines, On
}
ACTION(Name, Action)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "PRIVMSG " . Name . " :" . Chr(1) . "ACTION " . Action . Chr(1) . "`r`n")
    ListLines, On
}
PART(Channel, Reason="")
{
    ListLines, Off
	global Socket
    WS2_SendData(Socket, "PART " . Channel . ((Reason != "") ? " :" . Reason : "") . "`r`n")
    ListLines, On
}
QUIT(Reason="")
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "QUIT`r`n")
    WS2_CleanUp()
    ListLines, On
}
MODE(Name, Mode, Parameters)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "MODE " . Name . " " . Mode . " " . Parameters . "`r`n")
    ListLines, On
}
KICK(Name, Channel, Reason="")
{
    ListLines, Off
    global Socket
    If (Reason != "")
        WS2_SendData(Socket, "KICK " . Channel . " " . Name . " :" . Reason . "`r`n")
    Else
        WS2_SendData(Socket, "KICK " . Channel . " " . Name . "`r`n")
    ListLines, On
}
INVITE(Channel, Person)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "INVITE " . Channel . " " . Person . "`r`n")
    ListLines, On
}
OP(Channel, Person, DeOp=false)
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "MODE " . Channel . " " . ((DeOp=false) ? "+" : "-") . "o " . Person . "`r`n")
    ListLines, On
}
BAN(Channel, Person, UnBan=false, KickBan=false, Reason="")
{
    ListLines, Off
    global Socket
    WS2_SendData(Socket, "MODE " . Channel . " " . ((UnBan=false) ? "+" : "-") . "b " . Person . "`r`n")
    If (KickBan = true)
        KICK(Channel, Person, Reason)
    ListLines, On
}
 
80GuiClose:
ExitSub:
OnExit
Loop, %UserTabCount%
	Part(Channel%A_Index%, "Quitting")
QUIT()
ExitApp

blinker1:
blinker2:
blinker3:
blinker4:
blinker5:
blinker6:
blinker7:
GuiControl, 80: Hide, % "redbutton" SubStr(A_ThisLabel, 0)
sleep 700
GuiControl, 80: Show, % "redbutton" SubStr(A_ThisLabel, 0)
sleep 670
return

AddGraphicButton(VariableName, ImgPath, Options="", bHeight=32, bWidth=32) 
{ 
Global 
Local ImgType, ImgType1, ImgPath0, ImgPath1, ImgPath2, hwndmode 
; BS_BITMAP := 128, IMAGE_BITMAP := 0, BS_ICON := 64, IMAGE_ICON := 1 
Static LR_LOADFROMFILE := 16 
Static BM_SETIMAGE := 247 
Static NULL 
SplitPath, ImgPath,,, ImgType1 
If ImgPath is float 
{ 
  ImgType1 := (SubStr(ImgPath, 1, 1)  = "0") ? "bmp" : "ico" 
  StringSplit, ImgPath, ImgPath,`. 
  %VariableName%_img := ImgPath2 
  hwndmode := true 
} 
ImgTYpe := (ImgType1 = "bmp") ? 128 : 64 
If (%VariableName%_img != "") AND !(hwndmode) 
  DllCall("DeleteObject", "UInt", %VariableName%_img) 
If (%VariableName%_hwnd = "") 
  Gui, 80: Add, Button,  v%VariableName% hwnd%VariableName%_hwnd +%ImgTYpe% %Options% 
ImgType := (ImgType1 = "bmp") ? 0 : 1 
If !(hwndmode) 
  %VariableName%_img := DllCall("LoadImage", "UInt", NULL, "Str", ImgPath, "UInt", ImgType, "Int", bWidth, "Int", bHeight, "UInt", LR_LOADFROMFILE, "UInt") 
DllCall("SendMessage", "UInt", %VariableName%_hwnd, "UInt", BM_SETIMAGE, "UInt", ImgType,  "UInt", %VariableName%_img) 
Return, %VariableName%_img ; Return the handle to the image 
}

;//******************* Functions *******************
;//Sun, Jul 13, 2008 --- 7/13/08, 7:19:19pm
;//Function: ListView_HeaderFontSet
;//Params...
;//		p_hwndlv    = ListView hwnd
;//		p_fontstyle = [b[old]] [i[talic]] [u[nderline]] [s[trike]]
;//		p_fontname  = <any single valid font name = Arial, Tahoma, Trebuchet MS>
ListView_HeaderFontSet(p_hwndlv="", p_fontstyle="", p_fontname="") {
	static hFont1stBkp
	method:="CreateFont"
	;//method="CreateFontIndirect"
	WM_SETFONT:=0x0030
	WM_GETFONT:=0x0031

	LVM_FIRST:=0x1000
	LVM_GETHEADER:=LVM_FIRST+31

	;// /* Font Weights */
	FW_DONTCARE:=0
	FW_THIN:=100
	FW_EXTRALIGHT:=200
	FW_LIGHT:=300
	FW_NORMAL:=400
	FW_MEDIUM:=500
	FW_SEMIBOLD:=600
	FW_BOLD:=700
	FW_EXTRABOLD:=800
	FW_HEAVY:=900

	FW_ULTRALIGHT:=FW_EXTRALIGHT
	FW_REGULAR:=FW_NORMAL
	FW_DEMIBOLD:=FW_SEMIBOLD
	FW_ULTRABOLD:=FW_EXTRABOLD
	FW_BLACK:=FW_HEAVY
	/*
	parse p_fontstyle for...
		cBlue	color	*** Note *** OMG can't set ListView/SysHeader32 font/text color??? ***
		s19		size
		b		bold
		w500	weight?
	*/
	;//*** Note *** yes I will allow mixed types later!...this was quick n dirty...
	;//*** Note *** ...it now supports bold italic underline & strike-thru...all at once
	style:=p_fontstyle
	;//*** Note *** change RegExReplace to RegExMatch
	style:=RegExReplace(style, "i)\s*\b(?:I|U|S)*B(?:old)?(?:I|U|S)*\b\s*", "", style_bold)
	style:=RegExReplace(style, "i)\s*\b(?:B|U|S)*I(?:talic)?(?:B|U|S)*\b\s*", "", style_italic)
	style:=RegExReplace(style, "i)\s*\b(?:B|I|S)*U(?:nderline)?(?:B|I|S)*\b\s*", "", style_underline)
	style:=RegExReplace(style, "i)\s*\b(?:B|I|U)*S(?:trike)?(?:B|I|U)*\b\s*", "", style_strike)
	;//style:=RegExReplace(style, "i)\s*\bW(?:eight)(\d+)\b\s*", "", style_weight)
	if (style_bold)
		fnWeight:=FW_BOLD
	if (style_italic)
		fdwItalic:=1
	if (style_underline)
		fdwUnderline:=1
	if (style_strike)
		fdwStrikeOut:=1
	;//if (mweight)
	;//	fnWeight:=mweight
	lpszFace:=p_fontname

	ret:=hHeader:=SendMessage(p_hwndlv, LVM_GETHEADER, 0, 0)
	el:=Errorlevel
	le:=A_LastError
	;//msgbox, 64, , SendMessage LVM_GETHEADER: ret(%ret%) el(%el%) le(%le%)

	ret:=hFontCurr:=SendMessage(hHeader, WM_GETFONT, 0, 0)
	el:=Errorlevel
	le:=A_LastError
	;//msgbox, 64, , SendMessage WM_GETFONT: ret(%ret%) el(%el%) le(%le%)
	if (!hFont1stBkp) {
		hFont1stBkp:=hFontCurr
	}

	if (method="CreateFont") {
		if (p_fontstyle!="" || p_fontname!="") {
			ret:=hFontHeader:=CreateFont(nHeight, nWidth, nEscapement, nOrientation
										, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut
										, fdwCharSet, fdwOutputPrecision, fdwClipPrecision
										, fdwQuality, fdwPitchAndFamily, lpszFace)
			el:=Errorlevel
			le:=A_LastError
			;//msgbox, 64, , CreateFont: ret(%ret%) el(%el%) le(%le%)
		} else hFontHeader:=hFont1stBkp
		ret:=SendMessage(hHeader, WM_SETFONT, hFontHeader, 1)
		;//ret:=SendMessage(hHeader, WM_SETFONT, hFontHeader, 0)
		;//ret:=SendMessage(hHeader, WM_SETFONT, &0, 1)
		el:=Errorlevel
		le:=A_LastError
		;//msgbox, 64, , SendMessage WM_SETFONT: ret(%ret%) el(%el%) le(%le%)
	}
}

/*
HFONT CreateFont(
  int nHeight,               // height of font
  int nWidth,                // average character width
  int nEscapement,           // angle of escapement
  int nOrientation,          // base-line orientation angle
  int fnWeight,              // font weight
  DWORD fdwItalic,           // italic attribute option
  DWORD fdwUnderline,        // underline attribute option
  DWORD fdwStrikeOut,        // strikeout attribute option
  DWORD fdwCharSet,          // character set identifier
  DWORD fdwOutputPrecision,  // output precision
  DWORD fdwClipPrecision,    // clipping precision
  DWORD fdwQuality,          // output quality
  DWORD fdwPitchAndFamily,   // pitch and family
  LPCTSTR lpszFace           // typeface name
);
*/
CreateFont(               nHeight                   , nWidth                  , nEscapement
						, nOrientation              , fnWeight                , fdwItalic
						, fdwUnderline              , fdwStrikeOut            , fdwCharSet
						, fdwOutputPrecision        , fdwClipPrecision        , fdwQuality
						, fdwPitchAndFamily         , lpszFace) {
	return DllCall("CreateFont"
				, "Int" , nHeight           , "Int" , nWidth          , "Int" , nEscapement
				, "Int" , nOrientation      , "Int" , fnWeight        , "UInt", fdwItalic
				, "UInt", fdwUnderline      , "UInt", fdwStrikeOut    , "UInt", fdwCharSet
				, "UInt", fdwOutputPrecision, "UInt", fdwClipPrecision, "UInt", fdwQuality
				, "UInt", fdwPitchAndFamily , "Str" , lpszFace)
}

SendMessage(p_hwnd, p_msg, p_wParam="", p_lParam="") {
	return DllCall("SendMessage", "UInt", p_hwnd, "UInt", p_msg, "UInt", p_wParam, "UInt", p_lParam)
}

;//           Msg [, wParam     , lParam     , Control  , WinTitle  , WinText  , ExcludeTitle     , ExcludeText
A_SendMessage(p_msg, p_wParam="", p_lParam="", p_ctrl="", p_title="", p_text="", p_excludetitle="", p_excludetext="") {
	SendMessage, p_msg, p_wParam, p_lParam, %p_ctrl%, %p_title%, %p_text%, %p_excludetitle%, %p_excludetext%
	return errorlevel
}
;//******************* /Functions *******************

ControlFocused()
{
    ControlGetFocus, Control, A
    Return Control
}
 
 
;************************
; Edit Control Functions
;************************
;
; http://www.autohotkey.com/forum/topic22748.html
;
; Standard parameters:
;   Control, WinTitle   If WinTitle is not specified, 'Control' may be the
;                       unique ID (hwnd) of the control.  If "A" is specified
;                       in Control, the control with input focus is used.
;
; Standard/default return value:
;   true on success, otherwise false.
 
 
Edit_Standard_Params(ByRef Control, ByRef WinTitle) {  ; Helper function.
    if (Control="A" && WinTitle="") { ; Control is "A", use focused control.
        ControlGetFocus, Control, A
        WinTitle = A
    } else if (Control+0!="" && WinTitle="") {  ; Control is numeric, assume its a ahk_id.
        WinTitle := "ahk_id " . Control
        Control =
    }
}
 
; Returns true if text is selected, otherwise false.
;
Edit_TextIsSelected(Control="", WinTitle="")
{
    Edit_Standard_Params(Control, WinTitle)
    return Edit_GetSelection(start, end, Control, WinTitle) and (start!=end)
}
 
; Gets the start and end offset of the current selection.
;
Edit_GetSelection(ByRef start, ByRef end, Control="", WinTitle="")
{
    Edit_Standard_Params(Control, WinTitle)
    VarSetCapacity(start, 4), VarSetCapacity(end, 4)
    SendMessage, 0xB0, &start, &end, %Control%, %WinTitle%  ; EM_GETSEL
    if (ErrorLevel="FAIL")
        return false
    start := NumGet(start), end := NumGet(end)
    return true
}
 
; Selects text in a text box, given absolute character positions (starting at 0.)
;
; start:    Starting character offset, or -1 to deselect.
; end:      Ending character offset, or -1 for "end of text."
;
Edit_Select(start=0, end=-1, Control="", WinTitle="")
{
    Edit_Standard_Params(Control, WinTitle)
    SendMessage, 0xB1, start, end, %Control%, %WinTitle%  ; EM_SETSEL
    return (ErrorLevel != "FAIL")
}
 
; Selects a line of text.
;
; line:             One-based line number, or 0 to select the current line.
; include_newline:  Whether to also select the line terminator (`r`n).
;
Edit_SelectLine(line=0, include_newline=false, Control="", WinTitle="")
{
    Edit_Standard_Params(Control, WinTitle)
   
    ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%
    if (!WinExist("ahk_id " hwnd))
        return false
   
    if (line<1)
        ControlGet, line, CurrentLine
   
    SendMessage, 0xBB, line-1, 0  ; EM_LINEINDEX
    offset := ErrorLevel
 
    SendMessage, 0xC1, offset, 0  ; EM_LINELENGTH
    lineLen := ErrorLevel
 
    if (include_newline) {
        WinGetClass, class
        lineLen += (class="Edit") ? 2 : 1 ; `r`n : `n
    }
   
    ; Select the line.
    SendMessage, 0xB1, offset, offset+lineLen  ; EM_SETSEL
    return (ErrorLevel != "FAIL")
}
 
; Deletes a line of text.
;
; line:     One-based line number, or 0 to delete current line.
;
Edit_DeleteLine(line=0, Control="", WinTitle="")
{
    Edit_Standard_Params(Control, WinTitle)
    ; Select the line.
    if (Edit_SelectLine(line, true, Control, WinTitle))
    {   ; Delete it.
        ControlSend, %Control%, {Delete}, %WinTitle%
        return true
    }
    return false
}

/* Title:		RichEdit

				This module allows you to create and programmatically set text properties in rich edit control.
				Besides that, it contains functions that work with standard edit controls. Each function contains
				description for which kind of control it can be used - any control supporting edit control interface
				(Edit, RichEdit, HiEdit...) or just rich edit control.
 */

RichEdit_Add(HParent, X="", Y="", W="", H="", Style="", Text="")  {
  static WS_CLIPCHILDREN=0x2000000, WS_VISIBLE=0x10000000, WS_CHILD=0x40000000
		,ES_DISABLENOSCROLL=0x2000, EX_BORDER=0x200
		,ES_LEFT=0, ES_CENTER=1, ES_RIGHT=2, ES_MULTILINE=4, ES_AUTOVSCROLL=0x40, ES_AUTOHSCROLL=0x80, ES_NOHIDESEL=0x100, ES_NUMBER=0x2000, ES_PASSWORD=0x20,ES_READONLY=0x800,ES_WANTRETURN=0x1000  ;, ES_SELECTIONBAR = 0x1000000
		,ES_HSCROLL=0x100000, ES_VSCROLL=0x200000, ES_SCROLL=0x300000
		,MODULEID

	if !MODULEID
		init := DllCall("LoadLibrary", "Str", "Msftedit.dll", "Uint"), MODULEID := 091009


	ifEqual, Style,, SetEnv, Style, MULTILINE WANTRETURN VSCROLL
	hStyle := InStr(" " Style " ", " hidden ") ? 0 : WS_VISIBLE,  hExStyle := 0
	Loop, parse, Style, %A_Tab%%A_Space%
	{
		IfEqual, A_LoopField, ,continue
		else if A_LoopField is integer
			 hStyle |= A_LoopField
		else if (v := ES_%A_LOOPFIELD%)
			 hStyle |= v
		else if (v := EX_%A_LOOPFIELD%)
			 hExStyle |= v
		else if (A_LoopField = "SELECTIONBAR")
       selectionbar := true
		else continue
	}

	hCtrl := DllCall("CreateWindowEx"
                  , "Uint", hExStyle			; ExStyle
                  , "str" , "RICHEDIT50W"		; ClassName
                  , "str" , Text				; WindowName
                  , "Uint", WS_CHILD | hStyle	; Edit Style
                  , "int" , X					; Left
                  , "int" , Y					; Top
                  , "int" , W					; Width
                  , "int" , H					; Height
                  , "Uint", HParent				; hWndParent
                  , "Uint", MODULEID			; hMenu
                  , "Uint", 0					; hInstance
                  , "Uint", 0, "Uint")			; must return uint.
	return hCtrl,  selectionbar ? RichEdit_SetOptions( hCtrl, "OR", "SELECTIONBAR" ) : ""
}

RichEdit_AutoUrlDetect(HCtrl, Flag="" )  {	;wParam Specify TRUE to enable automatic URL detection or FALSE to disable it.
	static EM_AUTOURLDETECT=0x45B, EM_GETAUTOURLDETECT=0x45C

	If (Flag = "") || (Flag ="^") {
		SendMessage, EM_GETAUTOURLDETECT,,,,ahk_id %HCtrl%
		ifEqual, Flag,, return ERRORLEVEL
		Flag := !ERRORLEVEL
	}
	SendMessage, EM_AUTOURLDETECT, Flag,,, ahk_id %HCtrl%
	return Flag
}

RichEdit_CanPaste(hEdit, ClipboardFormat=0x1) {
    Static EM_CANPASTE := 1074
    SendMessage EM_CANPASTE,ClipboardFormat,0,,ahk_id %hEdit%
    return ErrorLevel
}

RichEdit_CharFromPos(hEdit,X,Y) {
    Static EM_CHARFROMPOS:=0xD7

	WinGetClass, cls, ahk_id %hEdit%
	if cls in RICHEDIT50W
		 VarSetCapacity(POINTL, 8), lParam := &POINTL, NumPut(X, POINTL), NumPut(Y,POINTL)
	else lParam := (Y<<16)|X

    SendMessage EM_CHARFROMPOS,,lParam,,ahk_id %hEdit%
    return ErrorLevel
}


RichEdit_Clear(hEdit) {
    static WM_CLEAR:=0x303
    SendMessage 0x0303,,,,ahk_id %hEdit%
}


RichEdit_Convert(Input, Direction=0) {
	static twipsPerInch = 1440, LOGPIXELSX=88, LOGPIXELSY=90, tpi0, tpi1

	if !tpi0
		dc := DllCall("GetDC", "uint", 0, "Uint")
		, tpi0 := DllCall("gdi32.dll\GetDeviceCaps", "uint", dc, "int", LOGPIXELSX)
		, tpi1 := DllCall("gdi32.dll\GetDeviceCaps", "uint", dc, "int", LOGPIXELSY)
		, DllCall("ReleaseDC", "uint", 0, "uint", dc)

   return (Input>0) ? (Input * tpi%Direction%) // twipsPerInch  : (-Input*twipsPerInch) // tpi%Direction%
}

RichEdit_FindText(hEdit, Text, CpMin=0, CpMax=-1, Flags="UNICODE") {
	static EM_FINDTEXT=1080, FR_DOWN=1, FR_WHOLEWORD=2, FR_MATCHCASE=4, FR_UNICODE=0
	hFlags := 0
	loop, parse, Flags, %A_Tab%%A_Space%,
		ifEqual, A_LoopField,,continue
		else hFlags |= FR_%A_LOOPFIELD%

	If InStr(Flags, "Unicode") {
		VarSetCapacity( uText, (len:=StrLen(Text))*2+1), DllCall( "MultiByteToWideChar", "Int",0,"Int",0,"Str",Text,"UInt",len,"Str", uText, "UInt", len )
		txtAdr := &uText
	} else txtAdr := &Text

	VarSetCapacity(FT, 12)
	NumPut(CpMin,   FT, 0)
	NumPut(CpMax,   FT, 4)
	NumPut(txtAdr,  FT, 8)

	SendMessage, EM_FINDTEXT, hFlags, &FT,, ahk_id %hEdit%
	Return ErrorLevel=4294967295 ? -1 : ErrorLevel
}

RichEdit_FindWordBreak(hCtrl, CharIndex, Flag="")  {
	static  EM_FINDWORDBREAK=1100
			, WB_CLASSIFY=3, WB_ISDELIMITER=2, WB_LEFT=0, WB_LEFTBREAK=6, WB_MOVEWORDLEFT=4, WB_MOVEWORDNEXT=5, WB_MOVEWORDPREV=4, WB_MOVEWORDRIGHT=5, WB_NEXTBREAK=7, WB_PREVBREAK=6, WB_RIGHT=1, WB_RIGHTBREAK=7

	SendMessage, EM_FINDWORDBREAK, WB_%Flag%, CharIndex,, ahk_id %hCtrl%
	return ErrorLevel
}


RichEdit_FixKeys(hCtrl) {
	oldProc := DllCall("GetWindowLong", "uint", hCtrl, "uint", -4)
	ifEqual, oldProc, 0, return 0
	wndProc := RegisterCallback("RichEdit_wndProc", "", 4, oldProc)
	ifEqual, wndProc, , return 0
	return DllCall("SetWindowLong", "UInt", hCtrl, "Int", -4, "Int", wndProc, "UInt")
}

RichEdit_GetFirstVisibleLine(hCtrl) {
	static EM_GETFIRSTVISIBLELINE = 0xCE
	SendMessage, EM_GETFIRSTVISIBLELINE, 0, 0, , ahk_id %hCtrl%
	return ErrorLevel
}

RichEdit_GetLine(hEdit, LineNumber=-1){
	static EM_GETLINE=196	  ;The return value is the number of characters copied. The return value is zero if the line number specified by the line parameter is greater than the number of lines in the HiEdit control

	if (LineNumber = -1)
		LineNumber := RichEdit_LineFromChar(hEdit, RichEdit_LineIndex(hEdit))
	len := RichEdit_LineLength(hEdit, LineNumber)
	ifEqual, len, 0, return	

	VarSetCapacity(txt, len * (A_IsUnicode ? 2 : 1), 0), NumPut(len, txt)
	SendMessage, EM_GETLINE, LineNumber, &txt,, ahk_id %hEdit%
	if ErrorLevel = FAIL
		return "", ErrorLevel := A_ThisFunc "> Failed to get line with code " A_LastError

	VarSetCapacity(txt, -1)
	return txt
}

RichEdit_GetLineCount(hEdit){
	static EM_GETLINECOUNT=0xBA
 	SendMessage, EM_GETLINECOUNT,,,, ahk_id %hEdit%
	Return ErrorLevel
}

RichEdit_GetOptions(hCtrl)  {
	static  EM_GETOPTIONS=1102
			,1="AUTOWORDSELECTION", 64="AUTOVSCROLL", 128="AUTOHSCROLL",  256="NOHIDESEL", 2048="READONLY", 4096="WANTRETURN", 16777216="SELECTIONBAR"
			,options="1,64,128,256,2048,4096,16777216"

	if (hCtrl > 1) {
		SendMessage, EM_GETOPTIONS,,,, ahk_id %hCtrl%
		o := ErrorLevel
	} else o := SubStr(hCtrl, 2)

	loop, parse, options, `,
		if (o & A_LoopField)
			res .= %A_LoopField% " "

	return SubStr(res, 1, -1)
}

RichEdit_GetCharFormat(hCtrl, ByRef Face="", ByRef Style="", ByRef TextColor="", ByRef BackColor="", Mode="SELECTION")  {
	static EM_GETCHARFORMAT=1082, SCF_SELECTION=1
  		  , CFM_CHARSET:=0x8000000, CFM_BACKCOLOR=0x4000000, CFM_COLOR:=0x40000000, CFM_FACE:=0x20000000, CFM_OFFSET:=0x10000000, CFM_SIZE:=0x80000000, CFM_WEIGHT=0x400000, CFM_UNDERLINETYPE=0x800000
		  , CFE_HIDDEN=0x100, CFE_BOLD=1, CFE_ITALIC=2, CFE_LINK=0x20, CFE_PROTECTED=0x10, CFE_STRIKEOUT=8, CFE_UNDERLINE=4, CFE_SUPERSCRIPT=0x30000, CFE_SUBSCRIPT=0x30000
		  , CFM_ALL2=0xFEFFFFFF, COLOR_WINDOW=5, COLOR_WINDOWTEXT=8
		  , styles="HIDDEN BOLD ITALIC LINK PROTECTED STRIKEOUT UNDERLINE SUPERSCRIPT SUBSCRIPT", StrGet = "StrGet"

	VarSetCapacity(CF, 84, 0), NumPut(84, CF), NumPut(CFM_ALL2, CF, 4)
	SendMessage, EM_GETCHARFORMAT, SCF_%Mode%, &CF,, ahk_id %hCtrl%
;	HexView(&CF, 84)

	Face := DllCall("MulDiv", "UInt", &CF+26, "Int",1, "Int",1, A_IsUnicode ? "astr" : "str")

	Style := "", dwEffects := NumGet(CF, 8, "UInt")
	Loop, parse, styles, %A_SPACE%
		if (CFE_%A_LoopField% & dwEffects)
			Style .= A_LoopField " "
    s := NumGet(CF, 12, "Int") // 20,  o := NumGet(CF, 16, "Int")
	Style .= "s" s (o ? " o" o : "")

	oldFormat := A_FormatInteger
    SetFormat, integer, hex
	
	if (dwEffects & CFM_BACKCOLOR)
		 BackColor := "-" DllCall("GetSysColor", "int", COLOR_WINDOW)
	else BackColor := NumGet(CF, 64), BackColor := (BackColor & 0xff00) + ((BackColor & 0xff0000) >> 16) + ((BackColor & 0xff) << 16)

	if (dwEffects & CFM_COLOR)
		 TextColor := "-" DllCall("GetSysColor", "int", COLOR_WINDOWTEXT)
	else TextColor := NumGet(CF, 20), TextColor := (TextColor & 0xff00) + ((TextColor & 0xff0000) >> 16) + ((TextColor & 0xff) << 16)

    SetFormat, integer, %oldFormat%
}

RichEdit_GetRedo(hCtrl, ByRef name="-")  {
	static EM_CANREDO=1109, EM_GETREDONAME=1111,UIDs="UNKNOWN,TYPING,DELETE,DRAGDROP,CUT,PASTE"
	SendMessage, EM_CANREDO,,,, ahk_id %hCtrl%
	nRedo := ErrorLevel

	If ( nRedo && name != "-" )  {
		SendMessage, EM_GETREDONAME,,,, ahk_id %hCtrl%
		Loop, Parse, UIDs, `,
			If (A_Index - 1 = ErrorLevel)  {
				name := A_LoopField
				break
			}
	}
	return nRedo
}

RichEdit_GetModify(hEdit)  {
    Static EM_GETMODIFY=0xB8
    SendMessage EM_GETMODIFY,,,,ahk_id %hEdit%
    Return ErrorLevel = 4294967295 ? 1 : 0
}

; Num,Align,Line,Ident,Space,Tabs
RichEdit_GetParaFormat(hCtrl) {
	static EM_GETPARAFORMAT=1085
		   ,PFM_ALL2=0xc0fffdff
	VarSetCapacity(PF, 188, 0), NumPut(188, PF),  NumPut(PFM_ALL2, PF, 4)
	SendMessage, EM_GETPARAFORMAT,, &PF,, ahk_id %hCtrl%
}

RichEdit_GetRect(hEdit,ByRef Left="",ByRef Top="",ByRef Right="",ByRef Bottom="") {
    static EM_GETRECT:=0xB2

	VarSetCapacity(RECT,16)
    SendMessage EM_GETRECT,0,&RECT,,ahk_id %hEdit%
      Left  :=NumGet(RECT, 0,"Int")
    , Top   :=NumGet(RECT, 4,"Int")
    , Right :=NumGet(RECT, 8,"Int")
    , Bottom:=NumGet(RECT,12,"Int")
    return  Left " " Top " " Right " " Bottom
}

RichEdit_GetSel(hCtrl, ByRef cpMin="", ByRef cpMax="" )  {
  static EM_EXGETSEL=0x434
  VarSetCapacity(CHARRANGE, 8)
  SendMessage, EM_EXGETSEL, 0,&CHARRANGE,, ahk_id %hCtrl%
  cpMin := NumGet(CHARRANGE, 0, "Int"), cpMax := NumGet(CHARRANGE, 4, "Int")
  return cpMin
}

RichEdit_GetText(HCtrl, CpMin="-", CpMax="-", CodePage="")  {
	static EM_EXGETSEL=0x434, EM_GETTEXTEX=0x45E, EM_GETTEXTRANGE=0x44B, GT_SELECTION=2, StrGet="StrGet"

	bufferLength := RichEdit_GetTextLength(hCtrl, "CLOSE", "UNICODE" )

	If (CpMin CpMax = "--")
		MODE := GT_SELECTION, CpMin:=CpMax:=""
	else if (CpMin=0 && CpMax=-1)
		MODE := GT_ALL      , CpMin:=CpMax:=""
	else if (CpMin+0 != "") && (cpMax+0 != "")
	{
		VarSetCapacity(lpwstr, bufferLength), VarSetCapacity(TEXTRANGE, 12)
		NumPut(CpMin, TEXTRANGE, 0, "UInt")
		NumPut(CpMax, TEXTRANGE, 4, "UInt"), NumPut(&lpwstr, TEXTRANGE, 8, "UInt")
		SendMessage, EM_GETTEXTRANGE,, &TEXTRANGE,, ahk_id %hCtrl%
		
		if !A_IsUnicode 
		{
			; If not unicode, return ansi from string pointer..
			if !InStr(RichEdit_TextMode(HCtrl), "MULTICODEPAGE")
				return DllCall("MulDiv", "UInt", &lpwstr, "Int",1, "Int",1, "str")

			;..else, convert Unicode to Ansi..
			nSz := DllCall("lstrlenW","UInt",&lpwstr) + 1, VarSetCapacity( ansi, nSz )
			DllCall("WideCharToMultiByte" , "Int",0       , "Int",0
										,"UInt",&LPWSTR ,"UInt",nSz+1
										, "Str",ansi    ,"UInt",nSz+1
										, "Int",0       , "Int",0 )
			VarSetCapacity(ansi, -1)
		} else VarSetCapacity(lpwstr, -1)

		return A_IsUnicode ? lpwstr : ansi
	}
	else return "", errorlevel := A_ThisFunc "> Invalid use of cpMin or cpMax parameter."

	VarSetCapacity(GETTEXTEX, 20, 0)          , VarSetCapacity(BUFFER, bufferLength, 0)
	NumPut(bufferLength, GETTEXTEX, 0, "UInt"), NumPut(MODE, GETTEXTEX, 4, "UInt")
	NumPut( (CodePage="unicode" || CodePage="u") ? 1200 : 0  , GETTEXTEX, 8, "UInt")
	SendMessage, EM_GETTEXTEX, &GETTEXTEX, &BUFFER,, ahk_id %hCtrl%
	VarSetCapacity(BUFFER, -1)

	

	return A_IsUnicode ? %StrGet%(&BUFFER,"", "UTF-8") : BUFFER
}

RichEdit_GetTextLength(hCtrl, Flags=0, CodePage="")  {
  static EM_GETTEXTLENGTHEX=95,WM_USER=0x400
  static GTL_DEFAULT=0,GTL_USECRLF=1,GTL_PRECISE=2,GTL_CLOSE=4,GTL_NUMCHARS=8,GTL_NUMBYTES=16

  hexFlags:=0
	Loop, parse, Flags, %A_Tab%%A_Space%
		hexFlags |= GTL_%A_LOOPFIELD%

  VarSetCapacity(GETTEXTLENGTHEX, 4)
  NumPut(hexFlags, GETTEXTLENGTHEX, 0), NumPut((codepage="unicode"||codepage="u") ? 1200 : 1252, GETTEXTLENGTHEX, 4)
  SendMessage, EM_GETTEXTLENGTHEX | WM_USER, &GETTEXTLENGTHEX,0,, ahk_id %hCtrl%
  IfEqual, ERRORLEVEL,0x80070057, return "", errorlevel := A_ThisFunc "> Invalid combination of parameters."
  IfEqual, ERRORLEVEL,FAIL      , return "", errorlevel := A_ThisFunc "> Invalid control handle."
  return ERRORLEVEL
}

RichEdit_GetUndo(hCtrl, ByRef Name="-")  {
  static EM_CANUNDO=0xC6,EM_GETUNDONAME=86,WM_USER=0x400
        ,UIDs="UNKNOWN,TYPING,DELETE,DRAGDROP,CUT,PASTE"
  SendMessage, EM_CANUNDO, 0,0,, ahk_id %hCtrl%
  nUndo := ERRORLEVEL

  If ( nUndo && name != "-" )  {
    SendMessage, WM_USER | EM_GETUNDONAME, 0,0,, ahk_id %hCtrl%
    Loop, Parse, UIDs, `,
      If (A_Index - 1 = errorlevel)  {
        name := A_LoopField
        break
      }
  }
  return nUndo
}

RichEdit_HideSelection(hCtrl, State=true)  {
  static EM_HIDESELECTION = 1087
  SendMessage, EM_HIDESELECTION,%State%,0,, ahk_id %hCtrl%
}

RichEdit_LineFromChar(hCtrl, CharIndex=-1)  {
  static EM_EXLINEFROMCHAR=1078
  SendMessage, EM_EXLINEFROMCHAR,,CharIndex,, ahk_id %hCtrl%
  return ERRORLEVEL
}

RichEdit_LineIndex(hEdit, LineNumber=-1) {
	static EM_LINEINDEX=187
 	SendMessage, EM_LINEINDEX, LineNumber,,, ahk_id %hEdit%
	Return ErrorLevel
}
RichEdit_LineLength(hEdit, LineNumber=-1) {
	static EM_LINELENGTH=193
	SendMessage, EM_LINELENGTH, RichEdit_LineIndex(hEdit, LineNumber),,, ahk_id %hEdit%
	Return ErrorLevel
}
RichEdit_LineScroll(hEdit,XScroll=0,YScroll=0){
    Static EM_LINESCROLL:=0xB6
    SendMessage EM_LINESCROLL, XScroll, YScroll,,ahk_id %hEdit%
}
RichEdit_LimitText(hCtrl,txtSize=0)  {
  static EM_EXLIMITTEXT=53,WM_USER=0x400
  SendMessage, WM_USER | EM_EXLIMITTEXT, 0,%txtSize%,, ahk_id %hCtrl%
}
RichEdit_Paste(hEdit) {
    Static WM_PASTE:=0x302
    SendMessage WM_PASTE,0,0,,ahk_id %hEdit%
}
RichEdit_PasteSpecial(HCtrl, Format)  {
  static EM_PASTESPECIAL=0x440
		,CF_BITMAP=2,CF_DIB=8,CF_DIBV5=17,CF_DIF=5,CF_DSPBITMAP=0x82,CF_DSPENHMETAFILE=0x8E,CF_DSPMETAFILEPICT=0x83
        ,CF_DSPTEXT=0x81,CF_ENHMETAFILE=14,CF_GDIOBJFIRST=0x300,CF_GDIOBJLAST=0x3FF,CF_HDROP=15,CF_LOCALE=16
        ,CF_METAFILEPICT=3,CF_OEMTEXT=7,CF_OWNERDISPLAY=0x80,CF_PALETTE=9,CF_PENDATA=10,CF_PRIVATEFIRST=0x200
        ,CF_PRIVATELAST=0x2FF,CF_RIFF=11,CF_SYLK=4,CF_TEXT=1,CF_WAVE=12,CF_TIFF=6,CF_UNICODETEXT=13

  SendMessage, EM_PASTESPECIAL, CF_%Format%, 0,, ahk_id %hCtrl%
}
RichEdit_PosFromChar(hEdit, CharIndex, ByRef X, ByRef Y) {
    Static EM_POSFROMCHAR=0xD6
    VarSetCapacity(POINTL,8,0)
    SendMessage EM_POSFROMCHAR,&POINTL,CharIndex,,ahk_id %hEdit%
    X:=NumGet(POINTL,0,"Int"), Y:=NumGet(POINTL,4,"Int")
}
RichEdit_Redo(hEdit) {
	static EM_REDO := 1108
	SendMessage, EM_REDO,,,, ahk_id %hEdit%
	return ErrorLevel
}
RichEdit_ReplaceSel(hEdit, Text=""){
	static  EM_REPLACESEL=194
	SendMessage, EM_REPLACESEL,, &text,, ahk_id %hEdit%
}
RichEdit_Save(hCtrl, FileName="") {
	static EM_STREAMOUT=0x44A

	wbProc := RegisterCallback("RichEdit_editStreamCallBack", "F")
	VarSetCapacity(EDITSTREAM, 16, 0)
	NumPut(RichEdit_GetTextLength(hCtrl, "USECRLF")*2, EDITSTREAM)	;aproximate
	NumPut(wbProc, EDITSTREAM, 8, "UInt")

	SendMessage, EM_STREAMOUT, 2, &EDITSTREAM,, ahk_id %hCtrl%
	return RichEdit_editStreamCallBack("!", FileName, "", "")
}
RichEdit_ScrollCaret(hEdit){
	static EM_SCROLLCARET=183
	SendMessage, EM_SCROLLCARET,,,, ahk_id %hEdit%
}
RichEdit_ScrollPos(HCtrl, PosString="" )  {
  static EM_GETSCROLLPOS=1245,EM_SETSCROLLPOS=1246

  VarSetCapacity(POINT, 8, 0)
  If (!PosString)  {
    SendMessage, EM_GETSCROLLPOS, 0,&POINT,, ahk_id %HCtrl%
    return NumGet(POINT, 0, "Int") . "/" . NumGet(POINT, 4, "Int")  ; returns posString
  }

  If RegExMatch( PosString, "^(?<X>\d*)/(?<Y>\d*)$", m )  {
    NumPut(mX, POINT, 0, "Int"), NumPut(mY, POINT, 4, "Int")
    SendMessage, EM_SETSCROLLPOS, 0,&POINT,, ahk_id %HCtrl%
  }
  else return false, errorlevel := "ERROR: '" PosString "' isn't a valid posString."
}
RichEdit_SelectionType(hCtrl)  {
	static EM_SELECTIONTYPE=1090, 1="TEXT", 2="OBJECT", 4="MULTICHAR", 8="MULTIOBJECT", types="1,2,4,8"

	if hCtrl > 0
	{
		SendMessage, EM_SELECTIONTYPE,,,, ahk_id %hCtrl%
		if !(o := ErrorLevel)
			return
	}
	else o := abs(hCtrl)

	loop, parse, types, `,
		if (o & A_LoopField)
			res .= %A_LoopField% " "

	return SubStr(res, 1, -1)
}
RichEdit_SetBgColor(hCtrl, Color)  {
	static EM_SETBKGNDCOLOR=1091

	if (Color < 0) {
		SendMessage, EM_SETBKGNDCOLOR,, abs(Color),, ahk_id %hCtrl%
		return Color
	}

	old := A_FormatInteger
	SetFormat, integer, hex
	RegExMatch( Color, "0x(?P<R>..)(?P<G>..)(?P<B>..)$", _ ) ; RGB2BGR
	Color := "0x00" _B _G _R        ; 0x00bbggrr
	SendMessage, EM_SETBKGNDCOLOR,,Color,, ahk_id %hCtrl%
	RegExMatch( ERRORLEVEL + 0x1000000, "(?P<B>..)(?P<G>..)(?P<R>..)$", _ ) ; RGB2BGR
	pColor := "0x" _R _G _B
	SetFormat, integer, %old%

	return pColor
}
RichEdit_SetCharFormat(HCtrl, Face="", Style="", TextColor="", BackColor="", Mode="SELECTION")  {
	static EM_SETCHARFORMAT=0x444
		  , CFM_CHARSET:=0x8000000,CFM_COLOR:=0x40000000, CFM_FACE:=0x20000000, CFM_OFFSET:=0x10000000, CFM_SIZE:=0x80000000, CFM_WEIGHT=0x400000, CFM_UNDERLINETYPE=0x800000
		  , CFM_HIDDEN=0x100, CFM_BOLD=1, CFM_ITALIC=2, CFM_DISABLED=0x2000, CFM_LINK=0x20, CFM_PROTECTED=0x10, CFM_STRIKEOUT=8, CFM_UNDERLINE=4, CFM_SUPERSCRIPT=0x30000, CFM_SUBSCRIPT=0x30000, CFM_BACKCOLOR=0x4000000, CFE_AUTOBACKCOLOR=0x4000000, CFE_AUTOCOLOR = 0x40000000
		  , CFE_HIDDEN=0x100, CFE_BOLD=1, CFE_ITALIC=2, CFE_DISABLED=0x2000, CFE_LINK=0x20, CFE_PROTECTED=0x10, CFE_STRIKEOUT=8, CFE_UNDERLINE=4, CFE_SUBSCRIPT=0x10000, CFE_SUPERSCRIPT=0x20000
		  , SCF_ALL=4, SCF_SELECTION=1, SCF_WORD=3, StrPut="StrPut"	;, SCF_ASSOCIATEFONT=0x10

	;sz := S(_, "CHARFORMAT2A: cbSize dwMask dwEffects yHeight=.04 yOffset=.04 crTextColor bCharSet=.1 bPitchAndFamily=.1 szFaceName wWeight=60.2 sSpacing=.02 crBackColor lcid dwReserved sStyle=.02 wKerning=.2 bUnderlineType=.1 bAnimation=.1 bRevAuthor=.1 bReserved1=.1")

	VarSetCapacity(CF, 84, 0),  NumPut(84, CF)
	hMask := 0
	if (Face != "") && (StrLen(Face) <= 32) {
		if A_IsUnicode
			VarSetCapacity(faceAnsi, %StrPut%(Face, "cp0")), %StrPut%(Face, &faceAnsi, "cp0")
		hMask |= CFM_FACE, DllCall("lstrcpyA", "UInt", &CF+26, "Uint", A_IsUnicode ? &faceAnsi : &Face)
	}

	if (TextColor != "")
		TextColor := ((TextColor & 0xFF) << 16) + (TextColor & 0xFF00) + ((TextColor >> 16) & 0xFF)
		, hMask |= CFM_COLOR, NumPut(TextColor, CF, 20)

	if (BackColor != "")
		BackColor := ((BackColor & 0xFF) << 16) + (BackColor & 0xFF00) + ((BackColor >> 16) & 0xFF)
		, hMask |= CFM_BACKCOLOR,  NumPut(BackColor, CF, 64)

	if (Style != "") {
		hEffects := 0
		loop, parse, Style, %A_Space%
		{
			lf := A_LoopField, c := SubStr(lf, 1, 1)
			if InStr("so", c) && ((j := SubStr(lf, 2)+0) != "", (%c% := j))
				 continue

			if bOff := c = "-"
				lf := SubStr(lf, 2)

			hMask |= CFM_%lf%, hEffects |= bOff ? 0 : CFE_%lf%
		}
	    NumPut(hEffects, CF, 8)
		if (s != "")
			hMask |= CFM_SIZE, NumPut(s*20, CF, 12, "Int")
		if (o != "")
			hMask |= CFM_OFFSET, NumPut(o, CF, 16, "Int")
	}

	NumPut(hMask, CF, 4)
	SendMessage, EM_SETCHARFORMAT, SCF_%Mode%, &CF,, ahk_id %hCtrl%
	return ErrorLevel
}
RichEdit_SetEvents(hCtrl, Handler="", Events="selchange"){
  static ENM_CHANGE=0x1,ENM_DRAGDROPDONE=0x10,ENM_DROPFILES:=0x100000,ENM_KEYEVENTS=0x10000,ENM_LINK=0x4000000,ENM_MOUSEEVENTS=0x20000,ENM_PROTECTED=0x200000,ENM_REQUESTRESIZE=0x40000,ENM_SCROLLEVENTS=0x8,ENM_SELCHANGE=0x80000 ;ENM_OBJECTPOSITIONS=0x2000000,ENM_SCROLL=0x4,ENM_UPDATE=0x2   ***
       , sEvents="CHANGE,DRAGDROPDONE,DROPFILES,KEYEVENTS,LINK,MOUSEEVENTS,PROTECTED,REQUESTRESIZE,SCROLLEVENTS,SELCHANGE,SCROLL"
	   , WM_NOTIFY=0x4E,WM_COMMAND=0x111,EM_SETEVENTMASK=1093, oldNotify, oldCOMMAND

	if (Handler = "")
		return OnMessage(WM_NOTIFY, old != "RichEdit_onNotify" ? old : ""), old := ""

	if !IsFunc(Handler)
		return A_ThisFunc "> Invalid handler: " Handler

	hMask := 0
	loop, parse, Events, %A_Tab%%A_Space%
	{
		IfEqual, A_LoopField,,continue
		if A_LoopField not in %sEvents%
			return A_ThisFunc "> Invalid event: " A_LoopField
		hMask |= ENM_%A_LOOPFIELD%
		If (A_LoopField = "DROPFILES")
			DllCall("shell32.dll\DragAcceptFiles", "UInt", hCtrl, "UInt", true)

		 ; 		if A_LoopField in CHANGE,SCROLL   ; (*** WIP)
		 ;     	if !oldCOMMAND {
		 ;     		oldCOMMAND := OnMessage(WM_COMMAND, "RichEdit_onNotify")
		 ;     		if oldCOMMAND != RichEdit_onNotify
		 ;     			RichEdit("oldCOMMAND", RegisterCallback(oldCOMMAND))
		 ;     	}
	}

	if !oldNotify {
		oldNotify := OnMessage(WM_NOTIFY, "RichEdit_onNotify")
		if oldNotify != RichEdit_onNotify
			RichEdit("oldNotify", RegisterCallback(oldNotify))
	}

	RichEdit(hCtrl "Handler", Handler)
	SendMessage, EM_SETEVENTMASK,,hMask,, ahk_id %hCtrl%
	return ERRORLEVEL  ; This message returns the previous event mask
}
RichEdit_SetFontSize(hCtrl, Add) {
	static EM_SETFONTSIZE=0x4DF
	SendMessage, EM_SETFONTSIZE,Add,,, ahk_id %hCtrl%
	return ErrorLEvel
}
RichEdit_SetModify(hEdit, State=true)  {
  Static EM_SETMODIFY = 185
  SendMessage EM_SETMODIFY,%State%,,,ahk_id %hEdit%
}
RichEdit_SetOptions(hCtrl, Operation, Options)  {
	static EM_SETOPTIONS=1101
		, ECOOP_SET=0x1,ECOOP_OR=0x2,ECOOP_AND=0x3,ECOOP_XOR=0x4
		, ECO_AUTOWORDSELECTION=0x1,ECO_AUTOVSCROLL=0x40,ECO_AUTOHSCROLL=0x80,ECO_NOHIDESEL=0x100,ECO_READONLY=0x800,ECO_WANTRETURN=0x1000,ECO_SELECTIONBAR=0x1000000

	operation := ECOOP_%Operation%
	ifEqual, operation,,return A_ThisFunc "> Invalid operation: " Operation

	hOptions := 0
	loop, parse, Options, %A_Tab%%A_Space%,
		ifEqual, A_LoopField,,continue
		else hOptions |= ECO_%A_LOOPFIELD%

	SendMessage, EM_SETOPTIONS, operation, hOptions,, ahk_id %hCtrl%
	return RichEdit_GetOptions( "." ErrorLevel)
}
RichEdit_PageRotate(hCtrl, R="") {
	static EM_SETPAGEROTATE=1260, EM_GETPAGEROTATE=1259, EPR_270 = 1, EPR_180 = 2, EPR_90 = 3, 1=270, 2=180, 3=90
	
	if (R="") { 
		SendMessage, EM_GETPAGEROTATE,,,, ahk_id %hCtrl%
		return (%ErrorLevel%)
	}
	
	SendMessage, EM_SETPAGEROTATE,EPR_%R%,,, ahk_id %hCtrl%
}
RichEdit_SetParaFormat(hCtrl, o1="", o2="", o3="", o4="", o5="", o6="")  {
	;S(_, "PARAFORMAT2: cbSize dwMask wNumbering=.2 wEffects=.2 dxStartIndent=.04 dxRightIndent=.04 dxOffset=.04 wAlignment=.02 cTabCount dySpaceBefore=156.04 dySpaceAfter=.04 dyLineSpacing=.04 sStyle=.02 bLineSpacingRule=.1 bOutlineLevel=.1 wShadingWeight=.2 wShadingStyle=.2 wNumberingStart=.2 wNumberingStyle=.2 wNumberingTab=.2 wBorderSpace=.2 wBorderWidth=.2 wBorders=.2")
	static EM_SETPARAFORMAT=0x447
		,PFM_ALIGNMENT=0x8, PFM_BORDER=0x800, PFM_BOX=0x4000000, PFM_COLLAPSED=0x1000000, PFM_DONOTHYPHEN=0x400000, PFM_KEEP=0x20000, PFM_KEEPNEXT=0x40000, PFM_LINESPACING=0x100, PFM_NOLINENUMBER=0x100000, PFM_NOWIDOWCONTROL=0x200000, PFM_NUMBERING=0x20
		,PFM_NUMBERINGSTART=0x8000, PFM_NUMBERINGSTYLE=0x2000, PFM_NUMBERINGTAB=0x4000, PFM_OFFSET=0x4, PFM_OFFSETINDENT=0x80000000, PFM_OUTLINELEVEL=0x2000000, PFM_PAGEBREAKBEFORE=0x80000, PFM_RIGHTINDENT=0x2, PFM_RTLPARA=0x10000, PFM_SHADING=0x1000
		,PFM_SIDEBYSIDE=0x800000, PFM_SPACEAFTER=0x80, PFM_SPACEBEFORE=0x40, PFM_STARTINDENT=0x1, PFM_STYLE=0x400,PFM_TABLE=0x40000000, PFM_TABSTOPS=0x10, PFN_BULLET=0x1, PFN_LCLETTER=3, PFN_LCROMAN=5, PFN_UCLETTER=4, PFN_UCROMAN=6

	static ALIGN_CENTER=3, ALIGN_LEFT=1, ALIGN_RIGHT=2, ALIGN_JUSTIFY=4
		  ,NUM_TYPE_BULLET=1, NUM_TYPE_DECIMAL=2, NUM_TYPE_LOWER=3, NUM_TYPE_UPPER=4, NUM_TYPE_ROMAN_LOWER=5, NUM_TYPE_ROMAN_UPPER=6, NUM_TYPE_SEQUENCE=7
		  ,NUM_STYLE_P=0X100, NUM_STYLE_D=0X200, NUM_STYLE_N=0X300, NUM_STYLE_CONT=0X400, NUM_STYLE_NEW=0X800
		  ,LINE_RULE_SINGLE=0, LINE_RULE_1ANDHALF=1, LINE_RULE_DOUBLE=2, LINE_RULE_S1=3, LINE_RULE_S2=4, LINE_RULE_S3=5,

	loop {
		ifEqual, o%A_Index%,,break
		else j := InStr( o%A_index%, "=" ), p := SubStr(o%A_index%, 1, j-1 ), v := SubStr( o%A_index%, j+1)
		StringSplit, %p%, v, `,
	}

	;S(PF, "PARAFORMAT2! cbSize dwMask wAlignment", sz, PFM_ALIGNMENT, PFA_RIGHT)
	VarSetCapacity(PF, 188, 0), NumPut(188, PF),  hMask := 0
	if Align0
		hMask |= PFM_ALIGNMENT, NumPut(ALIGN_%Align1%, PF, 24, "UShort")

	;S(PF, "PARAFORMAT2! cbSize dwMask wNumbering wNumberingStart wNumberingStyle wNumberingTab", sz, pm := PFM_NUMBERING | PFM_NUMBERINGSTART | PFM_NUMBERINGSTYLE | PFM_NUMBERINGTAB, p1:=2, p2:=10, p3:=0x200, p4:=20*50)
	if Num0
		hMask |= PFM_NUMBERING, NumPut(NUM_TYPE_%Num1%, PF, 8, "UShort")
		, (Num2 = "") ? "" : (hMask |= PFM_NUMBERINGSTART,  NumPut(Num2, PF, 176, "UShort"))
		, (Num3 = "") ? "" : (hMask |= PFM_NUMBERINGSTYLE,  NumPut(NUM_STYLE_%Num3%, PF, 178, "UShort"))
		, (Num4 = "") ? "" : (hMask |= PFM_NUMBERINGTAB,    NumPut(Num4, PF, 180, "UShort"))

	;S(PF, "PARAFORMAT2! cbSize dwMask bLineSpacingRule dyLineSpacing", sz, PFM_LINESPACING, x:=4, y:=20*50)
	if Line0
		hMask |= PFM_LINESPACING,  NumPut(LINE_RULE_%Line1%, PF, 170, "UChar"),  NumPut(Line2, PF, 164, "Int")

	;S(PF, "PARAFORMAT2! cbSize dwMask dxOffset dxStartIndent dxRightIndent", sz, p:=PFM_OFFSET | PFM_OFFSETINDENT | PFM_RIGHTINDENT, x:=-20*50, y:=20*50, z=x:=20*50)
	if Ident0
		hMask |= 0	;dummy, expression so that bellow works....
		,(Ident1 = "") ? "" : (hMask |= SubStr(Ident1,1,1)!="." ? PFM_OFFSETINDENT : (PFM_STARTINDENT, Ident1 := SubStr(Ident1,2)),  NumPut(Ident1, PF, 12, "Int"))
		,(Ident2 = "") ? "" : (hMask |= PFM_OFFSET,  NumPut(Ident2, PF, 20, "Int"))
		,(Ident3 = "") ? "" : (hMask |= PFM_RIGHTINDENT,  NumPut(Ident3, PF, 16, "Int"))

	;S(PF, "PARAFORMAT2! cbSize dwMask dySpaceAfter dySpaceBefore", sz, p:=PFM_SPACEAFTER | PFM_SPACEBEFORE, x:=20*50, y:=10*50)
	if Space0
		hMask |= 0
		,(Space1 = "") ? "" : (hMask |= PFM_SPACEBEFORE,  NumPut(Space1, PF, 156, "Int"))
		,(Space2 = "") ? "" : (hMask |= PFM_SPACEAFTER,   NumPut(Space2, PF, 160, "Int"))

	;S(PF, "PARAFORMAT2! cbSize dwMask cTabCount rgxTabs", sz, PFM_TABSTOPS, x:=2)		;put 2 tabstops
	;NumPut(20*50, PF, 28+0, "Int"), NumPut(20*250, PF, 28+4, "Int")
	if Tabs0
	{
		loop, parse, Tabs1, %A_Space%%A_Tab%
			NumPut(A_LoopField, PF, 24+(A_Index*4), "Int"), tabCount := A_Index
		NumPut(tabCount, PF, 26, "Short"),  hMask |= PFM_TABSTOPS
	}

	;S(PF, "PARAFORMAT2! cbSize dwMask wBorders wBorderWidth", sz, PFM_BORDER, x:=64, y:=20*5 )	;!!! does not work

    NumPut(hMask, PF, 4)   ; HexView(&PF, sz)
	SendMessage, EM_SETPARAFORMAT,,&PF,,ahk_id %hCtrl%
	return ErrorLevel
}
RichEdit_SetEditStyle(hCtrl, Style)  {
	static EM_SETEDITSTYLE=0x4CC
		   ,SES_UPPERCASE=512, SES_LOWERCASE=1024, SES_XLTCRCRLFTOCR=16384, SES_EXTENDBACKCOLOR=4, SES_BEEPONMAXTEXT=2, SES_EMULATESYSEDIT=1, SES_USEAIMM=64, SES_SCROLLONKILLFOCUS=8192

	if bOff := (SubStr(Style, 1, 1) = "-")
		Style := SubStr(Style, 2)
	SendMessage, EM_SETEDITSTYLE, bOff ? 0 : SES_%Style%, SES_%Style%,, ahk_id %hCtrl%
	return ErrorLevel
}
RichEdit_SetSel(hCtrl, CpMin=0, CpMax=0)  {
	static EM_EXSETSEL=1079

	VarSetCapacity(CHARRANGE, 8), NumPut(cpMin, CHARRANGE, 0, "Int"), NumPut(cpMax ? cpMax : cpMin, CHARRANGE, 4, "Int")
	SendMessage, EM_EXSETSEL, , &CHARRANGE,, ahk_id %hCtrl%
	return ErrorLevel
}
RichEdit_SetText(HCtrl, Txt="", Flag=0, Pos="" )  {
	static EM_SETTEXTEX=0x461, ST_KEEPUNDO=1, ST_SELECTION=2, StrPut = "StrPut"

	hFlag=0
	If Flag
  		Loop, parse, Flag, %A_Tab%%A_Space%
			If (A_LoopField = "FROMFILE") {
				FileRead, Txt, %Txt%
				IfNotEqual, Errorlevel, 0, return false, ErrorLevel := A_ThisFunc "> Couldn't open file: '" Txt "'"
			} else if A_LoopField in KEEPUNDO,SELECTION
				hFlag |= ST_%A_LoopField%

  ; If specifying a pos, calculate new range for restoring original selection
	if (Pos != "")
		if (hFlag >= ST_SELECTION) {
			RichEdit_GetSel(HCtrl, min, max)
			ifLess, Pos, -1, SetEnv, Pos, 0
			else if (Pos > max-min)
				Pos := max-min

			ifEqual, Pos, -1, SetEnv, Pos, %max%
			else Pos += min

			prevPos := RichEdit_SetSel(HCtrl, Pos)
			max += StrLen(Txt)
		} else {
			hFlag |= ST_SELECTION, len := StrLen(Txt)
			RichEdit_GetSel(HCtrl, min, max)
			prevPos := RichEdit_SetSel(HCtrl, Pos)
			if (Pos < min)
				min += len, max += len
			else if (Pos >= min) && (Pos < max)
				max += len
		}

	VarSetCapacity(SETTEXTEX, 8), NumPut(hFlag, SETTEXTEX)

	tt := Txt
	if A_IsUnicode
		VarSetCapacity(tt, %StrPut%(Txt, "cp0")), %StrPut%(Txt, &tt, "cp0")
	
	SendMessage, EM_SETTEXTEX, &SETTEXTEX, &tt,, ahk_id %HCtrl%
	return ERRORLEVEL, prevPos != "" ? RichEdit_SetSel(HCtrl, min, max) : ""
}
RichEdit_SetUndoLimit(hCtrl, nMax)  {
	static EM_SETUNDOLIMIT=82,WM_USER=0x400
	if nMax is not integer
		return false
	SendMessage, WM_USER | EM_SETUNDOLIMIT, %nMax%,0,, ahk_id %hCtrl%
	return ERRORLEVEL
}
RichEdit_ShowScrollBar(hCtrl, Bar, State=true)  {
  static EM_SHOWSCROLLBAR=96,WM_USER=0x400,SB_HORZ=0,SB_VERT=1

	If ( StrLen(bar) <= 2)  {
		If InStr( Bar, "H" )
			SendMessage, WM_USER | EM_SHOWSCROLLBAR, SB_HORZ, State,, ahk_id %hCtrl%
		If InStr( Bar, "V" )
			SendMessage, WM_USER | EM_SHOWSCROLLBAR, SB_VERT, State,, ahk_id %hCtrl%
	}
}
RichEdit_TextMode(HCtrl, TextMode="")  {
  static EM_SETTEXTMODE=0x459, EM_GETTEXTMODE=0x45A
		,TM_PLAINTEXT=1, TM_RICHTEXT=2, TM_SINGLELEVELUNDO=4, TM_MULTILEVELUNDO=8, TM_SINGLECODEPAGE=16, TM_MULTICODEPAGE=32
		,TEXTMODES="MULTICODEPAGE,SINGLECODEPAGE,MULTILEVELUNDO,SINGLELEVELUNDO,RICHTEXT,PLAINTEXT"

	If (TextMode)  {    ; Setting text mode
		hTextMode := 0
		Loop, parse, TextMode, %A_Tab%%A_Space%
			ifEqual, A_LoopField,,continue
			else hTextMode |= TM_%A_LOOPFIELD%
	    IfEqual, hTextMode,, return false, ErrorLevel := A_ThisFunc "> Some of the options are invalid: " TextMode

		RichEdit_SetText(HCtrl)
		SendMessage, EM_SETTEXTMODE, hTextMode,,, ahk_id %HCtrl%
		return Errorlevel ? False : True
	}
	else  {				; Getting current text mode
		SendMessage, EM_GETTEXTMODE,,,, ahk_id %HCtrl%
		tm := ErrorLevel
		loop, parse, TEXTMODES,`,
			if (TM_%A_LoopField% & tm)
				res .= A_LoopField " "
		return SubStr(res, 1, -1)
	}
}
RichEdit_WordWrap(HCtrl, Flag)  {
	static EM_SETTARGETDEVICE=0x448
	SendMessage, EM_SETTARGETDEVICE,NULL,!Flag,, ahk_id %hCtrl%
	return ErrorLevel
}
Richedit_Zoom(hCtrl, zoom=0)  {
  static EM_SETZOOM=225,EM_GETZOOM=224,WM_USER=0x400

  ; Get the current zoom ratio
  VarSetCapacity(numer, 4)  , VarSetCapacity(denom, 4)
  SendMessage, WM_USER | EM_GETZOOM, &numer,&denom,, ahk_id %hCtrl%
  numerator := NumGet(numer, 0, "UShort") ;, denominator := NumGet(denom, 0, "UShort")

  If zoom is not integer
    return false, errorlevel := "ERROR: '" zoom "' is not an integer, stupid"
  If (!zoom)
    return numerator "/" denominator

  ; Calculate new numerator value (denominator not currently changed)
  InStr(zoom,"-") ?  numerator-=SubStr(zoom,2)  :  numerator+=zoom

  ; Set the zoom ratio
  SendMessage, WM_USER | EM_SETZOOM, %numerator%, 1,, ahk_id %hCtrl%
  return ERRORLEVEL
}
RichEdit_Undo(hCtrl, Reset=false)  {
  static EM_UNDO=0xC7,EM_EMPTYUNDOBUFFER=0xCD
  If !reset  {
    SendMessage, EM_UNDO,,,, ahk_id %hCtrl%
    return ERRORLEVEL
  } else SendMessage, EM_EMPTYUNDOBUFFER,,,, ahk_id %hCtrl%
}

;========================================== PRIVATE ===================================================================

RichEdit_add2Form(hParent, Txt, Opt){
	static parse = "Form_Parse"
	%parse%(Opt, "x# y# w# h# style", x, y, w, h, style)
	hCtrl := RichEdit_Add(hParent, x, y, w, h, style, Txt)
	return hCtrl
}


RichEdit_onNotify(Wparam, Lparam, Msg, Hwnd) {
	static MODULEID := 091009, oldNotify="*", oldCOMMAND="*"
		  ,ENM_PROTECTED=1796, ENM_REQUESTRESIZE=1793, ENM_SELCHANGE=1794, ENM_DROPFILES=1795, ENM_DRAGDROPDONE=1804, ENM_LINK=1803

	critical		;its OK, always executed in its own thread.
	if (_ := (NumGet(Lparam+4))) != MODULEID
	 ifLess _, 10000, return	;if ahk control, return asap (AHK increments control ID starting from 1. Custom controls use IDs > 10000 as its unlikely that u will use more then 10K ahk controls.
	 else {
		ifEqual, oldNotify, *, SetEnv, oldNotify, % RichEdit("oldNotify")
		if oldNotify !=
			 return DllCall(oldNotify, "uint", Wparam, "uint", Lparam, "uint", Msg, "uint", Hwnd)
		else return
		;ifEqual, oldCOMMAND, *, SetEnv, oldCOMMAND, % RichEdit("oldCOMMAND")
		;if oldCOMMAND !=
		;	return DllCall(oldCOMMAND, "uint", Wparam, "uint", Lparam, "uint", Msg, "uint", Hwnd)
	 }

	hw :=  NumGet(Lparam+0), code := NumGet(Lparam+8, 0, "UInt"),  handler := RichEdit(hw "Handler")
	ifEqual, handler,,return code=ENM_PROTECTED ? TRUE : FALSE  ;ENM_PROTECTED msg returns nonzero value to prevent operation

	If (code = 1792) {					;ENM_MOUSEEVENTS ENM_KEYEVENTS ENM_SCROLLEVENTS
		static 258="KEYPRESS_DWN",513="MOUSE_L_DWN",514="MOUSE_L_UP",516="MOUSE_R_DWN",517="MOUSE_R_UP",522="SCROLL_BEGIN",277="SCROLL_END" ;,512="MOUSE_HOVER",256="KEYPRESS_UP"

		umsg := NumGet(lparam+12)		;Keyboard or mouse message identifier.
		key := ((n:=NumGet(lparam+40))>=32) ? Chr(n) : ""
		If (%umsg%)   ;***
			return %handler%(hw, %Umsg%, key, "", "")
	}

	If (code = ENM_REQUESTRESIZE)  {
		rc := NumGet(lparam+24) ;Requested new size.
		return %handler%(hw, "REQUESTRESIZE", rc, "", "")
	}

	if (code = ENM_SELCHANGE)  {
		cpMin := NumGet(lparam+12), cpMax := NumGet(lparam+16), selType := RichEdit_SelectionType(-NumGet(lparam+20))
		return %handler%(hw, "SELCHANGE", cpMin, cpMax, seltype)
	}

	If (code = ENM_DROPFILES)  {          ;
		hDrop := NumGet(lparam+8, 4 , "UInt"), cp := NumGet(lparam+8, 8 , "Int")

		; (thanks DerRaphael!)  http://www.autohotkey.com/forum/post-234905.html&highlight=#234905
		Loop,% file_count := DllCall("shell32.dll\DragQueryFile","uInt",hDrop,"uInt",0xFFFFFFFF,"uInt",0,"uInt",0) {
		   VarSetCapacity(lpSzFile,4096,0)
		   DllCall("shell32.dll\DragQueryFile","uInt",hDrop,"uInt",A_index-1,"uInt",&lpSzFile,"uInt",4096)
		   VarSetCapacity(lpSzFile,-1)
		   files .= ((A_Index>1) ? "`n" : "") lpSzFile
		}
		return %handler%(hw, "DROPFILES", file_count, files, cp)
	}

	If (code = ENM_DRAGDROPDONE)  {
		chars := NumGet(lparam+12), cpMax := NumGet(lparam+16)
		return %handler%(hw, "DRAGDROPDONE", chars, cpMax-chars, cpMax)
	}

	If (code = ENM_PROTECTED)  {
		cpMin := NumGet(lparam+24), cpMax := NumGet(lparam+28)
		return %handler%(hw, "PROTECTED", cpMin, cpMax, "") ; This message returns a nonzero value to prevent the operation.
	}

	If (code = ENM_LINK )  {
		umsg := NumGet(lparam+12)
		If umsg Not In 513,516
			 return
		cpMin := NumGet(lparam+24), cpMax := NumGet(lparam+28)
		return %handler%(hw, "LINK", (Umsg = 513 ? "LClick" : "RClick"), cpMin, cpMax) ; This message returns a nonzero value to prevent the operation.
	}
}

RichEdit_wndProc(hwnd, uMsg, wParam, lParam){

    if (uMsg = 0x87)  ;WM_GETDLGCODE
		return 4	 ;DLGC_WANTALLKEYS

   return DllCall("CallWindowProcA", "UInt", A_EventInfo, "UInt", hwnd, "UInt", uMsg, "UInt", wParam, "UInt", lParam)
}

RichEdit_editStreamCallBack(dwCookie, pbBuff, cb, pcb) {
	static s

	if (dwCookie="!") {
		fn := pbBuff
		ifEqual, fn,, return l := s, VarSetCapacity(s,0)
		FileDelete, %fn%
		FileAppend, %s%, %fn%
		return VarSetCapacity(s, 0)
	}

	if s =
		 VarSetCapacity(s, dwCookie)

	s .= DllCall("MulDiv", "Int", pbBuff, "Int",1, "Int", 1, "str")
}

;Mini storage
RichEdit(var="", value="~`a", ByRef o1="", ByRef o2="", ByRef o3="", ByRef o4="", ByRef o5="", ByRef o6="") {
	static
	 _ := %var%
	ifNotEqual, value, ~`a, SetEnv, %var%, %value%
	return _
}

/* Group: About
	o Version 1.0c by freakkk & majkinetor.
	o MSDN Reference : <http://msdn.microsoft.com/en-us/library/bb787605(VS.85).aspx>.
	o RichEdit control shortcut keys: <http://msdn.microsoft.com/en-us/library/bb787873(VS.85).aspx#rich_edit_shortcut_keys>.
	o Licensed under BSD <http://creativecommons.org/licenses/BSD/>.
 */


   /*
WinSock2.ahk // a rewrite by derRaphael (w) Sep, 9 2008

based on the WinLIRC Script from Chris
    http://www.autohotkey.com/docs/scripts/WinLIRC.htm
and on the WinLIRC Rewrite by ZedGecko
    http://www.autohotkey.com/forum/viewtopic.php?t=13829
    
__WSA_GetHostByName - Parts based upon scripts from DarviK 
and Tasman. Not much left of the origin source, but it was
their achievement by doing the neccessary research.
*/

; WS2 Connect - This establishes a connection to a named resource
; The parameter is to be passed in an URI:Port manner.
; Returns the socket upon successfull connection, otherwise it
; returns -1. In the latter case more Information is in the global
; variable __WSA_ErrMsg
;
; Usage-Example: 
;    Pop3_Socket := WS2_Connect("mail.isp.com:110")
; See the Doc for more Information.
WS2_Connect(lpszUrl) {

    Global 
    ; split our targetURI 
    __WinINet_InternetCrackURL("info://" lpszUrl,"__WSA")
    ; name our port
    WS2_Port := __WSA_nPort
    
    ; Init the Winsock connection
    if !__WSA_ScriptInit() || !__WSA_Startup() {        ; Init the Scriptvariables      Fire up the WSA
        WS2_CleanUp()         ; Do a premature cleanup
        return -1             ; and return an error indication
    }
    ; check the URI if it's valid
	__WSA_lpszHostName := SubStr(lpszUrl,1, Instr(lpszUrl, ":")-1)
    if (RegExMatch(__WSA_lpszHostName,"[^\d.]+")) { ; Must be different than IP
        WS2_IPAddress := __WSA_GetHostByName(__WSA_lpszHostName)
	}
    else {     ; Let's check if the IP is valid
        StringSplit,__WSA_tmpIPFragment, __WSA_lpszHostName,.
        Loop,4
            If (__WSA_tmpIPFragment%A_Index%<0 || __WSA_tmpIPFragment%A_Index%>255 || __WSA_tmpIPFragment0!=4) {
                __WSA_IPerror = 1
                Break
            }
        If (__WSA_IPerror=1) {
            __WSA_ErrMsg .= "No valid IP Supplied"
		}
        else 
            WS2_IPAddress := __WSA_lpszHostName
    }

    ; CONVERSIONS

    ; The htons function returns the value in TCP/IP network byte order.
    ; http://msdn.microsoft.com/en-us/library/ms738557(VS.85).aspx
    __WSA_Port                := DllCall("Ws2_32\htons", "UShort", WS2_Port)

    ; The inet_addr function converts a string containing an IPv4 dotted-decimal 
    ; address into a proper address for the IN_ADDR structure.
    ; inet_addr: http://msdn.microsoft.com/en-us/library/ms738563(VS.85).aspx
    ; IN_ADDR:   http://msdn.microsoft.com/en-us/library/ms738571(VS.85).aspx
    __WSA_InetAddr           := DllCall("Ws2_32\inet_addr", "Str", WS2_IPAddress)
	__WSA_Socket:=__WSA_Socket()
    If (__WSA_Socket && __WSA_Connect()) {
        return __WSA_Socket   ; All went OK, return the SocketID
	}
    Else {
        WS2_CleanUp()         ; Do a premature cleanup
        return -1             ; and return an error indication
    }
}

; WS2 OnMessage - This function defines, whatever should happen when
; a Message is received on the socket.
; Expected Parameter: 
;      Ws2_Socket    => Socket returned from WS2_Connect() Call
;      UDF           => An UserDefinedFunction to which the received 
;                       Data will be passed to
; Optional Parameter:
;      WindowMessage => A number indicating upon which WM_Message to react
;
; Returns -1 on error, 0 on success

WS2_AsyncSelect(Ws2_Socket,UDF,WindowMessage="") {
    Global __WSA_ErrMsg
    If (    ( StrLen(Ws2_Socket)=0 )
         || ( StrLen(UDF)=0        ) ) {
        res := -1
    } else {
        If (    (StrLen(WindowMessage)=0) 
             || (WindowMessage+0=0)      )
            WindowMessage := 0x5000
        res := __WSA_AsyncSelect(Ws2_Socket, UDF, WindowMessage)
    }
    return res
}   

WS2_SendData(WS2_Socket,DataToSend) {
    Global __WSA_ErrMsg
    If (__WSA_send(WS2_Socket, DataToSend)=-1) {
        
    }
}

; WS2 Cleanup - This needs to be called whenever Your Script exits
; Usually this is invoked by some OnExit, Label subroutines.
WS2_CleanUp() {
    DllCall("Ws2_32\WSACleanup")
}

; WS2 ScriptInit - for internal use only
; Initializes neccessary variables for this Script.
__WSA_ScriptInit()
{
    ; CONTANTS

    ; We're working with version 2 of Winsock
    Local VersionRequested    := 2
    ; from http://msdn.microsoft.com/en-us/library/ms742212(VS.85).aspx
    Local AF_INET             := 2
    Local SOCK_STREAM         := 1
    Local IPPROTO_TCP         := 6
    Local FD_READ             := 0x1
    Local FD_CLOSE            := 0x20

    __AI_PASSIVE              := 1

    __WSA_WSVersion           := VersionRequested
    __WSA_SocketType          := SOCK_STREAM
    __WSA_SocketProtocol      := IPPROTO_TCP
    __WSA_SocketAF            := AF_INET
    __WSA_lEvent              := FD_READ|FD_CLOSE

    __WSA_WOULDBLOCK          := 10035  ; http://www.sockets.com/err_lst1.htm#WSAECONNRESET
    __WSA_CONNRESET           := 10054  ; http://www.sockets.com/err_lst1.htm#WSAECONNRESET

    return 1
}

; WS2 Startup - for internal use only
; Initializes the Winsock 2 Adapter
__WSA_Startup()
{
    Global WSAData, __WSA_ErrMsg, __WSA_WSVersion

    ; It's a good idea, to have a __WSA_ErrMsg Container, so any Error Msgs
    ; may be catched by the script.
    __WSA_ErrMsg := ""

    ; Generate Structure for the lpWSAData 
    ; as stated on http://msdn.microsoft.com/en-us/library/ms742213.aspx
    ; More on WSADATA (structure) to be found here:
    ; http://msdn.microsoft.com/en-us/library/ms741563(VS.85).aspx
    VarSetCapacity(WSAData, 32)
    result := DllCall("Ws2_32\WSAStartup", "UShort", __WSA_WSVersion, "UInt", &WSAData)

    if (ErrorLevel)
        __WSA_ErrMsg .= "Ws2_32\WSAStartup could not be called due to error " ErrorLevel "`n"
                      . "Winsock 2.0 or higher is required.`n"
    if (result!=0) 
        __WSA_ErrMsg .= "Ws2_32\WSAStartup " __WSA_GetLastError()

    If (StrLen(__WSA_ErrMsg)>0)
        Return -1
    Else
        Return 1
}

; WS2 Socket Descriptor - for internal use only
; Sets type and neccessary structures for a successfull connection
__WSA_Socket()
{
    Global __WSA_ErrMsg, __WSA_SocketProtocol, __WSA_SocketType, __WSA_SocketAF

    ; Supposed to return a descriptor referencing the new socket
    ; http://msdn.microsoft.com/en-us/library/ms742212(VS.85).aspx
    Socket := DllCall("Ws2_32\socket","Int",2,"Int",1,"Int",6,"Ptr")
    if (socket = -1)
        __WSA_ErrMsg .= "Ws2_32\socket " __WSA_GetLastError()
    If (StrLen(__WSA_ErrMsg)>0)
        Return -1
    Else
        Return Socket

}

; WS2 Connection call - for internal use only
; Establishes a connection to a foreign IP at the specified port
__WSA_Connect()
{
    Global __WSA_ErrMsg, __WSA_Port, __WSA_Socket, __WSA_InetAddr, __WSA_SocketAF

    ; Generate socketaddr structure for the connect()
    ; http://msdn.microsoft.com/en-us/library/ms740496(VS.85).aspx
    __WSA_SockAddrNameLen  := 16
    VarSetCapacity(__WSA_SockAddr, __WSA_SockAddrNameLen)
    NumPut(__WSA_SocketAF, __WSA_SockAddr, 0, "UShort")
    NumPut(__WSA_Port,     __WSA_SockAddr, 2, "UShort")
    NumPut(__WSA_InetAddr, __WSA_SockAddr, 4)

    ; The connect function establishes a connection to a specified socket.
    ; http://msdn.microsoft.com/en-us/library/ms737625(VS.85).aspx
    result := DllCall("Ws2_32\connect"
                        , "UInt", __WSA_Socket
                        , "UInt", &__WSA_SockAddr
                        , "Int" , __WSA_SockAddrNameLen)
    if (result)
        __WSA_ErrMsg .= "Ws2_32\connect " __WSA_GetLastError()

    If (StrLen(__WSA_ErrMsg)>0)
        Return -1
    Else
        Return 1
}


/*
 This code based originally upon an example by DarviK 
    http://www.autohotkey.com/forum/topic8871.html 
 and on the modifcations by Tasman
    http://www.autohotkey.com/forum/viewtopic.php?t=9937
*/
; Resolves canonical domainname to IP
__WSA_GetHostByName(url)
{
    Global __WSA_ErrMsg
    ; gethostbyname returns information about a domainname into a Hostent Structure
    ; http://msdn.microsoft.com/en-us/library/ms738524(VS.85).aspx
    IP := ""
    if ((PtrHostent:=DllCall("Ws2_32\gethostbyname","str",url)) != 0) {
        Loop, 1 ; 3 is max No of retrieved addresses
            If (PtrTmpIP := NumGet(NumGet(PtrHostent+12)+(offset:=(A_Index-1)*4),offset)) {
                IP := (IP) ? IP "|" : ""
                Loop, 4 ; Read our IP address
                    IP .= NumGet(PtrTmpIP+offset,(A_Index-1 ),"UChar") "."
                IP := SubStr(IP,1,-1)
            } else ; No more IPs left
                Break
        result := IP
    } else {
        __WSA_ErrMsg .= "Ws2_32\gethostbyname failed`n "
        result := -1
    }
    return result
}

; Return the last Error with a lil bit o' text if neccessary
; Note: the txt variable is set to 0 when checking for received content
__WSA_GetLastError(txt=1)
{
    Err       := DllCall("Ws2_32\WSAGetLastError")
    ExtraInfo := __WSA_ErrLookUp(RegExReplace(Err,"[^\d]"))
    If ((InStr(ExtraInfo,"Sorry, no")) || (txt!=1))
        ExtraInfo := ""
    Return ( txt ? "indicated Winsock error " : "") 
           . Err
           . ( txt ? "`n" ExtraInfo : "")
}

; WS2 AsyncSelect - for internal use only
; Sets up an Notification Handler for Receiving Messages
; Expected Parameters: Socket from Initialisation
; Optional: NotificationMsg   - default 0x5000
;           WSA_DataReiceiver - an different Name to standard
;                               wm_* processor function.
;                               default __WSA_ReceiveData
; Returns -1 on Error, 0 on success
__WSA_AsyncSelect(__WSA_Socket, UDF, __WSA_NotificationMsg=0x5000
                              ,__WSA_DataReceiver="__WSA_recv")
{
    Global

    __WSA_UDF := UDF

    OnMessage(__WSA_NotificationMsg, __WSA_DataReceiver)
    ; The WSAAsyncSelect function requests Windows message-based notification 
    ; of network events for a socket.
    ; http://msdn.microsoft.com/en-us/library/ms741540(VS.85).aspx
    Result := DllCall("Ws2_32\WSAAsyncSelect"
                , "UInt", __WSA_Socket
                , "UInt", __WSA_GetThisScriptHandle()
                , "UInt", __WSA_NotificationMsg
                , "Int",  __WSA_lEvent)
    if (Result) {
        __WSA_ErrMsg .= "Ws2_32\WSAAsyncSelect() " . __WSA_GetLastError()
        Result := -1
    }
    Return Result
}

; WS2 Receive - for internal use only
; Triggers upon Notification Handler when Receiving Messages
__WSA_recv(wParam, lParam)
{
    Global __WSA_3, __WSA_ErrMsg, NickName, Channel, Sender, DotText, DOTDOTDOT, CurrTextLen, Chat1, OnlineUsers, WantNick, __WSA_UDF
    ; __WSA_UDF containes the name of the UserDefinedFunction to call when the event 
    ; has been triggered and text may be processed (allthough the reveived text might
    ; be inclomplete, especially when receiving large chunks of data, like in eMail-
    ; attachments or sometimes in IRC). The UDF needs to accept two parameter: socket
    ; and the received buffer
    __WSA_Socket := wParam
    __WSA_BufferSize = 4096
    Loop
    {
        VarSetCapacity(__WSA_Buffer, __WSA_BufferSize, 0)
        __WSA_BufferLength := DllCall("Ws2_32\recv"
                                        , "UPtr", __WSA_Socket
                                        , "Str",  __WSA_Buffer
                                        , "Int",  __WSA_BufferSize
                                        , "Int",  0 )
        if (__WSA_BufferLength = 0)
            break
        if (__WSA_BufferLength = -1){
            __WSA_Err := __WSA_GetLastError(0)
            ; __WSA_WOULDBLOCK (from http://www.sockets.com/)
            ; The socket is marked as non-blocking (non-blocking operation mode), and 
            ; the requested operation is not complete at this time. The operation is 
            ; underway, but as yet incomplete. 
            if (__WSA_Err = 10035)
                return 1

            ; __WSA_CONNRESET: (from http://www.sockets.com/)
            ; A connection was forcibly closed by a peer. This normally results from 
            ; a loss of the connection on the remote socket due to a timeout or a reboot. 
            If (__WSA_Err != 10054)
                __WSA_ErrMsg .= "Ws2_32\recv indicated Winsock error " __WSA_Err "`n"
            Else{
                Quit()
                Loop, 5 {
					Gui, 80: ListView, OnlineUsers%A_Index%
					LV_Delete()
				}
                CurrTextLen := RichEdit_GetTextLength(Chat1)
                RichEdit_SetText(Chat1, "== Re-Connecting.", "SELECTION", -1)
                RichEdit_SetSel(Chat1, CurrTextLen , -1)
                DotText := "Re-Connecting"
                SetTimer, DOTDOTDOT, 1000
                IfWinActive, Contractor Chat - %WantNick%
                    MsgBox, 4096, Lost Connection, Your connection has timed out. Please wait until reconnected to continute with chat.`r`nThis will take a moment.1
                CONNECT(NickName, NickName, NickName, "", "irc.freenode.net", 6667)
                JOIN(Channel)
                ROMF("Message_Recieved")
            }
            break
        }
        if (StrLen(__WSA_UDF)!=0) ; If set, call UserDefinedFunction and pass Buffer to it
            %__WSA_UDF%(__WSA_Socket,__WSA_Buffer) 
    }
    return 1
}



; WSA Send - for internal use only
; Users are encouraged to use the WS2_SendData() Function
__WSA_send(__WSA_Socket, __WSA_Data)
{
    Global __WSA_ErrMsg

    Result := DllCall("Ws2_32\send", "UInt", __WSA_Socket, "Str",  __WSA_Data, "Int", StrLen(__WSA_Data) << !!A_IsUnicode, "Int", 0)
   If (Result = -1)
      __WSA_ErrMsg .=  "Ws2_32\send " __WSA_GetLastError()
   Return Result
}

; Closes Open Socket - for internal use only
; Returns 0 on success
__WSA_CloseSocket(__WSA_Socket)
{
    Global __WSA_ErrMsg

    Result := DllCall("Ws2_32\closesocket"
                       , "UInt", __WSA_Socket)
    If (Result != 0)
      __WSA_ErrMsg .=  "Ws2_32\closesocket " __WSA_GetLastError()

    Return result
}

; GetThisScriptHandle - for internal use only
; Returns the handle of the executing script
__WSA_GetThisScriptHandle()
{
    HiddenWindowsSave := A_DetectHiddenWindows
    DetectHiddenWindows On
    ScriptMainWindowId := WinExist("ahk_class AutoHotkey ahk_pid " DllCall("GetCurrentProcessId"))
    DetectHiddenWindows %HiddenWindowsSave%
    Return ScriptMainWindowId
}

; Lookup Winsock ErrCode - for internal use only
; This list is form http://www.sockets.com
__WSA_ErrLookUp(sNumber) {
WSA_ErrorList =
(LTrim Join`n
    10004 - Interrupted system call
    10009 - Bad file number
    10013 - Permission denied
    10014 - Bad address
    10022 - Invalid argument
    10024 - Too many open files
    10035 - Operation would block
    10036 - Operation now in progress
    10037 - Operation already in progress
    10038 - Socket operation on non-socket
    10039 - D   estination address required
    10040 - Message too long
    10041 - Protocol wrong type for socket
    10042 - Bad protocol option
    10043 - Protocol not supported
    10044 - Socket type not supported
    10045 - Operation not supported on socket
    10046 - Protocol family not supported
    10047 - Address family not supported by protocol family
    10048 - Address already in use
    10049 - Can't assign requested address
    10050 - Network is down
    10051 - Network is unreachable
    10052 - Net dropped connection or reset
    10053 - Software caused connection abort
    10054 - Connection reset by peer
    10055 - No buffer space available
    10056 - Socket is already connected
    10057 - Socket is not connected
    10058 - Can't send after socket shutdown
    10059 - Too many references, can't splice
    10060 - Connection timed out
    10061 - Connection refused
    10062 - Too many levels of symbolic links
    10063 - File name too long
    10064 - Host is down
    10065 - No Route to Host
    10066 - Directory not empty
    10067 - Too many processes
    10068 - Too many users
    10069 - Disc Quota Exceeded
    10070 - Stale NFS file handle
    10091 - Network SubSystem is unavailable
    10092 - WINSOCK DLL Version out of range
    10093 - Successful WSASTARTUP not yet performed
    10071 - Too many levels of remote in path
    11001 - Host not found
    11002 - Non-Authoritative Host not found
    11003 - Non-Recoverable errors: FORMERR, REFUSED, NOTIMP
    11004 - Valid name, no data record of requested type
    11004 - No address, look for MX record 
)
ExNr := 0, ExErr := "Sorry, but no definition available."
Loop,Parse,WSA_ErrorList,`n
{
    RegExMatch(A_LoopField,"(?P<Nr>\d+) - (?P<Err>.*)",Ex)
    if (sNumber = ExNr)
        break
}
Return ExNr " means " ExErr "`n"
}
; WinINet InternetCrackURL - for internal use only
; v 0.1 / (w) 25.07.2008 by derRaphael / zLib-Style release
; This routine was originally posted here:
; http://www.autohotkey.com/forum/viewtopic.php?p=209957#209957
__WinINet_InternetCrackURL(lpszUrl,arrayName="URL")
{
    local hModule, offset_name_length
    hModule := DllCall("LoadLibrary", "Str", "WinINet.Dll")

    ; SetUpStructures for URL_COMPONENTS / needed for InternetCrackURL
    ; http://msdn.microsoft.com/en-us/library/aa385420(VS.85).aspx
    offset_name_length:= "4-lpszScheme-255|16-lpszHostName-1024|28-lpszUserName-1024|"
                       . "36-lpszPassword-1024|44-lpszUrlPath-1024|52-lpszExtrainfo-1024"

    VarSetCapacity(URL_COMPONENTS,60,0)
    ; Struc Size               ; Scheme Size                  ; Max Port Number
    NumPut(60,URL_COMPONENTS,0), NumPut(255,URL_COMPONENTS,12), NumPut(0xffff,URL_COMPONENTS,24)
    Loop,Parse,offset_name_length,|
    {
        RegExMatch(A_LoopField,"(?P<Offset>\d+)-(?P<Name>[a-zA-Z]+)-(?P<Size>\d+)",iCU_)
        VarSetCapacity(%iCU_Name%,iCU_Size,0)
        NumPut(&%iCU_Name%,URL_COMPONENTS,iCU_Offset)
        NumPut(iCU_Size,URL_COMPONENTS,iCU_Offset+4)
    }

    ; Split the given URL; extract scheme, user, pass, authotity (host), port, path, and query (extrainfo)
    ; http://msdn.microsoft.com/en-us/library/aa384376(VS.85).aspx
    DllCall("WinINet\InternetCrackUrlA","Str",lpszUrl,"uPtr",StrLen(lpszUrl) << !!A_IsUnicode,"uPtr",0,"uPtr",&URL_COMPONENTS)
    ; Update variables to retrieve results
    Loop,Parse,offset_name_length,|
    {
        RegExMatch(A_LoopField,"-(?P<Name>[a-zA-Z]+)-",iCU_)
        VarSetCapacity(%iCU_Name%,-1)
        %arrayName%_%iCU_Name% := % %iCU_Name%
    }
    %arrayName%_nPort:=NumGet(URL_COMPONENTS,24,"uInt")
    DllCall("FreeLibrary", "UInt", hModule)                    ; unload the library
}

ILButton(HBtn, Images, Cx=16, Cy=16, Align="center", Margin="1 1 1 1") {
   static BCM_SETIMAGELIST=0x1602, a_right=1, a_top=2, a_bottom=3, a_center=4

   if Images is not integer
   {
      hIL := DllCall("ImageList_Create", "UInt", Cx, "UInt",Cy, "UInt", 0x20, "UInt", 1, "UInt", 6)
      Loop, Parse, Images, |, %A_Space%%A_Tab%
      {
         if (A_LoopField = "") {
            DllCall("ImageList_AddIcon", "UInt", hIL, "UInt", I)
            continue
         }
         if (k := InStr(A_LoopField, ":", 0, 0)) && ( k!=2 )
             v1 := SubStr(A_LoopField, 1, k-1), v2 := SubStr(A_LoopField, k+1)
         else v1 := A_LoopField, v2 := 0

         ifEqual, v1,,SetEnv,v1, %prevFileName%
         else prevFileName := v1

         DllCall("PrivateExtractIcons", "Str", v1, "UInt", v2, "UInt", Cx, "UInt", Cy, "UIntP", hIcon, "UInt",0, "UInt", 1, "UInt", 0x20) ; LR_LOADTRANSPARENT = 0x20
         DllCall("ImageList_AddIcon", "UInt",hIL, "UInt",hIcon)
         ifEqual, A_Index, 1, SetEnv, I, %hIcon%
         else DllCall("DestroyIcon", "UInt", hIcon)
      }
      DllCall("DestroyIcon", "UInt", I)
   } else hIL := Images

   VarSetCapacity(BIL, 24), NumPut(hIL, BIL), NumPut(a_%Align%, BIL, 20)
   Loop, Parse, Margin, %A_Space%
      NumPut(A_LoopField, BIL, A_Index * 4)

   SendMessage, BCM_SETIMAGELIST,,&BIL,, ahk_id %HBtn%
   ifEqual, ErrorLevel, 0, return 0, DllCall("ImageList_Destroy", "Uint", hIL)

   sleep 1 ; workaround for a redrawing problem on WinXP
   return hIL
}

;----------------------------------------------------------------------------------------------------
;---------------------------------------   UPDATE   -------------------------------------------------
;----------------------------------------------------------------------------------------------------

   
Check_ForUpdate(_ReplaceCurrentScript = 0, _SuppressMsgBox = 0, _CallbackFunction = "", ByRef _Information = "")
{
    ;Version.ini file format
    ;
    ;[Info]
    ;Version=1.156
    ;URL=http://www.autohotkey.net/~dylan904/mypropertypreservation/executablebids.exe
    ;MD5=00000000000000000000000000000000 or omit this key completly to skip the MD5 file validation
   
   
    Static Script_Name := "LoneIRC" ;Your script name
    , Update_URL := "http://www.autohotkey.net/~dylan904/Chat.ini" ;The URL of the version.ini file for your script
    , Retry_Count := 3 ;Retry count for if/when anything goes wrong
    global Version_Number
    
    Random,Filler,10000000,99999999
    Version_File := A_Temp . "\" . Filler . ".ini"
    , Temp_FileName := A_Temp . "\" . Filler . ".tmp"
    , VBS_FileName := A_Temp . "\" . Filler . ".vbs"
    Loop,% Retry_Count
    {
        _Information := ""
           
        UrlDownloadToFile,%Update_URL%,%Version_File%
           
        IniRead,Version,%Version_File%,Info,Version,N/A
           
        If (Version = "N/A"){
            FileDelete,%Version_File%
            If (A_Index = Retry_Count)
                _Information .= "The version info file doesn't have a ""Version"" key in the ""Info"" section or the file can't be downloaded."
            Else
                Sleep,500
               
            Continue
        }
           
        If (Version > Version_Number){
            If (_SuppressMsgBox != 1 and _SuppressMsgBox != 3){ 
               MsgBox,262144,New version available,There is a new version of %Script_Name% available, `nand can be installed automatically. `nCurrent version: %Version_Number%`nNew version: %Version%`n`nPress OK to continue.
                   
                IfMsgBox,OK
                    MsgBox_Result := 1
				IfMsgBox,Cancel
				{
					MsgBox,262144,Exiting Application, Please come back when you're ready to update!
					ExitApp
				}
            }
               
            If (_SuppressMsgBox or MsgBox_Result){
                IniRead,URL,%Version_File%,Info,URL,N/A
                   
                If (URL = "N/A")
                    _Information .= "The version info file doesn't have a valid URL key."
                Else {
                    SplitPath,URL,,,Extension
                       
                    If (Extension = "ahk" And A_AHKPath = "")
                        _Information .= "The new version of the script is an .ahk filetype and you do not have AutoHotKey installed on this computer.`r`nReplacing the current script is not supported."
                    Else If (Extension != "exe" And Extension != "ahk")
                        _Information .= "The new file to download is not an .EXE or an .AHK file type. Replacing the current script is not supported."
                    Else {
                        IniRead,MD5,%Version_File%,Info,MD5,N/A
                           
                        Loop,% Retry_Count
                        {
                            UrlDownloadToFile,%URL%,%Temp_FileName%
                               
                            IfExist,%Temp_FileName%
                            {
                                If (MD5 = "N/A"){
                                    _Information .= "The version info file doesn't have a valid MD5 key."
                                    , Success := True
                                    Break
                                } Else {
                                    H := DllCall("CreateFile","Str",Temp_FileName,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0)
                                    , VarSetCapacity(FileSize,8,0)
                                    , DllCall("GetFileSizeEx","UInt",H,"Int64",&FileSize)
                                    , FileSize := NumGet(FileSize,0,"Int64")
                                    , FileSize := FileSize = -1 ? 0 : FileSize
                                       
                                    If (FileSize != 0){
                                        VarSetCapacity(Data,FileSize,0)
                                        , DllCall("ReadFile","UInt",H,"UInt",&Data,"UInt",FileSize,"UInt",0,"UInt",0)
                                        , DllCall("CloseHandle","UInt",H)
                                        , VarSetCapacity(MD5_CTX,104,0)
                                        , DllCall("advapi32\MD5Init",Str,MD5_CTX)
                                        , DllCall("advapi32\MD5Update",Str,MD5_CTX,"UInt",&Data,"UInt",FileSize)
                                        , DllCall("advapi32\MD5Final",Str,MD5_CTX)
                                           
                                        FileMD5 := ""
                                        Loop % StrLen(Hex:="123456789ABCDEF0")
                                            N := NumGet(MD5_CTX,87+A_Index,"Char"), FileMD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
                                           
                                        VarSetCapacity(Data,FileSize,0)
                                        , VarSetCapacity(Data,0)
                                           
                                        If (FileMD5 != MD5){
                                            FileDelete,%Temp_FileName%
                                               
                                            If (A_Index = Retry_Count)
                                                _Information .= "The MD5 hash of the downloaded file does not match the MD5 hash in the version info file."
                                            Else                                     
                                                Sleep,500
                                               
                                            Continue
                                        } Else
                                            Success := True
                                    } Else {
                                        DllCall("CloseHandle","UInt",H)
                                        Success := True
                                    }
                                }
                            } Else {
                                If (A_Index = Retry_Count)
                                    _Information .= "Unable to download the latest version of the file from " %URL% "."
                                Else
                                    Sleep,500
                                Continue
                            }
                        }
                    }
                }
            }
        } Else
            _Information .= "No update was found."
           
        FileDelete,%Version_File%
        Break
    }
       
    If (_ReplaceCurrentScript And Success){
        SplitPath,URL,,,Extension
        Process,Exist
        MyPID := ErrorLevel
           
        VBS_P1 =
        (LTrim Join`r`n
            On Error Resume Next
            Set objShell = CreateObject("WScript.Shell")
            objShell.Run "TaskKill -f -im %MyPID%", WindowStyle, WaitOnReturn
            WScript.Sleep 1000
            Set objFSO = CreateObject("Scripting.FileSystemObject")
        )
           
        If (A_IsCompiled){
            If (Extension = "exe"){
                VBS_P2 =
                (LTrim Join`r`n
                    objFSO.CopyFile "%Temp_FileName%", "%A_ScriptFullPath%", True
                    objFSO.DeleteFile "%Temp_FileName%", True
                    objShell.Run """%A_ScriptFullPath%"""
                )
                   
                Return_Val :=  Temp_FileName
            } Else { ;Extension is ahk
                SplitPath,A_ScriptFullPath,,FDirectory,,FName
                FileMove,%Temp_FileName%,%FDirectory%\%FName%.ahk,1
                FileDelete,%Temp_FileName%
                   
                VBS_P2 =
                (LTrim Join`r`n
                    objFSO.DeleteFile "%A_ScriptFullPath%", True
                    objShell.Run """%FDirectory%\%FName%.ahk"""
                )
                   
                Return_Val := FDirectory . "\" . FName . ".ahk"
            }
        } Else {
            If (Extension = "ahk"){
                FileMove,%Temp_FileName%,%A_ScriptFullPath%,1
                If (Errorlevel)
                    _Information .= "Error (" Errorlevel ") unable to replace current script with the latest version."
                Else {
                    VBS_P2 = 
                    (LTrim Join`r`n
                        objShell.Run """%A_ScriptFullPath%"""
                    )
                       
                    Return_Val :=  A_ScriptFullPath
                }
            } Else If (Extension = "exe"){
                SplitPath,A_ScriptFullPath,,FDirectory,,FName
                FileMove,%Temp_FileName%,%FDirectory%\%FName%.exe,1
                FileDelete,%A_ScriptFullPath%
                   
                VBS_P2 =
                (LTrim Join`r`n
                    objShell.Run """%FDirectory%\%FName%.exe"""
                )
                   
                Return_Val :=  FDirectory . "\" . FName . ".exe"
            } Else {
                FileDelete,%Temp_FileName%
                _Information .= "The downloaded file is not an .EXE or an .AHK file type. Replacing the current script is not supported."
            }
        }
           
        VBS_P3 =
        (LTrim Join`r`n
            objFSO.DeleteFile "%VBS_FileName%", True
            Set objFSO = Nothing
            Set objShell = Nothing
        )
           
        If (_SuppressMsgBox < 2)
            VBS_P3 .= "`r`nWScript.Echo ""Update completed successfully."""
           
        FileDelete,%VBS_FileName%
        FileAppend,%VBS_P1%`r`n%VBS_P2%`r`n%VBS_P3%,%VBS_FileName%
           
        If (_CallbackFunction != ""){
            If (IsFunc(_CallbackFunction))
                %_CallbackFunction%()
            Else
                _Information .= "The callback function is not a valid function name."
        }
           
        RunWait,%VBS_FileName%,%A_Temp%,VBS_PID
        Sleep,2000
           
        Process,Close,%VBS_PID%
        _Information := "Error (?) unable to replace current script with the latest version.`r`nPlease make sure your computer supports running .vbs scripts and that the script isn't running in a pipe."
    }
       
    _Information := _Information = "" ? "None" : _Information
       
    Return Return_Val
}
;----------------------------------------------------------------------------------------------------
;----------------------------------------   END OF UPDATE   -----------------------------------------
;----------------------------------------------------------------------------------------------------