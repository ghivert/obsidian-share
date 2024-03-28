import gleam/list
import gleam/int
import lustre/attribute
import lustre/event
import lustre/element/html
import styled
import styled/size.{px}
import toaster/model/model.{type Model, Model}
import toaster/view/colors
import toaster/model/toast.{type Level, type Toast}
import toaster/types.{ResumeToast, StopToast}

pub fn view(model: Model) {
  let Model(toasts, _) = model
  let toasts = list.map(toasts, fn(toast) { view_toast(toast) })
  html.div([], toasts)
}

fn view_toast(toast: Toast) {
  let attrs = [
    color_styles(toast.level),
    base_styles(),
    event.on_mouse_enter(StopToast(toast.id)),
    event.on_mouse_leave(ResumeToast(toast.id)),
  ]
  html.div(
    [
      attribute.style([
        #("padding", "12px"),
        #("position", "fixed"),
        right_position_styles(toast.displayed),
        #("bottom", int.to_string(toast.bottom) <> "px"),
        #("transition", "right 1s, bottom 1s"),
      ]),
      attribute.classes([
        #("toaster-toast", True),
        #("toaster-toast-" <> int.to_string(toast.id), True),
      ]),
    ],
    [
      html.div(attrs, [
        html.div([text_wrapper()], [html.text(toast.content)]),
        html.div([pb_styles(), pb_color(toast.running, toast.level)], []),
      ]),
    ],
  )
}

fn base_styles() {
  styled.class([
    styled.display("flex"),
    styled.flex_direction("column"),
    // Sizes
    styled.width_("var(--toaster-width, 320px)"),
    styled.min_height_("var(--toast-min-height, 64px)"),
    styled.max_height_("var(--toast-max-height, 800px)"),
    // Spacings
    styled.border_radius("var(--toaster-border-radius, 6px)"),
    // Animation
    styled.overflow("hidden"),
  ])
  |> styled.memo()
  |> styled.to_lustre()
}

fn color_styles(level: Level) {
  let #(background, text_color) = colors.from_level(level)
  attribute.style([
    #("background", "var(--toaster-info-background, " <> background <> ")"),
    #("color", "var(--toaster-info-text-color, " <> text_color <> ")"),
  ])
}

fn text_wrapper() {
  styled.class([
    styled.display("flex"),
    styled.align_items("center"),
    styled.flex("1"),
    styled.padding_("8px 16px"),
  ])
  |> styled.memo()
  |> styled.to_lustre()
}

fn pb_styles() {
  styled.class([
    styled.animation("5s linear 0s progress_bar"),
    styled.animation_fill_mode("forwards"),
    styled.height(px(5)),
  ])
  |> styled.memo()
  |> styled.to_lustre()
}

fn pb_color(running: Bool, level: Level) {
  let back = colors.progress_bar_from_level(level)
  attribute.style([
    #("animation-play-state", toast.running_to_string(running)),
    #("background", "var(--toaster-info-progress-bar, " <> back <> ")"),
  ])
}

fn right_position_styles(displayed: Bool) {
  case displayed {
    True -> #("right", "0")
    False -> #("right", "-100%")
  }
}
