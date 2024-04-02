import gleam/int
import gleam/string
import lustre/element/html
import styled
import styled/size.{px}
import toaster/model/toast.{type Level, type Toast}
import toaster/view/colors

pub fn view(toast: Toast) {
  html.div(
    [
      pb_play_state(toast.running),
      pb_background_color(toast.level),
      pb_animation(toast.animation_duration),
      pb_base(),
    ],
    [],
  )
}

fn pb_base() {
  [styled.animation_fill_mode("forwards"), styled.height(px(5))]
  |> styled.class()
  |> styled.to_lustre()
}

fn pb_animation(duration: Int) {
  let duration_ = int.to_string(duration / 1000)
  [styled.animation(duration_ <> "s linear 0s progress_bar")]
  |> styled.style("toast-duration-" <> duration_, _)
  |> styled.to_lustre()
}

fn pb_background_color(level: Level) {
  let back_color = colors.progress_bar_from_level(level)
  let background = "var(--toaster-info-progress-bar, " <> back_color <> ")"
  string.join(["toaster", "pb", "background", back_color], "-")
  |> styled.style([styled.background(background)])
  |> styled.to_lustre()
}

fn pb_play_state(running: Bool) {
  let running_str = toast.running_to_string(running)
  string.join(["toaster", "pb", "play-state", running_str], "-")
  |> styled.style([styled.animation_play_state(running_str)])
  |> styled.to_lustre()
}
