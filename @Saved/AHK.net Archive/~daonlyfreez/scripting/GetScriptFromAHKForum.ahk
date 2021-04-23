; ****************************************************
; GetScriptFromAHKForum
;
; version: 1
;
; Here is my version ;-)...
;
; Currenly only for Internet Explorer
;
; Automagically extracts the codes from your the AHK
; forum you are currently browsing
;
; ****************************************************

; Example (this topic), Internet Explorer only so far:
IfWinNotExist, Mr Clean ahk_class IEFrame
  Run, iexplore.exe "http://www.autohotkey.com/forum/topic12388.html"

; ****************************************************

; Path to Editor
editorPath = %A_ProgramFiles%\PSPad\PSPad.exe
;editorPath = %A_ProgramFiles%\SciTE\SciTE.exe
;editorPath = %A_Desktop%\AHKDev\IDE4AHK\SciTE4AHK\SciTE.exe

; Scanning vars, extracts everything between
startHTML = <td class="code">
StringLen, startHTMLLen, startHTML
endHTML = </td>	</tr></table>
StringLen, endHTMLLen, endHTML

; Temporary file paths
tempHTMLFile = %A_ScriptDir%\forum.tmp
tempAHKFile = %A_ScriptDir%\temp.ahk

; Other
checkForInURL = www.autohotkey.com/forum/topic

; ****************************************************

; Gui:
Gui, Add, Button, x6 y5 w160 h30 gGetCodesFromBrowser, Get Scripts
Gui, Add, Text, x176 y5 w290 h30 , Extracts posted code pieces from the AutoHotkey Forum.`nDetects open browser windows with an AHK forum thread.
Gui, Add, Text, x6 y45 w50 h20 , URL
Gui, Add, Edit, x56 y45 w410 h20 vURL, 
Gui, Add, Text, x6 y75 w50 h20 , Title
Gui, Add, Edit, x56 y75 w410 h20 vTitle, 
Gui, Add, Text, x6 y105 w180 h20 , Contained Codes:
Gui, Add, ListView, x6 y125 w50 h236 -Hdr -Multi AltSubmit vContainedCodes gContainedCodes, ListView
Gui, Add, Text, x56 y125 w410 h236 Border vCodePreview, 
Gui, Add, Button, x56 y365 w160 h30 gCopyToClipboard, Copy code to Clipboard
Gui, Add, Button, x266 y365 w100 h30 gEditAsScript, Edit as Script
Gui, Add, Button, x366 y365 w100 h30 gRunAsScript, Run as Script
; Generated using SmartGUI Creator 4.0
Gui, Show, x231 y91 h408 w481, Get Script From AHK Forum - v 1 - IE only...

Gui, ListView, ContainedCodes
LV_ModifyCol(1, 28)
Return

; ****************************************************

GuiClose:
ExitApp

; ****************************************************

; Debugging
!r::Reload
Return

; ****************************************************

ContainedCodes:
If A_GuiEvent = Normal
{
	LV_GetText(RowText, A_EventInfo)
	thisCode := allCodeArray%RowText%
  GuiControl, , CodePreview, %thisCode%
}
Return

; ****************************************************

CopyToClipboard:
GuiControlGet, highlCode, , CodePreview
StringMid, highl1stChar, highlCode, 1, 1
; Don't continue if program comment or empty
If (highl1stChar != "*" And highlCode != "")
  Clipboard = %highlCode%
Else
  GuiControl, , CodePreview, * There is no script to copy
Return

; ****************************************************

EditAsScript:
GuiControlGet, highlCode, , CodePreview
StringMid, highl1stChar, highlCode, 1, 1
; Don't continue if program comment or empty
If (highl1stChar != "*" And highlCode != "")
{
  FileAppend, %highlCode%, %tempAHKFile%
  Run, %editorPath% "%tempAHKFile%"
}
Else
  GuiControl, , CodePreview, * There is no script to edit
Return

; ****************************************************

RunAsScript:
GuiControlGet, highlCode, , CodePreview
StringMid, highl1stChar, highlCode, 1, 1
; Don't continue if program comment or empty
If (highl1stChar != "*" And highlCode != "")
{
  FileAppend, %highlCode%, %tempAHKFile%
  Run, %tempAHKFile%
}
Else
  GuiControl, , CodePreview, * There is no script to run
Return

; ****************************************************

GetCodesFromBrowser:
allCode =
GuiControl, , CodePreview,
LV_Delete()
Loop, %allCodeArray0%
  allCodeArray%A_Index% =

WinGet, IEWins, List, ahk_class IEFrame
Loop, %IEWins%
{
  aIEWin := IEWins%A_Index%
  ControlGetText, curURL, Edit1, ahk_id %aIEWin%
  If curURL contains %checkForInURL%
  {
    getURL = %curURL%
    WinGetTitle, getTitle, ahk_id %aIEWin%
    Break
  }
}

; Check for Internet Explorer window
If getURL =
{
  GuiControl, , CodePreview, * No Internet Explorer window found with an AutoHotkey Forum page loaded...
  Return
}

; Update Gui
GuiControl, , URL, %getURL%
GuiControl, , Title, %getTitle%

; Download html file
UrlDownloadToFile, %getURL%, %tempHTMLFile%
If ErrorLevel = 1
{
  GuiControl, , CodePreview, * There was an error downloading the file...
  Return
}

; Read html file
FileRead, allHTML, %tempHTMLFile%
If ErrorLevel = 1
{
  GuiControl, , CodePreview, * There was an error reading from the file...
  Return
}

; Check for code
IfNotInString, allHTML, %startHTML%
{
  GuiControl, , CodePreview, * It appears the file doesn't contain code...
  Return
}

; Get all containing codes
Loop
{
  StringGetPos, aPos, allHTML, %startHTML%, L%A_Index%
  StringGetPos, bPos, allHTML, %endHTML%, , %aPos%
  If aPos = -1
  {
    codesCount := a_index-1
    Break
  }
  StringMid, aCode, allHTML, (aPos+startHTMLLen+1), (bPos-aPos-endHTMLLen+2)
  StringMid, startOfCode, aCode, 0, 8
  If startOfCode = `r`n<br />
    StringTrimLeft, aCode, aCode, 8
  If aCode =
    Break
  Else
  {
    LV_Add("", A_Index)
    allCode := allCode "°" ForumHTMLToText(aCode)

  }
}
StringTrimLeft, allCode, allCode, 1
StringSplit, allCodeArray, allCode, °, %A_Space%%A_Tab%`n	

; Update Gui
GuiControl, , CodePreview, %allCodeArray1%
Return

; ****************************************************

; Transform AHK Forum html to text
ForumHTMLToText(theHTML)
{
  allSearch =
  allReplace = 
  StringReplace, theHTML, theHTML, `n<br />`n, , All
  StringReplace, theHTML, theHTML, ``n&nbsp; &nbsp;, %a_tab%, All
  StringReplace, theHTML, theHTML, &nbsp; &nbsp;, %a_tab%, All
  StringReplace, theHTML, theHTML, &nbsp;, %a_space%, All
  StringReplace, theHTML, theHTML, &quot;, ", All
  StringReplace, theHTML, theHTML, &#123;, {, All
  StringReplace, theHTML, theHTML, &#125;, }, All
  StringReplace, theHTML, theHTML, &#58;, :, All
  StringReplace, theHTML, theHTML, &#40;, (, All
  StringReplace, theHTML, theHTML, &#41;, ), All
  StringReplace, theHTML, theHTML, &#91;, [, All
  StringReplace, theHTML, theHTML, &#93;, ], All
  return theHTML
}

; ****************************************************
