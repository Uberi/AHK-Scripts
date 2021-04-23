;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;   Main Function    ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#SingleInstance Off ; check for multiple instances manually
#NoTrayIcon

#NoEnv
#HotkeyInterval 0		;disable the warning dialog if a key is held down
#InstallKeybdHook		;Forces the unconditional installation of the keyboard hook
#UseHook On			;might increase responsiveness of hotkeys
#MaxThreads 20			;use 20 (the max) instead of 10 threads
SetBatchLines, -1		;makes the script run at max speed
SetKeyDelay , -1, -1		;faster response (might be better with -1, 0)
;Thread, Interrupt , -1, -1	;not sure what this does, could be bad for timers 
SetTitleMatchMode, 1

ScriptName :=		"WarKeys.ahk"
ScriptVersion :=	"0.15.3.0a" ; note: this line must be on line 17 for convert.ahk
WindowName = WarKeys v%ScriptVersion%

;Menu, Tray, Icon, Warkeys.exe ; other windows are affected too

;AutoHotkeyVersion :=	"1.0.43.08"
;Language :=		"English"
;Platform :=		"WinXP Pro SP2"
;Author :=		"John Schroeder"
  
; Purpose of this Program, Warkeys
;   The goal of this program is to accomplish the following:
;
; 1. Allow users maximum customability that the CustomKeys.txt has using a
;    WYSIWYG (What you see is what you get) GUI (Graphical User Interface).
; 2. Give users a sense of familiarity of other windows programs by using the
;    same type of interface that is common among most windows programs.
; 3. Create an environment that is similiar to Keycraft, so that users of
;    Keycraft will be able to pick up Warkeys with ease.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Explanation of Variables ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  This program attempts to use Hungarian Notation as best it can.
;  An explation of Hungarian Notation can be found at:
;    http://web.umr.edu/~cpp/common/hungarian.html
;
;  C = class
;  rg = range
;  p = pointer
;  _ = member variable
;
; CIcon : class of Icon
; CIcon<name>_<var> : var is a member variable of the Icon class of name
; rgpCIcon : array/range (ie the grid) of pointers to Icon classes
; prgpCIcon : pointer (ie CurrentGrid) to an array/range of pointers to Icon classes
;
;
; How stuff works:
;   pointers are really strings that hold the name of the variable we want to change
;     *not* the address in this case
;   Ex: rgpCIconGridHumanBuildingsAlter8 = CIconPaladin
;     here name CIconPaladin is the variable referenced by this pointer
;   To dereference a pointer we do this:
;     %rgpCIconGridHumanBuildingsAlter8%_hotkey = Q

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Varibables/Defines ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tree stuff
HomePath = %A_WorkingDir%\AHKTreeSupport.dll
msgbox, A_WorkingDir = %A_WorkingDir%`nHomePath = %HomePath%
IfNotExist, %HomePath%
{
  Gui +OwnDialogs
	MsgBox, 0, DLL Missing!, A required DLL - AHKTreeSupport.dll - could not be found`nThe program will now exit.
	ExitApp
}
hModule := DllCall("LoadLibrary", "str", HomePath)
hLastInsertedItem = -0x0FFFE

; Defines
;NULL := "NULL"
kcQuote = "
StringCaseSense, On
bIsFileDirty := false

;kstrGuiMainWin = x170 y110 h385 w761
;kstrGuiMainWin = x170 y110 h390 w761
kstrGuiMainWin = h390 w761
kstrINI = %A_WorkingDir%\warkeys.ini
kstrLoadCfg = Load last used cfg file on Startup
ImageDir = %A_WorkingDir%\images
kstrBlankImage = blank ;BTNTemp

GENERIC_WRITE = 0x40000000  ; Open the file for writing rather than reading.
CREATE_ALWAYS = 2  ; Create new file (overwriting any existing file).
WS_CLIPSIBLINGS := 0x4000000

prgpCIconGridCurrent = rgpCIconGridEmpty


; Defines for Icons
kiTypeHero := 0
kiTypeNormal := 1
kiTypeNormal2 := 2
kiTypeNormal2B := 3
kiTypeNormal3 := 4
kiTypeNormal3B := 5
kiTypeNormal3BB := 6
kiTypeUnbutton := 7
kiTypeUnbuttonB := 8
kiTypeNoHotkey := 9
kiTypeDouble := 10
kiTypeDoubleB := 11

kiTypeSeparate := 30

kiTypeHeroDota := 12
kiTypeDotaAB := 13
kiTypeDotaABNormLearn := 29

kiTypeHeroSpell := 14
kiTypeHeroSpellLearn := 15
kiTypeHeroSpellUnbutton := 16
kiTypeHeroSpellUnbuttonB := 17
kiTypeHeroSpellNoHotkey := 18
kiTypeHeroSpellDouble := 19
kiTypeHeroSpellDoubleB := 20
kiTypeHeroSpellSix := 21
kiTypeHeroSpellSixDouble := 22
kiTypeHeroSpellSixDoubleB := 23
kiTypeHeroSpellSixNoHotkey := 24

kiTypeHeroSpellDota := 25
kiTypeHeroSpellDotaUN := 26
kiTypeDotaUN := 27

kiTypeGridKey := 28


kstrGridposbackground = x340 y37 w354 h267 %WS_CLIPSIBLINGS%

; defines for mouse positions
kiGridDelta := 88
krgiMouseX0 := 347
krgiMouseX1 := krgiMouseX0 + kiGridDelta
krgiMouseX2 := krgiMouseX1 + kiGridDelta
krgiMouseX3 := krgiMouseX2 + kiGridDelta
krgiMouseX4 := krgiMouseX3 + kiGridDelta
krgiMouseY0 := 88
krgiMouseY1 := krgiMouseY0 + kiGridDelta
krgiMouseY2 := krgiMouseY1 + kiGridDelta
krgiMouseY3 := krgiMouseY2 + kiGridDelta

; defines for grid positions
kiGridDelta := 88
x0 := 347
x1 := x0 + kiGridDelta
x2 := x1 + kiGridDelta
x3 := x2 + kiGridDelta
x4 := x3 + kiGridDelta ; for the text update
y0 := 44
y1 := y0 + kiGridDelta
y2 := y1 + kiGridDelta
y3 := y2 + kiGridDelta ; for the text update

kiGridheight := 80
kiGridwidth := 80

rgstrGridpos0 = x%x0% y%y0% w%kiGridwidth% h%kiGridheight% gGrid0 vrgImage0
rgstrGridpos1 = x%x0% y%y1% w%kiGridwidth% h%kiGridheight% gGrid1 vrgImage1
rgstrGridpos2 = x%x0% y%y2% w%kiGridwidth% h%kiGridheight% gGrid2 vrgImage2

rgstrGridpos3 = x%x1% y%y0% w%kiGridwidth% h%kiGridheight% gGrid3 vrgImage3
rgstrGridpos4 = x%x1% y%y1% w%kiGridwidth% h%kiGridheight% gGrid4 vrgImage4
rgstrGridpos5 = x%x1% y%y2% w%kiGridwidth% h%kiGridheight% gGrid5 vrgImage5

rgstrGridpos6 = x%x2% y%y0% w%kiGridwidth% h%kiGridheight% gGrid6 vrgImage6
rgstrGridpos7 = x%x2% y%y1% w%kiGridwidth% h%kiGridheight% gGrid7 vrgImage7
rgstrGridpos8 = x%x2% y%y2% w%kiGridwidth% h%kiGridheight% gGrid8 vrgImage8

rgstrGridpos9 = x%x3% y%y0% w%kiGridwidth% h%kiGridheight% gGrid9 vrgImage9
rgstrGridpos10 = x%x3% y%y1% w%kiGridwidth% h%kiGridheight% gGrid10 vrgImage10
rgstrGridpos11 = x%x3% y%y2% w%kiGridwidth% h%kiGridheight% gGrid11 vrgImage11

; defines for the text boxes
kiTextWidth := 32
;kiTextWidthEsc := 32
kiTextHeight := 32

rgstrGridText0 = x%x0% y%y0% w%kiTextWidth% h%kiTextHeight% vrgText0
rgstrGridText1 = x%x0% y%y1% w%kiTextWidth% h%kiTextHeight% vrgText1
rgstrGridText2 = x%x0% y%y2% w%kiTextWidth% h%kiTextHeight% vrgText2

rgstrGridText3 = x%x1% y%y0% w%kiTextWidth% h%kiTextHeight% vrgText3
rgstrGridText4 = x%x1% y%y1% w%kiTextWidth% h%kiTextHeight% vrgText4
rgstrGridText5 = x%x1% y%y2% w%kiTextWidth% h%kiTextHeight% vrgText5

rgstrGridText6 = x%x2% y%y0% w%kiTextWidth% h%kiTextHeight% vrgText6
rgstrGridText7 = x%x2% y%y1% w%kiTextWidth% h%kiTextHeight% vrgText7
rgstrGridText8 = x%x2% y%y2% w%kiTextWidth% h%kiTextHeight% vrgText8

rgstrGridText9 = x%x3% y%y0% w%kiTextWidth% h%kiTextHeight% vrgText9
rgstrGridText10 = x%x3% y%y1% w%kiTextWidth% h%kiTextHeight% vrgText10
rgstrGridText11 = x%x3% y%y2% w%kiTextWidth% h%kiTextHeight% vrgText11

; defines for when the box contains the Esc char
;rgstrGridTextEsc0 = x%x0% y%y0% w%kiTextWidthEsc% h%kiTextHeight% vrgText0
;rgstrGridTextEsc1 = x%x0% y%y1% w%kiTextWidthEsc% h%kiTextHeight% vrgText1
;rgstrGridTextEsc2 = x%x0% y%y2% w%kiTextWidthEsc% h%kiTextHeight% vrgText2

;rgstrGridTextEsc3 = x%x1% y%y0% w%kiTextWidthEsc% h%kiTextHeight% vrgText3
;rgstrGridTextEsc4 = x%x1% y%y1% w%kiTextWidthEsc% h%kiTextHeight% vrgText4
;rgstrGridTextEsc5 = x%x1% y%y2% w%kiTextWidthEsc% h%kiTextHeight% vrgText5

;rgstrGridTextEsc6 = x%x2% y%y0% w%kiTextWidthEsc% h%kiTextHeight% vrgText6
;rgstrGridTextEsc7 = x%x2% y%y1% w%kiTextWidthEsc% h%kiTextHeight% vrgText7
;rgstrGridTextEsc8 = x%x2% y%y2% w%kiTextWidthEsc% h%kiTextHeight% vrgText8

;rgstrGridTextEsc9 = x%x3% y%y0% w%kiTextWidthEsc% h%kiTextHeight% vrgText9
;rgstrGridTextEsc10 = x%x3% y%y1% w%kiTextWidthEsc% h%kiTextHeight% vrgText10
;rgstrGridTextEsc11 = x%x3% y%y2% w%kiTextWidthEsc% h%kiTextHeight% vrgText11

kstrTextPos = x%x0% y0 w350 h%kiTextHeight% vstrText

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Function / AutoExec ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{
  ; Gui Stuff
  GuiINIRead()
  GuiInit()
  ;GuiHotkeysOff()

  ; Tree Stuff
  TreeAdd(45, 37, 250, 267)
  TreeBuild()
  OnMessage(0x004E, "DumpInfo") ; when the user clicks on the tree

  ; Grid Stuff
  GridLoadCmds()
  GridLoadGrids()

  if ( (bOpLoadCfgOnStartup == true) && (strFileCfg) )
  { 
    IfExist, %strFileCfg%
    {
      if (FileLoad(strFileCfg) == 0) ; invalid file
        strFileCfg =
      IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg 
    }
    else
    {
      strFileCfg =
      IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg
       
      Gui +OwnDialogs
      Msgbox, 0, Last used Config file not found!, Last used Config was not found.
    }
    GuiRefreshWinName()
  }
  if (bOpForceGridAlign == true)
    GridAlign()
  
  ; Timers
  TimerInit()
  
  GuiRefresh()
}
return

; Hotkeys for setting a new hotkey
;   Note: Hotkeys must be defined AFTER the GUI stuff
#IfWinActive, Choose New Hotkey
$a::Send a{Enter}
$b::Send b{Enter}
$c::Send c{Enter}
$d::Send d{Enter}
$e::Send ae{Enter}
$f::Send f{Enter}
$g::Send g{Enter}
$h::Send h{Enter}
$i::Send i{Enter}
$j::Send j{Enter}
$k::Send k{Enter}
$l::Send l{Enter}
$m::Send m{Enter}
$n::Send an{Enter}
$o::Send o{Enter}
$p::Send p{Enter}
$q::Send q{Enter}
$r::Send r{Enter}
$s::Send s{Enter}
$t::Send t{Enter}
$u::Send u{Enter}
$v::Send v{Enter}
$w::Send w{Enter}
$x::Send x{Enter}
$y::Send y{Enter}
$z::Send z{Enter}
$Esc::Send aee{Enter}
$Space::Send ann{Enter}
;GuiHotkeysOff()
;Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;   Tree Functions   ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Member Variables:
;   m_rgTreeList ; an array that serves as a quick ref to the list of trees
;     m_rgTreeList is actually a sparse array that functions as a hash table 
;   m_rgTreeGridList ; an array that serves as a quick ref to the list of trees
;   m_iTreeCount ; a counter that tells us how many items we have total
;
; AddTree(x, y, width, height)
; TreeBuild() ;***add items to tree***
; TreeInsert(TreeHwnd, hParent, hLastInsertedItem, Text2Insert)
; GetChildHWND(ParentHWND, ChildClassNN)
; DumpInfo(wParam, lParam, msg, hwnd) ;***read from tree***
;

; Adds the tree to the main window
TreeAdd(x, y, width, height)
{
  global ;todo: do we need this here?

  WinGet, HWND, ID, %WindowName%   ;Get HWND of the dialog
  dwexStyle := 0x10000000 | 0x01 | 0x02 | 0x04   ;Set Treestyle
  dwStyle = 0
  nID = 1234   ;Set an ID for the TreeControl
  TreeHWND := DllCall("AHKTreeSupport\TreeCreate", DWORD, dwexStyle, DWORD, dwStyle, int, x, int, y, int, width, int, height, DWORD, HWND, int, nID, "Cdecl Int")
  if (errorlevel <> 0) || (nRC = 0)
  {
     Gui +OwnDialogs
     MsgBox, 0, Error!, Error while calling TreeCreate Errorlevel: %errorlevel% - RC: %nRC%`nmfc80.dll and/or msvcr80.dll may be missing`n, 
     ExitApp
  }
}

; add items to tree here
TreeBuild()
{
  global

  TreeHwnd := GetChildHWND(HWND, "SysTreeView321")
  m_iTreeCount := 0

  ; Main Branches 
  TreeInsert(0, "GridKeys", "Hotkey Grid")
  TreeInsert(0, "GridKeysL", "Learn Hotkey Grid")
  TreeInsert(0, "Common", "Common")
  TreeInsert(0, "Human", "Human")
  TreeInsert(0, "Orc", "Orc")
  TreeInsert(0, "Undead", "Undead")
  TreeInsert(0, "NightElf", "Night Elf")
  TreeInsert(0, "Neutral", "Neutral")
  TreeInsert(0, "Dota", "Dota 6.31")

  ; Second Levels
  TreeInsert("Common", "CommonBuildings", "Buildings")
  TreeInsert("Common", "CommonUnits", "Units")
  TreeInsert("Common", "CommonSpells", "Spells")

  TreeInsert("Human", "HumanBuildings", "Buildings")
  TreeInsert("Human", "HumanUnits", "Units")
  TreeInsert("Human", "HumanHeroes", "Heroes")
  TreeInsert("Human", "HumanHeroSummons", "Hero Summoned Units")

  TreeInsert("Orc", "OrcBuildings", "Buildings")
  TreeInsert("Orc", "OrcUnits", "Units")
  TreeInsert("Orc", "OrcHeroes", "Heroes")
  TreeInsert("Orc", "OrcHeroSummons", "Hero Summoned Units")
  
  TreeInsert("Undead", "UndeadBuildings", "Buildings")
  TreeInsert("Undead", "UndeadUnits", "Units")
  TreeInsert("Undead", "UndeadHeroes", "Heroes")
  TreeInsert("Undead", "UndeadHeroSummons", "Hero Summoned Units")
  
  TreeInsert("NightElf", "NightElfBuildings", "Buildings")
  TreeInsert("NightElf", "NightElfUnits", "Units")
  TreeInsert("NightElf", "NightElfHeroes", "Heroes")
  TreeInsert("NightElf", "NightElfHeroSummons", "Hero Summoned Units")
  
  TreeInsert("Neutral", "NeutralBuildings", "Buildings")
  TreeInsert("Neutral", "NeutralUnits", "Units")
  TreeInsert("Neutral", "NeutralCreeps", "Creeps")
  TreeInsert("Neutral", "NeutralHeroes", "Heroes")
  TreeInsert("Neutral", "NeutralHeroSummons", "Hero Summoned Units")

  TreeInsert("Dota", "DotaCommon", "Common")
  TreeInsert("Dota", "DotaMorning", "Morning Tavern Heroes")
  TreeInsert("Dota", "DotaSunrise", "Sunrise Tavern Heroes")
  TreeInsert("Dota", "DotaTavern", "Light Tavern Heroes")
  TreeInsert("Dota", "DotaDawn", "Dawn Tavern Heroes")
  TreeInsert("Dota", "DotaMidnight", "Midnight Tavern Heroes")
  TreeInsert("Dota", "DotaEvening", "Evening Tavern Heroes")
  TreeInsert("Dota", "DotaTwilight", "Twilight Tavern Heroes")
  TreeInsert("Dota", "DotaDusk", "Dusk Tavern Heroes")
  TreeInsert("Dota", "DotaCreeps", "Dota Creeps")
  
  TreeInsert("CommonBuildings", "CommonBuildingsBasics", "Building Basics")
  TreeInsert("CommonBuildings", "CommonBuildingsShopBasics", "Shop Basics")

  TreeInsert("CommonUnits", "CommonUnitsUnits", "Units")
  TreeInsert("CommonUnits", "CommonUnitsHide", "Units with Hide")
  TreeInsert("CommonUnits", "CommonUnitsPillage", "Units with Pillage")
  TreeInsert("CommonUnits", "CommonUnitsCatapult", "Catapults")
  TreeInsert("CommonUnits", "CommonUnitsHeroes", "Heroes")
  TreeInsert("CommonUnits", "CommonUnitsCancel", "Cancel")
  TreeInsert("CommonUnits", "CommonUnitsPeon", "Peasant/Peon Gather")
  TreeInsert("CommonUnits", "CommonUnitsPeonU", "Peasant/Peon Return Resources")

  TreeInsert("CommonSpells", "CommonSpellsDispel", "Dispel Magic")
  TreeInsert("CommonSpells", "CommonSpellsRSkin", "Resistant Skin: Units with < 4 Spells")
  TreeInsert("CommonSpells", "CommonSpellsRSkinZ", "Resistant Skin: Units with 4 Spells")
  TreeInsert("CommonSpells", "CommonSpellsImmune", "Spell Immunity (Green)")
  TreeInsert("CommonSpells", "CommonSpellsImmuneZ", "Spell Immunity (Black)")
  TreeInsert("CommonSpells", "CommonSpellsAbolish", "Abolish Magic")
  TreeInsert("CommonSpells", "CommonSpellsAbolishU", "Abolish Magic: Auto-cast On")

  TreeInsert("HumanBuildings", "HumanBuildingsTownhall", "Town Hall")
  TreeInsert("HumanBuildings", "HumanBuildingsTownhallZ", "Town Hall (Keep)")
  TreeInsert("HumanBuildings", "HumanBuildingsAltar", "Altar of Kings")
  TreeInsert("HumanBuildings", "HumanBuildingsBarracks", "Barracks")
  TreeInsert("HumanBuildings", "HumanBuildingsLumbermill", "Lumber Mill")
  TreeInsert("HumanBuildings", "HumanBuildingsLumbermillA", "Lumber Mill 2")
  TreeInsert("HumanBuildings", "HumanBuildingsLumbermillB", "Lumber Mill 3")
  TreeInsert("HumanBuildings", "HumanBuildingsBlacksmith", "Blacksmith")
  TreeInsert("HumanBuildings", "HumanBuildingsBlacksmithA", "Blacksmith 2")
  TreeInsert("HumanBuildings", "HumanBuildingsBlacksmithB", "Blacksmith 3")
  TreeInsert("HumanBuildings", "HumanBuildingsSanctum", "Arcane Sanctum")
  TreeInsert("HumanBuildings", "HumanBuildingsSanctumA", "Arcane Sanctum 2")
  TreeInsert("HumanBuildings", "HumanBuildingsWorkshop", "Workshop")
  TreeInsert("HumanBuildings", "HumanBuildingsWorkshopZ", "Workshop 2")
  TreeInsert("HumanBuildings", "HumanBuildingsAviary", "Gryphon Aviary")
  TreeInsert("HumanBuildings", "HumanBuildingsTowerscout", "Tower: Scout")
  TreeInsert("HumanBuildings", "HumanBuildingsTowerarcane", "Tower: Arcane")
  TreeInsert("HumanBuildings", "HumanBuildingsVault", "Arcane Vault")

  TreeInsert("HumanUnits", "HumanUnitsPeasant", "Peasant")
  TreeInsert("HumanUnits", "HumanUnitsPeasantU", "Peasant: With Lumber/Repair On")
  TreeInsert("HumanUnits", "HumanUnitsPeasantBuild", "Peasant: Build")
  TreeInsert("HumanUnits", "HumanUnitsFootman", "Footman")
  TreeInsert("HumanUnits", "HumanUnitsFootmanU", "Footman (Defending)")
  TreeInsert("HumanUnits", "HumanUnitsPriest", "Priest")
  TreeInsert("HumanUnits", "HumanUnitsPriestU", "Priest (auto-cast on)")
  TreeInsert("HumanUnits", "HumanUnitsSorceress", "Sorceress")
  TreeInsert("HumanUnits", "HumanUnitsSorceressU", "Sorceress (auto-cast on)")
  TreeInsert("HumanUnits", "HumanUnitsSpellbreaker", "Spell Breaker")
  TreeInsert("HumanUnits", "HumanUnitsSpellbreakerU", "Spell Breaker (auto-cast on)")
  TreeInsert("HumanUnits", "HumanUnitsFlyingMachine", "Flying Machine")
  TreeInsert("HumanUnits", "HumanUnitsMortar", "Mortar Team")
  TreeInsert("HumanUnits", "HumanUnitsSteamTank", "Steam Tank")
  TreeInsert("HumanUnits", "HumanUnitsDragonhawk", "Dragon Hawk")
  TreeInsert("HumanUnits", "HumanUnitsGryphon", "Gryphon Rider")

  TreeInsert("HumanHeroes", "HumanHeroesArchmage", "Archmage")
  TreeInsert("HumanHeroes", "HumanHeroesArchmageL", "Archmage: Learn")
  TreeInsert("HumanHeroes", "HumanHeroesMountainking", "Mountain King")
  TreeInsert("HumanHeroes", "HumanHeroesMountainkingL", "Mountain King: Learn")
  TreeInsert("HumanHeroes", "HumanHeroesPaladin", "Paladin")
  TreeInsert("HumanHeroes", "HumanHeroesPaladinL", "Paladin: Learn")
  TreeInsert("HumanHeroes", "HumanHeroesBloodmage", "Blood Mage")
  TreeInsert("HumanHeroes", "HumanHeroesBloodmageL", "Blood Mage: Learn")
  
  TreeInsert("HumanHeroSummons", "HumanHeroSummonsPhoenix", "Phoenix")

  TreeInsert("OrcBuildings", "OrcBuildingsTownHall", "Great Hall")
  TreeInsert("OrcBuildings", "OrcBuildingsTownHallZ", "Great Hall (Stronghold)")
  TreeInsert("OrcBuildings", "OrcBuildingsBurrow", "Burrow")
  TreeInsert("OrcBuildings", "OrcBuildingsAltarofStorms", "Altar of Storms")
  TreeInsert("OrcBuildings", "OrcBuildingsBarracks", "Barracks")
  TreeInsert("OrcBuildings", "OrcBuildingsBarracksZ", "Barracks 2")
  TreeInsert("OrcBuildings", "OrcBuildingsWarMill", "War Mill")
  TreeInsert("OrcBuildings", "OrcBuildingsWarMillA", "War Mill 2")
  TreeInsert("OrcBuildings", "OrcBuildingsWarMillB", "War Mill 3")
  TreeInsert("OrcBuildings", "OrcBuildingsBeastiary", "Beastiary")
  TreeInsert("OrcBuildings", "OrcBuildingsSpiritLodge", "Spirit Lodge")
  TreeInsert("OrcBuildings", "OrcBuildingsSpiritLodgeA", "Spirit Lodge 2")
  TreeInsert("OrcBuildings", "OrcBuildingsTaurenTotem", "Tauren Totem")
  TreeInsert("OrcBuildings", "OrcBuildingsVoodooLounge", "Voodoo Lounge")
  
  TreeInsert("OrcUnits", "OrcUnitsPeon", "Peon")
  TreeInsert("OrcUnits", "OrcUnitsPeonU", "Peon: With Lumber/Repair On")
  TreeInsert("OrcUnits", "OrcUnitsPeonBuild", "Peon: Build")
  TreeInsert("OrcUnits", "OrcUnitsBerserker", "Troll Berserker")
  TreeInsert("OrcUnits", "OrcUnitsDemolisher", "Demolisher")
  TreeInsert("OrcUnits", "OrcUnitsShamanRoc", "Shaman (ROC)")
  TreeInsert("OrcUnits", "OrcUnitsShamanRocU", "Shaman (ROC): Auto-cast On")
  TreeInsert("OrcUnits", "OrcUnitsShaman", "Shaman (TFT)")
  TreeInsert("OrcUnits", "OrcUnitsShamanU", "Shaman (TFT): Auto-cast On")
  TreeInsert("OrcUnits", "OrcUnitsWitchDoc", "Troll Witch Doctor")
  TreeInsert("OrcUnits", "OrcUnitsSpiritWalker", "Spirit Walker")
  TreeInsert("OrcUnits", "OrcUnitsSpiritWalkerU", "Spirit Walker: Corporeal")
  TreeInsert("OrcUnits", "OrcUnitsRadier", "Raider")
  TreeInsert("OrcUnits", "OrcUnitsWindRaider", "Wind Raider")
  TreeInsert("OrcUnits", "OrcUnitsKodo", "Kodo Beast")
  TreeInsert("OrcUnits", "OrcUnitsBatrider", "Troll Batrider")
  TreeInsert("OrcUnits", "OrcUnitsTauren", "Tauren")
  
  TreeInsert("OrcHeroes", "OrcHeroesFarSeer", "Far Seer")
  TreeInsert("OrcHeroes", "OrcHeroesFarSeerL", "Far Seer: Learn")
  TreeInsert("OrcHeroes", "OrcHeroesTaurenChief", "Tauren Chieftain")
  TreeInsert("OrcHeroes", "OrcHeroesTaurenChiefL", "Tauren Chieftain: Learn")
  TreeInsert("OrcHeroes", "OrcHeroesBlademaster", "Blademaster")
  TreeInsert("OrcHeroes", "OrcHeroesBlademasterL", "Blademaster: Learn")
  TreeInsert("OrcHeroes", "OrcHeroesShadowHunter", "Shadow Hunter")
  TreeInsert("OrcHeroes", "OrcHeroesShadowHunterL", "Shadow Hunter: Learn")
  
  TreeInsert("OrcHeroSummons", "OrcHeroSummonsFeralSpirit", "Feral Spirit")
  
  TreeInsert("UndeadBuildings", "UndeadBuildingsNecropolis", "Necropolis")
  TreeInsert("UndeadBuildings", "UndeadBuildingsNecropolisZ", "Necropolis (Halls of the Dead)")
  TreeInsert("UndeadBuildings", "UndeadBuildingsZiggurat", "Ziggurat")
  TreeInsert("UndeadBuildings", "UndeadBuildingsTower", "Nerubian Tower")
  TreeInsert("UndeadBuildings", "UndeadBuildingsAltar", "Altar of Darkness")
  TreeInsert("UndeadBuildings", "UndeadBuildingsCrypt", "Crypt")
  TreeInsert("UndeadBuildings", "UndeadBuildingsGraveyard", "Graveyard")
  TreeInsert("UndeadBuildings", "UndeadBuildingsGraveyardA", "Graveyard 2")
  TreeInsert("UndeadBuildings", "UndeadBuildingsGraveyardB", "Graveyard 3")
  TreeInsert("UndeadBuildings", "UndeadBuildingsTemple", "Temple of the Damned")
  TreeInsert("UndeadBuildings", "UndeadBuildingsTempleA", "Temple of the Damned 2")
  TreeInsert("UndeadBuildings", "UndeadBuildingsSlaughterhouse", "Slaughterhouse")
  TreeInsert("UndeadBuildings", "UndeadBuildingsPit", "Sacrificial Pit")
  TreeInsert("UndeadBuildings", "UndeadBuildingsBoneyard", "Boneyard")
  TreeInsert("UndeadBuildings", "UndeadBuildingsRelics", "Tomb of Relics")

  TreeInsert("UndeadUnits", "UndeadUnitsAcolyte", "Acolyte")
  TreeInsert("UndeadUnits", "UndeadUnitsAcolyteU", "Acolyte: Repair On")
  TreeInsert("UndeadUnits", "UndeadUnitsAcolyteBuild", "Acolyte: Build")
  TreeInsert("UndeadUnits", "UndeadUnitsGhoul", "Ghoul")
  TreeInsert("UndeadUnits", "UndeadUnitsGhoulU", "Ghoul: with Lumber")
  TreeInsert("UndeadUnits", "UndeadUnitsFiend", "Crypt Fiend")
  TreeInsert("UndeadUnits", "UndeadUnitsFiendU", "Crypt Fiend: Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsFiendBurrowed", "Crypt Fiend: Burrowed")
  TreeInsert("UndeadUnits", "UndeadUnitsGargoyle", "Gargoyle")
  TreeInsert("UndeadUnits", "UndeadUnitsGargoyleU", "Gargoyle: Stone Form")
  TreeInsert("UndeadUnits", "UndeadUnitsNecromancer", "Necromancer")
  TreeInsert("UndeadUnits", "UndeadUnitsNecromancerU", "Necromancer: Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsBansheeRoc", "Banshee (ROC)")
  TreeInsert("UndeadUnits", "UndeadUnitsBansheeRocU", "Banshee (ROC): Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsBanshee", "Banshee (TFT)")
  TreeInsert("UndeadUnits", "UndeadUnitsBansheeU", "Banshee (TFT): Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsMeatWagon", "Meat Wagon")
  TreeInsert("UndeadUnits", "UndeadUnitsMeatWagonU", "Meat Wagon: Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsAbomination", "Abomination")
  TreeInsert("UndeadUnits", "UndeadUnitsStatue", "Obsidian Statue")
  TreeInsert("UndeadUnits", "UndeadUnitsStatueU", "Obsidian Statue: Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsDestroyer", "Destroyer")
  TreeInsert("UndeadUnits", "UndeadUnitsDestroyerU", "Destroyer: Auto-cast On")
  TreeInsert("UndeadUnits", "UndeadUnitsShade", "Shade")
  TreeInsert("UndeadUnits", "UndeadUnitsFrostWyrm", "Frost Wyrm")
  
  TreeInsert("UndeadHeroes", "UndeadHeroesDeathKnight", "Death Knight")
  TreeInsert("UndeadHeroes", "UndeadHeroesDeathKnightL", "Death Knight: Learn")
  TreeInsert("UndeadHeroes", "UndeadHeroesDreadlord", "Dreadlord")
  TreeInsert("UndeadHeroes", "UndeadHeroesDreadlordL", "Dreadlord: Learn")
  TreeInsert("UndeadHeroes", "UndeadHeroesLich", "Lich")
  TreeInsert("UndeadHeroes", "UndeadHeroesLichU", "Lich: Auto-cast On")
  TreeInsert("UndeadHeroes", "UndeadHeroesLichL", "Lich: Learn")
  TreeInsert("UndeadHeroes", "UndeadHeroesCryptLord", "Crypt Lord")
  TreeInsert("UndeadHeroes", "UndeadHeroesCryptLordU", "Crypt Lord: Auto-cast On")
  TreeInsert("UndeadHeroes", "UndeadHeroesCryptLordL", "Crypt Lord: Learn")
  
  TreeInsert("UndeadHeroSummons", "UndeadHeroSummonsInfernal", "Infernal")
  TreeInsert("UndeadHeroSummons", "UndeadHeroSummonsBeetle", "Carrion Beetle: Level 2")
  TreeInsert("UndeadHeroSummons", "UndeadHeroSummonsBeetleU", "Carrion Beetle: Burrowed (L2)")
  TreeInsert("UndeadHeroSummons", "UndeadHeroSummonsBeetleThree", "Carrion Beetle: Level 3")
  TreeInsert("UndeadHeroSummons", "UndeadHeroSummonsBeetleThreeU", "Carrion Beetle: Burrowed (L3)")
  
  TreeInsert("NightElfBuildings", "NightElfBuildingsTreeUproot", "Tree: Uprooted")
  TreeInsert("NightElfBuildings", "NightElfBuildingsTreeOfLifeUproot", "Tree of Life: Uprooted")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientProtectorUproot", "Ancient Protector: Uprooted")
  TreeInsert("NightElfBuildings", "NightElfBuildingsEntangledGoldMine", "Entangled Gold Mine")
  TreeInsert("NightElfBuildings", "NightElfBuildingsTreeOfLife", "Tree of Life")
  TreeInsert("NightElfBuildings", "NightElfBuildingsTreeOfAges", "Tree of Ages")
  TreeInsert("NightElfBuildings", "NightElfBuildingsMoonWell", "Moon Well")
  TreeInsert("NightElfBuildings", "NightElfBuildingsMoonWellU", "Moon Well: Auto-cast On")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAltarOfElders", "Altar of Elders")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfWar", "Ancient of War")
  TreeInsert("NightElfBuildings", "NightElfBuildingsHuntersHall", "Hunter's Hall")
  TreeInsert("NightElfBuildings", "NightElfBuildingsHuntersHallA", "Hunter's Hall 2")
  TreeInsert("NightElfBuildings", "NightElfBuildingsHuntersHallB", "Hunter's Hall 3")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfLore", "Ancient of Lore")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfLoreA", "Ancient of Lore 2")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfWind", "Ancient of Wind")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfWindA", "Ancient of Wind 2")
  TreeInsert("NightElfBuildings", "NightElfBuildingsChimRoost", "Chimaera Roost")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientOfWonders", "Ancient of Wonders")
  TreeInsert("NightElfBuildings", "NightElfBuildingsAncientProtector", "Ancient Protector")
  
  TreeInsert("NightElfUnits", "NightElfUnitsWisp", "Wisp")
  TreeInsert("NightElfUnits", "NightElfUnitsWispU", "Wisp: Auto-cast On")
  TreeInsert("NightElfUnits", "NightElfUnitsWispBuild", "Wisp Build")
  TreeInsert("NightElfUnits", "NightElfUnitsArcher", "Archer")
  TreeInsert("NightElfUnits", "NightElfUnitsHuntress", "Huntress")
  TreeInsert("NightElfUnits", "NightElfUnitsGlaiveThrower", "Glaive Thrower")
  TreeInsert("NightElfUnits", "NightElfUnitsDryad", "Dryad")
  TreeInsert("NightElfUnits", "NightElfUnitsDryadU", "Dryad: Auto-cast On")
  TreeInsert("NightElfUnits", "NightElfUnitsDruidClaw", "Druid of the Claw")
  TreeInsert("NightElfUnits", "NightElfUnitsDruidClawZ", "Druid of the Claw: Bear Form")
  TreeInsert("NightElfUnits", "NightElfUnitsMtGiant", "Mountain Giant")
  TreeInsert("NightElfUnits", "NightElfUnitsHippogryph", "Hippogryph")
  TreeInsert("NightElfUnits", "NightElfUnitsHippogryphZ", "Hippogryph: with Archer")
  TreeInsert("NightElfUnits", "NightElfUnitsDruidTalon", "Druid of the Talon")
  TreeInsert("NightElfUnits", "NightElfUnitsDruidTalonZ", "Druid of the Talon: Auto-cast/Storm Crow Form")
  TreeInsert("NightElfUnits", "NightElfUnitsFaerieDragon", "Faerie Dragon")
  TreeInsert("NightElfUnits", "NightElfUnitsFaerieDragonZ", "Faerie Dragon: Auto-cast/Mana Flare On")
  TreeInsert("NightElfUnits", "NightElfUnitsChimaera", "Chimaera")
  
  TreeInsert("NightElfHeroes", "NightElfHeroesDemonHunter", "Demon Hunter")
  TreeInsert("NightElfHeroes", "NightElfHeroesDemonHunterZ", "Demon Hunter: Immolation On")
  TreeInsert("NightElfHeroes", "NightElfHeroesDemonHunterL", "Demon Hunter: Learn")
  TreeInsert("NightElfHeroes", "NightElfHeroesKeeperGrove", "Keeper of the Grove")
  TreeInsert("NightElfHeroes", "NightElfHeroesKeeperGroveL", "Keeper of the Grove: Learn")
  TreeInsert("NightElfHeroes", "NightElfHeroesPriestessMoon", "Priestess of the Moon")
  TreeInsert("NightElfHeroes", "NightElfHeroesPriestessMoonU", "Priestess of the Moon: Auto-cast On")
  TreeInsert("NightElfHeroes", "NightElfHeroesPriestessMoonL", "Priestess of the Moon: Learn")
  TreeInsert("NightElfHeroes", "NightElfHeroesWarden", "Warden")
  TreeInsert("NightElfHeroes", "NightElfHeroesWardenL", "Warden: Learn")
  
  TreeInsert("NightElfHeroSummons", "NightElfHeroSummonsOwl", "Owl Scout")
  TreeInsert("NightElfHeroSummons", "NightElfHeroSummonsAvatar", "Avatar of Vengenance")
  TreeInsert("NightElfHeroSummons", "NightElfHeroSummonsAvatarU", "Avatar of Vengenance: Auto-cast On")
  
  TreeInsert("NeutralBuildings", "NeutralBuildingsTavern", "Tavern")
  TreeInsert("NeutralBuildings", "NeutralBuildingsMerchant", "Goblin Merchant")
  TreeInsert("NeutralBuildings", "NeutralBuildingsLaboratory", "Goblin Laboratory")
  TreeInsert("NeutralBuildings", "NeutralBuildingsMercCamp", "Mercenary Camp")
  TreeInsert("NeutralBuildings", "NeutralBuildingsMercCampTwo", "Mercenary Camp (2)")
  TreeInsert("NeutralBuildings", "NeutralBuildingsMercCampThree", "Mercenary Camp (3)")
  
  TreeInsert("NeutralUnits", "NeutralUnitsZeppelin", "Goblin Zeppelin")
  TreeInsert("NeutralUnits", "NeutralUnitsSapper", "Goblin Sapper")
  TreeInsert("NeutralUnits", "NeutralUnitsSapperU", "Goblin Sapper: Auto-cast On")
  TreeInsert("NeutralUnits", "NeutralUnitsShredder", "Goblin Shredder")
  TreeInsert("NeutralUnits", "NeutralUnitsShredderZ", "Goblin Shredder: with Lumber")
  TreeInsert("NeutralUnits", "NeutralUnitsShadowPriest", "Forest Troll Shadow Priest")
  TreeInsert("NeutralUnits", "NeutralUnitsShadowPriestU", "Forest Troll Shadow Priest: Auto-cast On")
  TreeInsert("NeutralUnits", "NeutralUnitsMudGolem", "Mud Golem")
  TreeInsert("NeutralUnits", "NeutralUnitsMudGolemU", "Mud Golem: Auto-cast On")
  
  TreeInsert("NeutralUnits", "NeutralUnitsHuntsman", "Murloc Huntsman")
  TreeInsert("NeutralUnits", "NeutralUnitsAssassin", "Assassin")
  TreeInsert("NeutralUnits", "NeutralUnitsGeomancer", "Kobold Geomancer")
  TreeInsert("NeutralUnits", "NeutralUnitsGeomancerU", "Kobold Geomancer: Auto-cast On")
  TreeInsert("NeutralUnits", "NeutralUnitsWindwitch", "Harpy Windwitch")
  TreeInsert("NeutralUnits", "NeutralUnitsWindwitchU", "Harpy Windwitch: Auto-cast On")
  TreeInsert("NeutralUnits", "NeutralUnitsMedicineMan", "Razormane Medicine Man")
  
  TreeInsert("NeutralUnits", "NeutralUnitsIceRevenant", "Ice Revenant")
  
  TreeInsert("NeutralCreeps", "NeutralCreepsOverseer", "Gnoll Overseer")
  TreeInsert("NeutralCreeps", "NeutralCreepsHighPriest", "Forest Troll High Priest")
  TreeInsert("NeutralCreeps", "NeutralCreepsHighPriestU", "Forest Troll High Priest: Auto-cast On")
  
  TreeInsert("NeutralHeroes", "NeutralHeroesAlchemist", "Alchemist")
  TreeInsert("NeutralHeroes", "NeutralHeroesAlchemistL", "Alchemist: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesBeastmaster", "Beastmaster")
  TreeInsert("NeutralHeroes", "NeutralHeroesBeastmasterL", "Beastmaster: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesDarkRanger", "DarkRanger")
  TreeInsert("NeutralHeroes", "NeutralHeroesDarkRangerU", "DarkRanger: auto-cast on")
  TreeInsert("NeutralHeroes", "NeutralHeroesDarkRangerL", "DarkRanger: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesFirelord", "Firelord")
  TreeInsert("NeutralHeroes", "NeutralHeroesFirelordU", "Firelord: auto-cast on")
  TreeInsert("NeutralHeroes", "NeutralHeroesFirelordL", "Firelord: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesNagaSeaWitch", "NagaSeaWitch")
  TreeInsert("NeutralHeroes", "NeutralHeroesNagaSeaWitchU", "NagaSeaWitch: Auto-cast/Mana Shield On")
  TreeInsert("NeutralHeroes", "NeutralHeroesNagaSeaWitchL", "NagaSeaWitch: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesPandarenBrewmaster", "PandarenBrewmaster")
  TreeInsert("NeutralHeroes", "NeutralHeroesPandarenBrewmasterL", "PandarenBrewmaster: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesPitLord", "PitLord")
  TreeInsert("NeutralHeroes", "NeutralHeroesPitLordL", "PitLord: Learn")
  
  TreeInsert("NeutralHeroes", "NeutralHeroesTinker", "Tinker")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerE", "Tinker: Engineering Upgrade 1")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEE", "Tinker: Engineering Upgrade 2")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEEE", "Tinker: Engineering Upgrade 3")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerL", "Tinker: Learn")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEL", "Tinker: Learn Engineering Upgrade 1")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEEL", "Tinker: Learn Engineering Upgrade 2")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEEEL", "Tinker: Learn Engineering Upgrade 3")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerU", "Tinker Tank")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEU", "Tinker Tank: Engineering Upgrade 1")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEEU", "Tinker Tank: Engineering Upgrade 2")
  TreeInsert("NeutralHeroes", "NeutralHeroesTinkerEEEU", "Tinker Tank: Engineering Upgrade 3")
  
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsStorm", "Pandaren Brewmaster: Storm")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsEarth", "Pandaren Brewmaster: Earth")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsFire", "Pandaren Brewmaster: Fire")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsDoomGuard", "Doom Guard")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsBear", "Bear")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsQuilbeast", "Quilbeast")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsQuilbeastU", "Quilbeast: Auto-cast On")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsHawk", "Hawk")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerk", "Clockwerk Goblin")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkE", "Clockwerk Goblin: Engineering Upgrade 1")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkEE", "Clockwerk Goblin: Engineering Upgrade 2")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkEEE", "Clockwerk Goblin: Engineering Upgrade 3")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkU", "Clockwerk Goblin: Auto-cast On")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkEU", "Clockwerk Goblin: Engineering Upgrade 1 with Auto-cast On")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkEEU", "Clockwerk Goblin: Engineering Upgrade 2 with Auto-cast On")
  TreeInsert("NeutralHeroSummons", "NeutralHeroSummonsClockwerkEEEU", "Clockwerk Goblin: Engineering Upgrade 3 with Auto-cast On")

  TreeInsert("DotaCommon", "DotaCommonUnits", "Units")
  TreeInsert("DotaCommon", "DotaCommonHereos", "Heroes")
  TreeInsert("DotaCommon", "DotaCommonHereosL", "Heroes Learn")
  TreeInsert("DotaCommon", "DotaCommonAttributeBonusTwoL", "Learn Attribute Bonus (Icon not visible)")
  ;TreeInsert("DotaCommon", "DotaCommonAttributeBonusThreeL", "Learn Attribute Bonus (Morphling)")

  TreeInsert("DotaMorning", "DotaMorningVengefulSpirit", "Vengeful Spirit")
  TreeInsert("DotaMorning", "DotaMorningVengefulSpiritL", "Vengeful Spirit Learn")
  TreeInsert("DotaMorning", "DotaMorningLordOfOlympia", "Lord of Olympia")
  TreeInsert("DotaMorning", "DotaMorningLordOfOlympiaL", "Lord of Olympia Learn")
  TreeInsert("DotaMorning", "DotaMorningLordOfOlympiaScepter", "Lord of Olympia (Aghanim's Scepter)")
  TreeInsert("DotaMorning", "DotaMorningLordOfOlympiaScepterL", "Lord of Olympia (Aghanim's Scepter) Learn")
  TreeInsert("DotaMorning", "DotaMorningEnchantress", "Enchantress")
  TreeInsert("DotaMorning", "DotaMorningEnchantressU", "Enchantress: Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningEnchantressL", "Enchantress Learn")

  TreeInsert("DotaMorning", "DotaMorningMorphling", "Morphling")
  TreeInsert("DotaMorning", "DotaMorningMorphlingU", "Morphling: Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingD", "Morphling: with Replicant")
  TreeInsert("DotaMorning", "DotaMorningMorphlingL", "Morphling Learn")
  /*
  TreeInsert("DotaMorning", "DotaMorningMorphlingAgility", "Morphling (Agility)")
  TreeInsert("DotaMorning", "DotaMorningMorphlingAgilityU", "Morphling (Agility) Blue Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingAgilityUU", "Morphling (Agility) Green Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingAgilityL", "Morphling (Agility) Learn")
  TreeInsert("DotaMorning", "DotaMorningMorphlingIntelligence", "Morphling (Intelligence)")
  TreeInsert("DotaMorning", "DotaMorningMorphlingIntelligenceU", "Morphling (Intelligence) Blue Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingIntelligenceUU", "Morphling (Intelligence) Green Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingIntelligenceL", "Morphling (Intelligence) Learn")
  TreeInsert("DotaMorning", "DotaMorningMorphlingStrength", "Morphling (Strength)")
  TreeInsert("DotaMorning", "DotaMorningMorphlingStrengthUUU", "Morphling (Strength) Unstable Power Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingStrengthU", "Morphling (Strength) Blue Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingStrengthUU", "Morphling (Strength) Green Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningMorphlingStrengthL", "Morphling Learn (Strength)")
  */
  TreeInsert("DotaMorning", "DotaMorningCrystalMaiden", "Crystal Maiden")
  TreeInsert("DotaMorning", "DotaMorningCrystalMaidenL", "Crystal Maiden Learn")
  TreeInsert("DotaMorning", "DotaMorningCrystalMaidenScepter", "Crystal Maiden (Aghanim's Scepter)")
  TreeInsert("DotaMorning", "DotaMorningCrystalMaidenScepterL", "Crystal Maiden (Aghanim's Scepter) Learn")
  TreeInsert("DotaMorning", "DotaMorningRogueknight", "Rogueknight")
  TreeInsert("DotaMorning", "DotaMorningRogueknightL", "Rogueknight Learn")
  TreeInsert("DotaMorning", "DotaMorningNagaSiren", "Naga Siren")
  TreeInsert("DotaMorning", "DotaMorningNagaSirenL", "Naga Siren Learn")
  TreeInsert("DotaMorning", "DotaMorningEarthshaker", "Earthshaker")
  TreeInsert("DotaMorning", "DotaMorningEarthshakerL", "Earthshaker Learn")
  TreeInsert("DotaMorning", "DotaMorningStealthAssassin", "Stealth Assassin")
  TreeInsert("DotaMorning", "DotaMorningStealthAssassinL", "Stealth Assassin Learn")
  
  TreeInsert("DotaMorning", "DotaMorningLoneDruid", "Lone Druid")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidU", "Lone Druid: Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidD", "Lone Druid: True Form")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidL", "Lone Druid Learn")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidE", "Lone Druid (Synergy Level 1)")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEU", "Lone Druid (Synergy Level 1) Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidED", "Lone Druid (Synergy Level 1) True Form")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEL", "Lone Druid (Synergy Level 1) Learn")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEE", "Lone Druid (Synergy Level 2)")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEU", "Lone Druid (Synergy Level 2) Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEED", "Lone Druid (Synergy Level 2) True Form")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEL", "Lone Druid (Synergy Level 2) Learn")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEE", "Lone Druid (Synergy Level 3)")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEU", "Lone Druid (Synergy Level 3) Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEED", "Lone Druid (Synergy Level 3) True Form")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEL", "Lone Druid (Synergy Level 3) Learn")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEE", "Lone Druid (Synergy Level 4)")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEEU", "Lone Druid (Synergy Level 4) Auto-cast On")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEED", "Lone Druid (Synergy Level 4) True Form")
  TreeInsert("DotaMorning", "DotaMorningLoneDruidEEEEL", "Lone Druid (Synergy Level 4) Learn")
  
  TreeInsert("DotaMorning", "DotaMorningSpiritBear", "Spirit Bear")
  TreeInsert("DotaMorning", "DotaMorningSlayer", "Slayer")
  TreeInsert("DotaMorning", "DotaMorningSlayerL", "Slayer Learn")
  TreeInsert("DotaMorning", "DotaMorningSlayerScepter", "Slayer (Aghanim's Scepter)")
  TreeInsert("DotaMorning", "DotaMorningSlayerScepterL", "Slayer (Aghanim's Scepter) Learn")
  TreeInsert("DotaMorning", "DotaMorningJuggernaut", "Juggernaut")
  TreeInsert("DotaMorning", "DotaMorningJuggernautL", "Juggernaut Learn")

  TreeInsert("DotaSunrise", "DotaSunriseSilencer", "Silencer")
  TreeInsert("DotaSunrise", "DotaSunriseSilencerL", "Silencer Learn")
  TreeInsert("DotaSunrise", "DotaSunriseTreantProtector", "Treant Protector")
  TreeInsert("DotaSunrise", "DotaSunriseTreantProtectorL", "Treant Protector Learn")
  TreeInsert("DotaSunrise", "DotaSunriseEnigma", "Enigma")
  TreeInsert("DotaSunrise", "DotaSunriseEnigmaL", "Enigma Learn")
  TreeInsert("DotaSunrise", "DotaSunriseKeeperOfLight", "Keeper of the Light")
  TreeInsert("DotaSunrise", "DotaSunriseKeeperOfLightL", "Keeper of the Light Learn")
  TreeInsert("DotaSunrise", "DotaSunriseKeeperOfLightScepter", "Keeper of the Light (Aghanim's Scepter)")
  TreeInsert("DotaSunrise", "DotaSunriseKeeperOfLightScepterL", "Keeper of the Light (Aghanim's Scepter) Learn")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuus", "Ignis Fatuus")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuusU", "Ignis Fatuus: Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuusTwo", "Ignis Fatuus Level 2")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuusTwoU", "Ignis Fatuus (2): Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuusThree", "Ignis Fatuus Level 3")
  TreeInsert("DotaSunrise", "DotaSunriseIgnisFatuusThreeU", "Ignis Fatuus (3): Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseLiberatedSoul", "Liberated Soul")
  TreeInsert("DotaSunrise", "DotaSunriseLiberatedSoulU", "Liberated Soul: Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseUrsaWarrior", "Ursa Warrior")
  TreeInsert("DotaSunrise", "DotaSunriseUrsaWarriorL", "Ursa Warrior Learn")
  
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagi", "Ogre Magi")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiU", "Ogre Magi: Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiL", "Ogre Magi Learn")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiE", "Ogre Magi (Multi-cast 1)")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEU", "Ogre Magi (Multi-cast 1): Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEL", "Ogre Magi (Multi-cast 1) Learn")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEE", "Ogre Magi (Multi-cast 2)")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEEU", "Ogre Magi (Multi-cast 2): Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEEL", "Ogre Magi (Multi-cast 2) Learn")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEEE", "Ogre Magi (Multi-cast 3)")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEEEU", "Ogre Magi (Multi-cast 3): Auto-cast On")
  TreeInsert("DotaSunrise", "DotaSunriseOgreMagiEEEL", "Ogre Magi (Multi-cast 3) Learn")
  TreeInsert("DotaSunrise", "DotaSunriseTinker", "Tinker")
  TreeInsert("DotaSunrise", "DotaSunriseTinkerL", "Tinker Learn")
  TreeInsert("DotaSunrise", "DotaSunriseProphet", "Prophet")
  TreeInsert("DotaSunrise", "DotaSunriseProphetL", "Prophet Learn")
  TreeInsert("DotaSunrise", "DotaSunriseProphetScepter", "Prophet (Aghanim's Scepter)")
  TreeInsert("DotaSunrise", "DotaSunriseProphetScepterL", "Prophet (Aghanim's Scepter) Learn")
  TreeInsert("DotaSunrise", "DotaSunrisePhantomLancer", "Phantom Lancer")
  TreeInsert("DotaSunrise", "DotaSunrisePhantomLancerL", "Phantom Lancer Learn")
  TreeInsert("DotaSunrise", "DotaSunriseStoneGiant", "Stone Giant")
  TreeInsert("DotaSunrise", "DotaSunriseStoneGiantL", "Stone Giant Learn")
  TreeInsert("DotaSunrise", "DotaSunriseGoblinTechies", "Goblin Techies")
  TreeInsert("DotaSunrise", "DotaSunriseGoblinTechiesL", "Goblin Techies Learn")
  TreeInsert("DotaSunrise", "DotaSunriseRemoteMine", "Remote Mine")
  TreeInsert("DotaSunrise", "DotaSunriseHolyKnight", "Holy Knight")
  TreeInsert("DotaSunrise", "DotaSunriseHolyKnightL", "Holy Knight Learn")
  
  TreeInsert("DotaTavern", "DotaTavernMoonRider", "Moon Rider")
  TreeInsert("DotaTavern", "DotaTavernMoonRiderL", "Moon Rider Learn")
  TreeInsert("DotaTavern", "DotaTavernMoonRiderScepter", "Moon Rider (Aghanim's Scepter)")
  TreeInsert("DotaTavern", "DotaTavernMoonRiderScepterL", "Moon Rider (Aghanim's Scepter) Learn")
  TreeInsert("DotaTavern", "DotaTavernDwarvenSniper", "Dwarven Sniper")
  TreeInsert("DotaTavern", "DotaTavernDwarvenSniperL", "Dwarven Sniper Learn")
  TreeInsert("DotaTavern", "DotaTavernTrollWarlord", "Troll Warlord")
  TreeInsert("DotaTavern", "DotaTavernTrollWarlordD", "Troll Warlord: Skills Active")
  TreeInsert("DotaTavern", "DotaTavernTrollWarlordL", "Troll Warlord Learn")
  TreeInsert("DotaTavern", "DotaTavernShadowShaman", "Shadow Shaman")
  TreeInsert("DotaTavern", "DotaTavernShadowShamanL", "Shadow Shaman Learn")
  TreeInsert("DotaTavern", "DotaTavernShadowShamanScepter", "Shadow Shaman (Aghanim's Scepter)")
  TreeInsert("DotaTavern", "DotaTavernShadowShamanScepterL", "Shadow Shaman (Aghanim's Scepter) Learn")
  TreeInsert("DotaTavern", "DotaTavernBristleback", "Bristleback")
  TreeInsert("DotaTavern", "DotaTavernBristlebackL", "Bristleback Learn")
  TreeInsert("DotaTavern", "DotaTavernPandarenBattlemaster", "Pandaren Battlemaster")
  TreeInsert("DotaTavern", "DotaTavernPandarenBattlemasterL", "Pandaren Battlemaster Learn")
  TreeInsert("DotaTavern", "DotaTavernStorm", "Pandaren Battlemaster: Storm")
  TreeInsert("DotaTavern", "DotaTavernEarth", "Pandaren Battlemaster: Earth")
  TreeInsert("DotaTavern", "DotaTavernFire", "Pandaren Battlemaster: Fire")
  TreeInsert("DotaTavern", "DotaTavernCentaurWarchief", "Centaur Warchief")
  TreeInsert("DotaTavern", "DotaTavernCentaurWarchiefL", "Centaur Warchief Learn")
  TreeInsert("DotaTavern", "DotaTavernBountyHunter", "Bounty Hunter")
  TreeInsert("DotaTavern", "DotaTavernBountyHunterL", "Bounty Hunter Learn")
  TreeInsert("DotaTavern", "DotaTavernDragonKnight", "Dragon Knight")
  TreeInsert("DotaTavern", "DotaTavernDragonKnightL", "Dragon Knight Learn")
  TreeInsert("DotaTavern", "DotaTavernAntiMage", "Anti-Mage")
  TreeInsert("DotaTavern", "DotaTavernAntiMageL", "Anti-Mage Learn")
  TreeInsert("DotaTavern", "DotaTavernDrowRanger", "Drow Ranger")
  TreeInsert("DotaTavern", "DotaTavernDrowRangerU", "Drow Ranger: Auto-cast On")
  TreeInsert("DotaTavern", "DotaTavernDrowRangerL", "Drow Ranger Learn")
  TreeInsert("DotaTavern", "DotaTavernOmniknight", "Omniknight")
  TreeInsert("DotaTavern", "DotaTavernOmniknightL", "Omniknight Learn")
  
  TreeInsert("DotaDawn", "DotaDawnBeastmaster", "Beastmaster")
  TreeInsert("DotaDawn", "DotaDawnBeastmasterL", "Beastmaster Learn")
  TreeInsert("DotaDawn", "DotaDawnTwinHeadDragon", "Twin Head Dragon")
  TreeInsert("DotaDawn", "DotaDawnTwinHeadDragonL", "Twin Head Dragon Learn")

  TreeInsert("DotaMidnight", "DotaMidnightSoulKeeper", "Soul Keeper")
  TreeInsert("DotaMidnight", "DotaMidnightSoulKeeperL", "Soul Keeper Learn")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoul", "Tormented Soul")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoulD", "Tormented Soul: Skills Active")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoulL", "Tormented Soul Learn")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoulScepter", "Tormented Soul (Aghanim's Scepter)")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoulScepterD", "Tormented Soul (Aghanim's Scepter): Skills Active")
  TreeInsert("DotaMidnight", "DotaMidnightTormentedSoulScepterL", "Tormented Soul (Aghanim's Scepter) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightLich", "Lich")
  TreeInsert("DotaMidnight", "DotaMidnightLichU", "Lich: Auto-cast On")
  TreeInsert("DotaMidnight", "DotaMidnightLichL", "Lich Learn")
  TreeInsert("DotaMidnight", "DotaMidnightLichScepter", "Lich (Aghanim's Scepter)")
  TreeInsert("DotaMidnight", "DotaMidnightLichScepterU", "Lich (Aghanim's Scepter): Auto-cast On")
  TreeInsert("DotaMidnight", "DotaMidnightLichScepterL", "Lich (Aghanim's Scepter) Learn")
  
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphet", "Death Prophet")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetL", "Death Prophet Learn")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetE", "Death Prophet (Witchcraft 1)")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEL", "Death Prophet (Witchcraft 1) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEE", "Death Prophet (Witchcraft 2)")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEEL", "Death Prophet (Witchcraft 2) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEEE", "Death Prophet (Witchcraft 3)")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEEEL", "Death Prophet (Witchcraft 3) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEEEE", "Death Prophet (Witchcraft 4)")
  TreeInsert("DotaMidnight", "DotaMidnightDeathProphetEEEEL", "Death Prophet (Witchcraft 4) Learn")
  
  TreeInsert("DotaMidnight", "DotaMidnightDemonWitch", "Demon Witch")
  TreeInsert("DotaMidnight", "DotaMidnightDemonWitchL", "Demon Witch Learn")
  TreeInsert("DotaMidnight", "DotaMidnightDemonWitchScepter", "Demon Witch (Aghanim's Scepter)")
  TreeInsert("DotaMidnight", "DotaMidnightDemonWitchScepterL", "Demon Witch (Aghanim's Scepter) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightVenomancer", "Venomancer")
  TreeInsert("DotaMidnight", "DotaMidnightVenomancerL", "Venomancer Learn")
  TreeInsert("DotaMidnight", "DotaMidnightVenomancerScepter", "Venomancer (Aghanim's Scepter)")
  TreeInsert("DotaMidnight", "DotaMidnightVenomancerScepterL", "Venomancer (Aghanim's Scepter) Learn")
  TreeInsert("DotaMidnight", "DotaMidnightMagnataur", "Magnataur")
  TreeInsert("DotaMidnight", "DotaMidnightMagnataurL", "Magnataur Learn")
  TreeInsert("DotaMidnight", "DotaMidnightNecrolic", "Necro'lic")
  TreeInsert("DotaMidnight", "DotaMidnightNecrolicL", "Necro'lic Learn")
  TreeInsert("DotaMidnight", "DotaMidnightChaosKnight", "Chaos Knight")
  TreeInsert("DotaMidnight", "DotaMidnightChaosKnightL", "Chaos Knight Learn")
  TreeInsert("DotaMidnight", "DotaMidnightLycanthrope", "Lycanthrope")
  TreeInsert("DotaMidnight", "DotaMidnightLycanthropeL", "Lycanthrope Learn")
  TreeInsert("DotaMidnight", "DotaMidnightBroodmother", "Broodmother")
  TreeInsert("DotaMidnight", "DotaMidnightBroodmotherU", "Broodmother: Auto-cast On")
  TreeInsert("DotaMidnight", "DotaMidnightBroodmotherL", "Broodmother Learn")
  TreeInsert("DotaMidnight", "DotaMidnightSpiderling", "Spiderling")
  TreeInsert("DotaMidnight", "DotaMidnightSpiderlingU", "Spiderling: Auto-cast On")
  TreeInsert("DotaMidnight", "DotaMidnightPhantomAssassin", "Phantom Assassin")
  TreeInsert("DotaMidnight", "DotaMidnightPhantomAssassinL", "Phantom Assassin Learn")

  TreeInsert("DotaEvening", "DotaEveningGordon", "Gordon")
  TreeInsert("DotaEvening", "DotaEveningGordonD", "Gordon (Skills Active)")
  TreeInsert("DotaEvening", "DotaEveningGordonL", "Gordon Learn")
  TreeInsert("DotaEvening", "DotaEveningNightStalker", "Night Stalker")
  TreeInsert("DotaEvening", "DotaEveningNightStalkerL", "Night Stalker Learn")
  TreeInsert("DotaEvening", "DotaEveningSkeletonKing", "Skeleton King")
  TreeInsert("DotaEvening", "DotaEveningSkeletonKingL", "Skeleton King Learn")
  TreeInsert("DotaEvening", "DotaEveningDoomBringer", "Doom Bringer")
  TreeInsert("DotaEvening", "DotaEveningDoomBringerL", "Doom Bringer Learn")
  TreeInsert("DotaEvening", "DotaEveningNerubianAssassin", "Nerubian Assassin")
  TreeInsert("DotaEvening", "DotaEveningNerubianAssassinL", "Nerubian Assassin Learn")
  TreeInsert("DotaEvening", "DotaEveningSlithereenGuard", "Slithereen Guard")
  TreeInsert("DotaEvening", "DotaEveningSlithereenGuardU", "Slithereen Guard: Auto-cast On")
  TreeInsert("DotaEvening", "DotaEveningSlithereenGuardL", "Slithereen Guard Learn")
  TreeInsert("DotaEvening", "DotaEveningQueenOfPain", "Queen of Pain")
  TreeInsert("DotaEvening", "DotaEveningQueenOfPainL", "Queen of Pain Learn")
  TreeInsert("DotaEvening", "DotaEveningQueenOfPainScepter", "Queen of Pain (Aghanim's Scepter)")
  TreeInsert("DotaEvening", "DotaEveningQueenOfPainScepterL", "Queen of Pain (Aghanim's Scepter) Learn")
  TreeInsert("DotaEvening", "DotaEveningBoneFletcher", "Bone Fletcher")
  TreeInsert("DotaEvening", "DotaEveningBoneFletcherU", "Bone Fletcher: Auto-cast On")
  TreeInsert("DotaEvening", "DotaEveningBoneFletcherL", "Bone Fletcher Learn")
  TreeInsert("DotaEvening", "DotaEveningFacelessVoid", "Faceless Void")
  TreeInsert("DotaEvening", "DotaEveningFacelessVoidL", "Faceless Void Learn")
  TreeInsert("DotaEvening", "DotaEveningNetherdrake", "Netherdrake")
  TreeInsert("DotaEvening", "DotaEveningNetherdrakeU", "Netherdrake: Auto-cast On")
  TreeInsert("DotaEvening", "DotaEveningNetherdrakeL", "Netherdrake Learn")
  TreeInsert("DotaEvening", "DotaEveningLightningRevenant", "Lightning Revenant")
  TreeInsert("DotaEvening", "DotaEveningLightningRevenantL", "Lightning Revenant Learn")
  TreeInsert("DotaEvening", "DotaEveningLifestealer", "Lifestealer")
  TreeInsert("DotaEvening", "DotaEveningLifestealerL", "Lifestealer Learn")
  
  TreeInsert("DotaTwilight", "DotaTwilightOblivion", "Oblivion")
  TreeInsert("DotaTwilight", "DotaTwilightOblivionL", "Oblivion Learn")
  TreeInsert("DotaTwilight", "DotaTwilightOblivionScepter", "Oblivion (Aghanim's Scepter)")
  TreeInsert("DotaTwilight", "DotaTwilightOblivionScepterL", "Oblivion (Aghanim's Scepter) Learn")
  TreeInsert("DotaTwilight", "DotaTwilightTidehunter", "Tidehunter")
  TreeInsert("DotaTwilight", "DotaTwilightTidehunterL", "Tidehunter Learn")
  TreeInsert("DotaTwilight", "DotaTwilightBaneElemental", "BaneElemental")
  TreeInsert("DotaTwilight", "DotaTwilightBaneElementalL", "BaneElemental Learn")
  TreeInsert("DotaTwilight", "DotaTwilightNecrolyte", "Necrolyte")
  TreeInsert("DotaTwilight", "DotaTwilightNecrolyteL", "Necrolyte Learn")
  TreeInsert("DotaTwilight", "DotaTwilightNecrolyteScepter", "Necrolyte (Aghanim's Scepter)")
  TreeInsert("DotaTwilight", "DotaTwilightNecrolyteScepterL", "Necrolyte (Aghanim's Scepter) Learn")
  TreeInsert("DotaTwilight", "DotaTwilightButcher", "Butcher")
  TreeInsert("DotaTwilight", "DotaTwilightButcherD", "Butcher: Skills Active")
  TreeInsert("DotaTwilight", "DotaTwilightButcherL", "Butcher Learn")
  TreeInsert("DotaTwilight", "DotaTwilightSpiritbreaker", "Spiritbreaker")
  TreeInsert("DotaTwilight", "DotaTwilightSpiritbreakerL", "Spiritbreaker Learn")
  TreeInsert("DotaTwilight", "DotaTwilightNerubianWeaver", "Nerubian Weaver")
  TreeInsert("DotaTwilight", "DotaTwilightNerubianWeaverL", "Nerubian Weaver Learn")
  TreeInsert("DotaTwilight", "DotaTwilightWatcher", "Watcher")
  TreeInsert("DotaTwilight", "DotaTwilightShadowFiend", "Shadow Fiend")
  TreeInsert("DotaTwilight", "DotaTwilightShadowFiendL", "Shadow Fiend Learn")
  TreeInsert("DotaTwilight", "DotaTwilightSandKing", "Sand King")
  TreeInsert("DotaTwilight", "DotaTwilightSandKingL", "Sand King Learn")
  TreeInsert("DotaTwilight", "DotaTwilightAxe", "Axe")
  TreeInsert("DotaTwilight", "DotaTwilightAxeL", "Axe Learn")
  TreeInsert("DotaTwilight", "DotaTwilightBloodseeker", "Bloodseeker")
  TreeInsert("DotaTwilight", "DotaTwilightBloodseekerL", "Bloodseeker Learn")
  TreeInsert("DotaTwilight", "DotaTwilightLordOfAvernus", "Lord of Avernus")
  TreeInsert("DotaTwilight", "DotaTwilightLordOfAvernusL", "Lord of Avernus Learn")

  TreeInsert("DotaDusk", "DotaDuskAvatarOfVengeance", "Avatar of Vengeance")
  TreeInsert("DotaDusk", "DotaDuskAvatarOfVengeanceL", "Avatar of Vengeance Learn")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctor", "Witch Doctor")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctorD", "Witch Doctor: Skills Active")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctorL", "Witch Doctor Learn")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctorScepter", "Witch Doctor (Aghanim's Scepter)")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctorScepterD", "Witch Doctor (Aghanim's Scepter): Skills Active")
  TreeInsert("DotaDusk", "DotaDuskWitchDoctorScepterL", "Witch Doctor (Aghanim's Scepter) Learn")
  TreeInsert("DotaDusk", "DotaDuskObsidianDestroyer", "Obsidian Destroyer")
  TreeInsert("DotaDusk", "DotaDuskObsidianDestroyerU", "Obsidian Destroyer: Auto-cast On")
  TreeInsert("DotaDusk", "DotaDuskObsidianDestroyerL", "Obsidian Destroyer Learn")
  
  TreeInsert("DotaCreeps", "DotaCreepsSatyrHellcaller", "Satyr Hellcaller")
  TreeInsert("DotaCreeps", "DotaCreepsSatyrSoulstealer", "Satyr Soulstealer")
  TreeInsert("DotaCreeps", "DotaCreepsSatyrTrickser", "Satyr Trickser")
  TreeInsert("DotaCreeps", "DotaCreepsPolarFurlborgUrsaWarrior", "Polar Furlborg Ursa Warrior")
  TreeInsert("DotaCreeps", "DotaCreepsCentaurKhan", "Centaur Khan")
  TreeInsert("DotaCreeps", "DotaCreepsOgreMagi", "Ogre Magi")
  TreeInsert("DotaCreeps", "DotaCreepsOgreMagiU", "Ogre Magi: Auto-cast On")
  TreeInsert("DotaCreeps", "DotaCreepsForestTrollHighPriest", "Forest Troll High Priest")
  TreeInsert("DotaCreeps", "DotaCreepsForestTrollHighPriestU", "Forest Troll High Priest: Auto-cast On")
  TreeInsert("DotaCreeps", "DotaCreepsKoboldTaskmaster", "Kobold Taskmaster")
  TreeInsert("DotaCreeps", "DotaCreepsKoboldTunneler", "Kobold Tunneler")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconArcher", "Necronomicon Archer 1")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconArcherTwo", "Necronomicon Archer 2")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconArcherThree", "Necronomicon Archer 3")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconWarrior", "Necronomicon Warrior 1")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconWarriorTwo", "Necronomicon Warrior 2")
  TreeInsert("DotaCreeps", "DotaCreepsNecronomiconWarriorThree", "Necronomicon Warrior 3")
  TreeInsert("DotaCreeps", "DotaCreepsGiantWolf", "Giant Wolf")
  TreeInsert("DotaCreeps", "DotaCreepsGnollAssassin", "Gnoll Assassin")
}

; one of trees subroutines
TreeInsert(hParent, strName, Text2Insert)
{ 
  global

  nRChParent := nRC%hParent%
  ;listvars
  ;MsgBox, nRChParent = %nRChParent%
  
  nRC := DllCall("AHKTreeSupport\TreeInsertItem", DWORD, TreeHwnd, Str, Text2Insert, DWORD, nRChParent, DWORD, hLastInsertedItem, "Cdecl Int")
  if (errorlevel <> 0) || (nRC = 0)
  {
    Gui +OwnDialogs
    MsgBox, 0, Error!, error while calling TreeInsertItem Errorlevel: %errorlevel% - RC: %nRC%`nThe program will now exit.
	  ExitApp
  }
  else
  {
    nCode = 1 ;1=Collapse / 2=Expand / 3=toggle / 0x4000=expand partial / 0x8000=collapsereset
    nRCExpand := DllCall("AHKTreeSupport\TreeExpandCollapse", UINT, TreeHwnd, UINT, nRChParent, UINT, nCode, "Cdecl Int")
    if (errorlevel <> 0) ;|| (nRC = 0)
    {
       Gui +OwnDialogs
       MsgBox, 0, Error!, error while calling TreeExpandCollapse Errorlevel: %errorlevel%`nThe program will now exit.
	     ExitApp
    }
  }
  nRC%strName% := nRC
  m_rgTreeList%nRC% = rgpCIconGrid%strName%
  
  m_iTreeCount++
  m_rgTreeGridList%m_iTreeCount% = rgpCIconGrid%strName%
  
  ;msgbox, %Text2Insert% = %nRC%
  ;return nRC ; pointer to most recently created object or 0 if unable to create                 
}
Return

; one of trees subroutines
GetChildHWND(ParentHWND, ChildClassNN)
{
   WinGetPos, ParentX, ParentY,,, ahk_id %ParentHWND%
   if ParentX =
      return  ; Parent window not found (possibly due to DetectHiddenWindows).
   ControlGetPos, ChildX, ChildY,,, %ChildClassNN%, ahk_id %ParentHWND%
   if ChildX =
      return  ; Child window not found, so return a blank value.
   return DllCall("WindowFromPoint", "int", ChildX + ParentX, "int", ChildY + ParentY)
}

; read items from the tree
DumpInfo(wParam, lParam, msg, hwnd)
{
  global ;access to all global vars

	nRC := DllCall("AHKTreeSupport\TreeGetNMHDR", DWORD, lParam, "int *", dwHwnd, "int *", dwID, "int *", dwCode, "CDecl int")
	if dwCode = -451
	{
		hTreeItem := DllCall("AHKTreeSupport\TreeGetSelectedItem", DWORD, dwHwnd, "CDecl int")
		if hTreeItem = 0
		{
			return
		}
		Length = 300
		VarSetCapacity(szValue, Length)
		nRC := DllCall("AHKTreeSupport\TreeGetItemText", UINT, dwHwnd, UINT, hTreeItem, "Str", szValue, int, Length, "Cdecl int")
		if (errorlevel <> 0) || (nRC = 0)
		{
      Gui +OwnDialogs
		  MsgBox, 0, Error!, error while calling TreeGetItemText Errorlevel: %errorlevel%. RC: %nRC%
	    ;ExitApp ; The program should not exit in the middle of doing stuff, users could lose data!
		}

    prgpCIconGridCurrent := m_rgTreeList%hTreeItem%
    ;GridLoadGrids()
    GridDrawCurrentGrid()		  
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;   Grid Funcs   ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GridLoadCmds() ; loads the data associated with the Icons
; GridLoadGrids() ; loads all the grids into memory
; GridDrawCurrentGrid ; Draws Current Grid
; GridAlignKey(kstrCodeName) ; sets all hotkeys based on buttonpos
; GridAlignHotKey(strHotkey, iCurrentButtonPos) ; sets hotkey based on

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;   Grid Top   ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Note: Grid.ahk was getting too big, so it was split into gridtop and gridbot
; GridLoadCmds() ; loads the data associated with the Icons

GridInit()
{
  global
  
  Loop
  {
    strIconName := m_rgTreeGridList%A_Index%
    
    i := 0
    Loop, 12
    {
      %strIconName%%i% = 
      i++    
    }
  
    if (A_Index >= m_iTreeCount)
      break
  }
}

; this is where the commands are loaded
GridLoadCmds()
{
  global
  
  ;kpCIconListStart = cmdrally
  ;pCIconListCurrent = cmdrally
  m_iCIconCount = 1
  
  ; Auto Read Start DO NOT EDIT/REMOVE THIS LINE
 
  ; Grid Stuff
  CIcon_CIconGridKey("WarkeysGrid0", 0, "Q", "Hotkey Button Pos 0,0", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid3", 3, "W", "Hotkey Button Pos 1,0", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid6", 6, "E", "Hotkey Button Pos 2,0", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid9", 9, "R", "Hotkey Button Pos 3,0", "BTNTemp")

  CIcon_CIconGridKey("WarkeysGrid1", 1, "A", "Hotkey Button Pos 0,1", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid4", 4, "S", "Hotkey Button Pos 1,1", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid7", 7, "D", "Hotkey Button Pos 2,1", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid10", 10, "F", "Hotkey Button Pos 3,1", "BTNTemp")

  CIcon_CIconGridKey("WarkeysGrid2", 2, "Z", "Hotkey Button Pos 0,2", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid5", 5, "X", "Hotkey Button Pos 1,2", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid8", 8, "C", "Hotkey Button Pos 2,2", "BTNTemp")
  CIcon_CIconGridKey("WarkeysGrid11", 11, "V", "Hotkey Button Pos 3,2", "BTNTemp")
  
  ; Learn Grid
  CIcon_CIconGridKey("WarkeysLearnGrid0", 0, "Q", "Learn Hotkey Button Pos 0,0", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid3", 3, "W", "Learn Hotkey Button Pos 1,0", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid6", 6, "E", "Learn Hotkey Button Pos 2,0", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid9", 9, "R", "Learn Hotkey Button Pos 3,0", "BTNShoveler")

  CIcon_CIconGridKey("WarkeysLearnGrid1", 1, "A", "Learn Hotkey Button Pos 0,1", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid4", 4, "S", "Learn Hotkey Button Pos 1,1", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid7", 7, "D", "Learn Hotkey Button Pos 2,1", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid10", 10, "F", "Learn Hotkey Button Pos 3,1", "BTNShoveler")

  CIcon_CIconGridKey("WarkeysLearnGrid2", 2, "Z", "Learn Hotkey Button Pos 0,2", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid5", 5, "X", "Learn Hotkey Button Pos 1,2", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid8", 8, "C", "Learn Hotkey Button Pos 2,2", "BTNShoveler")
  CIcon_CIconGridKey("WarkeysLearnGrid11", 11, "V", "Learn Hotkey Button Pos 3,2", "BTNShoveler")
  
  ;Building Basics
  CIcon_CIconSeparate("cmdrally", "ARal", 10, "Y", "Set Rally Point", "BTNRallyPoint")
  CIcon_CIcon("cmdcancelbuild", 11, "ESC", "Cancel", "BTNCancel")
  ;Shop Basics
  CIcon_CIcon("anei", 11, "U", "Select User", "BTNSelectUnit")
  ; Player Shop Basics
  CIcon_CIcon("plcl", 3, "C", "Purchase Lesser Clarity Potion", "BTNLesserClarityPotion")
  CIcon_CIcon("dust", 9, "D", "Purchase Dust of Appearance", "BTNDustofAppearance")
  CIcon_CIcon("phea", 1, "P", "Purchase Potion of Healing", "BTNPotionGreenSmall")
  CIcon_CIcon("pman", 4, "M", "Purchase Potion of Mana", "BTNPotionBlueSmall")
  CIcon_CIcon("stwp", 7, "T", "Purchase Scroll of Town Portal", "BTNScrollUber")
  CIcon_CIcon("shea", 5, "H", "Purchase Scroll of Healing", "BTNScrollofTownPortal")
  ; Cancel
  CIcon_CIcon("cmdcancel", 11, "ESC", "Cancel", "BTNCancel")
  ;CIconcmdcancel_bIsUnchangeable := true
  ;Hero Basics
  CIcon_CIcon("cmdselectskill", 10, "O", "Set Hero Ability", "BTNSkillz")
  ;Catapult Basics
  CIcon_CIcon("cmdattackground", 10, "G", "Attack Ground", "BTNAttackGround")
  ; Pillage
  CIcon_CIconN("asal", 5, "Pillage", "BTNPillage")
  ; Dispel
  CIcon_CIcon("adsm", 2, "D", "Dispel Magic", "BTNDispelMagic")
  ; Resistant Skin
  CIcon_CIconN("acrk", 11, "Resistant Skin", "BTNThickFur")
  ; Resistant Skin 2
  CIcon_CIconN("acsk", 10, "Resistant Skin", "BTNThickFur")
  ; Spell Immunity Green: used by dryad/spellbreaker
  CIcon_CIconN("amim", 8, "Spell Immunity", "BTNResistMagic")
  ; Spell Immunity Black
  CIcon_CIconN("acmi", 8, "Spell Immunity", "BTNGenericSpellImmunity")
  ; Abolish Magic
  CIcon_CIconU("acd2", 5, "B", "Abolish Magic", "BTNDryadDispelMagic")
  ;Hide
  CIcon_CIcon("ashm", 7, "I", "Hide", "BTNAmbush")
  ;Peon Basics
  CIcon_CIconD("ahar", 10, 10, "G", "E", "Gather", "Return Resources", "BTNGatherGold", "BTNReturnGoods")
  ;Unit Basics
  CIcon_CIcon("cmdmove", 0, "M", "Move", "BTNMove")
  CIcon_CIcon("cmdstop", 3, "S", "Stop", "BTNStop")
  CIcon_CIcon("cmdholdpos", 6, "H", "Hold Position", "BTNHoldPosition")
  CIcon_CIcon("cmdattack", 9, "A", "Attack", "BTNAttack")
  CIcon_CIcon("cmdpatrol", 1, "P", "Patrol", "BTNPatrol")
   
  ;Town Hall
  CIcon_CIcon("hpea", 0, "P", "Train Peasant", "BTNPeasant")
  CIcon_CIcon("rhpm", 9, "B", "Research Backpack", "BTNPackBeast")
  CIcon_CIcon("hkee", 2, "U", "Upgrade to Keep", "BTNTownHall")
  CIcon_CIconD("amic", 5, 8, "C", "W", "Call to Arms", "Back to Work", "BTNCallToArms", "BTNBacktoWork")
  ;Keep
  CIcon_CIcon("hcas", 2, "U", "Upgrade to Castle", "BTNCastle")
  ;Human Altar
  CIcon_CIconH("Hamg", 2, "A", "Archmage", "BTNHeroArchMage")
  CIcon_CIconH("Hmkg", 5, "M", "Mountain King", "BTNHeroMountainKing")
  CIcon_CIconH("Hpal", 8, "L", "Paladin", "BTNHeroPaladin")
  CIcon_CIconH("Hblm", 1, "B", "Blood Mage", "BTNHeroBloodElfPrince")
  ;Barracks
  CIcon_CIcon("hfoo", 0, "F", "Train Footman", "BTNFootman")
  CIcon_CIcon("hrif", 3, "R", "Train Rifleman", "BTNRifleman")
  CIcon_CIcon("hkni", 6, "K", "Train Knight", "BTNKnight")
  CIcon_CIcon("rhde", 2, "D", "Research Defend", "BTNDefend")
  CIcon_CIcon("rhri", 5, "L", "Upgrade to Long Rifles", "BTNDwarvenLongRifle")
  CIcon_CIcon("rhan", 8, "A", "Research Animal War Training", "BTNAnimalWarTraining")
  ;Lumber Mill
  CIcon_CIcon2("rhlh", 0, "L", "L", "Improved Lumber Harvesting", "Advanced Lumber Harvesting", "BTNHumanLumberUpgrade1",  "BTNHumanLumberUpgrade2")
  CIcon_CIcon3("rhac", 3, "M", "M", "M", "Upgrade to Improved Masonry", "Upgrade to Advanced Masonry", "Upgrade to Imbued Masonry", "BTNStoneArchitecture", "BTNArcaniteArchitecture", "BTNImbuedMasonry")
  ;Blacksmith
  CIcon_CIcon3("rhme", 0, "S", "S", "S", "Upgrade to Iron Forged Swords", "Upgrade to Steel Forged Swords", "Upgrade to Mithril Forged Swords", "BTNSteelMelee", "BTNThoriumMelee", "BTNArcaniteMelee")
  CIcon_CIcon3("rhra", 3, "G", "G", "G", "Upgrade to Black Gunpowder", "Upgrade Refined Gunpowder", "Upgrade to Imbued Gunpowder", "BTNHumanMissileUpOne", "BTNHumanMissileUpTwo", "BTNHumanMissileUpThree")
  CIcon_CIcon3("rhar", 1, "P", "P", "P", "Upgrade to Iron Plating", "Upgrade to Steel Plating", "Upgrade to Mithril Plating", "BTNHumanArmorUpOne", "BTNHumanArmorUpTwo", "BTNHumanArmorUpThree")
  CIcon_CIcon3("rhla", 4, "A", "A", "A", "Upgrade to Studded Leather Armor", "Upgrade to Reinforced Leather Armor", "Upgrade to Dragonhide Armor", "BTNLeatherUpgradeOne", "BTNLeatherUpgradeTwo", "BTNLeatherUpgradeThree")
  ;Arcane Sanctum
  CIcon_CIcon("hsor", 0, "S", "Train Sorceress", "BTNSorceress")
  CIcon_CIcon("hmpr", 3, "P", "Train Priest", "BTNPriest")
  CIcon_CIcon("hspt", 6, "B", "Train Spell Breaker", "BTNSpellBreaker")
  CIcon_CIcon("rhss", 7, "G", "Research Control Magic", "BTNControlMagic")
  CIcon_CIcon2("rhst", 2, "O", "O", "Sorceress Adept Training", "Sorceress Master Training", "BTNSorceressAdept", "BTNSorceressMaster")
  CIcon_CIcon2("rhpt", 5, "T", "T", "Priest Adept Training", "Priest Master Training", "BTNPriestAdept", "BTNPriestMaster")
  CIcon_CIcon("rhse", 8, "M", "Research Magic Sentry", "BTNMagicalSentry")
  ;Workshop
  CIcon_CIcon("hgyr", 0, "G", "Train Flying Machine", "BTNGyrocopter")
  CIcon_CIcon("hmtm", 3, "M", "Train Mortar Team", "BTNMortarTeam")
  CIcon_CIcon("hmtt", 6, "T", "Train Siege Engine", "BTNSeigeEngine")
  CIcon_CIcon("hrtt", 6, "T", "Train Siege Engine", "BTNSeigeEngineWithMissles")
  CIcon_CIcon("rhfc", 1, "C", "Research Flak Cannons", "BTNFlakCannons")
  CIcon_CIcon("rhfs", 4, "S", "Research Fragmentation Shards", "BTNFragmentationBombs")
  CIcon_CIcon("rhgb", 2, "B", "Research Flying Machine Bombs", "BTNHumanArtilleryUpOne")
  CIcon_CIcon("rhfl", 5, "F", "Research Flare", "BTNFlare")
  CIcon_CIcon("rhrt", 8, "R", "Research Barrage", "BTNScatterRockets")
  ;Gryphon Aviary
  CIcon_CIcon("hgry", 0, "G", "Train Gryphon Rider", "BTNGryphonRider")
  CIcon_CIcon("hdhw", 3, "D", "Train Dragon Hawk", "BTNDragonHawk")
  CIcon_CIcon("rhhb", 2, "H", "Research Storm Hammers", "BTNStormHammer")
  CIcon_CIcon("rhcd", 5, "C", "Research Cloud", "BTNCloudofFog")
  ;Tower Scout
  CIcon_CIcon("hgtw", 2, "G", "Upgrade to Guard Tower", "BTNGuardTower")
  CIcon_CIcon("hctw", 5, "C", "Upgrade to Cannon Tower", "BTNCannonTower")
  CIcon_CIcon("hatw", 8, "N", "Upgrade to Arcane Tower", "BTNHumanArcaneTower")  
  ;Tower Arcane
  CIcon_CIcon("ahta", 2, "R", "Reveal", "BTNReveal")
  CIcon_CIconN("adts", 7, "Magic Sentry", "BTNMagicalSentry")
  CIcon_CIconN("afbt", 0, "Feedback", "BTNFeedback")
  ;Arcane Vault
  CIcon_CIcon("sreg", 0, "R", "Purchase Scroll of Regeneration", "BTNScrollofRegenerationGreen")
  ;CIcon_CIcon("plcl", 3, "C", "Purchase Lesser Clarity Potion", "BTNLesserClarityPotion")
  CIcon_CIcon("mcri", 6, "E", "Purchase Mechanical Critter", "BTNMechanicalCritter")
  ;CIcon_CIcon("phea", 1, "P", "Purchase Potion of Healing", "BTNPotionGreenSmall")
  ;CIcon_CIcon("pman", 4, "M", "Purchase Potion of Mana", "BTNPotionBlueSmall")
  ;CIcon_CIcon("stwp", 7, "T", "Purchase Scroll of Town Portal", "BTNScrollofTownPortal")
  CIcon_CIcon("tsct", 10, "V", "Purchase Ivory Tower", "BTNHumanWatchTower")
  CIcon_CIcon("ofir", 2, "F", "Purchase Orb of Fire", "BTNOrbofFire")
  CIcon_CIcon("ssan", 5, "N", "Purchase Staff of Sanctuary", "BTNStaffofSanctuary")
  
  ; Dragon Hawk
  CIcon_CIcon("amls", 2, "E", "Aerial Shackles", "BTNMagicLariet")
  CIcon_CIcon("aclf", 5, "C", "Cloud", "BTNCloudofFog")
  ; Gryphon Rider
  CIcon_CIconN("asth", 2, "Storm Hammers", "BTNStormHammer")
  ; Steam Tank  
  CIcon_CIconN("aroc", 2, "Barrage", "BTNScatterRockets")    
  ; Footman
  CIcon_CIconD("adef", 2, 2, "D", "D", "Defend", "Stop Defend", "BTNDefend", "BTNDefendStop")
  ; Mortar Team
  CIcon_CIcon("afla", 2, "F", "Flare", "BTNFlare")
  CIcon_CIconN("afsh", 5, "Fragmentation Shards", "BTNFragmentationBombs")
  ; Flying Machine
  CIcon_CIconN("agyv", 5, "True Sight", "BTNExpandedView")
  CIcon_CIconN("aflk", 8, "Flak Cannons", "BTNFlakCannons")
  CIcon_CIconN("agyb", 11, "Flying Machine Bombs", "BTNHumanArtilleryUpOne")
  ; Peasant
  CIcon_CIconSeparate("cmdbuildhuman", "AHbu", 2, "B", "Build Structure", "BTNHumanBuild")
  CIcon_CIconU("ahrp", 4, "R", "Repair", "BTNRepair")
  CIcon_CIconD("amil", 5, 8, "C", "W", "Call to Arms", "Return to Work", "BTNCalltoArms", "BTNBacktoWork")
  ; Peasant-Build
  CIcon_CIcon("htow", 0, "H", "Build Town Hall", "BTNTownHall")
  CIcon_CIcon("hbar", 3, "B", "Build Barracks", "BTNHumanBarracks")
  CIcon_CIcon("hlum", 6, "L", "Build Lumber Mill", "BTNHumanLumberMill")
  CIcon_CIcon("hbla", 9, "S", "Build Blacksmith", "BTNBlacksmith")
  CIcon_CIcon("hhou", 1, "F", "Build Farm", "BTNFarm")
  CIcon_CIcon("halt", 4, "A", "Build Altar of Kings", "BTNAltarofKings")
  CIcon_CIcon("hars", 7, "R", "Build Arcane Sanctum", "BTNArcaneSanctum")
  CIcon_CIcon("harm", 10, "W", "Build Workshop", "BTNWorkshop")
  CIcon_CIcon("hwtw", 2, "T", "Build Scout Tower", "BTNHumanWatchTower")
  CIcon_CIcon("hgra", 5, "G", "Build Gryphon Aviary", "BTNGryphonAviary")
  CIcon_CIcon("hvlt", 8, "V", "Build Arcane Vault", "BTNArcaneVault")
  ; Priest
  CIcon_CIconU("ahea", 2, "E", "Heal", "BTNHeal")
  CIcon_CIcon("adis", 5, "D", "Dispel Magic", "BTNDispelMagic")
  CIcon_CIconU("ainf", 8, "I", "Inner Fire", "BTNInnerfire")
  ; Sorceress
  CIcon_CIconU("aslo", 2, "W", "Slow", "BTNSlow")
  CIcon_CIcon("aivs", 5, "I", "Invisibility", "BTNInvisibility")
  CIcon_CIcon("aply", 8, "O", "Polymorph", "BTNPolymorph")
  ; Spell Breaker
  CIcon_CIconU("asps", 2, "T", "Spell Steal", "BTNSpellSteal")
  CIcon_CIcon("acmg", 5, "C", "Control Magic", "BTNControlMagic")
  ;CIcon_CIconN("amim", 8, "Spell Immunity", "BTNResistMagic") ; used by dryad
  CIcon_CIconN("afbk", 11, "Feedback", "BTNFeedback")
  
  ;Archmage
  CIcon_CIconHS("ahbz", 2, "B", "Blizzard", "BTNBlizzard")
  CIcon_CIconHS("ahwe", 5, "W", "Summon Water Elemental", "BTNSummonWaterElemental")
  CIcon_CIconHSN("ahab", 8, "R", "Brilliance Aura", "BTNBrilliance")
  CIcon_CIconHS6("ahmt", 11, "T", "Mass Teleport", "BTNMassTeleport")
  ;Blood Mage
  CIcon_CIconHS("AHfs", 2, "F", "Flame Strike", "BTNWallofFire")
  CIcon_CIconHS("AHbn", 5, "B", "Banish", "BTNBanish")
  CIcon_CIconHS("AHdr", 8, "N", "Siphon Mana", "BTNManaDrain")
  CIcon_CIconHS6("AHpx", 11, "X", "Summon Phoenix", "BTNMarkofFire")
  ;Mountain King
  CIcon_CIconHS("AHtb", 2, "T", "Storm Bolt", "BTNStormBolt")
  CIcon_CIconHS("AHtc", 5, "C", "Thunder Clap", "BTNThunderClap")
  CIcon_CIconHSN("AHbh", 8, "B", "Bash", "BTNBash")
  CIcon_CIconHS6("AHav", 11, "V", "Avatar", "BTNAvatar")
  ;Paladin
  CIcon_CIconHS("AHhb", 2, "T", "Holy Light", "BTNHolyBolt")
  CIcon_CIconHS("AHds", 5, "D", "Divine Shield", "BTNDivineIntervention")
  CIcon_CIconHSN("AHad", 8, "V", "Devotion Aura", "BTNDevotion")
  CIcon_CIconHS6("AHre", 11, "R", "Resurrection", "BTNResurrection")
	
  ; Orc Buildings
	; Altar of Storms
	CIcon_CIcon("oshd", 1, "S", "Summon Shadow Hunter", "BTNShadowHunter")
  CIcon_CIcon("obla", 2, "B", "Summon Blademaster", "BTNHeroBladeMaster")
  CIcon_CIcon("ofar", 5, "F", "SummonFar Seer", "BTNHeroFarSeer")
  CIcon_CIcon("otch", 8, "T", "Summon Tauren Chieftain", "BTNHeroTaurenChieftain")
  ;Barracks
  CIcon_CIcon("ogru", 0, "G", "Train Grunt", "BTNGrunt")
  CIcon_CIcon("ohun", 3, "H", "Train Troll Headhunter", "BTNHeadhunter")
  CIcon_CIcon("otbk", 3, "T", "Train Troll Berserker", "BTNHeadHunterBerserker")
  CIcon_CIcon("ocat", 6, "C", "Train Demolisher", "BTNDemolisher")
  CIcon_CIcon("robk", 4, "E", "Berserker Upgrade", "BTNHeadhunterBerserker")
  CIcon_CIcon("robs", 2, "B", "Research Berserker Strength", "BTNBerserk")
  CIcon_CIcon("rotr", 5, "T", "Research Troll Regeneration", "BTNRegenerate")
  CIcon_CIcon("robf", 8, "N", "Burning Oil", "BTNFireRocks")
  ;Beastiary
  CIcon_CIcon("orai", 0, "R", "Train Raider", "BTNRaider")
  CIcon_CIcon("owyv", 3, "W", "Train Wind Rider", "BTNWyvernRider")
  CIcon_CIcon("okod", 6, "K", "Train Kodo Beast", "BTNKotobeast")
  CIcon_CIcon("otbr", 9, "B", "Train Troll Batrider", "BTNTrollBatRider")
  CIcon_CIcon("roen", 2, "E", "Research Ensnare", "BTNEnsnare")
  CIcon_CIcon("rovs", 4, "E", "Research Envenomed Weapon", "BTNEnvenomedSpear")
  CIcon_CIcon("rwdm", 8, "D", "Upgrade War Drums", "BTNDrum")
  CIcon_CIcon("rolf", 7, "L", "Research Liquid Fire", "BTNLiquidFire")
  ;Burrow
  CIcon_CIcon("abtl", 2, "B", "Battle Stations", "BTNBattlestations")
  CIcon_CIcon("astd", 5, "D", "Stand Down", "BTNBacktoWork")
  ;Spirit Lodge
  CIcon_CIcon("oshm", 0, "S", "Train Shaman", "BTNShaman")
  CIcon_CIcon("odoc", 3, "W", "Train Troll Witch Doctor", "BTNWitchDoctor")
  CIcon_CIcon("ospm", 6, "T", "Train Spirit Walker", "BTNSpiritWalker")
  CIcon_CIcon2("rost", 2, "M", "M", "Shaman Adept Training", "Shaman Master Training", "BTNShamanAdept", "BTNShamanMaster")
  CIcon_CIcon2("rowd", 5, "D", "D", "Witch Doctor Adept Training", "Witch Doctor Master Training", "BTNWitchDoctorAdept", "BTNWitchDoctorMaster")
  CIcon_CIcon2("rowt", 8, "R", "R", "Spirit Walker Adept Training", "Spirit Walker Master Training", "BTNSpiritWalkerAdeptTraining", "BTNSpiritWalkerMasterTraining")
  ;Tauren Totem
  CIcon_CIcon("otau", 0, "T", "Train Tauren", "BTNTauren")
  CIcon_CIcon("rows", 2, "P", "Research Pulverize", "BTNSmash")
  ;Town Hall
  CIcon_CIcon("opeo", 0, "P", "Train Peon", "BTNPeon")
  CIcon_CIcon("ropg", 6, "G", "Research Pillage", "BTNPillage")
  CIcon_CIcon("ropm", 9, "B", "Research Backpack", "BTNPackBeast")
  CIcon_CIcon("ostr", 2, "U", "Upgrade To Stronghold", "BTNStronghold")
  ;Stronghold
  CIcon_CIcon("ofrt", 2, "U", "Upgrade To Fortress", "BTNFortress")
  ;Voodoo Lounge
  CIcon_CIcon("hslv", 0, "H", "Purchase Healing Salve", "BTNHealingSalve")
  ;CIcon_CIcon("plcl", 3, "C", "Purchase Lesser Clarity Potion", "BTNLesserClarityPotion")
  CIcon_CIcon("shas", 6, "D", "Purchase Scroll of Speed", "BTNScrollofHaste")
  ;CIcon_CIcon("phea", 1, "P", "Purchase Potion of Healing", "BTNPotionGreenSmall")
  ;CIcon_CIcon("pman", 4, "M", "Purchase Potion of Mana", "BTNPotionBlueSmall")
  ;CIcon_CIcon("stwp", 7, "T", "Purchase Scroll of Town Portal", "BTNScrollUber")
  CIcon_CIcon("oli2", 2, "L", "Purchase Orb of Lightning", "BTNOrbofLightning")
  CIcon_CIcon("tgrh", 5, "G", "Purchase Tiny Great Hall", "BTNGreatHall")
  ;War Mill
  CIcon_CIcon3("rome", 0, "M", "M", "M", "Upgrade to Steel Melee Weapons", "Upgrade to Thorium Melee Weapons", "Upgrade to Arcanite Melee Weapons", "BTNOrcMeleeUpone",  "BTNOrcMeleeUpTwo", "BTNOrcMeleeUpThree")
  CIcon_CIcon3("rora", 3, "R", "R", "R", "Upgrade to Steel Ranged Weapons", "Upgrade to Thorium Ranged Weapons", "Upgrade to Arcanite Ranged Weapons", "BTNSteelRanged", "BTNThoriumRanged", "BTNArcaniteRanged")
  CIcon_CIcon3("rosp", 6, "S", "S", "S", "Upgrade to Spiked Barricades", "Upgrade to Improved Spiked Barricades", "Upgrade to Advanced Spike Barricades", "BTNSpikedBarricades",  "BTNImprovedSpikedBarricades", "BTNAdvancedSpikedBarricades")
  CIcon_CIcon3("roar", 1, "A", "A", "A", "Upgrade to Steel Unit Armor", "Upgrade to Thorium Unit Armor", "Upgrade to Arcanite Unit Armor", "BTNSteelArmor", "BTNThoriumArmor", "BTNArcaniteArmor")
  CIcon_CIcon("rorb", 7, "B", "Reinforced Defenses", "BTNReinforcedBurrows")
  
  ; Orc Heros
  ; Far Seer
  CIcon_CIconHS("aocl", 2, "C", "Chain Lightning", "BTNChainLightning")
  CIcon_CIconHS("aofs", 5, "F", "Far Sight", "BTNFarSight")
  CIcon_CIconHS("aosf", 8, "T", "Feral Spirit", "BTNSpiritWolf")
  CIcon_CIconHS6("aoeq", 11, "E", "Earthquake", "BTNEarthquake")
  ; Tauren Chieftain
  CIcon_CIconHS("aosh", 2, "W", "Shockwave", "BTNShockwave")
  CIcon_CIconHS("aows", 5, "T", "War Stomp", "BTNWarStomp")
  CIcon_CIconHSN("aoae", 8, "E", "Endurance Aura", "BTNCommand")
  CIcon_CIconHS6N("aore", 11, "R", "Reincarnation", "BTNReincarnation")
  ; Blademaster
  CIcon_CIconHS("aowk", 2, "W", "Wind Walk", "BTNWindWalkOn")
  CIcon_CIconHS("aomi", 5, "R", "Mirror Image", "BTNMirrorImage")
  CIcon_CIconHSN("aocr", 8, "C", "Critical Strike", "BTNCriticalStrike")
  CIcon_CIconHS6("aoww", 11, "B", "Bladestorm", "BTNWhirlWind")
  ; Shadow Hunter
  CIcon_CIconHS("aohw", 2, "E", "Healing Wave", "BTNHealingWave")
  CIcon_CIconHS("aohx", 5, "X", "Hex", "BTNHex")
  CIcon_CIconHS("aosw", 8, "W", "Serpent Ward", "BTNSerpentWard")
  CIcon_CIconHS6("aovd", 11, "V", "Big Bad Voodoo", "BTNBigBadVoodooSpell")
  ; Orc Units
  ; Peon
  CIcon_CIconU("arep", 4, "R", "Repair", "BTNRepair")
  CIcon_CIconSeparate("cmdbuildorc", "AObu", 2, "B", "Build Structure", "BTNBasicStruct")
  ; Peon:Build
  CIcon_CIcon("ogre", 0, "H", "Build Great Hall", "BTNGreatHall")
  CIcon_CIcon("obar", 3, "B", "Build Barracks", "BTNBarracks")
  CIcon_CIcon("ofor", 6, "M", "Build War Mill", "BTNForge")
  CIcon_CIcon("owtw", 9, "W", "Build Watch Tower", "BTNOrcTower")
  CIcon_CIcon("otrb", 1, "O", "Build Burrow", "BTNTrollBurrow")
  CIcon_CIcon("oalt", 4, "A", "Build Altar of Storms", "BTNAltarofStorms")
  CIcon_CIcon("osld", 7, "S", "Build Spirit Lodge", "BTNSpiritLodge")
  CIcon_CIcon("obea", 10, "E", "Build Beastiary", "BTNBeastiary")
  CIcon_CIcon("otto", 2, "T", "Build Tauren Totem", "BTNTaurenTotem")
  CIcon_CIcon("ovln", 5, "V", "Build Voodoo Lounge", "BTNVoodooLounge")
  ; Troll Berserker
  CIcon_CIcon("absk", 2, "B", "Berserk", "BTNHeadhunterBerserker")
  ; Demolisher
  CIcon_CIconN("abof", 2, "Burning Oil", "BTNFireRocks")
  ; Shaman
  CIcon_CIcon("aprg", 2, "G", "Purge", "BTNPurge")
  CIcon_CIcon("apg2", 2, "G", "Purge", "BTNPurge")
  CIcon_CIcon("alsh", 5, "L", "Lightning Shield", "BTNLightningShield")
  CIcon_CIconU("ablo", 8, "B", "Bloodlust", "BTNBloodLust")
  ; Troll Witch Doc
  CIcon_CIcon("aeye", 2, "W", "Sentry Ward", "BTNSentryWard")
  CIcon_CIcon("asta", 5, "T", "Stasis Trap", "BTNStasisTrap")
  CIcon_CIcon("ahwd", 8, "E", "Healing Ward", "BTNHealingWard")
  ; Spirit Walker
  CIcon_CIcon("aspl", 2, "R", "Spirit Link", "BTNSpiritLink")
  CIcon_CIcon("adcn", 5, "D", "Disenchant", "BTNDisenchant")
  CIcon_CIcon("aast", 8, "C", "Ancestral Spirit", "BTNAncestralSpirit")
  CIcon_CIconD("acpf", 11, 11, "F", "F", "Corporeal Form", "Ethereal Form", "BTNSpiritWalker", "BTNEtherealFormOn")
  ; Raider
  CIcon_CIcon("aens", 2, "E", "Ensnare", "BTNEnsnare")
  ; Wind Raider
  CIcon_CIconN("aven", 2, "Envenomed Spears", "BTNEnvenomedSpear")
  ; Kodo Beast
  CIcon_CIcon("adev", 2, "D", "Devour", "BTNDevour")
  CIcon_CIconN("aakb", 5, "War Drums", "BTNDrum")
  ; Troll Batrider
  CIcon_CIcon("auco", 2, "C", "Unstable Concoction", "BTNUnstableConcoction")
  CIcon_CIconN("aliq", 5, "Liquid Fire", "BTNLiquidFire")
  ; Tauren
  CIcon_CIconN("awar", 2, "Pulverize", "BTNSmash")
  ; Feral Spirit
  CIcon_CIconN("acct", 8, "Critical Strike", "BTNCriticalStrike")
  
  ; Undead
  ; Undead Buildings
  ; Necropolis
  CIcon_CIcon("uaco", 0, "C", "Train Acolyte", "BTNAcolyte")
  CIcon_CIcon("unp1", 2, "U", "Upgrade to Halls of the Dead", "BTNHalloftheDead")
  CIcon_CIcon("rupm", 9, "B", "Research Backpack", "BTNPackBeast")
  ; Halls of the Dead
  CIcon_CIcon("unp2", 2, "U", "Upgrade to Black Citadel", "BTNBlackCitadel")
  CIcon_CIconN("afr2", 5, "Frost Attack", "BTNFrost")
  ; Ziggurat
  CIcon_CIcon("uzg1", 2, "T", "Upgrade to Spirit Tower", "BTNZigguratUpgrade")
  CIcon_CIcon("uzg2", 5, "N", "Upgrade to Nerubian Tower", "BTNFrostTower")
  ; Nerubian Tower
  CIcon_CIconN("afra", 2, "Frost Attack", "BTNFrost")
  ; Altar of Darkness
  CIcon_CIcon("udea", 2, "D", "Death Knight", "BTNHeroDeathKnight")
  CIcon_CIcon("udre", 5, "E", "Dreadlord", "BTNHeroDreadlord")
  CIcon_CIcon("ulic", 8, "L", "Lich", "BTNHeroLich")
  CIcon_CIcon("ucrl", 1, "C", "Crypt Lord", "BTNHeroCryptLord")
  ; Crypt
  CIcon_CIcon("ugho", 0, "G", "Train Ghoul", "BTNGhoul")
  CIcon_CIcon("ucry", 3, "F", "Train Crypt Fiend", "BTNCryptFiend")
  CIcon_CIcon("ugar", 6, "A", "Train Gargoyle", "BTNGargoyle")
  CIcon_CIcon("ruac", 1, "C", "Research Cannibalize", "BTNCannibalize")
  CIcon_CIcon("rubu", 4, "B", "Research Burrow", "BTNCryptFiendBurrow")
  CIcon_CIcon("rugf", 2, "Z", "Research Ghoul Frenzy", "BTNGhoulFrenzy")
  CIcon_CIcon("ruwb", 5, "W", "Research Web", "BTNWeb")
  CIcon_CIcon("rusf", 8, "S", "Research Stone Form", "BTNStoneForm")
  ; Graveyard
  CIcon_CIcon3("rume", 0, "S", "S", "S", "Unholy Strength", "Improved Unholy Strength", "Advanced Unholy Strength", "BTNUnholyStrength", "BTNImprovedUnholyStrength", "BTNAdvancedUnholyStrength")
  CIcon_CIcon3("ruar", 1, "U", "U", "U", "Unholy Armor", "Improved Unholy Armor", "Advanced Unholy Armor", "BTNUnholyArmor", "BTNImprovedUnholyArmor", "BTNAdvancedUnholyArmor")
  CIcon_CIcon3("rura", 3, "A", "A", "A", "Creature Attack", "Improved Creature Attack", "Advanced Creature Attack", "BTNCreatureAttack", "BTNImprovedCreatureAttack", "BTNAdvancedCreatureAttack")
  CIcon_CIcon3("rucr", 4, "C", "C", "C", "Creature Carapace", "Improved Creature Carapace", "Advanced Creature Carapace", "BTNCreatureCarapace", "BTNImprovedCreatureCarapace", "BTNAdvancedCreatureCarapace")
  ; Temple of the Damned aka N-BEAMS or M-BEANS
  CIcon_CIcon("unec", 0, "N", "Train Necromancer", "BTNNecromancer")
  CIcon_CIcon("uban", 3, "B", "Train Banshee", "BTNBanshee")
  CIcon_CIcon2("rune", 2, "N", "N", "Necromancer Adept Training", "Necromancer Master Training", "BTNNecromancerAdept", "BTNNecromancerMaster")
  CIcon_CIcon2("ruba", 5, "A", "A", "Banshee Adept Training", "Banshee Master Training", "BTNBansheeAdept", "BTNBansheeMaster")
  CIcon_CIcon("rusm", 7, "M", "Research Skeletal Mastery", "BTNSkeletonMage")
  CIcon_CIcon("rusl", 8, "S", "Research Skeletal Longevity", "BTNSkeletalLongevity")
  ; Slaughterhouse
  CIcon_CIcon("umtw", 0, "M", "Train Meat Wagon", "BTNMeatWagon")
  CIcon_CIcon("uabo", 3, "A", "Train Abomination", "BTNAbomination")
  CIcon_CIcon("uobs", 6, "O", "Create Obsidian Statue", "BTNObsidianStatue")
  CIcon_CIcon("ruex", 2, "E", "Research Exhume Corpses", "BTNExhumeCorpses")
  CIcon_CIcon("rupc", 5, "D", "Research Disease Cloud", "BTNPlagueCloud")
  CIcon_CIcon("rusp", 8, "T", "Research Destroyer Form", "BTNDestroyer")
  ; Sacrificial Pit
  CIcon_CIcon("asac", 0, "C", "Sacrifice", "BTNSacrifice")
  ; Boneyard
  CIcon_CIcon("ufro", 0, "F", "Train Frost Wyrm", "BTNFrostWyrm")
  CIcon_CIcon("rufb", 2, "B", "Research Freezing Breath", "BTNFreezingBreath")
  ; Tomb of Relics
  CIcon_CIcon("rnec", 0, "R", "Purchase Rod of Necromancy", "BTNRodofNecromancy")
  CIcon_CIcon("skul", 6, "B", "Purchase Sacrificial Skull", "BTNSacrificialSkull")
  ;CIcon_CIcon("dust", 9, "D", "Purchase Dust of Appearance", "BTNDustofAppearance")
  CIcon_CIcon("ocor", 2, "B", "Purchase Orb of Corruption", "BTNOrbofCorruption")
  ;CIcon_CIcon("shea", 5, "H", "Purchase Scroll of Healing", "BTNScrollofHealing")
  ; Undead Units
  ; Acolyte
  CIcon_CIconSeparate("cmdbuildundead", "AUbu", 2, "B", "Summon Building", "BTNScourgeBuild")
  CIcon_CIcon("auns", 5, "U", "Unsummon Building", "BTNUnsummonBuilding")
  CIcon_CIconU("arst", 4, "R", "Restore", "BTNRepair")
  CIcon_CIcon("aaha", 10, "G", "Gather", "BTNGatherGold")
  CIcon_CIcon("alam", 11, "C", "Sacrifice", "BTNSacrifice")
  ; Acolyte Build
  CIcon_CIcon("unpl", 0, "N", "Summon Necropolis", "BTNNecropolis")
  CIcon_CIcon("usep", 3, "C", "Summon Crypt", "BTNCrypt")
  CIcon_CIcon("ugol", 6, "G", "Haunt Gold Mine", "BTNGoldmine")
  CIcon_CIcon("ugrv", 9, "V", "Summon Graveyard", "BTNGraveYard")
  CIcon_CIcon("uzig", 1, "Z", "Summon Ziggurat", "BTNZiggurat")
  CIcon_CIcon("uaod", 4, "A", "Summon Altar", "BTNAltarofDarkness")
  CIcon_CIcon("utod", 7, "T", "Summon Temple of the Damned", "BTNTempleoftheDamned")
  CIcon_CIcon("uslh", 10, "H", "Summon Slaughterhouse", "BTNSlaughterHouse")
  CIcon_CIcon("usap", 2, "S", "Summon Sacrificial Pit", "BTNSacrificialPit")
  CIcon_CIcon("ubon", 5, "B", "Summon Boneyard", "BTNBoneyard")
  CIcon_CIcon("utom", 8, "R", "Summon Tomb of Relics", "BTNTombofRelics")
  ; Ghoul
  CIcon_CIcon("acan", 2, "C", "Cannibalize", "BTNCannibalize")
  CIcon_CIconD("ahrl", 10, 10, "G", "E", "Gather", "Return Resources", "BTNGatherGold", "BTNReturnGoods")
  ; Crypt Fiend
  CIcon_CIconU("aweb", 2, "W", "Web", "BTNWeb")
  CIcon_CIconD("abur", 11, 11, "B", "B", "Burrow", "Unburrow", "BTNCryptFiendBurrow", "BTNCryptFiendUnBurrow")
  ; Gargoyle
  CIcon_CIconD("astn", 2, 2, "F", "F", "Stone Form", "Gargoyle Form", "BTNStoneForm", "BTNGargoyle")
  ; Necromancer
  CIcon_CIconU("arai", 2, "R", "Raise Dead", "BTNRaiseDead")
  CIcon_CIcon("auhf", 5, "U", "Unholy Frenzy", "BTNUnholyFrenzy")
  CIcon_CIcon("acri", 8, "C", "Cripple", "BTNCripple")
  ; Banshee
  CIcon_CIconU("acrs", 2, "C", "Curse", "BTNCurse")
  CIcon_CIcon("aams", 5, "N", "Anti-magic Shell", "BTNAntiMagicShell")
  CIcon_CIcon("aam2", 5, "N", "Anti-magic Shell", "BTNAntiMagicShell")
  CIcon_CIcon("apos", 8, "O", "Possession", "BTNPossession")
  CIcon_CIcon("aps2", 8, "O", "Possession", "BTNPossession")
  ; Meat Wagon
  CIcon_CIconU("amel", 2, "C", "Get Corpse", "BTNUndeadLoad")
  CIcon_CIcon("amed", 5, "D", "Drop All Corpses", "BTNUndeadUnload")
  CIcon_CIconN("apts", 8, "Disease Cloud", "BTNPlagueCloud")
  CIcon_CIconN("aexh", 11, "Exhume Corpses", "BTNExhumeCorpses")
  ; Abomination
  CIcon_CIcon("acn2", 2, "C", "Cannibalize", "BTNCannibalize")
  CIcon_CIconN("aap1", 5, "Disease Cloud", "BTNPlagueCloud")
  ; Obsidian Statue
  CIcon_CIconU("arpl", 2, "B", "Essence of Blight", "BTNReplenishHealth")
  CIcon_CIconU("arpm", 5, "C", "Spirit Touch", "BTNReplenishMana")
  CIcon_CIconSeparate("ubsp", "Aave", 11, "T", "Morph into Destroyer", "BTNDestroyer")
  ; Destroyer
  CIcon_CIcon("advm", 2, "D", "Devour Magic", "BTNDevourMagic")
  CIcon_CIconU("afak", 5, "O", "Orb of Annihilation", "BTNOrbofDeath")
  CIcon_CIcon("aabs", 11, "B", "Absorb Mana", "BTNAbsorbMagic")
  ; Shade
  CIcon_CIconN("atru", 2, "True Sight", "DLShadeTrueSight")
  ; Frost Wyrm
  CIcon_CIconN("afrz", 2, "Freezing Breath", "BTNFreezingBreath")
  ; Undead Heros
  ; Death Knight
  CIcon_CIconHS("audc", 2, "C", "Death Coil", "BTNDeathCoil")
  CIcon_CIconHS("audp", 5, "E", "Death Pact", "BTNDeathPact")
  CIcon_CIconHSN("auau", 8, "U", "Unholy Aura", "BTNUnholyAura")
  CIcon_CIconHS("auan", 11, "D", "Animate Dead", "BTNAnimateDead")
  ; Dreadlord
  CIcon_CIconHS("aucs", 2, "C", "Carrion Swarm", "BTNCarrionSwarm")
  if (bOpDotaDefault == false)
  {
    CIcon_CIconHS("ausl", 5, "F", "Sleep", "BTNSleep")
    CIcon_CIconHSN("auav", 8, "V", "Vampiric Aura", "BTNVampiricAura")
  }
  else ;switch for Dota
  {
    CIcon_CIconHS("ausl", 8, "F", "Sleep", "BTNSleep")
    CIcon_CIconHSN("auav", 5, "V", "Vampiric Aura", "BTNVampiricAura")
  }
  CIcon_CIconHS("auin", 11, "N", "Inferno", "BTNInfernal")
  ; Lich
  CIcon_CIconHS("aufn", 2, "N", "Frost Nova", "BTNGlacier")
  CIcon_CIconHSU("aufu", 5, "F", "Frost Armor", "BTNFrostArmor")
  CIcon_CIconHS("audr", 8, "R", "Dark Ritual", "BTNDarkRitual")
  CIcon_CIconHS("audd", 11, "D", "Death and Decay", "BTNDeathandDecay")
  ; Crypt Lord
  CIcon_CIconHS("auim", 2, "E", "Impale", "BTNImpale")
  CIcon_CIconHSN("auts", 5, "S", "Spiked Carapace", "BTNThornShield")
  CIcon_CIconHSU("aucb", 8, "C", "Carrion Beetles", "BTNCarrionScarabs")
  CIcon_CIconHS("auls", 11, "L", "Locust Swarm", "BTNLocustSwarm")
  ; Undead Hero Summons
  ; Infernal
  CIcon_CIconN("anpi", 2, "Permanent Immolation", "BTNImmolationOn")  
  ; Carrion Beetle
  CIcon_CIconD("abu2", 11, 11, "B", "B", "Burrow", "Unburrow", "BTNCryptFiendBurrow", "BTNCryptFiendUnBurrow")
  CIcon_CIconD("abu3", 11, 11, "B", "B", "Burrow", "Unburrow", "BTNCryptFiendBurrow", "BTNCryptFiendUnBurrow")
  
  ; Night Elf
  ; Night Elf Buildings
  ; Tree Uproot
  CIcon_CIconD("aro1", 11, 11, "R", "R", "Root", "Uproot", "BTNRoot", "BTNUproot")
  CIcon_CIconD("aro2", 11, 11, "R", "R", "Root", "Uproot", "BTNRoot", "BTNUproot")
  CIcon_CIcon("aeat", 2, "E", "Eat Tree", "BTNEatTree")
  ; Entangled Gold Mine
  CIcon_CIcon("slo2", 2, "L", "Load Wisp", "BTNLoad")
  CIcon_CIcon("adri", 5, "U", "Unload All", "BTNUnload")  
  ; Tree of Life Uproot
  ; Tree of Life
  CIcon_CIcon("ewsp", 0, "W", "Train Wisp", "BTNWisp")   
  CIcon_CIcon("renb", 6, "N", "Research Nature's Blessing", "BTNNaturesBlessing")   
  CIcon_CIcon("repm", 9, "B", "Research Backpack", "BTNPackBeast")   
  CIcon_CIcon("etoa", 2, "U", "Upgrade to Tree of Ages", "BTNTreeofAges")   
  CIcon_CIcon("aent", 5, "G", "Entangle Gold Mine", "BTNGoldMine")
  ; Tree of Ages
  CIcon_CIcon("etoe", 2, "U", "Upgrade to Tree of Eternity", "BTNTreeofEternity")
  ; Moon Well
  CIcon_CIconU("ambt", 0, "R", "Replenish Mana and Life", "BTNManaRecharge")
  ; Altar of Elders
  CIcon_CIcon("edem", 2, "D", "Demon Hunter", "BTNHeroDemonHunter")   
  CIcon_CIcon("ekee", 5, "K", "Keeper of the Grove", "BTNKeeperofTheGrove")   
  CIcon_CIcon("emoo", 8, "P", "Priestess of the Moon", "BTNPriestessofTheMoon")   
  CIcon_CIcon("ewar", 1, "W", "Warden", "BTNHeroWarden")   
  ; Ancient of War
  CIcon_CIcon("earc", 0, "A", "Train Archer", "BTNArcher")   
  CIcon_CIcon("esen", 3, "H", "Train Huntress", "BTNHuntress")   
  CIcon_CIcon("ebal", 6, "T", "Train Glaive Thrower", "BTNGlaiveThrower")   
  CIcon_CIcon("reib", 1, "I", "Research Improved Bows", "BTNImprovedBows")   
  CIcon_CIcon("resc", 4, "S", "Research Sentinel", "BTNSentinel")   
  CIcon_CIcon("remk", 2, "M", "Research Marksmanship", "BTNMarksmanship")   
  CIcon_CIcon("remg", 5, "G", "Upgrade Moon Glaive", "BTNUpgradeMoonGlaive")   
  CIcon_CIcon("repb", 8, "P", "Research Vorpal Blades", "BTNVorpalBlades")
  ; Hunter's Hall
  CIcon_CIcon3("resm", 0, "M", "M", "M", "Upgrade to Strength of the Moon", "Upgrade to Improved Strength of the Moon", "Upgrade to Advanced Strength of the Moon", "BTNStrengthofTheMoon", "BTNImprovedStrengthofTheMoon", "BTNAdvancedStrengthofTheMoon")   
  CIcon_CIcon3("rema", 1, "A", "A", "A", "Upgrade to Moon Armor", "Upgrade to Improved Moon Armor", "Upgrade to Advanced Moon Armor", "BTNMoonArmor", "BTNImprovedMoonArmor", "BTNAdvancedMoonArmor")   
  CIcon_CIcon3("resw", 3, "W", "W", "W", "Upgrade to Strength of the Wild", "Upgrade to Improved Strength of the Wild", "Upgrade to Advanced Strength of the Wild", "BTNStrengthofTheWild", "BTNImprovedStrengthofTheWild", "BTNAdvancedStrengthofTheWild")   
  CIcon_CIcon3("rerh", 4, "R", "R", "R", "Upgrade to Reinforced Hides", "Upgrade to Improved Reinforced Hides", "Upgrade to Advanced Reinforced Hides", "BTNReinforcedHides", "BTNImprovedReinforcedHides", "BTNAdvancedReinforcedHides")   
  CIcon_CIcon("reuv", 6, "U", "Research Ultravision", "BTNUltravision")   
  CIcon_CIcon("rews", 9, "E", "Research Well Spring", "BTNWellSpring")
  ; Ancient of Lore
  CIcon_CIcon("edry", 0, "D", "Train Dryad", "BTNDryad")   
  CIcon_CIcon("edoc", 3, "C", "Train Druid of the Claw", "BTNDruidofTheClaw")   
  CIcon_CIcon("emtg", 6, "G", "Train Mountain Giant", "BTNMountainGiant")   
  CIcon_CIcon("resi", 2, "S", "Research Abolish Magic", "BTNDryadDispelMagic")   
  CIcon_CIcon("reeb", 4, "M", "Research Mark of the Claw", "BTNEnchantedBears")   
  CIcon_CIcon2("redc", 5, "L", "L", "Druid of the Claw Adept Training", "Druid of the Claw Master Training", "BTNDOCAdeptTraining", "BTNDOCMasterTraining")   
  CIcon_CIcon("rehs", 7, "H", "Research Hardened Skin", "BTNHardenedSkin")   
  CIcon_CIcon("rers", 8, "T", "Research Resistant Skin", "BTNResistantSkin")
  ; Ancient of Wind
  CIcon_CIcon("ehip", 0, "H", "Train Hippogryph", "BTNHippogriff")   
  CIcon_CIcon("edot", 3, "T", "Train Druid of the Talon", "BTNDruidofTheTalon")   
  CIcon_CIcon("efdr", 6, "F", "Train Fairie Dragon", "BTNFaerieDragon")   
  CIcon_CIcon("reht", 2, "I", "Research Hippogryph Taming", "BTNTameHippogriff")   
  CIcon_CIcon("reec", 4, "M", "Research Mark of the Talon", "BTNEnchantedCrows")   
  CIcon_CIcon2("redt", 5, "A", "A", "Druid of the Talon Adept Training", "Druid of the Talon Master Training", "BTNDOTAdeptTraining", "BTNDOTMasterTraining")
  ; Chimaera Roost
  CIcon_CIcon("echm", 0, "C", "Train Chimaera", "BTNChimaera")   
  CIcon_CIcon("recb", 2, "B", "Research Corrosive Breath", "BTNCorrosiveBreath")
  ; Ancient of Wonders
  CIcon_CIcon("moon", 0, "N", "Purchase Moonstone", "BTNMoonstone")   
  ;CIcon_CIcon("plcl", 3, "C", "Purchase Lesser Clarity Potion", "BTNLesserClarityPotion")   
  ;CIcon_CIcon("dust", 9, "D", "Purchase Dust of Appearance", "BTNDustofAppearance")   
  CIcon_CIcon("spre", 10, "E", "Purchase Staff of Preservation", "BTNStaffofPreservation")   
  CIcon_CIcon("oven", 2, "V", "Purchase Orb of Venom", "BTNOrbofVenom")   
  CIcon_CIcon("pams", 5, "A", "Purchase Anti-magic Potion", "BTNSnazzyPotion")
  
  ; Night Elf Units
  ; Wisp
  CIcon_CIconSeparate("cmdbuildnightelf", "AEbu", 2, "B", "Create Building", "BTNNightElfBuild")   
  CIcon_CIconU("aren", 4, "R", "Renew", "BTNWispHeal")   
  CIcon_CIcon("adtn", 5, "D", "Detonate", "BTNWispSplode")   
  CIcon_CIcon("awha", 10, "G", "Gather", "BTNGatherGold")   
  ; Wisp Build
  CIcon_CIcon("etol", 0, "T", "Create Tree of Life", "BTNTreeofLife")   
  CIcon_CIcon("eaom", 3, "R", "Create Ancient of War", "BTNAncientofTheEarth")   
  CIcon_CIcon("edob", 6, "H", "Create Hunter's Hall", "BTNHuntersHall")   
  CIcon_CIcon("etrp", 9, "P", "Create Ancient Protector", "BTNTreant")   
  CIcon_CIcon("emow", 1, "M", "Create Moon Well", "BTNMoonWell")   
  CIcon_CIcon("eate", 4, "A", "Create Altar of Elders", "BTNAltarofElders")   
  CIcon_CIcon("eaoe", 7, "L", "Create Ancient of Lore", "BTNAncientofLore")   
  CIcon_CIcon("eaow", 2, "W", "Create Ancient of Wind", "BTNAncientofTheMoon")   
  CIcon_CIcon("edos", 5, "C", "Create Chimaera Roost", "BTNChimaeraRoost")   
  CIcon_CIcon("eden", 8, "D", "Create Ancient of Wonders", "BTNAncientofWonders")   
  ; Archer
  CIcon_CIcon("aco2", 2, "U", "Mount Hippogryph", "BTNHippogriffRider")   
  CIcon_CIconN("aegr", 5, "Elune's Grace", "BTNElunesGrace")   
  ; Huntress
  CIcon_CIcon("aesn", 2, "E", "Sentinel", "BTNSentinel")   
  CIcon_CIconN("amgl", 5, "Moon Glaive", "BTNUpgradeMoonGlaive")   
  ; Glaive Thrower
  CIcon_CIconN("aimp", 2, "Vorpal Blades", "BTNVorpalBlades")   
  ; Dryad
  CIcon_CIconU("aadm", 2, "B", "Abolish Magic", "BTNDryadDispelMagic")   
  CIcon_CIconN("aspo", 5, "Slow Poison", "BTNSlowPoison")   
  ;CIcon_CIcon("amim", 8, "", "", "") ; used by spell breaker   
  ; Druid of the Claw
  CIcon_CIcon("aroa", 2, "R", "Roar", "BTNBattleRoar")   
  CIcon_CIcon("ara2", 2, "R", "Roar", "BTNBattleRoar")   
  CIcon_CIcon("arej", 5, "E", "Rejuvenation", "BTNRejuvenation")   
  CIcon_CIconD("abrf", 11, 11, "F", "F", "Bear Form", "Night Elf Form", "BTNBearForm", "BTNDruidofTheClaw")   
  ; Mountain Giant
  CIcon_CIcon("atau", 2, "T", "Taunt", "BTNTaunt")   
  CIcon_CIcon("agra", 5, "W", "War Club", "BTNGrabTree")   
  CIcon_CIconN("assk", 8, "Hardened Skin", "BTNHardenedSkin")   
  CIcon_CIconN("arsk", 11, "Resistant Skin", "BTNResistantSkin")   
  ; Hippogryph
  CIcon_CIcon("aco3", 2, "U", "Pick up Archer", "BTNHippogriffRider")   
  CIcon_CIcon("adec", 2, "U", "Dismount Archer `& Hippogryph", "BTNArcher")   
  ; Druid of the Talon
  CIcon_CIconU("afae", 2, "R", "Faerie Fire", "BTNFaerieFire")   
  CIcon_CIcon("acyc", 5, "C", "Cyclone", "BTNCyclone")   
  CIcon_CIconD("arav", 11, 11, "F", "F", "Storm Crow Form", "Night Elf Form", "BTNRavenForm", "BTNDruidofTheTalon")   
  ; Faerie Dragon
  CIcon_CIconU("apsh", 2, "E", "Phase Shift", "BTNPhaseShift")   
  CIcon_CIconD("amfl", 5, 5, "F", "F", "Mana Flare", "Stop Mana Flare", "BTNManaFlare", "BTNManaFlareOff")
  ; Chimaera  
  CIcon_CIconN("acor", 2, "Corrosive Breath", "BTNCorrosiveBreath")

  ; Night Elf Heroes
  ; Demon Hunter
  CIcon_CIconHS("aemb", 2, "B", "Mana Burn", "BTNManaBurn")   
  CIcon_CIconHSD("aeim", 5, 5, "L", "L", "Activate Immolation", "Deactivate Immolation", "BTNImmolationOn", "BTNImmolationOff")   
  CIcon_CIconHSN("aeev", 8, "E", "Evasion", "BTNEvasion")   
  CIcon_CIconHS6("aeme", 11, "T", "Metamorphosis", "BTNMetamorphosis")   
  ; Keeper of the Grove
  CIcon_CIconHS("aeer", 2, "E", "Entangling Roots", "BTNEntanglingRoots")
  if (bOpDotaDefault == false)
  {     
    CIcon_CIconHS("aefn", 5, "F", "Force of Nature", "BTNEnt")
    CIcon_CIconHSN("aeah", 8, "R", "Thorns Aura", "BTNThorns")
  }   
  else
  {   
    CIcon_CIconHS("aefn", 8, "F", "Force of Nature", "BTNEnt")
    CIcon_CIconHSN("aeah", 5, "R", "Thorns Aura", "BTNThorns")   
  }
  CIcon_CIconHS6("aetq", 11, "T", "Tranquility", "BTNTranquility")   
  ; Priestess of the Moon
  CIcon_CIconHS("aest", 2, "C", "Scout", "BTNScout")   
  CIcon_CIconHSU("ahfa", 5, "R", "Searing Arrows", "BTNSearingArrows")   
  CIcon_CIconHS("aear", 8, "T", "Trueshot Aura", "BTNTrueshot")   
  CIcon_CIconHS6("aesf", 11, "F", "Starfall", "BTNStarFall")   
  ; Warden
  CIcon_CIconHS("aebl", 5, "B", "Blink", "BTNBlink")   
  if (bOpDotaDefault == false)
  {
    CIcon_CIconHS("aefk", 2, "F", "Fan of Knives", "BTNFanofKnives")   
    CIcon_CIconHS("aesh", 8, "D", "Shadow Strike", "BTNShadowStrike")
  }
  else ; Switch for Dota
  {   
    CIcon_CIconHS("aefk", 8, "F", "Fan of Knives", "BTNFanofKnives")   
    CIcon_CIconHS("aesh", 2, "D", "Shadow Strike", "BTNShadowStrike")
  }   
  CIcon_CIconHS6("aesv", 11, "V", "Vengeance", "BTNSpiritofVengeance")
  ; Night Elf Hero Summons
  ; Owl Scout
  CIcon_CIconN("adtg", 2, "True Sight", "BTNScout")   
  ; Avatar of Vengeance   
  CIcon_CIconU("avng", 2, "V", "Spirit of Vengeance", "BTNAvengingWatcher")

  ; Neutral
  ; Neutral Buildings
  ; Tavern
  CIcon_CIcon("nngs", 1, "G", "Summon Naga Sea Witch", "BTNNagaSeaWitch")
  CIcon_CIcon("nbrn", 4, "R", "Summon Dark Ranger", "BTNBansheeRanger")
  CIcon_CIcon("npbm", 7, "N", "Summon Pandaren Brewmaster", "BTNPandarenBrewmaster")
  CIcon_CIcon("nfir", 10, "O", "Summon Firelord", "BTNFirelord")
  CIcon_CIcon("nplh", 2, "I", "Summon Pit Lord", "BTNPitLord")
  CIcon_CIcon("nbst", 5, "S", "Summon Beastmaster", "BTNBeastmaster")
  CIcon_CIcon("ntin", 8, "Z", "Summon Tinker", "BTNTinker")
  CIcon_CIcon("nalc", 11, "X", "Summon Alchemist", "BTNAlchemist")
  ; Goblin Merchant
  CIcon_CIcon("bspd", 0, "S", "Purchase Boots of Speed", "BTNBootsofSpeed")
  CIcon_CIcon("prvt", 3, "V", "Purchase Periapt of Vitality", "BTNPeriapt")
  CIcon_CIcon("cnob", 6, "C", "Purchase Circlet of Nobility", "BTNCirclet")
  ;CIcon_CIcon("dust", 9, "D", "Purchase Dust of Appearance", "BTNDustofAppearance")
  CIcon_CIcon("spro", 1, "R", "Purchase Scroll of Protection", "BTNScrollofProtection")
  CIcon_CIcon("pinv", 4, "I", "Purchase Potion of Invisibility", "BTNLesserInvisibility")
  ;CIcon_CIcon("stwp", 7, "T", "Purchase Scroll of Town Portal", "BTNScrollofTownPortal")
  CIcon_CIcon("stel", 10, "E", "Purchase Staff of Teleportation", "BTNStaffofTeleportation")
  CIcon_CIcon("tret", 2, "O", "Purchase Tome of Retraining", "BTNTomeofRetraining")
  ;CIcon_CIcon("shea", 5, "H", "Purchase Scroll of Healing", "BTNScrollofHealing")
  CIcon_CIcon("pnvl", 8, "N", "Purchase Potion of Lesser Invulnerability", "BTNLesserInvulneralbility")
  ; Goblin Laboratory
  CIcon_CIcon("ngsp", 0, "S", "Hire Goblin Sapper", "BTNGoblinSapper")
  CIcon_CIcon("nzep", 3, "Z", "Hire Goblin Zeppelin", "BTNGoblinZeppelin")
  CIcon_CIcon("ngir", 6, "G", "Hire Goblin Shredder", "BTNJunkGolem")
  CIcon_CIcon("andt", 9, "R", "Reveal", "BTNReveal")
  ; Mercenary Camp
  CIcon_CIcon("nfsp", 0, "P", "Hire Forest Troll Shadow Priest", "BTNForestTrollShadowPriest")
  CIcon_CIcon("nftb", 3, "B", "Hire Forest Troll Berserker", "BTNForestTroll")
  CIcon_CIcon("ngrk", 6, "U", "Summon Mud Golem", "BTNRockGolem")
  CIcon_CIcon("nogm", 9, "M", "Hire Ogre Mauler", "BTNOgre")
  ; Mercenary Camp (2)
  CIcon_CIcon("nkob", 0, "K", "Hire Kobold", "BTNKobold")
  CIcon_CIcon("nmrr", 3, "H", "Hire Murloc Huntsman", "BTNMurlocFleshEater")
  CIcon_CIcon("nass", 6, "A", "Hire Assassin", "BTNAssassin")
  CIcon_CIcon("nkog", 9, "G", "Hire Kobold Geomancer", "BTNKoboldGeomancer")
  ; Mercenary Camp (3)
  CIcon_CIcon("ncen", 0, "O", "Hire Centaur Outrunner", "BTNCentaur")
  CIcon_CIcon("nhrr", 3, "R", "Hire Harpy Rogue", "BTNHarpy")
  CIcon_CIcon("nhrw", 6, "W", "Hire Harpy Windwitch", "BTNHarpyWitch")
  CIcon_CIcon("nrzm", 9, "M", "Hire Razormane Medicine Man", "BTNRazormaneChief")
  
  ; Neutral units
  ; Goblin Zeppelin
  CIcon_CIcon("aloa", 2, "L", "Load", "BTNLoad")
  CIcon_CIcon("adro", 5, "U", "Unload All", "BTNUnload")  
  ; Goblin Sapper
  CIcon_CIconU("asds", 2, "B", "Kaboom!", "BTNSelfDestruct")
  ; Goblin Shredder
  CIcon_CIconD("ahr3", 10, 10, "G", "E", "Gather", "Return Resources", "BTNGatherGold", "BTNReturnGoods")
  ; Forest Troll Shadow Priest
  CIcon_CIconU("anh1", 2, "E", "Heal", "BTNHeal")
  CIcon_CIconU("acdm", 5, "B", "Abolish Magic", "BTNDryadDispelMagic")  
  ; Mud Golem
  CIcon_CIconU("acsw", 2, "W", "Slow", "BTNSlow")
  ; Murloc Huntsman
  CIcon_CIcon("acen", 2, "E", "Ensnare", "BTNEnsnare")
  CIcon_CIconN("acvs", 5, "Envenomed Weapons", "BTNEnvenomedSpear")
  ; Kobold Geomancer
  CIcon_CIconU("acs2", 2, "W", "Slow", "BTNSlow")
  ; Harp Wind witch
  CIcon_CIconU("afa2", 2, "R", "Faerie Fire", "BTNFaerieFire")
  ; Razormane Medicine Man
  CIcon_CIcon("achw", 2, "E", "Healing Ward", "BTNHealingWard")
  CIcon_CIcon("acsf", 5, "T", "Feral Spirit", "BTNSpiritWolf")
  ; Ice Revenant
  CIcon_CIcon("acfn", 2, "N", "Frost Nova", "BTNGlacier")
  CIcon_CIconN("acvp", 8, "Vampiric Aura", "BTNVampiricAura")
  
  ; Creeps
  ; Gnoll Overseer
  CIcon_CIconN("acac", 2, "Command Aura", "BTNGnollCommandAura")
  ; Forest Troll High Priest
  CIcon_CIconU("anh2", 2, "E", "Heal", "BTNHeal")
  CIcon_CIconU("acif", 8, "I", "Inner Fire", "BTNInnerfire")  
  
  ; Neutral Heroes
  ; Beastmaster
  CIcon_CIconHS("ANsg", 2, "B", "Summon Bear", "BTNGrizzlyBear")
  CIcon_CIconHS("ANsq", 5, "Q", "Quilbeast", "BTNQuillbeast")
  CIcon_CIconHS("ANsw", 8, "W", "Summon Hawk", "BTNWarEagle")
  CIcon_CIconHS6("ANst", 11, "T", "Stampede", "BTNStampede")
  ; Dark Ranger
  if (bOpDotaDefault = false)
  {
    CIcon_CIconHS("ansi", 2, "E", "Silence", "BTNSilence")
    CIcon_CIconHSU("anba", 5, "B", "Black Arrow", "BTNTheBlackArrow")
  }
  else ; switch these 2 spells for compatability with Dota
  {
    CIcon_CIconHSU("anba", 2, "B", "Black Arrow", "BTNTheBlackArrow")
    CIcon_CIconHS("ansi", 5, "E", "Silence", "BTNSilence")
  }
  CIcon_CIconHS("andr", 8, "D", "Life Drain", "BTNLifeDrain")
  CIcon_CIconHS6("anch", 11, "C", "Charm", "BTNCharm")
  ; Naga Sea Witch
	CIcon_CIconHS("anfl", 2, "F", "Forked Lightening", "BTNMonsoon")
	CIcon_CIconHSU("anfa", 5, "R", "Frost Arrows", "BTNColdArrows")
	CIcon_CIconHSD("anms", 8, 8, "N", "N", "Activate Mana Shield", "Deactivate Mana Shield", "BTNNeutralManaShield", "BTNneutralManaShieldOff")
	CIcon_CIconHS6("anto", 11, "T", "Tornado", "BTNTornado")
  ; Pandaren Brewmaster
	CIcon_CIconHS("anbf", 2, "F", "Breath of Fire", "BTNBreathofFire")
	CIcon_CIconHS("andh", 5, "D", "Drunken Haze", "BTNStrongDrink")
	CIcon_CIconHSN("andb", 8, "B", "Drunken Brawler", "BTNDrunkenDodge")
	CIcon_CIconHS6("anef", 11, "E", "Storm, Earth, And Fire", "BTNStormEarthFire")
  ; Pit Lord
	CIcon_CIconHS("anrf", 2, "F", "Rain of Fire", "BTNFire")
	CIcon_CIconHS("anht", 5, "T", "Howl of Terror", "BTNHowlofTerror")
	CIcon_CIconHSN("anca", 8, "C", "Cleaving Attack", "BTNCleavingAttack")
	CIcon_CIconHS6("ando", 11, "D", "Doom", "BTNDoom")
  ; Firelord
	CIcon_CIconHS("anso", 2, "B", "Soul Burn", "BTNSoulBurn") 
	CIcon_CIconHS("anlm", 5, "W", "Summon Lava Spawn", "BTNLavaSpawn")
	CIcon_CIconHSU("ania", 8, "C", "Incinerate", "BTNIncinerate")
	CIcon_CIconHS6("anvc", 11, "V", "Volcano", "BTNVolcano")
  ; Alchemist
	CIcon_CIconHS("anhs", 2, "E", "Healing Spray", "BTNHealingSpray")
	CIcon_CIconHS("ancr", 5, "R", "Chemical Rage", "BTNChemicalRage")
	CIcon_CIconHS("anab", 8, "B", "Acid Bomb", "BTNAcidBomb")
	CIcon_CIconHS6("antm", 11, "T", "Transmute", "BTNTransmute")
  ; Tinker
	CIcon_CIconHS("ansy", 2, "F", "Pocket Factory", "BTNPocketFactory")
	CIcon_CIconHS("ans1", 2, "F", "Pocket Factory", "BTNPocketFactory")
	CIcon_CIconHS("ans2", 2, "F", "Pocket Factory", "BTNPocketFactory")
	CIcon_CIconHS("ans3", 2, "F", "Pocket Factory", "BTNPocketFactory")
	CIcon_CIconHS("ancs", 5, "R", "Cluster Rockets", "BTNClusterRockets")
	CIcon_CIconHS("anc1", 5, "R", "Cluster Rockets", "BTNClusterRockets")
	CIcon_CIconHS("anc2", 5, "R", "Cluster Rockets", "BTNClusterRockets")
	CIcon_CIconHS("anc3", 5, "R", "Cluster Rockets", "BTNClusterRockets")
	CIcon_CIconHSN("aneg", 8, "E", "Engineering Upgrade", "BTNEngineeringUpgrade")
	CIcon_CIconHS6D("anrg", 11, 11, "B", "T", "Robo-Goblin", "Revert to Tinker Form", "BTNRobo-Goblin", "BTNTinker")
	CIcon_CIconHS6D("ang1", 11, 11, "B", "T", "Robo-Goblin", "Revert to Tinker Form", "BTNRobo-Goblin", "BTNTinker")
	CIcon_CIconHS6D("ang2", 11, 11, "B", "T", "Robo-Goblin", "Revert to Tinker Form", "BTNRobo-Goblin", "BTNTinker")
	CIcon_CIconHS6D("ang3", 11, 11, "B", "T", "Robo-Goblin", "Revert to Tinker Form", "BTNRobo-Goblin", "BTNTinker")
	CIcon_CIconN("ande", 4, "Demolish", "BTNDemolish")
	CIcon_CIconN("and1", 4, "Demolish - Upgrade Level 1", "BTNDemolish")
	CIcon_CIconN("and2", 4, "Demolish - Upgrade Level 2", "BTNDemolish")
	CIcon_CIconN("and3", 4, "Demolish - Upgrade Level 3", "BTNDemolish")
	; Neutral Summons
	; Storm
	CIcon_CIcon("accy", 5, "C", "Cyclone", "BTNCyclone")
	CIcon_CIcon("anwk", 8, "W", "Wind Walk", "BTNWindWalkOn")
	; Earth
	CIcon_CIconN("acpv", 2, "Pulverize", "BTNSeaGiantPulverize")
	CIcon_CIcon("anta", 5, "T", "Taunt", "BTNPandaTaunt")
	; Fire
	CIcon_CIconN("apig", 2, "Permanent Immolation", "BTNImmolationOn")
	; Doom Guard
	CIcon_CIcon("awrs", 5, "T", "War Stomp", "BTNWarStomp")
	CIcon_CIcon("accr", 8, "C", "Cripple", "BTNCripple")
	CIcon_CIcon("acrf", 11, "F", "Rain of Fire", "BTNFire")
	; Bear
	CIcon_CIcon("anbl", 2, "B", "Blink", "BTNBearBlink")
	CIcon_CIconN("anbh", 5, "Bash", "BTNBash")
	; Quilbeast
	CIcon_CIconU("afzy", 2, "F", "Frenzy", "BTNBloodLust")
	; Hawk
	CIcon_CIconN("antr", 2, "True Sight", "BTNScout")
	; Clockwerk Goblin
	CIcon_CIconU("asdg", 2, "B", "Kaboom!", "BTNSelfDestruct")
	CIcon_CIconU("asd1", 2, "B", "Kaboom!", "BTNSelfDestruct")
	CIcon_CIconU("asd2", 2, "B", "Kaboom!", "BTNSelfDestruct")
	CIcon_CIconU("asd3", 2, "B", "Kaboom!", "BTNSelfDestruct")
  
  ; Morning Tavern
  ;CIcon_CIconH("Hamg", 2, "A", "Archmage", "BTNHeroArchMage")
 
  ; Attribute Bonus
  ;CIcon_CIconN("aamk", 4, "Attribute Bonus", "DLSkillzYellow")
  ;CIconaamkL_iButtonPos := 10
  CIcon_CIconDotaABNorm("aamk", 4, "U", "Attribute Bonus", "DLSkillzYellow")
  ;CIcon_CIconDotaABSpec("a0aj", 4, "U", "Attribute Bonus", "DLSkillzYellow")
  ;CIcon_CIconDotaABSpec("a04h", 4, "U", "Attribute Bonus", "DLSkillzYellow")
  CIcon_CIconDotaABSpec("a0nr", 4, "U", "Attribute Bonus", "DLSkillzYellow")
  
  ; Morning Tavern Heros
  ; Vengeful Spirit
  CIcon_CIconHSDota("a02a", 2, "C", "Magic Missle", "BTNFrostBolt")
  CIcon_CIconHSDota("a0ap", 5, "T", "Terror", "BTNHowlofTerror")
  ;CIcon_CIconHSDota("", 8, "D", "Command Aura", "BTNGnollCommandAura")
  CIcon_CIconHS("a00g", 11, "W", "Nether Swap", "BTNWandOfNeutralization")
  ; Lord Of Olympia
  CIcon_CIconHSDota("a020", 2, "C", "Arc Lightning", "BTNChainLightning")
  CIcon_CIconHSDota("a006", 5, "G", "Lightning Bolt", "BTNBlue_Lightning")
  CIcon_CIconHSDota("a0n5", 8, "F", "Static Field", "BTNPurge")
  CIcon_CIconHS("a07C", 11, "W", "Thundergod's Wrath", "BTNSpell_Holy_SealOfMight")
  CIcon_CIconHS("a06l", 11, "W", "Thundergod's Wrath (Aghanim's Scepter)", "BTNSpell_Holy_SealOfMight")
  ; Enchantress
  CIcon_CIconHSDotaU("a0dy", 2, "T", "Impetus", "BTNVorpalBlades")
  CIcon_CIconHSDota("a0dx", 5, "C", "Enchant", "BTNDispelMagic")
  CIcon_CIconHSDota("a01b", 8, "R", "Nature's Attendants", "BTNRejuvenation")
  CIcon_CIconHS("a0dw", 11, "N", "Untouchable", "BTNResistMagic")
  ; Morphling
  CIcon_CIconHSDota("a0fn", 2, "W", "Waveform", "BTNCrushingWave")
  CIcon_CIconHSDota("a0g6", 5, "E", "Adaptive Strike", "BTNShimmerWeed")
  CIcon_CIconHSDotaUN("a0kx", 4, "R", "Morph", "BTNReplenishMana")
  CIcona0kxL_iButtonPos := 6
  CIcon_CIconDotaUN("a0kw", 7, "Morph", "BTNReplenishHealth")
  CIcon_CIconHS("a0g8", 11, "R", "Replicate", "BTNForceOfNature")
  CIcon_CIconHS("a0gc", 11, "R", "Morph Replicate", "BTNManaStone")
  /*
  CIcon_CIconHSDota("a06j", 2, "W", "Waveform", "BTNCrushingWave")
  CIcon_CIconHSDota("a0fm", 5, "E", "Morph Attack", "BTNShimmerWeed")
  CIcon_CIconHSDotaUN("a0kx", 8, "R", "Morph", "BTNReplenishMana")
  CIcon_CIconDotaUN("a0kw", 7, "Morph", "BTNReplenishHealth")
  CIcon_CIconHS("a0f4", 11, "D", "Adapt", "BTNForceOfNature")
  ; More Morphling
  CIcon_CIconHSDota("a08j", 5, "E", "Crushing Wave", "BTNBlizzard")
  CIcon_CIconHSDotaU("a0f6", 5, "E", "Unstable Power", "BTNBarkSkin")
  */
  ; Crystal Maiden
  CIcon_CIconHSDota("a01d", 2, "V", "Frost Nova", "BTNGlacier")
  CIcon_CIconHSDota("a04c", 5, "E", "Frostbite", "BTNFrost")
  CIcon_CIconHSDotaN("ahab", 8, "R", "Brilliance Aura", "BTNBrilliance")
  CIcon_CIconHS("a03r", 11, "Z", "Freezing Field", "BTNColdArrows")
  CIcon_CIconHS("a0av", 11, "Z", "Freezing Field (Aghanim's Scepter)", "BTNColdArrows")
  ; Rogueknight
  CIcon_CIconHSDota("ahtb", 2, "T", "Storm Bolt", "BTNStormBolt")
  CIcon_CIconHSDotaN("a01k", 5, "C", "Great Cleave", "BTNCleavingAttack")
  CIcon_CIconHSDotaN("a01m", 8, "G", "Toughness Aura", "BTNDevotion")
  CIcon_CIconHS("a01h", 11, "R", "God Strength", "BTNAncestralSpirit")
  ; Naga Siren
  CIcon_CIconHSDota("a063", 2, "R", "Mirror Image", "BTNMirrorImage")
  CIcon_CIconHSDota("a0ba", 5, "E", "Ensnare", "BTNEnsnare")
  CIcon_CIconHSDotaN("a00e", 8, "C", "Critical Strike", "BTNCriticalStrike")
  CIcon_CIconHS("a07u", 11, "G", "Song of the Siren", "BTNPenguin")
  ; Earthshaker
  CIcon_CIconHSDota("a0m0", 2, "F", "Fissure", "BTNShockWave")
  CIcon_CIconHSDota("a0dl", 5, "E", "Enchant Totem", "BTNSmash")
  CIcon_CIconHSDotaN("a0dj", 8, "A", "Aftershock", "BTNFarSight")
  CIcon_CIconHS("a0dh", 11, "C", "Echo Slam", "BTNEarthquake")
  ; Stealth Assassin
  CIcon_CIconHSDota("a0e6", 2, "C", "Smoke Screen", "BTNCloudofFog")
  CIcon_CIconHSDota("a0k9", 5, "B", "Blink Strike", "BTNBearBlink")
  CIcon_CIconHSDotaN("a0dz", 8, "K", "Backstab", "BTNTheBlackArrow")
  CIcon_CIconHSN("a0mb", 11, "E", "Permanent Invisibility", "BTNInvisibility")
  CIcon_CIconHSN("a00j", 11, "E", "Permanent Invisibility", "BTNInvisibility")
  ; Lone Druid
  CIcon_CIconHSDota("a0a5", 2, "B", "Summon Spirit Bear", "BTNGrizzlyBear")
  CIcon_CIconHSDotaU("a0aa", 5, "R", "Rabid", "BTNBerserk")
  CIcon_CIconHSDotaU("a0ab", 5, "R", "Rabid", "BTNBerserk")
  CIcon_CIconHSDotaU("a0ac", 5, "R", "Rabid", "BTNBerserk")
  CIcon_CIconHSDotaU("a0ad", 5, "R", "Rabid", "BTNBerserk")
  CIcon_CIconHSDotaU("a0ae", 5, "R", "Rabid", "BTNBerserk")
  CIcon_CIconHSDotaN("a0a8", 8, "Y", "Synergy", "BTNAncestralSpirit")
  CIcon_CIconHSD("a0ag", 11, 11, "F", "F", "True Form", "Lone Druid Form", "BTNBearForm", "BTNDruidofTheClaw")
  CIcon_CIcon("a0ai", 4, "C", "Battle Cry", "BTNBattleRoar")
  CIcon_CIcon("a0a9", 7, "E", "One", "BTNSpiritLink")
  ; Spirit Bear
  CIcon_CIconN("a0a0", 2, "Entangle", " BTNEntanglingRoots")
  CIcon_CIcon("a0a7", 5, "R", "Return", "BTNBlink")
  CIcon_CIconN("a0ah", 8, "Demolish", "BTNDemolish")
  ; Slayer
  CIcon_CIconHSDota("a01f", 2, "D", "Dragon Slave", "BTNSearingArrows")
  CIcon_CIconHSDota("a027", 5, "T", "Light Strike Array", "BTNBearBlink")
  CIcon_CIconHSDota("a001", 8, "E", "Ultimate", "BTNDisenchant")
  CIcon_CIconHS("a01p", 11, "G", "Laguna Blade", "BTNManaFlare")
  CIcon_CIconHS("a09z", 11, "G", "Laguna Blade (Aghanim's Scepter)", "BTNManaFlare")
  ; Juggernaut
  CIcon_CIconHSDota("a05g", 2, "F", "Blade Fury", "BTNWhirlWind")
  CIcon_CIconHSDota("a047", 5, "G", "Healing Ward", "BTNHealingWard")
  CIcon_CIconHSDotaN("a00k", 8, "C", "Blade Dance", "BTNAbility_Parry")
  CIcon_CIconHS("a0m1", 11, "N", "Omnislash", "BTNSteelMelee")

  ; Sunrise Tavern
  ; Silencer
  CIcon_CIconHSDota("a0kd", 2, "C", "Curse of the Silent", "BTNControlMagic")
  CIcon_CIconHSDota("a0lz", 5, "W", "Glaives of Wisdom", "BTNAdvancedMoonGlaive")
  ;CIcon_CIconHSDota("", 8, "L", "Last Word", "BTNSell")
  CIcon_CIconHS("a0l3", 11, "E", "Global Silence", "BTNSilence")
  ; Treant Protector
  CIcon_CIconHSDota("a01z", 2, "T", "Nature's Guise", "BTNAmbush")
  CIcon_CIconHSDota("a01v", 5, "E", "Eyes in the Forest", "BTNUltraVision")
  CIcon_CIconHSDotaU("a01u", 8, "V", "Living Armor", "BTNNaturesBlessing")
  CIcon_CIconHS("a07z", 11, "R", "Overgrowth", "BTNSpikedBarricades")
  ; Enigma
  CIcon_CIconHSDota("a0b3", 2, "F", "Malefice", "BTNVengeanceIncarnate")
  CIcon_CIconHSDota("a0b7", 5, "C", "Conversion", "BTNDeepLordRevenant")
  CIcon_CIconHSDota("a0b1", 8, "D", "Midnight Pulse", "BTNDeathAndDecay")
  CIcon_CIconHS("a0by", 11, "B", "Black Hole", "BTNGenericSpellImmunity")
  ; Keeper of the Light
  CIcon_CIconHSDota("a085", 2, "T", "Illuminate", "BTNOrbOfLightning")
  CIcon_CIconHSDota("a07y", 5, "E", "Mana Leak", "BTNCharm")
  CIcon_CIconHSDota("a07n", 8, "C", "Chakra Magic", "BTNPriestAdept")
  CIcon_CIconHS("a0mo", 11, "F", "Ignis Fatuus", "BTNWispSplode")
  CIcon_CIconHS("a0eo", 11, "F", "Ignis Fatuus (Aghanim's Scepter)", "BTNWispSplode")
  ; Ignis Fatuus
  CIcon_CIconU("a0dt", 2, "B", "Liberate Soul", "BTNPriest")
  CIcon_CIconU("a0do", 2, "B", "Liberate Soul", "BTNPriest")
  CIcon_CIconU("a0ds", 2, "B", "Liberate Soul", "BTNPriest")
  CIcon_CIcon("a07w", 5, "W", "Will O'", "BTNBlink")
  ;CIcon_CIconU("apsh", 8, "E", "Phase Shift", "")
  ; Liberated Soul
  ;CIcon_CIconHSDota("", 2, "", "", "BTNHeal") ; same as forest troll's heal
  ; Ursa Warrior
  CIcon_CIconHSDota("a03y", 2, "E", "Earthshock", "BTNEarthquake")
  CIcon_CIconHSDota("a059", 5, "V", "Overpower", "BTNBloodlust")
  ;CIcon_CIconHSDotaN("", 8, "W", "Fury Swipes", "")
  CIcon_CIconHS("a0lc", 11, "R", "Enrage", "BTNShamanMaster")
  ; Ogre Magi
  CIcon_CIconHSDota("a04w", 2, "F", "Fireblast", "BTNFireBolt")
  CIcon_CIconHSDota("a011", 5, "G", "Ignite", "BTNLiquidFire")
  CIcon_CIconHSDotaU("a083", 8, "B", "Bloodlust", "BTNBloodlust")
  CIcon_CIconHSN("a088", 11, "C", "Multi Cast", "BTNWitchDoctorMaster")
  ; Ogre Magi: Multi Cast Level 1
  CIcon_CIconHSDota("a089", 2, "F", "Fireblast", "BTNFireBolt")
  CIcon_CIconHSDota("a007", 5, "G", "Ignite", "BTNLiquidFire")
  CIcon_CIconHSDotaU("a08f", 8, "B", "Bloodlust", "BTNBloodlust")
  ; Ogre Magi: Multi Cast Level 2
  CIcon_CIconHSDota("a08a", 2, "F", "Fireblast", "BTNFireBolt")
  CIcon_CIconHSDota("a01t", 5, "G", "Ignite", "BTNLiquidFire")
  CIcon_CIconHSDotaU("a08g", 8, "B", "Bloodlust", "BTNBloodlust")
  ; Ogre Magi: Multi Cast Level 3 
  CIcon_CIconHSDota("a08d", 2, "F", "Fireblast", "BTNFireBolt")
  CIcon_CIconHSDota("a00f", 5, "G", "Ignite", "BTNLiquidFire")
  CIcon_CIconHSDotaU("a08i", 8, "B", "Bloodlust", "BTNBloodlust")
  ; Tinker
  CIcon_CIconHSDota("a049", 2, "E", "Laser", "BTNHeartOfAszune")
  CIcon_CIconHSDota("a05e", 5, "T", "Heat Seeking Missle", "BTNClusterRockets")
  CIcon_CIconHSDota("a0bq", 8, "C", "March of the Machines", "BTNRoboticGoblin")
  CIcon_CIconHS("a065", 11, "R", "Rearm", "BTNEngineeringUpgrade")
  ; Prophet
  CIcon_CIconHSDota("a06q", 2, "T", "Sprout", "BTNEatTree")
  CIcon_CIconHSDota("a01o", 5, "R", "Teleportation", "BTNWispSplode")
  ;CIcon_CIconHSDota("", 8, "F", "Force of Nature", "BTNEnt") ; force of nature
  CIcon_CIconHS("a07x", 11, "W", "Wrath of Nature", "BTNTreeOfLife")
  CIcon_CIconHS("a0al", 11, "W", "Wrath of Nature (Aghanim's Scepter)", "BTNTreeOfLife")  
  ; Phantom Lancer
  CIcon_CIconHSDota("a0da", 2, "T", "Spirit Lance", "BTNWindsArrows")
  CIcon_CIconHSDota("a0d7", 5, "W", "Dopplewalk", "BTNWindWalkOn")
  CIcon_CIconHSDotaN("a0db", 8, "X", "Juxtapose", "BTNMassTeleport")
  CIcon_CIconHSN("a0d9", 11, "D", "Phantom Edge", "BTNBanish")
  ; Stone Giant
  CIcon_CIconHSDota("a0ll", 2, "V", "Avalanche", "BTNGolemStormBolt")
  CIcon_CIconHSDota("a0bz", 5, "T", "Toss", "BTNAttackGround")
  CIcon_CIconHSDotaN("a0bu", 8, "C", "Craggy Exterior", "BTNResistantSkin")
  CIcon_CIconHSN("a0cy", 11, "W", "Grow!", "BTNReincarnation")
  ; Goblin Techies
  CIcon_CIconHSDota("a05j", 2, "E", "Land Mines", "BTNGoblinLandMine")
  CIcon_CIconHSDota("a06h", 5, "T", "Stasis Trap", "BTNStasisTrap")
  ;CIcon_CIconHSDotaU("", 8, "C", "Suicide Squad, Attack!", "BTNSelfDestruct")
  CIcon_CIconHS("a0ak", 11, "R", "Remote Mines", "BTNClusterRockets")
  CIcon_CIcon("a02t", 7, "D", "Detonate", "BTNSelfDestruct")
  ; RemoteMine
  CIcon_CIcon("a0am", 2, "D", "Detonate", "BTNSelfDestruct")
  ; Holy Knight
  CIcon_CIconHSDota("a0km", 2, "E", "Penitence", "BTNResurrection")
  CIcon_CIconHSDota("a0lv", 5, "T", "Test of Faith", "BTNStaffOfPreservation")
  CIcon_CIconHSDota("a069", 8, "R", "Holy Persuasion", "BTNScepterOfMastery")
  CIcon_CIconHS("a0lt", 11, "D", "Hand of God", "BTNHeal")
  
  ; Tavern
  ; Moon Rider
  CIcon_CIconHSDota("a042", 2, "C", "Lucent Beam", "BTNMoonStone")
  CIcon_CIconHSDotaN("a041", 5, "G", "Moon Glaive", "BTNUpgradeMoonGlaive")
  CIcon_CIconHSDotaN("a062", 8, "L", "Lunar Blessing", "BTNAdvancedStrengthOfTheMoon")
  CIcon_CIconHS("a054", 11, "E", "Eclipse", "BTNElunesGrace")
  CIcon_CIconHS("a00u", 11, "E", "Eclipse (Aghanim's Scepter)", "BTNElunesGrace")
  ; Dwarven Sniper
  CIcon_CIconHSDota("a064", 2, "C", "Scatter Shot", "BTNFragmentationBombs")
  CIcon_CIconHSDotaN("a03S", 5, "O", "Headshot", "BTNHumanMissileUpOne")
  CIcon_CIconHSDotaN("a03U", 8, "E", "Take Aim", "BTNHumanMissileUpTwo")
  CIcon_CIconHS("a04P", 11, "T", "Assassinate", "BTNDwarvenLongRifle")
  ; Troll Warlord
  CIcon_CIconHSDotaD("a0be", 2, 2, "G", "G", "Berserker Rage", "Ranged Form", "BTNOrcMeleeUpThree", "BTNArcaniteRanged")
  CIcon_CIconN("a09e", 7, "Bash", "BTNBash")
  CIcon_CIconHSDota("a0bc", 5, "D", "Blind", "BTNSleep")
  CIcon_CIconHSDotaN("a0bd", 8, "F", "Fervor", "BTNCommand")
  CIcon_CIconHS("a0bb", 11, "R", "Rampage", "BTNBerserkForTrolls")
  ; Shadow Shaman
  CIcon_CIconHSDota("a010", 2, "R", "Forked Lightning", "BTNMonsoon")
  CIcon_CIconHSDota("a0mn", 5, "D", "Voodoo", "BTNHex")
  CIcon_CIconHSDota("a00p", 8, "E", "Shackles", "BTNMagicLariet")
  CIcon_CIconHS("a00h", 11, "W", "Mass Serpent Ward", "BTNSerpentWard")
  CIcon_CIconHS("a0a1", 11, "W", "Mass Serpent Ward (Aghanim's Scepter)", "BTNSerpentWard")
  ; Bristleback
  CIcon_CIconHSDota("a0fw", 2, "V", "Viscous Nasal Goo", "BTNPlagueCloud")
  CIcon_CIconHSDota("a0fx", 5, "R", "Quill Spray", "BTNFanOfKnives")
  CIcon_CIconHSDotaN("a0m3", 8, "K", "Bristleback", "BTNQuillSprayOff")
  CIcon_CIconHSN("a0fv", 11, "W", "Warpath", "BTNHire")
  ; Pandaren Battlemaster
  CIcon_CIconHSDota("a06m", 2, "C", "Thunder Clap", "BTNThunderClap")
  CIcon_CIconHSDota("acdh", 5, "D", "Drunken Haze", "BTNStrongDrink")
  CIcon_CIconHSDotaN("a0mx", 8, "B", "Battlemastery", "BTNDrunkenDodge")
  CIcon_CIconHS("a0mq", 11, "R", "Primal Split", "BTNStormEarthFire")
  ; Centaur Warchief
  CIcon_CIconHSDota("a00s", 2, "F", "Hoof Stomp", "BTNWarStomp")
  CIcon_CIconHSDota("a00l", 5, "D", "Double Edge", "BTNArcaniteMelee")
  CIcon_CIconHSDotaN("a00v", 8, "R", "Return", "BTNThorns")
  CIcon_CIconHS("a01l", 11, "G", "Great Fortitude", "BTNCentaur")
  ; Bounty Hunter
  CIcon_CIconHSDota("a004", 2, "T", "Shuriken Toss", "BTNUpgradeMoonGlaive")
  CIcon_CIconHSDota("a000", 5, "J", "Jinda", "BTNEvasion")
  CIcon_CIconHSDota("a07a", 8, "W", "Wind Walk", "BTNWindWalkOn")
  CIcon_CIconHS("a0b4", 11, "R", "Track", "BTNSpy")
  ; Dragon Knight
  CIcon_CIconHSDota("a03f", 2, "F", "Breathe Fire", "BTNBreathOfFire")
  CIcon_CIconHSDota("a0ar", 5, "T", "Dragon Tail", "BTNHumanArmorUpThree")
  CIcon_CIconHSDotaN("a0cl", 8, "D", "Dragon Blood", "BTNIncinerate")
  CIcon_CIconHS("a03g", 11, "R", "Elder Dragon Form", "BTNAzureDragon")
  CIcon_CIconN("a07d", 7, "Corrosive Attack", "BTNCorrosiveBreath")
  ; Anti-Mage
  CIcon_CIconHSDotaN("a022", 2, "R", "Mana Break", "BTNFeedBack")
  ;CIcon_CIconHSDota("", 5, "", "", "BTNBlink")
  CIcon_CIconHSDotaN("a0ky", 8, "D", "Spell Shield", "BTNNeutralManaShield")
  CIcon_CIconHS("a0e3", 11, "V", "Mana Void", "BTNTelekinesis")
  ; Drow Ranger
  CIcon_CIconHSDotaU("a026", 2, "R", "Frost Arrows", "BTNColdArrows")
  ;CIcon_CIconHSDota("", 5, "", "", "BTNSilence")
  CIcon_CIconHSDotaN("a029", 8, "T", "True Shot Aura", "BTNTrueShot")
  CIcon_CIconHSN("a056", 11, "M", "Marksmanship", "BTNMarksmanship")
  ; Omniknight
  CIcon_CIconHSDota("a08n", 2, "R", "Purification", "BTNDispelMagic")
  CIcon_CIconHSDota("a08v", 5, "E", "Repel", "BTNMagicalSentry")
  CIcon_CIconHSDotaN("a06a", 8, "D", "Degen Aura", "BTNSpiritLink")
  CIcon_CIconHS("a0er", 11, "G", "Guardian Angel", "BTNDivineIntervention")
  
  ; Dawn Tavern
  ; Beastmaster
  CIcon_CIconHSDota("a0o1", 2, "W", "Wild Axes", "BTNAbility_Warrior_SavageBlow")
  CIcon_CIconHSDota("a0oo", 5, "D", "Call of the Wild", "BTNEnchantedCrows")
  CIcon_CIconHSDota("a0o0", 8, "G", "Beast Rage", "BTNEnchantedBears")
  CIcon_CIconHS("a0o2", 11, "R", "Primal Roar", "BTNBattleRoar")
  ; Twin Head Dragon
  CIcon_CIconHSDota("a0o7", 2, "D", "Dual Breath", "BTNDualBreath")
  CIcon_CIconHSDota("a0o6", 5, "T", "Ice Path", "BTNFreezingBreath")
  CIcon_CIconHSDotaN("a0o8", 8, "A", "Auto Fire", "PASBTNAutoFire")
  CIcon_CIconHS("a0o5", 11, "R", "Macropyre", "BTNBreathOfFireNew")  
  
  ; Midnight Tavern
  ; Soul Keeper
  CIcon_CIconHSDota("a04L", 2, "E", "Soul Steal", "BTNDrainSoul")
  ;CIcon_CIconHSDota("a08Q", 5, "C", "Conjure Image", "BTNMirrorImage")
  CIcon_CIconHSDota("a0h4", 5, "C", "Conjure Image", "BTNMirrorImage")
  CIcon_CIconHSDota("a0mv", 8, "T", "Metamorphosis", "BTNMetamorphosis")
  CIcon_CIconHS("a07q", 11, "R", "Sunder", "BTNDeathCoil")
  ; Tormented Soul
  CIcon_CIconHSDota("a06w", 2, "T", "Split Earth", "BTNEarthquake")
  CIcon_CIconHSDota("a035", 5, "C", "Diablolic Edict", "BTNGuldanSkull")
  CIcon_CIconHSDota("a06v", 8, "G", "Lightning Storm", "BTNChainLightning")
  CIcon_CIconHSD("a06x", 11, 11, "V", "V", "Activate Pulse Nova", "Deactivate Pulse Nova", "DLShadeTrueSight", "DLShadeTrueSight")
  CIcon_CIconHSD("a0aq", 11, 11, "V", "V", "Pulse Nova (Aghanim's Scepter)", "Deactivate Pulse Nova (Aghanim's Scepter)", "DLShadeTrueSight", "DLShadeTrueSight")
  ; Lich
  CIcon_CIconHSDota("a07f", 2, "V", "Frost Nova", "BTNGlacier")
  CIcon_CIconHSDotaU("a08r", 5, "F", "Frost Armor", "BTNFrostArmor")
  CIcon_CIconHSDota("a053", 8, "D", "Dark Ritual", "BTNDarkRitual")
  CIcon_CIconHS("a05t", 11, "C", "Chain Frost", "BTNBreathOfFrost")
  CIcon_CIconHS("a08h", 11, "C", "Chain Frost (Aghanim's Scepter)", "BTNBreathOfFrost")

  ; Death Prophet
  CIcon_CIconHSDota("a02m", 2, "R", "Carrion Swarm", "BTNCarrionSwarm")
  CIcon_CIconHSDota("a06n", 2, "R", "Carrion Swarm", "BTNCarrionSwarm")
  CIcon_CIconHSDota("a072", 2, "R", "Carrion Swarm", "BTNCarrionSwarm")
  CIcon_CIconHSDota("a074", 2, "R", "Carrion Swarm", "BTNCarrionSwarm")
  CIcon_CIconHSDota("a078", 2, "R", "Carrion Swarm", "BTNCarrionSwarm")

  ;CIcon_CIconHSDota("ansi", 5, "E", "Silence", "BTNSilence")
  CIcon_CIconHSDota("a07h", 5, "E", "Silence", "BTNSilence")
  CIcon_CIconHSDota("a07i", 5, "E", "Silence", "BTNSilence")
  CIcon_CIconHSDota("a07j", 5, "E", "Silence", "BTNSilence")
  CIcon_CIconHSDota("a07m", 5, "E", "Silence", "BTNSilence")

  CIcon_CIconHSDotaN("a02c", 8, "C", "Witchcraft", "BTNSpiritOfVengeance")

  CIcon_CIconHS("a073", 11, "X", "Exorcism", "BTNDevourMagic")
  CIcon_CIconHS("a03j", 11, "X", "Exorcism", "BTNDevourMagic")
  CIcon_CIconHS("a04j", 11, "X", "Exorcism", "BTNDevourMagic")
  CIcon_CIconHS("a04m", 11, "X", "Exorcism", "BTNDevourMagic")
  CIcon_CIconHS("a04n", 11, "X", "Exorcism", "BTNDevourMagic")
  
  ; Demon Witch
  CIcon_CIconHSDota("a02j", 2, "E", "Impale", "BTNImpale")
  CIcon_CIconHSDota("a0mn", 5, "D", "Voodoo", "BTNHex")
  CIcon_CIconHSDota("a02n", 8, "R", "Mana Drain", "BTNManaDrain")
  CIcon_CIconHS("a095", 11, "F", "Finger of Death", "BTNCorpseExplode")
  CIcon_CIconHS("a09w", 11, "F", "Finger of Death (Aghanim's Scepter)", "BTNCorpseExplode")
  ; Venomancer
  ;CIcon_CIconHSDota("", 2, "", "", "")
  CIcon_CIconHSDotaN("a0my", 5, "T", "Poison Sting", "BTNEnvenomedSpear")
  CIcon_CIconHSDota("a0ms", 8, "W", "Plague Ward", "BTNSerpentWard")
  CIcon_CIconHS("a013", 11, "V", "Poison Nova", "BTNCorrosiveBreath")
  CIcon_CIconHS("a0a6", 11, "V", "Poison Nova (Aghanim's Scepter)", "BTNCorrosiveBreath")
  ; Magnataur
  CIcon_CIconHSDota("a02s", 2, "W", "Shock Wave", "BTNShockWave")
  CIcon_CIconHSDota("a037", 5, "E", "Empower", "BTNGhoulFrenzy")
  CIcon_CIconHSDotaN("a024", 8, "T", "Mighty Swing", "BTNAbility_Warrior_Cleave")
  CIcon_CIconHS("a06f", 11, "V", "Reverse Polarity", "BTNGolemThunderClap")
  ; Necro'lic
  CIcon_CIconHSDota("a08x", 2, "G", "Grave Chill", "BTNAbsorbMagic")
  CIcon_CIconHSDotaU("a0c4", 5, "T", "Soul Assumption", "BTNCloakOfFlames")
  ;CIcon_CIconHSDotaN("", 8, "V", "Gravekeeper's Cloak", "BTNAntiMagicShell")
  CIcon_CIconHSU("a07k", 11, "E", "Raise Revenant", "DLShadeTrueSight")
  ; Chaos Knight
  CIcon_CIconHSDota("a055", 2, "C", "Chaos Bolt", "BTNStun")
  CIcon_CIconHSDota("a09f", 5, "B", "Blink Strike", "BTNBearBlink")
  CIcon_CIconHSDotaN("a03n", 8, "R", "Critical Strike", "BTNCriticalStrikeNew")
  CIcon_CIconHS("a03o", 11, "T", "Phantasm", "BTNMirrorImage")
  ; Lycanthrope
  CIcon_CIconHSDota("a03d", 2, "V", "Summon Wolves", "BTNSpiritWolf")
  CIcon_CIconHSDota("a02g", 5, "W", "Howl", "BTNHowlOfTerror")
  CIcon_CIconHSDotaN("a03e", 8, "E", "Feral Heart", "BTNHeartOfAszune")
  CIcon_CIconHSN("a093", 11, "F", "Shapeshift", "BTNDireWolf")
  CIcon_CIconN("a03b", 4, "Critical Strike", "BTNCriticalStrike")
  ; Broodmother
  CIcon_CIconHSDotaU("a0bh", 2, "W", "Spawn Spiderlings", "BTNSpiderGreen")
  CIcon_CIconHSDota("a0bg", 5, "B", "Spin Web", "BTNWeb")
  CIcon_CIconHSDotaN("a0bm", 8, "P", "Incapacitating Bite", "BTNRedDragonDevour")
  CIcon_CIconHSDotaN("a0bk", 8, "P", "Incapacitating Bite", "BTNRedDragonDevour")
  CIcon_CIconHS("a0bp", 11, "T", "Insatiable Hunger", "BTNSpiderling")
  ; Spiderling
  CIcon_CIconN("a0bj", 2, "Poison Sting", "BTNEnvenomedSpear")
  CIcon_CIconU("a002", 5, "W", "Spawn Spiderite", "BTNSpiderGreen")
  ; Phantom Assassin
  ;CIcon_CIconHSDota("", 2, "", "Shadow Strike", "BTNShadowStrike")
  CIcon_CIconHSDota("a0k9", 5, "B", "Blink Strike", "BTNBearBlink")
  CIcon_CIconHSDotaN("a03p", 8, "U", "Blur", "BTNInvisibility")
  CIcon_CIconHSN("a03q", 11, "C", "Coup de Graçe", "BTNAbility_BackStab")
  
  ; Evening Tavern
  ; Gordan
  CIcon_CIconHSDotaD("a012", 2, 2, "T", "T", "Split Shot", "Stop Split Shot", "BTNMultyArrows", "BTNMultyArrows")
  CIcon_CIconHSDota("a00y", 5, "C", "Chain Lightning", "BTNChainLightning")
  CIcon_CIconHSDotaD("a0mp", 8, 8, "E", "E", "Activate Mana Shield", "Deactivate Mana Shield", "BTNNeutralManaShield", "BTNNeutralManaShieldOff")
  CIcon_CIconHS("a02v", 11, "G", "Purge", "BTNPurge")
  CIcon_CIconN("a09j", 7, "Split Shot", "BTNMultyArrows")
  ; Night Stalker
  CIcon_CIconHSDota("a02h", 2, "V", "Void", "BTNDarkSummoning")
  CIcon_CIconHSDota("a08c", 5, "F", "Crippling Fear", "BTNPossession")
  CIcon_CIconHSDota("a08e", 5, "F", "Crippling Fear", "BTNPossession")
  CIcon_CIconHSDotaN("a086", 8, "G", "Hunter in the Night", "BTNHeroDreadLord")
  CIcon_CIconHS("a03k", 11, "R", "Darkness", "BTNOrbOfDarkness")
  ; Skeleton King
  ;CIcon_CIconHSDota("", 2, "", "", "BTNStormBolt")
  ;CIcon_CIconHSDota("", 5, "", "", "BTNVampiricAura")
  ;CIcon_CIconHSDotaN("", 8, "", "", "BTNCriticalStrike")
  CIcon_CIconHSN("a01y", 11, "R", "Reincarnation", "BTNReincarnation")
  ; Doom Bringer
  CIcon_CIconHSDota("a05y", 2, "E", "Devour", "BTNRedDragonDevour")
  CIcon_CIconHSDota("a0fe", 5, "T", "Scorched Earth", "BTNWallOfFire")
  CIcon_CIconHSDota("a094", 8, "V", "LVL? Death", "BTNGuldanSkull")
  CIcon_CIconHS("a0mu", 11, "D", "Doom", "BTNDoom")
  ; Nerubian Assassin
  CIcon_CIconHSDota("a09k", 2, "E", "Impale", "BTNImpale")
  CIcon_CIconHSDota("a02k", 5, "R", "Mana Burn", "BTNManaBurn")
  CIcon_CIconHSDotaN("a02l", 8, "D", "Spiked Carapace", "BTNThornShield")
  CIcon_CIconHS("a09u", 11, "V", "Vendetta", "BTNWindWalkOn")
  ; Slithereen Guard
  CIcon_CIconHSDota("a05c", 2, "T", "Sprint", "BTNSirenMaster")
  CIcon_CIconHSDota("a01w", 5, "E", "Slithereen Crush", "BTNHydraWarStomp")
  CIcon_CIconHSDotaN("a0jj", 8, "B", "Bash", "BTNBash")
  CIcon_CIconHSU("a034", 11, "G", "Amplify Damage", "BTNFaerieFire")
  ; Queen of Pain
  ;CIcon_CIconHSDota("", 2, "", "Shadow Strike", "BTNShadowStrike")
  CIcon_CIconHSDota("a0me", 5, "B", "Blink", "BTNBlink")
  CIcon_CIconHSDota("a04a", 8, "F", "Scream of Pain", "BTNPossession")
  CIcon_CIconHS("a00o", 11, "W", "Sonic Wave", "BTNTornado")
  CIcon_CIconHS("a0af", 11, "W", "Sonic Wave (Aghanim's Scepter)", "BTNTornado")
  ; Bone Fletcher
  CIcon_CIconHSDota("a030", 2, "T", "Strafe", "BTNSkeletalLongevity")
  ;CIcon_CIconHSDotaU("", 5, "", "Searing Arrows", "BTNSearingArrows")
  CIcon_CIconHSDota("a025", 8, "W", "Wind Walk", "BTNWindWalkOn")
  CIcon_CIconHS("a04q", 11, "E", "Death Pact", "BTNDeathPact")
  ; Faceless Void
  CIcon_CIconHSDota("a0lk", 2, "W", "Time Walk", "BTNInvisibility")
  CIcon_CIconHSDota("a0cz", 5, "R", "Backtrack", "BTNTimeStop")
  CIcon_CIconHSDota("a081", 8, "E", "Time Lock", "BTNBash")
  CIcon_CIconHS("a0j1", 11, "C", "Chronosphere", "BTNSeaOrb")
  ; Netherdrake
  CIcon_CIconHSDota("a05d", 2, "R", "Frenzy", "BTNUnholyFrenzy")
  CIcon_CIconHSDotaU("a09v", 5, "C", "Poison Attack", "BTNSlowPoison")
  CIcon_CIconHSDotaN("a0mm", 8, "E", "Corrosive Skin", "BTNResistMagic")
  CIcon_CIconHS("a080", 11, "V", "Viper Strike", "BTNShadowStrike")
  ; Lightning Revenant
  ;CIcon_CIconHSDota("", 2, "", "", "BTNUnholyFrenzy")
  ;CIcon_CIconHSDota("a00y", 5, "C", "Chain Lightning", "BTNChainLightning")
  CIcon_CIconHSDotaN("a00n", 8, "N", "Unholy Fervor", "BTNUnholyAura")
  CIcon_CIconHS("a04b", 11, "K", "Storm Seeker", "BTNMonsoon")
  ; Lifestealer
  CIcon_CIconHSDotaN("a0jq", 2, "F", "Feast", "BTNCannibalize")
  CIcon_CIconHSDotaN("a01e", 5, "T", "Poison Sting", "BTNEnvenomedSpear")
  CIcon_CIconHSDotaN("a06y", 8, "Z", "Anabolic Frenzy", "BTNGhoulFrenzy")
  CIcon_CIconHS("a028", 11, "R", "Rage", "BTNReincarnation")
  
  ; Twilight Tavern
  ; Oblivion
  CIcon_CIconHSDota("a0mt", 2, "B", "Nether Blast", "BTNOrbOfLightning")
  CIcon_CIconHSDota("a0ce", 5, "C", "Decrepify", "BTNCripple")
  CIcon_CIconHSDota("a09d", 8, "W", "Nether Ward", "BTNEntrapmentWard")
  CIcon_CIconHS("a0cc", 11, "D", "Life Drain", "BTNLifeDrain")
  ; Oblivion (Aghanim's Scepter)
  CIcon_CIconHSDota("a0mt", 2, "B", "Nether Blast", "BTNOrbOfLightning")
  CIcon_CIconHSDota("a0ce", 5, "C", "Decrepify", "BTNCripple")
  CIcon_CIconHSDota("a09d", 8, "W", "Nether Ward", "BTNEntrapmentWard")
  CIcon_CIconHS("a02z", 11, "D", "Life Drain (Aghanim's Scepter)", "BTNLifeDrain")
  ; Tidehunter
  CIcon_CIconHSDota("a046", 2, "G", "Gush", "BTNCrushingWave")
  CIcon_CIconHSDotaN("a04e", 5, "R", "Kraken Shell", "BTNNagaArmorUp3")
  CIcon_CIconHSDotaN("a044", 8, "C", "Anchor Smash", "BTNSeaGiantCriticalStrike")
  CIcon_CIconHS("a03z", 11, "V", "Ravage", "BTNSeaGiantWarStomp")
  ; Bane Elemental
  CIcon_CIconHSDota("a04v", 2, "E", "Enfeeble", "BTNCurse")
  CIcon_CIconHSDota("a0gk", 5, "B", "Brain Sap", "BTNDevourMagic")
  CIcon_CIconHSDota("a04y", 8, "T", "Nightmare", "BTNWandOfShadowSight")
  CIcon_CIconHS("a02q", 11, "F", "Fiend's Grip", "BTNAmuletOftheWild")
  ; Necrolyte
  CIcon_CIconHSDota("a05v", 2, "D", "Death Pulse", "BTNDeathNova")
  ;CIcon_CIconHSDotaN("", 5, "F", "", "BTNDLShadeTrueSight")
  CIcon_CIconHSDotaN("a060", 8, "I", "Sadist", "BTNOrbOfCorruption")
  CIcon_CIconHS("a067", 11, "R", "Reaper's Scythe", "BTNINV_Sword_09")
  CIcon_CIconHS("a08p", 11, "R", "Reaper's Scythe (Aghanim's Scepter)", "BTNINV_Sword_09")
  ; Butcher
  CIcon_CIconHSDota("a06i", 2, "T", "Meat Hook", "BTNImpale")
  CIcon_CIconHSDotaD("a06k", 5, 5, "R", "R", "Rot", "Deactivate Rot", "BTNPlagueCloud", "BTNPlagueCloud")
  CIcon_CIconHSDotaN("a06d", 8, "F", "Flesh Heap", "BTNExhumeCorpses")
  CIcon_CIconHS("a0fl", 11, "D", "Dismember", "BTNCannibalize")
  ; Spiritbreaker
  CIcon_CIconHSDota("a0ml", 2, "C", "Charge fo Darkness", "BTNSpell_Shadow_GatherShadows")
  CIcon_CIconHSDotaN("a0es", 5, "H", "Empowering Haste", "BTNEtherealFormOn")
  CIcon_CIconHSDotaN("a0g5", 8, "T", "Greater Bash", "BTNBash1")
  CIcon_CIconHS("a0g4", 11, "E", "Nether Strike", "BTNSacrifice")
  ; Nerubian Weaver
  CIcon_CIconHSDota("a00t", 2, "W", "Watcher", "BTNWandOfShadowSight")
  CIcon_CIconHSDota("a0ca", 5, "C", "Shukuchi", "BTNWindWalkOn")
  CIcon_CIconHSDotaN("a0cn", 8, "K", "Geminate Attack", "BTNLocustSwarm")
  CIcon_CIconHSDotaN("a0cg", 8, "K", "Geminate Attack", "BTNLocustSwarm")
  CIcon_CIconHS("a0ct", 11, "T", "Time Lapse", "BTNOrbOfFrost")
  ; Watcher
  ; Shadow Fiend
  CIcon_CIconHSDota("a0ey", 2, "Z", "Shadowraze", "BTNDeathCoil")
  CIcon_CIconDota("a0fh", 5, "X", "Shadowraze", "BTNDeathCoil")
  CIcon_CIconDota("a0f0", 8, "C", "Shadowraze", "BTNDeathCoil")
  ;CIcon_CIconHSDotaN("", 4, "N", "Necromastery", "BTNSacrificialSkull")
  CIcon_CIconHSDotaN("a0fu", 7, "P", "Presence of the Dark Lord", "BTNRegenerationAura")
  CIcona0fuL_iButtonPos := 6
  CIcon_CIconHS("a0he", 11, "R", "Requiem of Souls", "BTNDizzy")
  ; Sand King
  CIcon_CIconHSDota("a06o", 2, "E", "Burrowstrike", "BTNImpale")
  CIcon_CIconHSDota("a0h0", 5, "R", "Sand Storm", "BTNSandStorm")
  CIcon_CIconHSDotaN("a0fa", 8, "L", "Caustic Finale", "BTNPoisonSting")
  CIcon_CIconHS("a06r", 11, "C", "Epicenter", "BTNEarthquake")
  ; Axe
  CIcon_CIconHSDota("a0c7", 2, "E", "Berserker's Call", "BTNUnholyAura")
  CIcon_CIconHSDota("a0c5", 5, "R", "Battle Hunger", "BTNIncinerate")
  CIcon_CIconHSDotaN("a0c6", 8, "X", "Counter Helix", "BTNStaffOfSanctuary")
  CIcon_CIconHS("a0e2", 11, "C", "Culling Blade", "BTNOrcMeleeUpThree")
  ; Bloodseeker
  CIcon_CIconHSDota("a0ec", 2, "D", "Bloodrage", "BTNSpellSteal")
  CIcon_CIconHSDotaN("a0le", 5, "B", "Blood Bath", "BTNSpell_Shadow_LifeDrain")
  CIcon_CIconHSDota("a0lf", 8, "T", "Strygwyr's Thirst", "BTNThirst")
  CIcon_CIconHS("a0lh", 11, "R", "Rupture", "BTNMarkOfFire")
  ; Lord of Avernus
  CIcon_CIconHSDota("a0mf", 2, "T", "Aphotic Shield", "BTNLightningShield")
  CIcon_CIconHSDota("a0mi", 5, "R", "Mark of the Abyss", "BTNSpell_Shadow_RagingScream")
  CIcon_CIconHSDotaN("a0mg", 8, "F", "Frostmourne", "BTNIceBlade")
  CIcon_CIconHSN("a0ns", 11, "B", "Borrowed Time", "BTNAnimateDead")

  ; Dusk Tavern
  ; Avatar of Vengeance
  CIcon_CIconHSDota("a0n6", 2, "E", "Phase", "BTNPhase")
  CIcon_CIconHSDota("a0n7", 5, "T", "Haunt", "BTNSpiritOfVengeance")
  CIcon_CIconHSDotaN("a0na", 8, "I", "Dispersion", "BTNThickFur")
  CIcon_CIconHSN("a0nf", 11, "V", "Vengeance", "BTNUnholyAura")
  CIcon_CIcon("a0nb", 4, "R", "Reality", "BTNCloakOfFlames")
  CIcon_CIconDota("a0nd", 7, "D", "Direct Vengeance", "BTNImmolationOn")
  ; Witch Doctor    
  CIcon_CIconHSDota("a0nm", 2, "C", "Paralyzing Casks", "BTNAcidBomb")
  CIcon_CIconHSDotaD("a0ne", 5, 5, "V", "V", "Voodoo Restoration", "Deactivate Voodoo Restoration", "BTNBigBadVoodooSpell", "BTNCancel")
  CIcon_CIconHSDota("a0no", 8, "E", "Maledict", "BTNShadowPact")
  ;CIcon_CIconHS("a0nk", 11, "D", "Death Ward", "BTNStasisTrap")
  CIcon_CIconHS("a0nt", 11, "D", "Death Ward", "BTNStasisTrap")
  ;CIcon_CIconHS("a0nj", 11, "D", "Death Ward (Aghanim's Scepter)", "BTNStasisTrap")
  CIcon_CIconHS("a0nx", 11, "D", "Death Ward (Aghanim's Scepter)", "BTNStasisTrap")
  ; Obsidian Destroyer
  CIcon_CIconHSDotaU("a0oi", 2, "R", "Arcane Orb", "BTNOrbOfDeath")
  CIcon_CIconHSDota("a0oj", 5, "T", "Astral Imprisonment", "BTNSpell_Shadow_AntiShadow")
  ;CIcon_CIconHSDota("", 8, "", "Essence Aura", "BTNTemp")
  CIcon_CIconHS("a0ok", 11, "C", "Sanity's Eclipse", "BTNSpell_Shadow_ImpPhaseShift")

  ; Dota Creeps
  ; Satyr Hellcaller
  CIcon_CIcon("acsh", 2, "W", "Shockwave", "BTNShockwave")
  CIcon_CIconN("acua", 8, "Unholy Aura", "BTNUnholyAura")
  ; Satyr Soulstealer
  ;CIcon_CIcon("", 2, "B", "Mana Burn", "BTNManaBurn")
  ; Satyr Trickser
  CIcon_CIcon("acpu", 2, "G", "Purge", "BTNPurge")
  ; Polar Furlborg Ursa Warrior
  ; Centaur Khan
  CIcon_CIconN("scae", 8, "Endurance Aura", "BTNCommand")
  ; Ogre Magi
  CIcon_CIconU("acf2", 5, "F", "Frost Armor", "BTNFrostArmor")
  ; Forest Troll High Priest
  ; Kobold Taskmaster
  CIcon_CIconN("acbh", 8, "Bash", "BTNBash")
  ; Kobold Tunneler
  ; Necronomicon Archer
  CIcon_CIcon("a0gv", 2, "B", "Mana Burn", "BTNManaBurn")
  CIcon_CIcon("a0jv", 2, "B", "Mana Burn", "BTNManaBurn")
  CIcon_CIcon("a0jw", 2, "B", "Mana Burn", "BTNManaBurn")
  CIcon_CIconN("a0gy", 11, "Necronomicon Endurance Aura", "BTNCommand")
  CIcon_CIconN("a0gb", 11, "Necronomicon Endurance Aura", "BTNCommand")
  CIcon_CIconN("a0hn", 11, "Necronomicon Endurance Aura", "BTNCommand")
  CIcon_CIconN("a0h3", 10, "Spell Immunity", "BTNThickFur")
  ; Necronomicon Warrior
  CIcon_CIconN("a0gw", 2, "Mana Break", "BTNTemp")
  CIcon_CIconN("a0m2", 2, "Mana Break", "BTNTemp")
  CIcon_CIconN("a0m4", 2, "Mana Break", "BTNTemp")
  CIcon_CIconN("a0gu", 11, "Last Will", "BTNTemp")
  CIcon_CIconN("a0gx", 11, "Last Will", "BTNTemp")
  CIcon_CIconN("a0gz", 11, "Last Will", "BTNTemp")
  ; Necronomicon Warrior
  ; Giant Wolf
  ; Gnoll Assassin
  
  ; Auto Read Stop DO NOT EDIT/REMOVE THIS LINE

}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;   Grid Bot   ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Note: Grid.ahk was getting too big, so it was split into gridtop and gridbot
; GridLoadGrids() ; loads all the grids into memory
; GridDrawCurrent ; Draws Current Grid
; GridAlignKey(kstrCodeName) ; sets all hotkeys based on buttonpos
; GridAlignHotKey(strHotkey, iCurrentButtonPos) ; sets hotkey based on

GridLoadGrids()
{
  global
  
  GridInit() ; Auto gen function
  
  ; Grid Stuff
  CIcon_Load("GridKeys", "WarkeysGrid0") ; "Hotkey For Grid Position 0,0"
  CIcon_Load("GridKeys", "WarkeysGrid3") ; "Hotkey For Grid Position 1,0"
  CIcon_Load("GridKeys", "WarkeysGrid6") ; "Hotkey For Grid Position 2,0"
  CIcon_Load("GridKeys", "WarkeysGrid9") ; "Hotkey For Grid Position 3,0"

  CIcon_Load("GridKeys", "WarkeysGrid1") ; "Hotkey For Grid Position 0,1"
  CIcon_Load("GridKeys", "WarkeysGrid4") ; "Hotkey For Grid Position 1,1"
  CIcon_Load("GridKeys", "WarkeysGrid7") ; "Hotkey For Grid Position 2,1"
  CIcon_Load("GridKeys", "WarkeysGrid10") ; "Hotkey For Grid Position 3,1"

  CIcon_Load("GridKeys", "WarkeysGrid2") ; "Hotkey For Grid Position 0,2"
  CIcon_Load("GridKeys", "WarkeysGrid5") ; "Hotkey For Grid Position 1,2"
  CIcon_Load("GridKeys", "WarkeysGrid8") ; "Hotkey For Grid Position 2,2"
  CIcon_Load("GridKeys", "WarkeysGrid11") ; "Hotkey For Grid Position 3,2"
  
  ; Learn Grid Stuff
  CIcon_Load("GridKeysL", "WarkeysLearnGrid0") ; "Hotkey For Grid Position 0"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid3") ; "Hotkey For Grid Position 3"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid6") ; "Hotkey For Grid Position 6"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid9") ; "Hotkey For Grid Position 9"

  CIcon_Load("GridKeysL", "WarkeysLearnGrid1") ; "Hotkey For Grid Position 1"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid4") ; "Hotkey For Grid Position 4"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid7") ; "Hotkey For Grid Position 7"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid10") ; "Hotkey For Grid Position 10"

  CIcon_Load("GridKeysL", "WarkeysLearnGrid2") ; "Hotkey For Grid Position 2"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid5") ; "Hotkey For Grid Position 5"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid8") ; "Hotkey For Grid Position 8"
  CIcon_Load("GridKeysL", "WarkeysLearnGrid11") ; "Hotkey For Grid Position 11"

  ; Building Basics
  CIcon_Load("CommonBuildingsBasics", "cmdrally")
  CIcon_Load("CommonBuildingsBasics", "cmdcancelbuild")
  ;Shop Basics
  CIcon_Load("CommonBuildingsShopBasics", "plcl")
  CIcon_Load("CommonBuildingsShopBasics", "dust")
  CIcon_Load("CommonBuildingsShopBasics", "phea") ; "Purchase Potion of Healing"
  CIcon_Load("CommonBuildingsShopBasics", "pman") ; "Purchase Potion of Mana"
  CIcon_Load("CommonBuildingsShopBasics", "stwp") ; "Purchase Scroll of Town Portal"
  CIcon_Load("CommonBuildingsShopBasics", "shea") ; "Purchase Scroll of Healing"
  CIcon_Load("CommonBuildingsShopBasics", "anei") ; Select User
  
  ; Unit Basics
  CIcon_LoadUnit("CommonUnitsUnits")
  ; Unit Basics
  CIcon_LoadUnit("CommonUnitsHide")
  CIcon_Load("CommonUnitsHide", "ashm") ; "Hide"
  ; Common Hero Basics
  CIcon_LoadHero("CommonHeroBasics")
  ; Hero Basics
  CIcon_LoadHero("CommonUnitsHeroes")
  ; Catapult Basics
  CIcon_LoadUnitAttackGround("CommonUnitsCatapult")
  ; Pillage
  CIcon_LoadUnit("CommonUnitsPillage")
  CIcon_Load("CommonUnitsPillage", "asal")
  ; Cancel
  CIcon_Load("CommonUnitsCancel", "cmdcancel")
  ; Peon Basics
  CIcon_LoadUnit("CommonUnitsPeon")
  CIcon_Load("CommonUnitsPeon", "ahar") ;lumber harvest
  ; Peon Basics 2
  CIcon_LoadUnit("CommonUnitsPeonU")
  CIcon_Load("CommonUnitsPeonU", "aharD") ;lumber harvest
  
  ; Spells
  CIcon_LoadUnit("CommonSpellsDispel")
  CIcon_Load("CommonSpellsDispel", "adsm") ; "Dispel Magic"
  ; Resistant Skin
  CIcon_LoadUnit("CommonSpellsRSkin")
  CIcon_Load("CommonSpellsRSkin", "acrk") ; "Resistant Skin"
  ; Resistant Skin 2
  CIcon_LoadUnit("CommonSpellsRSkinZ")
  CIcon_Load("CommonSpellsRSkinZ", "acsk") ; "Resistant Skin"
  ; Spell Immunity Green
  CIcon_LoadUnit("CommonSpellsImmune")
  CIcon_Load("CommonSpellsImmune", "amim") ; "Spell Immunity"
  ; Spell Immunity Black
  CIcon_LoadUnit("CommonSpellsImmuneZ")
  CIcon_Load("CommonSpellsImmuneZ", "acmi") ; "Spell Immunity"
  ; Abolish Magic
  CIcon_LoadUnit("CommonSpellsAbolish")
  CIcon_Load("CommonSpellsAbolish", "acd2") ; "Abolish Magic"
  CIcon_LoadUnit("CommonSpellsAbolishU")
  CIcon_Load("CommonSpellsAbolishU", "acd2U") ; "Abolish Magic"
  
  ; Humans
  ; Human Buildings   
  ; Town Hall
  CIcon_LoadBuilding("HumanBuildingsTownhall")
  CIcon_Load("HumanBuildingsTownhall", "hpea")
  CIcon_Load("HumanBuildingsTownhall", "rhpm")
  CIcon_Load("HumanBuildingsTownhall", "hkee") ;upgrade to keep
  CIcon_Load("HumanBuildingsTownhall", "amic")
  CIcon_Load("HumanBuildingsTownhall", "amicD") ;Untip
  ; Keep
  CIcon_LoadBuilding("HumanBuildingsTownhallZ")
  CIcon_Load("HumanBuildingsTownhallZ", "hpea")
  CIcon_Load("HumanBuildingsTownhallZ", "rhpm")
  CIcon_Load("HumanBuildingsTownhallZ", "hcas") ;upgrade to castle
  CIcon_Load("HumanBuildingsTownhallZ", "amic")
  CIcon_Load("HumanBuildingsTownhallZ", "amicD") ;Untip
  ; HumanBuildingsAltar
  CIcon_LoadBuilding("HumanBuildingsAltar")
  CIcon_Load("HumanBuildingsAltar", "Hamg")
  CIcon_Load("HumanBuildingsAltar", "Hmkg")
  CIcon_Load("HumanBuildingsAltar", "Hpal")
  CIcon_Load("HumanBuildingsAltar", "Hblm")
  ;Barracks
  CIcon_LoadBuilding("HumanBuildingsBarracks")
  CIcon_Load("HumanBuildingsBarracks", "hfoo") ; footies
  CIcon_Load("HumanBuildingsBarracks", "hrif") ; rifle
  CIcon_Load("HumanBuildingsBarracks", "hkni") ; knights
  CIcon_Load("HumanBuildingsBarracks", "rhde") ; research defend
  CIcon_Load("HumanBuildingsBarracks", "rhri")
  CIcon_Load("HumanBuildingsBarracks", "rhan")
  ;Lumber Mill
  CIcon_Load("HumanBuildingsLumbermill", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsLumbermill", "rhlh") ; lumber harvesting
  CIcon_Load("HumanBuildingsLumbermill", "rhac") ; masonry

  CIcon_Load("HumanBuildingsLumbermillA", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsLumbermillA", "rhlhA") ; lumber harvesting
  CIcon_Load("HumanBuildingsLumbermillA", "rhacA") ; masonry
  
  CIcon_Load("HumanBuildingsLumbermillB", "cmdcancelbuild")
  ;CIcon_Load("HumanBuildingsLumbermillB", "rhlhA")
  CIcon_Load("HumanBuildingsLumbermillB", "rhacB") ; masonry
  ;Blacksmith
  CIcon_Load("HumanBuildingsBlacksmith", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsBlacksmith", "rhme") ; "Upgrade to Iron Forged Swords"
  CIcon_Load("HumanBuildingsBlacksmith", "rhra") ; "Upgrade to Black Gunpowder"
  CIcon_Load("HumanBuildingsBlacksmith", "rhar") ; "Upgrade to Iron Plating"
  CIcon_Load("HumanBuildingsBlacksmith", "rhla") ; "Upgrade to Studded Leather Armor"
    
  CIcon_Load("HumanBuildingsBlacksmithA", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsBlacksmithA", "rhmeA")
  CIcon_Load("HumanBuildingsBlacksmithA", "rhraA") 
  CIcon_Load("HumanBuildingsBlacksmithA", "rharA") 
  CIcon_Load("HumanBuildingsBlacksmithA", "rhlaA") 

  CIcon_Load("HumanBuildingsBlacksmithB", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsBlacksmithB", "rhmeB")
  CIcon_Load("HumanBuildingsBlacksmithB", "rhraB") 
  CIcon_Load("HumanBuildingsBlacksmithB", "rharB") 
  CIcon_Load("HumanBuildingsBlacksmithB", "rhlaB") 
  
  ; Arcane Sanctum
  CIcon_LoadBuilding("HumanBuildingsSanctum")
  CIcon_Load("HumanBuildingsSanctum", "hmpr") ; train priest
  CIcon_Load("HumanBuildingsSanctum", "rhpt") ; priest training upgrade
  CIcon_Load("HumanBuildingsSanctum", "hsor") ; train sorceress
  CIcon_Load("HumanBuildingsSanctum", "rhst") ; sorc training upgrade
  CIcon_Load("HumanBuildingsSanctum", "hspt") ; spell breaker training
  CIcon_Load("HumanBuildingsSanctum", "rhss") ; research control magic 
  CIcon_Load("HumanBuildingsSanctum", "rhse") ; magic sentry upgrade
  ; Arcane Sanctum 2
  CIcon_LoadBuilding("HumanBuildingsSanctumA")
  CIcon_Load("HumanBuildingsSanctumA", "hmpr") ; train priest
  CIcon_Load("HumanBuildingsSanctumA", "rhptA") ; priest training upgrade
  CIcon_Load("HumanBuildingsSanctumA", "hsor") ; train sorceress
  CIcon_Load("HumanBuildingsSanctumA", "rhstA") ; sorc training upgrade
  CIcon_Load("HumanBuildingsSanctumA", "hspt") ; spell breaker training
  CIcon_Load("HumanBuildingsSanctumA", "rhss") ; research control magic 
  CIcon_Load("HumanBuildingsSanctumA", "rhse") ; magic sentry upgrade
  ;Workshop
  CIcon_LoadBuilding("HumanBuildingsWorkshop")
  CIcon_Load("HumanBuildingsWorkshop", "hgyr")
  CIcon_Load("HumanBuildingsWorkshop", "hmtm")
  CIcon_Load("HumanBuildingsWorkshop", "hmtt") ; tank w/o missles
  CIcon_Load("HumanBuildingsWorkshop", "rhfc")
  CIcon_Load("HumanBuildingsWorkshop", "rhfs")
  CIcon_Load("HumanBuildingsWorkshop", "rhgb")
  CIcon_Load("HumanBuildingsWorkshop", "rhfl")
  CIcon_Load("HumanBuildingsWorkshop", "rhrt") ; barrage
  ;Workshop 2
  CIcon_LoadBuilding("HumanBuildingsWorkshopZ")
  CIcon_Load("HumanBuildingsWorkshopZ", "hgyr")
  CIcon_Load("HumanBuildingsWorkshopZ", "hmtm")
  CIcon_Load("HumanBuildingsWorkshopZ", "hrtt") ; tank with missles
  CIcon_Load("HumanBuildingsWorkshopZ", "rhfc")
  CIcon_Load("HumanBuildingsWorkshopZ", "rhfs")
  CIcon_Load("HumanBuildingsWorkshopZ", "rhgb")
  CIcon_Load("HumanBuildingsWorkshopZ", "rhfl")
  ;Gryphon Aviary
  CIcon_LoadBuilding("HumanBuildingsAviary")
  CIcon_Load("HumanBuildingsAviary", "hgry")
  CIcon_Load("HumanBuildingsAviary", "hdhw")
  CIcon_Load("HumanBuildingsAviary", "rhhb")
  CIcon_Load("HumanBuildingsAviary", "rhcd") ; research cloud
  ;Tower Scout
  CIcon_Load("HumanBuildingsTowerscout", "cmdcancelbuild")
  CIcon_Load("HumanBuildingsTowerscout", "hgtw")
  CIcon_Load("HumanBuildingsTowerscout", "hctw")
  CIcon_Load("HumanBuildingsTowerscout", "hatw")
  CIcon_Load("HumanBuildingsTowerscout", "adts") ; majik sentry
  ;Tower Arcane
  CIcon_Load("HumanBuildingsTowerArcane", "cmdattack")
  CIcon_Load("HumanBuildingsTowerArcane", "cmdstop")
  CIcon_Load("HumanBuildingsTowerArcane", "ahta") ; reveal
  CIcon_Load("HumanBuildingsTowerArcane", "adts") ; majik sentry
  CIcon_Load("HumanBuildingsTowerArcane", "afbt") ; feedback
  ;Arcane Vault
  CIcon_Load("HumanBuildingsVault", "sreg")
  CIcon_Load("HumanBuildingsVault", "plcl")
  CIcon_Load("HumanBuildingsVault", "mcri") ; macronni
  CIcon_Load("HumanBuildingsVault", "phea")
  CIcon_Load("HumanBuildingsVault", "pman") ; pac man

  CIcon_Load("HumanBuildingsVault", "stwp")
  CIcon_Load("HumanBuildingsVault", "tsct")
  CIcon_Load("HumanBuildingsVault", "ofir")
  CIcon_Load("HumanBuildingsVault", "ssan")
  CIcon_Load("HumanBuildingsVault", "anei")
  
  ;Dragon Hawk
  CIcon_LoadUnit("HumanUnitsDragonhawk")
  CIcon_Load("HumanUnitsDragonhawk", "amls")
  CIcon_Load("HumanUnitsDragonhawk", "aclf") ; cloud
  ;Gryphon Rider
  CIcon_LoadUnit("HumanUnitsGryphon")
  CIcon_Load("HumanUnitsGryphon", "asth") ; storm hammers
  ;Footman
  CIcon_LoadUnit("HumanUnitsFootman")
  CIcon_Load("HumanUnitsFootman", "adef") ; defend
  ;Footman (Defending)
  CIcon_LoadUnit("HumanUnitsFootmanU")
  CIcon_Load("HumanUnitsFootmanU", "adefD") ; stop defend
  ;Flying Machine
  CIcon_LoadUnit("HumanUnitsFlyingMachine")
  CIcon_Load("HumanUnitsFlyingMachine", "agyv")
  CIcon_Load("HumanUnitsFlyingMachine", "aflk")
  CIcon_Load("HumanUnitsFlyingMachine", "agyb")

  ;Mortar Team
  CIcon_LoadUnit("HumanUnitsMortar")
  CIcon_Load("HumanUnitsMortar", "afla") 
  CIcon_Load("HumanUnitsMortar", "afsh")
  ;Steam Tank
  CIcon_LoadUnit("HumanUnitsSteamTank")
  CIcon_Load("HumanUnitsSteamTank", "aroc")
  ;Peasant
  CIcon_LoadUnit("HumanUnitsPeasant")
  CIcon_Load("HumanUnitsPeasant", "ahrp") ; repair
  CIcon_Load("HumanUnitsPeasant", "ahar") 
  CIcon_Load("HumanUnitsPeasant", "cmdbuildhuman")
  CIcon_Load("HumanUnitsPeasant", "amil") ; Militia
  CIcon_Load("HumanUnitsPeasant", "amilD") ; Back to Work 
  ;Peasant with wood mheh heh uh huh huh
  CIcon_LoadUnit("HumanUnitsPeasantU")
  CIcon_Load("HumanUnitsPeasantU", "ahrpU") ; repair
  CIcon_Load("HumanUnitsPeasantU", "aharD") 
  CIcon_Load("HumanUnitsPeasantU", "cmdbuildhuman")
  CIcon_Load("HumanUnitsPeasantU", "amil") ; Militia
  CIcon_Load("HumanUnitsPeasantU", "amilD") ; Back to Work 
  ;Peasant-Build 
  CIcon_Load("HumanUnitsPeasantBuild", "htow")
  CIcon_Load("HumanUnitsPeasantBuild", "hbar")
  CIcon_Load("HumanUnitsPeasantBuild", "hlum")
  CIcon_Load("HumanUnitsPeasantBuild", "hbla")
  CIcon_Load("HumanUnitsPeasantBuild", "hhou")
  CIcon_Load("HumanUnitsPeasantBuild", "halt")
  CIcon_Load("HumanUnitsPeasantBuild", "hars") 
  CIcon_Load("HumanUnitsPeasantBuild", "harm")
  CIcon_Load("HumanUnitsPeasantBuild", "hwtw")
  CIcon_Load("HumanUnitsPeasantBuild", "hgra") 
  CIcon_Load("HumanUnitsPeasantBuild", "hvlt")
  CIcon_Load("HumanUnitsPeasantBuild", "cmdcancel")
  ;Priest
  CIcon_LoadUnit("HumanUnitsPriest")
  CIcon_Load("HumanUnitsPriest", "ahea")
  CIcon_Load("HumanUnitsPriest", "adis") 
  CIcon_Load("HumanUnitsPriest", "ainf")
  ;PriestA
  CIcon_LoadUnit("HumanUnitsPriestU")
  CIcon_Load("HumanUnitsPriestU", "aheaU")
  CIcon_Load("HumanUnitsPriestU", "adis") 
  CIcon_Load("HumanUnitsPriestU", "ainfU")
  ;Sorceress
  CIcon_LoadUnit("HumanUnitsSorceress")
  CIcon_Load("HumanUnitsSorceress", "aslo")
  CIcon_Load("HumanUnitsSorceress", "aivs") 
  CIcon_Load("HumanUnitsSorceress", "aply")
  ;SorceressA
  CIcon_LoadUnit("HumanUnitsSorceressU")
  CIcon_Load("HumanUnitsSorceressU", "asloU")
  CIcon_Load("HumanUnitsSorceressU", "aivs") 
  CIcon_Load("HumanUnitsSorceressU", "aply")
  ;Spell Breaker
  CIcon_LoadUnit("HumanUnitsSpellbreaker")
  CIcon_Load("HumanUnitsSpellbreaker", "amim") ; spell immunity
  CIcon_Load("HumanUnitsSpellbreaker", "afbk") ; feedback
  CIcon_Load("HumanUnitsSpellbreaker", "acmg") ; control magic
  CIcon_Load("HumanUnitsSpellbreaker", "asps") ; spell steal
  ;Spell BreakerA
  CIcon_LoadUnit("HumanUnitsSpellbreakerU")
  CIcon_Load("HumanUnitsSpellbreakerU", "amim") ; spell immunity
  CIcon_Load("HumanUnitsSpellbreakerU", "afbk") ; feedback
  CIcon_Load("HumanUnitsSpellbreakerU", "acmg") ; control magic
  CIcon_Load("HumanUnitsSpellbreakerU", "aspsU") ; spell steal
  
  ;Archmage
  CIcon_LoadHero("HumanHeroesArchmage")
  CIcon_Load("HumanHeroesArchmage", "ahbz")
  CIcon_Load("HumanHeroesArchmage", "ahwe")
  CIcon_Load("HumanHeroesArchmage", "ahab")
  CIcon_Load("HumanHeroesArchmage", "ahmt")
  ;Archmage Learn
  CIcon_Load("HumanHeroesArchmageL", "ahbzL")
  CIcon_Load("HumanHeroesArchmageL", "ahweL")
  CIcon_Load("HumanHeroesArchmageL", "ahabL")
  CIcon_Load("HumanHeroesArchmageL", "ahmtL")
  ;Blood Mage
  CIcon_LoadHero("HumanHeroesBloodmage")
  CIcon_Load("HumanHeroesBloodmage", "AHfs")
  CIcon_Load("HumanHeroesBloodmage", "AHbn")
  CIcon_Load("HumanHeroesBloodmage", "AHdr")
  CIcon_Load("HumanHeroesBloodmage", "AHpx")
  ;Blood Mage Learn
  CIcon_Load("HumanHeroesBloodmageL", "AHfsL")
  CIcon_Load("HumanHeroesBloodmageL", "AHbnL")
  CIcon_Load("HumanHeroesBloodmageL", "AHdrL")
  CIcon_Load("HumanHeroesBloodmageL", "AHpxL")
  ;Mountain King
  CIcon_LoadHero("HumanHeroesMountainking")
  CIcon_Load("HumanHeroesMountainking", "AHtb")
  CIcon_Load("HumanHeroesMountainking", "AHtc")
  CIcon_Load("HumanHeroesMountainking", "AHbh")
  CIcon_Load("HumanHeroesMountainking", "AHav")
  ;Mountain King Learn
  CIcon_Load("HumanHeroesMountainkingL", "AHtbL")
  CIcon_Load("HumanHeroesMountainkingL", "AHtcL")
  CIcon_Load("HumanHeroesMountainkingL", "AHbhL")
  CIcon_Load("HumanHeroesMountainkingL", "AHavL")
  ;Paladin
  CIcon_LoadHero("HumanHeroesPaladin")
  CIcon_Load("HumanHeroesPaladin", "AHhb")
  CIcon_Load("HumanHeroesPaladin", "AHds")
  CIcon_Load("HumanHeroesPaladin", "AHad")
  CIcon_Load("HumanHeroesPaladin", "AHre")
  ;Paladin Learn
  CIcon_Load("HumanHeroesPaladinL", "AHhbL")
  CIcon_Load("HumanHeroesPaladinL", "AHdsL")
  CIcon_Load("HumanHeroesPaladinL", "AHadL")
  CIcon_Load("HumanHeroesPaladinL", "AHreL")
  ; Phoenix
  CIcon_LoadUnit("HumanHeroSummonsPhoenix")
  CIcon_Load("HumanHeroSummonsPhoenix", "acrk") ; "Resistant Skin"
  CIcon_Load("HumanHeroSummonsPhoenix", "acmi") ; "Spell Immunity"

  ; Orc
  ; Orc Buildings
  ; Altar of Storms
  CIcon_LoadBuilding("OrcBuildingsAltarofStorms")
  CIcon_Load("OrcBuildingsAltarofStorms", "oshd") ; "Shadow Hunter"
  CIcon_Load("OrcBuildingsAltarofStorms", "obla") ; "Blade Master"
  CIcon_Load("OrcBuildingsAltarofStorms", "ofar") ; "Far Seer"
  CIcon_Load("OrcBuildingsAltarofStorms", "otch") ; "Tauren Chieftain"
  ; Barracks
  CIcon_LoadBuilding("OrcBuildingsBarracks")
  CIcon_Load("OrcBuildingsBarracks", "ogru") ; "Grunt"
  CIcon_Load("OrcBuildingsBarracks", "ohun") ; "Troll Headhunter"
  CIcon_Load("OrcBuildingsBarracks", "ocat") ; "Catapult"
  CIcon_Load("OrcBuildingsBarracks", "robk") ; "Learn Berserker Upgrade"
  CIcon_Load("OrcBuildingsBarracks", "robs") ; "Learn Berserker Strength"
  CIcon_Load("OrcBuildingsBarracks", "rotr") ; "Learn Troll Regeneration"
  CIcon_Load("OrcBuildingsBarracks", "robf") ; "Research Naphtha"
  ; Barracks 2
  CIcon_LoadBuilding("OrcBuildingsBarracksZ")
  CIcon_Load("OrcBuildingsBarracksZ", "ogru") ; "Grunt"
  CIcon_Load("OrcBuildingsBarracksZ", "otbk") ; "Troll Headhunter"
  CIcon_Load("OrcBuildingsBarracksZ", "ocat") ; "Catapult"
  ;CIcon_Load("OrcBuildingsBarracksZ", "robk") ; "Learn Berserker Upgrade"
  CIcon_Load("OrcBuildingsBarracksZ", "robs") ; "Learn Berserker Strength"
  CIcon_Load("OrcBuildingsBarracksZ", "rotr") ; "Learn Troll Regeneration"
  CIcon_Load("OrcBuildingsBarracksZ", "robf") ; "Research Naphtha"
  ; Beastiary
  CIcon_LoadBuilding("OrcBuildingsBeastiary")
  CIcon_Load("OrcBuildingsBeastiary", "orai") ; "Raider"
  CIcon_Load("OrcBuildingsBeastiary", "okod") ; "Kodo Beast"
  CIcon_Load("OrcBuildingsBeastiary", "owyv") ; "Wyrven"
  CIcon_Load("OrcBuildingsBeastiary", "otbr") ; "Troll Batrider"
  CIcon_Load("OrcBuildingsBeastiary", "rolf") ; "Research Liquid Fire"
  CIcon_Load("OrcBuildingsBeastiary", "roen") ; "Learn Ensnare"
  CIcon_Load("OrcBuildingsBeastiary", "rwdm") ; "Learn War Drums"
  CIcon_Load("OrcBuildingsBeastiary", "rovs") ; "Learn Envenomed Weapon"
  ; Burrow
  CIcon_Load("OrcBuildingsBurrow", "cmdstop") ; "Stop"
  CIcon_Load("OrcBuildingsBurrow", "cmdattack") ; "Attack"
  CIcon_Load("OrcBuildingsBurrow", "abtl") ; "Battlestations"
  CIcon_Load("OrcBuildingsBurrow", "astd") ; "Stand Down"
  ; Spirit Lodge
  CIcon_LoadBuilding("OrcBuildingsSpiritLodge")
  CIcon_Load("OrcBuildingsSpiritLodge", "oshm") ; "Shaman"
  CIcon_Load("OrcBuildingsSpiritLodge", "odoc") ; "Witch Doctor"
  CIcon_Load("OrcBuildingsSpiritLodge", "ospm") ; "Spirit Walker"
  CIcon_Load("OrcBuildingsSpiritLodge", "rost") ; "Shaman Adept Training"
  CIcon_Load("OrcBuildingsSpiritLodge", "rowd") ; "Witch Doctor Adept Training"
  CIcon_Load("OrcBuildingsSpiritLodge", "rowt") ; "Spirit Walker Adept Training"
  ; Spirit Lodge 2
  CIcon_LoadBuilding("OrcBuildingsSpiritLodgeA")
  CIcon_Load("OrcBuildingsSpiritLodgeA", "oshm") ; "Shaman"
  CIcon_Load("OrcBuildingsSpiritLodgeA", "odoc") ; "Witch Doctor"
  CIcon_Load("OrcBuildingsSpiritLodgeA", "ospm") ; "Spirit Walker"
  CIcon_Load("OrcBuildingsSpiritLodgeA", "rostA") ; "Shaman Adept Training"
  CIcon_Load("OrcBuildingsSpiritLodgeA", "rowdA") ; "Witch Doctor Adept Training"
  CIcon_Load("OrcBuildingsSpiritLodgeA", "rowtA") ; "Spirit Walker Adept Training"
  ; Tauren Totem
  CIcon_LoadBuilding("OrcBuildingsTaurenTotem")
  CIcon_Load("OrcBuildingsTaurenTotem", "otau") ; "Tauren"
  CIcon_Load("OrcBuildingsTaurenTotem", "rows") ; "Learn Pulverize"
  ; Great Hall
  CIcon_LoadBuilding("OrcBuildingsTownHall")
  CIcon_Load("OrcBuildingsTownHall", "opeo") ; "Peon"
  CIcon_Load("OrcBuildingsTownHall", "ropg") ; "Research Pillage"
  CIcon_Load("OrcBuildingsTownHall", "ropm") ; "Research Backpack"
  CIcon_Load("OrcBuildingsTownHall", "ostr") ; "Upgrade Town Hall"
  ; Stronghold
  CIcon_LoadBuilding("OrcBuildingsTownHallZ")
  CIcon_Load("OrcBuildingsTownHallZ", "opeo") ; "Peon"
  CIcon_Load("OrcBuildingsTownHallZ", "ropg") ; "Research Pillage"
  CIcon_Load("OrcBuildingsTownHallZ", "ropm") ; "Research Backpack"
  CIcon_Load("OrcBuildingsTownHallZ", "ofrt") ; "Upgrade To Fortress"
  ; Voodoo Lounge
  CIcon_Load("OrcBuildingsVoodooLounge", "hslv") ; "Purchase Healing Salve"
  CIcon_Load("OrcBuildingsVoodooLounge", "plcl") ; "Purchase Lesser Clarity Potion"
  CIcon_Load("OrcBuildingsVoodooLounge", "shas") ; "Purchase Scroll of Speed"
  CIcon_Load("OrcBuildingsVoodooLounge", "phea") ; "Purchase Potion of Healing"
  CIcon_Load("OrcBuildingsVoodooLounge", "pman") ; "Purchase Potion of Mana"
  CIcon_Load("OrcBuildingsVoodooLounge", "stwp") ; "Purchase Scroll of Town Portal"
  CIcon_Load("OrcBuildingsVoodooLounge", "oli2") ; "Purchase Orb of Lightning"
  CIcon_Load("OrcBuildingsVoodooLounge", "tgrh") ; "Purchase Tiny Great Hall"
  CIcon_Load("OrcBuildingsVoodooLounge", "anei") ; Select User
  ; War Mill
  CIcon_Load("OrcBuildingsWarMill", "cmdcancelbuild") ; "Cancel Build"
  CIcon_Load("OrcBuildingsWarMill", "rorb") ; "Reinforced Defenses"
  CIcon_Load("OrcBuildingsWarMill", "rosp") ; "Upgrade to Spiked Barricades"
  CIcon_Load("OrcBuildingsWarMill", "rome") ; "Upgrade to Steel Melee Weapons"
  CIcon_Load("OrcBuildingsWarMill", "rora") ; "Upgrade to Steel Ranged Weapons"
  CIcon_Load("OrcBuildingsWarMill", "roar") ; "Upgrade to Steel Unit Armor"
  ; War Mill 2
  CIcon_Load("OrcBuildingsWarMillA", "cmdcancelbuild") ; "Cancel Build"
  CIcon_Load("OrcBuildingsWarMillA", "rospA") ; "Upgrade to Spiked Barricades"
  CIcon_Load("OrcBuildingsWarMillA", "romeA") ; "Upgrade to Steel Melee Weapons"
  CIcon_Load("OrcBuildingsWarMillA", "roraA") ; "Upgrade to Steel Ranged Weapons"
  CIcon_Load("OrcBuildingsWarMillA", "roarA") ; "Upgrade to Steel Unit Armor"
  ; War Mill 3
  CIcon_Load("OrcBuildingsWarMillB", "cmdcancelbuild") ; "Cancel Build"
  CIcon_Load("OrcBuildingsWarMillB", "rospB") ; "Upgrade to Spiked Barricades"
  CIcon_Load("OrcBuildingsWarMillB", "romeB") ; "Upgrade to Steel Melee Weapons"
  CIcon_Load("OrcBuildingsWarMillB", "roraB") ; "Upgrade to Steel Ranged Weapons"
  CIcon_Load("OrcBuildingsWarMillB", "roarB") ; "Upgrade to Steel Unit Armor"
  
  ; Orc Heroes
  ; Far Seer
  CIcon_LoadHero("OrcHeroesFarSeer")
  CIcon_LoadHS("OrcHeroesFarSeer", "aocl") ; "Chain Lightning"
  CIcon_LoadHS("OrcHeroesFarSeer", "aofs") ; "Far Sight"
  CIcon_LoadHS("OrcHeroesFarSeer", "aosf") ; "Feral Spirit"
  CIcon_LoadHS("OrcHeroesFarSeer", "aoeq") ; "Earthquake"
  ; Tauren Chieftain
  CIcon_LoadHero("OrcHeroesTaurenChief")
  CIcon_LoadHS("OrcHeroesTaurenChief", "aosh") ; "Shockwave"
  CIcon_LoadHS("OrcHeroesTaurenChief", "aows") ; "War Stomp"
  CIcon_LoadHS("OrcHeroesTaurenChief", "aoae") ; "Endurance Aura"
  CIcon_LoadHS("OrcHeroesTaurenChief", "aore") ; "Reincarnation"
  ; Blademaster
  CIcon_LoadHero("OrcHeroesBlademaster")
  CIcon_LoadHS("OrcHeroesBlademaster", "aowk") ; "Wind Walk"
  CIcon_LoadHS("OrcHeroesBlademaster", "aomi") ; "Mirror Image"
  CIcon_LoadHS("OrcHeroesBlademaster", "aocr") ; "Critical Strike"
  CIcon_LoadHS("OrcHeroesBlademaster", "aoww") ; "Bladestorm"
  ; Shadow Hunter
  CIcon_LoadHero("OrcHeroesShadowHunter")
  CIcon_LoadHS("OrcHeroesShadowHunter", "aohw") ; "Healing Wave"
  CIcon_LoadHS("OrcHeroesShadowHunter", "aohx") ; "Hex"
  CIcon_LoadHS("OrcHeroesShadowHunter", "aosw") ; "Serpent Ward"
  CIcon_LoadHS("OrcHeroesShadowHunter", "aovd") ; "Big Bad Voodoo"
  ; Orc Units
  ; Peon
  CIcon_LoadUnit("OrcUnitsPeon")
  CIcon_Load("OrcUnitsPeon", "asal") ; "Pillage"
  CIcon_Load("OrcUnitsPeon", "arep") ; repair
  CIcon_Load("OrcUnitsPeon", "ahar") 
  CIcon_Load("OrcUnitsPeon", "cmdbuildorc") ; "Build Structure"
  ; Peon with wood
  CIcon_LoadUnit("OrcUnitsPeonU")
  CIcon_Load("OrcUnitsPeonU", "ahrpU") ; repair
  CIcon_Load("OrcUnitsPeonU", "aharD") 
  CIcon_Load("OrcUnitsPeonU", "asal") ; "Pillage"
  CIcon_Load("OrcUnitsPeonU", "cmdbuildorc") ; "Build Structure"
  ; Peon-Build
  CIcon_Load("OrcUnitsPeonBuild", "ogre") ; "Build Great Hall"
  CIcon_Load("OrcUnitsPeonBuild", "obar") ; "Build Barracks"
  CIcon_Load("OrcUnitsPeonBuild", "ofor") ; "Build War Mill"
  CIcon_Load("OrcUnitsPeonBuild", "owtw") ; "Build Watch Tower"
  CIcon_Load("OrcUnitsPeonBuild", "otrb") ; "Build Burrow"
  CIcon_Load("OrcUnitsPeonBuild", "oalt") ; "Build Altar of Storms"
  CIcon_Load("OrcUnitsPeonBuild", "osld") ; "Build Spirit Lodge"
  CIcon_Load("OrcUnitsPeonBuild", "obea") ; "Build Beastiary"
  CIcon_Load("OrcUnitsPeonBuild", "otto") ; "Build Tauren Totem"
  CIcon_Load("OrcUnitsPeonBuild", "ovln") ; "Build Voodoo Lounge"
  CIcon_Load("OrcUnitsPeonBuild", "cmdcancel")
  ; Troll Berserker
  CIcon_LoadUnit("OrcUnitsBerserker")
  CIcon_Load("OrcUnitsBerserker", "absk") ; "Berserk"
  ; Demolisher
  CIcon_LoadUnitAttackGround("OrcUnitsDemolisher")
  CIcon_Load("OrcUnitsDemolisher", "abof") ; "Burning Oil"
  ; Shaman ROC
  CIcon_LoadUnit("OrcUnitsShamanRoc")
  CIcon_Load("OrcUnitsShamanRoc", "aprg") ; "Purge"
  CIcon_Load("OrcUnitsShamanRoc", "alsh") ; "Lightning Shield"
  CIcon_Load("OrcUnitsShamanRoc", "ablo") ; "Bloodlust"
  ; Shaman ROC (Auto-Cast On)
  CIcon_LoadUnit("OrcUnitsShamanRocU")
  CIcon_Load("OrcUnitsShamanRocU", "aprg") ; "Purge"
  CIcon_Load("OrcUnitsShamanRocU", "alsh") ; "Lightning Shield"
  CIcon_Load("OrcUnitsShamanRocU", "abloU") ; "Bloodlust"
  ; Shaman
  CIcon_LoadUnit("OrcUnitsShaman")
  CIcon_Load("OrcUnitsShaman", "apg2") ; "Purge"
  CIcon_Load("OrcUnitsShaman", "alsh") ; "Lightning Shield"
  CIcon_Load("OrcUnitsShaman", "ablo") ; "Bloodlust"
  ; Shaman (Auto-Cast On)
  CIcon_LoadUnit("OrcUnitsShamanU")
  CIcon_Load("OrcUnitsShamanU", "apg2") ; "Purge"
  CIcon_Load("OrcUnitsShamanU", "alsh") ; "Lightning Shield"
  CIcon_Load("OrcUnitsShamanU", "abloU") ; "Bloodlust"
  ; Troll Witch Doc
  CIcon_LoadUnit("OrcUnitsWitchDoc")
  CIcon_Load("OrcUnitsWitchDoc", "aeye") ; "Sentry Ward"
  CIcon_Load("OrcUnitsWitchDoc", "asta") ; "Stasis Trap"
  CIcon_Load("OrcUnitsWitchDoc", "ahwd") ; "Healing Ward"
  ; Spirit Walker
  CIcon_LoadUnitNoAttack("OrcUnitsSpiritWalker")
  CIcon_Load("OrcUnitsSpiritWalker", "aspl") ; "Spirit Link"
  CIcon_Load("OrcUnitsSpiritWalker", "adcn") ; "Disenchant"
  CIcon_Load("OrcUnitsSpiritWalker", "aast") ; "Ancestral Spirit"
  CIcon_Load("OrcUnitsSpiritWalker", "acpf") ; "Corporeal Form"
  ; Spirit Walker Corporeal
  CIcon_LoadUnit("OrcUnitsSpiritWalkerU")
  CIcon_Load("OrcUnitsSpiritWalkerU", "aspl") ; "Spirit Link"
  CIcon_Load("OrcUnitsSpiritWalkerU", "adcn") ; "Disenchant"
  CIcon_Load("OrcUnitsSpiritWalkerU", "aast") ; "Ancestral Spirit"
  CIcon_Load("OrcUnitsSpiritWalkerU", "acpfD") ; "Ethereal Form"
  ; Raider
  CIcon_LoadUnit("OrcUnitsRadier")
  CIcon_Load("OrcUnitsRadier", "asal") ; "Pillage"
  CIcon_Load("OrcUnitsRadier", "aens") ; "Ensnare"
  ; Wind Raider
  CIcon_LoadUnit("OrcUnitsWindRaider")
  CIcon_Load("OrcUnitsWindRaider", "aven") ; "Envenomed Spears"
  ; Kodo Beast
  CIcon_LoadUnit("OrcUnitsKodo")
  CIcon_Load("OrcUnitsKodo", "adev") ; "Devour"
  CIcon_Load("OrcUnitsKodo", "aakb") ; "War Drums"
  ; Troll Batrider
  CIcon_LoadUnit("OrcUnitsBatrider")
  CIcon_Load("OrcUnitsBatrider", "auco") ; "Unstable Concoction"
  CIcon_Load("OrcUnitsBatrider", "aliq") ; "Liquid Fire"
  ; Tauren
  CIcon_LoadUnit("OrcUnitsTauren")
  CIcon_Load("OrcUnitsTauren", "awar") ; "Pulverize"
  ; Feral Spirit
  CIcon_LoadUnit("OrcHeroSummonsFeralSpirit")
  CIcon_Load("OrcHeroSummonsFeralSpirit", "acct") ; "Critical Strike"
  
  ; Undead
  ; Undead Buildings
  ; Necropolis
  CIcon_LoadBuilding("UndeadBuildingsNecropolis")
  CIcon_Load("UndeadBuildingsNecropolis", "uaco") ; "Train Acolyte"
  CIcon_Load("UndeadBuildingsNecropolis", "rupm") ; "Research Backpack"
  CIcon_Load("UndeadBuildingsNecropolis", "unp1") ; "Upgrade to Halls of the Dead"
  ; Halls of the Dead
  CIcon_LoadBuilding("UndeadBuildingsNecropolisZ")
  CIcon_Load("UndeadBuildingsNecropolisZ", "uaco") ; "Train Acolyte"
  CIcon_Load("UndeadBuildingsNecropolisZ", "rupm") ; "Research Backpack"
  CIcon_Load("UndeadBuildingsNecropolisZ", "unp2") ; "Upgrade to Black Citadel"
  CIcon_Load("UndeadBuildingsNecropolisZ", "afr2") ; "Frost Attack"
  ; Ziggurat
  CIcon_Load("UndeadBuildingsZiggurat", "uzg1") ; "Upgrade to Spirit Tower"
  CIcon_Load("UndeadBuildingsZiggurat", "uzg2") ; "Upgrade to Nerubian Tower"
  ; Nerubian Tower
  CIcon_Load("UndeadBuildingsTower", "cmdstop") ; "Stop"
  CIcon_Load("UndeadBuildingsTower", "cmdattack") ; "Attack"
  CIcon_Load("UndeadBuildingsTower", "afra") ; "Frost Attack"
  ; Altar of Darkness
  CIcon_LoadBuilding("UndeadBuildingsAltar")
  CIcon_Load("UndeadBuildingsAltar", "udea") ; "Death Knight"
  CIcon_Load("UndeadBuildingsAltar", "udre") ; "Dreadlord"
  CIcon_Load("UndeadBuildingsAltar", "ulic") ; "Lich"
  CIcon_Load("UndeadBuildingsAltar", "ucrl") ; "Crypt Lord"
  ; Crypt
  CIcon_LoadBuilding("UndeadBuildingsCrypt")
  CIcon_Load("UndeadBuildingsCrypt", "ugho") ; "Train Ghoul"
  CIcon_Load("UndeadBuildingsCrypt", "ucry") ; "Train Crypt Fiend"
  CIcon_Load("UndeadBuildingsCrypt", "ugar") ; "Train Gargoyle"
  CIcon_Load("UndeadBuildingsCrypt", "ruac") ; "Research Cannibalize"
  CIcon_Load("UndeadBuildingsCrypt", "rubu") ; "Research Burrow"
  CIcon_Load("UndeadBuildingsCrypt", "rugf") ; "Research Ghoul Frenzy"
  CIcon_Load("UndeadBuildingsCrypt", "ruwb") ; "Research Web"
  CIcon_Load("UndeadBuildingsCrypt", "rusf") ; "Research Stone Form"
  ; Graveyard
  CIcon_Load("UndeadBuildingsGraveyard", "cmdcancelbuild")
  CIcon_Load("UndeadBuildingsGraveyard", "rume") ; "Unholy Strength"
  CIcon_Load("UndeadBuildingsGraveyard", "ruar") ; "Unholy Armor"
  CIcon_Load("UndeadBuildingsGraveyard", "rura") ; "Creature Attack"
  CIcon_Load("UndeadBuildingsGraveyard", "rucr") ; "Creature Carapace"
  ; Graveyard 2
  CIcon_Load("UndeadBuildingsGraveyardA", "cmdcancelbuild")
  CIcon_Load("UndeadBuildingsGraveyardA", "rumeA") ; "Unholy Strength"
  CIcon_Load("UndeadBuildingsGraveyardA", "ruarA") ; "Unholy Armor"
  CIcon_Load("UndeadBuildingsGraveyardA", "ruraA") ; "Creature Attack"
  CIcon_Load("UndeadBuildingsGraveyardA", "rucrA") ; "Creature Carapace"
  ; Graveyard 3
  CIcon_Load("UndeadBuildingsGraveyardB", "cmdcancelbuild")
  CIcon_Load("UndeadBuildingsGraveyardB", "rumeB") ; "Unholy Strength"
  CIcon_Load("UndeadBuildingsGraveyardB", "ruarB") ; "Unholy Armor"
  CIcon_Load("UndeadBuildingsGraveyardB", "ruraB") ; "Creature Attack"
  CIcon_Load("UndeadBuildingsGraveyardB", "rucrB") ; "Creature Carapace"
  ; Temple of the Damned aka N-BEAMS or M-BEANS
  CIcon_LoadBuilding("UndeadBuildingsTemple")
  CIcon_Load("UndeadBuildingsTemple", "unec") ; "Train Necromancer"
  CIcon_Load("UndeadBuildingsTemple", "uban") ; "Train Banshee"
  CIcon_Load("UndeadBuildingsTemple", "rune") ; "Necromancer Adept Training"
  CIcon_Load("UndeadBuildingsTemple", "ruba") ; "Banshee Adept Training"
  CIcon_Load("UndeadBuildingsTemple", "rusm") ; "Research Skeletal Mastery"
  CIcon_Load("UndeadBuildingsTemple", "rusl") ; "Research Skeletal Longevity"
  ; Temple of the Damned 2 aka N-BEAMS or M-BEANS
  CIcon_LoadBuilding("UndeadBuildingsTempleA")
  CIcon_Load("UndeadBuildingsTempleA", "unec") ; "Train Necromancer"
  CIcon_Load("UndeadBuildingsTempleA", "uban") ; "Train Banshee"
  CIcon_Load("UndeadBuildingsTempleA", "runeA") ; "Necromancer Adept Training"
  CIcon_Load("UndeadBuildingsTempleA", "rubaA") ; "Banshee Adept Training"
  CIcon_Load("UndeadBuildingsTempleA", "rusm") ; "Research Skeletal Mastery"
  CIcon_Load("UndeadBuildingsTempleA", "rusl") ; "Research Skeletal Longevity"
  ; Slaughterhouse
  CIcon_LoadBuilding("UndeadBuildingsSlaughterhouse")
  CIcon_Load("UndeadBuildingsSlaughterhouse", "umtw") ; "Train Meat Wagon"
  CIcon_Load("UndeadBuildingsSlaughterhouse", "uabo") ; "Train Abomination"
  CIcon_Load("UndeadBuildingsSlaughterhouse", "uobs") ; "Create Obsidian Statue"
  CIcon_Load("UndeadBuildingsSlaughterhouse", "ruex") ; "Research Exhume Corpses"
  CIcon_Load("UndeadBuildingsSlaughterhouse", "rupc") ; "Research Disease Cloud"
  CIcon_Load("UndeadBuildingsSlaughterhouse", "rusp") ; "Research Destroyer Form"
  ; Sacrificial Pit
  CIcon_LoadBuilding("UndeadBuildingsPit")
  CIcon_Load("UndeadBuildingsPit", "asac") ; "Sacrifice"
  ; Boneyard
  CIcon_LoadBuilding("UndeadBuildingsBoneyard")
  CIcon_Load("UndeadBuildingsBoneyard", "ufro") ; "Train Frost Wyrm"
  CIcon_Load("UndeadBuildingsBoneyard", "rufb") ; "Research Freezing Breath"
  ; Tomb of Relics
  CIcon_Load("UndeadBuildingsRelics", "rnec") ; "Purchase Rod of Necromancy"
  CIcon_Load("UndeadBuildingsRelics", "skul") ; "Purchase Sacrificial Skull"
  CIcon_Load("UndeadBuildingsRelics", "dust") ; "Purchase Dust of Appearance"
  CIcon_Load("UndeadBuildingsRelics", "ocor") ; "Purchase Orb of Corruption"
  CIcon_Load("UndeadBuildingsRelics", "shea") ; "Purchase Scroll of Healing"
  CIcon_Load("UndeadBuildingsRelics", "phea") ; "Purchase Potion of Healing"
  CIcon_Load("UndeadBuildingsRelics", "pman") ; "Purchase Potion of Mana"
  CIcon_Load("UndeadBuildingsRelics", "stwp") ; "Purchase Scroll of Town Portal"
  CIcon_Load("UndeadBuildingsRelics", "anei") ; Select User
  ; Undead Units
  ; Acolyte
  CIcon_LoadUnit("UndeadUnitsAcolyte")
  CIcon_Load("UndeadUnitsAcolyte", "cmdbuildundead") ; "Summon Building"
  CIcon_Load("UndeadUnitsAcolyte", "auns") ; "Unsummon Building"
  CIcon_Load("UndeadUnitsAcolyte", "arst") ; "Restore"
  CIcon_Load("UndeadUnitsAcolyte", "aaha") ; "Gather"
  CIcon_Load("UndeadUnitsAcolyte", "alam") ; "Sacrifice"
  ; Acolyte: Auto-cast On
  CIcon_LoadUnit("UndeadUnitsAcolyteU")
  CIcon_Load("UndeadUnitsAcolyteU", "cmdbuildundead") ; "Summon Building"
  CIcon_Load("UndeadUnitsAcolyteU", "auns") ; "Unsummon Building"
  CIcon_Load("UndeadUnitsAcolyteU", "arstU") ; "Restore"
  CIcon_Load("UndeadUnitsAcolyteU", "aaha") ; "Gather"
  CIcon_Load("UndeadUnitsAcolyteU", "alam") ; "Sacrifice"
  ; Acolyte Build
  CIcon_Load("UndeadUnitsAcolyteBuild", "unpl") ; "Summon Necropolis"
  CIcon_Load("UndeadUnitsAcolyteBuild", "usep") ; "Summon Crypt"
  CIcon_Load("UndeadUnitsAcolyteBuild", "ugol") ; "Haunt Gold Mine"
  CIcon_Load("UndeadUnitsAcolyteBuild", "ugrv") ; "Summon Graveyard"
  CIcon_Load("UndeadUnitsAcolyteBuild", "uzig") ; "Summon Ziggurat"
  CIcon_Load("UndeadUnitsAcolyteBuild", "uaod") ; "Summon Altar"
  CIcon_Load("UndeadUnitsAcolyteBuild", "utod") ; "Summon Temple of the Damned"
  CIcon_Load("UndeadUnitsAcolyteBuild", "uslh") ; "Summon Slaughterhouse"
  CIcon_Load("UndeadUnitsAcolyteBuild", "usap") ; "Summon Sacrificial Pit"
  CIcon_Load("UndeadUnitsAcolyteBuild", "ubon") ; "Summon Boneyard"
  CIcon_Load("UndeadUnitsAcolyteBuild", "utom") ; "Summon Tomb of Relics"
  CIcon_Load("UndeadUnitsAcolyteBuild", "cmdcancel")
  ; Ghoul
  CIcon_LoadUnit("UndeadUnitsGhoul")
  CIcon_Load("UndeadUnitsGhoul", "acan") ; "Cannibalize"
  CIcon_Load("UndeadUnitsGhoul", "ahrl") ; "Gather"/ "Return Resources"
  ; Ghoul: with Wood
  CIcon_LoadUnit("UndeadUnitsGhoulU")
  CIcon_Load("UndeadUnitsGhoulU", "acan") ; "Cannibalize"
  CIcon_Load("UndeadUnitsGhoulU", "ahrlD") ; "Gather"/ "Return Resources"
  ; Crypt Fiend
  CIcon_LoadUnit("UndeadUnitsFiend")
  CIcon_Load("UndeadUnitsFiend", "aweb") ; "Web"
  CIcon_Load("UndeadUnitsFiend", "abur") ; "Burrow"/ "Unburrow"
  ; Crypt Fiend: Auto-cast on
  CIcon_LoadUnit("UndeadUnitsFiendU")
  CIcon_Load("UndeadUnitsFiendU", "awebU") ; "Web"
  CIcon_Load("UndeadUnitsFiendU", "abur") ; "Burrow"/ "Unburrow"
  ; Crypt Fiend: Burrowed
  CIcon_Load("UndeadUnitsFiendBurrowed", "aburD") ; "Burrow"/ "Unburrow"
  ; Gargoyle
  CIcon_LoadUnit("UndeadUnitsGargoyle")
  CIcon_Load("UndeadUnitsGargoyle", "astn") ; "Stone Form"/ "Gargoyle Form"
  ; Gargoyle: Stoned
  CIcon_Load("UndeadUnitsGargoyleU", "astnD") ; "Stone Form"/ "Gargoyle Form"
  CIcon_Load("UndeadUnitsGargoyleU", "acmi") ; "Spell Immunity"
  ; Necromancer
  CIcon_LoadUnit("UndeadUnitsNecromancer")
  CIcon_Load("UndeadUnitsNecromancer", "arai") ; "Raise Dead"
  CIcon_Load("UndeadUnitsNecromancer", "auhf") ; "Unholy Frenzy"
  CIcon_Load("UndeadUnitsNecromancer", "acri") ; "Cripple"
  ; Necromancer: Auto-cast On
  CIcon_LoadUnit("UndeadUnitsNecromancerU")
  CIcon_Load("UndeadUnitsNecromancerU", "araiU") ; "Raise Dead"
  CIcon_Load("UndeadUnitsNecromancerU", "auhf") ; "Unholy Frenzy"
  CIcon_Load("UndeadUnitsNecromancerU", "acri") ; "Cripple"
  ; Banshee (ROC)
  CIcon_LoadUnit("UndeadUnitsBansheeRoc")
  CIcon_Load("UndeadUnitsBansheeRoc", "acrs") ; "Curse"
  CIcon_Load("UndeadUnitsBansheeRoc", "aams") ; "Anti-magic Shell"
  CIcon_Load("UndeadUnitsBansheeRoc", "apos") ; "Possession"
  ; Banshee (ROC): Auto-cast On
  CIcon_LoadUnit("UndeadUnitsBansheeRocU")
  CIcon_Load("UndeadUnitsBansheeRocU", "acrsU") ; "Curse"
  CIcon_Load("UndeadUnitsBansheeRocU", "aams") ; "Anti-magic Shell"
  CIcon_Load("UndeadUnitsBansheeRocU", "apos") ; "Possession"
  ; Banshee (TFT)
  CIcon_LoadUnit("UndeadUnitsBanshee")
  CIcon_Load("UndeadUnitsBanshee", "acrs") ; "Curse"
  CIcon_Load("UndeadUnitsBanshee", "aam2") ; "Anti-magic Shell"
  CIcon_Load("UndeadUnitsBanshee", "aps2") ; "Possession"
  ; Banshee (TFT): Auto-cast On
  CIcon_LoadUnit("UndeadUnitsBansheeU")
  CIcon_Load("UndeadUnitsBansheeU", "acrsU") ; "Curse"
  CIcon_Load("UndeadUnitsBansheeU", "aam2") ; "Anti-magic Shell"
  CIcon_Load("UndeadUnitsBansheeU", "aps2") ; "Possession"
  ; Meat Wagon
  CIcon_LoadUnitAttackGround("UndeadUnitsMeatWagon")
  CIcon_Load("UndeadUnitsMeatWagon", "amel") ; "Get Corpse"
  CIcon_Load("UndeadUnitsMeatWagon", "amed") ; "Drop All Corpses"
  CIcon_Load("UndeadUnitsMeatWagon", "apts") ; "Disease Cloud"
  CIcon_Load("UndeadUnitsMeatWagon", "aexh") ; "Exhume Corpses"
  ; Meat Wagon: Auto-cast On
  CIcon_LoadUnitAttackGround("UndeadUnitsMeatWagonU")
  CIcon_Load("UndeadUnitsMeatWagonU", "amelU") ; "Get Corpse"
  CIcon_Load("UndeadUnitsMeatWagonU", "amed") ; "Drop All Corpses"
  CIcon_Load("UndeadUnitsMeatWagonU", "apts") ; "Disease Cloud"
  CIcon_Load("UndeadUnitsMeatWagonU", "aexh") ; "Exhume Corpses"
  ; Abomination
  CIcon_LoadUnit("UndeadUnitsAbomination")
  CIcon_Load("UndeadUnitsAbomination", "acn2") ; "Cannibalize"
  CIcon_Load("UndeadUnitsAbomination", "aap1") ; "Disease Cloud"
  ; Obsidian Statue
  CIcon_LoadUnit("UndeadUnitsStatue")
  CIcon_Load("UndeadUnitsStatue", "arpl") ; "Essence of Blight"
  CIcon_Load("UndeadUnitsStatue", "arpm") ; "Spirit Touch"
  CIcon_Load("UndeadUnitsStatue", "ubsp") ; "Morph into Destroyer"
  ; Obsidian Statue: Auto-cast On
  CIcon_LoadUnit("UndeadUnitsStatueU")
  CIcon_Load("UndeadUnitsStatueU", "arplU") ; "Essence of Blight"
  CIcon_Load("UndeadUnitsStatueU", "arpmU") ; "Spirit Touch"
  CIcon_Load("UndeadUnitsStatueU", "ubsp") ; "Morph into Destroyer"
  ; Destroyer
  CIcon_LoadUnit("UndeadUnitsDestroyer")
  CIcon_Load("UndeadUnitsDestroyer", "acmi") ; "Spell Immunity"
  CIcon_Load("UndeadUnitsDestroyer", "advm") ; "Devour Magic"
  CIcon_Load("UndeadUnitsDestroyer", "afak") ; "Orb of Annihilation"
  CIcon_Load("UndeadUnitsDestroyer", "aabs") ; "Absorb Mana"
  ; Destroyer: Auto-cast On
  CIcon_LoadUnit("UndeadUnitsDestroyerU")
  CIcon_Load("UndeadUnitsDestroyerU", "acmi") ; "Spell Immunity"
  CIcon_Load("UndeadUnitsDestroyerU", "advm") ; "Devour Magic"
  CIcon_Load("UndeadUnitsDestroyerU", "afakU") ; "Orb of Annihilation"
  CIcon_Load("UndeadUnitsDestroyerU", "aabs") ; "Absorb Mana"
  ; Shade
  CIcon_LoadUnitNoAttack("UndeadUnitsShade")
  CIcon_Load("UndeadUnitsShade", "atru") ; "True Sight"
  ; Frost Wyrm
  CIcon_LoadUnit("UndeadUnitsFrostWyrm")
  CIcon_Load("UndeadUnitsFrostWyrm", "afrz") ; "Freezing Breath"
  
  ; Undead Heroes
  ; Death Knight
  CIcon_LoadHero("UndeadHeroesDeathKnight")
  CIcon_LoadHS("UndeadHeroesDeathKnight", "audc") ; "Death Coil"
  CIcon_LoadHS("UndeadHeroesDeathKnight", "audp") ; "Death Pact"
  CIcon_LoadHS("UndeadHeroesDeathKnight", "auau") ; "Unholy Aura"
  CIcon_LoadHS("UndeadHeroesDeathKnight", "auan") ; "Animate Dead"
  ; Dreadlord
  CIcon_LoadHero("UndeadHeroesDreadlord")
  CIcon_LoadHS("UndeadHeroesDreadlord", "aucs") ; "Carrion Swarm"
  CIcon_LoadHS("UndeadHeroesDreadlord", "ausl") ; "Sleep"
  CIcon_LoadHS("UndeadHeroesDreadlord", "auav") ; "Vampiric Aura"
  CIcon_LoadHS("UndeadHeroesDreadlord", "auin") ; "Inferno"
  ; Lich
  CIcon_LoadHero("UndeadHeroesLich")
  CIcon_LoadHS("UndeadHeroesLich", "aufn") ; "Frost Nova"
  CIcon_LoadHS("UndeadHeroesLich", "aufu") ; "Frost Armor"
  CIcon_LoadHS("UndeadHeroesLich", "audr") ; "Dark Ritual"
  CIcon_LoadHS("UndeadHeroesLich", "audd") ; "Death and Decay"
  ; Lich: Auto-cast On
  CIcon_LoadHeroNoCancel("UndeadHeroesLichU")
  CIcon_Load("UndeadHeroesLichU", "aufn") ; "Frost Nova"
  CIcon_Load("UndeadHeroesLichU", "aufuU") ; "Frost Armor"
  CIcon_Load("UndeadHeroesLichU", "audr") ; "Dark Ritual"
  CIcon_Load("UndeadHeroesLichU", "audd") ; "Death and Decay"
  ; Crypt Lord
  CIcon_LoadHero("UndeadHeroesCryptLord")
  CIcon_LoadHS("UndeadHeroesCryptLord", "auim") ; "Impale"
  CIcon_LoadHS("UndeadHeroesCryptLord", "auts") ; "Spiked Carapace"
  CIcon_LoadHS("UndeadHeroesCryptLord", "aucb") ; "Carrion Beetles"
  CIcon_LoadHS("UndeadHeroesCryptLord", "auls") ; "Locust Swarm"
  ; Crypt Lord: Auto-cast On
  CIcon_LoadHeroNoCancel("UndeadHeroesCryptLordU")
  CIcon_Load("UndeadHeroesCryptLordU", "auim") ; "Impale"
  CIcon_Load("UndeadHeroesCryptLordU", "auts") ; "Spiked Carapace"
  CIcon_Load("UndeadHeroesCryptLordU", "aucbU") ; "Carrion Beetles"
  CIcon_Load("UndeadHeroesCryptLordU", "auls") ; "Locust Swarm"

  ; Undead Hero Summons
  ; Infernal
  CIcon_LoadUnit("UndeadHeroSummonsInfernal") 
  CIcon_Load("UndeadHeroSummonsInfernal", "anpi") ; "Permanent Immolation"
  CIcon_Load("UndeadHeroSummonsInfernal", "acmi") ; "Spell Immunity"
  CIcon_Load("UndeadHeroSummonsInfernal", "acrk") ; "Resistant Skin"
  ; Carrion Beetle
  CIcon_LoadUnit("UndeadHeroSummonsBeetle")
  CIcon_Load("UndeadHeroSummonsBeetle", "abu2") ; "Burrow"/ "Unburrow"
  CIcon_Load("UndeadHeroSummonsBeetleU", "abu2D") ; "Burrow"/ "Unburrow"
  CIcon_LoadUnit("UndeadHeroSummonsBeetleThree")
  CIcon_Load("UndeadHeroSummonsBeetleThree", "abu3") ; "Burrow"/ "Unburrow"
  CIcon_Load("UndeadHeroSummonsBeetleThreeU", "abu3D") ; "Burrow"/ "Unburrow"
  
  ; Night Elf
  ; Night Elf Buildings
  ; Tree Uproot
  CIcon_LoadUnit("NightElfBuildingsTreeUproot")
  CIcon_Load("NightElfBuildingsTreeUproot", "aeat") ; "Eat Tree"
  CIcon_Load("NightElfBuildingsTreeUproot", "aro1") ; "Root"/ "Uproot"
  ; Tree of Life Uproot
  CIcon_LoadUnit("NightElfBuildingsTreeOfLifeUproot")
  CIcon_Load("NightElfBuildingsTreeOfLifeUproot", "aent") ; "Entangle Gold Mine"
  CIcon_Load("NightElfBuildingsTreeOfLifeUproot", "aeat") ; "Eat Tree"
  CIcon_Load("NightElfBuildingsTreeOfLifeUproot", "aro1") ; "Root"/ "Uproot"
  ; Ancient Protector Uprooted
  CIcon_LoadUnit("NightElfBuildingsAncientProtectorUproot")
  CIcon_Load("NightElfBuildingsAncientProtectorUproot", "aeat") ; "Eat Tree"
  CIcon_Load("NightElfBuildingsAncientProtectorUproot", "aro2") ; "Root"/ "Uproot"
  ; Entangled Gold Mine
  CIcon_Load("NightElfBuildingsEntangledGoldMine", "slo2") ; "Load Wisp"
  CIcon_Load("NightElfBuildingsEntangledGoldMine", "adri") ; "Unload All"
  ; Tree of Life
  CIcon_LoadBuilding("NightElfBuildingsTreeOfLife")
  CIcon_Load("NightElfBuildingsTreeOfLife", "ewsp") ; "Train Wisp"
  CIcon_Load("NightElfBuildingsTreeOfLife", "renb") ; "Research Nature's Blessing"
  CIcon_Load("NightElfBuildingsTreeOfLife", "repm") ; "Research Backpack"
  CIcon_Load("NightElfBuildingsTreeOfLife", "etoa") ; "Upgrade to Tree of Ages"
  CIcon_Load("NightElfBuildingsTreeOfLife", "aent") ; "Entangle Gold Mine"
  CIcon_Load("NightElfBuildingsTreeOfLife", "aro1D") ; "Root"/ "Uproot"
  ; Tree of Ages
  CIcon_LoadBuilding("NightElfBuildingsTreeOfAges")
  CIcon_Load("NightElfBuildingsTreeOfAges", "ewsp") ; "Train Wisp"
  CIcon_Load("NightElfBuildingsTreeOfAges", "renb") ; "Research Nature's Blessing"
  CIcon_Load("NightElfBuildingsTreeOfAges", "repm") ; "Research Backpack"
  CIcon_Load("NightElfBuildingsTreeOfAges", "etoe") ; "Upgrade to Tree of Eternity"
  CIcon_Load("NightElfBuildingsTreeOfAges", "aent") ; "Entangle Gold Mine"
  CIcon_Load("NightElfBuildingsTreeOfAges", "aro1D") ; "Root"/ "Uproot"
  ; Moon Well
  CIcon_Load("NightElfBuildingsMoonWell", "ambt") ; "Replenish Mana and Life"
  ; Moon Well: Auto-cast On
  CIcon_Load("NightElfBuildingsMoonWellU", "ambtU") ; "Replenish Mana and Life"
  ; Altar of Elders
  CIcon_LoadBuilding("NightElfBuildingsAltarOfElders")
  CIcon_Load("NightElfBuildingsAltarOfElders", "edem") ; "Demon Hunter"
  CIcon_Load("NightElfBuildingsAltarOfElders", "ekee") ; "Keeper of the Grove"
  CIcon_Load("NightElfBuildingsAltarOfElders", "emoo") ; "Priestess of the Moon"
  CIcon_Load("NightElfBuildingsAltarOfElders", "ewar") ; "Warden"
  ; Ancient of War
  CIcon_LoadBuilding("NightElfBuildingsAncientOfWar")
  CIcon_Load("NightElfBuildingsAncientOfWar", "earc") ; "Train Archer"
  CIcon_Load("NightElfBuildingsAncientOfWar", "esen") ; "Train Huntress"
  CIcon_Load("NightElfBuildingsAncientOfWar", "ebal") ; "Train Glaive Thrower"
  CIcon_Load("NightElfBuildingsAncientOfWar", "reib") ; "Research Improved Bows"
  CIcon_Load("NightElfBuildingsAncientOfWar", "resc") ; "Research Sentinel"
  CIcon_Load("NightElfBuildingsAncientOfWar", "remk") ; "Research Marksmanship"
  CIcon_Load("NightElfBuildingsAncientOfWar", "remg") ; "Upgrade Moon Glaive"
  CIcon_Load("NightElfBuildingsAncientOfWar", "repb") ; "Research Vopal Blades"
  CIcon_Load("NightElfBuildingsAncientOfWar", "aro1D") ; "Root"/ "Uproot"
  ; Hunter's Hall
  CIcon_Load("NightElfBuildingsHuntersHall", "cmdcancelbuild")
  CIcon_Load("NightElfBuildingsHuntersHall", "resm") ; "Upgrade to Strength of the Moon"
  CIcon_Load("NightElfBuildingsHuntersHall", "rema") ; "Upgrade to Moon Armor"
  CIcon_Load("NightElfBuildingsHuntersHall", "resw") ; "Upgrade to Strength of the Wild"
  CIcon_Load("NightElfBuildingsHuntersHall", "rerh") ; "Upgrade to Reinforced Hides"
  CIcon_Load("NightElfBuildingsHuntersHall", "reuv") ; "Research Ultravision"
  CIcon_Load("NightElfBuildingsHuntersHall", "rews") ; "Research Well Spring"
  ; Hunter's Hall 2
  CIcon_Load("NightElfBuildingsHuntersHallA", "cmdcancelbuild")
  CIcon_Load("NightElfBuildingsHuntersHallA", "resmA") ; "Upgrade to Strength of the Moon"
  CIcon_Load("NightElfBuildingsHuntersHallA", "remaA") ; "Upgrade to Moon Armor"
  CIcon_Load("NightElfBuildingsHuntersHallA", "reswA") ; "Upgrade to Strength of the Wild"
  CIcon_Load("NightElfBuildingsHuntersHallA", "rerhA") ; "Upgrade to Reinforced Hides"
  ; Hunter's Hall 3
  CIcon_Load("NightElfBuildingsHuntersHallB", "cmdcancelbuild")
  CIcon_Load("NightElfBuildingsHuntersHallB", "resmB") ; "Upgrade to Strength of the Moon"
  CIcon_Load("NightElfBuildingsHuntersHallB", "remaB") ; "Upgrade to Moon Armor"
  CIcon_Load("NightElfBuildingsHuntersHallB", "reswB") ; "Upgrade to Strength of the Wild"
  CIcon_Load("NightElfBuildingsHuntersHallB", "rerhB") ; "Upgrade to Reinforced Hides"
  ; Ancient of Lore
  CIcon_LoadBuilding("NightElfBuildingsAncientOfLore")
  CIcon_Load("NightElfBuildingsAncientOfLore", "edry") ; "Train Dryad"
  CIcon_Load("NightElfBuildingsAncientOfLore", "edoc") ; "Train Druid of the Claw"
  CIcon_Load("NightElfBuildingsAncientOfLore", "emtg") ; "Train Mountain Giant"
  CIcon_Load("NightElfBuildingsAncientOfLore", "resi") ; "Research Abolish Magic"
  CIcon_Load("NightElfBuildingsAncientOfLore", "reeb") ; "Research Mark of the Claw"
  CIcon_Load("NightElfBuildingsAncientOfLore", "redc") ; "Druid of the Claw Adept Training"
  CIcon_Load("NightElfBuildingsAncientOfLore", "rehs") ; "Research Hardened Skin"
  CIcon_Load("NightElfBuildingsAncientOfLore", "rers") ; "Research Resistant Skin"
  CIcon_Load("NightElfBuildingsAncientOfLore", "aro1D") ; "Root"/ "Uproot"
  ; Ancient of Lore 2
  CIcon_LoadBuilding("NightElfBuildingsAncientOfLoreA")
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "edry") ; "Train Dryad"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "edoc") ; "Train Druid of the Claw"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "emtg") ; "Train Mountain Giant"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "resi") ; "Research Abolish Magic"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "reeb") ; "Research Mark of the Claw"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "redcA") ; "Druid of the Claw Master Training"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "rehs") ; "Research Hardened Skin"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "rers") ; "Research Resistant Skin"
  CIcon_Load("NightElfBuildingsAncientOfLoreA", "aro1D") ; "Root"/ "Uproot"  ; Ancient of Wind
  ; Ancient of Wind
  CIcon_LoadBuilding("NightElfBuildingsAncientOfWind")
  CIcon_Load("NightElfBuildingsAncientOfWind", "ehip") ; "Train Hippogryph"
  CIcon_Load("NightElfBuildingsAncientOfWind", "edot") ; "Train Druid of the Talon"
  CIcon_Load("NightElfBuildingsAncientOfWind", "efdr") ; "Train Fairie Dragon"
  CIcon_Load("NightElfBuildingsAncientOfWind", "reht") ; "Research Hippogryph Taming"
  CIcon_Load("NightElfBuildingsAncientOfWind", "reec") ; "Research Mark of the Talon"
  CIcon_Load("NightElfBuildingsAncientOfWind", "redt") ; "Druid of the Talon Adept Training"
  CIcon_Load("NightElfBuildingsAncientOfWind", "aro1D") ; "Root"/ "Uproot"
  ; Ancient of Wind 2
  CIcon_LoadBuilding("NightElfBuildingsAncientOfWindA")
  CIcon_Load("NightElfBuildingsAncientOfWindA", "ehip") ; "Train Hippogryph"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "edot") ; "Train Druid of the Talon"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "efdr") ; "Train Fairie Dragon"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "reht") ; "Research Hippogryph Taming"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "reec") ; "Research Mark of the Talon"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "redtA") ; "Druid of the Talon Master Training"
  CIcon_Load("NightElfBuildingsAncientOfWindA", "aro1D") ; "Root"/ "Uproot"
  ; Chimaera Roost
  CIcon_LoadBuilding("NightElfBuildingsChimRoost")
  CIcon_Load("NightElfBuildingsChimRoost", "echm") ; "Train Chimaera"
  CIcon_Load("NightElfBuildingsChimRoost", "recb") ; "Research Corrosive Breath"
  ; Ancient of Wonders
  CIcon_Load("NightElfBuildingsAncientOfWonders", "moon") ; "Purchase Moonstone"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "plcl") ; "Purchase Lesser Clarity Potion"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "dust") ; "Purchase Dust of Appearance"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "spre") ; "Purchase Staff of Preservation"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "phea") ; "Purchase Potion of Healing"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "pman") ; "Purchase Potion of Mana"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "stwp") ; "Purchase Scroll of Town Portal"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "anei") ; Select User
  CIcon_Load("NightElfBuildingsAncientOfWonders", "oven") ; "Purchase Orb of Venom"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "pams") ; "Purchase Anti-magic Potion"
  CIcon_Load("NightElfBuildingsAncientOfWonders", "aro1D") ; "Root"/ "Uproot"
  ; Ancient Protector
  CIcon_Load("NightElfBuildingsAncientProtector", "cmdstop") ; "Stop"
  CIcon_Load("NightElfBuildingsAncientProtector", "cmdattack") ; "Attack"
  CIcon_Load("NightElfBuildingsAncientProtector", "aro2D") ; "Root"/ "Uproot"
  
  ; Night Elf Units
  ; Wisp
  CIcon_LoadUnit("NightElfUnitsWisp")
  CIcon_Load("NightElfUnitsWisp", "cmdbuildnightelf") ; "Create Building"
  CIcon_Load("NightElfUnitsWisp", "aren") ; "Renew"
  CIcon_Load("NightElfUnitsWisp", "adtn") ; "Detonate"
  CIcon_Load("NightElfUnitsWisp", "awha") ; "Gather"
  ; Wisp: Auto-cast On
  CIcon_LoadUnit("NightElfUnitsWispU")
  CIcon_Load("NightElfUnitsWispU", "cmdbuildnightelf") ; "Create Building"
  CIcon_Load("NightElfUnitsWispU", "arenU") ; "Renew"
  CIcon_Load("NightElfUnitsWispU", "adtn") ; "Detonate"
  CIcon_Load("NightElfUnitsWispU", "awha") ; "Gather"
  ; Wisp Build
  CIcon_Load("NightElfUnitsWispBuild", "etol") ; "Create Tree of Life"
  CIcon_Load("NightElfUnitsWispBuild", "eaom") ; "Create Ancient of War"
  CIcon_Load("NightElfUnitsWispBuild", "edob") ; "Create Hunter's Hall"
  CIcon_Load("NightElfUnitsWispBuild", "etrp") ; "Create Ancient Protectoor"
  CIcon_Load("NightElfUnitsWispBuild", "emow") ; "Create Moon Well"
  CIcon_Load("NightElfUnitsWispBuild", "eate") ; "Create Altar of Elders"
  CIcon_Load("NightElfUnitsWispBuild", "eaoe") ; "Create Ancient of Lore"
  CIcon_Load("NightElfUnitsWispBuild", "eaow") ; "Create Ancient of Wind"
  CIcon_Load("NightElfUnitsWispBuild", "edos") ; "Create Chimera Roost"
  CIcon_Load("NightElfUnitsWispBuild", "eden") ; "Create Ancient of Wonders"
  CIcon_Load("NightElfUnitsWispBuild", "cmdcancel")
  ; Archer
  CIcon_LoadUnit("NightElfUnitsArcher")
  CIcon_Load("NightElfUnitsArcher", "ashm") ; "Hide"
  CIcon_Load("NightElfUnitsArcher", "aco2") ; "Mount Hippogryph"
  CIcon_Load("NightElfUnitsArcher", "aegr") ; "Elune's Grace"
  ; Huntress
  CIcon_LoadUnit("NightElfUnitsHuntress")
  CIcon_Load("NightElfUnitsHuntress", "ashm") ; "Hide"
  CIcon_Load("NightElfUnitsHuntress", "aesn") ; "Sentinel"
  CIcon_Load("NightElfUnitsHuntress", "amgl") ; "Moon Glaive"
  ; Glaive Thrower
  CIcon_LoadUnitAttackGround("NightElfUnitsGlaiveThrower")
  CIcon_Load("NightElfUnitsGlaiveThrower", "aimp") ; "Vorpal Blades"
  ; Dryad
  CIcon_LoadUnit("NightElfUnitsDryad")
  CIcon_Load("NightElfUnitsDryad", "aadm") ; "Abolish Magic"
  CIcon_Load("NightElfUnitsDryad", "aspo") ; "Slow Poison"
  CIcon_Load("NightElfUnitsDryad", "amim") ; "Spell Immunity"
  ; Dryad: Auto-cast On
  CIcon_LoadUnit("NightElfUnitsDryadU")
  CIcon_Load("NightElfUnitsDryadU", "aadmU") ; "Abolish Magic"
  CIcon_Load("NightElfUnitsDryadU", "aspo") ; "Slow Poison"
  CIcon_Load("NightElfUnitsDryadU", "amim") ; "Spell Immunity"
  ; Druid of the Claw
  CIcon_LoadUnit("NightElfUnitsDruidClaw")
  CIcon_Load("NightElfUnitsDruidClaw", "aroa") ; "Roar"
  CIcon_Load("NightElfUnitsDruidClaw", "arej") ; ""
  CIcon_Load("NightElfUnitsDruidClaw", "abrf") ; "Bear Form"/ "Night Elf Form"
  ; Druid of the Claw: Bear
  CIcon_LoadUnit("NightElfUnitsDruidClawZ")
  CIcon_Load("NightElfUnitsDruidClawZ", "ara2") ; "Roar (in Bear Form)"
  CIcon_Load("NightElfUnitsDruidClawZ", "abrfD") ; "Bear Form"/ "Night Elf Form"
  ; Mountain Giant
  CIcon_LoadUnit("NightElfUnitsMtGiant")
  CIcon_Load("NightElfUnitsMtGiant", "atau") ; "Taunt"
  CIcon_Load("NightElfUnitsMtGiant", "agra") ; "War Club"
  CIcon_Load("NightElfUnitsMtGiant", "assk") ; "Hardened Skin"
  CIcon_Load("NightElfUnitsMtGiant", "arsk") ; "Resistant Skin"
  ; Hippogryph
  CIcon_LoadUnit("NightElfUnitsHippogryph")
  CIcon_Load("NightElfUnitsHippogryph", "aco3") ; "Pick up Archer"
  ; Hippogryph: with Archer
  CIcon_LoadUnit("NightElfUnitsHippogryphZ")
  CIcon_Load("NightElfUnitsHippogryphZ", "adec") ; "Pick up Archer"
  ; Druid of the Talon
  CIcon_LoadUnit("NightElfUnitsDruidTalon")
  CIcon_Load("NightElfUnitsDruidTalon", "afae") ; "Faerie Fire"
  CIcon_Load("NightElfUnitsDruidTalon", "acyc") ; "Cyclone"
  CIcon_Load("NightElfUnitsDruidTalon", "arav") ; "Storm Crow Form"
  ; Druid of the Talon: Auto-cast On/Storm Crow Form
  CIcon_LoadUnit("NightElfUnitsDruidTalonZ")
  CIcon_Load("NightElfUnitsDruidTalonZ", "afaeU") ; "Faerie Fire"
  CIcon_Load("NightElfUnitsDruidTalonZ", "aravD") ; "Storm Crow Form"
  ; Faerie Dragon
  CIcon_LoadUnit("NightElfUnitsFaerieDragon")
  CIcon_Load("NightElfUnitsFaerieDragon", "amim") ; "Spell Immunity"
  CIcon_Load("NightElfUnitsFaerieDragon", "apsh") ; "Phase Shift"
  CIcon_Load("NightElfUnitsFaerieDragon", "amfl") ; "Mana Flare"/ "Stop Mana Flare"
  ; Faerie Dragon
  CIcon_LoadUnit("NightElfUnitsFaerieDragonZ")
  CIcon_Load("NightElfUnitsFaerieDragonZ", "amim") ; "Spell Immunity"
  CIcon_Load("NightElfUnitsFaerieDragonZ", "apshU") ; "Phase Shift"
  CIcon_Load("NightElfUnitsFaerieDragonZ", "amflD") ; "Mana Flare"/ "Stop Mana Flare"
  ; Chimaera  
  CIcon_LoadUnit("NightElfUnitsChimaera")
  CIcon_Load("NightElfUnitsChimaera", "acor") ; "Corrosive Breath"

  ; Night Elf Heroes
  ; Demon Hunter
  CIcon_LoadHero("NightElfHeroesDemonHunter")
  CIcon_LoadHS("NightElfHeroesDemonHunter", "aemb") ; "Mana Burn"
  CIcon_LoadHS("NightElfHeroesDemonHunter", "aeim") ; "Activate Immolation"/ "Deactivate Immolation"
  CIcon_LoadHS("NightElfHeroesDemonHunter", "aeev") ; "Evasion"
  CIcon_LoadHS("NightElfHeroesDemonHunter", "aeme") ; "Metamorphosis"
  ; Demon Hunter: Immolation On
  CIcon_LoadHeroNoCancel("NightElfHeroesDemonHunterZ")
  CIcon_Load("NightElfHeroesDemonHunterZ", "aemb") ; "Mana Burn"
  CIcon_Load("NightElfHeroesDemonHunterZ", "aeimD") ; "Activate Immolation"/ "Deactivate Immolation"
  CIcon_Load("NightElfHeroesDemonHunterZ", "aeev") ; "Evasion"
  CIcon_Load("NightElfHeroesDemonHunterZ", "aeme") ; "Metamorphosis"
  ; Keeper of the Grove
  CIcon_LoadHero("NightElfHeroesKeeperGrove")
  CIcon_LoadHS("NightElfHeroesKeeperGrove", "aeer") ; "Entangling Roots"
  CIcon_LoadHS("NightElfHeroesKeeperGrove", "aefn") ; "Force of Nature"
  CIcon_LoadHS("NightElfHeroesKeeperGrove", "aeah") ; "Thorns Aura"
  CIcon_LoadHS("NightElfHeroesKeeperGrove", "aetq") ; "Tranquility"
  ; Priestess of the Moon
  CIcon_LoadHero("NightElfHeroesPriestessMoon")
  CIcon_LoadHS("NightElfHeroesPriestessMoon", "aest") ; "Scout"
  CIcon_LoadHS("NightElfHeroesPriestessMoon", "ahfa") ; "Searing Arrows"
  CIcon_LoadHS("NightElfHeroesPriestessMoon", "aear") ; "Trueshot Aura"
  CIcon_LoadHS("NightElfHeroesPriestessMoon", "aesf") ; "Starfall"
  ; Priestess of the Moon: Auto-cast On
  CIcon_LoadHeroNoCancel("NightElfHeroesPriestessMoonU")
  CIcon_Load("NightElfHeroesPriestessMoonU", "aest") ; "Scout"
  CIcon_Load("NightElfHeroesPriestessMoonU", "ahfaU") ; "Searing Arrows"
  CIcon_Load("NightElfHeroesPriestessMoonU", "aear") ; "Trueshot Aura"
  CIcon_Load("NightElfHeroesPriestessMoonU", "aesf") ; "Starfall"
  ; Warden
  CIcon_LoadHero("NightElfHeroesWarden")
  CIcon_LoadHS("NightElfHeroesWarden", "aefk") ; "Fan of Knives"
  CIcon_LoadHS("NightElfHeroesWarden", "aebl") ; "Blink"
  CIcon_LoadHS("NightElfHeroesWarden", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("NightElfHeroesWarden", "aesv") ; "Vengeance"
  
  ; Night Elf Hero Summons
  ; Owl Scout
  CIcon_LoadUnitNoAttack("NightElfHeroSummonsOwl")
  CIcon_Load("NightElfHeroSummonsOwl", "adtg") ; "True Sight"
  ; Avatar of Vengeance   
  CIcon_LoadUnit("NightElfHeroSummonsAvatar")
  CIcon_Load("NightElfHeroSummonsAvatar", "avng") ; "Spirit of Vengeance"
  ; Avatar of Vengeance: Auto-cast On 
  CIcon_LoadUnit("NightElfHeroSummonsAvatarU")
  CIcon_Load("NightElfHeroSummonsAvatarU", "avngU") ; "Spirit of Vengeance"

  ; Neutral
  ; Neutral Buildings
  ; Tavern
  CIcon_Load("NeutralBuildingsTavern","nngs") ; "Summon Naga Sea Witch"
  CIcon_Load("NeutralBuildingsTavern","nbrn") ; "Summon Dark Ranger"
  CIcon_Load("NeutralBuildingsTavern","npbm") ; "Summon Pandaren Brewmaster"
  CIcon_Load("NeutralBuildingsTavern","nfir") ; "Summon Firelord"
  CIcon_Load("NeutralBuildingsTavern","nplh") ; "Summon Pit Lord"
  CIcon_Load("NeutralBuildingsTavern","nbst") ; "Summon Beastmaster"
  CIcon_Load("NeutralBuildingsTavern","ntin") ; "Summon Tinker"
  CIcon_Load("NeutralBuildingsTavern","nalc") ; "Summon Alchemist"
  ; Goblin Merchant
  CIcon_Load("NeutralBuildingsMerchant", "bspd") ; "Purchase Boots of Speed"
  CIcon_Load("NeutralBuildingsMerchant", "prvt") ; "Purchase Periapt of Vitality"
  CIcon_Load("NeutralBuildingsMerchant", "cnob") ; "Purchase Circlet of Nobility"
  CIcon_Load("NeutralBuildingsMerchant", "dust") ; "Purchase Dust of Appearance"
  CIcon_Load("NeutralBuildingsMerchant", "spro") ; "Purchase Scroll of Protection"
  CIcon_Load("NeutralBuildingsMerchant", "pinv") ; "Purchase Potion of Invisibility"
  CIcon_Load("NeutralBuildingsMerchant", "stwp") ; "Purchase Scroll of Town Portal"
  CIcon_Load("NeutralBuildingsMerchant", "stel") ; "Purchase Staff of Teleportation"
  CIcon_Load("NeutralBuildingsMerchant", "tret") ; "Purchase Tome of Retraining"
  CIcon_Load("NeutralBuildingsMerchant", "shea") ; "Purchase Scroll of Healing"
  CIcon_Load("NeutralBuildingsMerchant", "pnvl") ; "Purchase Potion of Lesser Invulerability"
  CIcon_Load("NeutralBuildingsMerchant", "anei") ; Select User
  ; Goblin Laboratory
  CIcon_Load("NeutralBuildingsLaboratory", "andt") ; "Reveal"
  CIcon_Load("NeutralBuildingsLaboratory", "ngsp") ; "Hire Goblin Sapper"
  CIcon_Load("NeutralBuildingsLaboratory", "nzep") ; "Hire Goblin Zeppelin"
  CIcon_Load("NeutralBuildingsLaboratory", "ngir") ; "Hire Goblin Shredder"
  ; Mercenary Camp
  CIcon_Load("NeutralBuildingsMercCamp", "nfsp") ; "Hire Forest Troll Shadow Priest"
  CIcon_Load("NeutralBuildingsMercCamp", "nftb") ; "Hire Forest Troll Berserker"
  CIcon_Load("NeutralBuildingsMercCamp", "ngrk") ; "Summon Mud Golem"
  CIcon_Load("NeutralBuildingsMercCamp", "nogm") ; "Hire Ogre Mauler"
  ; Mercenary Camp (2)
  CIcon_Load("NeutralBuildingsMercCampTwo", "nkob") ; "Hire Kobold"
  CIcon_Load("NeutralBuildingsMercCampTwo", "nmrr") ; "Hire Murloc Huntsman"
  CIcon_Load("NeutralBuildingsMercCampTwo", "nass") ; "Hire Assassin"
  CIcon_Load("NeutralBuildingsMercCampTwo", "nkog") ; "Hire Kobold Geomancer"
  ; Mercenary Camp (3)
  CIcon_Load("NeutralBuildingsMercCampThree", "ncen") ; "Hire Centaur Outrunner"
  CIcon_Load("NeutralBuildingsMercCampThree", "nhrr") ; "Hire Harpy Rogue"
  CIcon_Load("NeutralBuildingsMercCampThree", "nhrw") ; "Hire Harpy Windwitch"
  CIcon_Load("NeutralBuildingsMercCampThree", "nrzm") ; "Hire Razormane Medicine Man"
    
  ; Neutral units
  ; Goblin Zeppelin
  CIcon_LoadUnit("NeutralUnitsZeppelin")
  CIcon_Load("NeutralUnitsZeppelin", "aloa") ; "Load"
  CIcon_Load("NeutralUnitsZeppelin", "adro") ; "Unload All"
  ; Goblin Sapper
  CIcon_LoadUnitNoAttack("NeutralUnitsSapper")
  CIcon_Load("NeutralUnitsSapper", "asds") ; "Kaboom!"
  ; Goblin Sapper (auto-cast on)
  CIcon_LoadUnitNoAttack("NeutralUnitsSapperU")
  CIcon_Load("NeutralUnitsSapperU", "asdsU") ; "Kaboom!"
  ; Goblin Shredder
  CIcon_LoadUnit("NeutralUnitsShredder")
  CIcon_Load("NeutralUnitsShredder", "ahr3") ; "Gather"
  ; Goblin Shredder: with Wood
  CIcon_LoadUnit("NeutralUnitsShredderZ")
  CIcon_Load("NeutralUnitsShredderZ", "ahr3D") ; "Return Resources"
  ; Forest Troll Shadow Priest
  CIcon_LoadUnit("NeutralUnitsShadowPriest")
  CIcon_Load("NeutralUnitsShadowPriest", "anh1") ; "Heal"
  CIcon_Load("NeutralUnitsShadowPriest", "acdm") ; "Abolish Magic"
  ; Forest Troll Shadow Priest (auto-cast on)
  CIcon_LoadUnit("NeutralUnitsShadowPriestU")
  CIcon_Load("NeutralUnitsShadowPriestU", "anh1U") ; "Heal"
  CIcon_Load("NeutralUnitsShadowPriestU", "acdmU") ; "Abolish Magic"
  ; Mud Golem
  CIcon_LoadUnit("NeutralUnitsMudGolem")
  CIcon_Load("NeutralUnitsMudGolem", "acsw") ; "Slow"
  CIcon_Load("NeutralUnitsMudGolem", "acmi") ; "Spell Immunity"
  ; Mud Golem (auto-cast on)
  CIcon_LoadUnit("NeutralUnitsMudGolemU")
  CIcon_Load("NeutralUnitsMudGolemU", "acswU") ; "Slow"
  CIcon_Load("NeutralUnitsMudGolemU", "acmi") ; "Spell Immunity"
  ; Murloc Huntsman
  CIcon_LoadUnit("NeutralUnitsHuntsman")
  CIcon_Load("NeutralUnitsHuntsman", "acen") ; "Ensnare"
  CIcon_Load("NeutralUnitsHuntsman", "acvs") ; "Envenomed Weapons"
  ; Assassin
  CIcon_LoadUnit("NeutralUnitsAssassin")
  CIcon_Load("NeutralUnitsAssassin", "ashm") ; Hide
  ; Kobold Geomancer
  CIcon_LoadUnit("NeutralUnitsGeomancer")
  CIcon_Load("NeutralUnitsGeomancer", "acd2") ; "Abolish Magic"
  CIcon_Load("NeutralUnitsGeomancer", "acs2") ; "Slow"
  ; Kobold Geomancer (auto-cast on)
  CIcon_LoadUnit("NeutralUnitsGeomancerU")
  CIcon_Load("NeutralUnitsGeomancerU", "acd2U") ; "Abolish Magic"
  CIcon_Load("NeutralUnitsGeomancerU", "acs2U") ; "Slow"
  ; Harp Wind witch
  CIcon_LoadUnit("NeutralUnitsWindwitch")
  CIcon_Load("NeutralUnitsWindwitch", "afa2") ; "Faerie Fire"
  ; Harp Wind witch (auto-cast on)
  CIcon_LoadUnit("NeutralUnitsWindwitchU")
  CIcon_Load("NeutralUnitsWindwitchU", "afa2U") ; "Faerie Fire"
  ; Razormane Medicine Man
  CIcon_LoadUnit("NeutralUnitsMedicineMan")
  CIcon_Load("NeutralUnitsMedicineMan", "achw") ; "Healing Ward"
  CIcon_Load("NeutralUnitsMedicineMan", "acsf") ; "Feral Spirit"
  ; Ice Revenant
  CIcon_LoadUnit("NeutralUnitsIceRevenant")
  CIcon_Load("NeutralUnitsIceRevenant", "acfn") ; "Frost Nova"
  CIcon_Load("NeutralUnitsIceRevenant", "acvp") ; "Vampiric Aura"
  ; Creeps
  ; Gnoll Overseer
  CIcon_LoadUnit("NeutralCreepsOverseer")
  CIcon_Load("NeutralCreepsOverseer", "acac") ; "Command Aura"
  ; Forest Troll High Priest
  CIcon_LoadUnit("NeutralCreepsHighPriest")
  CIcon_Load("NeutralCreepsHighPriest", "anh2") ; "Heal"
  CIcon_Load("NeutralCreepsHighPriest", "acd2") ; "Abolish Magic"
  CIcon_Load("NeutralCreepsHighPriest", "acif") ; "Inner Fire"
  ; Forest Troll High Priest (auto-cast on)
  CIcon_LoadUnit("NeutralCreepsHighPriestU")
  CIcon_Load("NeutralCreepsHighPriestU", "anh2U") ; "Heal"
  CIcon_Load("NeutralCreepsHighPriestU", "acd2U") ; "Abolish Magic"
  CIcon_Load("NeutralCreepsHighPriestU", "acifU") ; "Inner Fire"
    
  ;Neutral Heroes
  ;Beastmaster
  CIcon_LoadHero("NeutralHeroesBeastmaster")
  CIcon_LoadHS("NeutralHeroesBeastmaster", "ANsg")
  CIcon_LoadHS("NeutralHeroesBeastmaster", "ANsq")
  CIcon_LoadHS("NeutralHeroesBeastmaster", "ANsw")
  CIcon_LoadHS("NeutralHeroesBeastmaster", "ANst")
  ; DarkRanger
  CIcon_LoadHero("NeutralHeroesDarkRanger")
  CIcon_LoadHS("NeutralHeroesDarkRanger", "ansi") ; "Silence"
  CIcon_LoadHS("NeutralHeroesDarkRanger", "anba") ; "Black Arrow"
  CIcon_LoadHS("NeutralHeroesDarkRanger", "andr") ; "Life Drain"
  CIcon_LoadHS("NeutralHeroesDarkRanger", "anch") ; "Charm"
  ; DarkRanger auto-cast on
  CIcon_LoadHeroNoCancel("NeutralHeroesDarkRangerU")
  CIcon_Load("NeutralHeroesDarkRangerU", "ansi") ; "Silence"
  CIcon_Load("NeutralHeroesDarkRangerU", "anbaU") ; "Black Arrow"
  CIcon_Load("NeutralHeroesDarkRangerU", "andr") ; "Life Drain"
  CIcon_Load("NeutralHeroesDarkRangerU", "anch") ; "Charm"
  ; Naga Sea Witch
  CIcon_LoadHero("NeutralHeroesNagaSeaWitch")
  CIcon_LoadHS("NeutralHeroesNagaSeaWitch", "anfl") ; "Forked Lightening"
  CIcon_LoadHS("NeutralHeroesNagaSeaWitch", "anfa") ; "Frost Arrows"
  CIcon_LoadHS("NeutralHeroesNagaSeaWitch", "anms") ; "Mana Shield"
  CIcon_LoadHS("NeutralHeroesNagaSeaWitch", "anto") ; "Tornado"
  ; Naga Sea Witch auto-cast on
  CIcon_LoadHeroNoCancel("NeutralHeroesNagaSeaWitchU")
  CIcon_Load("NeutralHeroesNagaSeaWitchU", "anfl") ; "Forked Lightening"
  CIcon_Load("NeutralHeroesNagaSeaWitchU", "anfaU") ; "Frost Arrows"
  CIcon_Load("NeutralHeroesNagaSeaWitchU", "anmsD") ; "Mana Shield"
  CIcon_Load("NeutralHeroesNagaSeaWitchU", "anto") ; "Tornado"
  ; Pandaren Brewmaster
  CIcon_LoadHero("NeutralHeroesPandarenBrewmaster")
  CIcon_LoadHS("NeutralHeroesPandarenBrewmaster", "anbf") ; "Breath of Fire"
  CIcon_LoadHS("NeutralHeroesPandarenBrewmaster", "andh") ; "Drunken Haze"
  CIcon_LoadHS("NeutralHeroesPandarenBrewmaster", "andb") ; "Drunken Brawler"
  CIcon_LoadHS("NeutralHeroesPandarenBrewmaster", "anef") ; ?????
  ; Pit Lord
  CIcon_LoadHero("NeutralHeroesPitLord")
  CIcon_LoadHS("NeutralHeroesPitLord", "anrf") ; "Rain of Fire"
  CIcon_LoadHS("NeutralHeroesPitLord", "anht") ; "Howl of Terror"
  CIcon_LoadHS("NeutralHeroesPitLord", "anca") ; "Cleaving Attack"
  CIcon_LoadHS("NeutralHeroesPitLord", "ando") ; "Doom"
  ; Firelord
  CIcon_LoadHero("NeutralHeroesFirelord")
  CIcon_LoadHS("NeutralHeroesFirelord", "anso") ; "Soul Burn"
  CIcon_LoadHS("NeutralHeroesFirelord", "anlm") ; "Summon Lava Spawn"
  CIcon_LoadHS("NeutralHeroesFirelord", "ania") ; "Incinerate"
  CIcon_LoadHS("NeutralHeroesFirelord", "anvc") ; "Volcano"
  ; Firelord auto-cast on
  CIcon_LoadHeroNoCancel("NeutralHeroesFirelordU")
  CIcon_Load("NeutralHeroesFirelordU", "anso") ; "Soul Burn"
  CIcon_Load("NeutralHeroesFirelordU", "anlm") ; "Summon Lava Spawn"
  CIcon_Load("NeutralHeroesFirelordU", "aniaU") ; "Incinerate"
  CIcon_Load("NeutralHeroesFirelordU", "anvc") ; "Volcano"
  ; Alchemist
  CIcon_LoadHero("NeutralHeroesAlchemist")
  CIcon_LoadHS("NeutralHeroesAlchemist", "anhs") ; "Healing Spray"
  CIcon_LoadHS("NeutralHeroesAlchemist", "ancr") ; "Chemical Rage"
  CIcon_LoadHS("NeutralHeroesAlchemist", "anab") ; "Acid Bomb"
  CIcon_LoadHS("NeutralHeroesAlchemist", "antm") ; "Transmute"
  
  ; Tinker 0
  CIcon_LoadHero("NeutralHeroesTinker")
  CIcon_LoadHS("NeutralHeroesTinker", "ansy") ; "Pocket Factory"
  CIcon_LoadHS("NeutralHeroesTinker", "ancs") ; "Cluster Rockets"
  CIcon_LoadHS("NeutralHeroesTinker", "aneg") ; "Engineering Upgrade"
  CIcon_LoadHS("NeutralHeroesTinker", "anrg") ; "Robo-Goblin"
  ; Tinker Tank
  CIcon_LoadHeroNoCancel("NeutralHeroesTinkerU")
  CIcon_Load("NeutralHeroesTinkerU", "ansy") ; "Pocket Factory"
  CIcon_Load("NeutralHeroesTinkerU", "ancs") ; "Cluster Rockets"
  CIcon_Load("NeutralHeroesTinkerU", "aneg") ; "Engineering Upgrade"
  CIcon_Load("NeutralHeroesTinkerU", "anrgD") ; "Revert to Tinker Form"
  CIcon_Load("NeutralHeroesTinkerU", "ande")
  ; Tinker 1
  CIcon_LoadHero("NeutralHeroesTinkerE")
  CIcon_LoadHS("NeutralHeroesTinkerE", "ans1") ; "Pocket Factory"
  CIcon_LoadHS("NeutralHeroesTinkerE", "anc1") ; "Cluster Rockets"
  CIcon_LoadHS("NeutralHeroesTinkerE", "aneg") ; "Engineering Upgrade"
  CIcon_LoadHS("NeutralHeroesTinkerE", "ang1") ; "Robo-Goblin"
  ; Tinker Tank
  CIcon_LoadHeroNoCancel("NeutralHeroesTinkerEU")
  CIcon_Load("NeutralHeroesTinkerEU", "ans1") ; "Pocket Factory"
  CIcon_Load("NeutralHeroesTinkerEU", "anc1") ; "Cluster Rockets"
  CIcon_Load("NeutralHeroesTinkerEU", "aneg") ; "Engineering Upgrade"
  CIcon_Load("NeutralHeroesTinkerEU", "ang1D") ; "Revert to Tinker Form"
  CIcon_Load("NeutralHeroesTinkerEU", "and1")
  ; Tinker 2
  CIcon_LoadHero("NeutralHeroesTinkerEE")
  CIcon_LoadHS("NeutralHeroesTinkerEE", "ans2") ; "Pocket Factory"
  CIcon_LoadHS("NeutralHeroesTinkerEE", "anc2") ; "Cluster Rockets"
  CIcon_LoadHS("NeutralHeroesTinkerEE", "aneg") ; "Engineering Upgrade"
  CIcon_LoadHS("NeutralHeroesTinkerEE", "ang2") ; "Robo-Goblin"
  ; Tinker Tank
  CIcon_LoadHeroNoCancel("NeutralHeroesTinkerEEU")
  CIcon_Load("NeutralHeroesTinkerEEU", "ans2") ; "Pocket Factory"
  CIcon_Load("NeutralHeroesTinkerEEU", "anc2") ; "Cluster Rockets"
  CIcon_Load("NeutralHeroesTinkerEEU", "aneg") ; "Engineering Upgrade"
  CIcon_Load("NeutralHeroesTinkerEEU", "ang2D") ; "Revert to Tinker Form"
  CIcon_Load("NeutralHeroesTinkerEEU", "and2")
  ; Tinker 3
  CIcon_LoadHero("NeutralHeroesTinkerEEE")
  CIcon_LoadHS("NeutralHeroesTinkerEEE", "ans3") ; "Pocket Factory"
  CIcon_LoadHS("NeutralHeroesTinkerEEE", "anc3") ; "Cluster Rockets"
  CIcon_LoadHS("NeutralHeroesTinkerEEE", "aneg") ; "Engineering Upgrade"
  CIcon_LoadHS("NeutralHeroesTinkerEEE", "ang3") ; "Robo-Goblin"
  ; Tinker Tank
  CIcon_LoadHeroNoCancel("NeutralHeroesTinkerEEEU")
  CIcon_Load("NeutralHeroesTinkerEEEU", "ans3") ; "Pocket Factory"
  CIcon_Load("NeutralHeroesTinkerEEEU", "anc3") ; "Cluster Rockets"
  CIcon_Load("NeutralHeroesTinkerEEEU", "aneg") ; "Engineering Upgrade"
  CIcon_Load("NeutralHeroesTinkerEEEU", "ang3D") ; "Revert to Tinker Form"
  CIcon_Load("NeutralHeroesTinkerEEEU", "and3")

  ; Neutral Summons
  ; Panda Storm
  CIcon_LoadUnit("NeutralHeroSummonsStorm")
  CIcon_Load("NeutralHeroSummonsStorm", "acrk")
  CIcon_Load("NeutralHeroSummonsStorm", "adsm")
  CIcon_Load("NeutralHeroSummonsStorm", "accy")
  CIcon_Load("NeutralHeroSummonsStorm", "anwk")
  ; Panda Earth
  CIcon_LoadUnit("NeutralHeroSummonsEarth")
  CIcon_Load("NeutralHeroSummonsEarth", "acmi")
  CIcon_Load("NeutralHeroSummonsEarth", "acrk")
  CIcon_Load("NeutralHeroSummonsEarth", "acpv")
  CIcon_Load("NeutralHeroSummonsEarth", "anta")
  ; Panda Fire
  CIcon_LoadUnit("NeutralHeroSummonsFire")
  CIcon_Load("NeutralHeroSummonsFire", "acrk")
  CIcon_Load("NeutralHeroSummonsFire", "apig")
  ; Doom Guard
  CIcon_LoadUnit("NeutralHeroSummonsDoomGuard")
  CIcon_Load("NeutralHeroSummonsDoomGuard", "acsk")
  CIcon_Load("NeutralHeroSummonsDoomGuard", "adsm") ; "Dispel Magic"
  CIcon_Load("NeutralHeroSummonsDoomGuard", "awrs") ; "War Stomp"
  CIcon_Load("NeutralHeroSummonsDoomGuard", "accr") ; "Cripple"
  CIcon_Load("NeutralHeroSummonsDoomGuard", "acrf") ; "Rain of Fire"
  ; Bear
  CIcon_LoadUnit("NeutralHeroSummonsBear")
  CIcon_Load("NeutralHeroSummonsBear", "anbl") ; "Blink"
  CIcon_Load("NeutralHeroSummonsBear", "anbh") ; "Bash"
  ; Quilbeast
  CIcon_LoadUnit("NeutralHeroSummonsQuilbeast")
  CIcon_Load("NeutralHeroSummonsQuilbeast", "afzy") ; "Frenzy"
  ; Quilbeast (auto-cast on)
  CIcon_LoadUnit("NeutralHeroSummonsQuilbeastU")
  CIcon_Load("NeutralHeroSummonsQuilbeastU", "afzyU") ; "Frenzy"
  ; Hawk
  CIcon_LoadUnit("NeutralHeroSummonsHawk")
  CIcon_Load("NeutralHeroSummonsHawk", "antr") ; "True Sight"
  ; Clockwerk Goblin 0
  CIcon_LoadUnit("NeutralHeroSummonsClockwerk")
  CIcon_Load("NeutralHeroSummonsClockwerk", "asdg")    
  ; Clockwerk Goblin 0 (auto-cast on)
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkU")
  CIcon_Load("NeutralHeroSummonsClockwerkU", "asdgU")    
  ; Clockwerk Goblin 1
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkE")
  CIcon_Load("NeutralHeroSummonsClockwerkE", "asd1")    
  ; Clockwerk Goblin 1 (auto-cast on)
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkEU")
  CIcon_Load("NeutralHeroSummonsClockwerkEU", "asd1U")    
  ; Clockwerk Goblin 2
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkEE")
  CIcon_Load("NeutralHeroSummonsClockwerkEE", "asd2")    
  ; Clockwerk Goblin 2 (auto-cast on)
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkEEU")
  CIcon_Load("NeutralHeroSummonsClockwerkEEU", "asd2U")    
  ; Clockwerk Goblin 3
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkEEE")
  CIcon_Load("NeutralHeroSummonsClockwerkEEE", "asd3")    
  ; Clockwerk Goblin 3 (auto-cast on)
  CIcon_LoadUnit("NeutralHeroSummonsClockwerkEEEU")
  CIcon_Load("NeutralHeroSummonsClockwerkEEEU", "asd3U")
  
  ; Dota
  ; Dota Common
  ; Attribute Bonus
  CIcon_LoadUnit("DotaCommonUnits")
  CIcon_LoadHeroDota("DotaCommonHereos")
  ;CIcon_Load("DotaCommonAttributeBonusTwoL", "a0ajL") ; "Attribute Bonus"
  CIcon_Load("DotaCommonAttributeBonusTwoL", "a0nrL") ; "Attribute Bonus"
  CIcon_Load("DotaCommonAttributeBonusTwoL", "cmdcancel")
  ;CIcon_Load("DotaCommonAttributeBonusThreeL", "a04hL") ; "Attribute Bonus"
  ;CIcon_Load("DotaCommonAttributeBonusThreeL", "a0nrL") ; "Attribute Bonus"
  ;CIcon_Load("DotaCommonAttributeBonusThreeL", "cmdcancel")
  
  ; Morning Tavern Heroes
  ; Vengeful Spirit
  CIcon_LoadHeroDota("DotaMorningVengefulSpirit")
  CIcon_LoadHS("DotaMorningVengefulSpirit", "a02a") ; "Magic Missle"
  CIcon_LoadHS("DotaMorningVengefulSpirit", "a0ap") ; "Terror"
  ;CIcon_LoadHS("DotaMorningVengefulSpirit", "") ; "Command Aura"
  CIcon_LoadHS("DotaMorningVengefulSpirit", "a00g") ; "Nether Swap"
  ; Lord of Olympia
  CIcon_LoadHeroDota("DotaMorningLordOfOlympia")
  CIcon_LoadHS("DotaMorningLordOfOlympia", "a020") ; "Arc Lightning"
  CIcon_LoadHS("DotaMorningLordOfOlympia", "a006") ; "Lightning Bolt"
  CIcon_LoadHS("DotaMorningLordOfOlympia", "a0n5") ; "Static Field"
  CIcon_LoadHS("DotaMorningLordOfOlympia", "a07C") ; "Thundergod's Wrath"
  ; Lord of Olympia (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMorningLordOfOlympiaScepter")
  CIcon_LoadHS("DotaMorningLordOfOlympiaScepter", "a020") ; "Arc Lightning"
  CIcon_LoadHS("DotaMorningLordOfOlympiaScepter", "a006") ; "Lightning Bolt"
  CIcon_LoadHS("DotaMorningLordOfOlympiaScepter", "a0n5") ; "Static Field"
  CIcon_LoadHS("DotaMorningLordOfOlympiaScepter", "a06l") ; "Thundergod's Wrath"
  ; Enchantress
  CIcon_LoadHeroDota("DotaMorningEnchantress")
  CIcon_LoadHS("DotaMorningEnchantress", "a0dy") ; "Impetus"
  CIcon_LoadHS("DotaMorningEnchantress", "a0dx") ; "Enchant"
  CIcon_LoadHS("DotaMorningEnchantress", "a01b") ; "Nature's Attendants"
  CIcon_LoadHS("DotaMorningEnchantress", "a0dw") ; "Untouchable"
  ; Enchantress: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaMorningEnchantressU")
  CIcon_Load("DotaMorningEnchantressU", "a0dyU") ; "Impetus"
  CIcon_Load("DotaMorningEnchantressU", "a0dx") ; "Enchant"
  CIcon_Load("DotaMorningEnchantressU", "a01b") ; "Nature's Attendants"
  CIcon_Load("DotaMorningEnchantressU", "a0dw") ; "Untouchable"
  ; Morphling
  CIcon_LoadHeroDotaNoAttrib("DotaMorningMorphling")
  CIcon_LoadHS("DotaMorningMorphling", "a0fn") ; "Waveform"
  CIcon_LoadHS("DotaMorningMorphling", "a0g6") ; "Adaptive Strike"
  CIcon_LoadHS("DotaMorningMorphling", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphling", "a0kw") ; "Morph"
  CIcon_LoadHS("DotaMorningMorphling", "a0g8") ; "Replicate"
  CIcon_Load("DotaMorningMorphlingL", "a04hL") ; "Skillz"
  ; Morphling Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingU")
  CIcon_Load("DotaMorningMorphlingU", "a0fn") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingU", "a0g6") ; "Adaptive Strike"
  CIcon_Load("DotaMorningMorphlingU", "a0kxU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingU", "a0kwU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingU", "a0g8") ; "Replicate"
  ; Morphling
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingD")
  CIcon_Load("DotaMorningMorphlingD", "a0fn") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingD", "a0g6") ; "Adaptive Strike"
  CIcon_Load("DotaMorningMorphlingD", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingD", "a0kw") ; "Morph"
  CIcon_Load("DotaMorningMorphlingD", "a0gc") ; "Morph Replicate"
  /*
  ; Morphling Agility
  CIcon_LoadHeroDotaNoAttrib("DotaMorningMorphlingAgility")
  CIcon_LoadHS("DotaMorningMorphlingAgility", "a06j") ; "Waveform"
  CIcon_LoadHS("DotaMorningMorphlingAgility", "a0fm") ; "Morph Attack"
  CIcon_LoadHS("DotaMorningMorphlingAgility", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingAgility", "a0kw") ; "Morph"
  CIcon_LoadHS("DotaMorningMorphlingAgility", "a0f4") ; "Adapt"
  CIcon_Load("DotaMorningMorphlingAgilityL", "a04hL") ; "Skillz"
  ; Morphling (Agility) Blue Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingAgilityU")
  CIcon_Load("DotaMorningMorphlingAgilityU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingAgilityU", "a0fm") ; "Morph Attack"
  CIcon_Load("DotaMorningMorphlingAgilityU", "a0kxU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingAgilityU", "a0kw") ; "Morph"
  CIcon_Load("DotaMorningMorphlingAgilityU", "a0f4") ; "Adapt"
  ; Morphling (Agility) Green Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingAgilityUU")
  CIcon_Load("DotaMorningMorphlingAgilityUU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingAgilityUU", "a0fm") ; "Morph Attack"
  CIcon_Load("DotaMorningMorphlingAgilityUU", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingAgilityUU", "a0kwU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingAgilityUU", "a0f4") ; "Adapt"
  ; Morphling Intelligence
  CIcon_LoadHeroDotaNoAttrib("DotaMorningMorphlingIntelligence")
  CIcon_LoadHS("DotaMorningMorphlingIntelligence", "a06j") ; "Waveform"
  CIcon_LoadHS("DotaMorningMorphlingIntelligence", "a08j") ; "Crushing Wave"
  CIcon_LoadHS("DotaMorningMorphlingIntelligence", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingIntelligence", "a0kw") ; "Morph"
  CIcon_LoadHS("DotaMorningMorphlingIntelligence", "a0f4") ; "Adapt"
  CIcon_Load("DotaMorningMorphlingIntelligenceL", "a04hL") ; "Skillz"
  ; Morphling (Intelligence) Blue Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingIntelligenceU")
  CIcon_Load("DotaMorningMorphlingIntelligenceU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingIntelligenceU", "a08j") ; "Crushing Wave"
  CIcon_Load("DotaMorningMorphlingIntelligenceU", "a0kxU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingIntelligenceU", "a0kw") ; "Morph"
  CIcon_Load("DotaMorningMorphlingIntelligenceU", "a0f4") ; "Adapt"
  ; Morphling (Intelligence) Green Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingIntelligenceUU")
  CIcon_Load("DotaMorningMorphlingIntelligenceUU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingIntelligenceUU", "a08j") ; "Crushing Wave"
  CIcon_Load("DotaMorningMorphlingIntelligenceUU", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingIntelligenceUU", "a0kwU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingIntelligenceUU", "a0f4") ; "Adapt"
  ; Morphling Strength
  CIcon_LoadHeroDotaNoAttrib("DotaMorningMorphlingStrength")
  CIcon_LoadHS("DotaMorningMorphlingStrength", "a06j") ; "Waveform"
  CIcon_LoadHS("DotaMorningMorphlingStrength", "a0f6") ; "Unstable Power"
  CIcon_LoadHS("DotaMorningMorphlingStrength", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrength", "a0kw") ; "Morph"
  CIcon_LoadHS("DotaMorningMorphlingStrength", "a0f4") ; "Adapt"
  CIcon_Load("DotaMorningMorphlingStrengthL", "a04hL") ; "Skillz"
  ; Morphling Strength: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingStrengthUUU")
  CIcon_Load("DotaMorningMorphlingStrengthUUU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingStrengthUUU", "a0f6U") ; "Unstable Power"
  CIcon_Load("DotaMorningMorphlingStrengthUUU", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthUUU", "a0kw") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthUUU", "a0f4") ; "Adapt"
  ; Morphling (Strength) Blue Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingStrengthU")
  CIcon_Load("DotaMorningMorphlingStrengthU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingStrengthU", "a0f6") ; "Unstable Power"
  CIcon_Load("DotaMorningMorphlingStrengthU", "a0kxU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthU", "a0kw") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthU", "a0f4") ; "Adapt"
  ; Morphling (Strength) Green Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningMorphlingStrengthUU")
  CIcon_Load("DotaMorningMorphlingStrengthUU", "a06j") ; "Waveform"
  CIcon_Load("DotaMorningMorphlingStrengthUU", "a0f6") ; "Unstable Power"
  CIcon_Load("DotaMorningMorphlingStrengthUU", "a0kx") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthUU", "a0kwU") ; "Morph"
  CIcon_Load("DotaMorningMorphlingStrengthUU", "a0f4") ; "Adapt"
  */
  ; Crystal Maiden
  CIcon_LoadHeroDota("DotaMorningCrystalMaiden")
  CIcon_LoadHS("DotaMorningCrystalMaiden", "a01d") ; "Frost Nova"
  CIcon_LoadHS("DotaMorningCrystalMaiden", "a04c") ; "Frostbite"
  CIcon_LoadHS("DotaMorningCrystalMaiden", "ahab") ; "Brilliance Aura"
  CIcon_LoadHS("DotaMorningCrystalMaiden", "a03r") ; "Freezing Field"
  ; Crystal Maiden (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMorningCrystalMaidenScepter")
  CIcon_LoadHS("DotaMorningCrystalMaidenScepter", "a01d") ; "Frost Nova"
  CIcon_LoadHS("DotaMorningCrystalMaidenScepter", "a04c") ; "Frostbite"
  CIcon_LoadHS("DotaMorningCrystalMaidenScepter", "ahab") ; "Brilliance Aura"
  CIcon_LoadHS("DotaMorningCrystalMaidenScepter", "a0av") ; "Freezing Field"
  ; Rogueknight
  CIcon_LoadHeroDota("DotaMorningRogueknight")
  CIcon_LoadHS("DotaMorningRogueknight", "ahtb") ; "Storm Bolt"
  CIcon_LoadHS("DotaMorningRogueknight", "a01k") ; "Great Cleave"
  CIcon_LoadHS("DotaMorningRogueknight", "a01m") ; "Toughness Aura"
  CIcon_LoadHS("DotaMorningRogueknight", "a01h") ; "God Strength"
  ; Naga Siren
  CIcon_LoadHeroDota("DotaMorningNagaSiren")
  CIcon_LoadHS("DotaMorningNagaSiren", "a063") ; "Mirror Image"
  CIcon_LoadHS("DotaMorningNagaSiren", "a0ba") ; "Ensnare"
  CIcon_LoadHS("DotaMorningNagaSiren", "a00e") ; "Critical Strike"
  CIcon_LoadHS("DotaMorningNagaSiren", "a07u") ; "Song of the Siren"
  ; Earthshaker
  CIcon_LoadHeroDota("DotaMorningEarthshaker")
  CIcon_LoadHS("DotaMorningEarthshaker", "a0m0") ; "Fissure"
  CIcon_LoadHS("DotaMorningEarthshaker", "a0dl") ; "Enchant Totem"
  CIcon_LoadHS("DotaMorningEarthshaker", "a0dj") ; "Aftershock"
  CIcon_LoadHS("DotaMorningEarthshaker", "a0dh") ; "Echo Slam"
  ; Stealth Assassin
  CIcon_LoadHeroDota("DotaMorningStealthAssassin")
  CIcon_LoadHS("DotaMorningStealthAssassin", "a0e6") ; "Smoke Screen"
  CIcon_LoadHS("DotaMorningStealthAssassin", "a0k9") ; "Blink Strike"
  CIcon_LoadHS("DotaMorningStealthAssassin", "a0dz") ; "Backstab"
  CIcon_Load("DotaMorningStealthAssassin", "a0mb") ; "Permanent Invisibility"
  CIcon_Load("DotaMorningStealthAssassinL", "a00jL") ; "Permanent Invisibility"

  ; Lone Druid
  CIcon_LoadHeroDotaNoAttrib("DotaMorningLoneDruid")
  CIcon_LoadHS("DotaMorningLoneDruid", "a0a5") ; ""
  CIcon_LoadHS("DotaMorningLoneDruid", "a0aa") ; ""
  CIcon_LoadHS("DotaMorningLoneDruid", "a0a8") ; ""
  CIcon_LoadHS("DotaMorningLoneDruid", "a0ag") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidL", "a0nrL") ; "Skillz"
  ; Lone Druid: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidU")
  CIcon_Load("DotaMorningLoneDruidU", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidU", "a0aaU") ; ""
  CIcon_Load("DotaMorningLoneDruidU", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidU", "a0ag") ; "True Form"
  ; Lone Druid (True Form)
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidD")
  CIcon_Load("DotaMorningLoneDruidD", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidD", "a0aa") ; ""
  CIcon_Load("DotaMorningLoneDruidD", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidD", "a0agD") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidD", "a0ai") ; "Battle Cry"
  CIcon_Load("DotaMorningLoneDruidD", "a0a9") ; "One"
  ; Lone Druid
  CIcon_LoadHeroDotaNoAttrib("DotaMorningLoneDruidE")
  CIcon_LoadHS("DotaMorningLoneDruidE", "a0a5") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidE", "a0ab") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidE", "a0a8") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidE", "a0ag") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEL", "a0nrL") ; "Skillz"
  ; Lone Druid: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEU")
  CIcon_Load("DotaMorningLoneDruidEU", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEU", "a0abU") ; ""
  CIcon_Load("DotaMorningLoneDruidEU", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEU", "a0ag") ; "True Form"
  ; Lone Druid (True Form)
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidED")
  CIcon_Load("DotaMorningLoneDruidED", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidED", "a0ab") ; ""
  CIcon_Load("DotaMorningLoneDruidED", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidED", "a0agD") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidED", "a0ai") ; "Battle Cry"
  CIcon_Load("DotaMorningLoneDruidED", "a0a9") ; "One"
  ; Lone Druid
  CIcon_LoadHeroDotaNoAttrib("DotaMorningLoneDruidEE")
  CIcon_LoadHS("DotaMorningLoneDruidEE", "a0a5") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEE", "a0ac") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEE", "a0a8") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEE", "a0ag") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEEL", "a0nrL") ; "Skillz"
  ; Lone Druid: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEEU")
  CIcon_Load("DotaMorningLoneDruidEEU", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEEU", "a0acU") ; ""
  CIcon_Load("DotaMorningLoneDruidEEU", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEEU", "a0ag") ; "True Form"
  ; Lone Druid (True Form)
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEED")
  CIcon_Load("DotaMorningLoneDruidEED", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEED", "a0ac") ; ""
  CIcon_Load("DotaMorningLoneDruidEED", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEED", "a0agD") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEED", "a0ai") ; "Battle Cry"
  CIcon_Load("DotaMorningLoneDruidEED", "a0a9") ; "One"
  ; Lone Druid
  CIcon_LoadHeroDotaNoAttrib("DotaMorningLoneDruidEEE")
  CIcon_LoadHS("DotaMorningLoneDruidEEE", "a0a5") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEE", "a0ad") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEE", "a0a8") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEE", "a0ag") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEEEL", "a0nrL") ; "Skillz"
  ; Lone Druid: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEEEU")
  CIcon_Load("DotaMorningLoneDruidEEEU", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEU", "a0adU") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEU", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEU", "a0ag") ; "True Form"
  ; Lone Druid (True Form)
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEEED")
  CIcon_Load("DotaMorningLoneDruidEEED", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEEED", "a0ad") ; ""
  CIcon_Load("DotaMorningLoneDruidEEED", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEEED", "a0agD") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEEED", "a0ai") ; "Battle Cry"
  CIcon_Load("DotaMorningLoneDruidEEED", "a0a9") ; "One"
  ; Lone Druid
  CIcon_LoadHeroDotaNoAttrib("DotaMorningLoneDruidEEEE")
  CIcon_LoadHS("DotaMorningLoneDruidEEEE", "a0a5") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEEE", "a0ae") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEEE", "a0a8") ; ""
  CIcon_LoadHS("DotaMorningLoneDruidEEEE", "a0ag") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEEEEL", "a0nrL") ; "Skillz"
  ; Lone Druid: Auto-cast On
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEEEEU")
  CIcon_Load("DotaMorningLoneDruidEEEEU", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEEU", "a0aeU") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEEU", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEEU", "a0ag") ; "True Form"
  ; Lone Druid (True Form)
  CIcon_LoadHeroDotaNoAttribNoCancel("DotaMorningLoneDruidEEEED")
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0a5") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0ae") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0a8") ; ""
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0agD") ; "True Form"
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0ai") ; "Battle Cry"
  CIcon_Load("DotaMorningLoneDruidEEEED", "a0a9") ; "One"
  
  ; Spirit Bear
  CIcon_LoadUnit("DotaMorningSpiritBear")
  CIcon_Load("DotaMorningSpiritBear", "a0a0") ; "Entangle"
  CIcon_Load("DotaMorningSpiritBear", "a0a7") ; "Return"
  CIcon_Load("DotaMorningSpiritBear", "a0ah") ; "Demolish"
  ; Slayer
  CIcon_LoadHeroDota("DotaMorningSlayer")
  CIcon_LoadHS("DotaMorningSlayer", "a01f") ; "Dragon Slave"
  CIcon_LoadHS("DotaMorningSlayer", "a027") ; "Light Strike Array"
  CIcon_LoadHS("DotaMorningSlayer", "a001") ; "Ultimate"
  CIcon_LoadHS("DotaMorningSlayer", "a01p") ; "Laguna Blade"
  ; Slayer (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMorningSlayerScepter")
  CIcon_LoadHS("DotaMorningSlayerScepter", "a01f") ; "Dragon Slave"
  CIcon_LoadHS("DotaMorningSlayerScepter", "a027") ; "Light Strike Array"
  CIcon_LoadHS("DotaMorningSlayerScepter", "a001") ; "Ultimate"
  CIcon_LoadHS("DotaMorningSlayerScepter", "a09z") ; "Laguna Blade"
  ; Juggernaut
  CIcon_LoadHeroDota("DotaMorningJuggernaut")
  CIcon_LoadHS("DotaMorningJuggernaut", "a05g") ; "Blade Fury"
  CIcon_LoadHS("DotaMorningJuggernaut", "a047") ; "Healing Ward"
  CIcon_LoadHS("DotaMorningJuggernaut", "a00k") ; "Blade Dance"
  CIcon_LoadHS("DotaMorningJuggernaut", "a0m1") ; "Omnislash"
  
  ; Sunrise Tavern
  ; Silencer
  CIcon_LoadHeroDota("DotaSunriseSilencer")
  CIcon_LoadHS("DotaSunriseSilencer", "a0kd") ; "Curse of the Silent"
  CIcon_LoadHS("DotaSunriseSilencer", "a0lz") ; "Glaives of Wisdom"
  ;CIcon_CIconHSDota("", 8, "L", "Last Word", "BTNAcorn")
  CIcon_LoadHS("DotaSunriseSilencer", "a0l3") ; "Global Silence"
  ; Treant Protector
  CIcon_LoadHeroDota("DotaSunriseTreantProtector")
  CIcon_LoadHS("DotaSunriseTreantProtector", "a01z") ; "Nature's Guise"
  CIcon_LoadHS("DotaSunriseTreantProtector", "a01v") ; "Eyes in the Forest"
  CIcon_LoadHS("DotaSunriseTreantProtector", "a01u") ; "Living Armor"
  CIcon_LoadHS("DotaSunriseTreantProtector", "a07z") ; "Overgrowth"
  ; Enigma
  CIcon_LoadHeroDota("DotaSunriseEnigma")
  CIcon_LoadHS("DotaSunriseEnigma", "a0b3") ; "Malefice"
  CIcon_LoadHS("DotaSunriseEnigma", "a0b7") ; "Conversion"
  CIcon_LoadHS("DotaSunriseEnigma", "a0b1") ; "Midnight Pulse"
  CIcon_LoadHS("DotaSunriseEnigma", "a0by") ; "Black Hole"
  ; Keeper of the Light
  CIcon_LoadHeroDota("DotaSunriseKeeperOfLight")
  CIcon_LoadHS("DotaSunriseKeeperOfLight", "a085") ; "Illuminate"
  CIcon_LoadHS("DotaSunriseKeeperOfLight", "a07y") ; "Mana Leak"
  CIcon_LoadHS("DotaSunriseKeeperOfLight", "a07n") ; "Chakra Magic"
  CIcon_LoadHS("DotaSunriseKeeperOfLight", "a0mo") ; "Ignis Fatuus"
  ; Keeper of the Light (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaSunriseKeeperOfLightScepter")
  CIcon_LoadHS("DotaSunriseKeeperOfLightScepter", "a085") ; "Illuminate"
  CIcon_LoadHS("DotaSunriseKeeperOfLightScepter", "a07y") ; "Mana Leak"
  CIcon_LoadHS("DotaSunriseKeeperOfLightScepter", "a07n") ; "Chakra Magic"
  CIcon_LoadHS("DotaSunriseKeeperOfLightScepter", "a0eo") ; "Ignis Fatuus"
  ; Ignis Fatuus
  CIcon_LoadUnit("DotaSunriseIgnisFatuus")
  CIcon_Load("DotaSunriseIgnisFatuus", "a0dt") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuus", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuus", "apsh") ; "Phase Shift"
  ; Ignis Fatuus Auto cast
  CIcon_LoadUnit("DotaSunriseIgnisFatuusU")
  CIcon_Load("DotaSunriseIgnisFatuusU", "a0dtU") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuusU", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuusU", "apshU") ; "Phase Shift"
  ; Ignis Fatuus 2
  CIcon_LoadUnit("DotaSunriseIgnisFatuusTwo")
  CIcon_Load("DotaSunriseIgnisFatuusTwo", "a0do") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuusTwo", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuusTwo", "apsh") ; "Phase Shift"
  ; Ignis Fatuus 2 Auto cast
  CIcon_LoadUnit("DotaSunriseIgnisFatuusTwoU")
  CIcon_Load("DotaSunriseIgnisFatuusTwoU", "a0doU") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuusTwoU", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuusTwoU", "apshU") ; "Phase Shift"
  ; Ignis Fatuus 3
  CIcon_LoadUnit("DotaSunriseIgnisFatuusThree")
  CIcon_Load("DotaSunriseIgnisFatuusThree", "a0ds") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuusThree", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuusThree", "apsh") ; "Phase Shift"
  ; Ignis Fatuus 3 Auto cast
  CIcon_LoadUnit("DotaSunriseIgnisFatuusThreeU")
  CIcon_Load("DotaSunriseIgnisFatuusThreeU", "a0dsU") ; "Liberate Soul"
  CIcon_Load("DotaSunriseIgnisFatuusThreeU", "a07w") ; "Will O'"
  CIcon_Load("DotaSunriseIgnisFatuusThreeU", "apshU") ; "Phase Shift"  
  ; Liberated Soul
  CIcon_LoadUnit("DotaSunriseLiberatedSoul")
  CIcon_Load("DotaSunriseLiberatedSoul", "anh2") ; "Heal"
  CIcon_LoadUnit("DotaSunriseLiberatedSoulU")
  CIcon_Load("DotaSunriseLiberatedSoulU", "anh2U") ; "Heal"
  ; Ursa Warrior
  CIcon_LoadHeroDota("DotaSunriseUrsaWarrior")
  CIcon_LoadHS("DotaSunriseUrsaWarrior", "a03y") ; "Earthshock"
  CIcon_LoadHS("DotaSunriseUrsaWarrior", "a059") ; "Overpower"
  ;CIcon_CIconHSDotaN("", 8, "W", "Fury Swipes", "BTNAcorn")
  CIcon_LoadHS("DotaSunriseUrsaWarrior", "a0lc") ; "Enrage"

  ; Ogre Magi
  CIcon_LoadHeroDota("DotaSunriseOgreMagi")
  CIcon_LoadHS("DotaSunriseOgreMagi", "a04w") ; "Fireblast"
  CIcon_LoadHS("DotaSunriseOgreMagi", "a011") ; "Ignite"
  CIcon_LoadHS("DotaSunriseOgreMagi", "a083") ; "Bloodlust"
  CIcon_LoadHS("DotaSunriseOgreMagi", "a088") ; "Multi Cast"
  ; Ogre Magi: Auto-cast On
  CIcon_LoadHeroDota("DotaSunriseOgreMagiU")
  CIcon_Load("DotaSunriseOgreMagiU", "a04w") ; "Fireblast"
  CIcon_Load("DotaSunriseOgreMagiU", "a011") ; "Ignite"
  CIcon_Load("DotaSunriseOgreMagiU", "a083U") ; "Bloodlust"
  CIcon_Load("DotaSunriseOgreMagiU", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 1
  CIcon_LoadHeroDota("DotaSunriseOgreMagiE")
  CIcon_LoadHS("DotaSunriseOgreMagiE", "a089") ; "Fireblast"
  CIcon_LoadHS("DotaSunriseOgreMagiE", "a007") ; "Ignite"
  CIcon_LoadHS("DotaSunriseOgreMagiE", "a08f") ; "Bloodlust"
  CIcon_LoadHS("DotaSunriseOgreMagiE", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 1: Auto-cast On
  CIcon_LoadHeroDota("DotaSunriseOgreMagiEU")
  CIcon_Load("DotaSunriseOgreMagiEU", "a089") ; "Fireblast"
  CIcon_Load("DotaSunriseOgreMagiEU", "a007") ; "Ignite"
  CIcon_Load("DotaSunriseOgreMagiEU", "a08fU") ; "Bloodlust"
  CIcon_Load("DotaSunriseOgreMagiEU", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 2
  CIcon_LoadHeroDota("DotaSunriseOgreMagiEE")
  CIcon_LoadHS("DotaSunriseOgreMagiEE", "a08a") ; "Fireblast"
  CIcon_LoadHS("DotaSunriseOgreMagiEE", "a01t") ; "Ignite"
  CIcon_LoadHS("DotaSunriseOgreMagiEE", "a08g") ; "Bloodlust"
  CIcon_LoadHS("DotaSunriseOgreMagiEE", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 2: Auto-cast On
  CIcon_LoadHeroDota("DotaSunriseOgreMagiEEU")
  CIcon_Load("DotaSunriseOgreMagiEEU", "a08a") ; "Fireblast"
  CIcon_Load("DotaSunriseOgreMagiEEU", "a01t") ; "Ignite"
  CIcon_Load("DotaSunriseOgreMagiEEU", "a08gU") ; "Bloodlust"
  CIcon_Load("DotaSunriseOgreMagiEEU", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 3 
  CIcon_LoadHeroDota("DotaSunriseOgreMagiEEE")
  CIcon_LoadHS("DotaSunriseOgreMagiEEE", "a08d") ; "Fireblast"
  CIcon_LoadHS("DotaSunriseOgreMagiEEE", "a00f") ; "Ignite"
  CIcon_LoadHS("DotaSunriseOgreMagiEEE", "a08i") ; "Bloodlust"
  CIcon_LoadHS("DotaSunriseOgreMagiEEE", "a088") ; "Multi Cast"
  ; Ogre Magi: Multi Cast Level 3: Auto-cast On
  CIcon_LoadHeroDota("DotaSunriseOgreMagiEEEU")
  CIcon_Load("DotaSunriseOgreMagiEEEU", "a08d") ; "Fireblast"
  CIcon_Load("DotaSunriseOgreMagiEEEU", "a00f") ; "Ignite"
  CIcon_Load("DotaSunriseOgreMagiEEEU", "a08iU") ; "Bloodlust"
  CIcon_Load("DotaSunriseOgreMagiEEEU", "a088") ; "Multi Cast"

  ; Tinker
  CIcon_LoadHeroDota("DotaSunriseTinker")
  CIcon_LoadHS("DotaSunriseTinker", "a049") ; "Laser"
  CIcon_LoadHS("DotaSunriseTinker", "a05e") ; "Heat Seeking Missle"
  CIcon_LoadHS("DotaSunriseTinker", "a0bq") ; "March of the Machines"
  CIcon_LoadHS("DotaSunriseTinker", "a065") ; "Rearm"
  ; Prophet
  CIcon_LoadHeroDota("DotaSunriseProphet")
  CIcon_LoadHS("DotaSunriseProphet", "a06q") ; "Sprout"
  CIcon_LoadHS("DotaSunriseProphet", "a01o") ; "Teleportation"
  CIcon_LoadHS("DotaSunriseProphet", "aefn") ; "Force of Nature"
  CIcon_LoadHS("DotaSunriseProphet", "a07x") ; "Wrath of Nature"
  ; Prophet Scepter
  CIcon_LoadHeroDota("DotaSunriseProphetScepter")
  CIcon_LoadHS("DotaSunriseProphetScepter", "a06q") ; "Sprout"
  CIcon_LoadHS("DotaSunriseProphetScepter", "a01o") ; "Teleportation"
  CIcon_LoadHS("DotaSunriseProphetScepter", "aefn") ; "Force of Nature"
  CIcon_LoadHS("DotaSunriseProphetScepter", "a0al") ; "Wrath of Nature"
  ; Phantom Lancer
  CIcon_LoadHeroDota("DotaSunrisePhantomLancer")
  CIcon_LoadHS("DotaSunrisePhantomLancer", "a0da") ; "Spirit Lance"
  CIcon_LoadHS("DotaSunrisePhantomLancer", "a0d7") ; "Dopplewalk"
  CIcon_LoadHS("DotaSunrisePhantomLancer", "a0db") ; "Juxtapose"
  CIcon_LoadHS("DotaSunrisePhantomLancer", "a0d9") ; "Phantom Edge"
  ; Stone Giant
  CIcon_LoadHeroDota("DotaSunriseStoneGiant")
  CIcon_LoadHS("DotaSunriseStoneGiant", "a0ll") ; "Avalanche"
  CIcon_LoadHS("DotaSunriseStoneGiant", "a0bz") ; "Toss"
  CIcon_LoadHS("DotaSunriseStoneGiant", "a0bu") ; "Craggy Exterior"
  CIcon_LoadHS("DotaSunriseStoneGiant", "a0cy") ; "Grow!"
  ; Goblin Techies
  CIcon_LoadHeroDota("DotaSunriseGoblinTechies")
  CIcon_LoadHS("DotaSunriseGoblinTechies", "a05j") ; "Land Mines"
  CIcon_LoadHS("DotaSunriseGoblinTechies", "a06h") ; "Stasis Trap"
  ;CIcon_CIconHSDotaU("", 8, "C", "Suicide Squad, Attack!", "BTNAcorn")
  CIcon_LoadHS("DotaSunriseGoblinTechies", "a0ak") ; "Remote Mines"
  CIcon_Load("DotaSunriseGoblinTechies", "a02t") ; "Detonates all remote mines."
  ; Remote Mine
  CIcon_Load("DotaSunriseRemoteMine", "a0am") ; "Detonate"
  CIcon_Load("DotaSunriseRemoteMine", "acmi") ; "Spell Immunity"
  ; Holy Knight
  CIcon_LoadHeroDota("DotaSunriseHolyKnight")
  CIcon_LoadHS("DotaSunriseHolyKnight", "a0km") ; "Penitence"
  CIcon_LoadHS("DotaSunriseHolyKnight", "a0lv") ; "Test of Faith"
  CIcon_LoadHS("DotaSunriseHolyKnight", "a069") ; "Holy Persuasion"
  CIcon_LoadHS("DotaSunriseHolyKnight", "a0lt") ; "Hand of God"

  ; Tavern Heroes
  ; Moon Rider
  CIcon_LoadHeroDota("DotaTavernMoonRider")
  CIcon_LoadHS("DotaTavernMoonRider", "a042") ; "Lucent Beam"
  CIcon_LoadHS("DotaTavernMoonRider", "a041") ; "Moon Glaive"
  CIcon_LoadHS("DotaTavernMoonRider", "a062") ; "Lunar Blessing"
  CIcon_LoadHS("DotaTavernMoonRider", "a054") ; "Eclipse"
  ; Moon Rider (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaTavernMoonRiderScepter")
  CIcon_LoadHS("DotaTavernMoonRiderScepter", "a042") ; "Lucent Beam"
  CIcon_LoadHS("DotaTavernMoonRiderScepter", "a041") ; "Moon Glaive"
  CIcon_LoadHS("DotaTavernMoonRiderScepter", "a062") ; "Lunar Blessing"
  CIcon_LoadHS("DotaTavernMoonRiderScepter", "a00u") ; "Eclipse"
  ; Dwarven Sniper
  CIcon_LoadHeroDota("DotaTavernDwarvenSniper")
  CIcon_LoadHS("DotaTavernDwarvenSniper", "A064") ; "Scatter Shot"
  CIcon_LoadHS("DotaTavernDwarvenSniper", "A03S") ; "Headshot"
  CIcon_LoadHS("DotaTavernDwarvenSniper", "A03U") ; "Take Aim"
  CIcon_LoadHS("DotaTavernDwarvenSniper", "A04P") ; "Assassinate"
  ; Troll Warlord
  CIcon_LoadHeroDota("DotaTavernTrollWarlord")
  CIcon_LoadHS("DotaTavernTrollWarlord", "a0be") ; "Berserker Rage"
  CIcon_LoadHS("DotaTavernTrollWarlord", "a0bc") ; "Blind"
  CIcon_LoadHS("DotaTavernTrollWarlord", "a0bd") ; "Fervor"
  CIcon_LoadHS("DotaTavernTrollWarlord", "a0bb") ; "Rampage"
  ; Troll Warlord: Skills Active
  CIcon_LoadHeroDotaNoCancel("DotaTavernTrollWarlordD")
  CIcon_LoadHS("DotaTavernTrollWarlordD", "a0beD") ; "Berserker Rage"
  CIcon_LoadHS("DotaTavernTrollWarlordD", "a0bc") ; "Blind"
  CIcon_LoadHS("DotaTavernTrollWarlordD", "a0bd") ; "Fervor"
  CIcon_LoadHS("DotaTavernTrollWarlordD", "a0bb") ; "Rampage"
  CIcon_LoadHS("DotaTavernTrollWarlordD", "a09e") ; "Bash"
  ; Shadow Shaman
  CIcon_LoadHeroDota("DotaTavernShadowShaman")
  CIcon_LoadHS("DotaTavernShadowShaman", "a010") ; "Forked Lightning"
  CIcon_LoadHS("DotaTavernShadowShaman", "a0mn") ; "Voodoo"
  CIcon_LoadHS("DotaTavernShadowShaman", "a00p") ; "Shackles"
  CIcon_LoadHS("DotaTavernShadowShaman", "a00h") ; "Mass Serpent Ward"
  ; Shadow Shaman (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaTavernShadowShamanScepter")
  CIcon_LoadHS("DotaTavernShadowShamanScepter", "a010") ; "Forked Lightning"
  CIcon_LoadHS("DotaTavernShadowShamanScepter", "a0mn") ; "Voodoo"
  CIcon_LoadHS("DotaTavernShadowShamanScepter", "a00p") ; "Shackles"
  CIcon_LoadHS("DotaTavernShadowShamanScepter", "a0a1") ; "Mass Serpent Ward"
  ; Bristleback
  CIcon_LoadHeroDota("DotaTavernBristleback")
  CIcon_LoadHS("DotaTavernBristleback", "a0fw") ; "Viscous Nasal Goo"
  CIcon_LoadHS("DotaTavernBristleback", "a0fx") ; "Quill Spray"
  CIcon_LoadHS("DotaTavernBristleback", "a0m3") ; "Bristleback"
  CIcon_LoadHS("DotaTavernBristleback", "a0fv") ; "Warpath"
  ; Pandaren Battlemaster
  CIcon_LoadHeroDota("DotaTavernPandarenBattlemaster")
  CIcon_LoadHS("DotaTavernPandarenBattlemaster", "a06m") ; "Thunder Clap"
  CIcon_LoadHS("DotaTavernPandarenBattlemaster", "acdh") ; "Drunken Haze"
  CIcon_LoadHS("DotaTavernPandarenBattlemaster", "a0mx") ; "Battlemastery"
  CIcon_LoadHS("DotaTavernPandarenBattlemaster", "a0mq") ; "Primal Split"
  ; Panda Storm
  CIcon_LoadUnit("DotaTavernStorm")
  CIcon_Load("DotaTavernStorm", "acrk")
  CIcon_Load("DotaTavernStorm", "adsm")
  CIcon_Load("DotaTavernStorm", "accy")
  CIcon_Load("DotaTavernStorm", "anwk")
  ; Panda Earth
  CIcon_LoadUnit("DotaTavernEarth")
  CIcon_Load("DotaTavernEarth", "acmi")
  CIcon_Load("DotaTavernEarth", "acrk")
  CIcon_Load("DotaTavernEarth", "acpv")
  CIcon_Load("DotaTavernEarth", "anta")
  ; Panda Fire
  CIcon_LoadUnit("DotaTavernFire")
  CIcon_Load("DotaTavernFire", "acrk")
  CIcon_Load("DotaTavernFire", "apig")
  ; Centaur Warchief
  CIcon_LoadHeroDota("DotaTavernCentaurWarchief")
  CIcon_LoadHS("DotaTavernCentaurWarchief", "a00s") ; "Hoof Stomp"
  CIcon_LoadHS("DotaTavernCentaurWarchief", "a00l") ; "Double Edge"
  CIcon_LoadHS("DotaTavernCentaurWarchief", "a00v") ; "Return"
  CIcon_LoadHS("DotaTavernCentaurWarchief", "a01l") ; "Great Fortitude"
  ; Bounty Hunter
  CIcon_LoadHeroDota("DotaTavernBountyHunter")
  CIcon_LoadHS("DotaTavernBountyHunter", "a004") ; "Shuriken Toss"
  CIcon_LoadHS("DotaTavernBountyHunter", "a000") ; "Jinda"
  CIcon_LoadHS("DotaTavernBountyHunter", "a07a") ; "Wind Walk"
  CIcon_LoadHS("DotaTavernBountyHunter", "a0b4") ; "Track"
  ; Dragon Knight
  CIcon_LoadHeroDota("DotaTavernDragonKnight")
  CIcon_LoadHS("DotaTavernDragonKnight", "a03f") ; "Breathe Fire"
  CIcon_LoadHS("DotaTavernDragonKnight", "a0ar") ; "Dragon Tail"
  CIcon_LoadHS("DotaTavernDragonKnight", "a0cl") ; "Dragon Blood"
  CIcon_LoadHS("DotaTavernDragonKnight", "a03g") ; "Elder Dragon Form"
  CIcon_LoadHS("DotaTavernDragonKnight", "a07d") ; "Corrosive Attack"
  ; Anti-Mage
  CIcon_LoadHeroDota("DotaTavernAntiMage")
  CIcon_LoadHS("DotaTavernAntiMage", "a022") ; "Mana Break"
  CIcon_LoadHS("DotaTavernAntiMage", "aebl") ; "Blink"
  CIcon_LoadHS("DotaTavernAntiMage", "a0ky") ; "Spell Shield"
  CIcon_LoadHS("DotaTavernAntiMage", "a0e3") ; "Mana Void"
  ; Drow Ranger
  CIcon_LoadHeroDota("DotaTavernDrowRanger")
  CIcon_LoadHS("DotaTavernDrowRanger", "a026") ; "Frost Arrows"
  CIcon_LoadHS("DotaTavernDrowRanger", "ansi") ; "Silence"
  CIcon_LoadHS("DotaTavernDrowRanger", "a029") ; "True Shot Aura"
  CIcon_LoadHS("DotaTavernDrowRanger", "a056") ; "Marksmanship"
  ; Drow Ranger: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaTavernDrowRangerU")
  CIcon_Load("DotaTavernDrowRangerU", "a026U") ; "Frost Arrows"
  CIcon_Load("DotaTavernDrowRangerU", "ansi") ; "Silence"
  CIcon_Load("DotaTavernDrowRangerU", "a029") ; "True Shot Aura"
  CIcon_Load("DotaTavernDrowRangerU", "a056") ; "Marksmanship"
  ; Omniknight
  CIcon_LoadHeroDota("DotaTavernOmniknight")
  CIcon_LoadHS("DotaTavernOmniknight", "a08n") ; "Purification"
  CIcon_LoadHS("DotaTavernOmniknight", "a08v") ; "Repel"
  CIcon_LoadHS("DotaTavernOmniknight", "a06a") ; "Degen Aura"
  CIcon_LoadHS("DotaTavernOmniknight", "a0er") ; "Guardian Angel"

  ; Dawn Tavern
  ; Beastmaster
  CIcon_LoadHeroDota("DotaDawnBeastmaster")
  CIcon_LoadHS("DotaDawnBeastmaster", "a0o1") ; "Wild Axes"
  CIcon_LoadHS("DotaDawnBeastmaster", "a0oo") ; "Call of the Wild"
  CIcon_LoadHS("DotaDawnBeastmaster", "a0o0") ; "Beast Rage"
  CIcon_LoadHS("DotaDawnBeastmaster", "a0o2") ; "Primal Roar"
  ; Twin Head Dragon
  CIcon_LoadHeroDota("DotaDawnTwinHeadDragon")
  CIcon_LoadHS("DotaDawnTwinHeadDragon", "a0o7") ; "Dual Breath"
  CIcon_LoadHS("DotaDawnTwinHeadDragon", "a0o6") ; "Ice Path"
  CIcon_LoadHS("DotaDawnTwinHeadDragon", "a0o8") ; "Auto Fire"
  CIcon_LoadHS("DotaDawnTwinHeadDragon", "a0o5") ; "Macropyre"

  ; Midnight Tavern
  ; Soul Keeper
  CIcon_LoadHeroDota("DotaMidnightSoulKeeper")
  CIcon_LoadHS("DotaMidnightSoulKeeper", "a04L") ; "Soul Steal"
  CIcon_LoadHS("DotaMidnightSoulKeeper", "a0h4") ; "Conjure Image"
  CIcon_LoadHS("DotaMidnightSoulKeeper", "a0mv") ; "Metamorphosis"
  CIcon_LoadHS("DotaMidnightSoulKeeper", "a07q") ; "Sunder"
  ; Tormented Soul
  CIcon_LoadHeroDota("DotaMidnightTormentedSoul")
  CIcon_LoadHS("DotaMidnightTormentedSoul", "a06w") ; "Split Earth"
  CIcon_LoadHS("DotaMidnightTormentedSoul", "a035") ; "Diablolic Edict"
  CIcon_LoadHS("DotaMidnightTormentedSoul", "a06v") ; "Lightning Storm"
  CIcon_LoadHS("DotaMidnightTormentedSoul", "a06x") ; "Activate Pulse Nova"
  ; Tormented Soul: Skills Active
  CIcon_LoadHeroDotaNoCancel("DotaMidnightTormentedSoulD")
  CIcon_Load("DotaMidnightTormentedSoulD", "a06w") ; "Split Earth"
  CIcon_Load("DotaMidnightTormentedSoulD", "a035") ; "Diablolic Edict"
  CIcon_Load("DotaMidnightTormentedSoulD", "a06v") ; "Lightning Storm"
  CIcon_Load("DotaMidnightTormentedSoulD", "a06xD") ; "Deactivate Pulse Nova"
  ; Tormented Soul (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMidnightTormentedSoulScepter")
  CIcon_LoadHS("DotaMidnightTormentedSoulScepter", "a06w") ; "Split Earth"
  CIcon_LoadHS("DotaMidnightTormentedSoulScepter", "a035") ; "Diablolic Edict"
  CIcon_LoadHS("DotaMidnightTormentedSoulScepter", "a06v") ; "Lightning Storm"
  CIcon_LoadHS("DotaMidnightTormentedSoulScepter", "a0aq") ; "Pulse Nova (Aghanim's Scepter)"
  ; Tormented Soul (Aghanim's Scepter): Skills Active
  CIcon_LoadHeroDotaNoCancel("DotaMidnightTormentedSoulScepterD")
  CIcon_Load("DotaMidnightTormentedSoulScepterD", "a06w") ; "Split Earth"
  CIcon_Load("DotaMidnightTormentedSoulScepterD", "a035") ; "Diablolic Edict"
  CIcon_Load("DotaMidnightTormentedSoulScepterD", "a06v") ; "Lightning Storm"
  CIcon_Load("DotaMidnightTormentedSoulScepterD", "a0aqD") ; "Deactivate Pulse Nova"
  ; Lich
  CIcon_LoadHeroDota("DotaMidnightLich")
  CIcon_LoadHS("DotaMidnightLich", "a07f") ; "Frost Nova"
  CIcon_LoadHS("DotaMidnightLich", "a08r") ; "Frost Armor"
  CIcon_LoadHS("DotaMidnightLich", "a053") ; "Dark Ritual"
  CIcon_LoadHS("DotaMidnightLich", "a05t") ; "Chain Frost"
  ; Lich: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaMidnightLichU")
  CIcon_Load("DotaMidnightLichU", "a07f") ; "Frost Nova"
  CIcon_Load("DotaMidnightLichU", "a08rU") ; "Frost Armor"
  CIcon_Load("DotaMidnightLichU", "a053") ; "Dark Ritual"
  CIcon_Load("DotaMidnightLichU", "a05t") ; "Chain Frost"
  ; Lich (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMidnightLichScepter")
  CIcon_LoadHS("DotaMidnightLichScepter", "a07f") ; "Frost Nova"
  CIcon_LoadHS("DotaMidnightLichScepter", "a08r") ; "Frost Armor"
  CIcon_LoadHS("DotaMidnightLichScepter", "a053") ; "Dark Ritual"
  CIcon_LoadHS("DotaMidnightLichScepter", "a08h") ; "Chain Frost (Aghanim's Scepter)"
  ; Lich (Aghanim's Scepter): Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaMidnightLichScepterU")
  CIcon_Load("DotaMidnightLichScepterU", "a07f") ; "Frost Nova"
  CIcon_Load("DotaMidnightLichScepterU", "a08rU") ; "Frost Armor"
  CIcon_Load("DotaMidnightLichScepterU", "a053") ; "Dark Ritual"
  CIcon_Load("DotaMidnightLichScepterU", "a08h") ; "Chain Frost (Aghanim's Scepter)"

  ; Death Prophet
  CIcon_LoadHeroDota("DotaMidnightDeathProphet")
  CIcon_LoadHS("DotaMidnightDeathProphet", "a02m") ; "Carrion Swarm"
  CIcon_LoadHS("DotaMidnightDeathProphet", "ansi") ; "Silence"
  CIcon_LoadHS("DotaMidnightDeathProphet", "a02c") ; "Witchcraft"
  CIcon_LoadHS("DotaMidnightDeathProphet", "a073") ; "Exorcism"
  ; Death Prophet (Witchcraft 1)
  CIcon_LoadHeroDota("DotaMidnightDeathProphetE")
  CIcon_LoadHS("DotaMidnightDeathProphetE", "a06n") ; "Carrion Swarm"
  CIcon_LoadHS("DotaMidnightDeathProphetE", "a07h") ; "Silence"
  CIcon_LoadHS("DotaMidnightDeathProphetE", "a02c") ; "Witchcraft"
  CIcon_LoadHS("DotaMidnightDeathProphetE", "a03j") ; "Exorcism"
  ; Death Prophet (Witchcraft 2)
  CIcon_LoadHeroDota("DotaMidnightDeathProphetEE")
  CIcon_LoadHS("DotaMidnightDeathProphetEE", "a072") ; "Carrion Swarm"
  CIcon_LoadHS("DotaMidnightDeathProphetEE", "a07i") ; "Silence"
  CIcon_LoadHS("DotaMidnightDeathProphetEE", "a02c") ; "Witchcraft"
  CIcon_LoadHS("DotaMidnightDeathProphetEE", "a04j") ; "Exorcism"
  ; Death Prophet (Witchcraft 3)
  CIcon_LoadHeroDota("DotaMidnightDeathProphetEEE")
  CIcon_LoadHS("DotaMidnightDeathProphetEEE", "a074") ; "Carrion Swarm"
  CIcon_LoadHS("DotaMidnightDeathProphetEEE", "a07j") ; "Silence"
  CIcon_LoadHS("DotaMidnightDeathProphetEEE", "a02c") ; "Witchcraft"
  CIcon_LoadHS("DotaMidnightDeathProphetEEE", "a04m") ; "Exorcism"
  ; Death Prophet (Witchcraft 4)
  CIcon_LoadHeroDota("DotaMidnightDeathProphetEEEE")
  CIcon_LoadHS("DotaMidnightDeathProphetEEEE", "a078") ; "Carrion Swarm"
  CIcon_LoadHS("DotaMidnightDeathProphetEEEE", "a07m") ; "Silence"
  CIcon_Load("DotaMidnightDeathProphetEEEE", "a02c") ; "Witchcraft"
  CIcon_LoadHS("DotaMidnightDeathProphetEEEE", "a04n") ; "Exorcism"

  ; Demon Witch
  CIcon_LoadHeroDota("DotaMidnightDemonWitch")
  CIcon_LoadHS("DotaMidnightDemonWitch", "a02j") ; "Impale"
  CIcon_LoadHS("DotaMidnightDemonWitch", "a0mn") ; "Voodoo"
  CIcon_LoadHS("DotaMidnightDemonWitch", "a02n") ; "Mana Drain"
  CIcon_LoadHS("DotaMidnightDemonWitch", "a095") ; "Finger of Death"
  ; Demon Witch (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMidnightDemonWitchScepter")
  CIcon_LoadHS("DotaMidnightDemonWitchScepter", "a02j") ; "Impale"
  CIcon_LoadHS("DotaMidnightDemonWitchScepter", "a0mn") ; "Voodoo"
  CIcon_LoadHS("DotaMidnightDemonWitchScepter", "a02n") ; "Mana Drain"
  CIcon_LoadHS("DotaMidnightDemonWitchScepter", "a09w") ; "Finger of Death (Aghanim's Scepter)"
  ; Venomancer
  CIcon_LoadHeroDota("DotaMidnightVenomancer")
  CIcon_LoadHS("DotaMidnightVenomancer", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("DotaMidnightVenomancer", "a0my") ; "Poison Sting"
  CIcon_LoadHS("DotaMidnightVenomancer", "a0ms") ; "Plague Ward"
  CIcon_LoadHS("DotaMidnightVenomancer", "a013") ; "Poison Nova"
  ; Venomancer (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaMidnightVenomancerScepter")
  CIcon_LoadHS("DotaMidnightVenomancerScepter", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("DotaMidnightVenomancerScepter", "a0my") ; "Poison Sting"
  CIcon_LoadHS("DotaMidnightVenomancerScepter", "a0ms") ; "Plague Ward"
  CIcon_LoadHS("DotaMidnightVenomancerScepter", "a0a6") ; "Poison Nova (Aghanim's Scepter)"
  ; Magnataur
  CIcon_LoadHeroDota("DotaMidnightMagnataur")
  CIcon_LoadHS("DotaMidnightMagnataur", "a02s") ; "Shock Wave"
  CIcon_LoadHS("DotaMidnightMagnataur", "a037") ; "Empower"
  CIcon_LoadHS("DotaMidnightMagnataur", "a024") ; "Mighty Swing"
  CIcon_LoadHS("DotaMidnightMagnataur", "a06f") ; "Reverse Polarity"
  ; Necro'lic
  CIcon_LoadHeroDota("DotaMidnightNecrolic")
  CIcon_LoadHS("DotaMidnightNecrolic", "a08x") ; "Grave Chill"
  CIcon_LoadHS("DotaMidnightNecrolic", "a0c4") ; "Soul Assumption"
  ;CIcon_CIconHSDotaN("", 8, "V", "Gravekeeper's Cloak", "BTNAcorn")
  CIcon_LoadHS("DotaMidnightNecrolic", "a07k") ; "Raise Revenant"
  ; Chaos Knight
  CIcon_LoadHeroDota("DotaMidnightChaosKnight")
  CIcon_LoadHS("DotaMidnightChaosKnight", "a055") ; "Chaos Bolt"
  CIcon_LoadHS("DotaMidnightChaosKnight", "a09f") ; "Blink Strike"
  CIcon_LoadHS("DotaMidnightChaosKnight", "a03n") ; "Critical Strike"
  CIcon_LoadHS("DotaMidnightChaosKnight", "a03o") ; "Phantasm"
  ; Lycanthrope
  CIcon_LoadHeroDota("DotaMidnightLycanthrope")
  CIcon_LoadHS("DotaMidnightLycanthrope", "a03d") ; "Summon Wolves"
  ;CIcon_LoadHS("DotaMidnightLycanthrope", "a02d") ; "Howl"
  CIcon_LoadHS("DotaMidnightLycanthrope", "a02g") ; "Howl"
  CIcon_LoadHS("DotaMidnightLycanthrope", "a03e") ; "Feral Heart"
  CIcon_LoadHS("DotaMidnightLycanthrope", "a093") ; "Shapeshift"
  CIcon_LoadHS("DotaMidnightLycanthrope", "a03b") ; "Critical Strike"
  ; Broodmother
  CIcon_LoadHeroDota("DotaMidnightBroodmother")
  CIcon_LoadHS("DotaMidnightBroodmother", "a0bh") ; "Spawn Spiderlings"
  CIcon_LoadHS("DotaMidnightBroodmother", "a0bg") ; "Spin Web"
  CIcon_Load("DotaMidnightBroodmother", "a0bm") ; "Incapacitating Bite"
  CIcon_Load("DotaMidnightBroodmotherL", "a0bkL") ; "Incapacitating Bite"
  CIcon_LoadHS("DotaMidnightBroodmother", "a0bp") ; "Insatiable Hunger"
  ; Broodmother: Auto-cast On
  CIcon_LoadHeroDota("DotaMidnightBroodmotherU")
  CIcon_Load("DotaMidnightBroodmotherU", "a0bhU") ; "Spawn Spiderlings"
  CIcon_Load("DotaMidnightBroodmotherU", "a0bg") ; "Spin Web"
  CIcon_Load("DotaMidnightBroodmotherU", "a0bm") ; "Incapacitating Bite"
  CIcon_Load("DotaMidnightBroodmotherU", "a0bp") ; "Insatiable Hunger"
  ; Spiderling
  CIcon_LoadUnit("DotaMidnightSpiderling")
  CIcon_Load("DotaMidnightSpiderling", "a0bj") ; "Poison Sting"
  CIcon_Load("DotaMidnightSpiderling", "a002") ; "Spawn Spiderite"
  ; Spiderling
  CIcon_LoadUnit("DotaMidnightSpiderlingU")
  CIcon_Load("DotaMidnightSpiderlingU", "a0bj") ; "Poison Sting"
  CIcon_Load("DotaMidnightSpiderlingU", "a002U") ; "Spawn Spiderite"
  ; Phantom Assassin
  CIcon_LoadHeroDota("DotaMidnightPhantomAssassin")
  CIcon_LoadHS("DotaMidnightPhantomAssassin", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("DotaMidnightPhantomAssassin", "a0k9") ; "Blink Strike"
  CIcon_LoadHS("DotaMidnightPhantomAssassin", "a03p") ; "Blur"
  CIcon_LoadHS("DotaMidnightPhantomAssassin", "a03q") ; "Coup de Graçe"
  
  ; Evening Tavern
  ; Gordon
  CIcon_LoadHeroDota("DotaEveningGordon")
  CIcon_LoadHS("DotaEveningGordon", "a012") ; "Split Shot"/ "Stop Split Shot"
  CIcon_LoadHS("DotaEveningGordon", "a00y") ; "Chain Lightning"
  CIcon_LoadHS("DotaEveningGordon", "a0mp") ; "Activate Mana Shield"/ "Deactivate Mana Shield"
  CIcon_LoadHS("DotaEveningGordon", "a02v") ; "Purge"
  ;CIcon_LoadHS("DotaEveningGordon", "a09j") ; "Split Shot"
  ; Gordan On
  CIcon_LoadHeroDotaNoCancel("DotaEveningGordonD")
  CIcon_Load("DotaEveningGordonD", "a012D") ; "Split Shot"/ "Stop Split Shot"
  CIcon_Load("DotaEveningGordonD", "a00y") ; "Chain Lightning"
  CIcon_Load("DotaEveningGordonD", "a0mpD") ; "Activate Mana Shield"/ "Deactivate Mana Shield"
  CIcon_Load("DotaEveningGordonD", "a02v") ; "Purge"
  CIcon_Load("DotaEveningGordonD", "a09j") ; "Split Shot"
  ; Night Stalker
  CIcon_LoadHeroDota("DotaEveningNightStalker")
  CIcon_LoadHS("DotaEveningNightStalker", "a02h") ; "Void"
  CIcon_Load("DotaEveningNightStalker", "a08c") ; "Crippling Fear"
  CIcon_Load("DotaEveningNightStalkerL", "a08eL") ; "Crippling Fear"
  CIcon_Load("DotaEveningNightStalkerL", "a086L") ; "Hunter in the Night"
  CIcon_LoadHS("DotaEveningNightStalker", "a03k") ; "Darkness"
  ; Skeleton King
  CIcon_LoadHeroDota("DotaEveningSkeletonKing")
  CIcon_LoadHS("DotaEveningSkeletonKing", "AHtb") ; "Storm Bolt" shared
  CIcon_LoadHS("DotaEveningSkeletonKing", "auav") ; "Vampiric Aura" shared
  CIcon_LoadHS("DotaEveningSkeletonKing", "aocr") ; "Critical Strike" shared
  CIcon_LoadHS("DotaEveningSkeletonKing", "a01y") ; "Reincarnation"
  ; Doom Bringer
  CIcon_LoadHeroDota("DotaEveningDoomBringer")
  CIcon_LoadHS("DotaEveningDoomBringer", "a05y") ; "Devour"
  CIcon_LoadHS("DotaEveningDoomBringer", "a0fe") ; "Scorched Earth"
  CIcon_LoadHS("DotaEveningDoomBringer", "a094") ; "LVL? Death"
  CIcon_LoadHS("DotaEveningDoomBringer", "a0mu") ; "Doom"
  ; Nerubian Assassin
  CIcon_LoadHeroDota("DotaEveningNerubianAssassin")
  CIcon_LoadHS("DotaEveningNerubianAssassin", "a09k") ; "Impale"
  CIcon_LoadHS("DotaEveningNerubianAssassin", "a02k") ; "Mana Burn"
  CIcon_LoadHS("DotaEveningNerubianAssassin", "a02l") ; "Spiked Carapace"
  CIcon_LoadHS("DotaEveningNerubianAssassin", "a09u") ; "Vendetta"
  ; Slithereen Guard
  CIcon_LoadHeroDota("DotaEveningSlithereenGuard")
  CIcon_LoadHS("DotaEveningSlithereenGuard", "a05c") ; "Sprint"
  CIcon_LoadHS("DotaEveningSlithereenGuard", "a01w") ; "Slithereen Crush"
  CIcon_LoadHS("DotaEveningSlithereenGuard", "a0jj") ; "Bash"
  CIcon_LoadHS("DotaEveningSlithereenGuard", "a034") ; "Amplify Damage"
  ; Slithereen Guard: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaEveningSlithereenGuardU")
  CIcon_Load("DotaEveningSlithereenGuardU", "a05c") ; "Sprint"
  CIcon_Load("DotaEveningSlithereenGuardU", "a01w") ; "Slithereen Crush"
  CIcon_Load("DotaEveningSlithereenGuardU", "a0jj") ; "Bash"
  CIcon_Load("DotaEveningSlithereenGuardU", "a034U") ; "Amplify Damage"
  ; Queen of Pain
  CIcon_LoadHeroDota("DotaEveningQueenOfPain")
  CIcon_LoadHS("DotaEveningQueenOfPain", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("DotaEveningQueenOfPain", "a0me") ; "Blink"
  CIcon_LoadHS("DotaEveningQueenOfPain", "a04a") ; "Scream of Pain"
  CIcon_LoadHS("DotaEveningQueenOfPain", "a00o") ; "Sonic Wave"
  ; Queen of Pain (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaEveningQueenOfPainScepter")
  CIcon_LoadHS("DotaEveningQueenOfPainScepter", "aesh") ; "Shadow Strike"
  CIcon_LoadHS("DotaEveningQueenOfPainScepter", "a0me") ; "Blink"
  CIcon_LoadHS("DotaEveningQueenOfPainScepter", "a04a") ; "Scream of Pain"
  CIcon_LoadHS("DotaEveningQueenOfPainScepter", "a0af") ; "Sonic Wave (Aghanim's Scepter)"
  ; Bone Fletcher
  CIcon_LoadHeroDota("DotaEveningBoneFletcher")
  CIcon_LoadHS("DotaEveningBoneFletcher", "a030") ; "Strafe"
  CIcon_LoadHS("DotaEveningBoneFletcher", "AHfa") ; "Searing Arrows" shared
  CIcon_LoadHS("DotaEveningBoneFletcher", "a025") ; "Wind Walk"
  CIcon_LoadHS("DotaEveningBoneFletcher", "a04q") ; "Death Pact"
  ; Bone Fletcher: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaEveningBoneFletcherU")
  CIcon_Load("DotaEveningBoneFletcherU", "a030") ; "Strafe"
  CIcon_Load("DotaEveningBoneFletcherU", "AHfaU") ; "Searing Arrows" shared
  CIcon_Load("DotaEveningBoneFletcherU", "a025") ; "Wind Walk"
  CIcon_Load("DotaEveningBoneFletcherU", "a04q") ; "Death Pact"
  ; Faceless Void
  CIcon_LoadHeroDota("DotaEveningFacelessVoid")
  CIcon_LoadHS("DotaEveningFacelessVoid", "a0lk") ; "Time Walk"
  CIcon_LoadHS("DotaEveningFacelessVoid", "a0cz") ; "Backtrack"
  CIcon_LoadHS("DotaEveningFacelessVoid", "a081") ; "Time Lock"
  CIcon_LoadHS("DotaEveningFacelessVoid", "a0j1") ; "Chronosphere"
  ; Netherdrake
  CIcon_LoadHeroDota("DotaEveningNetherdrake")
  CIcon_LoadHS("DotaEveningNetherdrake", "a05d") ; "Frenzy"
  CIcon_LoadHS("DotaEveningNetherdrake", "a09v") ; "Poison Attack"
  CIcon_LoadHS("DotaEveningNetherdrake", "a0mm") ; "Corrosive Skin"
  CIcon_LoadHS("DotaEveningNetherdrake", "a080") ; "Viper Strike"
  ; Netherdrake: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaEveningNetherdrakeU")
  CIcon_Load("DotaEveningNetherdrakeU", "a05d") ; "Frenzy"
  CIcon_Load("DotaEveningNetherdrakeU", "a09vU") ; "Poison Attack"
  CIcon_Load("DotaEveningNetherdrakeU", "a0mm") ; "Corrosive Skin"
  CIcon_Load("DotaEveningNetherdrakeU", "a080") ; "Viper Strike"
  ; Lightning Revenant
  CIcon_LoadHeroDota("DotaEveningLightningRevenant")
  CIcon_LoadHS("DotaEveningLightningRevenant", "a05d") ; "Frenzy"
  CIcon_LoadHS("DotaEveningLightningRevenant", "a00y") ; "Chain Lightning"
  CIcon_LoadHS("DotaEveningLightningRevenant", "a00n") ; "Unholy Fervor"
  CIcon_LoadHS("DotaEveningLightningRevenant", "a04b") ; "Storm Seeker"
  ; Lifestealer
  CIcon_LoadHeroDota("DotaEveningLifestealer")
  CIcon_LoadHS("DotaEveningLifestealer", "a0jq") ; "Feast"
  CIcon_LoadHS("DotaEveningLifestealer", "a01e") ; "Poison Sting"
  CIcon_LoadHS("DotaEveningLifestealer", "a06y") ; "Anabolic Frenzy"
  CIcon_LoadHS("DotaEveningLifestealer", "a028") ; "Rage"

  ; Twilight Tavern
  ; Oblivion
  CIcon_LoadHeroDota("DotaTwilightOblivion")
  CIcon_LoadHS("DotaTwilightOblivion", "a0mt") ; "Nether Blast"
  CIcon_LoadHS("DotaTwilightOblivion", "a0ce") ; "Decrepify"
  CIcon_LoadHS("DotaTwilightOblivion", "a09d") ; "Nether Ward"
  CIcon_LoadHS("DotaTwilightOblivion", "a0cc") ; "Life Drain"
  ; Oblivion (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaTwilightOblivionScepter")
  CIcon_LoadHS("DotaTwilightOblivionScepter", "a0mt") ; "Nether Blast"
  CIcon_LoadHS("DotaTwilightOblivionScepter", "a0ce") ; "Decrepify"
  CIcon_LoadHS("DotaTwilightOblivionScepter", "a09d") ; "Nether Ward"
  CIcon_LoadHS("DotaTwilightOblivionScepter", "a02z") ; "Life Drain"
  ; Tidehunter
  CIcon_LoadHeroDota("DotaTwilightTidehunter")
  CIcon_LoadHS("DotaTwilightTidehunter", "a046") ; ""
  CIcon_LoadHS("DotaTwilightTidehunter", "a04e") ; ""
  CIcon_LoadHS("DotaTwilightTidehunter", "a044") ; ""
  CIcon_LoadHS("DotaTwilightTidehunter", "a03z") ; ""
  ; Bane Elemental
  CIcon_LoadHeroDota("DotaTwilightBaneElemental")
  CIcon_LoadHS("DotaTwilightBaneElemental", "a04v") ; ""
  CIcon_LoadHS("DotaTwilightBaneElemental", "a0gk") ; ""
  CIcon_LoadHS("DotaTwilightBaneElemental", "a04y") ; ""
  CIcon_LoadHS("DotaTwilightBaneElemental", "a02q") ; ""
  ; Necrolyte
  CIcon_LoadHeroDota("DotaTwilightNecrolyte")
  CIcon_LoadHS("DotaTwilightNecrolyte", "a05v") ; "Death Pulse"
  ;CIcon_CIconHSDotaN("", 5, "F", "Diffusion Aura", "BTNAcorn")
  CIcon_LoadHS("DotaTwilightNecrolyte", "a060") ; "Sadist"
  CIcon_LoadHS("DotaTwilightNecrolyte", "a067") ; "Reaper's Scythe"
  ; Necrolyte (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaTwilightNecrolyteScepter")
  CIcon_LoadHS("DotaTwilightNecrolyteScepter", "a05v") ; "Death Pulse"
  ;CIcon_CIconHSDotaN("", 5, "F", "Diffusion Aura", "BTNAcorn")
  CIcon_LoadHS("DotaTwilightNecrolyteScepter", "a060") ; "Sadist"
  CIcon_LoadHS("DotaTwilightNecrolyteScepter", "a08p") ; "Reaper's Scythe"
  ; Butcher
  CIcon_LoadHeroDota("DotaTwilightButcher")
  CIcon_LoadHS("DotaTwilightButcher", "a06i") ; "Meat Hook"
  CIcon_LoadHS("DotaTwilightButcher", "a06k") ; "Activate Rot"/ "Deactivate Rot"
  CIcon_LoadHS("DotaTwilightButcher", "a06d") ; "Flesh Heap"
  CIcon_LoadHS("DotaTwilightButcher", "a0fl") ; "Dismember"
  ; Butcher: skillz active
  CIcon_LoadHeroDotaNoCancel("DotaTwilightButcherD")
  CIcon_Load("DotaTwilightButcherD", "a06i") ; "Meat Hook"
  CIcon_Load("DotaTwilightButcherD", "a06kD") ; "Activate Rot"/ "Deactivate Rot"
  CIcon_Load("DotaTwilightButcherD", "a06d") ; "Flesh Heap"
  CIcon_Load("DotaTwilightButcherD", "a0fl") ; "Dismember"
  ; Spiritbreaker
  CIcon_LoadHeroDota("DotaTwilightSpiritbreaker")
  CIcon_LoadHS("DotaTwilightSpiritbreaker", "a0ml") ; "Charge fo Darkness"
  CIcon_LoadHS("DotaTwilightSpiritbreaker", "a0es") ; "Empowering Haste"
  CIcon_LoadHS("DotaTwilightSpiritbreaker", "a0g5") ; "Greater Bash"
  CIcon_LoadHS("DotaTwilightSpiritbreaker", "a0g4") ; "Nether Strike"
  ; Nerubian Weaver
  CIcon_LoadHeroDota("DotaTwilightNerubianWeaver")
  CIcon_LoadHS("DotaTwilightNerubianWeaver", "a00t") ; "Watcher"
  CIcon_LoadHS("DotaTwilightNerubianWeaver", "a0ca") ; "Shukuchi"
  CIcon_Load("DotaTwilightNerubianWeaver", "a0cn") ; "Geminate Attack"
  CIcon_Load("DotaTwilightNerubianWeaverL", "a0cgL") ; "Geminate Attack"
  CIcon_LoadHS("DotaTwilightNerubianWeaver", "a0ct") ; "Time Lapse"
  ; Watcher
  CIcon_LoadUnitNoAttack("DotaTwilightWatcher")
  CIcon_LoadHS("DotaTwilightWatcher", "acsk") ; "Spell Immunity"
  ; Shadow Fiend
  CIcon_LoadHeroDotaNoAttrib("DotaTwilightShadowFiend")
  CIcon_LoadHS("DotaTwilightShadowFiend", "a0ey") ; "Shadowraze"
  CIcon_Load("DotaTwilightShadowFiend", "a0fh") ; "Shadowraze"
  CIcon_Load("DotaTwilightShadowFiend", "a0f0") ; "Shadowraze"
  ;CIcon_CIconHSDotaN("", 4, "N", "Necromastery", "BTNAcorn")
  CIcon_LoadHS("DotaTwilightShadowFiend", "a0fu") ; "Presence of the Dark Lord"
  CIcon_LoadHS("DotaTwilightShadowFiend", "a0he") ; "Requiem of Souls"
  CIcon_Load("DotaTwilightShadowFiendL", "a0nrL") ; "Skillz"
  ; Sand King
  CIcon_LoadHeroDota("DotaTwilightSandKing")
  CIcon_LoadHS("DotaTwilightSandKing", "a06o") ; "Burrowstrike"
  CIcon_LoadHS("DotaTwilightSandKing", "a0h0") ; "Sand Storm"
  CIcon_LoadHS("DotaTwilightSandKing", "a0fa") ; "Caustic Finale"
  CIcon_LoadHS("DotaTwilightSandKing", "a06r") ; "Epicenter"
  ; Axe
  CIcon_LoadHeroDota("DotaTwilightAxe")
  CIcon_LoadHS("DotaTwilightAxe", "a0c7") ; "Berserker's Call"
  CIcon_LoadHS("DotaTwilightAxe", "a0c5") ; "Battle Hunger"
  CIcon_LoadHS("DotaTwilightAxe", "a0c6") ; "Counter Helix"
  CIcon_LoadHS("DotaTwilightAxe", "a0e2") ; "Culling Blade"
  ; Bloodseeker
  CIcon_LoadHeroDota("DotaTwilightBloodseeker")
  CIcon_LoadHS("DotaTwilightBloodseeker", "a0ec") ; "Bloodrage"
  CIcon_LoadHS("DotaTwilightBloodseeker", "a0le") ; "Blood Bath"
  CIcon_LoadHS("DotaTwilightBloodseeker", "a0lf") ; "Strygwyr's Thirst"
  CIcon_LoadHS("DotaTwilightBloodseeker", "a0lh") ; "Rupture"
  ; Lord of Avernus
  CIcon_LoadHeroDota("DotaTwilightLordOfAvernus")
  CIcon_LoadHS("DotaTwilightLordOfAvernus", "a0mf") ; "Aphotic Shield"
  CIcon_LoadHS("DotaTwilightLordOfAvernus", "a0mi") ; "Mark of the Abyss"
  CIcon_LoadHS("DotaTwilightLordOfAvernus", "a0mg") ; "Frostmourne"
  CIcon_LoadHS("DotaTwilightLordOfAvernus", "a0ns") ; "Borrowed Time"

  ; Dusk Tavern
  ; Avatar of Vengeance
  CIcon_LoadHeroDotaNoAttrib("DotaDuskAvatarOfVengeance")
  CIcon_LoadHS("DotaDuskAvatarOfVengeance", "a0n6") ; "Phase"
  CIcon_LoadHS("DotaDuskAvatarOfVengeance", "a0n7") ; "Haunt"
  CIcon_LoadHS("DotaDuskAvatarOfVengeance", "a0na") ; "Dispersion"
  CIcon_LoadHS("DotaDuskAvatarOfVengeance", "a0nf") ; "Vengeance"
  CIcon_Load("DotaDuskAvatarOfVengeance", "a0nb") ; "Reality"
  CIcon_Load("DotaDuskAvatarOfVengeance", "a0nd") ; "Direct Vengeance"
  CIcon_Load("DotaDuskAvatarOfVengeanceL", "a0nrL") ; "Skillz"  
  ; Witch Doctor
  CIcon_LoadHeroDota("DotaDuskWitchDoctor")
  CIcon_LoadHS("DotaDuskWitchDoctor", "a0nm") ; "Paralyzing Casks"
  CIcon_LoadHS("DotaDuskWitchDoctor", "a0ne") ; "Voodoo Restoration"/ "Deactivate Voodoo Restoration"
  CIcon_LoadHS("DotaDuskWitchDoctor", "a0no") ; "Maledict"
  CIcon_LoadHS("DotaDuskWitchDoctor", "a0nt") ; "Death Ward"
  ; Witch Doctor Skills Active
  CIcon_LoadHeroDotaNoCancel("DotaDuskWitchDoctorD")
  CIcon_Load("DotaDuskWitchDoctorD", "a0nm") ; "Paralyzing Casks"
  CIcon_Load("DotaDuskWitchDoctorD", "a0neD") ; "Voodoo Restoration"/ "Deactivate Voodoo Restoration"
  CIcon_Load("DotaDuskWitchDoctorD", "a0no") ; "Maledict"
  CIcon_Load("DotaDuskWitchDoctorD", "a0nt") ; "Death Ward"
  ; Witch Doctor (Aghanim's Scepter)
  CIcon_LoadHeroDota("DotaDuskWitchDoctorScepter")
  CIcon_LoadHS("DotaDuskWitchDoctorScepter", "a0nm") ; "Paralyzing Casks"
  CIcon_LoadHS("DotaDuskWitchDoctorScepter", "a0ne") ; "Voodoo Restoration"/ "Deactivate Voodoo Restoration"
  CIcon_LoadHS("DotaDuskWitchDoctorScepter", "a0no") ; "Maledict"
  CIcon_LoadHS("DotaDuskWitchDoctorScepter", "a0nx") ; "Death Ward"
  ; Witch Doctor (Aghanim's Scepter) Skills Active
  CIcon_LoadHeroDotaNoCancel("DotaDuskWitchDoctorScepterD")
  CIcon_Load("DotaDuskWitchDoctorScepterD", "a0nm") ; "Paralyzing Casks"
  CIcon_Load("DotaDuskWitchDoctorScepterD", "a0neD") ; "Voodoo Restoration"/ "Deactivate Voodoo Restoration"
  CIcon_Load("DotaDuskWitchDoctorScepterD", "a0no") ; "Maledict"
  CIcon_Load("DotaDuskWitchDoctorScepterD", "a0nx") ; "Death Ward"
  ; Obsidian Destroyer
  CIcon_LoadHeroDota("DotaDuskObsidianDestroyer")
  CIcon_LoadHS("DotaDuskObsidianDestroyer", "a0oi") ; "Arcane Orb"
  CIcon_LoadHS("DotaDuskObsidianDestroyer", "a0oj") ; "Astral Imprisonment"
  ;CIcon_CIconHSDota("", 8, "", "Essence Aura", "BTNTemp")
  CIcon_LoadHS("DotaDuskObsidianDestroyer", "a0ok") ; "Sanity's Eclipse"
  ; Obsidian Destroyer: Auto-cast On
  CIcon_LoadHeroDotaNoCancel("DotaDuskObsidianDestroyerU")
  CIcon_Load("DotaDuskObsidianDestroyerU", "a0oiU") ; "Arcane Orb"
  CIcon_Load("DotaDuskObsidianDestroyerU", "a0oj") ; "Astral Imprisonment"
  ;CIcon_CIconHSDota("", 8, "", "Essence Aura", "BTNTemp")
  CIcon_Load("DotaDuskObsidianDestroyerU", "a0ok") ; "Sanity's Eclipse"
    
  ; Dota Creeps
  ; Satyr Hellcaller
  CIcon_LoadUnit("DotaCreepsSatyrHellcaller")
  CIcon_Load("DotaCreepsSatyrHellcaller", "acsh") ; "Shockwave"
  CIcon_Load("DotaCreepsSatyrHellcaller", "acua") ; "Unholy Aura"
  ; Satyr Soulstealer
  ;CIcon_CIcon("", 2, "B", "Mana Burn", "BTNManaBurn")
  ; Satyr Trickser
  CIcon_LoadUnit("DotaCreepsSatyrTrickser")
  CIcon_Load("DotaCreepsSatyrTrickser", "acpu") ; "Purge"
  ; Polar Furlborg Ursa Warrior
  CIcon_LoadUnit("DotaCreepsPolarFurlborgUrsaWarrior")
  CIcon_Load("DotaCreepsPolarFurlborgUrsaWarrior", "acac")
  CIcon_Load("DotaCreepsPolarFurlborgUrsaWarrior", "awrs")
  ; Centaur Khan
  CIcon_LoadUnit("DotaCreepsCentaurKhan")
  CIcon_Load("DotaCreepsCentaurKhan", "awrs")
  CIcon_Load("DotaCreepsCentaurKhan", "scae") ; "Endurance Aura"
  ; Ogre Magi
  CIcon_LoadUnit("DotaCreepsOgreMagi")
  CIcon_Load("DotaCreepsOgreMagi", "acf2") ; "Frost Armor"
  ; Ogre Magi: Auto-cast On
  CIcon_LoadUnit("DotaCreepsOgreMagiU")
  CIcon_Load("DotaCreepsOgreMagiU", "acf2U") ; "Frost Armor"
  ; Forest Troll High Priest
  CIcon_LoadUnit("DotaCreepsForestTrollHighPriest")
  CIcon_Load("DotaCreepsForestTrollHighPriest", "anh2")
  CIcon_Load("DotaCreepsForestTrollHighPriest", "acd2")
  ; Forest Troll High Priest: Auto-cast On
  CIcon_LoadUnit("DotaCreepsForestTrollHighPriestU")
  CIcon_Load("DotaCreepsForestTrollHighPriestU", "anh2U")
  CIcon_Load("DotaCreepsForestTrollHighPriestU", "acd2U")
  ; Kobold Taskmaster
  CIcon_LoadUnit("DotaCreepsKoboldTaskmaster")
  CIcon_Load("DotaCreepsKoboldTaskmaster", "acac")
  CIcon_Load("DotaCreepsKoboldTaskmaster", "acbh") ; "Bash"
  ; Kobold Tunneler
  CIcon_LoadUnit("DotaCreepsKoboldTunneler")
  CIcon_Load("DotaCreepsKoboldTunneler", "acbh") ; "Bash"
  ; Necronomicon Archer
  CIcon_LoadUnit("DotaCreepsNecronomiconArcher")
  CIcon_Load("DotaCreepsNecronomiconArcher", "a0gv") ; "Mana Burn"
  CIcon_Load("DotaCreepsNecronomiconArcher", "a0gy") ; "Necronomicon Endurance Aura"
  CIcon_Load("DotaCreepsNecronomiconArcher", "a0h3") ; "Spell Immunity"
  ; Necronomicon Archer 2
  CIcon_LoadUnit("DotaCreepsNecronomiconArcherTwo")
  CIcon_Load("DotaCreepsNecronomiconArcherTwo", "a0jv") ; "Mana Burn"
  CIcon_Load("DotaCreepsNecronomiconArcherTwo", "a0gb") ; "Necronomicon Endurance Aura"
  CIcon_Load("DotaCreepsNecronomiconArcherTwo", "a0h3") ; "Spell Immunity"
  ; Necronomicon Archer 3
  CIcon_LoadUnit("DotaCreepsNecronomiconArcherThree")
  CIcon_Load("DotaCreepsNecronomiconArcherThree", "a0jw") ; "Mana Burn"
  CIcon_Load("DotaCreepsNecronomiconArcherThree", "a0hn") ; "Necronomicon Endurance Aura"
  CIcon_Load("DotaCreepsNecronomiconArcherThree", "a0h3") ; "Spell Immunity"
  ; Necronomicon Warrior
  CIcon_LoadUnit("DotaCreepsNecronomiconWarrior")
  CIcon_Load("DotaCreepsNecronomiconWarrior", "a0gw") ; "Mana Break"
  CIcon_Load("DotaCreepsNecronomiconWarrior", "a0gu") ; "Last Will"
  CIcon_Load("DotaCreepsNecronomiconWarrior", "a0h3") ; "Spell Immunity"
  ; Necronomicon Warrior 2
  CIcon_LoadUnit("DotaCreepsNecronomiconWarriorTwo")
  CIcon_Load("DotaCreepsNecronomiconWarriorTwo", "a0m2") ; "Mana Break"
  CIcon_Load("DotaCreepsNecronomiconWarriorTwo", "a0gx") ; "Last Will"
  CIcon_Load("DotaCreepsNecronomiconWarriorTwo", "a0h3") ; "Spell Immunity"
  ; Necronomicon Warrior 3
  CIcon_LoadUnit("DotaCreepsNecronomiconWarriorThree")
  CIcon_Load("DotaCreepsNecronomiconWarriorThree", "a0m4") ; "Mana Break"
  CIcon_Load("DotaCreepsNecronomiconWarriorThree", "a0gz") ; "Last Will"
  CIcon_Load("DotaCreepsNecronomiconWarriorThree", "a0h3") ; "Spell Immunity"
  ; Necronomicon Warrior
  CIcon_LoadUnit("DotaCreepsNecronomiconWarriorThree")
  ; Giant Wolf
  CIcon_LoadUnit("DotaCreepsGiantWolf")
  CIcon_Load("DotaCreepsGiantWolf", "acct")
  ; Gnoll Assassin
  CIcon_LoadUnit("DotaCreepsGnollAssassin")
  CIcon_Load("DotaCreepsGnollAssassin", "acvs")
}

; Checks each of the 12 positions on the grid and brings up the associated icon
GridDrawCurrentGrid()
{
  global
  
  StringRight, cLastChar, prgpCIconGridCurrent, 1
  
  iIndexSelected :=

  ;Gui +LastFound
  ;SendMessage, 0xB, false ; Turn off redrawing. 0xB is WM_SETREDRAW. 
    
  i := 0
  loop, 12
  {
    pCIconTemp := %prgpCIconGridCurrent%%i%
    
    if pCIconTemp
    {
      iTempType := %pCIconTemp%_iType
      
      strCIconImage := %pCIconTemp%_strImage
      cCIconHotkey := %pCIconTemp%_cHotkey
      iCIconType := %pCIconTemp%_iType
      
      if  ( (iCIconType != kiTypeNoHotkey) && (iCIconType != kiTypeHeroSpellNoHotkey)
        && (iCIconType != kiTypeUnbuttonB) && (iCIconType != kiTypeHeroSpellUnbuttonB) 
        && (iCIconType != kiTypeHeroSpellSixNoHotkey)&& (iCIconType != kiTypeDotaUN)
        && (iCIconType != kiTypeHeroSpellDotaUN) && (iCIconType != kiTypeDotaAB) 
        && (bOpHideHotkeys == false) )
      { 
        if (cCIconHotkey == "ESC")
        {
          ;cCIconHotkey = Esc
          ; todo: make ESC show up instead of just ES
          GuiControl, , rgText%i%, %cCIconHotkey%
          ;GuiControl, , rgTextEsc%i%, %cCIconHotkey%
        }
        else
          GuiControl, , rgText%i%, %cCIconHotkey%
          
        GuiControl, Show, rgText%i%
      }
      else
        GuiControl, Hide, rgText%i%
    }
    else
    {
      strCIconImage := kstrBlankImage
      GuiControl, Hide, rgText%i%
    }
    ;GuiControl, Hide, rgImage%i%
    GuiControl, , rgImage%i%, %ImageDir%\%strCIconImage%.jpg
    ;GuiControl, Show, rgImage%i%
     
    i++  
  }
  
  ;Gui +LastFound
  ;SendMessage, 0xB, true  ; Turn redrawing back on.
  ;WinSet Redraw  ; Force the window to repaint.  
}

; Align all the keys in 5 lines or less
GridAlign()
{
  global
  
  Loop
  {
    if (A_Index >= m_iCIconCount)
      break
      
    pCIconListCurrent := m_rgCIconList%A_Index%
    GridAlignKey(pCIconListCurrent) 
  }
  
  ; update Cancel command on Learn Grid
  ;GridAlignLearnHotKey(CIconcmdcancel_cHotkey, iCurrentButtonPos)
  
  CIcon_ResetUnchangeables()
}

; Given a certain cmd, this function will set all associated hotkeys
; (ie normal, learn, double) based on its button position 
GridAlignKey(kstrCodeName)
{
  global

  iCurrentType := CIcon%kstrCodeName%_iType
  iCurrentButtonPos := CIcon%kstrCodeName%_iButtonPos
  
  ; if there is no hotkey, then return
  if ( (iCurrentType == kiTypeNoHotkey) || (iCurrentType == kiTypeDotaUN)
    || (iCurrentType == kiTypeHeroSpellDotaUN) || (iCurrentType == kiTypeDotaAB) 
    || (iCurrentType == kiTypeUnbuttonB) || (iCurrentType == kiTypeHeroSpellUnbuttonB) 
    || (iCurrentType == kiTypeGridKey) )
    return

  /*
  ; if it's a hero spell with no hotkey, Align the Learn Hotkey, then return
  if ( (iCurrentType == kiTypeHeroSpellNoHotkey) || (iCurrentType == kiTypeHeroSpellSixNoHotkey) )
  {
    iCurrentButtonPos := CIcon%kstrCodeName%L_iButtonPos
    strHotkeyTemp = CIcon%kstrCodeName%L_cHotkey
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)
    return
  }
  */
  
  ; else Align the key to the grid
  strHotkeyTemp = CIcon%kstrCodeName%_cHotkey
  if ( (iCurrentType == kiTypeHeroSpellLearn) || (strHotkeyTemp == "CIconcmdcancel_cHotkey") )
    GridAlignLearnHotKey(strHotkeyTemp, iCurrentButtonPos)
  else 
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)

  /*
  ; check special keys
  if ( (iCurrentType == kiTypeNormal2) || (iCurrentType == kiTypeNormal3) )
  {
    strHotkeyTemp = CIcon%kstrCodeName%A_cHotkey
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)
    if ( iCurrentType == kiTypeNormal3 )
    {
      strHotkeyTemp = CIcon%kstrCodeName%B_cHotkey
      GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)
    }
  }
  else if ( (iCurrentType == kiTypeDouble) || (iCurrentType == kiTypeHeroSpellDouble)
    || (iCurrentType == kiTypeHeroSpellSixDouble) )
  {
    iCurrentButtonPos := CIcon%kstrCodeName%D_iButtonPos
    strHotkeyTemp = CIcon%kstrCodeName%D_cHotkey  
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)
  }
  if ( (iCurrentType == kiTypeHeroSpell) || (iCurrentType == kiTypeHeroSpellDouble)
    || (iCurrentType == kiTypeHeroSpellSix) || (iCurrentType == kiTypeHeroSpellSixDouble) )
  {
    iCurrentButtonPos := CIcon%kstrCodeName%L_iButtonPos
    strHotkeyTemp = CIcon%kstrCodeName%L_cHotkey
    ;msgbox, strHotkeyTemp = %strHotkeyTemp%
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPos)
  }
  */
}

; Given a Hotkey and a buttonpos, this function sets the hotkey based on the buttonpos
GridAlignHotKey(strHotkey, iCurrentButtonPos)
{
  global
  
  if CIconWarkeysGrid%iCurrentButtonPos%_cHotkey =
    return
  
  %strHotkey% := CIconWarkeysGrid%iCurrentButtonPos%_cHotkey
  ;msgbox, WarkeysGrid%iCurrentButtonPos%_cHotkey = %temp%
}

; Same as above but uses the "Learn" Grid
GridAlignLearnHotKey(strHotkey, iCurrentButtonPos)
{
  global
  
  if CIconWarkeysLearnGrid%iCurrentButtonPos%_cHotkey =
    return
  
  %strHotkey% := CIconWarkeysLearnGrid%iCurrentButtonPos%_cHotkey
  ;temp := strHotkey
  ;msgbox, WarkeysGrid%iCurrentButtonPos%_cHotkey = %temp%
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; CIcon Class ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Member Variables:
;   m_iCIconCount ; a counter that tells us how many icons are in the array
;   m_rgCIconList ; an array that serves as a quick ref to the list of icons 
;
; Constructors: These functions create an icon object 
; CIcon_CIconH(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIcon(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIcon2(strCode, iButtonPos, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
; CIcon_CIcon3(strCode, iButtonPos, cHotkey, cHotkey2, cHotkey3, strName, strName2, strName3, strImage, strImage2, strImage3)
; CIcon_CIconU(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconN(strCode, iButtonPos, strName, strImage)
; CIcon_CIconD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
; CIcon_CIconSeparate(strCode, strCode2, iButtonPos, cHotkey, strName, strImage)
;
; CIcon_CIconHS(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSU(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSN(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
; CIcon_CIconHS6(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHS6N(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHS6D(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
;
; CIcon_CIconHSDota(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSDotaU(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSDotaN(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSDotaUN(strCode, iButtonPos, cHotkey, strName, strImage)
; CIcon_CIconHSDotaD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
; CIcon_CIconDotaUN(strCode, iButtonPos, strName, strImage)
; CIcon_CIconDota()
; CIcon_CIconDotaAB(strCode, iButtonPos, cHotkey, strName, strImage)
;
;
; CIcon_Load(kstrGridName, kstrIconName) ; These functions attach an icon to a grid
;
; CIcon_LoadUnit(kstrGridName) ; loads icons common to units
; CIcon_LoadUnitNoAttack(kstrGridName) ; units without attack
; CIcon_LoadUnitAttackGround(kstrGridName) ; for units that also attack ground
; CIcon_LoadUnitTransport(kstrGridName) ; for transports (load and unload, but no attack)
;
; CIcon_LoadHero(kstrGridName) ; loads icons common to a hero
; CIcon_LoadHeroNoCancel(kstrGridName) ; does not attach the cancel command to the learn grid, use this function for secondary grids, like auto-cast on or doubles
;
; CIcon_LoadHeroDota(kstrGridName) ; dota heros
; CIcon_LoadHeroDotaNoAttrib(kstrGridName) ; dota heros WITHOUT yellow cross
;
; CIcon_LoadUnitBuilding(kstrGridName) ; loads icons common to buildings (cmd cancel and cmd rally)
;
; These fuctions update the icons
; CIcon_Update(pCIcon, iPosition)
; CIcon_UpdateTiny(pCIcon, iPosition)
;
; CIcon_Unchangeable() ; resets the unchangeables (run this after loading in a file)

; constructor for the Hotkey Grid
CIcon_CIconGridKey(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeGridKey
  
  m_rgCIconList%m_iCIconCount% = %strCode% 
  m_iCIconCount++
}

; constructor for heros
CIcon_CIconH(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global
  
  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHero
  m_rgCIconList%m_iCIconCount% = %strCode% 
  m_iCIconCount++
}

; constructor for normal icons
CIcon_CIcon(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeNormal
  m_rgCIconList%m_iCIconCount% = %strCode% 
  m_iCIconCount++
}

; constructor for items with 2 phases, such as research priest upgrades
CIcon_CIcon2(strCode, iButtonPos, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeNormal2
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%A_strNameDefault = %strName2%
  CIcon%strCode%A_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%A_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%A_strImage = %strImage2%
  CIcon%strCode%A_cHotkey = %cHotkey2%
  CIcon%strCode%A_iButtonPos = %iButtonPos%
  CIcon%strCode%A_strName = %strName2%
  ;CIcon%strCode%A_iType := kiTypeNormal2B
  m_rgCIconList%m_iCIconCount% = %strCode%A
  m_iCIconCount++
}

; constructor for items with 3 phases, such as all weapon upgrades
CIcon_CIcon3(strCode, iButtonPos, cHotkey, cHotkey2, cHotkey3, strName, strName2, strName3, strImage, strImage2, strImage3)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeNormal3
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%A_strNameDefault = %strName2%
  CIcon%strCode%A_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%A_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%A_strImage = %strImage2%
  CIcon%strCode%A_cHotkey = %cHotkey2%
  CIcon%strCode%A_iButtonPos = %iButtonPos%
  CIcon%strCode%A_strName = %strName2%
  ;CIcon%strCode%A_iType := kiTypeNormal3B
  m_rgCIconList%m_iCIconCount% = %strCode%A
  m_iCIconCount++

  CIcon%strCode%B_strNameDefault = %strName3%
  CIcon%strCode%B_cHotkeyDefault = %cHotkey3%
  CIcon%strCode%B_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%B_strImage = %strImage3%
  CIcon%strCode%B_cHotkey = %cHotkey3%
  CIcon%strCode%B_iButtonPos = %iButtonPos%
  CIcon%strCode%B_strName = %strName3%
  ;CIcon%strCode%B_iType := kiTypeNormal3BB
  m_rgCIconList%m_iCIconCount% = %strCode%B
  m_iCIconCount++
}

; constructor for icons with unbuttons
CIcon_CIconU(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeUnbutton
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++
 
  CIcon%strCode%U_strNameDefault = |cffc3dbffRight-click to activate auto-casting.|r
  ;CIcon%strCode%U_cHotkeyDefault = %cHotkey%
  CIcon%strCode%U_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%U_strName = |cffc3dbffRight-click to activate auto-casting.|r
  ;CIcon%strCode%U_cHotkey = %cHotkey%
  CIcon%strCode%U_iButtonPos = %iButtonPos%
  CIcon%strCode%U_strImage = %strImage%On
  CIcon%strCode%U_iType := kiTypeUnbuttonB
  m_rgCIconList%m_iCIconCount% = %strCode%U
  m_iCIconCount++
}

; constructor for icons with no hotkey, such as true sight
CIcon_CIconN(strCode, iButtonPos, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeNoHotkey  
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++
}

; constructor for icons with on and off states, like defend and stop defend
CIcon_CIconD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeDouble
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%D_strNameDefault = %strName2%
  CIcon%strCode%D_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%D_iButtonPosDefault = %iButtonPos2%
  CIcon%strCode%D_strName = %strName2%
  CIcon%strCode%D_cHotkey = %cHotkey2%
  CIcon%strCode%D_iButtonPos = %iButtonPos2%
  CIcon%strCode%D_strImage = %strImage2%
  CIcon%strCode%D_iType := kiTypeDoubleB
  m_rgCIconList%m_iCIconCount% = %strCode%D
  m_iCIconCount++
}

; constructor for Hero Spells
CIcon_CIconHS(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpell
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells with unbuttons, such as frost arrows
CIcon_CIconHSU(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellUnbutton
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%U_strNameDefault = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkeyDefault = %cHotkey%
  CIcon%strCode%U_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%U_strName = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkey = %cHotkey%
  CIcon%strCode%U_iButtonPos = %iButtonPos%
  CIcon%strCode%U_strImage = %strImage%On
  CIcon%strCode%U_iType := kiTypeHeroSpellUnbuttonB
  m_rgCIconList%m_iCIconCount% = %strCode%U
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells with no hotkey, like bash
CIcon_CIconHSN(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellNoHotkey
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells that have 2 states on and off, like mana shield
CIcon_CIconHSD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellDouble
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%D_strNameDefault = %strName2% - [|cffffcc00Level 1|r],%strName2% - [|cffffcc00Level 2|r],%strName2% - [|cffffcc00Level 3|r]
  CIcon%strCode%D_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%D_iButtonPosDefault = %iButtonPos2%
  CIcon%strCode%D_strName = %strName2%
  CIcon%strCode%D_cHotkey = %cHotkey2%
  CIcon%strCode%D_iButtonPos = %iButtonPos2%
  CIcon%strCode%D_strImage = %strImage2%
  CIcon%strCode%D_iType := kiTypeHeroSpellDoubleB
  m_rgCIconList%m_iCIconCount% = %strCode%D
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells Level 6
CIcon_CIconHS6(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellSix
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName%
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName%
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells Level 6 that have no hotkey such as reincarnation
CIcon_CIconHS6N(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  ;CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellSixNoHotkey
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName%
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName%
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells Level 6 that have 2 states, such as Tinker Tank Form and Tinker Normal Form
CIcon_CIconHS6D(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellSixDouble
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%D_strNameDefault = %strName2%
  CIcon%strCode%D_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%D_iButtonPosDefault = %iButtonPos2%
  CIcon%strCode%D_strName = %strName2%
  CIcon%strCode%D_cHotkey = %cHotkey2%
  CIcon%strCode%D_iButtonPos = %iButtonPos2%
  CIcon%strCode%D_strImage = %strImage2%
  CIcon%strCode%D_iType := kiTypeHeroSpellSixDoubleB
  m_rgCIconList%m_iCIconCount% = %strCode%D
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName%
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName%
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for icons that have a separate code for the buttonpos
CIcon_CIconSeparate(strCode, strCode2, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%

  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_code = %strCode2%
  CIcon%strCode%_iType := kiTypeSeparate
  
  m_rgCIconList%m_iCIconCount% = %strCode% 
  m_iCIconCount++
}

; constructor for Dota Hero Spells (4 levels) ***with no Learn***
CIcon_CIconDota(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpell
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  ;CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  ;CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  ;CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  ;CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  ;CIcon%strCode%L_cHotkey = %cHotkey%
  ;CIcon%strCode%L_iButtonPos := iButtonPos-2
  ;CIcon%strCode%L_strImage = %strImage%
  ;CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  ;m_rgCIconList%m_iCIconCount% = %strCode%L
  ;m_iCIconCount++
}

; constructor for Dota Hero Spells (4 levels)
CIcon_CIconHSDota(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpell
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells with unbuttons, such as frost arrows
CIcon_CIconHSDotaU(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellUnbutton
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%U_strNameDefault = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkeyDefault = %cHotkey%
  CIcon%strCode%U_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%U_strName = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkey = %cHotkey%
  CIcon%strCode%U_iButtonPos = %iButtonPos%
  CIcon%strCode%U_strImage = %strImage%On
  CIcon%strCode%U_iType := kiTypeHeroSpellUnbuttonB
  m_rgCIconList%m_iCIconCount% = %strCode%U
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells with no hotkey, like bash
CIcon_CIconHSDotaN(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellNoHotkey
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells with unbuttons, such as frost arrows
CIcon_CIconHSDotaUN(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellDotaUN
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%U_strNameDefault = |cffc3dbffRight-click to activate auto-casting.|r
  ;CIcon%strCode%U_cHotkeyDefault = %cHotkey%
  CIcon%strCode%U_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%U_strName = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkey = %cHotkey%
  CIcon%strCode%U_iButtonPos = %iButtonPos%
  CIcon%strCode%U_strImage = %strImage%On
  CIcon%strCode%U_iType := kiTypeHeroSpellUnbuttonB ; todo: change this?
  m_rgCIconList%m_iCIconCount% = %strCode%U
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; constructor for Hero Spells that have 2 states on and off, like mana shield
CIcon_CIconHSDotaD(strCode, iButtonPos, iButtonPos2, cHotkey, cHotkey2, strName, strName2, strImage, strImage2)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],,%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeHeroSpellDouble
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%D_strNameDefault = %strName2% - [|cffffcc00Level 1|r],%strName2% - [|cffffcc00Level 2|r],%strName2% - [|cffffcc00Level 3|r],%strName2% - [|cffffcc00Level 4|r]
  CIcon%strCode%D_cHotkeyDefault = %cHotkey2%
  CIcon%strCode%D_iButtonPosDefault = %iButtonPos2%
  CIcon%strCode%D_strName = %strName2% - [|cffffcc00Level 1|r],%strName2% - [|cffffcc00Level 2|r],%strName2% - [|cffffcc00Level 3|r],%strName2% - [|cffffcc00Level 4|r]
  CIcon%strCode%D_cHotkey = %cHotkey2%
  CIcon%strCode%D_iButtonPos = %iButtonPos2%
  CIcon%strCode%D_strImage = %strImage2%
  CIcon%strCode%D_iType := kiTypeHeroSpellDoubleB
  m_rgCIconList%m_iCIconCount% = %strCode%D
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-2
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-2
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}
; constructor for icons with unbuttons and no hotkey (f***ing Morphling!)
CIcon_CIconDotaUN(strCode, iButtonPos, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName% - [|cffffcc00Level 1|r],%strName% - [|cffffcc00Level 2|r],%strName% - [|cffffcc00Level 3|r],%strName% - [|cffffcc00Level 4|r]
  CIcon%strCode%_cHotkey = %cHotkey%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeDotaUN
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%U_strNameDefault = |cffc3dbffRight-click to activate auto-casting.|r
  ;CIcon%strCode%U_cHotkeyDefault = %cHotkey%
  CIcon%strCode%U_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%U_strName = |cffc3dbffRight-click to activate auto-casting.|r
  CIcon%strCode%U_cHotkey = %cHotkey%
  CIcon%strCode%U_iButtonPos = %iButtonPos%
  CIcon%strCode%U_strImage = %strImage%On
  CIcon%strCode%U_iType := kiTypeHeroSpellUnbuttonB ; todo: change this?
  m_rgCIconList%m_iCIconCount% = %strCode%U
  m_iCIconCount++
}

; constructor for Attribute Bonus for Dota
; todo: some of the regular (non learn) stuff isn't needed because it isn't shown
CIcon_CIconDotaABNorm(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeDotaAB
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-3
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-3
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_bIsUnchangeable := true
  CIcon%strCode%L_iType := kiTypeDotaABNormLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; Special Attribute Bonus for Morphling, Avatar of Vengence etc. (only the learn icon is used)
CIcon_CIconDotaABSpec(strCode, iButtonPos, cHotkey, strName, strImage)
{
  global

  CIcon%strCode%_strNameDefault = %strName%
  ;CIcon%strCode%_cHotkeyDefault = %cHotkey%
  CIcon%strCode%_iButtonPosDefault = %iButtonPos%
  CIcon%strCode%_strName = %strName%
  CIcon%strCode%_iButtonPos = %iButtonPos%
  CIcon%strCode%_strImage = %strImage%
  CIcon%strCode%_iType := kiTypeDotaAB
  m_rgCIconList%m_iCIconCount% = %strCode%
  m_iCIconCount++

  CIcon%strCode%L_strNameDefault = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkeyDefault = %cHotkey%
  CIcon%strCode%L_iButtonPosDefault := iButtonPos-3
  CIcon%strCode%L_strName = Learn %strName% - [|cffffcc00Level `%d|r]
  CIcon%strCode%L_cHotkey = %cHotkey%
  CIcon%strCode%L_iButtonPos := iButtonPos-3
  CIcon%strCode%L_strImage = %strImage%
  CIcon%strCode%L_iType := kiTypeHeroSpellLearn
  m_rgCIconList%m_iCIconCount% = %strCode%L
  m_iCIconCount++
}

; this function attaches an icon to a grid
CIcon_Load(kstrGridName, kstrIconName)
{
  global

  piButtonPos := CIcon%kstrIconName%_iButtonPos
  rgpCIconGrid%kstrGridName%%piButtonPos% = CIcon%kstrIconName%
}

CIcon_LoadUnit(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
}

CIcon_LoadUnitNoAttack(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  ;CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
}

CIcon_LoadUnitAttackGround(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  CIcon_Load(kstrGridName, "cmdattackground")
}

CIcon_LoadHero(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
  strGridNameL = %kstrGridName%L
  CIcon_Load(strGridNameL, "cmdcancel")
}

CIcon_LoadHeroNoCancel(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
}

CIcon_LoadHeroDota(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  ;CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
  CIcon_Load(kstrGridName, "aamk")
  strGridNameL = %kstrGridName%L
  CIcon_Load(strGridNameL, "cmdcancel")
  CIcon_Load(strGridNameL, "aamkL")
}

; No Cancel
CIcon_LoadHeroDotaNoCancel(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  ;CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
  CIcon_Load(kstrGridName, "aamk")
  ;strGridNameL = %kstrGridName%L
  ;CIcon_Load(strGridNameL, "cmdcancel")
 ; CIcon_Load(strGridNameL, "aamkL")
}

; for dota heros WITHOUT the yellow cross
CIcon_LoadHeroDotaNoAttrib(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  ;CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
  ;CIcon_Load(kstrGridName, "aamk")
  strGridNameL = %kstrGridName%L
  CIcon_Load(strGridNameL, "cmdcancel")
  ;CIcon_Load(strGridNameL, "aamkL")
}

; for dota heros WITHOUT the yellow cross and no cancel
CIcon_LoadHeroDotaNoAttribNoCancel(kstrGridName)
{
  global
  
  CIcon_Load(kstrGridName, "cmdmove")
  CIcon_Load(kstrGridName, "cmdstop")
  CIcon_Load(kstrGridName, "cmdholdpos")
  CIcon_Load(kstrGridName, "cmdattack")
  CIcon_Load(kstrGridName, "cmdpatrol")
  ;CIcon_Load(kstrGridName, "ashm") ; hide
  CIcon_Load(kstrGridName, "cmdselectskill")
  ;CIcon_Load(kstrGridName, "aamk")
  ;strGridNameL = %kstrGridName%L
  ;CIcon_Load(strGridNameL, "cmdcancel")
  ;CIcon_Load(strGridNameL, "aamkL")
}

CIcon_LoadHS(kstrGridName, kstrIconName)
{
  global
  
  CIcon_Load(kstrGridName, kstrIconName)
  strGridNameL = %kstrGridName%L
  strIconNameL = %kstrIconName%L
  CIcon_Load(strGridNameL, strIconNameL)
}

CIcon_LoadBuilding(kstrGridName)
{
  global

  CIcon_Load(kstrGridName, "cmdrally")
  CIcon_Load(kstrGridName, "cmdcancelbuild")
}

; This function checks the icon to see if it is a double or triple
;  and updates the 2nd and 3rd icon button positions if necessary
CIcon_Update(pCIcon, iPosition)
{
  global

  CIcon_UpdateTiny(pCIcon, iPosition)
  
  if ( (%pCIcon%_iType == kiTypeNormal2) || (%pCIcon%_iType == kiTypeNormal3) )
  {
    pCIconA = %pCIcon%A
    CIcon_UpdateTiny(pCIconA, iPosition)
  }
  if (%pCIcon%_iType == kiTypeNormal3)
  {
    pCIconB = %pCIcon%B
    CIcon_UpdateTiny(pCIconB, iPosition)
   }
}

; This function moves the icon to a new position and if Force Grid Align is on
;  it changes the hotkey
CIcon_UpdateTiny(pCIcon, iPosition)
{
  global

  %pCIcon%_iButtonPos = %iPosition%

  if (%pCIcon%_bIsUnchangeable == true)
    return

  if (bOpForceGridAlign == true)
  {
    strHotkeyTemp = %pCIcon%_cHotkey
    iCurrentButtonPosTemp := %pCIcon%_iButtonPos
    GridAlignHotKey(strHotkeyTemp, iCurrentButtonPosTemp)
  }  
}

CIcon_IsValidHotkey(cInput)
{
  if (cInput == "A")
    Return true
  else if (cInput == "B")
    Return true
  else if (cInput == "C")
    Return true
  else if (cInput == "D")
    Return true
  else if (cInput == "E")
    Return true
  else if (cInput == "F")
    Return true
  else if (cInput == "G")
    Return true
  else if (cInput == "H")
    Return true
  else if (cInput == "I")
    Return true
  else if (cInput == "J")
    Return true
  else if (cInput == "K")
    Return true
  else if (cInput == "L")
    Return true
  else if (cInput == "M")
    Return true
  else if (cInput == "N")
    Return true
  else if (cInput == "O")
    Return true
  else if (cInput == "P")
    Return true
  else if (cInput == "Q")
    Return true
  else if (cInput == "R")
    Return true
  else if (cInput == "S")
    Return true
  else if (cInput == "T")
    Return true
  else if (cInput == "U")
    Return true
  else if (cInput == "V")
    Return true
  else if (cInput == "W")
    Return true
  else if (cInput == "X")
    Return true
  else if (cInput == "Y")
    Return true
  else if (cInput == "Z")
    Return true
  else if (cInput == "ESC")
    Return true
      
  return false
}


; run this program in case someone decided to change the cfg file manually
CIcon_ResetUnchangeables()
{
  global CIconcmdcancel_cHotkey, CIconaamkL_cHotkey, CIconcmdcancel_iButtonPos, CIconcmdcancelbuild_iButtonPos
  
  ; these hotkeys cannot be changed
  ;CIconcmdcancel_cHotkey = ESC
  CIconaamkL_cHotkey = U
  CIconcmdcancel_iButtonPos := CIconcmdcancelbuild_iButtonPos
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;   Menus  ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GuiInit() initializes the Gui
;  mnuFileNew:
;  mnuFileOpen:
;  mnuFileSave:
;  mnuFileSaveAs:
;  mnuOptionsLoadCfgOnStartup:
;  mnuHelpAbout:
;   LaunchHomePage:
;   LaunchEmail:
;
; 2ButtonOK:
; 2GuiClose:
; 2GuiEscape:
;
; Button1:
; Button2:
;   4ButtonOK:
;   4GuiClose:
;   4GuiEscape:
;   4ButtonCancel:
; Button3:
; Button4:
;
; CheckboxGridAlign:
; CheckboxHideHotkeys:
;
; grid0 -> grid11
;
; GuiINIRead()
; bool GuiDirtyCheck() returns 0 if the user cancels
; GetNewHotKey() gets a new hotkey
;
; int Char2Num(cInput)
; SetNewHotKey()
; GuiHotkeysOn()
; GuiHotkeysOff()
;
; 3ButtonOK:
; 3GuiClose:
; 3GuiEscape:
; 3ButtonCancel:
;
; GuiTextUpdate()
; OnClickGrid(iGridnum)
;
; GuiRefreshWinName()
; GuiRefresh() refreshes the window name, current grid, etc


; Initials the main Gui Window
; this func can only be called at the beginning of the program and only once
GuiInit()
{
  global

  ; Main Menu creation
  Menu, mnuFile, Add, &New, mnuFileNew
  Menu, mnuFile, Add, &Open..., mnuFileOpen
  Menu, mnuFile, Add,
  Menu, mnuFile, Add, &Save, mnuFileSave
  Menu, mnuFile, Add, Save As..., mnuFileSaveAs
  Menu, mnuFile, Add
  Menu, mnuFile, Add, Exit, mnuFileExit
  ;Menu, mnuOptions, Add, %kstrLoadCfg%, mnuOptionsLoadCfgOnStartup
  Menu, mnuImport, Add, Import Warkeys Config File, mnuImportScript
  Menu, mnuImport, Add, Import CustomKeys.txt, mnuImportCustomkeys
  
  /*
  if (bOpLoadCfgOnStartup == true)
    Menu, mnuOptions, Check, %kstrLoadCfg%
  else
    Menu, mnuOptions, UnCheck, %kstrLoadCfg%
  */
  Menu, mnuOptions, Add, Program Settings, mnuOptionsSettings
  
  Menu, mnuHelp, Add, Check for Update, mnuHelpUpdate
  Menu, mnuHelp, Add,
  Menu, mnuHelp, Add, About, mnuHelpAbout
  
  Menu, MainMenu, Add, &File, :mnuFile ; Adds FileMenu to MainMenu
  Menu, MainMenu, Add, &Options, :mnuOptions ; Adds OptionMenu to MainMenu
  Menu, MainMenu, Add, &Import, :mnuImport ; Adds OptionMenu to MainMenu
  Menu, MainMenu, Add, &Help, :mnuHelp ; Adds HelpMenu to MainMenu

  ;Gui, Add, Button, x16 y320 w110 h40 gButton1, Align Keys to %WarkeysGrid0_cHotkey%%WarkeysGrid3_cHotkey%%WarkeysGrid6_cHotkey%%WarkeysGrid9_cHotkey%, %WarkeysGrid1_cHotkey%%WarkeysGrid4_cHotkey%%WarkeysGrid7_cHotkey%%WarkeysGrid10_cHotkey%, %WarkeysGrid2_cHotkey%%WarkeysGrid5_cHotkey%%WarkeysGrid8_cHotkey%%WarkeysGrid11_cHotkey% grid
  ;Gui, Add, Button, x16 y320 w110 h40 gButton1, Align Keys to QWER, ASDF, ZXCV grid
  Gui, Add, Button, x16 y320 w110 h40 gButton1, Align Keys based on grid position    
  Gui, Add, Button, x146 y320 w110 h40 gButton2, Set Keys to Default
  Gui, Add, Button, x276 y320 w110 h40 gButton3, Change Text Color
  Gui, Add, Button, x406 y320 w110 h40 gButton4, Save to CustomKeys.txt

  Gui, Add, Checkbox, x536 y320 w120 h20 gCheckboxGridAlign vbOpForceGridAlign Checked%bOpForceGridAlign%, Force Grid Align
  Gui, Add, Checkbox, x536 y340 w200 h20 gCheckboxHideHotkeys vbOpHideHotkeys Checked%bOpHideHotkeys%, Hide Hotkeys/Edit Strings

  ; Add images
  Gui, Add, Pic, %kstrGridposbackground%, %ImageDir%\backgrnd.bmp
  Gui, Font, s20 c%strTextColor%
  Gui, Add, Text, %kstrTextPos%, 
  
  i := 0
  loop, 12
  {
  
    temp := rgstrGridpos%i%
    Gui, Add, Pic, %temp%, %ImageDir%\%kstrBlankImage%.jpg
    GuiControlGet, rgImage%i%
    
    temp := rgstrGridText%i%
    Gui, Add, Text, %temp%, A
    GuiControlGet, rgText%i%
    GuiControl, Hide, rgText%i%
     
    i++
  }
  Gui, Show, %kstrGuiMainWin%, %WindowName%
  Gui, Menu, MainMenu ; Creates MainMenu control on gui
}

; Creates a New File and prompts to save the old one if it's dirty
mnuFileNew:
bReturn := GuiDirtyCheck()
if (bReturn == 0)
  return
strFileCfg =
IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg
GridLoadCmds()
if (bOpForceGridAlign == true)
  GridAlign()
bIsFileDirty := false
GuiRefresh()
return

; Open a Warkeys file and prompt to save the old one if dirty
mnuFileOpen:
bReturn := GuiDirtyCheck()
if (bReturn == 0)
  return
Gui +OwnDialogs
FileSelectFile, strSelectedFileName, 3, %A_WorkingDir%, Open File, Warkeys Config File (*.cfg)
if strSelectedFileName =  ; No file selected.
	return
if (FileLoad(strSelectedFileName) == false) ; invalid file
  return
strFileCfg = %strSelectedFileName%
IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg
bIsFileDirty := false
if (bOpForceGridAlign == true)
  GridAlign()
GuiRefresh()
Return

; Save the current file, go to save as if the user has not chosen a file name
;^s::
mnuFileSave:
FileSave:
if strFileCfg =
  GoSub, FileSaveAs
else
  FileSave()
if strFileCfg =
  return
bIsFileDirty := false
GuiRefreshWinName()
Return

; Prompt the user for a file name and save it
mnuFileSaveAs:
FileSaveAs:
kstrDotCfg = `.cfg
FileSelectFile, strSelectedFileName, S16,, Save File, Warkeys Config File (*.cfg)
if strSelectedFileName =  ; No file selected.
	return
StringRight, strNameEnd, strSelectedFileName, 4
if (kstrDotCfg != strNameEnd) ; user does not type in .cfg
{
  FileDelete, %strSelectedFileName%
  strSelectedFileName = %strSelectedFileName%.cfg
}
;StringRight, strNameEnd, strSelectedFileName, 5
;if (kstrSlashDotCfg == strNameEnd) ; user only typed .cfg
;  return
;msgbox, file name ok
strFileCfg = %strSelectedFileName%
IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg
FileSave()
bIsFileDirty := false
GuiRefreshWinName()
Return

mnuFileExit:
FileExit:
Exit:
bReturn := GuiDirtyCheck()
if (bReturn == 0)
  return
ExitApp
Return

mnuImportScript:
DI()
Gui +OwnDialogs
FileSelectFile, strSelectedFileName, 3, %A_WorkingDir%, Open File, Warkeys Config File (*.cfg)
if not strSelectedFileName
{
  EI()
  Return
}

Gui, 4:+owner1
Gui, 1:+Disabled  ; Disable main window.
Gui, 4:Add, Text, , Choose which options to set to load from the script file:
Gui, 4:Add, Checkbox, x25 y25 w120 h20 gCheckboxGui4Hotkeys vbGui4CheckHotkeys Checked0, Load Hotkeys
Gui, 4:Add, Checkbox, x25 y50 w200 h20 gCheckboxGui4Buttonpos vbGui4CheckButtonpos Checked0, Load Button Positions
Gui, 4:Add, Checkbox, x25 y75 w200 h20 gCheckboxGui4Strings vbGui4CheckStrings Checked0, Load Descriptions
Gui, 4:Add, Button, Default w120 h25 x10 y120, OK
Gui, 4:Add, Button, w120 h25 x150 y120, Cancel
Gui, 4:Show, x200 y200 h150 w300, Import Options, Choose which parts of the Script file to Import:

bIsGui4Destroyed := false
DI() ; disable interrupts
Loop
{
  if (bIsGui4Destroyed == true)
    break
  Sleep, 50
}
if (bIsGui4Canceled == false)
{
  Gui, 4:Submit
  if (FileLoad(strSelectedFileName, bGui4CheckHotkeys, bGui4CheckButtonpos, bGui4CheckStrings) != false) ; valid file
    bIsFileDirty := true
}
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui, 4:Destroy  ; Destroy the about box.

CIcon_ResetUnchangeables()

;bIsFileDirty := true
EI() ; enable interrupts
GuiRefresh()
Return

mnuImportCustomkeys:
DI()
Gui +OwnDialogs
FileSelectFile, strSelectedFileName, 3, %kstrWar3Path%\CustomKeys.txt, Open File, Custom Keys File (*.txt)
if not strSelectedFileName
{
  EI()
  Return
}

Gui, 4:+owner1
Gui, 1:+Disabled  ; Disable main window.
Gui, 4:Add, Text, , Choose which options to set to load from the Custom Keys file:
Gui, 4:Add, Checkbox, x25 y25 w120 h20 gCheckboxGui4Hotkeys vbGui4CheckHotkeys Checked0, Load Hotkeys
Gui, 4:Add, Checkbox, x25 y50 w200 h20 gCheckboxGui4Buttonpos vbGui4CheckButtonpos Checked0, Load Button Positions
Gui, 4:Add, Checkbox, x25 y75 w200 h20 gCheckboxGui4Strings vbGui4CheckStrings Checked0, Load Descriptions
Gui, 4:Add, Button, Default w120 h25 x10 y120, OK
Gui, 4:Add, Button, w120 h25 x150 y120, Cancel
Gui, 4:Show, x200 y200 h150 w300, Import Options, Choose which parts of the Custom Keys file to Import:

bIsGui4Destroyed := false
Loop
{
  if (bIsGui4Destroyed == true)
    break
  Sleep, 50
}
if (bIsGui4Canceled == false)
{
 Gui, 4:Submit
 if ( (bGui4CheckHotkeys == false) && (bGui4CheckButtonpos == false) && (bGui4CheckStrings == false) )
 {
   Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
   Gui, 4:Destroy  ; Destroy the about box.
   GuiRefresh()
   Return
 }
 
 Loop, Read, %strSelectedFileName%
 {
  StringLeft, cFirstChar, A_LoopReadLine, 1
  StringLeft, cSecondChar, A_LoopReadLine, 2
  StringRight, cSecondChar, cSecondChar, 1
  
  if ( (cFirstChar == "[") && (cSecondChar != "|") )
  {
    StringTrimLeft, strCode, A_LoopReadLine, 1 
    ;StringTrimRight, strCode, strCode, 1
    StringGetPos, iPosEndBracket, strCode, ]
    ;iPosEndBracket += 2
    StringLeft, strCode, strCode, %iPosEndBracket%
    
    ;msgbox, strCode = %strCode%, iPosEndBracket = %iPosEndBracket%

    IfInString, strCode, ]
    {
      Gui +OwnDialogs
      Msgbox, 0, Error!, There was error reading line %A_LoopReadLine% at line %A_Index%.  Aborting.
      break
    }
  }
  ; comments, etc. Keycraft generated files has an error at the beginning ï is the first char
  else if ( (cFirstChar == "/") || (cFirstChar == " ") || (not cFirstChar) || (cFirstChar == "ï") )
  {
    ; ignore comments
  }
  else
  {
    ; Some Customkeys generated by Keycraft have descriptions on more than 1 line
    if ( (cFirstChar != "[") && (cSecondChar != "|") )
    {
      ;StringSplit, rgstrTemp, A_LoopReadLine, =,
      StringSplit, rgstrTemp, A_LoopReadLine, =
      StringLower, rgstrTemp1, rgstrTemp1
    }

    ; Tips
    if (rgstrTemp1 == "tip")
    {
     if (bGui4CheckStrings == true)
     { 
      CIcon%strCode%_strName =
    
      ; if the tip is made by warkeys or keycraft, it will contain the hotkey info, so we remove it
      StringLeft, cFirstChar, rgstrTemp2, 1
      
      if (cFirstChar == kcQuote)
      {
        ; the first and last chars in the description is a quote, remove it
        StringTrimLeft, rgstrTemp2, rgstrTemp2, 1
        StringTrimRight, rgstrTemp2, rgstrTemp2, 1
      
        StringLeft, cFirstChar, rgstrTemp2, 1
      }
            
      if (cFirstChar == "(")
      {
        StringSplit, rgstrTips, rgstrTemp2, `,
      
        Loop, %rgstrTips0%
        {
          StringGetPos, iPosCloseParen, rgstrTips%A_Index%, )
          iPosCloseParen += 2
          StringTrimLeft, rgstrTips%A_Index%, rgstrTips%A_Index%, %iPosCloseParen%
          if not CIcon%strCode%_strName
            CIcon%strCode%_strName := rgstrTips%A_Index%
          else
           CIcon%strCode%_strName := CIcon%strCode%_strName . "," . rgstrTips%A_Index%
        }
      }
      else
        CIcon%strCode%_strName := rgstrTemp2
     }
    }
    else if (rgstrTemp1 == "untip")
    {
     if (bGui4CheckStrings == true)
     {
      CIcon%strCode%U_strName =
    
      ; if the tip is made by warkeys or keycraft, it will contain the hotkey info, so we remove it
      StringLeft, cFirstChar, rgstrTemp2, 1
      
      if (cFirstChar == kcQuote)
      {
        ; the first and last chars in the description is a quote, remove it
        StringTrimLeft, rgstrTemp2, rgstrTemp2, 1
        StringTrimRight, rgstrTemp2, rgstrTemp2, 1
      
        StringLeft, cFirstChar, rgstrTemp2, 1
      }
      
      if (cFirstChar == "(")
      {
        StringSplit, rgstrTips, rgstrTemp2, `,
      
        Loop, %rgstrTips0%
        {
          StringGetPos, iPosCloseParen, rgstrTips%A_Index%, )
          iPosCloseParen += 2
          StringTrimLeft, rgstrTips%A_Index%, rgstrTips%A_Index%, %iPosCloseParen%
          if not CIcon%strCode%U_strName
            CIcon%strCode%U_strName := rgstrTips%A_Index%
          else
            CIcon%strCode%U_strName := CIcon%strCode%U_strName . "," . rgstrTips%A_Index%
        }
      }
      else
        CIcon%strCode%U_strName := rgstrTemp2
     }
    }
    else if (rgstrTemp1 == "researchtip")
    {
     if (bGui4CheckStrings == true)
     {
      CIcon%strCode%L_strName =
    
      ; if the tip is made by warkeys or keycraft, it will contain the hotkey info, so we remove it
      StringLeft, cFirstChar, rgstrTemp2, 1
      
      if (cFirstChar == kcQuote)
      {
        ; the first and last chars in the description is a quote, remove it
        StringTrimLeft, rgstrTemp2, rgstrTemp2, 1
        StringTrimRight, rgstrTemp2, rgstrTemp2, 1
      
        StringLeft, cFirstChar, rgstrTemp2, 1
      }
       
      if (cFirstChar == "(")
      {
        StringSplit, rgstrTips, rgstrTemp2, `,
      
        Loop, %rgstrTips0%
        {
          StringGetPos, iPosCloseParen, rgstrTips%A_Index%, )
          iPosCloseParen += 2
          StringTrimLeft, rgstrTips%A_Index%, rgstrTips%A_Index%, %iPosCloseParen%
          if not CIcon%strCode%L_strName
            CIcon%strCode%L_strName := rgstrTips%A_Index%
          else
            CIcon%strCode%L_strName := CIcon%strCode%L_strName . "," . rgstrTips%A_Index%
        }
      }
      else
      {
        ;msgbox, rgstrTemp2 = %rgstrTemp2%, cFirstChar = %cFirstChar%
        CIcon%strCode%L_strName := rgstrTemp2
      }
     }
    }
    else if (rgstrTemp1 == "revivetip")
    {
      ; if (bGui4CheckStrings == true)
      ; ignore revivetip
    }
    else if (rgstrTemp1 == "awakentip")
    {
      CIcon%strCode%_strName =
    
      ; if the tip is made by warkeys or keycraft, it will contain the hotkey info, so we remove it
      StringLeft, cFirstChar, rgstrTemp2, 1
      if (cFirstChar == "(")
      {
        StringGetPos, iPosCloseParen, rgstrTemp2, )
        iPosCloseParen += 2
        StringTrimLeft, rgstrTemp2, rgstrTemp2, %iPosCloseParen%
        
        StringLeft, strTest, rgstrTemp2, 6
        
        if ( strTest == "Awaken" )
           StringTrimLeft, rgstrTemp2, rgstrTemp2, 7
        
        CIcon%strCode%_strName := rgstrTemp2
      }

      ; ignore awakentip
    }
    ; Hotkeys
    else if (rgstrTemp1 == "hotkey")
    {
      if (bGui4CheckHotkeys == true)
      {
        StringSplit, rgstrHotkeys, rgstrTemp2, `,

        if ( CIcon_IsValidHotkey(rgstrHotkeys1) )
          CIcon%strCode%_cHotkey = %rgstrHotkeys1%
        
        if ( (rgstrHotkeys0 >= 2) && (CIcon_IsValidHotkey(rgstrHotkeys2)) )
          CIcon%strCode%A_cHotkey = %rgstrHotkeys2%
        if ( (rgstrHotkeys0 >= 3) && (CIcon_IsValidHotkey(rgstrHotkeys3)) )
          CIcon%strCode%B_cHotkey = %rgstrHotkeys3%
      }
    }
    else if (rgstrTemp1 == "unhotkey")
    {
      if ( (bGui4CheckHotkeys == true) && (CIcon_IsValidHotkey(rgstrTemp2)) )
      {
        if CIcon%strCode%U_cHotkey
          CIcon%strCode%U_cHotkey = %rgstrTemp2%
        else
          CIcon%strCode%D_cHotkey = %rgstrTemp2%
      }
    }
    else if (rgstrTemp1 == "researchhotkey")
    {
      if ( (bGui4CheckHotkeys == true) && (CIcon_IsValidHotkey(rgstrTemp2)) )
        CIcon%strCode%L_cHotkey = %rgstrTemp2%
    }
    ; Buttons 
    else if (rgstrTemp1 == "buttonpos")  
    {
      if (bGui4CheckButtonpos == true)
      {
        StringSplit, iButtonPos, rgstrTemp2, `,
        
        iNum := 3*iButtonPos1 + iButtonPos2
        if ( (iNum >= 0) && (iNum <= 11) )
        {
          CIcon%strCode%_iButtonPos := iNum
        
          ; check blacksmith etc.
          if ((CIcon%strCode%_iType == kiTypeNormal2) || (CIcon%strCode%_iType == kiTypeNormal3))
            CIcon%strCode%A_iButtonPos := iNum
          if (CIcon%strCode%_iType == kiTypeNormal3)
            CIcon%strCode%B_iButtonPos := iNum
        }
      }
    }
    else if (rgstrTemp1 == "unbuttonpos")
    {
      if (bGui4CheckButtonpos == true)
      {
        StringSplit, iButtonPos, rgstrTemp2, `,

        iNum := 3*iButtonPos1 + iButtonPos2
        if ( (iNum >= 0) && (iNum <= 11) )
        {
          if CIcon%strCode%U_iButtonPos
            CIcon%strCode%U_iButtonPos := iNum
          else ; it should be double
            CIcon%strCode%D_iButtonPos := iNum
        }
      }
    }
    else if (rgstrTemp1 == "researchbuttonpos") 
    {
      if (bGui4CheckButtonpos == true)
      {
        StringSplit, iButtonPos, rgstrTemp2, `,
        iNum := 3*iButtonPos1 + iButtonPos2
        if ( (iNum >= 0) && (iNum <= 11) )
          CIcon%strCode%L_iButtonPos := iNum
      }
    }
    else if (rgstrTemp1 == "minimapsignal")  || (rgstrTemp1 == "minimapterrain")
      || (rgstrTemp1 == "minimapcolors") || (rgstrTemp1 == "minimapcreeps")
      || (rgstrTemp1 == "formationtoggle")
    {
      ; ignore old hotkeys for minimap
    }
    else if ( (rgstrTemp1 == "editorsuffix") || (rgstrTemp1 == "art") 
      || (rgstrTemp1 == "placementmodel") || (rgstrTemp1 == "name")
      || (rgstrTemp1 == "ubertip") )
    {
      ; I wonder what these things are for... well cant' do übertips for sure
    }
    else
    {
      ;listvars
      Gui +OwnDialogs
      MsgBox, 0, Error!, Unknown Command Found in Custom Keys File: %rgstrTemp1% on line %A_Index%`nFile Reading Aborted.
      break
    }
  }
 }
}
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui, 4:Destroy  ; Destroy the about box.

CIcon_ResetUnchangeables()

bIsFileDirty := true
GuiRefresh()
EI()
Return


OnExit, FileExit

GuiClose:
GoSub, FileExit
return

mnuHelpUpdate:
IfNotExist, update\Warkeys Update.exe
{
  Gui +OwnDialogs
  MsgBox, 0, Auto Update Missing!, Warkeys cannot find "Warkeys Update.exe". Please reinstall warkeys.
}
else
{
  Run, update\Warkeys Update.exe
  Gui +OwnDialogs
  MsgBox, 0, Checking for Update, Warkeys Update is now running in the system tray.`nYou will recieve a notification if an update is available.
}
Return

mnuHelpAbout:
Gui, 2:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui +Disabled  ; Disable main window.
Gui, 2:Add, Text,, Warkeys`nVersion %ScriptVersion%`n`nWarkeys coded by John Schroeder (Open Source) 2006
Gui, 2:Font, underline
Gui, 2:Add, Text, cBlue gLaunchHomePage, Homepage: http://warkeys.sourceforge.net/
Gui, 2:Add, Text, cBlue gLaunchEmail, Email: points@san.rr.com (include Warkeys in the subject line)
Gui, 2:Font, norm
Gui, 2:Add, Text,, Thanks to Keycraft for the orignal concept, Micha for tree support`nRajat for his SmartGUI Creator, Melissa for getting rid of all the acorns
Gui, 2:Add, Text,, And of course thanks to Chris for helping to make autohotkey,`nthis forum and the file server, and for answering all my questions. 
Gui, 2:Add, Button, Default x125 w100 h25, OK
Gui, 2:Show
Return

LaunchHomePage:
Run, http://warkeys.sourceforge.net/
return

LaunchEmail:
Run, mailto:points@san.rr.com?subject=Warkeys
return

2ButtonOK:
2GuiClose:
2GuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
return

mnuOptionsSettings:
{
  Gui, 5:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
  Gui +Disabled  ; Disable main window.

  ;Gui, 5:Add, ListBox, x16 y10 w160 h340 Choose1 gGui5ListSelect vstrGui5ListSelect, Warkeys Behavior|Options|Messages|Updates
  Gui, 5:Add, ListBox, x16 y10 w160 h340 Choose1 gGui5ListSelect vstrGui5ListSelect, Warkeys Behavior|Messages|Updates

  Gui, 5:Add, Checkbox, x196 y10 w400 h30 vbGui5OpTrayIcon Checked%bOpTrayIcon%, Enable Tray Icon
  Gui, 5:Add, Checkbox, x196 y40 w400 h30 vbGui5OpMultiple Checked%bOpMultiple%, Allow Multiple Instances
  Gui, 5:Add, Checkbox, x196 y70 w400 h30 vbGui5OpLoadCfgOnStartup Checked%bOpLoadCfgOnStartup%, Load Last cfg on Startup
  Gui, 5:Add, Checkbox, x196 y100 w400 h30 vbGui5OpDotaDefault Checked%bOpDotaDefault%, New cfg files default to Dota compatiable
  
  Gui, 5:Add, Checkbox, x196 y10 w400 h30 vbGui5OpHideMsgNoWarDir Checked%bOpHideMsgNoWarDir%, Disable Warning about warcraft directory not found

  Gui, 5:Add, Checkbox, x196 y10 w400 h30 vbGui5OpCheckUpdatesOnStartup Checked%bOpCheckUpdatesOnStartup%, Check for updates on Warkeys Startup
  Gui, 5:Add, Checkbox, x196 y40 w400 h30 vbGui5OpCheckUpdatesOnWinStartup Checked%bOpCheckUpdatesOnWinStartup%, Check for updates on Windows Startup

  Gui, 5:Add, Button, Default w120 h25 x10 y350, OK
  Gui, 5:Add, Button, w120 h25 x150 y350, Cancel
  ;Gui, 5:Add, Button, w120 h25 x290 y350, Apply


  GuiControl, 5:Show, bGui5OpTrayIcon
  GuiControl, 5:Show, bGui5OpMultiple
  GuiControl, 5:Show, bGui5OpLoadCfgOnStartup
  GuiControl, 5:Show, bGui5OpDotaDefault

  GuiControl, 5:Hide, bGui5OpHideMsgNoWarDir

  GuiControl, 5:Hide, bGui5OpCheckUpdatesOnStartup
  GuiControl, 5:Hide, bGui5OpCheckUpdatesOnWinStartup
  
  Gui, 5:Show, x200 y200 h385 w500, Warkeys Options

  bIsGui5Destroyed := false
  DI() ; disable interrupts
  Loop
  {
    if (bIsGui5Destroyed == true)
      break
    Sleep, 50
  }
  if (bIsGui5Canceled == false)
  {
    ; Warkeys options
    Gui, 5:Submit, NoHide
    if (bGui5OpTrayIcon != bOpTrayIcon)
    {
      bOpTrayIcon := bGui5OpTrayIcon
      IniWrite, %bOpTrayIcon%, %kstrINI%, warkeys, bOpTrayIcon
      if (bOpTrayIcon == false)
        menu, tray, NoIcon
      else ;if (bOpTrayIcon == true)
        menu, tray, Icon
    }
    if (bGui5OpMultiple != bOpMultiple)
    {
      bOpMultiple := bGui5OpMultiple
      IniWrite, %bOpMultiple%, %kstrINI%, warkeys, bOpMultiple
    }
    if (bGui5OpLoadCfgOnStartup != bOpLoadCfgOnStartup)
    {
      bOpLoadCfgOnStartup := bGui5LoadCfgOnStartup
      IniWrite, %bOpLoadCfgOnStartup%, %kstrINI%, warkeys, bOpLoadCfgOnStartup
    }   
    if (bGui5OpDotaDefault != bOpDotaDefault)
    {
      bOpDotaDefault := bGui5OpDotaDefault
      IniWrite, %bOpDotaDefault%, %kstrINI%, warkeys, bOpDotaDefault
    }
    
    ;Messages
    if (bGui5OpHideMsgNoWarDir != bOpHideMsgNoWarDir)
    {
      bOpHideMsgNoWarDir := bGui5OpHideMsgNoWarDir
      IniWrite, %bOpHideMsgNoWarDir%, %kstrINI%, messages, bOpHideMsgNoWarDir
    }
    
    ;Updates   
    if (bGui5OpCheckUpdatesOnStartup != bOpCheckUpdatesOnStartup)
    {
      bOpCheckUpdatesOnStartup := bGui5OpCheckUpdatesOnStartup
      IniWrite, %bOpCheckUpdatesOnStartup%, %kstrINI%, updates, bOpCheckUpdatesOnStartup
    }
    if (bGui5OpCheckUpdatesOnWinStartup != bOpCheckUpdatesOnWinStartup)
    {
      bOpCheckUpdatesOnWinStartup := bGui5OpCheckUpdatesOnWinStartup
      ;IniWrite, %bOpCheckUpdatesOnWinStartup%, %kstrINI%, updates, bOpCheckUpdatesOnWinStartup
      if (bOpCheckUpdatesOnWinStartup == false)
        FileDelete, %A_Startup%\Warkeys Update.lnk
      else ;if (bOpCheckUpdatesOnWinStartup == true)
        FileCopy, %A_WorkingDir%\Warkeys Update.lnk, %A_Startup%\
    }    
  }
  Gui, 1:-Disabled
  Gui, 5:Destroy
  ;bIsFileDirty := true
  EI() ; enable interrupts
  GuiRefresh()
}
Return

Gui5ListSelect:
Gui, 5:Submit, NoHide

GuiControl, 5:Hide, bGui5OpTrayIcon
GuiControl, 5:Hide, bGui5OpMultiple
GuiControl, 5:Hide, bGui5OpLoadCfgOnStartup
GuiControl, 5:Hide, bGui5OpDotaDefault

GuiControl, 5:Hide, bGui5OpHideMsgNoWarDir

GuiControl, 5:Hide, bGui5OpCheckUpdatesOnStartup
GuiControl, 5:Hide, bGui5OpCheckUpdatesOnWinStartup

if (strGui5ListSelect == "Warkeys Behavior")
{
  GuiControl, 5:Show, bGui5OpTrayIcon
  GuiControl, 5:Show, bGui5OpMultiple
  GuiControl, 5:Show, bGui5OpLoadCfgOnStartup
  GuiControl, 5:Show, bGui5OpDotaDefault
}
else if (strGui5ListSelect == "Messages")
{
  GuiControl, 5:Show, bGui5OpHideMsgNoWarDir
}
else if (strGui5ListSelect == "Updates")
{
  GuiControl, 5:Show, bGui5OpCheckUpdatesOnStartup
  GuiControl, 5:Show, bGui5OpCheckUpdatesOnWinStartup
}
Gui, 5:Show, x200 y200 h385 w500, Warkeys Options
Return

/*
Gui5Multiple:
GuiControl, , bGui5Multiple, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5LoadLast:
;GuiControl, , bGui5LoadLast, 0
;Gui +OwnDialogs
;MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5DotaDefault:
GuiControl, , bGui5DotaDefault, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5Unbutton:
GuiControl, , bGui5Unbutton, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5Double:
GuiControl, , bGui5Double, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5SaveOnExit:
GuiControl, , bGui5SaveOnExit, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5DirNotFound:
GuiControl, , bGui5DirNotFound, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5CfgFileNotFound:
GuiControl, , bGui5CfgFileNotFound, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5Update1:
GuiControl, , bGui5Update1, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return

Gui5Update2:
GuiControl, , bGui5Update2, 0
Gui +OwnDialogs
MsgBox, 0, Feature Unvailable!, This feature is not ready.
Return
*/

5ButtonOK:
bIsGui5Destroyed := true
bIsGui5Canceled := false
return

5GuiClose:
5ButtonCancel:
bIsGui5Destroyed := true
bIsGui5Canceled := true
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;  Buttons ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Button1:
if (bOpForceGridAlign == true)
{
  Gui +OwnDialogs
  msgbox, 0, Hotkeys already Aligned, Hotkeys are already Aligned to grid.`nForce Grid Align is currently on.
  return
}
Gui +OwnDialogs
msgbox, 4, Grid Align, This will Align all Hotkeys based on their grid position`nContinue?
IfMsgBox, No
	return
bIsFileDirty := true
GridAlign()
GuiRefresh()
return

Button2:
{
  Gui, 4:+owner1
  Gui +Disabled  ; Disable main window.
  ;Gui +OwnDialogs
  ;msgbox, 4, Set keys to Default, Set all Hotkeys to their default value?
  ;Gui, 4:Add, Pic, w128 h128 y10, %ImageDir%\%strImageName%.jpg
  ;Gui, 4:Add, Text, w128, %strIconName%
  ;Gui, 4:Add, Text, , Default Hotkey = %strLabelDefault%`n`nCurrent Hotkey = %ListboxHotkeyChoice%
  ;Gui, 4:Add, ListBox, x150 y10 vListboxHotkeyChoice Choose%iListboxChoice% r27, A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|ESC
  Gui, 4:Add, Text, , Choose which options to set to default:
  Gui, 4:Add, Checkbox, x25 y25 w120 h20 gCheckboxGui4Hotkeys vbGui4CheckHotkeys Checked0, Reset Hotkeys
  Gui, 4:Add, Checkbox, x25 y50 w200 h20 gCheckboxGui4Buttonpos vbGui4CheckButtonpos Checked0, Reset Button Positions
  Gui, 4:Add, Checkbox, x25 y75 w200 h20 gCheckboxGui4Strings vbGui4CheckStrings Checked0, Reset Strings
  Gui, 4:Add, Button, Default w120 h25 x10 y120, OK
  Gui, 4:Add, Button, w120 h25 x150 y120, Cancel
  Gui, 4:Show, x200 y200 h150 w300, Set keys to Default, Set all Hotkeys to their default value?

  bIsGui4Destroyed := false
  DI() ; disable interrupts
  Loop
  {
    if (bIsGui4Destroyed == true)
      break
    Sleep, 50
  }
  if (bIsGui4Canceled == false)
  {
    Gui, 4:Submit
    if (bGui4CheckHotkeys == true)
    {
      bIsFileDirty := true
      Loop
      {
        if (A_Index >= m_iCIconCount)
          break
      
        pCIconListCurrent := m_rgCIconList%A_Index%
        CIcon%pCIconListCurrent%_cHotkey := CIcon%pCIconListCurrent%_cHotkeyDefault
      }
      if (bOpForceGridAlign == true)
        GridAlign()
    }
    if (bGui4CheckButtonpos == true)
    {
      bIsFileDirty := true
      Loop
      {
        if (A_Index >= m_iCIconCount)
          break
      
        pCIconListCurrent := m_rgCIconList%A_Index%
        CIcon%pCIconListCurrent%_iButtonPos := CIcon%pCIconListCurrent%_iButtonPosDefault
      }
    }
    if (bGui4CheckStrings == true)
    {
      bIsFileDirty := true
      Loop
      {
        if (A_Index >= m_iCIconCount)
          break
      
        pCIconListCurrent := m_rgCIconList%A_Index%
        CIcon%pCIconListCurrent%_strName := CIcon%pCIconListCurrent%_strNameDefault
      }
    }    
  }
  Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
  Gui, 4:Destroy  ; Destroy the about box.
  ;bIsFileDirty := true
  EI() ; enable interrupts
  GuiRefresh()
  return
}

CheckboxGui4Hotkeys:
; this code is commented out since now we can have blank hotkeys, the user may
;   want to reset the blank ones
/*
if (bOpForceGridAlign == true)
{
  ;Msgbox, Can't do it
  Gui +OwnDialogs
  MsgBox, 3, Force Grid Align is On, Hotkeys are currently Aligned to grid.`nIn order to reset the Hotkeys, Force Grid Align must be turned off.`n`nTurn Force Grid Allign Off?
  IfMsgBox, Yes
  {
    bOpForceGridAlign := false
    GuiControl, 1:, Force Grid Align, 0
    Gui, 1:Submit, NoHide
  }
  Else
    GuiControl, 4:, Reset Hotkeys, 0
}
return
*/
CheckboxGui4Buttonpos:
CheckboxGui4Strings:
return

4ButtonOK:
;SetNewHotkey()
;Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
;Gui Destroy  ; Destroy the about box.
bIsGui4Destroyed := true
bIsGui4Canceled := false
return

4GuiClose:
4ButtonCancel:
;Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
;Gui Destroy  ; Destroy the about box.
bIsGui4Destroyed := true
bIsGui4Canceled := true
return

Button3:
;if (strTextColor == "White") 
  ;strTextColor = Grey
if (strTextColor == "Black")
  strTextColor = Blue
;else if (strTextColor == "Grey") 
;  strTextColor = Blue
else if (strTextColor == "Blue") 
  strTextColor = Green
else if (strTextColor == "Green")
  strTextColor = Red
else if (strTextColor == "Red") 
  strTextColor = Purple
else if (strTextColor == "Purple")
  strTextColor = Yellow
else if (strTextColor == "Yellow")
  strTextColor = Black
else
  strTextColor = Black

IniWrite, %strTextColor%, %kstrINI%, textcolor, strTextColor

Gui, Font, s20 c%strTextColor%
GuiControl, Font, strText
i = 0
Loop, 12
{
  GuiControl, Font, rgText%i%
  i++
}
return

Button4:
;msgbox, kstrWar3Path = %kstrWar3Path%
IfExist, %kstrWar3Path%\Customkeys.txt
{
  Gui +OwnDialogs
  msgbox, 4, Confirm File Replace,%kstrWar3Path%\Customkeys.txt already exists.`nDo you want to replace it?
}
IfMsgBox, No
	return
FileSaveCK()
IfExist, %kstrWar3Path%\Customkeys.txt
{
  Gui +OwnDialogs
  MsgBox, 0, File Saved!, %kstrWar3Path%\CustomKeys.txt has been saved
}
else
{
  Gui +OwnDialogs
  MsgBox, , Error!, %kstrWar3Path%\CustomKeys.txt was unable to be saved!
}
return


CheckboxGridAlign:
Gui, Submit, NoHide
if (bOpForceGridAlign == true)
{
  Gui +OwnDialogs
  msgbox, 4, Grid Align, This will Align all Hotkeys based on their grid position`nContinue?
  IfMsgBox, No
  {
    GuiControl, , Force Grid Align, 0
    Gui, Submit, NoHide
	  return
	}
  GridAlign()
  bIsFileDirty := true
  GuiRefresh()
}
IniWrite, %bOpForceGridAlign%, %kstrINI%, main, bOpForceGridAlign
GuiRefresh()
return

CheckboxHideHotkeys:
Gui, Submit, NoHide
IniWrite, %bOpHideHotkeys%, %kstrINI%, main, bOpHideHotkeys
GuiRefresh()
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Clicking on a Grid ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
grid0:
OnClickGrid(0)
return

grid1:
OnClickGrid(1)
return

grid2:
OnClickGrid(2)
return

grid3:
OnClickGrid(3)
return

grid4:
OnClickGrid(4)
return

grid5:
OnClickGrid(5)
return

grid6:
OnClickGrid(6)
return

grid7:
OnClickGrid(7)
return

grid8:
OnClickGrid(8)
return

grid9:
OnClickGrid(9)
return

grid10:
OnClickGrid(10)
return

grid11:
OnClickGrid(11)
return

GuiINIRead()
{
  global

  ; check for old ini files that don't have bOpDotaDefault and delete them
  IniRead, bOpDotaDefault, %kstrINI%, warkeys, bOpDotaDefault
  if ( (bOpDotaDefault != false) && (bOpDotaDefault != true) )
  {
    FileDelete, %kstrINI%
  }

  IfNotExist, %kstrINI%
  {
    ;Gui +OwnDialogs
    ;MsgBox, 0, Don't forget to enable CustomKeys in Warcraft III, This appears to be first your time running Warkeys.`nJust a reminder on getting started:`n`nPress the "Save to CustomKeys.txt" button when you are finished!`n`nEnable your CustomKeys in Warcraft III by starting Warcraft III, choosing Options, then Gameplay, and making sure the "Custom Keyboard Shortcuts" Box is checked.`n`nDue to an issue with Dota, some of the spells for the regular heroes have been moved.  Uncheck this box if you do not want these spells moved by default.  (This option can be changed under Program Settings).  
    
    Gui, 6:Add, Button, x272 y180 w75 h23 , OK
    Gui, 6:Add, Text, x14 y10 w600 h132, This appears to be first your time running Warkeys.  Just a hint on getting started:`n`nPress the "Save to CustomKeys.txt" button when you are finished!`n`nEnable your CustomKeys in Warcraft III by starting Warcraft III`, choosing Options`, then Gameplay`, and making sure the "Custom Keyboard Shortcuts" Box is checked.`n`nDue to an issue with Dota`, some of the spells for the regular heroes have been moved.  Uncheck this box if you do not want these spells moved by default.  (This option can be changed under Program Settings).
    Gui, 6:Add, Checkbox, x14 y150 h20 w600 vbGui6OpDotaDefault Checked1, New cfg files default to Dota compatiable
    Gui, 6:Show, x219 y260 h210 w621, Don't forget to enable Custom Keys in Warcraft III!

    Gui, 6:+owner1
    Gui, 1:+Disabled  ; Disable main window.
    
    Loop
    {
      if (bIsGui6Destroyed == true)
        break
      Sleep, 50
    }
    if (bIsGui6Canceled == false)
    {
      bOpDotaDefault := bGui6OpDotaDefault
    }
    ; main
    IniWrite, 0, %kstrINI%, main, bOpForceGridAlign
    IniWrite, 0, %kstrINI%, main, bOpHideHotkeys
    
    ; warkeys
    IniWrite, 0, %kstrINI%, warkeys, bOpTrayIcon
    IniWrite, 0, %kstrINI%, warkeys, bOpMultiple
    IniWrite, 1, %kstrINI%, warkeys, bOpLoadCfgOnStartup
    IniWrite, %bOpDotaDefault%, %kstrINI%, warkeys, bOpDotaDefault
    
    ; messages
    IniWrite, 0, %kstrINI%, messages, bOpHideMsgNoWarDir 

    ; updates
    IniWrite, 1, %kstrINI%, updates, bOpCheckUpdatesOnStartup
    ;IniWrite, 1, %kstrINI%, updates, bOpCheckUpdatesOnWinStartup    

    ; Gui options / Text Color
    IniWrite, 0, %kstrINI%, guioptions, bOpForceGridAlign
    IniWrite, 0, %kstrINI%, guioptions, bOpHideHotkeys
    IniWrite, Black, %kstrINI%, textcolor, strTextColor
    
    ;files
    IniWrite, %strFileCfg%, %kstrINI%, files, strFileCfg
    
    Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
    Gui, 6:Destroy  ; Destroy the about box.
  }

  GuiIniReadLine(bOpForceGridAlign, "main", "bOpForceGridAlign", false)
  GuiIniReadLine(bOpHideHotkeys, "main", "bOpHideHotkeys", false)
 
  GuiIniReadLine(bOpTrayIcon, "warkeys", "bOpTrayIcon", false)
  GuiIniReadLine(bOpMultiple, "warkeys", "bOpMultiple", false)
  GuiIniReadLine(bOpLoadCfgOnStartup, "warkeys", "bOpLoadCfgOnStartup", true)
  GuiIniReadLine(bOpDotaDefault, "warkeys", "bOpDotaDefault", true)

  GuiIniReadLine(bOpHideMsgNoWarDir, "messages", "bOpHideMsgNoWarDir", false)

  GuiIniReadLine(bOpCheckUpdatesOnStartup, "updates", "bOpCheckUpdatesOnStartup", true)
  ;GuiIniReadLine(bOpCheckUpdatesOnWinStartup, "updates", "bOpCheckUpdatesOnWinStartup", true)

  if (bOpLoadCfgOnStartup == true)
    IniRead, strFileCfg, %kstrINI%, files, strFileCfg

  strTemp = %A_Startup%\Warkeys Update.lnk
  bOpCheckUpdatesOnWinStartup := FileExist(strTemp) ; returns blank if false
  if bOpCheckUpdatesOnWinStartup = 
    bOpCheckUpdatesOnWinStartup := false
  else
    bOpCheckUpdatesOnWinStartup := true
  
  Menu, Tray, NoStandard
  Menu, Tray, Add, Exit
  
  if (bOpTrayIcon == true)
    Menu, Tray, Icon

  ; Check for multiple instances
  IfWinExist, %WindowName%
  {
    if (bOpMultiple == false)
    {
      Gui +OwnDialogs
      MsgBox, 0, Only One Instance Allowed, Warkeys is already running., 5
      ExitApp
    }
  }

  ; Warcraft III path
  regread, kstrWar3Path, HKEY_CURRENT_USER, Software\Blizzard Entertainment\Warcraft III, InstallPath
  if kstrWar3Path =
  {
    kstrWar3Path := A_WorkingDir
    if (bOpHideMsgNoWarDir == false)
    { 
      Gui +OwnDialogs
      MsgBox, 0, Warcraft III Directory Not Found!, The Warcraft III directory could not be found.`nThe CustomKeys.txt file will be saved to the current directory: %kstrWar3Path%`n`nThis warning can be disabled under Program Settings.
    }
  }
  else ; War 3 dir found, check to make sure customkeys is enabled
  {
    regread, bCustomKeys, HKEY_CURRENT_USER, Software\Blizzard Entertainment\Warcraft III\Gameplay, customkeys

    if (bCustomKeys == false)
    {
      Gui +OwnDialogs
      MsgBox, 4, Custom Keys must be Enabled!, Warkeys has determined that the Custom Key shortcuts are currently disabled for Warcraft III!`n`nWould you like Warkeys to turn on Custom Keys?`n(Note: You MUST say yes or enable Custom Keys in Warcraft III for Warkeys to work!)
      IfMsgBox, Yes
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Blizzard Entertainment\Warcraft III\Gameplay, customkeys, 1
    }
  }
  
  kstrFileKeys = %kstrWar3Path%\CustomKeys.txt
  
  ; Check for new version
  if (bOpCheckUpdatesOnStartup == true)
  {
    IfNotExist, update\Warkeys Update.exe
    {
      Gui +OwnDialogs
      MsgBox, 0, Auto Update Missing!, Warkeys cannot find "Warkeys Update".exe. Please reinstall warkeys.
    }
    else
      Run, update\Warkeys Update.exe
  }
  
  IniRead, strTextColor, %kstrINI%, textcolor, strTextColor
  ;(%strTextColor% != White) || (%strTextColor% != Grey) ||  
  if( (%strTextColor% != Blue) || (%strTextColor% != Green) || (%strTextColor% != Red)
    || (%strTextColor% != Purple) || (%strTextColor% != Yellow) || (%strTextColor% != Black) )
  {
    strTextColor = Black
  }
}

GuiIniReadLine(byRef bVar, kstrKey, kstrbVarName, kbDefaultVal)
{
  global

  IniRead, bVar, %kstrINI%, %kstrKey%, %kstrbVarName%
  if ( (bVar != false) && (bVar != true) )
  {
    IniWrite, %kbDefaultVal%, %kstrINI%, %kstrKey%, %kstrbVarName%
    bVar := %kbDefaultVal%
  }
}

6ButtonOK:
6GuiClose:
;6ButtonCancel:
bIsGui6Destroyed := true
bIsGui6Canceled := true
return

GuiDirtyCheck()
{
  global
  
  if (bIsFileDirty == true)
  {
    if strFileCfg =
      strLine = Untitled
    else
      strLine = %strFileCfg%
    Gui +OwnDialogs
    msgbox, 3, Warkeys, The data in the %strLine% file has changed.`n`nDo you want to save the changes?
    IfMsgBox, Cancel
  	  return 0
	  IfMsgBox, Yes
    {
      if strFileCfg =
        GoSub, FileSaveAs
      else
        GoSub, FileSave
    }
    return 1
  }
}

GetNewHotKey()
{
  global
  
  ;Gui, +OwnDialogs
  Gui, 3:+owner1
  Gui +Disabled  ; Disable main window.
  
  ListboxHotkeyChoice := %pCIconTemp1%_cHotkey
  iListboxChoice := Char2Num(ListboxHotkeyChoice)

  ;if (ListboxHotkeyChoice == "512")
    ;ListboxHotkeyChoice = Esc
  
  strImageName := %pCIconTemp1%_strImage
  strIconName := %pCIconTemp1%_strName
  iType := %pCIconTemp1%_iType

  strLabelDefault := %pCIconTemp1%_cHotkeyDefault
  ;if (strLabelDefault == "512")
    ;strLabelDefault = Esc
  
  Gui, 3:Add, Pic, w128 h128 y10, %ImageDir%\%strImageName%.jpg
  Gui, 3:Add, Text, w128, %strIconName%
  Gui, 3:Add, Text, , Default Hotkey = %strLabelDefault%`n`nCurrent Hotkey = %ListboxHotkeyChoice%
  if (iType == kiTypeGridKey)
    Gui, 3:Add, ListBox, x150 y10 vListboxHotkeyChoice Choose%iListboxChoice% r28, A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|ESC|None
  else
    Gui, 3:Add, ListBox, x150 y10 vListboxHotkeyChoice Choose%iListboxChoice% r27, A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|ESC
  Gui, 3:Add, Button, Default w120 h25 x10 y380, OK
  Gui, 3:Add, Button, w120 h25 x150 y380, Cancel
  Gui, 3:Show, x200 y200 h410 w300, Choose New Hotkey
  
  bIsGui3Destroyed := false
  
  ;GuiHotkeysOn()
  DI() ; disable interrupts
  Loop
  {
    if (bIsGui3Destroyed == true)
      break
    Sleep, 50
  }
  EI() ; enable interrupts
  ;GuiHotkeysOff()
  iIndexSelected = 
  if (bIsGui3Canceled == false)
  {
    bIsFileDirty := true
    GuiRefresh()
  }
}

Char2Num(cInput)
{
  if (cInput == "A")
    iNum := 1
  else if (cInput == "B")
    iNum := 2
  else if (cInput == "C")
    iNum := 3
  else if (cInput == "D")
    iNum := 4
  else if (cInput == "E")
    iNum := 5
  else if (cInput == "F")
    iNum := 6
  else if (cInput == "G")
    iNum := 7
  else if (cInput == "H")
    iNum := 8
  else if (cInput == "I")
    iNum := 9
  else if (cInput == "J")
    iNum := 10
  else if (cInput == "K")
    iNum := 11
  else if (cInput == "L")
    iNum := 12
  else if (cInput == "M")
    iNum := 13
  else if (cInput == "N")
    iNum := 14
  else if (cInput == "O")
    iNum := 15
  else if (cInput == "P")
    iNum := 16
  else if (cInput == "Q")
    iNum := 17
  else if (cInput == "R")
    iNum := 18
  else if (cInput == "S")
    iNum := 19
  else if (cInput == "T")
    iNum := 20
  else if (cInput == "U")
    iNum := 21
  else if (cInput == "V")
    iNum := 22
  else if (cInput == "W")
    iNum := 23
  else if (cInput == "X")
    iNum := 24
  else if (cInput == "Y")
    iNum := 25
  else if (cInput == "Z")
    iNum := 26
  ;else if (cInput == "512")
  else if (cInput == "ESC")
    iNum := 27
  else if cInput =
    iNum := 28
  else
    iNum := 1
      
  return iNum
}

SetNewHotKey()
{
  global

  Gui, 3:Submit 

  if (ListboxHotkeyChoice == "None")
    ListboxHotkeyChoice =
  ;else if (ListboxHotkeyChoice == "Esc")
    ;ListboxHotkeyChoice = 512

  %pCIconTemp1%_cHotkey := ListboxHotkeyChoice
}

GuiHotkeysOn()
{
  Hotkey, a, On
  Hotkey, b, On
  Hotkey, c, On
  Hotkey, d, On
  Hotkey, e, On
  Hotkey, f, On
  Hotkey, g, On
  Hotkey, h, On
  Hotkey, i, On
  Hotkey, j, On
  Hotkey, k, On
  Hotkey, l, On
  Hotkey, m, On
  Hotkey, n, On
  Hotkey, o, On
  Hotkey, p, On
  Hotkey, q, On
  Hotkey, r, On
  Hotkey, s, On
  Hotkey, t, On
  Hotkey, u, On
  Hotkey, v, On
  Hotkey, w, On
  Hotkey, x, On
  Hotkey, y, On
  Hotkey, z, On
  Hotkey, Esc, On
}

GuiHotkeysOff()
{
  Hotkey, a, Off
  Hotkey, b, Off
  Hotkey, c, Off
  Hotkey, d, Off
  Hotkey, e, Off
  Hotkey, f, Off
  Hotkey, g, Off
  Hotkey, h, Off
  Hotkey, i, Off
  Hotkey, j, Off
  Hotkey, k, Off
  Hotkey, l, Off
  Hotkey, m, Off
  Hotkey, n, Off
  Hotkey, o, Off
  Hotkey, p, Off
  Hotkey, q, Off
  Hotkey, r, Off
  Hotkey, s, Off
  Hotkey, t, Off
  Hotkey, u, Off
  Hotkey, v, Off
  Hotkey, w, Off
  Hotkey, x, Off
  Hotkey, y, Off
  Hotkey, z, Off
  Hotkey, Esc, Off
}


3ButtonOK:
SetNewHotkey()
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
bIsGui3Destroyed := true
bIsGui3Canceled := false
return

;3GuiEscape:
; todo: perhaps we can write some code that will highlight Esc when Escape is pressed

3GuiClose:
3ButtonCancel:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
bIsGui3Destroyed := true
bIsGui3Canceled := true
return

GuiTextUpdate()
{
  global
  
  static iGridXYPos
  
  if ( (iMouseX < x0) || (iMouseX > x4) || (iMouseY < 88) || (iMouseY > 352) )
    GuiControl, , strText,
  else
  {
    ; calculate Grid position
    iGridXYPos := ( 3*( (iMouseX - x0) // kiGridDelta ) + ( (iMouseY - 88) // kiGridDelta )) 
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%%iGridXYPos%
    if strGuiTextUpdateTemp
    {
      strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
      GuiControl, , strText, %strGuiTextUpdateTemp%
    }
    else
      GuiControl, , strText,
  }
  if (strControl == "Button1")
    ToolTip, This Button Aligns all the keys based the Layout in "Hotkey Grid" and "Learn Hotkey Grid", iMouseX+20, iMouseY+20, 1
  else if (strControl == "Button2")
    ToolTip, You can choose to set the Hotkeys`, Button Positions and/or the Tips to Default with this button, iMouseX+20, iMouseY+20, 1
  else if (strControl == "Button3")
    ToolTip, Press this button to change the text color, iMouseX+20, iMouseY+20, 1
  else if (strControl == "Button4")
    ToolTip, IMPORTANT!!!  Press this button when you are done to save to the CustomKeys.txt`nAnd don't forget to enable Custom Keys in Warcraft III!, iMouseX+20, iMouseY+20, 1
  else if (strControl == "Button5")
    ToolTip, This Button Aligns all the keys based the Layout in "Hotkey Grid" and "Learn Hotkey Grid"`nAnd forces the button to keep these hotkeys even when moved, iMouseX+20, iMouseY+20, 1
  else if (strControl == "Button6")
    ToolTip, Check this box to hide the Hotkey text and see the whole icon`nAlso`, you can change the Tip information when this box is checked, iMouseX+20, iMouseY+20, 1
  else
    ToolTip
  /*  
  if ((%prgpCIconGridCurrent%0 != %NULL%) && (iMouseX > krgiMouseX0) && (iMouseX < krgiMouseX1) && (iMouseY > krgiMouseY0) && (iMouseY < krgiMouseY1))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%0
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%1 != %NULL%) && (iMouseX > krgiMouseX0) && (iMouseX < krgiMouseX1) && (iMouseY > krgiMouseY1) && (iMouseY < krgiMouseY2))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%1
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%2 != %NULL%) && (iMouseX > krgiMouseX0) && (iMouseX < krgiMouseX1) && (iMouseY > krgiMouseY2) && (iMouseY < krgiMouseY3))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%2
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  
  else if ((%prgpCIconGridCurrent%3 != %NULL%) && (iMouseX > krgiMouseX1) && (iMouseX < krgiMouseX2) && (iMouseY > krgiMouseY0) && (iMouseY < krgiMouseY1))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%3
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%4 != %NULL%) && (iMouseX > krgiMouseX1) && (iMouseX < krgiMouseX2) && (iMouseY > krgiMouseY1) && (iMouseY < krgiMouseY2))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%4
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%5 != %NULL%) && (iMouseX > krgiMouseX1) && (iMouseX < krgiMouseX2) && (iMouseY > krgiMouseY2) && (iMouseY < krgiMouseY3))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%5
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  
  else if ((%prgpCIconGridCurrent%6 != %NULL%) && (iMouseX > krgiMouseX2) && (iMouseX < krgiMouseX3) && (iMouseY > krgiMouseY0) && (iMouseY < krgiMouseY1))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%6
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%7 != %NULL%) && (iMouseX > krgiMouseX2) && (iMouseX < krgiMouseX3) && (iMouseY > krgiMouseY1) && (iMouseY < krgiMouseY2))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%7
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%8 != %NULL%) && (iMouseX > krgiMouseX2) && (iMouseX < krgiMouseX3) && (iMouseY > krgiMouseY2) && (iMouseY < krgiMouseY3))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%8
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  
  else if ((%prgpCIconGridCurrent%9 != %NULL%) && (iMouseX > krgiMouseX3) && (iMouseX < krgiMouseX4) && (iMouseY > krgiMouseY0) && (iMouseY < krgiMouseY1))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%9
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%10 != %NULL%) && (iMouseX > krgiMouseX3) && (iMouseX < krgiMouseX4) && (iMouseY > krgiMouseY1) && (iMouseY < krgiMouseY2))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%10
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  else if ((%prgpCIconGridCurrent%11 != %NULL%) && (iMouseX > krgiMouseX3) && (iMouseX < krgiMouseX4) && (iMouseY > krgiMouseY2) && (iMouseY < krgiMouseY3))
  {
    strGuiTextUpdateTemp := %prgpCIconGridCurrent%11
    strGuiTextUpdateTemp := %strGuiTextUpdateTemp%_strName
    GuiControl, , strText, %strGuiTextUpdateTemp%
  }
  
  else
    GuiControl, , strText,
 */   
  GuiControl, Show, strText
}

OnClickGrid(iGridnum)
{
  global
  
  strTemp := %prgpCIconGridCurrent%%iGridnum%

  if (not iIndexSelected) && (strTemp)
  {
      iIndexSelected := iGridnum+1
  } 
  else if iIndexSelected ;&& (rgpCIconGrid%CurrentGrid%%iGridnum% == %NULL%))
  {
    iIndexSelected--
    pCIconTemp1 := %prgpCIconGridCurrent%%iIndexSelected%
    pCIconTemp2 := %prgpCIconGridCurrent%%iGridnum%

    iTypeTemp := %pCIconTemp1%_iType
    bIsUnchangeable := %pCIconTemp1%_bIsUnchangeable

    if (iIndexSelected == iGridNum)
    {
      if (bOpHideHotkeys == false)
      {
        ;iTypeTemp := %pCIconTemp1%_iType
      
        if (bOpForceGridAlign == true)
        {
          Gui +OwnDialogs
          Msgbox, 0, Hotkeys locked, Force Grid Align is currently on.`nTo change hotkeys, first disable this option.
          iIndexSelected =
          return
        }
        if ( (iTypeTemp == kiTypeDotaABNormLearn) || (bIsUnchangeable == true) )
        {
          Gui +OwnDialogs
          Msgbox, , Can't Change Hotkey, This button's Hotkey cannot be changed (it is not supported by Warcraft III).
        }
        else if  ( (iTypeTemp != kiTypeNoHotkey) && (iTypeTemp != kiTypeHeroSpellNoHotkey)
          && (iTypeTemp != kiTypeUnbuttonB) && (iTypeTemp != kiTypeHeroSpellUnbuttonB) 
          && (iTypeTemp != kiTypeHeroSpellSixNoHotkey) && (iTypeTemp != kiTypeDotaUN) 
          && (iTypeTemp != kiTypeHeroSpellDotaUN) && (iTypeTemp != kiTypeDotaAB) )
          GetNewHotKey()
        else
        {
          Gui +OwnDialogs
          Msgbox, , No Hotkey, This icon has no Hotkey.
        }
      }
      else ;if (bOpHideHotkeys == true)
      {
        strLabel := %pCIconTemp1%_strName
        strLabelDefault := %pCIconTemp1%_strNameDefault

        Gui, 4:+owner1
        Gui +Disabled  ; Disable main window.
        
        ;InputBox, strInput, Enter New Label for command, Default Label = %strLabelDefault%`n`nCurrent Label = %strLabel%, , , , , , , , %strLabel%
        
        Gui, 4:Font, s10
        Gui, 4:Add, Button, x5 y5 w54 h24, Default
        Gui, 4:Add, Text, x5 y35 w358 h98, Default Label = %strLabelDefault%`n`nCurrent Label = %strLabel%
        Gui, 4:Add, Edit, x5 y138 w358 h24 vstrInput, %strLabel%
        Gui, 4:Add, Button, x68 y167 w54 h24, OK
        Gui, 4:Add, Button, x247 y167 w54 h24, Cancel
        Gui, 4:Show, x423 y255 h198 w370, Enter New Tip for the Command

        bIsGui4Destroyed := false
        DI() ; disable interrupts
        Loop
        {
          if (bIsGui4Destroyed == true)
            break
          Sleep, 50
        }
        if (bIsGui4Canceled == false)
        {
          Gui, 4:Submit
          
          %pCIconTemp1%_strName := strInput
          bIsFileDirty := true
          GuiRefresh()
        }

        Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
        Gui, 4:Destroy  ; Destroy the about box.
        ;bIsFileDirty := true
        EI() ; enable interrupts
      }
      iIndexSelected =
      return
    }    
  
    if (iTypeTemp == kiTypeGridKey)
    {
      iIndexSelected =
      return
    }
  
    StringRight, cLastChar, prgpCIconGridCurrent, 1
    if ( (cLastChar == "A") || (cLastChar == "B") )
    {
      Gui +OwnDialogs
      MsgBox , , Cannot Move Icon, Icons on this grid cannot be changed`nTo move icons use orignal grid,
      return
    }

    %prgpCIconGridCurrent%%iIndexSelected% = %pCIconTemp2%
    %prgpCIconGridCurrent%%iGridnum% = %pCIconTemp1%
    
    if pCIconTemp1
      CIcon_Update(pCIconTemp1, iGridnum)
      
    if pCIconTemp2
      CIcon_Update(pCIconTemp2, iIndexSelected)
    
    ; cmdcancel and cmdcancelbuild both use the same buttonpos (cmdcancel's)
    if ( (pCIconTemp1 == "CIconcmdcancelbuild") || (pCIconTemp2 == "CIconcmdcancelbuild") )
      CIconcmdcancel_iButtonPos := CIconcmdcancelbuild_iButtonPos
    else if ( (pCIconTemp1 == "CIconcmdcancel") || (pCIconTemp2 == "CIconcmdcancel") )
      CIconcmdcancelbuild_iButtonPos := CIconcmdcancel_iButtonPos

    iIndexSelected =
    bIsFileDirty := true

    GuiRefresh()
  }
}

4ButtonDefault:
GuiControl, , strInput, %strLabelDefault%
return

GuiRefreshWinName()
{
  global
  
  ;GuiControl, , strGuiControlButton1, Align Keys to %WarkeysGrid0_cHotkey%%WarkeysGrid3_cHotkey%%WarkeysGrid6_cHotkey%%WarkeysGrid9_cHotkey%, %WarkeysGrid1_cHotkey%%WarkeysGrid4_cHotkey%%WarkeysGrid7_cHotkey%%WarkeysGrid10_cHotkey%, %WarkeysGrid2_cHotkey%%WarkeysGrid5_cHotkey%%WarkeysGrid8_cHotkey%%WarkeysGrid11_cHotkey% grid
  
  if strFileCfg =
  {
    if (bIsFileDirty == false)
      WindowName = WarKeys v%ScriptVersion%
    else
      WindowName = WarKeys v%ScriptVersion% *
  }
  else
  {
    StringSplit, kstrOutput, strFileCfg, \ 
    kstrTemp := kstrOutput%kstrOutput0%
    if (bIsFileDirty == false)
      WindowName = WarKeys v%ScriptVersion% (%kstrTemp%)
    else
      WindowName = WarKeys v%ScriptVersion% (%kstrTemp%*)
  }
  Gui, 1:Show, , %WindowName%
}

GuiRefresh()
{
  ;GuiControl, , strGuiControlButton1, Align Keys to %WarkeysGrid0_cHotkey%%WarkeysGrid3_cHotkey%%WarkeysGrid6_cHotkey%%WarkeysGrid9_cHotkey%, %WarkeysGrid1_cHotkey%%WarkeysGrid4_cHotkey%%WarkeysGrid7_cHotkey%%WarkeysGrid10_cHotkey%, %WarkeysGrid2_cHotkey%%WarkeysGrid5_cHotkey%%WarkeysGrid8_cHotkey%%WarkeysGrid11_cHotkey% grid
  ;Gui, Add, Button, x16 y320 w110 h40 gButton1, Align Keys to %WarkeysGrid0_cHotkey%%WarkeysGrid3_cHotkey%%WarkeysGrid6_cHotkey%%WarkeysGrid9_cHotkey%, %WarkeysGrid1_cHotkey%%WarkeysGrid4_cHotkey%%WarkeysGrid7_cHotkey%%WarkeysGrid10_cHotkey%, %WarkeysGrid2_cHotkey%%WarkeysGrid5_cHotkey%%WarkeysGrid8_cHotkey%%WarkeysGrid11_cHotkey% grid
  ;Gui, Add, Button, x16 y320 w110 h40 gButton1, Align Keys to QWER, ASDF, ZXCV grid
  ;GuiControlGet, strGuiControlButton1

  GuiRefreshWinName()
  GridLoadGrids()
  GridDrawCurrentGrid()
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; File Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FileSave()
; FileSaveCK()
; FileWrite(hFileName, kstrLine)
; FileWriteIcon(strCodeName) ; this function has been obsoleted
; FileWriteIconCK(strCodeName)
; bool FileLoad(strFileName)

; Saves the info about the icons to a Warkeys cfg file
FileSave()
{
  global
  
  DI()
  ;FileRecycle, %kstrFileKeys%
  ;FileRecycle, %strFileCfg%
  
  hFileCfg := DllCall("CreateFile", str, strFileCfg, Uint, GENERIC_WRITE, Uint, 0, UInt, 0, UInt, CREATE_ALWAYS, Uint, 0, UInt, 0)
  if not hFileCfg
  {
    Gui +OwnDialogs
	  MsgBox, Can't open "%strFileCfg%" for writing.
	  return
  }
  
  Loop
  {
    if (A_Index >= m_iCIconCount)
      break
      
    pCIconListCurrent := m_rgCIconList%A_Index%
    
    strItemName := CIcon%pCIconListCurrent%_strName
    cItemHotkey := CIcon%pCIconListCurrent%_cHotkey
    iItemButtonPos := CIcon%pCIconListCurrent%_iButtonPos

    strTemp = %pCIconListCurrent%`t%iItemButtonPos%`t%cItemHotkey%`t%strItemName%`r`n
    FileWrite(hFileCfg, strTemp)
  }
  DllCall("CloseHandle", UInt, hFileCfg)  ; Close the file.
  EI()
}

; Writes the CustomKeys.txt
FileSaveCK()
{
  global
  
  DI()
  Gui, 1:+Disabled
  ;FileRecycle, %kstrFileKeys%
  ;FileRecycle, %strFileCfg%
  
  hFileKeys := DllCall("CreateFile", str, kstrFileKeys, Uint, GENERIC_WRITE, Uint, 0, UInt, 0, UInt, CREATE_ALWAYS, Uint, 0, UInt, 0)
  if not hFileKeys
  {
    Gui +OwnDialogs
	  MsgBox Can't open "%kstrFileKeys%" for writing.
	  return
  }
 
  FileWrite(hFileKeys, "//////////////////////////////////////////////////////`r`n")
  FileWrite(hFileKeys, "// File Generated by Warkeys                        //`r`n")
  FileWrite(hFileKeys, "//////////////////////////////////////////////////////`r`n`r`n")
  
  Loop
  {
    if (A_Index >= m_iCIconCount)
      break
      
    pCIconListCurrent := m_rgCIconList%A_Index%
    FileWriteIconCK(pCIconListCurrent) 
  }

  DllCall("CloseHandle", UInt, hFileKeys)  ; Close the file.
  Gui, 1:-Disabled
  EI()
}

; Writes a line to the file
FileWrite(hFileName, kstrLine)
{
  global
  
  DllCall("WriteFile", UInt, hFileName, str, kstrLine, UInt, StrLen(kstrLine), UIntP, BytesActuallyWritten, UInt, 0)
}

; given an icon, this function writes the given info about that icon to CustomKeys.txt
FileWriteIconCK(strCodeName)
{
  global

  iCIconType := CIcon%strCodeName%_iType
  
  if (iCIconType == kiTypeNormal) ; Standard
  {
    strItemName := CIcon%strCodeName%_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHero) ; Hero
  {
    strHeroName := CIcon%strCodeName%_strName
    cHeroHotkey := CIcon%strCodeName%_cHotkey
    iHeroButtonPos := CIcon%strCodeName%_iButtonPos
    iHeroButtonPosx := iHeroButtonPos // 3 
    iHeroButtonPosy := mod(iHeroButtonPos,3)

    ;strTemp = //%strHeroName%`r`n
    ;FileWrite(hFileKeys, strTemp)

    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cHeroHotkey%|r) Summon %strHeroName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Revivetip=(|cffffcc00%cHeroHotkey%|r) Revive %strHeroName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Awakentip=(|cffffcc00%cHeroHotkey%|r) Awaken %strHeroName%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cHeroHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iHeroButtonPosx%`,%iHeroButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeNormal2) ; Double Dippin'
  {
    strItemName := CIcon%strCodeName%_strName
    strItemName2 := CIcon%strCodeName%A_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkey2 := CIcon%strCodeName%A_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`,(|cffffcc00%cItemHotkey2%|r) %strItemName2%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    if (cItemHotkey2 == "ESC")
      cItemHotkey2 = 512
    strTemp = Hotkey=%cItemHotkey%`,%cItemHotkey2%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeNormal3) ; 3-way
  {
    strItemName := CIcon%strCodeName%_strName
    strItemName2 := CIcon%strCodeName%A_strName
    strItemName3 := CIcon%strCodeName%B_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkey2 := CIcon%strCodeName%A_cHotkey
    cItemHotkey3 := CIcon%strCodeName%B_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`,(|cffffcc00%cItemHotkey2%|r) %strItemName2%`,(|cffffcc00%cItemHotkey3%|r) %strItemName3%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    if (cItemHotkey2 == "ESC")
      cItemHotkey2 = 512
    if (cItemHotkey3 == "ESC")
      cItemHotkey3 = 512
    strTemp = Hotkey=%cItemHotkey%`,%cItemHotkey2%`,%cItemHotkey3%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeDouble) ; doppelgangers
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameD := CIcon%strCodeName%D_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyD := CIcon%strCodeName%D_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosD := CIcon%strCodeName%D_iButtonPos
    iItemButtonPosDx := iItemButtonPosD // 3 
    iItemButtonPosDy := mod(iItemButtonPosD,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = UnTip=(|cffffcc00%cItemHotkeyD%|r) %strItemNameD%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyD == "ESC")
      cItemHotkeyD = 512
    strTemp = Unhotkey=%cItemHotkeyD%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Unbuttonpos=%iItemButtonPosDx%`,%iItemButtonPosDy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeUnbutton) ; Unbuttons
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameU := CIcon%strCodeName%U_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyU := CIcon%strCodeName%U_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosU := CIcon%strCodeName%U_iButtonPos
    iItemButtonPosUx := iItemButtonPosU // 3 
    iItemButtonPosUy := mod(iItemButtonPosU,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = UnTip=%strItemNameU%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Unbuttonpos=%iItemButtonPosUx%`,%iItemButtonPosUy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeNoHotkey)
  {
    strItemName := CIcon%strCodeName%_strName
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)

    ;strTemp = //%strItemName%`r`n 
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=%strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpell) ; Hero Spells
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkey%|r)%A_Space%, 1
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpellSix) ; Sexy Six!!!
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = ResearchTip=(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpellSixNoHotkey) ; Stupid Tauren...
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    ;cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Tip=%strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = ResearchTip=(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpellUnbutton) ; Hero Spell Unbuttons
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    strItemNameU := CIcon%strCodeName%U_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    ;cItemHotkeyU := CIcon%strCodeName%U_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)
    iItemButtonPosU := CIcon%strCodeName%U_iButtonPos
    iItemButtonPosUx := iItemButtonPosU // 3 
    iItemButtonPosUy := mod(iItemButtonPosU,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n  
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkey%|r)%A_Space%, 1
    FileWrite(hFileKeys, strTemp)
    strTemp = UnTip=%strItemNameU%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=`"(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`"`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Unbuttonpos=%iItemButtonPosUx%`,%iItemButtonPosUy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if ( (iCIconType == kiTypeHeroSpellNoHotkey) || (iCIconType == kiTypeDotaAB) )
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)
    ;strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    strTemp = Tip=%strItemName%`r`n
    ;StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkey%|r)%A_Space%, 1
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=`"(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`"`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpellDouble) ; Stupid Sea Witch...
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    strItemNameD := CIcon%strCodeName%D_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    cItemHotkeyD := CIcon%strCodeName%D_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)
    iItemButtonPosD := CIcon%strCodeName%D_iButtonPos
    iItemButtonPosDx := iItemButtonPosD // 3 
    iItemButtonPosDy := mod(iItemButtonPosD,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n  
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkey%|r)%A_Space%, 1
    FileWrite(hFileKeys, strTemp)
    strTemp = UnTip=(|cffffcc00%cItemHotkeyD%|r) %strItemNameD%`r`n
    StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkeyD%|r)%A_Space%, 1
    ;strTemp = UnTip=(|cffffcc00%cItemHotkeyD%|r) %strItemNameD% - [|cffffcc00Level 1|r],(|cffffcc00%cItemHotkeyD%|r) %strItemNameD% - [|cffffcc00Level 2|r],(|cffffcc00%cItemHotkeyD%|r) %strItemNameD% - [|cffffcc00Level 3|r]`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=`"(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`"`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyD == "ESC")
      cItemHotkeyD = 512
    strTemp = Unhotkey=%cItemHotkeyD%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Unbuttonpos=%iItemButtonPosDx%`,%iItemButtonPosDy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }  
  else if (iCIconType == kiTypeHeroSpellSixDouble) ; tinker....
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    strItemNameD := CIcon%strCodeName%D_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    cItemHotkeyD := CIcon%strCodeName%D_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)
    iItemButtonPosD := CIcon%strCodeName%D_iButtonPos
    iItemButtonPosDx := iItemButtonPosD // 3 
    iItemButtonPosDy := mod(iItemButtonPosD,3)
    
    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n  
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = UnTip=(|cffffcc00%cItemHotkeyD%|r) %strItemNameD%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyD == "ESC")
      cItemHotkeyD = 512
    strTemp = Unhotkey=%cItemHotkeyD%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Unbuttonpos=%iItemButtonPosDx%`,%iItemButtonPosDy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeSeparate) ; two codes!!!
  {
    strItemName := CIcon%strCodeName%_strName
    cItemHotkey := CIcon%strCodeName%_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    strCodeName2 := CIcon%strCodeName%_code

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = [%strCodeName2%]`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeHeroSpellDotaUN) ; Hero Spell Unbuttons
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameL := CIcon%strCodeName%L_strName
    strItemNameU := CIcon%strCodeName%U_strName
    ;cItemHotkey := CIcon%strCodeName%_cHotkey
    cItemHotkeyL := CIcon%strCodeName%L_cHotkey
    ;cItemHotkeyU := CIcon%strCodeName%U_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosL := CIcon%strCodeName%L_iButtonPos
    iItemButtonPosLx := iItemButtonPosL // 3 
    iItemButtonPosLy := mod(iItemButtonPosL,3)
    iItemButtonPosU := CIcon%strCodeName%U_iButtonPos
    iItemButtonPosUx := iItemButtonPosU // 3 
    iItemButtonPosUy := mod(iItemButtonPosU,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n  
    FileWrite(hFileKeys, strTemp)
    ;strTemp = Tip=(|cffffcc00%cItemHotkey%|r) %strItemName%`r`n
    strTemp = Tip=%strItemName%`r`n
    ;StringReplace, strTemp, strTemp, `, , `,(|cffffcc00%cItemHotkey%|r)%A_Space%, 1
    FileWrite(hFileKeys, strTemp)
    strTemp = UnTip=%strItemNameU%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchtip=`"(|cffffcc00%cItemHotkeyL%|r) %strItemNameL%`"`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkey == "ESC")
      cItemHotkey = 512
    strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)

    if (cItemHotkeyL == "ESC")
      cItemHotkeyL = 512
    strTemp = Researchhotkey=%cItemHotkeyL%`r`n
    FileWrite(hFileKeys, strTemp)

    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Unbuttonpos=%iItemButtonPosUx%`,%iItemButtonPosUy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Researchbuttonpos=%iItemButtonPosLx%`,%iItemButtonPosLy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  else if (iCIconType == kiTypeDotaUN) ; Morphling....
  {
    strItemName := CIcon%strCodeName%_strName
    strItemNameU := CIcon%strCodeName%U_strName
    ;cItemHotkey := CIcon%strCodeName%_cHotkey
    ;cItemHotkeyU := CIcon%strCodeName%U_cHotkey
    iItemButtonPos := CIcon%strCodeName%_iButtonPos
    iItemButtonPosx := iItemButtonPos // 3 
    iItemButtonPosy := mod(iItemButtonPos,3)
    iItemButtonPosU := CIcon%strCodeName%U_iButtonPos
    iItemButtonPosUx := iItemButtonPosU // 3 
    iItemButtonPosUy := mod(iItemButtonPosU,3)

    ;strTemp = //%strItemName%`r`n
    ;FileWrite(hFileKeys, strTemp)
    strTemp = [%strCodeName%]`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Tip=%strItemName%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = UnTip=%strItemNameU%`r`n
    ;FileWrite(hFileKeys, strTemp)
    ;strTemp = Hotkey=%cItemHotkey%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Buttonpos=%iItemButtonPosx%`,%iItemButtonPosy%`r`n
    FileWrite(hFileKeys, strTemp)
    strTemp = Unbuttonpos=%iItemButtonPosUx%`,%iItemButtonPosUy%`r`n`r`n
    FileWrite(hFileKeys, strTemp)
  }
  ; else we don't care
}

; Loads a given cfg file
FileLoad(strFileName, bLoadHotkey = true, bLoadButtonPos = true, bLoadName = true)
{
  global

  if ( (bLoadButtonPos == false) && (bLoadHotkey == false) && (bLoadName == false) )
    Return

  ; double check to make sure the cfg file is valid
  ;  Note: this is done simply by counting the number of tabs
  Loop, Read, %strFileName%
  {
    StringSplit, strInput, A_LoopReadLine, %A_Tab%
    
    if (strInput0 != 4)
    {
      Gui +OwnDialogs
      MsgBox, Invalid cfg file!`nThe file will not be loaded.
      return 0
    }
  }

  Loop, Read, %strFileName%
  {
    StringSplit, strInput, A_LoopReadLine, %A_Tab%
    
    iTypeTemp := CIcon%strInput1%_iType

    if (bLoadButtonPos == true)
    {
      if ( (strInput2 >= 0) && (strInput2 <= 11) ) 
        CIcon%strInput1%_iButtonPos = %strInput2%
    }
    if (bLoadHotkey == true)
    {
      ; check to see if it is a Hotkey type
      if  ( (iTypeTemp != kiTypeNoHotkey) && (iTypeTemp != kiTypeHeroSpellNoHotkey)
        && (iTypeTemp != kiTypeUnbuttonB) && (iTypeTemp != kiTypeHeroSpellUnbuttonB) 
        && (iTypeTemp != kiTypeHeroSpellSixNoHotkey) && (iTypeTemp != kiTypeDotaUN) 
        && (iTypeTemp != kiTypeHeroSpellDotaUN) && (iTypeTemp != kiTypeDotaAB) )
      {
         ; check for "None" hotkey for GridKeys
        if ( (iTypeTemp == kiTypeGridKey) && (not %strInput3%) ) 
          CIcon%strInput1%_cHotkey := 
        if ( CIcon_IsValidHotkey(strInput3) )
          CIcon%strInput1%_cHotkey = %strInput3%
      }
    }
    if (bLoadName == true)
    {
      CIcon%strInput1%_strName = %strInput4%
    }
  }
  
  CIcon_ResetUnchangeables()
  
  return 1
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;   Timer Functions   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TimerInit()
; DI() ; Disable Interrupts
; EI() ; Enable Interrupts

; sets the timer for how often the mouse is checked to see if it is over an icon
TimerInit()
{
  SetTimer, UpdateText, 100
  EI()
  ;Gosub, UpdateText  ; Make the first update immediate rather than waiting for the timer.
}

UpdateText:
if (bEnableInterrupts == false)
  return
;IfWinNotActive, Warkeys
;  return
DI() ; make sure the ISR isn't interrupted by itself
MouseGetPos, iMouseX, iMouseY, , strControl
GuiTextUpdate()
EI() ; turn the interrupts back on
return

; Disable interrupts
; Disabling the interrupts is useful when in an ISR and when doing a long task
;  where the updating is not required (ie writing the CustomKeys.txt) or 
;  getting a new hotkey.  This function should be called whenever a dialog
;  window is created
DI()
{
  global

  bEnableInterrupts := false
}

; Enable interrupts
EI()
{
  global
  
  bEnableInterrupts := true
}
 
