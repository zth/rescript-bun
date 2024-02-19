open Test

let mockFunction = mock(() => ())

describe("mock", () => {
  beforeAll(() => {
    mockFunction()
  })

  test("mock function should have been called", () => {
    expect(mockFunction->Obj.magic)->Expect.toHaveBeenCalled
    mockFunction()
    expect(mockFunction->Obj.magic)->Expect.toHaveBeenCalledTimes(2.)
  })
})
