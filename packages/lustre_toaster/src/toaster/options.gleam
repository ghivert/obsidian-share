import gleam/option.{type Option, None, Some}
import lustre/effect.{type Effect}
import toaster/model/model.{type Model}
import toaster/types.{type Msg}

pub type Options {
  Options(
    timeout: Int,
    debug: Option(
      fn(fn(Model, Msg) -> #(Model, Effect(Msg))) ->
        fn(Model, Msg) -> #(Model, Effect(Msg)),
    ),
  )
}

pub fn default() -> Options {
  Options(timeout: 5000, debug: None)
}

pub fn debug(options, debug) {
  Options(..options, debug: Some(debug))
}

pub fn timeout(options: Options, timeout: Int) -> Options {
  Options(..options, timeout: timeout)
}
