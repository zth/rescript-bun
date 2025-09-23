open Globals
module SQLQuery = {
  type t<'a> = promise<'a>
  
  @val external active: t<'a> => bool = "active"
  @val external cancelled: t<'a> => bool = "cancelled"
  @send external cancel: t<'a> => t<'a> = "cancel"
  @send external simple: t<'a> => t<'a> = "simple"
  @send external execute: t<'a> => t<'a> = "execute"
  @send external raw: t<'a> => t<'a> = "raw"
  @send external values: t<'a> => t<'a> = "values" 
}

@unboxed
type rec param =
| Boolean(bool)
| @as(null) Null
| String(string)
| Number(float)
| Dict(Core__Dict.t<param>)
| Array(array<param>)
| Query(SQLQuery.t<param>)

type t

@module("bun") @new
external make: string => t = "SQL"

module TemplateStringsArray = {
  let fromArray: array<'a> => array<'a> = %raw(`
    function(array) {
      array.raw = [...array]
      return array
    }
  `)
}

let query: (t, array<string>, array<param>) => SQLQuery.t<param> = %raw(`
  function(t, strings, params) {
    let templateArray = TemplateStringsArray.fromArray(strings)

    return t(templateArray, ...params)
  }
`)

let object: (t, {..}, array<string>) => SQLQuery.t<param> = %raw(`
  function(t, obj, cols) {
    return t(obj, ...cols)
  } 
`)

let values: (t, array<'a>) => SQLQuery.t<param> = %raw(`
  function(t, values) {
    return t(arr)
  }
`)

@send
external commitDistributed: (t, string) => promise<unit> = "commitDistributed" 

@send
external rollbackDistributed: (t, string) => promise<unit> = "rollbackDistributed" 

@send
external connect: (t, unit) => promise<unit> = "connect" 

type options = {
  timeout?: float
}

@send
external close: (t, ~options: options=?) => promise<unit> = "close"

@send
external end: (t, ~options: options=?) => promise<unit> = "end"

@send
external flush: t => unit = "flush"

@send
external reserve: t => t = "reserve"

type sqlTransactionContextCallback<'a> = t => promise<'a> 

@send
external begin: (t, sqlTransactionContextCallback<'b>) => promise<'a> = "begin"

@send
external transaction: (t, sqlTransactionContextCallback<'b>) => promise<'a> = "transaction"

@send
external beginDistributed: (t, string, sqlTransactionContextCallback<'b>) => promise<'a> = "beginDistributed"

@send
external distributed: (t, string, sqlTransactionContextCallback<'b>) => promise<'a> = "distributed"

@send
external unsafe: (t, string, ~values: array<JSON.t>=?) => SQLQuery.t<param> = "unsafe"

@send
external file: (t, string, ~values: array<JSON.t>=?) => SQLQuery.t<param> = "file" 

type rec sqlOptions = {
  filename?: string,
  // Connection URL (can be string or URL object)
  url?: URL.t,
  // Database server hostname
  host?: string,
  // Database server hostname (alias for host)
  hostname?: string,
  // Database server port number
  port?: int,
  // Database user for authentication
  username?: string,
  // Database user for authentication (alias for username)
  user?: string,
  // Database password for authentication
  password?: string,
  // Database password for authentication (alias for password)
  pass?: string,
  // Name of the database to connect to
  database?: string,
  // Name of the database to connect to (alias for database)
  db?: string,
  // Database adapter/driver to use
  adapter?: string,
  // Maximum time in seconds to wait for connection to become available
  idleTimeout?: float,
  // Maximum time in seconds to wait for connection to become available (alias for idleTimeout)
  idle_timeout?: float,
  // Maximum time in seconds to wait when establishing a connection
  connectionTimeout?: float,
  // Maximum time in seconds to wait when establishing a connection (alias for connectionTimeout)
  connection_timeout?: float,
  // Maximum lifetime in seconds of a connection
  maxLifetime?: float,
  // Maximum lifetime in seconds of a connection (alias for maxLifetime)
  max_lifetime?: float,
  // Whether to use TLS/SSL for the connection
  tls?: bool,
  // Whether to use TLS/SSL for the connection (alias for tls)
  ssl?: bool,
  // Callback function executed when a connection is established
  onconnect?: t => unit,
  // Callback function executed when a connection is closed
  onclose?: t => unit,
  // Maximum number of connections in the pool
  max?: int,
  // By default values outside i32 range are returned as strings. If this is true, values outside i32 range are returned as BigInts.
  bigint?: bool,
  // Automatic creation of prepared statements, defaults to true
  prepare?: bool,
}

@get
external options: t => sqlOptions = "options"

@module("bun") @new
external fromOptions: sqlOptions => t = "SQL"
