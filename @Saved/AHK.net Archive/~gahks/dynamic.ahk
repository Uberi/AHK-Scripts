; Created by Jonny, with thanks to Rajat for the parsing code.
execute(CmdLine)
{

   global r1,r2,r3,r4,r5,r6,r7

   StringGetPos, cPos, CmdLine, `,
   StringGetPos, sPos, CmdLine, %A_SPACE%
   
   IfGreater, sPos, 0
      IfLess, sPos, %cPos%
         cPos = %sPos%
   
   StringLeft, Command, CmdLine, %cPos%
   cPos ++
   StringTrimLeft, CmdLine, CmdLine, %cPos%
   CmdLine = %CmdLine%
   
   IfEqual, Command,
      Command = %CmdLine%
   
   Loop, Parse, CmdLine, `,, %A_Space%%A_Tab%
      P%A_Index% = %A_LOOPFIELD%

   if command not in
(Join
BlockInput,Control,ControlClick,ControlFocus,
ControlGet,ControlGetFocus,ControlGetPos,ControlGetText,
ControlMove,ControlSend,ControlSendRaw,ControlSetText,
DetectHiddenText,DetectHiddenWindows,Drive,DriveGet,
DriveSpaceFree,EnvAdd,EnvDiv,EnvMult,EnvSet,EnvSub,EnvUpdate,
ExitApp,FileAppend,FileCopy,FileCopyDir,FileCreateDir,
FileCreateShortcut,FileDelete,FileGetAttrib,FileGetShortcut,
FileGetSize,FileGetTime,FileGetVersion,FileMove,FileMoveDir,
FileRead,FileReadLine,FileRecycle,FileRecycleEmpty,FileRemoveDir,
FileSelectFile,FileSelectFolder,FileSetAttrib,FileSetTime,
GetKeyState,GroupActivate,GroupAdd,GroupClose,GroupDeactivate,
GuiControlGet,ImageSearch,IniDelete,IniRead,IniWrite,
KeyHistory,ListHotkeys,ListLines,ListVars,Menu,MouseClick,
MouseClickDrag,MouseGetPos,MouseMove,OnExit,
PixelGetColor,PixelSearch,PostMessage,Process,Progress,Random,
RegDelete,RegRead,RegWrite,Reload,Run,RunAs,Send,SendRaw,
SendMessage,SetCapslockState,SetNumlockState,SetScrollLockState,SetWinDelay,
Shutdown,Sleep,Sort,SoundBeep,SoundGet,SoundGetWaveVolume,SoundPlay,SoundSet,
SoundSetWaveVolume,SplitPath,StatusBarGetText,StringGetPos,
StringLeft,StringLen,StringLower,StringMid,StringReplace,StringRight,
StringSplit,StringTrimLeft,StringTrimRight,StringUpper,Suspend,
SysGet,ToolTip,Transform,TrayTip,URLDownloadToFile,
WinActivate,WinActivateBottom,WinClose,WinGetActiveStats,
WinGetActiveTitle,WinGetClass,WinGet,WinGetPos,WinGetText,
WinGetTitle,WinHide,WinKill,WinMaximize,WinMenuSelectItem,
WinMinimize,WinMinimizeAll,WinMinimizeAllUndo,WinMove,WinRestore,
WinSet,WinSetTitle,WinShow
)
      return 0
   goto,%command% 

BlockInput:
blockinput,%p1%
return

Control:
control,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%
return

ControlClick:
controlclick,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%
return

ControlFocus:
controlfocus,%p1%,%p2%,%p3%,%p4%,%p5%
return

ControlGet:
controlget,ov,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%
return ov

ControlGetFocus:
controlgetfocus,ov,%p1%,%p2%,%p3%,%p4%
return ov

ControlGetPos:
controlgetpos,r1,r2,r3,r4,%p1%,%p2%,%p3%,%p4%,%p5%
return

ControlGetText:
controlgettext,ov,%p1%,%p2%,%p3%,%p4%,%p5%
return ov

ControlMove:
controlmove,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%,%p9%
return

ControlSend:
controlsend,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%
return

ControlSendRaw:
controlsendraw,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%
return

ControlSetText:
controlsettext,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%
return

DetectHiddenText:
detecthiddentext,%p1%
return

DetectHiddenWindows:
detecthiddenwindows,%p1%
return

Drive:
drive,%p1%,%p2%,%p3%
return

DriveGet:
driveget,ov,%p1%,%p2%
return ov

DriveSpaceFree:
drivespacefree,ov,%p1%
return ov

EnvAdd:
envadd,%p1%,%p2%,%p3%
return

EnvDiv:
envdiv,%p1%,%p2%
return

EnvMult:
envmult,%p1%,%p2%
return

EnvSet:
envset,%p1%,%p2%
return

EnvSub:
envsub,%p1%,%p2%,%p3%
return

EnvUpdate:
envupdate
return

ExitApp:
exitapp
return

FileAppend:
fileappend,%p1%,%p2%
return

FileCopy:
filecopy,%p1%,%p2%,%p3%
return

FileCopyDir:
filecopydir,%p1%,%p2%,%p3%
return

FileCreateDir:
filecreatedir,%p1%
return

FileCreateShortcut:
filecreateshortcut,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%,%p9%
return

FileDelete:
filedelete,%p1%
return

FileGetAttrib:
filegetattrib,ov,%p1%
return ov

FileGetShortcut:
filegetshortcut,%p1%,r1,r2,r3,r4,r5,r6,r7
return

FileGetSize:
filegetsize,ov,%p1%,%p2%
return ov

FileGetTime:
filegettime,ov,%p1%,%p2%
return ov

FileGetVersion:
filegetversion,ov,%p1%
return ov

FileMove:
filemove,%p1%,%p2%,%p3%
return

FileMoveDir:
filemovedir,%p1%,%p2%,%p3%
return

FileRead:
fileread,ov,%p1%
return ov

FileReadLine:
filereadline,ov,%p1%,%p2%
return ov

FileRecycle:
filerecycle,%p1%
return

FileRecycleEmpty:
filerecycleempty,%p1%
return

FileRemoveDir:
fileremovedir,%p1%,%p2%
return

FileSelectFile:
fileselectfile,ov,%p1%,%p2%,%p3%,%p4%
return ov

FileSelectFolder:
fileselectfolder,ov,%p1%,%p2%,%p3%
return ov

FileSetAttrib:
filesetattrib,%p1%,%p2%,%p3%,%p4%
return

FileSetTime:
filesettime,%p1%,%p2%,%p3%,%p4%,%p5%
return

GetKeyState:
getkeystate,ov,%p1%,%p2%
return ov

GroupActivate:
groupactivate,%p1%,%p2%
return

GroupAdd:
groupadd,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%
return

GroupClose:
groupclose,%p1%,%p2%
return

GroupDeactivate:
groupdeactivate,%p1%,%p2%
return

GuiControlGet:
guicontrolget,ov,%p1%,%p2%,%p3%
return ov

ImageSearch:
imagesearch,r1,r2,%p1%,%p2%,%p3%,%p4%,%p5%
return

IniDelete:
inidelete,%p1%,%p2%,%p3%
return

IniRead:
iniread,ov,%p1%,%p2%,%p3%,%p4%
return ov

IniWrite:
iniwrite,%p1%,%p2%,%p3%,%p4%
return

KeyHistory:
keyhistory
return

ListHotkeys:
listhotkeys
return

ListLines:
listlines
return

ListVars:
listvars
return

Menu:
menu,%p1%,%p2%,%p3%,%p4%,%p5%
return

MouseClick:
mouseclick,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%
return

MouseClickDrag:
mouseclickdrag,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%
return

MouseGetPos:
mousegetpos,r1,r2,r3,r4,%p1%
return

MouseMove:
mousemove,%p1%,%p2%,%p3%,%p4%
return

OnExit:
onexit,%p1%
return

PixelGetColor:
pixelgetcolor,ov,%p1%,%p2%,%p3%
return ov

PixelSearch:
pixelsearch,r1,r2,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%
return

PostMessage:
postmessage,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%
return

Process:
process,%p1%,%p2%,%p3%
return

Progress:
progress,%p1%,%p2%,%p3%,%p4%,%p5%
return

Random:
random,ov,%p1%,%p2%
return ov

RegDelete:
regdelete,%p1%,%p2%,%p3%
return

RegRead:
regread,ov,%p1%,%p2%,%p3%
return ov

RegWrite:
regwrite,%p1%,%p2%,%p3%,%p4%,%p5%
return

Reload:
reload
return

Run:
run,%p1%,%p2%,%p3%,ov
return ov

RunAs:
runas,%p1%,%p2%,%p3%
return

Send:
Send, %p1%
return

SendRaw:
sendraw,%p1%
return

SendMessage:
sendmessage,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%
return errorlevel

SetCapslockState:
setcapslockstate,%p1%
return

SetNumlockState:
setnumlockstate,%p1%
return

SetScrollLockState:
setscrolllockstate,%p1%
return

Shutdown:
shutdown,%p1%
return

Sleep:
sleep,%p1%
return

Sort:
sort,%p1%,%p2%
return

SoundBeep:
soundbeep,%p1%,%p2%
return

SoundGet:
soundget,ov,%p1%,%p2%,%p3%
return ov

SoundGetWaveVolume:
soundgetwavevolume,ov,%p1%
return ov

SoundPlay:
soundplay,%p1%,%p2%
return

SoundSet:
soundset,%p1%,%p2%,%p3%,%p4%
return

SoundSetWaveVolume:
soundsetwavevolume,%p1%,%p2%
return

SplitPath:
splitpath,%p1%,r1,r2,r3,r4,r5
return

StatusBarGetText:
statusbargettext,ov,%p1%,%p2%,%p3%,%p4%,%p5%
return ov

StringGetPos:
stringgetpos,ov,%p1%,%p2%,%p3%,%p4%
return ov

StringLeft:
stringleft,ov,%p1%,%p2%
return ov

StringLen:
stringlen,ov,%p1%
return ov

StringLower:
stringlower,ov,%p1%,%p2%
return

StringMid:
stringmid,ov,%p1%,%p2%,%p3%,%p4%
return ov

StringReplace:
stringreplace,ov,%p1%,%p2%,%p3%,%p4%
return ov

StringRight:
stringright,ov,%p1%,%p2%
return ov

StringSplit:
stringsplit,%p1%,%p2%,%p3%,%p4%
return

StringTrimLeft:
stringtrimleft,ov,%p1%,%p2%
return ov

StringTrimRight:
stringtrimright,ov,%p1%,%p2%
return ov

StringUpper:
stringupper,ov,%p1%,%p2%
return ov

SysGet:
sysget,ov,%p1%,%p2%
return ov

ToolTip:
tooltip,%p1%,%p2%,%p3%,%p4%
return

Transform:
transform,ov,%p1%,%p2%,%p3%
return ov

TrayTip:
traytip,%p1%,%p2%,%p3%,%p4%
return

URLDownloadToFile:
urldownloadtofile,%p1%,%p2%
return

WinActivate:
winactivate,%p1%,%p2%,%p3%,%p4%
return

WinActivateBottom:
winactivatebottom,%p1%,%p2%,%p3%,%p4%
return

WinClose:
winclose,%p1%,%p2%,%p3%,%p4%,%p5%
return

WinGetActiveStats:
wingetactivestats,r1,r2,r3,r4,r5
return

WinGetActiveTitle:
wingetactivetitle,ov
return ov

WinGetClass:
wingetclass,ov,%p1%,%p2%,%p3%,%p4%
return ov

WinGet:
winget,ov,%p1%,%p2%,%p3%,%p4%,%p5%
return ov

WinGetPos:
wingetpos,r1,r2,r3,r4,%p1%,%p2%,%p3%,%p4%
return

WinGetText:
wingettext,ov,%p1%,%p2%,%p3%,%p4%
return ov

WinGetTitle:
wingettitle,ov,%p1%,%p2%,%p3%,%p4%
return ov

WinHide:
winhide,%p1%,%p2%,%p3%,%p4%
return

WinKill:
winkill,%p1%,%p2%,%p3%,%p4%,%p5%
return

WinMaximize:
winmaximize,%p1%,%p2%,%p3%,%p4%
return

WinMenuSelectItem:
winmenuselectitem,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%,%p9%,%p10%,%p11%
return

WinMinimize:
winminimize,%p1%,%p2%,%p3%,%p4%
return

WinMinimizeAll:
winminimizeall
return

WinMinimizeAllUndo:
winminimizeallundo
return

WinMove:
if p1 is integer
{
   if p2 is integer
      winmove,%p1%,%p2%
   else
      winmove,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%
}
else
   winmove,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%,%p7%,%p8%
return

WinRestore:
winrestore,%p1%,%p2%,%p3%,%p4%
return

WinSet:
winset,%p1%,%p2%,%p3%,%p4%,%p5%,%p6%
return

WinSetTitle:
winsettitle,%p1%,%p2%,%p3%,%p4%,%p5%
return

WinShow:
winshow,%p1%,%p2%,%p3%,%p4%
return

suspend,permit

}