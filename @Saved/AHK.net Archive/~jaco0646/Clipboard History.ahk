#SingleInstance force
#Persistent
#NoEnv
SetBatchLines, -1
SetTitleMatchMode, slow
GroupAdd, AHK,,http://www.autohotkey.com/forum/posting.php
GroupAdd, AHK,,http://www.autohotkey.com/forum/privmsg.php
;
TypeOfTitle= 1	;1|2	1=Title of the URL's Window.
;			2=URL text between "www" and ".com"
;
SavePath= %A_Desktop%	;Place to save Clipboard histories.
;
;
;Win+C shows the Clipboard History.
;Double-click a history item to put it on the clipboard.
;
;
Menu, Tray, Icon, clipbrd.exe
Menu, Tray, Tip, Clipboard History
Menu, Tray, Add, Show History, ShowHistory
Menu, Tray, Default, Show History
Menu, Tray, NoStandard
Menu, Tray, Standard
return

OnClipboardChange:
If A_EventInfo = 1
 clipHistory := clipboard "?" clipHistory
;----------AHK forum link helper----------;
WinGetActiveTitle, title
If (SubStr(clipboard,1,7) != "http://") AND (title != "AutoHotkey Help")
 return
WinWaitActive, ahk_group AHK,,5
If !(ErrorLevel)
{
 If title = AutoHotkey Help
 {
  clipboard = [quote="AHK Help File"]%clipboard%[/quote]
  return
 }
 If TypeOfTitle = 1
 {
  If title contains - Windows Internet Explorer
   StringTrimRight, title, title, 28
 }
 Else If TypeOfTitle = 2
 {
  StringSplit, URL, clipboard, .
  StringReplace, URL1, URL1, http://
  title := InStr(clipboard,"www.")=8 ? URL2:URL1
 }
 StringReplace, clipboard, clipboard, (, `%28, All
 StringReplace, clipboard, clipboard, ), `%29, All
 If pos := InStr(clipboard,"&highlight=")
  clipboard := SubStr(clipboard,1,(pos-1))
 clipboard = [URL=%clipboard%]%title%[/URL]
}
;----------AHK forum link helper----------;
return

#c::
ShowHistory:
temp=
Loop, Parse, clipHistory, ?
{
 If !(A_LoopField)
  continue
 newline := A_LoopField
 duplicate = 0
 Loop, Parse, temp, ?
 {
  oldline := A_LoopField
  If (oldline = newline)
  {
   duplicate = 1
   break
  }
 }
 If !(duplicate)
  temp .= newline "?"
}
clipHistory := temp
Gui, +LastFoundExist
IfWinExist
{
 GuiControl,,listItem, ?%clipHistory%
 WinActivate
 return
}
Gui, +Delimiter?
Gui, Add, ListBox, +HScroll r25 w500 vlistItem gClick, %clipHistory%
Gui, Add, Button, gSave, Save History
Gui, Add, Button, gClear x+15, Clear History
Gui, Show,,Clipboard History
return

GuiClose:
GuiEscape:
Gui, Destroy
return

Click:
If A_GuiEvent != DoubleClick
 return
Gui, Submit
clipboard := listItem
Gui, Destroy
return

Save:
IfNotExist, %SavePath%
{
 Gui, +OwnDialogs
 MsgBox,48,Clipboard History
 , SavePath does not exist:`n%SavePath%
 return
}
IfExist %SavePath%\ClipHistory.txt
 Loop
  IfNotExist, %SavePath%\ClipHistory[%A_Index%].txt
  {
   num = [%A_Index%]
   break
  }
Else num=
Loop, Parse, clipHistory, ?
 FileAppend, %A_LoopField%`r`n, %SavePath%\ClipHistory%num%.txt
If !(ErrorLevel)
{
 Gui, +OwnDialogs
 MsgBox,64,Clipboard History
 , Saved to:`n%SavePath%\ClipHistory%num%.txt
}
return

Clear:
clipHistory=
Gui, Destroy
return