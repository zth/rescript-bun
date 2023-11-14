type binaryToTextEncoding =
  | @as("base64") Base64 | @as("base64url") Base64URL | @as("hex") Hex | @as("binary") Binary
type characterEncoding =
  | @as("utf8") Utf8 | @as("utf-8") UtfDash8 | @as("utf16le") Utf16Le | @as("latin1") Latin1
type legacyCharacterEncodingWithoutBinary =
  | @as("ascii") Ascii | @as("ucs2") Ucs2 | @as("ucs-2") UcsDash2
type legacyCharacterEncoding = | ...legacyCharacterEncodingWithoutBinary | @as("binary") Binary

type encoding =
  | ...binaryToTextEncoding
  | ...characterEncoding
  | ...legacyCharacterEncodingWithoutBinary
