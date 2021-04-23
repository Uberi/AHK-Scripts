;; Messy script to test EasyCOM.dll and AHK Wrapper functions
;; For use with easycom.ahk v0.002

#NoEnv

#Include easycom.ahk

LoadEasyCOM()

;;; Custom object, loaded from dll ;;;

;objTestObj := CreateObjectFromDll("..\testobj\TestObj.dll"
;							, "{4760F41F-7D56-4869-AFA9-5210675D9BDF}")
;iRet := InvokeEx(objTestObj, "RefArgs()"
;							, COM_STR | COM_BYREF, s 
;							, COM_INT | COM_BYREF, i)
;Msgbox % s "  " i
;
;ReleaseObject(objTestObj)

;;; Speech API ;;;

objSpVoice := CreateObject("SAPI.SpVoice")
iRet := Invoke(objSpVoice, "Speak()", "This is a test" , 0) 
ReleaseObject(objSpVoice)

;;; FileSystemObject ;;;

objFSO := CreateObject("Scripting.FileSystemObject")

iRet := Invoke(objFSO, "FolderExists()", "C:\WINDOWS")

objTxtFile := InvokeEx(objFSO, "OpenTextFile()"
				, COM_STR, "test.txt"
				, COM_INT, 2 ; for writing
				, COM_INT, True) ; create file
				
Invoke(objTxtFile, "WriteLine()", "Hello thar!")

iRet := Invoke(objFSO, "FileExists()", "test.txt")

If (iRet <> 1)
	Msgbox % "Where'd the file go??"

Invoke(objTxtFile, "Close()")
 
ReleaseObject(objTxtFile)


objTxtFile := InvokeEx(objFSO, "OpenTextFile()"
				, COM_STR, "test.txt"
				, COM_INT, 1 ; for writing
				, COM_INT, False) ; create file
				
sRet := Invoke(objTxtFile, "ReadLine()")

If (sRet <> "Hello thar!")
	Msgbox % "What happened with the file contents?"

Msgbox % sRet

Invoke(objTxtFile, "Close()")
 
ReleaseObject(objTxtFile)



objDrive := Invoke(objFSO, "GetDrive()", "c:")
					
iRet := Invoke(objDrive, "FreeSpace")

Msgbox % "Free space on drive C: " iRet

ReleaseObject(objDrive)

objFile := Invoke(objFSO, "GetFile()", "test.txt")
					
Invoke(objFile, "Delete()")

ReleaseObject(objFile)

ReleaseObject(objFSO)

;;; Excel ;;;

; Of course the script will fail here if Excel isn't installed
objXL := CreateObject("Excel.Application")

Invoke(objXL, "Visible=", 1)

objWrkBks := Invoke(objXL, "Workbooks")
objWB := Invoke(objWrkBks, "Add()")
objWS := Invoke(objWB, "ActiveSheet")
Msgbox % Invoke(objWS, "Name")

Loop, 100
{
	;; Invoke() doesn't work with the 'Cells' property (exception 0x800A03EC)
	;; because the second argument can either be column index (integer),
	;; or column name (string, such as "A")
	;; Therefore InvokeEx() must be used
	;objCell := Invoke(objWS, "Cells", A_Index, 1) <-- fails
	;objCell := Invoke(objWS, "Cells", A_Index, "A") <-- but this works
	objCell := InvokeEx(objWS, "Cells"
						, COM_INT, A_Index
						, COM_INT, 1)
	Invoke(objCell, "Value=", "Happy!")
	sVal := Invoke(objCell, "Value")
	If (sVal <> "Happy!") 
		Msgbox % "Not happy!"
	ReleaseObject(objCell)
	
	objCell := InvokeEx(objWS, "Cells"
						, COM_INT, A_Index
						, COM_INT, 2)
	Invoke(objCell, "Value=", 1000.34567)
	ReleaseObject(objCell)
}


ReleaseObject(objWS)
ReleaseObject(objWB)
ReleaseObject(objWrkBks)
;Invoke(objXL, "Quit()")
ReleaseObject(objXL)


UnloadEasyCOM()
