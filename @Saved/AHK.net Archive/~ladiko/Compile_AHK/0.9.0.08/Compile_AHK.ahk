; --------------------------------------------------------------------------------
; AutoHotkey Version:	1.0.47.04
; Language:				Deutsch/English
; Platform:				WinXP						| WinVista
; Author:				<= 0.9.0.5 @ denick			| >= 0.9.0.6 @ ladiko
; Version:				0.9.0.6/2007-09-09/ladiko
; Script Function:		Gui for AHK2EXE.EXE
; --------------------------------------------------------------------------------
; This script analyses a scriptname.ahk.ini, that is present inside of a script's
; directory or creates it, when not present and controls the compiler call and the
; possibly ResHack call.
; To use Compile_AHK you have to call it with the full path of a script as
; command line parameter
; --------------------------------------------------------------------------------
; Das Script wertet eine im Scriptverzeichnis vorhandene scriptname.ahk.ini aus
; und steuert damit den Compiler- und ggf. ResHack-Aufruf. Ggf. wird die ini-Datei
; mit Defaultwerten neu angelegt.
; Der vollständige Pfad des Scripts muss als Kommandozeilenparameter übergeben
; werden.
; --------------------------------------------------------------------------------
; ================================================================================
; AUTO EXECUTE SECTION ===========================================================
; ================================================================================
; --------------------------------------------------------------------------------
; AutoHotkey Directives
; --------------------------------------------------------------------------------
#NoEnv
#SingleInstance, Force
; --------------------------------------------------------------------------------
; AutoHotkey Settings
; --------------------------------------------------------------------------------
SetBatchLines, -1
DetectHiddenWindows, On
; --------------------------------------------------------------------------------
; Konstanten
; --------------------------------------------------------------------------------
COMPILE_AHK := "Compile_AHK.exe"
USER_DIR := A_AppDataCommon . "\AutoHotkey\Compiler"
COMPILER := "Ahk2Exe.exe"
BIN_FILE := "AutoHotkeySC.bin"
UPX_EXE := "Upx.exe"
RC_EXE := "GoRC.exe"
RES_EXE := "ResHacker.exe"
RES_INI := "ResHacker.ini"
RES_LOG := "ResHacker.log"
LOG_FILE := "Compile_AHK.log"
MANIFEST_FILE := "AutoHotkeySC.manifest"
DEFAULTS_INI := "Defaults.ini"

AHK_SECTION := "AHK2EXE"
RES_SECTION := "VERSION"
ICO_SECTION := "ICONS"
ICONCOUNT := 7
MSG_TITLE := "Compile AHK"
COMPR_LEVELS := "Lowest|Low|Normal|High|Highest"
SetWorkingDir, %USER_DIR%
; --------------------------------------------------------------------------------
; Variable
; --------------------------------------------------------------------------------
; Compiler settings
IN_FILE := ""
IN_DIR := ""
IN_EXT := ""
IN_NAME := ""
OUT_FILE := ""
OUT_DIR := ""
OUT_NAME := ""
UPX_LEVEL := 4
OUT_PASS := ""
SHOW_PASS := 0
OUT_DCMP := 0
RUN_BEFORE := ""
RUN_AFTER := ""
ADMIN := 0
; Version information
VERSION_INFO := False
COMPANY_NAME := ""
FILE_DESC := ""
FILE_VER := ""
INTERNAL_NAME := ""
LEGAL_COPYRIGHT := ""
ORG_FILENAME := ""
PRODUCT_NAME := ""
PRODUCT_VER := ""
SET_AHK_VERSION := 0

; Icons
Loop , 7 {
	ICON_%A_Index% := ""
	ICON_%A_Index%_SET := 0
}

; Gui
GUI_TITLE := "AHK Compilation Settings"
GUI_OUT_FILE := ""
GUI_UPX_LEVEL := 0
GUI_OUT_PASS := ""
GUI_SHOW_PASS := 0
GUI_OUT_DCMP := ""
GUI_RUN_BEFORE := ""
GUI_RUN_AFTER := ""
GUI_ADMIN := 0
GUI_VERSION_INFO := 0
GUI_COMPANY_NAME := ""
GUI_FILE_DESC := ""
GUI_TFV1 := ""
GUI_TFV2 := ""
GUI_TFV3 := ""
GUI_TFV4 := ""
GUI_FV1 := 0
GUI_FV2 := 0
GUI_FV3 := 0
GUI_FV4 := 0
GUI_INTERNAL_NAME := ""
GUI_PRODUCT_NAME := ""
GUI_LEGAL_COPYRIGHT := ""
GUI_ORG_FILENAME := ""
GUI_TPV1 := ""
GUI_TPV2 := ""
GUI_TPV3 := ""
GUI_TPV4 := ""
GUI_PV1 := 0
GUI_PV2 := 0
GUI_PV3 := 0
GUI_PV4 := 0
GUI_SET_AHK_VERSION := 0
GUI_ICON_1 := ""
GUI_ICON_2 := ""
GUI_ICON_3 := ""
GUI_ICON_4 := ""
GUI_ICON_1_SET := 0
GUI_ICON_2_SET := 0
GUI_ICON_3_SET := 0
GUI_ICON_4_SET := 0
; Others
INI_FILE := ""
ERR_MSG := ""
PARAM := ""
CMP_ERROR := ""
AHK_DIR := ""
; --------------------------------------------------------------------------------
; Installation check
; --------------------------------------------------------------------------------
ERR_MSG := "Installation Error!`n"
If (A_ScriptDir <> USER_DIR) {
	_ERR_MSG .= COMPILE_AHK . " must be called from Folder`n"
				. USER_DIR . "`n"
				. "Move the file and start again, please!"
	_ERROR_EXIT(ERR_MSG)
}
USER_DIR .= "\"
RegRead, AHK_DIR, HKLM, SOFTWARE\AutoHotkey, InstallDir
If (ErrorLevel) {
	_ERROR_EXIT(ERR_MSG . "AHK InstallDir not found")
}
AHK_DIR .= "\Compiler\"
If (!FileExist(AHK_DIR . COMPILER)) {
	_ERROR_EXIT(ERR_MSG . AHK_DIR . COMPILER . " not found")
}
If (!FileExist(AHK_DIR . BIN_FILE)) {
	_ERROR_EXIT(ERR_MSG . AHK_DIR . BIN_FILE . " not found")
}
_CHECK_AHK()
; --------------------------------------------------------------------------------
; Command line parameter ( Full AHK Script Path)
; --------------------------------------------------------------------------------
ERR_MSG := "Command Line Parameter Error!`n"
PARAM = %0%
If (PARAM != 2) {
	_ERROR_EXIT(ERR_MSG . "Wrong Number of Parameters: " . PARAM)
}
PARAM = %1%
If (PARAM != "/in") {
	_ERROR_EXIT(ERR_MSG . "Wrong Parameters: " . PARAM)
}
IN_FILE = %2%
SplitPath, IN_FILE, , IN_DIR, IN_EXT, IN_NAME
If (IN_EXT != "ahk") {
	_ERROR_EXIT(ERR_MSG . IN_FILE)
}
If (!FileExist(IN_FILE)) {
	_ERROR_EXIT(ERR_MSG . IN_FILE)
}
INI_FILE := IN_FILE . ".ini"
OUT_FILE := IN_DIR . "\" . IN_NAME . ".exe"
OUT_DIR := IN_DIR
OUT_NAME := IN_NAME . ".exe"
; --------------------------------------------------------------------------------
; INI File
; --------------------------------------------------------------------------------
If FileExist(INI_FILE) {
	_READ_INI(INI_FILE)
} Else If FileExist(DEFAULTS_INI) {
	_READ_INI(DEFAULTS_INI)
} Else {
	_WRITE_INI(INI_FILE)
}
; --------------------------------------------------------------------------------
; Compilation Settings Gui
; --------------------------------------------------------------------------------
_SET_GUI_VERS()
Gosub, GuiShow
Sleep, 250
WinWaitClose, %GUI_TITLE%
SplitPath, OUT_FILE, OUT_NAME, OUT_DIR
; --------------------------------------------------------------------------------
; Run Before
; --------------------------------------------------------------------------------
ERR_MSG := "Run before Error!`n"
If (RUN_BEFORE != "") {
	_RUN_BEFORE()
}
; --------------------------------------------------------------------------------
; Version Info
; --------------------------------------------------------------------------------
ERR_MSG := "Set Version Error!`n"
If (VERSION_INFO) {
	_SET_VERSION()
}
; --------------------------------------------------------------------------------
; Modify Manifest for Vista Administrator Exection Level (User Account Control)
; --------------------------------------------------------------------------------
ERR_MSG := "Modify Manifest Error!`n"
If (ADMIN) {
	_MOD_MANIFEST()
}
; --------------------------------------------------------------------------------
; Change Icons
; --------------------------------------------------------------------------------
ERR_MSG := "Change Icons Error!`n"
If (ICON_1_SET || ICON_2_SET || ICON_3_SET || ICON_4_SET || ICON_5_SET || ICON_6_SET || ICON_7_SET) {
	_CHANGE_ICONS()
}
; --------------------------------------------------------------------------------
; Compile
; --------------------------------------------------------------------------------
ERR_MSG := "Compilation Error!`n"
If (!_COMPILE_AHK()) {
	FileRead, CMP_ERROR, %LOG_FILE%
	_ERROR_EXIT(ERR_MSG . CMP_ERROR)
}
; --------------------------------------------------------------------------------
; Run After
; --------------------------------------------------------------------------------
ERR_MSG := "Run after Error!`n"
If (RUN_AFTER != "") {
	_RUN_AFTER()
}
; --------------------------------------------------------------------------------
; Rewrite INI
; --------------------------------------------------------------------------------
_WRITE_INI(INI_FILE)
; --------------------------------------------------------------------------------
; Bye
; --------------------------------------------------------------------------------
ExitApp
; ================================================================================
; GUI SECTION ==================================================================
; ================================================================================
; Show Gui
; --------------------------------------------------------------------------------
GuiShow:
Gui, +AlwaysOnTop -MinimizeBox -MaximizeBox
Gui, Margin, 0, 0
Gui, Font, s10 cNavy Arial
Gui, Add, Tab, Choose1 x0 w615 h440, Compiler Options|Version Info|Icons
Gui, Tab, 1

Gui, Add, Text, Section x+20 y+20 h20 w100 +0x1000, Script File
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w360 ReadOnly, %IN_FILE%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, Exe File
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w360 vGUI_OUT_FILE, %OUT_FILE%
Gui, Add, Button, x+20 yp h20 w70 gGuiBTSelFile, Select

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, Compression
Gui, Font, cBlack
Gui, Add, DDL, X+20 yp w100 vGUI_UPX_LEVEL AltSubmit, %COMPR_LEVELS%
GUI_UPX_LEVEL := UPX_LEVEL + 1
GuiControl, Choose, GUI_UPX_LEVEL, %GUI_UPX_LEVEL%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, Password
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w180 vGUI_OUT_PASS Password, %OUT_PASS%
Gui, Add, Checkbox, x+5 yp Checked%SHOW_PASS% vGUI_SHOW_PASS gGuiShowPwd, Show Password

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, NoDecompile
Gui, Add, Checkbox, x+20 yp w360 h20 vGUI_OUT_DCMP Checked%OUT_DCMP%
	, (AHK v1.0.46.10+)

Gui, Add, Text, xs y+20 h20 w100 +0x1000, Run Before
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w360 vGUI_RUN_BEFORE, %RUN_BEFORE%
Gui, Add, Button, x+20 yp h20 w70 gGuiBTRunBefore, Select

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, Run After
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w360 vGUI_RUN_AFTER, %RUN_AFTER%
Gui, Add, Button, x+20 yp h20 w70 gGuiBTRunAfter, Select

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w100 +0x1000, Vista UAC
Gui, Add, Checkbox, x+20 yp w400 h20 vGUI_ADMIN Checked%ADMIN%
	, Vista Administrator Execution Level (User Account Control)

Gui, Tab, 2

Gui, Add, Checkbox, x+20 y+20 gGUICBVI vGUI_VERSION_INFO Checked%VERSION_INFO%, Set Version Info

Gui, Font, cNavy
Gui, Add, Text, Section xp y+20 h20 w120 +0x1000, Company Name
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_COMPANY_NAME, %COMPANY_NAME%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, File Description
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_FILE_DESC, %FILE_DESC%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, File Version
Gui, Font, cBlack
Gui, Add, Edit, Center x+20 yp h20 w50 vGUI_TFV1,
Gui, Add, Updown, vGUI_FV1 Range0-999, %GUI_FV1%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TFV2,
Gui, Add, Updown, vGUI_FV2 Range0-999, %GUI_FV2%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TFV3,
Gui, Add, Updown, vGUI_FV3 Range0-999, %GUI_FV3%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TFV4,
Gui, Add, Updown, vGUI_FV4 Range0-999, %GUI_FV4%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, Internal Name
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_INTERNAL_NAME, %INTERNAL_NAME%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, Legal Copyright
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_LEGAL_COPYRIGHT, %LEGAL_COPYRIGHT%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, Original File Name
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_ORG_FILENAME, %ORG_FILENAME%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, Product Name
Gui, Font, cBlack
Gui, Add, Edit, x+20 yp h20 w320 vGUI_PRODUCT_NAME, %PRODUCT_NAME%

Gui, Font, cNavy
Gui, Add, Text, xs y+20 h20 w120 +0x1000, Product Version
Gui, Font, cBlack
Gui, Add, Edit, Center x+20 yp h20 w50 vGUI_TPV1,
Gui, Add, Updown, vGUI_PV1 Range0-999, %GUI_PV1%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TPV2,
Gui, Add, Updown, vGUI_PV2 Range0-999, %GUI_PV2%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TPV3,
Gui, Add, Updown, vGUI_PV3 Range0-999, %GUI_PV3%
Gui, Add, Edit, Center x+0 yp h20 w50 vGUI_TPV4,
Gui, Add, Updown, vGUI_PV4 Range0-999, %GUI_PV4%
Gui, Add, Checkbox, x+20 gGUICBSAV vGUI_SET_AHK_VERSION Checked%SET_AHK_VERSION%, Set to AutoHotkey.exe version

Gui, Tab, 3

Gui, Font, cNavy
Gui, Add, Text, Section x+20 y+20 h20 w130 +0x1000, Main Icon
Gui, Add, Checkbox, x+20 yp vGUI_ICON_1_SET gGuiIconActivate Checked%ICON_1_SET%
Gui, Font, cBlack
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_1 gGuiEDIcon, %ICON_1%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_1_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_1_PIC, %ICON_1%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Suspend Icon
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_2_SET gGuiIconActivate Checked%ICON_2_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_2 gGuiEDIcon, %ICON_2%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_2_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_2_PIC, %ICON_2%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Pause Icon
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_3_SET gGuiIconActivate Checked%ICON_3_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_3 gGuiEDIcon, %ICON_3%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_3_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_3_PIC, %ICON_3%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Suspend/Pause Icon
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_4_SET gGuiIconActivate Checked%ICON_4_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_4 gGuiEDIcon, %ICON_4%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_4_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_4_PIC, %ICON_4%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Shortcut Icon
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_5_SET gGuiIconActivate Checked%ICON_5_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_5 gGuiEDIcon, %ICON_5%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_5_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_5_PIC, %ICON_5%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Main Icon Win9x
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_6_SET gGuiIconActivate Checked%ICON_6_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_6 gGuiEDIcon, %ICON_6%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_6_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_6_PIC, %ICON_6%

Gui, Font, cNavy
Gui, Add, Text, Section xs y+20 h20 w130 +0x1000, Suspend Icon Win9x
Gui, Font, cBlack
Gui, Add, Checkbox, x+20 yp vGUI_ICON_7_SET gGuiIconActivate Checked%ICON_7_SET%
Gui, Add, Edit, x+0 yp h20 w250 vGUI_ICON_7 gGuiEDIcon, %ICON_7%
Gui, Add, Button, x+20 yp h20 w70 vGUI_ICON_7_BT gGuiBTSelIcon, Select
Gui, Add, Picture, x+20 yp-5 w32 h32 vGUI_ICON_7_PIC, %ICON_7%

Gui, Tab
Gui, Add, Button, Default xs y400 h25 w70 gGuiBTCompile, Compile
Gui, Add, Button, xp+500 yp h25 w70 gGuiClose, Abort

Gui, Add, Button, xm+514 ym h23 w100 gGuiSaveDefaults, Save Defaults

If (!VERSION_INFO) {
	_GUI_VERS_INFO("Disable")
}
GoSub , GuiCBSAV
GoSub , GuiShowPwd
GoSub , GuiIconActivate
Gui, Show, Autosize, %GUI_TITLE%
Return
; --------------------------------------------------------------------------------
; Gui Close
; --------------------------------------------------------------------------------
GuiClose:
GuiEscape:
Gui, Destroy
ERR_MSG := "Compilation aborted!"
_ERROR_EXIT(ERR_MSG)
Return
; --------------------------------------------------------------------------------
; Gui Button Compile
; --------------------------------------------------------------------------------
GuiBTCompile:
Gui, Submit, NoHide
If Not _GET_GUI_VALUES() {
	Return
}
Gui, Destroy
Return
; --------------------------------------------------------------------------------
; Gui Drop Files
; --------------------------------------------------------------------------------
GuiDropFiles:
Return
; --------------------------------------------------------------------------------
; Gui Button Select Exe File
; --------------------------------------------------------------------------------
GuiBTSelFile:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	SplitPath, GUI_OUT_FILE, OUT_NAME, OUT_DIR
	_SELECT_FOLDER(OUT_DIR)
	GuiControl, , GUI_OUT_FILE, %OUT_DIR%\%OUT_NAME%
Return
; --------------------------------------------------------------------------------
; Gui Save Default Settings
; --------------------------------------------------------------------------------
GuiSaveDefaults:
	Gui , Submit , NoHide
	_WRITE_INI(DEFAULTS_INI)
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiIconActivate:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	Loop , %ICONCOUNT% {
		TempControlName = GUI_ICON_%A_INDEX%_SET
		If (%TempControlName%) {
			; activate
			GuiControl, Enable, GUI_ICON_%A_Index%
			GuiControl, Enable, GUI_ICON_%A_Index%_BT
		} Else {
			; deactivate
			GuiControl, Disable, GUI_ICON_%A_Index%
			GuiControl, Disable, GUI_ICON_%A_Index%_BT
			GuiControl, , GUI_ICON_%A_Index%,
			GuiControl, , GUI_ICON_%A_Index%_PIC,
		}
	}
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiBTSelIcon:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	TempIconName := "GUI_ICON_" . SubStr(A_GuiControl,-3,1)
	TempIcon := %TempIconName%
	_SELECT_FILE(TempIcon, "ICO")
	GuiControl, , %TempIconName%, %TempIcon%
Return
; --------------------------------------------------------------------------------
; Gui Edit Icon
; --------------------------------------------------------------------------------
GuiEDIcon:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	TempIconName := "GUI_ICON_" . SubStr(A_GuiControl,0)
	TempIcon := %TempIconName%
	If (CHECK_ICON(TempIcon)) {
		GuiControl, , %TempIconName%_PIC, %TempIcon%
	} Else {
		GuiControl, , %TempIconName%_PIC
	}
Return
; --------------------------------------------------------------------------------
; Gui Button Select Show or Hide Password
; --------------------------------------------------------------------------------
GuiShowPwd:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	If (GUI_SHOW_PASS)
		GuiControl, -Password, GUI_OUT_PASS
	Else
		GuiControl, +Password, GUI_OUT_PASS
	GuiControl, Focus, GUI_OUT_PASS
return
; --------------------------------------------------------------------------------
; Gui Button Select Run Before
; --------------------------------------------------------------------------------
GuiBTRunBefore:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	_SELECT_FILE(GUI_RUN_BEFORE, "RUN")
	GuiControl, , GUI_RUN_BEFORE, %GUI_RUN_BEFORE%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Run After
; --------------------------------------------------------------------------------
GuiBTRunAfter:
	Gui, +Owndialogs
	Gui, Submit, NoHide
	_SELECT_FILE(GUI_RUN_AFTER, "RUN")
	GuiControl, , GUI_RUN_AFTER, %GUI_RUN_AFTER%
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Version Info
; --------------------------------------------------------------------------------
GuiCBVI:
	Gui, Submit, NoHide
	If (GUI_VERSION_INFO) {
		_GUI_VERS_INFO("Enable")
	} Else {
		_GUI_VERS_INFO("Disable")
	}
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Set AHK Version
; --------------------------------------------------------------------------------
GuiCBSAV:
	Gui, Submit, NoHide
	If (GUI_SET_AHK_VERSION) {
		;split AHK_Version to four values
		StringSplit, a_V, s_OrgComp, .
		Loop , %a_V0%
		{
			GuiControl, Disable, GUI_TPV%A_Index%
			Value := a_V%A_Index%
			GuiControl, , GUI_TPV%A_Index% , %Value%
		}
	} Else {
		Loop , %a_V0%
			GuiControl, Enable, GUI_TPV%A_Index%
	}
Return
; ================================================================================
; FUNCTIONS SECTION ============================================================
; ================================================================================
; Check AHK Compiler Version
; --------------------------------------------------------------------------------
_CHECK_AHK()
{
	Global
	Local s_UserComp, s_OrgUPX, s_UserUPX
	FileGetVersion, s_OrgComp, %AHK_DIR%%COMPILER%
	FileGetVersion, s_UserComp, %USER_DIR%%COMPILER%
	If (s_OrgComp <> s_UserComp) {
		FileCopy, %AHK_DIR%%COMPILER%, %USER_DIR%%COMPILER%, 1
		If (Errorlevel) {
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new " . COMPILER)
		}
	}
	FileGetVersion, s_OrgUPX, %AHK_DIR%%UPX_EXE%
	FileGetVersion, s_UserUPX, %USER_DIR%%UPX_EXE%
	If (s_OrgUPX <> s_UserUPX) {
		FileCopy, %AHK_DIR%%UPX_EXE%, %USER_DIR%%UPX_EXE%, 1
		If (Errorlevel) {
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new " . UPX_EXE)
		}
	}

	FileCopy, %AHK_DIR%%BIN_FILE%, %USER_DIR%%BIN_FILE%, 1
	If (Errorlevel) {
		_ERROR_EXIT(ERR_MSG . "Couldn't copy " . BIN_FILE)
	}
	Return
}
; --------------------------------------------------------------------------------
; Check for valid Icon Path
; --------------------------------------------------------------------------------
CHECK_ICON(sPATH)
{
	Global
	Local sEXT
	SplitPath, sPATH, , , sEXT
	If (sEXT = "ICO") {
		If (FileExist(sPATH)) {
			Return True
		}
	}
	Return False
}
; --------------------------------------------------------------------------------
; Read INI file
; --------------------------------------------------------------------------------
_READ_INI(s_INI_FILE)
{
	Global
	Local s_INI
	ERR_MSG := "Error reading INI File!`n"
	If (s_INI_FILE != DEFAULTS_INI) {
		IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, OUT_FILE, ERROR
		If (s_INI != "ERROR") {
			SplitPath, s_INI, , , s_EXT
			If (s_EXT = "exe") {
				OUT_FILE := s_INI
			}
		}
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, UPX_LEVEL, ERROR
	If s_INI Between 0 and 4
	{
		UPX_LEVEL := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, OUT_PASS, ERROR
	If (s_INI != "ERROR") {
		OUT_PASS := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, SHOW_PASS, ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_ERROR_EXIT(ERR_MSG . "SHOW_PASS = " . s_INI)
			Return
		}
		SHOW_PASS := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, OUT_DCMP, ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_ERROR_EXIT(ERR_MSG . "OUT_DCMP = " . s_INI)
			Return
		}
		OUT_DCMP := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, RUN_BEFORE, ERROR
	If (s_INI != "ERROR") {
		RUN_BEFORE := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, RUN_AFTER, ERROR
	If (s_INI != "ERROR") {
		RUN_AFTER := s_INI
	}
	IniRead, s_INI, %s_INI_FILE%, %AHK_SECTION%, ADMIN, ERROR
	If (s_INI != "ERROR") {
		ADMIN := s_INI
	}
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, VERSION_INFO, ERROR
	If (s_INI = "ERROR") {
		Return
	}
	If s_INI Not In 0,1
	{
		_ERROR_EXIT(ERR_MSG . "VERSION_INFO = " . s_INI)
		Return
	}
	VERSION_INFO := s_INI
	If (VERSION_INFO = False) {
		Return
	}
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, COMPANY_NAME, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "COMPANY_NAME missing!")
		Return
	}
	COMPANY_NAME := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, FILE_DESC, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "FILE_DESC missing!")
		Return
	}
	FILE_DESC := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, FILE_VER, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "FILE_VER missing!")
		Return
	}
	FILE_VER := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, INTERNAL_NAME, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "INTERNAL_NAME missing!")
		Return
	}
	INTERNAL_NAME := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, LEGAL_COPYRIGHT, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "LEGAL_COPYRIGHT missing!")
		Return
	}
	LEGAL_COPYRIGHT := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, ORG_FILENAME, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "ORG_FILENAME missing!")
		Return
	}
	ORG_FILENAME := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, PRODUCT_NAME, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "PRODUCT_NAME missing!")
		Return
	}
	PRODUCT_NAME := s_INI
	
	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, PRODUCT_VER, ERROR
	If (s_INI = "ERROR") {
		_ERROR_EXIT(ERR_MSG . "PRODUCT_VER missing!")
		Return
	}
	PRODUCT_VER := s_INI

	IniRead, s_INI, %s_INI_FILE%, %RES_SECTION%, SET_AHK_VERSION, ERROR
	If (s_INI != "ERROR") {
		SET_AHK_VERSION := s_INI
	}
	
	Loop , %ICONCOUNT% {
		IniRead, s_INI, %s_INI_FILE%, %ICO_SECTION%, ICON_%A_Index%_SET, ERROR
		If (s_INI != "ERROR") {
			If s_INI Not In 0,1
			{
				_ERROR_EXIT(ERR_MSG . "ICON_" . A_Index . "_SET = " . s_INI)
				Return
			}
			ICON_%A_Index%_SET := s_INI
		}
		If (s_INI = 0)
			Continue
		
		IniRead, s_INI, %s_INI_FILE%, %ICO_SECTION%, ICON_%A_Index%, ERROR
		If (s_INI != "ERROR") {
			If FileExist(s_INI) {
				ICON_%A_Index% := s_INI
			}
		}	
	}
	Return
}
; --------------------------------------------------------------------------------
; Write INI file
; --------------------------------------------------------------------------------
_WRITE_INI(s_INI_FILE)
{
	Global
	FileDelete, %s_INI_FILE%
	If (s_INI_FILE != DEFAULTS_INI)
		IniWrite, %OUT_FILE%, %s_INI_FILE%, %AHK_SECTION%, OUT_FILE
	IniWrite, %ICON_1%, %s_INI_FILE%, %AHK_SECTION%, ICON_1
	IniWrite, %UPX_LEVEL%, %s_INI_FILE%, %AHK_SECTION%, UPX_LEVEL
	IniWrite, %OUT_PASS%, %s_INI_FILE%, %AHK_SECTION%, OUT_PASS
	IniWrite, %SHOW_PASS%, %s_INI_FILE%, %AHK_SECTION%, SHOW_PASS
	IniWrite, %OUT_DCMP%, %s_INI_FILE%, %AHK_SECTION%, OUT_DCMP
	IniWrite, %RUN_BEFORE%, %s_INI_FILE%, %AHK_SECTION%, RUN_BEFORE
	IniWrite, %RUN_AFTER%, %s_INI_FILE%, %AHK_SECTION%, RUN_AFTER
	IniWrite, %ADMIN%, %s_INI_FILE%, %AHK_SECTION%, ADMIN
	IniWrite, %VERSION_INFO%, %s_INI_FILE%, %RES_SECTION%, VERSION_INFO
	If (VERSION_INFO)
	{
		IniWrite, %COMPANY_NAME%, %s_INI_FILE%, %RES_SECTION%, COMPANY_NAME
		IniWrite, %FILE_DESC%, %s_INI_FILE%, %RES_SECTION%, FILE_DESC
		IniWrite, %FILE_VER%, %s_INI_FILE%, %RES_SECTION%, FILE_VER
		IniWrite, %INTERNAL_NAME%, %s_INI_FILE%, %RES_SECTION%, INTERNAL_NAME
		IniWrite, %LEGAL_COPYRIGHT%, %s_INI_FILE%, %RES_SECTION%, LEGAL_COPYRIGHT
		IniWrite, %ORG_FILENAME%, %s_INI_FILE%, %RES_SECTION%, ORG_FILENAME
		IniWrite, %PRODUCT_NAME%, %s_INI_FILE%, %RES_SECTION%, PRODUCT_NAME
		IniWrite, %PRODUCT_VER%, %s_INI_FILE%, %RES_SECTION%, PRODUCT_VER
		
		IniWrite, %SET_AHK_VERSION%, %s_INI_FILE%, %RES_SECTION%, SET_AHK_VERSION
	}
	Loop , %ICONCOUNT% {
		TempIconName := "ICON_" . A_Index
		TempIcon := %TempIconName%
		TempBoxName := TempIconName . "_SET"
		TempBox := %TempBoxName%
		IniWrite, %TempBox%, %s_INI_FILE%, %ICO_SECTION%, %TempBoxName%
		If (TempBox)
			IniWrite, %TempIcon%, %s_INI_FILE%, %ICO_SECTION%, %TempIconName%
	}
	Return
}
; --------------------------------------------------------------------------------
; Enable/Disable Version Info
; --------------------------------------------------------------------------------
_GUI_VERS_INFO(s_CMD)
{
	Global
	GuiControl, %s_CMD%, GUI_COMPANY_NAME
	GuiControl, %s_CMD%, GUI_FILE_DESC
	GuiControl, %s_CMD%, GUI_TFV1
	GuiControl, %s_CMD%, GUI_TFV2
	GuiControl, %s_CMD%, GUI_TFV3
	GuiControl, %s_CMD%, GUI_TFV4
	GuiControl, %s_CMD%, GUI_FV1
	GuiControl, %s_CMD%, GUI_FV2
	GuiControl, %s_CMD%, GUI_FV3
	GuiControl, %s_CMD%, GUI_FV4
	GuiControl, %s_CMD%, GUI_INTERNAL_NAME
	GuiControl, %s_CMD%, GUI_LEGAL_COPYRIGHT
	GuiControl, %s_CMD%, GUI_ORG_FILENAME
	GuiControl, %s_CMD%, GUI_PRODUCT_NAME
	If Not SET_AHK_VERSION {
		GuiControl, %s_CMD%, GUI_TPV1
		GuiControl, %s_CMD%, GUI_TPV2
		GuiControl, %s_CMD%, GUI_TPV3
		GuiControl, %s_CMD%, GUI_TPV4
		GuiControl, %s_CMD%, GUI_PV1
		GuiControl, %s_CMD%, GUI_PV2
		GuiControl, %s_CMD%, GUI_PV3
		GuiControl, %s_CMD%, GUI_PV4
	}
	GuiControl, %s_CMD%, GUI_SET_AHK_VERSION
	Return
}
; --------------------------------------------------------------------------------
; Set GUI Versions
; --------------------------------------------------------------------------------
_SET_GUI_VERS()
{
	Global
	Local aVersion0
	If (!VERSION_INFO) {
		Return
	}
	StringSplit, aVersion, FILE_VER, `., %A_Space%
	Loop, %aVersion0%
	{
		GUI_FV%A_Index% := aVersion%A_Index%
	}
	StringSplit, aVersion, PRODUCT_VER, `., %A_Space%
	Loop, %aVersion0%
	{
		GUI_PV%A_Index% := aVersion%A_Index%
	}
	Return
}
; --------------------------------------------------------------------------------
; Select Folder
; --------------------------------------------------------------------------------
_SELECT_FOLDER(ByRef s_DIR)
{
	Global
	Local s_SEL, s_PROMPT
	s_PROMPT := "Select Destination Folder:"
	FileSelectFolder, s_SEL, *%s_DIR%, 3, %s_PROMPT%
	If (Errorlevel) {
		Return
	}
	s_DIR := s_SEL
	Return
}
; --------------------------------------------------------------------------------
; Select File
; --------------------------------------------------------------------------------
_SELECT_FILE(ByRef s_FILE, s_TYPE)
{
	Global
	Local s_SEL, s_EXT, s_OPTIONS, s_PROMPT, S_FILTER
	If s_TYPE not in ICO,RUN
	{
		Return
	}
	If (s_TYPE = "ICO") {
		s_OPTIONS := "1"
		s_PROMPT := "Select Icon File"
		s_FILTER := "Icon (*.ico)"
	} ELSE {
		s_OPTIONS := "1"
		s_PROMPT := "Select Runnable File"
		s_FILTER := "Run (*.ahk;*.bat;*.cmd;*.exe)"
	}
	FileSelectFile, s_SEL, %s_OPTIONS%, %IN_DIR%, %s_PROMPT%, %s_FILTER%
	If (Errorlevel) {
		Return
	}
	s_FILE := s_SEL
	Return
}
; --------------------------------------------------------------------------------
; Get Gui Values
; --------------------------------------------------------------------------------
_GET_GUI_VALUES()
{
	Global
	OUT_FILE := GUI_OUT_FILE
	If (GUI_ICON_1 != "") {
		If Not FileExist(GUI_ICON_1) {
			Msgbox, 262192, %MSG_TITLE%, Icon File %GUI_ICON_1% doesn't exist!
			GuiControl, Focus, GUI_ICON_1
			Return False
		}
	}
	ICON_1 := GUI_ICON_1
	UPX_LEVEL := GUI_UPX_LEVEL - 1
	OUT_PASS := GUI_OUT_PASS
	SHOW_PASS := GUI_SHOW_PASS
	OUT_DCMP := GUI_OUT_DCMP
	RUN_BEFORE := GUI_RUN_BEFORE
	RUN_AFTER := GUI_RUN_AFTER
	ADMIN := GUI_ADMIN
	VERSION_INFO := GUI_VERSION_INFO
	If (VERSION_INFO) {
		COMPANY_NAME := GUI_COMPANY_NAME
		FILE_DESC := GUI_FILE_DESC
		FILE_VER := GUI_FV1 . "." . GUI_FV2 . "." . GUI_FV3 . "." . GUI_FV4
		INTERNAL_NAME := GUI_INTERNAL_NAME
		LEGAL_COPYRIGHT := GUI_LEGAL_COPYRIGHT
		ORG_FILENAME := GUI_ORG_FILENAME
		PRODUCT_NAME := GUI_PRODUCT_NAME
		PRODUCT_VER := GUI_PV1 . "." . GUI_PV2 . "." . GUI_PV3 . "." . GUI_PV4
		
		SET_AHK_VERSION := GUI_SET_AHK_VERSION
	}
	Loop , %ICONCOUNT% {
		ICON_%A_Index% := GUI_ICON_%A_Index%
		ICON_%A_Index%_SET := GUI_ICON_%A_Index%_SET
	}
	Return True
}
; --------------------------------------------------------------------------------
; Run before
; --------------------------------------------------------------------------------
_RUN_BEFORE()
{
	Global
	Local s_CMD, s_ERR, s_LOG
	s_CMD := RUN_BEFORE
			. " > "
			. """" . LOG_FILE . """"
	StringReplace, s_CMD, s_CMD, % "%IF%", %IN_FILE%, All
	StringReplace, s_CMD, s_CMD, % "%OF%", %OUT_FILE%, All
	StringReplace, s_CMD, s_CMD, % "%OD%", %OUT_DIR%, All
	StringReplace, s_CMD, s_CMD, % "%ON%", %OUT_NAME%, All
	RunWait, %ComSpec% /c "%s_CMD%", %IN_DIR%, UseErrorLevel Hide
	If (Errorlevel <> 0)
	{
		FileRead, s_LOG, %LOG_FILE%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	Return
	Return
}
; --------------------------------------------------------------------------------
; Modify Manifest for Vista Administrator Exection Level (User Account Control)
; --------------------------------------------------------------------------------
_MOD_MANIFEST()
{
	Global
	Local s_CMD, s_ERR, s_LOG, s_MANIFEST, XML_POS, s_LEFT, s_RIGHT

	s_CMD := """" . RES_EXE . """"
			. " -extract "
			. """" . BIN_FILE . """"
			. ", "
			. """" . MANIFEST_FILE . """"
			. ",24,1,1033"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	If (Errorlevel <> 0)
	{
		FileRead, s_LOG, %RES_LOG%
		s_ERR := "Couldn't create manifest file, " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	
	FileRead , s_MANIFEST, %MANIFEST_FILE%
	StringGetPos, XML_POS, s_MANIFEST, </, R
	StringLeft, s_LEFT, s_MANIFEST, XML_POS
	StringTrimLeft, s_RIGHT, s_MANIFEST, XML_POS
	
	s_MANIFEST := s_LEFT
				. "<!-- Identify the application security requirements. -->`n"
				. "<!-- level can be ""asInvoker"", ""highestAvailable"", or ""requireAdministrator"" -->`n"
				. "	<trustInfo xmlns=""urn:schemas-microsoft-com:asm.v2"">`n"
				. "		<security>`n"
				. "			<requestedPrivileges>`n"
				. "				<requestedExecutionLevel`n"
				. "					level=""requireAdministrator""`n"
				. "					uiAccess=""false""`n"
				. "				/>`n"
				. "			</requestedPrivileges>`n"
				. "		</security>`n"
				. "</trustInfo>`n"
				. s_RIGHT
	
	FileDelete , %MANIFEST_FILE%
	FileAppend , %s_MANIFEST% , %MANIFEST_FILE%
	
	s_CMD := """" . RES_EXE . """"
			. " -addoverwrite "
			. """" . BIN_FILE . """"
			. ", "
			. """" . BIN_FILE . """"
			. ", "
			. """" . MANIFEST_FILE . """"
			. ",24,1,1033"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	If (Errorlevel <> 0)
	{
		FileRead, s_LOG, %RES_LOG%
		s_ERR := "Couldn't modify manifest file, " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	
	FileSetTime, , %BIN_FILE%, M			;Is not set automatically
	FileDelete, %MANIFEST_FILE%
	FileDelete, %RES_INI%
	FileDelete, %RES_LOG%

	
	Return
}
; --------------------------------------------------------------------------------
; Set Version
; --------------------------------------------------------------------------------
_SET_VERSION()
{
	Global
	Local s_CMD, s_ERR, s_LOG, s_FILE_VER, s_PROD_VER, s_RC_FILE, s_RES_FILE
	s_RC_FILE := "Temp.rc"
	s_RES_FILE := "Temp.res"
	IfNotExist, %RC_EXE%
	{
		_ERROR_EXIT(ERR_MSG . "Couldn't find " . RC_EXE)
	}
	IfNotExist, %RES_EXE%
	{
		_ERROR_EXIT(ERR_MSG . "Couldn't find " . RES_EXE)
	}
	FileDelete, %s_RC_FILE%
	FileDelete, %s_RES_FILE%
	StringReplace, s_FILE_VER, FILE_VER, ., `, , All
	StringReplace, s_PROD_VER, PRODUCT_VER, ., `, , All
	FileAppend,
(
1 VERSIONINFO
FILEVERSION %s_FILE_VER%
PRODUCTVERSION %s_PROD_VER%
FILEOS 0x4
FILETYPE 0x1
{
BLOCK "StringFileInfo"
{
		BLOCK "040904b0"
		{
			VALUE "CompanyName", "%COMPANY_NAME%"
			VALUE "FileDescription", "%FILE_DESC%"
			VALUE "FileVersion", "%FILE_VER%"
			VALUE "InternalName", "%INTERNAL_NAME%"
			VALUE "LegalCopyright", "%LEGAL_COPYRIGHT%"
			VALUE "OriginalFilename", "%ORG_FILENAME%"
			VALUE "ProductName", "%PRODUCT_NAME%"
			VALUE "ProductVersion", "%PRODUCT_VER%"
		}
}
BLOCK "VarFileInfo"
{
	VALUE "Translation", 0x0409 0x04B0
}
}
), %s_RC_FILE%
	s_CMD := """" . RC_EXE . """"
			. "/r "
			. """" . s_RC_FILE . """"
			. " > "
			. """" . LOG_FILE . """"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	IfNotExist, %s_RES_FILE%
	{
		FileRead, s_LOG, %LOG_FILE%
		s_ERR := "Couldn't set Version Info, " . RC_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
; --------------------------------------------------------------------------------
; ResHacker-fix:
; delete versioninfo with language ID 1033 to prevent double versioninfo and cause
; following command doesnt work:
; ResHacker.exe -addoverwrite, in.exe, out.exe, version.res, versioninfo,1,1033
; --------------------------------------------------------------------------------
	s_CMD := """" . RES_EXE . """"
			. " -delete "
			. """" . BIN_FILE . """"
			. ", "
			. """" . BIN_FILE . """"
			. ", Versioninfo,1,1033"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead, s_LOG, %RES_LOG%
		s_ERR := "Couldn't set Version Info, " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
; --------------------------------------------------------------------------------
	s_CMD := """" . RES_EXE . """"
			. " -addoverwrite "
			. """" . BIN_FILE . """"
			. ", "
			. """" . BIN_FILE . """"
			. ", "
			. """" . s_RES_FILE . """"
			. ", Versioninfo,1,"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead, s_LOG, %RES_LOG%
		s_ERR := "Couldn't set Version Info, " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}

	FileSetTime, , %BIN_FILE%, M			;Is not set automatically
	FileDelete, %s_RC_FILE%
	FileDelete, %s_RES_FILE%
	FileDelete, %RES_INI%
	FileDelete, %RES_LOG%
	Return
}
; --------------------------------------------------------------------------------
; Change Icons
; --------------------------------------------------------------------------------
_CHANGE_ICONS()
{
	Global
	Local s_SC_FILE, s_SCRIPT, s_CMD, s_LOG
	s_SC_FILE := "TempIcon.src"
	
	s_SCRIPT := "[FILENAMES]`n"
			. "Exe=" . BIN_FILE . "`n"
			. "SaveAs=" . BIN_FILE . "`n"
			. "Log=" . RES_LOG . "`n"
			. "[COMMANDS]`n"
	
	If (ICON_1_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_1 """,ICONGROUP,159,1033`n"
	If (ICON_2_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_2 """,ICONGROUP,206,1033`n"
	If (ICON_3_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_3 """,ICONGROUP,207,1033`n"
	If (ICON_4_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_4 """,ICONGROUP,208,1033`n"
	If (ICON_5_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_5 """,ICONGROUP,160,1033`n"
	If (ICON_6_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_6 """,ICONGROUP,228,1033`n"
	If (ICON_7_SET)
		s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_7 """,ICONGROUP,229,1033`n"
	
	FileDelete, %s_SC_FILE%
	FileAppend , %s_SCRIPT% , %s_SC_FILE%
	
	s_CMD := """" . RES_EXE . """"
			. " -script "
			. """" . s_SC_FILE . """"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead, s_LOG, %RES_LOG%
		s_ERR := "Couldn't change icons, " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	
	FileSetTime, , %BIN_FILE%, M			;Is not set automatically
	FileDelete, %s_SC_FILE%
	FileDelete, %RES_INI%
	FileDelete, %RES_LOG%
	
	Return
}
; --------------------------------------------------------------------------------
; Compile AHK
; --------------------------------------------------------------------------------
_COMPILE_AHK()
{
	Global
	Local s_IN, s_OUT, s_ICON, s_PASS, s_DCMP, s_CMD, s_LOG
	s_IN := " /in """ . IN_FILE . """"
	s_OUT := " /out """ . OUT_FILE . """"
	/*
	If (ICON_1 != "") {
		s_ICON := " /icon """ . ICON_1 . """"
	}
	*/
	If (OUT_PASS != "") {
		s_PASS := " /pass """ . OUT_PASS . """"
	}
	If (OUT_DCMP) {
		s_DCMP := " /NoDecompile"
	}
	_SET_REGISTRY()
	s_CMD := """" . COMPILER . """"
			. s_IN
			. s_OUT
			. s_ICON
			. s_PASS
			. s_DCMP
			. " > "
			. """" . LOG_FILE . """"
	RunWait, %ComSpec% /c "%s_CMD%", , UseErrorLevel Hide
	_SET_REGISTRY()
	If (ErrorLevel) {
		Return False
	}
	FileRead, s_LOG, %LOG_FILE%
	Msgbox, 262208, Compile AHK, %s_LOG%
	Return True
}
; --------------------------------------------------------------------------------
; Run after
; --------------------------------------------------------------------------------
_RUN_AFTER()
{
	Global
	Local s_CMD, s_ERR, s_LOG
	s_CMD := RUN_AFTER
			. " > "
			. """" . LOG_FILE . """"
	StringReplace, s_CMD, s_CMD, % "%IF%", %IN_FILE%, All
	StringReplace, s_CMD, s_CMD, % "%OF%", %OUT_FILE%, All
	StringReplace, s_CMD, s_CMD, % "%OD%", %OUT_DIR%, All
	StringReplace, s_CMD, s_CMD, % "%ON%", %OUT_NAME%, All
	RunWait, %ComSpec% /c "%s_CMD%", %IN_DIR%, UseErrorLevel Hide
	If (Errorlevel <> 0)
	{
		FileRead, s_LOG, %LOG_FILE%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	Return
}
; --------------------------------------------------------------------------------
; Set Registry Entries
; --------------------------------------------------------------------------------
_SET_REGISTRY()
{
	Global
	RegWrite, REG_DWORD
				, HKCU
				, Software\AutoHotkey\Ahk2Exe
				, LastCompression
				, %UPX_LEVEL%
	RegWrite, REG_SZ
				, HKCU
				, Software\AutoHotkey\Ahk2Exe
				, LastIcon
	Return
}
; --------------------------------------------------------------------------------
; ERROR EXIT
; --------------------------------------------------------------------------------
_ERROR_EXIT(sMSG)
{
	Msgbox, 262160, %MSG_TITLE%, %sMSG%
	ExitApp
}