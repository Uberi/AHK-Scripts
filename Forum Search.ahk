#NoEnv

Results := Forum.Search("","Uberi")
Authored := []
For Index, Result In Results
{
    If Result.Author = "Uberi"
        Authored.Insert(Result.URL . " " . Result.Title)
}
MsgBox % Clipboard := ShowObject(Authored)

class Forum
{
    Search(Search,Username = "",DisplayFormat = "Topics",Tags = "",Forums = "",SortKey = "Date",SortDirection = "Descending",MinimumPosts = 0,MinimumViews = 0)
    {
        ;check display format
        If (DisplayFormat = "Posts")
            DisplayFormat := 0
        Else If (DisplayFormat = "Topics")
            DisplayFormat := 1
        Else
            throw Exception("Invalid display format.",-1)

        ;check forums
        ForumIndices := {"AutoHotkey":                     56
                        ,"AutoHotkey>Support":             48
                        ,"AutoHotkey>Support>Gaming":      60
                        ,"AutoHotkey>Scripts":             49
                        ,"AutoHotkey>Scripts>Gaming":      59
                        ,"AutoHotkey>Tutorials":           61
                        ,"AutoHotkey>Suggestions":         51
                        ,"AutoHotkey>Suggestions>Issues":  50
                        ,"AutoHotkey>Announcements":       53
                        ,"General":                        57
                        ,"General>Utilities":              54
                        ,"General>Programming":            58
                        ,"General>Offtopic":               52
                        ,"Deutches (German)":              62
                        ,"Deutches (German)>Unterstützen": 63
                        ,"Deutches (German)>Scripts":      64
                        ,"Deutches (German)>Tooltime":     65
                        ,"Deutches (German)>Smalltalk":    66}
        ForumParameters := ""
        Loop, Parse, Forums, `,
        {
            If !ForumIndices.HasKey(A_LoopField)
                throw Exception("Invalid forum.",-1)
            ForumParameters .= "&search_app_filters%5Bforums%5D%5Bforums%5D%5B%5D=" . ForumIndices[A_LoopField]
        }

        ;check sort key
        If (SortKey = "Date")
            SortKey := "date"
        Else If (SortKey = "Title")
            SortKey := "title"
        Else If (SortKey = "Replies")
            SortKey := "posts"
        Else If (SortKey = "Views")
            SortKey := "views"
        Else
            throw Exception("Invalid sort key.",-1)

        ;check sort direction
        If (SortDirection = "Descending")
            SortDirection := 0
        Else If (SortDirection = "Ascending")
            SortDirection := 1
        Else
            throw Exception("Invalid sort direction.",-1)

        ;check minimum statistics
        If MinimumPosts Is Not Integer
            throw Exception("Invalid minimum post count.",-1)
        If MinimumViews Is Not Integer
            throw Exception("Invalid minimum view count.",-1)

        URL := "http://www.autohotkey.com/board/index.php?app=core&module=search&section=search&do=search&fromsearch=1"
            . "&search_app=forums" ;search for content
            . "&search_term=" . this.URLEncode(Search) ;search terms
            . "&search_content=both" ;titles and/or content
            . "&search_tags=" . this.URLEncode(Tags) ;post tags
            . "&search_author=" . this.URLEncode(Username) ;post username
            . "&search_app_filters%5Bforums%5D%5BliveOrArchive%5D=live" ;search in live content
            . ForumParameters ;forums to search in
            . "&search_app_filters%5Bforums%5D%5BnoPreview%5D=" . DisplayFormat ;display format
            . "&search_app_filters%5Bforums%5D%5BpCount%5D=" . MinimumPosts ;minimum post count
            . "&search_app_filters%5Bforums%5D%5BpViews%5D=" . MinimumViews ;minimum view count
            . "&search_app_filters%5Bforums%5D%5BsortKey%5D=" . SortKey ;sort key
            . "&search_app_filters%5Bforums%5D%5BsortDir%5D=" . SortDirection ;sort direction

        Results := []
        Loop
        {
            Page := this.Request(URL)

            Document := this.ParseHTML(Page)
            HTMLResults := Document.getElementById("forum_table").getElementsByTagName("tr")
            Loop, % HTMLResults.length
            {
                HTMLResult := HTMLResults[A_Index - 1].childNodes
                Result := Object()

                Result.Title := HTMLResult[1].childNodes[0].childNodes[0].innerText
                Result.URL := HTMLResult[1].childNodes[0].childNodes[0].attributes.href.value
                RegExMatch(HTMLResult[1].childNodes[1].getElementsByTagName("a")[0].attributes.href.value,"iS)/forum/(\d+)-",Temp)
                Result.Forum := ""
                For Name, Value In ForumIndices
                    If (Temp1 = Value)
                        Result.Forum := Name
                RegExMatch(HTMLResult[1].childNodes[2].innerText,"iS)Started by ([^,]*)",Temp)
                Result.Author := Temp1
                RegExMatch(HTMLResult[3].childNodes[0].childNodes[0].innerText,"S)\d+",Temp1)
                Result.Replies := Temp1
                RegExMatch(HTMLResult[3].childNodes[0].childNodes[1].innerText,"S)\d+",Temp1)
                Result.Views := Temp1

                Results.Insert(Result)
            }

            ;obtain the URL of the next page
            Element := Document.getElementById("content").getElementsByTagName("div")[1].childNodes[1].childNodes[0].getElementsByTagName("ul")[2]
            If Element.childNodes.length = 0
                Break
            URL := Element.getElementsByTagName("a")[0].attributes.href.value
        }
        Return, Results
    }

    Request(URL)
    {
        try
        {
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("GET",URL)
            WebRequest.Send()
            Result := WebRequest.ResponseText
            WebRequest := ""
        }
        catch
            throw Exception("Could not retrieve page.",-1)
        Return, Result
    }

    ParseHTML(HTML)
    {
        static HTMLDocument := ComObjCreate("HTMLFile")
        HTMLDocument.open()
        HTMLDocument.write(HTML)
        HTMLDocument.close()
        Return, HTMLDocument
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
}