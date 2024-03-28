import lustre.{type Action, type ClientSpa}
import toaster/types.{type Msg}

pub type Dispatch =
  fn(Action(Msg, ClientSpa)) -> Nil

@external(javascript, "../lustre_toaster_ffi.mjs", "storeDispatcher")
pub fn store_dispatcher(_dispatcher: Dispatch) -> Dispatch {
  fn(_a) { Nil }
}

@external(javascript, "../lustre_toaster_ffi.mjs", "getDispatcher")
pub fn dispatcher() -> Dispatch {
  fn(_a) { Nil }
}

@external(javascript, "../lustre_toaster_ffi.mjs", "isDarkTheme")
pub fn is_dark_theme() -> Bool {
  False
}

@external(javascript, "../lustre_toaster_ffi.mjs", "computeToastSize")
pub fn compute_toast_size(id: Int) -> Int
