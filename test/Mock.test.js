// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Buntest from "bun:test";

var mockFunction = Buntest.mock(function () {
      
    });

Buntest.describe("mock", (function () {
        Buntest.beforeAll(function () {
              mockFunction();
            });
        Buntest.test("mock function should have been called", (function () {
                Buntest.expect(mockFunction).toHaveBeenCalled();
                mockFunction();
                Buntest.expect(mockFunction).toHaveBeenCalledTimes(2);
              }), undefined);
      }));

export {
  mockFunction ,
}
/* mockFunction Not a pure module */