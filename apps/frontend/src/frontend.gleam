import views/layout.{main_layout}
import lustre
import lustre/effect
import lustre/update
import sketch
import sketch/options as sketch_options
import toaster
import toaster/lustre/toast
import toaster/options
import tardis
import types

pub fn main() {
  let assert Ok(debugger_) = tardis.setup()
  let main = tardis.application(debugger_, "main")

  let assert Ok(_) =
    options.default()
    |> options.timeout(5000)
    |> options.debug(debugger_)
    |> toaster.setup()

  let assert Ok(render) =
    sketch_options.document()
    |> sketch.lustre_setup()

  let assert Ok(_) =
    fn(_) { #(types.init(), effect.none()) }
    |> lustre.application(update, render(main_layout))
    |> tardis.wrap(main)
    |> lustre.start("#app", Nil)
    |> tardis.activate(main)
}

fn update(model, msg) {
  case msg {
    types.NoOp -> update.none(model)
    types.PerformEffect(effect) -> #(model, effect)
    types.Authenticate(authenticate) ->
      case authenticate {
        types.SubmitEmailPassword ->
          update.none(model)
          |> update.add_effect(toast.success("Coucou"))
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
