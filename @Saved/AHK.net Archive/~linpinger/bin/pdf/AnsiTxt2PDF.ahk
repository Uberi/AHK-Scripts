VerDate := "2011-9-17"

FontsList =
(Join| C
D:\etc\Font\???_GBK.TTF
%A_WinDir%\Fonts\simhei.ttf
%A_WinDir%\Fonts\simkai.ttf
; ??????????,??Radio?????
%A_WinDir%\Fonts\simsun.ttc
%A_WinDir%\Fonts\simfang.ttf
D:\etc\Font\?????W5-A.TTF
)


	Gui, +AlwaysOnTop

	Menu, MyMenuBar, Add, ??(&T), ZhiDing

	Menu, MyMenuBar, Add, olsoul???(&W), FoxHelp
	Menu, MyMenuBar, Add, olsoul??(&B), FoxHelp
	Menu, MyMenuBar, Add, ????(&A), FoxHelp
	Menu, MyMenuBar, Add, ?????(&L), FoxHelp
	Menu, MyMenuBar, Add, ????(&H), FoxHelp

	Gui, Menu, MyMenuBar

GuiInit:
	Gui, Add, GroupBox, x6 y10 w320 h80 cBlue, ??:
	Gui, Add, ComboBox, x16 y30 w230 h20 R10 Choose1 vFontFilePath, %FontsList%
	Gui, Add, Button, x256 y30 w60 h20 gChooseFontPath, ??(&S)
	Gui, Add, Radio, x16 y60 w80 h20 vCKFont1 Checked gChangeFontPath, &1.???
	Gui, Add, Radio, x96 y60 w70 h20 vCKFont2 gChangeFontPath, &2.??
	Gui, Add, Radio, x166 y60 w70 h20 vCKFont3 gChangeFontPath, &3.??
	Gui, Add, Text, x236 y63 w40 h20 , ??:
	Gui, Add, Edit, x276 y60 w40 h20 vFontSize, 9.5

	Gui, Add, GroupBox, x336 y10 w180 h80 cBlue, ??:
	Gui, Add, Text, x346 y33 w60 h20 , ????:
	Gui, Add, Edit, x406 y30 w40 h20 vPageWidth, 257
	Gui, Add, Text, x446 y33 w20 h20 , %A_space%*
	Gui, Add, Edit, x466 y30 w40 h20 vPageHeight, 335
	Gui, Add, Text, x346 y63 w50 h20 , ???:
	Gui, Add, Edit, x396 y60 w20 h20 vPagePading, 5
	Gui, Add, Text, x426 y63 w50 h20 , ???:
	Gui, Add, Edit, x476 y60 w30 h20 vLineSpacing, 12.5

	Gui, Add, GroupBox, x6 y100 w510 h250 cBlue, ????????????:
;	Gui, Add, ListView, x16 y120 w490 h220 , ListView
	Gui, Add, ListBox, x16 y120 w490 h220 cGreen vLog

	Gui, Add, StatusBar, , ??: ????? ??: %VerDate% ????: http://www.autohotkey.net/~linpinger
	; Generated using SmartGUI Creator 4.0
	Gui, Show, h377 w528, Ansi Txt2PDF ?????(linpinger) QQ: 308639546
	GuiControl, focus, CKFont1
Return

ZhiDing:
	If ( A_thismenuitem = "??(&T)" ) {
		isNormal := ! isNormal
		If isNormal
			Gui, -AlwaysOnTop
		else
			Gui, +AlwaysOnTop
	}
return

FoxHelp:
	If ( A_thismenuitem = "olsoul???(&W)" )
		OpenURL("http://www.olsoul.com?s=ExeAnsiTxt2PDF")
	If ( A_thismenuitem = "olsoul??(&B)" )
		OpenURL("http://bbs.olsoul.com?s=ExeAnsiTxt2PDF")
	If ( A_thismenuitem = "????(&A)" )
		TrayTip, ?????:, QQ: 308639546`nhttp://www.autohotkey.net/~linpinger/index.html
	If ( A_thismenuitem = "?????(&L)" )
		OpenURL("http://www.autohotkey.net/~linpinger/index.html?s=ExeAnsiTxt2PDF")
	If ( A_thismenuitem = "????(&H)" ) {
		AAAbout =
		(Ltrim join`n
		??: ???(ANSI??)???PDF??(Kindle???)
		??: ????????????????
		)
		traytip, ????:, %AAAbout%
	}
return

GuiDropFiles:
	File_full_path := A_GuiEvent
	Gui, Submit, Nohide
	if ( A_guicontrol = "FontFilePath" )
		Guicontrol, text, FontFilePath, %File_full_path%
	if ( A_guicontrol = "Log" ) {
		FileInstall, libhpdf.dll, libhpdf.dll, 1
		sTime := A_TickCount
		loop, parse, File_full_path, `n, `r,
		{
			If ( A_loopField = "" )
				continue
			++Jishu
			FoxListBoxLog("??", "?????? " . jishu . " > " . A_loopField)

			Fileread, NowNR, %A_loopField%
			SplitPath, A_loopField, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive

			K3_Msg("SetHead", "????: " . OutFileName . " ??: ??PDF? ")
			K3_Msg("SetTail", " ?")
			K3_PDFInit(A_scriptdir . "\libhpdf.dll") ; ???
			K3_PDFGetFont(FontFilePath)
			K3_PDFAddMixTextPage(OutNameNoExt, NowNR, PageWidth, PageHeight, PagePading, FontSize, LineSpacing, 12)
			K3_PDFTerm(OutDir . "\" . OutNameNoExt . ".pdf") ; ??,??
			FoxListBoxLog("??", "?????? " . jishu . " > " . OutDir . "\" . OutNameNoExt . ".pdf")
		}
		eTime := A_TickCount - sTime
		SB_SetText("??: ??????  ???: " . jishu . "  ??(ms): " . eTime)
		Traytip, ??:, ??????
	}
return

ChangeFontPath: ; Radio ???
	Gui, Submit, Nohide
	If ( CKFont1 = 1 )
		Guicontrol, Choose, FontFilePath, 1
	If ( CKFont2 = 1 )
		Guicontrol, Choose, FontFilePath, 2
	If ( CKFont3 = 1 )
		Guicontrol, Choose, FontFilePath, 3
return

ChooseFontPath: ; ??????
	FileSelectFile, SelectFontPath, 1, , ???: ????????, ????(*.ttf;*.ttc)
	If ( SelectFontPath = "" )
		return
	else
		Guicontrol, text, FontFilePath, %SelectFontPath%
return

GuiClose:
GuiEscape:
	If A_IsCompiled
		FileDelete, libhpdf.dll
	ExitApp
return

FoxListBoxLog(Action="", Msg="")
{
	static AllLog
	If ( Action = "??" ) {
		AllLog .= "|" . Msg
		Guicontrol, , Log, %AllLog%||
	}
	If ( Action = "??" ) {
		stringsplit, ll_, AllLog, |, %A_space%
		OldMsg := ll_%ll_0%
		stringreplace, AllLog, AllLog, %OldMsg%, %Msg%, A
		Guicontrol, , Log, %AllLog%||
	}
	If ( Action = "??" ) {
		AllLog := ""
		Guicontrol, , Log, |
	}
}

; -----??:
^esc::reload
+esc::Edit
!esc::ExitApp

OpenURL(URL="http://www.autohotkey.net/~linpinger/index.html?s=ExeAnsiTxt2PDF")
{
	IfExist, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE
		run, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE -new %URL%
	else
		run, %URL%
}

