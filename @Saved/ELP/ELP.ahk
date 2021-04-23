;Your script must have the following set before these functions will operate
Ptr := A_PtrSize ? "Ptr" : "UInt"

ELP_FileSetTimes(_ModifedTime, _CreationTime, _AccessTime, _FilePattern, _OperateOnFolders = 0, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFSTS"
	
	If (_ModifedTime = "")
		_ModifedTime := A_Now
	Else If (_ModifedTime != 0 And StrLen(_ModifedTime) < 14)
		FormatTime, _ModifedTime, _ModifedTime, yyyyMMddHHmmss
	
	If (_CreationTime = "")
		_CreationTime := A_Now
	Else If (_CreationTime != 0 And StrLen(_CreationTime) < 14)
		FormatTime, _CreationTime, _CreationTime, yyyyMMddHHmmss
	
	If (_AccessTime = "")
		_AccessTime := A_Now
	Else If (_AccessTime != 0 And StrLen(_AccessTime) < 14)
		FormatTime, _AccessTime, _AccessTime, yyyyMMddHHmmss
	
	_AccessTime := _AccessTime = 0 ? 0 : LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_AccessTime))
	, VarSetCapacity(AccessTime, 8, 0)
	, NumPut(_AccessTime, AccessTime, 0, "Int64")
	, _CreationTime := _CreationTime = 0 ? 0 : LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_CreationTime))
	, VarSetCapacity(CreationTime, 8, 0)
	, NumPut(_CreationTime, CreationTime, 0, "Int64")
	, _ModifedTime := _ModifedTime = 0 ? 0 : LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_ModifedTime))
	, VarSetCapacity(ModifiedTime, 8, 0)
	, NumPut(_ModifedTime, ModifiedTime, 0, "Int64")
	, FailedFiles := 0
	, SuccessfulFiles := 0
	
	If (_IsPattern){
		If (!InStr(_FilePattern, "*", False, InStr(_FilePattern, "\", False, 0)))
			_IsPattern := False
	}
	
	If (_FilePattern = "" Or (!_IsPattern And !ELP_FileExists(_FilePattern))){
		ErrorLevel := 1
		Return 1
	}
	
	If (_IsPattern){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FilePattern, "Close", 0, FileInfo, MY_ID)
		
		Loop
		{
			FileName := ELP_LoopFilePattern(_FilePattern, _OperateOnFolders, _Recurse, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			H := ELP_OpenFileHandle(FileName, "Write")
			, E := DllCall("SetFileTime", Ptr, H, Ptr, &CreationTime, Ptr, &AccessTime, Ptr, &ModifiedTime)
			, ELP_CloseFileHandle(H)
			
			If (!E)
				FailedFiles ++
			Else
				SuccessfulFiles ++
		}
	} Else {
		H := ELP_OpenFileHandle(_FilePattern, "Write")
		, E := DllCall("SetFileTime", Ptr, H, Ptr, &CreationTime, Ptr, &AccessTime, Ptr, &ModifiedTime)
		, ELP_CloseFileHandle(H)
		
		If (!E)
			FailedFiles ++
		Else
			SuccessfulFiles ++
	}
	
	ErrorLevel := FailedFiles
	
	Return SuccessfulFiles
}

ELP_FileSetTime(_TimeStamp, _FilePattern, _WhichTime = "M", _OperateOnFolders = 0, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFST"
	
	If (_TimeStamp = "")
		_TimeStamp := A_Now
	Else If (StrLen(_TimeStamp) < 14)
		FormatTime, _TimeStamp, _TimeStamp, yyyyMMddHHmmss
	
	_TimeStamp := LocalFileTimeToFileTime(ELP_SystemTimeToFileTime(_TimeStamp))
	, VarSetCapacity(TimeStamp, 8, 0)
	, NumPut(_TimeStamp, TimeStamp, 0, "Int64")
	, FailedFiles := 0
	, SuccessfulFiles := 0
	
	If (_IsPattern){
		If (!InStr(_FilePattern, "*", False, InStr(_FilePattern, "\", False, 0)))
			_IsPattern := False
	}
	
	If (_FilePattern = "" Or (!_IsPattern And !ELP_FileExists(_FilePattern))){
		ErrorLevel := 1
		Return 1
	}
	
	If (_IsPattern){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FilePattern, "Close", 0, FileInfo, MY_ID)
		
		Loop
		{
			FileName := ELP_LoopFilePattern(_FilePattern, _OperateOnFolders, _Recurse, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			H := ELP_OpenFileHandle(FileName, "Write")
			
			If (_WhichTime = "M" Or _WhichTime = "")
				E := DllCall("SetFileTime", Ptr, H, "UInt", 0, "UInt", 0, Ptr, &TimeStamp)
			Else If (_WhichTime = "A")
				E := DllCall("SetFileTime", Ptr, H, "UInt", 0, Ptr, &TimeStamp, "UInt", 0)
			Else If (_WhichTime = "C")
				E := DllCall("SetFileTime", Ptr, H, Ptr, &TimeStamp, "UInt", 0, "UInt", 0)
			
			ELP_CloseFileHandle(H)
			
			If (!E)
				FailedFiles ++
			Else
				SuccessfulFiles ++
		}
	} Else {
		H := ELP_OpenFileHandle(_FilePattern, "Write")
		
		If (_WhichTime = "M" Or _WhichTime = "")
			E := DllCall("SetFileTime", Ptr, H, "UInt", 0, "UInt", 0, Ptr, &TimeStamp)
		Else If (_WhichTime = "A")
			E := DllCall("SetFileTime", Ptr, H, "UInt", 0, Ptr, &TimeStamp, "UInt", 0)
		Else If (_WhichTime = "C")
			E := DllCall("SetFileTime", Ptr, H, Ptr, &TimeStamp, "UInt", 0, "UInt", 0)
		
		ELP_CloseFileHandle(H)
		
		If (!E)
			FailedFiles ++
		Else
			SuccessfulFiles ++
	}
	
	ErrorLevel := FailedFiles
	
	Return SuccessfulFiles
}

ELP_SystemTimeToFileTime(_SystemTime)
{
	Global Ptr
	
	VarSetCapacity(FSystemTime, 16, 0) ;8*2
	, VarSetCapacity(FFileTime, 8, 0) ;2*4
	
	, Miliseconds := SubStr(_SystemTime, 15, 3)
	, Miliseconds := Miliseconds = "" ? 0 : Miliseconds
	
	, NumPut(SubStr(_SystemTime, 1, 4), FSystemTime, 0, "UShort")
	, NumPut(SubStr(_SystemTime, 5, 2), FSystemTime, 2, "UShort")
	;NumPut(DayOfWeek, FSystemTime, 0, "UShort")
	, NumPut(SubStr(_SystemTime, 7, 2), FSystemTime, 6, "UShort")
	, NumPut(SubStr(_SystemTime, 9, 2), FSystemTime, 8, "UShort")
	, NumPut(SubStr(_SystemTime, 11, 2), FSystemTime, 10, "UShort")
	, NumPut(SubStr(_SystemTime, 13, 2), FSystemTime, 12, "UShort")
	, NumPut(Miliseconds, FSystemTime, 14, "UShort")
	
	, DllCall("SystemTimeToFileTime", Ptr, &FSystemTime, Ptr, &FFileTime)
	
	Return NumGet(FFileTime, 0, "Int64")
}

LocalFileTimeToFileTime(_FileTime)
{
	Global Ptr
	
	VarSetCapacity(FileTime, 64, 0)
	, VarSetCapacity(FileTimeUTC, 64, 0)
	, NumPut(_FileTime, FileTime, 0, "Int64")
	, DllCall("LocalFileTimeToFileTime", Ptr, &FileTime, Ptr, &FileTimeUTC)
	
	Return NumGet(FileTimeUTC, 0, "Int64")
}

ELP_FileRead(_FileName, ByRef _Data = "010011100010111101000001")
{
	Global Ptr
	Static UTF8_BOM1 = 239, UTF8_BOM2 = 187, UTF8_BOM3 = 191
	, UTF16LE_BOM1 = 255, UTF16LE_BOM2 = 254
	, UTF8_CP = 65001, UTF16_CP = 1200
	, SLong_MAX = 2147483647
	
	W_CP := A_FileEncoding
	
	Loop
	{
		If (SubStr(_FileName, 1, 1) = "*"){
			Option := SubStr(_FileName, 1, InStr(_FileName, A_Space))
			, _FileName := SubStr(_FileName, StrLen(Option) + 1)
			
			If (InStr(Option, ":") Or InStr(Option, "\") Or InStr(Option, ".") Or _FileName = ""){
				ErrorLevel := -1
				Return
			}
			
			If (SubStr(Option, 1, 2) = "*m"){
				Bytes_ToRead := SubStr(Option, 3)
				, Bytes_ToRead *= 1024 * 1024
			} Else If (SubStr(Option, 1, 2) = "*t")
				Replace_Newlines := 1
			Else If (SubStr(Option, 1, 2) = "*P")
				W_CP := SubStr(Option, 3)
			Else If (SubStr(Option, 1, 2) = "*c"){
				ErrorLevel := 1
				Return
			} Else If (SubStr(Option, 1, 2) = "**")
				Binary_Mode := True
		} Else
			Break
	}
	
	If (W_CP = "" Or W_CP = 0)
		W_CP := DllCall("GetACP")
	Else {
		If W_CP Is Not Number
			W_CP := DllCall("GetACP")
	}
	
	If (!ELP_FileExists(_FileName, 0, 0, 0)){
		ErrorLevel := 1
		Return
	}
	
	If (_Data = "010011100010111101000001"){
		ReturnByRef := True
		
		If (Binary_Mode){
			ErrorLevel := 1
			Return
		}
	}
	
	Handle := ELP_OpenFileHandle(_FileName, "Read", FileSize)
	If (Handle = -1){
		ErrorLevel := 2
		Return
	}
	
	Bytes_ToRead := Bytes_ToRead = "" ? FileSize : Bytes_ToRead
	
	If (!FileSize){
		ErrorLevel := 0
		ELP_CloseFileHandle(Handle)
		Return
	}
	
	If (A_PtrSize != 8 And Bytes_ToRead > SLong_MAX){
		ErrorLevel := 1
		Return
	}
	
	If (Binary_Mode){
		VarSetCapacity(_Data, Bytes_ToRead, 0)
		, Bytes_Read := ELP_ReadData(Handle, &_Data, Bytes_ToRead)
		
		Return Bytes_Read
	} Else {
		VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
		, Bytes_Read := ELP_ReadData(Handle, &Data_Buffer, Bytes_ToRead)
		, ELP_CloseFileHandle(Handle)
	}
	
	If (Bytes_Read >= 3 And NumGet(&Data_Buffer, 0, "UChar") = UTF8_BOM1 And NumGet(&Data_Buffer, 1, "UChar") = UTF8_BOM2 And NumGet(&Data_Buffer, 2, "UChar") = UTF8_BOM3){
		Data_Start := &Data_Buffer + 3
		, Data_Length := Bytes_Read - 3
		
		If (A_IsUnicode){
			;Convert UTF8 to UTF16 to string
			Data_Length := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0)
			, VarSetCapacity(_Data, Data_Length * 2, 0)
			, DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length * 2)
			
			, VarSetCapacity(_Data, -1)
			, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
			, VarSetCapacity(Data_Buffer, 0)
		} Else {
			;Convert UTF8 to ANSI to string
			Data_Length := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0)
			, VarSetCapacity(_Data, Data_Length * 2, 0)
			, DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length * 2)
			
			, Temp_Data_Length := Data_Length
			, Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Temp_Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(Data_Buffer, Data_Length, 0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Temp_Data_Length, Ptr, &Data_Buffer, "Int", Data_Length, Ptr, 0, Ptr, 0)
			
			, VarSetCapacity(_Data, 0)
			, VarSetCapacity(_Data, Data_Length, 0)
			
			, DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Data_Length)
			, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
			, VarSetCapacity(Data_Buffer, 0)
			, VarSetCapacity(_Data, -1)
		}
	} Else If ((Has_BOM := (Bytes_Read >= 2 And NumGet(&Data_Buffer, 0, "UChar") = UTF16LE_BOM1 And NumGet(&Data_Buffer, 1, "UChar") = UTF16LE_BOM2)) Or W_CP = UTF16_CP){
		Data_Start := &Data_Buffer
		, Data_Length := Bytes_Read
		
		If (Has_BOM)
			Data_Start += 2, Data_Length -= 2
		
		If (A_IsUnicode){
			;Moves the UTF16 buffer data into a string
			VarSetCapacity(_Data, Data_Length, 0)
			, DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, Data_Start, "UInt", Data_Length)
			
			, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
			, VarSetCapacity(Data_Buffer, 0)
			, VarSetCapacity(_Data, -1)
		} Else {
			;Convert UTF16 to ANSI to string
			Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(_Data, Data_Length, 0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, Data_Start, "Int", Data_Length, Ptr, &_Data, "Int", Data_Length, Ptr, 0, Ptr, 0)
			
			, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
			, VarSetCapacity(Data_Buffer, 0)
			, VarSetCapacity(_Data, -1)
		}
	} Else {
		If (A_IsUnicode){
			;Convert from other codepage to UTF16 to string
			Data_Length := DllCall("MultiByteToWideChar", "UInt", W_CP,"UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, 0, "Int", 0)
			, VarSetCapacity(_Data, Data_Length * 2, 0)
			, DllCall("MultiByteToWideChar", "UInt", W_CP, "UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, &_Data, "Int", Data_Length * 2)
			
			, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
			, VarSetCapacity(Data_Buffer, 0)
			, VarSetCapacity(_Data, -1)
		} Else {
			;Moves the ANSI data into the string
			If (W_CP = DllCall("GetACP")){
				VarSetCapacity(_Data, Bytes_Read, 0)
				, DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Bytes_Read)
				
				, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
				, VarSetCapacity(Data_Buffer, 0)
				, VarSetCapacity(_Data, -1)
			} Else {
				;Convert from other codepage to UTF16 to ANSI to string
				Data_Length := DllCall("MultiByteToWideChar", "UInt", W_CP,"UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, 0, "Int", 0)
				, VarSetCapacity(_Data, Data_Length * 2, 0)
				, DllCall("MultiByteToWideChar", "UInt", W_CP, "UInt", 0, Ptr, &Data_Buffer, "Int", Bytes_Read, Ptr, &_Data, "Int", Data_Length)
				, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
				, VarSetCapacity(Data_Buffer, 0)
				
				, W_CP := DllCAll("GetACP")
				
				, Data_Length := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Data_Length, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
				, VarSetCapacity(Data_Buffer, Data_Length, 0)
				, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_Data, "Int", Data_Length, Ptr, &Data_Buffer, "Int", Data_Length, Ptr, 0, Ptr, 0)
				, VarSetCapacity(_Data, 0)
				, VarSetCapacity(_Data, Data_Length, 0)
				, DllCall("RtlMoveMemory", Ptr, &_Data, Ptr, &Data_Buffer, "UInt", Data_Length)
				, VarSetCapacity(Data_Buffer, Bytes_ToRead, 0)
				, VarSetCapacity(Data_Buffer, 0)
				, VarSetCapacity(_Data, -1)
			}
		}
	}
	
	If (Replace_Newlines)
		StringReplace, _Data, _Data, `r`n, `n, A
	
	If (ReturnByRef)
		Return _Data
}

ELP_FileMoveDirectory(_FromDirectory, _ToDirectory, _Flags = 0)
{
	;_Flags
	;R | Rename
	;0 | Fail if exists
	;1 | Overwrite
	;2 | Overwrite
	;3 | Overwrite and always remove source files
	
	Global Ptr
	Static MY_ID := "ELPCF", ERROR_ALREADY_EXISTS := 183, Am_Root
	
	If (SubStr(_FromDirectory, 0, 1) != "\")
		_FromDirectory .= "\"
	
	If (SubStr(_ToDirectory, 0, 1) != "\")
		_ToDirectory .= "\"
	
	Failed_Moves := 0
	
	If (_Flags = "R"){
		ELP_ConvertPath(_FromDirectory)
		, ELP_ConvertPath(_ToDirectory)
		, Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
	} Else If (_Flags = 1 Or _Flags = 2){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromDirectory . "*.*", "Close", 0, FileInfo, MY_ID)
		, Failed_Moves += ELP_FileMove(_FromDirectory . "*.*", _ToDirectory . "*.*", 1, 1)
		, Source_Length := StrLen(_FromDirectory) + 1
		
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 2, 0, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
			Temp_ToDirectory := _ToDirectory . SubStr(FromFile, Source_Length)
			, Failed_Moves += ELP_FileMoveDirectory(FromFile, Temp_ToDirectory, _Flags)
		}
		
		Failed_Moves += ELP_FileRemoveDirectory(_FromDirectory)
	} Else If (_Flags = 0 Or _Flags = 3){
		If (ELP_FileExists(_ToDirectory, 1, 0, 0))
			Failed_Moves := 1
		Else {
			From_Device := ELP_GetPathRoot(_FromDirectory)
			, To_Device := ELP_GetPathRoot(_ToDirectory)
			
			If (From_Device = To_Device){
				ELP_ConvertPath(_FromDirectory)
				, ELP_ConvertPath(_ToDirectory)
				, Failed_Moves := DllCall("MoveFileW", Ptr, &_FromDirectory, Ptr, &_ToDirectory) = 0 ? 1 : 0
			} Else {
				Failed_Moves := ELP_FileCopyDirectory(_FromDirectory, _ToDirectory)
				
				If (!Failed_Moves Or _Flags = 3)
					ELP_FileRemoveDirectory(_FromDirectory, 1)
			}
		}
	}
	
	Return ErrorLevel := Failed_Moves
}

ELP_FileMove(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFM", ERROR_ALREADY_EXISTS := 183
	
	If (_IsPattern){
		If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile), "D"))
			Return ErrorLevel := 1
		
		P := InStr(_FromFile, "\", False, 0)
		
		If (InStr(_FromFile, "*", False, P))
			Source_IsPattern := True
		Else
			Source_IsPattern := False
		
		P := InStr(_ToFile, "\", False, 0)
		
		If (InStr(_ToFile, "*", False, P))
			Destination_IsPattern := True
		Else
			Destination_IsPattern := False
		
		If (!Destination_IsPattern){
			If (SubStr(_ToFile, 0, 1) = "\")
				Destination_IsPattern := True
			Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
				_ToFile .= "\", Destination_IsPattern := True
			
			If (!Source_IsPattern And Destination_IsPattern){
				_ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
				, Destination_IsPattern := False
			}
		}
		
		If (!Source_IsPattern And !Destination_IsPattern)
			_IsPattern := False
	}
	
	Failed_Moves := 0
	
	If (_CreateDestination){
		Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
		
		If (!ELP_FileExists(Directory, 1, 0, 0))
			ELP_FileCreateDirectory(Directory)
	}
	
	From_Device := ELP_GetPathRoot(_FromFile)
	, To_Device := ELP_GetPathRoot(_ToFile)
	
	If (From_Device != To_Device)
		Method_Copy := True
	
	If (!_IsPattern){
		If (Method_Copy){
			Failed_Moves := ELP_FileCopy(_FromFile, _ToFile, _OverWrite, 0, 0)
			
			If (!Failed_Moves)
				ELP_FileDelete(_FromFile, 1, 0)
		} Else {
			__FromFile := _FromFile
			, __ToFile := _ToFile
			, ELP_ConvertPath(__FromFile)
			, ELP_ConvertPath(__ToFile)
			, Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
			
			If (Failed_Moves And _OverWrite And A_LastError = ERROR_ALREADY_EXISTS){
				If (!ELP_FileDelete(_ToFile, 1, 0))
					Failed_Moves := DllCall("MoveFileW", Ptr, &__FromFile, Ptr, &__ToFile) = 0 ? 1 : 0
			}
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
		
		Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
		If (Destination_Pattern != ""){
			_ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
			
			StringSplit,FN_,Destination_Pattern,.
			
			Dest_Name := FN_1
			, Dest_Extension := FN_2
		}
		
		;MsgBox % _ToFile "`n" Dest_Name "`n" Dest_Extension
		
		Loop
		{
			MoveFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
			
			If (MoveFromFile = "")
				Break
			
			;Populate the Copy-To variable with the Copy-From file name
			Source_Name := SubStr(MoveFromFile, InStr(MoveFromFile, "\", False, 0) + 1)
			
			If (Destination_Pattern){
				MoveTo_Name := Dest_Name
				, MoveTo_Extension := Dest_Extension
				, P := InStr(Source_Name, ".", False, 0)
				
				If (P){
					SFN_1 := SubStr(Source_Name, 1, P - 1)
					, SFN_2 := SubStr(Source_Name, P + 1)
				} Else {
					SFN_1 := Source_Name
					, SFN_2 := ""
				}
				
				If (InStr(MoveTo_Name,"*")){
					StringReplace, MoveTo_Name, MoveTo_Name, *, %SFN_1%
					StringReplace, MoveTo_Name, MoveTo_Name, *,, A
				}
				
				If (InStr(MoveTo_Extension,"*")){
					StringReplace, MoveTo_Extension, MoveTo_Extension, *, %SFN_2%
					StringReplace, MoveTo_Extension, MoveTo_Extension, *,, A
				}
				
				If (MoveTo_Extension)
					MoveToFile := _ToFile . MoveTo_Name . "." . MoveTo_Extension
				Else
					MoveToFile := _ToFile . MoveTo_Name
			} Else
				MoveToFile := _ToFile . Source_Name
			
			;MsgBox % "Source file: " MoveFromFile "`nDestination file: " MoveToFile
			
			If (Method_Copy){
				E := ELP_FileCopy(MoveFromFile, MoveToFile, _OverWrite, 0, 0)
			
				If (!E)
					ELP_FileDelete(MoveFromFile, 1, 0)
				Else
					Failed_Moves ++
			} Else {
				ELP_ConvertPath(MoveFromFile)
				, ELP_ConvertPath(MoveToFile)
				, E := DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
				;MsgBox % E "`n`n" A_LastError
				If (E){
					If (_OverWrite And A_LastError = ERROR_ALREADY_EXISTS And !ELP_FileDelete(_ToFile, 1, 0))
						Failed_Moves += DllCall("MoveFileW", Ptr, &MoveFromFile, Ptr, &MoveToFile) = 0 ? 1 : 0
					Else
						Failed_Moves ++
				}
			}
		}
	}
	
	Return Failed_Moves
}

ELP_FileCopyDirectory(_FromDirectory, _ToDirectory, _Overwrite = 0)
{
	Global Ptr
	Static MY_ID := "ELPFCD"
	
	If (SubStr(_FromDirectory, 0, 1) != "\")
		_FromDirectory .= "\"
	
	If (SubStr(_ToDirectory, 0, 1) != "\")
		_ToDirectory .= "\"
	
	If (_FromDirectory = _ToDirectory)
		Return ErrorLevel := 1
	
	If (SubStr(_ToDirectory, 1, StrLen(_FromDirectory)) = _FromDirectory)
		Method := 2
	Else
		Method := 1
	
	Destination_Exists := ELP_FileExists(_ToDirectory, 1, 0, 0)
	
	If (Destination_Exists And !_Overwrite)
		Return ErrorLevel := 1
	
	Errored_Directories := 0
	, Errored_Files := 0
	
	, From_BaseLength := StrLen(_FromDirectory)
	, To_BaseLength := StrLen(_ToDirectory)
	
;	MsgBox % _ToDirectory "`n" _FromDirectory "`n" SubStr(_ToDirectory,1,StrLen(_FromDirectory))
	
;	MsgBox % Method "`n" From_BaseLength "`n" _ToDirectory "`n" _FromDirectory
	
	If (Method = 1){
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
			CopyFile := SubStr(FromFile, From_BaseLength + 1)
			
			If (ELP_IsDirectoryFromFI(FileInfo)){
				If (ELP_FileCreateDirectory(_ToDirectory . CopyFile))
					Errored_Directories ++
			} Else {
				If (ELP_FileCopy(_FromDirectory . CopyFile, _ToDirectory . CopyFile, _Overwrite, 0, 0))
					Errored_Files ++
			}
		}
	} Else If (Method = 2){
		Loop
		{
			FromFile := ELP_LoopFilePattern(_FromDirectory . "*.*", 1, 1, FileInfo, MY_ID)
			
			If (FromFile = "")
				Break
			
;			MsgBox % FromFile
			
			If (SubStr(FromFile,1,To_BaseLength) = _ToDirectory)
				Continue
			
			FromFile := SubStr(FromFile, From_BaseLength + 1)
			
;			MsgBox % FromFile
			
			If (ELP_IsDirectoryFromFI(FileInfo))
				DirectoryContents .= DirectoryContents ? "|" . FromFile . "\" : FromFile . "\"
			Else
				DirectoryContents .= DirectoryContents ? "|" . FromFile : FromFile
		}
		
		If (!Destination_Exists And ELP_FileCreateDirectory(_ToDirectory))
			Return ErrorLevel := 1
		
		Loop,Parse,DirectoryContents,|
		{
			If (SubStr(A_LoopField, 0, 1) = "\"){
				If (ELP_FileCreateDirectory(_ToDirectory . A_LoopField))
					Errored_Directories ++
			} Else {
				If (ELP_FileCopy(_FromDirectory . A_LoopField, _ToDirectory . A_LoopField, _Overwrite, 0, 0))
					Errored_Files ++
			}
		}
		
		VarSetCapacity(DirectoryContents, 0)
	}
	
	If (Errored_Directories Or Errored_Files)
		Return Errored_Directories . "|" . Errored_Files
}

ELP_FileCopy(_FromFile, _ToFile, _OverWrite = 0, _CreateDestination = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFC"
	
	If (_IsPattern){
		If (SubStr(_FromFile, 0, 1) = "\" Or InStr(ELP_FileGetAttributes(_FromFile), "D"))
			Return ErrorLevel := 1
		
		P := InStr(_FromFile, "\", False, 0)
		
		If (InStr(_FromFile, "*", False, P))
			Source_IsPattern := True
		Else
			Source_IsPattern := False
		
		P := InStr(_ToFile, "\", False, 0)
		
		If (InStr(_ToFile, "*", False, P))
			Destination_IsPattern := True
		Else
			Destination_IsPattern := False
		
		If (!Destination_IsPattern){
			If (SubStr(_ToFile, 0, 1) = "\")
				Destination_IsPattern := True
			Else If (InStr(ELP_FileGetAttributes(_ToFile), "D"))
				_ToFile .= "\", Destination_IsPattern := True
			
			If (!Source_IsPattern And Destination_IsPattern){
				_ToFile .= SubStr(_FromFile, InStr(_FromFile, "\", False, 0) + 1)
				, Destination_IsPattern := False
			}
		}
		
		If (!Source_IsPattern And !Destination_IsPattern)
			_IsPattern := False
	}
	
	Failed_Copies := 0
	
	If (_CreateDestination){
		Directory := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
		
		If (!ELP_FileExists(Directory, 1, 0, 0))
			ELP_FileCreateDirectory(Directory)
	}
	
	If (!_IsPattern){
		__FromFile := _FromFile
		, __ToFile := _ToFile
		, ELP_ConvertPath(__FromFile)
		, ELP_ConvertPath(__ToFile)
		, Failed_Copies := DllCall("CopyFileW", Ptr, &__FromFile, Ptr, &__ToFile, "Int", !_OverWrite) = 0 ? 1 : 0
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FromFile, "Close", 0, FileInfo, MY_ID)
		
		Destination_Pattern := SubStr(_ToFile, InStr(_ToFile, "\", False, 0) + 1)
		If (Destination_Pattern != ""){
			_ToFile := SubStr(_ToFile, 1, InStr(_ToFile, "\", False, 0))
			
			StringSplit, FN_, Destination_Pattern, .
			
			Dest_Name := FN_1
			, Dest_Extension := FN_2
		}
		
		;MsgBox % _ToFile "`n" Dest_Name "`n" Dest_Extension
		
		Loop
		{
			CopyFromFile := ELP_LoopFilePattern(_FromFile, 0, 0, FileInfo, MY_ID)
			
			If (CopyFromFile = "")
				Break
			
			;Populate the Copy-To variable with the Copy-From file name
			Source_Name := SubStr(CopyFromFile, InStr(CopyFromFile, "\", False, 0) + 1)
			
			If (Destination_Pattern){
				CopyTo_Name := Dest_Name
				, CopyTo_Extension := Dest_Extension
				, P := InStr(Source_Name, ".", False, 0)
				
				If (P){
					SFN_1 := SubStr(Source_Name, 1, P - 1)
					, SFN_2 := SubStr(Source_Name, P + 1)
				} Else {
					SFN_1 := Source_Name
					, SFN_2 := ""
				}
				
				If (InStr(CopyTo_Name,"*")){
					StringReplace, CopyTo_Name, CopyTo_Name, *, %SFN_1%
					StringReplace, CopyTo_Name, CopyTo_Name, *,, A
				}
				
				If (InStr(CopyTo_Extension,"*")){
					StringReplace, CopyTo_Extension, CopyTo_Extension, *, %SFN_2%
					StringReplace, CopyTo_Extension, CopyTo_Extension, *,, A
				}
				
				If (CopyTo_Extension)
					CopyToFile := _ToFile . CopyTo_Name . "." . CopyTo_Extension
				Else
					CopyToFile := _ToFile . CopyTo_Name
			} Else
				CopyToFile := _ToFile . Source_Name
			
			;MsgBox % "Source file: " CopyFromFile "`nDestination file: " CopyToFile
			ELP_ConvertPath(CopyFromFile)
			, ELP_ConvertPath(CopyToFile)
			, Failed_Copies += DllCall("CopyFileW", Ptr, &CopyFromFile, Ptr, &CopyToFile, "Int", !_OverWrite) = 0 ? 1 : 0
		}
	}
	
	Return Failed_Copies
}

ELP_FileGetVersion(_FileName, _Which = 1)
{
	Global Ptr
	
	ELP_ConvertPath(_FileName)
	, Size := DllCall("Version.dll\GetFileVersionInfoSizeW", Ptr, &_FileName, Ptr, 0)
	
	If (!Size){
		ErrorLevel := 1
		Return
	}
	
	VarSetCapacity(FileVersion,Size,0)
	, DllCall("Version.dll\GetFileVersionInfoW", Ptr, &_FileName, "Int", 0, "Int", Size, Ptr, &FileVersion)
	, VarSetCapacity(SL, 2, 0)
	, NumPut(Asc("\"), SL, 0, "UShort")
	
	If (!DllCall("Version.dll\VerQueryValueW", Ptr, &FileVersion, Ptr, &SL, "Int64*", pFFI, "UInt*", uSize)){
		VarSetCapacity(FileVersion, Size, 0)
		, VarSetCapacity(FileVersion, 0)
		, ErrorLevel := 1
		
		Return
	}
	
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms646997(v=vs.85).aspx
	
	If (_Which = 1){
		FVMS := NumGet(pFFI+0, 8, "Int")
		, FVLS := NumGet(pFFI+0, 12, "Int")
		, Version := (FVMS >> 16) . "." . (FVMS & 0xFFFF) . "." . (FVLS >> 16) . "." . (FVLS & 0xFFFF)
	} Else If (_Which = 2){
		PVMS := NumGet(pFFI+0, 8, "Int")
		, PVLS := NumGet(pFFI+0, 12, "Int")
		, Version := (PVMS >> 16) . "." . (PVMS & 0xFFFF) . "." . (PVLS >> 16) . "." . (PVLS & 0xFFFF)
	}
	
	;Cleanup
	VarSetCapacity(FileVersion, Size, 0)
	, VarSetCapacity(FileVersion, 0)
	
	Return Version
}

ELP_FileRemoveDirectory(_Directory, _Recurse = 0)
{
	Global Ptr
	Static MY_ID := "ELPFRD"
	
	If (SubStr(_Directory,0) != "\")
		_Directory .= "\"
	
	__Directory := _Directory
	, ELP_ConvertPath(__Directory)
	, E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
	
	If (!_Recurse And !E){
		;If (A_LastError
		Return ErrorLevel := 1
	} Else If (_Recurse And !E){
		E := ELP_FileDelete(_Directory . "*.*")
		
		If (E){
			ErrorLevel := 1
			
			Return E
		}
		
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
		
		Loop
		{
			Folder := ELP_LoopFilePattern(_Directory . "*.*", 2, 0, FileInfo, MY_ID)
			
			If (Folder = "")
				Break
			
			E := ELP_FileRemoveDirectory(Folder, _Recurse)
			
			If (E){
				ELP_LoopFilePattern(_Directory . "*.*", "Close", 0, FileInfo, MY_ID)
				, ErrorLevel := 1
				
				Return E
			}
		}
		
		__Directory := _Directory
		, ELP_ConvertPath(__Directory)
		, E := DllCall("RemoveDirectoryW", Ptr, &__Directory)
		
		If (!E)
			Return ErrorLevel := 1
	}
}

ELP_FileExists(_FileName, _IncludeFolders = 1, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFE"
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	If (_IncludeFolders != 1 Or _Recurse)
		_IsPattern := True
	Else If (!_IsPattern){
		__FileName := _FileName
		ELP_ConvertPath(__FileName)
		, E := DllCall("GetFileAttributesW", Ptr, &__FileName)
		
		If (E = -1) ;Try the find-file method
			_IsPattern := True, E := False
	}
	
	If (_IsPattern){
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		, FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
		
		If (FileName != ""){
			ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
			, E := True
		}
	}
	
	Return E
}

ELP_FileDelete(_FileName, _ForceDelete = 1, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFD"
	
	FailedDeletes := 0
	, __FileName := _FileName
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	If (!_IsPattern){
		ELP_ConvertPath(__FileName)
		, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
		
		If (A_LastError != 2){
			If (E = 5 And _ForceDelete){
				If (ELP_FileSetAttributes("-R", _FileName, 0, 0, _IsPattern))
					FailedDeletes ++
				Else If (!DllCall("DeleteFileW", Ptr, &__FileName))
					FailedDeletes ++
			} Else If (E)
				FailedDeletes ++
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		Loop
		{
			FileName := ELP_LoopFilePattern(_FileName, 0, 0, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			__FileName := FileName
			, ELP_ConvertPath(__FileName)
			, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
			
			If (A_LastError != 2){
				If (E = 5 And _ForceDelete){
					Original_Attributes := ELP_FileGetAttributesFromFI(FileInfo, 1)
					
					If (Original_Attributes){
						New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, "-R")
						
						If (New_Attributes != Original_attributes){
							ELP_FileSetRAWAttributes(FileName, New_Attributes)
							, E := DllCall("DeleteFileW", Ptr, &__FileName) = 0 ? A_LastError : 0
						}
					}
				}
				
				If (E)
					FailedDeletes ++
			}
		}
	}
	
	Return FailedDeletes
}

ELP_FileSetAttributes(_Attributes, _FileName, _IncludeFolders = 0, _Recurse = 0, _IsPattern = 1)
{
	Global Ptr
	Static MY_ID := "ELPFSA"
	
	If (_IsPattern){
		P := InStr(_FileName, "\", False, 0)
		
		If (!InStr(_FileName, "*", False, P) And !InStr(_FileName, "?", False, P))
			_IsPattern := False
	}
	
	FailedAttributeChanges := 0
	
	If (!_IsPattern){
		Original_Attributes := ELP_FileGetAttributes(_FileName, 1)
		
		If (Original_Attributes = -1)
			FailedAttributeChanges ++
		Else {		
			New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
			
			If (New_Attributes != Original_Attributes){
				ELP_FileSetRAWAttributes(_FileName, New_Attributes)
				
				If (ErrorLevel)
					FailedAttributeChanges ++
			}
		}
	} Else {
		;Just incase this search pattern was done before - rare but it might happen
		ELP_LoopFilePattern(_FileName, "Close", 0, FileInfo, MY_ID)
		Loop
		{
			FileName := ELP_LoopFilePattern(_FileName, _IncludeFolders, _Recurse, FileInfo, MY_ID)
			
			If (FileName = "")
				Break
			
			Original_Attributes := ELP_FileGetAttributes(FileName, 1)
			
			If (Original_Attributes = -1)
				FailedAttributeChanges ++
			Else {		
				New_Attributes := ELP_ChangeRawAttributes(Original_Attributes, _Attributes)
				
				If (New_Attributes != Original_Attributes){
					ELP_FileSetRAWAttributes(_FileName, New_Attributes)
					
					If (ErrorLevel)
						FailedAttributeChanges ++
				}
			}
		}
	}
	
	Return FailedAttributeChanges
}

ELP_ChangeRawAttributes(New_Attributes, _NewAttributes)
{
	Static FILE_ATTRIBUTE_ARCHIVE := 32
	, FILE_ATTRIBUTE_HIDDEN := 2
	, FILE_ATTRIBUTE_NORMAL := 128
	, FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
	, FILE_ATTRIBUTE_OFFLINE := 4096
	, FILE_ATTRIBUTE_READONLY := 1
	, FILE_ATTRIBUTE_SYSTEM := 4
	, FILE_ATTRIBUTE_TEMPORARY := 256
	, Allowed_Attributes := "AHN2ORST"
	
	Mode := -1
	
	Loop,Parse,_NewAttributes
	{
		If (A_LoopField = "-")
			Mode := -1
		Else If (A_LoopField = "+")
			Mode := 1
		Else If (A_LoopField = "^")
			Mode := 0
		Else If (InStr(Allowed_Attributes, A_LoopField)){
			If (A_LoopField = "R")
				Temp_Attribute := FILE_ATTRIBUTE_READONLY
			Else If (A_LoopField = "A")
				Temp_Attribute := FILE_ATTRIBUTE_ARCHIVE
			Else If (A_LoopField = "H")
				Temp_Attribute := FILE_ATTRIBUTE_HIDDEN
			Else If (A_LoopField = "N")
				Temp_Attribute := FILE_ATTRIBUTE_NORMAL
			Else If (A_LoopField = 2)
				Temp_Attribute := FILE_ATTRIBUTE_NOT_CONTENT_INDEXED
			Else If (A_LoopField = "O")
				Temp_Attribute := FILE_ATTRIBUTE_OFFLINE
			Else If (A_LoopField = "S")
				Temp_Attribute := FILE_ATTRIBUTE_SYSTEM
			Else If (A_LoopField = "T")
				Temp_Attribute := FILE_ATTRIBUTE_TEMPORARY
			
			If (Mode < 0)
				New_Attributes := New_Attributes & ~Temp_Attribute
			Else If (Mode > 0)
				New_Attributes := New_Attributes | Temp_Attribute
			Else
				New_Attributes := New_Attributes ^ Temp_Attribute
		}
	}
	
	Return New_Attributes
}

ELP_FileSetRAWAttributes(_FileName, _Attributes)
{
	Global Ptr
	
	If _Attributes Is Not Number
	{
		ErrorLevel := -1
		Return
	}
	
	ELP_ConvertPath(_FileName)
	, ErrorLevel := DllCall("SetFileAttributesW", Ptr, &_FileName, "Int", _Attributes) = 0 ? 1 : 0
}

ELP_ConvertRAWAttributes(_RawAttributes)
{
	Static FILE_ATTRIBUTE_ARCHIVE := 32
	, FILE_ATTRIBUTE_COMPRESSED := 2048
	, FILE_ATTRIBUTE_DEVICE := 64
	, FILE_ATTRIBUTE_DIRECTORY := 16
	, FILE_ATTRIBUTE_ENCRYPTED := 16384
	, FILE_ATTRIBUTE_HIDDEN := 2
	, FILE_ATTRIBUTE_NORMAL := 128
	, FILE_ATTRIBUTE_NOT_CONTENT_INDEXED := 8192
	, FILE_ATTRIBUTE_OFFLINE := 4096
	, FILE_ATTRIBUTE_READONLY := 1
	, FILE_ATTRIBUTE_REPARSE_POINT := 1024
	, FILE_ATTRIBUTE_SPARSE_FILE := 512
	, FILE_ATTRIBUTE_SYSTEM := 4
	, FILE_ATTRIBUTE_TEMPORARY := 256
	, FILE_ATTRIBUTE_VIRTUAL := 65536
	
	Attributes .= _RawAttributes & FILE_ATTRIBUTE_ARCHIVE ? "A" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_COMPRESSED ? "C" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_DEVICE ? "1" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_DIRECTORY ? "D" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_ENCRYPTED ? "E" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_HIDDEN ? "H" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_NORMAL ? "N" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_NOT_CONTENT_INDEXED ? "2" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_OFFLINE ? "O" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_READONLY ? "R" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_REPARSE_POINT ? "3" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_SPARSE_FILE ? "4" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_SYSTEM ? "S" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_TEMPORARY ? "T" : ""
	, Attributes .= _RawAttributes & FILE_ATTRIBUTE_VIRTUAL ? "V" : ""
	
	Return Attributes
}

ELP_FileGetAttributes(_FileName, _Raw = 0)
{
	Global Ptr
	
	ELP_ConvertPath(_FileName)
	, RAW_Attributes := DllCall("GetFileAttributesW", Ptr, &_FileName)
	
	If (RAW_Attributes = -1)
		Return -1
	
	If (_Raw)
		Return RAW_Attributes
	Else 
		Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetSize(_FileName, _Units = "B", _Floor = 0)
{
	Static MY_ID := "ELPFGS"
	
	If (!ELP_FileExists(_FileName))
		Return 0
	
	Handle := ELP_OpenFileHandle(_FileName, "Read", FileSize)
	
	If (Handle = -1){
		ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID) ;Just incase this search pattern was done before - rare but it might happen
		If (ELP_LoopFilePattern(_FileName, 1, 0, FileInfo) = "")
			FileSize := 0
		Else {
			FileSize := ELP_GetFileSizeFromFI(FileInfo)
			, ELP_LoopFilePattern(_FileName, "Close", 1, FileInfo, MY_ID)
		}
	} Else
		ELP_CloseFileHandle(Handle)
	
	If (_Units = "K")
		FileSize := FileSize / 1024
	Else If (_Units = "M")
		FileSize := FileSize / 1024 / 1024
	Else If (_Units = "G")
		FileSize := FileSize / 1024 / 1024 / 1024
	
	If (_Floor)
		FileSize := Floor(FileSize)
	
	Return FileSize
}

ELP_GetFileSizeFromFI(ByRef _FileInfo, _Units = "B", _Floor = 0)
{
	Static FileSizeOffset := 28, MAXDWORD := 4294967295
	
	HighOrder := NumGet(_FileInfo, FileSizeOffset, "Int")
	, LowOrder := NumGet(_FileInfo, FileSizeOffset + 4, "Int")
	
	FileSize := (HighOrder * (MAXDWORD+1)) + LowOrder
	
	If (_Units = "K")
		FileSize := FileSize / 1024
	Else If (_Units = "M")
		FileSize := FileSize / 1024 / 1024
	Else If (_Units = "G")
		FileSize := FileSize / 1024 / 1024 / 1024
	
	If (_Floor)
		FileSize := Floor(FileSize)
	
	Return FileSize
}

ELP_FileGetAttributesFromFI(ByRef _FileInfo, _Raw = 0)
{
	Static FileAttributesOffset := 0
	
	RAW_Attributes := NumGet(_FileInfo, FileAttributesOffset, "Int")
	
	If (_Raw)
		Return RAW_Attributes
	Else
		Return ELP_ConvertRAWAttributes(RAW_Attributes)
}

ELP_FileGetTimeFromFI(ByRef _FileInfo, _Which = "M", _Style = 1)
{
	Global Ptr
	Static CO := 4, AO := 12, MO := 20
	
	
	If (_Which = "C")
		Address := &_FileInfo + CO
	Else If (_Which = "A")
		Address := &_FileInfo + AO
	Else 
		Address := &_FileInfo + MO
	
	VarSetCapacity(FSystemTime,16,0) ;8*2
	
	If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
		Year := NumGet(FSystemTime, 0, "Short") 
		, Month := NumGet(FSystemTime, 2, "Short") 
		;, WDay := NumGet(FSystemTime, 4, "Short")
		, Day := NumGet(FSystemTime, 6, "Short")
		, Hour := NumGet(FSystemTime, 8, "Short")
		, Minute := NumGet(FSystemTime, 10, "Short")
		, Second := NumGet(FSystemTime, 12, "Short")
		, Milisecond := NumGet(FSystemTime, 14, "Short")
		, VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		
		If (_Style = 1){
			RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
			, RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
			Return RVal
		} Else If (_Style = 2)
			Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
	} Else {
		VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		, ErrorLevel := 3
	}
}

ELP_FileGetTime(_FileName, _Which = "M", _Style = 1)
{
	Global Ptr
	Static CO := 4, AO := 12, MO := 20
	
	Handle := ELP_OpenFileHandle(_FileName, "Read")
	
	If (Handle = -1){
		ErrorLevel := 1
		Return
	}
	
	VarSetCapacity(FileInformation, 52, 0) ;13*4
	
	If (!DllCall("GetFileInformationByHandle", Ptr, Handle, Ptr, &FileInformation)){
		ErrorLevel := 2
		, ELP_CloseFileHandle(Handle)
		, VarSetCapacity(FileInformation, 52, 0)
		, VarSetCapacity(FileInformation, 0)
		
		Return
	} Else
		ELP_CloseFileHandle(Handle)
	
	If (_Which = "C")
		Address := &FileInformation + CO
	Else If (_Which = "A")
		Address := &FileInformation + AO
	Else 
		Address := &FileInformation + MO
	
	VarSetCapacity(FSystemTime,16,0) ;8*2
	
	If (DllCall("FileTimeToSystemTime", Ptr, Address, Ptr, &FSystemTime)){
		Year := NumGet(FSystemTime, 0, "Short") 
		, Month := NumGet(FSystemTime, 2, "Short") 
		;, WDay := NumGet(FSystemTime, 4, "Short")
		, Day := NumGet(FSystemTime, 6, "Short")
		, Hour := NumGet(FSystemTime, 8, "Short")
		, Minute := NumGet(FSystemTime, 10, "Short")
		, Second := NumGet(FSystemTime, 12, "Short")
		, Milisecond := NumGet(FSystemTime, 14, "Short")
		, VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		
		If (_Style = 1){
			RVal := Year * 10000000000000 + Month * 100000000000 + Day * 1000000000
			, RVal += Hour * 10000000 + Minute * 100000 + Second * 1000 + Milisecond
			Return RVal
		} Else If (_Style = 2)
			Return Year * 10000000000 + Month * 100000000 + Day * 1000000 + Hour * 10000 + Minute * 100 + Second
	} Else {
		VarSetCapacity(FSystemTime, 16, 0)
		, VarSetCapacity(FSystemTime, 0)
		, ErrorLevel := 3
	}
}


ELP_FileAppend(_String, _FileName)
{
	Global Ptr
	Static UTF8_BOM1 = 239, UTF8_BOM2 = 187, UTF8_BOM3 = 191
	, UTF16LE_BOM1 = 255, UTF16LE_BOM2 = 254
	, UTF8_CP = 65001, UTF16_CP = 1200
	
	If (_FileName = ""){
		ErrorLevel := 2
		Return
	}
	
	If (SubStr(_FileName, 1, 1) = "*"){
		Binary_Mode := True
		, _FileName := SubStr(_FileName, 2)
	}
	
	If (P := InStr(_FileName, ",")){
		CodePage := SubStr(_FileName, P + 1)
		, _FileName := SubStr(_FileName, 1, P-1)
	} Else If (A_FileEncoding)
		CodePage := A_FileEncoding
	
	Handle := ELP_OpenFileHandle(_FileName, "Write", FileSize)
	
	If (Handle = -1){
		ErrorLevel := 1
		Return
	}
	
	If (CodePage = "")
		W_CP := 0
	Else If (CodePage = "UTF-8" Or CodePage = "UTF-8-RAW")
		W_CP := UTF8_CP
	Else If (CodePage = "UTF-16" Or CodePage = "UTF-16-RAW")
		W_CP := UTF16_CP
	Else If (SubStr(CodePage, 1, 2) = "CP"){
		W_CP := SubStr(CodePage, 2)
		
		If W_CP Is Not Number
			W_CP := 0
	} Else
		W_CP := 0
	
	If (!Binary_Mode){
		If (!InStr(_String, "`r`n") And InStr(_String, "`n"))
			StringReplace, _String, _String, "`n", "`r`n", 1
	}
	
	If (A_IsUnicode){
		If (W_CP != UTF16_CP){
			If (W_CP = 0)
				W_CP := DllCall("GetACP")
			
			StringLength := DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(__String, StringLength, 0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength, Ptr, 0, Ptr, 0)
			, Converted := True
		}
	} Else If (W_CP != 0){
		StringLength := DllCall("MultiByteToWideChar", "UInt", 0,"UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, 0, "Int", 0)
		, VarSetCapacity(__String, StringLength * 2, 0)
		, DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, Ptr, &_String, "Int", StrLen(_String), Ptr, &__String, "Int", StringLength)
		
		If (W_CP != UTF16_CP){
			Temp_StringLength := StringLength
			, StringLength := DllCall("WideCharToMultiByte","UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0)
			, VarSetCapacity(_String,StringLength,0)
			, DllCall("WideCharToMultiByte", "UInt", W_CP, "UInt", 0, Ptr, &__String, "Int", Temp_StringLength, Ptr, &_String, "Int", StringLength, Ptr, 0, Ptr, 0)
			, VarSetCapacity(__String, Temp_StringLength * 2, 0)
			, VarSetCapacity(__String, 0)
		} Else
			StringLength *= 2
		
		Converted := True
	}
	
	If (FileSize = 0){
		If (CodePage = "UTF-8"){
			VarSetCapacity(BOM, 3, 0)
			, NumPut(UTF8_BOM1, BOM,0, "UChar")
			, NumPut(UTF8_BOM2, BOM,1, "UChar")
			, NumPut(UTF8_BOM3, BOM,2, "UChar")
			, ELP_WriteData(Handle, &BOM, 3)
			, FileSize += 3
			, VarSetCapacity(BOM, 3, 0)
			, VarSetCapacity(BOM, 0)
		} Else If (CodePage = "UTF-16"){
			VarSetCapacity(BOM, 2, 0)
			, NumPut(UTF16LE_BOM1, BOM, 0, "UChar")
			, NumPut(UTF16LE_BOM2, BOM, 1, "UChar")
			, ELP_WriteData(Handle, &BOM, 2)
			, FileSize += 2
			, VarSetCapacity(BOM, 2, 0)
			, VarSetCapacity(BOM, 0)
		}
	}
	
	ELP_SetFilePointer(Handle, FileSize)
	
	If (Converted){
		If (A_IsUnicode Or W_CP = UTF16_CP){
			ELP_WriteData(Handle, &__String, StringLength)
			, VarSetCapacity(__String, StringLength, 0)
			, VarSetCapacity(__String, 0)
		} Else {
			ELP_WriteData(Handle, &_String, StringLength)
			, VarSetCapacity(_String, StringLength, 0)
			, VarSetCapacity(_String, 0)
		}
	} Else
		ELP_WriteData(Handle, &_String, StrLen(_String) * (A_IsUnicode ? 2 : 1))
	
	ELP_CloseFileHandle(Handle)
}

ELP_LoopFilePattern(_FileName, _IncludeFolders = 0, _DoRecurse = 0, ByRef FileInfo = "", Override_ID = "")
{
	Static
	;Ensures that atleast the first entry of the common sets are static
	Static @0__CurrentFileName, @0__CurrentPath, @0__Handle, @0__FN, Stored__Handles
	, @0_ELPFRD_CurrentFileName, @0_ELPFRD_CurrentPath, @0_ELPFRD_Handle, @0_ELPFRD_FN, Stored_ELPFRD_Handles
	, @0_ELPFE_CurrentFileName, @0_ELPFE_CurrentPath, @0_ELPFE_Handle, @0_ELPFE_FN, Stored_ELPFE_Handles
	, @0_ELPFD_CurrentFileName, @0_ELPFD_CurrentPath, @0_ELPFD_Handle, @0_ELPFD_FN, Stored_ELPFD_Handles
	, @0_ELPFSA_CurrentFileName, @0_ELPFSA_CurrentPath, @0_ELPFSA_Handle, @0_ELPFSA_FN, Stored_ELPFSA_Handles
	, @0_ELPFGS_CurrentFileName, @0_ELPFGS_CurrentPath, @0_ELPFGS_Handle, @0_ELPFGS_FN, Stored_ELPFGS_Handles
	, @0_ELPCF_CurrentFileName, @0_ELPCF_CurrentPath, @0_ELPCF_Handle, @0_ELPCF_FN, Stored_ELPCF_Handles
	, @0_ELPFM_CurrentFileName, @0_ELPFM_CurrentPath, @0_ELPFM_Handle, @0_ELPFM_FN, Stored_ELPFM_Handles
	, @0_ELPFCD_CurrentFileName, @0_ELPFCD_CurrentPath, @0_ELPFCD_Handle, @0_ELPFCD_FN, Stored_ELPFCD_Handles
	, @0_ELPFC_CurrentFileName, @0_ELPFC_CurrentPath, @0_ELPFC_Handle, @0_ELPFC_FN, Stored_ELPFC_Handles
	, @0_ELPFST_CurrentFileName, @0_ELPFST_CurrentPath, @0_ELPFST_Handle, @0_ELPFST_FN, Stored_ELPFST_Handles
	Global Ptr
	Local FileName, FilePath, SearchPattern, Folders
	, P1, P2, Handle, __FileName, __ID, ID, FoundName ;, Recursed := 0
	
	ELPLFP_Start:
	
	If (Last_OverrideID = Override_ID And Last_FileName = _FileName){
		__ID := Last___ID
		, FileName := @%__ID%_%Override_ID%_CurrentFileName
		, CurrentPath := @%__ID%_%Override_ID%_CurrentPath
		, Handle := @%__ID%_%Override_ID%_Handle
	} Else If (P1 := InStr(Stored_%Override_ID%_Handles,"|" . _FileName . "|")){
		P2 := P1 + StrLen(_FileName) + 2
		, __ID := SubStr(Stored_%Override_ID%_Handles, P2, InStr(Stored_%Override_ID%_Handles, "|", False, P2) - P2)
		, FileName := @%__ID%_%Override_ID%_CurrentFileName
		, CurrentPath := @%__ID%_%Override_ID%_CurrentPath
		, Handle := @%__ID%_%Override_ID%_Handle
		, Last_FileName := _FileName
		, Last___ID := __ID
		, Last_OverrideID := Override_ID
	} Else If (_IncludeFolders != "Close"){
		FileName := _FileName
		, __ID := 0
		
		While (InStr(Stored_%Override_ID%_Handles,"|" . __ID . "|"))
			__ID ++
		
		@%__ID%_%Override_ID%_FN := 0
		, Stored_%Override_ID%_Handles .= Stored_%Override_ID%_Handles ? _FileName . "|" . __ID . "|" : "|" . _FileName . "|" . __ID . "|"
		, Last_FileName := _FileName
		, Last___ID := __ID
		, Last_OverrideID := Override_ID
	}
	
	If (_IncludeFolders = "Close"){
		ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
		If (__ID != ""){
			VarSetCapacity(@%__ID%_%Override_ID%_CurrentFileName, 0)
			, VarSetCapacity(@%__ID%_%Override_ID%_CurrentPath, 0)
			, ELP_FindClose(@%__ID%_%Override_ID%_Handle)
			, VarSetCapacity(@%__ID%_%Override_ID%_Handle, 0)
			
			Loop,% @%__ID%_%Override_ID%_FN
				VarSetCapacity(@Folder_%A_Index%_%Override_ID%, 0)
			
			VarSetCapacity(@%__ID%_%Override_ID%_FN, 0)
		}
		
		VarSetCapacity(Last_FileName, 0)
		, VarSetCapacity(Last___ID, 0)
		, VarSetCapacity(Last_OverrideID, 0)
		, VarSetCapacity(FileInfo, 1140, 0)
		, VarSetCapacity(FileInfo, 0)
		
		Return
	}
	
	If (!Handle){
		__FileName := FileName
		, ELP_ConvertPath(__FileName)
		, VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		, Handle := DllCall("FindFirstFileW", Ptr, &__FileName, Ptr, &FileInfo)
		
		If (Handle = -1){
			If (_DoRecurse){
				Folders := ELP_FindFolders(FileName, _DoRecurse)

				If (Folders != ""){
					P1 := InStr(FileName, "\", False, 0)
					, FilePath := SubStr(FileName, 1, P1)
					, SearchPattern := SubStr(FileName, P1+1)
					
					Loop,Parse,Folders,|
					{
						@%__ID%_%Override_ID%_FN ++
						ID := @%__ID%_%Override_ID%_FN
						@Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
					}
				}
			}
		} Else {
			FoundName := ELP_GetNameFromFI(FileInfo)
			, @%__ID%_%Override_ID%_CurrentFileName := FileName
			, CurrentPath := @%__ID%_%Override_ID%_CurrentPath := SubStr(FileName, 1, InStr(FileName, "\", False, 0))
			, @%__ID%_%Override_ID%_Handle := Handle
			
			If (FoundName = "." Or FoundName = ".."){
				FoundName := ""
				, VarSetCapacity(FileInfo, 0)
				GoTo,ELPLFP_Start
			} Else If (!_IncludeFolders){
				If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			} Else If (_IncludeFolders = 2){
				If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			}
		}
	} Else {
		VarSetCapacity(FileInfo, 1140, 0) ; 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		
		If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
			ELP_FindClose(Handle)
			, Handle := @%__ID%_%Override_ID%_Handle := ""
			
			If (_DoRecurse){
				Folders := ELP_FindFolders(FileName, _DoRecurse)
				
				If (Folders != ""){
					P1 := InStr(FileName, "\", False, 0)
					, FilePath := SubStr(FileName, 1, P1)
					, SearchPattern := SubStr(FileName, P1+1)
					
					Loop, Parse, Folders, |
					{
						@%__ID%_%Override_ID%_FN ++
						ID := @%__ID%_%Override_ID%_FN
						@Folder_%ID%_%Override_ID% := FilePath . A_LoopField . "\" . SearchPattern
					}
				}
			}
		} Else {
			FoundName := ELP_GetNameFromFI(FileInfo)
			
			If (FoundName = "." Or FoundName = ".."){
				FoundName := ""
				, VarSetCapacity(FileInfo, 0)
				GoTo,ELPLFP_Start
			} Else If (!_IncludeFolders){
				If (FoundName != "" And ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			} Else If (_IncludeFolders = 2){
				If (FoundName != "" And !ELP_IsDirectoryFromFI(FileInfo)){
					FoundName := ""
					, VarSetCapacity(FileInfo, 0)
					GoTo,ELPLFP_Start
				}
			}
		}
	}
	
	If (FoundName != "")
		Return CurrentPath . FoundName
	Else If (@%__ID%_%Override_ID%_FN){
		ID := @%__ID%_%Override_ID%_FN
		, @%__ID%_%Override_ID%_FN --
		, @%__ID%_%Override_ID%_CurrentFileName := @Folder_%ID%_%Override_ID%
		, VarSetCapacity(@Folder_%ID%_%Override_ID%, 0)
		GoTo,ELPLFP_Start
	} Else {
		If (InStr(Stored_%Override_ID%_Handles, "|" . _FileName . "|")){
			ELP_DeleteFileHandle(Stored_%Override_ID%_Handles, _FileName)
			, @%__ID%_%Override_ID%_CurrentFileName := ""
			, @%__ID%_%Override_ID%_CurrentPath := ""
			, @%__ID%_%Override_ID%_Handle := ""
			, Last_FileName := Last___ID := Last_OverrideID := ""
		}
	}
}

ELP_DeleteFileHandle(ByRef _StoredHandles, _FileName)
{
	P1 := InStr(_StoredHandles, "|" . _FileName . "|")
	
	If (P1){
		P2 := P1 + StrLen(_FileName) + 2
		, New_1 := SubStr(_StoredHandles, 1, P1 - 1)
		, New_2 := SubStr(_StoredHandles, InStr(_StoredHandles, "|", False, P2))
		, _StoredHandles := New_1 . New_2
		
		If (_StoredHandles = "|")
			VarSetCapacity(_StoredHandles, 0)
	}
}

ELP_FindFolders(_FileName, _DoRecurse)
{
	Global Ptr
	
	If (_DoRecurse = 2)
		__FilePath := _FileName
	Else
		__FilePath := SubStr(_FileName, 1, InStr(_FileName, "\", False, 0)) . "*.*"
	
	ELP_ConvertPath(__FilePath)
	, VarSetCapacity(FileInfo, 1140, 0) 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
	, Handle := DllCall("FindFirstFileW", Ptr, &__FilePath, Ptr, &FileInfo)
	
	If (Handle = -1)
		Return
	
	Loop
	{
		FolderName := ELP_GetNameFromFI(FileInfo)
		
		If (FolderName != "." And FolderName != ".."){
			If (ELP_IsDirectoryFromFI(FileInfo))
				AllFolders .= AllFolders ? "|" . FolderName : FolderName
		}
			
		VarSetCapacity(FileInfo, 1140, 0) 4 + 3*8 + 4*4 + 260*4 + 14*4 = 1140
		If (!DllCall("FindNextFileW", Ptr, Handle, Ptr, &FileInfo)){
			ELP_FindClose(Handle)
			
			Return AllFolders
		}
	}
}

ELP_GetNameFromFI(ByRef _FileInfo)
{
	Global Ptr
	Static NameOffset := 44, L_Name := "StrGet"
	
	If (A_IsUnicode)
		Name := %L_Name%(&_FileInfo + NameOffset,-1,"UTF-16")
	Else
		Name := StrGetB(&_FileInfo + NameOffset,-1,"UTF-16")
	
	Return Name
}

StrGetB(Address, Length=-1, Encoding=0)
{
	; Flexible parameter handling:
	if Length is not integer
	Encoding := Length,  Length := -1

	; Check for obvious errors.
	if (Address+0 < 1024)
		return

	; Ensure 'Encoding' contains a numeric identifier.
	if Encoding = UTF-16
		Encoding = 1200
	else if Encoding = UTF-8
		Encoding = 65001
	else if SubStr(Encoding,1,2)="CP"
		Encoding := SubStr(Encoding,3)

	if !Encoding ; "" or 0
	{
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "uint", Address)
		VarSetCapacity(String, Length)
		DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
	}
	else if Encoding = 1200 ; UTF-16
	{
		char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
		VarSetCapacity(String, char_count)
		DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
	}
	else if Encoding is integer
	{
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
		VarSetCapacity(String, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
		String := StrGetB(&String, char_count, 1200)
	}
	
	return String
}

ELP_IsDirectoryFromFI(ByRef _FileInfo)
{
	Static FILE_ATTRIBUTE_DIRECTORY := 0x10
	
	Return NumGet(_FileInfo, 0, "UInt") & FILE_ATTRIBUTE_DIRECTORY
}

ELP_FindClose(_Handle)
{
	Global Ptr
	
	Return DllCall("FindClose", Ptr, _Handle)
}










ELP_SetEndOfFile(_Handle, _Size)
{
	Global Ptr
	
	Old_Pointer := ELP_GetFilePointer(_Handle)
	, ELP_SetFilePointer(_Handle, _Size)
	, ErrorLevel := DllCall("SetEndOfFile", Ptr, _Handle) = 0 ? 1 : 0
	, ELP_SetFilePointer(_Handle, Old_Pointer)
	
	Return ErrorLevel
}

ELP_WOW64FileRedirect(_NewState)
{
	Global Ptr
	Static OldValue, CurrentValue := "Enabled"
	
	If ((_NewState = 0 Or _NewState = "Disable") And CurrentValue != "Disabled"){
		VarSetCapacity(OldValue, 500, 0)
		, E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
		, CurrentValue := "Disable"
	} Else If ((_NewState = 1 Or _NewState = "Enable") And CurrentValue != "Enabled"){
		E := DllCall("Wow64DisableWow64FsRedirection", Ptr, &OldValue)
		, CurrentValue := "Enabled"
	}
	
	Return E
}

ELP_OpenFileHandle(_FileName, _DesiredAccess, ByRef _FileSize = 0)
{
	Global Ptr
	Static GENERIC_ALL := 0x10000000
	, GENERIC_READ = 0x80000000
	, GENERIC_WRITE := 0x40000000
	, GENERIC_EXECUTE  := 0x20000000
	, FILE_SHARE_DISABLE := 0x00000000
	, FILE_SHARE_DELETE := 0x00000004
	, FILE_SHARE_READ := 0x00000001
	, FILE_SHARE_WRITE := 0x00000002
	, FILE_SHARE_READ_WRITE := 0x00000003
	
	ELP_ConvertPath(_FileName)
	
	If (_DesiredAccess = "Read")
		Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_READ, "UInt", FILE_SHARE_READ_WRITE, "UInt", 0, "UInt", 3, "UInt", 0, "UInt", 0)
	Else If (_DesiredAccess = "Write")
		Handle_ := DllCall("CreateFileW", Ptr, &_FileName, "UInt", GENERIC_READ | GENERIC_WRITE, "UInt", FILE_SHARE_READ, "UInt", 0, "UInt", 4, "UInt", 0, "UInt", 0)
	
	_FileSize := 0
	If (Handle_ = -1)
		ErrorLevel := 1
	Else {
		DllCall("GetFileSizeEx", Ptr, Handle_, "Int64*", _FileSize)
		, _FileSize := _FileSize = -1 ? 0 : _FileSize
	}
	
	Return Handle_
}

ELP_SetFilePointer(_Handle, _DesiredValue)
{
	Global Ptr
	
	DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", _DesiredValue, "UInt *", P, "Int", 0)
}

ELP_WriteData(ByRef _Handle, _DataAddress, _BytesToWrite, _AttemptV = 1)
{
	Global Ptr
	Static UInt_MAX = 4294967295
	
	If (_AttemptV)
		Verify_Writes := ELP_MasterSettings("Get", "Verify_Writes")
	
	WriteBytes := _BytesToWrite
	, Original_FilePointer := ELP_GetFilePointer(_Handle)
	, Total_BytesWritten := 0
	
	While (WriteBytes > 0){
		Write_Size := WriteBytes > UInt_MAX ? UInt_MAX : WriteBytes
		, WriteBytes -= UInt_MAX
		
		, ELP_SetFilePointer(_Handle, Original_FilePointer + ((A_Index - 1) * UInt_MAX))
		, DllCall("WriteFile", Ptr, _Handle, Ptr, _DataAddress + ((A_Index - 1) * UInt_MAX), "UInt", Write_Size, "UInt*", BytesWritten, "UInt", 0)
		
		, Total_BytesWritten += BytesWritten
	}
	
	If (ELP_MasterSettings("Get", "Count_BytesWritten"))
		ELP_StoreBytes("AddWrite", Total_BytesWritten)
	
	If (Verify_Writes And _AttemptV)
		ELP_VerifyWrite(_Handle, _DataAddress, _BytesToWrite, Original_FilePointer, ELP_GetFilePointer(_Handle))
	
	Return Total_BytesWritten
}

ELP_ReadData(_Handle, _DataAddress, _BytesToRead, _AttemptV = 1)
{
	Global Ptr
	Static UInt_MAX = 4294967295
	
	If (_AttemptV)
		ELP_VerifyReads := ELP_MasterSettings("Get", "ELP_VerifyReads")
	
	ReadBytes := _BytesToRead
	, Original_FilePointer := ELP_GetFilePointer(_Handle)
	, Total_BytesRead := 0
	
	While (ReadBytes > 0){
		Read_Size := ReadBytes > UInt_MAX ? UInt_MAX : ReadBytes
		, ReadBytes -= UInt_MAX
		
		, ELP_SetFilePointer(_Handle, Original_FilePointer + ((A_Index - 1) * UInt_MAX))
		, DllCall("ReadFile", Ptr, _Handle, Ptr, _DataAddress + ((A_Index - 1) * UInt_MAX), "UInt", Read_Size, "UInt*", BytesRead, "UInt", 0)
		
		, Total_BytesRead += BytesRead
	}
	
	If (ELP_MasterSettings("Get", "Count_BytesRead"))
		ELP_StoreBytes("AddRead", Total_BytesRead)
	
	If (_AttemptV And ELP_VerifyReads)
		ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, ELP_GetFilePointer(_Handle))
	
	Return Total_BytesRead
}

ELP_CloseFileHandle(_Handle)
{
	Global Ptr
	
	DllCall("CloseHandle", Ptr, _Handle)
}

ELP_GetFilePointer(_Handle)
{
	Global Ptr
	
	DllCall("SetFilePointerEx", Ptr, _Handle, "Int64", 0, "Int64*", Current_FilePointer, "Int", 1)
	
	Return Current_FilePointer
}

ELP_VerifyWrite(_Handle, _DataAddress, _BytesToWrite, Original_FilePointer, Current_FilePointer)
{
	;FileName := ELP_GetPathFromHandle(_Handle)
	;If (FileName = -1)
	;	Return
	
	VarHash := ELP_CalcMD5(_DataAddress, _BytesToWrite)
	
	;, ELP_CloseFileHandle(_Handle)
	;, H := ELP_OpenFileHandle(FileName, "Read", FileSize)
	, ELP_SetFilePointer(_Handle, Original_FilePointer)
	, VarSetCapacity(TempData, _BytesToWrite, 0)
	, ELP_ReadData(_Handle, &TempData, _BytesToWrite, 0)
	
	;, ELP_CloseFileHandle(H)
	, FileHash := ELP_CalcMD5(&TempData, _BytesToWrite)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	, VarSetCapacity(TempData, 0)
	
	;, _Handle := ELP_OpenFileHandle(FileName, "Write") ;Open the file back up to it's original state
	, ELP_SetFilePointer(_Handle, Current_FilePointer)
	
	If (VarHash != FileHash)
		ErrorLevel := -100
}

ELP_VerifyRead(_Handle, _DataAddress, _BytesToRead, Original_FilePointer, Current_FilePointer)
{
	VarHash := ELP_CalcMD5(_DataAddress, _BytesToRead)
	
	, ELP_SetFilePointer(_Handle, Original_FilePointer)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	
	, ELP_ReadData(_Handle, &TempData, _BytesToRead, 0)
	, FileHash := ELP_CalcMD5(&TempData, _BytesToRead)
	, VarSetCapacity(TempData, _BytesToRead, 0)
	, VarSetCapacity(TempData, 0)
	
	, ELP_SetFilePointer(_Handle, Current_FilePointer)
	
	If (VarHash != FileHash)	
		ErrorLevel := -101
}

ELP_GetPathFromHandle(_Handle)
{
	Global Ptr
	Static Old_OperatingSystems := "WIN_NT4,WIN_95,WIN_98,WIN_ME,WIN_2000,WIN_2003,WIN_XP"
	
	If (InStr("," . Old_OperatingSystems . ",", "," . A_OSVersion . ",")) ;Requires Vista/Server 2008 or later
		Return -1
	
	CallName := A_IsUnicode ? "Kernel32.dll\GetFinalPathNameByHandleW" : "Kernel32.dll\GetFinalPathNameByHandleA"
	, PathLength := DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", 0, "UInt", 0)
	, VarSetCapacity(FileName, PathLength * 2, 0)
	, DllCall(CallName, Ptr, _Handle, Ptr, &FileName, "UInt", PathLength * 2, "UInt", 0)
	, VarSetCapacity(FileName, -1)
	
	Return FileName
}

ELP_GetPathRoot(_FileName)
{
	If (SubStr(_FileName, 2, 2) = ":\") ;Local file
		I := 3
	Else If (SubStr(_FileName, 1, 9) = "\\?\UNC\\"){ ;Long network path
		P := InStr(_FileName, "\", False, 10) + 2
		If (SubStr(_FileName, P, 2) = "$\") ;Long admin network share
			I := P + 1
		Else ;Long normal network share
			I := InStr(_FileName, "\", False, P + 2)
	} Else If (SubStr(_FileName, 1, 4) = "\\?\") ;Long local path
		I := 7
	Else If (SubStr(_FileName, 1, 2) = "\\") ;Network path
		I := InStr(_FileName, "\", False, InStr(_FileName, "\", False, 3) + 1)
	Else
		Return
	
	Return SubStr(_FileName, 1, I)
}

ELP_FileCreateDirectory(_Directory, _CreateParents = 1)
{
	Global Ptr
	Static ERROR_ALREADY_EXISTS := 183
	
	__Directory := _Directory
	, ELP_ConvertPath(__Directory)
	, E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
	
	If (E Or A_LastError = ERROR_ALREADY_EXISTS) ;Directory already exists != critical error
		ErrorLevel := 0
	Else If (_CreateParents){
		If (SubStr(_Directory, 0) != "\")
			_Directory .= "\"
		
		Part_Length := StrLen(ELP_GetPathRoot(_Directory))
		, I := StrLen(_Directory)
		
		While (Part_Length < I){
			Part_Length := InStr(_Directory, "\", False, Part_Length + 1)
			, __Directory :=  SubStr(_Directory, 1, Part_Length)
			, ELP_ConvertPath(__Directory)
			, E := DllCall("CreateDirectoryW", Ptr, &__Directory, "UInt", 0)
		}
		
		If (E Or A_LastError = ERROR_ALREADY_EXISTS)
			ErrorLevel := 0
		Else
			ErrorLevel := 1
	}
	
	Return ErrorLevel
}

ELP_CalcMD5(_VarAddress, _VarSize)
{
	Global Ptr
	Static Hex = "123456789ABCDEF0"
	
	VarSetCapacity(MD5_CTX, 104, 0)
	, DllCall("advapi32\MD5Init", Ptr, &MD5_CTX)
	, DllCall("advapi32\MD5Update", Ptr, &MD5_CTX, Ptr, _VarAddress, "UInt", _VarSize)
	, DllCall("advapi32\MD5Final", Ptr, &MD5_CTX)
	
	Loop,16
		MD5 .= NumGet(MD5_CTX, 87 + A_Index, "UChar")
	;N := NumGet(MD5_CTX, 87 + A_Index, "Char"), MD5 .= SubStr(Hex, N >> 4, 1) . SubStr(Hex, N & 15, 1)
	
	Return MD5
}

ELP_ConvertPath(ByRef _String)
{
	Global Ptr
	
	If (SubStr(_String, 1, 4) != "\\?\"){
		If (SubStr(_String, 1, 2) = "\\")
			String_C := "\\?\UNC\" . SubStr(_String, 3)
		Else
			String_C := "\\?\" . _String
	} Else
		String_C := _String
	
	If (A_IsUnicode){
		_String := String_C
		Return
	} Else {
		CodePage := DllCall("GetACP")
		, Size := DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, 0, "Int", 0)
		, VarSetCapacity(_String, 2 * Size, 0)
		, DllCall("MultiByteToWideChar", "UInt", CodePage, "UInt", 0, ptr, &String_C, "Int", -1, ptr, &_String, "Int", Size)
	}
}

ELP_StoreBytes(_Cmd, _V = 0)
{
	Static BW := 0, BR := 0
	
	If (_Cmd = "AddRead")
		BR += _V
	Else If (_Cmd = "AddWrite")
		BW += _V
	Else If (_Cmd = "GetRead")
		Return BR
	Else If (_Cmd = "GetWrite")
		Return BW
	Else If (_Cmd = "ResetRead")
		BR := 0
	Else If (_Cmd = "ResetWrite")
		BW := 0
}

ELP_MasterSettings(_Cmd, _Value, _NewValue = "")
{
	Static Verify_Writes :=  False
	, Verify_Reads := False
	, Count_BytesWritten := False
	, Count_BytesRead := False
	, Version := 1.0
	
	If (_Cmd = "Get"){
		If (_Value = "Verify_Writes"){
			Return Verify_Writes
		} Else If (_Value = "Verify_Reads"){
			Return Verify_Reads
		} Else If (_Value = "Count_BytesWritten"){
			Return Count_BytesWritten
		} Else If (_Value = "Count_bytesRead"){
			Return Count_bytesRead
		} Else If (_Value = "Version"){
			Return Version
		}
	} Else If (_Cmd = "Set"){
		If (_Value = "Verify_Writes"){
			Verify_Writes := _NewValue
		} Else If (_Value = "Verify_Reads"){
			Verify_Reads := _NewValue
		} Else If (_Value = "Count_BytesWritten"){
			Count_BytesWritten := _NewValue
		} Else If (_Value = "Count_bytesRead"){
			Count_bytesRead := _NewValue
		}
	}
}