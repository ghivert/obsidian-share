import gleam/list

pub type Toast {
  Toast(id: Int, content: String, displayed: Bool)
}

pub type Model {
  Model(toasts: List(Toast), id: Int)
}

pub fn empty() {
  let toasts = []
  let id = 0
  Model(toasts: toasts, id: id)
}

pub fn add(model model: Model, message content: String) {
  let Model(toasts, id) = model
  let new_toasts = [Toast(id, content, False), ..toasts]
  let new_id = id + 1
  Model(toasts: new_toasts, id: new_id)
}

pub fn show(model: Model, id: Int) {
  let Model(toasts, current_id) = model
  let new_toasts =
    list.map(toasts, fn(toast) {
      let Toast(tid, content, _) = toast
      case id == tid {
        True -> Toast(tid, content, True)
        False -> toast
      }
    })
  Model(new_toasts, current_id)
}

pub fn hide(model: Model, id: Int) {
  let Model(toasts, current_id) = model
  let new_toasts =
    list.map(toasts, fn(toast) {
      let Toast(tid, content, _) = toast
      case id == tid {
        True -> Toast(tid, content, False)
        False -> toast
      }
    })
  Model(new_toasts, current_id)
}

pub fn remove(model: Model, id: Int) {
  let Model(toasts, current_id) = model
  let new_toasts = list.filter(toasts, fn(toast) { toast.id != id })
  Model(new_toasts, current_id)
}
