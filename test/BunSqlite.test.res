open Test

describe("BunSqlite", () => {
  test("basic commands work", () => {
    open BunSqlite
    let db = Database.makeInMemory()

    let resOne = db->Database.query("SELECT 1")->Statement.all
    expect(resOne)->Expect.toEqual([
      JSON.Object(
        dict{
          "1": JSON.Number((1 :> float)),
        },
      ),
    ])

    db
    ->Database.query("
CREATE TABLE IF NOT EXISTS pokemon (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);
")
    ->Statement.run
    ->ignore

    let insertResult =
      db
      ->Database.query("INSERT INTO pokemon (name) VALUES (@name)")
      ->Statement.run(
        ~params={
          "@name": "Pikachu",
        },
      )

    expect(insertResult.lastInsertRowid)->Expect.toBe(1)
    expect(insertResult.changes)->Expect.toBe(1)

    db
    ->Database.query("INSERT INTO pokemon (name) VALUES (@name)")
    ->Statement.run(
      ~params={
        "@name": "Raichu",
      },
    )
    ->ignore

    let allPokemons = db->Database.query("SELECT * FROM pokemon ORDER BY id")->Statement.all
    expect(allPokemons)->Expect.toEqual([
      JSON.Object(
        dict{
          "id": JSON.Number((1 :> float)),
          "name": JSON.String("Pikachu"),
        },
      ),
      JSON.Object(
        dict{
          "id": JSON.Number((2 :> float)),
          "name": JSON.String("Raichu"),
        },
      ),
    ])

    db->Database.close
  })
})
