dropbox_pause_sync()
{
	TI := TrayIcons( "Dropbox.exe" )
	StringSplit,TIV, TI, |
	uID  := RegExReplace( TIV4, "uID: " )
	Msg  := RegExReplace( TIV5, "MessageID: " )
	hWnd := RegExReplace( TIV6, "hWnd: " )

	FoundPos := RegExMatch(TIV9, "All files up to date")

	if ( FoundPos <= 0 ) { ; not found
		FoundPos := RegExMatch(TIV9, "Syncing paused")
		if ( FoundPos > 0 ) { ; already paused
			msgbox Already paused. Switching display
			return 1
		}
		else {
			msgbox Cant do it. Dropbox NOT reporting that all files are up to date
			return 0
		}
	}

	; right click
	PostMessage, Msg, uID,0x204,, ahk_id %hWnd% ; Right Click down
	PostMessage, Msg, uID,0x205,, ahk_id %hWnd% ; Right Click Up

	WinWaitActive, Dropbox
	send {Down}{Down}{Down}{Down}{Down}{Down}{Down}
	send {Enter}
	return 1

}

dropbox_resume_sync()
{
	TI := TrayIcons( "Dropbox.exe" )
	StringSplit,TIV, TI, |
	uID  := RegExReplace( TIV4, "uID: " )
	Msg  := RegExReplace( TIV5, "MessageID: " )
	hWnd := RegExReplace( TIV6, "hWnd: " )

	FoundPos := RegExMatch(TIV9, "Syncing paused")

	if ( FoundPos <= 0 )
	{
		msgbox Cant do it. Dropbox NOT reporting that sync is currently paused
		return 0
	}

	; right click
	PostMessage, Msg, uID,0x204,, ahk_id %hWnd% ; Right Click down
	PostMessage, Msg, uID,0x205,, ahk_id %hWnd% ; Right Click Up

	WinWaitActive, Dropbox
	send {Down}{Down}{Down}{Down}{Down}{Down}{Down}
	send {Enter}
	return 1
}
