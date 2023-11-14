// https://bun.sh/guides/util/deep-equals

let a = {"a": 1, "b": 2, "c": {"d": 3}}
let b = {"a": 1, "b": 2, "c": {"d": 3}}

let equals = Bun.deepEquals(a, b) // true

Console.log(equals)
