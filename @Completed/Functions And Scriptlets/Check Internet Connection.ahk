#NoEnv

CheckInternetConnection()
{
 Return, DllCall("wininet\InternetCheckConnection","UInt",0,"Int",1,"Int",0)
}