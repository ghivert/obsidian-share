import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/result
import lustre.{type Action}
import lustre/attribute as a
import lustre/internals/runtime
import lustre/effect.{type Effect}
import lustre/element as el
import lustre/element/html as h
import lustre/event
import plinth/browser/element
import plinth/browser/shadow
import plinth/browser/document
import sketch
import sketch/options as sketch_options
import tardis/data/colors
import tardis/data/debugger.{Debugger} as debugger_
import tardis/data/model.{type Model, Model}
import tardis/data/msg.{type Msg}
import tardis/data/step.{type Step, Step}
import tardis/styles as s
import tardis/view as v

fn create_model_updater(
  application: String,
  dispatch: fn(Action(Msg, c)) -> Nil,
) {
  fn(dispatcher: Dynamic) {
    fn(model: Dynamic) -> Effect(Msg) {
      effect.from(fn(_) {
        io.debug(dynamic.unsafe_coerce(dispatcher))
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

fn create_tardis_nodes() {
  // Instanciate the Shadow DOM wrapper.
  let div = document.create_element("div")
  element.append_child(document.body(), div)
  element.set_attribute(div, "class", "tardis")

  // Instanciate the Shadow DOM lustre node.
  let root = document.create_element("div")
  element.set_attribute(root, "id", "tardis-start")
  let selector: String = dynamic.unsafe_coerce(dynamic.from(root))

  // Instanciate the Shadow DOM itself.
  let shadow_root = shadow.attach_shadow(div, shadow.Open)
  shadow.append_child(shadow_root, root)

  #(shadow_root, selector)
}

pub fn setup() {
  let #(shadow_root, selector) = create_tardis_nodes()

  // Attach the StyleSheet to the Shadow DOM.
  let assert Ok(render) =
    sketch_options.shadow(shadow_root)
    |> sketch.lustre_setup()

  lustre.application(init, update, render(view))
  |> lustre.start(selector, Nil)
  |> result.map(fn(dispatch) {
    fn(application: String) {
      #(create_model_updater(application, dispatch), fn(update) {
        fn(model, msg) -> #(model, effect.Effect(msg)) {
          let new_state = update(model, msg)

          // Keep model to display it in Tardis
          pair.first(new_state)
          |> dynamic.from()
          |> msg.AddStep(application, _, dynamic.from(msg))
          |> lustre.dispatch()
          |> dispatch()

          new_state
        }
      })
    }
  })
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
          |> result.map(fn(item) { d.dispatcher(item.model) })
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
      |> list.key_set(debugger_, debugger_.init(dispatcher))
      |> fn(d) {
        let selected = option.or(model.selected_debugger, Some(debugger_))
        Model(..model, debuggers: d, selected_debugger: selected)
      }
      |> pair.new(effect.none())

    msg.BackToStep(debugger_, item) -> {
      let selected_step = option.Some(item.index)
      let model_effect =
        model.debuggers
        |> debugger_.get(debugger_)
        |> result.map(fn(d) { d.dispatcher(item.model) })
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
      |> debugger_.replace(debugger_, fn(d) {
        let step = Step(int.to_string(d.count), m, m_)
        Debugger(..d, count: d.count + 1, steps: [step, ..d.steps])
      })
      |> fn(d) { Model(..model, debuggers: d) }
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
                use #(item, _) <- list.map(model.debuggers)
                let selected = model.selected_debugger == Some(item)
                h.option([a.value(item), a.selected(selected)], item)
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
