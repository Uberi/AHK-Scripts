;--------------------------------------------------
; GOOGLETRANSLATE
; Ctrl+C (x2) to instantly translate selected text, using Google-translate
; by Mikhail Kuropyatnikov (micdelt@mail.ru) modified by Drini(yDrini@twitter.com) and remodified by Simon(simon.stralberg@gmail.com)
; http://www.autohotkey.com/forum/viewtopic.php?t=52124 for more info
; 
;
; 
;--------------------------------------------------
#NoEnv
#SingleInstance, Force
OnExit, Exit
GoSub, LanguageList
Menu, Tray, NoStandard
Menu, Tray, Add, (§) Set Language, SetLanguage
Menu, Tray, Add, (X) Exit, Exit
n = 1 ; Setting standards
x = 2
IfExist, Data/GoogleTranslateIni.ini
	{
	IniRead, ChosenLanguageTo, Data/GoogleTranslateIni.ini, General, ChosenLanguageTo
	IniRead, ChosenLanguageAnti, Data/GoogleTranslateIni.ini, General, ChosenLanguageAnti
    IniRead, n, Data/GoogleTranslateIni.ini, General, ChosenLanguageToCode
	IniRead, x, Data/GoogleTranslateIni.ini, General, ChosenLanguageAntiCode
	}
To:= Code%n%
Anti := Code%x%
Traytip, GoogleTranslator:, Press ctrl+c(x2) to instantly translate any text to your chosen language (%to%), 4, 1
return
SetLanguage:
Gui, Destroy
Gui, Add, Text, x10, Language (To)
StringTrimLeft, N, ChosenLanguageTo, 8
StringTrimLeft, X, ChosenLanguageAnti, 8
Gui, Add, DropDownList, yp x140 vToLanguage Choose%n%, %LanguageList%
Gui, Add, Text, x10, Language (Reverse)
Gui, Add, DropDownList, yp x140 vAntiLanguage Choose%x%, %LanguageList%
Gui, Add, Button, x10 w120 gGuiSubmit, < Submit >
Gui, Add, Button, x140 yp w80 gGuiCancel, < Cancel >
Gui, Add, Button, x230 yp w30 gLanguageHelp, < ? >
Gui, Show
if to =
to = en
if anti =
anti = ru
return
LanguageHelp:
Msgbox, To = What you want to translate to.`nReverse = What to translate to if text is in (to) language.`n`nNOTE! GoogleTranslate automatically finds the language of the text you want to translate. Activate GoogleTranslate by pressing Ctrl+C two times consecutevely.
return
GuiCancel:
Gui, Destroy
return
GuiSubmit:
Gui, Submit

; Set the "TO" data
Container := %ToLanguage%
StringTrimLeft, N, Container, 8
IniWrite, %Container%, Data/GoogleTranslateIni.ini, General, ChosenLanguageTo
IniWrite, %n%, Data/GoogleTranslateIni.ini, General, ChosenLanguageToCode
To := Code%n%
; Set the "ANTI" data
Container := %AntiLanguage%
StringTrimLeft, X, Container, 8
IniWrite, %Container%, Data/GoogleTranslateIni.ini, General, ChosenLanguageAnti
IniWrite, %x%, Data/GoogleTranslateIni.ini, General, ChosenLanguageAntiCode
Anti := Code%x%
TrayTip, GoogleTranslate:, To %tolanguage% (%to%)`nor %antilanguage%(%anti%), 2, 1
return
::restart tsl::
Reload
Return
~^C:: DoublePress()

; translate to "to" language,
; if source language is "to"
; translate to "anti" language

Translate(to,anti)
{

   use_anti = 0
   translate_to := to
   if clipboard =
       return

   Transform, unicodeClipboard, Unicode
anti_translate:
   url := "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q="
            . uriEncode(unicodeClipboard) . "&langpair=%7C" . translate_to
            
   ; simulate UrlDownloadToVAR
   UrlDownloadToFile, %url%, %A_ScriptDir%\translate.html
   FileRead, json_trans, %A_ScriptDir%\translate.html
   json_trans := UTF82Ansi(json_trans)

   rgxText = \Q{"translatedText":"\E(?P<Text>.*)\"\,
   rgxDetectedLanguage = \Q"detectedSourceLanguage":"\E(?P<DetectedLanguage>.*)\"\}
   rgxDetails = \Q"responseDetails": "\E(?P<Details>.*)\"\,
   rgxStatus = \Q"responseStatus": \E(?P<Status>\d*)

   RegExMatch(json_trans,rgxText,trans)
   RegExMatch(json_trans,rgxDetails,trans)
   RegExMatch(json_trans,rgxStatus,trans)
   RegExMatch(json_trans,rgxDetectedLanguage,trans)
   
   if transStatus = 200
   {
      if (transDetectedLanguage = to and translate_to <> anti)
      {
         translate_to := anti
         goto anti_translate
      }
      
      t := UnHTM(UnSlashUnicode(transText))
      ; split long line to smaller lines about 40-50 symbols length
      t := RegExReplace(t,".{40,50}(\s)","$0`n")
      if transDetectedLanguage =
         ToolTip %t%
      else
      {
         ToolTip %transDetectedLanguage%>%translate_to%:%t%
      }
   
      ; copy result to clipboard
      Clipboard := t
   }
   else
      ToolTip %transDetails%
}
~LButton:: ; Remove tooltip left click
ToolTip
return
;------
; DoublePress
;-------

DoublePress() ; Simulate double press
{
   global
   static pressed1 = 0
   if pressed1 and A_TimeSincePriorHotkey <= 500
   {
      pressed1 = 0
      Translate(to, anti) ; from English to Russian
   }
   else
      pressed1 = 1
   
}

;---------------------------------------
; Convert strings
;---------------------------------------

/*
CP_ACP   = 0
CP_OEMCP = 1
CP_MACCP = 2
CP_UTF7  = 65000
CP_UTF8  = 65001
*/

Ansi2Oem(sString)
{
   Ansi2Unicode(sString, wString, 0)
   Unicode2Ansi(wString, zString, 1)
   Return zString
}

Oem2Ansi(zString)
{
   Ansi2Unicode(zString, wString, 1)
   Unicode2Ansi(wString, sString, 0)
   Return sString
}

Ansi2UTF8(sString)
{
   Ansi2Unicode(sString, wString, 0)
   Unicode2Ansi(wString, zString, 65001)
   Return zString
}

UTF82Ansi(zString)
{
   Ansi2Unicode(zString, wString, 65001)
   Unicode2Ansi(wString, sString, 0)
   Return sString
}

Ansi2Unicode(ByRef sString, ByRef wString, CP = 0)
{
     nSize := DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", 0
      , "int",  0)

   VarSetCapacity(wString, nSize * 2)

   DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", &wString
      , "int",  nSize)
}

Unicode2Ansi(ByRef wString, ByRef sString, CP = 0)
{
     nSize := DllCall("WideCharToMultiByte"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &wString
      , "int",  -1
      , "Uint", 0
      , "int",  0
      , "Uint", 0
      , "Uint", 0)

   VarSetCapacity(sString, nSize)

   DllCall("WideCharToMultiByte"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &wString
      , "int",  -1
      , "str",  sString
      , "int",  nSize
      , "Uint", 0
      , "Uint", 0)
}

;-------------------------------------------------
; HTML encode/decode
;------------------------------------------------

UriEncode(str)
{ ; v 0.3 / (w) 24.06.2008 by derRaphael / zLib-Style release
   b_Format := A_FormatInteger
   data := ""
   SetFormat,Integer,H
   Loop,Parse,str
      if ((Asc(A_LoopField)>0x7f) || (Asc(A_LoopField)<0x30) || (asc(A_LoopField)=0x3d))
         data .= "%" . ((StrLen(c:=SubStr(ASC(A_LoopField),3))<2) ? "0" . c : c)
      Else
         data .= A_LoopField
   SetFormat,Integer,%b_format%
   return data
}

UriDecode(str)
{ ; v 0.1 / (w) 28.06.2008 by derRaphael / zLib-Style release
   Loop,Parse,str,`%
      txt := (A_Index=1) ? A_LoopField : txt chr("0x" substr(A_LoopField,1,2)) SubStr(A_LoopField,3)
   return txt
}

UnHTM( HTM ) { ; Remove HTML formatting / Convert to ordinary text     by SKAN 19-Nov-2009
 Static HT     ; Forum Topic: www.autohotkey.com/forum/topic51342.html
 IfEqual,HT,,   SetEnv,HT, % "&aacutea&acirca&acute?&aelig?&agravea&amp&aringa&atildea&au"
 . "mla&bdquo„&brvbar¦&bull•&ccedilc&cedil?&cent?&circ?&copy©&curren¤&dagger†&dagger‡&deg"
 . "°&divide?&eacutee&ecirce&egravee&eth?&eumle&euro€&fnof?&frac12?&frac14?&frac34?&gt>&h"
 . "ellip…&iacutei&icirci&iexcl?&igravei&iquest?&iumli&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr?&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntilden&oacuteo&ocirco&oelig?&ograveo&or"
 . "df?&ordm?&oslasho&otildeo&oumlo&para¶&permil‰&plusmn±&pound?&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scarons&sect§&shy&sup1?&sup2?&sup3?&szlig?&thorn?&tilde?&tim"
 . "es?&trade™&uacuteu&ucircu&ugraveu&uml?&uumlu&yacutey&yen?&yumly"
 TXT := RegExReplace( HTM,"<[^>]+>" )               ; Remove all tags between  "<" and ">"
 Loop, Parse, TXT, &`;                              ; Create a list of special characters
   L := "&" A_LoopField ";", R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , `;                                ; Parse Special Characters
  If F := InStr( HT, A_LoopField )                  ; Lookup HT Data
    StringReplace, TXT,TXT, %A_LoopField%`;, % SubStr( HT,F+StrLen(A_LoopField), 1 ), All
  Else If ( SubStr( A_LoopField,2,1)="#" )
    StringReplace, TXT, TXT, %A_LoopField%`;, % Chr(SubStr(A_LoopField,3)), All
Return RegExReplace( TXT, "(^\s*|\s*$)")            ; Remove leading/trailing white spaces
}

UnSlashUnicode(s)
{
;~   ; unslash unicode sequences like \u0026
  ; by Mikhail Kuropyatnikov 2009 (micdelt@mail.ru)
   rx = \\u([0-9a-fA-F]{4})
   pos = 0

   loop
   {
   pos := RegExMatch(s,rx,m,pos+1)
   if (pos = 0)
      break
   StringReplace, s, s, %m%, % Chr("0x" . SubStr(m,3,4))
   }
   
   return s
}
return
Exit:
; IniWrite, %to%, Data/GoogleTranslateIni.ini, General, LanguageTo
; IniWrite, %anti%, Data/GoogleTranslateIni.ini, General, LanguageAnti
ExitApp

LanguageList: 
; At the bottom of script due to lengthy data
LanguageList = Afrikaans|Albanian|Amharic|Arabic|Armenian|Azerbaijani|Basque|Belarusian|Bengali|Bihari|Bork|Bosnian|Breton|Bulgarian|Cambodian|Catalan|ChineseSimplified|ChineseTraditional|Corsican|Croatian|Czech|Danish|Dutch|ElmerFudd|English|Esperanto|Estonian|Faroese|Filipino|Finnish|French|Frisian|Galician|Georgian|German|Greek|Guarani|Gujarati|Hackker|Hausa|Hebrew|Hindi|Hungarian|Icelandic|Indonesian|Interlingua|Irish|Italian|Japanese|Javanese|Kannada|Kazakh|Kinyarwanda|Kirundi|Klingon|Korean|Kurdish|Kyrgyz|Laothian|Latin|Latvian|Lingala|Lithuanian|Macedonian|Malagasy|Malay|Malayalam|Maltese|Maori|Marathi|Moldavian|Mongolian|Montenegrin|Nepali|Norwegian|NorwegianNynorsk|Occitan|Oriya|Oromo|Pashto|Persian|Pirate|Polish|PortugeseBR|PortugesePT|Punjabi|Quechua|Romanian|Romansh|Russian|ScotsGaelic|Serbian|SerboCroatian|Sesotho|Shona|Sindhi|Sinhalese|Slovak|Slovenian|Somali|Spanish|Sudanese|Swahili|Swedish|Tajik|Tamil|Tatar|Telugu|Thai|Tigrinya|Tonga|Turkish|Turkmen|Twi|Uighur|Ukrainian|Urdu|Uzbek|Vietnamese|Welsh|Xhosa|Yiddish|Yoruba|Zulu

CodeList = af|sq|am|ar|hy|az|eu|be|bn|bh|xx-bork|bs|br|bg|km|ca|zh-CN|zh-TW|co|hr|cs|da|nl|xx-elmer|en|eo|et|fo|tl|fi|fr|fy|gl|ka|de|el|gn|gu|xx-hacker|ha|iw|hi|hu|is|id|ia|ga|it|ja|jw|kn|kk|rw|rn|xx-klingon|ko|ku|ky|lo|la|lv|ln|lt|mk|mg|ms|ml|mt|mi|mr|mo|mn|sr-ME|ne|no|nn|oc|or|om|ps|fa|xx-pirate|pl|pt-BR|pt-PT|pa|qu|ro|rm|ru|gd|sr|sh|st|sn|sd|si|sk|sl|so|es|su|sw|sv|tg|ta|tt|te|th|ti|to|tr|tk|tw|ug|uk|ur|uz|vi|cy|xh|yi|yo|zu
Loop, parse, LanguageList, |
{
	Language%A_Index% := A_LoopField
    %A_LoopField% := "Language"A_Index
}
Loop, parse, CodeList, |
{
	Code%A_Index% := A_LoopField
}

/* If YOU ever need to list all the languages, try this
Loop, 50
{
   ShowLanguage := Language%A_Index%
   ShowCode := Code%A_Index%
   Gui, Add, Text, x10, %ShowLanguage%
   Gui, Add, Text, yp x200, %ShowCode%
}
Gui, Show
*/
return