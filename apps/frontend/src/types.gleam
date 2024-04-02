import gleam/option.{type Option, None}
import lustre/effect.{type Effect}
import firebase/auth.{type Credentials}

pub type Model {
  Model(web_authn: Option(String))
}

pub fn init() {
  Model(web_authn: None)
}

pub type Msg {
  NoOp
  PerformEffect(Effect(Msg))
  WebAuthnMsg(String)
  Authenticate(Result(Credentials, auth.AuthError))
}
