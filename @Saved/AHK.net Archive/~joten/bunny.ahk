/**
 *	bunny - Syntax highlighting of AutoHotkey scripts with CSS/HTML
 *	Copyright (c) 2011 joten
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *	@version 0.1.0.01 (05.10.2011)
 */

/**
 *  The syntax definition was taken from AutoHotkey\Extras\Editors\Syntax
 *  and the "Vim syntax file":
 *  Language:         AutoHotkey script file
 *  Maintainer:       Nikolai Weibull <now@bitwi.se>
 *  Latest Revision:  2008-06-22
 */

/**
 *  CSS SPAN classes:
 *  
 *  AHK-Comment
 *  AHK-CommentGroup
 *  AHK-String
 *  AHK-Escape
 *  
 *  AHK-BuiltinVariable
 *  AHK-Command
 *  AHK-Conditional
 *  AHK-Function
 *  AHK-PreProc
 *  
 *  AHK-Boolean
 *  AHK-Hotkey
 *  AHK-Hotstring
 *  AHK-MatchClass
 *  AHK-Type
 *  AHK-Variable
 *  
 *  AHK-Number
 */

NAME := "bunny"
VERSION := "0.1.0"

/**
 * Script settings
 */
FileEncoding, UTF-8
#NoEnv							; Recommended for performance and compatibility with future AutoHotkey releases.
; #NoTrayIcon
#SingleInstance force
SendMode Input					; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%		; Ensures a consistent starting directory.

/**
 * Pseudo main function
 */
	Keyword_init()
	
	FileSelectFile, sPath, 1, %A_ScriptDir%, Select an AHK script
	If Not sPath
		sPath := A_ScriptFullPath
	FileRead, s, % sPath
	
	t  := ""
	sP := 1
	Loop {
		; extract multi-line comments -> extract multi-line strings -> extract inline comments and strings -> search for keywords
		cP0 := RegExMatch(s, "m)^\s*/\*", "", sP)			; comment start
		If cP0 {
			extractMultiLineStrings(SubStr(s, sP, cP0 - sP))
			cP1 := InStr(s, "*/", False, cP0 + 2)		; comment end
			If cP1 {
				t   .= "<SPAN CLASS=""AHK-CommentGroup"">" encode(SubStr(s, cP0, cP1 + 2 - cP0)) "</SPAN>"
				sP  := cP1 + 2
			} Else {									; endless comment
				t   .= "<SPAN CLASS=""AHK-CommentGroup"">" encode(SubStr(s, cP0)) "</SPAN>"
				sP  := StrLen(s)
				Break
			}
		} Else
			Break
	}
	extractMultiLineStrings(SubStr(s, sP))
	StringReplace, t, t, %A_Tab%, % "<SPAN>    </SPAN>", All
	t := "<PRE>`n" t "</PRE>`n"
	
	MsgBox, 4, , The syntax highlighting has been done.`nCopy the text (HTML body) to the clipboard?
	IfMsgBox Yes
		Clipboard := t
ExitApp							; end of the auto-execute section

/**
 *	Hotkeys, function & label definitions
 */
Esc::ExitApp

encode(s) {
	StringReplace, s, s, &, &amp`;, All
	StringCaseSense, On
	StringReplace, s, s, Ä, &Auml`;, All
	StringReplace, s, s, Ö, &Ouml`;, All
	StringReplace, s, s, Ü, &Uuml`;, All
	StringCaseSense, Off
	StringReplace, s, s, ", &quot`;, All
	cMap := "aacute;á&acirc;â&acute;´&aelig;æ&agrave;à&apos;'&aring;å&atilde;ã&auml;ä&bdquo;„"
		. "&brvbar;¦&bull;•&ccedil;ç&cedil;¸&cent;¢&circ;ˆ&copy;©&curren;¤&dagger;†&deg;°&divide;÷"
		. "&eacute;é&ecirc;ê&egrave;è&eth;ð&euml;ë&euro;€&fnof;ƒ&frac12;½&frac14;¼&frac34;¾&gt;>"
		. "&hellip;…&iacute;í&icirc;î&iexcl;¡&igrave;ì&iquest;¿&iuml;ï&laquo;«&ldquo;“&lsaquo;‹&lsquo;‘&lt;<"
		. "&macr;¯&mdash;—&micro;µ&middot;·&ndash;–&not;¬&ntilde;ñ"
		. "&oacute;ó&ocirc;ô&oelig;œ&ograve;ò&ordf;ª&ordm;º&oslash;ø&otilde;õ&ouml;ö"
		. "&para;¶&permil;‰&plusmn;±&pound;£&raquo;»&rdquo;”&reg;®&rsaquo;›&rsquo;’"
		. "&sbquo;‚&scaron;š&sect;§&sup1;¹&sup2;²&sup3;³&szlig;ß&thorn;þ&tilde;˜&times;×&trade;™"
		. "&uacute;ú&ucirc;û&ugrave;ù&uml;¨&uuml;ü&yacute;ý&yen;¥&yuml;ÿ"
	Loop, PARSE, cMap, &
	{
		StringSplit, c, A_LoopField, `;
		StringReplace, s, s, %c2%, &%c1%`;, All
	}
	
	Return, s
}

extractMultiLineStrings(s) {
	Global t
	
	sP := 1
	Loop {
		p0 := RegExMatch(s, "m)^\s*\(", "", sP)				; start of the continuation section
		If p0 {
			strP0 := RegExMatch(s, "[\n\r][ \t]*[""]", "", p0)	; start of the string
			If strP0 {
				parse(SubStr(s, sP, strP0 - sP))
				strP0 := RegExMatch(s, "[ \t]*[""]", "", strP0)
				strP1 := InStr(s, """", False, strP0)
				strP1 := InStr(s, """", False, strP1 + 1)	; end of the string
				If strP1 {
					t  .= "<SPAN CLASS=""AHK-String"">" encode(RegExReplace(SubStr(s, strP0, strP1 + 1 - strP0), "(``.)", "<SPAN CLASS=""AHK-Escape"">$1</SPAN>")) "</SPAN>"
					sP := strP1 + 1
					p1 := InStr(s, ")", False, sP)			; end of the continuation section
					If p1
						sP := p1
				} Else {									; endless string
					t  .= "<SPAN CLASS=""AHK-String"">" encode(RegExReplace(SubStr(s, strP0), "(``.)", "<SPAN CLASS=""AHK-Escape"">$1</SPAN>")) "</SPAN>"
					sP := StrLen(s)
					Break
				}
			} Else {
				p1 := InStr(s, ")", False, p0)				; end of the continuation section
				If p1
					sP := p1
				Else {
					sP := StrLen(s)
					Break
				}
			}
		} Else
			Break
	}
	parse(SubStr(s, sP))
}

Keyword_init() {
	Global Keyword_builtinVariable, Keyword_command, Keyword_conditional, Keyword_function, Keyword_preProc
	
	Keyword_builtinVariable := 
		(Join LTrim RTrim 
			"A_AhkPath|A_AhkVersion|A_AppData|A_AppDataCommon|A_AutoTrim|
			A_BatchLines|
			A_CaretX|A_CaretY|A_ComputerName|A_ControlDelay|A_Cursor|
			A_DD|A_DDD|A_DDDD|A_DefaultMouseSpeed|A_Desktop|A_DesktopCommon|A_DetectHiddenText|A_DetectHiddenWindows|
			A_EndChar|A_EventInfo|A_ExitReason|
			A_FormatFloat|A_FormatInteger|
			A_Gui|A_GuiEvent|A_GuiControl|A_GuiControlEvent|A_GuiHeight|A_GuiWidth|A_GuiX|A_GuiY|
			A_Hour|
			A_IconFile|A_IconHidden|A_IconNumber|A_IconTip|A_Index|A_IPAddress1|A_IPAddress2|A_IPAddress3|A_IPAddress4|
			A_ISAdmin|A_IsCompiled|A_IsCritical|A_IsPaused|A_IsSuspended|
			A_KeyDelay|
			A_Language|A_LastError|A_LineFile|A_LineNumber|
			A_LoopField|A_LoopFileAttrib|A_LoopFileDir|A_LoopFileExt|A_LoopFileFullPath|A_LoopFileLongPath|A_LoopFileName|A_LoopFileShortName|
			A_LoopFileShortPath|A_LoopFileSize|A_LoopFileSizeKB|A_LoopFileSizeMB|A_LoopFileTimeAccessed|A_LoopFileTimeCreated|
			A_LoopFileTimeModified|A_LoopReadLine|A_LoopRegKey|A_LoopRegName|A_LoopRegSubkey|A_LoopRegTimeModified|A_LoopRegType|
			A_MDAY|A_Min|A_MM|A_MMM|A_MMMM|A_Mon|A_MouseDelay|A_MSec|A_MyDocuments|
			A_Now|A_NowUTC|A_NumBatchLines|
			A_OSType|A_OSVersion|
			A_PriorHotkey|A_ProgramFiles|A_Programs|A_ProgramsCommon|
			A_ScreenHeight|A_ScreenWidth|A_ScriptDir|A_ScriptFullPath|A_ScriptName|A_Sec|A_Space|A_StartMenu|A_StartMenuCommon|A_Startup|A_StartupCommon|A_StringCaseSense|
			A_Tab|A_Temp|A_ThisFunc|A_ThisHotkey|A_ThisLabel|A_ThisMenu|A_ThisMenuItem|A_ThisMenuItemPos|A_TickCount|A_TimeIdle|
			A_TimeIdlePhysical|A_TimeSincePriorHotkey|A_TimeSinceThisHotkey|A_TitleMatchMode|A_TitleMatchModeSpeed|
			A_UserName|
			A_WDay|A_WinDelay|A_WinDir|A_WorkingDir|
			A_YDay|A_YEAR|A_YWeek|A_YYYY|
			Clipboard|ClipboardAll|ComSpec|ErrorLevel|ProgramFiles"
		)
	
	Keyword_command := 
		(Join LTrim RTrim 
			"AutoTrim|
			BlockInput|Break|
			Click|ClipWait|Continue|
			Control|ControlClick|ControlFocus|ControlGet|ControlGetFocus|ControlGetPos|ControlGetText|ControlMove|ControlSend|ControlSendRaw|ControlSetText|
			CoordMode|Critical|
			DetectHiddenText|DetectHiddenWindows|Drive|DriveGet|DriveSpaceFree|
			Edit|EnvAdd|EnvDiv|EnvGet|EnvMult|EnvSet|EnvSub|EnvUpdate|Exit|ExitApp|
			FileAppend|FileCopy|FileCopyDir|FileCreateDir|FileCreateShortcut|FileDelete|
			FileGetAttrib|FileGetShortcut|FileGetSize|FileGetTime|FileGetVersion|
			FileInstall|FileMove|FileMoveDir|FileRead|FileReadLine|FileRecycle|FileRecycleEmpty|FileRemoveDir|
			FileSelectFile|FileSelectFolder|FileSetAttrib|FileSetTime|FormatTime|
			GetKeyState|Gosub|Goto|GroupActivate|GroupAdd|GroupClose|GroupDeactivate|Gui|GuiControl|GuiControlGet|
			Hotkey|
			ImageSearch|IniDelete|IniRead|IniWrite|Input|InputBox|
			KeyHistory|KeyWait|
			ListHotkeys|ListLines|ListVars|Loop|Loop, Parse|Loop, Read|
			Menu|MouseClick|MouseClickDrag|MouseGetPos|MouseMove|MsgBox|
			OnExit|OutputDebug|
			Pause|PixelGetColor|PixelSearch|PostMessage|Process|Progress|
			Random|RegDelete|RegRead|RegWrite|Reload|Repeat|Return|Run|RunAs|RunWait|
			Send|SendEvent|SendInput|SendMessage|SendMode|SendPlay|SendRaw|
			SetBatchLines|SetCapslockState|SetControlDelay|SetDefaultMouseSpeed|SetEnv|SetFormat|SetKeyDelay|SetMouseDelay|SetNumlockState|
			SetScrollLockState|SetStoreCapslockMode|SetTimer|SetTitleMatchMode|SetWinDelay|SetWorkingDir|
			Shutdown|Sleep|Sort|SoundBeep|SoundGet|SoundGetWaveVolume|SoundPlay|SoundSet|SoundSetWaveVolume|SplashImage|SplashTextOff|
			SplashTextOn|SplitPath|StatusBarGetText|StatusBarWait|
			StringCaseSense|StringGetPos|StringLeft|StringLen|StringLower|StringMid|StringReplace|StringRight|StringSplit|StringTrimLeft|StringTrimRight|StringUpper|
			Suspend|SysGet|
			Thread|ToolTip|Transform|TrayTip|
			URLDownloadToFile|
			While|WinActivate|WinActivateBottom|WinClose|WinGet|WinGetActiveStats|WinGetActiveTitle|WinGetClass|WinGetPos|WinGetText|
			WinGetTitle|WinHide|WinKill|WinMaximize|WinMenuSelectItem|WinMinimize|WinMinimizeAll|WinMinimizeAllUndo|WinMove|WinRestore|WinSet|
			WinSetTitle|WinShow|WinWait|WinWaitActive|WinWaitClose|WinWaitNotActive"
		)
	
	Keyword_conditional := 
		(Join LTrim RTrim 
			"If|Else|IfEqual|IfExist|IfGreater|IfGreaterOrEqual|IfInString|IfLess|IfLessOrEqual|IfMsgBox|IfNotEqual|IfNotExist|IfNotInString|
			IfWinActive|IfWinExist|IfWinNotActive|IfWinNotExist"
		)
	
	Keyword_function := 
		(Join LTrim RTrim 
			"Abs|ACos|Asc|ASin|ATan|Ceil|Chr|Cos|DllCall|Exp|FileExist|Floor|GetKeyState|IL_Add|IL_Create|IL_Destroy|InStr|IsFunc|IsLabel|
			Ln|Log|LV_Add|LV_Delete|LV_DeleteCol|LV_GetCount|LV_GetNext|LV_GetText|LV_Insert|LV_InsertCol|LV_Modify|LV_ModifyCol|LV_SetImageList|
			Mod|NumGet|NumPut|OnMessage|RegExMatch|RegExReplace|RegisterCallback|Round|SB_SetIcon|SB_SetParts|SB_SetText|Sin|Sqrt|StrLen|SubStr|
			Tan|TV_Add|TV_Delete|TV_GetChild|TV_GetCount|TV_GetNext|TV_Get|TV_GetParent|TV_GetPrev|TV_GetSelection|TV_GetText|TV_Modify|
			VarSetCapacity|WinActive|WinExist"			
		)
	
	Keyword_preProc := 
		(Join LTrim RTrim 
			"#AllowSameLineComments|#ClipboardTimeout|#CommentFlag|#ErrorStdOut|#EscapeChar|
			#HotkeyInterval|#HotkeyModifierTimeout|#Hotstring|
			#IfWinActive|#IfWinExist|#IfWinNotActive|#IfWinNotExist|
			#Include|#IncludeAgain|
			#InstallKeybdHook|#InstallMouseHook|#KeyHistory|#LTrim|
			#MaxHotkeysPerInterval|#MaxMem|#MaxThreads|#MaxThreadsBuffer|#MaxThreadsPerHotkey|
			#NoEnv|#NoTrayIcon|#Persistent|#SingleInstance|#UseHook|#WinActivateForce"
		)
}

parse(s) {
	Global t
	
	Loop, PARSE, s, `n, `r
	{
		l  := A_LoopField
		l0 := ""
		c  := ""
		
		; Extract quoted strings and inline comments
		Loop {
			cP := RegExMatch(l, "(^;|[^``];)", "")
			p0 := InStr(l, """", False)
			If cP Or p0 {
				If cP And (p0 = 0 Or cP < p0) {	; inline comment
					c := "<SPAN CLASS=""AHK-Comment"">" encode(SubStr(l, cP)) "</SPAN>"
					l := SubStr(l, 1, cP - 1)
					Break
				} Else If p0 {					; quoted string
					p1 := InStr(l, """", False, p0 + 1)
					If p1 {
						l0 .= tag(SubStr(l, 1, p0 - 1)) "<SPAN CLASS=""AHK-String"">" encode(SubStr(l, p0, p1 - p0 + 1)) "</SPAN>"
						l  := SubStr(l, p1 + 1)
					} Else {					; endless string
						l0 .= tag(SubStr(l, 1, p0 - 1)) "<SPAN CLASS=""AHK-String"">" encode(SubStr(l, p0)) "</SPAN>"
						l  := ""
						Break
					}
				}
			} Else
				Break
		}
		l := RegExReplace(l0 tag(l), "(``.)", "<SPAN CLASS=""AHK-Escape"">$1</SPAN>") c
		
		t .= l "`n"
	}
}

tag(s) {
	Global Keyword_builtinVariable, Keyword_command, Keyword_conditional, Keyword_function, Keyword_preProc
	
	s := RegExReplace(s, "i)(" Keyword_preProc ")\b", "<SPAN CLASS=""AHK-PreProc"">$1</SPAN>")
	s := RegExReplace(s, "i)\b(" Keyword_builtinVariable ")\b", "<SPAN CLASS=""AHK-BuiltinVariable"">$1</SPAN>")
	s := RegExReplace(s, "i)\b(" Keyword_command ")\b", "<SPAN CLASS=""AHK-Command"">$1</SPAN>")
	s := RegExReplace(s, "i)(" Keyword_conditional ")\b", "<SPAN CLASS=""AHK-Conditional"">$1</SPAN>")
	s := RegExReplace(s, "i)(" Keyword_function ")\b", "<SPAN CLASS=""AHK-Function"">$1</SPAN>")
	
	s := RegExReplace(s, "i)\b(true|false)\b", "<SPAN CLASS=""AHK-Boolean"">$1</SPAN>")
	s := RegExReplace(s, "i)(^\s*)(.+::)", "$1<SPAN CLASS=""AHK-Hotkey"">" encode($2) "</SPAN>")
;	s := RegExReplace(s, "i)(^\s*)(:\%(B0\|C1\|K\d\+\|P\d\+\|S[IPE]\|Z\d\=\|[*?COR]\)*:.\{-}::)", "$1<SPAN CLASS=""AHK-HotString"">" encode($2) "</SPAN>")
	s := RegExReplace(s, "i)\b(ahk_group|ahk_class|ahk_id|ahk_pid)\b", "<SPAN CLASS=""AHK-MatchClass"">$1</SPAN>")
	s := RegExReplace(s, "i)^(\s*)(global|local)\b", "$1<SPAN CLASS=""AHK-Type"">$2</SPAN>")
	s := RegExReplace(s, "i)%([a-zA-Z0-9#_@\$\?]+)%", "%<SPAN CLASS=""AHK-Variable"">$1</SPAN>%")
	
	s := RegExReplace(s, "i)(\b\d*\.?\d+\b)", "<SPAN CLASS=""AHK-Number"">$1</SPAN>")
	s := RegExReplace(s, "i)(\b0x[a-fA-F\d]+\b)", "<SPAN CLASS=""AHK-Number"">$1</SPAN>")
	
	Return, s
}
