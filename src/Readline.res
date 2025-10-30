module Interface = {
  type t
  @send external close: t => unit = "close"
  @send external pause: t => unit = "pause"
  @send external prompt: (t, Nullable.t<bool>) => unit = "prompt"
  @send
  external question: (t, string, string => unit) => unit = "question"
  @send external resume: t => unit = "resume"
  @send external setPrompt: (t, string) => unit = "setPrompt"
  @send external write: (t, string) => unit = "write"
  type keyOptions = {
    ctrl?: bool,
    meta?: bool,
    shift?: bool,
    name?: string,
  }
  @send
  external writeKey: (t, Null.t<string>, keyOptions) => unit = "write"
  @send
  external writeKey2: (
    t,
    Null.t<string>,
    {"ctrl": option<bool>, "meta": option<bool>, "shift": option<bool>, "name": option<string>},
  ) => unit = "write"
  @get @return(nullable) external line: t => option<string> = "line"
  @get @return(nullable)
  external cursor: t => option<int> = "cursor"

  include EventEmitter.Impl({type t = t})
}

module Events = {
  open! Interface
  let close: (t, unit => unit) => t = (rl, f) => rl->on(Event.fromString("close"), f)
  let line: (t, string => unit) => t = (rl, f) => rl->on(Event.fromString("line"), f)
  let history: (t, array<string> => unit) => t = (rl, f) => rl->on(Event.fromString("history"), f)
}

type interfaceOptions<'rtype, 'wtype> = {
  input: Stream.Readable.subtype<Buffer.t, 'rtype>,
  output?: Stream.Writable.subtype<Buffer.t, 'wtype>,
  completer?: (string, (string, (array<string>, string)) => unit) => unit,
  terminal?: bool,
  historySize?: int,
  prompt?: string,
  crlfDelay?: float,
  removeHistoryDuplicates?: bool,
  escapeCodeTimeout?: int,
}
@module("node:readline")
external make: interfaceOptions<'rtype, 'wtype> => Interface.t = "createInterface"

@module("node:readline")
external clearLine: (Stream.Writable.subtype<Buffer.t, 'ty>, int, ~callback: unit => unit) => bool =
  "clearLine"

@module("node:readline")
external clearScreenDown: (
  Stream.Writable.subtype<Buffer.t, 'ty>,
  ~callback: unit => unit,
) => bool = "clearScreenDown"

@module("node:readline")
external cursorTo: (
  Stream.Writable.subtype<Buffer.t, 'ty>,
  ~x: int,
  ~y: int=?,
  ~callback: unit => unit=?,
  @ignore unit,
) => bool = "cursorTo"

@module("node:readline")
external moveCursor: (
  Stream.Writable.subtype<Buffer.t, 'ty>,
  ~dx: int,
  ~dy: int,
  ~callback: unit => unit=?,
  @ignore unit,
) => bool = "moveCursor"
