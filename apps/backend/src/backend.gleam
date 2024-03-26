import router
import gleam/erlang/os
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response
import gleam/io
import mist.{type Connection}
import radiate

fn print_radiate_update(_state: state, path: String) {
  io.println("Change in " <> path <> ", reloading")
}

fn handler(request: Request(Connection)) {
  let cors_methods = "POST,GET,PUT,PATCH,DELETE"
  let cors_hosts = "http://localhost:5173"
  request
  |> router.handle_request()
  |> response.set_header("Access-Control-Allow-Method", cors_methods)
  |> response.set_header("Access-Control-Allow-Origin", cors_hosts)
  |> response.set_header("Content-Type", "application/json")
}

fn run_radiate() {
  case os.get_env("GLEAM_ENV") {
    Ok("development") -> {
      let assert Ok(_) =
        radiate.new()
        |> radiate.add_dir(".")
        |> radiate.on_reload(print_radiate_update)
        |> radiate.start()
      io.println("Watching src to change.")
      Nil
    }
    _ -> Nil
  }
}

pub fn main() {
  let _ = run_radiate()

  let assert Ok(_) =
    handler
    |> mist.new()
    |> mist.port(3000)
    |> mist.start_http()

  process.sleep_forever()
}
