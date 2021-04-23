/*
ShowScriptImage.ahk

Show an image encoded directly in a script, without writing on the disk.

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.00.001 -- 2006/12/15 (PL) -- I no longer delete the bitmap, it is owned by the control.
             I get the first bitmap found in WinDir, so I am sure it is always there. Other minor changes.
 1.00.000 -- 2006/12/15 (PL) -- Creation.
*/
/*
LIMITATIONS:
- I think that compressed bitmaps are not handled (and won't be).
- Images must be small! Bigger images must use several continuation sections.

TODO:
- Manage bitmaps with palette.
- Optionally stretch image to requested size, eg. to make gradient background.
- Ideally, handle more image formats, like PNG, to benefit of compression. This would need GDI+, so lot more code...
- Better packaging, outside the demo code, for easy reusing.
*/
/* Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006 Philippe Lhoste / PhiLhoSoft
*/
#SingleInstance Force
#NoEnv

#Include DllCallStruct.ahk
#Include BinaryEncodingDecoding.ahk
#Include Pebwa.ahk

appTitle = Show Image in Script

; Two pixel image, nearly the smallest that can be done
image1 =
( Join
 42 4D 3E 00 00 00 00 00 00 00 36 00 00 00 28 00
 00 00 01 00 00 00 02 00 00 00 01 00 18 00 00 00
 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00 FF 00
)
; A familiar image
image2 =
( Join
 42 4D 36 03 00 00 00 00 00 00 36 00 00 00 28 00 00 00 10 00 00 00 10 00 00 00 01 00 18 00 00 00
 00 00 00 03 00 00 13 0B 00 00 13 0B 00 00 00 00 00 00 00 00 00 00 6E AF 65 69 AA 60 61 A2 57 5F
 A0 54 5A 9B 4E 55 96 49 4D 8E 40 4B 8C 3E 46 87 38 41 82 32 3C 7D 2C 39 7A 29 2F 71 1F 2D 6F 1D
 26 68 16 26 68 16 74 B4 6A 6E AF 65 69 AA 60 61 A2 57 5F A0 54 5A 9B 4E 55 96 49 50 91 43 4B 8C
 3E 43 84 35 41 82 32 39 7A 29 37 78 27 32 74 22 2D 6F 1D 26 68 16 76 B6 6C 71 B1 67 6E AF 65 69
 AA 60 91 B3 89 50 91 44 5A 9B 4E 55 96 49 50 91 43 4D 8E 40 6A 9C 5F 63 95 58 35 76 25 37 78 27
 32 74 22 2D 6F 1D 7E BE 75 79 B9 6F 74 B4 6A B7 D8 B2 FC FE FC 91 B3 89 61 A2 57 5A 9B 4E 55 96
 49 52 93 46 FC FE FC FC FE FC 35 76 26 39 7A 29 37 78 27 34 76 24 80 C0 78 80 C0 78 79 B9 6F B9
 DA B4 FC FE FC 91 B3 89 61 A2 57 5F A0 54 5C 9D 51 55 96 49 FC FE FC FC FE FC 35 76 26 43 84 35
 3C 7D 2C 37 78 27 89 C9 83 80 C0 78 7E BE 75 BC DD B7 FC FE FC 91 B3 89 6B AC 62 64 A5 5A 5F A0
 54 5C 9D 51 FC FE FC FC FE FC 3A 7B 2B 46 87 38 43 84 35 3C 7D 2C 8C CC 86 89 C9 83 83 C3 7C BE
 DF BA FC FE FC C7 D9 C3 91 B3 89 6B 9C 60 47 88 3A 42 83 34 FC FE FC FC FE FC 3C 7E 2E 4B 8C 3E
 46 87 38 43 84 35 93 D3 8E 8C CC 86 86 C6 7F C1 E2 BE FC FE FC FC FE FC FC FE FC FC FE FC FC FE
 FC FC FE FC FC FE FC FC FE FC 3F 80 31 52 93 46 4D 8E 40 48 89 3B 9A DA 96 97 D7 92 8C CC 86 C4
 E5 C1 FC FE FC C7 D9 C3 BC DD B7 DB EC D8 FC FE FC FC FE FC FC FE FC FC FE FC 41 83 34 55 96 49
 55 96 49 4B 8C 3E 9A DA 96 97 D7 92 93 D3 8E C8 E9 C5 FC FE FC 91 B3 89 80 C0 78 7B BB 72 76 B6
 6C 71 B1 67 FC FE FC FC FE FC 44 85 37 5C 9D 51 57 98 4B 52 93 46 A2 E2 9F 9D DD 99 9A DA 96 C8
 E9 C5 FC FE FC 91 B3 89 86 C6 7F 80 C0 78 7B BB 72 74 B4 6A FC FE FC FC FE FC 46 88 3A 61 A2 57
 5F A0 54 57 98 4B AA E9 A7 A2 E2 9F 9D DD 99 CB EC C9 FC FE FC 91 B3 89 89 C9 83 86 C6 7F 80 C0
 78 7B BB 72 FC FE FC FC FE FC 49 8A 3C 66 A7 5D 61 A2 57 5F A0 54 AD EC AA AA E9 A7 A4 E4 A1 CE
 EF CC FC FE FC AE D0 A9 90 D0 8A 89 C9 83 86 C6 7F 80 C0 78 FC FE FC FC FE FC 62 A3 57 69 AA 60
 69 AA 60 61 A2 57 B3 F1 B1 AD EC AA A7 E7 A4 A4 E4 A1 CE EF CC 9A DA 96 93 D3 8E 90 D0 8A 8C CC
 86 86 C6 7F 9F D0 99 9D CD 96 76 B6 6C 71 B1 67 6C AC 62 69 AA 60 BA F7 B7 B6 F4 B4 AF EE AD AA
 E9 A7 A4 E4 A1 9F DF 9C 9A DA 96 97 D7 92 90 D0 8A 89 C9 83 86 C6 7F 80 C0 78 7E BE 75 79 B9 6F
 71 B1 67 6E AF 65 BD FA BA BA F7 B7 B3 F1 B1 AF EE AD AA E9 A7 A4 E4 A1 9D DD 99 9A DA 96 97 D7
 92 90 D0 8A 8C CC 86 86 C6 7F 80 C0 78 7B BB 72 79 B9 6F 74 B4 6A
)
; A bit of self indulgence, both on format and image... ;-)
image3 =
( Join %,`
üú1bOóBM60á'óï6á$óï(á$óï@á$óï@á$óïÜ"ïÜ9á'óï0ïïÜ4Ü,ïïÜ4Ü,á+óï¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?á$óp¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$óp?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ)()Ü*Ü(Ü*???¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*989ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸YXYÜ*Ü(Ü*Ü*Ü(Ü*)()¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸ÁËÁ)()Ü*Ü(Ü*Ü*Ü(Ü*hhh¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*989HHHÜ*Ü(Ü
*á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸á$ó©Ü*Ü(Ü*YXY)()Ü*Ü(Ü*?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®xxx?Ÿ??Ÿ?Ü;
Ü9Ü;989¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©hhh?Ÿ??Ÿ?Ü;Ü9Ü;hhh¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁá$ó©HHHÜ;Ü9Ü;Ü;Ü9Ü;Ü;
Ü9Ü;HHHYXY)()xxxÜ;Ü9Ü;YXY???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸???HHH)()Ü;Ü9Ü;Ü;Ü9Ü;Ü;Ü9Ü;)())()xxx)()á$ópá$ó©ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸???Ü;Ü9Ü;Ü*
Ü(Ü*HHHxxx???â'ó»®©®Ü*Ü(Ü*???á$ópYXYÜ*Ü(Ü*®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ópÜ*Ü(Ü*YXYá'ópá$ó©®©®â'ó»?Ÿ?Ü*Ü(Ü*á$ópÜ*Ü(Ü*)()???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸???
Ü*Ü(Ü*HHHÁËÁ???)()¸?¸¸?¸¸?¸?Ÿ?)()?Ÿ?¸?¸¸?¸hhhÜ;Ü9Ü;ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ*Ü(Ü*xxx¸?¸¸?¸»»»Ü*Ü(Ü*?Ÿ?¸?¸¸?¸¸?¸Ü;Ü9Ü;»»»?Ÿ?989Ü;Ü9Ü;???¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸)()HHHÁËÁ¸?¸á$ópHHHá$ópâ*óHYXYá$ó©á$óp?Ÿ??Ÿ?Ü;Ü9Ü;???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®989ÁËÁ?Ÿ?á$ópá$ó©)()á$ó©989HHHá'ó©»»»¸?¸¸?¸989989¸?¸¸?¸¸?¸¸?¸¸?¸®
©®Ü*Ü(Ü*»»»?Ÿ?xxxhhhYXYxxxá$ó©®©®®©®á$ó©hhhYXYÜ;Ü9Ü;YXYHHHxxx?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»á$ó©HHH)())()YXYxxx989???®©®á$ó©YXYÜ*Ü(Ü*Ü;Ü9Ü;hhh?Ÿ????Ü*Ü(Ü*»»»¸?
¸¸?¸¸?¸¸?¸á$ópHHHá$ópÜ;Ü9Ü;hhhHHHxxx¸?¸¸?¸¸?¸¸?¸hhhxxx¸?¸¸?¸?Ÿ?xxxhhh989á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ópÜ;Ü9Ü;HHHá$óp?Ÿ?¸?¸¸?¸HHHYXY¸?¸¸?¸¸?¸¸?¸®©®á$ó©989Ü;Ü9Ü;®©®Ü
;Ü9Ü;®©®¸?¸¸?¸¸?¸¸?¸?Ÿ?á$ó©Ü;Ü9Ü;®©®ÁËÁÜ*Ü(Ü*á$óp¸?¸¸?¸¸?¸ÁËÁá$ó©989?Ÿ?ÁËÁ¸?¸á$ópHHH»»»)()®©®¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®989»»»YXYá$óp¸?¸ÁËÁ?Ÿ?á$ó©®©®¸?¸¸?¸¸?¸¸?¸á$ópÜ;Ü9Ü
;ÁËÁ®©®á$ópÜ*Ü(Ü*?Ÿ?¸?¸¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*á$óp¸?¸???Ü;Ü9Ü;¸?¸ÁËÁá$ópHHHÜ;Ü9Ü;á$ó©Ü;Ü9Ü;hhhÜ;Ü9Ü;)()YX
Yá$ó©?Ÿ?»»»Ü;Ü9Ü;¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁHHH»»»ÁËÁÜ;Ü9Ü;xxx)()Ü;Ü9Ü;Ü*
Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;YXYá$ópÁËÁÁËÁÜ*Ü(Ü*???ÁËÁHHHYXYÁËÁ¸?¸¸?¸¸?¸¸?¸á$ó©YXYYXYÜ;Ü9Ü;YXYâ'óxÜ;Ü9Ü;)()
xxx???»»»Ü*Ü(Ü*???®©®xxx989Ü;Ü9Ü;Ü;Ü9Ü;YXY989®©®?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?®©®Y
XY)()xxxÜ;Ü9Ü;á'ó©???®©®á$ó©»»»®©®xxx)()Ü;Ü9Ü;á$óp)()YXYYXY)()á$ó©á$óp¸?¸¸?¸¸?¸¸?¸xxxhhhÁËÁá$óphhh98
9hhh»»»¸?¸¸?¸¸?¸¸?¸)()HHH¸?¸¸?¸®©®á$ó©???á$ó©xxxYXY989hhh»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»YXYÜ*Ü(
Ü*Ü*Ü(Ü*989xxx»»»Ü;Ü9Ü;á$ó©¸?¸¸?¸989)()¸?¸¸?¸¸?¸¸?¸???hhhá$ó©Ü*Ü(Ü*???¸?¸YXYxxx¸?¸¸?¸¸?¸¸?¸YXYxxx¸?¸
YXY)()¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*989?Ÿ?á$óp)()ÁËÁ¸?¸®©®Ü;Ü9Ü;á$ó©Ü;Ü9Ü;Ü*Ü(Ü*hhhÁËÁ¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸ÁËÁhhhÜ*Ü(Ü*Ü;Ü9Ü;xxxá$ó©ÁËÁ¸?¸ÁËÁ)()®©®?Ÿ?989Ü*Ü(Ü*á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ*Ü(Ü*YXY¸?¸â'óh¸?¸
¸?¸¸?¸¸?¸HHH989®©®Ü*Ü(Ü*YXY¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸xxxÜ*Ü(Ü*Ü*Ü(Ü*á$ó©Ü;Ü9Ü;ÁËÁ¸?¸?Ÿ?Ü*Ü(Ü*»»»¸?¸á$ó
©Ü;Ü9Ü;)()»»»¸?¸¸?¸¸?¸¸?¸???)()Ü;Ü9Ü;á$óp¸?¸???Ü*Ü(Ü*ÁËÁ¸?¸???xxx989Ü*Ü(Ü*Ü*Ü(Ü*xxx¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸YXYÜ*Ü(Ü*???989HHH¸?¸¸?¸¸?¸¸?¸xxxÜ*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»hhhá$ópÜ*
Ü(Ü*xxxÜ;Ü9Ü;xxxá$ó©???¸?¸¸?¸?Ÿ?HHHÜ*Ü(Ü*á$óp¸?¸¸?¸á$ópÜ*Ü(Ü*YXY?Ÿ?¸?¸¸?¸á$ó©Ü;Ü9Ü;á$ópÜ;Ü9Ü;Ü*Ü(Ü*Ü
*Ü(Ü*Ü;Ü9Ü;hhh?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸???Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*á$ó©¸?¸¸?¸¸?¸¸?¸???Ü*Ü(Ü*Ü*Ü(Ü*xxx¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?Ü*Ü(Ü*á$ópHHHÜ*Ü(Ü*Ü*Ü(Ü*hhh?Ÿ?¸?¸¸?¸¸?¸xxxÜ*Ü(Ü*á$ó©xxxÜ*Ü(Ü*
á$ó©¸?¸¸?¸¸?¸?Ÿ?hhh989hhhHHHá$ó©xxxÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸hhhÜ*Ü(Ü*Ü*Ü(Ü*»»»¸?¸¸?¸¸?
¸¸?¸¸?¸HHHxxxÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ*Ü(Ü*»»»¸?¸?Ÿ?xxxÜ;Ü9Ü;Ü*Ü(Ü*á$óp¸?¸¸?¸¸?¸®©
®Ü;Ü9Ü;á$ó©???¸?¸¸?¸¸?¸á$ó©â'óHYXY¸?¸¸?¸???Ü*Ü(Ü*ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸YXYYXY¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸Ü;Ü9Ü;á$óp¸?¸¸?¸hhhá$ópYXYÜ;Ü9Ü;»»»¸?
¸¸?¸ÁËÁxxx)()ÁËÁ¸?¸¸?¸»»»Ü*Ü(Ü*xxxHHHYXY¸?¸¸?¸á$ó©)()¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁË
Á¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸989xxx¸?¸¸?¸xxx989¸?¸HHHhhh¸?¸¸?¸
hhhá$ó©)()xxx¸?¸¸?¸YXYHHH¸?¸989á$ó©¸?¸¸?¸YXYHHH¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©Ü;Ü9Ü;ÁËÁ¸?¸á$óp)()¸?¸á$óp)()¸?¸?Ÿ?
Ü*Ü(Ü*»»»???Ü*Ü(Ü*?Ÿ?¸?¸Ü;Ü9Ü;®©®¸?¸Ü*Ü(Ü*®©®¸?¸ÁËÁÜ;Ü9Ü;á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ;Ü9Ü;hhh?Ÿ????Ü*Ü(Ü*Á
ËÁ?Ÿ?á$ó©¸?¸xxxHHH¸?¸¸?¸xxx®©®¸?¸)()»»»ÁËÁá$ó©?Ÿ??Ÿ?YXY)()ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?YXYÜ;Ü9Ü;á$ó©Ü*Ü(Ü*
á$ó©Ü*Ü(Ü*Ü*Ü(Ü*xxxÜ;Ü9Ü;á$ó©989989989989hhh989á$ó©Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*hhh?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸?Ÿ?Ü*Ü(Ü*á*óp®©®Ü*Ü(Ü*???®©®®©®®©®á$ó©®©®hhhxxx®©®á$ó©»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸Ü*Ü(Ü*á$óp)()???xxx989¸?¸¸?¸¸?¸ÁËÁÜ;Ü9Ü;á$ó©®©®989á$ópÜ;Ü9Ü;¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸HHHá$ó©)()ÁËÁ989hhh¸?¸¸?¸¸?¸¸?¸hhh989ÁËÁ989hhhYXY¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸xxxâ'óhÁËÁÜ*Ü(Ü*®©®?Ÿ?YXYYXY?Ÿ?á$ópÜ;Ü9Ü;ÁËÁá$ó©YXYhhh¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸?Ÿ?Ü*Ü(Ü*???®©®Ü;Ü9Ü;»»»Ü;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*)()»»»Ü*Ü(Ü*???ÁËÁHHHá$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸xxx989¸?¸YXYHHHxxxYXYÁËÁÁËÁHHHá$ó©989hhh¸?¸989®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$óp
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ópÜ*Ü(Ü*xxx¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*á$ópÁËÁÜ;Ü9Ü;®©®YXYá$óp¸?¸¸?¸á$ó©hhhá$óp)()ÁËÁÜ*Ü(Ü*á$ó©»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸hhhÜ*Ü(Ü*á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ??Ÿ?ÁËÁ¸?¸?Ÿ?Ü;Ü9Ü;Ü;Ü9Ü;Ü*Ü(Ü
*ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ)()YXYYXYá$ópÜ;Ü9Ü;¸?¸YXYá$óp¸?¸¸?¸á$ó©hhhÁËÁÜ;Ü9Ü;á$óp)()xxx)()¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*)()Ü;Ü9Ü;ÁËÁ¸?¸ÁËÁ?Ÿ??Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸HHHÜ*Ü(Ü*Ü;Ü9Ü;
hhhá$óp)()?Ÿ?)()á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸hhhÜ*Ü(Ü*?Ÿ?989á'ó©¸?¸á$ópHHH¸?¸¸?¸HHH®©®¸?¸xxx989á$óp?Ÿ?Ü*
Ü(Ü*xxx¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$óp)()?Ÿ?Ü;Ü9Ü;â'óxÜ;Ü9Ü;Ü*Ü(Ü*HHH¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸x
xx989®©®989Ü;Ü9Ü;á$óp¸?¸á$ó©HHH¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*®©®¸?¸â'óhÁËÁ¸?¸ÁËÁ989®©®???989ÁËÁ¸?¸ÁËÁÜ;
Ü9Ü;á$óp¸?¸á$ópÜ*Ü(Ü*???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸989á$óp¸?¸xxxÜ;Ü9Ü;á$ó©®©®989á$ó©¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?
Ÿ?»»»¸?¸¸?¸?Ÿ?Ü;Ü9Ü;ÁËÁá$ópxxxÜ;Ü9Ü;???ÁËÁÜ;Ü9Ü;ÁËÁ¸?¸¸?¸¸?¸¸?¸?Ÿ?Ü;Ü9Ü;hhh¸?¸?Ÿ?á$óp)()¸?¸¸?¸¸?¸?Ÿ?
989á$ó©?Ÿ?¸?¸¸?¸¸?¸á$ó©Ü;Ü9Ü;ÁËÁ¸?¸YXYÜ;Ü9Ü;?Ÿ?¸?¸¸?¸¸?¸¸?¸ÁËÁÜ;Ü9Ü;ÁËÁ®©®hhh)()xxxÁËÁÜ;Ü9Ü;?Ÿ?¸?¸¸?
¸?Ÿ??Ÿ?¸?¸¸?¸¸?¸¸?¸xxxÜ*Ü(Ü*989???¸?¸á$ó©á$óp)()»»»®©®YXY¸?¸)()»»»®©®®©®®©®???á$ó©hhh¸?¸¸?¸989hhh989
®©®¸?¸¸?¸á'ópHHHá$óp¸?¸¸?¸®©®xxx)()HHH¸?¸¸?¸HHH989ÁËÁ®©®á$óp®©®®©®á$ó©ÁËÁ)()®©®»»»HHHxxxá$óp¸?¸®©®)()
Ü*Ü(Ü*xxx¸?¸¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*xxxÁËÁYXYá$ópÁËÁxxx989â'óHá$óp)())()Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;xxx
ÁËÁhhhÜ*Ü(Ü*»»»á$ó©)()ÁËÁá$ó©989ÁËÁÁËÁ989á$ópÁËÁÜ;Ü9Ü;á$óp»»»Ü;Ü9Ü;®©®»»»á$óp)()YXYhhh)())()989)()á$
ó©YXYá$óp¸?¸á$óphhhÁËÁhhhÜ*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*»»»¸?¸¸?¸¸?¸¸?¸¸?¸989Ü*Ü(Ü*®©®YXYHHHá'ópxxxá'óp»»»á$ópÁËÁ
¸?¸¸?¸á$ópá$ó©xxxâ'óhÜ;Ü9Ü;á$óp¸?¸ÁËÁá$óphhh989ÁËÁ¸?¸¸?¸ÁËÁá$ópHHH989ÁËÁ¸?¸á$ó©989Ü*Ü(Ü*HHH???Ü;Ü9Ü;
xxx¸?¸¸?¸ÁËÁá$ó©???®©®á$ó©YXYá$ópá$ó©â'óx®©®Ü*Ü(Ü*YXY¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»Ü*Ü(Ü*á$ó©á$ópxxxá'ó©?Ÿ?á$
ó©HHHá$ó©Ü;Ü9Ü;Ü;Ü9Ü;???hhh)()»»»¸?¸hhh)()???)()HHH?Ÿ?YXY989®©®¸?¸¸?¸¸?¸ÁËÁ989)()®©®ÁËÁHHHÜ*Ü(Ü*á$ó©
á$ópá$ó©¸?¸?Ÿ?989®©®xxxhhhHHHxxx989xxx?Ÿ?á$ópxxxHHH®©®YXYÜ*Ü(Ü*»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸???989hhhÁËÁx
xxá$ó©HHHYXYá$ó©???á$óp»»»HHHYXYá$ópÁËÁá$ópYXYÁËÁ¸?¸»»»)()hhhá$óp?Ÿ?Ü;Ü9Ü;989ÁËÁÁËÁ989)()?Ÿ?xxx)()á$
ó©?Ÿ?¸?¸ÁËÁHHHYXY?Ÿ?á$ó©Ü;Ü9Ü;hhh»»»hhh???®©®YXYHHH989á$ópÁËÁYXY)()®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁhhhÜ*Ü(Ü*
á$ó©xxx989á$ópÁËÁ?Ÿ?»»»ÁËÁ989á$ó©YXY???»»»HHHÜ*Ü(Ü*)()YXYxxxYXY989á$ó©Ü;Ü9Ü;ÁËÁ¸?¸?Ÿ?)()989á$ópYXY?Ÿ
?¸?¸ÁËÁá$óp989)()YXYxxxhhhá$ó©989xxxâ'ó»YXYYXYá$ó©»»»?Ÿ?»»»ÁËÁhhhá$ó©YXY®©®Ü;Ü9Ü;hhhÁËÁ¸?¸¸?¸¸?¸á$óp
Ü;Ü9Ü;Ü*Ü(Ü*á$óp¸?¸¸?¸á$ópYXYÜ;Ü9Ü;â'óHá$ó©989ÁËÁ»»»hhhHHH»»»???xxxYXYYXYxxx???ÁËÁÜ*Ü(Ü*»»»¸?¸¸?¸???
YXY)()???¸?¸¸?¸®©®Ü;Ü9Ü;ÁËÁ???hhhYXYhhhá$ó©ÁËÁá$óp989xxx»»»?Ÿ?á$ó©YXYHHH989)()á$ó©xxx¸?¸¸?¸á$ópÜ*Ü(Ü
*Ü;Ü9Ü;á$óp¸?¸®©®Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*hhhxxx»»»989»»»?Ÿ??Ÿ?»»»á$óphhhHHHYXY???ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸á$ó©á$ópá$ó©989989»»»®©®989989®©®YXYYXY¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ópYXYYXYxxxYXYÁËÁ?Ÿ??Ÿ????á$ó©
®©®á$óphhhÜ*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;???¸?¸?Ÿ?á$ópYXY989Ü;Ü9Ü;YXYÜ*Ü(Ü*á$ó©Ü;Ü9Ü;989HHHxxx®©®ÁËÁ¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?hhh)()Ü;Ü9Ü;YXY???¸?¸¸?¸¸?¸¸?¸???á$ópÜ;Ü9Ü;á$ó©xxx?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ
»»»â'óhHHHÜ;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;)()hhhá$ó©?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ?Ÿ?Ü*Ü(Ü*ÁËÁÁËÁá$ó©HHHÁËÁ¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»Ü;Ü9Ü;)()á$ópá$ó©???¸?¸?Ÿ?989989?Ÿ?¸?¸®©®Ü;Ü9Ü;???)()Ü;Ü9Ü;»»»¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ;Ü9Ü;á$ó©ÁËÁ?Ÿ?xxx?Ÿ?ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ*Ü(Ü*ÁËÁYXY
Ü*Ü(Ü*®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸)()YXYÁËÁ¸?¸á$ó©989»»»Ü;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;®©®hhhá$óp¸?
¸ÁËÁHHH989¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*hhh?Ÿ?Ü*Ü(Ü*ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸ÁËÁÜ*Ü(Ü*Ü;Ü9Ü;Ü*Ü(Ü*á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»Ü;Ü9Ü;»»»¸?¸¸?¸ÁËÁ989xxx)()Ü*Ü(Ü*Ü*Ü
(Ü*Ü*Ü(Ü*Ü*Ü(Ü*YXYÁËÁ¸?¸¸?¸»»»Ü*Ü(Ü*»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©Ü*Ü(Ü*)()Ü*Ü(Ü*ÁËÁ¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁÜ*Ü(Ü*Ü*Ü(Ü*á$óp¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»á$ó©Ü;Ü9Ü;Ü;
Ü9Ü;»»»989á$ópÜ;Ü9Ü;á$ópâ'ó»HHHÜ*Ü(Ü*Ü*Ü(Ü*hhhxxxÜ*Ü(Ü*á$ó©Ü*Ü(Ü*???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸á$ópÜ*Ü(Ü*Ü;Ü9Ü;¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸á$ópÜ;Ü9Ü;Ü;Ü9Ü;á$ó©®©®Ü;Ü9Ü;Ü*Ü(Ü*hhhá$ópÜ;Ü9Ü;¸?¸ÁËÁYXY®©®YXYá$ó©)()®©®»»»Ü*Ü(Ü*á$ó©á$óp¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸???á$ó©¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁhhhÜ*Ü(Ü*)()á$óp®©®Ü*Ü(Ü*)()á$ópÁËÁÁËÁÜ*Ü(Ü*®©®®©®Ü;Ü9Ü;¸?¸ÁËÁ989xxx)()®©®Ü;Ü9Ü;x
xxÜ*Ü(Ü*hhhÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁHHHÜ*Ü(Ü*)()?Ÿ?Ü;Ü9Ü;hhhá$ó©»»»)()ÁËÁ???Ü;Ü9Ü;?Ÿ?»»»Ü;Ü9Ü;????Ÿ?Ü;Ü9Ü;»»
»YXY)()á$óp?Ÿ?)()Ü*Ü(Ü*YXY¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ989Ü*Ü(Ü*Ü;Ü9Ü;ÁËÁ¸?¸xxxÜ*Ü(Ü*ÁËÁ¸?¸YXYÜ;Ü9Ü;)()á$óp¸?¸¸?¸á$ópÜ
;Ü9Ü;Ü;Ü9Ü;xxx¸?¸ÁËÁ989HHH¸?¸»»»Ü;Ü9Ü;Ü*Ü(Ü*YXYÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»)()Ü*Ü(Ü*Ü;Ü9Ü;®©®á$óphhh989YXY¸?¸¸?¸?Ÿ?ÁËÁ¸?
¸¸?¸¸?¸¸?¸ÁËÁ?Ÿ?¸?¸¸?¸HHHá$ópÜ;Ü9Ü;???®©®Ü*Ü(Ü*Ü*Ü(Ü*)()?Ÿ?¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©Ü*Ü(Ü*xxx)()á$ó©»»»Ü*Ü(Ü*á$óp
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸á$ó©Ü*Ü(Ü*?Ÿ????HHHÜ*Ü(Ü*Ü;Ü9Ü;á$ó©¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁá$ó©Ü*Ü(Ü*á$ó©x
xx®©®YXY»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*®©®xxxÜ*Ü(Ü*Ü*Ü(Ü*hhhÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸HHHÜ*Ü(Ü*
®©®)()Ü;Ü9Ü;989YXYá'ó©á$óp???®©®á$óp»»»á$ópÜ*Ü(Ü*á$ó©989)()á*ó©¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸Ü;Ü9Ü;Ü*Ü(Ü
*ÁËÁ¸?¸?Ÿ?®©®á$óphhhYXYYXYhhhYXYxxxhhhÜ;Ü9Ü;®©®?Ÿ??Ÿ?¸?¸ÁËÁÜ*Ü(Ü*Ü;Ü9Ü;¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸?Ÿ?Ü*Ü
(Ü*Ü*Ü(Ü*ÁËÁ¸?¸¸?¸¸?¸¸?¸?Ÿ?YXYHHH®©®ÁËÁá$ó©989»»»¸?¸¸?¸¸?¸¸?¸?Ÿ?Ü*Ü(Ü*Ü*Ü(Ü*ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»
»»Ü*Ü(Ü*Ü*Ü(Ü*»»»¸?¸¸?¸¸?¸¸?¸»»»á$óphhhÜ*Ü(Ü*Ü*Ü(Ü*989á$ó©»»»¸?¸¸?¸¸?¸¸?¸???Ü*Ü(Ü*Ü*Ü(Ü*»»»¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸á$ópÜ*Ü(Ü*Ü*Ü(Ü*HHHâ'óhHHHÜ;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*)()®©®HHHÜ*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;HHHâ'óhHHHÜ*
Ü(Ü*Ü*Ü(Ü*®©®¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*)()hhh»»»¸?¸¸?¸»»»YXYÜ
;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*Ü*Ü(Ü*???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸®©®Ü*Ü(Ü*Ü*Ü(Ü*Ü;Ü9Ü;989HHHá$ó
©»»»¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸»»»á$ó©HHH989Ü;Ü9Ü;Ü*Ü(Ü*Ü*Ü(Ü*???¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?
¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸
¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸ÁËÁ¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸?¸¸
?¸¸?¸¸?¸¸?¸¸?¸
) ; KM64_24.bmp: 12342 / 13750
; With palette, for future tests
; It can be displayed, but looks funny...
image4 =
( Join
424D760800000000000076000000280000004000000040000000010004000000000000080000130B0000130B0000100000000000000009070900888888004848
4800C8C8C80029282900A8A9A80068686800E7E8E7001A181A0059585900D7D9D7003938390078787800FCFEFC0098989800B7B8B700DDDDDDDDDDAEDDDDDDDD
DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDEADDDDDDDDDDDDDDDDDDD740FDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD50B7DDDDDDDDDDDDDDDDDD9004DDDDDDD
DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD74006DDDDDDDDDDDDDDDDD30B20EDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD10940ADDDDDDDDDDDDDDDD5CAA8BDDDDDD
DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD16AA86DDDDDDDDDDDDD712888294C89FDDDDDDDDDDDDDDDDDDDDDDDDDDDDF2488844C4E17DDDDDDDDDF802CF3350FE905D
DDDDDDDDDDDDDDDDDDDDDDDDDE09EE1533A0E04FDDDDDDDF027F4DDDA4ADD687DDDDDDDDDDDDDDDDDDDDDDDD70CDD30ADDD83AB8FDDDDDD427DE2E22291EAA8F
DDDDDDDDDDDDDDDDDDDDDDDD5B7AE141B2113DDBBDDDDD503AC69C155169892CADDDDDDDDDDDDDDDDDDDDDD312449CBF519086AF03DDDDE2E862CDDDD6CDDAC6
BEDDDDDDDDDDDDDDDDDDDDE82EADD29DDDD51B8585DDDDA18570EDDD71BA7DE2345DDDDDDDDDDDDDDDDDD5B39ED7A15DDDDE875E0ADDDD30EDF8D7E281868491
A38DDDDDDDDDDDDDDDDD72378C4800089E770F7297DDDD19989CC84CF30F5CB889B5ADDDDDDDDDDDDDDA594C811F5135C48E49941EDDDDC67E6B63DDDD42DD51
F1C9B63DDDDDDDDDD3900BC381DDB4DDDDF610FD9CDDDD9CD94DDDDDDD50BAE47D5818067DDDDDD7608C17D745AB0EDDDDDD709D66DDDD2B509DDDDDDDDC0018
7DA03D1843DDDDF48EDF07DFCB00CDDDDDDDD90FB2DDDDC0003DDDDDDDDD36E0C8C1FDDA20EDDE09ADD18E80086ADDDDDDDDDF0001DDDDF00CDDDDDDDDDDDDA0
E2006ADDDC01C01DDDA6B621C7DDDDDDDDDDDD6003DDDDD2C7DDDDDDDDDDDD703DAC80EDDD581FDDD1229DDF07DDDDDDDDDDDDD99DDDDDD7DDDDDDDDDDDDDDD8
EDD6E983DD7C47DD30C29DD14DDDDDDDDDDDDDDD7DDDDDDDDDDDDDDDDDDDDDDBCDDCBD26DD614CDD92DB1DD92DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD1
87DE4DE4DA03F0AD85D05D78EDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD786AF07A1DC2DDC5D4371AA947DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
A9810100C81BBBB6B100006ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDA0EEE50F555156C513DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
DDDD0E4FCBDDD7815BE8DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD2147B6DDDD6B7B69DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
DDDDC66705A99AE87196DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDA0F583800430F72EDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD5DDDDDDD
DDDDCBD92C97721B6DB5DDDDDDDDDDDEDDDDDDDDDDDDDDDDDDDDDDDE0CDDDDDDDDD30E7859EDD16E47013DDDDDDDDD60EDDDDDDDDDDDDDDDDDAA7DA8807DDDDD
DD7499E8D9EDD1678E4C4DDDDDDDD30487D7AADDDDDDDDDDDD2086E4A4EDDDDDDD60AB11DE2DD25DCBEA0CDDDDDDDE4A8CC802DDDDDDDDDDDDCB5B8ED12DDDDD
D505D667D7B5FB7D78EDE0FDDDDDDBEDC815B1DDDDDDDDA3DDA87EC8F787DDDDA86DAE4DDDAB1ADDD187D98ADDDD787564C78ADDAADDDDC0BFD1E4359D43555F
16DDB6B5DDEE2EDD5C42DD2B75E55174532CED540CDDDD3000C79E7CB22E44008C76031471B77BE78E3853E49644B419EDE6760003DDDDDB0592EECEE3E7DDE1
C668ED7E6B7DD7E2B7D1B02F8CDD71F519E1CC509DDDDDD301EC11A12188F643D64F42A9B5DDD7B457201E1DAB5C62CBCAEC25903DDDDDDDFB67C1291FE329E7
E97D346EA8B77B4AC41AD729A18636F592BE7945DDDDDD7601CBE7A37B19F32049C9B187DA4BE9AD7EB49C61BC339913A376195867DDDE80EDDE98221B73623F
C99CF703DDF94FDD587F69617EBC3A192B41CDDE08ED50006C3B3AA3E629F7DDDDDDDD1E1BB35BB599DDDDDDDDDE99C97AAF15E6008FDAE9B89018B2C57DDDDD
DDDDA6489FDDDDFE81CADDDDDDDDD7366280008461ADDDDDD7A077127DDDDDDDDDD384E1FDABBAD58F483DDDDDDDDDD7817ACA7DDDDDDDDDDD707905DDDDDDDD
DDD497D1B3800856ED72BDDDDDDDDDDD506A07DDDDDDDDDDDD7080EDDDDDDDDDDD383DD7BC4000097DD303DDDDDDDDDDD10407DDDDDDDDDDDD700EDDDDDDDDDD
DD31883BE8E332006C010FDDDDDDDDDDDDE08DDDDDDDDDDDDDD13DDDDDDDDDDDDE8815806E8D7959145301EDDDDDDDDDDDDF1DDDDDDDDDDDDDDDDDDDDDDDDDD7
604E504E770558D7BC458C067DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD7204A861347F8A38FA8394EA409DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD7B0
87DC07D984EDDE88CD7B2D38097DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD34085E6B9DDA7DDDD7ADD2E8F5004ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD1
0C4130EDDDDDDDDDD10AF2081DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD7101C593DDDDDDDD505C0067DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
D20548B911EF5E3E01B4111DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD807DA5E69969C685AAD708DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
A007DDDDA92571B3DDDDA007DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD3003DDDD3E600B13DDDDF003DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
E00266280045200082662005DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD50000000463DD3980000000FDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
5008B213DDDDDDDD312B800FDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD7DDDDDDDDDDDDDDDDDDDDDD
)
imageNb := 3
currentImageNb := 0

STM_SETIMAGE = 0x0172
STM_GETIMAGE = 0x0173
IMAGE_BITMAP = 0
BITMAPFILEHEADER_SIZE := 2 + 4 + 2 + 2 + 4
BITMAPINFOHEADER_SIZE := 4 + 4 + 4 + 2 + 2 + 4 + 4 + 4 + 4 + 4 + 4
BI_BITFIELDS = 3
DIB_RGB_COLORS = 0
DIB_PAL_COLORS = 1

guiWidth  = 400
guiHeight = 300
titleBarHeight = 24
clientHeight := guiHeight - titleBarHeight
buttonSize := titleBarHeight - 4
buttonPosX := guiWidth - buttonSize - 2
buttonPosY := guiHeight - buttonSize - 2

Gui -Caption +Border
; Annoying thing: we have to give a valid _bitmap_ image here, or it won't work!
Loop %A_WinDir%\*.bmp
{
	imageFile := A_LoopFileFullPath
	Break
}
Gui Add, Picture,  x0 y%titleBarHeight% w%guiWidth% h%clientHeight% vimage, %imageFile%
Gui Font, s9 Bold, Tahoma
Gui Margin, 0, 0
Gui Add, Text,  x0 y0 w%GuiWidth% h%titleBarHeight% +0x4	; SS_BLACKRECT
Gui Add, Text,  x0 y0 w%GuiWidth% h%titleBarHeight% cFFFFFF Backgroundtrans +0x200 gGuiMove
		, %A_Space%%A_Space%%appTitle%	; SS_CENTERIMAGE?
Gui Add, Button, x%buttonPosX% y%buttonPosY% w%buttonSize% h%buttonSize% gChangeImage, >
Gui Show, w%guiWidth% h%guiHeight%, %appTitle%
Gui +LastFound
guiID := WinExist()
Return

GuiMove:	; Thanks to Goyyah, we can more this titleless GUI
	PostMessage 0xA1, 2, , , A	; WM_NCLBUTTONDOWN
Return

ChangeImage:
	currentImageNb := ++currentImageNb > imageNb ? 1 : currentImageNb
	hBitmap := CreateBitmapInMemory(image%currentImageNb%, guiID)
	ReplacePictureImage("Static1", hBitmap)
Return

GuiEscape:
ExitApp

Pause::ListVars

GetBinaryData(ByRef @binaryData, _encodedData, _decodeMethod="")
{
	local len

	; Remove separators
	StringReplace _encodedData, _encodedData, %A_Space%, , All
	If _decodeMethod not in hex,pebwa
	;,base64,ascii85
	{
		If (SubStr(_encodedData, 1, 2) = "üú")
			_decodeMethod = pebwa
		Else
			_decodeMethod = hex
	}

	If _decodeMethod = hex
	{
		len := Hex2Bin(@binaryData, _encodedData)
	}
	Else If _decodeMethod = pebwa
	{
		len := Pebwa2Bin(@binaryData, _encodedData)
	}

	Return len
}

CreateBitmapInMemory(_imageHexData, _guiID)
{
	local len, imageData
	local bmiHeaderAddr, dataAddr
	local hdc, hBitmap

	; Transform hex data to binary data
	len := GetBinaryData(imageData, _imageHexData)
	; Transform this binary data to a bitmap handle
	; http://www.codeguru.com/Cpp/G-M/bitmap/article.php/c1681/
	; Get useful info from the headers
	; Make it global, to ease their access
	bfOffBits := GetInteger(imageData, 10)
	bmihOffset := BITMAPFILEHEADER_SIZE
	biSize := GetInteger(imageData, bmihOffset)
	biWidth := GetInteger(imageData, bmihOffset + 4)
	biHeight := GetInteger(imageData, bmihOffset + 8)
	biBitCount := GetInteger(imageData, bmihOffset + 14, 2)
	biCompression := GetInteger(imageData, bmihOffset + 16)
	biClrUsed := GetInteger(imageData, bmihOffset + 32)
	bmiColors := GetInteger(imageData, bmihOffset + 36)

	; Compute number of colors used in the image
	; If the image has a palette, that's the palette size
	colorNb := biClrUsed > 0 ? biClrUsed : 1 << biBitCount
	bmiHeaderAddr := &imageData + bmihOffset
	dataAddr := &imageData + bfOffBits	; More efficient and reliable than method below given in article above...
;~ 	dataAddr := bmiHeaderAddr + biSize
;~ 	If (biBitCount > 8)
;~ 		dataAddr += biClrUsed + (biCompression = BI_BITFIELDS ? 3 : 0)
;~ 	Else
;~ 		dataAddr += colorNb	; Skip palette

	; I suppose here bitmap is in real colors mode, I don't manage a palette yet!

	hdc := DllCall("GetDC", "UInt", _guiID, "UInt")
	; Create in memory a copy of the data, and return a handle on it
	hBitmap := DllCall("CreateDIBitmap"
		, "UInt", hdc
		, "UInt", bmiHeaderAddr  ; Bitmap data
		, "UInt", 4              ; Init. option: CBM_INIT
		, "UInt", dataAddr       ; Init. data
		, "UInt", bmiHeaderAddr  ; Color format data
		, "UInt" ; Color data usage
		, biBitCount <= 8 ? DIB_PAL_COLORS : DIB_RGB_COLORS
		, "UInt")
	If (ErrorLevel != 0 or (A_LastError > 0 and A_LastError != 127))	; I get 127, I don't know why...
	{
		MsgBox Error: %ErrorLevel% %A_LastError% (%hBitmap%)
		ExitApp
	}
	DllCall("ReleaseDC", "UInt", _guiID, "UInt", hdc)
	Return hBitmap
}

; Given a Picture control (_pictureTitle),
; and a bitmap handle (from clipboard, from GDI operations, etc.),
; tell the Picture to change its image.
; Better than BitBlt, because we don't have to manage WM_PAINT...
; Note that the given _hBitmap no longer belongs to the caller,
; either the Picture owns it, or it is destroyed, for consistent behavior.
ReplacePictureImage(_pictureTitle, _hBitmap)
{
	local hOldBitmap, hCurrentBitmap

	; From info taken from http://www.autohotkey.com/forum/viewtopic.php?t=10091
	; and from the source (in script_gui.cpp).
	; Reset the image of the control before deleting it
	SendMessage STM_SETIMAGE, IMAGE_BITMAP, 0, %_pictureTitle%
	; Handle on the previous bitmamp
	hOldBitmap := ErrorLevel
	If (hOldBitmap != "FAIL" and hOldBitmap > 0)
		; Destroy it
		DllCall("DeleteObject", "UInt", hOldBitmap)
	; Set new image
	SendMessage STM_SETIMAGE, IMAGE_BITMAP, _hBitmap, %_pictureTitle%
	; Get the handle on the bitmap stored by the control
	SendMessage STM_GETIMAGE, IMAGE_BITMAP, 0, %_pictureTitle%
	hCurrentBitmap := ErrorLevel
	; If it is different than the sent one, XP made a copy because image has alpha transparency
	If (hCurrentBitmap != "FAIL" and hCurrentBitmap != _hBitmap)
		; So delete the sent image, to avoid a memory leak
		DllCall("DeleteObject", "UInt", _hBitmap)
}

/*
typedef struct tagBITMAPFILEHEADER {
  WORD    bfType; 0
  DWORD   bfSize; 2
  WORD    bfReserved1; 6
  WORD    bfReserved2; 8
  DWORD   bfOffBits; 10 -> 14
} BITMAPFILEHEADER, *PBITMAPFILEHEADER;

typedef struct tagBITMAPINFO {
  BITMAPINFOHEADER bmiHeader;
  RGBQUAD          bmiColors[1];
} BITMAPINFO, *PBITMAPINFO;

typedef struct tagBITMAPINFOHEADER{
  DWORD  biSize; 0
  LONG   biWidth; 4
  LONG   biHeight; 8
  WORD   biPlanes; 12
  WORD   biBitCount; 14
  DWORD  biCompression; 16
  DWORD  biSizeImage; 20
  LONG   biXPelsPerMeter; 24
  LONG   biYPelsPerMeter; 28
  DWORD  biClrUsed; 32
  DWORD  biClrImportant; 36 -> 40
} BITMAPINFOHEADER, *PBITMAPINFOHEADER;
*/
