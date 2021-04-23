;Example 4 - FileAppend.ahk

Ptr := A_PtrSize ? "Ptr" : "UInt"

;#Include %A_ScriptDir%\ELP.ahk
;Uncomment if you do not have ELP.ahk in your standard library

MyText := "This is some text"

;The ,*Encoding* postfix on the file path is valid for all versions of AutoHotKey
;For examples on how the "*" prefix and ,*Encoding* postfix works see the AutoHotKey
;_L example on fileappend
ELP_FileAppend(MyText, "*" . A_ScriptDir . "\FileAppend example.txt,UTF-16")

;This function will handle everything needed internally so no further operations are
;required

;Because of the encoding changes required for various operations the memory requirements
;are as follows

;AHK Basic/ANSI -> append as default (ANSI)
;2x memory of the passed text

;AHK Basic/ANSI -> append as anything other then default (ANSI)
;
;4x memory of the passed text

;AHK Unicode -> append as default (ANSI)
;
;3x memory of the passed text

;AHK Unicode -> append as UTF-16
;
;2x memory of the passed text

;AHK Unicode -> append as anything other then default (ANSI) or UTF-16
;
;3x memory of the passed text