#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Crypt.ahk
#Include CryptConst.ahk
#Include CryptFoos.ahk

;~ Examples:

msgbox % "Bytes writen: " Crypt.Encrypt.FileEncrypt("test.txt","test.cr","IwantAcake")	; encrypts file using RC4 encryption and MD5 hash
msgbox % "Bytes writen: " Crypt.Encrypt.FileDecrypt("test.cr","test_out.txt","IwantAcake") ; decrypts file encrypted with RC4 and MD5

msgbox % "Bytes writen: " Crypt.Encrypt.FileEncrypt("test.txt","test.cr","IwantAcake",7,6)	; encrypts file using AES_256 encryption and SHA_512 hash
msgbox % "Bytes writen: " Crypt.Encrypt.FileDecrypt("test.cr","test_out.txt","IwantAcake",7,6) ; decrypts file encrypted with AES_256 and SHA_512

msgbox % hash := Crypt.Encrypt.StrEncrypt("MS encryption works in that way","007",5,1) ; encrypts string using AES_128 encryption and MD5 hash
msgbox % decrypted_string := Crypt.Encrypt.StrDecrypt(hash,"007",5,1)				  ; decrypts the string using previously generated hash,AES_128 and MD5

msgbox % hash := Crypt.Hash.FileHash("test.txt") ; get a MD5 HASH of file, its 55EEE971C6357584B4F0EDB6194E2987
msgbox % hash := Crypt.Hash.FileHash("test.txt",3) ; get a SHA1 HASH of file, B65C8825FB47B72A8A15EF85E48C0C8BD5C50D51
msgbox % hash := Crypt.Hash.FileHash("test.txt",6,"Hello,World!",7) ; get a HMAC SHA_512 HASH of file using password "Hello,World!" and AES_256 encryption key

msgbox % hash := Crypt.Hash.StrHash("RabbidsGoHome",2) ; gets a MD2 HASH of string and result is A81FE29CEA80104F9D6DB0615F805B79

;~ --Example of using FileEncryptToStr & StrDecryptToFile:

pass := "somepass"
cv := FileOPen("res.txt","w","CP0")
cv.Write(Crypt.Encrypt.FileEncryptToStr("test.txt",pass,7, 6))
cv.close()

cv := FileOPen("res.txt","r","CP0")
hash := cv.Read()
Crypt.Encrypt.StrDecryptToFile(hash,"test_out.txt",pass,7, 6)
hash =
cv.close()