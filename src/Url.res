module SearchParams = {
  type rec t = {
    @as("append")
    append: (~name: string, ~value: string) => unit,
    @as("delete")
    delete: string => unit,
    @as("forEach")
    forEach: ((~value: string, ~name: string=?, ~searchParams: t=?) => unit) => unit,
    @as("get")
    get: string => Null.t<string>,
    @as("getAll")
    getAll: string => array<string>,
    @as("has")
    has: string => bool,
    @as("set")
    set: (~name: string, ~value: string) => unit,
    @as("sort")
    sort: unit => unit,
    @as("toString")
    toString: unit => string,
    // [@bs.as "[Symbol.iterator]"] iteratorSymbol: unit => iterator, // no type definition for 'iterator'
    // [@bs.as "values"] values: unit => iterator, // no type definition for 'iterator'
    // [@bs.as "entries"] entries: unit => iterator, // no type definition for 'iterator'
    // [@bs.as "keys"] keys: unit => iterator, // no type definition for 'iterator'
  }
  @new external empty: unit => t = "URLSearchParams"
  @new external fromString: string => t = "URLSearchParams"
  @new external fromDict: dict<string> => t = "URLSearchParams"
  // [@bs.new] external fromIterable: iterable => t = "URLSearchParams"; // no type definition for 'iterator'
}

type t = {
  hash: string,
  host: string,
  hostname: string,
  href: string,
  origin: string,
  password: string,
  pathname: string,
  port: int,
  protocol: string,
  search: string,
  searchParams: SearchParams.t,
  username: string,
  toString: unit => string,
  toJson: unit => JSON.t,
}

@module("node:url") @new external make: string => t = "URL"
@module("node:url") @new
external fromBaseString: (~input: string, ~base: string) => t = "URL"
@module("node:url") @new
external fromBaseUrl: (~input: string, ~base: t) => t = "URL"

@module("node:url") external domainToASCII: string => string = "domainToASCII"
@module("node:url")
external domainToUnicode: string => string = "domainToUnicode"
@module("node:url") external fileURLToPath: t => string = "fileURLToPath"
@module("node:url")
external fileStringToPath: string => string = "fileURLToPath"

type urlFormatOptions = {"auth": bool, "fragment": bool, "search": bool, "unicode": bool}

@module("node:url")
external format: (
  t,
  {
    "auth": Nullable.t<bool>,
    "fragment": Nullable.t<bool>,
    "search": Nullable.t<bool>,
    "unicode": Nullable.t<bool>,
  },
) => string = "format"
let format = (~auth=?, ~fragment=?, ~search=?, ~unicode=?, url) =>
  format(
    url,
    {
      "auth": Nullable.fromOption(auth),
      "fragment": Nullable.fromOption(fragment),
      "search": Nullable.fromOption(search),
      "unicode": Nullable.fromOption(unicode),
    },
  )

@module("node:url") external pathToFileURL: string => t = "pathToFileURL"
