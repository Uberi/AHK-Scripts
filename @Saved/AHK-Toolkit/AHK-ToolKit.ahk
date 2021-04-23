/*
 * =============================================================================================== *
 * Author           : RaptorX   <graptorx@gmail.com>
 * Script Name      : AutoHotkey ToolKit (AHK-ToolKit)
 * Script Version   : 0.8.1.1
 * Homepage         : http://www.autohotkey.com/forum/topic61379.html#376087
 *
 * Creation Date    : July 11, 2010
 * Modification Date: October 14, 2012
 *
 * Description      :
 * ------------------
 * This small program is a set of "tools" that i use regularly.
 *
 * A convenient GUI that serves as a hotkey and hotstring manager allows you to keep all of them
 * in an easy to read list.
 *
 * The Live Code tab allows you to quickly test ahk code without having to save a file even if
 * Autohotkey is not installed in the computer you are using.
 * Also there are other tools like the Command Detector and the Screen and Forum Tools that improve
 * the way i help other people while in IRC and ahk Forums.
 *
 * I hope other people find it useful. You can modify it and improve it as you like. Feel free
 * to contact me if you want your changes to be added in the official release.
 *
 * -----------------------------------------------------------------------------------------------
 * License          :       Copyright ©2010-2012 RaptorX <GPLv3>
 *
 *          This program is free software: you can redistribute it and/or modify
 *          it under the terms of the GNU General Public License as published by
 *          the Free Software Foundation, either version 3 of  the  License,  or
 *          (at your option) any later version.
 *
 *          This program is distributed in the hope that it will be useful,
 *          but WITHOUT ANY WARRANTY; without even the implied warranty  of
 *          MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE.  See  the
 *          GNU General Public License for more details.
 *
 *          You should have received a copy of the GNU General Public License
 *          along with this program.  If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>
 * -----------------------------------------------------------------------------------------------
 *
 * [GUI Number Index]
 *
 * GUI 01 - First Time Run / AutoHotkey ToolKit [MAIN GUI]
 * GUI 02 - Add Hotkey
 * GUI 03 - Add Hotstring
 * GUI 04 - Import Hotkeys/Hotstrings
 * GUI 05 - Export Hotkeys/Hotstrings
 * GUI 06 - Preferences
 * GUI 07 - Add Snippet
 * GUI 08 - About
 * GUI 09 - Paste Upload
 * GUI 92 - Command Helper Options
 * GUI 93 - Command Helper
 * GUI 94 - Code Detection Popup
 * GUI 95 - Code Detection Pastebin Preferences
 * GUI 96 - Code Detection Keywords Preferences
 * GUI 97 - Code Detection Preferences
 * GUI 98 - General Preferences
 * GUI 99 - Splash Window / Screen Tool Area Selection
 *
 * =============================================================================================== *
 */

 if (a_ahkversion < 1.1){
    Msgbox, 0x10
          , % "Error"
          , % "The AutoHotkey installed in your computer is not compatible with`n"
            . "this version of AutoHotkey Toolkit.`n`n"
            . "Please use the compiled version of my script or upgrade to AutoHotkey L.`n"
            . "The application will exit now."

    Exitapp
}

;[Includes]{
#include <sc>
#include <sci>
#include <hash>
#include <klist>
#include <attach>
#include <hkSwap>
#include <uriSwap>
#include <scriptobj>
#include <htmlhelp>
#include <httprequest>
;}

;[Directives]{
#NoEnv
#SingleInstance Force
; --
SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, RegEx
CoordMode, Caret, Screen
CoordMode, Tooltip, Screen
SetWorkingDir, %a_scriptdir%
OnExit, Exit
; --
GroupAdd, ScreenTools, ahk_class SWarClass
GroupAdd, ScreenTools, ahk_class Photoshop
GroupAdd, ScreenTools, ahk_class illustrator
GroupAdd, ScreenTools, ahk_class 3DSMAX
GroupAdd, ScreenTools, ahk_class AE_CApplication_9.0
;}

;[Basic Script Info]{
Clipboard := null
global script := { base        : scriptobj
                  ,name        : "AHK-ToolKit"
                  ,version     : "0.8.1.1"
                  ,author      : "RaptorX"
                  ,email       : "graptorx@gmail.com"
                  ,homepage    : "http://www.autohotkey.com/forum/topic61379.html#376087"
                  ,crtdate     : "July 11, 2010"
                  ,moddate     : "October 14, 2012"
                  ,conf        : "conf.xml"}
script.getparams(), ForumMenu(), TrayMenu()  ; These function are here so that
                                             ; the Tray Icon is shown early
                                             ; and forum menus are ready.

;}

;[User Configuration]{
; Trying to fix the issues that result from the script not being run as admin under Win7/Vista
if (!a_isadmin){
    If a_iscompiled
       DllCall(ShellExecute,"Uint", 0
                           , "Str", "RunAs"
                           , "Str", a_scriptfullpath
                           , "Str", params
                           , "Str", a_workingdir
                           ,"Uint", 1)
    Else
       DllCall(ShellExecute,"Uint", 0
                           , "Str", "RunAs"
                           , "Str", a_ahkpath
                           , "Str", """" a_scriptfullpath """" a_space params
                           , "Str", a_workingdir
                           ,"Uint", 1)
}

global system := {}, sci := {} ; Scintilla array
global conf := ComObjCreate("MSXML2.DOMDocument"), xsl := ComObjCreate("MSXML2.DOMDocument"), root, options, hotkeys, hotstrings
system.mon := {}, system.wa := {}

RegRead,defBrowser,HKCR,.html                               ; Get default browswer
RegRead,defBrowser,HKCR,%defBrowser%\Shell\Open\Command     ; Get path to default browser + options
SysGet, mon, Monitor                                        ; Get the boundaries of the current screen
SysGet, wa, MonitorWorkArea                                 ; Get the working area of the current screen

system.defBrowser := defBrowser
system.mon.left := monLEFT, system.mon.right := monRIGHT, system.mon.top := monTOP, system.mon.bottom := monBOTTOM
system.wa.left := waLEFT, system.wa.right := waRIGHT, system.wa.top := waTOP, system.wa.bottom := waBOTTOM
;--
; Cleaning
defBrowser:=monLEFT:=monRIGHT:=monTOP:=monBOTTOM:=waLEFT:=waRIGHT:=waTOP:=waBOTTOM:=null  ; Set all to null
;--
; Configuration file objects
style = ;{
(
<!-- Extracted from: http://www.dpawson.co.uk/xsl/sect2/pretty.html (v2) -->
<!-- Cdata info from: http://www.altova.com/forum/default.aspx?g=posts&t=1000002342 -->
<!-- Modified By RaptorX -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            indent="yes"
            encoding="UTF-8"/>

<xsl:template match="*">
   <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
   </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()">
   <xsl:copy />
</xsl:template>
</xsl:stylesheet>
<!-- I have to keep the indentation here in this file as i want it to be on the XML file -->
)
;}

xsl.loadXML(style), style:=null
if !conf.load(script.conf)
{
    if FileExist(script.conf)
    {
        Msgbox, 0x14
              , % "Error while reading the configuration file."
              , % "The configuration file is corrupt.`n"
                . "Do you want to load the default configuration file?`n`n"
                . "Note: `n"
                . "You will lose any saved hotkeys/hotstrings and all other personal data by this operation.`n"
                . "Choose No to abort the operation and try to recover the file manually."

        IfMsgBox Yes
        {
            defConf(script.conf)

            Msgbox, 0x40
                  , % "Operation Completed"
                  , % "The default configuration file was successfully created. The script will reload."

            Reload
            Pause       ; Fixes the problem of the Main Gui flashing because of being created before
                        ; the Reload is really performed.
        }
        IfMsgBox No
            ExitApp
    }
    else
        FirstRun()
} root:=conf.documentElement,options:=root.firstChild,hotkeys:=options.nextSibling,hotstrings:=hotkeys.nextSibling

node := root.attributes.item[0]
node.text != script.version ? (node.text := script.version, conf.save(script.conf)
                              , conf.load(script.conf), node:=null) : null
;}

;[Main]{
script.autostart(options.selectSingleNode("//@sww").text)
options.selectSingleNode("//@ssi").text ? script.splash("res\img\AHK-TK_Splash.png") : null

CreateGui() ; Creating GUI before checking for updates for avoiding the GUI not showing up because an update check was in progress
options.selectSingleNode("//@cfu").text ? script.update(script.version) : null

Return                      ; [End of Auto-Execute area]
;}

;[Labels]{
GuiHandler:         ;{
    GuiHandler()
return
;}

MenuHandler:        ;{
    MenuHandler()
return
;}

ListHandler:        ;{
    ListHandler()
return
;}

HotkeyHandler:      ;{
    HotkeyHandler(a_thishotkey)
return
;}

GuiSize:            ;{
4GuiSize:
    if (a_gui = 1)
    {
        _lists := "hkList|shkList|hsList|shsList"
        _guiwidth := a_guiwidth, _guiheight:= a_guiheight
        SB_SetParts(150,150,a_guiwidth-378,50)

        Loop, Parse, _lists, |
        {
            Gui, 01: ListView, % a_loopfield
            if (a_loopfield = "hkList" || a_loopfield = "shkList")
                LV_ModifyCol(2, "Center"), LV_ModifyCol(3, "Center")
            Loop, 4
                LV_ModifyCol(a_index, "AutoHdr")
        }

        if (a_eventinfo = 1)
        {
            main_toggle := !main_toggle
            Gui, 01: Hide
        }
    }
    if a_gui = 4
    {
        Gui, 04: ListView, imList
        LV_ModifyCol(5, "AutoHdr")
    }
return
;}

OnClipboardChange:  ;{
    Critical
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
    if options.selectSingleNode("//Codet/@status").text
    {
        if (Clipboard = oldScript)
            return
        oldScript:=Clipboard, kword_cnt:=0
        kwords := options.selectSingleNode("//Codet/Keywords").text     ; load every time because it might have
                                                                        ; changed recently

        Loop, Parse, kwords, %a_space%
            if RegexMatch(Clipboard, "i)\b" a_loopfield "\b\(?")
                kword_cnt++
        if (kword_cnt >= options.selectSingleNode("//Codet/Keywords/@min").text)
        {
            kword_cnt:=0
            if (options.selectSingleNode("//Codet/@mode").text = 2)
                pasteUpload("auto")
            else
                pasteUpload("show")
        }
    }
return
;}

; Special Labels
OpenHelpFile:       ;{
    oldclip := ClipboardAll
    Send, {Ctrl Down}{left}+{right}c{CtrlUp}
    ClipWait
    htmlhelp(hwnd, regexreplace(a_ahkpath, "exe$", "chm"), clipboard)
    Clipboard := oldclip
return
;}

ForumTags:          ;{
    oldclip := ClipboardAll
    Send, {Ctrl Down}{left}+{right}c{CtrlUp}
    ClipWait
    htmlhelp("ForumHelper", regexreplace(a_ahkpath, "exe$", "chm"), clipboard)
    Clipboard := oldclip
return
;}


Exit:
    Process,Close, %hslPID%
    if FileExist(a_temp "\ahkl.bak")
        FileDelete, %a_temp%\ahkl.bak

    if FileExist(a_temp "\*.code")
        Loop, % a_temp "\*.code"
            FileDelete, %a_loopfilefullpath%

    ExitApp
;}

;[Functions]{
; Gui related functions
FirstRun(){
    global

    Gui, +DelimiterSpace
    Gui, add, GroupBox, y5 w345 h95, % "General Preferences"
    Gui, add, Text, xp+10 yp+20 w325, % "This is the first time you are running " script.name ".`n"
                                      . "Here you can set some general options for the program.`n`n"
                                      . "You can change them at any time later on by going to the `n""Settings >"
                                      . " Preferences"" Menu."
    Gui, add, GroupBox, x10 y+15 w345 h70, % "Startup"
    Gui, add, CheckBox, xp+25 yp+20 Checked v_ssi, % "Show splash image"
    Gui, add, CheckBox, x+70 Checked v_sww, % "Start with Windows"
    Gui, add, CheckBox, x35 y+10 Checked v_smm, % "Start minimized"
    Gui, add, CheckBox, x+91 Checked v_cfu, % "Check for updates"

    Gui, add, GroupBox, x10 y+20 w345 h55, % "Main GUI Hotkey"
    Gui, add, DropDownList, xp+10 yp+20 w140 HWND$hkddl v_hkddl, % lst := "None  " klist("all^", "mods msb")
    SetHotkeys(lst,$hkddl, "First Run")
    Gui, add, CheckBox, x+10 yp+3 v_ctrl, % "Ctrl"
    Gui, add, CheckBox, x+10 v_alt, % "Alt"
    Gui, add, CheckBox, x+10 v_shift, % "Shift"
    Gui, add, CheckBox, x+10 v_win, % "Win"

    Gui, add, GroupBox, x10 y+26 w345 h70, % "Other Tools"
    Gui, add, CheckBox, xp+15 yp+20 Checked v_ecd, % "Enable Code Detection"
    Gui, add, CheckBox, x+60 Checked v_ech, % "Enable Command Helper"
    Gui, add, CheckBox, x25 y+10 Checked v_eft, % "Enable Forum Tag-AutoComplete"
    Gui, add, CheckBox, x+14 Checked v_est, % "Enable Screen Tools"
    Gui, add, Text, x20 y+30 w325
              , % "Note:`n"
                . "The default hotkey is Win + ``  (Win key + Back tic)"

    Gui, add, Text, x0 y+10 w370 0x10
    Gui, add, Button, xp+280 yp+10 w75 gGuiHandler, % "&Save"
    Gui, show, w365 h405, % "First Run"

    Pause
}
TrayMenu(){
    Menu, Tray, Icon, res/AHK-TK.ico
    Menu, Tray, Tip, % script.name " v" script.version " [" (a_isunicode ? "W" : "A") "]"
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1
    Menu, Tray, add, % "Show Main Gui", GuiClose
    Menu, Tray, Default, % "Show Main Gui"
    Menu, Tray, add
    Menu, Tray, Standard
}
MainMenu(){
    conf.load(script.conf), root:=conf.documentElement,options:=root.firstChild
    Menu, iexport, add, Import Hotkeys/Hotstrings, MenuHandler
    Menu, iexport, add
    Menu, iexport, add, Export Hotkeys/Hotstrings, MenuHandler

    Menu, File, add, &New`t(Ctrl+N), MenuHandler
    Menu, File, add, Delete`t(DEL), MenuHandler
    Menu, File, add
    Menu, File, add, &Open`t(Ctrl+O), MenuHandler
    Menu, File, disable, &Open`t(Ctrl+O)
    Menu, File, add, &Save`t(Ctrl+S), MenuHandler
    Menu, File, disable, &Save`t(Ctrl+S)
    Menu, File, add, Save As`t(Ctrl+Shift+S), MenuHandler
    Menu, File, disable, Save As`t(Ctrl+Shift+S)
    Menu, File, add
    Menu, File, add, Import/Export, :iexport
    Menu, File, add
    Menu, File, add, Exit, Exit

    Menu, LO, add, Duplicate Line`t(Ctrl+D), MenuHandler
    Menu, LO, add, Split Lines`t(Ctrl+I), MenuHandler
    Menu, LO, add, Join Lines`t(Ctrl+J), MenuHandler
    Menu, LO, add, Move up current Line`t(Ctrl+Shift+Up), MenuHandler
    Menu, LO, add, Move down current Line`t(Ctrl+Shift+Down), MenuHandler

    Menu, Convert Case,add, Convert to Lowercase`t(Ctrl+U), MenuHandler
    Menu, Convert Case,add, Convert to Uppercase`t(Ctrl+Shift+U), MenuHandler

    Menu, Edit, add, Undo`t(Ctrl+Z), MenuHandler
    Menu, Edit, disable, Undo`t(Ctrl+Z)
    Menu, Edit, add, Redo`t(Ctrl+Y), MenuHandler
    Menu, Edit, disable, Redo`t(Ctrl+Y)
    Menu, Edit, add
    Menu, Edit, add, Cut`t(Ctrl+X), MenuHandler
    Menu, Edit, add, Copy`t(Ctrl+C), MenuHandler
    Menu, Edit, add, Paste`t(Ctrl+V), MenuHandler
    Menu, Edit, add, Select All`t(Ctrl+A), MenuHandler
    Menu, Edit, add
    Menu, Edit, add, Convert Case, :Convert Case
    Menu, Edit, add, Line Operations, :LO
    Menu, Edit, add, Trim Trailing Space`t(Ctrl+Space), MenuHandler
    Menu, Edit, add
    Menu, Edit, add, Set Read Only, MenuHandler

    Menu, Search, add, Find...`t(Ctrl+F), MenuHandler
    Menu, Search, add, Find in Files...`t(Ctrl+Shift+F), MenuHandler
    Menu, Search, add, Find Next...`t(F3), MenuHandler
    Menu, Search, add, Find Previous...`t(Shift+F3), MenuHandler
    Menu, Search, add, Find && Replace`t(Ctrl+H), MenuHandler
    Menu, Search, add, Go to Line`t(Ctrl+G), MenuHandler
    Menu, Search, add, Go to Matching Brace`t(Ctrl+B), MenuHandler
    Menu, Search, disable, Go to Matching Brace`t(Ctrl+B)

    Menu, Symbols, add, Show Spaces and TAB, MenuHandler
    Menu, Symbols, add, Show End Of Line, MenuHandler
    Menu, Symbols, add, Show All Characters, MenuHandler

    Menu, Zoom, add, Zoom in`t(Ctrl+Numpad +), MenuHandler
    Menu, Zoom, add, Zoom out`t(Ctrl+Numpad -), MenuHandler
    Menu, Zoom, add, Default Zoom`t(Ctrl+=), MenuHandler

    Menu, View, add, Always On Top, MenuHandler
    Menu, View, add, Snippet Library, MenuHandler
    Menu, View, disable, Snippet Library
    Menu, View, add
    Menu, View, add, Show Symbols, :Symbols
    Menu, View, disable, Show Symbols
    Menu, View, add, Zoom, :Zoom
    Menu, View, disable, Zoom
    Menu, View, add, Line Wrap, MenuHandler
    Menu, View, disable, Line Wrap

    Menu, RCW, add, L-Ansi, MenuHandler
    Menu, RCW, add, L-Unicode, MenuHandler
    Menu, RCW, add, Basic, MenuHandler
    Menu, RCW, add, IronAHK, MenuHandler

    Menu, Settings, add, Run Code With, :RCW
    Menu, Settings, disable, Run Code With
    Menu, Settings, add, Enable Command Helper, MenuHandler
    Menu, Settings, disable, Enable Command Helper
    Menu, Settings, add, Context Menu Options, MenuHandler
    Menu, Settings, disable, Context Menu Options
    Menu, Settings, add
    Menu, Settings, add, &Preferences`t(Ctrl+P), MenuHandler

    Menu, Help, add, Help, MenuHandler
    Menu, Help, disable, Help
    Menu, Help, add, Documentation, MenuHandler
    Menu, Help, disable, Documentation
    Menu, Help, add, Check for Updates, MenuHandler
    Menu, Help, add
    Menu, Help, add, About, MenuHandler

    Menu, MainMenu, add, File, :File
    Menu, MainMenu, add, Edit, :Edit
    Menu, MainMenu, disable, Edit
    Menu, MainMenu, add, Search, :Search
    Menu, MainMenu, disable, Search
    Menu, MainMenu, add, View, :View
    Menu, MainMenu, add, Settings, :Settings
    Menu, MainMenu, add, Help, :Help

    rcwSet()

    if root.selectSingleNode("//@alwaysontop").text
        Menu, View, check, Always On Top

    if options.selectSingleNode("//@snplib").text
        Menu, View, check, Snippet Library

    if options.selectSingleNode("//@linewrap").text
        Menu, View, check, Line Wrap

    if options.selectSingleNode("//@sci").text
        Menu, Settings, check, Enable Command Helper

    return
}
ForumMenu(){

    Menu, Color, Add, Custom, MenuHandler
    Menu, Color, Add, Dark Red, MenuHandler
    Menu, Color, Add, Red, MenuHandler
    Menu, Color, Add, Orange, MenuHandler
    Menu, Color, Add, Brown, MenuHandler
    Menu, Color, Add, Yellow, MenuHandler
    Menu, Color, Add, Green, MenuHandler
    Menu, Color, Add, Olive, MenuHandler
    Menu, Color, Add, Cyan, MenuHandler
    Menu, Color, Add, Blue, MenuHandler
    Menu, Color, Add, Dark Blue, MenuHandler
    Menu, Color, Add, Indigo, MenuHandler
    Menu, Color, Add, Violet, MenuHandler
    Menu, Color, Add, White, MenuHandler
    Menu, Color, Add, Black, MenuHandler

    Menu, Size, Add, Custom, MenuHandler
    Menu, Size, Add, Tiny, MenuHandler
    Menu, Size, Add, Small, MenuHandler
    Menu, Size, Add, Normal, MenuHandler
    Menu, Size, Add, Large, MenuHandler
    Menu, Size, Add, Huge, MenuHandler
}
SnippetMenu(){
    global

    Menu, Snippet, add, New, MenuHandler
    Menu, Snippet, add
    Menu, Snippet, add, Edit, MenuHandler
    Menu, Snippet, add, Rename, MenuHandler
    ; Menu, Snippet, add
    Menu, Snippet, add, Delete, MenuHandler
    return
}
CreateGui(){
    global $hwnd1

    MainGui(), AddHKGui(), AddHSGui(), ImportGui(), ExportGui(), PreferencesGui()
    SnippetGui(), AboutGui(), PasteUploadGui(), CodetPopup(), AreaSlectionGui(), SetHotkeys("main", $hwnd1)
    SetSciStyles()
    return
}
MainGui(){
    global
    OnMessage(WM("COMMAND"),"MsgHandler")

    _aot := (root.attributes.item[1].text ? "+" : "-") "AlwaysOnTop"
    Gui, 01: +LastFound +Resize +MinSize650x300 %_aot%
    $hwnd1 := WinExist(), MainMenu(), _aot:=null
    tabLast := "Hotkeys"    ; Helps when deleting an item on the Hotkeys tab, before actually clicking the tabs.

    Gui, 01: menu, MainMenu
    Gui, 01: add, Tab2, x0 y0 w800 h400 HWND$tabcont gGuiHandler vtabLast, % "Hotkeys|Hotstrings|Live Code"
    Gui, 01: add, StatusBar, HWND$StatBar

    updateSB()

    _cnt := root.selectSingleNode("//Hotkeys/@count").text
    Gui, 01: tab, Hotkeys
    Gui, 01: add, ListView, w780 h315 HWND$hkList Count%_cnt% Sort Grid AltSubmit gListHandler vhkList
                          , % "Type|Program Name|Hotkey|Program Path / Script Preview"
    Gui, 01: add, ListView, w780 h315 xp yp HWND$shkList Count%_cnt% Sort Grid AltSubmit gListHandler vshkList
                          , % "Type|Program Name|Hotkey|Program Path"

    GuiControl, hide, shkList

    Load("Hotkeys")

    Gui, 01: add, Text, x0 y350 w820 0x10 HWND$hkDelim
    Gui, 01: font, s8 cGray italic, Verdana
    Gui, 01: add, Edit, x10 yp+10 w250 HWND$QShk gGuiHandler vQShk, % "Quick Search"
    Gui, 01: font
    Gui, 01: add, Button, x+370 yp w75 HWND$hkAdd Default gGuiHandler, % "&Add"
    Gui, 01: add, Button, x+10 yp w75 HWND$hkClose gGuiHandler, % "&Close"

    _cnt := root.selectSingleNode("//Hotstrings/@count").text
    Gui, 01: Tab, Hotstrings
    Gui, 01: add, ListView, w780 h205 HWND$hsList Count%_cnt% Grid AltSubmit gListHandler vhsList
                          , % "Type|Options|Abbreviation|Expand To"
    Gui, 01: add, ListView, w780 h205 xp yp HWND$shsList Count%_cnt% Grid AltSubmit gListHandler vshsList
                          , % "Type|Options|Abbreviation|Expand To"

    GuiControl, hide, shsList

    Gui, 01: add, Groupbox, w780 h105 HWND$hsGbox, % "Quick Add"
    Gui, 01: add, Text, xp+100 yp+20 HWND$hsText1, % "Expand:"
    Gui, 01: font, s8 cGray italic, Verdana
    Gui, 01: add, Edit, x+10 yp-3 w150 HWND$hsExpand vhsExpand, % "e.g. btw"
    Gui, 01: font
    Gui, 01: add, Text, x+10 yp+3 HWND$hsText2, % "To:"
    Gui, 01: font, s8 cGray italic, Verdana
    Gui, 01: add, Edit, x+10 yp-3 w250 HWND$hsExpandto vhsExpandto, % "e.g. by the way"
    Gui, 01: font
    Gui, 01: add, Checkbox, x+10 yp+5 HWND$hsCbox1 vhsIsCode, % "Run as Script"
    Gui, 01: add, CheckBox, x112 y+15 HWND$hsCbox2 Checked vhsAE, % "AutoExpand"
    Gui, 01: add, CheckBox, xp+235 yp HWND$hsCbox3 vhsDND, % "Do not delete typed abbreviation"
    Gui, 01: add, CheckBox, x112 y+10 HWND$hsCbox4 vhsTIOW, % "Trigger inside other words"
    Gui, 01: add, CheckBox, xp+235 yp HWND$hsCbox5 vhsSR, % "Send Raw (do not translate {Enter} or {key})"

    Load("HotStrings")

    Gui, 01: add, Text, x0 y350 w820 0x10 HWND$hsDelim
    Gui, 01: font, s8 cGray italic, Verdana
    Gui, 01: add, Edit, x10 yp+10 w250 HWND$QShs gGuiHandler vQShs, % "Quick Search"
    Gui, 01: font
    Gui, 01: add, Button, x+370 yp w75 HWND$hsAdd Default gGuiHandler, % "&Add"
    Gui, 01: add, Button, x+10 yp w75 HWND$hsClose gGuiHandler, % "&Close"

    Gui, 01: Tab, Live Code
    options.selectSingleNode("//@snplib").text ? w:=640 : w:=790
    sci[1] := new scintilla($hwnd1,5,25,w,320, "lib", "hidden")

    Gui, 01: add, Text, x650 y25 w145 h17 HWND$slTitle Center Border Hidden, % "Snippet Library"
    Gui, 01: add, DropDownList, xp y+5 w145 HWND$slDDL Hidden gGuiHandler Sort vslDDL
    _current := options.selectSingleNode("//SnippetLib/@current").text
    _cnt := options.selectSingleNode("//Group[@name='" _current "']/@count").text
    Gui, 01: add, ListView
                , w145 h270 HWND$slList -Hdr -ReadOnly Count%_cnt% AltSubmit Sort Grid Hidden gListHandler vslList
                , % "Title"

    Load("SnpLib")

    Gui, 01: add, Text, x0 y350 w820 0x10 HWND$lcDelim
    Gui, 01: font, s8 cGray italic, Verdana
    Gui, 01: add, Edit, x10 yp+10 w250 Disabled HWND$QSlc gGuiHandler vQSlc, % "Quick Search"
    Gui, 01: font
    Gui, 01: add, Button, x+370 yp w75 HWND$lcRun gGuiHandler, % "&Run"
    Gui, 01: add, Button, x+10 yp w75 HWND$lcClear gGuiHandler, % "&Clear"
    GuiAttach(1),SetSciMargin(sci[1])

    ; The following is used in the message handler to get the ID
    ; of the edit controls so we can change their font (quick search controls)
    WinGet, cList1, ControlList
    WinGet, hList1, ControlListHWND

    hide := options.selectSingleNode("//@smm").text ? "Hide" : ("", main_toggle:=1)

    current:=cnt:=null

    ; I remove one pixel from w800 to cover the delimiter line on the right side
    ;
    ; The attach function redraws the tab on top of the Status bar.
    ; I made it so that the window is a little bit below the tab to avoid overlapping
    ; hence the h422.
    Gui, 01: show, w799 h422 %hide%, % "AutoHotkey Toolkit [" (a_isunicode ? "W" : "A") "]"
    return
}
AddHKGui(){
    global

    Gui, 02: +LastFound +Resize +MinSize +Owner1 +DelimiterSpace
    $hwnd2 := WinExist()

    Gui, 02: add, GroupBox, w240 h55, % "Hotkey Name"
    Gui, 02: add, Edit, x20 yp+20 w220 HWND$hkName vhkName

    Gui, 02: add, GroupBox, xp-10 yp+40 w350 h70, % "Hotkey Type"
    Gui, 02: add, Radio, xp+10 yp+20 Checked gGuiHandler vhkType, % "Script"
    Gui, 02: add, Radio, x+20 gGuiHandler, % "File"
    Gui, 02: add, Radio,x+20 gGuiHandler, % "Folder"
    Gui, 02: add, Edit, x20 yp+20 w220 Disabled HWND$hk2Path vhkPath, %a_programfiles%
    Gui, 02: add, Button, x+10 w100 Disabled HWND$hk2Browse gGuiHandler, % "&Browse..."

    Gui, 02: add, GroupBox, x10 w350 h70, % "Select Hotkey"

    Gui, 02: add, CheckBox, xp+10 yp+33 vhkctrl, % "Ctrl"
    Gui, 02: add, CheckBox, x+10 vhkalt, % "Alt"
    Gui, 02: add, CheckBox, x+10 vhkshift, % "Shift"
    Gui, 02: add, CheckBox, x+10 vhkwin, % "Win"
    Gui, 02: add, DropDownList, x+10 yp-3 w140 vhkey, % lst := "None  " klist("all^", "mods msb")
    ; SetHotkeys(lst,$hkddl, "Add Hotkey")

    Gui, 02: add, GroupBox, x+20 y6 w395 h205, % "Advanced Options"
    Gui, 02: add, Text,xp+10 yp+15, % "Note: Comma delimited, case insensitive and accepts RegExs"
    Gui, 02: font, s8 cGray italic, Verdana
    Gui, 02: add, Edit, w375 HWND$hkIfWin vhkIfWin, % "If window active list (e.g. Winamp, Notepad, Fire.*)"
    Gui, 02: add, Edit, wp HWND$hkIfWinN vhkIfWinN
                      , % "If window NOT active list (e.g. Notepad++, Firefox, post.*\s)"
    Gui, 02: font
    Gui, 02: add, Checkbox, xp y+5 vhkLMod, % "Left mod: only use left modifier key"
    Gui, 02: add, Checkbox, vhkRMod, % "Right mod: only use right modifier key"
    Gui, 02: add, Checkbox, vhkWild, % "Wildcard: fire with other keys           "
    Gui, 02: add, Checkbox, vhkSend, % "Send key to active window"
    Gui, 02: add, Checkbox, vhkHook, % "Install hook"
    Gui, 02: add, Checkbox, vhkfRel, % "Fire when releasing key"

    sci[2] := new scintilla($hwnd2,10,220,750,250,"lib")

    Gui, 02: add, Text, x0 y+280 w785 0x10 HWND$hk2Delim
    Gui, 02: add, Button, x600 yp+10 w75 HWND$hk2Add Default gGuiHandler, % "&Add"
    Gui, 02: add, Button, x+10 yp w75 HWND$hk2Cancel gGuiHandler, % "&Cancel"
    GuiAttach(2),SetSciMargin(sci[2])

    WinGet, cList2, ControlList
    WinGet, hList2, ControlListHWND

    Gui, 02: show, w770 h520 Hide, % "Add Hotkey"
    return
}
AddHSGui(){
    global

    Gui, 03: +LastFound +Resize +MinSize +Owner1
    $hwnd3 := WinExist()

    Gui, 03: add, GroupBox, w180 h55, % "Hotstring Options"
    Gui, 03: font, s8 cGray italic, Verdana
    Gui, 03: add, Edit, xp+10 yp+20 w70 HWND$hsOpt vhsOpt, % "e.g. rc*"
    Gui, 03: font
    Gui, 03: add, Checkbox, x+5 yp+3 gGuiHandler vhs2IsCode, % "Run as Script"

    Gui, 03: add, GroupBox, x+20 yp-23 w210 h55, % "Expand"
    Gui, 03: font, s8 cGray italic, Verdana
    Gui, 03: add, Edit, xp+10 yp+20 w190 HWND$hs2Expand vhs2Expand, % "e.g. btw"
    Gui, 03: font

    Gui, 03: add, GroupBox,x10 y+20 w400 h100, % "Advanced Options"
    Gui, 03: add, Text, xp+10 yp+20, % "Note: Comma delimited, case insensitive and accepts RegExs"
    Gui, 03: font, s8 cGray italic, Verdana
    Gui, 03: add, Edit, w380 HWND$hsIfWin vhsIfWin, % "If window active list (e.g. Winamp, Notepad, Fire.*)"
    Gui, 03: add, Edit, wp HWND$hsIfWinN vhsIfWinN
                      , % "If window NOT active list (e.g. Notepad++, Firefox, post.*\s)"
    Gui, 03: font

    Gui, 03: add, GroupBox, x10 w400 h300 HWND$hs2GBox, % "Expand to"
    sci[3] := new scintilla($hwnd3,20,195,380,265,"lib")

    Gui, 03: add, Text, x0 y+10 w440 0x10 HWND$hs2Delim
    Gui, 03: add, Button, xp+250 yp+10 w75 Default HWND$hs2Add gGuiHandler, % "&Add"
    Gui, 03: add, Button, x+10 yp w75 HWND$hsCancel gGuiHandler, % "&Cancel"
    GuiAttach(3),SetSciMargin(sci[3],0,0)

    WinGet, cList3, ControlList
    WinGet, hList3, ControlListHWND

    Gui, 03: show, w420 h530 Hide, % "Add Hotstring"
    return
}
ImportGui(){
    global

    Gui, 04: +LastFound +Resize +MinSize +Owner1
    $hwnd4 := WinExist()

    Gui, 04: add, GroupBox, w500 h100, % "Import from"
    Gui, 04: add, Radio, xp+10 yp+20 Checked gGuiHandler vimType , % "Folder"
    Gui, 04: add, Radio,x+10 gGuiHandler, % "File"
    Gui, 04: add, CheckBox, xp-58 y+10 HWND$imIncFolders Checked vimRecurse, % "Include subfolders"
    Gui, 04: add, CheckBox,x+10 Checked vimHK, % "Import Hotkeys"
    Gui, 04: add, CheckBox,x+10 Checked vimHS, % "Import Hotstrings"
    Gui, 04: add, Edit, x20 yp+20 w315 vimPath, % a_mydocuments
    Gui, 04: add, Button, x+10 w75 gGuiHandler, % "&Browse..."
    Gui, 04: add, Button, x+10 wp gGuiHandler, % "&Import"

    Gui, 04: add, ListView, x10 y+30 w500 r10 HWND$imList Sort Grid AltSubmit gListHandler vimList
                          , % "Type|Acelerator|Command|Path"

    Gui, 04: add, Text, x0 y+10 w540 0x10 HWND$imDelim
    Gui, 04: add, Button, xp+274 yp+10 w75 HWND$imAccept Default gGuiHandler, % "&Accept"
    Gui, 04: add, Button, x+1 yp w75 HWND$imClear gGuiHandler, % "C&lear"
    Gui, 04: add, Button, x+10 yp w75 HWND$imCancel gGuiHandler, % "&Cancel"
    GuiAttach(4)

    Gui, 04: show, w520 h340 Hide , % "Import"
    return
}
ExportGui(){
    global

    Gui, 05: +LastFound +Owner1
    $hwnd5 := WinExist()

    Gui, 05: add, GroupBox, w480 h80, % "Export to"
    Gui, 05: add, CheckBox,xp+10 yp+20 Checked vexHK, % "Export Hotkeys"
    Gui, 05: add, CheckBox,x+10 Checked vexHS, % "Export Hotstrings"
    Gui, 05: add, Edit, x20 yp+20 w375 vexPath, % a_mydocuments "\export_" subStr(a_now,1,8) ".ahk"
    Gui, 05: add, Button, x+10 w75 gGuiHandler, % "&Browse..."

    Gui, 05: add, Text, x0 y+30 w520 0x10
    Gui, 05: add, Button, xp+330 yp+10 w75 gGuiHandler, % "&Export"
    Gui, 05: add, Button, x+10 wp gGuiHandler, % "&Cancel"
    GuiAttach(5)

    Gui, 05: show, w500 h140 Hide, % "Export"
    return
}
PreferencesGui(){
    global

    Gui, 06: -MinimizeBox -MaximizeBox +LastFound +Owner1
    Gui, 06: Default
    $hwnd6 := WinExist()

    Gui, 06: add, TreeView, y30 w150 h260 AltSubmit -0x4 0x200 -Buttons -HScroll gListHandler vPrefList

    ;{ TreeView Item List
    $P1 := TV_Add("General Preferences", 0, "Expand")
        $P1C1 := TV_Add("Code Detection", $P1, "Expand")
            $C1C1 := TV_Add("Keywords", $P1C1, "Expand")
            $C1C2 := TV_Add("Pastebin Options", $P1C1, "Expand")
        $P1C2 := TV_Add("Command Helper", $P1, "Expand")
            $C2C1 := TV_Add("Options", $P1C2, "Expand")
        $P1C3 := TV_Add("Live Code", $P1, "Expand")
            $C3C1 := TV_Add("Run Code With", $P1C3, "Expand")
            $C3C2 := TV_Add("Keywords", $P1C3, "Expand")
            $C3C3 := TV_Add("Syntax Styles", $P1C3, "Expand")
        $P1C4 := TV_Add("Screen Tools", $P1, "Expand")
        ; $P1C4 := TV_Add("Script Manager", $P1, "Expand")
    ;}

    Gui, 06: font, s16
    Gui, 06: add, Text, x+5 y0 HWND$Title vTitle, % "General Preferences"
    Gui, 06: font
    Gui, 06: add, Text, x165 y+5 w370 0x10
    Gui, 06: add, Picture, x165 y36 vAHKTK_UC Hidden, % "res\img\AHK-TK_UnderConstruction.png"

    ;{ General Preferences GUI
    Gui, 98: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    $hwnd98 := WinExist()

    vars := "ssi|smm|sww|cfu"
    Loop, Parse, vars, |
        _%a_loopfield% := options.selectSingleNode("//@" a_loopfield).text

    Gui, 98: add, GroupBox, x3 y0 w345 h70, % "Startup"
    Gui, 98: add, CheckBox, xp+25 yp+20 Checked%_ssi% v_ssi gGuiHandler, % "Show splash image"
    Gui, 98: add, CheckBox, x+70 Checked%_sww% v_sww gGuiHandler, % "Start with Windows"
    Gui, 98: add, CheckBox, x28 y+10 Checked%_smm% v_smm gGuiHandler, % "Start minimized"
    Gui, 98: add, CheckBox, x+91 Checked%_cfu% v_cfu gGuiHandler, % "Check for updates"

    _mhk := options.selectSingleNode("MainKey").text
    vars := "ctrl|alt|shift|win"
    Loop, Parse, vars, |
        _%a_loopfield% := options.selectSingleNode("MainKey/@" a_loopfield).text
    _mods:=(_ctrl ? "^" : null)(_alt ? "!" : null)(_shift ? "+" : null)(_win ? "#" : null)

    Gui, 98: add, GroupBox, x3 y+20 w345 h55, % "Main GUI Hotkey"
    Gui, 98: add, CheckBox, xp+10 yp+23 Checked%_ctrl% HWND$_ctrl v_ctrl gGuiHandler, % "Ctrl"
    Gui, 98: add, CheckBox, x+10 Checked%_alt% HWND$_alt v_alt gGuiHandler, % "Alt"
    Gui, 98: add, CheckBox, x+10 Checked%_shift% HWND$_shift v_shift gGuiHandler, % "Shift"
    Gui, 98: add, CheckBox, x+10 Checked%_win% HWND$_win v_win gGuiHandler, % "Win"
    Gui, 98: add, DropDownList, x+10 yp-3 w140 HWND$GP_DDL v_hkddl gGuiHandler
                , % lst := "Default  " klist("all^", "mods msb")

    Control,ChooseString,%_mhk%,, ahk_id %$GP_DDL%
    ; SetHotkeys(lst,$GP_DDL, "Preferences")

    Gui, 98: add, GroupBox, x3 y+26 w345 h100 Disabled, % "Suspend hotkeys on these windows"
    Gui, 98: add, Edit, xp+10 yp+20 w325 h70 HWND$GP_E1 v_swl gGuiHandler Disabled
                , % options.selectSingleNode("SuspWndList").text

    Hotkey, % _mods _mhk, GuiClose

    Gui, 98: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Code Detection Preferences
    Gui, 97: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    $hwnd97 := WinExist()

    Gui, 97: add, GroupBox, x3 y0 w345 h145, % "Info"
    Gui, 97: add, Text, xp+10 yp+20 w330
                      , % "CODET attempts to detect AutoHotkey code copied to the clipboard.`n`n"
                        . "Then it allows you to upload the code to a pastebin service like the ones offered by "
                        . "www.autohotkey.net or www.pastebin.com.`n`n"
                        . "You can select the minimum amount of keywords to match "
                        . "and you can also edit the keyword list to add or delete words as you want to fine tune "
                        . "CODET to match your needs and avoid false detections.`n"

    Gui, 97: add, Text, x0 y+20 w360 0x10
    Gui, 97: add, GroupBox, x3 yp+10 w345 h70, % "General Preferences"

    codStat := options.selectSingleNode("//Codet/@status").text
    codMode := options.selectSingleNode("//Codet/@mode").text
    Gui, 97: add, CheckBox, xp+7 yp+20 HWND$codStat Checked%codStat% gGuiHandler vcodStat
                          , % "Enable Command Detection"
    Gui, 97: add, Radio, xp y+10 HWND$codMode1 gGuiHandler vcodMode, % "Show Popup"
    Gui, 97: add, Radio, x+10 HWND$codMode2 gGuiHandler, % "Automatic Upload"

    selRadio := codMode = 1 ? ("Show Popup", options.selectSingleNode("//Codet/@mode").text := 1)
                            : ("Automatic Upload", options.selectSingleNode("//Codet/@mode").text := 2)
    GuiControl, 97: , %selRadio%, 1

    Gui, 97: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Code Detection > Keywords Preferences
    Gui, 96: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    $hwnd96 := WinExist()

    Gui, 96: add, GroupBox, x3 y0 w345 h110, % "Info"
    Gui, 96: add, Text, xp+10 yp+20 w330
                      , % "There can be false detections because some AHK keywords can be found "
                        . "in normal text or other programming languages.`n`n"
                        . "Here you can select the minimum amount of keywords to match "
                        . "(the more the more accurate) and you can also add or delete words "
                        . "from the list of keywords to fine tune CODET to your liking."

    Gui, 96: add, Text, x0 y+20 w360 0x10
    Gui, 96: add, Edit, x3 yp+9 w345 h90 HWND$codKwords 0x100 gGuiHandler vcodKwords
                      , % options.selectSingleNode("//Codet/Keywords").text
    Gui, 96: add, Text, x3 y+8, % "Min. keyword match:"
    Gui, 96: add, Edit, x+10 yp-3 w25 Center gGuiHandler vcodMin
                      , % options.selectSingleNode("//Codet/Keywords/@min").text
    Gui, 96: font, s8 cGray italic, Verdana
    Gui, 96: add, Edit, x+11 w201 HWND$QScod Center gGuiHandler vQScod, % "Quick Search"
    Gui, 96: font

    Gui, 96: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Code Detection > Pastebin Preferences
    Gui, 95: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 ; +Border ; -WS_POPUP +WS_CHILD
    $hwnd95 := WinExist()

    curr:=options.selectSingleNode("//Codet/Pastebin/@current").text
    ahknet := curr = "Autohotkey.net" ? 1 : 0

    Gui, 95: add, GroupBox, x3 y0 w345 h110, % "Info"
    Gui, 95: add, Text, xp+10 yp+20 w330
                      , % "If AutoUpload is enabled you wont be prompted to select a Pastebin,`n"
                        . "instead the info will be retrieved from here.`n`n"
                        . "You can change the default options for the AutoUpload function here.`n`n"
                        . "For Pastebin.com click on the 'Get Key' button to get a user key."

    Gui, 95: add, Text, x0 y+20 w360 0x10
    Gui, 95: add, Text, x3 yp+10, % "Current Bin"
    Gui, 95: add, DropDownList, HWND$CP_DDL x3 y+10 w140 gGuiHandler vpbp_ddl
                              , % "AutoHotkey.net||Pastebin.com" ; |Gist.com"


    Gui, 95: add, Button, HWND$pbpButton1 x+10 yp w75 gGuiHandler Disabled, % "Get User Key"
    Gui, 95: add, Text, HWND$pbpText1 x3 y+15 w100, % ahknet ? "Nick" : "User Key"
    Gui, 95: add, Text, xp+150, % "Privacy"
    Gui, 95: add, Text, HWND$pbpText2 xp+80 Disabled, % "Expiration"
    Gui, 95: add, Edit, HWND$pbpText3 w140 x3 y+10 gGuiHandler vpbp_user
                      , % ahknet ? options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@nick").text
                                 : options.selectSingleNode("//Codet/Pastebin/PasteBin/@key").text

    Gui, 95: add, DropDownList, HWND$CP_DDL2 w70 x+10 gGuiHandler vpbp_exposure, % "Public||Private"

    Control,ChooseString
    ,% ahknet ? options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@private").text = 1 ? "Private" : "Public"
              : options.selectSingleNode("//Codet/Pastebin/PasteBin/@private").text = 1 ? "Private" : "Public"
    ,, ahk_id %$CP_DDL2%

    Gui, 95: add, DropDownList, HWND$CP_DDL3 w115 x+10 gGuiHandler vpbp_expiration Disabled
                              , % "Never|10 Minutes||1 Hour|1 Day|1 Month"

    Control,ChooseString
           ,% options.selectSingleNode("//Codet/Pastebin/PasteBin/@expiration").text
           ,, ahk_id %$CP_DDL3%

    Control,ChooseString,%curr%,, ahk_id %$CP_DDL%

    Gui, 95: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Command Helper
    Gui, 93: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border ; -WS_POPUP   +WS_CHILD
    $hwnd93 := WinExist()

    Gui, 93: add, GroupBox, x3 y0 w345 h150, % "Info"
    Gui, 93: add, Text, xp+10 yp+25 w330
                      , % "CMDHelper looks up the current selected word on the AHK help file.`n"
                        . "Optionally you can set it to use the online help in case you dont have ahk installed or "
                        . "if you are planning on sharing the link instead.`n`n"
                        . "If you have the Forums Tags options enable you can use the Tags hotkey "
                        . "to link the word under the cursor to the online documentation, providing an easy way "
                        . "to help users to inform themselves about the command you just mentioned in your reply.`n"

    Gui, 93: add, Text, x0 y+20 w360 0x10

    Gui, 93: add, GroupBox, x3 yp+10 w345 h70, % "Features"
    Gui, 93: add, CheckBox, xp+25 yp+20 HWND$cmdStat Checked%cmdStat% gGuiHandler vcmdStat, % "Enable CMDHelper"
    Gui, 93: add, CheckBox, xp+180 HWND$_uoh Checked%_uoh% gGuiHandler v_uoh, % "Use Online Help"
    Gui, 93: add, CheckBox, x28 y+10 HWND$_eie Checked%_eie% Disabled gGuiHandler v_eie
                          , % "Enable in Internal Editors"
    Gui, 93: add, CheckBox, xp+180 HWND$_eft Checked%_eft% gGuiHandler v_eft, % "AHK Forum Tags"

    Gui, 93: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Command Helper > Options
    Gui, 92: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border ; -WS_POPUP   +WS_CHILD
    $hwnd92 := WinExist()

    Gui, 92: add, GroupBox, x3 y0 w345 h60, % "Info"
    Gui, 92: add, Text, xp+10 yp+20 w330
                      , % "Open Help File searches the help file.`n"
                        . "Forum Tags adds [url] tags and autocompletes other forum tags."

    _hfhk := options.selectSingleNode("CMDHelper/HelpKey").text
    vars := "ctrl|alt|shift|win"
    Loop, Parse, vars, |
        _hf%a_loopfield% := options.selectSingleNode("CMDHelper/HelpKey/@" a_loopfield).text
    _mods:=(_hfctrl ? "^" : null)(_hfalt ? "!" : null)(_hfshift ? "+" : null)(_hfwin ? "#" : null)

    Gui, 92: add, GroupBox, x3 y+20 w345 h55, % "Open Help File"    ; y+26 to cover for checkbox lack of 3px
    Gui, 92: add, CheckBox, xp+10 yp+23 HWND$_hfctrl Checked%_hfctrl% v_hfctrl gGuiHandler, % "Ctrl"
    Gui, 92: add, CheckBox, x+10 HWND$_hfalt Checked%_hfalt% v_hfalt gGuiHandler, % "Alt"
    Gui, 92: add, CheckBox, x+10 HWND$_hfshift Checked%_hfshift% v_hfshift gGuiHandler, % "Shift"
    Gui, 92: add, CheckBox, x+10 HWND$_hfwin Checked%_hfwin% v_hfwin gGuiHandler, % "Win"
    Gui, 92: add, DropDownList, x+10 yp-3 w140 HWND$HF_DDL v_hfddl gGuiHandler
                , % lst := "Default  " klist("all^", "mods msb")

    Control,ChooseString,%_hfhk%,, ahk_id %$HF_DDL%
    Hotkey, % _mods _hfhk, OpenHelpFile

    _fthk := options.selectSingleNode("CMDHelper/TagsKey").text
    vars := "ctrl|alt|shift|win"
    Loop, Parse, vars, |
        _ft%a_loopfield% := options.selectSingleNode("CMDHelper/TagsKey/@" a_loopfield).text
    _mods:=(_ftctrl ? "^" : null)(_ftalt ? "!" : null)(_ftshift ? "+" : null)(_ftwin ? "#" : null)

    Gui, 92: add, GroupBox, x3 y+20 w345 h55, % "Forum Tags"
    Gui, 92: add, CheckBox, xp+10 yp+23 HWND$_ftctrl Checked%_ftctrl% v_ftctrl gGuiHandler, % "Ctrl"
    Gui, 92: add, CheckBox, x+10 HWND$_ftalt Checked%_ftalt% v_ftalt gGuiHandler, % "Alt"
    Gui, 92: add, CheckBox, x+10 HWND$_ftshift Checked%_ftshift% v_ftshift gGuiHandler, % "Shift"
    Gui, 92: add, CheckBox, x+10 HWND$_ftwin Checked%_ftwin% v_ftwin gGuiHandler, % "Win"
    Gui, 92: add, DropDownList, x+10 yp-3 w140 HWND$FT_DDL v_ftddl gGuiHandler
                , % lst := "Default  " klist("all^", "mods msb")

    Control,ChooseString,%_fthk%,, ahk_id %$FT_DDL%
    Hotkey, % _mods _fthk, ForumTags

    Gui, 92: add, GroupBox, x3 y+20 w345 h55, % "Help File Path"
    Gui, 92: add, Edit, xp+10 yp+23 w240 r1 vhfPath, % options.selectSingleNode("CMDHelper/HelpPath").text
    Gui, 92: add, Button, x+10 w75 gGuiHandler, % "&Browse..."

    Gui, 92: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Live Code
    ; Gui, 91: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    ; $hwnd91 := WinExist()
    ; Gui, 91: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Live Code > Run Code With
    ; Gui, 90: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    ; $hwnd90 := WinExist()
    ; Gui, 90: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Live Code > Keywords Preferences
    ; Gui, 89: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    ; $hwnd89 := WinExist()
    ; Gui, 89: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Live Code > Syntax Styles Preferences
    ; Gui, 88: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace ; +Border -WS_POPUP +WS_CHILD
    ; $hwnd88 := WinExist()
    ; Gui, 88: show, x165 y36 w350 h245 NoActivate
    ;}

    ;{ Screen Tools
    Gui, 87: -Caption +LastFound +Owner6 -0x80000000 +0x40000000 +DelimiterSpace  ; +Border -WS_POPUP +WS_CHILD
    $hwnd87 := WinExist()
    Gui, 87: show, x165 y36 w350 h245 NoActivate
    Gui, 87: add, GroupBox, x3 y0 w345 h170, % "Info"
    Gui, 87: add, Text, xp+10 yp+20 w330
                      , % "Screen Tools are there to allow you to take screenshots easily.`n`n"
                        . "The taken shot will be automatically uploaded to imgur and the`n"
                        . "link will be saved in the clipboard for easy sharing.`n`n"
                        . "Alt + Drag:   `tTakes a screenshot of selected area`n`n"
                        . "Alt + Click:  `tTakes a screenshot of active window`n`n"
                        . "Print Screen: `tIf enabled uploads a picture of the whole screen`n"
                        . "`t`tby pressing the 'Print Screen' button."

    Gui, 87: add, Text, x0 y+20 w360 0x10
    Gui, 87: add, GroupBox, x3 yp+10 w345 h50, % "General Preferences"

    scrStat := options.selectSingleNode("//ScrTools/@altdrag").text
    scrPrnt := options.selectSingleNode("//ScrTools/@prtscr").text
    Gui, 87: add, CheckBox, xp+7 yp+20 HWND$scrStat Checked%scrStat% gGuiHandler vscrStat
                          , % "Enable Screen Tools"
    Gui, 87: add, CheckBox, x+45 yp HWND$scrPrnt Checked%scrPrnt% gGuiHandler vscrPrnt
                          , % "Upload by Print Screen Hotkey"
    ;}

    Gui, 06: add, Text, x165 y+8 w370 0x10                          ; y is 10 - 2px of the Picture control.
    Gui, 06: add, Button, xp+105 yp+10 w75 gGuiHandler, % "&OK"
    Gui, 06: add, Button, x+10 w75 gGuiHandler, % "&Close"
    Gui, 06: add, Button, x+10 w75 HWND$Apply Disabled gGuiHandler, % "&Apply"


    Gui, 01: Default
    Gui, 06: show, w520 h330 Hide, % "Preferences"
    ; pause
    return
}
SnippetGui(){
    global

    Gui, 07: +LastFound +Resize +MinSize +Owner1
    $hwnd7 := WinExist(),SnippetMenu()

    Gui, 07: add, GroupBox, w260 h80, % "Info"
    Gui, 07: add, Text,xp+10 yp+20, % "Title:"
    Gui, 07: add, Edit, x60 yp-3 w200 vslTitle
    Gui, 07: add, Text, x20 y+13 , % "Group:"
    Gui, 07: add, ComboBox, x60 yp-3 w200 vslGroup

    node := options.selectSingleNode("//SnippetLib").childNodes
    current := options.selectSingleNode("//SnippetLib/@current").text

    Loop, % node.length
    {
        _group := node.item[a_index-1].selectSingleNode("@name").text
        if  (_group = current)
            GuiControl,7:,slGroup, %_group%||
        else
            GuiControl,7:,slGroup, %_group%
    }

    Gui, 07: add, GroupBox, x10 w470 h300 HWND$slGBox, % "Snippet"
    sci[4] := new scintilla($hwnd7,20,110,450,270,"lib")

    Gui, 07: add, Text, x0 y400 w500 0x10 HWND$slDelim
    Gui, 07: add, Button, xp+320 yp+10 w75 Default HWND$slAdd gGuiHandler, % "&Add"
    Gui, 07: add, Button, x+10 yp w75 HWND$slCancel gGuiHandler, % "&Cancel"
    GuiAttach(7), SetSciMargin(sci[4])

    Gui, 07: show, w490 h440 Hide, % "Add Snippet"
    return
}
AboutGui(){
    global
    OnMessage(WM("MOUSEMOVE"),"MsgHandler")

    Gui, 08: -Caption +LastFound +Owner1 +Border
    $hwnd8 := WinExist()

    info    := "Author`t`t  : " script.author " <" script.email ">`n"
            .  "Script Version`t  : " script.version " [" (a_isunicode ? "Unicode" : "ANSI") "]`n"
            .  "Homepage`t  : "

    info2   := "Creation Date`t  : " script.crtdate "`n"
            .  "Modification Date : " script.moddate

    License := "Copyright ©2010-2012 " script.author " <GPLv3>`n`n"
            .  "This program is free software: you can redistribute it and/or modify it`n"
            .  "under the terms of the GNU General Public License as published by`n"
            .  "the Free Software Foundation, either version 3 of  the  License,`n"
            .  "or (at your option) any later version.`n`n"

            .  "This program is distributed in the hope that it will be useful,`n"
            .  "but WITHOUT ANY WARRANTY; without even the implied warranty  of`n"
            .  "MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE.`n"
            .  "See  the GNU General Public License for more details.`n`n"

            .  "You should have received a copy of the GNU General Public License`n"
            .  "along with this program.  If not, see "

    Gui, 08: color, White, White
    Gui, 08: add, Picture, x0 y0, % "res\img\AHK-TK_About.png"
    Gui, 08: add, Text, x0 w450 0x10
    Gui, 08: add, Text, x10 yp+10, % info
    Gui, 08: font, cBlue underline
    Gui, 08: add, Text, xp+92 yp+27 gGuiHandler, % script.homepage
    Gui, 08: font
    Gui, 08: add, Text, x10 y+10, % info2
    Gui, 08: add, GroupBox, x10 y+10 w400 h220, % "License"
    Gui, 08: add, Text, xp+20 yp+20, % License
    Gui, 08: font, cBlue underline
    Gui, 08: add, Text, xp+169 yp+169  gGuiHandler, % "http://www.gnu.org/licenses/gpl-3.0.txt"
    Gui, 08: font
    Gui, 08: add, Text, x0 y+30 w450 0x10
    Gui, 08: add, Button, xp+250 yp+10 w75 Disabled gGuiHandler, % "Credits"
    Gui, 08: add, Button, x+10 w75 gGuiHandler, % "&Close"

    Gui, 08: show, w420 h490 Hide
    return
}
PasteUploadGui(){
    global

    Gui, 09: +LastFound +Resize +MinSize
    $hwnd9 := WinExist()

    curr:=options.selectSingleNode("//Codet/Pastebin/@current").text
    ahknet := curr = "AutoHotkey.net" ? 1 : 0

    sci[5] := new scintilla($hwnd9,10,5,620,400,"lib")
    Gui, 09: add, Text, HWND$puText1 x0 y410 w650 0x10
    Gui, 09: add, GroupBox, HWND$puGBox1 x10 yp+5 w620 h80, % "Options"
    Gui, 09: add, Text, HWND$puText2 xp+10 yp+20, % "Upload  to:"
    Gui, 09: add, Text, HWND$puText3 xp+135 w100, % "Nick"
    Gui, 09: add, Text, HWND$puText4 xp+135, % "Description"
    Gui, 09: add, Text, HWND$puText5 xp+135, % "Privacy"
    Gui, 09: add, Text, HWND$puText6 xp+80 Disabled, % "Expiration"
    Gui, 09: add, DropDownList, HWND$pb_ddl x20 y+10 w125 gGuiHandler vpb_ddl
                              , % "AutoHotkey.net||Pastebin.com" ; |Gist.com"


    Gui, 09: add, Edit, HWND$pb_name x+10 w125 vpb_name
                      , % ahknet ? options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@nick").text
                                 : NULL

    Gui, 09: add, Edit, HWND$pb_description x+10 w125 vpb_description
    Gui, 09: add, DropDownList, HWND$pb_exposure x+10 w70 vpb_exposure, % "Public||Private"

    Control,ChooseString
    ,% ahknet ? options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@private").text = 1 ? "Private" : "Public"
              : options.selectSingleNode("//Codet/Pastebin/PasteBin/@private").text = 1 ? "Private" : "Public"
    ,, ahk_id %$pb_exposure%

    Gui, 09: add, DropDownList, HWND$pb_expiration x+10 w115 vpb_expiration Disabled
                              , % "Never|10 Minutes||1 Hour|1 Day|1 Month"

    Control,ChooseString
           ,% options.selectSingleNode("//Codet/Pastebin/PasteBin/@expiration").text
           ,, ahk_id %$pb_expiration%

    Control,ChooseString,%curr%,, ahk_id %$pb_ddl%  ; all variables are created so when this triggers gui handler
                                                    ; there will be no issues.

    Gui, 09: add, Text, HWND$puText7 x0 w650 0x10
    Gui, 09: add, Button, HWND$puButton1 h25 x385 yp+10 w75 gGuiHandler Default, % "&Upload"
    Gui, 09: add, Button, HWND$puButton2 h25 x+10 yp w75 gGuiHandler, % "&Save to File"
    Gui, 09: add, Button, HWND$puButton3 h25 x+10 yp w75 gGuiHandler, % "&Cancel"
    GuiAttach(9),SetSciMargin(sci[5])

    Gui, 09: Show, w640 h550 Hide, % "Paste Upload"
    return
}
CodetPopup(){
    global

    Gui, 94: +LastFound -Caption +Border +AlwaysOnTop +ToolWindow
    ; $hwnd94 := WinExist()
    WinGet, $hwnd94, ID

    Gui, 94: Font, s10 w600, Verdana
    Gui, 94: add, Text, x0 w250 Center, % "AHK Code Detected"
    Gui, 94: add, Text, x0 w260 0x10
    Gui, 94: Font, s8 normal
    Gui, 94: add, Text, x5 yp+5 w250, % "You have copied text that contains some AutoHotkey Keywords. `n`n"
                                      . "Do you want to upload it to a pastebin service?"
    Gui, 94: add, Text, w260 x0 0x10
    Gui, 94: add, Button, x10 yp+10 w65 gGuiHandler, % "&Yes"
    Gui, 94: add, Button, x+5 w65 gGuiHandler, % "&No"
    codMode := options.selectSingleNode("//Codet/@mode").text = 1 ? 1 : 0
    Gui, 94: add, CheckBox, x+5 yp+6 Checked%codMode% gGuiHandler vpopup, % "Enable Popup"
    Gui, 94: Show, % "Hide w250 h150 x" system.mon.Right " y" system.mon.Bottom, % "Codet Popup"
    return
}
AreaSlectionGui(){
    global

    Gui, 99: -Caption +ToolWindow +AlwaysOnTop +Border
    Gui, 99: Color, 600000
    Gui, 99: Show, Hide, % "SelBox"
}
GuiAttach(guiNum){
    global $tabcont,$hkList,$hkDelim,$QShk,$hkAdd,$hkClose,$StatBar,$slTitle,$slDDL,$slList
         , $hsList,$hsGbox,$hsText1,$hsExpand,$hsText2,$hsExpandto,$hsCbox1,$hsCbox2,$hsCbox3,$hsCbox4,$hsCbox5
         , $hsDelim,$QShs,$hsAdd,$hsClose,$lcDelim,$QSlc,$lcRun,$lcClear,$hk2Delim
         , $hk2Add,$hk2Cancel,$hs2GBox,$hs2Delim,$hs2Add,$hsCancel
         , $imList,$imDelim,$imAccept,$imClear,$imCancel,$slGBox,$slDelim,$slAdd,$slCancel
         , $shsList,$shkList
         , $puText1,$puGBox1,$puText2,$puText3,$puText4,$puText5,$puText6,$pb_ddl,$pb_name,$pb_description
         , $pb_exposure,$pb_expiration,$puText7,$puButton1,$puButton2,$puButton3

    ; AutoHotkey ToolKit Gui
    if (guiNum = 1)
    {
        ; hotkeys tab
        attach($tabcont, "w h")
        attach($hkList, "w h")
        attach($shkList, "w h")
        attach($StatBar, "w r1")
        attach($hkDelim, "y w")
        attach($QShk, "y")
        attach($hkAdd, "x y r2"),attach($hkClose, "x y r2")

        ; hotstrings Tab
        c:="$hsText1|$hsExpand|$hsText2|$hsExpandto|$hsCbox1|$hsCbox2|$hsCbox3|$hsCbox4|$hsCbox5"
        Loop, Parse, c, |
            attach(%a_loopfield%, "x.5 y r1")

        attach($hsList, "w h r2")
        attach($shsList, "w h r2")
        attach($hsGbox, "y w r2")

        attach($hsDelim, "y w")
        attach($QShs, "y")
        attach($hsAdd, "x y r2"),attach($hsClose, "x y r2")

        ; Live Code Tab
        attach(sci[1].hwnd, "w h r2")
        attach($slTitle, "x")
        attach($slDDL, "x")
        attach($slList, "x h r2")
        attach($lcDelim, "y w")
        attach($QSlc, "y")
        attach($lcRun, "x y r2"),attach($lcClear, "x y r2")
    }

    ; Add Hotkey Gui
    if (guiNum = 2)
    {
        attach(sci[2].hwnd, "w h r2")
        attach($hk2Delim, "y w")
        attach($hk2Add, "x y r2"),attach($hk2Cancel, "x y r2")
    }

    ; Add Hotstring Gui
    if (guiNum = 3)
    {
        attach(sci[3].hwnd,"w h r2")
        attach($hs2GBox,"w h r2")
        attach($hs2Delim,"y w")
        attach($hs2Add,"x y r2"),attach($hsCancel,"x y r2")
    }

    ; Import Hotkeys/Hotstrings
    if (guiNum = 4)
    {
        attach($imList, "w h r2")
        attach($imDelim, "y w")
        attach($imAccept, "x y r2"),attach($imClear, "x y r2"),attach($imCancel, "x y r2")
    }

    ; Snippet Gui
    if (guiNum = 7)
    {
        attach(sci[4].hwnd, "w h r2")
        attach($slGBox, "w h r2")
        attach($slDelim, "y w")
        attach($slAdd, "x y r2")
        attach($slCancel, "x y r2")
    }

    ; Paste Upload Gui
    if (guiNum = 9)
    {
        attach(sci[5].hwnd, "w h r2")
        attach($puGBox1, "y w r2")

        Loop, 7
            (a_index = 1 || a_index = 7) ? attach($puText%a_index%, "y w r1") : attach($puText%a_index%, "x.5 y r1")

        c:="$pb_ddl|$pb_name|$pb_description|$pb_exposure|$pb_expiration"
        loop, parse, c, |
            attach(%a_loopfield%, "x.5 y r1")

        attach($puButton1, "x y r1"),attach($puButton2, "x y r1"),attach($puButton3, "x y r1")

    }
}
SetHotkeys(list=0, $hwnd=0, title=0){
    static lst, $lhwnd, ltitle

    if (list && list != "main")
    {
        $lhwnd:=$hwnd, ltitle:=title
        StringReplace, lst,list,None%a_space%%a_space% ; two spaces to select None
        Loop, Parse, lst, %a_space%
        {
            Hotkey, IfWinActive, %title%
            if strLen(a_loopfield) = 1
                Hotkey, %  a_loopfield, hkcAction
            else
                Hotkey, %a_loopfield%, hkcAction
            Hotkey, IfWinActive
        }
        return
    }
    else if (!list && !$hwnd && !title)
    {
        Loop, Parse, lst, %a_space%
        {
            Hotkey, IfWinActive, %ltitle%
            if strLen(a_loopfield) = 1
                Hotkey, %  a_loopfield, Toggle
            else
                Hotkey, %a_loopfield%, Toggle
            Hotkey, IfWinActive
        }
        return
    }

    if (list = "main")
    {
        Hotkey, IfWinActive, ahk_id %$hwnd%
        Hotkey, ^n, Gui_AddNew          ; Ctrl + N
        Hotkey, ^o, Gui_Open            ; Ctrl + O
        Hotkey, ^s, Gui_Save            ; Ctrl + S
        Hotkey, ^+s, Gui_SaveAs         ; Ctrl + Shift + S
        Hotkey, ^i, Gui_Import          ; Ctrl + I
        Hotkey, ^p, Gui_Preferences     ; Ctrl + P
        Hotkey, IfWinActive
    }
    return

    hkcAction:
        Control,ChooseString,%a_thishotkey%,, ahk_id %$lhwnd%
    return
}
SetSciMargin(lSci, n0=40, n1=10){

    lSci.SetMarginWidthN(0,n0),lSci.SetMarginWidthN(1,0),lSci.SetMarginWidthN(2,n1)
}
SetSciStyles(){
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

    Loop, % sci.MaxIndex()
    {
        cObj := a_index
        sci[cObj].SetLexer(2) ; SCLEX_AHK
        sci[cObj].SetWrapMode("SC_WRAP_WORD"), sci[cObj].StyleSetBold("STYLE_DEFAULT", true), sci[cObj].StyleClearAll()

        ; Setting up the keywords:
        Loop 7
        {
            listNum:=a_index-1
            sci[cObj].SetKeywords(listNum, (listNum = 0 ? options.selectSingleNode("//LiveCode/Keywords/FlowControl").text
                                          : listNum = 1 ? options.selectSingleNode("//LiveCode/Keywords/Commands").text
                                          : listNum = 2 ? options.selectSingleNode("//LiveCode/Keywords/Functions").text
                                          : listNum = 3 ? options.selectSingleNode("//LiveCode/Keywords/Directives").text
                                          : listNum = 4 ? options.selectSingleNode("//LiveCode/Keywords/Keys").text
                                          : listNum = 5 ? options.selectSingleNode("//LiveCode/Keywords/BuiltInVars").text
                                          : listNum = 6 ? options.selectSingleNode("//LiveCode/Keywords/Parameters").text))
        }

        sci[cObj].StyleSetFore("STYLE_LINENUMBER",0x8A8A8A), sci[cObj].StyleSetBold("STYLE_LINENUMBER", false)

        ; Setting up AHK lexer colors:
        bold := "0|1|2|4|5|6|7|8|9|17"
        colors=
        (LTrim Join| c
            0x000000    ; SCE_AHK_DEFAULT
            0x007700    ; SCE_AHK_COMMENTLINE
            0x007700    ; SCE_AHK_COMMENTBLOCK
            0xFF0000    ; SCE_AHK_ESCAPE
            0x000080    ; SCE_AHK_SYNOPERATOR
            0x000080    ; SCE_AHK_EXPOPERATOR
            0xA2A2A2    ; SCE_AHK_STRING
            0xFF9000    ; SCE_AHK_NUMBER
            0xFF9000    ; SCE_AHK_IDENTIFIER
            0xFF9000    ; SCE_AHK_VARREF
            0x0000FF    ; SCE_AHK_LABEL
            0x0000FF    ; SCE_AHK_WORD_CF
            0x0000FF    ; SCE_AHK_WORD_CMD
            0xFF0090    ; SCE_AHK_WORD_FN
            0xA50000    ; SCE_AHK_WORD_DIR
            0xA2A2A2    ; SCE_AHK_WORD_KB
            0xFF9000    ; SCE_AHK_WORD_VAR
            0x0000FF    ; SCE_AHK_WORD_SP
            0x00F000    ; SCE_AHK_WORD_UD
            0xFF9000    ; SCE_AHK_VARREFKW
            0xFF0000    ; SCE_AHK_ERROR
        )

        Loop, Parse, colors, |
            sci[cObj].StyleSetFore(a_index-1, a_loopfield)

        Loop, Parse, bold, |
            sci[cObj].StyleSetBold(a_loopfield, false)

        sci[cObj].StyleSetItalic(15, true) ; SCE_AHK_WORD_KB
    }
}
Add(type){
    global
    ; stupid ahk fails if i dont reload the freaking xml file in here again... tired of searching for the reason.
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

    local _code
    if (type = "hotkey")
    {
        Gui, 01: Default
        Gui, 01: ListView, hkList
        sci[2].GetText(sci[2].GetLength()+1,_hkscript)
        node := root.selectSingleNode("//Hotkeys")
        hkey := RegexReplace(hkey, "\'", "&apos;")
        if (editingHK)
        {
            editingHK := False
            Msgbox, 0x124
                  , % "Hotkey already present"
                  , % "The Hotkey you are trying to create already exist.`n"
                    . "Do you want to edit the existing hotkey?"

            IfMsgbox No
                return
            else
            {
                sci[2].GetText(sci[2].GetLength()+1,_hkscript)
                currNode := node.selectSingleNode("//hk[@key='" RegexReplace(oldkey, "\'", "&apos;") "']")
                currNode.attributes.getNamedItem("key").value := hkey
                currNode.attributes.getNamedItem("type").value := hkType
                currNode.selectSingleNode("name").text := hkName
                currNode.selectSingleNode("path").text := hkType != "Script" ? hkPath : ""
                currNode.selectSingleNode("script").text := _hkscript
                currNode.selectSingleNode("ifwinactive").text := inStr(hkIfWin, "e.g.") ? "" : hkIfWin
                currNode.selectSingleNode("ifwinnotactive").text := inStr(hkIfWinN, "e.g.") ? "" : hkIfWinN
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=null
            Load("Hotkeys")
            return
        }
        else
        {
            ; _code comes from import
            Hotkey, % RegexReplace(hkey, "&apos;", "'"), HotkeyHandler, On
            node.attributes.item[0].text() += 1
                _c := conf.createElement("hk")
                _c.setAttribute("type", hkType), _c.setAttribute("key", opts hkey) ; opts comes from import
                    _cc1 := conf.createElement("name"), _cc1.text := hkName
                    _cc2 := conf.createElement("path"), _cc2.text := hkType != "Script" ?(!hkPath ? _code : hkPath)
                                                                                        : ""
                    _cc3 := conf.createElement("script"), _cc3.text := !_hkscript ? _code : _hkscript
                    _cc4 := conf.createElement("ifwinactive"), _cc4.text := inStr(hkIfWin, "e.g.") ? "" : hkIfWin
                    _cc5 := conf.createElement("ifwinnotactive"),_cc5.text:=inStr(hkIfWinN, "e.g.")? "" : hkIfWinN
            Loop 5
                if (_cc%a_index%.text)
                    _c.appendChild(_cc%a_index%)
            node.appendChild(_c)

            _code := RegexReplace(_code, "(\n|\r)", "[``n]")
            _hkscript := RegexReplace(_hkscript, "(\n|\r)", "[``n]")

            LV_Add("", hkType
                     , hkName
                     , hkSwap(RegexReplace(hkey, "&apos;", "'"), "long")
                     , hkType != "Script" ? hkPath _code
                     : strLen(_hkscript _code)>40 ? subStr(_hkscript _code,1,40) "..." : _hkscript _code)
            Loop, 4
                LV_ModifyCol(a_index,"AutoHdr")
        }
        conf.transformNodeToObject(xsl, conf), updateSB()
        conf.save(script.conf), conf.load(script.conf) root:=options:=_c:=_cc1:=_cc2:=_cc3:=_cc4:=_cc5:=null
        return
    }

    if (type = "hotstring")
    {
        Gui, 01: Default
        Gui, 01: ListView, hsList
        node := root.selectSingleNode("//Hotstrings")

        if (editingHS)
        {
            editingHS := False
            Msgbox, 0x124
                  , % "Hotstring already present"
                  , % "The hotstring you are trying to create already exist.`n"
                    . "Do you want to edit the existing hotstring?"

            IfMsgbox No
                return
            else
            {
                sci[3].GetText(sci[3].GetLength()+1,hsExpandTo)
                currNode := node.selectSingleNode("//hs[expand='" RegexReplace(oldhs, "\'", "&apos;") "']")
                currNode.attributes.getNamedItem("iscode").value := hs2IsCode
                currNode.attributes.getNamedItem("opts").value := hsOpt
                currNode.selectSingleNode("expand").text := RegexReplace(hsExpand, "\'", "&apos;")
                currNode.selectSingleNode("expandto").text := hsExpandTo
                currNode.selectSingleNode("ifwinactive").text := inStr(hsIfWin, "e.g.") ? "" : hsIfWin
                currNode.selectSingleNode("ifwinnotactive").text := inStr(hsIfWinN, "e.g.") ? "" : hsIfWinN
                FileDelete, % a_temp "\hslauncher.code"
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=_c:=_cc1:=_cc2:=_cc3:=_cc4:=null
            Load("Hotstrings")
            return
        }
        else
        {
            node.attributes.item[0].text() += 1
                _c := conf.createElement("hs"), _c.setAttribute("iscode", hsIsCode)
                _c.setAttribute("opts", opts hsOpt) ; opts comes from import
                    _cc1 := conf.createElement("expand"), _cc1.text() := RegexReplace(hsExpand, "\'", "&apos;")
                    _cc2 := conf.createElement("expandto"), _cc2.text() := hsExpandTo
                    _cc3 := conf.createElement("ifwinactive"), _cc3.text() := inStr(hsIfWin, "e.g.") ? "" : hsIfWin
                    _cc4 := conf.createElement("ifwinnotactive"),_cc4.text():=inStr(hsIfWinN, "e.g.")? "" : hsIfWinN
            Loop 4
                if (_cc%a_index%.text)
                    _c.appendChild(_cc%a_index%)
            node.appendChild(_c)

            if RegexMatch(hsExpandTo, "(\n|\r)")
            {
                if (hsIsCode)
                    _code := "`n:" hsOpt ":" hsExpand "::`n" hsExpandTo "`nreturn`n"
                else
                    _code := "`n:" hsOpt ":" hsExpand "::`n(`n" hsExpandTo "`n)`nreturn`n"
            }
            else
            {
                if (hsIsCode)
                    _code := "`n:" hsOpt ":" hsExpand "::`n" hsExpandTo "`nreturn`n"
                else
                    _code := "`n:" hsOpt ":" hsExpand "::" hsExpandTo "`n"
            }

            hsExpandTo := RegexReplace(hsExpandTo, "(\n|\r)", "[``n]")

            LV_Add("", hsIsCode ? "Script" : "Text"
                     , opts hsOpt ; opts comes from import
                     , hsExpand
                     , strLen(hsExpandto) > 40 ? subStr(hsExpandto,1,40) "..." : hsExpandto)

            Loop, 4
                LV_ModifyCol(a_index,"AutoHdr")
        }
        FileAppend, %_code%, % a_temp "\hslauncher.code"

        If (a_ahkpath && FileExist(a_temp "\hslauncher.code"))
            Run, % a_ahkpath " " a_temp "\hslauncher.code",,, hslPID
        else
            Run, % "res\ahkl.bak " a_temp "\hslauncher.code",,, hslPID

        conf.transformNodeToObject(xsl, conf), updateSB()
        conf.save(script.conf), conf.load(script.conf) root:=options:=_c:=_cc1:=_cc2:=_cc3:=_cc4:=null
        return
    }

    if (type = "snippet")
    {
        Gui, 01: Default                            ; Fixes an issue with the List View
        Gui, 01: submit, NoHide                     ; Retrieve values from DropDown List
        Gui, 01: ListView, slList
        sci[4].GetText(sci[4].GetLength()+1, _snip)  ; Retrieve text from scintilla control

        node := options.selectSingleNode("//SnippetLib/Group[@name='" slGroup "']"), _groupExist := node.text
        if (editingNode)
        {
            editingNode := False
            _current := options.selectSingleNode("//SnippetLib/@current").text
            _groupNode :=  options.selectSingleNode("//Group[@name='" _current "']")    ; Select correct Group
            _editNode := _groupNode.selectSingleNode("Snippet[@title='" _seltxt "']")
            _editNode.setAttribute("title", slTitle), _editNode.text := _snip

            LV_Delete()
            GuiControl, -Redraw, slList

            node := options.selectSingleNode("//Group[@name='" slGroup "']").childNodes
            Loop, % node.length
                LV_Add("", node.item[a_index-1].selectSingleNode("@title").text)

            GuiControl, +Redraw, slList
        }
        else if (_groupExist)
        {
            node := options.selectSingleNode("//SnippetLib/Group[@name='" slGroup "']/@count")
            node.text := node.text + 1

            _p := options.selectSingleNode("//SnippetLib/Group[@name='" slGroup "']")
                _pc := conf.createElement("Snippet"), _pc.setAttribute("title", slTitle)
                        _cd := conf.createCDATASection("`n" _snip "`n`t`t`t`t`t")

            _pc.appendChild(_cd), _p.appendChild(_pc)
            options.selectSingleNode("//SnippetLib/@current").text := slGroup

            GuiControl,ChooseString,slDDL, %slGroup%
            LV_Add("",slTitle)
        }
        else
        {
            node := options.selectSingleNode("//SnippetLib")
            _p := conf.createElement("Group"), _p.setAttribute("name", slGroup), _p.setAttribute("count", 1)
                _pc := conf.createElement("Snippet"), _pc.setAttribute("title", slTitle)
                    _cd := conf.createCDATASection("`n" _snip "`n`t`t`t`t`t")

            _pc.appendChild(_cd), _p.appendChild(_pc)
            node.appendChild(_p), node.setAttribute("current", slGroup)
            node:=_p:=_pc:=_cd:=null

            GuiControl,07:,slGroup, %slGroup%||
            GuiControl,,slDDL, %slGroup%||

            LV_Delete()
            LV_Add("",slTitle)
        }

        node:=_p:=_pc:=_cd:=_editNode:=null                     ; Clean
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
    }
}
Load(type){
    global

    if (type = "Hotkeys")
    {
        Gui, 01: ListView, hkList

        LV_Delete()
        GuiControl, -Redraw, hkList

        conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
        node := options.selectSingleNode("//Hotkeys").childNodes
        Loop, % node.length
        {
            _path := node.item[a_index-1].selectSingleNode("path").text
            _script := RegexReplace(node.item[a_index-1].selectSingleNode("script").text, "(\n|\r)", "[``n]")
            _hk := RegexReplace(node.item[a_index-1].selectSingleNode("@key").text, "&apos;", "'")

            LV_Add("", node.item[a_index-1].selectSingleNode("@type").text
                     , node.item[a_index-1].selectSingleNode("name").text
                     , hkSwap(_hk, "long")
                     , _path ? _path : (strLen(_script) > 40 ? subStr(_script, 1, 40) "..." : _script))


            Hotkey,  % _hk, HotkeyHandler, On
        }
        LV_ModifyCol(2, "Center"), LV_ModifyCol(3, "Center")
        GuiControl, +Redraw, hkList
        return
    }

    if (type = "Hotstrings")
    {
        if !FileExist(a_temp "\hslauncher.code")
        {
            hsfileopts =
            (Ltrim
                ;+--> ; ---------[Directives]---------
                #NoEnv
                #SingleInstance Force
                #NoTrayIcon
                ; --
                SetBatchLines -1
                SendMode Input
                SetTitleMatchMode, Regex
                SetWorkingDir %a_scriptdir%
                ;-
                !F11::Suspend`n
            )
            FileAppend, %hsfileopts%, % a_temp "\hslauncher.code"
        }

        Gui, 01: ListView, hsList

        LV_Delete()
        GuiControl, -Redraw, hsList

        conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
        node := options.selectSingleNode("//Hotstrings").childNodes
        _code := ""             ; Clean code
        Loop, % node.length
        {
            _opts := node.item[a_index-1].selectSingleNode("@opts").text
            _iscode := node.item[a_index-1].selectSingleNode("@iscode").text
            _expand := RegexReplace(node.item[a_index-1].selectSingleNode("expand").text, "&apos;", "'")
            _expandto := node.item[a_index-1].selectSingleNode("expandto").text

            if RegexMatch(_expandto, "(\n|\r)")
            {
                if (_iscode)
                    _code .= "`n:" _opts ":" _expand "::`n" _expandto "`nreturn`n"
                else
                    _code .= "`n:" _opts ":" _expand "::`n(`n" _expandto "`n)`nreturn`n"
            }
            else
            {
                if (_iscode)
                    _code .= "`n:" _opts ":" _expand "::`n" _expandto "`nreturn`n"
                else
                    _code .= "`n:" _opts ":" _expand "::" _expandto "`n"
            }

            _expandto := RegexReplace(node.item[a_index-1].selectSingleNode("expandto").text, "(\n|\r)", "[``n]")

            LV_Add("", _iscode ? "Script" : "Text"
                     , _opts
                     , _expand
                     , strLen(_expandto) > 40 ? subStr(_expandto, 1, 40) "..." : _expandto)
        }
        FileAppend, %_code%, % a_temp "\hslauncher.code"

        If (a_ahkpath && FileExist(a_temp "\hslauncher.code"))
            Run, % a_ahkpath " " a_temp "\hslauncher.code",,, hslPID
        else
            Run, % "res\ahkl.bak " a_temp "\hslauncher.code",,, hslPID

        GuiControl, +Redraw, hsList
        return
    }

    if (type = "SnpLib")
    {
        LV_Delete()
        GuiControl,,slDDL,|
        GuiControl, -Redraw, slList

        conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
        current := options.selectSingleNode("//SnippetLib/@current").text
        node := options.selectSingleNode("//Group[@name='" current "']").childNodes
        Loop, % node.length
            LV_Add("", node.item[a_index-1].selectSingleNode("@title").text)

        GuiControl, +Redraw, slList

        node := options.selectSingleNode("//SnippetLib").childNodes
        Loop, % node.length
        {
            _group := node.item[a_index-1].selectSingleNode("@name").text
            if  (_group = current)
                GuiControl,,slDDL, %_group%||
            else
                GuiControl,,slDDL, %_group%
        }
        return
    }
}
GuiReset(guiNum){
    global

    if (guiNum = 01)        ; Add inline Hotstring
        _vals:="hsExpand¥e.g. btw¢hsExpandto¥e.g. by the way¢hsIsCode¥0¢hsAE¥1¢hsDND¥0¢hsTIOW¥0¢hsSR¥0"
    else if (guiNum = 02)   ; Add Hotkey Gui
    {
        _vals:="hkName¥¢hkType¥1¢hkPath¥" a_programfiles "¢hkctrl¥0¢hkalt¥0¢hkshift¥0¢hkwin¥0¢"
             . "hkey¥None  " klist("all^", "mods msb") "¢"
             . "hkIfWin¥If window active list (e.g. Winamp, Notepad, Fire.*)¢"
             . "hkIfWinN¥If window NOT active list (e.g. Notepad++, Firefox, post.*\s)¢"
             . "hkLMod¥0¢hkRMod¥0¢hkWild¥0¢hkSend¥0¢hkHook¥0¢hkfRel¥0"

        Control, disable,,,ahk_id %$hk2Path%
        Control, disable,,,ahk_id %$hk2Browse%
        sci[2].StyleResetDefault(), sci[2].ClearAll(), sci[2].SetReadOnly(false), SetSciMargin(sci[2])
    }
    else if (guiNum = 03)   ; Add Hotstring Gui
    {
        _vals:="hsOpt¥e.g. rc*¢hs2IsCode¥0¢hs2Expand¥e.g. btw¢"
             . "hsIfWin¥If window active list (e.g. Winamp, Notepad, Fire.*)¢"
             . "hsIfWinN¥If window NOT active list (e.g. Notepad++, Firefox, post.*\s)"
        sci[3].StyleResetDefault(), sci[3].ClearAll(), sci[3].SetReadOnly(false), SetSciMargin(sci[3],0,0)
    }
    else if (guiNum = 04)   ; Import Hotkeys/Hotstrings Gui
    {
        _vals:="imType¥1¢imRecurse¥1¢imHK¥1¢imHS¥1¢imPath¥" a_mydocuments
        Control, enable,,, ahk_id %$imIncFolders%
        Gui, 04: Default
        Gui, 04: ListView, imList
        LV_Delete()
    }
    else if (guiNum = 06)   ; Preferences
    {
        Gui, 06: Default
        Gui, 06: TreeView, PrefList
        ControlSetText,, General Preferences, ahk_id %$Title%
        TV_Modify($P1, "Select"),prefControl($P1)
    }
    else if (guiNum = 07)   ; Add Snippet
    {
        _vals:="slTitle¥¢"
        sci[4].StyleResetDefault(), sci[4].ClearAll(), sci[4].SetReadOnly(false)
    }
    else if (guiNum = 09)   ; Pastebin Upload
    {
        _vals := "pb_code¥¢pb_name¥¢pb_description¥"
        Control, disable,,, ahk_id %$pb_exposure%
        Control, disable,,, ahk_id %$pb_expiration%
    }

    Loop, Parse, _vals, ¢
    {
        Loop, Parse, a_loopfield, ¥
            _val%a_index%:=a_loopfield
        if inStr(a_loopfield, "e.g.")
        {
            Gui, %guiNum%: font, s8 cGray italic, Verdana
            GuiControl, %guiNum%: font, %_val1%
        }
        GuiControl, %guiNum%:, %_val1%, %_val2%
        Gui, %guiNum%: font
    }
    return
}
GuiClose(guiNum){
    global $hwnd1

    Gui, %guiNum%: Hide
    if (guiNum = 09)
        return
    WinActivate, ahk_id %$hwnd1%
    Gui, 01: -Disabled
    return
}
ApplyPref(){
    global      ; It accesses hotkey variables and others.
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

    ;{ General Preferences GUI
    ; Startup
    node := options.firstChild                              ; <-- Startup
        node.setAttribute("ssi", _ssi),node.setAttribute("sww", _sww)
        node.setAttribute("smm", _smm),node.setAttribute("cfu", _cfu)
        script.autostart(_sww)                              ; Save or Delete Registry Entry

    ; Main Hotkey
    node := options.childNodes.item[1]                      ; <-- MainKey
        ;{ Load old hotkey
        _octrl := node.attributes.item[0].text, _oalt := node.attributes.item[1].text
        _oshift := node.attributes.item[2].text, _owin := node.attributes.item[3].text
        _mhk := node.text
        ;}

        ;{ Disable Old Hotkey
        _mods:=(_octrl ? "^" : null)(_oalt ? "!" : null)(_oshift ? "+" : null)(_owin ? "#" : null)
        Hotkey, % _mods  _mhk, Off
        ;}

        ;{ Load new hotkey
        node.text := (_hkddl = "None" ? (, _ctrl:=_alt:=_shift:=0, _win:=1) : _hkddl)
        node.setAttribute("ctrl", _ctrl), node.setAttribute("alt", _alt)
        node.setAttribute("shift", _shift), node.setAttribute("win", _win)
        ;}

        ;{ Enable New Hotkey
        _mods:=(_ctrl ? "^" : null)(_alt ? "!" : null)(_shift ? "+" : null)(_win ? "#" : null)
        Hotkey, % _mods node.text, GuiClose, On
        ;}

    ; Suspend hotkeys on these windows
    node := options.childNodes.item[2]                      ; <-- SuspWndList
        node.text := _swl
    node := null
    ;}

    ;{ Code Detection Preferences
    ; Status
    options.selectSingleNode("//Codet/@status").text := codStat
    options.selectSingleNode("//Codet/@mode").text := codMode

    GuiControl, 94:, popup, % t := codMode = 1 ? 1 : 0
    ;}

    ;{ Code Detection > Keywords Preferences
    options.selectSingleNode("//Codet/Keywords/@min").text := codMin
    options.selectSingleNode("//Codet/Keywords").text := "`n" codKwords
    ;}

    ;{ Code Detection > Pastebin Preferences
    options.selectSingleNode("//Codet/Pastebin/@current").text := pbp_ddl

    ; AutoHotkey.net
    if (pbp_ddl = "AutoHotkey.net")
    {
        options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@private").text := pbp_exposure = "Private" ? 1 : 0
        options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@nick").text := pbp_user
    }
    ; PasteBin.com
    else if (pbp_ddl = "Pastebin.com")
    {
        options.selectSingleNode("//Codet/Pastebin/PasteBin/@private").text := pbp_exposure = "Private" ? 1 : 0
        options.selectSingleNode("//Codet/Pastebin/PasteBin/@key").text := pbp_user
        options.selectSingleNode("//Codet/Pastebin/PasteBin/@expiration").text := pbp_expiration
    }
    ;}

    ;{ Command Helper
    ; Status
    options.selectSingleNode("//CMDHelper/@global").text := cmdStat
    options.selectSingleNode("//CMDHelper/@sci").text := _eie
    options.selectSingleNode("//CMDHelper/@tags").text := _eft
    options.selectSingleNode("//CMDHelper/HelpPath/@online").text := _uoh
    ;}

    ;{ Command Helper > Options

    ; Help File
    node := options.selectSingleNode("//CMDHelper/HelpKey")
    ;{ Load old hotkey
    _octrl := node.attributes.item[0].text, _oalt := node.attributes.item[1].text
    _oshift := node.attributes.item[2].text, _owin := node.attributes.item[3].text
    _hfhk := node.text
    ;}

    ;{ Disable Old Hotkey
    _mods:=(_octrl ? "^" : null)(_oalt ? "!" : null)(_oshift ? "+" : null)(_owin ? "#" : null)
    Hotkey, % _mods _hfhk, Off
    ;}

    ;{ Load new hotkey
    node.text := (_hfddl = "None" ? ("F1", _hfalt:=_hfshift:=_hfwin:=0, _hfctrl := 1) : _hfddl)
    node.setAttribute("ctrl", _hfctrl), node.setAttribute("alt", _hfalt)
    node.setAttribute("shift", _hfshift), node.setAttribute("win", _hfwin)
    ;}

    ;{ Enable New Hotkey
    _mods:=(_hfctrl ? "^" : null)(_hfalt ? "!" : null)(_hfshift ? "+" : null)(_hfwin ? "#" : null)
    Hotkey, % _mods node.text, OpenHelpFile, On
    ;}

    ; Forum Tags
    node := options.selectSingleNode("//CMDHelper/TagsKey")
    ;{ Load old hotkey
    _octrl := node.attributes.item[0].text, _oalt := node.attributes.item[1].text
    _oshift := node.attributes.item[2].text, _owin := node.attributes.item[3].text
    _fthk := node.text
    ;}

    ;{ Disable Old Hotkey
    _mods:=(_octrl ? "^" : null)(_oalt ? "!" : null)(_oshift ? "+" : null)(_owin ? "#" : null)
    Hotkey, % _mods _fthk, Off
    ;}

    ;{ Load new hotkey
    node.text := (_ftddl = "None" ? ("F2", _ftalt:=_ftshift:=_ftwin:=0, _ftctrl := 1) : _ftddl)
    node.setAttribute("ctrl", _ftctrl), node.setAttribute("alt", _ftalt)
    node.setAttribute("shift", _ftshift), node.setAttribute("win", _ftwin)
    ;}

    ;{ Enable New Hotkey
    _mods:=(_ftctrl ? "^" : null)(_ftalt ? "!" : null)(_ftshift ? "+" : null)(_ftwin ? "#" : null)
    Hotkey, % _mods node.text, ForumTags, On
    ;}


    ; File Path
    options.selectSingleNode("//CMDHelper/HelpPath").text := hfPath
    ;}

    ;{ Screen Tools
    options.selectSingleNode("//ScrTools/@altdrag").text := scrStat
    options.selectSingleNode("//ScrTools/@prtscr").text := scrPrnt
    ;}

    conf.transformNodeToObject(xsl, conf)
    conf.save(script.conf), conf.load(script.conf)          ; Save and Load
    if !conf.xml
        MsgBox, 0x10
              , % "Operation Failed"
              , % "There was a problem while saving the settings.`n"
                . "The configuration file could not be reloaded."

    ; Update Pastebin Upload Gui
    if (pbp_ddl = "AutoHotkey.net")
    {
        Control,ChooseString,%pbp_exposure%,, ahk_id %$pb_exposure%
        Control,ChooseString,AutoHotkey.net,, ahk_id %$pb_ddl%
        ControlSetText,,%pbp_user%, ahk_id %$pb_name%
    }
    else if (pbp_ddl = "Pastebin.com")
    {
        Control,ChooseString,%pbp_exposure%,, ahk_id %$pb_exposure%
        Control,ChooseString,%pbp_expiration%,, ahk_id %$pb_expiration%
        Control,ChooseString,Pastebin.com,, ahk_id %$pb_ddl%
        ControlSetText,,, ahk_id %$pb_name%
    }

}

; Handlers
GuiHandler(){

    global

    if !a_gui
        return

    Gui, %a_gui%: submit, Nohide
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
    ; tooltip % a_guicontrol " " a_guievent

    ; Handling URLs
    if (inStr(a_guicontrol, "http://") || inStr(a_guicontrol, "www."))
    {
        Run, % RegexReplace(system.defBrowser, "\""?\%1\""?", """" a_guicontrol """")
        return
    }

    ; AutoHotkey ToolKit Gui
    if (a_gui = 01)
    {
        if (a_guicontrol = "tabLast")
        {
            action := tabLast = "Live Code" ? "show" : "hide"
            slControls:=$slTitle "|" $slDDL "|" $slList
            MenuHandler(tabLast = "Live Code" ? "enable" : "disable")
            Control,%action%,,, % "ahk_id " sci[1].hwnd

            if (action = "show")
                ControlFocus,, % "ahk_id " sci[1].hwnd

            if options.selectSingleNode("//@snplib").text != 0
                Loop, Parse, slControls, |
                    Control,%action%,,,ahk_id %a_loopfield%
            return
        }

        if (a_guicontrol = "&Save") ; From First Run GUI
        {
            defConf(script.conf)
            conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

            ; Startup Options:
            ; ssi = show splash image
            ; sww = start with windows
            ; smm = start minimized
            ; cfu = check for updates
            node := options.firstChild                              ; <-- Startup
                node.setAttribute("ssi", _ssi),node.setAttribute("sww", _sww)
                node.setAttribute("smm", _smm),node.setAttribute("cfu", _cfu)

            ; Main Hotkey:
            node := options.childNodes.item[1]                      ; <-- MainKey
                node.text := (_hkddl = "None" ? ("``", _win := 1) : _hkddl)
                node.setAttribute("ctrl", _ctrl), node.setAttribute("alt", _alt)
                node.setAttribute("shift", _shift), node.setAttribute("win", _win)

            ; Other Tools:
            ; ecd = enable command detection
            ; ech = enable command helper
            ; eft = enable forum tag-autocomplete
            ; est = enable screen tools
            node := options.childNodes.item[3]                      ; <-- Codet
                node.setAttribute("status", _ecd)

            node := options.childNodes.item[4]                      ; <-- CMDHelper
                node.setAttribute("global", _ech),node.setAttribute("sci", _ech)
                node.setAttribute("forum", _ech),node.setAttribute("tags", _eft)

            node := options.childNodes.item[6]                      ; <-- ScrTools
                node.setAttribute("altdrag", _est),node.setAttribute("prtscr", _est)
            node := null

            conf.transformNodeToObject(xsl, conf)
            conf.save(script.conf), conf.load(script.conf), root:=options:=null             ; Save & Clean

            Gui, destroy
            Pause                                                   ; UnPause
        }

        if (a_guicontrol = "slDDL")
        {
            Gui, 01: ListView, slList
            options.selectSingleNode("//SnippetLib/@current").text := slDDL
            node := options.selectSingleNode("//Group[@name='" slDDL "']").childNodes

            GuiControl, -Redraw, slList

            LV_Delete()
            Loop, % node.length
                LV_Add("", node.item[a_index-1].selectSingleNode("@title").text)

            GuiControl, +Redraw, slList
            conf.transformNodeToObject(xsl, conf)
            conf.save(script.conf), conf.load(script.conf)          ; Save and Load
            return
        }

        if (a_guicontrol = "QShk" && tabLast = "Hotkeys")
        {
            if (QShk && QShk != "Quick Search")
            {
                GuiControl, show, shkList
                GuiControl, hide, hkList
                Gui, 01: ListView, shkList
                LV_Delete()     ; Delete contents of shsList to avoid creating double results

                Gui, 01: ListView, hkList
                Loop, % LV_GetCount()
                {
                    Gui, 01: ListView, hkList
                    LV_GetText(_type, a_index, 1), LV_GetText(_name, a_index, 2)
                    LV_GetText(_hkey, a_index, 3), LV_GetText(_path, a_index, 4)
                    if (inStr(_name, QShk) || inStr(_path, QShk))
                    {
                        Gui, 01: ListView, shkList
                        LV_Add("", _type
                                 , _name
                                 , _hkey
                                 , _path)
                        Loop, 4
                            LV_ModifyCol(a_index, "AutoHdr")
                    }
                }
            }
            else
            {
                GuiControl, show, hkList
                GuiControl, hide, shkList
                Gui, 01: ListView, shkList
                LV_Delete()
            }
            return
        }

        if (a_guicontrol = "QShs" && tabLast = "Hotstrings")
        {
            if (QShs && QShs != "Quick Search")
            {
                GuiControl, show, shsList
                GuiControl, hide, hsList
                Gui, 01: ListView, shsList
                LV_Delete()     ; Delete contents of shsList to avoid creating double results

                Gui, 01: ListView, hsList
                Loop, % LV_GetCount()
                {
                    Gui, 01: ListView, hsList
                    LV_GetText(_type, a_index, 1), LV_GetText(_opts, a_index, 2)
                    LV_GetText(_expand, a_index, 3), LV_GetText(_expandto, a_index, 4)
                    if (inStr(_expand, QShs) || inStr(_expandto, QShs))
                    {
                        Gui, 01: ListView, shsList
                        LV_Add("", _type
                                 , _opts
                                 , _expand
                                 , _expandto)
                    }
                }
            }
            else
            {
                GuiControl, show, hsList
                GuiControl, hide, shsList
                Gui, 01: ListView, shsList
                LV_Delete()
            }
            return
        }

        if (a_guicontrol = "&Add" && tabLast = "Hotkeys")
        {
            Gui, 01: +Disabled
            Gui, 02: show
            return
        }

        if (a_guicontrol = "&Add" && tabLast = "Hotstrings")
        {
            if (inStr(hsExpand, "e.g.") || inStr(hsExpandto, "e.g."))
            {
                Gui, 01: +Disabled
                Gui, 03: show
                ControlFocus,, % "ahk_id " sci[3].hwnd
            }
            else
            {
                hsOpt := (hsAE ? "*" : "") (hsDND ? "B0" : "")
                      .  (hsTIOW ? "?" : "") (hsSR ? "R" : "")
                Add("hotstring"), GuiReset(01)
            }
            return
        }

        if (a_guicontrol = "&Run")
        {
            lcRun(a_gui)
            return
        }

        if (a_guicontrol = "&Clear")
        {
            sci[1].ClearAll()
            return
        }

        if (a_guicontrol = "&Close")
        {
            GuiClose:
            GuiEscape:
                /*
                    Bring the window forward with hotkey if it doesnt have focus.
                    Fixed the issue with losing focus when clicking the tray icon
                    preventing the normal hide/show behaviour by clicking the icon by
                    checking the time passed since last hotkey press.
                */
                WinGet, winstat, MinMax, ahk_id %$hwnd1%
                if (!WinActive("ahk_id " $hwnd1) && (winstat != "")
                && (a_timesincethishotkey < 100 && a_timesincethishotkey != -1))
                {
                    WinActivate, ahk_id %$hwnd1%
                    return
                }
                if main_toggle := !main_toggle
                    Gui, 01: show
                else
                    Gui, 01: Hide
            return
        }
    }

    ; Add Hotkey Gui
    if (a_gui = 02)
    {
        if (a_guicontrol = "hkType")
        {
            Control, disable,,,ahk_id %$hk2Path%
            Control, disable,,,ahk_id %$hk2Browse%
            sci[2].StyleResetDefault(), sci[2].SetReadOnly(false), SetSciMargin(sci[2])
        }
        else if (a_guicontrol = "File" || a_guicontrol = "Folder")
        {
            Control, enable,,,ahk_id %$hk2Path%
            Control, enable,,,ahk_id %$hk2Browse%
            sci[2].ClearAll(),sci[2].SetReadOnly(true),sci[2].StyleSetBack("STYLE_DEFAULT", 0xe0dfe3)
            sci[2].SetMarginWidthN(0,0),sci[2].SetMarginWidthN(1,0)
        }

        if (a_guicontrol = "&Browse...")
        {
            Gui, 02: +OwnDialogs

            if (hkType = 2) ; File
                FileSelectFile, _path, 1, %a_programfiles%, % "Please select the file to launch."
                                        , % "(*.exe; *.ahk)"
            else if (hkType = 3) ; Folder
                FileSElectFolder, _path, *%a_programfiles%, 3, % "Please select the file to launch."

            StringSplit, _name, _path, \

            if (_name0)
            {
                _name := RegexReplace(_name%_name0%, "im)\.[^\/:*?""<>|]{1,3}$")
                StringUpper,_name, _name, T
                GuiControl, 02:, hkPath, % _path
                GuiControl, 02:, hkName, % _name
            }
            else
            {
                GuiControl, 02:, hkName,
                GuiControl, 02:, hkPath, %a_programfiles%
            }
            return
        }

        if (a_guicontrol = "&Add")
        {
            if inStr(hkey, "None")
            {
                Msgbox, 0x10
                      , % "Error while trying to create new Hotkey"
                      , % "Please select the key that you want to use as a hotkey."
                return
            }

            hkey := (hkHook ? "`$" : "") (hkSend ? "`~" : "") (hkWild ? "`*" : "") (hkLMod ? "`<" : "")
                 .  (hkRMod ? "`>" : "") (hkctrl ? "`^" : "") (hkalt  ? "`!" : "") (hkshift ? "`+": "")
                 .  (hkwin  ? "`#" : "") hkey (hkfRel ? " UP": "")
            hkType := hkType = 1 ? "Script" : hkType = 2 ? "File" : hkType = 3 ? "Folder" : ""

            Add("hotkey"), GuiReset(02)

            Gui, %a_gui%: Submit
            WinActivate, ahk_id %$hwnd1%
            Gui, 01: -Disabled
            return
        }

        if (a_guicontrol = "&Cancel")
        {
            2GuiClose:
            2GuiEscape:
                GuiClose(02), GuiReset(02)
            return
        }
    }

    ; Add Hotstring Gui
    if (a_gui = 03)
    {
        if hs2IsCode
            SetSciMargin(sci[3])
        else
            SetSciMargin(sci[3],0,0)

        if (a_guicontrol = "&Add")
        {
            if inStr(hs2Expand, "e.g.")
            {
                Msgbox, 0x10
                      , % "Error while trying to create new Hotstring"
                      , % "Please type in the abbreviation that you want to expand"
                return
            }

            hsExpand:=hs2Expand,sci[3].GetText(sci[3].GetLength()+1,hsExpandTo),hsIsCode:=hs2IsCode
            Add("hotstring"), GuiReset(03)

            Gui, %a_gui%: Submit
            WinActivate, ahk_id %$hwnd1%
            Gui, 01: -Disabled

            return
        }

        if (a_guicontrol = "&Cancel")
        {
            3GuiClose:
            3GuiEscape:
                GuiClose(3), GuiReset(03)
            return
        }
    }

    ; Import Hotkeys/Hotstrings
    if (a_gui = 04)
    {
        if (a_guicontrol = "imType")
        {
            Control, enable,,, ahk_id %$imIncFolders%
            GuiControl, 04:, imPath, %a_mydocuments%
            return
        }
        else if (a_guicontrol = "File")
        {
            Control, disable,,, ahk_id %$imIncFolders%
            GuiControl, 04:, imPath, %a_mydocuments%
            return
        }

        if (a_guicontrol = "&Browse...")
        {
            Gui, 04: +OwnDialogs
            if (imType = 1)
                FileSelectFolder, im, *%a_mydocuments%, 3, % "Select the folder"
            else if (imType = 2)
            {
                FileSelectFile, im, M3, %a_mydocuments%, % "Select the file"
                Loop, Parse, im, `n, `r
                {
                    if (a_index = 1)
                    {
                        path:=a_loopfield "\", _im:=""
                        continue
                    }
                    _im .= path . a_loopfield "`n"
                }
                im := _im
            }

            if (im)
                GuiControl, 04:, imPath, % RegexReplace(im, "\n", "|")
            else
                GuiControl, 04:, imPath, %a_mydocuments%
            return
        }

        if (a_guicontrol = "&Import")
        {
            if imType = 1
            {
                Loop, %imPath%\*.ahk,0,%imRecurse%
                {
                    impFile0 := a_index
                    FileRead, impFile%a_index%, % a_loopfilelongpath
                    if !hotExtract(impFile%a_index%, a_loopfilelongpath)
                        return
                }
            }
            else
            {
                Loop, Parse, imPath, |
                {
                    FileRead, impFile%a_index%, % a_loopfield
                    if !hotExtract(impFile%a_index%, a_loopfield)
                        return
                    if a_loopfield
                        impFile0 := a_index
                }
            }
            Msgbox, % LV_GetCount() " items imported."
            return
        }

        if (a_guicontrol = "&Accept")
        {
            hkName := "Imported"
            Loop % LV_GetCount()
            {
                Gui, 04: Default
                Gui, 04: ListView, imList
                LV_GetText(hkType, a_index, 1), LV_GetText(opts, a_index, 2), LV_GetText(hkey, a_index, 3)
                LV_GetTExt(_code, a_index, 4), _code:=RegexReplace(_code, "Run\,\s", ""), hsExpand:=hkey
                hsExpandTo := _code := RegexReplace(_code, "\(Multiline\)\s", "", hsIsCode)

                if (hkType = "Hotstring")
                    Add("hotstring")
                else
                    Add("hotkey")
            }
            Load("Hotstrings"), GuiReset(04)
            hkName:=hkType:=opts:=hkey:=hsexpand:=hsexpandto:=_code:=hsIsCode:=null

            Gui, %a_gui%: Submit
            WinActivate, ahk_id %$hwnd1%
            Gui, 01: -Disabled
            return
        }

        if (a_guicontrol = "C&lear")
        {
            LV_Delete()
            return
        }

        if (a_guicontrol = "&Cancel")
        {
            4GuiClose:
            4GuiEscape:
                GuiClose(04), GuiReset(04)
            return
        }
    }

    ; Export Hotkeys/Hotstrings
    if (a_gui = 05)
    {
        if (a_guicontrol = "&Browse...")
        {
            Gui, 05: +OwnDialogs
            FileSelectFile, exFile
                          , S24
                          , % a_mydocuments "\export_" subStr(a_now,1,8) ".ahk"
                          , % "Save File as...", *.ahk; *.txt
            if (exFile)
                GuiControl, 05:, exPath, %exFile%
            return
        }

        if (a_guicontrol = "&Export")
        {
            if FileExist(exPath)
            {
                Msgbox, 0x124
                      , % "The file exists"
                      , % "The filename that you selected appears already exist.`n"
                        . "Do you want to append to the existing file?"

                IfMsgbox No
                    return
            }

            if (exHK)
            {
                node := root.selectSingleNode("//Hotkeys")
                FileAppend, % "; Hotkeys Exported with AutoHotkey Toolkit v" script.version " [" (a_isunicode ? "W" : "A") "]`n", %exPath%
                Loop % node.attributes.item[0].text
                {
                    _hk := node.selectSingleNode("//hk[" a_index - 1 "]/@key").text
                    _hk := RegexReplace(_hk, "&apos;", "'")
                    _path := node.selectSingleNode("//hk[" a_index - 1 "]/path").text
                    _script := node.selectSingleNode("//hk[" a_index - 1 "]/script").text
                    _ifWin := node.selectSingleNode("//hk[" a_index - 1 "]/ifwinactive").text "`n"
                    _ifWinN := node.selectSingleNode("//hk[" a_index - 1 "]/ifwinnotactive").text "`n"

                    if (node.selectSingleNode("//hk[" a_index - 1 "]/@type").text = "Script")
                        _code := (_ifWin != "`n" ? "#IfWinActive " _ifWin : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive " _ifWinN : "")
                              .   _hk "::`n" _script "`nreturn`n"
                              .  (_ifWin != "`n" ? "#IfWinActive" : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive" : "")
                    else
                        _code := (_ifWin != "`n" ? "#IfWinActive " _ifWin : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive " _ifWinN : "")
                              .   _hk "::Run, " _path
                              .  (_ifWin != "`n" ? "#IfWinActive" : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive" : "")

                    FileAppend, %_code%`n, %exPath%
                }
            }

            if (exHS)
            {
                node := root.selectSingleNode("//Hotstrings")
                FileAppend, % "; Hotstrings Exported with AutoHotkey Toolkit v" script.version " [" (a_isunicode ? "W" : "A") "]`n", %exPath%
                Loop % node.attributes.item[0].text
                {
                    _opts := node.selectSingleNode("//hs[" a_index - 1 "]/@opts").text
                    _expand := node.selectSingleNode("//hs[" a_index - 1 "]/expand").text
                    _expand := RegexReplace(_expand, "&apos;", "'")
                    _expandto := node.selectSingleNode("//hs[" a_index - 1 "]/expandto").text
                    _ifWin := node.selectSingleNode("//hs[" a_index - 1 "]/ifwinactive").text "`n"
                    _ifWinN := node.selectSingleNode("//hs[" a_index - 1 "]/ifwinnotactive").text "`n"

                    if (node.selectSingleNode("//hs[" a_index - 1 "]/@iscode").text)
                        _code := (_ifWin != "`n" ? "#IfWinActive " _ifWin : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive " _ifWinN : "")
                              .   ":" _opts ":" _expand "::`n" _expandto "`nreturn`n"
                              .  (_ifWin != "`n" ? "#IfWinActive" : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive" : "")
                    else
                        _code := (_ifWin != "`n" ? "#IfWinActive " _ifWin : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive " _ifWinN : "")
                              .   ":" _opts ":" _expand "::" _expandto
                              .  (_ifWin != "`n" ? "#IfWinActive" : "")
                              .  (_ifWinN != "`n" ? "#IfWinNotActive" : "")

                    FileAppend, %_code%`n, %exPath%
                }
            }

            Gui, %a_gui%: Submit
            WinActivate, ahk_id %$hwnd1%
            Gui, 01: -Disabled
            return
        }

        if (a_guicontrol = "&Cancel")
        {
            5GuiClose:
            5GuiEscape:
                GuiClose(5)
            return
        }
    }

    ; Preferences
    if (a_gui = 06 || a_gui > 80)
    {
        Loop, 13
        {
            _gui := a_index + 86
            Gui, %_gui%: submit, NoHide
        }

        ; tooltip % a_guicontrol
        if (a_guicontrol = "QScod")
        {
            QScod:
                oldQS := QScod = "Quick Search" ? oldQS : QScod
                if (a_thishotkey = "F3")
                    QScod := oldQS, pos := oldpos
                ; tooltip % QScod " - " oldpos " - " a_thishotkey, 10,20
                pos := instr(codKwords, QScod,"", pos ? pos : 1)-1
                SendMessage, 0xB6, 0, 0,, ahk_id %$codKwords%                       ; Scroll to visible
                SendMessage, 0xB1, pos, pos+Strlen(QScod),, ahk_id %$codKwords%     ; Select text
                SendMessage, 0xB7, 0, 0,, ahk_id %$codKwords%                       ; Scroll the caret into view
                oldpos := pos + strlen(QScod)
                if (pos = -1)
                    oldpos := pos := 0
                ; tooltip % QScod " - " pos " - " oldpos, 10,40,2
            return

            Gui6Search:
                oldpos := pos := 0
                SendMessage, 0xB1,0,0,, ahk_id %$codKwords%     ; Select text
                ControlSetText,,, ahk_id %$QScod%
            return

            Hotkey, IfWinActive, ahk_id %$hwnd6%
            Hotkey, F3, QScod, Off
            Hotkey, Delete, Gui6Search, Off
            Hotkey, IfWinActive
        }

        if (a_guicontrol = "&OK")
        {
            ApplyPref(), GuiClose(06), GuiReset(06)
            return
        }

        if (a_guicontrol = "&Close")
        {
            6GuiClose:
            6GuiEscape:
                GuiClose(06), GuiReset(06)
            return
        }

        if (a_guicontrol = "&Apply")
        {
            Control,disable,,,ahk_id %$Apply%
            ApplyPref()
            return
        }

        if (a_guicontrol = "codStat")
        {
            if (codStat)
            {
                Control, enable,,, ahk_id %$codMode1%
                Control, enable,,, ahk_id %$codMode2%
            }
            else
            {
                Control, disable,,, ahk_id %$codMode1%
                Control, disable,,, ahk_id %$codMode2%
            }
        }

        if (a_guicontrol = "cmdStat")
        {
            if (cmdStat)
            {
                ; Control, enable,,, ahk_id %$_eie%
                Control, enable,,, ahk_id %$_uoh%
                Control, enable,,, ahk_id %$_eft%
            }
            else
            {
                ; Control, disable,,, ahk_id %$_eie%
                Control, disable,,, ahk_id %$_uoh%
                Control, disable,,, ahk_id %$_eft%
            }
        }

        if (a_guicontrol = "_uoh")
        {
            ctrls:="ctrl|alt|shift|win"
            if (_uoh)
            {
                Loop, parse, ctrls, |
                {
                    c := $_hf%a_loopfield%
                    Control, enable,,, ahk_id %c%
                }
                Control, enable,,, ahk_id %$HF_DDL%
            }
            else
            {
                Loop, parse, ctrls, |
                {
                    c := $_hf%a_loopfield%
                    Control, disable,,, ahk_id %c%
                }
                Control, disable,,, ahk_id %$HF_DDL%
            }
        }

        if (a_guicontrol = "_eft")
        {
            ctrls := "ctrl|alt|shift|win"
            if (_eft)
            {
                Loop, parse, ctrls, |
                {
                    c := $_ft%a_loopfield%
                    Control, enable,,, ahk_id %c%
                }
                Control, enable,,, ahk_id %$FT_DDL%
            }
            else
            {
                Loop, parse, ctrls, |
                {
                    c := $_ft%a_loopfield%
                    Control, disable,,, ahk_id %c%
                }
                Control, disable,,, ahk_id %$FT_DDL%
            }
        }

        if (a_guicontrol = "_hkddl")
        {
            if (_hkddl = "Default")
            {
                ctrls := "$_ctrl|$_alt|$_shift"
                Loop, Parse, ctrls, |
                    Control, Uncheck,,, % "ahk_id " %a_loopfield%
                Control, Check,,, % "ahk_id " $_win
                Control,ChooseString,``,, ahk_id %$GP_DDL%
            }
        }
        
        if (a_guicontrol = "_hfddl")
        {
            if (_hfddl = "Default")
            {
                ctrls := "$_hfwin|$_hfalt|$_hfshift"
                Loop, Parse, ctrls, |
                    Control, Uncheck,,, % "ahk_id " %a_loopfield%
                Control, Check,,, % "ahk_id " $_hfctrl
                Control,ChooseString,F1,, ahk_id %$HF_DDL%
            }
        }
        
        if (a_guicontrol = "_ftddl")
        {
            if (_ftddl = "Default")
            {
                ctrls := "$_ftwin|$_ftalt|$_ftshift"
                Loop, Parse, ctrls, |
                    Control, Uncheck,,, % "ahk_id " %a_loopfield%
                Control, Check,,, % "ahk_id " $_ftctrl
                Control,ChooseString,F2,, ahk_id %$FT_DDL%
            }
        }
        
        if (a_guicontrol = "&Browse...")
        {
            if (a_gui = 92)
            {
                Gui, 92: +OwnDialogs
                FileSelectFile, hf, 3, %a_ahkpath%, % "Select the help file", Help Files (*.chm)

                if (hf)
                    GuiControl, 92:, hfPath, % RegexReplace(hf, "\n", "|")
                else
                    GuiControl, 92:, hfPath, % RegexReplace(a_ahkpath, "exe$", "chm")
            }
        }

        ; There are no returns because any other control would enable the Apply button.
        ; and it would mess with the other GUIs by exiting the routine before the other statments are checked.
        Control,enable,,,ahk_id %$Apply%
    }

    ; Add Snippet
    if (a_gui = 07)
    {
        if (a_guicontrol = "&Add")
        {
            Add("snippet"), GuiReset(07)

            Gui, %a_gui%: submit                        ; Submits Gui 7
            WinActivate, ahk_id %$hwnd1%
            Gui, 01: -Disabled

            return
        }

        if (a_guicontrol = "&Cancel")
        {
            7GuiClose:
            7GuiEscape:
                GuiClose(7), GuiReset(07)
            return
        }
    }

    ; About Gui
    if (a_gui = 08)
    {
        if (a_guicontrol = "&Close")
        {
            8GuiClose:
            8GuiEscape:
                GuiClose(8)
            return
        }
    }

    ; Paste Upload
    if (a_gui = 09)
    {
        if (a_guicontrol = "pb_ddl")
        {
            if (pb_ddl = "AutoHotkey.net"){
                Ena_Control(1,1,0, a_gui)
                ControlSetText,, Nick, ahk_id %$puText3%
                Control,enable,,, ahk_id %$puText4%
                Control,enable,,, ahk_id %$pb_description%
                Control,disable,,, ahk_id %$puText6%
            }
            else if (pb_ddl = "Pastebin.com"){
                Ena_Control(0,1,1, a_gui)
                ControlSetText,, Post Title, ahk_id %$puText3%
                Control,disable,,, ahk_id %$puText4%
                Control,disable,,, ahk_id %$pb_description%
                Control,enable,,, ahk_id %$puText6%
            }
            return
        }
        if (a_guicontrol = "&Upload")
        {
            Gui, %a_gui%: submit
            pasteUpload()
            return
        }
        if (a_guicontrol = "&Save to File")
        {
            Gui, 09: +OwnDialogs
            sci[5].GetText(sci[5].GetLength()+1,pb_code)
            FileSelectFile, f_saved, S24, %a_desktop%, Save script as..., AutoHotkey (*.ahk)
            if !f_saved
                return

            /*
             * The following piece of code fixes the issue with saving a file without adding
             * the extension while the file existed as "file.ahk", which caused the file
             * to be saved as "file.ahk.ahk" and added a msgbox if the user is overwriting an existing file
             */

            if f_saved contains .ahk               ; Check whether the user added the file extension or not
            {
                if FileExist(f_saved)
                    FileDelete, %f_saved%
                FileAppend, %pb_code%, %f_saved%   ; If added just save the file as the user specified
            }
            else
            {
                if FileExist(f_saved . ".ahk")
                    Msgbox, 4, Replace file...?,  % f_saved . " already exist.`nDo you want to replace it?"
                ifMsgbox, No
                    return
                FileDelete, %f_saved%.ahk
                FileAppend, %pb_code%, %f_saved%.ahk
            }

            Gui, 09: Hide
            return
        }
        if (a_guicontrol = "&Cancel")
        {
            9GuiClose:
            9GuiEscape:
                GuiClose(9), GuiReset(9)
            return
        }
    }

    ; Codet Popup
    if (a_gui = 94)
    {
        if (a_guicontrol = "&No")
        {
            Gui, %a_gui%: Hide
            Settimer, Sleep, Off
            return
        }
        if (a_guicontrol = "&Yes")
        {
            Gui, %a_gui%: Submit
            sci[5].SetText(repIncludes(clipboard))
            Gui, 09: Show
            return
        }
        if (a_guicontrol = "popup")
        {
            selRadio := popup = 1 ? ("Show Popup", options.selectSingleNode("//Codet/@mode").text := 1)
                                  : ("Automatic Upload", options.selectSingleNode("//Codet/@mode").text := 2)

            GuiControl, 97: , %selRadio%, 1
            conf.transformNodeToObject(xsl, conf)
            conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        }

        return
    }

    ; Code Detection Pastebin Preferences
    if (a_gui = 95)
    {
        if (a_guicontrol = "pbp_ddl")
        {
            if (pbp_ddl = "AutoHotkey.net"){
                Ena_Control(1,1,0, a_gui)
                ControlSetText,, Nick, ahk_id %$pbpText1%
                Control,disable,,, ahk_id %$pbpButton1%
                Control,disable,,, ahk_id %$pbpText2%

                Control,ChooseString
                ,% options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@private").text = 1 ? "Private" : "Public"
                ,, ahk_id %$CP_DDL2%

                ControlSetText,
                ,% options.selectSingleNode("//Codet/Pastebin/AutoHotkey/@nick").text
                ,ahk_id %$pbpText3%
            }
            else if (pbp_ddl = "Pastebin.com"){
                Ena_Control(1,1,1, a_gui)
                ControlSetText,, User Key, ahk_id %$pbpText1%
                ; Control,enable,,, ahk_id %$pbpButton1%
                Control,enable,,, ahk_id %$pbpText2%

                Control,ChooseString
                ,% options.selectSingleNode("//Codet/Pastebin/PasteBin/@private").text = 1 ? "Private" : "Public"
                ,, ahk_id %$CP_DDL2%

                ControlSetText,
                ,% options.selectSingleNode("//Codet/Pastebin/PasteBin/@key").text
                ,ahk_id %$pbpText3%
            }
            return
        }
    }
}
MenuHandler(stat=0){
    global
    static tog_aot, tog_lw, tog_ech, tog_sl, tog_ro:=0
           , colors:="Dark Red,Red,Orange,Brown,Yellow,Green,Olive,Cyan,Blue,Dark Blue,Indigo,Violet,White,Black,Custom"
           , lcfPath, lcFile

    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
    tog_aot := root.selectSingleNode("//@alwaysontop").text, tog_ech := options.selectSingleNode("//@sci").text
    tog_lw  := options.selectSingleNode("//@linewrap").text, tog_sl  := options.selectSingleNode("//@snplib").text

    if (stat)
    {
        ; switch state of some menu items depending on which tab we are in at the moment
        ; Menu, MainMenu, %stat%, Edit
        ; Menu, MainMenu, %stat%, Search

        Menu, View, %stat%, Snippet Library
        ; Menu, View, %stat%, Show Symbols
        ; Menu, View, %stat%, Zoom
        Menu, View, %stat%, Line Wrap

        Menu, Settings, %stat%, Run Code With
        ; Menu, Settings, %stat%, Enable Command Helper
        ; Menu, Settings, %stat%, Context Menu Options

        Menu, File, %stat%, &Open`t(Ctrl+O)
        Menu, File, %stat%, &Save`t(Ctrl+S)
        Menu, File, %stat%, Save As`t(Ctrl+Shift+S)
        return
    }

    ; Snippet Menu
    if (a_thismenuitem = "New")
    {
        Gui, 01: +Disabled
        Gui, 07: show
        return
    }

    if (a_thismenuitem = "Edit")
    {
        ListHandler(a_thismenuitem)
        return
    }

    if (a_thismenuitem = "Rename")
    {
        Send, {F2}
        ListHandler(a_thismenuitem)
        return
    }

    if (a_thismenuitem = "Delete")
    {
        ListHandler(a_thismenuitem)
        return
    }

    ; Main Menu
    if (a_thismenuitem = "&New`t(Ctrl+N)")
    {
        Gui_AddNew:
            Gui, 01: Submit, Nohide
            if tabLast = Hotkeys
            {
                Gui, 01: +Disabled
                Gui, 02: show
            }
            else if tabLast = Hotstrings
            {
                Gui, 01: +Disabled
                Gui, 03: show
                ControlFocus,,% "ahk_id " sci[3].hwnd
            }
            else if tabLast = Live Code
            {
                if options.selectSingleNode("//@snplib").text
                {
                    Gui, 01: +Disabled
                    Gui, 07: show
                }
                return
            }
        return
    }

    if (a_thismenuitem = "Delete`t(DEL)")
    {
        if (tabLast = "Live Code")
        {
            ListHandler("Delete")
            return
        }
        else if (tabLast = "Hotkeys")
        {
            node := root.selectSingleNode("//Hotkeys")
            Loop, % LV_GetCount("Selected")
            {
                if !next := LV_GetNext()
                    break
                LV_GetText(_hkey, next, 3), LV_Delete(next)

                if node.attributes.item[0].text() <= 0
                    node.attributes.item[0].text() := 0
                else
                    node.attributes.item[0].text() -= 1
                node.removeChild(node.selectSingleNode("//hk[@key='" hkSwap(_hkey, "short") "']"))
                Hotkey, % hkSwap(_hkey, "short"), OFF
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=node:=null         ; Save & Clean
            return
        }
        else if (tabLast = "Hotstrings")
        {
            FileDelete, % a_temp "\hslauncher.code"
            node := root.selectSingleNode("//Hotstrings")
            Loop, % LV_GetCount("Selected")
            {
                if !next := LV_GetNext()
                    break
                LV_GetText(_expand, next, 3), LV_Delete(next)

                if node.attributes.item[0].text() <= 0
                    node.attributes.item[0].text() := 0
                else
                    node.attributes.item[0].text() -= 1
                node.removeChild(node.selectSingleNode("//hs[expand='" _expand "']"))
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=node:=null         ; Save & Clean
            Load("Hotstrings")
            return
        }
    }

    if (a_thismenuitem = "&Open`t(Ctrl+O)")
    {
        Gui_Open:
            Gui, 01: +OwnDialogs
            FileSelectFile, lcfPath, 1, %lcfPath%, % "Please select the file to open.", % "AutoHotkey (*.ahk)"
            lcFile := FileOpen(lcfPath, "rw `n", "UTF-8")
            sci[1].SetText(false, lcFile.Read()), lcFile.Close()
        return
    }

    if (a_thismenuitem = "&Save`t(Ctrl+S)")
    {
        Gui_Save:
            if (!lcfPath)
            {
                Gui, 01: +OwnDialogs
                FileSelectFile, lcfPath, S24, %a_mydocuments%, % "Save File as...", % "Autohotkey (*.ahk)"

                if !regexmatch(lcfPath, "\.[[:alnum:]]+$")
                        lcfPath := lcfPath ".ahk"
            }

            FileDelete, %lcfPath%
            lcFile := FileOpen(lcfPath, "rw `n", "UTF-8")
            sci[1].GetText(sci[1].GetLength()+1, _lcCode)
            lcFile.Write(_lcCode), lcFile.Close()
        return
    }

    if (a_thismenuitem = "Save As`t(Ctrl+Shift+S)")
    {
        Gui_SaveAs:
            Gui, 01: +OwnDialogs
            FileSelectFile, lcfPath, S24, %a_mydocuments%, % "Save File as...", % "Autohotkey (*.ahk)"

            if !regexmatch(lcfPath, "\.[[:alnum:]]+$")
                    lcfPath := lcfPath ".ahk"

            FileDelete, %lcfPath%
            lcFile := FileOpen(lcfPath, "rw `n", "UTF-8")
            sci[1].GetText(sci[1].GetLength()+1, _lcCode)
            lcFile.Write(_lcCode), lcFile.Close()
        return
    }

    if (a_thismenuitem = "Import Hotkeys/Hotstrings")
    {
        Gui_Import:
            Gui, 01: +Disabled
            Gui, 04: show
        return
    }

    if (a_thismenuitem = "Export Hotkeys/Hotstrings")
    {
        Gui, 01: +Disabled
        Gui, 05: show
        return
    }

    if (a_thismenuitem = "Set Read Only")
    {
        Menu, Edit, ToggleCheck, %a_thismenuitem%
        sci[1].SetReadOnly(tog_ro := !tog_ro)
        return
    }

    if (a_thismenuitem = "Always On Top")
    {
        Menu, View, ToggleCheck, %a_thismenuitem%
        alwaysontop := ((tog_aot := !tog_aot) ? "+" : "-") "AlwaysOnTop"
        Gui, %a_gui%: %alwaysontop%
        root.setAttribute("alwaysontop", tog_aot)
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        return
    }

    if (a_thismenuitem = "Snippet Library")
    {
        slControls:=$slTitle "|" $slDDL "|" $slList
        Menu, View, ToggleCheck, %a_thismenuitem%

        if tog_sl := !tog_sl
        {
            ControlMove,,,, % _guiwidth - 160,, % "ahk_id " sci[1].hwnd
            attach(sci[1].hwnd, "w h r2")
            Loop, Parse, slControls, |
                Control, show,,, ahk_id %a_loopfield%
        }
        else
        {
            ControlMove,,,, % _guiwidth - 10,, % "ahk_id " sci[1].hwnd
            attach(sci[1].hwnd, "w h r2")
            Loop, Parse, slControls, |
                Control, hide,,, ahk_id %a_loopfield%
        }

        options.selectSingleNode("//@snplib").text := tog_sl
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        return
    }

    if (a_thismenuitem = "Line Wrap")
    {
        Menu, View, ToggleCheck, %a_thismenuitem%
        sci[1].SetWrapMode(tog_lw := !tog_lw)
        options.selectSingleNode("//@linewrap").text := tog_lw
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        return
    }

    if (a_thismenuitem = "Enable Command Helper")
    {
        Menu, Settings, ToggleCheck, %a_thismenuitem%
        ; cmdHelper(tog_ech := !tog_ech)
        options.selectSingleNode("//@sci").text := !tog_ech
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        return
    }

    if (a_thismenuitem = "L-Ansi" || a_thismenuitem = "L-Unicode"
    ||  a_thismenuitem = "Basic"  || a_thismenuitem = "IronAHK")
    {
        rcwSet(a_thismenuitem)
        return
    }

    if (a_thismenuitem = "&Preferences`t(Ctrl+P)")
    {
        Gui_Preferences:
            Gui, 01: +Disabled
            Gui, 06: show
        return
    }

    if (a_thismenuitem = "Check for Updates")
    {
        script.update(script.version)
        return
    }

    if (a_thismenuitem = "About")
    {
        Gui, 01: +Disabled
        Gui, 08: show
        return
    }

    ; Forum Color Menu
    if (instr(colors, a_thismenuitem) && a_thismenuitem != "Custom")
        Send, % RegexReplace(a_thismenuitem, "\s") "][/color]{Left 8}"
    else if (a_thismenu = "Color" && a_thismenuitem = "Custom")
    {
        InputBox, hexColor, % "Custom Hexadecimal Color", % "Please Input a hexadecimal color.`nThe hash is optional.",, 210, 140
        if (!ErrorLevel)
        {
            SendRaw, % "#" RegexReplace(hexColor, "#")
            Send, ][/color]{Left 8}
        }
    }

    ; Forum Size Menu
    if (a_thismenu = "Size" && a_thismenuitem = "Custom")
    {
        InputBox, fontSize, % "Custom Font Size", % "Please Input a number which will be your font size.",, 180, 140
        if (!ErrorLevel)
            Send, %fontSize%][/size]{Left 7}
    }
    else if (a_thismenuitem = "Tiny")
        Send, 7][/size]{Left 7}
    else if (a_thismenuitem = "Small")
        Send, 9][/size]{Left 7}
    else if (a_thismenuitem = "Normal")
        Send, 12][/size]{Left 7}
    else if (a_thismenuitem = "Large")
        Send, 18][/size]{Left 7}
    else if (a_thismenuitem = "Huge")
        Send, 24][/size]{Left 7}
}
ListHandler(sParam=0){
    global

    Gui, 01: ListView, %a_guicontrol%
    _selrow := LV_GetNext(), LV_GetText(_seltxt, _selrow)
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
    ; tooltip % a_guicontrol " " a_guievent

    if (sParam = "Edit")
    {
        editingNode := True
        _current := options.selectSingleNode("//SnippetLib/@current").text
        _groupNode :=  options.selectSingleNode("//Group[@name='" _current "']")          ; Select correct Group
        _editNode := _groupNode.selectSingleNode("Snippet[@title='" _seltxt "']")
        GuiControl,07:,slTitle, %_seltxt%
        GuiControl,07: ChooseString,slGroup, %_current%
        sci[4].SetText(false, _editNode.text)

        Gui, 01: +Disable
        Gui, 07: Show
        return
    }

    if (sParam = "Delete")
    {
        _current := options.selectSingleNode("//SnippetLib/@current").text
        Loop, % LV_GetCount("Selected")
        {
            if !next := LV_GetNext()
                break

            LV_GetText(_title, next)
            LV_Delete(next)

            node :=  options.selectSingleNode("//Group[@name='" _current "']")          ; Select correct Group
            node.removeChild(node.selectSingleNode("Snippet[@title='" _title "']"))

            node := options.selectSingleNode("//Group[@name='" _current "']/@count")    ; Reduce Child Count
            node.text := node.text - 1

            if (node.text = 0)
            {
                node := options.selectSingleNode("//SnippetLib")
                node.removeChild(options.selectSingleNode("//Group[@name='" _current "']"))

                ; Replace with next Group
                _current := options.selectSingleNode("//SnippetLib/Group/@name").text
                options.selectSingleNode("//SnippetLib/@current").text := _current

                ; Load DDL with updated information
                GuiControl,,slDDL,|
                node := options.selectSingleNode("//SnippetLib").childNodes
                _current := options.selectSingleNode("//SnippetLib/@current").text

                Loop, % node.length
                {
                    _group := node.item[a_index-1].selectSingleNode("@name").text
                    if  (_group = _current)
                        GuiControl,,slDDL, %_group%||
                    else
                        GuiControl,,slDDL, %_group%
                }

                node := options.selectSingleNode("//Group[@name='" _current "']").childNodes
                GuiControl, -Redraw, slList

                Loop, % node.length
                    LV_Add("", node.item[a_index-1].selectSingleNode("@title").text)

                GuiControl, +Redraw, slList
            }
        }
        conf.transformNodeToObject(xsl, conf)
        conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        return
    }

    if (a_guicontrol = "imList")
    {
        if (a_guievent = "DoubleClick")
        {
            LV_GetText(_search, _selrow, 4), LV_GetText(_file, _selrow, 5)
            Run, Notepad %_file%
            winwaitactive
            if !inStr(_search, "Multiline")
            {
                SetKeyDelay, 200
                Send ^{Home}{F3}%_search%{Enter}{Esc}
                SetKeyDelay, -1
            }
        }

        if (a_guievent = "K" && a_eventinfo = 46)
        {
            Loop, % LV_GetCount("Selected")
            {
                if !next := LV_GetNext()
                    break
                LV_Delete(next)
            }
            return
        }
    }

    if (a_guicontrol = "PrefList")
    {
        Loop, 13
        {
            _gui := a_index + 86
            Gui, %_gui%: submit, NoHide
        }

        if (a_guievent = "Normal")
        {
            TV_GetText(selPref, a_eventinfo)
            if selPref
                ControlSetText,, %selPref%, ahk_id %$Title%
            prefControl(a_eventinfo)
            return
        }
    }

    if (a_guicontrol = "hkList" || a_guicontrol = "shkList")
    {
        if (a_guievent = "DoubleClick")
        {
            if !_selrow
            {
                LV_Modify(0,"-Select"),LV_Modify(0,"-Focus")
                Gui, 01: +Disabled
                Gui, 02: show
                return
            }
            editingHK := True
            LV_GetText(_hk, _selrow, 3)
            oldkey := _hkey := hkSwap(_hk, "short")
            node := root.selectSingleNode("//Hotkeys/hk[@key='" RegexReplace(_hkey, "\'", "&apos;") "']")

            _hkType := node.attributes.getNamedItem("type").value
            _hkName := node.selectSingleNode("name").text
            _hkPath := node.selectSingleNode("path").text
            _hkIfWin := node.selectSingleNode("ifwinactive").text
            _hkIfWinN := node.selectSingleNode("ifwinnotactive").text
            _script := node.selectSingleNode("script").text

            _guivars := "hkName|hkPath|hkIfWin|hkIfWinN"

            Loop, Parse, _guivars, |
                GuiControl, 2:, % a_loopfield, % _%a_loopfield%

            GuiControl, 2:, % _hkType, 1
            if (_hkType = "Script")
            {
                Control, disable,,,ahk_id %$hk2Path%
                Control, disable,,,ahk_id %$hk2Browse%
                sci[2].StyleResetDefault(), sci[2].SetReadOnly(false), SetSciMargin(sci[2])
            }
            else if (_hkType = "File" || _hkType = "Folder")
            {
                Control, enable,,,ahk_id %$hk2Path%
                Control, enable,,,ahk_id %$hk2Browse%
                sci[2].ClearAll(),sci[2].SetReadOnly(true),sci[2].StyleSetBack("STYLE_DEFAULT", 0xe0dfe3)
                sci[2].SetMarginWidthN(0,0),sci[2].SetMarginWidthN(1,0)
            }

            if (_script)
               sci[2].SetText(false, _script)

            _guivars := "hkctrl ^|hkalt !|hkshift +|hkwin #|hkLMod <|hkRMod >|hkWild *|hkSend ~|hkHook $|hkfRel UP"

            Loop, Parse, _guivars, |
            {
                StringSplit, _key, a_loopfield, %a_space%
                GuiControl, 2:, % _key1, % inStr(_hkey, _key2) ? "1" : "0"
            }
            RegexMatch(_hkey, "im)[^\^!+#<>*~$ ]+", _hkey)
            GuiControl, 2: ChooseString, hkey, % _hkey
            Gui, 02: show
        }

        if (a_guievent = "K" && a_eventinfo = 46)
        {
            node := root.selectSingleNode("//Hotkeys")
            Loop, % LV_GetCount("Selected")
            {
                if !next := LV_GetNext()
                    break
                LV_GetText(_hkey, next, 3), LV_Delete(next)

                if node.attributes.item[0].text() <= 0
                    node.attributes.item[0].text() := 0
                else
                    node.attributes.item[0].text() -= 1
                node.removeChild(node.selectSingleNode("//hk[@key='" hkSwap(RegexReplace(_hkey, "\'", "&apos;")
                                                                                        , "short") "']"))
                Hotkey, % hkSwap(_hkey, "short"), OFF
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=node:=null         ; Save & Clean
            return
        }

    }

    if (a_guicontrol = "hsList" || a_guicontrol = "shsList")
    {
        if (a_guievent = "DoubleClick")
        {
            if !_selrow
            {
                LV_Modify(0,"-Select"),LV_Modify(0,"-Focus")
                Gui, 01: +Disabled
                Gui, 03: show
                ControlFocus,, % "ahk_id " sci[3].hwnd
                return
            }
            editingHS := True
            LV_GetText(_expand, _selrow, 3), oldhs := _expand
            node := root.selectSingleNode("//Hotstrings/hs[expand='" RegexReplace(_expand, "\'", "&apos;") "']")

            _hs2IsCode := node.attributes.getNamedItem("iscode").value
            _hsOpt := node.attributes.getNamedItem("opts").value
            _hs2Expand := RegexReplace(node.selectSingleNode("expand").text, "&apos;", "'")
            _hs2Expandto := node.selectSingleNode("expandto").text
            _hsIfWin := node.selectSingleNode("ifwinactive").text
            _hsIfWinN := node.selectSingleNode("ifwinnotactive").text
            _guivars := "hs2IsCode|hsOpt|hs2Expand|hsIfWin|hsIfWinN"

            Loop, Parse, _guivars, |
                GuiControl, 3:, % a_loopfield, % _%a_loopfield%

            if _hs2IsCode
                SetSciMargin(sci[3])
            else
                SetSciMargin(sci[3],0,0)

            sci[3].SetText(false, _hs2Expandto)
            Gui, 03: show
        }

        if (a_guievent = "K" && a_eventinfo = 46)
        {
            FileDelete, % a_temp "\hslauncher.code"
            node := root.selectSingleNode("//Hotstrings")
            Loop, % LV_GetCount("Selected")
            {
                if !next := LV_GetNext()
                    break
                LV_GetText(_expand, next, 3), LV_Delete(next)

                if node.attributes.item[0].text() <= 0
                    node.attributes.item[0].text() := 0
                else
                    node.attributes.item[0].text() -= 1
                node.removeChild(node.selectSingleNode("//hs[expand='" RegexReplace(_expand, "\'", "&apos;") "']"))
            }
            conf.transformNodeToObject(xsl, conf), updateSB()
            conf.save(script.conf), conf.load(script.conf) root:=options:=node:=null         ; Save & Clean
            Load("Hotstrings")
            return
        }
    }

    if (a_guicontrol = "slList" || sParam = "Rename")
    {
        if (a_guievent = "DoubleClick" && !_selrow)
        {
            LV_Modify(0,"-Select"),LV_Modify(0,"-Focus")
            Gui, 01: +Disabled
            Gui, 07: show
        }

        if (a_guievent = "DoubleClick")
        {
            _current := options.selectSingleNode("//SnippetLib/@current").text
            _snip := options.selectSingleNode("//Group[@name='" _current "']/Snippet[@title='" _seltxt "']").text
            sci[1].AddText(strLen(_snip),_snip)
            return
        }

        if (a_guievent = "RightClick")
        {
            Menu, Snippet, show
            return
        }

        if (a_guievent = "K" && a_eventinfo = 46)
        {
            ListHandler("Delete")
            return
        }

        if (a_guievent = "E" || sParam = "Rename")
        {
            Send, {Delete}                      ; Needed because we cannot append with the input command.

            ; Need this hotkey to be able to cancel the renaming process cleanly
            ; by clicking.
            Hotkey, *LButton, CancelInput, On   ; Using On to enable if it is disabled by label below.
            Input, slNewTitle,CV,{Enter}{Esc}

            if !inStr(ErrorLevel, "EndKey:Escape")
            {
                _current := options.selectSingleNode("//SnippetLib/@current").text
                _title := slNewTitle ? slNewTitle : _seltxt
                node :=  options.selectSingleNode("//Group[@name='" _current "']")
                node.selectSingleNode("Snippet[@title='" _seltxt "']/@title").text:=_title
                conf.transformNodeToObject(xsl, conf)
                conf.save(script.conf), conf.load(script.conf)          ; Save and Load
            }
            Hotkey, *LButton, Off               ; If we finished editing normally then turn off the hotkey.
            return

            CancelInput:
                Send {Enter}
                Hotkey, *LButton, Off
            Return
        }
    }

    if !LV_GetCount("Selected")
        LV_Modify(0,"-Focus")
}
HotkeyHandler(hk){
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

    node := root.selectSingleNode("//Hotkeys")

    hk := RegexReplace(hk, "\'", "&apos;")
    _path := node.selectSingleNode("//hk[@key='" hk "']/path").text
    _type := node.selectSingleNode("//hk[@key='" hk "']/@type").text
    _script := node.selectSingleNode("//hk[@key='" hk "']/script").text

    if (_type = "Script")
    {
        lcfPath := a_temp . "\" . rName(5, "code")        ; Random Live Code Path

        if !InStr(_script,"Gui")
            _script .= "`n`nExitApp"
        else if !InStr(_script,"GuiClose")
        {
            if !InStr(_script,"return")
                _script .= "`nreturn"
            _script .= "`n`nGuiClose:`nExitApp"
        }

        live_script =
        (Ltrim
            ;[Directives]{
            #NoEnv
            #SingleInstance Force
            ; --
            SetBatchLines -1
            SendMode Input
            SetWorkingDir %a_scriptdir%
            ; --
            ;}

            sec         :=  1000               ; 1 second
            min         :=  sec * 60           ; 1 minute
            hour        :=  min * 60           ; 1 hour

            %_script%

        )

        if !InStr(_script, "^Esc::ExitApp")
            live_script .= "^Esc::ExitApp"

        FileAppend, %live_script%, %lcfPath%

        rcw := options.selectSingleNode("//RCPaths/@current").text
        ahkpath := options.selectSingleNode("//RCPaths/" rcw).text
        if !ahkpath
        {
            if !FileExist(ahkpath := a_temp "\ahkl.bak")
                FileInstall, res\ahkl.bak, %ahkpath%
        }

        Run, %ahkpath% %lcfPath%
        return
    }
    else if (fileExist(_path))
        Run, % _path
    else
        Msgbox, 0x10
          , % "Error"
          , % "The file this hotkey is trying to access does not exist."
    return
}
MsgHandler(wParam,lParam, msg, hwnd){
    static
    hCurs:=DllCall("LoadCursor","UInt",0,"Int",32649,"UInt") ;IDC_HAND
    global cList1,hList1,cList2,hList2,cList3,hList3,$QShk,$QShs,$QSlc,$QScod
         , $hsOpt,$hsExpand,$hs2Expand,$hsExpandto,$hkIfWin,$hkIfWinN,$hsIfWin,$hsIfWinN
         , $GP_E1, $GP_DDL
         , hSciL:=sci[1].hwnd "," sci[2].hwnd "," sci[3].hwnd
         , oldpos,pos   ; From Gui 96

    if (msg = WM("MOUSEMOVE"))
    {
        MouseGetPos,,,,ctrl
        if ((instr(ctrl, "Static4") ||  instr(ctrl, "Static7")) && a_gui != 06)
            DllCall("SetCursor","UInt",hCurs)
        Return
    }
    if (msg = WM("COMMAND"))
    {

        if lParam in %hSciL%
            return

        if (wParam>>16 = 0x0100)    ; EN_SETFOCUS
        {
            if (lParam = $GP_E1)
            {
                SetHotkeys()                    ; Disable hotkeys
                return
            }

            if (lParam = $QScod)
            {
                oldpos := pos := 0              ; Reset search position
                Gui, 96: font, s8 cBlack norm
                GuiControl, 96: font, QScod
                ; msgbox % errorlevel
            }

            ControlGetText,sText,, ahk_id %lParam%
            if a_gui
            {
                Gui, %a_gui%: font, s8 cBlack norm
                GuiControl, font, % getID(lParam, cList%a_gui%, hList%a_gui%)
            }

            if (inStr(sText, "e.g. ") || inStr(sText, "Quick Search"))
                ControlSetText,,, ahk_id %lParam%
            return
        }

        if (wParam>>16 = 0x0200)    ; EN_KILLFOCUS
        {
            if (lParam = $GP_E1)
            {
                SetHotkeys()                    ; Re-Enable hotkeys
                return
            }

            if (lParam = $QScod)
            {
                Gui, 96: font, s8 cGray italic, Verdana
                GuiControl, 96: font, QScod
            }

            ControlGetText,cText,, ahk_id %lParam%

            if (!cText && (inStr(sText, "e.g. ") || inStr(sText, "Quick Search")))
            {
                if a_gui
                {
                    Gui, %a_gui%: font, s8 cGray italic, Verdana
                    GuiControl, font, % getID(lParam, cList%a_gui%, hList%a_gui%)
                }
                ControlSetText,,%sText%, ahk_id %lParam%
                return
            }

            if (!cText && sText)
            {
                if a_gui
                {
                    Gui, %a_gui%: font, s8 cGray italic, Verdana
                    GuiControl, font, % getID(lParam, cList%a_gui%, hList%a_gui%)
                }

                if (lParam = $QShk || lParam = $QShs || lParam = $QScod)
                    ControlSetText,, % "Quick Search", ahk_id %lParam%

                if (lParam = $hsOpt)
                    ControlSetText,, % "e.g. rc*", ahk_id %lParam%

                if (lParam = $hsExpand || lParam = $hs2Expand)
                    ControlSetText,, % "e.g. btw", ahk_id %lParam%

                if (lParam = $hsExpandto)
                    ControlSetText,, % "e.g. by the way", ahk_id %lParam%

                if (lParam = $hkIfWin || lParam = $hsIfWin)
                    ControlSetText,, % "If window active list (e.g. Winamp, Notepad, Fire.*)", ahk_id %lParam%

                if (lParam = $hkIfWinN || lParam = $hsIfWinN)
                    ControlSetText,, % "If window NOT active list (e.g. Notepad++, Firefox, post.*\s)"
                                   , ahk_id %lParam%
                return
            }
        }
    }
}

; Other
getID(hwnd, controls, handles){

    Loop, Parse, handles,`n, `r
        if (a_loopfield = hwnd)
            match:=a_index

    Loop, Parse, controls, `n,`r
        if (a_index = match)
            return a_loopfield
}
hotExtract(file, path){
    global imHK, imHS, _code

    Gui, 04: Default
    Gui, 04: ListView, imList

    ; This variable contains the regex for importing multiline hotkeys and hotstrings.
    ; This ternary checks if imHK is set, if it is it checks if imHS is also set.
    ; If imHK is not set then we check if imHS is set by itself or not.
    #mLine:=imHK ? "mi)^(?P<HKOPT>[<>*~$]+)?(?P<HK>[\w\s#!^+&]+)(?<![:;])::(\s+;.*)?$"
    . (imHK && imHS ? "|" : "")
    . (imHS ? "^:(?P<HSOPT>[*?BCKOPRSIEZ0-9]+)?:(?P<HS>.*)(?<![;])::(\s+;.*)?$" : "") : ""
    . (imHS ? "mi)^:(?P<HSOPT>[*?BCKOPRSIEZ0-9]+)?:(?P<HS>.*)(?<![;])::(\s+;.*)?$" : "")

    ; Same as above but only for single lined hotkeys and hotstrings.
    #sLine:=imHK ? "i)^(?P<HKOPT>[<>*~$]+)?(?P<HK>[\w\s#!^+&]+)(?<![:;])::(?P<HKCODE>[^;]+)"
    . (imHK && imHS ? "|" : "")
    . (imHS ? "^:(?P<HSOPT>[*?BCKOPRSIEZ0-9]+)?:(?P<HS>.*)(?<![;])::(?P<HSCODE>[^;]+)" : "") : ""
    . (imHS ? "i)^:(?P<HSOPT>[*?BCKOPRSIEZ0-9]+)?:(?P<HS>.*)(?<![;])::(?P<HSCODE>[^;]+)" : "")

    if (!#mLine || !#sLine)
    {
        Msgbox, 0x10
              , % "Error while trying to import."
              , % "You must select what to import my friend.`nEither hotkeys, hotstrings or both."
        return 0
    }

    GuiControl, -Redraw, imList
    Loop, Parse, file, `n,`r
    {
        SplitPath, path,_fName
        if multiline
        {
            if inStr(a_loopfield, "return")
            {
                subCode := "(Multiline) " _code ; RegexReplace(subStr(_code,1,40), "\s+", " ")
                LV_Add(""
                      , _mlHK ? "Script" : "Hotstring"
                      , ((_mlHKOPT || _mlHSOPT) ? RegexReplace(_mlHKOPT _mlHSOPT, "^\s+") : "")
                      , ((_mlHK || _mlHS) ? RegexReplace(_mlHK _mlHS, "^\s+") : "")
                      , subCode
                      , path)

                Loop, 5
                {
                    if a_index = 4
                    {
                        LV_ModifyCol(a_index, 250)
                        continue
                    }
                    LV_ModifyCol(a_index, "AutoHdr")
                }
                multiline:=False,_code:="",_mlHK:="",_mlHS:="",_mlHKOPT:="",_mlHSOPT:=""
            }
            else
                _code .= a_loopfield "`n"
        }

        if RegexMatch(a_loopfield, #mLine, ml)
        {
            ; this process keep old hotkey/hotstring information so i can parse multiline items correctly
            multiline:=True,_mlHK:=mlHK ? mlHK : _mlHK,_mlHS:=mlHS ? mlHS : _mlHS
           ,_mlHKOPT:=mlHKOPT ? mlHKOPT : _mlHKOPT,_mlHSOPT:=mlHSOPT ? mlHSOPT : _mlHSOPT
           continue
        }

        if RegexMatch(a_loopfield, #sLine, sl)
        {
            LV_Add(""
                  , ((RegexMatch(slHKCODE slHSCODE, "Run(,\s)?(.*)", mtype) && !slHSCODE) ? null
                  . (instr(FileExist(mtype2), "D") ? "Folder" : "File") : slHS ? "Hotstring" : "Script")
                  , ((slHKOPT || slHSOPT) ? RegexReplace(slHKOPT slHSOPT, "^\s+") : "")
                  , ((slHK || slHS) ? RegexReplace(slHK slHS, "^\s+") : "")
                  , slHKCODE slHSCODE
                  , path)

            Loop, 5
            {
                if a_index = 4
                {
                    LV_ModifyCol(a_index, 250)
                    continue
                }
                LV_ModifyCol(a_index, "AutoHdr")
            }
            continue
        }
    }
    GuiControl, +Redraw, imList
    return 1
}
rcwSet(menu=0){
    static names:="L-Ansi|L-Unicode|Basic|IronAHK"

    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild
    node := options.selectSingleNode("//RCPaths").childNodes
    loop, Parse, names, |
    {
        if !node.item[a_index - 1].text
            Menu, RCW, disable, %a_loopfield%
        else if !menu
            Menu, RCW, check, % options.selectSingleNode("//RCPaths/@current").text
        else if (menu = a_loopfield)
        {
            Loop, Parse, names, |
                Menu, RCW, uncheck, %a_loopfield%       ; Make sure all others are unchecked
            Menu, RCW, check, %a_loopfield%
            options.selectSingleNode("//RCPaths/@current").text := a_loopfield
            conf.transformNodeToObject(xsl, conf)
            conf.save(script.conf), conf.load(script.conf)          ; Save and Load
        }
    }
    return
}
prefControl(pref=0){
    global

    if !pref
        return

    if (pref = $P1)
        Gui, 98: show, NoActivate
    else
        Gui, 98: hide

    if (pref = $P1C1)
        Gui, 97: show, NoActivate
    else
        Gui, 97: hide

    if (pref = $C1C1)
    {
        Gui, 96: show, NoActivate
        Hotkey, F3, QScod, On
        Hotkey, Delete, Gui6Search, On
    }
    else
    {
        Gui, 96: hide
        Hotkey, F3, QScod, Off
        Hotkey, Delete, Gui6Search, Off
    }

    if (pref = $C1C2)
        Gui, 95: show, NoActivate
    else
        Gui, 95: hide

    if (pref = $P1C2)
        Gui, 93: show, x165 y36 w350 NoActivate
    else
        Gui, 93: hide

    if (pref = $C2C1)
        Gui, 92: show, x165 y36 w350 NoActivate
    else
        Gui, 92: hide

    if (pref = $P1C4)
        Gui, 87: show, x165 y36 w350 NoActivate
    else
        Gui, 87: hide

    ; Temporal Code
    w := $P1 "," $P1C1 "," $C1C1 "," $C1C2 "," $P1C2 "," $C2C1 "," $P1C4

    if pref not in %w%
        GuiControl, 06: show, AHKTK_UC
    else
        GuiControl, 06: hide, AHKTK_UC
}
defConf(path){
    s_version := script.version, hlpPath := RegexReplace(a_ahkpath, "exe$", "chm")
    a_isunicode ? (unicode := a_ahkpath, current := "L-Unicode") : (ansi := a_ahkpath, current := "L-Ansi")
    template=
    (
<?xml version="1.0" encoding="UTF-8"?>
<AHK-Toolkit version="%s_version%" alwaysontop="0">
    <Options>
        <Startup ssi="1" sww="1" smm="1" cfu="1"/>
        <MainKey ctrl="0" alt="0" shift="0" win="1">``</MainKey>
        <SuspWndList/>
        <Codet status="1" mode="1">
            <Pastebin current="Autohotkey">
                <AutoHotkey private="0" nick=""></AutoHotkey>
                <PasteBin private="0" key="" expiration="1H"></PasteBin>
                <DPaste nick=""></DPaste>
                <Gist></Gist>
            </Pastebin>
            <History max="10"/>
            <Keywords min="5">
if exitapp gosub goto ifequal ifexist ifgreater ifgreaterorequal ifinstring ifless iflessorequal ifmsgbox ifnotequal ifnotexist ifnotinstring ifwinactive ifwinexist ifwinnotactive ifwinnotexist onexit setbatchlines settimer suspend static global local byref autotrim blockinput clipwait click control controlclick controlfocus controlget controlgetfocus controlgetpos controlgettext controlmove controlsend controlsendraw controlsettext coordmode critical detecthiddentext detecthiddenwindows driveget drivespacefree endrepeat envadd envdiv envget envmult envset envsub envupdate fileappend filecopy filecopydir filecreatedir filecreateshortcut filedelete filegetattrib filegetshortcut filegetsize filegettime filegetversion fileinstall filemove filemovedir fileread filereadline filerecycle filerecycleempty fileremovedir fileselectfile fileselectfolder filesetattrib filesettime formattime getkeystate groupactivate groupadd groupclose groupdeactivate gui guicontrol guicontrolget hideautoitwin hotkey imagesearch inidelete iniread iniwrite input inputbox keyhistory keywait listhotkeys listlines listvars mouseclick mouseclickdrag mousegetpos mousemove msgbox numget numset outputdebug pixelgetcolor pixelsearch postmessage regdelete registercallback regread regwrite reload runas runwait send sendevent sendinput sendmessage sendmode sendplay sendraw setcapslockstate setcontroldelay setdefaultmousespeed setenv setformat setkeydelay setmousedelay setnumlockstate setscrolllockstate setstorecapslockmode settitlematchmode setwindelay setworkingdir soundbeep soundget soundgetwavevolume soundplay soundset soundsetwavevolume splashimage splashtextoff splashtexton splitpath statusbargettext statusbarwait stringcasesense stringgetpos stringleft stringlen stringlower stringmid stringreplace stringright stringsplit stringtrimleft stringtrimright stringupper sysget thread tooltip transform traytip urldownloadtofile winactivate winactivatebottom winclose winget wingetactivestats wingetactivetitle wingetclass wingetpos wingettext wingettitle winhide winkill winmaximize winmenuselectitem winminimize winminimizeall winminimizeallundo winmove winrestore winset winsettitle winshow winwait winwaitactive winwaitclose winwaitnotactive abs acos asc asin atan ceil chr cos dllcall exp fileexist floor il_add il_create il_destroy instr islabel ln log lv_add lv_delete lv_deletecol lv_getcount lv_getnext lv_gettext lv_insert lv_insertcol lv_modify lv_modifycol lv_setimagelist mod onmessage round regexmatch regexreplace sb_seticon sb_setparts sb_settext sin sqrt strlen substr tan tv_add tv_delete tv_getchild tv_getcount tv_getnext tv_get tv_getparent tv_getprev tv_getselection tv_gettext tv_modify varsetcapacity winactive winexist allowsamelinecomments clipboardtimeout commentflag errorstdout escapechar hotkeyinterval hotkeymodifiertimeout hotstring include includeagain installkeybdhook installmousehook maxhotkeysperinterval maxmem maxthreads maxthreadsbuffer maxthreadsperhotkey noenv notrayicon singleinstance usehook winactivateforce shift lshift rshift alt lalt ralt lcontrol rcontrol ctrl lctrl rctrl lwin rwin appskey altdown altup shiftdown shiftup ctrldown ctrlup lwindown lwinup rwindown rwinup lbutton rbutton mbutton wheelup wheeldown xbutton1 xbutton2 joy1 joy2 joy3 joy4 joy5 joy6 joy7 joy8 joy9 joy10 joy11 joy12 joy13 joy14 joy15 joy16 joy17 joy18 joy19 joy20 joy21 joy22 joy23 joy24 joy25 joy26 joy27 joy28 joy29 joy30 joy31 joy32 joyx joyy joyz joyr joyu joyv joypov joyname joybuttons joyaxes joyinfo space tab enter escape backspace delete insert pgup pgdn printscreen ctrlbreak scrolllock capslock numlock numpad0 numpad1 numpad2 numpad3 numpad4 numpad5 numpad6 numpad7 numpad8 numpad9 numpadmult numpadadd numpadsub numpaddiv numpaddot numpaddel numpadins numpadclear numpadup numpaddown numpadleft numpadright numpadhome numpadend numpadpgup numpadpgdn numpadenter f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 browser_back browser_forward browser_refresh browser_stop browser_search browser_favorites browser_home volume_mute volume_down volume_up media_next media_prev media_stop media_play_pause launch_mail launch_media launch_app1 launch_app2 a_ahkpath a_ahkversion a_appdata a_appdatacommon a_autotrim a_batchlines a_caretx a_carety a_computername a_controldelay a_cursor a_dd a_ddd a_dddd a_defaultmousespeed a_desktop a_desktopcommon a_detecthiddentext a_detecthiddenwindows a_endchar a_eventinfo a_exitreason a_formatfloat a_formatinteger a_gui a_guievent a_guicontrol a_guicontrolevent a_guiheight a_guiwidth a_guix a_guiy a_hour a_iconfile a_iconhidden a_iconnumber a_icontip a_index a_ipaddress1 a_ipaddress2 a_ipaddress3 a_ipaddress4 a_isadmin a_iscompiled a_issuspended a_keydelay a_language a_lasterror a_linefile a_linenumber a_loopfield a_loopfileattrib a_loopfiledir a_loopfileext a_loopfilefullpath a_loopfilelongpath a_loopfilename a_loopfileshortname a_loopfileshortpath a_loopfilesize a_loopfilesizekb a_loopfilesizemb a_loopfiletimeaccessed a_loopfiletimecreated a_loopfiletimemodified a_loopreadline a_loopregkey a_loopregname a_loopregsubkey a_loopregtimemodified a_loopregtype a_mday a_min a_mm a_mmm a_mmmm a_mon a_mousedelay a_msec a_mydocuments a_now a_nowutc a_numbatchlines a_ostype a_osversion a_priorhotkey a_programfiles a_programs a_programscommon a_screenheight a_screenwidth a_scriptdir a_scriptfullpath a_scriptname a_sec a_space a_startmenu a_startmenucommon a_startup a_startupcommon a_stringcasesense a_tab a_temp a_thisfunc a_thishotkey a_thislabel a_thismenu a_thismenuitem a_thismenuitempos a_tickcount a_timeidle a_timeidlephysical a_timesincepriorhotkey a_timesincethishotkey a_titlematchmode a_titlematchmodespeed a_username a_wday a_windelay a_windir a_workingdir a_yday a_year a_yweek a_yyyy clipboard clipboardall comspec errorlevel programfiles true false ltrim rtrim ahk_id ahk_pid ahk_class ahk_group processname minmax controllist statuscd filesystem setlabel alwaysontop mainwindow nomainwindow useerrorlevel altsubmit hscroll vscroll imagelist wantctrla wantf2 visfirst return wantreturn backgroundtrans minimizebox maximizebox sysmenu toolwindow exstyle check3 checkedgray readonly notab lastfound lastfoundexist alttab shiftalttab alttabmenu alttabandmenu alttabmenudismiss controllisthwnd hwnd deref pow bitnot bitand bitor bitxor bitshiftleft bitshiftright sendandmouse mousemouveoff hkey_local_machine hkey_users hkey_current_user hkey_classes_root hkey_current_config hklm hku hkcu hkcr hkcc reg_sz reg_expand_sz reg_multi_sz reg_dword reg_qword reg_binary reg_link reg_resource_list reg_full_resource_descriptor reg_resource_requirements_list reg_dword_big_endian regex rgb belownormal abovenormal xdigit alpha upper lower alnum topmost transparent transcolor redraw idlast togglecheck toggleenable nodefault nostandard deleteall noicon groupbox button checkbox dropdownlist ddl combobox statusbar treeview listbox listview datetime monthcal updown iconsmall sortdesc nosort nosorthdr hdr autosize range font resize owner nohide minimize maximize restore noactivate cancel destroy center margin owndialogs guiescape guiclose guisize guicontextmenu guidropfiles tabstop choosestring enabled disabled visible notimers interrupt priority waitclose OnClipboardChange OnGUIClose OnGUIEscape OnGUICancel
            </Keywords>
    )
    template2=
    (
		</Codet>
		<CMDHelper global="1" sci="1" forum="1" tags="1">
			<HelpKey ctrl="1" alt="0" shift="0" win="0">F1</HelpKey>
			<TagsKey ctrl="1" alt="0" shift="0" win="0">F2</TagsKey>
			<HelpPath online="0">%hlpPath%</HelpPath>
		</CMDHelper>
		<LiveCode linewrap="1" highlighting="1" url="1" symbols="0" snplib="0">
			<RCPaths current="%current%">
				<L-Ansi>%ansi%</L-Ansi>
				<L-Unicode>%unicode%</L-Unicode>
				<Basic/>
				<IronAHK/>
			</RCPaths>
            <SnippetLib current="Example Snippets">
				<Group name="Example Snippets" count="4">
                    <Snippet title="Coord Saver">
/*
 *********************************************************************
 * This script saves X and Y coordinates in a file when you click.   *
 * It is very useful for quickly determining positions on the screen *
 * or to record several x - y positions to be parsed later on by     *
 * a macro which would click those positions automatically.          *
 *                                                                   *
 * Use the Right Mouse button or Esc to exit the application.        *
 *********************************************************************
 */

CoordMode, Mouse, Screen
s_file := a_desktop . "\coords.txt"         ; Change as desired

Loop
{
    MouseGetPos, X, Y
    ToolTip, x(`%X`%)``, y(`%Y`%)                ; Tooltip to make everything easier
    Sleep 10
}

Esc::
RButton::
    ExitApp
~LButton::FileAppend, `%X`%``,`%Y`%``n, `%s_file`%  ; Save coords to parse e.g. 300,400
                    </Snippet>
					<Snippet title="Schedule Shutdown">
/*
 *********************************************************************
 * All Live Code scripts can make use the variables                  *
 * 'sec' 'min' and 'hour'                                            *
 * The following script schedules a shutdown on the specified time.  *
 * Note that we need to divide by 1000 because the shutown command   *
 * only accepts seconds while our variables return milliseconds.     *
 *                                                                   *
 * Also as we are dividing, time would return a decimal number       *
 * so we need to get rid of the '.000000' before passing it to the   *
 * shutdown command                                                  *
 *********************************************************************
 */

Gui, add, Groupbox,w235 h50, Shutdown in:
Gui, add, Edit, xp+10 yp+20 w25 vhh
Gui, add, Text, x+5 yp+3, Hours
Gui, add, Edit, x+10 yp-3 w25 vmm
Gui, add, Text, x+5 yp+3, Minutes
Gui, add, Edit, x+10 yp-3 w25 vss
Gui, add, Text, x+5 yp+3, Seconds
Gui, add, Text, x0 y+20 w260 0x10
Gui, add, Button, x170 yp+5 w75 Default gGuiHandler, &amp;Schedule

Gui, show, w255
return

GuiHandler:
    Gui, submit
    hh := !hh ? 0 : hh, mm := !mm ? 0 : mm,ss := !ss ? 0 : ss
    time := regexreplace(time:=(hh*hour + mm*min + ss*sec)/1000, "\.\d+")
    Run, `%comspec`% /c "Shutdown -s -t `%time`% -f"
    ExitApp
                    </Snippet>
					<Snippet title="Text Control - Style Ref.">
/*
 *********************************************************************
 * This Script is just a demostration of the styles that you can     *
 * apply to text controls.                                           *
 *                                                                   *
 * To apply a style just write the code like this:                   *
 * Gui, add, Text, [options] [style]                                 *
 * Ex. Gui, add, Text, w50 h50 x20 y25 0x4                           *
 *                                                                   *
 * As you can see this opens tons of posibilities in your            *
 * Gui Creation and with enough creativity you can create cool       *
 * interfaces! Dont limit yourself to the defaults!                  *
 *                                                                   *
 * **Press Esc to close the Aplication.                              *
 *********************************************************************
 */

; --[Main]------------------------------------------------------------------------

0x4=
`(
Specifies a rectangle filled with the current *window frame* color.
This color is BLACK in the default color scheme.
`)
0x5=
`(
Specifies a rectangle filled with the current *screen background* color.
This color is GRAY in the default color scheme.
`)
0x6=
`(
Specifies a rectangle filled with the current *window background* color.
This color is WHITE in the default color scheme.
`)
0x7=
`(
Specifies a box with a frame drawn in the same color as the
*window frames*. This color is BLACK in the default color scheme.
`)
0x8=
`(
Specifies a box with a frame drawn with the same color as the *screen
background* (desktop). This color is GRAY in the default color scheme.
`)
0x9=
`(
Specifies a box with a frame drawn with the same color as the *window
background*. This color is WHITE in the default color scheme.
`)
0x10=
`(
Draws the top and bottom edges of the static control using the
EDGE_ETCHED edge style.
`)
0x11=
`(
Draws the left and right edges of the static control using the
EDGE_ETCHED edge style.
`)
0x12=
`(
Draws the frame of the static control using the
EDGE_ETCHED edge style.
`)
0x1000=
`(
Draws a half-sunken border around a static control.
`)

Desc=
`(
This Script is just a demostration of the styles that you can apply to Text controls.

To apply a style just write the code like this: Gui, add, Text, [options] [style]
Ex. Gui, add, Text, w50 h50 x20 y25 0x4

As you can see this opens tons of posibilities in your Gui Creation and
with enough creativity you can create cool interfaces!
Dont limit yourself to the defaults!

**Press Esc to close the Aplication
`)

Gui, add, Text, w50 h50 x20 y25 0x4
Gui, add, Text, wp hp y+32 0x5
Gui, add, Text, wp hp y+32 0x6
Gui, add, Text, wp hp y+32 0x7
Gui, add, Text, wp hp y+32 0x8
Gui, add, Text, x450 y25 wp hp 0x9
Gui, add, Text, wp hp y+52 0x10
Gui, add, Text, wp hp xp+20 y+12 0x11
Gui, add, Text, wp hp xp-20 y+32 0x12
Gui, add, Text, wp hp y+32 0x1000

Gui, add, Groupbox, w420 h75 x10 y10,0x4
Gui, add, Groupbox, wp hp,0x5
Gui, add, Groupbox, wp hp,0x6
Gui, add, Groupbox, wp hp,0x7
Gui, add, Groupbox, wp hp,0x8
Gui, add, Groupbox, x440 y10 wp hp,0x9
Gui, add, Groupbox, wp hp,0x10
Gui, add, Groupbox, wp hp,0x11
Gui, add, Groupbox, wp hp,0x12
Gui, add, Groupbox, wp hp,0x1000

Gui, add, Text, x80 y35, `%0x4`%
Gui, add, Text,y+60, `%0x5`%
Gui, add, Text,y+55, `%0x6`%
Gui, add, Text,y+55, `%0x7`%
Gui, add, Text,y+55, `%0x8`%
Gui, add, Text,x510 y35, `%0x9`%
Gui, add, Text,y+60, `%0x10`%
Gui, add, Text,y+55, `%0x11`%
Gui, add, Text,y+55, `%0x12`%
Gui, add, Text,y+60, `%0x1000`%
; --[Description]-----------------------------------------------------------------
Gui, add, Text, w750 x60 0x10
Gui, add, Text, w850 h150 xp-50 yp+7 0x7
Gui, add, Text, w840 hp-10 xp+5 yp+5 0x8
Gui, add, Text, w800 xp+5 yp+5, `%desc`%
Gui, add, Text, w50 h50 x+-150 yp+10 0x4
Gui, add, Text, w50 h50 x+5 0x5
Gui, add, Text, w50 h50 x670 y+5 0x7
Gui, add, Text, w50 h50 x+5 0x6

Gui show
return

Esc::
GuiClose:
    ExitApp
                    </Snippet>
                    <Snippet title="Version Test">
/*
 *********************************************************************
 * This Script is just a quick way to determine which version of     *
 * Autohotkey is being used by the Live Code feature.                *
 *                                                                   *
 * It is meant as a way of checking that you set up the correct      *
 * path to a different version of Autohotkey and that the program    *
 * is accessing that path correctly.                                 *
 *                                                                   *
 *********************************************************************
 */

version := "AHK Version: " a_ahkversion
unicode := "Supports Unicode: " `(a_isunicode ? "Yes" : "No"`)
Msgbox `% version "``n" unicode
                	</Snippet>
                    <Snippet title="Get Control Name">
/*
 *********************************************************************
 * This Script allows you to see the name of the control under the   *
 * mouse while at the same time copying the name to the clipboard    *
 * for later use.                                                    *
 *                                                                   *
 * Use Ctrl + Esc to exit the app, the last control name will be     *
 * still in clipboard.                                               *
 *********************************************************************
 */

loop
{
mousegetpos,,,,ctrl
tooltip `% clipboard:=ctrl
sleep 10
}
					</Snippet>
					<Snippet title="Get Control Hwnd">
/*
 *********************************************************************
 * This Script allows you to see the HWND of the control under the   *
 * mouse while at the same time copying the HWND to the clipboard    *
 * for later use.                                                    *
 *                                                                   *
 * Use Ctrl + Esc to exit the app, the last control HWND will be     *
 * still in clipboard.                                               *
 *********************************************************************
 */

loop
{
mousegetpos,,,,ctrl,2
tooltip `% clipboard:=ctrl
sleep 10
}
					</Snippet>
				</Group>
			</SnippetLib>
    )
    template3=
    (
			<Keywords>
				<Directives list="0">
allowsamelinecomments clipboardtimeout commentflag errorstdout escapechar hotkeyinterval hotkeymodifiertimeout hotstring if iftimeout ifwinactive ifwinexist include includeagain installkeybdhook installmousehook keyhistory ltrim maxhotkeysperinterval maxmem maxthreads maxthreadsbuffer maxthreadsperhotkey menumaskkey noenv notrayicon persistent singleinstance usehook warn winactivateforce
                </Directives>
				<Commands list="1">
autotrim blockinput clipwait control controlclick controlfocus controlget controlgetfocus controlgetpos controlgettext controlmove controlsend controlsendraw controlsettext coordmode critical detecthiddentext detecthiddenwindows drive driveget drivespacefree edit endrepeat envadd envdiv envget envmult envset envsub envupdate fileappend filecopy filecopydir filecreatedir filecreateshortcut filedelete filegetattrib filegetshortcut filegetsize filegettime filegetversion fileinstall filemove filemovedir fileread filereadline filerecycle filerecycleempty fileremovedir fileselectfile fileselectfolder filesetattrib filesettime formattime getkeystate groupactivate groupadd groupclose groupdeactivate gui guicontrol guicontrolget hideautoitwin hotkey if ifequal ifexist ifgreater ifgreaterorequal ifinstring ifless iflessorequal ifmsgbox ifnotequal ifnotexist ifnotinstring ifwinactive ifwinexist ifwinnotactive ifwinnotexist imagesearch inidelete iniread iniwrite input inputbox keyhistory keywait listhotkeys listlines listvars menu mouseclick mouseclickdrag mousegetpos mousemove msgbox outputdebug pixelgetcolor pixelsearch postmessage process progress random regdelete regread regwrite reload run runas runwait send sendevent sendinput sendmessage sendmode sendplay sendraw setbatchlines setcapslockstate setcontroldelay setdefaultmousespeed setenv setformat setkeydelay setmousedelay setnumlockstate setscrolllockstate setstorecapslockmode settitlematchmode setwindelay setworkingdir shutdown sort soundbeep soundget soundgetwavevolume soundplay soundset soundsetwavevolume splashimage splashtextoff splashtexton splitpath statusbargettext statusbarwait stringcasesense stringgetpos stringleft stringlen stringlower stringmid stringreplace stringright stringsplit stringtrimleft stringtrimright stringupper sysget thread tooltip transform traytip urldownloadtofile winactivate winactivatebottom winclose winget wingetactivestats wingetactivetitle wingetclass wingetpos wingettext wingettitle winhide winkill winmaximize winmenuselectitem winminimize winminimizeall winminimizeallundo winmove winrestore winset winsettitle winshow winwait winwaitactive winwaitclose winwaitnotactive fileencoding true false
                </Commands>
				<FlowControl list="2">
break continue else exit exitapp gosub goto loop onexit pause repeat return settimer sleep suspend static global local byref while until for
                </FlowControl>
				<Functions list="3">
abs acos asc asin atan ceil chr cos dllcall exp fileexist floor getkeystate numget numput registercallback il_add il_create il_destroy instr islabel isfunc ln log lv_add lv_delete lv_deletecol lv_getcount lv_getnext lv_gettext lv_insert lv_insertcol lv_modify lv_modifycol lv_setimagelist mod onmessage round regexmatch regexreplace sb_seticon sb_setparts sb_settext sin sqrt strlen substr tan tv_add tv_delete tv_getchild tv_getcount tv_getnext tv_get tv_getparent tv_getprev tv_getselection tv_gettext tv_modify varsetcapacity winactive winexist trim ltrim rtrim fileopen strget strput object isobject objinsert objremove objminindex objmaxindex objsetcapacity objgetcapacity objgetaddress objnewenum objaddref objrelease objclone _insert _remove _minindex _maxindex _setcapacity _getcapacity _getaddress _newenum _addref _release _clone comobjcreate comobjget comobjconnect comobjerror comobjactive comobjenwrap comobjunwrap comobjparameter comobjmissing comobjtype comobjvalue comobjarray
                </Functions>
				<BuiltInVars list="4">
a_ahkpath a_ahkversion a_appdata a_appdatacommon a_autotrim a_batchlines a_caretx a_carety a_computername a_controldelay a_cursor a_dd a_ddd a_dddd a_defaultmousespeed a_desktop a_desktopcommon a_detecthiddentext a_detecthiddenwindows a_endchar a_eventinfo a_exitreason a_formatfloat a_formatinteger a_gui a_guievent a_guicontrol a_guicontrolevent a_guiheight a_guiwidth a_guix a_guiy a_hour a_iconfile a_iconhidden a_iconnumber a_icontip a_index a_ipaddress1 a_ipaddress2 a_ipaddress3 a_ipaddress4 a_isadmin a_iscompiled a_issuspended a_keydelay a_language a_lasterror a_linefile a_linenumber a_loopfield a_loopfileattrib a_loopfiledir a_loopfileext a_loopfilefullpath a_loopfilelongpath a_loopfilename a_loopfileshortname a_loopfileshortpath a_loopfilesize a_loopfilesizekb a_loopfilesizemb a_loopfiletimeaccessed a_loopfiletimecreated a_loopfiletimemodified a_loopreadline a_loopregkey a_loopregname a_loopregsubkey a_loopregtimemodified a_loopregtype a_mday a_min a_mm a_mmm a_mmmm a_mon a_mousedelay a_msec a_mydocuments a_now a_nowutc a_numbatchlines a_ostype a_osversion a_priorhotkey a_programfiles a_programs a_programscommon a_screenheight a_screenwidth a_scriptdir a_scriptfullpath a_scriptname a_sec a_space a_startmenu a_startmenucommon a_startup a_startupcommon a_stringcasesense a_tab a_temp a_thishotkey a_thismenu a_thismenuitem a_thismenuitempos a_tickcount a_timeidle a_timeidlephysical a_timesincepriorhotkey a_timesincethishotkey a_titlematchmode a_titlematchmodespeed a_username a_wday a_windelay a_windir a_workingdir a_yday a_year a_yweek a_yyyy clipboard clipboardall comspec programfiles a_thisfunc a_thislabel a_ispaused a_iscritical a_isunicode a_ptrsize errorlevel
                </BuiltInVars>
				<Keys list="5">
shift lshift rshift alt lalt ralt control lcontrol rcontrol ctrl lctrl rctrl lwin rwin appskey altdown altup shiftdown shiftup ctrldown ctrlup lwindown lwinup rwindown rwinup lbutton rbutton mbutton wheelup wheeldown xbutton1 xbutton2 joy1 joy2 joy3 joy4 joy5 joy6 joy7 joy8 joy9 joy10 joy11 joy12 joy13 joy14 joy15 joy16 joy17 joy18 joy19 joy20 joy21 joy22 joy23 joy24 joy25 joy26 joy27 joy28 joy29 joy30 joy31 joy32 joyx joyy joyz joyr joyu joyv joypov joyname joybuttons joyaxes joyinfo space tab enter escape esc backspace bs delete del insert ins pgup pgdn home end up down left right printscreen ctrlbreak pause scrolllock capslock numlock numpad0 numpad1 numpad2 numpad3 numpad4 numpad5 numpad6 numpad7 numpad8 numpad9 numpadmult numpadadd numpadsub numpaddiv numpaddot numpaddel numpadins numpadclear numpadup numpaddown numpadleft numpadright numpadhome numpadend numpadpgup numpadpgdn numpadenter f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 browser_back browser_forward browser_refresh browser_stop browser_search browser_favorites browser_home volume_mute volume_down volume_up media_next media_prev media_stop media_play_pause launch_mail launch_media launch_app1 launch_app2 blind click raw wheelleft wheelright
                </Keys>
				<Parameters list="6">
ltrim rtrim join ahk_id ahk_pid ahk_class ahk_group processname minmax controllist statuscd filesystem setlabel alwaysontop mainwindow nomainwindow useerrorlevel altsubmit hscroll vscroll imagelist wantctrla wantf2 vis visfirst wantreturn backgroundtrans minimizebox maximizebox sysmenu toolwindow exstyle check3 checkedgray readonly notab lastfound lastfoundexist alttab shiftalttab alttabmenu alttabandmenu alttabmenudismiss controllisthwnd hwnd deref pow bitnot bitand bitor bitxor bitshiftleft bitshiftright sendandmouse mousemove mousemoveoff hkey_local_machine hkey_users hkey_current_user hkey_classes_root hkey_current_config hklm hku hkcu hkcr hkcc reg_sz reg_expand_sz reg_multi_sz reg_dword reg_qword reg_binary reg_link reg_resource_list reg_full_resource_descriptor caret reg_resource_requirements_list reg_dword_big_endian regex pixel mouse screen relative rgb low belownormal normal abovenormal high realtime between contains in is integer float number digit xdigit alpha upper lower alnum time date not or and topmost top bottom transparent transcolor redraw region id idlast count list capacity eject lock unlock label serial type status seconds minutes hours days read parse logoff close error single shutdown menu exit reload tray add rename check uncheck togglecheck enable disable toggleenable default nodefault standard nostandard color delete deleteall icon noicon tip click show edit progress hotkey text picture pic groupbox button checkbox radio dropdownlist ddl combobox statusbar treeview listbox listview datetime monthcal updown slider tab tab2 iconsmall tile report sortdesc nosort nosorthdr grid hdr autosize range xm ym ys xs xp yp font resize owner submit nohide minimize maximize restore noactivate na cancel destroy center margin owndialogs guiescape guiclose guisize guicontextmenu guidropfiles tabstop section wrap border top bottom buttons expand first lines number uppercase lowercase limit password multi group background bold italic strike underline norm theme caption delimiter flash style checked password hidden left right center section move focus hide choose choosestring text pos enabled disabled visible notimers interrupt priority waitclose unicode tocodepage fromcodepage yes no ok cancel abort retry ignore force on off all send wanttab monitorcount monitorprimary monitorname monitorworkarea pid base useunsetlocal useunsetglobal localsameasglobal
                </Parameters>
            </Keywords>
    )
    template4=
    (
            <Styles>
                <Style name="Default" id="0" fgColor="000000" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Comment Line" id="1" fgColor="008000" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Comment Block" id="2" fgColor="008000" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Escape Secuence" id="3" fgColor="FF0000" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Syn Operator" id="4" fgColor="FF0000" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Exp Operator" id="5" fgColor="0000FF" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="String" id="6" fgColor="808080" bgColor="FFFFFF" fName="" fStyle="2"/>
                <Style name="Number" id="7" fgColor="FF8000" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Identifier" id="8" fgColor="000000" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Label" id="9" fgColor="0080FF" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Variables" id="10" fgColor="FF8000" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Variable Delimiter" id="11" fgColor="FF8000" bgColor="FFFFFF" fName="" fStyle="3"/>
                <Style name="Error" id="12" fgColor="EE0000" bgColor="FF8080" fName="" fStyle="1"/>
                <!--Keywords -->
                <Style name="Directives" id="13" fgColor="0000FF" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Commands" id="14" fgColor="0000FF" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Flow Control" id="15" fgColor="0000FF" bgColor="FFFFFF" fName="" fStyle="1"/>
                <Style name="Functions" id="16" fgColor="FF80FF" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="Built-in Variables" id="17" fgColor="FF8000" bgColor="FFFFFF" fName="" fStyle="3"/>
                <Style name="Keys and Buttons" id="18" fgColor="000000" bgColor="FFFFFF" fName="" fStyle="3"/>
                <Style name="Parameters" id="19" fgColor="408080" bgColor="FFFFFF" fName="" fStyle="0"/>
                <Style name="User Defined" id="20" fgColor="FF0000" bgColor="FFFFFF" fName="" fStyle="0"/>
            </Styles>
        </LiveCode>
        <ScrTools altdrag="1" prtscr="1">
            <Imagebin current="Imageshack">
                <Imagebin nick="">http://imagebin.org/index.php?page=add</Imagebin>
                <Imageshack private="0" user="" pass="">http://www.imageshack.us/upload_api.php</Imageshack>
            </Imagebin>
        </ScrTools>
    </Options>
    <Hotkeys count="0"/>
    <Hotstrings count="0"/>
</AHK-Toolkit>
    )
    FileDelete, %path%
    Sleep, 500

    ; Appending tabs because AutoHotkey deletes them at the beginning of the continuation section.
    FileAppend, %template%`n`t`t%template2%`n`t`t`t%template3%`n`t`t`t%template4%, %path%, UTF-8
    return ErrorLevel
}
rName(length="", filext=""){
	if !length
		Random, length, 8, 15
	Loop,26
		n .= chr(64+a_index) chr(96+a_index)
	n .= "0123456789"
	Loop,% length {
		Random,rnd,1,% StrLen(n)
		Random,UL,0,1
		rName .= RegExReplace(SubStr(n,rnd,1),".$","$" (round(UL)? "U":"L") "0")
	}
	if !filext
		return rName
	Else
		return rName . "." . filext
}
updateSB(){
    global $hwnd1

    WinGetPos,,, _w,, ahk_id %$hwnd1%
    SB_SetParts(150,150,_w - 378,50) ; including 8 pixes for the borders.
    SB_SetText("`t" root.selectSingleNode("//Hotkeys/@count").text " Hotkeys currently active",1)
    SB_SetText("`t" root.selectSingleNode("//Hotstrings/@count").text " Hotstrings currently active",2)
    SB_SetText("`tv" script.version,4)
    return
}
lcRun(_gui=0){

    lcfPath := a_temp . "\" . rName(5, "code")        ; Random Live Code Path

    if _gui = 01
        sci[1].GetText(sci[1].GetLength()+1, _code)
    else
        _code := Clipboard

    if !InStr(_code,"Gui")
        _code .= "`n`nExitApp"
    else if !InStr(_code,"GuiClose")
    {
        if !InStr(_code,"return")
            _code .= "`nreturn"
        _code .= "`n`nGuiClose:`nExitApp"
    }

    live_code =
    (Ltrim
        ;[Directives]{
        #NoEnv
        #SingleInstance Force
        ; --
        SetBatchLines -1
        SendMode Input
        SetWorkingDir %a_scriptdir%
        ; --
        ;}

        sec         :=  1000               ; 1 second
        min         :=  sec * 60           ; 1 minute
        hour        :=  min * 60           ; 1 hour

        %_code%

    )
    if !InStr(_code, "^Esc::ExitApp")
        live_code .= "^Esc::ExitApp"

    FileAppend, %live_code%, %lcfPath%

    ahkpath := options.selectSingleNode("//RCPaths/" options.selectSingleNode("//RCPaths/@current").text).text
    if !ahkpath
    {
        ahkpath := a_temp "\ahkl.bak"
        FileInstall, res\ahkl.bak, %ahkpath%
    }

    Run, %ahkpath% %lcfPath%
    return
}
pasteUpload(mode=""){
    conf.load(script.conf), root:=conf.documentElement, options:=root.firstChild

    FormatTime,pb_time,,[MMM/dd/yyyy - HH:mm:ss]
    sci[5].GetText(sci[5].GetLength()+1,pb_code)
    node := options.selectSingleNode("//Codet/Pastebin")
    if (mode = "show"){
        Gui, 94: Show, NoActivate
        WinGetPos,,, 94Width, 94Height, ahk_id %$Hwnd94%
        WinMove, ahk_id %$Hwnd94%,, system.wa.Right,% system.wa.Bottom - 94Height
        pop_Right := system.wa.Right - 2
        Loop, 5
        {
            pop_Right -= 94Width/5
            WinMove, ahk_id %$Hwnd94%,,% pop_Right
        }
        Settimer, Sleep, % 1*sec    ; Using a timer allows to "stop" the sleep time fixing the bug with
                                    ; Ctrl + C not working some times.
        return

        Sleep:
            if slp = 5
            {
                slp:=0
                SetTimer, Sleep, Off
                Gui, 94: Hide       ; Hide Codet Popup
            } slp++
        return
    }
    if (mode = "auto")
        pb_ddl := options.selectSingleNode("//Codet/Pastebin/@current").text

    ; [httpRequest]{
    if (pb_ddl = "Autohotkey.net"){
            URL := "http://www.autohotkey.net/paste/"
            POST:= "MAX_FILE_SIZE=262144"
                .  "&jscheck=1"
                .  "&text=" uriSwap(mode = "auto" ? Clipboard : pb_code, "e")
                .  "&description=" uriSwap(mode = "auto" ? null : pb_description, "e")
                .  "&submit=Paste"
                .  "&author="
                .  uriSwap(mode = "auto"  ? options.selectSingleNode("//Pastebin/AutoHotkey/@nick").text
                                          : pb_name, "e")
                .  "&irc=" ; note that here 1 = public and 0 = private, contrary to how i save it, hence the not.
                .  (mode = "auto" ? !options.selectSingleNode("//Pastebin/AutoHotkey/@private").text
                                  : (pb_exposure = "Public" ? 1 : 0))
    }
    else if (pb_ddl = "Pastebin.com"){
        pb_expiration := mode = "auto" ? options.selectSingleNode("//Pastebin/PasteBin/@expiration").text
                                       : pb_expiration
        URL := "http://www.pastebin.com/api/api_post.php"
        POST:= "api_option=paste"
            .  "&api_dev_key=786f7529a54ee64a1959612f2aeb8596"
            .  "&api_paste_code=" uriSwap(mode = "auto" ? Clipboard : pb_code, "e")
            .  "&api_paste_private="
            .  (mode = "auto" ? options.selectSingleNode("//Pastebin/PasteBin/@private").text
                              : (pb_exposure = "Public" ? 0 : 1))
            .  "&api_paste_name=" uriSwap(pb_name, "e")
            .  "&api_paste_format=autohotkey"
            .  "&api_paste_expire_date=" pb_expiration := (pb_expiration = "Never" ? "N"
                                                       :   pb_expiration = "10 Minutes" ? "10M"
                                                       :   pb_expiration = "1 Hour" ? "1H"
                                                       :   pb_expiration = "1 Day" ? "1D"
                                                       :   pb_expiration = "1 Month" ? "1M" : null)
    }

    httpRequest(URL,POST,headers:="", "charset: utf-8")
    RegexMatch(POST, "i)<title>Paste #(.*?)<\/title>|.com\/(.*)", pb_url)
    pb_url := (pb_ddl = "Pastebin.com" ? substr(URL, 1,24) : URL) pb_url1 pb_url2
    Tooltip, % "Copied: " Clipboard := pb_url, 5, 5
    SetTimer, ttOff, % "-" 5 * sec

    if (mode = "auto")
        SoundPlay, *48
    ;}


    Loop, parse, pb_code, `n, `r%a_space%%a_tab%
    {
        if a_index = 5
            break
        pb_preview .= pb_preview ? "[``n]" a_loopfield : "`n" a_loopfield
    }

    node := options.selectSingleNode("//Codet/History")
    if node.childNodes.length = node.attributes.item[0].text
        node.removeChild(node.firstChild)

    _h := conf.createElement("paste"), _h.setAttribute("time", pb_time), _h.setAttribute("url", pb_url)
    _h.text := pb_preview "`n                ", pb_preview := "" ; for xml formatting
    node.appendChild(_h)
    conf.transformNodeToObject(xsl, conf)
    conf.save(script.conf), conf.load(script.conf), root:=options:=_h:=null
    return

    ttOff:
        Tooltip
    return
}
Ena_Control(description="", exposure="", expiration="", guiNum=1){
    _varList := "description|exposure|expiration"
    Loop, parse, _varList, |
    {
        ctrl := (guiNum = 9 ? "pb_" : "pbp_") (a_loopfield = "description" ? "user" : a_loopfield)
        if (%a_loopfield% = 1)
            GuiControl, %guiNum%: enable, %ctrl%
        else if (%a_loopfield% = 0)
            GuiControl, %guiNum%: disable, %ctrl%
    }
    return
}
repIncludes(code){

    /*
    * This will replace the includes for the actual files to avoid
    * the issues of missing includes on Pasted code
    */
    Loop, parse, code, `n, `r
    {
        if inStr(a_loopfield, "#Include")
        {
            ; need to work with relative paths
            inc_file := RegexReplace(a_loopfield, "i)^#include\s|\*i\s|\s;.*")
            if inc_file contains .ahk
                FileRead, inc_%a_index%, %inc_file%
            else
                SetWorkingDir, %inc_file%
            Stringreplace, code, code, %a_loopfield%, % inc_%a_index%
        }
        else
            continue
    }
    SetWorkingDir %a_scriptdir%
    return code
}
matchclip(type, funct=""){

    clipold := Clipboard
	httpRequest(URL := "http://www.autohotkey.com/docs/" type ".htm", htm)

	if type = Variables
    {
        if !RegexMatch(htm, "i)" . Clipboard, Match)
            return 0
        if InStr(Clipboard, "screen")
            Match := URL . "#Screen"
        else if InStr(Clipboard, "caret")
            Match := URL . "#Caret"
        else if InStr(Clipboard, "guiheight")
            Match := URL . "#GuiWidth"
        else
            Match := URL . "#" . SubStr(Match, 3)
        return Match
    }
    if type = Functions
    {
        if !RegexMatch(htm, "i)" . funct, Match)
            return 0
        if (InStr(funct, "regex") || InStr(funct, "dllcall"))
            return Match := matchclip("cmd")
        else if InStr(funct, "asc")
            return Match := URL . "#Asc"
        else if InStr(funct, "abs")
            return Match := URL . "#Abs"
        else
            Match := URL . "#" . Match
        return Match
    }
    if type = Commands
    {
        if ((InStr(Clipboard, "clipboard") || InStr(Clipboard, "thread")) && !InStr(Clipboard, "regex"))
            URL := "http://www.autohotkey.com/docs/misc/"
        else
            URL := "http://www.autohotkey.com/docs/commands/"

        if !RegexMatch(htm, "i)>(" . RegexReplace(Clipboard, "\W.*", "") . ").*?<", Match)
            return 0
        if InStr(Clipboard, "#")
            Match := URL . RegexReplace(Clipboard, "#", "_") . ".htm"
        else if (InStr(Clipboard, "regex") || InStr(Clipboard, "dllcall"))
            Match := URL . RegexReplace(Clipboard, "\s?\(.*\).*", "") . ".htm"
        else
            Match := URL . Match1 . ".htm"
        return Match
    }
    if type = manual
    {
        Match := RegexReplace(Clipboard, "\(.*", "")
        if InStr(Match, "guiwidth")
            Match := "A_GuiWidth"
        ToolTip, % "Searching for """ . Match . """ on the documentation files"
        Sleep 2*sec
        URL := "http://www.autohotkey.com/search/search.php"
        POST := "site=4"
             . "&refine=1"
             . "&template_demo=phpdig.html"
             . "&result_page=search.php"
             . "&query_string=" . Match
             . "&search=Go+..."
             . "&option=start"
             . "&path=docs%2F%25"

        httpRequest(URL, POST)
        if (Clipboard = "WinGet")
            RegexMatch(POST, "99.80 %.+?(href=""(.+?)"")", Match)
        else if (Clipboard = "ErrorLevel")
            RegexMatch(POST, "4.+82.92 %.+?(href=""(.+?)"")", Match)
        else
            RegexMatch(POST, "100.00 %.+?(href=""(.+?)"")", Match)
        return Match2
    }
	return 0
}
imgUpload(image_file, Anonymous_API_Key, byref output_XML=""){

   Static Imgur_Upload_Endpoint := "http://api.imgur.com/2/upload.xml"
   FileGetSize, size, % image_file
   FileRead, output_XML, % "*c " image_file
   If HTTPRequest( Imgur_Upload_Endpoint "?key=" Anonymous_API_Key, output_XML
      , Response_Headers := "Content-Type: application/octet-stream`nContent-Length: " size
      , "Callback: CustomProgress" )
   && ( pos := InStr( output_XML, "<original>" ) )
      Return SubStr( output_XML, pos + 10, Instr( output_XML, "</original>", 0, pos ) - pos - 10 )
   Else Return "" ; error: see response
}
CustomProgress(pct, total){
If ( pct = "" )
   Tooltip
Else If ( pct < 0 )
   Tooltip, % "Uploading " Round( 100 * ( pct + 1 ), 1 ) "%. "
   . Round( ( pct + 1 ) * total, 0 ) " of " total " bytes."
}

; Storage
WM(var){
    static

    MOUSEMOVE:=0x200,COMMAND:=0x111
    EDITLABEL:=a_isunicode ? 4214 : 4119
    return lvar:=%var%
}
;}

;[Classes]{
;}

;[Hotkeys/Hotstrings]{
^F12::Suspend, Toggle
^CtrlBreak::Reload

#if options.selectSingleNode("//ScrTools/@altdrag").text && !WinActive("ahk_group ScreenTools")
;} Added for correct folding in C++ Lexer (To be removed when finished)
!LButton::                                                              ;{ [Alt + LButton] Capture Active Window/Area
    CoordMode, Mouse, Screen
    rect := False
    MouseGetPos, scXL, scYT
    WinMove, % "SelBox",, %scXL%, %scYT%
    Sleep, 150
    if GetKeyState("LButton", "P"){
    Gui, 99: Show, w1 h1 x%scXL% y%scYT%, % "SelBox"
    WinSet, Transparent, 120, % "SelBox"
    While GetKeyState("LButton", "P")
    {
        ; amazing solution by adabo
        ; first we check which direction we are dragging the mouse
        ; then we calculate the width and height and finally show the GUI
        MouseGetPos, scXR, scYB
        if (scXL < scXR) and (scYT < scYB) ; direction - right up
            Gui, 99:Show, % "x"(scXL) "y"(scYT) "w"(scXR - scXL) "h"(scYB - scYT), % "SelBox"

        if (scXL < scXR) and (scYT > scYB) ; direction - right down
            Gui, 99:Show, % "x"(scXL) "y"(scYB) "w"(scXR - scXL) "h"(scYT - scYB), % "SelBox"

        if (scXL > scXR) and (scYT < scYB) ; direction - left up
            Gui, 99:Show, % "x"(scXR) "y"(scYT) "w"(scXL - scXR) "h"(scYB - scYT), % "SelBox"

        if (scXL > scXR) and (scYT > scYB) ; direction - left down
            Gui, 99:Show, % "x"(scXR) "y"(scYB) "w"(scXL - scXR) "h"(scYT - scYB), % "SelBox"

        WinGetPos,,, guiw, guih, % "SelBox"
        ToolTip, % guiw "," guih
        if GetKeyState("RButton", "P")
        {
            ToolTip
            Gui, 99: Show, Hide w1 h1 x0 y0, % "SelBox"
            return
        }
    }
    ToolTip
    Gui, 99: Show, Hide w1 h1 x0 y0, % "SelBox"
    outputdebug, % scXL "-" scXR
    if (scXL < scXR)
        CaptureScreen(scXL "," scYT "," scXR "," scYB, 0, scRect := a_temp . "\scRect_" . rName(0,"png"))
    else
        CaptureScreen(scXR "," scYB "," scXL "," scYT, 0, scRect := a_temp . "\scRect_" . rName(0,"png"))
    rect := True
    }

#if options.selectSingleNode("//ScrTools/@prtscr").text
;} Added for correct folding in C++ Lexer (To be removed when finished)
PrintScreen::
    if (!rect)
        CaptureScreen(a_thishotkey = "Printscreen" ? 0 : 1, 0, scWin := a_temp . "\scWin_" . rName(0,"png"))

    if FileExist(scWin)
        image := scWin
    else if FileExist(scRect)
        image := scRect

    Tooltip % "Clipboard: " Clipboard := imgUpload(image, "cc6055c88e33af94a7577e2fe845ae66")
    Sleep, 5*sec
    Tooltip

    FileDelete, %scWin%
    FileDelete, %scRect%
    rect := False
return
;}
#if
;} Added for correct folding in C++ Lexer (To be removed when finished)
#IfWinActive

^F5::                                                                   ;{ [Ctrl + F5] Run Selected Code
    Send, ^c
    ClipWait
    lcRun()
return
;}

;{ Forum Hotstrings
#IfWinActive AutoHotkey Community
:*B0:[b]::[/b]{Left 4}
:*B0:[c]::[/c]{Left 4}
:*B0:[i]::[/i]{Left 4}
:*B0:[u]::[/u]{Left 4}
:*B0:[s]::[/s]{Left 4}
:*B0:[list]::[/list]{Left 7}
:*B0:[code]::[/code]{Left 7}
:*B0:[quote]::[/quote]{Left 8}
:*B0:[youtube]::[/youtube]{Left 10}
:*B0:[gist]::[/gist]{Left 7}
:*B0:[img]::[/img]{Left 6}
:*B0:[url]::[/url]{Left 6}

:*B0:[url=::
    SendInput %clipboard%][/url]{Left 6}
return

:*B0:[color=::
    Menu, Color, Show
return

:*B0:[size=::
    Menu, Size, Show
return

#IfWinActive
;}
;}

/*
 * * * Compile_AHK SETTINGS BEGIN * * *
[AHK2EXE]
Exe_File=%In_Dir%\lib\AHK-ToolKit.exe
Alt_Bin=C:\Program Files\AutoHotkeyW\Compiler\AutoHotkeySC.bin
[VERSION]
Set_Version_Info=1
File_Version=0.8.1.1
Inc_File_Version=0
Internal_Name=AHK-TK
Legal_Copyright=GNU General Public License 3.0
Original_Filename=AutoHotkey Toolkit.exe
Product_Name=AutoHotkey Toolkit
Product_Version=0.8.1.1
[ICONS]
Icon_1=%In_Dir%\res\AHK-TK.ico
Icon_2=%In_Dir%\res\AHK-TK.ico
Icon_3=%In_Dir%\res\AHK-TK.ico
Icon_4=%In_Dir%\res\AHK-TK.ico
Icon_5=%In_Dir%\res\AHK-TK.ico
Icon_6=%In_Dir%\res\AHK-TK.ico
Icon_7=%In_Dir%\res\AHK-TK.ico

* * * Compile_AHK SETTINGS END * * *
*/
