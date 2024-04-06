import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event
import sketch
import sketch/size.{px}
import toaster/model/model.{type Model, Model}
import toaster/model/toast.{type Level, type Toast}
import toaster/types.{type Msg, HideToast, ResumeToast, StopToast}
import toaster/view/colors
import toaster/view/progress_bar

pub fn view(model: Model) {
  let Model(toasts, _, _) = model
  element.keyed(html.div([attribute.class("grille-pain")], _), {
    use toast <- list.map(toasts)
    let id = int.to_string(toast.id)
    #(id, view_toast_wrapper(toast))
  })
}

fn view_toast_wrapper(toast: Toast) {
  let on_hide = event.on_click(HideToast(toast.id, toast.iteration))
  html.div([wrapper_position_style(toast), wrapper_dom_classes(toast)], [
    view_toast(toast, [
      html.div([text_wrapper(), on_hide], [html.text(toast.content)]),
      progress_bar.view(toast),
    ]),
  ])
}

fn view_toast(toast: Toast, children: List(element.Element(Msg))) {
  html.div(
    [
      toast_colors(toast.level),
      toast_class(),
      event.on_mouse_enter(StopToast(toast.id)),
      event.on_mouse_leave(ResumeToast(toast.id)),
    ],
    children,
  )
}

fn wrapper_position_style(toast: Toast) {
  let min_bot = int.max(0, toast.bottom)
  ["toast", bool.to_string(toast.displayed), int.to_string(min_bot)]
  |> string.join("-")
  |> sketch.dynamic([
    sketch.padding(px(12)),
    sketch.position("fixed"),
    sketch.bottom(px(min_bot)),
    sketch.transition("right 0.7s, bottom 0.7s"),
    case toast.displayed {
      True -> sketch.right(px(0))
      False -> sketch.right_("calc(-1 * var(--toaster-width, 320px) - 100px)")
    },
  ])
  |> sketch.to_lustre()
}

fn wrapper_dom_classes(toast: Toast) {
  let displayed = case toast.displayed {
    True -> "visible"
    False -> "hidden"
  }
  attribute.classes([
    #("toaster-toast", True),
    #("toaster-toast-" <> int.to_string(toast.id), True),
    #("toaster-toast-" <> displayed, True),
  ])
}

fn toast_class() {
  sketch.class([
    sketch.display("flex"),
    sketch.flex_direction("column"),
    // Sizes
    sketch.width_("var(--toaster-width, 320px)"),
    sketch.min_height_("var(--toast-min-height, 64px)"),
    sketch.max_height_("var(--toast-max-height, 800px)"),
    // Spacings
    sketch.border_radius_("var(--toaster-border-radius, 6px)"),
    // Colors
    sketch.box_shadow("0px 4px 12px rgba(0, 0, 0, 0.1)"),
    // Animation
    sketch.overflow("hidden"),
  ])
  |> sketch.to_lustre()
}

fn toast_colors(level: Level) {
  let #(background, text_color) = colors.from_level(level)
  let id = string.join(["toaster", background, text_color], "-")
  sketch.to_lustre(
    sketch.dynamic(id, [
      sketch.background("var(--toaster-info-background, " <> background <> ")"),
      sketch.color("var(--toaster-info-text-color, " <> text_color <> ")"),
    ]),
  )
}

fn text_wrapper() {
  sketch.class([
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.flex("1"),
    sketch.padding_("8px 16px"),
  ])
  |> sketch.to_lustre()
}
