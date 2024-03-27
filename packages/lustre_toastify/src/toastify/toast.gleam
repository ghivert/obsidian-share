import lustre
import lustre/effect
import toastify/ffi
import toastify/types.{NewToast}

pub fn info(content: String) {
  let toastify_dispatch = ffi.dispatcher()
  effect.from(fn(_dispatch) {
    NewToast(content)
    |> lustre.dispatch()
    |> toastify_dispatch()
  })
}
