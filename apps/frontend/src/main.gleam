import lustre
import lustre/event
import lustre/effect
import lustre/element/html
import layout
// import layout/align
import layout/justify
import content/text
import gleam/int
import styled/media
import styled/size.{px}
import styled

pub type Msg {
  OnClick
}

pub fn main() {
  let app = lustre.application(init, update, view)
  lustre.start(app, "#app", Nil)
}

fn init(_init) {
  #(0, effect.none())
}

fn update(model, _msg) {
  #(model + 1, effect.none())
}

fn view(model) {
  let justif = case model % 2 {
    0 -> justify.Start
    1 | _ -> justify.End
  }
  html.div([styled.to_lustre(display())], [
    layout.column([], [html.text(text.please_auth)]),
    layout.row([layout.justify(justif)], [
      html.button([event.on_click(OnClick)], [
        html.text("Authenticate"),
        html.text(int.to_string(model)),
      ]),
    ]),
  ])
}

fn my_class() {
  styled.class([
    styled.max_width(px(200)),
    styled.color("lemonchiffon"),
    styled.padding(px(12)),
  ])
  |> styled.memo()
}

fn display() {
  styled.class([
    styled.compose(my_class()),
    styled.max_width(px(500)),
    styled.color("red"),
    styled.background("red"),
    styled.hover([styled.background("blue")]),
    styled.media(media.max_width(px(1024)), [
      styled.max_width(px(300)),
      styled.color("blue"),
      styled.hover([styled.background("blue")]),
    ]),
    styled.media(media.max_width(px(1024)), [
      styled.max_width(px(300)),
      styled.color("blue"),
      styled.hover([styled.background("blue")]),
    ]),
  ])
  |> styled.memo()
}
