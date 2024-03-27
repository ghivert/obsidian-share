import lustre/effect
import toaster/toast

pub fn info(content: String) {
  effect.from(fn(_dispatch) { toast.info(content) })
}
