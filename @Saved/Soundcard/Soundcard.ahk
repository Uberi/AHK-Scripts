/*
    Sound Card Analyzer v1.0
    
    Requirements:
        - AutoHotkey v1.1.10+
        - Windows Vista or later
        - VA v2.2  http://www.autohotkey.com/board/topic/21984-/
*/
if A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
    MsgBox 48,, This script requires Windows Vista or later.
    ExitApp
}

global CLSID_MMDeviceEnumerator := "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
      , IID_IMMDeviceEnumerator := "{A95664D2-9614-4F35-A746-DE8DB63617E6}"

OnMessage(0x100, "OnKeyDown")
Gui +hwndGuiHwnd
Gui Add, ListView, vDeviceLV gDeviceLV AltSubmit r10 w500, #|Def|Endpoint|Adapter
Gui Add, ListView, vControlLV gControlLV AltSubmit r15 w500, Connector|ComponentType|ControlType|Value
Gui Add, Slider, vSlider gSlider Disabled w440 AltSubmit ToolTip
Gui Add, Checkbox, vToggle gToggle Disabled x+7 w53 h33 +0x1000, Toggle
Gui Font, s9, Courier New
Gui Font, s9, Consolas
Gui Add, Edit, vCommand xm r2 ReadOnly -Wrap -VScroll w500,
(
Select a device to list the components and controls it supports.
Press F5 to refresh the list of devices.
)
PopulateDeviceLV()
Gui Show,, Sound Controls

return

OnKeyDown(wParam)
{
    if A_Gui
    {
        if (wParam = 0x74) ; VK_F5
        {
            PopulateDeviceLV()
            return true
        }
    }
}

DeviceLV:
    Gui ListView, DeviceLV
    if (A_GuiEvent = "I" && InStr(ErrorLevel, "F", true))
    {
        LV_GetText(device_num, A_EventInfo, 1)
        PopulateControlLV(device_num)
        GuiControl,, Command, Select a control to show usage.
        GuiControl, Disable, Toggle
        GuiControl, Disable, Slider
    }
return

ControlLV:
    Gui ListView, ControlLV
    if (A_GuiEvent = "I" && InStr(ErrorLevel, "F", true))
    {
        control_row := A_EventInfo
        LV_GetText(component_type, A_EventInfo, 2)
        LV_GetText(control_type, A_EventInfo, 3)
        LV_GetText(value, A_EventInfo, 4)
        if InStr(value, " ")
        {
            GuiControl,, Command, This control doesn't appear to be supported by AutoHotkey.
            GuiControl, Disable, Toggle
            GuiControl, Disable, Slider
            return
        }
        GuiControl,, Command,
        (LTrim
        SoundGet, OutputVar, %component_type%, %control_type%, %device_num%
        SoundSet, NewSetting, %component_type%, %control_type%, %device_num%
        )
        if value is number
        {
            GuiControl, Enable, Slider
            GuiControl, Disable, Toggle
        }
        else
        {
            GuiControl, Enable, Toggle
            GuiControl, Disable, Slider
        }
        GuiControl,, Slider, % value
        GuiControl,, Toggle, % value="On"
    }
return

Toggle:
Slider:
if (A_GuiControl = "Slider")
    GuiControlGet value,, Slider
else
    value := -1
SoundSet % value, %component_type%, %control_type%, %device_num%
SoundGet value, %component_type%, %control_type%, %device_num%
LV_Modify(control_row, "Col4", ErrorLevel ? ErrorLevel : value)
return

GuiEscape:
GuiClose:
ExitApp

PopulateDeviceLV()
{
    Gui ListView, DeviceLV
    LV_Delete()
    enum := ComObjCreate(CLSID_MMDeviceEnumerator, IID_IMMDeviceEnumerator)
    if VA_IMMDeviceEnumerator_EnumAudioEndpoints(enum, 2, 9, devices) >= 0
    {
        VA_IMMDeviceEnumerator_GetDefaultAudioEndpoint(enum, 0, 0, device)
        VA_IMMDevice_GetId(device, default_id)
        ObjRelease(device)
        
        VA_IMMDeviceCollection_GetCount(devices, count)
        Loop % count
        {
            if VA_IMMDeviceCollection_Item(devices, A_Index-1, device) < 0
                continue
            VA_IMMDevice_GetId(device, id)
            name := VA_GetDeviceName(device)
            if !RegExMatch(name, "^(.*?) \((.*?)\)$", m)
                m1 := name, m2 := ""
            LV_Add("", A_Index, id == default_id ? ">>" : "", m1, m2)
            ObjRelease(device)
        }
        ObjRelease(devices)
    }
    ObjRelease(enum)
    Loop 2
        LV_ModifyCol(A_Index+2, "AutoHdr")
}

PopulateControlLV(device_num)
{
    Gui ListView, ControlLV
    LV_Delete()
    SoundGet value, Master, Volume, %device_num%
    LV_Add("", "", "Master", "Volume", ErrorLevel ? ErrorLevel : value)
    SoundGet value, Master, Mute, %device_num%
    LV_Add("", "", "Master", "Mute", ErrorLevel ? ErrorLevel : value)
    if !(enum := ComObjCreate(CLSID_MMDeviceEnumerator, IID_IMMDeviceEnumerator))
        return 0
    if (hr := VA_IMMDeviceEnumerator_EnumAudioEndpoints(enum, 2, 9, devices)) >= 0
    {
        hr := VA_IMMDeviceCollection_Item(devices, device_num-1, device)
        ObjRelease(devices)
    }
    ObjRelease(enum)
    if hr < 0  ; Failed to get device.
        return
    ScanDevice(device, device_num)
    ObjRelease(device)
    Loop 4
        LV_ModifyCol(A_Index, "AutoHdr")
}

ScanDevice(device, device_num)
{
    VA_IMMDevice_Activate(device, "{2A07407E-6497-4A18-9787-32F79BD0D98F}", 7, 0, deviceTopology)
    VA_IDeviceTopology_GetConnector(deviceTopology, 0, conn)
    ObjRelease(deviceTopology)
    VA_IConnector_GetConnectedTo(conn, conn_to)
    VA_IConnector_GetDataFlow(conn, data_flow)
    ObjRelease(conn)
    if !conn_to
        return
    part := ComObjQuery(conn_to, "{AE2DE0E4-5BCA-4F2D-AA46-5D13F8FDB3A9}") ; IID_IPart
    ObjRelease(conn_to)
    if !part
        return
    ScanPart(part, {data_flow: data_flow, device_num: device_num}, [])
    ObjRelease(part)
}

ScanPart(root, scan, controls)
{
    if (scan.data_flow = 0)
        hr := VA_IPart_EnumPartsIncoming(root, parts)
    else
        hr := VA_IPart_EnumPartsOutgoing(root, parts)
    if (hr < 0)
        return
    
    VA_IPartsList_GetCount(parts, count)
    if (count > 1)
        controls := []  ; Ignore controls seen by caller.
    this_part_control := Round(controls.MaxIndex()) + 1
    
    Loop % count
    {
        if VA_IPartsList_GetPart(parts, A_Index-1, part) < 0
            continue
        
        VA_IPart_GetPartType(part, type)
        VA_IPart_GetSubType(part, subtype)
        if (type = 0) ; Connector
        {
            VA_IPart_GetName(part, name)
            
            component_type := GetComponentType(subtype)
            instance := Round(scan.found[component_type]) + 1
            scan.found[component_type] := instance
            if (instance > 1)
                component_type .= ":" instance
            
            for i, control_type in controls
            {
                if RegExMatch(control_type, "^\w+", ctl)
                    SoundGet value, %component_type%, %ctl%, % dn := scan.device_num
                else
                    ErrorLevel := "n/a"
                LV_Add("", name, component_type, control_type, ErrorLevel ? ErrorLevel : value)
            }
        }
        else ; Subunit
        {
            GetControls(part, controls)
            
            ScanPart(part, scan, controls)
            
            controls.Remove(this_part_control, controls.MaxIndex())
        }
        
        ObjRelease(part)
    }
}

GetControls(part, controls)
{
    static IID_to_Name := {
    (C Join,
        ; Supported:
        "{7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}": "Volume"
        "{DF45AEEA-B74A-4B6B-AFAD-2366B6AA012E}": "Mute"
        ; Unsupported:
        "{85401FD4-6DE4-4b9d-9869-2D6753A82F3C}": "OnOff (AGC)"
        "{4F03DC02-5E6E-4653-8F72-A030C123D598}": "0x70010001 (Mux)"
        "{BB515F69-94A7-429e-8B9C-271B3F11A3AB}": "Demux"
        "{7D8B1437-DD53-4350-9C1B-1EE2890BD938}": "Loudness"
        "{DD79923C-0599-45e0-B8B6-C8DF7DB6E796}": "0x10020001 (PeakMeter)"
        "{A2B1A1D9-4DB3-425D-A2B2-BD335CB3E2E5}": "Bass"
        "{5E54B6D7-B44B-40D9-9A9E-E691D9CE6EDF}": "Midrange"
        "{0A717812-694E-4907-B74B-BAFA5CFDCA7B}": "Treble"
    )}
    VA_IPart_GetControlInterfaceCount(part, count)
    Loop % count
    {
        VA_IPart_GetControlInterface(part, A_Index-1, desc)
        ; Get IID and map it to a name, since GetName() seems to return nothing.
        if VA_IControlInterface_GetIID(desc, iid) >= 0
            controls.Insert(IID_to_Name[iid] ? IID_to_Name[iid] : iid)
        ObjRelease(desc)
    }
}

GetComponentType(guid)
{
    ; KSNODETYPE_* GUID : SoundGet/Set ComponentType
    static TypeMap := {
    (Join,
        "{DFF21BE1-F70F-11D0-B917-00A0C9223196}": "Microphone"
		"{DFF21BE2-F70F-11D0-B917-00A0C9223196}": "Microphone"
		"{DFF21FE4-F70F-11D0-B917-00A0C9223196}": "Wave"
		"{6994AD04-93EF-11D0-A3CC-00A0C9223196}": "Wave"
		"{DFF21CE1-F70F-11D0-B917-00A0C9223196}": "Wave"
		"{DFF220E3-F70F-11D0-B917-00A0C9223196}": "CD"
		"{DFF220F3-F70F-11D0-B917-00A0C9223196}": "Synth"
		"{DFF21FE3-F70F-11D0-B917-00A0C9223196}": "Line"
		"{DFF21EE2-F70F-11D0-B917-00A0C9223196}": "Telephone"
		"{DFF21EE1-F70F-11D0-B917-00A0C9223196}": "Telephone"
		"{DFF21EE3-F70F-11D0-B917-00A0C9223196}": "Telephone"
		"{DFF21FE1-F70F-11D0-B917-00A0C9223196}": "Analog"
		"{DFF21FE5-F70F-11D0-B917-00A0C9223196}": "Digital"
    )}
    type := TypeMap[guid]
    return type ? type : "N/A"
}
