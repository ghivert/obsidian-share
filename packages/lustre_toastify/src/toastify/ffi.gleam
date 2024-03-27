import lustre.{type Action, type ClientSpa}
import toastify/types.{type Msg}

pub type Dispatch =
  fn(Action(Msg, ClientSpa)) -> Nil

@external(javascript, "../lustre_toastify_ffi.mjs", "storeDispatcher")
pub fn store_dispatcher(_dispatcher: Dispatch) -> Dispatch {
  fn(_a) { Nil }
}

@external(javascript, "../lustre_toastify_ffi.mjs", "getDispatcher")
pub fn dispatcher() -> Dispatch {
  fn(_a) { Nil }
}
