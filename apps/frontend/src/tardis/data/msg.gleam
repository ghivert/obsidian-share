import lustre/effect.{type Effect}
import tardis/data/step.{type Step}
import tardis/data/colors.{type ColorScheme}

pub type Msg(model, msg) {
  ToggleOpen
  AddStep(model, msg)
  UpdateColorScheme(ColorScheme)
  AddApplication(fn(model) -> Effect(Msg(model, msg)))
  BackToStep(Step(model, msg))
  Debug(String)
  Restart
}
