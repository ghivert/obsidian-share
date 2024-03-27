import lustre
import toaster/ffi
import toaster/types.{NewToast}

pub fn info(content: String) {
  let toaster_dispatch = ffi.dispatcher()
  NewToast(content)
  |> lustre.dispatch()
  |> toaster_dispatch()
}
