import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/function
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option}
import gleam/result

pub opaque type Auth

pub type AuthError {
  Decoding(List(DecodeError))
  FromFirebase(String)
}

pub opaque type Credentials {
  Credentials(
    access_token: String,
    display_name: Option(String),
    email: String,
    provider_id: String,
    tenant_id: Option(String),
    uid: String,
    refresh_token: String,
  )
}

@external(javascript, "../frontend_ffi.mjs", "auth")
pub fn get_auth() -> Auth

@external(javascript, "../frontend_ffi.mjs", "createUserWithEmailAndPassword")
pub fn create_user_with_email_and_password_(
  auth: Auth,
  email: String,
  password: String,
) -> Promise(Dynamic)

@external(javascript, "../frontend_ffi.mjs", "signInWithEmailAndPassword")
fn sign_in_with_email_and_password_(
  auth: Auth,
  email: String,
  password: String,
) -> Promise(Dynamic)

fn decode_user_credentials(content: Dynamic) {
  dynamic.decode7(
    Credentials,
    dynamic.field("accessToken", dynamic.string),
    dynamic.field("displayName", dynamic.optional(dynamic.string)),
    dynamic.field("email", dynamic.string),
    dynamic.field("providerId", dynamic.string),
    dynamic.field("tenantId", dynamic.optional(dynamic.string)),
    dynamic.field("uid", dynamic.string),
    dynamic.field("refreshToken", dynamic.string),
  )
  |> dynamic.field("user", _)
  |> function.apply1(content)
  |> result.map_error(Decoding)
}

pub fn create_user_with_email_and_password(
  auth: Auth,
  email: String,
  password: String,
) -> Promise(Result(Credentials, AuthError)) {
  create_user_with_email_and_password_(auth, email, password)
  |> promise.map(fn(content) { decode_user_credentials(content) })
  |> promise.rescue(fn(error) {
    dynamic.field("code", dynamic.string)(error)
    |> result.map_error(fn(error) { Decoding(error) })
    |> result.then(fn(error) { Error(FromFirebase(error)) })
  })
}

pub fn sign_in_with_email_and_password(
  auth: Auth,
  email: String,
  password: String,
) -> Promise(Result(Credentials, AuthError)) {
  sign_in_with_email_and_password_(auth, email, password)
  |> promise.map(fn(content) { decode_user_credentials(content) })
  |> promise.rescue(fn(error) {
    dynamic.field("code", dynamic.string)(error)
    |> result.map_error(fn(error) { Decoding(error) })
    |> result.then(fn(error) { Error(FromFirebase(error)) })
  })
}
