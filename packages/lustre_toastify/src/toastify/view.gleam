import gleam/list
import lustre/element/html
import styled
import styled/size.{percent, px}
import toastify/model.{type Model, type Toast, Model}

pub fn view(model: Model) {
  let Model(toasts, _) = model
  let toasts = list.map(toasts, fn(toast) { view_toast(toast) })
  html.div([], toasts)
}

fn view_toast(toast: Toast) {
  let move = styled.to_lustre(display_move(toast.displayed))
  let base = styled.to_lustre(display_styles())
  html.div([base, move], [html.text(toast.content)])
}

fn display_styles() {
  styled.class([
    styled.position("fixed"),
    styled.bottom(px(0)),
    styled.right(px(0)),
    styled.padding_("9px 12px"),
    styled.margin(px(12)),
    styled.background("var(--green)"),
    styled.color("black"),
    styled.border_radius("5px"),
    styled.transition("right 1s"),
  ])
  |> styled.memo()
}

fn display_move(displayed: Bool) {
  case displayed {
    True -> styled.class([])
    False -> styled.class([styled.right(percent(-100))])
  }
}
