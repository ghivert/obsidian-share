import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import lustre
import lustre/attribute
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event
import sketch
import sketch/size.{px}
import sketch/options as sketch_options

type Step(model, msg) {
  Step(index: String, model: model, msg: msg)
}

type Model(model, msg) {
  Model(count: Int, steps: List(Step(model, msg)), opened: Bool)
}

@external(javascript, "./tardis.ffi.mjs", "toString")
fn to_s(model: model) -> String

pub fn setup() {
  let assert Ok(render) =
    sketch_options.node()
    |> sketch.lustre_setup()

  fn(_) { #(Model(1, [], False), effect.none()) }
  |> lustre.application(update, render(view))
  |> lustre.start("#tardis", Nil)
  |> result.map(fn(dispatch) {
    fn(update) {
      fn(model, msg) -> #(model, effect.Effect(msg)) {
        let new_state = update(model, msg)

        // Keep model to display it in Tardis
        new_state
        |> pair.first()
        |> AddStep(msg)
        |> lustre.dispatch()
        |> dispatch()

        new_state
      }
    }
  })
}

pub type Msg(model, msg) {
  ToggleOpen
  AddStep(model, msg)
}

fn update(model: Model(model, msg), msg: Msg(model, msg)) {
  case msg {
    ToggleOpen -> {
      let Model(c, s, opened) = model
      #(Model(count: c, steps: s, opened: !opened), effect.none())
    }
    AddStep(m, m_) -> {
      let Model(count, steps, opened) = model
      let step = Step(int.to_string(count), m, m_)
      let new_model =
        Model(count: count + 1, steps: [step, ..steps], opened: opened)
      #(new_model, effect.none())
    }
  }
}

fn tardis_panel() {
  sketch.class([
    sketch.display("flex"),
    sketch.flex_direction("column"),
    sketch.position("fixed"),
    sketch.bottom(px(12)),
    sketch.right(px(12)),
    sketch.background("white"),
    sketch.border_radius(px(10)),
    sketch.box_shadow("0px 0px 5px 1px #ccc"),
    sketch.overflow("hidden"),
    sketch.border("2px solid #ffaa33"),
    sketch.color("#5c6166"),
    sketch.width(px(650)),
    sketch.max_height_("min(1200px, calc(100vh - 24px))"),
  ])
  |> sketch.to_lustre()
}

fn tardis_header() {
  sketch.class([
    sketch.background("white"),
    sketch.padding(px(12)),
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.justify_content("space-between"),
    sketch.font_family("Lexend"),
  ])
  |> sketch.to_lustre()
}

fn tardis_body() {
  sketch.class([
    sketch.display("grid"),
    sketch.grid_template_columns("auto 2fr 3fr"),
    sketch.gap(px(1)),
    sketch.background("#8a919966"),
    sketch.font_family("monospace"),
    sketch.overflow_y("auto"),
    sketch.width_("100%"),
  ])
  |> sketch.to_lustre()
}

fn model_details() {
  sketch.class([
    sketch.display("grid"),
    sketch.grid_column("1 / 4"),
    sketch.grid_template_columns("subgrid"),
    sketch.background("#f8f9fa"),
    sketch.font_size(px(14)),
  ])
  |> sketch.to_lustre()
}

fn step_index() {
  sketch.class([
    sketch.padding_("9px 9px"),
    sketch.justify_self("end"),
    sketch.border_right("1px solid #8a919966"),
    sketch.font_family("Lexend"),
    sketch.color("#787b8099"),
  ])
  |> sketch.to_lustre()
}

fn step_msg() {
  sketch.class([
    sketch.overflow("hidden"),
    sketch.word_break("break-all"),
    sketch.padding(px(9)),
    sketch.border_right("1px solid #8a919966"),
  ])
  |> sketch.to_lustre()
}

fn step_model() {
  sketch.class([
    sketch.overflow("hidden"),
    sketch.word_break("break-all"),
    sketch.padding(px(6)),
  ])
  |> sketch.to_lustre()
}

fn view_model(item: Step(model, msg)) {
  let Step(index, model, msg) = item
  html.div([model_details()], [
    html.div([step_index()], [html.text(index)]),
    html.div([step_msg()], [html.text(to_s(msg))]),
    html.div([step_model()], [html.text(to_s(model))]),
  ])
}

fn interaction_section() {
  sketch.class([
    sketch.display("flex"),
    sketch.gap(px(12)),
    sketch.align_items("center"),
  ])
  |> sketch.to_lustre()
}

fn toggle_button() {
  sketch.class([])
  |> sketch.to_lustre()
}

fn view(model: Model(model, msg)) {
  let border_bottom = case model.opened, model.count {
    False, _ | True, 1 -> attribute.none()
    True, _ -> attribute.style([#("border-bottom", "2px solid #ffaa33")])
  }
  let toggle_action = event.on_click(ToggleOpen)
  html.div([attribute.class("tardis")], [
    html.div([tardis_panel()], [
      html.div([tardis_header(), border_bottom], [
        html.div([], [html.text("Debugger")]),
        html.div([interaction_section()], [
          html.div([], [html.text(int.to_string(model.count - 1) <> " Steps")]),
          html.button([toggle_button(), toggle_action], [
            html.text(case model.opened {
              True -> "Close"
              False -> "Open"
            }),
          ]),
        ]),
      ]),
      case model.opened {
        False -> element.none()
        True ->
          element.keyed(html.div([tardis_body()], _), {
            use item <- list.map(model.steps)
            let child = view_model(item)
            #(item.index, child)
          })
      },
    ]),
  ])
}
