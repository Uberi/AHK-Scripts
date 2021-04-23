
; This code is based on Ahk2Exe's changeicon.cpp

ReplaceAhkIcon(re, IcoFile, ExeFile, iconGroupID, langId=0x409)
{
	global _EI_HighestIconID
	;static iconGroupID := 159

	ids := EnumIcons(ExeFile, iconGroupID)
	if !IsObject(ids)
		return false
	
	f := FileOpen(IcoFile, "r")
	if !IsObject(f)
		return false
	
	VarSetCapacity(igh, 8), f.RawRead(igh, 6)
	if NumGet(igh, 0, "UShort") != 0 || NumGet(igh, 2, "UShort") != 1
		return false
	
	wCount := NumGet(igh, 4, "UShort")
	
	VarSetCapacity(rsrcIconGroup, rsrcIconGroupSize := 6 + wCount*14)
	NumPut(NumGet(igh, "Int64"), rsrcIconGroup, "Int64") ; fast copy
	
	ige := &rsrcIconGroup + 6
	
	; Delete all the images
	Loop, % ids._MaxIndex()
		DllCall("UpdateResource", "ptr", re, "ptr", 3, "ptr", ids[A_Index], "ushort", langId, "ptr", 0, "uint", 0, "uint")
	
	Loop, %wCount%
	{
		thisID := ids[A_Index]
		if !thisID
			thisID := ++ _EI_HighestIconID
		
		f.RawRead(ige+0, 12) ; read all but the offset
		NumPut(thisID, ige+12, "UShort")
		
		imgOffset := f.ReadUInt()
		oldPos := f.Pos
		f.Pos := imgOffset
		
		VarSetCapacity(iconData, iconDataSize := NumGet(ige+8, "UInt"))
		f.RawRead(iconData, iconDataSize)
		f.Pos := oldPos
		
		DllCall("UpdateResource", "ptr", re, "ptr", 3, "ptr", thisID, "ushort", langId, "ptr", &iconData, "uint", iconDataSize, "uint")
		
		ige += 14
	}
	
	DllCall("UpdateResource", "ptr", re, "ptr", 14, isNum(iconGroupID)?"ptr":"str", iconGroupID, "ushort", langId, "ptr", &rsrcIconGroup, "uint", rsrcIconGroupSize, "uint")
	return true
}

EnumIcons(ExeFile, iconGroupID)
{
	; RT_GROUP_ICON = 14
	; RT_ICON = 3
	global _EI_HighestIconID
	static pEnumFunc := RegisterCallback("EnumIcons_Enum")
	
	hModule := DllCall("LoadLibraryEx", "str", ExeFile, "ptr", 0, "ptr", 2, "ptr")
	if !hModule
		return
	
	static gotHighestIdAlready = false
	if(!gotHighestIdAlready){
		_EI_HighestIconID := 0
		if DllCall("EnumResourceNames", "ptr", hModule, "ptr", 3, "ptr", pEnumFunc, "uint", 0) = 0
		{
			DllCall("FreeLibrary", "ptr", hModule)
			return
		}
		gotHighestIdAlready = true
	}

	hRsrc := DllCall("FindResource", "ptr", hModule, isNum(iconGroupID)?"ptr":"str", iconGroupID, "ptr", 14, "ptr")
	hMem := DllCall("LoadResource", "ptr", hModule, "ptr", hRsrc, "ptr")
	pDirHeader := DllCall("LockResource", "ptr", hMem, "ptr")
	
	iconIDs := []
	if(pDirHeader){
		pResDir := pDirHeader + 6
	
		wCount := NumGet(pDirHeader+4, "UShort")
	
		Loop, %wCount%
		{
			pResDirEntry := pResDir + (A_Index-1)*14
			iconIDs[A_Index] := NumGet(pResDirEntry+12, "UShort")
		}
	}
		
	DllCall("FreeLibrary", "ptr", hModule)
	return iconIDs
}

EnumIcons_Enum(hModule, type, name, lParam)
{
	global _EI_HighestIconID
	if (name < 0x10000) && name > _EI_HighestIconID
		_EI_HighestIconID := name
	return 1
}
