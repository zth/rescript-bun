// https://bun.sh/docs/api/html-rewriter
let rewriter = HTMLRewriter.make()

let findInternalLinks = html => {
  let internalLinks = []

  let _ =
    rewriter
    ->HTMLRewriter.on(
      "*",
      {
        element: element => {
          switch (element.tagName, element.getAttribute("href")) {
          | ("a", Value(href)) if href->String.startsWith("/") => internalLinks->Array.push(href)
          | _ => ()
          }
        },
      },
    )
    ->HTMLRewriter.transform(Response.make(html))

  internalLinks
}

// Find all internal links on the Bun main site
let content = await fetch("https://bun.sh")
let html = await content->Response.text

let internalLinks = findInternalLinks(html)
Console.log(internalLinks)
