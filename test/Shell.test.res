open Test
open Globals

describe("shell", () => {
  testAsync("basic commands work", async () => {
    let res = await (sh`echo HELLO`)

    expect(res.stdout->Buffer.toString)->Expect.toBe("HELLO\n")
  })
})
