import gleam/option.{type Option}
import tardis/data/colors
import tardis/data/debugger.{type Debugger}

pub type Model {
  Model(
    debuggers: List(#(String, Debugger)),
    color_scheme: colors.ColorScheme,
    frozen: Bool,
    opened: Bool,
    selected_debugger: Option(String),
  )
}
