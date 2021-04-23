Geolocation
===========
Simple API for various geolocation-related tasks.

Reference
---------

### Geolocation.Geolocate(RefreshNetworkList = False)

Obtains the current location of the device.

The `RefreshNetworkList` parameter is a boolean value that describes whether the list of wireless networks should be refreshed prior to using it.

It is false by default since a scan can take up to 4 seconds and is already done automatically at certain intervals.

Returns a `Geolocation.Location` object describing the device location.

### Geolocation.ToAddress(Location)

Given a location, obtains a list of human readable addresses that correspond to it.

The `Location` parameter is a `Geolocation.Location` object that can be obtained through functions such as `Geolocation.Geolocate`.

Returns an array of strings representing human readable addresses, sorted from best match to worst match.

### Geolocation.ToLocation(Address)

Given a human readable address, obtains a list of locations that correspond to it.

The `Address` parameter is a string representing a human readable address, such as "123 Test Street".

Returns an array of `Geolocation.Location` objects, sorted from best match to worst match.

### Geolocation.Location

Object describing a physical location on the surface of the Earth.

Properties:

* `Location.Accuracy` - expected deviation of described location from true location, in meters (positive real number).
* `Location.Latitude` - estimated latitude of location, in degrees north of the equator (real number between -90 and 90 inclusive)
* `Location.Longitude` - estimated longitude of location, in degrees east of the Prime Meridian (real number between -1800 and 180 inclusive)

Examples
--------

Obtain location of the device:

    Location := Geolocation.Geolocate()
    MsgBox, % "The current location is " . Location.Latitude . ", " . Location.Longitude . "."

Obtain address of the device:

    Location := Geolocation.Geolocate()
    Addresses := Geolocation.ToAddress(Location)
    MsgBox, % "The current address is " . Addresses[1] . "."

Obtain address of a location:

    Addresses := Geolocation.ToAddress(new Geolocation.Location(0,34,23))
    MsgBox, % "The address is " . Addresses[1] . "."

Obtain location of an address:

    Locations := Geolocation.ToLocation("123 Test Street")
    For Index, Value In Locations
        MsgBox, % "The location is " . Location.Latitude . ", " . Location.Longitude . "."

License
-------

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