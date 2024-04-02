import firebase/auth
import lustre/effect/extra as effect_extra

pub fn create_user_with_email_and_password(email: String, password: String) {
  auth.get_auth()
  |> auth.create_user_with_email_and_password(email, password)
  |> effect_extra.from_promise()
}

pub fn sign_in_with_email_and_password(email: String, password: String) {
  auth.get_auth()
  |> auth.sign_in_with_email_and_password(email, password)
  |> effect_extra.from_promise()
}
