import lustre
import lustre/attribute
import lustre/effect
import lustre/element/html
import layout
// import layout/align
import layout/justify
import content/text

pub fn main() {
  let app = lustre.application(init, update, view)
  lustre.start(app, "#app", Nil)
}

fn init(_init) {
  #(0, effect.none())
}

fn update(model, _msg) {
  #(model, effect.none())
}

fn view(_model) {
  layout.column_(
    [layout.gap(12)],
    [attribute.style([#("max-width", "400px")])],
    [
      layout.column([], [html.text(text.please_auth)]),
      layout.row([layout.justify(justify.End)], [
        html.button([], [html.text("Authenticate")]),
      ]),
    ],
  )
}
