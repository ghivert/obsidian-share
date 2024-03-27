import lustre/effect.{type Effect}

pub fn map_first(tuple: #(a, b), mapper: fn(a) -> c) {
  let #(fst, snd) = tuple
  let new_fst = mapper(fst)
  #(new_fst, snd)
}

pub fn map_second(tuple: #(a, b), mapper: fn(b) -> c) {
  let #(fst, snd) = tuple
  let new_snd = mapper(snd)
  #(fst, new_snd)
}

pub fn none(model: model) {
  #(model, effect.none())
}

pub fn add_effect(tuple: #(model, Effect(msg)), effect: Effect(msg)) {
  let #(model, fst_effect) = tuple
  #(model, effect.batch([fst_effect, effect]))
}
