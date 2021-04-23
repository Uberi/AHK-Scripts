;
; AutoHotkey Version: 1.x
; Language:       English/Deutsch
; Platform:       WinXP
; Author:         haichen <haihai001@hotmail.com>
;


about=
(
Zbox und Dropbox
----------------
Das Programm Dropbox synchronisiert Dateien und Ordner über das Internet. Dabei werden diese einfach in einen lokalen Ordner namens Dropbox abgelegt
und dann über den Anbieter mit weiteren Dropboxen des eigenen Accounts synchronisiert. Die Inhalte werden verschlüsselt übertragen und beim Anbieter verschlüsselt gespeichert.
Dropbox bietet dabei neben der Wiederherstellung älterer Versionen auch den Dropbox unabhängigen Download
an. 2 GB Festplattenplatz sind dabei ohne Kosten.

Die Verschlüsselung der Daten liegt allerding vollständig beim Anbieter. Um eine Nutzerabhängige Verschlüsselung zu gewährleisten gibt es die Möglichkeit 
einen Truecryptcontainer zu nutzen.

mit Zbox biete ich eine andere Möglichkeit:

Ein Ordner wird auf Änderungen überwacht. Werden dort Dateien gelöscht, geändert oder hinzugefügt wird der Ordnerinhalt zu einer 7z- oder rar-Datei verschlüsselt
und in die Dropbox kopiert. Nach der Synchronisation wird der Inhalt automatisch in den dortige zBoxordner extrahiert.
Die Anwendung der Zbox ist daher wie bei der Dropbox. Der Schlüssel liegt allerdings beim Nutzer.

Vergleich:
Ordner DropBox -> verschlüsselt übertragen -> Internetserver schlüssel -> verschlüsselt übertragen -> andere Dropbox
Ordner zBox  -> selbstverschlüsseltes 7z oder rar Archiv -> eigene DropBox -> wie oben -> remote DropBox -> automatisches entpacken nach zBox

Die Nutzung
-----------
Voraussetzung: Dropbox muss installiert sein. Im Order der die eigene Drobox enthält Zbox kopieren.
Das Programm wie folgt umbenennen und auf die zu synchronisierenden Rechner verteilen:
Namederzuüberwachendenzbox_PCname.exe
1. Rechner  zB.   -> zBox1_home.exe 
2. Rechner        -> zBox1_work.exe

Damit ist das Programm funktionsfähig. Ein eigenes Passwort für die 7z-Datei kann man über das Traymenü erzeugen.
Dieses muß dann natürlich auf beiden Rechnern identisch sein.
Rar ist über commandline zu nutzen  zB. zBox1_home.exe -r (natürlich auf beiden Seiten)
Alternativ kann es im code fest eingestellt werden (line 115). Rar.exe muß wie 7z.exe im Verzeichnis stehen, 
oder über die PATH-Variable eingebunden werden.

Probleme
--------
Eine Garantie kann nicht übernommen werden.
Dies ist ein reines Hobbyprogramm.
Jegliche Nutzung geschieht auf eigene Gefahr.

Links
-------------
ZBox_MyPC.exe erstellt mit
Autohokey
www.autohotkey.com/

Dropbox
www.getdropbox.com/
http://stadt-bremerhaven.de/dropbox-und-truecrypt-verschluesselte-daten-in-der-cloud/
http://stadt-bremerhaven.de/portable-dropbox-fuer-windows-32bit/

oder Dropbox portable (nutze ich) bitte obige Anleitung lesen.
http://forums.getdropbox.com/topic.php?id=7729&replies=6

7zip
www.7-zip.org/
benötigt wird die Datei 7z.exe (Commandline)
entweder im zBox-Verzeichnis oder durch Anpassung der PATH Variablen zugänglich.
7-Zip is licensed under the GNU LGPL license

die Datei rehash.exe
http://rehash.sourceforge.net/

kblackbox.png
http://www.icon-king.com/projects/nuvola/
The Nuvola icons are licensed under the LGPL


---------------
vielen Dank an 
---------------
Caschy      - http://stadt-bremerhaven.de/

Chris       - für Autohotkey

hochentwickelte Funktionen von - highly advanced functions from:
HotKeyIt
majkinetor
Sean
Titan

--------
Author
--------

haichen

--------
)


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent                    ;skript wird nicht autom. beendet

;Command Line Parameter
If 1 = -r
  Dateityp = .rar
Else
  Dateityp = .7z



;Dateityp=.rar  ;wenn nur RAR verwendet werden soll Semikolon vor Dateityp entfernen

; Bitte ändern; beide Passwörter müssen auf unterschiedlichen rechnern identisch sein
Password=bratwurst

;KeyPassword wird im Keyfile neugesetzt bzw gelesen und kann über ein Menü geändert werden
KeyPassword=AutoHotkey
;Das Passwort für die Verschlüsselung ist zusammengesetzt aus Password und dem im Keyfile gespeichertem KeyPassword.
sPassword = %KeyPassword%%Password%


dropboxfolder=dropbox    ;wenn der Dropboxordner keine Ordner Public und photos enthält wird er mit finddropboxfolder nicht gefunden
Gosub,finddropboxfolder  ;dann das Gosub kommentieren und darüber den korrekten Ordner angeben.
;msgBox, % dropboxfolder
if(dropboxfolder="")
{
  MsgBox,  keine Dropbox gefunden - do not find a Dropbox
  ExitApp
}

Menu, tray, add, Zbox
Menu, tray, NoStandard ,
Menu, tray, add
Menu, tray, add, open Zbox Folder,openzBoxDir
Menu, tray, Default, open Zbox Folder
Menu, tray, add, open Dropbox Folder,openDropboxDir
Menu, tray, add, Make a keyfile,  makeaKey
Menu, tray, add, Quit,  Exit

OnExit,Exit                    ;wichtig damit beim Beenden des Progs auch die Überwachung des Ordners beendet wird.

Gosub dateinamen
Gosub readKey

IfNotExist  %boxname%
{
  FileInstall, rehash.exe, rehash.exe, 0  ;rehash.exe wird in das Programmverzeichnis entpackt
  If (dateityp = ".7z")
    FileInstall, 7z.exe, 7z.exe, 0
  Else If (dateityp = ".rar")
    FileInstall, rar.exe, rar.exe, 0

  FileCreateDir, %boxname%
}
SetTimer,WatchFolder,100            ;
Return

openzBoxDir:
  Run, explore %boxname%
Return

openDropboxDir:
  Run, explore %DropBoxfolder%
Return

finddropboxfolder:
  dropboxfolder=
  Loop ,%A_ScriptDir%\*.* ,2 ,1
  {
    IfExist,  my dropbox\photos
      IfExist,  my dropbox\public
      {
        DropBoxfolder= my dropbox
        Return
      }

    IfExist,  dropbox\photos
      IfExist,  dropbox\public
      {
        DropBoxfolder= dropbox
        Return
      }

    If  (A_LoopFileName =  "photos")
      IfExist,  %A_LoopFileDir%\public
      {
        DropBoxfolder= %A_LoopFileDir%
        Return
      }
  }
Return

Zbox:
  Gui, 2:+Resize +MinSize
  Gui, 2:Add, Edit, vabout ReadOnly x10 y10 w480 h200 ,
  Gui, 2:Add, Button, vokb Default, OK
  Gui, 2:Show,, ZBox
  GuiControl,2:, about,  %about%
Return

2GuiSize:
  Anchor("about", "w h")
  Anchor("okb", "y")
Return



readKey:
  IfExist %boxname%_key.txt
  {
    KeyPassword=
    FileRead,KeyPassword, %boxname%_key.txt
  }
  sPassword = %KeyPassword%%Password%
Return



makeaKey:
  Gui, Submit, NoHide
  text1=
  (
Erstellt eine Passwortdatei. Die synchronisierenden Rechner müssen das gleiche Passwort haben. 
Die Datei kann auf den zweiten PC kopiert werden.
  )

  text2=
  (
Makes a keyfile. Both PCs must have the same pwd. The file can be copied to the second PC.
  )

  Gui, 3:+Resize +MinSize
  Gui, 3:Add, Text,vt1, %text1%
  Gui, 3:Add, Text,vt2,  %text2%

  Gui, 3:Add, Edit,vPassword1  x10 y90 w480  r3,
  Gui, 3:Add, Button,vokb2 Default, OK
  Gui, 3:Show,x800 y200 , ZBox - make a keyfile
Return

3GuiSize:
  Anchor("Password1", "w h")
  Anchor("okb2", "y")
Return



2ButtonOK:
2GuiClose:
2GuiEscape:
  Gui Destroy
Return


3ButtonOK:
  Gui, Submit, NoHide
  FileDelete,%boxname%_key.txt
  Sleep, 1000
  FileAppend,%Password1%,%boxname%_key.txt
  Gosub,readKey 
  Filedelete, %a_scriptdir%\%boxname%%Dateityp%
3GuiClose:
3GuiEscape:
  Gui Destroy
Return

dateinamen:
  IfNotInString, a_scriptname ,_
  {
    MsgBox,  Bitte Namen zB. zBox_MyPCatHome.exe; bitte nur ein "_" - Please change Name to something like zBox_MyPCatWork.exe;  only one "_" please
    ExitApp
  }

  StringReplace, boxname_pcname, a_scriptname, `.ahk           ;der skriptname wird in der Variablen  boxname_pcname ohne .ahk gespeichert sbox_pc1.ahk -> sbox_pc1

  StringReplace, boxname_pcname, boxname_pcname, `.exe           ;dasselbe für kompilierte Skripte
  StringSplit, teilname, boxname_pcname , _                    ;sbox_pc1 -> sbox in der Var boxname  "pc1" -> pcname
  boxname:=teilname1
  pcname:=teilname2
  Mysyncindikator=sync_%boxname_pcname%.txt                     ;textdatei die anzeigt das eine 7z datei in der Dropbox abgelegt oder aktualisiert wurde. Enthät den Hash derselben

Return


WatchFolder:
  WatchDirectory(boxname,1)       ;beobachtet den Ordner boxname zB. sbox auf ÄndeRungen
  Gosub findSyncIndikator
  if( WatchDirectory("RegisterChanges")<>""  )  ;wenn ÄndeRungen dann Gosub ..
  Gosub encryptAndSync
Return

findSyncIndikator:
  ;suche nach ubdate-Benachrichtigungen eines anderen Rechners
  FileList =
  Loop %dropboxfolder%\sync_%boxname%_*.txt
    If  (A_LoopFileName <> Mysyncindikator)
      FileList = %FileList%%A_LoopFileName%`n
  Gosub,  decrypt
Return

decrypt:
  Loop, Parse, FileList, `n
  {
    MD5=
    md5test=
    StringReplace, decrypttobox, A_LoopField, `.txt     ;sync_%boxname_pcname%.txt   zB. sync_sbox_pc2.txt
    StringReplace, decrypttobox, decrypttobox, sync_    ;sbox_pc2
    StringSplit, decrypttobox, decrypttobox , _         ;decrypttobox1="sbox" decrypttobox2="pc2"
    FileRead,MD5, %dropboxfolder%\%A_loopfield%
    ;<sbox.7z>
    ;MD5          : F01E22F1 23766DFC 1875D69C F2FF224D

    hashtest=rehash.exe -none -md5 "%dropboxfolder%\%decrypttobox1%%Dateityp%"
    MD5test := Run(hashtest)
    If (md5test = md5)
    {
      If (dateityp = ".7z")
        extract=  7z x -y -p%sPassword% "%dropboxfolder%\%decrypttobox1%%Dateityp%"  -o"%decrypttobox1%""
      Else If (dateityp = ".rar")
        extract=  RAR x -y -hp%sPassword% "%dropboxfolder%\%decrypttobox1%.rar" "%decrypttobox1%\"
      FileDelete %dropboxfolder%\%A_LoopField%
      IfExist %decrypttobox1%
        FileDelete,  %decrypttobox1%\*.*
      sOutput := Run(extract)
      WatchDirectory()
      WatchDirectory(boxname,1)
    }
  }
Return


encryptAndSync:
  FileDelete,  %dropboxfolder%\%Mysyncindikator%
  ; ---- sbox.7z   die Modifikationszeit soll sich nicht ändern damit Dropbox nur die Änderungen überträgt.

  ; zip=RAR u -u -as -r -ep1 -os -h%Password% -m5 -tk %boxname% %boxname%\*.*
  ; rem u Update
  ; rem -u Dateien erneuern
  ; rem -as synchronisation (loeschen in rar)
  ; rem -r subdir
  ; rem -ep1 ohne Stammverzeichnis
  ; rem -hpPASSWORT Datei kann auch nicht mehr eingesehen werden
  ; rem -m0 ... -m5 Kompression
  ; rem -os ntfs streams werden auch gespeichert
  ; rem -tk Zeitstempel wird nicht geaendert!
  ; rem -y alles bestätigen

  ;zip= 7z u -mx3 -t7z -r -up1q0r2x1y2z1w2 -p%Password% -mhe %boxname%.7z .\%boxname%\*
  ;  7z Commandline 7z.exe
  ;  u Update
  ;  -mx3 Kompressionsrate
  ;  -t7z Kompressionsverfahren (7z)
  ;  -r Subdirs
  ;  -p Passwort
  ;  -mhe Dateien sind nicht sichtbar
  ;  -u updateswitch p1q0r2x1y2z1w2 Synchronisation -nicht vorhandene Dateien werden aus dem 7z gelöscht!
  ;  .\name\* alle Daeien AUS dem Verzeichnis. Das Verzeichnis selber bleibt draussen.
  ;

  If (dateityp = ".7z")
    zip= 7z u -mx3 -t7z -r -up1q0r2x1y2z1w2 -p%sPassword% -mhe "%boxname%.7z" .\"%boxname%"\*
  Else If (dateityp = ".rar")
    zip=RAR u -u -as -r -ep1 -os -hp%sPassword% -m5 -tk "%boxname%" "%boxname%"\*.*
; msgbox,%sPassword%
  sOutput := Run(zip)    ; Commandline ohne Dosfenster

  FileSetTime, 20090227120000, %boxname%%Dateityp% ,m      ; das Modifikationsdatum  wird zurückgesetzt
  FileSetTime, 20090227120000, %boxname%%Dateityp% ,c
  FileSetTime, 20090227120000, %boxname%%Dateityp% ,a

  FileCopy, %a_scriptdir%\%boxname%%Dateityp%, %dropboxfolder%,1           ;ab in die Dropbox
  MD5box=
  hashtest=rehash.exe -none -md5 %dropboxfolder%\%boxname%%Dateityp%
  ; Da sich in der Dropbox weder Name noch Datum der 7z Datei ändern, muß der MD5 Hash eine frische Datei kennzeichnen.
  MD5box := Run(hashtest)

  ;Der hash wird in der Datei  sync_%boxname_pcname%.txt zB sync_sbox_pc1.txt (..pc2.txt) gespeichert und separat in die dropbox kopiert.

  IfNotExist, %dropboxfolder%\%Mysyncindikator%
    FileAppend, %MD5box%, %dropboxfolder%\%Mysyncindikator%
Return

RegisterChanges(action,folder,file){
    static
    ;  if ((action<>"")or (folder<>"") or (file<>"")   )
    ;    WatchDirectory()
  }

Exit:
  WatchDirectory()
  ExitApp





  ; von HotKeyIt
  ;http://www.autohotkey.com/forum/viewtopic.php?t=45237
  ;Function WatchDirectory()
  ;
  ;Parameters
  ;      WatchFolder         - Specify a valid path to watch for changes in.
  ;                     - can be directory or drive (e.g. c:\ or c:\Temp)
  ;                     - can be network path e.g. \\192.168.2.101\Shared)
  ;                     - can include last backslash. e.g. C:\Temp\ (will be reported same form)
  ;
  ;      WatchSubDirs      - Specify whether to search in subfolders
  ;
  ;StopWatching   -   THIS SHOULD BE DONE BEFORE EXITING SCRIPT AT LEAST (OnExit)
  ;      Call WatchDirectory() without parameters to stop watching all directories
  ;
  ;ReportChanges
  ;      Call WatchDirectory("ReportingFunctionName") to process registered changes.
  ;      Syntax of ReportingFunctionName(Action,Folder,File)
  ;
  ;      Example
/*
#Persistent
OnExit,Exit
WatchDirectory("C:\Windows",1)
SetTimer,WatchFolder,100
Return
WatchFolder:
WatchDirectory("RegisterChanges")
Return
RegisterChanges(action,folder,file){
static
#1:="New File", #2:="Deleted", #3:="Modified", #4:="Renamed From", #5:="Renamed To"
ToolTip % #%Action% "`n" folder . (SubStr(folder,0)="\" ? "" : "\") . file
}
Exit:
WatchDirectory()
ExitApp
*/

  WatchDirectory(WatchFolder="", WatchSubDirs=true)
  {
    static
    local hDir, hEvent, r, Action, FileNameLen, pFileName, Restart, CurrentFolder, PointerFNI, _SizeOf_FNI_=65536
    nReadLen := 0
    If !(WatchFolder){
      Gosub, StopWatchingDirectories
    } Else If IsFunc(WatchFolder) {
      r := DllCall("MsgWaitForMultipleObjectsEx", UInt, DirIdx, UInt, &DirEvents, UInt, -1, UInt, 0x4FF, UInt, 0x6) ;Timeout=-1
      If !(r >= 0 && r < DirIdx)
        Return
      r += 1
      CurrentFolder := Dir%r%Path
      PointerFNI := &Dir%r%FNI
      DllCall( "GetOverlappedResult", UInt, hDir, UInt, &Dir%r%Overlapped, UIntP, nReadLen, Int, true )
      Loop {
        pNext      := NumGet( PointerFNI + 0  )
        Action      := NumGet( PointerFNI + 4  )
        FileNameLen := NumGet( PointerFNI + 8  )
        pFileName :=       ( PointerFNI + 12 )
        If (Action < 0x6){
          VarSetCapacity( FileNameANSI, FileNameLen )
          DllCall( "WideCharToMultiByte",UInt,0,UInt,0,UInt,pFileName,UInt,FileNameLen,Str,FileNameANSI,UInt,FileNameLen,UInt,0,UInt,0)
          %WatchFolder%(Action,CurrentFolder,SubStr( FileNameANSI, 1, FileNameLen/2 ))
        }
        If (!pNext or pNext = 4129024)
          Break
        Else
          PointerFNI := (PointerFNI + pNext)
      }
      DllCall( "ResetEvent", UInt,NumGet( Dir%r%Overlapped, 16 ) )
      Gosub, ReadDirectoryChanges
      Return r
    } Else {
      Loop % (DirIdx) {
        If InStr(WatchFolder, Dir%A_Index%Path){
          If (Dir%A_Index%Subdirs)
            Return
        } Else If InStr(Dir%A_Index%Path, WatchFolder) {
          If (WatchSubDirs){
            DllCall( "CloseHandle", UInt,Dir%A_Index% )
            DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
            Restart := DirIdx, DirIdx := A_Index
          }
        }
      }
      If !Restart
        DirIdx += 1
      r:=DirIdx
      hDir := DllCall( "CreateFile"
              , Str  , WatchFolder
              , UInt , ( FILE_LIST_DIRECTORY := 0x1 )
              , UInt , ( FILE_SHARE_READ     := 0x1 )
      | ( FILE_SHARE_WRITE    := 0x2 )
      | ( FILE_SHARE_Delete   := 0x4 )
              , UInt , 0
              , UInt , ( OPEN_EXISTING := 0x3 )
              , UInt , ( FILE_FLAG_BACKUP_SEMANTICS := 0x2000000  )
      | ( FILE_FLAG_OVERLAPPED       := 0x40000000 )
              , UInt , 0 )
      Dir%r%         := hDir
      Dir%r%Path     := WatchFolder
      Dir%r%Subdirs  := WatchSubDirs
      VarSetCapacity( Dir%r%FNI, _SizeOf_FNI_ )
      VarSetCapacity( Dir%r%Overlapped, 20, 0 )
      DllCall( "CloseHandle", UInt,hEvent )
      hEvent := DllCall( "CreateEvent", UInt,0, Int,true, Int,false, UInt,0 )
      NumPut( hEvent, Dir%r%Overlapped, 16 )
      If ( VarSetCapacity(DirEvents) < DirIdx*4 and VarSetCapacity(DirEvents, DirIdx*4 + 60))
        Loop %DirIdx%
        {
          If (SubStr(Dir%A_Index%Path,1,1)!="-"){
            action++
            NumPut( NumGet( Dir%action%Overlapped, 16 ), DirEvents, action*4-4 )
          }
        }
      NumPut( hEvent, DirEvents, DirIdx*4-4)
      Gosub, ReadDirectoryChanges
      If Restart
        DirIdx = %Restart%
    }
    Return
StopWatchingDirectories:
  Loop % (DirIdx) {
    DllCall( "CloseHandle", UInt,Dir%A_Index% )
    DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
    Dir%A_Index%=
    Dir%A_Index%Path=
    Dir%A_Index%Subdirs=
    Dir%A_Index%FNI=
    DllCall( "CloseHandle", UInt, NumGet(Dir%A_Index%Overlapped,16) )
    VarSetCapacity(Dir%A_Index%Overlapped,0)
  }
  DirIdx=
  VarSetCapacity(DirEvents,0)
Return
ReadDirectoryChanges:
  DllCall( "ReadDirectoryChangesW"
          , UInt , Dir%r%
          , UInt , &Dir%r%FNI
          , UInt , _SizeOf_FNI_
          , UInt , Dir%r%SubDirs
          , UInt , ( FILE_NOTIFY_CHANGE_FILE_NAME   := 0x1   )
  | ( FILE_NOTIFY_CHANGE_DIR_NAME    := 0x2   )
  | ( FILE_NOTIFY_CHANGE_ATTRIBUTES  := 0x4   )
  | ( FILE_NOTIFY_CHANGE_SIZE        := 0x8   )
  | ( FILE_NOTIFY_CHANGE_LAST_WRITE  := 0x10  )
  | ( FILE_NOTIFY_CHANGE_CREATION    := 0x40  )
  | ( FILE_NOTIFY_CHANGE_SECURITY    := 0x100 )
          , UInt , 0
          , UInt , &Dir%r%Overlapped
          , UInt , 0  )
Return
}



/*
von majkinetor
http://www.autohotkey.com/forum/viewtopic.php?p=279720#279720

Function: Run
Retreive and be notified about output from the console programs.

Parameters:
Cmd		 - Command to execute.
Stream	 - If set to TRUE it'll create a console window and display output line-by-line, in addition to returning the result as a whole.
If string, name of the notification function to be called as output updates. The function accepts 1 argument.
Dir		 - Working Directory, optional.
Input	 - Program input (stdin).
ExitCode - Program exit code.

Examples:
(start code)
sOutput := Run("ping.exe localhost")							 ;just grab the output
sOutput := Run("ping.exe localhost", "OnOutput")				 ;with notification function
sOutput := Run("cmd.exe /c dir /a /o", "", A_WinDir)			 ;with working dir
sOutput := Run("sort.exe", "", "", "abc`r`nefg`r`nhijk`r`n0123") ;with argument
sOutput := Run("sort.exe 123", "", "", "", ExitCode)			 ;with ExitCode, in this case returns 1 as 123 is not found.

OnOutput(s){
OutputDebug %s%
}
(end code)

About:
o v1.0
o Developed by Sean. Modified and documented by majkinetor.
o Licenced under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>
*/
Run(Cmd, Stream = "", Dir = "", Input = "", ByRef ExitCode="")
  {
    DllCall("CreatePipe", "UintP", hStdInRd , "UintP", hStdInWr , "Uint", 0, "Uint", 0)
    DllCall("CreatePipe", "UintP", hStdOutRd, "UintP", hStdOutWr, "Uint", 0, "Uint", 0)
    DllCall("SetHandleInformation", "Uint", hStdInRd , "Uint", 1, "Uint", 1)
    DllCall("SetHandleInformation", "Uint", hStdOutWr, "Uint", 1, "Uint", 1)
    VarSetCapacity(pi, 16, 0)
    NumPut(VarSetCapacity(si, 68, 0), si)	; size of si
    NumPut(0x100	, si, 44)		; STARTF_USESTDHANDLES
    NumPut(hStdInRd	, si, 56)		; hStdInput
    NumPut(hStdOutWr, si, 60)		; hStdOutput
    NumPut(hStdOutWr, si, 64)		; hStdError
    If !DllCall("CreateProcess", "Uint", 0, "Uint", &Cmd, "Uint", 0, "Uint", 0, "int", True, "Uint", 0x08000000, "Uint", 0, "Uint", Dir ? &Dir : 0, "Uint", &si, "Uint", &pi)	; bInheritHandles and CREATE_NO_WINDOW
      Return A_ThisFunc "> Can't create Process:`n" Cmd

    hProcess := NumGet(pi,0)
    DllCall("CloseHandle", "Uint", NumGet(pi,4)),  DllCall("CloseHandle", "Uint", hStdOutWr),  DllCall("CloseHandle", "Uint", hStdInRd)

    If Input !=
      DllCall("WriteFile", "Uint", hStdInWr, "Uint", &Input, "Uint", StrLen(Input), "UintP", nSize, "Uint", 0)

    DllCall("CloseHandle", "Uint", hStdInWr)
    Stream+0 ? (bAlloc:=DllCall("AllocConsole"),hCon:=DllCall("CreateFile","str","CON","Uint",0x40000000,"Uint",bAlloc ? 0 : 3,"Uint",0,"Uint",3,"Uint",0,"Uint",0)) : ""
    VarSetCapacity(sTemp, nTemp:=Stream ? 64-nTrim:=1 : 4095)
    Loop
      If	DllCall("ReadFile", "Uint", hStdOutRd, "Uint", &sTemp, "Uint", nTemp, "UintP", nSize:=0, "Uint", 0) && nSize
      {
        NumPut(0,sTemp,nSize,"Uchar"), VarSetCapacity(sTemp,-1), sOutput.=sTemp
        If	Stream
          Loop
            If	RegExMatch(sOutput, "S)[^\n]*\n", sTrim, nTrim)
              Stream+0 ? DllCall("WriteFile", "Uint", hCon, "Uint", &sTrim, "Uint", StrLen(sTrim), "UintP", 0, "Uint", 0) : %Stream%(sTrim), nTrim+=StrLen(sTrim)
            Else	Break
      }
      Else	Break
    DllCall("CloseHandle", "Uint", hStdOutRd)
    Stream+0 ? (DllCall("Sleep","Uint",1000),hCon+1 ? DllCall("CloseHandle","Uint",hCon) : "",bAlloc ? DllCall("FreeConsole") : "") : ""
    DllCall("GetExitCodeProcess", "uint", hProcess, "UintP", ExitCode, "int")
    DllCall("CloseHandle", "Uint", hProcess)
    Return	sOutput
  }



/*
von Titan
http://www.autohotkey.com/forum/topic4348.html
http://www.autohotkey.net/~Titan/#anchor
http://www.autohotkey.com/forum/viewtopic.php?t=36756

Function: Anchor
Defines how controls should be automatically positioned relative to the new dimensions of a GUI when resized.

Parameters:
cl - a control HWND, associated variable name or ClassNN to operate on
a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
optionally followed by a relative factor, e.g. "x h0.5"
r - (optional) true to redraw controls, recommended for GroupBox and Button types

Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height

Remarks:
Anchor must always be called within a GuiSize label where AutoHotkey assigns a real value to A_Gui.
The only exception is when the second and third parameters are omitted to reset the stored positions for a control.
For a complete example see anchor-example.ahk.

License:
- Version 4.56 by Titan <http://www.autohotkey.net/~Titan/#anchor>
- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

*/

Anchor(i, a = "", r = false) {
    static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
    If z = 0
      VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
    If a =
    {
      StringLeft, gn, i, 2
      If gn Contains :
      {
        StringTrimRight, gn, gn, 1
        t = 2
      }
      StringTrimLeft, i, i, t ? t : 3
      If gn is not Digit
        gn := gx
    }
    Else gn := A_Gui
    If i is not Xdigit
    {
      GuiControlGet, t, Hwnd, %i%
      If ErrorLevel = 0
        i := t
      Else ControlGet, i, Hwnd, , %i%
    }
    gb := (gn - 1) * gs
    Loop, %cx%
      If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
        If a =
        {
          cf = 1
          Break
        }
        Else gx := A_Gui
        d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
                , dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
                , dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
        Loop, Parse, a, xywh
          If A_Index > 1
            av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
                  , d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
        DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
        If r != 0
          DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
        Return
      }
    If cf != 1
      cb := cl, cl += cs
    If (!NumGet(g, gb)) {
      Gui, %gn%:+LastFound
      WinGetPos, , , , gh
      VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
              , NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
              , NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
    }
    Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
    ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
    If cf = 1
    {
      Gui, %gn%:+LastFound
      WinGetPos, , , gw, gh
      d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
    }
    NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
            , NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
    Return, true
  }
