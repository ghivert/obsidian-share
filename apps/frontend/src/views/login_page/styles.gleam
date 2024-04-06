import sketch
import sketch/size.{percent, px}
import sketch/media

pub fn wrapper() {
  sketch.class([
    sketch.display("flex"),
    sketch.flex_direction("column"),
    sketch.gap(px(12)),
    sketch.text_align("center"),
    sketch.max_width(px(350)),
    sketch.width(percent(100)),
  ])
  |> sketch.to_lustre()
}

pub fn login_form() {
  sketch.class([
    sketch.flex("1"),
    sketch.display("flex"),
    sketch.flex_direction("column"),
    sketch.align_items("center"),
    sketch.justify_content("center"),
    sketch.gap(px(48)),
    sketch.padding(px(24)),
    sketch.border_radius(px(12)),
  ])
  |> sketch.to_lustre()
}

pub fn decoration() {
  sketch.class([
    sketch.flex("1"),
    sketch.background("var(--white)"),
    sketch.border_radius(px(50)),
    sketch.margin(px(24)),
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.justify_content("center"),
  ])
  |> sketch.to_lustre()
}

fn default_input() {
  sketch.class([
    sketch.padding(px(18)),
    sketch.border("none"),
    sketch.border_radius(px(12)),
    sketch.width(percent(100)),
    sketch.transition("outline .2s, background .2s, color .2s"),
    sketch.outline("1px solid transparent"),
    sketch.focus([sketch.outline("1px solid var(--border-color)")]),
  ])
}

pub fn inputs() {
  sketch.class([
    sketch.compose(default_input()),
    sketch.background("var(--input-background)"),
    sketch.color("var(--text-color)"),
  ])
  |> sketch.to_lustre()
}

pub fn submit() {
  sketch.class([sketch.compose(default_input()), sketch.outline("none")])
  |> sketch.to_lustre()
}

pub fn login_page() {
  sketch.class([
    sketch.grid_column("1 / 3"),
    sketch.grid_row("1 / 3"),
    sketch.display("flex"),
    sketch.background("rgba(0, 0, 0, 0.31)"),
    sketch.box_shadow("0 4px 30px rgba(0, 0, 0, 0.1)"),
    sketch.property("backdrop-filter", "blur(20px)"),
    sketch.media(media.min_height(px(1600)), [sketch.flex_direction("column")]),
  ])
  |> sketch.to_lustre()
}

pub fn main_title() {
  sketch.class([sketch.font_size(px(24))])
  |> sketch.to_lustre()
}

pub fn sub_title() {
  sketch.class([
    sketch.font_size(px(16)),
    sketch.color("var(--text-grey-color)"),
    sketch.font_weight("normal"),
  ])
  |> sketch.to_lustre()
}

pub fn continue() {
  sketch.class([
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.gap(px(18)),
  ])
  |> sketch.to_lustre()
}

pub fn create_account() {
  sketch.class([
    sketch.color("var(--text-grey-color)"),
    sketch.font_size(px(12)),
    sketch.text_align("right"),
  ])
  |> sketch.to_lustre()
}

pub fn create_account_link() {
  sketch.class([
    sketch.color("var(--link)"),
    sketch.text_decoration("underline"),
  ])
  |> sketch.to_lustre()
}
