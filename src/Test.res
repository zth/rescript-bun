open Types
// TODO: mocking etc

/**
   * Create mocks with the `mock` function.
   *
   * ```ts
   * import { test, expect, mock } from "bun:test";
   * const random = mock(() => Math.random());
   *
   * test("random", async () => {
   * const val = random();
   * expect(val).toBeGreaterThan(0);
   * expect(random).toHaveBeenCalled();
   * expect(random).toHaveBeenCalledTimes(1);
   * });
   * ```
   */
@module("bun:test")
external mock: (unit => 'value) => unit => 'value = "mock"

/**
   * Control the system time used by:
   * - `Date.now()`
   * - `new Date()`
   * - `Intl.DateTimeFormat().format()`
   *
   * In the future, we may add support for more functions, but we haven't done that yet.
   *
   * @param now The time to set the system time to. If not provided, the system time will be reset.
   * @returns `this`
   * @since v0.6.13
   *
   * ## Set Date to a specific time
   *
   * ```js
   * import { setSystemTime } from 'bun:test';
   *
   * setSystemTime(new Date('2020-01-01T00:00:00.000Z'));
   * console.log(new Date().toISOString()); // 2020-01-01T00:00:00.000Z
   * ```
   * ## Reset Date to the current time
   *
   * ```js
   * import { setSystemTime } from 'bun:test';
   *
   * setSystemTime();
   * ```
   */
@module("bun:test")
external setSystemTime: dateOrNumber => unit = "setSystemTime"

// TODO: Jest?

/**
   * Describes a group of related tests.
   *
   * @example
   * function sum(a, b) {
   *   return a + b;
   * }
   * describe("sum()", () => {
   *   test("can sum two values", () => {
   *     expect(sum(1, 1)).toBe(2);
   *   });
   * });
   *
   * @param label the label for the tests
   * @param fn the function that defines the tests
   */
@module("bun:test")
external describe: (string, unit => unit) => unit = "describe"

module Describe = {
  /**
     * Skips all other tests, except this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("describe")
  external only: (string, unit => unit) => unit = "only"

  /**
     * Skips this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("describe")
  external skip: (string, unit => unit) => unit = "skip"

  /**
     * Marks this group of tests as to be written or to be fixed.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("describe")
  external todo: (string, ~test: unit => unit=?) => unit = "todo"

  /**
     * Runs this group of tests, only if `condition` is true.
     *
     * This is the opposite of `describe.skipIf()`.
     *
     * @param condition if these tests should run
     */
  @module("bun:test")
  @scope("describe")
  external if_: bool => (string, unit => unit) => unit = "if"

  /**
     * Skips this group of tests, if `condition` is true.
     *
     * @param condition if these tests should be skipped
     */
  @module("bun:test")
  @scope("describe")
  external skipIf: bool => (string, unit => unit) => unit = "skipIf"

  // TODO: each
}

type callbackFunction<'err> = (~error: 'err=?) => unit

/**
   * Runs a function, once, before all the tests.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, tests will not run in this file.
   *
   * @example
   * let database;
   * beforeAll(async () => {
   *   database = await connect("localhost");
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeAll: (unit => unit) => unit = "beforeAll"

/**
   * Runs a function, once, before all the tests.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, tests will not run in this file.
   *
   * @example
   * let database;
   * beforeAll(async () => {
   *   database = await connect("localhost");
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeAllAsync: (unit => promise<unit>) => unit = "beforeAll"

/**
   * Runs a function, once, before all the tests.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, tests will not run in this file.
   *
   * @example
   * let database;
   * beforeAll(async () => {
   *   database = await connect("localhost");
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeAllCallback: (callbackFunction<_> => unit) => unit = "beforeAll"

/**
   * Runs a function before each test.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, the test will not run.
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeEach: (unit => unit) => unit = "beforeEach"

/**
   * Runs a function before each test.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, the test will not run.
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeEachAsync: (unit => promise<unit>) => unit = "beforeEach"

/**
   * Runs a function before each test.
   *
   * This is useful for running set up tasks, like initializing
   * a global variable or connecting to a database.
   *
   * If this function throws, the test will not run.
   *
   * @param fn the function to run
   */
@module("bun:test")
external beforeEachCallback: (callbackFunction<_> => unit) => unit = "beforeEach"

/**
   * Runs a function, once, after all the tests.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @example
   * let database;
   * afterAll(async () => {
   *   if (database) {
   *     await database.close();
   *   }
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterAll: (unit => unit) => unit = "afterAll"

/**
   * Runs a function, once, after all the tests.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @example
   * let database;
   * afterAll(async () => {
   *   if (database) {
   *     await database.close();
   *   }
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterAllAsync: (unit => promise<unit>) => unit = "afterAll"

/**
   * Runs a function, once, after all the tests.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @example
   * let database;
   * afterAll(async () => {
   *   if (database) {
   *     await database.close();
   *   }
   * });
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterAllCallback: (callbackFunction<_> => unit) => unit = "afterAll"

/**
   * Runs a function after each test.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterEach: (unit => unit) => unit = "afterEach"

/**
   * Runs a function after each test.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterEachAsync: (unit => promise<unit>) => unit = "afterEach"

/**
   * Runs a function after each test.
   *
   * This is useful for running clean up tasks, like closing
   * a socket or deleting temporary files.
   *
   * @param fn the function to run
   */
@module("bun:test")
external afterEachCallback: (callbackFunction<_> => unit) => unit = "afterEach"

type testOptions = {
  /**
     * Sets the timeout for the test in milliseconds.
     *
     * If the test does not complete within this time, the test will fail with:
     * ```ts
     * 'Timeout: test {name} timed out after 5000ms'
     * ```
     *
     * @default 5000 // 5 seconds
     */
  timeout?: int,
  /**
     * Sets the number of times to retry the test if it fails.
     *
     * @default 0
     */
  retry?: int,
  /**
     * Sets the number of times to repeat the test, regardless of whether it passed or failed.
     *
     * @default 0
     */
  repeats?: int,
}

@unboxed
type timeoutOrOptions = Timeout(float) | Options(testOptions)

/**
   * Runs a test.
   *
   * @example
   * test("can check if using Bun", () => {
   *   expect(Bun).toBeDefined();
   * });
   *
   * test("can make a fetch() request", async () => {
   *   const response = await fetch("https://example.com/");
   *   expect(response.ok).toBe(true);
   * });
   *
   * test("can set a timeout", async () => {
   *   await Bun.sleep(100);
   * }, 50); // or { timeout: 50 }
   *
   * @param label the label for the test
   * @param fn the test function
   * @param options the test timeout or options
   */
@module("bun:test")
external test: (string, unit => unit, ~options: timeoutOrOptions=?) => unit = "test"

/**
   * Runs a test.
   *
   * @example
   * test("can check if using Bun", () => {
   *   expect(Bun).toBeDefined();
   * });
   *
   * test("can make a fetch() request", async () => {
   *   const response = await fetch("https://example.com/");
   *   expect(response.ok).toBe(true);
   * });
   *
   * test("can set a timeout", async () => {
   *   await Bun.sleep(100);
   * }, 50); // or { timeout: 50 }
   *
   * @param label the label for the test
   * @param fn the test function
   * @param options the test timeout or options
   */
@module("bun:test")
external testAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit = "test"

/**
   * Runs a test.
   *
   * @example
   * test("can check if using Bun", () => {
   *   expect(Bun).toBeDefined();
   * });
   *
   * test("can make a fetch() request", async () => {
   *   const response = await fetch("https://example.com/");
   *   expect(response.ok).toBe(true);
   * });
   *
   * test("can set a timeout", async () => {
   *   await Bun.sleep(100);
   * }, 50); // or { timeout: 50 }
   *
   * @param label the label for the test
   * @param fn the test function
   * @param options the test timeout or options
   */
@module("bun:test")
external testCallback: (
  string,
  callbackFunction<_> => promise<unit>,
  ~options: timeoutOrOptions=?,
) => unit = "test"

module Test = {
  /**
     * Skips all other tests, except this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external only: (string, unit => unit, ~options: timeoutOrOptions=?) => unit = "only"

  /**
     * Skips all other tests, except this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external onlyAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit = "only"

  /**
     * Skips all other tests, except this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external onlyCallback: (
    string,
    callbackFunction<_> => unit,
    ~options: timeoutOrOptions=?,
  ) => unit = "only"

  /**
     * Skips this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external skip: (string, unit => unit) => unit = "skip"

  /**
     * Skips this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external skipAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit = "skip"

  /**
     * Skips this group of tests.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external skipCallback: (
    string,
    callbackFunction<_> => unit,
    ~options: timeoutOrOptions=?,
  ) => unit = "skip"

  /**
     * Marks this group of tests as to be written or to be fixed.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external todo: (string, ~test: unit => unit=?) => unit = "todo"

  /**
     * Marks this group of tests as to be written or to be fixed.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external todoAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit = "todo"

  /**
     * Marks this group of tests as to be written or to be fixed.
     *
     * @param label the label for the tests
     * @param fn the function that defines the tests
     */
  @module("bun:test")
  @scope("test")
  external todoCallback: (
    string,
    callbackFunction<_> => unit,
    ~options: timeoutOrOptions=?,
  ) => unit = "todo"

  /**
     * Runs this group of tests, only if `condition` is true.
     *
     * This is the opposite of `describe.skipIf()`.
     *
     * @param condition if these tests should run
     */
  @module("bun:test")
  @scope("test")
  external if_: bool => (string, unit => unit) => unit = "if"

  /**
     * Runs this group of tests, only if `condition` is true.
     *
     * This is the opposite of `describe.skipIf()`.
     *
     * @param condition if these tests should run
     */
  @module("bun:test")
  @scope("test")
  external ifAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit = "if"

  /**
     * Runs this group of tests, only if `condition` is true.
     *
     * This is the opposite of `describe.skipIf()`.
     *
     * @param condition if these tests should run
     */
  @module("bun:test")
  @scope("test")
  external ifCallback: (string, callbackFunction<_> => unit, ~options: timeoutOrOptions=?) => unit =
    "if"

  /**
     * Skips this group of tests, if `condition` is true.
     *
     * @param condition if these tests should be skipped
     */
  @module("bun:test")
  @scope("test")
  external skipIf: bool => (string, unit => unit) => unit = "skipIf"

  /**
     * Skips this group of tests, if `condition` is true.
     *
     * @param condition if these tests should be skipped
     */
  @module("bun:test")
  @scope("test")
  external skipIfAsAsync: (string, unit => promise<unit>, ~options: timeoutOrOptions=?) => unit =
    "skipIf"
  @module("bun:test")
  @scope("test")
  /**
     * Skips this group of tests, if `condition` is true.
     *
     * @param condition if these tests should be skipped
     */
  external skipIfAsCallback: (
    string,
    callbackFunction<_> => unit,
    ~options: timeoutOrOptions=?,
  ) => unit = "skipIf"

  // TODO: each
}

// TODO: it?

module Expect = {
  type t<'t>

  /**
     * Negates the result of a subsequent assertion.
     *
     * @example
     * expect(1).not.toBe(0);
     * expect(null).not.toBeNull();
     */
  @get
  external not: t<'t> => t<'t> = "not"
  /**
     * Expects the value to be a promise that resolves.
     *
     * @example
     * expect(Promise.resolve(1)).resolves.toBe(1);
     */
  @get
  external resolves: t<'t> => t<'t> = "resolves"
  /**
     * Expects the value to be a promise that rejects.
     *
     * @example
     * expect(Promise.reject("error")).rejects.toBe("error");
     */
  @get
  external rejects: t<'t> => t<'t> = "rejects"
  /**
     * Assertion which passes.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/pass
     * @example
     * expect().pass();
     * expect().pass("message is optional");
     * expect().not.pass();
     * expect().not.pass("hi");
     *
     * @param message the message to display if the test fails (optional)
     */
  @send
  external pass: (t<'t>, ~message: string=?) => unit = "pass"

  /**
     * Assertion which fails.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/fail
     * @example
     * expect().fail();
     * expect().fail("message is optional");
     * expect().not.fail();
     * expect().not.fail("hi");
     */
  @send
  external fail: (t<'t>, ~message: string=?) => unit = "fail"

  /**
     * Asserts that a value equals what is expected.
     *
     * - For non-primitive values, like objects and arrays,
     * use `toEqual()` instead.
     * - For floating-point numbers, use `toBeCloseTo()` instead.
     *
     * @example
     * expect(100 + 23).toBe(123);
     * expect("d" + "og").toBe("dog");
     * expect([123]).toBe([123]); // fail, use toEqual()
     * expect(3 + 0.14).toBe(3.14); // fail, use toBeCloseTo()
     *
     * @param expected the expected value
     */
  @send
  external toBe: (t<'t>, 't) => unit = "toBe"

  /**
     * Asserts that a number is odd.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/number/#tobeodd
     * @example
     * expect(1).toBeOdd();
     * expect(2).not.toBeOdd();
     */
  @send
  external toBeOdd: t<'t> => unit = "toBeOdd"
  /**
     * Asserts that a number is even.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/number/#tobeeven
     * @example
     * expect(2).toBeEven();
     * expect(1).not.toBeEven();
     */
  @send
  external toBeEven: t<'t> => unit = "toBeEven"

  /**
     * Asserts that value is close to the expected by floating point precision.
     *
     * For example, the following fails because arithmetic on decimal (base 10)
     * values often have rounding errors in limited precision binary (base 2) representation.
     *
     * @example
     * expect(0.2 + 0.1).toBe(0.3); // fails
     *
     * Use `toBeCloseTo` to compare floating point numbers for approximate equality.
     *
     * @example
     * expect(0.2 + 0.1).toBeCloseTo(0.3, 5); // passes
     *
     * @param expected the expected value
     * @param numDigits the number of digits to check after the decimal point. Default is `2`
     */
  @send
  external toBeCloseTo: (t<'t>, float, ~numDigits: float=?) => unit = "toBeCloseTo"

  /**
     * Asserts that a value is deeply equal to what is expected.
     *
     * @example
     * expect(100 + 23).toBe(123);
     * expect("d" + "og").toBe("dog");
     * expect([456]).toEqual([456]);
     * expect({ value: 1 }).toEqual({ value: 1 });
     *
     * @param expected the expected value
     */
  @send
  external toEqual: (t<'t>, 't) => unit = "toEqual"

  /**
     * Asserts that a value is deeply and strictly equal to
     * what is expected.
     *
     * There are two key differences from `toEqual()`:
     * 1. It checks that the class is the same.
     * 2. It checks that `undefined` values match as well.
     *
     * @example
     * class Dog {
     *   type = "dog";
     * }
     * const actual = new Dog();
     * expect(actual).toStrictEqual(new Dog());
     * expect(actual).toStrictEqual({ type: "dog" }); // fail
     *
     * @example
     * const actual = { value: 1, name: undefined };
     * expect(actual).toEqual({ value: 1 });
     * expect(actual).toStrictEqual({ value: 1 }); // fail
     *
     * @param expected the expected value
     */
  @send
  external toStrictEqual: (t<'t>, 't) => unit = "toStrictEqual"

  /**
     * Asserts that a value contains what is expected.
     *
     * The value must be an array or iterable, which
     * includes strings.
     *
     * @example
     * expect([1, 2, 3]).toContain(1);
     * expect(new Set([true])).toContain(true);
     * expect("hello").toContain("o");
     *
     * @param expected the expected value
     */
  @send
  external toContain: (t<_>, 'any) => unit = "toContain"

  /**
     * Asserts that a value has a `.length` property
     * that is equal to the expected length.
     *
     * @example
     * expect([]).toHaveLength(0);
     * expect("hello").toHaveLength(4);
     *
     * @param length the expected length
     */
  @send
  external toHaveLength: (t<_>, float) => unit = "toHaveLength"

  /**
     * Asserts that a value has a property with the
     * expected name, and value, if provided.
     *
     * @example
     * expect(new Set()).toHaveProperty("size");
     * expect(new Uint8Array()).toHaveProperty("byteLength", 0);
     *
     * @param name the expected property name
     * @param value the expected property value, if provided
     */
  @send
  external toHaveProperty: (t<_>, string, ~value: 'any=?) => unit = "toHaveProperty"
  /**
     * Asserts that a value is "truthy".
     *
     * To assert that a value equals `true`, use `toBe(true)` instead.
     *
     * @link https://developer.mozilla.org/en-US/docs/Glossary/Truthy
     * @example
     * expect(true).toBeTruthy();
     * expect(1).toBeTruthy();
     * expect({}).toBeTruthy();
     */
  @send
  external toBeTruthy: t<_> => unit = "toBeTruthy"
  /**
     * Asserts that a value is "falsy".
     *
     * To assert that a value equals `false`, use `toBe(false)` instead.
     *
     * @link https://developer.mozilla.org/en-US/docs/Glossary/Falsy
     * @example
     * expect(true).toBeTruthy();
     * expect(1).toBeTruthy();
     * expect({}).toBeTruthy();
     */
  @send
  external toBeFalsy: t<_> => unit = "toBeFalsy"
  /**
     * Asserts that a value is defined. (e.g. is not `undefined`)
     *
     * @example
     * expect(true).toBeDefined();
     * expect(undefined).toBeDefined(); // fail
     */
  @send
  external toBeDefined: t<_> => unit = "toBeDefined"

  /**
     * Asserts that the expected value is an instance of value
     *
     * @example
     * expect([]).toBeInstanceOf(Array);
     * expect(null).toBeInstanceOf(Array); // fail
     */
  @send
  external toBeInstanceOf: (t<_>, 'any) => unit = "toBeInstanceOf"
  /**
     * Asserts that a value is `undefined`.
     *
     * @example
     * expect(undefined).toBeUndefined();
     * expect(null).toBeUndefined(); // fail
     */
  @send
  external toBeUndefined: t<_> => unit = "toBeUndefined"
  /**
     * Asserts that a value is `null`.
     *
     * @example
     * expect(null).toBeNull();
     * expect(undefined).toBeNull(); // fail
     */
  @send
  external toBeNull: t<_> => unit = "toBeNull"
  /**
     * Asserts that a value can be coerced to `NaN`.
     *
     * Same as using `Number.isNaN()`.
     *
     * @example
     * expect(NaN).toBeNaN();
     * expect(Infinity).toBeNaN();
     * expect("notanumber").toBeNaN();
     */
  @send
  external toBeNaN: t<_> => unit = "toBeNaN"

  // TODO(future) bigint versions of the below
  /**
     * Asserts that a value is a `number` and is greater than the expected value.
     *
     * @example
     * expect(1).toBeGreaterThan(0);
     * expect(3.14).toBeGreaterThan(3);
     * expect(9).toBeGreaterThan(9); // fail
     *
     * @param expected the expected number
     */
  @send
  external toBeGreaterThan: (t<_>, float) => unit = "toBeGreaterThan"
  /**
     * Asserts that a value is a `number` and is greater than or equal to the expected value.
     *
     * @example
     * expect(1).toBeGreaterThanOrEqual(0);
     * expect(3.14).toBeGreaterThanOrEqual(3);
     * expect(9).toBeGreaterThanOrEqual(9);
     *
     * @param expected the expected number
     */
  @send
  external toBeGreaterThanOrEqual: (t<_>, float) => unit = "toBeGreaterThanOrEqual"
  /**
     * Asserts that a value is a `number` and is less than the expected value.
     *
     * @example
     * expect(-1).toBeLessThan(0);
     * expect(3).toBeLessThan(3.14);
     * expect(9).toBeLessThan(9); // fail
     *
     * @param expected the expected number
     */
  @send
  external toBeLessThan: (t<_>, float) => unit = "toBeLessThan"
  /**
     * Asserts that a value is a `number` and is less than or equal to the expected value.
     *
     * @example
     * expect(-1).toBeLessThanOrEqual(0);
     * expect(3).toBeLessThanOrEqual(3.14);
     * expect(9).toBeLessThanOrEqual(9);
     *
     * @param expected the expected number
     */
  @send
  external toBeLessThanOrEqual: (t<_>, float) => unit = "toBeLessThanOrEqual"

  // TODO(future) Fix when Error.t is allowed in untagged variant
  @unboxed
  type expectedToThrow = String(string) /* | Error(Error.t) */ | RegExp(RegExp.t)

  /**
     * Asserts that a function throws an error.
     *
     * - If expected is a `string` or `RegExp`, it will check the `message` property.
     * - If expected is an `Error` object, it will check the `name` and `message` properties.
     * - If expected is an `Error` constructor, it will check the class of the `Error`.
     * - If expected is not provided, it will check if anything as thrown.
     *
     * @example
     * function fail() {
     *   throw new Error("Oops!");
     * }
     * expect(fail).toThrow("Oops!");
     * expect(fail).toThrow(/oops/i);
     * expect(fail).toThrow(Error);
     * expect(fail).toThrow();
     *
     * @param expected the expected error, error message, or error pattern
     */
  @send
  external toThrow: (t<_>, ~expected: expectedToThrow=?) => unit = "toThrow"

  @send
  external toThrowThisError: (t<_>, Error.t) => unit = "toThrow"

  /**
     * Asserts that a value matches a regular expression or includes a substring.
     *
     * @example
     * expect("dog").toMatch(/dog/);
     * expect("dog").toMatch("og");
     *
     * @param expected the expected substring or pattern.
     */
  @send
  external toMatch: (t<_>, stringOrRegexp) => unit = "toMatch"

  /**
     * Asserts that a value matches the most recent snapshot.
     *
     * @example
     * expect([1, 2, 3]).toMatchSnapshot();
     * expect({ a: 1, b: 2 }).toMatchSnapshot({ a: 1 });
     * expect({ c: new Date() }).toMatchSnapshot({ c: expect.any(Date) });
     *
     * @param propertyMatchers Object containing properties to match against the value.
     * @param hint Hint used to identify the snapshot in the snapshot file.
     */
  @send
  external toMatchSnapshot: (t<_>, ~propertyMatchers: Dict.t<'any>=?, ~hint: string=?) => unit =
    "toMatchSnapshot"
  /**
     * Asserts that an object matches a subset of properties.
     *
     * @example
     * expect({ a: 1, b: 2 }).toMatchObject({ b: 2 });
     * expect({ c: new Date(), d: 2 }).toMatchObject({ d: 2 });
     *
     * @param subset Subset of properties to match with.
     */
  @send
  external toMatchObject: (t<_>, 'obj) => unit = "toMatchObject"

  /**
     * Asserts that a value is empty.
     *
     * @example
     * expect("").toBeEmpty();
     * expect([]).toBeEmpty();
     * expect({}).toBeEmpty();
     * expect(new Set()).toBeEmpty();
     */
  @send
  external toBeEmpty: t<_> => unit = "toBeEmpty"
  /**
     * Asserts that a value is `null` or `undefined`.
     *
     * @example
     * expect(null).toBeNil();
     * expect(undefined).toBeNil();
     */
  @send
  external toBeNil: t<_> => unit = "toBeNil"
  /**
     * Asserts that a value is a `array`.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/array/#tobearray
     * @example
     * expect([1]).toBeArray();
     * expect(new Array(1)).toBeArray();
     * expect({}).not.toBeArray();
     */
  @send
  external toBeArray: t<_> => unit = "toBeArray"
  /**
     * Asserts that a value is a `array` of a certain length.
     *
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/array/#tobearrayofsize
     * @example
     * expect([]).toBeArrayOfSize(0);
     * expect([1]).toBeArrayOfSize(1);
     * expect(new Array(1)).toBeArrayOfSize(1);
     * expect({}).not.toBeArrayOfSize(0);
     */
  @send
  external toBeArrayOfSize: (t<_>, int) => unit = "toBeArrayOfSize"
  /**
     * Asserts that a value is a `boolean`.
     *
     * @example
     * expect(true).toBeBoolean();
     * expect(false).toBeBoolean();
     * expect(null).not.toBeBoolean();
     * expect(0).not.toBeBoolean();
     */
  @send
  external toBeBoolean: t<_> => unit = "toBeBoolean"
  /**
     * Asserts that a value is `true`.
     *
     * @example
     * expect(true).toBeTrue();
     * expect(false).not.toBeTrue();
     * expect(1).not.toBeTrue();
     */
  @send
  external toBeTrue: t<_> => unit = "toBeTrue"

  /**
     * Asserts that a value matches a specific type.
     *
     * @link https://vitest.dev/api/expect.html#tobetypeof
     * @example
     * expect(1).toBeTypeOf("number");
     * expect("hello").toBeTypeOf("string");
     * expect([]).not.toBeTypeOf("boolean");
     */
  @send
  external toBeTypeOf: (
    t<_>,
    [
      | #bigint
      | #boolean
      | #function
      | #number
      | #object
      | #string
      | #symbol
      | #undefined
    ],
  ) => unit = "toBeTypeOf"
  /**
     * Asserts that a value is `false`.
     *
     * @example
     * expect(false).toBeFalse();
     * expect(true).not.toBeFalse();
     * expect(0).not.toBeFalse();
     */
  @send
  external toBeFalse: t<_> => unit = "toBeFalse"
  /**
     * Asserts that a value is a `number`.
     *
     * @example
     * expect(1).toBeNumber();
     * expect(3.14).toBeNumber();
     * expect(NaN).toBeNumber();
     * expect(BigInt(1)).not.toBeNumber();
     */
  @send
  external toBeNumber: t<_> => unit = "toBeNumber"
  /**
     * Asserts that a value is a `number`, and is an integer.
     *
     * @example
     * expect(1).toBeInteger();
     * expect(3.14).not.toBeInteger();
     * expect(NaN).not.toBeInteger();
     */
  @send
  external toBeInteger: t<_> => unit = "toBeInteger"
  /**
     * Asserts that a value is a `number`, and is not `NaN` or `Infinity`.
     *
     * @example
     * expect(1).toBeFinite();
     * expect(3.14).toBeFinite();
     * expect(NaN).not.toBeFinite();
     * expect(Infinity).not.toBeFinite();
     */
  @send
  external toBeFinite: t<_> => unit = "toBeFinite"
  /**
     * Asserts that a value is a positive `number`.
     *
     * @example
     * expect(1).toBePositive();
     * expect(-3.14).not.toBePositive();
     * expect(NaN).not.toBePositive();
     */
  @send
  external toBePositive: t<_> => unit = "toBePositive"
  /**
     * Asserts that a value is a negative `number`.
     *
     * @example
     * expect(-3.14).toBeNegative();
     * expect(1).not.toBeNegative();
     * expect(NaN).not.toBeNegative();
     */
  @send
  external toBeNegative: t<_> => unit = "toBeNegative"
  /**
     * Asserts that a value is a number between a start and end value.
     *
     * @param start the start number (inclusive)
     * @param end the end number (exclusive)
     */
  @send
  external toBeWithin: (t<_>, ~start: float, ~end_: float) => unit = "toBeWithin"
  /**
     * Asserts that a value is equal to the expected string, ignoring any whitespace.
     *
     * @example
     * expect(" foo ").toEqualIgnoringWhitespace("foo");
     * expect("bar").toEqualIgnoringWhitespace(" bar ");
     *
     * @param expected the expected string
     */
  @send
  external toEqualIgnoringWhitespace: (t<_>, string) => unit = "toEqualIgnoringWhitespace"
  /**
     * Asserts that a value is a `symbol`.
     *
     * @example
     * expect(Symbol("foo")).toBeSymbol();
     * expect("foo").not.toBeSymbol();
     */
  @send
  external toBeSymbol: t<_> => unit = "toBeSymbol"
  /**
     * Asserts that a value is a `function`.
     *
     * @example
     * expect(() => {}).toBeFunction();
     */
  @send
  external toBeFunction: t<_> => unit = "toBeFunction"
  /**
     * Asserts that a value is a `Date` object.
     *
     * To check if a date is valid, use `toBeValidDate()` instead.
     *
     * @example
     * expect(new Date()).toBeDate();
     * expect(new Date(null)).toBeDate();
     * expect("2020-03-01").not.toBeDate();
     */
  @send
  external toBeDate: t<_> => unit = "toBeDate"
  /**
     * Asserts that a value is a valid `Date` object.
     *
     * @example
     * expect(new Date()).toBeValidDate();
     * expect(new Date(null)).not.toBeValidDate();
     * expect("2020-03-01").not.toBeValidDate();
     */
  @send
  external toBeValidDate: t<_> => unit = "toBeValidDate"
  /**
     * Asserts that a value is a `string`.
     *
     * @example
     * expect("foo").toBeString();
     * expect(new String("bar")).toBeString();
     * expect(123).not.toBeString();
     */
  @send
  external toBeString: t<_> => unit = "toBeString"
  /**
     * Asserts that a value includes a `string`.
     *
     * For non-string values, use `toContain()` instead.
     *
     * @param expected the expected substring
     */
  @send
  external toInclude: (t<_>, string) => unit = "toInclude"
  /**
     * Asserts that a value includes a `string` {times} times.
     * @param expected the expected substring
     * @param times the number of times the substring should occur
     */
  @send
  external toIncludeRepeated: (t<_>, string, ~times: float) => unit = "toIncludeRepeated"
  /**
     * Checks whether a value satisfies a custom condition.
     * @param {Function} predicate - The custom condition to be satisfied. It should be a function that takes a value as an argument (in this case the value from expect) and returns a boolean.
     * @example
     * expect(1).toSatisfy((val) => val > 0);
     * expect("foo").toSatisfy((val) => val === "foo");
     * expect("bar").not.toSatisfy((val) => val === "bun");
     * @link https://vitest.dev/api/expect.html#tosatisfy
     * @link https://jest-extended.jestcommunity.dev/docs/matchers/toSatisfy
     */
  @send
  external toSatisfy: (t<'t>, 't => bool) => unit = "toSatisfy"
  /**
     * Asserts that a value starts with a `string`.
     *
     * @param expected the string to start with
     */
  @send
  external toStartWith: (t<_>, string) => unit = "toStartWith"
  /**
     * Asserts that a value ends with a `string`.
     *
     * @param expected the string to end with
     */
  @send
  external toEndWith: (t<_>, string) => unit = "toEndWith"
  /**
     * Ensures that a mock function is called.
     */
  @send
  external toHaveBeenCalled: t<_> => unit = "toHaveBeenCalled"
  /**
     * Ensures that a mock function is called an exact number of times.
     */
  @send
  external toHaveBeenCalledTimes: (t<_>, float) => unit = "toHaveBeenCalledTimes"
}

/**
   * Asserts that a value matches some criteria.
   *
   * @link https://jestjs.io/docs/expect#reference
   * @example
   * expect(1 + 1).toBe(2);
   * expect([1,2,3]).toContain(2);
   * expect(null).toBeNull();
   *
   * @param actual the actual value
   */
@module("bun:test")
external expect: 't => Expect.t<'t> = "expect"
