import gleam/io
import gleam/list
import birl
import birl/duration.{Duration}

pub type Toast {
  Toast(
    id: Int,
    content: String,
    displayed: Bool,
    running: Bool,
    remaining: Int,
    last_schedule: birl.Time,
    iteration: Int,
  )
}

pub type Model {
  Model(toasts: List(Toast), id: Int)
}

pub fn empty() {
  let toasts = []
  let id = 0
  Model(toasts: toasts, id: id)
}

fn new_toast(id: Int, content: String) {
  Toast(
    id: id,
    content: content,
    displayed: False,
    running: False,
    remaining: 5000,
    last_schedule: birl.now(),
    iteration: 0,
  )
}

pub fn add(model model: Model, message content: String) {
  let Model(toasts, id) = model
  let new_toasts = [new_toast(id, content), ..toasts]
  let new_id = id + 1
  Model(toasts: new_toasts, id: new_id)
}

fn update_toast(model: Model, id: Int, updater: fn(Toast) -> Toast) {
  let Model(toasts, current_id) = model
  let new_toasts =
    list.map(toasts, fn(toast) {
      case id == toast.id {
        True -> updater(toast)
        False -> toast
      }
    })
  Model(new_toasts, current_id)
}

pub fn show(model: Model, id: Int) {
  update_toast(model, id, fn(toast) {
    Toast(..toast, displayed: True, running: True, last_schedule: birl.now())
  })
}

pub fn hide(model: Model, id: Int) {
  update_toast(model, id, fn(toast) { Toast(..toast, displayed: False) })
}

pub fn stop(model: Model, id: Int) {
  update_toast(model, id, fn(toast) {
    let Duration(elapsed_time) =
      birl.difference(birl.now(), toast.last_schedule)
    let remaining = toast.remaining - elapsed_time / 1000
    let i = toast.iteration + 1
    Toast(..toast, running: False, remaining: remaining, iteration: i)
  })
}

pub fn run(model: Model, id: Int) {
  update_toast(model, id, fn(toast) {
    Toast(..toast, running: True, last_schedule: birl.now())
  })
}

pub fn remove(model: Model, id: Int) {
  let Model(toasts, current_id) = model
  let new_toasts = list.filter(toasts, fn(toast) { toast.id != id })
  Model(new_toasts, current_id)
}
