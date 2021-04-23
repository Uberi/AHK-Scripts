#NoTrayIcon
VerDate := "2012-3-22"

FontFilePath = %1%
FontSize = %2%
PageWidth = %3%
PageHeight = %4%
PagePading = %5%
LineSpacing = %6%
File_full_path = %7%
PDFSavePath = %8%

If ( FontFilePath = "" or FontFilePath = "-h" ) {
	HelpContent =
	(join`n Ltrim
	Txt2PDF_CMD.exe ???? ?? ??? ??? ??? ??? ?????? [??PDF??]
	??:
	Txt2PDF_CMD.exe "D:\etc\Font\???_GBK.TTF" 9.5 257 335 5 12.5 "c:\??.txt" | cat
	Txt2PDF_CMD.exe "D:\etc\Font\???_GBK.TTF" 9.5 257 335 5 12.5 "c:\??.txt" "C:\etc\??_??.pdf" | cat
	)
	msgbox, %HelpContent%
	ExitApp
}

; ?????
	FileInstall, libhpdf.dll, libhpdf.dll, 1
	Fileread, NowNR, %File_full_path%
	SplitPath, File_full_path, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	If ( PDFSavePath = "" )
		PDFSavePath := OutDir . "\" . OutNameNoExt . ".pdf"
	FileAppend, ?? %OutNameNoExt% ?PDF,???...`r`n, *

	K3_PDFInit(A_scriptdir . "\libhpdf.dll") ; ???
	K3_PDFGetFont(FontFilePath)
	K3_PDFAddMixTextPage(OutNameNoExt, NowNR, PageWidth, PageHeight, PagePading, FontSize, LineSpacing, 12)
	K3_PDFTerm(PDFSavePath) ; ??,??

	FileAppend, ????,???: %PDFSavePath%`n, *
	FileDelete, %A_scriptdir%\libhpdf.dll
	ExitApp
return
