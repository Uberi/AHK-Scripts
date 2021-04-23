/*
	An extension of Container designed to make interacting with files and folders through AHK easier.

	For online documentation
	See http://www.autohotkey.net/~Rapte_Of_Suzaku/Documentation/files/FC-ahk.html
	
	Release #6.1
	
	bugfix: explorer construction method now properly decodes the URI format (no more %20s and such)
	bugfix: explorer construction method appends "\" to path returned in "folder" mode
	
	
	Joshua A. Kinnison
	2010-10-22, 13:54
*/
;=======================================================================================================================
;==== DEFAULT PREFERENCES ==============================================================================================
;=======================================================================================================================
FC_DefaultPreferences(name,value="")
{
	static
	if !_init
	{	
		_init := true
		; important paths
		7zip                		:= "G:\Workspace\Programs\7-zip\App\7-Zip\7z.exe"
		
		; default flags	
		FO_DELETE_flags     		:= "FOF_NOCONFIRMATION|"
		FO_COPY_flags       		:= "FOF_ALLOWUNDO|"
		FO_MOVE_flags       		:= "FOF_ALLOWUNDO|"
		flags               		:= "FOF_SIMPLEPROGRESS|FOF_NOCONFIRMMKDIR|"
			
		; zip preferences	
		zip_switches				:= "-y"
		zip_ask						:= 1
		zip_hide					:= 1
			
		; unzip preferences	
		unzip_switches				:= "-o* -aou -y"
		unzip_spill					:= 0
		unzip_shorten				:= 1
		unzip_clean					:= 1
		unzip_delete				:= 0
		unzip_hide					:= 1
		unzip_manipulate			:= "RegExReplace"
		unzip_manip_params			:= Object(1,"\s*\.[^\\]*\\$",2,"\")
				
		; uncategorized		
		
		file_fix					:= 1

		; defaults already set through Container
		;file_delim					:= "`n"
		;file_encoding				:= "UTF-16"
		;file_cpi					:= 1200 ; is UTF-16
		;file_overwrite				:= 0
		
		;list_delim					:= "`n"
		;list_omit					:= "`r"
		
		; override sort method
		sort_type					:= "Split"				; bucket sorting using callbacks
		sort_method					:= "depthsort"			; sorts by depth
		
		
		catch_always           		:= 0
		catch_disable_on_take 		:= 0
		rename_method       		:= "FC_MakePathSuggestion"
		
		clip_delim					:= "`n"
		
		explore_warn				:= 10
		
		pattern_recurse				:= 0
		pattern_folders				:= 0
		
		regex_recurse				:= 1
		regex_folders				:= 1
			
		;template_take_catch			:= 0
		;copy_take_catch				:= 1
			
		shorten_delete				:= 1
			
		rme_recurse					:= 1
		
		attr_recurse				:= 0
		attr_catch					:= 1
			
		stats_units					:= "__noThing__"
		
		prompt_use_standard_dialog	:= 0
		
		
		; NEW
		enfolder_prompt				:= 1
		enfolder_return_mode		:= "simple"
		
		explorer_mode				:= "selection"
		explorer_fix				:= 1
		
		;method						:= "list"
		;source						:= "__noThing__"
	}
	
	if (value!="")
		%name% := value
	
	;MsgBox % "returning " %name%
	return (%name%)
}
;=======================================================================================================================
;==== Overrides ========================================================================================================
;=======================================================================================================================
FC_file(f, fpath, delimiters="__deFault__", omit="__deFault__", fix="__deFault__")
{
	f._prefs("file_fix",fix)
	len_before := f.len()
	Container_file(f,fpath,delimiters,omit)
	
	Loop % f.len()-len_before
	{
		i := A_Index+len_before
		f[i] := dir_fixer(f[i])
	}	
}
dir_fixer(item)
{
	if IsFolder(item)
		return item
	FileGetAttrib, attr, %item%
	IfInString attr, D
		return item . "\"
	return item
}
depthsort(item)
{
	StringReplace, item, item, \, \, UseErrorLevel
	return ErrorLevel + (SubStr(item,0,1)!="\")
}
FC_refresh(f,param="__deFault__")
{
	if (f._method="catch")
		return f
	else if f._prefs("catch_always")
		f.catch := f.new("catch")
	return Container_refresh(f,param)
}
FC_makeTemplate(f,take="")
{
	f_new := Container_makeTemplate(f)
	
	if f._catch and take
		f_new._catch := f.takeCatch()

	return f_new
}
FC_makeCopy(f,leave_catch=0)
{
	return f.makeTemplate(!leave_catch).absorb(f)
}
FC_absorb(f,params*)
{
	Container_absorb(f,params*)
	for i,param in params
		f._catch.absorb(param.takeCatch())
	return f
}
FC_MakePathSuggestion(path)
{
	;p := Path(path)
	p := FC_(path)
	while FileExist(suggestion := p.dir p.namenoext " (" A_Index+1 ")." p.ext)
		continue
	return suggestion
}
FC_enableCatch(f)
{
	if !f._catch
		f._catch := FC("catch")
}
FC_disableCatch(f)
{
	f._catch := ""
}
; while catches shouldn't leak all over, catchability should spread quickly
FC_takeCatch(f,disable="__deFault__")
{
	f._prefs("catch_disable_on_take",disable)
	ret := f._catch
	if ret
	{
		f.disableCatch()	; clears it too
		if !disable
			f.enableCatch()
	}
	return ret
}
; only have to filter newly added items
;FC_pattern(f, pattern, options="", regexp="")
FC_pattern(f, pattern, folders="__deFault__", recurse="__deFault__", regexp="")
{
	;Loop, Parse, options, =`,, %A_Space%
	;	A_Index & 1	? (  __  := SubStr(A_LoopField,1,3)) : ( %__% := A_LoopField )
	f._prefs("pattern_folders",folders,"pattern_recurse",recurse)
	if folders != 2
		Loop %pattern%, 0, %recurse% 				; get the files first
			f.add(A_LoopFileFullPath)
	if folders										; then loop through folders	(to add a slash)
		Loop %pattern%, 2, %recurse%
			f.add(A_LoopFileFullPath . "\")
	if regexp
		f.filterTF("RegExMatch",true,regexp)
	return f
}
;FC_regex(f,base,regexp, options="")
FC_regex(f,base,regexp, folders="__deFault__", recurse="__deFault__")
{
	;Loop, Parse, options, =`,, %A_Space%
	;	A_Index & 1	? (  __  := SubStr(A_LoopField,1,3)) : ( %__% := A_LoopField )
	f._prefs("regex_folders",folders,"regex_recurse",recurse)
	
	return FC_pattern(f,base . "*.*", folders, recurse, regexp)
	;return FC_pattern(f,base . "*.*", "fol=" folders " rec=" recurse, regexp)
}

; NEW
FC_explorer(f,hwnd="",mode="__deFault__",fix="__deFault__")
{
	hwnd := hwnd ? hwnd : WinExist("A")
	WinGetClass class, ahk_id %hwnd%
	
	if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				break
	
	if !IsObject(window)
		return f
	
	f._prefs("explorer_mode",mode,"explorer_fix",fix)
	
	/*
	if (mode="folder")
	{
		comobj := window
		field := "LocationURL"
	}
	else if (mode="selection")
	{
		comobj := window.Document.SelectedItems
		field := "path"
	}
	else if (mode="all")
	{
		comobj := window.Document.Folder.Items
		field := "path"
	}
	*/
	
	; dang MaxIndex
	start_at := f.len() ? f.len()+1 : 1
	if (mode="folder")
	{
		path := window.LocationURL
		path := SubStr(path,InStr(path,"///")+3)
		f.add(path "\")
	}
	else
	{
		doc := window.Document
		Container_COM(f,doc[ (mode="all" ? "Folder.Items" : "SelectedItems") ],"path")
	}
	
	Loop % f.len()-start_at+1
	{
		i := a_Index+start_at-1
		path := f[i]
		StringReplace, path, path, /, \, All 
		if fix
			path := dir_fixer(path)
		
		; thanks to polyethene
		Loop
			If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
				StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
			Else Break
		
		f[i] := path
	}
	
	return f
}
;=======================================================================================================================
;==== BASIC CONTAINER ==================================================================================================
;=======================================================================================================================
; removes paths that are already defined implicitly
FC_simplify(f)
{
	f.sort("command","")
	n := i := 0
	Loop
	{
		if (SubStr(f[++i],0,1)=="\")
			if (SubStr(f[i+1],1,StrLen(f[i]))=f[i])
				continue
		if !(f[++n] := f[i])
			break
	}
	return f.xRange(n)
}
; removes subitems from the list, usually to avoid conflicts
FC_reduce(f)
{
	f.sort("command","")
	n := i := 0
	while f[++n] := f[++i]
	{
		if (SubStr(f[i],0,1)=="\")
		{
			len := StrLen(base := f[i])
			while (SubStr(f[++i],1,len)==base)
				continue
			--i
		}
	}
	return f.xRange(n)
}
; get real containing would be nice too... if you don't want to accidentally affect non contained existing items
FC_makeContaining(f)
{
	fc := f.get("reduce")
	common := FC_(fc[1])
	Loop % fc.len()
	{
		target := fc[A_Index]
		while (!InStr(target,common.path))
			common := FC_(common.dir)
		if common.path
			continue
		ErrorLevel := "No Common Path Found"
		break
	}
	return f.bud("list",common.path)
}
FC_makeExpansion(f,includeFolders="__deFault__",recursive="__deFault__",pattern="__deFault__",f2="__deFault__")
{
	; default to original parameters if applicable
	if (includeFolders == "__deFault__")
	{
		if (f._method="pattern")
			includeFolders := f._params[1]
		else if (f._method="regex")
			includeFolders := f._params[2]
		else
			includeFolders := 1
	}
	if (recursive == "__deFault__")
	{
		if (f._method="pattern")
			recursive := f._params[2]
		else if (f._method="regex")
			recursive := f._params[3]
		else
			recursive := 1
	}
	pattern  := (pattern!="__deFault__")	? pattern 	: "*"
	f_target := (f2!="__deFault__") 		? f2 		: f.makeTemplate()
	
	Loop % (folders := f.folders()).len()
		f_target.extend("pattern",folders[A_Index] pattern,includeFolders,recursive)
	return f_target
}
FC_expand(f,includeFolders="__deFault__",recursive="__deFault__",pattern="__deFault__")
{
	; do any languages allow for automagically prespecifying the return variable? (instead of passing it in explicitly)
	return f.makeExpansion(includeFolders,recursive,pattern,f)
}
;=======================================================================================================================
;==== BUILT-IN FILTERS =================================================================================================
;=======================================================================================================================
; callbacks are inefficient.  But so very convenient.  T_T
FC_iAttr(f,attr)
{
	return f.filter("hasAttributes", true, attr)
}
FC_xAttr(f,attr)
{
	return f.filter("hasAttributes", false, attr)
}
hasAttributes(item,list)
{
	FileGetAttrib, attr, %item%
	If attr contains %list%
		return true
}
FC_files(f)
{
	return f.filter("IsFolder",false)
}
FC_folders(f)
{
	return f.filter("IsFolder",true)
}
IsFolder(item)
{
	return (SubStr(item,0,1)="\")
}
IsFile(item)
{
	return !IsFolder(item)
}
FC_iExists(f)
{
	return f.filterTF("PathExist",true)
}
FC_xExists(f)
{
	return f.filterTF("PathExist",false)
}
PathExist(item)
{
	return !!FileExist(item)
}
;==========================================================================================================================================================================================
;= FILE OPERATIONS ========================================================================================================================================================================
;==========================================================================================================================================================================================
FC_create(f,extra_flags="")
{
	blank_file := f.makeTemp("file", true)
	blank_dir := f.makeTemp("folder", true)
	dest := f.get("simplify")
	source := FC()
	Loop % dest.len()
		source.add(IsFolder(dest[A_Index]) ? blank_dir : blank_file)
	; operation -undo
	return ShFO("FO_COPY", source, dest, extra_flags)
}
FC_recycle(f,extra_flags="")
{
	return f.delete(extra_flags "FOF_ALLOWUNDO|FOF_WANTNUKEWARNING|")
}
FC_delete(f,extra_flags="")
{
	return ShFO( "FO_DELETE", f.makeCopy().xDuplicates().reduce().iExists(),"", extra_flags)
}
FC_moveInto(f,p1,extra_flags="")
{	
	return f.move(p1,extra_flags,"into")
}
FC_moveOnto(f,p1,extra_flags="")
{
	return f.move(p1,extra_flags,"onto")
}
FC_move(f,p1, extra_flags="", dest_mode="onto")
{
	return FC_operation(f,"FO_MOVE",p1,extra_flags,dest_mode)
}
FC_copyInto(f,p1, extra_flags="")
{
	return f.copy(p1,extra_flags,"into")
}
FC_copyOnto(f,p1, extra_flags="")
{
	return f.copy(p1,extra_flags,"onto")
}
FC_copy(f,p1, extra_flags="", dest_mode="onto")
{
	return FC_operation(f,"FO_COPY",p1,extra_flags,dest_mode)
}
; maybe work quick regex stuff back into this later
FC_rename(f,p1,extra_flags="")
{
	return f.moveOnto(p1,extra_flags)
}
; need to update this for dest_mode stuff
/*
FC_moveContents(f,p1, extra_flags="")
{
	source := f.makeTemplate()
	; make the mapping explicit (in case of single destination folder)
	dest := IsObject(p1) ? p1 : FC("list",p1)
	if (dest.len() < f.len())
		Loop % f.len()
			dest[A_Index] := dest[1]
	
	; expand to list contents explicitly
	Loop % f.len()
	{
		i := A_Index
		new_source := FC("pattern",f[i] "*",1,0)
		source.absorb(new_source)
		Loop % new_source.len()
			destination.add(dest[i])
	}
	return FC_operation(source,"FO_MOVE",destination,extra_flags)
}
*/
;==== Enfolder =========================================================================================================
;=======================================================================================================================
FC_enfolder(f,dest="",prompt="__deFault__",return_mode="__deFault__")
{
	if (dest := f.promptForPath(dest, "Please provide a name for the new folder.",f._prefs("enfolder_prompt",prompt)))
		res := f.moveInto(dest "\" )
	if (f._prefs("enfolder_return_mode",return_mode)="simple")
		res := res.become("list",dest "\") 
	return res
}
FC_enfolderEach(f,return_mode="__deFault__")
{
	ret := f.makeTemplate(1)
	Loop % f.len()
		ret.extend("list",FC("list",f[A_Index]).enfolder("",false,return_mode))
	return ret
}
;==== Spill ============================================================================================================
;=======================================================================================================================
FC_spiller(f,folders,recurse,delete)
{	
	flatten := folders and recurse
	folders := flatten ? 0 : folders

	source 		 := f.makeTemplate(1)	; template, but with catch propogated
	for_deletion := f.makeTemplate()
	for_creation := f.makeTemplate()
	dest := FC()
	
	is_folder := f.makeSplit("IsFolder")
	unchanged := is_folder[false] ? is_folder[false] : f.makeTemplate()		; any way to do this with default constructor?
	folder_fc := is_folder[true]
	
	Loop % folder_fc.len()
	{
		folder := FC_(folder_fc[A_Index])
		new_source := FC("pattern",folder.path "*.*",folders,recurse)		; obtain requested subitems of this folder
		dest.extend("listn",folder.dir,new_source.len())
		source.absorb(new_source)											; add new sources to the source FileContainer, assumed that folders don't overlap -> fast mode OK
			
		if (delete)		; at the very least, the delete flag indicates that the spilt folder should be deleted
			for_deletion.add(folder.path)
		else
			unchanged.add(folder.path)
		if (flatten)	; if flattening, the folders need to be spilt too.  But rather than moving them, just recreate them
			for_creation.absorb(FC("pattern",folder.path . "*.*",2,1).manipulate("move_helper", folder.dir))
	}
	; could move the folders last... no need to recreate them [ can't undo after merge, so no point]
	; could merge folders instead [can't undo after merge, so no point]	
	; isempty filter before rme is a bit odd, but quick way to prevent duplicates
	return source.moveInto(dest).absorb(for_creation.create(), unchanged, for_deletion.filter("IsEmpty",true).removeEmptyFolders(0))
}
FC_leak(f,delete=0)
{
	return f.spiller(0,0,0)
}
FC_spill(f,delete=0)
{
	return f.spiller(1,0,delete)
}
FC_dump(f,delete=0)
{
	return f.spiller(0,1,delete)
}
FC_flatten(f,delete=0)
{
	return f.spiller(1,1,delete)
}
move_helper(item,dir)
{
	SplitPath item, name, folder
	if !name
	{
		SplitPath folder, name
		tail := "\"
	}
	return dir . name . tail
}
;==== zip ==============================================================================================================
;=======================================================================================================================
; still no error handling for 7-zip stuff
FC_zip(f,destination="", options="")
{	
	
	ask:=hid:=swi:="__deFault__"
	Loop, Parse, options, =`,, %A_Space%
		A_Index & 1	? (  __  := SubStr(A_LoopField,1,3)) : ( %__% := A_LoopField )
	f._prefs("zip_ask",ask,"zip_hide",hid,"zip_switches",swi)

	ret := f.makeTemplate(1)
	if (destination := f.promptForPath(destination,"Please provide a name for the new archive.", ask))
	{
		TrayTip,, Now zipping...
		
		f.run7z("a """ . destination . ".zip"" @""" . f.toFile(f.makeTemp(),"enc=UTF-8") . """ " . swi,"", hid)	
		TrayTip,, Done!
		ret.add(destination ".zip")
	}
	else ; caught items:  all were aborted
		ret._catch.absorb(f)
	return ret
}
/*
FC_zipEach(f,options="")
{
	ret := f.makeTemplate(1)
	Loop % f.len()
		ret.extend("list",FC("list",f[A_Index]).zip("",options)[1])
	return ret
}
*/
; option to spill if only folders are present?  What would I call that?  Or just an option for here?
; delete option is a bit poor...  need error handling for 7zip
/*
	optional processing settings, in order of effect with defaults in []:
	
		hide [1]			---->		1 to hide 7-zip progress (command line)
		switches			---->		command line switches to be used with 7zip
		manipulate [*]		---->		name of function to call manipulate with
			p1-p8 [*]			---->		values to pass to manipulate
		shorten [1]			---->		1 to shorten folder (automatically recursive, otherwise it would be pointless)
		spill [0]			---->		1 to spill folder
		clean [1]			---->		1 to delete empty folders generated during shorten and spill operations
		delete [0]			---->		1 to delete archives when done
		
		* manipulate defaults to call RegExReplace(item,"\s*[.][^\]*\$","\") for each base folder
		  generated while unzipping.  This manipulation finds the first period in the folder
		  name and removes the preceding spaces, the period, and everything after the period.
		  This is for when folder names have fake extensions and look like "Folder.txt".  Not only
		  does it look stupid, but it can also conflict with file names.
		  
		  When not overriden, unused p#s will default to "__deFault__"
		
		only the first 3 letters of any given option need to be specified
		
		example:
			f.unzip("hide=0 del=1 spi=1")
*/
FC_unzip(f,options="",man="__default__",params*)
{
	; choose settings for the operation
	spi:=sho:=cle:=del:=hid:=man:=swi:="__deFault__"
	Loop, Parse, options, =`,,%A_Space%
		A_Index & 1	? (  __  := SubStr(A_LoopField,1,3)) : ( %__% := A_LoopField )
	f._prefs("unzip_spill",spi,"unzip_shorten",sho,"unzip_clean",cle,"unzip_delete",del,"unzip_hide",hid)
	f._prefs("unzip_manipulate",man,"unzip_switches",swi)
	
	params := params.MaxIndex() ? params : f._prefs("unzip_manip_params")
	
	new_f := f.makeTemplate(1)
	files := f.get("files")
	TrayTip,, Now unzipping...
	Loop % files.len()
	{
		item := FC_(files[A_Index])
		TrayTip,, % "Now unzipping '" item.path "'`n(" A_Index " of " files.len() ")"
		f.run7z("x" . " """ . item.path . """ " . swi,item.dir, hid)
		new_f.add(item.dir . item.nameNoExt . "\")
		
	}
	;dout_om(new_f,"new_f before man")
	;MSgBox
	TrayTip,, Now processing...
	if man
		new_f := new_f.doManip(man,params*)
	;dout_om(new_f,"new_f before shorten")
	;MSgBox
	if sho
		new_f := new_f.shortenAll(cle)
	;dout_om(new_f,"new_f before spill")
	;MSgBox
	if spi
		new_f := new_f.spill(cle)
	;dout_om(new_f,"new_f before delete")  ; perfect here!
	if del
		new_f.absorb(files.delete())
	;dout_om(new_f,"new_f at end of unzip") ; dead!
	TrayTip,, Done!
	return new_f
}
; more just a helper...
FC_run7z(f, line, working_dir, hide)
{
	;if (SubStr(line,1,1)=="x")
		;MsgBox % "line='" line "'"
	return f._runWait(f._prefs("7zip") " " line, working_dir, hide ? "hide":"")	
}
; assumes item is already known to be a folder
remove_dir_ext(item)
{
	return RegExReplace(item,"\s*[.].*","\")
}
;==== Shorten ==========================================================================================================
;=======================================================================================================================
FC_shorten(f, delete="__deFault__", recursive=false)
{
	f._prefs("shorten_delete",delete)
	is_folder := f.makeSplit("IsFolder")	
	if recursive
		is_folder[true].expand(2,1)
	
	can_shorten := is_folder[true].makeSplit("canShorten")	
	target_split := can_shorten[true].makeSplit("depthsort")	
	
	;dout_om(is_folder[true],"folder targets")
	;dout_om(can_shorten[true],"shorten targets")
	;dout_om(target_split,"target split")
	
	dest := f.makeTemplate(1).absorb(is_folder[false],can_shorten[false])
	;dout_om(dest,"shorten dest")
	keys := Object()
	for depth in target_split
		keys[len := A_Index] := depth
	;GoSub dout_vars
	Loop %len%
		dest.absorb(target_split[keys[len+1-A_Index]].spill(delete))
	;dout_om(dest.iExists(),"result of shorten")
	return dest.iExists()
}
FC_ShortenAll(f,delete="__deFault__")
{
	return f.shorten(f,delete,1)
}

shorten_helper(folder)
{
	return FC_(folder).dir
}
canShorten(item)
{
	num_files := 0
	loop %item%*.*
		if (num_files := A_Index)
			break
	num_folders := 0
	if !num_files
		Loop %item%*.*,2
			if ( (num_folders := A_Index) == 2 )
				break
	return (num_folders = 1 and num_files = 0)
}
;==== Remove Empty Folders =============================================================================================
;=======================================================================================================================
; recursive mode to remove folders that only have empty folders in them too ?
; ah, the return was blank if nothing was deleted!  this is WRONG!!
FC_removeEmptyFolders(f,recursive="__deFault__")
{
	f._prefs("rme_recurse",recursive)
	is_folder := f.makeSplit("IsFolder")
	is_empty := is_folder[true].makeSplit("IsEmpty")
	if recursive
		is_empty[true].absorb(f.makeExpansion(2).filter("IsEmpty",true))
	
	return f.makeTemplate(1).absorb(is_empty[true].delete(),is_folder[0],is_empty[0])
}
;==== Up ===============================================================================================================
;=======================================================================================================================
FC_up(f)
{
	return f.doManip("up_helper")
}
up_helper(item)
{
	p := FC_(item)
	return FC_(p.dir).dir . p.name
}
;==== DoManip ==========================================================================================================
;=======================================================================================================================
FC_doManip(f,func, params*)
{
	return f.moveOnto(f.makeCopy(1).manipulate(func,params*))
}
;==== setAttr ====================================================================================================
;=======================================================================================================================
; option to not remove failed items?
FC_setAttr(f,attributes,recursive="__deFault__",catch="__deFault__")
{
	f._prefs("attr_recurse",recursive,"attr_catch",catch)
	c := 0
	ret := f.makeTemplate(1)
	Loop % f.len()
	{
		path := f[A_Index]
		FileSetAttrib, %attributes%, %path%, 1, %recursive%
		if !ErrorLevel
			ret.add(f[A_Index])
		else if catch
			ret._catch.add(f[A_Index])
	}
	return ret
}
;==== RenameAsText =====================================================================================================
;=======================================================================================================================
FC_renameAsText(f,editor="__deFault__")
{
	return f.moveOnto(f.makeCopy().editAsText(editor))
}
;==========================================================================================================================================================================================
;= OUTPUT =================================================================================================================================================================================
;==========================================================================================================================================================================================
FC_run(f,line)
{
	; notepad++ tries to open gibberish if passed a blank parameter... weird
	if !f.len()
		return
	del := """ """
	list := " """ . SubStr(f.toList(del),1,-StrLen(del)) . """"
	Run % line . list
}
FC_exploreAll(f,warn="__deFault__")
{
	return f.explore(0,warn)
}
FC_exploreBase(f,warn="__deFault__")
{
	return f.explore(1,warn)
}
FC_explore(f, base_only=false, warn="__deFault__")
{
	f._prefs("explore_warn",warn)
	
	
	f := base_only ? f.makeContaining() : f.folders()
	n := f.len()
	
	if ( warn != -1 and n > warn )
	{   ; warning + YesNo
		MsgBox, 52, Warning, This operation will open %n% folders... Would you like to continue?
		IfMsgBox No
			return
	}
	Loop %n%
		Run % "explore " f[A_Index]
}
; could probably be updated... does it even work still?
FC_makeStats(f, desired_units="__deFault__")
{
	f._prefs("stats_units",desired_units)
	stats := Object()
	TotalSize := 0
	num_files := 0
	num_folders := 0
	Loop % f.len()
	{
		item := f[A_Index]
		FileGetAttrib attr, %item%
		IfInString attr, D
		{ ; recursively handle folder
			Loop %item%\*.*,1,1
			{
				TotalSize += %A_LoopFileSize%
				
				FileGetAttrib attr, %A_LoopFileFullPath%
				IfInString attr, D
					num_folders++
				else
					num_files++
			}
			num_folders++
		}
		else
		{ ; just a file
			num_files++
			FileGetSize size, %item%
			TotalSize += %size%
		}
	}
	
	; determine the appropriate units
	; if you get past YB, please contact me!
	unit_list =B KB MB GB TB PB EB ZB YB
	StringSplit, units, unit_list, %A_Space%
	Loop
	{
		unit := units%A_Index%
		if (TotalSize < 1024 OR desired_units = unit)
			break
		TotalSize := TotalSize / 1024.00
	}

	msg := "total size = " TotalSize " " unit
	msg .= "`n# files = " num_files
	msg .= "`n# folders = " num_folders
	
	stats.size 			:= TotalSize
	stats.units 		:= unit
	stats.num_files 	:= num_files
	stats.num_folders 	:= num_folders
	stats.msg			:= msg
	
	return stats
}
; saves a recursive simplified list to the clipboard.  minimum text required to recreate the filestructure
; more for my own testing than anything else
fc_structureToClipboard(f)
{
	return f.get("expand").simplify().toClipboard()
}
;==========================================================================================================================================================================================
;= HELPER FUNCTIONS =======================================================================================================================================================================
;==========================================================================================================================================================================================
remove_trailing_slash(item)
{
	return IsFolder(item) ? SubStr(item,1,-1) : item
}

; checks if given real item is a directory or not and adds the slash where appropriate

isEmpty(folder)
{
	Loop %folder%*.*,1,0
		return false
	return true
}
kill_bad_spaces(path)
{
	path := RegExReplace(path,"\s*(\.|$)","$1")	; trailing spaces are bad
	path := RegExReplace(path,"^\s*")			; leading spaces are bad
	return path
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; would using Path objects be efficient enough?
; could they be more efficient!?
;		- creating and accessing would be slightly slower
;		- manipulating would take more effort too
;		+ copying and passing would be more efficient! (pointers rather than string copying)
;		... probably overall worse.
FC_promptForPath(f, path="", msg="", prompt=true, use_standard_dialog="__deFault__")
{
	f._prefs("prompt_use_standard_dialog",use_standard_dialog)
	p := FC_(f[1])
	dir := p.dir
	nameNoExt := p.nameNoExt

	; ask user for path if not provided
	if !path
	{
		; generate a simple suggestion for the user
		; should generalize this part and make it configurable****
		if (SubStr(nameNoExt,0,1) = "\")						; remove trailing slash if present	
			StringTrimRight, nameNoExt, nameNoExt, 1
		StringReplace, suggestion, nameNoExt, _, %A_Space%,All	; underscores to spaces
		suggestion := kill_bad_spaces(suggestion)
		if dir not contains anime
			suggestion := RegExReplace(suggestion,".*","$T0")		; title case
		
		; allow the user to specify the path
		if prompt
		{
			if use_standard_dialog
				FileSelectFolder, path, dir,1+2+4
			else
				InputBox,path,%msg%,The path will be relative to "%dir%" unless a full path is given,,,,,,,,%suggestion%		
			if ErrorLevel
				return
		}
		else
			path := suggestion
	}
	if !path
		return
	
	if (SubStr(path,0,1) = "\")				
		StringTrimRight, path, path, 1 		; can't yet tell if this is a folder or file, so remove any backslashes now (added back later if necessary)
	IfNotInString path, :					
		path := dir . path 				; convert relative paths to absolute paths
	
	return path
}
; bugged me a lot
MsgBox(p1,p2="",p3="",p4="")
{
	static list="Yes|No|OK|Cancel|Abort|Ignore|Retry|Continue|TryAgain|Timeout"
	MsgBox, %p1%, %p2%, %p3%, %p4%
	Loop Parse, list, |
		IfMsgBox %A_LoopField%
			return A_LoopField
	return ErrorLevel := "!?"
}
;==========================================================================================================================================================================================
;= INTERNAL STUFF =========================================================================================================================================================================
;==========================================================================================================================================================================================

FC_operation(f,operation,destination_in="",extra_flags="",dest_mode="onto")
{ 
	;dout_f(A_ThisFunc)
	destination := IsObject(destination_in) ? destination_in.makeCopy() : FC("list",destination_in)
	;dout_o(f,"f into operation")
	source := f.makeCopy().rsortLinked(destination)
	; rsortLinked can introduce blanks
	destination.xBlanks()
	
	
	;dout_o(destination,"dest op")
	
	; expand single destination to a 1-to-1 mapping between source and destination
	dest := destination[1]
	if ( destination.len() == 1 and source.len() != 1)
		Loop % source.len()
			destination[A_Index] := dest
	
	; deal with ambiguity of destination folders
	if (dest_mode="into")
		Loop % source.len()
			If IsFolder(d:=destination[A_Index])
				destination[A_Index] := d . FC_(source[A_Index]).name
	
	; avoid destination is subfolder of source problem by percolating upwards
	; mostly for enfolder and typically a rare case even then
	Loop % source.len()
	{
		; if dest is a subfolder of source
		if ( 	(SubStr(d:=destination[A_Index],0)=="\") 		; dest is a folder
			and (SubStr(s:=source[A_Index],0)=="\")				; source is a folder
			and (StrLen(d) > (slen:=StrLen(s))) 				; dest path is longer than source path
			and (s=SubStr(d,1,slen)) ) 							; dest path is contained in source path
		{
			c := s
			name := FC_(c).name
			
			; remove this entry (replaced by soon to be added entries)
			source[A_Index] := ""
			destination[A_Index] := ""
			
			; keep going until there are no more conflicts
			While % FileExist(c)
			{
				subs := FC("pattern",c "*.*",1,0)
				c .= name
				Loop % subs.len()
				{
					if (subs[A_Index]=c)
						continue
					; move individual items up
					; new additions do not need to be (and aren't) processed in this loop
					source.add(subs[A_Index])
					destination.add(c FC_(subs[A_Index]).name)
				}
				
			}
		}
	}
	
	return ShFO(operation, source, destination, extra_flags)
}
FC_pickFlags(f,op,extra_flags)
{
	flags := f._prefs("flags") . f._prefs(op "_flags")
	
	If ( SubStr(extra_flags,0) == "|" )
		extra_flags := SubStr(extra_flags,1,-1)
	
	Loop Parse, extra_flags, |
		if (SubStr(A_LoopField,1,1)=="-")
			flags := RegExReplace(flags,"\Q" SubStr(A_LoopField,2) "\E\|?")
		else
			flags .= A_LoopField "|"
	
	return flags
}	
;source/dest will be modified, operations must not be order dependant.
ShFO(op, source, dest="", extra_flags="")
{ ;dout_f(A_ThisFunc)
	;dout_o(source,"source into ShFO")
	;dout_o(dest,"dest into ShFO")
	;dout_fm(A_ThisFunc)
	if !IsObject(source)
	{
		ErrorLevel := "source was not a FileContainer"
		;dout(ErrorLevel)
		return FC()
	}
	flags := source.pickFlags(op,extra_flags)
	;dout_v(flags)
	ret := source.makeTemplate(1) ; keep propogating the catch

	to_remove := Object()
	Loop % source.len()
	{
		;dout(A_Index)
		if !(s := source[A_Index])				; blanks in source should be ignored
		{
			;dout_m("source[" A_Index "] will be removed because it is blank")
			to_remove.Insert(A_Index)
		}
		else if !(s_attr := FileExist(s))		; remove nonexistant source files
		{   
			;dout_m("source[" A_Index "] will be removed because it does not exist")
			to_remove.Insert(A_Index)
			ret._catch.add(s[A_Index])
		}
		else if (s=dest[A_Index])				; for pointless operations, mark as successful but don't actually process them
		{   
			;dout_m("source[" A_Index "] will be removed because it is a pointless operation")
			to_remove.Insert(A_Index)
			ret.add(s)
		}
	}
	; remove canceled operations
	source.xAt(to_remove)
	dest.xAt(to_remove)
	
	if !source.len()
	{
		ErrorLevel := "source had nothing in it"
		;dout(ErrorLevel)
		return ret
	}
	dest.xBlanks()
	if ( (op != "FO_DELETE") and (source.len() != dest.len()) )
	{	
		; items caught : abort everything
		ret._catch.absorb(source)
		return ret
	}	
	; do the main part of the requested operation
	result := ShellFileOperation(op, source.toList("|"), dest.manipulate("tricky").toList("|"), "FOF_WANTMAPPINGHANDLE|FOF_MULTIDESTFILES|" flags)
	;MsgBox after shellFileOperation
	; delete operations are easy
	if (op="FO_DELETE")
		ret._catch.absorb(source.iExists())		; items caught: unable to delete
	else
	{	; postprocessing to track what actually happend during the operation
		
		s_ren := ret.makeTemplate()
		d_ren := ret.makeTemplate()
		
		mappings := result.mappings
		
		MakeSuggestion := ret._prefs("rename_method")
		
		Loop % source.len()
		{
			d := dest[A_Index]
			if (r := mappings[d])
			{
				; add the trailing slash back on folder paths
				if IsFolder(d)
					r .= "\"
				else
				{
					;StringReplace, tail, r, %d%
					;if ( tail and RegExMatch(tail, "^\s(\(\d+\)|- Copy)$") )
					;if ( tail and ( tail=" - Copy" or RegExMatch(tail, "^\s\(\d+\)$") ) )
					d=%d%
					StringReplace, was_renamed, r, %d%
					if was_renamed
					{	; prep to fix ShFileOperations' buggy rename system
						s_ren.add(r)
						d_ren.add(%MakeSuggestion%(d))
						continue
					}
					;r = %r% ; remove trailing space that was added before the operation
				}
				ret.add(r)
			}
			else	; items caught: something went wrong during ShellFileOperation	
				ret._catch.add(source[A_Index])
		}
		ret.absorb(s_ren.moveOnto(d_ren))
	}
	return ret
}
; by adding a space to file paths, ShFileOperation will be tricked into adding the item to the
; mappings!  Weird stuff, but it works well.  downside is extra processing and ShFileOperation's
; inability to properly rename items afterwards ("new.txt " gets renamed to "new.txt  (2)"...),
; which requires even more effort just to fix that after the initial operation!
; but at least I finally have a solid solution for tracking file movements!
tricky(item)
{
	if IsFolder(item)
		return item
	return item A_Space
}


;================================================================================================================
;========================================  TODO  ================================================================
;================================================================================================================
/*
	ROADMAP:
		<<<< RELEASE # 5 >>>>
		
		fix examples
		
		make more demos, find more use cases
			- generating test areas
			- PortableApps ini situation
			- G-M cleanup?
		
		<<<< RELEASE # 6 >>>>		
		
		promptForPath needs to be customizable
		
		mappings magic moved into ShellFileOperation
		
		Progress Notification [Progress / SplashImage]
			- functionalize it
			- experiment
			- FC setting for controlling this behavior
	
		renameAsText upgrades!
		
		static methods
		
		<<<< RELEASE # 7 >>>>
		
		new features from unsorted thoughts below
		
		<<<< RELEASE # 8 >>>>
		[[[[Project is Mature]]]]
	
	
	GENERAL UNSORTED THOUGHTS:
		
		run should go to Container.
		
		Lexikos' function for getting files into the clipboard
		http://www.autohotkey.com/forum/topic25416.html
	
		native zip support!!!!
	
		for catch returns, maybe also include reason why each item was lost?
		
		burn to CD using imgburn (mix it up with zip!)
		
		split to folders
			- by size too!

		Held Operations [ MsgBox w\ timeout ? ]
			- delete zip files after unzipping, but let the user make sure first
			
		improve renameAsText
			- option to align at levels for easy editing
			- option to space it out extra for easy editing
			- will be interesting to figure out how to handle operations
				- force explicit?
		
		"take" and "do" variants
		
		internal undo history
			- Explorer's system is a lost cause
			- but this will probably take a lot of work
				- not all operations can be reversed (like even simple overwrites)
		
		merge folders
			- with optional shortening inside!
			- basically enfolder tehn spill enfoldered folders
	
		recursive unzipping (for annoying people who zip zips of zips)
	
		expansion methods need to be investigated
			- need more use cases
			- make them more like fromPattern?
			- should recursion and pattern default to construction settings if available?
		
		name files after folders
		
		7-zip isn't quite integrated well enough
			- unzipping folder name... why is it appended with part01 still?
			- high cpu usage sometimes annoying
			- doesn't die if FC script killed (still?)
			- needs error handling
		
		zip each item to a separate archive
			- makes more sense when each item is a folder, but no need to limit functionality
		
		unzip needs error managment (did it unzip properly? can I delete it now?)
		
		integration with programs like TeraCopy?
		
		would be nice to be able to detect when the parent folder is better named while shortening...
		
		ability to operate on an array of FileContainers.  For when you have
		multiple containers on which you wish to performe the same actions.
			- FC container?
			- static method?
			- ?
		
		for the built-in filter methods, it would be nicer
		to just expose the functions I use for filtering, 
		at least in some cases.  They have uses
		beyond just being used with filter.
		
		run files in something
			- prompt for path?  How would this work?
			- shortcut to using in command line?  could just paste, but faster is better
		
		file contents manipulation should be built into this
			- apply actions to entire container
			- filter by contents
			- actions based on contents
			- spidering in general
		
		param saving system is hardcoded, and I don't like it.  perhaps a dict would be better...
		
		options for which parts are returned and how?
			- like for shorten.  maybe I only want the items that were shortened?

	
	INTERNAL IMPROVEMENT IDEAS:
	
		for built-in filters, get() is relatively inefficient...  makeSplit doesn't modify the original,
		so the copy is a waste.  The problem is with the structuring of the commands.  CAn I pattern it after
		Container's slice ?
	
		improve efficiency in situations where FC is extended (like dir_fixer with construction methods)

		pre-operation functions
			- returns lists or FCs rather than doing the actual operation
			- operation could be done afterwards using the return values
			- would make reuse of functions more efficient
				* shorten calls spill for each depth.  create and delete don't need to be done per depth.

		how much can I reduce the need for Call?
			- for many methods, it seems easy enough to make all params __deFault__ then set them inside.
			
		more can be done for efficiency
			- but the basic structure is inefficient by choice (convenience of use vs efficiency).
			- Even if it takes longer, the user can be doing something else.
				- delays are rarely that long... more a sluggish feel than a "I'll go do something else".
			- vicious cycle:  restructure -> make more efficient -> restructure.  Focus on only functionality for a while +20 sanity
			- actually not that bad, after checking 2010-09-15
	
		delayed task system ?
			- when working internally, set a flag and delay all processing steps
			- doDelayedTasks or something to then go throug everything at once
				+ hopefully more efficient
				+ probably cleaner code in some areas
				- call triggered by read requests
	
		efficiency
			- makeCopy is sometimes unnecessary (and it gets snuck into many different methods)
			- add small delay to user calls by __Call that disables itself (internal=fast)
				- copies can be saved based on call name

				
		profiling is possible
			- need to be able to sort it...
			- lots of stuff could be done in this area!  another library!?
	
		duplicate removal can be optimized probably
			- flag for "is already unique"
			- keep a dict?  meh
		
	MUCH LATER:
	
		file operations should be able to interpret implicit steps.  
				
		Really, what use would be a tree structure?
			- already lost interest in finishing that library.  so many things do for a _good_ tree
			- keeping order is a different problem
			- my level split strategy works well enough for my needs here I believe.
			+ reducer would benefit greatly from this
			+ level based selection methods
				- what would I use them for?
			+

		better duplicate checking?  Does this really matter enough to warrent the effort and added code?
			- ?
			- need a compare func with GetFileInformationByHandle()
				- http://stackoverflow.com/questions/562701/best-way-to-determine-if-two-path-reference-to-same-file-in-c-c
				- http://msdn.microsoft.com/en-us/library/aa364952%28VS.85%29.aspx
				- http://msdn.microsoft.com/en-us/library/aa363788%28v=VS.85%29.aspx
				;if ( PathsAreEquivalent(path,f[A_Index]) and A_Index != x_index)
	
	UNEXPLAINED:
		something breaks if I use …… instead of __deFault__.  I don't know why, either.  It is like the comparison doesn't work,
		or like it can't be passed to a function properly.
		
	NOTES:
	
	bucket sort is generally faster than AHK's built in sort command (as expected), but
	the sort command does a harder sort.  It also makes reducing way faster, as reducing
	after an alphanumeric sort is so much easier.
	
	
	ByRef doesn't work with debug caller passthrough.  Don't try it.
	
	large test area (~2600 items) [already old timings, should be even faster now that arrays are gone]
		xDuplicates() less than a second
		sort in less than 4 seconds (could be faster, but it is already much better than before)
		simplify in about 8 seconds (way better than before.  barring radical changes, only tuning is left)
	
	structureToClipboard test on 18531 items:
	~39s for InStr method
	~35s for SubStr method
	~19s for ._array method
	~17s for no arrays anymore method
		
	array unique functions (a,b,distance)
		- return false to delete b
	array sort functions (a,b,distance)
		- return > 0 to swap a and b

	all too easy to create invalid items... use \\.\<path> syntax to fix manually with command line
	
	for callbacks vs direct code:
		- from simple tests, it seems like direct code can be up to 5 times faster.
		- try to minimize local variables in callback function
		- much of the slowdown seems to be basic function call overhead.
		- returning an expression results in a 2x slowdown (weird).  Just break up the lines
		- best I can get is 2x slower for callback.  Rather annoying.  
		- when using strings, the added complexity drops it all down to 4-5 times slower.  IsFolder filtering takes 4-5 times longer than it would were it hardcoded.
		
		
		
	Attempt to autoclick ShFileOperation dialogs ended in disappointment.  It just wasn't good enough...
		title := "Confirm Folder Replace ahk_class #32770"
		base_text := "This destination already contains a folder named '"
		folder := "1 2 3"
		Loop
		{
			text := base_text folder "'."
			WinWait, %title%, %text%
			ControlSend,,!y
		}

		F12::
			Reload
		return
*/
FC_(parts*)
{
	return FC_Path(parts*)
}
FC_Path(parts*)
{
	static base
	if !base
		base := Object("__Call", "FC_Path_caller")
	
	for i,part in parts
		path .= IsObject(part) ? part.path : part
	
	SplitPath, path, name, dir, ext, nameNoExt, drive
	if ( isFolder := !name )
	{
		StringGetPos, pos, path, \, R2
		name := nameNoExt := SubStr(path,pos+2)
		dir  := SubStr(path,1,pos)
	}
	return Object(	"base",			base
				,	"path",			path
				,	"name",			name
				,	"dir",			dir . "\"
				,	"ext",			ext
				,	"nameNoExt",	nameNoExt
				,	"drive",		drive . "\"
				,	"isFolder",		isFolder
				,	"isFile",		!isFolder)
}
FC_Path_caller(self,method,params*)
{
	if (!self.f)
		self.f := FC("list",self.path)

	if !(func := self.f[method])
		MsgBox % "ERROR - method '" method "' could not be found"

	f := self.f
	ret := %func%(f,params*)
	
	return self
}
/*
belongs in Container, really
FC_join
FC_onArray(array,action,params*)
{
	
}
*/
; 8 total params, room for 1 more left open for extend functions
FC(method="",source="__deFault__", params*)
{
	;dout_f(A_ThisFunc)
	static base, fcmethod
	if !base
	{
		base := Object( 	"_type",					"FC"
						,	"base",						Container()
						;==================================================================================================
						;================= Overrides ======================================================================
						;==================================================================================================
						,	"file",						"FC_file"
						,	"absorb",					"FC_absorb"
						,	"makeCopy",					"FC_makeCopy"
						,	"makeTemplate",				"FC_makeTemplate"
						,	"refresh",					"FC_refresh"
						;==================================================================================================
						;================= Source Parsing =================================================================
						;==================================================================================================
						,	"pattern",					"FC_pattern"
						,	"regex",					"FC_regex"
						,	"explorer",					"FC_explorer"
						;==================================================================================================
						;================= Catch Handling =================================================================
						;==================================================================================================
						,	"enableCatch",				"FC_enableCatch"
						,	"disableCatch",				"FC_disableCatch"
						,	"takeCatch",				"FC_takeCatch"
						;==================================================================================================
						;================= Basic Container ================================================================
						;==================================================================================================		
						,	"simplify",					"FC_simplify"
						,	"reduce",					"FC_reduce"
						,	"expand",					"FC_expand"
						,	"makeExpansion",			"FC_makeExpansion"
						,	"makeContaining",			"FC_makeContaining"
						;==================================================================================================
						;================= Built-in Filters ===============================================================
						;==================================================================================================
						,	"folders",					"FC_folders"
						,	"files",					"FC_files"
						,	"iExists",					"FC_iExists"
						,	"xExists",					"FC_xExists"
						,	"iAttr",					"FC_iAttr"
						,	"xAttr",					"FC_xAttr"
						;==================================================================================================
						;================= Basic File Manipulation ========================================================
						;==================================================================================================
						,	"create",					"FC_create"
						,	"delete",					"FC_delete"
						,	"recycle",					"FC_recycle"
						,	"move",						"FC_move"
						,	"moveInto",					"FC_moveInto"
						,	"moveOnto",					"FC_moveOnto"
						,	"moveContents",				"FC_moveContents"
						,	"copy",						"FC_copy"
						,	"copyInto",					"FC_copyInto"
						,	"copyOnto",					"FC_copyOnto"
						,	"rename",					"FC_rename"
						;==================================================================================================
						;================= Advanced File Manipulation  ====================================================
						;==================================================================================================
						,	"zip",						"FC_zip"
						,	"zipEach",					"FC_zipEach"
						,	"unzip",					"FC_unzip"
						,	"enfolder",					"FC_enfolder"
						,	"enfolderEach",				"FC_enfolderEach"
						,	"spill",					"FC_spill"
						,	"leak",						"FC_leak"
						,	"dump",						"FC_dump"
						,	"flatten",					"FC_flatten"
						,	"shorten",					"FC_shorten"
						,	"shortenAll",				"FC_shortenAll"
						,	"removeEmptyFolders",		"FC_removeEmptyFolders"
						,	"up",						"FC_up"
						,	"renameAsText",				"FC_renameAsText"
						,	"doManip",					"FC_doManip"
						,	"setAttr",					"FC_setAttr"
						;==================================================================================================
						;================= Output =========================================================================
						;==================================================================================================
						,	"makeStats",				"FC_makeStats"
						,	"explore",					"FC_explore"
						,	"exploreAll",				"FC_exploreAll"
						,	"exploreBase",				"FC_exploreBase"
						,	"structureToClipboard",		"FC_structureToClipboard"
						,	"run",						"FC_run"
						;==================================================================================================
						;================= Internal Stuff =================================================================
						;==================================================================================================
						,	"operation",				"FC_operation"
						,	"run7z",					"FC_run7z"
						,	"spiller",					"FC_spiller"
						,	"pickFlags",				"FC_pickFlags"
						,	"promptRename",				"FC_promptRename"
						,	"promptForPath",			"FC_promptForPath"
						;,	"__Call",					"caller"
						,	"__Delete",					"FC_Die")
		
		Prefs_init(base,"FC_DefaultPreferences")
		
		fcmethod := Object(	"",							Object()
						,	"catch",					Object()
						,	"list",						Object()
						,	"listn",					Object()
						,	"array",					Object()
						,	"file",						Object()
						,	"pattern",					Object()
						,	"regex",					Object()
						,	"COM",						Object()
						,	"explorer",					Object())			; not much yet...  have ideas for later
		
	}
	
	;if IsObject(method)
	;	return FC_onArray(method,source,params*)
	
	; rather, make path library into FC methods that act on entire container (thus len=1 --> Path)
	; prep for future quick access to the Path library
	;if !fcmethod[method]
	;	return Path(method, source, p3,p4,p5,p6,p7,p8)
		;return Call("Path",method,source,p3,p4,p5,p6,p7,p8)

	f := Object(		"base",						base
					,	"_catch",					"")
					;,	"_goat",					"")
					
	;f._prefs("method",method,"source",source)
	;dout_o(f,"f after FC constructor")
	;dout_o(f.base,"f base after constructor")
	;if method
	f.saveParams(method,source,params*).refresh()
	;dout_om(f,"f after constructor")
	return f
}
caller(c,func,params*)
{
	;static dict
	;if !dict
	;	dict := Object()
	;last := dict[&c]
	;now := c._method
	;if (last != now)
	;	dout_x()
	;dict[&c] := now
	;dout_f(A_ThisFunc)
	;dout_v(&c,"address of c")
	;dout_v(c._method,"method of c")
	;dout_o(c,"container before")
	;f := c[func]
	;ret := %f%(c,params*)
	;dout_o(c,"container after")
	;dout_less()
	;return ret
}
; actually, I think this doesn't work?  That's because I save the pid of the command window, not the 7zip process...
FC_Die(f)
{
	if (f._goat)
		Process, Close, % f._goat
	return ""
}
