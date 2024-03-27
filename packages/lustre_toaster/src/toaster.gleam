import gleam/io
import gleam/list
import gleam/result
import lustre
import lustre/effect
import toaster/model.{type Model, Model}
import toaster/schedule.{schedule}
import toaster/view.{view}
import toaster/ffi
import toaster/types.{
  type Msg, HideToast, NewToast, RemoveToast, RunToast, ShowToast, StopToast,
}

pub fn setup() {
  let start =
    fn(_) { #(model.empty(), effect.none()) }
    |> lustre.application(update, view)
    |> lustre.start("#toaster", Nil)
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
    ShowToast(id) -> #(model.show(model, id), schedule(5000, HideToast(id, 0)))
    RemoveToast(id) -> #(model.remove(model, id), effect.none())
    StopToast(id) -> #(model.stop(model, id), effect.none())
    HideToast(id, iteration) -> {
      model.toasts
      |> list.find(fn(toast) { toast.id == id })
      |> result.map(fn(toast) {
        case toast.iteration == iteration {
          True -> #(model.hide(model, id), schedule(1000, RemoveToast(id)))
          False -> #(model, effect.none())
        }
      })
      |> result.unwrap(or: #(model, effect.none()))
    }
    RunToast(id) -> {
      let new_model = model.run(model, id)
      let toast = list.find(model.toasts, fn(toast) { toast.id == id })
      case toast {
        Ok(t) -> #(new_model, schedule(t.remaining, HideToast(id, t.iteration)))
        Error(_) -> #(new_model, effect.none())
      }
    }
    NewToast(content) -> {
      let old_id = model.id
      let new_model = model.add(model, content)
      #(new_model, schedule(100, ShowToast(old_id)))
    }
  }
}
