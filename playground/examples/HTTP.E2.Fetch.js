// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Core__Option from "@rescript/core/src/Core__Option.js";

var response = await fetch("https://bun.sh");

var html = await response.text();

console.log(html);

var response$1 = await fetch("https://bun.sh/api", {
      body: Core__Option.getOr(JSON.stringify({
                message: "Hello from Bun!"
              }), "-"),
      headers: [[
          "Content-Type",
          "application/json"
        ]],
      method: "POST"
    });

var body = await response$1.json();

console.log(body);

export {
  html ,
  response$1 as response,
  body ,
}
/* response Not a pure module */
