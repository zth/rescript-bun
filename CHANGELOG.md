# main

## 2.0.2

### Patch Changes

- f118bba: ReScript v12.

## 2.0.1

### Patch Changes

- e9087b7: Move to ReScript v12.

## 0.6.2

### Patch Changes

- 30f25fb: SQL API Bindings

## 0.6.1

### Patch Changes

- 49bf132: Cookie API bindings

## 0.6.0

### Minor Changes

- c6b9a03: Add bindings to `routes` in `Bun.serve`.
- c6b9a03: Add basic SQLite bindings in `BunSqlite`.

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
