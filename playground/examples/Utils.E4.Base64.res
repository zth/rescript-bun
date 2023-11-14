// https://bun.sh/guides/util/base64

let data = "hello world"
let encoded = btoa(data) // => "aGVsbG8gd29ybGQ="
let decoded = atob(encoded) // => "hello world"

Console.log2(encoded, decoded)
