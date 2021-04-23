/*
FarmVille Downloader (XML/Parser) by Richsm
http://www.autohotkey.com/forum/topic64590.html
-------------------------------------------------------------
FarmVille Downloader is a simple script that downloads XML data from FarmVille, parses the data as necessary, 
and stores it in a more readable format such as a comma-separated value (CSV) file.
*/
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Variables *********************************************************************************************************************************************************
LocaleURL = http://farmville.com/flashLocaleXml.xml.gz
LocaleFile = %A_ScriptDir%\XML\flashLocaleXml.xml
SettingsURL = http://farmville.com/gameSettings.xml.gz
SettingsFile = %A_ScriptDir%\XML\gameSettings.xml
ItemsURL = http://farmville.com/items.xml.gz
ItemsFile = %A_ScriptDir%\XML\items.xml
ItemsFile_Temp = %A_ScriptDir%\XML\items_temp.xml ; Temp file
StorageURL = http://farmville.com/StorageConfig.xml.gz
StorageFile = %A_ScriptDir%\XML\StorageConfig.xml
CraftingURL = http://farmville.com/crafting.xml.gz
CraftingFile = %A_ScriptDir%\XML\crafting.xml
SourceFile = %A_ScriptDir%\XML\sourceNames.csv
FV_Mastery = %A_ScriptDir%\XML\Mastery.csv
FV_Animals = %A_ScriptDir%\XML\Parents.csv
FriendPos = 0 ; Use for Friendly Names positioning
ItemName = <item name= ; Used to find start of items
EndItem = </item> ; Used to find end of items
; Mastery Level Info
TypeSeed = type="seed"
TypeTree = type="tree"
Masterable = mastery="true"
MasterLevel = <masteryLevel
mLevel = 1
; Horse-Foal and Cow-Calf Info
TypeAnimal = type="animal"
Foal = <foal>
Baby = <baby>
Foal2 = <foal share="true"> ; Used only for Mustang

; Download XML Info and Uncompress ****************************************************************************************************************************
URLDownloadToFile, %LocaleURL%, %LocaleFile%.gz
URLDownloadToFile, %SettingsURL%, %SettingsFile%.gz
URLDownloadToFile, %ItemsURL%, %ItemsFile%.gz
URLDownloadToFile, %StorageURL%, %StorageFile%.gz
URLDownloadToFile, %CraftingURL%, %CraftingFile%.gz
RunWait, %A_ScriptDir%\XML\gunzip.exe,%A_ScriptDir%\XML,Hide

; Generate Friendly Names ****************************************************************************************************************************************
FileRead, XMLSource, %LocaleFile%
FileDelete, %SourceFile%
XMLNew := regexReplace(XMLSource, "ism)\s*<bundle name=""(?!Items)[^""]+"">.*?</bundle>") ; Ignore non "Items" elements
Loop
{
   FriendPos := regexmatch(XMLNew, "i)<bundleLine key=""([^""]+)_friendlyName"">\s*<value>([^<]+)</value>", NameText, FriendPos + 1) ; Find Code & Friendly Names
   If (!FriendPos)
      Break
   StringReplace, NameText2, NameText2, &lt;sup&gt;,,1 ; Removes <sup> tags
   StringReplace, NameText2, NameText2, &lt;/sup&gt;,,1 ; Removes </sup> tags
   StringReplace, NameText2, NameText2, &amp;#xE9;,e,1 ; Replaces e' symbol
   StringReplace, NameText2, NameText2, &amp;#xAE;%A_Space%,,1 ; Removes register trademark symbol
   StringReplace, NameText2, NameText2, &amp;#xAE;,,1 ; Removes register trademark symbol
   StringReplace, NameText2, NameText2, &amp;,&,1 ; Replace &amp; with & symbol
   StringReplace, NameText2, NameText2, &lt;sup&gt;&amp;#xAE;&lt;/sup&gt;, &reg; ; Fix Registered symbol
   NameText2 = %NameText2% ; AutoTrim will remove whitespace
   FileText .= NameText1 . ",""" . NameText2 . """`r`n" ; NameText1 is code name, NameText2 is Friendly Name
}
FileAppend, %FileText%, %SourceFile%

; Generate Mastery Level Information ******************************************************************************************************************************
FileDelete, %FV_Mastery%

Loop, read, %ItemsFile%
{
	IfInString, A_LoopReadLine, %ItemName% ; Is an Item, continue
		IfInString, A_LoopReadLine, %TypeSeed% ; Is a Seed, continue
		{
			IfInString, A_LoopReadLine, %Masterable% ; Is able to Master crop, continue
				RegExMatch(A_LoopReadLine, "(?<=name="")\w+", SeedName)
		}
		Else
		{
			IfInString, A_LoopReadLine, %TypeTree% ; Is a Tree, continue
				IfInString, A_LoopReadLine, %Masterable% ; Is able to Master tree, continue
					RegExMatch(A_LoopReadLine, "(?<=name="")\w+", TreeName)
		}

	If (SeedName)
	{
		IfNotInString, A_LoopReadLine, %EndItem% ; Not reached end of Item, continue
		{
			IfInString, A_LoopReadLine, %MasterLevel% ; Found Mastery Level, continue
			{
				RegExMatch(A_LoopReadLine, "(?<=count="")[0-9]+", MastLevel%mLevel%)
				++mLevel
			}
		}
		Else
		{
			If (SeedName and MastLevel1)
				FileAppend, %SeedName%`,%MastLevel1%`,%MastLevel2%`,%MastLevel3%`n, %FV_Mastery%
			SeedName = 0
			mLevel = 1
		}
	}
	If (TreeName)
	{
		IfNotInString, A_LoopReadLine, %EndItem% ; Not reached end of Item, continue
		{
			IfInString, A_LoopReadLine, %MasterLevel% ; Found Mastery Level, continue
			{
				RegExMatch(A_LoopReadLine, "(?<=count="")[0-9]+", MastLevel%mLevel%)
				++mLevel
			}
		}
		Else
		{
			If (TreeName and MastLevel1)
				FileAppend, %TreeName%`,%MastLevel1%`,%MastLevel2%`,%MastLevel3%`n, %FV_Mastery%
			TreeName = 0
			mLevel = 1
		}
	}
}

; Generate Horse-Foal and Cow-Calf Information ******************************************************************************************************************
FileDelete, %FV_Animals%

Loop, read, %ItemsFile%
{
	IfInString, A_LoopReadLine, %ItemName% ; Is an Item, continue
		IfInString, A_LoopReadLine, %TypeAnimal% ; Is an Animal, continue
			RegExMatch(A_LoopReadLine, "(?<=name="")\w+", AnimalName)

	If (AnimalName)
	{
		IfNotInString, A_LoopReadLine, %EndItem% ; Not reached end of Item, continue
		{
			IfInString, A_LoopReadLine, %Baby% ; Baby calfs
				RegExMatch(A_LoopReadLine, "(?<=\<baby\>)\w+", BabyName)
			IfInString, A_LoopReadLine, %Foal% ; Horse foals
				RegExMatch(A_LoopReadLine, "(?<=\<foal\>)\w+", BabyName)
			IfInString, A_LoopReadLine, %Foal2% ; Only used for Mustang
				RegExMatch(A_LoopReadLine, "(?<=\<foal share=""true""\>)\w+", BabyName)
		}
		Else
		{
			If (AnimalName and BabyName)
				FileAppend, %AnimalName%`,%BabyName%`n, %FV_Animals%
			BabyName = 0
		}
	}
}

; Add XSD to XML for Excel to read *******************************************************************************************************************************
RootElement = <settings>
RootElementNew = <settings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="items.xsd">
FileRead, FileText, %ItemsFile%
StringReplace, FileText, FileText, buyable="fale", buyable="false", A ; Fix typo
StringTrimLeft, FileText, FileText, StrLen("%RootElement%")
FileAppend, %RootElementNew%, %ItemsFile_Temp%
FileAppend, %FileText%, %ItemsFile_Temp%
FileMove, %ItemsFile_Temp%, %ItemsFile%, 1