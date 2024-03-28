import lustre
import toaster/ffi
import toaster/types.{NewToast}
import toaster/model/toast.{type Level, Error, Info, Standard, Success, Warning}

fn dispatch_toast(content: String, level: Level) {
  let toaster_dispatch = ffi.dispatcher()
  NewToast(content, level)
  |> lustre.dispatch()
  |> toaster_dispatch()
}

pub fn info(content: String) {
  dispatch_toast(content, Info)
}

pub fn success(content: String) {
  dispatch_toast(content, Success)
}

pub fn error(content: String) {
  dispatch_toast(content, Error)
}

pub fn toast(content: String) {
  dispatch_toast(content, Standard)
}

pub fn warning(content: String) {
  dispatch_toast(content, Warning)
}
