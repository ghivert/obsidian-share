import gleam/io
import lustre
import lustre/effect
import toastify/model.{type Model, Model}
import toastify/schedule.{schedule}
import toastify/view.{view}
import toastify/ffi
import toastify/types.{type Msg, HideToast, NewToast, RemoveToast, ShowToast}

pub fn setup() {
  let start =
    fn(_) { #(model.empty(), effect.none()) }
    |> lustre.application(update, view)
    |> lustre.start("#toastify", Nil)
  case start {
    Error(err) -> {
      io.debug(err)
      Error(err)
    }
    Ok(dispatcher) -> {
      ffi.store_dispatcher(dispatcher)
      Ok(Nil)
    }
  }
}

fn update(model: Model, msg: Msg) {
  case msg {
    ShowToast(id) -> #(model.show(model, id), schedule(5000, HideToast(id)))
    HideToast(id) -> #(model.hide(model, id), schedule(1000, RemoveToast(id)))
    RemoveToast(id) -> #(model.remove(model, id), effect.none())
    NewToast(content) -> {
      let old_id = model.id
      let new_model = model.add(model, content)
      #(new_model, schedule(100, ShowToast(old_id)))
    }
  }
}
