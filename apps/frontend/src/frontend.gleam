import firebase/lustre/auth
import gleam/io
import layout/main.{main_layout}
import lustre
import lustre/effect
import lustre/update
import toaster
import toaster/options
import types

fn authenticate(username: String, password: String) {
  auth.sign_in_with_email_and_password(username, password)
  |> effect.map(types.Authenticate)
}

pub fn main() {
  let username = "guillaume@example.com"
  let password = "testtesttes"

  let assert Ok(_) =
    options.default()
    |> options.timeout(5000)
    |> toaster.setup()

  let assert Ok(_) =
    fn(_) { #(types.init(), authenticate(username, password)) }
    |> lustre.application(update, main_layout)
    |> lustre.start("#app", Nil)
}

fn update(model, msg) {
  case msg {
    types.NoOp -> update.none(model)
    types.PerformEffect(eff) -> #(model, eff)
    types.WebAuthnMsg(_chall) -> update.none(model)
    types.Authenticate(credentials) -> {
      io.debug(credentials)
      update.none(model)
    }
  }
}
