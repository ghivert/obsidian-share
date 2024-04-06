import tardis/data/colors

pub type Step(model, msg) {
  Step(index: String, model: model, msg: msg)
}

pub type Model(model, msg) {
  Model(
    count: Int,
    steps: List(Step(model, msg)),
    opened: Bool,
    color_scheme: colors.ColorScheme,
  )
}
