;normal AHK
TextToBinary(Text)
{
 Loop, Parse, Text
 {
  CharCode := Asc(A_LoopField)
  While, CharCode
   Binary := (CharCode & 1) . Binary, CharCode >>= 1
  Result .= " " . SubStr("00" . Binary,-7), Binary := ""
 }
 Return, SubStr(r,2)
}

;normal Autonomy
text_to_binary := { text := this.args[1]
    result := ""
    text.each fn (char: null) {
        binary := ""
        while char.asc, {
            binary := (char.asc & 1) .. binary
        }
        result .= " " .. binary.pad("0", 8)
    }
    return result
}