import views/layout.{main_layout}
import lustre
import lustre/effect
import lustre/update
import toaster
import toaster/options
import types

pub fn main() {
  let assert Ok(_) =
    options.default()
    |> options.timeout(5000)
    |> toaster.setup()

  let assert Ok(_) =
    fn(_) { #(types.init(), effect.none()) }
    |> lustre.application(update, main_layout)
    |> lustre.start("#app", Nil)
}

fn update(model, msg) {
  case msg {
    types.NoOp -> update.none(model)
    types.PerformEffect(effect) -> #(model, effect)
    types.Authenticate(authenticate) ->
      case authenticate {
        types.SubmitEmailPassword -> update.none(model)
        types.UpdateEmail(email) ->
          model
          |> types.update_email(email)
          |> update.none()
        types.UpdatePassword(password) ->
          model
          |> types.update_password(password)
          |> update.none()
      }
  }
}
