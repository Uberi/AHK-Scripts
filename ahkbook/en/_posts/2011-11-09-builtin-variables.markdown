---
title: The power of built-in variables
layout: post
permalink: /en/builtin-variables.html
---

# The power of built-in variables

## What are built-in variables?
As the name says, built-in variables are built-in. Their content is not filled by the user but by AutoHotkey itself.
There are several differences with their handling:

* built-in variables are available *everywhere*, in the auto-execute section, any label and any user-defined function
* the content of a built-in variable can not be changed directly by the user (some exceptions listed below)
* all built-in variables begin with an `A_` prefix, except for `ErrorLevel`, `ComSpec` and `ProgramFiles` (which is also available as `A_ProgramFiles`)

**Note:** In AutoHotkey v2 and AutoHotkey\_H v2, the `ComSpec` and `ProgramFiles` variables are removed (and `A_ComSpec` is introduced).

### Setting the content
As noted above, you usually can't change the content of a built-in variable. There are 2 exceptions of that rule:

* `ErrorLevel` can be set
* IronAHK uses built-in variable assignment to replace some commands such as `SetWorkingDir C:\Any\Dir` by `A_WorkingDir := "C:\Any\Dir"`

## Which variables are available?
There are way too much built-in variables to list them all here. The areas they cover reach from `A_Space` over script properties, date & time, script settings, user idle time, GUI variables, OS info up to things like `A_LastHotkey`.

A list of them can be found in the respective manual. Online links:
* [AutoHotkey classic](http://www.autohotkey.com/docs/Variables.htm#BuiltIn)
* [AutoHotkey\_L](http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/Variables.htm#BuiltIn)

## booleans
Additionally to those listed in the links above, AutoHotkey has the built-in variables (or constants) **true** and **false**. IronAHK also introduces **null**.
