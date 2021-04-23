; Get the remote Sha1 hash
remoteURL := "http://www.autohotkey.net/xfm/api/sha1/?f=DerRaphael/tmp/demoScript.ahk"
URLDownloadToFile, % remoteURL, temp.dat
FileRead, remoteSha1, temp.dat

; Compute the local Sha1 hash
FileRead, sData, % A_ScriptName
LocalSha1 := hash( sData, StrLen( sData ), 4 )

if ( LocalSha1 != RemoteSha1 )
{
	MsgBox,16,Oh noes ... ,Remote File is different to local copy!
}
Else
{
	MsgBox,48,Happy happy! Joy Joy!,Remote File is same as local copy
}

; Laszlo: http://www.autohotkey.com/forum/topic17853.html#113252
HASH(ByRef sData, nLen, SID = 3) { ; SID = 3: MD5, 4: SHA1
   DllCall("advapi32\CryptAcquireContextA", UIntP,hProv, UInt,0, UInt,0, UInt,1, UInt,0xF0000000)
   DllCall("advapi32\CryptCreateHash", UInt,hProv, UInt,0x8000|0|SID, UInt,0, UInt,0, UIntP, hHash)

   DllCall("advapi32\CryptHashData", UInt,hHash, UInt,&sData, UInt,nLen, UInt,0)

   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,0, UIntP,nSize, UInt,0)
   VarSetCapacity(HashVal, nSize, 0)
   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,&HashVal, UIntP,nSize, UInt,0)

   DllCall("advapi32\CryptDestroyHash", UInt,hHash)
   DllCall("advapi32\CryptReleaseContext", UInt,hProv, UInt,0)

   IFormat := A_FormatInteger
   SetFormat Integer, H
   Loop %nSize%
      sHash .= SubStr(*(&HashVal+A_Index-1)+0x100,-1)
   SetFormat Integer, %IFormat%
   Return sHash
}