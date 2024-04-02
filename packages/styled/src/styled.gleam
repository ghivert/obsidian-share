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
  PseudoSelector(
    pseudo_selector: String,
    styles: List(Style(NoMedia, NoPseudoSelector)),
  )
  Property(key: String, value: String, important: Bool)
}

pub type MediaStyle =
  Style(NoMedia, PseudoSelector)

pub type PseudoStyle =
  Style(NoMedia, NoPseudoSelector)

pub fn width(width: Size) {
  Property("width", size.to_string(width), False)
}

pub fn width_(width: String) {
  Property("width", width, False)
}

pub fn max_width(width: Size) {
  Property("max-width", size.to_string(width), False)
}

pub fn max_width_(width: String) {
  Property("max-width", width, False)
}

pub fn min_width(width: Size) {
  Property("min-width", size.to_string(width), False)
}

pub fn min_width_(width: String) {
  Property("min-width", width, False)
}

pub fn height(height: Size) {
  Property("height", size.to_string(height), False)
}

pub fn height_(height: String) {
  Property("height", height, False)
}

pub fn max_height(height: Size) {
  Property("max-height", size.to_string(height), False)
}

pub fn max_height_(height: String) {
  Property("max-height", height, False)
}

pub fn min_height(height: Size) {
  Property("min-height", size.to_string(height), False)
}

pub fn min_height_(height: String) {
  Property("min-height", height, False)
}

pub fn color(color: String) {
  Property("color", color, False)
}

pub fn font_family(font_family: String) {
  Property("font-family", font_family, False)
}

pub fn font_style(font_style: String) {
  Property("font-style", font_style, False)
}

pub fn font_weight(font_weight: String) {
  Property("font-weight", font_weight, False)
}

pub fn letter_spacing(letter_spacing: String) {
  Property("letter-spacing", letter_spacing, False)
}

pub fn line_break(line_break: String) {
  Property("line-break", line_break, False)
}

pub fn line_height(line_height: String) {
  Property("line-height", line_height, False)
}

pub fn text_align(text_align: String) {
  Property("text-align", text_align, False)
}

pub fn text_decoration(text_decoration: String) {
  Property("text-decoration", text_decoration, False)
}

pub fn text_justify(text_justify: String) {
  Property("text-justify", text_justify, False)
}

pub fn text_overflow(text_overflow: String) {
  Property("text-overflow", text_overflow, False)
}

pub fn text_transform(text_transform: String) {
  Property("text-transform", text_transform, False)
}

pub fn white_space(white_space: String) {
  Property("white-space", white_space, False)
}

pub fn white_space_collapse(white_space_collapse: String) {
  Property("white-space-collapse", white_space_collapse, False)
}

pub fn word_break(word_break: String) {
  Property("word-break", word_break, False)
}

pub fn word_spacing(word_spacing: String) {
  Property("word-spacing", word_spacing, False)
}

pub fn word_wrap(word_wrap: String) {
  Property("word-wrap", word_wrap, False)
}

pub fn list_style(list_style: String) {
  Property("list-style", list_style, False)
}

pub fn list_style_image(list_style_image: String) {
  Property("list-style-image", list_style_image, False)
}

pub fn list_style_position(list_style_position: String) {
  Property("list-style-position", list_style_position, False)
}

pub fn list_style_type(list_style_type: String) {
  Property("list-style-type", list_style_type, False)
}

pub fn display(display: String) {
  Property("display", display, False)
}

pub fn z_index(z_index: Int) {
  Property("z_index", int.to_string(z_index), False)
}

pub fn visibility(visibility: String) {
  Property("visibility", visibility, False)
}

pub fn background(background: String) {
  Property("background", background, False)
}

pub fn object_fit(object_fit: String) {
  Property("object-fit", object_fit, False)
}

pub fn object_position(object_position: String) {
  Property("object-position", object_position, False)
}

pub fn opacity(opacity: String) {
  Property("opacity", opacity, False)
}

pub fn pointer_events(pointer_events: String) {
  Property("pointer-events", pointer_events, False)
}

pub fn user_select(user_select: String) {
  Property("user-select", user_select, False)
}

pub fn position(position: String) {
  Property("position", position, False)
}

pub fn outline(outline: String) {
  Property("outline", outline, False)
}

pub fn outline_color(outline_color: String) {
  Property("outline-color", outline_color, False)
}

pub fn outline_offset(outline_offset: String) {
  Property("outline-offset", outline_offset, False)
}

pub fn outline_style(outline_style: String) {
  Property("outline-style", outline_style, False)
}

pub fn outline_width(outline_width: String) {
  Property("outline-width", outline_width, False)
}

pub fn offset(offset: String) {
  Property("offset", offset, False)
}

pub fn offset_anchor(offset_anchor: String) {
  Property("offset-anchor", offset_anchor, False)
}

pub fn offset_distance(offset_distance: String) {
  Property("offset-distance", offset_distance, False)
}

pub fn offset_path(offset_path: String) {
  Property("offset-path", offset_path, False)
}

pub fn offset_position(offset_position: String) {
  Property("offset-position", offset_position, False)
}

pub fn offset_rotate(offset_rotate: String) {
  Property("offset-rotate", offset_rotate, False)
}

pub fn gap(gap: String) {
  Property("gap", gap, False)
}

pub fn column_gap(column_gap: Size) {
  Property("column-gap", size.to_string(column_gap), False)
}

pub fn row_gap(row_gap: Size) {
  Property("row-gap", size.to_string(row_gap), False)
}

pub fn grid_area(grid_area: String) {
  Property("grid-area", grid_area, False)
}

pub fn grid_column(grid_column: String) {
  Property("grid-column", grid_column, False)
}

pub fn grid_row(grid_row: String) {
  Property("grid-row", grid_row, False)
}

pub fn grid_template(grid_template: String) {
  Property("grid-template", grid_template, False)
}

pub fn grid_auto_columns(grid_auto_columns: String) {
  Property("grid-auto-columns", grid_auto_columns, False)
}

pub fn grid_auto_rows(grid_auto_rows: String) {
  Property("grid-auto-rows", grid_auto_rows, False)
}

pub fn grid_auto_flow(grid_auto_flow: String) {
  Property("grid-auto-flow", grid_auto_flow, False)
}

pub fn grid_template_areas(grid_template_areas: String) {
  Property("grid-template-areas", grid_template_areas, False)
}

pub fn grid_template_columns(grid_template_columns: String) {
  Property("grid-template-columns", grid_template_columns, False)
}

pub fn grid_template_rows(grid_template_rows: String) {
  Property("grid-template-rows", grid_template_rows, False)
}

pub fn align_content(align: String) {
  Property("align-content", align, False)
}

pub fn align_items(align: String) {
  Property("align-items", align, False)
}

pub fn align_self(align: String) {
  Property("align-self", align, False)
}

pub fn align_tracks(align: String) {
  Property("align-tracks", align, False)
}

pub fn justify_content(justify: String) {
  Property("justify-content", justify, False)
}

pub fn justify_items(justify: String) {
  Property("justify-items", justify, False)
}

pub fn justify_self(justify: String) {
  Property("justify-self", justify, False)
}

pub fn justify_tracks(justify: String) {
  Property("justify-tracks", justify, False)
}

pub fn place_content(place: String) {
  Property("place-content", place, False)
}

pub fn place_items(place: String) {
  Property("place-items", place, False)
}

pub fn place_self(place: String) {
  Property("place-self", place, False)
}

pub fn animation(animation: String) {
  Property("animation", animation, False)
}

pub fn animation_name(animation: String) {
  Property("animation-name", animation, False)
}

pub fn animation_duration(animation: String) {
  Property("animation-duration", animation, False)
}

pub fn animation_timing_function(animation: String) {
  Property("animation-timing-function", animation, False)
}

pub fn animation_delay(animation: String) {
  Property("animation-delay", animation, False)
}

pub fn animation_iteration_count(animation: String) {
  Property("animation-iteration-count", animation, False)
}

pub fn animation_direction(animation: String) {
  Property("animation-direction", animation, False)
}

pub fn animation_fill_mode(animation: String) {
  Property("animation-fill-mode", animation, False)
}

pub fn animation_play_state(animation: String) {
  Property("animation-play-state", animation, False)
}

pub fn transition(transition: String) {
  Property("transition", transition, False)
}

pub fn translate(translate: String) {
  Property("translate", translate, False)
}

pub fn transform(transform: String) {
  Property("transform", transform, False)
}

pub fn transform_box(transform_box: String) {
  Property("transform-box", transform_box, False)
}

pub fn transform_origin(transform_origin: String) {
  Property("transform-origin", transform_origin, False)
}

pub fn transform_style(transform_style: String) {
  Property("transform-style", transform_style, False)
}

pub fn appearance(appearance: String) {
  Property("appearance", appearance, False)
}

pub fn filter(filter: String) {
  Property("filter", filter, False)
}

pub fn aspect_ratio(aspect_ratio: String) {
  Property("aspect-ratio", aspect_ratio, False)
}

pub fn top(size: Size) {
  Property("top", size.to_string(size), False)
}

pub fn bottom(size: Size) {
  Property("bottom", size.to_string(size), False)
}

pub fn right(size: Size) {
  Property("right", size.to_string(size), False)
}

pub fn left(size: Size) {
  Property("left", size.to_string(size), False)
}

pub fn top_(size: String) {
  Property("top", size, False)
}

pub fn bottom_(size: String) {
  Property("bottom", size, False)
}

pub fn right_(size: String) {
  Property("right", size, False)
}

pub fn left_(size: String) {
  Property("left", size, False)
}

pub fn box_shadow(box_shadow: String) {
  Property("box-shadow", box_shadow, False)
}

pub fn box_sizing(box_sizing: String) {
  Property("box-sizing", box_sizing, False)
}

pub fn overflow(overflow: String) {
  Property("overflow", overflow, False)
}

pub fn overflow_x(overflow_x: String) {
  Property("overflow-x", overflow_x, False)
}

pub fn overflow_y(overflow_y: String) {
  Property("overflow-y", overflow_y, False)
}

pub fn direction(direction: String) {
  Property("direction", direction, False)
}

pub fn flex(flex: String) {
  Property("flex", flex, False)
}

pub fn flex_basis(flex_basis: String) {
  Property("flex-basis", flex_basis, False)
}

pub fn flex_direction(flex_direction: String) {
  Property("flex-direction", flex_direction, False)
}

pub fn flex_grow(flex_grow: String) {
  Property("flex-grow", flex_grow, False)
}

pub fn border(border: String) {
  Property("border", border, False)
}

pub fn border_top(border_top: String) {
  Property("border-top", border_top, False)
}

pub fn border_bottom(border_bottom: String) {
  Property("border-bottom", border_bottom, False)
}

pub fn border_right(border_right: String) {
  Property("border-right", border_right, False)
}

pub fn border_left(border_left: String) {
  Property("border-left", border_left, False)
}

pub fn border_radius(border_radius: String) {
  Property("border-radius", border_radius, False)
}

pub fn border_top_right_radius(border_top_right_radius: String) {
  Property("border-top-right-radius", border_top_right_radius, False)
}

pub fn border_top_left_radius(border_top_left_radius: String) {
  Property("border-top-left-radius", border_top_left_radius, False)
}

pub fn border_bottom_right_radius(border_bottom_right_radius: String) {
  Property("border-bottom-right-radius", border_bottom_right_radius, False)
}

pub fn border_bottom_left_radius(border_bottom_left_radius: String) {
  Property("border-bottom-left-radius", border_bottom_left_radius, False)
}

pub fn padding(padding: Size) {
  Property("padding", size.to_string(padding), False)
}

pub fn padding_(padding: String) {
  Property("padding", padding, False)
}

pub fn padding_top(padding: Size) {
  Property("padding-top", size.to_string(padding), False)
}

pub fn padding_bottom(padding: Size) {
  Property("padding-bottom", size.to_string(padding), False)
}

pub fn padding_right(padding: Size) {
  Property("padding-right", size.to_string(padding), False)
}

pub fn padding_left(padding: Size) {
  Property("padding-left", size.to_string(padding), False)
}

pub fn margin(margin: Size) {
  Property("margin", size.to_string(margin), False)
}

pub fn margin_(margin: String) {
  Property("margin", margin, False)
}

pub fn margin_top(margin: Size) {
  Property("margin-top", size.to_string(margin), False)
}

pub fn margin_bottom(margin: Size) {
  Property("margin-bottom", size.to_string(margin), False)
}

pub fn margin_right(margin: Size) {
  Property("margin-right", size.to_string(margin), False)
}

pub fn margin_left(margin: Size) {
  Property("margin-left", size.to_string(margin), False)
}

pub fn property(field: String, content: String) {
  Property(field, content, False)
}

pub fn media(query: Query, styles: List(MediaStyle)) -> Style(Media, pseudo) {
  let media_selector = media.to_string(query)
  Media(media_selector, styles)
}

pub fn placeholder(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector("::placeholder", styles)
}

pub fn hover(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":hover", styles)
}

pub fn active(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":active", styles)
}

pub fn focus(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":focus", styles)
}

pub fn focus_visible(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":focus-visible", styles)
}

pub fn focus_within(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":focus-within", styles)
}

pub fn enabled(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":enabled", styles)
}

pub fn disabled(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":disabled", styles)
}

pub fn read_only(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":read-only", styles)
}

pub fn read_write(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":read-write", styles)
}

pub fn checked(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":checked", styles)
}

pub fn blank(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":blank", styles)
}

pub fn valid(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":valid", styles)
}

pub fn invalid(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":invalid", styles)
}

pub fn required(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":required", styles)
}

pub fn optional(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":optional", styles)
}

pub fn link(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":link", styles)
}

pub fn visited(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":visited", styles)
}

pub fn target(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":target", styles)
}

pub fn nth_child(
  selector: String,
  styles: List(PseudoStyle),
) -> Style(media, PseudoSelector) {
  PseudoSelector(string.append(":nth-child", selector), styles)
}

pub fn nth_last_child(
  selector: String,
  styles: List(PseudoStyle),
) -> Style(media, PseudoSelector) {
  PseudoSelector(string.append(":nth-last-child", selector), styles)
}

pub fn nth_of_type(
  selector: String,
  styles: List(PseudoStyle),
) -> Style(media, PseudoSelector) {
  PseudoSelector(string.append(":nth-of-type", selector), styles)
}

pub fn nth_last_of_type(
  selector: String,
  styles: List(PseudoStyle),
) -> Style(media, PseudoSelector) {
  PseudoSelector(string.append(":nth-last-of-type", selector), styles)
}

pub fn first_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":first-child", styles)
}

pub fn last_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":last-child", styles)
}

pub fn only_child(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":only-child", styles)
}

pub fn first_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":first-of-type", styles)
}

pub fn last_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":last-of-type", styles)
}

pub fn only_of_type(styles: List(PseudoStyle)) -> Style(media, PseudoSelector) {
  PseudoSelector(":only-of-type", styles)
}

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

pub fn important(style: Style(media, pseudo)) {
  case style {
    Property(key, value, _) -> Property(key, value, True)
    any -> any
  }
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
