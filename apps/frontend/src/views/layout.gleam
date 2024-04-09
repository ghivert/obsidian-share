import gleam/list
import gleam/string
import layout
import lustre/element
import lustre/element/html
import sketch
import sketch/size.{px, vh}
import types.{type Model, Disconnected}
import views/login_page/view as auth

pub fn main_layout(model: Model) {
  let nav = select_navbar(model)
  sketch.class([
    sketch.background("radial-gradient(purple -155%, transparent)"),
    sketch.display("grid"),
    sketch.grid_template_columns("auto 1fr"),
    sketch.grid_template_rows("auto 1fr"),
    sketch.min_height(vh(100)),
    ["\"header header\"", "\"navbar body\""]
      |> string.join("\n")
      |> sketch.grid_template_areas(),
  ])
  |> sketch.to_lustre()
  |> list.repeat(1)
  |> html.div([header(model), nav, body(model)])
}

fn select_header_style(model: Model) {
  case model {
    Disconnected(_, _) -> transparent_header_sketch()
    _ -> bordered_header_sketch()
  }
}

fn select_navbar(model: Model) {
  case model {
    Disconnected(_, _) -> element.none()
    _ -> navbar()
  }
}

fn header(model: Model) {
  select_header_style(model)
  |> sketch.to_lustre()
  |> list.repeat(1)
  |> html.nav([
    layout.row([layout.gap(12)], [html.div([], [html.text("Obsidian Share")])]),
  ])
  // html.div([], [html.text("Home")]),
  // html.div([], [html.text("Logout")]),
}

fn bordered_header_sketch() {
  sketch.class([
    sketch.compose(transparent_header_sketch()),
    sketch.border_bottom("1px solid var(--border-color)"),
  ])
}

fn transparent_header_sketch() {
  sketch.class([
    sketch.grid_area("header"),
    sketch.padding(px(24)),
    sketch.display("flex"),
    sketch.justify_content("space-between"),
    sketch.z_index(1),
  ])
}

fn navbar() {
  sketch.class([
    sketch.grid_area("navbar"),
    sketch.padding(px(12)),
    sketch.border_right("1px solid var(--border-color)"),
  ])
  |> sketch.to_lustre()
  |> list.repeat(1)
  |> html.nav([html.text("Navbar")])
}

fn body(model: types.Model) {
  case model {
    Disconnected(username, password) -> auth.login_page(username, password)
    _ -> element.none()
  }
}
