#NoEnv

SendMessage, 0x112, 0xF170, 1,, Program Manager ahk_class Progman ;SC_MONITORPOWER, MONITOR_STANBY: set monitor to standby mode
SendMessage, 0x112, 0xF170, 2,, Program Manager ahk_class Progman ;SC_MONITORPOWER, MONITOR_OFF: turn off monitor
SendMessage, 0x112, 0xF170, -1,, Program Manager ahk_class Progman ;SC_MONITORPOWER, MONITOR_ON: turn on monitor