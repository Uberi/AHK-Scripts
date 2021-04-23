;;
;  Compile() - 0.41 - by gwarble
;    compile your script on demand, with local icons/AutoHotkey.bin
;
; Compile(Action,Name,Password)
;
;    Action   "" [Default]  -waits for the compiler to finish before returning
;             Run           -to run the compiled script and close the running script
;             NoWait        -starts compiling and continues running your script
;             Recompile     -closes the running .exe and launches the .ahk (if compiled)
;                             (useful for a self-editing compiled script)
;
;    Name     "" [Default]  -uses filename of script for exe/ico/bin filenames
;             Other         -specify a different name for the input ico/bin and output exe
;
;    Password **            -compilation password
;
;    Return   1 on success
;             0 on failure, compiler not found, already compiled, etc...
;
;    Notes    save custom icon as ScriptName.ico (in a subdir is ok) or
;             save modified AutoHotkeySC.bin as ScriptName.AHK.bin
;
Compile(Action="",Name="",Password="") {
 If A_IsCompiled	
  If Action <> Recompile	; unless "ReCompile", function does nothing when running compiled
   Return 0
  Else
  {
   SplitPath, A_ScriptFullPath,,,,ScriptName
   Run, %ScriptName%.ahk 	; if is Recompile, will close the running exe and launch the ahk script
   Return 1		; which should have its own auto-exeute Compile("Run")
  }
 SplitPath, A_ScriptFullPath,, ScriptDir,, ScriptName
 If Name <>
  ScriptName := Name	; Name parameter overrides icon/exe name from Scripts name
 Icon := ExeFile := ScriptDir "\" ScriptName ".exe"
 Loop, %ScriptName%.AHK.bin, 0, 1	; find .AHK.bin file if it exists, including subdirs
  IfExist %A_LoopFileFullPath%
  {
   Icon := CompilerBin := A_LoopFileFullPath
   Break
  }
 If CompilerBin =		; otherwise, use a found ScriptName.ico for the compile process
  Loop, %ScriptName%.ico, 0, 1	; including subdirs
   IfExist %A_LoopFileFullPath%	
   {
    ScriptIcon = /icon "%A_LoopFileFullPath%"
    Icon = %A_LoopFileFullPath%	; and sets it for the run string to run the compiler later
    Break
   }
 SplitPath, A_AhkPath,, Compiler,,,  ; find compiler...
 Compiler := Compiler "\Compiler\Ahk2Exe.exe"	; assumes compiler is in AHKPath default Compiler dir
 IfNotExist %Compiler%		; otherwise, checks registry for AHK install dir
 {			; poor method checks the context menu for the compile command
  RegRead, Compiler, HKCR, AutoHotkeyScript\Shell\Compile\Command ; for location of compiler
  StringReplace, Compiler, Compiler, ",,All
  StringReplace, Compiler, Compiler, % "/in %l"	; and clean up that context menu command to the exe path
  IfNotExist %Compiler%
  {
   Loop %A_StartMenuCommon%\*.*, 0, 1	; otherwise check the start menu for compiler's default shortcut
    If A_LoopFileName contains convert .ahk to .exe
    {
     FileGetShortcut, % A_LoopFileFullPath, Compiler
     Break
    }
   IfNotExist %Compiler%		; otherwise assumes AHK (and compiler) is not installed
    Loop, %A_ScriptDir%\Ahk2Exe.exe, 0, 1	; so checks the local dir for the compiler
     Compiler := %A_LoopFileFullPath% 	; including subdirs
  }
  IfNotExist %Compiler%		; and after all that if no compiler is found, returns error (0)
   Return 0   			; compiler not found
 }

 Prev_DetectHiddenWindows := A_DetectHiddenWindows
 DetectHiddenWindows On		; loop to WinClose all running processes before compiling
 Loop
  IfWinExist, % ExeFile,,30
   WinClose
  Else
   Break
 DetectHiddenWindows %Prev_DetectHiddenWindows%

 If (Password)  			; sets compilation password
  Password := "/pass " Password		; untested feature

 Loop, %ScriptName%.AHK.bin, 0, 1
  IfExist %A_LoopFileFullPath%		; if custom .bin is used, copy it in place
  {			; after backing up the original
   SplitPath, Compiler,, CompilerDir,,,
   CompilerBin := CompilerDir "\AutoHotkeySC.bin"
   FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Last.bin", 1 ; backed up original every run
   FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Orig.bin", 0 ; first backup made won't be overwritten
   FileCopy, % A_LoopFileFullPath , % CompilerBin, 1
   Break
  }			; and finally, put all those options together
 RunLine = %Compiler% /in "%A_ScriptFullPath%" /out "%ExeFile%" %ScriptIcon% %Password%
 If Action = NoWait		; decide how to run it (first parameter)
  Run,     % RunLine, % A_ScriptDir, Hide
 Else
  RunWait, % RunLine, % A_ScriptDir, Hide
 If (CompilerBin)			; restore the original SC.bin file if a custom one was used
  FileCopy, % CompilerDir "\AutoHotkeySC.Last.bin", % CompilerBin, 1
 If Action = Run			; and run the compiled script if "Run" option is used (typical)
 {
  Run, % ScriptName
  ExitApp
 }
Return 1
}