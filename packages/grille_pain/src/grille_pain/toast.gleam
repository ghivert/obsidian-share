import lustre
import grille_pain/ffi
import grille_pain/model/toast.{
  type Level, Error, Info, Standard, Success, Warning,
}
import grille_pain/types.{NewToast}

fn dispatch_toast(content: String, level: Level) {
  let grille_pain_dispatch = ffi.dispatcher()
  NewToast(content, level)
  |> lustre.dispatch()
  |> grille_pain_dispatch()
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
