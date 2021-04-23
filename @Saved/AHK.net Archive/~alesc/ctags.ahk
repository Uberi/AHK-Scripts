;----------------------------------------------------------------------
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         alesc
;
; Script Function:
;       Script enables ctags in PSPad editor.
;
;       What do you need: aleto.js, alemain.js, ctags.ahk, alecore.ahk
;       External needs: ctags ( http://ctags.sourceforge.net/ )
;       Not necesary: ramdisk ( http://www.mydigitallife.info/2007/05/27/free-ramdisk-for-windows-vista-xp-2000-and-2003-server/ )
;
;       How to install: 
;        - Copy javascripts to pspad\Script\JScript directory
;        - Set env.variable ALEPATH ( Path to ctags and map file...example: ALEPATH=R:\ )
;        - start ctags.ahk script
;
;       How to use:
;        - select something from everywhere ( dont need to be in PSPad and PSPad does not need to run )
;        - press the hotkey ( default: Win+a )
;
;       Description:
;         Script reads entire ctag file into memory and searches for file, line and details of the selected
;         item. If there is only one match this is written to map file and shortcut
;         is sent to PSPad. If multiple matches are found gui with list view is created and 
;         script waits for user to pick one. After the user chooses one match this is written to map
;         file and shortcut is sent to PSPad. If PSPad is not running or its window not active
;         script tries to run it or activate its window. After PSPad is up and running and it receives
;         the shortcut the script aleto.js is executed which reads the map file and tries to open/set focus 
;         the file and moves to line. Map file format: <file name> <line number>
;
;       About ctags file:
;         Ctag file should be created in special format and named allways ctags. See 'how to create ctag file'. 
;         Normally you can place ctag file on a disk but I prefer to keep it on a ramdisk which
;         shows some performance improvements. Note: I use this script on ctag file of 30MB+
;
;       How to create ctag file:
;         -f <fullpath>\ctags...where to create ctag file
;         --recurse=yes...recurse into directories ( not a must )
;         --fields=+n...adds line numbers ( must )
;         v:\src...path to sources
;         Example:
;         'ctags -f R:\ctags --recurse=yes --fields=+n v:\src'
;
;       Todo:
;         - move backward/forward
;         - code autocomplete
;---------------------------------------------------------------------- 

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include %A_ScriptDir%\alecore.ahk

; globals
;------------------------------------------------------

; shortcut for calling PSPad javascript aleto.js
; Note: If this is changed than you have to modify shortcut in aleto.js too
aletoHotkey = ^!i   ;( default: Ctrl+Alt+I )

; Gui list view options
fontSize = 10
fontType = MS sans serif
backColor = E4E2FC

; custom icon
cIcon = %A_ScriptDir%\icons\penguin.ico

;------------------------------------------------------

title="Hots    by alesc"
if cIcon <>
  IfExist, %cIcon%
    Menu, Tray, Icon, %cIcon%

; set env.variable ALEPATH before use
; ALEPATH is used as repository of ctags, map and err file
EnvGet, actPath, ALEPATH
if actPath =
{
  report("Error", "Env.variable ALEPATH not set.`nSet env.variable and restart the script")
  return
}

; do not change
ctagFile = %actPath%ctags
mapFile = %actPath%dat.txt
errFile = %actPath%err.txt

;------------------------------------------------------
; ctags
;------------------------------------------------------
#a::
selected := getSelectedTxt()
if isInvalid(selected)
  return

FileRead, content, %ctagFile%
if not ErrorLevel
{
  startPos = 1
  tagsCnt = 0

  loop
  {
    pos1 = 0
    pos2 = 0

    ; matching file + line number
    pos1 := RegExMatch(content, "Si)`r`n((" . selected . ")\t(.+)\t(\d+);.+)`r`n", line, startPos)
    ; matching file + line number + description
    pos2 := RegExMatch(content, "Si)`r`n((" . selected . ")\t(.+)\t/\^(.+)\$/;.+line:(\d+).*)`r`n", linetwo, startPos)

    ; match file + line number
    if ((pos1 < pos2 and pos1 != 0) or (pos1 != 0 and pos2 = 0))
    {
      tagsCnt++
      tagsFileArr%tagsCnt% = %line3%
      tagsDescArr%tagsCnt% =
      tagsNumArr%tagsCnt% = %line4%
      startPos := pos1 + StrLen(line1)
      continue
    }

    ; match file + line number + description
    if ((pos1 > pos2 and pos2 != 0) or (pos1 = 0 and pos2 != 0))
    {
      tagsCnt++
      tagsFileArr%tagsCnt% = %linetwo3%
      tagsDescArr%tagsCnt% = %linetwo4%
      tagsNumArr%tagsCnt% = %linetwo5%
      startPos := pos2 + StrLen(linetwo1)
      continue
    }
    ; no match...end loop
    if (pos1 = 0 and pos2 = 0)
      break 
  }
  content =

  if (tagsCnt > 1)
  {  
    ; more mathces found...create gui and wait for user click
    maxlen := 0
    
    Gui, Font, s%fontSize%, %fontType%
    Gui, Add, ListView, X0 Y0 vMyListView gmultiCtags Background%backColor% Grid, File name|Line number|Details
    Loop %tagsCnt%
    {
      ; ugly...
      tmplen := StrLen(tagsFileArr%A_Index%) + StrLen(tagsNumArr%A_Index%) + StrLen(tagsDescArr%A_Index%)
      if (maxlen < tmplen)
        maxlen := tmplen

      LV_Add("cWhite", tagsFileArr%A_Index%, tagsNumArr%A_Index%, tagsDescArr%A_Index%)
    }
    LV_ModifyCol(1, "AutoHdr")
    LV_ModifyCol(2, "AutoHdr")
    LV_ModifyCol(3, "AutoHdr")
 
    Gui +Resize
    ; ugly and not water proof
    height := tagsCnt * 25 + 10
    width := maxlen * 10

    MouseGetPos, xpos, ypos
    SysGet, workArea, MonitorWorkArea, 0
    maxHeight := (workAreaBottom * 0.90) - ypos
    maxWidth := A_ScreenWidth * 0.50

    if (height > maxHeight)
      height := maxHeight
    if (width > maxWidth)
      width := maxWidth

    Gui, Show, x%xpos% y%ypos% w%width% h%height%, Mutliball %title%
  }
  else if (tagsCnt = 1)
  {
    ; one match...save map file for editor to read and send shortcut
    writeMapfile(tagsFileArr1, tagsNumArr1)
    sendToPspad(aletoHotkey)
  }
  else
  {
    ; selected txt not found in ctags
    report("Warning", selected . " not found.")
  }
}
else
{
  report("Error", "Ctag file[" . ctagFile . "] not found.")
}
return

multiCtags:
if A_GuiEvent = DoubleClick
{
  ; get the text from the row's first and second field.
  LV_GetText(filename, A_EventInfo)
  LV_GetText(line, A_EventInfo, 2)
  Gui Destroy
  writeMapfile(filename, line)
  sendToPspad(aletoHotkey)
}
return

GuiClose:
Gui Destroy
return

GuiSize:
; The window has been minimized. No action needed.
if A_EventInfo = 1
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . A_GuiWidth . " H" . A_GuiHeight
return


