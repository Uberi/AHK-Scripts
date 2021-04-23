/* 
Version 0.8
	*Seperate Changelog
	*Application code re-written
	*Can handle variable lengh user names (was fixed to 8 character before)
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
	
*************** MUST DO **************************8
	*Upon reload, if own user appears offline, reload is re-done until appear online (will stop bug when everyone appears offline) DONE
	*Handle many incoming messages in one moment
	*Own user must be in user.txt
	*If novell message exe open script will fail.
	
******* TO DO VERSION 0.8******
	*ON INCOMING MESSAGE Instead of closing window when read last message, which would result tempory showing when msg recieved, hide but check the number in list view and if increased get new message whilst keeping window hidden
	*Adapt to use multiple lines

To be done:
	*Hide default novell windows (needed open for testing) READY
	*Change user list to use ini file or comma seperated values to allow any length user name (Using CSV now)  DONE
	*Use Command line interface (send.exe) to send messages (unable to do)
	*Make sure all messages are grabbed from recieve window if many recieved in 1 seconds
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
MessengerTitle = Novell Messenger 0.8 Alpha
GuiNo = 1
IniRead,HideWindows,Novell Messenger.ini,Settings,HideWindows,0

Gui,Add,ListView,gListView -Multi +ReadOnly,Users|K Number|Status
ImageListID := IL_Create(2) ; needed to enable image on listview
LV_SetImageList(ImageListID) ;needed to enable image on listview
IL_Add(ImageListID, A_ScriptDir "\Online.ico",0) ;Registers online icon
IL_Add(ImageListID, A_ScriptDir "\Offline.ico",1) ;Registers offline icon
Gui,Add,Button,+Hidden +Default gSelect,Select
Gui,+Resize

FileRead,UsernameCheck,%A_ScriptDir%\Users CSV.txt
IfNotInString,UsernameCheck,%A_Username%
{
	Msgbox,16,Novell Messenger Error,Your own user name is not in users file. Please enter your user name in file.
	ExitApp
}
UsernameCheck =

SetTitleMatchMode,3 ; window must be exact
IfNotExist,%A_WinDir%\System32\nwsndmsg.exe
{
	Msgbox,16,Novell Not Found,Novell could not be found on your computer.`nNovell Messenger will now exit.
	ExitApp
}
Gosub,RunMessenger
Gui,Show,xcenter ycenter h320 w300,%MessengerTitle%
Menu,Tray,Enable,&Show Window
SetTimer,Incoming,100
FirstReload = 1
Gosub,Reload
SetTimer,Reload,5000
OnMessage( 0x18, "WM_SHOWWINDOW") 
;OnMessage( NMSend, "NMSend")
Return

NMSend()
{
	Msgbox,Message Recieved
	Return
}

RunMessenger:
Process,Exist,nwsndmsg.exe
If ErrorLevel = 0
{
	Run,%A_WinDir%\System32\nwsndmsg.exe,,UseErrorLevel
	If ErrorLevel <> 0
	{
		Msgbox,16,Novell Messenger Dependency Error,The application `"%A_WinDir%\System32\nwsndmsg.exe`" could not be run which Novell Messenger is dependant on.`nNovell Messenger will now exit.
		ExitApp
	}
}
DetectHiddenWindows,On
WinWait,Novell Send Message,Select a server to see a list of users and groups,20
If ErrorLevel <> 0
{
	Msgbox,48,Novell Messenger Error,Timeout waiting for Novell Send Message server select window to appear.,10
	Exit
}
WinSetTitle,Novell Send Message,Select a server to see a list of users and groups,Novell Send Message <main>
If HideWindows = 1
	WinHide,Novell Send Message <main>,Select a server to see a list of users and groups
SetTitleMatchMode,2
IfWinNotExist,Send Message,Send message to the selected users or groups.
{
	ControlGet,Servers,List,,SysListView321,Novell Send Message <main>,Select a server to see a list of users and groups
	IniRead,Server,Novell Messenger.ini,Settings,Server,%A_Space%
	If Server = 
	{
		Msgbox,16,Novell Messenger Error,No server in setting file. Please Configure Novell Messenger.ini`nNovell Messenger will now exit.
		Process,Close,nwsndmsg.exe ; Switch with line above in final
		ExitApp
	}
	ControlSend,SysListView321,{Home},Novell Send Message <main>,Select a server to see a list of users and groups
	Loop,Parse,Servers,`n
	{
		IfEqual, A_LoopField, %Server%
		{
			Count := A_Index - 1
			ControlSend,SysListView321,{Down %Count%},Novell Send Message <main>,Select a server to see a list of users and groups
			ControlSend,&Select,{Enter},Novell Send Message <main>,Select a server to see a list of users and groups
			Break
		}
	}
	Servers =
	If Count =
	{
		Msgbox,16,Server not found,Can't find server %server% in list
		Exit
	}
}
DetectHiddenWindows,Off
WinWait,Send Message,Send message to the selected users or groups.,20
WinSetTitle,Send Message,Send message to the selected users or groups.,Send Message <main>
If ErrorLevel <> 0
{
	Msgbox,48,Novell Messenger Error,Timeout waiting for Novell Send Message user select window to appear.,10
	Exit
}
ControlSend,SysListView321,{F5},Send Message <main>,Send message to the selected users or groups.
If HideWindows = 1
	SetTimer,HideWindow,100
Return

HideWindow:
Critical
DetectHiddenWindows,Off
WinHide,Send Message <main>,Send message to the selected users or groups.
IfWinNotExist,Send Message <main>,Send message to the selected users or groups.
	SetTimer,HideWindow,Off
Return

GuiSize:
If A_EventInfo = 1
	WinHide,%MessengerTitle%
Else
	GuiControl, Move, SysListView321, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 20) ;resizes controls in window
return

Reload:
SetTimer,Reload,Off
SetBatchLines,-1
DetectHiddenWindows,On
If FirstReload = 0
{
	OldRows := LV_GetCount()
	Loop,%OldRows%
	{
			LV_GetText(OldUsersAdd, A_Index, 2)
			LV_GetText(OldUsersStatus, A_Index, 3)
			OldUsers = %OldUsers%%OldUsersAdd%,%OldUsersStatus%`n
	}
}
IfWinNotExist,Send Message <main>,Send message to the selected users or groups.
	Gosub,RunMessenger
ControlSend,SysListView321,{F5},Send Message <main>,Send message to the selected users or groups. ;Refresh list
ControlGet,Users,List,,SysListView321,Send Message <main>,Send message to the selected users or groups. ;gets a list of online users
If Users =
{
	OldUsers =
	TrayTip,Novell Messenger Error,Error retriving contact list, retrying,5,3
	Sleep,500
	Goto,Reload
	Exit
}
IfNotExist,%A_ScriptDir%\Users CSV.txt
{
	MsgBox,21,Novell Messenger Error,The user file could not be found.`nRetry or exit.
	IfMsgBox,Retry
	{
		OldUsers =
		Goto,Reload
	}
	IfMsgBox,Cancel
		ExitApp
}
LV_Delete() ;erases all data
Loop,Read,%A_ScriptDir%\Users CSV.txt
{
	TrimKNo := RegExMatch(A_LoopReadLine,",")
	StringTrimLeft,NickName,A_LoopReadLine,%TrimKNo%
	TrimKNo--
	StringLeft,KNo,A_LoopReadLine,%TrimKNo%
	IfInString,Users,%KNo%
		LV_Add("Icon" . 1, NickName, KNo,"Online") ;adds online user with icon
	Else
		LV_Add("Icon" . 2, NickName, KNo,"Offline")  ;adds offline user with icon
}
LV_ModifyCol(1,100) ; column width
LV_ModifyCol(2,100)
LV_ModifyCol(3,50)
LV_ModifyCol(1,"Sort") ;sorts by online or offline
LV_ModifyCol(3,"SortDesc") ;sorts by online or offline

If FirstReload = 0
{
	NewRows := LV_GetCount()
	Loop,%NewRows%
	{
		LV_GetText(NewUser, A_Index, 2)
		LV_GetText(NewUserStatus, A_Index, 3)
		NewUserFull = %NewUser%,%NewUserStatus%
		Loop,Parse,OldUsers,`n
		{
			IfInString,A_LoopField,%NewUser%
			{
				;Msgbox,Positive %NewUser% - %A_LoopField%
				;Msgbox,%NewUserFull% - %A_LoopField%
				IfNotEqual,NewUserFull,%A_LoopField%
				{
					;Msgbox,Status change
					NickName := GetUsername(NewUser,"0")
					IfInString,NewUserFull,Online
					{
						Run,autohotkey.exe "%A_ScriptDir%\toaster.ahk" "%NickName% has signed on"
						Sleep,50
					}
					IfInString,NewUserFull,Offline
					{
						Run,autohotkey.exe "%A_ScriptDir%\toaster.ahk" "%NickName% has signed off"
						Sleep,50
					}
				}
			}
			;Else
			;Msgbox,Negative %NewUser% - %A_LoopField%
		}
	}
}
OldUsers =
Users =
FirstReload = 0
SetTimer,Reload,On
Return

Select:
ListView:
If (A_GuiEvent = "DoubleClick") (A_GuiEvent = "Normal")
if A_GuiEvent = DoubleClick
{
    LV_GetText(SelUsername, A_EventInfo)  ; Get the text from the row's first field.
	LV_GetText(SelKNo, A_EventInfo ,2) ; gets the K Number of user
	LV_GetText(Status, A_EventInfo ,3) ; Gets status of contact
	If Status = Offline
	{
		Gui,+OwnDialogs
		Msgbox,64,Contact Offline,%SelUsername% is currently offline. You are unable to chat to them.
		Exit
	} 
	CreateChatWindow(SelKNo,SelUsername)
}
Return

Window:
WinShow,%MessengerTitle%
WinActivate,%MessengerTitle%
Return

Incoming:
IfWinExist,Novell Message Popup
{
	WinHide,Novell Message Popup
	DetectHiddenWindows,On
	ControlGetText,IMessage,Edit1,Novell Message Popup
	WinClose,Novell Message Popup
	StringGetPos,IMessageTrim,IMessage,`n,L3
	IMessageTrim := IMessageTrim + 7
	StringTrimLeft,IMessage,IMessage,%IMessageTrim%
	StringTrimRight,IMessage,IMessage,1
	StringGetPos,IKnoTrim,Imessage,[
	StringLeft,IKNo,IMessage,%IKNoTrim%
	StringGetPos,IMessageTrim,IMessage,]
	IMessageTrim := IMessageTrim + 2
	StringTrimLeft,IMessage,IMessage,%IMessageTrim%
	IUsername := GetUserName(IKNo,"0")
	IGuiNo := CreateChatWindow(IKNo,IUsername)
	Gui,%IGuiNo%: Default
	LV_Add(1,IUsername A_Space "Says:", IMessage)
	SetTitleMatchMode,2
	IfWinNotActive,- Chat,%IKno%
		Run,autohotkey.exe "%A_ScriptDir%\toaster.ahk" "Message From: %IUsername%"
	SetTimer,GuiFlash,500
}
Return

GuiFlash:
Gui,%IGuiNo%: Default
GuiControlGet,FKNo,,Static1
SetTitleMatchMode,2
IfWinActive,- Chat,%FKNo%
{
	GuiFlashCount = 0
	SetTimer,GuiFlash,Off
}
GuiFlashCount++
If GuiFlashCount = 1
	FlashGuiNo := IGuiNo
Gui, %FlashGuiNo%: Flash
If GuiFlashCount > 6
{
	GuiFlashCount = 0
	SetTimer,GuiFlash,Off
}
Return

Send:
ControlGetText,SendKNo,Static1,A
GuiControlGet,Message,,Edit1
If Message =
	Exit
Run,autohotkey.exe "%A_ScriptDir%\Novell Messenger Send.ahk" "%SendKNo%" "%Message%"
GuiControl,Text,Edit1,
LV_Add(1,"You Say:", Message)
Return

CreateChatWindow(Kno,Username)
{
	DetectHiddenText,On
	DetectHiddenWindows,On
	SetTitleMatchMode,3
	IfWinExist,%Username% - Chat,%KNo%
	{
		ControlGetText,GuiNo,Static2,%Username% - Chat,%KNo%
		WinActivate,%Username% - Chat,%KNo%
		Return GuiNo
	}
	SetTitleMatchMode,2
	DetectHiddenWindows,Off
	Loop
	{
		If A_Index = 1
			Continue
		If A_Index > 99
		{
			Gui,1: +OwnDialogs
			Msgbox,16,Novell Messenger Error,Unable to create chat window. There are already too many open, please close some.
			Exit
		}
		Gui, %A_Index%: Default
		GuiControlGet,GetGuiNo,,Static2
		If GetGuiNo =
		{
			GuiNo = %A_Index%
			Break
		}
	}
	Gui,%GuiNo%: Default
	Gui,Add,ListView,x10 y10 w400 h300 -Hdr +NoSortHdr -LV0x10 -Multi gLVEvent,User|Message
	LV_ModifyCol(1,80)
	LV_ModifyCol(2,316)
	Gui,Add,Text,+Hidden,%KNo%
	Gui,Add,Text,+Hidden,%GuiNo%
	Gui,Add,Edit,x10 y320 h45 w320 -0x1000,
	Gui,Add,Button,x340 y320 h45 w70 Default gSend,&Send
	Gui,Show,xcenter ycenter h375 w420,%Username% - Chat
	GuiControl,Focus,Edit1
	Return GuiNo
}


GetUsername(KNo,ErrorReturn) ;Errorlevels = (NoInput,NoMatch,NoUserFile,MatchNoName)
{
	If KNo =
	{
		Error = NoInput
		Goto,ErrorReturn ; Returns if passed blank value
	}
	IfNotExist,%A_ScriptDir%\Users CSV.txt
	{
		Error = NoUserFile
		Goto,ErrorReturn ; Returns if Users CSV.txt not found
	}
	Loop,Read,%A_ScriptDir%\Users CSV.txt
	{
		TrimKNo := RegExMatch(A_LoopReadLine,",")
		TrimKNo--
		StringLeft,KNoSearch,A_LoopReadLine,%TrimKNo%
		If KNoSearch = %KNo%
		{
			Line := A_LoopReadLine
			Break
		}
	}
	NickNameTrim := RegExMatch(Line,",")
	StringTrimLeft,NickName,Line,%NickNameTrim%
	If Line <>
	{
		If NickName =
		{
			Error = MatchNoName
			Gosub,ErrorReturn ; Returns if a match was in list but user had no nickname
		}
		Else
			Return NickName ; Returns successful result
	}
	Else
	{
		Error = NoMatch 
		Gosub,ErrorReturn ; Returns if no match found
	}
	
	ErrorReturn:
	If ErrorReturn = 0
		Return %KNo%
	Else
		Return %Error%
	Return
}

WM_SHOWWINDOW( wParam, lParam ) 
{
	if ( wParam=0 and A_Gui <> 1 )
    Gui, %A_Gui%:Destroy
}

LVEvent:
if A_GuiEvent = DoubleClick
{
  LV_GetText(SelName, A_EventInfo ,1) ; gets the K Number of user
  LV_GetText(SelMessage, A_EventInfo ,2) ; gets the K Number of user
  Gui,+OwnDialogs
  Msgbox,,Message,%SelName% %SelMessage%
}
Return


!^+x::
GuiClose:
Exit:
Critical
SetTimer,Reload,Off
DetectHiddenWindows,On
WinClose,Send Message <main>,Send message to the selected users or groups.
WinClose,Novell Send Message <main>,Select a server to see a list of users and groups
OnMessage( 0x18, "") 
IniWrite,0,Novell Messenger.ini,Send,Instance
ExitApp