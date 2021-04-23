#NoEnv

Data = 
(
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend!</body>
</note>
)

;http://msdn.microsoft.com/en-us/library/aa923288.aspx
cDocument := ComObjCreate("msxml2.DOMDocument.6.0")
cDocument.async := False

cDocument.loadXML(Data)
If cDocument.parseError.errorCode
    throw Exception(cDocument.parseError.reason . "(line " . cDocument.parseError.line . ", column " . cDocument.parseError.linepos . ")")

;http://msdn.microsoft.com/en-us/library/windows/desktop/ms767671(v=vs.85).aspx
cDocumentReader := ComObjCreate("msxml2.SAXXMLReader.6.0")

;http://msdn.microsoft.com/en-us/library/windows/desktop/ms755440(v=vs.85).aspx
cDocumentWriter := ComObjCreate("msxml2.MXXMLWriter.6.0")

;cDocumentWriter.byteOrderMark := True ;enable writing of unicode byte order mark
cDocumentWriter.indent := True ;enable document indenting
;cDocumentWriter.standalone := False ;output standalone document, including the XML declaration

;connect XML writer to SAX parser
cDocumentReader.contentHandler := cDocumentWriter
cDocumentReader.dtdHandler := cDocumentWriter
cDocumentReader.errorHandler := cDocumentWriter
cDocumentReader.putProperty("http://xml.org/sax/properties/lexical-handler",cDocumentWriter)
cDocumentReader.putProperty("http://xml.org/sax/properties/declaration-handler",cDocumentWriter)

;parse input data
cDocumentReader.parse(cDocument)

;obtain result
Result := cDocumentWriter.output

MsgBox % Result