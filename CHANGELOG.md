# main

A note about versions:

- `2.x.x` is for ReScript v12 and above.
- `0.x.x` is for ReScript v11 and below.

# 2.0.0-alpha.1

`rescript-bun` is now compatible with ReScript v12.

- Remove `@rescript/core` since it now ships with the compiler.
- Remove `BigInt` since it now ships with the compiler.

# 0.5.0

- Add bindings for `Response.json()`. https://github.com/zth/rescript-bun/pull/5
- Return JSON data with `Response.makeWithJson`
- Return any data type with `Response.makeWithJsonUnsafe`
- Upgrade to ReScript `>=11.1.0` and Core `>=1.3.0`.
- Fix issue with bigint type.

# 0.4.1

- Fix `package-lock.json` issue.

# 0.4.0

- Add bindings to Bun's shell `$`. https://github.com/zth/rescript-bun/pull/4

# 0.3.1

- Fix `Bun.scanSync` APIs.

# 0.3.0

- Integrate Node bindings from [`rescript-nodejs`](https://github.com/TheSpyder/rescript-nodejs).
- Bind `Transpile` and `Build`.

# 0.2.1

- Fix `Glob`.

# 0.2.0

- Fix `Bun.write` bindings.
- Fix `TextDecoder.decode` binding.
- Add bindings to create new `Request`.
- Add bindings to `Glob`.
