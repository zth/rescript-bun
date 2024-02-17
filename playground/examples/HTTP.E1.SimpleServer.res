// https://bun.sh/guides/http/simple

let server = Bun.serve({
  port: 3000,
  fetch: async (request, _server) => {
    let url = request->Globals.Request.url->URL.make

    switch url->Globals.URL.pathname {
    | "/" => Response.makeWithJsonUnsafe({"test": 1})
    | _ => Response.make("404!")
    }
  },
})

Console.log(`Listening on localhost: ${server->Bun.Server.port->Int.toString}`)

// https://bun.sh/guides/http/tls
let tlsServer = Bun.serve({
  fetch: async (_request, _server) => Response.make("Welcome to Bun!"),
  tls: {
    cert: [Bun.file("cert.pem")],
    key: [Bun.file("key.pem")],
    ca: [Bun.file("ca1.pem"), Bun.file("ca2.pem")],
  },
})
