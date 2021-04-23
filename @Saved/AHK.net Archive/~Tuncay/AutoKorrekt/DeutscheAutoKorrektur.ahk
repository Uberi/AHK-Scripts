/*
; ATTENTION! THIS COMMENT BLOCK IS IN INI FORMAT AND COULD BE USED AS INI FILE.
[META]
Source =                http://www.autohotkey.net/~Tuncay/AutoKorrekt/AutoKorrekt.zip
Discussion =            http://de.autohotkey.com/forum/viewtopic.php?t=1013
Language =              de
Name =                  Deutsche AutoKorrektur
Description =           Deutschsprachige Korrektur häufiger Tippfehler; generiert mit AutoKorrekt.
Date =                  2010-11-28 22:30
License =               Public Domain
Category =              Hotstrings/Hotkeys
Type =                  Application
AhkVersion =            1.0.48.05
Standalone =            Yes
StdLibConform =         No
*/

/*
Autocorrect German Wordlist 1
Die wordlist.txt ist eine Liste häufig falsch geschriebener Wörter für die Miranda Erweiterung "Auto Correct".
Quelle: http://addons.miranda-im.org/details.php?action=viewfile&id=3179
Herausgeber: cybery
*/

;------------------------------------------------------------------------------
; ANLEITUNG
; Bei Doppelklick auf das Tray Icon oder bei Auswahl im Menü "Pausieren" oder
; werden alle Hotstrings (Abkürzungen) kurzweilig ausgeschaltet.
;------------------------------------------------------------------------------

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Hotstring EndChars -()[]{}':;"/\,.?!`n `t
#Hotstring R ; R=raw
FileInstall, DeutscheAutoKorrektur.ahk, DeutscheAutoKorrektur.ahk

Menu, Tray, NoStandard
If (!A_IsCompiled)
{
    Menu, Tray, Add, Wörterliste neu laden, ReloadScript
}
Menu, Tray, Add, Pausieren, SuspendScript
    Menu, Tray, Default, Pausieren
Menu, Tray, Add, Beenden, ExitApp
Return

ExitApp:
ExitApp

SuspendScript:
Suspend, Toggle
If (A_IsSuspended)
{
    Menu, Tray, Rename, Pausieren, Aktivieren
}
Else
{
    Menu, Tray, Rename, Aktivieren, Pausieren
}
Return

ReloadScript:
Reload
Return

RETURN

::,)::;)
::,d as::, das
::,d ass::, dass
::.D:::D
:::9:::)
:::d:::D
:::p:::P
::;9::;)
::;p::;P
::adneren::anderen
::adners::anders
::ahb::hab
::amch::machen
::amchen::machen
::amchst::machst
::amg::mag
::asu::aus
::besuhc::besuch
::bruachst::brauchst
::bsi::bis
::bsit::bist
::chi::ich
::cih::ich
::datei::Datei
::ddas::das
::deshlab::deshalb
::diene::deine
::dnan::dann
::dnen::denn
::doer::oder
::doer::oder
::dönnie::dönni
::eabr::aber
::egschickt::geschickt
::ehct::echt
::eiegntlich::eigentlich
::eigenltich::eigentlich
::einfahc::einfach
::englishc::englisch
::englsich::englisch
::eni::ein
::erscheitn::erscheint
::fehtl::fehlt
::fidns::finds
::ga rnicht::gar nicht
::gcuken::gucken
::gefundne::gefunden
::genua::genau
::geschcihte::geschichte
::geschcikt::geschickt
::gitb::gibt
::gluab::glaub
::Grade::Gerade
::grade::gerade
::gukcen::gucken
::heir::hier
::hic::ich
::iegentlich::eigentlich
::imemr::immer
::iweder::wieder
::kansnt::kannst
::keien::keine
::komsmt::kommst
::komtm::kommt
::lansgsam::langsam
::lassne::lassen
::lsut::lust
::lsutig::lustig
::lust::Lust
::ma::mal
::Ma::Mal
::mahc::mach
::mahcs::machs
::mand as::man das
::mcih::mich
::meisnt::meinst
::mekrwürdig::merkwürdig
::mier::mir
::mihc::mich
::mla::mal
::mri::mir
::mri::mir
::msus::muss
::mti::mit
::nahc::nach
::nämlcih::nämlich
::nciht::nicht
::nciht::nicht
::nciht::nicht
::nciht::nicht
::ncihtmal::nichtmal
::ncith::nicht
::ncoh::noch
::ncohmal::nochmal
::ndan::dann
::nei::nie
::nichtmla::nichtmal
::nicth::nicht
::nihct::nicht
::nromalerweise::normalerweise
::nud::und
::ordneltich::ordentlich
::portemonaie::portemonnaie
::rechtschreibkorrektur::Rechtschreibkorrektur
::rechtschriebkorrektur::Rechtschreibkorrektur
::sbi::bis
::schciken::schicken
::schelcht::schlecht
::schlciht::schlicht
::schn::schon
::scon::schon
::sga::sag
::sgaen::sagen
::shcick::schick
::shcon::schon
::shconmal::schonmal
::shculden::schulden
::shon::schon
::sidn::sind
::sied::seid
::sien::sein
::sit::ist
::uach::auch
::uach::auch
::übirgens::übrigens
::übriegsn::übrigens
::udn::und
::usneres::unseres
::utn::tun
::verscuh::versuch
::vershicken::verschicken
::vershickt::verschickt
::vershikt::verschickt
::vielleciht::vielleicht
::vno::von
::wahrscheinlcih::wahrscheinlich
::wahrschienlich::wahrscheinlich
::weider::wieder
::welhces::welches
::wiel::weil
::wiso::wieso
::wnan::wann
::wnen::wenn
::wolte::wollte
::zeimlich::ziemlich
::abeiten::arbeiten
::Abnachung::Abmachung
::Accesoir::Accessoire
::Acksessoir::Accessoire
::adnere::andere
::adneren	::anderen
::adneres::anderes
::adners::anders
::Aksessoir::Accessoire
::aler::aller
::anderne::andere
::arbete::arbeite
::arbeten::arbeiten
::arbetest::arbeitest
::arbetet::arbeitet
::Argumnet::Argument
::Assessoir::Accessoire
::auslandisch::ausländisch
::Auswal::Auswahl
::awr::war
::beerits::bereits
::befor::bevor
::bekant::bekannt
::Bekante::Bekannte
::Bekanter::Bekannter
::bekantes::bekanntes
::Belästignug::Belästigung
::Belätsigung::Belästigung
::bereis::bereits
::Bescherde::Beschwerde
::bescämen::beschämen
::Bibliotekh::Bibliothek
::Bibliothrk::Bibliothek
::Belästigung::Belästigung
::Brauche nicht::brauche nicht
::brauchst nicht::brauchst nicht
::brauchtnicht::braucht nicht
::Buchsabe::Buchstabe
::Buchstbae::Buchstabe
::dachet::dachte
::darfnicht::darf nicht
::darfstnicht::darfst nicht
::daselbe::dasselbe
::Datein::Dateien
::dei::die
::deis::dies
::deise::diese
::deiser::dieser
::dekne::denke
::deknst::denkst
::dersselbe::derselbe
::diesre::dieser
::diesselbe::dieselbe
::dirr::dir
::dise::diese
::disees::dieses
::diser::dieser
::dna::dann
::Dnak::Dank
::dnake::danke
::Dockument::Dokument
::Dokkument::Dokument
::Dokumnet::Dokument
::dre::der
::dsa::das
::dubist::du bist
::dürfennicht::dürfen nicht
::edr::der
::ehielt::erhielt
::emfehlen::empfehlen
::empfelen::empfehlen
::empfelhen::empfehlen
::enige::einige
::eniges::einiges
::enldich::endlich
::Entwicklug::Entwicklung
::enu::neu
::Enwicklung::Entwicklung
::ereichen::erreichen
::ereicht::erreicht
::Erflg::Erfolg
::erhalen::erhalten
::erhaltn::erhalten
::erhlaten::erhalten
::erinern::erinnern
::erkennn::erkennen
::erknennen::erkennen
::erts::erst
::fandn::fanden
::fiden::finden
::findn::finden
::Firna::Firma
::fnad::fand
::fnaden::fanden
::fnadst::fandst
::Fnester::Fenster
::folgn::folgen
::folgnd::folgend
::follgen::folgen
::follgend::folgend
::follgende::folgende
::follgender::folgender
::follgendes::folgendes
::Forfall::Vorfall
::fpr::für
::Fra::Frau
::Fraeg::Frage
::fragn::fragen
::Freudne::Freunde
::Freundinen::Freundinnen
::Frima::Firma
::Fru::Frau
::fsat::fast
::fäöschlich::fälschlich
::Garanti::Garantie
::Garrantie::Garantie
::Gechichte::Geschichte
::Gecshichte::Geschichte
::Gefar::Gefahr
::gehn::gehen
::gehts::geht’s
::Geidcht::Gedicht
::Gelegenhet::Gelegenheit
::Gelgenheit::Gelegenheit
::geradde::gerade
::Geschichtne::Geschichten
::Geshichte::Geschichte
::ghe::gehe
::ghen::gehen
::ghest::gehst
::gibts::gibt’s
::glaben::glauben
::glaubn::glauben
::gnaz::ganz
::Grupe::Gruppe
::gschehen::geschehen
::habenicht::habe nicht
::habn::haben
::haett::hatte
::hastnicht::hast nicht
::hatnicht::hat nicht
::hbe::habe
::hoffendlich::hoffentlich
::hst::hast
::ht::hat
::huete::heute
::Hypotek::Hypothek
::ide::die
::ien::ein
::iene::eine
::ienes::eines
::ienige::einige
::ieniges::einiges
::ieronisch::ironisch
::ih::ich
::ihc::ich
::imer::immer
::inRichtung::in Richtung
::interrim::interim
::Intriege::Intrige
::intriegieren::intrigieren
::Intrife::Intrige
::ires::ihres
::its::ist
::Jare::Jahre
::jettz::jetzt
::jezt::jetzt
::Jhar::Jahr
::kalrer::klarer
::kan::kann
::kannicht::kann nicht
::kannnicht::kann nicht
::kien::kein
::kiene::keine
::kienes::keines
::kiense::keines
::klin::klein
::klint::klingt
::klnnen::können
::klr::klar
::klra::klar
::kna::kann
::Komite::Komitee
::Komittee::Komitee
::Kommitee::Komitee
::Kommittee::Komitee
::Kompreßion::Kompression
::komunizieren::kommunizieren
::konte::konnte
::koonte::konnte
::Kopei::Kopie
::Kres::Kreis
::könte::könnte
::Labaratorium::Laboratorium
::Labbor::Labor
::Labohratorium::Laboratorium
::lebn::leben
::Leistnug::Leistung
::Leistug::Leistung
::Leisung::Leistung
::Lestung::Leistung
::Libe::Liebe
::Liestung::Leistung
::Lizentz::Lizenz
::Luete::Leute
::macen::machen
::machn::machen
::macst::machst
::Mact::Macht
::macte::machte
::magts::magst
::Mathemaitk::Mathematik
::Mathematikk::Mathematik
::Mathemetik::Mathematik
::Mathrmatik::Mathematik
::Mattematik::Mathematik
::mene::meine
::Mesnchen::Menschen
::mfg::Mit freundlichen Grüßen
::mga::mag
::michselbst::mich selbst
::mirselbst::mir selbst
::mocte::mochte
::mti::mit
::möcht::möchte
::nachste::nächste
::nachster::nächster
::nachstes::nächstes
::nciht::nicht
::nehmem::nehmen
::nemen::nehmen
::Nihcte::Nichte
::nimst::nimmst
::nltig::nötig
::Nunner::Nummer
::nurr::nur
::nähmlich::nämlich
::nätig::nötig
::Nörigung::Nötigung
::oaky::okay
::ofenbar::offenbar
::ofensichtlich::offensichtlich
::offensicgtlich::offensichtlich
::offensichylich::offensichtlich
::pber::über
::pbertreiben::übertreiben
::Piknick::Picknick
::Piknik::Picknick
::Porblem::Problem
::Porzelan::Porzellan
::Porzellam::Porzellan
::Porzellna::Porzellan
::Potzellan::Porzellan
::Prioität::Priorität
::priorität::Priorität
::Problen::Problem
::Prozellan::Porzellan
::Psycgologie::Psychologie
::Rechnug::Rechnung
::Rekrod::Rekord
::Rhytmus::Rhythmus
::Rythmus::Rhythmus
::Rytmus::Rhythmus
::Sachem::Sachen
::Sahce::Sache
::schonn::schon
::schrebe::schreibe
::schrebst::schreibst
::schreibn::schreiben
::schriben::schreiben
::scon::schon
::Seckretärin::Sekretärin
::seinse::seines
::Sekretätin::Sekretärin
::seperat::separat
::serh::sehr
::seteht::steht
::sgdh::Sehr geehrte Damen und Herren
::sichausdenken::sich ausdenken
::sien::sein
::siene::seine
::sienem::seinem
::sienes::seines
::sioe::sie
::slebst::selbst
::solltenicht::sollte nicht
::solltennicht::sollten nicht
::solltestnicht::solltest nicht
::solte::sollte
::solten::sollten
::soltest::solltest
::sparch::sprach
::spircht::spricht
::sprechn::sprechen
::sprischt::sprichst
::steen::stehen
::stpo::stopp
::Stärkke::Stärke
::synonüm::synonym
::sünonym::synonym
::sünonüm::synonym
::tirnkst::trinkst
::tnu::tun
::Traume::Träume
::trinkn::trinken
::trint::trinkt
::täusvhen::täuschen
::uas::aus
::ud::du
::udn::und
::umbedingt::unbedingt
::Unabhägnigkeit::Unabhängigkeit
::Unabhängigket::Unabhängigkeit
::Unahangigkeit::Unabhängigkeit
::unbdingt::unbedingt
::unbedinkt::unbedingt
::unbedint::unbedingt
::unddas::und das
::undder::und der
::unddie::und die
::unrerbringen::unterbringen
::unterbingen::unterbringen
::Unterbingung::Unterbringung
::Unterbrignug::Unterbringung
::unzufriden::unzufrieden
::uz::zu
::veilleicht::vielleicht
::Versamlung::Versammlung
::vieleicht::vielleicht
::vno::von
::Vorang::Vorrang
::Vorfal::Vorfall
::Vorvall::Vorfall
::vro::vor
::vuchstabieren::buchstabieren
::wachesn::wachsen
::wasist::was ist
::wechle::welche
::wechler::welcher
::wechles::welches
::wedre::werde
::wei::wie
::weider::wieder
::weisst::weißt
::weng::wenig
::wenge::wenige
::werd::wird
::Wge::Weg
::Widnows::Windows
::wiederschreiben::wieder schreiben
::wiel::weil
::wieß::weiß
::wieße::weiße
::wießt::weißt
::wiklich::wirklich
::wil::will
::wilst::willst
::wirds::wird’s
::wisen::wissen
::wissn::wissen
::wolen::wollen
::wolltn::wollten
::wolte::wollte
::wolten::wollten
::woltest::wolltest
::woolten::wollten
::wra::war
::wre::wer
::wri::wir
::wriklich::wirklich
::wriklih::wirklich
::Wrot::Wort
::wüdre::würde
::wüdren::würden
::würdst::würdest
::zeigem::zeigen
::Zeti::Zeit
::Zite::Zeit
::Zuhschauer::Zuschauer
::Zuhärer::Zuhörer
::zuruck::zurück
::zürück::zurück
::änlich::ähnlich
::übertreibn::übertreiben
::übetrreiben::übertreiben
::ühnlich::ähnlic
