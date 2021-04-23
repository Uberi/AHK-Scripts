---
title: What AutoHotkey version should I choose?
layout: post
permalink: /en/What-Version-To-Choose.html
---

# What to choose?

## Available versions
Currently, there are plenty of AutoHotkey forks and versions. The first step to do it choosing the right one.
Of course, it depends on your skills and what you want to do, but here are some pros and cons.

### AutoHotkey "basic", "classic" or "Vanilla"
This is the original AutoHotkey version, coded by Chris Mallett. Unfortunately, Chris has stopped development some time ago.

If you choose this version, any bugs you detect won't be fixed, and you can't use a lot of new features, such as Unicode, Arrays, COM, ... . You might think "I don't need Unicode, Arrays, etc., I don't even know what it is!". But trust me, they will become useful.

**Also note that AHK classic on 64bit will not work as soon as you reach some advanced topics.**

### AutoHotkey\_L
This fork is based on the original AutoHotkey code, and it is developed by Lexikos (Steve Gray). Contrary to AutoHotkey classic, it is still actively maintained.
Bugs are usually fixed quickly (given you report them), however, sometimes a change introduces a new bug.

AutoHotkey\_L has hundreds of new features, such as Arrays / Objects + classes (we'll deal with them later), native COM (another topic we'll discuss), but also features useful for hotkey scripters, and last but not least **64bit support**.

AutoHotkey\_L is offered in an ANSI and an Unicode version. This describes a different script encoding \([learn more...](http://www.joelonsoftware.com/printerFriendly/articles/Unicode.html "The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets \(No Excuses!\)")\). You may not know a lot about it, but Unicode often makes dealing with advanced topics (Windows API), but also hotkeys with special characters (&auml;, &ouml;, &uuml;, &szlig;, &Oslash;, Њ, ڵ, ...) easier. On the other side, *some* old scripts from the forum might have minor issues.

### IronAHK
This fork is a complete rewrite of AutoHotkey classic in C# (by polyethene and other contributors), which will enable cross-platform AutoHotkey. You'll be able to compile scripts into regular .NET assemblies, plus it will offer new features such as Arrays / Objects and Unicode. It will require (of course) the .NET framework or [Mono](http://www.mono-project.com/Main_Page) to be installed.

Why the future tense here? Well, IronAHK (or IA) is not yet finished, it's in alpha stage. And unfortunately, development seems to be paused here, too. Many things don't work yet, others produce errors.

Although it is a very interesting project, **currently it is not recommended to install it (as a beginner).**

### AutoHotkey v2
AutoHotkey v2 is based on Chris' plans for AutoHotkey's future + AutoHotkey\_L code. It is developed by Lexikos, too. It cleans up syntax, and introduces many script-breaking changes.
You can already use it, although it may have some bugs. But you might have to change your scripts for every new version, and you cannot use a lot of forum scripts.
AutoHotkey v2 is Unicode-only.

**It is not (yet) recommended to install this version.**

### AutoHotkey\_H
[AutoHotkey\_H](http://www.autohotkey.com/forum/topic43049.html) is a custom build of AutoHotkey\_L, maintained by HotKeyIt.

It allows multithreading within AutoHotkey, and can be used to run dynamic AHK code, use wildcards in #Includes or dynamic #Includes, or exit all threads.

There's also a version based on AutoHotkey v2 [available](http://www.autohotkey.net/~HotKeyIt/AutoHotkey2alpha.zip).

**You can use this version if you need its advanced features. Otherwise you should use AutoHotkey\_L.**

### AutoHotkey.dll
AutoHotkey.dll is a DLL version included with AutoHotkey\_H. It can be used to run AutoHotkey\_H code from within other scripting or programming languages.  There is a COM interface, so it can easily be used from AutoHotkey\_L, AutoHotkey\_H, AutoHotkey v2, VBScript, Javascript, etc.

## Legacy versions

### AutoHotkeyU
[AutoHotkeyU](http://www.autohotkey.com/forum/viewtopic.php?t=50485) was a Unicode version of AutoHotkey\_L rev. 41 by jackieku. This has been merged into AutoHotkey\_L.

**It is no longer recommended to install this version.**

### AutoHotkey64
[AutoHotkey64](http://www.autohotkey.com/forum/topic58237.html) was a 64bit version of AutoHotkey\_L by fincs. This has been merged into AutoHotkey\_L.

**It is no longer recommended to install this version. AutoHotkey\_L has 64bit support.**

## multiple versions aside
...

## Conclusion
Now you'll have to choose your version. Personally, I recommend AutoHotkey_L Unicode, and I'm not the only one to do so, but it's your choice.

The examples in this book will contain code for all versions of AutoHotkey, except for features that aren't supported by some version. The AutoHotkey version will be in a comment in the first line of each example.

A version information like <cite>AutoHotkey_L or later</cite> or <cite>AutoHotkey_L or similarly newer versions</cite> indicates a feature is supported in AutoHotkey\_L as well as in AutoHotkey\_H, AutoHotkey v2 and AutoHotkey\_H v2, as those versions derive from AutoHotkey\_L.

## version overview
A small diagram to illustrate AutoHotkey's version development (click to view in full size):
[![diagram](images/versions.png)](images/versions.png)
