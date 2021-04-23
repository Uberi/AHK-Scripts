; AutoHotkey Version: 1.x
; Language:       English/Português
; Platform:       Win9x/NT
; Author:         Leo
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Process, Priority, , High

; ######################################################################################
; CHANGELOG
; ######################################################################################

; 22/2/08 às 13:06 - add hk pra gastos do ceub em win+alt+g.
; 21/2/08 às 18:11 - add hs pra down em donw.
; 20/2/08 às 23:45 - mudada hk de selection to google pra win+ctrl+alt+c e bb em ctrl+alt+b.
; 20/2/08 às 15:01 - niftywindows incoroporada com modificações.
; 20/2/08 às 6:25 - add hk pra epstemplate, nvu e prefixo dos eps em rwin+t
; 19/2/08 às 18:54 - add hs pra ...nar em ...arn.
; 19/2/08 às 18:49 - add parte do script para redimensionar com alt+rbutton. removido às 21:10.
; 19/2/08 às 18:30 - add Rctrl+F11 para hs de sair (sign out) da conta do google em português.
; 19/2/08 às 18:11 - mudada hk de data atual simples para ]a.
; 19/2/08 às 13:59 - add hs pra url do tutorial de upload de eps em []2.
; 18/2/08 às 18:56 - mudada hk de salvar e recarregar pra rctrl+numpadenter.
; 16/2/08 às 23:44 - add hk pra OODefrag = win+Ctrl+F1
; 16/2/08 às 15:34 - add hs pra música em musica.
; 15/2/08 às 16:10 - add hs pra pode em poed e preço em preco e dizem.
; 15/2/08 às 15:33 - atualizada função da hk de episódios diários.
; 15/2/08 às 4:13 - mudada hk de restaurar itens selecionados da lixeira para RShift+BS.
; 14/2/08 às 18:28 - add hk pra hovermixplus em win+alt+h
; 14/2/08 às 18:25 - add hs' pra ...ário e área.
; 14/2/08 às 3:10 - add hk pra ad-aware em win+ctrl+F6 e mudada de cws pra win+ctrl+F3.
; 14/2/08 às 1:57 - add hs' para alguns pronomes, vá, freqüência e derivados e nessa em nesa.
; 14/2/08 às 0:56 - add hs' pra já, tá e lá.
; 14/2/08 às 0:18 - add hs pra SANCC.
; 13/2/08 às 23:38 - add hs pra alguém,  ...ável ...endo em enod, então, ...gênio, hein, idéia, mente, série e sério.
; 13/2/08 às 16:42 - add hs pra galera em glr e começo.
; 13/2/08 às 1:42 - add hs' pra é e né.
; 13/2/08 às 1:38 - add hs' pra quanto e quem.
; 13/2/08 às 1:25 - add hk pra notepad++ em Rwin+N
; 13/2/08 às 1:20 - add hs' pra aconteça e preguiça (e derivados).
; 13/2/08 às 0:56 - add hs' para atende e porra.
; 12/2/08 às 2:38 - add hs pra ícone.
; 12/2/08 às 2:02 - add hk pra seek em alt+shift+s.
; 12/2/08 às 1:47 - add hs pra data atual simples sem espaços em ]h.
; 12/2/08 às 1:11 - add hs pra conteúdo e script em scritp, pouco depois add algumas para pergunta.f
; 12/2/08 às 1:05 - add hs pra Firefox em ff.
; 11/2/08 às 20:09 - add hs pra agora em agoar.
; 11/2/08 às 19:40 - add hs pra espaço, café, página e além.
; 11/2/08 às 18:43 - add hs pra história em historia.
; 10/2/08 às 20:39 - add hs para sign out do gmail em ingles em RCtrl+F12.
; 10/2/08 às 6:12 - add hs pra também em tb.
; 10/2/08 às 5:57 - add hs para house em hosue.
; 10/2/08 às 4:58 - add hk para selection to google em win+alt+c (Firefox apenas)
; 10/2/08 às 4:40 - removida info de dopus.
; 10/2/08 às 4:08 - add algumas hs' pra search. 
; 10/2/08 às 1:38 - add ks pra você em vc.
; 9/2/08 às 21:56 - mudada hk de BB pra Win+Ctrl+Alt+B
; 9/2/08 às 18:28 - adicionado porquês.
; 9/2/08 às 18:14 - incorporado script de drag2 (do showcase padrão).
; 30/1/08 às 23:57 - add hs pra selecionar critérios de busca para ltv em win+down.
; 30/1/08 às 23:52 - add numpadenter para salvar e recarregar este script.
; 30/1/08 às 22:39 - add hk renomear, copiar/colar, enter em ctrl+alt+z e x respectivamente.
; 30/1/08 às 22:02 - add hs para depois em deopis.
; 30/1/08 às 12:50 - add hs pra -ções em coes e hora em hroa.
; 30/1/08 às 3:26 - adicionada hk pra subir pra este changelog e ainda pôr a data em win+ctrl+up!
; 30/1/08 às 3:22 - mudada hk de copia e cola rapida de win+alt+c pra ctrl+àlt+c.
; 30/1/08 às 2:30 - adicionado comando para ir para hs' em ctrl+alt+pgdn, lembrar de atualizar.
; 29/1/08 às 21:34 - adicionada hs pra mensagem em msg e cadê em kd.
; 29/1/08 às 16:51 - add hs pra que em q e o que em oq.
; 29/1/08 às 16:29 - adicionada hs pra qualquer em qq.
; 28/1/08 às 21:24 - adicionada hs pra episódios de hoje em epss.
; 28/1/08 às 19:17 - adicionada hs pra pra você em poce e adicionada em adicioanda.
; 28/1/08 às 18:36 - adicionada hk pra xaveco em win+ctrl+shift+x
; 28/1/08 às 18:09 - adicionada hs pra pera em epra e será em sera.
; 28/1/08 às 17:22 - adicionada hk simples pra bb em win+b.
; 27/1/08 às 23:11 - adicioada hs pra gente em getne e como em ocmo.
; 27/1/08 às 22:30 - adicioanda hs pra muito em mutio.
; 27/1/08 às 22:14 - adicionada hs pra quando em qdo.
; 27/1/08 às 19:40 - fedorenta pendendo implementação
; 27/1/08 às 4:17 - removido firefox bb code.
; 27/1/08 às 2:35 - removida hs para você.
; 27/1/08 às 2:31 - adicionado comando para organizar icones na dt por data = win+space
; 27/1/08 às 1:40 - adicionada hs pra mas em ams.
; 27/1/08 às 0:06 - velho atalho do bb mudado pra adobe bridge.
; 26/1/08 às 22:59 - adicionadas hs para c = você e donde = de onde.
; 26/1/08 às 22:51 - adicionada hs pessaos para pessoas e para melhor em melhro.
; 26/1/08 às 22:46 - adicionada hs pra hoje em hj.
; 26/1/08 às 21:33 - mudada hk do coelho para -.
; 26/1/08 às 21:31 - mudada hk de copia/cola rápida para rctrl+l.
; 26/1/08 às 14:36 - adicinada win+ctrl+9 pra colete.
; 25/1/08 às 14:17 - adicionada hs prb pra problema.
; 24/1/08 às 23:28 - adicionada hs para não na letra ene.
; 24/1/08 às 18:14 - adicioanda hk rwin+ç pra dopus.
; 24/1/08 às 18:07 - adicionada hs ctz pra certeza.
; 24/1/08 às 15:41 - adicionada hs para procurar <h1>Tonight Shows</h1> na fonte do sa.
; 24/1/08 às 12:51 - mudada hk de clicar anexos no gmail para win+´.
; 24/1/08 às 12:50 - mudada hk de autoscriptwriter para win+ctrl+]
; 24/1/08 às 12:50 - mudada hk para ejetar drives para apeanas win+]ou[
; 24/1/08 às 10:32 - adicionada win+ctrl+i pra imgburn.
; 24/1/08 às 10:15 - adicionado nvu f&r e atalho pra nvu = win+alt+n
; 22/1/08 às 14:59 - Adicionada Rwin+Rshift+R pra ROR soundtrack.
; 21/1/08 às 8:50 - Adicionada RCtrl+PS pra screenshot rapida para irfanview.
; 21/1/08 às 2:48 - adicionado win+ctrl+alt+shift+f pra fake falacioso.
; 20/1/08 às 12:48 - adicionada win+alt+k pra sam2 do samurize.
; 20/1/08 às 9:35 - Adicionada hs para http://www.darossa.frih.net
; 19/1/08 às 3:08 - adicionada macro de fake profile sem porn.
; 18/1/08 às 4:48 - Remover area de busca no FF = Ctrl+Mouse4=xbutton1
; 18/1/08 às 4:18 - BBcode for Firefox
; 18/1/08 às 1:36 - Adicionados *'s nas hots do blog, link principal agora é -*-.
; 17/1/08 às 9:01 - implementado comando para mover janelas nas 8 direcoes com ctrl+numpad.
; 17/1/08 às 6:00 - melhorada hs [[s para este changelog.
; 17/1/08 às 5:53 - atalho para RoR = RWin+RCtrl+R
; 17/1/08 às 5:52 - Changelog implementado, tudo que tem abaixo disso tá na ordem inversa.
; WIN+ALT+F11 Cola as configs do sistema	terça-feira, 15 de janeiro de 2008	11:33:19
; www.olavodecarvalho.org em ::olavo2::	quarta-feira, 16 de janeiro de 2008	00:52:57
; Filezilla autoconnect & select = mudado down 4 pra down 5	quarta-feira, 16 de janeiro de 2008	07:42:05
; intellisense movido pra area em desuso	quarta-feira, 16 de janeiro de 2008	07:44
; hs para blog do rosseiro em [] 	quarta-feira, 16 de janeiro de 2008	08:51:30
; Thanks for this! ;0 :) em win+shift+ç	quarta-feira, 16 de janeiro de 2008	23:29:56
; hs para MSN em []m	quinta-feira, 17 de janeiro de 2008	00:08:48
; ajuda do ahk em RCtrl+Pgdn	quinta-feira, 17 de janeiro de 2008	02:25:48
; temporário de renomear dezenas em numpad5, em desuso	quinta-feira, 17 de janeiro de 2008	03:07:20
; Converter clipboard para capitalização como em prosa em CTRL+ALT+C	quinta-feira, 17 de janeiro de 2008	03:26:22
; Clicar anexos no gmail em Win+[	quinta-feira, 17 de janeiro de 2008	04:48:12
; copiar texto seleciondo e colar na 2a janela em alt+c	quinta-feira, 17 de janeiro de 2008	05:20:14


; ######################################################################################
; TECLAS DE ATALHO DE PROGRAMAS
; ######################################################################################

; ACROBAT
; Win+Shift+8
#+8::Run E:\Adobe\Acrobat 8.0\Acrobat\Acrobat.exe

; AD-AWARE
; Win+Ctrl+F6
#^F6::Run C:\Arquivos de programas\Scanners\Ad-Aware 2007\Ad-Aware2007.exe

; APPRENTICE
; Win+G
#g::Run E:\Apprentice\Appr.exe

; AUDITION
; Win+Ctrl+J
#^j::Run E:\Adobe\Audition 1.5\Audition.exe

; AUTOSCRIPT WRITER (RECORDER)
; Win+Ctrl+]
#^]:: Run C:\Arquivos de programas\AutoHotkey\AutoScriptWriter\AutoScriptWriter.exe

; BLOCO DE NOTAS
; Win+\
#\:: Run C:\Windows\Notepad.exe

; BRIDGE
; Win+Ctrl+Shift+B
#^+b::Run E:\Adobe\Adobe Bridge CS3\Bridge.exe

; BSPLAYER
; Win+Ctrl+B
#^b::Run C:\Arquivos de Programas\Video Tools\BSPlayerPro\bsplayer.exe

; CCLEANER
; Win+Ctrl+F8
#^F8::Run C:\Arquivos de programas\Scanners\CCleaner\ccleaner.exe

; CMD
; Win+Alt+P
#!p::Run C:\WINDOWS\system32\cmd.exe

; COREL 10
; Win+Shift+0
#+0::RUN E:\Corel 10\Programs\coreldrw.exe 

; CORELX3
; Win+Shift+6
#+6::RUN F:\Appz\5 Outros\Aplicativos-Arte\CorelDraw X3 with SP2 Thinstalled\CorelDRW.exe

; CWS SHREDDER
; Win+Ctrl+F3
#^F3:: Run F:\Appz\2 Segurança\cwshredder.exe

; DAEMON TOOLS
; Win+Alt+D
#!d::Run C:\Arquivos de programas\DAEMON Tools\daemon.exe

; DREAMWEAVER CS3
; Win+Shift+D
#+d::Run E:\Adobe\Adobe Dreamweaver CS3\Dreamweaver.exe "D:\site\rossa_root\episodios.html"

; EVEREST
; Win+Ctrl+E
#^e::RUN F:\Appz\2 Segurança\EVEREST Ultimate Edition\everest.exe

; EXCEL
; Win+Shift+2
#+2::Run E:\Microsoft Office\Office12\EXCEL.EXE

; BATCH FILENAME EDITOR
; Win+Shift+F
#+f::Run C:\Program Files\Batch FileName Editor\Nameditor.exe

; FILEZILLA
; Win+Ctrl+M
#^m::Run C:\Arquivos de programas\FileZilla\filezilla.exe

; FIREFOX
; Win+A
#a::Run C:\Arquivos de Programas\Mozilla Firefox\Firefox.exe

; FIREWORKS 8
; Win+Shift+}
#+}::Run E:\Fireworks 8\Fireworks.exe

; FLASH
; Win+Shift+5
#+5::Run E:\Adobe\Adobe Flash CS3\Flash.exe 

; FONTVIEWER
; Win+Ctrl+F
#^f::Run F:\Appz\4 Utilitários\FontViewer\FontViewer.exe

; GRAVADOR DE SOM
; Win+Ctrl+5
#^5::Run C:\WINDOWS\system32\sndrec32.exe

; HIJACKTHIS!
; Win+Ctrl+F5
#^F5:: Run F:\Appz\2 Segurança\HiJackThis_v2.exe

; IMGBURN
; Win+Ctrl+I
#^i::Run C:\Arquivos de programas\ImgBurn\ImgBurn.exe

; INTERNET EXPLORER
; Win+Shift+Z
#+z::Run C:\Arquivos de programas\Internet Explorer\iexplore.exe

; ILLUSTRATOR
; Win+Shift+9
#+9::Run E:\Adobe\Adobe Illustrator CS3\Support Files\Contents\Windows\Illustrator.exe

; INKSAVER
; Win+I
#i::Run C:\Arquivos de programas\InkSaver\InkSaver.exe

; IRFANVIEW
; Win+V
#v::Run C:\Arquivos de programas\IrfanView\i_view32.exe

; LIMEWIRE
; Win+W
#w::Run C:\Arquivos de programas\LimeWire\LimeWire.exe

; MAPLE
; Win+Shift+M
#+m::Run E:\Maple 11\bin.win\maplew.exe

; MEDIA PLAYER CLASSIC
; Win+Ctrl+C
#^c::Run C:\Arquivos de programas\Video Tools\mplayerc.exe

; MESSENGER DETECT
; Win+Numpad6
#Numpad6::Run C:\Arquivos de programas\Messenger Detect\MessengerDetect.exe

; MIRC
; Win+6
#6::Run C:\Arquivos de Programas\mIRC\mirc.exe

; MOZBACK
; Win+Alt+B
#!b::Run F:\Appz\4 Utilitários\MozBackup 1.4.4\Backup.exe

; MSN MESSENGER
; Win+Numpad4
#Numpad4::Run C:\Arquivos de programas\MSN Messenger\msnmsgr.exe

; MVREGCLEAN
; Win+Ctrl+F11
#^F11::Run C:\Arquivos de programas\Scanners\MV RegClean 5.5\MVREGCLEAN.EXE

; NERO START SMART
; Win+Ctrl+N
#^n::Run C:\Arquivos de programas\Nero 6\Nero StartSmart\NeroStartSmart.exe

; NOTEPAD++
; RWin+N
>#n::Run C:\Arquivos de programas\Notepad++\notepad++.exe "D:\Docs\AHK\scripts\script.ahk"

; NVU
; Win+Alt+N
#!n::Run F:\Appz\4 Utilitários\nvu-1.0\nvu.exe "D:\site\rossa_root\episodios.html"

; ONE NOTE
; Win+Shift+4
#+4::Run E:\Microsoft Office\Office12\ONENOTE.EXE

; OODEFRAG
; Win+Ctrl+F1
#^F1::Run C:\Arquivos de programas\Scanners\OO Defrag Professional\oodcnt.exe

; OUTLOOK
; Win+2
#2::Run E:\Microsoft Office\Office12\OUTLOOK.EXE

; PAINT
; Win+Shift+V
#+v::Run C:\WINDOWS\system32\mspaint.exe

; PHOTOSHOP
; Win+P
#p::Run F:\Appz\5 Outros\Aplicativos-Arte\Adobe Portable\Portable Photoshop 8 CS\Portable_PS_8.exe

; PHOTOSHOP CS3
; Win+Shift+'
#+'::Run E:\Adobe\Adobe Photoshop CS3\Photoshop.exe

; PICASA
; Win+Ctrl+P
#^p::Run C:\Arquivos de programas\Picasa2\Picasa2.exe

; PIXIE
; Win+Alt+Shift+P
#!+p::Run C:\Arquivos de programas\Pixie\pixie.exe

; POWER CALC
; Win+Shift+Q
#+q::Run F:\Appz\4 Utilitários\PowerCalc.exe

; POWER POINT
; Win+Shift+3
#+3::Run E:\Microsoft Office\Office12\POWERPNT.EXE

; PREMIERE PRO
; Win+Shift+7
#+7::Run E:\Adobe\Premiere Pro 1.5\Adobe Premiere Pro.exe

; REGISTRY FIX
; Win+Ctrl+F10
#^F10::Run C:\Arquivos de programas\Scanners\RegistryFix\RegistryFix.exe

; RK LAUNCHER
; Win+Shift+L
#+l::Run F:\Appz\1 Os Primeiros\RK_Launcher_04_Beta\RKLauncher.exe

; ROR
; RWin+RCtrl+R
>#>^r::Run C:\Documents and Settings\All Users\Menu Iniciar\Programas\Jogos\Rise of Rome.lnk

; SAMURIZE 1
; Win+Shift+K
#+k::Run C:\Arquivos de programas\Samurize\Client.exe "C:\Arquivos de programas\Samurize\Configs\sam1.ini"

; SAMURIZE 2
; Win+Alt+K
#!k::Run C:\Arquivos de programas\Samurize\Client.exe "C:\Arquivos de programas\Samurize\Configs\sam2.ini"

; SEEK
; Alt+Shift+S
!+s::run D:\Docs\AHK\scripts\seek.ahk

; SKYPE
; RWin+Shift+S
>#+s::Run C:\Arquivos de programas\Skype\Phone\Skype.exe

; SPYBOT
; Win+Ctrl+F9
#^F9::Run C:\Arquivos de programas\Scanners\Spybot\SpybotSD.exe

; STEAM
; Win+Ctrl+S
#^s::Run E:\Steam\Steam.exe -applaunch 10

; TEXTPAD
; Win+S
#s::Run C:\Arquivos de programas\TextPad 5\TextPad.exe

; UNIT CONVERSION TOOL
; Win+Ctrl+U
#^u::Run F:\Appz\4 Utilitários\Unit Conversion Tool v5.1 Portable\UniCon.exe

; UTORRENT
; Win+T
#t::Run C:\Arquivos de programas\uTorrent\uTorrent.exe

; VALVE HAMMER EDITOR
; Win+H
#h::Run C:\Arquivos de programas\Half-Life Tool Pack\Applications\Valve Hammer Editor\hammer.exe

; WALLY
; Win+Shift+W
#+w::Run C:\Arquivos de programas\Half-Life Tool Pack\Applications\Wally\Wally.exe

; WINAMP
; Win+1
#1::run C:\Arquivos de programas\Winamp\winamp.exe "C:\Documents and Settings\New user\Desktop\lista13-11-7.m3u"

; WINDOWS MEDIA PLAYER
; Win+Ctrl+1
#^1::Run C:\Arquivos de programas\Windows Media Player\wmplayer.exe

; WORD
; Win+Shift+1
#+1::Run E:\Microsoft Office\Office12\WINWORD.EXE

; WORLD COMMUNITY GRID
; Win+Ctrl+Alt+X
#^!x::Run C:\Arquivos de programas\WorldCommunityGrid\UD.EXE

; XP-ANTISPY
; Win+Ctrl+F4
#^F4:: Run F:\Appz\2 Segurança\xp-AntiSpy.exe

; XPlORER²
; Win+Z
#z::run C:\Arquivos de programas\xplorer2\xplorer2_UC.exe

; YOUR! UNINSTALLER
; Win+Shift+R
#+r::Run C:\Arquivos de programas\Your Uninstaller 2008\uruninstaller.exe

































; ######################################################################################
; CONFIGURAÇÕES DO SISTEMA
; ######################################################################################

; CPU-Z
; RWin+RCtrl+Z
>#>^z::Run F:\Appz\4 Utilitários\CPU-Z\cpuz.exe

; GERENCIADOR DE TAREFAS
; Win+Q
#q::Run C:\WINDOWS\system32\taskmgr.exe

; INFORMAÇÕES DO SISTEMA
; Win+F10
#F10::Run C:\Arquivos de programas\Arquivos comuns\Microsoft Shared\MSInfo\msinfo32.exe

; LIXEIRA
; Win+BS
#bs:: Run "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{645FF040-5081-101B-9F08-00AA002F954E}"

; MOUSE
; Win+N
#n::Run C:\WINDOWS\system32\main.cpl

; MSCONFIG
; Win+F8
#F8::Run C:\WINDOWS\pchealth\helpctr\binaries\msconfig.exe

; PAINEL DE CONTROLE
; Win+C
#c:: Run C:\Documents and Settings\All Users\Menu Iniciar\Programas\Atalhos 2\Painel de Controle.lnk

;PROPRIEDADES DO COMPUTADOR
; Win+F11
#F11::Run C:\Documents and Settings\All Users\Menu Iniciar\Programas\Atalhos 2\Propriedades do Computador.cpl

; REGEDIT
; Win+F7
#F7::Run C:\WINDOWS\regedit.exe

; SERVICES
; Win+F9
#F9::Run C:\WINDOWS\system32\services.msc

; SOM
; Win+5
#5::Run C:\WINDOWS\system32\mmsys.cpl

; TWEAK UI
; Win+F5
#F5:: Run C:\WINDOWS\system32\tweakui.exe

; VÍDEO
; Win+Ctrl+V
#^v::Run C:\WINDOWS\system32\desk.cpl






























; ######################################################################################
; DOCUMENTOS E OUTROS ARQUIVOS
; ######################################################################################

; ABRIR ESTE PRÓPRIO TEXTO (verifique o diretório onde o script está.)
; RWin+Ins
>#Ins::Run F:\Appz\4 Utilitários\notepad++ 4.7.5\notepad++.exe "D:\Docs\AHK\scripts\Script.ahk"

; AOE SCRIPT
; Win+Ctrl+Shift+A
#^+a::
Run D:\Docs\AHK\aoe.ahk
ExitApp

; AUTOHOTKEY HELP FILE
; RCtrl+PgDn
>^PgDn::Run C:\Arquivos de programas\AutoHotkey\AutoHotkey.chm

; EPSTEMPLATE, NVU E PREFIXO DOS EPS.AHK
; RWin+T
>#t:: 
run C:\Arquivos de programas\Notepad++\notepad++.exe "D:\site\epstemplate3.txt" "D:\Docs\AHK\scripts\prefixodoseps2.ahk"
run D:\Docs\AHK\scripts\prefixodoseps2.ahk
run F:\Appz\4 Utilitários\nvu-1.0\nvu.exe
return

; GASTOS DO CEUB
; Win+Alt+G
#!g::run D:\Docs\Listas\Gastos-CEUB.xlsx

; LISTA DAS MANUTENÇÕES
; Win+X
#x::Run D:\Docs\Listas\Lista das Manutenções.xlsx

; HOVER MIX PLUS
; Win+Alt+H
#!h::Run D:\Docs\AHK\scripts\hovermixplus.ahk

; MANUAL DE ERROS DO HAMMER.html
; Win+Ctrl+H
#^h::Run D:\Docs\Coisas do CS\mapping\Tutoriais\Manual de Erros.pdf

; ROR SOUNDTRACK
; Rwin+RShift+R
>#>+R:: Run F:\Appz\6 Patches e Joguinhos\AoE e RoR\Coisas de AoE e RoR\Age of Empires Rise Of Rome OST\RoR Soundtrack.m3u

; SÉRIES
; Win+Alt+S
#!s::Run D:\Séries\Series.xlsx

; TOG
; Win+Ctrl+Alt+P
#^!p:: Run C:\Arquivos de programas\TextPad 5\TextPad.exe "D:\Docs\Backups\Psicatogue.dec"



































; ######################################################################################
; MACROS DE TECLADO
; ######################################################################################

; BB
;  Ctrl+Alt+B
^!b::send 31291129992

; BOLD
; Win+Shift+B
#+b:: send [b][/b]{space}{left 5}

; CODE
; Win+Shift+C
#+c:: send [code][/code]{space}{left 8}


; FAKE PROFILE COM PORN
; Win+Ctrl+Shift+F
#^+f::send Fake profile, mass-scrap spammer, porn-oriented. Please do something to block their multi-message scripts.{tab}{enter}

; FAKE PROFILE COM PORN E FALÁCIA
; Win+Ctrl+Alt+Shift+F
#^!+f::send Fake profile, mass-scrap spammer, porn-oriented. This kind is using a new 'technique' to lure the men they send mass scraps: they act like they knew the person, with sweet messages of love, peace, etc so the 'victim' becomes curious to see their fake profile. In there, we see the links for porn sites. Please do something to block their multi-message scripts.{tab}{enter}

; FAKE PROFILE SEM PORN
; Win+Alt+Shift+F
#!+f::send Fake profile, mass-scrap spammer. Please do something to block their multi-message scripts.{tab}{enter}

; FTP_SYNC NO NPP (1152)
; Win+Alt+F
#!f::send 
!p{down}{right}{enter}
Sleep, 2000
MouseClick, left,  901,  118
Sleep, 46
MouseClick, left,  915,  132
Sleep, 46
return

; ITALIC
; Win+Shift+I
#+i:: send [i][/i]{space}{left 5}

; MULLIGAN
; Win+Ctrl+\
#^\::
send !a
Sleep, 30
send h{enter}
Sleep, 30
send !ag
Sleep, 30
send {enter}
Sleep, 30
send !a{up}
Sleep, 30
send {right}{enter}
Sleep, 30
send {ctrldown}s{ctrlup}
Sleep, 30
send {ctrldown}l{ctrlup}
Sleep, 30
send 20{enter}
Sleep, 30
send {ctrldown}{d 7}{ctrlup}
return

; OBRIGADO
; Win+Shift+O
#+o:: send Valeu pelo trabalho, equipe+1{tab}{space}{tab 2}{space}

; QUOTE
; Win+Ctrl+Shift+Q
#^+q:: send [quote][/quote]{space}{left 9}

; THANKS
; Win+Shift+T
#+t:: 
Sleep, 20
send Thanks for sharing uploader
Sleep, 20
Send {shiftdown}1{shiftup} :){tab}{space}
return

; THANKS 2
; Win+Shift+Ç
#+ç::
Sleep, 20
send Thanks for this!
Sleep, 20
Send {shiftdown}1{shiftup} :){space}:){tab}{space}
return

; UNDERLINE
; Win+Shift+U
#+u:: send [u][/u]{left 4}

; UPDATE TRACKER
; Win+Ctrl+Shift+U
#^+u::send {ctrldown}a{ctrlup}{appskey}k

; VIRTUA 
; Win+Ctrl+Shift+V
#^+v::send 0016b54a9786{tab 2}{down 2}{tab}{down 2}{tab}{enter}

; XAVECO
; Win+Ctrl+Shift+X
#^+x::send xavecoredshot@yahoo.com.br




































; ######################################################################################
; HOTSTRINGS
; ######################################################################################

; ACONTEÇA
:*:aconteca::aconteça

; ADICIONADA
:*:adicioanda::adicionada

; ADICIONADO
:*:adicioando::adicionado

; AGORA
::agoar::agora

; ALÉM
:*:alem::além

; ALGUÉM
:*:alguem::alguém

; ÃO
::ao::ao
:?:aõ::ão
:?:ao::ão

; ÁREA
::area::área

; ...ÁRIO
:*?:ario::ário


; AS FAR AS I KNOW
:*:afaik::As far as I know

; AS YOU CAN SEE
:*:aucs::As you can see
 
; ATENDE
:*:atnede::atende
:*:atnedn::atende
:*:atedne::atende
:*:atened::atende

; ...ÁVEL
:*?:avel::ável

; BLOG
::rosss::http://rosseiro.blogspot.com

; BY THE WAY
::btw::by the way

; CADÊ
::kd::cadê

; CAFÉ
::cafe::café

; CERTEZA
:*:ctz::certeza

; COMEÇAR (e derivados)
:*:comeco::começo
:*:comeca::começa

; COMENTÁRIOS EM SÉRIE
:*:cesss::http://www.comentariosemserie.com

; COMO
:*:ocmo::como

; CONHEÇO
:*:conheco::conheço

; CONTEÚDO
::conteudo::conteúdo

; ÇÃO
:*?:cao::ção

; ÇÕES
:*?:coes::ções

; DA ROSSA.frih.net
:*:drih::http://www.darossa.frih.net

; DATA ATUAL
:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,,LongDate  ; Vai ficar tipo: Sábado, 29 de dezembro de 2007 às 23:05
SendInput %CurrentDateTime%
send {space}às{space}
FormatTime, CurrentDateTime,,HH:mm 
SendInput %CurrentDateTime%
return

; DATA ATUAL BY GARRY
:*:]t::   
FormatTime, CurrentDateTime,, d/M/yy H:mm ; It will look like 9/1/2005 23:53
stringsplit,BX,Currentdatetime,%A_space%        ; divide the string at space, in this case divide in 2 parts (index)
SendInput %BX1%{Tab}%BX2%                       ; send index1 TAB index2
Return

; DATA ATUAL SIMPLES
:*:]a::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,,d/M/yy  ; Vai ficar tipo: 29/12/07 às 23:05
SendInput %CurrentDateTime%
send {space}às{space}
FormatTime, CurrentDateTime,,H:mm 
SendInput %CurrentDateTime%
return

; DATA ATUAL PARA PÔR NO EXCEL
:*:[d::  ; Esta hotstring substitui "[d" pela data e hora atuais de acordo com os comandos abaixo.
FormatTime, CurrentDate,, LongDate ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDate%
SendInput, {Tab}
FormatTime, CurrentTime,, H:mm:ss  ; Vai ficar na forma 5-4-07 às 14:57:01
SendInput %CurrentTime%
return

; DATA ATUAL SIMPLES PARA NOMES DE ARQUIVO
:*:]s::  ; Esta hotstring substitui "]s" pela data e hora atuais na forma 5-4-07 às 14.57 de acordo com os comandos abaixo.
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
return

; DATA ATUAL SIMPLES PARA NOMES DE ARQUIVO SEM ESPAÇOS
:*:]h::  ; Esta hotstring substitui "]h" pela data e hora atuais na forma 5-4-07__14-57 de acordo com os comandos abaixo.
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, __
FormatTime, CurrentTime,, HH-mm  ; <-- esta é a hora.
SendInput %CurrentTime%
return

; DE ONDE
:*:donde::de onde

; DEIXA
:*:diexa::deixa

; DEPOIS
:*:deopis::depois

; DIRECT ADMIN
:*:dadmin::http://216.32.85.170:2222/

; DIZEM
:*:dimze::dizem
:*:dizme::dizem

; DOWN
:*?:donw::down

; É
::eh::é

; EDIT
:*:]e::[b]Edit:[/b]{space}

; EMAIL
:*:]/::darossa@gmail.com

; ...ENDO
:*?:enod::endo

; ENTÃO
:*:etnao::então

; EPISÓDIOS DE HOJE
:*:epss::http://www.darossa.frih.net/episodios.html

; ESPAÇO
:*:espaco::espaço

; FIREFOX
::ff::Firefox

; FREQÜÊNCIA (e derivados)
:*:frq::freqüência
:*?:frequ::freqü

; GALERA
:*:glr::galera

; ...GÊNIO
:*?:genio::gênio

; GENTE
::genet::gente
:*:getne::gente

; HEIN
:*:hien::hein

; HISTÓRIA
:*:historia::história

; HOJE
:*:hj::hoje

; HORA
:*:hroa::hora

; HOUSE
:?*:hosue::house

; ÍCONE
::icone::ícone

; IDÉIA
:*:ideia::idéia

; ...ÍVEL
:*?:ivel::ível

; JÁ
::ja::já

; LÁ
::la::lá

; LEO
:*:lgcp::Leonardo Gomes do Carmo Pereira

; MAS
:*:ams::mas

; MELHOR
:*:melhro::melhor
:*:mlehor::melhor

; MENSAGEM
::msg::mensagem
:*:msgs::mensagens

; ...MENTE
:*?:metne::mente
:*?:menet::mente
:*?:mnete::mente

; MSN
:*:[]m::darossa@brturbo.com

; MUITO
:*:mutio::muito

; MUITO 2
:*:mto::muito

; MÚSICA
:*:musica::música

; ...NAR
:?:arn::nar

; NÃO
::n::não
:*:naõ::não
:*:n.:: não.

; NÉ
:*:neh::né

; NESSA
::nesa::nessa

; NUMB3RS
:*:nm::Numb3rs

; OLAVO DE CARVALHO
:*:olavao::http://blogtalkradio.com/olavo

; OLAVO DE CARVALHO 2
:*:olavo2::www.olavodecarvalho.org

; O QUE
::oq::o que

; ORKUT (MEU PROFILE)
:*:lorkut::http://www.orkut.com/Profile.aspx?uid=12796900234143758630

; PÁGINA(S)
:*:pagina::página

; PERA
:*:epra::pera

; PERGUNTA
:*:pergutna::pergunta
:*:pregunta::pergunta
:*:pergunat::pergunta

; PESSOAS
:*:pessaos::pessoas

; PODE
:*:poed::pode

; POR QUÊ
:*:pq?::por quê?

; POR QUE
:*:pqq::por que

; PORQUE
::pq::porque

; PORQUÊ
:*:p^q::porquê

; PORRA
::porar::porra

; PRA VOCÊ
::poce::pra você

; PREÇO
::preco::preço

; PREGUIÇA e derivados
:*:preguic::preguiç

; PROBLEMA
:*:prb::problema

; PRONOMES (ALGUNS)
:*?:a-la::á-la
:*?:i-la::í-la
:*?:a-lo::á-lo
:*?:i-lo::í-lo

; QUALQUER
::qq::qualquer

; QUANDO
:*:qdo::quando

; QUANTO
:*:qto::quanto

; QUE
::q::que

; QUEM
::qm::quem

; SANCC
:*:sanccc::Somos Amigos, Não Confunda as Coisas

; SCRIPT
:*:scritp::script

; SEARCH
:*:serach::search
:*:sreach::search
:*:seacrh::search
:*:saerch::search

; SERÁ
::sera::será

; SÉRIE e SÉRIO
:*:serio::sério
:*:serie::série

; SPOILER
:*:sopielr::spoiler
:*:spioler::spoiler

; TÁ
::ta::tá

; TAMBÉM
::tb::também
:*:tambem::também

; TONIGHT'S SHOWS, PROCURAR NA FONTE DO SA
; RWin+O
>#o::
send ^f
Sleep, 7
sendraw width=220>Description</td>
return

; Vá
::va::vá

; VOCÊ
::vc::você


























; ######################################################################################
; HOTSTRINGS DO BLOG DO ROSSEIRO
; ######################################################################################

; LINK PRINCIPAL
:*:-*-::http://rosseiro.blogspot.com
; TUTORIAL DE UPLOAD DE EPISÓDIOS
:*:[]2::http://rosseiro.blogspot.com/2007/01/tutorial-para-upload-de-episdios-em.html
; ANATOMIA
:*:[]3::http://rosseiro.blogspot.com/2007/01/anatomia-de-um-release-de-episdio-de-tv.html
; ASSINTINDO
:*:[]5::http://rosseiro.blogspot.com/2007/01/tutorial-para-assistir-episdios-de.html
; CULTIVANDO
:*:[]6::http://rosseiro.blogspot.com/2007/01/tutorial-para-cultivar-o-ratio-em.html
; 24
:*:[]7::http://rosseiro.blogspot.com/2007/01/tutorial-para-obteno-de-episdios-de-24.html
; MANEIRAS
:*:[]8::http://rosseiro.blogspot.com/2007/01/outras-maneiras-de-se-obter-episdios-de.html
; OUTROS TIPOS
:*:[]9::http://rosseiro.blogspot.com/2007/02/outros-tipos-de-releases-de-episdios-de.html
; GLOSSÁRIO
:*:[]10::http://rosseiro.blogspot.com/2007/03/glossrio-de-termos-associados.html
; ASSUNTOS DIVERSOS
:*:[]11::http://rosseiro.blogspot.com/2007/02/assuntos-diversos_4919.html

























; ######################################################################################
; OUTRAS AÇÕES
; ######################################################################################


; ABRIR ESTE PRÓPRIO TEXTO (verifique o diretório onde o script está.)
; RCtrl+Ins
>^Ins::Run C:\Arquivos de programas\TextPad 5\TextPad.exe "D:\Docs\AHK\scripts\script.ahk"



; ABRIR TODOS OS TRACKERS
; Win+Ctrl+Alt+T
#^!t::
MouseClick, right,  680,  99
Sleep, 100
MouseClick, left,  713,  112
Sleep, 100
return

; APPRENTICE DECK
; Win+Ctrl+K
#^k::
send !c
Sleep, 100
send +terrenos
Sleep, 100
send {enter}
Sleep, 100
send !c
Sleep, 100
send +criaturas
Sleep, 100
send {enter}
Sleep, 100
send !c
Sleep, 100
send +m´agicas
Sleep, 100
send {enter}
Sleep, 100
send !c
Sleep, 100
send +side{enter}
Sleep, 100
return

; CAIXA NOVA
; velha = ; #^+c:: send 0674{tab}1780038
; Win+Ctrl+Shift+C
#^+c::
MouseClick, left,  386,  311
Sleep, 20
send k11e5i9t19h8{tab}{space}{tab}{down 2}{enter}
Sleep, 250
MouseClick, left,  537,  434
Sleep, 2500
MouseClick, left,  425,  326
Sleep, 100
return
#^!b::send 31291129992

; CLICAR ANEXOS DO GMAIL, 1152x864, Firefox com BTF, 2 tabs na parte superior, sendo uma do Gmail
; Win+´
#´::
WinWait, Gmail - Compose Mail - animantaimgs@gmail.com - Mozilla Firefox, 
IfWinNotActive, Gmail - Compose Mail - animantaimgs@gmail.com - Mozilla Firefox, , WinActivate, Gmail - Compose Mail - animantaimgs@gmail.com - Mozilla Firefox, 
WinWaitActive, Gmail - Compose Mail - animantaimgs@gmail.com - Mozilla Firefox, 
MouseClick, left,  295,  391
Sleep, 100
MouseClick, left,  295,  426
Sleep, 100
MouseClick, left,  295,  447
Sleep, 100
MouseClick, left,  291,  468
Sleep, 100
MouseClick, left,  294,  489
Sleep, 100
MouseClick, left,  301,  514
Sleep, 100
MouseClick, left,  302,  528
Sleep, 100
MouseClick, left,  298,  552
Sleep, 100
MouseClick, left,  298,  577
Sleep, 100
MouseClick, left,  298,  601
Sleep, 100
MouseClick, left,  298,  622
Sleep, 100
MouseClick, left,  301,  644
Sleep, 100
MouseClick, left,  301,  664
Sleep, 100
MouseClick, left,  301,  696
Sleep, 100
MouseClick, left,  301,  686
Sleep, 100
MouseClick, left,  301,  710
Sleep, 100
MouseClick, left,  301,  734
Sleep, 100
MouseClick, left,  298,  752
Sleep, 100
MouseClick, left,  298,  773
Sleep, 100
MouseClick, left,  287,  290
Sleep, 100
MouseClick, left,  291,  290
Sleep, 100
MouseClick, left,  291,  290
Sleep, 100
MouseClick, left,  291,  290
Sleep, 100
MouseClick, left,  291,  290
Sleep, 100





; COLETE
; RCtrl+PgUp
>^PgUp::Run D:\Docs\AHK\x27tN18tm3sob2.ahk

; COLAR CONFIGURAÇÕES DO SISTEMA
; Win+Alt+F11
#!F11::
send Processor: AMD Athlon XP 2800+
Sleep, 25
send {enter}
send RAM: 512MB DDR 400
Sleep, 25
send {enter}
send Video: GeForce 4 MX 440 64MB
Sleep, 25
send {enter}
send HD 1: Samsung 80GB 7200 rpm IDE
Sleep, 25
send {enter}
send HD 2: Seagate 120GB 7200 rpm IDE
Sleep, 25
send {enter}
send OS: Windows XP Home SP2
Sleep, 25
send {enter}
send Monitor: 17" Samsung Syncmaster 753DFX
return


; CONVERTER ÁREA DE TRANSFERÊNCIA PARA CAPITALIZAÇÃO COMO EM PROSA
; Exemplo: era uma vEz, Blé. eca. ---> Era uma vez, blé. Eca.
; Ctrl+Alt+K
!^k::                                          
StringLower, Clipboard, Clipboard
Clipboard := RegExReplace(Clipboard, "((?:^|[.!?]\s+)[a-z])", "$u1")
Send %Clipboard%
RETURN

; CÓPIA/COLA RÁPIDA <-- Posicionar as duas janelas em primeiro plano.
; Ctrl+Alt+C
#!c::
send ^c
Sleep, 25
send !{tab}
Sleep, 25
send ^v
Sleep, 25
send {enter}
return

;-------------------------------------------------
; Window dragging via alt+lbutton                -
; Author: Lasmori (email AT lasmori D0T com)     -
;-------------------------------------------------
!LButton::
original_win_delay := A_Win_Delay

CoordMode, Mouse, Relative
MouseGetPos, cur_win_x, cur_win_y, window_id
WinGet, window_minmax, MinMax, ahk_id %window_id%

; Return if the window is maximized or minimized
if window_minmax <> 0
{
  return
}

CoordMode, Mouse, Screen
SetWinDelay, 0

loop
{
  ; exit the loop if the left mouse button was released
  GetKeyState, lbutton_state, LButton, P
  if lbutton_state = U
  {
    break
  }

  MouseGetPos, cur_x, cur_y
  window_x := cur_x - cur_win_x
  window_y := cur_y - cur_win_y
  WinMove, ahk_id %window_id%,, %window_x%, %window_y%
}

SetWinDelay, %original_win_delay%

return
;-------------------------------------------------


; EJETAR / RECOLHER DRIVE H
; Win+[
#[::
Drive, Eject, H:
; If the command completed quickly, the tray was probably already ejected.
; In that case, retract it:
if A_TimeSinceThisHotkey < 1000  ; Adjust this time if needed.
    Drive, Eject,, 1
return

; EJETAR / RECOLHER DRIVE I
; Win+]
#]::
Drive, Eject, I:
; If the command completed quickly, the tray was probably already ejected.
; In that case, retract it:
if A_TimeSinceThisHotkey < 1000  ; Adjust this time if needed.
    Drive, Eject, I:, 1
return

; ESVAZIAR LIXEIRA
;Win+RCtrl+Backspace
#>^bs::
FileRecycleEmpty
Return

; EXTRAÇÃO DE WINRAR RÁPIDA
; RCtrl+Enter
>^Enter::
send {AppsKey}
Sleep, 100
send x{enter}
Sleep, 1200
send o
return

; EXTRAÇÃO DE WINRAR RÁPIDA, PARA PASTA
; RCtrl+Enter
>^>+Enter::
send {AppsKey}
Sleep, 100
send e{enter}
Sleep, 1200
send o
return

; FILEZILLA: AUTOCONECTAR E SELECIONAR
; Win+Ctrl+Alt+M
#^!m::
send ^s
Sleep, 250
send {down}
Sleep, 250
send !c
Sleep, 250
send {tab 9}
Sleep, 250
send {down 5}

; IR PARA HOTSTRINGS
; Ctrl+Alt+PgDn
^!PgDn::send {pgdn 17}

; LEGENDAS.TV SELECIONAR RELEASE EM PORTUGUÊS-BR
; Win+Down
#down::send {tab 2}{down}{enter}{tab}{enter}

; LOCALIZAR TONIGHT'S SHOWS NO CÓDIGO DO SA
; Win+Alt+U
#!u::
send !v
Sleep, 9
send o
Sleep, 1000
send ^f
Sleep, 50
send <h1>Tonight Shows</h1>
return


; MOVIMENTOS DA JANELA ATUAL

; 0
; Ctrl+Numpad6
^Numpad6::
send!{space}m
Sleep, 20
send {right 30}
return

; 45
; Ctrl+Numpad9
^Numpad9::
send!{space}m
Sleep, 20
send {right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{right 2}{up}{right}{up}{enter}
return

; 90
; Ctrl+Numpad8
^Numpad8::
send!{space}m
Sleep, 20
send {up 25}{enter}
return

; 135
; Ctrl+Numpad7
^Numpad7::
send!{space}m
Sleep, 20
send {up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{up}{left 2}{enter}
return

; 180
; Ctrl+Numpad4
^Numpad4::
send!{space}m
Sleep, 20
send {left 30}{enter}
return

; 225
; Ctrl+Numpad1
^Numpad1::
send!{space}m
Sleep, 20
send {down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}{down}{left 2}
return

; 270
; Ctrl+Numpad2
^Numpad2::
send!{space}m
Sleep, 20
send {down 25}{enter}
return

; 315
; Ctrl+Numpad3
^Numpad3::
send!{space}m
Sleep, 20
send {down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}{down}{right 2}
return

; MOZBACK TOTAL --> OS 4 TIPOS
; Win+Alt+Y
#!y::
; primeiro passo - welcome
send {enter} 
Sleep, 100
; segundo passo -backup or restore
send {tab 4} 
Sleep, 100
send {down 2} 
Sleep, 100
send {enter} 
; terceiro passo  - escolher profile
Sleep, 100
send {tab 3} 
Sleep, 100
send {down} 
Sleep, 100
send {tab} 
Sleep, 100
send {space} 
; quarto passo - salvar o arquivo
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+c+c+e
Sleep, 100
send {enter}
; quinto passo - voltar ao passo do profile, arquivo já determinado
Sleep, 100
send {tab 2}{enter}
; sexto passo - determinar se é com ou sem senha
Sleep, 100
send nnn
Sleep, 100
; sétimo passo - escolher opções de backup
send {tab 3}
Sleep, 100
send {up}{space}
Sleep, 100
; oitavo passo - lembrete das extensões problemáticas
send {enter}
Sleep, 100
send {enter}
; nono passo - go!
Sleep, 12000 ; FIM DO CCE
send !n{tab}{space}
Sleep, 100
send {enter}
Sleep, 100
send {tab 4}{down 2}
Sleep, 100
send {enter}
Sleep, 100
send {tab 3}{down}{tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+c+s+e
Sleep, 100
send {enter}
Sleep, 100
send {tab 2}{space}
Sleep, 100
send n
Sleep, 100
send {tab 3}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}
Sleep, 100
send {enter}
Sleep, 100
send {enter} 
Sleep, 9000 ; FIM DO CSE
send !n{tab}{space}
Sleep, 100
send {enter}
Sleep, 100
send {tab 4}{down 2} ; cuidado de novo
Sleep, 100
send {enter}
send {tab 3}{down}{tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+s+c+e
Sleep, 100
send {enter}
Sleep, 100
send {tab 2}{space}
Sleep, 100
send nn
Sleep, 100
send {tab 4}
Sleep, 100
send {down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{enter}
Sleep, 12000 ; FIM DO SCE
send !n
Sleep, 100
send {tab}{enter}
Sleep, 100,
send {enter}
Sleep, 100,
send {tab 4}{down 2}
Sleep, 100,
send {enter}{tab 3}{down}
Sleep, 100,
send {tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+s+s+e
Sleep, 100
send {enter}
Sleep, 100,
send {tab 2}{space}
Sleep, 100,
send nn
Sleep, 100
send {tab 3}
Sleep, 100
send {space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{tab}
Sleep, 100
send {space}
Sleep, 4500,
send {enter}
Sleep, 100
send {enter}
return ; END SSE

 
; MOZBACK TOTAL COM EXECUÇÃO DO PROGRAMA--> OS 4 TIPOS
; Win+Alt+O
#!o::
Run F:\Appz\4 Utilitários\MozBackup 1.4.4\Backup.exe
Sleep, 500
; primeiro passo - welcome
send {enter} 
Sleep, 100
; segundo passo -backup or restore
send {tab 4} 
Sleep, 100
send {down 2} 
Sleep, 100
send {enter} 
; terceiro passo  - escolher profile
Sleep, 100
send {tab 3} 
Sleep, 100
send {down} 
Sleep, 100
send {tab} 
Sleep, 100
send {space} 
; quarto passo - salvar o arquivo
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+c+c+e
Sleep, 100
send {enter}
; quinto passo - voltar ao passo do profile, arquivo já determinado
Sleep, 100
send {tab 2}{enter}
; sexto passo - determinar se é com ou sem senha
Sleep, 100
send nnn
Sleep, 100
; sétimo passo - escolher opções de backup
send {tab 3}
Sleep, 100
send {up}{space}
Sleep, 100
; oitavo passo - lembrete das extensões problemáticas
send {enter}
Sleep, 100
send {enter}
; nono passo - go!
Sleep, 7000 ; FIM DO CCE
send !n{tab}{space}
Sleep, 100
send {enter}
Sleep, 100
send {tab 4}{down 2}
Sleep, 100
send {enter}
Sleep, 100
send {tab 3}{down}{tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+c+s+e
Sleep, 100
send {enter}
Sleep, 100
send {tab 2}{space}
Sleep, 100
send n
Sleep, 100
send {tab 3}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}
Sleep, 100
send {enter}
Sleep, 100
send {enter} 
Sleep, 6000 ; FIM DO CSE
send !n{tab}{space}
Sleep, 100
send {enter}
Sleep, 100
send {tab 4}{down 2} ; cuidado de novo
Sleep, 100
send {enter}
send {tab 3}{down}{tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+s+c+e
Sleep, 100
send {enter}
Sleep, 100
send {tab 2}{space}
Sleep, 100
send nn
Sleep, 100
send {tab 4}
Sleep, 100
send {down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{enter}
Sleep, 6000 ; FIM DO SCE
send !n
Sleep, 100
send {tab}{enter}
Sleep, 100,
send {enter}
Sleep, 100,
send {tab 4}{down 2}
Sleep, 100,
send {enter}{tab 3}{down}
Sleep, 100,
send {tab}{space}
Sleep, 100
send {right} 
Sleep, 100
send {left 4} 
Sleep, 100
send {BS 10}
Sleep, 500
FormatTime, CurrentDate,, d-M-yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H.mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}+s+s+e
Sleep, 100
send {enter}
Sleep, 100,
send {tab 2}{space}
Sleep, 100,
send nn
Sleep, 100
send {tab 3}
Sleep, 100
send {space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{space}{down}{tab}
Sleep, 100
send {space}
Sleep, 2500,
send {enter}
Sleep, 100
send {enter}
return ; END SSE


; NVU FIND/REPLACE
; Win+Ctrl+Shift+N
#^+n::
send ^f
Sleep, 50
send 05:00 pm{tab}<b>17:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 05:30 pm{tab}<b>17:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 06:00 pm{tab}<b>18:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 06:30 pm{tab}<b>18:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 07:00 pm{tab}<b>19:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 07:15 pm{tab}<b>19:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 07:30 pm{tab}<b>19:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 07:45 pm{tab}<b>19:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 08:00 pm{tab}<b>20:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 08:15 pm{tab}<b>20:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 08:30 pm{tab}<b>20:30</b>!a
Sleep, 50
send {tab 2}
send 08:45 pm{tab}<b>20:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 09:00 pm{tab}<b>21:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 09:30 pm{tab}<b>21:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 10:00 pm{tab}<b>22:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 10:02 pm{tab}<b>22:02</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 10:15 pm{tab}<b>22:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 10:30 pm{tab}<b>22:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 11:00 pm{tab}<b>23:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 11:05 pm{tab}<b>23:05</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 11:30 pm{tab}<b>23:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 11:35 pm{tab}<b>23:35</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 11:45 pm{tab}<b>23:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:00 am{tab}<b>00:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:05 am{tab}<b>00:05</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:15 am{tab}<b>00:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:30 am{tab}<b>00:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:35 am{tab}<b>00:35</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 12:45 am{tab}<b>00:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:00 am{tab}<b>01:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:05 am{tab}<b>01:05</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:15 am{tab}<b>01:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:30 am{tab}<b>01:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:35 am{tab}<b>01:35</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 01:45 am{tab}<b>01:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:00 am{tab}<b>02:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:05 am{tab}<b>02:05</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:15 am{tab}<b>02:15</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:30 am{tab}<b>02:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:35 am{tab}<b>02:35</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 02:45 am{tab}<b>02:45</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 03:00 am{tab}<b>03:00</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 03:30 am{tab}<b>03:30</b>!a
Sleep, 50
send {tab 2}
Sleep, 50
send 04:00 am{tab}<b>04:00</b>!a
Sleep, 50
send {tab}<b>{enter}
Sleep, 50
Return

; ORGANIZAR ÍCONES NA ÁREA DE TRABALHO POR DATA DE MODIFICAÇÃO
; Win+Space
#space::
send #m
WinWait, Program Manager, 
IfWinNotActive, Program Manager, , WinActivate, Program Manager, 
WinWaitActive, Program Manager, 
MouseClick, left,  432,  336
Sleep, 100
MouseClick, right,  432,  336
Sleep, 100
Send, gm
return

; PAUSE
; RWin+BS
>#BS:: Pause

; RECARREGAR SCRIPT
; Ctrl+num0
^Numpad0:: Reload


; REMOVER ÁREA DE BUSCA DO FIREFOX
; Ctrl+Xbutton1 = mouse4
^XButton1::
send ^f
Sleep, 23
send {esc}
return

; RENOMEAR, COPIAR, ENTER
; Ctrl+Alt+Z
^!z::send {F2}^c{enter}

; RENOMEAR, COLAR, ENTER
; Ctrl+Alt+X
^!x::send {F2}^v{enter}

; RESTAURAR ITENS SELECIONADOS DA LIXEIRA
; RShift+Backspace
>+bs::send {appskey}{down}{enter}

; SALVAR E RECARREGAR
; RCtrl+NumpadEnter
>^NumpadEnter::
IfWinActive, TextPad - [D:\Docs\AHK\scripts\Script.ahk *]
WinActivate  ; Automatically uses the window found above.
WinMaximize  ; same
Send, ^s
Reload
return


; SAMURIZE CONFIG
; Win+RCtrl+S
#>^s:: Run C:\Arquivos de programas\Samurize\Config.exe "C:\Arquivos de programas\Samurize\Configs\hdzinho.ini"

; SCREENSHOT RÁPIDA
; RCtrl+PrintScreen
>^PrintScreen::
Send,{PrintScreen}
Sleep,100
Run, C:\Arquivos de programas\IrfanView\i_view32.exe
Sleep,700
send, ^v
Sleep, 500
return

; SELECTION TO GOOGLE
; Win+Ctrl+Alt+C
#^!c::
send ^c
Sleep, 18
send ^k
Sleep, 18
send ^v
Sleep, 18
send {up}
Sleep, 18
send {up}
Sleep, 18
send {up}
Sleep, 18
send {up}
Sleep, 18
send {enter}
return

; SIGN OUT NO GMAIL (EM INGLÊS)
; RCtrl+F12
>^F12::
send '
send sig{enter}
return

>^F11::
send '
send sair{enter}
return

; SUBIR PARA O CHANGELOG
; Win+Ctrl+Up
#^up::
send ^{home}{down 17}{enter}{;}{space}
Sleep, 26
FormatTime, CurrentDate,, d/M/yy ; <-- esta é a data.
SendInput %CurrentDate%
SendInput, {space}às{space}
FormatTime, CurrentTime,, H:mm  ; <-- esta é a hora.
SendInput %CurrentTime%
SendInput, {space}-{space}
return

; SUBIR PARA O CHANGELOG, ADICIONAR PEQUENA MODIFICAÇÃO
; Win+Shift+Up
#+up::send ^{home}{down 18}{end}{bs}{space}

; URL BB CODE FOR PHPBB
; Win+=
#=::
Sleep, 50
send [url=%clipboard%]
Sleep, 50
send [/url]
Sleep, 50
send {left 6}
return

; UTORRENT: REMOVE AND DELETE DATA
; Win+Ctrl+NumpadSub
#^NumpadSub:: send {AppsKey}ne{enter}
























; ######################################################################################
; FORA DE USO / TEMPORÁRIOS
; ######################################################################################

/*
; CLIPBOARD TO GOOGLE
Alt+F1
!F1::
Var = %Clipboard%
StringReplace, Var, Var, %A_Space%, +, All
GoogleSearch = http://www.google.com/search?q=`%22%Var%`%22
Run, %GoogleSearch%
Return
*/

/*
COLUNAS DA PLANILHA DE SÉRIES
Win+Ctrl+R
#^r::send +release{tab}+status{tab}+fonte{tab}+legenda{tab}+renomeação{tab}+resultado
*/

/*
HOME, BACK, SPACE
F4::send {home}{bs}{space}
*/

/*
LOAD ROR GAME
RCtrl+Numpad7
>^Numpad7::
send {F10}
Sleep, 150
Send {down 4}
Sleep, 150
send {enter 3}
return
*/

/*
RENOMEAR DEZENAS
Numpad5
Numpad5::send {down}{F2}{left}{right}{bs 2}
*/

/*
INTELLISENSE
Win+Ctrl+Num*
#^NumpadMult::Run C:\Arquivos de programas\AutoHotkey\Extras\Scripts\IntelliSense.ahk
*/

/*
#^Numpad5::
Send,!{PrintScreen}
Sleep,1500
Runwait, D:\Docs\Imagens\Screenshots\kiu-clipsave.exe, , Hide
Sleep, 750
KeyWait, LButton, down
return
*/


























































































































































































; ##########################################################################################
; NIFTYWINDOWS nwd; ##########################################################################################


/*
 * Copyright (c) 2004-2005 by Enovatic-Solutions. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * ----------------------------------------------------------------------
 * If you have any suggestions of new features or further questions 
 * feel free to contact the author.
 *
 * Company:  Enovatic-Solutions (IT Service Provider)
 * Author:   Oliver Pfeiffer, Bremen (GERMANY)
 * Homepage: http://www.enovatic.org/
 * Email:    contact@enovatic.org
 */



; NiftyWindows Version 0.9.3.1
; http://www.enovatic.org/products/niftywindows/

; AutoHotkey Version 1.0.36.01
; http://www.autohotkey.com/



#SingleInstance force
#HotkeyInterval 1000
#MaxHotkeysPerInterval 100
; #NoTrayIcon



; [SYS] autostart section

SplitPath, A_ScriptFullPath, SYS_ScriptNameExt, SYS_ScriptDir, SYS_ScriptExt, SYS_ScriptNameNoExt, SYS_ScriptDrive
SYS_ScriptVersion = 0.9.3.1
SYS_ScriptBuild = 20050702195845
SYS_ScriptInfo = %SYS_ScriptNameNoExt% %SYS_ScriptVersion%

Process, Priority, , HIGH
SetBatchLines, -1
; TODO : a nulled key delay may produce problems for WinAmp control
SetKeyDelay, 0, 0
SetMouseDelay, 0
SetDefaultMouseSpeed, 0
SetWinDelay, 0
SetControlDelay, 0

Gosub, SYS_ParseCommandLine
Gosub, CFG_LoadSettings
Gosub, CFG_ApplySettings

MIR_MirandaFullPath = %ProgramFiles%\Miranda\Miranda32.exe
SplitPath, MIR_MirandaFullPath, , MIR_MirandaDir

if ( !A_IsCompiled )
	SetTimer, REL_ScriptReload, 1000

OnExit, SYS_ExitHandler

Gosub, TRY_TrayInit
Gosub, SYS_ContextCheck

Return



; [SYS] parses command line parameters

SYS_ParseCommandLine:
	Loop %0%
		If ( (%A_Index% = "/x") or (%A_Index% = "/exit") )
			ExitApp
Return



; [SYS] exit handler

SYS_ExitHandler:
	Gosub, AOT_ExitHandler
	Gosub, ROL_ExitHandler
	Gosub, TRA_ExitHandler
	Gosub, CFG_SaveSettings
ExitApp



; [SYS] context check

SYS_ContextCheck:
	Gosub, SYS_TrayTipBalloonCheck
	If ( !SYS_TrayTipBalloon )
	{
		Gosub, SUS_SuspendSaveState
		Suspend, On
		MsgBox, 4148, Balloon Handler - %SYS_ScriptInfo%, The balloon messages are disabled on your system. These visual messages`nabove the system tray are often used by tools as additional information four`nyour interest.`n`nNiftyWindows uses balloon messages to show you some important operating`ndetails. If you leave the messages disabled NiftyWindows will show some plain`nmessages as tooltips instead (in front of the system tray).`n`nDo you want to enable balloon messages now (highly recommended)?
		Gosub, SUS_SuspendRestoreState
		IfMsgBox, Yes
		{
			SYS_TrayTipBalloon = 1
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, EnableBalloonTips, %SYS_TrayTipBalloon%
			RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, EnableBalloonTips, %SYS_TrayTipBalloon%
			SendMessage, 0x001A, , , , ahk_id 0xFFFF ; 0x001A is WM_SETTINGCHANGE ; 0xFFFF is HWND_BROADCAST
			Sleep, 500 ; lets the other windows relax
		}
	}
	
	IfNotExist, %A_ScriptDir%\readme.txt
	{
		TRY_TrayEvent := "Help"
		Gosub, TRY_TrayEvent
		Suspend, On
		Sleep, 10000
		ExitApp, 1
	}

	IfNotExist, %A_ScriptDir%\license.txt
	{
		TRY_TrayEvent := "View License"
		Gosub, TRY_TrayEvent
		Suspend, On
		Sleep, 10000
		ExitApp, 1
	}
	
	TRY_TrayEvent := "About"
	Gosub, TRY_TrayEvent
Return



; [SYS] handles tooltips

SYS_ToolTipShow:
	If ( SYS_ToolTipText )
	{
		If ( !SYS_ToolTipSeconds )
			SYS_ToolTipSeconds = 2
		SYS_ToolTipMillis := SYS_ToolTipSeconds * 1000
		CoordMode, Mouse, Screen
		CoordMode, ToolTip, Screen
		If ( !SYS_ToolTipX or !SYS_ToolTipY )
		{
			MouseGetPos, SYS_ToolTipX, SYS_ToolTipY
			SYS_ToolTipX += 16
			SYS_ToolTipY += 24
		}
		ToolTip, %SYS_ToolTipText%, %SYS_ToolTipX%, %SYS_ToolTipY%
		SetTimer, SYS_ToolTipHandler, %SYS_ToolTipMillis%
	}
	SYS_ToolTipText =
	SYS_ToolTipSeconds =
	SYS_ToolTipX =
	SYS_ToolTipY =
Return

SYS_ToolTipFeedbackShow:
	If ( SYS_ToolTipFeedback )
		Gosub, SYS_ToolTipShow
	SYS_ToolTipText =
	SYS_ToolTipSeconds =
	SYS_ToolTipX =
	SYS_ToolTipY =
Return

SYS_ToolTipHandler:
	SetTimer, SYS_ToolTipHandler, Off
	ToolTip
Return



; [SYS] handles balloon messages

SYS_TrayTipShow:
	If ( SYS_TrayTipText )
	{
		If ( !SYS_TrayTipTitle )
			SYS_TrayTipTitle = %SYS_ScriptInfo%
		If ( !SYS_TrayTipSeconds )
			SYS_TrayTipSeconds = 10
		If ( !SYS_TrayTipOptions )
			SYS_TrayTipOptions = 17
		SYS_TrayTipMillis := SYS_TrayTipSeconds * 1000
		Gosub, SYS_TrayTipBalloonCheck
		If ( SYS_TrayTipBalloon and !A_IconHidden )
		{
			TrayTip, %SYS_TrayTipTitle%, %SYS_TrayTipText%, %SYS_TrayTipSeconds%, %SYS_TrayTipOptions%
			SetTimer, SYS_TrayTipHandler, %SYS_TrayTipMillis%
		}
		Else
		{
			TrayTip
			SYS_ToolTipText = %SYS_TrayTipTitle%:`n`n%SYS_TrayTipText%
			SYS_ToolTipSeconds = %SYS_TrayTipSeconds%
			SysGet, SYS_TrayTipDisplay, Monitor
			SYS_ToolTipX = %SYS_TrayTipDisplayRight%
			SYS_ToolTipY = %SYS_TrayTipDisplayBottom%
			Gosub, SYS_ToolTipShow
		}
	}
	SYS_TrayTipTitle =
	SYS_TrayTipText =
	SYS_TrayTipSeconds =
	SYS_TrayTipOptions =
Return

SYS_TrayTipHandler:
	SetTimer, SYS_TrayTipHandler, Off
	TrayTip
Return

SYS_TrayTipBalloonCheck:
	RegRead, SYS_TrayTipBalloonCU, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, EnableBalloonTips
	SYS_TrayTipBalloonCU := ErrorLevel or SYS_TrayTipBalloonCU
	RegRead, SYS_TrayTipBalloonLM, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, EnableBalloonTips
	SYS_TrayTipBalloonLM := ErrorLevel or SYS_TrayTipBalloonLM
	SYS_TrayTipBalloon := SYS_TrayTipBalloonCU and SYS_TrayTipBalloonLM
Return



; [SUS] provides suspend services

#Esc::
SUS_SuspendToggle:
	Suspend, Permit
	If ( !A_IsSuspended )
	{
		Suspend, On
		SYS_TrayTipText = NiftyWindows is suspended now.`nPress WIN+ESC to resume it again.
		SYS_TrayTipOptions = 2
	}
	Else
	{
		Suspend, Off
		SYS_TrayTipText = NiftyWindows is resumed now.`nPress WIN+ESC to suspend it again.
	}
	Gosub, SYS_TrayTipShow
	Gosub, TRY_TrayUpdate
Return

SUS_SuspendSaveState:
	SUS_Suspended := A_IsSuspended
Return

SUS_SuspendRestoreState:
	If ( SUS_Suspended )
		Suspend, On
	Else
		Suspend, Off
Return

SUS_SuspendHandler:
	IfWinActive, A
	{
		WinGet, SUS_WinID, ID
		If ( !SUS_WinID )
			Return
		WinGet, SUS_WinMinMax, MinMax, ahk_id %SUS_WinID%
		WinGetPos, SUS_WinX, SUS_WinY, SUS_WinW, SUS_WinH, ahk_id %SUS_WinID%
		
		If ( (SUS_WinMinMax = 0) and (SUS_WinX = 0) and (SUS_WinY = 0) and (SUS_WinW = A_ScreenWidth) and (SUS_WinH = A_ScreenHeight) )
		{
			WinGetClass, SUS_WinClass, ahk_id %SUS_WinID%
			WinGet, SUS_ProcessName, ProcessName, ahk_id %SUS_WinID%
			SplitPath, SUS_ProcessName, , , SUS_ProcessExt
			If ( (SUS_WinClass != "Progman") and (SUS_ProcessExt != "scr") and !SUS_FullScreenSuspend )
			{
				SUS_FullScreenSuspend = 1
				SUS_FullScreenSuspendState := A_IsSuspended
				If ( !A_IsSuspended )
				{
					Suspend, On
					SYS_TrayTipText = A full screen window was activated.`nNiftyWindows is suspended now.`nPress WIN+ESC to resume it again.
					SYS_TrayTipOptions = 2
					Gosub, SYS_TrayTipShow
					Gosub, TRY_TrayUpdate
				}
			}
		}
		Else
		{
			If ( SUS_FullScreenSuspend )
			{
				SUS_FullScreenSuspend = 0
				If ( A_IsSuspended and !SUS_FullScreenSuspendState )
				{
					Suspend, Off
					SYS_TrayTipText = A full screen window was deactivated.`nNiftyWindows is resumed now.`nPress WIN+ESC to suspend it again.
					Gosub, SYS_TrayTipShow
					Gosub, TRY_TrayUpdate
				}
			}
		}
	}
Return



; [SYS] provides reversion of all visual effects

/**
 * This powerful hotkey removes all visual effects (like on exit) that have 
 * been made before by NiftyWindows. You can use this action as a fall-back 
 * solution to quickly revert any always-on-top, \ed windows and 
 * transparency features you've set before.
 */

^#BS::
; ^!BS::
SYS_RevertVisualEffects:
	Gosub, AOT_SetAllOff
	Gosub, ROL_RollDownAll
	Gosub, TRA_TransparencyAllOff
	SYS_TrayTipText = All visual effects (AOT, Roll, Transparency) were reverted.
	Gosub, SYS_TrayTipShow
Return



; [NWD] nifty window dragging

/**
 * This is the most powerful feature of NiftyWindows. The area of every window 
 * is tiled in a virtual 9-cell grid with three columns and rows. The center 
 * cell is the largest one and you can grab and move a window around by clicking 
 * and holding it with the right mouse button. The other eight corner cells are 
 * used to resize a resizable window in the same manner.
 */

$RButton::
$+RButton::
$+!RButton::
$+^RButton::
$+#RButton::
$+!^RButton::
$+!#RButton::
$+^#RButton::
$+!^#RButton::
$!RButton::
$!^RButton::
$!#RButton::
$!^#RButton::
$^RButton::
$^#RButton::
$#RButton::
	NWD_ResizeGrids = 5
	CoordMode, Mouse, Screen
	MouseGetPos, NWD_MouseStartX, NWD_MouseStartY, NWD_WinID
	If ( !NWD_WinID )
		Return
	WinGetPos, NWD_WinStartX, NWD_WinStartY, NWD_WinStartW, NWD_WinStartH, ahk_id %NWD_WinID%
	WinGet, NWD_WinMinMax, MinMax, ahk_id %NWD_WinID%
	WinGet, NWD_WinStyle, Style, ahk_id %NWD_WinID%
	WinGetClass, NWD_WinClass, ahk_id %NWD_WinID%
	GetKeyState, NWD_CtrlState, Ctrl, P
	
	; the and'ed condition checks for popup window:
	; (WS_POPUP) and !(WS_DLGFRAME | WS_SYSMENU | WS_THICKFRAME)
	If ( (NWD_WinClass = "Progman") or ((NWD_CtrlState = "U") and (((NWD_WinStyle & 0x80000000) and !(NWD_WinStyle & 0x4C0000)) or (NWD_WinClass = "ExploreWClass") or (NWD_WinClass = "CabinetWClass") or (NWD_WinClass = "IEFrame") or (NWD_WinClass = "MozillaWindowClass") or (NWD_WinClass = "OpWindow") or (NWD_WinClass = "ATL:ExplorerFrame") or (NWD_WinClass = "ATL:ScrapFrame"))) )
	{
		NWD_ImmediateDownRequest = 1
		NWD_ImmediateDown = 0
		NWD_PermitClick = 1
	}
	Else
	{
		NWD_ImmediateDownRequest = 0
		NWD_ImmediateDown = 0
		NWD_PermitClick = 1
	}
	
	NWD_Dragging := (NWD_WinClass != "Progman") and ((NWD_CtrlState = "D") or ((NWD_WinMinMax != 1) and !NWD_ImmediateDownRequest))

	; checks wheter the window has a sizing border (WS_THICKFRAME)
	If ( (NWD_CtrlState = "D") or (NWD_WinStyle & 0x40000) )
	{
		If ( (NWD_MouseStartX >= NWD_WinStartX + NWD_WinStartW / NWD_ResizeGrids) and (NWD_MouseStartX <= NWD_WinStartX + (NWD_ResizeGrids - 1) * NWD_WinStartW / NWD_ResizeGrids) )
			NWD_ResizeX = 0
		Else
			If ( NWD_MouseStartX > NWD_WinStartX + NWD_WinStartW / 2 )
				NWD_ResizeX := 1
			Else
				NWD_ResizeX := -1

		If ( (NWD_MouseStartY >= NWD_WinStartY + NWD_WinStartH / NWD_ResizeGrids) and (NWD_MouseStartY <= NWD_WinStartY + (NWD_ResizeGrids - 1) * NWD_WinStartH / NWD_ResizeGrids) )
			NWD_ResizeY = 0
		Else
			If ( NWD_MouseStartY > NWD_WinStartY + NWD_WinStartH / 2 )
				NWD_ResizeY := 1
			Else
				NWD_ResizeY := -1
	}
	Else
	{
		NWD_ResizeX = 0
		NWD_ResizeY = 0
	}
	
	If ( NWD_WinStartW and NWD_WinStartH )
		NWD_WinStartAR := NWD_WinStartW / NWD_WinStartH
	Else
		NWD_WinStartAR = 0
	
	; TODO : this is a workaround (checks for popup window) for the activation 
	; bug of AutoHotkey -> can be removed as soon as the known bug is fixed
	If ( !((NWD_WinStyle & 0x80000000) and !(NWD_WinStyle & 0x4C0000)) )
		IfWinNotActive, ahk_id %NWD_WinID%
			WinActivate, ahk_id %NWD_WinID%
	
	; TODO : the hotkeys must be enabled in the 2nd block because the 1st block 
	; activates them only for the first call (historical problem of AutoHotkey)
	Hotkey, Shift, NWD_IgnoreKeyHandler
	Hotkey, Ctrl, NWD_IgnoreKeyHandler
	Hotkey, Alt, NWD_IgnoreKeyHandler
	Hotkey, LWin, NWD_IgnoreKeyHandler
	Hotkey, RWin, NWD_IgnoreKeyHandler
	Hotkey, Shift, On
	Hotkey, Ctrl, On
	Hotkey, Alt, On
	Hotkey, LWin, On
	Hotkey, RWin, On
	SetTimer, NWD_IgnoreKeyHandler, 100
	SetTimer, NWD_WindowHandler, 10
Return

NWD_SetDraggingOff:
	NWD_Dragging = 0
Return

NWD_SetClickOff:
	NWD_PermitClick = 0
	NWD_ImmediateDownRequest = 0
Return

NWD_SetAllOff:
	Gosub, NWD_SetDraggingOff
	Gosub, NWD_SetClickOff
Return

NWD_IgnoreKeyHandler:
	GetKeyState, NWD_RButtonState, RButton, P
	GetKeyState, NWD_ShiftState, Shift, P
	GetKeyState, NWD_CtrlState, Ctrl, P
	GetKeyState, NWD_AltState, Alt, P
	; TODO : unlike the other modifiers, Win does not exist 
	; as a virtual key (but Ctrl, Alt and Shift do)
	GetKeyState, NWD_LWinState, LWin, P
	GetKeyState, NWD_RWinState, RWin, P
	If ( (NWD_LWinState = "D") or (NWD_RWinState = "D") )
		NWD_WinState = D
	Else
		NWD_WinState = U
	
	If ( (NWD_RButtonState = "U") and (NWD_ShiftState = "U") and (NWD_CtrlState = "U") and (NWD_AltState = "U") and (NWD_WinState = "U") )
	{
		SetTimer, NWD_IgnoreKeyHandler, Off
		Hotkey, Shift, Off
		Hotkey, Ctrl, Off
		Hotkey, Alt, Off
		Hotkey, LWin, Off
		Hotkey, RWin, Off
	}
Return

NWD_WindowHandler:
	SetWinDelay, -1
	CoordMode, Mouse, Screen
	MouseGetPos, NWD_MouseX, NWD_MouseY
	WinGetPos, NWD_WinX, NWD_WinY, NWD_WinW, NWD_WinH, ahk_id %NWD_WinID%
	GetKeyState, NWD_RButtonState, RButton, P
	GetKeyState, NWD_ShiftState, Shift, P
	GetKeyState, NWD_AltState, Alt, P
	; TODO : unlike the other modifiers, Win does not exist 
	; as a virtual key (but Ctrl, Alt and Shift do)
	GetKeyState, NWD_LWinState, LWin, P
	GetKeyState, NWD_RWinState, RWin, P
	If ( (NWD_LWinState = "D") or (NWD_RWinState = "D") )
		NWD_WinState = D
	Else
		NWD_WinState = U
	
	If ( NWD_RButtonState = "U" )
	{
		SetTimer, NWD_WindowHandler, Off
		
		If ( NWD_ImmediateDown )
			MouseClick, RIGHT, %NWD_MouseX%, %NWD_MouseY%, , , U
		Else
			If ( NWD_PermitClick and (!NWD_Dragging or ((NWD_MouseStartX = NWD_MouseX) and (NWD_MouseStartY = NWD_MouseY))) )
			{
				MouseClick, RIGHT, %NWD_MouseStartX%, %NWD_MouseStartY%, , , D
				MouseClick, RIGHT, %NWD_MouseX%, %NWD_MouseY%, , , U
			}

		Gosub, NWD_SetAllOff
		NWD_ImmediateDown = 0
	}
	Else
	{
		NWD_MouseDeltaX := NWD_MouseX - NWD_MouseStartX
		NWD_MouseDeltaY := NWD_MouseY - NWD_MouseStartY

		If ( NWD_MouseDeltaX or NWD_MouseDeltaY )
		{
			If ( NWD_ImmediateDownRequest and !NWD_ImmediateDown )
			{
				MouseClick, RIGHT, %NWD_MouseStartX%, %NWD_MouseStartY%, , , D
				MouseMove, %NWD_MouseX%, %NWD_MouseY%
				NWD_ImmediateDown = 1
				NWD_PermitClick = 0
			}

			If ( NWD_Dragging )
			{
				If ( !NWD_ResizeX and !NWD_ResizeY )
				{
					NWD_WinNewX := NWD_WinStartX + NWD_MouseDeltaX
					NWD_WinNewY := NWD_WinStartY + NWD_MouseDeltaY
					NWD_WinNewW := NWD_WinStartW
					NWD_WinNewH := NWD_WinStartH
				}
				Else
				{
					NWD_WinDeltaW = 0
					NWD_WinDeltaH = 0
					If ( NWD_ResizeX )
						NWD_WinDeltaW := NWD_ResizeX * NWD_MouseDeltaX
					If ( NWD_ResizeY )
						NWD_WinDeltaH := NWD_ResizeY * NWD_MouseDeltaY
					If ( NWD_WinState = "D" )
					{
						If ( NWD_ResizeX )
							NWD_WinDeltaW *= 2
						If ( NWD_ResizeY )
							NWD_WinDeltaH *= 2
					}
					NWD_WinNewW := NWD_WinStartW + NWD_WinDeltaW
					NWD_WinNewH := NWD_WinStartH + NWD_WinDeltaH
					If ( NWD_WinNewW < 0 )
						If ( NWD_WinState = "D" )
							NWD_WinNewW *= -1
						Else
							NWD_WinNewW := 0
					If ( NWD_WinNewH < 0 )
						If ( NWD_WinState = "D" )
							NWD_WinNewH *= -1
						Else
							NWD_WinNewH := 0
					If ( (NWD_AltState = "D") and NWD_WinStartAR )
					{
						NWD_WinNewARW := NWD_WinNewH * NWD_WinStartAR
						NWD_WinNewARH := NWD_WinNewW / NWD_WinStartAR
						If ( NWD_WinNewW < NWD_WinNewARW )
							NWD_WinNewW := NWD_WinNewARW
						If ( NWD_WinNewH < NWD_WinNewARH )
							NWD_WinNewH := NWD_WinNewARH
					}
					NWD_WinDeltaX = 0
					NWD_WinDeltaY = 0
					If ( NWD_WinState = "D" )
					{
						NWD_WinDeltaX := NWD_WinStartW / 2 - NWD_WinNewW / 2
						NWD_WinDeltaY := NWD_WinStartH / 2 - NWD_WinNewH / 2
					}
					Else
					{
						If ( NWD_ResizeX = -1 )
							NWD_WinDeltaX := NWD_WinStartW - NWD_WinNewW
						If ( NWD_ResizeY = -1 )
							NWD_WinDeltaY := NWD_WinStartH - NWD_WinNewH
					}
					NWD_WinNewX := NWD_WinStartX + NWD_WinDeltaX
					NWD_WinNewY := NWD_WinStartY + NWD_WinDeltaY
				}
				
				If ( NWD_ShiftState = "D" )
					NWD_WinNewRound = -1
				Else
					NWD_WinNewRound = 0
				
				Transform, NWD_WinNewX, Round, %NWD_WinNewX%, %NWD_WinNewRound%
				Transform, NWD_WinNewY, Round, %NWD_WinNewY%, %NWD_WinNewRound%
				Transform, NWD_WinNewW, Round, %NWD_WinNewW%, %NWD_WinNewRound%
				Transform, NWD_WinNewH, Round, %NWD_WinNewH%, %NWD_WinNewRound%
				
				If ( (NWD_WinNewX != NWD_WinX) or (NWD_WinNewY != NWD_WinY) or (NWD_WinNewW != NWD_WinW) or (NWD_WinNewH != NWD_WinH) )
				{
					WinMove, ahk_id %NWD_WinID%, , %NWD_WinNewX%, %NWD_WinNewY%, %NWD_WinNewW%, %NWD_WinNewH%
					
					If ( SYS_ToolTipFeedback )
					{
						WinGetPos, NWD_ToolTipWinX, NWD_ToolTipWinY, NWD_ToolTipWinW, NWD_ToolTipWinH, ahk_id %NWD_WinID%
						SYS_ToolTipText = Window Drag: (X:%NWD_ToolTipWinX%, Y:%NWD_ToolTipWinY%, W:%NWD_ToolTipWinW%, H:%NWD_ToolTipWinH%)
						Gosub, SYS_ToolTipFeedbackShow
					}
				}
			}
		}
	}
Return



; [MIW {NWD}] minimize/roll on right + left mouse button

/**
 * Minimizes the selected window (if minimizable) to the task bar. If you press 
 * the left button over the titlebar the selected window will be rolled up 
 * instead of being minimized. You have to apply this action again to roll the 
 * window back down.
 */

$LButton::
$^LButton::
	GetKeyState, MIW_RButtonState, RButton, P
	If ( (MIW_RButtonState = "D") and (!NWD_ImmediateDown) and (NWD_WinClass != "Progman") )
	{
		GetKeyState, MIW_CtrlState, Ctrl, P
		WinGet, MIW_WinStyle, Style, ahk_id %NWD_WinID%
		SysGet, MIW_CaptionHeight, 4 ; SM_CYCAPTION
		SysGet, MIW_BorderHeight, 7 ; SM_CXDLGFRAME
		MouseGetPos, , MIW_MouseY

		If ( MIW_MouseY <= MIW_CaptionHeight + MIW_BorderHeight )
		{
			; checks wheter the window has a sizing border (WS_THICKFRAME)
			If ( (MIW_CtrlState = "D") or (MIW_WinStyle & 0x40000) )
			{
				Gosub, NWD_SetAllOff
				ROL_WinID = %NWD_WinID%
				Gosub, ROL_RollToggle
			}
		}
		Else
		{
			; the second condition checks for minimizable window:
			; (WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX)
			If ( (MIW_CtrlState = "D") or (MIW_WinStyle & 0xCA0000 = 0xCA0000) )
			{
				Gosub, NWD_SetAllOff
				WinMinimize, ahk_id %NWD_WinID%
				SYS_ToolTipText = Window Minimize
				Gosub, SYS_ToolTipFeedbackShow
			}
		}
	}
	Else
	{
		; this feature should be implemented by using a timer because 
		; AutoHotkeys threading blocks the first thread if another 
		; one is started (until the 2nd is stopped)
		
		Thread, priority, 1
		MouseClick, LEFT, , , , , D
		KeyWait, LButton
		MouseClick, LEFT, , , , , U
	}
Return



; [CLW {NWD}] close/send bottom on right + middle mouse button || double click on middle mouse button

/**
 * Closes the selected window (if closeable) as if you click the close button 
 * in the titlebar. If you press the middle button over the titlebar the 
 * selected window will be sent to the bottom of the window stack instead of 
 * being closed.
 */

$MButton::
$^MButton::
	GetKeyState, CLW_RButtonState, RButton, P
	If ( (CLW_RButtonState = "D") and (!NWD_ImmediateDown) and (NWD_WinClass != "Progman") )
	{
		GetKeyState, CLW_CtrlState, Ctrl, P
		WinGet, CLW_WinStyle, Style, ahk_id %NWD_WinID%
		SysGet, CLW_CaptionHeight, 4 ; SM_CYCAPTION
		SysGet, CLW_BorderHeight, 7 ; SM_CXDLGFRAME
		MouseGetPos, , CLW_MouseY

		If ( CLW_MouseY <= CLW_CaptionHeight + CLW_BorderHeight )
		{
			Gosub, NWD_SetAllOff
			Send, !{Esc}
			SYS_ToolTipText = Window Bottom
			Gosub, SYS_ToolTipFeedbackShow
		}
		Else
		{
			; the second condition checks for closeable window:
			; (WS_CAPTION | WS_SYSMENU)
			If ( (CLW_CtrlState = "D") or (CLW_WinStyle & 0xC80000 = 0xC80000) )
			{
				Gosub, NWD_SetAllOff
				WinClose, ahk_id %NWD_WinID%
				SYS_ToolTipText = Window Close
				Gosub, SYS_ToolTipFeedbackShow
			}
		}
	}
	Else
	{
		; TODO : workaround for "MouseClick, LEFT, , , 2" due to inactive titlebar problem
		
		Thread, Priority, 1
		CoordMode, Mouse, Screen
		MouseGetPos, CLW_MouseX, CLW_MouseY
		MouseClick, LEFT, %CLW_MouseX%, %CLW_MouseY%
		Sleep, 10
		MouseGetPos, CLW_MouseNewX, CLW_MouseNewY
		MouseClick, LEFT, %CLW_MouseX%, %CLW_MouseY%
		MouseMove, %CLW_MouseNewX%, %CLW_MouseNewY%
	}
Return



; [TSM {NWD}] toggles windows start menu || moves window to previous display || maximize to multiple windows on the left

/**
 * This additional button is used to toggle the windows start menu.
 */


; [MAW {NWD}] toggles window maximizing || moves window to next display || maximize to multiple windows on the right

/**
 * This additional button is used to toggle the maximize state of the active 
 * window (if maximizable).
 */

$XButton2::
$^XButton2::
	If ( NWD_ImmediateDown )
		Return
	
	IfWinActive, A
	{
		WinGet, MAW_WinID, ID
		If ( !MAW_WinID )
			Return
		WinGetClass, MAW_WinClass, ahk_id %MAW_WinID%
		If ( MAW_WinClass = "Progman" )
			Return
		
		GetKeyState, MAW_RButtonState, RButton, P
		If ( MAW_RButtonState = "U" )
		{
			GetKeyState, MAW_CtrlState, Ctrl, P
			WinGet, MAW_WinStyle, Style
			
			; the second condition checks for maximizable window:
			; (WS_CAPTION | WS_SYSMENU | WS_MAXIMIZEBOX)
			If ( (MAW_CtrlState = "D") or (MAW_WinStyle & 0xC90000 = 0xC90000) )
			{
				WinGet, MAW_MinMax, MinMax
				If ( MAW_MinMax = 0 )
				{
					WinMaximize
					SYS_ToolTipText = Window Maximize
					Gosub, SYS_ToolTipFeedbackShow
				}
				Else
					If ( MAW_MinMax = 1 )
					{
						WinRestore
						SYS_ToolTipText = Window Restore
						Gosub, SYS_ToolTipFeedbackShow
					}
			}
		}
		Else
		{
			Gosub, NWD_SetAllOff
			GetKeyState, MAW_CtrlState, Ctrl, P
			If ( MAW_CtrlState = "U" )
			{
				Send, ^>
				SYS_ToolTipText = Window Move: RIGHT
				Gosub, SYS_ToolTipFeedbackShow
			}
			; Else
			; TODO : maximize to multiple displays on the right (planned feature)
		}
	}
Return



; [TSW {NWD}] provides alt-tab-menu to the right mouse button + mouse wheel

/**
 * Provides a quick task switcher (alt-tab-menu) controlled by the mouse wheel.
 */

WheelDown::
	GetKeyState, TSW_RButtonState, RButton, P
	If ( (TSW_RButtonState = "D") and (!NWD_ImmediateDown) )
	{
		; TODO : this is a workaround because the original tabmenu 
		; code of AutoHotkey is buggy on some systems
		GetKeyState, TSW_LAltState, LAlt
		If ( TSW_LAltState = "U" )
		{
			Gosub, NWD_SetAllOff
			Send, {LAlt down}{Tab}
			SetTimer, TSW_WheelHandler, 1
		}
		Else
			Send, {Tab}
	}
	Else
		Send, {WheelDown}
Return

WheelUp::
	GetKeyState, TSW_RButtonState, RButton, P
	If ( (TSW_RButtonState = "D") and (!NWD_ImmediateDown) )
	{
		; TODO : this is a workaround because the original tabmenu 
		; code of AutoHotkey is buggy on some systems
		GetKeyState, TSW_LAltState, LAlt
		If ( TSW_LAltState = "U" )
		{
			Gosub, NWD_SetAllOff
			Send, {LAlt down}+{Tab}
			SetTimer, TSW_WheelHandler, 1
		}
		Else
			Send, +{Tab}
	}
	Else
		Send, {WheelUp}
Return

TSW_WheelHandler:
	GetKeyState, TSW_RButtonState, RButton, P
	If ( TSW_RButtonState = "U" )
	{
		SetTimer, TSW_WheelHandler, Off
		GetKeyState, TSW_LAltState, LAlt
		If ( TSW_LAltState = "D" )
			Send, {LAlt up}
	}
Return



; [AOT] toggles always on top

/**
 * Toggles the always-on-top attribute of the selected/active window.
 */

#SC029::
#LButton::
AOT_SetToggle:
	Gosub, AOT_CheckWinIDs
	SetWinDelay, -1
	
	IfInString, A_ThisHotkey, LButton
	{
		MouseGetPos, , , AOT_WinID
		If ( !AOT_WinID )
			Return
		IfWinNotActive, ahk_id %AOT_WinID%
			WinActivate, ahk_id %AOT_WinID%
	}
	
	IfWinActive, A
	{
		WinGet, AOT_WinID, ID
		If ( !AOT_WinID )
			Return
		WinGetClass, AOT_WinClass, ahk_id %AOT_WinID%
		If ( AOT_WinClass = "Progman" )
			Return
			
		WinGet, AOT_ExStyle, ExStyle, ahk_id %AOT_WinID%
		If ( AOT_ExStyle & 0x8 ) ; 0x8 is WS_EX_TOPMOST
		{
			SYS_ToolTipText = Always on Top: OFF
			Gosub, AOT_SetOff
		}
		Else
		{
			SYS_ToolTipText = Always on Top: ON
			Gosub, AOT_SetOn
		}
		Gosub, SYS_ToolTipFeedbackShow
	}
Return

AOT_SetOn:
	Gosub, AOT_CheckWinIDs
	SetWinDelay, -1
	IfWinNotExist, ahk_id %AOT_WinID%
		Return
	IfNotInString, AOT_WinIDs, |%AOT_WinID%
		AOT_WinIDs = %AOT_WinIDs%|%AOT_WinID%
	WinSet, AlwaysOnTop, On, ahk_id %AOT_WinID%
Return

AOT_SetOff:
	Gosub, AOT_CheckWinIDs
	SetWinDelay, -1
	IfWinNotExist, ahk_id %AOT_WinID%
		Return
	StringReplace, AOT_WinIDs, AOT_WinIDs, |%A_LoopField%, , All
	WinSet, AlwaysOnTop, Off, ahk_id %AOT_WinID%
Return

AOT_SetAllOff:
	Gosub, AOT_CheckWinIDs
	Loop, Parse, AOT_WinIDs, |
		If ( A_LoopField )
		{
			AOT_WinID = %A_LoopField%
			Gosub, AOT_SetOff
		}
Return

#^SC029::
	Gosub, AOT_SetAllOff
	SYS_ToolTipText = Always on Top: ALL OFF
	Gosub, SYS_ToolTipFeedbackShow
Return

AOT_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, AOT_WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
				StringReplace, AOT_WinIDs, AOT_WinIDs, |%A_LoopField%, , All
Return

AOT_ExitHandler:
	Gosub, AOT_SetAllOff
Return



; [ROL] rolls up/down a window to/from its title bar

ROL_RollToggle:
	Gosub, ROL_CheckWinIDs
	SetWinDelay, -1
	IfWinNotExist, ahk_id %ROL_WinID%
		Return
	WinGetClass, ROL_WinClass, ahk_id %ROL_WinID%
	If ( ROL_WinClass = "Progman" )
		Return
	
	IfNotInString, ROL_WinIDs, |%ROL_WinID%
	{
		; SYS_ToolTipText = Window Roll: UP
		Gosub, ROL_RollUp
	}
	Else
	{
		WinGetPos, , , , ROL_WinHeight, ahk_id %ROL_WinID%
		If ( ROL_WinHeight = ROL_WinRolledHeight%ROL_WinID% )
		{
			; SYS_ToolTipText = Window Roll: DOWN
			Gosub, ROL_RollDown
		}
		Else
		{
			; SYS_ToolTipText = Window Roll: UP
			Gosub, ROL_RollUp
		}
	}
	Gosub, SYS_ToolTipFeedbackShow
Return

ROL_RollUp:
	Gosub, ROL_CheckWinIDs
	SetWinDelay, -1
	IfWinNotExist, ahk_id %ROL_WinID%
		Return
	WinGetClass, ROL_WinClass, ahk_id %ROL_WinID%
	If ( ROL_WinClass = "Progman" )
		Return
	
	WinGetPos, , , , ROL_WinHeight, ahk_id %ROL_WinID%
	IfInString, ROL_WinIDs, |%ROL_WinID%
		If ( ROL_WinHeight = ROL_WinRolledHeight%ROL_WinID% ) 
			Return
	SysGet, ROL_CaptionHeight, 4 ; SM_CYCAPTION
	SysGet, ROL_BorderHeight, 7 ; SM_CXDLGFRAME
	If ( ROL_WinHeight > (ROL_CaptionHeight + ROL_BorderHeight) )
	{
		IfNotInString, ROL_WinIDs, |%ROL_WinID%
			ROL_WinIDs = %ROL_WinIDs%|%ROL_WinID%
		ROL_WinOriginalHeight%ROL_WinID% := ROL_WinHeight
		WinMove, ahk_id %ROL_WinID%, , , , , (ROL_CaptionHeight + ROL_BorderHeight)
		WinGetPos, , , , ROL_WinRolledHeight%ROL_WinID%, ahk_id %ROL_WinID%
	}
Return

ROL_RollDown:
	Gosub, ROL_CheckWinIDs
	SetWinDelay, -1
	If ( !ROL_WinID )
		Return
	IfNotInString, ROL_WinIDs, |%ROL_WinID%
		Return
	WinGetPos, , , , ROL_WinHeight, ahk_id %ROL_WinID%
	If( ROL_WinHeight = ROL_WinRolledHeight%ROL_WinID% )
		WinMove, ahk_id %ROL_WinID%, , , , , ROL_WinOriginalHeight%ROL_WinID%
	StringReplace, ROL_WinIDs, ROL_WinIDs, |%ROL_WinID%, , All
	ROL_WinOriginalHeight%ROL_WinID% =
	ROL_WinRolledHeight%ROL_WinID% =
Return

ROL_RollDownAll:
	Gosub, ROL_CheckWinIDs
	Loop, Parse, ROL_WinIDs, |
		If ( A_LoopField )
		{
			ROL_WinID = %A_LoopField%
			Gosub, ROL_RollDown
		}
Return

#^r::
	Gosub, ROL_RollDownAll
	SYS_ToolTipText = Window Roll: ALL DOWN
	Gosub, SYS_ToolTipFeedbackShow
Return

ROL_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, ROL_WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
			{
				StringReplace, ROL_WinIDs, ROL_WinIDs, |%A_LoopField%, , All
				ROL_WinOriginalHeight%A_LoopField% =
				ROL_WinRolledHeight%A_LoopField% =
			}
Return

ROL_ExitHandler:
	Gosub, ROL_RollDownAll
Return



; [TRA] provides window transparency

/**
 * Adjusts the transparency of the active window in ten percent steps 
 * (opaque = 100%) which allows the contents of the windows behind it to shine 
 * through. If the window is completely transparent (0%) the window is still 
 * there and clickable. If you loose a transparent window it will be extremly 
 * complicated to find it again because it's invisible (see the first hotkey 
 * in this list for emergency help in such situations). 
 */

#WheelUp::
#+WheelUp::
#WheelDown::
#+WheelDown::
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	IfWinActive, A
	{
		WinGet, TRA_WinID, ID
		If ( !TRA_WinID )
			Return
		WinGetClass, TRA_WinClass, ahk_id %TRA_WinID%
		If ( TRA_WinClass = "Progman" )
			Return
		
		IfNotInString, TRA_WinIDs, |%TRA_WinID%
			TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
		TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%
		TRA_PixelColor := TRA_PixelColor%TRA_WinID%
		
		IfInString, A_ThisHotkey, +
			TRA_WinAlphaStep := 255 * 0.01 ; 1 percent steps
		Else
			TRA_WinAlphaStep := 255 * 0.1 ; 10 percent steps

		If ( TRA_WinAlpha = "" )
			TRA_WinAlpha = 255

		IfInString, A_ThisHotkey, WheelDown
			TRA_WinAlpha -= TRA_WinAlphaStep
		Else
			TRA_WinAlpha += TRA_WinAlphaStep

		If ( TRA_WinAlpha > 255 )
			TRA_WinAlpha = 255
		Else
			If ( TRA_WinAlpha < 0 )
				TRA_WinAlpha = 0

		If ( !TRA_PixelColor and (TRA_WinAlpha = 255) )
		{
			Gosub, TRA_TransparencyOff
			SYS_ToolTipText = Transparency: OFF
		}
		Else
		{
			TRA_WinAlpha%TRA_WinID% = %TRA_WinAlpha%

			If ( TRA_PixelColor )
				WinSet, TransColor, %TRA_PixelColor% %TRA_WinAlpha%, ahk_id %TRA_WinID%
			Else
				WinSet, Transparent, %TRA_WinAlpha%, ahk_id %TRA_WinID%

			TRA_ToolTipAlpha := TRA_WinAlpha * 100 / 255
			Transform, TRA_ToolTipAlpha, Round, %TRA_ToolTipAlpha%
			SYS_ToolTipText = Transparency: %TRA_ToolTipAlpha% `%
		}
		Gosub, SYS_ToolTipFeedbackShow
	}
Return

;#^LButton::
;#^MButton::
;	Gosub, TRA_CheckWinIDs
;	SetWinDelay, -1
;	CoordMode, Mouse, Screen
;	CoordMode, Pixel, Screen
;	MouseGetPos, TRA_MouseX, TRA_MouseY, TRA_WinID
;	If ( !TRA_WinID )
;		Return
;	WinGetClass, TRA_WinClass, ahk_id %TRA_WinID%
;	If ( TRA_WinClass = "Progman" )
;		Return
	
;	IfWinNotActive, ahk_id %TRA_WinID%
;		WinActivate, ahk_id %TRA_WinID%
;	IfNotInString, TRA_WinIDs, |%TRA_WinID%
;		TRA_WinIDs = %TRA_WinIDs%|%TRA_WinID%
	
;	IfInString, A_ThisHotkey, MButton
;	{
;		AOT_WinID = %TRA_WinID%
;		Gosub, AOT_SetOn
;		TRA_WinAlpha%TRA_WinID% := 25 * 255 / 100
;	}
	
;	TRA_WinAlpha := TRA_WinAlpha%TRA_WinID%
	
	; TODO : the transparency must be set off first, 
	; this may be a bug of AutoHotkey
	WinSet, TransColor, OFF, ahk_id %TRA_WinID%
	PixelGetColor, TRA_PixelColor, %TRA_MouseX%, %TRA_MouseY%, RGB
	WinSet, TransColor, %TRA_PixelColor% %TRA_WinAlpha%, ahk_id %TRA_WinID%
	TRA_PixelColor%TRA_WinID% := TRA_PixelColor

	IfInString, A_ThisHotkey, MButton
		SYS_ToolTipText = Transparency: 25 `% + %TRA_PixelColor% color (RGB) + Always on Top
	Else
		SYS_ToolTipText = Transparency: %TRA_PixelColor% color (RGB)
	Gosub, SYS_ToolTipFeedbackShow
Return

#MButton::
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	MouseGetPos, , , TRA_WinID
	If ( !TRA_WinID )
		Return
	IfWinNotActive, ahk_id %TRA_WinID%
		WinActivate, ahk_id %TRA_WinID%
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		Return
	Gosub, TRA_TransparencyOff

	SYS_ToolTipText = Transparency: OFF
	Gosub, SYS_ToolTipFeedbackShow
Return

TRA_TransparencyOff:
	Gosub, TRA_CheckWinIDs
	SetWinDelay, -1
	If ( !TRA_WinID )
		Return
	IfNotInString, TRA_WinIDs, |%TRA_WinID%
		Return
	StringReplace, TRA_WinIDs, TRA_WinIDs, |%TRA_WinID%, , All
	TRA_WinAlpha%TRA_WinID% =
	TRA_PixelColor%TRA_WinID% =
	; TODO : must be set to 255 first to avoid the black-colored-window problem
	WinSet, Transparent, 255, ahk_id %TRA_WinID%
	WinSet, TransColor, OFF, ahk_id %TRA_WinID%
	WinSet, Transparent, OFF, ahk_id %TRA_WinID%
	WinSet, Redraw, , ahk_id %TRA_WinID%
Return

TRA_TransparencyAllOff:
	Gosub, TRA_CheckWinIDs
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
		{
			TRA_WinID = %A_LoopField%
			Gosub, TRA_TransparencyOff
		}
Return

#^t::
	Gosub, TRA_TransparencyAllOff
	SYS_ToolTipText = Transparency: ALL OFF
	Gosub, SYS_ToolTipFeedbackShow
Return

TRA_CheckWinIDs:
	DetectHiddenWindows, On
	Loop, Parse, TRA_WinIDs, |
		If ( A_LoopField )
			IfWinNotExist, ahk_id %A_LoopField%
			{
				StringReplace, TRA_WinIDs, TRA_WinIDs, |%A_LoopField%, , All
				TRA_WinAlpha%A_LoopField% =
				TRA_PixelColor%A_LoopField% =
			}
Return

TRA_ExitHandler:
	Gosub, TRA_TransparencyAllOff
Return



; [SCR] starts the user defined screensaver

/**
 * Starts the user defined screensaver (password protection aware). 
 */

#^!s up::
	RegRead, SCR_Saver, HKEY_CURRENT_USER, Control Panel\Desktop, SCRNSAVE.EXE
	If ( !ErrorLevel and SCR_Saver )
	{
		SendMessage, 0x112, 0xF140, 0, , Program Manager ; 0x112 is WM_SYSCOMMAND ; 0xF140 is SC_SCREENSAVE
		
		If ( A_ThisHotkey != "^#s up" )
			Return
		
		SplitPath, SCR_Saver, SCR_SaverFileName
		Process, Wait, %SCR_SaverFileName%, 5
		If ( ErrorLevel )
		{
			Gosub, SUS_SuspendSaveState
			Suspend, On
			Sleep, 5000
			Gosub, SUS_SuspendRestoreState
			Process, Exist, %SCR_SaverFileName%
			If ( ErrorLevel )
				SendMessage, 0x112, 0xF170, 2, , Program Manager ; 0x112 is WM_SYSCOMMAND ; 0xF170 is SC_MONITORPOWER ; (2 = off, 1 = standby, -1 = on)
		}
	}
	Else
	{
		SYS_TrayTipText = No screensaver specified in display settings (control panel).
		SYS_TrayTipOptions = 2
		Gosub, SYS_TrayTipShow
	}
Return



; [SIZ {NWD}] provides several size adjustments to windows

/**
 * Adjusts the transparency of the active window in ten percent steps 
 * (opaque = 100%) which allows the contents of the windows behind it to shine 
 * through. If the window is completely transparent (0%) the window is still 
 * there and clickable. If you loose a transparent window it will be extremly 
 * complicated to find it again because it's invisible (see the first hotkey in 
 * this list for emergency help in such situations). 
 */

!WheelUp::
!+WheelUp::
!^WheelUp::
!#WheelUp::
!+^WheelUp::
!+#WheelUp::
!^#WheelUp::
!+^#WheelUp::
!WheelDown::
!+WheelDown::
!^WheelDown::
!#WheelDown::
!+^WheelDown::
!+#WheelDown::
!^#WheelDown::
!+^#WheelDown::
	; TODO : the following code block is a workaround to handle 
	; virtual ALT calls in WheelDown/Up functions
	GetKeyState, SIZ_AltState, Alt, P
	If ( SIZ_AltState = "U" )
	{
		IfInString, A_ThisHotkey, WheelDown
			Gosub, WheelDown
		Else
			Gosub, WheelUp
		Return
	}

	If ( NWD_Dragging or NWD_ImmediateDown )
		Return
	
	SetWinDelay, -1
	CoordMode, Mouse, Screen
	IfWinActive, A
	{
		WinGet, SIZ_WinID, ID
		If ( !SIZ_WinID )
			Return
		WinGetClass, SIZ_WinClass, ahk_id %SIZ_WinID%
		If ( SIZ_WinClass = "Progman" )
			Return
		
		GetKeyState, SIZ_CtrlState, Ctrl, P
		WinGet, SIZ_WinMinMax, MinMax, ahk_id %SIZ_WinID%
		WinGet, SIZ_WinStyle, Style, ahk_id %SIZ_WinID%

		; checks wheter the window isn't maximized and has a sizing border (WS_THICKFRAME)
		If ( (SIZ_CtrlState = "D") or ((SIZ_WinMinMax != 1) and (SIZ_WinStyle & 0x40000)) )
		{
			WinGetPos, SIZ_WinX, SIZ_WinY, SIZ_WinW, SIZ_WinH, ahk_id %SIZ_WinID%
			
			If ( SIZ_WinW and SIZ_WinH )
			{
				SIZ_AspectRatio := SIZ_WinW / SIZ_WinH

				IfInString, A_ThisHotkey, WheelDown
					SIZ_Direction = 1
				Else
					SIZ_Direction = -1
				
				IfInString, A_ThisHotkey, +
					SIZ_Factor = 0.01
				Else
					SIZ_Factor = 0.1
				
				SIZ_WinNewW := SIZ_WinW + SIZ_Direction * SIZ_WinW * SIZ_Factor
				SIZ_WinNewH := SIZ_WinH + SIZ_Direction * SIZ_WinH * SIZ_Factor
				
				IfInString, A_ThisHotkey, #
				{
					SIZ_WinNewX := SIZ_WinX + (SIZ_WinW - SIZ_WinNewW) / 2
					SIZ_WinNewY := SIZ_WinY + (SIZ_WinH - SIZ_WinNewH) / 2
				}
				Else
				{
					SIZ_WinNewX := SIZ_WinX
					SIZ_WinNewY := SIZ_WinY
				}
				
				If ( SIZ_WinNewW > A_ScreenWidth )
				{
					SIZ_WinNewW := A_ScreenWidth
					SIZ_WinNewH := SIZ_WinNewW / SIZ_AspectRatio
				}
				If ( SIZ_WinNewH > A_ScreenHeight )
				{
					SIZ_WinNewH := A_ScreenHeight
					SIZ_WinNewW := SIZ_WinNewH * SIZ_AspectRatio
				}
				
				Transform, SIZ_WinNewX, Round, %SIZ_WinNewX%
				Transform, SIZ_WinNewY, Round, %SIZ_WinNewY%
				Transform, SIZ_WinNewW, Round, %SIZ_WinNewW%
				Transform, SIZ_WinNewH, Round, %SIZ_WinNewH%
				
				WinMove, ahk_id %SIZ_WinID%, , SIZ_WinNewX, SIZ_WinNewY, SIZ_WinNewW, SIZ_WinNewH
				
				If ( SYS_ToolTipFeedback )
				{
					WinGetPos, SIZ_ToolTipWinX, SIZ_ToolTipWinY, SIZ_ToolTipWinW, SIZ_ToolTipWinH, ahk_id %SIZ_WinID%
					SYS_ToolTipText = Window Size: (X:%SIZ_ToolTipWinX%, Y:%SIZ_ToolTipWinY%, W:%SIZ_ToolTipWinW%, H:%SIZ_ToolTipWinH%)
					Gosub, SYS_ToolTipFeedbackShow
				}
			}
		}
	}
Return

!NumpadAdd::
!^NumpadAdd::
!#NumpadAdd::
!^#NumpadAdd::
!NumpadSub::
!^NumpadSub::
!#NumpadSub::
!^#NumpadSub::
	If ( NWD_Dragging or NWD_ImmediateDown )
		Return

	SetWinDelay, -1
	CoordMode, Mouse, Screen
	IfWinActive, A
	{
		WinGet, SIZ_WinID, ID
		If ( !SIZ_WinID )
			Return
		WinGetClass, SIZ_WinClass, ahk_id %SIZ_WinID%
		If ( SIZ_WinClass = "Progman" )
			Return
		
		GetKeyState, SIZ_CtrlState, Ctrl, P
		WinGet, SIZ_WinMinMax, MinMax, ahk_id %SIZ_WinID%
		WinGet, SIZ_WinStyle, Style, ahk_id %SIZ_WinID%

		; checks wheter the window isn't maximized and has a sizing border (WS_THICKFRAME)
		If ( (SIZ_CtrlState = "D") or ((SIZ_WinMinMax != 1) and (SIZ_WinStyle & 0x40000)) )
		{
			WinGetPos, SIZ_WinX, SIZ_WinY, SIZ_WinW, SIZ_WinH, ahk_id %SIZ_WinID%
			
			IfInString, A_ThisHotkey, NumpadAdd
				If ( SIZ_WinW < 160 )
					SIZ_WinNewW = 160
				Else
					If ( SIZ_WinW < 320 )
						SIZ_WinNewW = 320
					Else
						If ( SIZ_WinW < 640 )
							SIZ_WinNewW = 640
						Else
							If ( SIZ_WinW < 800 )
								SIZ_WinNewW = 800
							Else
								If ( SIZ_WinW < 1024 )
									SIZ_WinNewW = 1024
								Else
									If ( SIZ_WinW < 1152 )
										SIZ_WinNewW = 1152
									Else
										If ( SIZ_WinW < 1280 )
											SIZ_WinNewW = 1280
										Else
											If ( SIZ_WinW < 1400 )
												SIZ_WinNewW = 1400
											Else
												If ( SIZ_WinW < 1600 )
													SIZ_WinNewW = 1600
												Else
													SIZ_WinNewW = 1920
			Else
				If ( SIZ_WinW <= 320 )
					SIZ_WinNewW = 160
				Else
					If ( SIZ_WinW <= 640 )
						SIZ_WinNewW = 320
					Else
						If ( SIZ_WinW <= 800 )
							SIZ_WinNewW = 640
						Else
							If ( SIZ_WinW <= 1024 )
								SIZ_WinNewW = 800
							Else
								If ( SIZ_WinW <= 1152 )
									SIZ_WinNewW = 1024
								Else
									If ( SIZ_WinW <= 1280 )
										SIZ_WinNewW = 1152
									Else
										If ( SIZ_WinW <= 1400 )
											SIZ_WinNewW = 1280
										Else
											If ( SIZ_WinW <= 1600 )
												SIZ_WinNewW = 1400
											Else
												If ( SIZ_WinW <= 1920 )
													SIZ_WinNewW = 1600
												Else
													SIZ_WinNewW = 1920
			
			If ( SIZ_WinNewW > A_ScreenWidth )
				SIZ_WinNewW := A_ScreenWidth
			SIZ_WinNewH := 3 * SIZ_WinNewW / 4
			If ( SIZ_WinNewW = 1280 )
				SIZ_WinNewH := 1024
			
			IfInString, A_ThisHotkey, #
			{
				SIZ_WinNewX := SIZ_WinX + (SIZ_WinW - SIZ_WinNewW) / 2
				SIZ_WinNewY := SIZ_WinY + (SIZ_WinH - SIZ_WinNewH) / 2
			}
			Else
			{
				SIZ_WinNewX := SIZ_WinX
				SIZ_WinNewY := SIZ_WinY
			}
			
			Transform, SIZ_WinNewX, Round, %SIZ_WinNewX%
			Transform, SIZ_WinNewY, Round, %SIZ_WinNewY%
			Transform, SIZ_WinNewW, Round, %SIZ_WinNewW%
			Transform, SIZ_WinNewH, Round, %SIZ_WinNewH%
			
			WinMove, ahk_id %SIZ_WinID%, , SIZ_WinNewX, SIZ_WinNewY, SIZ_WinNewW, SIZ_WinNewH
			
			If ( SYS_ToolTipFeedback )
			{
				WinGetPos, SIZ_ToolTipWinX, SIZ_ToolTipWinY, SIZ_ToolTipWinW, SIZ_ToolTipWinH, ahk_id %SIZ_WinID%
				SYS_ToolTipText = Window Size: (X:%SIZ_ToolTipWinX%, Y:%SIZ_ToolTipWinY%, W:%SIZ_ToolTipWinW%, H:%SIZ_ToolTipWinH%)
				Gosub, SYS_ToolTipFeedbackShow
			}
		}
	}
Return



; [XWN] provides X Window like focus switching (focus follows mouse)

/**
 * Provided a 'X Window' like focus switching by mouse cursor movement. After 
 * activation of this feature (by using the responsible entry in the tray icon 
 * menu) the focus will follow the mouse cursor with a delayed focus change 
 * (after movement end) of 500 milliseconds (half a second). This feature is 
 * disabled per default to avoid any confusion due to the new user-interface-flow.
 */

XWN_FocusHandler:
	CoordMode, Mouse, Screen
	MouseGetPos, XWN_MouseX, XWN_MouseY, XWN_WinID
	If ( !XWN_WinID )
		Return
	
	If ( (XWN_MouseX != XWN_MouseOldX) or (XWN_MouseY != XWN_MouseOldY) )
	{
		IfWinNotActive, ahk_id %XWN_WinID%
			XWN_FocusRequest = 1
		Else
			XWN_FocusRequest = 0
		
		XWN_MouseOldX := XWN_MouseX
		XWN_MouseOldY := XWN_MouseY
		XWN_MouseMovedTickCount := A_TickCount
	}
	Else
		If ( XWN_FocusRequest and (A_TickCount - XWN_MouseMovedTickCount > 500) )
		{
			WinGetClass, XWN_WinClass, ahk_id %XWN_WinID%
			If ( XWN_WinClass = "Progman" )
				Return
			
			; checks wheter the selected window is a popup menu
			; (WS_POPUP) and !(WS_DLGFRAME | WS_SYSMENU | WS_THICKFRAME)
			WinGet, XWN_WinStyle, Style, ahk_id %XWN_WinID%
			If ( (XWN_WinStyle & 0x80000000) and !(XWN_WinStyle & 0x4C0000) )
				Return
			
			IfWinNotActive, ahk_id %XWN_WinID%
				WinActivate, ahk_id %XWN_WinID%
				
			XWN_FocusRequest = 0
		}
Return



; [GRP] groups windows for quick task switching

/**
 * Activates the next window in a process window group that was defined 
 * gradually before with the given CTRL modifier. This feature causes the first 
 * window of the responsible group to be activated. Using it a second time will 
 * activate the next window in the series and so on. By using process window 
 * groups you can organize and access your process windows in semantic groups 
 * quickly. 
 */

#!F1::
#!F2::
#!F3::
#!F4::
	IfWinActive, A
	{
		WinGet, GRP_WinID, ID
		If ( !GRP_WinID )
			Return
		WinGetClass, GRP_WinClass, ahk_id %GRP_WinID%
		If ( GRP_WinClass = "Progman" )
			Return
		WinGet, GRP_WinPID, PID
		If ( !GRP_WinPID )
			Return
			
		StringMid, GRP_GroupNumber, A_ThisHotkey, 3, 3
		GroupAdd, Group%GRP_GroupNumber%, ahk_PID %GRP_WinPID%
		
		SYS_ToolTipText = Active window was added to group %GRP_GroupNumber%.
		Gosub, SYS_ToolTipFeedbackShow
	}
Return

!F1::
!F2::
!F3::
!F4::
	StringMid, GRP_GroupNumber, A_ThisHotkey, 2, 3
	GroupActivate, Group%GRP_GroupNumber%
	
	SYS_ToolTipText = Activated next window in group %GRP_GroupNumber%.
	Gosub, SYS_ToolTipFeedbackShow
Return

;!#F1::
;!#F2::
;!#F3::
;!#F4::
!#F5::
!#F6::
!#F7::
!#F8::
!#F9::
!#F10::
;!#F11::
!#F12::
!#F13::
!#F14::
!#F15::
!#F16::
!#F17::
!#F18::
!#F19::
!#F20::
!#F21::
!#F22::
!#F23::
!#F24::
	StringMid, GRP_GroupNumber, A_ThisHotkey, 3, 3
	GroupClose, Group%GRP_GroupNumber%, A
	
	SYS_ToolTipText = Closed all windows in group %GRP_GroupNumber%.
	Gosub, SYS_ToolTipFeedbackShow
Return


; [TRY] handles the tray icon/menu

TRY_TrayInit:
	Menu, TRAY, NoStandard
	Menu, TRAY, Tip, %SYS_ScriptInfo%

	If ( !A_IsCompiled )
	{
		Menu, AutoHotkey, Standard
		Menu, TRAY, Add, AutoHotkey, :AutoHotkey
		Menu, TRAY, Add
	}

	Menu, TRAY, Add, Help, TRY_TrayEvent
	Menu, TRAY, Default, Help
	Menu, TRAY, Add
	Menu, TRAY, Add, About, TRY_TrayEvent
	Menu, TRAY, Add
	Menu, TRAY, Add, Mail Author, TRY_TrayEvent
	Menu, TRAY, Add, View License, TRY_TrayEvent
	Menu, TRAY, Add, Visit Website, TRY_TrayEvent
	Menu, TRAY, Add, Check For Update, TRY_TrayEvent
	Menu, TRAY, Add

	Menu, MouseHooks, Add, Left Mouse Button, TRY_TrayEvent
	Menu, MouseHooks, Add, Middle Mouse Button, TRY_TrayEvent
	Menu, MouseHooks, Add, Right Mouse Button, TRY_TrayEvent
	Menu, MouseHooks, Add, Fourth Mouse Button, TRY_TrayEvent
	Menu, MouseHooks, Add, Fifth Mouse Button, TRY_TrayEvent
	Menu, TRAY, Add, Mouse Hooks, :MouseHooks

	Menu, TRAY, Add, ToolTip Feedback, TRY_TrayEvent
	Menu, TRAY, Add, Auto Suspend, TRY_TrayEvent
	Menu, TRAY, Add, Focus Follows Mouse, TRY_TrayEvent
	Menu, TRAY, Add, Suspend All Hooks, TRY_TrayEvent
	Menu, TRAY, Add, Revert Visual Effects, TRY_TrayEvent
	Menu, TRAY, Add, Hide Tray Icon, TRY_TrayEvent
	Menu, TRAY, Add
	Menu, TRAY, Add, Exit, TRY_TrayEvent
	
	Gosub, TRY_TrayUpdate

	If ( A_IconHidden )
		Menu, TRAY, Icon
Return

TRY_TrayUpdate:
	If ( CFG_LeftMouseButtonHook )
		Menu, MouseHooks, Check, Left Mouse Button
	Else
		Menu, MouseHooks, UnCheck, Left Mouse Button
	If ( CFG_MiddleMouseButtonHook )
		Menu, MouseHooks, Check, Middle Mouse Button
	Else
		Menu, MouseHooks, UnCheck, Middle Mouse Button
	If ( CFG_RightMouseButtonHook )
		Menu, MouseHooks, Check, Right Mouse Button
	Else
		Menu, MouseHooks, UnCheck, Right Mouse Button
	If ( CFG_FourthMouseButtonHook )
		Menu, MouseHooks, Check, Fourth Mouse Button
	Else
		Menu, MouseHooks, UnCheck, Fourth Mouse Button
	If ( CFG_FifthMouseButtonHook )
		Menu, MouseHooks, Check, Fifth Mouse Button
	Else
		Menu, MouseHooks, UnCheck, Fifth Mouse Button
	If ( SYS_ToolTipFeedback )
		Menu, TRAY, Check, ToolTip Feedback
	Else
		Menu, TRAY, UnCheck, ToolTip Feedback
	If ( SUS_AutoSuspend )
		Menu, TRAY, Check, Auto Suspend
	Else
		Menu, TRAY, UnCheck, Auto Suspend
	If ( XWN_FocusFollowsMouse )
		Menu, TRAY, Check, Focus Follows Mouse
	Else
		Menu, TRAY, UnCheck, Focus Follows Mouse
	If ( A_IsSuspended )
		Menu, TRAY, Check, Suspend All Hooks
	Else
		Menu, TRAY, UnCheck, Suspend All Hooks
Return

TRY_TrayEvent:
	If ( !TRY_TrayEvent )
		TRY_TrayEvent = %A_ThisMenuItem%
	
	If ( TRY_TrayEvent = "Help" )
		IfExist, %A_ScriptDir%\readme.txt
			Run, "%A_ScriptDir%\readme.txt"
		Else
		{
			SYS_TrayTipText = File couldn't be accessed:`n%A_ScriptDir%\readme.txt
			SYS_TrayTipOptions = 3
			Gosub, SYS_TrayTipShow
		}

	If ( TRY_TrayEvent = "About" )
	{
		SYS_TrayTipText = Copyright (c) 2004-2005 by Enovatic-Solutions.`nAll rights reserved. Use is subject to license terms.`n`nCompany:`tEnovatic-Solutions (IT Service Provider)`nAuthor:`t`tOliver Pfeiffer`, Bremen (GERMANY)`nEmail:`t`tniftywindows@enovatic.org
		Gosub, SYS_TrayTipShow
	}

	If ( TRY_TrayEvent = "Mail Author" )
		Run, mailto:niftywindows@enovatic.org?subject=%SYS_ScriptInfo% (build %SYS_ScriptBuild%)

	If ( TRY_TrayEvent = "View License" )
		IfExist, %A_ScriptDir%\license.txt
			Run, "%A_ScriptDir%\license.txt"
		Else
		{
			SYS_TrayTipText = File couldn't be accessed:`n%A_ScriptDir%\license.txt
			SYS_TrayTipOptions = 3
			Gosub, SYS_TrayTipShow
		}

	If ( TRY_TrayEvent = "Visit Website" )
		Run, http://www.enovatic.org/products/niftywindows/

	If ( TRY_TrayEvent = "ToolTip Feedback" )
		SYS_ToolTipFeedback := !SYS_ToolTipFeedback

	If ( TRY_TrayEvent = "Auto Suspend" )
	{
		SUS_AutoSuspend := !SUS_AutoSuspend
		Gosub, CFG_ApplySettings
	}

	If ( TRY_TrayEvent = "Focus Follows Mouse" )
	{
		XWN_FocusFollowsMouse := !XWN_FocusFollowsMouse
		Gosub, CFG_ApplySettings
	}

	If ( TRY_TrayEvent = "Suspend All Hooks" )
		Gosub, SUS_SuspendToggle
	
	If ( TRY_TrayEvent = "Revert Visual Effects" )
		Gosub, SYS_RevertVisualEffects

	If ( TRY_TrayEvent = "Hide Tray Icon" )
	{
		SYS_TrayTipText = Tray icon will be hidden now.`nPress WIN+X to show it again.
		SYS_TrayTipOptions = 2
		SYS_TrayTipSeconds = 5
		Gosub, SYS_TrayTipShow
		SetTimer, TRY_TrayHide, 5000
	}

	If ( TRY_TrayEvent = "Exit" )
		ExitApp

	If ( TRY_TrayEvent = "Left Mouse Button" )
	{
		CFG_LeftMouseButtonHook := !CFG_LeftMouseButtonHook
		Gosub, CFG_ApplySettings
	}
	
	If ( TRY_TrayEvent = "Middle Mouse Button" )
	{
		CFG_MiddleMouseButtonHook := !CFG_MiddleMouseButtonHook
		Gosub, CFG_ApplySettings
	}
	
	If ( TRY_TrayEvent = "Right Mouse Button" )
	{
		CFG_RightMouseButtonHook := !CFG_RightMouseButtonHook
		Gosub, CFG_ApplySettings
	}
	
	If ( TRY_TrayEvent = "Fourth Mouse Button" )
	{
		CFG_FourthMouseButtonHook := !CFG_FourthMouseButtonHook
		Gosub, CFG_ApplySettings
	}
	
	If ( TRY_TrayEvent = "Fifth Mouse Button" )
	{
		CFG_FifthMouseButtonHook := !CFG_FifthMouseButtonHook
		Gosub, CFG_ApplySettings
	}

	Gosub, TRY_TrayUpdate
	TRY_TrayEvent =
Return

TRY_TrayHide:
	SetTimer, TRY_TrayHide, Off
	Menu, TRAY, NoIcon
Return



; [EDT] edits this script in notepad

^#!F9::
	If ( A_IsCompiled )
		Return
	
	Gosub, SUS_SuspendSaveState
	Suspend, On
	MsgBox, 4129, Edit Handler - %SYS_ScriptInfo%, You pressed the hotkey for editing this script:`n`n%A_ScriptFullPath%`n`nDo you really want to edit?
	Gosub, SUS_SuspendRestoreState
	IfMsgBox, OK
		Run, notepad.exe %A_ScriptFullPath%
Return



; [REL] reloads this script on change

REL_ScriptReload:
	If ( A_IsCompiled )
		Return

	FileGetAttrib, REL_Attribs, %A_ScriptFullPath%
	IfInString, REL_Attribs, A
	{
		FileSetAttrib, -A, %A_ScriptFullPath%
		If ( REL_InitDone )
		{
			Gosub, SUS_SuspendSaveState
			Suspend, On
			MsgBox, 4145, Update Handler - %SYS_ScriptInfo%, The following script has changed:`n`n%A_ScriptFullPath%`n`nReload and activate this script?
			Gosub, SUS_SuspendRestoreState
			IfMsgBox, OK
				Reload
		}
	}
	REL_InitDone = 1
Return



; [CFG] handles the persistent configuration

CFG_LoadSettings:
	CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
	IniRead, SUS_AutoSuspend, %CFG_IniFile%, Main, AutoSuspend, 1
	IniRead, XWN_FocusFollowsMouse, %CFG_IniFile%, WindowHandling, FocusFollowsMouse, 0
	IniRead, SYS_ToolTipFeedback, %CFG_IniFile%, Visual, ToolTipFeedback, 1
	IniRead, UPD_LastUpdateCheck, %CFG_IniFile%, UpdateCheck, LastUpdateCheck, %A_MM%
	IniRead, CFG_LeftMouseButtonHook, %CFG_IniFile%, MouseHooks, LeftMouseButton, 1
	IniRead, CFG_MiddleMouseButtonHook, %CFG_IniFile%, MouseHooks, MiddleMouseButton, 1
	IniRead, CFG_RightMouseButtonHook, %CFG_IniFile%, MouseHooks, RightMouseButton, 1
	IniRead, CFG_FourthMouseButtonHook, %CFG_IniFile%, MouseHooks, FourthMouseButton, 1
	IniRead, CFG_FifthMouseButtonHook, %CFG_IniFile%, MouseHooks, FifthMouseButton, 1
Return

CFG_SaveSettings:
	CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
	IniWrite, %SUS_AutoSuspend%, %CFG_IniFile%, Main, AutoSuspend
	IniWrite, %XWN_FocusFollowsMouse%, %CFG_IniFile%, WindowHandling, FocusFollowsMouse
	IniWrite, %SYS_ToolTipFeedback%, %CFG_IniFile%, Visual, ToolTipFeedback
	IniWrite, %UPD_LastUpdateCheck%, %CFG_IniFile%, UpdateCheck, LastUpdateCheck
	IniWrite, %CFG_LeftMouseButtonHook%, %CFG_IniFile%, MouseHooks, LeftMouseButton
	IniWrite, %CFG_MiddleMouseButtonHook%, %CFG_IniFile%, MouseHooks, MiddleMouseButton
	IniWrite, %CFG_RightMouseButtonHook%, %CFG_IniFile%, MouseHooks, RightMouseButton
	IniWrite, %CFG_FourthMouseButtonHook%, %CFG_IniFile%, MouseHooks, FourthMouseButton
	IniWrite, %CFG_FifthMouseButtonHook%, %CFG_IniFile%, MouseHooks, FifthMouseButton
Return

CFG_ApplySettings:
	If ( SUS_AutoSuspend )
		SetTimer, SUS_SuspendHandler, 1000
	Else
		SetTimer, SUS_SuspendHandler, Off
		
	If ( XWN_FocusFollowsMouse )
		SetTimer, XWN_FocusHandler, 100
	Else
		SetTimer, XWN_FocusHandler, Off
		
	If ( CFG_LeftMouseButtonHook )
		CFG_LeftMouseButtonHookStr = On
	Else
		CFG_LeftMouseButtonHookStr = Off

	If ( CFG_MiddleMouseButtonHook )
		CFG_MiddleMouseButtonHookStr = On
	Else
		CFG_MiddleMouseButtonHookStr = Off

	If ( CFG_RightMouseButtonHook )
		CFG_RightMouseButtonHookStr = On
	Else
		CFG_RightMouseButtonHookStr = Off

	If ( CFG_FourthMouseButtonHook )
		CFG_FourthMouseButtonHookStr = On
	Else
		CFG_FourthMouseButtonHookStr = Off

	If ( CFG_FifthMouseButtonHook )
		CFG_FifthMouseButtonHookStr = On
	Else
		CFG_FifthMouseButtonHookStr = Off
	
	Hotkey, $LButton, %CFG_LeftMouseButtonHookStr%
	Hotkey, $^LButton, %CFG_LeftMouseButtonHookStr%
	Hotkey, #LButton, %CFG_LeftMouseButtonHookStr%
	
	Hotkey, #MButton, %CFG_MiddleMouseButtonHookStr%
	Hotkey, $MButton, %CFG_MiddleMouseButtonHookStr%
	Hotkey, $^MButton, %CFG_MiddleMouseButtonHookStr%
	
	Hotkey, $RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+!RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+^RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+!^RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+!#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+^#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $+!^#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $!RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $!^RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $!#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $!^#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $^RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $^#RButton, %CFG_RightMouseButtonHookStr%
	Hotkey, $#RButton, %CFG_RightMouseButtonHookStr%
	
	; Hotkey, $^XButton1, %CFG_FourthMouseButtonHookStr%
	
	Hotkey, $XButton2, %CFG_FifthMouseButtonHookStr%
	Hotkey, $^XButton2, %CFG_FifthMouseButtonHookStr%
Return



















































































































































































; ######################################################################################
; ÁREA DE TESTES
; ######################################################################################


; NVIDIA - MUDAR DISPLAY PRIMÁRIO <-- complicado
; Win+Shift+N
#+n::
send {tab 4}{right 4}
Sleep, 100
send !n
Sleep, 1500
send {tab 5}{right 5}
Sleep, 5000
send {tab 4}{up}
Sleep, 100
send !l
Sleep, 7000
send s
return


; TENTATIVA DE CÓPIA/COLA RÁPIDA PARA BARRA DE END DO FIREFOX <-- Posicionar as duas janelas em primeiro plano.
; RCtrl+L
>^l::
send ^c
Sleep, 250
send !{tab}
Sleep, 250
send ^l
Sleep, 250
send ^v
Sleep, 250
send {enter 2}
Sleep, 250
send !{tab}
return

RAlt & d::AltTab
RAlt & s::ShiftAltTab


; ######################################################################################
; FALTANDO DESCOBRIR/IMPLEMENTAR:
; ######################################################################################

/*
como fechar os itens da barra de tarefas simplesmente segurando alt+click
como agilizar o processo de copiar um texto no Firefox e colar na janela do Word.
hotkey para documento que tá sempre mudando de nome
manuseando 2 diferentes teclados
mapa visual de teclas em GUI como no comfortkeys
fazer com que Alt+Q seja = Ctrl+W e evitar a aparição dos ?.
multiple filecopy dos arquivos de backup, cruzar com data atual na criação do novo.
*/

/* como fechar um outro script aberto
/*
como substituir parte de uma palavra que está escrita errada como depressaõ para depressão configurando somente para a terminação. */

/* perguntar como que faz pra isso aqui só valer quando esta janela está ativa.
; SALVAR E RECARREGAR
NumpadEnter::
IfWinExist, D:\Docs\AHK\scripts\script.ahk - Notepad++
WinActivate  ; Automatically uses the window found above.
WinMaximize  ; same
Send, ^s
Reload
return */

; ctrl+w=alt+q

/*
; SOBRE NOTEPAD++:
 solicitar implementação de tecla de atalho com alt no find-replace
 solicitar poder fechar o documento com alt+q
 perguntar se tem como implementarem a descida de cursor inteligente que tem no textpad.
solicitar implementação de atalhos pra ftp_sync 
perguntar se tem como fazer com que arquivos.ahk sempre ativem a linguagem autoit automaticamente
*/


; ##########################################################################################
; COM PROBLEMAS:; ##########################################################################################


; FECHAR JANELA MAIS CONFORTAVELMENTE
; Alt+W
!w::!F4

; MINIMIZAR TUDO COMO COM WIN+M
; Win+'
#'::WinMinimizeAll

*/