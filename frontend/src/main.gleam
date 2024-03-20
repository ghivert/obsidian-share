import lustre
import lustre/attribute
import lustre/effect
import lustre/element/html
import layout
// import layout/align
import layout/justify
import content/text
import styled/media
import styled/size.{px}
import styled/styled

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
  html.div([styled.from_class(display())], [
    layout.column([], [html.text(text.please_auth)]),
    layout.row([layout.justify(justify.End)], [
      html.button([], [html.text("Authenticate")]),
    ]),
  ])
}

fn my_class() {
  styled.class([
    styled.max_width(px(200)),
    styled.color("lemonchiffon"),
    styled.padding(px(12)),
  ])
}

fn display() {
  styled.class([
    styled.extend(my_class()),
    styled.max_width(px(500)),
    styled.color("red"),
    styled.media(media.max_width(px(1024)), [
      styled.max_width(px(300)),
      styled.color("blue"),
    ]),
  ])
}
