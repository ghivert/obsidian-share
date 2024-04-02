import gleam/list
import gleam/int
import gleam/string
import lustre/attribute.{type Attribute}
import styled/media.{type Query}
import styled/size.{type Size}

pub opaque type Class
pub opaque type Styles
pub opaque type Media
pub opaque type NoMedia
pub opaque type PseudoSelector
pub opaque type NoPseudoSelector

pub opaque type Style(media, pseudo) {
  ClassName(class_name: String)
  Media(query: String, styles: List(Style(NoMedia, PseudoSelector)))
  PseudoSelector(pseudo_selector: String, styles: List(Style(NoMedia, NoPseudoSelector)))
  Property(key: String, value: String)
}

pub type MediaStyle = Style(NoMedia, PseudoSelector)
pub type PseudoStyle = Style(NoMedia, NoPseudoSelector)

pub fn width(width: Size) { Property("width", size.to_string(width)) }
pub fn width_(width: String) { Property("width", width) }
pub fn max_width(width: Size) { Property("max-width", size.to_string(width)) }
pub fn max_width_(width: String) { Property("max-width", width) }
pub fn min_width(width: Size) { Property("min-width", size.to_string(width)) }
pub fn min_width_(width: String) { Property("min-width", width) }
pub fn height(height: Size) { Property("height", size.to_string(height)) }
pub fn height_(height: String) { Property("height", height) }
pub fn max_height(height: Size) { Property("max-height", size.to_string(height)) }
pub fn max_height_(height: String) { Property("max-height", height) }
pub fn min_height(height: Size) { Property("min-height", size.to_string(height)) }
pub fn min_height_(height: String) { Property("min-height", height) }

pub fn color(color: String) { Property("color", color) }
pub fn font_family(font_family: String) { Property("font-family", font_family) }
pub fn font_style(font_style: String) { Property("font-style", font_style) }
pub fn font_weight(font_weight: String) { Property("font-weight", font_weight) }
pub fn letter_spacing(letter_spacing: String) { Property("letter-spacing", letter_spacing) }
pub fn line_break(line_break: String) { Property("line-break", line_break) }
pub fn line_height(line_height: String) { Property("line-height", line_height) }
pub fn text_align(text_align: String) { Property("text-align", text_align) }
pub fn text_decoration(text_decoration: String) { Property("text-decoration", text_decoration) }
pub fn text_justify(text_justify: String) { Property("text-justify", text_justify) }
pub fn text_overflow(text_overflow: String) { Property("text-overflow", text_overflow) }
pub fn text_transform(text_transform: String) { Property("text-transform", text_transform) }
pub fn white_space(white_space: String) { Property("white-space", white_space) }
pub fn white_space_collapse(white_space_collapse: String) { Property("white-space-collapse", white_space_collapse) }
pub fn word_break(word_break: String) { Property("word-break", word_break) }
pub fn word_spacing(word_spacing: String) { Property("word-spacing", word_spacing) }
pub fn word_wrap(word_wrap: String) { Property("word-wrap", word_wrap) }

pub fn list_style(list_style: String) { Property("list-style", list_style) }
pub fn list_style_image(list_style_image: String) { Property("list-style-image", list_style_image) }
pub fn list_style_position(list_style_position: String) { Property("list-style-position", list_style_position) }
pub fn list_style_type(list_style_type: String) { Property("list-style-type", list_style_type) }

pub fn display(display: String) { Property("display", display) }
pub fn z_index(z_index: Int) { Property("z_index", int.to_string(z_index)) }
pub fn visibility(visibility: String) { Property("visibility", visibility) }
pub fn background(background: String) { Property("background", background) }
pub fn object_fit(object_fit: String) { Property("object-fit", object_fit) }
pub fn object_position(object_position: String) { Property("object-position", object_position) }
pub fn opacity(opacity: String) { Property("opacity", opacity) }
pub fn pointer_events(pointer_events: String) { Property("pointer-events", pointer_events) }
pub fn user_select(user_select: String) { Property("user-select", user_select) }
pub fn position(position: String) { Property("position", position) }

pub fn outline(outline: String) { Property("outline", outline) }
pub fn outline_color(outline_color: String) { Property("outline-color", outline_color) }
pub fn outline_offset(outline_offset: String) { Property("outline-offset", outline_offset) }
pub fn outline_style(outline_style: String) { Property("outline-style", outline_style) }
pub fn outline_width(outline_width: String) { Property("outline-width", outline_width) }

pub fn offset(offset: String) { Property("offset", offset) }
pub fn offset_anchor(offset_anchor: String) { Property("offset-anchor", offset_anchor) }
pub fn offset_distance(offset_distance: String) { Property("offset-distance", offset_distance) }
pub fn offset_path(offset_path: String) { Property("offset-path", offset_path) }
pub fn offset_position(offset_position: String) { Property("offset-position", offset_position) }
pub fn offset_rotate(offset_rotate: String) { Property("offset-rotate", offset_rotate) }

pub fn gap(gap: String) { Property("gap", gap) }
pub fn column_gap(column_gap: Size) { Property("column-gap", size.to_string(column_gap)) }
pub fn row_gap(row_gap: Size) { Property("row-gap", size.to_string(row_gap)) }
pub fn grid_area(grid_area: String) { Property("grid-area", grid_area) }
pub fn grid_column(grid_column: String) { Property("grid-column", grid_column) }
pub fn grid_row(grid_row: String) { Property("grid-row", grid_row) }
pub fn grid_template(grid_template: String) { Property("grid-template", grid_template) }
pub fn grid_auto_columns(grid_auto_columns: String) { Property("grid-auto-columns", grid_auto_columns) }
pub fn grid_auto_rows(grid_auto_rows: String) { Property("grid-auto-rows", grid_auto_rows) }
pub fn grid_auto_flow(grid_auto_flow: String) { Property("grid-auto-flow", grid_auto_flow) }
pub fn grid_template_areas(grid_template_areas: String) { Property("grid-template-areas", grid_template_areas) }
pub fn grid_template_columns(grid_template_columns: String) { Property("grid-template-columns", grid_template_columns) }
pub fn grid_template_rows(grid_template_rows: String) { Property("grid-template-rows", grid_template_rows) }

pub fn align_content(align: String) { Property("align-content", align) }
pub fn align_items(align: String) { Property("align-items", align) }
pub fn align_self(align: String) { Property("align-self", align) }
pub fn align_tracks(align: String) { Property("align-tracks", align) }

pub fn justify_content(justify: String) { Property("justify-content", justify) }
pub fn justify_items(justify: String) { Property("justify-items", justify) }
pub fn justify_self(justify: String) { Property("justify-self", justify) }
pub fn justify_tracks(justify: String) { Property("justify-tracks", justify) }

pub fn place_content(place: String) { Property("place-content", place) }
pub fn place_items(place: String) { Property("place-items", place) }
pub fn place_self(place: String) { Property("place-self", place) }

pub fn animation(animation: String) { Property("animation", animation) }
pub fn animation_name(animation: String) { Property("animation-name", animation) }
pub fn animation_duration(animation: String) { Property("animation-duration", animation) }
pub fn animation_timing_function(animation: String) { Property("animation-timing-function", animation) }
pub fn animation_delay(animation: String) { Property("animation-delay", animation) }
pub fn animation_iteration_count(animation: String) { Property("animation-iteration-count", animation) }
pub fn animation_direction(animation: String) { Property("animation-direction", animation) }
pub fn animation_fill_mode(animation: String) { Property("animation-fill-mode", animation) }
pub fn animation_play_state(animation: String) { Property("animation-play-state", animation) }
pub fn transition(transition: String) { Property("transition", transition) }
pub fn translate(translate: String) { Property("translate", translate) }
pub fn transform(transform: String) { Property("transform", transform) }
pub fn transform_box(transform_box: String) { Property("transform-box", transform_box) }
pub fn transform_origin(transform_origin: String) { Property("transform-origin", transform_origin) }
pub fn transform_style(transform_style: String) { Property("transform-style", transform_style) }
pub fn appearance(appearance: String) { Property("appearance", appearance) }
pub fn filter(filter: String) { Property("filter", filter) }
pub fn aspect_ratio(aspect_ratio: String) { Property("aspect-ratio", aspect_ratio) }

pub fn top(size: Size) { Property("top", size.to_string(size)) }
pub fn bottom(size: Size) { Property("bottom", size.to_string(size)) }
pub fn right(size: Size) { Property("right", size.to_string(size)) }
pub fn left(size: Size) { Property("left", size.to_string(size)) }

pub fn box_shadow(box_shadow: String) { Property("box-shadow", box_shadow) }
pub fn box_sizing(box_sizing: String) { Property("box-sizing", box_sizing) }
pub fn overflow(overflow: String) { Property("overflow", overflow) }
pub fn overflow_x(overflow_x: String) { Property("overflow-x", overflow_x) }
pub fn overflow_y(overflow_y: String) { Property("overflow-y", overflow_y) }

pub fn direction(direction: String) { Property("direction", direction) }
pub fn flex(flex: String) { Property("flex", flex) }
pub fn flex_basis(flex_basis: String) { Property("flex-basis", flex_basis) }
pub fn flex_direction(flex_direction: String) { Property("flex-direction", flex_direction) }
pub fn flex_grow(flex_grow: String) { Property("flex-grow", flex_grow) }

pub fn border(border: String) { Property("border", border) }
pub fn border_top(border_top: String) { Property("border-top", border_top) }
pub fn border_bottom(border_bottom: String) { Property("border-bottom", border_bottom) }
pub fn border_right(border_right: String) { Property("border-right", border_right) }
pub fn border_left(border_left: String) { Property("border-left", border_left) }
pub fn border_radius(border_radius: String) { Property("border-radius", border_radius) }
pub fn border_top_right_radius(border_top_right_radius: String) { Property("border-top-right-radius", border_top_right_radius) }
pub fn border_top_left_radius(border_top_left_radius: String) { Property("border-top-left-radius", border_top_left_radius) }
pub fn border_bottom_right_radius(border_bottom_right_radius: String) { Property("border-bottom-right-radius", border_bottom_right_radius) }
pub fn border_bottom_left_radius(border_bottom_left_radius: String) { Property("border-bottom-left-radius", border_bottom_left_radius) }

pub fn padding(padding: Size) { Property("padding", size.to_string(padding)) }
pub fn padding_(padding: String) { Property("padding", padding) }
pub fn padding_top(padding: Size) { Property("padding-top", size.to_string(padding)) }
pub fn padding_bottom(padding: Size) { Property("padding-bottom", size.to_string(padding)) }
pub fn padding_right(padding: Size) { Property("padding-right", size.to_string(padding)) }
pub fn padding_left(padding: Size) { Property("padding-left", size.to_string(padding)) }

pub fn margin(margin: Size) { Property("margin", size.to_string(margin)) }
pub fn margin_(margin: String) { Property("margin", margin) }
pub fn margin_top(margin: Size) { Property("margin-top", size.to_string(margin)) }
pub fn margin_bottom(margin: Size) { Property("margin-bottom", size.to_string(margin)) }
pub fn margin_right(margin: Size) { Property("margin-right", size.to_string(margin)) }
pub fn margin_left(margin: Size) { Property("margin-left", size.to_string(margin)) }

pub fn property(field: String, content: String) { Property(field, content) }

pub fn media(query: Query, styles: List(MediaStyle)) -> Style(Media, pseudo) {
  let media_selector = media.to_string(query)
  Media(media_selector, styles)
}

pub fn placeholder(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector("::placeholder", styles) }
pub fn hover(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":hover", styles) }
pub fn active(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":active", styles) }
pub fn focus(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":focus", styles) }
pub fn focus_visible(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":focus-visible", styles) }
pub fn focus_within(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":focus-within", styles) }
pub fn enabled(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":enabled", styles) }
pub fn disabled(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":disabled", styles) }
pub fn read_only(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":read-only", styles) }
pub fn read_write(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":read-write", styles) }
pub fn checked(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":checked", styles) }
pub fn blank(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":blank", styles) }
pub fn valid(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":valid", styles) }
pub fn invalid(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":invalid", styles) }
pub fn required(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":required", styles) }
pub fn optional(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":optional", styles) }
pub fn link(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":link", styles) }
pub fn visited(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":visited", styles) }
pub fn target(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":target", styles) }
pub fn nth_child(selector: String, styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(string.append(":nth-child", selector), styles) }
pub fn nth_last_child(selector: String, styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(string.append(":nth-last-child", selector), styles) }
pub fn nth_of_type(selector: String, styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(string.append(":nth-of-type", selector), styles) }
pub fn nth_last_of_type(selector: String, styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(string.append(":nth-last-of-type", selector), styles) }
pub fn first_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":first-child", styles) }
pub fn last_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":last-child", styles) }
pub fn only_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":only-child", styles) }
pub fn first_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":first-of-type", styles) }
pub fn last_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":last-of-type", styles) }
pub fn only_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) { PseudoSelector(":only-of-type", styles) }

pub fn compose(class: Class) {
  class
  |> to_string()
  |> ClassName()
}

@external(javascript, "./styled_ffi.mjs", "compileClass")
fn compile_class(styles: List(Style(media, pseudo))) -> Class

@external(javascript, "./styled_ffi.mjs", "compileClass")
fn compile_style(styles: List(Style(media, pseudo)), id: String) -> Class

@external(javascript, "./styled_ffi.mjs", "memo")
fn memo(class: Class) -> Class

@external(javascript, "./styled_ffi.mjs", "toString")
fn to_string(class: Class) -> String

pub fn class(styles: List(Style(media, pseudo))) -> Class {
  styles
  |> compile_class()
  |> memo()
}

pub fn style(id: String, styles: List(Style(media, pseudo))) -> Class {
  styles
  |> compile_style(id)
}

pub fn to_class_name(class: Class) -> String {
  class
  |> to_string()
}

pub fn to_lustre(class: Class) -> Attribute(a) {
  class
  |> to_string()
  |> string.split(" ")
  |> list.map(fn(value) { #(value, True) })
  |> attribute.classes()
}
