/*
FileUpdate Function v2

Made by Kerry Jones Sept 04, 2006

FromURL: specify to be True or False, true being that you want to download a file with a description and files to update.
AHKFile: the path to the AHKFile that you want updated.  The file taken from the internet will be placed here.
URL: the URL of the location of the updated file.
UpdateURL: applicable only if FromURL = True, which is the path to the ini file to do the updating. See below for details.
ProcessPath: If you want to compile and run the path from a different location than the current directory.
ProcessName: The exact name of the exe that is running
Compile: If you want to compile the file, set to True
RunNow: If you want to run the file after updated, set to True

----------------------------------- FromURL = True -----------------------------------
If you specify FromURL = True, then you need to set UpdateURL to an inifile with the correct standards
The current standards for the ini file are:

	[Version Info]
	Name=
	Num=
	Description=
	[Options]
	Compile=
	Run=
	[File1]
	AHKFile=
	URL=
	[File2]
	AHKFile=
	URL=
	[File3]
	AHKFile=
	URL=
	
The [File%num%]'s can go on for as many files as you would like to update.

Name: The name of the script you are updating
Num: The version number.  The function adds in the v (for instance, v1.54)
Description: The description of the update. This will be shown to the user to check if he actually wants to update.
Compile: If you want to compile a file, put the file you would like to compile. If blank, nothing will be compiled.
Run: If you want to run a file, either .ahk or .exe, put it here. If blank, nothing will be run.
AHKFile: The file you would like to update.
URL: The location of the new file that will replcae AHKFile

*/

UpdateFile(FromURL, AHKFile = "", URL = "", UpdateURL = "", ProcessPath= "", ProcessName = "", Compile = 0, RunNow = 0)
{
	; Splits the paths and makes NewPath to be the correct variable
	SplitPath, A_AhkPath, , InitialPath
	InitialPath = %InitialPath%\
	
	if (FromURL = 1) and (UpdateUrl <> "") 
	{
		UrlDownloadToFile, %UpdateURL%, func_Update.ini
		
		DelUpdate := "del func_Update.ini"
		
		IniRead, Name, func_Update.ini, Version Info, Name
		IniRead, Num, func_Update.ini, Version Info, Num
		IniRead, Description, func_Update.ini, Version Info, Description
		IniRead, CompileFile, func_Update.ini, Options, Compile
		IniRead, RunFile, func_Update.ini, Options, Run
		
		
		MsgBox, 4, %Name% - v%Num%, %Description% `r`n `r`nDo you want to continue?
		IfMsgBox Yes
		{
			loop
			{
				IniRead, File%A_Index%Name, func_Update.ini, File%A_Index%, AHKFile
				If File%A_Index%Name <> ERROR
				{
					IniRead, File%A_Index%URL, func_Update.ini, File%A_Index%, URL
					FileName = % File%A_Index%Name
					FileURL = % File%A_Index%URL
					FileAppend, 
					(
						URLDownloadToFile, %FileURL%, %FileName%
					), Update.ahk
				} else
				{
					break
				}
			}
			if CompileFile <> 
			{
				SplitPath CompileFile,, , CompileExt, CompileTo
				if CompileExt = ahk
				{
					FileAppend,
					(
						
						RunWait %InitialPath%Compiler\AHK2Exe.exe /in "%CompileFile%" /out "%CompileTo%.exe"
					), Update.ahk
				} else
				{
					MsgBox Files with "%CompileExt%" extension cannot be compiled.
				}
			}
			
			if RunFile <> 
			{
				SplitPath RunFile, , , RunExt
				if (RunExt = "ahk") or (RunExt = "exe") or (RunExt = "bat")
				{
					FileAppend,
					(
						
						Run %RunFile%
					), Update.ahk
				} else
				{
					MsgBox Only files with "ahk", "exe" or "bat" extensions may be run.
				}
			}
		} else 
		{
			FileDelete, func_Update.ini
			Return
		}
		
		FileAppend,
		(
		
			MsgBox Program has been successfully updated! Press OK to continue.
			
			Run tempupdate.bat,, hide
		), Update.ahk
		
	} else
	{
		if AHKFile = "" or URL = ""
		{
			MsgBox You must specify an AHKFile and URL if FromURL = False or 0
		}
		
		if (ProcessPath = "" and ProcessName = "")
		{
			NewPath = %AHKFile%
		} else
		{
			NewPath = %NewProcessPath%%NewProcessName%
		}
		
		if Compile = 1
		{
			SplitPath, Newpath, , , NewPathExt, NewPathNoExt
			If NewPathExt <> exe
			{
				NewPath = %NewPathNoExt%.exe
			}
		}
		
		FileAppend, 
		(
			UrlDownloadToFile, %URL%, %AHKFile%
		), Update.ahk
		
		FileAppend,
		(

			Compile = %Compile%
			RunNow = %RunNow%
			
			
			if Compile = 1
			{
				RunWait %InitialPath%Compiler\AHK2Exe.exe /in "%AHKFile%" /out "%NewPath%"
			}
			
			if RunNow = 1
			{
				Run %NewPath%
			}
			
			MsgBox Program has been successfully updated! Press OK to continue.
			
			Run tempupdate.bat,, hide
			
			ExitApp
		), Update.ahk
	}
	
	
	FileAppend,
	(
		%DelUpdate%
		del Update.AHK
		del tempUpdate.bat
	), tempupdate.bat	
	
	
	Run Update.ahk
	
	ExitApp
}