; --------------------------------------------------------------------------------
; AutoHotkey Version	: 1.0.47.06
; Language				: Deutsch // English
; Platform				: Win2k // WinXP // WinVista
; Author				: <= 0.9.0.5 @ denick // >= 0.9.0.6 @ ladiko
; Version				: 0.9.1.0 // 2007-09-16 // ladiko
; Script Function		: Gui for AHK2EXE.EXE
; --------------------------------------------------------------------------------
; This script analyses a scriptname.ahk.ini , that is present inside of a script's
; directory or creates it , when not present and controls the compiler call and the
; possibly ResHack call.
; To use Compile_AHK you have to call it with the full path of a script as
; command line parameter
; --------------------------------------------------------------------------------
; Das Script wertet eine im Scriptverzeichnis vorhandene scriptname.ahk.ini aus
; und steuert damit den Compiler- und ggf. ResHack-Aufruf. Ggf. wird die ini-Datei
; mit Defaultwerten neu angelegt.
; Der vollst?ndige Pfad des Scripts muss als Kommandozeilenparameter übergeben
; werden.
; --------------------------------------------------------------------------------
; Thanks goes to jfk001
; --------------------------------------------------------------------------------
; ================================================================================
; AUTO EXECUTE SECTION ===========================================================
; ================================================================================
; --------------------------------------------------------------------------------
; AutoHotkey Directives
; --------------------------------------------------------------------------------
#NoEnv
#SingleInstance , Force
; --------------------------------------------------------------------------------
; AutoHotkey Settings
; --------------------------------------------------------------------------------
SetBatchLines , -1
DetectHiddenWindows , On
; --------------------------------------------------------------------------------
; Konstanten
; --------------------------------------------------------------------------------
IfNotExist , %A_TEMP%\AutoHotkey\Compiler
	FileCreateDir , %A_TEMP%\AutoHotkey\Compiler
SetWorkingDir , %A_TEMP%\AutoHotkey\Compiler

COMPILER := "Ahk2Exe.exe"
AHK_EXE := "AutoHotkey.exe"
LIB_DIR := "Lib"
BIN_FILE := "AutoHotkeySC.bin"
UPX_EXE := "Upx.exe"
RC_EXE := "GoRC.exe"
RC_LOG := "GoRC.log"
RES_EXE := "ResHacker.exe"
RES_INI := "ResHacker.ini"
RES_LOG := "ResHacker.log"
LOG_FILE := "Compile_AHK.log"
MANIFEST_FILE := "AutoHotkeySC.manifest"
USER_DEFAULTS_INI := A_AppData . "\Compile_AHK\Defaults.ini"
GLOBAL_DEFAULTS_INI := A_ScriptDir . "\Defaults.ini"
AUTO_COMPILE = 0

AHK_SECTION := "AHK2EXE"
RES_SECTION := "VERSION"
ICO_SECTION := "ICONS"
ICONCOUNT := 7
MSG_TITLE := "Compile_AHK"
COMPR_LEVELS := "Lowest|Low|Normal|High|Highest"
LANG_IDS := CREATE_LANG_LIST()
CHARSETS := CREATE_CHARSET_LIST()

; --------------------------------------------------------------------------------
; Variable
; --------------------------------------------------------------------------------
; Compiler settings
IN_FILE := ""
IN_DIR := ""
IN_EXT := ""
IN_NAME := ""
ALT_BIN_SET := 0
ALT_BIN := ""
OUT_FILE := ""
OUT_DIR := ""
OUT_NAME := ""
COMPRESSION := 4
NO_UPX := 0
OUT_PASS := ""
SHOW_PASS := 0
NO_DECOMPILE := 0
CREATED_DATE := 0
RUN_BEFORE := ""
RUN_AFTER := ""
EXEC_LEVEL := 1
; Version information
VERSION_INFO := False
COMPANY_NAME := ""
FILE_DESC := ""
FILE_VER := ""
INC_FILE_VER := 0
INTERNAL_NAME := ""
LEGAL_COPYRIGHT := ""
ORG_FILENAME := ""
PRODUCT_NAME := ""
PRODUCT_VER := ""
SET_AHK_VERSION := 0
INC_PROD_VER := 0
LANG_ID := 39 ; English_United_States
CHARSET := 5 ; Unicode

; Icons
Loop , 7 {
	ICON_%A_Index% := ""
	ICON_%A_Index%_SET := 0
}

; Gui compiler settings
Gui +OwnDialogs
GUI_TITLE := "Compile_AHK"
GUI_ALT_BIN_SET := 0
GUI_ALT_BIN := ""
GUI_OUT_FILE := ""
GUI_COMPRESSION := 5
GUI_NO_UPX := 0
GUI_OUT_PASS := ""
GUI_SHOW_PASS := 0
GUI_NO_DECOMPILE := 0
GUI_CREATED_DATE := 0
GUI_RUN_BEFORE := ""
GUI_RUN_AFTER := ""
GUI_EXEC_LEVEL := 1
; gui versioninfo
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
GUI_INC_FILE_VER := 0
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
GUI_INC_PROD_VER := 0
GUI_LANG_ID := 0
GUI_CHARSET := 0
;gui icons
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
AHK_COMPILER_DIR := ""
; --------------------------------------------------------------------------------
; Installation check
; --------------------------------------------------------------------------------
ERR_MSG := "Installation Error!`n"
RegRead , AHK_DIR , HKLM , SOFTWARE\AutoHotkey , InstallDir
If (ErrorLevel) {
	IfExist , %A_ScriptDir%\Ahk2Exe.exe
		SplitPath, A_ScriptDir , , AHK_DIR
	Else
		_ERROR_EXIT(ERR_MSG . "AHK InstallDir not found")
}
AHK_COMPILER_DIR := AHK_DIR . "\Compiler"
If (!FileExist(AHK_COMPILER_DIR . "\" . COMPILER)) {
	_ERROR_EXIT(ERR_MSG . AHK_COMPILER_DIR . "\" . COMPILER . " not found")
}
If (!FileExist(AHK_COMPILER_DIR . "\" . BIN_FILE)) {
	_ERROR_EXIT(ERR_MSG . AHK_COMPILER_DIR . "\" . BIN_FILE . " not found")
}
_CHECK_AHK()
; --------------------------------------------------------------------------------
; Command line parameter ( Full AHK Script Path)
; --------------------------------------------------------------------------------
ERR_MSG := "Command Line Parameter Error!`n"
PARAM = %0%

If PARAM = 0
	_SELECT_FILE(IN_FILE , "AHK")
Else If PARAM = 1
	IN_FILE = %1%
Else If PARAM = 2
{
	
	PARAM_1 = %1%
	If PARAM_1 = /auto
	{
		IN_FILE = %2%
		AUTO_COMPILE = 1
	}
	Else If PARAM_1 = /nogui
	{
		IN_FILE = %2%
		AUTO_COMPILE = 2
	}
	Else
	{
		PARAM_ERROR :=	"`nThe first of two parameters has to be:`n"
						. "/auto to compile with existing settings from the last compilation`n"
						. "/nogui to compile with existing settings and no warnings`n`n"
						. "The second parameter has to be the full path of a script."
		_ERROR_EXIT(ERR_MSG . PARAM_ERROR)
	}
}
Else
	_ERROR_EXIT(ERR_MSG . "Wrong Number of Parameters: " . PARAM)

SplitPath , IN_FILE , , IN_DIR , IN_EXT , IN_NAME

If (IN_EXT != "ahk") {
	_ERROR_EXIT(ERR_MSG . "`n""" . IN_FILE . """ is not a .ahk file.")
}
If FileExist(IN_FILE)
{
	If IN_DIR = ""
		IN_DIR := A_WorkingDir
}
Else
{
	If FileExist(A_ScriptDir . "\" . IN_FILE)
	{
		IN_DIR := A_ScriptDir
		IN_FILE := IN_DIR . "\" . IN_FILE
	}
	Else
		_ERROR_EXIT(ERR_MSG . "`n""" . IN_FILE . """ not found")
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
} Else If FileExist(USER_DEFAULTS_INI) {
	_READ_INI(USER_DEFAULTS_INI)
} Else If FileExist(GLOBAL_DEFAULTS_INI) {
	_READ_INI(GLOBAL_DEFAULTS_INI)
}
; --------------------------------------------------------------------------------
; Compilation Settings Gui
; --------------------------------------------------------------------------------
_SET_GUI_VERS()
Gosub , GuiShow
Return
; ================================================================================
; FUNCTIONS AND METHODS SECTION ==================================================
; ================================================================================
; --------------------------------------------------------------------------------
; Gui Button Compile
; --------------------------------------------------------------------------------
GuiBTCompile:
	Gui , Submit , NoHide
	If Not _GET_GUI_VALUES() {
		Return
	}
	Gui , Destroy

	SplitPath , OUT_FILE , OUT_NAME , OUT_DIR
	; --------------------------------------------------------------------------------
	; New Log File
	; --------------------------------------------------------------------------------
	ERR_MSG := "Error while deleting old log file!`n"
	IfExist , %A_WorkingDir%\%LOG_FILE%
	{
		FileDelete , %A_WorkingDir%\%LOG_FILE%
		If ErrorLevel
			_ERROR_EXIT(ERR_MSG . "Couldn't delete """ . LOG_FILE . """")
	}
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
	; Change Icons
	; --------------------------------------------------------------------------------
	ERR_MSG := "Change Icons Error!`n"
	If (ICON_1_SET || ICON_2_SET || ICON_3_SET || ICON_4_SET || ICON_5_SET || ICON_6_SET || ICON_7_SET) {
		_CHANGE_ICONS()
	}
	; --------------------------------------------------------------------------------
	; Modify Manifest for Vista Administrator Exection Level (User Account Control)
	; --------------------------------------------------------------------------------
	ERR_MSG := "Modify Manifest Error!`n"
	If (EXEC_LEVEL > 1) {
		_MOD_MANIFEST()
	}
	Else {
		_CHECK_EXENAME()
	}
	; --------------------------------------------------------------------------------
	; Compile
	; --------------------------------------------------------------------------------
	ERR_MSG := "Compilation Error!`n"
	If (!_COMPILE_AHK()) {
		FileRead , CMP_ERROR , %LOG_FILE%
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
Return
; ================================================================================
; GUI SECTION ==================================================================
; ================================================================================
; Show Gui
; --------------------------------------------------------------------------------
GuiShow:
	Gui , -MinimizeBox -MaximizeBox
	Gui , Margin , 0 , 0
	Gui , Font , s10 cNavy Arial
	Gui , Add , Tab , Choose1 x0 w555 h410 vGUI_TAB_CHOOSE , Compiler Options|Version Info|Icons
	Gui , Tab , 1

	Gui , Add , Text , Section x+20 y+17 h20 w120 +0x1000 vGUI_TEXT_IN_FILE , Script File
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGUI_IN_FILE ReadOnly , %IN_FILE%
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_ALT_BIN , AutoHotkeySC.bin
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp w30 vGUI_ALT_BIN_SET gGuiActivateAltBin Checked%ALT_BIN_SET%
	Gui , Add , Edit , x+00 yp h20 w250 vGUI_ALT_BIN , %ALT_BIN%
	Gui , Add , Button , x+20 yp-1 h22 w70 vGUI_SELECT_ALT_BIN gGuiBTSelBin , Select

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_OUT_FILE , Exe File
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGUI_OUT_FILE , %OUT_FILE%
	Gui , Add , Button , x+20 yp-1 h22 w70 vGUI_SELECT_OUT_FILE gGuiBTSelFile , Select

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_COMPRESSION, Compression
	Gui , Font , cBlack
	Gui , Add , DDL , x+20 yp w100 vGUI_COMPRESSION AltSubmit , %COMPR_LEVELS%
	GUI_COMPRESSION := COMPRESSION + 1
	GuiControl , Choose , GUI_COMPRESSION , %GUI_COMPRESSION%
	Gui , Add , Checkbox , x+20 yp Checked%NO_UPX% vGUI_NO_UPX , No UPX

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_PASSWORD, Password
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w190 vGUI_OUT_PASS Password , %OUT_PASS%
	Gui , Add , Button , x+20 yp-1 h22 gGUI_GEN_PWD vGUI_Generate, &Generate
	Gui , Add , Checkbox , x+20 yp Checked%SHOW_PASS% vGUI_SHOW_PASS gGuiShowPwd , Show
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_RUN_BEFORE , Run Before
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGUI_RUN_BEFORE , %RUN_BEFORE%
	Gui , Add , Button , x+20 yp-1 h22 w70 gGuiBTRunBefore vGUI_SELECT_RUN_BEFORE , Select

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_RUN_AFTER , Run After
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGUI_RUN_AFTER , %RUN_AFTER%
	Gui , Add , Button , x+20 yp-1 h22 w70 gGuiBTRunAfter vGUI_SELECT_RUN_AFTER , Select

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_VISTA_UAC , Vista UAC
	Gui , Add , Text , x+20 yp w100 h20 vGUI_TEXT_EXEC_LEVEL , Execution Level:
	Gui , Add , DropDownList , x+20 yp w160 AltSubmit Choose%EXEC_LEVEL% vGUI_EXEC_LEVEL , none||asInvoker|highestAvailable|requireAdministrator
	Gui , Add , Button , x+20 yp-1 w70 h22 vGUI_UAC_HELP gEXEC_LEVEL_HELP , &Help
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGUI_TEXT_OTHER_OPTIONS, Other Options
	Gui , Add , Checkbox , x+20 yp w210 h20 vGUI_NO_DECOMPILE Checked%NO_DECOMPILE% , NoDecompile (AHK v1.0.46.10+)
	Gui , Add , Checkbox , x+20 yp w160 h20 vGUI_CREATED_DATE Checked%CREATED_DATE% , New file creation date

	Gui , Tab , 2
	Gui , Add , Checkbox , x+20 y+10 gGUI_CB_VI vGUI_VERSION_INFO Checked%VERSION_INFO% , Set Version Info

	Gui , Font , cNavy
	Gui , Add , Text , Section xp y+10 h20 w120 +0x1000 vGUI_TEXT_COMPANY_NAME , Company Name
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_COMPANY_NAME , %COMPANY_NAME%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_FILE_DESC , File Description
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_FILE_DESC , %FILE_DESC%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_FILE_VER , File Version
	Gui , Font , cBlack
	Gui , Add , Edit , Center x+20 yp h20 w50 vGUI_TFV1 , 
	Gui , Add , Updown , vGUI_FV1 Range0-999 , %GUI_FV1%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TFV2 , 
	Gui , Add , Updown , vGUI_FV2 Range0-999 , %GUI_FV2%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TFV3 , 
	Gui , Add , Updown , vGUI_FV3 Range0-999 , %GUI_FV3%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TFV4 , 
	Gui , Add , Updown , vGUI_FV4 Range0-999 , %GUI_FV4%
	Gui , Add , Checkbox , x+20 gGUI_CB_INC vGUI_INC_FILE_VER Checked%INC_FILE_VER% , Autoincrement

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_INTERNAL_NAME , Internal Name
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_INTERNAL_NAME , %INTERNAL_NAME%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_LEGAL_COPYRIGHT , Legal Copyright
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_LEGAL_COPYRIGHT , %LEGAL_COPYRIGHT%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_ORG_FILENAME , Original File Name
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_ORG_FILENAME , %ORG_FILENAME%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_PRODUCT_NAME , Product Name
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGUI_PRODUCT_NAME , %PRODUCT_NAME%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGUI_TEXT_PROD_VER , Product Version
	Gui , Font , cBlack
	Gui , Add , Edit , Center x+20 yp h20 w50 vGUI_TPV1 , 
	Gui , Add , Updown , vGUI_PV1 Range0-999 , %GUI_PV1%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TPV2 , 
	Gui , Add , Updown , vGUI_PV2 Range0-999 , %GUI_PV2%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TPV3 , 
	Gui , Add , Updown , vGUI_PV3 Range0-999 , %GUI_PV3%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGUI_TPV4 , 
	Gui , Add , Updown , vGUI_PV4 Range0-999 , %GUI_PV4%
	Gui , Add , Checkbox , yp-3 x+20 gGUI_CB_SAV vGUI_SET_AHK_VERSION Checked%SET_AHK_VERSION% , Set to AHK version
	Gui , Add , Checkbox , xp yp+16 gGUI_CB_INC vGUI_INC_PROD_VER Checked%INC_PROD_VER% , Autoincrement

	Gui , Font , cNavy
	Gui , Add , Text , xs y+7 h20 w120 +0x1000 vGUI_TEXT_LANG_ID , Language ID
	Gui , Font , cBlack
	Gui , Add , DropDownList , x+20 w200 yp AltSubmit Choose%LANG_ID% vGUI_LANG_ID , %LANG_IDS%
	Gui , Font , cNavy
	Gui , Add , Text , xs y+7 h20 w120 +0x1000 vGUI_TEXT_CHARSET , Charset
	Gui , Font , cBlack
	Gui , Add , DropDownList , x+20 w200 yp AltSubmit Choose%CHARSET% vGUI_CHARSET , %CHARSETS%


	Gui , Tab , 3
	Gui , Font , cNavy
	Gui , Add , Text , Section x+20 y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_1 , Main Icon
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_1_SET gGuiActivateIcon Checked%ICON_1_SET%
	Gui , Font , cBlack
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_1 gGuiEDIcon , %ICON_1%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_1_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_1_PIC , %ICON_1%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_2 , Shortcut Icon
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_2_SET gGuiActivateIcon Checked%ICON_2_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_2 gGuiEDIcon , %ICON_2%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_2_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_2_PIC , %ICON_2%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_3 , Suspend Icon
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_3_SET gGuiActivateIcon Checked%ICON_3_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_3 gGuiEDIcon , %ICON_3%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_3_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_3_PIC , %ICON_3%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_4 , Pause Icon
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_4_SET gGuiActivateIcon Checked%ICON_4_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_4 gGuiEDIcon , %ICON_4%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_4_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_4_PIC , %ICON_4%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_5 , Suspend/Pause Icon
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_5_SET gGuiActivateIcon Checked%ICON_5_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_5 gGuiEDIcon , %ICON_5%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_5_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_5_PIC , %ICON_5%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_6 , Main Icon Win9x
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_6_SET gGuiActivateIcon Checked%ICON_6_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_6 gGuiEDIcon , %ICON_6%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_6_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_6_PIC , %ICON_6%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+20 h20 w130 +0x1000 vGUI_TEXT_ICON_7 , Suspend Icon Win9x
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGUI_ICON_7_SET gGuiActivateIcon Checked%ICON_7_SET%
	Gui , Add , Edit , x+0 yp h20 w190 vGUI_ICON_7 gGuiEDIcon , %ICON_7%
	Gui , Add , Button , x+20 yp h20 w70 vGUI_ICON_7_BT gGuiBTSelIcon , Select
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGUI_ICON_7_PIC , %ICON_7%

	Gui , Tab
	Gui , Add , Button , Default xs y370 h25 w70 vGUI_COMPILE gGuiBTCompile , &Compile
	Gui , Add , Button , xp+440 yp h25 w70 vGUI_ABORT gGuiClose , &Abort

	Gui , Add , Picture , xm+374 ym+4 h16 w16 hidden vGUI_ON_TOP gGUI_ON_TOP_OFF AltSubmit Icon6 , %A_ScriptName%
	Gui , Add , Picture , xm+374 ym+4 h16 w16 vGUI_ON_TOP_OFF gGUI_ON_TOP AltSubmit Icon7 , %A_ScriptName%

	Gui , Add , Button , xm+394 ym h23 w100 vGUI_SAVEDEFAULTS gGuiSaveDefaults , &Save Defaults
	Gui , Add , Button , xm+494 ym h23 w60 vGUI_CREDITS gShowCredits , C&redits

	GoSub , GUI_CB_INC
	GoSub , GUI_CB_SAV

	If (!VERSION_INFO) {
		_GUI_VERS_INFO("Disable")
	}

	GoSub , GuiShowPwd
	GoSub , GuiActivateIcon
	GoSub , GuiActivateAltBin
	If AUTO_COMPILE
		GoSub , GuiBTCompile
	Else
	{
		GoSub , CreateToolTips
		Gui , Show , Autosize , %GUI_TITLE% - %IN_NAME%.%IN_EXT%
	}		
	GuiControl , Focus , Compile
Return
; --------------------------------------------------------------------------------
; Gui Close
; --------------------------------------------------------------------------------
GuiClose:
GuiEscape:
	Gui , Destroy
	ERR_MSG := "Compilation aborted!"
	_ERROR_EXIT(ERR_MSG)
Return
; --------------------------------------------------------------------------------
; Gui 2 Close
; --------------------------------------------------------------------------------
2GuiEscape:
2GuiClose:
	Gui 1:-Disabled
	Gui 2:Destroy
Return
; --------------------------------------------------------------------------------
; Gui Drop Files
; --------------------------------------------------------------------------------
GuiDropFiles:
Gui , Submit , NoHide
IfInString , A_GuiControl , GUI_ICON_
	IfNotInString , A_GuiControl , _SET
		GuiControl , , %A_GuiControl% , %A_GuiEvent%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Exe File
; --------------------------------------------------------------------------------
GuiBTSelFile:
	Gui , Submit , NoHide
	SplitPath , GUI_OUT_FILE , OUT_NAME , OUT_DIR
	_SELECT_FOLDER(OUT_DIR)
	GuiControl , , GUI_OUT_FILE , %OUT_DIR%\%OUT_NAME%
Return
; --------------------------------------------------------------------------------
; Gui Save Default Settings
; --------------------------------------------------------------------------------
GuiSaveDefaults:
	Gui , Submit , NoHide
	If Not _GET_GUI_VALUES() {
		Return
	}
	Button1Name = AppData
	Button2Name = Compile_AHK
	Button3Name = Cancel
	MsgBoxTitle = Choice required
	MsgBoxText = Do you want to save the defaults in the current user's AppData folder or in the folder of Compile_AHK.exe?
	SetTimer , ChangeButtonNames , 50
	MsgBox , 51 , %MsgBoxTitle% , %MsgBoxText%
	IfMsgBox , Yes
		_WRITE_INI(USER_DEFAULTS_INI)
	Else IfMsgBox , No
		_WRITE_INI(GLOBAL_DEFAULTS_INI)
Return

; --------------------------------------------------------------------------------
; Gui OnTop On
; --------------------------------------------------------------------------------

GUI_ON_TOP:
	Gui , +AlwaysOnTop
	
	GuiControl , Hide , GUI_ON_TOP_OFF
	GuiControl , Show , GUI_ON_TOP
Return
; --------------------------------------------------------------------------------
; Gui OnTop Off
; --------------------------------------------------------------------------------
GUI_ON_TOP_OFF:
	Gui , -AlwaysOnTop
	
	GuiControl , Hide , GUI_ON_TOP
	GuiControl , Show , GUI_ON_TOP_OFF
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiActivateIcon:
	Gui , Submit , NoHide
	Loop , %ICONCOUNT% {
		TempControlName = GUI_ICON_%A_Index%_SET
		If (%TempControlName%) {
			; enable
			GuiControl , Enable , GUI_ICON_%A_Index%
			GuiControl , Enable , GUI_ICON_%A_Index%_BT
		} Else {
			; disable
			GuiControl , Disable , GUI_ICON_%A_Index%
			GuiControl , Disable , GUI_ICON_%A_Index%_BT
			GuiControl , , GUI_ICON_%A_Index% , 
			GuiControl , , GUI_ICON_%A_Index%_PIC , 
		}
	}
Return

GuiActivateAltBin:
	Gui , Submit , NoHide
	If (GUI_ALT_BIN_SET)
	{
		; enable
		GuiControl , Enable , GUI_ALT_BIN
		GuiControl , Enable , GUI_SELECT_ALT_BIN
	}
	Else
	{
		; disable
		GuiControl , Disable , GUI_ALT_BIN
		GuiControl , Disable , GUI_SELECT_ALT_BIN
		GuiControl , , GUI_ALT_BIN
	}
Return
; --------------------------------------------------------------------------------
; Gui Button Generate Password
; --------------------------------------------------------------------------------
GUI_GEN_PWD:
	GuiControl , , GUI_OUT_PASS , % GenPassword()
Return
; --------------------------------------------------------------------------------
; Password Generator by Titan / www.autohotkey.net
; --------------------------------------------------------------------------------
GenPassword(l=30, chars=3)
{
	cAlpha = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
	cNum = 1234567890
	cAlphaNum = %cAlpha%%cNum%
	cMutation = ??ü?é???àè??ù??????????????
	cMixed = %cAlphaNum%%cMutation%.%A_Space%!"£$`%^&*()_-=+{}[]`;:``@'#~<>,./?\|¬¦
	If chars in 0,alphanum
		StringSplit , list , cAlphaNum
	else If chars in 1,alpha
		StringSplit , list , cAlpha
	else If chars in 2,num
		StringSplit , list , cNum
	else If chars in 3,mixed
		StringSplit , list , cMixed
	Random , rnd , 0 , %list0%
	l += rnd
	Loop , %l%
	{
		Random , rnd , 1 , %list0%
		i := list%rnd%
		pass = %pass%%i%
	}
	Return , %pass%
}
; --------------------------------------------------------------------------------
; Gui Button Select AutoHotkey.bin
; --------------------------------------------------------------------------------
GuiBTSelBin:
	Gui , Submit , NoHide
	_SELECT_FILE(GUI_ALT_BIN , "BIN")
	GuiControl , , GUI_ALT_BIN , %GUI_ALT_BIN%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiBTSelIcon:
	Gui , Submit , NoHide
	SourceFileName := "GUI_ICON_" . SubStr(A_GuiControl , -3 , 1)
	SourceFile := %SourceFileName%
	
	ERR_MSG := "Error selecting icon file!`n"
	
	If (SourceFile = "" || !FileExist(SourceFile))
		SourceFile = %A_WinDir%\system32\shell32.dll
	nIndex := 0

	WinGet , hWnd , ID , PickIconDlg

	VarSetCapacity(wSourceFile , 260 * 2)
	DllCall("MultiByteToWideChar" , "Uint" , 0 , "Uint" , 0 , "str" , SourceFile , "int" , -1 , "str" , wSourceFile , "int" , 260)

	If !DllCall("shell32\PickIconDlg" , "Uint" , hWnd , "str" , wSourceFile , "Uint" , 260 , "intP" , nIndex)
		Return ; cancel was clicked or something else failed
	
	VarSetCapacity(SourceFile , 260)
	DllCall("WideCharToMultiByte" , "Uint" , 0 , "Uint" , 0 , "str" , wSourceFile , "int" , -1 , "str" , SourceFile , "int" , 260 , "Uint" , 0 , "Uint" , 0)
	
	StringReplace , SourceFile , SourceFile , `%SystemRoot`% , %A_WinDir%
	
	IconFile := IN_FILE . "_" . SubStr(A_GuiControl , -3 , 1) . ".ico"
	SplitPath , IconFile , IconFileName
	
	SplitPath , SourceFile , , SourceFileDir , SourceFileExt
	If (SourceFileExt = "ICO")
	{
		If (SourceFileDir = IN_DIR)
			IconFile := SourceFile
		Else
		{
			Button1Name = &Use original
			Button2Name = &Create copy
			MsgBoxTitle = Choice required
			MsgBoxText = Do you want to use the icon from its original folder or create a copy in your script's folder and use the copy (recommended)? 
			SetTimer , ChangeButtonNames , 50
			MsgBox , 289 , %MsgBoxTitle% , %MsgBoxText%
			IfMsgBox , OK
			{
				IconFile := SourceFile
			}
			Else
			{
				IfExist , %IconFile%
				{
					Button1Name = &Replace
					Button2Name = Re&name
					Button3Name = Cancel
					MsgBoxTitle = Choice required
					MsgBoxText = %IconFileName% already exists.`nDo you want to replace or rename it?
					SetTimer , ChangeButtonNames , 50
					MsgBox , 51 , %MsgBoxTitle% , %MsgBoxText%
					IfMsgBox , Cancel
						Return
					IfMsgBox , No
						Loop
						{
							StringReplace , NewIconFile , IconFile , .ico , _%A_Index%.ico
							IfExist , %NewIconFile%
								Continue
							IconFile := NewIconFile
							Break
						}
				}
					; IfMsgBox = Yes / No -->
					FileCopy , %SourceFile% , %IconFile% , 1
					If (ErrorLevel)
					{
						s_ERR := "Replacing " . IconFile . " by " . SourceFile . " failed!"
						_ERROR_EXIT(ERR_MSG . s_ERR)
					}
			}
		}
	}
	Else
	{
		IfExist , %IconFile%
		{
			Button1Name = &Replace
			Button2Name = Re&name
			Button3Name = Cancel
			MsgBoxTitle = Choice required
			MsgBoxText = %IconFileName% already exists.`nDo you want to replace or rename it?
			SetTimer , ChangeButtonNames , 50
			MsgBox , 51 , %MsgBoxTitle% , %MsgBoxText%
			IfMsgBox , Cancel
				Return
			IfMsgBox , No
				Loop
				{
					StringReplace , NewIconFile , IconFile , .ico , _%A_Index%.ico
					IfExist , %NewIconFile%
						Continue
					IconFile := NewIconFile
					Break
				}
		}
		
		; ResHacker uses ResourceIds instead of IconIndex
		IconGroupID := ResourceIdOfIcon(SourceFile , nIndex)
	
		s_SC_FILE := A_WorkingDir . "\ExtractIcon.cfg"
		
		s_SCRIPT := "[FILENAMES]`n"
				. "Exe=" . SourceFile . "`n"
				. "SaveAs=" . IconFile . "`n"
				. "Log=" . A_WorkingDir . "\" . RES_LOG . "`n"
				. "[COMMANDS]`n"
				. "-extract """ . IconFile . """ , ICONGROUP , " . IconGroupID . " , "
	
		FileDelete , %s_SC_FILE%
		FileAppend , %s_SCRIPT% , %s_SC_FILE%
		
		s_CMD := """" . A_ScriptDir . "\" RES_EXE . """"
				. " -script "
				. """" . s_SC_FILE . """"
		
		FileAppend , `n* Extract Icon from file:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
		RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
		If Errorlevel
		{
			FileRead , s_LOG , A_WorkingDir . "\" . %RES_LOG%
			s_ERR := "Couldn't extract icon file , " . RES_EXE . " failed!`n" . s_LOG
			_ERROR_EXIT(ERR_MSG . s_ERR)
		}
		FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
		IfInString , s_Log , ERROR:
		{
			s_ERR := "Couldn't extract icon file , " . RES_EXE . " failed!`n" . s_LOG
			_ERROR_EXIT(ERR_MSG . s_ERR)
		}
		FileDelete , %A_WorkingDir%\%RES_LOG%
		FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest extracted successfully!`n`n , %A_WorkingDir%\%LOG_FILE%
	}

	GuiControl , , %SourceFileName% , %IconFile%
Return
; --------------------------------------------------------------------------------
; Change Button Names
; --------------------------------------------------------------------------------
ChangeButtonNames:
	IfWinNotExist , %MsgBoxTitle%
		Return ; Keep waiting.
	SetTimer , ChangeButtonNames , off 
	WinActivate 
	ControlSetText , Button1 , %Button1Name%
	ControlSetText , Button2 , %Button2Name%
	ControlSetText , Button3 , %Button3Name%
Return
; --------------------------------------------------------------------------------
; Gui Edit Icon
; --------------------------------------------------------------------------------
GuiEDIcon:
	Gui , Submit , NoHide
	SourceFile := %A_GuiControl%

	If (CHECK_ICON(SourceFile))
		GuiControl , , %A_GuiControl%_PIC , *w32 *h32 %SourceFile%
	Else
		GuiControl , , %A_GuiControl%_PIC
Return
; --------------------------------------------------------------------------------
; Gui Button Select Show or Hide Password
; --------------------------------------------------------------------------------
GuiShowPwd:
	Gui , Submit , NoHide
	If (GUI_SHOW_PASS)
		GuiControl , -Password , GUI_OUT_PASS
	Else
		GuiControl , +Password , GUI_OUT_PASS
	GuiControl , Focus , GUI_OUT_PASS
Return
; --------------------------------------------------------------------------------
; Gui Button Select Run Before
; --------------------------------------------------------------------------------
GuiBTRunBefore:
	Gui , Submit , NoHide
	_SELECT_FILE(GUI_RUN_BEFORE , "RUN")
	GuiControl , , GUI_RUN_BEFORE , %GUI_RUN_BEFORE%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Run After
; --------------------------------------------------------------------------------
GuiBTRunAfter:
	Gui , Submit , NoHide
	_SELECT_FILE(GUI_RUN_AFTER , "RUN")
	GuiControl , , GUI_RUN_AFTER , %GUI_RUN_AFTER%
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Version Info
; --------------------------------------------------------------------------------
GUI_CB_VI:
	Gui , Submit , NoHide
	If (GUI_VERSION_INFO) {
		_GUI_VERS_INFO("Enable")
	} Else {
		_GUI_VERS_INFO("Disable")
	}
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Set AHK Version
; --------------------------------------------------------------------------------
GUI_CB_SAV:
	Gui , Submit , NoHide
	If (GUI_SET_AHK_VERSION) {
		GuiControl , Disable , GUI_INC_PROD_VER
		GuiControl , , GUI_INC_PROD_VER , 0
		;split AHK_Version to four values
		StringSplit , a_V , s_OrgComp , .
		Loop , %a_V0%
		{
			GuiControl , Disable , GUI_TPV%A_Index%
			Value := a_V%A_Index%
			GuiControl , , GUI_TPV%A_Index% , %Value%
		}
	} Else {
		GuiControl , Enable , GUI_INC_PROD_VER
		If (!GUI_INC_PROD_VER)
			Loop , %a_V0%
				GuiControl , Enable , GUI_TPV%A_Index%
	}
Return
; --------------------------------------------------------------------------------
; Gui Autoincrement Version
; --------------------------------------------------------------------------------
GUI_CB_INC:
	Gui , Submit , NoHide
	
	;split Prod_Version and File_Version to four values
	StringSplit , a_PV , PRODUCT_VER , .
	StringSplit , a_FV , FILE_VER , .
	
	If (A_GuiControl = "GUI_INC_PROD_VER" || A_GuiControl = "")
	If (GUI_INC_PROD_VER)
	{
		
		GuiControl , Disable , GUI_SET_AHK_VERSION
		GuiControl , , GUI_SET_AHK_VERSION , 0
		increment = 1
		Loop %a_PV0%
		{
			ReverseIndex := 5 - A_Index
			GuiControl , Disable , GUI_TPV%ReverseIndex%
			
			;Set old version's value
			Value := a_PV%ReverseIndex%
			
			If (increment)
			{
				If Value = 999
					GuiControl , , GUI_TPV%ReverseIndex% , 0
				Else
				{
					Value++
					GuiControl , , GUI_TPV%ReverseIndex% , %Value%
					increment = 0
				}
			}
			Else
				GuiControl , , GUI_TPV%ReverseIndex% , %Value%
		}
	}
	Else {
		GuiControl , Enable , GUI_SET_AHK_VERSION
		Loop , %a_PV0%
			GuiControl , Enable , GUI_TPV%A_Index%
	}
	
	If (A_GuiControl = "GUI_INC_FILE_VER" || A_GuiControl = "")
	If (GUI_INC_FILE_VER)
	{
		increment = 1
		Loop %a_FV0%
		{
			ReverseIndex := 5 - A_Index
			GuiControl , Disable , GUI_TFV%ReverseIndex%
			
			;Set old version's value
			Value := a_FV%ReverseIndex%
			
			If (increment)
			{
				If Value = 999
					GuiControl , , GUI_TFV%ReverseIndex% , 0
				Else
				{
					Value++
					GuiControl , , GUI_TFV%ReverseIndex% , %Value%
					increment = 0
				}
			}
			Else
				GuiControl , , GUI_TFV%ReverseIndex% , %Value%
		}
	}
	Else
		Loop , %a_FV0%
			GuiControl , Enable , GUI_TFV%A_Index%
Return
; ================================================================================
; FUNCTIONS SECTION ==============================================================
; ================================================================================
; Check AHK Compiler Version
; --------------------------------------------------------------------------------
_CHECK_AHK()
{
	Global
	Local s_UsedComp , s_OrgUPX , s_UsedUPX
	FileGetVersion , s_OrgComp , %AHK_COMPILER_DIR%\%COMPILER%
	FileGetVersion , s_UsedComp , %A_WorkingDir%\%COMPILER%
	If (s_OrgComp <> s_UsedComp) {
		FileCopy , %AHK_COMPILER_DIR%\%COMPILER% , %A_WorkingDir%\%COMPILER% , 1
		If (Errorlevel) {
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new " . COMPILER)
		}
	}
	FileGetVersion , s_OrgUPX , %AHK_COMPILER_DIR%\%UPX_EXE%
	FileGetVersion , s_UsedUPX , %A_WorkingDir%\%UPX_EXE%
	If (s_OrgUPX <> s_UsedUPX) {
		FileCopy , %AHK_COMPILER_DIR%\%UPX_EXE% , %A_WorkingDir%\%UPX_EXE% , 1
		If (Errorlevel) {
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new " . UPX_EXE)
		}
	}
	FileCopy , %AHK_COMPILER_DIR%\%BIN_FILE% , %A_WorkingDir%\%BIN_FILE% , 1
	If (Errorlevel) {
		_ERROR_EXIT(ERR_MSG . "Couldn't copy """ . AHK_COMPILER_DIR . "\" . BIN_FILE . """ to """ . A_WorkingDir . """.")
	}
	Return
}
; --------------------------------------------------------------------------------
; Get IconGroupID / ResourceID from IconIndex
; --------------------------------------------------------------------------------
ResourceIdOfIcon(Filename , IconIndex)
{
	hmod := DllCall("GetModuleHandle" , "str" , Filename)
	; If the DLL isn't already loaded , load it as a data file.
	loaded := !hmod
	&& hmod := DllCall("LoadLibraryEx" , "str" , Filename , "uint" , 0 , "uint" , 0x2)

	if !hmod
		Return

	enumproc := RegisterCallback("ResourceIdOfIcon_EnumIconResources" , "F")
	VarSetCapacity(param , 12 , 0) , NumPut(IconIndex , param , 0)
	; to work with enabled DEP --> http://www.autohotkey.com/forum/viewtopic.php?t=25480
	DllCall("VirtualProtect", "uint", enumproc, "uint", 8, "uint", 0x40, "uint*", 0)
	; Enumerate the icon group resources. (RT_GROUP_ICON=14)
	DllCall("EnumResourceNames" , "uint" , hmod , "uint" , 14 , "uint" , enumproc , "uint" , &param)
	DllCall("GlobalFree" , "uint" , enumproc)

	; If we loaded the DLL , free it now.
	if loaded
		DllCall("FreeLibrary" , "uint" , hmod)

	Return NumGet(param , 8) ? NumGet(param , 4) : ""
}

ResourceIdOfIcon_EnumIconResources(hModule , lpszType , lpszName , lParam)
{
	Index := NumGet(lParam+4)
	if (Index = NumGet(lParam+0))
	{	; for named resources , lpszName might not be valid once we Return (?)
		; if (lpszName >> 16 == 0) , lpszName is an integer resource ID.
		NumPut(lpszName , lParam+4)
		NumPut(1 , lParam+8)
		Return false ; break
	}
	NumPut(Index+1 , lParam+4)
	Return true
}
; --------------------------------------------------------------------------------
; Check for valid Icon Path
; --------------------------------------------------------------------------------
CHECK_ICON(sPATH)
{
	Global
	Local sEXT
	SplitPath , sPATH , , , sEXT
	If (sEXT = "ICO") {
		If (FileExist(sPATH)) {
			Return True
		}
	}
	Return False
}
; --------------------------------------------------------------------------------
; Show Credits
; --------------------------------------------------------------------------------
ShowCredits:
	WinH = 100			; Height of GUI
	YPos1 := WinH - 8	; Bottom of GUI Window
	YPos2 := YPos1 + 40	; Gap
	YPos3 := YPos2 + 48
	YPos4 := YPos3 + 48
	YPos5 := YPos4 + 48
	YPos6 := YPos5 + 48
	YPos7 := YPos6 + 48
	YPos8 := YPos7 + 48
	YPos9 := YPos8 + 64

	MoreText =
	(LTrim
		This will go on for a while.`n
		Believe me.`n
		It's not worth reading on.`n
		C'mon - quit now.`n
		Close the gui`n
		Hello?`n`n
		It's useless reading on.`n`n
		Oh look how nice it scrolls!`n
		So you wanted it.`n
		I'll close the gui for you.`n`n`n`n
		BYE !
	)
	Gui 2:+owner1
	Gui +Disabled
	Gui 2:+ToolWindow +AlwaysOnTop
	Gui 2:Margin, 0, 0
	
	Gui, 2:Font, bold
	Gui 2:Add, Text , x12 vText_1 y%YPos1% , .:[ Compile_AHK ]:.
	Gui, 2:Font, norm
	
	Gui 2:Add, Picture, vIcon1 x12 y%YPos2% h32 w32 Icon13, shell32.dll
	Gui 2:Add, Text, vURL_1 gOpenLink x48, AutoHotkey by Chris
	
	Gui 2:Add, Picture, vIcon2 x12 y%YPos3% h32 w32 Icon174, shell32.dll
	Gui 2:Add, Text, vURL_2 gOpenLink x48, Developed by de/nick
	
	Gui 2:Add, Picture, vIcon3 x12 y%YPos4% h32 w32 Icon1, %A_ScriptFullPath%
	Gui 2:Add, Text, vURL_3 gOpenLink x48, Enhanced by ladiko
	
	Gui 2:Add, Picture, vIcon4 x12 y%YPos5% h32 w32 Icon172, shell32.dll
	Gui 2:Add, Text, vURL_4 gOpenLink x48, Debugged by jfk001
	
	Gui 2:Add, Picture, vIcon5 x12 y%YPos6% h32 w32 Icon142, shell32.dll
	Gui 2:Add, Text, vURL_5 gOpenLink x48, Graphics by Titan
	
	Gui 2:Add, Picture, vIcon6 x12 y%YPos7% h32 w32 Icon98, shell32.dll
	Gui 2:Add, Text, vURL_6 gOpenLink x48, Credits GUI by AGU && Laszlo
	
	Gui 2:Add, Picture, vIcon7 x12 y%YPos8% h32 w32 Icon14, shell32.dll
	Gui 2:Add, Text, vURL_7 gOpenLink x48, Help by The Community
	
	Gui 2:Add, Text, vText_2 x12 y%YPos9%, %MoreText%
	
	Gui 2:Show, w200 h%WinH%, Credits:
	
	; Retrieve scripts PID
	Process, Exist
	pid_this := ErrorLevel
 
	; Retrieve unique ID number (HWND/handle)
	WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
 
	; Call "HandleMessage" when script receives WM_SETCURSOR message
	WM_SETCURSOR = 0x20
	OnMessage(WM_SETCURSOR, "HandleMessage")
 
	; Call "HandleMessage" when script receives WM_MOUSEMOVE message
	WM_MOUSEMOVE = 0x200
	OnMessage(WM_MOUSEMOVE, "HandleMessage")

	Loop
	{
		IfWinNotExist , Credits:
			Break
		YPos1--
		GuiControl 2:Move, Text_1, y%YPos1%
		YPos2--
		GuiControl 2:Move, Icon1, y%YPos2%
		GuiControl 2:Move, URL_1, y%YPos2%
		YPos3--
		GuiControl 2:Move, Icon2, y%YPos3%
		GuiControl 2:Move, URL_2, y%YPos3%
		YPos4--
		GuiControl 2:Move, Icon3, y%YPos4%
		GuiControl 2:Move, URL_3, y%YPos4%
		YPos5--
		GuiControl 2:Move, Icon4, y%YPos5%
		GuiControl 2:Move, URL_4, y%YPos5%
		YPos6--
		GuiControl 2:Move, Icon5, y%YPos6%
		GuiControl 2:Move, URL_5, y%YPos6%
		YPos7--
		GuiControl 2:Move, Icon6, y%YPos7%
		GuiControl 2:Move, URL_6, y%YPos7%
		YPos8--
		GuiControl 2:Move, Icon7, y%YPos8%
		GuiControl 2:Move, URL_7, y%YPos8%
		YPos9--
		GuiControl 2:Move, Text_2, y%YPos9%
		
		GuiControlGet Text_2, 2:Pos
		If (Text_2Y + Text_2H < WinH)
			Break
		Sleep 50
	}
	
	Sleep 1000
	Gui 1:-Disabled
	Gui 2:Destroy
Return
; --------------------------------------------------------------------------------
; URL gLabels
; --------------------------------------------------------------------------------
OpenLink:
	If A_GuiControl = URL_1
		Run, http://www.autohotkey.com
	Else If A_GuiControl = URL_2
		Run, http://www.autohotkey.com/forum/topic14379.html
	Else If A_GuiControl = URL_3
		Run, http://www.autohotkey.com/forum/topic22975.html
	Else If A_GuiControl = URL_4
		Run, jfk001
	Else If A_GuiControl = URL_5
		Run, http://www.autohotkey.net
	Else If A_GuiControl = URL_6
		Run, http://www.autohotkey.com/forum/post-40027.html
	Else If A_GuiControl = URL_7
		Run, http://www.autohotkey.com/forum/
Return
; --------------------------------------------------------------------------------
; URL Function
; --------------------------------------------------------------------------------
HandleMessage(p_w, p_l, p_m, p_hw)
{
	global	 WM_SETCURSOR, WM_MOUSEMOVE,
	static	 URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl
 
	If (p_m = WM_SETCURSOR)
	{
		If URL_hover
			Return, true
	}
	Else If (p_m = WM_MOUSEMOVE)
	{
		; Mouse cursor hovers URL text control
		StringLeft, CtrlIsURL, A_GuiControl, 3
		If (CtrlIsURL = "URL")
			{
				If URL_hover=
				{
					Gui, Font, cBlue underline
					GuiControl, Font, %A_GuiControl%
					LastCtrl = %A_GuiControl%
				 
					h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
				 
					URL_hover := true
				}
				h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
			}
		; Mouse cursor doesn't hover URL text control
		Else
		{
			If URL_hover
			{
				Gui, Font, norm cBlack
				GuiControl, Font, %LastCtrl%
			 
				DllCall("SetCursor", "uint", h_old_cursor)
			 
				URL_hover=
			}
		}
	}
}
; --------------------------------------------------------------------------------
; Read INI file
; --------------------------------------------------------------------------------
_READ_INI(s_INI_FILE)
{
	Global
	Local s_INI
	ERR_MSG := "Error processing INI File!`n" . s_INI_FILE . "`n"
	If (s_INI_FILE != USER_DEFAULTS_INI) {
		IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , OUT_FILE , ERROR
		If (s_INI != "ERROR") {
			SplitPath , s_INI , , , s_EXT
			If (s_EXT = "exe") {
				StringReplace , s_INI , s_INI , `%IN_DIR`% , %IN_DIR%
				OUT_FILE := s_INI
			}
		}
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , ALT_BIN , ERROR
	If (s_INI != "ERROR") {
		StringReplace , s_INI , s_INI , `%IN_DIR`% , %IN_DIR%
		If FileExist(s_INI)
		{
			ALT_BIN := s_INI
			ALT_BIN_SET := 1
		}
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , COMPRESSION , ERROR
	If s_INI Between 0 and 4
	{
		COMPRESSION := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , NO_UPX , ERROR
	If s_INI In 0,1
	{
		NO_UPX := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , OUT_PASS , ERROR
	If (s_INI != "ERROR") {
		OUT_PASS := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , SHOW_PASS , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_ERROR_EXIT(ERR_MSG . "SHOW_PASS = " . s_INI)
			Return
		}
		SHOW_PASS := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , NO_DECOMPILE , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_ERROR_EXIT(ERR_MSG . "NO_DECOMPILE = " . s_INI)
			Return
		}
		NO_DECOMPILE := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , CREATED_DATE , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_ERROR_EXIT(ERR_MSG . "CREATED_DATE = " . s_INI)
			Return
		}
		CREATED_DATE := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , RUN_BEFORE , ERROR
	If (s_INI != "ERROR") {
		RUN_BEFORE := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , RUN_AFTER , ERROR
	If (s_INI != "ERROR") {
		RUN_AFTER := s_INI
	}
	IniRead , s_INI , %s_INI_FILE% , %AHK_SECTION% , EXEC_LEVEL , ERROR
	If (s_INI != "ERROR") {
		EXEC_LEVEL := s_INI
	}

	Loop , %ICONCOUNT%
	{
		/*
		IniRead , s_INI , %s_INI_FILE% , %ICO_SECTION% , ICON_%A_Index%_SET , ERROR
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
		*/
		IniRead , s_INI , %s_INI_FILE% , %ICO_SECTION% , ICON_%A_Index% , ERROR
		If (s_INI != "ERROR") {
			StringReplace , s_INI , s_INI , `%IN_DIR`% , %IN_DIR%
			If FileExist(s_INI)
			{
				ICON_%A_Index% := s_INI
				ICON_%A_Index%_SET := 1
			}
		}
	}

	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , VERSION_INFO , ERROR
	If (s_INI = "ERROR") {
		Return
	}
	If s_INI Not In 0,1
	{
		_ERROR_EXIT(ERR_MSG . "VERSION_INFO = " . s_INI)
		Return
	}

	VERSION_INFO := s_INI
	If !VERSION_INFO {
		Return
	}
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , COMPANY_NAME , ERROR
	If (s_INI != "ERROR") {
		COMPANY_NAME := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , FILE_DESC , ERROR
	If (s_INI != "ERROR") {
		FILE_DESC := s_INI
	}

	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , FILE_VER , ERROR
	If (s_INI != "ERROR") {
		FILE_VER := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , INC_FILE_VER , ERROR
	If (s_INI != "ERROR") {
		INC_FILE_VER := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , INTERNAL_NAME , ERROR
	If (s_INI != "ERROR") {
		INTERNAL_NAME := s_INI
	}

	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , LEGAL_COPYRIGHT , ERROR
	If (s_INI != "ERROR") {
		LEGAL_COPYRIGHT := s_INI
	}

	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , ORG_FILENAME , ERROR
	If (s_INI != "ERROR") {
		ORG_FILENAME := s_INI
	}

	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , PRODUCT_NAME , ERROR
	If (s_INI != "ERROR") {
		PRODUCT_NAME := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , PRODUCT_VER , ERROR
	If (s_INI != "ERROR") {
		PRODUCT_VER := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , SET_AHK_VERSION , ERROR
	If (s_INI != "ERROR") {
		SET_AHK_VERSION := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , INC_PROD_VER , ERROR
	If (s_INI != "ERROR") {
		INC_PROD_VER := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , LANG_ID , ERROR
	If (s_INI != "ERROR") {
		LANG_ID := s_INI
	}
	
	IniRead , s_INI , %s_INI_FILE% , %RES_SECTION% , CHARSET , ERROR
	If (s_INI != "ERROR") {
		CHARSET := s_INI
	}
	Return
}
; --------------------------------------------------------------------------------
; Write INI file
; --------------------------------------------------------------------------------
_WRITE_INI(s_INI_FILE)
{
	Global
	ERR_MSG := "Error writing INI File!`n" . s_INI_FILE . "`n"
	SplitPath , s_INI_FILE , , s_INI_OUTDIR
	IfNotExist , %s_INI_OUTDIR%
	{
		FileCreateDir , %s_INI_OUTDIR%
		If ErrorLevel
			_ERROR(ERR_MSG . "`nCould not create the folder """ . s_INI_OUTDIR . """")
	}
	IfExist , %s_INI_FILE%
	{
		FileDelete , %s_INI_FILE%
		If ErrorLevel
			_ERROR(ERR_MSG . "`nCould not delete the file """ . s_INI_FILE . """")
	}	
	If (s_INI_FILE = INI_FILE)
	{
		StringReplace , s_INI , OUT_FILE , %IN_DIR% , `%IN_DIR`%
		IniWrite , %s_INI% , %s_INI_FILE% , %AHK_SECTION% , OUT_FILE
		
		; local ini file
		StringReplace , s_INI , ALT_BIN , %IN_DIR% , `%IN_DIR`%
		IniWrite , %s_INI% , %s_INI_FILE% , %AHK_SECTION% , ALT_BIN
	}
	Else
		; global ini file
		IniWrite , %ALT_BIN% , %s_INI_FILE% , %AHK_SECTION% , ALT_BIN
	
	IniWrite , %COMPRESSION% , %s_INI_FILE% , %AHK_SECTION% , COMPRESSION
	IniWrite , %NO_UPX% , %s_INI_FILE% , %AHK_SECTION% , NO_UPX
	IniWrite , %OUT_PASS% , %s_INI_FILE% , %AHK_SECTION% , OUT_PASS
	IniWrite , %SHOW_PASS% , %s_INI_FILE% , %AHK_SECTION% , SHOW_PASS
	IniWrite , %NO_DECOMPILE% , %s_INI_FILE% , %AHK_SECTION% , NO_DECOMPILE
	IniWrite , %CREATED_DATE% , %s_INI_FILE% , %AHK_SECTION% , CREATED_DATE
	; add quotation marks to deal problems with spaces in pathes
	IniWrite , "%RUN_BEFORE%" , %s_INI_FILE% , %AHK_SECTION% , RUN_BEFORE
	IniWrite , "%RUN_AFTER%" , %s_INI_FILE% , %AHK_SECTION% , RUN_AFTER
	IniWrite , %EXEC_LEVEL% , %s_INI_FILE% , %AHK_SECTION% , EXEC_LEVEL
	IniWrite , %VERSION_INFO% , %s_INI_FILE% , %RES_SECTION% , VERSION_INFO
	If (VERSION_INFO)
	{
		IniWrite , %COMPANY_NAME% , %s_INI_FILE% , %RES_SECTION% , COMPANY_NAME
		IniWrite , %FILE_DESC% , %s_INI_FILE% , %RES_SECTION% , FILE_DESC
		IniWrite , %FILE_VER% , %s_INI_FILE% , %RES_SECTION% , FILE_VER
		IniWrite , %INC_FILE_VER% , %s_INI_FILE% , %RES_SECTION% , INC_FILE_VER
		IniWrite , %INTERNAL_NAME% , %s_INI_FILE% , %RES_SECTION% , INTERNAL_NAME
		IniWrite , %LEGAL_COPYRIGHT% , %s_INI_FILE% , %RES_SECTION% , LEGAL_COPYRIGHT
		IniWrite , %ORG_FILENAME% , %s_INI_FILE% , %RES_SECTION% , ORG_FILENAME
		IniWrite , %PRODUCT_NAME% , %s_INI_FILE% , %RES_SECTION% , PRODUCT_NAME
		IniWrite , %PRODUCT_VER% , %s_INI_FILE% , %RES_SECTION% , PRODUCT_VER
		
		IniWrite , %SET_AHK_VERSION% , %s_INI_FILE% , %RES_SECTION% , SET_AHK_VERSION
		IniWrite , %INC_PROD_VER% , %s_INI_FILE% , %RES_SECTION% , INC_PROD_VER
		IniWrite , %LANG_ID% , %s_INI_FILE% , %RES_SECTION% , LANG_ID
		IniWrite , %CHARSET% , %s_INI_FILE% , %RES_SECTION% , CHARSET
	}
	Loop , %ICONCOUNT% {
		TempIconName := "ICON_" . A_Index
		TempIcon := %TempIconName%
		TempBoxName := TempIconName . "_SET"
		TempBox := %TempBoxName%
		; IniWrite , %TempBox% , %s_INI_FILE% , %ICO_SECTION% , %TempBoxName%
		If (TempBox)
		{
			StringReplace , TempIcon , TempIcon , %IN_DIR% , `%IN_DIR`%
			IniWrite , %TempIcon% , %s_INI_FILE% , %ICO_SECTION% , %TempIconName%
		}
	}
	Return
}
; --------------------------------------------------------------------------------
; Enable/Disable Version Info
; --------------------------------------------------------------------------------
_GUI_VERS_INFO(s_CMD)
{
	Global
	GuiControl , %s_CMD% , GUI_COMPANY_NAME
	GuiControl , %s_CMD% , GUI_FILE_DESC
	GuiControl , %s_CMD% , GUI_TFV1
	GuiControl , %s_CMD% , GUI_TFV2
	GuiControl , %s_CMD% , GUI_TFV3
	GuiControl , %s_CMD% , GUI_TFV4
	GuiControl , %s_CMD% , GUI_FV1
	GuiControl , %s_CMD% , GUI_FV2
	GuiControl , %s_CMD% , GUI_FV3
	GuiControl , %s_CMD% , GUI_FV4
	GuiControl , %s_CMD% , GUI_INC_FILE_VER
	GuiControl , %s_CMD% , GUI_INTERNAL_NAME
	GuiControl , %s_CMD% , GUI_LEGAL_COPYRIGHT
	GuiControl , %s_CMD% , GUI_ORG_FILENAME
	GuiControl , %s_CMD% , GUI_PRODUCT_NAME
	GuiControl , %s_CMD% , GUI_LANG_ID
	GuiControl , %s_CMD% , GUI_CHARSET
	
	If !GUI_SET_AHK_VERSION {
		GuiControl , %s_CMD% , GUI_TPV1
		GuiControl , %s_CMD% , GUI_TPV2
		GuiControl , %s_CMD% , GUI_TPV3
		GuiControl , %s_CMD% , GUI_TPV4
		GuiControl , %s_CMD% , GUI_PV1
		GuiControl , %s_CMD% , GUI_PV2
		GuiControl , %s_CMD% , GUI_PV3
		GuiControl , %s_CMD% , GUI_PV4
		GuiControl , %s_CMD% , GUI_INC_PROD_VER
	}
	
	If !GUI_INC_PROD_VER
		GuiControl , %s_CMD% , GUI_SET_AHK_VERSION
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
	StringSplit , aVersion , FILE_VER , `. , %A_Space%
	Loop , %aVersion0%
		GUI_FV%A_Index% := aVersion%A_Index%
	StringSplit , aVersion , PRODUCT_VER , `. , %A_Space%
	Loop , %aVersion0%
		GUI_PV%A_Index% := aVersion%A_Index%
	Return
}
; --------------------------------------------------------------------------------
; Select Folder
; --------------------------------------------------------------------------------
_SELECT_FOLDER(ByRef s_DIR)
{
	Global
	Local s_SEL , s_PROMPT
	s_PROMPT := "Select Destination Folder:"
	FileSelectFolder , s_SEL , *%s_DIR% , 3 , %s_PROMPT%
	If (Errorlevel) {
		Return
	}
	s_DIR := s_SEL
	Return
}
; --------------------------------------------------------------------------------
; Select File
; --------------------------------------------------------------------------------
_SELECT_FILE(ByRef s_FILE , s_TYPE)
{
	Global
	Local s_SEL , s_EXT , s_OPTIONS , s_PROMPT , S_FILTER , s_FOLDER
	If s_TYPE = RUN
	{
		s_OPTIONS := "1"
		s_PROMPT := "Select Runnable File"
		s_FILTER := "Run (*.ahk;*.bat;*.cmd;*.exe)"
		s_FOLDER := IN_DIR
	}
	Else If s_TYPE = AHK
	{
		s_OPTIONS := "1"
		s_PROMPT := "Select AutoHotkey Script"
		s_FILTER := "AutoHotkey Script (*.ahk)"
		; s_FOLDER := "C:"
	}
	Else If s_TYPE = BIN
	{
		s_OPTIONS := "1"
		s_PROMPT := "Select AutoHotkeySC.bin"
		s_FILTER := "AutoHotkeySC.bin (*.*)"
		; s_FOLDER := "C:"
	}
	Else
		Return
	FileSelectFile , s_SEL , %s_OPTIONS% , %s_FOLDER% , %s_PROMPT% , %s_FILTER%
	If (Errorlevel) {
		Return
	}
	If s_TYPE = RUN
	{
		IfInString , s_SEL , %A_Space%
			s_FILE := """" . s_SEL . """"
		Else
			s_FILE := s_SEL
	}
	Else
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
	ALT_BIN := GUI_ALT_BIN
	
	Loop , %ICONCOUNT%
	{
		TempIcon := GUI_ICON_%A_Index%
		If (TempIcon != "") {
			If Not FileExist(TempIcon) {
				
				Msgbox , 262192 , %MSG_TITLE% , Icon File %TempIcon% doesn't exist!
				GuiControl , Focus , GUI_ICON_%A_Index%
				Return False
			}
		}
		ICON_1 := GUI_ICON_1
	}
	COMPRESSION := GUI_COMPRESSION - 1
	NO_UPX := GUI_NO_UPX
	OUT_PASS := GUI_OUT_PASS
	SHOW_PASS := GUI_SHOW_PASS
	NO_DECOMPILE := GUI_NO_DECOMPILE
	CREATED_DATE := GUI_CREATED_DATE
	RUN_BEFORE := GUI_RUN_BEFORE
	RUN_AFTER := GUI_RUN_AFTER
	EXEC_LEVEL := GUI_EXEC_LEVEL
	VERSION_INFO := GUI_VERSION_INFO
	If (VERSION_INFO) {
		COMPANY_NAME := GUI_COMPANY_NAME
		FILE_DESC := GUI_FILE_DESC
		FILE_VER := GUI_FV1 . "." . GUI_FV2 . "." . GUI_FV3 . "." . GUI_FV4
		INC_FILE_VER := GUI_INC_FILE_VER
		INTERNAL_NAME := GUI_INTERNAL_NAME
		LEGAL_COPYRIGHT := GUI_LEGAL_COPYRIGHT
		ORG_FILENAME := GUI_ORG_FILENAME
		PRODUCT_NAME := GUI_PRODUCT_NAME
		PRODUCT_VER := GUI_PV1 . "." . GUI_PV2 . "." . GUI_PV3 . "." . GUI_PV4

		SET_AHK_VERSION := GUI_SET_AHK_VERSION
		INC_PROD_VER := GUI_INC_PROD_VER
		
		LANG_ID := GUI_LANG_ID
		CHARSET := GUI_CHARSET
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
	Local s_CMD , s_ERR , s_LOG
	s_CMD := RUN_BEFORE
			. " >> "
			. """" . A_WorkingDir . "\" . LOG_FILE . """"
	StringReplace , s_CMD , s_CMD , % "%IF%" , %IN_FILE% , All
	StringReplace , s_CMD , s_CMD , % "%OF%" , %OUT_FILE% , All
	StringReplace , s_CMD , s_CMD , % "%OD%" , %OUT_DIR% , All
	StringReplace , s_CMD , s_CMD , % "%ON%" , %OUT_NAME% , All
	FileAppend , `n* Execute Run Before Command:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , %IN_DIR% , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_LOG , %LOG_FILE%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_LOG
			_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileAppend , `n# Run Before executed successfully!`n`n , %A_WorkingDir%\%LOG_FILE%
	Return
}
; --------------------------------------------------------------------------------
; Modify Manifest for Vista Administrator Exection Level (User Account Control)
; --------------------------------------------------------------------------------
_MOD_MANIFEST()
{
	Global
	Local s_CMD , s_ERR , s_LOG , s_MANIFEST , XML_POS , s_LEFT , s_RIGHT , s_SC_File , s_MF_FILE , s_EX_LEVEL
	
	s_SC_FILE := A_WorkingDir . "\ExtractManifest.cfg"
	s_MF_FILE := A_WorkingDir . "\" . MANIFEST_FILE
	
	s_SCRIPT := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "SaveAs=" . s_MF_FILE . "`n"
			. "Log=" . A_WorkingDir . "\" . RES_LOG . "`n"
			. "[COMMANDS]`n"
			. "-extract """ . s_MF_FILE . """ , 24 , 1 , 1033"
	
	FileDelete , %s_SC_FILE%
	FileAppend , %s_SCRIPT% , %s_SC_FILE%
	
	s_CMD := """" . A_ScriptDir . "\" RES_EXE . """"
			. " -script "
			. """" . s_SC_FILE . """"
	
	FileAppend , `n* Extract Manifest from binary file:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_LOG , A_WorkingDir . "\" . %RES_LOG%
		s_ERR := "Couldn't extract manifest file , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't extract manifest file , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%RES_LOG%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest extracted successfully!`n`n , %A_WorkingDir%\%LOG_FILE%
	
	If EXEC_LEVEL = 4
		s_EX_LEVEL = requireAdministrator
	Else If EXEC_LEVEL = 3
		s_EX_LEVEL = highestAvailable
	Else
		s_EX_LEVEL = asInvoker
	
	FileRead , s_MANIFEST , %s_MF_FILE%
	StringGetPos , XML_POS , s_MANIFEST , </ , R
	StringLeft , s_LEFT , s_MANIFEST , XML_POS
	StringTrimLeft , s_RIGHT , s_MANIFEST , XML_POS

	s_MANIFEST := s_LEFT
				. "<!-- Identify the application security requirements. -->`n"
				. "<!-- level can be ""asInvoker"" , ""highestAvailable"" , or ""requireAdministrator"" -->`n"
				. "	<trustInfo xmlns=""urn:schemas-microsoft-com:asm.v2"">`n"
				. "		<security>`n"
				. "			<requestedPrivileges>`n"
				. "				<requestedExecutionLevel`n"
				. "					level=""" . s_EX_LEVEL . """`n"
				. "					uiAccess=""false""`n"
				. "				/>`n"
				. "			</requestedPrivileges>`n"
				. "		</security>`n"
				. "</trustInfo>`n"
				. s_RIGHT

	FileDelete , %s_MF_FILE%
	FileAppend , %s_MANIFEST% , %s_MF_FILE%

	s_SC_FILE := A_WorkingDir . "\OverwriteManifest.cfg"
	
	s_SCRIPT := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "Log=" . A_WorkingDir . "\" . RES_LOG . "`n"
			. "[COMMANDS]`n"
			. "-addoverwrite """ . s_MF_FILE . """ , 24 , 1 , 1033"
	
	FileDelete , %s_SC_FILE%
	FileAppend , %s_SCRIPT% , %s_SC_FILE%
	
	s_CMD := """" . A_ScriptDir . "\" RES_EXE . """"
			. " -script "
			. """" . s_SC_FILE . """"
	
	FileAppend , `n* Overwrite Manifest in binary file:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
		s_ERR := "Couldn't modify manifest file , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't modify manifest file , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%RES_LOG%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest overwritten successfully!`n`n , %A_WorkingDir%\%LOG_FILE%

	FileSetTime , , %BIN_FILE% , M			;Is not set automatically
	; FileDelete , %MANIFEST_FILE%
	; FileDelete , %RES_INI%
	; FileDelete , %RES_LOG%


	Return
}
; --------------------------------------------------------------------------------
; Set Version
; --------------------------------------------------------------------------------
_CHECK_EXENAME()
{
	Global
	Local elevated
	
	elevated = 0
	IfInstring , OUT_FILE , setup
		elevated = setup
	IfInstring , OUT_FILE , install
		elevated = install
	IfInstring , OUT_FILE , update
		elevated = update
	IfInstring , OUT_FILE , patch
		elevated = patch
	
	If elevated != 0
	{
		Button1Name = &Continue
		Button2Name = &Abort
		MsgBoxTitle = Choice required
		MsgBoxText = Your executable's filename contains the word "%elevated%". If you continue, Windows Vista will automatically elevate your executable so that it need to run in administration mode.`n`nChose an execution level in the Compile_AHK compiler settings to disable this message.
		SetTimer , ChangeButtonNames , 50
		MsgBox , 289 , %MsgBoxTitle% , %MsgBoxText%
		If AUTO_COMPILE <> 2
		{
			IfMsgBox , Cancel
				_ERROR_EXIT("You have decided to abort the compilation. Please try again!`n`nBye bye ... !")
		}
	}
	Return
}
; --------------------------------------------------------------------------------
; Set Version
; --------------------------------------------------------------------------------
_SET_VERSION()
{
	Global
	Local s_CMD , s_ERR , s_LOG , s_FILE_VER , s_PROD_VER , s_RC_FILE , s_RES_FILE , s_SC_FILE , s_SCRIPT , s_LANG_ID , s_CHARSET
	
	s_LANG_ID := LCode_%LANG_ID%
	s_CHARSET := SubStr( "0000" . ToBase(CCode_%CHARSET%,16) , -3) ; convert to hex and prepend up to 4 zeros
	
	s_RC_FILE := "VersionInfo.rc"
	s_RES_FILE := "VersionInfo.res"
	IfNotExist , %A_ScriptDir%\%RC_EXE%
	{
		MsgBox, 262164, %MSG_TITLE%, %ERR_MSG%`nCouldn't find %A_ScriptDir%\%RC_EXE%`nWithout it the Version info can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	IfNotExist , %A_ScriptDir%\%RES_EXE%
	{
		MsgBox, 262164, %MSG_TITLE%, %ERR_MSG%`nCouldn't find %A_ScriptDir%\%RES_EXE%`nWithout it the Version info can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	
	FileDelete , %s_RC_FILE%
	FileDelete , %s_RES_FILE%
	StringReplace , s_FILE_VER , FILE_VER , . , `, , All
	StringReplace , s_PROD_VER , PRODUCT_VER , . , `, , All

	FileAppend , 
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
			VALUE "CompanyName" , "%COMPANY_NAME%"
			VALUE "FileDescription" , "%FILE_DESC%"
			VALUE "FileVersion" , "%FILE_VER%"
			VALUE "InternalName" , "%INTERNAL_NAME%"
			VALUE "LegalCopyright" , "%LEGAL_COPYRIGHT%"
			VALUE "OriginalFilename" , "%ORG_FILENAME%"
			VALUE "ProductName" , "%PRODUCT_NAME%"
			VALUE "ProductVersion" , "%PRODUCT_VER%"
		}
}
BLOCK "VarFileInfo"
{
	VALUE "Translation" , 0x%s_LANG_ID% 0x%s_CHARSET%
}
}
) , %s_RC_FILE%

	s_CMD := """" . A_ScriptDir . "\" RC_EXE . """"
			. "/r "
			. """" . A_WorkingDir . "\" . s_RC_FILE . """"
			. " >> "
			. """" . A_WorkingDir . "\" . RC_LOG . """"
	
	FileAppend , `n* Create resource file:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	IfNotExist , %A_WorkingDir%\%s_RES_FILE%
	{
		FileRead , s_LOG , %RC_LOG%
		s_ERR := "Couldn't set Version Info , " . RC_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileRead , s_LOG , %RC_LOG%
	FileDelete , %A_WorkingDir%\%RC_LOG%
	FileAppend , `n~~ GoRC Log Start ~~`n%s_Log%~~ GoRC Log End ~~`n`n# Resource file created successfully!`n`n , %A_WorkingDir%\%LOG_FILE%
	
	s_SC_FILE := A_WorkingDir . "\ChangeVersionInfo.cfg"
	
	s_SCRIPT := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "Log=" . A_WorkingDir . "\" . RES_LOG . "`n"
			. "[COMMANDS]`n"
; --------------------------------------------------------------------------------
; ResHacker-fix:
; delete versioninfo with language ID 1033 to prevent double versioninfo and cause
; following command doesnt work:
; ResHacker.exe -addoverwrite , in.exe , out.exe , version.res , versioninfo , 1 , 1033
; --------------------------------------------------------------------------------
	s_SCRIPT := s_SCRIPT . "-delete Versioninfo , 1 , 1033`n"
; --------------------------------------------------------------------------------
	s_SCRIPT := s_SCRIPT . "-addoverwrite """ . A_WorkingDir . "\" . s_RES_FILE . """ , Versioninfo , 1 , "

	FileDelete , %s_SC_FILE%
	FileAppend , %s_SCRIPT% , %s_SC_FILE%
	
	s_CMD := """" . A_ScriptDir . "\" RES_EXE . """"
			. " -script "
			. """" . s_SC_FILE . """"
	
	FileAppend , `n* Delete original Versioninfo (ResHacker-fix for non-1033 systems) and add the new one:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
		s_ERR := "Couldn't set Version Info , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileRead , s_LOG , %A_WorkingDir%\%RES_LOG%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't set Version Info , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%RES_LOG%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Versioninfo replaced successfully!`n`n , %A_WorkingDir%\%LOG_FILE%

	FileSetTime , , %A_WorkingDir%\%BIN_FILE% , M	;Is not set automatically
	; FileDelete , %s_RC_FILE%
	; FileDelete , %s_RES_FILE%
	; FileDelete , %RES_INI%
	; FileDelete , %RES_LOG%
	Return
}
; --------------------------------------------------------------------------------
; Change Icons
; --------------------------------------------------------------------------------
_CHANGE_ICONS()
{
	Global
	Local s_SC_FILE , s_SCRIPT , s_CMD , s_LOG
	s_SC_FILE := A_WorkingDir . "\ChangeIcon.cfg"
	
	IfNotExist , %A_ScriptDir%\%RES_EXE%
	{
		MsgBox, 262164, %MSG_TITLE%, %ERR_MSG%`nCouldn't find %A_ScriptDir%\%RES_EXE%`nWithout it the icons can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	
	s_SCRIPT := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . BIN_FILE . "`n"
			. "Log=" . A_WorkingDir . "\" . RES_LOG . "`n"
			. "[COMMANDS]`n"
	
	Loop , %ICONCOUNT%
		If ICON_%A_Index%_SET
		{
			; ResHacker uses ResourceIds instead of IconIndex
			IconGroupID := ResourceIdOfIcon(BIN_FILE , A_Index - 1)
			s_SCRIPT := s_SCRIPT . "-addoverwrite """ . ICON_%A_Index% """ , ICONGROUP," . IconGroupID . ",1033`n"
		}

	FileDelete , %s_SC_FILE%
	FileAppend , %s_SCRIPT% , %s_SC_FILE%

	s_CMD := """" . A_ScriptDir . "\" RES_EXE . """"
			. " -script "
			. """" . s_SC_FILE . """"
	
	FileAppend , `n* Replace icons:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead , s_LOG , %A_WorkingDir%\%RES_LOG%
		s_ERR := "Couldn't change icons , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%RES_LOG%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't change icons , " . RES_EXE . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%RES_LOG%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Icons replaced successfully!`n`n , %A_WorkingDir%\%LOG_FILE%

	FileSetTime , , %BIN_FILE% , M ;Is not set automatically
	; FileDelete , %s_SC_FILE%
	; FileDelete , %RES_INI%
	; FileDelete , %RES_LOG%

	Return
}
; --------------------------------------------------------------------------------
; Compile_AHK
; --------------------------------------------------------------------------------
_COMPILE_AHK()
{
	Global
	Local s_IN , s_OUT , s_ICON , s_PASS , s_NO_DECOMPILE , s_CMD , s_LOG , OLD_COMPRESSION
	
	s_IN := " /in """ . IN_FILE . """"
	s_OUT := " /out """ . OUT_FILE . """"
	/*
	not needed cause now reshacker replaces icons
	If (ICON_1 != "") {
		s_ICON := " /icon """ . ICON_1 . """"
	}
	*/
	If (OUT_PASS != "") {
		; escape double quotation marks
		StringReplace , s_PASS , OUT_PASS , " , "" , All
		s_PASS := " /pass """ . s_PASS . """"
	}
	If (NO_DECOMPILE) {
		s_NO_DECOMPILE := " /NoDecompile"
	}
	
	If NO_UPX
	{
		FileDelete , %A_WorkingDir%\%UPX_EXE%
		If Errorlevel
			_ERROR_EXIT(ERR_MSG . "Couldn't delete " . UPX_EXE)
	}
	
	OLD_COMPRESSION := _SET_COMPRESSION(COMPRESSION)
	
	
	If ALT_BIN_SET
	{
		FileCopy , %ALT_BIN% , %A_WorkingDir%\%BIN_FILE% , 1
		If (Errorlevel) {
			_ERROR_EXIT(ERR_MSG . "Couldn't copy """ . ALT_BIN . """ to """ . A_WorkingDir . """.")
		}
	}
	
	If CREATED_DATE
	{
		IfExist , %OUT_FILE%
		{
			FileSetTime , , %OUT_FILE% , C

			If ErrorLevel
				Return False
		}
	}
	
	_COPY_LIB_DIR()
	
	s_CMD := """" . A_WorkingDir . "\" . COMPILER . """"
			. s_IN
			. s_OUT
			. s_ICON
			. s_PASS
			. s_NO_DECOMPILE
			. " >> "
			. """" . A_WorkingDir . "\" . LOG_FILE . """"
	
	FileAppend , `n* Compile script:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If (ErrorLevel)
	{
		_SET_COMPRESSION(OLD_COMPRESSION)
		Return False
	}
	Loop, read , %A_WorkingDir%\%LOG_FILE%
		LastLine := A_Index
	FileAppend , `n# Script compiled successfully!`n , %A_WorkingDir%\%LOG_FILE%
	_SET_COMPRESSION(OLD_COMPRESSION)
	If AUTO_COMPILE <> 2
	{
		FileReadLine , s_LOG , %A_WorkingDir%\%LOG_FILE% , %LastLine%
		Msgbox , 262208 , %MSG_TITLE% , %s_LOG% , 2
	}
	Return True
}
; --------------------------------------------------------------------------------
; Run after
; --------------------------------------------------------------------------------
_RUN_AFTER()
{
	Global
	Local s_CMD , s_ERR , s_LOG
	s_CMD := RUN_AFTER
			. " >> "
			. """" . A_WorkingDir . "\" . LOG_FILE . """"
	StringReplace , s_CMD , s_CMD , % "%IF%" , %IN_FILE% , All
	StringReplace , s_CMD , s_CMD , % "%OF%" , %OUT_FILE% , All
	StringReplace , s_CMD , s_CMD , % "%OD%" , %OUT_DIR% , All
	StringReplace , s_CMD , s_CMD , % "%ON%" , %OUT_NAME% , All
	
	FileAppend , `n* Execute Run After Command:`n%s_CMD%`n, %A_WorkingDir%\%LOG_FILE%
	RunWait , %ComSpec% /c "%s_CMD%" , %IN_DIR% , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_LOG , %LOG_FILE%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_LOG
		_ERROR_EXIT(ERR_MSG . s_ERR)
	}
	FileAppend , `n# Run After executed successfully!`n`n , %A_WorkingDir%\%LOG_FILE%
	Return
}
; --------------------------------------------------------------------------------
; Set Registry Entries
; --------------------------------------------------------------------------------
_SET_COMPRESSION(NewLevel)
{
	Global
	Local OldLevel
	ERR_MSG := "Error while setting compression level.`n"
	
	RegRead , OldLevel , HKCU , Software\AutoHotkey\Ahk2Exe , LastCompression
	RegWrite , REG_DWORD , HKCU , Software\AutoHotkey\Ahk2Exe , LastCompression , %NewLevel%
	RegWrite , REG_SZ , HKCU , Software\AutoHotkey\Ahk2Exe , LastIcon
	Return , OldLevel
}
; --------------------------------------------------------------------------------
; Copy the lib directory
; --------------------------------------------------------------------------------

_COPY_LIB_DIR()
{
	Global
	Local s_OrgAHK , s_UsedAHK
	
	SetWorkingDir , %A_Temp%\AutoHotkey
	
	ERR_MSG := "Error while copying Lib folder.`n"
	
	IfExist , %A_WorkingDir%\%LIB_DIR%
	{
		FileRemoveDir , %A_WorkingDir%\%LIB_DIR% , 1
		If Errorlevel
			_ERROR_EXIT(ERR_MSG . "Couldn't delete folder " . LIB_DIR)
	}
	IfExist , %AHK_DIR%\%LIB_DIR%
	{
		FileCopyDir , %AHK_DIR%\%LIB_DIR% , %A_WorkingDir%\%LIB_DIR% , 1
		If Errorlevel
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new folder " . LIB_DIR)
	}
	FileGetVersion , s_OrgAHK , %AHK_DIR%\%AHK_EXE%
	FileGetVersion , s_UsedAHK , %A_WorkingDir%\%AHK_EXE%
	If (s_OrgAHK <> s_UsedAHK)
	{
		FileCopy , %AHK_DIR%\%AHK_EXE% , %A_WorkingDir%\%AHK_EXE% , 1
		If Errorlevel
			_ERROR_EXIT(ERR_MSG . "Couldn't copy new " . AHK_EXE)
	}
	SetWorkingDir , %A_Temp%\AutoHotkey\Compiler
	Return
}
; --------------------------------------------------------------------------------
; Help Window with Informations about Vista Execution Level
; --------------------------------------------------------------------------------
EXEC_LEVEL_HELP:
	Gui ,+OwnDialogs
	
	HelpText := "* none:`n"
				. A_Tab . "Doesn't add a special execution level.`n`n"
				. "* asInvoker:`n"
				. A_Tab . "Launches with the same rights as the user or parent process.`n`n"
				. "* highestAvailable:`n"
				. A_Tab . "Launches with the highest rights this user possesses.`n"
				. A_Tab . "Asks for administrator rights, if those are not available,`n"
				. A_Tab . "it launches with user's rights.`n`n"
				. "* requireAdministrator:`n"
				. A_Tab . "Needs administrator rights to be lauched.`n"
				. A_Tab . "User has to be a member of Administrators group."

	MsgBox , 64 , Information on Vista Execution Level , %HelpText%
Return
; --------------------------------------------------------------------------------
; ToolTip texts
; --------------------------------------------------------------------------------
CreateToolTips:
	GUI_ABORT_TT := ""
	GUI_ALT_BIN_SET_TT := ""
	GUI_ALT_BIN_TT := ""

	GUI_CHARSET_TT := "Set the charset encoding."
	GUI_COMPANY_NAME_TT := "Set your company's name."
	GUI_COMPILE_TT := ""
	GUI_COMPRESSION_TT := "Set the compression rate."
	GUI_CREATED_DATE_TT := "Set this option if the resulting exe file's ""created"" date should be updated."
	GUI_CREDITS_TT := ""

	GUI_EXEC_LEVEL_TT := "Set the execution level for Vista's UAC."
	GUI_FILE_DESC_TT := "Set the file's description."

	GUI_FV1_TT := "Set the file version."
	GUI_FV2_TT := "Set the file version."
	GUI_FV3_TT := "Set the file version."
	GUI_FV4_TT := "Set the file version."

	GUI_GENERATE_TT := "Click here to generate a new password."

	GUI_ICON_1_BT_TT := ""
	GUI_ICON_1_PIC_TT := ""
	GUI_ICON_1_SET_TT := "Set the first icon file"
	GUI_ICON_1_TT := "This is the first icon file."

	GUI_ICON_2_BT_TT := ""
	GUI_ICON_2_PIC_TT := ""
	GUI_ICON_2_SET_TT := "Set the second icon file"
	GUI_ICON_2_TT := "This is the second icon file."

	GUI_ICON_3_BT_TT := ""
	GUI_ICON_3_PIC_TT := ""
	GUI_ICON_3_SET_TT := "Set the third icon file"
	GUI_ICON_3_TT := "This is the thirdicon file."

	GUI_ICON_4_BT_TT := ""
	GUI_ICON_4_PIC_TT := ""
	GUI_ICON_4_SET_TT := "Set the fourth icon file"
	GUI_ICON_4_TT := "This is the fourth icon file."

	GUI_ICON_5_BT_TT := ""
	GUI_ICON_5_PIC_TT := ""
	GUI_ICON_5_SET_TT := "Set the fifth icon file"
	GUI_ICON_5_TT := "This is the fifth icon file."

	GUI_ICON_6_BT_TT := ""
	GUI_ICON_6_PIC_TT := ""
	GUI_ICON_6_SET_TT := "Set the sixth icon file"
	GUI_ICON_6_TT := "This is the sixth icon file."

	GUI_ICON_7_BT_TT := ""
	GUI_ICON_7_PIC_TT := ""
	GUI_ICON_7_SET_TT := "Set the seventh icon file"
	GUI_ICON_7_TT := "This is the seventh icon file."

	GUI_IN_FILE_TT := "This is the path to the selected script."
	GUI_INC_FILE_VER_TT := "Set this option if you want the file version to be automatically incremented on every compiling."
	GUI_INC_PROD_VER_TT := "Set this option if you want the product version to be automatically incremented on every compiling."
	GUI_INTERNAL_NAME_TT := "Set the file's internal name."
	GUI_LANG_ID_TT := "Set a language ID."
	GUI_LEGAL_COPYRIGHT_TT := "Set the legal copyright."
	
	GUI_NO_DECOMPILE_TT := "Set this option if you want to enable the NoDecompile option."
	GUI_NO_UPX_TT := "Set this option to disable the upx compression."
	GUI_ON_TOP_OFF_TT := "Always on top is off."
	GUI_ON_TOP_TT := "Always on top is on."
	GUI_ORG_FILENAME_TT := "Set the original file name."
	GUI_OUT_FILE_TT := "This is the path to the resulting exe file."
	GUI_OUT_PASS_TT := "This is the password used for encrypting your source script"
	GUI_PRODUCT_NAME_TT := "Set the file's product name."
	
	GUI_PV1_TT := "Set the product version."
	GUI_PV2_TT := "Set the product version."
	GUI_PV3_TT := "Set the product version."
	GUI_PV4_TT := "Set the product version."
	
	GUI_RUN_AFTER_TT := "This is the path to the file that is executed after compiling."
	GUI_RUN_BEFORE_TT := "This is the path to the file that is executed before compiling."
	GUI_SAVEDEFAULTS_TT := ""
	GUI_SELECT_ALT_BIN_TT := ""
	GUI_SELECT_OUT_FILE_TT := "Set the path of the resulting exe file."
	GUI_SELECT_RUN_AFTER_TT := ""
	GUI_SELECT_RUN_BEFORE_TT := ""
	
	GUI_SET_AHK_VERSION_TT := "Set this option if you want the product version to be set to the ahk compiler's file version."
	GUI_SHOW_PASS_TT := "Set this option if you want to see the password."
	GUI_TAB_CHOOSE_TT := ""

	GUI_TEXT_COMPRESSION_TT := ""
	GUI_TEXT_EXEC_LEVEL_TT := ""
	GUI_TEXT_IN_FILE_TT := ""
	GUI_TEXT_OTHER_OPTIONS_TT := ""
	GUI_TEXT_OUT_FILE_TT := ""
	GUI_TEXT_PASSWORD_TT := ""
	GUI_TEXT_RUN_AFTER_TT := ""
	GUI_TEXT_RUN_BEFORE_TT := ""
	GUI_TEXT_VISTA_UAC_TT := ""

	GUI_TFV1_TT := "Set the file version."
	GUI_TFV2_TT := "Set the file version."
	GUI_TFV3_TT := "Set the file version."
	GUI_TFV4_TT := "Set the file version."
	GUI_TPV1_TT := "Set the product version."
	GUI_TPV2_TT := "Set the product version."
	GUI_TPV3_TT := "Set the product version."
	GUI_TPV4_TT := "Set the product version."

	GUI_TITLE_TT := ""
	GUI_UAC_HELP_TT := ""
	GUI_VERSION_INFO_TT := "Set this option to change the resulting exe file's version info."

	OnMessage(0x200, "WM_MOUSEMOVE") ;{}
Return
; --------------------------------------------------------------------------------
; Create a ToolTip on Mouseover
; --------------------------------------------------------------------------------
WM_MOUSEMOVE()
{
	static CurrControl, PrevControl, _TT ; _TT is kept blank for use by the ToolTip command below.
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
		ToolTip ; Turn off any previous tooltip.
		SetTimer, DisplayToolTip, -300
		PrevControl := CurrControl
	}
	Return

	DisplayToolTip:
		If (%CurrControl%_TT = "")
			ToolTip , %CurrControl%
		Else
			ToolTip % %CurrControl%_TT ; %The leading percent sign tell it to use an expression.
		SetTimer, RemoveToolTip2, -5000
	Return

	RemoveToolTip2:
		ToolTip
	Return
}
; --------------------------------------------------------------------------------
; Creates a List with all language IDs for the version info
; --------------------------------------------------------------------------------
CREATE_LANG_LIST()
{
	Global
	Local NameList
	If LCode_1 != 0436
	{
		LCode_1 = 0436
		LName_1 = Afrikaans
		LCode_2 = 041c
		LName_2 = Albanian
		LCode_3 = 0401
		LName_3 = Arabic_Saudi_Arabia
		LCode_4 = 0801
		LName_4 = Arabic_Iraq
		LCode_5 = 0c01
		LName_5 = Arabic_Egypt
		LCode_6 = 0401
		LName_6 = Arabic_Saudi_Arabia
		LCode_7 = 0801
		LName_7 = Arabic_Iraq
		LCode_8 = 0c01
		LName_8 = Arabic_Egypt
		LCode_9 = 1001
		LName_9 = Arabic_Libya
		LCode_10 = 1401
		LName_10 = Arabic_Algeria
		LCode_11 = 1801
		LName_11 = Arabic_Morocco
		LCode_12 = 1c01
		LName_12 = Arabic_Tunisia
		LCode_13 = 2001
		LName_13 = Arabic_Oman
		LCode_14 = 2401
		LName_14 = Arabic_Yemen
		LCode_15 = 2801
		LName_15 = Arabic_Syria
		LCode_16 = 2c01
		LName_16 = Arabic_Jordan
		LCode_17 = 3001
		LName_17 = Arabic_Lebanon
		LCode_18 = 3401
		LName_18 = Arabic_Kuwait
		LCode_19 = 3801
		LName_19 = Arabic_UAE
		LCode_20 = 3c01
		LName_20 = Arabic_Bahrain
		LCode_21 = 4001
		LName_21 = Arabic_Qatar
		LCode_22 = 042b
		LName_22 = Armenian
		LCode_23 = 042c
		LName_23 = Azeri_Latin
		LCode_24 = 082c
		LName_24 = Azeri_Cyrillic
		LCode_25 = 042d
		LName_25 = Basque
		LCode_26 = 0423
		LName_26 = Belarusian
		LCode_27 = 0402
		LName_27 = Bulgarian
		LCode_28 = 0403
		LName_28 = Catalan
		LCode_29 = 0404
		LName_29 = Chinese_Taiwan
		LCode_30 = 0804
		LName_30 = Chinese_PRC
		LCode_31 = 0c04
		LName_31 = Chinese_Hong_Kong
		LCode_32 = 1004
		LName_32 = Chinese_Singapore
		LCode_33 = 1404
		LName_33 = Chinese_Macau
		LCode_34 = 041a
		LName_34 = Croatian
		LCode_35 = 0405
		LName_35 = Czech
		LCode_36 = 0406
		LName_36 = Danish
		LCode_37 = 0413
		LName_37 = Dutch_Standard
		LCode_38 = 0813
		LName_38 = Dutch_Belgian
		LCode_39 = 0409
		LName_39 = English_United_States
		LCode_40 = 0809
		LName_40 = English_United_Kingdom
		LCode_41 = 0c09
		LName_41 = English_Australian
		LCode_42 = 1009
		LName_42 = English_Canadian
		LCode_43 = 1409
		LName_43 = English_New_Zealand
		LCode_44 = 1809
		LName_44 = English_Irish
		LCode_45 = 1c09
		LName_45 = English_South_Africa
		LCode_46 = 2009
		LName_46 = English_Jamaica
		LCode_47 = 2409
		LName_47 = English_Caribbean
		LCode_48 = 2809
		LName_48 = English_Belize
		LCode_49 = 2c09
		LName_49 = English_Trinidad
		LCode_50 = 3009
		LName_50 = English_Zimbabwe
		LCode_51 = 3409
		LName_51 = English_Philippines
		LCode_52 = 0425
		LName_52 = Estonian
		LCode_53 = 0438
		LName_53 = Faeroese
		LCode_54 = 0429
		LName_54 = Farsi
		LCode_55 = 040b
		LName_55 = Finnish
		LCode_56 = 040c
		LName_56 = French_Standard
		LCode_57 = 080c
		LName_57 = French_Belgian
		LCode_58 = 0c0c
		LName_58 = French_Canadian
		LCode_59 = 100c
		LName_59 = French_Swiss
		LCode_60 = 140c
		LName_60 = French_Luxembourg
		LCode_61 = 180c
		LName_61 = French_Monaco
		LCode_62 = 0437
		LName_62 = Georgian
		LCode_63 = 0407
		LName_63 = German_Standard
		LCode_64 = 0807
		LName_64 = German_Swiss
		LCode_65 = 0c07
		LName_65 = German_Austrian
		LCode_66 = 1007
		LName_66 = German_Luxembourg
		LCode_67 = 1407
		LName_67 = German_Liechtenstein
		LCode_68 = 0408
		LName_68 = Greek
		LCode_69 = 040d
		LName_69 = Hebrew
		LCode_70 = 0439
		LName_70 = Hindi
		LCode_71 = 040e
		LName_71 = Hungarian
		LCode_72 = 040f
		LName_72 = Icelandic
		LCode_73 = 0421
		LName_73 = Indonesian
		LCode_74 = 0410
		LName_74 = Italian_Standard
		LCode_75 = 0810
		LName_75 = Italian_Swiss
		LCode_76 = 0411
		LName_76 = Japanese
		LCode_77 = 043f
		LName_77 = Kazakh
		LCode_78 = 0457
		LName_78 = Konkani
		LCode_79 = 0412
		LName_79 = Korean
		LCode_80 = 0426
		LName_80 = Latvian
		LCode_81 = 0427
		LName_81 = Lithuanian
		LCode_82 = 042f
		LName_82 = Macedonian
		LCode_83 = 043e
		LName_83 = Malay_Malaysia
		LCode_84 = 083e
		LName_84 = Malay_Brunei_Darussalam
		LCode_85 = 044e
		LName_85 = Marathi
		LCode_86 = 0414
		LName_86 = Norwegian_Bokmal
		LCode_87 = 0814
		LName_87 = Norwegian_Nynorsk
		LCode_88 = 0415
		LName_88 = Polish
		LCode_89 = 0416
		LName_89 = Portuguese_Brazilian
		LCode_90 = 0816
		LName_90 = Portuguese_Standard
		LCode_91 = 0418
		LName_91 = Romanian
		LCode_92 = 0419
		LName_92 = Russian
		LCode_93 = 044f
		LName_93 = Sanskrit
		LCode_94 = 081a
		LName_94 = Serbian_Latin
		LCode_95 = 0c1a
		LName_95 = Serbian_Cyrillic
		LCode_96 = 041b
		LName_96 = Slovak
		LCode_97 = 0424
		LName_97 = Slovenian
		LCode_98 = 040a
		LName_98 = Spanish_Traditional_Sort
		LCode_99 = 080a
		LName_99 = Spanish_Mexican
		LCode_100 = 0c0a
		LName_100 = Spanish_Modern_Sort
		LCode_101 = 100a
		LName_101 = Spanish_Guatemala
		LCode_102 = 140a
		LName_102 = Spanish_Costa_Rica
		LCode_103 = 180a
		LName_103 = Spanish_Panama
		LCode_104 = 1c0a
		LName_104 = Spanish_Dominican_Republic
		LCode_105 = 200a
		LName_105 = Spanish_Venezuela
		LCode_106 = 240a
		LName_106 = Spanish_Colombia
		LCode_107 = 280a
		LName_107 = Spanish_Peru
		LCode_108 = 2c0a
		LName_108 = Spanish_Argentina
		LCode_109 = 300a
		LName_109 = Spanish_Ecuador
		LCode_110 = 340a
		LName_110 = Spanish_Chile
		LCode_111 = 380a
		LName_111 = Spanish_Uruguay
		LCode_112 = 3c0a
		LName_112 = Spanish_Paraguay
		LCode_113 = 400a
		LName_113 = Spanish_Bolivia
		LCode_114 = 440a
		LName_114 = Spanish_El_Salvador
		LCode_115 = 480a
		LName_115 = Spanish_Honduras
		LCode_116 = 4c0a
		LName_116 = Spanish_Nicaragua
		LCode_117 = 500a
		LName_117 = Spanish_Puerto_Rico
		LCode_118 = 0441
		LName_118 = Swahili
		LCode_119 = 041d
		LName_119 = Swedish
		LCode_120 = 081d
		LName_120 = Swedish_Finland
		LCode_121 = 0449
		LName_121 = Tamil
		LCode_122 = 0444
		LName_122 = Tatar
		LCode_123 = 041e
		LName_123 = Thai
		LCode_124 = 041f
		LName_124 = Turkish
		LCode_125 = 0422
		LName_125 = Ukrainian
		LCode_126 = 0420
		LName_126 = Urdu
		LCode_127 = 0443
		LName_127 = Uzbek_Latin
		LCode_128 = 0843
		LName_128 = Uzbek_Cyrillic
		LCode_129 = 042a
		LName_129 = Vietnamese
	}
	
	Loop
	{
		if LCode_%A_Index% = 
		{
			StringTrimRight, NameList , NameList , 1
			break
		}
		NameList .= LName_%A_Index% . "|"
	}
	Return %NameList%
}
; --------------------------------------------------------------------------------
; Creates a List with all charset IDs for the version info
; --------------------------------------------------------------------------------
CREATE_CHARSET_LIST()
{
	Global
	Local NameList
	If CCode_1 != 0
	{
		CCode_1 = 0
		CName_1 = 7-bit ASCII
		CCode_2 = 932
		CName_2 = Japan (Shift – JIS X-0208)
		CCode_3 = 949
		CName_3 = Korea (Shift – KSC 5601)
		CCode_4 = 950
		CName_4 = Taiwan (Big5)
		CCode_5 = 1200
		CName_5 = Unicode
		CCode_6 = 1250
		CName_6 = Latin-2 (Eastern European)
		CCode_7 = 1251
		CName_7 = Cyrillic
		CCode_8 = 1252
		CName_8 = Multilingual
		CCode_9 = 1253
		CName_9 = Greek
		CCode_9 = 1254
		CName_9 = Turkish
		CCode_9 = 1255
		CName_9 = Hebrew
		CCode_10 = 1256
		CName_10 = Arabic
	}
	
	Loop
	{
		if CCode_%A_Index% = 
		{
			StringTrimRight, NameList , NameList , 1
			break
		}
		NameList .= CName_%A_Index% . "|"
	}
	Return %NameList%
}
; --------------------------------------------------------------------------------
; Convert decimal numbers to any other format (hex, dual, octal, ...)
; --------------------------------------------------------------------------------
ToBase(n,b) { ; n >= 0, 1 < b <= 36
	Return (n < b ? "" : ToBase(n//b,b)) . ((d:=mod(n,b)) < 10 ? d : Chr(d+55))
}
; --------------------------------------------------------------------------------
; ERROR EXIT
; --------------------------------------------------------------------------------
_ERROR(sMSG)
{
	Msgbox , 262160 , %MSG_TITLE% , %sMSG%
}

_ERROR_EXIT(sMSG)
{
	Msgbox , 262160 , %MSG_TITLE% , %sMSG%
	_EXIT()
}
_EXIT()
{
	ExitApp
}