; by infogulch. see: http://www.autohotkey.com/forum/viewtopic.php?t=75679

random_number( min = 0, max = 1, round = "default" ) {
/*
 *  Generates and returns a random number from min to max optionally
 *  rounded to a whole number.
 *  
 *  If all parameters are omitted, returns a random decimal from 0-1 
 *  
 *  If min and max are specified other than 0 and 1 respectively,
 *  then the result will be rounded by default.
 *  
 *  This uses a cryptographically secure random number generator 
 *  and uses the maximum number of significant bits allowed 
 *  in a double for the greatest precision.
 */
    round := round == "default" ? !(min==0 && max==1) : round
    ; 52: max precision of a double. 2 ** 52 - 1 == 0xfffffffffffff
    random_buffer(52, buff)
    ; produce a random decimal from 0-1; modify for min, max
    ret := NumGet(buff, 0, "UInt64") / 0xfffffffffffff * (max - min) + min
    return round ? round(ret) : ret
}

random_buffer(len_bits, ByRef buff) {
/*
 *  Generates len_bits random bits and returns the result in buff.
 *  Cryptographically secure, see: http://msdn.microsoft.com/en-us/library/aa379942(v=VS.85).aspx
 *  
 *  This does NOT guarantee that any number of high bits are not 0.
 *  I.e. it is entirely possible that you specify 40 bits, but the
 *  highest 1-bit is actually 35. 
 *  
 *  It actually generates ceil(len_bits/8) __bytes__ of random data, 
 *  and then truncates the top byte to the specified length in bits.
 */
    ; PROV_RSA_FULL  := 1, CRYPT_VERIFYCONTEXT  :=  0xF0000000, CRYPT_SILENT  :=  0x40
    hProv := 0
    if !DllCall("advapi32\CryptAcquireContext", "ptr*", hProv, "uint", 0, "uint", 0, "uint", 1, "uint", 0xF0000000 | 0x40)
    {
        MsgBox Acquiring Context Failed %ErrorLevel%, %A_LastError%
        return 0
    }
    len_bytes := Ceil(len_bits/8) ; CryptGenRandom accepts bytes, not bits
    VarSetCapacity(buff, 65), VarSetCapacity(buff, 0) ; ensure buff is actually unallocated
    VarSetCapacity(buff, len_bytes)
    if !DllCall("advapi32\CryptGenRandom", "ptr", hProv, "int", len_bytes, "ptr", &buff)
    {
        MsgBox CryptGenRandom Failed %ErrorLevel%, %A_LastError%
        return 0
    }
    
    ; truncate the highest bits to len_bits
    NumPut(0xff >> 7-mod(len_bits-1, 8) & NumGet(buff, len_bytes-1, "uchar"), buff, len_bytes-1, "uchar")
    
    DllCall("advapi32\CryptReleaseContext", "ptr", hProv, "uint", 0)
    return 1
}