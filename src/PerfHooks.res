module PerformanceEntry = {
  type t = {
    duration: float,
    name: string,
    startTime: float,
    entryType: string,
    kind: int,
  }
  @get external duration: t => float = "duration"
  @get external name: t => string = "name"
  @get external startTime: t => float = "startTime"
  @get external entryType: t => string = "entryType"
  @get external kind: t => int = "kind"
}

module PerformanceNodeTiming = {
  type t = {
    // Extends PerformanceEntry: TODO use spread in ReScript 11
    duration: float,
    name: string,
    startTime: float,
    entryType: string,
    kind: int,
    // Specific to this class:
    bootstrapComplete: float,
    clusterSetupStart: float,
    clusterSetupEnd: float,
    environment: float,
    loopStart: float,
    loopExit: float,
    moduleLoadStart: float,
    moduleLoadEnd: float,
    nodeStart: float,
    preloadModuleLoadStart: float,
    preloadModuleLoadEnd: float,
    thirdPartyMainStart: float,
    thirdPartyMainEnd: float,
    v8Start: float,
  }
  // Extends PerformanceEntry:
  @get external duration: t => float = "duration"
  @get external name: t => string = "name"
  @get external startTime: t => float = "startTime"
  @get external entryType: t => string = "entryType"
  @get external kind: t => int = "kind"
  // Specific to this class:
  @get external bootstrapComplete: t => float = "bootstrapComplete"
  @get external clusterSetupStart: t => float = "clusterSetupStart"
  @get external clusterSetupEnd: t => float = "clusterSetupEnd"
  @get external environment: t => float = "environment"
  @get external loopStart: t => float = "loopStart"
  @get external loopExit: t => float = "loopExit"
  @get external moduleLoadStart: t => float = "moduleLoadStart"
  @get external moduleLoadEnd: t => float = "moduleLoadEnd"
  @get external nodeStart: t => float = "nodeStart"
  @get external preloadModuleLoadStart: t => float = "preloadModuleLoadStart"
  @get external preloadModuleLoadEnd: t => float = "preloadModuleLoadEnd"
  @get external thirdPartyMainStart: t => float = "thirdPartyMainStart"
  @get external thirdPartyMainEnd: t => float = "thirdPartyMainEnd"
  @get external v8Start: t => float = "v8Start"
}

module Performance = {
  type t = {nodeTiming: PerformanceNodeTiming.t}
  @module("node:perf_hooks") external performance: t = "performance"
  @send external clearMarks: (t, unit) => unit = "clearMarks"
  @send external clearMarksByName: (t, string) => unit = "clearMarks"
  @send external mark: (t, unit) => unit = "mark"
  @send external markWithName: (t, string) => unit = "mark"
  @send
  external measure: (t, string, ~startMark: string, ~endMark: string) => unit = "measure"
  @get external nodeTiming: t => PerformanceNodeTiming.t = "nodeTiming"
  @send external now: t => float = "now"
  @send external timerify: (unit => unit, unit) => unit = "timerify"
  @send
  external timerifyU: (@uncurry (unit => unit), unit) => unit = "timerify"
}

module Histogram = {
  type t = {
    exceeds: float,
    max: float,
    mean: float,
    min: float,
  }
  @send external disable: (t, unit) => bool = "disable"
  @send external enable: (t, unit) => bool = "enable"
  @get external exceeds: t => float = "exceeds"
  @get external max: t => float = "max"
  @get external mean: t => float = "mean"
  @get external min: t => float = "min"
  @send external percentile: (t, int) => float = "percentile"
  @send external reset: t => unit = "reset"
  @send external stddev: t => float = "stddev"
  // ES6 Map type not defined by BuckleScript as far as I can tell
  // [@bs.get] external percentiles: t => ES6Map.t(int, float) = "percentiles";
}

module PerformanceObserverEntryList = {
  type t
  @send
  external getEntries: t => array<PerformanceEntry.t> = "getEntries"
  @send
  external getEntriesByName: (t, string, Nullable.t<string>) => array<PerformanceEntry.t> =
    "getEntriesByName"
  let getEntriesByName = (entryList, ~type_=?, name) =>
    getEntriesByName(entryList, name, Nullable.fromOption(type_))
  @send
  external getEntriesByType: (t, string) => array<PerformanceEntry.t> = "getEntriesByType"
}

module PerformanceObserver = {
  type t
  @module("node:perf_hooks") @new
  external make: ((PerformanceObserverEntryList.t, t) => unit) => t = "PerformanceObserver"
}

@module("node:perf_hooks")
external monitorEventLoopDelay: Nullable.t<{"resolution": float}> => Histogram.t = "eventLoopDelay"
let monitorEventLoopDelay = (~resolution=?, ()) =>
  monitorEventLoopDelay(Nullable.fromOption(resolution))
