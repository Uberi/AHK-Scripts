/*
  COM registry class for AutoHotkey >=1.1.00.00
  Last updated 7/31/2011
  Copyright (C) 2011 Bryan Perry <ih57452[AT]gmail.com>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

class Registry {
  ;ErrorLevel will be set to an error code if there is an error, or 0 if it succeeded.
  ;Use an empty string to get and set Default values.
  
  static trees := {HKEY_LOCAL_MACHINE:  0x80000002, HKLM: 0x80000002
                  ,HKEY_USERS:          0x80000003, HKU:  0x80000003
                  ,HKEY_CURRENT_USER:   0x80000001, HKCU: 0x80000001
                  ,HKEY_CLASSES_ROOT:   0x80000000, HKCR: 0x80000000
                  ,HKEY_CURRENT_CONFIG: 0x80000005, HKCC: 0x80000005}

  static permissions := {KEY_QUERY_VALUE:        0x1      ;Required to query the values of a registry key.
                        ,KEY_SET_VALUE:          0x2      ;Required to create, delete, or set a registry value.
                        ,KEY_CREATE_SUB_KEY:     0x4      ;Required to create a subkey of a registry key.
                        ,KEY_ENUMERATE_SUB_KEYS: 0x8      ;Required to enumerate the subkeys of a registry key.
                        ,KEY_NOTIFY:             0x10     ;Required to request change notifications for a registry key or for subkeys of a registry key.
                        ,KEY_CREATE:             0x20     ;Required to create a registry key.
                        ,DELETE:                 0x10000  ;Required to delete a registry key.
                        ,READ_CONTROL:           0x20000  ;Combines the STANDARD_RIGHTS_READ, KEY_QUERY_VALUE, KEY_ENUMERATE_SUB_KEYS, and KEY_NOTIFY values.
                        ,WRITE_DAC:              0x40000  ;Required to modify the DACL in the object's security descriptor.
                        ,WRITE_OWNER:            0x80000} ;Required to change the owner in the object's security descriptor.
                                                          ;You can add these values together to verify more than one access permission.

  static types := {REG_SZ:        1
                  ,REG_EXPAND_SZ: 2
                  ,REG_BINARY:    3
                  ,REG_DWORD:     4
                  ,REG_MULTI_SZ:  7
                  ,REG_QWORD:    11}

  __New(mode = 64, tree = "") {
    this.SetMode(mode)
    if (tree = "")
      tree := this.trees.HKLM
    this.tree := tree
  }
  
  __Set(key, value) {
    if (key = "mode")
      this.SetMode(value)
  }
  
  SetMode(mode) {
    if mode not in 32,64
    {
      MsgBox, 16, Error, Mode must be either 32 or 64.
      return
    }
    this.objCtx := ComObjCreate("WbemScripting.SWbemNamedValueSet")
    this.objCtx.Add("__ProviderArchitecture", mode)
    this.objCtx.Add("__RequiredArchitecture", ComObjParameter(0xB, -1))
    this.objLocator := ComObjCreate("Wbemscripting.SWbemLocator")
    this.objServices := this.objLocator.ConnectServer(ComObjMissing(), "root\default", ComObjMissing(), ComObjMissing(), ComObjMissing(), ComObjMissing(), ComObjMissing(), this.objCtx)
    this.objStdRegProv := this.objServices.Get("StdRegProv")
  }
  
  CheckAccess(PermissionsRequired, SubKey = "") {
    ;returns 1 if access granted or 0 if access denied
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("CheckAccess").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.uRequired := PermissionsRequired
    Outparams := this.objStdRegProv.ExecMethod_("CheckAccess", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    if (Outparams.bGranted = -1)
      return, 1
    return, 0
  }
  
  CreateKey(SubKey = "") {
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("CreateKey").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Outparams := this.objStdRegProv.ExecMethod_("CreateKey", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  DeleteKey(SubKey = "") {
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("DeleteKey").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Outparams := this.objStdRegProv.ExecMethod_("DeleteKey", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  DeleteValue(ValueName, SubKey = "") {
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("DeleteValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("DeleteValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  EnumKey(SubKey = "") {
    ;returns an array of subkey names
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("EnumKey").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Outparams := this.objStdRegProv.ExecMethod_("EnumKey", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    returnObj := []
    for name in Outparams.sNames
      returnObj.Insert(name)
    return, returnObj
  }
  
  EnumValues(SubKey = "") {
    ;returns an associative array of values in the form of {ValueName: ValueType}
    ;ValueType is one of the values in Registry.types
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("EnumValues").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Outparams := this.objStdRegProv.ExecMethod_("EnumValues", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    names := []
    for name in Outparams.sNames
      names.Insert(name)
    types := []
    for type in Outparams.Types
      types.Insert(type)
    returnObj := {}
    for k, name in names
      returnObj[name] := types[A_Index]
    return, returnObj
  }
  
  GetBinaryValue(ValueName, SubKey = "") {
    ;returns a REG_BINARY value as an array of bytes
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetBinaryValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetBinaryValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    returnObj := []
    for value in Outparams.uValue
      returnObj.Insert(value)
    return, returnObj
  }
  
  GetDWORDValue(ValueName, SubKey = "") {
    ;returns a REG_DWORD value
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetDWORDValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetDWORDValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.uValue
  }
  
  GetExpandedStringValue(ValueName, SubKey = "") {
    ;returns a REG_EXPAND_SZ value
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetExpandedStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetExpandedStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.sValue
  }
  
  GetMultiStringValue(ValueName, SubKey = "") {
    ;returns a REG_MULTI_SZ value as an array of strings
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetMultiStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetMultiStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    returnObj := []
    for value in Outparams.sValue
      returnObj.Insert(value)
    return, returnObj
  }
  
  GetQWORDValue(ValueName, SubKey = "") {
    ;returns a REG_QWORD value
    ;Windows Server 2003, Windows XP, Windows 2000, Windows NT 4.0, and Windows Me/98/95: This method is not available.
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetQWORDValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetQWORDValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.uValue
  }
  
  GetStringValue(ValueName, SubKey = "") {
    ;returns a REG_SZ value
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("GetStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Outparams := this.objStdRegProv.ExecMethod_("GetStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.sValue
  }
  
  SetBinaryValue(ValueName, Value, SubKey = "") {
    ;sets a REG_BINARY value to an array of bytes
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetBinaryValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    for k, v in Value
      Inparams.uValue[k-1] := v
    Outparams := this.objStdRegProv.ExecMethod_("SetBinaryValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  SetDWORDValue(ValueName, Value, SubKey = "") {
    ;sets a REG_DWORD value
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetDWORDValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Inparams.uValue := Value
    Outparams := this.objStdRegProv.ExecMethod_("SetDWORDValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  SetExpandedStringValue(ValueName, Value, SubKey = "") {
    ;sets a REG_EXPAND_SZ value
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetExpandedStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Inparams.sValue := Value
    Outparams := this.objStdRegProv.ExecMethod_("SetExpandedStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  SetMultiStringValue(ValueName, Value, SubKey = "") {
    ;sets a REG_MULTI_SZ value to an array of strings
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetMultiStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    for k, v in Value
      Inparams.sValue[k-1] := v
    Outparams := this.objStdRegProv.ExecMethod_("SetMultiStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  SetQWORDValue(ValueName, Value, SubKey = "") {
    ;sets a REG_QWORD value
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetQWORDValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Inparams.uValue := Value
    Outparams := this.objStdRegProv.ExecMethod_("SetQWORDValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
  
  SetStringValue(ValueName, Value, SubKey = "") {
    ;sets a REG_SZ value
    ;returns 0 if successful or an error code if failed
    if (SubKey = "") {
      SubKey := this.SubKey
      if (SubKey = "") {
        MsgBox, 16, Error, SubKey is not defined.
        return
      }
    }
    Inparams := this.objStdRegProv.Methods_("SetStringValue").Inparameters
    Inparams.hDefKey := this.tree
    Inparams.sSubKeyName := SubKey
    Inparams.sValueName := ValueName
    Inparams.sValue := Value
    Outparams := this.objStdRegProv.ExecMethod_("SetStringValue", Inparams, ComObjMissing(), this.objCtx)
    ErrorLevel := Outparams.ReturnValue
    return, Outparams.ReturnValue
  }
}