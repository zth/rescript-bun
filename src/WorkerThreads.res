open Globals

type messagePort

module TransferListItem = {
  type t

  external fromArrayBuffer: ArrayBuffer.t => t = "%identity"
  external fromMessagePort: messagePort => t = "%identity"
  external fromBlob: Blob.t => t = "%identity"
}

/**
   * Instances of the `worker.MessagePort` class represent one end of an
   * asynchronous, two-way communications channel. It can be used to transfer
   * structured data, memory regions and other `MessagePort`s between different `Worker` s.
   *
   * This implementation matches [browser `MessagePort`](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort) s.
   * @since v10.5.0
   */
module MessagePort = {
  // TODO: Extends EventEmitter
  type t = messagePort

  /**
     * Disables further sending of messages on either side of the connection.
     * This method can be called when no further communication will happen over this`MessagePort`.
     *
     * The `'close' event` is emitted on both `MessagePort` instances that
     * are part of the channel.
     * @since v10.5.0
     */
  @send
  external close: t => unit = "close"
  /**
     * Sends a JavaScript value to the receiving side of this channel.`value` is transferred in a way which is compatible with
     * the [HTML structured clone algorithm](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm).
     *
     * In particular, the significant differences to `JSON` are:
     *
     * * `value` may contain circular references.
     * * `value` may contain instances of builtin JS types such as `RegExp`s,`BigInt`s, `Map`s, `Set`s, etc.
     * * `value` may contain typed arrays, both using `ArrayBuffer`s
     * and `SharedArrayBuffer`s.
     * * `value` may contain [`WebAssembly.Module`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/Module) instances.
     * * `value` may not contain native (C++-backed) objects other than:
     *
     * ```js
     * const { MessageChannel } = require('worker_threads');
     * const { port1, port2 } = new MessageChannel();
     *
     * port1.on('message', (message) => console.log(message));
     *
     * const circularData = {};
     * circularData.foo = circularData;
     * // Prints: { foo: [Circular] }
     * port2.postMessage(circularData);
     * ```
     *
     * `transferList` may be a list of [`ArrayBuffer`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer), `MessagePort` and `FileHandle` objects.
     * After transferring, they are not usable on the sending side of the channel
     * anymore (even if they are not contained in `value`). Unlike with `child processes`, transferring handles such as network sockets is currently
     * not supported.
     *
     * If `value` contains [`SharedArrayBuffer`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) instances, those are accessible
     * from either thread. They cannot be listed in `transferList`.
     *
     * `value` may still contain `ArrayBuffer` instances that are not in`transferList`; in that case, the underlying memory is copied rather than moved.
     *
     * ```js
     * const { MessageChannel } = require('worker_threads');
     * const { port1, port2 } = new MessageChannel();
     *
     * port1.on('message', (message) => console.log(message));
     *
     * const uint8Array = new Uint8Array([ 1, 2, 3, 4 ]);
     * // This posts a copy of `uint8Array`:
     * port2.postMessage(uint8Array);
     * // This does not copy data, but renders `uint8Array` unusable:
     * port2.postMessage(uint8Array, [ uint8Array.buffer ]);
     *
     * // The memory for the `sharedUint8Array` is accessible from both the
     * // original and the copy received by `.on('message')`:
     * const sharedUint8Array = new Uint8Array(new SharedArrayBuffer(4));
     * port2.postMessage(sharedUint8Array);
     *
     * // This transfers a freshly created message port to the receiver.
     * // This can be used, for example, to create communication channels between
     * // multiple `Worker` threads that are children of the same parent thread.
     * const otherChannel = new MessageChannel();
     * port2.postMessage({ port: otherChannel.port1 }, [ otherChannel.port1 ]);
     * ```
     *
     * The message object is cloned immediately, and can be modified after
     * posting without having side effects.
     *
     * For more information on the serialization and deserialization mechanisms
     * behind this API, see the `serialization API of the v8 module`.
     * @since v10.5.0
     */
  @send
  external postMessage: ('any, ~transferList: array<TransferListItem.t>=?) => unit = "postMessage"

  /**
     * Opposite of `unref()`. Calling `ref()` on a previously `unref()`ed port does _not_ let the program exit if it's the only active handle left (the default
     * behavior). If the port is `ref()`ed, calling `ref()` again has no effect.
     *
     * If listeners are attached or removed using `.on('message')`, the port
     * is `ref()`ed and `unref()`ed automatically depending on whether
     * listeners for the event exist.
     * @since v10.5.0
     */
  @send
  external ref: t => unit = "ref"
  /**
     * Calling `unref()` on a port allows the thread to exit if this is the only
     * active handle in the event system. If the port is already `unref()`ed calling`unref()` again has no effect.
     *
     * If listeners are attached or removed using `.on('message')`, the port is`ref()`ed and `unref()`ed automatically depending on whether
     * listeners for the event exist.
     * @since v10.5.0
     */
  @send
  external unref: t => unit = "unref"
  /**
     * Starts receiving messages on this `MessagePort`. When using this port
     * as an event emitter, this is called automatically once `'message'`listeners are attached.
     *
     * This method exists for parity with the Web `MessagePort` API. In Node.js,
     * it is only useful for ignoring messages when no event listener is present.
     * Node.js also diverges in its handling of `.onmessage`. Setting it
     * automatically calls `.start()`, but unsetting it lets messages queue up
     * until a new handler is set or the port is discarded.
     * @since v10.5.0
     */
  @send
  external start: t => unit = "start"

  @send external addCloseListener: (t, @as("close") _, unit => unit) => t = "addListener"
  @send external addMessageListener: (t, @as("message") _, 'any => unit) => t = "addListener"
  @send
  external addMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t = "addListener"
  @send external addListener: (t, string, 'args => unit) => t = "addListener"
  @send external addSymbolListener: (t, Symbol.t, 'args => unit) => t = "addListener"

  @send external emitClose: (t, @as("close") _) => bool = "emit"
  @send external emitMessage: (t, @as("message") _, 'any) => bool = "emit"
  @send
  external emitMessageError: (t, @as("messageerror") _, Error.t) => bool = "emit"
  @send external emit: (t, string, 'any) => bool = "emit"
  @send external emitSymbol: (t, Symbol.t, 'any) => bool = "emit"

  @send external onClose: (t, @as("close") _, unit => unit) => t = "on"
  @send external onMessage: (t, @as("message") _, 'any => unit) => t = "on"
  @send
  external onMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "on"
  @send external on: (t, string, 'args => unit) => t = "on"
  @send external onSymbol: (t, Symbol.t, 'args => unit) => t = "on"

  @send external onceClose: (t, @as("close") _, unit => unit) => t = "once"
  @send external onceMessage: (t, @as("message") _, 'any => unit) => t = "once"
  @send
  external onceMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "once"
  @send external once: (t, string, 'args => unit) => t = "once"
  @send external onceSymbol: (t, Symbol.t, 'args => unit) => t = "once"

  @send external prependCloseListener: (t, @as("close") _, unit => unit) => t = "prependListener"
  @send
  external prependMessageListener: (t, @as("message") _, 'any => unit) => t = "prependListener"
  @send
  external prependMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "prependListener"
  @send external prependListener: (t, string, 'args => unit) => t = "prependListener"
  @send external prependSymbolListener: (t, Symbol.t, 'args => unit) => t = "prependListener"

  @send
  external prependOnceCloseListener: (t, @as("close") _, unit => unit) => t = "prependOnceListener"
  @send
  external prependOnceMessageListener: (t, @as("message") _, 'any => unit) => t =
    "prependOnceListener"
  @send
  external prependOnceMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "prependOnceListener"
  @send external prependOnceListener: (t, string, 'args => unit) => t = "prependOnceListener"
  @send
  external prependOnceSymbolListener: (t, Symbol.t, 'args => unit) => t = "prependOnceListener"

  @send external removeCloseListener: (t, @as("close") _, unit => unit) => t = "removeListener"
  @send
  external removeMessageListener: (t, @as("message") _, 'any => unit) => t = "removeListener"
  @send
  external removeMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "removeListener"
  @send external removeListener: (t, string, 'args => unit) => t = "removeListener"
  @send external removeSymbolListener: (t, Symbol.t, 'args => unit) => t = "removeListener"

  @send external offClose: (t, @as("close") _, unit => unit) => t = "off"
  @send external offMessage: (t, @as("message") _, 'any => unit) => t = "off"
  @send
  external offMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "off"
  @send external off: (t, string, 'args => unit) => t = "off"
  @send external offSymbol: (t, Symbol.t, 'args => unit) => t = "off"
}

type share_env

@module("node:worker_threads")
external share_env: share_env = "SHARE_ENV"

module WorkerEnv = {
  type t
  external fromShareEnv: share_env => t = "%identity"
  external fromDict: Dict.t<string> => t = "%identity"
}

type workerOptions<'data> = {
  /**
     * A string specifying an identifying name for the DedicatedWorkerGlobalScope representing the scope of
     * the worker, which is mainly useful for debugging purposes.
     */
  name?: string,
  /**
     * Use less memory, but make the worker slower.
     *
     * Internally, this sets the heap size configuration in JavaScriptCore to be
     * the small heap instead of the large heap.
     */
  smol?: bool,
  /**
     * When `true`, the worker will keep the parent thread alive until the worker is terminated or `unref`'d.
     * When `false`, the worker will not keep the parent thread alive.
     *
     * By default, this is `false`.
     */
  ref?: bool,
  /**
     * In Bun, this does nothing.
     */
  @as("type")
  type_?: string,
  /**
     * List of arguments which would be stringified and appended to
     * `Bun.argv` / `process.argv` in the worker. This is mostly similar to the `data`
     * but the values will be available on the global `Bun.argv` as if they
     * were passed as CLI options to the script.
     */
  /** If `true` and the first argument is a string, interpret the first argument to the constructor as a script that is executed once the worker is online. */
  /**
     * If set, specifies the initial value of process.env inside the Worker thread. As a special value, worker.SHARE_ENV may be used to specify that the parent thread and the child thread should share their environment variables; in that case, changes to one thread's process.env object affect the other thread as well. Default: process.env.
     */
  // argv?: any[] | undefined;

  // eval?: boolean | undefined;

  env?: WorkerEnv.t,
  /**
     * In Bun, this does nothing.
     */
  credentials?: string,
  /**
     * @default true
     */
  // trackUnmanagedFds?: boolean;

  workerData?: 'data,
  /**
     * An array of objects that are transferred rather than cloned when being passed between threads.
     */
  transferList?: array<TransferListItem.t>,

  // resourceLimits?: import("worker_threads").ResourceLimits;
  // stdin?: boolean | undefined;
  // stdout?: boolean | undefined;
  // stderr?: boolean | undefined;
  // execArgv?: string[] | undefined;
}

type resourceLimits = {
  /**
     * The maximum size of a heap space for recently created objects.
     */
  maxYoungGenerationSizeMb?: float,
  /**
     * The maximum size of the main heap in MB.
     */
  maxOldGenerationSizeMb?: float,
  /**
     * The size of a pre-allocated memory range used for generated code.
     */
  codeRangeSizeMb?: float,
  /**
     * The default maximum stack size for the thread. Small values may lead to unusable Worker instances.
     * @default 4
     */
  stackSizeMb?: float,
}

type workerPerformance = {eventLoopUtilization: PerfHooks.eventLoopUtilityFunction}

/**
   * The `Worker` class represents an independent JavaScript execution thread.
   * Most Node.js APIs are available inside of it.
   *
   * Notable differences inside a Worker environment are:
   *
   * * The `process.stdin`, `process.stdout` and `process.stderr` may be redirected by the parent thread.
   * * The `require('worker_threads').isMainThread` property is set to `false`.
   * * The `require('worker_threads').parentPort` message port is available.
   * * `process.exit()` does not stop the whole program, just the single thread,
   * and `process.abort()` is not available.
   * * `process.chdir()` and `process` methods that set group or user ids
   * are not available.
   * * `process.env` is a copy of the parent thread's environment variables,
   * unless otherwise specified. Changes to one copy are not visible in other
   * threads, and are not visible to native add-ons (unless `worker.SHARE_ENV` is passed as the `env` option to the `Worker` constructor).
   * * `process.title` cannot be modified.
   * * Signals are not delivered through `process.on('...')`.
   * * Execution may stop at any point as a result of `worker.terminate()` being invoked.
   * * IPC channels from parent processes are not accessible.
   * * The `trace_events` module is not supported.
   * * Native add-ons can only be loaded from multiple threads if they fulfill `certain conditions`.
   *
   * Creating `Worker` instances inside of other `Worker`s is possible.
   *
   * Like [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) and the `cluster module`, two-way communication can be
   * achieved through inter-thread message passing. Internally, a `Worker` has a
   * built-in pair of `MessagePort` s that are already associated with each other
   * when the `Worker` is created. While the `MessagePort` object on the parent side
   * is not directly exposed, its functionalities are exposed through `worker.postMessage()` and the `worker.on('message')` event
   * on the `Worker` object for the parent thread.
   *
   * To create custom messaging channels (which is encouraged over using the default
   * global channel because it facilitates separation of concerns), users can create
   * a `MessageChannel` object on either thread and pass one of the`MessagePort`s on that `MessageChannel` to the other thread through a
   * pre-existing channel, such as the global one.
   *
   * See `port.postMessage()` for more information on how messages are passed,
   * and what kind of JavaScript values can be successfully transported through
   * the thread barrier.
   *
   * ```js
   * const assert = require('assert');
   * const {
   *   Worker, MessageChannel, MessagePort, isMainThread, parentPort
   * } = require('worker_threads');
   * if (isMainThread) {
   *   const worker = new Worker(__filename);
   *   const subChannel = new MessageChannel();
   *   worker.postMessage({ hereIsYourPort: subChannel.port1 }, [subChannel.port1]);
   *   subChannel.port2.on('message', (value) => {
   *     console.log('received:', value);
   *   });
   * } else {
   *   parentPort.once('message', (value) => {
   *     assert(value.hereIsYourPort instanceof MessagePort);
   *     value.hereIsYourPort.postMessage('the worker is sending this');
   *     value.hereIsYourPort.close();
   *   });
   * }
   * ```
   * @since v10.5.0
   */
module Worker = {
  open Stream
  type t

  /**
     * If `stdin: true` was passed to the `Worker` constructor, this is a
     * writable stream. The data written to this stream will be made available in
     * the worker thread as `process.stdin`.
     * @since v10.5.0
     */
  @get
  external stdin: t => Null.t<Writable.t> = "stdin"
  /**
     * This is a readable stream which contains data written to `process.stdout` inside the worker thread. If `stdout: true` was not passed to the `Worker` constructor, then data is piped to the
     * parent thread's `process.stdout` stream.
     * @since v10.5.0
     */
  @get
  external stdout: t => Readable.t = "stdout"
  /**
     * This is a readable stream which contains data written to `process.stderr` inside the worker thread. If `stderr: true` was not passed to the `Worker` constructor, then data is piped to the
     * parent thread's `process.stderr` stream.
     * @since v10.5.0
     */
  @get
  external stderr: t => Readable.t = "stderr"
  /**
     * An integer identifier for the referenced thread. Inside the worker thread,
     * it is available as `require('node:worker_threads').threadId`.
     * This value is unique for each `Worker` instance inside a single process.
     * @since v10.5.0
     */
  @get
  external threadId: t => float = "threadId"
  /**
     * Provides the set of JS engine resource constraints for this Worker thread.
     * If the `resourceLimits` option was passed to the `Worker` constructor,
     * this matches its values.
     *
     * If the worker has stopped, the return value is an empty object.
     * @since v13.2.0, v12.16.0
     */
  @get
  external resourceLimits: t => option<resourceLimits> = "resourceLimits"

  /**
     * An object that can be used to query performance information from a worker
     * instance. Similar to `perf_hooks.performance`.
     * @since v15.1.0, v14.17.0, v12.22.0
     */
  @get
  external performance: t => workerPerformance = "performance"

  /**
     * @param filename  The path to the Worker’s main script or module.
     *                  Must be either an absolute path or a relative path (i.e. relative to the current working directory) starting with ./ or ../,
     *                  or a WHATWG URL object using file: protocol. If options.eval is true, this is a string containing JavaScript code rather than a path.
     */
  @module("worker_threads")
  @new
  external make: (string, ~options: workerOptions<'data>=?) => t = "Worker"

  /**
     * @param filename  The path to the Worker’s main script or module.
     *                  Must be either an absolute path or a relative path (i.e. relative to the current working directory) starting with ./ or ../,
     *                  or a WHATWG URL object using file: protocol. If options.eval is true, this is a string containing JavaScript code rather than a path.
     */
  @module("worker_threads")
  @new
  external makeFromURL: (URL.t, ~options: workerOptions<'data>=?) => t = "Worker"

  /**
     * Send a message to the worker that is received via `require('node:worker_threads').parentPort.on('message')`.
     * See `port.postMessage()` for more details.
     * @since v10.5.0
     */
  @send
  external postMessage: (t, 'any, ~transferList: array<TransferListItem.t>=?) => unit =
    "postMessage"
  /**
     * Opposite of `unref()`, calling `ref()` on a previously `unref()`ed worker does _not_ let the program exit if it's the only active handle left (the default
     * behavior). If the worker is `ref()`ed, calling `ref()` again has
     * no effect.
     * @since v10.5.0
     */
  @get
  external ref: unit => unit = "ref"
  /**
     * Calling `unref()` on a worker allows the thread to exit if this is the only
     * active handle in the event system. If the worker is already `unref()`ed calling`unref()` again has no effect.
     * @since v10.5.0
     */
  @get
  external unref: unit => unit = "unref"
  /**
     * Stop all JavaScript execution in the worker thread as soon as possible.
     * Returns a Promise for the exit code that is fulfilled when the `'exit' event` is emitted.
     * @since v10.5.0
     */
  @send
  external terminate: unit => promise<float> = "terminate"
  /**
     * Returns a readable stream for a V8 snapshot of the current state of the Worker.
     * See `v8.getHeapSnapshot()` for more details.
     *
     * If the Worker thread is no longer running, which may occur before the `'exit' event` is emitted, the returned `Promise` is rejected
     * immediately with an `ERR_WORKER_NOT_RUNNING` error.
     * @since v13.9.0, v12.17.0
     * @return A promise for a Readable Stream containing a V8 heap snapshot
     */
  @send
  external getHeapSnapshot: unit => promise<Readable.t> = "getHeapSnapshot"

  @send external addErrorListener: (t, @as("error") _, Error.t => unit) => t = "addListener"
  @send external addExitListener: (t, @as("exit") _, float => unit) => t = "addListener"
  @send
  external addMessageListener: (t, @as("message") _, 'any => unit) => t = "addListener"
  external addMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t = "addListener"
  @send
  external addOnlineListener: (t, @as("online") _, unit => unit) => t = "addListener"
  @send external addListener: (t, string, 'args => unit) => t = "addListener"
  @send external addSymbolListener: (t, Symbol.t, 'args => unit) => t = "addListener"

  @send external emitError: (t, @as("error") _, Error.t => unit) => t = "emit"
  @send external emitExit: (t, @as("exit") _, float => unit) => t = "emit"
  @send
  external emitMessage: (t, @as("message") _, 'any => unit) => t = "emit"
  external emitMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "emit"
  @send
  external emitOnline: (t, @as("online") _, unit => unit) => t = "emit"
  @send external emit: (t, string, 'args => unit) => t = "emit"
  @send external emitSymbol: (t, Symbol.t, 'args => unit) => t = "emit"

  @send external onError: (t, @as("error") _, Error.t => unit) => t = "on"
  @send external onExit: (t, @as("exit") _, float => unit) => t = "on"
  @send
  external onMessage: (t, @as("message") _, 'any => unit) => t = "on"
  external onMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "on"
  @send
  external onOnline: (t, @as("online") _, unit => unit) => t = "on"
  @send external on: (t, string, 'args => unit) => t = "on"
  @send external onSymbol: (t, Symbol.t, 'args => unit) => t = "on"

  @send external onceError: (t, @as("error") _, Error.t => unit) => t = "once"
  @send external onceExit: (t, @as("exit") _, float => unit) => t = "once"
  @send
  external onceMessage: (t, @as("message") _, 'any => unit) => t = "once"
  external onceMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "once"
  @send
  external onceOnline: (t, @as("online") _, unit => unit) => t = "once"
  @send external once: (t, string, 'args => unit) => t = "once"
  @send external onceSymbol: (t, Symbol.t, 'args => unit) => t = "once"

  @send external prependErrorListener: (t, @as("error") _, Error.t => unit) => t = "prependListener"
  @send external prependExitListener: (t, @as("exit") _, float => unit) => t = "prependListener"
  @send
  external prependMessageListener: (t, @as("message") _, 'any => unit) => t = "prependListener"
  external prependMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "prependListener"
  @send
  external prependOnlineListener: (t, @as("online") _, unit => unit) => t = "prependListener"
  @send external prependListener: (t, string, 'args => unit) => t = "prependListener"
  @send external prependSymbolListener: (t, Symbol.t, 'args => unit) => t = "prependListener"

  @send
  external prependOnceErrorListener: (t, @as("error") _, Error.t => unit) => t =
    "prependOnceListener"
  @send
  external prependOnceExitListener: (t, @as("exit") _, float => unit) => t = "prependOnceListener"
  @send
  external prependOnceMessageListener: (t, @as("message") _, 'any => unit) => t =
    "prependOnceListener"
  external prependOnceMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "prependOnceListener"
  @send
  external prependOnceOnlineListener: (t, @as("online") _, unit => unit) => t =
    "prependOnceListener"
  @send external prependOnceListener: (t, string, 'args => unit) => t = "prependOnceListener"
  @send
  external prependOnceSymbolListener: (t, Symbol.t, 'args => unit) => t = "prependOnceListener"

  @send
  external removeErrorListener: (t, @as("error") _, Error.t => unit) => t = "removeListener"
  @send
  external removeExitListener: (t, @as("exit") _, float => unit) => t = "removeListener"
  @send
  external removeMessageListener: (t, @as("message") _, 'any => unit) => t = "removeListener"
  external removeMessageErrorListener: (t, @as("messageerror") _, Error.t => unit) => t =
    "removeListener"
  @send
  external removeOnlineListener: (t, @as("online") _, unit => unit) => t = "removeListener"
  @send external removeListener: (t, string, 'args => unit) => t = "removeListener"
  @send
  external removeSymbolListener: (t, Symbol.t, 'args => unit) => t = "removeListener"

  @send external offError: (t, @as("error") _, Error.t => unit) => t = "off"
  @send external offExit: (t, @as("exit") _, float => unit) => t = "off"
  @send
  external offMessage: (t, @as("message") _, 'any => unit) => t = "off"
  external offMessageError: (t, @as("messageerror") _, Error.t => unit) => t = "off"
  @send
  external offOnline: (t, @as("offline") _, unit => unit) => t = "off"
  @send external off: (t, string, 'args => unit) => t = "off"
  @send external offSymbol: (t, Symbol.t, 'args => unit) => t = "off"
}

type broadcastChannelEventMap = {
  message: MessageEvent.t,
  messageerror: MessageEvent.t,
}

/** [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel) */
module BroadcastChannel = {
  type t

  /**
     * Returns the channel name (as passed to the constructor).
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel/name)
     */
  @get
  external name: t => string = "name"
  /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel/message_event) */
  /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel/messageerror_event) */
  /**
     * Closes the BroadcastChannel object, opening it up to garbage collection.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel/close)
     */
  @send
  external // Use addEventListener instead onmessage: ((this: BroadcastChannel, ev: MessageEvent) => any) | null;

  // Use addEventListener instead onmessageerror: ((this: BroadcastChannel, ev: MessageEvent) => any) | null;

  close: t => unit = "close"
  /**
     * Sends the given message to other BroadcastChannel objects set up for this channel. Messages can be structured objects, e.g. nested objects and arrays.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/BroadcastChannel/postMessage)
     */
  @send
  external postMessage: (t, 'any) => unit = "postMessage"

  @send
  external addMessageEventListener: (
    t,
    @as("message") _,
    (t, MessageEvent.t) => 'any,
    ~options: EventTarget.addEventListenerOptionsOpt=?,
  ) => unit = "addEventListener"
  @send
  external addMessageErrorEventListener: (
    t,
    @as("messageerror") _,
    (t, MessageEvent.t) => 'any,
    ~options: EventTarget.addEventListenerOptionsOpt=?,
  ) => unit = "addEventListener"

  @send
  external removeMessageEventListener: (
    t,
    @as("message") _,
    (t, MessageEvent.t) => 'any,
    ~options: EventTarget.removeEventListenerOptionsOpt=?,
  ) => unit = "removeEventListener"
  @send
  external removeMessageErrorEventListener: (
    t,
    @as("messageerror") _,
    (t, MessageEvent.t) => 'any,
    ~options: EventTarget.removeEventListenerOptionsOpt=?,
  ) => unit = "removeEventListener"

  /**
     * Keep the process alive until the BroadcastChannel is closed or `unref`'d.
     * BroadcastChannel is `ref`'d by default.
     */
  @send
  external ref: t => unit = "ref"
  /**
     * Undo a previous `ref()`
     */
  @send
  external unref: t => unit = "unref"

  @module("worker_threads") external make: string => t = "BroadcastChannel"
}

@module("worker_threads")
external markAsUntransferable: 'obj => unit = "markAsUntransferable"

/**
   * Transfer a `MessagePort` to a different `vm` Context. The original `port`object is rendered unusable, and the returned `MessagePort` instance
   * takes its place.
   *
   * The returned `MessagePort` is an object in the target context and
   * inherits from its global `Object` class. Objects passed to the [`port.onmessage()`](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/onmessage) listener are also created in the
   * target context
   * and inherit from its global `Object` class.
   *
   * However, the created `MessagePort` no longer inherits from [`EventTarget`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget), and only
   * [`port.onmessage()`](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/onmessage) can be used to receive
   * events using it.
   * @since v11.13.0
   * @param port The message port to transfer.
   * @param contextifiedSandbox A `contextified` object as returned by the `vm.createContext()` method.
   */
@module("worker_threads")
external moveMessagePortToContext: (MessagePort.t, VM.context) => MessagePort.t =
  "moveMessagePortToContext"

type receivedMessage<'t> = {message: 't}
/**
   * Receive a single message from a given `MessagePort`. If no message is available,`undefined` is returned, otherwise an object with a single `message` property
   * that contains the message payload, corresponding to the oldest message in the`MessagePort`’s queue.
   *
   * ```js
   * const { MessageChannel, receiveMessageOnPort } = require('worker_threads');
   * const { port1, port2 } = new MessageChannel();
   * port1.postMessage({ hello: 'world' });
   *
   * console.log(receiveMessageOnPort(port2));
   * // Prints: { message: { hello: 'world' } }
   * console.log(receiveMessageOnPort(port2));
   * // Prints: undefined
   * ```
   *
   * When this function is used, no `'message'` event is emitted and the`onmessage` listener is not invoked.
   * @since v12.3.0
   */
@module("worker_threads")
external receiveMessageOnPort: MessagePort.t => option<receivedMessage<'t>> = "receiveMessageOnPort"

@unboxed
type serializable = String(string) | Object(Dict.t<string>) | Number(float) | Boolean(bool) // TODO: Add bigint

/**
   * Within a worker thread, `worker.getEnvironmentData()` returns a clone
   * of data passed to the spawning thread's `worker.setEnvironmentData()`.
   * Every new `Worker` receives its own copy of the environment data
   * automatically.
   *
   * ```js
   * const {
   *   Worker,
   *   isMainThread,
   *   setEnvironmentData,
   *   getEnvironmentData,
   * } = require('worker_threads');
   *
   * if (isMainThread) {
   *   setEnvironmentData('Hello', 'World!');
   *   const worker = new Worker(__filename);
   * } else {
   *   console.log(getEnvironmentData('Hello'));  // Prints 'World!'.
   * }
   * ```
   * @since v15.12.0, v14.18.0
   * @param key Any arbitrary, cloneable JavaScript value that can be used as a {Map} key.
   */
@module("worker_threads")
external getEnvironmentData: serializable => serializable = "getEnvironmentData"

/**
   * The `worker.setEnvironmentData()` API sets the content of`worker.getEnvironmentData()` in the current thread and all new `Worker`instances spawned from the current context.
   * @since v15.12.0, v14.18.0
   * @param key Any arbitrary, cloneable JavaScript value that can be used as a {Map} key.
   * @param value Any arbitrary, cloneable JavaScript value that will be cloned and passed automatically to all new `Worker` instances. If `value` is passed as `undefined`, any previously set value
   * for the `key` will be deleted.
   */
@module("worker_threads")
external setEnvironmentData: (serializable, serializable) => unit = "setEnvironmentData"

/**
   * This Channel Messaging API interface allows us to create a new message channel and send data through it via its two MessagePort properties.
   *
   * [MDN Reference](https://developer.mozilla.org/docs/Web/API/MessageChannel)
   */
module MessageChannel = {
  type t

  /**
     * Returns the first MessagePort object.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/MessageChannel/port1)
     */
  @get
  external port1: t => MessagePort.t = "port1"
  /**
     * Returns the second MessagePort object.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/MessageChannel/port2)
     */
  @get
  external port2: t => MessagePort.t = "port2"

  @new @module("worker_threads") external make: unit => t = "MessageChannel"
}
