;AHK v1
#NoEnv

;MsgBox % ConvertEntities("Ham &amp; Eggs, &#34;Test&quot; 123")

ConvertEntities(HTML)
{
    static EntityList := "|quot=34|apos=39|amp=38|lt=60|gt=62|nbsp=160|iexcl=161|cent=162|pound=163|curren=164|yen=165|brvbar=166|sect=167|uml=168|copy=169|ordf=170|laquo=171|not=172|shy=173|reg=174|macr=175|deg=176|plusmn=177|sup2=178|sup3=179|acute=180|micro=181|para=182|middot=183|cedil=184|sup1=185|ordm=186|raquo=187|frac14=188|frac12=189|frac34=190|iquest=191|Agrave=192|Aacute=193|Acirc=194|Atilde=195|Auml=196|Aring=197|AElig=198|Ccedil=199|Egrave=200|Eacute=201|Ecirc=202|Euml=203|Igrave=204|Iacute=205|Icirc=206|Iuml=207|ETH=208|Ntilde=209|Ograve=210|Oacute=211|Ocirc=212|Otilde=213|Ouml=214|times=215|Oslash=216|Ugrave=217|Uacute=218|Ucirc=219|Uuml=220|Yacute=221|THORN=222|szlig=223|agrave=224|aacute=225|acirc=226|atilde=227|auml=228|aring=229|aelig=230|ccedil=231|egrave=232|eacute=233|ecirc=234|euml=235|igrave=236|iacute=237|icirc=238|iuml=239|eth=240|ntilde=241|ograve=242|oacute=243|ocirc=244|otilde=245|ouml=246|divide=247|oslash=248|ugrave=249|uacute=250|ucirc=251|uuml=252|yacute=253|thorn=254|yuml=255|OElig=338|oelig=339|Scaron=352|scaron=353|Yuml=376|circ=710|tilde=732|ensp=8194|emsp=8195|thinsp=8201|zwnj=8204|zwj=8205|lrm=8206|rlm=8207|ndash=8211|mdash=8212|lsquo=8216|rsquo=8217|sbquo=8218|ldquo=8220|rdquo=8221|bdquo=8222|dagger=8224|Dagger=8225|hellip=8230|permil=8240|lsaquo=8249|rsaquo=8250|euro=8364|trade=8482|"
    FoundPos := 1
    While, FoundPos := InStr(HTML,"&",1,FoundPos)
    {
        FoundPos ++ ;move past the ampersand
        Entity := SubStr(HTML,FoundPos,InStr(HTML,";",1,FoundPos) - FoundPos) ;retrieve the entity body
        If SubStr(Entity,1,1) = "#" ;numeric entity code
            EntityCode := SubStr(Entity,2)
        Else ;named entity
        {
            Temp1 := InStr(EntityList,"|" . Entity . "=") + StrLen(Entity) + 2
            EntityCode := SubStr(EntityList,Temp1,InStr(EntityList,"|",1,Temp1) - Temp1)
        }
        If (Entity != "amp") ;convert every entity except the ampersand
            StringReplace, HTML, HTML, &%Entity%;, % Chr(EntityCode), All ;convert the entity
    }
    StringReplace, HTML, HTML, &amp;, &, All ;convert the ampersand entity
    Return, HTML
}