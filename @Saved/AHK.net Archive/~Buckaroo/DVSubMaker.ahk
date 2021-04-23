; DVSubMaker.ahk
; 2008-11-01
; This program is third party, and to state the principal author:
; This program is free. Use it on Your own risk.
;
#SingleInstance force
#Persistent
#NoEnv
#NoTrayIcon

NULL:=0
WS_EX_ACCEPTFILES:=0x00000010
WM_SETTEXT:=0x000C
WM_GETTEXT:=0x000D

TTabSheet1_Caption:="1. Get DV  DateTime"
TTabSheet2_Caption:="2. Make Subs"

TTabSheet1_TFilenameEdit_1:="" ; WS_EX_ACCEPTFILES
TTabSheet1_TFilenameEdit_2:=""
TTabSheet1_TBitBtn_Start:=""
TTabSheet2_TFilenameEdit_1:="" ; WS_EX_ACCEPTFILES
TTabSheet2_TFilenameEdit_2:=""
TTabSheet2_TBitBtn_Start:=""

;DVSubMaker_dwProcessId:=0
;DVSubMaker_dwThreadId:=0
TPageControl:=0
TTabSheet1:=0
TTabSheet2:=0

TextGuiDropFiles:="`r`nApply preferences to DV Sub Maker, then`r`nDrag and Drop DV avi files here.`r`n"

Gui 1:+LastFound
Gui1:=WinExist()

Gui,Show,Hide,DV Sub Maker.AHK batch utility

Gui,Font,bold
Gui,Add,Text,xCenter y0 w256 +BackgroundTrans +Border -Wrap +Center vTextGuiDropFiles,%TextGuiDropFiles%

Gui 1:Margin,0,0
Gui 1:Show,AutoSize Hide
Gui 1:Show,xCenter yCenter Hide
Gui 1:+AlwaysOnTop
Gui 1:Show
return

GuiEscape:
GuiClose:
ExitApp,0

GuiDropFiles:
;
GuiControl,,TextGuiDropFiles,`r`nGenerating Chapter Frame Indexes`r`n
dwTotalFrames:=0
Chapters:=0
txt:=""
LastField:=""
FileList=%A_GuiEvent%
Sort,FileList
Loop,Parse,FileList,`n
{
	if(!RegExMatch(A_LoopField,"i)^(?:\s*)?(?:[""]*)?.*?[.]avi(?:[""]*)?(?:\s*)?$"))
		Continue
	LastField:=A_LoopField
	FileRead,OutputVar,*m88 %LastField%
	if(ErrorLevel)
		Break
	Chapters++
	dwTotalFrames%Chapters%:=NumGet(OutputVar,48,"UInt")
	Continue
}
if(!ErrorLevel)
{
	Loop,%Chapters%
	{
		if(A_Index==Chapters)
		{
			Chapters:=A_Index-1
			Break
		}
		dwTotalFrames+=dwTotalFrames%A_Index%
		txt.=dwTotalFrames . "`r`n"
	}
	if(Chapters)
	{
		sTmp:=LastField
		sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(.*[\/\\])?.*?(?:[""]*)?(?:\s*)?$","$1Chapters_FrameIndexed." . A_Now . ".txt")
		FileDelete,%sTmp%
		FileAppend,%txt%,%sTmp%
	}
}
GuiControl,,TextGuiDropFiles,%TextGuiDropFiles%
;
SetTitleMatchMode,3
DetectHiddenWindows,On
if(DVSubMaker:=WinExist("DV Sub Maker ahk_class TfmMain",TTabSheet1_Caption))
{
	if not EnumWindowsProc
		EnumWindowsProc:=RegisterCallback("EnumWindowsProc","Fast")
	
	if not EnumChildProc
		EnumChildProc:=RegisterCallback("EnumChildProc","Fast")
	
	EnumChildWindows(DVSubMaker,EnumChildProc,0)
	
	DllCall("GetWindowThreadProcessId","UInt",DVSubMaker,"UInt",&DVSubMaker)
	
	if(TPageControl && TTabSheet1 && TTabSheet2)
	{
		EnumChildWindows(TTabSheet1,EnumChildProc,1)
		EnumChildWindows(TTabSheet2,EnumChildProc,2)
		
		Loop,Parse,A_GuiEvent,`n
		{
			SendMessage,WM_SETTEXT,0,0,,ahk_id %TTabSheet2_TFilenameEdit_1%
			SendMessage,WM_SETTEXT,0,0,,ahk_id %TTabSheet2_TFilenameEdit_2%
			
			sTmp=%A_LoopField%
			sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(.*?)(?:[""]*)?(?:\s*)?$","""$1""")
			sAVI:=sTmp
			SendMessage,WM_SETTEXT,0,&sAVI,,ahk_id %TTabSheet1_TFilenameEdit_1%
			
			sTmp=%A_LoopField%
			sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(?:(.*)[.].*?|(.*?))(?:[""]*)?(?:\s*)?$","""$1$2.dvdt""")
			sDVDT:=sTmp
			SendMessage,WM_SETTEXT,0,&sDVDT,,ahk_id %TTabSheet1_TFilenameEdit_2%
			
			sSub:=""
			
			sTmp=%A_LoopField%
			sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(?:.*[\/\\])?(?:(.*)[.].*?|(.*?))(?:[""]*)?(?:\s*)?$","""$1$2""")
			sName:=sTmp
			
			Loop
			{
				if(ModalDialogBlock())
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`nMODAL...WAITING`r`n
					Sleep,1000
				}
				else
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`n%TTabSheet1_Caption%`r`n
					ControlSend,,{Left}{Left},ahk_id %TPageControl%
					Break
				}
			}
			{
				sDVDT_:=sDVDT
				sDVDT_:=RegExReplace(sDVDT_,"^(?:\s*)?(?:[""]*)(.*?)(?:[""]*)?(?:\s*)?$","$1")
				sTmp:=sDVDT_
				sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(?:(.*)([.].*?)|(.*?))(?:[""]*)?(?:\s*)?$","$1$2$3.bak")
				FileMove,%sDVDT_%,%sTmp%,1
			}
			SetControlDelay -1
			ControlClick,,ahk_id %TTabSheet1_TBitBtn_Start%,,,,NA
			RequestedCapacity:=1024
			sTmp:=sDVDT
			VarSetCapacity(sDVDT,RequestedCapacity,0)
			VarSetCapacity(sSub,RequestedCapacity,0)
			Loop
			{
				if(DllCall("IsWindowEnabled","UInt",TTabSheet1_TBitBtn_Start))
				{
					SendMessage,WM_GETTEXT,RequestedCapacity,&sDVDT,,ahk_id %TTabSheet2_TFilenameEdit_1%
					SendMessage,WM_GETTEXT,RequestedCapacity,&sSub,,ahk_id %TTabSheet2_TFilenameEdit_2%
					
					if(sDVDT==sTmp && sSub)
					{
						Break
					}
				}
				else if(ModalDialogBlock())
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`nClick Start if automation needs resuming.`r`n
				}
				
				Sleep,250
			}
			
			Loop
			{
				if(ModalDialogBlock())
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`nMODAL...WAITING`r`n
					Sleep,1000
				}
				else
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`n%TTabSheet2_Caption%`r`n
					ControlSend,,{Left}{Left}{Right},ahk_id %TPageControl%
					Break
				}
			}
			sSub:=RegExReplace(sSub,"^(?:\s*)?(?:[""]*)(.*?)(?:[""]*)?(?:\s*)?$","$1")
			sTmp:=sSub
			sTmp:=RegExReplace(sTmp,"^(?:\s*)?(?:[""]*)?(?:(.*)([.].*?)|(.*?))(?:[""]*)?(?:\s*)?$","$1$2$3.bak")
			FileMove,%sSub%,%sTmp%,1
			FileMove:=ErrorLevel ? false:true
			FileExist:=FileExist(sSub)
			SetControlDelay -1
			ControlClick,,ahk_id %TTabSheet2_TBitBtn_Start%,,,,NA
			if(!FileMove||FileExist)
			{
				Sleep,3000
			}
			Loop
			{
				if(FileExist(sSub))
				{
					Break
				}
				else if(ModalDialogBlock())
				{
					GuiControl,,TextGuiDropFiles,`r`n%sName%`r`nClick Start if automation needs resuming.`r`n
				}
			}
		}
		
		GuiControl,,TextGuiDropFiles,%TextGuiDropFiles%
		
		return
	}
}

MsgBox,270352,,Cannot begin exporting subtitles.`r`nNo (supported) DV Sub Maker process found.
return

ModalDialogBlock()
{
	global
	
	return EnumWindows(EnumWindowsProc,NULL) ? false:true
}

EnumWindows(lpEnumFunc,lParam)
{
	global
	
	return DllCall("EnumWindows","UInt",lpEnumFunc,"UInt",lParam)
}

EnumWindowsProc(hwnd,lParam)
{
	global
	
	DetectHiddenWindows,On
	WinGetTitle,Title,ahk_id %hwnd%
	WinGetClass,Class,ahk_id %hwnd%
	DetectHiddenWindows,Off
	
	dwProcessId:=0
	dwThreadId:=DllCall("GetWindowThreadProcessId","UInt",hwnd,"UInt",&dwProcessId)
	
	if(DVSubMaker==dwProcessId && DllCall("IsWindowVisible","UInt",hwnd))
	{
		if(Class && Class!="TfmMain" && Class!="TApplication")
		{
			return false
		}
	}
	
	return true
}

EnumChildWindows(hWndParent,lpEnumFunc,lParam)
{
	global
	
	return DllCall("EnumChildWindows","UInt",hWndParent,"UInt",lpEnumFunc,"UInt",lParam)
}

EnumChildProc(hwnd,lParam)
{
	global
	
	DetectHiddenWindows,On
	WinGetTitle,Title,ahk_id %hwnd%
	WinGetClass,Class,ahk_id %hwnd%
	WinGet,Style,Style,ahk_id %hwnd%
	WinGet,ExStyle,ExStyle,ahk_id %hwnd%
	DetectHiddenWindows,Off
	
	if(lParam==0)
	{
		if(Class=="TPageControl" && !(Style&(0x0008|0x0100)) && !(Style&(0x0002|0x0200)))
		{
			TPageControl:=hwnd
		}
		else if(Class=="TTabSheet")
		{
			if(Title==TTabSheet1_Caption)
			{
				TTabSheet1:=hwnd
			}
			else if(Title==TTabSheet2_Caption)
			{
				TTabSheet2:=hwnd
			}
		}
	}
	else if(Class=="TFilenameEdit" && (ExStyle & WS_EX_ACCEPTFILES))
	{
		TTabSheet%lParam%_TFilenameEdit_1:=hwnd
	}
	else if(Class=="TFilenameEdit" && !(ExStyle & WS_EX_ACCEPTFILES))
	{
		TTabSheet%lParam%_TFilenameEdit_2:=hwnd
	}
	else if(Class=="TBitBtn" && Title=="Start")
	{
		TTabSheet%lParam%_TBitBtn_Start:=hwnd
	}
	
	return true
}
