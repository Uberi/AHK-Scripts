#NoEnv

/*
Copyright 2013 Anthony Zhang <azhang9@gmail.com>

This file is part of Geolocation. Source code is available at <https://github.com/Uberi/Geolocation>.

Geolocation is free software: you can redistribute it and/or modify
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

class Geolocation
{
    class Location
    {
        __New(Accuracy,Latitude,Longitude)
        {
            this.Accuracy := Accuracy
            this.Latitude := Latitude
            this.Longitude := Longitude
        }
    }

    Geolocate(RefreshNetworkList = False)
    {
        static hWLAN := DllCall("LoadLibrary","Str","wlanapi","UPtr") ;load the WLAN API library

        RequestURL := "https://maps.googleapis.com/maps/api/browserlocation/json?browser=firefox&sensor=true"

        APIVersion := 0
        If DllCall("wlanapi\WlanOpenHandle","UInt",2,"UPtr",0,"UInt*",APIVersion,"UPtr*",hClientHandle) = 0 ;ERROR_SUCCESS
        {
            If APIVersion >= 2 ;version 2 or greater is required
            {
                If DllCall("wlanapi\WlanEnumInterfaces","UPtr",hClientHandle,"UPtr",0,"UPtr*",pInterfaces) = 0 ;ERROR_SUCCESS
                {
                    Offset := 8
                    VarSetCapacity(GUID,16)
                    Loop, % NumGet(pInterfaces + 0,0,"UInt") ;loop over each interface, looking for one that is in the available state
                    {
                        DllCall("RtlMoveMemory","UPtr",&GUID,"UPtr",pInterfaces + Offset,"UPtr",16), Offset += 528 ;copy the interface GUID
                        If NumGet(pInterfaces + Offset,0,"UInt") != 0 ;wlan_interface_state_not_ready
                        {
                            Found := 1
                            Break
                        }
                        Offset += 4
                    }
                    DllCall("wlanapi\WlanFreeMemory","UPtr",pInterfaces) ;cleanup if call succeeded (only case where buffer is allocated)

                    If Found ;compatible interface found
                    {
                        If RefreshNetworkList ;network list should be refreshed
                        {
                            DllCall("wlanapi\WlanScan","UPtr",hClientHandle,"UPtr",&GUID,"UPtr",0,"UPtr",0,"UPtr",0) ;scan for networks
                            Sleep, 4000 ;wait while the scan completes (4 seconds is the standard upper limit for network drivers passing the Windows logo requirements)
                        }

                        If DllCall("wlanapi\WlanGetNetworkBssList","UPtr",hClientHandle,"UPtr",&GUID,"UPtr",0,"UPtr",0,"UPtr",0,"UPtr",0,"UPtr*",pWLANBSSList) = 0 ;ERROR_SUCCESS
                        {
                            Offset := 8
                            Loop, % NumGet(pWLANBSSList + 4,0,"UInt") ;loop over each wireless network, collecting information from each
                            {
                                ;DOT11_SSID structure
                                Length := Numget(pWLANBSSList + Offset,0,"UInt"), Offset += 4 ;length of the SSID string
                                SSID := StrGet(pWLANBSSList + Offset,Length,"CP0"), Offset += 32 ;SSID string

                                Offset += 4 ;PHY ID

                                ;DOT11_MAC_ADDRESS structure
                                MACAddress := ""
                                FormatInteger := A_FormatInteger
                                SetFormat, IntegerFast, Hex
                                Loop, 6
                                    MACAddress .= SubStr("0" . SubStr(NumGet(pWLANBSSList + Offset,A_Index - 1,"UChar"),3),-1) . "-"
                                SetFormat, IntegerFast, %FormatInteger%
                                MACAddress := SubStr(MACAddress,1,-1), Offset += 6

                                Offset += 2 ;align to a 4 byte boundary

                                ;skip over "Ad Hoc" networks (dot11_BSS_type_independent)
                                If NumGet(pWLANBSSList + Offset,0,"UInt") = 2
                                {
                                    Offset += 312
                                    Continue
                                }
                                Offset += 4

                                Offset += 4 ;PHY type

                                SignalStrength := NumGet(pWLANBSSList + Offset,0,"UInt"), Offset += 4 ;RSSI in dBm

                                Offset += 4 ;link quality
                                Offset += 4 ;station is operating in regulatory domain
                                Offset += 2 ;beacon period in multiples of 1024 microseconds
                                Offset += 2 ;align to a 4 byte boundary
                                Offset += 8 ;response timestamp from station
                                Offset += 8 ;response timestamp from host
                                Offset += 2 ;capability information
                                Offset += 2 ;align to a 4 byte boundary
                                Offset += 4 ;channel center frequency in kHz
                                Offset += 256 ;WLAN_RATE_SET structure
                                Offset += 4 ;information element data blob offset
                                Offset += 4 ;information element data blob size

                                RequestURL .= "&wifi=mac:" . MACAddress . "%7Cssid:" . SSID . "%7Css:" . Round(SignalStrength)
                            }
                            DllCall("wlanapi\WlanFreeMemory","UPtr",pWLANBSSList) ;cleanup if call succeeded (only case where buffer is allocated)
                        }
                    }
                }
            }
            DllCall("wlanapi\WlanCloseHandle","UPtr",hClientHandle,"UPtr",0)
        }

        try
        {
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("GET",RequestURL)
            WebRequest.Send()
            Response := WebRequest.ResponseText
        }
        catch e
            throw Exception("Could not send location request.")

        ;parse response
        If !(RegExMatch(Response,"iS)""accuracy""\s*:\s*\K[\d\.-]+",Accuracy)
            && RegExMatch(Response,"iS)""lat""\s*:\s*\K[\d\.-]+",Latitude)
            && RegExMatch(Response,"iS)""lng""\s*:\s*\K[\d\.-]+",Longitude)
            && RegExMatch(Response,"iS)""status""\s*:\s*""\K[^""]*",Status))
            || Status != "OK"
            throw Exception("Could not obtain location response from provider.")

        Return, new this.Location(Accuracy,Latitude,Longitude)
    }

    ToAddress(Location)
    {
        RequestURL := "http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=" . Location.Latitude . "," . Location.Longitude
        try
        {
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("GET",RequestURL)
            WebRequest.Send()
            Response := WebRequest.ResponseText
        }
        catch e
            throw Exception("Could not send request.")

        Result := []
        FoundPos := 1
        While, FoundPos := RegExMatch(Response,"iS)""formatted_address""\s*:\s*""([^""]*)",Match,FoundPos)
            Result.Insert(Match1), FoundPos += StrLen(Match)

        If !RegExMatch(Response,"iS)""status""\s*:\s*""\K[^""]*",Status)
            || Status != "OK"
            || !Result.MaxIndex()
            throw Exception("Could not obtain address response from provider.")

        Return, Result
    }

    ToLocation(Address)
    {
        RequestURL := "http://maps.googleapis.com/maps/api/geocode/xml?sensor=true&address=" . Address
        try
        {
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("GET",RequestURL)
            WebRequest.Send()
            Response := WebRequest.ResponseText
        }
        catch e
            throw Exception("Could not send request.")

        Document := ComObjCreate("MSXML2.DOMDocument")
        If !Document.loadXML(Response)
            || Document.getElementsByTagName("status").item(0).text != "OK"
            throw Exception("Could not obtain location response from provider.")

        Result := []
        Radius := 6367500 ;radius of the earth in meters
        Radians := 3.141592653589793 / 180

        Geometries := Document.getElementsByTagName("geometry")
        Loop, % Geometries.Length
        {
            Geometry := Geometries.item(A_Index - 1)

            Latitude := Geometry.selectSingleNode("location/lat").text
            Longitude := Geometry.selectSingleNode("location/lng").text

            If Geometry.selectSingleNode("location_type").text = "ROOFTOP" ;exact location
                Accuracy := 0
            Else ;approximate location
            {
                Bound1X := Geometry.selectSingleNode("viewport/southwest/lng").text
                Bound2X := Geometry.selectSingleNode("viewport/northeast/lng").text
                VariationX := Abs(Bound1X - Bound2X)
                If VariationX > 180
                    VariationX := 360 - VariationX
                Accuracy := VariationX * Radians * Radius ;variation in meters
            }

            Result.Insert(new this.Location(Accuracy,Latitude,Longitude))
        }

        Return, Result
    }
}