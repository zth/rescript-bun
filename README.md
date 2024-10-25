# rescript-bun

_Check out the `2.x` branch for ReScript v12 support._

Use [Bun](https://bun.sh) with ReScript.

> **Currently alpha state software**. You're encouraged to start using it, but please report all issues. There will be both bindings missing and some bindings will probably be wrong/suboptimal. We're going to work through the API surface as we go. Report all issues you find!

## Getting started

**Template repo to get up and running quickly: https://github.com/zth/rescript-bun-starter**

You need to be on ReScript v11 `>=11.1.0` and Core `>=1.3.0`. This is designed for uncurried mode so you should use that as well (`"uncurried": true` in your bsconfig/`rescript.json`).

Install `rescript-bun` and `@rescript/core`:

```bash
npm i rescript-bun @rescript/core
```

Include them in your `rescript.json`:

```json
{
  "bs-dependencies": ["@rescript/core", "rescript-bun"]
}
```

`rescript-bun` is [namespaced](https://rescript-lang.org/docs/manual/latest/build-configuration#name-namespace), so you'll find all modules listed under the main module `RescriptBun`.

**You're strongly encouraged to open `RescriptBun` globally, to get the best possible developer experience.** You do that by adding this to your `rescript.json`:

```json
{
  "bsc-flags": [
    "-open RescriptCore",
    "-open RescriptBun",
    "-open RescriptBun.Globals"
  ]
}
```

> Notice `-open RescriptBun.Globals`. This will expose all Bun _globals_. This might be a matter of taste, but I recommend opening it to get the best experience.

This will make all of Bun available to you without needing to dip into the `RescriptBun` module explicitly.

## Credits

This lib copies [`rescript-nodejs`](https://github.com/TheSpyder/rescript-nodejs) for Bun's Node compatible bindings. Shout out to the maintainers of that project!

## Examples

Here's a few examples of how it looks. More examples (often inspired by `https://bun.sh/guides`) can be found in the `playground/examples` directory in this repo.

### Testing

To write tests using Bun's built in test runner, just `open Test` and you'll have everything available to you to write your tests:

```rescript
open Test

describe("Playing around with tests", () => {
  test("addition works", () => {
    expect(1 + 1)->Expect.toBe(2)
  })
})
```

This will make all of Bun's testing utilities available to you in the global scope.

### Setting up a simple server

Here's setting up a simple web server.

```rescript
let server = Bun.serve({
  fetch: async (request, _server) => {
    let userName =
      request
      ->Request.headers
      ->Headers.get("x-user-name")
      ->Option.getWithDefault("Unknown user")

    Response.make(`Hello ${userName}!`, ~options={status: 200})
  },
})

let port =
  server
  ->Bun.Server.port
  ->Int.toString

let hostName = server->Bun.Server.hostname

Console.log(`Server listening on http://${hostName}:${port}!`)
```

### Hashing and verifying a password

```rescript
let password = "super-secure-pa$$word"

let bcryptHash = await Bun.Password.hash(
  password,
  ~algorithm=BCryptAlgorithm({
    cost: 4, // number between 4-31
  }),
)

let isMatch = await Bun.Password.verify(password, ~hash)
```

### Using the file system router

```rescript
let router = Bun.FileSystemRouter.make({
  style: NextJs,
  dir: "./pages",
  origin: "https://mydomain.com",
  assetPrefix: "_next/static/",
})

let matches = router->Bun.FileSystemRouter.match("/")
```

### Using HTMLRewriter to rewrite HTML

```rescript
// Rewrite all <div> to <section>

let rewriter = HTMLRewriter.make()->HTMLRewriter.on(
  "*",
  {
    element: element => {
      if element.tagName === "div" {
        element.tagName = "section"
      }
    },
  },
)

let response = await fetch("https://bun.sh")
let transformedResponse = rewriter->HTMLRewriter.transform(response)

let html = await transformedResponse->Response.text

Console.log(html)
```

## Current project state

Currently, bindings exist for the most common things. There's still a good amount of bindings missing. Some bindings will be covered as we go along, while others won't be added.

### Missing bindings

#### Crucial

- [x] Globals
- [x] Bun
- [x] Tests
- [x] Fs
- [x] Stream (some stream utils already exist in Globals + Bun)
- [x] Path

#### Prio 2

- [x] AsyncHooks
- [x] Crypto
- [x] Buffer
- [x] Child_process (needs Stream?)
- [x] HTML Rewriter
- [x] Os
- [ ] Sqlite
- [x] Perf hooks
- [x] StringDecoder
- [x] Readline (needs Stream?)
- [x] WorkerThreads

#### Prio 3

- [ ] FFI
- [x] Util
- [ ] SupportsColors
- [x] Timers
- [x] Tls
- [x] Tty

#### Unclear if needed

- [x] Assert
- [ ] Diagnostics channel
- [x] Dns
- [ ] Domain
- [x] Events
- [ ] JSC
- [x] Module
- [x] Net
- [x] VM
- [ ] WS (already multiple websocket things present)
- [x] Zlib (bun has its own gzip?)
- [x] Http (Nodes built in HTTP, should use Bun's own, right?)

#### Definitively not needed

- URL (available in globals)
- Constants (deprecated)
- Querystring (deprecated)
- Punycode (deprecated)
- Console (Core has it)

## Other things to figure out

- How to reuse/contribute to [`rescript-webapi`](https://github.com/TheSpyder/rescript-webapi) instead of rolling our own bindings. I've intentionally not reused any other existing library because I wanted to start from scratch and follow ReScript v11 idioms as much as possible. But once all of this settles, we need to figure out and share the common denominator with `rescript-webapi` and other similar projects to this.

## Contributing

Contributions are very welcome. We're aiming to cover close to 100% of the Bun API surface, which is quite huge task. But, it's definitively possible and the initial large effort pays dividends over time.

If you do want to contribute, _please open an issue saying you're starting work on module X_. So we don't accidentally double work.

## Bindings style

_This will be fleshed out in a short while_.
