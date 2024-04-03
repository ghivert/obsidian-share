import styled
import styled/size.{percent, px}
import styled/media

pub fn wrapper() {
  styled.class([
    styled.display("flex"),
    styled.flex_direction("column"),
    styled.gap(px(12)),
    styled.text_align("center"),
    styled.max_width(px(350)),
    styled.width(percent(100)),
  ])
  |> styled.to_lustre()
}

pub fn login_form() {
  styled.class([
    styled.flex("1"),
    styled.display("flex"),
    styled.flex_direction("column"),
    styled.align_items("center"),
    styled.justify_content("center"),
    styled.gap(px(48)),
    styled.padding(px(24)),
    styled.border_radius(px(12)),
  ])
  |> styled.to_lustre()
}

pub fn decoration() {
  styled.class([
    styled.flex("1"),
    styled.background("var(--white)"),
    styled.border_radius(px(50)),
    styled.margin(px(24)),
    styled.display("flex"),
    styled.align_items("center"),
    styled.justify_content("center"),
  ])
  |> styled.to_lustre()
}

fn default_input() {
  styled.class([
    styled.padding(px(18)),
    styled.border("none"),
    styled.border_radius(px(12)),
    styled.width(percent(100)),
    styled.transition("outline .2s, background .2s, color .2s"),
    styled.outline("1px solid transparent"),
    styled.focus([styled.outline("1px solid var(--border-color)")]),
  ])
}

pub fn inputs() {
  styled.class([
    styled.compose(default_input()),
    styled.background("var(--input-background)"),
    styled.color("var(--text-color)"),
  ])
  |> styled.to_lustre()
}

pub fn submit() {
  styled.class([styled.compose(default_input()), styled.outline("none")])
  |> styled.to_lustre()
}

pub fn login_page() {
  styled.class([
    styled.grid_column("1 / 3"),
    styled.grid_row("1 / 3"),
    styled.display("flex"),
    styled.background("rgba(0, 0, 0, 0.31)"),
    styled.box_shadow("0 4px 30px rgba(0, 0, 0, 0.1)"),
    styled.property("backdrop-filter", "blur(20px)"),
    styled.media(media.min_height(px(1600)), [styled.flex_direction("column")]),
  ])
  |> styled.to_lustre()
}

pub fn main_title() {
  styled.class([styled.font_size(px(24))])
  |> styled.to_lustre()
}

pub fn sub_title() {
  styled.class([
    styled.font_size(px(16)),
    styled.color("var(--text-grey-color)"),
    styled.font_weight("normal"),
  ])
  |> styled.to_lustre()
}

pub fn continue() {
  styled.class([
    styled.display("flex"),
    styled.align_items("center"),
    styled.gap(px(18)),
  ])
  |> styled.to_lustre()
}

pub fn create_account() {
  styled.class([
    styled.color("var(--text-grey-color)"),
    styled.font_size(px(12)),
    styled.text_align("right"),
  ])
  |> styled.to_lustre()
}

pub fn create_account_link() {
  styled.class([
    styled.color("var(--link)"),
    styled.text_decoration("underline"),
  ])
  |> styled.to_lustre()
}
