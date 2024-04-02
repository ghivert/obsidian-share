import lustre/effect
import toaster/toast

fn dispatch(content: String, toaster: fn(String) -> Nil) {
  use _dispatch <- effect.from()
  toaster(content)
}

pub fn info(content: String) {
  dispatch(content, toast.info)
}

pub fn success(content: String) {
  dispatch(content, toast.success)
}

pub fn toast(content: String) {
  dispatch(content, toast.toast)
}

pub fn error(content: String) {
  dispatch(content, toast.error)
}

pub fn warning(content: String) {
  dispatch(content, toast.warning)
}
