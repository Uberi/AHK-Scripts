;AHK v1
#NoEnv

/*
Timestamp := GetUnixTimestamp()
MsgBox %Timestamp%
Temp1 := FromUnixTimestamp(Timestamp)
MsgBox, %Temp1%
MsgBox, % ToUnixTimestamp(Temp1)
*/

GetUnixTimestamp()
{
 CurrentTime := A_NowUTC ;unix time is always based on Coordinated Universal Time
 EnvSub, CurrentTime, 19700101000000, Seconds ;seconds since 01/01/1970
 Return, CurrentTime
}

ToUnixTimestamp(Timestamp)
{
 EnvSub, TimeStamp, 19700101000000, Seconds ;seconds since 01/01/1970
 Return, TimeStamp
}

FromUnixTimestamp(UnixTimestamp)
{
 Timestamp := "19700101000000"
 EnvAdd, Timestamp, UnixTimestamp, Seconds ;add seconds to the date
 Return, Timestamp
}