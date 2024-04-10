import gleam/dynamic.{type Dynamic}
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/result
import lustre.{type Action, type App}
import lustre/attribute as a
import lustre/effect.{type Effect}
import lustre/element as el
import lustre/element/html as h
import lustre/event
import lustre/internals/runtime
import sketch
import sketch/options as sketch_options
import tardis/data/colors
import tardis/data/debugger as debugger_
import tardis/data/model.{type Model, Model}
import tardis/data/msg.{type Msg}
import tardis/setup
import tardis/styles as s
import tardis/view as v

type Middleware =
  fn(Dynamic, Dynamic) -> Nil

pub opaque type Instance {
  Instance(dispatch: fn(Action(Msg, lustre.ClientSpa)) -> Nil)
}

pub opaque type Tardis {
  Tardis(#(fn(Dynamic) -> Nil, Middleware))
}

fn wrap_init(middleware: Middleware) {
  fn(init) {
    fn(flags) {
      let new_state = init(flags)
      new_state
      |> pair.first()
      |> dynamic.from()
      |> middleware(dynamic.from("Init"))
      new_state
    }
  }
}

fn wrap_update(middleware: Middleware) {
  fn(update) {
    fn(model, msg) {
      let new_state = update(model, msg)
      new_state
      |> pair.first()
      |> dynamic.from()
      |> middleware(dynamic.from(msg))
      new_state
    }
  }
}

pub fn wrap(application: App(a, b, c), tardis: Tardis) {
  let Tardis(#(_, middleware)) = tardis
  update_lustre(application, wrap_init(middleware), wrap_update(middleware))
}

pub fn activate(result: Result(fn(Action(a, b)) -> Nil, c), tardis: Tardis) {
  use dispatch <- result.map(result)
  let Tardis(#(dispatcher, _)) = tardis
  dispatcher(dynamic.from(dispatch))
  dispatch
}

@external(javascript, "./tardis.ffi.mjs", "updateLustre")
fn update_lustre(
  application: App(a, b, c),
  init_mapper: fn(fn(flags) -> #(model, Effect(msg))) ->
    fn(flags) -> #(model, Effect(msg)),
  update_mapper: fn(fn(model, msg) -> #(model, Effect(msg))) ->
    fn(model, msg) -> #(model, Effect(msg)),
) -> App(a, b, c)

fn create_model_updater(
  application: String,
  dispatch: fn(Action(Msg, c)) -> Nil,
) {
  fn(dispatcher: Dynamic) {
    fn(model: Dynamic) -> Effect(Msg) {
      effect.from(fn(_) {
        model
        |> dynamic.from()
        |> runtime.UpdateModel()
        |> dynamic.unsafe_coerce(dispatcher)
      })
    }
    |> msg.AddApplication(application, _)
    |> lustre.dispatch()
    |> dispatch()
  }
}

pub fn setup() {
  let #(shadow_root, lustre_root) = setup.mount_shadow_node()

  // Attach the StyleSheet to the Shadow DOM.
  let renderer =
    sketch_options.shadow(shadow_root)
    |> sketch.lustre_setup()

  renderer
  |> result.map(fn(r) { lustre.application(init, update, r(view)) })
  |> result.map_error(fn(error) {
    io.debug("Unable to start sketch. Check your configuration.")
    io.debug(error)
    lustre.NotErlang
  })
  |> result.then(lustre.start(_, lustre_root, Nil))
  |> result.map(fn(dispatch) { Instance(dispatch) })
}

pub fn single(name: String) {
  setup()
  |> result.map(application(_, name))
}

fn step_adder(instance: Instance, name: String) {
  fn(model, msg) {
    model
    |> msg.AddStep(name, _, msg)
    |> lustre.dispatch()
    |> instance.dispatch()
  }
}

pub fn application(instance: Instance, name: String) {
  let updater = create_model_updater(name, instance.dispatch)
  let adder = step_adder(instance, name)
  Tardis(#(updater, adder))
}

fn init(_) {
  colors.choose_color_scheme()
  |> Model(
    debuggers: [],
    frozen: False,
    opened: False,
    color_scheme: _,
    selected_debugger: option.None,
  )
  |> pair.new(effect.none())
}

fn update(model: Model, msg: Msg) {
  case msg {
    msg.ToggleOpen -> #(Model(..model, opened: !model.opened), effect.none())

    msg.Restart(debugger_) -> {
      let restart_effect =
        model.debuggers
        |> debugger_.get(debugger_)
        |> result.then(fn(d) {
          d.steps
          |> list.first()
          |> result.then(fn(item) {
            d.dispatcher
            |> option.map(function.apply1(_, item.model))
            |> option.to_result(Nil)
          })
        })
        |> result.unwrap(effect.none())

      model.debuggers
      |> debugger_.replace(debugger_, debugger_.unselect)
      |> fn(ds) { Model(..model, frozen: False, debuggers: ds) }
      |> pair.new(restart_effect)
    }

    msg.UpdateColorScheme(cs) ->
      Model(..model, color_scheme: cs)
      |> pair.new(colors.save_color_scheme(cs))

    msg.AddApplication(debugger_, dispatcher) ->
      model.debuggers
      |> debugger_.replace(debugger_, debugger_.add_dispatcher(_, dispatcher))
      |> fn(d) { Model(..model, debuggers: d) }
      |> pair.new(effect.none())

    msg.BackToStep(debugger_, item) -> {
      let selected_step = option.Some(item.index)
      let model_effect =
        model.debuggers
        |> debugger_.get(debugger_)
        |> result.then(fn(d) {
          d.dispatcher
          |> option.map(function.apply1(_, item.model))
          |> option.to_result(Nil)
        })
        |> result.unwrap(effect.none())

      model.debuggers
      |> debugger_.replace(debugger_, debugger_.select(_, selected_step))
      |> fn(d) { Model(..model, frozen: True, debuggers: d) }
      |> pair.new(model_effect)
    }

    msg.Debug(value) -> {
      io.debug(value)
      #(model, effect.none())
    }

    msg.SelectDebugger(debugger_) ->
      Model(..model, selected_debugger: option.Some(debugger_))
      |> pair.new(effect.none())

    msg.AddStep(debugger_, m, m_) -> {
      model.debuggers
      |> debugger_.replace(debugger_, debugger_.add_step(_, m, m_))
      |> fn(d) { Model(..model, debuggers: d) }
      |> model.optional_set_debugger(debugger_)
      |> pair.new(effect.none())
    }
  }
}

fn select_panel_options(panel_opened: Bool) {
  case panel_opened {
    True -> #(s.panel(), s.bordered_header(), "Close")
    False -> #(s.panel_closed(), s.header(), "Open")
  }
}

fn on_cs_input(content) {
  let cs = colors.cs_from_string(content)
  msg.UpdateColorScheme(cs)
}

fn on_debugger_input(content) {
  msg.SelectDebugger(content)
}

fn view(model: Model) {
  let color_scheme_class = colors.get_color_scheme_class(model.color_scheme)
  let #(panel, header, button_txt) = select_panel_options(model.opened)
  let frozen_panel = case model.frozen {
    True -> s.frozen_panel()
    False -> a.none()
  }
  let debugger_ =
    model.selected_debugger
    |> option.unwrap("")
    |> debugger_.get(model.debuggers, _)
  h.div([a.class("debugger_"), color_scheme_class, frozen_panel], [
    h.div([panel], [
      h.div([header], [
        h.div([s.flex(), s.debugger_title()], [
          h.div([], [h.text("Debugger")]),
          case model.opened {
            False -> el.none()
            True ->
              h.select([event.on_input(on_cs_input), s.select_cs()], {
                use item <- list.map(colors.themes())
                let as_s = colors.cs_to_string(item)
                let selected = model.color_scheme == item
                h.option([a.value(as_s), a.selected(selected)], as_s)
              })
          },
          case model.frozen, model.selected_debugger {
            True, Some(debugger_) ->
              h.button([s.select_cs(), event.on_click(msg.Restart(debugger_))], [
                h.text("Restart"),
              ])
            _, _ -> el.none()
          },
        ]),
        case debugger_ {
          Error(_) -> el.none()
          Ok(debugger_) ->
            h.div([s.actions_section()], [
              h.select([event.on_input(on_debugger_input), s.select_cs()], {
                list.filter(model.debuggers, fn(debugger_) {
                  let steps = pair.second(debugger_).steps
                  !list.is_empty(steps)
                })
                |> list.map(fn(i) {
                  let #(item, _) = i
                  let selected = model.selected_debugger == Some(item)
                  h.option([a.value(item), a.selected(selected)], item)
                })
              }),
              h.div([], [h.text(int.to_string(debugger_.count - 1) <> " Steps")]),
              h.button([s.toggle_button(), event.on_click(msg.ToggleOpen)], [
                h.text(button_txt),
              ]),
            ])
        },
      ]),
      case debugger_, model.selected_debugger {
        Ok(debugger_), Some(d) -> v.view_model(model.opened, d, debugger_)
        _, _ -> el.none()
      },
    ]),
  ])
}
