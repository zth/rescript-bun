module Statement = {
  type t

  /** Runs a query and returns an array of JSON objects for the results. */
  @send
  external all: (t, {..}) => array<JSON.t> = "all"

  /** Runs a query and returns raw JSON for the results. */
  @send
  external allJson: (t, {..}) => JSON.t = "all"

  /** Runs a query and returns raw JSON, using a dictionary for the parameters to make it easy to assemble parameters dynamically. */
  @send
  external allDictJson: (t, Dict.t<JSON.t>) => JSON.t = "all"

  /** Runs a query and returns a JSON object for the results. */
  @send
  external get: (t, {..}) => Nullable.t<JSON.t> = "get"

  /** Runs a query and returns a JSON object for the results, using a dictionary for the parameters to make it easy to assemble parameters dynamically. */
  @send
  external getDict: (t, Dict.t<JSON.t>) => Nullable.t<JSON.t> = "get"

  /** Runs a query, expecting no results. */
  @send
  external run: (t, {..}) => unit = "run"

  /** Runs a query and returns an iterator over the results as raw JSON. */
  @send
  external iterate: (t, {..}) => Iterator.t<JSON.t> = "iterate"

  /** Destroys the statement, freeing up resources. */
  @send
  external finalize: t => unit = "finalize"

  /** Returns the entire SQL query as a string. */
  @send
  external toString: t => string = "toString"
}

module Database = {
  type t

  type dbOptions = {readonly?: bool, create?: bool, strict?: bool}

  /** Creates a new database. */
  @module("bun:sqlite") @new
  external make: (string, ~options: dbOptions=?) => t = "Database"

  /**
   Creates a new in-memory database.

   ## Examples

   ```rescript
   let db = Database.makeInMemory()
   ```
   */
  @module("bun:sqlite") @new
  external makeInMemory: (@as(":memory:") _, ~options: dbOptions=?) => t = "Database"

  /**
   Executes a query.

   ## Examples

   ```rescript
   let users = switch db->Database.query("SELECT * FROM users WHERE age > :age")->Statement.all({"age": 90}) {
   | exception Exn.Error(e) => Error(#DatabaseFailed)
   | [] => Error(#NoUsersFound)
   | users => Ok(users->usersFromJson)
   }
   ```
   */
  @send
  external query: (t, string) => Statement.t = "query"

  /**
   Closes the database.

   ## Examples

   ```rescript
   let db = Database.makeInMemory()
   db->Database.close
   ```
   */
  @send
  external close: (t, ~throwOnError: bool=?) => unit = "close"

  @send external loadExtension: (t, string) => unit = "loadExtension"

  /** Serializes a database to a binary representation. */
  @send
  external serialize: (t, ~name: string=?) => ArrayBuffer.t = "serialize"
}
