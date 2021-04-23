;AHK v1
#NoEnv

/*
Up::ShowShell()
Down::HideShell()
Esc::ExitApp
*/

HideShell()
{
 WinHide, ahk_class Shell_TrayWnd
 WinHide, Start ahk_class Button
 WinHide, ahk_class Progman
}

ShowShell()
{
 WinShow, ahk_class Shell_TrayWnd
 WinShow, Start ahk_class Button
 WinShow, ahk_class Progman
}