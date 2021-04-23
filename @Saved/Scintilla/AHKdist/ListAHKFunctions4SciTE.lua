#!Lua50.exe
--[[
List the functions, labels and hotstuff (hotkeys, hotstrings, key remapping)
in an AutoHotkey script.

by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
File/Project history:
 1.03.000 -- 2006/11/30 (toralf & PL) -- Better detection of hotstuff,
             splitted between hotkeys (and key remapping) and hotstrings.
 1.02.001 -- 2006/11/29 (PL) -- Making labels more tolerant.
 1.02.000 -- 2006/11/25 (PL) -- SciTE version.
 1.01.000 -- 2006/11/24 (PL) -- Minor changes.
 1.00.000 -- 2006/11/23 (PL) -- Creation.
]]
--[[ Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006 Philippe Lhoste / PhiLhoSoft
]]

------------------------------------------------------------------------------
-- Functions to handle complex regular expressions
------------------------------------------------------------------------------
-- Lua's RE don't take repetition symbols on sub-patterns, only on char classes!
-- I have to add functions to manage this...

-- Check if past the given position, the line ends with a comment
-- (or just whitespace/nothing).
local function IsEndingComment(line, pos)
	if pos == 1 and string.find(line, "^%s*;") ~= nil then
		-- Line with only comment, skip it
		return true
	end
	if string.find(line, "^%s*$", pos) ~= nil then
		-- Line ending with nothing or whitespace only
		return true
	end
	-- Go back one step to ensure there is at least one whitespace before the comment:
	-- This function is often called after eating all whitespace at end of previous matching.
	if pos > 1 and string.find(line, "^%s+;", pos - 1) ~= nil then
		return true
	end
	return false
end

local function IsFunction(line, bOnlyCheckParam)
	-- Legal characters for AHK identifiers
	local identifierRE = '][#@$?_%w'
	-- Legal characters in function definition parameter list
	local parameterListRE = identifierRE .. ',=".%s-'

	local bHasClosingParen, bHasOpeningBrace
	local fs, fe, fName, fParameters, fClosingParen, fOpeningBrace
	if bOnlyCheckParam then
		fs, fe, fParameters, fClosingParen, fOpeningBrace =
				string.find(line, "^%s*(,[" ..
						parameterListRE .. "]+)(%)?)%s*({?)%s*")
	else
		fs, fe, fName, fParameters, fClosingParen, fOpeningBrace =
				string.find(line, "^%s*([" .. identifierRE .. "]+)%(([" ..
						parameterListRE .. "]*)(%)?)%s*({?)%s*")
	end
	if fs ~= nil then
		bHasClosingParen = fClosingParen == ')'
		bHasOpeningBrace = fOpeningBrace == '{'
		if bHasOpeningBrace and not bHasClosingParen then
			-- Bad syntax...
			return false
		end
		if not IsEndingComment(line, fe + 1) then
			-- Probably parameters are expressions
			return false
		end
		return true, fName, fParameters,
				bHasClosingParen, bHasOpeningBrace
	end
	return false
end

local function IsHotkey(line)
	-- Legal characters in hotkey definition. Double-colon is now legal, but I won't handle it!
	local hkcRE = "[^%s:][^%s:]-" -- Same as [^%s:]+? in other engines
	local fs, hotkeyName
	fs, _, hotkeyName = string.find(line, "^%s*(" .. hkcRE .. ")::")
	if (fs == nil) then
		fs, _, hotkeyName = string.find(line, "^%s*(" .. hkcRE .. "%s+[uU][pP])::")
	end
	if (fs == nil) then
		fs, _, hotkeyName = string.find(line, "^%s*(" .. hkcRE .. "%s+&%s+" .. hkcRE .. ")::")
	end
	if (fs == nil) then
		fs, _, hotkeyName = string.find(line, "^%s*(" .. hkcRE .. "%s+&%s+" .. hkcRE .. "%s+[uU][pP])::")
	end
	if (fs ~= nil) then
		return true, hotkeyName
	end
	return false
end

------------------------------------------------------------------------------
-- State management routines
------------------------------------------------------------------------------

local State = {}
State.m_state = {}

function State.Set(k, message)
	State.m_state = { [k] = true }
end
function State.Add(k, message)
	State.m_state[k] = true
end
function State.Remove(k, message)
	State.m_state[k] = nil
end
function State.Is(k)
	return State.m_state[k]
end

------------------------------------------------------------------------------
-- The parser
------------------------------------------------------------------------------

function ListAutoHotkeyFunctions()

local functionList, labelList, hotkeyList, hotstringList = {}, {}, {}, {}
local functionNb, labelNb, hotkeyNb, hotstringNb = 1, 1, 1, 1
local lineNb = 1
State.Set"DEFAULT"
for line in AllLines() do
	if IsEndingComment(line, 1) then
		--Empty line or line with comment, skip it
		-- We do nothing...
	elseif State.Is"COMMENT" then
		-- In a block comment
		if string.find(line, "^%s*%*/") ~= nil then
			-- End of block comment
			State.Remove("COMMENT", "end of comment")
			-- "*/ function_def()" is legal but quite perverse... I won't support this
		end
	elseif State.Is"CONTSECTION" then
		-- In a continuation section
		if string.find(line, "^%s*%)") ~= nil then
			-- End of continuation section
			State.Set("DEFAULT", "end of continuation section")
		end
	elseif string.find(line, "^%s*/%*") ~= nil then
		-- Start of block comment, to skip
		State.Add"COMMENT"
	elseif string.find(line, "^%s*%(") ~= nil then
		-- Start of continuation section, to skip
		State.Set"CONTSECTION"
	else
		local fs, fe
		-- Correct detection of hotstuff (hotstrings, hotkeys, key remapping) is tricky
		-- but has been solved by toralf, Thanks!
		-- Some false positives are still possible (eg. MsgBox Up::) but very unlikely!
		local bIsHotkey, hotkeyName = IsHotkey(line)
		if bIsHotkey then
			hotkeyList[hotkeyNb] = { name = hotkeyName, line = lineNb }
			hotkeyNb = hotkeyNb + 1
			State.Set("DEFAULT", "Hotkey: " .. hotkeyName)
		else
			-- I simplified the expression for hotstrings (smaller=faster) as we don't really care to
			-- have exact syntax of options...
			local hotstringName
			fs, fe, hotstringName = string.find(line, "^%s*:[*?%w%d-]*:(..-)::")
			if fs ~= nil then
				hotstringList[hotstringNb] = { name = hotstringName, line = lineNb }
				hotstringNb = hotstringNb + 1
				State.Set("DEFAULT", "Hotstring: " .. hotstringName)
			else
				-- Labels are very tolerant...
				-- Note: L:L: is a legal label, but I won't handle this special case.
				-- Likewise, labels starting with an opening parenthesis will be seen as continuation section start.
				-- I hope it is unlikely to meet them...
				local labelName
				fs, fe, labelName = string.find(line, "^%s*([^%s,:;`][^%s,:`]*):%s*")
				if fs ~= nil and IsEndingComment(line, fe + 1) then
					labelList[labelNb] = { name = labelName, line = lineNb }
					labelNb = labelNb + 1
					State.Set("DEFAULT", "Label: " .. labelName)
				elseif State.Is"DEFAULT" then
					local bIsFunction, functionName, functionParameters,
							bHasClosingParen, bHasOpeningBrace = IsFunction(line, false)
					if bIsFunction then
						-- Found a function call or a function definition
						State.Set("FUNCTION", functionName)
						functionList[functionNb] = { name = functionName, line = lineNb, parameters = functionParameters }
						if bHasClosingParen then
							-- With closed parameter list
							if bHasOpeningBrace then
								-- Found! This is a function definition
								functionNb = functionNb + 1	-- Validate the finding
								State.Set("DEFAULT", "Function def!")
							else
								-- List of parameters is closed, just search for opening brace
								State.Add"TOBRACE"
							end
						else
							-- With open parameter list
							-- Search for closing parenthesis
							State.Add"INPARAMS"
						end
					end
				elseif State.Is"FUNCTION" then
					-- After a function definition or call
					if State.Is"INPARAMS" then
						-- Looking for ending parenthesis
						bIsFunction, functionName, functionParameters,
								bHasClosingParen, bHasOpeningBrace = IsFunction(line, true)
						if bIsFunction then
							-- Correct additional set of parameters
							functionList[functionNb].parameters = functionList[functionNb].parameters ..
									functionParameters
							if bHasClosingParen then
								-- With closed parameter list
								if bHasOpeningBrace then
									-- Found! This is a function definition
									functionNb = functionNb + 1	-- Validate the finding
									State.Set("DEFAULT", "Function def!")
								else
									-- List of parameters is closed, just search for opening brace
									State.Remove"INPARAMS"
									State.Add"TOBRACE"
								end
							end
							-- Otherwise, we continue
						else
							-- Incorrect syntax for a parameter list, it was probably just a function call
							State.Set("DEFAULT", "NO function def!")
						end
					elseif State.Is"TOBRACE" then
						-- Looking for opening brace
						-- There can be only empty lines and comments, which are already processed
						fs, fe = string.find(line, "^%s*{%s*")
						if fs ~= nil and IsEndingComment(line, fe + 1) then
							-- Found! This is a function definition
							functionNb = functionNb + 1	-- Validate the finding
							State.Set("DEFAULT", "function def!")
						else
							-- Incorrect syntax between closing parenthesis and opening brace,
							-- it was probably just a function call
							State.Set("DEFAULT", "NO function def!")
						end
					end
				end
			end
		end
	end
	lineNb = lineNb + 1
end

return functionNb - 1, functionList, labelNb - 1, labelList,
		hotkeyNb - 1, hotkeyList, hotstringNb - 1, hotstringList

end
