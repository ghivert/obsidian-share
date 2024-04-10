import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/option.{type Option}
import gleam/pair
import gleam/result
import lustre/effect.{type Effect}
import tardis/data/msg.{type Msg}
import tardis/data/step.{type Step}

pub type Debuggers =
  List(#(String, Debugger))

pub type Debugger {
  Debugger(
    count: Int,
    steps: List(Step),
    dispatcher: fn(Dynamic) -> Effect(Msg),
    selected_step: Option(String),
  )
}

pub fn init(dispatcher) {
  Debugger(1, steps: [], dispatcher: dispatcher, selected_step: option.None)
}

pub fn replace(
  debuggers: Debuggers,
  debugger_: String,
  mapper: fn(Debugger) -> Debugger,
) -> Debuggers {
  debuggers
  |> list.find(fn(item) { pair.first(item) == debugger_ })
  |> result.map(fn(d) { mapper(pair.second(d)) })
  |> result.map(fn(d) { list.key_set(debuggers, debugger_, d) })
  |> result.unwrap(debuggers)
}

pub fn get(debuggers: Debuggers, debugger_: String) {
  debuggers
  |> list.find(fn(item) { pair.first(item) == debugger_ })
  |> result.map(pair.second)
}

pub fn unselect(debugger_: Debugger) {
  Debugger(..debugger_, selected_step: option.None)
}

pub fn select(debugger_: Debugger, step: Option(String)) {
  Debugger(..debugger_, selected_step: step)
}
