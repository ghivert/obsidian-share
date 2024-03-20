import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import layout/align
import layout/justify

pub opaque type Attributes {
  Direction(String)
  Align(String)
  Justify(String)
  Gap(Int)
}

pub fn align(align: align.Align) -> Attributes {
  case align {
    align.Stretch -> Align("stretch")
    align.Start -> Align("start")
    align.End -> Align("end")
    align.Center -> Align("center")
  }
}

pub fn justify(justify: justify.Justify) -> Attributes {
  case justify {
    justify.Stretch -> Justify("stretch")
    justify.Start -> Justify("start")
    justify.End -> Justify("end")
    justify.Center -> Justify("center")
    justify.SpaceBetween -> Justify("space-between")
    justify.SpaceAround -> Justify("space-around")
  }
}

pub fn gap(gap: Int) -> Attributes {
  Gap(gap)
}

fn reduce_attributes(attributes: Dict(String, String), value: Attributes) {
  case value {
    Direction(direction) -> dict.insert(attributes, "flex-direction", direction)
    Align(align) -> dict.insert(attributes, "align-items", align)
    Justify(justify) -> dict.insert(attributes, "justify-content", justify)
    Gap(gap) -> {
      let gap_value = int.to_string(gap)
      let gap_style = string.append(gap_value, "px")
      dict.insert(attributes, "gap", gap_style)
    }
  }
}

fn flex(
  direction: String,
  attrs: List(Attributes),
  attrs_: List(attribute.Attribute(a)),
  children: List(Element(a)),
) {
  let attributes_ =
    [Direction(direction), ..attrs]
    |> list.fold(dict.from_list([#("display", "flex")]), reduce_attributes)
    |> dict.to_list
    |> attribute.style
  html.div([attributes_, ..attrs_], children)
}

pub fn row(attrs, children) {
  flex("row", attrs, [], children)
}

pub fn row_(attrs, html_attributes, children) {
  flex("row", attrs, html_attributes, children)
}

pub fn column(attrs, children) {
  flex("column", attrs, [], children)
}

pub fn column_(attrs, html_attributes, children) {
  flex("column", attrs, html_attributes, children)
}
