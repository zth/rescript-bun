let db = SQL.fromOptions({filename:":memory:", adapter:"sqlite"})

(await db->SQL.query`
  CREATE TABLE users (
      name TEXT NOT NULL,
      email TEXT PRIMARY KEY
  );
`)->ignore

let insertUser = async (name, email) => await db->SQL.query`
  INSERT INTO users (name, email) 
  VALUES (${String(name)}, ${String(email)})
  RETURNING *
`

let userData = {
  "name": "Alice",
  "email": "alice@example.com",
}

let newUser = await db->SQL.query`
  INSERT INTO users ${Query(db->SQL.object(userData, ["name", "email"]))}
  RETURNING *
`

Console.log(newUser)

(await insertUser("Bob", "bob@email.com"))->ignore

switch await db->SQL.query`SELECT * FROM users` {
| Array(users) => Console.log(users)
| _ => ()
}
