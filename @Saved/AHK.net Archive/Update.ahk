/*
[AutoHotkey Updater]
version = 0.007
*/

KeepBackup = 0 ; Set to 1 to keep old EXE as <filename>.<version>.bak.
SelfUpdate = 1 ; Set to 0 to prevent the script from checking for updates to itself.

; Alternate update sources should use the following structure:
;   %UpdateURL%/Update.ahk  -- [optional] newer version of this script
;   %UpdateURL%/version.txt -- text file: ONLY a version number
;   %UpdateURL_bin%         -- zip file: AutoHotkey.exe and AutoHotkeySC.bin;
;                       {suffix} is replaced with "w", "a" or "w64" as appropriate.
;   %UpdateURL_chm%         -- zip file: AutoHotkey.chm
;   %UpdateURL_a2e%         -- zip file: Ahk2Exe.exe
UpdateURL = http://www.autohotkey.net/~Lexikos/AutoHotkey_L
UpdateURL_bin = %UpdateURL%/AutoHotkey_L{suffix}.zip
UpdateURL_chm = %UpdateURL%/AutoHotkey_L_Help.zip
UpdateURL_a2e = %UpdateURL%/Ahk2Exe_L.zip

TempDir = %A_Temp%\AhkUpdate%A_Now%


#NoEnv
#Include *i %A_ScriptDir%\UpdateDebug.ahk

if 0 > 0
{
    if IsFunc("_" %True%) ; Recursive call, used to swap exes or elevate the process.
    {
        prms := Object()
        Loop %0%
            prms.Insert(%A_Index%)
        func := prms.Remove(1), _%func%(prms*)
        ExitApp
    }
    else if 1 = SuppressUpToDate ; Suppress "AutoHotkey is up to date" message.
        SuppressUpToDate := true
}

if !A_IsCompiled && SelfUpdate
{
    ; First, check for a newer version of this script.
    URLDownloadToFile %UpdateURL%/Update.ahk, %A_Temp%\Update.ahk
    IniRead rver, %A_Temp%\Update.ahk, AutoHotkey Updater, version, %A_Space%
    IniRead lver, %A_ScriptFullPath%,  AutoHotkey Updater, version, %A_Space%
    if (lver < rver)
    {
        MsgBox 3, AutoHotkey Updater,
        (LTrim Join`s
        A newer version of this script is available.  It is recommended
        that you use the updated version of the script to install further
        updates.  *** WARNING: If you click yes, any modifications you
        have made to this script will be lost. ***
        `n`nUse the updated script?
        )
        ifMsgBox Yes
        {
            _SelfUpdate(A_Temp "\Update.ahk")
            ExitApp
        }
        ifMsgBox Cancel
        {
            FileDelete %A_Temp%\Update.ahk
            ExitApp
        }
    }
    FileDelete %A_Temp%\Update.ahk
}

if A_OSVersion in WIN_2000,WIN_NT4,WIN_95,WIN_98,WIN_ME ; Only WIN_2000 should actually be possible.
{
    MsgBox 16, AutoHotkey Updater, Windows XP or later is required.
    ExitApp
}

FileCreateDir %TempDir%

; Retrieve latest version number.
URLDownloadToFile %UpdateURL%/version.txt, %TempDir%\version.txt
FileRead version, %TempDir%\version.txt


if (version <= A_AhkVersion)
    && !RegExMatch(A_AhkVersion, "^\Q" version "\E-")  ; Quick hack for beta -> final version.
{
    if !SuppressUpToDate
        MsgBox 64, AutoHotkey Updater,
        (Ltrim
        AutoHotkey is up to date.
        
        Installed version:`t%A_AhkVersion%
        Latest version:`t%version%
        )
    FileRemoveDir %TempDir%, 1
    ExitApp
}

MsgBox 68, AutoHotkey Update Available,
(
An update for AutoHotkey is available.

Installed version:`t%A_AhkVersion%
Latest version:`t%version%

Would you like to install it now?
)
ifMsgBox No
{
    FileRemoveDir %TempDir%, 1
    ExitApp
}

; Determine the appropriate package.
if A_PtrSize = 8
    suffix = w64 ; Above already verified A_IsUnicode is true in this case.
else if A_IsUnicode
    suffix = w
else
    suffix = a
StringReplace UpdateURL_bin, UpdateURL_bin, {suffix}, %suffix%

; Download binaries.
errors     := !Download(UpdateURL_bin, TempDir "\bin.zip")
; Download help file.
ifExist %A_AhkPath%\..\AutoHotkey.chm
    errors += !Download(UpdateURL_chm, TempDir "\help.zip")
; Download compiler.
ifExist %A_AhkPath%\..\Compiler\Ahk2Exe.exe
    errors += !Download(UpdateURL_a2e, TempDir "\compiler.zip")

if errors
{
    MsgBox 16, AutoHotkey Updater, Update failed: download error.
    ifExist %TempDir%\*.zip
        Run %TempDir% ; Allow user to extract files manually.
    else
        FileRemoveDir %TempDir%, 1
    ExitApp
}

; Extract binaries, help file and compiler into temp dir.
oShell := ComObjCreate("Shell.Application")
oDir := oShell.NameSpace(TempDir)
Loop %TempDir%\*.zip
{
    oZip := oShell.NameSpace(A_LoopFileFullPath)
    if !(oZip && oDir)
    {
        MsgBox 16, AutoHotkey Updater, Update failed: unzip error.
        Run %TempDir%
        ExitApp
    }
    oDir.CopyHere(oZip.Items, 4)
}
oShell := oDir := oZip := ""

_Install(TempDir)

ExitApp


_Install(source_dir)
{
    ; Get list of scripts running on the old executable. This will apparently
    ; work even after the file itself is renamed, but better be on the safe side.
    Process Exist
    my_pid := ErrorLevel
    ComObjError(0) ; ComObjGet("winmgmts:") fails on Guest account.
    for proc in ComObjGet("winmgmts:").InstancesOf("Win32_Process")
        if (proc.ExecutablePath = A_AhkPath && proc.ProcessId != my_pid)
            pids .= proc.ProcessId ","
    pids := SubStr(pids,1,-1)

    ; Rename current executable to allow another to take its place.
    backup_path = %A_AhkPath%.%A_AhkVersion%.bak
    FileMove %A_AhkPath%, %backup_path%, 1
    if ErrorLevel
    {
        if !A_IsAdmin
        {   ; Try again as admin.
            if Elevate("Install", source_dir)
                ExitApp
        }
        MsgBox 16, AutoHotkey Updater, Update failed: unable to rename old file.  Error %err%.`n`nSource: %A_AhkPath%`nDestination: %backup_path%
        Run %source_dir%
        ExitApp
    }

    ; Move new files into place -- FileCopy is used because otherwise the files would still have permissions inherited from %A_Temp%.
    FileCopy %source_dir%\AutoHotkey.exe, %A_AhkPath%
    if ErrorLevel
    {
        MsgBox 16, AutoHotkey Updater, Update failed: unable to move AutoHotkey.exe to "%A_AhkPath%".
        Run %source_dir%
        ExitApp
    }
    errors := 0 
    compiler_dir = %A_AhkPath%\..\Compiler
    ifExist %compiler_dir%\Ahk2Exe.exe
    {
        FileCopy %source_dir%\Ahk2Exe.exe, %compiler_dir%\Ahk2Exe.exe, 1
        errors += ErrorLevel
        FileCopy %source_dir%\*.bin, %compiler_dir%, 1
        errors += ErrorLevel
        AutoHotkeySC_bin := (A_IsUnicode ? "Unicode " : "ANSI ") A_PtrSize*8 "-bit.bin"
        FileCopy %source_dir%\%AutoHotkeySC_bin%, %compiler_dir%\AutoHotkeySC.bin, 1
        errors += ErrorLevel
    }
    FileCopy %source_dir%\AutoHotkey.chm, %A_AhkPath%\..\AutoHotkey.chm, 1 ; If it exists.
    if errors + ErrorLevel
    {
        MsgBox 16, AutoHotkey Updater, Failed to copy one or more files.
        Run %source_dir%
        ExitApp
    }

    ; Clean up. :)
    FileRemoveDir %source_dir%, 1
    
    ; Relaunch using new executable -- see _TidyUp() below.
    Run "%A_AhkPath%" "%A_ScriptFullPath%" TidyUp "%my_pid%" "%backup_path%" "%pids%"
}


_TidyUp(parent_pid, delete_me, other_pids="")
{
    ; Update registry -- this is done here so can be positive the version number is accurate.
    RegRead InstallDir, HKLM, SOFTWARE\AutoHotkey, InstallDir
    if (A_AhkPath = InstallDir "\AutoHotkey.exe")
    {
        RegWrite REG_SZ, HKLM, SOFTWARE\AutoHotkey, Version, %A_AhkVersion%
        RegWrite REG_SZ, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AutoHotkey, DisplayName, AutoHotkey %A_AhkVersion%
        RegWrite REG_SZ, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AutoHotkey, DisplayVersion, %A_AhkVersion%
    }
    
    Process WaitClose, %parent_pid% ; Wait for previous instance of this script to close.
    DetectHiddenWindows On
    scripts := Object()
    Loop Parse, other_pids, `,
    {
        ifWinExist ahk_pid %A_LoopField% ahk_class AutoHotkey
        {
            WinGetTitle script
            script := RegExReplace(script, " - [^-]*$")
            scripts[WinExist()] := script
            script_filenames .= script "`n"
        }
    }
    SplitPath A_AhkPath, exe
    SplitPath delete_me, bak
    if scripts.MaxIndex() != ""
    {
        MsgBox 4, AutoHotkey Updater, The following scripts are still running:`n`n%script_filenames%`nWould you like to automatically reload them?
        ifMsgBox Yes
        {
            failed := ""
            while (id := scripts.MaxIndex()) ; Must be MAX rather than MIN, otherwise existing IDs will be invalidated by Remove().
            {
                script := scripts.Remove(id)
                ifExist %script%
                {
                    ; Triggering reload won't work in most cases since the version number
                    ; in the window title has changed. Instead, forcibly start the script
                    ; and automatically close the old one if the new one loaded okay.
                    Run "%A_AhkPath%" /force "%script%",,, pid
                    WinWait ahk_pid %pid%,, 1
                    ; Above may have timed out or found a load-time error dialog.
                    ; Check for the "ahk_class AutoHotkey" window specifically,
                    ; since its presence indicates the script loaded okay.
                    ifWinExist ahk_pid %pid% ahk_class AutoHotkey
                        WinClose ahk_id %id%,, 0
                }
                ifWinExist ahk_id %id%
                    failed .= script "`n"
            }
            if failed !=
                MsgBox 16, AutoHotkey Updater, One or more scripts were not successfully reloaded:`n`n%failed%
        }
    }

    global KeepBackup
    if KeepBackup ; This is set at the top of the script, for configuration by a user.
        ExitApp
    ; Attempt to delete file. This will fail if any old scripts are still running.
    FileDelete %delete_me%
    ; If unsuccessful, attempt to schedule it for deletion. This will only work
    ; for administrators. If a limiter user got this far in the installation,
    ; they're probably working with a portable installation and won't want to
    ; provide admin credentials just to schedule a file for deletion.
    if ErrorLevel && !DllCall("MoveFileEx", "str", delete_me, "ptr", 0, "uint", 4) ; MOVEFILE_DELAY_UNTIL_REBOOT:=4
        MsgBox 16, AutoHotkey Updater, Failed to delete old file "%bak%".
    ExitApp
}


_SelfUpdate(source_path)
{
    ; Copy and Delete instead of Move so that file permissions are inherited correctly.
    FileCopy %source_path%, %A_ScriptFullPath%, 1
    if ErrorLevel
    {
        if !A_IsAdmin
        {   ; Try again as admin.
            if Elevate("SelfUpdate", source_path)
                ExitApp
        }
        MsgBox 16, AutoHotkey Updater, Script update failed.  Error %err%.
        ExitApp
    }
    FileDelete %source_path%
    Reload
}


Elevate(func, prms*)
{
    cmd := func
    for i,prm in prms
    {
        StringReplace prm, prm, `", "", All
        cmd .= " """ prm """"
    }
    if A_IsCompiled
        exe := A_ScriptFullPath
    else
        exe := A_AhkPath, cmd := """" A_ScriptFullPath """ " cmd
    return DllCall("shell32\ShellExecute", "ptr", 0, "str", "RunAs"
                    , "str", exe, "str", cmd, "ptr", 0, "int", 1) > 32
}


; Based on code by Sean and SKAN @ http://www.autohotkey.com/forum/viewtopic.php?p=184468#184468
Download(url, file)
{
    static vt
    if !VarSetCapacity(vt)
    {
        VarSetCapacity(vt, A_PtrSize*11), nPar := "31132253353"
        Loop Parse, nPar
            NumPut(RegisterCallback("DL_Progress", "F", A_LoopField, A_Index-1), vt, A_PtrSize*(A_Index-1))
    }
    global _cu
    SplitPath file, dFile
    SysGet m, MonitorWorkArea, 1
    y := mBottom-52-2, x := mRight-330-2, VarSetCapacity(_cu, 100), VarSetCapacity(tn, 520)
    , DllCall("shlwapi\PathCompactPathEx", "str", _cu, "str", url, "uint", 50, "uint", 0)
    Progress Hide CWFAFAF7 CT000020 CB445566 x%x% y%y% w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11,, %_cu%, AutoHotkeyProgress, Tahoma
    if (0 = DllCall("urlmon\URLDownloadToCacheFile", "ptr", 0, "str", url, "str", tn, "uint", 260, "uint", 0x10, "ptr*", &vt))
        FileCopy %tn%, %file%
    else
        ErrorLevel := 1
    Progress Off
    return !ErrorLevel
}
DL_Progress( pthis, nP=0, nPMax=0, nSC=0, pST=0 )
{
    global _cu
    if A_EventInfo = 6
    {
        Progress Show
        Progress % P := 100*nP//nPMax, % "Downloading:     " Round(np/1024,1) " KB / " Round(npmax/1024) " KB    [ " P "`% ]", %_cu%
    }
    return 0
}