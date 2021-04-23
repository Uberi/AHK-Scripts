page_title := "Text Demo"

samp_text := "abcdefgABCDEFG123!#$%&+-@?"
samp_text2 := "The quick brown fox jumps over the lazy dog."


;load the library
hpdfDllFile := A_ScriptDir "\libhpdf.dll"
hDll := HPDF_LoadDLL(hpdfDllFile)

;create new document in memory
hDoc := HPDF_New("error","000")

;set compression mode
HPDF_SetCompressionMode(hDoc, "COMP_ALL")

;create default-font
font := HPDF_GetFont(hDoc, "Helvetica", 0)


   ;Creating a page, A4, Portrait
   page := HPDF_AddPage(hDoc)
   HPDF_Page_SetSize(page, "A4", "PORTRAIT")

   ;draw a grid (see libhpdf_helpers.ahk)
   print_grid(hDoc, page)

   ;print the title of the page (with positioning center).
   HPDF_Page_SetFontAndSize(page, font, 24)
   tw := HPDF_Page_TextWidth(page, page_title)
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page,(HPDF_Page_GetWidth(page) - tw) / 2, HPDF_Page_GetHeight(page) - 50, page_title)
   HPDF_Page_EndText(page)

   HPDF_Page_BeginText(page)
   HPDF_Page_MoveTextPos(page, 60, HPDF_Page_GetHeight(page) - 60)


   ;font size
   fsize = 8
   while fsize < 60
   {
      ;set style and size of font.
      HPDF_Page_SetFontAndSize(page, font, fsize)

      ;set the position of the text.
      HPDF_Page_MoveTextPos(page, 0, -5 - fsize)

      ;measure the number of characters which included in the page.
      buf := samp_text
      len := HPDF_Page_MeasureText(page, samp_text, HPDF_Page_GetWidth(page) - 120, 0, 0)

      ;truncate the text.
      buf := SubStr(buf,1,len)
      HPDF_Page_ShowText(page, buf)

      ; print the description.
      HPDF_Page_MoveTextPos(page, 0, -10)
      HPDF_Page_SetFontAndSize(page, font, 8)

      buf := "Fontsize=" Round(fsize,1)

      HPDF_Page_ShowText(page, buf)

      fsize *= 1.5
   }

   ;font color
   HPDF_Page_SetFontAndSize(page, font, 8)
   HPDF_Page_MoveTextPos(page, 0, -30)
   HPDF_Page_ShowText(page, "Font color")

   HPDF_Page_SetFontAndSize(page, font, 18)
   HPDF_Page_MoveTextPos(page, 0, -20)

   len := strlen(samp_text)

   loop, %len%
   {
      i := A_Index

      r := i / len
      g := 1 - i / len

      buf := SubStr(samp_text,i,1)

      HPDF_Page_SetRGBFill(page, r, g, 0.0)
      HPDF_Page_ShowText(page, buf)
   }

   HPDF_Page_MoveTextPos(page, 0, -25)

   loop, %len%
   {
      i := A_Index

      r := i / len
      b := 1 - i / len

      buf := SubStr(samp_text,i,1)

      HPDF_Page_SetRGBFill(page, r, 0.0, b)
      HPDF_Page_ShowText(page, buf)
   }

   HPDF_Page_MoveTextPos(page, 0, -25)


   loop, %len%
   {
      i := A_Index

      b := i / len
      g := 1 - i / len

      buf := SubStr(samp_text,i,1)

      HPDF_Page_SetRGBFill(page, 0.0, g, b)
      HPDF_Page_ShowText(page, buf)
   }

   HPDF_Page_EndText(page)

   ypos := 450


   ;-----------------------------------------------
   ;Font rendering mode
   ;-----------------------------------------------
   HPDF_Page_SetFontAndSize(page, font, 32)
   HPDF_Page_SetRGBFill(page, 1, 1, 0.0)
   HPDF_Page_SetLineWidth(page, 1.5)

   ;PDF_FILL
   show_description(page, 60, ypos, "RenderingMode=PDF_FILL")
   HPDF_Page_SetTextRenderingMode(page, "FILL")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos, "ABCabc123")
   HPDF_Page_EndText(page)

   ;PDF_STROKE
   show_description(page, 60, ypos - 50, "RenderingMode=PDF_STROKE")
   HPDF_Page_SetTextRenderingMode(page, "STROKE")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos - 50, "ABCabc123")
   HPDF_Page_EndText(page)

   ;PDF_FILL_THEN_STROKE
   show_description(page, 60, ypos - 100, "RenderingMode=PDF_FILL_THEN_STROKE")
   HPDF_Page_SetTextRenderingMode(page, "FILL_THEN_STROKE")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos - 100, "ABCabc123")
   HPDF_Page_EndText(page)

   ;PDF_FILL_CLIPPING
   show_description(page, 60, ypos - 150, "RenderingMode=PDF_FILL_CLIPPING")
   HPDF_Page_GSave(page)
   HPDF_Page_SetTextRenderingMode(page, "FILL_CLIPPING")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos - 150, "ABCabc123")
   HPDF_Page_EndText(page)
   show_stripe_pattern(page, 60, ypos - 150)
   HPDF_Page_GRestore(page)

   ;PDF_STROKE_CLIPPING
   show_description(page, 60, ypos - 200, "RenderingMode=PDF_STROKE_CLIPPING")
   HPDF_Page_GSave(page)
   HPDF_Page_SetTextRenderingMode(page, "STROKE_CLIPPING")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos - 200, "ABCabc123")
   HPDF_Page_EndText(page)
   show_stripe_pattern(page, 60, ypos - 200)
   HPDF_Page_GRestore(page)

   ;PDF_FILL_STROKE_CLIPPING
   show_description(page, 60, ypos - 250, "RenderingMode=PDF_FILL_STROKE_CLIPPING")
   HPDF_Page_GSave(page)
   HPDF_Page_SetTextRenderingMode(page, "FILL_STROKE_CLIPPING")
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, ypos - 250, "ABCabc123")
   HPDF_Page_EndText(page)
   show_stripe_pattern(page, 60, ypos - 250)
   HPDF_Page_GRestore(page)

   ;Reset text attributes
   HPDF_Page_SetTextRenderingMode(page, "FILL")
   HPDF_Page_SetRGBFill(page, 0, 0, 0)
   HPDF_Page_SetFontAndSize(page, font, 30)

   ;Rotating text
   angle1 := 30                   ; A rotation of 30 degrees.
   rad1 := angle1 / 180 * 3.141592 ; Calcurate the radian value.

   show_description(page, 320, ypos - 60, "Rotating text")
   HPDF_Page_BeginText(page)
   HPDF_Page_SetTextMatrix(page, cos(rad1), sin(rad1), -sin(rad1), cos(rad1), 330, ypos - 60)
   HPDF_Page_ShowText(page, "ABCabc123")
   HPDF_Page_EndText(page)

   ;Skewing text.
   show_description(page, 320, ypos - 120, "Skewing text")
   HPDF_Page_BeginText(page)

   angle1 := 10
   angle2 := 20
   rad1 := angle1 / 180 * 3.141592
   rad2 := angle2 / 180 * 3.141592

   HPDF_Page_SetTextMatrix(page, 1, tan(rad1), tan(rad2), 1, 320, ypos - 120)
   HPDF_Page_ShowText(page, "ABCabc123")
   HPDF_Page_EndText(page)


   ;scaling text(X direction)
   show_description(page, 320, ypos - 175, "Scaling text(X direction)")
   HPDF_Page_BeginText(page)
   HPDF_Page_SetTextMatrix(page, 1.5, 0, 0, 1, 320, ypos - 175)
   HPDF_Page_ShowText(page, "ABCabc12")
   HPDF_Page_EndText(page)


   ;scaling text(Y direction)
   show_description(page, 320, ypos - 250, "Scaling text(Y direction)")
   HPDF_Page_BeginText(page)
   HPDF_Page_SetTextMatrix(page, 1, 0, 0, 2, 320, ypos - 250)
   HPDF_Page_ShowText(page, "ABCabc123")
   HPDF_Page_EndText(page)


   ;char spacing, word spacing
   show_description(page, 60, 140, "char-spacing 0")
   show_description(page, 60, 100, "char-spacing 1.5")
   show_description(page, 60, 60, "char-spacing 1.5, word-spacing 2.5")

   HPDF_Page_SetFontAndSize(page, font, 20)
   HPDF_Page_SetRGBFill(page, 0.1, 0.3, 0.1)

   ; char-spacing 0
   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, 140, samp_text2)
   HPDF_Page_EndText(page)

   ; char-spacing 1.5
   HPDF_Page_SetCharSpace(page, 1.5)

   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, 100, samp_text2)
   HPDF_Page_EndText(page)

   ; char-spacing 1.5, word-spacing 3.5
   HPDF_Page_SetWordSpace(page, 2.5)

   HPDF_Page_BeginText(page)
   HPDF_Page_TextOut(page, 60, 60, samp_text2)
   HPDF_Page_EndText(page)

;saving to file
HPDF_SaveToFile(hDoc, "example_text_demo.pdf")

;unload dll
HPDF_UnloadDLL(hDll)

ExitApp





show_stripe_pattern(ByRef page, x, y)
{
    iy := 0

    while iy < 50
    {
        HPDF_Page_SetRGBStroke(page, 0.0, 0.0, 0.5)
        HPDF_Page_SetLineWidth(page, 1)
        HPDF_Page_MoveTo(page, x, y + iy)
        HPDF_Page_LineTo(page, x + HPDF_Page_TextWidth(page, "ABCabc123"),  y + iy)
        HPDF_Page_Stroke(page)
        iy += 3
    }

    HPDF_Page_SetLineWidth(page, 2.5)
}



show_description(ByRef page, x, y, text)
{
   fsize := HPDF_Page_GetCurrentFontSize(page)
   font := HPDF_Page_GetCurrentFont(page)


   /*
   RGB := HPDF_Page_GetRGBFill(page)

   r := NumGet(RGB,0,"Float")
   g := NumGet(RGB,4,"Float")
   b := NumGet(RGB,8,"Float")
   ;msgbox % r " - " g " - " b
   */

   r := 0.43
   g := 0.44
   b := 0.0

   HPDF_Page_BeginText(page)
   HPDF_Page_SetRGBFill(page, 0, 0, 0)
   HPDF_Page_SetTextRenderingMode(page, "FILL")
   HPDF_Page_SetFontAndSize(page, font, 10)
   HPDF_Page_TextOut(page, x, y - 12, text)
   HPDF_Page_EndText(page)

   HPDF_Page_SetFontAndSize(page, font, fsize)
   HPDF_Page_SetRGBFill(page, r, g, b)


}