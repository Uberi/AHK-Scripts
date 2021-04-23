;===============================================================================
;
; Function:         Wrapper functions for SQLite.dll to work on SQLite DBs.
; AHK version:      1.0.48.05
; Language:         English
; Tested on:        Win Vista
; Author:           nick (denick)
; Version:          1.00.00/2006-09-23/nick
;                   1.00.01/2006-15-11/nick
;                   2.00.00/2010-02-10/nick
;
;===============================================================================
; Most of these function are transcripted from the AutoIt3-Script SQLite.au3.
; Let's thank picasso (Fida Florian) for sharing it at
; www.autoitscript.com/forum/index.php?showtopic=17099
;===============================================================================
; This software is provided 'as-is', without any express or
; implied warranty.  In no event will the authors be held liable for any
; damages arising from the use of this software.
;===============================================================================
; List of Functions:
;===============================================================================
; - Load SQLite3.dll
; SQLite_Startup() 
; - Unload SQLite3.dll
; SQLite_Shutdown()
; - Open a DB connection
; SQLite_OpenDB(DBFile)
; - Close DB connection
; SQLite_CloseDB(hDB)
; - Get full result for SQL query (SELECT)
; SQLite_GetTable(hDB, SQL, ByRef Result, ByRef Rows, ByRef Cols, MaxResult = -1)
; - Get full result for SQL query (SELECT), values stored in global variables
; SQLite_GetTableGlobal(hDB, SQL, ByRef Rows, ByRef Cols, ByRef Names, Prefix = "", MaxResult = -1)
; - Free global variables created by SQLite_GetTableGlobal()
; SQLite_FreeGlobalResult(Rows, Cols, Prefix = "")
; - Execute non query SQL statements
; SQLite_Exec(hDB, SQL)
; - Prepare SQL query
; SQlite_Query(hDB, SQL)
; - Get column names from prepared query
; SQLite_FetchNames(hQuery, ByRef Names)
; - Get next row of data from prepared query
; SQLite_FetchData(hQuery, ByRef Row)
; - Get next row of data from prepared query, column values stored in global variables
; SQLite_FetchDataGlobal(hQuery, Prefix = "")
; - Free prepared query
; SQLite_QueryFinalize(hQuery)
; - Reset prepared query for reuse
; SQLite_QueryReset(hQuery)
; - Execute SQLite3.exe with given commands
; SQLite_SQLiteExe(DBFile, Commands, ByRef Output)
; - Get SQLite3.dll version number
; SQLite_LibVersion()
; - Get the ROWID of the last inserted row
; SQLite_LastInsertRowID(hDB, ByRef RowID)
; - Get number of changes caused by last SQL statement
; SQLite_Changes(hDB, ByRef Rows)
; - Get number of changes since connecting to database
; SQLite_TotalChanges(hDB, ByRef Rows)
; - Get the SQLite error message caused by last SQL statement
; SQLite_ErrMsg(hDB, ByRef Msg)
; - Get the SQLite error code caused by last SQL statement
; SQLite_ErrCode(hDB, ByRef Code)
; - Set SQLite's busy timer's timeout
; SQLite_SetTimeout(hDB, Timeout = 1000)
; - Get description for last error
; SQLite_LastError(Error = "")
; - Set/get path for SQLite3.dll
; SQLite_DLLPath(Path = "")
; - Set/get path for SQLite.exe
; SQLite_EXEPath(Path = "")
; - Set/get row delimiter for results
; SQLite_RowDelim(Delim = "")
; - Set/get column delimiter for results
; SQLite_ColDelim(Delim = "")
; **************************** Internal functions ******************************
; _SQLite_ModuleHandle(Handle = "")
; _SQLite_CurrentDB(hDB = "")
; _SQLite_CheckDB(hDB, Action = "")
; _SQLite_CurrentQuery(hQuery = "")
; _SQLite_CheckQuery(hQuery, hDB = "")
; _SQLite_ReturnCode(RC)
;===============================================================================
; SQLite Returncodes
;===============================================================================
; see _SQLite_ReturnCode()
;===============================================================================
; Function Name:    SQLite_StartUP()
; Description:      Loads SQLite3.dll
; Requirements:     Valid path to SQLite3.dll stored in SQLite_DLLPath().
;                   Default: A_ScriptDir . "\SQLite3.dll"
; Parameter(s):     None
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
; Author(s):        nick
;===============================================================================
SQLite_Startup() {
   hDLL := DllCall("LoadLibrary", Str, SQLite_DLLPath())
   If !(ErrorLevel)
      _SQLite_ModuleHandle(hDLL)
   Return (ErrorLevel ? False : True)
}
;===============================================================================
; Function Name:    SQLite_Shutdown()
; Description:      Unloads SQLite3.dll
; Parameter(s):     None
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
; Author(s):        nick
;===============================================================================
SQLite_Shutdown() {
   DllCall("FreeLibrary", UInt, _SQLite_ModuleHandle())
   Return (ErrorLevel ? False : True)
}
;===============================================================================
; Function Name:    SQLite_OpenDB()
; Description:      Opens a database.
; Parameter(s):     DBFile - Database filename
; Return Value(s):  On Success - DB handle
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_OpenDB(DBFile) {
   SQLite_LastError(" ")
   If (DBFile = "")
      DBFile := ":memory:"
   RC := DllCall("sqlite3\sqlite3_open", Str, DBFile, UIntP, hDB, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_open failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   _SQLite_CheckDB(hDB, "Store")
   _SQLite_CurrentDB(hDB)
   Return hDB
}
;===============================================================================
; Function Name:    SQLite_CloseDB()
; Description:      Closes an open database.
;                   Waits until SQLite <> _SQLITE_BUSY until 'Timeout' has elapsed
; Parameter(s):     hDB - DB handle, -1 for last opened DB
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_CloseDB(hDB) {
   SQLite_LastError(" ")
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB)
      Return True
   RC := DllCall("sqlite3\sqlite3_close", UInt, hDB, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError := DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str")
      ErrorLevel := RC
      Return False
   }
   _SQLite_CheckDB(hDB, "Free")
   Return True
}
;===============================================================================
; Function Name:    SQLite_GetTable()
; Description:      Provides two strings containing column names and data for a
;                   given query. Columns are seperated by SQLite_ColDelim(),
;                   rows by SQLite_RowDelim()
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   SQL - SQL statement to be executed
;                   ByRef Result - Passes out the result string
;                   ByRef Rows   - Passes out the number of 'Data' rows
;                   ByRef Cols   - Passes out the number of columns
;                   MaxResult    - Optional: Number of rows to be returned
;                                  Default = -1 : All rows
;                                  Specify 0 to get only the number of rows and columns
;                                  Specify 1 to get column names also 
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_GetTable(hDB, SQL, ByRef Rows, ByRef Cols, ByRef Names, ByRef Result, MaxResult = -1) {
   SQLite_LastError(" ")
   Rows := Cols := 0
   Names := Result := ""
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid database handle " . hDB)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   If MaxResult Is Not Integer
      MaxResult := -1
   If (MaxResult < -1)
      Maxresult := -1
   pResult := pErr := 0
   RC := DllCall("sqlite3\sqlite3_get_table", UInt, hDB, Str, SQL, UIntP, pResult
               , UIntP, Rows, UIntP, Cols, UIntP, pErr, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_get_table failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   If (MaxResult = 0) {
		DllCall("SQLite3\sqlite3_free_table", UInt, pResult, "Cdecl")   
      If (ErrorLevel) {
         SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
         Return False
      }
      Return True
   }
   If (MaxResult = 1)
      GetRows := MaxResult
   Else If (MaxResult > 1) && (MaxResult < Rows)
      GetRows := MaxResult + 1
   Else
      GetRows := Rows + 1
   Offset := 0
   Loop, %GetRows% {
      Row := ""
      Loop, %Cols% {
         Col := DllCall("MulDiv", UInt, NumGet(pResult+0, Offset), Int, 1, Int, 1, "Str")
         Row .= Col . SQLite_ColDelim()  
         Offset += 4
      }
      StringTrimRight Row, Row, 1
      If (A_index = 1)
         Names .= Row
      Else
         Result .= Row . SQLite_RowDelim()
   }
   StringTrimRight Result, Result, 1
   ; Free Results Memory
   DllCall("SQLite3\sqlite3_free_table", UInt, pResult, "Cdecl")   
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_GetTableGlobal()
; Description:      Provides the number of rows, the number of columns and the
;                   column names for a given query. Result's data are stored in 
;                   global variables %Prefix%R%RowIndexC%ColumnIndex%.
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   SQL - SQL statement to be executed
;                   ByRef Rows   - Passes out the number of 'Data' rows
;                   ByRef Cols   - Passes out the number of columns
;                   ByRef Names  - Passes out the column names, seperated by SQLite_ColDelim()
;                   Optional Prefix    - Prefix for global variables
;                                        Default: SQLite_
;                   Optional MaxResult - Number of rows to be returned
;                                        Default = -1 : All rows
;                                        Specify 0 to get only the number of rows and columns
;                                        Specify 1 to get column names also 
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_GetTableGlobal(hDB, SQL, ByRef Rows, ByRef Cols, ByRef Names, Prefix = "", MaxResult = -1) {
   Global
   Local pResult := 0, pErr := 0, RC := 0, GetRows := 0
   Local Offset := 0, IRow := 0, Col := ""
   SQLite_LastError(" ")
   Rows := Cols := 0
   Names := ""
   If (Prefix = "")
      Prefix := "SQLite_"
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid database handle " . hDB)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   If MaxResult Is Not Integer
      MaxResult := -1
   If (MaxResult < -1)
      MaxResult := -1
   pResult := pErr := 0
   RC := DllCall("sqlite3\sqlite3_get_table", UInt, hDB, Str, SQL, UIntP, pResult
               , UIntP, Rows, UIntP, Cols, UIntP, pErr, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_get_table failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   If (MaxResult = 0) {
		DllCall("SQLite3\sqlite3_free_table", UInt, pResult, "Cdecl")   
      If (ErrorLevel) {
         SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
         Return False
      }
      Return True
   }
   If (MaxResult = 1)
      GetRows := 0
   Else If (MaxResult > 1) && (MaxResult < Rows)
      GetRows := MaxResult
   Else
      GetRows := Rows
   Offset := 0
   Loop, %Cols% {
      Col := DllCall("MulDiv", UInt, NumGet(pResult+0, Offset), Int, 1, Int, 1, "Str")
      Names .= Col . SQLite_ColDelim()  
      Offset += 4
   }
   StringTrimRight Names, Names, 1
   Loop, %GetRows% {
      IRow := A_Index
      Loop, %Cols% {
         Col := DllCall("MulDiv", UInt, NumGet(pResult+0, Offset), Int, 1, Int, 1, "Str")
         %Prefix%R%IRow%C%A_Index% := Col  
         Offset += 4
      }
   }
   ; Free Results Memory
   DllCall("SQLite3\sqlite3_free_table", UInt, pResult, "Cdecl")   
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_close failed!")
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_FreeGlobalResult()
; Description:      Frees the memory used for global variables created by
;                   SQLite_GetTableGlobal()
; Parameter(s):     Rows - Number of rows
;                   Cols - Number of columns
;                   Optional Prefix - Prefix for global variables
;                                     Default: SQLite_
; Return Value(s):  True
; Author(s):        nick
;===============================================================================
SQLite_FreeGlobalResult(Rows, Cols, Prefix = "") {
   Global
   Local IRow
   If (Prefix = "")
      Prefix := "SQLite_"
   Loop, %Rows% {
      IRow := A_Index
      Loop, %Cols% 
         VarSetCapacity(%Prefix%R%IRow%C%A_Index%, 0)
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_Exec()
; Description:      Executes a non query SQLite statement,
;                   does not handle results.
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   SQL - SQL statement to be executed
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_Exec(hDB, SQL) {
   SQLite_LastError(" ")
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid database handle " . hDB)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   pErr := 0
   RC := DllCall("sqlite3\sqlite3_exec", UInt, hDB, Str, SQL, UInt, 0, UInt, 0
               , UIntP, pErr, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_exec failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQlite_Query()
; Description:      Prepares a single statement SQLite query,
; Parameter(s):     hDB  - DB handle, -1 for last opened DB
;                   SQL  - SQL statement to be executed
; Return Value(s):  On Success - Query handle
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQlite_Query(hDB, SQL) {
   SQLite_LastError(" ")
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid database handle " . hDB)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   hQuery := pSQL := 0
   RC := DllCall("sqlite3\sqlite3_prepare", UInt, hDB, Str, SQL, Int, StrLen(SQL)
               , UIntP, hQuery, UIntP, pSQL, "Cdecl Int")
   If (ErrorLeveL) {
      SQLite_LastError("ERROR: DLLCall sqlite3_prepare failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   _SQLite_CheckQuery(hQuery, hDB)
   _SQLite_CurrentQuery(hQuery)
   Return hQuery
}
;===============================================================================
; Function Name:    SQLite_FetchNames()
; Description:      Provides the column names of a SQLite_Query() based query
; Parameter(s):     hQuery - Query handle, -1 for last prepared query
;                   ByRef Names - Passes out the column names seperated by
;                                 SQLite_ColDelim() 
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_FetchNames(hQuery, ByRef Names) {
   SQLite_LastError(" ")
   Names := ""
   If (hQuery = -1)
      hQuery := _SQLite_CurrentQuery()
   If !(hDB := _SQLite_CheckQuery(hQuery)) {
      SQLite_LastError("ERROR: Invalid query handle " . hQuery)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_column_count", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_column_count failed!")
      Return False
   }
   If (RC < 1) {
      SQLite_LastError("ERROR: Query result is empty!")
      ErrorLevel := _SQLite_ReturnCode("SQLITE_EMPTY")
      Return False
   }
   iCol := 0
   Loop, %RC% {
      Col := DllCall("sqlite3\sqlite3_column_name", UInt, hQuery, Int, iCol, "Cdecl Str")
      If (ErrorLevel) {
         SQLite_LastError("ERROR: DLLCall sqlite3_column_name failed!")
         Return False
      }
      Names .= Col . SQLite_ColDelim()
      iCol++
   }
   If (Names <> "")
      StringTrimRight Names, Names, 1
   Return True
}
;===============================================================================
; Function Name:    SQLite_FetchData()
; Description:      Fetches next row of data from a SQLite_Query() based query
; Parameter(s):     hQuery - Query handle, -1 for last prepared query
;                   ByRef Row - Passes out one row of data seperated by
;                               SQLite_ColDelim() 
; Return Value(s):  On Success - True, -1 on end of data
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_FetchData(hQuery, ByRef Row) {
   Static SQLITE_NULL := 5
   SQLite_LastError(" ")
   Row := ""
   If (hQuery = -1)
      hQuery := _SQLite_CurrentQuery()
   If !(hDB := _SQLite_CheckQuery(hQuery)) {
      SQLite_LastError("ERROR: Invalid query handle " . hQuery)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_step", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_step failed!")
      Return False
   }
   If (RC <> _SQLite_ReturnCode("SQLITE_ROW")) {
      If (RC = _SQLite_ReturnCode("SQLITE_DONE")) {
         Return -1
      }
      SQLite_QueryFinalize(hQuery)
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_data_count", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_data_count failed!")
      Return False
   }
   If (RC < 1) {
      SQLite_LastError("ERROR: Query result is empty!")
      ErrorLevel := _SQLite_ReturnCode("SQLITE_EMPTY")
      Return False
   }
   iCol := 0
   Loop, %RC% {
      Type := DllCall("sqlite3\sqlite3_column_type", UInt, hQuery, Int, iCol, "Cdecl Int")
      If (ErrorLevel) {
         SQLite_LastError("ERROR: DLLCall sqlite3_column_type failed!")
         Return False
      }
      If (Type = SQLITE_NULL) {
         Col := ""
      } Else {
         Col := DllCall("sqlite3\sqlite3_column_text", UInt, hQuery, Int, iCol, "Cdecl Str")
         If (ErrorLevel) {
            SQLite_LastError("ERROR: DLLCall sqlite3_column_text failed!")
            Return False
         }
      }
      Row .= Col . SQLite_ColDelim()
      iCol++
   }
   If (Row <> "")
      StringTrimRight Row, Row, 1
   Return True
}
;===============================================================================
; Function Name:    SQLite_FetchDataGlobal()
; Description:      Fetches next row of data from a SQLite_Query(). Values
;                   ares Stored in global variables %Prefix%C%ColumnIndex%.
; Parameter(s):     hQuery - Query handle, -1 for last prepared query
;                   Optional Prefix - Prefix for glaobal variables
;                                     Default = SQLite_ 
; Return Value(s):  On Success - Number of colums, -1 on end of data
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_FetchDataGlobal(hQuery, Prefix = "") {
   Global
   Static SQLITE_NULL := 5
   Local hDB := 0, RC:= 0, ICol:= 0, Col := ""
   SQLite_LastError(" ")
   If (Prefix = "")
      Prefix := "SQLite_"
   If (hQuery = -1)
      hQuery := _SQLite_CurrentQuery()
   If !(hDB := _SQLite_CheckQuery(hQuery)) {
      SQLite_LastError("ERROR: Invalid query handle " . hQuery)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_step", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_step failed!")
      Return False
   }
   If (RC <> _SQLite_ReturnCode("SQLITE_ROW")) {
      If (RC = _SQLite_ReturnCode("SQLITE_DONE")) {
         Return -1
      }
      SQLite_QueryFinalize(hQuery)
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_data_count", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_data_count failed!")
      Return False
   }
   If (RC < 1) {
      SQLite_LastError("ERROR: Query result is empty!")
      ErrorLevel := _SQLite_ReturnCode("SQLITE_EMPTY")
      Return False
   }
   Loop, %RC% {
      Type := DllCall("sqlite3\sqlite3_column_type", UInt, hQuery, Int, ICol, "Cdecl Int")
      If (ErrorLevel) {
         SQLite_LastError("ERROR: DLLCall sqlite3_column_type failed!")
         Return False
      }
      If (Type = SQLITE_NULL) {
         Col := ""
      } Else {
         Col := DllCall("sqlite3\sqlite3_column_text", UInt, hQuery, Int, ICol, "Cdecl Str")
         If (ErrorLevel) {
            SQLite_LastError("ERROR: DLLCall sqlite3_column_text failed!")
            Return False
         }
      }
      %Prefix%C%A_Index% := Col
      ICol++
   }
   Return RC
}
;===============================================================================
; Function Name:    SQLite_QueryFinalize()
; Description:      Finalizes SQLite_Query() based query,
;                   Query handle will be not valid any more
; Parameter(s):     hQuery - Query handle, -1 for last prepared query
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;==============================================================================
SQLite_QueryFinalize(hQuery) {
   SQLite_LastError(" ")
   If (hQuery = -1)
      hQuery := _SQLite_CurrentQuery()
   If !(hDB := _SQLite_CheckQuery(hQuery)) {
      SQLite_LastError("ERROR: Invalid query handle " . hQuery)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_finalize", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_finalize failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   _SQLite_CheckQuery(hQuery, 0)
   Return True
}
;===============================================================================
; Function Name:    SQLite_QueryReset()
; Description:      Resets SQLite_Query() based query for reuse
; Parameter(s):     hQuery - Query handle, -1 for last prepared query
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;==============================================================================
SQLite_QueryReset(hQuery) {
   SQLite_LastError(" ")
   If (hQuery = -1)
      hQuery := _SQLite_CurrentQuery()
   If !(hDB := _SQLite_CheckQuery(hQuery)) {
      SQLite_LastError("ERROR: Invalid query handle " . hQuery)
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   RC := DllCall("sqlite3\sqlite3_reset", UInt, hQuery, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_finalize failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_SQLiteExe()
; Description:      Executes commands with SQLite3.exe
; Requirements:     Valid path for SQLite3.exe stored in SQLite_EXEPath().
;                   Default: A_ScriptDir . "\SQLite3.EXE"
; Parameter(s):     DBFile - DB filename
;                   Commands - Commands for SQLite3.exe
;                   ByRef Output - Raw output from SQLite3.exe
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_SQLiteExe(DBFile, Commands, ByRef Output) {
   Static InputFile := "~SQLINP.TXT"
   Static OutputFile := "~SQLOUT.TXT"
   SQLite_LastError(" ")
   Output := ""
   SQLiteExe := SQLite_EXEPath()
   If !FileExist(SQLiteExe) {
      SQLite_LastError("ERROR: Unable to find " . SQLiteExe . "!")
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   If !FileExist(DBFile) {
      FileAppend, , %DBFile%
      If (ErrorLevel) {
         SQLite_LastError("ERROR: Unable to create " . DBFile . "!")
         Return False
      }
   }
   If FileExist(InputFile) {
      FileDelete, %InputFile%
      If (ErrorLevel) {
         SQLite_LastError("ERROR: Unable to delete " . InputFile . "!")
         Return False
      }
   }
   If FileExist(OutputFile) {
      FileDelete, %OutputFile%
      If (ErrorLevel) {
         SQLite_LastError("ERROR: Unable to delete " . OutputFile . "!")
         Return False
      }
   }
   If !InStr(Commands, ".output stdout")
      Commands := ".output stdout`n" . Commands
   FileAppend, %Commands%, %InputFile%
   If (ErrorLevel) {
      SQLite_LastError("ERROR: Unable to create " . InputFile . "!")
      Return False
   }
   Cmd = ""%SQLiteExe%" "%DBFile%" < "%InputFile%" > "%OutputFile%""
   RunWait %comspec% /c %Cmd%, , Hide UseErrorLevel
   If (Errorlevel) {
      SQLite_LastError("ERROR: Error occured running " . SQLiteExe . "!")
      Return False
   }
   FileRead, Output, %OutputFile%
   If (ErrorLevel) {
      SQLite_LastError("ERROR: Unable to read " . OutputFile . "!")
      Return False
   }
   If InStr(Output, "SQL error:") || InStr(Output, "Incomplete SQL:") {
      SQLite_LastError("ERROR: " . SQLiteExe . " reported an Error!")
      ErrorLevel := _SQLite_ReturnCode("SQLITE_ERROR")
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_LibVersion()
; Description:      Returns the version number of the SQLite3.dll
; Parameter(s):     None
; Return Value(s):  On Success - Version number
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_LibVersion() {
   SQLite_LastError(" ")
   Version := DllCall("sqlite3\sqlite3_libversion", "Cdecl Str")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_libversion failed!")
      Return False
   }
   Return Version
}
;===============================================================================
; Function Name:    SQLite_LastInsertRowID()
; Description:      Returns the ROWID of the most recent INSERT in the DB
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   ByRef RowID - passes out ROWID
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_LastInsertRowID(hDB, ByRef RowID) {
   SQLite_LastError(" ")
   RowID := 0
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   RC := DllCall("SQLite3\sqlite3_last_insert_rowid", UInt, hDB, "Cdecl UInt")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_last_insert_rowid failed!")
      Return False
   }
   RowID := RC
   Return True
}
;===============================================================================
; Function Name:    SQLite_Changes()
; Description:      Returns the number of DB rows that were changed
;                   by the most recently completed query
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   ByRef Rows - Passes out number of changes
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_Changes(hDB, ByRef Rows) {
   SQLite_LastError(" ")
   Rows := 0
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   RC := DllCall("SQLite3\sqlite3_changes", UInt, hDB, "Cdecl UInt")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_changes failed!")
      Return False
   }
   Rows := RC
   Return True
}
;===============================================================================
; Function Name:    SQLite_TotalChanges()
; Description:      Returns the total number of DB rows that have been
;                   modified, inserted, or deleted since the DB connection
;                   was created
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   ByRef Rows - Passes out the number of changes
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_TotalChanges(hDB, ByRef Rows) {
   SQLite_LastError(" ")
   Rows := 0
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   RC := DllCall("SQLite3\sqlite3_total_changes", UInt, hDB, "Cdecl UInt")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_total_changes failed!")
      Return False
   }
   Rows := RC
   Return True
}
;===============================================================================
; Function Name:    SQLite_ErrMsg()
; Description:      Returns the error message for the most recent
;                   sqlite3_* API call as string
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   ByRef Msg - Passes out the error message
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_ErrMsg(hDB, ByRef Msg) {
   SQLite_LastError(" ")
   Msg := ""
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   RC := DllCall("SQLite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_errmsg failed!")
      Return False
   }
   Msg := RC
   Return True
}
;===============================================================================
; Function Name:    SQLite_ErrCode()
; Description:      Returns the error code for the most recent
;                   sqlite3_* API call as string.
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   ByRef Code - Passes out the error code
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_ErrCode(hDB, ByRef Code)
{
   SQLite_LastError(" ")
   Msg := ""
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   RC := DllCall("SQLite3\sqlite3_errcode", UInt, hDB, "Cdecl UInt")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_errcode failed!")
      Return False
   }
   Code := RC
   Return True
}
;===============================================================================
; Function Name:    SQLite_SetTimeout()
; Description:      Sets timeout for DB's "busy handler"
; Parameter(s):     hDB - DB handle, -1 for last opened DB
;                   Optional Timeout - Timeout [msec]
; Return Value(s):  On Success - True
;                   On Failure - False, check ErrorLevel for details
;                                Additional error message by SQLite_LastError()
; Author(s):        nick
;===============================================================================
SQLite_SetTimeout(hDB, Timeout = 1000) {
   SQLite_LastError(" ")
   Msg := ""
   If (hDB = -1)
      hDB := _SQLite_CurrentDB()
   If !_SQLite_CheckDB(hDB) {
      SQLite_LastError("ERROR: Invalid DB Handle " . hDB . "!")
      Return False
   }
   If Timeout Is Not Integer
      Timeout := 1000
   RC := DllCall("SQLite3\sqlite3_busy_timeout", UInt, hDB, "Cdecl Int")
   If (ErrorLevel) {
      SQLite_LastError("ERROR: DLLCall sqlite3_busy_timeout failed!")
      Return False
   }
   If (RC) {
      SQLite_LastError(DllCall("sqlite3\sqlite3_errmsg", UInt, hDB, "Cdecl Str"))
      ErrorLevel := RC
      Return False
   }
   Return True
}
;===============================================================================
; Function Name:    SQLite_LastError()
; Description:      Provides additional error description for the last error
; Parameter(s):     Optional Error - for internal use only!!!
; Return Value(s):  Error description or ""
; Author(s):        nick
;===============================================================================
SQLite_LastError(Error = "") {
   Static LastError := ""
   If (Error != "")
      LastError := Error
   Return LastError
}
;===============================================================================
; Function Name:    SQLite_DLLPath()
; Description:      Stores/provides the path for SQLite3.dll
;                   SQLite DLL is assumed to be in the scripts directory, if not
;                   you have to call the function with the valid path before any
;                   other function calls!
; Parameter(s):     Optional Path - Path for SQLite3.dll
; Return Value:     Path to SQLite DLL
; Author(s):        nick
;===============================================================================
SQLite_DLLPath(Path = "") {
   Static DLLPath := ""
   If (DLLPath = "")
      DLLPath := A_ScriptDir . "\SQLite3.dll"
   If (Path != "")
      DLLPath := Path
   Return DLLPath
}
;===============================================================================
; Function Name:    SQLite_EXEPath()
; Description:      Stores/provides the path for SQLite3.exe
;                   SQLite EXE is assumed to be in the scripts directory, if not
;                   you have to call the function with the valid path before any
;                   calls on SQLite_SQLite_Exe()!
; Parameter(s):     Optional Path - Path for SQLite3.exe
; Return Value:     Path to SQLite DLL
; Author(s):        nick
;===============================================================================
SQLite_EXEPath(Path = "") {
   Static EXEPath := ""
   If (EXEPath = "")
      EXEPath := A_ScriptDir . "\SQLite3.exe"
   If (Path != "")
      EXEPath := Path
   Return EXEPath
}
;===============================================================================
; Function Name:    SQLite_RowDelim()
; Description:      Stores/provides the row delimiter for results.
;                   Default is LF (`n), to change it call the function with your
;                   favoured delimiter.
; Parameter(s):     Optional Delim - New delimiter
; Return Value:     Row delimiter
; Author(s):        nick
;===============================================================================
SQLite_RowDelim(Delim = "") {
   Static RowDelimiter := "`n"
   If (Delim != "")
      RowDelimiter := Delim
   Return RowDelimiter
}
;===============================================================================
; Function Name:    SQLite_ColDelim()
; Description:      Stores/provides the column delimiter for results.
;                   Default is Pipe (|), to change it call the function with your
;                   favoured delimiter.
; Parameter(s):     Optional Delim - New delimiter
; Return Value:     Column delimiter
; Author(s):        nick
;===============================================================================
SQLite_ColDelim(Delim = "") {
   Static ColDelimiter := "|"
   If (Delim != "")
      ColDelimiter := Delim
   Return ColDelimiter
}
;===============================================================================
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; Following functions are for internal use only !!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;===============================================================================
; Function Name:    _SQLite_ModuleHandle()
; Description:      Stores/provides DLL's module handle
; Author(s):        nick
;===============================================================================
_SQLite_ModuleHandle(Handle = "") {
   Static ModuleHandle := ""
   If (Handle != "")
      ModuleHandle := Handle
   Return ModuleHandle
}
;===============================================================================
; Function Name:    _SQLite_CurrentDB()
; Description:      Stores\provides the current (last opened) DB handle
; Author(s):        nick
;===============================================================================
_SQLite_CurrentDB(hDB = "") {
   Static CurrentDB := 0
   If (hDB != "")
      CurrentDB := hDB
   Return CurrentDB
}
;===============================================================================
; Function Name:    _SQLite_CheckDB()
; Description:      Stores\frees\validates the given DB handle
; Author(s):        nick
;===============================================================================
_SQLite_CheckDB(hDB, Action = "") {
   Static ValidHandles := "|"
   If hDB Is Not Integer
      Return False
   If (hDB = 0)
      Return False
   If (Action = "Store") {
      If !InStr(ValidHandles, "|" . hDB . "|")
         ValidHandles .= hDB . "|"
      Return True
   }
   If (Action = "Free") {
      If InStr(ValidHandles, "|" . hDB . "|")
         StringReplace, ValidHandles, ValidHandles, |%hDB%|, |
      Return True
   }
   Return InStr(ValidHandles, "|" . hDB . "|")
}
;===============================================================================
; Function Name:    _SQLite_CurrentQuery()
; Description:      Stores\provides the current (last prepared) query handle
; Author(s):        nick
;===============================================================================
_SQLite_CurrentQuery(hQuery = "") {
   Static CurrentQuery := 0
   If (hQuery != "")
      CurrentQuery := hQuery
   Return CurrentQuery
}
;===============================================================================
; Function Name:    _SQLite_CheckQuery()
; Description:      Stores\frees\validates the given query handle
; Author(s):        nick
;===============================================================================
_SQLite_CheckQuery(hQuery, hDB = "") {
   Static ValidQueries := "|"
   If hQuery Is Not Integer
      Return False
   If (hQuery = 0)
      Return False
   If (hDB = 0) {
      ValidQueries := RegExReplace(ValidQueries, "\|" . hQuery . ":[^|]+\|", "|")
      Return True
   }
   If (hDB != "") {
      If !InStr(ValidQueries, "|" . hQuery . ":" . hDB . "|")
         ValidQueries .= hQuery . ":" . hDB . "|"
      Return True
   }
   Return RegExMatch(ValidQueries, "\|" . hQuery . ":([^|]+)\|", M) ? M1 : False
}
;===============================================================================
; Function Name:    _SQLite_ReturnCode(RC)
; Description:      Returns numeric RC for symbolic RC
; Author(s):        nick
;===============================================================================
_SQLite_ReturnCode(RC) {
   Static SQLITE_OK         := 0    ; Successful result 
        , SQLITE_ERROR      := 1    ; SQL error or missing database 
        , SQLITE_INTERNAL   := 2    ; NOT USED. Internal logic error in SQLite 
        , SQLITE_PERM       := 3    ; Access permission denied 
        , SQLITE_ABORT      := 4    ; Callback routine requested an abort 
        , SQLITE_BUSY       := 5    ; The database file is locked 
        , SQLITE_LOCKED     := 6    ; A table in the database is locked 
        , SQLITE_NOMEM      := 7    ; A malloc() failed 
        , SQLITE_READONLY   := 8    ; Attempt to write a readonly database 
        , SQLITE_INTERRUPT  := 9    ; Operation terminated by sqlite3_interrupt()
        , SQLITE_IOERR      := 10   ; Some kind of disk I/O error occurred 
        , SQLITE_CORRUPT    := 11   ; The database disk image is malformed 
        , SQLITE_NOTFOUND   := 12   ; NOT USED. Table or record not found 
        , SQLITE_FULL       := 13   ; Insertion failed because database is full 
        , SQLITE_CANTOPEN   := 14   ; Unable to open the database file 
        , SQLITE_PROTOCOL   := 15   ; NOT USED. Database lock protocol error 
        , SQLITE_EMPTY      := 16   ; Database is empty 
        , SQLITE_SCHEMA     := 17   ; The database schema changed 
        , SQLITE_TOOBIG     := 18   ; String or BLOB exceeds size limit 
        , SQLITE_CONSTRAINT := 19   ; Abort due to constraint violation 
        , SQLITE_MISMATCH   := 20   ; Data type mismatch 
        , SQLITE_MISUSE     := 21   ; Library used incorrectly 
        , SQLITE_NOLFS      := 22   ; Uses OS features not supported on host 
        , SQLITE_AUTH       := 23   ; Authorization denied 
        , SQLITE_FORMAT     := 24   ; Auxiliary database format error 
        , SQLITE_RANGE      := 25   ; 2nd parameter to sqlite3_bind out of range 
        , SQLITE_NOTADB     := 26   ; File opened that is not a database file 
        , SQLITE_ROW        := 100  ; sqlite3_step() has another row ready 
        , SQLITE_DONE       := 101  ; sqlite3_step() has finished executing 
   Return RegExMatch(RC, "^SQLITE_[A-Z]+$") ? %RC% : ""
}