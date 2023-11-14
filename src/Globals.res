open Types

type dOMHighResTimeStamp = float
type messageEventSource = unit

type binaryType = | @as("nodebuffer") NodeBuffer | @as("arraybuffer") ArrayBuffer | @as("blob") Blob

// TODO
type buffer

type importMeta = {
  /**
   * `file://` url string for the current module.
   *
   * @example
   * ```ts
   * console.log(import.meta.url);
   * "file:///Users/me/projects/my-app/src/my-app.ts"
   * ```
   */
  url: string,
  /**
   * Absolute path to the source file
   */
  path: string,
  /**
   * Absolute path to the directory containing the source file.
   *
   * Does not have a trailing slash
   */
  dir: string,
  /**
   * Filename of the source file
   */
  file: string,
  /**
   * Resolve a module ID the same as if you imported it
   * Set `parent` to resolve the `moduleId` as though it were imported from `parent`
   *
   * On failure, throws a `ResolveMessage`
   */
  resolve: (~moduleId: string, ~parent: string=?) => promise<string>,
  /**
   * Resolve a module ID the same as if you imported it
   *
   * The `parent` argument is optional, and defaults to the current module's path.
   */
  resolveSync: (~moduleId: string, ~parent: string=?) => string,
  // TODO
  /*
   * Load a CommonJS module
   *
   * Internally, this is a synchronous version of ESModule's `import()`, with extra code for handling:
   * - CommonJS modules
   * - *.node files
   * - *.json files
   *
   * Warning: **This API is not stable** and may change in the future. Use at your
   * own risk. Usually, you should use `require` instead and Bun's transpiler
   * will automatically rewrite your code to use `import.meta.require` if
   * relevant.
   */
  // require: NodeJS.Require;

  /**
   * Did the current file start the process?
   *
   * @example
   * ```ts
   * if (import.meta.main) {
   *  console.log("I started the process!");
   * }
   * ```
   *
   * @example
   * ```ts
   * console.log(
   *   import.meta.main === (import.meta.path === Bun.main)
   * )
   * ```
   */
  main: bool,
}

type import = {meta: importMeta}
external import: import = "import"

module BufferSource = {
  type t
}

type rec arrayBuffer = {
  /**
   * Read-only. The length of the ArrayBuffer (in bytes).
   */
  byteLength: float,
  /**
   * Resize an ArrayBuffer in-place.
   */
  resize: float => arrayBuffer,
  /**
   * Returns a section of an ArrayBuffer.
   */
  slice: (~begin: float, ~end: float=?) => arrayBuffer,
  // readonly [Symbol.toStringTag]: string;
}

type structuredCloneOptions = {transfer?: array<arrayBuffer>}

/**
 * Creates a deep clone of an object.
 *
 * [MDN Reference](https://developer.mozilla.org/docs/Web/API/structuredClone)
 */
external structuredClone: ('value, ~options: structuredCloneOptions=?) => 'value = "structuredClone"

// TODO: Worker threads
// TODO: Workers
type messagePort
// TODO: Process

module HeadersInit = {
  @unboxed type t = FromArray(array<(string, string)>) | FromDict(Js.Dict.t<string>)
}

/**
 * This Fetch API interface allows you to perform various actions on HTTP
 * request and response headers. These actions include retrieving, setting,
 * adding to, and removing. A Headers object has an associated header list,
 * which is initially empty and consists of zero or more name and value
 * pairs.
 *
 * You can add to this using methods like append()
 *
 * In all methods of this interface, header names are matched by
 * case-insensitive byte sequence.
 */
module Headers = {
  type t

  @new external make: (~init: HeadersInit.t=?) => t = "Headers"

  @send external append: (t, string, string) => unit = "append"
  @send external delete: (t, string) => unit = "delete"
  @return(nullable) @send external get: (t, string) => option<string> = "get"
  @send external has: (t, string) => bool = "has"
  @send external set: (t, string, string) => unit = "set"
  @send external entries: t => Iterator.t<(string, string)> = "entries"
  @send external keys: t => Iterator.t<string> = "keys"
  @send external values: t => Iterator.t<string> = "values"
  @send external forEach: (t, (string, string, t) => unit) => unit = "forEach"

  /**
   * Convert {@link Headers} to a plain JavaScript object.
   *
   * About 10x faster than `Object.fromEntries(headers.entries())`
   *
   * Called when you run `JSON.stringify(headers)`
   *
   * Does not preserve insertion order. Well-known header names are lowercased. Other header names are left as-is.
   */
  @send
  external toJSON: t => Dict.t<string> = "toJSON"

  /**
   * Get the total number of headers
   */
  @get
  external count: t => int = "count"

  /**
   * Get all headers matching "Set-Cookie"
   *
   * Only supports `"Set-Cookie"`. All other headers are empty arrays.
   *
   * @returns An array of header values
   *
   * @example
   * ```rescript
   * let headers = Headers.make()
   * headers->Headers.append("Set-Cookie", "foo=bar")
   * headers->Headers.append("Set-Cookie", "baz=qux")
   * let cookies = headers->Headers.getAllCookies // ["foo=bar", "baz=qux"]
   * ```
   */
  @send
  external getAllCookies: (t, @as("Set-Cookie") _) => array<string> = "getAll"
}

module FormData = {
  type t

  @new external make: unit => t = "FormData"

  @unboxed type formDataEntryValue = String(string) | File(Js.File.t)
  @unboxed type formDataValueResult = | ...formDataEntryValue | @as(null) Null

  @send external get: (t, string) => formDataValueResult = "get"
  @send external getAll: (t, string) => array<formDataEntryValue> = "getAll"

  @unboxed
  type stringOrBlob = String(string) | Blob(Js.Blob.t)

  /**
   * Appends a new value onto an existing key inside a FormData object, or adds
   * the key if it does not already exist.
   *
   * @param name The name of the field whose data is contained in value.
   * @param value The field's value.
   * @param fileName The filename reported to the server.
   *
   * ## Upload a file
   * ```ts
   * const formData = new FormData();
   * formData.append("username", "abc123");
   * formData.append("avatar", Bun.file("avatar.png"), "avatar.png");
   * await fetch("https://example.com", { method: "POST", body: formData });
   * ```
   */
  @send
  external append: (t, string, stringOrBlob, ~fileName: string=?) => unit = "append"
  @send external delete: (t, string) => unit = "delete"
  @send external has: (t, string) => bool = "has"
  @send external set: (t, string, stringOrBlob, ~fileName: string=?) => unit = "set"
  @send external keys: t => Iterator.t<string> = "keys"
  @send external values: t => Iterator.t<formDataEntryValue> = "values"
  @send external entries: t => Iterator.t<(string, formDataEntryValue)> = "entries"
  @send external forEach: ((formDataEntryValue, string, t) => unit) => unit = "forEach"
}

// TODO: extends EventTarget
module AbortSignal = {
  type t
  /**
   * Returns true if this AbortSignal's AbortController has signaled to abort, and false otherwise.
   */
  @get
  external aborted: t => bool = "aborted"

  /**
   * The reason the signal aborted, or undefined if not aborted.
   */
  @get
  external reason: t => 'any = "reason"

  // onabort: ((this: AbortSignal, ev: Event) => any) | null;
  /* addEventListener<K extends keyof AbortSignalEventMap>(
    type: K,
    listener: (this: AbortSignal, ev: AbortSignalEventMap[K]) => any,
    options?: boolean | AddEventListenerOptions,
  ): void;
  addEventListener(
    type: string,
    listener: EventListenerOrEventListenerObject,
    options?: boolean | AddEventListenerOptions,
  ): void;
  removeEventListener<K extends keyof AbortSignalEventMap>(
    type: K,
    listener: (this: AbortSignal, ev: AbortSignalEventMap[K]) => any,
    options?: boolean | EventListenerOptions,
  ): void;
  removeEventListener(
    type: string,
    listener: EventListenerOrEventListenerObject,
    options?: boolean | EventListenerOptions,
  ): void;*/

  @new external make: unit => t = "AbortSignal"

  external abort: (~reason: 'any=?) => t = "AbortSignal.abort"

  /**
   * Create an AbortSignal which times out after milliseconds
   *
   * @param milliseconds the number of milliseconds to delay until {@link AbortSignal.prototype.signal()} is called
   *
   * @example
   *
   * ## Timeout a `fetch()` request
   *
   * ```ts
   * await fetch("https://example.com", {
   *    signal: AbortSignal.timeout(100)
   * })
   * ```
   */
  external timeout: (~milliseconds: float) => t = "AbortSignal.timeout"
}

type readableStreamDefaultController<'r> = {
  desiredSize: Null.t<float>,
  close: unit => unit,
  enqueue: (~chunk: 'r=?) => unit,
  error: (~e: any) => unit,
}

type readableStreamController<'r> = readableStreamDefaultController<'r>

type underlyingSourceCancelCallback = (~reason: any=?) => unit

type underlyingSourcePullCallback<'r> = readableStreamController<'r> => unit

type underlyingSourceStartCallback<'r> = readableStreamController<'r> => unknown

type underlyingSource<'r> = {
  cancel?: underlyingSourceCancelCallback,
  pull?: underlyingSourcePullCallback<'r>,
  start?: underlyingSourceStartCallback<'r>,
  /**
   * Mode "bytes" is not currently supported.
   */
  @as("type")
  type_?: unit,
}

module ReadableStreamDirectController = {
  type t

  @send external close: (t, ~error: Error.t=?) => unit = "close"
  @send external writeBufferSource: (t, BufferSource.t) => float = "write"
  @send external writeBufferSourceAsync: (t, BufferSource.t) => promise<float> = "write"

  @send external writeArrayBuffer: (t, ArrayBuffer.t) => float = "write"
  @send external writeArrayBufferAsync: (t, ArrayBuffer.t) => promise<float> = "write"

  @send external writeString: (t, string) => float = "write"
  @send external writeStringAsync: (t, string) => promise<float> = "write"

  @send external end: t => float = "end"
  @send external endAsync: t => promise<float> = "end"

  @send external flush: t => float = "flush"
  @send external flushAsync: t => promise<float> = "flush"
  @send external start: t => unit = "start"
}

type directUnderlyingSource<'r> = {
  cancel?: underlyingSourceCancelCallback,
  pull: ReadableStreamDirectController.t => unit,
  @as("type") type_: [#direct],
}

type queuingStrategySize<'t> = (~chunk: 't=?) => float

type queuingStrategy<'t> = {
  highWaterMark?: float,
  size?: queuingStrategySize<'t>,
}

type queuingStrategyInit = {
  /**
   * Creates a new ByteLengthQueuingStrategy with the provided high water mark.
   *
   * Note that the provided high water mark will not be validated ahead of time. Instead, if it is negative, NaN, or not a number, the resulting ByteLengthQueuingStrategy will cause the corresponding stream constructor to throw.
   */
  highWaterMark: float,
}

type streamPipeOptions = {
  preventAbort?: bool,
  preventCancel?: bool,
  /**
   * Pipes this readable stream to a given writable stream destination. The way in which the piping process behaves under various error conditions can be customized with a number of passed options. It returns a promise that fulfills when the piping process completes successfully, or rejects if any errors were encountered.
   *
   * Piping a stream will lock it for the duration of the pipe, preventing any other consumer from acquiring a reader.
   *
   * Errors and closures of the source and destination streams propagate as follows:
   *
   * An error in this source readable stream will abort destination, unless preventAbort is truthy. The returned promise will be rejected with the source's error, or with any error that occurs during aborting the destination.
   *
   * An error in destination will cancel this source readable stream, unless preventCancel is truthy. The returned promise will be rejected with the destination's error, or with any error that occurs during canceling the source.
   *
   * When this source readable stream closes, destination will be closed, unless preventClose is truthy. The returned promise will be fulfilled once this process completes, unless an error is encountered while closing the destination, in which case it will be rejected with that error.
   *
   * If destination starts out closed or closing, this source readable stream will be canceled, unless preventCancel is true. The returned promise will be rejected with an error indicating piping to a closed stream failed, or with any error that occurs during canceling the source.
   *
   * The signal option can be set to an AbortSignal to allow aborting an ongoing pipe operation via the corresponding AbortController. In this case, this source readable stream will be canceled, and destination aborted, unless the respective options preventCancel or preventAbort are set.
   */
  preventClose?: bool,
  signal?: AbortSignal.t,
}

module WritableStream = {
  type t<'t>

  @get external locked: t<_> => bool = "locked"
  @send external abort: (t<_>, ~reason: any=?) => promise<unit> = "abort"
  @send external close: t<_> => promise<unit> = "close"

  /** This Streams API interface is the object returned by WritableStream.getWriter() and once created locks the < writer to the WritableStream ensuring that no other streams can write to the underlying sink. */
  module WritableStreamDefaultWriter = {
    type writableStream<'w> = t<'w>
    type t<'w>

    @get external closed: t<_> => promise<unit> = "closed"
    @get external desiredSize: t<_> => Null.t<float> = "desiredSize"
    @get external ready: t<_> => promise<unit> = "ready"
    @send external abort: (t<_>, ~reason: any=?) => promise<unit> = "abort"
    @send external write: (t<'w>, 'w) => promise<unit> = "write"
    @send external close: t<_> => promise<unit> = "close"
    @send external releaseLock: t<_> => unit = "releaseLock"

    @new external make: writableStream<'w> => t<'w> = "WritableStreamDefaultWriter"
  }

  @send external getWriter: t<'t> => WritableStreamDefaultWriter.t<'t> = "getWriter"

  @new
  external make: (
    ~underlyingSource: underlyingSource<'r>=?,
    ~strategy: queuingStrategy<'r>=?,
  ) => t<'w> = "WritableStream"
}

module ReadableStreamGenericReader = {
  type t<'r>
  @get external closed: t<_> => promise<unit> = "closed"
  @send external cancel: (t<_>, ~reason: 'any=?) => promise<unit> = "cancel"
}

@tag("done")
type readableStreamDefaultReadResult<'r> = | @as(false) NotDone({value: 'r}) | Done({value: unit})

type readableStreamDefaultReadManyResult<'r> = {
  done: bool,
  /** Number of bytes */
  size: float,
  value: array<'r>,
}

type readableStream<'r>

module ReadableStreamDefaultReader = {
  include ReadableStreamGenericReader
  @send external read: t<'r> => promise<readableStreamDefaultReadResult<'r>> = "read"
  /** Only available in Bun. If there are multiple chunks in the queue, this will return all of them at the same time. */
  @send
  external readMany: t<'r> => promise<readableStreamDefaultReadManyResult<'r>> = "readMany"
  @send external releaseLock: t<_> => unit = "releaseLock"

  @new external make: readableStream<'r> => t<'r> = "ReadableStreamDefaultReader"
}

type readableWritablePair<'r, 'w>

/** This Streams API interface represents a readable stream of byte data. The Fetch API offers a concrete instance of a ReadableStream through the body property of a Response object. */
module ReadableStream = {
  type t<'r> = readableStream<'r>

  @get external locked: t<_> => bool = "locked"
  @send external cancel: (t<_>, ~reason: 'any=?) => promise<unit> = "cancel"
  @send external getReader: t<'r> => ReadableStreamDefaultReader.t<'r> = "getReader"
  @send
  external pipeThrough: (
    t<'t>,
    readableWritablePair<'t, 'r>,
    ~options: streamPipeOptions=?,
  ) => t<'t> = "pipeThrough"
  @send
  external pipeTo: (t<_>, WritableStream.t<'r>, ~options: streamPipeOptions=?) => promise<unit> =
    "pipeTo"
  @send external tee: t<'t> => (t<'t>, t<'t>) = "tee"

  type valuesOptions = {preventCancel: bool}
  @send external values: (t<'t>, ~options: valuesOptions=?) => AsyncIterator.t<'t> = "values"

  @new
  external make: (
    ~underlyingSource: underlyingSource<'r>=?,
    ~strategy: queuingStrategy<'r>=?,
  ) => t<'r> = "ReadableStream"

  @new
  external makeWithDirectUnderlyingSource: (
    ~underlyingSource: underlyingSource<'r>=?,
    ~strategy: queuingStrategy<'r>=?,
  ) => t<'r> = "ReadableStream"
}

module ReadableWritablePair = {
  type t<'r, 'w> = readableWritablePair<'r, 'w>

  @get external readable: t<'r, _> => ReadableStream.t<'r> = "readable"
  @get external writable: t<_, 'w> => WritableStream.t<'w> = "writable"
}

module TransformStream = {
  type t<'t, 'r> = {
    readable: ReadableStream.t<'t>,
    writable: WritableStream.t<'r>,
  }

  type chunk

  module Controller = {
    type t

    @send external enqueue: (t, chunk) => unit = "enqueue"
  }

  type config = {transform: (chunk, Controller.t) => unit}

  @new external make: config => t<'t, 'r> = "TransformStream"
}

module Blob = {
  type t = Js.Blob.t

  /**
   * Create a new view **without 🚫 copying** the underlying data.
   *
   * Similar to [`BufferSource.subarray`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BufferSource/subarray)
   */
  @send
  external slice: (t, ~begin: float=?, ~end: float=?, ~contentType: string=?) => t = "slice"

  /**
   * Read the data from the blob as a string. It will be decoded from UTF-8.
   */
  @send
  external text: t => promise<string> = "text"

  /**
   * Read the data from the blob as a ReadableStream.
   */
  @send
  external stream: (t, ~chunkSize: float=?) => ReadableStream.t<'t> = "stream"

  /**
   * Read the data from the blob as an ArrayBuffer.
   *
   * This copies the data into a new ArrayBuffer.
   */
  @send
  external arrayBuffer: t => promise<ArrayBuffer.t> = "arrayBuffer"

  /**
   * Read the data from the blob as a JSON object.
   *
   * This first decodes the data from UTF-8, then parses it as JSON.
   */
  @send
  external json: t => promise<JSON.t> = "json"

  /**
   * Read the data from the blob as a {@link FormData} object.
   *
   * This first decodes the data from UTF-8, then parses it as a
   * `multipart/form-data` body or a `application/x-www-form-urlencoded` body.
   *
   * The `type` property of the blob is used to determine the format of the
   * body.
   *
   * This is a non-standard addition to the `Blob` API, to make it conform more
   * closely to the `BodyMixin` API.
   */
  @send
  external formData: t => promise<FormData.t> = "formData"

  @get
  external type_: t => string = "type"

  @get
  external size: t => float = "size"

  @unboxed
  type blobPart = String(string) | Blob(t)
  type blobPropertyBag = {
    /** Set a default "type". Not yet implemented. */
    @as("type")
    type_?: string,
    /* Not implemented in Bun yet. */
    // endings?: "transparent" | "native";
  }

  @new external make: (~parts: array<blobPart>=?, ~options: blobPropertyBag=?) => t = "Blob"
}

module File = {
  type t = Js.File.t

  /**
   * Create a new view **without 🚫 copying** the underlying data.
   *
   * Similar to [`BufferSource.subarray`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BufferSource/subarray)
   */
  @send
  external slice: (t, ~begin: float=?, ~end: float=?, ~contentType: string=?) => t = "slice"

  /**
   * Read the data from the blob as a string. It will be decoded from UTF-8.
   */
  @send
  external text: t => promise<string> = "text"

  /**
   * Read the data from the blob as a ReadableStream.
   */
  @send
  external stream: (t, ~chunkSize: float=?) => ReadableStream.t<'t> = "stream"

  /**
   * Read the data from the blob as an ArrayBuffer.
   *
   * This copies the data into a new ArrayBuffer.
   */
  @send
  external arrayBuffer: t => promise<ArrayBuffer.t> = "arrayBuffer"

  /**
   * Read the data from the blob as a JSON object.
   *
   * This first decodes the data from UTF-8, then parses it as JSON.
   */
  @send
  external json: t => promise<JSON.t> = "json"

  /**
   * Read the data from the blob as a {@link FormData} object.
   *
   * This first decodes the data from UTF-8, then parses it as a
   * `multipart/form-data` body or a `application/x-www-form-urlencoded` body.
   *
   * The `type` property of the blob is used to determine the format of the
   * body.
   *
   * This is a non-standard addition to the `Blob` API, to make it conform more
   * closely to the `BodyMixin` API.
   */
  @send
  external formData: t => promise<FormData.t> = "formData"

  @get
  external getType: t => string = "type"

  @get
  external size: t => float = "size"

  @get external lastModified: t => float = "lastModified"
  @get external name: t => string = "name"

  type filePropertyBag = {
    ...Blob.blobPropertyBag,
    lastModified?: dateOrNumber,
  }

  @new
  external make: (~parts: array<Blob.blobPart>, ~name: string, ~options: filePropertyBag=?) => t =
    "File"

  external toBlob: t => Blob.t = "%identity"
}

module URLSearchParams = {
  type t

  @unboxed type init = Object(Dict.t<string>) | String(string) | Array(array<array<string>>)

  @new external make: unit => t = "URLSearchParams"
  @new external makeWithInit: init => t = "URLSearchParams"

  /** Appends a specified key/value pair as a new search parameter. */
  @send
  external append: (t, string, string) => unit = "append"

  /** Deletes the given search parameter, and its associated value, from the list of all search parameters. */
  @send
  external delete: (t, string) => unit = "delete"

  /** Returns the first value associated to the given search parameter. */
  @send
  @return(nullable)
  external get: (t, string) => option<string> = "get"

  /** Returns all the values association with a given search parameter. */
  @send
  external getAll: (t, string) => array<string> = "getAll"

  /** Returns a Boolean indicating if such a search parameter exists. */
  @send
  external has: (t, string) => bool = "has"

  /** Sets the value associated to a given search parameter to the given value. If there were several values, delete the others. */
  @send
  external set: (t, string, string) => unit = "set"

  /** Sorts all key/value pairs, if any, by their keys. */
  @send
  external sort: t => unit = "sort"

  /** Returns an iterator allowing to go through all entries of the key/value pairs. */
  @send
  external entries: t => Iterator.t<(string, string)> = "entries"

  /** Returns an iterator allowing to go through all keys of the key/value pairs of this search parameter. */
  @send
  external keys: t => Iterator.t<string> = "keys"

  /** Returns an iterator allowing to go through all values of the key/value pairs of this search parameter. */
  @send
  external values: t => Iterator.t<string> = "values"

  /** Executes a provided function once for each key/value pair. */
  @send
  external forEach: (t, (string, string, t) => unit) => unit = "forEach"

  /** Returns a string containing a query string suitable for use in a URL. Does not include the question mark. */
  @send
  external toString: t => string = "toString"
}

module Response = {
  type t

  type baseResponseInit = {
    /** @default 200 */
    status?: int,
    /** @default "OK" */
    statusText?: string,
  }

  type responseInit = {
    ...baseResponseInit,
    headers?: HeadersInit.t,
  }

  type responseInitWithHeaders = {
    ...baseResponseInit,
    headers?: Headers.t,
  }

  type responseType =
    | @as("basic") Basic
    | @as("cors") Cors
    | @as("default") Default
    | @as("error") Error
    | @as("opaque") Opaque
    | @as("opaqueredirect") OpaqueRedirect

  external defer: t = "undefined"

  @new external make: (string, ~options: responseInit=?) => t = "Response"
  @new external makeFromFile: bunFile => t = "Response"
  @new external makeWithHeaders: (string, ~options: responseInitWithHeaders=?) => t = "Response"
  @new external makeFromFormData: (FormData.t, ~options: responseInit=?) => t = "Response"
  @new
  external makeFromURLSearchParams: (URLSearchParams.t, ~options: responseInit=?) => t = "Response"

  @new
  external makeFromReadableStream: (ReadableStream.t<'t>, ~options: responseInit=?) => t =
    "Response"

  /** Create a new Response that redirects to url */
  external makeRedirect: (string, ~status: int=?) => t = "Response.redirect"

  /** HTTP Headers sent with the response. */
  @get
  external headers: t => Headers.t = "headers"

  /** HTTP response body as a ReadableStream */
  @get
  @return(nullable)
  external body: t => option<ReadableStream.t<'t>> = "body"

  /** Has the body of the response already been consumed? */
  @get
  external bodyUsed: t => bool = "bodyUsed"

  /** Read the data from the Response as a string. It will be decoded from UTF-8. */
  @send
  external text: t => promise<string> = "text"

  /** Read the data from the Response as a string. It will be decoded from UTF-8. */
  @send
  external arrayBuffer: t => promise<ArrayBuffer.t> = "arrayBuffer"

  /** Read the data from the Response as a JSON object. */
  @send
  external json: t => promise<JSON.t> = "json"

  /** Read the data from the Response as a Blob. */
  @send
  external blob: t => promise<Blob.t> = "blob"

  /** Read the data from the Response as a FormData object. */
  @send
  external formData: t => promise<FormData.t> = "formData"

  @get external ok: t => bool = "ok"
  @get external redirected: t => bool = "redirected"

  /** HTTP status code */
  @get
  external status: t => int = "status"
  @get external statusText: t => string = "statusText"
  @get external type_: t => responseType = "type"
  @get external url: t => string = "url"

  /** Copy the Response object into a new Response, including the body */
  @send
  external clone: t => t = "clone"
}

type requestCache =
  | @as("default") Default
  | @as("force-cache") ForceCache
  | @as("no-cache") NoCache
  | @as("no-store") NoStore
  | @as("only-if-cached") OnlyIfCached
  | @as("reload") Reload

type requestCredentials =
  | @as("include") Include
  | @as("omit") Omit
  | @as("same-origin") SameOrigin

type requestDestination =
  | @as("") Empty
  | @as("audio") Audio
  | @as("audioworklet") AudioWorklet
  | @as("document") Document
  | @as("embed") Embed
  | @as("font") Font
  | @as("frame") Frame
  | @as("iframe") IFrame
  | @as("image") Image
  | @as("manifest") Manifest
  | @as("object") Object_
  | @as("paintworklet") PaintWorklet
  | @as("report") Report
  | @as("script") Script
  | @as("sharedworker") SharedWorker
  | @as("style") Style
  | @as("track") Track
  | @as("video") Video
  | @as("worker") Worker
  | @as("xslt") Xslt

type requestMode =
  | @as("cors") Cors
  | @as("navigate") Navigate
  | @as("no-cors") NoCors
  | @as("same-origin") SameOriginMode

type requestRedirect =
  | @as("error") Error
  | @as("follow") Follow
  | @as("manual") Manual

type referrerPolicy =
  | @as("") Empty
  | @as("no-referrer") NoReferrer
  | @as("no-referrer-when-downgrade") NoReferrerWhenDowngrade
  | @as("origin") Origin
  | @as("origin-when-cross-origin") OriginWhenCrossOrigin
  | @as("same-origin") SameOriginPolicy
  | @as("strict-origin") StrictOrigin
  | @as("strict-origin-when-cross-origin") StrictOriginWhenCrossOrigin
  | @as("unsafe-url") UnsafeUrl

type ipFamily = IPv4 | IPv6

type encoding = | @as("utf-8") Utf8 | @as("windows-1252") Windows1252 | @as("utf-16") Utf16

type socketAddress = {
  /**
     * The IP address of the client.
     */
  address: string,
  /**
     * The port of the client.
     */
  port: int,
  /**
     * The IP family ("IPv4" or "IPv6").
     */
  family: ipFamily,
}

module XMLHttpRequestBodyInit = {
  type t

  external makeFromBlob: Blob.t => t = "%identity"
  // TODO: external makeFromBufferSource: Blob.t => t = "%identity"
  external makeFromString: string => t = "%identity"
  external makeFromURLSearchParams: URLSearchParams.t => t = "%identity"
}

module BodyInit = {
  type t

  external makeFromReadableStream: ReadableStream.t<_> => t = "%identity"
  external makeFromXMLHttpRequestBodyInit: XMLHttpRequestBodyInit.t => t = "%identity"
  external makeFromBlob: Blob.t => t = "%identity"
  external makeFromString: string => t = "%identity"
  external makeFromURLSearchParams: URLSearchParams.t => t = "%identity"
}

type requestInit = {
  /**
   * A BodyInit object or null to set request's body.
   */
  body?: Null.t<BodyInit.t>,
  /**
   * A string indicating how the request will interact with the browser's cache to set request's cache.
   *
   * Note: as of Bun v0.5.7, this is not implemented yet.
   */
  cache?: requestCache,
  /**
   * A string indicating whether credentials will be sent with the request always, never, or only when sent to a same-origin URL. Sets request's credentials.
   */
  credentials?: requestCredentials,
  /**
   * A Headers object, an object literal, or an array of two-item arrays to set request's headers.
   */
  headers?: HeadersInit.t,
  /**
   * A cryptographic hash of the resource to be fetched by request. Sets request's integrity.
   *
   * Note: as of Bun v0.5.7, this is not implemented yet.
   */
  integrity?: string,
  /**
   * A boolean to set request's keepalive.
   *
   * Available in Bun v0.2.0 and above.
   *
   * This is enabled by default
   */
  keepalive?: bool,
  /**
   * A string to set request's method.
   */
  method?: string,
  /**
   * A string to indicate whether the request will use CORS, or will be restricted to same-origin URLs. Sets request's mode.
   */
  mode?: requestMode,
  /**
   * A string indicating whether request follows redirects, results in an error upon encountering a redirect, or returns the redirect (in an opaque fashion). Sets request's redirect.
   */
  redirect?: requestRedirect,
  /**
   * A string whose value is a same-origin URL, "about:client", or the empty string, to set request's referrer.
   */
  referrer?: string,
  /**
   * A referrer policy to set request's referrerPolicy.
   */
  referrerPolicy?: referrerPolicy,
  /**
   * An AbortSignal to set request's signal.
   */
  signal?: Null.t<AbortSignal.t>,
  /**
   * Enable or disable HTTP request timeout
   */
  timeout?: bool,
}

type checkServerIdentity

type tlsConfig = {rejectUnauthorized?: bool} // Defaults to true

type fetchRequestInitTls = {
  ...tlsConfig,
  checkServerIdentity?: checkServerIdentity, // TODO: change `any` to `checkServerIdentity`
}

type fetchRequestInit = {
  ...requestInit,
  /**
   * Log the raw HTTP request & response to stdout. This API may be
   * removed in a future version of Bun without notice.
   * This is a custom property that is not part of the Fetch API specification.
   * It exists mostly as a debugging tool
   */
  verbose?: bool,
  /**
   * Override http_proxy or HTTPS_PROXY
   * This is a custom property that is not part of the Fetch API specification.
   */
  proxy?: string,
  /**
   * Override the default TLS options
   */
  tls?: fetchRequestInitTls,
}

/** All possible HTTP methods. */
type method = GET | HEAD | POST | PUT | DELETE | CONNECT | OPTIONS | TRACE | PATCH

// https://github.com/oven-sh/bun/blob/main/packages/bun-types/globals.d.ts#L1331
module Request = {
  type t

  /**
   * Read or write the HTTP headers for this request.
   *
   * @example
   * ```rescript
   * let request = Request.make("https://remix.run/");
   * request->Request.headers->Headers.set("Content-Type", "application/json");
   * request->Request.headers->Headers.set("Accept", "application/json");
   * let res = await fetch(request)
   * ```
   */
  @get
  external headers: t => Headers.t = "headers"

  /**
   * The URL (as a string) corresponding to the HTTP request
   * @example
   * ```rescript
   * let request = Request.make("https://remix.run/")
   * request->Request.url; // "https://remix.run/"
   * ```
   */
  @get
  external url: t => string = "url"

  /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a string. It will be decoded from UTF-8.
   *
   * When the body is valid latin1, this operation is zero copy.
   */
  @send
  external text: t => promise<string> = "text"

  /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a {@link ReadableStream}.
   *
   * Streaming **outgoing** HTTP request bodies via `fetch()` is not yet supported in
   * Bun.
   *
   * Reading **incoming** HTTP request bodies via `ReadableStream` in `Bun.serve()` is supported
   * as of Bun v0.2.0.
   *
   *
   */
  @send
  external body: t => Null.t<ReadableStream.t<'t>> = "body"

  /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as an ArrayBuffer.
   *
   */
  @send
  external arrayBuffer: t => promise<ArrayBuffer.t> = "arrayBuffer"

  /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a JSON object.
   *
   * This first decodes the data from UTF-8, then parses it as JSON.
   *
   */
  @send
  external json: t => promise<JSON.t> = "json"

  /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a `Blob`.
   *
   * This allows you to reuse the underlying data.
   *
   */
  @send
  external blob: t => promise<Blob.t> = "blob"

  /**
   * Returns the cache mode associated with request, which is a string indicating how the request will interact with the browser's cache when fetching.
   */
  @get
  external cache: t => requestCache = "cache"
  /**
   * Returns the credentials mode associated with request, which is a string indicating whether credentials will be sent with the request always, never, or only when sent to a same-origin URL.
   */
  @get
  external credentials: t => requestCredentials = "credentials"
  /**
   * Returns the kind of resource requested by request, e.g., "document" or "script".
   *
   * In Bun, this always returns "navigate".
   */
  @get
  external destination: t => requestDestination = "destination"
  /**
   * Returns request's subresource integrity metadata, which is a cryptographic hash of the resource being fetched. Its value consists of multiple hashes separated by whitespace. [SRI]
   *
   * This does nothing in Bun right now.
   */
  @get
  external integrity: t => string = "integrity"
  /**
   * Returns a boolean indicating whether or not request can outlive the global in which it was created.
   *
   * In Bun, this always returns false.
   */
  @get
  external keepalive: t => bool = "keepalive"
  /**
   * Returns request's HTTP method, which is "GET" by default.
   */
  @get
  external method: t => method = "method"
  /**
   * Returns the mode associated with request, which is a string indicating whether the request will use CORS, or will be restricted to same-origin URLs.
   */
  @get
  external mode: t => requestMode = "mode"
  /**
   * Returns the redirect mode associated with request, which is a string indicating how redirects for the request will be handled during fetching. A request will follow redirects by default.
   */
  @get
  external redirect: t => requestRedirect = "redirect"
  /**
   * Returns the referrer of request. Its value can be a same-origin URL
   * if explicitly set in init, the empty string to indicate no referrer,
   * and "about:client" when defaulting to the global's default. This is
   * used during fetching to determine the value of the `Referer` header
   * of the request being made.
   */
  @get
  external referrer: t => string = "referrer"
  /**
   * Returns the referrer policy associated with request. This is used during fetching to compute the value of the request's referrer.
   */
  @get
  external referrerPolicy: t => referrerPolicy = "referrerPolicy"
  /**
   * Returns the signal associated with request, which is an AbortSignal object indicating whether or not request has been aborted, and its abort event handler.
   */
  @get
  external signal: t => AbortSignal.t = "signal"

  /** Copy the Request object into a new Request, including the body */
  @send
  external clone: t => t = "clone"

  /**
   * Read the body from the Request as a {@link FormData} object.
   *
   * This first decodes the data from UTF-8, then parses it as a
   * `multipart/form-data` body or a `application/x-www-form-urlencoded` body.
   *
   * @returns Promise<FormData> - The body of the request as a {@link FormData}.
   */
  @send
  external formData: t => promise<FormData.t> = "formData"

  /**
   * Has the body of the request been read?
   *
   * [Request.bodyUsed](https://developer.mozilla.org/en-US/docs/Web/API/Request/bodyUsed)
   */
  @get
  external bodyUsed: t => bool = "bodyUsed"
}

module Crypto = {
  type t

  // TODO: readonly subtle: SubtleCrypto;

  @send external getRandomValues: (t, BufferSource.t) => BufferSource.t = "getRandomValues"
  /**
   * Generate a cryptographically secure random UUID.
   *
   * @example
   *
   * ```js
   * crypto.randomUUID()
   * '5e6adf82-f516-4468-b1e1-33d6f664d7dc'
   * ```
   */
  @send
  external randomUUID: t => string = "randomUUID"

  @new external make: unit => t = "Crypto"
}

external crypto: Crypto.t = "crypto"

/**
 * [`atob`](https://developer.mozilla.org/en-US/docs/Web/API/atob) decodes base64 into ascii text.
 *
 * @param asciiText The base64 string to decode.
 */
external atob: string => string = "atob"

/**
 * [`btoa`](https://developer.mozilla.org/en-US/docs/Web/API/btoa) encodes ascii text into base64.
 *
 * @param stringToEncode The ascii text to encode.
 */
external btoa: string => string = "btoa"

type encodeIntoResult = {
  /**
   * The read Unicode code units of input.
   */
  read: float,
  /**
   * The written UTF-8 bytes of output.
   */
  written: float,
}

/**
 * An implementation of the [WHATWG Encoding Standard](https://encoding.spec.whatwg.org/) `TextEncoder` API. All
 * instances of `TextEncoder` only support UTF-8 encoding.
 *
 * ```js
 * const encoder = new TextEncoder();
 * const uint8array = encoder.encode('this is some data');
 * ```
 *
 */
module TextEncoder = {
  type t
  type utf8Encoding = | @as("utf-8") Utf8

  @new external make: (~encoding: utf8Encoding=?) => t = "TextEncoder"

  /**
   * The encoding supported by the `TextEncoder` instance. Always set to `'utf-8'`.
   */
  @get
  external encoding: t => utf8Encoding = "encoding"

  /**
   * UTF-8 encodes the `input` string and returns a `Uint8Array` containing the
   * encoded bytes.
   * @param [input='an empty string'] The text to encode.
   */
  @send
  external encode: (t, string) => Uint8Array.t = "encode"

  /**
   * UTF-8 encodes the `src` string to the `dest` Uint8Array and returns an object
   * containing the read Unicode code units and written UTF-8 bytes.
   *
   * ```js
   * const encoder = new TextEncoder();
   * const src = 'this is some data';
   * const dest = new Uint8Array(10);
   * const { read, written } = encoder.encodeInto(src, dest);
   * ```
   * @param src The text to encode.
   * @param dest The array to hold the encode result.
   */
  @send
  external encodeInto: (~src: string=?, ~dest: BufferSource.t=?) => encodeIntoResult = "encodeInto"
}

/**
 * An implementation of the [WHATWG Encoding Standard](https://encoding.spec.whatwg.org/) `TextDecoder` API.
 *
 * ```js
 * const decoder = new TextDecoder();
 * const u8arr = new Uint8Array([72, 101, 108, 108, 111]);
 * console.log(decoder.decode(u8arr)); // Hello
 * ```
 */
module TextDecoder = {
  type t
  /**
   * The encoding supported by the `TextDecoder` instance.
   */
  @get
  external encoding: t => string = "encoding"
  /**
   * The value will be `true` if decoding errors result in a `TypeError` being
   * thrown.
   */
  @get
  external fatal: t => bool = "fatal"
  /**
   * The value will be `true` if the decoding result will include the byte order
   * mark.
   */
  @get
  external ignoreBOM: t => bool = "ignoreBOM"

  type options = {fatal?: bool, ignoreBOM?: bool}

  @new external make: (~encoding: encoding=?, ~options: options=?) => t = "TextDecoder"

  module Input = {
    type t

    external fromBufferSource: BufferSource.t => t = "%identity"
    external fromArrayBuffer: ArrayBuffer.t => t = "%identity"
  }

  /**
   * Decodes the `input` and returns a string. If `options.stream` is `true`, any
   * incomplete byte sequences occurring at the end of the `input` are buffered
   * internally and emitted after the next call to `textDecoder.decode()`.
   *
   * If `textDecoder.fatal` is `true`, decoding errors that occur will result in a`TypeError` being thrown.
   * @param input An `ArrayBuffer`, `DataView` or `BufferSource` instance containing the encoded data.
   */
  @send
  external decode: (~input: Input.t=?) => string = "decode"
}

// TODO: ShadowRealm

type performance = {
  /**
   * Milliseconds since Bun.js started
   *
   * Uses a high-precision system timer to measure the time elapsed since the
   * Bun.js runtime was initialized. The value is represented as a double
   * precision floating point number. The value is monotonically increasing
   * during the lifetime of the runtime.
   *
   */
  now: unit => float,
  /**
   * The timeOrigin read-only property of the Performance interface returns the
   * high resolution timestamp that is used as the baseline for
   * performance-related timestamps.
   *
   * @link https://developer.mozilla.org/en-US/docs/Web/API/Performance/timeOrigin
   */
  timeOrigin: float,
}

external performance: performance = "performance"

/*
 * Cancel an immediate function call by its immediate ID.
 * @param id immediate id
 */
// TODO declare function clearImmediate(id?: number | Timer): void;

/**
 * Send a HTTP(s) request
 *
 * @param request Request object
 * @param init A structured value that contains settings for the fetch() request.
 *
 * @returns A promise that resolves to {@link Response} object.
 *
 *
 */
external fetchByRequest: (Request.t, ~init: requestInit=?) => promise<Response.t> = "fetch"
/**
 * Send a HTTP(s) request
 *
 * @param url URL string
 * @param init A structured value that contains settings for the fetch() request.
 *
 * @returns A promise that resolves to {@link Response} object.
 *
 *
 */
external fetch: (string, ~init: fetchRequestInit=?) => promise<Response.t> = "fetch"

external queueMicrotask: (unit => unit) => unit = "queueMicrotask"
/**
 * Log an error using the default exception handler
 * @param error Error or string
 */
external reportError: 'any => unit = "reportError"

// TODO: Timers, setImmediate, etc
// TODO: addEventListener

type eventInit = {
  bubbles?: bool,
  cancelable?: bool,
  composed?: bool,
}

type errorEventInit = {
  ...eventInit,
  colno?: float,
  error?: unknown,
  filename?: string,
  lineno?: float,
  message?: string,
}

type closeEventInit = {
  ...eventInit,
  code?: float,
  reason?: string,
  wasClean?: bool,
}

type messageEventInit<'t> = {
  ...eventInit,
  data?: 't,
  lastEventId?: string,
  origin?: string,
}

type eventListenerOptions = {capture?: bool}

type uIEventInit = {
  ...eventInit,
  detail?: float,
}

type eventModifierInit = {
  ...uIEventInit,
  altKey?: bool,
  ctrlKey?: bool,
  metaKey?: bool,
  modifierAltGraph?: bool,
  modifierCapsLock?: bool,
  modifierFn?: bool,
  modifierFnLock?: bool,
  modifierHyper?: bool,
  modifierNumLock?: bool,
  modifierScrollLock?: bool,
  modifierSuper?: bool,
  modifierSymbol?: bool,
  modifierSymbolLock?: bool,
  shiftKey?: bool,
}

type eventSourceInit = {withCredentials?: bool}

type event

type eventListener = event => unit
type eventListenerObject = {handleEvent: eventListener}

type addEventListenerOptions = {
  ...eventListenerOptions,
  once?: bool,
  passive?: bool,
  signal?: AbortSignal.t,
}

/** EventTarget is a DOM interface implemented by objects that can receive events and may have listeners for them. */
module EventTarget = {
  type t

  @unboxed
  type eventListenerOrEventListenerObject =
    EventListener(eventListener) | EventListenerObject(eventListenerObject)

  @unboxed
  type addEventListenerOptionsOpt = AddEventListenerOptions(addEventListenerOptions) | Bool(bool)

  @unboxed
  type removeEventListenerOptionsOpt = EventListenerOptions(eventListenerOptions) | Bool(bool)
  /**
   * Appends an event listener for events whose type attribute value is
   * type. The callback argument sets the callback that will be invoked
   * when the event is dispatched.
   *
   * The options argument sets listener-specific options. For
   * compatibility this can be a boolean, in which case the method behaves
   * exactly as if the value was specified as options's capture.
   *
   * When set to true, options's capture prevents callback from being
   * invoked when the event's eventPhase attribute value is
   * BUBBLING_PHASE. When false (or not present), callback will not be
   * invoked when event's eventPhase attribute value is CAPTURING_PHASE.
   * Either way,callback will be invoked if event's eventPhase attribute
   * value is AT_TARGET.
   *
   * When set to true, options's passive indicates that the callback will
   * not cancel the event by invoking preventDefault(). This is used to
   * enable performance optimizations described in § 2.8 Observing event
   * listeners.
   *
   * When set to true, options's once indicates that the callback will
   * only be invoked once after which the event listener will be removed.
   *
   * If an AbortSignal is passed for options's signal, then the event
   * listener will be removed when signal is aborted.
   *
   * The event listener is appended to target's event listener list and is
   * not appended if it has the same type, callback, and capture.
   */
  @send
  external addEventListener: (
    t,
    string,
    ~callback: Null.t<eventListenerOrEventListenerObject>,
    ~options: addEventListenerOptionsOpt=?,
  ) => unit = "addEventListener"
  /** Dispatches a synthetic event event to target and returns true if either event's cancelable attribute value is false or its preventDefault() method was not invoked, and false otherwise. */
  @send
  external dispatchEvent: (t, event) => bool = "dispatchEvent"
  /** Removes the event listener in target's event listener list with the same type, callback, and options. */
  @send
  external removeEventListener: (
    t,
    string,
    ~callback: Null.t<eventListenerOrEventListenerObject>,
    ~options: addEventListenerOptionsOpt=?,
  ) => unit = "removeEventListener"

  @new external make: unit => t = "EventTarget"
}

// TODO: Type variables for all Event types
/** An event which takes place in the DOM. */
module Event = {
  type t = event

  /**
   * Returns true or false depending on how event was initialized. True
   * if event goes through its target's ancestors in reverse tree order,
   * and false otherwise.
   */
  @get
  external bubbles: t => bool = "bubbles"
  @get external cancelBubble: t => bool = "cancelBubble"
  /**
   * Returns true or false depending on how event was initialized. Its
   * return value does not always carry meaning, but true can indicate
   * that part of the operation during which event was dispatched, can be
   * canceled by invoking the preventDefault() method.
   */
  @get
  external cancelable: t => bool = "cancelable"
  /**
   * Returns true or false depending on how event was initialized. True
   * if event invokes listeners past a ShadowRoot node that is the root of
   * its target, and false otherwise.
   */
  @get
  external composed: t => bool = "composed"
  /**
   * Returns the object whose event listener's callback is currently
   * being invoked.
   */
  @get
  external currentTarget: t => Null.t<'any> = "currentTarget"
  /**
   * Returns true if preventDefault() was invoked successfully to
   * indicate cancelation, and false otherwise.
   */
  @get
  external defaultPrevented: t => bool = "defaultPrevented"
  /**
   * Returns the event's phase, which is one of NONE, CAPTURING_PHASE,
   * AT_TARGET, and BUBBLING_PHASE.
   */
  @get
  external eventPhase: t => float = "eventPhase"
  /**
   * Returns true if event was dispatched by the user agent, and false
   * otherwise.
   */
  @get
  external isTrusted: t => bool = "isTrusted"
  /**
   * Returns the object to which event is dispatched (its target).
   */
  @get
  external target: t => Null.t<EventTarget.t> = "target"
  /**
   * Returns the event's timestamp as the number of milliseconds measured
   * relative to the time origin.
   */
  @get
  external timeStamp: t => dOMHighResTimeStamp = "timestamp"
  /**
   * Returns the type of event, e.g. "click", "hashchange", or "submit".
   */
  @get
  external type_: t => string = "type"
  /**
   * Returns the invocation target objects of event's path (objects on
   * which listeners will be invoked), except for any nodes in shadow
   * trees of which the shadow root's mode is "closed" that are not
   * reachable from event's currentTarget.
   */
  @send
  external composedPath: t => array<EventTarget.t> = "composedPath"

  /**
   * If invoked when the cancelable attribute value is true, and while
   * executing a listener for the event with passive set to false, signals
   * to the operation that caused event to be dispatched that it needs to
   * be canceled.
   */
  @send
  external preventDefault: t => unit = "preventDefault"
  /**
   * Invoking this method prevents event from reaching any registered
   * event listeners after the current one finishes running and, when
   * dispatched in a tree, also prevents event from reaching any other
   * objects.
   */
  @send
  external stopImmediatePropagation: t => unit = "stopImmediatePropagation"
  /**
   * When dispatched in a tree, invoking this method prevents event from
   * reaching any objects other than the current object.
   */
  @send
  external stopPropagation: t => unit = "stopPropagation"
  @get external at_target: t => float = "AT_TARGET"
  @get external bubbling_phase: t => float = "BUBBLING_PHASE"
  @get external capturing_phase: t => float = "CAPTURING_PHASE"
  @get external none: t => float = "NONE"

  @new external make: (~type_: string, ~eventInitDict: eventInit=?) => t = "Event"
}

/**
 * Events providing information related to errors in scripts or in files.
 */
module ErrorEvent = {
  include Event
  @get external colno: t => float = "colno"
  @get external error: t => 'any = "error"
  @get external filename: t => string = "filename"
  @get external lineno: t => float = "lineno"
  @get external message: t => string = "message"
}

/** A CloseEvent is sent to clients using WebSockets when the connection is closed. This is delivered to the listener indicated by the WebSocket object's onclose attribute. */
module CloseEvent = {
  include Event
  /** Returns the WebSocket connection close code provided by the server. */
  @get
  external code: t => float = "code"
  /** Returns the WebSocket connection close reason provided by the server. */
  @get
  external reason: t => string = "reason"
  /** Returns true if the connection closed cleanly; false otherwise. */
  @get
  external wasClean: t => bool = "wasClean"

  @new external make: (~type_: string, ~eventInitDict: closeEventInit=?) => t = "CloseEvent"
}

/** A message received by a target object. */
module MessageEvent = {
  include Event

  /** Returns the data of the message. */
  @get
  external data: t => 'data = "data"
  /** Returns the last event ID string, for server-sent events. */
  @get
  external lastEventId: t => string = "lastEventId"
  /** Returns the origin of the message, for server-sent events and cross-document messaging. */
  @get
  external origin: t => string = "origin"
  /** Returns the MessagePort array sent with the message, for cross-document messaging and channel messaging. */
  @get
  external ports: t => array<messagePort> = "ports"
  @get external source: t => messageEventSource = "source"

  @new
  external make: (~type_: string, ~eventInitDict: messageEventInit<_>=?) => t = "MessageEvent"
}

type customEventInit<'t> = {
  ...eventInit,
  detail?: 't,
}

module CustomEvent = {
  include Event
  /** Returns any custom data event was created with. Typically used for synthetic events. */
  @get
  external detail: t => 't = "detail"

  @new external make: (~type_: string, ~eventInitDict: customEventInit<_>=?) => t = "CustomEvent"
}

/**
 * A map of WebSocket event names to event types.
 */
type webSocketEventMap = {
  @as("open") open_: Event.t,
  message: MessageEvent.t,
  close: CloseEvent.t,
  ping: MessageEvent.t,
  pong: MessageEvent.t,
  error: Event.t,
}

/**
 * A client that makes an outgoing WebSocket connection.
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
 * @example
 * const ws = new WebSocket("wss://ws.postman-echo.com/raw");
 *
 * ws.addEventListener("open", () => {
 *   console.log("Connected");
 * });
 * ws.addEventListener("message", ({ data }) => {
 *   console.log("Received:", data); // string or Buffer
 * });
 * ws.addEventListener("close", ({ code, reason }) => {
 *   console.log("Disconnected:", code, reason);
 * });
 */
module WebSocket = {
  /**
 * A state that represents if a WebSocket is connected.
 *
 * - `WebSocket.CONNECTING` is `0`, the connection is pending.
 * - `WebSocket.OPEN` is `1`, the connection is established and `send()` is possible.
 * - `WebSocket.CLOSING` is `2`, the connection is closing.
 * - `WebSocket.CLOSED` is `3`, the connection is closed or couldn't be opened.
 *
 * @link https://developer.mozilla.org/en-US/docs/Web/API/WebSocket/readyState
 */
  type webSocketReadyState = | @as(0) CONNECTING | @as(1) OPEN | @as(2) CLOSING | @as(3) CLOSED

  type t<'t>

  type config<'t> = {
    message?: (t<'t>, string) => unit,
    @as("open") open_?: t<'t> => unit,
    close?: (t<'t>, int, string) => unit,
    drain?: t<'t> => unit,
  }

  /**
   * Sends a message.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   * @example
   * let ws: WebSocket;
   * ws.send("Hello!");
   * ws.send(new TextEncoder().encode("Hello?"));
   */
  @send
  external send: (t<_>, string) => unit = "send"

  /**
   * Sends a message.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   * @example
   * let ws: WebSocket;
   * ws.send("Hello!");
   * ws.send(new TextEncoder().encode("Hello?"));
   */
  @send
  external sendBufferSource: (t<_>, BufferSource.t) => unit = "send"

  /**
   * A status that represents the outcome of a sent message.
   *
   * - if **Dropped**, the message was **dropped**.
   * - if **-1**, there is **backpressure** of messages.
   * - if **>0**, it represents the **number of bytes sent**.
   *
   * @example
   * ```js
   * const status = ws.send("Hello!");
   * if (status === 0) {
   *   console.log("Message was dropped");
   * } else if (status === -1) {
   *   console.log("Backpressure was applied");
   * } else {
   *   console.log(`Success! Sent ${status} bytes`);
   * }
   * ```
   */
  @unboxed
  type serverWebSocketSendStatus =
    | @as(0.) Dropped
    | @as(-1.) Backpressure
    | SentBytes(float)

  @send
  external publish: (t<_>, ~topic: string, ~data: string, ~compress: bool=?) => unit = "publish"

  @send
  external publishCheckStatus: (
    t<_>,
    ~topic: string,
    ~data: string,
    ~compress: bool=?,
  ) => serverWebSocketSendStatus = "publish"

  @send
  external subscribe: (t<_>, ~topic: string) => unit = "subscribe"

  @send
  external unsubscribe: (t<_>, ~topic: string) => unit = "unsubscribe"

  /**
   * Closes the connection.
   *
   * Here is a list of close codes:
   * - `1000` means "normal closure" **(default)**
   * - `1001` means the client is "going away"
   * - `1009` means a message was too big and was rejected
   * - `1011` means the server encountered an error
   * - `1012` means the server is restarting
   * - `1013` means the server is too busy or the client is rate-limited
   * - `4000` through `4999` are reserved for applications (you can use it!)
   *
   * To abruptly close the connection without a code, use `terminate()` instead.
   *
   * @param code the close code
   * @param reason the close reason
   * @example
   * let ws: WebSocket;
   * ws.close(1013, "Exceeded the rate limit of 100 messages per minute.");
   */
  @send
  external close: (t<_>, ~code: float=?, ~reason: string=?) => unit = "close"

  /**
   * Closes the connection, abruptly.
   *
   * To gracefuly close the connection, use `close()` instead.
   */
  @send
  external terminate: t<_> => unit = "terminate"

  /**
   * Sends a ping.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   */
  @send
  external ping: (t<_>, string) => unit = "ping"

  /**
   * Sends a ping.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   */
  @send
  external pingWithBufferSource: (t<_>, BufferSource.t) => unit = "ping"

  /**
   * Sends a pong.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   */
  @send
  external pong: (t<_>, string) => unit = "pong"

  /**
   * Sends a pong.
   *
   * @param data the string, ArrayBuffer, or ArrayBufferView to send
   */
  @send
  external pongWithBufferSource: (t<_>, BufferSource.t) => unit = "pong"

  /**
   * Sets how binary data is returned in events.
   *
   * - if `nodebuffer`, binary data is returned as `Buffer` objects. **(default)**
   * - if `arraybuffer`, binary data is returned as `ArrayBuffer` objects.
   * - if `blob`, binary data is returned as `Blob` objects. **(not supported)**
   *
   * In browsers, the default is `blob`, however in Bun, the default is `nodebuffer`.
   *
   * @example
   * let ws: WebSocket;
   * ws.binaryType = "arraybuffer";
   * ws.addEventListener("message", ({ data }) => {
   *   console.log(data instanceof ArrayBuffer); // true
   * });
   */
  @get
  external binaryType: t<_> => binaryType = "binaryType"

  /**
   * The ready state of the connection.
   *
   * - `WebSocket.CONNECTING` is `0`, the connection is pending.
   * - `WebSocket.OPEN` is `1`, the connection is established and `send()` is possible.
   * - `WebSocket.CLOSING` is `2`, the connection is closing.
   * - `WebSocket.CLOSED` is `3`, the connection is closed or couldn't be opened.
   */
  @get
  external readyState: t<_> => webSocketReadyState = "readyState"

  /**
   * The resolved URL that established the connection.
   */
  @get
  external url: t<_> => string = "url"

  /**
   * The number of bytes that are queued, but not yet sent.
   *
   * When the connection is closed, the value is not reset to zero.
   */
  @get
  external bufferedAmount: t<_> => float = "bufferedAmount"

  /**
   * The protocol selected by the server, if any, otherwise empty.
   */
  @get
  external protocol: t<_> => string = "protocol"

  /**
   * The extensions selected by the server, if any, otherwise empty.
   */
  @get
  external extensions: t<_> => string = "extensions"

  /**
   * Sets the event handler for `open` events.
   *
   * If you need multiple event handlers, use `addEventListener("open")` instead.
   */
  @set
  external onopen: (t<_>, Null.t<(t<_>, Event.t) => unknown>) => unit = "onopen"

  /**
   * Sets the event handler for `close` events.
   *
   * If you need multiple event handlers, use `addEventListener("close")` instead.
   */
  @set
  external onclose: (t<_>, Null.t<(t<_>, CloseEvent.t) => unknown>) => unit = "onclose"

  /**
   * Sets the event handler for `message` events.
   *
   * If you need multiple event handlers, use `addEventListener("message")` instead.
   */
  @set
  external onmessage: (t<_>, Null.t<(t<_>, MessageEvent.t) => unknown>) => unit = "onmessage"

  /**
   * Sets the event handler for `error` events.
   *
   * If you need multiple event handlers, use `addEventListener("error")` instead.
   */
  @set
  external onerror: (t<_>, Null.t<(t<_>, Event.t) => unknown>) => unit = "onerror"

  /* TODO: addEventListener<T extends keyof WebSocketEventMap>(
    type: T,
    listener: (this: WebSocket, event: WebSocketEventMap[T]) => unknown,
    options?: boolean | AddEventListenerOptions,
  ): void;

  addEventListener(
    type: string,
    listener: (this: WebSocket, event: Event) => unknown,
    options?: boolean | AddEventListenerOptions,
  ): void;

  removeEventListener<T extends keyof WebSocketEventMap>(
    type: T,
    listener: (this: WebSocket, event: WebSocketEventMap[T]) => unknown,
    options?: boolean | EventListenerOptions,
  ): void;

  removeEventListener(
    type: string,
    listener: (this: WebSocket, event: Event) => unknown,
    options?: boolean | EventListenerOptions,
  ): void;*/

  @new external make: (string, ~protocols: array<string>=?) => t<'t> = "WebSocket"

  type options = {
    /**
       * Sets the headers when establishing a connection.
       */
    headers?: HeadersInit.t,
    /**
       * Sets the sub-protocol the client is willing to accept.
       */
    protocol?: string,
    /**
       * Sets the sub-protocols the client is willing to accept.
       */
    protocols?: array<string>,
    /**
       * Override the default TLS options
       */
    tls?: tlsConfig,
  }

  @new external makeWithOptions: (string, ~options: options=?) => t<'t> = "WebSocket"
}

/** The URL module represents an object providing static methods used for creating object URLs. */
module URL = {
  type t

  @new external make: string => t = "URL"

  @get external hash: t => string = "hash"
  @get external host: t => string = "host"
  @get external hostname: t => string = "hostname"
  @get external href: t => string = "href"

  /** Returns a USVString containing the whole URL. It is a synonym for URL.href. */
  @send
  external toString: t => string = "toString"

  @get external origin: t => string = "origin"
  @get external password: t => string = "password"
  @get external pathname: t => string = "pathname"
  @get external port: t => string = "port"
  @get external protocol: t => string = "protocol"
  @get external search: t => string = "search"

  @get external searchParams: t => URLSearchParams.t = "searchParams"

  @get external username: t => string = "username"

  /** Returns a USVString containing a serialized URL. It is mainly used by JavaScript engines for some internal purposes. */
  @send
  external toJSON: t => string = "toJSON"

  /**
   * Check if `url` is a valid URL string
   *
   * @param url URL string to parse
   * @param base URL to resolve against
   */
  external canParse: (string, ~base: string=?) => bool = "URL.canParse"
}

module FetchEvent = {
  include Event
  @get external request: t => Request.t = "request"
  @get external url: t => string = "url"

  @send external waitUntil: (t, promise<'any>) => unit = "waitUntil"
  @send external respondWith: (t, Response.t) => unit = "respondWith"
  @send external respondWithPromise: (t, promise<Response.t>) => unit = "respondWith"
}

type eventMap = {
  fetch: FetchEvent.t,
  message: MessageEvent.t,
  messageerror: MessageEvent.t,
  // exit: Event;
}

// TODO: Loader
