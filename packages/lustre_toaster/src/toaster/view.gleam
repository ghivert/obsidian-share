import gleam/list
import lustre/event
import lustre/element/html
import styled
import styled/size.{percent, px}
import toaster/model.{type Model, type Toast, Model}
import toaster/types.{RunToast, StopToast}

pub fn view(model: Model) {
  let Model(toasts, _) = model
  let toasts = list.map(toasts, fn(toast) { view_toast(toast) })
  html.div([], toasts)
}

fn view_toast(toast: Toast) {
  html.div(
    [
      styled.to_lustre(display_move(toast.displayed)),
      styled.to_lustre(display_styles()),
      event.on_mouse_enter(StopToast(toast.id)),
      event.on_mouse_leave(RunToast(toast.id)),
    ],
    [
      html.div([styled.to_lustre(text_wrapper())], [html.text(toast.content)]),
      html.div([styled.to_lustre(progress_bar(toast.running))], []),
    ],
  )
}

fn display_styles() {
  styled.class([
    styled.display("flex"),
    styled.flex_direction("column"),
    // Sizes
    styled.width_("var(--toaster-width, 320px)"),
    styled.min_height_("var(--toast-min-height, 64px)"),
    styled.max_height_("var(--toast-max-height, 800px)"),
    // Position
    styled.position("fixed"),
    styled.bottom(px(0)),
    styled.right(px(0)),
    // Spacings
    styled.margin(px(12)),
    styled.border_radius("var(--toaster-border-radius, 6px)"),
    // Colors
    styled.background("var(--toaster-info-background, #07bc0c)"),
    styled.color("var(--toaster-info-text-color, #fff)"),
    // Animation
    styled.transition("right 1s"),
    styled.overflow("hidden"),
  ])
  |> styled.memo()
}

fn text_wrapper() {
  styled.class([
    styled.display("flex"),
    styled.align_items("center"),
    styled.flex("1"),
    styled.padding_("8px 16px"),
  ])
}

pub const gradient = "linear-gradient(to right, #4cd964, #5ac8fa, #007aff, #34aadc, #5856d6, #ff2d55)"

fn progress_bar(running: Bool) {
  let run = case running {
    True -> "running"
    False -> "paused"
  }
  styled.class([
    styled.animation("5s linear 0s progress_bar"),
    styled.animation_play_state(run),
    styled.animation_fill_mode("forwards"),
    styled.height(px(5)),
    styled.background(
      "var(--toaster-info-progress-bar, rgba(255, 255, 255, 0.7))",
    ),
  ])
}

fn display_move(displayed: Bool) {
  case displayed {
    True -> styled.class([])
    False -> styled.class([styled.right(percent(-100))])
  }
}
