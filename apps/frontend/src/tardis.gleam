import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import lustre.{type Action}
import lustre/attribute as a
import lustre/internals/runtime
import lustre/effect.{type Effect}
import lustre/element as el
import lustre/element/html as h
import lustre/event
import sketch
import sketch/options as sketch_options
import tardis/data/colors
import tardis/data/model.{type Model, Model}
import tardis/data/msg.{type Msg}
import tardis/data/step.{type Step, Step}
import tardis/styles as s
import tardis/view as v

fn create_model_updater(dispatch: fn(Action(Msg(model, msg), c)) -> Nil) {
  fn(dispatcher: fn(Action(d, e)) -> Nil) {
    fn(model: model) -> Effect(Msg(model, msg)) {
      effect.from(fn(_) {
        model
        |> dynamic.from()
        |> runtime.UpdateModel()
        |> dispatcher()
      })
    }
    |> msg.AddApplication()
    |> lustre.dispatch()
    |> dispatch()
  }
}

pub fn setup() {
  let assert Ok(render) =
    sketch_options.node()
    |> sketch.lustre_setup()

  lustre.application(init, update, render(view))
  |> lustre.start("#tardis", Nil)
  |> result.map(fn(dispatch) {
    #(create_model_updater(dispatch), fn(update) {
      fn(model, msg) -> #(model, effect.Effect(msg)) {
        let new_state = update(model, msg)

        // Keep model to display it in Tardis
        pair.first(new_state)
        |> msg.AddStep(msg)
        |> lustre.dispatch()
        |> dispatch()

        new_state
      }
    })
  })
}

fn init(_) {
  colors.choose_color_scheme()
  |> Model(
    count: 1,
    steps: [],
    opened: False,
    color_scheme: _,
    dispatcher: fn(_) { effect.none() },
    frozen: False,
    selected_step: option.None,
  )
  |> pair.new(effect.none())
}

fn update(model: Model(model, msg), msg: Msg(model, msg)) {
  case msg {
    msg.ToggleOpen -> #(Model(..model, opened: !model.opened), effect.none())

    msg.Restart -> {
      model.steps
      |> list.first()
      |> result.map(fn(item) { model.dispatcher(item.model) })
      |> result.unwrap(effect.none())
      |> pair.new(Model(..model, frozen: False, selected_step: option.None), _)
    }

    msg.UpdateColorScheme(cs) ->
      Model(..model, color_scheme: cs)
      |> pair.new(colors.save_color_scheme(cs))

    msg.AddApplication(dispatcher) ->
      Model(..model, dispatcher: dispatcher)
      |> pair.new(effect.none())

    msg.BackToStep(item) -> {
      option.Some(item.index)
      |> fn(s) { Model(..model, frozen: True, selected_step: s) }
      |> pair.new(model.dispatcher(item.model))
    }

    msg.Debug(value) -> {
      io.debug(value)
      #(model, effect.none())
    }

    msg.AddStep(m, m_) -> {
      let count = model.count
      let steps = model.steps
      let step = Step(int.to_string(count), m, m_)
      let new_model = Model(..model, count: count + 1, steps: [step, ..steps])
      #(new_model, effect.none())
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

fn view(model: Model(model, msg)) {
  let color_scheme_class = colors.get_color_scheme_class(model.color_scheme)
  let #(panel, header, button_txt) = select_panel_options(model.opened)
  let frozen_panel = case model.frozen {
    True -> s.frozen_panel()
    False -> a.none()
  }
  h.div([a.class("debugger"), color_scheme_class, frozen_panel], [
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
          case model.frozen {
            False -> el.none()
            True ->
              h.button([s.select_cs(), event.on_click(msg.Restart)], [
                h.text("Restart"),
              ])
          },
        ]),
        h.div([s.actions_section()], [
          h.div([], [h.text(int.to_string(model.count - 1) <> " Steps")]),
          h.button([s.toggle_button(), event.on_click(msg.ToggleOpen)], [
            h.text(button_txt),
          ]),
        ]),
      ]),
      v.view_model(model),
    ]),
  ])
}
