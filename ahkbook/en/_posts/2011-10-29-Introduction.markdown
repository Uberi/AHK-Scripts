---
title: Introduction
layout: post
permalink: /en/Introduction.html
---

# Introduction

## What is AutoHotkey?
AutoHotkey is a powerful scripting language for Windows, focused on **auto**mation and **hotkeys**. It allows you to easily manipulate other programs, create custom hotkeys and "hotstrings", interact with the user, read, create and manage files and a lot more.

With AutoHotkey, you can also use big parts of the Windows API, interact with Web applications, use COM and more.

With these both simple and advanced features, AutoHotkey is as well suitable for beginners as for advanced programmers that want to customize their environment or automate common tasks.

AutoHotkey was originally developed by Chris Mallett. Today, there are a lot of custom versions and additions, which we will cover in [Chapter 1](What-Version-To-Choose.html).

## What can AutoHotkey do?
***Nearly everything.*** Aside from making toast, no one has yet found a task that can't be done with AutoHotkey in some way. Some of these ways are simple, some are not very elegant, some are rather obscure, however, they work.

## What can't AutoHotkey do?
There are just two things:
* **Performance:** AutoHotkey is a scripting language. That means, it is interpreted each time it's run. This has of course some impact on performance.
* **Compilation**: AutoHotkey cannot be used as a shell extension or be injected into another process, as it can't be compiled to a dll. There's a compiler, but it only compiles to an \*.exe, and it doesn't compile the AutoHotkey source code to a binary.

Both issues might be (partially) solved later by the IronAHK version.


## When and why should I use AutoHotkey?
You should use AutoHotkey because it is easy to use and to learn, because it offers simple solutions, because it has advanced features, because it is a great and helpful language to learn.

In the beginnings, you should of course start with easy things. But you're not limited to them: people write complex and large software in AutoHotkey. As an example, large parts of the recommended editor for AutoHotkey, [Scite4AutoHotkey](http://www.autohotkey.com/forum/viewtopic.php?t=58820), are written in AutoHotkey.

You can use AutoHotkey for game scripts, for quick macros, for tasks that take hours, for deep system modifications, for automating other applications through their window or through other interfaces, and a lot more.

## Index
***Note:*** This list and its order are not set in stone. Feel free to change it.

1. [What AutoHotkey version to choose?](What-Version-To-Choose.html)

2. [First steps](First-steps.html)

	- [Your first script](Your-First-Script.html)

		- [useful tools: AutoHotkey editors](Useful-Tools-Editors.html)
	- [Compiling a script](Compiling.html)

3. [A guide to the manual](Guide-Manual.html)

4. [A guide to the AutoHotkey forums](Guide-Forums.html)

5. [Let's start](Lets-start.html)
	- [the auto-execute section](auto-execute-section.html)
	- [Hotkeys]()
	
		- [context-sensitive hotkeys]() <!-- including #if & friends, but without covering in detail || or just #IfWinActive + #if later?  
												~nimda says:	#if should go there; with a link to expressions or at least 
																http://d.ahk4.me/Variables#Expressions -->
		- ['toggle' hotkeys & 'autofire'](toggle-autofire.html) <!-- ~change the punctuation/name; not a big deal -->
	- [Hotstrings]()
	- [Remapping keys]()
	- [Labels](Labels.html)

		- [useful tools: TillaGoTo](Useful-Tools-TillaGoTo.html)
	- [Variables, commands and function stuff](Variables-functions-commands.html)

		- [the power of built-in variables](builtin-variables.html)
	- [Working with conditions](Working-with-conditions.html)
	- [Basic User Interaction: MsgBox & Co.](Basic-user-interaction.html)
	- [Repeating things](Repeating.html)
	- [Influencing AutoHotkey]() <!-- directives! take from Directives.markdown -->
	- [GUI stuff]()

		- [useful tools: Gui creators]()<!-- take from Coding-Environment.markdown -->
	- [File management]()
	- [Storing data]()
		- [INI]()
		- [XML]()
		- [Registry]()
	- [operators]()

		- [a bit of maths]()
	- [working with strings]()
	- [handling errors]() <!-- ErrorLevel + try/catch/throw -->
	- [Regular Expressions]()

6. [Documenting your code]()
	- [Why and how to document your code]()
	- [useful tools: NDocs & GenDocs]()

7. [User-defined functions]() <!-- including byRef -->
	- [variable scopes]()
	- [libraries and stdLib conventions]()
	- [The standard library collection]()

8. [Into the web: downloading, HttpRequests, httpQuery() and more]()

9. [A bit of advanced stuff]()
	- [DllCalls to Windows API](DllCalls.html)
	- [Structures](Structures.html)
	- [Working with bits (&, |, >>, <<, ...)](Working-with-bits.html)
	- [Streams and file headers]()

10. [custom GUI controls]()

	- [embedding browser in GUI etc.]()

11. [COM]()
	- [a short introduction]()
	- [StdLib & native COM]()
	- [automating IE & FF]()
	- [automating Office]()
	- [interfaces]()

12. [OOP]()
	- [Objects & Arrays]()
	- [Classes]()

13. [Libraries]()
    - [CWindow library (+ C# converter)]()
    - [Aero Library]()
    - [gdi+]()
