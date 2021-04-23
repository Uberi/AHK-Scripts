#NoEnv

/*
Copyright 2011-2012 Anthony Zhang <azhang9@gmail.com>

This file is part of AutoHotkey.net Website Generator. Source code is available at <https://github.com/Uberi/AutoHotkey.net-Website-Generator>.

AutoHotkey.net Website Generator is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

;opens an FTP session with AutoHotkey.net
AutoHotkeySiteOpenSession()
{
    global AutoHotkeyNetUsername, AutoHotkeyNetPassword, hWinINet, hInternet, hConnection
    hWinINet := DllCall("LoadLibrary","Str","wininet.dll")
    hInternet := DllCall("wininet\InternetOpen","Str","AutoHotkey","UInt",0,"UInt",0,"UInt",0,"UInt",0)
    If !hInternet
        Return, True
    hConnection := DllCall("wininet\InternetConnect","UInt",hInternet,"Str","autohotkey.net","UInt",21,"Str",AutoHotkeyNetUsername . "@autohotkey.net","Str",AutoHotkeyNetPassword,"UInt",1,"UInt",0,"UInt",0)
    If !hConnection
        Return, True
    Return, False
}

;uploads a file to AutoHotkey.net
AutoHotkeySiteUpload(LocalFile,RemoteFile)
{
    global hConnection
    StringReplace, RemoteFile, RemoteFile, \, /, All
    If !DllCall("wininet\FtpPutFile","UInt",hConnection,"Str",LocalFile,"Str",RemoteFile,"UInt",0,"UInt",0)
        Return, True
    Return, False
}

;creates a directory at AutoHotkey.net
AutoHotkeySiteCreateDirectory(Directory)
{
    global hConnection
    UPtr := A_PtrSize ? "UPtr" : "UInt", VarSetCapacity(FindData,48) ;initialize variables
    Loop, Parse, Directory, \/ ;loop over each directory name in the path
    {
        ;set the proper path
        If A_Index = 1
            Path := A_LoopField
        Else
            Path .= "/" . A_LoopField

        ;create the directory if it does not already exist
        If !(DllCall("wininet\FtpFindFirstFile","UInt",hConnection,UPtr,&Path,UPtr,&FindData,UPtr,0,UPtr,0) && (NumGet(FindData,0,"UInt") & 0x10)) ;path not found, or found path did not have the directory attribute
        {
            If !DllCall("wininet\FtpCreateDirectory","UInt",hConnection,UPtr,&Path) ;failed to create directory
                Return, True
        }
    }
    Return, False
}

;closes the previously opened FTP session
AutoHotkeySiteCloseSession()
{
    global hWinINet, hInternet, hConnection
    UPtr := A_PtrSize ? "UPtr" : "UInt"
    If !DllCall("wininet\InternetCloseHandle","UInt",hConnection)
        Return, True
    If !DllCall("wininet\InternetCloseHandle","UInt",hInternet)
        Return, True
    DllCall("FreeLibrary",UPtr,hWinINet)
    Return, False
}