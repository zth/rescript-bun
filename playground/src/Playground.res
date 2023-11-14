let rewriter = HTMLRewriter.make()

let _ = rewriter->HTMLRewriter.on(
  "*",
  {
    element: element => {
      element.tagName = "span"
    },
  },
)

let transformedResponse =
  rewriter->HTMLRewriter.transform(
    Response.make("<html><head></head><body><div>hellO!</div></body></html>"),
  )

let html = await transformedResponse->Response.text
Console.log(html)
