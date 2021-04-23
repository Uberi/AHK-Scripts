/* 星号查看.ahk    作者：wz520

        不多说了，相信大家都知道这是干嘛的。
        写成AHK脚本的好处就在于真需要时可以不需要其他软件了。

        用法：在要查看密码的编辑框上按Ctrl+鼠标左键，立刻星号变明文。理论上应该只支持标准的Edit框。

        PS: XP系统下测试通过，其他系统下效果未知……

*/

; #define EM_GETPASSWORDCHAR 0x00D2
; #define EM_SETPASSWORDCHAR 0x00CC

^esc::reload
+esc::Edit
!esc::ExitApp
F1::
	MouseGetPos,,,,ctrlid,3 ;取得鼠标指针下的控件ID
	SendMessage, 0x00D2,0,0,,ahk_id %ctrlid% ;取得鼠标指针下控件的密码字符（就是检测鼠标下面是否是带星号的Edit框）。
	If errorlevel in FAIL,0
		return ;若返回失败或0，那下面就不做了……
	PostMessage, 0x00CC,0,0,,ahk_id %ctrlid% ;把密码字符设为0，即取消密码属性，使其显示明文。
	sleep, 50 ; 休息一下……
	ControlFocus,,ahk_id %ctrlid% ;有焦点才会显示明文。
return


