module Dirent = {
  type t = {name: string}
  @send external isBlockDevice: t => bool = "isBlockDevice"
  @send external isCharacterDevice: t => bool = "isCharacterDevice"
  @send external isDirectory: t => bool = "isDirectory"
  @send external isFIFO: t => bool = "isFIFO"
  @send external isFile: t => bool = "isFile"
  @send external isSocket: t => bool = "isSocket"
  @send external isSymbolicLink: t => bool = "isSymbolicLink"
}

module Dir = {
  type t = {path: string}
  @send external close: t => promise<unit> = "close"
  @send
  external closeWithCallback: (t, Nullable.t<JsExn.t> => unit) => unit = "close"
  @send external closeSync: t => unit = "closeSync"
  @send
  external read: t => promise<Nullable.t<Dirent.t>> = "read"
  @send
  external readWithCallback: (t, (JsExn.t, Nullable.t<Dirent.t>) => unit) => unit = "read"
  @send external readSync: t => Nullable.t<Dirent.t> = "readSync"
}

module Stats = {
  type t = {
    dev: int,
    ino: int,
    mode: int,
    nlink: int,
    uid: int,
    gid: int,
    rdev: int,
    size: int,
    blksize: int,
    blocks: int,
    atimeMs: float,
    mtimeMs: float,
    ctimeMs: float,
    birthtimeMs: float,
    atime: string,
    mtime: string,
    ctime: string,
    birthtime: string,
  }

  /** `isFile(stats)` Returns true if the `stats` object describes a file. */
  @send
  external isFile: t => bool = "isFile"
  /** `isDirectory(stats)` Returns true if the `stats` object describes a directory. */
  @send
  external isDirectory: t => bool = "isDirectory"
  /** `isBlockDevice(stats)` Returns true if the `stats` object describes a block device. */
  @send
  external isBlockDevice: t => bool = "isBlockDevice"
  /** `isBlockDevice(stats)` Returns true if the `stats` object describes a character device. */
  @send
  external isCharacterDevice: t => bool = "isCharacterDevice"
  /** `isBlockDevice(stats)` Returns true if the `stats` object describes a symbolic link. */
  @send
  external isSymbolicLink: t => bool = "isSymbolicLink"
  /** `isBlockDevice(stats)` Returns true if the `stats` object describes a first-in-first-out (FIFO) pipe. */
  @send
  external isFIFO: t => bool = "isFIFO"
  /** `isBlockDevice(stats)` Returns true if the `stats` object describes a socket. */
  @send
  external isSocket: t => bool = "isSocket"
}

module Constants = {
  type t = private int

  /** Bitwise 'or' i.e. JavaScript [x | y] */
  external lor: (t, t) => t = "%orint"

  @@text("{1 File Access Constants}")

  @module("node:fs") @scope("constants") external f_ok: t = "F_OK"
  @module("node:fs") @scope("constants") external w_ok: t = "W_OK"
  @module("node:fs") @scope("constants") external r_ok: t = "R_OK"
  @module("node:fs") @scope("constants") external x_ok: t = "X_OK"

  @@text("{1 File Copy Constants}")

  @module("node:fs") @scope("constants") external copyfile_excl: t = "COPYFILE_EXCL"
  @module("node:fs") @scope("constants") external copyfile_ficlone: t = "COPYFILE_FICLONE"
  @module("node:fs") @scope("constants")
  external copyfile_ficlone_force: t = "COPYFILE_FICLONE_FORCE"

  @@text("{1 File Open Constants}")

  @module("node:fs") @scope("constants") external o_rdonly: t = "O_RDONLY"
  @module("node:fs") @scope("constants") external o_wronly: t = "O_WRONLY"
  @module("node:fs") @scope("constants") external o_rdwr: t = "O_RDWR"
  @module("node:fs") @scope("constants") external o_creat: t = "O_CREAT"
  @module("node:fs") @scope("constants") external o_excl: t = "O_EXCL"
  @module("node:fs") @scope("constants") external o_noctty: t = "O_NOCTTY"
  @module("node:fs") @scope("constants") external o_trunc: t = "O_TRUNC"
  @module("node:fs") @scope("constants") external o_append: t = "O_APPEND"
  @module("node:fs") @scope("constants") external o_directory: t = "O_DIRECTORY"
  @module("node:fs") @scope("constants") external o_noatime: t = "O_NOATIME"
  @module("node:fs") @scope("constants") external o_nofollow: t = "O_NOFOLLOW"
  @module("node:fs") @scope("constants") external o_sync: t = "O_SYNC"
  @module("node:fs") @scope("constants") external o_dsync: t = "O_DSYNC"
  @module("node:fs") @scope("constants") external o_symlink: t = "O_SYMLINK"
  @module("node:fs") @scope("constants") external o_direct: t = "O_DIRECT"
  @module("node:fs") @scope("constants") external o_nonblock: t = "O_NONBLOCK"

  @@text("{1 File Type Constants}")

  @module("node:fs") @scope("constants") external s_ifmt: t = "S_IFMT"
  @module("node:fs") @scope("constants") external s_ifreg: t = "S_IFREG"
  @module("node:fs") @scope("constants") external s_ifdir: t = "S_IFDIR"
  @module("node:fs") @scope("constants") external s_ifchr: t = "S_IFCHR"
  @module("node:fs") @scope("constants") external s_ifblk: t = "S_IFBLK"
  @module("node:fs") @scope("constants") external s_ififo: t = "S_IFIFO"
  @module("node:fs") @scope("constants") external s_iflnk: t = "S_IFLNK"
  @module("node:fs") @scope("constants") external s_ifsock: t = "S_IFSOCK"

  @@text("{1 File Mode Constants}")

  @module("node:fs") @scope("constants") external s_irwxu: t = "S_IRWXU"
  @module("node:fs") @scope("constants") external s_irusr: t = "S_IRUSR"
  @module("node:fs") @scope("constants") external s_iwusr: t = "S_IWUSR"
  @module("node:fs") @scope("constants") external s_ixusr: t = "S_IXUSR"
  @module("node:fs") @scope("constants") external s_irwxg: t = "S_IRWXG"
  @module("node:fs") @scope("constants") external s_irgrp: t = "S_IRGRP"
  @module("node:fs") @scope("constants") external s_iwgrp: t = "S_IWGRP"
  @module("node:fs") @scope("constants") external s_ixgrp: t = "S_IXGRP"
  @module("node:fs") @scope("constants") external s_irwxo: t = "S_IRWXO"
  @module("node:fs") @scope("constants") external s_iroth: t = "S_IROTH"
  @module("node:fs") @scope("constants") external s_iwoth: t = "S_IWOTH"
  @module("node:fs") @scope("constants") external s_ixoth: t = "S_IXOTH"
}

module Flag: {
  type t = private string

  @inline("r")
  let read: t
  @inline("r+")
  let readWrite: t
  @inline("rs+")
  let readWriteSync: t
  @inline("w")
  let write: t
  @inline("wx")
  let writeFailIfExists: t
  @inline("w+")
  let writeRead: t
  @inline("wx+")
  let writeReadFailIfExists: t
  @inline("a")
  let append: t
  @inline("ax")
  let appendFailIfExists: t
  @inline("a+")
  let appendRead: t
  @inline("ax+")
  let appendReadFailIfExists: t
} = {
  type t = string
  @inline("r")
  let read = "r"
  @inline("r+")
  let readWrite = "r+"
  @inline("rs+")
  let readWriteSync = "rs+"
  @inline("w")
  let write = "w"
  @inline("wx")
  let writeFailIfExists = "wx"
  @inline("w+")
  let writeRead = "w+"
  @inline("wx+")
  let writeReadFailIfExists = "wx+"
  @inline("a")
  let append = "a"
  @inline("ax")
  let appendFailIfExists = "ax"
  @inline("a+")
  let appendRead = "a+"
  @inline("ax+")
  let appendReadFailIfExists = "ax+"
}

type fd = private int

type writeFileOptions = {
  mode?: int,
  flag?: Flag.t,
  encoding?: string,
}

type appendFileOptions = {
  mode?: int,
  flag?: Flag.t,
  encoding?: string,
}

type readFileOptions = {
  flag?: Flag.t,
  encoding?: string,
}

type openFileOptions = {
  flag?: Flag.t,
  mode?: int,
}

/**
 * `readdirSync(path)`
 * Reads the contents of a directory, returning an array of strings representing
 * the paths of files and sub-directories. **Execution is synchronous and blocking**.
 */
@module("node:fs")
external readdirSync: string => array<string> = "readdirSync"

/**
 * `renameSync(~oldPath, ~newPath)
 * Renames/moves the file located at `~oldPath` to `~newPath`. **Execution is
 * synchronous and blocking**.
 */
@module("node:fs")
external renameSync: (~from: string, ~to_: string) => unit = "renameSync"
@module("node:fs") external ftruncateSync: (fd, int) => unit = "ftruncateSync"
@module("node:fs")
external truncateSync: (string, int) => unit = "truncateSync"
@module("node:fs")
external chownSync: (string, ~uid: int, ~gid: int) => unit = "chownSync"
@module("node:fs")
external fchownSync: (fd, ~uid: int, ~gid: int) => unit = "fchownSync"
@module("node:fs") external readlinkSync: string => string = "readlinkSync"
@module("node:fs") external unlinkSync: string => unit = "unlinkSync"

/**
 * `rmdirSync(dirPath)
 * **Note: (recursive removal is experimental).**
 * Removes the directory at `dirPath`. **Execution is synchronous and blocking**.
 */
@module("node:fs")
external rmdirSync: string => unit = "rmdirSync"

@module("node:fs") external openSync: string => fd = "openSync"
@module("node:fs")
external openSyncWith: (string, ~flag: Flag.t=?, ~mode: int=?) => fd = "openSync"

@module("node:fs")
external readFileSync: string => Buffer.t = "readFileSync"
@module("node:fs")
external readFileSyncWith: (string, readFileOptions) => Buffer.t = "readFileSync"

@module("node:fs") external existsSync: string => bool = "existsSync"

@val @module("node:fs")
external writeFileSync: (string, Buffer.t) => unit = "writeFileSync"
@val @module("node:fs")
external writeFileSyncWith: (string, Buffer.t, writeFileOptions) => unit = "writeFileSync"

module FileHandle = {
  type t = {fd: fd}

  @send
  external appendFile: (t, Buffer.t, appendFileOptions) => promise<unit> = "appendFile"
  @send
  external appendFileWith: (t, Buffer.t) => promise<unit> = "appendFile"
  @send external chmod: (t, int) => promise<unit> = "chmod"
  @send external chown: (t, int, int) => promise<unit> = "chown"
  @send external close: t => promise<unit> = "close"
  @send external datasync: t => promise<unit> = "datasync"

  type readInfo = {
    bytesRead: int,
    buffer: Buffer.t,
  }

  @send
  external read: (t, Buffer.t, ~offset: int, ~length: int, ~position: int) => promise<readInfo> =
    "read"
  @send external readFile: t => promise<Buffer.t> = "readFile"
  @send
  external readFileWith: (t, readFileOptions) => promise<string> = "readFile"

  @send external stat: t => promise<Stats.t> = "stat"
  @send external sync: t => promise<unit> = "sync"
  @send
  external truncate: (t, ~length: int=?, unit) => promise<unit> = "truncate"

  type writeInfo = {bytesWritten: int}

  @send
  external write: (t, Buffer.t) => promise<writeInfo> = "write"
  @send
  external writeOffset: (t, Buffer.t, ~offset: int) => promise<writeInfo> = "write"
  @send
  external writeRange: (
    t,
    Buffer.t,
    ~offset: int,
    ~length: int,
    ~position: int,
  ) => promise<writeInfo> = "write"

  @send
  external writeFile: (t, Buffer.t) => promise<unit> = "writeFile"
  @send
  external writeFileWith: (t, Buffer.t, writeFileOptions) => promise<unit> = "writeFile"
}

module PromiseAPI = {
  @module("node:fs") @scope("promises")
  external access: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)] => promise<unit> =
    "access"
  @module("node:fs") @scope("promises")
  external accessWithMode: (
    @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~mode: int,
  ) => promise<unit> = "access"

  type appendFileStrOptions = {
    encoding?: string,
    mode?: int,
    flag?: Flag.t,
  }
  @module("node:fs") @scope("promises")
  external appendFile: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t) | #Handle(FileHandle.t)],
    ~data: string,
  ) => promise<unit> = "appendFile"

  @module("node:fs") @scope("promises")
  external appendFileWith: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t) | #Handle(FileHandle.t)],
    ~data: string,
    ~options: appendFileStrOptions,
  ) => promise<unit> = "appendFile"

  type appendFileBufferOptions = {
    mode?: int,
    flag?: Flag.t,
  }
  @module("node:fs") @scope("promises")
  external appendFileBuffer: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t) | #Handle(FileHandle.t)],
    ~data: Buffer.t,
  ) => promise<unit> = "appendFile"

  @module("node:fs") @scope("promises")
  external appendFileBufferWith: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t) | #Handle(FileHandle.t)],
    ~data: Buffer.t,
    ~options: appendFileBufferOptions,
  ) => promise<unit> = "appendFile"

  @module("node:fs") @scope("promises")
  external chmod: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~mode: int,
  ) => promise<unit> = "chmod"

  @module("node:fs") @scope("promises")
  external chown: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~uid: int,
    ~gid: int,
  ) => promise<unit> = "chown"

  @module("node:fs") @scope("promises")
  external copyFile: (
    ~src: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~dest: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
  ) => promise<unit> = "copyFile"

  @module("node:fs") @scope("promises")
  external copyFileFlag: (
    ~src: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~dest: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~flags: Constants.t,
  ) => promise<unit> = "copyFile"

  @module("node:fs") @scope("promises")
  external lchmod: (~path: @unwrap [#Str(string)], ~mode: int) => promise<unit> = "lchmod"

  @module("node:fs") @scope("promises")
  external link: (
    ~existingPath: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~newPath: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
  ) => promise<unit> = "link"

  type statOptions = {bigint: int}
  @module("node:fs") @scope("promises")
  external lstat: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)] => promise<Stats.t> =
    "lstat"

  @module("node:fs") @scope("promises")
  external lstatBigInt: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~options: statOptions,
  ) => promise<Stats.t> = "lstat"

  type mkdirOptions = {
    recursive?: bool,
    mode?: int,
  }

  @module("node:fs") @scope("promises")
  external mkdir: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)] => promise<unit> =
    "mkdir"

  @module("node:fs") @scope("promises")
  external mkdirWith: (
    @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    mkdirOptions,
  ) => promise<unit> = "mkdir"

  type mkdtempOptions = {encoding?: string}

  @module("node:fs") @scope("promises")
  external mkdtemp: string => promise<string> = "mkdtemp"

  @module("node:fs") @scope("promises")
  external mkdtempWith: (
    ~prefix: string,
    ~mkdtempOptions: @unwrap [#Str(string) | #Option(mkdtempOptions)],
  ) => promise<string> = "mkddtemp"

  @module("node:fs") @scope("promises")
  external open_: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~flags: Flag.t,
  ) => promise<FileHandle.t> = "open"

  @module("node:fs") @scope("promises")
  external openWithMode: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~flags: Flag.t,
    ~mode: int,
  ) => promise<FileHandle.t> = "open"

  @module("node:fs") @scope("promises")
  external stat: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)] => promise<Stats.t> =
    "lstat"

  @module("node:fs") @scope("promises")
  external statWith: (
    ~path: @unwrap [#Str(string) | #Buffer(Buffer.t) | #URL(Url.t)],
    ~options: statOptions,
  ) => promise<Stats.t> = "lstat"
}

@module("node:fs") @scope("promises")
external access: string => promise<unit> = "access"
@module("node:fs") @scope("promises")
external accessWithMode: (string, ~mode: int) => promise<unit> = "access"

@module("node:fs") @scope("promises")
external appendFile: (string, string, appendFileOptions) => promise<unit> = "appendFile"

@module("node:fs") @scope("promises")
external appendFileWith: (string, string, appendFileOptions) => promise<unit> = "appendFile"

type appendFileBufferOptions = {mode?: int, flag?: Flag.t}

@module("node:fs") @scope("promises")
external appendFileBuffer: (string, Buffer.t) => promise<unit> = "appendFile"

@module("node:fs") @scope("promises")
external appendFileBufferWith: (string, Buffer.t, appendFileBufferOptions) => promise<unit> =
  "appendFile"

@module("node:fs") @scope("promises")
external chmod: (string, ~mode: int) => promise<unit> = "chmod"

@module("node:fs") @scope("promises")
external chown: (string, ~uid: int, ~gid: int) => promise<unit> = "chown"

@module("node:fs") @scope("promises")
external copyFile: (string, ~dest: string) => promise<unit> = "copyFile"

@module("node:fs") @scope("promises")
external copyFileFlag: (string, ~dest: string, ~flags: Constants.t) => promise<unit> = "copyFile"

@module("node:fs") @scope("promises")
external lchmod: (string, ~mode: int) => promise<unit> = "lchmod"

@module("node:fs") @scope("promises")
external link: (~existingPath: string, ~newPath: string) => promise<unit> = "link"

@module("node:fs") @scope("promises")
external lstat: string => promise<Stats.t> = "lstat"

@module("node:fs") @scope("promises")
external lstatBigInt: (string, bool) => promise<Stats.t> = "lstat"

type mkdirOptions = {recursive?: bool, mode?: int}

@module("node:fs") @scope("promises")
external mkdir: (string, mkdirOptions) => promise<unit> = "mkdir"

@module("node:fs") @scope("promises")
external mkdirWith: (string, mkdirOptions) => promise<unit> = "mkdir"

@module("node:fs")
external mkdirSync: string => unit = "mkdirSync"

@module("node:fs")
external mkdirSyncWith: (string, mkdirOptions) => unit = "mkdirSync"

type mkdtempOptions = {encoding?: string}

@module("node:fs") @scope("promises")
external mkdtemp: string => promise<string> = "mkddtemp"

@module("node:fs") @scope("promises")
external mkdtempWith: (string, mkdtempOptions) => promise<string> = "mkddtemp"

@module("node:fs") @scope("promises")
external open_: (string, Flag.t) => promise<FileHandle.t> = "open"

@module("node:fs") @scope("promises")
external openWithMode: (string, Flag.t, ~mode: int) => promise<FileHandle.t> = "open"

module WriteStream = {
  type kind<'w> = [Stream.writable<'w> | #FileSystem]
  type subtype<'w, 'ty> = Stream.subtype<[> kind<'w>] as 'ty>
  type supertype<'w, 'ty> = Stream.subtype<[< kind<'w>] as 'ty>
  type t = subtype<Buffer.t, [kind<Buffer.t>]>
  module Impl = {
    include Stream.Writable.Impl
    @send
    external bytesWritten: subtype<'w, [> kind<'w>]> => int = "bytesWritten"
    @send external path: subtype<'w, [> kind<'w>]> => string = "path"
    @send
    external pending: subtype<'w, [> kind<'w>]> => bool = "pending"
    @send
    external onOpen: (
      subtype<'w, [> kind<'w>]> as 'stream',
      @as("open") _,
      @uncurry fd => unit,
    ) => 'stream = "on"
    @send
    external onReady: (
      subtype<'w, [> kind<'w>]> as 'stream,
      @as("ready") _,
      @uncurry unit => unit,
    ) => 'stream = "on"
  }
  include Impl
}

module ReadStream = {
  type kind<'r> = [Stream.readable<'r> | #FileSystem]
  type subtype<'r, 'ty> = Stream.subtype<[> kind<'r>] as 'ty>
  type supertype<'r, 'ty> = Stream.subtype<[< kind<'r>] as 'ty>
  type t = subtype<Buffer.t, [kind<Buffer.t>]>
  module Impl = {
    include Stream.Readable.Impl
    @send
    external bytesRead: subtype<'r, [> kind<'r>]> => int = "bytesWritten"
    @send external path: subtype<'r, [> kind<'r>]> => string = "path"
    @send
    external pending: subtype<'r, [> kind<'r>]> => bool = "pending"
    @send
    external onOpen: (
      subtype<'r, [> kind<'r>]> as 'stream,
      @as("open") _,
      @uncurry fd => unit,
    ) => 'stream = "on"
    @send
    external onReady: (
      subtype<'r, [> kind<'r>]> as 'stream,
      @as("ready") _,
      @uncurry unit => unit,
    ) => 'stream = "on"
  }
  include Impl
}

type createReadStreamOptions = {
  flags?: Flag.t,
  encoding?: string,
  fd?: fd,
  mode?: int,
  autoClose?: bool,
  emitClose?: bool,
  start?: int,
  _end?: int,
  highWaterMark?: int,
}
@module("node:fs")
external createReadStream: string => ReadStream.t = "createReadStream"
@module("node:fs")
external createReadStreamWith: (string, createReadStreamOptions) => ReadStream.t =
  "createReadStream"

type createWriteStreamOptions<'fs> = {
  flags?: Flag.t,
  encoding?: string,
  fd?: fd,
  mode?: int,
  autoClose?: bool,
  emitClose?: bool,
  start?: int,
  fs?: 'fs,
}
@module("node:fs")
external createWriteStream: string => WriteStream.t = "createWriteStream"

@module("fs")
external createWriteStreamWith: (string, createWriteStreamOptions<'fs>) => WriteStream.t =
  "createWriteStream"
