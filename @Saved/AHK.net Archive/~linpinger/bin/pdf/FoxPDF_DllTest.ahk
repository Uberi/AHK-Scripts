^esc::reload
+esc::Edit
!esc::ExitApp
F1::
	OutPDFPath := A_scriptdir . "\00000.pdf"
	FileDelete, %OutPDFPath%
	FoxStr := "??FoxSaid~!@#$%^&*()_+|-=\??,????????,?????????????????,??????????????????????????????,???????????,????:“???,?????????????????????,?????????,????????????????????……”(????)!~!" ; ???????
	loop, 15
		nr .= FoxStr . "`n------------`n"
	FoxStr := nr , nr := ""
;	FoxStr := "???????,??,ABCDEFGHIjklMNOPQRSTUV???,???? ?" ; 40 + 23 = 63


	hModule := DllCall("LoadLibrary", "Str", "FoxPDF.dll")  
	sTime := A_TickCount
	Dllcall("FoxPDF.dll\FoxPDF_init", "str", "C:\WINDOWS\Fonts\simhei.ttf", "Cdecl int") ; ???

	hpage0 := PDFAddTextPage("?????", "", 257, 335, 5, 9.5, 12.5, 12)
	hpage1 := PDFAddTextPage("???", FoxStr, 257, 335, 5, 9.5, 12.5, 12)
	hpage2 := PDFAddTextPage("???", FoxStr, 257, 335, 5, 9.5, 12.5, 12)
;	hpage3 := Dllcall("FoxPDF.dll\FoxPDF_AddImagePage", "str", "?????", "str", "c:\etc\1.png", "int", 1, "Cdecl int")
;	hpage4 := Dllcall("FoxPDF.dll\FoxPDF_AddImagePage", "str", "", "str", "c:\etc\2.png", "int", 1, "Cdecl int")

	; ????
	xx := Dllcall("FoxPDF.dll\FoxPDF_AddOutLine", "str", "???", "int", hpage0, "Cdecl int")
	AA := Dllcall("FoxPDF.dll\FoxPDF_AddOutLine", "str", "???", "int", hPage1, "Cdecl int")
	BB := Dllcall("FoxPDF.dll\FoxPDF_AddOutLine", "str", "???", "int", hPage2, "Cdecl int")

	; ????
	cc := Dllcall("FoxPDF.dll\FoxPDF_AddLink", "int", hpage0, "float", 0, "float", 300, "float", 257, "float", 335, "int", hpage2, "Cdecl int")
;	FoxPDF_AddLink(hSrcPage:HPDF_Page; left,bottom,right,top:HPDF_REAL; hDestPage:HPDF_Page):HPDF_Annotation;
	
	Dllcall("FoxPDF.dll\FoxPDF_term", "str", OutPDFPath, "Cdecl int") ; ?????
	eTime := A_TickCount - sTime
	DllCall("FreeLibrary", "UInt", hModule)
	IfExist, %OutPDFPath%
	{
		Traytip, ??:%eTime%, %AA%`n%BB%`n%cc%
		run, %OutPDFPath%
	} else
		Traytip, ???PDF:, %AA%
return


PDFAddTextPage(Title="", sContent="", PageWidth=260, PageHeight=335, PageSpace=5, FontSize=9, LineSpace=13.5, TitleFontSize=12)
{	; ????,??,?????
	PageCount := 1
	hStartPage := hPage := Dllcall("FoxPDF.dll\FoxPDF_AddBlankPage", "float", PageWidth, "float", PageHeight, "Cdecl int")

	If ( Title = "" ) ; ?????
		TitleFontSize := 0
	else 
		Dllcall("FoxPDF.dll\FoxPDF_ShowTextAtYRange" , "str", Title , "int", 1 , "float", PageHeight-PageSpace, "float", PageHeight-PageSpace-TitleFontSize , "float", PageWidth , "float", PageHeight , "float", PageSpace , "float", TitleFontSize , "float", TitleFontSize*1.5 , "int", 5 , "Cdecl int")

	If ( sContent = "" ) ; ????
		return, hStartPage
	startPos := 1 , alllen := StrLen(sContent)

	aa := Dllcall("FoxPDF.dll\FoxPDF_ShowTextAtYRange" , "str", sContent , "int", startPos , "float", PageHeight-PageSpace-TitleFontSize, "float", PageSpace , "float", PageWidth , "float", PageHeight , "float", PageSpace , "float", FontSize , "float", LineSpace , "int", 0 , "Cdecl int")

	while ( startPos := startPos + aa ) <= alllen
	{
		++PageCount
		hPage := Dllcall("FoxPDF.dll\FoxPDF_AddBlankPage", "float", PageWidth, "float", PageHeight, "Cdecl int")
		aa := Dllcall("FoxPDF.dll\FoxPDF_ShowTextAtYRange" , "str", sContent , "int", startPos , "float", PageHeight-PageSpace, "float", PageSpace , "float", PageWidth , "float", PageHeight , "float", PageSpace , "float", FontSize , "float", LineSpace , "int", 0 , "Cdecl int")
	}
	return, hStartPage
}

