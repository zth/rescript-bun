type eventLoopUtilization = {
  idle: float,
  active: float,
  utilization: float,
}
// /**
//  * @param util1 The result of a previous call to eventLoopUtilization()
//  * @param util2 The result of a previous call to eventLoopUtilization() prior to util1
//  */
type eventLoopUtilityFunction = (
  ~util1: eventLoopUtilization=?,
  ~util2: eventLoopUtilization=?,
) => eventLoopUtilization

type performance = {
  now: unit => float,
  /**
     * The timeOrigin specifies the high resolution millisecond timestamp from which all performance metric durations are measured.
     */
  timeOrigin: float,
}

@module("perf_hooks")
external performance: performance = "performance"

type constants = {
  @as("NODE_PERFORMANCE_GC_MAJOR") node_performance_gc_major: float,
  @as("NODE_PERFORMANCE_GC_MINOR") node_performance_gc_minor: float,
  @as("NODE_PERFORMANCE_GC_INCREMENTAL") node_performance_gc_incremental: float,
  @as("NODE_PERFORMANCE_GC_WEAKCB") node_performance_gc_weakcb: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_NO") node_performance_gc_flags_no: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_CONSTRUCT_RETAINED")
  node_performance_gc_flags_construct_retained: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_FORCED") node_performance_gc_flags_forced: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_SYNCHRONOUS_PHANTOM_PROCESSING")
  node_performance_gc_flags_synchronous_phantom_processing: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_ALL_AVAILABLE_GARBAGE")
  node_performance_gc_flags_all_available_garbage: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_ALL_EXTERNAL_MEMORY")
  node_performance_gc_flags_all_external_memory: float,
  @as("NODE_PERFORMANCE_GC_FLAGS_SCHEDULE_IDLE") node_performance_gc_flags_schedule_idle: float,
}

@module("perf_hooks") external constants: constants = "constants"
