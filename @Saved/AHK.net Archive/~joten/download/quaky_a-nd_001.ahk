/**
 *	quaky a-nd - Vim Command Mode
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
 *	@version 0.0.1.01 (26.06.2011)
 */

/**
 *  quick help
 *
 *  The main purpose of this script is to map custom (simple) hotkeys to 
 *  existing shortcuts in applications. In order to not interfer with other
 *  input methods the script implements a Vim-like command and input mode; 
 *  most of the hotkeys are Vim-like, too, and are similar to those used in
 *  Vimperator, a Firefox add-on.
 *  The script has settings for the following applications:
 *    + Firefox
 *    + Explorer
 *    + PDFXChange Viewer
 *  
 *  It essentially uses the following AutoHotkey commands:
 *    + http://www.autohotkey.com/docs/commands/_IfWinActive.htm
 *    + http://www.autohotkey.com/docs/Hotkeys.htm
 *    + http://www.autohotkey.com/docs/Hotstrings.htm
 *    + http://www.autohotkey.com/docs/commands/Send.htm
 *  
 *  If you want to adjust the script to your needs, please refer to the 
 *  documentation given by the above links. One possible method to add 
 *  support for a new application is as follows:
 *    + copy the entry for "MozillaWindowClass"
 *    + change the title and class name for the #IfWinActive condition
 *    + delte the hotkeys, which are not needed or compatible
 *    + change all appearances of "MozillaWindowClass" to a unique 
 *      identifier of your choice
 *  
 *  The use of the function "Send(id, keys, altKeys)" ensures, that the 
 *  configured hotkeys are only active, if you are in command mode, and 
 *  allows the input of the hotkey characters in another context.
 *  
 *  If you want to alter the appearance of the OSD, please refer to 
 *    + http://www.autohotkey.com/docs/commands/Gui.htm and
 *    + http://www.autohotkey.com/docs/commands/Sleep.htm .
 *  
 *  Please keep in mind, that apart from the OSD the script does not 
 *  provide a GUI, no main window or tray icon.
 */

NAME	:= "quaky a-nd"
VERSION := "0.0.1"

; script settings
SetBatchLines, -1
SetTitleMatchMode, 3
SetTitleMatchMode, fast
#NoEnv
#NoTrayIcon
#SingleInstance force

; pseudo main function
Return 				; end of the auto-execute section

/**
 *	function & label definitions
 */
^!+q::ExitApp
^!+r::Reload

#IfWinActive ahk_class MozillaWindowClass				; Use "<window title>" and/or "ahk_class <window class>" to 
{														; select the window, for which the hotkeys are active.
	i::
		If (MozillaWindowClass_mode = "-- INPUT --")	; Set the mode "-- INPUT --" (The hotkeys except "Esc" and 
			SendInput i									; "F1" are suspended and the hotkey characters are sent.)
		Else
			MozillaWindowClass_mode := "-- INPUT --"
	Return
	Esc::												; Set the mode "-- COMMAND --" (The hotkeys are activated and 
		MozillaWindowClass_mode := "-- COMMAND --"		; the hotkey characters cannot be used for input.)
	Return
	F1::ShowMode("MozillaWindowClass")					; Show the current mode. ShowMode("<id>"); <id> may be the 
														; name of the window class, for which the hotkeys are active.
	; G:gg:gt:gT:P:^u:^i:^o
	; d:h:j:k:l:n:N:o:p:r:t:u
	d::Send("MozillaWindowClass", "^w", "d")			; Send("<id>", "<the keys to send, if the hotkey is active>", 
	+g::Send("MozillaWindowClass", "{End}", "+g")		; "<the keys to send, otherwise, i. e. the hotkey characters>"
	:B0CZ*:gg::
		Send("MozillaWindowClass", "{Home}", "gg")
	Return
	:B0CZ*:gt::
		Send("MozillaWindowClass", "^{Tab}", "gt")
	Return
	:B0CZ*:gT::
		Send("MozillaWindowClass", "^+{Tab}", "gT")
	Return
	h::Send("MozillaWindowClass", "{Left}", "h")
	j::Send("MozillaWindowClass", "{Down}", "j")
	k::Send("MozillaWindowClass", "{Up}", "k")
	l::Send("MozillaWindowClass", "{Right}", "l")
	n::Send("MozillaWindowClass", "{F3}", "n")
	+n::Send("MozillaWindowClass", "+{F3}", "+n")
	o::
		Send("MozillaWindowClass", "^l", "o")
		MozillaWindowClass_mode := "-- INPUT --"
	Return
	p::
		Send("MozillaWindowClass", "^l", "p")
		Send("MozillaWindowClass", SubStr(Clipboard, 1, InStr(Clipbord, "`r`n") - 1), "")
		Send("MozillaWindowClass", "{Enter}", "")
	Return
	+p::
		Send("MozillaWindowClass", "^t", "+p")
		Send("MozillaWindowClass", SubStr(Clipboard, 1, InStr(Clipbord, "`r`n") - 1), "")
		Send("MozillaWindowClass", "{Enter}", "")
	Return
	r::Send("MozillaWindowClass", "{F5}", "r")
	t::
		Send("MozillaWindowClass", "^t", "t")
		MozillaWindowClass_mode := "-- INPUT --"
	Return
	^u::Send("MozillaWindowClass", "^+t", "^u")
	^i::Send("MozillaWindowClass", "!{Right}", "^i")
	^o::Send("MozillaWindowClass", "!{Left}", "^o")
}

#IfWinActive ahk_class CabinetWClass
{
	i::
		If (CabinetWClass_mode = "-- INPUT --")
			SendInput i
		Else
			CabinetWClass_mode := "-- INPUT --"
	Return
	Esc::
		CabinetWClass_mode := "-- COMMAND --"
	Return
	F1::ShowMode("CabinetWClass")
	
	; G:gg:h:j:k:l:o:^o
	+g::Send("CabinetWClass", "{End}", "+g")
	:B0CZ*:gg::
		Send("CabinetWClass", "{Home}", "gg")
	Return
	h::Send("CabinetWClass", "{Left}", "h")
	j::Send("CabinetWClass", "{Down}", "j")
	k::Send("CabinetWClass", "{Up}", "k")
	l::Send("CabinetWClass", "{Right}", "l")
	o::
		Send("CabinetWClass", "{F4}", "o")
		CabinetWClass_mode := "-- INPUT --"
	Return
	^o::Send("CabinetWClass", "!{Up}", "^o")
}

#IfWinActive ahk_class DSUI:PDFXCViewer
{
	i::
		If (PDFXCViewer_mode = "-- INPUT --")
			SendInput i
		Else
			PDFXCViewer_mode := "-- INPUT --"
	Return
	Esc::
		PDFXCViewer_mode := "-- COMMAND --"
	Return
	F1::ShowMode("PDFXCViewer")
	
	; d:G:gg:gt:gT:h:j:k:l:n:N:o:p:P:r:t:u:^i:^o
	d::Send("PDFXCViewer", "^w", "d")
	+g::Send("PDFXCViewer", "{End}", "+g")
	:B0CZ*:gg::
		Send("PDFXCViewer", "{Home}", "gg")
	Return
	:B0CZ*:gt::
		Send("PDFXCViewer", "^{Tab}", "gt")
	Return
	:B0CZ*:gT::
		Send("PDFXCViewer", "^+{Tab}", "gT")
	Return
	h::Send("PDFXCViewer", "{Left}", "h")
	j::Send("PDFXCViewer", "{Down}", "j")
	k::Send("PDFXCViewer", "{Up}", "k")
	l::Send("PDFXCViewer", "{Right}", "l")
	n::Send("PDFXCViewer", "{F3}", "n")
	+n::Send("PDFXCViewer", "+{F3}", "+n")
	o::
		Send("PDFXCViewer", "^o", "o")
		PDFXCViewer_mode := "-- INPUT --"
	Return
	p::
		Send("PDFXCViewer", "^o", "p")
		Send("PDFXCViewer", SubStr(Clipboard, 1, InStr(Clipbord, "`r`n") - 1), "")
		PDFXCViewer_mode := "-- INPUT --"
	Return
}

Send(id, keys, altKeys) {
	If Not (%id%_mode = "-- INPUT --")
		Send %keys%
	Else
		SendInput %altKeys%
}

ShowMode(id) {
	Global
	
	If (%id%_mode = "")
		%id%_mode := "-- COMMAND --"
	
	IfWinExist, quaky a-nd OSD
		Gui, Destroy
	Gui, Font, s16, DejaVu Sans Mono
    Gui, Add, Text, vText cff8000 Backgroundffffff, % "Mode: " %id%_mode
    Gui, +ToolWindow +AlwaysOnTop -Caption
    Gui, Color, ffffff
    Gui, +Lastfound
    WinSet, TransColor, ffffff 180
    Gui, Show, , quaky a-nd OSD
	Sleep, 1000
	Gui, Destroy
}
