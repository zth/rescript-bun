// With PostgreSQL
let mysql = SQL.make("mysql://user:pass@localhost:3306/mydb")
let mysqlResults = await mysql->SQL.query`
  SELECT * FROM users 
  WHERE active = ${Boolean(true)}
`

// With SQLite
let sqlite = SQL.make("sqlite://myapp.db")
let sqliteResults = await sqlite->SQL.query`
  SELECT * FROM users 
  WHERE active = ${Number(1.0)}
`
