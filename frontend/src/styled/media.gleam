import styled/size.{type Size, to_string as to_str}
import gleam/string

pub opaque type ColorMode {
  Dark
  Light
}

pub opaque type Query {
  MaxWidth(Size)
  MinWidth(Size)
  ColorScheme(ColorMode)
}

pub fn dark() {
  Dark
}

pub fn light() {
  Light
}

pub fn max_width(size) {
  MaxWidth(size)
}

pub fn min_width(size) {
  MinWidth(size)
}

pub fn color_scheme(color_scheme) {
  ColorScheme(color_scheme)
}

pub fn to_string(query: Query) {
  case query {
    ColorScheme(Dark) -> "@media (prefers-color-scheme: dark)"
    ColorScheme(Light) -> "@media (prefers-color-scheme: light)"
    MaxWidth(s) -> string.join(["@media (max-width: ", to_str(s), ")"], "")
    MinWidth(s) -> string.join(["@media (min-width: ", to_str(s), ")"], "")
  }
}
