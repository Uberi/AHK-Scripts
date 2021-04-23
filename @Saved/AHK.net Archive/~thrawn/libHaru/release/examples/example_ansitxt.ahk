ansi2pdf("testText.txt")

return


ansi2pdf(filename,target="")
{
   SplitPath, fileName, fileNameNoPath, targetDir,,noExt
   Fileread, text, %filename%

   remaining := textLength := StrLen(text)

   if targetDir =
      targetDir = .

   if target =
      target := targetDir "\" noExt ".pdf"

   ;load the library
   hpdfDllFile := A_ScriptDir "\libhpdf.dll"
   hDll := HPDF_LoadDLL(hpdfDllFile)

   ;create new document in memory
   hDoc := HPDF_New("error","000")

   ;Load a Standard-font
   encoding := "WinAnsiEncoding"
   fontName := HPDF_LoadTTFontFromFile(hDoc, A_WinDir "\Fonts\arial.ttf", 0)
   font := HPDF_GetFont2(hDoc, fontName, encoding)
   MAX_TEXT_POST := 25000

   ;if there are characters left to print, write them to a new page
   while remaining > 0
   {
      ;Creating a page, A4, Landscape
      ;+get dimensions for further usage
      page := HPDF_AddPage(hDoc)
      HPDF_Page_SetSize(page, "A4", "PORTRAIT")
      height := HPDF_Page_GetHeight(page)
      width := HPDF_Page_GetWidth(page)

      ;Writing the header
      HPDF_Page_BeginText(page)
      HPDF_Page_SetFontAndSize(page, font, 11)
      header := fileNameNoPath " (Page " A_Index ")"
      tw := HPDF_Page_TextWidth(page, header)
      HPDF_Page_MoveTextPos(page, (width-tw)/2, height-20)

      HPDF_Page_ShowText(page, header)
      HPDF_Page_EndText(page)


      ;Write the text to the page
      HPDF_Page_BeginText(page)
      HPDF_Page_SetFontAndSize(page, font, 11)

      ;text-dimensions on the page
      rect_left := 20
      rect_top := height-40
      rect_right := width-40
      rect_bottom := 20

      HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, SubStr(text,textLength-remaining+1,MAX_TEXT_POST), "LEFT", charsWritten)
      remaining := remaining - charsWritten

      HPDF_Page_EndText(page)
   }

   ;saving to file
   HPDF_SaveToFile(hDoc, target)

   ;unload dll
   HPDF_UnloadDLL(hDll)
}