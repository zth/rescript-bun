open Test

describe("shell", () => {
  testAsync("basic commands work", async () => {
    open Bun

    let res = await (sh`echo "HELLO"`)

    expect(res.stdout->Buffer.toString)->Expect.toBe("HELLO\n")
  })
})
