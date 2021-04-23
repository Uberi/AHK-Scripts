#Include ScriptParser.ahk
#Include IconChanger.ahk

AhkCompile(ByRef AhkFile, ExeFile="", ByRef CustomIcon="", BinFile="", UseMPRESS="")
{
	global ExeFileTmp
	AhkFile := Util_GetFullPath(AhkFile)
	if AhkFile =
		Util_Error("Error: Source file not specified.")
	SplitPath, AhkFile,, AhkFile_Dir,, AhkFile_NameNoExt
	
	if ExeFile =
		ExeFile = %AhkFile_Dir%\%AhkFile_NameNoExt%.exe
	else
		ExeFile := Util_GetFullPath(ExeFile)
	
	ExeFileTmp := ExeFile
	
	if BinFile =
		BinFile = %A_ScriptDir%\AutoHotkeySC.bin
	
	Util_DisplayHourglass()
	
	IfNotExist, %BinFile%
		Util_Error("Error: The selected AutoHotkeySC binary does not exist.", 1, BinFile)
	
	try FileCopy, %BinFile%, %ExeFile%, 1
	catch
		Util_Error("Error: Unable to copy AutoHotkeySC binary file to destination.")
	
	BundleAhkScript(ExeFile, AhkFile, CustomIcon)
	
	if FileExist(A_ScriptDir "\mpress.exe") && UseMPRESS
	{
		Util_Status("Compressing final executable...")
		RunWait, "%A_ScriptDir%\mpress.exe" -q -x "%ExeFile%",, Hide
	}
	
	Util_HideHourglass()
	Util_Status("")
}

BundleAhkScript(ExeFile, AhkFile, IcoFile="")
{
	SplitPath, AhkFile,, ScriptDir
	
	ExtraFiles := []
	PreprocessScript(ScriptBody, AhkFile, ExtraFiles)
	;FileDelete, %ExeFile%.ahk
	;FileAppend, % ScriptBody, %ExeFile%.ahk
	VarSetCapacity(BinScriptBody, BinScriptBody_Len := StrPut(ScriptBody, "UTF-8"))
	StrPut(ScriptBody, &BinScriptBody, "UTF-8")
	
	module := DllCall("BeginUpdateResource", "str", ExeFile, "uint", 0, "ptr")
	if !module
		Util_Error("Error: Error opening the destination file.")
	
	if IcoFile
	{
		Util_Status("Changing the main icon...")
		if !ReplaceAhkIcon(module, IcoFile, ExeFile, 159)
		{
			; Error was already displayed
			gosub _EndUpdateResource
			Util_Error("Error changing icon: Unable to read icon or icon was of the wrong format.")
		}
	}
	
	Util_Status("Compressing and adding: Master Script")
	if !DllCall("UpdateResource", "ptr", module, "ptr", 10, "str", IcoFile ? ">AHK WITH ICON<" : ">AUTOHOTKEY SCRIPT<"
	          , "ushort", 0x409, "ptr", &BinScriptBody, "uint", BinScriptBody_Len, "uint")
		goto _FailEnd
	
	oldWD := A_WorkingDir
	SetWorkingDir, %ScriptDir%
	for each,resFile in ExtraFiles
	{
		file := resFile.file
		Util_Status("Compressing and adding: " file)
		
		IfNotExist, %file%
			goto _FailEnd2
		
		resType := toUpper(ifDefault(trim(resFile.resType),10)) ; default resource-type: RT_RCDATA = 10
		resName := toUpper(ifDefault(trim(resFile.resName),file)) ; default resource-name: the file name
		resLang := ifDefault(resFile.resLang+0, 0x409) ; default language: english (0x409)

		if(file ~= "i)\.ico$" and resType==14){ ; .ico files added to the icon-group section require special handling
			ReplaceAhkIcon(module, file, ExeFile, resName, resLang)
		}else{
			if(file ~= "i)\.ahk$" and resFile.preProcess){ ; if it's a AHK script and pre-processing is enabled then we preprocess it
				PreprocessScript(scriptCont, file, [])
				VarSetCapacity(filedata, filesize := StrPut(scriptCont, "UTF-8"))
				StrPut(scriptCont, &filedata, "UTF-8")
	
			}else{ ; any other file type is added as is
			
				; This "old-school" method of reading binary files is way faster than using file objects.
				FileGetSize, filesize, %file%
				VarSetCapacity(filedata, filesize)
				FileRead, filedata, *c %file%
			}
	
			if !DllCall("UpdateResource"
						, "ptr", module
						, isNum(resType)?"ptr":"str", resType
						, isNum(resName)?"ptr":"str", resName
						, "ushort", resLang
						, "ptr", &filedata
						, "uint", filesize, "uint")
				goto _FailEnd2
			VarSetCapacity(filedata, 0)
		}
	}
	SetWorkingDir, %oldWD%
	
	gosub _EndUpdateResource
	return
	
_FailEnd:
	gosub _EndUpdateResource
	Util_Error("Error adding script file:`n`n" AhkFile)
	
_FailEnd2:
	gosub _EndUpdateResource
	Util_Error("Error adding FileInstall file:`n`n" file)
	
_EndUpdateResource:
	if !DllCall("EndUpdateResource", "ptr", module, "uint", 0)
		Util_Error("Error: Error opening the destination file.")
	return
}

ifDefault(param,default){
	return param=="" ? default : param
}

toUpper(str){
	StringUpper str, str
	return str
}

isNum(param){
	if param is number
		return true
	return false
}

Util_GetFullPath(path)
{
	VarSetCapacity(fullpath, 260 * (!!A_IsUnicode + 1))
	if DllCall("GetFullPathName", "str", path, "uint", 260, "str", fullpath, "ptr", 0, "uint")
		return fullpath
	else
		return ""
}
