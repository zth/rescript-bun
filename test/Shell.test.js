// Generated by ReScript, PLEASE EDIT WITH CARE

import * as $$Bun from "bun";
import * as Buntest from "bun:test";

Buntest.describe("shell", (function () {
        Buntest.test("basic commands work", (async function () {
                var res = await $$Bun.$`echo HELLO`;
                Buntest.expect(res.stdout.toString()).toBe("HELLO\n");
              }));
      }));

export {
  
}
/*  Not a pure module */
