import gleam/string
import lustre/event.{on_click}
import lustre/element/html
import styled
import styled/size.{px, vh}
import types.{type Model, PerformEffect}
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
  let on_std = on_click(PerformEffect(toast.toast("This is an std toast")))
  let on_info = on_click(PerformEffect(toast.info("This is an info toast")))
  let on_success = on_click(PerformEffect(toast.success("This is an su toast")))
  let on_warning = on_click(PerformEffect(toast.warning("This is an wn toast")))
  let on_error = on_click(PerformEffect(toast.error("This is an er toast")))
  html.nav([styled.to_lustre(body_styles())], [
    html.text("Body"),
    html.button([on_std], [html.text("Click me standard")]),
    html.button([on_info], [html.text("Click me info")]),
    html.button([on_success], [html.text("Click me success")]),
    html.button([on_warning], [html.text("Click me warning")]),
    html.button([on_error], [html.text("Click me error")]),
  ])
}

fn body_styles() {
  styled.class([styled.grid_area("body")])
  |> styled.memo()
}
