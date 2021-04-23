#NoEnv

/*
DataToCode(Code,"When on board H.M.S. 'Beagle,' as naturalist, I was much struck with certain facts in the distribution of the inhabitants of South America, and in the geological relations of the present to the past inhabitants of that continent.  These facts seemed to me to throw some light on the origin of species--that mystery of mysteries, as it has been called by one of our greatest philosophers.")
MsgBox % Clipboard := Code
*/

DataToCode(ByRef Code,ByRef Data,Length = "")
{
 ;initialize variables
 CharSet := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
 If (Length = "") ;autodetect length if it was not given
  Length := StrLen(Data) << !!A_IsUnicode ;make sure the length is the number of bytes, not the number of characters

 ;convert data to Base64
 VarSetCapacity(EncodedData,Ceil(Length / 3) << 2), Index := 0, pData := &Data ;set the size of the Base64 EncodedData, initialize variables
 Loop, % EncodedDataLength := Length // 3 ;process 3 bytes per iteration
  Temp1 := (*(pData ++) << 16) | (*(pData ++) << 8) | *(pData ++), EncodedData .= SubStr(CharSet,((Temp1 >> 18) & 63) + 1,1) . SubStr(CharSet,((Temp1 >> 12) & 63) + 1,1) . SubStr(CharSet,((Temp1 >> 6) & 63) + 1,1) . SubStr(CharSet,(Temp1 & 63) + 1,1) ;convert the 3 bytes to 4 Base64 characters
 Temp2 := Mod(Length,3), EncodedDataLength *= 4 ;determine the number of characters left over, get the length of the encoded data
 If (Temp2 > 0)
 {
  Temp1 := (*pData) << 10, EncodedData .= SubStr(CharSet,((Temp1 >> 12) & 63) + 1,1)
  If (Temp2 = 1)
   EncodedData .= SubStr(CharSet,((Temp1 >> 6) & 63) + 1,1), EncodedDataLength += 2
  Else ;(Temp2 = 2)
   Temp1 |= *(++ pData) << 2, EncodedData .= SubStr(CharSet,((Temp1 >> 6) & 63) + 1,1) . SubStr(CharSet,(Temp1 & 63) + 1,1), EncodedDataLength += 3
 }

 ;generate code
 MaxLineLength := 16383 ;the maximum length of each line of data
 MaxLineLength -= 5 ;reduce the maximum line length to compensate for the line overhead
 Temp1 := Ceil(EncodedDataLength / MaxLineLength) ;find the number of lines needed
 Code := "", VarSetCapacity(Code,EncodedDataLength + (Temp1 * 6)), Index := 1 ;set the capacity of the data, initialize the index
 Loop, %Temp1%
  Code .= "e.=""" . SubStr(EncodedData,Index,MaxLineLength) . """`n", Index += MaxLineLength
 Code := "RetrieveData(ByRef d){`ne:="""",VarSetCapacity(e," . EncodedDataLength . "),VarSetCapacity(d," . Length . ")`n" . Code . "c:=""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"",t:=(SubStr(e,0)=""="")+(SubStr(e,-1,1)=""="")`nIf t>0`ne:=SubStr(e,1,-t)`nl:=StrLen(e),b:=Ceil(l/4*3),VarSetCapacity(d,b),i:=1,p:=0`nLoop,% l//4`nt:=InStr(c,SubStr(e,i++,1),1)-1<<18|InStr(c,SubStr(e,i++,1),1)-1<<12|InStr(c,SubStr(e,i++,1),1)-1<<6|InStr(c,SubStr(e,i++,1),1)-1,NumPut(t>>16|(t>>8&255)<<8|(t&255)<<16,d,p,""UInt""),p+=3`nl&=3`nIf l>0`nt:=InStr(c,SubStr(e,i,1),1)-1<<18|InStr(c,SubStr(e,i+1,1),1)-1<<12,NumPut(t>>16,d,p,""UChar""),l=3 ? (t|=InStr(c,SubStr(e,i+2,1),1)-1<<6,NumPut(t>>8&255,d,p+1,""UChar""))`nReturn,b`n}"
}