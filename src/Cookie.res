@unboxed
type expires = 
| Number(int)
| Date(Date.t)
| String(string)

type cookieInit = {
  name?: string,
  value?: string,
  domain?: string,
  path?: string,
  expires?: expires,
  secure?: bool,
  sameSite?: [#strict | #lax | #none],
  httpOnly?: bool,
  partitioned?: bool,
  maxAge?: int,
}

type t = cookieInit

@module("bun") @new
external make: cookieInit => t = "Cookie"

@module("bun") @new
external fromString: string => t = "Cookie"

@send external isExpired: t => bool = "isExpired"
@send external serialize: t => string = "serialize"
@send external toString: t => string = "toString"
@send external toJSON: t => cookieInit = "toJSON"

@module("bun") @scope("Cookie")
external parse: string => t = "parse"

@module("bun") @scope("Cookie")
external from: (string, string, ~options:cookieInit=?) => t = "from"