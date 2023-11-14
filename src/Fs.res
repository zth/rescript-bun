type watchOptions = {recursive?: bool}

type watchEventType =
  | @as("rename") Rename | @as("change") Change | @as("error") Error | @as("close") Close

@module("fs")
external watch: (string, ~options: watchOptions=?, (watchEventType, string) => unit) => unit =
  "watch"

@module("node:fs/promises")
external writeFile: (string, string) => promise<unit> = "writeFile"

type mkdirOpts = {recursive?: bool}

@module("node:fs/promises")
external mkdir: (string, ~options: mkdirOpts=?) => promise<unit> = "mkdir"
