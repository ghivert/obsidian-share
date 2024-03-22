import gleam/bytes_builder
import gleam/erlang/process
// import gleam/io
// import gleam/int
// import gleam/list
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/http/response.{type Response}
// import gleam/string
import gleam/json
import mist.{type Connection, type ResponseData}
import webauthn

const cors_methods = "POST,GET,PUT,PATCH,DELETE"

const cors_hosts = "http://localhost:5173"

fn empty_response(code: Int) {
  let empty_body = mist.Bytes(bytes_builder.new())
  response.set_body(response.new(code), empty_body)
}

pub fn main() {
  let assert Ok(_) =
    handle_request
    |> mist.new()
    |> mist.port(3000)
    |> mist.start_http()
  process.sleep_forever()
}

fn handle_request(req: Request(Connection)) -> Response(ResponseData) {
  case req.method {
    http.Get -> handle_http_request(req)
    http.Options -> empty_response(200)
    _ -> empty_response(404)
  }
  |> response.set_header("Access-Control-Allow-Method", cors_methods)
  |> response.set_header("Access-Control-Allow-Origin", cors_hosts)
  |> response.set_header("Content-Type", "application/json")
}

fn handle_http_request(req: Request(Connection)) -> Response(ResponseData) {
  case request.path_segments(req) {
    ["webauthn"] -> send_challenge()
    _ -> empty_response(404)
  }
}

fn send_challenge() {
  let challenge = webauthn.challenge()
  let body =
    json.object([#("challenge", json.string(challenge))])
    |> json.to_string_builder()
    |> bytes_builder.from_string_builder()
    |> mist.Bytes()
  response.new(200)
  |> response.set_body(body)
}
