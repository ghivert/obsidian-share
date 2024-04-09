import gleam/io
import gleam/list
import gleam/result
import lustre
import lustre/effect
import toaster/ffi
import toaster/lustre/schedule.{schedule}
import toaster/model/model.{type Model, Model}
import toaster/options.{type Options}
import toaster/types.{
  type Msg, HideToast, NewToast, RemoveToast, ResumeToast, ShowToast, StopToast,
}
import toaster/view.{view}

pub fn setup(options: Options) {
  ffi.create_node()

  let dispatcher =
    fn(_) { #(model.new(options), effect.none()) }
    |> lustre.application(update, view)
    |> lustre.start("#grille-pain", Nil)

  dispatcher
  |> result.map_error(io.debug)
  |> result.map(ffi.store_dispatcher)
}

pub fn simple() {
  setup(options.default())
}

fn update(model: Model, msg: Msg) {
  let time = model.options.timeout
  case msg {
    ShowToast(id) -> #(model.show(model, id), schedule(time, HideToast(id, 0)))
    RemoveToast(id) -> #(model.remove(model, id), effect.none())
    StopToast(id) -> #(model.stop(model, id), effect.none())
    HideToast(id, iteration) ->
      model.toasts
      |> list.find(fn(toast) { toast.id == id && toast.iteration == iteration })
      |> result.map(fn(toast) {
        let new_model =
          model
          |> model.hide(toast.id)
          |> model.decrease_bottom(toast.id)
        #(new_model, schedule(1000, RemoveToast(id)))
      })
      |> result.unwrap(or: #(model, effect.none()))
    ResumeToast(id) -> {
      let new_model = model.resume(model, id)
      list.find(model.toasts, fn(toast) { toast.id == id })
      |> result.map(fn(t) { schedule(t.remaining, HideToast(id, t.iteration)) })
      |> result.map(fn(eff) { #(new_model, eff) })
      |> result.unwrap(#(new_model, effect.none()))
    }
    NewToast(content, level) -> {
      let old_id = model.id
      let new_model = model.add(model, content, level)
      #(new_model, schedule(100, ShowToast(old_id)))
    }
  }
}
