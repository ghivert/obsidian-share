import gleam/dynamic.{type Decoder}
import gleam/list

pub fn at(fields: List(a), decoder: Decoder(t)) -> Decoder(t) {
  use current_decoder, field <- list.fold_right(fields, decoder)
  dynamic.field(field, current_decoder)
}
