--[[
SciTEStartup.lua an initialisation script for SciTE

by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
File/Project history:
 1.00.000 -- 2008/07/01 (PL) -- External current version.
]]
--[[ Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2008 Philippe Lhoste / PhiLhoSoft
]]
-- Ctrl+Shift+O on line below (ajust to your path...) to get the list of Scintilla functions.
-- C:\Dev\SciTE\_current\Scintilla\include\Scintilla.iface
-- http://scintilla.sourceforge.net/SciTELua.html
-- http://lua-users.org/wiki/UsingLuaWithScite

-- User Defined Lists
local udl_Separator = "~"
local udl_SuperAbbr = 10
local udl_ListTools = 15
local udl_ListAHKFunctions = 20

------------------------------------------------------------------------------
--- Generic useful functions ---

-- Convert number as hexadecimal string to plain decimal number: H'4488CC'
function H(ns)
	return tonumber(ns, 16)
end

-- Cut a string in several parts, along the given separator (only one char)
function Split(toCut, separator)
	local splitted = {}
	local i = 0
	-- Regular expression:
	-- 0 or more chars different from separator, followed by 0 or 1 separator
	local regEx = "([^" .. separator .. "]*)" .. separator .. "?"
	-- Add a separator at the end, to take in account empty field at the end of the line
	for item in string.gfind(toCut .. separator, regEx) do
		i = i + 1
		splitted[i] = item or ''
	end
	splitted[i] = nil
	return splitted
end

function RepeatEditor(f, n)
	for i = 1, n do
		editor[f](editor)
	end
end

-- Get EOL char(s), assuming consistency in the file
function GetEOL()
	local eol = "\r\n"
	if editor.EOLMode == SC_EOL_CR then
		eol = "\r"
	elseif editor.EOLMode == SC_EOL_LF then
		eol = "\n"
	end
	return eol
end
--~ function GetEOL()
--~ 	local map =
--~ 	{
--~ 		SC_EOL_CRLF = "\r\n",
--~ 		SC_EOL_CR = "\r",
--~ 		SC_EOL_LF = "\n",
--~ 	}
--~ 	return map[editor.EOLMode]
--~ end
--~ function GetEOL()
--~ 	local map =
--~ 	{
--~ 		[SC_EOL_CRLF] = "SC_EOL_CRLF",
--~ 		[SC_EOL_CR] = "SC_EOL_CR",
--~ 		[SC_EOL_LF] = "SC_EOL_LF",
--~ 	}
--~ 	return map[editor.EOLMode]
--~ end

-- From Neil Hodgson
function CenterOnLine(line)
	local topLineWanted = editor:VisibleFromDocLine(line) - editor.LinesOnScreen / 2
	editor:LineScroll(0, topLineWanted - editor.FirstVisibleLine)
end

function GetCurrentLineNumber()
	return editor:LineFromPosition(editor.CurrentPos)
end

-- Given a line number (-1 for the line where the caret is),
-- return the position of the start of the line, of its end, and
-- the number of the line
function GetLineInfo(lineNb)
	if lineNb < 0 then
		lineNb = GetCurrentLineNumber()
	end
	local lineStartPos = editor:PositionFromLine(lineNb)
	local lineEndPos = editor.LineEndPosition[lineNb]
	return lineStartPos, lineEndPos, lineNb
end

-- Return the range of selected lines
function GetSelectionLineRange()
	local startPos, endPos = editor.Anchor, editor.CurrentPos
	-- Right order
	if startPos > endPos then
		startPos, endPos = endPos, startPos
	end
	-- Compute the line numbers
	local startLine = editor:LineFromPosition(startPos)
	local endLine = editor:LineFromPosition(endPos)
	-- Position of the start of the last line
	local lineStartPos = editor:PositionFromLine(endLine)
	-- If equal to end of selection, we don't include this line (classical margin line selection)
	-- unless we are in rectangular selection
	if lineStartPos == endPos  and not editor.SelectionIsRectangle then
		endLine = endLine - 1
	end
	return startLine, endLine
end

-- This one doesn't follow my naming conventions (it would have been ?),
-- because I want it to be usable in place of file:lines().
-- Usage: for line in editor:lines() do ... end
--~ function editor.lines(self)
--~ end

-- Return the string of current line (where the caret is). No EOL.
function GetCurrentLine()
	-- I could have used editor:GetLine(n) but I don't want the EOL
	local lineStartPos, lineEndPos = GetLineInfo(-1)
	return editor:textrange(lineStartPos, lineEndPos)
end

-- Return the selected text and its length.
-- If no text is selected, select the current line and return it.
function GetSelectedText(defaultSel)
	local text, len = editor:GetSelText()
	if len == 0 then
		if defaultSel == 'line' then
			-- No selection, select the current line with EOL
			text, len = SelectCurrentLine(true)
		elseif defaultSel == 'word' then
			text, len = SelectCurrentWord()
		else
			print"Bad parameter for GetSelectedText!"
		end
	end
	return text, len
end

function SelectCurrentLine(bWithEOL)
	local lineStartPos, lineEndPos = GetLineInfo(-1)
	if bWithEOL then
		local eol = editor.CharAt[lineEndPos]
		if eol == 10 or eol == 13 then
			lineEndPos = lineEndPos + 1
			eol = editor.CharAt[lineEndPos]
			if eol == 10 then
				lineEndPos = lineEndPos + 1
			end
		end
	end
	editor:SetSel(lineStartPos, lineEndPos)
	return editor:GetSelText()
end

function SelectCurrentWord()
	editor:WordRight()
	editor:WordLeftExtend() -- Could be better, if followed by spaces, select these spaces too...
	return editor:GetSelText()
end

function ReplaceLine(lineNb, line)
	local lineStartPos, lineEndPos = GetLineInfo(lineNb)
	editor:SetSel(lineStartPos, lineEndPos)
	-- Replace line with result
	-- Operation can be canceled with a single Undo
	editor:ReplaceSel(line)
end

-- We often act on the line where the cursor is
function ReplaceCurrentLine(line)
	ReplaceLine(GetCurrentLineNumber(), line)
end

-- Iterators
function AllLines()
	local currentLineNb = -1
	local totalLineNb = editor.LineCount
	return function ()
		currentLineNb = currentLineNb + 1
		if currentLineNb < totalLineNb then
			return editor:GetLine(currentLineNb)
		end
	end
end

function AllSelectedLinePos()
	local startLine, endLine = GetSelectionLineRange()
	local currentLineNb = startLine - 1
	return function ()
		currentLineNb = currentLineNb + 1
		if currentLineNb <= endLine then
			return currentLineNb
		end
	end
end


 function MarkText(position, length, indicator)
	editor:StartStyling(position, INDICS_MASK)
	editor:SetStyling(length, INDIC0_MASK + indicator)
	editor:SetStyling(2, 0)
 end

------------------------------------------------------------------------------
--- Tips ---

function SwitchToBuffer(index)
	MenuCommand(1200 + index)
end

function UpdateStatusBar(message)
	props['LuaInfoMessage'] = message
--~ 	scite.UpdateStatusBar()
end

--[[
function clearOccurrences()
     scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)
end

function markOccurrences()
     clearOccurrences()
     scite.SendEditor(SCI_INDICSETSTYLE, 0, INDIC_CONTAINER)
     scite.SendEditor(SCI_INDICSETFORE, 0, 0x0000FF)
     local txt = GetCurrentWord()
	if(txt == nil) then return; end;
     local flags = SCFIND_WHOLEWORD
     local s,e = editor:findtext(txt,flags,0)
     while s do
         scite.SendEditor(SCI_INDICATORFILLRANGE, s, e - s)
         s,e = editor:findtext(txt,flags,e+1)
     end
end

function isWordChar(char)
     local strChar = string.char(char)
     local beginIndex = string.find(strChar, '%w')
     if beginIndex ~= nil then
         return true
     end
     if strChar == '_' or strChar == '$' then
         return true
     end

     return false
end

function GetCurrentWord()
     local beginPos = editor.CurrentPos
     local endPos = beginPos
     if editor.SelectionStart ~= editor.SelectionEnd then
         return editor:GetSelText()
     else
		while isWordChar(editor.CharAt[beginPos-1]) do
			beginPos = beginPos - 1
		end
		while isWordChar(editor.CharAt[endPos]) do
			endPos = endPos + 1
		end
		if(beginPos ~= endPos) then
			return editor:textrange(beginPos,endPos)
		else
			return nil
		end
	end
end
]]

------------------------------------------------------------------------------
--- Tool functions ---

-- Add braces { } (or soft brackets) around the selected line(s),
-- or if there is no selection, around the current line.
-- Assume *whole* lines are selected, including EOLs.
-- Also suppose selected text is already at right indentation level,
-- either to add braces around the single line of an existing if (for, while, etc.),
-- or tabbing the selection before performing this operation.
function AddBraces()
	-- Get selection or if none, current line
	local text, len = GetSelectedText('line')
	if len == 0 then return end -- Empty buffer!
	local eol = GetEOL()
	-- Get indentation level (run of tabs or spaces at start of line)
	local _, _, indent, nextChar = string.find(text, "^([\t ]+)(.)")
--~ 	print('|' .. (indent or 'nil') .. '|' .. (nextChar or 'nil') .. '|' .. text .. '|')
	if indent ~= nil then
		if nextChar ~= nil and nextChar ~= '\n' and nextChar ~= '\r' then
			if string.sub(indent, 1, 1) == '\t' then
				-- One tab less
				indent = string.sub(indent, 2)
			else	-- Indent with spaces
				-- Skip number of ident spaces
				indent = string.sub(indent, 1 + editor.Indent)
			end
		-- ELSE, we have a line with only whitespace,
		-- chances are we are just after a if/for/while... (with option indent.maintain)
		-- and just want braces at same level
		end
	else	-- Not indented, leave as is
		indent = ''
	end
	text = indent .. '{' .. eol ..
			text .. -- Selection is left unchanged
			indent .. '}' .. eol
	editor:ReplaceSel(text)
	editor:LineUp(); editor:LineUp() -- Go between the braces
end

function AddPercents()
	local text, len = GetSelectedText('word')
	if len == 0 then return end -- Empty buffer!
--~ 	text = '%' .. text .. '%'
	text = '[color=indigo][b]' .. text .. '[/b][/color]'
	editor:ReplaceSel(text)
end

--~ tagStart = [[]]
--~ tagEnd = [[]]
--~ tagStart = [[<label for="">]]
--~ tagEnd = [[</label>]]
--~ tagStart = [[<h3><a name="|" id="|">]]
--~ tagEnd = [[</a></h3>]]
--~ tagStart = [[<code>]]
--~ tagEnd = [[</code>]]
tagStart = [[<em>]]
tagEnd = [[</em>]]

function AddXMLTag()
	local text, len = GetSelectedText('word')
	if len == 0 then return end -- Empty buffer!
--~ 	local ts = string.gsub(tagStart, "|", text);
--~ 	editor:ReplaceSel(ts .. text .. tagEnd)
	editor:ReplaceSel(tagStart .. text .. tagEnd)
end

------------------------------------------------------------------------------
--- SVG functions ---
--[[
-- Reduce floating point precision of coordinate pairs in an SVG file
function ReduceFPP2()
	-- Read current selection
	local text, len = editor:GetSelText()
	-- Search FP number pairs separated by comas
	-- and provide them to a function that round them
	-- and spit them out to replace orignal values
	text = string.gsub(text, "([.%d]+),([.%d]+)",
		function (n1, n2)
			return math.floor(n1*10 + 0.5)/10 .. ',' ..
						 math.floor(n2*10 + 0.5)/10
		end)
	-- Replace current selection with modified text
	editor:ReplaceSel(text)
end

-- Reduce floating point precision of coordinates in an SVG file
function ReduceFPP()
	-- Read current selection
	local text, len = editor:GetSelText()
	-- Search FP numbers
	-- and provide them to a function that round them
	-- and spit them out to replace orignal values
	text = string.gsub(text, "([.%d]+)",
		function (n)
			return math.floor(n*10 + 0.5)/10
		end)
	-- Replace current selection with modified text
	editor:ReplaceSel(text)
end

-- Find min and max of coordinates in an SVG file
function FindMinMax()
	local min, max = 1000000000, 0
	-- Read current selection
	local text, len = editor:GetSelText()
	-- Search FP numbers
--	local inb = 0
	for n in string.gfind(text, "([.%d]+)") do
		local nn = tonumber(n)
		if nn ~= nil then
--		inb = inb + 1
			if nn > max then max = nn end
			if nn < min then min = nn end
--print(inb, nn, min, max)
		end
	end
	-- Display result
	print(min, max)
end
]]
------------------------------------------------------------------------------
--- Various functions ---

function Sort2(el1, el2)
	if el1[2] == '' and el2[2] == '' then
		return false
	end
	if el1[2] == '' then
		return false
	end
	if el2[2] == '' then
		return true
	end
	-- Convert to number to avoid having 13 > 111...
	return tonumber(el1[2]) < tonumber(el2[2])
end

-- Sort a buffer made of tab-separated fields.
-- Sort along the FIELD_TO_SORT column.
-- The Sort function contains the real comparison.
function SortTable()
	local FIELD_TO_SORT = 1
	local lineNb = editor.LineCount
	local firstLine = editor:GetLine(0)
	local toSort = {}
	local line, parts
	-- Skip first line, if it is the title line
	-- Skip last line, it should be empty, because all lines must be ended with newline char(s)
	for i = 1, lineNb - 2 do
		line = editor:GetLine(i)
		if line ~= nil then
			parts = Split(line, '\t')
			-- Store line number, key and real line
			-- Line number isn't used here...
			-- Perhaps we can avoid to store line, and swap
			-- the lines according to old line number.
			-- It would use less memory but would be probably slower.
			toSort[i] = { i, parts[FIELD_TO_SORT], line }
		end
	end
	-- Do the sort!
	table.sort(toSort, Sort2)
	-- Replace whole text with result
	editor:BeginUndoAction()
	-- Overwrite buffer content with first line (title)
	editor:SetText(firstLine)
	-- Append each line to the end of the buffer
	for i = 1, lineNb - 2 do
--~ 		editor:InsertText(editor.Length, toSort[i][3])
		editor:AppendText(toSort[i][3])
	end
	-- Sort can be cancelled with a single Undo
	editor:EndUndoAction()
end

-- Sort all lines in buffer.
function SortAllLines()
	local lineNb = editor.LineCount
	local toSort = {}
	local line, parts
	for i = 1, lineNb do
		line = editor:GetLine(i - 1)
		if line ~= nil then
			if string.find(line, "[\r\n]$") == nil then
				line = line .. "\r\n"
			end
			toSort[i] = line
		end
	end
	-- Do the sort!
	table.sort(toSort, function (e1, e2) return e1 < e2 end )
	-- Replace whole text with result
	editor:BeginUndoAction()
	-- Overwrite buffer content with empty string
	editor:SetText("")
	-- Append each line to the end of the buffer
	for i = 1, lineNb do
--~ 		editor:InsertText(editor.Length, toSort[i][3])
		editor:AppendText(toSort[i])
	end
	-- Sort can be cancelled with a single Undo
	editor:EndUndoAction()
end

function GetNumbers(line)
	local _, _, n1, n2 = string.find(line, "%w+%(([-%d]+), ([-%d]+)%)")
	return tonumber(n1), tonumber(n2)
end

--~ function SortDump(el1, el2)
--~ 	n11, n12 = GetNumbers(el1)
--~ 	n21, n22 = GetNumbers(el2)
--~ 	if n11 == n21 then
--~ 		return n12 < n22
--~ 	else
--~ 		return n11 < n21
--~ 	end
--~ end

--~ function SortDump(el1, el2)
--~ 	local _, _, id1 = string.find(el1, "products_id = (%d+);")
--~ 	local _, _, id2 = string.find(el2, "products_id = (%d+);")
--~ 	if id1 == nil or id2 == nil then return false end
--~ 	return id1 + 0 < id2 + 0
--~ end

--~ function SortDump(el1, el2)
--~ 	local u1, u2 = true, true
--~ 	local _, _, id1 = string.find(el1, "products_id = (%d+);")
--~ 	if id1 == nil then
--~ 		_, _, id1 = string.find(el1, "^%((%d+),")
--~ 		u1 = false
--~ 	end
--~ 	local _, _, id2 = string.find(el2, "products_id = (%d+);")
--~ 	if id2 == nil then
--~ 		_, _, id2 = string.find(el2, "^%((%d+),")
--~ 		u2 = false
--~ 	end
--~ 	if id1 == nil or id2 == nil then return false end
--~ 	if id1 == id2 then return u1 end
--~ 	return id1 + 0 < id2 + 0
--~ end

function SortDump(el1, el2)
	local u1, u2 = true, true
	local _, _, id1 = string.find(el1, "WHERE products_id = (%d+);")
	if id1 == nil then
		_, _, id1 = string.find(el1, "WHERE products_id = (%d+) ")
		u1 = false
	end
	local _, _, id2 = string.find(el2, "WHERE products_id = (%d+);")
	if id2 == nil then
		_, _, id2 = string.find(el2, "WHERE products_id = (%d+) ")
		u2 = false
	end
	if id1 == nil or id2 == nil then return false end
	if id1 == id2 then return u1 or u2 end
	return id1 + 0 < id2 + 0
end

-- Sort the selection, using more or less smart algorithm.
function SortSelectedLines()
	local startLine, endLine = GetSelectionLineRange()
	local toSort = {}
	for i = startLine, endLine do
		local line = editor:GetLine(i)
		if line ~= nil then
			toSort[i - startLine + 1] = line
		end
	end
	-- Do the sort!
	-- Primitive sort
--~ 	table.sort(toSort, function (e1, e2) return e1 < e2 end)
	-- Sorting on a part of the line
	table.sort(toSort, SortDump)
	-- Replace whole text with result
	-- Sort can be cancelled with a single Undo, because it is an atomic operation
	editor:ReplaceSel(table.concat(toSort))
end

-- Convert .ses file loaded in current buffer to a .session file in .properties format
function ConvertSesFile()
	print"ConvertSesFile"
	local session, bufferNb = '', 1
	for line in AllLines() do
		local pos, path, bCurrent = 0, '', false
		_, _, pos, path = string.find(line, "<pos=(-?%d+)> (.*)")
		pos = tonumber(pos)
		if pos < 0 then
			pos = -pos
			bCurrent = true
		end
		session = session .. 'buffer.' .. bufferNb .. '.path=' .. path ..
				'buffer.' .. bufferNb .. '.position=' .. pos .. '\n'
		if bCurrent then
			session = session .. 'buffer.' .. bufferNb .. '.current=1\n\n'
		else
			session = session .. '\n'
		end
		print(bufferNb)
		bufferNb = bufferNb + 1
	end
	-- Replace whole text with result
	editor:BeginUndoAction()
	-- Overwrite buffer content with converted lines
	editor:SetText(session)
	-- Operation can be cancelled with a single Undo
	editor:EndUndoAction()
end
--[[
buffer.1.path=c:\SciTE\src-session\scite\src\SciTEBuffers.cxx
buffer.1.position=395
buffer.1.current=1
]]

function CapitalizeLines()
	local lineNb = editor.LineCount
	local line, substNb
	editor:BeginUndoAction()
	-- Skip last line, it should be empty, because all lines must be ended with newline char(s)
	for i = lineNb - 2, 0, -1 do
		line = editor:GetLine(i)
		if line ~= nil then
			-- Replace words in all upper-case to words with only initial upper-case
			line, substNb = string.gsub(line, "([A-ZÀ-Ý])([A-ZÀ-Ý]+[ ,;-])",
					function (c, s)
						return c .. string.lower(s)
					end)
			line = string.gsub(line, "[\r\n]", "");
			ReplaceLine(i, line, false)
		end
	end
	editor:EndUndoAction()
end

-- Zen Cart French Translation Utility
function LowerCaseWords()
	local line, substNb = GetCurrentLine(), 0
	-- Trim initial space
--	line, substNb = string.gsub(line, "^%s+define(.*)", "define%1")
	-- Except after a dot, replace a word starting with an initial upper-case by a lower-case word
	line, substNb = string.gsub(line, "([^.][ ;][A-Z])([^A-Z])",
			function (c, s) return string.lower(c) .. s end)
	if substNb > 0 then
		ReplaceCurrentLine(line)
	else
		output:AppendText(line)
	end
	editor:CharRight()
end

-- Unfinished, but can be used as starting point for something else...
function GetTextInTags()
	local leftmostPos, rightmostPos

	local initialPos = editor.CurrentPos
	local startLineNb = editor:LineFromPosition(initialPos)
	local lineStartPos = editor:PositionFromLine(startLineNb)
	local lineNb = startLineNb
	local startP, endP, tag
	local pos = initialPos
	while true do
		local before = editor:textrange(lineStartPos, pos)
		print(before)
		-- Get rightmost tag (it doesn't work...)
		startP, endP, tag = string.find(before, "^.*<(%a+).-$")
		if startP == nil then
			-- Not found: search on previous line
			if lineNb > 0 then
				lineNb = lineNb - 1
				pos = lineStartPos - 1
				lineStartPos = editor:PositionFromLine(lineNb)
			else
tag = SOF
				break	-- Reached start of file
			end
		else
			break	-- Found
		end
	end
	print(startP, endP, tag)
	if startP ~= nil then
		startP = lineStartPos + startP
		local before = editor:textrange(startP, initialPos)
		print(before)
--~ 		leftmostPos = string.find(before, "")
	end
end

-- Trim all spaces and split line in fixed length chunks
function Normalize()
	local chunkLength = 5
	local line = GetCurrentLine()
	-- Trim all spaces
	line = string.gsub(line, "%s", '')
	-- Make a regexp matching n chars (Lua's regexp are limited...)
	local matcher = '(' .. string.rep('.', chunkLength) .. ')'
	-- Add a space every n chars
	line = string.gsub(line, matcher,
			function (chunk) return chunk .. ' ' end)
	-- Previous gsub may have added an extra space at end
	line = string.gsub(line, "%s$", '')
	ReplaceCurrentLine(line)
end

function FunnyCaps()
	local line = GetCurrentLine()
	line = string.gsub(line, ".", function (c)
		if math.random(10) > 7 then
			return string.upper(c)
		else
			return c
		end
	end)
	ReplaceCurrentLine(line)
end

function FixKeywords()
	local lineNb = editor.LineCount
	local line, sn, substNb
	editor:BeginUndoAction()
	-- Skip last line, it should be empty, because all lines must be ended with newline char(s)
	for i = lineNb - 2, 0, -1 do
		line = editor:GetLine(i)
		if line ~= nil then
			-- If the line starts with a keyword needing to start with a parenthese, put a space between them
			line = string.gsub(line, "[\r\n ]*$", "")
			line, substNb = string.gsub(line, "^( +)(%l+)%(",
					function (s, kw)
						if kw == "if" or kw == "for" or kw == "while" or
								kw == "switch" or kw == "synchronized" or kw == "catch" then
							return s .. kw .. " ("
						else
							return s .. kw .. "("	-- No changes
						end
					end)
			-- Some special cases...
			line, sn = string.gsub(line, "^( +)} ?while%(", "%1} while (")
			substNb = substNb + sn
			line, sn = string.gsub(line, "^( +)else if%(", "%1else if (")
			substNb = substNb + sn
			if substNb > 0 then
--~ print(i .. '>' .. line .. '<' )
				ReplaceLine(i, line, false)
			end
		end
	end
	editor:EndUndoAction()
end

function AddTotalSubst(tTotalSubstNb, substNb)
	tTotalSubstNb[1] = tTotalSubstNb[1] + substNb
end

function ChangeLine(line, pattern, subst, tTotalSubstNb)
	local line, substNb = string.gsub(line, pattern, subst)
	AddTotalSubst(tTotalSubstNb, substNb)
	return line
end

-- Normalize Java (or most C-like languages) code line along some code rules
function NormalizeJava()
	local line = GetCurrentLine()
	local castNb, substNb = 0, 0, 0
	tsnb = { 0 }

	-- Transform one line comment to doc comment
--~ 	line = ChangeLine(line, "^(%s+)// *(.*) *$", "%1/** %2. */", tsnb)
	line, substNb = string.gsub(line, "^(%s+)// *(.)(.*) *$",
			function(spaces, initial, comment)
				return spaces .. "/** " .. string.upper(initial) .. comment .. ". */"
			end)
	if substNb > 0 then
		ReplaceCurrentLine(line)
		return
	end

	-- Protect cast
	line, castNb = string.gsub(line, " %(([][%w]+)%)(.)",
		function (s, c)
			if c == ' ' then
				c = ''
			else
				AddTotalSubst(tsnb, 1)
			end
			return " µ" .. s .. "¤ " .. c
		end)

	-- Generic punctuation
	line = ChangeLine(line, " *, *", ", ", tsnb)
	line = ChangeLine(line, " *; *", "; ", tsnb)
	line = ChangeLine(line, " *([*/+-]=) *", " %1 ", tsnb)
	line = ChangeLine(line, "([^!><=*/+-]) *([!><=]+) *", "%1 %2 ", tsnb)

	-- return and assert take no parentheses
	line = ChangeLine(line, "^( +)return *%( *(.-) *%) *; *$", "%1return %2;", tsnb)
	line = ChangeLine(line, "^( +)assert *%( *(.-) *%) *; *$", "%1assert %2;", tsnb)
	line = ChangeLine(line, "^( +)assert *%( *(.-) *%) *:", "%1assert %2 :", tsnb)

	line = ChangeLine(line, "^( +)DEBUG.ASSERT *%( *(.-), *(.-) *%) *; *$", "%1assert %2 : %3;", tsnb)
	line = ChangeLine(line, "^( +)DEBUG.ASSERT *%( *(.-) *%) *; *$", "%1assert %2;", tsnb)

	-- Add a space (if needed) after a keyword followed by a parenthesis
	line, substNb = string.gsub(line, "^( +)(%l+)%(",
			function (s, kw)
				if kw == "if" or kw == "for" or kw == "while" or
						kw == "switch" or kw == "synchronized" or kw == "catch" then
					return s .. kw .. " ("
				else
					return s .. kw .. "("	-- No changes
				end
			end)
	AddTotalSubst(tsnb, substNb)
	-- Some special cases...
	line = ChangeLine(line, "^( +)} ?while%(", "%1} while (", tsnb)
	line = ChangeLine(line, "^( +)else if%(", "%1else if (", tsnb)

	-- Add space (if needed) after an opening parenthesis or bracket, unless followed by a closing one
	repeat
		line, substNb = string.gsub(line, "([([])([^]) ])", "%1 %2")
		AddTotalSubst(tsnb, substNb)
	until substNb == 0
	-- Add space (if needed) before a closing parenthesis or bracket, unless followed by an opening one
	repeat
		line, substNb = string.gsub(line, "([^([ ])([])])", "%1 %2")
		AddTotalSubst(tsnb, substNb)
	until substNb == 0

	-- Restore cast
	if castNb > 0 then
		line = string.gsub(line, "µ([][%w]+)¤", "(%1)")
	end

	-- Do something only if needed
	if tsnb[1] > 0 then
		ReplaceCurrentLine(line)
	end
end

-- Normalize deviantART messages...
function NormalizeDA()
	local line = GetCurrentLine()
	local cn1, cn2, cn3 = 0, 0, 0

	--     *   [X]    ~0Hamster0 has added Is this deviant watching you? to their favourites.  Nov 29, 2007, 9:58 PM
	line, cn1 = string.gsub(line, "^.*%]%s+([^ ]+) has added (.*) to their favourites%.%s+(.*)$", "%1\t%2\t%3")
	--     * [X] =frozenpandaman has added you to their friends list. Dec 1, 2007, 9:14 PM
	line, cn2 = string.gsub(line, "^.*%]%s+([^ ]+) has added you to their friends list%.%s+(.*)$", "%1\t%2")
	--     * [X] =luffsfromafriend has added Watching you? v1.3 to the collection BROWSER SCRIPTS Feb 22, 2008, 4:57 PM
	line, cn3 = string.gsub(line, "^.*%]%s+([^ ]+) has added (.*) to the collection (.*)%s+(%u%l%l %d.*)$", "%1\t%2\t%4\tcollection %3")

	-- Do something only if needed
	if cn1 + cn2 + cn3 > 0 then
		ReplaceCurrentLine(line)
	end
end

-- A lexer specific function
function HelperFunction()
	local ext = string.lower(props["FileExt"])
	if ext == "ahk" then
		ShowAHKFunctions()
	elseif ext == "java" then
		NormalizeJava()
	elseif ext == "css" then
		ExpandContractCSS()
	elseif ext == "cxx" then
		TestTest()
	end
	if props["FileNameExt"] == "Deviations.txt" then
		NormalizeDA()
	end
end

function TestTest()
	local selType = editor.SelectionMode
	if selType == 1 then -- SC_SEL_RECTANGLE
		print(editor.SelectionIsRectangle)
	else
		print("No rectangular selection!")
		return
	end
	for lineNb in AllSelectedLinePos() do
		local startPos = editor:GetLineSelStartPosition(lineNb)
		local endPos = editor:GetLineSelEndPosition(lineNb)
		local text = editor:textrange(startPos, endPos)
		print('[' .. lineNb .. '] ' .. text)
	end
end

-- We assume we have either a CSS definition on one line or
-- on several, but the caret is always on the first line.
function ExpandContractCSS()
	local line = GetCurrentLine()
	local newForm
	if string.find(line, "}") then
		-- On one line
		newForm = string.gsub(line, "; *", ";\r\n  ")
		newForm = string.gsub(newForm, "{ *", "{\r\n  ")
		newForm = string.gsub(newForm, " *}", "}")
	else
		-- To contract
		-- Well, just use Ctrl+Z!
	end
	if newForm ~= nil then
		ReplaceCurrentLine(newForm)
	end
end

-- Toggle boolean values
-- DaveMDS and Steve Donovan
--[[
local replacements = {
   ["TRUE"] = "FALSE", ["FALSE"] = "TRUE",
   ["YES"]="NO", ["NO"]="YES",
   ["0"]="1", ["1"]="0",
}

function Toggle()
    local StartPos = editor.CurrentPos
    editor:WordRight()
    editor:WordLeftExtend()
    local Word = editor:GetSelText()
    local was_lowercase = string.find(Word,"^[a-z]")
    local repl = replacements[string.upper(Word)]
    if was_lowercase then
        repl = string.lower(repl)
    end
    if repl then
        editor:ReplaceSel(repl)
    end
    editor:GotoPos(StartPos)
end
]]


function MakeUpperLower(s)
	return string.upper(string.sub(s, 1, 1)) ..
           string.lower(string.sub(s, 2))
end

function PLToggle()
	local replacements =
	{
		{ "true",  "false" },
		{ "yes",   "no" },
		{ "1",     "0" },
		{ "right", "wrong" },
	}

	local startPos = editor.CurrentPos
	local word = SelectCurrentWord()
	local case = "lower"
	if string.find(word,"[%u][%u]+") ~= nil then
		case = "upper"
	elseif string.find(word,"[%u][%l]+") ~= nil then
		case = "mixed"
	end
	local lword = string.lower(word)
	local repl
	for i, v in ipairs(replacements) do
		if lword == v[1] then repl = v[2]
		elseif lword == v[2] then repl = v[1]
		end
	end
	if repl then
		if case == "upper" then
			repl = string.upper(repl)
		elseif case == "mixed" then
			repl = MakeUpperLower(repl)
		end
		editor:ReplaceSel(repl)
	end
	editor:GotoPos(startPos)
end

function ChangeLineNumberStyle()
--~ 	editor.StyleFore(STYLE_LINENUMBER, 1122884) -- 0x112244
--~ 	editor.StyleBack(STYLE_LINENUMBER, 16746564) -- 0xFF8844
	editor.StyleFore[STYLE_LINENUMBER] = 1122884 -- 0x112244
	editor.StyleBack[STYLE_LINENUMBER] = 16746564 -- 0xFF8844
	print("Fait !")
end

function StyleLine()
	local style1, style2 = 1, 2
	local STYLE_LENGTH = 10
	local lineStartPos, lineEndPos = GetLineInfo(-1)
	editor:StartStyling(lineStartPos, 31)
	for i = 0, (lineEndPos - lineStartPos) / STYLE_LENGTH do
		editor:SetStyling(STYLE_LENGTH, math.mod(i, 2) == 0 and style1 or style2)
	end
	editor.StyleFore[style1] = H'112288'
	editor.StyleFore[style2] = H'44AA66'
	editor.StyleBack[style1] = H'AAFF88'
	editor.StyleBack[style2] = H'AA88FF'
end

-- By Mozer, with little improvements from PL
function CopyBookmarkedLines()
	local ml = 0
	local lines = {}
	while true do
		ml = editor:MarkerNext(ml, 2)
		if (ml == -1) then break end
		table.insert(lines, (editor:GetLine(ml)))
		ml = ml + 1
	end
	editor:CopyText(table.concat(lines))
	UpdateStatusBar('Copied lines: ' .. table.getn(lines))
end

------------------------------------------------------------------------------
--- Functions called by keyboard shortcuts (tests, etc.) ---

function Whatever(p)
--~ 	local text, len = editor:GetSelText()
--~ 	if len == 0 then return end
	local eol = GetEOL()
	print(({
		[SC_EOL_CRLF] = "SC_EOL_CRLF",
		[SC_EOL_CR] = "SC_EOL_CR",
		[SC_EOL_LF] = "SC_EOL_LF",
	})[editor.EOLMode])
	-- Loop on the lines and process them
--~ 	text = string.gsub(text, ".-" .. eol, function (l) return '\t' .. l end)
--~ 	editor:ReplaceSel(text)
end

dofile[[E:/Dev/PhiLhoSoft/Lua/DumpObject.lua]]

function QuickNDirty()
--~ 	LowerCaseWords()
--~ 	CapitalizeLines()
--~ 	Normalize()
--~ 	MarkText(editor.CurrentPos, 10, 2)
--~ 	for k, v in pairs(props) do
--~ 		if (type(k) == "string" or type(k) == "number") and
--~ 				(type(v) == "string" or type(v) == "number") then
--~ 			print((k or 'nil') .. " - " .. (v or 'nil'))
--~ 		end
--~ 	end
	props['DirName'] = string.match(props['FileDir'], "[/\\]([^/\\]-)$")
end

function QuickNDirty_()
--~ 	RepeatEditor("LineUp", 4)
--~ 	editor:Home()
--~ 	RepeatEditor("LineDownExtend", 2)

--~ 	local e = editor
--~ 	local lu = e.LineUp
--~ 	local lde = e.LineDownExtend
--~ 	lu(e); lu(e); lu(e); lu(e)
--~ 	editor:Home()
--~ 	lde(e); lde(e)

--~ 	editor:Clear()
--~ 	editor:LineDown()
--~ 	editor:LineDownExtend(); editor:LineDownExtend(); editor:LineDownExtend(); editor:LineDownExtend(); editor:LineDownExtend()
--~ 	editor:Clear()
end

------------------------------------------------------------------------------

--
function UserListShow(udl, list)
	editorACS = editor.AutoCSeparator
	editor.AutoCSeparator = string.byte(udl_Separator)
	editor:UserListShow(udl, list)
	editor.AutoCSeparator = editorACS
end


--================ Super Abbreviations ================
local abbrList =
{
	["Infinite Loop"] =
	{
		template = [[
for (;;)
{
	|;
}
]],
		posChar = '|'
	},
	["While Loop"] =
	{
		template = [[
while (|)
{
	;
}
]],
		posChar = '|'
	},
	["gsub"] =
	{
		template = [[
string.gsub(s, "^",
	function (s)
		return s
	end)
]],
		posChar = '^'
	},
}

function SuperAbbr()
	local titles = ''
	for t, v in pairs(abbrList) do
		titles = titles .. t .. udl_Separator
	end
	titles = string.sub(titles, 1, -2)
	UserListShow(udl_SuperAbbr, titles)
end

local ahkFunctions = {}
if string.lower(props["FileExt"]) == "ahk" then
	dofile(props["SciteDefaultHome"] .. [[\ListAHKFunctions4SciTE.lua]])
else
	ListAutoHotkeyFunctions = function () return nil end
end

function CreateAHKFunctionList()
	local functionNb, functionList, labelNb, labelList,
			hotkeyNb, hotkeyList, hotstringNb, hotstringList =
					ListAutoHotkeyFunctions()
	if functionNb == nil then return "" end
	local menuItem
	local rf, rl, rhk, rhs = '', '', '', ''
print(functionNb)

	for i = 1, functionNb do
		pl = string.gsub(functionList[i].parameters, "%s%s*", " ")
		menuItem = "F [" .. functionList[i].line .. "] " .. functionList[i].name .. "(" .. pl .. ")"
		rf = rf .. menuItem .. udl_Separator
		ahkFunctions[menuItem] = functionList[i].line
	end
	for i = 1, labelNb do
		menuItem = "L [" .. labelList[i].line .. "] " .. labelList[i].name
		rl = rl .. menuItem .. udl_Separator
		ahkFunctions[menuItem] = labelList[i].line
	end
	for i = 1, hotkeyNb do
		menuItem = "K [" .. hotkeyList[i].line .. "] " .. hotkeyList[i].name
		rhk = rhk .. menuItem .. udl_Separator
		ahkFunctions[menuItem] = hotkeyList[i].line
	end
	for i = 1, hotstringNb do
		menuItem = "S [" .. hotstringList[i].line .. "] " .. hotstringList[i].name
		rhs = rhs .. menuItem .. udl_Separator
		ahkFunctions[menuItem] = hotstringList[i].line
	end

	return string.gsub(rf .. rl .. rhk .. rhs, udl_Separator .. '$', '')
end

function ShowAHKFunctions()
	UserListShow(udl_ListAHKFunctions, CreateAHKFunctionList())
end


-- April White's tool menu generator
-- The functions below must be declared _above_!

local tools =
{
	["Normalize line"] = { 1, Normalize },
	["Sort selected lines"] = { 2, SortSelectedLines },
	["Sort all lines"] = { 3, SortAllLines },
--~ 	["T"] = { 5, F },
}

function LuaTools()
	local tl = {}
	for title, tool in pairs(tools) do
		tl[tool[1]] = title
	end
	local toolList = table.concat(tl, udl_Separator)

	UserListShow(udl_ListTools, toolList)
end

--=====================================================
--- Event Handlers ---
-- Currently, OnOpen, OnSwitchFile, OnSave, OnBeforeSave, OnChar,
-- OnSavePointReached, OnSavePointLeft, OnDoubleClick, OnMarginClick,
-- and OnUserListSelection are supported.

function OnClear()
	return false
end

function OnUserListSelection(lt, choice)
	print("OnUserListSelection: " .. lt .. ", " .. choice)
--~ 	print(FormatSimpleTable(tools))
	if lt == udl_ListTools then
		local tool = tools[choice]
		tool[2]()
		return true
	elseif lt == udl_SuperAbbr then
		editor:InsertText(-1, abbrList[choice]["template"])
		-- Should locate posChar, remove it and put the caret there
		return true
	elseif lt == udl_ListAHKFunctions then
		CreateAHKFunctionList()	-- Re-create the list
		editor:GotoLine(ahkFunctions[choice] - 1)
		return true
	else
		return false
	end
end

function OnSwitchFile(filename)
--~ 	print("Lua sample: switched to " .. filename)
	UpdateProps(filename)
	return false	-- Let next handler to process event
end

function OnOpen(filename)
	UpdateProps(filename)
	return false	-- Let next handler to process event
end

function UpdateProps(filename)
	local dirName = string.match(filename, "[/\\]([^/\\]-)[/\\][^/\\]-$")
	if dirName == nil then -- Eg. at root
		dirName = ''
	end
	props['DirName'] = dirName
end

--~ function OnSwitchFile(filename)
--~ 	print("Lua sample: switched to " .. filename)
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnOpen(filename)
--~     if string.sub(filename, -1) ~= '\\' then
--~         print("Lua sample: opened " .. filename)
--~     end
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnSave(filename)
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnBeforeSave(filename)
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnChar(charAdded)
--~ 	return false	-- Let next handler to process event
--~ end

--## Real time conversion of (some) high Ascii characters to their entities.
-- I don't use it because I use the right encoding (ISO-8859-1) so 8bit is fine.

local entities =
{
--	['&'] = "&amp;",
--	['<'] = "&lt;",
--	['>'] = "&gt;",
	-- French entities (the most common ones)
	['à'] = "&agrave;",
	['â'] = "&acirc;",
	['é'] = "&eacute;",
	['è'] = "&egrave;",
	['ê'] = "&ecirc;",
	['ë'] = "&euml;",
	['î'] = "&icirc;",
	['ï'] = "&iuml;",
	['ô'] = "&ocirc;",
	['ö'] = "&ouml;",
	['ù'] = "&ugrave;",
	['û'] = "&ucirc;",
	['ÿ'] = "&yuml;",
	['À'] = "&Agrave;",
	['Â'] = "&Acirc;",
	['É'] = "&Eacute;",
	['È'] = "&Egrave;",
	['Ê'] = "&Ecirc;",
	['Ë'] = "&Euml;",
	['Î'] = "&Icirc;",
	['Ï'] = "&Iuml;",
	['Ô'] = "&Ocirc;",
	['Ö'] = "&Ouml;",
	['Ù'] = "&Ugrave;",
	['Û'] = "&Ucirc;",
	['ç'] = "&ccedil;",
	['Ç'] = "&Ccedil;",
	['Ÿ'] = "&Yuml;",
	['«'] = "&laquo;",
	['»'] = "&raquo;",
	['©'] = "&copy;",
	['®'] = "&reg;",
	['æ'] = "&aelig;",
	['Æ'] = "&AElig;",
	['Œ'] = "&OElig;", -- Not understood by all browsers - Alternative: &#338;
	['œ'] = "&oelig;", -- Not understood by all browsers - Alternative: &#339;
}

local htmlExt = { htm = 1, html = 1, php = 1, asp = 1 }

function On_Char(charAdded)
	if htmlExt[string.lower(props["FileExt"])] == 1 then	-- Only when editing an HTML file...
		if entities[charAdded] ~= nil then
--			trace(charAdded)
			local pos = editor.CurrentPos
			editor:SetSel(pos, pos - 1)
			editor:ReplaceSel(entities[charAdded])
		end
	end
	return false	-- Let next handler to process event
--~ 	return true	-- Don't let next handler to process event
end

--## Autoclose braces and quotes.
-- This is mostly annoying, I should try the Eclipse way:
-- add the closing match, but if it is typed anyway, eat it.
-- Still annoying in VB where a single quote is used for line comments...

local toClose = { ['('] = ')', ['{'] = '}', ['['] = ']', ['"'] = '"', ["'"] = "'" }

function On__Char(charAdded)
--	trace(charAdded)

	if toClose[charAdded] ~= nil then
		local pos = editor.CurrentPos
		editor:ReplaceSel(toClose[charAdded])
		editor:SetSel(pos, pos)
	end
	return false	-- Let next handler to process event
--	return true	-- Don't let next handler to process event
end

--## Put SQL keywords on uppercase while typing them.

local sqlExt = { sql = 1, plsql = 1, mssql = 1, foosql = 1 }
local sqlKW =
{
absolute=1, action=1, add=1, admin=1, after=1, aggregate=1,
alias=1, all=1, allocate=1, alter=1, ['and']=1, -- Use [''] because it is a Lua keyword...
any=1, are=1, array=1, as=1, asc=1,
assertion=1, at=1, authorization=1,
}

function GetPreviousWord()
	local pos = editor.CurrentPos
	editor:WordLeftExtend()
	local word = editor:GetSelText()
	editor:CharRight()
	return word
end

function On__Char(charAdded)
	if sqlExt[string.lower(props["FileExt"])] == 1 then	-- Only when editing an SQL file...
		local word = GetPreviousWord()
		if sqlKW[word] == 1 then
--			trace(charAdded)
			local pos = editor.CurrentPos
			editor:SetSel(pos, pos - string.len(word))
			editor:ReplaceSel(string.upper(word))
		end
	end
	return false	-- Let next handler to process event
--~ 	return true	-- Don't let next handler to process event
end

function OnUpdateUI()
	props["CurrentStyle"] = editor.StyleAt[editor.CurrentPos]
end

--~ function OnSavePointReached()
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnSavePointLeft()
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnDoubleClick()
--~ 	scite.MenuCommand(IDM_OPENSELECTED)
--~ 	return true	-- Don't let next handler to process event
--~ end

--~ function OnDoubleClick()
--~ 	return false	-- Let next handler to process event
--~ end

--~ function OnMarginClick()
--~ 	return false	-- Let next handler to process event
--~ end

-- Example styler looks for "lua" and highlights to end of word.
function OnStyle(start, len, state, styler)
	--trace("> [" .. start .."," .. len .. "," .. startstyle .. "]\n")
	local i = start
    while i <= start + len do
		if string.lower(editor:GetRange(i, i+3)) == "lua" then
			styler:ColourTo(i - 1, state)
			state = 1
		elseif state == 1 then
			if not string.find(editor:GetRange(i, i+1), "[%a_]") then
				styler:ColourTo(i - 1, state)
				state = 0
			end
		end
		i = i + 1
	end
	styler:ColourTo(start + len - 1, state)
	return 1	-- Event have been handled, don't give it to default processing
end
