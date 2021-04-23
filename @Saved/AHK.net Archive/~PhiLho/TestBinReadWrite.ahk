#Include BinReadWrite.ahk

file = C:\Foo.dat
wo = 0

IfExist, %file%
	FileDelete, %file%
fh := OpenFileForWrite(file)
Gosub TestError

; Write some stuff at start of file
l := Hex2Bin(data, "41484B21")
WriteInFile(fh, data, l)	; Give size because data var is larger than given bytes
Gosub TestError

; Write just after
l := Hex2Bin(data, "A961686B")
WriteInFile(fh, data, l)
Gosub TestError

; Skip some bytes
;~ l := Hex2Bin(data, "0000000000")
;~ WriteInFile(fh, data, l)
;~ Gosub TestError

; Skip some bytes
l := Hex2Bin(data, "402040")
WriteInFile(fh, data, l, FILE_BEGIN, 13)
Gosub TestError

; Replace one byte
l := Hex2Bin(data, "5F")
WriteInFile(fh, data, l, FILE_END, -2)
Gosub TestError

; Go back & fill in empty bytes
l := Hex2Bin(data, "B0B7B0B7B0")
WriteInFile(fh, data, l, FILE_CURRENT, -7)
Gosub TestError

CloseFile(fh)


fh := OpenFileForRead(file)
Gosub TestError

; Read whole file
read := ReadFromFile(fh, data)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox Whole: %data% (%read%) -> %hd% (%converted%)

; Restart reading at start
read := ReadFromFile(fh, data, 4, FILE_BEGIN)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox Start: %data% (%read%) -> %hd% (%converted%)

; Read a bit more just after
read := ReadFromFile(fh, data, 4)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox More: %data% (%read%) -> %hd% (%converted%)

; Read too much...
read := ReadFromFile(fh, data, 32, FILE_BEGIN)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox Too much: %data% (%read%) -> %hd% (%converted%)

; Read in the middle
read := ReadFromFile(fh, data, 4, FILE_BEGIN, 4)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox Middle: %data% (%read%) -> %hd% (%converted%)

; Read the end
read := ReadFromFile(fh, data, 3, FILE_END, -3)
Gosub TestError
converted := Bin2Hex(hd, data, read)
MsgBox End: %data% (%read%) -> %hd% (%converted%)

CloseFile(fh)

;=============

file = C:\Bar.dat
wo = 0

IfExist, %file%
	FileDelete, %file%
fh := OpenFileForWrite(file)
Gosub TestError

; Write some stuff at start of file
l := Hex2Bin(data, "404142434445464748494A4B4C4D4E4F")
WriteInFile(fh, data, l)	; Give size because data var is larger than given bytes
Gosub TestError

; Skip and write
l := Hex2Bin(data, "606162636465666768696A6B6C6D6E6F")
WriteInFile(fh, data, l, FILE_BEGIN, 32)
Gosub TestError

CloseFile(fh)

fh := OpenFileForWrite(file)
Gosub TestError

; Write some stuff in the middle of the file
l := Hex2Bin(data, "B0B7B0B7B0")
WriteInFile(fh, data, l, FILE_BEGIN, 20)
Gosub TestError

; And a little farther
l := Hex2Bin(data, "C0C7C0C7C0")
WriteInFile(fh, data, l, FILE_CURRENT, 20)
Gosub TestError

; Add data beyond the end
l := Hex2Bin(data, "D0D7D0D7D0")
WriteInFile(fh, data, l, FILE_END, 10)
Gosub TestError

;-- Negative offsets

data := "End of File"
l := StrLen(data)
WriteInFile(fh, data, l, FILE_BEGIN, 256 - l)
Gosub TestError

data :=  "-=#=-"
l := StrLen(data)
WriteInFile(fh, data, l, FILE_END, -48)
Gosub TestError

data :=  "^_^"
l := StrLen(data)
WriteInFile(fh, data, l, FILE_CURRENT, -64)
Gosub TestError

data :=  "OoO"
l := StrLen(data)
WriteInFile(fh, data, l)
Gosub TestError

CloseFile(fh)

MsgBox Look at the resulting file (%file%) with an hex editor...

Exit

TestError:
;Return
wo++
IfNotEqual ErrorLevel, 0, {
	MsgBox 16, Test, Error at operation %wo%: %ErrorLevel%
	Exit
}
Return
