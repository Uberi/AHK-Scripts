#NoEnv
#Warn, LocalSameAsGlobal, Off
SetWorkingDir %A_ScriptDir% 
#Include <DBA>

global initialSQL := "SELECT * FROM Test"
global databaseType := ""
global currentDB := null ; current db connection

connectionStrings := A_ScriptDir "\Test\TestDB.sqlite||Server=localhost;Port=3306;Database=test;Uid=root;Pwd=toor;|Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" A_ScriptDir "\Test\TestDB.mdb"

Gui, +LastFound +OwnDialogs
Gui, Margin, 10, 10


Gui, Add, Text, x10 w100 h20 0x200 , DB Connection, 
Gui, Add, ComboBox, x+0 ym w400 vddDatabaseConnection, % connectionStrings
Gui, Add, DropDownList, yp xp+420 w100 vddDatabaseType, % ArrayToGuiString(DBA.DataBaseFactory.AvaiableTypes, true)
Gui, Add, Button, gReConnect yp xp+140 w80, .connect

Gui, Add, Text, x10 yp+35  w100 h20 0x200 vTX, SQL statement:
Gui, Add, ComboBox, x+0  w520 vSQL Sort, %initialSQL%||
Gui, Add, Button, yp xp+560 w80 hp vRun gRunSQL Default, .run


Gui, Add, Text, xm h20 w100 0x200, Table name:
Gui, Add, GroupBox, xm w780 h330 , Results
Gui, Add, ListView, xp+10 yp+18 w760 h300 vResultsLV,

Gui, Add, Button, gTestRecordSetClick, [Test RecordSet]
Gui, Add, Button, gTestInsertClick, [Test Insert]
Gui, Add, Button, gTestBinaryBlobClick, [Test Insert Binary Blob]

Gui, Add, StatusBar,
Gui, Show, , sqlite test oop

return



ReConnect:
	Gui, submit, NoHide
	DoTestInserts := true
	
	databaseType := ddDatabaseType
	connectionString := ddDatabaseConnection

	try {
		currentDB := DBA.DataBaseFactory.OpenDataBase(databaseType, connectionString)
		
		if(DoTestInserts)
		{
			try {
				if(databaseType = "SQLite"){
					CreateTestDataSQLite(currentDB)
				}else if(databaseType = "mySQL"){
					CreateTestDataMySQL(currentDB)
				}
			}catch e
				MsgBox,16, Error, % "Failed to create Test Data.`n`n" ExceptionDetail(e)
		}
	} catch e
		MsgBox,16, Error, % "Failed to create connection. Check your Connection string and DB Settings!`n`n" ExceptionDetail(e)


	GoSub, RunSQL

return


TestRecordSetClick:
	Gui, submit, NoHide
	if(IsEnsureConnection())
	{
		TestRecordSet(currentDB, SQL)
	}
return

TestBinaryBlobClick:
	Gui, submit, NoHide
	if(IsEnsureConnection())
	{
		TestBinaryBLob(currentDB)
	}
return

TestInsertClick:
	if(IsEnsureConnection())
	{
		try {
			TestInsert(currentDB)
		}catch e
			MsgBox,16, Error, % "Test of Recordset Insert failed!`n`nException Detail:`n" e.What "`n"  e.Message
	}
return


GuiClose:
	if(IsObject(currentDB))
		currentDB.Close()
Exitapp

;=======================================================================================================================
; Execute SQL-Statement
;=======================================================================================================================
RunSQL:
	GuiControlGet, SQL
	RunSQL(SQL)
return


RunSQL(SQL){
	if(IsObject(currentDB))
	{
		state := ""
		if(Trim(SQL) == "")
		{
		   SB_SetText("No SQL entered")
		   Return
		}
		
		try {
			rs := currentDB.OpenRecordSet(SQL)
			if(IsObject(rs))
				ShowRecordSet("ResultsLV", rs)
		} catch e {
			MsgBox,16, Error, % "OpenRecordSet Failed.`n`n" ExceptionDetail(e) ;state := "!# " e.What " " e.Message
		}


		if(state != "")
			SB_SetText(state)
	}else {
		MsgBox,16, Error, No Connection avaiable. Please connect to a db first!
	}
}

IsEnsureConnection( dialoge=1 ){
	connected := (currentDB != null)
	if(dialoge && !connected){
		MsgBox,64, No Connection, You must connect to a DB to use this command.
	}
	
	return connected
}


TestInsert(mydb){

	;Table Layout: Name, Fname, Phone, Room
	
	record := {}
	record.Name := "Yutini_" RandomChars(5)
	record.Fname := "Wayland"
	record.Phone := "1337"
	record.Room := "No idea for what this is good for"
	
	mydb.Insert(record, "Test") ; insert a single record into table test
	
	
	/*
	* Test inserting multiple values
	* this is normaly faster than calling Insert for each element individually
	*/
	
	records := new Collection()
	
	record := {}
	record.Name := "Hans_" RandomChars(5)
	record.Fname := "Meier"
	record.Phone := "93737337"
	record.Room := "wtf is room!? :D"
		
	record2 := {}
	record2.Name := "Marta_" RandomChars(5)
	record2.Fname := "Heilia"
	record2.Phone := "1234111"
	record2.Room := "Don't be that strange!"	
	
	records.Add(record)
	records.Add(record2)	
	
	mydb.InsertMany(records, "Test")
	
	RunSQL("SELECT * FROM Test")
}

TestBinaryBLob(db){
	static imagePath := A_scriptdir "\Test\boom.png"
	
	if(!IsObject(db))
		throw Exception("ArgumentExcpetion: db must be a DBA DataBase Object")
	
	imgBuffer := MemoryBuffer.CreateFromFile(imagePath)
	
	MsgBox % imgBuffer.ToString()

	record := {}
	record.Name  := "SuperTest"
	record.Image := imgBuffer
		
	db.Insert(record, "TestImage") ; Insert this record into Table 'ImageTest'
	imgBuffer.Free()
	
	
	TestReadBinaryBlobAndWriteToDisk(db)
}


TestReadBinaryBlobAndWriteToDisk(db){
	static imagePath2 := A_scriptdir "\Test\boomFromDb.png"
	
	FileDelete, % imagePath2
	
	record := db.QueryRow("Select * from  TestImage WHERE Name = 'SuperTest'")
	
	if(IsObject(record))
	{
		/*
		* All binary BLOBs are wrapped automatically into a MemoryBuffer.
		* The record.Image is therefore an Instance of a MemoryBuffer
		*/
		
		; write the binary blob data into a new file
		record.Image.WriteToFile(imagePath2) ; write the buffer into a file - we get a valid png again :)
		run, % imagePath2
	}else
		MsgBox,16, no such record, cant find 'SuperTest' in TestImage
	
	
}

TestRecordSet(db, sQry){
	rs := db.OpenRecordSet(sQry)
	
	while(!rs.EOF){	
		name := rs["Name"] 
		phone := rs["Phone"]

		MsgBox, % (4 | 0x40), Showing record Nr %A_Index%,  %name% %phone%`n`n`nDo you want to display the next record?
		IfMsgBox, No
			break
		rs.MoveNext()
	}
	
	rs.Close()
	MsgBox done :)
}

/*
* Show all records in the recordSet in the given ListView
*/
ShowRecordSet( LVname, resultSet ){
	
	GuiControl, -ReDraw, %LVname%
	Gui, ListView, %LVname%

	if(!is(resultSet, DBA.RecordSet))
		throw Exception("RecordSet Object expected! resultSet was of type: " typeof(resultSet) ,-1)
	
	; Delete existing data
	LV_Delete()
	Loop, % LV_GetCount("Column")
	   LV_DeleteCol(1)
	   

	; fetch new data
	columns := resultSet.getColumnNames()
	columnCount := columns.Count()
	
	for each, colName in columns
		LV_InsertCol(A_Index,"", colName)
	
	
	while(!resultSet.EOF){	
		rowNum := LV_Add("", "")
		Loop, % columnCount
			LV_Modify(rowNum, "Col" . A_index, resultSet[A_index])
		resultSet.MoveNext()
	}
	
	LV_ModifyCol()
	GuiControl, +ReDraw, %LVname%
	
	
	SB_SetText("Displaying " rowNum " Rows")
}



CreateTestDataSQLite(db){
	
	try
	{
		SB_SetText("Create Test Data")
		
		db.Query("CREATE TABLE Test (Name, Fname, Phone, Room, PRIMARY KEY(Name ASC, FName ASC));")
		
		db.Query("CREATE TABLE TestImage (Name, Image BLOB, PRIMARY KEY(Name ASC));")
		
		InsertTestData(db)
	}catch{
		;// ignore
	}
}

CreateTestDataMySQL(db){
	
	try
	{
		SB_SetText("Create Test Data")

		createTableSQL =
		(Ltrim
				CREATE TABLE IF NOT EXISTS Test (
				  Name VARCHAR(250),
				  Fname VARCHAR(250),
				  Phone VARCHAR(250),
				  Room VARCHAR(250),
				  PRIMARY KEY (Name, Fname)
				`)
		)		
		db.Query(createTableSQL)

		InsertTestData(db)
		
	}catch e{
		; // if there where already test data
		; // we ignore the duplicate key exception.
	}
}

InsertTestData(db)
{
	db.BeginTransaction()
	{
		_SQL := "('Name#', 'Fname#', 'Phone#', 'Room#')"
		sQry := "INSERT INTO Test (Name, Fname, Phone, Room)`nVALUES`n"
		i := 1
		
		Loop, 500 {
		   StringReplace, cSQL, _SQL, #, %i%, All
			sQry .= cSQL ",`n"
		   i++
		}
		
		sQry := substr(sQry,1,StrLen(sQry)-2) ";"
		
		
		if (!db.Query(sQry)) {
			  Msg := "ErrorLevel: " . ErrorLevel . "`n" . SQLite_LastError() "`n`n" sQry
			  FileAppend, %Msg%, sqliteTestQuery.log
			  throw Exception("Query failed: " Msg)
			 ; MsgBox, 0, Query failed, %Msg%
		}
		

	}db.EndTransaction()
}



ArrayToGuiString(items , bSelectFirst){
	str := ""
	for each, item in items
		str .= item "|" ((bSelectFirst && A_Index == 1) ? "|" : "")
	return str
}


RandomChars(count, str=""){
	loop % count
	{
		Random, asc, 0x61, 0x7A
		str .= chr(asc)
	}
	return str
}