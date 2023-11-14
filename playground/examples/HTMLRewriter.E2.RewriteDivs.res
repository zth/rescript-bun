// https://bun.sh/docs/api/html-rewriter
// Rewrite all <div> to <section>

let rewriter = HTMLRewriter.make()->HTMLRewriter.on(
  "*",
  {
    element: element => {
      if element.tagName === "div" {
        element.tagName = "section"
      }
    },
  },
)

let response = await fetch("https://bun.sh")
let transformedResponse = rewriter->HTMLRewriter.transform(response)

let html = await transformedResponse->Response.text

Console.log(html)
