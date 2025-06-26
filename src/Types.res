@unboxed
type dateOrNumber = Date(Date.t) | Number(float)

@unboxed
type stringOrRegexp = String(string) | RegExp(RegExp.t)

type promiseStatus =
  | @as("pending") Pending | @as("fulfilled") Fulfilled | @as("rejected") Rejected

type fileDescriptor

type bufferEncoding =
  | @as("buffer") Buffer
  | @as("utf8") Utf8
  | @as("utf-8") Utf_8
  | @as("ascii") Ascii
  | @as("utf16le") Utf16le
  | @as("ucs2") Ucs2
  | @as("ucs-2") Ucs_2
  | @as("latin1") Latin1
  | @as("binary") Binary
  | @as("hex") Hex
  | @as("base64") Base64
  | @as("base64url") Base64url

// TODO
module ArrayBufferView = {
  type t = {}
}

// TODO
module SharedArrayBuffer = {
  type t
}

type fileSink
type bunFile

type fileBlob = bunFile

type any
external makeAny: 'any => any = "%identity"
