/* 
Version 0.7.1
	*Toaster application uses parameters (more accurate)
Version 0.7
	*Chat windows
Version 0.6.1
	*Stops sending message when user is offline
Version 0.6
	*Added Toasters
Version 0.5
	*Renamed Novell Messenger
	*Runs Novell Messenger on startup
Version 0.4
	*Detects users sign in and out
Version 0.3
	*Will Now recieve messages to a message box
Version 0.2
	*Can now send messages, in beta
Version 0.1
	*Shows who's online
	
To be done:
	*Hide default novell windows
	*Change user list to use ini file or comma seperated values to allow any length user name
	*Use Command line interface (send.exe) to send messages
	*Make sure all messages are grabbed from recieve window if many recieved in 1 seconds
	*Does not recieve more messages until OK is pressed  // ignored as of version 0.7
	*Hold on sending message - will be ignored once send.exe implamented
	*Notification if message successfuly sent - will adapt in version 0.7 only for send failed 
*/

#NoEnv
#SingleInstance,Ignore
#Persistent
Menu,Tray,NoStandard
Menu,Tray,Tip,Novell Messenger
IfExist,Novell.ico
Menu,Tray,Icon,Novell.ico
Menu,Tray,Add,&Show Window,Window
Menu,Tray,Disable,&Show Window
Menu,Tray,Default,&Show Window
Menu,Tray,Add,&Reload,Reload
Menu,Tray,Add,E&xit,Exit
/*
Process,Exist,nwtray.exe
PID = ErrorLevel
DetectHiddenWindows,On
SendMessage,0x11F,808002e1,06bf0e85,,ahk_pid %pid%
*/
SetBatchLines,-1
Gui,Add,ListView,gListView -Multi +ReadOnly,Users|K Number|Status
ImageListID := IL_Create(2) ; needed to enable image on listview
LV_SetImageList(ImageListID) ;needed to enable image on listview
IL_Add(ImageListID, "Online.ico",0) ;Registers online icon
IL_Add(ImageListID, "Offline.ico",1) ;Registers offline icon
Gui,+Resize
SetTitleMatchMode,3 ; window must be exact
IfNotExist,%A_WinDir%\System32\nwsndmsg.exe
{
	Msgbox,16,Novell Not Found,Novell Chat could not be found on your computer
	ExitApp
}
Process,Exist,nwsndmsg.exe
If ErrorLevel = 0
{
	Run,%A_WinDir%\System32\nwsndmsg.exe,,UseErrorLevel
	If ErrorLevel <> 0
	{
		Msgbox,16,Novell Messenger Error,Novell Messenger could not be Run
		ExitApp
	}
}
GuiNo = 1
;IfWinNotExist,Novell Send Message
;TrayTip,,Please open Novell Send Message Utililty from the Novell Tray`nand select the FTEDATAPR2 Server
WinWait,Novell Send Message
;Sleep,1000
IfWinNotExist,Send Message,Send message to the selected users or groups.
{
	;Control,ChooseString,FTEDATAPR2,SysListView321,Novell Send Message
	ControlGet,Servers,List,,SysListView321,Novell Send Message,Select a server
	Loop,Parse,Servers,`n
	{
		IfEqual, A_LoopField, FTEDATAPR2
		{
			Count := A_Index - 1
			ControlSend,SysListView321,{Down %Count%},Novell Send Message,Select a server
			ControlSend,&Select,{Enter},Novell Send Message,Select a server
			Break
		}
	}
	If Count =
	{
		Msgbox,16,Server not found,Can't find server FTEDATAPR2 in list
		Exit
	}
}
WinWait,Send Message,Send message to the selected users or groups.
ControlSend,SysListView321,{F5},Send Message,Send message to the selected users or groups.
	Sleep,50
;------- Start of 1st list retrieval
Control,Disable,,Button1,Send Message,Send message to the selected users or groups.
ControlGet,Users,List,,SysListView321,Send Message,Send message to the selected users or groups. ;gets a list of online users
Menu,Tray,Enable,&Show Window
Gui,Show,xcenter ycenter h320 w300,Novell Messenger 0.7 Alpha
Loop,Read,Users.txt
{
	StringLeft,KNo,A_LoopReadLine,8 ; retrieves the K number
	User := RegExMatch(Users,Kno) ;searches for user
	StringTrimLeft,Name,A_LoopReadLine,9 ;gets user name
	If User <> 0
	{
		LV_Add("Icon" . 1, Name, KNo,"Online") ;adds online user with icon
		;LV_Add("Icon" . 1,Name,KNo)
		;Msgbox,%Name% is online
	}
	Else
	{
		LV_Add("Icon" . 2, Name, KNo,"Offline") ; adds offline user with icon
	}
	
}
LV_ModifyCol(1,100) ; column width
LV_ModifyCol(2,100)
LV_ModifyCol(3,50)
LV_ModifyCol(1,"Sort") ;sorts by online or offline
LV_ModifyCol(3,"SortDesc") ;sorts by online or offline
SetTimer,Incoming,1000
SetTimer,Reload,10000
Return
;If user <> 0
;Msgbox,Paul is online
;Msgbox,%Users%

ListView:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
	LV_GetText(SelKNo, A_EventInfo ,2) ; gets the K Number of user
	LV_GetText(Status, A_EventInfo ,3) ; Gets status of contact
	
	If Status = Offline
	{
		Gui,+OwnDialogs
		Msgbox,16,Contact Offline,%RowText% is not online. You are unable to chat to them.
		Exit
	}
	ChatWinUNo := SelKNo
	ChatWinUser := RowText
	Gosub,CreateChatWindow
}
return

GuiSize:
If A_EventInfo = 1
{
	WinHide,Novell Messenger
}
Else
{
	GuiControl, Move, SysListView321, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 20) ;resizes controls in window
}
;GuiControl , Move, SysListView321 ,x14 y36 w%Width2% h%Height2%
return

GuiClose:
ExitApp

Window:
WinShow,Novell Messenger
WinActivate,Novell Messenger
Return

Incoming:
IfWinExist,Novell Message Popup
{
	ControlGetText,IMessage,Edit1,Novell Message Popup
	Loop,Parse,IMessage,`n
	{
		If A_Index = 4
		{
			StringTrimLeft,IName,A_LoopField,6
			StringLeft,IName2,IName,8
			Msgbox,IName: %IName% IName2: %IName2%
			Loop,Read,Users.txt
			{
				StringLeft,INo,A_LoopReadLine,8 ; retrieves the K number
				User := RegExMatch(INo,IName2) ;searches for user
				StringTrimLeft,INameR,A_LoopReadLine,9
				If User <> 0
				{
					IName2 = %INameR%
					Break
				}
			}
			StringGetPos,MessageTrim,A_LoopField,]
			MessageTrim2 := MessageTrim + 2
			StringTrimLeft,TrimmedMsg,A_LoopField,%MessageTrim2%
		}
	}
	WinClose,Novell Message Popup
	ChatWinUser := IName2
	ChatWinUNo := INo
	IfWinNotExist,%IName2% - Chat
	Gosub,CreateChatWindow
	ControlGetText,GuiINo,Static1,%IName2% - Chat
	Gui,%GuiINo%: Default
	LV_Add(1,IName2 A_Space "Says:", TrimmedMsg)
	SetTimer,GuiFlash,500
	;Msgbox,,Message From %IName2%,%TrimmedMsg%
}
;SetTimer,Incoming,Off
Return

GuiFlash:
GuiFlash++
Gui, %GuiNo%: Flash
If GuiFlash > 6
{
	GUIFlash = 0
	Settimer,GuiFlash,Off
}
Return

Reload:
SetTitleMatchMode,2
DetectHiddenWindows,On
SetTimer,Reload,Off
ControlGet,OldUsers,List,,SysListView321,Novell Messenger
;msgbox,%OldUsers%
LV_Delete() ;erases all data
ControlSend,SysListView321,{F5},Send Message,Send message to the selected users or groups.
ControlGet,Users,List,,SysListView321,Send Message,Send message to the selected users or groups. ;gets a list of online users
Loop,Read,Users.txt
{
	StringLeft,KNo,A_LoopReadLine,8 ; retrieves the K number
	User := RegExMatch(Users,Kno) ;searches for user
	StringTrimLeft,Name,A_LoopReadLine,9 ;gets user name
	If User <> 0
	{
		LV_Add("Icon" . 1, Name, KNo,"Online") ;adds online user with icon
		;LV_Add("Icon" . 1,Name,KNo)
		;Msgbox,%Name% is online
	}
	Else
	{
		LV_Add("Icon" . 2, Name, KNo,"Offline") ; adds offline user with icon
	}
	
}
LV_ModifyCol(1,100) ; column width
LV_ModifyCol(2,100)
LV_ModifyCol(3,50)
LV_ModifyCol(1,"Sort") ;sorts by online or offline
LV_ModifyCol(3,"SortDesc") ;sorts by online or offline
ControlGet,NewUsers,List,,SysListView321,Novell Messenger
;IfNotEqual,NewUsers,%OldUsers%
;{
	;Gui, +OwnDialogs
	;MsgBox,A user has signed on or off.
;}
Loop,Parse,NewUsers,`n
{
	NewField = %A_LoopField%
	StringGetPos,NewFieldNo,NewField,%A_Tab%K ;finds K number
	NewFieldNo++ ; to remove tab before K number
	StringTrimLeft,NewField2,NewField,%NewFieldNo% ; feeds back only K number
	StringLeft,NewField3,NewField2,8
	;Msgbox,%NewField2%
	Loop,Parse,OldUsers,`n
	{
		OldField = %A_LoopField%
		StringGetPos,OldFieldNo,OldField,%A_Tab%K ;finds K number
		OldFieldNo++ ; to remove tab before K number
		StringTrimLeft,OldField2,OldField,%OldFieldNo% ; feeds back K number and status
		StringLeft,OldField3,OldField2,8
		IfInString,NewField3,%OldField3%
		;Msgbox,OldField: %OldField%`nOldFieldNo: %OldFieldNo%`nOldField2: %OldField2%`nOldField3: %OldField3%
		{
			;Msgbox,Sub Run
			IfNotEqual,NewField2,%OldField2%
			{
				Loop,Read,Users.txt
				{
					StringLeft,ONo,A_LoopReadLine,8 ; retrieves the K number
					UserO := RegExMatch(ONo,OldField3) ;searches for user
					StringTrimLeft,ONameR,A_LoopReadLine,9
					If UserO <> 0
					NewField3 = %ONameR%
				}
				IfInString,NewField2,Online
				{
					Run,autohotkey.exe "%A_ScriptDir%\toaster.ahk" "%NewField3% has signed on"
					;SetTitleMatchMode,2
					;WinWait,Toaster
					;ControlSetText,Static1,%NewField3% has signed On,Toaster
				}
					;Msgbox,,,%NewField3% has signed On,3
				IfInString,NewField2,Offline
				{
					Run,autohotkey.exe "%A_ScriptDir%\toaster.ahk" "%NewField3% has signed off"
					;SetTitleMatchMode,2
					;WinWait,Toaster
					;ControlSetText,Static1,%NewField3% has signed Off,Toaster
				}
					;Msgbox,,,%NewField3% has signed off,3
				;Msgbox,%OldField2% has signed in or out.`n`nOld Data:%OldField2%|`nNew Data:%NewField2%|
			}
		}
	}
}
SetTimer,Reload,On
Return

CreateChatWindow:
IfWinExist,%ChatWinUser% - Chat
	Exit
GuiNo++
Gui,%GuiNo%: Default
Gui,Add,ListView,x10 y10 w400 h300 -Hdr +NoSortHdr -LV0x10 -Multi gLVEvent,User|Message
LV_ModifyCol(1,80)
LV_ModifyCol(2,316)
Gui,Add,Text,+Hidden,%GuiNo%
Gui,Add,Text,+Hidden,%ChatWinUNo%
Gui, Add,Edit,x10 y320 h45 w320 -0x1000 ,
GUi,Add,Button,x340 y320 h45 w70 Default gSend,&Send
Gui, Show,xcenter ycenter h375 w420,%ChatWinUser% - Chat
GuiControl,Focus,Edit1
Return

Send:
;WinGetActiveTitle,ActiveWin
;ControlGetText,GuiFind,Static1,%ActiveWin%
;Gui,%GuiFind%: Default
SetBatchLines,-1
DetectHiddenText,On
ControlGetText,SelKNo,Static2,A
GuiControlGet,Message,,Edit1
If Message =
	Exit
SetTimer,Reload,Off
GuiControl,Disable,Button1
ControlSetText,Edit1,%Message%,Send Message,Send message to the selected users or groups
Control,Disable,,SysListView321,Send Message,Send message to the selected users or groups. 
ControlGet,ChatUsers,List,,SysListView321,Send Message,Send message to the selected users or groups. ;gets a list of online users
Loop,Parse,ChatUsers,`n
{
	StringTrimLeft,Line,A_LoopField,2
	StringLeft,Line2,Line,8
	IfEqual, Line2, %SelKNo%
	{
		Count := A_Index - 1
		ControlSend,SysListView321,{Home},Send Message,Send message to the selected users or groups.
		ControlSend,SysListView321,{Down %Count%},Send Message,Send message to the selected users or groups.
		ControlSend,&Send,{Enter},Send Message,Send message to the selected users or groups.
		Break
	}
Control,Enable,,SysListView321,Send Message,Send message to the selected users or groups.
ResultHandleRuns = 0
SetTimer,ResultHandle,100
	;Msgbox,%A_LoopField%
}
SetTimer,Reload,On
LV_Add(1,"Paul Says:", Message)
GuiControl,Text,Edit1,
GuiControl,Focus,Edit1
GuiControl,Enable,Button1
;ControlSend,SysListView321,{End},User - Chat,
Loop,3
SendMessage, 0x115, 1, 0, SysListView321, User - Chat
Return

LVEvent:
if A_GuiEvent = DoubleClick
{
  LV_GetText(SelName, A_EventInfo ,1) ; gets the K Number of user
  LV_GetText(SelMessage, A_EventInfo ,2) ; gets the K Number of user
  Gui,+OwnDialogs
  Msgbox,,Message,%SelName% %SelMessage%
}
Return

ResultHandle:
ResultHandleRuns++
If ResultHandleRuns > 50
	SetTimer,ResultHandle,Off
IfWinNotExist,Send Message Results
	Exit
ControlSend,Button1,{Enter},Send Message Results
Return


Exit:
ExitApp