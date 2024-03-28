import birl

pub type Toast {
  Toast(
    id: Int,
    content: String,
    displayed: Bool,
    running: Bool,
    remaining: Int,
    last_schedule: birl.Time,
    iteration: Int,
    bottom: Int,
    level: Level,
  )
}

pub type Level {
  Standard
  Info
  Warning
  Error
  Success
}

@external(javascript, "../../lustre_toaster_ffi.mjs", "computeBottomPosition")
fn compute_bottom_position() -> Int

pub fn new(id: Int, content: String, level: Level) {
  Toast(
    id: id,
    content: content,
    displayed: False,
    running: False,
    remaining: 5000,
    last_schedule: birl.now(),
    iteration: 0,
    bottom: compute_bottom_position(),
    level: level,
  )
}

pub fn running_to_string(running: Bool) {
  case running {
    True -> "running"
    False -> "paused"
  }
}
