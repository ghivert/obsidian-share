import sketch

pub type Colors {
  Colors(
    background: String,
    shadow: String,
    primary: String,
    editor_fg: String,
    editor_bg: String,
    gutter: String,
    syntax_comment: String,
    button: String,
    function: String,
    nil: String,
    bool: String,
    constant: String,
    bit_array: String,
    utf_codepoint: String,
    string: String,
    number: String,
    custom_type: String,
    regex: String,
    date: String,
  )
}

pub type ColorScheme {
  Dark
  Light
}

pub const dark = Colors(
  background: "#111e",
  shadow: "#333",
  primary: "#ffcc66",
  editor_fg: "#cccac2",
  editor_bg: "#242936",
  gutter: "#8a919966",
  syntax_comment: "#b8cfe680",
  button: "#ffd173",
  function: "#ffd173",
  nil: "#ffad66",
  bool: "#dfbfff",
  constant: "#ffad66",
  bit_array: "#d5ff80",
  utf_codepoint: "#f28779",
  string: "#d5ff80",
  number: "#5ccfe6",
  custom_type: "#73d0ff",
  regex: "#95e6cb",
  date: "#dfbfff",
)

pub const light = Colors(
  background: "white",
  shadow: "#ccc",
  primary: "#ffaa33",
  editor_fg: "#5c6166",
  editor_bg: "#f8f9fa",
  gutter: "#8a919966",
  syntax_comment: "#787b8099",
  button: "#F2AE49",
  function: "#F2AE49",
  nil: "#fa8d3e",
  bool: "#a37acc",
  constant: "#fa8d3e",
  bit_array: "#86b300",
  utf_codepoint: "#f07171",
  string: "#86b300",
  number: "#55b4d4",
  custom_type: "#399ee6",
  regex: "#4cbf43",
  date: "#a37acc",
)

pub fn dark_class() {
  sketch.class([
    sketch.property("--background", dark.background),
    sketch.property("--shadow", dark.shadow),
    sketch.property("--primary", dark.primary),
    sketch.property("--editor-fg", dark.editor_fg),
    sketch.property("--editor-bg", dark.editor_bg),
    sketch.property("--gutter", dark.gutter),
    sketch.property("--syntax-comment", dark.syntax_comment),
    sketch.property("--button", dark.button),
    sketch.property("--function", dark.function),
    sketch.property("--nil", dark.nil),
    sketch.property("--bool", dark.bool),
    sketch.property("--constant", dark.constant),
    sketch.property("--bit-array", dark.bit_array),
    sketch.property("--utfcodepoint", dark.utf_codepoint),
    sketch.property("--string", dark.string),
    sketch.property("--number", dark.number),
    sketch.property("--custom-type", dark.custom_type),
    sketch.property("--regex", dark.regex),
    sketch.property("--date", dark.date),
  ])
  |> sketch.to_lustre()
}

pub fn light_class() {
  sketch.class([
    sketch.property("--background", light.background),
    sketch.property("--shadow", light.shadow),
    sketch.property("--primary", light.primary),
    sketch.property("--editor-fg", light.editor_fg),
    sketch.property("--editor-bg", light.editor_bg),
    sketch.property("--gutter", light.gutter),
    sketch.property("--syntax-comment", light.syntax_comment),
    sketch.property("--button", light.button),
    sketch.property("--function", light.function),
    sketch.property("--nil", light.nil),
    sketch.property("--bool", light.bool),
    sketch.property("--constant", light.constant),
    sketch.property("--bit-array", light.bit_array),
    sketch.property("--utfcodepoint", light.utf_codepoint),
    sketch.property("--string", light.string),
    sketch.property("--number", light.number),
    sketch.property("--custom-type", light.custom_type),
    sketch.property("--regex", light.regex),
    sketch.property("--date", light.date),
  ])
  |> sketch.to_lustre()
}

@external(javascript, "../../tardis.ffi.mjs", "isDarkTheme")
fn is_dark_theme() -> Bool

pub fn choose_color_scheme() {
  case is_dark_theme() {
    True -> Dark
    False -> Light
  }
}

pub fn get_color_scheme_class(color_scheme: ColorScheme) {
  case color_scheme {
    Light -> light_class()
    Dark -> dark_class()
  }
}
