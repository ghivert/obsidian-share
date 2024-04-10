import gleam/function
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import lustre
import lustre/effect
import sketch
import sketch/options as sketch_options
import tardis
import grille_pain/ffi
import grille_pain/lustre/schedule.{schedule}
import grille_pain/model/model.{type Model, Model}
import grille_pain/options.{type Options}
import grille_pain/types.{type Msg} as t
import grille_pain/view.{view}

pub fn setup(opts: Options) {
  ffi.create_node()

  let #(wrapper, activate) =
    opts.debug
    |> option.map(tardis.application(_, "grille-pain"))
    |> option.map(fn(d) { #(tardis.wrap(_, d), tardis.activate(_, d)) })
    |> option.unwrap(#(function.identity, function.identity))

  let render =
    sketch_options.node()
    |> sketch.lustre_setup()
    |> result.unwrap(function.identity)

  let dispatcher =
    fn(_) { #(model.new(opts.timeout), effect.none()) }
    |> lustre.application(update, render(view))
    |> wrapper()
    |> lustre.start("#grille-pain", Nil)
    |> activate()

  dispatcher
  |> result.map_error(io.debug)
  |> result.map(ffi.store_dispatcher)
}

pub fn simple() {
  options.default()
  |> setup()
}

fn update(model: Model, msg: Msg) {
  let time = model.timeout
  case msg {
    t.RemoveToast(id) -> #(model.remove(model, id), effect.none())
    t.StopToast(id) -> #(model.stop(model, id), effect.none())

    t.ShowToast(id) -> {
      let new_model = model.show(model, id)
      let eff = schedule(time, t.HideToast(id, 0))
      #(new_model, eff)
    }

    t.HideToast(id, iteration) ->
      model.toasts
      |> list.find(fn(toast) { toast.id == id && toast.iteration == iteration })
      |> result.map(fn(toast) {
        model
        |> model.hide(toast.id)
        |> model.decrease_bottom(toast.id)
        |> pair.new(schedule(1000, t.RemoveToast(id)))
      })
      |> result.unwrap(#(model, effect.none()))

    t.ResumeToast(id) -> {
      let new_model = model.resume(model, id)
      model.toasts
      |> list.find(fn(toast) { toast.id == id })
      |> result.map(fn(t) {
        schedule(t.remaining, t.HideToast(id, t.iteration))
      })
      |> result.map(fn(eff) { #(new_model, eff) })
      |> result.unwrap(#(new_model, effect.none()))
    }

    t.NewToast(content, level) -> {
      let old_id = model.id
      let new_model = model.add(model, content, level)
      #(new_model, schedule(100, t.ShowToast(old_id)))
    }
  }
}
