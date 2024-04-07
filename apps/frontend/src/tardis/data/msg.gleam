import tardis/data/colors.{type ColorScheme}

pub type Msg(model, msg) {
  ToggleOpen
  AddStep(model, msg)
  UpdateColorScheme(ColorScheme)
}
