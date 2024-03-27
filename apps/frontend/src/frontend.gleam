import gleam/dynamic
import gleam/function
import lustre
import lustre/effect
import lustre_http as http
import layout/main.{main_layout}
import types
import toaster

pub fn main() {
  let assert Ok(_) = toaster.setup()
  let assert Ok(_) =
    fn(_) { #(types.init(), effect.none()) }
    |> lustre.application(update, main_layout)
    |> lustre.start("#app", Nil)
}

fn get_challenge() {
  let url = "http://localhost:3000/webauthn"
  let decoder = dynamic.field("challenge", of: dynamic.string)
  http.get(url, http.expect_json(decoder, function.identity))
  |> effect.map(fn(content) {
    case content {
      Ok(challenge) -> types.WebAuthnMsg(challenge)
      Error(_err) -> types.NoOp
    }
  })
}

fn update(model, msg) {
  case msg {
    types.NoOp -> #(model, effect.none())
    types.PerformEffect(eff) -> #(model, eff)
    types.WebAuthnMsg(_chall) -> #(model, effect.none())
  }
}
