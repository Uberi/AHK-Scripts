; --------------------------------------------------------------------------------
; AutoHotkey Version	: 1.0.47.06
; Language				: Deutsch // English
; Platform				: Win2k // WinXP // WinVista
; Author				: <= 0.9.0.5 @ denick // >= 0.9.0.6 @ ladiko
; Script Function		: Alternative Gui for AHK2EXE.EXE
; --------------------------------------------------------------------------------
; This script analyses a scriptname.ahk.ini , that is present inside of a script's
; directory or creates it , when not present and controls the Compiler call and the
; possibly ResHack call.
; To use Compile_AHK you have to call it with the full path of a script as
; command line Parameter
; --------------------------------------------------------------------------------
; Das Script wertet eine im Scriptverzeichnis vorhandene scriptname.ahk.ini aus
; und steuert damit den Compiler- und ggf. ResHack-Aufruf. Ggf. wird die ini-Datei
; mit Defaultwerten neu angelegt.
; Der vollst?ndige Pfad des Scripts muss als KommandozeilenParameter übergeben
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

IfNotExist , %A_TEMP%\AutoHotkey\Compiler
	FileCreateDir , %A_TEMP%\AutoHotkey\Compiler
SetWorkingDir , %A_TEMP%\AutoHotkey\Compiler


GoSub , DefineVariables
GoSub , CheckPortableApp
GoSub , ReadLanguage
GoSub , CheckInstall
GoSub , CommandLine
; --------------------------------------------------------------------------------
; INI File
; --------------------------------------------------------------------------------
If FileExist(Ini_File) {
	_READ_INI(Ini_File)
} Else If FileExist(Defaults_Ini) {
	_READ_INI(Defaults_Ini)
}
; --------------------------------------------------------------------------------
; Compilation Settings Gui
; --------------------------------------------------------------------------------
_Set_Gui_VERS()
Gosub , GuiShow
Return
; ================================================================================
; FUNCTIONS AND METHODS SECTION ==================================================
; ================================================================================
; --------------------------------------------------------------------------------
; Gui Button Compile
; --------------------------------------------------------------------------------
GuiBTCompile:
	Gui , Submit
	If !_Get_Gui_Values() {
		Return
	}

	SplitPath , Exe_File , Out_Name , Out_Dir
	; --------------------------------------------------------------------------------
	; New Log File
	; --------------------------------------------------------------------------------
	Error_Message := "Delete old log file Error!`n"
	IfExist , %A_WorkingDir%\%Log_File%
	{
		FileDelete , %A_WorkingDir%\%Log_File%
		If ErrorLevel
			_Error_Exit(Error_Message . "Couldn't delete """ . Log_File . """")
	}
	
	; --------------------------------------------------------------------------------
	; Run Before
	; --------------------------------------------------------------------------------
	If (Run_Before != "") {
		_Run_Before()
	}
	
	; --------------------------------------------------------------------------------
	; No UPX
	; --------------------------------------------------------------------------------
	If (No_UPX && FileExist(A_WorkingDir . "\" . UPX_Exe))
		Delete_UPX()
	
	; --------------------------------------------------------------------------------
	; copy lib directory
	; --------------------------------------------------------------------------------
	_Copy_Lib_Dir()
	
	; --------------------------------------------------------------------------------
	; Use alternative bin file
	; --------------------------------------------------------------------------------
	If Alt_Bin !=
		Use_Alt_Bin()
	
	; --------------------------------------------------------------------------------
	; Version Info
	; --------------------------------------------------------------------------------
	If (Set_Version_Info) {
		_Set_Version()
	}
	
	; --------------------------------------------------------------------------------
	; Change Icons
	; --------------------------------------------------------------------------------
	Loop , %Icon_Count%
	{
		If (Icon_%A_Index%_Set || Icon_%A_Index%_Delete)
		{
			_Change_Icons()
			Break
		}
	}
	; --------------------------------------------------------------------------------
	; Modify Manifest for Vista Administrator Exection Level (User Account Control)
	; --------------------------------------------------------------------------------
	If (Execution_Level > 1) {
		_Mod_Manifest()
	}
	Else {
		Error_Message := "Check Exename Error!`n"
		_Check_ExeName()
	}
	
	; --------------------------------------------------------------------------------
	; Add Resources to AutoHotkeySC.bin
	; --------------------------------------------------------------------------------
	If (LV_GetCount()) {
		Import_Resources()
	} Else {
		Resource_Files := ""
	}
	
	; --------------------------------------------------------------------------------
	; Compile
	; --------------------------------------------------------------------------------
	If (!_Compile_AHK()) {
		FileRead , Compiler_Error , %Log_File%
		_Error_Exit(Error_Message . Compiler_Error)
	}
	
	; --------------------------------------------------------------------------------
	; Renew created date
	; --------------------------------------------------------------------------------
	If (Created_Date && FileExist(Exe_File))
		Renew_Created_Date()
	
	; --------------------------------------------------------------------------------
	; Run After
	; --------------------------------------------------------------------------------
	If (Run_After != "") {
		_Run_After()
	}
	
	; --------------------------------------------------------------------------------
	; Rewrite INI
	; --------------------------------------------------------------------------------
	_WRITE_INI(Ini_File)
	
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
	Gui , Add , Tab , Choose1 x0 w555 h410 vGui_Tabs , %Lang_Tabs%
	Gui , Tab , 1

	Gui , Add , Text , Section x+20 y+17 h20 w120 +0x1000 vGui_Script_File , %Lang_Script_File%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGui_In_File ReadOnly , %In_File%
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Alt_Bin , AutoHotkeySC.bin
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp w30 vGui_Alt_Bin_Set gGuiActivateAltBin Checked%Alt_Bin_Set%
	Gui , Add , Edit , x+00 yp h20 w250 vGui_Alt_Bin , %Alt_Bin%
	Gui , Add , Button , x+20 yp-1 h22 w70 vGui_Select_Alt_Bin gGuiBTSelBin , %Lang_Select%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Exe_File , %Lang_Exe_File%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGui_Exe_File , %Exe_File%
	Gui , Add , Button , x+20 yp-1 h22 w70 vGui_Select_Exe_File gGuiBTSelFile , %Lang_Select%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Compression, %Lang_Compression%
	Gui , Font , cBlack
	Gui , Add , DDL , x+20 yp w100 vGui_Compression_Levels AltSubmit , %Lang_Compression_Levels%
	Gui_Compression_Levels := Compression + 1
	GuiControl , Choose , Gui_Compression_Levels , %Gui_Compression_Levels%
	Gui , Add , Checkbox , x+20 yp w80 Checked%No_UPX% vGui_No_UPX , %Lang_No_UPX%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Password, %Lang_Password%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w190 vGui_Password Password , %Password%
	Gui , Add , Button , x+10 yp-1 h22 w80 gGui_Gen_Pass vGui_Generate, %Lang_Generate%
	Gui , Add , Checkbox , x+20 yp w80 Checked%Show_Pwd% vGui_Show_Pwd gGuiShowPwd , %Lang_Show_Pwd%
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Run_Before , %Lang_Run_Before%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGui_Run_Before , %Run_Before%
	Gui , Add , Button , x+20 yp-1 h22 w70 gGuiBTRunBefore vGui_Select_Run_Before , %Lang_Select%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Run_After , %Lang_Run_After%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w280 vGui_Run_After , %Run_After%
	Gui , Add , Button , x+20 yp-1 h22 w70 gGuiBTRunAfter vGui_Select_Run_After , %Lang_Select%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Vista_UAC , %Lang_Vista_UAC%
	Gui , Add , Text , x+20 yp w100 h20 vGui_Text_Execution_Level , %Lang_Execution_Level%:
	Gui , Add , DropDownList , x+20 yp w160 AltSubmit Choose%Execution_Level% vGui_Execution_Levels , %Lang_Execution_Levels%
	Gui , Add , Button , x+20 yp-1 w70 h22 vGui_Help gExecution_Level_Help , %Lang_Help%
	
	Gui , Font , cNavy
	Gui , Add , Text , xs y+17 h20 w120 +0x1000 vGui_Text_Other_Options, %Lang_Other_Options%
	Gui , Add , Checkbox , x+20 yp w180 h20 vGui_NoDecompile Checked%NoDecompile% , %Lang_NoDecompile%
	Gui , Add , Checkbox , x+20 yp w180 h20 vGui_Created_Date Checked%Created_Date% , %Lang_Created_Date%

	Gui , Tab , 2
	Gui , Add , Checkbox , x+20 y+20 gGui_CB_VI w150 vGui_Set_Version_Info Checked%Set_Version_Info% , %Lang_Set_Version_Info%

	Gui , Font , cNavy
	Gui , Add , Text , Section xp y+10 h20 w120 +0x1000 vGui_Text_Company_Name , %Lang_Company_Name%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_Company_Name , %Company_Name%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_File_Description , %Lang_File_Description%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_File_Description , %File_Description%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_File_Version , %Lang_File_Version%
	Gui , Font , cBlack
	Gui , Add , Edit , Center x+20 yp h20 w50 vGui_TFV1 , 
	Gui , Add , Updown , vGui_FV1 Range0-9999 , %Gui_FV1%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TFV2 , 
	Gui , Add , Updown , vGui_FV2 Range0-9999 , %Gui_FV2%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TFV3 , 
	Gui , Add , Updown , vGui_FV3 Range0-9999 , %Gui_FV3%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TFV4 , 
	Gui , Add , Updown , vGui_FV4 Range0-9999 , %Gui_FV4%
	Gui , Add , Checkbox , x+20 gGui_CB_INC vGui_Inc_File_Version Checked%Inc_File_Version% , %Lang_Autoincrement%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_Internal_Name , %Lang_Internal_Name%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_Internal_Name , %Internal_Name%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_Legal_Copyright , %Lang_Legal_Copyright%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_Legal_Copyright , %Legal_Copyright%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_Original_Filename , %Lang_Original_Filename%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_Original_Filename , %Original_Filename%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_Product_Name , %Lang_Product_Name%
	Gui , Font , cBlack
	Gui , Add , Edit , x+20 yp h20 w320 vGui_Product_Name , %Product_Name%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+10 h20 w120 +0x1000 vGui_Text_Product_Version , %Lang_Product_Version%
	Gui , Font , cBlack
	Gui , Add , Edit , Center x+20 yp h20 w50 vGui_TPV1 , 
	Gui , Add , Updown , vGui_PV1 Range0-9999 , %Gui_PV1%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TPV2 , 
	Gui , Add , Updown , vGui_PV2 Range0-9999 , %Gui_PV2%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TPV3 , 
	Gui , Add , Updown , vGui_PV3 Range0-9999 , %Gui_PV3%
	Gui , Add , Edit , Center x+0 yp h20 w50 vGui_TPV4 , 
	Gui , Add , Updown , vGui_PV4 Range0-9999 , %Gui_PV4%
	Gui , Add , Checkbox , yp-3 x+20 gGui_CB_SAV vGui_Set_AHK_Version Checked%Set_AHK_Version% , %Lang_Set_AHK_Version%
	Gui , Add , Checkbox , xp yp+16 gGui_CB_INC vGui_Inc_Product_Version Checked%Inc_Product_Version% , %Lang_Autoincrement%

	Gui , Font , cNavy
	Gui , Add , Text , xs y+7 h20 w120 +0x1000 vGui_Text_Language_ID , %Lang_Language_ID%
	Gui , Font , cBlack
	Gui , Add , DropDownList , x+20 w200 yp AltSubmit Choose%Language_ID% vGui_Language_ID , %Language_IDS%
	Gui , Font , cNavy
	Gui , Add , Text , xs y+7 h20 w120 +0x1000 vGui_Text_Charset , %Lang_Charset%
	Gui , Font , cBlack
	Gui , Add , DropDownList , x+20 w200 yp AltSubmit Choose%Charset% vGui_Charset , %Charsets%


	Gui , Tab , 3
	Gui , Font , cNavy
	Gui , Add , Text , Section x+20 y+20 h20 w130 +0x1000 vGui_Text_Icon_1 , %Lang_Main_Icon%
	Gui , Add , Checkbox , x+20 yp vGui_Icon_1_Set gGuiActivateIcon Checked%Icon_1_Set%
	Gui , Font , cBlack
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_1 gGuiEDIcon , %Icon_1%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_1_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_1_Pic , %Icon_1%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_1_Delete gGuiActivateIcon Checked%Icon_1_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_2 , %Lang_Shortcut_Icon%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_2_Set gGuiActivateIcon Checked%Icon_2_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_2 gGuiEDIcon , %Icon_2%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_2_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_2_Pic , %Icon_2%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_2_Delete gGuiActivateIcon Checked%Icon_2_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_3 , %Lang_Suspend_Icon%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_3_Set gGuiActivateIcon Checked%Icon_3_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_3 gGuiEDIcon , %Icon_3%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_3_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_3_Pic , %Icon_3%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_3_Delete gGuiActivateIcon Checked%Icon_3_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_4 , %Lang_Pause_Icon%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_4_Set gGuiActivateIcon Checked%Icon_4_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_4 gGuiEDIcon , %Icon_4%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_4_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_4_Pic , %Icon_4%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_4_Delete gGuiActivateIcon Checked%Icon_4_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_5 , %Lang_Suspend_Pause_Icon%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_5_Set gGuiActivateIcon Checked%Icon_5_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_5 gGuiEDIcon , %Icon_5%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_5_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_5_Pic , %Icon_5%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_5_Delete gGuiActivateIcon Checked%Icon_5_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_6 , %Lang_Main_Icon_9x%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_6_Set gGuiActivateIcon Checked%Icon_6_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_6 gGuiEDIcon , %Icon_6%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_6_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_6_Pic , %Icon_6%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_6_Delete gGuiActivateIcon Checked%Icon_6_Delete% , %Lang_Delete%

	Gui , Font , cNavy
	Gui , Add , Text , Section xs y+8 h20 w130 +0x1000 vGui_Text_Icon_7 , %Lang_Suspend_Icon_9x%
	Gui , Font , cBlack
	Gui , Add , Checkbox , x+20 yp vGui_Icon_7_Set gGuiActivateIcon Checked%Icon_7_Set%
	Gui , Add , Edit , x+0 yp h20 w190 vGui_Icon_7 gGuiEDIcon , %Icon_7%
	Gui , Add , Button , x+20 yp h20 w70 vGui_Icon_7_BT gGuiBTSelIcon , %Lang_Select%
	Gui , Add , Picture , x+20 yp-5 w32 h32 vGui_Icon_7_Pic , %Icon_7%
	Gui , Add , Checkbox , xs w100 yp+28 vGui_Icon_7_Delete gGuiActivateIcon Checked%Icon_7_Delete% , %Lang_Delete%
	
	Gui , Tab , 4
	Gui , Add , ListView , x+20 y+20 w500 h286 Grid vGui_Resource_ListView , %Lang_Resource_ListView%
	Gui , Add , Button , xp+145 y+10 w100 h23 vGui_Add_Resource gSelect_Resource , %Lang_Add_Resource%
	Gui , Add , Button , x+10 yp w100 h23 vGui_Remove_Resource gRemove_Resource , %Lang_Remove_Resource%

	Gui , Tab
	Gui , Add , Button , Default xs y370 h25 w70 vGui_Compile gGuiBTCompile , %Lang_Compile%
	Gui , Add , Button , xp+430 yp h25 w80 vGui_Cancel gGuiClose , %Lang_Cancel%

	Gui , Add , Picture , xm+294 ym+4 h16 w16 hidden vGui_ON_TOP_ON gGui_ON_TOP_OFF AltSubmit Icon2 , %A_ScriptName%
	Gui , Add , Picture , xm+294 ym+4 h16 w16 vGui_ON_TOP_OFF gGui_ON_TOP_ON AltSubmit Icon3 , %A_ScriptName%

	Gui , Add , Button , xm+314 ym h25 w80 vGui_Save_Defaults gGuiSave_Defaults , %Lang_Save_Defaults%
	Gui , Add , Button , xm+394 ym h25 w60 vGui_Credits gShowCredits , &%Lang_Credits%
	
	LangHelp_AddLangDropDownMenu(possibleLangs, Lang_MenulanguageTitel, actualLang)
	
	If (Resource_Files)
		Add_Resource(Resource_Files)

	GoSub , Gui_CB_INC
	GoSub , Gui_CB_SAV

	If (!Set_Version_Info) {
		_Gui_DeActivate_Version_Info("Disable")
	}

	GoSub , GuiShowPwd
	GoSub , GuiActivateIcon
	GoSub , GuiActivateAltBin
	If Auto_Compile
		GoSub , GuiBTCompile
	Else
	{
		OnMessage(0x200, "WM_MOUSEMOVE") ; tooltips
		Gui , Show , Autosize , %Gui_Title% - %IN_NAME%.%IN_EXT%
	}		
	GuiControl , Focus , Compile
Return
; --------------------------------------------------------------------------------
; Gui Close
; --------------------------------------------------------------------------------
GuiClose:
GuiEscape:
	Gui , Destroy
	Error_Message := "Compilation canceled!"
	_Error_Exit(Error_Message)
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
IfInString , A_GuiControl , Gui_Icon_
	IfNotInString , A_GuiControl , _Set
		GuiControl , , %A_GuiControl% , %A_GuiEvent%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Exe File
; --------------------------------------------------------------------------------
GuiBTSelFile:
	Gui , Submit , NoHide
	SplitPath , Gui_Exe_File , Out_Name , Out_Dir
	_Select_FOLDER(Out_Dir)
	GuiControl , , Gui_Exe_File , %Out_Dir%\%Out_Name%
Return
; --------------------------------------------------------------------------------
; Gui Save Default Settings
; --------------------------------------------------------------------------------
GuiSave_Defaults:
	Gui , Submit , NoHide
	If !_Get_Gui_Values() {
		Return
	}
	_WRITE_INI(Defaults_Ini)
Return

; --------------------------------------------------------------------------------
; Gui OnTop On
; --------------------------------------------------------------------------------

Gui_ON_TOP_ON:
	Gui , +AlwaysOnTop
	
	GuiControl , Hide , Gui_ON_TOP_OFF
	GuiControl , Show , Gui_ON_TOP_ON
Return
; --------------------------------------------------------------------------------
; Gui OnTop Off
; --------------------------------------------------------------------------------
Gui_ON_TOP_OFF:
	Gui , -AlwaysOnTop
	
	GuiControl , Hide , Gui_ON_TOP_ON
	GuiControl , Show , Gui_ON_TOP_OFF
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiActivateIcon:
	Gui , Submit , NoHide
	
	Loop , %Icon_Count% {
		TempControlName = Gui_Icon_%A_Index%_Set
		TempControl2Name = Gui_Icon_%A_Index%_Delete
		TempControl2State := %TempControl2Name%

		GuiControl , Disable%TempControl2State% , Gui_Text_Icon_%A_Index%
		GuiControl , Disable%TempControl2State% , Gui_Icon_%A_Index%_Set
		GuiControl , Disable%TempControl2State% , Gui_Icon_%A_Index%
		GuiControl , Disable%TempControl2State% , Gui_Icon_%A_Index%_BT
		GuiControl , Disable%TempControl2State% , Gui_Icon_%A_Index%_Pic
		
		If (%TempControlName% AND !%TempControl2Name%) {
			; enable
			GuiControl , Enable , Gui_Icon_%A_Index%
			GuiControl , Enable , Gui_Icon_%A_Index%_BT
		} Else {
			; disable
			GuiControl , , Gui_Icon_%A_Index%_Set , 0
			GuiControl , Disable , Gui_Icon_%A_Index%
			GuiControl , Disable , Gui_Icon_%A_Index%_BT
			GuiControl , , Gui_Icon_%A_Index% , 
			GuiControl , , Gui_Icon_%A_Index%_Pic , 
		}
	}
Return

GuiActivateAltBin:
	Gui , Submit , NoHide
	If (Gui_Alt_Bin_Set)
	{
		; enable
		GuiControl , Enable , Gui_Alt_Bin
		GuiControl , Enable , Gui_Select_Alt_Bin
	}
	Else
	{
		; disable
		GuiControl , Disable , Gui_Alt_Bin
		GuiControl , Disable , Gui_Select_Alt_Bin
		GuiControl , , Gui_Alt_Bin
	}
Return
; --------------------------------------------------------------------------------
; Gui Button Generate Password
; --------------------------------------------------------------------------------
Gui_Gen_Pass:
	GuiControl , , Gui_Password , % GenPassword()
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
	_Select_FILE(Gui_Alt_Bin , "BIN")
	GuiControl , , Gui_Alt_Bin , %Gui_Alt_Bin%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Icon
; --------------------------------------------------------------------------------
GuiBTSelIcon:
	Gui , Submit , NoHide
	
	Error_Message := "Error Selecting icon file!`n"
	
	; icon fix for Win9x by Drugwash
	if A_OSType in WIN32_WINDOWS
		shell := A_WinDir . "\system\shell32.dll"
	else
		shell := A_WinDir . "\system32\shell32.dll"

	VarSetCapacity(SourceFile , 260)

	SourceFileName := "Gui_Icon_" . SubStr(A_GuiControl , -3 , 1)
	SourceFile := %SourceFileName%
	
	If (SourceFile = "" || !FileExist(SourceFile))
		SourceFile := shell
	nIndex := 0

	; WinGet , hWnd , ID , PickIconDlg
	WinGet , hWnd , ID , A
	
	; icon fix for Win9x by Drugwash
	if A_OSType in WIN32_WINDOWS
	{
		If !DllCall(DllCall("GetProcAddress", "Uint", DllCall("LoadLibrary", "str", "shell32.dll"), "Uint", 62), "Uint", hWnd, "Uint", &SourceFile, "Uint", 260, "intP", nIndex)
			Return ; cancel was clicked or something else failed
		DllCall("FreeLibrary", "str", "shell32.dll")
	}
	else
	{
		VarSetCapacity(wSourceFile , 260 * 2)
		DllCall("MultiByteToWideChar" , "Uint" , 0 , "Uint" , 0 , "str" , SourceFile , "int" , -1 , "str" , wSourceFile , "int" , 260)
	
		If !DllCall("shell32\PickIconDlg" , "Uint" , hWnd , "str" , wSourceFile , "Uint" , 260 , "intP" , nIndex)
			Return ; cancel was clicked or something else failed
	
		VarSetCapacity(SourceFile , 260)
		DllCall("WideCharToMultiByte" , "Uint" , 0 , "Uint" , 0 , "str" , wSourceFile , "int" , -1 , "str" , SourceFile , "int" , 260 , "Uint" , 0 , "Uint" , 0)
	
		StringReplace , SourceFile , SourceFile , `%SystemRoot`% , %A_WinDir%
	}
	
	IconFile := In_File . "_" . SubStr(A_GuiControl , -3 , 1) . ".ico"
	SplitPath , IconFile , IconFileName
	
	SplitPath , SourceFile , , SourceFileDir , SourceFileExt
	StringLower, %SourceFileExt%, %SourceFileExt%
	
	If (SourceFileExt = "ICO")
	{
		If (SourceFileDir = In_Dir)
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
						_Error_Exit(Error_Message . s_ERR)
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
	
		s_Sc_File := A_WorkingDir . "\ExtractIcon.script"
		
		s_Script := "[FILENAMES]`n"
				. "Exe=" . SourceFile . "`n"
				. "SaveAs=" . IconFile . "`n"
				. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
				. "[COMMANDS]`n"
				. "-extract """ . IconFile . """ , ICONGROUP , " . IconGroupID . " , "
	
		FileDelete , %s_Sc_File%
		FileAppend , %s_Script% , %s_Sc_File%
		
		s_CMD := """" . A_ScriptDir . "\" Res_Exe . """"
				. " -script "
				. """" . s_Sc_File . """"
		
		FileAppend , `n* Extract Icon from file:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
		
		RunWait , %s_CMD% , , UseErrorLevel Hide
		If Errorlevel
		{
			FileRead , s_Log , A_WorkingDir . "\" . %Res_Log%
			s_ERR := "Couldn't extract icon file , " . Res_Exe . " failed!`n" . s_Log
			_Error_Exit(Error_Message . s_ERR)
		}
		FileRead , s_Log , %A_WorkingDir%\%Res_Log%
		IfInString , s_Log , ERROR:
		{
			s_ERR := "Couldn't extract icon file , " . Res_Exe . " failed!`n" . s_Log
			_Error_Exit(Error_Message . s_ERR)
		}
		FileDelete , %A_WorkingDir%\%Res_Log%
		FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest extracted successfully!`n`n , %A_WorkingDir%\%Log_File%
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
		GuiControl , , %A_GuiControl%_Pic , *w32 *h32 %SourceFile%
	Else
		GuiControl , , %A_GuiControl%_Pic
Return
; --------------------------------------------------------------------------------
; Gui Button Select Show or Hide Password
; --------------------------------------------------------------------------------
GuiShowPwd:
	Gui , Submit , NoHide
	If (Gui_Show_Pwd)
		GuiControl , -Password , Gui_Password
	Else
		GuiControl , +Password , Gui_Password
	GuiControl , Focus , Gui_Password
Return
; --------------------------------------------------------------------------------
; Gui Button Select Run Before
; --------------------------------------------------------------------------------
GuiBTRunBefore:
	Gui , Submit , NoHide
	_Select_FILE(Gui_Run_Before , "RUN")
	GuiControl , , Gui_Run_Before , %Gui_Run_Before%
Return
; --------------------------------------------------------------------------------
; Gui Button Select Run After
; --------------------------------------------------------------------------------
GuiBTRunAfter:
	Gui , Submit , NoHide
	_Select_FILE(Gui_Run_After , "RUN")
	GuiControl , , Gui_Run_After , %Gui_Run_After%
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Version Info
; --------------------------------------------------------------------------------
Gui_CB_VI:
	Gui , Submit , NoHide
	If (Gui_Set_Version_Info) {
		_Gui_DeActivate_Version_Info("Enable")
	} Else {
		_Gui_DeActivate_Version_Info("Disable")
	}
Return
; --------------------------------------------------------------------------------
; Gui Checkbox Set AHK Version
; --------------------------------------------------------------------------------
Gui_CB_SAV:
	Gui , Submit , NoHide
	If (Gui_Set_AHK_Version) {
		GuiControl , Disable , Gui_Inc_Product_Version
		GuiControl , , Gui_Inc_Product_Version , 0
		;split AHK_Version to four values
		StringSplit , a_V , s_OrgComp , .
		Loop , %a_V0%
		{
			GuiControl , Disable , Gui_TPV%A_Index%
			Value := a_V%A_Index%
			GuiControl , , Gui_TPV%A_Index% , %Value%
		}
	} Else {
		GuiControl , Enable , Gui_Inc_Product_Version
		If (!Gui_Inc_Product_Version)
			Loop , %a_V0%
				GuiControl , Enable , Gui_TPV%A_Index%
	}
Return
; --------------------------------------------------------------------------------
; Gui Autoincrement Version
; --------------------------------------------------------------------------------
Gui_CB_INC:
	Gui , Submit , NoHide
	
	;split Product_Version and File_Version to four values
	StringSplit , a_PV , Product_Version , .
	StringSplit , a_FV , File_Version , .
	
	If (A_GuiControl = "Gui_Inc_Product_Version" || A_GuiControl = "")
	{
		If (Gui_Inc_Product_Version)
		{
			
			GuiControl , Disable , Gui_Set_AHK_Version
			GuiControl , , Gui_Set_AHK_Version , 0
			Inc_Version_Helper("PV")
		}
		Else {
			GuiControl , Enable , Gui_Set_AHK_Version
			Loop , %a_PV0%
				GuiControl , Enable , Gui_TPV%A_Index%
		}
	}
	
	If (A_GuiControl = "Gui_Inc_File_Version" || A_GuiControl = "")
	{
		If (Gui_Inc_File_Version)
		{
			Inc_Version_Helper("FV")
		}
		Else {
			Loop , %a_FV0%
				GuiControl , Enable , Gui_TFV%A_Index%
		}
	}
Return
; --------------------------------------------------------------------------------
; Increments version - type: FV or PV
; --------------------------------------------------------------------------------
Inc_Version_Helper(Type)
{
	Global
	
	increment = 1
	Loop % a_%Type%0
	{
		ReverseIndex := 5 - A_Index
		GuiControl , Disable , Gui_T%Type%%ReverseIndex%
		
		;Set old version's value
		Value := a_%Type%%ReverseIndex%
		
		If(increment)
		{
			If Value = 999
				GuiControl , , Gui_T%Type%%ReverseIndex% , 0
			Else
			{
				Value++
				GuiControl , , Gui_T%Type%%ReverseIndex% , %Value%
				increment = 0
			}
		}
		Else
			GuiControl , , Gui_T%Type%%ReverseIndex% , %Value%
	}
	Return
}
; ================================================================================
; FUNCTIONS SECTION ==============================================================
; ================================================================================
; Check AHK Compiler Version
; --------------------------------------------------------------------------------
_CHECK_AHK()
{
	Global
	Local s_UsedComp , s_OrgUPX , s_UsedUPX
	FileGetVersion , s_OrgComp , %AHK_Compiler_DIR%\%Compiler%
	FileGetVersion , s_UsedComp , %A_WorkingDir%\%Compiler%
	If (s_OrgComp <> s_UsedComp) {
		FileCopy , %AHK_Compiler_DIR%\%Compiler% , %A_WorkingDir%\%Compiler% , 1
		If (Errorlevel) {
			_Error_Exit(Error_Message . "Couldn't copy new " . Compiler)
		}
	}
	FileGetVersion , s_OrgUPX , %AHK_Compiler_DIR%\%UPX_Exe%
	FileGetVersion , s_UsedUPX , %A_WorkingDir%\%UPX_Exe%
	If (s_OrgUPX <> s_UsedUPX) {
		FileCopy , %AHK_Compiler_DIR%\%UPX_Exe% , %A_WorkingDir%\%UPX_Exe% , 1
		If (Errorlevel) {
			_Error_Exit(Error_Message . "Couldn't copy new " . UPX_Exe)
		}
	}
	FileCopy , %AHK_Compiler_DIR%\%Bin_File% , %A_WorkingDir%\%Bin_File% , 1
	If (Errorlevel) {
		_Error_Exit(Error_Message . "Couldn't copy """ . AHK_Compiler_Dir . "\" . Bin_File . """ to """ . A_WorkingDir . """.")
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
	VarSetCapacity(Param , 12 , 0) , NumPut(IconIndex , Param , 0)
	; to work with enabled DEP --> http://www.autohotkey.com/forum/viewtopic.php?t=25480
	DllCall("VirtualProtect", "uint", enumproc, "uint", 8, "uint", 0x40, "uint*", 0)
	; Enumerate the icon group resources. (RT_GROUP_ICON=14)
	DllCall("EnumResourceNames" , "uint" , hmod , "uint" , 14 , "uint" , enumproc , "uint" , &Param)
	DllCall("GlobalFree" , "uint" , enumproc)

	; If we loaded the DLL , free it now.
	if loaded
		DllCall("FreeLibrary" , "uint" , hmod)

	Return NumGet(Param , 8) ? NumGet(Param , 4) : ""
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
	YPos0 := WinH - 8	; Bottom of GUI Window
	YPos1 := YPos0 + 40	; Gap
	YPos2 := YPos1 + 48
	YPos3 := YPos2 + 48
	YPos4 := YPos3 + 48
	YPos5 := YPos4 + 48
	YPos6 := YPos5 + 48
	YPos7 := YPos6 + 48
	YPos8 := YPos7 + 48
	YPos9 := YPos8 + 48
	YPos10 := YPos9 + 64

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
	Gui, 2:Add, Text , x12 vText_1 y%YPos0% , .:[ Compile_AHK ]:.
	Gui, 2:Font, norm
	
	Gui 2:Add, Picture, vIcon1 x12 y%YPos1% h32 w32 Icon13, shell32.dll
	Gui 2:Add, Text, vURL_1 gOpenLink x48, AutoHotkey by Chris
	
	Gui 2:Add, Picture, vIcon2 x12 y%YPos2% h32 w32 Icon174, shell32.dll
	Gui 2:Add, Text, vURL_2 gOpenLink x48, Developed by de/nick
	
	Gui 2:Add, Picture, vIcon3 x12 y%YPos3% h32 w32 Icon1, %A_ScriptFullPath%
	Gui 2:Add, Text, vURL_3 gOpenLink x48, Enhanced by ladiko
	
	Gui 2:Add, Picture, vIcon4 x12 y%YPos4% h32 w32 Icon172, shell32.dll
	Gui 2:Add, Text, vURL_4 gOpenLink x48, Debugged by jfk001
	
	Gui 2:Add, Picture, vIcon5 x12 y%YPos5% h32 w32 Icon142, shell32.dll
	Gui 2:Add, Text, vURL_5 gOpenLink x48, Graphics by Titan
	
	Gui 2:Add, Picture, vIcon6 x12 y%YPos6% h32 w32 Icon98, shell32.dll
	Gui 2:Add, Text, vURL_6 gOpenLink x48, Credits GUI by AGU && Laszlo
	
	Gui 2:Add, Picture, vIcon7 x12 y%YPos7% h32 w32 Icon100, shell32.dll
	Gui 2:Add, Text, vURL_7 gOpenLink x48, Language Helper by haichen
	
	Gui 2:Add, Picture, vIcon8 x12 y%YPos8% h32 w32 Icon81, shell32.dll
	Gui 2:Add, Text, vURL_8 gOpenLink x48, Resource Includer by Ripp3r]D3[
	
	Gui 2:Add, Picture, vIcon9 x12 y%YPos9% h32 w32 Icon14, shell32.dll
	Gui 2:Add, Text, vURL_9 gOpenLink x48, Help by The Community
	
	Gui 2:Add, Text, vText_2 x12 y%YPos10%, %MoreText%
	
	Gui 2:Show, w200 h%WinH%, %Lang_Credits%:
	
	; Retrieve scripts PID
	Process, Exist
	pid_this := ErrorLevel
 
	; Retrieve unique ID number (HWND/handle)
	WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
 
	; Call "HandleMessage" when script receives WM_SetCURSOR message
	WM_SetCURSOR = 0x20
	OnMessage(WM_SetCURSOR, "HandleMessage")
 
	; Call "HandleMessage" when script receives WM_MOUSEMOVE message
	WM_MOUSEMOVE = 0x200
	OnMessage(WM_MOUSEMOVE, "HandleMessage")

	Loop
	{
		IfWinNotExist , %Lang_Credits%:
			Break
		YPos0--
		GuiControl 2:Move, Text_1, y%YPos0%
		YPos1--
		GuiControl 2:Move, Icon1, y%YPos1%
		GuiControl 2:Move, URL_1, y%YPos1%
		YPos2--
		GuiControl 2:Move, Icon2, y%YPos2%
		GuiControl 2:Move, URL_2, y%YPos2%
		YPos3--
		GuiControl 2:Move, Icon3, y%YPos3%
		GuiControl 2:Move, URL_3, y%YPos3%
		YPos4--
		GuiControl 2:Move, Icon4, y%YPos4%
		GuiControl 2:Move, URL_4, y%YPos4%
		YPos5--
		GuiControl 2:Move, Icon5, y%YPos5%
		GuiControl 2:Move, URL_5, y%YPos5%
		YPos6--
		GuiControl 2:Move, Icon6, y%YPos6%
		GuiControl 2:Move, URL_6, y%YPos6%
		YPos7--
		GuiControl 2:Move, Icon7, y%YPos7%
		GuiControl 2:Move, URL_7, y%YPos7%
		YPos8--
		GuiControl 2:Move, Icon8, y%YPos8%
		GuiControl 2:Move, URL_8, y%YPos8%
		YPos9--
		GuiControl 2:Move, Icon9, y%YPos9%
		GuiControl 2:Move, URL_9, y%YPos9%
		YPos10--
		GuiControl 2:Move, Text_2, y%YPos10%
		
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
		Run, http://www.autohotkey.com/forum/topic6752.html
	Else If A_GuiControl = URL_7
		Run, http://www.autohotkey.com/forum/topic29003.html
	Else If A_GuiControl = URL_8
		Run, http://www.autohotkey.com/forum/topic37624.html
	Else If A_GuiControl = URL_9
		Run, http://www.autohotkey.com/forum/
	
Return
; --------------------------------------------------------------------------------
; URL Function
; --------------------------------------------------------------------------------
HandleMessage(p_w, p_l, p_m, p_hw)
{
	global	 WM_SetCURSOR, WM_MOUSEMOVE,
	static	 URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl
 
	If (p_m = WM_SetCURSOR)
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
				h_Old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
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
_READ_INI(s_Ini_File)
{
	Global
	Local s_INI
	Error_Message := "Error processing INI File!`n" . s_Ini_File . "`n"
	If (s_Ini_File != Defaults_Ini) {
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Exe_File , ERROR
		If (s_INI = "ERROR")
			IniRead , s_INI , %s_Ini_File% , %AHK_Section% , OUT_FILE , ERROR
		If (s_INI != "ERROR") {
			SplitPath , s_INI , , , s_EXT
			If (s_EXT = "exe") {
				StringReplace , s_INI , s_INI , `%In_Dir`% , %In_Dir%
				Exe_File := s_INI
			}
		}
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Alt_Bin , ERROR
	If (s_INI != "ERROR") {
		StringReplace , s_INI , s_INI , `%In_Dir`% , %In_Dir%
		If FileExist(s_INI)
		{
			Alt_Bin := s_INI
			Alt_Bin_Set := 1
		}
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Compression , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , UPX_LEVEL , ERROR
	If s_INI Between 0 and 4
	{
		Compression := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , No_UPX , ERROR
	If s_INI In 0,1
	{
		No_UPX := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Password , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , OUT_PASS , ERROR	
	If (s_INI != "ERROR") {
		Password := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Show_Pwd , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , SHOW_PASS , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_Error_Exit(Error_Message . "Show_Pwd = " . s_INI)
			Return
		}
		Show_Pwd := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , NoDecompile , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , OUT_DCMP , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_Error_Exit(Error_Message . "NoDecompile = " . s_INI)
			Return
		}
		NoDecompile := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Created_Date , ERROR
	If (s_INI != "ERROR") {
		If s_INI Not In 0,1
		{
			_Error_Exit(Error_Message . "Created_Date = " . s_INI)
			Return
		}
		Created_Date := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Run_Before , ERROR
	If (s_INI != "ERROR") {
		Run_Before := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Run_After , ERROR
	If (s_INI != "ERROR") {
		Run_After := s_INI
	}
	IniRead , s_INI , %s_Ini_File% , %AHK_Section% , Execution_Level , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %AHK_Section% , EXEC_LEVEL , ERROR
	If (s_INI != "ERROR") {
		Execution_Level := s_INI
	}

	Loop , %Icon_Count%
	{
		IniRead , s_INI , %s_Ini_File% , %ICO_Section% , Icon_%A_Index% , ERROR
		If (s_INI = 0) {
			Icon_%A_Index%_Delete := 1
		} Else If (s_INI != "ERROR") {
			StringReplace , s_INI , s_INI , `%In_Dir`% , %In_Dir%
			If FileExist(s_INI)
			{
				Icon_%A_Index% := s_INI
				Icon_%A_Index%_Set := 1
			}
		}
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Resource_Files , ERROR
	If (s_INI != "ERROR") {
		Resource_Files := s_INI
	}

	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Set_Version_Info , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , VERSION_INFO , ERROR
	If (s_INI = "ERROR") {
		Return
	}
	If s_INI Not In 0,1
	{
		_Error_Exit(Error_Message . "Set_Version_Info = " . s_INI)
		Return
	}
	Set_Version_Info := s_INI
	If !Set_Version_Info {
		Return
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Company_Name , ERROR
	If (s_INI != "ERROR") {
		Company_Name := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , File_Description , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , FILE_DESC , ERROR
	If (s_INI != "ERROR") {
		File_Description := s_INI
	}

	IniRead , s_INI , %s_Ini_File% , %RES_Section% , File_Version , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , FILE_VER , ERROR
	If (s_INI != "ERROR") {
		File_Version := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Inc_File_Version , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , INC_FILE_VER , ERROR
	If (s_INI != "ERROR") {
		Inc_File_Version := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Internal_Name , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , EXEC_LEVEL , ERROR
	If (s_INI != "ERROR") {
		Internal_Name := s_INI
	}

	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Legal_Copyright , ERROR
	If (s_INI != "ERROR") {
		Legal_Copyright := s_INI
	}

	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Original_Filename , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , ORG_FILENAME , ERROR
	If (s_INI != "ERROR") {
		Original_Filename := s_INI
	}

	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Product_Name , ERROR
	If (s_INI != "ERROR") {
		Product_Name := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Product_Version , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , PRODUCT_VER , ERROR
	If (s_INI != "ERROR") {
		Product_Version := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Set_AHK_Version , ERROR
	If (s_INI != "ERROR") {
		Set_AHK_Version := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Inc_Product_Version , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , INC_PROD_VER , ERROR
	If (s_INI != "ERROR") {
		Inc_Product_Version := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Language_ID , ERROR
	If (s_INI = "ERROR")
		IniRead , s_INI , %s_Ini_File% , %RES_Section% , LANG_ID , ERROR
	If (s_INI != "ERROR") {
		Language_ID := s_INI
	}
	
	IniRead , s_INI , %s_Ini_File% , %RES_Section% , Charset , ERROR
	If (s_INI != "ERROR") {
		Charset := s_INI
	}
	Return
}
; --------------------------------------------------------------------------------
; Write INI file
; --------------------------------------------------------------------------------
_WRITE_INI(s_Ini_File)
{
	Global
	Error_Message := "Error writing INI File!`n" . s_Ini_File . "`n"
	SplitPath , s_Ini_File , , s_ini_OutDir
	IfNotExist , %s_ini_OutDir%
	{
		FileCreateDir , %s_ini_OutDir%
		If ErrorLevel
			_Error(Error_Message . "`nCould not create the folder """ . s_ini_OutDir . """")
	}
	IfExist , %s_Ini_File%
	{
		FileDelete , %s_Ini_File%
		If ErrorLevel
			_Error(Error_Message . "`nCould not delete the file """ . s_Ini_File . """")
	}	
	If (s_Ini_File = Ini_File)
	{
		StringReplace , s_INI , Exe_File , %In_Dir% , `%In_Dir`%
		IniWrite , %s_INI% , %s_Ini_File% , %AHK_Section% , Exe_File
		
		; only for local ini file
		StringReplace , s_INI , Alt_Bin , %In_Dir% , `%In_Dir`%
	}
	
	IniWrite , %Alt_Bin% , %s_Ini_File% , %AHK_Section% , Alt_Bin
	
	IniWrite , %Compression% , %s_Ini_File% , %AHK_Section% , Compression
	IniWrite , %No_UPX% , %s_Ini_File% , %AHK_Section% , No_UPX
	IniWrite , %Password% , %s_Ini_File% , %AHK_Section% , Password
	IniWrite , %Show_Pwd% , %s_Ini_File% , %AHK_Section% , Show_Pwd
	IniWrite , %NoDecompile% , %s_Ini_File% , %AHK_Section% , NoDecompile
	IniWrite , %Created_Date% , %s_Ini_File% , %AHK_Section% , Created_Date
	; add quotation marks to deal problems with spaces in pathes
	IniWrite , "%Run_Before%" , %s_Ini_File% , %AHK_Section% , Run_Before
	IniWrite , "%Run_After%" , %s_Ini_File% , %AHK_Section% , Run_After
	IniWrite , %Execution_Level% , %s_Ini_File% , %AHK_Section% , Execution_Level
	IniWrite , %Set_Version_Info% , %s_Ini_File% , %RES_Section% , Set_Version_Info
	IniWrite , %Resource_Files% , %s_Ini_File% , %RES_Section% , Resource_Files
	
	If (Set_Version_Info)
	{
		IniWrite , %Company_Name% , %s_Ini_File% , %RES_Section% , Company_Name
		IniWrite , %File_Description% , %s_Ini_File% , %RES_Section% , File_Description
		IniWrite , %File_Version% , %s_Ini_File% , %RES_Section% , File_Version
		IniWrite , %Inc_File_Version% , %s_Ini_File% , %RES_Section% , Inc_File_Version
		IniWrite , %Internal_Name% , %s_Ini_File% , %RES_Section% , Internal_Name
		IniWrite , %Legal_Copyright% , %s_Ini_File% , %RES_Section% , Legal_Copyright
		IniWrite , %Original_Filename% , %s_Ini_File% , %RES_Section% , Original_Filename
		IniWrite , %Product_Name% , %s_Ini_File% , %RES_Section% , Product_Name
		IniWrite , %Product_Version% , %s_Ini_File% , %RES_Section% , Product_Version
		
		IniWrite , %Set_AHK_Version% , %s_Ini_File% , %RES_Section% , Set_AHK_Version
		IniWrite , %Inc_Product_Version% , %s_Ini_File% , %RES_Section% , Inc_Product_Version
		IniWrite , %Language_ID% , %s_Ini_File% , %RES_Section% , Language_ID
		IniWrite , %Charset% , %s_Ini_File% , %RES_Section% , Charset
	}
	Loop , %Icon_Count% {
		TempIconName := "Icon_" . A_Index
		TempIcon := %TempIconName%
		
		If (Icon_%A_Index%_Delete = 1)
			IniWrite , 0 , %s_Ini_File% , %ICO_Section% , %TempIconName%
		Else If (Icon_%A_Index%_Set)
		{
			If (s_Ini_File = Ini_File)
				; only for local ini file
				StringReplace , TempIcon , TempIcon , %In_Dir% , `%In_Dir`%
			IniWrite , %TempIcon% , %s_Ini_File% , %ICO_Section% , %TempIconName%
		}
	}
	Return
}
; --------------------------------------------------------------------------------
; Enable/Disable Version Info
; --------------------------------------------------------------------------------
_Gui_DeActivate_Version_Info(s_CMD)
{
	Global
	GuiControl , %s_CMD% , Gui_Company_Name
	GuiControl , %s_CMD% , Gui_File_Description
	GuiControl , %s_CMD% , Gui_TFV1
	GuiControl , %s_CMD% , Gui_TFV2
	GuiControl , %s_CMD% , Gui_TFV3
	GuiControl , %s_CMD% , Gui_TFV4
	GuiControl , %s_CMD% , Gui_FV1
	GuiControl , %s_CMD% , Gui_FV2
	GuiControl , %s_CMD% , Gui_FV3
	GuiControl , %s_CMD% , Gui_FV4
	GuiControl , %s_CMD% , Gui_Inc_File_Version
	GuiControl , %s_CMD% , Gui_Internal_Name
	GuiControl , %s_CMD% , Gui_Legal_Copyright
	GuiControl , %s_CMD% , Gui_Original_Filename
	GuiControl , %s_CMD% , Gui_Product_Name
	GuiControl , %s_CMD% , Gui_Language_ID
	GuiControl , %s_CMD% , Gui_Charset
	
	If !Gui_Set_AHK_Version {
		GuiControl , %s_CMD% , Gui_TPV1
		GuiControl , %s_CMD% , Gui_TPV2
		GuiControl , %s_CMD% , Gui_TPV3
		GuiControl , %s_CMD% , Gui_TPV4
		GuiControl , %s_CMD% , Gui_PV1
		GuiControl , %s_CMD% , Gui_PV2
		GuiControl , %s_CMD% , Gui_PV3
		GuiControl , %s_CMD% , Gui_PV4
		GuiControl , %s_CMD% , Gui_Inc_Product_Version
	}
	
	If !Gui_Inc_Product_Version
		GuiControl , %s_CMD% , Gui_Set_AHK_Version
	Return
}
; --------------------------------------------------------------------------------
; Set GUI Versions
; --------------------------------------------------------------------------------
_Set_Gui_VERS()
{
	Global
	Local aVersion0
	If (!Set_Version_Info) {
		Return
	}
	StringSplit , aVersion , File_Version , `. , %A_Space%
	Loop , %aVersion0%
		Gui_FV%A_Index% := aVersion%A_Index%
	StringSplit , aVersion , Product_Version , `. , %A_Space%
	Loop , %aVersion0%
		Gui_PV%A_Index% := aVersion%A_Index%
	Return
}
; --------------------------------------------------------------------------------
; Select Folder
; --------------------------------------------------------------------------------
_Select_FOLDER(ByRef s_DIR)
{
	Global
	Local s_SEL , s_PROMPT
	s_PROMPT := "Select Destination Folder:"
	FileSelectFolder , s_SEL , *%s_DIR% , 3 , %s_PROMPT%
	If (Errorlevel) {
		Return
	}
	s_Dir := s_SEL
	Return
}
; --------------------------------------------------------------------------------
; Select File
; --------------------------------------------------------------------------------
_Select_FILE(ByRef s_FILE , s_TYPE)
{
	Global
	
	Error_Message := "File section error Error!`n"
	Local s_SEL , s_EXT , s_OPTIONS , s_PROMPT , S_FILTER , s_FOLDER
	If s_TYPE = RUN
	{
		s_OPTIONS := "1"
		s_PROMPT := "Select Runnable File"
		s_FILTER := "Run (*.ahk;*.bat;*.cmd;*.exe)"
		s_FOLDER := In_Dir
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
		_Error_Exit(Error_Message . "`nFile type """ . s_Type . """ is unknown.")
	
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
_Get_Gui_Values()
{
	Global
	
	Exe_File := Gui_Exe_File
	Alt_Bin := Gui_Alt_Bin
	
	Loop , %Icon_Count%
	{
		TempIcon := Gui_Icon_%A_Index%
		If (TempIcon != "") {
			If Not FileExist(TempIcon) {
				
				Msgbox , 262192 , %MSG_TITLE% , Icon File %TempIcon% doesn't exist!
				GuiControl , Focus , Gui_Icon_%A_Index%
				Return False
			}
		}
		Icon_1 := Gui_Icon_1
	}
	Compression := Gui_Compression_Levels - 1
	No_UPX := Gui_No_UPX
	Password := Gui_Password
	Show_Pwd := Gui_Show_Pwd
	NoDecompile := Gui_NoDecompile
	Created_Date := Gui_Created_Date
	Run_Before := Gui_Run_Before
	Run_After := Gui_Run_After
	Execution_Level := Gui_Execution_Levels
	Set_Version_Info := Gui_Set_Version_Info
	If (Set_Version_Info) {
		Company_Name := Gui_Company_Name
		File_Description := Gui_File_Description
		File_Version := Gui_FV1 . "." . Gui_FV2 . "." . Gui_FV3 . "." . Gui_FV4
		Inc_File_Version := Gui_Inc_File_Version
		Internal_Name := Gui_Internal_Name
		Legal_Copyright := Gui_Legal_Copyright
		Original_Filename := Gui_Original_Filename
		Product_Name := Gui_Product_Name
		Product_Version := Gui_PV1 . "." . Gui_PV2 . "." . Gui_PV3 . "." . Gui_PV4

		Set_AHK_Version := Gui_Set_AHK_Version
		Inc_Product_Version := Gui_Inc_Product_Version
		
		Language_ID := Gui_Language_ID
		Charset := Gui_Charset
	}
	Loop , %Icon_Count% {
		Icon_%A_Index% := Gui_Icon_%A_Index%
		Icon_%A_Index%_Set := Gui_Icon_%A_Index%_Set
		Icon_%A_Index%_Delete := Gui_Icon_%A_Index%_Delete
	}
	Return True
}
; --------------------------------------------------------------------------------
; Run before
; --------------------------------------------------------------------------------
_Run_Before()
{
	Global
	Local s_CMD , s_ERR , s_Log , s_Out
	Error_Message := "Run Before Error!`n"
	s_CMD := Run_Before
			. " >> "
			. """" . A_WorkingDir . "\" . Log_File . """"
	
	StringReplace , s_CMD , s_CMD , % "%IF%" , %In_File% , All
	StringReplace , s_CMD , s_CMD , % "%OF%" , %Exe_File% , All
	StringReplace , s_CMD , s_CMD , % "%OD%" , %Out_Dir% , All
	StringReplace , s_CMD , s_CMD , % "%ON%" , %Out_Name% , All
	FileAppend , `n* Execute Run Before Command:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%ss
	RunWait , %ComSpec% /c "%s_CMD%" , %In_Dir% , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , %Log_File%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_Log
			_Error_Exit(Error_Message . s_ERR)
	}
	FileAppend , `n# Run Before executed successfully!`n`n , %A_WorkingDir%\%Log_File%
	Return
}
; --------------------------------------------------------------------------------
; Modify Manifest for Vista Administrator Exection Level (User Account Control)
; --------------------------------------------------------------------------------
_Mod_Manifest()
{
	Global
	Local s_CMD , s_ERR , s_Log , s_MANIFEST , XML_POS , s_LEFT , s_RIGHT , s_Sc_File , s_Mf_File , s_Ex_Level, i_Count
	
	Error_Message := "Modify Manifest Error!`n"
	
	s_Sc_File := A_WorkingDir . "\ExtractManifest.script"
	s_Mf_File := A_WorkingDir . "\" . Manifest_File
	
	s_Script := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "SaveAs=" . s_Mf_File . "`n"
			. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
			. "[COMMANDS]`n"
			. "-extract """ . s_Mf_File . """ , 24 , 1 , 1033"
	
	FileDelete , %s_Sc_File%
	FileAppend , %s_Script% , %s_Sc_File%
	
	s_CMD := """" . A_ScriptDir . "\" Res_Exe . """"
			. " -script "
			. """" . s_Sc_File . """"
	
	FileAppend , `n* Extract Manifest from binary file:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %s_CMD% , , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , A_WorkingDir . "\" . %Res_Log%
		s_ERR := "Couldn't extract manifest file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%Res_Log%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't extract manifest file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%Res_Log%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest extracted successfully!`n`n , %A_WorkingDir%\%Log_File%
	
	If Execution_Level = 4
		s_Ex_Level = requireAdministrator
	Else If Execution_Level = 3
		s_Ex_Level = highestAvailable
	Else
		s_Ex_Level = asInvoker
	
	FileRead , s_MANIFEST , %s_Mf_File%
	StringGetPos , XML_POS , s_MANIFEST , </ , R
	StringLeft , s_LEFT , s_MANIFEST , XML_POS
	StringTrimLeft , s_RIGHT , s_MANIFEST , XML_POS

	s_MANIFEST := RegExReplace(s_MANIFEST, "level\s*=\s*['""][^'""]*['""]", "level='" s_Ex_Level "'", i_count)
	if !i_count
		s_MANIFEST := s_LEFT
				. "<!-- Identify the application security requirements. -->`n"
				. "<!-- level can be ""asInvoker"" , ""highestAvailable"" , or ""requireAdministrator"" -->`n"
				. "	<trustInfo xmlns=""urn:schemas-microsoft-com:asm.v2"">`n"
				. "		<security>`n"
				. "			<requestedPrivileges>`n"
				. "				<requestedExecutionLevel level=""" . s_Ex_Level . """ uiAccess=""false"" />`n"
				. "			</requestedPrivileges>`n"
				. "		</security>`n"
				. "</trustInfo>`n"
				. s_RIGHT

	FileDelete , %s_Mf_File%
	FileAppend , %s_MANIFEST% , %s_Mf_File%

	s_Sc_File := A_WorkingDir . "\OverwriteManifest.script"
	
	s_Script := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
			. "[COMMANDS]`n"
			. "-addoverwrite """ . s_Mf_File . """ , 24 , 1 , 1033"
	
	FileDelete , %s_Sc_File%
	FileAppend , %s_Script% , %s_Sc_File%
	
	s_CMD := """" . A_ScriptDir . "\" Res_Exe . """"
			. " -script "
			. """" . s_Sc_File . """"
	
	FileAppend , `n* Overwrite Manifest in binary file:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %s_CMD% , , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , %A_WorkingDir%\%Res_Log%
		s_ERR := "Couldn't modify manifest file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%Res_Log%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't modify manifest file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%Res_Log%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Manifest overwritten successfully!`n`n , %A_WorkingDir%\%Log_File%

	FileSetTime , , %Bin_File% , M			;Is not set automatically
	; FileDelete , %Manifest_File%
	; FileDelete , %RES_Ini%
	; FileDelete , %Res_Log%


	Return
}
; --------------------------------------------------------------------------------
; Set Version
; --------------------------------------------------------------------------------
_Check_ExeName()
{
	Global
	Local elevated
	
	elevated = 0
	IfInstring , Exe_File , setup
		elevated = setup
	IfInstring , Exe_File , install
		elevated = install
	IfInstring , Exe_File , update
		elevated = update
	IfInstring , Exe_File , patch
		elevated = patch
	
	If elevated != 0
	{
		Button1Name = &Continue
		Button2Name = &Cancel
		MsgBoxTitle = Choice required
		MsgBoxText = Your executable's filename contains the word "%elevated%". If you continue, Windows Vista will automatically elevate your executable so that it need to run in administration mode.`n`nChose an execution level in the Compile_AHK Compiler settings to disable this message.
		SetTimer , ChangeButtonNames , 50
		MsgBox , 289 , %MsgBoxTitle% , %MsgBoxText%
		If Auto_Compile <> 2
		{
			IfMsgBox , Cancel
				_Error_Exit(Error_Message . "You have decided to cancel the compilation. Please try again!`n`nBye bye ... !")
		}
	}
	Return
}
; --------------------------------------------------------------------------------
; Set Version
; --------------------------------------------------------------------------------
_Set_Version()
{
	Global
	Local s_CMD , s_ERR , s_Log , s_File_Version , s_Product_Version , s_Rc_File , s_Res_File , s_Sc_File , s_Script , s_Language_ID , s_Charset
	
	Error_Message := "Set Version Error!`n"
	
	s_Language_ID := LCode_%Language_ID%
	s_Charset := SubStr( "0000" . ToBase(CCode_%Charset%,16) , -3) ; convert to hex and prepend up to 4 zeros
	
	s_Rc_File := "VersionInfo.rc"
	s_Res_File := "VersionInfo.res"
	IfNotExist , %A_ScriptDir%\%RC_EXE%
	{
		MsgBox, 262164, %MSG_TITLE%, %Error_Message%`nCouldn't find %A_ScriptDir%\%RC_EXE%`nWithout it the Version info can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	IfNotExist , %A_ScriptDir%\%Res_Exe%
	{
		MsgBox, 262164, %MSG_TITLE%, %Error_Message%`nCouldn't find %A_ScriptDir%\%Res_Exe%`nWithout it the Version info can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	
	FileDelete , %s_Rc_File%
	FileDelete , %s_Res_File%
	StringReplace , s_File_Version , File_Version , . , `, , All
	StringReplace , s_Product_Version , Product_Version , . , `, , All

	FileAppend , 
(
1 VERSIONINFO
FILEVERSION %s_File_Version%
PRODUCTVERSION %s_Product_Version%
FILEOS 0x4
FILETYPE 0x1
{
BLOCK "StringFileInfo"
{
		BLOCK "040904b0"
		{
			VALUE "CompanyName" , "%Company_Name%"
			VALUE "FileDescription" , "%File_Description%"
			VALUE "FileVersion" , "%File_Version%"
			VALUE "InternalName" , "%Internal_Name%"
			VALUE "LegalCopyright" , "%Legal_Copyright%"
			VALUE "OriginalFilename" , "%Original_Filename%"
			VALUE "ProductName" , "%Product_Name%"
			VALUE "ProductVersion" , "%Product_Version%"
		}
}
BLOCK "VarFileInfo"
{
	VALUE "Translation" , 0x%s_Language_ID% 0x%s_Charset%
}
}
) , %s_Rc_File%

	s_CMD := """" . A_ScriptDir . "\" RC_EXE . """"
			. " /r "
			. """" . A_WorkingDir . "\" . s_Rc_File . """"
			. " >> "
			. """" . A_WorkingDir . "\" . RC_Log . """"
	
	FileAppend , `n* Create resource file:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	IfNotExist , %A_WorkingDir%\%s_Res_File%
	{
		FileRead , s_Log , %RC_Log%
		s_ERR := "Couldn't set Version Info , " . RC_EXE . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %RC_Log%
	FileDelete , %A_WorkingDir%\%RC_Log%
	FileAppend , `n~~ GoRC Log Start ~~%s_Log%~~ GoRC Log End ~~`n`n# Resource file created successfully!`n`n , %A_WorkingDir%\%Log_File%
	
	s_Sc_File := A_WorkingDir . "\ChangeVersionInfo.script"
	
	s_Script := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
			. "[COMMANDS]`n"
; --------------------------------------------------------------------------------
; ResHacker-fix: cause the following command doesn't work:
; ResHacker.exe -addoverwrite , in.exe , out.exe , version.res , versioninfo , 1 , 1033
; the versioninfo with language ID 1033 has to be deleted to prevent double versioninfo
; --------------------------------------------------------------------------------
	s_Script := s_Script . "-delete Versioninfo , 1 , 1033`n"
; --------------------------------------------------------------------------------
	s_Script := s_Script . "-addoverwrite """ . A_WorkingDir . "\" . s_Res_File . """ , Versioninfo , 1 , `n"

	FileDelete , %s_Sc_File%
	FileAppend , %s_Script% , %s_Sc_File%
	
	s_CMD := """" . A_ScriptDir . "\" Res_Exe . """"
			. " -script "
			. """" . s_Sc_File . """"
	
	FileAppend , `n* Set Versioninfo (with ResHacker-fix for non-1033 systems):`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %s_CMD% , , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead , s_Log , %A_WorkingDir%\%Res_Log%
		s_ERR := "Couldn't set Version Info , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%Res_Log%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't set Version Info , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%Res_Log%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Set Versioninfo successfully!`n`n , %A_WorkingDir%\%Log_File%

	FileSetTime , , %A_WorkingDir%\%Bin_File% , M	;Is not set automatically
	; FileDelete , %s_Rc_File%
	; FileDelete , %s_Res_File%
	; FileDelete , %RES_Ini%
	; FileDelete , %Res_Log%
	Return
}
; --------------------------------------------------------------------------------
; Change Icons
; --------------------------------------------------------------------------------
_Change_Icons()
{
	Global
	Local s_Sc_File , s_Script , s_CMD , s_Log
	
	Error_Message := "Change Icons Error!`n"
	
	s_Sc_File := A_WorkingDir . "\ChangeIcon.script"
	
	IfNotExist , %A_ScriptDir%\%Res_Exe%
	{
		MsgBox, 262164, %MSG_TITLE%, %Error_Message%`nCouldn't find %A_ScriptDir%\%Res_Exe%`nWithout it the icons can't be changed!`n`nDo you want to continue anyway?
		IfMsgBox , No
			_EXIT()
		Else
			Return
	}
	
	s_Script := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
			. "[COMMANDS]`n"
	
	Loop , %Icon_Count%
	{
		If Icon_%A_Index%_Set
		{
			; ResHacker uses ResourceIds instead of IconIndex
			IconGroupID := ResourceIdOfIcon(Bin_File , A_Index - 1)
			s_Script := s_Script . "-addoverwrite """ . Icon_%A_Index% """ , ICONGROUP," . IconGroupID . ",1033`n"
		} Else If Icon_%A_Index%_Delete
		{
			; ResHacker uses ResourceIds instead of IconIndex
			IconGroupID := ResourceIdOfIcon(Bin_File , A_Index - 1)
			s_Script := s_Script . "-delete ICONGROUP," . IconGroupID . ",1033`n"
		}
	}

	FileDelete , %s_Sc_File%
	FileAppend , %s_Script% , %s_Sc_File%

	s_CMD := """" . A_ScriptDir . "\" Res_Exe . """"
			. " -script "
			. """" . s_Sc_File . """"
	
	FileAppend , `n* Replace icons:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %s_CMD% , , UseErrorLevel Hide
	If (Errorlevel)
	{
		FileRead , s_Log , %A_WorkingDir%\%Res_Log%
		s_ERR := "Couldn't change icons , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%Res_Log%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't change icons , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%Res_Log%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Icons replaced successfully!`n`n , %A_WorkingDir%\%Log_File%

	FileSetTime , , %Bin_File% , M ;Is not set automatically
	; FileDelete , %s_Sc_File%
	; FileDelete , %RES_Ini%
	; FileDelete , %Res_Log%

	Return
}
; --------------------------------------------------------------------------------
; Delete UPX.exe
; --------------------------------------------------------------------------------
Delete_UPX()
{
	Global
	
	Error_Message := "NoUPX Error.`n"
	
	FileAppend , `n* Set No_UPX option`nFileDelete `, %A_WorkingDir%\%UPX_Exe% , %A_WorkingDir%\%Log_File%
	
	FileDelete , %A_WorkingDir%\%UPX_Exe%
	If Errorlevel
		_Error_Exit(Error_Message . "Couldn't delete " . UPX_Exe)
		
	FileAppend , `n# Set No_UPX option successfully`n , %A_WorkingDir%\%Log_File%

	Return
}
; --------------------------------------------------------------------------------
; Use alternative bin file
; --------------------------------------------------------------------------------
Use_Alt_Bin()
{
	Global
	
	Error_Message := "Alternative AutoHotkeySC.bin Error.`n"
	
	FileAppend , `n* Set alternative .bin file`nFileCopy `, %Alt_Bin% `, %A_WorkingDir%\%Bin_File% `, 1 , %A_WorkingDir%\%Log_File%
	FileCopy , %Alt_Bin% , %A_WorkingDir%\%Bin_File% , 1
	If (Errorlevel)
		_Error_Exit(Error_Message . "Couldn't copy """ . Alt_Bin . """ to """ . A_WorkingDir . """.")

	FileAppend , `n# Set alternative .bin file successfully`n , %A_WorkingDir%\%Log_File%
	
	Return
}
; --------------------------------------------------------------------------------
; Renew compiled exe file's created date
; --------------------------------------------------------------------------------
Renew_Created_Date()
{
	Global
	
	Error_Message := "Set new created date Error.`n"
	
	FileAppend , `n* Set new created date`nFileSetTime `, `, %Exe_File% `, C , %A_WorkingDir%\%Log_File%
	
	FileSetTime , , %Exe_File% , C

	If (Errorlevel)
		_Error_Exit(Error_Message . "Couldn't set net created date for """ . Exe_File . """.")
	FileAppend , `n# Set new created date successfully`n`n , %A_WorkingDir%\%Log_File%
	
	Return
}
; --------------------------------------------------------------------------------
; Compile_AHK
; --------------------------------------------------------------------------------
_Compile_AHK()
{
	Global
	Local s_IN , s_OUT , s_PASS , s_NoDecompile , s_CMD , s_Log , Old_Compression
	
	Error_Message := "Compilation Error!`n"
	
	s_IN := " /in """ . In_File . """"
	s_OUT := " /out """ . Exe_File . """"

	If (Password != "") {
		; escape double quotation marks
		StringReplace , s_PASS , Password , " , "" , All
		s_PASS := " /pass """ . s_PASS . """"
	}
	If (NoDecompile) {
		s_NoDecompile := " /NoDecompile"
	}
	
	Old_Compression := _Set_Compression(Compression)
	
	Error_Message := "Compilation Error.`n"
	
	s_CMD := """" . A_WorkingDir . "\" . Compiler . """"
			. s_IN
			. s_OUT
			. s_PASS
			. s_NoDecompile
			. " >> "
			. """" . A_WorkingDir . "\" . Log_File . """"
	
	FileAppend , `n* Compile script:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	/* Msgbox , "%A_LastError%"
	s_Out := CMDret_RunReturn(s_CMD)
	Msgbox , "%A_LastError%"`n"%s_Out%"
	*/
	RunWait , %ComSpec% /c "%s_CMD%" , , UseErrorLevel Hide
	If ErrorLevel
	{
		_Set_Compression(Old_Compression)
		Return False
	}
	
	FileAppend , `n# Script Compiled successfully!`n , %A_WorkingDir%\%Log_File%
	_Set_Compression(Old_Compression)
	If Auto_Compile <> 2
	{
		Loop, Read , %A_WorkingDir%\%Log_File%
			LastLine := A_Index
		LastLine -= 2
		FileReadLine , s_Log , %A_WorkingDir%\%Log_File% , %LastLine%
		Msgbox , 262208 , %MSG_TITLE% , %s_Log% , 2
	}
	Return True
}
; --------------------------------------------------------------------------------
; Run after
; --------------------------------------------------------------------------------
_Run_After()
{
	Global
	Local s_CMD , s_ERR , s_Log
	
	Error_Message := "Run after Error!`n"
	
	s_CMD := Run_After
			. " >> "
			. """" . A_WorkingDir . "\" . Log_File . """"
	StringReplace , s_CMD , s_CMD , % "%IF%" , %In_File% , All
	StringReplace , s_CMD , s_CMD , % "%OF%" , %Exe_File% , All
	StringReplace , s_CMD , s_CMD , % "%OD%" , %Out_Dir% , All
	StringReplace , s_CMD , s_CMD , % "%ON%" , %Out_Name% , All
	
	FileAppend , `n* Execute Run After Command:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %ComSpec% /c "%s_CMD%" , %In_Dir% , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , %Log_File%
		s_ERR := "Running " . s_CMD . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileAppend , `n# Run After executed successfully!`n`n , %A_WorkingDir%\%Log_File%
	Return
}
; --------------------------------------------------------------------------------
; Set Registry Entries
; --------------------------------------------------------------------------------
_Set_Compression(NewLevel)
{
	Global
	Local OldLevel
	Error_Message := "Error while setting Compression level.`n"
	
	RegRead , OldLevel , HKCU , Software\AutoHotkey\Ahk2Exe , LastCompression
	RegWrite , REG_DWORD , HKCU , Software\AutoHotkey\Ahk2Exe , LastCompression , %NewLevel%
	RegWrite , REG_SZ , HKCU , Software\AutoHotkey\Ahk2Exe , LastIcon
	Return , OldLevel
}
; --------------------------------------------------------------------------------
; Copy the lib directory
; --------------------------------------------------------------------------------

_Copy_Lib_Dir()
{
	Global
	Local s_OrgAHK , s_UsedAHK
	
	SetWorkingDir , %A_Temp%\AutoHotkey
	
	Error_Message := "Error while copying Lib folder.`n"
	
	/*
	IfExist , %A_WorkingDir%\%Lib_Dir%
	{
		FileRemoveDir , %A_WorkingDir%\%Lib_Dir% , 1
		If Errorlevel
			_Error_Exit(Error_Message . "Couldn't delete folder " . Lib_Dir)
	}
	*/
	IfExist , %AHK_DIR%\%Lib_Dir%
	{
		FileAppend , `n* Copy Lib directory`n`nFileCopyDir `, %AHK_DIR%\%Lib_Dir% `, %A_WorkingDir%\%Lib_Dir% `, 1`n, %A_WorkingDir%\%Log_File%
		
		FileCopyDir , %AHK_DIR%\%Lib_Dir% , %A_WorkingDir%\%Lib_Dir% , 1
		If Errorlevel
			_Error_Exit(Error_Message . "Couldn't copy new folder " . Lib_Dir)
		
		FileAppend , `n# Copy Lib directory successfully!`n`n , %A_WorkingDir%\%Log_File%
	}
	FileGetVersion , s_OrgAHK , %AHK_DIR%\%AHK_Exe%
	FileGetVersion , s_UsedAHK , %A_WorkingDir%\%AHK_Exe%
	If (s_OrgAHK <> s_UsedAHK)
	{
		FileCopy , %AHK_DIR%\%AHK_Exe% , %A_WorkingDir%\%AHK_Exe% , 1
		If Errorlevel
			_Error_Exit(Error_Message . "Couldn't copy new " . AHK_Exe)
	}
	SetWorkingDir , %A_Temp%\AutoHotkey\Compiler
	Return
}
; --------------------------------------------------------------------------------
; Select_Resource Button
; --------------------------------------------------------------------------------
Select_Resource:
	FileSelectFile, s_Resources , M1 , , %Gui_Title% - Select resource file(s)
	If s_Resources =
		Return
	
	Selected_Resources := ""
	
	Loop, parse, s_Resources, `n
	{
		If A_Index = 1
		{
			Selected_Resources_Dir := A_LoopField
		} else {
			Selected_Resources .= Selected_Resources_Dir . "\" . A_LoopField . "|"
		}
	}
	
	StringTrimRight, Selected_Resources , Selected_Resources , 1
	
	Add_Resource(Selected_Resources)
Return

; --------------------------------------------------------------------------------
; Add_Resource Helper
; --------------------------------------------------------------------------------
Add_Resource(s_Resources)
{
	Global
	Local s_Resource_File , s_Target , s_Resource_Dir
	
	SetFormat, Float, 02.0

	Loop, parse, s_Resources, |
	{
		IfNotExist , %A_LoopField%
		{
			Msgbox , 262192 , %MSG_TITLE% , Resource file %A_LoopField% doesn't exist!
			Msgbox , 262192 , %MSG_TITLE% , Resource file %A_LoopField% doesn't exist!
			Continue
		}
		SplitPath, A_LoopField , s_Resource_File , s_Resource_Dir , s_Resources_Ext
		
		If s_Resources_Ext = BMP
		{
			BITMAP_I++
			BITMAP_I += 0.0
			
			s_Target := "BITMAP," . BITMAP_I . ","
		} Else If s_Resources_Ext = ICO
		{
			ICONGROUP_I++
			ICONGROUP_I += 0.0
			
			s_Target := "ICONGROUP," . ICONGROUP_I . ","
		} Else
		{
			RCDATA_I++
			RCDATA_I += 0.0
			
			s_Target := "RCDATA," . RCDATA_I . ","
		}
		LV_Add("" , s_Resource_File , s_Target , s_Resource_Dir )
	}
	LV_ModifyCol()
	LV_ModifyCol(2,"Sort")
	Return
}
; --------------------------------------------------------------------------------
; Delete resource from list
; --------------------------------------------------------------------------------
Remove_Resource:
	Loop % LV_GetCount("Selected")
	{
		LV_Delete(LV_GetNext())
	}
Return
; --------------------------------------------------------------------------------
; Import resource to AutoHotkeySC.bin
; -------------------------------------------------------------------------------
Import_Resources()
{
	
	Global
	Local s_Sc_File , s_Script , s_File , s_Target , s_Dir
	
	Error_Message := "Import Resources Error!`n"
	
	s_Sc_File := A_WorkingDir . "\AddResource.script"
	
	s_Script := "[FILENAMES]`n"
			. "Exe=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "SaveAs=" . A_WorkingDir . "\" . Bin_File . "`n"
			. "Log=" . A_WorkingDir . "\" . Res_Log . "`n"
			. "[COMMANDS]`n"
	
	Resource_Files := ""
	Loop % LV_GetCount()
	{
		LV_GetText(s_File, A_Index, 1)
		LV_GetText(s_Target, A_Index, 2)
		LV_GetText(s_Dir, A_Index, 3)
		
		Resource_Files .= s_Dir . "\" . s_File
		
		If (A_Index != LV_GetCount())
				Resource_Files .= "|"
		
		s_Script .= "-addoverwrite """ . s_Dir . "\" . s_File . """ , " . s_Target . "`n"
	}
	
	FileDelete , %s_Sc_File%
	FileAppend , %s_Script% , %s_Sc_File%
	
	s_CMD := """" . A_ScriptDir . "\" . Res_Exe . """"
			. " -script "
			. """" . s_Sc_File . """"
	FileAppend , `n* Add Resources to binary file:`n%s_CMD%`n, %A_WorkingDir%\%Log_File%
	RunWait , %s_CMD% , , UseErrorLevel Hide
	If Errorlevel
	{
		FileRead , s_Log , %A_WorkingDir%\%Res_Log%
		s_ERR := "Couldn't add resources to binary file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileRead , s_Log , %A_WorkingDir%\%Res_Log%
	IfInString , s_Log , ERROR:
	{
		s_ERR := "Couldn't add resources to binary file , " . Res_Exe . " failed!`n" . s_Log
		_Error_Exit(Error_Message . s_ERR)
	}
	FileDelete , %A_WorkingDir%\%Res_Log%
	FileAppend , `n~~ Reshacker Log Start ~~`n%s_Log%~~ Reshacker Log End ~~`n`n# Resources added successfully!`n`n , %A_WorkingDir%\%Log_File%

	Return
}
; --------------------------------------------------------------------------------
; Help Window with Informations about Vista Execution Level
; --------------------------------------------------------------------------------
Execution_Level_Help:
	Gui ,+OwnDialogs
	
	HelpText := "* none:`n"
				. A_Tab . "Doesn't add a special execution level.`n`n"
				. "* asInvoker:`n"
				. A_Tab . "Launches with the same rights as the parent process.`n"
				. A_Tab . "The application can be elevated to a higher permission`n"
				. A_Tab . "level by selecting ""Run as Administrator"".`n`n"
				. "* highestAvailable:`n"
				. A_Tab . "Launches with the highest available permission level.`n"
				. A_Tab . "If the user is member of Adminstrators group and a higher`n"
				. A_Tab . "level is available, the system promts for credentials,`n"
				. A_Tab . "else it launches with user's rights.`n`n"				
				. "* requireAdministrator:`n"
				. A_Tab . "Needs administrator rights to be lauched.`n"
				. A_Tab . "User has to be a member of Administrators group.`n"
				. A_Tab . "If the opening process is not running with administrative`n"
				. A_Tab . "permissions, the system will prompt for credentials."

	MsgBox , 64 , Information on Vista Execution Level , %HelpText%
Return
; --------------------------------------------------------------------------------
; Create a ToolTip on Mouseover
; --------------------------------------------------------------------------------
WM_MOUSEMOVE()
{
	Global
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
	StringReplace , Lang_CurrControl, CurrControl , Gui_ , Lang_
	If (%Lang_CurrControl%_TT = "")
		ToolTip , %CurrControl%
	Else
		ToolTip % %Lang_CurrControl%_TT . " :D" ; %The leading percent sign tell it to use an expression.
	SetTimer, RemoveToolTip2, -5000
	Return

	RemoveToolTip2:
		ToolTip
	Return
}
; --------------------------------------------------------------------------------
; Define all constants and variables
; --------------------------------------------------------------------------------
DefineVariables:
; --------------------------------------------------------------------------------
; Konstanten
; --------------------------------------------------------------------------------
	Compiler := "Ahk2Exe.exe"
	AHK_Exe := "AutoHotkey.exe"
	Lib_Dir := "Lib"
	Bin_File := "AutoHotkeySC.bin"
	UPX_Exe := "Upx.exe"
	RC_EXE := "GoRC.exe"
	RC_Log := "GoRC.log"
	Res_Exe := "ResHacker.exe"
	RES_Ini := "ResHacker.ini"
	Res_Log := "ResHacker.log"
	Log_File := "Compile_AHK.log"
	Manifest_File := "AutoHotkeySC.manifest"
	User_Defaults_Ini := A_AppData . "\Compile_AHK\Defaults.ini"
	Global_Defaults_Ini := A_ScriptDir . "\Defaults.ini"
	User_Language_Ini := A_AppData . "\Compile_AHK\language.ini"
	Global_Language_Ini := A_ScriptDir . "\language.ini"
	Auto_Compile = 0

	AHK_Section := "AHK2EXE"
	RES_Section := "VERSION"
	ICO_Section := "ICONS"
	Icon_Count := 7
	MSG_TITLE := "Compile_AHK"
	Language_IDS := Create_Lang_List()
	Charsets := Create_Charset_List()

; --------------------------------------------------------------------------------
; Variable
; --------------------------------------------------------------------------------
	; Compiler settings
	In_File := ""
	In_Dir := ""
	IN_EXT := ""
	IN_NAME := ""
	Alt_Bin_Set := 0
	Alt_Bin := ""
	Exe_File := ""
	Out_Dir := ""
	Out_Name := ""
	Compression := 4
	No_UPX := 0
	Password := ""
	Show_Pwd := 0
	NoDecompile := 0
	Created_Date := 0
	Run_Before := ""
	Run_After := ""
	Execution_Level := 1
	; Version information
	Set_Version_Info := False
	Company_Name := ""
	File_Description := ""
	File_Version := ""
	Inc_File_Version := 0
	Internal_Name := ""
	Legal_Copyright := ""
	Original_Filename := ""
	Product_Name := ""
	Product_Version := ""
	Set_AHK_Version := 0
	Inc_Product_Version := 0
	Language_ID := 39 ; English_United_States
	Charset := 5 ; Unicode

	; Icons
	Loop , %Icon_Count% {
		Icon_%A_Index% := ""
		Icon_%A_Index%_Set := 0
		Icon_%A_Index%_Delete := 0
	}

	; Gui Compiler settings
	Gui +OwnDialogs
	Gui_Title := "Compile_AHK"
	Gui_Alt_Bin_Set := 0
	Gui_Alt_Bin := ""
	Gui_Exe_File := ""
	Gui_Compression_Levels := 5
	Gui_No_UPX := 0
	Gui_Password := ""
	Gui_Show_Pwd := 0
	Gui_NoDecompile := 0
	Gui_Created_Date := 0
	Gui_Run_Before := ""
	Gui_Run_After := ""
	Gui_Execution_Levels := 1
	; gui versioninfo
	Gui_Set_Version_Info := 0
	Gui_Company_Name := ""
	Gui_File_Description := ""
	Gui_TFV1 := ""
	Gui_TFV2 := ""
	Gui_TFV3 := ""
	Gui_TFV4 := ""
	Gui_FV1 := 0
	Gui_FV2 := 0
	Gui_FV3 := 0
	Gui_FV4 := 0
	Gui_Inc_File_Version := 0
	Gui_Internal_Name := ""
	Gui_Product_Name := ""
	Gui_Legal_Copyright := ""
	Gui_Original_Filename := ""
	Gui_TPV1 := ""
	Gui_TPV2 := ""
	Gui_TPV3 := ""
	Gui_TPV4 := ""
	Gui_PV1 := 0
	Gui_PV2 := 0
	Gui_PV3 := 0
	Gui_PV4 := 0
	Gui_Set_AHK_Version := 0
	Gui_Inc_Product_Version := 0
	Gui_Language_ID := 0
	Gui_Charset := 0
	;gui icons
	Loop , %Icon_Count%
	{
		Gui_Icon_%A_Index% := ""
		Gui_Icon_%A_Index%_Set := 0
		Gui_Icon_Delete%A_Index%_Delete := 0
	}
	
	; Others
	Ini_File := ""
	Error_Message := ""
	Param := ""
	Compiler_Error := ""
	AHK_Dir := ""
	AHK_Compiler_Dir := ""
	Portable_App := 0
Return
; --------------------------------------------------------------------------------
; Check if Compile_AHK runs in portable mode and set variables
; --------------------------------------------------------------------------------
CheckPortableApp:
	IfExist , %Global_Defaults_Ini%
	{
		Portable_App := 1
		Defaults_Ini := A_ScriptDir . "\Defaults.ini"
		Language_Ini := A_ScriptDir . "\Language.ini"
	} Else {
		Defaults_Ini := A_AppData . "\Compile_AHK\Defaults.ini"
		Language_Ini := A_AppData . "\Compile_AHK\Language.ini"
	}
Return
; --------------------------------------------------------------------------------
; Read language file
; --------------------------------------------------------------------------------
ReadLanguage:
	Error_Message := "Read Language File Error!`n"
	If(!Portable_App)
	{
		IfNotExist , %Global_Language_Ini%
			_Error_Exit(Error_Message . "`nCould not find """ . Global_Language_Ini . """.")
			
		IfExist , %Language_Ini%
		{
			FileGetTime , Lang_Time , %Language_Ini%
			FileGetTime , Global_Lang_Time , %Global_Language_Ini%
			If (Global_Lang_Time > Lang_Time)
			{
				SplitPath , Language_Ini , , Language_Dir
				
				IniRead , _actualLang , %Language_Ini% , Lang , actualLang , en-us
				
				FileCopy , %Global_Language_Ini% , %Language_Ini% , 1
				If ErrorLevel
					_Error(Error_Message . "`nCould not copy """ . Global_Language_Ini . """ to """ . Language_Dir . """.")
				
				IniWrite , %_actualLang% , %Language_Ini% , Lang , actualLang
				If ErrorLevel
					_Error(Error_Message . "`nCould not write to """ . Language_Ini . """.")
			}

		} Else {
			SplitPath , Language_Ini , , Language_Dir
			IfNotExist , %Language_Dir%
			{
				FileCreateDir , %Language_Dir%
				If ErrorLevel
					_Error(Error_Message . "`nCould not create the folder """ . Language_Dir . """")
			}
			FileCopy , %Global_Language_Ini% , %Language_Ini% , 1
			If ErrorLevel
				_Error(Error_Message . "`nCould not copy """ . Global_Language_Ini . """ to """ . Language_Dir . """.")
		}
	}
	FileRead, lang_file, %Language_Ini%
	LangHelp_LoadLanguageVars(lang_file,"updateLang")

Return
; --------------------------------------------------------------------------------
; update Language on change
; --------------------------------------------------------------------------------
updateLang:
	GuiControl , , Gui_lang_DDL , |%Lang_MenulanguageTitel%||%LangDDL%
	
	GuiControl , , Gui_Cancel , %Lang_Cancel%
	
	GuiControl , , Gui_Charset , %Lang_Charset%
	GuiControl , , Gui_Compile , %Lang_Compile%
	GuiControl , , Gui_Compression_Levels , %Lang_Compression%
	GuiControl , , Gui_Created_Date , %Lang_Created_Date%
	GuiControl , , Gui_Credits , %Lang_Credits%

	GuiControl , , Gui_Execution_Levels , |%Lang_Execution_Levels%
	GuiControl , , Gui_Compression_Levels , |%Lang_Compression_Levels%

	GuiControl , , Gui_Generate , %Lang_Generate%

	Loop , %Icon_Count%
	{
		GuiControl , , Gui_Icon_%A_Index%_BT , %Lang_Select%
		GuiControl , , Gui_Icon_%A_Index%_Delete , %Lang_Delete%
	}
	
	GuiControl , , Gui_Inc_File_Version , %Lang_Autoincrement%
	GuiControl , , Gui_Inc_Product_Version , %Lang_Autoincrement%

	GuiControl , , Gui_NoDecompile , %Lang_NoDecompile%
	GuiControl , , Gui_No_UPX , %Lang_No_UPX%
	
	GuiControl , , Gui_Save_Defaults , %Lang_Save_Defaults%
	GuiControl , , Gui_Select_Alt_Bin , %Lang_Select%
	GuiControl , , Gui_Select_Exe_File , %Lang_Select%
	GuiControl , , Gui_Select_Run_After , %Lang_Select%
	GuiControl , , Gui_Select_Run_Before , %Lang_Select%

	GuiControl , , Gui_Set_AHK_Version , %Lang_Set_AHK_Version%
	GuiControl , , Gui_Show_Pwd , %Lang_Show_Pwd%
	GuiControl , , Gui_Tabs , |%Lang_Tabs%
	; GuiControl , , MenulanguageTitel

	GuiControl , , Gui_Text_Compression , %Lang_Compression%
	GuiControl , , Gui_Text_Execution_Level , %Lang_Execution_Level%:
	GuiControl , , Gui_Script_File , %Lang_Script_File%
	GuiControl , , Gui_Text_Other_Options , %Lang_Other_Options%
	GuiControl , , Gui_Text_Exe_File , %Lang_Exe_File%
	GuiControl , , Gui_Text_Password , %Lang_Password%
	GuiControl , , Gui_Text_Run_After , %Lang_Run_After%
	GuiControl , , Gui_Text_Run_Before , %Lang_Run_Before%
	GuiControl , , Gui_Text_Vista_UAC , %Lang_Vista_UAC%

	GuiControl , , Gui_Title , %Lang_Gui_Title%
	GuiControl , , Gui_Help , %Lang_Help%
	GuiControl , , Gui_Set_Version_Info , %Lang_Set_Version_Info%
	
	GuiControl , , Gui_Text_Company_Name , %Lang_Company_Name%
	GuiControl , , Gui_Text_File_Description , %Lang_File_Description%
	GuiControl , , Gui_Text_File_Version , %Lang_File_Version%
	GuiControl , , Gui_Text_Internal_Name , %Lang_Internal_Name%
	GuiControl , , Gui_Text_Legal_Copyright , %Lang_Legal_Copyright%
	GuiControl , , Gui_Text_Original_Filename , %Lang_Original_Filename%
	GuiControl , , Gui_Text_Product_Name , %Lang_Product_Name%
	GuiControl , , Gui_Text_Product_Version , %Lang_Product_Version%
	
	GuiControl , , Gui_Text_Language_ID , %Lang_Language_ID%
	GuiControl , , Gui_Text_Charset , %Lang_Charset%
	GuiControl , , Gui_Text_Icon_1 , %Lang_Main_Icon%
	GuiControl , , Gui_Text_Icon_2 , %Lang_Shortcut_Icon%
	GuiControl , , Gui_Text_Icon_3 , %Lang_Suspend_Icon%
	GuiControl , , Gui_Text_Icon_4 , %Lang_Pause_Icon%
	GuiControl , , Gui_Text_Icon_5 , %Lang_Suspend_Pause_Icon%
	GuiControl , , Gui_Text_Icon_6 , %Lang_Main_Icon_9x%
	GuiControl , , Gui_Text_Icon_7 , %Lang_Suspend_Icon_9x%

	GuiControl , , Gui_Resource_ListView , %Lang_Resource_ListView%
	GuiControl , , Gui_Add_Resource , %Lang_Add_Resource%
	GuiControl , , Gui_Remove_Resource , %Lang_Remove_Resource%
	
	Loop , Parse , Lang_Resource_ListView , |
		LV_ModifyCol(A_Index, "AutoHdr" , A_LoopField)
	
	IniWrite , %actualLang% , %Language_Ini% , Lang , actualLang
	If ErrorLevel
			_Error(Error_Message . "`nCould not write to """ . Language_Ini . """.")
return
; --------------------------------------------------------------------------------
; Installation check
; --------------------------------------------------------------------------------
CheckInstall:
	Error_Message := "Installation Error!`n"
	RegRead , AHK_Dir , HKLM , SOFTWARE\AutoHotkey , InstallDir
	If (ErrorLevel) {
		IfExist , %A_ScriptDir%\Ahk2Exe.exe
			SplitPath, A_ScriptDir , , AHK_DIR
		Else
			_Error_Exit(Error_Message . "AHK InstallDir not found")
	}
	AHK_Compiler_Dir := AHK_Dir . "\Compiler"
	If (!FileExist(AHK_Compiler_Dir . "\" . Compiler)) {
		_Error_Exit(Error_Message . AHK_Compiler_Dir . "\" . Compiler . " not found")
	}
	If (!FileExist(AHK_Compiler_Dir . "\" . Bin_File)) {
		_Error_Exit(Error_Message . AHK_Compiler_Dir . "\" . Bin_File . " not found")
	}

	_CHECK_AHK()
Return
; --------------------------------------------------------------------------------
; Command line Parameter ( Full AHK Script Path)
; --------------------------------------------------------------------------------
CommandLine:
	Error_Message := "Command Line Parameter Error!`n"
	
	Param = %0%

	If Param = 0
		_Select_FILE(In_File , "AHK")
	Else If Param = 1
		In_File = %1%
	Else If Param = 2
	{
		
		Param_1 = %1%
		If Param_1 = /auto
		{
			In_File = %2%
			Auto_Compile = 1
		}
		Else If Param_1 = /nogui
		{
			In_File = %2%
			Auto_Compile = 2
		}
		Else
		{
			Param_ERROR :=	"`nThe first of two Parameters has to be:`n"
							. "/auto to Compile with existing settings from the last compilation`n"
							. "/nogui to Compile with existing settings and no warnings`n`n"
							. "The second Parameter has to be the full path of a script."
			_Error_Exit(Error_Message . Param_ERROR)
		}
	}
	Else
		_Error_Exit(Error_Message . "Wrong Number of Parameters: " . Param)

	SplitPath , In_File , , In_Dir , IN_EXT , IN_NAME

	If (In_File = "")
		_Error_Exit(Error_Message . "`nNo file Selected.")
		
	If (IN_EXT != "ahk") {
		_Error_Exit(Error_Message . "`n""" . In_File . """ is not a .ahk file.")
	}
	If FileExist(In_File)
	{
		If In_Dir = ""
			In_Dir := A_WorkingDir
	}
	Else
	{
		If FileExist(A_ScriptDir . "\" . In_File)
		{
			In_Dir := A_ScriptDir
			In_File := In_Dir . "\" . In_File
		}
		Else
			_Error_Exit(Error_Message . "`n""" . In_File . """ not found")
	}

	Ini_File := In_File . ".ini"
	Exe_File := In_Dir . "\" . IN_NAME . ".exe"
	Out_Dir := In_Dir
	Out_Name := IN_NAME . ".exe"
Return
; --------------------------------------------------------------------------------
; Creates a List with all language IDs for the version info
; --------------------------------------------------------------------------------
Create_Lang_List()
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
; Creates a List with all Charset IDs for the version info
; --------------------------------------------------------------------------------
Create_Charset_List()
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
; Language Helper Functions by hainchen
; --------------------------------------------------------------------------------
LangHelp_LoadLanguageVars(IniVarr,updatelabel,MyMenuBarrName="MyMenu"){
		global 
		inivar :=inivarr
		MyMenuBarName := MyMenuBarrName
		updateLang := updatelabel
		;section lang
		LangHelp_loadVarsFromIniVar(IniVar,"lang")
		; section %actuallang%
		LangHelp_loadVarsFromIniVar(IniVar,actualLang)
	}

LangHelp_AddLangDropDownMenu(possibleLangs, MenulanguageTitel, actualLang){
		
		global	Gui_lang_DDL , LangDDL
		
		StringSplit, LangString, possibleLangs, `,%A_Space%%A_Tab%`n`r
		Loop,%LangString0%
		{
			l := LangString%a_index%
			LangDDL .= l . "|"
		}
		Gui , Add , DropDownList , vGui_lang_DDL x+0 yp w100 Choose1 gLangHelp_ChangeLanguageByDropDown , %MenulanguageTitel%|%LangDDL%
		Menualt:=MenulanguageTitel
		Return :=Menualt
	}

LangHelp_ChangeLanguageByDropDown:
	Gui, Submit, NoHide
	actualLang := %A_GuiControl%
	LangHelp_loadVarsFromIniVar(IniVar,actualLang,1)
	Gosub,%updateLang% ;updateLang
Return

LangHelp_loadVarsFromIniVar(iniVar,iniSectionsToLoad,updateGUI = 0)
{
	; from not-logged-in-daonlyfreez
	; http://www.autohotkey.com/forum/post-41881.html
	global
	local loadEm
	loadEm = 0
	Counter := 0
	Loop, Parse, iniVar, `n, `r
	{
		; Scan for section, if the line is a section, get section name
		; compare to iniSectionsToLoad, set loadEm flag
		If A_LoopField Contains [
		{
			If A_LoopField Contains ]
			{
				StringMid, anIniSection, A_LoopField, InStr(A_LoopField,"]")-1, StrLen(A_LoopField)-2, L ; Get Section name
				If anIniSection in %iniSectionsToLoad% ; is it in our matchlist?
					loadEm = 1
				Else
					loadEm = 0
				If iniSectionsToLoad = ; is it empty? -> get nothing ;all
					loadEm = 0 ;1
			}
		}
		; Set key and value of the line to a variable named like the key
		; and with the value of the key
		If loadEm = 1
		{
			If A_LoopField Contains =
			{
				Counter++
				StringSplit, Field, A_LoopField, =
				Field =%Field1%=
				StringSplit, Field, A_LoopField, = ,%A_Space%%A_Tab%`n`r ;after the last comma its from Haichen :-)
				If Field1 in actualLang,possibleLangs
					%Field1% := Field2
				Else
					Lang_%Field1% := Field2
			}
		}
	}
	Return Counter
}
; --------------------------------------------------------------------------------
; ERROR EXIT
; --------------------------------------------------------------------------------
_Error(sMSG)
{
	Msgbox , 262160 , %MSG_TITLE% , %sMSG%
}

_Error_Exit(sMSG)
{
	FileAppend , `n`n* ~~~ ERROR_EXIT ~~~ *`n`n%sMSG% , %A_WorkingDir%\%Log_File%
	Msgbox , 262160 , %MSG_TITLE% , %sMSG%
	_EXIT()
}
_EXIT()
{
	ExitApp
}

; ******************************************************************
; CMDret-AHK functions
; version 1.10 beta
;
; Updated: Dec 5, 2006
; by: corrupt
; Code modifications and/or contributions made by:
; Laszlo, shimanov, toralf, Wdb 
; http://www.autohotkey.com/forum/topic8606.html
; ******************************************************************
; Usage:
; CMDin - command to execute
; WorkingDir - full path to working directory (Optional)
; ******************************************************************
; Known Issues:
; - If using dir be sure to specify a path (example: cmd /c dir c:\)
; or specify a working directory   
; - Running 16 bit console applications may not produce output. Use
; a 32 bit application to start the 16 bit process to receive output 
; ******************************************************************
; Additional requirements:
; - none
; ******************************************************************
; Code Start
; ******************************************************************

CMDret_RunReturn(CMDin, WorkingDir=0)
{
	Global cmdretPID
	tcWrk := WorkingDir=0 ? "Int" : "Str"
	idltm := A_TickCount + 20
	CMsize = 1
	VarSetCapacity(CMDout, 1, 32)
	VarSetCapacity(sui,68, 0)
	VarSetCapacity(pi, 16, 0)
	VarSetCapacity(pa, 12, 0)
	Loop, 4 {
		DllCall("RtlFillMemory", UInt,&pa+A_Index-1, UInt,1, UChar,12 >> 8*A_Index-8)
		DllCall("RtlFillMemory", UInt,&pa+8+A_Index-1, UInt,1, UChar,1 >> 8*A_Index-8)
	}
	IF (DllCall("CreatePipe", "UInt*",hRead, "UInt*",hWrite, "UInt",&pa, "Int",0) <> 0) {
		Loop, 4
			DllCall("RtlFillMemory", UInt,&sui+A_Index-1, UInt,1, UChar,68 >> 8*A_Index-8)
		DllCall("GetStartupInfo", "UInt", &sui)
		Loop, 4 {
			DllCall("RtlFillMemory", UInt,&sui+44+A_Index-1, UInt,1, UChar,257 >> 8*A_Index-8)
			DllCall("RtlFillMemory", UInt,&sui+60+A_Index-1, UInt,1, UChar,hWrite >> 8*A_Index-8)
			DllCall("RtlFillMemory", UInt,&sui+64+A_Index-1, UInt,1, UChar,hWrite >> 8*A_Index-8)
			DllCall("RtlFillMemory", UInt,&sui+48+A_Index-1, UInt,1, UChar,0 >> 8*A_Index-8)
		}
		IF (DllCall("CreateProcess", Int,0, Str,CMDin, Int,0, Int,0, Int,1, "UInt",0, Int,0, tcWrk, WorkingDir, UInt,&sui, UInt,&pi) <> 0) {
			Loop, 4
				cmdretPID += *(&pi+8+A_Index-1) << 8*A_Index-8
			Loop {
				idltm2 := A_TickCount - idltm
				If (idltm2 < 10) {
					DllCall("Sleep", Int, 10)
					Continue
				}
				IF (DllCall("PeekNamedPipe", "uint", hRead, "uint", 0, "uint", 0, "uint", 0, "uint*", bSize, "uint", 0 ) <> 0 ) {
					Process, Exist, %cmdretPID%
					IF (ErrorLevel OR bSize > 0) {
						IF (bSize > 0) {
							VarSetCapacity(lpBuffer, bSize+1)
							IF (DllCall("ReadFile", "UInt",hRead, "Str", lpBuffer, "Int",bSize, "UInt*",bRead, "Int",0) > 0) {
								IF (bRead > 0) {
									TRead += bRead
									VarSetCapacity(CMcpy, (bRead+CMsize+1), 0)
									CMcpy = a
									DllCall("RtlMoveMemory", "UInt", &CMcpy, "UInt", &CMDout, "Int", CMsize)
									DllCall("RtlMoveMemory", "UInt", &CMcpy+CMsize, "UInt", &lpBuffer, "Int", bRead)
									CMsize += bRead
									VarSetCapacity(CMDout, (CMsize + 1), 0)
									CMDout=a	 
									DllCall("RtlMoveMemory", "UInt", &CMDout, "UInt", &CMcpy, "Int", CMsize)
									VarSetCapacity(CMDout, -1)	 ; fix required by change in autohotkey v1.0.44.14
								}
							}
						}
					}
					ELSE
						break
				}
				ELSE
					break
				idltm := A_TickCount
			}
			cmdretPID=
			DllCall("CloseHandle", UInt, hWrite)
			DllCall("CloseHandle", UInt, hRead)
		}
	}
	IF (StrLen(CMDout) < TRead) {
		VarSetCapacity(CMcpy, TRead, 32)
		TRead2 = %TRead%
		Loop {
			DllCall("RtlZeroMemory", "UInt", &CMcpy, Int, TRead)
			NULLptr := StrLen(CMDout)
			cpsize := Tread - NULLptr
			DllCall("RtlMoveMemory", "UInt", &CMcpy, "UInt", (&CMDout + NULLptr + 2), "Int", (cpsize - 1))
			DllCall("RtlZeroMemory", "UInt", (&CMDout + NULLptr), Int, cpsize)
			DllCall("RtlMoveMemory", "UInt", (&CMDout + NULLptr), "UInt", &CMcpy, "Int", cpsize)
			TRead2 --
			IF (StrLen(CMDout) > TRead2)
				break
		}
	}
	StringTrimLeft, CMDout, CMDout, 1
	Return, CMDout
} 