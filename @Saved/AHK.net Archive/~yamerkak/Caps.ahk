menu, tray, icon, caps.ico

Capslock:: ; a,j,s,1,2,v,c,e,q,m,f,i (insert to previous tag),r,b (g,d,w)
SetCapsLockState,OFF
SplashTextOn,,,ON prevtag=%tag%,
WinMove,ON,,1070,725
input, var,l1, {pgdn}{enter}{appskey}
SplashTextoff

if IsLabel(var)
{
 SplashTextOff
;SplashTextOn,,,%var%,splash
;WinMove,%var%,,1070,725
Gosub, %var%
}
Return

j:
Run journal.ahk
return
m:
Run viewmain.ahk
Return
u:
clipboard =
Send, ^c
sleep, 500
url=%clipboard%
InputBox, title,title, ,,,140
clipboard=<a href="%url%" target="_blank" class="mO" rel="nofollow">%title%</a> 
return


a:      ;Append to file
Run ajournal.ahk
return

s:           ; SEARCH    
input, var,, {pgdn}{enter},s,g,y,d,j,w,a,c
clipboard =
Send, ^c
sleep, 500
word=%clipboard%
var= %var%1
if IsLabel(var)
Gosub, %var%
Return
g1:
run http://www.google.com/search?q=%clipboard%
Return
d1:
run http://www.thefreedictionary.com/%clipboard%
FileAppend, %clipboard% `n, words.txt
Return
y1:
Run http://www.youtube.com/results?search_query=%clipboard%
Return
a1:
Run http://www.amazon.com/s/ref=nb_ss?url=search-alias=aps&field-keywords=%clipboard%
Return
w1:
Run http://en.wikipedia.org/wiki/%word%
Return
s1:
run http://www.merriam-webster.com/spanish/%clipboard%
return
c1:
run http://www.worldcat.org/search?qt=worldcat_org_bks&q=%word%
return
u1:
Run %clipboard%
return

c:       ;Clipboard append to file

sleep, 500
clipboard=
Send, ^c
clipwait

Run ajournal.ahk "c"
Return

 g:
InputBox, word,google, ,,,140
if ErrorLevel
 WinClose, google
 else if (word="")
WinClose, 
else
run http://www.google.com/search?q=%word%
return

i: ;quick copy paste to file w/o dialog
sleep, 500
clipboard=
Send, ^c
clipwait
FileAppend, %clipboard% `n, %tag%.txt
return


b: ;quick view
run %tag%.txt
return


d:
InputBox, word,Dictionary, ,,,140
if ErrorLevel
 WinClose, Dictionary
 else if (word="")
WinClose, 
else
{
Run http://en.wiktionary.org/wiki/%word%#English
FileAppend, %word% `n, words.txt
}
return
w:
InputBox, word,Wikipedia, ,,,140
if ErrorLevel
 WinClose, Wikipedia
else if (word="")
WinClose, Wikipedia
else
{
Run http://en.wikipedia.org/wiki/%word%
FileAppend, %word% `n, searchlist\wlist.txt
}
return

1:
clipboard=
sleep, 500
Send, ^c
clipwait
Fileappend, %clipboard% `n, w_%clipboard%.txt
dicword=%clipboard%
return
2:
clipboard=
Send, ^c
clipwait
Fileappend, %clipboard% `n, w_%dicword%.txt
fileread, ovar, w_%dicword%.txt
msgbox,,%dicword%, %ovar%,3
return
3:
clipboard=
sleep, 500
Send, ^c
clipwait
 Fileappend,%clipboard%, anki.txt
 Fileappend,;, anki.txt
 return
 4:
clipboard=
Send, ^c
clipwait
Fileappend, %clipboard% `n, anki.txt
return


v: 
Run guinotes.ahk

return


 e:
 inputbox,var,Edit,,,,,,,,,%tag%
StringSplit, oa, var, %A_Space%
if(var=="]")
{                                               ;searchlist journals
inputbox, var2,Edit in searchlist
run searchlist\%var2%.txt

}
if(var=="" or ErrorLevel)
{                                               ;
Return
}
else Run %oa1%.txt
return

f:
inputbox, var, Run filename
Run %var%
Return

#Include inputboxsearch.ahk


return