// TODO: Figure out difference between crypto and Bun crypto

module BunCrypto = Crypto
open Globals
open Types

module StringOrBuffer = {
  type t
  external fromString: string => t = "%identity"
  external fromTypedArray: TypedArray.t<_> => t = "%identity"
  external fromArrayBuffer: ArrayBuffer.t => t = "%identity"
}

module Env = {
  type t = {
    @as("NODE_ENV") node_env?: string,
    /**
     * The timezone used by Intl, Date, etc.
     *
     * To change the timezone, set `Bun.env.TZ` or `process.env.TZ` to the time zone you want to use.
     *
     * You can view the current timezone with `Intl.DateTimeFormat().resolvedOptions().timeZone`
     *
     * @example
     * ```js
     * Bun.env.TZ = "America/Los_Angeles";
     * console.log(Intl.DateTimeFormat().resolvedOptions().timeZone); // "America/Los_Angeles"
     * ```
     */
    @as("TZ")
    tz?: string,
  }

  @get_index external get: (t, string) => option<string> = ""
}

external env: Env.t = "Bun.env"

/**
 * The raw arguments passed to the process, including flags passed to Bun. If you want to easily read flags passed to your script, consider using `process.argv` instead.
 */
external argv: array<string> = "Bun.argv"
external origin: string = "Bun.origin"

/**
  * Options for the `which` function.
  */
type whichOptions = {
  @as("PATH") path?: string,
  cwd?: string,
}

/**
  * Find the path to an executable, similar to typing which in your terminal. Reads the `PATH` environment variable unless overridden with `options.PATH`.
  *
  * @param command The name of the executable or script
  * @param options Overrides the PATH environment variable and limits the search to a particular directory
  *
  */
@return(nullable)
external which: (string, ~options: whichOptions=?) => option<string> = "Bun.which"

type toml = {parse: string => JSON.t}
external toml: toml = "Bun.TOML"

module Server = {
  type t

  /**
     * Stop listening to prevent new connections from being accepted.
     *
     * By default, it does not cancel in-flight requests or websockets. That means it may take some time before all network activity stops.
     *
     * @param closeActiveConnections Immediately terminate in-flight requests, websockets, and stop accepting new connections.
     * @default false
     */
  @send
  external stop: (t, ~closeActiveConnections: bool=?) => unit = "stop"

  /**
     * Update the `fetch` and `error` handlers without restarting the server.
     *
     * This is useful if you want to change the behavior of your server without
     * restarting it or for hot reloading.
     *
     * @example
     *
     * ```js
     * // create the server
     * const server = Bun.serve({
     *  fetch(request) {
     *    return new Response("Hello World v1")
     *  }
     * });
     *
     * // Update the server to return a different response
     * server.reload({
     *   fetch(request) {
     *     return new Response("Hello World v2")
     *   }
     * });
     * ```
     *
     * Passing other options such as `port` or `hostname` won't do anything.
     */
  type reloadServeOptions = {
    development?: bool,
    port?: int,
    fetch: (Request.t, t) => promise<Response.t>,
  }

  type reloadServeWithWebSocketOptions<'websocketDataType> = {
    ...reloadServeOptions,
    websocket?: WebSocket.config<'websocketDataType>,
  }

  @send
  external reload: (t, reloadServeOptions) => unit = "reload"

  @send
  external reloadWithWebSocket: (t, reloadServeWithWebSocketOptions<'websocketDataType>) => unit =
    "reload"

  @get external port: t => int = "port"
  @send external upgrade: (t, Request.t) => bool = "upgrade"

  @send
  external publish: (t, ~topic: string, ~data: string, ~compress: bool=?) => unit = "publish"

  @send
  external publishCheckStatus: (
    t,
    ~topic: string,
    ~data: string,
    ~compress: bool=?,
  ) => WebSocket.serverWebSocketSendStatus = "publish"

  /**
     * Returns the client IP address and port of the given Request. If the request was closed or is a unix socket, returns null.
     *
     * @example
     * ```js
     * export default {
     *  async fetch(request, server) {
     *    return new Response(server.requestIP(request));
     *  }
     * }
     * ```
     */
  @return(nullable)
  @send
  external requestIP: (t, Request.t) => option<socketAddress> = "requestIP"

  /**
     * How many requests are in-flight right now?
     */
  @get
  external pendingRequests: t => int = "pendingRequests"

  /**
     * How many {@link ServerWebSocket}s are in-flight right now?
     */
  @get
  external pendingWebSockets: t => int = "pendingWebSockets"

  /**
     * The hostname the server is listening on. Does not include the port
     * @example
     * ```js
     * "localhost"
     * ```
     */
  @get
  external hostname: t => string = "hostname"
  /**
     * Is the server running in development mode?
     *
     * In development mode, `Bun.serve()` returns rendered error messages with
     * stack traces instead of a generic 500 error. This makes debugging easier,
     * but development mode shouldn't be used in production or you will risk
     * leaking sensitive information.
     *
     */
  @get
  external development: t => bool = "development"

  /**
     * An identifier of the server instance
     *
     * When bun is started with the `--hot` flag, this ID is used to hot reload the server without interrupting pending requests or websockets.
     *
     * When bun is not started with the `--hot` flag, this ID is currently unused.
     */
  @get
  external id: t => string = "id"
}

/**
   * [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob) powered by the fastest system calls available for operating on files.
   *
   * This Blob is lazy. That means it won't do any work until you read from it.
   *
   * - `size` will not be valid until the contents of the file are read at least once.
   * - `type` is auto-set based on the file extension when possible
   *
   * @example
   * ```js
   * const file = Bun.file("./hello.json");
   * console.log(file.type); // "application/json"
   * console.log(await file.text()); // '{"hello":"world"}'
   * ```
   *
   * @example
   * ```js
   * await Bun.write(
   *   Bun.file("./hello.txt"),
   *   "Hello, world!"
   * );
   * ```
   *
   */
module BunFile = {
  type t = bunFile

  /**
     * Offset any operation on the file starting at `begin` and ending at `end`. `end` is relative to 0
     *
     * Similar to [`TypedArray.subarray`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/subarray). Does not copy the file, open the file, or modify the file.
     *
     * If `begin` > 0, {@link Bun.write()} will be slower on macOS
     *
     * @param begin - start offset in bytes
     * @param end - absolute offset in bytes (relative to 0)
     * @param contentType - MIME type for the new BunFile
     */
  @send
  external slice: (t, ~begin: float=?, ~end: float=?, ~contentType: string=?) => t = "slice"

  type writerOptions = {highWaterMark?: float}

  /**
   * Incremental writer for files and pipes.
   */
  @send
  external writer: (t, ~options: writerOptions=?) => fileSink = "writer"

  @get external readable: t => ReadableStream.t<_> = "readable"

  /**
   * A UNIX timestamp indicating when the file was last modified.
   */
  @get
  external lastModified: t => float = "lastModified"

  /**
   * The name or path of the file, as specified in the constructor.
   */
  @get
  external name: t => option<string> = "name"

  /**
   * Does the file exist?
    *
    * This returns true for regular files and FIFOs. It returns false for
    * directories. Note that a race condition can occur where the file is
    * deleted or renamed after this is called but before you open it.
    *
    * This does a system call to check if the file exists, which can be
    * slow.
    *
    * If using this in an HTTP server, it's faster to instead use `return new
    * Response(Bun.file(path))` and then an `error` handler to handle
    * exceptions.
    *
    * Instead of checking for a file's existence and then performing the
    * operation, it is faster to just perform the operation and handle the
    * error.
    *
    * For empty Blob, this always returns true.
    */
  @send
  external exists: t => promise<bool> = "exists"

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

  external asBlob: t => Js.Blob.t = "%identity"
}

type tlsOptions = {
  /**
     * File path to a TLS key
     *
     * To enable TLS, this option is required.
     *
     * @deprecated since v0.6.3 - Use `key: Bun.file(path)` instead.
     */
  keyFile?: string,
  /**
     * File path to a TLS certificate
     *
     * To enable TLS, this option is required.
     *
     * @deprecated since v0.6.3 - Use `cert: Bun.file(path)` instead.
     */
  certFile?: string,
  /**
     * Passphrase for the TLS key
     */
  passphrase?: string,
  /**
     *  File path to a .pem file for a custom root CA
     *
     * @deprecated since v0.6.3 - Use `ca: Bun.file(path)` instead.
     */
  caFile?: string,
  /**
     * File path to a .pem file custom Diffie Helman parameters
     */
  dhParamsFile?: string,
  /**
     * Explicitly set a server name
     */
  serverName?: string,
  /**
     * This sets `OPENSSL_RELEASE_BUFFERS` to 1.
     * It reduces overall performance but saves some memory.
     * @default false
     */
  lowMemoryMode?: bool,
  /**
     * Optionally override the trusted CA certificates. Default is to trust
     * the well-known CAs curated by Mozilla. Mozilla's CAs are completely
     * replaced when CAs are explicitly specified using this option.
     */
  ca?: array<BunFile.t>,
  /**
     *  Cert chains in PEM format. One cert chain should be provided per
     *  private key. Each cert chain should consist of the PEM formatted
     *  certificate for a provided private key, followed by the PEM
     *  formatted intermediate certificates (if any), in order, and not
     *  including the root CA (the root CA must be pre-known to the peer,
     *  see ca). When providing multiple cert chains, they do not have to
     *  be in the same order as their private keys in key. If the
     *  intermediate certificates are not provided, the peer will not be
     *  able to validate the certificate, and the handshake will fail.
     */
  cert?: array<BunFile.t>,
  /**
     * Private keys in PEM format. PEM allows the option of private keys
     * being encrypted. Encrypted keys will be decrypted with
     * options.passphrase. Multiple keys using different algorithms can be
     * provided either as an array of unencrypted key strings or buffers,
     * or an array of objects in the form {pem: <string|buffer>[,
     * passphrase: <string>]}. The object form can only occur in an array.
     * object.passphrase is optional. Encrypted keys will be decrypted with
     * object.passphrase if provided, or options.passphrase if it is not.
     */
  key?: array<BunFile.t>,
  /**
     * Optionally affect the OpenSSL protocol behavior, which is not
     * usually necessary. This should be used carefully if at all! Value is
     * a numeric bitmask of the SSL_OP_* options from OpenSSL Options
     */
  secureOptions?: float, // Value is a numeric bitmask of the `SSL_OP_*` options
}

type genericServeOptions = {
  /*
   * What URI should be used to make Request.url absolute?
   * By default, looks at hostname, port, and whether or not SSL is enabled to generate one
   *
   * Example: "http://my-app.com"
   * Example: "https://wongmjane.com/"
   *
   * This should be the public, absolute URL – include the protocol and hostname.
   * If the port isn't 80 or 443, then include the port too.
   *
   * Example: "http://localhost:3000"
   */
  // baseURI: option<string>, // Uncomment and use if needed

  /*
   * What is the maximum size of a request body? (in bytes)
   * Default: 1024 * 1024 * 128 // 128MB
   */
  maxRequestBodySize?: int,
  /*
   * Render contextual errors? This enables bun's error page
   * Default: process.env.NODE_ENV !== 'production'
   */
  development?: bool,
  /*
   * Error handling function
   */
  error?: (Server.t, Error.t) => option<Response.t>,
  /*
   * Uniquely identify a server instance with an ID
   *
   * When bun is started with the `--hot` flag
   * - This string will be used to hot reload the server without interrupting
   *   pending requests or websockets. If not provided, a value will be
   *   generated. To disable hot reloading, set this value to `null`.
   *
   * When bun is not started with the `--hot` flag
   * - This string will currently do nothing. But in the future it could be useful for logs or metrics.
   */
  id?: string,
  unix?: string,
  tls?: tlsOptions,
  /**
     *  The keys are [SNI](https://en.wikipedia.org/wiki/Server_Name_Indication) hostnames.
     *  The values are SSL options objects.
     */
  serverNames?: Dict.t<tlsOptions>,
}

type serveOptions = {
  ...genericServeOptions,
  /*
   * What port should the server listen on?
   * Default: process.env.PORT || "3000"
   */
  port?: int,
  /*
   * If the `SO_REUSEPORT` flag should be set.
   *
   * This allows multiple processes to bind to the same port, which is useful for load balancing.
   *
   * Default: false
   */
  reusePort?: bool,
  /*
   * What hostname should the server listen on?
   *
   * Default: "0.0.0.0" // listen on all interfaces
   * Example: "127.0.0.1" // Only listen locally
   * Example: "remix.run" // Only listen on remix.run
   *
   * Note: hostname should not include a port
   */
  hostname?: string,
  // 'unix' field is omitted as it's never type and seems not relevant here

  /*
   * Handle HTTP requests
   *
   * Respond to Request objects with a Response object.
   *
   */
  fetch: (Request.t, Server.t) => promise<Response.t>,
}

// TODO(future): Bind all `serve` versions when needed: https://github.com/oven-sh/bun/blob/c08e8a76eff713f87a1f0791bba803c2b110a7a7/packages/bun-types/bun.d.ts#L86
external serve: serveOptions => Server.t = "Bun.serve"

type webSocketServeOptions<'websocketDataType> = {
  ...serveOptions,
  /**
     * Enable websockets with {@link Bun.serve}
     *
     * For simpler type safety, see {@link Bun.websocket}
     *
     * @example
     * ```js
     *import { serve } from "bun";
     *serve({
     *  websocket: {
     *    open: (ws) => {
     *      console.log("Client connected");
     *    },
     *    message: (ws, message) => {
     *      console.log("Client sent message", message);
     *    },
     *    close: (ws) => {
     *      console.log("Client disconnected");
     *    },
     *  },
     *  fetch(req, server) {
     *    const url = new URL(req.url);
     *    if (url.pathname === "/chat") {
     *      const upgraded = server.upgrade(req);
     *      if (!upgraded) {
     *        return new Response("Upgrade failed", { status: 400 });
     *      }
     *    }
     *    return new Response("Hello World");
     *  },
     *});
     *```
     * Upgrade a {@link Request} to a {@link ServerWebSocket} via {@link Server.upgrade}
     *
     * Pass `data` in @{link Server.upgrade} to attach data to the {@link ServerWebSocket.data} property
     *
     *
     */
  websocket: WebSocket.config<'websocketDataType>,
}

external serveWithWebSocket: webSocketServeOptions<'websocketDataType> => Server.t = "Bun.serve"

/**
   * [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob) powered by the fastest system calls available for operating on files.
   *
   * This Blob is lazy. That means it won't do any work until you read from it.
   *
   * - `size` will not be valid until the contents of the file are read at least once.
   * - `type` is auto-set based on the file extension when possible
   *
   * @example
   * ```js
   * const file = Bun.file("./hello.json");
   * console.log(file.type); // "application/json"
   * console.log(await file.json()); // { hello: "world" }
   * ```
   *
   * @example
   * ```js
   * await Bun.write(
   *   Bun.file("./hello.txt"),
   *   "Hello, world!"
   * );
   * ```
   * @param path The path to the file (lazily loaded)
   *
   */
external file: (string, ~options: Blob.blobPropertyBag=?) => BunFile.t = "Bun.file"

/**
   * [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob) powered by the fastest system calls available for operating on files.
   *
   * This Blob is lazy. That means it won't do any work until you read from it.
   *
   * - `size` will not be valid until the contents of the file are read at least once.
   * - `type` is auto-set based on the file extension when possible
   *
   * @example
   * ```js
   * const file = Bun.file("./hello.json");
   * console.log(file.type); // "application/json"
   * console.log(await file.json()); // { hello: "world" }
   * ```
   *
   * @example
   * ```js
   * await Bun.write(
   *   Bun.file("./hello.txt"),
   *   "Hello, world!"
   * );
   * ```
   * @param path The path to the file (lazily loaded)
   *
   */
external fileFromURL: (URL.t, ~options: Blob.blobPropertyBag=?) => BunFile.t = "Bun.file"

/**
   * `Blob` that leverages the fastest system calls available to operate on files.
   *
   * This Blob is lazy. It won't do any work until you read from it. Errors propagate as promise rejections.
   *
   * `Blob.size` will not be valid until the contents of the file are read at least once.
   * `Blob.type` will have a default set based on the file extension
   *
   * @example
   * ```js
   * const file = Bun.file(new TextEncoder.encode("./hello.json"));
   * console.log(file.type); // "application/json"
   * ```
   *
   * @param path The path to the file as a byte buffer (the buffer is copied)
   */
external fileFromUint8Array: (Uint8Array.t, ~options: Blob.blobPropertyBag=?) => BunFile.t =
  "Bun.file"
external fileFromArrayBuffer: (ArrayBuffer.t, ~options: Blob.blobPropertyBag=?) => BunFile.t =
  "Bun.file"

external fileFromFileDescriptor: (fileDescriptor, ~options: Blob.blobPropertyBag=?) => BunFile.t =
  "Bun.file"

external fileFromFile: (Js.File.t, ~options: Blob.blobPropertyBag=?) => BunFile.t = "Bun.file"

/**
  * Synchronously resolve a `moduleId` as though it were imported from `parent`
  *
  * On failure, throws a `ResolveMessage`
  */
external resolveSync: (string, string) => string = "Bun.resolveSync"

/**
  * Resolve a `moduleId` as though it were imported from `parent`
  *
  * On failure, throws a `ResolveMessage`
  *
  * For now, use the sync version. There is zero performance benefit to using this async version. It exists for future-proofing.
  */
external resolve: (string, string) => promise<string> = "Bun.resolve"

type writeOptions = {mode?: int}

module Write = {
  module Destination = {
    type t
    external fromBunFile: BunFile.t => t = "%identity"
    external fromPath: string => t = "%identity"
  }

  module Input = {
    type t
    external fromBlob: Blob.t => t = "%identity"
    external fromTypedArray: TypedArray.t<_> => t = "%identity"
    external fromArrayBuffer: ArrayBuffer.t => t = "%identity"
    external fromString: string => t = "%identity"
    external fromBlobParts: array<Blob.blobPart> => t = "%identity"
  }
  /**
   *
   * Use the fastest syscalls available to copy from `input` into `destination`.
   *
   * If `destination` exists, it must be a regular file or symlink to a file.
   *
   * @param destination The file or file path to write to
   * @param input The data to copy into `destination`.
   * @returns A promise that resolves with the number of bytes written.
   */
  external write: (
    ~destination: Destination.t,
    ~input: Input.t,
    ~options: writeOptions=?,
  ) => promise<float> = "Bun.write"

  /**
 * Persist a {@link Response} body to disk.
 *
 * @param destination The file to write to. If the file doesn't exist,
 * it will be created and if the file does exist, it will be
 * overwritten. If `input`'s size is less than `destination`'s size,
 * `destination` will be truncated.
 * @param input - `Response` object
 * @returns A promise that resolves with the number of bytes written.
 */
  external writeResponseToFile: (~file: BunFile.t, ~response: Response.t) => promise<float> =
    "Bun.write"

  /**
   *
   * Persist a {@link Response} body to disk.
   *
   * @param destinationPath The file path to write to. If the file doesn't
   * exist, it will be created and if the file does exist, it will be
   * overwritten. If `input`'s size is less than `destination`'s size,
   * `destination` will be truncated.
   * @param input - `Response` object
   * @returns A promise that resolves with the number of bytes written.
   */
  external writeResponseToPath: (~destinationPath: string, ~input: Response.t) => promise<float> =
    "Bun.write"

  /**
   *
   * Use the fastest syscalls available to copy from `input` into `destination`.
   *
   * If `destination` exists, it must be a regular file or symlink to a file.
   *
   * On Linux, this uses `copy_file_range`.
   *
   * On macOS, when the destination doesn't already exist, this uses
   * [`clonefile()`](https://www.manpagez.com/man/2/clonefile/) and falls
   * back to [`fcopyfile()`](https://www.manpagez.com/man/2/fcopyfile/)
   *
   * @param destination The file to write to. If the file doesn't exist,
   * it will be created and if the file does exist, it will be
   * overwritten. If `input`'s size is less than `destination`'s size,
   * `destination` will be truncated.
   * @param input The file to copy from.
   * @returns A promise that resolves with the number of bytes written.
   */
  external writeFileToFile: (~destination: BunFile.t, ~input: BunFile.t) => promise<float> =
    "Bun.write"

  /**
   *
   * Use the fastest syscalls available to copy from `input` into `destination`.
   *
   * If `destination` exists, it must be a regular file or symlink to a file.
   *
   * On Linux, this uses `copy_file_range`.
   *
   * On macOS, when the destination doesn't already exist, this uses
   * [`clonefile()`](https://www.manpagez.com/man/2/clonefile/) and falls
   * back to [`fcopyfile()`](https://www.manpagez.com/man/2/fcopyfile/)
   *
   * @param destinationPath The file path to write to. If the file doesn't
   * exist, it will be created and if the file does exist, it will be
   * overwritten. If `input`'s size is less than `destination`'s size,
   * `destination` will be truncated.
   * @param input The file to copy from.
   * @returns A promise that resolves with the number of bytes written.
   */
  external writeFileToPath: (~destinationPath: string, ~input: BunFile.t) => promise<float> =
    "Bun.write"
}

module TypedArrayOrBuffer = {
  type t
  external fromTypedArray: TypedArray.t<_> => t = "%identity"
  external fromArrayBuffer: ArrayBuffer.t => t = "%identity"
}

/**
 * Concatenate an array of typed arrays into a single `ArrayBuffer`. This is a fast path.
 *
 * You can do this manually if you'd like, but this function will generally
 * be a little faster.
 *
 * If you want a `Uint8Array` instead, consider `Buffer.concat`.
 *
 * @param buffers An array of typed arrays to concatenate.
 * @returns An `ArrayBuffer` with the data from all the buffers.
 *
 * Here is similar code to do it manually, except about 30% slower:
 * ```js
 *   var chunks = [...];
 *   var size = 0;
 *   for (const chunk of chunks) {
 *     size += chunk.byteLength;
 *   }
 *   var buffer = new ArrayBuffer(size);
 *   var view = new Uint8Array(buffer);
 *   var offset = 0;
 *   for (const chunk of chunks) {
 *     view.set(chunk, offset);
 *     offset += chunk.byteLength;
 *   }
 *   return buffer;
 * ```
 *
 * This function is faster because it uses uninitialized memory when copying. Since the entire
 * length of the buffer is known, it is safe to use uninitialized memory.
 */
external concatArrayBuffers: array<TypedArrayOrBuffer.t> => ArrayBuffer.t = "Bun.concatArrayBuffers"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 * 
 * Concatenate the chunks into a single `ArrayBuffer`.
 *
 * @param stream The stream to consume.
 * @returns A promise that resolves with the concatenated chunks or the concatenated chunks as an `ArrayBuffer`.
 */
external readableStreamToArrayBuffer: ReadableStream.t<TypedArrayOrBuffer.t> => promise<
  ArrayBuffer.t,
> = "Bun.readableStreamToArrayBuffer"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 *
 * Concatenate the chunks into a single `Blob`.
 *
 * @param stream The stream to consume.
 * @returns A promise that resolves with the concatenated chunks as a `Blob`.
 */
external readableStreamToBlob: ReadableStream.t<_> => promise<Blob.t> = "Bun.readableStreamToBlob"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 *
 * Reads the multi-part or URL-encoded form data into a `FormData` object
 *
 * @param stream The stream to consume.
 * @params multipartBoundaryExcludingDashes Optional boundary to use for multipart form data.
 * @returns A promise that resolves with the data encoded into a `FormData` object.
 */
external readableStreamToFormData: (
  ~stream: ReadableStream.t<_>,
  ~multipartBoundaryExcludingDashes: string=?,
) => promise<FormData.t> = "Bun.readableStreamToFormData"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 *
 * Concatenate the chunks into a single string.
 *
 * @param stream The stream to consume.
 * @returns A promise that resolves with the concatenated chunks as a `String`.
 */
external readableStreamToText: ReadableStream.t<_> => promise<string> = "Bun.readableStreamToText"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 *
 * Concatenate the chunks into a single string and parse as JSON.
 *
 * @param stream The stream to consume.
 * @returns A promise that resolves with the concatenated chunks.
 */
external readableStreamToJSON: ReadableStream.t<_> => promise<JSON.t> = "Bun.readableStreamToJSON"

/**
 * Consume all data from a `ReadableStream` until it closes or errors.
 *
 * @param stream The stream to consume.
 * @returns A promise that resolves with the chunks as an array.
 *
 */
external readableStreamToArray: ReadableStream.t<'a> => promise<array<'a>> =
  "Bun.readableStreamToArray"

/**
 * Escape the following characters in a string:
 *
 * - `"` becomes `"&quot;"`
 * - `&` becomes `"&amp;"`
 * - `'` becomes `"&#x27;"`
 * - `<` becomes `"&lt;"`
 * - `>` becomes `"&gt;"`
 *
 * This function is optimized for large input.
 * Non-string types will be converted to a string before escaping.
 */
external escapeHTML: string => string = "Bun.escapeHTML"

/**
 * Convert a filesystem path to a file:// URL.
 *
 * @param path The path to convert.
 * @returns A URL with the file:// scheme.
 *
 * Internally, this function uses WebKit's URL API to
 * convert the path to a file:// URL.
 */
external pathToFileURL: string => URL.t = "Bun.pathToFileURL"

module Peek: {
  type t<'t>
  type decoded<'t> = Async(promise<'t>) | Sync('t)
  let decode: t<'t> => decoded<'t>
  @send external status: t<_> => promiseStatus = "status"
  external peekPromise: promise<'t> => t<'t> = "Bun.peek"
} = {
  type t<'t>

  type decoded<'t> = Async(promise<'t>) | Sync('t)

  let asPromise: t<'v> => option<promise<'v>> = %ffi(`function asPromise(v) {
    return v instanceof Promise ? v : undefined
  }`)

  external asSync: t<'v> => 'v = "%identity"

  let decode = (v: t<'t>) =>
    switch asPromise(v) {
    | Some(v) => Async(v)
    | None => Sync(asSync(v))
    }

  @send external status: t<_> => promiseStatus = "status"
  external peekPromise: promise<'t> => t<'t> = "Bun.peek"
}

/**
 * Convert a URL to a filesystem path.
 * @param url The URL to convert.
 * @returns A filesystem path.
 * @throws If the URL is not a URL.
 */
@val
external fileURLToPath: string => string = "Bun.fileURLToPath"

/**
 * Convert a URL to a filesystem path.
 * @param url The URL to convert.
 * @returns A filesystem path.
 * @throws If the URL is not a URL.
 */
@val
external fileURLAsURLToPath: URL.t => string = "Bun.fileURLToPath"

module ArrayBufferSink = {
  type t

  @new external make: unit => t = "ArrayBufferSink"

  type startOptions = {
    asUint8Array?: bool,
    /**
       * Preallocate an internal buffer of this size
       * This can significantly improve performance when the chunk size is small
       */
    highWaterMark?: float,
    /**
       * On {@link ArrayBufferSink.flush}, return the written data as a `Uint8Array`.
       * Writes will restart from the beginning of the buffer.
       */
    stream?: bool,
  }

  @send
  external start: (t, ~options: startOptions=?) => unit = "start"

  @send
  external writeString: (t, string) => float = "write"

  @send
  external writeArrayBufferView: (t, ArrayBufferView.t) => float = "write"

  @send
  external writeArrayBuffer: (t, ArrayBuffer.t) => float = "write"

  @send
  external writeSharedArrayBuffer: (t, SharedArrayBuffer.t) => float = "write"

  module EndResult: {
    type t
    type decoded = Uint8Array(Uint8Array.t) | ArrayBuffer(ArrayBuffer.t)
    let decode: t => decoded
  } = {
    type t
    type decoded = Uint8Array(Uint8Array.t) | ArrayBuffer(ArrayBuffer.t)

    external asArrayBuffer: t => ArrayBuffer.t = "%identity"

    let asUint8Array: t => option<Uint8Array.t> = %ffi(`function asUint8Array(raw) {
      if (raw instanceof Uint8Array) {
        return raw
      }
    }`)

    let decode = raw => {
      switch asUint8Array(raw) {
      | Some(v) => Uint8Array(v)
      | None => ArrayBuffer(asArrayBuffer(raw))
      }
    }
  }

  module FlushResult: {
    type t
    type decoded = Bytes(float) | Uint8Array(Uint8Array.t) | ArrayBuffer(ArrayBuffer.t)
    let decode: t => decoded
  } = {
    type t
    type decoded = Bytes(float) | Uint8Array(Uint8Array.t) | ArrayBuffer(ArrayBuffer.t)

    external asNumber: t => float = "%identity"

    let asUint8Array: t => option<Uint8Array.t> = %ffi(`function asUint8Array(raw) {
      if (raw instanceof Uint8Array) {
        return raw
      }
    }`)

    let asArrayBuffer: t => option<ArrayBuffer.t> = %ffi(`function asArrayBuffer(raw) {
      if (raw instanceof ArrayBuffer) {
        return raw
      }
    }`)

    let decode = raw => {
      switch asUint8Array(raw) {
      | Some(v) => Uint8Array(v)
      | None =>
        switch asArrayBuffer(raw) {
        | Some(v) => ArrayBuffer(v)
        | None => Bytes(asNumber(raw))
        }
      }
    }
  }

  @send
  external flush: t => FlushResult.t = "flush"

  @send
  external end: t => EndResult.t = "end"
}

module Dns = {
  type t
  type lookup = {
    /**
     * The IP address of the host as a string in IPv4 or IPv6 format.
     *
     * @example "127.0.0.1"
     * @example "192.168.0.1"
     * @example "2001:4860:4860::8888"
     */
    address: string,
    family: [#4 | #6],
    /**
     * Time to live in seconds
     *
     * Only supported when using the `c-ares` DNS resolver via "backend" option
     * to {@link dns.lookup}. Otherwise, it's 0.
     */
    ttl: float,
  }

  type family = | @as(0) Zero | @as(4) Four | @as(6) Six | IPv4 | IPv6 | @as("any") Any
  type socketType = | @as("udp") Udp | @as("tcp") Tcp
  type lookupOptions = {
    family?: family,
    socketType?: socketType,
    flags?: int,
    port?: int,
    backend?: string,
  }

  /** 
   * Lookup the IP address for a hostname.
   *
   * Uses non-blocking APIs by default.
   *
   * ## Example
   * ```
   * const [{ address }] = await Bun.dns.lookup('example.com');
   * ```
   *
   * ### Filter results to IPv4:
   * ```
   * import { dns } from 'bun';
   * const [{ address }] = await dns.lookup('example.com', {family: 4});
   * console.log(address); // "123.122.22.126"
   * ```
   *
   * ### Filter results to IPv6:
   * ```
   * import { dns } from 'bun';
   * const [{ address }] = await dns.lookup('example.com', {family: 6});
   * console.log(address); // "2001:db8::1"
   * ```
   *
   * #### DNS resolver client
   *
   * Bun supports three DNS resolvers:
   * - `c-ares` - Uses the c-ares library to perform DNS resolution. This is the default on Linux.
   * - `system` - Uses the system's non-blocking DNS resolver API if available, falls back to `getaddrinfo`. This is the default on macOS and the same as `getaddrinfo` on Linux.
   * - `getaddrinfo` - Uses the posix standard `getaddrinfo` function. Will cause performance issues under concurrent loads.
   *
   * To customize the DNS resolver, pass a `backend` option to `dns.lookup`:
   * ```
   * import { dns } from 'bun';
   * const [{ address }] = await dns.lookup('example.com', {backend: 'getaddrinfo'});
   * console.log(address); // "19.42.52.62"
   * ```
   */
  @send
  external lookup: (t, string, ~options: lookupOptions=?) => promise<array<lookup>> = "lookup"
}

external dns: Dns.t = "Bun.dns"

/**
   * Fast incremental writer for files and pipes.
   *
   * This uses the same interface as {@link ArrayBufferSink}, but writes to a file or pipe.
   */
module FileSink = {
  type t
  /**
     * Write a chunk of data to the file.
     *
     * If the file descriptor is not writable yet, the data is buffered.
     */
  @send
  external writeString: (t, string) => float = "write"

  @send
  external writeArrayBufferView: (t, ArrayBufferView.t) => float = "write"

  @send
  external writeArrayBuffer: (t, ArrayBuffer.t) => float = "write"

  @send
  external writeSharedArrayBuffer: (t, SharedArrayBuffer.t) => float = "write"

  @unboxed type floatOrPromisedFloat = Bytes(float) | Async(promise<float>)
  /**
     * Flush the internal buffer, committing the data to disk or the pipe.
     */
  @send
  external flush: t => floatOrPromisedFloat = "flush"
  /**
     * Close the file descriptor. This also flushes the internal buffer.
     */
  @send
  external end: (t, ~error: Error.t=?) => floatOrPromisedFloat = "end"

  type startOptions = {
    /**
       * Preallocate an internal buffer of this size
       * This can significantly improve performance when the chunk size is small
       */
    highWaterMark?: float,
  }

  @send external start: (t, ~options: startOptions=?) => unit = "start"

  /**
     * For FIFOs & pipes, this lets you decide whether Bun's process should
     * remain alive until the pipe is closed.
     *
     * By default, it is automatically managed. While the stream is open, the
     * process remains alive and once the other end hangs up or the stream
     * closes, the process exits.
     *
     * If you previously called {@link unref}, you can call this again to re-enable automatic management.
     *
     * Internally, it will reference count the number of times this is called. By default, that number is 1
     *
     * If the file is not a FIFO or pipe, {@link ref} and {@link unref} do
     * nothing. If the pipe is already closed, this does nothing.
     */
  @send
  external ref: t => unit = "ref"

  /**
     * For FIFOs & pipes, this lets you decide whether Bun's process should
     * remain alive until the pipe is closed.
     *
     * If you want to allow Bun's process to terminate while the stream is open,
     * call this.
     *
     * If the file is not a FIFO or pipe, {@link ref} and {@link unref} do
     * nothing. If the pipe is already closed, this does nothing.
     */
  @send
  external unref: t => unit = "unref"
}

/**
 * Hash a string or array buffer using Wyhash
 *
 * This is not a cryptographic hash function.
 * @param data The data to hash.
 * @param seed The seed to use.
 */
module Hash = {
  type t

  // TODO(future): float | bigint, when untagged variants can handle bigint
  external hashString: (string, ~seed: float=?) => float = "Bun.hash"
  external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float = "Bun.hash"
  external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash"
  external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float = "Bun.hash"

  module Algorithms = {
    module WyHash = {
      external hashString: (string, ~seed: BigInt.t=?) => BigInt.t = "Bun.hash.wyhash"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.wyhash"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t = "Bun.hash.wyhash"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.wyhash"
    }

    module Adler32 = {
      external hashString: (string, ~seed: float=?) => float = "Bun.hash.adler32"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float =
        "Bun.hash.adler32"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash.adler32"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float =
        "Bun.hash.adler32"
    }

    module Crc32 = {
      external hashString: (string, ~seed: float=?) => float = "Bun.hash.crc32"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float = "Bun.hash.crc32"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash.crc32"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float =
        "Bun.hash.crc32"
    }

    module CityHash32 = {
      external hashString: (string, ~seed: float=?) => float = "Bun.hash.cityHash32"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float =
        "Bun.hash.cityHash32"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash.cityHash32"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float =
        "Bun.hash.cityHash32"
    }

    module CityHash64 = {
      external hashString: (string, ~seed: BigInt.t=?) => BigInt.t = "Bun.hash.cityHash64"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.cityHash64"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.cityHash64"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.cityHash64"
    }

    module Murmur32v3 = {
      external hashString: (string, ~seed: float=?) => float = "Bun.hash.murmur32v3"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float =
        "Bun.hash.murmur32v3"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash.murmur32v3"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float =
        "Bun.hash.murmur32v3"
    }

    module Murmur32v2 = {
      external hashString: (string, ~seed: float=?) => float = "Bun.hash.murmur32v2"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: float=?) => float =
        "Bun.hash.murmur32v2"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: float=?) => float = "Bun.hash.murmur32v2"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: float=?) => float =
        "Bun.hash.murmur32v2"
    }

    module Murmur64v2 = {
      external hashString: (string, ~seed: BigInt.t=?) => BigInt.t = "Bun.hash.murmur64v2"
      external hashArrayBufferView: (ArrayBufferView.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.murmur64v2"
      external hashArrayBuffer: (ArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.murmur64v2"
      external hashSharedArrayBuffer: (SharedArrayBuffer.t, ~seed: BigInt.t=?) => BigInt.t =
        "Bun.hash.murmur64v2"
    }
  }
}

/**
   * Fast deep-equality check two objects.
   *
   * This also powers expect().toEqual in `bun:test`
   *
   */
external deepEquals: ('a, 'b, /** @default false */ ~strict: bool=?) => bool = "Bun.deepEquals"

/**
   * Returns true if all properties in the subset exist in the
   * other and have equal values.
   *
   * This also powers expect().toMatchObject in `bun:test`
   */
external deepMatch: ('a, 'b) => bool = "Bun.deepMatch"

// TODO(when needed): Transpiler
// TODO(when needed): Build

/**
 * Hash and verify passwords using argon2 or bcrypt. The default is argon2.
 * Password hashing functions are necessarily slow, and this object will
 * automatically run in a worker thread.
 *
 * The underlying implementation of these functions are provided by the Zig
 * Standard Library. Thanks to @jedisct1 and other Zig constributors for their
 * work on this.
 *
 * ### Example with argon2
 *
 * ```ts
 * import {password} from "bun";
 *
 * const hash = await password.hash("hello world");
 * const verify = await password.verify("hello world", hash);
 * console.log(verify); // true
 * ```
 *
 * ### Example with bcrypt
 * ```ts
 * import {password} from "bun";
 *
 * const hash = await password.hash("hello world", "bcrypt");
 * // algorithm is optional, will be inferred from the hash if not specified
 * const verify = await password.verify("hello world", hash, "bcrypt");
 *
 * console.log(verify); // true
 * ```
 */
module Password = {
  @tag("algorithm")
  type algorithmLabel =
    | @as("bcrypt") Bcrypt
    | @as("argon2id") Argon2Id
    | @as("argon2d") Argon2d
    | @as("argon2i") Argon2i

  @tag("algorithm")
  type hashAlgorithm =
    | @as("argon2id")
    Argon2id({
        /**
         * Memory cost, which defines the memory usage, given in kibibytes.
         */
        memoryCost?: float,
        /**
         * Defines the amount of computation realized and therefore the execution
         * time, given in number of iterations.
         */
        timeCost?: float,
      })
    | @as("argon2d")
    Argon2d({
        /**
         * Memory cost, which defines the memory usage, given in kibibytes.
         */
        memoryCost?: float,
        /**
         * Defines the amount of computation realized and therefore the execution
         * time, given in number of iterations.
         */
        timeCost?: float,
      })
    | @as("argon2i")
    Argon2i({
        /**
         * Memory cost, which defines the memory usage, given in kibibytes.
         */
        memoryCost?: float,
        /**
         * Defines the amount of computation realized and therefore the execution
         * time, given in number of iterations.
         */
        timeCost?: float,
      })
    | @as("bcrypt")
    BCryptAlgorithm({
        /**
       * A number between 4 and 31. The default is 10.
       */
        cost?: int,
      })

  /**
   * Verify a password against a previously hashed password.
   *
   * @returns true if the password matches, false otherwise
   *
   * @example
   * ```ts
   * import {password} from "bun";
   * await password.verify("hey", "$argon2id$v=19$m=65536,t=2,p=1$ddbcyBcbAcagei7wSkZFiouX6TqnUQHmTyS5mxGCzeM$+3OIaFatZ3n6LtMhUlfWbgJyNp7h8/oIsLK+LzZO+WI");
   * // true
   * ```
   *
   * @throws If the algorithm is specified and does not match the hash
   * @throws If the algorithm is invalid
   * @throws if the hash is invalid
   *
   */
  external verify: (
    /**
     * The password to verify.
     *
     * If empty, always returns false
     */ string,
    /**
     * Previously hashed password.
     * If empty, always returns false
     */
    ~hash: string,
    /**
     * If not specified, the algorithm will be inferred from the hash.
     *
     * If specified and the algorithm does not match the hash, this function
     * throws an error.
     */
    ~algorithm: algorithmLabel=?,
  ) => promise<bool> = "Bun.password.verify"

  /**
   * Verify a password against a previously hashed password.
   *
   * @returns true if the password matches, false otherwise
   *
   * @example
   * ```ts
   * import {password} from "bun";
   * await password.verify("hey", "$argon2id$v=19$m=65536,t=2,p=1$ddbcyBcbAcagei7wSkZFiouX6TqnUQHmTyS5mxGCzeM$+3OIaFatZ3n6LtMhUlfWbgJyNp7h8/oIsLK+LzZO+WI");
   * // true
   * ```
   *
   * @throws If the algorithm is specified and does not match the hash
   * @throws If the algorithm is invalid
   * @throws if the hash is invalid
   *
   */
  external verifyBuffer: (
    /**
     * The password to verify.
     *
     * If empty, always returns false
     */
    Buffer.t,
    /**
     * Previously hashed password.
     * If empty, always returns false
     */
    ~hash: StringOrBuffer.t,
    /**
     * If not specified, the algorithm will be inferred from the hash.
     *
     * If specified and the algorithm does not match the hash, this function
     * throws an error.
     */
    ~algorithm: algorithmLabel=?,
  ) => promise<bool> = "Bun.password.verify"

  /**
   * Asynchronously hash a password using argon2 or bcrypt. The default is argon2.
   *
   * @returns A promise that resolves to the hashed password
   *
   * ## Example with argon2
   * ```ts
   * import {password} from "bun";
   * const hash = await password.hash("hello world");
   * console.log(hash); // $argon2id$v=1...
   * const verify = await password.verify("hello world", hash);
   * ```
   * ## Example with bcrypt
   * ```ts
   * import {password} from "bun";
   * const hash = await password.hash("hello world", "bcrypt");
   * console.log(hash); // $2b$10$...
   * const verify = await password.verify("hello world", hash);
   * ```
   */
  external hash: (
    /**
     * The password to hash
     *
     * If empty, this function throws an error. It is usually a programming
     * mistake to hash an empty password.
     */
    string,
    /**
     * @default "argon2id"
     *
     * When using bcrypt, passwords exceeding 72 characters will be SHA512'd before
     */
    ~algorithm: hashAlgorithm=?,
  ) => promise<string> = "Bun.password.hash"

  /**
   * Asynchronously hash a password using argon2 or bcrypt. The default is argon2.
   *
   * @returns A promise that resolves to the hashed password
   *
   * ## Example with argon2
   * ```ts
   * import {password} from "bun";
   * const hash = await password.hash("hello world");
   * console.log(hash); // $argon2id$v=1...
   * const verify = await password.verify("hello world", hash);
   * ```
   * ## Example with bcrypt
   * ```ts
   * import {password} from "bun";
   * const hash = await password.hash("hello world", "bcrypt");
   * console.log(hash); // $2b$10$...
   * const verify = await password.verify("hello world", hash);
   * ```
   */
  external hashBuffer: (
    /**
     * The password to hash
     *
     * If empty, this function throws an error. It is usually a programming
     * mistake to hash an empty password.
     */
    Buffer.t,
    /**
     * @default "argon2id"
     *
     * When using bcrypt, passwords exceeding 72 characters will be SHA512'd before
     */
    ~algorithm: hashAlgorithm=?,
  ) => promise<string> = "Bun.password.hash"

  /**
   * Synchronously hash and verify passwords using argon2 or bcrypt. The default is argon2.
   * Warning: password hashing is slow, consider using {@link Bun.password.verify}
   * instead which runs in a worker thread.
   *
   * The underlying implementation of these functions are provided by the Zig
   * Standard Library. Thanks to @jedisct1 and other Zig constributors for their
   * work on this.
   *
   * ### Example with argon2
   *
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world");
   * const verify = await password.verifySync("hello world", hash);
   * console.log(verify); // true
   * ```
   *
   * ### Example with bcrypt
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world", "bcrypt");
   * // algorithm is optional, will be inferred from the hash if not specified
   * const verify = await password.verifySync("hello world", hash, "bcrypt");
   *
   * console.log(verify); // true
   * ```
   */
  external verifySync: (
    string,
    ~hash: string,
    /**
     * If not specified, the algorithm will be inferred from the hash.
     */
    ~algorithm: algorithmLabel=?,
  ) => bool = "Bun.password.verifySync"

  /**
   * Synchronously hash and verify passwords using argon2 or bcrypt. The default is argon2.
   * Warning: password hashing is slow, consider using {@link Bun.password.verify}
   * instead which runs in a worker thread.
   *
   * The underlying implementation of these functions are provided by the Zig
   * Standard Library. Thanks to @jedisct1 and other Zig constributors for their
   * work on this.
   *
   * ### Example with argon2
   *
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world");
   * const verify = await password.verifySync("hello world", hash);
   * console.log(verify); // true
   * ```
   *
   * ### Example with bcrypt
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world", "bcrypt");
   * // algorithm is optional, will be inferred from the hash if not specified
   * const verify = await password.verifySync("hello world", hash, "bcrypt");
   *
   * console.log(verify); // true
   * ```
   */
  external verifyBufferSync: (
    Buffer.t,
    ~hash: StringOrBuffer.t,
    /**
     * If not specified, the algorithm will be inferred from the hash.
     */
    ~algorithm: algorithmLabel=?,
  ) => bool = "Bun.password.verifySync"

  /**
   * Synchronously hash and verify passwords using argon2 or bcrypt. The default is argon2.
   * Warning: password hashing is slow, consider using {@link Bun.password.hash}
   * instead which runs in a worker thread.
   *
   * The underlying implementation of these functions are provided by the Zig
   * Standard Library. Thanks to @jedisct1 and other Zig constributors for their
   * work on this.
   *
   * ### Example with argon2
   *
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world");
   * const verify = await password.verifySync("hello world", hash);
   * console.log(verify); // true
   * ```
   *
   * ### Example with bcrypt
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world", "bcrypt");
   * // algorithm is optional, will be inferred from the hash if not specified
   * const verify = await password.verifySync("hello world", hash, "bcrypt");
   *
   * console.log(verify); // true
   * ```
   */
  external hashSync: (
    /**
     * The password to hash
     *
     * If empty, this function throws an error. It is usually a programming
     * mistake to hash an empty password.
     */
    string,
    /**
     * @default "argon2id"
     *
     * When using bcrypt, passwords exceeding 72 characters will be SHA256'd before
     */
    ~algorithm: hashAlgorithm=?,
  ) => string = "Bun.password.hashSync"

  /**
   * Synchronously hash and verify passwords using argon2 or bcrypt. The default is argon2.
   * Warning: password hashing is slow, consider using {@link Bun.password.hash}
   * instead which runs in a worker thread.
   *
   * The underlying implementation of these functions are provided by the Zig
   * Standard Library. Thanks to @jedisct1 and other Zig constributors for their
   * work on this.
   *
   * ### Example with argon2
   *
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world");
   * const verify = await password.verifySync("hello world", hash);
   * console.log(verify); // true
   * ```
   *
   * ### Example with bcrypt
   * ```ts
   * import {password} from "bun";
   *
   * const hash = await password.hashSync("hello world", "bcrypt");
   * // algorithm is optional, will be inferred from the hash if not specified
   * const verify = await password.verifySync("hello world", hash, "bcrypt");
   *
   * console.log(verify); // true
   * ```
   */
  external hashBufferSync: (
    /**
     * The password to hash
     *
     * If empty, this function throws an error. It is usually a programming
     * mistake to hash an empty password.
     */
    Buffer.t,
    /**
     * @default "argon2id"
     *
     * When using bcrypt, passwords exceeding 72 characters will be SHA256'd before
     */
    ~algorithm: hashAlgorithm=?,
  ) => string = "Bun.password.hashSync"
}

// TODO: WebSockets. Move config from globals to here.

/**
   * Allocate a new [`Uint8Array`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) without zeroing the bytes.
   *
   * This can be 3.5x faster than `new Uint8Array(size)`, but if you send uninitialized memory to your users (even unintentionally), it can potentially leak anything recently in memory.
   */
external allocUnsafe: float => Uint8Array.t = "Bun.allocUnsafe"

type bunInspectOptions = {
  colors?: bool,
  depth?: float,
  sorted?: bool,
}

/**
   * Pretty-print an object the same as {@link console.log} to a `string`
   *
   * Supports JSX
   *
   * @param args
   */
external inspect: ('ant, ~options: bunInspectOptions=?) => string = "Bun.inspect"

/** Write to stdout */
external stdout: BunFile.t = "Bun.stdout"

/** Write to stderr */
external stderr: BunFile.t = "Bun.stderr"

/**
 * Read from stdin
 *
 * This is read-only
 */
external stdin: BunFile.t = "Bun.stdin"

module SemVer = {
  type comparisonResult = | @as(1) V1IsGreater | @as(-1) V2IsGreater | @as(0) Equal
  type semver = {
    /**
     * Test if the version satisfies the range. Stringifies both arguments. Returns `true` or `false`.
     */
    satisfies: (~version: string, ~range: string) => bool,
    /**
     * Returns 0 if the versions are equal, 1 if `v1` is greater, or -1 if `v2` is greater.
     * Throws an error if either version is invalid.
     */
    order: (~v1: string, ~v2: string) => comparisonResult,
  }

  external semver: semver = "Bun.semver"
}

// TODO(when needed): unsafe

type digestEncoding = | @as("hex") Hex | @as("base64") Base64

/**
   * Are ANSI colors enabled for stdin and stdout?
   *
   * Used for {@link console.log}
   */
external enableANSIColors: bool = "Bun.enableANSIColors"

/**
   * What script launched bun?
   *
   * Absolute file path
   *
   * @example "/never-gonna-give-you-up.js"
   */
external main: string = "Bun.main"

/**
   * Manually trigger the garbage collector
   *
   * This does two things:
   * 1. It tells JavaScriptCore to run the garbage collector
   * 2. It tells [mimalloc](https://github.com/microsoft/mimalloc) to clean up fragmented memory. Mimalloc manages the heap not used in JavaScriptCore.
   *
   * @param force Synchronously run the garbage collector
   */
external gc: (~force: bool) => unit = "Bun.gc"

/**
   * JavaScriptCore engine's internal heap snapshot
   *
   * I don't know how to make this something Chrome or Safari can read.
   *
   * If you have any ideas, please file an issue https://github.com/oven-sh/bun
   */
type heapSnapshot = {
  /** 2 */
  version: int,
  /** "Inspector" */
  @as("type")
  type_: string,
  nodes: array<float>,
  nodeClassNames: array<string>,
  edges: array<float>,
  edgeTypes: array<string>,
  edgeNames: array<string>,
}

/**
   * Nanoseconds since Bun.js was started as an integer.
   *
   * This uses a high-resolution monotonic system timer.
   *
   * After 14 weeks of consecutive uptime, this function
   * wraps
   */
external nanoseconds: unit => float = "Bun.nanoseconds"

/**
   * Generate a heap snapshot for seeing where the heap is being used
   */
external generateHeapSnapshot: unit => heapSnapshot = "Bun.generateHeapSnapshot"

/**
 * The next time JavaScriptCore is idle, clear unused memory and attempt to reduce the heap size.
 */
external shrink: unit => unit = "Bun.shrink"

type editorOptions = {
  editor?: [#vscode | #subl],
  line?: int,
  column?: int,
}

/**
 * Open a file in your local editor. Auto-detects via `$VISUAL` || `$EDITOR`
 *
 * @param path path to open
 */
external openInEditor: (~path: string, ~options: editorOptions=?) => unit = "Bun.openInEditor"

module CryptoHasher = {
  type t

  type supportedCryptoAlgorithms =
    | @as("blake2b256") Blake2b256
    | @as("md4") Md4
    | @as("md5") Md5
    | @as("ripemd160") Ripemd160
    | @as("sha1") Sha1
    | @as("sha224") Sha224
    | @as("sha256") Sha256
    | @as("sha384") Sha384
    | @as("sha512") Sha512
    | @as("sha512-256") Sha512_256

  /**
     * The algorithm chosen to hash the data
     *
     */
  @get
  external algorithm: t => supportedCryptoAlgorithms = "algorithm"

  /**
     * The length of the output hash in bytes
     */
  @get
  external byteLength: t => float = "byteLength"

  /**
     * Create a new hasher
     *
     * @param algorithm The algorithm to use. See {@link algorithms} for a list of supported algorithms
     */
  @new
  external make: supportedCryptoAlgorithms => t = "Bun.CryptoHasher"

  /**
     * Update the hash with data
     *
     * @param input
     */
  @send
  external update: (t, ~input: StringOrBuffer.t, ~inputEncoding: BunCrypto.encoding=?) => t =
    "update"

  /**
     * Perform a deep copy of the hasher
     */
  @send
  external copy: t => t = "copy"

  /**
     * Finalize the hash. Resets the CryptoHasher so it can be reused.
     *
     * @param encoding `DigestEncoding` to return the hash in. If none is provided, it will return a `Uint8Array`.
     */
  @send
  external digest: (t, digestEncoding) => string = "digest"

  /**
     * Finalize the hash
     *
     * @param hashInto `TypedArray` to write the hash into. Faster than creating a new one each time
     */
  @send
  external digestToTypedArray: (~hashInto: TypedArray.t<'t>=?) => TypedArray.t<'t> = "digest"

  /**
     * Run the hash over the given data
     *
     * @param input `string`, `Uint8Array`, or `ArrayBuffer` to hash. `Uint8Array` or `ArrayBuffer` is faster.
     *
     * @param hashInto `TypedArray` to write the hash into. Faster than creating a new one each time
     */
  external hash: (
    ~algorithm: supportedCryptoAlgorithms,
    ~input: StringOrBuffer.t,
    ~hashInto: TypedArray.t<'t>=?,
  ) => TypedArray.t<'t> = "Bun.CryptoHasher.hash"

  /**
     * Run the hash over the given data
     *
     * @param input `string`, `Uint8Array`, or `ArrayBuffer` to hash. `Uint8Array` or `ArrayBuffer` is faster.
     *
     * @param encoding `DigestEncoding` to return the hash in
     */
  external hashToString: (
    ~algorithm: supportedCryptoAlgorithms,
    ~input: StringOrBuffer.t,
    ~encoding: digestEncoding,
  ) => string = "Bun.CryptoHasher.hash"

  /**
     * List of supported hash algorithms
     *
     * These are hardware accelerated with BoringSSL
     */
  external algorithms: array<supportedCryptoAlgorithms> = "Bun.CryptoHasher.algorithms"
}

/**
   * Resolve a `Promise` after milliseconds. This is like
   * {@link setTimeout} except it returns a `Promise`.
   *
   * @param ms milliseconds to delay resolving the promise. This is a minimum
   * number. It may take longer. If a {@link Date} is passed, it will sleep until the
   * {@link Date} is reached.
   *
   * @example
   * ## Sleep for 1 second
   * ```ts
   * import { sleep } from "bun";
   *
   * await sleep(1000);
   * ```
   * ## Sleep for 10 milliseconds
   * ```ts
   * await Bun.sleep(10);
   * ```
   * ## Sleep until `Date`
   *
   * ```ts
   * const target = new Date();
   * target.setSeconds(target.getSeconds() + 1);
   * await Bun.sleep(target);
   * ```
   * Internally, `Bun.sleep` is the equivalent of
   * ```ts
   * await new Promise((resolve) => setTimeout(resolve, ms));
   * ```
   * As always, you can use `Bun.sleep` or the imported `sleep` function interchangeably.
   */
external sleep: (~ms: dateOrNumber) => promise<unit> = "Bun.sleep"

/**
   * Sleep the thread for a given number of milliseconds
   *
   * This is a blocking function.
   *
   * Internally, it calls [nanosleep(2)](https://man7.org/linux/man-pages/man2/nanosleep.2.html)
   */
external sleepSync: (~ms: float) => unit = "Bun.sleepSync"

/**
   *
   * Hash `input` using [SHA-2 512/256](https://en.wikipedia.org/wiki/SHA-2#Comparison_of_SHA_functions)
   *
   * @param input `string`, `Uint8Array`, or `ArrayBuffer` to hash. `Uint8Array` or `ArrayBuffer` will be faster
   * @param hashInto optional `Uint8Array` to write the hash to. 32 bytes minimum.
   *
   * This hashing function balances speed with cryptographic strength. This does not encrypt or decrypt data.
   *
   * The implementation uses [BoringSSL](https://boringssl.googlesource.com/boringssl) (used in Chromium & Go)
   *
   * The equivalent `openssl` command is:
   *
   * ```bash
   * # You will need OpenSSL 3 or later
   * openssl sha512-256 /path/to/file
   *```
   */
external sha: (~input: StringOrBuffer.t, ~hashInto: TypedArray.t<'t>=?) => TypedArray.t<'t> =
  "Bun.sha"

/**
   *
   * Hash `input` using [SHA-2 512/256](https://en.wikipedia.org/wiki/SHA-2#Comparison_of_SHA_functions)
   *
   * @param input `string`, `Uint8Array`, or `ArrayBuffer` to hash. `Uint8Array` or `ArrayBuffer` will be faster
   * @param encoding `DigestEncoding` to return the hash in
   *
   * This hashing function balances speed with cryptographic strength. This does not encrypt or decrypt data.
   *
   * The implementation uses [BoringSSL](https://boringssl.googlesource.com/boringssl) (used in Chromium & Go)
   *
   * The equivalent `openssl` command is:
   *
   * ```bash
   * # You will need OpenSSL 3 or later
   * openssl sha512-256 /path/to/file
   *```
   */
external shaToString: (~input: StringOrBuffer.t, ~encoding: digestEncoding) => string = "Bun.sha"

// TODO: CryptoHashInterface + friends

/** Compression options for `Bun.deflateSync` and `Bun.gzipSync` */
type zlibCompressionOptions = {
  /**
     * The compression level to use. Must be between `-1` and `9`.
     * - A value of `-1` uses the default compression level (Currently `6`)
     * - A value of `0` gives no compression
     * - A value of `1` gives least compression, fastest speed
     * - A value of `9` gives best compression, slowest speed
     */
  level?: [#"-1" | #0 | #1 | #2 | #3 | #4 | #5 | #6 | #7 | #8 | #9],
  /**
     * How much memory should be allocated for the internal compression state.
     *
     * A value of `1` uses minimum memory but is slow and reduces compression ratio.
     *
     * A value of `9` uses maximum memory for optimal speed. The default is `8`.
     */
  memLevel?: [#1 | #2 | #3 | #4 | #5 | #6 | #7 | #8 | #9],
  /**
     * The base 2 logarithm of the window size (the size of the history buffer).
     *
     * Larger values of this parameter result in better compression at the expense of memory usage.
     *
     * The following value ranges are supported:
     * - `9..15`: The output will have a zlib header and footer (Deflate)
     * - `-9..-15`: The output will **not** have a zlib header or footer (Raw Deflate)
     * - `25..31` (16+`9..15`): The output will have a gzip header and footer (gzip)
     *
     * The gzip header will have no file name, no extra data, no comment, no modification time (set to zero) and no header CRC.
     */
  windowBits?: [
    | #"-9"
    | #"-10"
    | #"-11"
    | #"-12"
    | #"-13"
    | #"-14"
    | #"-15"
    | #9
    | #10
    | #11
    | #12
    | #13
    | #14
    | #15
    | #25
    | #26
    | #27
    | #28
    | #29
    | #30
    | #31
  ],
  /**
     * Tunes the compression algorithm.
     *
     * - `Z_DEFAULT_STRATEGY`: For normal data **(Default)**
     * - `Z_FILTERED`: For data produced by a filter or predictor
     * - `Z_HUFFMAN_ONLY`: Force Huffman encoding only (no string match)
     * - `Z_RLE`: Limit match distances to one (run-length encoding)
     * - `Z_FIXED` prevents the use of dynamic Huffman codes
     *
     * `Z_RLE` is designed to be almost as fast as `Z_HUFFMAN_ONLY`, but give better compression for PNG image data.
     *
     * `Z_FILTERED` forces more Huffman coding and less string matching, it is
     * somewhat intermediate between `Z_DEFAULT_STRATEGY` and `Z_HUFFMAN_ONLY`.
     * Filtered data consists mostly of small values with a somewhat random distribution.
     */
  strategy?: float,
}

/**
   * Compresses a chunk of data with `zlib` DEFLATE algorithm.
   * @param data The buffer of data to compress
   * @param options Compression options to use
   * @returns The output buffer with the compressed data
   */
external deflateSync: (~data: Uint8Array.t, ~options: zlibCompressionOptions=?) => Uint8Array.t =
  "Bun.deflateSync"
/**
   * Compresses a chunk of data with `zlib` GZIP algorithm.
   * @param data The buffer of data to compress
   * @param options Compression options to use
   * @returns The output buffer with the compressed data
   */
external gzipSync: (~data: Uint8Array.t, ~options: zlibCompressionOptions=?) => Uint8Array.t =
  "Bun.gzipSync"
/**
  * Decompresses a chunk of data with `zlib` INFLATE algorithm.
  * @param data The buffer of data to decompress
  * @returns The output buffer with the decompressed data
  */
external inflateSync: Uint8Array.t => Uint8Array.t = "Bun.inflateSync"
/**
   * Decompresses a chunk of data with `zlib` GUNZIP algorithm.
   * @param data The buffer of data to decompress
   * @returns The output buffer with the decompressed data
   */
external gunzipSync: Uint8Array.t => Uint8Array.t = "Bun.gunzipSync"

// TODO(when needed): Bundling, plugins

/**
   * Is the current global scope the main thread?
   */
external isMainThread: bool = "Bun.isMainThread"

// TODO(when needed): Sockets
// TODO: Spawn

module FileSystemRouter = {
  type t

  type style = | @as("nextjs") NextJs

  type options = {
    /**
       * The root directory containing the files to route
       *
       * There is no default value for this option.
       *
       * @example
       *   ```ts
       *   const router = new FileSystemRouter({
       *   dir:
       */
    dir: string,
    style: style,
    /** The base path to use when routing */
    assetPrefix?: string,
    origin?: string,
    /** Limit the pages to those with particular file extensions. */
    fileExtensions?: array<string>,
  }

  type matchedRouteKind =
    | @as("exact") Exact
    | @as("catch-all") CatchAll
    | @as("optional-catch-all") OptionalCatchAll
    | @as("dynamic") Dynamic

  type matchedRoute = {
    /**
     * A map of the parameters from the route
     *
     * @example
     * ```ts
     * const router = new FileSystemRouter({
     *   dir: "/path/to/files",
     *   style: "nextjs",
     * });
     * const {params} = router.match("/blog/2020/01/01/hello-world");
     * console.log(params.year); // "2020"
     * console.log(params.month); // "01"
     * console.log(params.day); // "01"
     * console.log(params.slug); // "hello-world"
     * ```
     */
    params: Dict.t<string>,
    filePath: string,
    pathname: string,
    query: Dict.t<string>,
    name: string,
    kind: matchedRouteKind,
    src: string,
  }

  /**
     * Create a new {@link FileSystemRouter}.
     *
     * @example
     * ```ts
     *const router = new FileSystemRouter({
     *   dir: process.cwd() + "/pages",
     *   style: "nextjs",
     *});
     *
     * const {params} = router.match("/blog/2020/01/01/hello-world");
     * console.log(params); // {year: "2020", month: "01", day: "01", slug: "hello-world"}
     * ```
     * @param options The options to use when creating the router
     * @param options.dir The root directory containing the files to route
     * @param options.style The style of router to use (only "nextjs" supported
     * for now)
     */
  @new
  external make: options => t = "Bun.FileSystemRouter"

  // todo: URL
  @return(nullable) @send external match: (t, string) => option<matchedRoute> = "match"

  @return(nullable) @send external matchRequest: (t, Request.t) => option<matchedRoute> = "match"

  @return(nullable) @send external matchResponse: (t, Response.t) => option<matchedRoute> = "match"

  @get external assetPrefix: t => string = "assetPrefix"
  @get external origin: t => string = "origin"
  @get external style: t => string = "style"
  @get external routes: t => Dict.t<string> = "routes"

  @send external reload: t => unit = "reload"
}

/**
   * The current version of Bun
   * @example
   * "0.2.0"
   */
external version: string = "Bun.version"

/**
   * The git sha at the time the currently-running version of Bun was compiled
   * @example
   * "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2"
   */
external revision: string = "Bun.revision"

/**
   * Find the index of a newline character in potentially ill-formed UTF-8 text.
   *
   * This is sort of like readline() except without the IO.
   */
external indexOfLine: (~buffer: ArrayBuffer.t, ~offset: int=?) => int = "Bun.indexOfLine"

/**
   * Find the index of a newline character in potentially ill-formed UTF-8 text.
   *
   * This is sort of like readline() except without the IO.
   */
external indexOfLineFromArrayBufferView: (~buffer: ArrayBufferView.t, ~offset: int=?) => int =
  "Bun.indexOfLine"

module Glob = {
  type t

  type globScanOptions = {
    /**
     * The root directory to start matching from. Defaults to `process.cwd()`
     */
    cwd?: string,
    /**
     * Allow patterns to match entries that begin with a period (`.`).
     *
     * @default false
     */
    dot?: bool,
    /**
     * Return the absolute path for entries.
     *
     * @default false
     */
    absolute?: bool,
    /**
     * Indicates whether to traverse descendants of symbolic link directories.
     *
     * @default false
     */
    followSymlinks?: bool,
    /**
     * Throw an error when symbolic link is broken
     *
     * @default false
     */
    throwErrorOnBrokenSymlink?: bool,
    /**
     * Return only files.
     *
     * @default true
     */
    onlyFiles?: bool,
  }

  @new external make: string => t = "Glob"

  /**
   * Scan a root directory recursively for files that match this glob pattern. Returns an async iterator.
   *
   * @throws {ENOTDIR} Given root cwd path must be a directory
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * const scannedFiles = await Array.fromAsync(glob.scan({ cwd: './src' }))
   * ```
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * for await (const path of glob.scan()) {
   *   // do something
   * }
   * ```
   */
  @send
  external scan: (t, ~options: globScanOptions=?) => AsyncIterator.t<string> = "scan"

  /**
   * Scan a root directory recursively for files that match this glob pattern. Returns an async iterator.
   *
   * @throws {ENOTDIR} Given root cwd path must be a directory
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * const scannedFiles = await Array.fromAsync(glob.scan({ cwd: './src' }))
   * ```
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * for await (const path of glob.scan()) {
   *   // do something
   * }
   * ```
   */
  @send
  external scanFromCwd: (t, string) => AsyncIterator.t<string> = "scan"

  /**
   * Synchronously scan a root directory recursively for files that match this glob pattern. Returns an iterator.
   *
   * @throws {ENOTDIR} Given root cwd path must be a directory
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * const scannedFiles = Array.from(glob.scan({ cwd: './src' }))
   * ```
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * for (const path of glob.scan()) {
   *   // do something
   * }
   * ```
   */
  @send
  external scanSync: (t, ~options: globScanOptions=?) => Iterator.t<string> = "scan"

  /**
   * Synchronously scan a root directory recursively for files that match this glob pattern. Returns an iterator.
   *
   * @throws {ENOTDIR} Given root cwd path must be a directory
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * const scannedFiles = Array.from(glob.scan({ cwd: './src' }))
   * ```
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * for (const path of glob.scan()) {
   *   // do something
   * }
   * ```
   */
  @send
  external scanFromCwdSync: (t, string) => Iterator.t<string> = "scan"

  /**
   * Match the glob against a string
   *
   * @example
   * ```js
   * const glob = new Glob("*.{ts,tsx}");
   * expect(glob.match('foo.ts')).toBeTrue();
   * ```
   */
  @send
  external match: (t, string) => bool = "match"
}
