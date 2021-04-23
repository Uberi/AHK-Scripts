;AHK AHK_L
#NoEnv

/*
;port should be 465 if SSL is in effect, otherwise 25
Email("""Anthony Zhang"" <azhang9@gmail.com>","""Some Person"" <azhang9@gmail.com>","Test","This is a test.",[A_ScriptFullPath],"azhang9","password goes here")
*/

Email(From,To,Subject,Body,Attachments,Username,Password,Server = "smtp.gmail.com",Port = 465,UseSSL = 1,UseHTML = 0)
{
 Message := ComObjCreate("CDO.Message") 

 Fields := Message.Configuration.Fields
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing").Value := 2 ;cdoSendUsingPort
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout").Value := 60 ;timeout in 60 seconds
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl").Value := UseSSL ;SSL flag
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").Value := 1 ;cdoBasic: cleartext authentication
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value := Server ;SMTP server
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport").Value := Port ;SMTP port
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername").Value := Username ;account username
 Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword").Value := Password ;account password
 Fields.Update() ;update fields

 Message.From := From ;message sender
 Message.To := To ;message receiver
 Message.Subject := Subject ;message subject

 If UseHTML ;message body is in HTML format
  Message.HtmlBody := Body
 Else ;message body is plain text
  Message.TextBody := Body

 For Index, Attachment In Attachments ;process any attached files
  Message.AddAttachment(Attachment)

 Message.Send() ;send the message

 Fields := "", Message := "" ;free the COM objects
}