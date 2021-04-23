#SingleInstance,Force
#NoTrayIcon
SetBatchLines,-1
SetFormat,Float,0.2

Gui, +AlwaysOnTop ;  -caption  -ToolWindow -SysMenu
;Gui, +Resize
Gui, Add, GroupBox, x6 y7 w460 h390 vGroupBox1, 1. Drop files or directories in the window below
Gui, Add, Text, x16 y30 w200 h20 vTextFilter, Filter (applies only to dropped directories)
Gui, Add, Edit, x216 y27 w90 h20 vEditFilter,*.exe
Gui, Add, Button, x306 y27 w20 h20 vButtonHelpFilter GBUTTONHELPFILTER, ?
Gui, Add, Button, x336 y27 w60 h20 GBUTTONCLEARLIST,Clear list
Gui, Font, underline
Gui, Add, Text, x408 y30 cBlue gLaunchUPXWeb,Get UPX
Gui, Font, norm
;Gui, Add, Button, x405 y27 w50 h20 GBUTTONSTOP,Stop
Gui, Add, ListView, x16 y57 w440 h330 vListFiles GLISTFILES Checked Count100 Grid,UPX|Name|Size (kB)|Compression
Gui, Add, GroupBox, x6 y397 w460 h70 vGroupBox2, 2. Options
Gui, Add, Radio, x16 y417 w120 h20 vRadioCompress GRADIOCOMPRESS, Compress with level:
	GuiControl,, RadioCompress,1
Gui, Add, Radio, x16 y437 w90 h20 vRadioDecompress GRADIODECOMPRESS, Decompress
Gui, Add, Checkbox, x226 y417 w200 h20 vCheckboxForce,Force compression of suspicious files
Gui, Add, Checkbox, x226 y437 w140 h20 vCheckboxBackup,Keep backup files
Gui, Add, DropDownList, x136 y417 w60 h20 R9 vDropdownCompressionLevel,1|2|3|4|5|6|7|8|9||--best
Gui, Add, GroupBox, x6 y467 w460 h50 vGroupBox3, 3. More options and process
Gui, Add, Edit, x16 y487 w350 h20 vEditMoreOptions,
Gui, Add, Button, x366 y487 w20 h20 vButtonHelpMoreOptions GBUTTONHELPMOREOPTIONS, ?
Gui, Add, Button, x396 y487 w60 h20 vButtonProcess GBUTTONPROCESS,Process
Gui, Add, StatusBar,, Number of files in the list: 0
SB_SetParts(160, 220)
SB_SetIcon("Shell32.dll",110,3)
SB_SetText("UPX idle",3)
GoSub, RESETSUMSIZE
Gui, Show, x575 y29 h540 w473, Advanced UPX GUI compile 7/21/2006 7:58AM

includefolders=0
startfolder=
CreationTime=
ModifTime=
InputString=
Comment=None
Filter=*.exe
IsOk=0
UPXCommand=upx.exe
FileFullPath=
transform, PercentSign, chr, 37
IfNotExist, upx.exe
{
	Gui,-AlwaysOnTop
  MsgBox,48,WARNING!,Please copy upx.exe in the UPX_GUI.exe directory, 5
	Gui,+AlwaysOnTop
}
Return



GuiDropFiles:
;A_GuiControlEvent
GuiControlGet, Filter, , EditFilter,
GuiControl,disable,ButtonProcess
GuiControl,disable,RadioDecompress
;msgbox The filter is now set to %Filter%
LV_ModifyCol(1,"AutoHdr")
LV_ModifyCol(2,"AutoHdr")
LV_ModifyCol(3,"AutoHdr Float")
LV_ModifyCol(4,"AutoHdr")
Loop, Parse, A_GuiControlEvent, `n
{
  FileGetAttrib, Attributes, %A_LoopField%
  IfInString, Attributes, D
  {
    startfolder=%A_LoopField%
    Gosub, COUNT
		continue
  }
	else
	  InputString=%A_LoopField%
  FileGetSize, SizeAscii, %A_LoopField%, K
  size:=SizeAscii/1.0
  InputString=%A_LoopField%
  Gosub, CHECKFILECOMPRESSION
  ifequal, Comment, None
    LV_Add("Check","",A_LoopField,size,Comment)
	else
	  LV_Add("","",A_LoopField,size,Comment)
	GoSub, UPDATELISTVIEW
}
GuiControl,enable,ButtonProcess
GuiControl,enable,RadioDecompress
LV_ModifyCol(1,"AutoHdr")
LV_ModifyCol(2,"AutoHdr")
LV_ModifyCol(3,"AutoHdr Float")
LV_ModifyCol(4,"AutoHdr")
LV_ModifyCol(3,"SortDesc")
Return



COUNT:
Loop,%startfolder%\%Filter%,1,1
{
  InputString=%a_loopfilefullpath%
  size:=A_LoopFileSizekB/1.0
  InputString=%a_loopfilefullpath%
  Gosub, CHECKFILECOMPRESSION
  ifequal, Comment, None
    LV_Add("Check","",a_loopfilefullpath,size,Comment)
	else
	  LV_Add("","",a_loopfilefullpath,size,Comment)
	GoSub, UPDATELISTVIEW
}
Return



UPDATELISTVIEW:
LV_Modify(LV_GetCount(),"Vis")
SB_SetText("Number of files in the list: " LV_GetCount(),1)
SumSizeAllFiles+=size/1024
String=Size of the files: %SumSizeAllFiles% MB
SB_SetText(String,2)
LV_ModifyCol(2,"AutoHdr")
Return



BROWSE:
Gui,-AlwaysOnTop
Gui,Submit,NoHide
FileSelectFolder,startfolder,*c:\
if ErrorLevel = 0
  Gosub,COUNT
Gui,+AlwaysOnTop
Return



BUTTONPROCESS:
Gui,-AlwaysOnTop
LV_GetText(Name,1,3)	;check if the list is filed
if Name =
{
  Gui,+AlwaysOnTop
  return
}
GuiControl,disable,ButtonProcess
FileFullPath=
Gosub, BUILDCOMMANDLINE
GuiControlGet, IsDecompressed,, RadioDecompress
Gain=0
Loop
{
  row:=LV_GetNext(0,"Checked")
  If row=0
    Break
  LV_Modify(row,"+Select")
  LV_Modify(row,"Vis")
  LV_GetText(Name,row,2)
  FileGetSize, OldSize, %Name%,
 	SB_SetIcon("Shell32.dll",138,3)
 	SB_SetText("UPX working",3)
  Command=%Command% "%Name%"
  LV_modify(row,"Col4","Processing...")
  runwait, %Command%,, hide
 	SB_SetIcon("Shell32.dll",110,3)
 	SB_SetText("UPX idle",3)
  FileGetSize, NewSize, %Name%,
  Gain+=(OldSize-NewSize)/(1024*1024)
  NewSizeKb:=NewSize/1024
  Ratio:=NewSize/OldSize*100
	Ratio=%Ratio%%PercentSign%
	GuiControlGet, OutputVar,, RadioDecompress
	ifequal OutputVar,0
		Ratio=%Ratio%    win32/pe
  if (NewSize >= OldSize)
  	Ratio=None
  LV_modify(row,"Col4",Ratio)
  LV_modify(row,"Col3",NewSizeKb)
  LV_Modify(row,"-Select")
  LV_modify(row,"-Check")
  ;LV_Delete(row)
	ifequal IsDecompressed,1
	{
		GainDisplay:=-Gain
		String=Loss after decompression: %GainDisplay% MB
	}
	else
		String=Gain after compression: %Gain% MB
	SB_SetText(String,2)
}
GuiControl,enable,ButtonProcess
Gui,+AlwaysOnTop
Return



LISTFILES:
If A_GuiEvent=DoubleClick
{
  Gui,-AlwaysOnTop
	LV_GetText(Name,1,3)
  if Name =
  {
    Gui,+AlwaysOnTop
    return
  }
  LV_GetText(folder,A_EventInfo,5)
  Run,Explorer.exe /e`,%folder%
}
Return



CHECKFILECOMPRESSION:
Comment=None
filedelete, %A_Temp%\DumpUPXInfo.bat
fileappend, %UPXCommand% -q -l "%InputString%", %A_Temp%\DumpUPXInfo.bat
RunWait, %A_Temp%\DumpUPXInfo.bat > %A_Temp%\upxgui.log,, hide
FileReadLine, Comment, %A_Temp%\upxgui.log, 9
ifnotequal, Comment, None
{
	StringGetPos, Position, Comment,  %A_Space%, R
	StringLeft, Comment, Comment, Position
	Comment=%Comment%
	loop 3
	{
		StringGetPos, Position, Comment,  %A_Space%, L
		Position:=strlen(Comment)-Position
		StringRight, Comment, Comment, Position
		Comment=%Comment%
	}
}
filedelete, %A_Temp%\DumpUPXInfo.bat
filedelete, %A_Temp%\upxgui.log
return



BUTTONCLEARLIST:
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
SB_SetText("Number of files in the list: 0")
GoSub, RESETSUMSIZE
return



RADIOCOMPRESS:
GuiControl,enable,DropdownCompressionLevel
GuiControl,enable,CheckboxForce
GuiControl,enable,CheckboxBackup
GuiControl,enable,EditMoreOptions
SB_SetText("",2)
Loop % LV_GetCount()
{
	LV_GetText(RetrievedText, A_Index,4)
	if InStr(RetrievedText, "None")
		LV_Modify(A_Index, "+Check")  ; Select each row whose first field contains the filter-text.
	else
		LV_Modify(A_Index, "-Check")
}
return



RADIODECOMPRESS:
GuiControl,disable,DropdownCompressionLevel
GuiControl,disable,CheckboxForce
GuiControl,disable,CheckboxBackup
GuiControl,disable,EditMoreOptions
SB_SetText("",2)
Loop % LV_GetCount()
{
	LV_GetText(RetrievedText, A_Index,4)
	if InStr(RetrievedText, "None")
		LV_Modify(A_Index, "-Check")  ; Select each row whose first field contains the filter-text.
	else
		LV_Modify(A_Index, "+Check")
}
return



BUTTONHELPFILTER:
Gui, -AlwaysOnTop
msgbox,, Filter, You may restrict the list by setting a file filter. For executables, use *.exe etc...
Gui, +AlwaysOnTop
return



BUTTONHELPMOREOPTIONS:
Gui, -AlwaysOnTop
msgbox,,More options...,Overlay options:`n  --overlay=copy      copy any extra data attached to the file [default]`n  --overlay=strip     strip any extra data attached to the file [DANGEROUS]`n  --overlay=skip      don't compress a file with an overlay`nOptions for win32/pe & rtm32/pe:`n  --compress-exports=0    do not compress the export section`n  --compress-exports=1    compress the export section [default]`n  --compress-icons=0      do not compress any icons`n  --compress-icons=1      compress all but the first icon`n  --compress-icons=2      compress all but the first icon directory [default]`n  --compress-resources=0  do not compress any resources at all`n  --keep-resource=list    do not compress resources specified by list`n  --strip-relocs=0        do not strip relocations`n  --strip-relocs=1        strip relocations [default]`n  --all-methods           try all available compression methods`n  --all-filters           try all available preprocessing filters`nOptions for atari/tos:`n  --all-methods       try all available compression methods`nOptions for djgpp2/coff:`n  --coff              produce COFF output [default: EXE]`n  --all-methods       try all available compression methods`n  --all-filters       try all available preprocessing filters`nOptions for dos/com:`n  --8086              make compressed com work on any 8086`n  --all-methods       try all available compression methods`n  --all-filters       try all available preprocessing filters`nOptions for dos/exe:`n  --8086              make compressed exe work on any 8086`n  --no-reloc          put no relocations in to the exe header`n  --all-methods       try all available compression methods`nOptions for dos/sys:`n  --8086              make compressed sys work on any 8086`n  --all-methods       try all available compression methods`n  --all-filters       try all available preprocessing filters`nOptions for ps1/exe:`n  --all-methods       try all available compression methods`n  --8-bit             uses 8 bit size compression [default: 32 bit]`n  --console-run       enables client/host transfer compatibility`n  --no-align          don't align to 2048 bytes [enables: --console-run]`nOptions for tmt/adam:`n  --all-methods       try all available compression methods`n  --all-filters       try all available preprocessing filters`nOptions for vmlinuz/386`n  --all-methods       try all available compression methods`n  --all-filters       try all available preprocessing filters`nOptions for watcom/le:`n  --le                produce LE output [default: EXE]
Gui, +AlwaysOnTop
return



BUILDCOMMANDLINE:
GuiControlGet, OutputVar,, RadioDecompress
ifequal OutputVar,1
{
	Command=%UPXCommand% -d
	return
}
GuiControlGet, CompressionLevel,,DropdownCompressionLevel, ; Retrieves the compression level
GuiControlGet, Force,,CheckboxForce,
GuiControlGet, Backup,,CheckboxBackup,
GuiControlGet, MoreOptions,,EditMoreOptions,
ifequal CompressionLevel, --best
	Command=%UPXCommand% %CompressionLevel%
else
	Command=%UPXCommand% -%CompressionLevel%
ifequal Force,1
	Command=%Command% -f
ifequal Backup,1
	Command=%Command% -k
Command=%Command% %MoreOptions%
Return



RESETSUMSIZE:
SumSizeAllFiles:=0
String=Size of the files: %SumSizeAllFiles% MB
SB_SetText(String,2)
return

LaunchUPXWeb:
Run http://upx.sourceforge.net/
return



GuiSize:
If A_EventInfo=1
  Return
GuiControl,Move,listview, % "W" . (A_GuiWidth - 10) . " H" . (A_GuiHeight - 77)
GuiControl,Move,box3, % "x" (A_GuiWidth - 350) "W" . (A_GuiWidth - 300) . " H" . (72)
Return



GuiClose:
ExitApp
