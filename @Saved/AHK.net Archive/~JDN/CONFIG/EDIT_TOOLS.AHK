Hotkey `;,Lab_Semi_Indent,OFF                                                            ; ********** DISABLE **********
Hotkey `;,Lab_Semi_Unindent,OFF
Hotkey `;,Lab_Semi_Add,OFF
Hotkey `;,Lab_Semi_OverType,OFF
Hotkey `;,Lab_Semi_EndOfLine,OFF
Hotkey `/,Lab_Slash_Down,OFF

Convert_Capitalize()
{
 Clip_Save:= ClipboardAll                                                                ; save original contents of clipboard
 Clipboard:= ""                                                                          ; empty clipboard
 Send ^c{delete}                                                                         ; copy highlighted text to clipboard
 Sleep 50
 StringLower Clipboard, Clipboard, T                                                     ; convert clipboard to desired case
 Send %Clipboard%                                                                        ; send desired text
 Len:= Strlen(Clipboard)                                                                 ; length of string in clipboard
 Send +{left %Len%}                                                                      ; highlight text
 Clipboard:= Clip_Save                                                                   ; restore clipboard
}
Convert_High()
{
 Clip_Save:= ClipboardAll                                                                ; save original contents of clipboard
 Clipboard:= ""                                                                          ; empty clipboard
 Send ^c{delete}                                                                         ; copy highlighted text to clipboard
 Sleep 50
 StringUpper Clipboard, Clipboard                                                        ; convert clipboard to desired case
 Send %Clipboard%                                                                        ; send desired text
 Len:= Strlen(Clipboard)                                                                 ; length of string in clipboard
 Send +{left %Len%}                                                                      ; highlight text
 Clipboard:= Clip_Save                                                                   ; restore clipboard
}
Convert_Low()
{
 Clip_Save:= ClipboardAll                                                                ; save original contents of clipboard
 Clipboard:= ""                                                                          ; empty clipboard
 Send ^c{delete}                                                                         ; copy highlighted text to clipboard
 Sleep 50
 StringLower Clipboard, Clipboard                                                        ; convert clipboard to desired case
 Send %Clipboard%                                                                        ; send desired text
 Len:= Strlen(Clipboard)                                                                 ; length of string in clipboard
 Send +{left %Len%}                                                                      ; highlight text
 Clipboard:= Clip_Save                                                                   ; restore clipboard
}
Convert_Reverse()
{
 Clip_Save:= ClipboardAll                                                                ; save original contents of clipboard
 Clipboard:= ""                                                                          ; empty clipboard
 Send ^c{delete}                                                                         ; copy highlighted text to clipboard
 Sleep 50
 Inv_Char_Out:= ""                                                                       ; clear variable that will hold output string
 Loop % Strlen(Clipboard) {                                                              ; loop for each character in the clipboard
    Inv_Char:= Substr(Clipboard, A_Index, 1)                                             ; isolate the character
    if Inv_Char is upper                                                                 ; if upper case
       Inv_Char_Out:= Inv_Char_Out Chr(Asc(Inv_Char) + 32)                               ; convert to lower case
    else if Inv_Char is lower                                                            ; if lower case
       Inv_Char_Out:= Inv_Char_Out Chr(Asc(Inv_Char) - 32)                               ; convert to upper case
    else
       Inv_Char_Out:= Inv_Char_Out Inv_Char                                              ; copy character to output var unchanged
 }
 Send %Inv_Char_Out%                                                                     ; send desired text
 Len:= Strlen(Clipboard)                                                                 ; length of string in clipboard
 Send +{left %Len%}                                                                      ; highlight text
 Clipboard:= Clip_Save                                                                   ; restore clipboard
}
Convert_Sentence()
{
 Clip_Save:= ClipboardAll                                                                ; save original contents of clipboard
 Clipboard:= ""                                                                          ; empty clipboard
 Send ^c{delete}                                                                         ; copy highlighted text to clipboard
 Sleep 50
 StringLower, Clipboard, Clipboard                                                       ; convert clipboard to lower case
 Clipboard := RegExReplace(Clipboard, "(((^|([.!?]\s+))[a-z])| i | i')", "$u1")          ; convert clipboard to sentence case
 Send %Clipboard%                                                                        ; send desired text
 Len:= Strlen(Clipboard)                                                                 ; length of string in clipboard
 Send +{left %Len%}                                                                      ; highlight text
 Clipboard:= Clip_Save                                                                   ; restore clipboard
}

Lab_Semi_Add_Pre() {
 Global Len
 Len:= StrLen(Clipboard)                                                                 ; number of chars in clipboard
 Hotkey `;,Lab_Semi_Add,ON                                                               ; dynamically create hotkey
 Hotkey `/,Lab_Slash_Down,ON                                                             ; dynamically create hotkey
}
Lab_Semi_OverType_Pre() {
 Global Len
 Len:= StrLen(Clipboard)                                                                 ; number of chars in clipboard
 Hotkey `;,Lab_Semi_OverType,ON                                                          ; dynamically create hotkey
 Hotkey `/,Lab_Slash_Down,ON                                                             ; dynamically create hotkey
}
Lab_Semi_Indent_Pre() {
 Global Len
 Input Len, L2,{enter}{esc}{tab}{space}                                                  ; number of chars to indent
 if (Len is digit) and (Len > 0) {                                                       ; verify validity
    Hotkey `;,Lab_Semi_Indent,ON                                                         ; dynamically create hotkey
    Hotkey `/,Lab_Slash_Down,ON                                                          ; dynamically create hotkey
 }
}
Lab_Semi_Unident_Pre() {
 Global Len
 Input Len, L2,{enter}{esc}{tab}{space}                                                  ; number of chars to indent
 if (Len is digit) and (Len > 0) {                                                       ; verify validity
    Hotkey `;,Lab_Semi_Unindent,ON                                                       ; dynamically create hotkey
    Hotkey `/,Lab_Slash_Down,ON                                                          ; dynamically create hotkey
 }
}

Lab_Semi_Add:
 Send %Clipboard%{down}{left %Len%}                                                      ; insert chars
RETURN
Lab_Semi_EndOfLine:
 Send {end}^v{down}{end}                                                                 ; insert chars
RETURN
Lab_Semi_Indent:
 Send {space %Len%}{left %Len%}{down}                                                    ; indent
RETURN
Lab_Semi_OverType:
 Send %Clipboard%{delete %Len%}{down}{left %Len%}                                        ; insert chars
RETURN
Lab_Semi_Unindent:
 Send {delete %Len%}{down}                                                               ; delete chars
RETURN
Lab_Slash_Down:                                                                          ; use "/" as a down cursor key
 Send {down}
RETURN

#include c:\aa\ahk\EDITOR_HEADER.AHK
#include c:\aa\ahk\WORD_PROCESSOR_HEADER.AHK
#IfWinActive