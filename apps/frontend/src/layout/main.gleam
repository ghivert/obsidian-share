import gleam/string
import lustre/event
import lustre/element/html
import styled
import styled/size.{px, vh}
import types.{type Model}
import layout
import toaster/lustre/toast

pub fn main_layout(_model: Model) {
  html.div([styled.to_lustre(main_styles())], [header(), navbar(), body()])
}

fn main_styles() {
  let template_areas =
    ["\"header header\"", "\"navbar body\""]
    |> string.join("\n")
    |> styled.grid_template_areas()

  styled.class([
    styled.display("grid"),
    template_areas,
    styled.grid_template_columns("auto 1fr"),
    styled.grid_template_rows("auto 1fr"),
    styled.min_height(vh(100)),
  ])
  |> styled.memo()
}

fn header() {
  html.nav([styled.to_lustre(header_styles())], [
    layout.row([layout.gap(12)], [
      html.div([], [html.text("Obsidian Share")]),
      html.div([], [html.text("Home")]),
    ]),
    html.div([], [html.text("Logout")]),
  ])
}

fn header_styles() {
  styled.class([
    styled.grid_area("header"),
    styled.padding(px(12)),
    styled.border_bottom("1px solid var(--border-color)"),
    styled.display("flex"),
    styled.justify_content("space-between"),
  ])
  |> styled.memo()
}

fn navbar() {
  html.nav([styled.to_lustre(navbar_styles())], [html.text("Navbar")])
}

fn navbar_styles() {
  styled.class([
    styled.grid_area("navbar"),
    styled.padding(px(12)),
    styled.border_right("1px solid var(--border-color)"),
  ])
  |> styled.memo()
}

fn body() {
  let on_click =
    event.on_click(types.PerformEffect(toast.info("This is an info toast")))
  html.nav([styled.to_lustre(body_styles())], [
    html.text("Body"),
    html.button([on_click], [html.text("Click me")]),
  ])
}

fn body_styles() {
  styled.class([styled.grid_area("body")])
  |> styled.memo()
}
