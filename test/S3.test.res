open Test

describe("s3 presence", () => {
  test("S3Client constructor and default instance available", () => {
    let _bucket = Bun.S3.S3Client.make({})
    // no throw means basic bindings are present
    expect(true)->Expect.toBeTrue
  })
})
