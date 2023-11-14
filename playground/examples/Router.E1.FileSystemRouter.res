// https://bun.sh/docs/api/file-system-router
let router = Bun.FileSystemRouter.make({
  style: NextJs,
  dir: "./pages",
  origin: "https://mydomain.com",
  assetPrefix: "_next/static/",
})

let matches = router->Bun.FileSystemRouter.match("/")

Console.log2(router, matches)
