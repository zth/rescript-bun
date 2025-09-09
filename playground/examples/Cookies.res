let cookies = CookieMap.make()

let cookies1 = CookieMap.fromString("theme=dark; foo=bar")

let cookies2 = CookieMap.fromDictionary(Dict.fromArray([
  ("session", "abc123"),
  ("theme", "dark")
]))

let cookies3 = CookieMap.fromArray([
  ("session", "abc123"),
  ("theme", "dark")
])

let theme1 = cookies1->CookieMap.get("theme")->Null.getOr("light")
let theme2 = cookies2->CookieMap.get("theme")->Null.getOr("light")
let theme3 = cookies3->CookieMap.get("theme")->Null.getOr("light")
Console.log3(theme1, theme2, theme3)
