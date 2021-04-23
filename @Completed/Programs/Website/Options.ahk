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

ProcessCommandLineParameters()
{
    global
    local Temp1, Parameter, Position, Option, Value
    Loop, %0% ;loop through each command line parameter in the form "--OPTION=VALUE"
    {
        Parameter := %A_Index%
        If (SubStr(Parameter,1,2) != "--") ;parameters must begin with "--"
            OutputError("Invalid command line parameter given: " . Parameter,1)
        Temp1 := SubStr(Parameter,3), Position := InStr(Temp1,"=")
        If !Position ;could not find "="
            OutputError("Option is missing value: " . Parameter,1)
        Option := SubStr(Temp1,1,Position - 1), Value := SubStr(Temp1,Position + 1)
        If !ObjHasKey(ValidParameters,Option)
            OutputError("Unknown option: " . Parameter,1)
        If ValidParameters[Option] ;parameter is a boolean flag
        {
            If (Value = "True")
                Value := 1
            Else If (Value = "False")
                Value := 0
            Else
                Value := !!Value
        }
        %Option% := Value
    }
}

LoadOptions()
{
    global
    If FileExist(ConfigurationPath)
    {
        For Key In ValidParameters
            IniRead, %Key%, %ConfigurationPath%, Options, %Key%, % %Key% . " " ;read in the key if it exists, otherwise use the original value
    }
}

SaveOptions()
{
    global ValidParameters, ConfigurationPath
    FileAppend,, %ConfigurationPath%
    For Key In ValidParameters
    {
        If (Key != "AutoHotkeyNetPassword") ;do not save the account password
            IniWrite, % %Key%, %ConfigurationPath%, Options, %Key%
    }
}

ShowOptionsDialog()
{
    global
    local Temp1, TemplatesList
    Gui, Font, s18 Bold, Arial
    Gui, Add, Text, x2 y0 w630 h30 Center, AutoHotkey.net Website Generator

    Gui, Font, s8
    Gui, Add, GroupBox, x10 y40 w310 h110, Credentials
    Gui, Font, Norm
    Gui, Add, Text, x20 y60 w160 h20, Forum Username:
    Gui, Add, Edit, x180 y60 w130 h20 vForumUsername gEnterUsername, %ForumUsername%
    Gui, Add, CheckBox, x20 y90 w290 h20 vUsernamesDiffer gUsernamesDiffer, &My AutoHotkey.net username is something different
    Gui, Add, Text, x20 y120 w160 h20 vAutoHotkeyNetUsernameLabel Disabled, AutoHotkey.net Username:
    Gui, Add, Edit, x180 y120 w130 h20 vAutoHotkeyNetUsername Disabled, %ForumUsername%

    Gui, Font, Bold
    Gui, Add, GroupBox, x330 y40 w290 h80, Upload
    Gui, Font, Norm
    Gui, Add, CheckBox, x340 y60 w270 h20 vUploadWebsite gUploadWebsite Checked%UploadWebsite%, &Upload website to AutoHotkey.net
    Gui, Add, Text, x340 y90 w140 h20 vAutoHotkeyNetPasswordLabel Disabled, AutoHotkey.net Password:
    Gui, Add, Edit, x480 y90 w130 h20 vAutoHotkeyNetPassword Disabled Password, %AutoHotkeyNetPassword%

    Gui, Font, Bold
    Gui, Add, GroupBox, x10 y160 w310 h70, Search
    Gui, Font, Norm
    Gui, Add, CheckBox, x20 y180 w290 h20 vSearchEnglishForum Checked%SearchEnglishForum%, Search in the &English AutoHotkey forums
    Gui, Add, CheckBox, x20 y200 w290 h20 vSearchGermanForum Checked%SearchGermanForum%, Search in the &German AutoHotkey forums

    Gui, Font, Bold
    Gui, Add, GroupBox, x330 y130 w290 h100, Appearance
    Gui, Font, Norm
    Gui, Add, Text, x340 y150 w140 h20, Template:

    ;look for templates in the templates directory
    TemplatesList := ""
    Loop, %ResourcesPath%\*, 2
        TemplatesList .= A_LoopFileName . "|"

    Gui, Add, DropDownList, x480 y150 w130 h20 r15 vTemplate Choose1, % SubStr(TemplatesList,1,-1)
    GuiControl, ChooseString, Template, %Template%

    ;add sorting options and choose the correct default
    Gui, Add, Radio, x340 y180 w270 h20 vSortTime, Sort entries by &order updated
    Gui, Add, Radio, x340 y200 w270 h20 vSortEntries, Sort entries &alphabetically
    If SortEntries
        GuiControl,, SortEntries, 1
    Else
        GuiControl,, SortTime, 1

    Gui, Font, Bold
    Gui, Add, GroupBox, x10 y240 w310 h90, Behavior
    Gui, Font, Norm
    Gui, Add, CheckBox, x20 y260 w290 h20 vUseCache Checked%UseCache%, Use page information &cache
    Gui, Add, CheckBox, x20 y280 w290 h20 vRelativeLinks Checked%RelativeLinks%, &Rewrite script links into site links.
    Gui, Add, CheckBox, x20 y300 w290 h20 vDownloadResources Checked%DownloadResources%, &Download all resources

    Gui, Font, Bold
    Gui, Add, GroupBox, x330 y240 w290 h50, Output
    Gui, Font, Norm
    Gui, Add, Text, x340 y260 w90 h20, Output Directory:
    Gui, Add, Edit, x430 y260 w150 h20 vOutputPath, %OutputPath%
    Gui, Add, Button, x580 y260 w30 h20 gSelectFolder, ...

    Gui, Font, s10 Bold
    Gui, Add, Button, x330 y300 w290 h30 gOptionsDialogSubmit Default, Generate Website

    Gosub, EnterUsername
    Gosub, UploadWebsite

    Gui, Show, w630 h340, Website Generator
    Return
 
    GuiEscape:
    GuiClose:
    Gui, Submit
    SaveOptions() ;save options to the configuration file
    ExitApp

    OptionsDialogSubmit:
    Gui, Submit

    ;check for errors
    If (!InStr(FileExist(OutputPath),"D") && CreateDirectory(OutputPath)) ;output directory does not exist and could not be created
    {
        OutputError("Invalid output directory: " . OutputPath)
        Gui, Show
        Return
    }
    TemplatePath := ResourcesPath . "\" . Template
    If !InStr(FileExist(TemplatePath),"D") ;template directory does not exist
    {
        OutputError("Invalid template: " . Template)
        Gui, Show
        Return
    }
    If (UploadWebsite && AutoHotkeyNetPassword = "") ;password is blank
    {
        OutputError("AutoHotkey.net account password is blank.")
        Gui, Show
        Return
    }
    SaveOptions() ;save options to the configuration file

    Gui, Destroy

    ;create and show the progress dialog
    Gui, Font, s18
    Gui, Add, Text, x2 y0 w460 h30 +Center, Generating
    Gui, Add, Progress, x10 y40 w450 h20 vGenerationProgress -Smooth 0x8, 0
    Gui, Show, w470 h70, Website Generator
    SetTimer, UpdateProgress, 40
    GenerateWebsite(ResourcesPath,TemplatePath,OutputPath,Template,UseCache,UploadWebsite)
    SetTimer, UpdateProgress, Off
    Gui, Destroy
    MsgBox, 64, Complete, Website generation complete.
    ExitApp

    UpdateProgress:
    GuiControl,, GenerationProgress, +1
    Return

    EnterUsername:
    GuiControlGet, Temp1,, UsernamesDiffer
    If !Temp1
    {
        GuiControlGet, Temp1,, ForumUsername
        GuiControl,, AutoHotkeyNetUsername, %Temp1%
    }
    Return

    UsernamesDiffer:
    GuiControlGet, Temp1,, UsernamesDiffer
    GuiControl, Enable%Temp1%, AutoHotkeyNetUsernameLabel
    GuiControl, Enable%Temp1%, AutoHotkeyNetUsername
    If !Temp1
    {
        GuiControlGet, Temp1,, ForumUsername
        GuiControl,, AutoHotkeyNetUsername, %Temp1%
    }
    Return

    SelectFolder:
    Gui, +OwnDialogs
    FileSelectFolder, Temp1,, 3, Select an output folder:
    If !ErrorLevel
        GuiControl,, OutputPath, %Temp1%
    Return

    UploadWebsite:
    GuiControlGet, Temp1,, UploadWebsite
    GuiControl, Enable%Temp1%, AutoHotkeyNetPasswordLabel
    GuiControl, Enable%Temp1%, AutoHotkeyNetPassword
    Return
}

OutputError(ErrorText,Fatal = 0)
{
    global ShowGUI
    If ShowGUI
        MsgBox, 16, Error, %ErrorText% ;display the error
    Else
        FileAppend, %ErrorText%`n, * ;write the error text to standard output
    If Fatal ;unrecoverable error
        ExitApp, 1
}