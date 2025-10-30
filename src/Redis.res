module RedisClient = {
  type t

  type setOptions = [#EX | #PX | #EXAT | #PXAT | #NX | #XX | #GET | #KEEPTTL]

  @unboxed
  type keyLike =
    | String(string)
    | ArrayBufferView(Types.ArrayBufferView.t)
    | Blob(Js.Blob.t)

  type redisOptions = {
    connectionTimeout?: int,
    idleTimeout?: int,
    autoReconnect?: bool,
    maxRetries?: int,
    enableOfflineQueue?: bool,
    tls?: bool,
    enableAutoPipelining?: bool,
  }

  @module("bun") @new
  external make: (~url: string=?, ~options: redisOptions=?) => t = "RedisClient"

  @external @get
  external connected: t => bool = "connected"

  @external @get
  external bufferedAmount: t => int = "bufferedAmount"

  @external @send
  external onconnect: (t, (t => unit) => unit) => unit = "onconnect"

  @external @send
  external onclose: (t, (t => unit, exn) => unit) => unit = "onclose"

  @external @send
  external connect: t => unit = "connect"

  @external @send
  external close: t => unit = "close"

  @external @send
  external send: (t, string, array<string>) => promise<unit> = "send"

  @external @send
  external get: (t, string) => promise<Null.t<string>> = "get"

  @external @send
  external getBuffer: (t, string) => promise<Null.t<Uint8Array.t>> = "getBuffer"

  @external @send
  external set: (t, string, keyLike) => promise<[#OK]> = "set"

  @external @send
  external setWithExpiry: (t, string, keyLike, [#EX | #PX | #EXAT | #PXAT], int) => promise<[#OK]> =
    "set"

  @external @send
  external setWithExists: (t, string, keyLike, [#NX | #XX]) => promise<Null.t<[#OK]>> = "set"

  @external @send
  external setWithGet: (t, string, keyLike, [#GET]) => promise<Null.t<string>> = "set"

  @external @send
  external setKeepTTL: (t, string, keyLike, [#KEEPTTL]) => promise<[#OK]> = "set"

  @external @send @variadic
  external setWithOptions: (t, string, keyLike, array<setOptions>) => promise<Null.t<string>> =
    "set"

  @external @send @variadic
  external del: (t, array<string>) => promise<int> = "del"

  @external @send
  external incr: (t, string) => promise<int> = "incr"

  @external @send
  external decr: (t, string) => promise<int> = "decr"

  @external @send
  external exists: (t, string) => promise<bool> = "exists"

  @external @send
  external expire: (t, string, float) => promise<int> = "expire"

  @external @send
  external ttl: (t, string) => promise<int> = "ttl"

  @external @send
  external hmset: (t, string, array<string>) => promise<string> = "hmset"

  @external @send
  external hmget: (t, string, array<string>) => promise<string> = "hmget"

  @external @send
  external sismember: (t, string, string) => promise<bool> = "sismember"

  @external @send
  external sadd: (t, string, string) => promise<int> = "sadd"

  @external @send
  external srem: (t, string, string) => promise<int> = "srem"

  @external @send
  external smembers: (t, string) => promise<array<string>> = "smembers"

  @external @send
  external srandmember: (t, string) => promise<Null.t<string>> = "srandmember"

  @external @send
  external spop: (t, string) => promise<Null.t<string>> = "spop"

  @external @send
  external hincrby: (t, string, string, int) => promise<int> = "hincrby"

  @external @send
  external hincrbyfloat: (t, string, string, float) => promise<string> = "hincrbyfloat"

  @external @send
  external hgetall: (t, string) => promise<dict<string>> = "hgetall"

  @external @send
  external hkeys: (t, string) => promise<array<string>> = "hkeys"

  @external @send
  external hlen: (t, string) => promise<int> = "hlen"

  @external @send
  external hvals: (t, string) => promise<array<string>> = "hvals"

  @external @send
  external keys: (t, string) => promise<array<string>> = "keys"

  @external @send
  external llen: (t, string) => promise<int> = "llen"

  @external @send
  external lpop: (t, string) => promise<Null.t<string>> = "lpop"

  @external @send
  external persists: (t, string) => promise<int> = "persists"

  @external @send
  external pexpiretime: (t, string) => promise<int> = "pexpiretime"

  @external @send
  external pttl: (t, string) => promise<int> = "pttl"

  @external @send
  external rpop: (t, string) => promise<Null.t<int>> = "rpop"

  @external @send
  external scard: (t, string) => promise<int> = "scard"

  @external @send
  external strlen: (t, string) => promise<int> = "strlen"

  @external @send
  external zcard: (t, string) => promise<int> = "zcard"

  @external @send
  external zpopmax: (t, string) => promise<Null.t<string>> = "zpopmax"

  @external @send
  external zpopmin: (t, string) => promise<Null.t<string>> = "zpopmin"

  @external @send
  external zrandmember: (t, string) => promise<Null.t<string>> = "zrandmember"

  @external @send
  external append: (t, string) => promise<int> = "append"

  @external @send
  external getset: (t, string, keyLike) => promise<Null.t<string>> = "getset"

  @external @send
  external lpush: (t, string, keyLike) => promise<int> = "lpush"

  @external @send
  external lpushx: (t, string, keyLike) => promise<int> = "lpushx"

  @external @send
  external pfadd: (t, string, string) => promise<int> = "pfadd"

  @external @send
  external rpush: (t, string, keyLike) => promise<int> = "rpush"

  @external @send
  external setnx: (t, string, keyLike) => promise<int> = "setnx"

  @external @send
  external zscore: (t, string, string) => promise<Null.t<string>> = "zscore"

  @external @send @variadic
  external mget: (t, array<string>) => promise<array<Null.t<string>>> = "mget"

  @external @send
  external bitcount: (t, string) => promise<int> = "bitcount"

  @external @send
  external dump: (t, string) => promise<Null.t<string>> = "dump"

  @external @send
  external expiretime: (t, string) => promise<int> = "expiretime"

  @external @send
  external getdel: (t, string) => promise<Null.t<string>> = "getdel"

  @external @send
  external getex: (t, string) => promise<Null.t<string>> = "getex"

  @external @send
  external ping: t => promise<[#PONG]> = "ping"
}

/**
  * Default Redis client
  *
  * Connection information populated from one of, in order of preference:
  * - `process.env.VALKEY_URL`
  * - `process.env.REDIS_URL`
  * - `"valkey://localhost:6379"`
  *
  */
let redis = RedisClient.make()
