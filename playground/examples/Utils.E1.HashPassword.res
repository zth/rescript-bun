// https://bun.sh/guides/util/hash-a-password
let password = "super-secure-pa$$word"

let hash = await Bun.Password.hash(password)
Console.log(hash)

// use argon2 (default)
let argonHash = await Bun.Password.hash(
  password,
  ~algorithm=Argon2d({
    memoryCost: 4., // memory usage in kibibytes
    timeCost: 3., // the number of iterations
  }),
)
Console.log(argonHash)

let bcryptHash = await Bun.Password.hash(
  password,
  ~algorithm=BCryptAlgorithm({
    cost: 4, // number between 4-31
  }),
)
Console.log(bcryptHash)

let isMatch = await Bun.Password.verify(password, ~hash)
Console.log(isMatch)
