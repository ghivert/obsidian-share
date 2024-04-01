import gleam/list
import birl
import birl/duration.{Duration}
import toaster/ffi
import toaster/model/toast.{type Level, type Toast, Toast}

pub type Model {
  Model(toasts: List(Toast), id: Int)
}

pub fn new() {
  let toasts = []
  let id = 0
  Model(toasts: toasts, id: id)
}

pub fn add(model model: Model, message content: String, level level: Level) {
  let Model(toasts, id) = model
  let new_toasts = [toast.new(id, content, level), ..toasts]
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

pub fn decrease_bottom(model: Model, id: Int) {
  let bottom = ffi.compute_toast_size(id)
  let new_toasts =
    list.map(model.toasts, fn(toast) {
      case toast.displayed, toast.id > id {
        True, True -> Toast(..toast, bottom: toast.bottom - bottom)
        _, _ -> toast
      }
    })
  Model(..model, toasts: new_toasts)
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

pub fn resume(model: Model, id: Int) {
  update_toast(model, id, fn(toast) {
    Toast(..toast, running: True, last_schedule: birl.now())
  })
}

pub fn remove(model: Model, id: Int) {
  let Model(toasts, current_id) = model
  let new_toasts = list.filter(toasts, fn(toast) { toast.id != id })
  Model(new_toasts, current_id)
}
