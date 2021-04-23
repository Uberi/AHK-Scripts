---
title: #Directives
layout: post
permalink: /en/Directives.html
---

# \#Directives

## What are directives?
Directives affect your script in a special way: usually, all your code is executed if and when the script "reaches" it. Directives are ***processed just before the script starts*** and allow you to customize AutoHotkey's behaviour.

There are 2 basic types of directives:
* non-positional directives
* positional directives

All directives in AutoHotkey begin with an `#`.

### non-positional directives
Non-positional directives are a kind of "setting" for your script. They affect how your script behaves during execution, control features or change the script's syntax. It doesn't count ***where*** in the script they are used, and using them multiple times is useless.

Important non-positional directives include:
* `#SingleInstance` - controls whether the script can run several times simultaneously. Imagine your script is currently running, and the user starts it a second time. What should happen?
* `#NoEnv` - turns off expansion of empty variables to environment variables. By default, AutoHotkey will try to replace empty variables with an environment variable of the same name. This directive turns this feature off and improves performance.
* `#CommentFlag` - changes the character that is used to mark a comment. This directive (and several others) are **not recommended** because they make it difficult for others to use your code. They are also removed in AutoHotkey v2.

### positional directives
Positional directives of course also affect the script, but the place where they are used matters, and using them multiple times isn't automatically nonsense. You can affect hotkeys and hotstrings, include code in your script and do a lot more things.

Important positional directives include:
* `#Include` - includes an other script file in the current script. It behaves just as if the code was copied and pasted. This is typically used to add libraries to your script or to separate your code into logical entities.
* `#IfWinActive` - changes the behaviour of all hotkeys and hotstrings below. This directive makes them only be triggered if the specified window is active - it makes them ***context-sensitive***.
* `#If` - this directive has a similar behaviour to the above one, but it allows more things to be tested. This is only available in AutoHotkey_L and AutoHotkey v2.
