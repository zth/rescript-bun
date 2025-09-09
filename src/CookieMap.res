type t = Map.t<string, string>

type cookieStoreDeleteOptions = {
  name: string,
  domanin?: null<string>,
  path?: string,
}

@module("bun") @new
external make: unit => t = "CookieMap"

@module("bun") @new
external fromArray: array<(string, string)> => t = "CookieMap" 

@module("bun") @new
external fromDictionary: dict<string> => t = "CookieMap"

@module("bun") @new
external fromString: string => t = "CookieMap"

@send external toSetCookieHeaders: t => array<string> = "toSetCookieHeaders"
@send external get: (t, string) => null<string> = "get"
@send external has: (t, string) => bool = "has"
@send external set: (t, string, string, ~options: Cookie.cookieInit=?) => unit = "set"
@send external setFromOptions: (t, Cookie.cookieInit) => unit = "set"
@send external delete: (t, cookieStoreDeleteOptions) => unit = "delete"
@send external toJSON: t => dict<string> = "toJSON"
@get external size: t => int = "size"
@send external entries: t => Iterator.t<(string, string)> = "entries"
@send external keys: t => Iterator.t<string> = "entries"
@send external values: t => Iterator.t<string> = "entries"
@send external forEach: (t, (string, string, t) => unit) => unit = "forEach"

