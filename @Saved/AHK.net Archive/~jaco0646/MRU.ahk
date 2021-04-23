#SingleInstance force
#NoTrayIcon
#NoEnv
EnvGet,UserProfile,UserProfile
EnvGet,SystemRoot,SystemRoot
SetBatchLines, -1

Gui,Add,ListView,r20 w750 Grid gClick
,Name|Path|Modified|Parameters
IL:=IL_Create(20)
LV_SetImageList(IL,1)
Loop,%UserProfile%\Recent\*.lnk
{
 FileGetTime,time
 FormatTime,time,%time%,h:mm:ss     MM/dd/yy
 FileGetShortcut,%A_LoopFileLongPath%,path,,params
 SplitPath,path,name,,ext
 RegRead,filetype,HKCR,.%ext%
 If ErrorLevel
  GoTo,OnError
 RegRead,iconpath,HKCR,%filetype%\DefaultIcon
 If ErrorLevel
 {
  RegRead,CLSID,HKCR,%filetype%\CLSID
  If ErrorLevel
   GoTo,OnError
  RegRead,iconpath,HKCR,CLSID\%CLSID%\DefaultIcon
  If ErrorLevel
   GoTo,OnError
 }
 StringSplit,icon,iconpath,`,
 If icon0=1
  icon2=0
 If icon1=`%SystemRoot`%\System32\shell32.dll
  icon2+=223
 StringReplace,icon1,icon1,`%SystemRoot`%,%SystemRoot%
 AddIcon:
 ILnum:=IL_Add(IL,icon1,icon2)
 LV_Add("Icon" ILnum,name,path,time,params)
 continue
 OnError:
  icon1=%SystemRoot%\system32\shell32.dll
  icon2=0
  GoTo,AddIcon
}
LV_ModifyCol()
LV_ModifyCol(4,0)

Gui,Show,,%UserProfile%\Recent
return
GuiClose:
ExitApp

Click:
If A_GuiEvent=DoubleClick
{
 LV_GetText(path,A_EventInfo,2)
 LV_GetText(params,A_EventInfo,4)
 If params
  params="%params%"
 SplitPath,path,,dir
 Run,%path% %params%,%dir%
}