import gleam/list
import gleam/int
import gleam/bool
import gleam/string
import lustre/attribute
import lustre/event
import lustre/element
import lustre/element/html
import styled
import styled/size.{percent, px}
import toaster/model/model.{type Model, Model}
import toaster/view/colors
import toaster/model/toast.{type Level, type Toast}
import toaster/types.{HideToast, ResumeToast, StopToast}

pub fn view(model: Model) {
  let Model(toasts, _) = model
  element.keyed(html.div([], _), {
    use toast <- list.map(toasts)
    let id = int.to_string(toast.id)
    #(id, view_toast(toast))
  })
}

fn view_toast(toast: Toast) {
  let id =
    ["toast", bool.to_string(toast.displayed), int.to_string(toast.bottom)]
    |> string.join("-")
  let attrs = [
    color_styles(toast.level),
    base_styles(),
    event.on_mouse_enter(StopToast(toast.id)),
    event.on_mouse_leave(ResumeToast(toast.id)),
  ]
  html.div(
    [
      styled.to_lustre(
        styled.style(id, [
          styled.padding(px(12)),
          styled.position("fixed"),
          right_position_styles(toast.displayed),
          styled.bottom(px(int.max(0, toast.bottom))),
          styled.transition("right 1s, bottom 1s"),
        ]),
      ),
      attribute.classes([
        #("toaster-toast", True),
        #("toaster-toast-" <> int.to_string(toast.id), True),
      ]),
    ],
    [
      html.div(attrs, [
        html.div(
          [text_wrapper(), event.on_click(HideToast(toast.id, toast.iteration))],
          [html.text(toast.content)],
        ),
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
    // Colors
    styled.box_shadow("0px 4px 12px rgba(0, 0, 0, 0.1)"),
    // Animation
    styled.overflow("hidden"),
  ])
  |> styled.to_lustre()
}

fn color_styles(level: Level) {
  let #(background, text_color) = colors.from_level(level)
  let id = string.join(["toaster", background, text_color], "-")
  styled.style(id, [
    styled.background("var(--toaster-info-background, " <> background <> ")"),
    styled.color("var(--toaster-info-text-color, " <> text_color <> ")"),
  ])
  |> styled.to_lustre()
}

fn text_wrapper() {
  styled.class([
    styled.display("flex"),
    styled.align_items("center"),
    styled.flex("1"),
    styled.padding_("8px 16px"),
  ])
  |> styled.to_lustre()
}

fn pb_styles() {
  styled.class([
    styled.animation("50s linear 0s progress_bar"),
    styled.animation_fill_mode("forwards"),
    styled.height(px(5)),
  ])
  |> styled.to_lustre()
}

fn pb_color(running: Bool, level: Level) {
  let back = colors.progress_bar_from_level(level)
  let running_str = toast.running_to_string(running)
  let id = string.join(["toaster", "pb", running_str, back], "-")
  styled.style(id, [
    styled.animation_play_state(running_str),
    styled.background("var(--toaster-info-progress-bar, " <> back <> ")"),
  ])
  |> styled.to_lustre()
}

fn right_position_styles(displayed: Bool) {
  case displayed {
    True -> styled.right(px(0))
    False -> styled.right(percent(-100))
  }
}
