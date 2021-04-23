; *****************************
; :: PULOVER'S MACRO CREATOR ::
; *****************************
; "An Interface-Based Automation Tool & Script Writer."
; Author: Pulover [Rodolfo U. Batista]
; rodolfoub@gmail.com
; Home: www.autohotkey.net/~Pulover/Index.html
; Forum: l.autohotkey.net/forum/topic85452.html
; Version: 2.05
; Release Date: July, 2012
; AutoHotkey Version: AHK_L 1.1.07.03
; GNU General Public License 3.0 or higher
; <http://www.gnu.org/licenses/gpl-3.0.txt>

/*

Change Log:

Version: 2.05
- Fixed syntax problems in Image/Pixel search.

Version: 2.04
- Made some minor changes in gui.

Version: 2.03
- Updated Graphic Buttons function to work with AHK_L 64bit (thanks to just me)
- Added Auto-execute Section to context help of Export Window.

Version: 2.02
- Added NoActivate (NA) option to ControlClick relative to window.
- Fixed PostMessage/SendMessage syntax error in exported scripts.

Version: 2.01
- Fixed some issues.

Version: 2.0
- Added SearchImage and SearchPixel commands.
- Added some If Statements commands.
- Added SendMessage and PostMessage commands.
- Added KeyWait option in Pause.
- Added Window-Sensitive Hotkey option in Export Menu.
- Added Clipboard Send in Text Command (removed Script option).
- Added option to return Mouse to initial position after playback.
- Added Context-Menu Help: Right-Click on a button or window to show links to AHK Online Help.
- ControlClick can now be used with position in window.
- Improved Mouse and Key Recording reliability.
- Loop now works for Playblack (Nested Loops won't work).
- Control Records can now record Window Title and Classes.
- Fixed: Control Record issues.
- Fixed: Up Keys not being recorded sometimes.
- Fixed: Program consuming too much CPU.
- Fixed some other issues.

Version: 1.64
- Added option to create Step-By-Step Macros: Each command of the list will be executed in sequence everytime you press the Hotkey (as in manual playback).

Version: 1.63
- Added option to select between Relative and Screen Mouse CoordMode.
- Fixed various issues.

Version: 1.62
- Corrected Sintax error in ControlClick.

Version: 1.61
- Added some tooltips with help from documentation.
- Added RunWait option in Run Command.

Version: 1.6
- Fixed not recording accurate mouse movements and intervals.
- Removed WinWaitActive from Window Recording.

Version: 1.53
- Fixed minor issues.

Version: 1.52
- Added option to use hotstrings in Export menu.
- Changed exported scripts to normal hotkeys (::) instead of the Hotkey command.
- Added option to select Speed Multiplier.
- Added Process (ahk_exe) identifier for Window selections.

Version: 1.51
- Added Playback Speed Control: Fast Forward & Slow Down keys.
- Added WinMove command.
- Fixed WinSet Top not working.

Version: 1.5
- Added Join option in Export window: it can append the current macro to another with different hotkeys.
- Added Record Controls Options.
- Added Find/Replace function in Edit Menu (Ctrl+F will open it too if Capture is off).
- Added Hotkeys to move rows: PageUp/PageDown can be used to move rows when Capture is off.
- Fixed an issue with the Hotkey insert box.
- Fixed: Tooltip not showing Previous Step in Manual Playback.
- Changed 'Duplicate' behavior: Selected rows will now be duplicated right after the last selected row.

Version: 1.42
- Fixed line breaks in exported scripts with Text/Script lines.

Version: 1.41
- Fixed an issue with Run command.
- Fixed an issue with delete key when Capture is off.
- Changed AborKey command in export from 'Reload' to 'ExitApp'.

Version: 1.4
- Added Ini Support: Current Settings will be saved on exit.
- Added Click Down/Up record option: It allows movement recording while holding a button (useful for Hand-Drawing).
- Added option to use Key Toggle State to set Relative Recording On/Off.
- Added Timed Interval Recording.
- Fixed: Minimum interval for mouse movement recording.

Version: 1.3
- Added Relative Mouse Clicks Recording (Hold CapsLock to record clicks and drags relative to the initial position).
- Added Window Class and Title recording.
- Added Window default delay (can be changed in Options Menu).
- Fixed: Record Mouse Movement bug.

Version: 1.21
- Fixed: Modification Keys not updating list correctly.

Version: 1.2
- Added Beta Recording Function (settings can be changed in Options Menu).
- Made Mouse Actions editable.
- Changed 'Loop' function behavior. It will now automatically create the loop start and end around selected rows.
- Added Icons to ListView.
- Changed default Delay value back to 0 and created a separate value for Mouse Delay. It can be changed in Options Menu.
- Fixed: Holding a modification key would cause a false input.
- Changed Column name 'Command' to 'Action'.
- Changed File Extension to "pmc" to allow future association with the Macro Creator.

Version: 1.1
- Fixed delay for entering combinations with Ctrl, Shift and Alt. Direct input no longer depends on the hotkey box but it can still be used with the Insert button.

Version: 1.01
- Changed default AbortKey to F9 because pressing the Ctrl key during execution would interfere with macro.
- Changed default Delay value to 1 for mouse performance reasons.
- Corrected some minor mistakes in guis.

*/

#NoEnv
#InstallKeybdHook
#MaxThreadsBuffer On
#MaxHotkeysPerInterval 999999999
#HotkeyInterval 9999999999
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Off
#WinActivateForce
SetTitleMatchMode, 2
SetControlDelay, -1
SetWinDelay, 0
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

CurrentVersion := "2.05"

;##### Ini File Read #####
IfExist, MacroCreator.ini
{
	IniRead, Lang, MacroCreator.ini, Language, Lang
	IniRead, AutoKey, MacroCreator.ini, HotKeys, AutoKey
	IniRead, ManKey, MacroCreator.ini, HotKeys, ManKey
	IniRead, AbortKey, MacroCreator.ini, HotKeys, AbortKey
	IniRead, Win1, MacroCreator.ini, HotKeys, Win1
;	IniRead, Win2, MacroCreator.ini, HotKeys, Win2
	IniRead, Win3, MacroCreator.ini, HotKeys, Win3
	IniRead, RecKey, MacroCreator.ini, HotKeys, RecKey
	IniRead, StopKey, MacroCreator.ini, HotKeys, StopKey
	IniRead, RelKey, MacroCreator.ini, HotKeys, RelKey
	IniRead, DelayG, MacroCreator.ini, Options, DelayG
	IniRead, ShowStep, MacroCreator.ini, Options, ShowStep
	IniRead, Mouse, MacroCreator.ini, Options, Mouse
	IniRead, Moves, MacroCreator.ini, Options, Moves
	IniRead, TimedI, MacroCreator.ini, Options, TimedI
	IniRead, Strokes, MacroCreator.ini, Options, Strokes
	IniRead, MScroll, MacroCreator.ini, Options, MScroll
	IniRead, ClickDn, MacroCreator.ini, Options, ClickDn
	IniRead, WClass, MacroCreator.ini, Options, WClass
	IniRead, WTitle, MacroCreator.ini, Options, WTitle
	IniRead, MDelay, MacroCreator.ini, Options, MDelay
	IniRead, DelayM, MacroCreator.ini, Options, DelayM
	IniRead, DelayW, MacroCreator.ini, Options, DelayW
	IniRead, TDelay, MacroCreator.ini, Options, TDelay
	IniRead, ToggleC, MacroCreator.ini, Options, ToggleC
	IniRead, RecKeybdCtrl, MacroCreator.ini, Options, RecKeybdCtrl
	IniRead, RecMouseCtrl, MacroCreator.ini, Options, RecMouseCtrl
	IniRead, CoordMouse, MacroCreator.ini, Options, CoordMouse
	IniRead, Fast, MacroCreator.ini, Options, Fast
	IniRead, Slow, MacroCreator.ini, Options, Slow
	IniRead, SpeedUp, MacroCreator.ini, Options, SpeedUp
	IniRead, SpeedDn, MacroCreator.ini, Options, SpeedDn
	IniRead, MouseReturn, MacroCreator.ini, Options, MouseReturn
	IniRead, VirtualKeys, MacroCreator.ini, Options, VirtualKeys
	IniRead, Ex_AutoKey, MacroCreator.ini, ExportOptions, Ex_AutoKey
	IniRead, Ex_AbortKey, MacroCreator.ini, ExportOptions, Ex_AbortKey
	IniRead, Ex_Hotstring, MacroCreator.ini, ExportOptions, Ex_Hotstring
	IniRead, Ex_HSOpt, MacroCreator.ini, ExportOptions, Ex_HSOpt
	IniRead, Ex_SQ, MacroCreator.ini, ExportOptions, Ex_SQ
	IniRead, Ex_BM, MacroCreator.ini, ExportOptions, Ex_BM
	IniRead, Ex_SM, MacroCreator.ini, ExportOptions, Ex_SM
	IniRead, SM, MacroCreator.ini, ExportOptions, SM
	IniRead, Ex_SI, MacroCreator.ini, ExportOptions, Ex_SI
	IniRead, SI, MacroCreator.ini, ExportOptions, SI
	IniRead, Ex_ST, MacroCreator.ini, ExportOptions, Ex_ST
	IniRead, ST, MacroCreator.ini, ExportOptions, ST
	IniRead, Ex_DH, MacroCreator.ini, ExportOptions, Ex_DH
	IniRead, Ex_AF, MacroCreator.ini, ExportOptions, Ex_AF
	IniRead, Ex_IN, MacroCreator.ini, ExportOptions, Ex_IN
	IniRead, IN, MacroCreator.ini, ExportOptions, IN
	IniRead, Ex_NT, MacroCreator.ini, ExportOptions, Ex_NT
	IniRead, Ex_SC, MacroCreator.ini, ExportOptions, Ex_SC
	IniRead, SC, MacroCreator.ini, ExportOptions, SC
	IniRead, Ex_SW, MacroCreator.ini, ExportOptions, Ex_SW
	IniRead, SW, MacroCreator.ini, ExportOptions, SW
	IniRead, Ex_SK, MacroCreator.ini, ExportOptions, Ex_SK
	IniRead, SK, MacroCreator.ini, ExportOptions, SK
	IniRead, Ex_MD, MacroCreator.ini, ExportOptions, Ex_MD
	IniRead, MD, MacroCreator.ini, ExportOptions, MD
	IniRead, Ex_SB, MacroCreator.ini, ExportOptions, Ex_SB
	IniRead, SB, MacroCreator.ini, ExportOptions, SB
	IniRead, WinState, MacroCreator.ini, WindowOptions, WinState
	IniRead, ColSizes, MacroCreator.ini, WindowOptions, ColSizes
	Goto, StartApp
}

Version := CurrentVersion

GoSub, LoadSettings

If ((A_Language = 0416) || (A_Language = 0816))
	Lang = Pt
Else
	Lang = En

GoSub, WriteSettings

StartApp:

If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME
{
	MsgBox This program requires Windows 2000/XP or later.
	ExitApp
}

If A_OSVersion in WIN_7,WIN_VISTA
{
	NewIcon := "wmploc.dll:" 178
	OpenIcon := "shell32.dll:" 45
	SaveIcon := "shell32.dll:" 258
	ExportIcon := "shell32.dll:" 68
	PreviewIcon := "shell32.dll:" 22
	OptionsIcon := "wmploc.dll:" 24
	MouseIcon := "DDORes.dll:" 27
	TextIcon := "DDORes.dll:" 26
	SpecialIcon := "wmploc.dll:" 15
	PauseIcon := "shell32.dll:" 265
	WindowIcon := "shell32.dll:" 2
	ImageIcon := "shell32.dll:" 302
	RunIcon := "shell32.dll:" 24
	LoopIcon := "wmploc.dll:" 137
	RecordIcon := "wmploc.dll:" 157
	StartIcon := "shell32.dll:" 137
	RemoveIcon := "shell32.dll:" 131
	IconId1 := "Icon27"
	IconId2 := "Icon28"
	IconId3 := "Icon20"
	IconId4 := "Icon15"
	IconId5 := "Icon11"
	IconId6 := "Icon25"
	IconId7 := "Icon17"
	IconId8 := "Icon16"
}

If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
	NewIcon := "shell32.dll:" 100
	OpenIcon := "shell32.dll:" 4
	SaveIcon := "shell32.dll:" 78
	ExportIcon := "shell32.dll:" 66
	PreviewIcon := "shell32.dll:" 22
	OptionsIcon := "shell32.dll:" 165
	MouseIcon := "Main.cpl:" 0
	TextIcon := "Main.cpl:" 7
	SpecialIcon := "wmploc.dll:" 14
	PauseIcon := "shell32.dll:" 20
	WindowIcon := "shell32.dll:" 2
	ImageIcon := "wmploc.dll:" 34
	RunIcon := "shell32.dll:" 24
	LoopIcon := "xpsp2res.dll:" 53
	RecordIcon := "Mmsys.cpl:" 24
	StartIcon := "shell32.dll:" 137
	RemoveIcon := "shell32.dll:" 131
	IconId1 := "Icon3"
	IconId2 := "Icon2"
	IconId3 := "Icon25"
	IconId4 := "Icon31"
	IconId5 := "Icon31"
	IconId6 := "Icon23"
	IconId7 := "Icon1"
	IconId8 := "Icon21"
}

;##### Definitions: #####

Version := CurrentVersion
Delimiter := "|"
ListCount := 0
Type1 := "Send"
Type2 := "ControlSend"
Type3 := "Click"
Type4 := "ControlClick"
Type5 := "Sleep"
Type6 := "MsgBox"
Type7 := "Loop"
Type8 := "SendRaw"
Type9 := "ControlSendRaw"
Type10 := "ControlSetText"
Type11 := "Run"
Type12 := "Clipboard"
Type13 := "SendEvent"
Type14 := "RunWait"
Type15 := "PixelSearch"
Type16 := "ImageSearch"
Type17 := "If Statement"
Type18 := "SendMessage"
Type19 := "PostMessage"
Type20 := "KeyWait"
Action1 := "Click"
Action2 := "Move"
Action3 := "Move & Click"
Action4 := "Click & Drag"
Action5 := "Mouse Wheel Up"
Action6 := "Mouse Wheel Down"
If1 := "If Window Active"
If2 := "If Window Not Active"
If3 := "If Window Exist"
If4 := "If Window Not Exist"
If5 := "If File Exist"
If6 := "If File Not Exist"
If7 := "If Clipboard Text"
If8 := "If Loop Index"
If9 := "If Image/Pixel Found"
If10 := "If Image/Pixel Not Found"
Help5 := "MouseB"
Help8 := "TextB"
Help7 := "SpecialB"
Help14 := "ExportG"
Help3 := "PauseB"
Help11 := "WindowB"
Help19 := "ImageB"
Help10 := "RunB"
Help12 := "ComLoopB"
Help21 := "IfStB"
Help22 := "SendMsgB"

;##### Messages: #####

WM_NULL = 0x00
WM_CREATE = 0x01
WM_DESTROY = 0x02
WM_MOVE = 0x03
WM_SIZE = 0x05
WM_ACTIVATE = 0x06
WM_SETFOCUS = 0x07
WM_KILLFOCUS = 0x08
WM_ENABLE = 0x0A
WM_SETREDRAW = 0x0B
WM_SETTEXT = 0x0C
WM_GETTEXT = 0x0D
WM_GETTEXTLENGTH = 0x0E
WM_PAINT = 0x0F
WM_CLOSE = 0x10
WM_QUERYENDSESSION = 0x11
WM_QUIT = 0x12
WM_QUERYOPEN = 0x13
WM_ERASEBKGND = 0x14
WM_SYSCOLORCHANGE = 0x15
WM_ENDSESSION = 0x16
WM_SYSTEMERROR = 0x17
WM_SHOWWINDOW = 0x18
WM_CTLCOLOR = 0x19
WM_WININICHANGE = 0x1A
WM_SETTINGCHANGE = 0x1A
WM_DEVMODECHANGE = 0x1B
WM_ACTIVATEAPP = 0x1C
WM_FONTCHANGE = 0x1D
WM_TIMECHANGE = 0x1E
WM_CANCELMODE = 0x1F
WM_SETCURSOR = 0x20
WM_MOUSEACTIVATE = 0x21
WM_CHILDACTIVATE = 0x22
WM_QUEUESYNC = 0x23
WM_GETMINMAXINFO = 0x24
WM_PAINTICON = 0x26
WM_ICONERASEBKGND = 0x27
WM_NEXTDLGCTL = 0x28
WM_SPOOLERSTATUS = 0x2A
WM_DRAWITEM = 0x2B
WM_MEASUREITEM = 0x2C
WM_DELETEITEM = 0x2D
WM_VKEYTOITEM = 0x2E
WM_CHARTOITEM = 0x2F

WM_SETFONT = 0x30
WM_GETFONT = 0x31
WM_SETHOTKEY = 0x32
WM_GETHOTKEY = 0x33
WM_QUERYDRAGICON = 0x37
WM_COMPAREITEM = 0x39
WM_COMPACTING = 0x41
WM_WINDOWPOSCHANGING = 0x46
WM_WINDOWPOSCHANGED = 0x47
WM_POWER = 0x48
WM_COPYDATA = 0x4A
WM_CANCELJOURNAL = 0x4B
WM_NOTIFY = 0x4E
WM_INPUTLANGCHANGEREQUEST = 0x50
WM_INPUTLANGCHANGE = 0x51
WM_TCARD = 0x52
WM_HELP = 0x53
WM_USERCHANGED = 0x54
WM_NOTIFYFORMAT = 0x55
WM_CONTEXTMENU = 0x7B
WM_STYLECHANGING = 0x7C
WM_STYLECHANGED = 0x7D
WM_DISPLAYCHANGE = 0x7E
WM_GETICON = 0x7F
WM_SETICON = 0x80

WM_NCCREATE = 0x81
WM_NCDESTROY = 0x82
WM_NCCALCSIZE = 0x83
WM_NCHITTEST = 0x84
WM_NCPAINT = 0x85
WM_NCACTIVATE = 0x86
WM_GETDLGCODE = 0x87
WM_NCMOUSEMOVE = 0xA0
WM_NCLBUTTONDOWN = 0xA1
WM_NCLBUTTONUP = 0xA2
WM_NCLBUTTONDBLCLK = 0xA3
WM_NCRBUTTONDOWN = 0xA4
WM_NCRBUTTONUP = 0xA5
WM_NCRBUTTONDBLCLK = 0xA6
WM_NCMBUTTONDOWN = 0xA7
WM_NCMBUTTONUP = 0xA8
WM_NCMBUTTONDBLCLK = 0xA9

WM_KEYFIRST = 0x100
WM_KEYDOWN = 0x100
WM_KEYUP = 0x101
WM_CHAR = 0x102
WM_DEADCHAR = 0x103
WM_SYSKEYDOWN = 0x104
WM_SYSKEYUP = 0x105
WM_SYSCHAR = 0x106
WM_SYSDEADCHAR = 0x107
WM_KEYLAST = 0x108

WM_IME_STARTCOMPOSITION = 0x10D
WM_IME_ENDCOMPOSITION = 0x10E
WM_IME_COMPOSITION = 0x10F
WM_IME_KEYLAST = 0x10F

WM_INITDIALOG = 0x110
WM_COMMAND = 0x111
WM_SYSCOMMAND = 0x112
WM_TIMER = 0x113
WM_HSCROLL = 0x114
WM_VSCROLL = 0x115
WM_INITMENU = 0x116
WM_INITMENUPOPUP = 0x117
WM_MENUSELECT = 0x11F
WM_MENUCHAR = 0x120
WM_ENTERIDLE = 0x121

WM_CTLCOLORMSGBOX = 0x132
WM_CTLCOLOREDIT = 0x133
WM_CTLCOLORLISTBOX = 0x134
WM_CTLCOLORBTN = 0x135
WM_CTLCOLORDLG = 0x136
WM_CTLCOLORSCROLLBAR = 0x137
WM_CTLCOLORSTATIC = 0x138

WM_MOUSEFIRST = 0x200
WM_MOUSEMOVE = 0x200
WM_LBUTTONDOWN = 0x201
WM_LBUTTONUP = 0x202
WM_LBUTTONDBLCLK = 0x203
WM_RBUTTONDOWN = 0x204
WM_RBUTTONUP = 0x205
WM_RBUTTONDBLCLK = 0x206
WM_MBUTTONDOWN = 0x207
WM_MBUTTONUP = 0x208
WM_MBUTTONDBLCLK = 0x209
WM_MOUSEWHEEL = 0x20A
WM_MOUSEHWHEEL = 0x20E

WM_PARENTNOTIFY = 0x210
WM_ENTERMENULOOP = 0x211
WM_EXITMENULOOP = 0x212
WM_NEXTMENU = 0x213
WM_SIZING = 0x214
WM_CAPTURECHANGED = 0x215
WM_MOVING = 0x216
WM_POWERBROADCAST = 0x218
WM_DEVICECHANGE = 0x219

WM_MDICREATE = 0x220
WM_MDIDESTROY = 0x221
WM_MDIACTIVATE = 0x222
WM_MDIRESTORE = 0x223
WM_MDINEXT = 0x224
WM_MDIMAXIMIZE = 0x225
WM_MDITILE = 0x226
WM_MDICASCADE = 0x227
WM_MDIICONARRANGE = 0x228
WM_MDIGETACTIVE = 0x229
WM_MDISETMENU = 0x230
WM_ENTERSIZEMOVE = 0x231
WM_EXITSIZEMOVE = 0x232
WM_DROPFILES = 0x233
WM_MDIREFRESHMENU = 0x234

WM_IME_SETCONTEXT = 0x281
WM_IME_NOTIFY = 0x282
WM_IME_CONTROL = 0x283
WM_IME_COMPOSITIONFULL = 0x284
WM_IME_SELECT = 0x285
WM_IME_CHAR = 0x286
WM_IME_KEYDOWN = 0x290
WM_IME_KEYUP = 0x291

WM_MOUSEHOVER = 0x2A1
WM_NCMOUSELEAVE = 0x2A2
WM_MOUSELEAVE = 0x2A3

WM_CUT = 0x300
WM_COPY = 0x301
WM_PASTE = 0x302
WM_CLEAR = 0x303
WM_UNDO = 0x304

WM_RENDERFORMAT = 0x305
WM_RENDERALLFORMATS = 0x306
WM_DESTROYCLIPBOARD = 0x307
WM_DRAWCLIPBOARD = 0x308
WM_PAINTCLIPBOARD = 0x309
WM_VSCROLLCLIPBOARD = 0x30A
WM_SIZECLIPBOARD = 0x30B
WM_ASKCBFORMATNAME = 0x30C
WM_CHANGECBCHAIN = 0x30D
WM_HSCROLLCLIPBOARD = 0x30E
WM_QUERYNEWPALETTE = 0x30F
WM_PALETTEISCHANGING = 0x310
WM_PALETTECHANGED = 0x311

WM_HOTKEY = 0x312
WM_PRINT = 0x317
WM_PRINTCLIENT = 0x318

WM_HANDHELDFIRST = 0x358
WM_HANDHELDLAST = 0x35F
WM_PENWINFIRST = 0x380
WM_PENWINLAST = 0x38F
WM_COALESCE_FIRST = 0x390
WM_COALESCE_LAST = 0x39F
WM_DDE_FIRST = 0x3E0
WM_DDE_INITIATE = 0x3E0
WM_DDE_TERMINATE = 0x3E1
WM_DDE_ADVISE = 0x3E2
WM_DDE_UNADVISE = 0x3E3
WM_DDE_ACK = 0x3E4
WM_DDE_DATA = 0x3E5
WM_DDE_REQUEST = 0x3E6
WM_DDE_POKE = 0x3E7
WM_DDE_EXECUTE = 0x3E8
WM_DDE_LAST = 0x3E8

WM_USER = 0x400
WM_APP = 0x8000

GoSub, LoadLang
GoSub, KeyHold
GoSub, ToggleC
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField

;##### Menus: #####

Menu, FileMenu, Add, %Lang001%, New
Menu, FileMenu, Add, %Lang002%, Open
Menu, FileMenu, Add, %Lang003%, Save
Menu, FileMenu, Add, %Lang004%, SaveAs
Menu, FileMenu, Add, %Lang005%, Export
Menu, FileMenu, Add, %Lang006%, Preview
Menu, FileMenu, Add
Menu, FileMenu, Add, %Lang007%, Exit
Menu, InsertMenu, Add, %Lang016%, Mouse
Menu, InsertMenu, Add, %Lang017%, Text
Menu, InsertMenu, Add, %Lang018%, Special
Menu, InsertMenu, Add, %Lang019%, Pause
Menu, InsertMenu, Add, %Lang092%, Window
Menu, InsertMenu, Add, %Lang203% / %Lang204%, Image
Menu, InsertMenu, Add, %Lang020%, Run
Menu, InsertMenu, Add, %Lang021%, ComLoop
Menu, InsertMenu, Add, %Lang200%, IfSt
Menu, InsertMenu, Add, %Lang201%, SendMsg
Menu, EditMenu, Add, %Lang036%, EditButton
Menu, EditMenu, Add, %Lang141%, Duplicate
Menu, EditMenu, Add, %Lang146%, EditComm
Menu, EditMenu, Add, %Lang173%, FindReplace
Menu, EditMenu, Default, %Lang036%
Menu, EditMenu, Add
Menu, EditMenu, Add, %Lang035%, :InsertMenu
Menu, EditMenu, Add
Menu, EditMenu, Add, %Lang142%, MoveUp
Menu, EditMenu, Add, %Lang143%, MoveDn
Menu, EditMenu, Add
Menu, EditMenu, Add, %Lang144%, Remove
Menu, OptionsMenu, Add, %Lang008%, OptionsConfig
Menu, OptionsMenu, Add, %Lang153%, LoadDefaults
Menu, LangMenu, Add, English, LangEN
Menu, LangMenu, Add, Português, LangPT
Menu, HelpMenu, Add, %Lang009%, Help
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %Lang223%, Homepage
Menu, HelpMenu, Add, %Lang222%, HelpAHK
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %Lang010%, HelpAbout

Menu, MenuBar, Add, %Lang011%, :FileMenu
Menu, MenuBar, Add, %Lang035%, :InsertMenu
Menu, MenuBar, Add, %Lang036%, :EditMenu
Menu, MenuBar, Add, %Lang012%, :OptionsMenu
Menu, MenuBar, Add, %Lang013%, :LangMenu
Menu, MenuBar, Add, %Lang009%, :HelpMenu

Gui, Menu, MenuBar

Menu, Tray, Add, %Lang148%, Record
Menu, Tray, Add, %Lang007%, Exit
Menu, Tray, NoStandard
Menu, Tray, Default, %Lang148%

Menu, MouseB, Add, Click, MouseB
Menu, MouseB, Add, MouseClickDrag, MouseB
Menu, MouseB, Add, ControlClick, MouseB
Menu, MouseB, Icon, Click, shell32.dll, 24 
Menu, TextB, Add, Send / SendRaw, TextB
Menu, TextB, Add, ControlSend, TextB
Menu, TextB, Add, ControlSetText, TextB
Menu, TextB, Add, Clipboard, TextB
Menu, TextB, Icon, Send / SendRaw, shell32.dll, 24 
Menu, SpecialB, Add, List of Keys, SpecialB
Menu, SpecialB, Icon, List of Keys, shell32.dll, 24 
Menu, PauseB, Add, Sleep, PauseB
Menu, PauseB, Add, MsgBox, PauseB
Menu, PauseB, Add, KeyWait, PauseB
Menu, PauseB, Icon, Sleep, shell32.dll, 24 
Menu, WindowB, Add, WinActivate, WindowB
Menu, WindowB, Add, WinActivateBottom, WindowB
Menu, WindowB, Add, WinClose, WindowB
Menu, WindowB, Add, WinHide, WindowB
Menu, WindowB, Add, WinKill, WindowB
Menu, WindowB, Add, WinMaximize, WindowB
Menu, WindowB, Add, WinMinimize, WindowB
Menu, WindowB, Add, WinMinimizeAll / WinMinimizeAllUndo, WindowB
Menu, WindowB, Add, WinMove, WindowB
Menu, WindowB, Add, WinRestore, WindowB
Menu, WindowB, Add, WinSet, WindowB
Menu, WindowB, Add, WinShow, WindowB
Menu, WindowB, Add, WinWait, WindowB
Menu, WindowB, Add, WinWaitActive / WinWaitNotActive, WindowB
Menu, WindowB, Add, WinWaitClose, WindowB
Menu, WindowB, Icon, WinActivate, shell32.dll, 24 
Menu, ImageB, Add, ImageSearch, ImageB
Menu, ImageB, Add, PixelSearch, ImageB
Menu, ImageB, Icon, ImageSearch, shell32.dll, 24 
Menu, RunB, Add, Run / RunWait, RunB
Menu, RunB, Icon, Run / RunWait, shell32.dll, 24 
Menu, ComLoopB, Add, Loop, ComLoopB
Menu, ComLoopB, Icon, Loop, shell32.dll, 24 
Menu, IfStB, Add, IfWinActive / IfWinNotActive, IfStB
Menu, IfStB, Add, IfWinExist / IfWinNotExist, IfStB
Menu, IfStB, Add, IfExist / IfNotExist, IfStB
Menu, IfStB, Add, If Statements, IfStB
Menu, IfStB, Icon, IfWinActive / IfWinNotActive, shell32.dll, 24 
Menu, SendMsgB, Add, PostMessage / SendMessage, SendMsgB
Menu, SendMsgB, Add, Message List, SendMsgB
Menu, SendMsgB, Add, Microsoft MSDN, SendMsgB
Menu, SendMsgB, Icon, PostMessage / SendMessage, shell32.dll, 24 
Menu, ExportG, Add, List of Keys, ExportG
Menu, ExportG, Add, Auto-execute Section, ExportG
Menu, ExportG, Icon, List of Keys, shell32.dll, 24 

If Lang = Pt
	Menu, LangMenu, Check, Português
If Lang = En
	Menu, LangMenu, Check, English

;##### Main Window: #####

GuiA := 1
Gui, +Resize +MinSize310x100 +HwndWindowID
Gui, Add, Button, W25 H25 hwndNewB vNewB gNew
	ILButton(NewB, NewIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 ys xp+25 hwndOpenB vOpenB gOpen
	ILButton(OpenB, OpenIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 ys xp+25 hwndSaveB vSaveB gSave
	ILButton(SaveB, SaveIcon, 16, 16, 4)
Gui, Add, Text, W2 H25 ys+2 xp+34 0x11
Gui, Add, Button, W65 H25 ys xp+11 hwndExportB vExportB gExport, %Lang014%
	ILButton(ExportB, ExportIcon, 16, 16, 5)
Gui, Add, Button, W65 H25 yp xp+65 hwndPreviewB vPreviewB gPreview, %Lang015%
	ILButton(PreviewB, PreviewIcon, 16, 16, 5)
Gui, Add, Button, W65 H25 yp xp+65 hwndOptionsB vOptionsB gOptionsConfig, %Lang012%
	ILButton(OptionsB, OptionsIcon, 16, 16, 5)
Gui, Add, Button, W25 H25 yp+30 xm hwndMouseB vMouseB gMouse
	ILButton(MouseB, MouseIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 yp xp+25 hwndTextB vTextB gText
	ILButton(TextB, TextIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 yp xp+25 hwndSpecialB vSpecialB gSpecial
	ILButton(SpecialB, SpecialIcon, 16, 16, 4)
Gui, Add, Text, W2 H25 yp+2 xp+34 0x11
Gui, Add, Button, W25 H25 yp-2 xp+11 hwndPauseB vPauseB gPause
	ILButton(PauseB, PauseIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 yp xp+25 hwndWindowB vWindowB gWindow
	ILButton(WindowB, WindowIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 yp xp+25 hwndImageB vImageB gImage
	ILButton(ImageB, ImageIcon, 16, 16, 4)
Gui, Add, Button, W25 H25 yp xp+25 hwndRunB vRunB gRun
	ILButton(RunB, RunIcon, 16, 16, 4)
Gui, Add, Text, W2 H25 yp+2 xp+34 0x11
Gui, Add, Button, W25 H25 yp-2 xp+11 hwndComLoopB vComLoopB gComLoop
	ILButton(ComLoopB, LoopIcon, 16, 16, 4)
Gui, Font,, Courier New
Gui, Add, Button, W25 H25 yp xp+25 vIfStB gIfSt, If
Gui, Add, Button, W25 H25 yp xp+25 vSendMsgB gSendMsg, WM
Gui, Add, Text, W2 H55 yp-28 xp+34 0x11
Gui, Font
Gui, Font, Bold
Gui, Add, Button, W90 H40 ys xm+310 hwndRecordB vRecordB gRecord, %Lang148%
	ILButton(RecordB, RecordIcon, 32, 32, 5)
Gui, Add, Button, W90 H40 ys xm+405 hwndStartB vStartB gStart, %Lang025%
	ILButton(StartB, StartIcon, 32, 32, 5)
Gui, Font
Gui, Add, Checkbox, yp+45 xp-95 W100 gCapt vCapt, %Lang026%
Gui, Add, Checkbox, Checked yp xp+100 W85 vShowStep, %Lang134%
Gui, Add, GroupBox, Section W280 H65 ys-9 xs+500
Gui, Add, Text, ym+5 xs+10 vAutoT, %Lang022%:
Gui, Add, Text, y+13 vManT, %Lang023%:
Gui, Add, Hotkey, vAutoKey W185 ym+2 xp+35, %AutoKey%
Gui, Add, Hotkey, vManKey W70 y+5 Limit190, %ManKey%
Gui, Add, Checkbox, ym+5 xp+188 vWin1, Win
Gui, Add, Text, y+15 xp-105 vAbortT, %Lang024%:
Gui, Add, Hotkey,  yp-5 xp+32 vAbortKey W70, %AbortKey%
Gui, Add, Checkbox, yp+5 xp+73 vWin3, Win
; Gui, Add, Checkbox, y+15 vWin2, Win
Gui, Font, Regular
Gui, Add, ListView, Section xm AltSubmit vInputList gInputList W760 r28 NoSort, Index|Action|Details|Repeat|Delay|Type|Control|Window|Comment
If A_OSVersion in WIN_7,WIN_VISTA
{
	ImageListID := IL_Create(30)
	LV_SetImageList(ImageListID)
	Loop 30
		IL_Add(ImageListID, "DDORes.dll", A_Index)
}
If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
	ImageListID := IL_Create(40)
	LV_SetImageList(ImageListID)
	Loop 40
		IL_Add(ImageListID, "setupapi.dll", A_Index)
}
LV_ModifyCol(1, Col_1)	; Index
LV_ModifyCol(2, Col_2)	; Action
LV_ModifyCol(3, Col_3)	; Details
LV_ModifyCol(4, Col_4)	; Repeat
LV_ModifyCol(5, Col_5)	; Delay
LV_ModifyCol(6, Col_6)	; Type
LV_ModifyCol(7, Col_7)	; Control
LV_ModifyCol(8, Col_8)	; Window
LV_ModifyCol(9, Col_9)	; Comment
Gui, Add, UpDown, ys gOrder vOrder -16 Range0-1, 0
Gui, Font, Bold
Gui, Add, Button, hwndRemove vRemove gRemove
	ILButton(Remove, RemoveIcon, 16, 16, 4)
Gui, Font
Gui, Add, Text, xm W50 Section vRepeat, %Lang030%:
Gui, Add, Edit, ys xp+40 Limit Number W80 H20 vRept
Gui, Add, UpDown, vTimesG 0x80 Range1-999999, 1
Gui, Add, Button, ys xp+85 W40 vApplyT gApplyT, %Lang034%
Gui, Add, Text, W2 H20 yp xp+52 0x11 vSeparator1
Gui, Add, Text, xp+12 ys W60 vDelayT, %Lang031%:
Gui, Add, Edit, xp+60 Limit Number W60 H20 ys vDelay
Gui, Add, UpDown, vDelayG 0x80 Range0-999999, %DelayG%
Gui, Add, Button, xp+65 ys W40 vApplyI gApplyI, %Lang034%
Gui, Add, Text, W2 H20 yp xp+52 0x11 vSeparator2
Gui, Add, Hotkey, xp+12 ys W145 vsInput
Gui, Add, Button, ys xp+145 W40 vApplyL gApplyL, %Lang035%
Gui, Add, Text, W2 H20 yp xp+52 0x11 vSeparator3
Gui, Add, Button, ys xp+12 W40 vEditButton gEditButton, %Lang036%
Gui, Add, Text, W2 H20 yp xp+52 0x11 vSeparator4
Gui, Add, Text, xp+12 ys W120 vCoordTip, CoordMode: %CoordMouse%
GuiControl,, Win1, %Win1%
; GuiControl,, Win2, %Win2%
GuiControl,, Win3, %Win3%
GuiControl,, ShowStep, %ShowStep%
GuiControl, Focus, InputList
If WinState = 1
	Gui, Show, W800 H600 Maximize, %AppName% v%CurrentVersion%
Else
	Gui, Show, W800 H600, %AppName% v%CurrentVersion%
Gui, Submit, NoHide
GoSub, b_Start
GoSub, HKey
OnMessage(WM_MOUSEMOVE, "ShowTooltip")
OnMessage(WM_RBUTTONDOWN, "ShowContextHelp")
IniRead, Version, MacroCreator.ini, Application, Version
If ((Version = "ERROR") OR (Version <> CurrentVersion))
{
	GoSub, LoadDefaults
	Version := CurrentVersion
}

return

;##### Capture Keys #####

MainLoop:
Loop
{
	WinWaitActive, ahk_id %WindowID%
	Gui, Submit, NoHide
	If Capt = 0
		break
	ControlGetFocus, Focus, ahk_id %WindowID%
	If Focus = SysListView321
	{
		Input, sKey, M L1, %VirtualKeys%
		If sKey <> 
		{
			GoSub, ChReplace
			tKey = %sKey%
			sKey = {%sKey%}
			Gui, Submit, NoHide
			If Capt = 0
				break
			ControlGetFocus, Focus, ahk_id %WindowID%
			If Focus = SysListView321
				GoSub, InsertRow
		}
		Else
		{
			If ErrorLevel = NewInput
				continue
			Else
			tKey = %ErrorLevel%
			endKey = %ErrorLevel%
			StringTrimLeft, sKey, endKey, 7
			If InStr(sKey, "LControl")
			{
				If LControlHold = 0
				{
					KeyDown = LControl
					LControlHold = 1
				}
			}
			If InStr(sKey, "RControl")
			{
				If RControlHold = 0
				{
					KeyDown = RControl
					RControlHold = 1
				}
			}
			If InStr(sKey, "LShift")
			{
				If LShiftHold = 0
				{
					KeyDown = LShift
					LShiftHold = 1
				}
			}
			If InStr(sKey, "RShift")
			{
				If RShiftHold = 0
				{
					KeyDown = RShift
					RShiftHold = 1
				}
			}
			If InStr(sKey, "LAlt")
			{
				If LAltHold = 0
				{
					KeyDown = LAlt
					LAltHold = 1
				}
			}
			If InStr(sKey, "RAlt")
			{
				If RAltHold = 0
				{
					KeyDown = RAlt
					RAltHold = 1
				}
			}
			If sKey contains Win
			{
				KeyDown := sKey
				GoSub, WinKey
				Sleep, 50
			}
			GoSub, Replace
			GoSub, ReplaceHold
			sKey = {%sKey%}
			Gui, Submit, NoHide
			If Capt = 0
				break
			ControlGetFocus, Focus, ahk_id %WindowID%
			If Focus = SysListView321
				GoSub, InsertRow
		}
	}
	Else
	continue
}
return

;##################################################
; Author: tkoi <http://www.autohotkey.net/~tkoi>
; Original code from: l.autohotkey.net/forum/topic40468.html
; Addional thanks to just me for adapting it to AHK_L 64bit
;##################################################
ILButton(hBtn, images, cx=16, cy=16, align=4, margin="1,1,1,1") {
   static
   static i = 0
   local himl, v0, v1, v2, v3, ext, hbmp, hicon
   i ++

   himl := DllCall("ImageList_Create", "Int",cx, "Int",cy, "UInt",0x20, "Int",1, "Int",5, "UPtr")
   Loop, Parse, images, |
      {
      StringSplit, v, A_LoopField, :
      if not v1
         v1 := v3
      v3 := v1
      SplitPath, v1, , , ext
      if (ext = "bmp") {
         hbmp := DllCall("LoadImage", "UInt",0, "Str",v1, "UInt",0, "UInt",cx, "UInt",cy, "UInt",0x10, "UPtr")
         DllCall("ImageList_Add", "Ptr",himl, "Ptr",hbmp, "Ptr",0)
         DllCall("DeleteObject", "Ptr", hbmp)
         }
      else {
         DllCall("PrivateExtractIcons", "Str",v1, "Int",v2, "Int",cx, "Int",cy, "PtrP",hicon, "UInt",0, "UInt",1, "UInt",0)
         DllCall("ImageList_AddIcon", "Ptr",himl, "Ptr",hicon)
         DllCall("DestroyIcon", "Ptr", hicon)
         }
      }
   ; Create a BUTTON_IMAGELIST structure
   VarSetCapacity(struct%i%, A_PtrSize + (5 * 4) + (A_PtrSize - 4), 0)
   NumPut(himl, struct%i%, 0, "Ptr")
   Loop, Parse, margin, `,
      NumPut(A_LoopField, struct%i%, A_PtrSize + ((A_Index - 1) * 4), "Int")
   NumPut(align, struct%i%, A_PtrSize + (4 * 4), "UInt")
   ; BCM_FIRST := 0x1600, BCM_SETIMAGELIST := BCM_FIRST + 0x2
   PostMessage, 0x1602, 0, &struct%i%, , ahk_id %hBtn%
   Sleep 1 ; workaround for a redrawing problem on WinXP
   }
;##################################################

;##### Recording: #####

Record:
Tooltip
Gui, Submit, NoHide
Hotkey, %RecKey%, RecStart, on
Hotkey, %StopKey%, RecStop, on
If Win1 = 1
	AutoKey = #%AutoKey%
;If Win2 = 1
;	ManKey = #%ManKey%
If Win3 = 1
	AbortKey = #%AbortKey%
If AutoKey <>
	Hotkey, %AutoKey%, f_AutoKey, On
If ManKey <>
	Hotkey, %ManKey%, f_ManKey, On
If AbortKey <>
	Hotkey, %AbortKey%, f_AbortKey, On
Stop = 0
WinMinimize, ahk_id %WindowID%
Traytip, Pulover's Macro Creator, %RecKey% %Lang159%.`n%StopKey% %Lang160%.`n%AutoKey% %Lang158%.
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

RecStart:
Tooltip
If ShowStep = 1
	Traytip, Pulover's Macro Creator, %Lang161% %StopKey% %Lang160%.
Record = 1
SetTimer, WinCheck, 100
p_Title := ""
p_Class := ""
Hotkey, ~WheelUp, MWUp, on
Hotkey, ~WheelDown, MWDn, on
Up = 0
Dn = 0
CoordMode, Mouse, %CoordMouse%
MouseGetPos, xPos, yPos
LastPos := xPos "/" yPos
LastTime := A_TickCount
SetTimer, MouseRecord, 0
If ((WClass = 1) || (WTitle = 1))
	WinRec := WindowRecord()
If Strokes = 1
	Goto, KeyboardRecord
return

RecStop:
Record = 0
Input
Hotkey, ~WheelUp, MWUp, off
Hotkey, ~WheelDown, MWDn, off
SetTimer, MouseRecord, off
Traytip
return

KeyboardRecord:
Loop
{
	Gui, Submit, NoHide
	If Record = 0
		break
	Input, sKey, V M L1, %VirtualKeys%
	If sKey <> 
	{
		GoSub, ChReplace
		tKey = %sKey%
		sKey = {%sKey%}
		If Record = 0
			break
		GoSub, InsertRow
	}
	Else
	{
		If ErrorLevel = NewInput
			continue
		Else
		tKey = %ErrorLevel%
		endKey = %ErrorLevel%
		If InStr(endKey, "EndKey:")
			StringTrimLeft, sKey, endKey, 7
		If InStr(sKey, "LControl")
		{
			If LControlHold = 0
			{
				KeyDown = LControl
				LControlHold = 1
			}
		}
		If InStr(sKey, "RControl")
		{
			If RControlHold = 0
			{
				KeyDown = RControl
				RControlHold = 1
			}
		}
		If InStr(sKey, "LShift")
		{
			If LShiftHold = 0
			{
				KeyDown = LShift
				LShiftHold = 1
			}
		}
		If InStr(sKey, "RShift")
		{
			If RShiftHold = 0
			{
				KeyDown = RShift
				RShiftHold = 1
			}
		}
		If InStr(sKey, "LAlt")
		{
			If LAltHold = 0
			{
				KeyDown = LAlt
				LAltHold = 1
			}
		}
		If InStr(sKey, "RAlt")
		{
			If RAltHold = 0
			{
				KeyDown = RAlt
				RAltHold = 1
			}
		}
		If sKey contains Win
		{
			KeyDown := sKey
			GoSub, WinKey
			Sleep, 50
		}
		GoSub, Replace
		GoSub, ReplaceHold
		sKey = {%sKey%}
		If Record = 0
			break
		GoSub, InsertRow
	}
}
return

InsertRow:
Type = %Type1%
Target := ""
Window := ""
If Record = 1
{
	If RecKeybdCtrl = 1
	{
		If ((InStr(sKey, "Control")) || (InStr(sKey, "Shift")) || (InStr(sKey, "Alt")))
			Goto, KeyInsert
		ControlGetFocus, ActiveCtrl, A
		If ActiveCtrl <>
		{
			Type = %Type2%
			Target = %ActiveCtrl%
			WinGetTitle, c_Title, A
			WinGetClass, c_Class, A
			If WTitle = 1
				Window = %c_Title%
			If WClass = 1
				Window = %Window% ahk_class %c_Class%
			If ((WTitle = 0) && (WClass = 0))
				Window = A
		}
	}
}
KeyInsert:
If Record = 1
{
	If TimedI = 1
	{
		If (Interval := TimeRecord())
		{
			If Interval > %TDelay%
			GoSub, SleepInput
		}
		InputDelay = 0
		WinDelay = 0
	}
	Else
	{
		InputDelay = %DelayG%
		WinDelay = %DelayW%
	}
	If ((WClass = 1) || (WTitle = 1))
		WinRec := WindowRecord()
}
Else
{
	InputDelay = %DelayG%
}
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, tKey, sKey, 1, InputDelay, Type, Target, Window)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, tKey, sKey, 1, DelayG, Type, Target, Window)
		GoSub, b_Start
		LV_Modify(RowNumber, "Vis")
	}
}
LV_MoveRow(0)
GoSub, RowCheck
return

MouseRecord:
CoordMode, Mouse, %CoordMouse%
MouseGetPos, xPos, yPos, id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
WinGet, pname, ProcessName, ahk_id %id%
ControlGetPos, x, y,, , %control%, A
xcpos := Controlpos(xPos, x)
ycpos := Controlpos(yPos, y)
If Moves = 1
{
	If (MouseMove := MoveCheck())
	{
		Action = %Action2%
		Details = %MouseMove%, 0
		Type = %Type3%
		GoSub, MouseAdd
	}
}
If !GetKeyState(RelKey, Toggle)
{
	RelHold = 0
	Relative = 
}
If MScroll = 1
{
	If Up > 0
	{
		If A_TimeIdle > 50
		{
			If RecMouseCtrl = 1
				Details := ClickOn(xPos, yPos, "WheelUp", Up)
			Else
				Details = WheelUp, %Up%
			Action = %Action5%
			Type = %Type3%
			GoSub, MouseInput
			Up = 0
		}
	}
	If Dn > 0
	{
		If A_TimeIdle > 50
		{
			If RecMouseCtrl = 1
				Details := ClickOn(xPos, yPos, "WheelDown", Dn)
			Else
				Details = WheelDown, %Dn%
			Action = %Action6%
			Type = %Type3%
			GoSub, MouseInput
			Dn = 0
		}
	}
}
return
#If ((Record = 1) && (Mouse = 1) && (ClickDn = 0))
*LButton::
{
	Send, {Blind}{LButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Left
	KeyWait, LButton
	{
		Send, {Blind}{LButton Up}
		MouseGetPos, xPos, yPos
		fb_Pos = %xPos%, %yPos%
		If (ib_Pos <> fb_Pos)
		{
			Details := DragEvent(ib_Pos, fb_Pos, Button)
			Action = %Button% %Action4%
			Type = %Type13%
			GoSub, MouseInput
		}
		Else
		{
			KeyWait, LButton, D, T0.2
			Send, {Blind}{LButton Down}
			If ErrorLevel = 0
				Click = 2
			Else
				Click = 1
			Details := ClickOn(xPos, yPos, Button, Click)
			Details .= ","
			Action = %Button% %Action3%
			Type = %Type3%
			GoSub, MouseInput
			KeyWait, LButton
			Send, {Blind}{LButton Up}
		}
	}
}
return
*RButton::
{
	Send, {Blind}{RButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Right
	KeyWait, RButton
	{
		Send, {Blind}{RButton Up}
		MouseGetPos, xPos, yPos
		fb_Pos = %xPos%, %yPos%
		If (ib_Pos <> fb_Pos)
		{
			Details := DragEvent(ib_Pos, fb_Pos, Button)
			Action = %Button% %Action4%
			Type = %Type13%
			GoSub, MouseInput
		}
		Else
		{
			KeyWait, RButton, D, T0.2
			Send, {Blind}{RButton Down}
			If ErrorLevel = 0
				Click = 2
			Else
				Click = 1
			Details := ClickOn(xPos, yPos, Button, Click)
			Details .= ","
			Action = %Button% %Action3%
			Type = %Type3%
			GoSub, MouseInput
			KeyWait, RButton
			Send, {Blind}{RButton Up}
		}
	}
}
return
*MButton::
{
	Send, {Blind}{MButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Middle
	KeyWait, MButton
	{
		Send, {Blind}{MButton Up}
		MouseGetPos, xPos, yPos
		fb_Pos = %xPos%, %yPos%
		If (ib_Pos <> fb_Pos)
		{
			Details := DragEvent(ib_Pos, fb_Pos, Button)
			Action = %Button% %Action4%
			Type = %Type13%
			GoSub, MouseInput
		}
		Else
		{
			KeyWait, MButton, D, T0.2
			Send, {Blind}{MButton Down}
			If ErrorLevel = 0
				Click = 2
			Else
				Click = 1
			Details := ClickOn(xPos, yPos, Button, Click)
			Details .= ","
			Action = %Button% %Action3%
			Type = %Type3%
			GoSub, MouseInput
			KeyWait, MButton
			Send, {Blind}{MButton Up}
		}
	}
}
return
*XButton1::
{
	Send, {Blind}{XButton1 Down}
	ib_Pos = %xPos%, %yPos%
	Button = X1
	KeyWait, XButton1
	{
		Send, {Blind}{XButton1 Up}
		MouseGetPos, xPos, yPos
		fb_Pos = %xPos%, %yPos%
		If (ib_Pos <> fb_Pos)
		{
			Details := DragEvent(ib_Pos, fb_Pos, Button)
			Action = %Button% %Action4%
			Type = %Type13%
			GoSub, MouseInput
		}
		Else
		{
			KeyWait, XButton1, D, T0.2
			Send, {Blind}{XButton1 Down}
			If ErrorLevel = 0
				Click = 2
			Else
				Click = 1
			Details := ClickOn(xPos, yPos, Button, Click)
			Details .= ","
			Action = %Button% %Action3%
			Type = %Type3%
			GoSub, MouseInput
			KeyWait, XButton1
			Send, {Blind}{XButton1 Up}
		}
	}
}
return
*XButton2::
{
	Send, {Blind}{XButton2 Down}
	ib_Pos = %xPos%, %yPos%
	Button = X2
	KeyWait, XButton2
	{
		Send, {Blind}{XButton2 Up}
		MouseGetPos, xPos, yPos
		fb_Pos = %xPos%, %yPos%
		If (ib_Pos <> fb_Pos)
		{
			Details := DragEvent(ib_Pos, fb_Pos, Button)
			Action = %Button% %Action4%
			Type = %Type13%
			GoSub, MouseInput
		}
		Else
		{
			KeyWait, XButton2, D, T0.2
			Send, {Blind}{XButton2 Down}
			If ErrorLevel = 0
				Click = 2
			Else
				Click = 1
			Details := ClickOn(xPos, yPos, Button, Click)
			Details .= ","
			Action = %Button% %Action3%
			Type = %Type3%
			GoSub, MouseInput
			KeyWait, XButton2
			Send, {Blind}{XButton2 Up}
		}
	}
}
return

#If ((Record = 1) && (Mouse = 1) && (ClickDn = 1))
*LButton::
{
	Send, {Blind}{LButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Left
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Down"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
~*LButton Up::
{
	Send, {Blind}{LButton Up}
	ib_Pos = %xPos%, %yPos%
	Button = Left
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Up"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*RButton::
{
	Send, {Blind}{RButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Right
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Down"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*RButton Up::
{
	Send, {Blind}{RButton Up}
	ib_Pos = %xPos%, %yPos%
	Button = Right
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Up"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*MButton::
{
	Send, {Blind}{MButton Down}
	ib_Pos = %xPos%, %yPos%
	Button = Middle
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Down"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*MButton Up::
{
	Send, {Blind}{MButton Up}
	ib_Pos = %xPos%, %yPos%
	Button = Middle
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Up"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*XButton1::
{
	Send, {Blind}{XButton1 Down}
	ib_Pos = %xPos%, %yPos%
	Button = X1
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Down"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*XButton1 Up::
{
	Send, {Blind}{XButton1 Up}
	ib_Pos = %xPos%, %yPos%
	Button = X1
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Up"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*XButton2::
{
	Send, {Blind}{XButton2 Down}
	ib_Pos = %xPos%, %yPos%
	Button = X2
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Down"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
*XButton2 Up::
{
	Send, {Blind}{XButton2 Up}
	ib_Pos = %xPos%, %yPos%
	Button = X2
	Details := ClickOn(xPos, yPos, Button, "")
	Details .= ", Up"
	Action = %Button% %Action3%
	Type = %Type3%
	GoSub, MouseInput
}
return
#If

MWUp:
Up++
return

MWDn:
Dn++
return

ClickOn(xPos, yPos, Button, Click="1")
{
	global RelHold, LastPos, RelKey, Toggle
	If RelHold = 1
	{
		Loop, Parse, LastPos, /
			iPar%A_Index% := A_LoopField
		Relative := RelToLastPos(iPar1, iPar2, xPos, yPos)
	}
	LastPos := xPos "/" yPos
	If GetKeyState(RelKey, Toggle)
	{
		xPos = Rel 0
		yPos = 0
		RelHold = 1
	}
	If Relative <> 
		Details = %Relative% %Button%, %Click%
	Else
		Details = %xPos%, %yPos% %Button%, %Click%
	return Details
}

DragEvent(Ini,End,Button)
{
	global RelKey, Toggle
	If GetKeyState(RelKey, Toggle)
	{
		DragOn := RelDragOn(Ini, End)
		Loop, Parse, DragOn, /
			Rel%A_Index% := A_LoopField
	Ini = %Rel1%
		End = %Rel2%
	}
	DetailsI = %Ini%, %Button% Down
	DetailsE = %End%, %Button% Up
	return "`{Click`, " DetailsI "`}`{Click`, " DetailsE "`}"
}

RelDragOn(Ini,End)
{
	StringReplace, Ini, Ini, %A_Space%
	StringReplace, End, End, %A_Space%
	Loop, Parse, Ini, `,
		iPar%A_Index% := A_LoopField
	Loop, Parse, End, `,
	{
		fPar%A_Index% := A_LoopField
	}
	Ini = Rel 0, 0
	End := RelToLastPos(iPar1, iPar2, fPar1, fPar2)
	return Ini "/" End
}

RelToLastPos(lX, lY, cX, cY)
{
	cX -= lX
	cY -= lY
	return "Rel " cX "`, " cY
}

MoveCheck()
{
	global MDelay, LastPos, RelKey, Toggle, CoordMouse
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPos, yPos
	If (LastPos = xPos "/" yPos)
		return
	If A_TimeIdle < %MDelay%
		return
	If GetKeyState(RelKey, Toggle)
	{
		Loop, Parse, LastPos, /
			iPar%A_Index% := A_LoopField
		MovedPos := RelToLastPos(iPar1, iPar2, xPos, yPos)
	}
	Else
		MovedPos := xPos ", " yPos
	LastPos := xPos "/" yPos
	return MovedPos
}

TimeRecord()
{
	global LastTime
	static TimeCount
	TimeCount := A_TickCount - LastTime
	LastTime := A_TickCount
	return TimeCount
}

MouseInput:
Target := ""
Window := ""
If RecMouseCtrl = 1
{
	If ((InStr(Details, "rel")) || (InStr(Details, "click")))
		Goto, MouseAdd
	If control <>
	{
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		StringReplace, Details, Details, %Par1%
		StringReplace, Details, Details, %Par2%
		Details = %Details% x%xcpos% y%ycpos% NA
		Action = %Button% %Action1%
		Type = %Type4%
		Target = %control%
		WinGetTitle, c_Title, A
		WinGetClass, c_Class, A
		If WTitle = 1
			Window = %c_Title%
		If WClass = 1
			Window = %Window% ahk_class %c_Class%
		If ((WTitle = 0) && (WClass = 0))
			Window = A
	}
}
MouseAdd:
If TimedI = 1
{
	If (Interval := TimeRecord())
	{
		If Interval > %TDelay%
		GoSub, SleepInput
	}
	RecDelay = 0
	WinDelay = 0
}
Else
{
	RecDelay = %DelayM%
	WinDelay = %DelayW%
}
LV_Add("", ListCount+1, Action, Details, 1, RecDelay, Type, Target, Window)
If (!InStr(Details, "Down") && (Action <> Action2))
{
	If ((WClass = 1) || (WTitle = 1))
		WinRec := WindowRecord()
}
GoSub, b_Start
LV_Modify(ListCount, "Vis")
LV_MoveRow(0)
GoSub, RowCheck
return

SleepInput:
LV_Add("", ListCount+1, "[Pause]", "", 1, Interval, Type5)
return

WindowRecord()
{
	global p_Title, p_Class, ListCount, WTitle, WClass, WinDelay
	WinGetTitle, c_Title, A
	WinGetClass, c_Class, A
	If WTitle = 1
	{
		Window = %c_Title%
		If WClass = 1
			Window = %Window% ahk_class %c_Class%
	}
	Else
	{
		If WClass = 1
			Window = ahk_class %c_Class%
	}
	If c_Class = %p_Class%
	{
		If WTitle = 0
			return
		Else
		{
			If c_Title = %p_Title%
				return
			Else
				LV_Add("", ListCount+1, "WinActivate", "", 1, WinDelay, "WinActivate", "", Window)
		}
	}
	Else
		LV_Add("", ListCount+1, "WinActivate", "", 1, 0, "WinActivate", "", Window)
	p_Class = %c_Class%
	p_Title = %c_Title%
}

KeyHold:
LControlHold := 0
RControlHold := 0
LAltHold := 0
RAltHold := 0
LShiftHold := 0
RShiftHold := 0
LWinHold := 0
RWinHold := 0
return

;##### Subroutines: Menus & Buttons #####

New:
Gui +OwnDialogs
If ListCount <> 0
{
	MsgBox, 3, %Lang003%, %Lang037%`n"%CurrentFileName%" ;"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
LV_Delete()
GoSub, b_Start
GoSub, KeyHold
GuiControl,, Capt, 0
If AutoKey <>
	Hotkey, %AutoKey%, f_AutoKey, Off
If ManKey <>
	Hotkey, %ManKey%, f_ManKey, Off
If AbortKey <>
	Hotkey, %AbortKey%, f_AbortKey, Off
CurrentFileName = 
Gui, Show,, %AppName% v%CurrentVersion%
GuiControl, Focus, InputList
return

GuiDropFiles:
Loop, Parse, A_GuiEvent, `n
{
    SelectedFileName := A_LoopField
    break
}
GoSub, FileRead
return

Open:
Gui +OwnDialogs
If ListCount <> 0
{
	MsgBox, 3, %Lang003%, %Lang037%`n"%CurrentFileName%" ;"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
FileSelectFile, SelectedFileName, 3, %A_ScriptDir%, %Lang038%, %Lang039% (*.pmc)
If SelectedFileName = 
	return
GoSub FileRead
return

FileRead:
CSV_Load(SelectedFileName, Delimiter)
CSV_LVLoad(1,, , 0, 0,, 0, 0)
GoSub, KeyHold
GoSub, b_Start
GuiControl,, Capt, 0
If AutoKey <>
	Hotkey, %AutoKey%, f_AutoKey, Off
If ManKey <>
	Hotkey, %ManKey%, f_ManKey, Off
If AbortKey <>
	Hotkey, %AbortKey%, f_AbortKey, Off
CurrentFileName = %SelectedFileName%
Gui, Show,, %AppName% v%CurrentVersion% %CurrentFileName% 
LV_MoveRow(0)
GoSub, RowCheck
GuiControl, Focus, InputList
return

Save:
Input
If CurrentFileName = 
	Goto SaveAs
GoSub, SaveCurrentList
return

SaveAs:
Input
Gui 1:+OwnDialogs
FileSelectFile, SelectedFileName, S16, %A_ScriptDir%, %Lang040%, %Lang039% (*.pmc)
If SelectedFileName = 
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "pmc")
	SelectedFileName = %SelectedFileName%.pmc
CurrentFileName = %SelectedFileName%
GoSub SaveCurrentList
return

SaveCurrentList:
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    If ErrorLevel
    {
        MsgBox %Lang041% "%CurrentFileName%".
        return
    }
}
CSV_LVSave(CurrentFileName, Delimiter, 0, 1)
Gui, Show,, %AppName% v%CurrentVersion% %CurrentFileName%
return

;##################################################
; Author: trueski <trueski@gmail.com>
; Original code from: l.autohotkey.net/forum/topic42843.html
;##################################################
CSV_Load(FileName, Delimiter="|")
  {
   Local Row
   Local Col
   
   Loop, Read, %FileName%
     {
      Row := A_Index
      Loop, Parse, A_LoopReadLine, %Delimiter%
        {
         Col := A_Index
         CSV_Row%Row%_Col%Col% := A_LoopField
        }
     }
       CSV_TotalRows := Row
      CSV_TotalCols := Col
      CSV_Delimiter := Delimiter
      SplitPath, FileName, CSV_FileName, CSV_Path
      
      IfNotInString, FileName, `\
        {
         CSV_FileName := FileName
         CSV_Path := A_ScriptDir
     }
     
      CSV_FileNamePath = %CSV_Path%\%CSV_FileName%
    }
;##################################################
CSV_TotalRows()
  { 
    global   
   Return %CSV_TotalRows%
  }
;##################################################
CSV_TotalCols()
  { 
    global   
   Return %CSV_TotalCols%
  }
;##################################################
CSV_Delimiter()
  { 
    global   
   Return %CSV_Delimiter%
  }
;##################################################
CSV_FileName()
  { 
    global   
   Return %CSV_FileName%
  }
;##################################################
CSV_Path()
  { 
    global   
   Return %CSV_Path%
  }
;##################################################
CSV_FileNamePath()
  { 
    global   
   Return %CSV_FileNamePath%
  }
;##################################################
CSV_LVLoad(Gui=1, x=10, y=10, w="", h="", header="", Sort=0, AutoAdjustCol=1)
  {
   Local Row
	CSV_LVAlreadyCreated = 1
    If CSV_LVAlreadyCreated =
      {
       Gui, %Gui%:Add, ListView, vListView%Gui% x%x% y%y% w%w% h%h%, %header%
      CSV_LVAlreadyCreated = 1
       }
   
   ;Set GUI window, clear any existing data
   Gui, %Gui%:Default
    GuiControl, -Redraw, InputList
    Sleep, 200
   LV_Delete()
   
   ;Add Data
   Loop, %CSV_TotalRows%
     LV_Add("", "")
   
   Loop, %CSV_TotalRows%
     {
      Row := A_Index
      Loop, %CSV_TotalCols%
           LV_Modify(Row, "Col" A_Index, CSV_Row%Row%_Col%A_Index%)
     }

   
   ;Display Data
   If Sort <> 0
     LV_ModifyCol(Sort, "Sort")
      
      
     If AutoAdjustCol = 1
     LV_ModifyCol()
     GuiControl, +Redraw, InputList
  }
;##################################################
CSV_LVSave(FileName, Delimiter="|",OverWrite=1, Gui=1)
  {
   Gui, %Gui%:Default
   Rows := LV_GetCount()
   Cols := LV_GetCount("Col")
   
   IfExist, %FileName%
     If OverWrite = 0
       Return 0
   
   FileDelete, %FileName%
   
   Loop, %Rows%
     {
        FullRow =
        Row := A_Index
        
        Loop, %Cols%
          {
             LV_GetText(CellData, Row, A_Index)
           FullRow .= CellData
           
           If A_Index <> %Cols%
             FullRow .= Delimiter
          }
      
         If Row <> %Rows%
           FullRow .= "`n"
           
         EntireFile .= FullRow
      }
    FileAppend, %EntireFile%, %FileName%
  }
;##################################################

Export:
Input
Gui, Submit, NoHide
SplitPath, CurrentFileName, name, dir, ext, name_no_ext, drive
If Win1 = 1
	AutoKey = #%AutoKey%
;If Win2 = 1
;	ManKey = #%ManKey%
If Win3 = 1
	AbortKey = #%AbortKey%
Gui, 14:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 14:Add, GroupBox, W360 H70, %Lang042%:
Gui, 14:Add, CheckBox, Checked Section ys+20 xs+10 vEx_AutoKey, Hotkey:
Gui, 14:Add, Edit, ys-3 xp+90 W100 vAutoKey, %AutoKey%
Gui, 14:Add, CheckBox, ys xp+110 vEx_Hotstring gEx_Hotstring, %Lang043%
Gui, 14:Add, CheckBox, Section xs vEx_AbortKey, Abort Hotkey:
Gui, 14:Add, Edit, ys-3 xp+90 W100 vAbortKey, %AbortKey%
Gui, 14:Add, Text, ys xp+110, %Lang012%:
Gui, 14:Add, Edit, ys-3 xp+45 W95 vEx_HSOpt Disabled, %Ex_HSOpt%
Gui, 14:Add, GroupBox, Section xm W360 H80, %Lang224%:
Gui, 14:Add, Checkbox, Section ys+20 xs+10 vEx_IfDir gEx_IfDir
Gui, 14:Add, DropdownList, yp-4 xs+30 W105 vEx_IfDirType, #IfWinActive||#IfWinNotActive|#IfWinExist|#IfNotWinExist
Gui, 14:Add, DropdownList, yp xs+275 W65 vIdent Disabled, Title||Class|Process|ID
Gui, 14:Add, Edit, xs+2 W280 vTitle Disabled
Gui, 14:Add, Button, yp-1 xp+280 W60 H22 vGetWin gGetWin Disabled, %Lang076%
Gui, 14:Add, GroupBox, Section xm W360 H155, %Lang012%:
Gui, 14:Add, CheckBox, Section Checked ys+20 xs+10 vEx_SM, SendMode
Gui, 14:Add, DropdownList, yp-3 xp+115 vSM w75, Input||Play|Event|InputThenPlay|
Gui, 14:Add, CheckBox, Section Checked xs vEx_SI, #SingleInstance
Gui, 14:Add, DropdownList, yp-3 xp+115 vSI w75, Force|Ignore||Off|
Gui, 14:Add, CheckBox, Checked xs vEx_ST, SetTitleMatchMode
Gui, 14:Add, DropdownList, yp-3 xp+115 vST w75, 1|2||3|RegEx|
Gui, 14:Add, CheckBox, Checked xs vEx_DH, DetectHiddenWindows
Gui, 14:Add, CheckBox, Checked xs vEx_AF, #WinActivateForce
Gui, 14:Add, CheckBox, xs vEx_IN, #Include
Gui, 14:Add, Edit, yp-3 xp+70 W120 H20 vIN -Multi
Gui, 14:Add, CheckBox, ys-27 xs+210 vEx_SK, SetKeyDelay
Gui, 14:Add, Edit, yp-3 xp+100 W30 vSK
Gui, 14:Add, CheckBox, yp+25 xs+210 vEx_MD, SetMouseDelay
Gui, 14:Add, Edit, yp-3 xp+100 W30 vMD
Gui, 14:Add, CheckBox, yp+25 xs+210 vEx_SC, SetControlDelay
Gui, 14:Add, Edit, yp-3 xp+100 W30 vSC
Gui, 14:Add, CheckBox, yp+25 xs+210 vEx_SW, SetWinDelay
Gui, 14:Add, Edit, yp-3 xp+100 W30 vSW
Gui, 14:Add, CheckBox, yp+25 xs+210 vEx_SB, SetBatchLines
Gui, 14:Add, Edit, yp-3 xp+100 W30 vSB
Gui, 14:Add, CheckBox, yp+25 xs+210 vEx_NT, #NoTrayIcon
Gui, 14:Add, GroupBox, Section xm W360 H50
Gui, 14:Add, Text, Section ys+20 xs+10, %Lang044%:
Gui, 14:Add, Edit, yp-3 xp+40 Limit Number W100 H20 vEx_TE
Gui, 14:Add, UpDown, 0x80 Range1-999999 vEx_TG, %TimesG%
Gui, 14:Add, Checkbox, yp+3 xs+150 W60 vEx_SQ gEx_SQ, %Lang196%
Gui, 14:Add, Checkbox, yp xs+245 W100 vEx_BM, %Lang217%
Gui, 14:Add, GroupBox, Section xm W360 H65
Gui, 14:Add, Text, Section ys+15 xs+10, %Lang045%:
Gui, 14:Add, Edit, vExpFile W295 H20 -Multi, %A_ScriptDir%\%name_no_ext%.ahk
Gui, 14:Add, Button, yp-1 xp+295 gExpSearch, %Lang046%
Gui, 14:Add, Button, Section Default xm W60 H22 gExpButton, %Lang014%
Gui, 14:Add, Button, ys W60 H22 gAppend, %Lang181%
Gui, 14:Add, Button, ys W60 H22 gExpClose, %Lang047%
GuiControl, 14:, Ex_AutoKey, %Ex_AutoKey%
GuiControl, 14:, Ex_AbortKey, %Ex_AbortKey%
GuiControl, 14:, Ex_Hotstring, %Ex_Hotstring%
GuiControl, 14:, Ex_HSOpt, %Ex_HSOpt%
GuiControl, 14:, Ex_SM, %Ex_SM%
GuiControl, 14:ChooseString, SM, %SM%
GuiControl, 14:, Ex_SI, %Ex_SI%
GuiControl, 14:ChooseString, SI, %SI%
GuiControl, 14:, Ex_ST, %Ex_ST%
GuiControl, 14:ChooseString, ST, %ST%
GuiControl, 14:, Ex_DH, %Ex_DH%
GuiControl, 14:, Ex_AF, %Ex_AF%
GuiControl, 14:, Ex_IN, %Ex_IN%
GuiControl, 14:ChooseString, IN, %IN%
GuiControl, 14:, Ex_NT, %Ex_NT%
GuiControl, 14:, Ex_SC, %Ex_SC%
GuiControl, 14:, SC, %SC%
GuiControl, 14:, Ex_SW, %Ex_SW%
GuiControl, 14:, SW, %SW%
GuiControl, 14:, Ex_SK, %Ex_SK%
GuiControl, 14:, SK, %SK%
GuiControl, 14:, Ex_MD, %Ex_MD%
GuiControl, 14:, MD, %MD%
GuiControl, 14:, Ex_SB, %Ex_SB%
GuiControl, 14:, SB, %SB%
GuiControl, 14:, Ex_SQ, %Ex_SQ%
GuiControl, 14:, Ex_BM, %Ex_BM%
If Ex_Hotstring = 1
	GuiControl, 14:Enable, Ex_HSOpt
GoSub, Ex_SQ
If CurrentFileName = 
	GuiControl, 14:, ExpFile, %A_ScriptDir%\MyScript.ahk
Gui, 14:Show,, %Lang005%
GoSub, DelKey
return

Ex_Hotstring:
Gui, Submit, NoHide
GuiControl, 14:Enable%Ex_Hotstring%, Ex_HSOpt
return

Ex_IfDir:
Gui, Submit, NoHide
GuiControl, 14:Enable%Ex_IfDir%, Ident
GuiControl, 14:Enable%Ex_IfDir%, Title
GuiControl, 14:Enable%Ex_IfDir%, GetWin
return

Ex_SQ:
Gui +OwnDialogs
Gui, Submit, NoHide
If Ex_SQ = 1
{
	If AutoKey contains ^,!,+,#
	{
		MsgBox, 16, %Lang197%, %Lang198%
		GuiControl,, Ex_SQ, 0
		return
	}
}
GuiControl, 14:Disable%Ex_SQ%, Ex_TG
GuiControl, 14:Disable%Ex_SQ%, Ex_TE
return

ExpButton:
Gui +OwnDialogs
Gui, Submit, NoHide
If Ex_AutoKey = 1
{
	If AutoKey = 
	{
		MsgBox, 16, %Lang048%, %Lang049%
		return
	}
}
If Ex_AbortKey = 1
{
	If AbortKey = 
	{
		MsgBox, 16, %Lang048%, %Lang049%
		return
	}
}
If Ex_SQ = 1
{
	If AutoKey contains ^,!,+,#
	{
		MsgBox, 16, %Lang197%, %Lang198%
		return
	}
}
If ExpFile = 
	return
SelectedFileName = %ExpFile%
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName = %SelectedFileName%.ahk
If drive = 
{
	MsgBox, 16, %Lang050%, %Lang051%
	return
}
If Append = 1
	return
GoSub, ExportFile
return

ExpClose:
Gui, Submit, NoHide
14GuiClose:
14GuiEscape:
Gui, 1:-Disabled
Gui, 14:Destroy
return

ExpSearch:
FileSelectFile, SelectedFileName, S16, %A_ScriptDir%, %Lang053%, AutoHotkey Scripts (*.ahk)
If SelectedFileName = 
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName = %SelectedFileName%.ahk
GuiControl,, ExpFile, %SelectedFileName%
return

ExportFile:
Header := Script_Header()
Body := LV_Export()
If Ex_SQ = 0
{
	If Ex_TG > 1
		Body := "Loop, " Ex_TG "`n{`n" Body "`n}"
}
If Ex_BM = 1
	Body := "BlockInput, MouseMove`n" Body "`nBlockInput, MouseMoveOff"
If Ex_AutoKey = 1
{
	Body := AutoKey "::`n" Body "`nreturn`n"
	If Ex_Hotstring = 1
	{
		If Ex_HSOpt <>
			Body := ":" Ex_HSOpt ":" Body
		Else
			Body := "::" Body
	}
}
If Ex_AbortKey = 1
	Body .= "`n" AbortKey "::`nExitApp`nreturn`n"
If Ex_IfDir = 1
	Body := Ex_IfDirType ", " Title "`n" Body Ex_IfDirType "`n"
Script := Header Body
ChoosenFileName = %SelectedFileName%
GoSub, SaveAHK
return

SaveAHK:
IfExist %ChoosenFileName%
{
    FileDelete %ChoosenFileName%
    If ErrorLevel
    {
        MsgBox, 16, %Lang213%, %Lang041% "%ChoosenFileName%".
        return
    }
}
FileAppend, %Script%, %ChoosenFileName%
If ErrorLevel
{
	MsgBox, 16, %Lang213%, %Lang041% "%ChoosenFileName%".
	return
}
MsgBox, 0, %Lang054%, %Lang055%
return

Append:
Gui, Submit, NoHide
Append = 1
If Ex_SQ = 1
{
	If AutoKey contains ^,!,+,#
	{
		MsgBox, 16, %Lang197%, %Lang198%
		Append = 0
		return
	}
}
GoSub, ExpButton
IfNotExist %SelectedFileName%
{
	MsgBox, 16, %Lang050%, %Lang182%
	Append = 0
	return
}
FileRead, TargetFile, %SelectedFileName%
If InStr(TargetFile, AutoKey)
{
	MsgBox, 16, %Lang184%, %Lang186%
	Append = 0
	return
}
Body := LV_Export()
If Ex_SQ = 0
{
	If Ex_TG > 1
		Body := "Loop, " Ex_TG "`n{`n" Body "`n}"
}
If Ex_BM = 1
	Body := "BlockInput, MouseMove`n" Body "`nBlockInput, MouseMoveOff"
If Ex_AutoKey = 1
{
	Body := AutoKey "::`n" Body "`nreturn`n"
	If Ex_Hotstring = 1
	{
		If Ex_HSOpt <>
			Body := "`n:" Ex_HSOpt ":" Body
		Else
			Body := "`n::" Body
	}
	Else
		Body := "`n" Body
}
If Ex_IfDir = 1
	Body := "`n" Ex_IfDirType ", " Title Body Ex_IfDirType "`n"
FileAppend, %Body%, %SelectedFileName%
MsgBox, 0, %Lang054%, %Lang055%
Append = 0
return

Preview:
Input
Gui 13:+LastFoundExist
IfWinExist
    GoSub, PrevClose
Preview := LV_Export()
Gui, 13:+Resize
Gui, 13:Add, Button, Section W60 H22 gPrevClose, %Lang047%
Gui, 13:Add, Button, ys W60 H22 gPrevRefresh, %Lang093%
Gui, 13:Add, Checkbox, ys+5 vAutoRefresh, %Lang056%
Gui, 13:Add, Checkbox, ys+5 xp+150 vOnTop gOnTop, %Lang124%
Gui, 13:Font,, Courier New
Gui, 13:Add, Edit, Section xm vLVPrev W400 R35 -Wrap HScroll ReadOnly
Gui, 13:Font
GuiControl, 13:, LVPrev, %Preview%
Gui, 13:Show,, %Lang057%
GoSub, DelKey
WinGet, PrevID, ID, A
return

OnTop:
Gui, Submit, NoHide
If OnTop = 1
	Gui, 13:+AlwaysOnTop
If OnTop = 0
	Gui, 13:-AlwaysOnTop
return

PrevRefresh:
Preview := LV_Export()
GuiControl, 13:, LVPrev, %Preview%
PostMessage, 0x115, 7, , Edit1, ahk_id %PrevID%
return

PrevClose:
13GuiClose:
13GuiEscape:
Gui, 13:Destroy
AutoRefresh = 0
return

;##### ExportAHK #####

LV_Export()
{
	global
	local Action, Step, TimesX, DelayX, Type, Target, Window, Comment, PAction, PType, PDelayX, PComment
	Gui, 1:Default
	RowData := ""
	LVData := ""
	Loop, %ListCount%
	{
		LV_GetText(Action, A_Index, 2)
		LV_GetText(Step, A_Index, 3)
		LV_GetText(TimesX, A_Index, 4)
		LV_GetText(DelayX, A_Index, 5)
		LV_GetText(Type, A_Index, 6)
		LV_GetText(Target, A_Index, 7)
		LV_GetText(Window, A_Index, 8)
		LV_GetText(Comment, A_Index, 9)
		LV_GetText(PAction, A_Index-1, 2)
		LV_GetText(PType, A_Index-1, 6)
		LV_GetText(PDelayX, A_Index-1, 5)
		LV_GetText(PComment, A_Index-1, 9)
		If Type = %Type1%
		{
			If InStr(Step, "``n")
			{
				StringReplace, Step, Step, ``n, `n, All
				Step := "`n(`n" Step "`n)"
			}
			If ((TimesX > 1) && (Action <> "[Text]"))
				GoSub, ScriptReplace
			If DelayX = 0
			{
				If ((Type = PType) && (PDelayX = 0) && (PComment = "") && (Action <> "[Text]") && (PAction <> "[Text]") && (Ex_SQ = 0))
					RowData := Step
				Else
					RowData := "`n" Type ", " Step
			}
			Else
				RowData := "`n" Type ", " Step
			If Comment <>
				RowData .= "  " "; " Comment
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If ((Action = "[Text]") && (TimesX > 1))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If ((Type = Type2) || (Type = Type9) || (Type = Type10))
		{
			If InStr(Step, "``n")
			{
				StringReplace, Step, Step, ``n, `n, All
				Step := "`n(`n" Step "`n)`n"
			}
			RowData := "`n" Type ", " Target ", " Step ", " Window
			If Comment <>
				RowData .= "  " "; " Comment
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If Type = %Type4%
		{
			RowData := "`n" Type ", " Target ", " Window ",, " Step
			If Comment <>
				RowData .= "  " "; " Comment
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If ((Type = Type3) || (Type = Type8) || (Type = Type11) || (Type = Type13) || (Type = Type14))
		{
			If InStr(Step, "``n")
			{
				StringReplace, Step, Step, ``n, `n, All
				Step := "`n(`n" Step "`n)"
			}
			RowData := "`n" Type ", " Step
			If Comment <>
				RowData .= "  " "; " Comment
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If Type = %Type5%
		{
			RowData := "`n" Type ", " DelayX
			If Comment <>
				RowData .= "  " "; " Comment
		}
		If Type = %Type6%
		{
			RowData := "`n" Type ", 49,, " Step "`nIfMsgBox, Cancel`nreturn"
			If Comment <>
				RowData .= "  " "; " Comment
		}
		If Type = %Type7%
		{
			If Step = LoopStart
				RowData := "`n" Type ", " TimesX
			If Comment <>
				RowData .= "  " "; " Comment
			RowData .= "`n{"
			If Step = LoopEnd
				RowData := "`n}"
		}
		If Type = %Type12%
		{
			If InStr(Step, "``n")
			{
				StringReplace, Step, Step, ``n, `n, All
				Step := "`n(`n" Step "`n)"
			}
			RowData := "`nSavedClip := ClipboardAll`nClipboard =`nClipboard = " Step "`nSleep, 333"
			If Target <>
				RowData .= "`nControlSend, " Target ", ^v, " Window
			Else
				RowData .= "`nSend, ^v"
			If Comment <>
				RowData .= "  " "; " Comment
			RowData .= "`nClipboard := SavedClip`nSavedClip ="
		}
		If ((Type = Type15) || (Type = Type16))
		{
			RowData := "`nCoordMode, Pixel, " Window
			RowData .= "`n" Type ", FoundX, FoundY, " Step
			If Comment <>
				RowData .= "  " "; " Comment
			StringReplace, Action, Action, `,%A_Space%, `,, All
			Loop, Parse, Action, `,
				Act%A_Index% := A_LoopField
			If (Act1 <> "Continue")
			{
				RowData .= "`nIf ErrorLevel = 0"
				If (Act1 = "Stop")
					RowData .= "`nReturn"
				If (Act1 = "Move")
					RowData .= "`nClick, %FoundX%, %FoundY%, 0"
				If InStr(Act1, "Click")
				{
					Loop, Parse, Act1, %A_Space%
						Action%A_Index% := A_LoopField
					RowData .= "`nClick, %FoundX%, %FoundY% " Action1 ", 1"
				}
				If (Act1 = "Prompt")
					RowData .= "`n{`nMsgBox, 49, " Lang209 ", " Lang210 "%FoundX%x%FoundY%.``n" Lang212 "`nIfMsgBox, Cancel`nreturn`n}"
			}
			If (Act2 <> "Continue")
			{
				RowData .= "`nIf ErrorLevel"
				If (Act2 = "Stop")
					RowData .= "`nReturn"
				If (Act2 = "Prompt")
					RowData .= "`n{`nMsgBox, 49, " Lang209 ", " Lang211 "``n" Lang212 "`nIfMsgBox, Cancel`nreturn`n}"
			}
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If Type = %Type17%
		{
			If Step = Else
			{
				RowData := "`n}`nElse"
				If Comment <>
					RowData .= "  " "; " Comment
				RowData .= "`n{"
			}
			Else
			If Step = EndIf
				RowData := "`n}"
			Else
			{
				GoSub, IfStReplace
				RowData := "`n" Action Step
				If Comment <>
					RowData .= "  " "; " Comment
				RowData .= "`n{"
			}
		}
		If ((Type = Type18) || (Type = Type19))
		{
			Loop, Parse, Step, `,
				Par%A_Index% := A_LoopField
			StringReplace, Step, Step, %Par1%, % %Par1%
			RowData := "`n" Type ", " Step ", " Target ", " Window
			If Comment <>
				RowData .= "  " "; " Comment
			If DelayX > 0
				RowData .= "`n" "Sleep, " DelayX
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If Type = %Type20%
		{
			RowData := "`n" Type ", " Step
			RowData .= "`n" Type ", " Step ", D"
			If DelayX > 0
				RowData .= " T" round(DelayX/1000, 1) "`nIf ErrorLevel`nreturn"
			If Comment <>
				RowData .= "  " "; " Comment
			If TimesX > 1
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If InStr(Type, "Win")
		{
			If Type = WinMove
			{
				RowData := "`n" Type ", " Window "," ", " Step
				If Comment <>
					RowData .= "  " "; " Comment
				If DelayX > 0
					RowData .= "`n" "Sleep, " DelayX
				If TimesX > 1
					RowData := "`nLoop, " TimesX "`n{`n" RowData "}"
			}
			Else
			If Type = WinSet
			{
				RowData := "`n" Type ", " Step ", " Window
				If Comment <>
					RowData .= "  " "; " Comment
				If DelayX > 0
					RowData .= "`n" "Sleep, " DelayX
				If TimesX > 1
					RowData := "`nLoop, " TimesX "`n{`n" RowData "}"
			}
			Else
			{
				RowData := "`n" Type ", " Window
				If Comment <>
					RowData .= "  " "; " Comment
				If DelayX > 0
					RowData .= "`nSleep, " DelayX
				If TimesX > 1
					RowData := "`nLoop, " TimesX "`n{`n" RowData "}"
			}
		}
		LVData .= RowData
		If Ex_SQ = 1
			If A_Index < %ListCount%	
			{
				LVData .= "`nKeyWait, " AutoKey "`nKeyWait, " AutoKey ", D"
			}
	}
	StringReplace, LVData, LVData, `n
	StringReplace, LVData, LVData, `n`n, `n
	return %LVData%
	
	ScriptReplace:
	StringReplace, Step, Step, {Shift Down}, |SD|
	StringReplace, Step, Step, {Shift Up}, |SU|
	StringReplace, Step, Step, {Control Down}, |CD|
	StringReplace, Step, Step, {Control Up}, |CD|
	StringReplace, Step, Step, {Alt Down}, |AD|
	StringReplace, Step, Step, {Alt Up}, |UD|
	StringReplace, Step, Step, `}, %A_Space%%TimesX%}
	StringReplace, Step, Step, |SD|, {Shift Down}
	StringReplace, Step, Step, |SU|, {Shift Up}
	StringReplace, Step, Step, |CD|, {Control Down}
	StringReplace, Step, Step, |CD|, {Control Up}
	StringReplace, Step, Step, |AD|, {Alt Down}
	StringReplace, Step, Step, |UD|, {Alt Up}
	return
	
	IfStReplace:
	StringReplace, Action, Action, %If1%, IfWinActive`,%A_Space%
	StringReplace, Action, Action, %If2%, IfWinNotActive`,%A_Space%
	StringReplace, Action, Action, %If3%, IfWinExist`,%A_Space%
	StringReplace, Action, Action, %If4%, IfWinNotExist`,%A_Space%
	StringReplace, Action, Action, %If5%, IfExist`,%A_Space%
	StringReplace, Action, Action, %If6%, IfNotExist`,%A_Space%
	StringReplace, Action, Action, %If7%, If Clipboard =%A_Space%
	StringReplace, Action, Action, %If8%, If A_Index =%A_Space%
	StringReplace, Action, Action, %If9%, If ErrorLevel = 0
	StringReplace, Action, Action, %If10%, If ErrorLevel
	return
}

Script_Header()
{
	global
	Header := HeadLine "`n`n#NoEnv`n#InstallKeybdHook`nSetWorkingDir %A_ScriptDir%`nCoordMode, Mouse, " CoordMouse
	If Ex_SM = 1
		Header .= "`nSendMode " SM
	If Ex_SI = 1
		Header .= "`n#SingleInstance " SI
	If Ex_ST = 1
		Header .= "`nSetTitleMatchMode, " ST
	If Ex_DH = 1
		Header .= "`nDetectHiddenWindows, on"
	If Ex_AF = 1
		Header .= "`n#WinActivateForce"
	If Ex_NT = 1
		Header .= "`n#NoTrayIcon"
	If Ex_SC = 1
		Header .= "`nSetControlDelay, " SC
	If Ex_SW = 1
		Header .= "`nSetWinDelay, " SW
	If Ex_SK = 1
		Header .= "`nSetKeyDelay, " SK
	If Ex_MD = 1
		Header .= "`nSetMouseDelay, " MD
	If Ex_SB = 1
		Header .= "`nSetBatchLines, " SB
	If Ex_IN = 1
		Header .= "`n#" "Include " IN
	Header .= "`n`n"
	return %Header%
}

OptionsConfig:
GuiA := 4
Gui, 4:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 4:Add, Tab2, W350 H430, %Lang162%|%Lang058%
Gui, 4:Add, GroupBox, W320 H205, %Lang164%:
Gui, 4:Add, Text, ys+50 xs+162, %Lang156%:
Gui, 4:Add, DropdownList, yp-2 xp+85 W75 vRecKey, F1|F2|F3|F4|F5|F6|F7|F8||F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, Text, yp+28 xs+162, %Lang157%:
Gui, 4:Add, DropdownList, yp-2 xp+85 W75 vStopKey, F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock||
Gui, 4:Add, CheckBox, ys+50 xs+22 vStrokes, %Lang149%
Gui, 4:Add, CheckBox, vMouse, %Lang150%
Gui, 4:Add, CheckBox, vMScroll, %Lang163%
Gui, 4:Add, CheckBox, vMoves gMoves, %Lang151%
Gui, 4:Add, Text, yp+20 xs+22, %Lang152%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+85 W60 H20 vMDelayT
Gui, 4:Add, UpDown, yp xp+60 vMDelay 0x80 Range0-999999, %MDelay%
Gui, 4:Add, CheckBox, yp-18 xp+70 vTimedI gTimedI, %Lang170%
Gui, 4:Add, Text, yp+20 xp, %Lang152%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+85 W60 H20 vTDelayT
Gui, 4:Add, UpDown, yp xp+60 vTDelay 0x80 Range0-999999, %TDelay%
Gui, 4:Add, CheckBox, yp+25 xs+22 vClickDn, %Lang171%
Gui, 4:Add, CheckBox, vWClass, %Lang167%
Gui, 4:Add, CheckBox, vWTitle, %Lang168%
Gui, 4:Add, CheckBox, yp-19 xp+155 vRecMouseCtrl, %Lang180%
Gui, 4:Add, CheckBox, vRecKeybdCtrl, %Lang179%
Gui, 4:Add, Text, yp+22 xs+22, %Lang169%:
Gui, 4:Add, Hotkey, vRelKey W90 yp-5 xp+150, %RelKey%
Gui, 4:Add, CheckBox, yp+4 xp+100 vToggleC gToggleC, %Lang172%
Gui, 4:Add, GroupBox, Section xs+12 ys+240 W320 H80, %Lang189%:
Gui, 4:Add, Text, yp+20 xp+10, %Lang190%:
Gui, 4:Add, DropdownList, yp-2 xp+70 W75 vFast, Insert||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DropdownList, yp xp+85 W35 vSpeedUp, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, Text, yp+25 xs+10, %Lang191%:
Gui, 4:Add, DropdownList, yp-2 xp+70 W75 vSlow, Pause||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DropdownList, yp xp+85 W35 vSpeedDn, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, Checkbox, Checked yp-40 xp+15 W95 vMouseReturn, %Lang208%
;Gui, 4:Add, Text, yp xp+15 W80
Gui, 4:Add, GroupBox, Section xs ys+85 W320 H90, %Lang008%:
Gui, 4:Add, Text, yp+20 xs+10, %Lang193%:
Gui, 4:Add, Radio, yp xp+150 W55 vRelative, %Lang194%
Gui, 4:Add, Radio, yp xp+85 W55 vScreen, %Lang195%
Gui, 4:Add, Text, yp+20 xs+10, %Lang165%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+150 W60 H20
Gui, 4:Add, UpDown, yp xp+60 vDelayM 0x80 Range0-999999, %DelayM%
Gui, 4:Add, Text, yp+25 xp-150, %Lang166%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+150 W60 H20
Gui, 4:Add, UpDown, yp xp+60 vDelayW 0x80 Range0-999999, %DelayW%
Gui, 4:Tab, 2
Gui, 4:Add, Text,, %Lang058%:
Gui, 4:Add, Edit, Section W320 H340 vEditMod, %VirtualKeys%
Gui, 4:Add, Button, W60 H22 gConfigRestore, %Lang061%
Gui, 4:Add, Button, yp xp+70 W60 H22 gConfigDetect, %Lang062%
Gui, 4:Tab
Gui, 4:Add, Button, Default Section xm W60 H22 gConfigOK, %Lang059%
Gui, 4:Add, Button, ys W60 H22 gConfigCancel, %Lang060%
GuiControl, 4:ChooseString, RecKey, %RecKey%
GuiControl, 4:ChooseString, StopKey, %StopKey%
GuiControl, 4:, Strokes, %Strokes%
GuiControl, 4:, Mouse, %Mouse%
GuiControl, 4:, Moves, %Moves%
GuiControl, 4:, MScroll, %MScroll%
GuiControl, 4:, MDelay, %MDelay%
GuiControl, 4:, DelayM, %DelayM%
GuiControl, 4:, DelayW, %DelayW%
GuiControl, 4:, TimedI, %TimedI%
GuiControl, 4:, TDelay, %TDelay%
GuiControl, 4:, WClass, %WClass%
GuiControl, 4:, WTitle, %WTitle%
GuiControl, 4:, RelKey, %RelKey%
GuiControl, 4:, ClickDn, %ClickDn%
GuiControl, 4:, ToggleC, %ToggleC%
GuiControl, 4:, RecMouseCtrl, %RecMouseCtrl%
GuiControl, 4:, RecKeybdCtrl, %RecKeybdCtrl%
GuiControl, 4:, RecKeybdCtrl, %RecKeybdCtrl%
GuiControl, 4:, MouseReturn, %MouseReturn%
GuiControl, 4:ChooseString, Fast, %Fast%
GuiControl, 4:ChooseString, Slow, %Slow%
GuiControl, 4:ChooseString, SpeedUp, %SpeedUp%
GuiControl, 4:ChooseString, SpeedDn, %SpeedDn%
If CoordMouse = Window
	GuiControl, 4:, Relative, 1
If CoordMouse = Screen
	GuiControl, 4:, Screen, 1
GoSub, Moves
GoSub, TimedI
Gui, 4:Show,, %Lang008%
GoSub, DelKey
OldMods = %VirtualKeys%
return

ConfigOK:
Gui, Submit, NoHide
If Relative = 1
	CoordMouse = Window
If Screen = 1
	CoordMouse = Screen
VirtualKeys = %EditMod%
GuiA := 1
Gui, 1:-Disabled
Gui, 4:Destroy
Gui, 1:Default
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
return

ConfigCancel:
4GuiClose:
4GuiEscape:
VirtualKeys = %OldMods%
Gui, 1:-Disabled
Gui, 4:Destroy
return

ConfigRestore:
GoSub, DefaultMod
GuiControl,, EditMod, %VirtualKeys%
return

ConfigDetect:
Gui, Submit, NoHide
VirtualKeys = %EditMod%
Gui, 9:+owner1 +ToolWindow
Gui, 4:Default
Gui +Disabled
Gui, 9:Add, Text, , %Lang063%:
Gui, 9:Add, Edit, Section xm W60 vKeyName 0x201 ReadOnly
Gui, 9:Add, Text, ys+2 xp+72, VK:
Gui, 9:Add, Edit, ys xp+20 W50 vVKey 0x201 ReadOnly
Gui, 9:Add, Text, ys+2 xp+60, SC:
Gui, 9:Add, Edit, ys xp+20 W50 vSCode 0x201 ReadOnly
Gui, 9:Add, Text, Section xm W200 vStMsg
Gui, 9:Add, Button, Section Default xm W60 H22 gDetAdd, %Lang064%
Gui, 9:Add, Button, ys W60 H22 gDetCancel, %Lang060%
Gui, 9:Show,, %Lang065%
GoSub, DelKey
Loop 9
	OnMessage(255+A_Index, "ScanCode")
return

DetAdd:
Gui +OwnDialogs
Gui, Submit, NoHide
If SCode = 
{
	GuiControl,, StMsg, %Lang066%
	return
}
Else
	VirtualKeys = %VirtualKeys%{%VKey%%SCode%}
Gui, 4:-Disabled
Gui, 9:Destroy
Gui, 4:Default
GuiControl,, EditMod, %VirtualKeys%
return

DetCancel:
9GuiClose:
9GuiEscape:
GuiA := 1
Gui, 4:-Disabled
Gui, 9:Destroy
return

Moves:
Gui, Submit, NoHide
GuiControl, 4:Enable%Moves%, MDelayT
return

TimedI:
Gui, Submit, NoHide
GuiControl, 4:Enable%TimedI%, TDelayT
return

ToggleC:
Gui, Submit, NoHide
If ToggleC = 1
	Toggle := "T"
If ToggleC = 0
	Toggle := "P"
return

LoadDefaults:
Gui +OwnDialogs
MsgBox, 49, %Lang153%, %Lang154%
IfMsgBox, OK
{
	IfExist, MacroCreator.ini
		FileDelete MacroCreator.ini
	GoSub, LoadSettings
	GoSub, WriteSettings
}
IfMsgBox, Cancel
	return
return

ShowTooltip()
{
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
		ToolTip
		SetTimer, DisplayToolTip, 500
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
	SetTimer, DisplayToolTip, Off
	ToolTip % %CurrControl%_TT
	SetTimer, RemoveToolTip, 3000
	return
}

ShowContextHelp()
{
	MouseGetPos,,,, Control
	If InStr(Control, "Edit")
		return
	If A_Gui in 3,5,7,8,10,11,12,14,19,21,22
	{
		Menu, % Help%A_Gui%, Show
		return
	}
	Else
	If A_GuiControl not in MouseB,TextB,SpecialB,PauseB,WindowB,ImageB,RunB,ComLoopB,IfStB,SendMsgB
		return
	Menu, %A_GuiControl%, Show
}

;##### Context Help: #####

MouseB:
If A_ThisMenuItem = Click
	Run, http://l.autohotkey.net/docs/commands/Click.htm
If A_ThisMenuItem = MouseClickDrag
	Run, http://l.autohotkey.net/docs/commands/MouseClickDrag.htm
If A_ThisMenuItem = ControlClick
	Run,  http://l.autohotkey.net/docs/commands/ControlClick.htm
return

TextB:
If A_ThisMenuItem = Send / SendRaw
	Run, http://l.autohotkey.net/docs/commands/Send.htm
If A_ThisMenuItem = ControlSend
	Run, http://l.autohotkey.net/docs/commands/ControlSend.htm
If A_ThisMenuItem = ControlSetText
	Run, http://l.autohotkey.net/docs/commands/ControlSetText.htm
If A_ThisMenuItem = Clipboard
	Run, http://l.autohotkey.net/docs/misc/Clipboard.htm
return

ExportG:
SpecialB:
If A_ThisMenuItem = List of Keys
	Run, http://l.autohotkey.net/docs/KeyList.htm
If A_ThisMenuItem = Auto-execute Section
	Run, http://l.autohotkey.net/docs/Scripts.htm#auto
return

PauseB:
If A_ThisMenuItem = Sleep
	Run, http://l.autohotkey.net/docs/commands/Sleep.htm
If A_ThisMenuItem = MsgBox
	Run, http://l.autohotkey.net/docs/commands/MsgBox.htm
If A_ThisMenuItem = KeyWait
	Run, http://l.autohotkey.net/docs/commands/KeyWait.htm
return

WindowB:
If A_ThisMenuItem = WinActivate
	Run, http://l.autohotkey.net/docs/commands/WinActivate.htm
If A_ThisMenuItem = WinActivateBottom
	Run, http://l.autohotkey.net/docs/commands/WinActivateBottom.htm
If A_ThisMenuItem = WinClose
	Run, http://l.autohotkey.net/docs/commands/WinClose.htm
If A_ThisMenuItem = WinHide
	Run, http://l.autohotkey.net/docs/commands/WinHide.htm
If A_ThisMenuItem = WinKill
	Run, http://l.autohotkey.net/docs/commands/WinKill.htm
If A_ThisMenuItem = WinMaximize
	Run, http://l.autohotkey.net/docs/commands/WinMaximize.htm
If A_ThisMenuItem = WinMinimize
	Run, http://l.autohotkey.net/docs/commands/WinMinimize.htm
If A_ThisMenuItem = WinMinimizeAll / WinMinimizeAllUndo
	Run, http://l.autohotkey.net/docs/commands/WinMinimizeAll.htm
If A_ThisMenuItem = WinMove
	Run, http://l.autohotkey.net/docs/commands/WinMove.htm
If A_ThisMenuItem = WinRestore
	Run, http://l.autohotkey.net/docs/commands/WinRestore.htm
If A_ThisMenuItem = WinSet
	Run, http://l.autohotkey.net/docs/commands/WinSet.htm
If A_ThisMenuItem = WinShow
	Run, http://l.autohotkey.net/docs/commands/WinShow.htm
If A_ThisMenuItem = WinWait
	Run, http://l.autohotkey.net/docs/commands/WinWait.htm
If A_ThisMenuItem = WinWaitActive / WinWaitNotActive
	Run, http://l.autohotkey.net/docs/commands/WinWaitActive.htm
If A_ThisMenuItem = WinWaitClose
	Run, http://l.autohotkey.net/docs/commands/WinWaitClose.htm
return

ImageB:
If A_ThisMenuItem = ImageSearch
	Run, http://l.autohotkey.net/docs/commands/ImageSearch.htm
If A_ThisMenuItem = PixelSearch
	Run, http://l.autohotkey.net/docs/commands/PixelSearch.htm
return

RunB:
Run, http://l.autohotkey.net/docs/commands/Run.htm
return

ComLoopB:
Run, http://l.autohotkey.net/docs/commands/Loop.htm
return

IfStB:
If A_ThisMenuItem = IfWinActive / IfWinNotActive
	Run, http://l.autohotkey.net/docs/commands/IfWinActive.htm
If A_ThisMenuItem = IfWinExist / IfWinNotExist
	Run, http://l.autohotkey.net/docs/commands/IfWinExist.htm
If A_ThisMenuItem = IfExist / IfNotExist
	Run, http://l.autohotkey.net/docs/commands/IfExist.htm
If A_ThisMenuItem = If Statements
	Run, http://l.autohotkey.net/docs/commands/IfEqual.htm
return

SendMsgB:
If A_ThisMenuItem = PostMessage / SendMessage
	Run, http://l.autohotkey.net/docs/commands/PostMessage.htm
If A_ThisMenuItem = Message List
	Run, http://l.autohotkey.net/docs/misc/SendMessageList.htm
If A_ThisMenuItem = Microsoft MSDN
	Run, http://msdn.microsoft.com
return

;##### Change Language: #####

LangPT:
If Lang = Pt
	return
Menu, LangMenu, Check, Português
Menu, LangMenu, Uncheck, English
Lang = Pt
GoSub, LangChange
return

LangEN:
If Lang = En
	return
Menu, LangMenu, Check, English
Menu, LangMenu, Uncheck, Português
Lang = En
GoSub, LangChange
return

LangChange:
MenuText =
(
%Lang011%
%Lang035%
%Lang036%
%Lang012%
%Lang013%
%Lang009%
%Lang001%
%Lang002%
%Lang003%
%Lang004%
%Lang005%
%Lang006%
%Lang007%
%Lang016%
%Lang017%
%Lang018%
%Lang019%
%Lang092%
%Lang203% / %Lang204%
%Lang020%
%Lang021%
%Lang200%
%Lang201%
%Lang036%
%Lang141%
%Lang146%
%Lang173%
%Lang142%
%Lang143%
%Lang144%
%Lang008%
%Lang153%
%Lang009%
%Lang010%
%Lang148%
%Lang222%
%Lang223%
)
StringSplit, MenuText, MenuText, `n
GoSub, LoadLang
GuiControl,, ExportB, %Lang014%
GuiControl,, PreviewB, %Lang015%
GuiControl,, OptionsB, %Lang012%
GuiControl,, AutoT, %Lang022%
GuiControl,, ManT, %Lang023%
GuiControl,, AbortT, %Lang024%
GuiControl,, RecordB, %Lang148%
GuiControl,, StartB, %Lang025%
GuiControl,, Capt, %Lang026%
GuiControl,, ShowStep, %Lang134%
GuiControl,, Repeat, %Lang030%
GuiControl,, ApplyT, %Lang034%
GuiControl,, DelayT, %Lang031%
GuiControl,, ApplyI, %Lang034%
GuiControl,, ApplyL, %Lang035%
GuiControl,, EditButton, %Lang036%
Menu, MenuBar, Rename, %MenuText1%, %Lang011%
Menu, MenuBar, Rename, %MenuText2%, %Lang035%
Menu, MenuBar, Rename, %MenuText3%, %Lang036%
Menu, MenuBar, Rename, %MenuText4%, %Lang012%
Menu, MenuBar, Rename, %MenuText5%, %Lang013%
Menu, MenuBar, Rename, %MenuText6%, %Lang009%
Menu, FileMenu, Rename, %MenuText7%, %Lang001%
Menu, FileMenu, Rename, %MenuText8%, %Lang002%
Menu, FileMenu, Rename, %MenuText9%, %Lang003%
Menu, FileMenu, Rename, %MenuText10%, %Lang004%
Menu, FileMenu, Rename, %MenuText11%, %Lang005%
Menu, FileMenu, Rename, %MenuText12%, %Lang006%
Menu, FileMenu, Rename, %MenuText13%, %Lang007%
;Menu, InsertMenu, Rename, %MenuText14%, %Lang016%
Menu, InsertMenu, Rename, %MenuText15%, %Lang017%
Menu, InsertMenu, Rename, %MenuText16%, %Lang018%
Menu, InsertMenu, Rename, %MenuText17%, %Lang019%
Menu, InsertMenu, Rename, %MenuText18%, %Lang092%
Menu, InsertMenu, Rename, %MenuText19%, %Lang203% / %Lang204%
Menu, InsertMenu, Rename, %MenuText20%, %Lang020%
;Menu, InsertMenu, Rename, %MenuText21%, %Lang021%
Menu, InsertMenu, Rename, %MenuText22%, %Lang200%
Menu, InsertMenu, Rename, %MenuText23%, %Lang201%
Menu, EditMenu, Rename, %MenuText24%, %Lang036%
Menu, EditMenu, Rename, %MenuText25%, %Lang141%
Menu, EditMenu, Rename, %MenuText26%, %Lang146%
Menu, EditMenu, Rename, %MenuText27%, %Lang173%
Menu, EditMenu, Rename, %MenuText28%, %Lang142%
Menu, EditMenu, Rename, %MenuText29%, %Lang143%
Menu, EditMenu, Rename, %MenuText30%, %Lang144%
Menu, OptionsMenu, Rename, %MenuText31%, %Lang008%
Menu, OptionsMenu, Rename, %MenuText32%, %Lang153%
Menu, HelpMenu, Rename, %MenuText33%, %Lang009%
Menu, HelpMenu, Rename, %MenuText34%, %Lang010%
Menu, HelpMenu, Rename, %MenuText36%, %Lang222%
Menu, HelpMenu, Rename, %MenuText37%, %Lang223%
Menu, Tray, Rename, %MenuText35%, %Lang148%
Menu, Tray, Rename, %MenuText13%, %Lang007%
Gui 13:+LastFoundExist
IfWinExist
    GoSub, Preview
Gui 15:+LastFoundExist
IfWinExist
    GoSub, Help
Gui 18:+LastFoundExist
IfWinExist
    GoSub, FindReplace
return

Help:
Input
Gui 15:+LastFoundExist
IfWinExist
    GoSub, HelpClose
Gui, 15:Add, Button, Section W60 H22 gHelpClose, %Lang047%
Gui, 15:Add, Edit, Section xm vHelpText WantTab W600 R22 ReadOnly, %HelpHead%`n`n%HelpTx%
Gui, 15:Show,, %Lang009%
GoSub, DelKey
return

HelpClose:
15GuiClose:
15GuiEscape:
Gui, 15:Destroy
return

Homepage:
Run, http://www.autohotkey.net/~Pulover
return

HelpAHK:
Run, http://l.autohotkey.net/docs
return

HelpAbout:
Gui +OwnDialogs
MsgBox, 0, %Lang010%,
(
PULOVER'S MACRO CREATOR
An Interface-Based Automation Tool & Script Writer.

Author: Rodolfo U. Batista
Version: %CurrentVersion%
Release Date: June, 2012
AutoHotkey Version: AHK_L 1.1.07.03

rodolfoub@gmail.com

GNU General Public License 3.0 or higher
http://www.gnu.org/licenses/gpl-3.0.txt

Thanks to:
jaco0646 for the function to make hotkey command detect other keys.
diabagger and Obi-Wahn for the function to move rows.
trueski for the CSV functions.
SKAN for the function to detect ScanCodes.
tkoi for the ILButton function for Graphic Buttons.
corrupt for the original Graphic Buttons function.
just me for updating the ILButton function to work on AHK_L 64bit.
)
return

EditMouse:
Caller = Edit
Mouse:
Gui, 5:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 5:Add, GroupBox, W250 H80, %Lang068%:
Gui, 5:Add, Radio, ys+20 xs+10 Checked gClick vClick, %Lang069%
Gui, 5:Add, Radio, gPoint vPoint, %Lang070%
Gui, 5:Add, Radio, gPClick vPClick, %Lang071%
Gui, 5:Add, Radio, ys+20 xp+120 gWUp vWUp, %Lang073%
Gui, 5:Add, Radio, gWDn vWDn, %Lang074%
Gui, 5:Add, Radio, gDrag vDrag, %Lang072%
Gui, 5:Add, GroupBox, Section xm W250 H100, %Lang075%:
Gui, 5:Add, Text, Section ys+25 xs+10, X:
Gui, 5:Add, Edit, ys-3 xp+15 vIniX Limit W35 Disabled
Gui, 5:Add, Text, ys xp+40, Y:
Gui, 5:Add, Edit, ys-3 xp+15 vIniY Limit W35 Disabled
Gui, 5:Add, Button, ys-5 xp+40 W60 H22 vMouseGetI gMouseGetI Disabled, %Lang076%
Gui, 5:Add, Text, Section xs, X:
Gui, 5:Add, Edit, ys-3 xp+15 vEndX Limit W35 Disabled
Gui, 5:Add, Text, ys xp+40, Y:
Gui, 5:Add, Edit, ys-3 xp+15 vEndY Limit W35 Disabled
Gui, 5:Add, Button, ys-4 xp+40 W60 H22 vMouseGetE gMouseGetE Disabled, %Lang076%
Gui, 5:Add, Radio, Checked Section yp+30 xm+10 vCL gCL, %Lang138%
Gui, 5:Add, Radio, yp xp+70 vSE gSE, %Lang137%
Gui, 5:Add, Checkbox, yp xp+70 vMRel gMRel Disabled, %Lang077%
Gui, 5:Add, GroupBox, Section xm W250 H90, %Lang078%:
Gui, 5:Add, Radio, Section ys+20 xs+10 Checked vLB, %Lang079%
Gui, 5:Add, Radio, yp xp+70 vRB, %Lang080%
Gui, 5:Add, Radio, yp xp+70 vMB, %Lang081%
Gui, 5:Add, Radio, ys+20 xs vX1, %Lang082%
Gui, 5:Add, Radio, yp xp+70 vX2, %Lang083%
Gui, 5:Add, Checkbox, Check3 yp xp+70 vMHold gMHold, %Lang139%
Gui, 5:Add, Text, Section yp+25 xs vClicks, %Lang147%:
Gui, 5:Add, Edit, Limit Number ys-2 W60 H20 vCCount
Gui, 5:Add, UpDown, 0x80 Range0-999999, 1
Gui, 5:Add, GroupBox, Section xm W250 H65
Gui, 5:Add, Checkbox, Section ys+15 xs+10 vCSend gCSend, %Lang084%:
Gui, 5:Add, Edit, vDefCt W170 Disabled
Gui, 5:Add, Button, yp-1 xp+170 W60 H22 vGetCtrl gGetCtrl Disabled, %Lang076%
Gui, 5:Add, Button, ys-5 xp W60 H22 vSetWin gSetWin Disabled, %Lang092%
Gui, 5:Add, GroupBox, Section xm W250 H110
Gui, 5:Add, Text, Section ys+15 xs+10, %Lang030%:
Gui, 5:Add, Text,, %Lang085%:
Gui, 5:Add, Edit, Limit Number ys W120 H20 vEdRept
Gui, 5:Add, UpDown, vTimesX 0x80 Range1-999999, 1
Gui, 5:Add, Edit, Limit Number W120
Gui, 5:Add, UpDown, vDelayX 0x80 Range0-999999, %DelayM%
Gui, 5:Add, Radio, Section yp+25 xm+10 Checked gMsc vMsc, %Lang086%
Gui, 5:Add, Radio, gSec vSec, %Lang087%
Gui, 5:Add, Button, Section Default xm W60 H22 gMouseOK, %Lang059%
Gui, 5:Add, Button, ys W60 H22 gMouseCancel, %Lang060%
If Caller = Edit
{
	If InStr(Action, "Left")
		GuiControl, 5:, LB, 1
	If InStr(Action, "Right")
		GuiControl, 5:, RB, 1
	If InStr(Action, "Middle")
		GuiControl, 5:, MB, 1
	If InStr(Action, "X1")
		GuiControl, 5:, X1, 1
	If InStr(Action, "X2")
		GuiControl, 5:, X2, 1
	StringReplace, Action, Action, Left%A_Space%
	StringReplace, Action, Action, Right%A_Space%
	StringReplace, Action, Action, Middle%A_Space%
	StringReplace, Action, Action, X1%A_Space%
	StringReplace, Action, Action, X2%A_Space%
	If Action = %Action1%
	{
		If Type = %Type13%
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, Click, 1
		GoSub, Click
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		StringReplace, Par2, Par2, `,
		If ((Par2 <> "Down") && (Par2 <> "Up"))
			GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If Action = %Action2%
	{
		GuiControl, 5:, Point, 1
		GoSub, Point
	}
	If Action = %Action3%
	{
		GuiControl, 5:, PClick, 1
		GoSub, PClick
	}
	If Action = %Action4%
	{
		StringReplace, DetailsX, Details, Rel%A_Space%,, All
		StringReplace, DetailsX, DetailsX, `}`{, |, All
		Loop, Parse, DetailsX, |
			Details%A_Index% := A_LoopField
		StringReplace, Details1, Details1, `{
		StringReplace, Details2, Details2, `}
		Loop, Parse, Details1, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, IniX, %Par2%
		GuiControl, 5:, IniY, %Par3%
		Loop, Parse, Details2, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, EndX, %Par2%
		GuiControl, 5:, EndY, %Par3%
		GuiControl, 5:, Drag, 1
		GoSub, Drag
	}
	If Action = %Action5%
	{
		If Type = %Type13%
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WUp, 1
		GoSub, WUp
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If Action = %Action6%
	{
		If Type = %Type13%
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WDn, 1
		GoSub, WDn
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If InStr(Details, " Down")
	{
		GuiControl, 5:, MHold, 1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Down
	}
	If InStr(Details, " Up")
	{
		GuiControl, 5:, MHold, -1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Up
	}
	If Type = %Type4%
	{
		GuiControl, 5:, CSend, 1
		GuiControl, 5:Enable, CSend
		GuiControl, 5:Enable, DefCt
		GuiControl, 5:Enable, GetCtrl
		GuiControl, 5:Enable, SetWin
		GuiControl, 5:Enable, MRel
		GuiControl, 5:, MRel, 1
		GuiControl, 5:Enable, IniX
		GuiControl, 5:Enable, IniY
		GuiControl, 5:Enable, MouseGetI
		GuiControl, 5:, DefCt, %Target%
		Window = %Window%
		Loop, Parse, Details, `,
			Par%A_Index% := A_LoopField
		Loop, Parse, Par3, %A_Space%
			Param%A_Index% := A_LoopField
		If InStr(Param1, "x")
		{
			StringReplace, Param1, Param1, x
			StringReplace, Param2, Param2, y
			GuiControl, 5:, IniX, %Param1%
			GuiControl, 5:, IniY, %Param2%
		}
		If InStr(Param2, "x")
		{
			StringReplace, Param2, Param2, x
			StringReplace, Param3, Param3, y
			GuiControl, 5:, IniX, %Param2%
			GuiControl, 5:, IniY, %Param3%
		}
		If RegExMatch(Target, "^x[0-9]+ y[0-9]+$")
		{
			StringReplace, Target, Target, x
			StringReplace, Target, Target, y
			Loop, Parse, Target, %A_Space%
				Targ%A_Index% := A_LoopField
			GuiControl, 5:Enable, CSend
			GuiControl, 5:Disable, DefCt
			GuiControl, 5:Disable, GetCtrl
			GuiControl, 5:, MRel, 0
			GuiControl, 5:, DefCt
			GuiControl, 5:, IniX, %Targ1%
			GuiControl, 5:, IniY, %Targ2%
		}
	}
	If Type = %Type13%
	{
		GuiControl, 5:, SE, 1
		GoSub, SE
	}
	If InStr(Details, "Rel")
		GuiControl, 5:, MRel, 1
	GuiControl, 5:, TimesX, %TimesX%
	GuiControl, 5:, DelayX, %DelayX%
	If ((Action = Action2) || (Action = Action3))
	{
		If Type = %Type13%
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		StringReplace, Details, Details, Rel%A_Space%
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		StringReplace, Par1, Par1, `,
		StringReplace, Par2, Par2, `,
		GuiControl, 5:, IniX, %Par1%
		GuiControl, 5:, IniY, %Par2%
		If Action = %Action2%
			GuiControl, 5:, CCount, 1
		Else
		{
			If ((Par4 <> "Down") && (Par4 <> "Up"))
				GuiControl, 5:, CCount, %Par4%
		}
	}
}
Else
	Window = A
Gui, 5:Show,, %Lang016%
GoSub, DelKey
Input
return

MouseOK:
Gui +OwnDialogs
Gui, Submit, NoHide
If Msc = 1
	DelayX = %DelayX%
If Sec = 1
	DelayX := DelayX * 1000
If TimesX = 0
	TimesX := 1
If LB = 1
	Button = Left
If RB = 1
	Button = Right
If MB = 1
	Button = Middle
If X1 = 1
	Button = X1
If X2 = 1
	Button = X2
If Click = 1
	GoSub, f_Click
If Point = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %Lang088%, %Lang089%
			return
	}
	Else
	GoSub, f_Point
}
If PClick = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %Lang088%, %Lang089%
		return
	}
	Else
	GoSub, f_PClick
}
If Drag = 1
{
	If ((IniX = "") || (IniY = "") || (EndX = "") || (EndY = ""))
	{
		MsgBox, 16, %Lang088%, %Lang089%
		return
	}
	Else
	GoSub, f_Drag
}
If WUp = 1
{
	GoSub, f_WUp
}
If WDn = 1
{
	GoSub, f_WDn
}
GuiControlGet, CtrlState, Enabled, DefCt
If CtrlState = 1
{
	If CSend = 1
	{
		If DefCt = 
		{
			MsgBox, 16, %Lang088%, %Lang052%
			return
		}
		Else
		{
			Target = %DefCt%
			Type = %Type4%
		}
	}
	Else
	{
		If CSend = 0
		{
			Target := ""
			Window := ""
		}
	}
}
Else
{
	If CSend = 1
	{
		If ((IniX = "") || (IniY = ""))
		{
			MsgBox, 16, %Lang088%, %Lang089%
			return
		}
		Else
		{
			Details .= " NA"
			Target = x%IniX% y%IniY%
			Type = %Type4%
		}
	}
	Else
	{
		Target := ""
		Window := ""
	}
}
Gui, 1:-Disabled
Gui, 5:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Window)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
Caller = 
GuiControl, Focus, InputList
return

MouseCancel:
5GuiClose:
5GuiEscape:
Gui, 1:-Disabled
Gui, 5:Destroy
Caller = 
return

f_Click:
Action = %Button% %Action1%
Details = %Button%
If MHold = 0
{
	Details = %Details%, %CCount%,%A_Space%
}
If MHold = 1
{
	Details = %Details%,, Down
}
If MHold = -1
{
	Details = %Details%,, Up
}
If MRel = 1
{
	If ((IniX <> "") && (IniY <> ""))
		Details = %Details% x%IniX% y%IniY% NA
}
If SE = 1
{
	Details = {Click, %Details%}
	Type = %Type13%
}
Else
	Type = %Type3%
return

f_Point:
Action = %Action2%
Details = %IniX%, %IniY%, 0
If MRel = 1
	Details = Rel %Details%
If SE = 1
{
	Details = {Click, %Details%}
	Type = %Type13%
}
Else
	Type = %Type3%
return

f_PClick:
Action = %Button% %Action3%
Details = %IniX%, %IniY% %Button%
If MHold = 1
	Details = %Details%, Down
If MHold = -1
	Details = %Details%, Up
If MRel = 1
	Details = Rel %Details%
If MHold = 0
	Details = %Details%, %CCount%
If SE = 1
{
	Details = {Click, %Details%}
	Type = %Type13%
}
Else
	Type = %Type3%
return

f_Drag:
Action = %Button% %Action4%
DetailsI = %IniX%, %IniY%, %Button% Down
DetailsE = %EndX%, %EndY%, %Button% Up
If MRel = 1
{
	DetailsI = Rel %DetailsI%
	DetailsE = Rel %DetailsE%
}
Details = {Click, %DetailsI%}{Click, %DetailsE%}
Type = %Type13%
return

f_WUp:
Action = %Action5%
Details = WheelUp
Details = %Details%, %CCount%
If SE = 1
{
	Details = {Click, %Details%}
	Type = %Type13%
}
Else
	Type = %Type3%
return

f_WDn:
Action = %Action6%
Details = WheelDown
Details = %Details%, %CCount%
If SE = 1
{
	Details = {Click, %Details%}
	Type = %Type13%
}
Else
	Type = %Type3%
return

Click:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GoSub, CSend
GuiControl, 5:Disable%SE%, CSend
return

Point:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

PClick:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GuiControl, 5:Disable, CSend
return

Drag:
Gui, Submit, NoHide
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, EndX
GuiControl, 5:Enable, EndY
GuiControl, 5:Enable, MouseGetE
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:, SE, 1
GuiControl, 5:Disable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

WUp:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

WDn:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

CL:
Gui, Submit, NoHide
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
If Click = 1
	GoSub, Click
If Point = 1
	GoSub, Point
If PClick = 1
	GoSub, PClick
If Drag = 1
	GoSub, Drag
If WUp = 1
	GoSub, WUp
If WDn = 1
	GoSub, WDn
return

SE:
Gui, Submit, NoHide
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:, MRel, 0
return

MRel:
Gui, Submit, NoHide
If ((Click = 1) || (WUp = 1) || (WDn = 1))
{
	GuiControl, 5:Enable%MRel%, DefCt
	GuiControl, 5:Enable%MRel%, GetCtrl
}
return

MHold:
Gui, Submit, NoHide
If MHold = 0
{
	GuiControl, 5:Enable, Clicks
	GuiControl, 5:Enable, CCount
}
If MHold = 1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
If MHold = -1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
return

MouseGetI:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 100
KeyWait, RButton, D
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
GuiControlGet, CtrlState, Enabled, DefCt
If CtrlState = 1
{
	GuiControl,, IniX, %xcpos%
	GuiControl,, IniY, %ycpos%
}
Else
{
	GuiControl,, IniX, %xPos%
	GuiControl,, IniY, %yPos%
}
return

MouseGetE:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 100
KeyWait, RButton, D
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
GuiControl,, EndX, %xPos%
GuiControl,, EndY, %yPos%
return

GetCtrl:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 100
KeyWait, RButton, D
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
GuiControl,, DefCt, %control%
return

GetWin:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 100
KeyWait, RButton, D
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
If Ident = Title
{
	If Label = IfGet
	{
		FoundTitle = %Title%
		return
	}
	GuiControl,, Title, %Title%
}
Else
If Ident = Class
{
	GuiControl,, Title, ahk_class %class%
	FoundTitle = ahk_class %class%
}
Else
If Ident = Process
{
	GuiControl,, Title, ahk_exe %pname%
	FoundTitle = ahk_exe %pname%
}
Else
If Ident = ID
{
	GuiControl,, Title, ahk_id %id%
	FoundTitle = ahk_id %id%
}
return

WinGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 100
KeyWait, RButton, D
WinGetPos, X, Y, W, H, A
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
GuiControl,, PosX, %X%
GuiControl,, PosY, %Y%
GuiControl,, SizeX, %W%
GuiControl,, SizeY, %H%
return

GetArea:
Gui, Submit, NoHide
CoordMode, Mouse, %CoordPixel%
Draw := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 0
KeyWait, RButton, D
WinActivate, ahk_id %TargetWindow%
iX = %xPos%
iY = %yPos%
KeyWait, RButton
WinActivate, ahk_id %TargetWindow%
eX = %xPos%
eY = %yPos%
Gui, 20:Destroy
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Draw := 0
WinActivate, ahk_id %WindowID%
GuiControl,, iPosX, %iX%
GuiControl,, iPosY, %iY%
GuiControl,, ePosX, %eX%
GuiControl,, ePosY, %eY%
return

GetPixel:
CoordMode, Mouse, %CoordPixel%
NoKey := 1
WinMinimize, ahk_id %WindowID%
SetTimer, WatchCursor, 10
KeyWait, RButton, D
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %WindowID%
GuiControl,, ImgFile, %color%
GuiControl, +Background%color%, ColorPrev
return

WatchCursor:
If Draw = 1
	CoordMode, Mouse, %CoordPixel%
Else
	CoordMode, Mouse, %CoordMouse%
CoordMode, Pixel, %CoordMouse%
MouseGetPos, xPos, yPos, id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
PixelGetColor, color, %xPos%, %yPos%, RGB
WinGet, pname, ProcessName, ahk_id %id%
ControlGetPos, x, y,, , %control%, A
xcpos := Controlpos(xPos, x)
ycpos := Controlpos(yPos, y)
If Draw = 1
	ToolTip, X%xPos% Y%yPos%`n%Lang205%
Else
	ToolTip, X%xPos% Y%yPos%`n%Lang033%: %control% X%xcpos% Y%ycpos%`n%Lang091%: %color%`n`nahk_id %id%`nahk_class %class%`n%title%`n%pname%`n`n%Lang090%
If CoordPixel = Window
{
	WinMove, SelectAreaGui,, (AreaX-8), (AreaY-8), (xPos-AreaX), (yPos-AreaY)
	MarginX := xPos - AreaX - 2
	MarginY := yPos - AreaY - 2
}
If CoordPixel = Screen
{
	WinMove, SelectAreaGui,,,, (xPos-AreaX), (yPos-AreaY)
	MarginX := xPos - AreaX - 2
	MarginY := yPos - AreaY - 2
}
WinSet, Region, 0-0 %xPos%-0 %xPos%-%yPos% 0-%yPos% 0-0   2-2 %MarginX%-2 %MarginX%-%MarginY% 2-%MarginY% 2-2, SelectAreaGui
return

Controlpos(z1, z2)
{
	return z1 - z2
}

NoKey:
return

#If NoKey
RButton::
return
RButton Up::
return

#If Draw
RButton::
TargetWindow = %id%
AreaX = %xPos%
AreaY = %yPos%
CoordMode, Mouse, %CoordPixel%
Gui, 20: +AlwaysOnTop +Toolwindow -Caption
Gui, 20:Color, Red
Gui, 20:Show, W2 H2 x%AreaX% y%AreaY%, SelectAreaGui
return
RButton Up::
return
#If

Special:
Gui, 7:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 7:Add, GroupBox, W380 H170 , %Lang018%:
Gui, 7:Add, Radio, ys+20 xs+10 Group vSpecKey, %Lang094%
Gui, 7:Add, Radio, ys+20 xp+120, %Lang095%
Gui, 7:Add, Radio, ys+20 xp+120, %Lang096%
Gui, 7:Add, Radio, ys+40 xs+10, %Lang097%
Gui, 7:Add, Radio, ys+40 xp+120, %Lang098%
Gui, 7:Add, Radio, ys+40 xp+120, %Lang099%
Gui, 7:Add, Radio, ys+60 xs+10, %Lang100%
Gui, 7:Add, Radio, ys+60 xp+120, %Lang101%
Gui, 7:Add, Radio, ys+60 xp+120, %Lang102%
Gui, 7:Add, Radio, ys+80 xs+10, %Lang103%
Gui, 7:Add, Radio, ys+80 xp+120, %Lang104%
Gui, 7:Add, Radio, ys+80 xp+120, %Lang105%
Gui, 7:Add, Radio, ys+100 xs+10, %Lang106%
Gui, 7:Add, Radio, ys+100 xp+120, %Lang107%
Gui, 7:Add, Radio, ys+100 xp+120, %Lang108% 
Gui, 7:Add, Radio, ys+120 xs+10, %Lang109%
Gui, 7:Add, Radio, ys+120 xp+120, %Lang110%
Gui, 7:Add, Radio, ys+120 xp+120, %Lang111%
Gui, 7:Add, Radio, ys+140 xs+10, %Lang063%:
Gui, 7:Add, Edit, ys+138 xp+95 W60 vKeyName 0x201 ReadOnly
Gui, 7:Add, Text, ys+140 xp+62, VK:
Gui, 7:Add, Edit, ys+138 xp+20 W50 vVKey 0x201 ReadOnly
Gui, 7:Add, Text, ys+140 xp+50, SC:
Gui, 7:Add, Edit, ys+138 xp+20 W50 vSCode 0x201 ReadOnly
Gui, 7:Add, Button, ys+136 xp+50 gAddSC, %Lang064%
Gui, 7:Add, Button, Section Default xm W60 H22 gSpecOK, %Lang059%
Gui, 7:Add, Button, ys W60 H22 gSpecCancel, %Lang060%
Gui, 7:Add, Text, ys+5 xp+80 W250 vStMsg
Gui, 7:Show,, %Lang018%
GoSub, DelKey
Input
OnMessage(0x200, "")
;##################################################
; Modified Code
; Author: SKAN
; Original code from: l.autohotkey.net/forum/topic22881.html
;##################################################
Loop 9
	OnMessage(255+A_Index, "ScanCode")
return

ScanCode(wParam, lParam)
{
	VK := GetKeyVK(A_PriorKey)
	SC := GetKeySC(A_PriorKey)
	SetFormat, IntegerFast, hex
	SC += 0
	SC .= ""
	VK += 0
	VK .= ""
	SetFormat, IntegerFast, d
	GuiControl,, KeyName, %A_PriorKey%
	GuiControl,, VKey, VK%VK%
	GuiControl,, SCode, SC%SC%
}
return
;##################################################

SpecOK:
Gui, Submit, NoHide
If SpecKey = 0
	return
If SpecKey = 1
	SKey = Browser_Back
If SpecKey = 2
	SKey = Browser_Forward
If SpecKey = 3
	SKey = Browser_Refresh
If SpecKey = 4
	SKey = Browser_Stop
If SpecKey = 5
	SKey = Browser_Search
If SpecKey = 6
	SKey = Browser_Favorites
If SpecKey = 7
	SKey = Browser_Home
If SpecKey = 8
	SKey = Launch_Media
If SpecKey = 9
	SKey = Volume_Mute
If SpecKey = 10
	SKey = Volume_Up
If SpecKey = 11
	SKey = Volume_Down
If SpecKey = 12
	SKey = Media_Play_Pause
If SpecKey = 13
	SKey = Media_Prev
If SpecKey = 14
	SKey = Media_Next
If SpecKey = 15
	SKey = Media_Stop
If SpecKey = 16
	SKey = Launch_Mail
If SpecKey = 17
	SKey = Launch_App1
If SpecKey = 18
	SKey = Launch_App2
If SpecKey = 19
{
	If SCode = 
	{
	GuiControl,, StMsg, %Lang066%
		return
	}
	Else
		sKey = %VKey%%SCode%
		tKey = %KeyName%
}
If SpecKey <> 19
	tKey = %sKey%
GoSub, Replace
GoSub, ReplaceHold
LV_MoveRow(0)
GoSub, RowCheck
sKey = {%sKey%}
Gui, 1:-Disabled
Gui, 7:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, tKey, sKey, 1, DelayG, Type1)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, tKey, sKey, 1, DelayG, Type1)
	}
}
LV_MoveRow(0)
GoSub, RowCheck
GuiControl, Focus, InputList
OnMessage(0x200, "WM_MOUSEMOVE")
return

SpecCancel:
7GuiClose:
7GuiEscape:
Gui, 1:-Disabled
Gui, 7:Destroy
OnMessage(0x200, "WM_MOUSEMOVE")
return

AddSC:
Gui +OwnDialogs
Gui, Submit, NoHide
{
	If SCode = 
	{
		GuiControl,, StMsg, %Lang066%
		return
	}
	Else
	{
		VirtualKeys = %VirtualKeys%{%VKey%%SCode%}
		GuiControl,, StMsg, %Lang112%
		Sleep, 3000
		GuiControl,, StMsg
	}
}
return

EditText:
Caller = Edit
Text:
Input
Gui, 8:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 8:Add, Edit, vTextEdit WantTab W600 R30
Gui, 8:Add, Text, Section, %Lang030%:
Gui, 8:Add, Edit, ys-2 xp+40 Limit Number W100 H20 vEdRept
Gui, 8:Add, UpDown, vTimesX 0x80 Range1-999999, 1
Gui, 8:Add, Button, Section Default xm W60 H22 gTextOK, %Lang059%
Gui, 8:Add, Button, ys W60 H22 gTextCancel, %Lang060%
Gui, 8:Add, Radio, Checked ys-20 xp+80 vRaw gRaw, %Lang113%
Gui, 8:Add, Radio, vComText gComText, %Lang114%
Gui, 8:Add, Radio, ys-20 xp+130 vClip gClip, %Lang115%
Gui, 8:Add, Radio, vSetText gSetText, %Lang116%
Gui, 8:Add, Checkbox, ys-20 xp+100 vCSend gCSend, %Lang084%:
Gui, 8:Add, Edit, vDefCt W150 Disabled
Gui, 8:Add, Button, yp-1 xp+150 W60 H22 vGetCtrl gGetCtrl Disabled, %Lang076%
Gui, 8:Add, Button, ys-25 xp W60 H22 vSetWin gSetWin Disabled, %Lang092%
If Caller = Edit
{
	StringReplace, Details, Details, ``n, `n, All
	GuiControl, 8:, TextEdit, %Details%
	GuiControl, 8:, TimesX, %TimesX%
	If ((Type = Type1) || (Type = Type2))
		GuiControl, 8:, ComText, 1
	If ((Type = Type8) || (Type = Type9))
		GuiControl, 8:, Raw, 1
	If Type = %Type10%
		GuiControl, 8:, SetText, 1
	If Type = %Type12%
		GuiControl, 8:, Clip, 1
	If Target <> ""
		GuiControl, 8:, DefCt, %Target%
	If InStr(Type, "Control")
	{
		GuiControl, 8:, CSend, 1
		GuiControl, 8:Enable, DefCt
		GuiControl, 8:Enable, GetCtrl
		GuiControl, 8:Enable, SetWin
	}
}
Else
	Window = A
Gui, 8:Show,, %Lang017%
GoSub, DelKey
return

TextOK:
Gui +OwnDialogs
Gui, Submit, NoHide
StringReplace, TextEdit, TextEdit, `n, ``n, All
If Raw = 1
	Type = %Type8%
If ComText = 1
	Type = %Type1%
If SetText = 1
	Type = %Type10%
If Clip = 1
	Type = %Type12%
GuiControlGet, CtrlState, Enabled, DefCt
If CtrlState = 1
{
	If CSend = 1
	{
		If DefCt = 
		{
			MsgBox, 16, %Lang088%, %Lang052%
			return
		}
		Else
		{
		Target = %DefCt%
		If Type = %Type1%
			Type = %Type2%
		If Type = %Type8%
			Type = %Type9%
		}
	}
	Else
	{
		If CSend = 0
		{
			Target := ""
			Window := ""
			If Type = %Type2%
				Type = %Type1%
			If Type = %Type9%
				Type = %Type8%
		}
	}
}
Else
{
	Target := ""
	Window := ""
}
Gui, 1:-Disabled
Gui, 8:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col3", TextEdit, TimesX, DelayX, Type, Target, Window)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[Text]", TextEdit, TimesX, DelayG, Type, Target, Window)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, "[Text]", TextEdit, TimesX, DelayG, Type, Target, Window)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
Caller = 
GuiControl, Focus, InputList
return

TextCancel:
8GuiClose:
8GuiEscape:
Gui, 1:-Disabled
Gui, 8:Destroy
Caller = 
return

Raw:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

ComText:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

SetText:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

Clip:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

Pause:
GuiA := 3
Gui, 3:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 3:Add, GroupBox, Section xm W230 H80 Disabled
Gui, 3:Add, Text, Section ys+15 xs+10, %Lang117%:
Gui, 3:Add, Edit, ys-2 xs+90 Limit Number W120 vDelayC
Gui, 3:Add, UpDown, vDelayX 0x80 Range0-999999, 300
Gui, 3:Add, Radio, Section yp+25 xm+10 Checked gMsc vMsc, %Lang086%
Gui, 3:Add, Radio, gSec vSec, %Lang087%
Gui, 3:Add, GroupBox, Section xm W230 H110
Gui, 3:Add, Checkbox, Section ys+15 xs+10 vMP gMP, %Lang118%:
Gui, 3:Add, Edit, vMsgPt W210 r4 Disabled
Gui, 3:Add, GroupBox, Section xm W230 H110
Gui, 3:Add, Checkbox, Section ys+15 xs+10 vKW gKW, %Lang218%:
Gui, 3:Add, Hotkey, vWaitKeys gWaitKeys W210 Disabled
Gui, 3:Add, Text, Section xs vTimoutT, %Lang219%:
Gui, 3:Add, Edit, ys-2 xs+90 Limit Number W120 vTimeoutC Disabled
Gui, 3:Add, UpDown, vTimeout 0x80 Range0-999999 Disabled, 0
Gui, 3:Add, Text, xs+90, %Lang220%
Gui, 3:Add, Button, Section Default xm W60 H22 gPauseOK, %Lang059%
Gui, 3:Add, Button, ys W60 H22 gPauseCancel, %Lang060%
Gui, 3:Show,, %Lang117%
GoSub, DelKey
Input
return

MP:
Gui, Submit, NoHide
GuiControl, Enable%MP%, MsgPt
GuiControl, Disable%MP%, DelayC
GuiControl, Disable%MP%, EdRept
GuiControl, Disable%MP%, DelayX
GuiControl, Disable%MP%, Msc
GuiControl, Disable%MP%, Sec
GuiControl, Disable%MP%, KW
return

KW:
Gui, Submit, NoHide
GuiControl, 3:Disable%KW%, DelayC
GuiControl, 3:Disable%KW%, EdRept
GuiControl, 3:Disable%KW%, DelayX
GuiControl, 3:Disable%KW%, Msc
GuiControl, 3:Disable%KW%, Sec
GuiControl, 3:Enable%KW%, WaitKeys
GuiControl, 3:Enable%KW%, TimeoutC
GuiControl, 3:Enable%KW%, Timeout
GuiControl, 3:Disable%KW%, MP
return

WaitKeys:
If WaitKeys contains +^,+!,^!,+^!
	GuiControl, %GuiA%:,WaitKeys
If WaitKeys contains +
	GuiControl, %GuiA%:,WaitKeys, Shift
If WaitKeys contains ^
	GuiControl, %GuiA%:,WaitKeys, Control
If WaitKeys contains !
	GuiControl, %GuiA%:,WaitKeys, Alt
return

PauseOK:
Gui, Submit, NoHide
If Msc = 1
	DelayX = %DelayX%
If Sec = 1
	DelayX := DelayX * 1000
If MP = 1
{
	StringReplace, MsgPT, MsgPT, `n, ``n, All
	Type := Type6
	Details = %MsgPT%
	DelayX := 0
}
Else
If KW = 1
{
	If WaitKeys =
		return
	Type := Type20
	tKey = %WaitKeys%
	GoSub, Replace
	Details = %tKey%
	DelayX = %Timeout%
}
Else
{
	Type := Type5
	Details := ""
}
GuiA := 1
Gui, 1:-Disabled
Gui, 3:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[Pause]", Details, 1, DelayX, Type)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, "[Pause]", Details, 1, DelayX, Type)
	}
}
LV_MoveRow(0)
GoSub, RowCheck
GuiControl, Focus, InputList
return

PauseCancel:
3GuiClose:
3GuiEscape:
GuiA := 1
Gui, 1:-Disabled
Gui, 3:Destroy
return

ComLoop:
Gui, 12:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 12:Add, GroupBox, W190 H55, %Lang119%:
Gui, 12:Add, Text, Section ys+25 xs+10, %Lang030%:
Gui, 12:Add, Edit, Limit Number W120 H20 ys vEdRept
Gui, 12:Add, UpDown, vTimesX 0x80 Range1-999999, 2
Gui, 12:Add, Text, Section xm W160 r2, %Lang122%
Gui, 12:Add, Button, Section Default xm W60 H22 gLoopOK, %Lang059%
Gui, 12:Add, Button, ys W60 H22 gLoopCancel, %Lang060%
Gui, 12:Show,, %Lang021%
GoSub, DelKey
Input
return

LoopOK:
Gui, Submit, NoHide
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[LoopStart]", "LoopStart", TimesX, 0, Type7)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_Add("", ListCount+2, "[LoopEnd]", "LoopEnd", 1, 0, Type7)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If RowNumber <> 0
		{
			LV_Insert(RowNumber, "", RowNumber, "[LoopStart]", "LoopStart", TimesX, 0, Type7)
			break
		}
	}
	RowNumber = 0
	LastRow = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
		{
			LV_Insert(LastRow+1, "",LastRow+1, "[LoopEnd]", "LoopEnd", 1, 0, Type7)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, RowCheck
GuiControl, Focus, InputList
return

LoopCancel:
12GuiClose:
12GuiEscape:
Gui, 1:-Disabled
Gui, 12:Destroy
return

LoopS:
GuiControl, Enable, EdRept
GuiControl, Enable, TimesX
return

LoopE:
GuiControl, Disable, EdRept
GuiControl, Disable, TimesX
return

EditWindow:
Caller = Edit
Window:
Gui, 11:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 11:Add, Text, , %Lang123%:
Gui, 11:Add, DropdownList, Section xm W150 vWinCom gWinCom, WinActivate|WinActivateBottom|WinClose|WinHide|WinKill|WinMaximize|WinMinimize|WinMinimizeAll|WinMinimizeAllUndo|WinMove|WinRestore|WinSet|WinShow|WinWait|WinWaitActive|WinWaitNotActive|WinWaitClose|
Gui, 11:Add, Radio, Section xs checked vAlwaysOnTop Disabled, %Lang124%
Gui, 11:Add, Radio, vBottom Disabled, %Lang125%
Gui, 11:Add, Radio, vTop Disabled, %Lang126%
Gui, 11:Add, Radio, vDisable Disabled, %Lang127%
Gui, 11:Add, Radio, vEnable Disabled, %Lang128%
Gui, 11:Add, Radio, vRedraw Disabled, %Lang129%
Gui, 11:Add, Radio, vTransparent Disabled, %Lang130%
Gui, 11:Add, Text, vValue, 255
Gui, 11:Add, Slider, Section yp Buddy2Value vN gN Range0-255 Disabled, 255
Gui, 11:Add, Text, Section ys+40 xm, %Lang187%
Gui, 11:Add, Text, yp xs+50, X:
Gui, 11:Add, Edit, ys-3 xs+65 vPosX Limit W35 Disabled
Gui, 11:Add, Text, ys xp+40, Y:
Gui, 11:Add, Edit, ys-3 xp+15 vPosY Limit W35 Disabled
Gui, 11:Add, Button, ys-5 xp+40 W60 H22 vWinGetP gWinGetP Disabled, %Lang076%
Gui, 11:Add, Text, Section xm, %Lang188%
Gui, 11:Add, Text, yp xs+50, X:
Gui, 11:Add, Edit, ys-3 xs+65 vSizeX Limit W35 Disabled
Gui, 11:Add, Text, ys xp+40, Y:
Gui, 11:Add, Edit, ys-3 xp+15 vSizeY Limit W35 Disabled
Gui, 11:Add, DropdownList, Section ys+30 xm W65 vIdent, Title||Class|Process|ID
Gui, 11:Add, Edit, Section xm W160 vTitle, A
Gui, 11:Add, Button, ys-1 xp+160 W60 H22 vGetWin gGetWin, %Lang076%
Gui, 11:Add, Text, Section ys+30 xm, %Lang030%:
Gui, 11:Add, Edit, Limit Number W120 H20 ys vEdRept
Gui, 11:Add, UpDown, vTimesX 0x80 Range1-999999, 1
Gui, 11:Add, Button, Section Default y+10 xm W60 H22 gWinOK, %Lang059%
Gui, 11:Add, Button, ys W60 H22 gWinCancel, %Lang060%
If Caller = Edit
{
	GuiControl, 11:, Title, %Window%
	GuiControl, 11:, TimesX, %TimesX%
	GuiControl, 11:ChooseString, WinCom, %Action%
	If Action = WinSet
	{
		GoSub, WinCom
		If InStr(Details, "AlwaysOnTop")
			GuiControl, 11:, AlwaysOnTop, 1
		If InStr(Details, "Bottom")
			GuiControl, 11:, Bottom, 1
		If InStr(Details, "Top")
			GuiControl, 11:, Top, 1
		If InStr(Details, "Disable")
			GuiControl, 11:, Disable, 1
		If InStr(Details, "Enable")
			GuiControl, 11:, Enable, 1
		If InStr(Details, "Redraw")
			GuiControl, 11:, Redraw, 1
		If InStr(Details, "Transparent")
		{
			GuiControl, 11:, Transparent, 1
			Loop, Parse, Details, `,
				Par%A_Index% := A_LoopField
			GuiControl, 11:, N, %Par2%
			GuiControl, 11:, Value, %Par2%
		}
	}
	If Action = WinMove
	{
		GoSub, WinCom
		Loop, Parse, Details, `,
			Par%A_Index% := A_LoopField
		GuiControl, 11:, PosX, %Par1%
		GuiControl, 11:, PosY, %Par2%
		GuiControl, 11:, SizeX, %Par3%
		GuiControl, 11:, SizeY, %Par4%
	}
	If InStr(Window, "ahk_class")
		GuiControl, 11:Choose, Ident, 2
	If InStr(Window, "ahk_exe")
		GuiControl, 11:Choose, Ident, 3
	If InStr(Window, "ahk_id")
		GuiControl, 11:Choose, Ident, 4
}
Gui, 11:Show,, %Lang067%
GoSub, DelKey
Input
return

WinOK:
Gui, Submit, NoHide
If WinCom = 
	return
If WinCom = WinSet
{
	If AlwaysOnTop = 1
		Att = AlwaysOnTop, Toggle
	If Bottom = 1
		Att = Bottom,
	If Top = 1
		Att = Top,
	If Disable = 1
		Att = Disable,
	If Enable = 1
		Att = Enable,
	If Redraw = 1
		Att = Redraw,
	If Transparent = 1
		Att = Transparent, %N%
}
Else
If WinCom = WinMove
	Att = %PosX%, %PosY%, %SizeX%, %SizeY%
Else
	Att := ""
Gui, 1:-Disabled
Gui, 11:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col2", WinCom, Att, TimesX, DelayX, WinCom, "", Title)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, WinCom, Att, TimesX, DelayW, WinCom, "", Title)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, WinCom, Att, TimesX, DelayW, WinCom, "", Title)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
Caller = 
GuiControl, Focus, InputList
return

WinCancel:
11GuiClose:
11GuiEscape:
Gui, 1:-Disabled
Gui, 11:Destroy
Caller = 
return

WinCom:
Gui, Submit, NoHide
If WinCom = WinSet
{
	GuiControl, 11:Enable, AlwaysOnTop
	GuiControl, 11:Enable, Bottom
	GuiControl, 11:Enable, Top
	GuiControl, 11:Enable, Disable
	GuiControl, 11:Enable, Enable
	GuiControl, 11:Enable, Redraw
	GuiControl, 11:Enable, Transparent
	GuiControl, 11:Enable, N
}
If WinCom <> WinSet
{
	GuiControl, 11:Disable, AlwaysOnTop
	GuiControl, 11:Disable, Bottom
	GuiControl, 11:Disable, Top
	GuiControl, 11:Disable, Disable
	GuiControl, 11:Disable, Enable
	GuiControl, 11:Disable, Redraw
	GuiControl, 11:Disable, Transparent
	GuiControl, 11:Disable, N
}
If WinCom = WinMove
{
	GuiControl, 11:Enable, PosX
	GuiControl, 11:Enable, PosY
	GuiControl, 11:Enable, WinGetP
	GuiControl, 11:Enable, SizeX
	GuiControl, 11:Enable, SizeY
}
If WinCom <> WinMove
{
	GuiControl, 11:Disable, PosX
	GuiControl, 11:Disable, PosY
	GuiControl, 11:Disable, WinGetP
	GuiControl, 11:Disable, SizeX
	GuiControl, 11:Disable, SizeY
}
return

N:
Gui, Submit, NoHide
GuiControl,, Value, %N%
return

EditImage:
Caller = Edit
Image:
Gui, 19:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 19:Add, Text,, %Lang120%
Gui, 19:Add, Text, yp xs+45, X:
Gui, 19:Add, Edit, yp xp+15 viPosX Limit W35, 0
Gui, 19:Add, Text, yp xp+40, Y:
Gui, 19:Add, Edit, yp xp+15 viPosY Limit W35, 0
Gui, 19:Add, Button, yp xp+38 W60 H22 vGetArea gGetArea, %Lang076%
Gui, 19:Add, Text, yp+27 xs, %Lang121%
Gui, 19:Add, Text, yp xs+45, X:
Gui, 19:Add, Edit, yp-3 xp+15 vePosX Limit W35, %A_ScreenWidth%
Gui, 19:Add, Text, yp xp+40, Y:
Gui, 19:Add, Edit, yp xp+15 vePosY Limit W35, %A_ScreenHeight%
Gui, 19:Add, Radio, Section Checked yp+25 xs vImageS gImageS, %Lang199%
Gui, 19:Add, Radio, yp xp+100 vPixelS gPixelS, %Lang202%
Gui, 19:Add, Edit, xs vImgFile W165 H20 -Multi
Gui, 19:Add, Button, yp-2 xp+165 gSearchImg, %Lang046%
Gui, 19:Add, Text, yp+30 xs W150, %Lang206%:
Gui, 19:Add, Dropdownlist, yp-2 xp+140 W75 vIfFound, Continue|Stop||Prompt|Move|Left Click|Right Click|Middle Click
Gui, 19:Add, Text, yp+25 xs W150, %Lang207%:
Gui, 19:Add, Dropdownlist, yp-2 xp+140 W75 vIfNotFound, Continue||Stop|Prompt
Gui, 19:Add, Text, yp+25 xs W60, %Lang057%:
Gui, 19:Add, Pic, Section xm+5 W210 H130 vPicPrev
Gui, 19:Add, Progress, ys xm W210 H130 Disabled Hidden vColorPrev
Gui, 19:Add, Text, Section y+10 xm+2 W80, Coord:
Gui, 19:Add, Dropdownlist, yp-5 xp+35 W65 vCoordPixel, Screen||Window
Gui, 19:Add, Text, yp+3 xp+80 W80, %Lang214%:
Gui, 19:Add, Edit, yp-3 xp+55 vVariatT Limit Number W45
Gui, 19:Add, UpDown, vVariat 0x80 Range0-255, 0
Gui, 19:Add, GroupBox, Section xm W220 H110
Gui, 19:Add, Text, Section ys+15 xs+10, %Lang030%:
Gui, 19:Add, Text,, %Lang085%:
Gui, 19:Add, Edit, Limit Number ys W120 H20 vEdRept
Gui, 19:Add, UpDown, vTimesX 0x80 Range1-999999, 1
Gui, 19:Add, Edit, Limit Number W120
Gui, 19:Add, UpDown, vDelayX 0x80 Range0-999999, %DelayG%
Gui, 19:Add, Radio, Section yp+25 xm+10 Checked gMsc vMsc, %Lang086%
Gui, 19:Add, Radio, gSec vSec, %Lang087%
Gui, 19:Add, Button, Section Default xm W60 H22 gImageOK, %Lang059%
Gui, 19:Add, Button, ys W60 H22 gImageCancel, %Lang060%
If Caller = Edit
{
	StringReplace, Action, Action, `,%A_Space%, `,, All
	StringReplace, Details, Details, `,%A_Space%, `,, All
	Loop, Parse, Action, `,
		Act%A_Index% := A_LoopField
	GuiControl, 19:ChooseString, IfFound, %Act1%
	GuiControl, 19:ChooseString, IfNotFound, %Act2%
	Loop, Parse, Details, `,
		Det%A_Index% := A_LoopField
	If Type = %Type16%
	{
		GuiControl, 19:, ImageS, 1
		Variat := RegExReplace(Det5, "\*(\d+)\s.*", "$1")
		GuiControl, 19:, Variat, %Variat%
		Det5 := RegExReplace(Det5, "\*(\d+)\s")
		File = %Det5%
		GoSub, MakePrev
	}
	If Type = %Type15%
	{
		GuiControl, 19:, PixelS, 1
		GuiControl, 19:Hide, PicPrev
		GuiControl, 19:Show, ColorPrev
		color = %Det5%
		GuiControl, 19:+Background%color%, ColorPrev
		GuiControl, 19:, Variat, %Det6%
	}
	GuiControl, 19:, iPosX, %Det1%
	GuiControl, 19:, iPosY, %Det2%
	GuiControl, 19:, ePosX, %Det3%
	GuiControl, 19:, ePosY, %Det4%
	GuiControl, 19:, ImgFile, %Det5%
	GuiControl, 19:ChooseString, CoordPixel, %Window%
	GuiControl, 19:, TimesX, %TimesX%
	GuiControl, 19:, DelayX, %DelayX%
}
Gui, 19:Show,, %Lang203% / %Lang204%
GoSub, DelKey
Input
return

ImageOK:
Gui, Submit, NoHide
If ImgFile = 
	return
Gui, 1:-Disabled
Gui, 19:Destroy
Gui, 1:Default
If Msc = 1
	DelayX = %DelayX%
If Sec = 1
	DelayX := DelayX * 1000
If TimesX = 0
	TimesX := 1
Action = %IfFound%`, %IfNotFound%
If ImageS = 1
{
	Type = %Type16%
	ImgFile = *%Variat% %ImgFile%
}
Details = %iPosX%`, %iPosY%`, %ePosX%`, %ePosY%`, %ImgFile%
If PixelS = 1
{
	Type = %Type15%
	Details .= ", " Variat ", Fast RGB"
}
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type,"",CoordPixel)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, Action, Details, TimesX, DelayX, Type,"",CoordPixel)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, Action, Details, TimesX, DelayX, Type,"",CoordPixel)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
GuiControl, Focus, InputList
Caller = 
return

ImageCancel:
PixelCancel:
19GuiClose:
19GuiEscape:
Gui, 1:-Disabled
Gui, 19:Destroy
Caller = 
return

SearchImg:
Gui, Submit, NoHide
If ImageS = 1
	GoSub, GetImage
If PixelS = 1
	GoSub, GetPixel
return

GetImage:
FileSelectFile, file,, %A_ScriptDir%, Select an image:, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
if file =
	return
GuiControl, 19:, ImgFile, %File%

MakePrev:
Gui, 99:Add, Pic, vLoadedPic, %file% 
GuiControlGet, LoadedPic, 99:Pos
Gui, 99:Destroy
If LoadedPicW > 210
{
	If LoadedPicH > %LoadedPicW%
	{
		Height = 130
		GuiControl, 19:, PicPrev, *W-1 *H%Height% %file%
	}
	Else
	{
		If LoadedPicH > 130
		{
			Height = 130
			GuiControl, 19:, PicPrev, *W-1 *H%Height% %file%
		}
		Else
		{
			Width = 210
			GuiControl, 19:, PicPrev, *W%Width% *H-1 %file%
		}
	}
}
Else
If LoadedPicH > 130
{
	Height = 130
	GuiControl, 19:, PicPrev, *W-1 *H%Height% %file%
}
Else
	GuiControl, 19:, PicPrev, *W0 *H0 %file%
return

ImageS:
Gui, Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Show, PicPrev
GuiControl, 19:Hide, ColorPrev
return

PixelS:
Gui, Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Hide, PicPrev
GuiControl, 19:Show, ColorPrev
return

EditRun:
Caller = Edit
Run:
Input
Gui, 10:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 10:Add, GroupBox, vSGroup Section xm W340 H85
Gui, 10:Add, Text, Section ys+15 xs+10, %Lang020%:
Gui, 10:Add, Edit, vComRun W270 H20 -Multi
Gui, 10:Add, Button, yp-2 xp+270 gSearch, %Lang046%
Gui, 10:Add, Checkbox, xs vRunWait, %Lang192%
Gui, 10:Add, Button, Section Default xm W60 H22 gRunOK, %Lang059%
Gui, 10:Add, Button, ys W60 H22 gRunCancel, %Lang060%
Gui, 10:Show,, %Lang020%
GoSub, DelKey
If Caller = Edit
{
	GuiControl, 10:, ComRun, %Details%
	If Type = %Type14%
		GuiControl, 10:, RunWait, 1
}
return

Search:
Gui +OwnDialogs
FileSelectFile, SelectedFileName, 3, %ProgramFiles%, %Lang038%
If SelectedFileName = 
	return
GuiControl,, ComRun, %SelectedFileName%
return

RunOK:
Gui, Submit, NoHide
Gui, 1:-Disabled
Gui, 10:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RunWait = 1
	Type = %Type14%
Else
	Type = %Type11%
If Caller = Edit
{
	LV_Modify(RowNumber, "Col3", ComRun, TimesX, DelayX, Type)
	Caller = 
	GuiControl, Focus, InputList
	return
}
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[Run]", ComRun, 1, DelayG, Type)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, "[Run]", ComRun, 1, DelayG, Type)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
Caller = 
GuiControl, Focus, InputList
return

RunCancel:
10GuiClose:
10GuiEscape:
Gui, 1:-Disabled
Gui, 10:Destroy
Caller = 
return

EditSt:
Caller = Edit
IfSt:
Gui, 21:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 21:Add, DropdownList, W170 vStatement gStatement, %If1%||%If2%|%If3%|%If4%|%If5%|%If6%|%If7%|%If8%|%If9%|%If10%
Gui, 21:Add, DropdownList, yp xp+180 W85 vIdent, Title||Class|Process|ID
Gui, 21:Add, Edit, y+10 xm W265 -Multi vTestVar
Gui, 21:Add, Button, Section Default xm W60 H22 gIfOK, %Lang059%
Gui, 21:Add, Button, ys W60 H22 gIfCancel, %Lang060%
Gui, 21:Add, Button, ys W60 H22 vAddElse gAddElse, %Lang216%
Gui, 21:Add, Button, ys W60 H22 vIfGet gIfGet, %Lang076%
If Caller = Edit
{
	GuiControl, 21:ChooseString, Statement, %Action%
	GuiControl, 21:, TestVar, %Details%
	GoSub, Statement
	If ((Action = If9) || (Action = If10))
		GuiControl, 21:Disable, TestVar
}
Gui, 21:Show, W290, %Lang200%
GoSub, DelKey
return

IfOK:
Gui, Submit, NoHide
If InStr(Statement, "Image")
	TestVar =
Else
{
	If TestVar =
		return
}
Gui, 1:-Disabled
Gui, 21:Destroy
Gui, 1:Default
If InStr(Statement, "Image")
	TestVar =
If Caller <> Edit
	TimesX := 1
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col2", Statement, TestVar, 1, 0, Type17)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, Statement, TestVar, 1, 0, Type17)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_Add("", ListCount+2, "[End If]", "EndIf", 1, 0, Type17)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If RowNumber <> 0
		{
			LV_Insert(RowNumber, "", RowNumber, Statement, TestVar, 1, 0, Type17)
			break
		}
	}
	RowNumber = 0
	LastRow = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
		{
			LV_Insert(LastRow+1, "",LastRow+1, "[End If]", "EndIf", 1, 0, Type17)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
Caller = 
GoSub, RowCheck
GuiControl, Focus, InputList
return

AddElse:
Gui, Submit, NoHide
Gui, 1:-Disabled
Gui, 21:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[Else]", "Else", 1, 0, Type17)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If RowNumber <> 0
		{
			LV_Insert(RowNumber, "", RowNumber, "[Else]", "Else", 1, 0, Type17)
			break
		}
	}
}
GoSub, RowCheck
GuiControl, Focus, InputList
return

IfCancel:
21GuiClose:
21GuiEscape:
Gui, 1:-Disabled
Gui, 21:Destroy
Caller = 
return

Statement:
Gui, Submit, NoHide
If InStr(Statement, "Window")
	GuiControl, 21:Enable, Ident
If !InStr(Statement, "Window")
	GuiControl, 21:Disable, Ident
If (!InStr(Statement, "Window") && !InStr(Statement, "File"))
	GuiControl, 21:Disable, IfGet
Else
	GuiControl, 21:Enable, IfGet
If ((Statement = If9) || (Statement = If10))
	GuiControl, 21:Disable, TestVar
Else
	GuiControl, 21:Enable, TestVar
return

IfGet:
Gui, Submit, NoHide
If InStr(Statement, "Window")
{
	Label = IfGet
	GoSub, GetWin
	Label =
	GuiControl, 21:, TestVar, %FoundTitle%
	return
}
If InStr(Statement, "File")
{
	GoSub, Search
	GuiControl, 21:, TestVar, %SelectedFileName%
	return
}
return

EditMsg:
Caller = Edit
SendMsg:
Gui, 22:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 22:Add, DropdownList, W100 vMsgType, PostMessage||SendMessage
Gui, 22:Add, DropdownList, yp xp+110 W210 vWinMsg, 
(Join
WM_ACTIVATE|
WM_ACTIVATEAPP|
WM_APP|
WM_ASKCBFORMATNAME|
WM_CANCELJOURNAL|
WM_CANCELMODE|
WM_CAPTURECHANGED|
WM_CHANGECBCHAIN|
WM_CHAR|
WM_CHARTOITEM|
WM_CHILDACTIVATE|
WM_CLEAR|
WM_CLOSE|
WM_COALESCE_FIRST|
WM_COALESCE_LAST|
WM_COMMAND|
WM_COMPACTING|
WM_COMPAREITEM|
WM_CONTEXTMENU|
WM_COPY|
WM_COPYDATA|
WM_CREATE|
WM_CTLCOLOR|
WM_CTLCOLORBTN|
WM_CTLCOLORDLG|
WM_CTLCOLOREDIT|
WM_CTLCOLORLISTBOX|
WM_CTLCOLORMSGBOX|
WM_CTLCOLORSCROLLBAR|
WM_CTLCOLORSTATIC|
WM_CUT|
WM_DDE_ACK|
WM_DDE_ADVISE|
WM_DDE_DATA|
WM_DDE_EXECUTE|
WM_DDE_FIRST|
WM_DDE_INITIATE|
WM_DDE_LAST|
WM_DDE_POKE|
WM_DDE_REQUEST|
WM_DDE_TERMINATE|
WM_DDE_UNADVISE|
WM_DEADCHAR|
WM_DELETEITEM|
WM_DESTROY|
WM_DESTROYCLIPBOARD|
WM_DEVICECHANGE|
WM_DEVMODECHANGE|
WM_DISPLAYCHANGE|
WM_DRAWCLIPBOARD|
WM_DRAWITEM|
WM_DROPFILES|
WM_ENABLE|
WM_ENDSESSION|
WM_ENTERIDLE|
WM_ENTERMENULOOP|
WM_ENTERSIZEMOVE|
WM_ERASEBKGND|
WM_EXITMENULOOP|
WM_EXITSIZEMOVE|
WM_FONTCHANGE|
WM_GETDLGCODE|
WM_GETFONT|
WM_GETHOTKEY|
WM_GETICON|
WM_GETMINMAXINFO|
WM_GETTEXT|
WM_GETTEXTLENGTH|
WM_HANDHELDFIRST|
WM_HANDHELDLAST|
WM_HELP|
WM_HOTKEY|
WM_HSCROLL|
WM_HSCROLLCLIPBOARD|
WM_ICONERASEBKGND|
WM_IME_CHAR|
WM_IME_COMPOSITION|
WM_IME_COMPOSITIONFULL|
WM_IME_CONTROL|
WM_IME_ENDCOMPOSITION|
WM_IME_KEYDOWN|
WM_IME_KEYLAST|
WM_IME_KEYUP|
WM_IME_NOTIFY|
WM_IME_SELECT|
WM_IME_SETCONTEXT|
WM_IME_STARTCOMPOSITION|
WM_INITDIALOG|
WM_INITMENU|
WM_INITMENUPOPUP|
WM_INPUTLANGCHANGE|
WM_INPUTLANGCHANGEREQUEST|
WM_KEYDOWN|
WM_KEYFIRST|
WM_KEYLAST|
WM_KEYUP|
WM_KILLFOCUS|
WM_LBUTTONDBLCLK|
WM_LBUTTONDOWN|
WM_LBUTTONUP|
WM_MBUTTONDBLCLK|
WM_MBUTTONDOWN|
WM_MBUTTONUP|
WM_MDIACTIVATE|
WM_MDICASCADE|
WM_MDICREATE|
WM_MDIDESTROY|
WM_MDIGETACTIVE|
WM_MDIICONARRANGE|
WM_MDIMAXIMIZE|
WM_MDINEXT|
WM_MDIREFRESHMENU|
WM_MDIRESTORE|
WM_MDISETMENU|
WM_MDITILE|
WM_MEASUREITEM|
WM_MENUCHAR|
WM_MENUSELECT|
WM_MOUSEACTIVATE|
WM_MOUSEFIRST|
WM_MOUSEHOVER|
WM_MOUSEHWHEEL|
WM_MOUSELEAVE|
WM_MOUSEMOVE|
WM_MOUSEWHEEL|
WM_MOVE|
WM_MOVING|
WM_NCACTIVATE|
WM_NCCALCSIZE|
WM_NCCREATE|
WM_NCDESTROY|
WM_NCHITTEST|
WM_NCLBUTTONDBLCLK|
WM_NCLBUTTONDOWN|
WM_NCLBUTTONUP|
WM_NCMBUTTONDBLCLK|
WM_NCMBUTTONDOWN|
WM_NCMBUTTONUP|
WM_NCMOUSELEAVE|
WM_NCMOUSEMOVE|
WM_NCPAINT|
WM_NCRBUTTONDBLCLK|
WM_NCRBUTTONDOWN|
WM_NCRBUTTONUP|
WM_NEXTDLGCTL|
WM_NEXTMENU|
WM_NOTIFY|
WM_NOTIFYFORMAT|
WM_NULL|
WM_PAINT|
WM_PAINTCLIPBOARD|
WM_PAINTICON|
WM_PALETTECHANGED|
WM_PALETTEISCHANGING|
WM_PARENTNOTIFY|
WM_PASTE|
WM_PENWINFIRST|
WM_PENWINLAST|
WM_POWER|
WM_POWERBROADCAST|
WM_PRINT|
WM_PRINTCLIENT|
WM_QUERYDRAGICON|
WM_QUERYENDSESSION|
WM_QUERYNEWPALETTE|
WM_QUERYOPEN|
WM_QUEUESYNC|
WM_QUIT|
WM_RBUTTONDBLCLK|
WM_RBUTTONDOWN|
WM_RBUTTONUP|
WM_RENDERALLFORMATS|
WM_RENDERFORMAT|
WM_SETCURSOR|
WM_SETFOCUS|
WM_SETFONT|
WM_SETHOTKEY|
WM_SETICON|
WM_SETREDRAW|
WM_SETTEXT|
WM_SETTINGCHANGE|
WM_SHOWWINDOW|
WM_SIZE|
WM_SIZECLIPBOARD|
WM_SIZING|
WM_SPOOLERSTATUS|
WM_STYLECHANGED|
WM_STYLECHANGING|
WM_SYSCHAR|
WM_SYSCOLORCHANGE|
WM_SYSCOMMAND|
WM_SYSDEADCHAR|
WM_SYSKEYDOWN|
WM_SYSKEYUP|
WM_SYSTEMERROR|
WM_TCARD|
WM_TIMECHANGE|
WM_TIMER|
WM_UNDO|
WM_USER|
WM_USERCHANGED|
WM_VKEYTOITEM|
WM_VSCROLL|
WM_VSCROLLCLIPBOARD|
WM_WINDOWPOSCHANGED|
WM_WINDOWPOSCHANGING|
WM_WININICHANGE|
)
Gui, 22:Add, Text, xm W80, wParam:
Gui, 22:Add, Edit, xm W320 -Multi vwParam
Gui, 22:Add, Text, xm W80, lParam:
Gui, 22:Add, Edit, xm W320 -Multi vlParam
Gui, 22:Add, Text, Section xm, %Lang084%:
Gui, 22:Add, Edit, vDefCt W260
Gui, 22:Add, Button, yp-1 xp+260 W60 H22 vGetCtrl gGetCtrl, %Lang076%
Gui, 22:Add, DropdownList, Section xm W65 vIdent, Title||Class|Process|ID
Gui, 22:Add, Edit, xs+2 W260 vTitle, A
Gui, 22:Add, Button, yp-1 xp+260 W60 H22 vGetWin gGetWin, %Lang076%
Gui, 22:Add, Button, Section Default xm W60 H22 gSendMsgOK, %Lang059%
Gui, 22:Add, Button, ys W60 H22 gSendMsgCancel, %Lang060%
If Caller = Edit
{
	StringReplace, Details, Details, `,%A_Space%, `,, All
	Loop, Parse, Details, `,
		Par%A_Index% := A_LoopField
	GuiControl, 22:ChooseString, MsgType, %Type%
	GuiControl, 22:ChooseString, WinMsg, %Par1%
	GuiControl, 22:, wParam, %Par2%
	GuiControl, 22:, lParam, %Par3%
	GuiControl, 22:, DefCt, %Target%
	GuiControl, 22:, Title, %Window%
}
Gui, 22:Show, , % Type19 " / " Type18
GoSub, DelKey
return

SendMsgOK:
Gui +OwnDialogs
Gui, Submit, NoHide
If WinMsg =
	return
If Caller <> Edit
	TimesX := 1
Details = %WinMsg%, %wParam%, %lParam%
Gui, 1:-Disabled
Gui, 22:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If Caller = Edit
	LV_Modify(RowNumber, "Col2", "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
Else
If RowSelection = 0
{
	LV_Add("", ListCount+1, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
	LV_MoveRow(0)
	GoSub, RowCheck
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
	}
	LV_MoveRow(0)
	GoSub, RowCheck
}
Caller = 
GuiControl, Focus, InputList
return

SendMsgCancel:
22GuiClose:
22GuiEscape:
Gui, 1:-Disabled
Gui, 22:Destroy
Caller = 
return

Start:
Gui +OwnDialogs
Gui, Submit, NoHide
If ((AutoKey = "") && (ManKey = ""))
{
	MsgBox, 16, %Lang048%, %Lang131%
	return
}
If Win1 = 1
	AutoKey = #%AutoKey%
;If Win2 = 1
;	ManKey = #%ManKey%
If Win3 = 1
	AbortKey = #%AbortKey%
If AutoKey <>
	Hotkey, %AutoKey%, f_AutoKey, On
If ManKey <>
	Hotkey, %ManKey%, f_ManKey, On
If AbortKey <>
	Hotkey, %AbortKey%, f_AbortKey, On
Stop = 0
Tooltip
WinMinimize, ahk_id %WindowID%
SetTimer, WinCheck, 100
If ShowStep = 1
	Traytip, Pulover's Macro Creator, %AutoKey% %Lang158%.
return

Capt:
GuiControl, Focus, InputList
Goto, MainLoop
return

InputList:
If ((A_GuiEvent = "I") || (A_GuiEvent = "Normal") || (A_GuiEvent = "A") || (A_GuiEvent = "C") || (A_GuiEvent = "K") || (A_GuiEvent = "F") || (A_GuiEvent = "f"))
{
	Gui, 13:Submit, NoHide
	If AutoRefresh = 1
		GoSub, PrevRefresh
}
If A_GuiEvent = F
{
	Input
	GoSub, DelKey
}
If A_GuiEvent = RightClick
{
	RowNumber = 0
	RowSelection := LV_GetCount("Selected")
	RowNumber := LV_GetNext(RowNumber - 1)
}
If A_GuiEvent <> DoubleClick
	return
RowNumber := LV_GetNext(RowNumber - 1)
If not RowNumber
	return
GoSub, DelKey
GoSub, Edit
return

GuiContextMenu:
If A_GuiControl <> InputList
	return
Menu, EditMenu, Show, %A_GuiX%, %A_GuiY%
return

Duplicate:
If RowSelection = 1
{
	LV_GetText(Action, RowNumber, 2)
	LV_GetText(Details, RowNumber, 3)
	LV_GetText(TimesX, RowNumber, 4)
	LV_GetText(DelayX, RowNumber, 5)
	LV_GetText(Type, RowNumber, 6)
	LV_GetText(Target, RowNumber, 7)
	LV_GetText(Window, RowNumber, 8)
	LV_Insert(RowNumber, "", RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window)
	GoSub, b_Start
	LV_Modify(RowNumber, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_GetText(Action, RowNumber, 2)
		LV_GetText(Details, RowNumber, 3)
		LV_GetText(TimesX, RowNumber, 4)
		LV_GetText(DelayX, RowNumber, 5)
		LV_GetText(Type, RowNumber, 6)
		LV_GetText(Target, RowNumber, 7)
		LV_GetText(Window, RowNumber, 8)
		LV_Insert(RowNumber+RowSelection, "", RowNumber+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	}
	Loop, %RowSelection%
	{
		LV_MoveRow(0)
	}
	GoSub, b_Start
	LV_Modify(RowNumber, "Vis")
}
GoSub, RowCheck
GuiControl, Focus, InputList
return

MoveUp:
LV_MoveRow(1)
GoSub, RowCheck
return

MoveDn:
LV_MoveRow(0)
GoSub, RowCheck
return

;###########################################################
; Original by diebagger (Guest) from:
; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
; Slightly Modifyed by Obi-Wahn
; http://l.autohotkey.net/forum/topic60898.html
;###########################################################
Order:
If Order = 1
	LV_MoveRow()
If Order = 0
	LV_MoveRow(false)

LV_MoveRow(moveup = true)
{
	If moveup not in 1,0
		Return
	while x := LV_GetNext(x)
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	Loop, %i%
	{
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		Loop, %cc%
		{
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}
GoSub, RowCheck
return
;##################################################

Remove:
Gui, Submit, NoHide
Gui +OwnDialogs
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	MsgBox, 1, %Lang132%, %Lang133%
	IfMsgBox, OK
		LV_Delete()
	IfMsgBox, Cancel
		return
	GoSub, b_Start
	GuiControl, Focus, InputList
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber - 1)
		If not RowNumber
			break
		LV_Delete(RowNumber)
		GoSub, RowCheck
	}
	GoSub, b_Start
	GuiControl, Focus, InputList
}
return

ApplyT:
Gui, Submit, NoHide
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col4", TimesG)
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Modify(RowNumber, "Col4", TimesG)
	}
}
return

ApplyI:
Gui, Submit, NoHide
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col5", DelayG)
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Modify(RowNumber, "Col5", DelayG)
	}
}
return

ApplyL:
Gui, Submit, NoHide
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
sKey := ""
If sInput = 
	return
tKey = %sInput%
If sKey =
	sKey = %tKey%
Else
	sKey = %sKey%
KeyDown =
GoSub, Replace
GoSub, ReplaceHold
sKey = {%sKey%}
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, tKey, sKey, 1, DelayG, Type1)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, tKey, sKey, 1, DelayG, Type1)
	}
}
LV_MoveRow(0)
GoSub, RowCheck
return

EditButton:
Gui, Submit, NoHide
RowSelection := LV_GetCount("Selected")
RowNumber := LV_GetNext(RowNumber - 1)
If RowSelection = 1
{
	If not RowNumber
		return
	GoSub, Edit
}
If RowSelection = 0
	GoSub, MultiEdit
If RowSelection > 1
	GoSub, MultiEdit
return

Edit:
LV_GetText(Action, RowNumber, 2)
LV_GetText(Details, RowNumber, 3)
LV_GetText(TimesX, RowNumber, 4)
LV_GetText(DelayX, RowNumber, 5)
LV_GetText(Type, RowNumber, 6)
LV_GetText(Target, RowNumber, 7)
LV_GetText(Window, RowNumber, 8)
If ((Type = Type15) || (Type = Type16))
	Goto, EditImage
If Type = %Type17%
{
	If ((Details = "EndIf") || (Details = "Else"))
		return
	Else
		Goto, EditSt
}
If ((Type = Type18) || (Type = Type19))
	Goto, EditMsg
If Action contains %Action1%,%Action2%,%Action3%,%Action4%,%Action5%,%Action6%
	Goto, EditMouse
If Action = [Text]
	Goto, EditText
If Action = [Run]
	Goto, EditRun
If InStr(Action, "Win")
	Goto, EditWindow
Gui, 2:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 2:Add, GroupBox, vSGroup Section xm W230 H120 Disabled
Gui, 2:Add, Checkbox, Section ys+15 xs+10 vCSend gCSend Hidden, %Lang084%:
Gui, 2:Add, Edit, vDefCt W150 Disabled Hidden
Gui, 2:Add, Button, yp-1 xp+150 W60 H22 vGetCtrl gGetCtrl Disabled Hidden, %Lang076%
Gui, 2:Add, DropdownList, Section xs W65 vIdent Disabled Hidden, Title||Class|Process|ID
Gui, 2:Add, Edit, xs+2 W150 vTitle Disabled Hidden, A
Gui, 2:Add, Button, yp xp+150 W60 H22 vGetWin gGetWin Disabled Hidden, %Lang076%
Gui, 2:Add, Checkbox, Section ym+15 xs vMP gMP Hidden, %Lang118%:
Gui, 2:Add, Edit, vMsgPt W210 r4 Multi Disabled Hidden
Gui, 2:Add, Text, Section ys xs vKWT Hidden, %Lang218%
Gui, 2:Add, Hotkey, vWaitKeys gWaitKeys W210 Hidden
Gui, 2:Add, Text, vTimoutT Hidden, %Lang219%:
Gui, 2:Add, Edit, yp-2 xs+90 Limit Number W120 vTimeoutC Hidden
Gui, 2:Add, UpDown, vTimeout 0x80 Range0-999999 Hidden, 0
Gui, 2:Add, Text, xs+90 vWTT Hidden, %Lang220%
Gui, 2:Add, GroupBox, Section xm W230 H110
Gui, 2:Add, Text, Section ys+15 xs+10, %Lang030%:
Gui, 2:Add, Text,, %Lang085%:
Gui, 2:Add, Edit, Limit Number W120 H20 ys vEdRept
Gui, 2:Add, UpDown, vTimesX 0x80 Range1-999999, %TimesX%
Gui, 2:Add, Edit, Limit Number W120 vDelayC
Gui, 2:Add, UpDown, vDelayX 0x80 Range0-999999, %DelayX%
Gui, 2:Add, Radio, Section yp+25 xm+10 Checked gMsc vMsc, %Lang086%
Gui, 2:Add, Radio, gSec vSec, %Lang087%
Gui, 2:Add, Button, Section Default xm W60 H22 gEditOK, %Lang059%
Gui, 2:Add, Button, ys W60 H22 gEditCancel, %Lang060%
If ((Type = Type1) || (Type = Type2) || (Type = Type3) || (Type = Type4) || (Type = Type8) || (Type = Type9) || (Type = Type13))
{
	GuiControl, 2:Show, CSend
	GuiControl, 2:Show, DefCt
	GuiControl, 2:Show, GetCtrl
	GuiControl, 2:Show, Ident
	GuiControl, 2:Show, Title
	GuiControl, 2:Show, GetWin
	If Target <> ""
		GuiControl, 2:, DefCt, %Target%
	If Action contains %Action2%,%Action3%,%Action4%
		GuiControl, 2:Disable, CSend
	If InStr(Type, "Control")
	{
		GuiControl, 2:, CSend, 1
		GuiControl, 2:Enable, DefCt
		GuiControl, 2:Enable, GetCtrl
		GuiControl, 2:Enable, Ident
		GuiControl, 2:, Title, %Window%
		GuiControl, 2:Enable, Title
		GuiControl, 2:Enable, GetWin
	}
}
Else
{
	If Type = %Type5%
	{
		GuiControl, 2:Show, MP
		GuiControl, 2:Show, MsgPt
	}
	If Type = %Type6%
	{
		StringReplace, Details, Details, ``n, `n, All
		GuiControl, 2:Show, MP
		GuiControl, 2:Show, MsgPt
		GuiControl, 2:, MP, 1
		GuiControl, 2:Enable, MsgPt
		GuiControl, 2:, MsgPt, %Details%
		GuiControl, 2:Disable, DelayC
		GuiControl, 2:Disable, EdRept
		GuiControl, 2:Disable, DelayX
		GuiControl, 2:Disable, Msc
		GuiControl, 2:Disable, Sec
	}
	If Type = %Type20%
	{
		GuiA := 2
		GuiControl, 2:Show, WaitKeys
		GuiControl, 2:Show, TimoutT
		GuiControl, 2:Show, TimeoutC
		GuiControl, 2:Show, Timeout
		GuiControl, 2:Show, KWT
		GuiControl, 2:Show, WTT
		GuiControl, 2:Disable, DelayC
		GuiControl, 2:Disable, EdRept
		GuiControl, 2:Disable, DelayX
		GuiControl, 2:Disable, Msc
		GuiControl, 2:Disable, Sec
		GuiControl, 2:, WaitKeys, %Details%
		GuiControl, 2:, Timeout, %DelayX%
	}
}
Gui, 2:Show,, %Lang036%
GoSub, DelKey
If Window = 
	Window = A
Input
return

CSend:
Gui, Submit, NoHide
GuiControl, Enable%CSend%, DefCt
GuiControl, Enable%CSend%, GetCtrl
GuiControl, Enable%CSend%, SetWin
GuiControl, Enable%CSend%, MRel
GuiControl,, MRel, %CSend%
GuiControl, Enable%CSend%, IniX
GuiControl, Enable%CSend%, IniY
GuiControl, Enable%CSend%, MouseGetI
GuiControl, Enable%CSend%, Ident
GuiControl, Enable%CSend%, Title
GuiControl, Enable%CSend%, GetWin
return

EditOK:
Gui +OwnDialogs
Gui, Submit, NoHide
If Msc = 1
	DelayX = %DelayX%
If Sec = 1
	DelayX := DelayX * 1000
If TimesX = 0
	TimesX := 1
Window = %Title%
If ((Type = Type5) || (Type = Type6))
{
	If MP = 1
	{
		Type := Type6
		Details = %MsgPT%
	}
	Else
	{
		Type := Type5
		Details := ""
	}
}
If Type = %Type20%
{
	If WaitKeys =
		return
	tKey = %WaitKeys%
	GoSub, Replace
	Details = %tKey%
	DelayX = %Timeout%
}
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 16, %Lang088%, %Lang052%
		return
	}
	Else
	{
		Target = %DefCt%
		If Type = %Type1%
			Type = %Type2%
		If Type = %Type3%
			Type = %Type4%
		If Type = %Type8%
			Type = %Type9%
	}
}
If CSend = 0
{
	Target := ""
	Window := ""
	If Type = %Type2%
		Type = %Type1%
	If Type = %Type4%
		Type = %Type3%
	If Type = %Type9%
		Type = %Type8%
}
GuiA := 1
Gui, 1:-Disabled
Gui, 2:Destroy
Gui, 1:Default
LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type, Target, Window)
GuiControl, Focus, InputList
return

EditCancel:
2GuiClose:
2GuiEscape:
GuiA := 1
Gui, 1:-Disabled
Gui, 2:Destroy
return

MultiEdit:
Gui, 6:+owner1 +ToolWindow
Gui, 1:Default
Gui +Disabled
Gui, 6:Add, GroupBox, vSGroup Section xm W230 H65
Gui, 6:Add, Checkbox, Section ys+15 xs+10 vCSend gCSend, %Lang084%:
Gui, 6:Add, Edit, vDefCt W150 Disabled
Gui, 6:Add, Button, yp-1 xp+150 W60 H22 vGetCtrl gGetCtrl Disabled, %Lang076%
Gui, 6:Add, DropdownList, Section xs W65 vIdent Disabled, Title||Class|Process|ID
Gui, 6:Add, Edit, xs+2 W150 vTitle Disabled, A
Gui, 6:Add, Button, yp xp+150 W60 H22 vGetWin gGetWin Disabled, %Lang076%
Gui, 6:Add, Button, Section Default xm W60 H22 gMultiOK, %Lang059%
Gui, 6:Add, Button, ys W60 H22 gMultiCancel, %Lang060%
Gui, 6:Show,, %Lang036%
GoSub, DelKey
Window := "A"
Input
return

MultiOK:
Gui +OwnDialogs
Gui, Submit, NoHide
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 16, %Lang088%, %Lang052%
		return
	}
	Else
	{
		Target = %DefCt%
		Window = %Title%
	}
}
If CSend = 0
{
	Target := ""
	Window := ""
}
Gui, 1:-Disabled
Gui, 6:Destroy
Gui, 1:Default
If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber = %A_Index%
		If RowNumber > %ListCount%
			break
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = Type1) || (Type = Type2) || (Type = Type3) || (Type = Type4) || (Type = Type8) || (Type = Type9))
		{
			If CSend = 1
			{
				If Type = %Type1%
					Type = %Type2%
				If Type = %Type3%
					Type = %Type4%
				If Type = %Type8%
					Type = %Type9%
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			If CSend = 0
			{
				If Type = %Type2%
					Type = %Type1%
				If Type = %Type4%
					Type = %Type3%
				If Type = %Type9%
					Type = %Type8%
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else
			continue
	}
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = Type1) || (Type = Type2) || (Type = Type3) || (Type = Type4) || (Type = Type8) || (Type = Type9))
		{
			If CSend = 1
			{
				If Type = %Type1%
					Type = %Type2%
				If Type = %Type3%
					Type = %Type4%
				If Type = %Type8%
					Type = %Type9%
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			If CSend = 0
			{
				If Type = %Type2%
					Type = %Type1%
				If Type = %Type4%
					Type = %Type3%
				If Type = %Type9%
					Type = %Type8%
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else
			continue
	}
}
GuiControl, Focus, InputList
return

MultiCancel:
6GuiClose:
6GuiEscape:
Gui, 1:-Disabled
Gui, 6:Destroy
return

Msc:
{
	Gui, Submit, NoHide
	DelayX := DelayX * 1000
	GuiControl,,DelayX, %DelayX%
}
return

Sec:
{
	Gui, Submit, NoHide
	DelayX := DelayX / 1000
	GuiControl,,DelayX, %DelayX%
}
return

SetWin:
Gui 2:+LastFoundExist
IfWinExist
	PW = 2
Gui 5:+LastFoundExist
IfWinExist
	PW = 5
Gui 6:+LastFoundExist
IfWinExist
	PW = 6
Gui 8:+LastFoundExist
IfWinExist
	PW = 8
Gui, 16:+owner1 +ToolWindow
Gui, %PW%:Default
Gui %PW%:+Disabled
Gui, 16:Add, DropdownList, Section xm W65 vIdent, Title||Class|Process|ID
Gui, 16:Add, Edit, ys xp+70 W150 vTitle, A
Gui, 16:Add, Button, Section Default yp+30 xm W60 H22 gSWinOK, %Lang059%
Gui, 16:Add, Button, ys W60 H22 gSWinCancel, %Lang060%
Gui, 16:Add, Button, ys W60 H22 vGetWin gGetWin, %Lang076%
Gui, 16:Show,, %Lang067%
GoSub, DelKey
If Window <> 
	GuiControl, 16:, Title, %Window%
return

SWinOK:
Gui, Submit, NoHide
Window = %Title%
Gui, %PW%:-Disabled
Gui, 16:Destroy
return

SWinCancel:
16GuiClose:
16GuiEscape:
Gui, %PW%:-Disabled
Gui, 16:Destroy
return

EditComm:
RowSelection := LV_GetCount("Selected")
Gui, 17:+owner1 +ToolWindow
Gui, 1:Default
Gui 1:+Disabled
Gui, 17:Add, GroupBox, Section xm W230 H110, %Lang146%:
Gui, 17:Add, Edit, ys+25 xs+10 vComm W210 r5
Gui, 17:Add, Button, Section Default xm W60 H22 gCommOK, %Lang059%
Gui, 17:Add, Button, ys W60 H22 gCommCancel, %Lang060%
If RowSelection = 1
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If not RowNumber
		return
	LV_GetText(Comment, RowNumber, 9)
	StringReplace, Comment, Comment, ``n, `n, All
	GuiControl, 17:, Comm, %Comment%
}
Gui, 17:Show,, %Lang145%
GoSub, DelKey
return

CommOK:
Gui, Submit, NoHide
StringReplace, Comm, Comm, `n, ``n, All
Comment = %Comm%
Gui, 1:-Disabled
Gui, 17:Destroy
Gui, 1:Default
If RowSelection = 1
	LV_Modify(RowNumber, "Col9", Comment)
If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber = %A_Index%
		If RowNumber > %ListCount%
			break
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
GuiControl, Focus, InputList
return

CommCancel:
17GuiClose:
17GuiEscape:
Gui, 1:-Disabled
Gui, 17:Destroy
return

FindReplace:
Input
Gui 18:+LastFoundExist
IfWinExist
    GoSub, FindClose
Gui, 18:+owner1 +ToolWindow
Gui, 1:Default
Gui, 18:Add, GroupBox, Section xm W280 H130, %Lang174%:
Gui, 18:Add, Edit, ys+25 xs+10 vFind W260 r5
Gui, 18:Add, Text, yp+76 xs+10 W180 vFound
Gui, 18:Add, Button, Default yp xs+210 W60 H22 gFindOK, %Lang174%
Gui, 18:Add, GroupBox, Section xm W280 H130, %Lang175%:
Gui, 18:Add, Edit, ys+25 xs+10 vReplace W260 r5
Gui, 18:Add, Text, yp+76 xs+10 W180 vReplaced
Gui, 18:Add, Button, yp xs+210 W60 H22 gReplaceOK, %Lang175%
Gui, 18:Add, Button, Section xm W60 H22 gFindClose, %Lang047%
Gui, 18:Show,, %Lang173%
GoSub, DelKey
return

FindOK:
Gui, Submit, NoHide
If Find = 
	return
Gui, 1:Default
LV_Modify(0, "-Select")
Loop
{
	RowNumber := A_Index
	If RowNumber > %ListCount%
		break
	LV_GetText(Details, RowNumber, 3)
	If InStr(Details, Find)
		LV_Modify(RowNumber, "Select")
}
RowSelection := LV_GetCount("Selected")
GuiControl, 18:, Found, %Lang177%: %RowSelection%
GuiControl, Focus, InputList
return

ReplaceOK:
Gui, Submit, NoHide
If Find = 
	return
Gui, 1:Default
Replaces = 0
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	Loop
	{
		RowNumber := A_Index
		If RowNumber > %ListCount%
			break
		LV_GetText(Details, RowNumber, 3)
		If InStr(Details, Find)
		{
			StringReplace, Details, Details, %Find%, %Replace%, All
			LV_Modify(RowNumber, "Col3", Details)
			Replaces += 1
		}
	}
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_GetText(Details, RowNumber, 3)
		If InStr(Details, Find)
		{
			StringReplace, Details, Details, %Find%, %Replace%, All
			LV_Modify(RowNumber, "Col3", Details)
			Replaces += 1
		}
	}
}
GuiControl, 18:, Replaced, %Lang178%: %Replaces%
GuiControl, Focus, InputList
return

FindClose:
18GuiClose:
18GuiEscape:
Gui, 18:Destroy
return

;##### Playback & Hotkeys #####

HKey:
Hotkey, %AutoKey%, f_AutoKey, Off
Hotkey, %ManKey%, f_ManKey, Off
Hotkey, %AbortKey%, f_AbortKey, Off
Hotkey, Del, h_Del, Off
Hotkey, NumpadDel, h_Numdel, Off
Hotkey, ^PgUp, MoveUp, Off
Hotkey, ^PgDn, MoveDn, Off
Hotkey, ^f, FindReplace, Off
return

f_AutoKey:
CoordMode, Mouse, Screen
MouseGetPos, CursorX, CursorY
CoordMode, Mouse, %CoordMouse%
If Record = 1
{
	GoSub, RecStop
	Sleep, 500
}
LoopStart := 0
LoopEnd := 0
IfError := 0
ThisLoop := 0
SearchResult := ""
LoopCount := 0
MouseReset := 0
Loop, %TimesG%
{
	If Stop = 1
		break
	ThisLoop++
	Loop, %ListCount%
	{
		If Stop = 1
			break
		LV_GetText(Action, A_Index, 2)
		LV_GetText(Step, A_Index, 3)
		LV_GetText(TimesX, A_Index, 4)
		LV_GetText(DelayX, A_Index, 5)
		LV_GetText(Type, A_Index, 6)
		LV_GetText(Target, A_Index, 7)
		LV_GetText(Window, A_Index, 8)
		If ((Type = Type3) OR (Type = Type13))
			MouseReset := 1
		If Type = %Type17%
		{
			If Step = EndIf
			{
				If IfError > 0
					IfError--
				Else
					IfError := 0
			}
			Else
			If Step = Else
			{
				If IfError > 0
					IfError--
				Else
					IfError++
			}
			Else
			{
				If IfError > 0
				{
					IfError++
					continue
				}
				If Action = %If1%
				{
					IfWinActive, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If2%
				{
					IfWinNotActive, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If3%
				{
					IfWinExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If4%
				{
					IfWinNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If5%
				{
					IfExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If6%
				{
					IfNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If7%
				{
					ClipContents := Clipboard
					If ClipContents = %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If8%
				{
					If ThisLoop = %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If9%
				{
					If SearchResult = 0
						IfError := 0
					Else
						IfError++
				}
				If Action = %If10%
				{
					If SearchResult <> 0
						IfError := 0
					Else
						IfError++
				}
			}
		}
		If IfError > 0
			continue
		If Type = %Type7%
		{
			If Step = LoopStart
			{
				StartPoint = %A_Index%
				LoopCount = %TimesX%
				continue
			}
			If Step = LoopEnd
			{
				EndPoint = %A_Index%
				LoopOver := LoopSection(StartPoint, EndPoint, LoopCount)
				continue
			}
		}
		If ((Type = Type15) || (Type = Type16))
		{
			StringReplace, Step, Step, `,%A_Space%, `,, All
			Loop, Parse, Step, `,
				Par%A_Index% := A_LoopField
			StringReplace, Action, Action, `,%A_Space%, `,, All
			Loop, Parse, Action, `,
				Act%A_Index% := A_LoopField
		}
		Loop, %TimesX%
		{
			If Stop = 1
				break
			If Type = %Type1%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				Send, %Step%
			}
			If Type = %Type2%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSend, %Target%, %Step%, %Window%
			}
			If Type = %Type3%
				Click, %Step%
			If Type = %Type4%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				ControlClick, %Target%, %Window%,, %Par1%, %Par2%, %Par3%
			}
			If Type = %Type5%
			{
				Sleep, %DelayX%
				continue
			}
			If Type = %Type6%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				MsgBox, 49, %Lang140%, %Step%
				IfMsgBox, OK
					continue
				IfMsgBox, Cancel
				{
					Stop = 1
					continue
				}
			}
			If Type = %Type8%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SendRaw, %Step%
			}
			If Type = %Type9%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSendRaw, %Target%, %Step%, %Window%
			}
			If Type = %Type10%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSetText, %Target%, %Step%, %Window%
			}
			If Type = %Type11%
				Run, %Step%
			If Type = %Type12%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SavedClip := ClipboardAll
				Clipboard =
				Clipboard = %Step%
				Sleep, 333
				If Target <>
					ControlSend, %Target%, ^v, %Window%
				Else
					Send, ^v
				Clipboard := SavedClip
				SavedClip =
			}
			If Type = %Type13%
				SendEvent, %Step%
			If Type = %Type14%
				RunWait, %Step%
			If ((Type = Type15) || (Type = Type16))
			{
				CoordMode, Pixel, %Window%
				If Type = %Type15%
				{
					PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
					SearchResult := ErrorLevel
				}
				Else
				If Type = %Type16%
				{
					ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
					SearchResult := ErrorLevel
				}
				TakeAction := DoAction(FoundX, FoundY, Act1, Act2, Window, SearchResult)
				If TakeAction = Continue
					TakeAction := 0
				If TakeAction = Stop
					Stop = 1
				If TakeAction = Prompt
				{
					If SearchResult = 0
						MsgBox, 49, %Lang209%, %Lang210%%FoundX%x%FoundY%.`n%Lang212%
					Else
						MsgBox, 49, %Lang209%, %Lang211%`n%Lang212%
					IfMsgBox, Cancel
						Stop = 1
				}
			}
			If Type = %Type18%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				SendMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type19%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				PostMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type20%
			{
				If DelayX = 0
				{
					KeyWait, %Step%
					KeyWait, %Step%, D
					continue
				}
				else
				{
					Delay := DelayX / 1000
					KeyWait, %Step%
					KeyWait, %Step%, D T%Delay%
					If ErrorLevel
					{
						MsgBox %Lang221%
						return
					}
					continue
				}
			}
			If Type = WinActivate
				WinActivate, %Window%
			If Type = WinActivateBottom
				WinActivateBottom, %Window%
			If Type = WinClose
				WinClose, %Window%
			If Type = WinHide
				WinHide, %Window%
			If Type = WinKill
				WinKill, %Window%
			If Type = WinMaximize
				WinMaximize, %Window%
			If Type = WinMinimize
				WinMinimize, %Window%
			If Type = WinMinimizeAll
				WinMinimizeAll, %Window%
			If Type = WinMinimizeAllUndo
				WinMinimizeAllUndo, %Window%
			If Type = WinMove
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinMove, %Window%,, %Par1%, %Par2%, %Par3%, %Par4%
			}
			If Type = WinRestore
				WinRestore, %Window%
			If Type = WinSet
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinSet, %Par1%, %Par2%, %Window%
			}
			If Type = WinShow
				WinShow, %Window%
			If Type = WinWait
				WinWait, %Window%
			If Type = WinWaitActive
				WinWaitActive, %Window%
			If Type = WinWaitNotActive
				WinWaitNotActive, %Window%
			If Type = WinWaitClose
				WinWaitClose, %Window%
			If GetKeyState(Slow, "P")
			{
				If ShowStep = 1
					Tooltip, 1/%SpeedDn%x
				Sleep, (DelayX*SpeedDn)
				Tooltip
			}
			Else
			If GetKeyState(Fast, "P")
			{
				If ShowStep = 1
					Tooltip, %SpeedUp%x
				Sleep, (DelayX/SpeedUp)
				Tooltip
			}
			Else
				Sleep, %DelayX%
		}
	}
}
If ((MouseReturn = 1) && (MouseReset = 1))
{
	CoordMode, Mouse, Screen
	Click, %CursorX%, %CursorY%, 0
	CoordMode, Mouse, %CoordMouse%
}
return

f_ManKey:
CoordMode, Mouse, %CoordMouse%
If Record = 1
	GoSub, RecStop
IfError := 0
SearchResult := ""
	Loop, %ListCount%
	{
		If Stop = 1
			break
		LV_GetText(Action, A_Index, 2)
		LV_GetText(Step, A_Index, 3)
		LV_GetText(TimesX, A_Index, 4)
		LV_GetText(DelayX, A_Index, 5)
		LV_GetText(Type, A_Index, 6)
		LV_GetText(Target, A_Index, 7)
		LV_GetText(Window, A_Index, 8)
		If ShowStep = 1
		{
			LV_GetText(NStep, A_Index+1, 3)
			LV_GetText(NTimesX, A_Index+1, 4)
			LV_GetText(NType, A_Index+1, 6)
			LV_GetText(NTarget, A_Index+1, 7)
			LV_GetText(NWindow, A_Index+1, 8)
			NextStep := A_Index + 1
			If A_Index = %ListCount%
			{
				LV_GetText(NStep, 1, 3)
				LV_GetText(NTimesX, 1, 4)
				LV_GetText(NType, 1, 6)
				LV_GetText(NTarget, 1, 7)
				LV_GetText(NWindow, 1, 8)
				NextStep := 1
			}
			ToolTip, %Lang135%: %NextStep%`n%NType%`, %NTarget%`, %NStep%`, %NTimesX%`, %NWindow%`n`n%Lang136%: %A_Index%`n%Type%`, %Target%`, %Step%`, %TimesX%`, %Window%
		}
		If Type = %Type17%
		{
			If Step = EndIf
			{
				If IfError > 0
					IfError--
				Else
					IfError := 0
			}
			Else
			If Step = Else
			{
				If IfError > 0
					IfError--
				Else
					IfError++
			}
			Else
			{
				If IfError > 0
				{
					IfError++
					continue
				}
				If Action = %If1%
				{
					IfWinActive, %Step%
						msgbox IfError := 0
					Else
						IfError++
				}
				If Action = %If2%
				{
					IfWinNotActive, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If3%
				{
					IfWinExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If4%
				{
					IfWinNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If5%
				{
					IfExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If6%
				{
					IfNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If7%
				{
					ClipContents := Clipboard
					If ClipContents = %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If9%
				{
					If SearchResult = 0
						IfError := 0
					Else
						IfError++
				}
				If Action = %If10%
				{
					If SearchResult <> 0
						IfError := 0
					Else
						IfError++
				}
			}
		}
		If IfError > 0
			continue
		If Type = %Type5%
			continue
		If Type = %Type7%
			continue
		If ((Type = Type15) || (Type = Type16))
		{
			StringReplace, Step, Step, `,%A_Space%, `,, All
			Loop, Parse, Step, `,
				Par%A_Index% := A_LoopField
			StringReplace, Action, Action, `,%A_Space%, `,, All
			Loop, Parse, Action, `,
				Act%A_Index% := A_LoopField
		}
		Loop, %TimesX%
		{
			If Stop = 1
				break
			If Type = %Type1%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				Send, %Step%
			}
			If Type = %Type2%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSend, %Target%, %Step%, %Window%
			}
			If Type = %Type3%
			{
				Click, %Step%
			}
			If Type = %Type4%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				ControlClick, %Target%, %Window%,, %Par1%, %Par2%, %Par3%
			}
			If Type = %Type6%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				MsgBox, 49, %Lang140%, %Step%
				IfMsgBox, OK
					continue
				IfMsgBox, Cancel
					break
			}
			If Type = %Type8%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SendRaw, %Step%
			}
			If Type = %Type9%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSendRaw, %Target%, %Step%, %Window%
			}
			If Type = %Type10%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSetText, %Target%, %Step%, %Window%
			}
			If Type = %Type11%
				Run, %Step%
			If Type = %Type12%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SavedClip := ClipboardAll
				Clipboard =
				Clipboard = %Step%
				Sleep, 333
				If Target <>
					ControlSend, %Target%, ^v, %Window%
				Else
					Send, ^v
				Clipboard := SavedClip
				SavedClip =
			}
			If Type = %Type13%
				SendEvent, %Step%
			If Type = %Type14%
				RunWait, %Step%
			If ((Type = Type15) || (Type = Type16))
			{
				CoordMode, Pixel, %Window%
				If Type = %Type15%
				{
					PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
					SearchResult := ErrorLevel
				}
				Else
				If Type = %Type16%
				{
					ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
					SearchResult := ErrorLevel
				}
				TakeAction := DoAction(FoundX, FoundY, Act1, Act2, Window, SearchResult)
				If TakeAction = Continue
					TakeAction := 0
				If TakeAction = Stop
					Stop = 1
				If TakeAction = Prompt
				{
					If SearchResult = 0
						MsgBox, 49, %Lang209%, %Lang210%%FoundX%x%FoundY%.`n%Lang212%
					Else
						MsgBox, 49, %Lang209%, %Lang211%`n%Lang212%
					IfMsgBox, Cancel
						Stop = 1
				}
			}
			If Type = %Type18%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				SendMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type19%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				PostMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type20%
			{
				If DelayX = 0
				{
					KeyWait, %Step%
					KeyWait, %Step%, D
					continue
				}
				else
				{
					Delay := DelayX / 1000
					KeyWait, %Step%
					KeyWait, %Step%, D T%Delay%
					If ErrorLevel
					{
						MsgBox %Lang221%
						return
					}
					continue
				}
			}
			If Type = WinActivate
				WinActivate, %Window%
			If Type = WinActivateBottom
				WinActivateBottom, %Window%
			If Type = WinClose
				WinClose, %Window%
			If Type = WinHide
				WinHide, %Window%
			If Type = WinKill
				WinKill, %Window%
			If Type = WinMaximize
				WinMaximize, %Window%
			If Type = WinMinimize
				WinMinimize, %Window%
			If Type = WinMinimizeAll
				WinMinimizeAll, %Window%
			If Type = WinMinimizeAllUndo
				WinMinimizeAllUndo, %Window%
			If Type = WinMove
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinMove, %Window%,, %Par1%, %Par2%, %Par3%, %Par4%
			}
			If Type = WinRestore
				WinRestore, %Window%
			If Type = WinSet
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinSet, %Par1%, %Par2%, %Window%
			}
			If Type = WinShow
				WinShow, %Window%
			If Type = WinWait
				WinWait, %Window%
			If Type = WinWaitActive
				WinWaitActive, %Window%
			If Type = WinWaitNotActive
				WinWaitNotActive, %Window%
			If Type = WinWaitClose
				WinWaitClose, %Window%
		}
		If ListCount = %A_Index% + 1
			break
		Else
			Input, Step, V, {%ManKey%}
	}
return

f_AbortKey:
Stop = 1
If AutoKey <>
	Hotkey, %AutoKey%, f_AutoKey, Off
If ManKey <>
	Hotkey, %ManKey%, f_ManKey, Off
If AbortKey <>
	Hotkey, %AbortKey%, f_AbortKey, Off
Sleep, 500
WinActivate, ahk_id %WindowID%
return

h_Del:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If not RowNumber
		break
	LV_Delete(RowNumber)
}
GoSub, RowCheck
GoSub, b_Start
return

h_NumDel:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If not RowNumber
		break
	LV_Delete(RowNumber)
	GoSub, RowCheck
	GoSub, b_Start
}
return

LoopSection(Start, End, X)
{
global
local Count
CoordMode, Mouse, %CoordMouse%
Count := End - Start - 1
ThisLoopS := 0
IfError := 0
f_Loop:
Loop, % X - 1
{
	If Stop = 1
		break
	ThisLoopS++
	Loop, %Count%
	{
		If Stop = 1
			break
		LV_GetText(Action, Start + A_Index, 2)
		LV_GetText(Step, Start + A_Index, 3)
		LV_GetText(TimesX, Start + A_Index, 4)
		LV_GetText(DelayX, Start + A_Index, 5)
		LV_GetText(Type, Start + A_Index, 6)
		LV_GetText(Target, Start + A_Index, 7)
		LV_GetText(Window, Start + A_Index, 8)
		If Type = %Type17%
		{
			If Step = EndIf
			{
				If IfError > 0
					IfError--
				Else
					IfError := 0
			}
			Else
			If Step = Else
			{
				If IfError > 0
					IfError--
				Else
					IfError++
			}
			Else
			{
				If IfError > 0
				{
					IfError++
					continue
				}
				If Action = %If1%
				{
					IfWinActive, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If2%
				{
					IfWinNotActive, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If3%
				{
					IfWinExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If4%
				{
					IfWinNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If5%
				{
					IfExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If6%
				{
					IfNotExist, %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If7%
				{
					ClipContents := Clipboard
					If ClipContents = %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If8%
				{
					If ThisLoopS = %Step%
						IfError := 0
					Else
						IfError++
				}
				If Action = %If9%
				{
					If SearchResult = 0
						IfError := 0
					Else
						IfError++
				}
				If Action = %If10%
				{
					If SearchResult <> 0
						IfError := 0
					Else
						IfError++
				}
			}
		}
		If IfError > 0
			continue
		If Type = %Type7%
			continue
		If ((Type = Type15) || (Type = Type16))
		{
			StringReplace, Step, Step, `,%A_Space%, `,, All
			Loop, Parse, Step, `,
				Par%A_Index% := A_LoopField
			StringReplace, Action, Action, `,%A_Space%, `,, All
			Loop, Parse, Action, `,
				Act%A_Index% := A_LoopField
		}
		Loop, %TimesX%
		{
			If Stop = 1
				break
			If Type = %Type1%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				Send, %Step%
			}
			If Type = %Type2%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSend, %Target%, %Step%, %Window%
			}
			If Type = %Type3%
				Click, %Step%
			If Type = %Type4%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				ControlClick, %Target%, %Window%,, %Par1%,, %Par3%
			}
			If Type = %Type5%
			{
				Sleep, %DelayX%
				continue
			}
			If Type = %Type6%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				MsgBox, 49, %Lang140%, %Step%
				IfMsgBox, OK
					continue
				IfMsgBox, Cancel
				{
					Stop = 1
					continue
				}
			}
			If Type = %Type8%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SendRaw, %Step%
			}
			If Type = %Type9%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSendRaw, %Target%, %Step%, %Window%
			}
			If Type = %Type10%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				ControlSetText, %Target%, %Step%, %Window%
			}
			If Type = %Type11%
				Run, %Step%
			If Type = %Type12%
			{
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				SavedClip := ClipboardAll
				Clipboard =
				Clipboard = %Step%
				Sleep, 333
				If Target <>
					ControlSend, %Target%, ^v, %Window%
				Else
					Send, ^v
				Clipboard := SavedClip
				SavedClip =
			}
			If Type = %Type13%
				SendEvent, %Step%
			If Type = %Type14%
				RunWait, %Step%
			If ((Type = Type15) || (Type = Type16))
			{
				CoordMode, Pixel, %Window%
				If Type = %Type15%
				{
					PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
					SearchResult := ErrorLevel
				}
				Else
				If Type = %Type16%
				{
					ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
					SearchResult := ErrorLevel
				}
				TakeAction := DoAction(FoundX, FoundY, Act1, Act2, Window, SearchResult)
				If TakeAction = Continue
					TakeAction := 0
				If TakeAction = Stop
					Stop = 1
				If TakeAction = Prompt
				{
					If SearchResult = 0
						MsgBox, 49, %Lang209%, %Lang210%%FoundX%x%FoundY%.`n%Lang212%
					Else
						MsgBox, 49, %Lang209%, %Lang211%`n%Lang212%
					IfMsgBox, Cancel
						Stop = 1
				}
			}
			If Type = %Type18%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				SendMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type19%
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				wMsg := % %Par1%
				PostMessage, %wMsg%, %Par2%, %Par3%, %Target%, %Window%
			}
			If Type = %Type20%
			{
				If DelayX = 0
				{
					KeyWait, %Step%
					KeyWait, %Step%, D
					continue
				}
				else
				{
					Delay := DelayX / 1000
					KeyWait, %Step%
					KeyWait, %Step%, D T%Delay%
					If ErrorLevel
					{
						MsgBox %Lang221%
						return
					}
					continue
				}
			}
			If Type = WinActivate
				WinActivate, %Window%
			If Type = WinActivateBottom
				WinActivateBottom, %Window%
			If Type = WinClose
				WinClose, %Window%
			If Type = WinHide
				WinHide, %Window%
			If Type = WinKill
				WinKill, %Window%
			If Type = WinMaximize
				WinMaximize, %Window%
			If Type = WinMinimize
				WinMinimize, %Window%
			If Type = WinMinimizeAll
				WinMinimizeAll, %Window%
			If Type = WinMinimizeAllUndo
				WinMinimizeAllUndo, %Window%
			If Type = WinMove
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinMove, %Window%,, %Par1%, %Par2%, %Par3%, %Par4%
			}
			If Type = WinRestore
				WinRestore, %Window%
			If Type = WinSet
			{
				Loop, Parse, Step, `,
					Par%A_Index% := A_LoopField
				WinSet, %Par1%, %Par2%, %Window%
			}
			If Type = WinShow
				WinShow, %Window%
			If Type = WinWait
				WinWait, %Window%
			If Type = WinWaitActive
				WinWaitActive, %Window%
			If Type = WinWaitNotActive
				WinWaitNotActive, %Window%
			If Type = WinWaitClose
				WinWaitClose, %Window%
			If GetKeyState(Slow, "P")
			{
				If ShowStep = 1
					Tooltip, 1/%SpeedDn%x
				Sleep, (DelayX*SpeedDn)
				Tooltip
			}
			Else
			If GetKeyState(Fast, "P")
			{
				If ShowStep = 1
					Tooltip, %SpeedUp%x
				Sleep, (DelayX/SpeedUp)
				Tooltip
			}
			Else
				Sleep, %DelayX%
		}
	}
}
return
}

DoAction(x, y, action1, action2, coord, error)
{
	CoordMode, Mouse, %coord%
	If Error = 0
	{
		If action1 = Move
		{
			Click, %x%, %y%, 0
			return
		}
		If InStr(action1, "Click")
		{
			Loop, Parse, action1, %A_Space%
				Act%A_Index% := A_LoopField
			Click, %x%, %y% %Act1%, 1
			return
		}
		Else
			return action1
	}
	If Error = 1
	{
		return action2
	}
	If Error = 2
	{
		return action2
	}
}

;##### Close: #####

Exit:
GuiClose:
Gui, 1:Default
Gui, Submit, NoHide
Gui +OwnDialogs
If ListCount <> 0
{
	MsgBox, 3, %Lang003%, %Lang037%`n"%CurrentFileName%" ;"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
WinGet, WinState, MinMax
If WinState = -1
	WinState = 0
ColSizes := ""
Loop % LV_GetCount("Column")
{
    SendMessage, 4125, A_Index - 1, 0, SysListView321
    ColSizes .= ErrorLevel ","
}
GoSub, WriteSettings
ExitApp
return

LoadSettings:
AutoKey := "F3"
ManKey := "F6"
AbortKey := "F8"
Win1 := 0
; Win2 := 0
Win3 := 0
RecKey := "F9"
StopKey := "F12"
RelKey := "CapsLock"
DelayG := 0
ShowStep := 1
Mouse := 1
Moves := 1
TimedI := 1
Strokes := 1
MScroll := 1
ClickDn := 1
WClass := 1
WTitle := 1
MDelay := 0
DelayM := 10
DelayW := 333
TDelay := 10
ToggleC := 0
RecKeybdCtrl := 0
RecMouseCtrl := 0
CoordMouse := "Window"
Fast := "Insert"
Slow := "Pause"
SpeedUp := 2
SpeedDn := 2
MouseReturn := 1
Ex_AutoKey := 1
Ex_AbortKey := 0
Ex_Hotstring := 0
Ex_HSOpt := ""
Ex_SQ := 0
Ex_BM := 0
Ex_SM := 1
SM := "Input"
Ex_SI := 1
SI := "Force"
Ex_ST := 1
ST := "2"
Ex_DH := 1
Ex_AF := 1
Ex_IN := 0
IN := ""
Ex_NT := 0
Ex_SC := 1
SC := -1
Ex_SW := 1
SW := 0
Ex_SK := 1
SK := -1
Ex_MD := 1
MD := -1
Ex_SB := 1
SB := -1
WinState := 0
ColSizes := "48,135,155,50,40,70,80,80,65"
DefaultMod:
VirtualKeys := 
(Join
"{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}
{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}{'}{-}{=}{´}{~}{[}{]}{;}{/}{,}{.}{\}
{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Esc}
{PrintScreen}{Pause}{Enter}{Tab}{Space}
{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}
{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}
{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}
{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadEnter}
{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}
{Browser_Search}{Browser_Favorites}{Browser_Home}{Volume_Mute}{Volume_Down}
{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}
{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}"
)
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
LV_ModifyCol(1, Col_1)	; Index
LV_ModifyCol(2, Col_2)	; Action
LV_ModifyCol(3, Col_3)	; Details
LV_ModifyCol(4, Col_4)	; Repeat
LV_ModifyCol(5, Col_5)	; Delay
LV_ModifyCol(6, Col_6)	; Type
LV_ModifyCol(7, Col_7)	; Control
LV_ModifyCol(8, Col_8)	; Window
LV_ModifyCol(9, Col_9)	; Comment
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
GuiControl, 1:, AutoKey, %AutoKey%
GuiControl, 1:, ManKey, %ManKey%
GuiControl, 1:, AbortKey, %AbortKey%
GuiControl, 1:, Win1, 0
GuiControl, 1:, Win3, 0
GuiControl, 1:, DelayG, 0
return

WriteSettings:
IniWrite, %Version%, MacroCreator.ini, Application, Version
IniWrite, %Lang%, MacroCreator.ini, Language, Lang
IniWrite, "%AutoKey%", MacroCreator.ini, HotKeys, AutoKey
IniWrite, "%ManKey%", MacroCreator.ini, HotKeys, ManKey
IniWrite, "%AbortKey%", MacroCreator.ini, HotKeys, AbortKey
IniWrite, %Win1%, MacroCreator.ini, HotKeys, Win1
; IniWrite, %Win2%, MacroCreator.ini, HotKeys, Win2
IniWrite, %Win3%, MacroCreator.ini, HotKeys, Win3
IniWrite, "%RecKey%", MacroCreator.ini, HotKeys, RecKey
IniWrite, "%StopKey%", MacroCreator.ini, HotKeys, StopKey
IniWrite, "%RelKey%", MacroCreator.ini, HotKeys, RelKey
IniWrite, %DelayG%, MacroCreator.ini, Options, DelayG
IniWrite, %ShowStep%, MacroCreator.ini, Options, ShowStep
IniWrite, %Mouse%, MacroCreator.ini, Options, Mouse
IniWrite, %Moves%, MacroCreator.ini, Options, Moves
IniWrite, %TimedI%, MacroCreator.ini, Options, TimedI
IniWrite, %Strokes%, MacroCreator.ini, Options, Strokes
IniWrite, %MScroll%, MacroCreator.ini, Options, MScroll
IniWrite, %ClickDn%, MacroCreator.ini, Options, ClickDn
IniWrite, %WClass%, MacroCreator.ini, Options, WClass
IniWrite, %WTitle%, MacroCreator.ini, Options, WTitle
IniWrite, %MDelay%, MacroCreator.ini, Options, MDelay
IniWrite, %DelayM%, MacroCreator.ini, Options, DelayM
IniWrite, %DelayW%, MacroCreator.ini, Options, DelayW
IniWrite, %TDelay%, MacroCreator.ini, Options, TDelay
IniWrite, %ToggleC%, MacroCreator.ini, Options, ToggleC
IniWrite, %RecKeybdCtrl%, MacroCreator.ini, Options, RecKeybdCtrl
IniWrite, %RecMouseCtrl%, MacroCreator.ini, Options, RecMouseCtrl
IniWrite, %CoordMouse%, MacroCreator.ini, Options, CoordMouse
IniWrite, %Fast%, MacroCreator.ini, Options, Fast
IniWrite, %Slow%, MacroCreator.ini, Options, Slow
IniWrite, %SpeedUp%, MacroCreator.ini, Options, SpeedUp
IniWrite, %SpeedDn%, MacroCreator.ini, Options, SpeedDn
IniWrite, %MouseReturn%, MacroCreator.ini, Options, MouseReturn
IniWrite, %VirtualKeys%, MacroCreator.ini, Options, VirtualKeys
IniWrite, %Ex_AutoKey%, MacroCreator.ini, ExportOptions, Ex_AutoKey
IniWrite, %Ex_AbortKey%, MacroCreator.ini, ExportOptions, Ex_AbortKey
IniWrite, %Ex_Hotstring%, MacroCreator.ini, ExportOptions, Ex_Hotstring
IniWrite, %Ex_HSOpt%, MacroCreator.ini, ExportOptions, Ex_HSOpt
IniWrite, %Ex_SQ%, MacroCreator.ini, ExportOptions, Ex_SQ
IniWrite, %Ex_BM%, MacroCreator.ini, ExportOptions, Ex_BM
IniWrite, %Ex_SM%, MacroCreator.ini, ExportOptions, Ex_SM
IniWrite, "%SM%", MacroCreator.ini, ExportOptions, SM
IniWrite, %Ex_SI%, MacroCreator.ini, ExportOptions, Ex_SI
IniWrite, "%SI%", MacroCreator.ini, ExportOptions, SI
IniWrite, %Ex_ST%, MacroCreator.ini, ExportOptions, Ex_ST
IniWrite, "%ST%", MacroCreator.ini, ExportOptions, ST
IniWrite, %Ex_DH%, MacroCreator.ini, ExportOptions, Ex_DH
IniWrite, %Ex_AF%, MacroCreator.ini, ExportOptions, Ex_AF
IniWrite, %Ex_IN%, MacroCreator.ini, ExportOptions, Ex_IN
IniWrite, "%IN%", MacroCreator.ini, ExportOptions, IN
IniWrite, %Ex_NT%, MacroCreator.ini, ExportOptions, Ex_NT
IniWrite, %Ex_SC%, MacroCreator.ini, ExportOptions, Ex_SC
IniWrite, %SC%, MacroCreator.ini, ExportOptions, SC
IniWrite, %Ex_SW%, MacroCreator.ini, ExportOptions, Ex_SW
IniWrite, %SW%, MacroCreator.ini, ExportOptions, SW
IniWrite, %Ex_SK%, MacroCreator.ini, ExportOptions, Ex_SK
IniWrite, %SK%, MacroCreator.ini, ExportOptions, SK
IniWrite, %Ex_MD%, MacroCreator.ini, ExportOptions, Ex_MD
IniWrite, %MD%, MacroCreator.ini, ExportOptions, MD
IniWrite, %Ex_SB%, MacroCreator.ini, ExportOptions, Ex_SB
IniWrite, %SB%, MacroCreator.ini, ExportOptions, SB
IniWrite, %WinState%, MacroCreator.ini, WindowOptions, WinState
IniWrite, %ColSizes%, MacroCreator.ini, WindowOptions, ColSizes
return

;###########################################################
; Original by jaco0646
; http://l.autohotkey.net/forum/topic51428.html
;###########################################################

#If ctrl := HotkeyCtrlHasFocus()
*AppsKey::
*BackSpace::
*Delete::
*Enter::
*Escape::
*Pause::
*PrintScreen::
*Space::
*Tab::
modifier := ""
If (GuiA <> 2) && (GuiA <> 3)
{
If GetKeyState("Shift","P")
	modifier .= "+"
If GetKeyState("Ctrl","P")
	modifier .= "^"
If GetKeyState("Alt","P")
	modifier .= "!"
}
Gui, %GuiA%:Submit, NoHide
If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)
	GuiControl, %GuiA%:,%ctrl%
Else
	GuiControl, %GuiA%:,%ctrl%, % modifier SubStr(A_ThisHotkey,2)
return
#If

HotkeyCtrlHasFocus()
{
	global GuiA
	GuiControlGet, ctrl, %GuiA%:Focus
	If InStr(ctrl,"hotkey")
	{
		GuiControlGet, ctrl, %GuiA%:FocusV
		Return, ctrl
	}
}
;##################################################

WinKey:
KeyWait, %KeyDown%, T0.2
If ErrorLevel = 1
{
	GoSub, KeyCheck
	KeyWait, %KeyDown%
	GuiControl, Focus, InputList
}
return

; Up Keys Record:

#If LControlHold = 1
*LControl Up::
{
	LControlHold = 0
	tKey = LControl
	sKey = LControl
	KeyDown = LControl
	GoSub, InputUpKey
	return
}
#If
#If RControlHold = 1
*RControl Up::
{
	RControlHold = 0
	tKey = RControl
	sKey = RControl
	KeyDown = RControl
	GoSub, InputUpKey
	return
}
#If
#If LShiftHold = 1
*LShift Up::
{
	LShiftHold = 0
	tKey = LShift
	sKey = LShift
	KeyDown = LShift
	GoSub, InputUpKey
	return
}
#If
#If RShiftHold = 1
*RShift Up::
{
	RShiftHold = 0
	tKey = RShift
	sKey = RShift
	KeyDown = RShift
	GoSub, InputUpKey
	return
}
#If
#If LAltHold = 1
*LAlt Up::
{
	LAltHold = 0
	tKey = LAlt
	sKey = LAlt
	KeyDown = LAlt
	GoSub, InputUpKey
	return
}
#If
#If RAltHold = 1
*RAlt Up::
{
	RAltHold = 0
	tKey = RAlt
	sKey = RAlt
	KeyDown = RAlt
	GoSub, InputUpKey
	return
}
#If

InputUpKey:
GoSub, Replace
GoSub, ReplaceHold
sKey = {%sKey%}
If Record = 1
{
	If TimedI = 1
	{
		If (Interval := TimeRecord())
		{
			If Interval > %TDelay%
			GoSub, SleepInput
		}
		InputDelay = 0
	}
}
Else
{
	If Capt = 0
		return
	InputDelay = %DelayG%
}
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("", ListCount+1, tKey, sKey, 1, InputDelay, Type1)
	GoSub, b_Start
	LV_Modify(ListCount, "Vis")
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If not RowNumber
			break
		LV_Insert(RowNumber+1, "", RowNumber+1, tKey, sKey, 1, DelayG, Type1)
		GoSub, b_Start
		LV_Modify(RowNumber, "Vis")
	}
}
GoSub, RowCheck
Input
return

; ##### Subroutines: Checks #####

b_Start:
ListCount := LV_GetCount()
If ListCount = 0
	GuiControl, Disable, StartB
Else
	GuiControl, Enable, StartB
return

WinCheck:
IfWinActive, ahk_id %WindowID%
{
	Input
	ToolTip
	Record = 0
	GoSub, RecStop
	GoSub, f_AbortKey
	SetTimer, WinCheck, off
}
return

RowCheck:
ListCount := LV_GetCount()
Loop, %ListCount%
{
	LV_GetText(Type, A_Index, 6)
	LV_Modify(A_Index, "", A_Index)
	If ((Type = Type1) || (Type = Type2) || (Type = Type8) || (Type = Type9) || (Type = Type10) || (Type = Type12))
	{
		LV_Modify(A_Index, IconId1)
	}
	If ((Type = Type3) || (Type = Type4) || (Type = Type13))
	{
		LV_Modify(A_Index, IconId2)
	}
	If ((Type = Type5) || (Type = Type6) || (Type = Type20))
		LV_Modify(A_Index, IconId3)
	If (Type = Type7)
		LV_Modify(A_Index, IconId4)
	If ((Type = Type11) || (Type = Type14))
		LV_Modify(A_Index, IconId5)
	If ((Type = Type17) || (Type = Type18) || (Type = Type19))
		LV_Modify(A_Index, IconId6)
	If ((Type = Type15) || (Type = Type16))
		LV_Modify(A_Index, IconId7)
	If InStr(Type, "Win")
	{
		LV_Modify(A_Index, "Icon16")
	}
}
return

DelKey:
Gui, Submit, NoHide
If Capt = 0
{
	ControlGetFocus, Focus, ahk_id %WindowID%
	If Focus = SysListView321
	{
		Hotkey, Del, h_Del, On
		Hotkey, NumpadDel, h_Numdel, On
		Hotkey, ^PgUp, MoveUp, On
		Hotkey, ^PgDn, MoveDn, On
		Hotkey, ^f, FindReplace, On
	}
	Else
	{
		Hotkey, Del, h_Del, Off
		Hotkey, NumpadDel, h_Numdel, Off
		Hotkey, ^PgUp, MoveUp, Off
		Hotkey, ^PgDn, MoveDn, Off
		Hotkey, ^f, FindReplace, Off
	}
}
Else
{
	Hotkey, Del, h_Del, Off
	Hotkey, NumpadDel, h_Numdel, Off
	Hotkey, ^PgUp, MoveUp, Off
	Hotkey, ^PgDn, MoveDn, Off
	Hotkey, ^f, FindReplace, Off
}
return

;Size and Position:

13GuiSize:
If A_EventInfo = 1
	return

GuiWidth := A_GuiWidth
GuiHeight := A_GuiHeight

GuiControl, Move, LVPrev, % "W" GuiWidth-20 "H" GuiHeight-40
return

GuiSize:
If A_EventInfo = 1
	return

GuiWidth := A_GuiWidth
GuiHeight := A_GuiHeight

GuiControl, Move, InputList, % "W" GuiWidth-40 "H" GuiHeight-100
GuiControl, Move, Order, % "x" GuiWidth-25
GuiControl, Move, Remove, % "x" GuiWidth-25
GuiControl, Move, Repeat, % "y" GuiHeight-22
GuiControl, Move, Rept, % "y" GuiHeight-25
GuiControl, Move, TimesG, % "y" GuiHeight-25
GuiControl, Move, DelayT, % "y" GuiHeight-22
GuiControl, Move, Delay, % "y" GuiHeight-25
GuiControl, Move, DelayG, % "y" GuiHeight-25
GuiControl, Move, ApplyT, % "y" GuiHeight-26
GuiControl, Move, ApplyI, % "y" GuiHeight-26
GuiControl, Move, sInput, % "y" GuiHeight-26
GuiControl, Move, ApplyL, % "y" GuiHeight-26
GuiControl, Move, EditButton, % "y" GuiHeight-26
GuiControl, Move, CoordTip, % "y" GuiHeight-22
GuiControl, Move, Separator1, % "y" GuiHeight-22
GuiControl, Move, Separator2, % "y" GuiHeight-22
GuiControl, Move, Separator3, % "y" GuiHeight-22
GuiControl, Move, Separator4, % "y" GuiHeight-22
return

;Subroutines: Substitution

KeyCheck:
If KeyDown = LWin
{
	If LWinHold = 0
	{
		sKey = %KeyDown% Down
		LWinHold = 1
	}
	Else
	If LWinHold = 1
	{
		sKey = %KeyDown% Up
		LWinHold = 0
	}
}
If KeyDown = RWin
{
	If RWinHold = 0
	{
		sKey = %KeyDown% Down
		RWinHold = 1
	}
	Else
	If RWinHold = 1
	{
		sKey = %KeyDown% Up
		RWinHold = 0
	}
}
return

Replace:
If InStr(sKey, "_")
	StringReplace, tKey, tKey, _, %A_Space%, All
StringRight, LastCh, tKey, 1
StringLower, LastCh, LastCh
StringTrimRight, tKey, tKey, 1
tKey = %tKey%%LastCh%

If InStr(tKey, "+")
	StringReplace, sKey, tKey, +, Shift Down}{
If InStr(tKey, "^")
	StringReplace, sKey, tKey, ^, Control Down}{
If InStr(tKey, "!")
	StringReplace, sKey, tKey, !, Alt Down}{
If InStr(sKey, "+")
	StringReplace, sKey, sKey, +, Shift Down}{
If InStr(sKey, "^")
	StringReplace, sKey, sKey, ^, Control Down}{
If InStr(sKey, "!")
	StringReplace, sKey, sKey, !, Alt Down}{

If InStr(sKey, "Alt Down")
	sKey = %sKey%}{Alt Up
If InStr(sKey, "Control Down")
	sKey = %sKey%}{Control Up
If InStr(sKey, "Shift Down")
	sKey = %sKey%}{Shift Up

If tKey = 
	tKey = EndKey:%KeyDown%

StringGetPos, pos, tKey, +
If pos = 0
	StringReplace, tKey, tKey, +, Shift +%A_Space%
If InStr(tKey, "^")
	StringReplace, tKey, tKey, ^, Control +%A_Space%
If InStr(tKey, "!")
	StringReplace, tKey, tKey, !, Alt +%A_Space%

If InStr(tKey, "EndKey:")
	StringTrimLeft, tKey, tKey, 7
If InStr(tKey, "Numpad")
	StringReplace, tKey, tKey, Numpad, Num%A_Space%
return

ReplaceHold:
If sKey contains Control,Shift,Alt
{
	If %KeyDown%Hold = 1
		sKey = %sKey% Down
	Else
	If %KeyDown%Hold = 0
		sKey = %sKey% Up
}

If tKey = LControl
	tKey = Left Control
If tKey = RControl
	tKey = Right Control
If tKey = LAlt
	tKey = Left Alt
If tKey = RAlt
	tKey = Right Alt
If tKey = LShift
	tKey = Left Shift
If tKey = RShift
	tKey = Right Shift
If tKey = LWin
	tKey = Left Windows
If tKey = RWin
	tKey = Right Windows
If tKey = AppsKey
	tKey = Apps Key
If tKey = PgUp
	tKey = Page Up
If tKey = PgDn
	tKey = Page Down
If tKey = PrintScreen
	tKey = Print Screen
If tKey = CapsLock
	tKey = Caps Lock
If tKey = ScrollLock
	tKey = Scroll Lock
If tKey = NumLock
	tKey = Num Lock
If tKey = Num Dot
	tKey = Num .
If tKey = Num Div
	tKey = Num /
If tKey = Num Mult
	tKey = Num *
If tKey = Num Add
	tKey = Num +
If tKey = Num Sub
	tKey = Num -
If tKey = Num Ins
	tKey = Num Insert
If tKey = Num PgDn
	tKey = Num Page Down
If tKey = Num PgUp
	tKey = Num Page Up
If tKey = Num Del
	tKey = Num Delete
return

ChReplace:
Transform, ChA, Chr, 1
Transform, ChB, Chr, 2
Transform, ChC, Chr, 3
Transform, ChD, Chr, 4
Transform, ChE, Chr, 5
Transform, ChF, Chr, 6
Transform, ChG, Chr, 7
Transform, ChH, Chr, 8
Transform, ChI, Chr, 9
Transform, ChJ, Chr, 10
Transform, ChK, Chr, 11
Transform, ChL, Chr, 12
Transform, ChM, Chr, 13
Transform, ChN, Chr, 14
Transform, ChO, Chr, 15
Transform, ChP, Chr, 16
Transform, ChQ, Chr, 17
Transform, ChR, Chr, 18
Transform, ChS, Chr, 19
Transform, ChT, Chr, 20
Transform, ChU, Chr, 21
Transform, ChV, Chr, 22
Transform, ChW, Chr, 23
Transform, ChX, Chr, 24
Transform, ChY, Chr, 25
Transform, ChZ, Chr, 26
StringReplace, sKey, sKey, %ChA%, a
StringReplace, sKey, sKey, %ChB%, b
StringReplace, sKey, sKey, %ChC%, c
StringReplace, sKey, sKey, %ChD%, d
StringReplace, sKey, sKey, %ChE%, e
StringReplace, sKey, sKey, %ChF%, f
StringReplace, sKey, sKey, %ChG%, g
StringReplace, sKey, sKey, %ChH%, h
StringReplace, sKey, sKey, %ChI%, i
StringReplace, sKey, sKey, %ChJ%, j
StringReplace, sKey, sKey, %ChK%, k
StringReplace, sKey, sKey, %ChL%, l
StringReplace, sKey, sKey, %ChM%, m
StringReplace, sKey, sKey, %ChN%, n
StringReplace, sKey, sKey, %ChO%, o
StringReplace, sKey, sKey, %ChP%, p
StringReplace, sKey, sKey, %ChQ%, q
StringReplace, sKey, sKey, %ChR%, r
StringReplace, sKey, sKey, %ChS%, s
StringReplace, sKey, sKey, %ChT%, t
StringReplace, sKey, sKey, %ChU%, u
StringReplace, sKey, sKey, %ChV%, v
StringReplace, sKey, sKey, %ChW%, w
StringReplace, sKey, sKey, %ChX%, x
StringReplace, sKey, sKey, %ChY%, y
StringReplace, sKey, sKey, %ChZ%, z
return


;##### Languages: #####

LoadLang:
If Lang = Pt
{
Lang001 := "Novo"
Lang002 := "Abrir"
Lang003 := "Salvar"
Lang004 := "Salvar Como"
Lang005 := "Exportar para AHK"
Lang006 := "Visualizar Script"
Lang007 := "Sair"
Lang008 := "Configurações"
Lang009 := "Ajuda"
Lang010 := "Sobre"
Lang011 := "Arquivo"
Lang012 := "Opções"
Lang013 := "Idioma"
Lang014 := "Exportar"
Lang015 := "Script"
Lang016 := "Mouse"
Lang017 := "Texto"
Lang018 := "Teclas Especiais"
Lang019 := "Pausa"
Lang020 := "Executar"
Lang021 := "Loop"
Lang022 := "Auto."
Lang023 := "Man."
Lang024 := "Abort."
Lang025 := "Iniciar"
Lang026 := "Capturar Teclas"
Lang027 := "Índice"
Lang028 := "Ação"
Lang029 := "Detalhes"
Lang030 := "Repetir"
Lang031 := "Inverv. (ms)"
Lang032 := "Tipo"
Lang033 := "Controle"
Lang034 := "Aplicar"
Lang035 := "Inserir"
Lang036 := "Editar"
Lang037 := "Gostaria de salvar a macro atual?"
Lang038 := "Abrir Macro"
Lang039 := "Arquivos PMC"
Lang040 := "Salvar Macro"
Lang041 := "Não foi possível salvar/substituir o arquivo"
Lang042 := "Atalhos"
Lang043 := "Usar Hotstring"
Lang044 := "Repetir"
Lang045 := "Exportar para"
Lang046 := "Procurar"
Lang047 := "Fechar"
Lang048 := "Erro: Nenhum atalho selecionado"
Lang049 := "Selecione um atalho ou desmarque a opção."
Lang050 := "Erro: Endereço Inválido"
Lang051 := "O endereço ou nome do arquivo selecionado é inválido."
Lang052 := "Clique em 'Buscar' para selecionar o controle."
Lang053 := "Exportar Script"
Lang054 := "Script Exportado"
Lang055 := "Arquivo exportado com sucesso!"
Lang056 := "Atualizar automaticamente"
Lang057 := "Pré-Visualização"
Lang058 := "Teclas Virtuais"
Lang059 := "OK"
Lang060 := "Cancelar"
Lang061 := "Padrão"
Lang062 := "Detectar"
Lang063 := "Detectar Tecla"
Lang064 := "Adicionar"
Lang065 := "Detectar Teclas Especiais"
Lang066 := "Pressione uma tecla para detectar..."
Lang067 := "Funções de Janelas"
Lang068 := "Ação"
Lang069 := "Clicar"
Lang070 := "Move"
Lang071 := "Mover e Clicar"
Lang072 := "Arrastar e Soltar"
Lang073 := "Rolar para Cima"
Lang074 := "Rolar para Baixo"
Lang075 := "Coordenadas"
Lang076 := "Buscar"
Lang077 := "Relativo"
Lang078 := "Botão"
Lang079 := "Esquerdo"
Lang080 := "Direito"
Lang081 := "Meio"
Lang082 := "X1"
Lang083 := "X2"
Lang084 := "Em Controle"
Lang085 := "Intervalo"
Lang086 := "Milisegundos"
Lang087 := "Segundos"
Lang088 := "Erro: Campo Obrigatório"
Lang089 := "Clique em 'Buscar' para marcar a posição."
Lang090 := "- Selecione a janela.`n- Aponte para o local desejado.`n- Clique com o Botão Direito."
Lang091 := "Cor do Pixel"
Lang092 := "Janela"
Lang093 := "Atualizar"
Lang094 := "Voltar"
Lang095 := "Avançar"
Lang096 := "Atualizar"
Lang097 := "Parar"
Lang098 := "Pesquisar"
Lang099 := "Favoritos"
Lang100 := "Pág. Inicial"
Lang101 := "Mídia"
Lang102 := "Mudo"
Lang103 := "Volume +"
Lang104 := "Volume -"
Lang105 := "Reproduzir / Pausar"
Lang106 := "Voltar Faixa"7
Lang107 := "Avançar Faixa"
Lang108 := "Parar Reprodução"
Lang109 := "Email"
Lang110 := "Aplicativo 1"
Lang111 := "Aplicativo 2"
Lang112 := "Código adicionado à lista de Teclas Virtuais!"
Lang113 := "Texto Simples (Raw)"
Lang114 := "Texto com Comandos"
Lang115 := "Colar"
Lang116 := "Definir Texto"
Lang117 := "Adicionar Pausa"
Lang118 := "Exibir Mensagem"
Lang119 := "Adicionar Loop"
Lang120 := "Início"
Lang121 := "Fim"
Lang122 := "*Esta função não se aplica para Reprodução Manual."
Lang123 := "Selecionar comando"
Lang124 := "Sempre Visível"
Lang125 := "Para trás"
Lang126 := "Para Frente"
Lang127 := "Desabilitar"
Lang128 := "Habilitar"
Lang129 := "Redesenhar"
Lang130 := "Transparente"
Lang131 := "Selecione um atalho para iniciar."
Lang132 := "Limpar Lista"
Lang133 := "Apagar todos os itens?"
Lang134 := "Mostrar Info."
Lang135 := "Próximo"
Lang136 := "Anterior"
Lang137 := "Send"
Lang138 := "Click"
Lang139 := "Segurar/Soltar"
Lang140 := "Mensagem"
Lang141 := "Duplicar"
Lang142 := "Mover para Cima"
Lang143 := "Mover para Baixo"
Lang144 := "Remover"
Lang145 := "Comentário"
Lang146 := "Editar Comentário"
Lang147 := "Click's"
Lang148 := "Gravar"
Lang149 := "Teclado"
Lang150 := "Clicks do Mouse"
Lang151 := "Movimentos do Mouse"
Lang152 := "Intervalo mínimo"
Lang153 := "Configuração Padrão"
Lang154 := "Carregar Configuração Padrão?"
Lang155 := "Sem caractere final"
Lang156 := "Iniciar Gravação"
Lang157 := "Parar Gravação"
Lang158 := "para reproduzir"
Lang159 := "para iniciar gravação"
Lang160 := "para parar gravação"
Lang161 := "Gravando..."
Lang162 := "Geral"
Lang163 := "Roda do Mouse"
Lang164 := "Gravação"
Lang165 := "Intervalo Padrão do Mouse"
Lang166 := "Intervalo Padrão das Janelas"
Lang167 := "Classes das Janelas"
Lang168 := "Títulos das Janelas"
Lang169 := "Tecla de Gravação Relativa"
Lang170 := "Intervalos de Tempo"
Lang171 := "Usar Click Down/Up"
Lang172 := "Fixa"
Lang173 := "Localizar/Substituir"
Lang174 := "Localizar"
Lang175 := "Substituir"
Lang176 := "Substituir Todos"
Lang177 := "Encontrados"
Lang178 := "Substituidos"
Lang179 := "Gravar ControlSend"
Lang180 := "Gravar ControlClick"
Lang181 := "Unir"
Lang182 := "Arquivo não encontrado ou não criado com Pulover's Macro Creator."
Lang183 := "Nome"
Lang184 := "Erro: Duplicidade"
Lang185 := "Este Nome já está em uso. Por favor escolha um nome diferente para esta macro."
Lang186 := "Este Atalho já está em uso.`nPor favor escolha um Atalho diferente para esta macro."
Lang187 := "Posição"
Lang188 := "Tamanho"
Lang189 := "Reprodução"
Lang190 := "Acelerar"
Lang191 := "Reduzir"
Lang192 := "RunWait (Espera o programa terminar)"
Lang193 := "Mouse Relativo à"
Lang194 := "Janela"
Lang195 := "Tela"
Lang196 := "Passo-A-Passo"
Lang197 := "Atalho inválido"
Lang198 := "A opção 'Passo-A-Passo' não pode ser usada com Ctrl/Alt/Shift/Windows."
Lang199 := "Imagem"
Lang200 := "Declaração 'Se'"
Lang201 := "Messages do Windows (Avançado)"
Lang202 := "Pixel"
Lang203 := "Procurar Imagem"
Lang204 := "Procurar Pixel"
Lang205 := "- Clique arraste com o Botão Direito para selecionar a área."
Lang206 := "Se encontrada"
Lang207 := "Se não encontrada / Erro"
Lang208 := "Retornar Mouse`npara posição inicial após reprodução."
Lang210 := "Continuar?"
Lang209 := "Continuar?"
Lang210 := "Imagem / Pixel Encontrada em "
Lang211 := "Imagem / Pixel Não Encontrada."
Lang212 := "Pressione OK para continuar."
Lang213 := "Erro"
Lang214 := "Variações"
Lang215 := "Se"
Lang216 := "Se Não"
Lang217 := "Bloquear Mouse"
Lang218 := "Esperar por Tecla"
Lang219 := "Tempo Limite"
Lang220 := "(milisegundos) 0 = infinito"
Lang221 := "Tempo esgotado!"
Lang222 := "Documentação AHK Online"
Lang223 := "Site do Macro Creator"
Lang224 := "Condicional"

NewB_TT := Lang001
OpenB_TT := Lang002
SaveB_TT := Lang003
ExportB_TT := Lang005
PreviewB_TT := Lang006
OptionsB_TT := Lang008
MouseB_TT := Lang016
TextB_TT := Lang017
SpecialB_TT := Lang018
PauseB_TT := Lang019
WindowB_TT := Lang092
ImageB_TT := Lang203 " / " Lang204
RunB_TT := Lang020
ComLoopB_TT := Lang021
IfStB_TT := Lang200
SendMsgB_TT := Lang201

RelKey_TT := "Grava Clicks e Movivimentos relativos enquanto pressionada."
ClickDn_TT := "Útil para gravar movimentos do mouse com o botão pressionado."
Relative_TT := "Coordenadas relativas à janela ativa."
Screen_TT := "Coordenadas relativas à área de trabalho (tela inteira)."
Ex_AutoKey_TT := "Se desmarcar esta opção o`nScript irá iniciar imediatamente`napós ser executado."
Ex_HSOpt_TT := "*: An ending character is not required.`n?: The hotstring will be triggered even when it is inside another word.`nB0: Automatic backspacing is not done.`nC: Case sensitive.`nC1: Do not conform to typed case.`nKn: Key-delay: sets the delay between keystrokes.`nO: Omit the ending character.`nPn: The priority of the hotstring.`nR: Send the replacement text raw.`nSI or SP or SE [v1.0.43+]: Sets the send method.`nZ: Resets the hotstring recognizer."
Ex_IfDir_TT := "Creates context-sensitive hotkeys and hotstrings depending on the type of window that is active or exists."
Ex_IfDirType_TT := "Creates context-sensitive hotkeys and hotstrings depending on the type of window that is active or exists."
Ex_SQ_TT := "Cria uma macro sequencial: Cada comando será executado em sequencia cada vez que o atalho for pressionado."
AppName := "Pulover's Macro Creator"
HeadLine := "; This script was created using Pulover's Macro Creator"
HelpHead :=
(
"****************************************************************************************************************
 CLIQUE COM O BOTÃO DIREITO SOBRE UM BOTÃO NA JANELA PRINCIPAL OU EM
 UMA JANELA DE COMANDO PARA MOSTRAR LINKS PARA A AJUDA ONLINE DO AHK.
****************************************************************************************************************"
)
HelpTx := "Dicas:`n`n- Você também pode inserir combinações de teclas diretamente na caixa no parte de baixo e pressionar o botão Inserir.`n- Segure a tecla Windows por aproximadamente meio segundo para mantê-la pressionada.`n- O contador 'Repetir' na parte de baixo define o número de repetições da lista toda. Você também pode usá-lo para modificar as repetições de cada item.`n- Você pode editar um item clicando duas vezes em um linha da lista ou selecionando um item e clicando no botão Editar na parte de baixo.`n- Você pode editar vários itens selecionados na lista definindo um número de repetições no contador 'Repetir' e pressionando Aplicar, o mesmo para o Intervalo. E você pode editar o Controle alvo clicando no botão Editar.`n- Use as Setas para cima e para baixo do lado direito (ou Ctrl+PgUp/PgDn) para mover os itens na lista (você pode mover vários itens ao mesmo tempo).`n- Use o botão X do lado direito para deletar um ou mais itens na lista.`n- Se nenhum item estiver selecionado os botões Editar, Setas e Deletar vão ser aplicados à todos os itens da lista.`n- Desmarque a opção 'Capturar Teclas' para selecionar itens com Ctrl/Shift na lista e para usar a tecla Delete.`n`n"
}
Else
If Lang = En
{
Lang001 := "New"
Lang002 := "Open"
Lang003 := "Save"
Lang004 := "Save As"
Lang005 := "Export to AHK"
Lang006 := "Preview Script"
Lang007 := "Exit"
Lang008 := "Settings"
Lang009 := "Help"
Lang010 := "About"
Lang011 := "File"
Lang012 := "Options"
Lang013 := "Language"
Lang014 := "Export"
Lang015 := "Preview"
Lang016 := "Mouse"
Lang017 := "Text"
Lang018 := "Special Keys"
Lang019 := "Pause"
Lang020 := "Run"
Lang021 := "Loop"
Lang022 := "Auto."
Lang023 := "Man."
Lang024 := "Abort"
Lang025 := "Play"
Lang026 := "Capture Keys"
Lang027 := "Index"
Lang028 := "Action"
Lang029 := "Details"
Lang030 := "Repeat"
Lang031 := "Delay (ms)"
Lang032 := "Type"
Lang033 := "Control"
Lang034 := "Apply"
Lang035 := "Insert"
Lang036 := "Edit"
Lang037 := "Do you want to save the current macro?"
Lang038 := "Open Macro"
Lang039 := "PMC Files"
Lang040 := "Save Macro"
Lang041 := "Faild to save/overwrite file"
Lang042 := "Hotkeys"
Lang043 := "Use Hotstring"
Lang044 := "Loops"
Lang045 := "Export to"
Lang046 := "Search"
Lang047 := "Close"
Lang048 := "Error: No Hotkey Selected"
Lang049 := "Select a Hotkey or uncheck this option."
Lang050 := "Error: Invalid Address"
Lang051 := "The selected address or file name is invalid."
Lang052 := "Click 'Get' to select the control."
Lang053 := "Export Script"
Lang054 := "Script Exported"
Lang055 := "The file was succesfully exported!"
Lang056 := "Auto-Refresh"
Lang057 := "Preview"
Lang058 := "Virtual Keys"
Lang059 := "OK"
Lang060 := "Cancel"
Lang061 := "Default"
Lang062 := "Detect"
Lang063 := "Detect Key"
Lang064 := "Add"
Lang065 := "Detect Special Keys"
Lang066 := "Press a Key to detect..."
Lang067 := "Window Functions"
Lang068 := "Action"
Lang069 := "Click"
Lang070 := "Move"
Lang071 := "Move && Click"
Lang072 := "Drag && Drop"
Lang073 := "Wheel Up"
Lang074 := "Wheel Down"
Lang075 := "Coordinates"
Lang076 := "Get"
Lang077 := "Relative"
Lang078 := "Button"
Lang079 := "Left"
Lang080 := "Right"
Lang081 := "Middle"
Lang082 := "X1"
Lang083 := "X2"
Lang084 := "Control"
Lang085 := "Delay"
Lang086 := "Miliseconds"
Lang087 := "Seconds"
Lang088 := "Error: Empty Field"
Lang089 := "Click 'Get' to mark position."
Lang090 := "- Select the window.`n- Point to desired position.`n- Press the Right Button."
Lang091 := "Pixel Color"
Lang092 := "Window"
Lang093 := "Refresh"
Lang094 := "Browser Back"
Lang095 := "Browser Forward"
Lang096 := "Browser Refresh"
Lang097 := "Browser Stop"
Lang098 := "Browser Search"
Lang099 := "Browser Favorites"
Lang100 := "Browser Home"
Lang101 := "Media"
Lang102 := "Mute"
Lang103 := "Volume Up"
Lang104 := "Volume Down"
Lang105 := "Play / Pause"
Lang106 := "Next Track"
Lang107 := "Previous Track"
Lang108 := "Stop"
Lang109 := "Email"
Lang110 := "App 1"
Lang111 := "App 2"
Lang112 := "Code added to Virtual Keys List!"
Lang113 := "Plain Text (Raw)"
Lang114 := "Text with commands"
Lang115 := "Clipboard"
Lang116 := "Set Text"
Lang117 := "Add Pause"
Lang118 := "Show Prompt"
Lang119 := "Add Loop"
Lang120 := "Start"
Lang121 := "End"
Lang122 := "*This function does not apply for Manual Playback."
Lang123 := "Select command"
Lang124 := "Always On Top"
Lang125 := "Bottom"
Lang126 := "Top"
Lang127 := "Disable"
Lang128 := "Enable"
Lang129 := "Redraw"
Lang130 := "Transparent"
Lang131 := "Select a Hotkey to start."
Lang132 := "Clear List"
Lang133 := "Sure to delete all items?"
Lang134 := "Show Info"
Lang135 := "Next"
Lang136 := "Previous"
Lang137 := "Send"
Lang138 := "Click"
Lang139 := "Hold/Release"
Lang140 := "Message"
Lang141 := "Duplicate"
Lang142 := "Move Up"
Lang143 := "Move Down"
Lang144 := "Delete"
Lang145 := "Comment"
Lang146 := "Edit Comment"
Lang147 := "Click Count"
Lang148 := "Record"
Lang149 := "Keystrokes"
Lang150 := "Mouse Clicks"
Lang151 := "Mouse Moves"
Lang152 := "Minimum delay"
Lang153 := "Default Settings"
Lang154 := "Load Default Settings?"
Lang155 := "No ending character"
Lang156 := "Start Record"
Lang157 := "Stop Record"
Lang158 := "to start playback"
Lang159 := "to start recording"
Lang160 := "to stop recording"
Lang161 := "Recording..."
Lang162 := "General"
Lang163 := "Mouse Wheel"
Lang164 := "Recording"
Lang165 := "Default Mouse Delay"
Lang166 := "Default Window Delay"
Lang167 := "Window Classes"
Lang168 := "Window Titles"
Lang169 := "Relative Record Key"
Lang170 := "Timed Intervals"
Lang171 := "Use Click Down/Up"
Lang172 := "Toggle"
Lang173 := "Find/Replace"
Lang174 := "Find"
Lang175 := "Replace"
Lang176 := "Replace All"
Lang177 := "Found"
Lang178 := "Replaced"
Lang179 := "Record ControlSend"
Lang180 := "Record ControlClick"
Lang181 := "Join"
Lang182 := "File not found."
Lang183 := "Name"
Lang184 := "Error: Duplicate Hotkey"
Lang185 := "This Name is already in use.`nPlease choose a different Name for this macro."
Lang186 := "This Hotkey is already in use.`nPlease choose a differente Hotkey for this macro."
Lang187 := "Position"
Lang188 := "Size"
Lang189 := "Playback"
Lang190 := "Fast Forward"
Lang191 := "Slow Down"
Lang192 := "RunWait (Waits for program to finish)"
Lang193 := "Mouse Relative to"
Lang194 := "Window"
Lang195 := "Screen"
Lang196 := "Step-By-Step"
Lang197 := "Invalid Hotkey"
Lang198 := "The 'Steb-By-Step' option cannot be used with Ctrl/Alt/Shift/Windows."
Lang199 := "Image"
Lang200 := "'If' Statements"
Lang201 := "Windows Messages (Advanced)"
Lang202 := "Pixel"
Lang203 := "Image Search"
Lang204 := "Pixel Search"
Lang205 := "- Click and Drag with Right Button to select area."
Lang206 := "If found"
Lang207 := "If not found / Error"
Lang208 := "Return Mouse to initial position after playback."
Lang209 := "Continue?"
Lang210 := "Image / Pixel Found at "
Lang211 := "Image / Pixel Not Found."
Lang212 := "Press OK to continue."
Lang213 := "Error"
Lang214 := "Variations"
Lang215 := "If"
Lang216 := "Add Else"
Lang217 := "Block Mouse"
Lang218 := "Wait for Key"
Lang219 := "Wait Timeout"
Lang220 := "(miliseconds) 0 = infinite"
Lang221 := "Timeout!"
Lang222 := "AHK Online Documentation"
Lang223 := "Macro Creator Home"
Lang224 := "Context Sensitive"

NewB_TT := Lang001
OpenB_TT := Lang002
SaveB_TT := Lang003
ExportB_TT := Lang005
PreviewB_TT := Lang006
OptionsB_TT := Lang008
MouseB_TT := Lang016
TextB_TT := Lang017
SpecialB_TT := Lang018
PauseB_TT := Lang019
WindowB_TT := Lang092
ImageB_TT := Lang203 " / " Lang204
RunB_TT := Lang020
ComLoopB_TT := Lang021
IfStB_TT := Lang200
SendMsgB_TT := Lang201

RelKey_TT := "Records relative Movements and Clicks while pressed."
ClickDn_TT := "Useful to record mouse movements while a button is pressed."
Relative_TT := "Coordinates are relative to the active window."
Screen_TT := "Coordinates are relative to the desktop (entire screen)."
Ex_AutoKey_TT := "If this option is unchecked`nthe Script will start immediately`nafter being executed."
Ex_HSOpt_TT := "*: An ending character is not required.`n?: The hotstring will be triggered even when it is inside another word.`nB0: Automatic backspacing is not done.`nC: Case sensitive.`nC1: Do not conform to typed case.`nKn: Key-delay: sets the delay between keystrokes.`nO: Omit the ending character.`nPn: The priority of the hotstring.`nR: Send the replacement text raw.`nSI or SP or SE [v1.0.43+]: Sets the send method.`nZ: Resets the hotstring recognizer."
Ex_IfDir_TT := "Creates context-sensitive hotkeys and hotstrings depending on the type of window that is active or exists."
Ex_IfDirType_TT := "Creates context-sensitive hotkeys and hotstrings depending on the type of window that is active or exists."
Ex_SM_TT := "Makes Send synonymous with SendInput or SendPlay rather than the default (SendEvent). Also makes Click and MouseMove/Click/Drag use the specified method."
SM_TT := "Event: This is the starting default used by all scripts. It uses the SendEvent method for Send, SendRaw, Click, and MouseMove/Click/Drag.`nInput: Switches to the SendInput method for Send, SendRaw, Click, and MouseMove/Click/Drag.`nInputThenPlay: Same as above except that rather than falling back to Event mode when SendInput is unavailable, it reverts to Play mode (below). This also causes the SendInput command itself to revert to Play mode when SendInput is unavailable.`nPlay: Switches to the SendPlay method for Send, SendRaw, Click, and MouseMove/Click/Drag."
Ex_SI_TT := "Determines whether a script is allowed to run again when it is already running."
SI_TT := "The word FORCE skips the dialog box and replaces the old instance automatically, which is similar in effect to the Reload command.`nThe word IGNORE skips the dialog box and leaves the old instance running. In other words, attempts to launch an already-running script are ignored.`nThe word OFF allows multiple instances of the script to run concurrently."
Ex_ST_TT := "Sets the matching behavior of the WinTitle parameter in commands such as WinWait."
ST_TT := "1: A window's title must start with the specified WinTitle to be a match.`n2: A window's title can contain WinTitle anywhere inside it to be a match.`n3: A window's title must exactly match WinTitle to be a match.`nRegEx: Changes WinTitle, WinText, ExcludeTitle, and ExcludeText to be regular expressions."
Ex_DH_TT := "Determines whether invisible windows are 'seen' by the script."
Ex_AF_TT := "Skips the gentle method of activating a window and goes straight to the forceful method."
Ex_IN_TT := "Causes the script to behave as though the specified file's contents are present at this exact position."
Ex_SK_TT := "Sets the delay that will occur after each keystroke sent by Send or ControlSend."
Ex_MD_TT := "Sets the delay that will occur after each mouse movement or click."
Ex_SC_TT := "Sets the delay that will occur after each control-modifying command."
Ex_SW_TT := "Sets the delay that will occur after each windowing command, such as WinActivate."
Ex_SB_TT := "Determines how fast a script will run (affects CPU utilization)."
Ex_NT_TT := "Disables the showing of a tray icon."
RunWait_TT := "Runs an external program. Unlike Run, RunWait will wait until the program finishes before continuing."
Ex_SQ_TT := "Creates a Sequenced Macro: Each command will be executed in sequence everytime you press the Hotkey."
AppName := "Pulover's Macro Creator"
HeadLine := "; This script was created using Pulover's Macro Creator"
HelpHead :=
(
"*****************************************************************************************
 RIGHT-CLICK ON A BUTTON IN THE MAIN WINDOW OR ANYWHERE
 ON A COMMAND WINDOW TO SHOW LINKS TO AHK ONLINE HELP.
*****************************************************************************************"
)
HelpTx := "Tips:`n`n- You can also enter key combinations direct in the Hotkey box at the bottom and press the Insert buttom.`n- Hold the Windows key for about half a second to hold it down.`n- The 'Repeat' counter at the bottom sets the number of loops of the whole list. You can also use it to set the loops for each item.`n- You can edit an item by double-clicking in a row in ListView or selecting an item and clicking in the Edit buttom at the bottom.`n- You can edit multiple selected items in the list by setting a repeat number in the 'Repeat' counter and pressing Apply, the same for Delay. And you can edit the Control target clicking in the Edit.`n- Use the Up/Down arrows to the right (or Ctrl+PgUp/PgDn) to move items in the list (you can move multiple items at the same time).`n- Use the X buttom to the right to delete one or more items in the list.`n- If no item is selected the Edit, Arrows and Delete buttoms will apply to all items in the list.`n- Uncheck the 'Capture Keys' option to select items with Ctrl/Shift in the ListView and to use the Delete key.`n`n"
}
return

