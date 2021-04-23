PreprocessScript(ByRef ScriptText, AhkScript, ExtraFiles, FileList="", FirstScriptDir="", Options="", iOption=0)
{
	SplitPath, AhkScript, ScriptName, ScriptDir
	if !IsObject(FileList)
	{
		FileList := [AhkScript]
		ScriptText := "; <COMPILER: v" A_AhkVersion ">`n"
		FirstScriptDir := ScriptDir
		IsFirstScript := true
		Options := { comm: ";", esc: "``" }
		
		OldWorkingDir := A_WorkingDir
		SetWorkingDir, %ScriptDir%
	}
	
	IfNotExist, %AhkScript%
		if !iOption
			Util_Error((IsFirstScript ? "Script" : "#include") " file """ AhkScript """ cannot be opened.")
		else return
	
	cmtBlock := false, contSection := false
	Loop, Read, %AhkScript%
	{
		tline := Trim(A_LoopReadLine)
		if !cmtBlock
		{
			if !contSection
			{
				if StrStartsWith(tline, Options.comm)
					continue
				else if tline =
					continue
				else if StrStartsWith(tline, "/*")
				{
					cmtBlock := true
					continue
				}
			}
			if StrStartsWith(tline, "(")
				contSection := true
			else if StrStartsWith(tline, ")")
				contSection := false
			
			tline := RegExReplace(tline, "\s+" RegExEscape(Options.comm) ".*$", "")
			if !contSection && RegExMatch(tline, "i)#Include(Again)?[ \t]*[, \t]?\s+(.*)$", o)
			{
				IsIncludeAgain := (o1 = "Again")
				IgnoreErrors := false
				IncludeFile := o2
				if RegExMatch(IncludeFile, "\*[iI]\s+?(.*)", o)
					IgnoreErrors := true, IncludeFile := Trim(o1)
				
				if RegExMatch(IncludeFile, "^<(.+)>$", o)
				{
					if IncFile2 := FindLibraryFile(o1, FirstScriptDir)
					{
						IncludeFile := IncFile2
						goto _skip_findfile
					}
				}
				
				StringReplace, IncludeFile, IncludeFile, `%A_ScriptDir`%, %FirstScriptDir%, All
				StringReplace, IncludeFile, IncludeFile, `%A_AppData`%, %A_AppData%, All
				StringReplace, IncludeFile, IncludeFile, `%A_AppDataCommon`%, %A_AppDataCommon%, All
				
				if FileExist(IncludeFile) = "D"
				{
					SetWorkingDir, %IncludeFile%
					continue
				}
				
				_skip_findfile:
				
				IncludeFile := Util_GetFullPath(IncludeFile)
				
				AlreadyIncluded := false
				for k,v in FileList
				if (v = IncludeFile)
				{
					AlreadyIncluded := true
					break
				}
				if(IsIncludeAgain || !AlreadyIncluded)
				{
					if !AlreadyIncluded
						FileList._Insert(IncludeFile)
					PreprocessScript(ScriptText, IncludeFile, ExtraFiles, FileList, FirstScriptDir, Options, IgnoreErrors)
				}			
			}else if !contSection && RegExMatch(tline, "i)^FileInstall[ \t]*[, \t][ \t]*([^,]+)[ \t]*(,[ \t]*([^,]+))?", o) ; TODO: implement `, detection
			{			
				if o1 ~= "[^``]%"
					Util_Error("Error: Invalid ""FileInstall"" syntax found. ")
				_ := Options.esc
				StringReplace, o1, o1, %_%`%, `%, All
				StringReplace, o1, o1, %_%`,, `,, All
				StringReplace, o1, o1, %_%%_%,, %_%,, All
				
				; if second parameter of FileInstall start with an asterisk, it is interpreted as a resource-type/resource-name/lang-id trio
				RegExMatch(o3, "^(\*)([^/]*)/?([^/]*)/?([^/]*)$", resId)

				ExtraFiles._Insert({file: o1, resType: resId2, resName: resId3, resLang: resId4, preProcess: !!resId1})

				ScriptText .= tline "`n"
			}else if !contSection && RegExMatch(tline, "i)^#CommentFlag\s+(.+)$", o)
				Options.comm := o1, ScriptText .= tline "`n"
			else if !contSection && RegExMatch(tline, "i)^#EscapeChar\s+(.+)$", o)
				Options.esc := o1, ScriptText .= tline "`n"
			else if !contSection && RegExMatch(tline, "i)^#DerefChar\s+(.+)$", o)
				Util_Error("Error: #DerefChar is not supported.")
			else if !contSection && RegExMatch(tline, "i)^#Delimiter\s+(.+)$", o)
				Util_Error("Error: #Delimiter is not supported.")
			else
				ScriptText .= (contSection ? A_LoopReadLine : tline) "`n"
		}else if StrStartsWith(tline, "*/")
			cmtBlock := false
	}
	
	Loop, % !!IsFirstScript ; equivalent to "if IsFirstScript" except you can break from the block
	{
		static AhkPath := A_IsCompiled ? A_ScriptDir "\..\AutoHotkey.exe" : A_AhkPath
		IfNotExist, %AhkPath%
			break ; Don't bother with auto-includes because the file does not exist
		
		Util_Status("Auto-including any functions called from a library...")
		ilibfile = %A_Temp%\_ilib.ahk
		IfExist, %ilibfile%, FileDelete, %ilibfile%
		AhkType := AHKType(AhkPath)
		if AhkType = FAIL
			Util_Error("Error: The AutoHotkey build used for auto-inclusion of library functions is not recognized.", 1, AhkPath)
		if AhkType = Basic
			Util_Error("Error: AutoHotkey Basic is not allowed as the build used for auto-inclusion of library functions.", 1, AhkPath)
		RunWait, "%AhkPath%" /iLib "%ilibfile%" "%AhkScript%", %FirstScriptDir%, UseErrorLevel
		IfExist, %ilibfile%
		{
			PreprocessScript(ScriptText, ilibfile, ExtraFiles, FileList, FirstScriptDir, Options)
			FileDelete, %ilibfile%
		}
		StringTrimRight, ScriptText, ScriptText, 1 ; remove trailing newline
	}
	
	if OldWorkingDir
		SetWorkingDir, %OldWorkingDir%
}

FindLibraryFile(name, ScriptDir)
{
	libs := [ScriptDir "\Lib", A_MyDocuments "\AutoHotkey\Lib", A_ScriptDir "\..\Lib"]
	p := InStr(name, "_")
	if p
		name_lib := SubStr(name, 1, p-1)
	
	for each,lib in libs
	{
		file := lib "\" name ".ahk"
		IfExist, %file%
			return file
		
		if !p
			continue
		
		file := lib "\" name_lib ".ahk"
		IfExist, %file%
			return file
	}
}

StrStartsWith(ByRef v, ByRef w)
{
	return SubStr(v, 1, StrLen(w)) = w
}

RegExEscape(t)
{
	static _ := "\.*?+[{|()^$"
	Loop, Parse, _
		StringReplace, t, t, %A_LoopField%, \%A_LoopField%, All
	return t
}
