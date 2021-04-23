In this package, I give the new binary (v.3.2.1) of SciTE (with Lua) and Scintilla (actually SciLexer.dll) compiled with Visual Studio Express 2010, including support of AHK v.1.

I also provide tools to recompile them, in case I still lag behind the latest versions of SciTE...

AddLexAHK1.ahk is an AutoHotkey script which injects the minimal code to add the LexAHK.cxx to Scintilla: it copies this file in the sources and edit SciLexer.h and KeyWords.cxx to add the required declarations.
It should update Scintilla.iface but currently neglects to do so. Likewise, it should also update SciTE's IFaceTable.cxx.
It assumes a given directory structure, you have to edit the first lines to adapt to your setting.

LexAHK1.cxx is thus the lexer for AutoHotkey v.1: I expect v.2 to be largely different in syntax, hence the provision for another version. The state names will be likely shared, though.

SciLexer.vcproj have to be put in scintilla\vcbuild, it is the project file for VSE2005 I used to make SciLexer.dll
SciTELua.vcproj and SciTE.vcproj have to be put in scite\vcbuild. SciTELua have to be compiled first (optimized for speed...) and SciTE will use the corresponding library.
SciLexer and SciTE are optimized for size, like in the original makefiles.

ahk1.properties is my current properties file for the lexer. Adjust the autohotkeydir setting to your configuration.

SciLexer.dll, SciTE.exe and ahk1.properties have to be dropped in the SciTE install dir, the first two replacing the provided binaries (I suggest to save them just in case...).

OpenSciTESession.ahk can be put in the SciTE directory. With proper registry settings (see SciTE.reg), you can double-click a session file to open the related files in an instance of SciTE.

SciTE.reg contains the registry hacks I apply to integrate SciTE to Windows (open by default for some file types, always in context menu, etc.).

SciTEUser.properties is an example of user defined properties, with some personal settings, and an example of including AHK lexer (in open filter, lexer list and import).

SciTEStartup.lua is a slightly stripped down version of my collection of Lua functions, including a call to ListAHKFunctions4SciTE.lua!
Some things there are useless or unused, I left these as code sample... Deep clean-up advised! ;)


