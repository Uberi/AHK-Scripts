#NoEnv

Gui, Font, s36, Arial
Gui, Add, Text, x10 y10 w760 h50 Center, MODSTER 2.0

Gui, Font, s12
Gui, Add, Groupbox, x10 y80 w760 h110, Where is the Minetest folder?
Gui, Font, s22
Gui, Add, Edit, x20 y110 w690 h40 vMinetestPath gCheckMinetest
Gui, Add, Button, x710 y110 w50 h40 gSelectMinetest, ...
Gui, Font, s10
Gui, Add, Text, x20 y160 w740 h20 vMinetestStatus

Gui, Font, s12
Gui, Add, Groupbox, x10 y200 w760 h150, How is the mod stored?
Gui, Font, s18
Gui, Add, Radio, x20 y220 w430 h40 Checked vModType gSelectType, I've got some sort of file here
Gui, Add, Radio, x20 y260 w430 h40 gSelectType, I've got this folder somewhere
Gui, Add, Radio, x20 y300 w430 h40 gSelectType, I've got a whole bunch of text
Gui, Font, s10
Gui, Add, Text, x450 y220 w310 h40, Select this if you have a single file with an extension like ZIP`, TAR.GZ`, LUA, or similar.
Gui, Add, Text, x450 y260 w310 h40, Select this if you have a folder with some files or folders inside it.
Gui, Add, Text, x450 y300 w310 h40, Select this if you have a some plain text that can be copied and pasted.

Gui, Font, s12
Gui, Add, Groupbox, x10 y360 w760 h110, Where is the mod?
Gui, Font, s22
Gui, Add, Edit, x20 y390 w690 h40 vModPath gCheckMod
Gui, Add, Button, x710 y390 w50 h40 vSelectMod gSelectMod, ...
Gui, Font, s10
Gui, Add, Text, x20 y440 w740 h20 vModStatus
Gui, Font,, Courier New
Gui, Add, Edit, x20 y385 w740 h75 -VScroll Hidden vModCode gDeferredCheckMod

Gui, Font, s12, Arial
Gui, Add, Groupbox, x10 y480 w760 h80, Installation status
Gui, Font, s24
Gui, Add, Text, x20 y510 w740 h40 vStatus

;installer default location found
SplitPath, A_WinDir,,,,, MainDrive
Loop, %MainDrive%\*Minetest*, 2
    GuiControl,, MinetestPath, %A_LoopFileLongPath%

;installer alternate location found
Loop, %A_ProgramFiles%\*Minetest*, 2
    GuiControl,, MinetestPath, %A_LoopFileLongPath%

Gosub, CheckMinetest
Gosub, CheckMod
Gosub, UpdateStatus

Gui, Color, White
Gui, Show, w780 h570, Modster 2.0 - Dead simple Minetest mod installer by Uberi
Return

GuiClose:
ExitApp

SelectMinetest:
FileSelectFolder, MinetestPath,, 3
If ErrorLevel
    Return
GuiControl,, MinetestPath, %MinetestPath%
Return

SelectType:
Gui, Submit, NoHide
State := ModType = 3
GuiControl, Hide%State%, ModPath
GuiControl, Hide%State%, SelectMod
GuiControl, Hide%State%, ModStatus
GuiControl, Show%State%, ModCode
GuiControl,, ModCode, Paste the code in here!
Return

SelectMod:
Gui, Submit, NoHide
If ModType = 1 ;mod is stored as a file
    FileSelectFile, ModPath, 3,, Select the mod file, Minetest Mods (*.7z; *.xz; *.zip; *.gz; *.gzip; *.tgz; *.bz2; *.bzip2; *.tbz2; *.tbz; *.tar; *.rar; *.lua)
Else If ModType = 2 ;mod is stored as a folder
    FileSelectFolder, ModPath,, 3
If ErrorLevel
    Return
GuiControl,, ModPath, %ModPath%
Return

CheckMinetest:
GuiControlGet, MinetestPath,, MinetestPath
try TrueMinetestPath := IsMinetest(MinetestPath)
catch e
{
    GuiControl,, MinetestStatus, % "Error: " . e.Message
    Return
}
Gosub, UpdateStatus
If TrueMinetestPath
{
    GuiControl,, MinetestStatus, Minetest found! Path: %TrueMinetestPath%
    If TrueModPath ;both minetest and mod paths specified
        Gosub, InstallMod
}
Else
    GuiControl,, MinetestStatus, That doesn't look like a Minetest folder!
Return

DeferredCheckMod:
Gui, Submit, NoHide
SetTimer, CheckMod, -500
Return

CheckMod:
GuiControlGet, ModPath,, ModPath
If ModType = 3 ;plain text mod
{
    GuiControlGet, ModCode,, ModCode
    try ModPath := CreateMod(ModCode)
    catch e
    {
        GuiControl,, ModStatus, % "Error: " . e.Message
        Return
    }
}
try TrueModPath := IsMod(ModPath)
catch e
{
    GuiControl,, ModStatus, % "Error: " . e.Message
    Return
}
Gosub, UpdateStatus
If TrueModPath
{
    GuiControl,, ModStatus, Mod found! Path: %TrueModPath%
    If TrueMinetestPath ;both minetest and mod paths specified
        Gosub, InstallMod
}
Else
    GuiControl,, ModStatus, That doesn't look like a mod!
Return

UpdateStatus:
If TrueMinetestPath
{
    If TrueModPath
        GuiControl,, Status, Installing...
    Else If ModType = 3 ;plain text mod
        GuiControl,, Status, Enter the mod code.
    Else
        GuiControl,, Status, Enter the mod path.
}
Else If TrueModPath
    GuiControl,, Status, Enter the Minetest path.
Else If ModType = 3 ;plain text mod
    GuiControl,, Status, Enter the Minetest path and mod code.
Else
    GuiControl,, Status, Enter the Minetest and mod paths.
Return

InstallMod:
ModName := DetectModName(TrueModPath)
If FileExist(TrueMinetestPath . "\mods\minetest") ;Minetest version 0.4.6 or below
    ModFolder := TrueMinetestPath . "\mods\minetest"
Else ;Minetest version 0.4.7 or above
    ModFolder := TrueMinetestPath . "\mods"
Destination := ModFolder . "\" . ModName

;copy files to the mod folder
try FileRemoveDir, %Destination%, 1
try FileCreateDir, %Destination%
catch
{
    GuiControl,, Status, Error: Could not create mod folder.
    Return
}
If CopyFilesAndFolders(TrueModPath . "\*.*",Destination,True) > 0
{
    GuiControl,, Status, Error: Could not copy all files.
    Return
}

GuiControl,, Status, Mod installed!
Return

CreateMod(Code)
{
    TempFolder := A_Temp . "\Modster_Temp1\modster_installed_" . (A_ScriptHwnd + 0)

    ;clear folder
    try FileRemoveDir, %TempFolder%, 1
    try FileCreateDir, %TempFolder%
    catch
        throw Exception("Could not create temp folder")

    ;write file
    try FileDelete, %TempFolder%\init.lua
    try FileAppend, %Code%, %TempFolder%\init.lua
    catch
        throw Exception("Could not write file")

    Return, TempFolder
}

DetectModName(ModPath)
{
    ;look through all the code files for indicators of the mod name
    Loop, %ModPath%\*.lua
    {
        try
        {
            FileRead, Contents, %A_LoopFileFullPath%
            If RegExMatch(Contents,"iS)register_(?:node|tool|craftitem)\s*\(\s*[""']\K\w+:",ModName)
                Return, ModName
        }
    }

    ;use folder name as the mod name
    SplitPath, ModPath, ModName
    If RegExMatch(ModName,"S)^\w+$")
        Return, ModName

    ;use the parent folder name as the mod name
    SplitPath, ModPath,, Parent
    SplitPath, Parent, ModName
    If RegExMatch(ModName,"S)^\w+$")
        Return, ModName
}

IsMinetest(Path) ;returns the base folder of Minetest, or a blank string if not found
{
    Attributes := FileExist(Path)
    If !Attributes ;path doesn't exist
        Return, ""
    If !InStr(Attributes,"D") ;path is a file
        Return, ""

    ;remove trailing slash
    If SubStr(Path,0) = "\" || SubStr(Path,0) = "/"
        Path := SubStr(Path,1,-1)

    ;check folder
    If FileExist(Path . "\bin\minetest.exe")
    {
        Loop, %Path%, 2
            Return, A_LoopFileLongPath
    }

    ;check parent folder
    If FileExist(Path . "\..\bin\minetest.exe")
    {
        Loop, %Path%\.., 2
            Return, A_LoopFileLongPath
    }

    ;check subfolders
    Loop, %Path%\*Minetest*, 2
    {
        TempPath := A_LoopFileFullPath
        If SubStr(TempPath,0) = "\"
            TempPath := SubStr(TempPath,1,-1)
        If FileExist(TempPath . "\bin\minetest.exe")
            Return, A_LoopFileLongPath
    }

    Return, ""
}

IsMod(Path) ;returns the base folder of the mod, or a blank string if not found
{
    Attributes := FileExist(Path)
    If !Attributes ;path doesn't exist
        Return, ""

    ;remove trailing slash
    If SubStr(Path,0) = "\" || SubStr(Path,0) = "/"
        Path := SubStr(Path,1,-1)

    If InStr(Attributes,"D") ;path is a folder
    {
        ;check folder
        If FileExist(Path . "\init.lua") || FileExist(Path . "\modpack.txt")
        {
            Loop, %Path%, 2
                Return, A_LoopFileLongPath
        }

        ;check parent folder
        If FileExist(Path . "\..\init.lua") || FileExist(Path . "\..\modpack.txt")
        {
            Loop, %Path%\.., 2
                Return, A_LoopFileLongPath
        }

        ;check subfolders
        Loop, %Path%\*, 2
        {
            TempPath := A_LoopFileFullPath
            If SubStr(TempPath,0) = "\"
                TempPath := SubStr(TempPath,1,-1)
            If FileExist(TempPath . "\init.lua") || FileExist(TempPath . "\modpack.txt")
                Return, A_LoopFileLongPath
        }
    }
    Else ;path is a file
    {
        try FileInstall, 7za.exe, %A_Temp%\7za.exe, 1
        catch
            throw Exception("Could not extract archiver")

        Loop
        {
            ;create a folder with the archive name
            SplitPath, Path,,,, Name
            TempFolder := A_Temp . "\Modster_Temp" . A_Index . "\" . Name

            ;clear folder
            try FileRemoveDir, %TempFolder%, 1
            try FileCreateDir, %TempFolder%
            catch
                throw Exception("Could not create temp folder")

            ;extract the archive based on its extension
            SplitPath, Path,,, Extension
            If (Extension = "lua") ;plain Lua file
            {
                ;wip: try checking the containing directory for the mod folder
                If (Name = "init") ;plain mod name
                {
                    Loop, 1
                    {
                        ;create a random folder for the mode to go in
                        Random, Temp1, 0, 0xFFFFFF
                        Temp1 := A_Temp . "\Modster_Temp" . A_Index . "\modster_installed_" . Temp1
                        try FileMoveDir, %TempFolder%, %Temp1%, R
                        catch
                            Break
                        TempFolder := Temp1
                    }
                }

                ;move the Lua file into the directory
                try FileCopy, %Path%, %TempFolder%\init.lua, 1
                catch
                    throw Exception("Could not copy file")
                Return, TempFolder
            }
            If Extension Not In 7z,xz,zip,gz,gzip,tgz,bz2,bzip2,tbz2,tbz,tar,rar
                Break

            ;extract archive
            try RunWait, "%A_ScriptDir%\7za.exe" x "%Path%" -y "-o%TempFolder%",, Hide
            catch
                throw Exception("Could not start archiver")
            If ErrorLevel != 0 ;archive extraction error
                throw Exception("Could not extract archive")

            ;check for mod
            If FileExist(TempFolder . "\init.lua") || FileExist(TempFolder . "\modpack.txt")
                Return, TempFolder

            ;check subfolders
            Loop, %TempFolder%\*, 2
            {
                TempPath := A_LoopFileFullPath
                If SubStr(TempPath,0) = "\"
                    TempPath := SubStr(TempPath,1,-1)
                If FileExist(TempPath . "\init.lua") || FileExist(TempPath . "\modpack.txt")
                    Return, A_LoopFileLongPath
            }

            ;check for nested archives
            Found := False
            Loop, %TempFolder%\*
            {
                If (A_LoopFileExt = "zip" || A_LoopFileExt = "gz" || A_LoopFileExt = "tgz" || A_LoopFileExt = "tar")
                {
                    Found := True
                    Path := A_LoopFileLongPath
                }
            }
            If !Found ;no nested archives found
                Break
        }
    }

    Return, ""
}

CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ; First copy all the files (but not the folders):
    FileCopy, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileCopyDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
    }
    return ErrorCount
}