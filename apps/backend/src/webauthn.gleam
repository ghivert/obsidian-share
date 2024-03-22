import gleam/int
import gleam/list
import gleam/string

const random_alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn challenge() {
  let graphemes = string.to_graphemes(random_alphabet)
  let graphemes_length = string.length(random_alphabet)
  list.repeat(0, 32)
  |> list.map(fn(_) { int.random(graphemes_length) })
  |> list.filter_map(fn(value) { list.at(graphemes, value) })
  |> string.join("")
}
