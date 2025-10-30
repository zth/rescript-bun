open Test

describe("csrf", () => {
  test("generate + verify with secret", () => {
    let secret = "test-secret"
    let token = Bun.CSRF.generateWithSecret(secret)
    Bun.CSRF.verifyWithOptions(token, {secret: secret})
    ->expect
    ->Expect.toBeTrue
  })

  test("verify fails with wrong secret", () => {
    let token = Bun.CSRF.generateWithSecret("correct-secret")
    Bun.CSRF.verifyWithOptions(token, {secret: "wrong-secret"})
    ->expect
    ->Expect.toBeFalse
  })

  test("generate with options (encoding + expires)", () => {
    let secret = "opts-secret"
    let token = Bun.CSRF.generateWithSecretOptions(secret, {encoding: Base64Url, expiresIn: 1000.0})
    Bun.CSRF.verifyWithOptions(token, {secret, encoding: Base64Url})
    ->expect
    ->Expect.toBeTrue
  })
})
