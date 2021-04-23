/* TheGood
How to properly add a horizontal scrollbar to a ListBox
*/

Gui, Add, ListBox, h100 hwndhLB +HScroll, This is a short list box item.|This is a very very very very very very very very very very very very very very long list box item.
Gui, Show

;Add Horizontal Bar
ListBoxAdjustHSB(hLB)

Return

GuiClose:
ExitApp
Return

ListBoxAdjustHSB(hLB) {
   
   ;Declare variables (for clarity's sake)
   dwExtent := 0
   dwMaxExtent := 0
   hDCListBox := 0
   hFontOld := 0
   hFontNew := 0
   VarSetCapacity(lptm, 53)
   
   ;Use GetDC to retrieve handle to the display context for the list box and store it in hDCListBox
   hDCListBox := DllCall("GetDC", "Uint", hLB)

   ;Send the list box a WM_GETFONT message to retrieve the handle to the font that the list box is using, and store this handle in hFontNew
   SendMessage 49, 0, 0,, ahk_id %hLB%
   hFontNew := ErrorLevel

   ;Use SelectObject to select the font into the display context. Retain the return value from the SelectObject call in hFontOld
   hFontOld := DllCall("SelectObject", "Uint", hDCListBox, "Uint", hFontNew)

   ;Call GetTextMetrics to get additional information about the font being used (eg. to get tmAveCharWidth's value)
   DllCall("GetTextMetrics", "Uint", hDCListBox, "Uint", &lptm)
   tmAveCharWidth := NumGet(lptm, 20)

   ;Get item count using LB_GETCOUNT
   SendMessage 395, 0, 0,, ahk_id %hLB%

   ;Loop through the items
   Loop %ErrorLevel% {

      ;Get list box item text
      s := GetListBoxItem(hLB, A_Index - 1)

      ;For each string, the value of the extent to be used is calculated as follows:
      DllCall("GetTextExtentPoint32", "Uint", hDCListBox, "str", s, "int", StrLen(s), "int64P", nSize)
      dwExtent := (nSize & 0xFFFFFFFF) + tmAveCharWidth

      ;Keep if it's the highest to date
      If (dwExtent > dwMaxExtent)
         dwMaxExtent := dwExtent
      
   }
   
   ;After all the extents have been calculated, select the old font back into hDCListBox and then release it:
   DllCall("SelectObject", "Uint", hDCListBox, "Uint", hFontOld)
   DllCall("ReleaseDC", "Uint", hLB, "Uint", hDCListBox)
   
   ;Adjust the horizontal bar using LB_SETHORIZONTALEXTENT
   SendMessage 404, dwMaxExtent, 0,, ahk_id %hLB%

}

GetListBoxItem(hLB, i) {
      
   ;Get length of item. 394 = LB_GETTEXTLEN
   SendMessage 394, %i%, 0,, ahk_id %hLB%
   
   ;Check for error
   If (ErrorLevel = 0xFFFFFFFF)
      Return ""
   
   ;Prepare variable
   VarSetCapacity(sText, ErrorLevel, 0)
   
   ;Retrieve item. 393 = LB_GETTEXT
   SendMessage 393, %i%, &sText,, ahk_id %hLB%
   
   ;Check for error
   If (ErrorLevel = 0xFFFFFFFF)
      Return ""
   
   ;Done

   Return sText

}

