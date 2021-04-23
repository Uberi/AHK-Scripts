VerDate := "2011-10-12"

	Menu, SiteMenu, Add, olsoul???(&W), FoxHelp
	Menu, SiteMenu, Add, olsoul??(&B), FoxHelp
	Menu, SiteMenu, Add, ?????(&L), FoxHelp

	Menu, MyMenuBar, Add, ??(&T), ZhiDing
	Menu, MyMenuBar, Add, ??(&O), :SiteMenu
	Menu, MyMenuBar, Add, ????(&A), FoxHelp
	Menu, MyMenuBar, Add, ?????(&L), FoxHelp
	Menu, MyMenuBar, Add, ????(&H), FoxHelp
	Gui, Menu, MyMenuBar
GuiInit:
	Gui, +AlwaysOnTop
	Gui, Add, GroupBox, x6 y10 w370 h330 cBlue, ? ??Txt ??????????,?????????
	Gui, Add, ListView, +NoSortHdr x16 y30 w350 h300 gClickFoxLV vFoxLV, ???|???
	LV_ModifyCol(1, 60) , LV_ModifyCol(2, 260)

	Gui, Add, StatusBar, , ??: ??Txt??????????   ??: %VerDate%
	; Generated using SmartGUI Creator 4.0
	Gui, Show, h365 w385, ?????Mobi?? ??: %VerDate%
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
		OpenURL("http://www.olsoul.com?s=ExeQidianTxt2Mobi")
	If ( A_thismenuitem = "olsoul??(&B)" )
		OpenURL("http://bbs.olsoul.com?s=ExeQidianTxt2Mobi")
	If ( A_thismenuitem = "????(&A)" )
		TrayTip, ?????:, QQ: 308639546`nhttp://www.autohotkey.net/~linpinger/index.html
	If ( A_thismenuitem = "?????(&L)" )
		OpenURL("http://www.autohotkey.net/~linpinger/index.html?s=ExeQidianTxt2Mobi")
	If ( A_thismenuitem = "????(&H)" ) {
		AAAbout =
		(Ltrim join`n
		??: ?????????????Mobi??(Kindle???)
		??: ????????????????,?????????,?????????????(????,???????)
		)
		traytip, ????:, %AAAbout%
	}
return

ClickFoxLV:
	if ( A_GuiEvent = "DoubleClick" ) { ; ???? ??????, ??????
		LV_GetText(FieldA, A_EventInfo, 1)
		sTime := A_TickCount
		SplitPath, File_full_path, , FileDir
		FileInstall, kindlegen.exe, kindlegen.exe, 1
		ProcessChapter2Mobi(GlobalQDTxt, FieldA, FileDir)
		FileDelete, kindlegen.exe
		eTime := A_TickCount - sTime
		SB_SetText("Mobi????: " . NowBookName . "  ??(??): " . eTime)
	}
return

GuiDropFiles:
	File_full_path := A_GuiEvent  ; ????,???????
	if ( A_guicontrol = "FoxLV" ) {
		FileRead, TmpNR, %File_full_path%
		If instr(TmpNR, "????") And instr(TmpNR, "??:")
		{
		LV_Delete()
		K3_QiDianTxtPrepProcess(TmpNR, GlobalQDTxt, "Add2LV")
		TmpNR := ""
		NowBookName := K3_QiDianGetSec(GlobalQDTxt, "BookName")
		LV_ModifyCol(2, "", "??? in «" . NowBookName . "»")
		} else {
			SB_SetText("???Txt???????????,???????Txt2Mobi??")
			TrayTip, ??:, ???Txt???????????
		}
	}
return


GuiClose:
GuiEscape:
	If A_IsCompiled
		FileDelete, kindlegen.exe
	ExitApp
return

; -----??:
^esc::reload
+esc::Edit
!esc::ExitApp

ProcessChapter2Mobi(Byref MarkedStr, StartPartNum=1, OutFileDir="")
{	; ???????????Mobi(?)
	TOCName := "FoxIndex"
	MainHTMLName := TOCName . ".htm" , NCXName := TOCName . ".ncx"
	OutMainHTMLPath :=  OutFileDir . "\" . MainHTMLName , OutNCXPath :=  OutFileDir . "\" . NCXName

	NowBookName := K3_QiDianGetSec(MarkedStr, "BookName") , AllPartCount := K3_QiDianGetSec(MarkedStr, "PartCount")
	OutOPFPath := OutFileDir . "\" . NowBookName . ".opf"

	; HTML ??
	NewHead = 
	(join`n Ltrim
	<html><head>
	<meta http-equiv=Content-Type content="text/html; charset=utf-8">
	<style type="text/css">h2,h3,h4{text-align:center;}</style>
	<title>%NowBookName%</title></head><body>
	<a id="toc"></a>`n`n<h3>%NowBookName%</h3>`n`n
	)
	NewTail .= "</body></html>`n"

	K3_MobiCreateNCX("AddItem", MainHTMLName . "#toc", "??", "toc")
	loop, % AllPartCount - StartPartNum + 1
	{
		NowPartNum := StartPartNum + A_index - 1
		NowTitle := K3_QiDianGetSec(MarkedStr, "Title" . NowPartNum) , NowPart := K3_QiDianGetSec(MarkedStr, "Part" . NowPartNum)
		K3_Msg("AddMsg", "??Mobi HTM ?: " . NowPartNum . " / " . AllPartCount)
		Stringreplace, NowPart, NowPart, `n, <br>`n, A

		K3_MobiCreateNCX("AddItem", MainHTMLName . "#" . NowPartNum, NowTitle, NowPartNum)
		NewTOC .= "<a href=""#" . NowPartNum . """>" . NowTitle . "</a><br>`n"
		NewTxt .= "<a id=""" . NowPartNum . """></a>`n`n<h4>" . NowTitle . "</h4>`n" . NowPart . "`n<mbp:pagebreak/>`n`n"
	}

	UTF8NR := K3_Ansi2UTF8(NewHead . NewTOC . "`n<mbp:pagebreak/>`n`n<a id=""content""></a>`n`n" . NewTxt . NewTail)
	K3_Msg("AddMsg", "??Mobi??: " . NowBookName)

	FileAppend, %UTF8NR%, %OutMainHTMLPath%              ; ??????foxopf????????
	K3_MobiCreateNCX("Create", OutNCXPath, NowBookName)

	K3_MobiCreateOPF("TOCName", "FoxIndex") ; ???
	K3_MobiCreateOPF("BookName", NowBookName)
	K3_MobiCreateOPF("HasNCX")
	K3_MobiCreateOPF("Create", OutOPFPath)

	runwait, kindlegen.exe %OutOPFPath%, %OutFileDir%, Hide
	FileDelete, %OutOPFPath%
	FileDelete, %OutNCXPath%
	FileDelete, %OutMainHTMLPath%
}

OpenURL(URL="http://www.autohotkey.net/~linpinger/index.html?s=ExeQidianTxt2Mobi")
{
	IfExist, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE
		run, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE -new %URL%
	else
		run, %URL%
}

/*
??K3??:
K3_Ansi2UTF8
K3_MobiCreateNCX
K3_MobiCreateOPF
K3_Msg
K3_QiDianGetSec
K3_QiDianTxtPrepProcess
*/
