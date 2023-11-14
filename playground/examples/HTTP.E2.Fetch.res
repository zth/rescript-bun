// https://bun.sh/guides/http/fetch
let response = await fetch("https://bun.sh")
let html = await response->Response.text
Console.log(html)

let response = await fetch(
  "https://bun.sh/api",
  ~init={
    method: "POST",
    body: Value(
      JSON.stringifyAny({"message": "Hello from Bun!"})
      ->Option.getWithDefault("-")
      ->BodyInit.makeFromString,
    ),
    headers: FromArray([("Content-Type", "application/json")]),
  },
)

let body = await response->Response.json
Console.log(body)
