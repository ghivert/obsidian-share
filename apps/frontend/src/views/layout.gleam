import gleam/list
import gleam/string
import layout
import lustre/element
import lustre/element/html
import lustre/event.{on_click}
import styled
import styled/size.{px, vh}
import toaster/lustre/toast
import types.{type Model, Authenticate, Disconnected, PerformEffect}
import views/login_page/view as auth

pub fn main_layout(model: Model) {
  let nav = select_navbar(model)
  styled.class([
    styled.background("radial-gradient(purple -155%, transparent)"),
    styled.display("grid"),
    styled.grid_template_columns("auto 1fr"),
    styled.grid_template_rows("auto 1fr"),
    styled.min_height(vh(100)),
    ["\"header header\"", "\"navbar body\""]
      |> string.join("\n")
      |> styled.grid_template_areas(),
  ])
  |> styled.to_lustre()
  |> list.repeat(1)
  |> html.div([header(model), nav, body(model)])
}

fn select_header_style(model: Model) {
  case model {
    Disconnected(_, _) -> transparent_header_styled()
    _ -> bordered_header_styled()
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
  |> styled.to_lustre()
  |> list.repeat(1)
  |> html.nav([
    layout.row([layout.gap(12)], [html.div([], [html.text("Obsidian Share")])]),
  ])
  // html.div([], [html.text("Home")]),
  // html.div([], [html.text("Logout")]),
}

fn bordered_header_styled() {
  styled.class([
    styled.compose(transparent_header_styled()),
    styled.border_bottom("1px solid var(--border-color)"),
  ])
}

fn transparent_header_styled() {
  styled.class([
    styled.grid_area("header"),
    styled.padding(px(24)),
    styled.display("flex"),
    styled.justify_content("space-between"),
    styled.z_index(1),
  ])
}

fn navbar() {
  styled.class([
    styled.grid_area("navbar"),
    styled.padding(px(12)),
    styled.border_right("1px solid var(--border-color)"),
  ])
  |> styled.to_lustre()
  |> list.repeat(1)
  |> html.nav([html.text("Navbar")])
}

fn body(model: types.Model) {
  case model {
    Disconnected(username, password) -> auth.login_page(username, password)
    _ -> element.none()
  }
}
