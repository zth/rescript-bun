module Types = {
  type content = string

  type contentOptions = {html?: bool}

  type onEndTagHandler

  type rec endTag = {
    name: string,
    before: (content, ~options: contentOptions=?) => endTag,
    after: (content, ~options: contentOptions=?) => endTag,
    remove: unit => endTag,
  }

  external onEndTagHandlerMakeSync: (endTag => unit) => onEndTagHandler = "%identity"
  external onEndTagHandlerMakeAsync: (endTag => promise<unit>) => onEndTagHandler = "%identity"

  type rec element = {
    mutable tagName: string,
    attributes: Iterator.t<array<string>>,
    removed: bool,
    /** Whether the element is explicitly self-closing, e.g. `<foo />` */
    selfClosing: bool,
    /**
     * Whether the element can have inner content. Returns `true` unless
     * - the element is an [HTML void element](https://html.spec.whatwg.org/multipage/syntax.html#void-elements)
     * - or it's self-closing in a foreign context (eg. in SVG, MathML).
     */
    canHaveContent: bool,
    namespaceURI: string,
    getAttribute: string => Null.t<string>,
    hasAttribute: string => bool,
    setAttribute: (string, string) => element,
    removeAttribute: string => element,
    before: (content, ~options: contentOptions=?) => element,
    after: (content, ~options: contentOptions=?) => element,
    prepend: (content, ~options: contentOptions=?) => element,
    append: (content, ~options: contentOptions=?) => element,
    replace: (content, ~options: contentOptions=?) => element,
    remove: unit => element,
    removeAndKeepContent: unit => element,
    setInnerContent: (content, ~options: contentOptions=?) => element,
    onEndTag: onEndTagHandler => unit,
  }

  type rec comment = {
    mutable text: string,
    removed: bool,
    before: (content, ~options: contentOptions=?) => comment,
    after: (content, ~options: contentOptions=?) => comment,
    replace: (content, ~options: contentOptions=?) => comment,
    remove: unit => comment,
  }
  type rec text = {
    text: string,
    lastInTextNode: bool,
    removed: bool,
    before: (content, ~options: contentOptions=?) => text,
    after: (content, ~options: contentOptions=?) => text,
    replace: (content, ~options: contentOptions=?) => text,
    remove: unit => text,
  }

  type doctype = {
    name: Null.t<string>,
    publicId: Null.t<string>,
    systemId: Null.t<string>,
  }

  type rec documentEnd = {append: (content, ~options: contentOptions=?) => documentEnd}

  @tag("kind")
  type syncOrAsync<'a> = Sync('a => unit) | Async('a => promise<unit>)
}

type htmlRewriterElementContentHandlers = {
  element?: Types.element => unit,
  comments?: Types.comment => unit,
  text?: Types.text => unit,
}

type htmlRewriterElementContentHandlersAsync = {
  element?: Types.element => promise<unit>,
  comments?: Types.comment => promise<unit>,
  text?: Types.text => promise<unit>,
}

type htmlRewriterDocumentContentHandlers = {
  doctype?: Types.doctype => unit,
  comments?: Types.comment => unit,
  text?: Types.text => unit,
  end?: Types.documentEnd => unit,
}

type htmlRewriterDocumentContentHandlersAsync = {
  doctype?: Types.doctype => promise<unit>,
  comments?: Types.comment => promise<unit>,
  text?: Types.text => promise<unit>,
  end?: Types.documentEnd => promise<unit>,
}

type t

/**
 * [HTMLRewriter](https://developers.cloudflare.com/workers/runtime-apis/html-rewriter?bun) is a fast API for transforming HTML.
 *
 * Bun leverages a native implementation powered by [lol-html](https://github.com/cloudflare/lol-html).
 *
 * HTMLRewriter can be used to transform HTML in a variety of ways, including:
 * * Rewriting URLs
 * * Adding meta tags
 * * Removing elements
 * * Adding elements to the head
 *
 * @example
 * ```ts
 * const rewriter = new HTMLRewriter().on('a[href]', {
 *   element(element: Element) {
 *     // Rewrite all the URLs to this youtube video
 *     element.setAttribute('href', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
 *   }
 * });
 * rewriter.transform(await fetch("https://remix.run"));
 * ```
 */
@new
external make: unit => t = "HTMLRewriter"

@send external on: (t, string, htmlRewriterElementContentHandlers) => t = "on"

/** Async version of `on`. */
@send
external onAsync: (t, string, htmlRewriterElementContentHandlersAsync) => t = "on"

@send external onDocument: (t, htmlRewriterDocumentContentHandlers) => t = "onDocument"

/** Async version of `onDocument`. */
@send
external onDocumentAsync: (t, htmlRewriterDocumentContentHandlersAsync) => t = "onDocument"

/**
 * @param input - The HTML to transform
 * @returns A new {@link Response} with the transformed HTML
 */
@send
external transform: (t, Globals.Response.t) => Globals.Response.t = "transform"
