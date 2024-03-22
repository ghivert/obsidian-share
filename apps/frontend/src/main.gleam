import gleam/dynamic
import lustre
import lustre/event
import lustre/effect
import lustre/element/html
import lustre_http as http
import layout
import layout/justify
import content/text
// import styled/media
// import styled/size.{px}
import styled
import styles

pub type Model {
  None
  WebAuthn(challenge: String)
}

pub type WebAuthnAction {
  GetChallenge
  GotChallenge(Result(String, http.HttpError))
}

pub type Msg {
  WebAuthnMsg(WebAuthnAction)
}

pub fn main() {
  let init = fn(_) { #(None, effect.none()) }
  let app = lustre.application(init, update, view)
  lustre.start(app, "#app", Nil)
}

fn get_challenge() {
  let url = "http://localhost:3000/webauthn"
  let mapper = fn(value) { WebAuthnMsg(GotChallenge(value)) }
  let decoder = dynamic.field("challenge", of: dynamic.string)
  http.get(url, http.expect_json(decoder, mapper))
}

fn update(model, msg) {
  case msg {
    WebAuthnMsg(GetChallenge) -> #(model, get_challenge())
    WebAuthnMsg(GotChallenge(Ok(chall))) -> #(WebAuthn(chall), effect.none())
    WebAuthnMsg(GotChallenge(_error)) -> #(None, effect.none())
  }
}

fn view(model) {
  html.div([styled.to_lustre(styles.display())], [
    layout.column([], [html.text(text.please_auth)]),
    layout.row([layout.justify(justify.End)], [
      html.button([event.on_click(WebAuthnMsg(GetChallenge))], [
        case model {
          WebAuthn(challenge) -> html.text(challenge)
          _ -> html.text("Authenticate")
        },
      ]),
    ]),
  ])
}
