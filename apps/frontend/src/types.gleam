import firebase/auth.{type Credentials}
import lustre/effect.{type Effect}

pub type Model {
  Disconnected(email: String, password: String)
  Connected(user: Credentials)
}

pub fn init() {
  Disconnected(email: "", password: "")
}

pub fn update_email(model: Model, email: String) {
  case model {
    Disconnected(_, password) -> Disconnected(email, password)
    _ -> model
  }
}

pub fn update_password(model: Model, password: String) {
  case model {
    Disconnected(email, _) -> Disconnected(email, password)
    _ -> model
  }
}

pub type Authenticate {
  SubmitEmailPassword
  UpdateEmail(String)
  UpdatePassword(String)
}

pub type Msg {
  NoOp
  PerformEffect(Effect(Msg))
  Authenticate(Authenticate)
}
