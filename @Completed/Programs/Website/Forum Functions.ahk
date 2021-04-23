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

/*
Search := ForumSearch("","","Uberi",2) ;search the "Scripts & Functions" forum for topics by Uberi

TopicList := ""
For Index, Result In Search
{
 If (Result.Author = "Uberi")
  TopicList .= Result.Title . "`n"
}
MsgBox % TopicList
*/

;searches the AutoHotkey forums for scripts posted by a specified forum user
ForumSearchAll(ForumUsername)
{
    global SearchEnglishForum, SearchGermanForum
    Results := []
    If SearchEnglishForum
    {
        For Index, Result In ForumSearch("http://www.autohotkey.com/community/search.php","",ForumUsername,2) ;search the English AutoHotkey forum for posts by the specified forum user
        {
            If Result.Author = ForumUsername
                ExpandSearchResult(Result), ObjInsert(Results,Result)
        }
    }
    If SearchGermanForum
    {
        For Index, Result In ForumSearch("http://de.autohotkey.com/forum/search.php","",ForumUsername,2) ;search the German AutoHotkey forum for posts by the specified forum user
        {
            If Result.Author = ForumUsername
            ExpandSearchResult(Result), ObjInsert(Results,Result)
        }
    }
    Return, Results
}

;retrieves information about a given forum topic and adds the information to the given search result
ExpandSearchResult(ByRef Result)
{
    global Cache
    If ObjHasKey(Cache,Result.URL) ;cache contains topic information
    {
        Topic := Cache[Result.URL]
        If Topic.Image != ""
            Result.Image := Topic.Image
        If Topic.Source != ""
            Result.Source := Topic.Source
    }
    Else ;download information from the forum
    {
        Topic := ForumGetTopicInfo(Result.URL)
        Cache[Result.URL] := Object()
        If ObjHasKey(Topic,"Image")
            Result.Image := Topic.Image, Cache[Result.URL].Image := Topic.Image
        If ObjHasKey(Topic,"Source")
            Result.Source := Topic.Source, Cache[Result.URL].Source := Topic.Source
        Cache[Result.URL].Description := Topic.Description
    }
    Result.Description := Topic.Description
}

;searches the AutoHotkey forum and returns the results in the form of an object
ForumSearch(BaseURL = "",Keywords = "",Author = "",ForumIndex = 0,ResultLimit = 0,SearchAny = 0)
{
    If (BaseURL = "")
        BaseURL := "http://www.autohotkey.com/community/search.php"

    URL := BaseURL
        . "?keywords=" . URLEncode(Keywords) ;search keywords
        . "&terms=" . (SearchAny ? "any" : "all") ;search any or all terms
        . "&author=" . URLEncode(Author) ;search for a specified author
        . (ForumIndex ? ("&fid%5B%5D=" . ForumIndex) : "") ;search in specified forum
        ;. "&sc=1" ;search in subforums
        . "&sf=all" ;search within post subjects and message text
        ;. "&sk=t" ;sort by post time
        ;. "&sd=d" ;sort descending
        . "&sr=topics" ;show topics rather than posts
        ;. "&st=0" ;show all results
        ;. "&ch=0" ;return 0 characters of the posts

    Result := [] ;prepare the result array
    Loop
    {
        ;request the search results page
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1"), WebRequest.Open("GET",URL)
        WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
        WebRequest.Send(), SearchResult := WebRequest.ResponseText, WebRequest := ""

        ;obtain the next page
        URL := ParseSearchResultPage(SearchResult,BaseURL,Result,ResultLimit)
        If !URL ;no page remains
            Break
        Sleep, 3000 ;delay to allow the request to close
    }
    Return, Result
}

;parses a search result page
ParseSearchResultPage(SearchResult,BaseURL,ByRef Result,ResultLimit = 0)
{
    ;process navigation
    RegExMatch(SearchResult,"isS)<div[^>]+class=""nav"".*?</div>",Navigation) ;obtain the navigation section
    If RegExMatch(Navigation,"iS)<a[^>]+href=""\K[^""]*(?!.*<(?:a|span)\b)",Field) ;obtain the last link in the section (the link to the next page)
    {
        ;obtain the page URL
        SplitPath, BaseURL,, Path
        NextPage := Path . "/" . ConvertEntities(Field)

        ;remove the "sid" parameter
        NextPage := RegExReplace(NextPage,"iS)(?:(\?)|&)sid=\w+","$1")
    }
    Else ;at the last page
        NextPage := ""

    ;obtain the results table
    RegExMatch(SearchResult,"iS)<table\b[^<]*<tr\b[^<]*<th\b.*?</tr>(.*?)</table>",Field)
    SearchResult := Field1

    If InStr(SearchResult,"<td class=""row1"" align=""center"">") ;no results found, error message shown
        Return, ""

    SplitPath, BaseURL,, Path
    FoundPos := 1
    While, FoundPos := RegExMatch(SearchResult,"isS)<tr[^>]*>(.*?)</tr>",Field,FoundPos)
    {
        If (ResultLimit > 0 && ObjMaxIndex(Result) >= ResultLimit)
            Return, ""

        FoundPos += StrLen(Field)

        If !RegExMatch(Field1,"isS)<a href=""(?P<Link>[^""]*)""[^>]+class=""topictitle""[^>]*>(?P<Title>[^<]*).*?"
            . "<p[^>]+class=""gensmall""[^<]+<a\b[^>]*>(?P<Forum>[^<]*).*?"
            . "<p class=""topicauthor"">[^<]*<a href=""(?P<Profile>[^""]*)""[^>]*>(?P<Author>[^<]*).*?"
            . "<p class=""topicdetails"">(?P<Replies>[^<]*).*?"
            . "<p class=""topicdetails"">(?P<Views>[^<]*)",Field)
            Continue

        RowResult := Object()
        RowResult.URL := Path . "/" . ConvertEntities(FieldLink)
        RowResult.Title := ConvertEntities(FieldTitle)
        RowResult.Forum := FieldForum
        RowResult.Author := ConvertEntities(FieldAuthor)
        RowResult.Profile := Path . "/" . ConvertEntities(FieldProfile)
        RowResult.Replies := FieldReplies
        RowResult.Views := FieldViews

        ;remove the "sid" parameter
        RowResult.Forum := RegExReplace(RowResult.Forum,"iS)(?:(\?)|&)sid=\w+","$1")
        RowResult.URL := RegExReplace(RowResult.URL,"iS)(?:(\?)|&)sid=\w+","$1")
        RowResult.Profile := RegExReplace(RowResult.Profile,"iS)(?:(\?)|&)sid=\w+","$1")

        Result.Insert(RowResult)
    }
    Return, NextPage
}

;retrieves information about a given forum topic
ForumGetTopicInfo(URL) ;wip
{
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1"), WebRequest.Open("GET",URL)
    WebRequest.Send(), ForumTopic := WebRequest.ResponseText, WebRequest := ""

    Result := Object()

    ;extract the title of the topic
    RegExMatch(ForumTopic,"iS)<a\b[^>]+class=""titles""[^>]*>\K[^<]*",Field)
    Result.Title := Field

    ;extract the author of the topic
    RegExMatch(ForumTopic,"iS)\bclass=""postauthor""[^>]*>\K[^<]*",Field) ;match the author field
    Result.Author := Field

    ;extract the first post of the topic
    RegExMatch(ForumTopic,"isS)\bclass=""postbody""[^>]*>(.*?)<table",Field) ;match the author field
    Field1 := RegExReplace(Field1,"S)<[^>]+\bclass=""postbody"".*") ;remove forum signatures
    Field1 := RegExReplace(Field1,"S)<[^>]+\bclass=""gensmall"".*") ;remove modification notices
    ForumTopic := Field1

    ;extract a description of the topic
    Temp1 := SubStr(ForumTopic,1,InStr(ForumTopic,"<br ") - 1) ;extract the first paragraph of the post
    Temp1 := ConvertEntities(Temp1) ;convert any HTML entities present into their literal equivelants
    StringReplace, Temp1, Temp1, `r,, All ;remove all carriage returns
    StringReplace, Temp1, Temp1, `n,, All ;remove all newlines
    Temp1 := Trim(Temp1) ;remove leading and trailing whitespace
    Temp1 := RegExReplace(Temp1,"S)\.\K[^\.:<>\[\]]+:$") ;if the last sentence ends with a colon, and there are sentences before it, remove the last sentence
    Temp1 := RegExReplace(Temp1,"S)^[^\.]*\K:$",".") ;if the description ends with a colon, and contains only one sentence, replace the colon with a period
    If (SubStr(Temp1,0) != ".") ;insert a period at the end of the description if one is not present
        Temp1 .= "."
    Temp1 := RegExReplace(Temp1,"iS)<a\s.*?href=""([^""]*)""[^>]*>([^<]+)</a>","<> href=""$1"" class=""link"">$2</>") ;normalize hyperlinks and temporarily change them into invalid tags
    Temp1 := RegExReplace(Temp1,"iS)<(?!/?>)[^>]*>") ;remove any HTML tags excluding hyperlinks that are still present
    StringReplace, Temp1, Temp1, <>, <a, All ;return opening hyperlink tags to their original form
    StringReplace, Temp1, Temp1, </>, </a>, All ;return closing hyperlink tags to their original form
    Result.Description := Temp1 ;set the description field of the result

    ;extract an image if present
    If RegExMatch(ForumTopic,"iS)<img\b[^>]*src=""([^:]+://[^""]*)""",Output) ;match images that are sourced from absolute links
        Result.Image := Output1 ;set the image field of the result

    ;extract a download link if present
    If RegExMatch(ForumTopic,"iS)<a\s.*?href=""([^""]*\.(?:ahk|exe))""[^>]*>[^<>]+</a>",Output)
        Result.Source := Output1 ;set the image field of the result

    Return, Result
}

URLEncode(URL)
{
    StringReplace, URL, URL, `%, `%25, All
    FormatInteger := A_FormatInteger, FoundPos := 0
    SetFormat, IntegerFast, Hex
    While, (FoundPos := RegExMatch(URL,"iS)[^\w-\.~%]",Char,FoundPos + 1))
        StringReplace, URL, URL, %Char%, % "%" . SubStr("0" . SubStr(Asc(Char),3),-1), All
    SetFormat, IntegerFast, %FormatInteger%
    Return, URL
}

URLDecode(Encoded)
{
    FoundPos := 0
    While, (FoundPos := InStr(Encoded,"%",False,FoundPos + 1))
    {
        If ((Temp1 := SubStr(Encoded,FoundPos + 1,2)) <> 25)
            StringReplace, Encoded, Encoded, `%%Temp1%, % Chr("0x" . Temp1), All
    }
    StringReplace, Encoded, Encoded, `%25, `%, All
    Return, Encoded
}

ConvertEntities(HTML)
{
    static EntityList := "|quot=34|apos=39|amp=38|lt=60|gt=62|nbsp=160|iexcl=161|cent=162|pound=163|curren=164|yen=165|brvbar=166|sect=167|uml=168|copy=169|ordf=170|laquo=171|not=172|shy=173|reg=174|macr=175|deg=176|plusmn=177|sup2=178|sup3=179|acute=180|micro=181|para=182|middot=183|cedil=184|sup1=185|ordm=186|raquo=187|frac14=188|frac12=189|frac34=190|iquest=191|Agrave=192|Aacute=193|Acirc=194|Atilde=195|Auml=196|Aring=197|AElig=198|Ccedil=199|Egrave=200|Eacute=201|Ecirc=202|Euml=203|Igrave=204|Iacute=205|Icirc=206|Iuml=207|ETH=208|Ntilde=209|Ograve=210|Oacute=211|Ocirc=212|Otilde=213|Ouml=214|times=215|Oslash=216|Ugrave=217|Uacute=218|Ucirc=219|Uuml=220|Yacute=221|THORN=222|szlig=223|agrave=224|aacute=225|acirc=226|atilde=227|auml=228|aring=229|aelig=230|ccedil=231|egrave=232|eacute=233|ecirc=234|euml=235|igrave=236|iacute=237|icirc=238|iuml=239|eth=240|ntilde=241|ograve=242|oacute=243|ocirc=244|otilde=245|ouml=246|divide=247|oslash=248|ugrave=249|uacute=250|ucirc=251|uuml=252|yacute=253|thorn=254|yuml=255|OElig=338|oelig=339|Scaron=352|scaron=353|Yuml=376|circ=710|tilde=732|ensp=8194|emsp=8195|thinsp=8201|zwnj=8204|zwj=8205|lrm=8206|rlm=8207|ndash=8211|mdash=8212|lsquo=8216|rsquo=8217|sbquo=8218|ldquo=8220|rdquo=8221|bdquo=8222|dagger=8224|Dagger=8225|hellip=8230|permil=8240|lsaquo=8249|rsaquo=8250|euro=8364|trade=8482|"
    FoundPos := 1
    While, (FoundPos := InStr(HTML,"&",1,FoundPos))
    {
        FoundPos ++
        Entity := SubStr(HTML,FoundPos,InStr(HTML,";",1,FoundPos) - FoundPos)
        If (SubStr(Entity,1,1) = "#")
            EntityCode := SubStr(Entity,2)
        Else
        {
            Temp1 := InStr(EntityList,"|" . Entity . "=") + StrLen(Entity) + 2
            EntityCode := SubStr(EntityList,Temp1,InStr(EntityList,"|",1,Temp1) - Temp1)
        }
        StringReplace, HTML, HTML, &%Entity%`;, % Chr(EntityCode), All
    }
    Return, HTML
}

HTMLEscape(String)
{
    Transform, Escaped, HTML, %String%
    Return, Escaped
}