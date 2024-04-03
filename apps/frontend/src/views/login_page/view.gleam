import gleam/bool
import gleam/string
import lustre/attribute
import lustre/event
import lustre/element
import lustre/element/html
import styled
import views/login_page/styles
import types.{Authenticate, SubmitEmailPassword, UpdateEmail, UpdatePassword}

fn input(label: String, value: String, type_: String, msg: fn(String) -> msg) {
  html.input([
    styles.inputs(),
    attribute.value(value),
    attribute.type_(type_),
    attribute.placeholder(label),
    event.on_input(msg),
  ])
}

fn select_submit_colors(active: Bool) {
  case active {
    True -> #("var(--orange)", "var(--white)")
    False -> #("var(--disabled)", "var(--text-disabled)")
  }
}

fn submit(value value: String, type_ type_: String, active active: Bool) {
  let id = bool.to_string(active) <> "-submit"
  let #(bg, txt) = select_submit_colors(active)
  html.input([
    styles.submit(),
    attribute.value(value),
    attribute.type_(type_),
    styled.style(id, [styled.background(bg), styled.color(txt)])
      |> styled.to_lustre(),
  ])
}

fn credentials_inputs(email: String, password: String) {
  let active = string.length(email) > 3 && string.length(password) > 6
  html.form([styles.login_form(), event.on_submit(SubmitEmailPassword)], [
    html.div([styles.wrapper()], [
      html.h1([styles.main_title()], [html.text("Hello again!")]),
      html.h2([styles.sub_title()], [
        html.text("Welcome back, you’ve been missed!"),
      ]),
    ]),
    html.div([styles.wrapper()], [
      input("Enter email", email, "email", UpdateEmail),
      input("Password", password, "password", UpdatePassword),
      html.div([styles.create_account()], [
        html.text("Not a member? "),
        html.a([styles.create_account_link()], [html.text("Create an account")]),
      ]),
    ]),
    html.div([styles.wrapper()], [
      submit(value: "Submit", type_: "submit", active: active),
    ]),
  ])
}

pub fn login_page(email: String, password: String) {
  html.div([styles.login_page()], [
    credentials_inputs(email, password),
    html.div([styles.decoration()], [
      html.img([attribute.src("/images/sign-in.svg")]),
    ]),
  ])
  |> element.map(Authenticate)
}
