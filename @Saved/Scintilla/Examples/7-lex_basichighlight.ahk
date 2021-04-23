#include ..\SCI.ahk
#singleinstance force

;---------------------
; This is an example of how to select a Lexer located in a scintilla dll and make some basic highlighting.
; In this example we will select the AutoHotkey Lexer. Keywords are to be added manually so we will add some random words.
;
; The idea is to first select which lexer to use (specially if scilexer.dll has more than one) with SetLexer(lexNum)
; Then you can add some keywords to the keyword lists which will be colored as soon as they appear.
; Finally you can change the Font properties with StyleSetXXXX functions in this case I changed the color of the styles.

Gui +LastFound
sci := new scintilla(WinExist())

sci.SetWrapMode(true), sci.SetLexer(2), sci.StyleClearAll()
sci.SetKeywords(0, "msgbox true another testing")

sci.StyleSetBold(11, true)
sci.StyleSetFore(11, 0x0000FF) ; Style No. 11 Belongs to SCE_AHK_WORD_CF in this particular lexer which is linked to the Keyword list No. 0 above.

sci.SetText(unused, "Start Typing here and add some of the words from line 16`nFeel free to add more words to the list.")
Gui, show, w600 h400
return

GuiClose:
    ExitApp