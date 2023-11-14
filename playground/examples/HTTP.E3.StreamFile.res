// https://bun.sh/guides/http/stream-file

let path = Path.resolve([import.meta.dir, "test.txt"])
let file = Bun.file(path)
let resp = Response.makeFromFile(file)

resp
->Response.headers
->Headers.get("Content-Type")
->Console.log

let _server = Bun.serve({
  fetch: async (req, _server) => {
    req
    ->Request.url
    ->URL.make
    ->URL.pathname
    ->Bun.file
    ->Response.makeFromFile
  },
})
