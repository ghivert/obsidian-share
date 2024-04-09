import gleam/dynamic
import views/layout.{main_layout}
import lustre
import lustre/effect
import lustre/update
import sketch
import sketch/options as sketch_options
import toaster
import toaster/options
import tardis
import types

pub fn main() {
  let assert Ok(config) = tardis.setup()
  let #(app_config, app_update_middleware) = config("app")
  let #(toaster_config, toaster_update_middleware) = config("toaster")

  let assert Ok(toaster_dispatch) =
    options.default()
    |> options.timeout(5000)
    |> toaster.setup()

  let assert Ok(render) =
    sketch_options.document()
    |> sketch.lustre_setup()

  let assert Ok(app_dispatch) =
    fn(_) { #(types.init(), effect.none()) }
    |> lustre.application(app_update_middleware(update), render(main_layout))
    |> lustre.start("#app", Nil)

  app_config(dynamic.from(app_dispatch))
  toaster_config(dynamic.from(toaster_dispatch))
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
