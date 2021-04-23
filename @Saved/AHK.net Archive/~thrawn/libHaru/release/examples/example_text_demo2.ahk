page_title := "Text Demo 2"

samp_text := "The quick brown fox jumps over the lazy dog."


;load the library
hpdfDllFile := A_ScriptDir "\libhpdf.dll"
hDll := HPDF_LoadDLL(hpdfDllFile)

;create new document in memory
hDoc := HPDF_New("error","000")

;set compression mode
HPDF_SetCompressionMode(hDoc, "COMP_ALL")


   ;Creating a page, A4, Portrait
   page := HPDF_AddPage(hDoc)
   HPDF_Page_SetSize(page, "A5", "PORTRAIT")

   ;draw a grid (see libhpdf_helpers.ahk)
   print_grid(hDoc, page)

   page_height = HPDF_Page_GetHeight (page);

   ;create default-font
   font := HPDF_GetFont(hDoc, "Helvetica", 0)
   HPDF_Page_SetTextLeading(page, 20)

   ;text_rect method

   ;HPDF_TALIGN_LEFT
   rect_left := 25
   rect_top := 545
   rect_right := 200
   rect_bottom := rect_top - 40

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "LEFT")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "LEFT", void)

   HPDF_Page_EndText(page)

   ; HPDF_TALIGN_RIGTH
   rect_left := 220
   rect_right := 395

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "RIGTH")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "RIGHT", NULL)

   HPDF_Page_EndText(page)

   ; HPDF_TALIGN_CENTER
   rect_left := 25
   rect_top := 475
   rect_right := 200
   rect_bottom := rect_top - 40

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "CENTER")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "CENTER", NULL)

   HPDF_Page_EndText(page)

   ; HPDF_TALIGN_JUSTIFY
   rect_left := 220
   rect_right := 395

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "JUSTIFY")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "JUSTIFY", NULL)

   HPDF_Page_EndText(page)

   ; Skewed coordinate system
   HPDF_Page_GSave(page)

   angle1 := 5
   angle2 := 10
   rad1 := angle1 / 180 * 3.141592
   rad2 := angle2 / 180 * 3.141592

   HPDF_Page_Concat(page, 1, tan(rad1), tan(rad2), 1, 25, 350)
   rect_left := 0
   rect_top := 40
   rect_right := 175
   rect_bottom := 0

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "Skewed coordinate system")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "LEFT", NULL)

   HPDF_Page_EndText(page)

   HPDF_Page_GRestore(page)


   ; Rotated coordinate system
   HPDF_Page_GSave(page)

   angle1 := 5
   rad1 := angle1 / 180 * 3.141592

   HPDF_Page_Concat(page, cos(rad1), sin(rad1), -sin(rad1), cos(rad1), 220, 350)
   rect_left := 0
   rect_top := 40
   rect_right := 175
   rect_bottom := 0

   HPDF_Page_Rectangle(page, rect_left, rect_bottom, rect_right - rect_left, rect_top - rect_bottom)
   HPDF_Page_Stroke(page)

   HPDF_Page_BeginText(page)

   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, rect_left, rect_top + 3, "Rotated coordinate system")

   HPDF_Page_SetFontAndSize(page, font, 13)
   HPDF_Page_TextRect(page, rect_left, rect_top, rect_right, rect_bottom, samp_text, "LEFT", NULL)

   HPDF_Page_EndText(page)

   HPDF_Page_GRestore(page)

   ; text along a circle
   samp_text := "The quick brown fox jumps over the lazy dog. "
   HPDF_Page_SetGrayStroke(page, 0)
   HPDF_Page_Circle(page, 210, 190, 145)
   HPDF_Page_Circle(page, 210, 190, 113)
   HPDF_Page_Stroke(page)

   angle1 := 360 /(strlen(samp_text))
   angle2 := 180

   HPDF_Page_BeginText(page)
   font := HPDF_GetFont(hDoc, "Courier-Bold", 0)
   HPDF_Page_SetFontAndSize(page, font, 30)

   loop, % StrLen(samp_text)
   {
      i := A_Index

      rad1 := (angle2 - 90) / 180 * 3.141592
      rad2 := angle2 / 180 * 3.141592

      x := 210 + cos(rad2) * 122
      y := 190 + sin(rad2) * 122

      HPDF_Page_SetTextMatrix(page, cos(rad1), sin(rad1), -sin(rad1), cos(rad1), x, y)

      HPDF_Page_ShowText(page, SubStr(samp_text,i,1))
      angle2 -= angle1
   }

   HPDF_Page_EndText(page)


;saving to file
HPDF_SaveToFile(hDoc, "example_text_demo2.pdf")

;unload dll
HPDF_UnloadDLL(hDll)

ExitApp