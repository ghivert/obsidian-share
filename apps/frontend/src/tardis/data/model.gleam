import gleam/option.{type Option}
import lustre/effect.{type Effect}
import tardis/data/colors
import tardis/data/msg.{type Msg}
import tardis/data/step.{type Step}

pub type Model(model, msg) {
  Model(
    count: Int,
    steps: List(Step(model, msg)),
    opened: Bool,
    color_scheme: colors.ColorScheme,
    dispatcher: fn(model) -> Effect(Msg(model, msg)),
    frozen: Bool,
    selected_step: Option(String),
  )
}
