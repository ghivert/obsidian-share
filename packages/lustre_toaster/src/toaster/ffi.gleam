import lustre.{type Action, type ClientSpa}
import toaster/types.{type Msg}

pub type Dispatch =
  fn(Action(Msg, ClientSpa)) -> Nil

@external(javascript, "../toaster.ffi.mjs", "storeDispatcher")
pub fn store_dispatcher(dispatcher: Dispatch) -> Dispatch {
  dispatcher
}

@external(javascript, "../toaster.ffi.mjs", "getDispatcher")
pub fn dispatcher() -> Dispatch {
  fn(_) { Nil }
}

@external(javascript, "../toaster.ffi.mjs", "isDarkTheme")
pub fn is_dark_theme() -> Bool {
  False
}

@external(javascript, "../toaster.ffi.mjs", "computeToastSize")
pub fn compute_toast_size(id: Int) -> Int

@external(javascript, "../toaster.ffi.mjs", "createNode")
pub fn create_node() -> Nil
