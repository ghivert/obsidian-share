import gleam/list
import gleam/string
import lustre/attribute.{type Attribute}
import styled/media.{type Query}
import styled/size.{type Size}

pub opaque type Class

pub opaque type Style {
  ClassName(class_name: String)
  Media(query: String, styles: List(Style))
  Property(key: String, value: String)
}

pub fn max_width(width: Size) {
  Property("max-width", size.to_string(width))
}

pub fn color(color: String) {
  Property("color", color)
}

pub fn padding(padding: Size) {
  Property("padding", size.to_string(padding))
}

pub fn media(query: Query, styles: List(Style)) {
  let media_selector = media.to_string(query)
  Media(media_selector, styles)
}

pub fn extend(class: Class) {
  class
  |> to_string()
  |> ClassName()
}

@external(javascript, "../styled_ffi.mjs", "compileClass")
pub fn class(styles: List(Style)) -> Class

@external(javascript, "../styled_ffi.mjs", "toString")
fn to_string(class: Class) -> String

pub fn from_class(class: Class) -> Attribute(a) {
  class
  |> to_string()
  |> string.split(" ")
  |> list.map(fn(value) { #(value, True) })
  |> attribute.classes()
}
